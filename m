Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF16C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE5C6B009B; Wed, 16 Sep 2026 08:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E386B009E; Wed, 16 Sep 2026 08:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA49D6B00A0; Wed, 16 Sep 2026 08:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AACBB6B009B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:18:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 468F1A06F7
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:18:59 +0000 (UTC)
X-FDA: 85219529598.16.8DB7118
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 35F67A0006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:18:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4f3aphR;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789561137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g3nJkuOIIREUaA/BODadsUt0oMvW89mcTSVk+TBxQTM=;
	b=EY+eKBd6ATBguBOUPW1Y8jt9EQQyxLq8qSWUd7YnPteywFWEdOT2vTMdClFnAz4XU2UFTa
	7WYWtgQbkSbDgcNs0c7tW3mnkcgF7SCeMnF3fSKnQ2YhfFRLxnfd44ZHKwMgF5BJUZ6QOS
	6SugWEX89Mb2WM7KPbtLVYdKNW55cpk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4f3aphR;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789561137;
	b=Cm8Huq/+uiRog8ljxFAQeo7HjvKdRTisWugGNIKM3v5fWC2sdNis2j2P75kvLUUCf/CKxO
	E3N8SBNRo01Z0bgeM5CsXDuo1iXaAJMPTCJ4uh2Ofla/SUti6urHoK4Wwa5TykKcwEeb83
	d9pWF73N5bvb/UMslFGRoo5hS2xI1FQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6861B40231;
	Wed, 16 Sep 2026 12:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2ED21F000FF;
	Wed, 16 Sep 2026 12:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789561136;
	bh=g3nJkuOIIREUaA/BODadsUt0oMvW89mcTSVk+TBxQTM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D4f3aphRbKTCYsr2/YdXXnNmP/c0zn+7f5CJPLOJU5Ag2ihsF9YAuf/mxPe5qbWft
	 RuJi+8IW2fqsg2OF0+gmzWHc2BZ4j4PTjyLzOz6AXC/PLF6S9HdJruYCs9q1aBBa08
	 8ZHvdqKz4yosb2VOnkK+Ge5a3oc1M8xppXnjlaquXG9GOt81jNxcjCCBLr3Ao5sI/6
	 BahavSPx3iHj0YFmmT9k2mAHR+8Qz/8CGxdMyrpN7ANNhao26Bl05UJf0Ue5Rfo74u
	 /bJEB1hlV/SynllZ7gk30FFmaNk7xpCzcneGOvAY4XI56CwUaA/YCw+pHaapShTTsS
	 Z2H/oC/TGFtGw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9C3EF1980047;
	Wed, 16 Sep 2026 08:18:49 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 16 Sep 2026 08:18:53 -0400
X-ME-Sender: <xms:KYmqalRLUKQ46xVHQNAqn_SpMCWEJPEnVGHPtE9pzFa946VuffulsQ>
    <xme:KYmqasdqqQzLLGbURN2ksP1011QzixMMfmpF8lNUTzKITQDDUxPPxIKCHfuAtHzHK
    HePpXZVWutif9vuPFKO5v9KU79xJFks9D-SgyH4nfh2k-fblP6MxBcb-Q>
X-ME-Received: <xmr:KYmqai4oFAoRIup95gPn3oxV9GZR0bmPcVh4y3t-o5HV8Kj-6Zg9KNTuehc>
X-ME-Proxy-Cause: dmFkZTF/htPXCt3Vp5AMDzX4aViluNR37AwoAasTR8iHLjBZ9vB+37s09E5FAj3fIBktXf
    wD7jyU9p9m8acEr6Ra3scjJrTilVkEufiTVp8kg6W1u05cirw+hDmrgiY3yqIDsNCGGy4Z
    NhlL2XmoVVdXSi7pWEyIFPv29lkrmEA3vKS966LaOo5Roq203cNGaURFEmJuo4rr3dx3pl
    zRvPBAEFOPc4BaV8VgR4olkNsATDKNUJ2aL3kSE+ZeDgohHMV8NuWlBUr1Y7gSpUtMk43S
    pHxrvHb6UYaqOu5IrjHeg8msBZNq9Ws0Y9sYF6moF2neMeMXhIcDUsNMr5TA/1SnWdrbnv
    krg8yzA58Iyw1wZU0OAObVQ8m4UiYc1907t7mzYhwQjpudg0+8QPH1YgpeY0d8JMVdr0rE
    I5cdBJmZizSGHOliBIKAT49rDuCWkjlzVhcGpA/FSylhtI2vOZ35amP2Bpu/ffULhom6KK
    mAFZrnyuq/2DovcPoXQKkstvBgE4kd6res0YrZ3TPJzPbjo01wcRbJyjyMarV3bBWIRJ2U
    /nfjKeUYZx8uSLHmxv0YkpN2OTgeBBvRg8w5ox13JY97RAKWHu1XAFS+AJFTFFrgA3BMc9
    4qUEfpEZPGPotDW9vPvWAQY4X3sf4al6PYefswJLQwFlMv/gcWohOVdYNR3w
