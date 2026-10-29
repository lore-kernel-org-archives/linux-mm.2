Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC464606A320
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n039RvLz
Received: by kanga.kvack.org (Postfix)
	id 0303A6B00EF; Thu, 29 Oct 2026 15:42:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23536B05B2; Thu, 29 Oct 2026 15:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39266B05B3; Thu, 29 Oct 2026 15:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C4BC26B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:42:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59449A053C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:42:41 +0000 (UTC)
X-FDA: 85376686122.03.0395EBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id AF6011A0007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:42:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n039RvLz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793302959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5BOmtE/8D5RrPoWo6N/EKi/wginAI3FukwfrzZJ0T4=;
	b=gdCyDdVc9Mm0fsgpf5yIJv/T1jeOy+0S48h91kV75TqFwN5nPYR+IfA78K29HpvL+Ec5Zx
	smzxoNHHl0nrjK7UGkj5fAQFPzGIAbtU9j/RZ1t4194I/1ZmzcaThaxKxEJLhvrQEr4FJV
	lSWP7lCRVnwYC9xU6ZSc5gmRwMo69Ig=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n039RvLz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793302959;
	b=RV+ssDiaf32evPRsn29yKGGlRdqyvGRNxUAG0VC97y6O9sZFi7WaVJZkYZXqcOjKTiXyFy
	P3t/5FrEK0Vt9V19GhzjyYawtq2qfyZdPSiuzmJbrfzRlwURAn8ydzHd7RODfjTEeGHHIU
	Uzb5uPIPRNd3dQAS8DO+ySBbHS3+t14=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DDA83407B0;
	Thu, 29 Oct 2026 19:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BE91F01816;
	Thu, 29 Oct 2026 19:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793302958;
	bh=M5BOmtE/8D5RrPoWo6N/EKi/wginAI3FukwfrzZJ0T4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=n039RvLz2MQBp9BfxMGzLnlsnUbqv3QH+HRwNf04y8I98V0PpNABrMhrQJMeaVmvi
	 3zd85eM31AJtqMMB13jFkSzHv20sMetPAlDdCrnN+gI7jS+LzruLhraQXgfy47gOTT
	 wpDzerJy0E9A5ce5AyJDoETbe3jRVDdWzHquTqzoqF3fmvcdz0PyWTAygUO988r7Re
	 Dfc0Ff9jntdVerieMBs8hG4DiJnjUPBGUKeH9lxbkdygoBOOVImf8qmcqQVIOKmaO7
	 aLxl7AN2nZfGozNkzCESmg2v5yIhJ/KpKEP2Bt8IAMYBLHSy7y/tY1SFFm/cPJ17Yg
	 pNfHWjm/hb5jw==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Ard Biesheuvel" <ardb@kernel.org>
Cc: "George Guo" <dongtai.guo@linux.dev>,  "Mike Rapoport"
 <rppt@kernel.org>,  "Pasha Tatashin" <pasha.tatashin@soleen.com>,
  "Pratyush Yadav" <pratyush@kernel.org>,  "Huacai Chen"
 <chenhuacai@kernel.org>,  shuah@kernel.org,  "Ilias Apalodimas"
 <ilias.apalodimas@linaro.org>,  "Andrew Morton"
 <akpm@linux-foundation.org>,  baoquan.he@linux.dev,
  ruirui.yang@linux.dev,  guodongtai@kylinos.cn,  "WANG Xuerui"
 <kernel@xen0n.name>,  "Alexander Graf" <graf@amazon.com>,
  liukexin@kylinos.cn,  loongarch@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kselftest@vger.kernel.org,
  linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a
 configuration table
