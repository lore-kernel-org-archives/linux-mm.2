Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 460CEC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 06:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548226B0092; Thu, 30 Jul 2026 02:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7956B0093; Thu, 30 Jul 2026 02:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E92E6B0095; Thu, 30 Jul 2026 02:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 200A16B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:58:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B09AB4091A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:58:08 +0000 (UTC)
X-FDA: 85044538656.23.AFA2277
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1EFD7180002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:58:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VtQ6Hw6Q;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785394687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juZaVOk2mgLybaaPcDSKiX2NuHl9H7CZd5lReePxyQk=;
	b=OxUXgTyvd/+be1FLQ6i9flgRkWVD2Ta6Cwy7iDn/JxShaFHpfviyuf86rdG+nZhTFcBsgy
	NVmUQA5KZ1zzWUf+6HGPLpwuD9zSlkHPDXK9AXK0P1VDkv9KU9Hp0cs7vBAkNV8dXa8+dA
	xPiHLreOijzMaxL7uuGu83QNE5HmHTI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VtQ6Hw6Q;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785394687;
	b=a/fKdcgdnS+mlNcShofv9bMZublB8RBUyCwt+WO65jhpcDjFWe3n+83y8RLkr7QvHgIiO3
	1aJWItjYCSQRSIgNHAb78m0SLYnKzNUkOXgsWYdsA3RLsLkBURatLFUBZRAdIMwRuBVqYK
	qmp2IyEyGiGvxYhQ0i0isH6MG7WDH5Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DD45600B1;
	Thu, 30 Jul 2026 06:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014B41F000E9;
	Thu, 30 Jul 2026 06:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785394686;
	bh=juZaVOk2mgLybaaPcDSKiX2NuHl9H7CZd5lReePxyQk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VtQ6Hw6QjRd5uPS7YgtsbzrPNJlC5dJ3ukdGd7UZNSPTXE7XJbgLIdr9XRhiBlxuX
	 yh91BKP4A9zDk7sM+WN4RIrZuZ7GL7FWf1ai5fN6BYkKvOZxAXXUqnnQmppqJHtL9/
	 3HAil7y1GX+McNb6PdHpVYlKSoDtfs3MQ4yYzdlfMOc1IAz0VA7mhjQGphnzakT3yE
	 AxPc0QD87Ksdrljtets3vrOxy80YbJ3SEWr9w/IMulVXxQ0jY9tnXrOhzEaXP4F8zu
	 cyYNS6TIQ7LHfme0J4GZR7PdAQTkZ2FOdApzQioRLbnQ2iK7rHW5lJurFmBcT9GolA
	 V9nlXZvPRcZ4w==
Date: Thu, 30 Jul 2026 09:58:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/mm_init: remove unnecessary initialization of
 pgdat->per_cpu_nodestats
Message-ID: <amr1-eQ8twFONiew@kernel.org>
References: <20260729155143.177790-1-ekffu200098@gmail.com>
 <20260729132745.9d42a13e614be2e18c5988ba@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729132745.9d42a13e614be2e18c5988ba@linux-foundation.org>
