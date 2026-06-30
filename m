Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6396DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 02:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397E96B00AA; Mon, 29 Jun 2026 22:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349C96B00AB; Mon, 29 Jun 2026 22:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239D56B00AF; Mon, 29 Jun 2026 22:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC06E6B00AA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:34:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32D0C12032D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:34:00 +0000 (UTC)
X-FDA: 84935009040.19.055B252
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2274A140004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:33:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w1+yDl86;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782786838;
	b=EkTRvjei+mjGQ4dPcGC3YgUo301T5mV6Pgqp7R/CO1PYpPLzXUUA7xQFZY5ZLnVCUC/B0e
	ACO65xbDUZXONikkkMoffE8b13mUF/64f81Lh9I/5xN7N3K8j/hIyaD3oixsQiABVtVqVZ
	uDVFevJuqjQ8JQC2trqcZJRPVRBlULc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782786838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9c++mEhIjD8EHQCLUFVooRT9xtLHlcXv5gfuL+wYJFM=;
	b=DeNIHU6yEyqi7J3SZsuR0sni7RUYlAPndBKR7zVZemB792tiTrPstE4ytJA6TgKS2El7rt
	qbpnHr4VQqWpC8rODmnLVECwFGIG3oNad31qj9DJXvmjXoREFL+QPC5t42qsdsK2dbg3r9
	EQKGWYAfvzLa67HW76e+LZX2y5qnExU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w1+yDl86;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E30041FC4;
	Tue, 30 Jun 2026 02:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B9F1F000E9;
	Tue, 30 Jun 2026 02:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782786837;
	bh=9c++mEhIjD8EHQCLUFVooRT9xtLHlcXv5gfuL+wYJFM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=w1+yDl86uLLkUigJDCkuAsWiZZcQmwTNSE2SJflGueR62sxq7SA1+LtKvK4aCQpTB
	 PDfcIkv3kyP7F/gm9wKmi43ry2ByrAnm4fwDm9bxh7tHMtHUS1KYvRUbVOQ1YPvBai
	 6yX4iFpvbZEQ4Q7wAEJRQ61WEH/ylbpVY+BIGHYY=
Date: Mon, 29 Jun 2026 19:33:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/7] mm/page_owner: misc cleanups
Message-Id: <20260629193356.e3a7527636192308f1557ae2@linux-foundation.org>
In-Reply-To: <20260630015331.147174-1-ye.liu@linux.dev>
References: <20260630015331.147174-1-ye.liu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2274A140004
X-Stat-Signature: 3qekzaghut3u3dexfspux8err1zj9qd1
X-HE-Tag: 1782786838-4415
X-HE-Meta: U2FsdGVkX1+VfZ2+L9t3JPJMb9JeJQvAHpkuLPktO6Cqsh5zSn2epcSy3GaIy4uiJNeHTzWl6fQB4RH5psi0T1/nDDwaelYZqDKO2nwn3h7xi+L8wYGFiA9VZeq5ng+r3+TvxC9OLo5cMYZuixSj5Cwtor92CIw/j3xxbX8Cyxl5nzenQJIzqNsJF5uD3GLDuTAbt8DrCZvkwUUJ9m9Q7laKRG0kNpE8CdoQj6P3hWsvHe6gQXNEar9rVjvnHDzHryE5rQGgYWH+dFYJWkX3h682//J3H5Mwa/c5SrAnQx4IKSFlNrmsoYpgS3Xs4ajaknLtID//5KYyMGMJ2ptozn1sPe36+NNIGDMEJIamhaOS3mtaOIRVAq/HMhQPaJ/PNDYjKf05/NnPu4BM1/WnOCiZzfAFf2QsaOh0EmqBaACJKhZzOt/5nSSxs25eCKwoFUTlu0gh5N/mihgQvDMfo3UYKADqY5vIcN2QLWL3wAZb7BX0zBfd3QVIGo8mtMzCaXa+F3P7tjqxjHOvEXSnx4jQoJTthyTOXdJ8I9PfyoBBDuaOhkLTv+rh2Tew1TGxiCpTqEYR/8q8zERHlAVvw8tIgWLRXLbIF+qrndPJbcpS75qiwRK8Rf8jwwkkCLkkdu9YVmoNSBTuXbi8Z1QtYn5M8hx5y/qh1VoRkcRIraeAT+HCtmGvV/8ng/g5h96UgwEG/Q3o9n87uiJKs43upVHhGYpHCxAkBqqSF1g5Xallz3Cb1vmBamKTO6S2OtsI9w/1a6heg+M0594/l+9Tzc3y3M8pLwqFtuJrzxm823tpkJVoRZhQZCbOS4hiTN9xqh245O9EO2RrYr+8Fm5Uf9vQljElw4P1C4SZtd05SSkOCdVjK6h6Z1a3C7eacRmUUTZbpjkvQdX8sdqDO/KISQhVtu+JA619tgk4qOBTijRl5NyQlAKROWUQxWa88SKkKXRG/rdD2Y/RDivrE4G
 XgT3C3iJ
 NWGgVzK8oEhWgGAEsJce/pbVpbEnM1Gg797o3fWFFoReltsllM6Om7nLb04NpDlGLRK7271WXAVnJXrdyvpsbjrLnO6w+ca/5HAMeOWDKvlHjBAZX+lVICQkHR9HsPcuD//5O//+w5nAuXFByBgmmSxdFiSdnEUf1Xhp1iIIYzzNDcYmfjDpb73udvwHaUn97u3w0eXJ8IFg+qM6lUHrkqMdl45qCPQcJmlCLsdg1LYvExMyX3MC+mxc7blVKjmg37QvvwzmqDOq2qL3ZuxNh6HhBb4nWohQvDhJo7l8uxwNIbjHxCc8FshgBJXB4VApLpypagSexK2nc+p4S/HElDG3+gnQSscHFcdGS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 09:53:17 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> This series collects a few cleanups for mm/page_owner.c that have been
> accumulated while reading through the file.  There is no functional
> change -- the goal is to make the code easier to read and maintain.

Updated, thanks.

AI review had some questions and suggestions:
	https://sashiko.dev/#/patchset/20260630015331.147174-1-ye.liu@linux.dev

