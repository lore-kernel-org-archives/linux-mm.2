Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22FB7CD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 621F16B0088; Tue, 12 May 2026 02:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8C16B008A; Tue, 12 May 2026 02:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536836B008C; Tue, 12 May 2026 02:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 42C966B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:46:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5C1A120210
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:46:44 +0000 (UTC)
X-FDA: 84757834728.03.483823A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5172940003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:46:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iq4WyErZ;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778568403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZr0BaIdHSwJJbA1hkK0oJ81Kb/bYZuv87/XRa/7gMU=;
	b=ZOc5kS5jdAB/9+GBkQQlj0PN8G2OEB0Kigc9bAw3t7yekj9H/WnNVpNGq4x3EKoMPjbmb6
	dNMOxa4b6/qOjl5Jz/IqyNPYaFsXzWKn2Y30/EHBwS8XdVBS6Y9Wftrcwgf9QcWkOKc4B0
	r+UmRKKtt8vdMe3Wh1Hm9795CiDbLHQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778568403; a=rsa-sha256;
	cv=none;
	b=8b1P031SNtkFo22w28/iNH7UHBKUj2mFKI7/RDjKHFXO/D1eBNLb3l5UCo3GPIMo6gcluv
	fadJnQyg7NUrXmiGkm5iDEtPZ3hVyv0pdAUAzdy2LTW9NQZ8uXGF7GOTB3yVXGG8XckB1h
	J65JD9OhnekMIj/hg/xhng9xRPSj8A4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iq4WyErZ;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A98B1600CB;
	Tue, 12 May 2026 06:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD99C2BCB8;
	Tue, 12 May 2026 06:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778568402;
	bh=9lo3a8HNQUQfSXTkObC7PN3s4BMtQs5GlB1W7QFzB7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iq4WyErZxLPa5eoiE6vV9GoH+CAJnCkGrApLT+EmefaDjXY/+2mDAOR7SPbNRKOSX
	 DJAN1+v+XyLPXBDgwYfvsVN7qnZ3HoGKeFY7UKmQAav6t29Unz2ZDP8Djl25+dsovY
	 Aax9awSrj1xfSIKYIH2onurNuLSiP+GeF98D63cA50VnbAYy7x7GTjkr7CSQTTuDwr
	 pxwa6tzNkqebXStif+d+CflDW8A18wjD141aoQYoExJQ0uLgZHh7uW5U1UhJF/WT1t
	 V9iESmawjhAQU/kVhViAuNkUm8I3bRmYilndNwTl4dh7aR+ECGgFJr/S8b+7EWpcxT
	 oxkBD/BCsWz7Q==
Date: Tue, 12 May 2026 09:46:34 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] kho: store incoming radix tree in kho_in
Message-ID: <agLMyu2_oQpbPCdn@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-3-pratyush@kernel.org>
 <agHA2imH5hdMSlId@kernel.org>
 <2vxz4ikddi6y.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz4ikddi6y.fsf@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5172940003
X-Rspam-User: 
X-Stat-Signature: b87a18jid56afya87nop3zrbdxef5pri
X-HE-Tag: 1778568403-640720
X-HE-Meta: U2FsdGVkX18sU1ocIo3VKHfRLmqOGM5nLi9s5lV16GE30AaMmFad4p2cs+eB0sISSEsNvb2lgq8SzesZfkDrljvmYAZp/UnOjXN4jE5WV7LAOZt7s31qxyLVbYg18HNtCS1XfKSb/yvhIVyHU/S6X4EsPFLds6O373dQWtId7MSDYaoX7V+hq6BCA2S3aCyFrLNUjVtpXAt3QkjPOUMQVcsb/i1y58tAszP35Ng/v4dl8AB52mJMLtdADeqRLRINTtDlcin2SRUqinMC6wIJ6KXYKPUpBpMSoUYpuiyDeE5q55pmuLDRNWhV/SbjzlOLfs0RUagEiWjwkU2aKAFBsZ65dYySzryPzV+lrBwKU3OluauX5zYcx2nHPt4+7376yzErpTWCRzBeUO0yDOsEupde8MenVuyf2ZoP7wMx3Tk/SX2/hlGJ88GV+FiEC0/vanDFmG3cla8rn8ZS7Nn2oYAkVxC6+HApZn7oxqgZ6fm+Xx3aZ/W++OZN/BpnSU8B9sU4Hu6jjpHcBtPCQ0uBEuWCtydr9p+ETPYb6GPss9Upfn2Ov8zBY4q7wXtACVXehoHTDQygEGgXvQuOgbh3GXpPkSw63YM8VFTjc3t2rX4gLYGGum+xalp3m/xHr1Kq4XIraj9lvAmGCV5HRjIgTYKUCFIqW/opKfqomM+t0sHFQ7S3+Ct67GSXva1uHBdYOFUs5oeIBJU3KJ9FsLh71LQQCnPHC3x8aSDzOMybza2UfyEaMZcq6pkQlesZGWcdUIizav56rnB8ByuJiAI+B6XQPZdI4Y70/OBxT7RDO7oUj29/Ony3gktf93V0fg+i5WUSoC2j1iaBo6EF54xZLyyMRKzhZ2ogqjEOV20F/67zmt9ScXnPdZ65pCIX28DhrWFODaSMWrYUv8h11xdcSHgvzVbd/vg6SdIuz1w4f39C+hmd/U7RHL1gJN656TSC0Fq5m66WFVxtLBRvVPx
 wk+OZbn2
 39m/3Rx/dcDFiYRWeLVpxXZiPavkmy1Wgll8yPIVVlTR0BZD/OCAJz8DpxPv9r+29QLPcc1aM0cgae01O0qtjku4XH2HwzX7l4jQQOPb77weLet3YQ4qYfO0HWHrFV7FG3PZ91GZKxBrelNnvdWJ8m2tFW6HYARJxSjYlZhqlTccgdYW5kpv9UKGrsvn/WvDkc97ASO2zbQvxrtMp9Hhn1QxnYjYUTSL0OCRWUloNPvsS17xLjYm/JJsp1MMiJWxFCoTbsa4id+z3sYZd4ifTPg+slueVWwn+E+Z5asnTS9azZKNA+mfQIpryUJVhmtfj1ttS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 06:28:21PM +0200, Pratyush Yadav wrote:
