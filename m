Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32F85FCC9B2
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 04:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 299A06B0088; Tue, 10 Mar 2026 00:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247276B0089; Tue, 10 Mar 2026 00:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1499F6B008A; Tue, 10 Mar 2026 00:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 027CD6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 00:05:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9306359112
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:05:09 +0000 (UTC)
X-FDA: 84528813138.23.1B71888
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf25.hostedemail.com (Postfix) with ESMTP id E52BBA000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:05:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773115507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pcPeGPKnK+VVnaKWUE33TzsISgSeurGv2X4aZN4dvjY=;
	b=cxnCiQF01HN2wkb6tF5bNeARlximmKmk01Mdpw7Vr0Bjrj1tsWWaClJYCL1yq9SWABkgEY
	KFZtX7WJit9RMefqALEYSZb9pW4HiZnwuOD2XRwCWS6ZPOMgx/UFOoYXiuN5JVBVNARphw
	BkiMaAUehlcTHtfQxXG4BispU8jQTiY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773115507; a=rsa-sha256;
	cv=none;
	b=emy9xyr8qyTKPix42pnySGvDW4japdbdfdWFI7VZlGwRei4vXkiGcBEESIcUyGB8eHKYX9
	CIehiWL9PgNNhOwoTnx4OW3Or+W9Eh/wHojT8DWZKEwkoFEThqDUAXzD4sFabcbqfJ/oWh
	OkswjEdWxW/DCofhOFfb9l93xh0JDXE=
Received: from [10.213.22.149] (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowADX+N9GmK9phtg2Cg--.5200S2;
	Tue, 10 Mar 2026 12:04:23 +0800 (CST)
Message-ID: <482adca2-4755-4e86-8488-fa2b1a02f0b5@iscas.ac.cn>
Date: Tue, 10 Mar 2026 12:04:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] SPARSEMEM broken on RISC-V; was: [PATCH] arch, mm:
 consolidate initialization of SPARSE memory model
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Mike Rapoport <rppt@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
References: <20260111082105.290734-1-rppt@kernel.org>
 <20260111082105.290734-25-rppt@kernel.org>
 <20260223144108-dcace0b9-02e8-4b67-a7ce-f263bed36f26@linutronix.de>
 <aZytSwzGj24lqkLU@kernel.org>
 <20260309082841-9c542a85-073d-4d08-8b8e-a56621a13c91@linutronix.de>
Content-Language: en-US
From: Vivian Wang <wangruikang@iscas.ac.cn>
In-Reply-To: <20260309082841-9c542a85-073d-4d08-8b8e-a56621a13c91@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID:rQCowADX+N9GmK9phtg2Cg--.5200S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Wr1rZr4UJrW5Xr1rGF1rZwb_yoWxKFWDpF
	48A3W5JFW5Jr4fAws7tw1kZryFkwnxGrW5tF95W34FkwsFvryrtw1vgayj9as7Wr4vkw42
	kF4a9F9F9a4UJa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Sb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwV
	C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7
	MxkF7I0En4kS14v26r1q6r43MxkIecxEwVAFwVW8XwCF04k20xvY0x0EwIxGrwCFx2IqxV
	CFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r10
	6r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxV
	WUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG
	6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr
	1UYxBIdaVFxhVjvjDU0xZFpf9x07br385UUUUU=
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E52BBA000A
X-Stat-Signature: rkdnts4ghwroq18qa6wcg31d9zho4aze
X-Rspam-User: 
X-HE-Tag: 1773115505-538989
X-HE-Meta: U2FsdGVkX1/9nNIA9jFxpdLF8cGgjBoGt9PTC4sNCaQiSD0n7Ii/jjhVCCCgMqy5YV1134lkIIwubYyqjPzgoVMhNmsDZQQbqwVJmCey/Yt/RqhBN6Hfaw0cJj0rUTKbzoJlcWt6eUzk3GYowB2w5M+TzXxFrhl2+TsI5TqTYu3h7DbooUtgWLfg37/r9as7ux6GK9Rs3zcMZXtXLF17SDdrDBWH3+Bh7tl65lfcSZRlJ+s24QWiCGE8ljWDeZRNpnhaizMW6vlutzI2OHmuKx2qvTkHjG7mzibSyCrgf2bA4pbNrAbZoOjjSOIfZwGfO/bHhWd08W8ZRf3HPXMymepVp29clXfMrYGE7GndH3QT+Si1QC76ibbEhKYa5rDsM1HuGcoD1TsomfxO+gVZHt5HG+wU/MEP5+JjrKQZE2xyZEU6Wx1AUoaS63WeuFxIhCcEw9owVIRY2WNRJHT/CH6WsA0SV7DDJyFKJmjY8lTEwQj01PscOYbJAEu3jnjbIbi1YRxJlrBpgvyQD98qUlRUorGhs9gv7/plTcGNfFTFiXHGZWiZ2NkWX3VTo+G5e3v5+ajtTi0SOZoqggHU3CIUtDS6qFJ8oGozDEX3aaGwzwRtSyfi9G37KjkI7Qu5mmRQHh0TGn1mVPmA6Q3VldOHyfG1/aKjhEx/DkIwKKlbgXZ8rcbUuknMS5OFTi79d+SnCAIQ9Vo6ccveYgh3lMdD366Kk56Xp6jeq/0+gmEBBpuXbNEsDhTKr9HhK4SvZV3yQHLNRG/KjlMpXGnXfQBnTeilH+zhyj0o7JwJMV6JIU6X0kDW+j1YT9pKid/VZyEPA+jR0sHK6DOM2oIsptf8O1PrJwc+JE+38K2VKeOi3EHvn46RudnLYCsXSnmBX9Z1uuX+Pti0vqlPWKdwiuZYztDML//QpfVcCePiONeUK0KyE2bJKIhrK29E/NScLWWkjqvwgfP1Otm7EPr
 EK5DxjHe
 R/y+vAj6mbO2FEctPZ2UxjtymjqzGgWNHFx8++aTne4/UjTsxdg/6yjy6sJdHUMvDeD/qGG5v6Tl7qidrP1tr+oT9uWhwtX8u/XFyD1xPSpdgyzOQjC1qK5G2iS83BDEegiZ8chsF764n7WitJBuWTm0/awKM4uzTiChEb3MD/ozOlwqBXKgOvfPgEmFf3mTPY8j+ayDHQq5mPtA4NQQDcJwIow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 15:34, Thomas Wei=C3=83schuh wrote:
