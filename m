Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F2E1EDF021
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 03:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5406B0005; Wed, 11 Feb 2026 22:17:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549486B0089; Wed, 11 Feb 2026 22:17:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42ADB6B008A; Wed, 11 Feb 2026 22:17:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2086B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:17:19 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACCA959BD5
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:17:18 +0000 (UTC)
X-FDA: 84434343756.28.ACA574C
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id B08C11A0002
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:17:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EKOW+JkJ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770866236; a=rsa-sha256;
	cv=pass;
	b=KEwsGaxHcEanThquwv4fkiy2QYFk6tsbaS7zGrXH2WA0ujUQ8Sj0lGuQjj1iOmy9dSZ1F0
	fj16/GeXYyH2ABfKilx0bsREJjzgqZgi7Y0Tq3JXih834drH1Nn0yi41yZSNLQAHO+ZBHi
	yYuiHZzHHwFrOBWj05NUlnhRPYJnAco=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EKOW+JkJ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770866236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=myejyAY6+trMq2217gubmIhKoo+IyTluOWjrjF1r/Gk=;
	b=7mIGUuYALMPIUCc3YNCQemI2X5vWnwtNph7k4Vul8Mec1KoEoflSePECfdhsrtR1GDJu+p
	pUh8pu64EDFdc+ECh8m1QZXo/jsLtoH6fDpWN7ivLtY1rkMz6/aK/VbQKlJBLLovB6YwJd
	jnTiRjUiEcKy/jf3Kh1f4QLU31hJGhE=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48324da63b9so24445e9.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:17:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770866235; cv=none;
        d=google.com; s=arc-20240605;
        b=UeFrN20yYwraGdNCpnz8ClxDMOkzwaqzSg6PSkf+KYf+M/n1KYQzKL/yx88M8b2gRn
         b5Vbc7Qa9EjwY0fum+MVeYSn+xAFnZwCLY5qEhJfyORmeQl5N3DxEJXlouK3iDUH/znf
         U8f1cpPIc3XYHmAFMzwhyCMtWzurifPXDDnwyhQbIqh4JaIH67uDPhSNjSOzX1ZTJfFI
         41DhutCKRZGP6bL0c7HJKi93M3XIqFMzOwONMkca66EWVusg2WNnIqb+G9dIDkTspdVu
         7clAGcFfZ/ng8x+c1D+QHR4GDbrb/2ZASvv9+HmJonio4UGMprKgkWvdWQ9dalUs79EH
         EB/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=myejyAY6+trMq2217gubmIhKoo+IyTluOWjrjF1r/Gk=;
        fh=qf52HoBJ66wkBwbRuk/q6ri0n3PgDAZxGh+UyEsphyg=;
        b=SZuPYtp7equ2hSWwnuNVhflyOhJHqVZw2RJNunLadnw4TBaNo+/YWWr4zpKSnxnWO/
         +6++i4BhTRD6p/HBv3jLWDEPw47IXaOjUNuAuZQDvj/77fv4FrQR8b17cBXNBJ4Jw96r
         L1Cj1NC5w834MVtwTQphpIxLtSAEj5Ukx+l3jXAa4IPv5Mm8hjOuek2ViIe46608ZjqB
         6Hj3MaWCZKeDFqqmZhWuOVvMEKNc+9NqY8EJln1MOhg7mWf5Jk5XpjVSsTPEKpIP8NyJ
         yQInXkQI0UxE+Vr6nzbRn0y4IzqymvocRXawTP5yCrbSAUcin6U8SSDZmL7TuPRVS1Qx
         H+CA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770866235; x=1771471035; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=myejyAY6+trMq2217gubmIhKoo+IyTluOWjrjF1r/Gk=;
        b=EKOW+JkJEVIGdiXfhKTeoFQcdFIPBLc0HEB7OqZbh5fedEa4QnEhAwAOknj82t7ZAv
         YR09XxOTuBSKGAGsM4qGbhujitWppmsUpeTelD0+tG0wWqkoyi7+ceK5s3hJkcOSmLFZ
         kgd7drtAMEnJgroRZgBiSTq94DDtcnlq777A4YTqmZGGopT03TrvnAIrT2cqAo9aEUPR
         lwO+eDZ2gtXuZlvOICyoQYI1u6Dhmd5sFiFvwkKJbvoRUnvzSjcS/W3V6JR80Iw9eiHS
         qDWZSEnP55CexjLaLUnZzNKjGhjiX4r9VhqOByGNa2d3m0E1RtVT02y4FHoFWDY22O5w
         retA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770866235; x=1771471035;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=myejyAY6+trMq2217gubmIhKoo+IyTluOWjrjF1r/Gk=;
        b=JkrW0q3JqaLS5YA0ZOaZWZp9PHlaGTstKBX/YCGNfbe22i+n9rp6tdGr6ubPB2S5mU
         26FkopBdD6BOmIxcriS/mapeNTgE+Fs3sAP84qvqBkHmYmaUQOqMoTSl1j58tyFhkXTm
         u0wlO/4XZjYSihGZKqBuobVPXw3zdOdRUYZxyh5L3kb3fylaja5UAaH3ZAC6xU1IMonO
         gKe39kWa1mQdId6+NsiQeWvKqT6TStMmiseHZ748/YqyA23PuTp0+MzY9/QFXgw/mY1F
         zsGH7Ank3ReEZ5o7vu7bUsU0WBuy+ctdv7yqVai8imQwqxTYruJCNPAOna6eBJcRQ7Uw
         2ZfQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8rzwTWzx0UPSpn+2dpvLZ3n6XeSsasBNy+5dMUZUznETY6DO18CWFjLODxDtObRV/rn31VC/oPg==@kvack.org
