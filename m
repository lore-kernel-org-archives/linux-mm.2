Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5E15CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398756B000C; Tue,  2 Sep 2025 04:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3704A6B000D; Tue,  2 Sep 2025 04:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25F846B0010; Tue,  2 Sep 2025 04:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 152026B000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:11:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3019611A8AC
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:06:34 +0000 (UTC)
X-FDA: 83843578308.19.9828531
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id DF5B34000A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:06:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a6F1+WtY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IpJ7H8N7FFsIL+sZVKXca+TmDGWYx1b6cFxz+BZpneM=;
	b=P8A+QxD+MSALhVcI+uSsM7KSttgHSSkZBg68vsMnfw1XogqWbLGsPke3nwR5tUsYvHhPp9
	2yLQjzHM1r2CbHSrG2d7iL3JLRuxtt9Y7tf9LEpW0o2PxXKasGCqifNoX2OtoOZkJO/xTM
	UwQEtYIe4CABlr9kFIbn73/Yu6/YwjE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a6F1+WtY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756800392; a=rsa-sha256;
	cv=none;
	b=DszkG2B4PF1G6dh+2wHc2Nmb7h9wbcMd5OnFNlqXtdY3sftvv2PB6p2yr8OBDQ/AKReBLG
	Xx5TroqqSfPYVo7QecCE9YY7hIIfv9fHsPO1cBkFhlpOVQlPPLF8aLX09D1aiCdA5PT4Tj
	rY57IR8U3UNVwl7TqJhCev0AAEJF+TU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756800391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IpJ7H8N7FFsIL+sZVKXca+TmDGWYx1b6cFxz+BZpneM=;
	b=a6F1+WtYkFr72LliXr+eYiW3ttqeBls6QMSEj2lWk0YcEHGUEmBvwpZ5FceOIf/dJdg9fY
	SV09sH72fD6a+zJFrLa8vxKmlrpRCEHZjlMNp1m5b++2c0roQgwcapmbeNM+Ae5LjGVXfb
	XJ6pRjdwf6XmXFG92YVU25GljuAmIAY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-7wx1Zyg4MseV1IC7zmBs2Q-1; Tue, 02 Sep 2025 04:06:30 -0400
X-MC-Unique: 7wx1Zyg4MseV1IC7zmBs2Q-1
X-Mimecast-MFC-AGG-ID: 7wx1Zyg4MseV1IC7zmBs2Q_1756800389
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ce059e3d42so3060352f8f.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756800389; x=1757405189;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IpJ7H8N7FFsIL+sZVKXca+TmDGWYx1b6cFxz+BZpneM=;
        b=X8//ymnrd/CXRNz3aQ2sIFqwoNcucjEn9hcBBIhHLGVCeeCdj+41iPkq3GutCwHmNW
         zEf4Bt3CgFKqf8Q7aEZo8mk6T05XfTY7/1pHHNYdQ+4+yz4Oni2GKDV9+u8M+nLquH74
         HsubIzceIqljN55JkOaOtiBMtb/udtc+1yXcq2aqBy64QJdaMJbFy9nldZgwHi1Tm5He
         lBnpztD5PqrmO7wHSiLPDsxkkKIt160uvhIZ1gT2zIo8G3cxCnom0YQ4KnK7ukMQ69go
         XgHtIkgVynXRLmhuq/7ERkGkgMW27Rg40EM/xbiJholzngJGZHNJyLNRFN8PEDxUmT7f
         t7RA==
X-Forwarded-Encrypted: i=1; AJvYcCVU6I1ByFVBNVlm46I7czI97XEShWsX54ZKUWkg/qe28S+d8DK7xeiTEwHcA8lWxRJb2uN8+gYuaQ==@kvack.org
X-Gm-Message-State: AOJu0Yx3otJwDh4wurhpBw5W86ETn9Xxp+L+/2F4DoNswcWbUrjIT3DN
	JHu6I4F3cDAFdGhZYeKWd2ZGFttHpoKWzJw9J3T0LVjuT3FiBuk3XH8ZEhplr77ABr/j+ihS6mC
	36Ou7CFUsTkXgCrbmMPAqIuVr/J6uDrIBQCDz7QmfbgDeciOngzvO
X-Gm-Gg: ASbGncui0rhOaSvC+LpNwzKJSC0g5QIrHVDvTXVnF53BJ7ZenuwA6wGaUgxjHbo/ubE
	uSVtOZvtrK7MEsvRNfU9OfAraOpqPBbv6rpc+hVJhb4CzQTregSepUQG5W6symdW9jDymPr/55V
	U2+3L4ylfqcz5gPqwJm0jecWNYHOa4bSMuVW6uYKRquK0WNHTfvd9A1GSloBM3FYpR3w8+YtEHr
	ljp/Z5z/p7pFJLCceBLJ1o9lnlsSdLsxibq7byfG2oEz4xNqxBbjxrKiMDHl6YQz4EMwsq43Rp3
	2ac5+tTk+fu+qhz3AXjURVPC5u8NDo39WQO8mxt/YipJ0suGDynOGi0jHXn3rxvz3uNjftVT+qo
	56kBKm73qf7vIxkj5xbGmnwF+0nXWdjJNZLnnhvBdlqqi38XQh85/BhJNk2W8spthIE0=
