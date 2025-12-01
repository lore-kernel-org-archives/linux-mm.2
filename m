Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D226D116E2
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 07:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3E46B0006; Mon,  1 Dec 2025 02:13:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D74F56B0011; Mon,  1 Dec 2025 02:13:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8A9C6B0022; Mon,  1 Dec 2025 02:13:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7F1B6B0006
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:13:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 683ABBBB35
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:13:28 +0000 (UTC)
X-FDA: 84170036496.29.40E49A6
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf12.hostedemail.com (Postfix) with ESMTP id AF9E140012
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:13:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf12.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764573206; a=rsa-sha256;
	cv=none;
	b=dciyawZ22wpmzdNw7uoEKVnET05vEoTxxluOkl+QAXXcPkPbcFIDociG8t567qV/TQdqz+
	KfSoex+92OGTG5u+Plggy+C0TvBDXZmsQnLU/TvTrJfVHdEhtlHU0ps2FP36cwhd5sziv4
	sSg7gmwfeUsOqFiqi5gEdlwT2jA+9AA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf12.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764573206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WFLM0Bti8oam3KIh06SJIzl+iipcMH8RHY8ma7FnqcY=;
	b=oAZEfGfH82D5PK33S/feJboPPMMIdZcy7hV+0B5mWFcXfWt7hEwuh64/7v8vkV4kb7kxm/
	HfM0+jlQfb4TE1kiSZrX/k//zWM9BFP/qP35Xt13CxIfTWYFM3FKp6M1Ev0q0GgL5nKEym
	11p80XDvAxsEPF0e09jkzE3y8qLOU9I=
Received: from w013.hihonor.com (unknown [10.68.26.19])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4dKZpQ039qzYl9BZ;
	Mon,  1 Dec 2025 15:11:58 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w013.hihonor.com
 (10.68.26.19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Mon, 1 Dec
 2025 15:13:21 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 1 Dec
 2025 15:13:21 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <21cnbao@gmail.com>
CC: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>,
	<axelrasmussen@google.com>, <corbet@lwn.net>, <david@redhat.com>,
	<hannes@cmpxchg.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <mhocko@kernel.org>, <mhocko@suse.com>,
	<rppt@kernel.org>, <shakeel.butt@linux.dev>, <surenb@google.com>,
	<vbabka@suse.cz>, <wangzicheng@honor.com>, <weixugc@google.com>,
	<willy@infradead.org>, <yuanchu@google.com>, <zhengqi.arch@bytedance.com>
Subject: RE: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from debugfs to procfs
Date: Mon, 1 Dec 2025 15:13:16 +0800
Message-ID: <20251201071316.19607-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAGsJ_4xJ5qMght93FQOYrk1OiJTh-wFC4e8Nd4K0A156N3ZEBQ@mail.gmail.com>
References: <CAGsJ_4xJ5qMght93FQOYrk1OiJTh-wFC4e8Nd4K0A156N3ZEBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AF9E140012
X-Stat-Signature: 3zmea1sz1gasfh589cf6dmnmg4auh6yi
X-Rspam-User: 
X-HE-Tag: 1764573205-225697
X-HE-Meta: U2FsdGVkX1/FPv8D1A+kEmLMidHm4MfphL29BUM4Qbns6aCAk2j9UcZkY7WDPE4HDU2k8/26O7IokibOqVlc0tSdGVmKhiN78Ko5yR0viWCuKWwaD4IE3kc38GCDRiaZ4aEM5fEcltEibUqaDrveriljk6hvGEryWUJwVXToUNJ5Z/kdTjX5SUFIUSGehFvtc6Dc8J/UhKsqmL8KX8SqnhNr5U5k7K58w3OXQAoOTwu4c/DrLit8x49WykBYT0av/jUxqXbRIBlSqNIOPY8PcYVfQ5UWN4dXYAj1RDmGtD1ZlYAlHfdk1/Big5hlEKUV8KF6SRrrIMKRJJF8aMfCJjUSBmtQEh5YF8k1+lMXXKuhncFda7nN0puWf/UvAbGwVhIePyR5pvCKFdTMD3nJZ4ErZSBl/ZsatjEYBkrx8YeLsJ+0BXlOXnXTx0sN3LrU6BJsiytkJ7hQU24rcKJxScRptpod65ahOn8Kidt/6Dy70GoA4AA3dspAv+aEmpvyyL2BctbGiqMv8NSuxOfpxXPIoFppBUVgH9CVnmspo5DhM61MUW6K1Ii8w7cFB5ZvenwJBuruhNthoJqOEqwS8iDxAZ12aKcKDjYm6oMsaRgeoOTcWS19EqRY+YSTkpq8ayf69rBF9xECmid5ibtCNj0KfafagKdsNoNkqTZUvpQOmRSfWQGicrnaN1J791e9JfVIq1EZGHD8BBQ0k1e6teMzdxj+jC6hCvj5IVldaW3Rp0BAmkDRhXjAAcPUCzETMuA1yohmeULrapEtal35GhsWHaIg9tunBIQ2+b0soKecYo8HlRmUNs85+OlF+gvpnbuYoPPbczJXtaOiQ/LNzZoS/D0SQa371gMVlb6Bg+UpaU8vmA7ifaDjeVYrI3i2oDe50pNol/uiBFaCooj/tCwGuyjEo3Don+uYHo/63HWP4rtcNVa8MT8ZojcPZNJFl0s7TSrD4Y55JFz/pgj
 /A6HRuFq
 KRTtL91mlBurFOY+XCvrBj3nRNKQfCsaa/kafT0U0i2SU9+hnXSjQwKHeol/+9ktQMsPURNslJUZx0skTKu9a8q6XFcv4KvhpfcyI8iqWwdiqI7VjjpEwkujRkHxypPARFRXdaQ1wcMaqJAx7dMwkRE/VkJFJdDpH+KSeUIjCLBH9mgnk/UWzAkQYTCNdab08GbrpyJLGRDHsOfSwg7UvuhXyVp7TCqzYppu3AnYhOJvwKJf8WObkzOBwrHv//ppkhWLzDlkRp1LqH9sbYsyXkuWFxAh+FYrC9MpGTIEMSox35ZIUzX5XbX7L1ggEq5ClHXSd9OFXmULBFkmZcavnz+gmCWDPV8Y75oA6z2r7ox3F4MA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hi Liam,
> 
> I saw you mentioned me, so I just wanted to join in :-)
> 
> On Sat, Nov 29, 2025 at 12:16 AM Liam R. Howlett
> <Liam.Howlett@oracle.com> wrote:
> >
> > * Matthew Wilcox <willy@infradead.org> [251128 10:16]:
> > > On Fri, Nov 28, 2025 at 10:53:12AM +0800, Zicheng Wang wrote:
> > > > Case study:
> > > > A widely observed issue on Android is that after application launch,
> >
> > What do you mean by application launch?  What does this mean in the
> > kernel context?
> 
> I think there are two cases. First, a cold start: a new process is
> forked to launch the app. Second, when the app switches from background
> to foreground, for example when we bring it back to the screen after it
> has been running in the background.
> 
> In the first case, you reboot your phone and tap the YouTube icon to
> start the app (cold launch). In the second case, you are watching a
> video in YouTube, then switch to Facebook, and later tap the YouTube
> icon again to bring it from background to foreground.
> 
> >
> > > > the oldest anon generation often becomes empty, and file pages
> > > > are over-reclaimed.
> > >
> > > You should fix the bug, not move the debug interface to procfs.  NACK.
> >
> > Barry recently sent an RFC [1] to affect LRU in the exit path for
> > Android.  This was proven incorrect by Johannes, iirc, in another thread
> > I cannot find (destroys performance of calling the same command).
> 
> My understanding is that affecting the LRU in the exit path is not
> generally correct, but it still highlights a requirement: Linux LRU
> needs a way to understand app-cycling behavior in an Android-like
> system.
> 
> >
> > These ideas seem both related as it points to a suboptimal LRU in the
> > Android ecosystem, at least.  It seems to stem from Androids life
> > (cycle) choices :)
> >
> > I strongly agree with Willy.  We don't want another userspace daemon
> > and/or interface, but this time to play with the LRU to avoid trying to
> > define and fix the problem.
> >
> > Do you know if this affects others or why it is android specific?
> 
> The behavior Zicheng probably wants is a proactive memory reclamation
> interface. For example, since each app may be in a different memcg, if an
> app has been in the background for a long time, he wants to reclaim its
> memory proactively rather than waiting until kswapd hits the watermarks.

