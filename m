Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B58A8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD6C6B0088; Fri, 10 Jul 2026 08:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F916B008A; Fri, 10 Jul 2026 08:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76DF36B008C; Fri, 10 Jul 2026 08:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 522046B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:57:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A7CFD140417
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:57:55 +0000 (UTC)
X-FDA: 84972869310.09.81B822D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 25B1280002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:57:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LZynFH0m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783688274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJ+ZZjoXshQwp4HjCw3hwahYLU+lQJ/F/RXGt07TIgQ=;
	b=VeX6zjJsAEvX/uAOgUxcZ0KT8O/bsjf9OwfyfPTbwnEGzFJzGZdyj+XivksxOsWij/Q5L+
	nH4Qi5B6/QnigIQEndK+Wep1DPsfz6CB37IfUZUuGssQWRG2okUKynHDOm9f+6vQKJONDq
	UsFU3WZweQ76Ou48dLsAgMl0+N1UHkA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LZynFH0m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783688274;
	b=AOE4Zmn4X8E5NaOuBG+RWt6yZ/Sdjkjl1YAcY0kztWCBLT26UM/OF1wEEIsF99xgHyJmfx
	YjN0b2usJQZfoP/TdTA41u6VNnQxZYCttDTlZxcwQ2XXFVMRl3Dw90am0jN4w6i1OEKIQ5
	HNAPLewtgBkAI1WntCnW0xTN48UlRrw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BB2560052;
	Fri, 10 Jul 2026 12:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400BA1F000E9;
	Fri, 10 Jul 2026 12:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783688273;
	bh=GJ+ZZjoXshQwp4HjCw3hwahYLU+lQJ/F/RXGt07TIgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LZynFH0m2Au0GulWeBOL9Se7/aaURATREjA+Ms9gJ6cf6EtMIjnSwTCzlx6N02XnT
	 dmeQJC81rdCvri3euXeoAfSFGRC9CIcPElPxCiLeWREStZCOdOcBu/+qjU0yCmT0QP
	 enmkG7dOtBv4nDyzVsVDneapP70gJ5rRL8UmcRvS6VjvhQn6RB008l2MD2l32xfGXG
	 5cYGi71NQAngfXSfymfzcPQ2MPJVVaecPUhTIsgTQH82cuEl6S9WmxjFwNuGAgHhNP
	 P2e2TfAIlREWpipjFo8pinavN75nYQAV2KudNOomqBE4nuw3/+drShM6jwi7qLxDtZ
	 ksyTR9LLiW0jQ==
Date: Fri, 10 Jul 2026 13:57:40 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: David Carlier <devnexen@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/2] mm/vmalloc: acquire init_mm read lock on huge vmap
 promotion
Message-ID: <alDnFGncVvcjsvTg@lucifer>
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <20260710-series-vmap-race-fix-v1-1-5b3794c113fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-series-vmap-race-fix-v1-1-5b3794c113fe@kernel.org>
X-Stat-Signature: k44rg7yz3qzi3okshzs6fg4ddip7enpj
X-Rspamd-Queue-Id: 25B1280002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783688273-77719
X-HE-Meta: U2FsdGVkX18KyMtVQKMIXokT6rNnuafoXy6f5teokzNpCuoA64H+/NjOqmN1I7FbLxz2QTxiVHttSS05GphsPb3Fwuu4Dn4CSaj6DA1cmsQx44TqFMjdpZDxSfPt41kTewLZ5RHmpy6322PcFiuyIC1WZBUmny5f797knXmjGc6Vcr8bpk5BanGe7hlUteUtwwAIMJCl44laKonQM5OQBbPcRZbNCkQAU4AMBjk2C1Fuyb/eXu+Ux3nr976hRSPjxqT54o7fNMvqg7mL+32PWGpsgVILBw4k9+jZVeO4mwfTdIDf/YcR939vZqFfuSq29EJlk0/bzCCASzc/lpXBBiHdZW8ayT//XNHrMxnnbwyjuMDmse5rwD1GWWv3UVvkcPc07V/TKvijFJCvKT2Eaj3k4LXwuW8VrGPrr/NHKrMDkNgaXWAerjIzzCaKOCUX7G6SDa9htOLGVC74vu9biFZC/pwLXw26EjYXBvDA0+HYC4AMoGHM9YSHk71HK6MktBkYQM/k1GS0CriAPD4iLDsuvpwpirxS4VKB0kTZtBVgeqTIatWHJNby7uaNn9Nk0RnheeuPpcvN4+T614AhM4eWOepDSE5vkNc/Ck4kzUx3VfIvHLh9q6ZNuNY1jxOY6nInNX1Qtb0hPPsWayBNFi5XSQQTV36fc6pgLRkYRfxyaVh5VsVrUNaq+Qmc0/KSQCRXfOr50wUL7olaaNWaqnBCyYlk9CZ76itZKM+JeUWelhgqDL+B3EogY2RpCxBLmZlrRg5ErLColqQIvXmVjbSngpGXYhfeePeiH2nnF75oOyQSuIrUwohz3RuTDTEZKPaUuSQzhEi6GzNsHIU7rNR2bvYkY+cckpVpvN0ItAgGx5E8ldk9fTVvNF8QOntG7rwzrW2Di4S53W2UUIrhpGmVD5Y5KM/rq+hmwLefkr7jAzSNMeZqRWrHudWC/p9CSyRC8s+DsqqUfS1WVIg
 xuqZwckx
 Txrxt+ZGofkD5OQgfGRZbqzWyIG8jjM7sfoLLsfd3vNhMWMd63cuOWTPCnSFEnA6OuXFJDrwVKOLAgjhfnpv71gO0La5b62bb+gK8NiN6b03zm4CI/Ft0Rgbe8MgbCHNcgdErL6jOhbhBSVXDotVWCZ+Ab0N765UVMPxF4eJORe9eZtuGvYCWgGNy+Aqb/WgvGYliEghsMeuPeb90yUGhLhQmUWp9kcHWLuyJqbwOQHw3rRy4lD5EUGk94CxbssEGjeghu47C1XUa2lCnqjT35PilzjVhsS/zF57Cnp//ok7JSl2VewhzMXsN7R2b/9lsTmVNDX0HvsmT72M3qg4MJwXMGC2G2XuTinIPK1sfrjEEU04AyPKg6+hCrRrMUynfVdCx16BZqxAE4mPAAcXq7bwLt0EqHX6n6xrQTsuCyCQo6ok9mnwDsmOsQiqbFxMrt5PedG97S8IWJt0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As per Sashiko, we need to account for x86's slightly bat... interesting
ptdump of non-init_mm page tables.

The fix is to take a nested init_mm lock in ptdump_walk_pgd(), which is
safe as nothing depends on an init_mm lock prior to acquiring an arbitrary
mm's lock.

I think this could potentially be sent as an entirely separate patch, as it
doesn't change what this protects against, nor the x86 CPA patch, both of
which stand on their own.

Cheers, Lorenzo

