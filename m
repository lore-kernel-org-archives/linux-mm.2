Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48650CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84826B009D; Mon, 11 May 2026 04:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C476B009E; Mon, 11 May 2026 04:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9719D6B00A5; Mon, 11 May 2026 04:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8407E6B009D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:59:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E4D24066C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:59:43 +0000 (UTC)
X-FDA: 84754541046.13.ED05F61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 35D9D18000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:59:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uC278g/6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQE3wpLqYzkqVVGo5IykdkJujhJiTkAzNCjRXn40AUE=;
	b=ElzjmOL1zWhQ9y2Un7J+rFTCdAhODK4ap+VfPRbveU1aUGfWSFHxeDZQmb5Erzsbr7h2wj
	D9CVtGdIHhBJGUIDF4cfOhq+eq6svsNOEJQPuqtsqpV3bj/sw7VA1746VyUGL9PWPXEi7X
	jB8VXfWUwlzs8xoJG4LexaIauNqMARs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489981; a=rsa-sha256;
	cv=none;
	b=xnsxzWo1NaOdHAFtXqFGZnkmciGLsfIBSugVarAh5Y9X9SULevTng+NZLQJE4skOTvJc7p
	6ZP5lgjQ1A827Z4Cm4IhBpiJGJJkjPy+p9RlDTNOHDCfVZbplFRe9NtZeV3UOzMsZ9Apje
	GcujIEDCej5uZYvxfl0At3CM/op0dzM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uC278g/6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 884C3600CB;
	Mon, 11 May 2026 08:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F5EC2BCF7;
	Mon, 11 May 2026 08:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778489980;
	bh=pvy6NTMFmdxYmqrWBMSd1MjoiQi19wsMVW3eEKzhiNY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=uC278g/6wcZXS/TECokjs2CKqBLAAIxUQXBQ4W6K/LvV2cTgxi3+2zo1RK1wLtotT
	 Qn6V56vnf5O4Z0ewruwmAxAlOlB5flBpO1rMunySxoPCyWmDW4zQVwUnIVoNZgd8rw
	 34xPqEQcU9tQ/jbYe3ELDh+VWdv6+1i1sK5qfRrOM8w1usBGEp+xYAJMs1ez3ge5pw
	 yG2mdBwYO7zGlnv8W8LAhZdPlNCRL62lqPK8T9aZQYfEi0ZnZCqXK1hwpeZYNP+YhJ
	 Nt6Sou/dVX74pLH9EoHCJAfc8sXz8WzyM4beQ4NWBlKrjLPLH9PqghlqB6sKYUDHtD
	 bU7jmckMb7LWA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id D79BAF40085;
	Mon, 11 May 2026 04:59:38 -0400 (EDT)
Received: from phl-imap-14 ([10.202.2.87])
  by phl-compute-01.internal (MEProxy); Mon, 11 May 2026 04:59:38 -0400
X-ME-Sender: <xms:epoBauLUKWQQFlZDizE4OuZE6nJAHfoxTRN4JweXZ0D331C0Gx9k2w>
    <xme:epoBag-E-VKCrhgu6pw8Omzhcj6zCZiOwRk3M7qAOAuWkSHFeksC-b68pGQn6zV2B
    utsXaz8NMFa0DCSHbDGj34WYVjf2jkvaYQNfX7MXBNbmfao4rY71IXY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduudekheefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeefhefgtefgkefhgfdvffdukeejheeuvedthfdtiefhleejhfefjeffieeu
    jeefteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    udejpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrnhhshhhumhgrnhdrkhhhrg
    hnughurghlsegrrhhmrdgtohhmpdhrtghpthhtoheptggrthgrlhhinhdrmhgrrhhinhgr
    shesrghrmhdrtghomhdprhgtphhtthhopehmrghrkhdrrhhuthhlrghnugesrghrmhdrtg
    homhdprhgtphhtthhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomhdprhgtphht
    thhopegrrhgusgdoghhithesghhoohhglhgvrdgtohhmpdhrtghpthhtohepjhgrnhhnhh
    esghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhiiihprhhutghkrgesghhoohhglhgv
    rdgtohhmpdhrtghpthhtohepshgvthhhjhgvnhhkihhnshesghhoohhglhgvrdgtohhmpd
    hrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:epoBaoK2PXNYJrbD9UF4L2Rfa83SRHRE4Tx3RlxLmwBWbX8OHFdGYw>
    <xmx:epoBakdLmSzav7YxfV8QIgIsf4qOoKU27Ca4E2o7m-mLwVLuB7rQDQ>
    <xmx:epoBaqV5UGjTnEjdVxMC3Vd39E4_WOaS7hl6JmkVEkAAyxPW_yFdxg>
    <xmx:epoBaijI7jp1hWClAtSGGNjLOjDz0kfcPsFqs9xn0feG0Uj96kj0pA>
    <xmx:epoBakjFQJe8ZqPXns0Mett1u_CYVhCbwTSLmPbB_izBow8_pPo9ccGW>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id AE438C4006E; Mon, 11 May 2026 04:59:38 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Mon, 11 May 2026 10:59:18 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jann Horn" <jannh@google.com>, "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 "Will Deacon" <will@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Liz Prucka" <lizprucka@google.com>, "Seth Jenkins" <sethjenkins@google.com>,
 "Kees Cook" <kees@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
