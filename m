Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E26BA606E46E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NEWiJYgo
Received: by kanga.kvack.org (Postfix)
	id 018596B05D7; Tue, 10 Nov 2026 08:00:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32116B05D8; Tue, 10 Nov 2026 08:00:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21756B05D9; Tue, 10 Nov 2026 08:00:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C599B6B05D7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:00:00 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B755C0144
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:00:00 +0000 (UTC)
X-FDA: 85419216960.30.D302548
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B88AC80002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:59:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NEWiJYgo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wnyy6heljadaRgfxt4wb4lOJGOZWSfcR9An36HYEP3o=;
	b=jcjDENRmooXnvLzJaFMPENeASNkFvdhNI0nxVLJkI3RtnzWvXE2hQ5yqU3UOt+ZVIJKgBR
	rIjSOK2b4d5YxEkGY9Y0SSerS+ZtI1/lbEezKh/uC25ejAu0nGJpwPoPsRwrmdI1zT8d88
	30mkEciWKqpFryo94Zkdf+v2bYNW3I0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315598;
	b=64nDbBqsbhhAIGjGvJb5S/qpo0cFcVOkwZQSk+I9lFgYdDdDIq/FGGwgxARuOGs9kdmg38
	VNnuhj0ArJLcL3MtXL81Xv2yPLvT3BKoaEEsnzbpI5Fg3oWM8k+dNbFLj2QG/jsqb3F3p2
	KeJSmDFFQEToVnTimV1D78+1aBV7imk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NEWiJYgo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C414163942;
	Tue, 10 Nov 2026 12:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B218D1F0089F;
	Tue, 10 Nov 2026 12:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794315597;
	bh=wnyy6heljadaRgfxt4wb4lOJGOZWSfcR9An36HYEP3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NEWiJYgoZ3M06iOwuPgwQNC6xnFZeGa8MtJTqrAh7BDOeh3ctwW7p34DOYRA52Lj9
	 KYLHjX3Xy4oCgODSgpfn+PM9Ul7YUdFwLrvJ6hH7IIwo5Rr+KID0ZTC5VYvpqJyCr/
	 DvjcGWIj3rlMcFBmeZSzhzlXDPfpT9U6z//Fw28JowMWY+8TT6nf6IDBCV13KEclgB
	 toyMCyhJVHOwm2ydP43nBNyV8BxJpn1LYc4bwBM69mWHIVxJlZtakBcxY7MZznfMO2
	 KIkWuxKYlIPOB6i37L5tkDWXMciTEa2O50u6im9c3uBicYDiGE6sUDfCQtnCXec2uj
	 oqdAR4Ap+LMiw==
Date: Tue, 10 Nov 2026 12:59:50 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Seunghyun An <san55@wisc.edu>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Suren Baghdasaryan <surenb@google.com>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/rmap: use vm_pgoff for anonymous VMAs in
 linear_anon_page_index()
Message-ID: <avMS8RyqNQ89a9hP@gremlin>
References: <20261110000002.1834454-1-san55@wisc.edu>
 <20261110000002.1834454-2-san55@wisc.edu>
 <avL5C_w-wo6bJJTj@pedro-suse.tail5790ac.ts.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avL5C_w-wo6bJJTj@pedro-suse.tail5790ac.ts.net>
