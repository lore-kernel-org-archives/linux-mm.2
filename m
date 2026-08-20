Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EC3EC5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 23:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613476B0095; Thu, 20 Aug 2026 19:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C38B6B009B; Thu, 20 Aug 2026 19:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B3076B009D; Thu, 20 Aug 2026 19:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 230BA6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:22:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5624A2E16
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:22:32 +0000 (UTC)
X-FDA: 85123224144.28.3264563
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id E347014000C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:22:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZJ6OEwzQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=imv4bel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787268150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=asT9cPmve6cmTnJFVNwrMzNjDioVMv1LtpS8TRSCILE=;
	b=bWEc2oz3qWkY+RiL5yhBViHUCQxXMnZz16i8eqdDuS/iGBIBVjVpTOk8WTtD1T8CQkQU8N
	8lkLAToRzAljDg4IaBE7Lt8+hFdgExzpMRXp8chXqUzoD5gkix0Amogh6vtlYxZGOXcBm5
	P8JfNv7855NEAB/laBPYsw0bkhR1iAc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZJ6OEwzQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=imv4bel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787268150;
	b=NPq5tfDUzBDv2Jv8+LQ8mo1uWSuABgBvg1I9da87e1/2O3/VyTlKmwBI3dxjfaPQhl2x0f
	5AEqO8glrw/2MZw8NFJLOpqDRQRlnagP8WBHdI9hTobGE9ldPh7MxP5a9SuPmI7NdN9iUS
	Xq8tQsV7E/B9O1AU5nFU2ArP13Zskw4=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ceb096e675so5399515ad.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 16:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787268150; x=1787872950; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=asT9cPmve6cmTnJFVNwrMzNjDioVMv1LtpS8TRSCILE=;
        b=ZJ6OEwzQ6IP9jjCxnmIqtRDfGpIm7gtvcq6mBHuil7kWEesAdwdnCVDToywLeB9326
         DIxAAWitOcoLYhpV0HTwR/+jdf4J5MbMFHeofFN/QHBfx4SkDRhwWELvZQJM5DMDFwak
         I4q3vJd/36RKmMO5isN8VTq93vMY4G6Cs5KDv4D1Ln64iFMX2aHFtiMi3cHi4pFMO8aJ
         oHSpea8FJBTKb/KGt/RRmykdEfhizAFWka6L3SsDkjjELN/cBVX1jHLovcJ70XhbaKyn
         L8zT5HWcunCGnNhTi4WSVRmslD7mwHU+RSymeVIwe+4/zj0hcTlzQA+gO49sfM51N33X
         kAVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787268150; x=1787872950;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=asT9cPmve6cmTnJFVNwrMzNjDioVMv1LtpS8TRSCILE=;
        b=E+toM1GpxAor8GSB7KrjHzfJh0iip6FoeuS/nlZeAJ7RmWGtoNTHk8mFsoo/yKiqAN
         GlDbdPTyLC+QOh+hFi7Vg3AHzyyIGx3LN+/RG72IulekKrjBdp+T3k27oMdItB2wNedK
         otqQzd52bPB/M8VoJh4GacVTdWpWWGAg8Wx7uHX3hpZWZD1xJCbeEzkNVXvnZGowiFKD
         J54owMGR7nSl2WyzcJZ1Pp/xESboQCLfaIS8o9HDL4bDgYZhATnKnw39FpmUCNZrfVcm
         lOeV+SbhEbC9gZafpr1mb3k6wmoxajFC1XIix+KCrHOEynQTqaIPT/n+5psL3BYvFCig
         jJPQ==
X-Forwarded-Encrypted: i=1; AHgh+RrXhQ0wZ7Z3hPCuKJuUxMi/ibYTF/dwi9aDyhejshIZs+rxY2DMwM0x+9uTc0pMM8CzXI1IzPOe8w==@kvack.org
X-Gm-Message-State: AFuF++mWTqv7p8YtUqXJ/+PQWSIC6DS8WPKoU4N9xxAMkenv/I7XisQ6
	OWU61YNLJW/kmTUqnx2TCpSU2G0wHmaRp5V0l9zi+rEaByQHxMEjIgeH