Message-Id: <31252c1d-a98d-4635-ab61-ce5b649e256f@app.fastmail.com>
In-Reply-To: 
 <CAG48ez1DJ88a0pBCE-Q0VXyDuJgng8zdunb38g4b4JPU88exww@mail.gmail.com>
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-19-ardb+git@google.com>
 <CAG48ez1DJ88a0pBCE-Q0VXyDuJgng8zdunb38g4b4JPU88exww@mail.gmail.com>
Subject: Re: [PATCH v4 02/15] mm: Make empty_zero_page __ro_after_init
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 35D9D18000F
X-Rspamd-Server: rspam04
X-Stat-Signature: 7utx9i63wopkam3s6f1rzpbhyiwhsoji
X-HE-Tag: 1778489981-126764
X-HE-Meta: U2FsdGVkX1/TZ1zJfDNA5CRTWYJAcB+dbEEh/QNwYXdcZHp0BYyq/nEO6hAWvquxEzfIihvtcuFgJ2ki+JQS6Yh3gLY8Hy+GsbsHIfLhk686dRZzVOtlidIN11HZCe4yDU0iy3JXOlhmrVVwEfiNUfG/g+eRCA8/vfRTlTUUgcPCo4q2iUiDcqVO3ldgyIbOvOC8TEnd9H47xmrvQcGQX6eDnxKadRfjc75aSslXPmTxwdh2CbfUmTjhk1jZ+VE7zMCWJZ2PLiCJXa5+SxEdbhJfMG5F9+JzzeU0A8t4/dl6Vd3DTpHM+hUxbkSLfFOSae6pQvSWHOoq6FkXVxZfZ53bR7vAii6Z0Alpkz9Zcug/1ozj2h9RKyg6DEDIcOL6FG+f/E2Rym+fNCM2bP/itAZ8fXq1rm6qL3EZAh37oYBHZqwGTji/PW8KtDnZ300CcxIaJEaInGSI4yC4kvPY3MVSdr+l2y0F+sp+RuPnTpx2kVMEHjQUkNgl434fHvHcqjyprv+BSW6eR09Vjmq+Qb5dKuTOZQoaJKASCMWstRI75BDgfunYouDUL2FLZLbDtOV6nL6fwpAhm1fh+UOl98+RaPgudhxewqvj6lksHkUeMvYBNeYTimUhe14nSIFANdqGrmyX82Z1B0kjHJo9Gi4nouGhG75hpgjN5qJp8hr2w1MiKeHuG2n3hv90tyLotlTK10Ah+sZKU+9jELEcLA8igXf25BZThxwN3okLrIC+fvFzzzv9odzgzaOV0aw6pIWgzEdNV6zilh3Gaev8T/tF4wDWk0AvzzKGx9nifYjywAiM9sSxiXha5CDjXDQwKjr8u/+mHDH1LwejNPYjUsBxvo7lxuu+nukifik29rNoxe2gysAvmPqehXfTA6nJBn7dscp7bP7XY8apu4UsbF8ZtROucKimaLuDMx7P8sdKr7O9dmbK/MakyeUNUTElhgfoO/zbvsd863fH0Je
 AImSdMd7
 8pU+wP6llejmuYwR0jN/4hvAGhtScX4nEP8QwVPM7S704X7GBbEuQ33H+UvTdJAWVnqZRX3TU1k41WMu0h/NRtyBCqV90AKvMhHPJBW8F7eV6enrsx7MDkBDOrpy3CahIs8mERhLuNrIW+ULvzoKvU8kZ0BXp35NaNEOEc7xU+pAaOVNf/XTffmUsUIjH3UGyLKdxRDPrectrEk3so7CQn7yNayx78ELGs3aarUPx5wEmjMz/MfZIt/RMcQ+skCQkFjiGhtPDbeMYcUDTN83nfybbdxceNoZP9nfuGeU3CzixjzPYJKCLE/snvI9ahTwhvEelizBXauqfZMtvcqLlgxST98IGdbKwqFY4Rg9rpOHVUJhHyHj7VD1jgtc2DpjP0tQI8WN6E/7k+tZAFTUDu2r9kBiZuZD95L9g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 8 May 2026, at 19:02, Jann Horn wrote:
> On Mon, Apr 27, 2026 at 5:44=E2=80=AFPM Ard Biesheuvel <ardb+git@googl=
e.com> wrote:
>> The empty zero page is used to back any kernel or user space mapping
>> that is supposed to remain cleared, and so the page itself is never
>> supposed to be modified.
>>
>> So make it __ro_after_init rather than __page_aligned_bss: on most
>> architectures, this ensures that both the kernel's mapping of it and =
any
>> aliases that are accessible via the kernel direct (linear) map are
>> mapped read-only, and cannot be used (inadvertently or maliciously) to
>> corrupt the contents of the zero page.
>>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> Reviewed-by: Jann Horn <jannh@google.com>
>

Thanks

> Sorry, I should have looked at this properly earlier instead of ending
> up duplicating this patch with
> <https://lore.kernel.org/all/20260508-ro-zeropage-v1-1-9808abc20b49@go=
ogle.com/>.
>

No worries. I might borrow some of that rationale btw

>> ---
>>  mm/mm_init.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index f9f8e1af921c..6ca01ed2a5a4 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -57,7 +57,7 @@ unsigned long zero_page_pfn __ro_after_init;
>>  EXPORT_SYMBOL(zero_page_pfn);
>>
>>  #ifndef __HAVE_COLOR_ZERO_PAGE
>> -uint8_t empty_zero_page[PAGE_SIZE] __page_aligned_bss;
>> +uint8_t empty_zero_page[PAGE_SIZE] __ro_after_init __aligned(PAGE_SI=
ZE);
>
> I think this is fine as-is; but FWIW:
> "__ro_after_init __aligned(PAGE_SIZE)" means that this will land
> in the middle of the .data..ro_after_init section, with padding in
> front of it to create 4K alignment. So this probably wastes some
> RAM on padding.
>
> Looking at "nm ../linux-out/vmlinux | sort" with this patch applied
> (from a build without any LTO or such), I see this:
> ```
> [...]
> ffffffff8473d378 d shmem_inode_cachep
> ffffffff8473d380 d user_buckets
> ffffffff8473e000 D zero_page_pfn
> ffffffff8473f000 D empty_zero_page
> ffffffff84740000 D __zero_page
> ffffffff84740008 D pcpu_reserved_chunk
> [...]
> ```
> So I think there are almost 4K of padding between zero_page_pfn and
> empty_zero_page for alignment; and I think when the linker linked
> mm-init.o with the rest of the kernel, it also had to align the
> compilation unit's entire .data..ro_after_init section to 4K, which is
> why I also got ~3K of padding before zero_page_pfn, resulting in a
> total of ~7K of padding.
>
> If you want to change this:
> I searched through the arch-specific linker scripts, and I think they
> all rely on the generic RO_DATA() macro for emitting the rodata
> section; so creating an analogous page-aligned rodata section should
> be as simple as adding "*(.rodata..page_aligned)" directly after
> "__start_rodata =3D .;", as I did in my duplicate patch.

I think we should simply do something along the lines of the below,
considering that the size of a data object tends to correlate with
its minimum alignment.

I do find it rather puzzling that the compiler emits empty_zero_page
*after* zero_page_pfn - ideally, we'd combine the below with
-fdata-sections so that the linker sees all individual objects, but
I suspect that would create some problems elsewhere.


--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -452,7 +452,7 @@
 #define RO_AFTER_INIT_DATA                                   \
        . =3D ALIGN(8);                                         \
        __start_ro_after_init =3D .;                            \
-       *(.data..ro_after_init)                               \
+       *(SORT_BY_ALIGNMENT(.data..ro_after_init))            \
        JUMP_TABLE_DATA                                       \
        STATIC_CALL_DATA                                      \
        __end_ro_after_init =3D .;