X-Gm-Message-State: AOJu0YzNvjDiLpHBplpADl3a/O9ETptvJyaZ/EXpDUNw3Z+vgiHKkXx6
	ktRGffcVoJOFzoARpq7gA4R4SSF7s7h/jQStlPKRuPUHIjXd+xQefUa4O7fu9DbDndL/r6jam7q
	r6H1yhoP/DJFMqC2m+4z4WOrWDfMsfoRrtTiXRYkS
X-Gm-Gg: AZuq6aLb/xdLF3rU0aXFwXyeW/Sn7lmLlKpa8vFMsVSpOOokwwjBOZ4Q1hOALehAjC9
	9HexPhW9Dm7+9muIF/ZgwMXE0VlLzlZHPJGasNrv0IEv/vyw68NsTPsz32/4TkThnzAc6ZrfK4j
	y2FV/GxcgD0CvllmbMj9Wt0pheLmrzdEI5ZAgjfymlYn0X+53riFNIwKaF4tdiDVtLEOVru/YSx
	BybnJ9BwaJSS8ln9G3yDmDAmc2zTiAGhG0t4lrnpIp3aIJO7S4rFSxHQ5rr/uf1EflyhuWELxMw
	J5/92e838KEzfxsL9Ikqkbc8fYfj8WL3e9SjtjsT
X-Received: by 2002:a05:600c:8288:b0:477:86fd:fb47 with SMTP id
 5b1f17b1804b1-4836593a321mr490675e9.8.1770866234921; Wed, 11 Feb 2026
 19:17:14 -0800 (PST)
MIME-Version: 1.0
References: <20260203192352.2674184-1-jiaqiyan@google.com> <20260203192352.2674184-3-jiaqiyan@google.com>
 <26a7803a-bf20-c60b-459d-2c8f82f2f4f6@huawei.com>
