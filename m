Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D880606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lt4QPuwU
Received: by kanga.kvack.org (Postfix)
	id 152686B05C4; Tue,  3 Nov 2026 03:28:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102E86B05C5; Tue,  3 Nov 2026 03:28:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0CA96B05C6; Tue,  3 Nov 2026 03:28:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B740E6B05C4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:28:51 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49450C0354
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:28:51 +0000 (UTC)
X-FDA: 85393132062.22.D1691CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6E4A040007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:28:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lt4QPuwU;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JaOz5oG8lXkw1B13R5Aj/6B+VG1aflC2P3pGdWg2ao8=;
	b=sPWUU05s4Y377wS6D8P065com7VrSzm1r4Q7jsY0rwwgVO5Aohcjbh9CqhgHSekOjhaQcT
	+x6SkPmwyACXbXRVMU9+Dnf5YHtD24Q1rZNW5tROVlAi7+c8v4mGx/OxhfIwdqMwUbv+0l
	GRHtz/xTYXBqNo6tMzN6FQkOk53LF54=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694529;
	b=a68oAj4Ne/AlNb/yR0z0m0c2CuJJxTpTnyFcWHfrlCFEJHs7oUa/ev/1GhsFY4UBSLzVcO
	qHc4nkfsHRQilwgObjR60ms6zK1zhuvE32nG0AfXnvSR8qNcrcOwZiP6aIl09vW35M0jTq
	MT/54RrRAJZ8/gxZcnhYJ3YHoSPgqKc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lt4QPuwU;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC89E409EC;
	Tue,  3 Nov 2026 08:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903F81F000C1;
	Tue,  3 Nov 2026 08:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694528;
	bh=JaOz5oG8lXkw1B13R5Aj/6B+VG1aflC2P3pGdWg2ao8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lt4QPuwUBBDihgRfS3d6ycNZp+q7tmtYJcB/AHlkqiEQOgcVoFinBwynsp4bCFJzK
	 31xkL+CCfnK7Vyq7HSeyvcKibwmQYPDt1R/Q9Aty48njdYhF7hVd02W1u8DqwyP032
	 Yy4ok3dHsGvdbXlxIlsKzeqcHQROHSEa8cylgZJ+J4gm4Spki0Q0dwgAwmlgq7IqRA
	 ARSTMNXPLQ0ROEgzmKOSU7Mfnb9zzobP6+vAC/5AO9itGe3iYSauIC09VNJGdl96PT
	 YDl6d/ghh3WdD4IcXdJCrk2QOmKylbuhlUI3xfboG5bvCdANTxl/C/NyfPJd1KBneb
	 sbDwU/dj+SEZQ==
Message-ID: <bb685568-a7a2-4fd7-98bf-7e189dd7ee7f@kernel.org>
Date: Tue, 3 Nov 2026 09:28:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: remove truncated folios from the page cache in
 batches
