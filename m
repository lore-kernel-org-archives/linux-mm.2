Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C784606A889
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=bX/506Q7
Received: by kanga.kvack.org (Postfix)
	id 9E5786B05B2; Wed, 11 Nov 2026 14:19:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F2A6B05B3; Wed, 11 Nov 2026 14:19:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DA46B05B4; Wed, 11 Nov 2026 14:19:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4AF6B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:19:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFCC3A017A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:19:17 +0000 (UTC)
X-FDA: 85423801554.15.20596D9
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id B58424000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:19:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b="bX/506Q7";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf12.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794424756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXG55VLQRWz9Ej2hW5tTgWRoryYzAo6LPvqb9XxJLWo=;
	b=QM8iobPrM95oPOhXqYAKhbHHFLqo62iCEAr2pIJMuP+1hXU2p9JEj2YRQi1A0UieXEi8Gw
	nKOWUO0AetrvZfSBW4fQscKIlXpDnpZfNWQ5pthMFZhpszW8o8MfUaUUbGerbL6xePILX5
	VaQibtmD7sxLMHCv9cWhTxM2XqxsZcY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b="bX/506Q7";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf12.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794424756;
	b=OAiJfyUgTYDhM0d+3MDAxGgnErxq0tUWR4tOXNX3u1eij2exrzN3s+7eFWKkMm1EPT9CNu
	EPO+d4Kczdea6/CmrV5iKBtCT96Rpls+MQyHyOcpzCSqYXDELt1fvf7U313qVo24sdyNty
	iRpZriN6jWmQ6yDs/XhQD3RzTlL4QgQ=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so523711866b.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1794424754; x=1795029554; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NXG55VLQRWz9Ej2hW5tTgWRoryYzAo6LPvqb9XxJLWo=;
        b=bX/506Q7gP/PnRR88dsYkAjrCgnucNCbtul6rhGI7kP1NQbbE8XFSxx/9AnO1u1+hU
         lewnr9XlCVc6XoA0qT2oPY562ZDrTr8Gk+XzoPZut6LpCKRw7oubkI/Tv+eEJ57zBFG1
         jvyieMBcsQ6NeVybUuzYmBQSTk0YghVUpdYMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794424754; x=1795029554;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NXG55VLQRWz9Ej2hW5tTgWRoryYzAo6LPvqb9XxJLWo=;
        b=099/mrm1A//0T3fsssk30z5z2xZjRpZ5nl52l2by1f4oi7uol53tPsPkQ8XuxNrRPT
         2+ssKzIobilviDh2uovxeUFVDe0tgGQBDK3LUd5pRh6S50gqcOMu56wzQ0AVWizEir8P
         teccX6MUXKMJ2w9yYRsppbdy5I0+JFsNv/F3HkK/7zfm/Ir9gWYb2L7eH2eujXddWGGX
         /Sc9sZrLOfhgDhC0gNOqUPfJPtQXip0c68C8EPXyFtZkcQI9Bb/3nLXzru7T5DZr4IEy
         hlL0g1GhGx0aJEl8kGDygCJiAnXONac3TqcJWrD/nQa+3/50eb8StuqZMbwax/WDr0IV
         BwBw==
X-Forwarded-Encrypted: i=1; AL+hErGo6Hm1d8kgss/CUsyHXkq1pmWSymnzs9dsdw/933eDGcZzKlD1BYk1EdSKWFjjcd95+sCvxq9xuA==@kvack.org
X-Gm-Message-State: APuU4Z+uHgovXOmCZ1433j3+2jxQGxg8uqApHSAJ6x2C1DLiekgVZ/xd
	+wyTLImwCDaCm00nBAku7QIaJUWlY+wbcu3dFHbbTwbJZ//xri34H+ONToIrxWscDJhhsZGbRYW
	0Cdztdjs=
X-Gm-Gg: AYBFou04yQHbvnPhev1IbJKxqGmia/NJf1jFYREOtlkSSH0K44LFnDZD2KNoJMJ0qjm
	d7n4D4PiL8xB4S6wAJnpUSVVFymxlnN/vKVd0rx6/zTboCZwJYmzNocNVTZQxtBvDn7WpF2GBX7
	v26LQ/RWz2Qt1y990hGpaaSemCPDV0aW720+lSjfw2FGRahj9RAEDs26zKa2dvtNFpr8kJBk2IR
	l4Udcww9spLrnTJ+yXonx1YtpaNWMrDI3Ds+evRbPI0Sq5K7xn5FSZ8PjhTXyC5jJgAG09uOPOH
	LhZTAZaQQ81nmkPVYbH1zXxASNN+x0yXltmEighYwjxjWtJ7gdyg3kCuelsB/YSERAJKoXMYCn7
	Uq/53jnINJ/R8g0/u3CaVO1ZIColdP57JVfAc2F1JcEb2bUBE7ZuD2xnf7JEmEl3F9GPLY5TC8J
	2LhDUTZj5eKbEcTqyGeBweQnjRm368kB9R6xBGmwiAD6ZtHAzdgmy5haKeqbTmGnJq8qyAiQsXL
	ujhJ1poQhy612fhW4RIzkkuygNBubOX3hcIQprPwX0nzsi7rSNsz7fPLlO3cpo/bFS23PJlGieb
	s8M5P2y2VUTZzN0ApMRp5Cv2q9nRAegYssCB0zUWOlTTrGeiR/dedLpvpX+cm3EhvM6M5SmFuQ0
	wlg==
