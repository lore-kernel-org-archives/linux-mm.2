Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30863606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 13:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dqS2EOF3
Received: by kanga.kvack.org (Postfix)
	id 4226C6B0939; Thu, 22 Oct 2026 09:37:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D39F6B093A; Thu, 22 Oct 2026 09:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E86D6B093B; Thu, 22 Oct 2026 09:37:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 141DE6B0939
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:37:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A487E40842
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:37:19 +0000 (UTC)
X-FDA: 85350363798.25.74BAA47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 104241C000A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:37:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dqS2EOF3;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792676238;
	b=5rB1RjR2CLE6ySsXhwgd+c5+gWrH+CVRcBqxnU/AxM9nZ3ANcYOqKamDzOsP+6y1cQAWXY
	ZbHFv97/uA032PnYww0CArqJkmhgZkQdOJ0KUBrA2ewLRKEC1ab1dIAEPe5QrWJ9f3MKZ5
	Z30wsjsS6j6beUUzKOcgBVBJXBdB25c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dqS2EOF3;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792676238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guiJ4aBhyGq0bfn00zMCo/CYuhvnJTZBmGSJvCGmgy4=;
	b=fwnd4Gjls4HQeBal/7lnv2mzZLUYHkrO35A+iWVZdtSqSXetCffnbIRwUH0lnfY+RpJA0V
	5t6+17L1iDMcGvPJU+1RMNziBKokSRM2JtqW+rCQytbAd3CRg+cEVZlUZ4ItwJJwP5ufQQ
	aBcFeHge0+ZoLqQURR0x2m4V5/or9Eg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A534402DA;
	Thu, 22 Oct 2026 13:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AEA1F000C1;
	Thu, 22 Oct 2026 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792676236;
	bh=guiJ4aBhyGq0bfn00zMCo/CYuhvnJTZBmGSJvCGmgy4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=dqS2EOF3Z2QrUBNCDGMnS5+612xBithuHVMX6RMdNLt/jTiAZFsNXQxsIjmPT7wKs
	 teOTq/3nlswzTSfmSx06jQ1I3xxmtH65Ou+qIxRapAkoupGwRbH1YqRi4qEVHou4FO
	 jyrZsPWB4P/TagrkWN0MgXAuFuwiHrzvMZnZ6qpTwYH/Ot97qs+2b3GgX96tlMeIu7
	 W+Pz5xIa05G+td1gZPD3uDV7PC+BeDYDC4rzSjwNK+rfnwsmr5YdyGfgJuZ5k4tChs
	 EAEkheql0xAzkPK5mnd0VVcBwPCHEN0qA/W0cmiIJw3gGI/4MFxIzmu90vum4iJogF
	 FY+Y0HVKNb4HQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Kees Cook <kees@kernel.org>,  Alexander Graf
 <graf@amazon.com>,  Changyuan Lyu <changyuanl@google.com>,  Tony Luck
 <tony.luck@intel.com>,  "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Pratyush Yadav
 <pratyush@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  kexec@lists.infradead.org
Subject: Re: [RFC PATCH 0/2] memblock: keep reserve_mem regions out of KHO
 bootmem
In-Reply-To: <20261021211058.83483-1-azpijr@gmail.com> (Jose A. Perez de
	Azpillaga's message of "Wed, 21 Oct 2026 23:10:44 +0200")
References: <20261021211058.83483-1-azpijr@gmail.com>
Date: Thu, 22 Oct 2026 15:37:12 +0200
Message-ID: <2vxzqzhhg8l3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 104241C000A
X-Stat-Signature: 67uyiwk46s45n8mpoj9wgsxtwrj4m8be
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792676237-295006
X-HE-Meta: U2FsdGVkX19zyVVZ/YL3ARc+DRXuf5/v7bz4KKIMFxYPCLdyMxu3amt+gpIiZeVpLhRZI3pfeoIIGH+/m3xocH4piWxYXzI8xGUUNUdOti6YUIDweFrGUyIrTVEcWfRZIMixTdHQe0GdVJq61hR7WoUXz9oJ1lt7LncLdt4KIVhVNU6Tc3oKjoTUW+o9kilM+wYVc/uKtBc3uKPJISXIimxbwOct6gkMoFbPn1T7NbG25x7xh9kwjkOddktCvIWBrmSVqMj2UeCFjcdsMxLaGcgGAdDY4yADR6e5O8wzKY+VgNtrXqLhSu0+NJgUdFOCDa+58i3h/b2uobbKVwIBbJN/R6R2gMPqI16h6aiE1nyCKPvPNaW4I/3mpI55nUyTtVd2p61oVAJfSa52Lwf3f7/DfGVGcUGZJLpajLIvkmUzsxiSHT9ne09JSEtvRERNIgvc1GiGMBUZdfWARd+wboXo3cdL8kgAS2hBXtJPV6+BJzHTbtTyQ9iy80BTJZCJgcb9ja5ILoUfRyIg2bpPi2mcFwYL8N/V68nmdrZ6kJr8n7eeLs9MSc1zPlljla96HAWsr+vZ41/Qe5Y24/gOXWqXtyoOfaGU0yftC4PftRODy0MS8XihTLe0qZjL4xIlcr3HCZKzeoD+2I1v3QMz16Hm7nXnam0WOt97ubdZCPVLHoY2dEa+nkn8njAZpMwihR6mokTEdqp5UdSziK+mi3Zn/hQ76RMAqC2k6DU7n9vdoKDED8e8x0YKY5lWuBYwXmkj6UedvqhZFObsav/n7XztSTfyFX2Cl50kzEPaI3IsrFplPSFoSoaqK6JEN3keJ2tzN0HXLuqX+c/kBq1CGTyipIO1Kx7KOfgB82IR12HoSYo2fD8Mr9MYDP59BIrmbM1V1jwnj1HNG5AeZRPBKDf313H95+Fk9GvW6+2d8cnguNsYx296gqF8unoF6qekf3RtJCiqr2b9YAVJzcz
 EYplmShq
 rXYnGv66nOsTGUmmghZEEVn1mEKk5XjgSkFy+88vjZDd5Joam7p4z5+FaVZcpVuqdJsFM44i1nkzbRfRFT6kIVn6WEFFGPMfAIVvTDDvLQYy+HaXqej5/DOS16hYfJIPVtslv3hWBIbfahUnN9kHw2IQj8YgZtesnizbkqweIUnJ6WRqDWIAGQHbNYuOWBdusGQ76owFectxFwvlu0V1X0IGe4J6HpFkI8pwOR5cw2EcecPnSjpHRlmM+vz89dl9bMq6RK+km9pyYQJFrx9Q5wiX7SScBt//w81qw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21 2026, Jose A. Perez de Azpillaga wrote:

> On a KHO boot, a reserve_mem= region that can't be revived (new name,
> size or alignment) can be allocated from KHO bootmem, which the next
> kernel boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG preserving it
> fails; without it, the next kernel's memmap ends up on top of it.

What's your use-case? Why are you adding new reserve_mem regions after
cold boot? I'd rather avoid making purely theoretical fixes.

[...]

-- 
Regards,
Pratyush Yadav

