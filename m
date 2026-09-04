Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A44EC79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 08:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3914F6B0088; Fri,  4 Sep 2026 04:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341176B008A; Fri,  4 Sep 2026 04:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 257666B008C; Fri,  4 Sep 2026 04:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE71F6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:22:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46BF8160A78
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:22:04 +0000 (UTC)
X-FDA: 85175386968.10.DCF3621
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B0A424000C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:22:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OjIgCijT;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788510122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViqxEg2nic21/cC+OdaYhidCKvzIE/91TrHsQDV+MNs=;
	b=RH4WtLicAS//Ju1/A0UcG0n4C3eaa2fYX4bIZzx56FHKsuwOwCUp09BeC8BIIEU8v7tnLY
	teix7yERB0k9xu22IBozaaZg9xxmRg+YrTYfjpQgFpr8T6mPl0KnhNv3ao+Xxg9p+ZtKVX
	uZrzrZJCnc78dQgd3B60EM/9zSaO+mI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788510122;
	b=5+USQwuleGnkAyAkqY3qkCbmItu/1AEYJl+422ggFBnIDek7ABKcdgV8AtBAsoNvr4Zxjh
	foykfOgFPav4cPbFwe5e/4tL7Fu06aGzDE/yX0ILS3FGWH7IFQcL8462EcHs19vH51HXOT
	PNjww4NTYXIDbQYtbT1FoLGp1i9WwzM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OjIgCijT;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D05D60211;
	Fri,  4 Sep 2026 08:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079581F00A3D;
	Fri,  4 Sep 2026 08:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788510121;
	bh=ViqxEg2nic21/cC+OdaYhidCKvzIE/91TrHsQDV+MNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OjIgCijTg8xubFCjXgjFEtmB1OQ+cfvyNFkyhkMtj8Y7nIE6k+3q/RspG0eSdf5bs
	 2svaQZbbt+haYCBqjLTdpFHywBlL3Dv1AeDUK1p18/QTS9oyZ4cnvAmfa3nBgsmhQM
	 tD6TyWTRFWOZXPJgDpzltMHLopfSdJDEIj0ME57ePoF44PluyT27F2LO0m3wSN+vTx
	 wWntQnd3eH+IaFBkfmKkYvd1h5gGdIK9gnQOyZ7ZeyPE6KjCBYBxL+XNERadmabR4i
	 RSjSNiRJzetnE1zaqPaJTtGeDy75H3nSCS09VbBvslDUSLXNf+yQesncXhmSVvL+5F
	 ZVxAtzIYZMaVg==
Date: Fri, 4 Sep 2026 11:21:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] xarray: fix index jumping backwards in xas_find()
Message-ID: <app_o87YogZExbwm@kernel.org>
References: <2992424b-2120-489e-9010-f45f46ed52c8@mail.kernel.org>
 <20260903112251.6114f91af953412d2355e5b3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903112251.6114f91af953412d2355e5b3@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B0A424000C
