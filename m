Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81342606A895
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 07:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kFFAXOZm
Received: by kanga.kvack.org (Postfix)
	id 656786B00EF; Sun, 15 Nov 2026 02:13:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6075F6B05B0; Sun, 15 Nov 2026 02:13:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F61E6B05B1; Sun, 15 Nov 2026 02:13:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B24B6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 02:13:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98B40140576
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:13:34 +0000 (UTC)
X-FDA: 85436487948.21.7430F57
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id CE1BD40004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:13:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kFFAXOZm;
	spf=pass (imf04.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794726812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0sztYeDoa78GRxByi5DPGRDZ13zK/I8mczcB1W5Z+o=;
	b=rtx0u/cxfLaUCqA8gI9U2/DejlpFDa7QFw2Bra75rkjIxHQBBTeerOe2/oSYr37xEte53c
	wZEGp2tXpVI6vd74Ke7ParoyzJGJUbtR9PZfzAE4rRcMDyMSeaJ2OJBk5gZ+ZrwGSbycVe
	aj4U+DTPzQrd7ZXpPvSnjqO5EkJKk4w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794726812;
	b=yUxzhmrNhnOxdNvmlixY1/qK0DoEUVwq5NybSZ4fyD33E1IwDINlxTBurxlLRCeqj4mKiD
	5AD8HJOGt441FZfINAKvif/eSaj7wQGb6Uu51nkoslWB90BO2iJG+FiBxONnPe9CquQuxY
	U3iP4eZo5d0lVsO5FUWGAK8IhCjPANw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kFFAXOZm;
	spf=pass (imf04.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-15dd124bbe7so2378231c88.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 23:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794726811; x=1795331611; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :message-id:date:in-reply-to:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i0sztYeDoa78GRxByi5DPGRDZ13zK/I8mczcB1W5Z+o=;
        b=kFFAXOZmqHCJOzu3FBM6EIjFKGkiJ/CjsxKKJo8PR7gZ/TYPYXySEBxtRx25K2S/su
         Df5ohlf+mJKa42Oc8KRu36bdbmV53S3zrOi0+9J2gm3kgTHdbs4mdvuAsP5Zgs9i3aII
         JV7kqddMwRTgcCYApl+F3PcDCsJUAvNYyY/mbialFesNPGOZTsDH56NNywN0S7IgZbNh
         U8JAk5jWcgpmd1MDeaN1kaOXvlLbbeFJbpVyBqsOa/Qehv3UMB2QWrpsodHct0MDN9yn
         /vEVr3M60G8A6xdacFe3vDWA42/wduc3WbAKWrNALPcBojsIUAZ/e5kGLAJpwLJYjKiv
         o6EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794726811; x=1795331611;
        h=content-transfer-encoding:content-type:mime-version:references
         :message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i0sztYeDoa78GRxByi5DPGRDZ13zK/I8mczcB1W5Z+o=;
        b=gPWnluuHmAK/Y+9V46jUd4aAxohYAqLdbdxuJj5znWahJyv0hqbg3ghOU5ujzSpaau
         kb4BS5uvN+3M6iEKZip9t1ZbK0N9iDTa9HexBRfX2wy3/vnlZlUd7ISl6TuMY6M+PisF
         JptWh85EhIA09mcALFuL7AGh7nwrVb3gDTs+F+VOWwTSPRYzHY3RRfdVBLM9a0ETnupw
         503FCVgHZMDHlG8nX7Y1oezla/vQar4g0xG9K2tholuXA6I16jlS0Fwq2g4sagPgyPW3
         PqHdqoz1XD+FbHM8nLrwUUWLnPo3PxGDO9G9vs/Kniu3aU27B5L6ixe61RfW83vZxDW1
         IJ/Q==
X-Forwarded-Encrypted: i=1; AL+hErER7rwOvd6tniE1ABvGvGZZ8WqVEWllNH/bYKrNE48pou/IZu9DUGrvFqDo5ji87OFcwbJilSnU8g==@kvack.org
X-Gm-Message-State: APuU4Z9vDC8sKJYWIje4qa6zg1Smdl6yjNFLmPcFflKhSKmuuRLody23
	kYaCmLO6Q4OVJ6jnjcI+fzpNYCzMJZyLjfSWsIA2aLTSDaw9pJUgpAXZ
X-Gm-Gg: AYBFou2txJZjyezPs+k+wedkakVQSFSmjChUGSWnNfnquXshS3QUb44nC0px3sAW/ID
	sN8CXqOthWzTdIg6uLuAhBX0w0S6yJG6tARsMaznQv4TQeKhWYq+khQPGlhrSInpgfwwM/MGYNe
	ykd9t6Udl5vkegUS6/B9uNrH6Ki3LfJLD6ZMvrRwEaiYmCS3nvSt+Ks0XUWoMZ90vdflypzgRlw
	rkIjGdYqjMu9yCbuL5e3Zv6zr6MonLhc2O+9SnymQ0FRh2GGNRq0ke4llHBqPrulQ+Y6SkqYND1
	TcBiuXESZqYFbEJqsIO4VNFOlXhdBGFiuWRzcAJ1tRF49wiUQNzWLqzcQ19kkLfzlC/9LLk3YjE
	DZL/0Ku5arZV50cUGpb0YNRZhOTmBULQluvAMH1ZhpCH2I0RbJANbHG+oQQ+1Mb+rHzWWCNkxF8
	hiP1ycvOw9iBW5EjyHLd0MLpJfjsBUVMjapL6uWfihsPcY+Gaey+u50CPSp8neKtBLYXOTYWzlI
	+lcGgfVguVjckGc24pJE0O7bz1pVjkdEnqArzASXYPLWIuAQwff5XEUMmAVdEpKLJBim3vpP4NY
	Ugox5GpwRw8Q47LO0osP7Jb5pEI=
X-Received: by 2002:a05:7300:6148:b0:36a:7bb7:4609 with SMTP id 5a478bee46e88-37967dd7e1dmr11471490eec.34.1794726811302;
        Sat, 14 Nov 2026 23:13:31 -0800 (PST)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37956bad134sm27441185eec.27.2026.11.14.23.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 23:13:30 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Mike Rapoport <rppt@kernel.org>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alexandre Ghiti <alexghiti@rivosinc.com>,
 Andrew Morton <akpm@linux-foundation.org>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, "David S.
 Miller" <davem@davemloft.net>, Dinh Nguyen <dinguyen@kernel.org>, Donald
 Dutile <ddutile@redhat.com>, Eric Chanudet <echanude@redhat.com>, Heiko
 Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, Huacai Chen
 <chenhuacai@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>,
 Liviu Dudau <liviu@dudau.co.uk>, Luis Chamberlain <mcgrof@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Nadav Amit
 <nadav.amit@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>, Peter
 Zijlstra <peterz@infradead.org>, Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, Russell
 King <linux@armlinux.org.uk>, Sam Ravnborg <sam@ravnborg.org>, Song Liu
 <song@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas
 Bogendoerfer <tsbogend@alpha.franken.de>, Thomas Gleixner
 <tglx@linutronix.de>, Will Deacon <will@kernel.org>, bpf@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-modules@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 loongarch@lists.linux.dev, netdev@vger.kernel.org,
 sparclinux@vger.kernel.org, x86@kernel.org, Madhavan Srinivasan
 <maddy@linux.ibm.com>
Subject: Re: [PATCH RESEND v8 11/16] powerpc: extend execmem_params for kprobes allocations
In-Reply-To: <avlTdlK9ErlqVRYl@kernel.org>
Date: Sun, 15 Nov 2026 12:33:31 +0530
Message-ID: <4idi8tks.ritesh.list@gmail.com>
References: <20240505160628.2323363-1-rppt@kernel.org> <20240505160628.2323363-12-rppt@kernel.org> <3f7af771-87a7-4ae7-9919-bc4c23bd31c9@kernel.org> <avlTdlK9ErlqVRYl@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: xk8fxictyrmqw178dr8q175164bt83us
X-Rspamd-Queue-Id: CE1BD40004
X-Rspam-User: 
X-HE-Tag: 1794726812-754662
X-HE-Meta: U2FsdGVkX1+siixiq9A1KvWKQa5OqRlXVsmr56Ra3wsqf4lxo41Ed+/DOa9Y7cu4zBy+xrByWMvWXMITEF7bmmmm/pPVHIZVe+kFnq5JXlpaQlG9mE+kYfoWi+pje3IEYqTZaBH3Hm7IokRWEIwg7rqYjTOAs3tMDBsA+Yb2n/1rNhI1mnVuYbEidUuGP+H4a1g3Ri3BNZ9xs8hc44OZBei1dLjpglcKbK4bWGBi66aZhMPFDkLEuG94OLau7cuWKbCS04rA9ARv6j0cg8V3f8A8refJy+51HtwbgooIhd6D01xjm9iiLjc23g2KxkhvSlrnMkGiU64TfxP1+M+Eard2CbqTkMjNL6MMFIcwaER8lsqmbM24XBRJD7v480zv+OIK3vvMCGMCCN/yv/zawZ/Z1/XCcv989ybYwkycyH2EV2C+/2xti+Pm1qGBfTiQryakZFMl2oNLZ7f5NF4UR6/bsxWWW1DrouYmjIWKy/DzsniQqtrV18Xm8yqQ1lPf+nWssM2ibqFA42PFp83i/XH3coblESa1pgMkkn9nM1FC3IYENupU+/HoANgUS+TFcirCqnTgykQnoifyRoJf9b2yhPW0TfobjWP1Y6YQELnfwWCe8lBX9J4uRgagDo+9thZ/DoNOR6ydK93vYQ9zQDUSGAHv1P/+SvqZZ9a9jAidzSlYI3f84gd2uBZfwHJZQx0C8c9LRdN4dYGG4AMfHTkLoVNwQJJSmA8EetxiVRXLax8jUNoTQkvjYmT34SjoRQwJD0XXKZKpJZEabgkLwUiYSrMr4SCH9t5LKu+8buP/haEMuiesK/R/VlovM6Le78Luyyyq31K6JaCKEmrOYcbaaxxzWRdiMWWvI2veXCr3d+xP/drRevyIyowXSslOvIw8/XgscMW5E/cUo6KlRyi7Bd6EwayQoHeFozBuW7Nw47VnpKLVmgFrgSvE/xTK7Tn3+sLGnEGUCtEzULv
 C6J0wflN
 a5oCxmK56CFaDZfU5ot7b/OqySdBT4JoAvSzEW56SEzqCFOMN/01n4byZHl0zAM3G6G2en+brOHlKrdnEMzWc5nZVlUMQ5/6/RSeeOazi7MfAChhp7OA6IAWfWbPSWlrT2rCjwu8ymJlO6oLxrsEBtdEbPJJ78WLCUBNbp4b7xm4XyJBb0TnDodl9h/i5A5zmuNsG5AUI1yebe0U+7fvE0W9Kd8H0j3NpwRPq/1vcNZbpgG/V+snhAXvo2x80hxYeO5icjx2y0Xfxl6yJGF5ms+4a0kLf1l+M1qFnKYBrbpdwZwLaT5OefPE0yyOCv7VP+iJfIfLOUz22EuKFw6eIzbGGd6L9r3pLqRz+G/MEhJdSIdxNZ26lU5hitzFJy/LpDAkuioOSTXUR+E1KGCI7ihVbVaQY9ByTwahD49ktkAI+rziFJ3PtIftzOOoONAJFVCQ1rd3opU+nti/hsYhJKdyuX5u7qUllQewlZXbdp/3R26xRR3d579r2ttuGb4p0nBEYFEVKmzjHh4HwKy4PoFIcJZJmXnzI1fz5BxzdupetWiilOiMHCKnb24sluGqSHjO85fpmUFGoSMOiZYBi7keVq92qJzUI96QYkvsZYpqYue4bSOg4uJZuIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Mike Rapoport <rppt@kernel.org> writes:

> Hi Christophe,
>
> On Fri, Nov 13, 2026 at 03:36:01PM +0100, Christophe Leroy (CS GROUP) wro=
te:
>> Hi Mike,
>>=20
>> Looks like I missed this change ...
>>=20

I didn't initially get what Christophe meant here. Then I came across this
reply of from him[1]. So looks like somehow between v3 to v8, something got
changed?=20

    On powerpc book3s/32, vmalloc space is not executable. Only modules=20
    space is executable. X/NX cannot be set on a per page basis, it can onl=
y=20
    be set on a 256 Mbytes segment basis.

    See commit c49643319715 ("powerpc/32s: Only leave NX unset on segments=
=20
    used for modules") and 6ca055322da8 ("powerpc/32s: Use dedicated segmen=
t=20
    for modules with STRICT_KERNEL_RWX") and 7bee31ad8e2f ("powerpc/32s: Fi=
x=20
    is_module_segment() when MODULES_VADDR is defined").

    So if your intention is still to have an executable kprobes, then you=20
    can't use vmalloc address space.

[1]: https://lore.kernel.org/all/1cb41761-29d0-5d33-b7c1-0ca3acaa810d@csgro=
up.eu/

>> Le 05/05/2024 =C3=A0 18:06, Mike Rapoport a =C3=A9crit=C2=A0:
>> > From: "Mike Rapoport (IBM)" <rppt@kernel.org>
>> >=20
>> > powerpc overrides kprobes::alloc_insn_page() to remove writable
>> > permissions when STRICT_MODULE_RWX is on.
>> >=20
>> > Add definition of EXECMEM_KRPOBES to execmem_params to allow using the
>> > generic kprobes::alloc_insn_page() with the desired permissions.
>> >=20
>> > As powerpc uses breakpoint instructions to inject kprobes, it does not
>> > need to constrain kprobe allocations to the modules area and can use t=
he
>> > entire vmalloc address space.
>>=20
>> Using breakpoint means the segment must still be executable.
>> On book3s/32 VMALLOC segment is not executable, while module segment is.
>>=20
>> See commit 6ca055322da8 ("powerpc/32s: Use dedicated segment for modules
>> with STRICT_KERNEL_RWX")
>>=20
>> See report and fix at https://lore.kernel.org/all/ed03d290d440d579a81ae0=
b7de5243721291d903.1794543909.git.ritesh.list@gmail.com/
>
> I'll take a look, thanks!
>=20=20

Thanks Mike for taking a look. Sorry, I should have ccd'd you there, I
guess I missed it. However, the changes are these one here [2][3]

[2]: https://lore.kernel.org/linuxppc-dev/82c4973addebd82923c460cb44221f5b7=
6146afe.1794572365.git.ritesh.list@gmail.com/
[3]: https://lore.kernel.org/linuxppc-dev/f75f2cf97f44375fd2c8820e0caeab703=
cdb371c.1794572365.git.ritesh.list@gmail.com/

-ritesh


