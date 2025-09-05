Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E03D8CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 22:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5698E0006; Fri,  5 Sep 2025 18:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8C198E0001; Fri,  5 Sep 2025 18:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8CB8E0006; Fri,  5 Sep 2025 18:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD2868E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:40:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3798C8595B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 22:40:30 +0000 (UTC)
X-FDA: 83856667020.02.66C7786
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6522E40009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 22:40:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="O+JMAAC/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757112028; a=rsa-sha256;
	cv=none;
	b=B1pMcakbB4hD6rRl6SXqazECcv00yeyL7wxcCZDtnhEbTc4VQxOjcKUxdZ6lyixQ7fU4sd
	W49r7/ey0I7b3Y4R3eEf6/cJm69MEO46MqpFNC/Z1l6MBW6KaZ0z1Hw3diFVZ3RuChgIBU
	OAyNHR7mL6Gvho1ohe4Gt6xrFeQHgbk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="O+JMAAC/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757112028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qCejKM4XYsS3Mc8jT+/6eMCCnzQlKMfy/kZQZZSu9UA=;
	b=nIC3OiR/ZW2wXnLV8MYXIb5RAH1wvI37J1gl0cIttuKcx4uAEngwk/637I6YDl875WnYlp
	CeDmYiR3XDARkFH0yhbHW7DpmDDL2nonhOPHpBOwLP0rlpWKwt+Sopk48pfKvnS4CzMABT
	uMDkwpp2kNhmW39ZvOK49euR6J63amg=
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-8874def0cf1so124669439f.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 15:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757112027; x=1757716827; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qCejKM4XYsS3Mc8jT+/6eMCCnzQlKMfy/kZQZZSu9UA=;
        b=O+JMAAC/W35BxTamUPEEOla2oWXfIshioZkGXa046BPS17CY8tckQKfzN1mvbnMsjB
         Kp+STYloVCz4dHRQnl2KK/La0KJwF60HnEOtRpj8mxSf3HsPnXbJeQqbAT2UmcUZ2Qnr
         vjgtsBmL5X6XmZjYsFt/UIrX6vEJuVGMM9L78rlN6yxUNybol2NYN4Q/DezLF5eeSoyz
         xuGorcOKowblq5Ony6CCGtpTv79COSNkUWkRtYrvEGxBYvWcjZywe1siKgi4jVZTpa+k
         4lC5S6g+FOs4miPiGzgmi4LTe0FD8s1scUxc72EN87FLY9heCN0nM3vS7gC/QytpCD61
         ufPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757112027; x=1757716827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qCejKM4XYsS3Mc8jT+/6eMCCnzQlKMfy/kZQZZSu9UA=;
        b=wI6/jcBQu0bGRj8sldS+Xc6lexBrZHk9sl4T3JM8MhdEOHLccXg9+6Z9U4yhugBlv9
         QNnqcz6o6tDhW9TG01XtwQz7iar28ILwP0BPfaUUM0OFSYXymFI/xkNToCS+baO8KbdD
         xF/E3bItg/iIzn1VEEnUArQQjBNCPCZRawl+BpFHwOss4/UR+rSVA3UPFJq4huFO8N6Q
         qzyLt6gjOvLGcfjszA1C6xABGURm4Erke2fJqTJO0PCPkNuScmH6nhXGelMLkph9qnpr
         W4yr/lK9O6nynXrKSO+473y0ciVBEijL3FQN2/svfXWYcYORtdHoKVhd+1xMNlSV6x0q
         EcVA==
X-Gm-Message-State: AOJu0YzPghcEPJMxzXEL0iNqfR0Ua6F8F2NAXyn0UcKezd59UGdKapzU
	V1xvBUKbJ5eXWNAEAXw5cRMC1NJXBfrsiRw1Zko6P1ffZa1jJfUdTSRLp5ri0s4qPBw3pz+zI7D
	ns4jR+KqlzDzRGokxIz+NYircQcvVctM=
X-Gm-Gg: ASbGncteCb6bcXa5Yt1+E6JgAT3aOz1K+vZwhwtneSzXy0CZwBkAT66FQnb7s4WM9+J
	n4iEtDij3v39HbPkOZGee0/V5wySJyHpK7yJMxT9R8qXzR7Ch0sT4AbBoq95D0LXMRGpZolNLH1
	HSQ5t8aDbJHtqh+FSNErsaTgYF/vKm+8k+zvdAil7iXiRbVePrtWnDn2Y9epUPbqc8uAsD3JlES
	JWjEAem
X-Google-Smtp-Source: AGHT+IG55bRnjpEXdc2WowZ5rrMS7XLGIAtuFag6uplP7dR8JDmhZUxRNCDeLpq1gfeQR+Z4TeVn2mE+C2ogz8I/qSk=
X-Received: by 2002:a05:6602:3420:b0:887:6d06:3604 with SMTP id
 ca18e2360f4ac-8877768ad3amr76211239f.14.1757112027235; Fri, 05 Sep 2025
 15:40:27 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-4-ryncsn@gmail.com>
