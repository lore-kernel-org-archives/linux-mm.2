Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A85DBCD98C5
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 12:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBCEB6B00B4; Sun, 14 Jun 2026 08:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94526B00B6; Sun, 14 Jun 2026 08:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0AD6B00B7; Sun, 14 Jun 2026 08:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B9D7A6B00B4
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 08:02:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 826D9A06A0
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:02:58 +0000 (UTC)
X-FDA: 84878382036.30.0995107
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D54BB40009
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:02:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IfMVTgE/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781438576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5TEdRcU1HNGEpxe5iEk5mmqGpDPc+8AZK6bCaNbHIo=;
	b=UvqzFtfZb4dVSS1bXKPReWGPsklcAiaEraNiy4DXfIMSIgrlMI7EtFLm4ziBx77FrY03lJ
	GuiP9z0LXSlf7MKBnQSdxnWj7Nyhl90hb9Ww0WOQGZbcYf1nggv5AlOA32JNJKkJwLM8gF
	Nr4bouTaDJim/jqGbcmixOPI5LFsTIY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IfMVTgE/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781438576;
	b=jJ64efyJMwNuQ7R4kDPUKorSViTwnOtrhk0biPLmId6kIb5PwFPqmsKUTiD++u3mwa9uWE
	9FntmmnRMwIyzbM+LZytFJjGludHx065F/WcKbdlEJRrRvA7Pxz4mz5wAvjJYoc9PuTgyt
	nO5/lD0ewL6PNPcoxMcY8UPk6oDghvg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5FA22601E2;
	Sun, 14 Jun 2026 12:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB4F1F00A3A;
	Sun, 14 Jun 2026 12:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781438576;
	bh=J5TEdRcU1HNGEpxe5iEk5mmqGpDPc+8AZK6bCaNbHIo=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=IfMVTgE/4qXI2cKR0GiZUoy1hcqZjKxQD9Ge7/d/1Nd5Lr8JaiLmAXIB42VO3ZUC9
	 PpFfv5WcH8uQC2D76eecRtkapuGD2uWmrE1CMYrxIkCu8WT2eK0yEQ3mIdqEdZj+E8
	 rOI4qVLNNFrCK58h/BLJ8Z45HgvxNdEg5k9gbyMMnwwVkcOYk5fsdVwPVemHuTdxmo
	 2rlphDI4zjcCN2VcLn47n23fex86Rjb6BFrb2KXg/AJmuizeVOdfx6g4s4Ogy2UaW4
	 xqOG81hztDTG/+9QmA2ASRi9sFFiNd/rX4ykHKOHx2EHtJoES1NwwSzjZ9TPzoTRi5
	 X2Xe7iBh2EUgg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 16/18] memblock: make HugeTLB bootmem allocation
 work with KHO
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Alexander Graf <graf@amazon.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
 Jork Loeser <jloeser@linux.microsoft.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260605183501.3884950-17-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
 <20260605183501.3884950-17-pratyush@kernel.org>
Date: Sun, 14 Jun 2026 15:02:31 +0300
Message-Id: <178143855120.2123877.5431342391381982046.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D54BB40009
X-Stat-Signature: x7jz6fz7zpaa6hb99p4fgz4spqjecrs6
X-HE-Tag: 1781438576-96512
X-HE-Meta: U2FsdGVkX18qxpq+mGXmmnalZ62e01GMVcs4VIdoBfLpmmKzziKV2o76jCTTld5vD/GEXOFs3fxPg8ZcvUYw786BKYHqLHWkHZyNHhTrTCyeeEFsNxNzYxxoj4Ybsn7X4yjydYUmlXFm85hgLnjBhYHGCwFNfIqtdN40XUWMfvIKAxYgLwgjBXU9XRu0icomQ98vHhzTLHuq1fiiSHRLCKNVBmrGzpAbtdmFcMrlbIYLfaqY0I3zzlNhq1gSAog6SLVWVSSPPqgiKzA2Au9m22DzTjJZxAWc6OqVYWfmH9G4GGMdCLU4e+kSTqc7HIIerHVqKeR5tEydtD0mjTbVclL6CSLLCzHNOI9/i4vMKp5UTu3orVduWCcx3WkBymbqU4xdClC/lQtsg77xivtpBo7mb33ELVXakxPMqfaskRC8JNGU9NXPBrsvTRYbHW0GU9S+CNBMFV/r0gj+7AMCg8lMiJSwysUdsi+Y/Ra4ZLphQu/IAtvasRDHjYqga4vOdFmxyYwpGF9GCdZQVfpjWuW/SPZP1WNVfEAXT0i6uxBNe1zB3FmTX8IPHjYsIeM9HKheJ55LXQ+e3Mhwa/8x1CW53J9S6y9xvAgvIx4gCwiNrJXw2tv/wEnfzQVJPSdI76cmbw6Kr3hLH0WCd2QhX2bjq3fpS45Nuzx1cO/iEvvL3XOpJGW97Tbs9Io8JvzYNzwJ++EMIRfDt7z3yBYgPBBA6K9VE6I+rhSvCpSXaNst5pSjdcsbcqv2+j9zYAMsu3WhrvgNlXEc4QovTX273GksCnZQ1U2aOS4mDV9soHGetocQ4HJsGb4NlVvAMcytcAEu6Ld0RimtUjN2WwkjDiJLmTFR1h4PV+7jYM0NnwXvQ0IFO2tKxKc+7r9zmCMaMfcIT8ZSBspIakKzLTZC1gQ5B6sNiE5ZdRX3BoMB4/oWDr2jFXuYiV7H/i+La+kc+lXUkHFg8+5EKaa3KXb
 Ta+ldR/x
 Zz5M621ZBbn2oqbiSr8ocJ/Hw2prR4a46L9iE2vWAISFbhcceF6gVQ0D0WYBvVLKYCnnEOonksYZgLUJMoUcyqd/srm3uNq6yYitEKpoP46h9ifVox0uvOnQJfOcX8cFaBfQGwDZgF/YOaZsKtTLVY1+h3kQGcIbEdiDXgvleO1a9wxbDd5VkrXtSEbDOJIode0Skmj7ZNR9Q5cnOOfOsQ4wtzej/f5Qe0f5Rbo+s32CBMz7YevIg7eLlxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 05 Jun 2026 20:34:49 +0200, Pratyush Yadav <pratyush@kernel.org> wrote:
> Gigantic huge page allocation is somewhat broken currently when KHO is
> used.
> 
> Firstly, they break KHO scratch size accounting. RSRV_KERN is used to
> track how much memory is reserved for use by the kernel. Since
> alloc_bootmem() calls the memblock_alloc*() APIs, the hugepages

hugetlb::alloc_bootmem()

> [...]
> First, it does not use mirrored memory for hugetlb. Mirrored memory is a
> limited resource that is best saved for kernel data structures, not user
> memory.
> 
> Second, if the memory found overlaps with KHO scratch areas, it discards
> the memory and retries.

This sentence is somewhat hard to parse.

>
>
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 6349c48154f4..131e54dd5d8d 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1756,6 +1761,69 @@ void * __init memblock_alloc_try_nid_raw(
> [ ... skip 51 lines ... ]
> +		if (memblock_bottom_up())
> +			start = addr + size;
> +		else
> +			start = addr - size;
> +
> +		goto retry;

Hmm, two goto retry don't seem nice :/
Although I can't see how to imporove it really.

Maybe add a helper for going the node fallback?

-- 
Sincerely yours,
Mike.