> On Mon, May 11 2026, Mike Rapoport wrote:
> 
> > On Wed, Apr 29, 2026 at 03:39:04PM +0200, Pratyush Yadav wrote:
> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> >> 
> >> This allows other functions to also use the radix tree. While at it,
> >> also use kho_get_mem_map_phys() instead of duplicating the code to get
> >> the radix tree root from the FDT.
> >> 
> >> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> >> ---
> >>  kernel/liveupdate/kexec_handover.c | 27 ++++++++-------------------
> >>  1 file changed, 8 insertions(+), 19 deletions(-)
> >> 
> >> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> >> index ba568d34c5b4..5758dc6fab5d 100644
> >> --- a/kernel/liveupdate/kexec_handover.c
> >> +++ b/kernel/liveupdate/kexec_handover.c
> >> @@ -1294,6 +1294,7 @@ struct kho_in {
> >>  	char previous_release[__NEW_UTS_LEN + 1];
> >>  	u32 kexec_count;
> >>  	struct kho_debugfs dbg;
> >> +	struct kho_radix_tree radix_tree;
> >>  };
> >>  
> >>  static struct kho_in kho_in = {
> >> @@ -1373,24 +1374,10 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
> >>  
> >>  static int __init kho_mem_retrieve(const void *fdt)
> >>  {
> >> -	struct kho_radix_tree tree;
> >> -	const phys_addr_t *mem;
> >> -	int len;
> >> -
> >> -	/* Retrieve the KHO radix tree from passed-in FDT. */
> >> -	mem = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
> >> -
> >> -	if (!mem || len != sizeof(*mem)) {
> >> -		pr_err("failed to get preserved KHO memory tree\n");
> >> -		return -ENOENT;
> >> -	}
> >> -
> >> -	if (!*mem)
> >> -		return -EINVAL;
> >> -
> >> -	tree.root = phys_to_virt(*mem);
> >> -	mutex_init(&tree.lock);
> >> -	return kho_radix_walk_tree(&tree, kho_preserved_memory_reserve);
> >> +	kho_in.radix_tree.root = phys_to_virt(kho_get_mem_map_phys(fdt));
> >
> > Do we really want to remove an explicit check for 0 and get a WARN() in
> > kho_radix_walk_tree()?
> 
> If mem_map_phys is 0 then kho_populate() never sets kho_in.scratch_phys
> and thus kho_mem_retrieve() never gets called. So here it will never be
> 0, and if it is, a WARN() is certainly warranted.
> 
> Perhaps I should add a comment since this isn't so obvious?

Yes, please.
After a few weeks it will be completely obscure.
 
> >
> >> +	mutex_init(&kho_in.radix_tree.lock);
> >> +	return kho_radix_walk_tree(&kho_in.radix_tree,
> >> +				   kho_preserved_memory_reserve);
> >>  }
> >>  
> >>  static __init int kho_out_fdt_setup(void)
> >> @@ -1597,8 +1584,10 @@ void __init kho_memory_init(void)
> >>  	if (kho_in.scratch_phys) {
> >>  		kho_scratch = phys_to_virt(kho_in.scratch_phys);
> >>  
> >> -		if (kho_mem_retrieve(kho_get_fdt()))
> >> +		if (kho_mem_retrieve(kho_get_fdt())) {
> >>  			kho_in.fdt_phys = 0;
> >> +			kho_in.radix_tree.root = NULL;
> >
> > I'd make kho_mem_retrieve() void and put these there.
> 
> Sure, will do.
> 
> >
> >> +		}
> >>  	} else {
> >>  		kho_reserve_scratch();
> >>  	}
> >> -- 
> >> 2.54.0.545.g6539524ca2-goog
> >> 
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

