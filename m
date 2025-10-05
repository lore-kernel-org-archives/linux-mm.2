Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60964CAC5B0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Oct 2025 00:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9A18E0003; Sat,  4 Oct 2025 20:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45B458E0002; Sat,  4 Oct 2025 20:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348C48E0003; Sat,  4 Oct 2025 20:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 239528E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 20:04:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55BE085A0E
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 00:04:18 +0000 (UTC)
X-FDA: 83962113396.01.8283054
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 60BF720004
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 00:04:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IPiAmOna;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759622656;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SuazfCg0JUEN6Q1wK7YMCSmIa0jdH/LBDbSMDJSl8bM=;
	b=Z3sldCIf4NqHo2Dvv/4Ao+7Ty4mazVnzIWRToTtcs1rZmOnbQcPW6sztNC5/xvp3AC8p/G
	Cu2Jgxt9G7E1BNtaRgNPR2RTSp2ylvouVwi/TkUnD8S4p5FoA4gKgQItGyUMWF40A6mlsc
	TGJsPceyW84qmKPwHyqcw2lEYqGSksk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759622656; a=rsa-sha256;
	cv=none;
	b=WVDcMRdTJb6zjphHyXpAn1NjsBfZpLEnYEgLR2SGxeAEzPJ/BlvrTZCsCz+Xox2GIFs7jc
	fl2PLR53mtF5CquIeRS8SkrM3M4zIsv3Ss93w3HvdS/5wOU3rkz7jaCsqIfgFcbdierLfY
	plA3z42F7bHpiYZuAWaklj26Vm7ky04=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IPiAmOna;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-63963066fb0so2367355a12.3
        for <linux-mm@kvack.org>; Sat, 04 Oct 2025 17:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759622655; x=1760227455; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SuazfCg0JUEN6Q1wK7YMCSmIa0jdH/LBDbSMDJSl8bM=;
        b=IPiAmOnaTKkDHELf+FX+j5aaYZVK8IDQpO/dNMRuoB5IQ7urcFvfhGvMbjDQqIRHx6
         WF60DAvWeYFY/JsyxhHvxvSCRdlM0mcgBvsvZBwSoGiLrLB8kQfKt/zBi4ud1yIhoIsN
         9QNwrCGPNHBNtCCxmCIdxtNZzN/AiSQ5kYZPgz5l7Eva3WMFtF1Ox8laC8lS+bLiZZKX
         XB9ZFOQevqMNCBB1qfQ+TbaSJdM43aHAqSVtr92sq8tem+3cAQO/5qaFYpL15v5FFP+3
         rFWjiMHy3O8HCymNzXSgRyu9YUY80GJGi1eMKbtkaBDft2lN18X9pahHIXzk1h8HIq1y
         +p6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759622655; x=1760227455;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SuazfCg0JUEN6Q1wK7YMCSmIa0jdH/LBDbSMDJSl8bM=;
        b=UIy2XcbFDUAbqlk2MQeg+P1yx3optL4V2ZPWIhnQcs8E9QcUE0JattEKwtdQ0wqAVi
         5pEHuFv9MK1LKVpjo0NWhZMGKtizViKoXHtWnB+s11BRgsZ2eIkSp6Ru+hUd907gwByh
         XaGzWOE9TvoLOMqkjLZ09cWSHz6vZn4MKndHmfObQ8ks4RwygI4MbxM/nH893ow39xtA
         AquthodxSO2S6WvRBqLcqWnj8EAaX8ftGqMqZTqMiSjQB8HFVzeYk4jkbZ+PQzv71AbB
         Zbe32o9m8xvEfKmYBa3wiPs4CJ1eKrsyLSFFfyvvO8K22+EHvUaHvMxtcwBn8+4XRGX/
         xSEw==
X-Forwarded-Encrypted: i=1; AJvYcCV2Sfi5cNO8h9Or/H0CiUZvnAmI7lLimUAuqQH7vmHH7Pgq478cQtWgZONBTeGCsOQP5+X4aVVbzA==@kvack.org
X-Gm-Message-State: AOJu0YzSvG8mmk9PfFAYLHpCrNBa6h4LZh4BEDyrw3mNwgF8jbdUcfwl
	gqIUwcY8zKGZiShf7lbWsOpCgRiF5+XXQG4iyMDFNlmueEE7cwZQyvkc
X-Gm-Gg: ASbGncspN2xk3CnUlDW1sIP1bDdSKnKxHVTRzHpicxB2twVOMRAgAa6NWGDgfFzWwyW
	6rbUsxFiKHx1cqVjSHDvPTAoanBQrDoL4Rk23wMjc2oec2Sez+OO3Y3vfQd4JvOmsCYmQOukE3/
	C/u0cnA4lITrrUAhYHyqZmWIhRNlsvHnD8jDstZynn688OdNlwM5M/jOO8Hoom99shGcgn6yEyY
	jlSvXNXYE5BDV1wirSaY33q54xnhWJmUCLfl6xO9iVxbaG+d3gKkVjeUvRDnJ96aEaUy+RxPuu+
	NK8tDj9jFZVhonw0O/i0q5B98Z8d9vMSKVEiPF+EiB9AcYr2Q/QHSrR0UbP4axBI6udO9HPXkeg
	rwq/wZToyEBOnVJ7PYgX5yiVQD17rqNoCzutMJly/I3VaevA/1vd7bccn
