Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 709D2C5B567
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 17:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9416B008C; Mon, 10 Aug 2026 13:56:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64B486B0092; Mon, 10 Aug 2026 13:56:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EC176B0093; Mon, 10 Aug 2026 13:56:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 256AE6B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:56:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BDC2BA1D56
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:56:48 +0000 (UTC)
X-FDA: 85086115296.25.C448287
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 395BA10000E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:56:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GfNCPqjI;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786384607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4yvXfUeulRUEmTF42XYsxj9IZ6IxSMv/Y/T9OemFD68=;
	b=r/iVMZQrjkWk5sPoRCqFL0REcQQmZiA6F8fn959pgGSD44Ou/3C2oBRqFCij+ZTw3MlIjX
	mJygRe55gC8h3SE0Ev2JfIkkvjYmfAY6MM/36J54hSk1/0vgswHGoVhdwhnVFUavh86O+E
	1A8qzhO8WqtZjsyRXoev+o5fJPUhh0Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GfNCPqjI;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786384607;
	b=AJrkxgsooTf958H6y5X4/vPhDutBe87O7KqDiDx1VMD95YoE+iMAH46Z4SrbaBED0wbFrV
	UmBHfqet8QwnFxn9zFm0nTOXBpzYWHsX88i2xZ6gKYmmy69BfSbJxP6Y0GkVuKcHwXjWnf
	0ISybXZylNKC0M/kvXq8quUn3y69YIs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A5428600C8;
	Mon, 10 Aug 2026 17:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35041F000E9;
	Mon, 10 Aug 2026 17:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786384606;
	bh=4yvXfUeulRUEmTF42XYsxj9IZ6IxSMv/Y/T9OemFD68=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=GfNCPqjIISgcgG/+twUpZHtMXxXS7jfzB7cxJs3nCp4ahhZswUZSnbJYaWecCiRWf
	 ff93HKBcIFo+iTMiUzBEUUAYwdTtuqlFYyKE8t1ifUbythVHJYTrVDD1G0/Hoo35U9
	 yXC3QwRUW7L4YIiIPKdqm+/GuUdjLwR/dSus1oEGbZj6O8pnezJpDdLwwoh7J36Bkf
	 1tajT0z240gUe9ZS5EjmxjOOLFyroqlsI4kJLpfnjAQX0K9JRKrTHmXwTXypL7ZoZ7
	 nmAy9+KMxo6xBaG+0zqEGOdzcfaS7AzyW2Sl1LEqEpV5cvEN8CaF1wCUVIVqL6qzQx
	 qB6YbUzxFHSLg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  kexec@lists.infradead.org (open list:LIVE
 UPDATE),  linux-kernel@vger.kernel.org (open list:LIVE UPDATE),
  linux-mm@kvack.org (open list:MEMORY MANAGEMENT),  Giorgi Tchankvetadze
 <giorgi@tchankvetadze.com>
