Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE9DD46627
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 21:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9461B6B00DC; Thu, 15 Jan 2026 16:14:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3696B00E1; Thu, 15 Jan 2026 16:14:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6046B00E2; Thu, 15 Jan 2026 16:14:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69FB66B00DC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:14:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EAAF3140491
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:14:51 +0000 (UTC)
X-FDA: 84335452782.03.A4B5C24
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1ACC9180010
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:14:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SqSB0sDX;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768511690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kLMiNGGY+MRW46p7GK2A4XqqTYN5OUlY7xfrS7gvdk=;
	b=5H23EXUdFm6lUC/YQ7nn3bzJQZGzH1Kfu6pwzOQ9uR8J+NNiTis+s7QAlpTRTZPptf6tSx
	PhNNwdcREuMSkapgEwy+PwMEilyViFHV0yWxnd8cJ38ELb6YX5F3buRv8QEnYMod/GgRUU
	lWoKHppaxTa+vi1gFmgEdBEihAUPz+o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SqSB0sDX;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768511690; a=rsa-sha256;
	cv=none;
	b=Pq4SDT07OgUFXw8/5IRuihiJhCf0stJ0M59SPYKKQ1ugeTkqbRWIC13wqCHX4NANLTettl
	e8fnsE1sb6o9F79qtV1PJzUPtiHa3TDumXvPIdQw1BhYkWwtzpmbIr6g2U/wJdzZvv0Yyy
	xyyYlEAzL3gIPiV3Zqw5tseBCzQKDmA=
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-646fe7f70e2so976324d50.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768511689; x=1769116489; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7kLMiNGGY+MRW46p7GK2A4XqqTYN5OUlY7xfrS7gvdk=;
        b=SqSB0sDXtSnox++5TzgMOtv360K0Iv8lE9nkcCnVepbi2LFJH+6mlcl8leXx2GDYEr
         xknwg2RDihM+0MgpG27JWDjGIyS+DOxGQL8Q66RiMa0QTY78IEgGoc+6K8WCY6AwC7R3
         jNJEAGRK0AQv+a/+pBo4YE6pXm9eWoEblVQUUTrbpKgaFuhmc4qGHOUpSFfn0mC4DJq2
         QqGIX3BGvwOn0Zbk1jFxUVA82GMVIRbgwQRa98jftZXWnI4ixsgwcdzHFEG0fLEoA+rP
         jMzT8VlsiaYipmWz2XI1ZpoKvZyILvQhzjW9TPsdhB3e08OG7Wv+NS8j4tVCqBxytHLG
         HeoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768511689; x=1769116489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7kLMiNGGY+MRW46p7GK2A4XqqTYN5OUlY7xfrS7gvdk=;
        b=nrpWXdXk/xjfuECw4Yy0cybh2UPIdlxvnCtVqSwbK5n5FivmYuzwO+FtFOCIxGEsUw
         NvbvUqI3DM0ryOcRjvzdX8ODiBTpRIomy9C/23xoF5VXAt8TU2YizhzHhzYp5zyOGpB9
         4MX3iXNt9xvxqTee0pFpHPwgCHG41EHZyoMOxS1sopXPKojUX+ASkZmZfPXz6LFX3XVA
         VLWlOig2zTLGRFzjUcdeOLeeVTNslRlZWVEkBZfUAdZb5Z7TMTUc8N2jggRmPpTWCCMc
         UGhpgBwuiQT4w4p0a5Kn5O2qP2Nk2QxJJMWcKUQnXkX8GDRimqHUY8FePT9ZGkMqHAZC
         bJ+g==
X-Forwarded-Encrypted: i=1; AJvYcCXkMry8DFzv9Iz9Mzg5uDM5kK/v5MRMgXPI/RkCQ2K1XFj7zANvg5vj3AqnBLki4mREuncy/EImwg==@kvack.org
X-Gm-Message-State: AOJu0Yygcmg99CTQQKS/ahBZ6yTA9TOoJh/RGzQXiS30Zq8CXrs5dWbV
	5J9rJSsEwV/XT2YRNBhPdk/38aAWSuVWRtMjMKAYRV4F69sQQxqfGAF5
X-Gm-Gg: AY/fxX7PGwzsQ4O6RPLcfJgp3NwhLNA0RyGOHRz7mXBSGzTmjk7xtT+WOYLnwRx8e9H
	athv6e31FcOX3A0AzEivd3U+FdqI3SSctq+6nPjk7EaDqWKgZUcrW0g/BB8qvZ8kE6mnCAsIym4
	crWXwbGjAFMBLW4lvk9rla67Pe2WbSff02zR0lCRusoqNFFzF0UkUBbFPaE8yvttJ+s9Eg2YAo7
	HeaQFQcn4ysRIbXIBZ/3U2lSYUKUgY1pVuHENLW656ZC9NiOKg9Nra6mhLfxpCZx1s2osaXdmUq
	lFfktFgXikWwV5TUHQY9OHfGyJfA7qCr39fiGQifWmNyxJmGyAcxTneWcOIjDRmO26FkaJrjkOj
	xj3cWUyqFxc0VDqNUvfob9GKA3v5zwlswsujUJ84eKJC8iB8IwmhFs/eChGJZwjhe+U5k16SLkT
	/zKNk8Q8dB
