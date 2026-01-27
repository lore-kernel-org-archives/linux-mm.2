Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 419EBD25959
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 07:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CC966B0089; Tue, 27 Jan 2026 02:27:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 850156B008A; Tue, 27 Jan 2026 02:27:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C3B6B008C; Tue, 27 Jan 2026 02:27:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 656896B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:27:04 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0324B140A5D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:27:03 +0000 (UTC)
X-FDA: 84376912368.19.163D348
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6AC14C0006
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:27:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PWxtpAUF;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769498822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qiY1VeY0GK0N/+CKEldnf2FHtmBlJfiHQKXOI0VOBdc=;
	b=yrtGkJBmW1J6Zv6TvfAeo24DvSaOBRNKFwA6zA/6RasEYnUE1KIKXZBXKxyJ5YaACvYIOU
	EAyCIJ+j/yvZf48FqqUemx2jMD+LgBUiNVt5FdUoFsMdSpH3l9vakPb22QufflYGSUvcWQ
	F8PlGUMlU66TAUfdu3OQjmLpqkEXLM0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PWxtpAUF;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769498822; a=rsa-sha256;
	cv=none;
	b=0YmNbZeDO6NYOBrNRtO5C4eF0OMjdaAyJx7TRb+DyJ+jW/R/HdncrvHld+s92q7dplt0Vk
	hE2OYy1uBNkm4GQxlP7CqLjUOb7r+NZyKXW1YzEJgb1DYVvAaz/tsocSjJr27YhGMhatY+
	vq/OLF7jX7/wAOURjY2iaWmly64Oc+I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C917D60097;
	Tue, 27 Jan 2026 07:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D68C116C6;
	Tue, 27 Jan 2026 07:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769498821;
	bh=2kiaOIVcsIwszKKFeZ5JCkrNsk0h0wj5t3pR7iEwX9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PWxtpAUFbQ76pTxzVPToj3w6NaJQsjdU+tedyUYSp+TFzVS5UtTRClnMJTMbLNI4z
	 LzDhiUZ6iwf+i1bC+4GcDsPKxfMhvUaRE7bFd81vD2Uviw1ds1eLmG/vrmL8RARMSZ
	 0NdCbbmYJsrqa6p6ttvdmXfP0DGRROpqsJJ85qq/pO0Hshvcxqxyff2n6QfNsCt6OF
	 O4ff/mNm1uBOzexHIhE3ZJNqLJhLzNAAb6S/8WlGbbmzVKqhfk8ban3FuJY/TrqeYy
	 8gKxXOXCA8UYnFvPPR0Z82zhNiFS6EsWTQyd7VOYQb8DFx91Lvdv1t8QjFBlwPsWyG
	 yCMWqhnsZ9gcA==
Date: Tue, 27 Jan 2026 09:26:52 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com,
	riel@surriel.com, SeongJae Park <sj@kernel.org>,
	kernel-team@meta.com
Subject: Re: [PATCH v5 2/4] kho: rename fdt parameter to blob in
 kho_add/remove_subtree()
Message-ID: <aXhovDdoLqcmSWVW@kernel.org>
References: <20260126-kho-v5-0-7cd0f69ab204@debian.org>
 <20260126-kho-v5-2-7cd0f69ab204@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126-kho-v5-2-7cd0f69ab204@debian.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6AC14C0006
X-Stat-Signature: 9uj5wy7eebd9dfmb44k7orpuii4qfjs6
X-Rspam-User: 
X-HE-Tag: 1769498822-536259
X-HE-Meta: U2FsdGVkX19q1KiMI+bu5o7/gYUJhz/cdPaQBK+nnpxGWApowNIE19RUXQHJJ+w22GqSJJtnDm97hJs34hvlLKZYKrBNRxlZTN2BWvF6qGDKn+WT4qAsT3BSSFD7nhgv74FmsnoLbNNF0EQPWw49sHNTO+NBszZ6VZhaTi/3UYWhh70Pg6t8MtMy7WViNHtGSAiNezL/766st05lvpwzWvmQg4jNHJFxdEftE12wNgOJffleQV1p8p9rmRpPDUz83cyYMt00TcD/DdcjiOKKaRICqaYBWyM2LHY2Q77vxJVcprfUd5AhYgg0I1bdmqeKMdp3WRPO/GyWN1qtzA4z9TsDAH4aTD9l3lz6XWuOObdG0U6iyP/jdn7S/FlRJPlMuV541Yf+2s5talIS/M3mX/1S2fTSdUIjT4mEgVeJ3fniWw3D2KzRk1ncY0AwdtngjW2rqEeLV+pUPqHn+yEQfFPJMmZtbFv5JrLBz0opYoIM5TQ83Ld7aWkF5buMWuyJgXF7LczdL5+Ef5SHzz2iW+M/FBO8IDn7Yv9Rv/Q4tTzqKi/XdbiTbrxtvyYcf79tzbSRFQWdR3O4DlcR1M5gRfY14xzyYV0dg/OFB0WV/ucpewkzSSjPUdrvviTl0lIvlWPSX9mrlQpvVQH9Fyu/81hyCP5A+eHEJvmVJSYVKjLc2Z5HdQi1ylz4Hxd8/8AQPvG+6rJwXT96k4ampVdJThnFlnuMx9BaDMWz+GFrQI5RMSL1jn6dxDKMr/Wb4MWx5ZBBHqfAJjwOTnNB81wYaWzYAXloAGUQKoi3tlU/m3n4j+AcUGdw8BZY+TKR8HAGsnBboh+QZw3NG1vh+4CmQgO/Xkh6H26wrQ5HcC1xnxLQa2fsFZyVVARuFUhwvfaIyswExzRCV4iRm2HxQrLnzE2k8PLNg3BClYlvrQGnW0YMFrZM+Pq8jJgf8js3DyBu8kQXGgsajFsnepjQhBx
 J0D01W6L
 FirH9w6X8AQfxvPMQptXlstbhehq9FBXZumnEISDb/7z+cZEv1omIiCm0xepi0fKghjbW/bicIxPEo8rw9VUGOinYOETHnDJxEYDa97uDbaODE8QKVI5iQzad7SMOOY86Ib2Q8eZaHu73Cz5Z55S5cee6HtNGhNK2Z5vH6T2k0kad1Gorklf8UDqCrwtXt+vCEBBKYEl6yJ7QlW8XqW0xtqaraXXjlw5ZFEGKWvHXaOBY11QiSMfkmFrQ9eEtJ5JjrGEnwqPdVacJimwfa877IUZ35xRobzIF5NoJLxjqz1Pbte4y3nvoJZO32f0dQ2QSlYuT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 08:07:24AM -0800, Breno Leitao wrote:
> Since kho_add_subtree() now accepts arbitrary data blobs (not just
> FDTs), rename the parameter from 'fdt' to 'blob' to better reflect
> its purpose. Apply the same rename to kho_remove_subtree() for
> consistency.
 
So if we are doing renames, let's take care of kho_debugfs_fdt_*() as well.

> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  include/linux/kexec_handover.h     |  8 ++++----
>  kernel/liveupdate/kexec_handover.c | 18 +++++++++---------
>  2 files changed, 13 insertions(+), 13 deletions(-)

-- 
Sincerely yours,
Mike.

