Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC2FCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 16:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8037090025A; Fri, 15 Aug 2025 12:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB08900256; Fri, 15 Aug 2025 12:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719AB90025A; Fri, 15 Aug 2025 12:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 61264900256
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:32:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D1D681A0201
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:32:20 +0000 (UTC)
X-FDA: 83779534440.26.DBDF36E
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf22.hostedemail.com (Postfix) with ESMTP id A9AD8C0005
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:32:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf22.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755275539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+cz5iYdOkIO13C9Yo6dYSPZaaeMSez+2fjh7J6mfVCw=;
	b=sbsnV2hp9LQsm9ILnQZkN0XIW0cYRdnWD6foRH7MR44cWNUkBvNGdbvjhAoBd125cxHaBt
	RS+UaCV9Cx0YfPTwadAkHaLwiImQJTLLRZxGbcb1c30Th9uqbv3/gytKqD1nEaFkT9ZjET
	AcV8iqWE+iX+KxPr2a7ghUexZLknQmA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf22.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755275539; a=rsa-sha256;
	cv=none;
	b=JmJEcD+2hO4wSJGEkX2FT0MeaUHCQdBAhiSTjLpzr6fYYwue9nZluVpEQG3GXQyH7HE0Th
	UHDEf11o1BQIfBxxIO9V7aQy6gJY6fK9wQDzEwFMBS4ZMmNU2loz0sKe/z/WZejvk15P9Z
	eEU0i15aYvZj/zma/Fqgsx1fxgEj9UM=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4c3SLW0yd1zYmPdg;
	Sat, 16 Aug 2025 00:32:03 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 16 Aug
 2025 00:32:11 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 16 Aug
 2025 00:32:11 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <akpm@linux-foundation.org>
CC: <andrealmeid@igalia.com>, <dave@stgolabs.net>, <dvhart@infradead.org>,
	<feng.han@honor.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liulu.liu@honor.com>,
	<mhocko@suse.com>, <mingo@redhat.com>, <npache@redhat.com>,
	<peterz@infradead.org>, <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<tglx@linutronix.de>, <zhongjinji@honor.com>
Subject: Re: [PATCH v4 3/3] mm/oom_kill: Have the OOM reaper and exit_mmap() traverse the maple tree in opposite orders
Date: Sat, 16 Aug 2025 00:32:07 +0800
Message-ID: <20250815163207.7078-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250814160914.7a4622ae1370092dde11c5f2@linux-foundation.org>
References: <20250814160914.7a4622ae1370092dde11c5f2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To a018.hihonor.com
 (10.68.17.250)
