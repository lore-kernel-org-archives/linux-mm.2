Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E24AD60A3828
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AtILWUY5
Received: by kanga.kvack.org (Postfix)
	id 15D4E6B05B1; Mon,  2 Nov 2026 07:50:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135AB6B05B2; Mon,  2 Nov 2026 07:50:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 073566B05B3; Mon,  2 Nov 2026 07:50:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC08E6B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:50:35 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6CC51120CBE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:50:35 +0000 (UTC)
X-FDA: 85390162830.14.91C2D6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C18AD1A0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:50:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AtILWUY5;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793623833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97k+e4o91hVS9qTh0dt39z8aEg6Tzz29+YtF2wcbbgQ=;
	b=QKt4KFCVKDAEa18p3xQgYwr+3Sm6g/h+9Ct1h7x1wUZ/Vnt//8EHY6WfQEjaiErXQmjxT/
	sIKuwiHt4mnGs07en+oHbpRDUWWabWBr9mDSUX4ct1z93zReYz6f5vXvDbgDoqY34wYNHH
	AEHmp4Hv43N4tcM1qUrSl7b1s2wWd/A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AtILWUY5;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793623833;
	b=IdxTiYNbweUDH3ms+WERYyFyXbcJ6tQQ4w/Q9rI4EzjMZBk7xJGY9Dlo+W2TE2i4pYaJle
	uVEs4Yv/nOdH1D/Gezp6XRxjnmx7J1GD9Ny6eqHAigdUbtg55+kELFX1Rh+IQxFNQ7+ri2
	xGFamCDKCtFX/YB7+k/iFQkh1bD2pwY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 031EA41F24;
	Mon,  2 Nov 2026 12:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E611F00A16;
	Mon,  2 Nov 2026 12:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793623832;
	bh=97k+e4o91hVS9qTh0dt39z8aEg6Tzz29+YtF2wcbbgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AtILWUY5mIyFfXVHZZaMeNlTRaC2KwUhu0hD8VnlvyFSwdU2U5A/xQ0ALr3MsnQFM
	 8ZeQHoUza99Mhfc2+tOUwCI5VTf8eyaOzi0yPy/CXApVpW5D2zaG8gxReKXCiTJ+M4
	 K1yLSKzWKE9omc2nQg2mWJM5SI4tldOftcDqRp9JTu6gj0QePp+mMqc7+CS05twCXT
	 ez1OpyhpBTBgtCScS0autEhUeeUpxfyzbif/uD4HF03RLlPLf3QSxSln88hA+vpxlk
	 adNtmnDK1Y3CC0YMNFcVCijWH5MvSLSh05Rf5zzVuXStZ3oF08Qc3JKxwsfIK1+2IK
	 7PkEAA6TPwAmg==
Date: Mon, 2 Nov 2026 12:50:27 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 0/6] mm/mremap: report a failed split before moving
 anything
