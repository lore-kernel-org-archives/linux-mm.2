Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37AD7EC1E9A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 10:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA7166B0089; Thu,  5 Feb 2026 05:48:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5DE06B0092; Thu,  5 Feb 2026 05:48:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A0B6B0093; Thu,  5 Feb 2026 05:48:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9375A6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:48:27 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4403A1404A0
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:48:27 +0000 (UTC)
X-FDA: 84410079054.01.D1ECF52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 498DB180004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:48:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RQGFSTWI;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770288504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5TaxiC7aAM82PjRddN4PaEpv8xBPtPLxPQ4L7tuRQho=;
	b=qHsWB6s3/6JRL3D8dJlMuKlmCuaGi54MA+4DmgKqbnMtdEP4+1dFHhfwR9poqheXxBXMnv
	KUoJaqx7viTMwgY1UsUqOxDJjfesAmLWLul+Ev5bFPH1BfJiioSf6rqwqy4nh4Akn/RgOp
	EDPIWyylv2FVdu84h+7W7XhbIgK+PRk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RQGFSTWI;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770288504; a=rsa-sha256;
	cv=none;
	b=h9u5j8D/GrPuHLhtCnYP2L5H0HtXWeJSbhejccAUDBiTRozHB+Ewb1bYRFW+lgvuqxWQ/j
	2kkTSwpW7p4YrFMR5CoeIGcNXyze2eqK7Fp4YxEbb/oc2jBJEzBfWURuIajIQw3t0fQBj8
	0XQFTSrhiuR4IuvyTUMI3kQvXxVSqrc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CB9960010;
	Thu,  5 Feb 2026 10:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC485C16AAE;
	Thu,  5 Feb 2026 10:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770288503;
	bh=KtgLQkOU/MenbkJ1CoPc5QlChz0x1XQvAlKnIeE5t4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RQGFSTWIHkOvCNE1BlhUjQaajGN5Yh5b8paoTC6KavtX/e93aV098vEOpSEBCohAD
	 RMATrK4LB/gfZKv3VSZJmG0IrgEfkSTsNSZijh2dl6wTMqP4jrN1SwKlMi4d1B3Oaf
	 LwJX2srGjEWbFaQtj1ZH2joNZK+QS21BO+8/K/noDnf+Tw6KC0KYiWp7KmeecNVbmP
	 9Z/6mOATHxtgUrDDvT3v+WIbSKuo+uIoec7bRTixVSQKvFaVYnAI1ZggMX7wTv5TxE
	 2h7aHCl9lh07X7d+qwuWbpYjfN0TXJTEKJfPomReOtTJk0A4ZG/wwCiQunQyoFSx5M
	 Ff5qmpsDPuLcg==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id C95E2F4006C;
	Thu,  5 Feb 2026 05:48:21 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 05 Feb 2026 05:48:21 -0500
X-ME-Sender: <xms:dXWEaTmF7yFUWQUwHHE7Yqpdz967qXai-r4RbF9ttGBXuUN-PUWpSw>
    <xme:dXWEaege_hDZX_A5jT9tYvXfxG1QWG2duZFZKvSoNYPPsZr7RHHp_jzgGB6VlAW55
    v54naWMACDK6a861LgqhYLGKs2ycHgEsxv8jIfU2IaKoHxm_yxGHaqn>
X-ME-Received: <xmr:dXWEafcudn86K3v7e1-sX3EvBClhFhI132dsYv4fWF-uNGKgRLPW7nguNW4QPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeehuddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeludettdeigfefhffhhfelveeludeuleduvefhgefgueeitedtleffudegfffg
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeeftddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepphhrshgrmhhprghtsegrmhgurdgtohhmpdhrtghpthhtohepuggrvhhiugeskh
    gvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqtghotghosehlihhsthhsrdhlihhnuhigrdguvghvpd
    hrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidq
    khgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhglhigse
    hlihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgt
    ohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggv
X-ME-Proxy: <xmx:dXWEac8rCswMdkOUD8ouc9KOqEyV0XjD5cdkzCno68cOQ6I8st38GA>
    <xmx:dXWEadgQmD84bqhvdJfsPTPCb_aOjJAlzrHqQcQMXcqdbxVpRpq1fA>
    <xmx:dXWEaY_21YuiMzn1Pm0rL99d2AyKVM_iUEVp0YrkV3GbfVptf-RW3A>
    <xmx:dXWEaWCq5d2m3qCBi4KOfQfyp-_ABe4tnq1aK6GIWccsYm_MrPZh1g>
    <xmx:dXWEaaHCKX-vVgOQFNesWeQO7sOwR9G0aDwNem1qAtAFaVIMsPDp4N-9>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Feb 2026 05:48:21 -0500 (EST)
Date: Thu, 5 Feb 2026 10:48:20 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: "David Hildenbrand (arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org, 
	akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [PATCH v4 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
Message-ID: <aYR0vqwyFPo3EKAi@thinkstation>
References: <20260203174946.1198053-1-prsampat@amd.com>
 <20260203174946.1198053-2-prsampat@amd.com>
 <d07cbb96-ba30-4dcf-ad14-0479d6a989f2@kernel.org>
 <70be936e-e49d-4485-8d1e-416fdf8f40a4@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <70be936e-e49d-4485-8d1e-416fdf8f40a4@amd.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: p4qyj1ma5njs7ytsjmyxbmo6a3qxcyqb
X-Rspam-User: 
X-Rspamd-Queue-Id: 498DB180004
X-HE-Tag: 1770288504-305670
X-HE-Meta: U2FsdGVkX1+I3ODqgKgsfG3OfIhDYxD9yV+LV2s3aZlm7nc9yyp/TATyofF5gzH/YelBJWOUgID4j1voAaQv1z5++HK5JTymmEWgND/8QIDZ8OQ/9uKCjw8NDceVn1JgDSzusF54eT/mc62/0jUw4zhNHaEK9kl5Sbb90ZdZjfxutzbvG3rB7bwr/7IssxxpIAuy3BZrM9g5ayhtOerpioANkqPWO+zjpdaMZO/FGL94LDh74OMBsFJb5gWt8ZxPJ1xL1Z5u+CZfERfVrebjsSNjZf73WylM0/mPn0wudjRFmBKChVjaSdVyJf+A4wKb/0Sy3Da/7XeFGBvO11uMaAYY9ThaSkfkayCtJS//5UcSHWpX6XJxpjtdD+cY0gt2657T2x91xFrwFdCk7cM+sGtmrjAR7wUSHvLZ+i1dFrCoc9kKz2RsUBIcL/fkXFOoA1hNtvuGnTYIL0bGdhQS8bjc1csqgiJ0e2nOWygmeZS2PH6o5kjPsfv4NEyVxAnDUmXlGXJjupr5b9TnL9FH7hd0kb7YwcOCWOBzhiBU2lHTH5MPj08roo2wSguTDB24OgM//NYDmX+DN7qBIYtubjZbIuEY22Xhs7d/y+kAs9uSn7pVI90lsbTr9tr2DdzHemnmu9F7c9ASEaqCjl2Reiv6BPN47Iq8PPKQaFQfJj7D82D2bfbqg19xwaF4iz7ZsI7XcoPlDIXCzB7/MEF7gw7HUFbBT+tqBI8e1AsOW65TL6gn6eOP+p7RGxsgwM2sI+mvbGZ+Lq4lWPFZxAkVOrLFBQcOUl7szUmxfaswijLogn6QYANe7OF9o3B6qdulvPiTj3jEDV/ReI7QsM+V6doogwFZ8O9urSC5HT2b7VLFKJ377iOSgwwUA53t7Ht1RVPvdBVZ8WTODItAbynfnNl015AIS3w65WjzZ/hzPEfAT+vlC2SNGBSj0o7YH4D8CfXmn4HeU1NxpEoN7d9
 r1A7WTMv
 ViLA/tcJWLGZqe39ac1LLqGw9LB3aPH+ITKIw7a6Yt34sX/tqEIoU2HcXiv2h5XejiPwqP+R6q5yd6iq7BGm4yzvKEtx322yDnROKvtmJ4LPmAMCJL2ib5fgh6c02/QrSESYtpoF5BezTQTmaLnL+TztErZHn4WaYC7Bglz88Mfx+8EKBhjl3GczWvrhnJL4JB8Rw+SwZg95lYCpmzvnfpAMvu/O4TKM+m6i35A81M+AFvSpijOAqm8I03f1crdbFHG1pRZ3i8aco9HwTMW072eqKBjNLO8+uykNCyfLQnQ+/ag5XZub0OExk08NELgxaB6EaFvawVSLsiktV8Qa1+Z0saoADeG9hRjMH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 09:50:09PM -0600, Pratik R. Sampat wrote:
> 
> 
> On 2/4/26 2:00 PM, David Hildenbrand (arm) wrote:
> >>   #endif
> >>     static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
> >> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> >> index a63ec679d861..549ccfd190ee 100644
> >> --- a/mm/memory_hotplug.c
> >> +++ b/mm/memory_hotplug.c
> >> @@ -1567,6 +1567,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
> >>       if (!strcmp(res->name, "System RAM"))
> >>           firmware_map_add_hotplug(start, start + size, "System RAM");
> >>   +    accept_hotplug_memory(start, size);
> >> +
> >>       /* device_online() will take the lock when calling online_pages() */
> >>       mem_hotplug_done();
> >>   
> > 
> > I really hate that accepting (and un-accepting) hotplugged memory is different to accepting ordinary boot memory.
> > 
> > Is there really no way we can get a reasonable implementation where we just call a generic accept_memory() and it will know what to do?
> > 
> 
> Sure, that shouldn't be impossible.
> 
> The only reason I initially kept them separate is because we accept and update
> the bitmap unconditionally. This mainly applies to cold-plugged memory since
> their bitmap state after remove shouldn't matter. However, as we are now
> correctly setting the bits in the hot-remove path we should be fine accepting
> from the for_each_set_bitrange_from() logic within accept_memory(), I think.
> 
> Something like so?
> 
> diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
> index d11e7836200a..e56adfd382f8 100644
> --- a/drivers/firmware/efi/unaccepted_memory.c
> +++ b/drivers/firmware/efi/unaccepted_memory.c
> @@ -36,6 +36,7 @@ void accept_memory(phys_addr_t start, unsigned long size)
>         unsigned long range_start, range_end;
>         struct accept_range range, *entry;
>         phys_addr_t end = start + size;
> +       phys_addr_t bitmap_end;
>         unsigned long flags;
>         u64 unit_size;
> 
> @@ -44,6 +45,21 @@ void accept_memory(phys_addr_t start, unsigned long size)
>                 return;
> 
>         unit_size = unaccepted->unit_size;
> +       bitmap_end = unaccepted->phys_base + unaccepted->size * unit_size * BITS_PER_BYTE;
> +
> +       /* Memory completely beyond bitmap: hotplug memory, accept unconditionally */
> +       if (start >= bitmap_end) {
> +               arch_accept_memory(start, end);
> +               return;
> +       }
> +
> +       /* Memory partially beyond bitmap */
> +       if (end > bitmap_end) {
> +               arch_accept_memory(bitmap_end, end);
> +               end = bitmap_end;
> +       }

You are calling arch_accept_memory() on every memory allocation if the
memory is not represented in the bitmap. Hard NAK.

> 
>         /*
>          * Only care for the part of the range that is represented
> 
> unaccept_hotplug_memory() truly doesn't do anything special for hotplug so I
> could just re-name it unaccept_memory().
> 
> Thanks!
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

