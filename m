Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9012FCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAC158E0019; Mon,  1 Sep 2025 05:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83FA8E0013; Mon,  1 Sep 2025 05:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D990C8E0019; Mon,  1 Sep 2025 05:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6EF58E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:48:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 75A531A0769
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:48:43 +0000 (UTC)
X-FDA: 83840206926.04.2B35473
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id 588741C0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:48:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=iezDNDjT;
	spf=pass (imf20.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756720121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yAMzs5EIRVRAxslxMp63SpyhDGxPn/8lHQuJpXOa5Os=;
	b=Jz6LcVpqxABxL/QuNFYWZwtPvcctchPLkyLo42w7t6tUcFWmkp2RAYf6pnt9VSaqdBCiS2
	DLN5IXxDU6hOtXfjXxeKtZbYx62aVdnBCWP1+9gxSSsijjG66u5bddP1r1R4H88Aur9ejn
	AxxBqhtfsci29x2XFV+4Zuc+fKDQTyM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=iezDNDjT;
	spf=pass (imf20.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756720121; a=rsa-sha256;
	cv=none;
	b=De4HTzSZL8j8Bt4GKtYILKKa2fwO41MpJ0pUBhVPq9u9kB2iTs1vE2FUytwRqNXEQ/v0AD
	X3Lz5qRPFTDep6FrfxSVQUK35kj02aHmqeCi7ZqVjSkBXoiv2Vz5BeWeCZpmSCbl7/BJ34
	cG3p6Wd6vH4xknVUUb1xLFMSHhxP20o=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b0415e03e25so143387166b.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756720120; x=1757324920; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yAMzs5EIRVRAxslxMp63SpyhDGxPn/8lHQuJpXOa5Os=;
        b=iezDNDjT5/+f5GBttUoHF/uS1Yf46QDgsua/cj2p0L2eVihHpFxhO3ss0eFdB+D3i8
         dYSVzQ0JMe6FAGe2XUwxy0xw25CwG63D67xDc+Mo9yiiQD30W0WdaX50jTgF6MCIik9n
         DT7nf2OpvQaWWCf9b78cgvskFcQmuHYwN75K5Ic9H1an3jSQwdnjaga5Wzdq4XLaZCWl
         KLhjHd0ZvrXIgI5vbs/sOERlpGTL+1E1TWFlKB//92JeVKBenW+yfs7ekHVaYrenHxaU
         eSKuFtMgWfwQ/sTgTucFgrJkAQGndgUJVFH0dgMGtKqQP8D6v98ter2BbSqgYkepQpdL
         /ULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756720120; x=1757324920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yAMzs5EIRVRAxslxMp63SpyhDGxPn/8lHQuJpXOa5Os=;
        b=MHQ125183jumBmOMcR9cbE6uLIDCQTzlkY7MAvvTtXMHDMhyZpDdZCZGbXuBOu1UMe
         BqNT0NWjfHv2ghjPMus91CjEycF4CpNq9vEYDPbnKwF89OHi5/dkgvjygpaB8EIFwmpj
         q10BADqIFD3b3drvnQITZ+yYGnkMD/0TuLyGrvtSsmvSEN7DUqFtwL7je11o9HnMC0Az
         bI8huzW7BvxKWXF2/D9QGSSUe3m56kIjbdEZsImK9gtEx4CKEwo+rCQwTrBU9TkOlRdH
         Pj1kNgn9SzPCtBoyqaKMjs4dsxrSqQhPFmktZxNnHL0sot0XHHrZdFoc7u626FHlTMHu
         N4mg==
X-Forwarded-Encrypted: i=1; AJvYcCVl9PYRdF3bda2NJSQAfgFTuvVvl9JYVUH9qLwsmi4XOrcTVnY/9yfJvTM7jf8IZ6r2X0RSmXUouA==@kvack.org
X-Gm-Message-State: AOJu0YwyU2j7RHFEH1DASBSTaExnVteFdMMpHaHZaVvlKcUMelKPt9Sq
	Dancx3gc0maMZ4ZDkQBUIr/ALuwn1ggpBY9rnbPjjujAAaoTqOnEJd4F9Zej24q8Uw8TJaw5qTV
	0Ay2TpHf4FlFjo4LQKPjFY62Q357n9DdxI70yNuA8Cw==
X-Gm-Gg: ASbGnct4bgIKXuLPWgwZoOtjbMFpX502KXG5FpDM/K5sO1Y8y9YUvhEak4xKHgdE8TN
	Vk0ERjItdt5VyuflhYsPGfWLW5lqwwdO/Bl07sWF6Modk5iX/gBrDk0n6X+RN0VSbNm8s4WqLmH
	f1PRSfpn91oaXC9htoZvCAp3rkAGHXUuwL+ENXqrwoe7LFBScDGGXsEsaC7gMvSiXGBUvItyc5V
	xiiwhHBUDU/rps4NhsNd6ifEUvARTM3Ra8=
X-Google-Smtp-Source: AGHT+IF9uPPihIpLNdOWfEOntV654qtMzSCsbA0hQdbcxVqqaSFVavOEVOieLFuxIRfTzmWFGI2O5TYxf4HiGmb1Fzc=
X-Received: by 2002:a17:907:7e82:b0:afe:ec09:2a23 with SMTP id
 a640c23a62f3a-b01d9769f7fmr622348566b.43.1756720119900; Mon, 01 Sep 2025
 02:48:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com> <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
 <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
 <e3ec5583-adf0-44c3-99c9-5a388c43fb7d@redhat.com> <CAKPOu+9CiT-5P--6TZcyq=jHLDhCa8LDh1AYjKr69+0shO8UrQ@mail.gmail.com>
 <244b73d5-39dc-4bcc-a69c-8ae3010b40d9@redhat.com> <CAKPOu+_wQ9DDHOQDtFeXU7ZqwvwxYqXNqWeSP3zJpfC0Cm2YAA@mail.gmail.com>
 <661e6140-572b-4480-9ca2-6a127730f32b@redhat.com>
In-Reply-To: <661e6140-572b-4480-9ca2-6a127730f32b@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 11:48:27 +0200
X-Gm-Features: Ac12FXzz8zeQxpYSNEubBaIfkFsD7okOqxhasIrHBExuNTUi_qYL4d0rCVeU-Og
Message-ID: <CAKPOu+_KbBRdtB-WiZuiva7Fqsus4x7zBOPkqdhwfYFkdS-doA@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer parameters
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org, 
	hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 588741C0006
X-Stat-Signature: t6j5xsq8bmtgc6dugkxc6uguakxp7s6g
X-Rspam-User: 
X-HE-Tag: 1756720121-848310
X-HE-Meta: U2FsdGVkX18F7TDNwhh3ETUuidW37kC9LpTEM9SMzbsTk4QPmf4YPWQJvVMPG3IqSoq+lI8bYG6NZx/B/sGsA524XgGBqctOhw9MfVGxLU3PK17ux/8ageUVuycVSMP2Ip0fJskS++5VW46HbffdsTq/BoBJYeQZ3ubEw86M5ym+wzy2+uWll2qvhsqAepbUsxPT+Hlsb32lvOcf8o31NaSFT2zVTrZD5v/vYfNocEum7ADb9CRhhe+VZjvsU/bO1HxIYpH7Ry1E/GLAGjRNVn2frD0PtvTtyg6HOLCiW7+Hug1dLRAMTo20f+i38/oBOvzPCcfoBzwShRVq2W51JoY7YwjqdIaI6AGDrSvY8ZHWS3DNTe91Btsks1VgbYsFQJbNjRUU/fTVLS0f2QlE8hj2ZtFP9I6AFiLHifxvryialymfEbf+JTJ9xaSdBX4KGcWpUNExsxS31IiS7+3fqShpYK9Fq56Fr68Ssg9fYKKKq7vrZi2DMDgZCgzjg3TiuVsGq+P78kkm45TN7bzytjzmtQyNxUpjc490dtw9t02BQ/oKwW80wpYVY5WNSJ8wswq4+vgV4usPLok7obsjNEDFTB+xU5FTFVnWKDPAB7m2Vnte8SIUb1nMy26QGmhYlUXzuZArEe5pm0XXpEG5cXr25t14HAssPSRLunLptc3c8PMso5mJVge8nnZ+uyDWdPcHtYpen+QY7IB/ygYyh3Wa/37uG2rAXIxJ6YQEPDgP6d8Of5u1tTD3j6Q1hTPp7t4Ht9jKtHiOBaX0N1uy6q4yU4y2fSSBIGdgEkwCxAx6Pg2ZfEWATDRu8UGOeeXxnwrQUkDJcr+Tbcg15fBkRGtn0CoIc77rs5DK72W/yNK923ZBk02zQ1p/ocozSOqeRB6kCTBSPZswcOyPBKtHwdFYD4o6/dMlx2hFJUJ3H25ahqRtq3bMPAK3jkq5LIUyru3ycdq7iL8z2UTRVDM
 9AycBANv
 6j1nhMR8U+Ji3YJJngk2DlQFi47qT0A8wBMDC42uPSBmHixvPG3pJLvlu1/Bi7ip5OrCS+QsLPlFIfVBDtzT9+7wq8jZXdavON41/rKjk8OTNZx5LjjTe4yLRdxkvUDcosDev/vM6J4Y39xvHgIC1Y9AZenNLCkuGASKhYfdgsYHHeeXosOu8lrZ/zTWd5cp+nJ+IDyQC8SgMTUqY+dFgVy0w2W7mv2L4tBr3hssKgXTI8wdusHrmSe/PntYQG18XLZQebZVb+qzwRUK035bguIz/Aq8sQtSrvn6g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 11:41=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
> There is an important distinction between garbage and a reasonable patch
> description.

It's still not clear to me where you draw the line (it's opinion, no
objective truth; to me, every redundant piece of text is effectively
garbage because it steals my time) - but you asked me to get busy
instead of arguing with you.