In-Reply-To: <26a7803a-bf20-c60b-459d-2c8f82f2f4f6@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 11 Feb 2026 19:17:03 -0800
X-Gm-Features: AZwV_QjvMCktCSOSG3Cg-wYQo1ai5b8Q1OUS6kQKYvkGyQjOIsUwWhbDhSlmNcM
Message-ID: <CACw3F52kCHc5HF2wSg6W0_ApuMcW3VUk=vde1kiwRxQ+tkW9jQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] selftests/mm: test userspace MFR for HugeTLB hugepage
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	william.roche@oracle.com, harry.yoo@oracle.com, jane.chu@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B08C11A0002
X-Stat-Signature: q59bi8ihrdyahpup1zokbssk4zcb8eqk
X-HE-Tag: 1770866236-11909
X-HE-Meta: U2FsdGVkX19xsViGLZXXGtr/YsEPkuF4AzZG6J31JoXlptFYWAXDP3X+U+TisJxDZ1eXOI5CnRlJHsjlt7KuDe149tfsAosgcpdtjpnNOZa9h06xUBFhT5eIrDZLihLWJ3xtV4ZDU1ZSMc+VOe5CjTZ9nB8H4ykqkcKt78p7tbVXvZxZRBH2CFosQM5IhpQbFrfR6yqZ4G5eG5R2kMgxaz6d50om8XYb1iwAELi0SFsczPvpfL9GzqCmBinZ6BXmet1aexYk2CHKkuASwXj1oxJBYPn+xWFm67RKqL81ZRSdGtNpixhCPpdtHIktmVrpjfyAyRfm/GcHpIhiBqQ4xkhBASzk4mTsnepgdEFJL5IDfQdaZkBh0vw5VlYA3yUYBU+sQ8gdDjSptIhKe8oUPsRWq7PfYRfVbu2or/d/dfppQyyaJRp/fAhPfhmID9TAD4yiCbU/OeZe1F7zsXYLYGjt2raI+ZDQpfS/j1bDNP2Qaxd1vgm2ag2YrYb0Gv9sUOQhOs5l6rZZ1QFSBF1kSLQXrfGboG8bGEHfEzI31SuKmXcEknEP5t5wAtJY1+ZYJFkTR4c2grKJXLtZb7VVwDwkz9SBXbrZDrWCF5KVCZ2C99zT6d0PUBzQzSEoYfpm4QIlfRS80EbRBC0RRkKCxVigzXRXIVQWDucJZP4Ruv2+IHa8MMAXetrreGC2JCehHmRSLDcL4eD/9LWFxtpYyWrIwCd3huvy/i2lytZoem5b0sXyTL/H6tZnIXVyGuZ0QV7flv2Rfyql6IWTaVo1XDJ9nCULbfpMdfyGT575/HPZ+tSMp1/X7n226WRQhqbKneXdKiUQ9tSbAIAkvR/j9bNij2bCWyNUw/yPrOWBZdC4wEJZ8iJF5iIALjL+3AYn4AvmIZfCDA4nMY8x1Xnp0G63Ut55ghErWhOBORx2LChK4weCY/mxyF3C2Cmefu51VTQntELTWRmwfFqmTJn
 EpAZjRjX
 3hJUeKydmg2dK2DHFsP900zXVrGnr4D0eUNmzZS6wePRas0NoZlKE6ft+jyqIyBk0E/Gy4JDSjD4RbcY51vf5fTMtI3Z/YuPVK12p0Jnj07Or07gPOmxb9SnONUwDe+ycMRWbtkt6lJONTDkRCy9DbogptwwUG6Qa7H5biUKQk/Qo6bn9mXW5Foy5r1wIGhNNPilwjFI9P1fFzkgwKFngvSLsTGqkUJwIjmHsjlmxS+pRcYwiZmM1GaqFCkfX6M6wd0jnJ28gHERklQ2H3UVkucxGxa9yNYuleTlK2DGkFhmNv4UuEbySK+L2S8RJqCQXcjsRZ+QU3hAnEfFtnv6kNy1krY8f1GhiY1DepTY6rAmjpx1hLY+XbD0PNZTtgEvdpLqXWNVy0pNM35+MP/0illpDrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 4:01=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.com> wr=
ote:
>
> On 2026/2/4 3:23, Jiaqi Yan wrote:
> > Test the userspace memory failure recovery (MFR) policy for HugeTLB:
> >
> > 1. Create a memfd backed by HugeTLB and had MFD_MF_KEEP_UE_MAPPED set.
> >
> > 2. Allocate and map 4 hugepages to the process.
> >
> > 3. Create sub-threads to MADV_HWPOISON inner addresses of the 1st hugep=
age.
> >
> > 4. Check if the process gets correct SIGBUS for each poisoned raw page.
> >
> > 5. Check if all memory are still accessible and content valid.
> >
> > 6. Check if the poisoned hugepage is dealt with after memfd released.
> >
> > Two configurables in the test:
> >
> > - hugepage_size: size of the hugepage, 1G or 2M.
> >
> > - nr_hwp_pages: number of pages within the 1st hugepage to MADV_HWPOISO=
N.
> >
> > Reviewed-by: Jane Chu <jane.chu@oracle.com>
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>
> It's not required but could this testcase be written into the tools/testi=
ng/selftests/mm/memory-failure.c [1]?

Good point, let me catch up with your new test fixtures and see what I
can do with this new test.

>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=
=3Dmm-unstable&id=3Dcf2929c618fec0a22702b3abd0778bbdde6e458e
>
> Thanks.
> .

