Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09734C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FC056B009D; Mon,  6 Jul 2026 13:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ACDA6B00A0; Mon,  6 Jul 2026 13:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79E226B00BF; Mon,  6 Jul 2026 13:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45AAF6B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:21:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ABB641A01C2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:21:21 +0000 (UTC)
X-FDA: 84959017962.03.504643A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E1F6440009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:21:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p9zCbIcw;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783358480;
	b=oPw3A53JuOUMmWslR4LW2JJVWfZghZcpaxWY2m7vQJADHGdSHI6BA2PwWxxYFFjECkPopd
	/hkBWk/4bN/QRkqKUNpubPsjJukk6Ot+c5itVayt8mdTgWF+xKcOp60403Tph6BJFClWh9
	zyZ5TxNmFGutslsJA3KwLzWc/x3bLdU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p9zCbIcw;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783358480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GT8eYR5FX/yxO0AzIZtWTpOPmt1HL5HPg0mx9YGGq9A=;
	b=Mt6ShlthHhIlsz175yxp+aVJWam1A6z2bygBO20CZhmXTU5gprvQo22Go0grOmLrSroPjA
	bYNvniqWUbSkrMHupj1AcFiSOjFNuLXYfBzrFh5zemekpNNdN2/geoadAquUI1fM8PWXeG
	x4SKbntN3Ml5Y4r5bpP+EkAZ6618uHY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E6CD60098;
	Mon,  6 Jul 2026 17:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F081F000E9;
	Mon,  6 Jul 2026 17:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783358478;
	bh=GT8eYR5FX/yxO0AzIZtWTpOPmt1HL5HPg0mx9YGGq9A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=p9zCbIcwLHK6Su6y0C2PJV/4Z9wCXnlM3TBQJUPMnEqq0cRCBacrKuCaisJ7NNhfp
	 CyjhcvOoA8/98yZrJhr4x69/CVDtRimvcjjGprSg1lWm30zU0wCw048/00EtZr+lta
	 XsXdagwOrZlFzKqzYL+zXcoLWlLGSUZeV3UQaoig=
Date: Mon, 6 Jul 2026 10:21:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, chrisl@kernel.org, usama.arif@linux.dev,
 kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 youngjun.park@lge.com, linux-mm@kvack.org, dri-devel@lists.sourceforge.net
Subject: Re: better block swap batching and a different take on swap_ops v3
Message-Id: <20260706102118.6b6ecc0557edcbb2839e2ab7@linux-foundation.org>
In-Reply-To: <20260706132206.935272-1-hch@lst.de>
References: <20260706132206.935272-1-hch@lst.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E1F6440009
X-Stat-Signature: f181b4jwjot754pgo5pidejeadxzx7bq
X-HE-Tag: 1783358479-513455
X-HE-Meta: U2FsdGVkX1+v/vlfwWICxIE8aXcQFDZFXDOc+PGpTz5ssKOuw795KATcK3epVoEW/3oIToX8/6HhTCBh+4cUntX8mXWeb1qGlc+b7PDqM6impVcB3CSa7ZDR3+F7CciaMGCBEGzN5j/MD0cg3PggOeZmfseSefDN8KXqG+ReZ+5iws0oiCiaGdDzvzKB5pOM8fIQSmqfRIaeRISrsw+KKCrxOg81W+uQk63NpW0ibltogp8O3o50rlB1cXgcTtRcWu1wY+l9Mx15P8G/9EglmoqAhTVh07fQHpTOIX+H96O7p3SXnCj2UjLoVFYd9RahUT0Sj1KgoMZWEdzUCH0FWmbASoX5KS9uWmGqjpK6/IyEEUNTQgrujSx1KXLsPxr5+6VvpXqGbx8Z5AITbBhxuwfdeEI+yRedoOm9R12U8gHTkOOAnJ4VwhqIT9bFiR5aWlsewF3azys1HVl8rLyzlpUPLWnvcPtBirlH7pFgZgukF0uNSqNW9VyHunLLNh8odVO4MiMb/bVmRT9WaQAhCdGi1ENIhwr2g6Eeblge8be3XPiIW8uije8iW/CAf/DIStsndJcsqhU+Msmt+sH9BOBWLdCVqwi8Y5QMN+FBS9ipn2uvPysH6g4zHrliBcZ0z8L5Y7uf/bdF4If+lAoiLibyt0vTft3obJGwzw1TpCPHhC+dVNvvZQ1a83s3jJFfJIem50wz0+6QgpuQp5CtZFtF6rWUfifAnc/fVjIXTKAbjXDpvZFCWhIu6egPbiwaveeb8a7sXhKfrNgjP45ruCBEtl6j8qgymMXDIQE2ix/adkoUERmQgLQ43HUAEgasYOUFHArX5dSNoiLUJnEdPyToGFOSgjXUUm7jvxUpqUd8Q9viQv/BTA8N3wEiKxDMAGr0F0pO6J5nZLvrTIa3seIHad9OQunM055GD6hyE9ckGU4uq287TlIpxl07tDdg+gj7gUIi9NrapHsOreh
 uVOfGDxn
 3nNPWpmjeZMeGYryoTsqBHSpcmCMBeQImcQj86VBT9qOlQqh4+BweFJBRKNgTGFXMDDkSS/2b5uoXjBgZpPSbu4EJXuOUa5NG6rIePv9VYgSlcci4iWx0a4Ivp5TMARqhNpen8o0kQeCcn6GiT48sgLC7pR7AZSS7B3b7g10tm9q8ELdlu3ghIohktoCxiPQxXowWhp+sBhdAzRqoaq+OldC5ry/D4KsCRCNtACIK0duEX+xRx4Kb0VHIzszBPBIl1DgATjxdJTYLsw7nvZTpPrOvFcltE3M2ISBwEisUAAySHRG6LTXtr0dMqREm6WQDfoSRfw2tu9yYokzHx8JLUtysQ5pkwJfSR8Y8VRw63V3YYoJn7niDSob5DZMOpMjLChYt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 15:21:52 +0200 Christoph Hellwig <hch@lst.de> wrote:

> this series makes use of the swap_iocb for block as well so that it
> doesn't do inefficient single-bio I/O, and then rebases the swap_ops from
> Baoquan on top of the now very different method structure.
> 
> When running doing kernels builds, which is a workload that doesn't
> really do much THP anonymous memory it still gets 2x clustering for
> writeout and 1.2x for reading back swap in.  The overall times do
> not actually change, though.

Thanks.

AI review might have found some pre-existing bugs in 
drivers/gpu/drm/i915/gem/i915_gem_shmem.c
drivers/gpu/drm/ttm/ttm_backup.c

	https://sashiko.dev/#/patchset/20260706132206.935272-1-hch@lst.de



