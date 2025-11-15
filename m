Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C05CEACEF
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 00:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561698E0020; Fri, 14 Nov 2025 19:40:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539848E0005; Fri, 14 Nov 2025 19:40:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 476F58E0020; Fri, 14 Nov 2025 19:40:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 33AA38E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:40:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4D191A05E7
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 00:40:40 +0000 (UTC)
X-FDA: 84110985840.17.6C1DDD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3F134120004
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 00:40:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BJQzh+rq;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763167239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bN8bDgGJVGh6hWZmpBRr8iBcPy/IkRvr/sv0vG/c/54=;
	b=NSG0XOR0xNbq9e1yzZx3A2qTtueDGMnJnuWtY941HnF5g/EJKH7vwczUj55/36Dxh6Qs3O
	WLQDHIo4QVGXYfsGKz/pd3BHvzEiIl+38dSuvFK1n610L6EchgowiLQJkfx+rqnjv38DMA
	/VNNlx4/HZbzkXUyLzB/JWXctoaFdqo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BJQzh+rq;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763167239; a=rsa-sha256;
	cv=none;
	b=7mz+D3VIELXJihrAlAD6MIvQRp/ZsixjUSZsmdaOvI95Hwsf3TqMdZPF0DsCgumYi4bI3W
	V24GCU4DcVgu1jNGbdYZeQ6y4bh05QlLiJdb2Dkqwy45slCSyci/XdYR+KSg5V521u9Whj
	zg9nQGG/BIUmc6PrXcZIttAC3MKPDCY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B7E760149;
	Sat, 15 Nov 2025 00:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7674C4CEFB;
	Sat, 15 Nov 2025 00:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763167238;
	bh=jEmxfxbxB+RQClXnrGxIyD6tQR2dATzYojvSYk9o6ck=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BJQzh+rqSgrdY0Fw+0DQg0QRfi1HftOt95vAULsMq/Nh6b5D2ZreaC2uAzbC3Q7TT
	 yFFZVPTV2lsw0GtFQgGCyPch1iRECfiCnhRHYQslC4gF7/YIVdijwSPtYWtkkhhSfP
	 rc7UJYRkcv/foeqCahn8h2CV2XJIGXyimxWuU/Vc=
Date: Fri, 14 Nov 2025 16:40:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: "Shakeel Butt" <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 "Johannes Weiner" <hannes@cmpxchg.org>, "David Hildenbrand"
 <david@redhat.com>, "Michal Hocko" <mhocko@kernel.org>, "Qi Zheng"
 <zhengqi.arch@bytedance.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: skip increasing kswapd_failures when 
 reclaim was boosted
Message-Id: <20251114164037.bdd9551dfae425bc52756832@linux-foundation.org>
In-Reply-To: <53de0b3ee0b822418e909db29bfa6513faff9d36@linux.dev>
References: <20251024022711.382238-1-jiayuan.chen@linux.dev>
	<lqcwz26ajddhoaq3gfuyt3mzwfn7waeqksoz6k55jrtn32u42z@pdf3dor7ntb6>
	<53de0b3ee0b822418e909db29bfa6513faff9d36@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3F134120004
X-Stat-Signature: j16bsi7ui9b3bh4c9k6xi31esycypxqb
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763167239-963076
X-HE-Meta: U2FsdGVkX18ayy4bfmReNQXmQPoOJul9YuveI0RrP07IaXBcUjbj2v85u50uddrU4FDaXNCZZ9okEotWjaHb9LU2LtcICE/VD07OFos+sYYS61mSnh0RJqjOmSs/gSOIi1XUP3ZsiIO7zVDopER1sU4dG9wz1h+5u+UmUH6loIYsVlzdOzLPa3S8NylbqDqIk77hFKyjNWXdAtCYPiW7XGzmRFL497YpbK4oJscxeJKsjUGVVgsgxGum3cmVrlRCOf8UP1sA9mzqMpjAO0bEQnlINccih3r80d3GrhqfkXRjUmcesJNTe59Og1zqygoZOAOymWHpTTglkV29y5VIWx8HCP0JrcICSHh0gqU74y6wPfyqhqzBhij3Tl8aFzQBjzWF0vrkAMJhLfo2F6Dmi8LEaLGWFApVZA9ppHt6hb1EmwjtVVpWGwOBnFUMKiwE2Cb9yiBbmTCB9U30Tyu9FNZBUPuQtZDwCL30BwTtEeaNBLcEZbCXpE1s7zDCwT/y6Dc0GJhN6YI/VDgjmXD5qQFCERUDCI1A009ziFBQdBAPAtJr0W9OlLqFC6Ck6MnrwKZYtx3hKLday0drwGJZ05C8NNSGw3AF1COIZcjOjXZN83Ey6duKc1s6nGoM/VfrzeZ9uBfCZjLW16RP3SXNIHt+5H1XHcg3pxKXY9Xm2Nki1EMvEFVjBRL/0mb3uW4if8FKRV6+eDZ8W0FiSRs0BH0Qll3O1FBt71DW02VTeKcQdwKovvJS9PJ2lFJS3+0GxdoSpZxehydhCAhTEEUxu/pFCIAQ7DJXwFpm9SohTIGOlcxwzIqO1HF7NbBf2ZDseeDL0/sFGft5V36aijA8aNVHwcJVZxeEpWpIRY4R3w7JdBKFgCmwzfdF7FyV5IagBPDkPSGi7HVGz5D5zFl1PaWVNS7A8G4am0bZ19HWLYxNVIH8wzxrcXxARFhHWHk09f1n6czaGCAna9xgbRS
 ThafM5XS
 Om23MtesTjPn8Deh+vwZYCAMuR1PjPHZwt3b/NjHoEcxoZ4dyRLKZiwR2zAQADff16K4gCH15BQIT6O/+ShBCSfbWDiGzLE1qdKrJIZW8UMhuunzIq3vz0OHs3SKzI5YhUxTnPyiUK5Z4J4j0K49GIaN5x0DwlSmjfeD+KbwkxPFNJ1PakXRto9iRje7fXvMYaB4k7j0mCQ7u9sPZpMK+ccOSIda2HMdSXfoX5h7azh40lMdUPUdJ4cwMy1C8ObmxPK+E/4ksBgYyjPcWxapBAKJbyAft2AfM5Lz1aK9Hi9SaGPDv8vRiI6s5/DxLxs+x0iTkCW10mnr6aNoRK6JSZd76fwzW384gKy+/AiqM+r7WNkUOhlcIP+Ee5gBL8/Gj5ZhgtHi3HLk1ifl4OVKoaXGIoZgMYqpOsJ9XIA0/tyQm8UlABuRtmV1xq9nNrMj0wjSdCexWRA5LTzSvq1THXtm1K3WPVWc0Ds5aFhHBnFH7tgFXmNhmJSmCW0xCBesXHhEGvh6wd2aFsqqMr11R2oiKPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Nov 2025 04:17:40 +0000 "Jiayuan Chen" <jiayuan.chen@linux.dev> wrote:

> > >  Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> > > 
> > Please resolve Andrew's comment and add couple of lines on boosted
> > watermark increasing the chances of kswapd failures and the patch only
> > targets that particular scenario, the general solution TBD in the commit
> > message.
> > 
> > With that, you can add:
> > 
> > Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
> >
> 
> I see this patch is already in mm-next. I'm not sure how to proceed.
> Perhaps Andrew needs to do a git rebase and then reword the commit message?

A rebase would be needed if the patch had been placed in mm.git's
mm-stable branch.  But it's still in the mm-unstable branch where
patches are kept in quilt form and are imported into git for each
mm.git release.

> But regardless, I'll reword the commit message here and please let me know
> how to proceed if possible:

Which is why I do things this way.

Easy peasy, edited, thanks.



From: Jiayuan Chen <jiayuan.chen@linux.dev>
Subject: mm/vmscan: skip increasing kswapd_failures when reclaim was boosted
Date: Fri, 24 Oct 2025 10:27:11 +0800

We have a colocation cluster used for deploying both offline and online
services simultaneously.  In this environment, we encountered a
scenario where direct memory reclamation was triggered due to kswapd
not running.

1. When applications start up, rapidly consume memory, or experience
   network traffic bursts, the kernel reaches steal_suitable_fallback(),
   which sets watermark_boost and subsequently wakes kswapd.

2. In the core logic of kswapd thread (balance_pgdat()), when reclaim is
   triggered by watermark_boost, the maximum priority is 10. Higher
   priority values mean less aggressive LRU scanning, which can result in
   no pages being reclaimed during a single scan cycle:

   if (nr_boost_reclaim && sc.priority =3D=3D DEF_PRIORITY - 2)
       raise_priority =3D false;

3. Additionally, many of our pods are configured with memory.low, which
   prevents memory reclamation in certain cgroups, further increasing the
   chance of failing to reclaim memory.

4.  This eventually causes pgdat->kswapd_failures to continuously
   accumulate, exceeding MAX_RECLAIM_RETRIES, and consequently kswapd
   sto= ps working.  At this point, the system's available memory is
   still significantly above the high watermark =E2=80=94 it's
   inappropriate fo= r kswapd to stop under these conditions.

The final observable issue is that a brief period of rapid memory
allocation causes kswapd to stop running, ultimately triggering direct
reclaim and making the applications unresponsive.

This problem leading to direct memory reclamation has been a
long-standing issue in our production environment.  We initially held
the simple assumption that it was caused by applications allocating
memory too rapidly for kswapd to keep up with reclamation.  However,
after we began monitoring kswapd's runtime behavior, we discovered a
different pattern:

kswapd initially exhibits very aggressive activity even when there is
still considerable free memory, but it subsequently stops running
entirely, even as memory levels approach the low watermark.

In summary, both boosted watermarks and memory.low increase the
probability of kswapd operation failures.

This patch specifically addresses the scenario involving boosted
watermarks by not incrementing kswapd_failures when reclamation fails. 
A more general solution, potentially addressing memory.low or other
cases, requires further discussion.

Link: https://lkml.kernel.org/r/53de0b3ee0b822418e909db29bfa6513faff9d36@linux.dev
Link: https://lkml.kernel.org/r/20251024022711.382238-1-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-skip-increasing-kswapd_failures-when-reclaim-was-boosted
+++ a/mm/vmscan.c
@@ -7127,7 +7127,12 @@ restart:
 		goto restart;
 	}
 
-	if (!sc.nr_reclaimed)
+	/*
+	 * If the reclaim was boosted, we might still be far from the
+	 * watermark_high at this point. We need to avoid increasing the
+	 * failure count to prevent the kswapd thread from stopping.
+	 */
+	if (!sc.nr_reclaimed && !boosted)
 		atomic_inc(&pgdat->kswapd_failures);
 
 out:
_