X-Gm-Gg: AR+sD10GO31SlGEK7TaCvvNmQ5BhrsjpWUXJ1e2nyCbvg6iypOF61ysZ3kFc7j5IqD6
	wkQULTxtS+KPIF7GpH8NSzrly3Jg2EeuTJ3/Gd1Tu2w/vRXpWpIEiX0Pf2pdYAAldO8taNgxfvg
	4LpNeHomxoApxcvVVS83FJ9JIydva+P5YuRX/eavAsjaEamMvWcWIN55eX0H/zR4T1NxxOBYqZh
	0DM+ZkT4ZVbAi9iLYqzplrz7E7ovvcsSksAgyWJCvKGxm/UcngPpCQqAktA8PcdLX4l9eDkuRnh
	P1iOhWtjE3GdITPMpvK0vFqLXNW84ZYBSBzmfB9Sed8Oi1Z9mCElqdyu9d8iglASKV7tQyWbBAz
	wo4y1MJnlRm3zpcDYYq63WAZnjj0i8hay7KWXrhdbekHWNvpc4+q4qfjm+/DxCbEcR7xJ9QWtyp
	gFU8H66UDLG6VAwzUGlq8cmiEBWUGIyn8WfGubrxkkrXfZFXuPNNp2qTAucZtHRKKTm9NsOEz3s
	Nsmwmia
X-Received: by 2002:a17:902:f552:b0:2d5:e3ce:3988 with SMTP id d9443c01a7336-2d64affbad3mr33244775ad.11.1787268149534;
        Thu, 20 Aug 2026 16:22:29 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62d5ae4a9sm12747335ad.32.2026.08.20.16.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 16:22:29 -0700 (PDT)
Date: Fri, 21 Aug 2026 08:22:24 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, imv4bel@gmail.com
Subject: Re: [PATCH v2 2/2] selftests/mm: add stale walk->action race test
Message-ID: <aoeMMPQao3cyMm4A@v4bel>
References: <20260811161949.3879321-1-imv4bel@gmail.com>
 <20260811161949.3879321-3-imv4bel@gmail.com>
 <b27f03ea-414a-4ae5-9649-2a05398fe082@kernel.org>
 <antoRbvwXVxoQ7Dw@gremlin>
 <0ec056ff-222c-42a4-a737-0bd65d1f0a93@kernel.org>
 <aoNFmM1Ozt7PaOaJ@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoNFmM1Ozt7PaOaJ@gremlin>
X-Stat-Signature: jht6uu1ra9pn4zuisgdpgsxx1e8yt8ui
X-Rspamd-Queue-Id: E347014000C
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787268150-942054
X-HE-Meta: U2FsdGVkX18mvGRvAd6acnI/Q+DGo3lQII4s9sG3f+ZPq9k52FhdjLFGiaZO1SKYdmXL7+v9t89ej94Z8o4WjSPa7cwnwjZXDmBrrlKmCW6G/X6w1vtBsEIdJvJo6MgasZiRkyNSJ1XBYurjzPbVv5lN0t4eUSIdtPJe+22V/o7eQpNFlVIHg4M+cLFtX3XjR7m1m9yNZ9qphNqe3kaNzZXfKQW4BnJlHQQaFvhYqYyBVRgBI/A/XXnkCgGmAgyCI4okh5afoJxkDxuRY0xL6t1Tfrxsj9N2dDwtcsrTbg/M4VVJJ8yi4yRU4nqSPHvjwx61cObhN88pJqFKeis6EwU23gPLG0goFTPgS0XY+U1IHrTNFRPICD0HGFaBYHv7cVPnpg7wZGOzmkCSeZtCk1CcoyxwrrEl1JQexmKQBmTiMlXEEJwDxt/Fu2Np3Tts5as75Jhk4kKx3MfgnLxxQ4+JIJ4oMK6FIFfwRMFjoaS9J1pRhivZmgXlUPjmWNuLVLfhk6PCeYpByG16vA9Cd69DC5fVYNTF52RItj2O3cpR69w5zE+iqYblw5DVf48B0xJPjAvir16to37jRs8D0LxsFeBGfE0766Tc+cjotjnNzKlNWfdN2TpXuEaoTcoPWYzDZIUUV6bu936eElVkMglgebIl9NEjb9iCEL0i8Us1ObTdEP3v+Z/HI2Wnuc/vP8lM/WlRXFI5j6aKSme7iy4AzLvLc8PsjE+8RyaFNxFi29wllpOCBgbrvenhvPPYho1jcEc2YvbTS8yrm8vBunf0r0b4Wg7ec9xqOH/6DQOEZFgMQ7TX9XsuiHXhwltNo/8s5ahGOCNmRDbl+3BEE09bEz3M4ERS//tRwbfsjm9EIGyD67gxahnnTOFBFpUy/KXAE+POYAvGjABZTsQDts1nhPw0VHUyCXNSsE1pZZ5Kp1kim/2LbFsn44DBYV3lD/S7pk6bqKNXS3+mTuu
 NufjAjHi
 1eYlvI+MMDx/T1LQ2lSRTi18jxsCjXZB6qfgoYOYIOAlGLjUEq0TpUKUXKX1slmGQl/qGR0GElSV4TH9jaHaJ2bNJewyGdXC9TGSwdzuJP+5IYuPwU8c57nKY5r1k1NEBMGRATNuwXuCpL87EgLFftnfx72mQyB3a4j2Gou5S934V658buVjVT7UBvcFPLE2qC8hNY4hIvqMJ3/GIf2kzJboJsiAx4o6U+Wr2vn7DwkyMs8Qh52vJfs+1ljydpyhLk2mNNqcwhLSMXN+17kZ2HfReIaBGXGru0ir0arNL3y6Nqh7NkDYm7SQJTjOy31HzNSjnHNmkkcR5/Irjfyh5ZGOOy4/iPirMxIdFymupWQO3YJ4ptHxYBFbv9kNvFTu8BS4eXABLbrsAqyGoZJn5Rho31Clo/qJpoSworI0AU+Em5/Y0KdRtGK5c39cOlOIvoOTEPXmheiipvoQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 06:32:21PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 11, 2026 at 08:49:46PM +0200, David Hildenbrand (Arm) wrote:
