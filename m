Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F24ACA0FF6
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 20:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B38B8E0009; Thu, 28 Aug 2025 16:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963148E0003; Thu, 28 Aug 2025 16:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852668E0009; Thu, 28 Aug 2025 16:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F37C8E0003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:54:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BCB3140396
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:54:44 +0000 (UTC)
X-FDA: 83827370088.26.AFC0EAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9F33C140005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:54:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sCjN9TPm;
	spf=pass (imf23.hostedemail.com: domain of kbusch@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756414482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywvGPIy8PHl9G1ugzrJfF+cpNToiG/QPV9W1oXZBkHA=;
	b=WZyVSCVzj1ys5mP+gxpsNIUgRPNHGYjtIjp04y1k/a8fxfFbuhG23NfoE6dBUOXMaa8pY3
	ooiajQIUFlNNnguTDYJMxyFYzoiffG2T6PT2FRJ3/5iczrrKvMhcoPN+tT2RPa7Rio2sv9
	deea8bHEYwU9JOsarQ6PETv67NAyYtY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sCjN9TPm;
	spf=pass (imf23.hostedemail.com: domain of kbusch@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756414482; a=rsa-sha256;
	cv=none;
	b=wNifCHamcfQQ3aOWy4jhniU/HIMdAEix9mQlMu4QZlhqq2TZnq7tWQxNxoaCRhU2u+BgTk
	y8rSjBiMoom2FAHYnCGWYOr/hR6YJKyoblbHo+v8RZYDO27unSohU2Vq///zaMZQsCJv5O
	qEEpXCfXL5Kunq+oBQGNOpqMqHd5nBU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CBC0C60139;
	Thu, 28 Aug 2025 20:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF632C4CEEB;
	Thu, 28 Aug 2025 20:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756414481;
	bh=G+6sPUUIFuKNkRdpDGh7oyzJRLExx6mM3Rr0TsrNav4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sCjN9TPmsmkv2CErZmw7eY4jhfo/PPQcCij3sdHoAaturic23UjSbV5/eD841QBrO
	 q5lqa5UXldETsQDMVxoOfW90mr401cd2aNU4qwzO6IO/5MHaurrX5r01OojjZShQEf
	 15Kqtld44h3aDOleBeJLOpcwjkQTTYAEhyrx8SC3goTrfnxyjVjHpigzIsE/EQK5r7
	 FqO3qkArHFFA2cKutZwYB5+zz+dbLtckQEfa3MaBKs+Sg/PNA0jXRALMJBXOlqNLWJ
	 BYklmKx3JSZ1NevsWbUBFS2Jp771ITiW6KubcU3EOHWT7p/JyrZiu2Mj04cW80QHY7
	 3fGPgcRndIPdQ==
Date: Thu, 28 Aug 2025 14:54:35 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 15/16] block-dma: properly take MMIO path
Message-ID: <aLDCC4rXcIKF8sRg@kbusch-mbp>
References: <cover.1755624249.git.leon@kernel.org>
 <642dbeb7aa94257eaea71ec63c06e3f939270023.1755624249.git.leon@kernel.org>
 <aLBzeMNT3WOrjprC@kbusch-mbp>
 <20250828165427.GB10073@unreal>
 <aLCOqIaoaKUEOdeh@kbusch-mbp>
 <20250828184115.GE7333@nvidia.com>
 <aLCpqI-VQ7KeB6DL@kbusch-mbp>
 <20250828191820.GH7333@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828191820.GH7333@nvidia.com>
X-Stat-Signature: t9xtrj8nu19zin6ghqyy1shu8q3pr7f6
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F33C140005
X-Rspamd-Server: rspam01
X-HE-Tag: 1756414482-437606
X-HE-Meta: U2FsdGVkX1+eNfZUdfKdEUesCCRZJC7En6zUi5HRvAwXxgbAcr6Zz0rSQsHqbwfXKDBnoeVzTsxSrwGaF4wWqurkRZiJWvZf6vHFhS50yF9rSY2vNjakAmD32vDJ/ts8ogy5NUs+owKpb0+8521otGrzNIpFW7BsZh6chg9AprpanK0aisvNBBeYKk8gkuMpdVRx5+FdzrCMIA+fJc3/OpGx0+UV/N1pyBLhpmIXUzd5XS3XEiyoUHh3Ju6Hl/JY8XbLku2Z0bA6WwZqvTlgf8U8PLmqG7se07+3d99aXLCEhha/lZhwYYz5MMHirRdbDjiWn+tN9JWvvPEAnEK2BRUbPAHRMQ/9vsQTx4G0Azx+ZFwqfgZ2HRfMFX9gMU2sWHjJibPY/UFwtppLsXS+ug1qLoHrOGhXFh57ioN/6AeL4O6CohP/LYFt5Jr0rd/UKdyz4s3P7Nf9C6ctUKtSu3IEzHCqRKPTl1bzM8xWx74UBhnrhFjcXWHpLbowI7nvruFlVNLwrEMJnFQFPdMczFIam5/sziZUW8A3UKWC4x8Pqr7OkuUSom00DEVk+UjkwWzBo61oz+CYLunnYWfEUoI8C/QGA4gEt60jmobZgP90IxvAzzvBUHhtRUCwaGhear+d+1ptIWD/t6SSILCgq+XpT6EJH8n+rKKX9PD+A6KlukTcoWshnipiSUVzgehx6oo5FC/kx3u8jsVDw6gEgrBwL0wfGLOPE7dxC/Ydpy5nJuzlcZuGz+jRNpLH0+TNmKqPdG4kPcws0bf/M8fEJh6bE3hYIbS42YwnXg7rALKF/FnVxRm4ecdzZyUKiO4JefBmqom/EZUZgx/fjb3lDetn9kBzXsq5egKzEquFjpJGJTAcnVMQn8SaUGC48XLrn8RjddJ16J0MZLo9stdvjKcxV3wJHRTMd4GUYFu7XFCryHaWCINAa84rU8WEEU55F6s7/ICKxDN/JakAEmi
 ALjezd65
 HzXnykLfzcJZsKfACcRZ3bPzus+Yzs+ZSyCc4Si4E0GPz+rfUrdI3gTopzwiYm68HmLqZYowqibdkcjpf8LAgjp7QX537nArBnJqrK41qJOeAahDjLylE5YwvmZicnVJvSDdflGPT24OONiZ+3rI5f+2+ro1tx4qRn5X5eh8YgYcrN8k9RQl3YFN/kY/HAFVDuQNH2+gYo10cjMPe5jSvVjcpPa4403mxCFkijFFOktBhAWQcif0Afy9skQkDWnEV10iWikGghNmzosspwofG8ToW1rD910xoQrdZfYcN+UtLrpGLZFxu8R8RRee7BbCGawQQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 04:18:20PM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 28, 2025 at 01:10:32PM -0600, Keith Busch wrote:
> > 
> > Data and metadata are mapped as separate operations. They're just
> > different parts of one blk-mq request.
> 
> In that case the new bit leon proposes should only be used for the
> unmap of the data pages and the metadata unmap should always be
> unmapped as CPU?

The common path uses host allocated memory to attach integrity metadata,
but that isn't the only path. A user can attach their own metadata with
nvme passthrough or the recent io_uring application metadata, and that
could have been allocated from anywhere.

In truth though, I hadn't tried p2p metadata before today, and it looks
like bio_integrity_map_user() is missing the P2P extraction flags to
make that work. Just added this patch below, now I can set p2p or host
memory independently for data and integrity payloads:

---
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 6b077ca937f6b..cf45603e378d5 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -265,6 +265,7 @@ int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 	unsigned int align = blk_lim_dma_alignment_and_pad(&q->limits);
 	struct page *stack_pages[UIO_FASTIOV], **pages = stack_pages;
 	struct bio_vec stack_vec[UIO_FASTIOV], *bvec = stack_vec;
+	iov_iter_extraction_t extraction_flags = 0;
 	size_t offset, bytes = iter->count;
 	unsigned int nr_bvecs;
 	int ret, nr_vecs;
@@ -286,7 +287,12 @@ int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 	}
 
 	copy = !iov_iter_is_aligned(iter, align, align);
-	ret = iov_iter_extract_pages(iter, &pages, bytes, nr_vecs, 0, &offset);
+
+	if (blk_queue_pci_p2pdma(q))
+		extraction_flags |= ITER_ALLOW_P2PDMA;
+
+	ret = iov_iter_extract_pages(iter, &pages, bytes, nr_vecs,
+					extraction_flags, &offset);
 	if (unlikely(ret < 0))
 		goto free_bvec;
 
--

