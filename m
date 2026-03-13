Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A764A106FD9A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 08:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DB416B0088; Fri, 13 Mar 2026 04:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E466B0089; Fri, 13 Mar 2026 04:51:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC6F6B008A; Fri, 13 Mar 2026 04:51:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB6786B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:51:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5FF5D1B8C73
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:51:06 +0000 (UTC)
X-FDA: 84540420132.17.A7489A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B816E20004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:51:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fMXnoAOQ;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773391864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5JrLlrz1R0ux6eyWaXBOi4F+LeobsZhvq0nXftAHdHg=;
	b=27F95NiLmSY8/lxkRSTvdiB4L4cU7KXJ/lafGCtnxSr40TG6kLno6z9NysYEG2/Xf/sthT
	AWOHAt9UF5wmCzfsNf7tFJakZXAmVyWotJ9EN6XRV0FJBTBfuPa4pdpWfavlRep/8BWXs4
	oZadw4DrAeaV4Ig7BZdUVmcYUsKDrQQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fMXnoAOQ;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773391864; a=rsa-sha256;
	cv=none;
	b=KoY7miF9PYXHU4C7ie1btthK6YvvwEuyv+LggQxfdWOrNSw5nFwhQbuEEEB+rhU8S7+M50
	jraTduvu297Y6XsODF04PNsxB2+7Uc72VV0Aom/1E1ATuuItY1V73HyXj81T2aroAoy+Fa
	yVvM9wCuE+VpizbaE/edHMHWviIkNd4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED8FB6012B;
	Fri, 13 Mar 2026 08:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E97C19421;
	Fri, 13 Mar 2026 08:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773391863;
	bh=1KUT9Tf25ZS6VrZia7+QDLQFs4SKqyhZvqzfc04vw8k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=fMXnoAOQU0/G+r8DPkq+oydoGE9H6DUf2wvwyh8xC86fVKVeEY1g+IxpVxEv8j4oL
	 Pyaz4iO+lYWCVz7h2biCk/IsklGMvlM6pN/y4sChyv5iDLimiyDysTb61GeN6DEeFS
	 j+J/NpSNz4VfxUAVWqep5mkYXV20jsikdgIjsCuLjCnEqG0GEVqz74Z4ZhFRL0bSX5
	 luExGUclhVGwdQrap00cRrbE+JD9QH9QQcylpQDIsiG7/7SJfdRTk8J9q8cs9DaP8l
	 eKeyMbspFRUlBy+3KMqU5qFIq4AdAzXd0dprSkae8RoYDJyix3r2Z9CB26YOHnGzY3
	 DTpw12xM5T4WA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  SeongJae Park <sj@kernel.org>,  kernel-team@meta.com
Subject: Re: [PATCH v8 1/6] kho: add size parameter to kho_add_subtree()
In-Reply-To: <20260309-kho-v8-1-c3abcf4ac750@debian.org> (Breno Leitao's
	message of "Mon, 09 Mar 2026 06:41:44 -0700")
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
	<20260309-kho-v8-1-c3abcf4ac750@debian.org>
