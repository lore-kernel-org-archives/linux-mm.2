Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE30CC624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 00:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA316B0092; Wed,  2 Sep 2026 20:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5742A6B0095; Wed,  2 Sep 2026 20:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C8D6B0096; Wed,  2 Sep 2026 20:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 171FD6B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:52:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 977B2403E5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:52:44 +0000 (UTC)
X-FDA: 85170625848.23.2CDF715
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id BBA20160002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:52:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=h41+C74g;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788396762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJgfeG9OkO77dXNQBRcYGcD7KsQqp8aI0V+XoArsabk=;
	b=LjZMdJQANGcOl818KTJmSgL/ThnajdKC+u3Y4l7/WTyliayPL0ij+wZw0GjtPa9WFoHsfz
	5iwxN9gPN//N7QDpzeP70Jp0kcjrnvxfOefaWEbXGRIbex0RY4yrE5M2EaQhDVPloK+QdH
	mMpZecGKVMjg592SSfgxfMYkLBi5TZU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=h41+C74g;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788396762;
	b=g8YzkL0yqptjQBZqc2v32aeeJXGqkghHjmz+OURD4BEPA45tmwI/NaHajZmjnjJKCJ/JRl
	LjsxzsU6z5VI69RZ+YMbRwS+vcnOcph+lBC+clk9Tl7g6eRtWDEVrx4LmaxSqqabOACVgn
	vBkBQGpGWt+wPMg+5RqXS/w74iCMdN8=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c0006ea8eso22891281cf.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 17:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788396762; x=1789001562; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PJgfeG9OkO77dXNQBRcYGcD7KsQqp8aI0V+XoArsabk=;
        b=h41+C74gFkbbWOJOcH0y1MMsqiCtdsF/mIcV/bHrRbd0iEfcRtUtCk8BwYm2Fn7nku
         +ib8Udg1OrJDJt2bcfF7MirPp3NQQAV6OOQkZX6lVaYf1ROyLZ5tzS75zBidG3kfLSkX
         oEQW6kfRllVKsBZL5ZaKvz+8In1gdTr6BHSiwCqg9/gGS5d4vcWmxAyM9qocYLZRjGZX
         XbRt/I7XQQQ4Oynu8grNNNwG34X3/KVNRbGwmhi+Ar8wkFuWhh+vroqfqU4iAHoZsj+I
         oQY8OlbKbp6fJhXSF82xty3YZ9vgYDecv2hbPEzcpjzD7pKiQveGqUCBtlIGiP8BZX+W
         5U7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788396762; x=1789001562;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PJgfeG9OkO77dXNQBRcYGcD7KsQqp8aI0V+XoArsabk=;
        b=p16Bo2g9oodCiZpxKTxCXH80QGXE8CcekJNOggfD9khX3YOZLv5AySl3JTLaMqo9HL
         KmAj79WpxlZtDBiRirsLS3uruDB0iXrtigOV613QiRLZtWXP4mwpRXovdIRKAtLHWKGY
         MAZn7SlBwX6QhGdgSvHMW/6qu2mqXJCOnzBckUR3lDN6ORrY6paAuRG7H7utiwW/q4rs
         qd8QlRjg6EXSf1MVdJzmMh6khYB6tHPMsy75IrCiZymRYTl8eKN3UYDi3ZxELDOmruuU
         v7FSMScr78rcvP3jLkXW5YRCt7KOn29OXRqSFvzLs3Nqn/QRjAkpmU/qJTYwNwRCvzMO
         yWcw==
X-Gm-Message-State: AFuF++m2781DQYxWuVwM/naT9UNp0OZjFy1bHY9IatiBD7tmQtcwuHF9
	3T6SECHve42OdEsgu3/ytFOlfVQ2k0G7oxopQiqW1vH/ym/ZcIOO4PzEfzfFv9/ppBfEyuYFYt7
	MC/LTuJo=
