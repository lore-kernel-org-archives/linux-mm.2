Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C126C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C86D6B0131; Mon, 17 Aug 2026 08:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179616B070E; Mon, 17 Aug 2026 08:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068D26B083F; Mon, 17 Aug 2026 08:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D782E6B0131
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:38:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A602160723
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:38:19 +0000 (UTC)
X-FDA: 85110714318.22.F624064
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BE688140008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:38:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nt9JknIU;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786970297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jan4OzxJD6YHTXR8sL9zOUPXJbJ02yzXDRqgLQqZmDw=;
	b=yNrXLt1kaVaRyg5XwDEOQzjb/iFJsxSOv4bZqia0imLx1MEahqPvRRcKlEyjI4mRLGMsUM
	M/3aEvzvHok168TzbHdntCzyc3mpLn23byjE0fScfw01VzXyxWcMrWPpXU7QV0u1sWUqL6
	U4mQBaYBl9da/Dvq2Qf6sC06tMQG+m0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nt9JknIU;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786970297;
	b=HaffGpIT27rZMFh+9cbgumQtykmmYL2PPgUej55jzNyrSu69vy58oQTjkBFpWWFs7W5qZE
	AJ+ZpFDcEGAkm6n0utL6+/4Ko6rVmfv+pkgsoWT/sQbGvITU7H9pfHn8222U/VpYj2ravx
	9Pc1d7Oq8Z5pOBrzBthZqLwzFKx2SNM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF9C043D6C;
	Mon, 17 Aug 2026 12:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE791F00A3A;
	Mon, 17 Aug 2026 12:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786970295;
	bh=jan4OzxJD6YHTXR8sL9zOUPXJbJ02yzXDRqgLQqZmDw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Nt9JknIUypwluAT0Ji5LQTyrFOwSkVwDvkrda5dvgtXQy7U9YgSYXXEWUionZIWjL
	 Ba/+IVsdJRP9OzsBQSOpGKoJVfI48sw3KnPL40Mm6WMf2wTBtYI5phjNgur1BlP3Fj
	 OWL6PNOCC9KpfAQZ/6O7YGY2D+LeFJhdbgLvEOoY7uFT05MfMmwcrD7nqUgz2jUXgk
	 g9ehqX7GSzo2ILJHxeI+1xHdHXJgoFqwEbXljMvAk+NEVLrWJZ7JXjSpB4yQRD71hi
	 VgZhyJym8+fRVjUW5Qpn/T/jz1woo/5WOFXqICkq9apxed+UuaJp9q/BlqyHHWgT6X
	 QITpVBN6IbbbQ==
Date: Mon, 17 Aug 2026 13:37:56 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 7/7] mm: Documentation: clarify where the mTHP stats
 live
Message-ID: <aoMAkG9hGAXAh9va@lucifer>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-7-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-7-ddac39d61c4a@linux.dev>
X-Stat-Signature: kodtg14w84199yybghwrtj6t1zo114p1
X-Rspamd-Queue-Id: BE688140008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786970297-122745
X-HE-Meta: U2FsdGVkX1/s5a+HHt7PUbpfPSTsq+lFwgepeKR5VVgp9YHzGf++BUj4q7seurzf/v9GNKDey4P1umy5isz+PbNvsZHF0FtclW7V7gVr5PxyvUmjoXHWt0rR4m8ea4pKEd4PBVIr2FBhsMZUd+DH818HwTxQPWjTS9z1Pjq0tH6LFU5vX9XwsAzhLYLtokkN1J+Q3tx5O9ViB7Gavf4JdrrqYu4y9d6lbrzlgOI9aTHcnQ28qa+3jTY1gz91K7DdqQZAZKJnXM2cmQGyvp4pQREVSxCdhqKZpXeU8pUMdGzhzwSAKhwoSscmlgzUlTMY66zGfrVt6e/SIVzGSnc40vn9Tw4s8Qu47fG/lHOyVy5kq0EiytqUHuhIuZKPOQBdlX+JBCvTSYdmkDGlZrz01K28TCcZXiFYZJc4EgBCtUI/PdnWznVFxffnXrLxcLYZFtCJPVZ97hSKNmWyB+3XTpXUtX3AwZJC0A2BPO0+/yFh9XUpxptt6k7qPCHAGOdcQqlfwoWkUU/o6BiA7lrVxJejQt95tQuAZ9NcHS6faGLjC42GKelilx6awFLqul9VFwd8s6hbBo1g9bFpmhcmoeFE2pMd+a1OfA58MYJP8cc06ErK4KW0UFgW4sgVe1/fJdYTolo+ZbsTgpazdR6/S4jNPJFC7ESZ/OP35m2f9XvkIoi1RQ06kCTk9kNH3V7ebkKC3I4m+Aze3h61RMUyGIxYN+bTDSFC0gud/8+N5WDch9Zwemxf0PYwM/bQVtOhZr6c71v/25ebPJSxRO7Vpar79kRoYOQDQE32/Nv+yLzUFmUdKyC8RZLG5SsP+Uu6qThN3vRKkRJrpYCpLPH/HZnub8R0kcfUhyBRhNNCl+wDT20DxUoDfexKmiRJP2E4JRk673uysdkq7c06NNtI+gV2FY4MAA1d/4Hzqp+cG+dLv5II1lvEZVvGoE/DhABEit+6zy4lUPnJg/XBUdW
 /OObPXWM
 V0SKYsgsUe14YSqoUiRn0d3mB00FXUtCjSbxaaL+oqVkMN6K3cAXHlJo7Cb1cVhhuMSvMBoMG/Gifw5JJLPEoSDdHXOcYVBDfeOCLrxmNczwm2FeDyI+4hOMiNi3Gbrft1NQC3o0FPletq2nadFfBHG0/pFQ6NgIHetjCPIE7JJD4YaK1ImCiReuWevIA+l2F58+hmZjshzonN+eDRC/7B+/zKYJA4viPtw2MPdRentNyyJ91ppb4QUvCenvCjL+H5WwpUQGtJnQWSNM5r0VsARcM0+fThdATgR6VRGXcIBfvDLo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:48:39AM -0600, Nico Pache (Red Hat) wrote:
> The note about khugepaged counters references /proc/vmstat for the PMD
> case, but never mentions where the mTHPs stats can be found
> (i.e.: /sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/)
> Add a small addition to this section for clarity.
>
> Also fix a missing period while we are at it.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

Thanks! LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>


> ---
>  Documentation/admin-guide/mm/transhuge.rst | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index 16f37135ed80..b187d618452f 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -224,7 +224,7 @@ khugepaged will be automatically started when any THP size is enabled
>  (either of the per-size anon control or the top-level control are set
>  to "always" or "madvise"), and it'll be automatically shutdown when
>  all THP sizes are disabled (when both the per-size anon control and the
> -top-level control are "never")
> +top-level control are "never").
>
>  process THP controls
>  --------------------
> @@ -301,7 +301,9 @@ being replaced by a PMD mapping, or (2) physical pages replaced by one
>  hugepage of various sizes (PMD-sized or mTHP). Each may happen independently,
>  or together, depending on the type of memory and the failures that occur.
>  As such, this value should be interpreted roughly as a sign of progress,
> -and counters in /proc/vmstat consulted for more accurate accounting)::
> +and counters in /proc/vmstat consulted for more accurate accounting.
> +Per-order mTHP collapse statistics are also available under
> +/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/)::
>
>  	/sys/kernel/mm/transparent_hugepage/khugepaged/pages_collapsed
>
>
> --
> 2.55.0
>

--
Cheers, Lorenzo