X-Stat-Signature: qm85bqo9qjxne6c9ary6p1qh6hthwgdg
X-HE-Tag: 1788510122-688765
X-HE-Meta: U2FsdGVkX19D2pNR4XbKbEYWrD+qKj0tkbv5SY+tIQtEymPk8F86UaMWJpXu8w79UJ6P5wOeMaJB0SiiNj+Iv4oMj8SGOom+J8rZN4StfJ3CgRTrnbYHlyaOlsdpzCc6XT8yj1ELPgPSw0Kn//dTpb1wFYOVK5I6v7Rqg5FYXB4UUqo9K8xzp2EWBXJdYxr5W41xBVjnAPku/0ZtG8iwaOy/tBhbIIAvV+ImCgP/IyO3B8eVZ/GNZIj/G9ZOrLy1vFsMB0RQiMJzKKD0crhrAuwvEB4ElD4Ne6j/qrrxOtyRtX3/TwqVPM9aF9ZcX4pYBz8gi+oEFJuBqJzNTdPoWgD06HL4HPQNHShbvN+MmAeyG/x5yMI47p+/m6qjzM6uRzKlpAAHTm/iF7nITNKp+b2UMrnfpqajitdGgEdbFoqiUO7kffA6YXcRZpc6eA/AuI1yT7HSgsF6v/0jz6fCmJIKArmFzLElI/6FyTO5DfD+kjlIOgcPs2U20OW0twios7BtPR1zXbbQ8VaXfnwh4hIQKEPC1q1CieW6LKuiI/8rIgHz7ba6YxdEn181RsUB5kKS1Ncrs2amn+gSVtEt7SymCUjnwBffJvsqpw4ANUtxoTOdmtSAzkvoEVav54QHG2BGpDf5G1aP58mZ7JGautGQfx5f6frbpbTRJmk1fwk5ZuSpbSoXZKXFG9zF4gi/5Vg1rQUrb5TePZcBSawCUwcFB5Vf+0GgEpaOKXj+riqpeC40p+ndWobzEwTULUQhcdjPJgxS9NdwZq7YhKuh5VLXBzptuVxsPdISwYw9fSKPxLpOvSq8HIkdrlcLNKjoomqSt6YMYba2PGx+83/EisBSl/U+4LoEL4VUHaP+tpM6zggqx1n/+e3D1p84wokCOiY7Kn9h004yGzCAzOkCuHnYPEoi7OO9VXLlgcn8KpU7Aej+IVNIv65LhBewE5VdAVrvTH/d0y7eW3z/w++
 lYiYsgHH
 NVsGFkqqw5xUCoUGs9GdEiZtqFBw0+jDMj4UFmafef3JrTIGeh5dwib6JDD4PlXoT32+9gWejJGM112chgM0oVV9UUX8nVIboemZ8N0Mik2ZTD32f7m5UJkQzlJdfuOyO6HFShTpDkEExagdztTiNez9ud/geYie7yv4nhPdB5s58MtRFvk0+7kMLPw6kectVZGdcMpwxlokvB6DuHOKh3+71BiWT1syYYrqRq0Q+yINH15PQOELWQy1QCB2b8T0euIaIUDh82/XPUNGmrNSsD2VCZ29hD7l+EvWnrPAI2YoeTIy+dFDzX4wq6jD7knS8mv6U4L5pLA3XoIdJIFOcbvRo9gxRoQ+B5PfnJDasKSgH87e6G/g66QMANjVGhdIng72VnHISfj9rSsIt7j+d8ERAJwqigq3GjYHhoFqPrgzxasIa2n+Sod5Gk7KQO0wCtBCaC+7Lu+rva9M9qSLa8WfJfk+3tiJcz8DXTsZSXi2WKTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 11:22:51AM -0700, Andrew Morton wrote:
> On Thu,  3 Sep 2026 13:48:55 +0000 (UTC) "syzbot" <syzbot@kernel.org> wrote:
> 
> > From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> > 
> > A bug in the XArray iterator xas_find() causes the iterator's index
> > (xas->xa_index) to jump backwards when iterating over a multi-index entry
> > (like a THP) that resides in a non-leaf node and is concurrently split.
> > 
> > When iterating over a multi-index entry in a non-leaf node, xas_load() sets
> > xas->xa_offset to the base offset of the entry, but leaves xas->xa_index at
> > the requested index. When the caller subsequently wants to advance to the
> > next entry, xas_find() is called. xas_find() attempts to synchronize
> > xas->xa_offset with xas->xa_index before advancing. However, the fixup
> > logic was incorrectly restricted to leaf nodes (!xas->xa_node->shift).
> > Because the THP resides in a non-leaf node, the fixup is skipped.
> > 
> > As a result, xas_find() simply increments xas->xa_offset and recalculates
> > xas->xa_index based on this new offset. This causes xas->xa_index to jump
> > backwards. If the THP was concurrently split, the entry at the new offset
> > is a node pointer, so xas_find() descends into it and returns the folio at
> > the backwards index. The caller (filemap_map_pages()) then calculates the
> > PTE pointer based on this backwards index, resulting in an invalid memory
> > access such as an out-of-bounds read or use-after-free on a page-table page
> > freed via tlb_remove_table_rcu().
> > 
> > To fix this, check if xas->xa_offset matches get_offset(xas->xa_index,
> > xas->xa_node). If it does not and the node is a non-leaf node, set
> > xas->xa_offset to get_offset(xas->xa_index, xas->xa_node) before advancing.
> > Also add test cases in test_xarray to verify xas_find() behavior when
> > iterating over and splitting multi-index entries.
> 
> Thanks.  But the changelog omits vital information: a description of
> the userspace-visible runtime effects of the bug.
> 
> > Fixes: b803b42823d0 ("xarray: Add XArray iterators")
> > Assisted-by: Gemini:gemini-3.7-flash syzbot
> > Reported-by: syzbot+b72767277f29b6407083@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=b72767277f29b6407083
> 
> I see from there that it was a use-after-free, detected by KASAN.  I'll
> update the changelog and I'll add cc:stable.
> 
> I'll queue the patch for testing while awaiting review input.

The testing shows there are issues with this patch:

https://github.com/linux-mm/linux-mm/actions/runs/33815757662/job/100847425973

And since it's in mm-unstable now it breaks all CI jobs :(

> > Link: https://syzkaller.appspot.com/ai_job?id=a01c56bd-74d0-411c-afb4-ee6f0cb6cb61
> 
> 

-- 
Sincerely yours,
Mike.