X-ME-Proxy: <xmx:KYmqalZSh5ALRNUk-yGxJZtajzA-EP-yYLtuDHVayGKZTkMcKh7jSg>
    <xmx:KYmqalt_kssyM3YMu8dwBID1pt4VvyP-Mkj4cux8cj19ZAJNXpj0Vg>
    <xmx:KYmqamtGLQwsCpo5AynCQsRx8Mzfx9LtL8HamC26SVKkpQEEcWC-6A>
    <xmx:KYmqauptDI-qdtg3rUZiebczKcGTquH5dulg1Jd6BPm1F5o5OVxSfQ>
    <xmx:KYmqat4kHc5k7IM1jrC0PaSyoI4CLHsuMRGImK3xFqk2X2jADcQ2D4xX>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 08:18:48 -0400 (EDT)
Date: Wed, 16 Sep 2026 13:18:46 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Zack Rusin <zack.rusin@broadcom.com>
Cc: Borislav Petkov <bp@alien8.de>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.makhalov@broadcom.com>, x86@kernel.org, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, virtualization@lists.linux.dev, 
	bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org, Christoph Lameter <cl@gentwo.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Bo Gan <bo.gan@broadcom.com>, linux-mm@kvack.org, linux-arch@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v1 0/2] x86/vmware: Share steal-time storage in encrypted
 guests
Message-ID: <aqqGUAX65s4LdJkr@thinkstation>
References: <cover.1789488039.git.zack.rusin@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1789488039.git.zack.rusin@broadcom.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 35F67A0006
X-Stat-Signature: xk9zbfz8jw5tft57fyjckx5yognefqj1
X-Rspam-User: 
X-HE-Tag: 1789561137-338820
X-HE-Meta: U2FsdGVkX18pi65mhXBQL61oNcC0swWxvyqDcDYJqOLTc+QvuLqGoxZzAmMWZSr6sAQD3+1jb8701tteMbebbzCIf0NZSXUDwqJPmBGXkWakxmzRC7XeJZwICqcIdzzrGtTWaXYBzsg4G1Q9I8LHqEAHBISPzNcIQcKRzmimvn5KGmkgHpOtm9DebtheVQO4opcOvgkopLEqvPDya5R3iiC1D/mE1tmH3FZIVitd3TQKbVn/NoUupFOMXHUNyuhqIabhu9zGPSmDZBL7Q6d7y+7zUUiHVsKP8Ih/w8ygRbKUwgdUJqFvY5B7pl49RYAJ056ARboMbi5IFTIOMkjcIzLk02xc1Zw6E99TxZND/GsTPa+tU1RYCv/tm9lREja1kEr1CItSC/i7YDg8djNIUtnkT80gzfHD1DzDit6WD/Lqd3fjHhBijLqh8PiVlWwx5agAofjlElXX0OCSsCJQGj2Gdrd8HVT3kSPM+KYwNZ2wDuqwBuiEqIxZBeWPBIlORFGZ9x6oWBHxkqYXPzJaamHwQpH/kF5/zXfvzviOswQaImLMddX0eZxDSoefz5TIOdj42MsBE8YW6iVezjaVRgc9Jl/nG/KUE65FhasdCL7aXjgBlnIU9clWBS/uUwLHWERHroYIZAus7b0r/M3bf8f1J50kkiY3BYdvqh8Cw3RxVgFsZ+7ENRR0s4f5YgLrkk8iKKfaHxLvzUK2+j/rw062Ryss4eVQtHXzAB2H5++vrCdfDGCmkaRgE1ujn9BeO/difZA5C8SaRJysj9Zxu5vKgHbfCYGayF8UZSI9SuLOVr3BVOIlXqcbRxoS+h8Eu+ooXzLZVa0edCZCEXqWXZ2MhiPEJdcPc9ibaEfv+Kr9bzJQkdeMwdi4J8siDi8M11+2MWVQFB3VpeUWI0iphoKFt2nkttDKzTWXrwnWHWe2ky9sHUeXddm18o+DikgZMiHlyoTOZOyGbYJY+uz
 DkrI3ooq
 qkmIJz00wxmcs3wRXXfIPgmAeAJASigp1RJX3ftc1qmE8AshEGXPJC5dU0XV/qs5PVaj8zKdMwYlxvg4AZmChsVESaqXWv92qXZpmgI5LurobkJ9Va0+jn3BbEMGT371zQasz1HNbBWrTTJgYVstkp71yRdnEqllbCprcdthATVdwBnzO/s5ajbyQqRTifHZ7+DA6lFcbCGLVSUISsRPaNre8Pia27xwRz8zFgb93pOtQi/uMVKVmWt34O+wOiCvS1OduWpfOK4dWJbsZaui4PBBtgS3T13Cf+vGPTendbj7gDqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 01:05:38AM -0400, Zack Rusin wrote:
