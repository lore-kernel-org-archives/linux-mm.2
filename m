Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD0CEFF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438F76B008C; Tue, 28 Apr 2026 03:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410066B0092; Tue, 28 Apr 2026 03:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34D456B0093; Tue, 28 Apr 2026 03:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22AC76B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:05:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7ED0140467
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:05:45 +0000 (UTC)
X-FDA: 84707079450.15.F0B505F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3C23712000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:05:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ben7krCh;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777359944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uEVl32vWRjlM+o7OTG78llEQbH/zUi79r9Un5rZBKBg=;
	b=p/R/BUAiLcl+sfQ0OAqzv4jaCAdvjxmjGyOUIfLYz/fRkcpVHHUqbEx1Um1lRLU2KFOTUo
	BGw8q1pgqOxBXOtcuIuvcnNyu64D+OtoT3UwZOx2jhxMDRhGEw2ukeBocC9fEGEVS9zORY
	AdTJPx0IrxwFuTIN3EXsCdYM1RlJSHw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ben7krCh;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777359944; a=rsa-sha256;
	cv=none;
	b=UkHIWlL3m9Dl02f0E/jturRleg3eRuWQqZIgV6VF/he2mgGY7eWFqyaK+mM6OQkV7fO7Ed
	cJlqdtmODF+/DC8JuzANFvbD+0PCSEL17dxHDkjjcuwv2KH91LOVetHBymyc3uYW+NVhzP
	AyUlszvCtMNrej2XLeNEFUUFQP4t7Us=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A571860133;
	Tue, 28 Apr 2026 07:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452E1C2BCB7;
	Tue, 28 Apr 2026 07:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777359943;
	bh=uEVl32vWRjlM+o7OTG78llEQbH/zUi79r9Un5rZBKBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ben7krCh0THkzCMVVV2ylnzeyZI/4YGyA7Q2FRiI7+gS2eeTZnCZID3/WHojpaAQq
	 iAER84V/LqodDwx+nS51n4m2tkTw4SornZfSiYXa4kOaXyMarKZXx/UpmnmuoYHBuD
	 tXN3WWa85HklI4nlSgTdSxCs1r3AOTsQdZsxsUSw1+GtDqcItIPcgsBWviyi1Hh0w6
	 i78g8WCUVrUXh34IU2TcFhR1dvOptEJ9Huf3zIUk1reB4TVfwRYJtr6hB+Tnkb+b4m
	 vIvrRe3UtxRFqoCfjnPU+cOOC967VxyGqFVB3wMqBE28pSLvE/XBu5j8st3cz5J81V
	 O6FKgoiru8bKw==
Date: Tue, 28 Apr 2026 08:05:37 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: fujunjie <fujunjie1@qq.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, SeongJae Park <sj@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2] mm/madvise: reject invalid process_madvise() advice
 for zero-length vectors
Message-ID: <afBcEkWg8UUsX6DY@lucifer>
References: <tencent_98F3571EF9236437E5165F5C08CF258A9E08@qq.com>
 <tencent_BB588C2CDED859A873093DAF28B2CC1F7B0A@qq.com>
 <637208e9-9d1c-4e7c-8428-9c3d36e2b7da@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <637208e9-9d1c-4e7c-8428-9c3d36e2b7da@kernel.org>
