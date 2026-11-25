Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E7F606A339
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DQ3jrQZ8
Received: by kanga.kvack.org (Postfix)
	id 941BF6B0950; Wed, 25 Nov 2026 04:23:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918D66B0956; Wed, 25 Nov 2026 04:23:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8554C6B0958; Wed, 25 Nov 2026 04:23:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 645456B0950
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:23:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F7F51C45FB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:23:16 +0000 (UTC)
X-FDA: 85473102792.14.076C8FE
Received: from mta1.migadu.com (out-246.mta1.migadu.com [95.215.58.246])
	by imf27.hostedemail.com (Postfix) with ESMTP id A7DDB40009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:23:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DQ3jrQZ8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795598594;
	b=hbpwbJE44THSUS2ZlybWurbDLYPWP2awNClRpzNDeYyevGUhvvDknhxXTtFeLiX2Trlrv7
	n255lLTeD0f+9mz68PUDZ0l6ihWe50jQwkLnUgUYdhVW5JO2LM0obDJqbENvVT0vEuDnYk
	K/WpOPGGl3yMw1+aVhguJ7z8UKwnHvY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795598594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ti9b2g1cfFsIFQO/QqlEg6n+yVVPk0+NYlYltUymZo=;
	b=KP/rn1wi7M6gBPYMhDhhpwONalf7ZMdeSFzuHk55AXjbZktDtbnFeh80vwApbEGhIp/7Cj
	sEenEgshD6f/m4wrsdPmQVLMNnpyXOfXeGcbxBEd8b9p/8Um/wqaxSpc1WyR06I0/rWTEO
	KD4T5G63ULswAc4aQ/7EjDJWlO2VIMM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DQ3jrQZ8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DqxSNtCX+aRSNVtoSK3y0B/p6G0anqe+rBJLjrGpyYk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795598591; v=1; x=1796203391;
 b=DQ3jrQZ86nN0dkYeinNJg60b9aIM1+JiLbirQ4yTCZz9C5LkhC5treyPhh8XHMzcweNmZtUn
 LK1ykgtVIM+4rlaiUOBG4x6pGzEyJmH3f4Qypnh85d7jfoMmRcdgGcGDhCZKfj6/hB/AFAv6AzU
 xrpkzSlegxm3zg6/5NOrNdi4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e6418e1a59a77475;
	Wed, 25 Nov 2026 09:23:11 +0000
X-Mizu-Trace-ID: e6418e1a59a77475
X-Migadu-Flow: FLOW_OUT
Message-ID: <7295e3f7-1798-46ad-8213-bc426be790eb@linux.dev>
Date: Wed, 25 Nov 2026 17:22:57 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: hmm: give migrate_remap_fault a longer
 timeout
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, jgg@ziepe.ca,
 leon@kernel.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, mhocko@suse.com, balbirs@nvidia.com
