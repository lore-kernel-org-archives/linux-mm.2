Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4877EF54ACE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85B026B0089; Tue, 24 Mar 2026 11:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80C106B008C; Tue, 24 Mar 2026 11:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7218C6B0092; Tue, 24 Mar 2026 11:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 653FC6B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:32:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10EF31395E2
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:32:31 +0000 (UTC)
X-FDA: 84581348502.28.D3E7884
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2F13D140002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:32:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A8CdR1TD;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A8CdR1TD;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774366349; a=rsa-sha256;
	cv=none;
	b=XSmbXbsd3c3l+Oz+akpwHmhNoVExKCRrUZ/25iVEWNkfjcG2XK2+RoyP2WovYg282G1iDr
	a9ho+83Eod4ziHerjldn3wsaeBP5o3Dgv1iW1ktzu/3HM8AFb4K2OnWBn9g1q59hX4yk0Y
	fyVkaNHEpa9FEeC66SlCwn1BFvLktgM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774366349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+vuny8JAx0aKUj6V31VSjrqdsJT9Ay7FWF/QSJhi+4=;
	b=aBhGFz3DxNgOzbwM093TQagg+ee6Ua1AbKUhqBOUReoRms/ZrFs8deOY6qRemTRrXarOmw
	S9yzaW+oZuZTj9FKkNaY4Fc7sdfudw6c74zqJCYQdtPkegtZK6UsVVk22apPMzOZDUB2gO
	Qp58z3qFnBeXYDtOWtPZdCdP1+zn9BM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FBE240D73;
	Tue, 24 Mar 2026 15:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E0FC19424;
	Tue, 24 Mar 2026 15:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774366348;
	bh=Pj+OtiBpuBF7IoC42Kw/vtLSB42CPkuKUZUpsmZAtF8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A8CdR1TDIvUqf/UIBWs17Nn4y+ea/fY6CzTak5aX12J4D+twwLfy+SwnX5lrhff4D
	 CUzBvNr9gv4/0D50Bsuh5GstOCFIQ7l1/YDJTViyrQcTcXkjPsV2NcEd1kTpkceCXt
	 qvmlEfeNjP0yn00Q1AmSFrv9QGGtJ2oKpyqS2VkQuMlb7xlEpzGPo2Z8H/X24jQkzS
	 /dRZDV1lzwWddAwn65weghGa9oo7qiThUc/kW/BhhH1pEumyxJoYG7WP3BMi6+9/xr
	 Y4kgvnO6kl4rFLyL5hI2Nvbd4V/5vHv9ZNMEpKAQRKpcauDbgPeLzXT7iYy5Aj7+iX
	 gcx1tICooGAPQ==
Message-ID: <ee66e204-4439-482f-a8cc-93de1d332a8d@kernel.org>
Date: Tue, 24 Mar 2026 16:32:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/21] mm: add vm_ops->mapped hook
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
 <4c5e98297eb0aae9565c564e1c296a112702f144.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <4c5e98297eb0aae9565c564e1c296a112702f144.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2F13D140002
