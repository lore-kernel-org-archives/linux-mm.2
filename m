Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F7FF45A1C
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 05:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7AED6B0088; Tue, 14 Apr 2026 01:17:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2C546B008A; Tue, 14 Apr 2026 01:17:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C42B76B0092; Tue, 14 Apr 2026 01:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B12716B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 01:17:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 632898B81D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:17:34 +0000 (UTC)
X-FDA: 84656003628.01.C790095
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A12F48000B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:17:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=12sUYr1m;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776143852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4zcFpRvfg2gFpsyLn+GB/lXfcqVkmxO1BkkPIVAthpQ=;
	b=Gq/fD8SsejLh02iYGlKz8WmIZtNOJ5hyHjw29yoHecT1fTOavkABua3NZNpU5k4vfWLLPa
	/wQQkSR35yGccSrjQdiogMxjQilXuIs8XVyl6hEACOHCB/ma1PFBqf8mhJm7MjY6xLSYAT
	+nbl27oXbLKlDpzHNMnakTOrWO/9bto=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776143852; a=rsa-sha256;
	cv=none;
	b=p4g6c2huEwsoIuQyJ5f9p1Q51OEdk0BLaMrRGVJD9a3d6C5+/KqB/CMqm2odR2xva9mER/
	0VaJhHTB3TvmEspEFPicSZ+Wpli7X7T8AbbuOx3/CzoYn8K5uX1qZVn3BycdZ75RPb4Wqf
	czoDaolEt3NuMdAYM2yWqTWDQXRtTjU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=12sUYr1m;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CA4D43DBC;
	Tue, 14 Apr 2026 05:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742AEC19425;
	Tue, 14 Apr 2026 05:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776143851;
	bh=82K051Tep/JkEig50wE4zoQmsPmPeGZ44gpDUIO1KyY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=12sUYr1mFI8KyEGPtwEEyJm/H3SK5yWb3apghtC+Y6KWqtz+TlkuU3OLAq8gtd3nf
	 f0YI29yQdVlArq7MbdKsJaf1aGsJMxxYe+u8ef+22H2bp7RnIhlPWEBcH+8FfuGoGC
	 xn0vqs060EZnSWWKem3d1work+YJmIkWgmePZJ1M=
Date: Mon, 13 Apr 2026 22:17:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand
 <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH mm-hotfixes] mm/vma: remove __vma_check_mmap_hook()
Message-Id: <20260413221724.c939e483e83304fb40e3d6da@linux-foundation.org>
In-Reply-To: <20260413105713.92625-1-ljs@kernel.org>
References: <20260413105713.92625-1-ljs@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A12F48000B
X-Stat-Signature: he1wricf817m6a5rjc6td98fk98wjeh3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776143852-829148
X-HE-Meta: U2FsdGVkX18NBqJ74rZxGQerhZWKkDk4e+c8W/981GiayujN+YRvAXPhLZ4P6iLzvtVauprOiGGxfyNve59P9mH6vWYYm4KVsWZnpJeYMJA1s2sKMnB7NB4+vf073X/Hlq4qJMP674Q4JZkJtvkTMq5Bl9Vl1lj4lEvyo61L0+Lb/ZbJkqsis1qTcl7ZUz5IwTbnqRFVb/pO6n9nb/xFv01cQt80KdZGGQcQuLiy1IvYIyd0HKZypWcZRtYMfya1DZwGGGAbn91LINSV2DCUPOWD/CiufBkVX5VLU9LnmbdTX89R6owuYYytXRF9qXfjMRK7/Zzi7fYypZMhTQyDwqIm+I7TKBEaTKR8Ixo76OeGvk0rbDIk2CGbZuyLZo9uWP3gFH3GtFrW9TIi7D4BGGwJbl0F5+rBdC2/CH1wuAIYFXhkvj+iSZFYrpeWYQ734OMTWlbL9xAgfbEN7xMWhjrh6W7bjX0YfYPhAaDRR+SWqZKP3+pg29JSOE4S+a6U1my4VdYRCoZjv5UnNsoA8ai16O/WWDTk8AiOZNBcanl4N/KwIAPJawOYeA6tnCaIv6Uv+kTvtjJwL/jac+TDVl7ccfO2fEKSoT6ARwGsQulCYRXWh+fn6NxsbH52eH9mgF6XZn0JoRcMc1oe4G7520vhoI1n9CelxtKOSIQE0jNWJJO2GwccYRRGNAhatIKXEb7pFFMxl8ZcrDchHhB0gpiue590Fc7YHzLwtsaYAN2nsjvd8O5CUny89XbJdKwU8naS802tXiL+BDJYovPVeBxJhNiZ6ENNOJ3+HJIUw4swdcUoGFMAsV9jZnnFk8Vt2x44fO7r18qKX3oC14y3+d2L/h0Bd+Oca9YFfUmWheO8zrgGHvzqKBcXbrMUrAfbn6P8O/51PTmDwm9/y3eldvPC8ShWcwkCAx4T/NZoLmzdTJjTBQMUERW3uRdb/zanPaXgbJhWYVpCVAVGEvn
 GvwShvTK
 J7KGdCcBDZNsLRBlHvMIHnddRpGc9G1sywbIK6Q/HBfpBBgEZ2uZOHfYNzweyfiejcIxsSH47YgY3xmfSj1+zsSnrQYJd9Jq0DSkLM8JCKZgsqsZ8/OyrD+8BYYnk5XKmofpN5+Rf4+cJ1lFHjRLTqprfRGZHi3FEw4isPdQF+/cAT/iXbKV8GRldixY6EWPtXIjP11qV5frT/3DVOAbFyclxCglUuMvFeR4s9HO1nPUOuqizd/gJUajX0bW+wqAdb7UmHtYUET6X6/8pWOtF1eN7IC9H2k4TFwLax6/E/e9TANuhKMAZdRIlAtJdRztJABjS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Apr 2026 11:57:13 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> Commit c50ca15dd496 ("mm: add vm_ops->mapped hook") introduced
> __vma_check_mmap_hook() in order to assert that a driver doesn't
> incorrectly implement both an f_op->mmap() and a vm_ops->mapped hook, the
> latter of which would not ultimately get invoked.
> 
> However, this did not correctly account for stacked drivers (or drivers
> that otherwise use the compatibility layer) which might recursively call
> an mmap_prepare hook via the compatibility layer.
> 
> Thus the nested mmap_prepare() invocation might result in a VMA which has
> vm_ops->mapped set with an overlaying mmap() hook, causing the
> __vma_check_mmap_hook() to fail in vfs_mmap(), wrongly failing the
> operation.
> 
> This patch resolves this by simply removing the check, as we can't be
> certain that an mmap() hook doesn't at some point invoke the compatibility
> layer, and it's not worth trying to track it.

Cool, thanks.

> Fixes: c50ca15dd496 ("mm: add vm_ops->mapped hook")

That's presently in flight mm.git->Linus, So I'll include this fix in
next week's second batch of MM updates into Linus.


> c50ca15dd496 is in mm-stable, so thought best to do as fix-patch? Will
> leave a small bisection hazard (unfortunately) so putting this as close as
> possible to the patch it fixes would be ideal.

Yep, I did that.