X-Google-Smtp-Source: AGHT+IExBZMBuqUh5CVS8KHs+bbxVO9mFkhOpIwnUmP6PDbjBSwp7A03wss0RXgBDhl9Y+HcyF8+BQ==
X-Received: by 2002:a05:6402:3582:b0:632:a8c1:f783 with SMTP id 4fb4d7f45d1cf-639346ceb41mr8370417a12.3.1759622654476;
        Sat, 04 Oct 2025 17:04:14 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6376b3abcd7sm6982792a12.2.2025.10.04.17.04.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 Oct 2025 17:04:13 -0700 (PDT)
Date: Sun, 5 Oct 2025 00:04:13 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/khugepaged: use map_anon_folio_pmd() in
 collapse_huge_page()
Message-ID: <20251005000413.ogmobshcbsw34b5v@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251004092523.28989-1-richard.weiyang@gmail.com>
 <96dac3c7-c969-4d4a-afca-85341f8a6a6e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96dac3c7-c969-4d4a-afca-85341f8a6a6e@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: saxfpxkjifpheu5a9dxh5xf5xbw5egds
X-Rspamd-Queue-Id: 60BF720004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759622656-928811
X-HE-Meta: U2FsdGVkX18t+b0HvwPaOwJqvgfyzabxGxKawGjodE3tVeO5W3N2dlbhaBoaOj3VKHBGUHAH32GjDC7KfJiL+qWWLsJ0JczV6eCoMe1lw9UQdglt3ZThj5AzAnfATCDn9NeoKkoIj1DvYW/4X+kXXEGKbAlWpJ0W1k+/tsqMhK7BQtSv1FByBsgq2zCKTiT+7zFBTqxThpjAx4v1uiuBuk9cqfEkCMVfkjvpiPqbF1gQqq3bhisjELWeNYEccFyauuA6tbr6PSrE0GfsAy8Z2Jg9lLoPtH+x4mO7TwR3AWyaRLz6di3CNyX3gbixDYrRETfi0yhEkwKT4SRBqxShv4N8FiusOyOsl2RkHxprsWDtxzxe5httS3f8RlAJFhl0xYY9hfUNUB99ubT7xIbwRJHTjxwJa9774MJleYOXsEJz87FtEvAnb0Mlw8AMyEsPnc+aCWEqC35ip/my5x02KWLWafyq7Ba1+NC+7fYddhy3A04xd6P7JefHrTyxunxPv9GMtGIR2D4gSAg7A7xvpugS69lD7dBf269adrMhGN3TdY2y/9kdKhPtRw5jue1jzPBfjyXJP8JAz5a468VudvaDSZ9qu4uQdIQk/tRkiHSeKf/tUmfgeopZ+hgIjBjAyMXGgtQuKRZ5UBsCp2t7wUgeG/0GxFg2viR9mI4Duk9ewJbrNkWiuK6TQD63E3fyjJymrOjDejWtRDbA/xwdX2hrMIUZm3GZXgRIX51xMcSXmMAaLdRy1RSoN3m8UpojLWm/1hdrLogAEAsfTdNjUBb4p7IaPWwKjSivcEc1a+CvULL84Zs/Qh4GEvkcOMLgC8ONGPYBIIcgRMUaRNp1WMP5GLJs9M2MpJ+rwLnJvW7hbGAS2rz3jrUWMAeSSBXL31DEXnKqfsr5K5lZas0iIzSW+6Cmhxwk4rN8DC0GBOvl4XQiQbEiO0d1LhcELXqQhsJA7kC5l4IqMp4pslH
 BtQ+XKis
 cLTTDsWGgLz+xVk5HzJrxh9roZh8MTJFZM/9dIr3t7dKo7WJW4J0mCkgj1IHcUCDg7h/Guv3a9gOEy3sISe/nvbe52+V/QHq7YZeldARB4SgZw2xcgd8GqeWpgHstkaKFxa60DehTi4oS/3rDisibeVNIEJAIhSjckBi6nfeQTqu1EDh6R7dYvJFyDvUzyIZZNrlTrrELNjKDBr9s4zk8R862hdpztCvcQebVHQwRB24N2ElnCMYkUTmxoQQKedWED8oHgmJnA57H7Ta0jz+9/moNHHGH6RH14l2u849rmEZZViHZO3+d6sTRhkf6VMXG5s+cKpLY/pE0hSdo+uzDSnRROJPjOU+zXJsd8QNABFM1YzSYzZb5fMXdb37ZSRBb8mIB3qkgQ44yjnx7acWSm/6hncnwlCyElH96b/VywvGVB7zDk+VUeQ9pMCXYyXIyFTFdYXFgY0j8h3L3bsv0AjW5k7n9Le+w4fP2xDocvB8xz0OfaEInKxdDOqSi3zeIwY1joeFAg9BmZQ0k2qNiOD7ZlwNBO4Ur86/deLuueKZcgBzaV4VAP1XQ0dqWTunrBbxf1sbA3iUdRfuC+5pxzJjwY0/DlhCRE23JuQFjdYk4XeBzxzLok7qutysgGTQwlJxXphYaAhLi43ewD/UvmgYmtFfSydhGWQPgJgPsQv0BQ+iR2xclxIMKYzfClHpWtx4cVS/KHvZbH0oAFUSd5z+jEgrcoCClzu+fv2xSOdHu9laqDMh5OoAUjDrQ/lrtAXl4iLr+K9gXdJOu6+zXJS5wHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 04, 2025 at 07:56:48PM +0530, Dev Jain wrote:
>
>On 04/10/25 2:55 pm, Wei Yang wrote:
>> Unify the process to install pmd folio.
>> 
>> No functional change is intended.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>
>Base commit on which this patch applies?
>

The base commit is 

696ef26cfef2 2025-10-03 mm: redefine VM_* flag constants with BIT()

on latest akpm/mm-new branch.

-- 
Wei Yang
Help you, Help me