X-Stat-Signature: k8ws3ioqt7fsryof5u5wx53bs83t3mut
X-Rspam-User: 
X-HE-Tag: 1774366348-366552
X-HE-Meta: U2FsdGVkX18eMFekDYO4GEpNdk8njbXcVnDV0pC3k0Iym0VF608DJgaUm4rKHqJEnsG5CcBj0Rr1bIlvcDl59GCLBE5wJ+YsxGKpP7CcWfbYUDKRtLY06ERHB1BOqmj5rgkxGCh3da5wR31da2lCkEQan8MW6Xbnk7OGndx/5FC55EbKbsEEn/N29wKMj/DdwliUtAITxxRu/yyPBjhHLEyi2kF6FLAjZemKPB4CKkjsPkbCuhsZ2llQrUoi09xr7LWd7aB0O8nZH0v+Q8wj1JK19LQjZ6EUVpa2U2MsOBrNgU8HoPQGVLmDTicbl2wiV1/331qWJi1lzV12BORP3lfz5yUGArfSDMSBTSdqJbTDMyVYHn0dSKnKGz2pNPrXC9I6RjP52IryIorBciuSsethaPwP0f3Rsu2XiR5fp/zfUkQHsfAbvkfMbCTdma0rT+s55AhtNO3gVt+NnVhNcc1EBctjlTdslgyFrtT7P4T8txVCp1EkyTv5hioKDT9sS7MEB3t9qrrLKx32wYp+FC0SjC8YdewauwxvOBXKwxo59sAWoCHdYcxC62ZHWT4DfEz9SxvZ3kfatGvaMriOcSJSmEX9V5JbFDoVf6HBNxcO4rQfvi2e5LNKOPoBnj6Ezgfwt3DVWzemxCXeCMd0KakBv2EKC8IqbrxJk6GXUseimbe5IPuvnC5ZK/7o951oKbrW3hlxql5OapyeezL66pef0+ZCRqutE1vJaMvFwjUaHGs3l9z/TnFb4JR6gXDq/NrL432YkZbtctrN3Xgi6ptAs3mVx6J5p3+Q2h97EC3JKOot23zbFWPMQX4QNhBWYUP59FbKQVbL3HRHTDwMU+qOQX4IgtqXut0cl03vbxWRJA4s9ijGWh6jyd7du0CVCo0xv+Cprqq/sgla9pcXQ54v3U70aMEOpIJyL2zUh8njaHWZmWfjHpk0qbtuGVgJhk72mz20FXqdWgMWTn9
 ZHwixUtC
 r+QXzonhBggkzA5E7J1cWjnLSCea72+MmJSBPHFvVtaUlKSClJTbbypd/UaTFc57NdtMjlRxX1nfn3o2IJtVHUkQMHSM6e1UQoGkzAnGEMWvlzz/sBonlgPt4dlqrMc2B5ivaf9S4oCZhrZ6mj2OoexG71i3j/E83r1rndckwJ8oNi1Su1xaFxc7V1GMukHJctNzf8UIHKRrUCYXUPZnDnaXlIcncfGZlT0UNakUVrrRWkT9zXZGTHsUnQRC30GBLgaRXQE8EgUVObJC0+fVbkgHAKuLevGDPIiUxE0ylXnDNeP+2ia0imdKkaNsO210fTQ9sOtK1iNi3pSRzx2/b6I23OXyklrIevxCeiNAmoHrnP5wq7CDYaUsSA19DzlynX1lilNPlJmrTfu1HDxNRDsAvVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> Previously, when a driver needed to do something like establish a
> reference count, it could do so in the mmap hook in the knowledge that the
> mapping would succeed.
> 
> With the introduction of f_op->mmap_prepare this is no longer the case, as
> it is invoked prior to actually establishing the mapping.
> 
> mmap_prepare is not appropriate for this kind of thing as it is called
> before any merge might take place, and after which an error might occur
> meaning resources could be leaked.
> 
> To take this into account, introduce a new vm_ops->mapped callback which
> is invoked when the VMA is first mapped (though notably - not when it is
> merged - which is correct and mirrors existing mmap/open/close behaviour).
> 
> We do better that vm_ops->open() here, as this callback can return an
> error, at which point the VMA will be unmapped.
> 
> Note that vm_ops->mapped() is invoked after any mmap action is complete
> (such as I/O remapping).
> 
> We intentionally do not expose the VMA at this point, exposing only the
> fields that could be used, and an output parameter in case the operation
> needs to update the vma->vm_private_data field.
> 
> In order to deal with stacked filesystems which invoke inner filesystem's
> mmap() invocations, add __compat_vma_mapped() and invoke it on vfs_mmap()
> (via compat_vma_mmap()) to ensure that the mapped callback is handled when
> an mmap() caller invokes a nested filesystem's mmap_prepare() callback.
> 
> Update the mmap_prepare documentation to describe the mapped hook and make
> it clear what its intended use is.
> 
> The vm_ops->mapped() call is handled by the mmap complete logic to ensure
> the same code paths are handled by both the compatibility and VMA layers.
> 
> Additionally, update VMA userland test headers to reflect the change.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



