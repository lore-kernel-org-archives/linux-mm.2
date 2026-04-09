Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AFFCF364C8
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 22:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B653F6B0088; Thu,  9 Apr 2026 18:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D396B0089; Thu,  9 Apr 2026 18:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A066B008A; Thu,  9 Apr 2026 18:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9937B6B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:08:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4447A88AE7
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 22:08:06 +0000 (UTC)
X-FDA: 84640406172.14.83E7F21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7AF3F40002
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 22:08:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nLTyAt5m;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775772484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCZp/0zpqKUcSUVUVKxZEKxPq6cY0vFtTi4h6UJ3eGc=;
	b=nHBfFOcVA+ZgclPWSrzBah9FZlS3n5fxJPCImTB8atqvhXGiiWF0KfNwvIffdH1oNkuU6h
	1b0BgJZZDcQsp0I5Iol9sNuXF4yKEKzVsByas9hz2xrA/L3OByX2yU71xXTQYyU5VnOBYa
	5NHzxg2eXJmFJoMEVXTLoIJdmAkWYsA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775772484; a=rsa-sha256;
	cv=none;
	b=wNapLwPtZ9AgZ2sxf7d9zza7YRqj1saz+Qb9MmbHN23HgfGu0C6wKWkfvycL7lw2I9W7qT
	xFM2Wnz6enpvMx28dV9QjFwNFhe51QWy7xrf785GB3mtnVEh2Yu07+4dJX2P6IgfVfsZlk
	pD/OF8te3cXLSNIpko0qR044PbnZibs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nLTyAt5m;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EF57438F0;
	Thu,  9 Apr 2026 22:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA32C4CEF7;
	Thu,  9 Apr 2026 22:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775772483;
	bh=+G3f1pApENEjUmf8/ey15GcIeDZlQhQyE/iU1l/XDHA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nLTyAt5mpJa8aEV4EsEvUSy7WoQR9BIMvp42QupSvFk18TFbfPUzXH8oSXb5KXOG+
	 SVXgkBzZjYd6+q+sQFdD76OtTJQTXuX4vQ+m6EWmO7JxTlbRAd/j2pYmcPqinxyXg9
	 PccXarbDIljFQfHWQk1vG7nmzsIIlKuCTA7xndys=
Date: Thu, 9 Apr 2026 15:08:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>,
 kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kho: fix error handling in kho_add_subtree()
Message-Id: <20260409150802.fd7b91c9beea6abe4e8a63c2@linux-foundation.org>
In-Reply-To: <20260407-kho_fix_send-v1-1-b21977feb960@debian.org>
References: <20260407-kho_fix_send-v1-1-b21977feb960@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7AF3F40002
X-Stat-Signature: ibrptwhgu8qr6kgpsswfck19r7p5xsaw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775772484-466647
X-HE-Meta: U2FsdGVkX18k34jvuYGMRPQOaJydYyhSjtbE8/dfQR0GqZ0zq4hchaszFI19iIPz74YBqhxMhc+udEo7/6rfRpKu3uWFDfiBRFqPGmM6RLpuO3jzFivPFC8ydO0BIsrRY4I5Lo8MReZht+fviQEF6r9Ycqt1X0jt6WPo4jPwsBM3+lB39roNTduSLrzPyEqLgzUahnVtwsV+6uxNXVBB99eNixFCIUpdARqdoX24oxc4hLiP2uxt9is/Ez0PWCec/wPHj7VmFhw0GMhedZEpFLT4zbXY893bo8RuNkvI8AWQsBLQ5t1QMMbNPcHpPY2qu14XaN+cvEHdBfthe+uyv4JSRT9oVw8RAbng/dnp63sly1+NIaB3BHrr0qM+pMvM6sgohRKdgLnW3pgOfhalSEqEggB476F6nJfehk+xY2SbQkKLObGhAdFRGi0G62nm5/DU8KxFHsEISyB9SYq4SmkUWESmpxa5InPmXyjl3cmGshunEQGXUTQRIhS1ph4cNJ2v9HMeFWlOAE6sFYPqJHCiiQw3snALtLo00LgZEmzaVoblWTFiQMlv+gspdpfsPWFrdpaWP+5ZiN4AulYw4wn9YGHIQk7Xg44WYDedODhNMOv3p8l+NaHxiejpbCR8c3aEhsA9FLuO85GVkYfuplB9JiJIM/F88BL5ifH69rm/v721IeHsuT/EKOEeTm5VBWjpmaxBex4Y/vJ6byvHnp90LN7aK5KardWlueDPBWPeLosycNANK3dUX1DSP5B+vbYTz1sVXHcnnn5FZdxM7Vj9JL10gq6rK1/0m8W37dGmZBmrQkkiwY1pBPo8jC8h2DI5LweEZ/WDguMF0CdM0hMhVJxl+6RrpwqvLEJ0Vqy5dIZvTpclA0aBFC0qtctIIobQCO88HriYHlDnBj6M7775PbrqqLYvr7xBZhqH3c0mM2puhkllfDG+fz0MD+i8r+mL7cR39McXvP9Pj9v
 MX7EmEgO
 ahUwfXqsPP0CsVEAhtekBQWBJv3gheW6LXtmuIiw8QglHLvTjCRtgUaOFnVh+b8BnNP7GWnpyJKtJ8Z9Y1SSe9Z1ATERmH8nYapVG6qtv2OrVjzAzZsCpMnUUCXYibBXDXHLYDaNUWcfF4MAdmpcgj0M6JsgW9cTMmOQACv201HsgM5ZXI6cTeK/B5sh0L/v/LyhwfVweYP4mtLclZDxr+X29CGHEZ0FzKPmNHyiEbDMAfWSPpCyfJcXge/UBtw1hhmVED2SzL4SeSHWVK3ihDXN5Xeys0+bLYbYPj6fIV0T/c6qKHwHTATscR4Qn3u/yOLu9OSuuiEtm6tsYbMIZfu0f5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 07 Apr 2026 10:01:47 -0700 Breno Leitao <leitao@debian.org> wrote:

> Fix two error handling issues in kho_add_subtree(), where it doesn't
> handle the error path correctly.
> 
> 1. If fdt_setprop() fails after the subnode has been created, the
>    subnode is not removed. This leaves an incomplete node in the FDT
>    (missing "preserved-data" or "blob-size" properties).
> 
> 2. The fdt_setprop() return value (an FDT error code) is stored
>    directly in err and returned to the caller, which expects -errno.
> 
> Fix both by storing fdt_setprop() results in fdt_err, jumping to a new
> out_del_node label that removes the subnode on failure, and only setting
> err = 0 on the success path, otherwise returning -ENOMEM (instead of
> FDT_ERR_ errors that would come from fdt_setprop).
> 
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")

v6.16.

> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)

Do -stable kernels want this?

Changelog is missing a description of userspace-visible effects, So I
(and others) can't tell!