X-Gm-Gg: AYBFou1LewiHZCGcUbTe1OUrCnHBlZx4pjbuk/6IEQYCLzGnipmc1DI1D7xMX4qusG5
	bH4XTfSouBlA9gqzvJMPBEmYnen0ytwFikAXdqtzMcubPSsQ3uYidwPQv0OY4SyC5fZ+R3tqqXz
	CUVwJrJx3XL6JlSIkoyg72yJjTakIXP8/HRtvgNAEULzecNfMQ6Naf8ORgi/06GpHuE7wEhGY+P
	YXiGahtAjafT6hu/eeZQsoXSKSGik1a4Pz20BgMfuqJQdGk8lsU+sOAIlj6y/4N6B7taP9XOF1y
	4pzJhHjIcvLKQz5qkJOJPYcDutguPUDTKmL+iPXMrGnuFwgjJ5Prk/L0mF/53ozS/VR2m1UKpC/
	2d5/fcTqEDpp64liP+kOc4Xd/Mtark6+pwZ+U7OjlZvKVDLpjMn8909/thtiBTK6lLKrSSTu8tQ
	1rcmyEc3VmfdROtEIWqOm5ftMxiB2vEL5PPHnPfz56UCt6YADFUdIgwX7aJ/OPP/p7DS0hOiLO3
	9w29pFDz8hgSw7FyJJBUGtW+mMX8m8UhOSA9MlKRGT1/l2tEWA8Py4=
X-Received: by 2002:a05:622a:1906:b0:52d:918b:92e1 with SMTP id d75a77b69052e-53036b93351mr100930171cf.5.1788396761900;
        Wed, 02 Sep 2026 17:52:41 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530331dc460sm31323441cf.18.2026.09.02.17.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 17:52:41 -0700 (PDT)
Date: Wed, 2 Sep 2026 20:52:39 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH] mm/memory_hotplug: factor out node_is_memoryless()
Message-ID: <apjESMmhP61ovLuu@gourry-fedora-PF4VCD3F>
References: <20260902195507.88655-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902195507.88655-1-gourry@gourry.net>
X-Stat-Signature: jjj8gycmwqu9zboo3i5inr1deqdk1x9u
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BBA20160002
X-Rspam-User: 
X-HE-Tag: 1788396762-504278
X-HE-Meta: U2FsdGVkX1/lUViBEFy8TMu2NzaDhZ7ygtxcrv6j1KE9D2Mh+mvasXSVQCT7XQNxOv+cBlYlArfLt+BXxOWvGPrBZkcb1vcL7J49H+nYlMVtnGQ9WXoXWy4ZS5wMZIHtRLcIZ/ddmi0/SRVoHal7FasR5RV9ufPhpVmj4QSen3qVgy8OiFXKgF4yNsNqt1sl42YLPcJVTOt58d0l22puw7EqUALNnzPwDaPrILqRIWlYbXfv0cXAO1rgZPOIl3UgcTD7bKJb4YBIqB5+7pexu30t+FJ4YeUrEQSlw/p61U8swa4FldyZ267fQwHuUe/p9DkoDyRN5vGs/gIIh6hl7JrcCMK6hd/i61T23ew4BFc//3L9qFYaykFbkcQS992C2lwUWqfEpo4uMy1qmqPTjIppNYPxMjGEt1Ie5GZUpO+icpZOo9lMTWbo90kpyebGp1Dww5y0FivrHtBsQIlKSOLz9zYC7N7V8vWJbza5isyRxUpWi4agdlwqNP5uceelNBT1VmfrT9zLwG12+QXUuP4O9Ly+Q+RrHTnvAQ14pehU82iUQPH0c7GKlQanznjKb6zZEkHZkDTXFrPZvgredYrAE3zlvXZoQefLA1FWYqHhA/l4oVXN8SnA3S9mwWHn7Ozd/9DIpp0ByHUFFmv40EkaRNtjfJwkVDh0xV3qROwJhIik3spEewJhDCLSL3tST3rV+DaMJpBabKNaJEgYwvSI9h1PexURamxqI4ORsSzP2/5kZ4/HRGFgRM868MbIhR8ulI8BKUuU9RSSBWiggr84uKTu6ifg1owkML7GOfzuG2GjtIA2NkHOraxsBWkLiS0EUIxdT8DUBFAZGmnfoG/c+/T82wwW4uwhOTtLHHgT/ZMhcjg3HYaVBtlFKo4y3SnFNDWQiUoxACtuZ6zDceyfjUGinzVRG3G5NosvwtgbBoOhE8+bBMxasXYl7IcXJ36UNTfqVciRePhBnS1
 KaHi/QxW
 2pOsb874PqiA1TNXWaSqET6UX8sTr1ZzSKFlyJTti1omcyyw9brXZkgzIapodDUWeRLc02J1xaNh75HxDbAY16qGlafjxaI9ARSGYQvFS8dg2ESyz9JRHabglRhKRyKp/mybZ5TFgK4OKgIHUYItkqVJF1B9skaeNRObUuvAXBwPgAWb/RGXj4+mAAbq50vKf9nBiUxOyxZ3Atmgw2nAl6Ia44yD4Zs721YpW/4M7hBoZ61aPZvciah47z18eoUL20ERMvstiFSVV5fICPhMU/U8kpfK1+V574NS9PM/CQTz9j8bp5l2G0a/x4EAXQYlYyVpWdedldsXE03uxmPS3PxM0RmgmbCe+CDSH2gXoHvXiFWonbBrpwxYJvY5ZQ9+FVnx1CYugoYjTlWHVD1lT8QBxGdx2pRuE0HoeBj9HXYBBr5bKZs9Z0tOR/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 03:55:07PM -0400, Gregory Price wrote:
