Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B42C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 22:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9B46B00A6; Tue, 30 Jun 2026 18:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69ABE6B00A8; Tue, 30 Jun 2026 18:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561706B00A9; Tue, 30 Jun 2026 18:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF126B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:03:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 699C5120143
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:03:04 +0000 (UTC)
X-FDA: 84937955088.29.3D1BAE5
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6E880120002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:03:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=TBI5g2tR;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of xmei5@asu.edu designates 209.85.214.180 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782856982;
	b=XdZWzYgQvUeA/j7VG4G3X1Xn5VxFUSGM8h88Oa5ZWzEv7VORR1h373Byxm9IXN/6+F/8M9
	27fNvqi/Z7jUA7T1A0KaWHQVKmIoUrGprpf168kKP1eVomg8reqYJvvl7NG4BOcv7RqJTq
	78X6psjMoRCrAEMjCFpmYJCyglcPVYM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782856982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSFCAf4wjFqNBaM6Rce1T2QXaCGyL1EA8pb2O0uNf+k=;
	b=GvF0mRMY6nhqJfdkHr2RXS2LJmXn1QcxIviZwtC/3eh9Y7bVkf3uShyHR0ucSdN2Sm/5n0
	7HEWN6bD++9592w1gdEj1+6L2Ql7DcInsyo1b0yd0quSR+Jll33y2Rd8c+zCQDzreMLf2P
	U1HVXe+gvJo4ZEMd9HaiHvGVFb3tWrk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=TBI5g2tR;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of xmei5@asu.edu designates 209.85.214.180 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c825c88744so158615ad.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:03:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782856981; cv=none;
        d=google.com; s=arc-20260327;
        b=DL21WXaVhwkIzaBOEQFlOBsUCw4Z3cBDGIHK1adhoDyY2eaAiBzNhW1EzQ5ScLEpyY
         SbcDeP0bbRobcTEhe0Lb8H99eEkil3ucwf5bAnwKRVkpHW0lE1slZu7dlktaeIG9u5KI
         OycX1Tn3l/lR7EumP98xpA+2Z8f57sO/ZgdCoJdQ0uff3OD7Mp7L8Tp0DIn8jxIHGgwm
         rCj8i5j5tBN3fGt/7IPY6xnByNUlwKMgVkJKE5Z8zIPJZ2ezCm6FhpXq1UYHvUycdG4o
         Cqn59iXMOtvY/y4QjzfGyVgVyMBJbo8ZDxLrYLsQCzAeCk2T5YRGxxZwa+3XsWO/kVYC
         /nFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fSFCAf4wjFqNBaM6Rce1T2QXaCGyL1EA8pb2O0uNf+k=;
        fh=kwvF5jFSy9WKrK64qzb4VYOMBlJEeabMB/MsGdK0Wy0=;
        b=VOSYVJUVtyhC8ulK8c+/e5ND1HqDfOzX+6Sft4huk+gO8BsLV7TEIMiQo8WtHPz7Gn
         ruN9ogY3a92Jf7vi/9Hyh/SKoZP0aSB4bmSVtDlmyKM9dchtZ4bSKArY9TBFK4s4iz9A
         GSwCJ3YpgEsfHaUvxm3gd54NJeLvzsfh/tLk1XAg2N6iKfW29JoKVjfG6BgEe9Bhp7V1
         j7X2zRDX6AMLiOUIRqYYHtiRTyye3Ui9iQf3++LUtjbX53agdHVpI2qAR0kPNMVf+ztf
         sBMCbtjJDsWtYU4p6uzPyjHU1WzxOaeeTqxDccSUUtluQ3SOl+arA3zN34Aa3z3tS4PC
         DFjA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782856981; x=1783461781; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fSFCAf4wjFqNBaM6Rce1T2QXaCGyL1EA8pb2O0uNf+k=;
        b=TBI5g2tRgAzlqFT3fjdy9MGK90mQA5OdBMk615XEDvrXuwput7mtmp55bQD+L3jtNf
         zVBfqR4NLulsOsz8X9RScIJROS5r8K9A3za9TYA8cg4Rppr0Hv79EVf4tRYKxDx9dPV6
         th7WZLQthxjnoGaR6P+BA2/AMq5P0KVxP0Tfr1gUjmp4GdbjwqnUNZuOnNgdggX2pz0h
         fUeebinXogUw5fekhhuEQJMUo1WKRzwypChks/m5p4CJJq4lEWHvXUfQ5K8GXI+oHOM5
         all4dmxwOipnxGGKBWj/EboxqgBmfDdFJ8rhgnLZbrtbcb3tUJvWc+5GjVFKbRqbUUGG
         vSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782856981; x=1783461781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fSFCAf4wjFqNBaM6Rce1T2QXaCGyL1EA8pb2O0uNf+k=;
        b=qmsq5YaGS5lZFoY/aXfGLm3hSNdCE0L8d9yOZIYB2uJ/wYhZ1FsZHG+KUBPhNDVCFV
         np0L8OebbOz6jhgSdG9rQcfiznZOg1PFqSn6Mn3h/SqPkovOQ3Lg6lZ3WcYjaXDZUold
         +pYk9g7yb5WIx9xO3r0XXmcn2kEKUntgrHy+n4fN135vhDboEXy3D7sYieITyaFJTB+X
         kLHM8yDUjOFmcXA9DBQ52UUEuFHv6pKX+yN/736jORGIzeC/yFyCQz4HWR/ePpS5cEMf
         JNb6x+/kNIQfzFqvCI/RXtzydcBj4OwCP/TupVcob1y8EKZyX1/lUhJ9gZucW6hQmCi6
         q7sg==
