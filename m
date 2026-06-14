Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 081F6CD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 12:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 557926B00B0; Sun, 14 Jun 2026 08:02:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507F06B00B2; Sun, 14 Jun 2026 08:02:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4456A6B00B3; Sun, 14 Jun 2026 08:02:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33F196B00B0
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 08:02:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1170C2856
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:02:51 +0000 (UTC)
X-FDA: 84878381742.21.8AD905D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0A92D140008
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:02:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RqNkEevG;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781438570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kwzn1hzeGIcRzeJH6kryEm6m63oonjH9mTFa0zzCpug=;
	b=GPNiJVdgMB4enctQ6JjnLf67emBkn9ME9zsUzc6heAXpggh1TeBc5APjqTJCLOWjBqafgD
	Z7zcDPwIscOFaT/YIvNKrjniKXKTlOLmTOSMaJsyQyL22ax1CfyXJpSGg+6XWO7FtwvXUf
	9Mdw+MQB1Fnmc4Iti7QDlnB6Zsgx3/E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RqNkEevG;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781438570;
	b=UnyDkZ1ScxgfOQel23c2TO4GMTvMkzgJXY1GCMokhnsb2GScRqd44t9omkIpPVIMzLkLDv
	Ydd51HfDEYvl2Ky5TUqGPqNP2k3yOALvArtZ+8sSAt4KJQSGsuDkiaTsMKhi4QwjabOcTt
	Kq0WUWzs9BZLIWi8oFyzlNWPcrQwXbw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A7EC43E47;
	Sun, 14 Jun 2026 12:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558261F00A3A;
	Sun, 14 Jun 2026 12:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781438569;
	bh=kwzn1hzeGIcRzeJH6kryEm6m63oonjH9mTFa0zzCpug=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=RqNkEevGhGMmJm9i8JjJw+HFEelsGN9sOdHOkFELNlVTiV2mNeuTULivvU6ea53iY
	 of46hPHggr0DGI05GY3R13xoRQ1NOZeAZJohFZu+9Cd0l+DJH5DNyQC8SVIVx2X2Z6
	 lEo2YZ+V0661mxlaRSg4RizLKmUSGyfNoXVH5JybPxLBlG9Tv9QNgFS9Ed1Mr9SqtN
	 jJO0R0vghBsiiu8GKH1iY6JvvdjR3A7kOzgmyUcxWlYramil2bUksEUl7i0LAPKZKA
	 jrUVOF0sbSStxR1D/HrQZSpg3S9iUmvg6rsCtl9NF1oYCLwiW5dIZ4aVvY5wEUCQ7G
	 dUgHrAzn0YWWQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 14/18] memblock: use kho_scratch_overlap() to decide
 migratetype
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Alexander Graf <graf@amazon.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
 Jork Loeser <jloeser@linux.microsoft.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260605183501.3884950-15-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
 <20260605183501.3884950-15-pratyush@kernel.org>
Date: Sun, 14 Jun 2026 15:02:31 +0300
Message-Id: <178143855115.2123877.12922508735700031761.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0A92D140008
X-Stat-Signature: 45zpzcr7pms9mti11yhh94drrzn16x68
X-Rspam-User: 
X-HE-Tag: 1781438569-929744
X-HE-Meta: U2FsdGVkX1+8lFY+8AsqY4l3TJ6qJ/NPMhs0Mp6qonERC1x7egzzY1edxcOQ5HteYO7ty19OHHU7zen7NRZCwgP3jOSDUu8ttu8qiF/tS6ETHcl55Zul1oq+updRs6KUYO3ikHFbbY+/pJfX90AwrnaM8ByC0SndZTAfaVh+VYgsVq9v29qERXtDYKQ8Db9b/8fhnGORRwOeIcWP0Xe+zDVL8AmheI6NOeNSKfBAm1+pURUD0G7kc5SGarloYp4vB8otrQZ+XGIBu28bXdOys0wesh7GxPqv/a7caXma4BK7erDxlVkGQ+BRu7swhC1xCs4zYrC54uvzdz5mRrRT6CjVsnUKzcGVmLgwDbRChMnUJvb/KP8bzXsDkK/wAQ83keN+C0HNtHSNUh9RIObpBoNtDMa7ZeHVgyi5va/2+oeTKvjPb1Nq0Wc2C+XULFrQF8e5KnyUf1D19UFp73rxZOcpLJSp6xmbKQg3O5ufI8YRpdczUnUallTgMe5tgHHqLyg1JWPEhQvaJN26yDqk79YurIXI0HrJFUTuty8DxYQf1QIIp3dpGXIBrxnJwcWzdNrd3MHw+O0Hj6OhlPjVCV9GjuNzn6jD5lV8sTbhDmQoe+0pPSlNWqa/YHke4heP2caLFjEgSGZa2JLoUq96rcrqGGzRzVSx0JinK1VJ0cSGQnCN6iJzv6kFlOR8n4BzOW2eQdj2ajNnUvODF0kqCPl3amDRR+Jc2fVgpyawx0U7WErSFraYzfcMWdqDIHnvDeXu5NiU7KtQKgLTmxSVoGQ1KbBd0aPUoKqVd0nu13W8iObcVdNWePpFpFyfu/wT1t+dXeB4JqwhHItWuzmwGtaoeIa/IHPJHBIb8obs5Z8q62UwPS78EwIO8GM4++327GW95niNtnmaLRRi1D4LbGOJTpPVwLlseaXZCY48GdltVUy1XAomxByP8c5IzZJ0MxIKWS4hk/Vx86/fax5
 pm6f5WGR
 uY8SeiffgCiTRrHILVMAdrslaASp7Cybv43BV3a6sPxoA6hf8fWKVay1OEMnYcELESQnlQ95KFz6C3txgtheSIFhdDp1Ti0DxI36G+ACAJSzWVm8iwZoCBxKauwoAXsCUFJx/J+oXaFuIJUI6JuDQs2vQFMY7P6xFu33XkVMzvLIjr+zUxnEgzbbkxuTsyN80FSeohrcvrFxcFLA7/pXIf4UIft5Oo0IOGpsLUoCL9Lu0BfmiUv313wP8dAgifv94mKvtnKVB9BWvEXzhvxarKa7YmMMHsibDyn3m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 05 Jun 2026 20:34:47 +0200, Pratyush Yadav <pratyush@kernel.org> wrote:
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 5afcd99aa8c1..546d7ef798b8 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -618,7 +619,7 @@ bool memblock_is_kho_scratch_memory(phys_addr_t addr);
>  static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
>  						       enum migratetype mt)
>  {
> -	if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)))
> +	if (kho_scratch_overlap(PFN_PHYS(pfn), pageblock_nr_pages << PAGE_SHIFT))

I'd move it to kexec_handover.h and kill
memblock_is_kho_scratch_memory() in the same patch

BTW, please double check that the extended scratch does not require
updates to efi_init()::reserve_regions().

-- 
Sincerely yours,
Mike.


