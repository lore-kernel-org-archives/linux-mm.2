Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 192FCCD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 00:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A26E6B0093; Wed, 10 Jun 2026 20:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 752B76B0095; Wed, 10 Jun 2026 20:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690C16B0096; Wed, 10 Jun 2026 20:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5821D6B0093
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:43:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AE441641DA
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:43:22 +0000 (UTC)
X-FDA: 84865783044.16.05F545A
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id A1777100010
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:43:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n1JOmPm4;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781138600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PxXYed74ADL8caJKJdGToQwcuACBpIehdiJ6ipQ6Epc=;
	b=dKoK5Yx+4Yg848Qq+6ldH+8fnQW3A4YmTGt++BPd4VAniOFUWtJNwYDf10QhneDsAYCOku
	tkcPiMPKAK9daZKsv2HY/r7T0bLsEKOU1NC4p+iePGIHVm3uoeerQwNv+cgRFRMhm7BbrE
	Za8s6+sMtVlSPgy/BGxypVfbCp8KBnM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n1JOmPm4;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781138600;
	b=sPuP9+SpL2XIyp3UFTEjVrWeTsgxooFWJ4pMs2dfwTY+EvNUVJAYScUgMQ5VA76Vrxdywu
	6wQUCmRIS23qJBcEMgciMh0ECFomsEjandgbzKy+HBFmzYQHP7fvy3Qar6GOXNS1NC49Jb
	ShSeejzZJsIb3IXncK3h0Oq6r0/50aA=
Date: Wed, 10 Jun 2026 17:43:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781138597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PxXYed74ADL8caJKJdGToQwcuACBpIehdiJ6ipQ6Epc=;
	b=n1JOmPm4sr6V71uCwYZTEeUGiMFTdzivPvGu/nr6gU6xUIK59EZPQfqlql8MqjU8juVKQV
	KN7SBZFy8OI5VIyr05j9NPWO1HlZH9rq0rJVit4LfqSWm8KRDaRibN1lmJaX9843erpfto
	7OjPDzW/hEwh5PpJuBmoCbBmyrgHPX8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Zenghui Yu <zenghui.yu@linux.dev>, Nhat Pham <nphamcs@gmail.com>
Subject: Re: [PATCH] mm/shrinker: do not hold RCU lock in
 shrinker_debugfs_count_show()
Message-ID: <aioDQapzvS-jiHah@linux.dev>
References: <20260611002236.69207-1-sj@kernel.org>
 <20260611002651.69383-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611002651.69383-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A1777100010