X-Received: by 2002:adf:b303:0:b0:3d2:82d:7da0 with SMTP id ffacd0b85a97d-3d2082d8289mr5428495f8f.43.1756800388651;
        Tue, 02 Sep 2025 01:06:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTerYgExLKpnch27eawnPrT4O2stkgHXpcDmb8FTUCEqRSxftMR8giHgH9SA0676g8Q5jadw==
X-Received: by 2002:adf:b303:0:b0:3d2:82d:7da0 with SMTP id ffacd0b85a97d-3d2082d8289mr5428419f8f.43.1756800388024;
        Tue, 02 Sep 2025 01:06:28 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d690f2edf1sm7891634f8f.16.2025.09.02.01.06.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:06:27 -0700 (PDT)
Message-ID: <ea4adc86-abf9-4ab8-999a-eb4c7bad4cd3@redhat.com>
Date: Tue, 2 Sep 2025 10:06:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/12] mm: constify assert/test functions in mm.h
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@HansenPartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
 <20250901205021.3573313-12-max.kellermann@ionos.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901205021.3573313-12-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kplDzCKyTHIzfACGc9KgvwoqiUQ-BsiQhWR-Mqk-oKM_1756800389
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DF5B34000A
X-Stat-Signature: 7rswf9awx8gadeuufr33kfcoffzt5y47
X-Rspam-User: 
X-HE-Tag: 1756800391-528880
X-HE-Meta: U2FsdGVkX1/52j2E/XSYIsDYEw5OlYCTgO8l3Rph22AVZHzIcq3NKOeoOw/cSXaOSG1fsG2z9fGFrl1e+u12TcQOwB8utcqZ3fvVJAf1CNxCmTfPol4xOyLHlwdvtzzugc9BJtojczh05XUy9nSv8SqNhNcWxe/weLnfoOVEgZv7JX/9p6O9uwFkcac1BaVl9FqB9+IgpW6k/y1mLlbYU1P9Xb6sJtEGVVChRmbmo/HpdF/xTaQbRioK032+wu6y6BhUQXnFYz9Jtpyr3+Gj0GfJCWH81e0rPWrFPdeJSqu7S9h4HOZp3oBxYZr/Dhm89PlelTyK56ctcxZP/bADVyMzuLe3XPpQvBp+71gAJxq0IiDbriUmjWo8ch9fgvfUqam4gOFHDuE425w+T8EcJheFeHPZiL1yh6OebS3INAq6rZPKUi1hXa/uwWhd5E05zmdRmyy9DKA6tblAhRGOKwxZ89Oy7Iy4oCG5tHnyWIsLOtUvVvNsmiKXWeJ5m6HO5RsWVo2RtiQoc8tfS9qIgiaVZFLSVrQsBs6+9AGu+uyn45S2hlVzzRL/FBOjVACkOhw1uJjol2BC93UHbAoBOYFcvQWCrZOqREUHVppLrNj2asPUAtF87LLACTZWBZlHQ6xsS3qoApxhLM09/8t8mXWddTK7BclsmdF2Y6C9Lw/Q+3xAWKJOXKFHxZuXwbBt3Mg9o7zXEik1bTi1Ds8Vz+PoTJt9y7LGf7DdesRQZaB7ynfw8DFSsFACaYeD3LrGjW83thiL3rYvbFg6uhcjFjuC/qi/PNCpGo/mEDZlnLMzBsHVl1oorFPuJ7EeU1SSyfI99Qhd+4tP/E3je+y3u083QVNK3N7W3Pl2xxLSTB8v6L2iPeh3F1AJ/5lIKjKgwUkDj+0GastlVBRSxmum/AQToqefkQ87HGUvkfXSwJIcA1gFy9ElD4ApRf04MTvqvV1RF8HzIYUOG4dMTNt
 jQV2nFgi
 K17p8F5igP4ZaVbPts4ANqTHRWg0VVpWM8sHMTyjmItJcqPVZthZNersSaPuZCTaBLcrRozSGKyaB4GH6yWW5sAYDvdPtbUGTTevXVgV1RykO/yIaZVpKx/3D3QPWvU1nXRUtUW3HRD2+SNpPg3zkik+GZrMOy6ixV+hgrxVcJ9IKufPhVvLsOVZJ+qmKGmzEdCfvg/ENTlEeZJLND6CGFvoXcropidZaLlqjuUcAk904pAlB+cPDLKzaeX6qBOq13uGS+GX2Owi9Rsu+L/3wR9B+kNY+YhJ2Kr+gMuo2WoVWd4BJzIJsTpsmPBYpOcqiH9PhqZbvS1KSqgTQ8lK5JogJDsBSTdZ8PgdBGgmJk6asicZK11j9GUiqRoTLbeBG9bxO0chuJas6y0rS39ItjRPf4j5l1DBSSuPjxWXmYe4L/6zySGZ9vmUmeZa/oPgplx5Wep3Ef6l2bxAF0z+Ykcr5rG0AEX+CVjkRosVoaSjhvmQXgcW0jWSOkfiKT51Wkn4K7yqtl1+MS2P6hgz94Wfdohd1xGt/tMxS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 22:50, Max Kellermann wrote:
> For improved const-correctness.
> 
> We select certain assert and test functions which either invoke each
> other, functions that are already const-ified, or no further
> functions.
> 
> It is therefore relatively trivial to const-ify them, which
> provides a basis for further const-ification further up the call
> stack.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