X-Forwarded-Encrypted: i=1; AHgh+Rr6ZcDZ8n9IcuNkrS3TQUEZ2yh3SbcLKK1uyY2e+1hojXyE4LfhtH0rOZQBqOieT2wfV1G34LZ+jA==@kvack.org
X-Gm-Message-State: AOJu0YzKRxHgRI9EFocVkhH1Af0d48/HmRTsLFN8lTOdnYapWruKnDF/
	uCZfJ63rS6+pFICWOo1QzgAHAn7zdz7Xdn0mw7l6+wr9bo32wlu+6kVgf3AtiE+ASV9nz2ih+ly
	03ytlYwMaC9QUZ5zz7QrxSMn+KCd6Uym53s87JPFE
X-Gm-Gg: AfdE7cnlH4NMtGA/qD9tTAHGRQ81bJv3/zsubo5D14KqJW9syGp3+6/KXw6eRkcovFX
	Z8Y0SZbzPvw+GbgDrB0m56LU+BFOkC4fuh0JmllRrlpcaOw1/nbIkcLAv3Z3EP2uD+fhY07qFqO
	u0wTLhV5LsT5zNejXDvUplN/M79f2+nttqTTI0wVtYSDzvD9vo40noHsfCGXy1koiV6K6b4+0Ts
	dAUONnotSNqVu/W55TaN15ieFn111yhYCH1u6QnKXb0oS19UFv1peO6rOVsUjb27nm12PMuJoY1
	nSGqaWp2it4dyFEcbbTkeGlUMBhu
X-Received: by 2002:a17:903:1a0b:b0:2c9:97a8:8c1a with SMTP id
 d9443c01a7336-2ca2eb2f98emr40338745ad.45.1782856981284; Tue, 30 Jun 2026
 15:03:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260629214712.1198680-1-xmei5@asu.edu> <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com>
 <4e96acf4-25e7-4f30-8455-f9b3f49062be@intel.com> <CAPpSM+RhcW=xciX50W3G+2mUVNkmLfL1-BScPN_2TekMbzYVcg@mail.gmail.com>
 <c7c5d2c7-db83-404f-b40f-ee01ae8b9299@intel.com>
In-Reply-To: <c7c5d2c7-db83-404f-b40f-ee01ae8b9299@intel.com>
From: Xiang Mei <xmei5@asu.edu>
Date: Tue, 30 Jun 2026 15:02:50 -0700
X-Gm-Features: AVVi8CdRnHt8kHQRYUk_bp7t-LCebSEbC70Greauv9pAtqRFDRdkvcC4EgUDnu8
Message-ID: <CAPpSM+QVOwhmwspjaUg+FqKsHjiEn7C+gYPEcpJ_UZA=JMj7zw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Dave Hansen <dave.hansen@intel.com>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-hardening@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>, Tiffany Bao <tbao@asu.edu>, 
	Ruoyu Wang <fishw@asu.edu>, Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>, 
	Yan Shoshitaishvili <yans@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: whdnkdreaof75cgc4t3p7xtt8huqg39g