In-Reply-To: <20250905191357.78298-4-ryncsn@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 5 Sep 2025 15:40:16 -0700
X-Gm-Features: Ac12FXwf1n-35Lk16KT3TkdmL6NzGPHTW0aRJyCAC7z75wlx6fkzmLWV7yOp5YA
Message-ID: <CAKEwX=Ndtbsy7UoGhwcd+by6bz2gt82o6EPOkiXbqNv=uPb8wg@mail.gmail.com>
Subject: Re: [PATCH v2 03/15] mm, swap: fix swap cahe index error when
 retrying reclaim
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6522E40009
X-Stat-Signature: r8qdufsjxei97k454yo5m91ke3oykgpe
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757112028-956632
X-HE-Meta: U2FsdGVkX1/5fgDckOnqSX2k8dZ/3lYI8fogmRAQ2uwc5gyOhUpKXhnqMDMtMkkEza6bn6cw9/LR2O4YWH3e3R2IDAjgljq35RjugMQom/ivxJStjFm4+fURByBm2QoC7UEgW+0q8Vn1qjD4mUslBht7sXrcvVSANklZ5da36JazJ/UrAME00DTKKoIVtmxcc1y/wi6JLrtMnt+7N+ME6H0rtq4RqoVUff29sHdZaYpcXVv8K6kHGLbrl/rmu3iDb0G9ydu2I+YFC4De0lJp7jm/BGa3unPnTd9ZsTyKeUg7rASdTM2De8Vsar22hB7Z9YJU6GJUiBLajzyAYb/C4ZjGq0m1AQmkRe6vRETg3INQbB1DwCRhdLKq+mp3qeJXKMZcs44pajHHoUTdHi0EApDBrgGOwaxixH4sRE74G/5r0wYe3FvfhsfBFUxr0PhQ0lDqKOT0LQWdATzIMWNN/W0PoEt8O5a72xhzvYuQ5S9KSz7vWTJaKe1zpQJ1HY9KrTHaUgT+MeoSUPy4vJ15ImwT3/RKlUuBrNBT65R/6CCcYshwxql8XSzOw5Ho4whnKUQtTXwmpi3IFMWdmho4XIaJdxFkdG4aV8EEMi/wStM13Q7MlorFWfQk5e8ym4824cq5uZoa4Egtcep7HQ1Gw62Ba2NKSGCwDbwZtF/juwR/LFnA0BKyi1lohDfs8lp+0wazhNC7PNVHlvGalvQPLxqEW/3gKn3hsmlKP6ZRG6EvV4xkcfMTTUJmftO9+t59JEepxq2Z+JyUPS913VyH8c/MeBp9zmUbixoT41oGmbK7202EaebMBmpja+rcItd+ER5b7Xe4LNx66z3Mm7TnNFu5ZXQMUwgluTbpDD0+2mdzLpp2KidIZE08CqxELrXFpzCa6GmlETkjmXkODygXHaBlj5r1t5C+aSSwipPJtWrdooD1Jo2bKlQZq3AAvT5lFCFHsqrtCM5Kq4NDl/M
 DAOgX2xo
 dHAiq6cfCHCdPhi3o8GVrBq2xzhHZ3VdAyr/P0Tz7Ck/QHUMfeMEJAFVOJEzcJFeTV8/BQ13R7zLWTgOB7uxFesD4L1vzTLJxspew07g8i3Th0aFcBuaIdFUWKJawcOwrc6aWrrTDgObyEkJAIeuw16AqSK63yrNOjQQBuC6IXI1v0zpeLod2oELgNhDCbhaO/+xT1SlhjF4SryHvOw7NwsWhr0+qrhC553lvBWxFZK3dJrLyVJICaKrSLmChETN+CaJ/tTxkMreFafgO29nUxj6rgmW/jzb/yakUW4PgF81LeQTIh5zq3t0RY+bA62DGmyWWN6cYab26iRq4vHugAmr5qUgA9UQ2uaLGESqdO3r+C4qxWmupvB/pBZpCF9vzReBzpubY7Qyvjh6Lf/8apd9k0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 12:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> The allocator will reclaim cached slots while scanning. Currently, it
> will try again if the reclaim found a folio that is already removed from
> the swap cache due to a race. But the following lookup will be using the
> wrong index. It won't cause any OOB issue since the swap cache index is
> truncated upon lookup, but it may lead to reclaiming of an irrelevant

I mean if there is a race, folio->swap could literally be anything
right? Can the following happen: between the filemap_get_folio()
lookup and the locking, the folio can have its swap slot freed up,
then obtain a new swap slot, potentially from an entirely different
swapfile (i.e different swp_type(folio->swap)).

It is very unlikely, and in many setups you only have one swapfile. Still..=
.

> folio.
>
> This should not cause a measurable issue, but we should fix it.
>
> Fixes: fae8595505313 ("mm, swap: avoid reclaiming irrelevant swap cache")
> Signed-off-by: Kairui Song <kasong@tencent.com>

Yeah that's pretty nuanced lol. It is unlikely to cause any issue
indeed - we're just occasionally swap-cache-reclaim some rando folio
haha.

Anyway, FWIW:

Acked-by: Nhat Pham <nphamcs@gmail.com>

