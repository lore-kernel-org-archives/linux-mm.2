Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B79BBCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 05:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25D7B6B008A; Wed, 24 Jun 2026 01:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235806B008C; Wed, 24 Jun 2026 01:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174176B0092; Wed, 24 Jun 2026 01:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E375E6B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 01:52:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27AE0C1371
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:52:25 +0000 (UTC)
X-FDA: 84913736250.07.2D5EC54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 917DE20006
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:52:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NYbXH6fZ;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782280343;
	b=akTZTQndjA/l6YxUZDo3Rg/jCietgIgVvTQRTJjKzY+kat6Il1hqsM3/Pk8+afwMP45JuL
	VVSFnSdkcTpylFagibm4+c0UwneIAZ6ZY7mOoxrLh3yhFm5tpkZ8r3Yt4kIl7CXlJaX/gc
	7kxBgC18+f2RrVEAhUnVDPHqLbGwDXk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782280343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s77aan8zIzbHun5dnnm2xBxH+FDWkBe885fh9Pyq530=;
	b=GqJ9gUTLQnrcoKZwt6awKlMa7ncltx2CgxHoPwgjyKh/rcm6qoHOCpab6q7BBMzLzuJTt3
	hlB7UmDLLooip7kQWhQVf126D6TmodjbD7qyZocBJ5GsQ9BP4S8lPbXZd0C0fdHlHxZhYk
	HcfTdU0u1CDb80yXrSzGmGsEAWSoDEY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NYbXH6fZ;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8839E402A5;
	Wed, 24 Jun 2026 05:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5171F000E9;
	Wed, 24 Jun 2026 05:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782280342;
	bh=s77aan8zIzbHun5dnnm2xBxH+FDWkBe885fh9Pyq530=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NYbXH6fZ2OqXmSrLU4YQgnYPoqjDbDmOKYUgo3N4fwLQ9atg0r1vt1gxoEMcdtGx5
	 Bry7j79MLeyAQ9UdZJ3hfYHia6tA49t8nf/1b3o7ISCdfbc60nGuD1DRIziLthPxln
	 dhSNA91jnPY2OefMlxZdoot5SruW4wg5XA3vfiB3im218D/auWv7EnqYJhZ48fXjq6
	 IqvfRys/sb3T/Dk4jPU6zfuIoHq4TuKYFe1kxU5LRwetHg6hd/Lwh+lzGFM2i266oL
	 fgh4bju1HuvFq9BAMDnVRBjSbf06gZedg8edRGeNc8w6/dE25vc9fNj3t0QoPITPFn
	 nD/8sA48K4yBg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: willy@infradead.org
