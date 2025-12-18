Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0110D6E2B7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 22:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1756B0088; Thu, 18 Dec 2025 17:31:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8FA6B0089; Thu, 18 Dec 2025 17:31:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31D16B008A; Thu, 18 Dec 2025 17:31:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E02F86B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:31:25 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E0BD13AA9C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:31:25 +0000 (UTC)
X-FDA: 84234039330.13.8A2BE8A
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6FA75180016
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:31:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="d/63ZC8Q";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766097083; a=rsa-sha256;
	cv=none;
	b=Z27mUcoZElHPVsnn3jxtNDbFKb4VVI+ZVkXvMOYssKppc2JK71RrXbnetAHsnsfeL+7htu
	r9cmsGvZVcmnXWA/xoNFzRtVWvnOcfSm6wkbCpJWAqjnplHAxyAT2fdtguUyPS2EOWSpKJ
	XRLD4QIM5lTDRFPvqgeqXUuGF0f7AU0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="d/63ZC8Q";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766097083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N0ZERnv75ipSNvUOdThWl0eF0juyZyQV8vJbbiWVzrk=;
	b=ENWsVsNSmLejcSSFKtIcMKkUs/vQFuv7TRkY8fpGYZ9R0RlMafr4ftapi0m0UmmbvL2udk
	Gb5YhfqyGbhjlrBYQZ7s1P4+BBjZAHH2FykDkx8BfZxljsrxC95grx6mkFFJgr4bmuQzDl
	XIiFKSM1cKjMbUfYOLSLmAoOGKBHCT8=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so2185751a12.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766097082; x=1766701882; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N0ZERnv75ipSNvUOdThWl0eF0juyZyQV8vJbbiWVzrk=;
        b=d/63ZC8QteW+Hcrrnu2c0DZOOeAf6hd10ScNjjs1fIsAERnnvOJ4E0VSAuyoRT4+Gy
         a58n54k2sXAwhDCheQednBruop3yuK2xpdaGFJo5jVP11q8jnST2YHL8Zhij69Ka+eiQ
         3nsLykMv8waJYaGkhyQggPFmEd++9rMKuW1e52J2nGAiX2bLPSk9+qq5w5TW+KU6YGaf
         RP4tSlY2E2iJdsvUeb8KR+HpbY7AAB7ajT9kP8JWtYvCwO/Yrz4fZpTmp/Z0pNYsMFxH
         M6lGs+rYSFS73BKufmY9ieRFyiap3PDAnwBzKBPDwEDlKMmhvZ8UfZaj+VG7GunTdzZc
         qQGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766097082; x=1766701882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N0ZERnv75ipSNvUOdThWl0eF0juyZyQV8vJbbiWVzrk=;
        b=moHJ10mr/19gwkxOAJQrTk6gFFw093fPjousCDrq8JZhgL5oQRXYwIBZ0ocTUMNrb3
         wVZr5Gp+UYO65PDQz77QRWKTzItTcaU1zermcOktzl72sZ/i2R2WeSfQciCxtMIrgNUs
         UgFDwLwXqQFI1doXEjT/8yUuzqXHL5mKlQJshmGwJdJsdJDWD1Q3yfkhfgr7w69sZEie
         KNKMeOfunZMpHvpiT0Ta7HUOPmWeSTjUr9eucQGPo+cPs3ge4Me/QUhVWquxNz8tcKRl
         gKIuTsWb3SKWptV4oKbyX/LHqk4YdHD5B9ZZqvvpwswwEWdUFmoWoE+sKCtaPMPelZ11
         ZZsQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2g8TGjtasbnJhcu3boLPTtvjGgQCvrDdLkP93a0W2mPQhqOHi4bTg/vmUSd4d9GyL9d07cZjLwA==@kvack.org
X-Gm-Message-State: AOJu0YyDqJDrrmn3rmzNDigVehX/LyUM0voo/MzvFye1UKaJK2mFE1BJ
	nAVDPseoLnrrlhEAx/SIxtD7OqqM6Q5mLoj3U1px0aANjSAMKZn8c0eCSPTOZ18NHCkcAWdhQ59
	Snwu7pK7AtPzvAMNRa2fNZ1TJVjGbPgwXCDiwahBWXw==
