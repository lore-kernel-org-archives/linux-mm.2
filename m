Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44D4760A2615
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=AbWyiBsH;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=m3cPI2hm
Received: by kanga.kvack.org (Postfix)
	id 5976A6B05B2; Mon, 26 Oct 2026 13:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547A16B05B3; Mon, 26 Oct 2026 13:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435F16B05B4; Mon, 26 Oct 2026 13:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19D0A6B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:12:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80EE4A0824
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:12:16 +0000 (UTC)
X-FDA: 85365420672.03.309DC71
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf14.hostedemail.com (Postfix) with ESMTP id 54BB0100014
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:12:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=AbWyiBsH;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="m 3cPI2h";
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793034734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZqGYNXG9Jy9oaDhM1F6gbcQnqTBe6d0+Qk2lQBEUtQ=;
	b=sdLm9RPuliC4y/wpxlOKfAFHHq8iDl9u1gmEVVxJfdWFFtXNnuUDCjDQegZJqViS8vA2pN
	0dCFD1EKbAmsLSnBba/cbpm1YFZBTUYddEVA31bxmxsE6yuGGyvdbhe2r5jJ8TTdAcxoD+
	V51kcPgS3Y2Rj8m8APa9VDfvAWVNqfk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=AbWyiBsH;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="m 3cPI2h";
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793034734;
	b=tTWK3iLmqydHLjoXGvPMNmVzBD6c//PgpR9lr7Ce9Kpxej9ss0/KNjTgUR9uPJSXYq9c+R
	z5tr3LSL48/k7CFtvaLlMxs9H+QY8o/zj4pyqni5AWiFlH5ZDXhMJdAlIDf5Cr6ZF7ilnP
	Uj1mN03dyoRBIE9wDzizg34ERfGFFkc=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id BA80413802A7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:12:13 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 26 Oct 2026 13:12:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm1;
	 t=1793034733; x=1793041933; bh=RZqGYNXG9Jy9oaDhM1F6gbcQnqTBe6d0
	+Qk2lQBEUtQ=; b=AbWyiBsHJcOAxp78Gt4falXdJ/81IDqSJLWnhkR08Drjh0il
	rRI3YNXUjvbhb2cf3tead8IQuqocZRovMqAiQWbMzdOMyv0Ipo1EgG2h+nQaIvkW
	DYJxu8IaaEHigLR3MBC3dSruMXaU5GG5e8cZ1kWqiLNNb1R6iu6nNRuZmANYH7Cy
	7H4Y/COcGaaFYj8DvBV/ymHEZJRsSwaWh+jONqTrghBnFfV3FqoKbvke+klVKPt7
	IylY2026lfRWAKvngJYsz9PKemVYH5ViGSHWSV9EeSBFoLcZ64+YtglHDEUC7JqQ
	mSWz20w0hZx0pw5bwPoiNw4E8lk5WBAiDX0v2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793034733; x=
	1793041933; bh=RZqGYNXG9Jy9oaDhM1F6gbcQnqTBe6d0+Qk2lQBEUtQ=; b=m
	3cPI2hmhe5hC9lykGVQzMYBHrGuUtBaKBX3b3PDp5p+gcvgP1x9snj9bqSgRM60A
	npnPx0faO2Nl+EPpUAS5vSOXXCEas6LUFCBn64NhUTO7uom48ZZfYftzLGnZCTAj
	LtzUaq6dzH1iJJbl8qOR6Osp5N6ebo64RU1Z30eCgRvN8YXm39fe6INPBOD7geCb
	MFy52sYavldvCCnTMEc4Ld85f1dZttLwcdqqumhqWEfGTdZjcrM+P19iBuNTVBiL
	qOIGBRRb7O29niDiljAJe0MXjiY6T1zjmhgtKgAEe3mHF0nOr9neg8yISNGwCn1B
	bGvglgPQ/spxAxFk2eeHA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793034733; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:RlkiVG3xZjI0/UIv77Du/y6LREK/6iZ6U2unRDl/Jl3OWxs
	lRZWj/aLKuxCkYJWDa4W81M+7c721R1pTJ5koLQPdf5ZCckatS+DArqFKI+P8md6
	WWJkCj6/x7PgPKCuuwvrhmEuKRshxEHu06cRZeZEgWGkA4WCgJ3E8YtGbSffHDXw
	r0PaMI8t9B4fMcrmXX36wWdG8xDN3UmkjFjnqSfw/0yn4eoNyBfyJD3f7C70H0I8
	Gy/rWdAsheoSBddadryauR33QjeXvORc8Azc9Evy469r+9wkmQ8KBH3ugN4WvLvQ
	ZoQX+yRnF/yZ91zUlLfgTr6tDo25HEDkCr9F8tw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-disposition,content-transfer-encoding,
	content-type,date,feedback-id,from,in-reply-to,message-id,
	mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:NjjF5I72RcwC2+4ccWoW5S+EHKEscCvEII6NdBABJgg=:Rd0QNiSVptMYykHMLxZ8QpMclorHmpkWRqBU7dC9M/g=;