Cc: josef@toxicpanda.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] filemap: Remove file pinning during fault handling
Date: Wed, 24 Jun 2026 13:52:19 +0800
Message-Id: <20260624055219.49097-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260622192114.1147198-1-willy@infradead.org>
References: <20260622192114.1147198-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 917DE20006
X-Stat-Signature: hen53num9x71og7figs85jmyh9nj3joj
X-HE-Tag: 1782280343-940520
X-HE-Meta: U2FsdGVkX19ivt0mYlyLrckxzXS9ZHJKEnUXhchuBrsAQ6Qo+BX7HB3NTnYlC01XFLgw2oBP7dkTEBjC+JI2umBfZlQJlPEhWa5dF3Jkl5dx1AX7GJM2CcEAklzCedJUZLILC8yUYUEZg6a1jI09CXjKujjyXPbZvv+2uQAkn5CmN6TJdyKwtoNtZPg1TpjhQ7zO4lzpyCIiKGu/DOUuIiZVXKEVmF5lhNsxhkWTz/XlPy6s+rimqxCUilqw4QxX/JUH3/J5A2h+aLrWbPd6uKOREqSfsb5fH6tv3NEHW+axRW4A9yBPn6XrZYRdWb2nHjsh3sxcUr2Br5tUuCQCYsXLHh2XAPEEdf74LiE3DzPiuEhtZOA5JdGPh1L6wK5RYI8eMHSeAE6PKqoQOpK1IFZESDI6xTsorxGuMuyLYbLpjqBUBmnup3Qc/pRsozdOeBaidE0ezQC2DyKqO42vSWBrqyEqB6CcrSYiv2uz5WL9Li+mIYav860aDfE0VQuDZEej5YnTPFCLQ7xeGCWxOzPc3zwdIzLo6xwh5ckJYKhR6mOWtfMsZIuAk2TqjhUx9vrEVpFlxrHX85qj9IM/3SGAOE/dfShCjf97vrOZBCnudT7HPu/JxheI/XEkw9gDxXUg/4B2qSr99N4OWU1IqNqUKgyWtzxgIpJxZ8umpXkJyF8JvZ9FJycFHPIbfnxjv4nOFCeOonRDc8euQT1IdfQevqs/c+76Zd2plZuEpHMyf2Mjox733vb7scRk1SMJHlEIeQ9EmKb1VPTF5QZLdnOKpttsLE5oxVIeF68Z5IhDKPXWr0KmMNkzF+gKezxzNYI4ItF8m8BOyuXeCVx1fAmKUbTpE394xkBaYbSuzLjuZvYNzz9GyXsQzT1Qdgf5Rv6zQqMTASYKImipUK6tvzjjlo/bu4YTZMgPhFw8gIZYe2+IQ2vipTliapd/sOunC0o+9TLr6+0Sx2bXjAM
 FoYp6BIH
 8KqtyZhOEuyAV9uBD3TxJQVkig16zsk1DwsO4kGPGIr1hr9IZ8mrfHqKYUtgvDH9gLIohWLoKj2GkPA8bOFZh2jQccIUP+2pprCaTuqoUedgAw153MZWLjP/eCBioJioopJuqxYOwmHXWClGt6a1imVS8TyL37cY8wgzSaQOyIWNE6jErYE5PS2nTGn9Rg7kSQXnMqJLBIdrGP1BBkbryN8qMXwciokVmmM3TLqS0+k/aCH91ogkyNreeAswB5PMHPjqccoQscU1H+oUve2w61fMR3qa1JnuGmpHkoaxDGxEJ2aGXyMsbG0P0Ze/kmHfOQNakF6WKVO24479w8O1W6oih0W3R4y4oNAWetffNNGl4O4jswwFh6AvGog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Now that faults are protected by a per-VMA lock instead of a process-wide
> mmap lock, it is far less important to avoid holding the fault lock while

We could have fallen back to the mmap_lock from the very beginning in
do_page_fault(). And for GUP fault-in, we have always used the
mmap_lock so far.

> performing file reads.  The per-VMA lock does not prevent operations
> on other VMAs, nor does it prevent iterating through /proc (see commits
> 6b4c9f446981 and a75d4c333772 for the original motivations behind dropping
> the fault lock).
> 
> We will now submit I/O and wait for I/O to complete while holding the
> fault lock.  This removes the need to return VM_FAULT_RETRY which means
> we won't fall back to the mmap_lock from the VMA lock just because we
> had to wait for I/O.
> 
> This should result in improved lock contention, although it is possible
> that some workloads will find themselves contending on the VMA locks
> due to them being held for longer.

Hongru reported that 82 of the top 200 Android applications in the
China market call fork() in heavily multi-threaded processes[1]. It
would be good to take existing applications into account, please.

[1] https://lore.kernel.org/linux-mm/20260623075805.466317-1-zhanghongru@xiaomi.com/

> 
> Cc: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
[...]
> -static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
> -				     struct file **fpin)
> -{
> -	if (folio_trylock(folio))
> -		return 1;
> -
> -	/*
> -	 * NOTE! This will make us return with VM_FAULT_RETRY, but with
> -	 * the fault lock still held. That's how FAULT_FLAG_RETRY_NOWAIT
> -	 * is supposed to work. We have way too many special cases..
> -	 */
> -	if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
> -		return 0;
> -

Does this break FOLL_NOWAIT users? They are KVM on x86 and s390.

Best Regards
Barry