X-Gm-Gg: AY/fxX4yATJy9CuPyerAEltMmPNFSY6/SvzN9uj2KOAAXmIcbq4zz//JJmfPGb71KMa
	an+X+hZci8ytwQgO8goG8Eyy3el0iYdOsKLuuIlkKEbKgu1QKIOz+oUxOkCu8Lg9Ml8hV1otJ66
	UtRSM5yP31BXUfIAUGxFCeY9/j0kb+JyQTqfKkAgVysXrCcNgEGgu/FVkvEu+l60RiqIDbDSaw/
	vm09B6n0NiAqjNS5TxaUoDMldyyq+H1+NGFb+FQD7SbU3rH9zKk7nJg2BVGhSLxRF/6TTdo+wgB
	fXfmxR8hd5IX44BBwRb3rPv3
X-Google-Smtp-Source: AGHT+IGygu6eRodSik3Bfkp3czBNQVMW6XjM1dVil21tieZxpnGb6arOF2/iB4pEiGfMJZadLyOPhelEhWbcfWH40bo=
X-Received: by 2002:a05:6402:13c9:b0:64b:4037:6f52 with SMTP id
 4fb4d7f45d1cf-64b8e94e075mr973035a12.12.1766097081599; Thu, 18 Dec 2025
 14:31:21 -0800 (PST)
MIME-Version: 1.0
References: <20251218155752.3045808-1-pasha.tatashin@soleen.com> <20251218130725.1b93a521c039ce121de62472@linux-foundation.org>
In-Reply-To: <20251218130725.1b93a521c039ce121de62472@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 18 Dec 2025 17:30:45 -0500
X-Gm-Features: AQt7F2rxtCEBDZim20tERMGFS7BGfrYSNxBBeVmqar1M0y5_ubwYl7w-lYf7Aq8
Message-ID: <CA+CK2bD41sMDbN670G5RrNQ-3Qq36dO3LmD18zFu6uc9KxhRzQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] list private v2 & luo flb v9
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pratyush@kernel.org, rppt@kernel.org, dmatlack@google.com, 
	skhawaja@google.com, rientjes@google.com, corbet@lwn.net, kees@kernel.org, 
	davidgow@google.com, pmladek@suse.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, nicolas.frattaroli@collabora.com, 
	linux-doc@vger.kernel.org, tamird@gmail.com, raemoar63@gmail.com, 
	graf@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6FA75180016
X-Stat-Signature: imktj5kn394ddkd6p5ok17p6o5o6bpee
X-HE-Tag: 1766097083-17690
X-HE-Meta: U2FsdGVkX197zKnZovxwUEDH36tkgaXPmbB86kCbc0lz3+1dQaxV0AJCM/U1aMS/de1+6pHLAMabksQXkrgzTktTzkw9WRtEpIN4Wo3x+VZ99QyUmZDSgzlqRvu5kIBiE2zUQUE1NjUfHGZlugCtQbhB4xK+5qoZrmIeMk3CjbWp5oWFvph6I+Yame0uIaH5Higjw1PXtm2shLodNa1cKQiLEAwRRmDheoX8WdiuG7QS++K2wB1/BYGZJuq++ss2A+MdoZSwd7YXR13v4INouJT6Xb//PYDkrIw59wgTL3zRog32FL+EvIMLHNCIZc8l+FoLAPW67ukk9h+xB93hUygsSF9SlEXU5BPA131RLmxUISfUWHP8+yXeYn+a21bvKaa8j86X0cCLmAyE4E4R2t9rfNsxMGJhiVE0T0sFhqEZbqoHmZTFcMN5EkdhLwL0ACztN4+QwTTlFEj7QYC8Z6VX+FjK7FbTofNKJjOnYGmojLMgT3DYRWrrGqFNpJ4zpFAAmuw82OrJFqGIGoZYN0E83iE4Ac3PgK2sJ3IqpobR/HCkVdwe9+6doiejtvSRc/YSS8cSzbWiOWkqoPnsE4HM8xrKulH2aBhnKleRyrJDmX9gLdVBYcnFamaGBeiuyVUwmUJixketS/gwHe67E4XZNzqCwBWQiWrNX+zx2pR+fU8d27VCqg1d5H9j8cVjBByWUiMGmTU0cJw2VpipeqNRb+b831EbVQmdzM1tGrP3Yj0U/kxJAiHNrXh3XMTs3s+O6HBcCcgV/JlKRct2XzpOqFlkbgrlvavD3zAhozy7RrcQi9hK6JbtkfpeMx1Kbh0lYihcHmhvyH5D78QydDtjZtzZaldx3llpQX6nLK65/Mo55nTZHk9L3MtVQNEeJKWT1dTz+WjqhfB1SM6Q+X53dzpF7eLX/jRbBXipGgnFFrAoN8Qi63lQTvZoBkA8fmRM9upuei44AZQ66zw
 8sqUdHkF
 9+ACraLnmLcDjnFz7kxHfkxfnn0Nsu6HsT8Spx9B05+is+PH8Ajedry6EBP6GOnA/J1lGr2/S8RiyjTbGaoaOc+8P9dWW86qaBpNigAQen25JHzAIyD7z++ujXQIFOh6IOvDircLjXojWFT6pz2hFSV81kPtpExdOEhR6AQL6aZAZIgpgBBlU/7+pBMaIZ8iia6s5LmMszOJ2BQLLhuuoAR0oaFu7HGG+wvQSstXH37sdjCX+9rlo81Quuux2mT6fW0HZc8qqbbymCjgNWq/XBRL616fp5ibz0zXj73SWmaFHZ1npHw5KwfIi9RRaapzLwGEpq+Qi/fIpD6U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 4:07=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 18 Dec 2025 10:57:47 -0500 Pasha Tatashin <pasha.tatashin@soleen.=