X-Stat-Signature: fcaw3ouuy41h5w6oknky98j1dkc7kxt5
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B88AC80002
X-HE-Tag: 1794315598-544443
X-HE-Meta: U2FsdGVkX1/6CjGO69ptzLrt8y2IArY1/3diHipArg8wGfwojTb+yfS4MzTqYu4EbO7dcduxdnVjxZ0lFk+HwgNGa1B4xCUssVuLWmshtSMSwcUn/6y9BDAFfwgPRky1uzfHnfXi33wYi7IdNT/8q6N+I45nyEepxMjzaaUrR9plprVOdEtQiKgcrt3OYemG8/vTE77dGm6gQkTvcu535bk23ybkSFoooG77Z9Xwl7wGSZiuxPKkTDRJPKXt+qfFsP9lvAxKWHDiNJ5w3LxGxHAB/983R84lGsLwB0zyBBAsjgfB27bCZ1GcKGviFX2XX/0Hj34ZlfhNNkgaUJkZnb67kIHwyXMDrXge4JB4YIZ6d8H3/iNZy9tB70lu6pCbsEbbUywxoQBCItp27Iua1bhNMzVD8QRn2r1b0JFatsmmvgdZabH7O40gi45EBL0/U81z0qNro1vNdBJuu2Xq1fZgYMgchF166MlODvuZg3M0kU9wXeWAkw3RfIgmnQ9z61vl3xoVCJsFTjgmyt/+I6nkVmZ5ie1eX+UiaCeM1/n+wH8EJWWlhfonj0efWtMrWo4T6wn0bayPY5dED43FMadgmHGQZUGzgJ4QVd3a12tnKc0i6oiR1ZowAVv6/uUrBkpP+uFhFcfUTQMGxSs5niZQRMqnuPSzOSMCTrLm2TYd/G7FivHtcG19eVsWnQa0hGqdkkMIp4EvblwR1xcVUoYkS/6DblGVs/0xAgg8taSUEGFPw8aruB6lNjepizq0k9S1pGMstANbQBXM+dIV++H+/kA9swgrTw/zzAosaRQ6P+v3hSU/i+7sSrQibK2egjtAMCzo1JLvYjxd5RE3b8KOveGKzgwRWophDxbh+yzxVxwFbFDU2xriLCxupFJffHO+S/ckSpp+1D/kXeZUHtN5pkC+iRaek21EB/ae0WOgzCYV8lyBayJop7o3j7EMmpeDm4CPR5BDA44CEjz
 keCUaKM4
 EnuCayvylttuhyu7VL/EVF84G2rK/EfvaWYfxJ6a+g8WaYy780fJO/ThDaekh8yDaiBJPNg3QZ6/dkeWrRPBXMxboFJR19M97aX5t8BFN/XKhEtF1M+0kpChaIi2uVg1Frp+JScMbxk5CU55d8+TJFv1iXA6Af2HbBMk/G6NnaEpqHGnJ9vByB6e0oc+JOIhTEmMVotEQIZost7CXxjWCyCu+H3W9T9txKpazJg8IlLuQBh/jkmZjMzDxQ1evGD+r4OS026esF9LPLbuN3SoszZjNyPY6y2y+kuI2lNP0e99Tu08=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 11:25:13AM +0000, Pedro Falcato wrote:
> I trust Lorenzo knows more about his plans to use anon_pgoff than I do,
> so I'll let him reply. A comment though:

Thanks.

I'm taking over the series rather than replying further, as is general practice
with this kind of submission.

Will post something in a little while.

>
> > Measured on an AMD EPYC 9634 (84 cores, 12 CCDs, CONFIG_DEBUG_VM=n), on
> > mainline after v7.4-rc1 (the base of this series). Threads share one
> > anonymous VMA, each faults its own slice and zaps it with MADV_DONTNEED;
> > faults/s, median of 3:
> >
> >   CPUs                      base      patched
> >   1 CCD,   7 threads        2.360M    2.369M   +0.4%
> >   7 CCDs,  1 thread each    1.738M    1.982M  +14.0%
>
> This is not particularly surprising. CCDs have their own L3 cache. I'm not
> surprised the coherency penalty is much higher cross-CCD.

Right. And a lot of these workloads seem to work backwards from the problem
'let's find the worst possible scenario for this, then microbenchmark it,
surprise it turns out it performs badly'.

Even the real-world usecase (no citation as to _actually_ encountering it) seems
to follow the same pattern.

I expect we'll continue to see more of this stuff over time, sigh.

In any case, the solution seems to be the same in general - don't do this check
in non-debug.

--
Cheers, Lorenzo

