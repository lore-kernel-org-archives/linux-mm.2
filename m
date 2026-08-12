Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5436C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94996B0163; Wed, 12 Aug 2026 09:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44046B0168; Wed, 12 Aug 2026 09:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B82596B016A; Wed, 12 Aug 2026 09:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 983876B0163
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:43:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20986C0397
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:43:09 +0000 (UTC)
X-FDA: 85092733698.10.49082EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 79989A000F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:43:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NZGVjU55;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786542187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NdUfCzcf3wF1p3vo4sFhy9PeaTxbdEqGqIMoxni8TVQ=;
	b=HgeVQ+YZDEVs72J3mQTg8/80mdVe56xsvhCb0asrAx2SEOBcODy2tLhu8ayMFRWmsVkBMu
	jD4Btho9GzoB7xD65rWZN5WebgYYfA/Cs14cth46FTbtj/sj0/DF4JytawMEtuTcF5rfmP
	mKLswoWtC/ihsCGSUnWhPyPvuWZWmKk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NZGVjU55;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786542187;
	b=LcDoZHY6oyC/RHZo1ip7XNWQFZX4QJwcxRDP4jMqbdL7QVzAU5Fz63OIH8Ff9RrtpXfUmX
	3R7/m2ygVw2K+LTsw62uTV5o+bcz/Cy7jswyIGT1tEUDTF9k7pp24cmim6tQErTsUMTnmq
	0DypXM56pumVwN+QsqPfcJDFnDG6tyo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1B11406C4;
	Wed, 12 Aug 2026 13:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A381F000E9;
	Wed, 12 Aug 2026 13:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786542186;
	bh=NdUfCzcf3wF1p3vo4sFhy9PeaTxbdEqGqIMoxni8TVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NZGVjU55FQi534PAJGHVOYuF8jMET4sFgF7el1r7GfrP7y5uoqTNaTldB8MpRpIzQ
	 sO87zUQJLpBMuqR6LEwIAEz0YIj2NOrCPQCXSsbbLHSLK9umZmQN0gHwEJ/koEHrkV
	 olSRdM8zqKUFF7XlLaEVqaXoHg+OwCqPr8l/3tFhBMfnHjY3iBj8sQH0r9K9oLXQYv
	 nBMFjq8yRkvprENQktFnMAOFEZhSdEqm0ttSDUTF9SZn4jBKMc7+3eYWcXpdXTnN3n
	 4g8EJ2F9oFlA7sHfmeMmlROsFRtvqN37j4+9ht5fmFKWeNZMOVN7PglHElU1bPXbeA
	 /YZr2noOoYVnA==
Date: Wed, 12 Aug 2026 16:42:58 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, shuah@kernel.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
	peterx@redhat.com, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] selftests/mm: emit TAP header and use TAP skip in
 mremap_test
Message-ID: <anx4YviUtQzP-cGe@kernel.org>
References: <20260812120821.523860-1-husong@kylinos.cn>
 <20260812120821.523860-3-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812120821.523860-3-husong@kylinos.cn>
X-Stat-Signature: jbqknuzurpn5wbo9b6qjkk4i8w74pb7i
X-Rspamd-Queue-Id: 79989A000F
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786542187-329445
X-HE-Meta: U2FsdGVkX1/HEuo/CmGI8e/1czxsAyFWeERxFhnCZgunhFU3518n75pgtbUogehvQaMxiSTPgLdkWRrWYWje7sK9qVq7JlDFP11nxpulcSYA3p4BaMujCV/HjKBur/933+mppoonfIZRbXlqPtNFNNlPuax5ZrqQullXVCgjLnTHxpqvI3KdmSFf8l2YzBU7BIOxN3MR2t+06NMEflZiwhtmZwN4lx4Ujjinlby9lPi6D6zL+9uD1Ka0YOAEi2evdoe3Nj9GMFSnpJt1M4vLluw674DY7t1wH04jlU/yQ1FO3TSTYthvR32WCOmU+XnFgsTzXGkqodTYYEQrwZvC4xcTX3otSMnKyGhsT+DxYFaMlguO5oDrSFLliUH2GW2eOSoPkw86KVzjYXxgcDp8SIM1Ri+U8SrfUxFGF6n+cc4EZicWnuMjuaaQnV8qzFiCyc+6SZBLoktY1oC699dDVcwfduLQOKDm99hpSKIBPiDwdh67NgC1Bx2yhSV2gEeXnlKEVxDo4jZWUSzONrL03sN8eHF38miZigGAHhBk2ZErFreuxHz2V4cmn6E0+iB+VarmbfGjZ5F14wLYqwPmi06kFI18wGa3o4+CNYdJqPCKuaVFdfNcabffVdaYHdjb6WysL56Zy/5uLaZeHITqnUcGIj0LuH9cUjEuaO96V6GV1qzdtEDbggpmSNZr5HDLQJFZ+QuQP42nrCKQewLpFI8nh+vD9jp5RCQN51wJNXkov0SBF1TdNpXs4kPtk+FGjpDIfovvJ64F8odF8WZFvZXveP610GnBmaiJYlFs05yqPmSfSCGfd8Rretk19W25jAOgusZ5fkRbqypgYOj+EXr1V2I/aO97FOce8SIhWheOSYw0pr4dgoVa7tRSmFK8aBrtOV36Xm2wHU1f41H9JM97YfpozEVNZnPr3QvqjCfMxkwQp/hC3iSlgc9ohLw9wv96yNDvOtjmPQpygdC
 vsY0Puu8
 ZhC3M8kZkmDGk2fzzjp5eVl2yNd/kWtxEjCsbSlXrshA0T0Xx1xpt2R8D8Knf01nf+PX/mWtNY4g1fBA//lIH2vrUzrtv2ZHJhOU6MnbCNENnAIvXe/Z6bh3+H3AhgWu59EMAngoD2e78tQhr/264xA8Q2jPMqa2QYJ+T3vqXh9G7aKM8+SQCZg7GFgoIWuU7WC7xXg+t4LzkcWnVsLRHonpy0C4j+j++M3tjMlJ6TMAvdO9xwc6WrJfNageHNuF9Xu3glZWs3CHv1n/U+XoR6tVBo1vmdILWLGXsZN4odLQ7QS5HOVhF1ACTihNfCrgt/lv4CiBEveV+YLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 08:08:20PM +0800, Song Hu wrote:
> mremap_test calls ksft_set_plan() without ksft_print_header(), and its
> get_mmap_min_addr() skip path uses a bare exit(KSFT_SKIP) that prints no
> TAP line, so its output is not valid KTAP.  Add the header and switch the
> skip to ksft_exit_skip().
> 
> Signed-off-by: Song Hu <husong@kylinos.cn>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/mm/mremap_test.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)

-- 
Sincerely yours,
Mike.