X-Stat-Signature: 1sr5o3s595rrzj67ebhcmfw4fcgu7n75
X-Rspam-User: 
X-Rspamd-Queue-Id: A9AD8C0005
X-Rspamd-Server: rspam05
X-HE-Tag: 1755275538-805003
X-HE-Meta: U2FsdGVkX18IPGNANv9YFWkxpuzydpqcihHFY5cnN4XzYj8/cohNDXUTyEHcT3wasVNUk7ap6PgnO6VCFsC9bOCIFfbwh4RlawyEC3W0SneLln1vt3WwRExTn7w+ZYsgKLrybvYP6+ma/3sqS2Ng9HqltyCnkn47tE+EFth0AXIOyoIu76vw+RnQhSx2Jw9wX+g3n+3VXMBaHPhcAgSypmMyCqZ+ULBrUCLw06U1iCvXr/Cy/z8lsqYCdhtroL5dGfz06RbOriSFBH3Ex701Tddu0rjJ9lTBuADaxRX1fetk2gdc6KRh0nHYnsYeG1IY+609QeeK5jIadykGX5wNTBo0ESHqV4yEIkSDWraurEra2PDJpBWIdq7Oyv7ugdvI6mdYqxv9w4LQfa1gJ1v6V1tRHQCCQ2L2Na7PDUfX6HzmtUF52EVx8bjO3QliXGjJ/JjTURdhJzBrJZuxdW2ETajcP9SCPCYkCo6Ai/ogIRFNw1MkZR3e6cuZ+7p25kMneq5IofJlIOWN8UfFNpnfblshSDvJLrHnAZI6B/p2tbFD8pRa90gsB+4CYfQYH2ryQjMCMbTzFXoDZ8Tp4cwvrS733fwZJt1UW0mwEo6R/Hahm3bYG5fHuL5YkH5INnPZGBP6rP/fsd7uBpr5Y9XaQEVj1mRiOYrWkHd/f/pPmOZzQoFFftRFPspMsC3q/5D10S02RP7cLSo9s2FYSZylY0jrYqTYeTq5CEAccr95+SPTkop2zbqPlHzLyc3GIfLqT/oesA+LgMHNgi8KpEZ5iUXMxfIQiTpJKto/X+GQForfitEdOu4gE9QvC/SIpoDMgm95DQqwVOm+LownTqbZrmJlVR/D7Hke2xVzz6paXxMhjiD5eIqiKLmFND9DFcGSJoR7Sa/Irpycm7t/hN7XihLccDs8PMBNLIlIyUqVtxAwLeqNGz7U70jaPNd1Gt4DO0loSHelZkM1T89B0YR
 hxleuGgi
 /H2iIYR4+T1DRjCfQAbyNHw3v/Pmt9Svj3Fu3EeA8jwQgx5r1yWbSsCk1gi+RolSXc3YT34xEbLLDcnBG8lI6+7M2n81BxAPJDch50hjWM/0T9RxBW3bAT1OmndTLCGxju0Dpqm41f1SAmgptSXKMbmnt/4h6En78dVf+Kidmy8kE/3QBZzXwMXDOC85oIUA0j5QHsadludDQMf+9yRTxmDUqUw1XICjF9Ybe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 21:55:55 +0800 <zhongjinji@honor.com> wrote:

> > When a process is OOM killed, if the OOM reaper and the thread running
> > exit_mmap() execute at the same time, both will traverse the vma's maple
> > tree along the same path. They may easily unmap the same vma, causing them
> > to compete for the pte spinlock. This increases unnecessary load, causing
> > the execution time of the OOM reaper and the thread running exit_mmap() to
> > increase.
> 
> Please tell me what I'm missing here.
> 
> OOM kills are a rare event.  And this race sounds like it will rarely
> occur even if an oom-killing is happening.  And the delay will be
> relatively short.
> 
> If I'm correct then we're addressing rare*rare*small, so why bother?

When there are apps that consume a large amount of memory, encountering OOM on
low-memory Android devices is not uncommon. On Android devices, programs like lmkd
(a user-space daemon in the Android system) also call process_mrelease() to reap 
memory when an app is killed.

> > When a process exits, exit_mmap() traverses the vma's maple tree from low to high
> > address. To reduce the chance of unmapping the same vma simultaneously,
> > the OOM reaper should traverse vma's tree from high to low address. This reduces
> > lock contention when unmapping the same vma.
> 
> Sharing some before-and-after runtime measurements would be useful.  Or
> at least, detailed anecdotes.

Here is my test data on Android. The test process is as follows: start the same app,
then kill it, and finally capture the perfetto trace.
In the test, the way to trigger the OOM reaper is: intercept the kill signal and
actively add the process to the OOM reaper queue as what OOM does.

Note: #RxComputationT, vdp:vidtask:m, and tp-background are threads of the same process,
and they are the last threads to exit.

Thread             TID         State        Wall duration (ms)
# with oom reaper and traverse reverse
#RxComputationT    13708       Running      60.690572
oom_reaper         81          Running      46.492032

# with oom reaper but traverses
vdp:vidtask:m      14040       Running      81.848297
oom_reaper         81          Running      69.32

# without oom reaper
tp-background      12424       Running      106.021874