In-Reply-To: <2382a0ee-cb6d-4572-be6e-ce3cf4d006e5@app.fastmail.com> (Ard
	Biesheuvel's message of "Thu, 29 Oct 2026 20:28:01 +0100")
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
	<20261029172956.20791-2-dongtai.guo@linux.dev>
	<2382a0ee-cb6d-4572-be6e-ce3cf4d006e5@app.fastmail.com>
Date: Thu, 29 Oct 2026 20:42:34 +0100
Message-ID: <2vxzqzh8mgyd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: AF6011A0007
X-Stat-Signature: smue4t3mbybyirt81bqo5itwczfj41pc
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793302959-775796
X-HE-Meta: U2FsdGVkX1+8yRk7mMVGJ0VUBuWGWBZx9i7bQpoTpgnaYwDtEjYEFjZJEFYaER1myNUsI5UyMAPDmsEDC0bIWT/0rRCN4k1++SctzTzrCNzdmw5MkIen8Xwfx1Vh9Lw1muTTUdT2lUKPWf3dBlYTJ+5e3q5Hgw/bwOmdqAZ15/GBNMjkB7uhL+sF95AdL3r4ED2WSpLI6toBKuk15G84aBanG68QoF/RwIRnLtitZs0O7caoxxu0xdr05qCOekS14dIBCXDpBdeRLcS5lM3FL0H3HB+kibCHDGo+xyrWmZ2tALJEmjLEwsE1/QU0rTiiMjMhwu2cbENXmI8MDr2ve3pEgdCh74NmBnsFCJPw3h2wZZVT8UYFHuem94b3T2GMbsZ4Yki3owHCUZXNWnSXh16Eakl5mh/eDiD1v6DBIpQBuEyZ42r8Qp0USrvSlzA+VQBL24G3ELWlfi9YenlK1YeW/zutcqvSo9rJibDiF7LdsWc/6bSq31SWUxrL9PIeMXr+ZX1Oco5yrZe12LjNDxJWAW+vs+DUMRoHkKeuRFEQ6JnYIjzgH0qKkvS/PciM/65rhdWGNGqihF71GQgSyjw6GUQgTamasJv2zyTuzc8f9fYI365SMOTLdeEuy2S81o1rip03deGurXkZZIdqIj1AK4JjAy3uhN2UTePShWiNnYgRD0rUpfDc05zfhH63e9TwsSbmlgttFeqbtqeblrboKb/bMFtrHhnq1rghgNhBBpsDPsXfnhTwisT3mwNLOMSJic3Fvz9Ic9xJIADHUxxkcduAhwv2FzqYTr/aor6xWGcC+ApLJ0uMy80ZVOraWgrKwS5D8FvlgVRTrcttfqtY+b1Ik5kbocNqA0GG4nCz+1nb/Yo1CfIRNISN3r+/3dKVXdC4tBH5mMUzCEScVWviunJ0sftzrYgcofT/ulaT9tXWc2PLI3cwIK0ImY1Cwiqk/WlRwQTkBfx0Fwt
 6PmiBCUg
 HF0CgfSZ2PUAnR5fY04jrYgTYJ73RQfjGytF+EJJvqqLt13HhejkFAu1eGOxOvnHlZkhzIlPwjC1ar7DXj/xbbO3HsWj7ENfIa8dxyjWd11zsAHfwU4HgHJqHPN68u4bZ9UKIAeP2C87h6hDEs88lUDqItev1kqcnF1I4q+Z2CHJeGIF6n14Zjjjhag+eVj4CNvWl3ZopNYk0l+3qYpmaapPXHkZH4Z93k1cl98fqg9RGaFjT24pA01Kprw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Ard,

On Thu, Oct 29 2026, Ard Biesheuvel wrote:

> On Thu, 29 Oct 2026, at 18:29, George Guo wrote:
>> From: George Guo <guodongtai@kylinos.cn>
>>
>> KHO has to give the next kernel two addresses: the KHO FDT and the
>> bootmem area list. arm64 and riscv put them under /chosen in the boot
>> FDT. LoongArch systems booting with EFI and ACPI do not require a boot
>> FDT, so KHO needs another way to pass this information.
>>
>> Add a Linux EFI configuration table for them, under
>> LINUX_EFI_KEXEC_HANDOVER_GUID. It points to a struct linux_efi_kho_data.
>>
>>   - On a cold boot, the LoongArch EFI stub installs the table, zeroed.
>>     Each kexec'd kernel is given the same EFI system table, so it finds
>>     the same table.
>>
>>   - In early boot, efi_config_parse_tables() reserves the table so
>>     neither the page allocator nor kexec segments use it, and calls
>>     kho_populate() if the table holds KHO state.
>>
>>   - Provide efi_kho_update() to update the table before kexec. Map the
>>     table during boot so updates do not require allocation or mapping
>>     at panic time.
>>
>>   - efi_kho_table_found() tells architecture code whether the table was
>>     found at boot, so it can turn KHO off when the table is missing.
>>
>> Only the LoongArch stub installs the table, and only with
>> CONFIG_KEXEC_HANDOVER. Elsewhere there is no table and this code does
>> nothing.
>>
>
> Can we handle this as an arch table then, and handle everything in
> the LoongArch arch code?

I think this is useful for all architectures that use EFI, not only
Loongarch. Today Loongarch is the only user, but this can very easily be
used by other architectures.

For example, I have been considering moving x86 over to this too. Today
we use setup_data. Once we get EFI support, I would like to get rid of
that and unify everything under EFI. It is much simpler to have a
universal way to pass KHO payload over.

-- 
Regards,
Pratyush Yadav

