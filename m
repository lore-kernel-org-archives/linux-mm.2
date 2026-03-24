Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CF20E9A767
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F906B0005; Tue, 24 Mar 2026 06:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F90B6B0088; Tue, 24 Mar 2026 06:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E88A6B0089; Tue, 24 Mar 2026 06:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38FC36B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:55:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09DD7141A38
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:55:54 +0000 (UTC)
X-FDA: 84580651428.13.B33AC8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3D16B20003
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:55:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fMEcgbbG;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774349752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uE3A52l//Eyh8el6mNpQoe5V6xt4Ha2AtzkaikN1c20=;
	b=ugz3EnlP8e311mv9gVS8UuUG7EkQdFYkgPzbTBAysC6Y/Qub1na+A+pctjsxsQaka1hW3n
	0uAOw73GJLWv561+Q8gogL73k8urpi1EjkQBgUWWdgeCn2xNRq319AXdp4LxRAI8aE+w5G
	SF85nEw0WNUqi654+4neRMbM86A6JXE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fMEcgbbG;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774349752; a=rsa-sha256;
	cv=none;
	b=5g2Vyc/LjCYbO05YVgZZrVLgr+6lKcNEGDUM6juhbWwaf78sH9LJoD84R0g43Aez+kvpZR
	yxCW7TKjfSEOrG7RUEO21ov5hYMafL8IkFzYnfthR/rMMYVUquVxuGup4fVWNV+yh2SMhh
	CHKUYQ3IvspTHBedlORPridbdGM21HI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4078344490;
	Tue, 24 Mar 2026 10:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D7FC19424;
	Tue, 24 Mar 2026 10:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774349751;
	bh=PKmRQSmpQcoJaB3C8EeGp80u+1D+x7QmhnNQbCSeB8o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fMEcgbbGgPyzprrfIXmnWzFQVASvL51viSIEUIGq0ULM2FvF4mbfhFjh/HfjosHht
	 cgW+/u9gxB9fYbahyMGnurb7qoARj2GLGX6Ra96W/IHys+NfiTnIL/mImcGXUmlDjh
	 NebVgjLehpGJwqkV4cVX7lDDhnYo58udnTxoI3ZrFyMQMHtl4DswqW26b/zG06s1sO
	 T1KpDuiaLK8G1+W+b214NZfc+rI3YgT9zrIPw8TCw1KOpmEjvUWFSZAmeubTl2MSkT
	 fUye6Vy/rI8+HkSs58CRHJoldtPx4J8kBNNWCqvbMR5Ikppaz5prA9TA7BNpQhgvcl
	 Af6e9o0yrXfiQ==
Message-ID: <a9ac9f4b-9b25-43f3-a2c1-da7157a95ab9@kernel.org>
Date: Tue, 24 Mar 2026 11:55:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/21] mm: avoid deadlock when holding rmap on
 mmap_prepare error
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1774045440.git.ljs@kernel.org>
 <d44248be9da68258b07c2c59d4e73485ee0ca943.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <d44248be9da68258b07c2c59d4e73485ee0ca943.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3D16B20003
