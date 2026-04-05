Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 304A0E64011
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 04:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5BB36B0088; Sun,  5 Apr 2026 00:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0CDF6B0089; Sun,  5 Apr 2026 00:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23076B008A; Sun,  5 Apr 2026 00:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF5FD6B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 00:36:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 103A45BC53
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 04:36:16 +0000 (UTC)
X-FDA: 84623240352.07.9FD8C3C
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3A78420005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 04:36:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gBvIaipp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775363774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRO9W2hfI/BSBDTftXJZfBbu3HFf6wv71UgZO5Fk6uM=;
	b=hULaht1liNqI0sfxg0O3zRznHoi09ypJPTDOV+XfwiVyNoj8zbx5PJFLCyp7/xnddEkRI6
	RxgXXC5o9b5LTA0j9su7Y0SOOz+dv15xJMQsgbgNxYYnzpaSPDTPpcjBRK9lJ7833xa1cd
	Cr0+WfIrTwDemRrn7ri6qvEBvUKwqgE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775363774; a=rsa-sha256;
	cv=none;
	b=geNWW1T9utYdJy/L9+BYR6LD8FrL39szf2SvYUKciUBAi3z+nh/Py95USp9GpG/ljNeuM7
	SVojfkuulGa4/NyvaBvHfY68GNBVnwA0X/hmUyeM38qjxEtmheXZGyPChDmwVraVReKrhR
	MtpRKL2mCcJvwuv5X+NjEoJ9RkoCn7s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gBvIaipp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
Message-ID: <01664abc-05c2-403d-a9eb-b2b780a1aaae@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775363769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRO9W2hfI/BSBDTftXJZfBbu3HFf6wv71UgZO5Fk6uM=;
	b=gBvIaippW/ikq/XAxO9ld/dCCdw7GzFQT/8DvVcl1evTSUIJ07lZZFA2EpThgi/Vp9Heu4
	Vr3rnx/f9Gjt7jiw+zteNdICTHZyueUTlV/9Cth/pcd+a6Kou/uwT+/F2srQODw0rmoQK5
	jtmnXRcQ/wAA3R+5vUb7c/OboxfKNIw=
Date: Sun, 5 Apr 2026 12:35:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] lib: test_hmm: evict device pages on file close to
 avoid use-after-free
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 david@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
 dri-devel@lists.freedesktop.org, balbirs@nvidia.com
References: <20260331063445.3551404-1-apopple@nvidia.com>
 <20260331063445.3551404-2-apopple@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260331063445.3551404-2-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3A78420005
X-Stat-Signature: xiy8fxbw8csossqs553taii6npjpxx6d
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775363772-513858
X-HE-Meta: U2FsdGVkX19Y3DiZJJNyMjiOx4AAq81gv+Q6smOiff0xtquxLlva0IA+JCojItZWr7ng2FfCanAoV/IzR2nA7HATO+wFEezHzYT2PCX3zHjujVi3KbPSQdfZ6EeDlOzkdR8vho166stZDuaAweh25sr0Nc3aM4cL5H2HIRJJQ+s6nQpEczmOQxW79qh5w3HR9Et99Sk2tGen8HWDbMQiNoEngKY/sr0yaLPTfcEWDJ+dr8icIsqQZiGSFrD7wwtzWdfe/ARrL0uY/Gg+tAgFg8odYQ2GPLhxcZF+fnlVDpGOv1uDNMX5NRgrhuFOTW+ijSt4MK25tRyqG+onN+zv7fecFGL/fm0pnvAmF92ZNLlLM/E6UXdZugBOzhZ/mAMVAlByS8nJ2OmwR1qJEK3xwcyAMZAz+IW9gVQQeAI12ZemvlDhs+0drVBmfC438z8OsWbe5qKSY+xNdsHCuFzqP5OIjgC4K2QTdbNUhDg3ANXGi6RRHcHwZ9yWsa8ZXyoYkwDuJDN2co95bK+kASXmea/laa+TDpjiKYW2BVhmKWfEx3gVvHg6loMkXcfBGnWt2uX57t8un82PdROvbyc/rCSelSq69uX2MIr76XbIuimNa3OSRWeysmYjHZZlTWis4q3GWc4/Bt8H62i2m5RQMwRqOTdKUaGmQw1sxfLx4gBHA+8KKbGWZ5Ya5VIvzS4X6wXBu2twnAJz3XSiXHFSEHuVxo461uwQKMtOvtFXCJ8/eh9iqAOidMGBRu41Lh5yPh4mYtbxxGEso728EVsdd7qpCH6FLcYva5CLguEe9D1o9pq5I2liwmOm67lpTOUIF4/kq+V4aIUGzXt/HhDH9aBDD/zvgghJWCX+eOuoM3/vq8839d8+YeIK4aGhn7jHoojXDgSN/UFr7YGo4zXVWEwnp2ydRyH/rgal44YOG/z5hJ9XECMQOcfs3dc0f66BrQaeZEcRnN4gpBCegZt
 8f3Pl8Wa
 uQcRAmNYQ73YNhpqhGVapjxRFZxHsP6qnp9NtsF0fhlg4pvJ/TlA2lNCOb363Of89WeFc5Z39E1eJd3WrsLH5pepi2X3JWR/adQ/RDh+k8OGiD13vZO4njYxHvSR2zpEqptdLnA+t7uT2NZj/R5czC1S/sU47C5OK/y8J5VH+MnZqArtZ3DPTPCtrboyLjlYMjNiylk3t2Hdjfu8/IWm9lSCiwTlTjXY/8iM42tqZy2Zd/hQu3WhztmNvOOKLqwIPvKVikBroc18Ua+lCDCmP44+us0GyvearP9PdAHHpao+gsTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 2:34 PM, Alistair Popple wrote:
> When dmirror_fops_release() is called it frees the dmirror struct but
> doesn't migrate device private pages back to system memory first. This
> leaves those pages with a dangling zone_device_data pointer to the freed
> dmirror.
> 
> If a subsequent fault occurs on those pages (eg. during coredump) the
> dmirror_devmem_fault() callback dereferences the stale pointer causing a
> kernel panic. This was reported [1] when running mm/ksft_hmm.sh on
> arm64, where a test failure triggered SIGABRT and the resulting coredump
> walked the VMAs faulting in the stale device private pages.
> 
> Fix this by calling dmirror_device_evict_chunk() for each devmem chunk
> in dmirror_fops_release() to migrate all device private pages back to
> system memory before freeing the dmirror struct. The function is moved
> earlier in the file to avoid a forward declaration.
> 
> Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> 
> ---
> 
> Note that I wasn't able to replicate the exact crash in [1] although I
> replicated something similar. So I haven't been able to verify this
> fixes the crash conclusively, but it should.

Yup! I've verified that it indeed fixed the crash. Thanks for the fix!

Zenghui

