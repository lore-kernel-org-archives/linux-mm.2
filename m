Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24DE0FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ED6A6B008A; Mon, 27 Apr 2026 04:54:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4C46B008C; Mon, 27 Apr 2026 04:54:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801846B0092; Mon, 27 Apr 2026 04:54:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EFB56B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:54:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3549F1B91B4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:54:40 +0000 (UTC)
X-FDA: 84703725120.09.0831888
Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	by imf20.hostedemail.com (Postfix) with ESMTP id 029D41C000E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:54:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=S6fWitaV;
	spf=pass (imf20.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.171.202.116 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777280078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXqEElTwN2Tki8IktRXTfIVL9D01k/xyxgMf0ctrAd4=;
	b=5bCaIdfnz1iumk2zc2KsZ7bSsq3LnDU5aH4aRF0ElI70mNTr5+GsNxV/MoVnrVhTnGze7i
	taNkd3DC+Y8ENxtltdxfi4rGTuwZzIBE1+PaVDt5+KuFdxwlIPPXbL0yg+HX9HQ1gbyLSP
	y123fJw4hYZATqO7q9CwEozB7xZHkXw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=S6fWitaV;
	spf=pass (imf20.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.171.202.116 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777280078; a=rsa-sha256;
	cv=none;
	b=toNtvtf3alWWSi0GXGaSw4vWvj/YYQPyMxu/1jkPU7aSgyAjfs9MuzaiLoM2t2BDfOA9YY
	xlGnYOXZLrp3egybCbxAGJrHfHareWNWq6XR02ySGk9/L40cFUylllNG4HcqfFU7VeUoMJ
	9EQbww+WgT3RHcBz93tFlllQtWd+daI=
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 1EF22C5CD44;
	Mon, 27 Apr 2026 08:55:19 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 00C60600D1;
	Mon, 27 Apr 2026 08:54:36 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3E6B410722270;
	Mon, 27 Apr 2026 10:54:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1777280074; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=TXqEElTwN2Tki8IktRXTfIVL9D01k/xyxgMf0ctrAd4=;
	b=S6fWitaVDU/VTZT6yPZJGXT7mUzoaUUbLCjgB4vRC3fCgw3YaEa8rUxESSeQ4XM7sjxdld
	w2wJkszlpI/+wJv4VqWfh21mPO0o4KNiRTj9oqzk+O10QqDUfqSImMWvLhCIOcLEjFMtyG
	sUY57bQmm2xTj8ZjKaHYGBs4eCyHXGr/RuUPsVyddOb3ET/DEUbe3cIOjRYxQgYqhcHujv
	mmeRT0Ooj0pRPIPSI9VdRSjRGsZnUXRi8k6doRZ/9vcuXQtb+ezrvE5e+kTwdL2pM/S1MO
	LmYK6n6Izjxt4mzCaSxAD8ryLg7XzSE0B+bbHBjSDcwj2rcfoRc1SPkXzxFAtQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 27 Apr 2026 10:54:24 +0200
Message-Id: <DI3T7A3A3LWQ.1WBAS2CWS2343@bootlin.com>
Subject: Re: [PATCH RFC bpf-next 0/8] bpf: add support for KASAN checks in
 JITed programs
Cc: =?utf-8?b?QWxleGlzIExvdGhvcsOpIChlQlBGIEZvdW5kYXRpb24p?=
 <alexis.lothore@bootlin.com>, "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Martin KaFai Lau" <martin.lau@linux.dev>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, "Song Liu" <song@kernel.org>, "Yonghong Song"
 <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>, "John Fastabend"
 <john.fastabend@gmail.com>, "David S. Miller" <davem@davemloft.net>, "David
 Ahern" <dsahern@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "X86 ML" <x86@kernel.org>, "H. Peter Anvin"
 <hpa@zytor.com>, "Shuah Khan" <shuah@kernel.org>, "Maxime Coquelin"
 <mcoquelin.stm32@gmail.com>, "Alexandre Torgue"
 <alexandre.torgue@foss.st.com>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Alexander Potapenko" <glider@google.com>, "Andrey Konovalov"
 <andreyknvl@gmail.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, <ebpf@linuxfoundation.org>, "Bastien
 Curutchet" <bastien.curutchet@bootlin.com>, "Thomas Petazzoni"
 <thomas.petazzoni@bootlin.com>, "Xu Kuohai" <xukuohai@huawei.com>, "bpf"
 <bpf@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>, "Network
 Development" <netdev@vger.kernel.org>, "open list:KERNEL SELFTEST
 FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 <linux-stm32@st-md-mailman.stormreply.com>, "linux-arm-kernel"
 <linux-arm-kernel@lists.infradead.org>, "kasan-dev"
 <kasan-dev@googlegroups.com>, "linux-mm" <linux-mm@kvack.org>
From: =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>
To: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>, "Ihor Solodrai"
 <ihor.solodrai@linux.dev>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
 <71fb19ff-6dde-43f4-a0e9-5c8cf2ba4ed4@linux.dev>
 <CAADnVQ+ytaX5oq_1TjKC66dnjd1-yh3yjmPrP-kEg5wEvX643g@mail.gmail.com>
In-Reply-To: <CAADnVQ+ytaX5oq_1TjKC66dnjd1-yh3yjmPrP-kEg5wEvX643g@mail.gmail.com>
X-Last-TLS-Session-Version: TLSv1.3
X-Rspam-User: 
X-Rspamd-Queue-Id: 029D41C000E
X-Rspamd-Server: rspam06
X-Stat-Signature: d7y9zqko484weaqfdftm6wqk1kxaygd7
X-HE-Tag: 1777280077-528396
X-HE-Meta: U2FsdGVkX181rxqOgWTXhNrAtL3w6uQ5V2mEfzT5vGX3bV4vOh7KPTWHX1iHUFNhhrAJuSFDtz9kQXy6hZOT5M1fZlZyfQIpvWs9PtlDMYtogLOUIxcXDAN9M9JtHE5+0132WfjhxVa8gqyte79CYkOk53fTLVXIHwnh0p0sdr9AkJRrZLMLZmUz8FdDuzhAjQZa5xYWfPNbz5V/mSrEC7xcI846jHu2GXm1QJDIwFEKPXPNYfqy8OQEnRvPvHtCO+56H1yiiERpOcONuimJMKQpeAeJK8lXB9XTVdkAEvyzAZEkTgXKn9Il2vdvZNSm0gIHBvCPt4HDbK0/pR5XMWveqIMpzWYh7+A4gtpm20kjTBBWxtTFsSGEMiixzdLteDV3IXo/hc/BE+oVufjlHtbP/LcUnJ8qfFPmz4onCq5BgZOIb2sKcGhVMNHLjhRo4eLdfpDXL8Dm0369yCt0x3QK3Uzl7BG1L3xqsPtor2q5zC8YGdVhk3+kk+oyycYBp6BpmcnXF3Gdox6g9K8l8KTfUz4r+DacjaLymVzLvVKdMxcQyrRBZ6+Q1kZl9HMe4uARes6rBPGoF2hH0cM1nh+y2kNPsk/6u4C1xYVArg0JO8Zgx0iLmKr3CP0N62iJwO/fNvOeVrsZpW18YhZH8Hncd8hHNtUYa5dYLavz79rwzwGXUWGszphDBKk5J4bEvhWUUdaH46qy92n9erQhdbIuCV72YliQ54BRWczgxvq295HWt3TNLw48anHc/IK2oPU2+/3WFiKgWIRPdSJuaTOZNMM3TwGEqENHghjYX7DcMiK3zfrCHDteimrSgzIZWOAXkbHl5kfLmbx1Y/xhkLGHZolAN8wWTHxyFNHuHniIa+1i9oBfMwPD8vSzHCyJR6BKG3Q6RCarSxfSM+ulZPNMvi1oOXU3tQlChbdTpvp5NjwfkYerBwF6AXMlUMhX8rMT/DBPczAXb99ORx+
 ukJ05VjG
 /F48AebGtK/6ODEuQm+nn9J1JfSVm2vqo5vFyQCLpcbUYbtBv9kNyc4/GdOJAIwysixif05WKbg7and8DXF0IKrOgGRDuke0p76nro/0Q4NwJdQdGaeTJvXTuEhDTGNxf7OC+wR+B4uZbHu/bPDxaLLWDzkxRw1cB+Y/Xm4oyWwq20eq+hLJ+Qx39dCjW2BVF/tK94bx26jBgMBJZQzalsVesSEzV5ohr7cX594TsOuunkm2Q4Ht8qoyZCfpKHSlyRj8O9/lLZWvchjmbhwOKLALp5C9oCRjy8F720ukpxamG3XoPYhaaDVB20Z+4FRLy9xGGTAsqVDwZTFnqFOo5O5biLD9dAHM7vo9K5+8Uy0oO3NDPEcDjS0cmsQf4PO3PTw2hFMX9QbeOPVkwl/MgXoUK325Ok/AC8zvuhTZjfUGdnHMOpxSezyfkDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Apr 25, 2026 at 1:28 AM CEST, Alexei Starovoitov wrote:
> On Fri, Apr 24, 2026 at 4:10=E2=80=AFPM Ihor Solodrai <ihor.solodrai@linu=
x.dev> wrote:
>>
>> I wonder if it's feasible to implement KASAN support on the verifier
>> side in post-verification fixups. AI slop for illustration:
>>
>>   ;; Original (1 BPF insn):
>>   dst =3D *(u64 *)(src + off)           ; BPF_LDX | BPF_MEM | BPF_DW
>>
>>   ;; Rewrite (~7 BPF insns):
>>   r_tmp1 =3D src                         ; BPF_MOV64_REG
>>   r_tmp1 +=3D off                        ; BPF_ALU64 | BPF_ADD | K   (fu=
ll address)
>>   r_tmp2 =3D r_tmp1                      ; copy
>>   r_tmp2 >>=3D 3                         ; KASAN_SHADOW_SCALE_SHIFT
>>   r_tmp2 +=3D KASAN_SHADOW_OFFSET        ; shadow address
>>   r_tmp3 =3D *(u8 *)(r_tmp2 + 0)         ; BPF_LDX | BPF_B   (load shado=
w byte)
>>   if r_tmp3 !=3D 0 goto +2               ; BPF_JNE | PC+2
>>   dst =3D *(u64 *)(src + off)            ; original access (fast path)
>>   goto +1                              ; skip slowpath
>>   call __asan_report_load8             ; BPF kfunc
>>   dst =3D *(u64 *)(src + off)            ; retry the access after report=
 (non-fatal)
>>
>> A sort of inline kasan directly in BPF.
>>
>> There are plenty of issues with it: instruction limit, exposing asan
>> API as kfuncs, etc. On the flip side we get cross-arch support out of
>> the box with no or mininal JIT changes.
>>
>> Honestly I'm not excited about this approach, but curious if anyone
>> thought about this, or maybe it was already discussed?
>
> We discussed this.
> It won't work because we don't have that many temp registers for once
> and second it has to preserve all (both callee and caller saved regs).
> This is arch specific.

This "fast path" was indeed part of my initial proposal. For the record:

https://lore.kernel.org/bpf/DG7UG112AVBC.JKYISDTAM30T@bootlin.com/

in the "Basic instrumentation" block.


--=20
Alexis Lothor=C3=A9, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


