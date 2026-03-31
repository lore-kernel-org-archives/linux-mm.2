Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D8C1061B2B
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 03:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273226B0095; Mon, 30 Mar 2026 23:33:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224736B0096; Mon, 30 Mar 2026 23:33:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13A6B6B0098; Mon, 30 Mar 2026 23:33:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0234F6B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:33:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 934C98CAED
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:33:22 +0000 (UTC)
X-FDA: 84604937844.09.61AC06B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0ED3110000B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:33:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sanwzxU3;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774928001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AudHXLEa7EjLg5TUhCRAsGbURMZsQtWgd1ggUbZWquY=;
	b=izg0bkyrBq0Wvwx036F7MbIyHi2VBl7cmLsYl3x/KJrWV1ubIrMIIiCih2mYKXt/aPLUAO
	zEZDUdO6BcKEIXCSPXuPRIjPD9MORvghjZXZdjQKpQWB+8Tlk2Dhl6bOmQqRPvajB3gSzQ
	iynAKGt0JoMDE7kcHM8HwyPIsMMAhTc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sanwzxU3;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774928001; a=rsa-sha256;
	cv=none;
	b=21io8894SG3mTFLLV4YC/JZpnw+vHuQbEC040mVMRNTGyjyWRKgdCLoqIbGLAa3p7l5xah
	BcQGdyyVqWCHZ4bTTZbxFUFt80O3rqKIMOefNcuilSjgBw8agChSbF+76v5UU3Mmlgvuy5
	rInBOyVI1Y306nrsTKhNTlAEfkvoP/w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 73C606001A;
	Tue, 31 Mar 2026 03:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB6BC19424;
	Tue, 31 Mar 2026 03:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774928000;
	bh=GJTZklG1sKmF/WrfX8qINx8zDJviAcgKqqdK+YrWwGQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sanwzxU3DS9SwZaOPuydSXSU9Pk16mt7rrDRoYhsMp9Okbj/gYJPVBAfRWia9b9Mi
	 wCGflSfwtRHBB4zKWEHDat5VETvwzfrA8NwQB25Mrqwlz9JVqdnfANXwyJVprS05QF
	 EGB0S/NYVdt2FSbX3VB8UAYTq8U/8kZSJPbKuH0Vwsbo8EkWliF0blYzIPH124vaSh
	 g6sNUyYvpHrPFrkS2sCfReyXu/FimdZjvsgJ6DHaBsnV74g7aBJIWUCdhHvWjs0Ddz
	 5GeJbcT7uXRrAE93lS59cdUtV0ne2sus6eFYwPAzEbfjnebtsbRZa4jwBRqU24HLBJ
	 kxfaTlEGYJe0Q==
Date: Tue, 31 Mar 2026 12:33:18 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 01/15] userfaultfd: introduce
 mfill_copy_folio_locked() helper
Message-ID: <actAfiUYvUjUNiZM@hyeyoo>
References: <20260330101116.1117699-1-rppt@kernel.org>
 <20260330101116.1117699-2-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330101116.1117699-2-rppt@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0ED3110000B
X-Stat-Signature: jhwwyja84uh78k14ppdbr3i75shgpxx7
X-Rspamd-Server: rspam06
X-HE-Tag: 1774928000-813154
X-HE-Meta: U2FsdGVkX19x949NIaATEc4HhMvt4UxZB1WwqgvVy7K21dydIQKjIlert2xqmGDxw6SxCuyR+YdQXJhqN0ANWT3zCSXGMRgk8TEtX+dM3sWZABKoaaVN0mzJmnFptgttGpKHre9U3/SPZBDo7llWyCKEz4Y/uogp6Ajs3VHFSAc6gs6KN7RW6bIFn7oS8ABu7kIgngDpTrWecMG8OJ+Rg2qJ+tgpJeLFJmt0vWYn+FDNxjklcI0O4PhyQ7F7Hw/qHjOcSqAWiodXqOm/y9v4tGVZtFez+usylDErxOZwE2p9tAqUpRLm9+dWr1MDSYmfM776tGnmvDtHhdgdjnt8KZuxtq5Yz+JXWS6X1yKPReWEo+ppFUftNW2d/rE5BlxkYGTFXaJ+BYZVeyA64KePk9Dfrfo+tQg7owk1ges4qIVfgGTd7SMXLOVP710rhRvMUpDBv+uo9JADY4VdVjppxs/27CK8NEAItwj6JlWv4HSJIlDnrvre8H2gyY8PCf45I+0qXf6l2VNvxQFe+OW6/NLkWyIA3ps6/OVDbMh/IRC9Z2SCS9rRr/F6RFhW7mD+tCMP1+1+cL5o0N7iP1sjviP2C8jd0SBp+uhD5dD61/NXQDt+iEp7jztiBkkK614jxfxY5rcl/FfYlluamiF39a6M7+IBdEmzYEECLzZXBvwlVY3MPCERKxXMmAIg1ulo8E+Em5HaLwoerf8EivH1WzoUAZOQRzamZC7PcvWQbcfwy2+iBjUzD2/uDrAX1YXpFCIlTqDLAaG/sK8ktoCvUefpJo1FVNBf+OuY0iBSsspyIpbhIaZLvKXI2ydDrhVZrxjXihN/pGrht50VwNr1g8kykmSlH/Rt10E3RqcOt4BPUrxvux0q+fcyxjfxHd76oqzYl2ild/ACThFdj637PxQnLOKSBv/dreWfX9+Rv1OjVe18OmIHOG+1nXdrKOMMK9rysJ64fJw/T9CBnM5
 adFNY+hq
 qhES5/xcVEsT40Hd66ohhxsOizRGPkquqAMXHx3EpuSd6PjX1iufWBIcBIgsbaQ1bm4kSbI5QVx/5wBxNRwsv9oeQM9Oy11nasER1EmvJL/isxbq7Dp5yxFR8q8e4Br01pMBxYtfJDaIapHtN8BWDnEtX0f5xu+BlSOvTy2EOMrUDjmU6Gd8tyOc/E3nw3qIOxWyvuS0cC45cTGqhK0TAyJ+dTUaZ3DgNxZqxGIk+iIWTTZ7VcSHOkPM1GOdgbrl6ZU8m7M6d6rLoZJo6UauCeYex6h8610k1O5CBPB411lHoAW1Zxepe/gHsUpmYEQoDlewuSaZ4CHGSYgdGKECicvm1TQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 01:11:02PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Split copying of data when locks held from mfill_atomic_pte_copy() into a
> helper function mfill_copy_folio_locked().
> 
> This makes improves code readability and makes complex
> mfill_atomic_pte_copy() function easier to comprehend.
> 
> No functional change.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Peter Xu <peterx@redhat.com>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

