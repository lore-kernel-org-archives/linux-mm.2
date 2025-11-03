Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19FECCCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B3E8E0033; Mon,  3 Nov 2025 02:53:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771868E002A; Mon,  3 Nov 2025 02:53:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6882E8E0033; Mon,  3 Nov 2025 02:53:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 531808E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:53:45 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E24B513BF4F
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:53:44 +0000 (UTC)
X-FDA: 84068531568.20.6253E7D
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id EAE341A0005
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:53:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=h3xYJ3BA;
	spf=pass (imf19.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762156423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/3QOrXfaRRSLiQ4GSPcpWfsbztlf+4SFaNdg8ef6Oc=;
	b=uGeVeOr30DjNKyUO+8HzF3DPpVY3KOgojyWcL1t3JVCa96/qXOmaXZvcU15o70JTWtHJWN
	KcnOhkHtGvMuajbiDLi1oG5PHwaU3MrUCtDKEnMaj2320RQELhLnotQlw0V3EzHyH/hT7C
	gzCytvVzeSP7DvddU2KAz5wedU2aEKw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=h3xYJ3BA;
	spf=pass (imf19.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762156423; a=rsa-sha256;
	cv=none;
	b=NtBUCM5/TBxIs25Rsa1+eARIticc3O8+MzH/zx6l5btjWqN5h+Rsb4lsDcYftL0+Fq7ClZ
	JDBJP94sTIim51fGFS4ZoJ3RbNZWhObsX05OEP1s5YZRmaEUalAWqDHWvjkeRCogDv1CLJ
	9n1cstd6y/AMkPgi1BndAIm4mVScVwo=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b67684e2904so2841661a12.2
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 23:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762156422; x=1762761222; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/3QOrXfaRRSLiQ4GSPcpWfsbztlf+4SFaNdg8ef6Oc=;
        b=h3xYJ3BA6vWwEY1+Fk7kGwKih1uhmxRAbtY1WEGD9piwOYgjBF1RLp99TWgyACxumC
         wOuPQWgWIF9kMsLcpfxoVavPB15kt+qFvxFYsbG2dAMRL4SD1zOGIm3tz7dg3I7rSRGj
         mWa5MRaT+Vil0rbasp32nIQxhDtOz0XW2PvBKXDxeC00L/qVBRyqVu7hktBZb7CbRySI
         OAQ9kCV0vtnTTkTSRFDY7I1+7tpr/cknzFC5p6AqRh8KNH8lpfpjZdE260vaXQWMMK+R
         f7Zi2g0vKO1sPNdEZgXXq5Au4JsSOsGmsOUPK1FUbkclLmxyXHSx53tMzEfsF/UUsQ+6
         P4Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762156422; x=1762761222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u/3QOrXfaRRSLiQ4GSPcpWfsbztlf+4SFaNdg8ef6Oc=;
        b=d6cxaVlEvuFvxhDWhnBz4nFy2IvLHqMSgkqFs3JRzRYP1m+vfTh7m+MPjiG7oMp9T0
         i7DWReyizLExaYGRorpQtCLUZH42NL8vxUn2RU0p9D474g/EX/QVyUCzK8D2rba8pqni
         9mfvkypSpqVzXcQ9bv7hq0Qfc/7TAF6lmjjMGboMy+oYoBPXUS8fsnNKH+0/146PrUwB
         GzCSqhcWbCWaEtsQOqMGg7NZSB+StlN/fhaL8PGoJGVCl4ELOReoGE1N9ec5BH6BB/0H
         aUHIZB4WUqcW5v0pnk3f9zjbpIKa8llXLX+0lEfHSkmXKc0E6Phib8Qhe8TuWmx6qANM
         L0pQ==
X-Forwarded-Encrypted: i=1; AJvYcCWT0ukfLirB9h+PSmZzTC5QQYCzkpGvQx3xof3yac5GY6nToO2f/z9frIz86OpIgIbAMaHljIkR2Q==@kvack.org
X-Gm-Message-State: AOJu0YxNODlJcj7PzHWzl88RQ8KVHe14V2A+r+Gc0IkcW9Jr4ZYFIe8F
	J5GKtUNGY0ZiE+Q9gzINg6v+rNlnRrvL2DBV/JhOx35WbRFGMBMJuMQJz61DO7338uo=
X-Gm-Gg: ASbGncuv9MOXPOM060ZxXG7VDRe00I6x1nAakfGd554AweWk7MJw+4YIyWi44eU9tCC
	p7wvOyd7t9m+vItB1er0um7pVqMBhZfG6JnLv0uOaDsJHP4yNqjn4CthvoVup2G9ufPB1wWgq8p
	UOR5SvDI+pkfqalK8l1D8iyr4LfjgH/zQo4A9rXqNHTArz/JEPiur1FuBhCMHOtXDVutUHAqJPa
	8nmsp0lCrxVEMFbQGxSDYS7L72aFIIN/e8BGQqKIGW6mh2hM6a95wqmFqUOCs6oTlo1//isyRPU
	yKnBCwsnMqE9yfc8lNKTyEk8SveIPvAj+knSwMtljxgb3YW9qTWJtCgAlCcWfe8Zt3Pn8zJx16O
	9DHmc4wNOcIwbSv1tZKsBeaP5TtdMbslLh32UloTLLp9oFSaI26N3ko1ciNOqUhJH46/olADk2H
	vt+197qp3w9bRInA==
X-Google-Smtp-Source: AGHT+IHOYxavcvNCjMo8ESpp671IIFf4aThj7PcelCJSkknoZhse0VlY/vuaeqRwnpTxjujOeJrL1g==
X-Received: by 2002:a17:902:d50f:b0:267:f7bc:673c with SMTP id d9443c01a7336-2951a51e6bfmr165298515ad.44.1762156421802;
        Sun, 02 Nov 2025 23:53:41 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34159a16652sm34552a91.20.2025.11.02.23.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:53:41 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: stable@vger.kernel.org,
	greg@kroah.com
Cc: tj@kernel.org,
	lizefan.x@bytedance.com,
	hannes@cmpxchg.org,
	corbet@lwn.net,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	sjenning@redhat.com,
	ddstreet@ieee.org,
	vitaly.wool@konsulko.com,
	lance.yang@linux.dev,
	leon.huangfu@shopee.com,
	shy828301@gmail.com,
	yosryahmed@google.com,
	sashal@kernel.org,
	vishal.moola@gmail.com,
	cerasuolodomenico@gmail.com,
	nphamcs@gmail.com,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Chris Li <chrisl@kernel.org>,
	Greg Thelen <gthelen@google.com>,
	Ivan Babrou <ivan@cloudflare.com>,
	Michal Koutny <mkoutny@suse.com>,
	Waiman Long <longman@redhat.com>,
	Wei Xu <weixugc@google.com>
Subject: [PATCH 6.6.y 7/7] mm: memcg: restore subtree stats flushing
Date: Mon,  3 Nov 2025 15:51:35 +0800
Message-ID: <20251103075135.20254-8-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251103075135.20254-1-leon.huangfu@shopee.com>
References: <20251103075135.20254-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EAE341A0005
X-Stat-Signature: 897o8h53z68jadohfs3dnhyryd8o9jxj
X-Rspam-User: 
X-HE-Tag: 1762156422-708380
X-HE-Meta: U2FsdGVkX1+IjW/colQJ32wXLkiyGcPf9zrNNzeO+aAyqbvQYWeDRFUKbKkgRtNVEgYb8/OjvDn9lngpRwSPRI3E+xK7FQtASHtuqVF6I1yMPlsqNQ1BH190CFiq64HZhKoGtXreMhHO16B2h/K/Ikr3THc1+H1duQUr7gCm0ylj6P6AsL6ktP1K1sLFcIh9AfTxLlfuDtV5WjMR+23dhl+VHxZuFdDSxmYbYx32E4Q78y+MIzny1kbsy+hchur1Rq5/lp+jLRuL11FD4uosYjeM9QaDPtmpgkhSx2YOaEm69w68cdKndaMynQCH3q+A4Z7pf/0KzaFBvhCHwsuO9WDMYg+C384dnXsN3Ad/3YfTTQ6avSLpY3p+rH9RNbw07LX4lkqO/Wecoty3oMy2S5KWpsDmbmbZGAYmm8+preGyE1B3BAGpElSRpT5BaO/Ezm28FQntSPiQGWCjJVGOW483T3DTGHoO7DFEXlg6Gc92DilE2ghIeimDKkTPIPNsxnXoZIsXTsypkErA7yXq4vys3xr/h7sAnRPeQY60EKvMH7/Vsbf+oKKlrb3TQQR+UXWxIss1bvXOiz7hq/6CIQIwcFHbqWDk0Np+z5apKhP6OWpNSzDYsDJUX6Jz+nTPungCKDCz/dLppUKe15E//H7n+49QtAT5D3AbT2t7mbewDSwLOjvy8MrLeRW8vrweSrPAilD3QTvA3b76ul197Y4Gfs1vcnHbyT7CoQdOINwt+hvPsh+5Lj1s/lPj4/sQmFM4EqkYJtG+jSpQ1Cro/FPAlNSltm38wmlFypJrLdmX/wp/uEABEkDcIFFubDOLsUFVMpAV5SP4d3vuB12Ez6Bm+lB9YWS1RTIaG9LxScWABjwzrEE2ZGuYGrPwsPyG/+CbYUxOjrCBsC9uOOEaLBK/fShM10nQ9JtO36aht1g2aOYzLG0U4MIHQD2Ex+ul6BIyUCPXWtbBVj+zCiw
 AsfHMFBl
 8D2N7bXw12U4Q9TXtgrMu47EZksDcs2BqzORJrVD4kDGbrl9lzBhOO52OjGrigWB+TOdx51uR8MXgcD1tDnVLhlg+dgmUYKtWB6wBht7NLLKXfEm7bt1WoGcAGUzQaVyBnY30YCtKuHdvKFhtjF0P2t2KEEfXaGwY9RuJs2i6b/98eUj6WnJLX8Us3gkXZuuuTxakmSHasO8CH/P03H9RiYG4yG00pQqrRDaR1NMsnz0JtXZ43JIDgG8+6SYAebYJAFjPi95aoo+KWLmZVnwH3W/DuatxgUpun9VhNwx/FgYiJSlKhDAx41S3+Q69EOApa6tBMA11cYBYwudtS4IDM9GS2UDN79xA0bPYljBMNyUSlgmG2CgF45mipb/0DLKqQ9dJjvaAkTFA+7HJwTk7y0d9zDtlJkjEcOgfyBHwnimmT0fI99Qz2RQEl1mVsaHBf5XiN0xo/kNshCdjiJDF/uujbrfXCukW3ZHR5EkTw5Jjz4lg/g4IDZW+ATRNz9sdOkeuoYwrewPrqbNcNiya6ZNgo66G+xcbSoyCsANgho2axuRFGP3BxVpoTTeLA/8haZTxUXdw3/BTQNBSBrZIfLLBr3xUy+OgkcAdxTD/gt/1KTX8v4C9+otibMjicsp0xJT7beIeweF3tA/7kqwYKg/NKXPVeZJBGXQPDKsaU+493xNP/IdAReT+8+WCc6idLrC2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yosry Ahmed <yosryahmed@google.com>

[ Upstream commit 7d7ef0a4686abe43cd76a141b340a348f45ecdf2 ]

Stats flushing for memcg currently follows the following rules:
- Always flush the entire memcg hierarchy (i.e. flush the root).
- Only one flusher is allowed at a time. If someone else tries to flush
  concurrently, they skip and return immediately.
- A periodic flusher flushes all the stats every 2 seconds.

The reason this approach is followed is because all flushes are serialized
by a global rstat spinlock.  On the memcg side, flushing is invoked from
userspace reads as well as in-kernel flushers (e.g.  reclaim, refault,
etc).  This approach aims to avoid serializing all flushers on the global
lock, which can cause a significant performance hit under high
concurrency.

This approach has the following problems:
- Occasionally a userspace read of the stats of a non-root cgroup will
  be too expensive as it has to flush the entire hierarchy [1].
- Sometimes the stats accuracy are compromised if there is an ongoing
  flush, and we skip and return before the subtree of interest is
  actually flushed, yielding stale stats (by up to 2s due to periodic
  flushing). This is more visible when reading stats from userspace,
  but can also affect in-kernel flushers.

The latter problem is particulary a concern when userspace reads stats
after an event occurs, but gets stats from before the event. Examples:
- When memory usage / pressure spikes, a userspace OOM handler may look
  at the stats of different memcgs to select a victim based on various
  heuristics (e.g. how much private memory will be freed by killing
  this). Reading stale stats from before the usage spike in this case
  may cause a wrongful OOM kill.
- A proactive reclaimer may read the stats after writing to
  memory.reclaim to measure the success of the reclaim operation. Stale
  stats from before reclaim may give a false negative.
- Reading the stats of a parent and a child memcg may be inconsistent
  (child larger than parent), if the flush doesn't happen when the
  parent is read, but happens when the child is read.

As for in-kernel flushers, they will occasionally get stale stats.  No
regressions are currently known from this, but if there are regressions,
they would be very difficult to debug and link to the source of the
problem.

This patch aims to fix these problems by restoring subtree flushing, and
removing the unified/coalesced flushing logic that skips flushing if there
is an ongoing flush.  This change would introduce a significant regression
with global stats flushing thresholds.  With per-memcg stats flushing
thresholds, this seems to perform really well.  The thresholds protect the
underlying lock from unnecessary contention.

This patch was tested in two ways to ensure the latency of flushing is
up to par, on a machine with 384 cpus:

- A synthetic test with 5000 concurrent workers in 500 cgroups doing
  allocations and reclaim, as well as 1000 readers for memory.stat
  (variation of [2]). No regressions were noticed in the total runtime.
  Note that significant regressions in this test are observed with
  global stats thresholds, but not with per-memcg thresholds.

- A synthetic stress test for concurrently reading memcg stats while
  memory allocation/freeing workers are running in the background,
  provided by Wei Xu [3]. With 250k threads reading the stats every
  100ms in 50k cgroups, 99.9% of reads take <= 50us. Less than 0.01%
  of reads take more than 1ms, and no reads take more than 100ms.

[1] https://lore.kernel.org/lkml/CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com/
[2] https://lore.kernel.org/lkml/CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com/
[3] https://lore.kernel.org/lkml/CAAPL-u9D2b=iF5Lf_cRnKxUfkiEe0AMDTu6yhrUAzX0b6a6rDg@mail.gmail.com/

[akpm@linux-foundation.org: fix mm/zswap.c]
[yosryahmed@google.com: remove stats flushing mutex]
  Link: https://lkml.kernel.org/r/CAJD7tkZgP3m-VVPn+fF_YuvXeQYK=tZZjJHj=dzD=CcSSpp2qg@mail.gmail.com
Link: https://lkml.kernel.org/r/20231129032154.3710765-6-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Tested-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
---
 include/linux/memcontrol.h |  8 ++---
 mm/memcontrol.c            | 68 ++++++++++++++++++++++----------------
 mm/vmscan.c                |  2 +-
 mm/workingset.c            | 10 ++++--
 4 files changed, 51 insertions(+), 37 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b1fdb1554f2f..8aee8b75aad0 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1039,8 +1039,8 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return x;
 }

-void mem_cgroup_flush_stats(void);
-void mem_cgroup_flush_stats_ratelimited(void);
+void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
+void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);

 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