X-Received: by 2002:a53:ac88:0:b0:646:5127:ad81 with SMTP id 956f58d0204a3-6491774abecmr401978d50.95.1768511689099;
        Thu, 15 Jan 2026 13:14:49 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:5::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c68c4167sm1738657b3.52.2026.01.15.13.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 13:14:48 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm/hugetlb: Enforce brace style
Date: Thu, 15 Jan 2026 16:14:46 -0500
Message-ID: <20260115211446.1429024-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a0760613-5c57-4f04-848b-a0a6ff05c0e8@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dxpuooupteqff6cidxa6z1dshp4q7qhj
X-Rspam-User: 
X-Rspamd-Queue-Id: 1ACC9180010
X-Rspamd-Server: rspam08
X-HE-Tag: 1768511689-432660
X-HE-Meta: U2FsdGVkX19JuRpy3Ta7JTHngXEjUY5UTbVQqXeCvAP0ezrtGiOGp/2I2Ly63C7CEpJ2G5KmK4r01FvNEYT/Ck7DpP3vAczu6Xi2BT9anVpdhBy6GdVnN4IYYa688DWvUtUx4HS1x0QYw+MZVxKHU01PPYhY/5LVreAjsEBq50xDOj5/C9K4yN33hmWdVcn0xNk7d53nUTIjtWbh2+tMURafVmbCWIvID/Rba7CscFsAID75XiU40hZcYWWP/gvLrCxtOVjKBQ52tGUrHTcGYekqnovafH6aju84bZFtJDdTIO9so1tUxnPGVT3OFauP83NuuXtaMRYe7bNiIHEVBvvRiWCxPVFWZMWfDvikeiQxtZ0wsYRSm2GolAymP3c8usPuUsSTgyz0MKG7JmKniGjwJDt2lWfbfjd3ESgwzmejEI/dpACuPhxzBHXYSHJZvrc00qcCE+ImK71hwBj7+RANtBSwi+pMwZjsBLFMcLz+PJ9ycIlqqkEPXiNgg2ZjkQdB/X9JnmAnFWoGhC+UUeqB462DofQ94QuUjf6xRmzLsBtXfbCWVlT60VZzpyrilBQlJrjpVdL2ZzPfNeHDM1+iSQxC/2m5mcY7gLOOvfAFV7H66PtYi3vE4rWNO4eaUU2Cc0d2zaUfvQcBGJWXVhT5W2/3JmBFqSzG5xois2SexsywR/GkYDrBdlODSYEZylUb2uAerjWZCCveqft3TZZXVxdvRptwJVBuaIv0alU6yOZBiIGLPBqEgeFzJ+dTLLrP2xhKeTIIwWATu8H0OBtRBbKxhG2TFOtEP+a4xHMQVq0yBKQhl1MLoyBMz7IYFmAIriu/P4z2mt7m12D2VxQgZNcQLNuKaCDNGzArDhq3/to8InQg5hYQu9r5GIKU3BKPuEpVPlrIRaSEGKsN6BLV0pFW1h1WCeeidXT5Qx7DjkhG8UBjxojQEEqtvKkeQqYeuX510ANi3P7qL6Y
 MXoY38yk
 d4WePfQ2Ar4WL1C8LkOM4wM4/7BcyNXwxlGeleQyZk+dsLwtzPYFfHTmxcslg2v7u9T1gT8gOQf6JOZ1UbmYIM9gw0HE5EmJi0Usez8jUNQF0n/mp4dUhUmqH+6AGfkH1vmHgPRIn4ogZzAmj2rAWsH+XDgZXDINNy603jj5y+61GJLZdDiMMm3l+RkJqifQdl4g8P3U3BmWMN+E1q8iF/mg9f+7NGsfUJwuh8R7kVrQchE1EUArJ+4WFZKaJkwcPM5EKlOFeSSzOc5exujwwXvKRJ0IcZPuKRLQelqYUPBM+sNDBCCaKrZYSCRcTYy29SKmwe6Ous9Zy3BGAN9CYG415X0LValmfvsoOZhgIZhq1ltWHU2m0Y+u5WSUrLnFTGfnilo+NiK1WFK2qZXE1sPTYatmth4hE5smRS1Zif0rh1W5jPokN/LGmEAI/AcjkVWoveiHGkJ3pUdcZwOYRFLYIueOBGcnZqoRbVscxsyxJ1GgdQNFzaJvFpK1zJ91TlLmGLUw/uMCg4s0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 21:10:41 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> On 1/15/26 19:14, Joshua Hahn wrote:
> > Documentation/process/coding-style.rst explicitly notes that if only one
> > branch of a conditional statement is a single statement, braces should
> > be used in both branches. Enforce this in mm/hugetlb.c.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> 
> [...]
> 
> >   		update_and_free_hugetlb_folio(h, folio, false);
> >   		return rc;
> > @@ -2672,11 +2675,13 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
> >   				 * be consumed on a subsequent allocation.
> >   				 */
> >   				folio_set_hugetlb_restore_reserve(folio);
> > -		} else
> > +		} else {
> >   			/*
> >   			 * No reservation present, do nothing
> >   			 */
> >   			 vma_end_reservation(h, vma, address);
> > +
> 
> But why the empty line? :)

Hello David,

Whoops, I totally forgot to run checkpatch on this one. I think Andrew
also noticed this, he sent a fixlet for it. Sorry for this! I'll fix it up
in v2. 

Thanks again, have a great day David!
Joshua

