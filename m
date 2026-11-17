Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54B0C606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MtsfLFMd
Received: by kanga.kvack.org (Postfix)
	id 5B0EA6B05C2; Tue, 17 Nov 2026 16:24:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55EF06B05C3; Tue, 17 Nov 2026 16:24:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49D0D6B05C4; Tue, 17 Nov 2026 16:24:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 266FE6B05C2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:24:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA3341A05BE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:24:50 +0000 (UTC)
X-FDA: 85445890740.18.1C67CF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0EF5D120003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:24:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MtsfLFMd;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794950689;
	b=lThiEZEjKcP/hk3mwKw0MYJH3zU4MtXPv+Y9ypnWss3R0AW/X5ipFb1rjtqRNMJjNtnSFF
	+bPwfdH0gyIRHpWtNGcCUGbMobPX0AjskbQAnLZanJlBY55XSCNfGTQ352lzsCNm3ZVuhJ
	Ynu+e+pQpyZlYRbYUwum4rhRFp/FZ64=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MtsfLFMd;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794950689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hvH8bxVat9uMPDe9n4hf/lY7kBk2VZsQsFJYCeEIQ48=;
	b=N//ran7fsZURu23N6kmsMCLUejuczFjWVJS4SsxwoNdHYAgEgxc/Zazu1XZNaIdIVfFV0z
	Mhc0j+La0lfCpWHYlO2J5AmlUQ3EMRZKdXKYcEKxG9ljtqpC9tvDtMvnu/Ldaru1ddBAfK
	NoNyplGx7t88qJUB0jOiLchJah52/lg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64E8060A75;
	Tue, 17 Nov 2026 21:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300C91F000C4;
	Tue, 17 Nov 2026 21:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794950688;
	bh=hvH8bxVat9uMPDe9n4hf/lY7kBk2VZsQsFJYCeEIQ48=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=MtsfLFMdLzw9jXBtv+5BOt1KrDAYuS+bDvrTuob6CE3dxLkG9/t78xyItT1dSAr7T
	 MmR1lQ3cWMeKelsvWGIUsloe4B2sp6cn23BXQzEtK9nd0oRQFp2GvjyxESWICF7ebd
	 cUsjmK91CX0Z7TkfZDmB18YZL4wEQEZSfyW0W87uSt8KDCe+EiKVwrF0AkzZ96yDYT
	 Sj5ZbKPK5mEo7jwpYUX/MGFrDDDmKx+QaqaIoZ/YWDP3TQFwhGTYSx8lvn/QHDbvj0
	 9gALozEay7jOBr+SMc3uFNCyUZla33mjC7fTCOahNL6WINrBt+pUXMG+eIVkMeuec+
	 LBy6xpMjWXZ9g==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Daniel Wade <danjwade95@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 stable@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261117100622.807-1-danjwade95@gmail.com>
References: <20261117100622.807-1-danjwade95@gmail.com>
Subject: Re: [PATCH v2] mm/memory: mark unshare copies dirty to fix
 MADV_FREE data loss
Message-Id: <179495068490.3690.332778202915534478.b4-ty@b4>
Date: Tue, 17 Nov 2026 22:24:44 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0EF5D120003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ai7fa35h3ss41umq4uu1tfdoacbsuort
X-Rspam-User: 
X-HE-Tag: 1794950688-280888
X-HE-Meta: U2FsdGVkX1+P6gaGznE8KU2J8w6DvRN4V/3XH5vs6v8ICGt5tBPArw0Sxz1EnacopE0rfhFu3JIZlWOXFJSvLLQ4PuN671b5hPCAd5bi7LGTVxZgJ0GHmGhQwpN+iMwzSFssCy1npMJUzlGMxLDWpSjXFyJnUdNcSlGk2/gXEiSG5BA5HeeKl4zgiRE3NTT6fdPULwdUsEvkXNINC3eeuPr3ktD8V83dMKnel5UjSnRAKf5s515F46aAOuBUshxWxGJrkoMP7eEkN7ErTIYlP8sRX/Ga91OIdCG3TRdnZBiwcyu+hGAGHnPZTxP2hJ4nxbjjOnFK8Mc7qFGJ5UT4bWlCWdH8S2vfr/TYbLGSEtgxZSvXsGeYVWHA/qoNFakJYfnrWC4gQPkbGXt0hM1GQx0dM5xb4wv4uT7eq2yj0ojBZplRzHOIm6yWqC9gcjc7DYEhVdsZz5M4JWYjdKsyly8G1697GyGVvPT7L3/TebVLpjPEBRScnV7heG6q73cEG9c/6JPfCX8A02z8mCu58ssLrCwzVpTGz+k1tlZ/gmS1wniLByO0yBPDFtrLRqGQmbGgwxf+7Q2tjBiiebdNF25sada0DFZgGgX/wNEXUrhQpMDr4E6VPWPUVDZDMWhDP3rRVQ/+uLU/9U1Iri9VJrZ2P93SlRPRtvQbXSLVzlkw6VZ4yiTqumieWQBmzHIHeWyVVRuZYdZZE5HGI093mOen/MG1YkGRWs5ivAwMeBZgUTkVOpa2BonzRm8HbXFebWYno4Z9Sr3Gn9ICXTJzsEQG0kUqwIj47YDKG7j1n3neTFbXr/Z4KbKxHVX4rYmVVELUEy4M8lh7xUGo77PNYFsAU64SOQRCSRBterhifh3eJSdPA3VfkClk9epkenhej07Gn7lMCN1kGpdywg5zkOkk08/EazHMkm/HDOx2el3oLdE9W7XcLv3cPpdwq5bp5iUUst0gxBBrY/Wl4+0
 gbriFSWN
 86Eb/sQccMti78eB+Dgg9/OifawNsWp1u4vf6IMJyZ5SU9R7V4gso1kOk9tAX1I27wRqhcaNi9bQhO7IRO0nb7y4LILZd7wEVnpHOu61hX3UZLZnjcQoEGVrJ9xSQQEuqHi7PGZMLnzRz5ToYrDX5jHnLXxXHVTveSPzz1j2kvR49ptFJl7Qt+ulz/eJpCsdsy0399XrcGbBxe0oUg7lohl98tlGWsoxJBSTv+SFbfLATn1g5V3Hc3cgRbIyxryNB2dVa9fdCUxBuWj1DbgLI04nhSTjE8qCedh57
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 20:36:22 +1030, Daniel Wade wrote:
> wp_page_copy() only calls pte_mkdirty() for write faults, so the copy it
> makes for FAULT_FLAG_UNSHARE comes out clean. Nothing marks the folio
> dirty either and there is no swap entry.
> 
> Unshare faults come from R/O GUP pins, like process_vm_readv() on a page
> shared with a child. If the process forks after the pin is gone,
> MADV_FREE in one of them marks the folio lazyfree and reclaim frees it.
> The other process then reads zeroes.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/memory: mark unshare copies dirty to fix MADV_FREE data loss
      https://git.kernel.org/mm/core/c/1000fb7d

-- 
Cheers,

David