> > On 8/11/26 20:23, Lorenzo Stoakes (ARM) wrote:
> > > On Tue, Aug 11, 2026 at 07:11:59PM +0200, David Hildenbrand (Arm) wrote:
> > >> On 8/11/26 18:18, Hyunwoo Kim wrote:
> > >>> The added pagewalk_race_test maps two PMDs and faults in 2MB of the first
> > >>> one.  A second thread then faults in the second PMD and drops it again with
> > >>> MADV_DONTNEED in a loop, while the main thread reads Rss for the mapping
> > >>> from /proc/self/smaps.
> > >>>
> > >>> Clearing the second PMD while smaps_pte_range() runs leaves walk->action
> > >>> erroneously set to ACTION_AGAIN, which causes the PUD walk to be retried,
> > >>> so the first PMD is counted twice and Rss comes out twice as large as what
> > >>> was faulted in.
> > >>>
> > >>> mincore() is the caller named in the fix, but the second walk writes past
> > >>> the length mincore() copies back, so it cannot be seen from userspace
> > >>> there.  smaps reports what the callbacks counted, so the duplicate shows up
> > >>> in Rss.
> > >>>
> > >>> A failure can only come from the kernel counting the same page twice, so
> > >>> missing the race is harmless.  On an unfixed kernel the test fails after a
> > >>> few hundred reads at most and takes about half a second.
> > >>>
> > >>> Assisted-by: Claude:claude-opus-5
> > >>> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> > >>> ---
> > >>
> > >> I'm sorry, but I don't consider such a specialized reproducer for a problem we
> > >> hit once a good fit for a selftest.
> > >>
> > >> Or am I missing something, that this here is more generic?
> > >
> > > To be fair I did ask him for this. :)
> > >
> > > I thought it would be useful to have a regression test because there's certainly
> > > no harm in it? The code is very sensitive and catching a similar mistake in
> > > future could be useful.
> > >
> > > If you're sure this isn't valuable then he could just drop it, but it's my fault
> > > sorry Hyunwoo for giving you extra work in this case! My bad.
> >
> > pagewalk_race_test is just rather odd. If this would be part of a bigger test
> > that covers more things than just one odd race, it might be better.
> >
> > But we certainly don't want one new test file for each kernel bug we ever
> > trigger, right? :)
> 
> Right yeah :) sure we can drop this then. Sorry Hyunwoo!

That's okay :)


Best regards,
Hyunwoo Kim

