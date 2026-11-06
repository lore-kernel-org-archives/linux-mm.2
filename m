Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B890E606A32F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DYBPV1og
Received: by kanga.kvack.org (Postfix)
	id C7D0C6B05B2; Fri,  6 Nov 2026 09:16:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C55056B05B3; Fri,  6 Nov 2026 09:16:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94056B05B4; Fri,  6 Nov 2026 09:16:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8406B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:16:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B27E51C48D5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:16:55 +0000 (UTC)
X-FDA: 85404895590.01.378BD37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id F0FC140011
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:16:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DYBPV1og;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793974614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbRvJ/bHp76KL1OEmDU1Qb2Rcrg4+B3yQbyXLRJ6Aio=;
	b=nnEhnEeqZa9VfEf0SXNbZADPiCbYPwHf6VRmLDEjDfjIiOeTcZFbbac18mjzdMmowvad4e
	kuFR46ObVHoOtgiXE949bop+54Hwt2gnL3iwY1R0gWKVMNxMYRZ2fYLnkgkMZKvl30e5PK
	d/peZxhNRwPuN1JIpUFJzZNHAEVe4MM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DYBPV1og;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793974614;
	b=qT73OldzU0QXYseghiKEVwfTb0bSKSgSJtrhiFCn8hXoN/TDoQu+oEunfb7mRVV6UvNGrI
	yJIaDmuAREYtGtP6mUqldr8QcrKqcqCcTQnJVsqUTrTHoR6lFalMngyn50bE4nss1LlR0u
	gK2RtGptICYMm8GUAF/YtcNyx+vCDbc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 190CC41964;
	Fri,  6 Nov 2026 14:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BA81F0089F;
	Fri,  6 Nov 2026 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793974613;
	bh=YbRvJ/bHp76KL1OEmDU1Qb2Rcrg4+B3yQbyXLRJ6Aio=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DYBPV1ogE/bLXFI/8qugY9boxyNnRkJH+vF52rmefXvV9/QtYzE1/KEfal3C83Lk+
	 1VGRfkAn50aP4TDwE/JvkrNWozXJZHTH3kUOrLzMz5r6H2Si+PQZ0TqT1tPm3h1lC2
	 JC2q3PMIhh/mDUYhZDdIn46r6BLMibxIE/GkzVArcyXyKz768NeS+D6Vu0Yag9jgrP
	 mCWj1YQE2jhqfNg8Vh/spK5An5+Ri2gm0l/tfp/l80FnNr+aXoHb5dFeJc8J7qpjbC
	 nTeymdjQymInKOj9IF1oMLL08Zf9AC6xLU8e5d9DdWtvOSiTXsr4+NVrfeT1N2vMzq
	 LBDliO+OLOEAg==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>, 
 Usama Arif <usama.arif@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 Hugh Dickins <hughd@google.com>
In-Reply-To: <20261019230646.3510790-1-joannelkoong@gmail.com>
References: <20261019230646.3510790-1-joannelkoong@gmail.com>
Subject: Re: [PATCH v3] mm: unqueue deferred split folios outside the
 lruvec lock
Message-Id: <179397460737.8873.12735484060049239618.b4-ty@b4>
Date: Fri, 06 Nov 2026 15:16:47 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F0FC140011
X-Stat-Signature: bjsgwnoyociud3ctdiczfaf1uunq6pum
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793974613-582044
X-HE-Meta: U2FsdGVkX19+sLHuWX4fLcOkDKNdOL0lPCfYL+j93NyPPi+B2nArI2og9Aby++dkZ2ZgX8o8gW3Ave70g2qB9Qzw6TGSXCV0AM5e0bkm/D3K8vfsggWhvY4qynGcovTZ8GyWtfO/f+ganfPWQ7bnN6jROplXPASOh4KqpA42c/8xlvZFpqDTfug1y8DhlNNrk4KhH051shYwgF0tHPRHwZPnWO/3Vqw1STcI31PHZCErLws043ndpTbl+tvEsV27gELi7Fm1r6NbXjiZ1sxIfBtIlEjuI4kP/K3t/g7UozD2HYqSUZ+rOovwb+ivA25jns0d0J4GRWO/Qar940M/+lqXjRix4RQyyKehLUZsXV4pdbhodVun21pYHYPRND+zvOp6tleRjk60RnqY9uyrBXRFAl4oUpEBwkFK8G8xyjqoh+4pW884pCDY0nyipm2PHn8a9Nslj0yCEfq9W2bR0u2dOQCpsiSlmXMlsMv3ocnwpXXm24F1PwDrbjT9qg8g4cynr1PS0limVXdjwn6xwIMc2TBjwWiKBuwn/FitDOy4mpZpWZRZE4g7b+1mZ5UMz1aEBlpOYr/la3ZdM041OxG3yEAjsxTg87R6Ysb1q4FiZZ7cqbKCbUUzyfxZ6/Fsi22G6tLHiOWdE6jyAXyJPckEIGEIVP4Tl7nedRF03yS1YCs8tepUHcI9SpR1cmmCAbBrv/AjhNXQ98QWgMTL++0+zjiZgH+bdlqhDuqL5HQ+JzCot3PkLqkLIMEYSsiG0V8DS+uDUah+HdZBDTnuaTzq+Mp6GMqFhruvSVAhG9iBnMFLu02cVGGLqPehqD93quSNZKVw+svDARNah18oMK58QyhS8Qbu6hYbjv0TDleh4l0bL68bGSNsDtOqyLmWauw4cEPljTO4J/oWihgX782/A4RuzvYeZcYmEaqVCju7qONhrMhnmyzHjAyekbtrArItM1Td0KPh6Xq0dJE
 t1VUTfXr
 NQdmzfuo6QgggEjh3FgHcfjQDQakW8FeswSI1t0Z7ZbZvT1mLzX0sQSYYKJ4SPrenA/WmwSFQWRWDlsNmZSbz78bTiymUZq/CdMiDPkMicWkQqZMFRI24cLtPFTu14U3e3TZGv2pT5bizFXdtqysVIBlzYzB/bMOn23wu/R+N0332qjIfXIFufCpsgaZU3GLIBUkHBHD/qui6ImJdoRUdAtqexM3/koG7u2i7IgMRcz+PN60WREhh/jIU7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 16:06:46 -0700, Joanne Koong wrote:
> move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() call
> folio_unqueue_deferred_split() on folios where the refcount has dropped
> to zero. In these paths, folio_unqueue_deferred_split() is called with
> the lruvec lock often held (move_folios_to_lru() always holds it and
> folio_batch_move_lru()/folios_put_refs() usually hold it for every folio
> in the batch except the first). However, it's not needed to hold the
> lruvec lock.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm: unqueue deferred split folios outside the lruvec lock
      https://git.kernel.org/mm/core/c/8c38bf2a

-- 
Cheers,

David


