Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D9AB109C059
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85CA46B008A; Wed, 25 Mar 2026 14:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80DA46B008C; Wed, 25 Mar 2026 14:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7239B6B0092; Wed, 25 Mar 2026 14:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F57B6B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:56:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8F5F1401F6
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:56:21 +0000 (UTC)
X-FDA: 84585490962.15.ADCC4F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4631E1C000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:56:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GnX+GgqK;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774464980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXrpBVDtXJh440ghzah6hNyBqLgDLb2/8ygf4qehDxM=;
	b=G5+3OTOLKbUs+QPfIb0eh0x6iXbfnnjCE+3zQSKQJ1fs2E1qdS0YW1Q4AurMaNcQB3Jlai
	RSwIVILS+Ke2reNq0Qhyczzs7kCH8AlxsBNxBjbSYIuJYfmxdupmQJua192ACpOxubZ4CL
	36SWWTH6IIHpZonO21AY7u3r57pDbxM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GnX+GgqK;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774464980; a=rsa-sha256;
	cv=none;
	b=Y93bZeML0CiPO6vjbiOZPAplAg+7elPMaVHm33PfcY4EqXuFO33+kvlVHTJu4YV8Pl1eqN
	ENkgjH8cg6fWXWuRVP0JN0yxKFT/6KH+Ra4T4Whb3OTJ7bTs53FsQ4qleSR4aLF5FsL7gL
	oqyrgCQRzoPgq6SFNX3TFCW7hls8QcE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A5E741A60;
	Wed, 25 Mar 2026 18:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E761C2BC9E;
	Wed, 25 Mar 2026 18:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774464979;
	bh=lp0LXh6BFpAmbxVcsSepCoAFLcbpz420PeI1wAApxVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GnX+GgqKNcpy31iHo9ZdlllUIyufqIUI0lVEDG9Ls6JtXoJimek+xiiKuTGx/B4Om
	 pko+uOtdyDuFZMld/MX7eJzT51F8a0DGB/fEifSyipyA+7LmhAjC7+eUhj6ym0XTfd
	 5kOhvEIGAbl/rLGlhIszOkXSIyZUuUAyfhy9qf8rm8ptRa3UUE+zeX04M0rdxJhc1Q
	 5/VoEpj3kBhUzw+fiK3CjMhsMu3lawsBhuWrEeAxcp+WEHKNLONVwMWAUHfmRybjsU
	 k7UUH7aOqKx0nsuf85modRyQymnGguI6YrWRufNzQaLNhpNu+a7Ufc9fANPKe5fpgv
	 0VVvq8d8R7E1g==
Date: Wed, 25 Mar 2026 20:56:12 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v3 1/2] liveupdate: prevent double management of files
Message-ID: <acQvzA6xTD6IlTll@kernel.org>
References: <20260325182026.467307-1-pasha.tatashin@soleen.com>
 <20260325182026.467307-2-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325182026.467307-2-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: 4631E1C000C
X-Stat-Signature: np3jf65jgpjk8par71sthpuy7hni5spt
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774464980-870752
X-HE-Meta: U2FsdGVkX18zy6bDkFGMnRBdurAQfyGGUl1lBkg7xMTb8Jd6hy97bjbNdAKxXL0f+9AhTElz37FOnNg2bV9iaZ5y7k8UOefS7hWxLWhZW4VMex8uodCVT37hIFJrOggKA0OOF4CrU5MDOjUNzcMaLUoy3LOLjuoCxXxMS2TEwRCxGnFHWvGhZ0vh8TKZsbTOZSYeWzIJbOuysMBHMz/7hlQAdzcWqfiSIAqGMtulyO1BzbwzNvJZZwDpA9eMFWmMxByFwrr7Mx+r7SfJko2QTGhidoQDBpRIIHyl/equkxheLeRxEkFxvEzp8EizJ2QZJV8mBa8h+2gEygWXw0Ongupe/LgB3WmInD808Z60gjZv/sST1oxLn1H4yTD2uB2NmZjmnn1PGGYACLAbwCo0XcGt/4mhLw+Wj/HQ+itlLCNPIk1+lvfA5kgQTbDEAdsMaY5wJKw0rr/K/9RCaybUQ376pFk+RvYsDKYMyieZAsXj6F14ZUVFWKkzuia4awWDscF2cE8zpXzWSr9ADe3mYcBl87C0lP+Rwk9wlNTeHx0KSrGRLbWsN7f3O9MqqlYB/nGpaI5BWiG9JufX6oVJb1y3VQhECGG9gyAszJfCNx4U7N7KuQY51O7sjKe59RI0V614va88qYUtAa/MwTCTPLJar/uI+PNInXZS2+fb0w3VJQyTz0/zu76L25xjKb59WD1C+ZREx22QZ7q2ll175wfB6Qm0rzVl99HZgGT7BHpOvPZ3C7Q3L/EVicva9vZpokP1RaCYvMvr5CrWdlrHQOrCs2j6IHBDWnANAG72ALkbJhKSRCNUNoUBtr38fcjaXpCZMRk8Vz0J3j85+znzaxpTIYnkhMGV+yoRCykbptxyVYNs5EqAsmY4S5wcTilKDfJ9yQulaBFMffuhF3popfPhzpgzlo0aX1H6kNWhZZNFLrOdNT/dxux1x09ZobKUEkBA0Zc3Mlr5l7ZDih1
 PsGndB5W
 8HFFxGPwF7baHEQXssbMwrw8PRcXZZxxBDTTjFg8xyvXTidlV5TB5wdolv7psfns4uS/YTBfBkQp93YfieKbjiENAt0I98j2ADBEysjCWeSheBwKL6hRXKS0q3ST8u73idpwjwjDsonFRRL4g+FokIrkyaCtWR/KMjQaGzIt9Pmd60VAPxC3+rn7Cwqo7vJ/eYpbyiGf4byh/MwPMJ6v35vZAJg8tTkGlrE3RWmNE3IXb9w2XSeVFoltTKZqr++VCmZx14gpuZHJUJxkdO+Gz/dF1BHAoa7tOb2FlHlpfbSx/+alt6eomWLetCBm7WY7pF7GI3EyZPKMbCxyrPfl9ExH+DSwarEu8R7tnRWgUrLwQ/DY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 06:20:25PM +0000, Pasha Tatashin wrote:
> Currently, LUO does not prevent the same file from being managed twice
> across different active sessions.
> 
> Use a global xarray luo_preserved_files to keep track of file
> pointers being preserved by LUO. Update luo_preserve_file() to check and
> insert the file pointer into this xarray when it is preserved, and
> erase it in luo_file_unpreserve_files() when it is released.
> 
> This ensures that the same file (struct file) cannot be managed by
> multiple sessions. If another session attempts to preserve an already
> managed file, it will now fail with -EBUSY.
> 
> Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/luo_file.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
 
-- 
Sincerely yours,
Mike.

