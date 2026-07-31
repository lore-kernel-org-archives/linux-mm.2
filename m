Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B7EBC5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9926B0095; Fri, 31 Jul 2026 13:44:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580CC6B00A3; Fri, 31 Jul 2026 13:44:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 472066B00A4; Fri, 31 Jul 2026 13:44:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FEEB6B0095
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:44:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 565E016049A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:05:51 +0000 (UTC)
X-FDA: 85049698902.23.7F357E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 89EFA160007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:05:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zVujV1G3;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785517549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TqAIK+llZBMk6DlijQEEYbjFZ2sn7l7HVlve64fFpcs=;
	b=UId80zXkrNfVnkiF4I/JDBo4Vc1PNjREo5/MvCl7I9BUcQdEhtP9ib60KDvQ0CHBqSxxGl
	s2UQB4nPjvTpRRAKjMXupS9yU5pB6PClX4yIMjVTzO90PCIkfdUcI48chRblMWU/4Et6KA
	/J8DRi2dUzyMNsSmS26qEsz+x83F4j4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785517549;
	b=1AZFxW90N5i3w33MXA9CQ7wevZ9esAgA9GNodZasamKMF4xVZbRQzbwRG5IHLAy1tl6dYd
	sO8eyb3ygiq8P4AouO7JfHNlONlrRSjs4jpTJI7LMDIX2qNnmijJrG+R0S8gE98MXt/xVW
	8DTjxykvJnnR06pCLHzDsCP7j9aw1BE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zVujV1G3;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A23EA43AA0;
	Fri, 31 Jul 2026 17:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF181F00AC4;
	Fri, 31 Jul 2026 17:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785517548;
	bh=TqAIK+llZBMk6DlijQEEYbjFZ2sn7l7HVlve64fFpcs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zVujV1G3bpuLx1untn6LC0L9LnhqML06gKvGHzDFq18UN9eR7GgjyoAguD19cc8kZ
	 w6Rs2pbBM9fYleHB8kup7z8qs2wQsHguFHll5/h6WikcKjh2PYftCazKsU/Jxj3L3c
	 h4wyrn4d3HRM1CAiNQTKyoPCQ5IVH3rZlQmVn5Ck=
Date: Fri, 31 Jul 2026 10:05:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Stanislav Kinsburskii
 <skinsburskii@gmail.com>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 0c39e2f552f5e16be695cec3a1c77d6a6bf086bb
Message-Id: <20260731100547.57414d6c37e65f08eb52ef04@linux-foundation.org>
In-Reply-To: <202607312212.u1pPx1f6-lkp@intel.com>
References: <202607312212.u1pPx1f6-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 89EFA160007
X-Stat-Signature: 97dxiye87yz9cx1t9ok6ot69t5tc4n3a
X-HE-Tag: 1785517549-97655
X-HE-Meta: U2FsdGVkX19F1IyrRgKUxYyf7ahkzsAPl9NNs6J++dgiBgh56yt1CDbYuBJBJ4Qb6iNKdmKFVy4Pn3PCs1AYarBM1pdtK7b7kDNKWVwBXV35mzMQSvcbUH5GZBwtB781IZtRDwXaH5s8ksF42wqxq//vfd2i6Uuo4cwY2Zyhq/N4X4UCZgePJeJfrbmPRKNZvku1gsS5nNfhrlScJ/Yl2831unTh0YAzjCrykL0NwyWfM9RwA/i/OaJacfOrVV1iqfC+CinwIYP3GdwDzpbHN0uvn9lbrV6EBbOmjmcMhPrQSu3mYUlfqMVSqAugWz+O5xk1bNSJZBAMmeZy0KBhVlO2UH574c6GcRJAwYCi7zQp+H4NiVhup0Pp/mCL1SCryHio7iEZoaFKiXnvyAB6k2HtW6Z5aGXp6EbZH8ZjXcld+fk7oN0b9NHDxQXQ0j4UMd7RzWN6hAyNPrTbS8xGDkFKS/qqCqhE7ax924Vpq72f12EdbKq/0ujOBgEfao3aquFTIfV38QXOwkFuHAxVbuapkdRkgR6GUwfAdSVq24wYtMkzN8LnZSvsTeh0hlhjj1pLxGo3Et3R78DLm2zehb5cRG4d7T3XC0uOEKp2/EUV5tE+eMGE+Bt/EVBQAYmjZkpEiDB1V8tKIvkfZ02EOg0BBpkh1zDL7ubWHMlgHg5cxi9UcOPV80poKmcPKOovcaE/qS6WOdtWCFHeOGeIBMDjhXNq6RI5WTkUWj98NVd2Vk76oWFxOaKdJqVDyCw7ggGDZ8GRy3mD8BFOikpsajYq9FWAaCjnJ04VRqfXd9k5mfYQR7c1zX8I9iiUEIhh3d6m5dyd2l8S3x5CbPjadSoFmPOuQwMg5XcnX3Bq0dZHS7QpxbR/i+WXTncQydew8mVbYTdv2azNGFnxJ0sfjkPdhstF+yhB4ovV646MpX4ebZz1UixZ8yvmkr9JgS8SBx4E9/S2EvGcrbJgQhD
 BCu17TSR
 kQddZBwny79DuqcwAJFgg46wdaC3UyjyIfYJ8YzGKH5pAhMLEy0NXgjvTH77p4+mavqGcPamUS9AhwMCV+bNr80mrGPBbj0bMoBJD0lyAgnRQCVMBPSphK4phhvpGuw2UCz4RwQO2qyBURxHAWfdoIme0x3v+7arnhS+Zmz5UTUG3zOvJSWGthXnoUrOI5KdZeuez2WlHg0de+mQgltnsDyIhpX9GK4yFadDXRekzk+Y55rjkcwO4UaJbmmqj0MZQ8AV3l80yge+WfrO38Ej3sB+MZOvYA+BAPZzRJ3wTLjJYYm39myRTc4+rdJODufHUXRUy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 22:31:38 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: 0c39e2f552f5e16be695cec3a1c77d6a6bf086bb  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Unverified Warning (likely false positive, kindly check if interested):
> 
>     https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com
> 
>     mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)

Thanks, due to "mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap
lock-drop support".  I think we've looked at this previously.

+	if (hmm_vma_walk->locked)
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;

...

+			*hmm_vma_walk->locked = false;

Stanislav, can you please take a look?