> A memoryless node neither spans present pages (populated or ZONE_DEVICE)
> nor has an offline-but-added memory block still linked to it in sysfs.
> 
> try_offline_node() presently open-codes this memoryless check.
> 
> Pull that into a node_is_memoryless() helper and pull the existing
> check_no_memblock_for_node_cb() helper ahead of the add/online path
> so it's clearer what is happening here.
> 
> No functional change.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  mm/memory_hotplug.c | 60 +++++++++++++++++++++++----------------------
>  1 file changed, 31 insertions(+), 29 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 226ab9cb078ad..d0e94057682af 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1491,6 +1491,36 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>  	return ret;
>  }
>  
> +static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
> +{
> +	int nid = *(int *)arg;
> +
> +	/*
> +	 * If a memory block belongs to multiple nodes, the stored nid is not
> +	 * reliable. However, such blocks are always online (e.g., cannot get
> +	 * offlined) and, therefore, are still spanned by the node.
> +	 */
> +	return mem->nid == nid ? -EEXIST : 0;
> +}
> +
> +/* Caller must hold the memory hotplug lock for this check. */
> +static bool node_is_memoryless(int nid)
> +{
> +	/*
> +	 * A node still spanning pages (especially ZONE_DEVICE) is not
> +	 * memoryless.  A node spans memory after move_pfn_range_to_zone(),
> +	 * e.g. once a memory block has been onlined.
> +	 */
> +	if (node_spanned_pages(nid))
> +		return false;

browsing sashiko feedback:

[Severity: High]
This is a pre-existing issue and was not introduced by this patch, but can
this lockless read of node_spanned_pages() race with ZONE_DEVICE memory
hotplug?

---

This seems legit and worth addressing (other notes are addressible as
well, but this is maybe noteworthy).

I actually have some old patches sandbagged that tried to marry the
ZONE_DEVICE hotplug pattern through mm/memory_hotplug.c rather than its
separare entry-point.  Might be worth a revisit.

I don't know that I want to predicate this particular fix on this patch
but it's worth a think.

~Gregory

