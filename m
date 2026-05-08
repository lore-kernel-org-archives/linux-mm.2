Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8712BCD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 22:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11936B02A6; Fri,  8 May 2026 18:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2A36B02A7; Fri,  8 May 2026 18:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9001C6B02A8; Fri,  8 May 2026 18:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E61A6B02A6
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:01:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27292140334
	for <linux-mm@kvack.org>; Fri,  8 May 2026 22:01:42 +0000 (UTC)
X-FDA: 84745625244.19.AD72604
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 60A30C000E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 22:01:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d7llvSYs;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778277700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2ADiq4g+8a1rnKaYVHRdvaJwDcms5oMNIUp25lNz8E=;
	b=Zy3oPydUIbPAgr9bETfl3Lkst7febSvCX6RVrhKUZYZ6w74T0EeSyWBJdcG+s01zf5I5Jx
	OaPmnE3dGBaxZr+GzmdlwOO1Chxeq88nYrQXTnGB9mJhMvlNYQbtydYot8yc+APL+XorS5
	dtBMNyIyeEF5kku121k9jBPC2gZY99Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778277700; a=rsa-sha256;
	cv=none;
	b=muQ9hol1xi6O9tVFw68XZOtbk+DgaJYY+ZfJdJ/IPxO1jEIyWoeg1s1BS3MTqQ/WYYT30d
	zTVZj6jQ7eJuVjrq0Fa7qyiyBmuAMsroJ2Z2IVEVAzIR/VHUMoX17DrbqF0/f2Pull8+8i
	W+nSnP1uZlI257PLtRY5DdcBEl9ARfA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d7llvSYs;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 28F3A442E0;
	Fri,  8 May 2026 22:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1946C2BCB0;
	Fri,  8 May 2026 22:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778277699;
	bh=TFFGfaDzh8waYoEt8jLINiE7oLKEHd+S3uUECMlHZc8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=d7llvSYshRamFmij8qRP/sZwuZRxJMwDTmNXH2TOgPdI83O5BMxAg/MHz/F6aRSwU
	 DNeZIqkLczaxFw1c14trqCNdUxq3DthDiDEtT69Hx389iMlb2ylI9FLdYFeBhWjVmX
	 dLY2NGRKARC4Wd9QcE1eis13rFD4688lfKF8Wj1k=
Date: Fri, 8 May 2026 15:01:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonwon Kang <joonwonkang@google.com>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, dodam@google.com
Subject: Re: [PATCH v4 1/4] percpu: Fix wrong chunk hints update
Message-Id: <20260508150138.3c90c36d08d140fdb7cf55dd@linux-foundation.org>
In-Reply-To: <20260506142100.1289509-1-joonwonkang@google.com>
References: <20260506142100.1289509-1-joonwonkang@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 60A30C000E
X-Rspam-User: 
X-Stat-Signature: 16s8twzcoqi5qdw4wukoobheipaexapr
X-HE-Tag: 1778277700-550953
X-HE-Meta: U2FsdGVkX1+YyKuNbSGd6gKr3Y9y6sRtXdy5dT/RJgxaFFCHkdLkFgel/4hrS8VgGgDJMLu/lmlqdp2fQcPweAVi18VKL2FrkE0D3Cvtfc+po9/lfUc0JWqCJPpk9r5VIMd2EY8Gub14A+SWNOgD4jow7AKd0qpituovxM6Z6thj7KT5ZEP3LbkRVo/MbRSQEYHzQAILSv+kKVaKJlqraiHdTZ0+gwR7hLtYl0NCnp9I+akeenEKNAyp3MnzgH4MMIc7g5OHf5HgS1wPm33bztOnXPW++F+DsOtg0ctHzOln2DIeR+NiNcoVsABwWLAMZQphuz/Sn7o/7evXpYwLDUollf1XSVNLnD3s3AgjiOjfiij1aumVMYUWI3d1uymhbgxADXN32y9vsk9uMuq4QRwIXcHGGAJ1E/gkl9ZqrYiwgl35letqVz4Zh04BAeE7KUYRT7Jqu9q4NFegadGjHJLS76Nj9/X5On334SLH3aOaxX7e+S/y6O6DHRF/O3BXm7Kicb6pXXTs9PzUfU38Wr9KTayWdX+U0WfzdS3KtrYVaYsakzWRZTsU0gF8jUKz1Q96IgmyJudLqgVpQm1wIdzJdKaxffehtfXkrYnPAyJtLW6ExLmXSv1rb+YPL1/M/ujQHgzo6Pz+IjyX7JSjNQflkaahSHRnb2JNi6CEz+YZ3qxT2s4xNE9qf0eFMHrc9UjyVajGYHoR3xbZv8oL8t2/nRT/VmTLwzqz1+0loUmoCJKP9XM8CxXVACAvfIugum5qo02rpDAY0Zcmzs5ONf1kQNdojPfk0z0ZvgOQ8AcGT4vZsKGc107AEj38ozI3o0iOTSAAew1eY223qFJb1QhUopfOctzdMk8aVENPmYJQdHLmsZVQXiRj4ikAULxU6n9Ack1H7f/+ehPE0+ZQbkBBNvdR2iXfPyNLE/PRRQDGDBD55IhXYZkMdZ4OrXv48qKjqCWo/sglX1tbu5j
 duphkC3U
 E0MwOCnS6lY1C0eV1WmQRzr8WT6L9EvfFV+O9hisF3/O1rwS9xTVYEsf1Ij4Pz8qwyXzqlHkKPwisXKRpRl4S1Yjr6JyzwEe9tIMm6BXWibeCjRZNBjM7+Ja6Mk2jETJHjHEHQ7flStBDJHBISxLdMSs4eyzAawbuet8K1aGLglYiqjXZ1Y13mQwtQwz6vRhZrjkBQF2AuDOl3ek0SrV131t1SlvHEGX3KzY+seVqaeZml94PcLjTJQAa8lri4TI58M9RbfJ47srYnyaTj8vrWMbyPTMiuPUv42Ggi7Rco8BY+1ieXqbMEvzCZcCbRRqnJ3dbfojzaMANadU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  6 May 2026 14:20:56 +0000 Joonwon Kang <joonwonkang@google.com> wrote:

> Chunk end offset was set to a block end offset, which could prevent
> chunk hints from being updated correctly. It was observed that the chunk
> free size gets minus or shorter than the actual free size due to this.
> This commit fixes it.

AI review:
	https://sashiko.dev/#/patchset/20260506142100.1289509-1-joonwonkang@google.com

The first comment seems valid:

  CC      mm/percpu-stats.o
mm/percpu-stats.c: In function 'chunk_map_stats':
mm/percpu-stats.c:125:9: error: aggregate value used where an integer was expected
  125 |         P("contig_bytes", chunk_md->contig_hint * PCPU_MIN_ALLOC_SIZE);
      |         ^