> VMware registers each per-CPU steal-time GPA with the host. An encrypted
> guest must first convert that storage to shared memory, but the existing
> setup publishes the address without conversion.
> 
> Patch 1 makes the decrypted per-CPU section available with
> CONFIG_X86_MEM_ENCRYPT, including TDX-only configurations. Patch 2 defers
> encrypted-guest setup until allocator-backed page-table splitting is
> available, converts every possible CPU's storage before publishing any
> GPA, and attempts to roll back all conversions on failure.

I acked 1/2, but I don't like where 2/2 does the conversion.

A variable declared with DEFINE_PER_CPU_DECRYPTED() ends up in a
dedicated, page-aligned linker section. The point of the section is that
one place converts it. Instead every user does it itself: KVM in
sev_map_percpu_data(), and now VMware in vmware_decrypt_steal_time(),
each with its own vendor checks and failure handling. The macro today
only buys page isolation, not the shared mapping its name promises.

The underlying problem is that the whole "decrypted section"
infrastructure is built around SME/SEV and was never generalized.
__bss_decrypted, early_set_memory_decrypted() and
mem_encrypt_free_decrypted_mem() are all under CONFIG_AMD_MEM_ENCRYPT
and implemented in mem_encrypt_amd.c. sme_postprocess_startup() converts
.bss..decrypted only if sme_get_me_mask() is set, so a TDX guest never
shares it. 1/2 moves the per-CPU linker section to X86_MEM_ENCRYPT, but
nothing that would act on that section follows.

Rather than have every TDX user reinvent the conversion, I would rather
see the infrastructure made vendor-neutral: boundary symbols for the
per-CPU decrypted section like the ones .bss..decrypted has, an early
conversion primitive that works on TDX as well as SEV, and a single
conversion of both sections at boot. Then sev_map_percpu_data() and
this driver's loop go away.

> TDX's conversion callback uses __pa(), so patch 2 preflights every possible
> CPU and leaves steal time disabled if a TDX guest uses vmalloc-backed
> per-CPU storage. This covers percpu_alloc=page and automatic allocator
> fallback. AMD encrypted guests support those mappings and are not rejected.
> Supporting them in TDX would require a separate conversion-API change.

Refusing vmalloc-backed storage on TDX is the right call, and not because
of the __pa() in the callback. Converting a vmalloc alias means either
fracturing the direct map or leaving a private direct-map alias to a
shared page, and the latter is a guest shutdown the moment
load_unaligned_zeropad() steps into it. See the comment in
tdx_early_init() and the earlier discussion of the same idea:

https://lore.kernel.org/all/xqi2bkulnhen2vax5msbzczlaywx3dsc7ezpn7oo5qn7u7xzap@xmaseinov7tf/

But that decision belongs in the same central place as the conversion.
If the first per-CPU chunk is vmalloc-backed on TDX, the decrypted
section is simply not shared, and users see that, instead of every
driver re-deriving it.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

