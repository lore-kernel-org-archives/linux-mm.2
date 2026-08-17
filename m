Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C64DC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 18:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3E136B0102; Mon, 17 Aug 2026 14:21:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EEB36B0103; Mon, 17 Aug 2026 14:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905386B0107; Mon, 17 Aug 2026 14:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FBD46B0102
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:21:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9A2F1408D5
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:21:54 +0000 (UTC)
X-FDA: 85111580148.03.4F98DF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E4FD71C000C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:21:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gKkEscvG;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786990913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0BkhnPeo1KLR/EUoIgA+xCcjgHScjG9tYFnOWvoAumo=;
	b=wOieJMPTjedfvoCnCYl3ALlRxQ2lPeaP1NyygMQ9mNepUHfD+d3uPUAByi4O/Q25DQiH4f
	2GvoWBFf+zWLoS9H1faK/Pn7OQZtipi1tqQh3bwE4sBblOo0FzmFKlbeHzncX4OnxpOonB
	0xtL1QR9T4jYgynNLsywaDrGJHDnQiM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gKkEscvG;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786990913;
	b=5G5pcilGlzxvk1RaxGjQ+aOdAC35lnOzcLYpfZlRYqUEIocjoo3gvkOxTqthX+PY1SXa/6
	9aZiKkm/ZcniVds2pKeAkV9ohfciR6To04pcGYdBM58kL6YWKyfPbWQ6PjnVaSFt3yUsAp
	ZOkIWTOSNIfDLsWoiI37qqTMUcU036I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4239B601DE;
	Mon, 17 Aug 2026 18:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DEB1F000E9;
	Mon, 17 Aug 2026 18:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786990911;
	bh=0BkhnPeo1KLR/EUoIgA+xCcjgHScjG9tYFnOWvoAumo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gKkEscvG2SIHcy2Pg5QQ00VuMOZJzlMUKm3IDezGJIVl6RotLuqK5O1dx7WXfvPqk
	 qn633LI0SYaf/GuXCCz7xSD0DE/aNWKtTkf2y7FQNXJf08c4CGxwXvofvQ2dFmIAtB
	 H8Lzo10TFV1Vq3Pw1x2HPaFFcTHUkjzAdFDYPdYo=
Date: Mon, 17 Aug 2026 11:21:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Su <sh_def@163.com>
Cc: david@kernel.org, balbirs@nvidia.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/migrate_device: avoid out-of-bounds writes for
 compound folios
Message-Id: <20260817112150.aa6cc927cf501d687336c0ef@linux-foundation.org>
In-Reply-To: <20260817120758.669807-3-sh_def@163.com>
References: <20260817120758.669807-3-sh_def@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: oqk71cwehigdokag5jn3p1s1is46c5dw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E4FD71C000C
X-HE-Tag: 1786990912-296536
X-HE-Meta: U2FsdGVkX1+58YhroOibsUtfz+rp4Sn5wLzSzqhxmjBwbXuEAzWA+fSeZIoXRlAk7WQdpR4Sshx7GPEYYi0iQjmHDzcLbTmDDwqrW4u4O3gxU/8rS7KN/lQcDa9lie/uAh5J/XcSyaeDMayR0aQDquQQfVQstKwCBUJ2hZkIhoctcCCrQim6bxzzRYsE5/+XszgGYnNUsB/A5ds5VyD6DhzeeAv4oFQZsg+xvFMDnyK2zQL/EqI3/yXIBlo1K7UDoSPFmuifokTo1oBBfNvun1AiJ45jmrPDXyCI5B+LYtjxm4xJPcvIirFx1CEOyE025nNFce9rr2t5+hrz2qj3/myUqvESMu0AgcHw6uiu7KUbuTBClvhtOqU9Z0d3Ug3GapL5a6ZYdLzG5mqkR6a6IJSKdEF5mJQsdmLXqWv+LTHEWGqbkPKV2RXLNjTt0LEezbGDDbAbL2HgUCW/Jh2v0HmPJnaIqUD5lA1YgtoN5ogKC3UmDxKcAqTbjIonIDeeNLRNWlwhQsqVruvfIOk8PSoqd7sU47qm5EldHYBnGjwl/TWB/4xMZfWKBF3CXrLLDyJoNlvuzEIBTyW80JL+R+F7cx1Mvl4cd5CFh2RNHEfsJEp6fDmU5vaI/lTGVqt/nLEfKk5Fxl6zBxkBZh8hULhi6Yh8b+9gWPxB0QDX9EAdHBlVozBfbcgEDQYqCMpxSJqDfi8qai+VOC1s+b+v5iiNb0hxTVOypG5a0RXYMyGQn/NVk/6JRyicurGTLa+YF2A/juHqM3n14GANcae7A9t/CA/aI9jYGN0JP7BhWGCtfHe7SAchMTAcm+UstTGdsUS6NNoChlKcHtooQWA2aJMoP+R495zRR75rdibtahD2ALctkr5k5Ig1pWrk8VpDH5e8dolMOyJDER2u8GmJyo+zMwJcN4WlSv0XjMHskA1NZZZ5QTXS4bFFDrJA30Dti2iFI1CwzfaPpl9uY8y
 PG2e/ErP
 IQOl1ESPqxm5XaQ26llQX3m+IV/R1D1MKuCPdcOJTOVky0zz2LXrQg2a4QFEgT6Hyov8xwEQSWJZ+v4YmAyBhmQIB4STfXib4pzJRS4o50SgwNnToY1EuWGugCtF/1cLnLHBSkdMcQoSloI1xrK1k6PEOCBnA+fOOuMVz/vDqZ1UwsLL19ZCU6ZUsnGEPBeMhJG/vkvhDQIkLOQPZLxDkrtxQJrWQlNIf2/0IiNKS4bMhPbyZbwCat4ohWt4WGjjgc2QN3COnGQY+QgOArxJW9GyzJctu1MMYr4NRI8e82vRqlRw5HuxzUDVRsQuu29BOKizT3lwyMbxMgqrUvgZFd5RILE2sIJwqBch5YId8hpxLI747pBVTULjC4qXgL2PDFzl/t3La9sHMNvk26Px+0MeBYbk0Tjyp8O9xKZmrM6bmL5xM/+aCL57qcsB0hFyrYNaB36m6vdaccdw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 20:08:00 +0800 Hui Su <sh_def@163.com> wrote:

> migrate_device_range() and migrate_device_pfns() clear the entries
> following a compound folio so that the PFN arrays retain their
> page-granular representation.
> 
> If a compound folio extends beyond the end of the caller-provided range,
> the loops clear all following folio entries without limiting them to the
> number of slots remaining in the npages-sized array, causing an
> out-of-bounds write.
> 
> Do not proceed with a compound folio if its page-granular representation
> does not fit entirely in the remaining PFN array. If this happens, drop
> any reference and lock acquired for the folio, clear the remaining
> entries, and stop collecting.
> 
> Observed with a KASAN x86 QEMU kernel using the HMM
> migrate_anon_huge_zero selftest. Closing /dev/hmm_dmirror0 after
> migrating an anonymous huge page to device memory exercises:
> 
>   dmirror_fops_release()
>     -> dmirror_device_evict_chunk()
>       -> migrate_device_range()

It isn't clear (to me, at least) what "exercises:" means.  Was there a
WARN?  Did the kernel crash?  Did it erase all my cat videos?

IOW, in detail, what are the userspace-visible effects of the bug? 
Please add this info to the changelog and maintain it.

Sashiko might have found some things.  Some pre-existing, some newly added:
	https://sashiko.dev/#/patchset/20260817120758.669807-3-sh_def@163.com