Message-ID: <auiGqsbwuRhIfhvj@gremlin>
References: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C18AD1A0007
X-Stat-Signature: zoub3r3twzwfcr8pph8mc3qnrqgbt9am
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793623833-947156
X-HE-Meta: U2FsdGVkX19ImSuX8I1MxQMdquGexjB4bcAx7WmLY31uOKc+X8v+O1btFvtrqXNqtilemtsAI/yns32N1Bikq0ghVQ8wiafHCG4dSdICfIF708sqryusfDnuWWoWn1wifkVXC2WlrPRy+eaM8M308FxKeVUB7P/0NNySPkwB1+NdGdHhVd6h+z9RkpsXIkjytNAbBDSNlwtcp0v5FeLmhickhQYQwmB48XqNM3WWYO5TKx3OScL96xfdp0ft3SS7wk447nYi2Y/uLQkdZ2d/3ZrQPKlRdTrol3nmPWLvBMEvjdCZF4I3g62WSlFuNPMq4pZvwtf3kiOXj/kAbbbfD3q3ARaaeoVcY8we5BH3XKgVsa8dlG16zwprylOzYoyAUDACOIzcB+1seF1NluzV/Ct+h1jFmUDc4D9EcWTfVO9gwTrSkc1nzBW7o7JnJqxpp4ZGBuKjuxMXgcvNtcuFOjF6NhpgGfGrJ0mr/5nGRIxKkKq7OI3ZFuX6W68TVCpGihn5f/YHnSrLrC4YfJ2nuTHDtCRubOZ8AH+Is7jUTZTt9xdYFW/eIPcB7zJnLXhHmHCHhI50m11J2K1xSHm5w9zxH2hgKzt3rWz4U8xHIwGdV3nnwp2fKdwUUO8gtr6EVQ+wh7+UXM7O2xFKpgy8CuBPm3BBfzaSGuq8bB00N/tk2an7P2Pvmf/2ILpwPRDPheoBSPkp/Rum7kP35yNkxusGbudsAoj2xPKbxBZQ0tDSmJIqvVhurqDMk1V6sNJUuoP/cKNftoTYmj+mSGJrQBuKBE5FNFG/OuN4O5mvdelqchZYZpX2OgfkBwQ1nuydR6L9WS3lZyC9d00lr6yAGENg6dATA1UjWQRjR+LxUL4VS1jzt4zCNhyHoUlt2AFkUT5FT/v7pf6f4lI0mabthPBoVqJzqz6PQMSPRXToCyWqbWGg3gyzzU9ZWeSB6fIJpuzUcvyLuq0o1fAJ7R/
 +Bn1df5d
 lLj31EuefFc45b33UsNmPSA++E+rV1Lv44JBGY+r/KwmJ2OE0ME67MM9/BAcuUjIZfcfrL6SNZOAp5BxcHu9nUUTxdutPaRWrXJ9l5hh5FwOaAuIY7/vTew/GXwVlk5SOSj6Die5Yz8k5tYSp1QuB3k1LuWu4cKQvoXXbcGVtbzxjM6UiyhyT/VsHQ9TCfPZyo7gkzVN4bS7MeI0p+Hxz//WOiVP4Mlsz3Cn2O+WRSO47zUrav4/Ut0opbKOjE9rAEtai
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 02:42:45PM +0000, Josef Bacik wrote:
> Hello,
>
> I went through the callers of __split_vma() to see who can't cope with
> it failing, and mremap() is the bad one.  If you move part of a VMA we

Yeah, what's frustrating there is that, AFAICT, the only really relevant
case is DAX.

But maybe hugetlb somehow raises its ugly head as you allude to.

> don't split it until the very end, when we unmap the old range.  By then
> the page tables have moved and there's nothing to go back to, so we fix
> up the accounting and return success with the old range still mapped.
>
> Lorenzo recently added a way to split ahead of the move for the mlock()
> + MREMAP_DONTUNMAP case.  This series uses that for every move that

MREMAP_DONTUNMAP is another real horror show for bugs. Candidate for
'should have never been merged'...

> unmaps its source, so a split that fails is reported before we've done
> anything.
>
> Doing that turned up a real bug in hugetlb.  We take the reservation map
> away from the whole old VMA before the part that's moving is split off,
> so the parts that stay never give their reservations back.  That fix is
> the first patch so it can go to stable by itself, and the second patch
> is a selftest for it.
>
> The next two fix the accounting for when the unmap at the end does fail,
> we either charged memory that was never accounted or lost track of the
> charge for the whole VMA.  That gets a lot harder to hit with the last
> patch but it's still possible.  There's also a test for an old size of
> 0, which nothing covered.

I feel like the charging logic needs to be reworked anyway. This whole
'drop VMA_ACCOUNT_BIT' hack is extremely stupid.

>
> I tested this with the mm selftests and with a loop that fails each
> allocation inside mremap() in turn and checks that we either moved or
> didn't.  The numbers for moving part of a mapping don't change.  Thanks,
>
> Josef

Anyway, thanks for these, will go through.

>
> ---
> Josef Bacik (6):
>       mm/mremap: fix hugetlb reservation leak on partial move
>       selftests/mm: test a partial mremap() of hugetlb memory
>       mm/mremap: reaccount on unmap failure only if accounted
>       mm/mremap: restore VM_ACCOUNT if the unmap fails
>       selftests/mm: test mremap() with an old size of 0
>       mm/mremap: split first so a failed split is reported
>
>  mm/mremap.c                                 | 55 +++++++++++++++++++++++------
>  tools/testing/selftests/mm/hugetlb-mremap.c | 52 +++++++++++++++++++++++++--
>  tools/testing/selftests/mm/mremap_test.c    | 52 ++++++++++++++++++++++++++-
>  3 files changed, 145 insertions(+), 14 deletions(-)
> ---
> base-commit: cd1d0b147afa81f80927f9711e53401703964217
> change-id: 20261030-b4-mremap-pre-split-13a3d54d6dbd
>

--
Cheers, Lorenzo