Date: Fri, 13 Mar 2026 08:50:59 +0000
Message-ID: <2vxzms0cgljg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: B816E20004
X-Rspamd-Server: rspam07
X-Stat-Signature: zmixmytcmqqr13nyhwu9mqwwn6krra6u
X-Rspam-User: 
X-HE-Tag: 1773391864-329928
X-HE-Meta: U2FsdGVkX1/ZFVIW1M48G1hDs1KX9A46YEC/GJuMBbHtvMz/HZU4016mibLwa+xuCdwSXE7zXfp4aMaUiW4d2Sk8JRs/8dZa3uNmv7mFfGmd6rQwCeLuKGO4DRWueQGW9Ro05mIXsIgY0DVjw6XqSCSUxtqq7nzjt1TMJYz2a0vW1hEAI83rBczo4teZoWUQzbD3b3Xjjh4uAO71sbPKNj9QhW1GbXyA3xzo69wQn/EAgnmSVCwteeGIsdFsJZsZJjYKyFtq5xdPQ6ongpGFG5JiOBKzelEjP/R3UPKBDHgWqZPC+1l71tOVz9nk29BTXAF80CTLr7WsWmvmtCg0juPdAjC9Op8F/bc01Ysa2+MlIifJb7bVq4VNh8wJU/frdsbL8DZ/8fDLB+iEcT7WYclXS1zgJFdNklJdIshQw4wydT8gRiAFuX/VgaLXW1kZl6HX6cp5SUbaiYdqWKH1k++wd7CtISnX5lwj36owfOkhKV/6srjbzigz/IIjP3vHg/Gy4PRlC1yVzhUjMKGuFrIUZeRkqXet8LkHX1hsazT/RQ9kHazeFgFGLgleaGv47H8N2oBVdA2EdzmITfAJ8ekfgzgTfDWEracz3AAlcSaiwD/0mfJG8HBTpaK0AoqrpjsTm5PmuXmzZTb9Qg0xX3cEeX3IhjG6OlAd9coJAEXCODgAPjO1oeRzoj5klkhMJySEuCeR2qSUo0DZK2CevfVGT7YbnDffQ+wl35h+xR5GmTYMQwjnTo1ELruHWuuudBfHf3y6HOvqAAJRYRLriTjSf+7/jrFlYQTCrXUDURe2wxiN95Zox6InxUBylqG85QBLe3y9x/MCbQM5HClcpkLz1ANaY7LkfVoUcZSmXh1ugdyClpkfKfakEt6QhN2Z8CVV0GLDTd0XbN/KIYgAkdz2QGMRFqpX1eOfCThTU0ejTY0aYYC/kJw4WLwSmZArDM1t8me2HOqO8sh3k6b
 8gbZkw0b
 11wMivn1MCMMV0UybUhKuuJNfA2LbYQRuX39rks/l2B5kvZb0ZPSPle3NeMCkPiqh2cQsMse3KKsR7YgByUSZRZ6M/vvZlp6RzY9IQfR4HbAjvO0jNYa5PMt5MyEgK4SsxQ6brlnA7OM2ykO0NV0Wb7/LL81Ml8/0nJ+oZmE7NPpoe/+m/WzfqBJmffP7j8vNiJGQB5xz8w9BS0xhuK0tGf1NVJRXvI64xAJGpt/MGE793YRKFtBbNClH6cHILQ4z1wvX0mRYVDyoCtQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09 2026, Breno Leitao wrote:

> kho_add_subtree() assumes the fdt argument is always an FDT and calls
> fdt_totalsize() on it in the debugfs code path. This assumption will
> break if a caller passes arbitrary data instead of an FDT.
>
> When CONFIG_KEXEC_HANDOVER_DEBUGFS is enabled, kho_debugfs_fdt_add()
> calls __kho_debugfs_fdt_add(), which executes:
>
>     f->wrapper.size = fdt_totalsize(fdt);
>
> Fix this by adding an explicit size parameter to kho_add_subtree() so
> callers specify the blob size. This allows subtrees to contain
> arbitrary data formats, not just FDTs. Update all callers:
>
>   - memblock.c: use fdt_totalsize(fdt)
>   - luo_core.c: use fdt_totalsize(fdt_out)
>   - test_kho.c: use fdt_totalsize()
>   - kexec_handover.c (root fdt): use fdt_totalsize(kho_out.fdt)
>
> Also update __kho_debugfs_fdt_add() to receive the size explicitly
> instead of computing it internally via fdt_totalsize(). In
> kho_in_debugfs_init(), pass fdt_totalsize() for the root FDT and
> sub-blobs since all current users are FDTs. A subsequent patch will
> persist the size in the KHO FDT so the incoming side can handle
> non-FDT blobs correctly.
>
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