X-Rspamd-Queue-Id: 6E880120002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782856982-218778
X-HE-Meta: U2FsdGVkX1/0W8IlSJx2BWQZbZsi5pXBGRoK/8THrL4eLxaARnCj6jwILSMIMgruMcgscDTfgeRFVQGGQJui1p2Qq25P1ISWGPGnJEr7OXDLDAYNp/ppb3Y1BNp1hqfxiBbFbU4pj2IV5MV/DXm6sSTV/OjWBSWC1N59eq+qbxA80+DP7Mloflv7wbI5Ipte/hLuPRp0MQe4u+wrZ29qGEiAXH0iilBXI2F2I0vq4Z+XFy/bkH5PGWK8GOPYdxetYGvxLDQ3dxrxuXuhMLe4lJ0+LyR1Q+jtYL2xR3yk5jwMTcPDTIu+NcjbNYIU4Bxdq2Zek1TPmV4yh7XeSIvQ/ILez+psPenoZvTdE2iDLuj/63rtPMiPtkPwTzeuQOQ15J8A6CSTArpVnaieNcsd6J7nmeFWG7WdqWyDT0o+4ZRz/Z5eBJ9UV5jNG3AlXfpCgPMlTQGBkBWi1W7hczbdbIHmhhUsX5fwTnmpnzJv9Y0mA4yaDw22rIjD96hxm3OgP32rvupeBnDbPINrCQhB2fnyDi8Pljh34vozpI9VwgkaKOQkiJjQ8CYrKMO9lCtw0NnyARGb2mRmCbDrSKqP+z0hvJBsYD8Wp9l6uGhy5TTjDyy6qUZk6es/8CEAdBkiXSk0JyigNbd2L+5pDmJ+0OyxeSnHch/IhKZzKjUgm7yFYYRuBCCRdFEnQ6wiL90RiRbxDiooNmECDVZtLUoY/fXB4y56U2YIFT/pjOp162SBy/IUCVTLO9d8fwYxBBq/yU1g6w99Ea5r/tBfi5JYNxPZx5+nQ+UVw1D1IP+FxwZ27kJuiIotV18UXjLTDuhrAzOW2r7ACpIXtBsYXj/0GYz/Lpx15vUnSNLaxuzBJ0N5VdaJjMTbT5xzzHl+IYnr0hKoSMbBau282KFpXWefKGQNk0MraJbLGAIjhmfYxm1PaCtwuEl2cqRmjpYpdp7rfpHeHX3AnztRB0+uWhK
 s7CjnZ0Y
 KQnanIpP5F44O6eU6YiSLU+a3VyPzvFQkpNEaX50WCrwoIMWG3WuKQPXPbMHImmJ+aIUD3DBL9fAlYMwaT/QmLZX8FKk7ph/NblTLvzpwavZ7yLZRbb/RLksGE1+870eLsLLA9TkilfeJLvQRYS2K4NraXMrFm5LIfRCXxjKn5wqMAeyWG1mq+kg60wo25gOh3z9QYYwcw02hjpoH9Gnhy1fEriHFM3A1OpAK2zXhyfABXdP2hIupVtn/aqT2Nxn0f4Ulb4NKS1uyvOWf2BA3kibzXiutiuPJOAe/6GRgCjWTKkE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 7:02=E2=80=AFAM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 6/29/26 18:22, Xiang Mei wrote:
> >> Please don't even try to send a v3 without addressing this.
> > This is a demo exploiting CVE-2026-31419 with this technique:
> > https://github.com/google/security-research/pull/397
>
> Thanks for sharing that. That's really good info.
>
> But what I want to hear a bit more about is why this new guard region is
> a good, generic mitigation. Does it help mitigate a whole class of
> vulnerabilities?
>
Thanks for the question. I'll change my words to call this problem an
issue instead of a bug since it's more like an (instruction set +
kernel stack design) issue.
I have used LLMs to evaluate other Intel instructions influencing SP
register (plus checking if such a gadget exists, e.g., `add rsp
0x8000`) and can't find a second gadget that could be used for stack
pivoting targeting adjacent pages.

> I think you're making the claim that this ENTER technique takes what
> would normally just be a DoS and makes it fully exploitable. Does this
> happen for a lot of DoS bugs? Or is CVE-2026-31419 very unusual and this
> stack guard gunk won't ever be useful again?

I may have written some misleading content; let me provide more
information to correct it.
ENTER escalates CFH (Contrflow Hijacking) to ACE (Arbitrary Code
Execution). It can't escalate DoS to exploitation primitives:
1) ENTER is an instruction, and it can be used to perform stack pivoting
2) The ENTER-pivoting technique requires a CFH primitive, for example
  a) CVE-2026-31419 is a race condition, and it gives a UAF
  b) attackers exploit UAF and control a function pointer
  c) attackers change the pointer to be an enter-pivoting gadget
(e.g., `enter 0x8000, 0; ret`)
  d) attackers escalate CFH to ACE
3) ENTER-pivoting is strong since the gadget is common and **one
gadget** is enough to escalate the CFH to ACE
5) Before this gadget, there is only one public one-gadget style
CFH->ACE technique: jump into BPF JIT (mitigated by JIT hardening)
6) This technique can be used for all CFH attacks, and it can enable
some hard exploitations (no register control, BPF JIT hardened).

Please feel free to ask any questions; I am glad to help.
Thanks,
Xiang