X-ME-Sender: <xms:64nfaqla3Y1_T0gGn6lOm1YQgBvqZstKIvz_kmKG8_kK0aQpVB0FeA>
    <xme:64nfaojA_xesgJNSkuazJJSILp_fHjMzysAlADF7tSNvL2WCxu-LjVdLKajwpLwU9
    dvfEd7a-wmmUNs11ZLnnm3tcnCKHriorz52g1fVorZBay8nqOAPuY8D>
X-ME-Received: <xmr:64nfai34Cu5W37PFLt2lpW_MgC6hU0egX9yN3JXAW20U5KMizTslMQneuco>
X-ME-Proxy-Cause: dmFkZTE8ZOKPwc5EzHtOWWinHBwzi2uf5XLjKi9jT0n+Q2/8hHEk/Az4FBy+BaF9zD4zXg
    S7yOtBmoLCsSHpCAzmHJKhimZLJIJSfin8UFhO1xIVZuJgAH+H9RthWtcAyMIvL/aW7GrU
    pfcDJY0Kg+JaM+oPKz/gLV+sFVN/Q+RPDyrZnPWdUhzuz7VIjsgAWzMw9d+YYXSRF+Ezpk
    nhF75BvW1D4+YWIZ9mw8tSXJ8mFZjBRM83ZsHx3DhPKpANNDVd3JA4r4HzBG8WaAYbTKR0
    t8crRv2FlN/UxXmh0hAeIgMh/lbKcb3kQMtWtQXbhkZGSy0F+zmf1rTixFGiyk4nwDf0bN
    PQijd6ps8/hCEbxR/vj+M4pttglEEVnSfU/xua8Z7cGAk7tWqNfCbl+u8uOfTYlgRN5YpE
    2Vrk8QzMLmRxH+oTmXMe1x+yTV/iWxw08D4CDORDP8fq7I1429eegPp1LN6wMPjWzwksUk
    Qw1WNKg2rdZEB2oTUqg028qyv33q5076GUQzmqjhhbyqO+JJu+Z782tynz23o9x/2KFw4O
    Pm12/RmGdNbvwuf7OOWICCT4MOlU79OLzzHgR8VaIpyBjThhbfkbDstz0Qdt5FfTvHDcsH
    fR1iPr4h+QtJJ0lCnZNfRvd6dZ0laru5GMGUGqUR9V7ajCDZW4d0lVHDWFGg
X-ME-Proxy: <xmx:64nfavM2JRyZebVj82zcOB8GMN_Vg8Ss00kKstbg8o8FeW5TvbbpJw>
    <xmx:64nfaslAFKEu9BHWSiP2__QDHI202MX4gBWy5DimVV94YF1RZZ8Szg>
    <xmx:64nfaij9W1EiG4T2OpidKyD07LJlqGeXReigCX2rg3AngGSn_l8mJw>
    <xmx:64nfavEOKzypMUlFwlkEiigoQsQ-BZpooV48zHPnmhTH6lhMhpopxQ>
    <xmx:7YnfanDN6h8UCSIsbhn_F7PAJD8llKYUhfVYkligy5QhEpsS1_az97hx>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 13:12:10 -0400 (EDT)
Date: Mon, 26 Oct 2026 17:12:09 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 09/16] mm/shmem: preserve data in clean folios when
 splitting fails