@@ -1515,11 +1515,11 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }

-static inline void mem_cgroup_flush_stats(void)
+static inline void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
 }

-static inline void mem_cgroup_flush_stats_ratelimited(void)
+static inline void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
 {
 }

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c31a5364f325..d3f4486a45d8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -667,7 +667,6 @@ struct memcg_vmstats {
  */
 static void flush_memcg_stats_dwork(struct work_struct *w);
 static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
-static atomic_t stats_flush_ongoing = ATOMIC_INIT(0);
 static u64 flush_last_time;

 #define FLUSH_TIME (2UL*HZ)
@@ -728,35 +727,40 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 	}
 }

-static void do_flush_stats(void)
+static void do_flush_stats(struct mem_cgroup *memcg)
 {
-	/*
-	 * We always flush the entire tree, so concurrent flushers can just
-	 * skip. This avoids a thundering herd problem on the rstat global lock
-	 * from memcg flushers (e.g. reclaim, refault, etc).
-	 */
-	if (atomic_read(&stats_flush_ongoing) ||
-	    atomic_xchg(&stats_flush_ongoing, 1))
-		return;
-
-	WRITE_ONCE(flush_last_time, jiffies_64);
-
-	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
+	if (mem_cgroup_is_root(memcg))
+		WRITE_ONCE(flush_last_time, jiffies_64);

-	atomic_set(&stats_flush_ongoing, 0);
+	cgroup_rstat_flush(memcg->css.cgroup);
 }