> Hi RISC-V maintainers,
>
> SPARSEMEM on RISC-V is currently broken in mainline.
> Could you take a look at my report and the suggestions from Mike below?=


Not riscv maintainer, just happened to be taking look at 32-bit RISC-V
lately...

Fortunately this is a 32-bit only thing. On 64-bit we enable vmemmap,
which means that phys_to_page is also just arithmetic. Almost all (or
just all?) commercially available riscv w/ MMU stuff are 64-bit.

I guess RV32 needs some more love?

> On Mon, Feb 23, 2026 at 09:40:59PM +0200, Mike Rapoport wrote:
>> On Mon, Feb 23, 2026 at 02:52:45PM +0100, Thomas Wei=C3=9Fschuh wrote:=

>>> On Sun, Jan 11, 2026 at 10:20:58AM +0200, Mike Rapoport wrote:
>>>> Every architecture calls sparse_init() during setup_arch() although =
the
>>>> data structures created by sparse_init() are not used until the
>>>> initialization of the core MM.
>>>>
>>>> Beside the code duplication, calling sparse_init() from architecture=

>>>> specific code causes ordering differences of vmemmap and HVO initial=
ization
>>>> on different architectures.
>>>>
>>>> Move the call to sparse_init() from architecture specific code to
>>>> free_area_init() to ensure that vmemmap and HVO initialization order=
 is
>>>> always the same.
>>> This broke the boot on RISC-V 32-bit (rv32_defconfig) for me.
>>>
>>> Specifically if sparse_init() is *not* called before the following ca=
llchain,
>>> the kernel dies at that point.
>>>
>>> start_kernel()
>>>   setup_arch()
>>>     apply_boot_alternatives()
>>>       _apply_alternatives()
>>>         riscv_cpufeature_patch_func()
>>>           patch_text_nosync()
>>>           riscv_alternative_fix_offsets()
>> Hm, most architectures do alternatives patching much later in the boot=
,
>> when much more subsystems (including mm) is already initialized.
>>
>> Any particular reason riscv does it that early?=20

Theoretically, it could be moved by making sure more things don't use
alternatives on boot.

In practice, a bunch of random things call the alternatives-using
versions of macros to check for extensions that I'd say (again, not
maintainer, just taking a look) I'd rather have this be as early as
possible, to minimize the minefield where random functions give the
wrong answer. (Since those are all supposed to generate only a single
nop or jump, WARN is not a good option.) Just looking at callees of
arch/riscv/kernel/setup.c setup_arch(), I see:

  * init_rt_signal_env() -> get_rt_frame_size() -> has_vector() ->
    riscv_has_extension_unlikely()
  * init_rt_signal_env() -> get_rt_frame_size() -> has_xtheadvector() ->
    riscv_has_vendor_extension_unlikely()
  * riscv_user_isa_enable() -> riscv_has_extension_unlikely()

And it's probably only going to get worse as more extensions come that
have architectural state.