X-Stat-Signature: irew4hr8m77zj9rnopepaqhpxj7gupag
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774349752-846082
X-HE-Meta: U2FsdGVkX183meKVC7823VbQAIzGHKwDo4ahoIt4zooM9Ijy1umDwqYSLOLlfG3vY+9jRjv5wcvEIj3nBxQ5lF3nMXQR0b+25WNKtW2I6xa+s4HuEhICJkphFIMMu+cGN1xZbavhL89fhuBo2AZ6i+x4NZ1a6bHaROhOB4u/AEdJG9O5RadFjY3tq7NZdeJFXrY2fDtOHzmprxCHD7kiRSnlkNUksf5CKSJl+DU26M8XcWrw1qfJBa2JZms7YRbgL+7XYwCDm+Xr26hDvFLjpW0T618JFYPr3ZkpsBFydd75WU54xJGdYPNWtPZP1qOU4SSRsnK8a/7tPkkOrcCLiLzxmInzvMKfVIADFqVrxdOBIGZl8uX0WD3CZrD5uVMdt99KrqE1iHDQMXjetsvT+9wdBmouUfZlxWeen68Kz8Iq8SkZ31p5wRgvacKZdNW8/3NwrGm9dxSbgas+Th8Cw9IPBsRctLKErA4xkFzg/kSS+3rB7POZn3l69bWDSHQICdQwQ0fK8rSn40shNQ07PzF4am9jUBX7ibixHkkKdjWowBLixWUpzUSqd9GA8uCbR4w+E5ekV3p+Tr+1fp2cHZlt2SRXEx04byLSG6cNIUtux11hxsjIAATYhsVizDTBi2G8cHkVpXfV61y00AXlXLIh9RG0I1esMpMUtSuK8ttIJxoH9574le4OM/lo8BmFJIlHvX00lW7wo7CcSSyK0x+ngx2NqCKyqpYFqAuJEd/2PKqAgbHHNgmaScuAY5vuJJgSa2PoaK3riGa8C2VdhqwRrYG4hqUu8G/gk9WwlLSl49n0etmFh6eonFDbiXBjgfF1gk0RUZezdlnbg6ai4R6ce1gxjVk0FkLUyryFMRbHxhZTkfi+tABS9dDYBffqoeWN069qB1Yf76SsQI7JnLS2BkDXDoCXY4K5gCc0/OWD95tklYtjYvOlWxIh1qpAbl9NgKXlaAQA2InbITk
 UwxSQQsE
 mgm8FQFqCpCX+drfHViFybPcj9TxZzhDqPNykzhc3u8wp1IGPkbRs+nJ4gk6E46oNwLzHMFqbnobjeiTJj4pbeA1p73Fj+S2ubRhfeSfiFEvCfhgUcF5cyHNE+AocPUL0yFFCVigDiRdfmPztO0B3I0zst/g5zZZef3Oql1CKd8HKhETbX6nPfabZXiQyTMx0ToHMvSYDdKhzyi5JmFlBXnynGiBL+vZvT9CtOj4NGHzTQKIf8fMcM8Nx/TG0plzRV69cPk2VtL4fa1VYbiuVK3hFRE7Leq/lJTtUbok3Syr1avyEkw5S7f6v6ByLWs75vbuHatvMGX8eFjfe3pW2mqHDGAyFLFM4zgGprXmtYwPw5QQ4syuVu2NXptGg26dxMjoHvXq9bztiUaqeTuqYlKAlxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> Commit ac0a3fc9c07d ("mm: add ability to take further action in
> vm_area_desc") added the ability for drivers to instruct mm to take actions
> after the .mmap_prepare callback is complete.
> 
> To make life simpler and safer, this is done before the VMA/mmap write lock
> is dropped but when the VMA is completely established.
> 
> So on error, we simply munmap() the VMA.
> 
> As part of this implementation, unfortunately a horrible hack had to be
> implemented to support some questionable behaviour hugetlb relies upon -
> that is that the file rmap lock is held until the operation is complete.
> 
> The implementation, for convenience, did this in mmap_action_finish() so
> both the VMA and mmap_prepare compatibility layer paths would have this
> correctly handled.
> 
> However, it turns out there is a mistake here - the rmap lock cannot be
> held on munmap, as free_pgtables() -> unlink_file_vma_batch_add() ->
> unlink_file_vma_batch_process() takes the file rmap lock.
> 
> We therefore currently have a deadlock issue that might arise.
> 
> Resolve this by leaving it to callers to handle the unmap.
> 
> The compatibility layer does not support this rmap behaviour, so we simply
> have it unmap on error after calling mmap_action_complete().
> 
> In the VMA implementation, we only perform the unmap after the rmap lock is
> dropped.
> 
> This resolves the issue by ensuring the rmap lock is always dropped when
> the unmap occurs.
> 
> Fixes: ac0a3fc9c07d ("mm: add ability to take further action in vm_area_desc")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