Message-ID: <at-GrQNgF3V_tL3w@thinkstation>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-9-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261026-fixes_shmem-v1-9-703206d5fa0c@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 54BB0100014
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: p3z7y1g5uo1as9mwx7eqiwf3ajm4iit8
X-HE-Tag: 1793034734-692979
X-HE-Meta: U2FsdGVkX1/hKi1s+TsHHK5DFmkqL/4OgC181eZ1zLioLjy/KdyixVEJ/E6LK85wpzqiGccNbQznoINhztjPJANM1epRfGJw73F3Jpd2HsSxEZsnZBcV38D3JAzWZrAiw6KjVboKsy4ztnHLP0YitnGY61gpi6lrK3VUa2FIL81jqJHgRb6vhMv9MaoMJ/JSekrIU7WEAiQjvwQx+ft5r6hjTZ/ajaN2K0EiA5OO8eKNsmrjPkKDBnbX5sjpR5hfp61AjWRqTWgeuzGHTo6x3BYexIxJjfQ5FseNeN33tOCMilIb5gD4BheDBpgkCz2Zkj3VSK/3PzMVolFJfhHToIAUbJBLUlAyiN5mQ3K0TdDUXRDewg6L8GIC1rpaG8snxuZnGZVoCksZo4c4qQ1ZJ9+My6hDQjAbXl60qYSrndnbtnkaeEoS2jRULuF6FPSRjXyfbmJY+qEyQLgs2D1QiLXUn4RbkqG2bhUGbpv6CXWuzs6QTuUtHzuQnqiB+fho0Jg1XEyhjoBuyJ2E5yphVVUqApxvLwNUVF3KgsbQNUsZCBhAJYUREeyG9PjbuptLFODkgizd5yMd3u2XX8Qh2gk1jjeaBGcNQX4njWd+IbKxaBXAtWxYwzPuGFysr8vvbt5CUtn5v4hu2vT8oxOO1g6EC3yt9JsDj0Q6igao7QmW3QmE2ip2wF13ivJdLUrttKFzi2KaK00TvWIvdBpTHHa2P/Ny7SNguhtbsJrtWPkvaltbL0v+dq/yLIum/C0cex+Lv48tVD/UV7CjGVXicMtiQ5Yn95J6HKhO/NS1NywPzTbn7zpTJ7ACFKr6hQhdn4cjDEH5PvJpLOgwpV7THhi/ohyfB5d84XzI6G+CID5jQ9DSNioADY1O24wE4JVnrdnW6dVbHENHrGK429f+gOZhgbHtN0UWIFPtjv+MkDcAb02OlSSu+1i1POilSpxx40K5Ip5dNUucvtiQaKB
 GxlrxRZE
 77piYD6LlrgjsGykCcQ9uUO73xEh/GCSO37aDisGjRooL7q0t5yYg7KE50/LCYGHddpJvpDZe8z6Bm51i/fyEdZV8JAi7F0bbEeEWzpvhcZSUV7rkSctBQHC5M4PzWJhUtFPpJLCEXZLohvRokaAcyepGZsudghv10OzwmFu1XkjwDj6nXD3L7W6lNmbib5cM6Lf5osUG8TreRvIg8PwjFc/eMjzzlQPzehjYqgDCdqg2MntZidedQeC+bJVmStEK8WzZ7lgxYfQfkA94P2nTY9KGv45b4Lel3RE8rovSb1auS1//DBfrzrUh3Tt7v/k8oG/sFOIjMYi6qFtgi+2ffXHScXKo5MlkQRLEQ3jQ5VOjsZl7f39sl4MNH0tqbX161zLC0c9f32I4KXs33dNrk1mC32gEVMm/t+M8dZ0SBlzkyY2K11kYP62cA4wVXOYfvt7UHijNMxS8NGttsjeYPtMv3+XsEjAHUipd/IGWdNb1mmCbvN0Z7nKWFvfvr4ZF9ytqkCLliOgbwvb0toNESfhveDlJJZfDa0qAosCFDR1CMcwIhu2R04DwUoaFy5JAMkJ8LbJDVV4Q04vv5sXzO1fS7iNzaIG5dWaJIFWmuOZObjqD5sGsKCFGj6bA94VJfkkZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:42AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> A shared writable mapping can have dirty PTEs while its shmem folio is
> still clean. A read fault can install a writable PTE, and a later store
> sets the PTE's dirty bit without marking the folio dirty.
> 
> After shmem_undo_range() has handled the boundary folios, a concurrent
> read fault into a hole below the new EOF can allocate a large folio.
> For example, on a tmpfs mount with huge=always, the fault's offset must
> be within the file, but the allocated folio can extend beyond i_size.
> The final scan then finds this folio and calls
> truncate_inode_partial_folio() without marking it dirty.

This is hard to follow. I asked LLM for a diagram. I think it would be
helpful for the commit message:

CPU0: ftruncate(fd, 3M)                CPU1: MAP_SHARED, tmpfs huge=always
─────────────────────────────────────  ──────────────────────────────────
i_size = 3M
shmem_undo_range(3M, -1)
  first pass: hole, nothing to do
  boundary folio at 3M: hole, none
                                       read fault at 2M+x (below EOF)
                                         PMD folio [2M,4M), crosses EOF
                                         writable PTE, folio clean
                                       store to 2M+x
                                         PTE dirty, folio still clean
                                       vmsplice(2M+x)
                                         extra folio reference
  whole_folios: finds [2M,4M) folio
  truncate_inode_partial_folio()
    zero [3M,4M)
    folio_split()
      unmap_folio(): extra ref
        → -EAGAIN, PTE dirty bit
          never reaches the folio
    folio clean
      → truncate_inode_folio(whole)
        [2M,3M) dropped
                                       read 2M+x → refault → zeroes


> Splitting normally collects the PTE dirty bits when unmapping the
> folio. An extra reference, for example from vmsplice(), can make it
> fail before that step. The fallback unmapping on split failure excludes
> shmem, so the helper still sees a clean folio and drops it, losing data
> outside the range.
> 
> Mark large folios dirty before partial truncation in the final scan,
> as the boundary handling already does. Exclude failed-fallocate
> rollback, which must discard the folios it added.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify descriptions, adjust comments ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

The fix itself looks reasonable:

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