X-Rspamd-Queue-Id: 1EFD7180002
X-Rspam-User: 
X-Stat-Signature: izqi4gd3catsxgf9jrohjdmf4zxje7xq
X-Rspamd-Server: rspam04
X-HE-Tag: 1785394686-892087
X-HE-Meta: U2FsdGVkX1/aAE24lc2AlzkZmQvmUOT5wLuQbefvF0GFrM1lWqv4+iJ/cMw+HNgVBhjLK309VwVadhhpqkC9N1Az5RBqlkEXZxrxK6ZetThLiKLiS+niiEIGIcg1J174TZWXf0MXHpAloBO2Lm7w1V2kyr3X77W308+m89rNCUNOu3Dh7jqHEuWJnfN81rtAcZqXEXNetKbx3CSQdCTIq0njan8+VXJN0XoxWKPNZBIDlLOTiZxqFPw49vc8KpJXaqH7r0bCQwLlj2nEHcqZahCmTaHYj8ujUugXEDc+hABXpdnBiidY+zusP+GGgKMlvk8JGOQMOcgGcm/jUO46Vv2xnTMkXfJLPzxTSkPwIRoEEHiIjKc1FF49X8nazRrkmcr9BRZvtCP9aQQ20Qd4ZaoM8qot8cZBD+8A7LGfCgBRKt0JJTmhxyoIX0fYD5zu3oWKNI4Gf2t/wB8wK5Xnv1BF9Y2xTa0CfredhPtySSH5IxHFIxR/32SEBDdV3WoQwgp6tJFbL6F3xvPS06V+sLpKMR/NBynWgA22LgHreQON+QD9zcRtZADNIYXP40TkQMZRIounQWNEnh/vf6ZHyBFybhLLOWYyTF3YVoCtrPO/CK4g5G834+FzX6kq6q4KnjX5Uaou60IrvR34SrW7DZjZVsovclQMdQXbhKNG7ij6gRV4gwYQGNrkOTv1XfKoN6U/kQ5W1fmhbaMkQJn0c+/v8Lbo5x6qJaQkYPb15f3/TvdyaVQLE3r2i3KhJSASE/dX5dVCuowaAXacpLeEPGJFyAKXwXVBnqIXYm7torc1l7zm66eYUdF8Y7hvyHCxBRslQmJalkkURbzihFwCaSubYc5xqq9m4Q/LMm59T//+bfGVQUDN4u5Ui/VM2JY6NmsUVgYrkfczi//s1jW7KQLIQBozy3AVbieLT/waOcIl/kChQM6n8S3hRXzsy8Ve2EgIurooeQeXNmy/1FI
 n38ygRMv
 TLvJGNEw76/z5L+7sXiTdwhKl4xspW68QGGRc/kO+lTyHWcaARR4/AITdnYGCcWjgElnRmpug1kxrqWT3iFXN/S+JLeV4RNUWkqxsCgB609Nt4xjHUcKBbP3f8kFoAPOMQxPn8HjbU81J7hvRRfopaR/E3FSIkQhnnMJyRz6FiE9lvogpu2Ed9S2RmJNdn3RFHB6svdflcx1JuQ1dmcY43fnlDk0XL47TpQ4mBjWbnJOZauHigN7VNq2MkvxW0a80nP+ZWXmhExHwSCblSFzFvWwBU40E/dM9J3uoUD/nAlii8uZKC6kRDrj3Atjh+pmizik6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 01:27:45PM -0700, Andrew Morton wrote:
> On Thu, 30 Jul 2026 00:51:15 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> 
> > free_area_init_node() sets pgdat->per_cpu_nodestats to NULL and later
> > calls free_area_init_core(), which unconditionally overwrites it with
> > &boot_nodestats. Nothing reads the field in between, so the store has
> > no effect.
> > 
> > Remove unnecessary initialization. No functional change.
> > 
> > ...
> >
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -1722,7 +1722,6 @@ static void __init free_area_init_node(int nid)
> >  
> >  	pgdat->node_id = nid;
> >  	pgdat->node_start_pfn = start_pfn;
> > -	pgdat->per_cpu_nodestats = NULL;
> >  
> >  	if (start_pfn != end_pfn) {
> >  		pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
> 
> Looks OK, thanks.  Although this statement is "free" in __init code and
> its removal does make the code that bit harder to follow.

Heh, it's already not that easy to follow :)

We initialize a few fields in pgdat, then setup node and its zone sizes,
then return to initialization of the rest of pgdat internals.

It feels like we need a larger cleanup there, and this patch wouldn't
really move a needle.
 
> Possibly *pgdat was zeroed out anyway, I got bored figuring that out. 
> The memblock_alloc_range_nid() kerneldoc is silent on the state of the
> returned memory but I spy a kzalloc_node() in there.

memblock_alloc_range_nid() does not zero the memory, unless inappropriately
called after slab_is_available(). But alloc_node_data() that allocates
pgdat's does :)

-- 
Sincerely yours,
Mike.