Yes, we need a mechanism for proactive memory reclamation that supports
proactive aging. Zicheng and I were just discussing this issue, and it
seems that supporting proactive aging during proactive memory reclamation
(such as reclamation of only anonymous pages) is a better approach, which
can be enabled by adding the parameter `force`. For example, the following
code, though it has other details to handle...

+static bool proactive_aging(struct lruvec *lruvec, int swappiness)
+{
+       int type;
+       bool should_age = false;
+
+       if (unlikely(sc->proactive && sc->proactive_force))
+               return false;
+
+       for_each_evictable_type(type, swappiness) {
+               if (get_nr_gens(lruvec, type) != MIN_NR_GENS)
+                       continue;
+               should_age = true;
+       }
+       return should_age;
+}
 /*
  * For future optimizations:
  * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
@@ -4845,6 +4860,8 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
        if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
                return -1;

+       if (proactive_aging(lruvec, swappiness))
+               goto aging;
        success = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);

        /* try to scrape all its memory if this memcg was deleted */
@@ -4856,7 +4873,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
        /* try to get away with not aging at the default priority */
        if (!success || sc->priority == DEF_PRIORITY)
                return nr_to_scan >> sc->priority;
-
+aging:
        /* stop scanning this lruvec as it's low on cold folios */
        return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -1 : 0;
 }


> This may help a newly launched app obtain memory more quickly, avoiding
> delays from reclamation, since a new app typically requires a substantial
> amount of memory.
> Zicheng, please let me know if I’m misunderstanding anything.
> 
> >
> > [1].  https://lore.kernel.org/all/20250514070820.51793-1-21cnbao@gmail.com/
> >
> 
> Thanks
> Barry


