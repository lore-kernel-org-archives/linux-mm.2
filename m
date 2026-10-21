Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBB3F606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 03:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HuUipxgR
Received: by kanga.kvack.org (Postfix)
	id C5A056B0196; Tue, 20 Oct 2026 23:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B5B6B0199; Tue, 20 Oct 2026 23:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21346B019A; Tue, 20 Oct 2026 23:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 933986B0196
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:33:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25624803CF
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 03:33:54 +0000 (UTC)
X-FDA: 85345214388.18.9F4DB42
Received: from mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0405E40003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 03:33:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HuUipxgR;
	spf=pass (imf12.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792553632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RbLlIDBzxSpd5cJfPOd2N3zvhSlGP9L2jcWxKocz/10=;
	b=y2cDY5QO3bVPiGFfX0L/2FgI/OLok5ZNap5JZdo6jgsizaRtN62w+OuJFsTe0nMsUyL7Vk
	AeU5Ppe/k/iE34I69XHXFiaHactPtY60ZIibVcMSKg/czD0FxCbkUC+Dk2RWcp9BDcsFOc
	rvvBq9sRpO43JoURkiS+VOmPi3i1Tl0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HuUipxgR;
	spf=pass (imf12.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792553632;
	b=vHEVWpSmsjYwuqvCWVnqaufBVOQvrYd3xJ+q+OKecK9b7VVE9RuYOzlQuX0sJo+/G/Uf8A
	mQT1CYRpURw2D9nT7LCEg0sD4gVADHwRW4IPiL9qn2KeZVjfpecY/l9of5cxswq/uUQ/rV
	cd5/oWsc5ItwOrkY5kOt0bt/AkTK8pA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=y927hDeFwTRi1uuF8AFccBXiuWM2sJNn4YnO+caicLI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792553630; v=1; x=1793158430;
 b=HuUipxgRWS3e7sDvPB7ilyEUPgRtTmYZ+Pmv+0G7aSfoBB64N9Ezdvggr7cyCJYhNYRoNABQ
 1NIALLv0lL+pT7s1Ta2HlXtIcSDzHQRv1LjU8Bz41eNK1xug9eM3nBz5/ICuWBm7aW60JdMJAdN
 h6MPK5xaXrRLUQqt3HGTojB0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 071bc8b21379f3c8;
	Wed, 21 Oct 2026 03:33:50 +0000
X-Mizu-Trace-ID: 071bc8b21379f3c8
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: pratyush@kernel.org
Cc: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org,
	ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v5 1/5] efi: add a KHO configuration table channel
Date: Wed, 21 Oct 2026 11:33:42 +0800
Message-ID: <20261021033342.3110-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2vxza4p95v6e.fsf@kernel.org>
References: <2vxza4p95v6e.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0405E40003
X-Stat-Signature: edcyhu9ykqhojfyky33ycmqs5frbwf96
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792553631-723568
X-HE-Meta: U2FsdGVkX1//aCbd9LIjLZN5gT4NKu1VWuU7lyjTXjYxvJREE4IgOZGbPtr6GbE9yzyEnlDb31iGcyEEcQat7hHp1/lEIZ+TtVO5GsYIdWW7re9fFf7aX0lN0wbSMOYvRb6suHShpwWaUHVhb/128Fu7VLKl/OnSBvnCu6S9/Q/GNxtkQ3t8Nx/WgR14waq3y+6oMtOjes+BjwFWr0LlmRBPIRWU+7SwX9XVq1HxefXLyFRY1UBBY39qVrwRd03B/0/jta2JDqaKjxiVJikqRm/JmmPNw1RAHVQywl3JRtV1T4HlTBJSkLGU8xz82Arbo29zjp5Uq1lCjEtynIJvWUzchNM5nDrlXWEvfvmVGQIWmJGTtWg3snKZ9rIyPcAb3lX16Dc0pOtOg8IpbVPByIXLAaT5ufz15Tpaakg3zcIaXmPjP3n6ifQXljuFdcsa7WhyOHUHDB3E5AUcex0YNPa3fA5nzj6UpMUZgV/pWgT2dnm07OqPnTOUgvknzWxMMcYo60u7uJwytr5H+StyueN8Lixqz4e8NKkwB8JxhyO7Vk9P4447fybMZ+GBdsoK3yqvZjk3gBMDRjyDnAr3L714Q9RurGSkVnYkAanAm4bcT0ntXsDF3JPF3tdvdE9HWiiye4V6MCYKQy52Nc2Nf2S39l7U7jJEjLqUOu4lwogKa+0eBnld1tpOCl8b5CkNBYNY28TDYB76XqyIrfArAwKtn+oKkOEitgl9qVPrTwBcD/2DWOBPCCCm9Y6lJS01eH98YuXLxMFEgTMsBVi59dawhTss0qYmL8Hg9sEHXmLUBy6uAE9Wvr5fNA6hTKSJOqP7TFuulejvPlNOlXkNhEtMv2nsBh/VD4Lw4xROyryH+8Ot9JIjrfuF9ceYpreRo20Rc9JRFq4cSjSn1EihF5hV9cRdcaH66YEnzxxZ+5Rmxfm46VINSTojVEFfhZM6rqhA+PsouhV0akEuN5k
 cO8/2GYE
 53uT2+a4Yu+ti4oBZUE+fBN6lQZGARJl09xzEiT5i65IoagrxGB+kYf+lXkYY2VMhnTk1La2pTOVnuatO4L/9GBwv8MvCR/mkmlYcjm/wsgaQC7pjRUQhxq6NOVYuvU/O0YKwRRh1CllKhyXmzDHdXLHbq0jAOiKpUD7qLEbAQCW3MrKPU1CjHhln+/NP6uirK39YUZCExoHEkYT3JKF59O8UuUUQFtfn19I9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Pratyush,

Thanks for the detailed review. I've rewriten the comments and commit messages
myself for v6. Replies inline.

On Tue, Sep 22 2026, Pratyush Yadav wrote:
> > +config EFI_KHO
> > +	bool
> > +	depends on EFI_STUB && EFI_GENERIC_STUB && KEXEC_HANDOVER
> > +	help
[...]
> I don't like adding a config for this sort of thing. Do we really need
> this? Why not just have the code always compiled and only used by
> loongarch? I don't really see we need a user decision for this sort of
> thing.

Agreed, v6 drops it.

> > +		/*
> > +		 * Reserve the stub-allocated table so it is neither handed
> > +		 * out by the buddy allocator nor placed on by kexec
> > +		 * segments, mirroring the memreserve handling above.  This
> > +		 * runs on every boot, so it also protects the table in the
> > +		 * next kernel until it reads it.
> > +		 */
>
> Nit: this comment is too wordy. Can you please make it more concise and
> to the point?

v6:

	/* Keep the buddy allocator and kexec segments off the table. */

> > +			if (kho->fdt_addr)
>
> When can kho->fdt_addr be NULL? Also, perhaps print a warning if
> early_memremap() fails?

It is 0 when there is nothing to restore:

  - on a cold boot, because the stub installs the table zeroed;
  - after a kexec into an image without KHO state, such as a crash
    kernel, because the table is zeroed just before that kexec.

v6 says this in the struct documentation, and adds a pr_warn() when
early_memremap() fails.

> > +	/*
> > +	 * Keep a persistent mapping of the table, the same way
> > +	 * efi_memreserve_root_init() keeps the memreserve root mapped:
> > +	 * efi_kho_update() is also called on the crash kexec path, where
> > +	 * memremap() is no longer an option.
> > +	 */
>
> No need to mention memreserve. Just explain the reason here. And keep it
> as short and to the point as possible.

v6:

	/* Map it now: the table is also written at panic time. */

> This is unreadable. Please add a human touch to this.
>
> And once again, the fact that it mirrors efi_mem_reserve_persistent()
> isn't important.

v6:

	/*
	 * Write the KHO addresses the next kernel should use, or zeroes
	 * if it should boot without KHO.
	 */

> Why ENODEV? Wouldn't ENOENT be a tiny bit better?

Neither, in v6. No table is the normal case outside LoongArch, so
efi_kho_update() now returns 0. The only error left is a table that
could not be mapped at boot, which returns -ENOMEM.

> This has too much information. You need to make it more to the point.
> For example, "without a device tree" already implies there is no /chosen
> property in the first place. No need to mention the function either.
>
> The lifetime of the table is certainly useful information but again,
> should be much more clear and to the point.
>
> Also, you should document what each of the members of the struct mean.

Agreed. v6:

	/**
	 * struct linux_efi_kho_data - KHO state passed to the next kernel
	 * @fdt_addr: physical address of the KHO FDT, 0 if there is none
	 * @fdt_size: size of the KHO FDT
	 * @bootmem_addr: physical address of the bootmem area list
	 * @bootmem_size: size of the bootmem area list
	 *
	 * Pointed to by the LINUX_EFI_KEXEC_HANDOVER_GUID configuration table.
	 *
	 * The EFI stub installs this table zeroed on a cold boot. It stays
	 * in place across kexec; the running kernel rewrites it just before
	 * each kexec, and the next kernel reads it during early boot.
	 *
	 * The layout is fixed. Changing it requires a new GUID.
	 */

> Note: I recently sent a series that renames scratch to bootmem [0]. It
> looks close to landing. So you likely need to rename this to
> bootmem_{addr,size}.

Thanks for the heads-up. It is in liveupdate/next now, so v6 is based
on it and uses bootmem_{addr,size}.

> Why __packed?

No good reason. All four members are u64, so there is no padding
and __packed changes nothing. Dropped.

Thanks,
George