com> wrote:
>
> > This series includes two separate workstreams. This is because FLB
> > should be applied on top of list_private, as it uses some of its
> > interfaces.
> >
> > 1. List private v2 (first 3 patches) Previous version:
> > https://lore.kernel.org/all/20251126185725.4164769-1-pasha.tatashin@sol=
een.com
> > For details, please read the cover letter from the previous submission.
> >
> > v2 Changelog:
> > - Added a Reviewed-by from David Gow.
> >
> > 2. LUO FLB v9 (last 2 patches) Previous version:
> > https://lore.kernel.org/all/20251125225006.3722394-2-pasha.tatashin@sol=
een.com
>
> Please, no.
>
> This patch series is intended for the Linux kernel.  Your grandchildren
> will read the above wondering "what did granddad do".  It's just lazy
> for us to expect readers to have to chase down links to earlier
> versions and then to figure out what changed and why we changed it,
> etc, etc.
>
> Let's give our audience a nice, self-contained and complete description
> of the proposed changes which doesn't refer them to the minute details
> of the ongoing development process.  A process which is utterly
> uninteresting three years from now.
>
> IOW, can we please have a complete and standalone description of *this
> patchset* which doesn't refer to earlier obsolete stuff?

Hi Andrew,

Point taken. You are right; the cover letter should be self-contained
and stand on its own for future readers. Here is the standalone
description of this patch series:

This series introduces two connected infrastructure improvements: a
new API for handling private linked lists, and the
"File-Lifecycle-Bound" (FLB) mechanism for the Live Update
Orchestrator.

1. Private List Primitives (patches 1-3)
Recently, Linux introduced the ability to mark structure members as
__private and access them via ACCESS_PRIVATE(). This enforces better
encapsulation by ensuring internal details are only accessible by the
owning subsystem.

However, struct list_head is frequently used as an internal linkage
mechanism within these private sections. The standard macros in
<linux/list.h> do not support ACCESS_PRIVATE() natively. Consequently,
subsystems using private lists are forced to implement ad-hoc
workarounds or local iterator macros.

This series adds <linux/list_private.h>, providing a set of primitives
identical to those in <linux/list.h> but designed for private list
heads. It also includes a KUnit test suite to verify that the macros
correctly handle pointer offsets and qualifiers.

2. This series adds FLB (patches 4-5) support to Live Update that also
internally uses private lists.

FLB allows global kernel state (such as IOMMU domains or HugeTLB
state) to be preserved once, shared across multiple file descriptors,
and restored when needed. This is necessary for subsystems where
multiple preserved file descriptors depend on a single, shared
underlying resource. Preserving this state for each individual file
would be redundant and incorrect.

FLB uses reference counting tied to the lifecycle of preserved files.
The state is preserved when the first file depending on it is
preserved, and restored or cleaned up only when the last file is
handled.

Changelog:
List-Private v2:
- Added a Reviewed-by from David Gow.
FLB v9:
- Addressed suggestions from David Matlack and Pratyush Yadav: added
  booleans to track if an object was retrieved and/or finished.
- Modified the patches to use the list_private interfaces.

Previous submissions:
List-Private:
v1 https://lore.kernel.org/all/20251126185725.4164769-1-pasha.tatashin@sole=
en.com

FLB:
v8 https://lore.kernel.org/all/20251125225006.3722394-2-pasha.tatashin@sole=
en.com

Thank you,
Pasha

