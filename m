Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D596FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 10:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CB796B0005; Sun, 26 Apr 2026 06:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E296B008A; Sun, 26 Apr 2026 06:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6904D6B008C; Sun, 26 Apr 2026 06:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 593F66B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 06:58:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0549A16063B
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 10:58:49 +0000 (UTC)
X-FDA: 84700409178.08.347AA20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 397C480004
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 10:58:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wnu5Bxw9;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777201127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yylVdHuN9loGbs2xaXe8v3+H0jAXSYiNRqdR2l2lfjE=;
	b=znGMQkcoWW3RV5+N6tMqonn8uBB+yhOIJIkkXCqEGyI5vrlCITKa9zN8xtqn8V3FOw1naw
	OrgdTBw1DbCBQxblxbOefDdP8N/W0pYwMh8f5YXHNfXIY4UDn4BOSs35fG48EaY65UC5y4
	uro0wJo5vWlEMNLlaXUyCB7gmGgvU/k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wnu5Bxw9;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777201127; a=rsa-sha256;
	cv=none;
	b=aTq3sNJLjAZ2VYp9/BvwibQcvtCjdTdLaymmkRO/ua8B3dQYLZzg85k9joWEgooENniC/n
	RYCLVO3CLMDlIRXdvmH2ghyjAbOChcM/fPylVLV/qTjjg4xGWPAdAhdorZAgKLeNvlRDVR
	yYd/cJJ44hTrduYQwfvLMYiuTUb96hQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4977644150;
	Sun, 26 Apr 2026 10:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E58C2BCAF;
	Sun, 26 Apr 2026 10:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777201126;
	bh=mkkI+lXLMcbjVq5S0Bvo04h/9+PSK8v/F/iMiEKV2hw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wnu5Bxw9rXhG06Go4iTyIXSDOa+mQ5Vuu2x0WHdRYrvoFnHH8SvqFaqyGi8gZnfVo
	 rNrEaLATkeLJzBlaS3huZSg8pXMz+mRx2XfDidb3Qn8wuf9FIdcPGMbcMlKHRbLsIF
	 E/kS3AB1tFWbeLsalS98galB73i4pxITt073G4egUeROdOZNeGDZUwaT0PwzBnkZwE
	 0xkD+IXZgCO0mRqAlvM3b3vbghe88BhElPmyJNMqLHD4jpAauJLh6RH7fFMRhQWwbT
	 L/MsSCciy6r5SRfd7MvXPhp0f8/59QbjoHOndQxh21dBR10JVBO9nc14+jdaSl/HFY
	 bEwxkaQZuafCg==
Date: Sun, 26 Apr 2026 12:58:29 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 43/53] selftests/mm: migration: add setup of HugeTLB
 pages
Message-ID: <ae3v1cyMLbcvJtYW@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-44-rppt@kernel.org>
 <a8510cbd-4a30-460c-b870-a250ceb8a522@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8510cbd-4a30-460c-b870-a250ceb8a522@redhat.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 397C480004
X-Rspam-User: 
X-Stat-Signature: ru4zfxe1z1sxbxtgtbdz35hc9637m8ga
X-HE-Tag: 1777201127-956266
X-HE-Meta: U2FsdGVkX19OX3orshFmD1zhOGx21Fpg4J6EgFRTcWISH/UiWhW/Rxzj6h4+ZtIZzDwB2Xgx2p6S9tenP6gUK7w1sw9pE6C3OtSs7oTiZKQdWVZLAZJRpGMUPX2hsWgOEEs0zOC27yv4XxxIQjHyDrs/FpuLc/qadtVM00fbEndGOCKGuLFHvmuTCFdJ1HCgRbW1CMn32e8eh+VKHjdZZtg8K2h8doYcc4gOcRFZWtxEkwg2n+dJ4RfD5fAmTeUfak1me9nbVNM0ntTCQd9Lu56TwebVxsd5M1g8jXzvm9S2a0HIOBpOBBRAr4pVXkdBBtT7J4k0/ZHXFJHfqpJ4u2kF1Ig3Y05FslGDp/zmFFFqRSSnRUktT7X1gCxTvjRY+XS4Yn5AMwtCM3tDf+gRN8MmAhH7Z1xpzO5mCTo06n2anSzwOZFSn8OjAorSfpOgEpHp9lJdBpMNqA5h03jHktt4TiQKIRzSmaMxpRiMpsdhF7V9QlosTNOdhCo91DWoyruScmsGJnw1iQ0eDGIvsXALxtImDpeOgk6C00svB662cNvl/gRsBJzhIWS2RnTCXAoqu4KxaFGJ7/xgbjx3YZAeKiXVT3SxoZ7TZ3F4T8kFooPrp6JlxkT3W4KXD5+H9GCfQlgy1ewj6Uw1LH9fJ3gO93BkM7kcXp6Uh4HWeHj/l+hdwrCpVZ96YWuKMHxDr8i76I4oXUkNAJu7qGCbTSsfyiUeJSRmKpg5Msa/Ac6WGuSMMtmat2UGNmPwPWe5NG2IJ4cslt+c1G8ng/CtGTVlhY501z+vjB0+rMYArUaiKNQrJnpYmWR/Myh7Eqwwo8XoSTwUSYQBdC47LEUUp4sGeqTbPF6UVfDhIDQ2sz6nrra+JeghzO+bt7+nlifMrSjSDZBFEythsWZhyRLbgb/Rx3OW9mEbk7dfXvbddTmbn78sYEZh9yqr2vLAZtaByHcFaLrNP9ZMldr0gwT
 NxQnuLBe
 JRBEwja8AP/sVi8EIhZD4bAhLc4JSbk0GQ7fIHUXeVL88wQ2a/D5yV+ALEozv4wd+XPU38kOUdWQ/7fI9RH5XN+wxSzw1XPC8I/Mn7vQuAU2AZM2j9tvi2Z7k2zTUb3GwVi05JC1B2uV90CckTRPaotRml8UzAajLHYSAhtOoSnTvxJMgms/Y83xa4PrEmIrMSIKZTxtreM1kMoBEklTSaAOwPxytfggDrAtLlaoKRvfsuKrb8EpXK/7NIuEI1lBSIjoZHI/4JR6J4ijTRIAw3Z+7ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 01:11:45PM -0400, Luiz Capitulino wrote:
> On 2026-04-18 06:55, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > migration skips HugeTLB tests if there are no free huge pages
> > prepared by a wrapper script.
> > 
> > Add setup of HugeTLB pages to the test and make sure that the original
> > settings are restored on the test exit.
> > 
> > Since kselftest_harness runs fixture setup and the tests in child
> > processes, use HUGETLB_SETUP_DEFAULT_PAGES() that defines a constructor
> > that runs in the main process and add verification that there are enough
> > free huge pages to the tests that use them.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >   tools/testing/selftests/mm/migration.c | 8 ++++++++
> >   1 file changed, 8 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> > index ccf42002ce86..61fb00953f83 100644
> > --- a/tools/testing/selftests/mm/migration.c
> > +++ b/tools/testing/selftests/mm/migration.c
> > @@ -23,6 +23,8 @@
> >   #define MAX_RETRIES	100
> >   #define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
> > +HUGETLB_SETUP_DEFAULT_PAGES(1)
> 
> Hey Mike,
> 
> I've been reviewing and testing this series and got a reproducible issue
> with this test when running it on a x86 KVM guest with 88 vCPUs.
> 
> The issue is that, when executing the full MM suite with
> sudo ./run_vmtests.sh -d -a, all 6 migration test pass but it doesn't exit.
> Instead, it gets stuck after this output:
> 
> """
> # # PASSED: 6 / 6 tests passed.
> # # Totals: pass:6 fail:0 xfail:0 xpass:0 skip:0 error:0
> """
> 
> Getting a backtrace from gdb I see:
> 
> """
> #0  0x00007efd2f2c247b in __lll_lock_wait_private () from /lib64/libc.so.6
> #1  0x00007efd2f26fa88 in __run_exit_handlers () from /lib64/libc.so.6
> #2  0x00007efd2f26fabe in exit () from /lib64/libc.so.6
> #3  0x0000000000404f2e in hugepage_restore_settings_sighandler ()
> #4  <signal handler called>
> #5  0x00007efd2f32f416 in __unregister_atfork () from /lib64/libc.so.6
> #6  0x00007efd2f26f338 in __cxa_finalize () from /lib64/libc.so.6
> #7  0x00007efd2f4548c7 in __do_global_dtors_aux () from /lib64/libm.so.6
> #8  0x00007ffd66ae0320 in ?? ()
> #9  0x00007efd2f55b2d2 in _dl_call_fini (closure_map=0x7efd2f5500c0) at dl-call_fini.c:43
> """
> 
> Could we be messing with libc internal state somehow? I also get systemd
> services hung when I try to reboot.

I don't think we are messing with libc internal state, but we surely leave
zombies around.
All the tests that fork() terminate the children with kill() but they never
call wait*() to collect the exit status.
 
> Some of the migration tests fork() and then kill() their children
> processes. Won't those all restore the hugetlb state concurrently
> from hugepage_restore_settings_atexit()?

Yeah, I missed the kill()s :/
 
> Also, for shared_anon_htlb, don't we need to reserve a HugeTLB page per
> children?

We only mmap() a single huge page in the parent, the children don't create
new mappings.
 
> And there's another issue: when running the migration test individually,
> private_anon_htlb gets skipped. I guess it's because the previous test
> is restoring the HugeTLB state:

It could be.

I pushed the updated version that has the fixes for both zombie and
signal issues:

https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=mm-selftest/v3

Would be great if you can test it in your setup.

-- 
Sincerely yours,
Mike.

