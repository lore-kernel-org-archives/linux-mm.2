Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA18F53D7E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 17:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143856B02F1; Mon, 16 Mar 2026 13:41:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E746B02F7; Mon, 16 Mar 2026 13:41:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03AEA6B02FF; Mon, 16 Mar 2026 13:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7AD96B02F1
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:41:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90CF8C18E3
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:41:15 +0000 (UTC)
X-FDA: 84552642510.21.544338B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 11CD98000B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:41:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HKaMKG0J;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773682874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aSLuN2rpEpuayesoGn3c5viQON6T20I/YWiP4UvupBM=;
	b=nFMY7m0pGWkUo/cJPtrK+YBXSXFpaamWZ3U28qFpwPGebUFx2k+GooWIYPI3dDkEgNQb/6
	CcjiXp+7EVIoWicI4YS/9Iwk1XNpBCg3yx0Ru/XNyMwLpMOgZW+5iNphkmq0sJ4fkP6Qru
	/dafkT7W+DN2IRxWk5mX+LnXwuPQkjo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773682874; a=rsa-sha256;
	cv=none;
	b=QmEThGK5pt9sIoL6gy2lRTvyR598On62lHfbeWf9rsCXUihAE6l91VYoVE+RZzCd8yFeqA
	DqwYPD1Y+l5O9XAD9duyZ38OFLJXAfoXQt+fUC7gVUcDCiOAPUON4JBY+2SIs/F1VPOzS4
	qUeKvFnasTMmyUuosJcUEvX1+c+cWW0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HKaMKG0J;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F82840BF5;
	Mon, 16 Mar 2026 17:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F85C19421;
	Mon, 16 Mar 2026 17:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773682872;
	bh=mn86UWxm6vL8oxBfD0hRZ9t1qWlOn0i/Goc/nNKxjL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HKaMKG0JsLag7/RFcl5oIEDOFErhPUfX4Nq9EDvpJMbmS60HRgGIrpPiTPmVUL8nV
	 qDymISISWbKSslwXkOTLzEMQf7Rkmymbm5CVSC3VUmM7niv7BcYC0QqGosAPl1GPfx
	 QGMZxjCmZNI2DaeSUYUcwPl+2IsNhFccAQvEftQnSNFzTNIW8cRuMcqqJosnbZB8bn
	 lmkSOFAHnIdX0nj4JTTIRW0Nc/W2ZsABpcf6bkkOmHbQuz8fecHtLXo9nKKUTSj5Od
	 gs+7WdAwuBF2P7OsqxjCuHLDAc/Q9C6o0LnYzxWrLlWFazBmoJwl+Ug49sACMq7MAH
	 no63hbwU0DqSQ==
Date: Mon, 16 Mar 2026 17:41:10 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kees Cook <kees@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/23] mm/vma: convert vm_flags_t to vma_flags_t in
 vma code
Message-ID: <d3688526-cd37-42f5-9eea-63ab19f7d446@lucifer.local>
References: <cover.1773665966.git.ljs@kernel.org>
 <20260316091704.24d7f8230ad57e8b7d18e9f8@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316091704.24d7f8230ad57e8b7d18e9f8@linux-foundation.org>
X-Stat-Signature: 8wmk73ueyuc6p9x33rnkieoq3yepjjn5
X-Rspam-User: 
X-Rspamd-Queue-Id: 11CD98000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1773682873-497356
X-HE-Meta: U2FsdGVkX1/w+vaNC18KAS/4CO9ZE2FdYV/sCHdMPt54lSfmPGYmg3cdR9cWCO3qMtb6ZQ3uceezNMTSYsRA2xYYZ51i8SX2hFb1MTDeWQJ9Xz33ymJKHUeFUava3R3SkZyDPbqzC/aw6MQMf4t4W43AmM96+gwm2U6Xrh+m1X2fbbMyQCTCm+nEd9yn/HcSlYp38TxZMkMHkXNvUcBCb1p6ej6AjYR4a/E7cKOM7mYPh+g1pjKucM5wxAEvfhWvP5IfbKHwKzTmGMwftCZ+bjumKyP315zCj1gpuqog72ohAvlU/KuXDN1SkMKxm4JoRSZsVZpJ6alzq7aw2H5p/OTNk4a3SNfR24rh9goEyZ6EC1ClWggiqzL4bv7X1hie/J7ZvVIHD4d50oFUa0fWAkCdO6Gun8b+2LefrP6OuI9EkOaxQ7tPqpFehe1BlbHd+DyugQgjUzSjF6AjYanZl/6LW06+bFYAfwaLr7jT3FTIXSNBalJYcd1Hm/mj1rWllHJBcLu7BpzfxQZFiWR+wC7TJpr6koVbcxctWS+RlAwaVPEztmBuGkZjt/FMBddAJtbMq2zgCt7BFRvqHmJTbs77CnPdbgV+f7zhf7ZUotyKmB1Rrkb1Tk4jz64BEZf3Dic3Gu3yFCv9+NBtCdRA16v44mtedUbsiL0WEJ6pYKI1xCQf/IZ5lsEapOEvkHs5YH3kQHDAZnad0qpdtpFXHiU39eUquf0kUj00ENPF6/GIFqkmfmfxt9sLApxXiKU3+u8NXrvMVj/CvX4wuRXwxxKqZCo6YASs0XUl0Kf7+il1xjwyxzfoWgmnJ5J6+8pFTJ3Mp3JhQBaWQambL82ooo+nVGbEw/ODq42kO5KJCC9q0LfQuVBxgeCuMfpe7BHs15n6VoJl/2EcllX+3DaefFje5jeODQC5ZYvS4gDxv/zG108qNNzkJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(trimmed mail list for sanity)

On Mon, Mar 16, 2026 at 09:17:04AM -0700, Andrew Morton wrote:
> On Mon, 16 Mar 2026 13:07:49 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > This series converts a lot of the existing use of the legacy vm_flags_t
> > data type to the new vma_flags_t type which replaces it.
>
> This series assumes the non-presence of your series "mm: expand
> mmap_prepare functionality and usage".  Seems that series is due for a
> respin so I'll drop v1.

Are there really that many clashes between the two?

I am working on a respin now, I can rebase that on this series if it helps.

Thanks, Lorenzo