-void mem_cgroup_flush_stats(void)
+/*
+ * mem_cgroup_flush_stats - flush the stats of a memory cgroup subtree
+ * @memcg: root of the subtree to flush
+ *
+ * Flushing is serialized by the underlying global rstat lock. There is also a
+ * minimum amount of work to be done even if there are no stat updates to flush.
+ * Hence, we only flush the stats if the updates delta exceeds a threshold. This
+ * avoids unnecessary work and contention on the underlying lock.
+ */
+void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
-	if (memcg_should_flush_stats(root_mem_cgroup))
-		do_flush_stats();
+	if (mem_cgroup_disabled())
+		return;
+
+	if (!memcg)
+		memcg = root_mem_cgroup;
+
+	if (memcg_should_flush_stats(memcg))
+		do_flush_stats(memcg);
 }

-void mem_cgroup_flush_stats_ratelimited(void)
+void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
 {
 	/* Only flush if the periodic flusher is one full cycle late */
 	if (time_after64(jiffies_64, READ_ONCE(flush_last_time) + 2*FLUSH_TIME))
-		mem_cgroup_flush_stats();
+		mem_cgroup_flush_stats(memcg);
 }

 static void flush_memcg_stats_dwork(struct work_struct *w)
@@ -765,7 +769,7 @@ static void flush_memcg_stats_dwork(struct work_struct *w)
 	 * Deliberately ignore memcg_should_flush_stats() here so that flushing
 	 * in latency-sensitive paths is as cheap as possible.
 	 */
