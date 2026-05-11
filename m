Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0207CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0806B00A9; Mon, 11 May 2026 08:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1A46B00AF; Mon, 11 May 2026 08:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7216B00B4; Mon, 11 May 2026 08:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B67266B00A9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:13:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B0AAA0696
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:13:11 +0000 (UTC)
X-FDA: 84755028582.10.9C518EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 203A6140008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:13:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qSlkMx09;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778501589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qrrUhpmrrpezbRav6XF88sv+CB2IUPx+VmpRhmh/K3U=;
	b=bFFP3BIu5P37/o1HIaN+51czDLnVPz1FytVGlW2SrRTOUNPxXmHrsVYSw77RKBcy0sx++O
	83JnI/VQ09E3xrEVKbQMj6oTRp6pRMDSrhNUXZWknIaoW5yZCwddwvvDJXXOYBnlIj9/IF
	S82Vka6nK1c3abs/DTM0lRNFv7LuGuU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qSlkMx09;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778501589; a=rsa-sha256;
	cv=none;
	b=7GNDfzyoEZLJ3Cu3qQ/hvrkcDE2ZpcY1q42VviZ00scrTklDv6bIDWQikJPBn++FWB+5uH
	Sci2j5lY7Z7eI6q59y4uQRyvdYEta3t/PgGsvnC79PpWnuSXASwD0G+T/QH9vjcek5putK
	ShMLZAwyzDQSUZFqElW+vBR1/cS1yvE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ECB5E44201;
	Mon, 11 May 2026 12:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6569DC2BCB0;
	Mon, 11 May 2026 12:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778501587;
	bh=ACia1fo3j4FYA6Cxli5LduVzIboVeoDpclxkAUCwXgA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qSlkMx09q7PpYOs8E1U0TOgx4LzltEiqjV0To4T92oDu6bM3pMnDy7qV1y11OPQNj
	 WBrZXGKH4R1OfzCvpv8STq9HmW8TdDm+ycGJZeybCFSMRGaVWjw2zuPMgSiz+5Uczs
	 lF1DfYyMJ3vldk4MKHM4lFVoVabV7gKcu48dw7TXdUyQVMiNzQINMeT4L6GgRM0bhw
	 BCElMcg9/z/7Zr2CkhA+3Y46ZINUNc9FmrP/wVR4vG2Bp461LGMryTgKVMeb1k1pGO
	 6OGrTzJrZ5xym27A1ZB/cNmHEeowzT/vWIU8ticpTbGmRmzJQY2G3YymBtZPqxUR2n
	 MK9MJGbLjs+AQ==
Date: Mon, 11 May 2026 15:13:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] kho: return virtual address of mem_map
Message-ID: <agHHzJS7bLPHk1GJ@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-12-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429133928.850721-12-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 203A6140008
X-Rspamd-Server: rspam06
X-Stat-Signature: o7gpurbwc8qthiwxz3rjcrdqzfpfammh
X-HE-Tag: 1778501588-749554
X-HE-Meta: U2FsdGVkX1+xstcLiL8I9iHky4cuOUfgg7SJeA8BIYsgz3ZSA5rlO1tA+UY6Tygp2mPpRZGWC8Ec3BEJWBdqyMhmmtT7z2IM0ToHWgLmNMkMev7H27lfrhgGz1FBGDcTQi1dp9YwW8VIRXiuyT6fYBKNT1DjuXcX6NY1hWPS4+DJlvTz/OYWxdIzjxG4MHd7Gd/Cf5zO2s+u/z8MEBQOImoTuOzs6z3V7v2DjE3SiWVj/3aJC3Uqz10Y2vE0mAwz6/OxSSgOK+W6mjxGXs8g96s6Q3Sa+wXnobikzH0niG7GHAcXNHSe2458GQsfMNS6vM/EiP6WxnbOkoss4AiNueoX9fdGriFTGSL97TWJ4JRdWKARZ9lojN2eFxq6vzv5eqYh1mbYv8IREdhn2HrkvWfKPQdpPIITNkxt4/F7RDRE9q/RT910xL69JxH76jN45vEykGSceLtThN5QMM226owkQJlO6GXIRy5mTlg5jTQ1pkFn8N2FtvznCMgos4qqCAAGA759j+NwvXIYUMvCCdFs42l2zKLBawdjE5n8qf1BGruXMKbp9Vu2/wyTcLsTHa2ceL/vuk3kb7/umkRx0w+e1/62E2V9jNPP5QcBzzHPihpLT1vfOIRdsk/5jxn83vTXzQZ5HlhGl8Fs51uscRW/r51rWH7H9/hLihipTogq1PfLiHry4RNxn3a7QiuKWxrpzHCZWR7A8mqThyQWcPpHq0gVmCvVOKK8jcXvt4hXmd1TwmcZqcJE7bbIRshQm3dQeUn5zOEyxavi69wuH3GDNRPql+Bi9IMEVOZFOsUTVTzgozzZfIXwRtAorIJbcy2QSKUazYbpJgCaxFiXmqai7mNpNJc3AFRfU6o+d8etWfS+W/7enrCU5riy4+oeSbjaJ7OVMnKq1FDf68tF/Bz/y/j1ClH3V+piGp9bfryq5EI2oAiKWCLlBOw+A0pjDnpd+Y/fYMWL95n1wk5
 1fRLGBhr
 0WqLitnkTUZOv6+W4EeWGlaw7hb8pDNzIsDoW5GPLvhH9Ioy0BL0ElbTIz5zYxxDn5f4sHxPFuyQ5dCnDjW503L8TCpzbf2RyNiJM/wwe07XC0gzDoHhMf3CYJNWBSmtIa0dFstGwVq3Xjr3uvYDIpJJr5003kba4DQX1A9XW5EB0iyp196BOj+bDuQQLlUVyx4r8R4ni01zmSOUoAHEUNQxre0GYcggHDpstxCc4XB9AGd2lXHrKDkwumvKBnruB6F2SqbnvVRgTChsGJ7QMw5b8QkTKG3YGsgeK2i6zrjZbpyvzUuCT8ERdHP9dsx9PWiJnKjHVt22YBWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 03:39:13PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> There are currently 3 callers of kho_get_mem_map_phys(). Two of them,
> kho_mem_retrieve() and kho_extend_scratch() need the virtual address.
> The third, kho_populate() doesn't care. Make things simpler by
> directly returning the virtual address. Rename kho_get_mem_map_phys() to
> kho_get_mem_map() to accurately reflect what it returns.

This should be moved earlier, before replacing open-coded get_mem_map()
with a call to kho_get_mem_map_phys().
 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)

-- 
Sincerely yours,
Mike.

