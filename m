Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 775CFFED3C1
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCDF96B0005; Fri, 24 Apr 2026 08:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F206B0095; Fri, 24 Apr 2026 08:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A945B6B0096; Fri, 24 Apr 2026 08:43:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 965996B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:43:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 510E3A0120
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:43:16 +0000 (UTC)
X-FDA: 84693414792.22.4ADFD82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 72E8640009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:43:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GvWlI/PB";
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777034594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BoUJwoq4bojpR/YODaPQnQLIjzWhgXAZZXIGj0Fplto=;
	b=rPLnsotFVm++orB1nMs7jFsqyCvCPSqY6ajLKcp1/o8cfphkRMBRAVTsaSPpVjD6nb0Q1l
	3frbrFpezHdnG5pxnddqZ0TKwTJ9EUNbhiLUepPKc7W2xwFRjkRajB0elgIzBnH4Jk6O1X
	33LV6V+pm0HVdgg7aEHodVjp8+vH4iE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GvWlI/PB";
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777034594; a=rsa-sha256;
	cv=none;
	b=nnBUGfDO1wWRd4tfhZxJ4lv3aNrJjy6+AtZXRRK26NrJ1p3UOVTmDrr0n8XwBwD862Jdui
	LxDEfP2lkbpg4vY2JuhvrtD1oQegm3XbeeP7QN8sHo6QIUTzQ/JAcVziwCwHlL8JyACHLG
	rlAE+zpvDgp8zM5SmnrmlLT/gA+MVB8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 694F24424E;
	Fri, 24 Apr 2026 12:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C30C19425;
	Fri, 24 Apr 2026 12:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777034593;
	bh=A8Xv77MZdIwUP4OGTQH12LVbjGVW7Q5PgatU6hZo1c8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GvWlI/PBBsrM97FtrKUwJ4dy8XCDHWcBfG1FJF69Uu80g7SeDUwWE0dm5LBrIKW8X
	 dG20HH5q13MOKMvRV37TntY330Advrgn3VXP9lKN3D+lEDyHIOZdG8D0+XQvSKXRaB
	 OWTFUjX/c5DSJh3mBP3AX+TS7aOSO2TVWs2kuIYz7xmkaxvCmuhNn2t6jIX7TpBIDe
	 9Ghk6q/JgbowZUn6vFYExXVyOjzCiaGtInT5D4NupCoMzKPKG7DRMTKsOPU7V17C49
	 K8gVlnNdmF0L6PhUdr+CXKCW0sx5X85+VQWhhD9PxAFIaCOdZEkaoJvsZMH0zAe586
	 9BkKdRS84Hy6g==
Message-ID: <aec46705-a02c-4429-844f-bdfa1140661b@kernel.org>
Date: Fri, 24 Apr 2026 14:43:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v4 02/12] mm/khugepaged: add folio dirty check after
 try_to_unmap()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-3-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424024915.28758-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 72E8640009
X-Stat-Signature: z89gwj3ncfdfdoaqwgqsebfrxefuwyxz
X-Rspam-User: 
X-HE-Tag: 1777034594-989673
X-HE-Meta: U2FsdGVkX1+Q9xa2yAiaE0mAWz7IX84oF/QeO+C2j0tbYX1o2MfiszTWydhEXJqvUETDOYRK/4CXZwQjKoW7O5398P3N5/tQMKITVVccXWIIKu2IevLzOBHY2lafX20S6NTOQjG0BNhIR/RPz5O/m4owr3lc2XwGEOOxGJtm2/oqLxNMPKSF9UVfq5ALZi/B/gnJN+uhC8oRLQUXtRgF2REuQdh77xoAjI4hNzwAi7pBdTLaYwAiE87Jd0nurMQSO/yajgbaDpHhse3DkI1o5bUHLJ/Lh0jCl6RVh9SuXYlhnsGvfVM5LD6miYTyLsI+dqkKV4GCCnoYJU6vJskMdvatiMmYwNB5KbbHHsqKujTKQ1qw1yHUt/4Qi/NlG/uGDMSSbJ0Anx576bEpgIPgLGw1y50d8QgjATEV/CArC+/S5yzQQ0hKkigibhuKfCHXwgWG7m0tIzSujWYMjiwcgoRxtY/vfEaQ6CcHw/QOW9HB54KnZnkUPyzF4GEjUuSagKatoOMAED+w68sBJUTRLFGBoDU/stSleTqlRL+MGJgS8mlpFlsFW8GecLSACeDiSox/qoLRFACV3unx7lsFkcp6LwVnu3VwGwHQ9nkMBZOFR3TnkAYi+zH9dymyz1efiC/6BHuNi1yvNW0TgItep+R5KL4bqGs/njM1xxho+tvVyZd0iSAk3ubOr77HB8OPyjuAccp944ttStin18Jympv5xnYVClB1GZPKisyV/bqK+0OqyqOVT+emBHJRQznRWwBucOTKl3sMIwlKm84w87bHpAkWB0LokVKEnovHMBOfLJACzbSTDuozSIAcCgXbmCdf5WIbYRXLb2bmX+8CBFy3pY4ZFZ5lrdeCdKBjg/yTz7jPtUvvIFkjRqttl159BwnWzvaJyq6m7GJ+wGQDgqkdBGk5SxLLh96NCR16dLGVCsy5CJLyt2VxgafvdwtI395S8RnbVUHLdFjfE9p
 q1COr3v4
 zkUEWLqjdQuux4VTK0Ck/n3E7nrO+9JNuQcmBGsJuHshRyyqmWo4qJSnh4Ud86/4zRJVEbb8m21rtoJRtsQyNvOiq/UzZSMdaVy0DSKL5aACRT+WB/alketrgmj2klAPOmIlzDD+OBFMQjQlMaAWMjL1eUED2xKQSKiazSKDsH9UTcACffMATi2nPQ2u7zV5D0dPFrnBQ78S3tu3noATC7L88Dm77s1AijGXf8UhKWZXPfdSJWcAF5TRdJdrj0L9cNFY5WZ89jj6+qZEXuJfQ4pzJHhHvkVxLvkq69+kMttZ5vOBiZmV9VhZSIApG1E+I5Nsws5J3AAAv5Bm1ILwfhqiq7KlXojtTEMsI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 04:49, Zi Yan wrote:
> This check ensures the correctness of collapse read-only THPs for FSes
> after READ_ONLY_THP_FOR_FS is enabled by default for all FSes supporting
> PMD THP pagecache.
> 
> READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
> and inode->i_writecount to prevent any write to read-only to-be-collapsed
> folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
> aforementioned mechanism will go away too. To ensure khugepaged functions
> as expected after the changes, skip if any folio is dirty after
> try_to_unmap(), since a dirty folio means this read-only folio
> got some writes via mmap can happen between try_to_unmap() and
> try_to_unmap_flush() via cached TLB entries and khugepaged does not support
> writable pagecache folio collapse yet.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