X-Stat-Signature: 85ex79yogpsrt59pcu515hmotwds4g75
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781138599-532633
X-HE-Meta: U2FsdGVkX19IsJAHnJRVdc1l1G5GwyPfB81XLHJOnS4FyS+Bmg2ztKN9baTqNsU9rE2wEYT7eQGulJMc4r2+0pk5+FCsINcutRZtAjZsXbhX3fSr9GIY6g3ZW4ffDVSIViDmV/1TDid5lZuQsgdtEGSVittYaDPnxXUuI3liK3QJoE9sxvEiYyHWZTshBTN9XbxNbB5DnPew6nUVp2cqN5oiXpC/8XqTdnlsO1ZdfjQgKM6n75vFfuRzPASVfndcD4F3qwK9/MC4KgEFW0paUz07hCSk0uNP7Zq3NgsHfVIC3zr+kjrtLxwFLbT1/NIUALFudRqQTxuBCtkaJv+BgL2fIM9tP3QNhM3HO4qtzfjP9ufmSI+lprxF+XAiumSTQh+itXunCIpxdHBet7GA0BFQMAZBGXca20wz3LKTNTiY+KNHoMbXtTzp8W6ownul6HIABAlu5kA4hkic2ZcLE/TBj3PSeVQEdgKaC2ucSTHXnUYmAxEiYnkcrNCn1/DgcGnG0IGrxzsy0Ylvfdcwcf8H8oV8J87b2+QFIrfCKfeYXqlSRIYaiOVh9+R7dbODSkMz2k9vWmpcO15jlpP3HZPmIjV1qLJyUSCoOd/zIMYy6giD2qdVb8iSnEY60HBNP1MZXwN/+4zySI3Us2dGMIumzQwny6SMASv4UYmO4UjltSblMVimtHt4GV/21m9x2NuatDciGEZbMnjWrx3DdwU9XG7i+epxzTXjnDX0xlyYAcyQBVKE7nF4QdfiTnUHa0Srd1ayIUJrpdeUqg1rrhFPFdVuePkiUPcXJkGD1LuQ2TUvccfY+5bIyO0hQdOZqx+N3dfpP+vX7ZJcieUH2TrslJbBm3uxaeMHgwPGtU0Cx15s36Dz+CKYohqOCFUv62OTcw4Rfw8JAHsigAZfM7O/4FhP+/XUshJR238ErQnUZECB3ZuCSNN13Ya/XsFL4M3DWnPIxaliG2XDHky
 L9AoILGH
 M67kNaIS8ykDZJvWdBHMIqORE6gbhHkokge5Wms8AS6dEfCqETsk70qWGpvp8TGc4YHjW7Qeuut9wdqjjunmcb4uCEmyuxIF1DtGrSIZwkee363a4xDdiACaxM+3d3lkMi0DtVItRise9MxIG5/4BHfEZpQ2ZoZnrdWJo3hCwARNo7NC/7poWCTG2FNDPMt+nD/vs2O7eL8XvETzeXy/Ei7RhtoVIyPX2P+LseeFY5cLDWtH8PV1UsqUN2VjLeduycGb40N6PIav/Ey4g29b8lKBKh285xS44vl29+nLFGmPcU58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:26:47PM -0700, SeongJae Park wrote:
> On Wed, 10 Jun 2026 17:22:51 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Wed, 10 Jun 2026 16:20:48 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > 
> > > Reading the debugfs "count" file of a memcg-aware shrinker can sleep
> > > inside an RCU read-side critical section:
> > > 
> > >   BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
> > >   RCU nest depth: 1, expected: 0
> > >    css_rstat_flush
> > >    mem_cgroup_flush_stats
> > >    zswap_shrinker_count
> > >    shrinker_debugfs_count_show
> > > 
> > > shrinker_debugfs_count_show() invokes the ->count_objects() callback
> > > under rcu_read_lock(). The zswap callback flushes memcg stats via
> > > css_rstat_flush(), which may sleep, so it must not run under RCU.
> > > 
> > > The RCU lock is not needed here. mem_cgroup_iter() takes RCU internally
> > > and returns a memcg holding a css reference (dropped on the next
> > > iteration or by mem_cgroup_iter_break()), so the memcg stays alive
> > > without it. The shrinker is kept alive by the open debugfs file:
> > > shrinker_free() removes the debugfs entries via
> > > debugfs_remove_recursive(), which waits for in-flight readers to drain,
> > > before call_rcu(..., shrinker_free_rcu_cb). The sibling "scan" handler
> > > already invokes the sleeping ->scan_objects() callback with no RCU
> > > section.
> > > 
> > > Drop the rcu_read_lock()/rcu_read_unlock().
> > 
> > All make sense to me, thank you for the nice description and the fix!
> > 
> > > 
> > > Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memory shrinkers")
> 
> Forgot asking this, sorry.  Are you intentionally not adding Cc: stable@ here?
> I think the user impact is arguably minor enough to not Cc-ing stable@, but
> just thought it would be good to make the intention clear.
> 

Haha I was just being lazy to think through if this should be CCed to stable or
not and letting others/reviewers do that for me :P

> > > Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> > > Closes: https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev/
> > > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > 
> > Reviewed-by: SeongJae Park <sj@kernel.org>

Thanks.

