Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7607DC55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 10:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284B66B007B; Sat,  1 Aug 2026 06:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E516B0088; Sat,  1 Aug 2026 06:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B03E6B008A; Sat,  1 Aug 2026 06:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D74D36B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:17:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60A2CC027E
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 10:17:31 +0000 (UTC)
X-FDA: 85052298702.18.1F7F8F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C1FB7180009
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 10:17:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eRXblZgw;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785579449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+5aGxDGH0iNgYnzSVA+SlJSc9z9J3oTNDM4pWcXsnw=;
	b=oqSD90GniCtj3XYyY/aCNBdvgEosRDADV5Hbxxmv4mxYGvqrD9D+JfdAlWNeIqV+IOjQ3+
	OaYbLSBWVjIX1gnIbojuFg02qWWwhPkkunIMIuuG9HIhikPqWHxiPrXxTm+5c/UyJLl0dN
	Pm58UhdyhGtmFIezJzewyY0An5suWlE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eRXblZgw;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785579449;
	b=gxbrr33d6kysmVGLDx+qrre8OmjCZEsG4oTjyVkwnSYRkUCcyAv4k/KycTTMYuFypDziM6
	9d3EaRYaHPyGGX7QD/zJgxkdFR+6yHKxVkImP6xHbVzerpCxYQ7B/vSCvJ0S9sRMwUBEHb
	Liz/dLLNyqFgCyqD2A9FI8Dg/6i2NhI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A9EC60A90;
	Sat,  1 Aug 2026 10:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D01C1F00AC4;
	Sat,  1 Aug 2026 10:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785579448;
	bh=M+5aGxDGH0iNgYnzSVA+SlJSc9z9J3oTNDM4pWcXsnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eRXblZgwhjsc5tv0e/sxHDYm1qF2gtbVq52EbI9UgUKH5ZqipNstxMhnw3WoU6d/P
	 t1VGTSvOnlV1qELlPGBqNPP852gg7c1xkPSQszr4+wFxyd/44AHM04lHEOcq0yzIsn
	 XMFojRNaSuE+W6NAdhax91z8AX98XmLkxme1zQLP103SaOr5f5NhW6vX99oK8mbMXc
	 XtbDzE9evbYbGdyE6whn1RM6aqKslZnyoFHuJVE2J/6ijiqNKtq0J64hyZc7RLRZ3D
	 NTaLxbzHfDPNQm9O9LC8hfUCXeerHPOV0hM6bL32HX7xD496SdNAYdvipwhe5EOKYu
	 ACwUd/gYLFS9w==
Date: Sat, 1 Aug 2026 13:17:21 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH] mm/sparse: correct init section annotations
Message-ID: <am3HsSG6SWz7ZNon@kernel.org>
References: <20260731164758.1210668-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731164758.1210668-1-ekffu200098@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C1FB7180009
X-Stat-Signature: udcra4zrkpktksagx5ci4tpj4aypfuxe
X-HE-Tag: 1785579449-877562
X-HE-Meta: U2FsdGVkX1/qayenmqba2iwfrb15VO94m+qPwWMJzxi9OaKIfVjcgQ33U5WyVvjKZOZaC6zkoYr8xi8TRC5/3q7w+4M+nTE6cyIPBXZBhanaulk9yNOlKDPug0DZMwbVuF4yWv8qAEoz8f5yLh0UoiO4eSTvszl70XOkzh5dvQF4HOItG6CsMzSAoZPWeRW8jiNo//dE+/jAGLM53vE8mpgGF3W1zQ8yzgdlUq8nM8x1OkbKH0HhrFDA6p04dkp3F5ou50D3RT5rF/iBUjl57UG/lUL+gpAXlDZ6401Esk2uHh1x+vA/COak3rfwjHejEYXGs8mf59bBvHw4e7WTinUH51t+HpWXVuyehUfpb2mG3us/U44nud61Irwl+LGToq9oK49BXCuCA3/62ydeVS1ZmmPtYGgSHPTQ3bFenlE3W56Qj5WvLcxpYeKdvYSWiPx4QIpNouIxznTLUT5hALrVTmRKAzZrPHT2uXEhbjCkOiN1Xz4Rg8xFMtF5TRsu2MG9yi7hno3qpTn4sa5vHPPkH4PCFX9p9ZVWvvzUYy+/xgWYSoLT14Ptafv3mA+fuYFnR2BvG7ksHIGJIl5fmyEFQurlCjE7trwr6JZeSkvcZTzV6HMu/87Ock9XK5VJqcm0v3GVuMS5u+e6GfKaEyf/8N7l9OPCGt0dkjw0kHsAmn6ZCueu/H79f1Yn+nJZcZqeENroFqQkXppHuDKCtXizvH722b03qh9w6ks9s7agz+pcKuqcY7zjgU8GQtgbn/fA6UHSAzCVSzGx9fNA28gMvpIEoeYOKMMW1rshQCxEqPuCZt7Q9aDBXDctgkJx+/V3Ht2C10apAaR+isyq+jmZKARvB46QeGuFs8Alc+GX98iw2OiU9HlxIeBCiDX1oLlM68I8mI37s+zco1SBRj9OfseVCdRnX3PDlmy1ElExulmZd0KRw7WOkjNY8oPu2NMCQhIB/pfJL6K3cqJ
 btII+GWi
 0WB9ocIdaioaixgmLoUktWSVXDKUSxD6nYCrSWe1G4OJ+DRE+sZqrkfTGF0+mAkJM02KrtFBqXpLqP7/tfKvEe0mImhGZVQ/CcQyoPJ9i2hnUU+k5KgE6YND7A+1EigjfAnAzxcZLiPPKV/LBzUSvjiacyvyovKp963exsItNKP3SPrLsCVTG0n9mxlbStwX7qp2GNEL8dKDepk+Plw29cS80MauBus+xgu4yjRjtZdVjFduZPtq/3qqJ3NLJQbHQTb3MmyvZxgIkiBeOvukdhVOWKEk+U2iFXf4hgxPFUyxRex0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 01, 2026 at 01:47:55AM +0900, Sang-Heon Jeon wrote:
> The !SPARSEMEM_EXTREME stub of sparse_index_init() has no annotation
> but the SPARSEMEM_EXTREME variant is __meminit. So mark the stub
> __meminit too.
> 
> mminit_validate_memmodel_limits() is only called by memory_present(),
> which is __init. So mark it __init.
> 
> sparse_usagebuf and sparse_usagebuf_end are only used by
> sparse_init_early_section(), sparse_usage_init() and sparse_usage_fini(),
> which are all __init. So mark them __initdata.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

