Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D212EC87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 06:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CE366B0089; Mon,  4 Aug 2025 02:56:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F1F6B008C; Mon,  4 Aug 2025 02:56:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26E1C6B0092; Mon,  4 Aug 2025 02:56:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 160296B0089
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 02:56:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6FEEA1A0D8E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 06:56:25 +0000 (UTC)
X-FDA: 83738166330.05.1A3AE3A
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2E9991A0005
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 06:56:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025072201 header.b=hFmN5bIr;
	spf=pass (imf19.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754290583; a=rsa-sha256;
	cv=none;
	b=eB3gAnI+Z1nu4UtnY0fc2HWZg1fjWx1VWlK+CsXUv+Hhcv6xNTElIXGiqcFnxHUKLISTS5
	aOXvTXMZOV3FtozeTUBLIh8QPtWyqU3KALfvvv1tLq5FmNCXQuObXJt7eyf0cbzn2MFzgq
	6m3yPAif3Y8qSClBGtn4DVyWWtUTjTw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025072201 header.b=hFmN5bIr;
	spf=pass (imf19.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754290583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Uxfo/n+FmHLvR+WWWhh+s7r7X3EBAjRA421qiR6QUs=;
	b=ykBFIIt5DUcEx1oPaD7AAy4c9rw227GJbldtg2thE0uyi72R6cMDjKJije4A9Ehw7voHzm
	5HigpHOzAw822iOwEl2R0jcfp7MRIkw/SIFJPEqNqcf6w5FP4u3rWXfJAkEyPL6gl/RicL
	DtFCwXQALbt6f2SJ8lBjUY4p9ybAk0U=
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5746tNXj718207
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Sun, 3 Aug 2025 23:55:23 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5746tNXj718207
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1754290530;
	bh=6Uxfo/n+FmHLvR+WWWhh+s7r7X3EBAjRA421qiR6QUs=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=hFmN5bIrGhwAqRzowBAQP+K7JKfkTZmxrPVOSbJS31LX45O5bseelsScA7k2yDAPP
	 mUWGJ9cRkp3wnCfLfOCOdLrCRaSejeDQvKQhqYD0KFFqPhWPi9VD5ehD5kwjJBQj2t
	 EglMcvwE5YmBnva0NyndOecbfVvrxckhlbHsKMMsbeWG/mVa+QaqaWu1UUe5ZAxFnL
	 1mZ5QW73IgNc+sHyKKBk2/Gt9h16K/EL0SMXj0hZdrOO0sLOUeqwekZA4MobIa0aa3
	 oUKY2QoT7lwUsXmsn2UM5m5MzP1sYfQoYlcAvGmOUImszdjO9LWUNNL4GiLRQ7btCZ
	 G/wBKmENMoORA==
Date: Sun, 03 Aug 2025 23:55:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Kees Cook <kees@kernel.org>, Dave Hansen <dave.hansen@intel.com>
CC: Sohil Mehta <sohil.mehta@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Kai Huang <kai.huang@intel.com>, Sandipan Das <sandipan.das@amd.com>,
        Breno Leitao <leitao@debian.org>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Alexei Starovoitov <ast@kernel.org>, Hou Tao <houtao1@huawei.com>,
        Juergen Gross <jgross@suse.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Eric Biggers <ebiggers@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>, Yuntao Wang <ytcoode@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Tejun Heo <tj@kernel.org>, Changbin Du <changbin.du@huawei.com>,
        Huang Shijie <shijie@os.amperecomputing.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-mm@kvack.org, "Kirill A. Shutemov" <kas@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Xiongwei Song <xiongwei.song@windriver.com>,
        Xin Li <xin3.li@intel.com>, "Mike Rapoport (IBM)" <rppt@kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Michael Roth <michael.roth@amd.com>, Tony Luck <tony.luck@intel.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        X86-kernel <x86@kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCHv9_04/16=5D_x86/cpu=3A_Defer_?=
 =?US-ASCII?Q?CR_pinning_setup_until_core_initcall?=
User-Agent: K-9 Mail for Android
In-Reply-To: <202508021149.B4BFF8D1@keescook>
References: <20250707080317.3791624-1-kirill.shutemov@linux.intel.com> <20250707080317.3791624-5-kirill.shutemov@linux.intel.com> <6075af69-299f-43d2-a3c8-353a2a3b7ee7@intel.com> <98a7a91b-3b46-4407-82a7-5f80443b7e00@intel.com> <6e768f25-3a1c-48b9-bc53-56877a556a83@intel.com> <202508021149.B4BFF8D1@keescook>
Message-ID: <5BC99441-D69E-4B23-9485-6802F8ED8A42@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2E9991A0005
X-Stat-Signature: 5fbifj5qzqeecfrzmtc6i8r5mbkaanh3
X-HE-Tag: 1754290582-406615
X-HE-Meta: U2FsdGVkX1/EfwHMQ6s5WeLMt9ZMrRAzolY89HEtdvV9Df5QeDBMZXImoB24uGnFN0IoanOmjsykmjQWETsOI6mNPVxK5tJvGPgUOwqDvb/tBdLRHTZetZHwdzE2Mc4cNrPOLWfPKR6tvL5fmoyUEnsbOFHcVTuUuitKuRdqSVhWhv1uPNhJuQgexCCiq11NkJjyj+bJIuUe1vbh9SCmOKqF7QmgNPBAxZtMAHrIQQPh5B5ujb6adO5/IapRqzRGbZvtzbabkJlsksBvg2Jyo08vILiarpXUSxT8Q85Etehdsjkcm1DIXxTc3hNreI2GwKX5IzCD2NbMO+PqIa3PnlXKx+Nte+OEiBiXqshbIpdPolJCubHb7TFgn39a085n/ZISbcqkemZLrc7XxLUd4DY8aeV5rKm8/kRd6xDz1bb9poj7SaQgzrfZ+NiIuOlA9UnaSrrsdb0RMJ/4anRG/9u9Ka3htl9Vp9Kbq968/fZLGPRWJwO0BZq13vXpumyvUl8kTqet277uQIrU8CEEcViJ/YtinGu2D0L+zRnd4GuxZZAUZH7+RRigtyRO0Moh+7mCKPKb63Nq/qV/9Ocnxvrv9GU7kONyyAS9XMlkMt4HXQqLojufumQUVwSDpk6e6dodkzDkhyblp2hhouwvP6E/BavaflZz+119o6N+RYg5JNqPBEPyfQhuRnYWV0i/6LDxpBKH7PbtEnwOm+PR7UffXbgG/t80hYLBkxkMdoVc57r0r0rDIfhyfCuKdmUjptNwAZJ/OuijWxGO7wbtL/xN8TRpf4gCH5tANSSbdab0YbBMAHbwLh64Bb4YHKhNFoSt4FZrMmx2SixqJd9IAdRU4R/hCbr9Je3xQLJ9KzjJ5aCeL6sE1hm8aH+iRy+mrRLFm8tdyptvNElzcalBNyw4UuDyl0aMk7SuD/GY8hhS0Ga5OfYUq7mi7hUnl5TJX+gB2u3hegg2aQvE2fr
 HA93j4PG
 DkagAKpu8503b0p2wc5S3e8tH4/XtZJKVbfpQWK1KiRjuxUIuoeWlzzVd+vM5wdO5/P4yrJLrQBgvIl1knzQs0ypCbuhjlQKUPDXj5dEWA/p4kABRJHl8DRG2ImkbkmYiVJKpSBJewh53qzf1LytittaXQ04a1SNTsNEVFteFb6tLrSZjWSb+xqKAScRTl/8CJaqi5YqJVviNE5e2nrjuA10SpNogiOC0LYpEWGRC6FK37TPoTC8Rp9VjZF4+ij87alTy4T61HdImTJNyok3m3gl5lvrwNyL15VjB0L3AIOIC6nce1Fjq16SidLSEWXDmFwVI+t+HCPD2C+aJjvqBlN4bP1ajUcFoU05XbarGp33fjR1YUhjcxD+GHDyuKeZAWjfm0LGkGgD/n9ibrTooSPI1Mt9NHPxFe2axSb1EEfR8INLQAV9FzppsHoqrpWy0vpkp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On August 2, 2025 11:51:28 AM PDT, Kees Cook <kees@kernel=2Eorg> wrote:
>On Thu, Jul 31, 2025 at 05:01:37PM -0700, Dave Hansen wrote:
>> On 7/31/25 16:45, Sohil Mehta wrote:
>> > On 7/9/2025 10:00 AM, Dave Hansen wrote:
>> >> On 7/7/25 01:03, Kirill A=2E Shutemov wrote:
>> >>> Instead of moving setup_cr_pinning() below efi_enter_virtual_mode()=
 in
>> >>> arch_cpu_finalize_init(), defer it until core initcall=2E
>> >> What are the side effects of this move? Are there other benefits? Wh=
at
>> >> are the risks?
>> >>
>> > Picking this up from Kirill=2E=2E Reevaluating this, core_initcall() =
seems
>> > too late for setup_cr_pinning()=2E
>> >=20
>> > We need to have CR pinning completed, and the associated static key
>> > enabled before AP bring up=2E start_secondary()->cr4_init() depends o=
n the
>> > cr_pinning static key to initialize CR4 for APs=2E
>>=20
>> Sure, if you leave cr4_init() completely as-is=2E
>>=20
>> 'cr4_pinned_bits' should be set by the boot CPU=2E Secondary CPUs shoul=
d
>> also read 'cr4_pinned_bits' when setting up their own cr4's,
>> unconditionally, independent of 'cr_pinning'=2E
>>=20
>> The thing I think we should change is the pinning _enforcement_=2E The
>> easiest way to do that is to remove the static_branch_likely() in
>> cr4_init() and then delay flipping the static branch until just before
>> userspace starts=2E
>
>Yeah, this is fine from my perspective=2E The goal with the pinning was
>about keeping things safe in the face of an attack from userspace that
>managed to get at MSR values and keeping them from being trivially
>changed=2E
>

I have mentioned this before: I would like to see CR4-pinning use a patcha=
ble immediate to make it harder to manipulate=2E If the mask is final when =
alternatives are run, that would be a good time to install it; the code can=
 just contain a zero immediate (no pinning) or a very limited set of bits t=
hat must never be changed at all up to that point=2E