X-Stat-Signature: 3ph1mabixztu3gfh9y5bu91ya6ggp6s8
X-Rspamd-Queue-Id: 3C23712000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777359944-870995
X-HE-Meta: U2FsdGVkX1+8KAHh2Cx7uPb3jRrDhgRG2Ha3KziQ0rrB32+WDuKQGD3fOFFSwioDJOPNcvY1tZvKzMwt7RedeIybha+p82YqGjDVve3oYkxPB8iiRVCvo7jdI1Zf7Z2RJrWu10KqDTENngMv1auuD4ntZeVsPAcSACOQ49cRJrTKnObp7yc9XIHnCyvJ/elJ/+nLppiIWhSYURHTlKBS5nQnEvf/FDEC01h1KZ1J+XyrJAI+EO8UOW5WZq1fij+lmoljMsJbq/t8f1pqY+62Hd5+QeZF1uiX8XFeKMOzIMIvwUNA0v/7wZ2RiuyqLcBfIMY5ueOl/Jxm6nYU2m7sn2T1f9dSbFwNrLDFEnmZwfGa0Uv8syOnwJFtXQrvi0W89oRKhWzkiH0523wg3p7XR2dwuPt/xhO9yDmJwlYkUJ4h6fgXcylk1Y9x7sUON3v0zEhVUJZNuDED4PdGRF+OAUSDW4lzG17lH23wjBKK+dHIe1QjAyHIl9ePBKTVIKET3opXiKmV1jVQhcqWmpxsCir32bLBTx8VRLCP5RGA7fsvVcQeplRr0u567CCLet1xYPYG1ZxACz/swQyG/5z99com4Q4R1TQKJcviu6LChHgDi5wR1Z2GP11jcRximmANNoEzZh4v10nr+P4k3dQFBgChISHwIMDa2TMByzUDtUIW70/yQy7r3chXCznfbuz7lzysPBJn5rDaCEPCdTr8k0ghkiKuitGGNtldLzTWrjdBDe58TeZM2a0+4d0zchbZrzZoS8/AiMFUwe69/Ha/pBzOnRBmrDcgKkE0npjm/7AFZAuaIztBykh/WwSSvkuvGc9yKxL6b6iwxk8VMZrElQc/tP5gFvSIo4BK5BJwV3z+zYISL47wPIryo34P5pBJG+fEGsgeUxf+1gRn6h9tFnuRsrKI9wea8w2bU+WXM2Tc3fhx/HDN2Dmyp9GN8eEf6LLuiU64GljHhklCNSz
 ucpV/Yrs
 /oxriD26gHqW+iauKY5GgzJWrAKsf+wOtnUuw3iGokBuQd+1N15zUnH81WlVI9Z6pu6b+KVSigHs3kYms0TIkgLES17DMR2P+oPbLuham4Nljhd36CdgDLfFsloLV/6PtV7y35MC28g/rT4m1wVjadJodA3OVYMmR/vklstzvdq3vuhb/3URQdcM6DMK13dsKZZURhyrR2w4CsXc6cxFAVmMwXKFwWr9L4XnBpTAdRiD5XA+hnrs6BMQVC46IRif0HyQY9AtONi/ElKYlozS8YJhQfQBz6IPJYPzgOzCfY7r8rOytvFBnVlOloh5WJJp7mHsv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 01:49:46PM +0200, David Hildenbrand (Arm) wrote:
> On 4/27/26 11:43, fujunjie wrote:
> > process_madvise() used to validate the advice while walking each
> > imported iovec. If the vector has zero total length, vector_madvise()
> > does not enter the loop and can return success without checking whether
> > the advice value is valid.
> >
> > For a local mm, such as process_madvise(PIDFD_SELF, ...), the remote-only
> > process_madvise_remote_valid() check is skipped. As a result, an invalid
> > advice can be reported as success when the vector has zero total length.
> > This differs from madvise(), which rejects an invalid advice before
> > returning success for a zero-length range.
> >
> > Validate the generic madvise behavior at the syscall-facing entry points
> > before any vector walk. In process_madvise(), do this before the
> > remote-only advice restriction so unsupported advice is rejected with the
> > same priority for local and remote mm. Then keep the per-range helper
> > focused on address/length validation, avoiding repeated behavior checks
> > for every iovec.
> >
> > Valid zero-length requests remain no-ops and continue to return 0. Add a
> > selftest that covers invalid advice with a zero-length iovec and an empty
> > vector, while also checking that a valid zero-length request still
> > succeeds.
> >
> > Fixes: 021781b01275 ("mm/madvise: unrestrict process_madvise() for current process")
> > Signed-off-by: fujunjie <fujunjie1@qq.com>
> > ---
>
>
> Next time, please don't send new revisions as reply to previous submissions.

Also this :P email sucks for all this but it makes it easy for me to miss your
reply :(

Thanks, Lorenzo

