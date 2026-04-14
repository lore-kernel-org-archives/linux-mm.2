Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DFDAED7BBC
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 11:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 967EE6B008A; Tue, 14 Apr 2026 07:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1B26B0092; Tue, 14 Apr 2026 07:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0746B0093; Tue, 14 Apr 2026 07:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9726B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:02:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26C111A0484
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:02:34 +0000 (UTC)
X-FDA: 84656873028.27.3AC62C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 577F98000C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:02:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lY+9sZw9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776164552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+VpTe+WuVl1yuwob5XhA95OUA4GD8mqNOo7qWLaG+SU=;
	b=q2dhtxxiDz5JsYi8R1A/ZafISVYZXYBfywWERfv5HaGbfZDpKG/wGmprih6dJT5I3Fzp7Y
	t9pwYQ0mH5knwPz5QSfcDLC+0m4fWqRaZGI0q3Dwzw2mPte6gsfrSgEBz3RwFh6S1owuy3
	xwNe0JOFS2r7coZnAeB2JBpPLNj28QU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776164552; a=rsa-sha256;
	cv=none;
	b=d9qBBALeSQ0N540Tb4AxkOi/cYoXIwGw71B4wbSc4jHlPzYmPkm8iz3iWybneOW2dT37j8
	pF485jqvkhwX4npNzfwNriIj6oEUYoG0e+EtYF+KLOCdREd9W7jJZQRb7W77GgctRb5CV3
	sneb3Y1kifW/EgmeS37VjXj6bun+Zy8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lY+9sZw9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D11AB60128;
	Tue, 14 Apr 2026 11:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA840C2BCB0;
	Tue, 14 Apr 2026 11:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776164551;
	bh=3L75qoIdfVmbrRRNBBC06gsElLNoH88AzCYCRI+iW2k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lY+9sZw98Ga25Md8XYklF0/JB0HQRNe3Rp7rtmg62qtYCT6GqQPywfE40U8C7sxyg
	 SWhlykTqHogv+APng04XeNVaPGtWAeHPVxnLmYrx6Ipc1HHwZKB5gy3J7yckvnY41v
	 TN87wxPxNN+H7+3MhsFD0k7VfvuH7u9hoA/HSzGfdbLpj3WlYNAVn81cwN+qvpU2RH
	 sSlzDGBet7KbENuS4E5Ec3bmBCsPtLjHTZ8tAk6+vq9CQIjjT9QiqMcChRMVVcqQ40
	 H5dc+n0Nf+GzUFVFh9hurubZh7xRyuFoS4aIUJ5dLl7+9yLZ+S3t+NjVg/OQC1VOO1
	 hykSOqAxUhN2w==
Message-ID: <8c4dd0ba-3e10-4510-8f17-59983e4d2e8c@kernel.org>
Date: Tue, 14 Apr 2026 13:02:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 06/12] mm: fs: remove filemap_nr_thps*() functions
 and their users
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-7-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413192030.3275825-7-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 577F98000C
X-Stat-Signature: utife5dweubsdgjoq7rw3ffa6ccpbejq
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776164552-548151
X-HE-Meta: U2FsdGVkX19VMKZMuAj7/LsjERqtCOiNVQPXudRkOQcyFlKxMY4VRkyT5bZ1vn1lVrrL04rhAEvPEiaYcW5lWp92vzYcro39rnpcYeo7LIU4WOeaC5Bu3r2s0IBw1iiTAUkkrsNS1Ck0j8XT1B1gCnLV2cSgnXT6t1r996rLmy3HYyS8m58Bqnu3dzwlQ+WkaAUhjCB+MIlzHH7+n9qPrWgfUuPcqApneoylnWlxH6kDltE3+xUIjVy6tT/rxXjyMI6m6sN7lj7F1FZBsYgRv7d9hr8/rd7AYBAcX3en6BRtIZL5SHtPEnfXdNTd+SAZNXiECnT+er7nHRiOJZRh6IyPSqIdsxC/IrmRdoFwrDjPOeGVyad4WrkUCj7IvhDYYZDt038iJJF2KCEVX75x4OEIwMgltVwCANKS2fsysAxHCjizwKl/hoT+7MIxlwBI9BBJkBlKLyP7rsRC8OCEVObooaETzUwIKbSISLfem00e21oBPdss7eu2eL8qfn5D2BCg0o5zCqqIr5ndTJJlnbxDVgOF2va0RMK3DNdRoVDj3CXdslF0t1mNJFhOO6fTJOvXwzDL58avwjFdXElXJR7br1CgdXpeZjly0KY2Zcag6A43u/9e+ckEVWu9M8yTLroehiHCNZdUbYA2TD0HLy8hCSdEq0FKzslznaYkHKFmTJWISaHzwMt/J6NWA8QHErzOxBrKmIYvps86VZd6H9ltW9mQYlTxGHCAUV/3rOoxJ5OE4Ow0r/gzTw5ULCFBI9/rLcIRBCZ+ftobONchOUwT0y2Zl8LGFgVop7MUxQ32vHRErc7SZ/YwqwjIid8jjAYFWHj/lG3z8QsRJfeHEVdSz8iQLe55IPle7oBKN1USgrMkiHSa4qjey6UulPbP4K0WTpk3aks4wqnHa1M3YBQ4jKP0SBo47fi5NPdAgPdDs7YyundStLy3Pk+GwZ1lCo/m3gRMkcyRUA+hUpi
 H7jgxzmj
 /YxoB01V3GL/mIE+5T36Bo2SQZ0WH/oDhMtGNr2PJQYuLl+kUnHNb8uciP6PLPdbixMxbhacfTt9NZPDyOA5YDeZPur7rBdGMxrNuXq2S94NbiRjA/8oaRNrA1xIOcUOnBnPpiZ3DqxxeR2hThlLmxX1IoERPxPvInWaEngQiupB4fG9R5F9kvcLKam5+V76D/M7qPEn6u1EfeArimfpIAwx9vXK4l5z/KzFtEfxdhs/LRhJ9JYNhG2+DkmLW6gvl3jabNEyNwzlTARPCLHdW0P6v9zi9UK0Kb7EVSa1/2q7WvifTL2SonlVigPCojbnSATnPWPw4QlgLWDv43mHZ1lvCdwC7agRR9t0j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 21:20, Zi Yan wrote:
> They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
> large folio support, so that read-only THPs created in these FSes are not
> seen by the FSes when the underlying fd becomes writable. Now read-only PMD
> THPs only appear in a FS with large folio support and the supported orders
> include PMD_ORDRE.
> 
> READ_ONLY_THP_FOR_FS was using mapping->nr_thps, inode->i_writecount, and
> smp_mb() to prevent writes to a read-only THP and collapsing writable
> folios into a THP. In collapse_file(), mapping->nr_thps is increased, then
> smp_mb(), and if inode->i_writecount > 0, collapse is stopped, while
> do_dentry_open() first increases inode->i_writecount, then a full memory
> fence, and if mapping->nr_thps > 0, all read-only THPs are truncated.
> 
> Now this mechanism can be removed along with READ_ONLY_THP_FOR_FS code,
> since a dirty folio check has been added after try_to_unmap() and
> try_to_unmap_flush() in collapse_file() to make sure no writable folio can
> be collapsed.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

