Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A45606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LPKRQb4y
Received: by kanga.kvack.org (Postfix)
	id C3B7D6B05B2; Tue, 17 Nov 2026 04:09:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEC2D6B05B4; Tue, 17 Nov 2026 04:09:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B3C6B05B5; Tue, 17 Nov 2026 04:09:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F5A56B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:09:31 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BEDF802C3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:09:31 +0000 (UTC)
X-FDA: 85444037742.29.39AE061
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 71DE81C0006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:09:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LPKRQb4y;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794906569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4j68du+QqrdYo0mkRinPnN6ZWQftz36UXeshS3GPhUU=;
	b=oVwDjurQeffdJ4olPhc6wcv9/c0URxTW/oDs2qHXRrY1gYgk8Uh9bfmXyXO4gNEX1ZGIDg
	aalw0srz9mA8GzsLhy29Eh3qRSNy9blq4FVENZcynia+Y9M44JzJzX8TmUnUCV9aZ83xWX
	p2VKuoKrdTXMNDbSERsNs25fKPo5V10=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794906569;
	b=ENh6EZaOILW1neuXxktD0q/Kmw8ucEqC7QrFb9FDavnJPHlRPWQkjXDHwCZ2E3EpY4vKxb
	Ish7bKO364BCJwbCegsuVxADH55HcZdNtIBLAG2m74ro1lIN2IP45nj9KCx0rBFk6phtyi
	+rY3bj5s6Hme7y5qQEpy/ik1lcTknjA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LPKRQb4y;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A57AD403CE;
	Tue, 17 Nov 2026 09:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363FA1F000C4;
	Tue, 17 Nov 2026 09:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794906568;
	bh=4j68du+QqrdYo0mkRinPnN6ZWQftz36UXeshS3GPhUU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LPKRQb4y3SHB6n3wVr1JYri8GotsV4oPdRPiR7zJmJl+MCdWBR7m0MtshOnWULYbD
	 mILxrFFNR+8elVObe9U4VmA/qcWXHKIZQj2Q/QYPRMwjdMO3wJzwNRRrr3D19oIAQw
	 9dKedsp+767EKn3I4Ss3VBqATSnODpHwizcox1dTBgL35Y/6wEACwcxVRfWhiYJpOq
	 Q6Q+9XEHctPxSdKec3MweC6MTNhlLJvXLYl7oegwCRlzcJbFiu3NGRhJnIKCYE4WIs
	 28Ygfi+PXtHDm5fsH3HPB87RPs3IwoBU7F6K3J166GdKhJJnJ+T/Gj0X8flMtjfv62
	 Bip8OHjqOpiTw==
From: David Hildenbrand <david@kernel.org>
To: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev, 
 qi.zheng@linux.dev, baohua@kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <71980310d9bf1bf9733ea0e4b772635e1b2bc5c5.1794886401.git.baolin.wang@linux.alibaba.com>
References: <71980310d9bf1bf9733ea0e4b772635e1b2bc5c5.1794886401.git.baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v2] mm: synchronize with PTE table reclaim for all
 folio sizes
Message-Id: <179490656487.3795.10506084518247823925.b4-ty@b4>
Date: Tue, 17 Nov 2026 10:09:24 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 71DE81C0006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 49ca5i4ga33bro7f9iadajkm5fkb7adr
X-HE-Tag: 1794906569-279640
X-HE-Meta: U2FsdGVkX18MLVCT6dBi5lKE3dwG6Ucoa9FW/bWLzOajeVn8Q1NNh2so58VfTwfWuvJMSbCRgAext3e7JfIfBbeN10vB4/FIOUCZApUxsGhXZAd1tKZnRkQCiycZljj3rKDDfz2bqrB+tk0cbUDx53QYFUPbaB5rCg2rLo8dMcfJsKUFzmWl2v89SCTevve3j1xrw/HrQ9Cl/KmDKWJNrCUuF1V31uRDj7Kx9gKdO1mdXcmNKiNgu9wRucSygeTcN541Is8AH7m5xxqs1k8aPvPnBrEOXYa9txHlpUrwTqpYoYWsj/OAOoTOZ6+goYTL+kdlmCddkePENKd/wxfui+rDgClRzN22OgaAC1upR6s4fFIJGuQmV5seI3lN0Ob6GMjcBnhhdXPVHEPVvZ4hKO+etEaSYsIyoWie3aJ+zkmCgv23MUlx+IYvdLB5411IKD8KZJdIGZ0fgZjQh5/gvFhRco0jFqtRGKSFmdxBdFisrvpF5GZS912Q3DzKDcsRXLMQhPC+eltMjVjimUWF/ntThs88RTsQY73g1+OEISQfoOZDcVW5AHrgFEHrYL1JbwvInN9m1H1TCf08i8MiEzXakYZSi9OOEi74RQSlYiYjWG8l3ehY+4f36ImQkV2cBYQFyDZpIJebzsAI4XyfcghWH7QrT9leTWHB/rhgTbr+NX/VTGmlKmeIdBHQBCkEu9ARrOLOchLMY7kZKvni8pIiWAIJpTNYPnaqB5g/8xzaSIeT9z9kdAtZcSuLxSRFbluZ75dFuyNhkhYoMsJNeBRM6rEs7DBXyMEh7hhTV9pefH95BitHUZDvpxEdnSJbk+H2QxayOlaYXTCSO0zLfoAb3zfQ8QBoHf46Qvn9ZOMkSrkpSEBRRppbw5Psr7VWu96v0eu3TDbtmFT9oBptkqyOHmuzj2wqsBBU8swT22HLhiv6I9Eq36LllrBRArj9RfCxJLOUrCz9kQloGfE
 x57GY7qn
 o2mJubmv9T/I1V8EMd4zkJJf6YydUkJhOZ9NBc3zdpAoPnoY6cWJsMYWcEe0aqPwGoFf02MX5yyvaVkr3RTrvaNRIQByrlI58t9OwjOLmSyMiUWwVCbABJ93Ck77yLRS7u14iS71dSJt2+Yr4+aVw2opJUuaHF6aYV8fhDIt05NooBKkbovYp/dX73Dmeq5fmQ11Jf7uQCv/9jg85pG2YZEd0Ksz4FHbvTkIlGM9DK9QhotCk7hpfzY5NFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 11:40:22 +0800, Baolin Wang wrote:
> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can also race
> with concurrent page table reclamation via zap_empty_pte_table().
> 
> page_vma_mapped_walk() is used by many functions including try_to_unmap(),
> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), remove_migration_ptes(),
> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for try_to_unmap()
> and try_to_migrate(), the other callers do not perform post-walk accounting
> checks, so the race has no observable impact on them.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm: synchronize with PTE table reclaim for all folio sizes
      https://git.kernel.org/mm/core/c/bf4c270e

-- 
Cheers,

David