Subject: Re: [PATCH] mm/memfd_luo: use real folio index in retrieve error logs
In-Reply-To: <20260806100543.138902-3-giorgitchankvetadze1997@gmail.com>
	(Giorgi Tchankvetadze's message of "Thu, 6 Aug 2026 14:05:39 +0400")
References: <20260806100543.138902-3-giorgitchankvetadze1997@gmail.com>
Date: Mon, 10 Aug 2026 19:56:43 +0200
Message-ID: <2vxz5x1h6eqs.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 395BA10000E
X-Stat-Signature: fmaqwhmm48618fc4f7r4doq1ddubpn48
X-HE-Tag: 1786384607-276296
X-HE-Meta: U2FsdGVkX1852kXh1yjjv6Ok2QVgPyBJpK+YDpUZQiOVzfJ++A8s9g137b6nYWEnuydgO/BwfUtP7Awf5Vwamd98LKTqpBy0LbLSHehTTLbH9RRlTNaXc+Ylb1ji7U3af7YEkRDhMK9fkd9Omkpeo0ObeyKpbXyxktEdpf4LbfRSehYHeXEs/Mqy/pdjvBbt6gpHzROmgWPrCsNJ8yZJpha1FnI9SAtE/KZOxaiEuHjqi/TSyDFTFOSGPRE4ZdDhPKhcmXV5wfROMKVml/cSqBfVKWvv7CFO8RhvEl7e1rrJuwQ+xFppPemnKjC/c6YOi4YrJRaG3gqssTTsthAQyf+DMK19rLg7356nHQH7usJyneLBXLrD43zFtof2EqhuClpg9PJ6OPNmepr2FV8tIV/mdiy829a/HYAYCByzaUmI4ibqc6jN/Og7yN0F2el1zeV36sF7RrHzz84Ej3GmYzv5BOJC64JXp5mxmVzjLXAcq4cSbcnzq11W8dqvizcMK3Jz/n/KDj0689CGpCPM55nDT9zNjyA+Npgrl9jAw9oWuQ+ujQZF34o5mkoeiaPFVFt54ym7XWVacQiNqP18FMWD4uEkzALME3AdjBYqb1eRrD8V1+WZKqi54MputHcQLYe2MSlcUO/qksFqHN3K1CjnV9xqi/hb8B+EWolILDE4RLMv8JXHmut5PfMOF7/lYnMoDt0TBphyShapT3RStPcizLPFt+0CLYJ1afh9QvWWzNUVh44bRQ7qtdN1Sk4wX/swMqFEBhY1NyCLNAi1B0SUWtmaVTMqE3bDeuFCY8jeCfTxXBetGMo192TThkBOF2IcrHYEOAUEggYU6udWJGZdasgqA/QvJ0Hf4QSHJ13E3wUVMgceXPgfHMcn+XwjCe9Tmbo01UClP5McNLYU6Y5pGI5YfgDZdWTnxh5ffIIl+1k+3kwlMouuV5WhmfYQSwTQ3tbXDj3K9r/x3cl
 hGZT9Ui6
 OrMv4vsD1sYc8swo/2wMltja1e9HekQiXkwQNsraHS1jZD9Ott/WlTVRYB1yDluhOy6YYWNe0fu5GL9oDcNxOijqN17NDqCMg/0fGa7LSf0yxkum0hN4g3J3yiwnhSiptZzlnIJp5BMBHyfNZpRAMzpJw4Ku+uxWRntmaJG05dtsJCFfqJWeRQWYJzLmLUYSe6AB+6oYSB+XskrA7vZWE7JxbEoe5PGQ5saF43lA//aG0N54UXml72xGgpf+tsKMvx+2Nt2Oe9wsiXEAASCMl1JImRuy1MpwbAs7qaUOTO3ELLbhfQ8Q2Uci+j4uUfd4nmMpp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06 2026, Giorgi Tchankvetadze wrote:

> From: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>
>
> memfd_luo_retrieve_folios() logs "folio index %ld" on its error paths
> but passes the loop counter 'i' instead of the folio's actual index
> held in the local 'index' variable (pfolio->index).
>
> Pass 'index' to the three pr_err() calls so the logged index matches
> the folio that actually failed. Since the saved index is a u64, use %llu with an
> unsigned long long cast when printing it.
>
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Signed-off-by: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>
> ---
>  mm/memfd_luo.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 59de210bee5f..652dd21e6ef0 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -451,16 +451,16 @@ static int memfd_luo_retrieve_folios(struct file *file,
>  
>  		err = mem_cgroup_charge(folio, NULL, mapping_gfp_mask(mapping));
>  		if (err) {
> -			pr_err("shmem: failed to charge folio index %ld: %d\n",
> -			       i, err);
> +			pr_err("shmem: failed to charge folio index %llu: %d\n",
> +			       (unsigned long long)index, err);

Why the cast here? u64 is always printed by %llu. See
Documentation/core-api/printk-formats.rst.

>  			goto unlock_folio;
>  		}
>  
>  		err = shmem_add_to_page_cache(folio, mapping, index, NULL,
>  					      mapping_gfp_mask(mapping));
>  		if (err) {
> -			pr_err("shmem: failed to add to page cache folio index %ld: %d\n",
> -			       i, err);
> +			pr_err("shmem: failed to add to page cache folio index %llu: %d\n",
> +			       (unsigned long long)index, err);
>  			goto unlock_folio;
>  		}
>  
> @@ -472,8 +472,8 @@ static int memfd_luo_retrieve_folios(struct file *file,
>  		npages = folio_nr_pages(folio);
>  		err = shmem_inode_acct_blocks(inode, npages);
>  		if (err) {
> -			pr_err("shmem: failed to account folio index %ld(%ld pages): %d\n",
> -			       i, npages, err);
> +			pr_err("shmem: failed to account folio index %llu(%ld pages): %d\n",
> +			       (unsigned long long)index, npages, err);
>  			goto remove_from_cache;
>  		}

-- 
Regards,
Pratyush Yadav