To: Qiliang Yuan <odys.yuan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261029-bug-mm-shmem-undo-batch-v1-1-59b34212fe78@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261029-bug-mm-shmem-undo-batch-v1-1-59b34212fe78@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 7gkaohuhdt13cu9bumeip8ynuhqu373x
X-Rspamd-Queue-Id: 6E4A040007
X-Rspam-User: 
X-HE-Tag: 1793694529-480731
X-HE-Meta: U2FsdGVkX19B33LR1NpxYmatPPiFb7kdTVAeNplD+iJ4sTlrAdRT6qEyX4zp6KYei8EdBaILCMFaBNj1HNGiGRZIUnfaP5UtNRCR4fcKFLGByyhYsjZ/n90rDcct8Vp+h/2X2GgmVWUz/8tZbbCDV6FqU82C5oS8P/A0+DCXOkSHv+W3K2Ldz8RwG8ahK6pY+jB2bXuIHgbyB4kVQJPtBm987X7uueun1mhKbHxdikSM/6x0gOP5P7NdWLNs2/zdHUlL3cgqo2+pzf9jiEBceeL3cp/1ubnkomuHbHv+mHfxBHRpQRd0T3V/jOQcOUaC7RfEu03Yb32a4KVV/VP6DJkRYjOXEGwlxb5vb6OkNzx+Pa5IYjpeYBaadUdVglZiaNbV4jCq+yCRe9OM9tvtFbW2qkpxKtcJGsP0upWvtWCipsky63ifH9r6af5nAHzp7KtZGuA9LI3go/xNsVpmY+bAhEo8yhkbGAqReNFmwhxdpiYcnSGcLd95dlDQmw+Fz7Kjo+TiQsIA0UaMDMnB7eAFHEtKyOwoMiplYx456cy8JZ/JN2tE4H/oqAUtxRD2D89mJK+20NOjEveQeXJFo3XeUynSp3o78wrzSivDEU/KvnoKcdzH5dChoqBX5tHpFjL7eXJF6+1qT/6ZDr76JkY4Z/7IXZx3BvB5AVx7Iw7vli+fE8g8AM6mIjebVhFrZBlXURyvA8kmAf84uSn11XvH+fedG16KPMLfr7ZcfzOHbCLa1aI9ksnarSKGeRie741Sm++19tk8sokd8zM0rCyklTT35CaL3aLI8J1QdP7sNTKi+aQqqQElvAFpvyiEsYB4s6/QqbkCI70jII6q0rFxFJ5nBnSbOVOotqfKCSpLaf3xVUCCHvIInfyWScDFrE7gi+oQ0a5+1SBA7TRTzPwVb3nlKFdbRR9V1AfBpSIdQ/GVsIcafqrqC2n0qRprL661duId31ZbXRvu0Pe
 77zQJRVR
 tkL4cfe9sWuIA64bTRe9PsCARxN/UhVBhXMg/XgcjWcySwEn4Q3Uwj7/oN/YoxjKP97u4LVZiJC3QC+IejeAvNuQ2R+ojdByQzGnow0dSCb27oYbGm1eth9a5znCUN5udkksTTY/rPTM3IWM4/53YQCj+VR+TmvwZ/sdw8gDsHFINQPQPicxtWtHVkR3ZbAc/juWPzc9IU+wGRisVyZgvObsQic0eQdYUiaLPwcE82IyoLzbCITPWAc16hoyiXxdwxiGk9oYepBBa0qCHXjuX8V/3I9nR/3avUC16eZ+xx5deZIRs0MfxClkYbuFFKjqy0LqrT0FhclPJkjX9LIto7tfeav45rPQZmFz9zkxGqjrMfe0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 04:44, Qiliang Yuan wrote:
> truncate_inode_pages_range() takes the folios it finds out of the page
> cache with delete_from_page_cache_batch(), which takes the inode's
> i_lock and the i_pages lock once for each batch of up to
> FOLIO_BATCH_SIZE folios.
> 
> shmem_undo_range() calls truncate_inode_folio() on each folio instead,
> so filemap_remove_folio() takes and drops both locks once per folio.
> Truncating, punching or freeing a tmpfs file or memfd made of small
> folios, such as a large /dev/shm segment, pays for that on every page.
> 
> Clean each folio up as truncate_inode_folio() does, collect the ones to
> remove and take them out with delete_from_page_cache_batch(), which
> needs truncate_cleanup_folio() outside mm/truncate.c. Swap entries, and
> the folios kept when undoing a failed fallocate(), stay out of the
> batch. Dropping an 8 GiB file of 4K folios, median of five runs,
> averaged over two boots of each kernel, in a 32 vCPU VM:
> 
>                         before    after
>   ftruncate() to 0     1163 ms   913 ms
>   hole punch           1155 ms   914 ms
>   close() of a memfd   1161 ms   914 ms
>   unlink()             1162 ms   916 ms
> 
> Files of PMD-sized folios take 20-25 ms with or without this change.
> 
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---

Doesn't look like something earth shattering :)

I'll wait a couple of days for more review and will then pick this up.

-- 
Cheers,

David

