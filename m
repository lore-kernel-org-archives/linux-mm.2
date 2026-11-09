Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 798F5606A323
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 02:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XL2WHWTD
Received: by kanga.kvack.org (Postfix)
	id 749056B05B4; Sun,  8 Nov 2026 21:37:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2126B05B5; Sun,  8 Nov 2026 21:37:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599D06B05B7; Sun,  8 Nov 2026 21:37:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 257BF6B05B4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:37:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A5F040597
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:37:57 +0000 (UTC)
X-FDA: 85414020594.04.1A60E6F
Received: from mta1.migadu.com (out-54.mta1.migadu.com [95.215.58.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id A34EC1A0006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:37:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XL2WHWTD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.54 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794191875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AEGX0/KL7mXbSaJY8zHxrw7A5L4IFOgbizn++kyw2IE=;
	b=Q5f2Tl00bhTfPdcT/zco5k2PeDVKqS7Z17d0B1Lage2VEV7nnGlSgNgNPCQIccqSfAUh1Q
	NALsAOrVYHD420oukywF+fmnERlBmpmgzSPDqXssZEKsNNKQIWmtwDQsAbrYRyAIFAdfET
	1nS8O8I10Z3ilJ/gT8dDCU4+MbUZPHA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XL2WHWTD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.54 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794191875;
	b=EsWZAldOoWcAEP5jOzO2laxw+glnGi/woxJht9rSu+JxDRMms7t2EULZPpWlQhyFxX4cDC
	bZgiTlfyaw7++shojhkEn6ayLbE+SigLW3CPpp58Kj6YxjlvoX/rS/NoxYl+f4nTudq+zZ
	lK28ABaO4BfAn/EjWJ8mAaKDsNRYQIA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BSLLWUjqysUniWqaKos+1oTfbUDYuJJnNJuIc0pgFwo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794191871; v=1; x=1794796671;
 b=XL2WHWTDldq8dc4J+S5VCwQikjlgRsEG8sCdf/g6J4yLzejet5DgbiFD8IVyo9je8po4cF2p
 Jw0384EKoWqB18dC453JHT0pAHeiO2yXJCNMIF2qCFTC5OabTZPbEg7Hh2R6YOb90xpbTCYbOwD
 wx+r2xZlOW1wCBc0dsFb6yJU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d646f8317d3d17bd;
	Mon, 09 Nov 2026 02:37:50 +0000
X-Mizu-Trace-ID: d646f8317d3d17bd
X-Migadu-Flow: FLOW_OUT
Message-ID: <16b5464d-d4a2-420e-9de0-2ccddb860e3b@linux.dev>
Date: Mon, 9 Nov 2026 10:37:34 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, linux-mm@kvack.org,
 James.Bottomley@HansenPartnership.com, sumit.semwal@linaro.org,
 christian.koenig@amd.com, phasta@kernel.org, joro@8bytes.org,
 will@kernel.org, linux-scsi@vger.kernel.org,
 dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
 bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com,
 robin.murphy@arm.com, mason@kernel.org, aesteve@redhat.com,
 tjmercier@google.com, harry@kernel.org, vbabka@suse.cz, cuitao@kylinos.cn,
 media-ci@linuxtv.org
Subject: Re: [PATCH 6/7] io_uring: account the ring context and SQPOLL thread
 data to memcg
To: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org,
 dgilbert@interlog.com, mkp@kernel.org, loberman@redhat.com,
 jmeneghi@redhat.com, kraxel@redhat.com, vivek.kasireddy@intel.com,
 mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com,
 stefanha@redhat.com, sgarzare@redhat.com, rostedt@goodmis.org,
 vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca,
 kevin.tian@intel.com, axboe@kernel.dk
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-7-cui.tao@linux.dev>
 <sashiko-outbox-202923@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <sashiko-outbox-202923@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A34EC1A0006
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5ubpjqr8ndtww6szfnyfzrn9f7s8p8wy
X-HE-Tag: 1794191875-513727
X-HE-Meta: U2FsdGVkX1/oEUk4L4gXZfV1zDvfVfkYEmPQlO3sRTGRVzM6mgxvN6qKWQdMaqfqS6zc1L6NW+zZCZ1tJhD1Idi0dL0wrGMgCIn+uSvx78DX2eNRcald/P/j+XZfH/AN+wzwTHm2HJ1zOAz/VHQldhfAh2bEk9DQeQDGuIabRDCOaMKSEa1bLF/1ZAESSfzjGqUexJIbwWX16gPzLl53Fvm1jQOk7mbzD+UkWNbOGMUSQeczFZm3eeYtzmkO6IZiauZqj//TyZp7999q9mOjnJxmi/r2coWiiTCWkkEDkasV2x072xwH8a0jTb9bZXl4QoXhKnnhmnvEh5mCn9wkXZfpYs88Es4aYiBiXpAQ76ckp2wySxJjkDfxPqBx4bCrBVAu8kqlFc50jx4PnW87gAM98fGaRzWeSTydd73udVKNyRYVlpAGXWeJnEwBX6Ijc69aPvcwSYIk0UH1UGduNk8zeBLhbB0DSQBgw4yJvA4uNdFhn0eMRuPsfLeOfVruLMaat9teR+fBBdAwaR1S9nIh+TvOp1EE4HAVdq77whZNSrTo53gLYTaiVPYkyytuSReWY00vkcUyOIV2HB/BTitmVtpgGXyadpIuKh12o+WDMNtpYJpVKImqqL7omzQjE13KX6fYC3z6MWdqmH0oJ5XTGe4LHIxSwnLhtGNMcQsQl504kx4O/iEQ84PB1FEBt6lV9ymOpF2yLPDJAxVKE3k3U4AS2PylKcePHwRo6L/NGqmpbIDuR0W80ioAaVAKCJ3w/HWhSQEVNT8D1kZyXNtO6laS0QIFurRRgWLGDetpBIKkd0jehDrqna5y47SNMEayRc3r4FMya/heSePcBUxvO4cBjJ4buCeornsNaIk3Bytd7CM4Vk0sSS1taxU4rONpdI3X+fezzDKEHqfJf68W5QK5yvpcdh0XQFKwoQKVybK3PG006rzprd1ElatHGX/0/zo7wM3jjGNuec0
 j8grJ+/O
 xgaKqyZhu6O3wMmuIqaytFwlYoLnFiXRFmlRrG+ZX/4l9Gh2aiHJF6SBo9yOccZ1jNz2ZsLBtH3XlNrf/YFDK3lEUDdwpMLUg4HSs/yE+8n/oM/ybJuq9HGjI7IZGJ5F/Y+eHHaJVHxmNXzPJfV/lVcuE0uP3IDofF708Y8/qoZIvoquVlluLSfVqGpd794xKDvmC0XDCY+cntOC6e8MY+4TbRV8NFPiJoVBrt6TgU+PAin81XKeViMDHtNAYqs4VRAgyb2IoZAWwckAHu5MEzBXu7rR8H0vHVLsxM1rsHSF8GLLR0SNidOSjRRYZ8uImXD8N6SCGzsp93Qcv4V1fEa/99PrRUv/wvqP+FMsgV9N2CXvMIAcWibCC4XYeFEAxbE4tUpdqte2Acc6pU0tRM+VyA1fspUQzz0RuWFBul8NEUPkm84kL+/crRsXUHUZAdu1C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

在 2026/11/7 21:27, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] io_uring: commit message omits rsrc and tctx changes and
>   uncharged allocs
Thanks for catching this.

You're right that the changelog should better match the actual changes.
Besides io_ring_ctx and io_sq_data, this patch also switches the
allocations in io_coalesce_buffer(), io_init_wq_offload(), and
io_uring_alloc_task_context() to GFP_KERNEL_ACCOUNT.  I'll mention
those explicitly in v2.

You're also right that "the last per-ring allocations" overstates the
current state.  Patch 7 still leaves some infrastructure allocations,
such as the percpu pieces and the io-wq cpumask, unchanged.  I'll drop
that wording and instead describe what this patch accounts and what
remains.

As for commits 075d5837bafc and 0b34e7b20a48, this series is based on
linux-next (next-20261104), which already includes the
io_uring-7.4-20261029 tag containing those commits.  If the review is
performed against a tree without that tag, those objects will indeed
still appear uncharged.

Thanks,
Tao
> --
> 
> commit 3d47975c4208930279f98824279734ca99b5e9bd
> Author: Tao Cui <cuitao@kylinos.cn>
> 
>> io_uring: account the ring context and SQPOLL thread data to memcg
>>
>> The io_ring_ctx and the SQPOLL io_sqd are the last per-ring allocations
>> made with plain GFP_KERNEL.  The larger surfaces around them are
>> already charged: io_mapped_ubuf and io_rsrc_node since commit
>> 075d5837bafc ("io_uring/rsrc: charge buffer arrays and nodes to memcg"),
>> the tctx node and its XArrays since commit 0b34e7b20a48 ("io_uring:
>> charge tctx nodes and personalities").
>>
>> Charge the context and the SQPOLL thread data the same way.
>>
>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> 
> [Severity: Low]
> Does the commit message match the actual changes and current tree state?
> 
> Alongside io_ring_ctx and io_sq_data, the patch also switches new_array in
> io_coalesce_buffer(), ctx->hash_map in io_init_wq_offload(), and
> io_uring_task in io_uring_alloc_task_context() to GFP_KERNEL_ACCOUNT without
> mentioning them in the subject or changelog.
> 
> The changelog also says these are the last per-ring GFP_KERNEL allocations.
> While commit "io_uring: account the remaining per-object allocations to
> memcg" later in the series converts io_alloc_cache_init() and io_wq_create(),
> percpu_ref_init(&ctx->refs, ...) in io_ring_ctx_alloc(),
> percpu_counter_init(&tctx->inflight, ...) in io_uring_alloc_task_context(),
> and alloc_cpumask_var(&wq->cpu_mask, ...) in io_wq_create() still use plain
> GFP_KERNEL.
> 
> Finally, the cited commits 075d5837bafc ("io_uring/rsrc: charge buffer
> arrays and nodes to memcg") and 0b34e7b20a48 ("io_uring: charge tctx nodes
> and personalities") are not present in the base tree, so io_alloc_imu(),
> io_rsrc_node_alloc(), io_tctx_install_node(), tctx->xa, and
> ctx->personalities remain uncharged.
> 