-	do_flush_stats();
+	do_flush_stats(root_mem_cgroup);
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }

@@ -1597,7 +1601,7 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 	 *
 	 * Current memory state:
 	 */
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(memcg);

 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -4047,7 +4051,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);

-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(memcg);

 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
@@ -4122,7 +4126,7 @@ static void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)

 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));

-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(memcg);

 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -4624,7 +4628,7 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;

-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(memcg);

 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
@@ -6704,7 +6708,7 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 	int i;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);

-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(memcg);

 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;
@@ -7868,7 +7872,11 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 			break;
 		}

-		cgroup_rstat_flush(memcg->css.cgroup);
+		/*
+		 * mem_cgroup_flush_stats() ignores small changes. Use
+		 * do_flush_stats() directly to get accurate stats for charging.
+		 */
+		do_flush_stats(memcg);
 		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
 		if (pages < max)
 			continue;
@@ -7933,8 +7941,10 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 static u64 zswap_current_read(struct cgroup_subsys_state *css,
 			      struct cftype *cft)
 {
-	cgroup_rstat_flush(css->cgroup);
-	return memcg_page_state(mem_cgroup_from_css(css), MEMCG_ZSWAP_B);
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	mem_cgroup_flush_stats(memcg);
+	return memcg_page_state(memcg, MEMCG_ZSWAP_B);
 }

 static int zswap_max_show(struct seq_file *m, void *v)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 774bae2f54d7..aba757e5c597 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2911,7 +2911,7 @@ static void prepare_scan_count(pg_data_t *pgdat, struct scan_control *sc)
 	 * Flush the memory cgroup stats, so that we read accurate per-memcg
 	 * lruvec stats for heuristics.
 	 */
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(sc->target_mem_cgroup);

 	/*
 	 * Determine the scan balance between anon and file LRUs.
diff --git a/mm/workingset.c b/mm/workingset.c
index 6e61ad08df75..7bac9be1b87f 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -464,8 +464,12 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset)

 	rcu_read_unlock();

-	/* Flush stats (and potentially sleep) outside the RCU read section */
-	mem_cgroup_flush_stats_ratelimited();
+	/*
+	 * Flush stats (and potentially sleep) outside the RCU read section.
+	 * XXX: With per-memcg flushing and thresholding, is ratelimiting
+	 * still needed here?
+	 */
+	mem_cgroup_flush_stats_ratelimited(eviction_memcg);

 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
 	refault = atomic_long_read(&eviction_lruvec->nonresident_age);
@@ -676,7 +680,7 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 		struct lruvec *lruvec;
 		int i;

-		mem_cgroup_flush_stats_ratelimited();
+		mem_cgroup_flush_stats_ratelimited(sc->memcg);
 		lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
 			pages += lruvec_page_state_local(lruvec,
--
2.50.1

