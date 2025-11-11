Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B58BFCCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 16:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 179AE8E000A; Tue, 11 Nov 2025 11:19:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12AD78E0002; Tue, 11 Nov 2025 11:19:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068108E000A; Tue, 11 Nov 2025 11:19:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E85648E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:19:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F127BA70C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:19:33 +0000 (UTC)
X-FDA: 84098836626.15.7852F0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B700614000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:19:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h0wvRDQJ;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762877971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZAyTc4jQWgY31ajcMSQaChND7zm3pdXKP2swcXR7no=;
	b=12DU6ruYeRmAFF0kqa2ZL5Ec8ckL9cRCJ2sTy43oOIyHeEyDkqXAQSMh8CAJn3uwywvLQ1
	2bAFq+PxvXuo7MJnpZQZ5P60r828yb8f6fLJDIR6JSX7deUcRsB0cNLSqkbn0XGnFA0SQF
	L37cdDRyb/HkLuUc+1JgnS39smDnMh0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h0wvRDQJ;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762877971; a=rsa-sha256;
	cv=none;
	b=NY+UBSRBxpw1L/+o7mCIaaOR8Bb1SB8PfA53SSh2tltkPN8XwKGMqPfBRQZqJyfC41ZLZT
	gZPbTU0eBPYncHLbIcuv5ESRBtLDbydRLiGjfS/xErB+UOBBmIUhG8M6easYUhqYBt8ign
	2kwlYcjIIaRqmkAsowkrX6FZcb7t+mY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89D8A43DD8;
	Tue, 11 Nov 2025 16:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F763C4CEFB;
	Tue, 11 Nov 2025 16:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762877970;
	bh=HIzM0iyT3dDoXIUZ+C66BgDp43e3Tu3Z+4PxsInPwrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0wvRDQJj5f5uCXvKhn5dc8STHHQH7StOpxysg6KHMApZLHAkXiz+g41StgoUiu7L
	 iQolui75WDT3w/Vw3J5DdZKOhVbnmOBk0bxL3q/UC3Z0g+ndM0Nmis6J9u9FuPnuh7
	 F4THWpnxR1SBp/EiAOQ75+46DxaWcoedbYxpN/R9UaSxfQkCAvB1iVJbBtrCvsK88/
	 12vqrMa03K5Pm5tNC5+SJ7DZ/Fb+X4hOKiDxqHWA6JVIBa/eT1HlSlIynLYo3zBENS
	 AG0SVd+au4GKdH+xm7vSx8XelnvDUyneSBfqVra5JRsx4+t/HBoqOxnbvrtdE/c/k1
	 aGNaw66gcx5Zw==
From: Mike Rapoport <rppt@kernel.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	dan.j.williams@intel.com
Subject: Re: [PATCH v2] memblock: fix memblock_estimated_nr_free_pages() for soft-reserved memory
Date: Tue, 11 Nov 2025 18:19:13 +0200
Message-ID: <176287786383.1435827.13312587708182229748.b4-ty@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251111010010.7800-1-akinobu.mita@gmail.com>
References: <aQo1VjjQw1OZG8nY@kernel.org> <20251111010010.7800-1-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B700614000F
X-Stat-Signature: utx795y9m5wj3bx4q7thymj97jwfss5m
X-Rspam-User: 
X-HE-Tag: 1762877971-676043
X-HE-Meta: U2FsdGVkX1/Lgzf62s4C+yFlX+urb4P1ln4gVc+K5ihNpbG4ffUq5fevO4wzTmN/QiZJbGCXoU1prg8gQJ9vsJZ/nvHsR3n7Baaj4lEXg5eKIkTJsEbmBl4CgJI2VBI4MeTSIyMDT/MtJuhm5l0M+vv+XFAwRj15QyukOcalevugr8EE+AZHcnoXrkJCpWqiSYn3v/N1ZigfCb4NeTTxs1xvt3+12SMPJbLHacQBBvW0RHi4kPdOmmn9sTttWnY+3FLYwLF1BPlVU+KdeDuxVLAirIw/yjWblsofvGnnAZb9e4qHCWQrLUxIB1znWr8BRglGOHx0QB8wGuCBuD/7qwJw2BhIEOUeNEIdHFYXkCBe7hz2lbEscAsmaCjyCtibr3jzhnBH7sGB47qYnAwE99ZMryA9r+HHvCckmNoIacsk0G4pUbOHOtCrWmNcxiPT/QOGa32SpG3xTsUyJPjTyfe9ncRNNbrBlmYyhTxKOg8CgxypkCLh/qJQYI0cemn91Ex45xaUtXOx0fSv3mL988T309vaqvdQWLEeWPLLYmAdEi2AsL/eTLFMsnFPu9NsDFN6otSpAs06pyNc+eCpuuOLReLuiXkXKGQl9I9j9atnlzFcKyfJZ+xfoibR1j86Ram0Nuhlg3Qh/N5OwjouiNwRFr4BwzMjzaHzInkwqtF+KC8joeebKgOxhW/OyeJzlUof+HzPiS/lRTcMZOv+JZSagrWz3np5tYXxOfFoo+UJH/8yFoJBIBPYJl/f1G76SYlfP746lrFPCf2sRa4RL8rZgR0Ye4dY7ndBh07VW6hZ+LaO0eS2GxiBzrFYM4JzhYoFe/7lgQDOXE+ym77D/L3nBB3B6JcQDGclOkOPlXlaSz9E7cf1c1NvD52AmjVxauFZmYrS/n53NbBsnhhYfcfzDQdm4fA+nDSJNadODsM8JmKoITvkS04y0DdwwHRLO4LKHANOZ4qdJ1k85h7
 iYhVdAB9
 0vUKwJrZTOo9EkUEuIAFukQL7/DBEgH8n0neoM667UCEmslgbw9wH1rBaqS+fDxLi79oiI+XEPCT4uQfwkA7Cebev6v8kAcxPWrIyi2+Y3qYNTU2B1H2oaFBouMLNQnLGmiFiQg/A1LM3JtmpONEtSysYeI4fT7LCNiufhoTR/2gKrbY00rPfc7o01ZqUB0R1kSurVRHmMfO0lp6HTtVxf3BIPqcss87y4ZV57HQpy24aIbbtdt67Z9cz/6lrbTdWEPcCCv3FcDTNseAmoR8pCKO5cnbhGPk2RLhJ3YzzgOWUDwT2kjHyxFT3Gu9KG7sDOOwcsk1S8OP1gwLOny0SOoa1zs/Q5SRCvkggDhrCEvPvudY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Tue, 11 Nov 2025 10:00:10 +0900, Akinobu Mita wrote:
> memblock_estimated_nr_free_pages() returns the difference between the total
> size of the "memory" memblock type and the "reserved" memblock type.
> 
> The "soft-reserved" memory regions are added to the "reserved" memblock
> type, but not to the "memory" memblock type. Therefore,
> memblock_estimated_nr_free_pages() may return a smaller value than
> expected, or if it underflows, an extremely large value.
> 
> [...]

Applied to fixes branch of memblock.git tree, thanks!

[1/1] memblock: fix memblock_estimated_nr_free_pages() for soft-reserved memory
      commit: c42af83c59b65d01c0f7a074e450bbbb43b22f0d

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: fixes

In the future please start a new thread when sending the next version of a
patch.

--
Sincerely yours,
Mike.