X-Received: by 2002:a17:906:f5a4:b0:c50:52b5:e17 with SMTP id a640c23a62f3a-c5066afc122mr264059766b.13.1794424753911;
        Wed, 11 Nov 2026 11:19:13 -0800 (PST)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a69ce38sm258245066b.84.2026.11.11.11.19.12
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 11:19:12 -0800 (PST)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c504bfd7393so338459966b.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:19:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHmIhoO2OazLjZ0RiRtXP7orLpOa6DpnhgcMeQyIzuOgzeWrO1pLrO9q+7o+XpUJUip7GUV9Obfzg==@kvack.org
X-Received: by 2002:a17:907:a805:b0:c40:36ca:9d1b with SMTP id
 a640c23a62f3a-c5066d6ae19mr293546066b.40.1794424752390; Wed, 11 Nov 2026
 11:19:12 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <606cae9e.bbec5.1a1c54f4f9f.Coremail.18670333770@163.com>
 <60541e98-b1f0-4f92-a155-8a29c0bb17dc@kernel.org> <44abb8ef-7711-4ad0-be9f-ca47206892a3@columbia.edu>
 <856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org> <avS5QcRj85yAm9ll@thinkstation>
In-Reply-To: <avS5QcRj85yAm9ll@thinkstation>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Wed, 11 Nov 2026 11:18:55 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgA6=_152qr3x6FrD2vmw27moARkQbUjsJoehXW-aAZoQ@mail.gmail.com>
X-Gm-Features: AclHuK9Un7jYzso2-pBVjOWTwZ9BRGN_Ct3oKTQqbfnCyzJAzUmyhZM2iKBUTgE
Message-ID: <CAHk-=wgA6=_152qr3x6FrD2vmw27moARkQbUjsJoehXW-aAZoQ@mail.gmail.com>
Subject: Re: [SECURITY] mm: khugepaged collapse_file() drops RWP PTE markers
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Tal Zussman <tz2294@columbia.edu>, n3rd <18670333770@163.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "ljs@kernel.org" <ljs@kernel.org>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
	"peterx@redhat.com" <peterx@redhat.com>, "security@kernel.org" <security@kernel.org>, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B58424000A
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: w6qah5n7q49cotzjmpi9rfctssfg8ekr
X-HE-Tag: 1794424755-606064
X-HE-Meta: U2FsdGVkX19g3cTY+Qyw/HQiselEEap8SWGaQywa+uAFkIMiaEW+UBxtzjGkkf/serYqEefFJXyp129fSsjprOr+ICKxO8nBicwRJ0XuLbvC5p8mYbu7I2CccaC2z/osD+9Dfa2KrPgJuC2sbU7zOlHyhCYxMfo6zvzroOC2CLvFQfhAlmUb0l39V3FEhN4331IXQQIKBGd0dRSt6RD/BAQv4kk4vvGoPUoQn93ZZNWlxa4kp235CwQHy/R+1vHn2YajCtpBMxqBSZ1Nslc7CZUSf42+s3iflYfUXS+TTYvRvyMu9qcuuclF2NpxXw6goR0jX06HAKzJHZYUUuDjD5TJMIDJ6+hMO0JPt0OjEo4ztQGg9LabhiJn0VvpbpizQ8K7kT5dRBilu4t9/zam6WEl8WtG/089l+n5Q3nQQj6EGSo/7puGc4WL+zDh/n07/GKxseaAJJ3dfejgf6F6xN0529sASjfqum5FXey/uxeftbofpey46DWaVNJNyuW+J/R5tiWnqda16svR3Xpbu0VDvaBc1ibYMAsplBudfTKUWHjiFJkJphM5K7ZXwrvJz452YJseTAurWftbnGHlxd96iuNaUM3I4XEJ/16JM2rEXJ0fhPkSH66uvsKNV2xUy+HVdSHbnTMZ0JNvyE7P+/g0+EefsMm2nD4r4jtxwUw0rc5GJxCAUJ3qKdju4+EJY1EftKdXiFV1etgLi+pzj3yGFow+NrPC8T6MOU3j/O403EQlujAjZBHvdEXlTEycIe+NgRoj/xapfzwluegvkxxo/8tceWeLQvcfXlt6bDPpBzl3+KANWGK/9o4Z0L6eQ8KR/sWD+8Z88tNQhaL1BySWGbpQCSiRsMSibprF10e1rk2LjeZjA9rbUdGBirVjQzzAOF8pIWDkA++RAJHOFxX0wmcJV+jOfpuYr2d/7+qbzKHcuoIH87O5oZUW792pR5KglD5wpFrczW5HpkS
 Lr5sQObS
 yULko/7fq2n92/d70zqmAMmuUzrfEWRSckqenc5JQ0BlK0TPTpI6feRsDgF9ceOsv8FHxS4G1/FDSguUrOFPjC2GNZ77twc5aa3Ye/bPsYCUR2ZjGwd/v7zJc3EZUAgGxlkUXpBnCS+PHl+T9i40v6BJKgmZ+lr4+HLDRwzVzn9MuMvO7o62/i+pj91j9QQJhd8jC8DiSdPKV+wwdp5r2AdbYrqpuaG0N1l3uWTJU0sluwoqwv95yXsS+6yWkRr9NyZglMLrSrHOtZKxoL3AOCtJPN9jrNV9XiBTbMEu/jhaAqhvgDjl5GdZDUj5kE7LIh/o1jVeyopB0WwC5Lp5cJX7+yS5pq3pqtEHLi5IwmuSF08IKJSI/Q82dkF8w4fMazRRdIfYP/UdnO4hgqyOQYWI9+ao+kVkLE6VkY1+g0DbDV+02Z91gz91nQxNJGtYaqkV3zMBpNJtz7IcfonAlncjXupjgagBzn1yN8So3vKs9atp/zFiSuIdFNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 at 11:13, Kiryl Shutsemau <kas@kernel.org> wrote:
>
> The report registers RWP alone. That is the only setup where the access
> after collapse goes unreported.

Let's just document that as "don't care" with the reasoning.

               Linus