>>> Simple reproducer, using kunit:
>>>
>>> ./tools/testing/kunit/kunit.py run --raw_output=3Dall --make_options =
LLVM=3D1 --arch riscv32 --kconfig_add CONFIG_SPARSEMEM_MANUAL=3Dy --kconf=
ig_add CONFIG_SPARSEMEM=3Dy
>> Looking at patch_map it's quite clear why movement of sparse_init() ca=
sed a
>> crash:
>>
>> 	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr))
>> 		page =3D phys_to_page(__pa_symbol(addr));
>>
>> phys_to_page() with CONFIG_SPARSEMEM=3Dy will try to access memory sec=
tion
>> that are initialized in sparse_init().
>>
>> What I don't understand is why patch_map() needs a struct page for ker=
nel
>> text patching at all, __pa_symbol() should work just fine.
>> And the BUG_ON(!page) is completely bogus for phys_to_page() conversio=
n,
>> because that one is pure arithmetics.

"Copied from arm64" was the reason, I believe. See code pre/post commit
8d09e2d569f6 ("arm64: patching: avoid early page_to_phys()") where the
exact same idea as yours was applied to arch/arm64/kernel/patching.c
patch_map(). Evidently riscv needs the same fix.

>> If moving apply_boot_alternatives() is not an option for riscv, someth=
ing
>> like the patch below should fix the issue with access to nonexistent
>> memory sections. But I think moving apply_boot_alternatives() later in=
 boot
>> would make things less fragile.
>>
>> diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
>> index db13c9ddf9e3..89b3c13f2865 100644
>> --- a/arch/riscv/kernel/patch.c
>> +++ b/arch/riscv/kernel/patch.c
>> @@ -43,18 +43,19 @@ static __always_inline void *patch_map(void *addr,=
 const unsigned int fixmap)
>>  {
>>  	uintptr_t uintaddr =3D (uintptr_t) addr;
>>  	struct page *page;
>> +	phys_addr_t phys;
>> =20
>> -	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr))
>> -		page =3D phys_to_page(__pa_symbol(addr));
>> -	else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
>> +	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr)) {
>> +		phys =3D __pa_symbol(addr);
>> +	} else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX)) {
>>  		page =3D vmalloc_to_page(addr);
>> -	else
>> +		BUG_ON(!page);
>> +		phys =3D page_to_phys(page);
>> +	} else {
>>  		return addr;
>> +	}
>> =20
>> -	BUG_ON(!page);
>> -
>> -	return (void *)set_fixmap_offset(fixmap, page_to_phys(page) +
>> -					 offset_in_page(addr));
>> +	return (void *)set_fixmap_offset(fixmap, phys + offset_in_page(addr)=
);
>>  }
>> =20
>>  static void patch_unmap(int fixmap)

The __pa_symbol(addr) case looks wrong - it adds an offset to an address
already with offset. This matches what arm64 did and should look pretty
similar to=C2=A0commit 8d09e2d569f6 ("arm64: patching: avoid early
page_to_phys()"):

diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -42,19 +42,19 @@ static inline bool is_kernel_exittext(uintptr_t addr)=

 static __always_inline void *patch_map(void *addr, const unsigned int fi=
xmap)
 {
 	uintptr_t uintaddr =3D (uintptr_t) addr;
-	struct page *page;
-
-	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr))
-		page =3D phys_to_page(__pa_symbol(addr));
-	else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
-		page =3D vmalloc_to_page(addr);
-	else
+	phys_addr_t phys;
+
+	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr)) {
+		phys =3D __pa_symbol(addr);
+	} else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX)) {
+		struct page *page =3D vmalloc_to_page(addr);
+		BUG_ON(!page);
+		phys =3D page_to_phys(page) + offset_in_page(addr);
+	} else {
 		return addr;
+	}
=20
-	BUG_ON(!page);
-
-	return (void *)set_fixmap_offset(fixmap, page_to_phys(page) +
-					 offset_in_page(addr));
+	return (void *)set_fixmap_offset(fixmap, phys);
 }
=20
 static void patch_unmap(int fixmap)

I can confirm this fixes riscv32 boot oops on QEMU. I can send it out as
a proper patch later, pending making checkpatch.pl happy/happier and
testing.

For reference this is arm64:

static void __kprobes *patch_map(void *addr, int fixmap)
{
	phys_addr_t phys;

	if (is_image_text((unsigned long)addr)) {
		phys =3D __pa_symbol(addr);
	} else {
		struct page *page =3D vmalloc_to_page(addr);
		BUG_ON(!page);
		phys =3D page_to_phys(page) + offset_in_page(addr);
	}

	return (void *)set_fixmap_offset(fixmap, phys);
}



