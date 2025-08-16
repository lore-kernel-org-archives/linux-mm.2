Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EF0CA0ED1
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 00:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 459458E0229; Fri, 15 Aug 2025 20:41:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BAD58E0008; Fri, 15 Aug 2025 20:41:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8C58E0229; Fri, 15 Aug 2025 20:41:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF0F8E0008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:41:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ADA26140325
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:41:49 +0000 (UTC)
X-FDA: 83780767938.20.E7B5352
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id B6EA1C0005
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:41:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JdKaLCor;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755304908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ojKgaeOJIavwY5MGBDiYWe4zl4Eo5ALmEoHlqz63x2E=;
	b=wqgBnsfhr3hmo8dHWXzqA8LEWZSk4EIMMlFDloWHzFivlT3he8Q/wmBvebDkza9IoGjm1l
	Im8MCny5ZaFFap/TEHKpd41v6O9KI3D2wF9DWFmvXVbClpBA2BBDo7qSSuFIZe/KJ5L0U0
	5komQUP2QRycxGqmDTyErqf+I5yUXwk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JdKaLCor;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755304908; a=rsa-sha256;
	cv=none;
	b=lqsO5L73Hx8e8zynQbNyC5guiNngdLPrfaX9ubY/KHMBoAy9J7LlKSl/4Jad8IbxfSfFz7
	+9+1nW3RxbPSqvwVdJyWUHJrYxfh0N/qbQndJtE/bq6ad+VV/JONN3+5aCVv6D8+kFx8kz
	buvwtg7rGQcYEVhlYm0CeKHVkTe6+64=
Date: Fri, 15 Aug 2025 17:41:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755304905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ojKgaeOJIavwY5MGBDiYWe4zl4Eo5ALmEoHlqz63x2E=;
	b=JdKaLCorLvM5TlpNcBpEwEodyIeca3CAyVoSJE/vYjtxN+yP2HQK5KYd6NtD+8t1d5CgRa
	bRaeHAoiR7oN/VNxLjFUmVBflP6D+JBIuBpQreljuLdaeiaGI7Q8n9F2y3QN87nUyvdNxI
	wB1SyGP4BFsYJbp3W1+lcpZBb5Q0CAY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@fb.com, wqu@suse.com, willy@infradead.org
Subject: Re: [PATCH v2 1/3] mm/filemap: add AS_UNCHARGED
Message-ID: <363p6uyyrx5gruugrlq5kjxwz5gmw762s3nnem5nydkflwbhxy@jpnk4gxbpquj>
References: <cover.1755300815.git.boris@bur.io>
 <38448707b0dfb7fabae28cbebba3481eec6f2f4e.1755300815.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38448707b0dfb7fabae28cbebba3481eec6f2f4e.1755300815.git.boris@bur.io>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B6EA1C0005
X-Stat-Signature: j636u49xm6x534g1b5rswhaekq3yb5eb
X-Rspam-User: 
X-HE-Tag: 1755304907-693807
X-HE-Meta: U2FsdGVkX18+WMFOlgWUngFLiN5D96591+y/R2Lhz3YFLBdmK8KbGVXsNOiM97k7S9TCDtMKi5MgFAc4XaIPsVX33oyBAXJuA97eAbuMU0qj5EZXPy42ZudzB0mf1afX83kkEBgPncAMRbtC+PP9R+5n+FfX0tE9jcYaglHVRlhPguZ+YHGocb4dZO6XfHeIYxYYXfLZYr2TtK/M3pdvyYzMkDNAKNVYqY2uQowHtxjElENX2/Q5FHL+3mEQDkoplR3dAjuDnOTzxcV8GNLTY4lxcEOd8dIF1FtUaRVCCTXpHSYaTMnnLmkL0ITBcYoT2DTJEmIP8krmTUzzH6oAa+/IUtU2i8DpDV6uWz22ZepchypxiOSnn+LVVsZL3ysg2pQtAjTw/BdYBuoF6mOVuTMjs9aVBgWR+2vbn3UdV1rkvAF/4yyNuCp0ZOu3N0mtYN+HF2r61htZnt/Kjue+CEi8bKycW8cStt3acWugmq0lvS75CiWD7afv744YG0SVFRXWj2ngaLkAagsh6vwg3uU/vGYcDJoimddg4Ly7vEj1xrwcReIKkkiZ/FPlSwBCeVTHRd8VctlvX1ZoRzA5/4t5Rxn0hrKQIQCmPRAJT+p5aHBcCUGAtLY0CgrxRazNs1qv+eAuyLX6yQmAHKLPeQ+2/ZAwuiV+R5tJ3M0AXpf5y6oHfT7ep9YmJdG2aegYjexTtB/td5KOIP/biQHZf8ES23xnfYdCvcIEjtTzywFDz19C31esK8WxB1kaToOEyJQN2ljKojML4fPx4U6SGbJ5OepqhLMNuWHS8WxEV9SR0s9TDM7+Q0UF0Mpc3gQMGcwmQ5V/aqxFfi8odMwz51BWgjbIK2PQXdi7VxLqWK4l6JTvDO3DyTyPmQdE7sI4MNLOeVzAlAQtZ3nIcc9sbt7jMpkiqFoNNFZWgYJX8XYKLhm8Ve3HZ06sFhZf53HNy+01iufFRLveg6baYyP
 KW55qIO3
 Nv6MlONeNd5mggNRDwQIegtTITKR28f5heKX23F5TjG81SprEZrN2sK9yqIHIwvC3OLBAZ+bgtmpBp8keO4q60h95sjwWVuC1Mfr8/qWmKyInRvdd4tIjZ+V1zxRdH3+xnXY5Zke8ieg4pNf6BstReTZboeMp7B8zBETP/0uMEKUDFNKMTxv5yPT82/W3/eMwjrIA90XATOqlPFXr3hLhcLnygWsl6IkQd+EI4Hf++/ZzqFsDo7B7+NOAphfr6orv3WgckxElCNbGwvxNZimi9SIll1Perxk6SDFUdhn9aavswTKJZ7S8pu17htwWCKTMTJK+PymsZFEUqIQuZ41ns7koBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 04:40:31PM -0700, Boris Burkov wrote:
> Btrfs currently tracks its metadata pages in the page cache, using a
> fake inode (fs_info->btree_inode) with offsets corresponding to where
> the metadata is stored in the filesystem's full logical address space.
> 
> A consequence of this is that when btrfs uses filemap_add_folio(), this
> usage is charged to the cgroup of whichever task happens to be running
> at the time. These folios don't belong to any particular user cgroup, so
> I don't think it makes much sense for them to be charged in that way.
> Some negative consequences as a result:
> - A task can be holding some important btrfs locks, then need to lookup
>   some metadata and go into reclaim, extending the duration it holds
>   that lock for, and unfairly pushing its own reclaim pain onto other
>   cgroups.
> - If that cgroup goes into reclaim, it might reclaim these folios a
>   different non-reclaiming cgroup might need soon. This is naturally
>   offset by LRU reclaim, but still.
> 
> A very similar proposal to use the root cgroup was previously made by
> Qu, where he eventually proposed the idea of setting it per
> address_space. This makes good sense for the btrfs use case, as the
> uncharged behavior should apply to all use of the address_space, not
> select allocations. I.e., if someone adds another filemap_add_folio()
> call using btrfs's btree_inode, we would almost certainly want the
> uncharged behavior.
> 
> Link: https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Boris Burkov <boris@bur.io>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

