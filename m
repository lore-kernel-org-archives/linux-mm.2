Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7075D0D176
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 21:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F27E6B0092; Wed,  7 Jan 2026 16:55:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076656B0093; Wed,  7 Jan 2026 16:55:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8DFC6B0095; Wed,  7 Jan 2026 16:55:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D42E16B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:55:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 871E6B9B6E
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:55:36 +0000 (UTC)
X-FDA: 84306525072.01.F36C5CD
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id ADC1F8000E
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:55:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=B0Rw9RYd;
	spf=pass (imf30.hostedemail.com: domain of maze@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=maze@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767822934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fRI8t9Yow/e3W/odLxxmoc1WYobO0D4rJNJUIXQBJM=;
	b=ARrPm7r9swJ0IsQ6/ca0Tq9A9vtRgm9oRE6q/KeH3bncJ0oMkbpbTiv7zoMJXj/43efEAa
	nnfk680xE0C4JgjvQ1XrK0rlIhHfiYkUAFrkwTyMqs2RlyiRkL6PqnXhUUaKFuWUnmNk80
	TEl65hgJpLGXID3jjev12eOVqpXdYNc=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=B0Rw9RYd;
	spf=pass (imf30.hostedemail.com: domain of maze@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=maze@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767822934; a=rsa-sha256;
	cv=pass;
	b=ZnLS1/Kz6DgbVZVpp2p1dtB/vCsIdcrZ5BH6Q9sS2EUPHJN4Vmh3rxpW1jztBuJKKCamxB
	BKMl2qXeDov5VG+Xg/DK9uv1mkl9kjbTwvoRQDOphSSi8Zi1LGZ3YonllsYOrs1M5MK+8q
	X1+NO7yFF5w8yXDeNTUIAOxyAP14TmU=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ee243b98caso535301cf.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 13:55:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767822934; cv=none;
        d=google.com; s=arc-20240605;
        b=bVlRSL/nljkHo8nrvWOQtnIa5fJ5v33+R9fhfcv2XI7InfJuRumcyTN31KHp+FPyCs
         SS6JbIfTJ1JI7elIs/7mDabqA5/ThNRRivy8BqvAChDYx38MBfdfwOBnb6HjpwgGrJez
         AdfOkkMfKH2q4Yos3+JfycZipSHVNUTXzzgRAJZJueAXxSdaaBt8r6qQgKkUB1xA/7Kx
         kdUBp9F7dTtVWsh1LQfwBGeey8Ar7ENl5Olt8K7H9aZ4dWS4mdp9BU6XpBdsMk7SSEzJ
         ClMmI9fUwUR2oHvDyf7mh2IoJsI6zK1bo8D+ExGYVNpKUJS0ncSMqbZrZ6MuOI7Hvzjp
         yUfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6fRI8t9Yow/e3W/odLxxmoc1WYobO0D4rJNJUIXQBJM=;
        fh=QEf7feLk+J0u2pq3Vt3Rt0zrz+D2nhWJzvevpo4SD6M=;
        b=JgL7MGk01WUXrfg2NXefUSHKc1bm7S3sqXU9TiOZ6oTwmYJJeHTZowTqR+x370EIs2
         c/rml6VCK6iGvTF81qw/tFikrXbZq3n4bQhciZW0MYsv/sMpZIQA8m6UrdG/Aks5hl0W
         lWxK0zxhaS2CsnfajAttXwkko7fwV3vqjmXljiuVrQocpkIhpJ42mZEa+IF+TAPvmhCr
         cxjSjVt10rTpPy5/5I/pcRYiY5mTK8hYpuYdqAv35WUnq3R192NqAHUqYRTdDPEsaSO+
         /XHLREJXsu+BRxGMi8O5SLeE7ffv5EM72Fmnja9J9tvgoYOJfw/+9ZanTf6dQFp5ZrhX
         yB6Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767822934; x=1768427734; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6fRI8t9Yow/e3W/odLxxmoc1WYobO0D4rJNJUIXQBJM=;
        b=B0Rw9RYd6SaBndotH9FclMhtN7/nipwS5090PglwCXtCp1nVIvbNYSQ5K1ycMAtFZE
         yVwhUBLNvVO/aB+zbeeY0WLSBNlasKHSCFfEvrc8mXTlI0lMgoedzfiG5IviCUzc88zB
         1EbGAVE9kWcpNWOZnB8B8vWtzYdHM/aobureINf+HviIoAd/SBXpGkJ7HWoZBloXHC13
         LEKkcYGwNJ7n7Q9U70mDKwQbHzw/XZhBSE5roswK/GPFJIgiY0GV4VBJ7zd9VBu4Aw29
         jpIr2rdk0gJNY3mXKeG9dXGp9q70omRYyncbIpN6aHPjrf6t468L3oX/cQEm6twZ6heO
         Qr5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767822934; x=1768427734;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fRI8t9Yow/e3W/odLxxmoc1WYobO0D4rJNJUIXQBJM=;
        b=v8XuXiImP/yUaPJe4fOtlGK4QSM9rn/StuSO4pf05wPSz4AmVIFo0maRPGZnmQbxFP
         +u2iwnT43d2EV82MPrX4ff1mdx/1ilrJiYX48TNjBiHXrySM+lQ7nuu1yBPAAofOBb1i
         v5DHDsUF/24htEBjrGOgdwWoReH3ONlCO4/se4NYMSAVE+FoR21RdSQcGTKDrQmLfGFu
         9a6tjp6HdlhxCgteh6LmtA92CNewIwWRaVnEQ2y2L8xuGtE8XtaaqBIb20svXSuYJddX
         +vmjSprl+nERdV9LGg9y8QeBEUOAXsx0qFWejxaAF3RuIi1/mG7pxqarg0f4MtYmh1e8
         TClQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/T0VGTHId0IYBxRlMrEgUsXBdwui6QsDktXiEkMwdD9qd2S8jGXfwedRmFJgrXXzVHmafhll38Q==@kvack.org
X-Gm-Message-State: AOJu0Yyt7dDAVp6IfX3FfB3C+lWS7Y33u03QLbCfFiaRgneITso0mQPv
	JDjcWD+KPg7xQ9GB7IJ0K/RBOmUiIBhsfSvaADrMayenL8nRXG7v3EdqnTSTIQ6+SEUCF9qrJNB
	Jsdns7TWy7/lHzeGJMVtmFVgRq/WjAHTwfX0HW1l+
X-Gm-Gg: AY/fxX6Cq5LglJOZSeK0SyQ6KtF6v4cLXS07/yqyJNb9t1Otk2B4AbbuX+Zw06uFcK4
	Zgae1ouNWifbp8N1J4+8Jrie0WmB9xZQKgGW/hW35nFXFpcQtQF7fL44oTiwGriRiuI12l7BJGx
	zD/ehQpSxCWg9ATXgIPV1H15qtUjMtGZO4hyaslcEHg3TLM5LHUxjR7kwOGTFSkySBsKWEHQJAB
	H5oCcqQT3Br1Xs1N/xHNBlq+FqWqbuppYvU+U+/QAzhhf2Oi+vKF9xIObPiOWETBve/iat9li/d
	ILXJXv8dvMNnkslf5BAAdT/JRU0s
X-Received: by 2002:ac8:57cb:0:b0:4ff:a98b:7fd3 with SMTP id
 d75a77b69052e-4ffc091f255mr623981cf.2.1767822933523; Wed, 07 Jan 2026
 13:55:33 -0800 (PST)
MIME-Version: 1.0
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
 <202601071226.8DF7C63@keescook> <btracv3snpi6l4b5upqvag6qz3j4d2k7l7qgzj665ft5m7bn22@m3y73eir2tnt>
 <CANP3RGfLXptZp6widUEyvVzicAB=dwcSx3k7MLtQozhO0NuxZw@mail.gmail.com> <CANP3RGeaEQipgRvk2FedpN54Rrq=fKdLs3PN4_+DThpeqQmTXA@mail.gmail.com>
In-Reply-To: <CANP3RGeaEQipgRvk2FedpN54Rrq=fKdLs3PN4_+DThpeqQmTXA@mail.gmail.com>
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date: Wed, 7 Jan 2026 22:55:21 +0100
X-Gm-Features: AQt7F2oohXGQVvxlmT23b9Uc5zteHdRxxTlRoo--luOtr2cVC6ZeMOEtT_AqGzY
Message-ID: <CANP3RGcNFgLSgKYPjmro2s1Es04Pnhf+4wHpnSwRX4M8bLDW9g@mail.gmail.com>
Subject: Re: KASAN vs realloc
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Kees Cook <kees@kernel.org>, joonki.min@samsung-slsi.corp-partner.google.com, 
	Andrew Morton <akpm@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>, jiayuan.chen@linux.dev, 
	syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	Kernel hackers <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADC1F8000E
X-Stat-Signature: bdjk5saws3o5yd8bq5cucohfe1jyqw71
X-HE-Tag: 1767822934-571264
X-HE-Meta: U2FsdGVkX191Y3RBTZ3+bGiq4Wbsl061jDHXYpEO7d6COaPY4RGlWBtdB5dxCjFExJSX1qq5ff8tHrXCJ54ztRVoN6Dmm74PyejFz/WjPyozORZbM6PDTEwF7DwFXgQULEnY4E2XcubvX0nSvhYbA4Q6WzK4KG97Olw9ERS26pTFxg/7zR/CYPLx5pNzSwKFrsyZicw+4O/OpD9m36jxu3zGKvQR/te4gYWp3OIUOWIR72myfsvuTnINkc3R3trV3vpDR9icNBl/hdJniGIVrSY5UGj2Y5NED1/mu4r8nn6DDf61FRWonGSw8aH53wXfKTsVrhGaqu7bpieOXjAYE1VzIEKPVyofM1c2yousQuTefOyZC0lwFkVeqJCtvDwzU2hF63IKq7Svi0oSefoOFLwucMidQu1QlIJgYFLoHnITD2saL/J4CRl2XMsfIko10Xc4xNz+96BrFE7vhyJXJjA/+AKEslarqZT9II+mg1UT1NWCvxw4bWot0+NQ+xPQxvNO6yoWK6OpOOt+bJbkA5gG0p/D1zMzdDXdEcjHUK3pzSXmcDlnxYeiGEYHOzY81nGgylf+7wHD353oYgFS8LPBN085JDofn6PyXCcOnb6eh5FZ1S75MM55ibaY4f/uU9IO6KvsqloQ7nqhiopLqIadHHWoohuaOcVSy4Lis0NjJLGJBpxtrCSHrNoq4SP09bShpH9gLYAR69DGNXzhs/8CpD+4xfaUnjQmR1WwBrd3UfBKPP8OB08OJlM/SIdE5SY1b8sXfMqr2nyKAwYybPOyWDEhNHDgD+ttIhasrDRs/hCItKeiq8UwYRNkrG56jEgbOowERtM8NJpgVNeyH3SF+C+cYyGXkYJPqp7b6fCrfHetUv+rVFxmn9EEMPaSr/UnmL3piPiZb1zD3IwoPKLIyGlTR3WQJs3F1sV4tML5Xldm12t1H0jYppQeEIdBeWNPtQvez2A9UVBuKLT
 KqIiqIRp
 fHOfEWDFMTeIWRmQlfe4/1CULlBC9ZtAWXGxT6HWI8xOYdSCggdvCcapy6d+DUCvF6cSEtR6CVEOM56ComBtARb3KRapDlJQpSuzeR1NVMx6hCwkfgcVtkS8e+KXu8e0mSx84L4LZ2ykG9hJ3VJDa5iiKnIENZFBfZAEdXyCpTclfzXvxt1oNk3DeUgX3ZgzfrWILDy730Bug3lgHH/SreV8gwREKwpM6KSaw4GWvTtAkI1Wrh6FbNE3hhdFoMEvPrfImNybVHkQS8ViyEx8sFtK9KIr7F7C7zOyJWB8Apxh9WjhfLsHTr3CED2wD/eHtxY22efLFIj6G9qL+SvX0L5cpO6T+unH4lQFKF5MK6sSYKGw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> WARNING: Actually I'm not sure if this is the *right* stack trace.
> This might be on a bare 6.18 without the latest extra 4 patches.
> I'm not finding a more recent stack trace.

Found comments from Samsung dev:

But another panic came after those fixes [ie. 4 patches] applied.
struct bpf_insn_aux_data is 88byte, so panic on warn set when old_size
ends with 0x8.
It seems like vrealloc cannot handle that case.

  84.536021] [4:     netbpfload:  771] ------------[ cut here ]------------
[   84.536196] [4:     netbpfload:  771] WARNING: CPU: 4 PID: 771 at
mm/kasan/shadow.c:174 __kasan_unpoison_vmalloc+0x94/0xa0
....
[   84.773445] [4:     netbpfload:  771] CPU: 4 UID: 0 PID: 771 Comm:
netbpfload Tainted: G           OE
6.18.1-android17-0-g41be44edb8d5-4k #1 PREEMPT
70442b615e7d1d560808f482eb5d71810120225e
[   84.789323] [4:     netbpfload:  771] Tainted: [O]=OOT_MODULE,
[E]=UNSIGNED_MODULE
[   84.795311] [4:     netbpfload:  771] Hardware name: Samsung xxxx
[   84.802519] [4:     netbpfload:  771] pstate: 03402005 (nzcv daif
+PAN -UAO +TCO +DIT -SSBS BTYPE=--)
[   84.810152] [4:     netbpfload:  771] pc : __kasan_unpoison_vmalloc+0x94/0xa0
[   84.815708] [4:     netbpfload:  771] lr : __kasan_unpoison_vmalloc+0x24/0xa0
[   84.821264] [4:     netbpfload:  771] sp : ffffffc0a97e77a0
[   84.825256] [4:     netbpfload:  771] x29: ffffffc0a97e77a0 x28:
3bffff8837198670 x27: 0000000000008000
[   84.833069] [4:     netbpfload:  771] x26: 41ffff8837ef8e00 x25:
ffffffffffffffa8 x24: 00000000000071c8
[   84.840880] [4:     netbpfload:  771] x23: 0000000000000001 x22:
00000000ffffffff x21: 000000000000000e
[   84.848694] [4:     netbpfload:  771] x20: 0000000000000058 x19:
c3ffffc0a8f271c8 x18: ffffffc082f1c100
[   84.856504] [4:     netbpfload:  771] x17: 000000003688d116 x16:
000000003688d116 x15: ffffff8837efff80
[   84.864317] [4:     netbpfload:  771] x14: 0000000000000180 x13:
0000000000000000 x12: e6ffff8837eff700
[   84.872129] [4:     netbpfload:  771] x11: 0000000000000041 x10:
0000000000000000 x9 : fffffffebf800000
[   84.879941] [4:     netbpfload:  771] x8 : ffffffc0a8f271c8 x7 :
0000000000000000 x6 : ffffffc0805bef3c
[   84.887754] [4:     netbpfload:  771] x5 : 0000000000000000 x4 :
0000000000000000 x3 : ffffffc080234b6c
[   84.895566] [4:     netbpfload:  771] x2 : 000000000000000e x1 :
0000000000000058 x0 : 0000000000000001
[   84.903377] [4:     netbpfload:  771] Call trace:
[   84.906502] [4:     netbpfload:  771]  __kasan_unpoison_vmalloc+0x94/0xa0 (P)
[   84.912058] [4:     netbpfload:  771]  vrealloc_node_align_noprof+0xdc/0x2e4
[   84.917525] [4:     netbpfload:  771]  bpf_patch_insn_data+0xb0/0x378
[   84.922384] [4:     netbpfload:  771]  bpf_check+0x25a4/0x8ef0
[   84.926638] [4:     netbpfload:  771]  bpf_prog_load+0x8dc/0x990
[   84.931065] [4:     netbpfload:  771]  __sys_bpf+0x340/0x524

[   79.334574][  T827] bpf_patch_insn_data: insn_aux_data size realloc
at abffffc08ef41000 to 330
[   79.334919][  T827] bpf_patch_insn_data: insn_aux_data at 55ffffc0a9c00000

[   79.335151][  T827] bpf_patch_insn_data: insn_aux_data size realloc
at 55ffffc0a9c00000 to 331
[   79.336331][  T827] vrealloc_node_align_noprof: p=55ffffc0a9c00000
old_size=7170
[   79.343898][  T827] vrealloc_node_align_noprof: size=71c8 alloced_size=8000
[   79.350782][  T827] bpf_patch_insn_data: insn_aux_data at 55ffffc0a9c00000

[   79.357591][  T827] bpf_patch_insn_data: insn_aux_data size realloc
at 55ffffc0a9c00000 to 332
[   79.366174][  T827] vrealloc_node_align_noprof: p=55ffffc0a9c00000
old_size=71c8
[   79.373588][  T827] vrealloc_node_align_noprof: size=7220 alloced_size=8000
[   79.380485][  T827] kasan_unpoison: after kasan_reset_tag
addr=ffffffc0a9c071c8(granule mask=f)

I added 8 bytes dummy data to avoid "p + old_size" was not ended with
8, it booted well.

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 4c497e839526..f9d3448321e8 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -581,6 +581,7 @@ struct bpf_insn_aux_data {
        u32 scc;
        /* registers alive before this instruction. */
        u16 live_regs_before;
+       u16 buf[4];     // TEST
 };

maze: Likely if 8 bytes worked then 'u8 buf[7]' would too?

it will be 88bytes + 7 bytes = 95 bytes(=0x5f) which is in the range
of granule mask(=0xf)

I don't think it works, but it works.

