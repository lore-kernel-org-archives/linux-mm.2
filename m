Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F62606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=prv5Y31s
Received: by kanga.kvack.org (Postfix)
	id 2C0316B05B1; Tue, 17 Nov 2026 18:05:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250BF6B05B2; Tue, 17 Nov 2026 18:05:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187096B05B3; Tue, 17 Nov 2026 18:05:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E28A86B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:05:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7BEE5C05EA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:05:35 +0000 (UTC)
X-FDA: 85446144630.05.351AC0E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7DA8918000F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:05:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=prv5Y31s;
	spf=pass (imf16.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794956734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k9hECHMo5h9GfCY5WPKMVv4Wl81tO8IuuIh5c8IoZ9o=;
	b=QP2vnPImcuceoy2u0sy3VKoXi10CvRrshy4XYnfD2+QEbyZo0AracAq7SxbGkPPZzL71s8
	tkaAG2NFf6QkMKa3iQpFmf2sP577A+YAN3O4u1CYy4nVkJVZ1E4quOPZ3+lGCbFJT3ddk2
	iOlN863gCesvPrLlN6QZxcHrf/gIjjA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794956734;
	b=ZwvWAOL+rlhRrRqlLVSDvFGzxXQwR1ibSnS/17Ide1NeGmgc+wTdiIU0sGZSQ+bMUGS5T6
	wvtGRCyvtO+hmLBJmtQMw4f9ByO/Sl2RXN4F++MOVkUbbUzKWCp+9TCkNhdRJL7GMdXQRF
	QVbsMRS69LZbfbZFCM8rAldAAcBQhPA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=prv5Y31s;
	spf=pass (imf16.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65BD9143D;
	Tue, 17 Nov 2026 15:05:29 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B051E3F673;
	Tue, 17 Nov 2026 15:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794956732; bh=80JOiYe9nFVbLZyY5qgUN4tX8EOBOfJzJ//RidlysA8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=prv5Y31ske7iBSp/rqXiLJZUTDgOBxPFHIQ+oiGiF2V5G1DqHXKG7dU7+oUICNqCt
	 eNo1aFAHTJe8JmSwbgKJYm5jMACcMKMuiLV9G4HLpKL2/3urSVYg8lIB5V4qoVcRGe
	 rhl1WbBj6gFBFI5DwnFCHBxeSTQlYP2oVUjLH6aY=
Date: Tue, 17 Nov 2026 23:05:28 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+527fed49e5b988882c9a@syzkaller.appspotmail.com,
	Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH] mm/slub: don't let kmemleak report rcu sheaves
Message-ID: <avzduIJralOKBgxK@arm.com>
References: <20261113151837.123795-1-ngocthang2710.1999@gmail.com>
 <0e626675-c6f9-40d7-a4ae-de069154ada2@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e626675-c6f9-40d7-a4ae-de069154ada2@kernel.org>
X-Stat-Signature: qphq6dtjwtxpbs6jso7ehyrjqobibaid
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DA8918000F
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794956733-159391
X-HE-Meta: U2FsdGVkX1/+EtHMkXMDiT8GyPt6QgV5XXTbbGc0Qrrd+wPMCLxmxfGgptRAb67ba0VhQS4Zc3WY3DGERIg2doWioieSnojZL/TaKAp2zkxDFznmfoIHVs9cW5++6A1KWPQMBKRHt8YOsIot1YlwvdswRgwQ2KhabjVRBb/sEnNAc5EC0B0E9uO9EuBwpbCnCTEkCuxZxS1vWcEtBFZTkaBOvDVCLRAPSzHvZ62MLp9o1cethNK63M3glbTzTXxguUH9m2aFX7gmIQDKAJKl2tlloiqa70ckAhpCYNiDIQN6/3MgQpvpa+cyWtSQy4YQaheqSrAJ+fNxVNQI344ZLqzBhP9iaoajOA8W8ONpCpsxl8dDJq8dL4Gt2dY/traTnlujuVQlQxCxU/c9Wa4XzxQxRAWkEWV/pVSmBAcWP4nx5p/L8fEWtDz5xPNrgfET7OAbCalS1zNljMuS9Sfjx5eU9lWKXndl5jaaDM2miYwaeWY1f4WDjWo4rM3OUWjSaj/f4akFhmlfrS4J3XWucHwwE7gn2Dy/7687N2EX2cPb7v75E9oJBT5yVBcBpLfrRxaLAMxBAFG2gOt1J+8c9zIm7LEPZfg/EhxvAFE++4n9tg+RbOGTttHE+Jv6pVjVjeZu4S2vEMG0/zqKfxUJj/ZpQRo1guypiVWPo2cS+1Bp2alsIwv+KNDtH33w3Bj4JCwwoHII83apSUU2nBS13VQp4qGqeC0GORg5MWqHsRZYSiNMxdE6DxN+CD73LinlZcr58gFZKh7voHLVjbwNbuxziGhOnT/MYQ1SLj2xaX6cjCvfNGyYEP4zLmbzdZUqPujCiSbj5hYSc2Mg19XphyOyfMwRkznHMKH9MqjlcsmOouUGGcTGqXoXgHa3P9YmOk81H2jRQC340dlNCiGU52EFkVGmUsRVwH7ewyePja/W1vmjNtzPcCKAqcgo/qH1XH+yuDv4oLjnrWvmSx1
 vJ1kAJ9D
 jX+/ehxcT9B91iZbRPnoD92LPmwAcuRIf5k3ghZWS52ksTza5M/9jFnoqtCAZTb2Wosy5OHWeXgnghPrO0Gq7FqKAYK+nkjI4hwNoWIf3wyDQyyj/crUoX5I5z8fC/nvVOB7fTJ7AUCBBSKTljVFmERD2vOFFIVo06D5v2REAihDJkl/LXMFfLkJPJ961MOHfsZ/zgwviXZSKyHxY4kjNzhRDPr9XSy73Mk2bmuUc4nsm3zOFBt5LKgaQNnnAS4umBXEkKNn+5tLhiVpVkVUbBzm82Ki/RU9NzBTgQWPL64DRF9NSuC+cZEKpphzOdKXC80tyNVnEMZpPQYmz5/UqKFghrlR5PhxoMWsMc2I1Ho1+pNk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 11:54:37AM +0100, Vlastimil Babka (SUSE) wrote:
> +CC Breno
> 
> On 11/13/26 16:18, Nguyen Ngoc Thang wrote:
> > kmemleak reports full rcu sheaves as leaked:
> > 
> >   unreferenced object 0xffff88810005f600 (size 512):
> >     hex dump (first 32 bytes):
> >       e0 79 f0 2b 81 88 ff ff 20 00 b4 81 ff ff ff ff
> >       00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00
> >     backtrace:
> >       __alloc_empty_sheaf mm/slub.c:2854 [inline]
> >       alloc_empty_sheaf mm/slub.c:2874 [inline]
> >       __pcs_replace_empty_main+0x260/0x2e0 mm/slub.c:4806
> > 
> > The second word is rcu_free_sheaf and the size equals the capacity: the
> > sheaf was handed to call_rcu() by __kfree_rcu_sheaf() and is waiting for
> > a grace period. At that point the only reference to it is the ->next
> > pointer of the previous callback in the rcu callback list.
> > 
> > That previous callback may live in memory kmemleak never scans, e.g. the
> > rcu_head of a struct slab queued by rcu_free_slab() for a
> > SLAB_TYPESAFE_BY_RCU cache. Slab pages are frozen (page_count() == 0),
> > so kmemleak skips their struct page. The chain from rcu_data is cut and
> > the sheaf, typically allocated long ago and recycled, looks unreferenced.
> > Since the sheaf is then not scanned either, the objects it is about to
> > free can be reported as well.
> 
> I don't get this part. The previous object can't be that much gone, RCU
> still needs to get to this sheaf at some point, so there has to be a live
> pointer somewhere?

After some back and forth with claude, I think there are a couple of
places where kmemleak fails to track. Since commit 9aec2fb0fd5e ("slab:
allocate frozen pages"), kmemleak no longer scans the slab structures in
scan_zone_pages(). We could do something like below:

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 20c0eb41c873..47446af5fc9f 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1875,9 +1875,13 @@ static int scan_zone_pages(struct zone *zone)
 		if (!(pfn & 63))
 			cond_resched_tasks_rcu_qs();
 
-		/* only scan in-use pages belonging to this zone */
+		/*
+		 * Only scan in-use pages belonging to this zone. Slab pages
+		 * are frozen (zero refcount) but struct slab holds pointers
+		 * such as the rcu_head of a slab pending rcu_free_slab().
+		 */
 		if (page && (page_zone(page) != zone ||
-			     page_count(page) == 0))
+			     (page_count(page) == 0 && !PageSlab(page))))
 			page = NULL;
 
 		if (page && first && page == last + 1 &&


I don't think this is specific to sheaves, SLAB_TYPESAFE_BY_RCU may have
a similar problem, though I don't remember to have seen such reports
yet. It should be covered by the above.

However, this only fixes the links through struct slab. The rcu list can
also go through a sheaf allocated with kmalloc_nolock(), which kmemleak
doesn't track. Any callback queued after it is missed (together with the
objects queued in that sheaf that may come from ordinary kfree_rcu()).
When kmemleak is enabled, could we simply avoid allocating sheaves with
kmalloc_nolock(), i.e.:

diff --git a/mm/slub.c b/mm/slub.c
index 45e077c7526c..13b8e57d6dae 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6278,6 +6278,14 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)

 		local_unlock(&s->cpu_sheaves->lock);

+		/*
+		 * A sheaf allocated with kmalloc_nolock() is not tracked by
+		 * kmemleak, so neither its objects nor the rcu callback queued
+		 * after it would be scanned. Fall back to defer_kfree_rcu().
+		 */
+		if (IS_ENABLED(CONFIG_DEBUG_KMEMLEAK) && !allow_spin)
+			goto fail;
+
 		/* Don't wake up kswapd, it will cause deadlock under pi_lock */
 		empty = alloc_empty_sheaf(s, __GFP_NOWARN, alloc_flags);
 

Not tested and it's possible I misunderstood how all this works. But if
it works, I don't think the kmemleak_not_leak() annotation is needed.

-- 
Catalin