References: <20261119133955.54001-1-zenghui.yu@linux.dev>
 <av94SXo6ZAU7Z5TR@nvdebian.thelocal>
 <20261124213730.a8b4f5100785a2cde54fa8b4@linux-foundation.org>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20261124213730.a8b4f5100785a2cde54fa8b4@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: A7DDB40009
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 3a8x9h3bn1g8n6ttegfnxe9qmbwkn15a
X-HE-Tag: 1795598592-646118
X-HE-Meta: U2FsdGVkX1+B97xxLzZo+VV+uUiuTyUhYRGuIVPdVZiNhQV7/duKI65U/4RHZmlVE0vjx2vk8iLeqBgYgGGFYMb9JHul9qfcyV7bH+pjkkgpq/UkchwGFlTYafmZY4P6qPLBNhoFfjAjqdF2rfVNTTsPwGcDVlYAgWlkGVn4v2rzLoUjp1nfL448oCv9MupvFOZsxpGePEqZINFzxz1OBmh1QSMxuEG3Y+oIUSKLcRgepBHa39mGklxfLrfpeALzGbdWgn3HRTloD31nKZuQdEojjjtPV63soaYZz+VqctDzymR3VPVgUxdniJFb1Roh33WqCYe/608ZeTh5Vw/swUvbB4cvezGVgmw0J8RiOvQgdxIPkHif9xs3N5+7xN6rIC+sZYpWA6Sod9ZD/CWjXz5K0P6AwmnotialGpr5r5dfOLbuJKXLRIAh7URzFbwrsU/j9BVvxB8hgvfGlmYVJct/CPxqOCprjEjao0p/0sQLdnAN+J6BrpZVUKTts2coE7ABm+/L9EoMJaeTCoVAOnIHzW1jj9uptV+f77aFh/5WfXq0ZYywoOAUEQEx4TMWEzEXJM4YWw1bqlzfK81KFcPS+/dkRn4NG8TRujk/8P+WH+7RcNNaGof+SVCB0SE9Mt8LJnGj1ZBJeHnEvAW6vlkFMlt9HscgCbKZ6cVHwTRMqs2whAf1DPz33ehGGp3AQv7iw9deB3mFqgx2IWrf53QhcVlumc9VuH1ECq2Qso1VDV4obiIum+kYKEU78Rn7JyJbWTQ80reYICcNhShN4S/J/KMG0lsub/E/gTKZqhuJuJ8U15Xxkan1ldPBEUabv7ZIJ3nEu3Z2Jn2t5KlQaRwgYX1/6q59OfPuK6ja39veogS9kJCI+N+Gy4Zam7DiAGbPSNGhV6bXN2y7uI0LhaMyPCw908g7rLE6BaujzUhFwRldPB/J7e1rNILGuQJ26FZK0PsHgAY+J9kMHBi
 ZPkTc7ab
 34GYQA4tl5Eb0/L76hyz9Q1Zl4otXh5Hchvt7zCQvGLvkm0JSjaYnr0HUQUHgEJfjt8o2R8xZfcVEqRw3fd47Hc8q2t+vEpGq6qEBnosFTigkXuUO1usKmwDadSQA0RQGYldhByr0vIR3EAfK31EanhpqhNC00RDtwVm6Ed29pjPtq4VbZhbwGYNsNMhUTFKNIAr2Ag9ZId8LexZg4IBJ07K7XXj1pvLsCTb73zvuD372fUnvXmhz7W/bL2Rilpdg/LmzcA6UAiOM/tTrb6vlcmAm21d3tKeBCabU+Ty8pdUSmJxLmVTIZOl1ZEdfTu6Iv1evJYG8c6QTj9TVaNauv9uKEj+xTudOZw8BPavnbeG1S5IHBY+iElpsQqRa8fADvCRMkZnFg+vE3veXkMWNPuJF47/H7mCm2CXyDrSQ0mJutDC/BvcBFn3XfHjpiSlv/4Dj+m6kYh+r71xXSaXyGDhyK04UuwVESJ2aQAKvZoPdZDVT3GsDGeLyFTVMGMJ7c63Mvtlfgxk6TyeXAbcgMOYhU5KCA9RV0G9hhuAhHrP8+Z8zJ7tchBiT3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

On 11/25/26 1:37 PM, Andrew Morton wrote:
> On Fri, 20 Nov 2026 09:31:23 +1100 Alistair Popple <apopple@nvidia.com> wrote:
> 
> > On 2026-11-20 at 00:39 +1100, Zenghui Yu <zenghui.yu@linux.dev> wrote...
> > > From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> > >
> > > migrate_remap_fault sizes its working set from the PMD page size and runs
> > > 24 combinations of migration/mremap parameters.  On arm64 with 64K base
> > > pages the PMD size is 512MB, so the test churns through tens of gigabytes
> > > of memory and takes ~32 seconds on my test machine.  This just exceeds the
> > > kselftest harness's 30s default per-test timeout (TEST_TIMEOUT_DEFAULT),
> > > and the test gets killed with "Test terminated by timeout" even though it
> > > is making steady progress.
> > >
> > > Raise the timeout to 120 seconds via TEST_F_TIMEOUT, so that the test can
> > > run to completion on configurations with large PMD sizes.
> >
> > I guess the alternative is to reduce the number of test combinations, but that
> > seems like it would reduce coverage so this seems reasonable. Adding Balbir to
> > CC in case he has thoughts though.
> 
> 32 seconds is just too long.  We have ~1200 seltests!  Imagine if they
> all did that.
> 
> Can we figure out how to make this test a lot faster?  I slop-coded a
> thing (below) which halves the runtime but it still needs to be taught
> to do at least one full-PMD MADV_NOHUGEPAGE run on systems with a PMD
> larger than 2 MiB.  And 15 seconds still sucks.
> 
> See, if running all selftest takes multiple hours then lots of people
> just aren't going to run selftests and that harms our overall project. 
> They need to be snappy.

The good news is that it is perfect on the popular 4k-page-size (and 16k)
systems, and 64k has not been tested much yet ;-)  There are still some
failures on my 64k machines that need to be addressed.  I just haven't had
a chance to fix them.

> 
> If we can't do this then I suggest we find a general way of excluding
> exceptionally slow tests from run_tests unless the user explicitly
> passes some --i-am-very-patient arg.  But that's out of scope for this
> present timeout issue.
> 
> Zenghui, are you able to figure out some way of speeding up hmm-tests.c
> to avoid the timeout without compromising test coverage too much?

Since Balbir volunteers to deal with it, I will test it then.

Thanks both,
Zenghui

