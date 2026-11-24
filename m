Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD8C2606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SERjqRr7
Received: by kanga.kvack.org (Postfix)
	id AB8506B07B5; Tue, 24 Nov 2026 11:30:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8FC16B07B7; Tue, 24 Nov 2026 11:30:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97F8E6B07B8; Tue, 24 Nov 2026 11:30:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66CEF6B07B5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:30:23 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36C9480B62
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:30:22 +0000 (UTC)
X-FDA: 85470550284.28.2AD0EAD
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3284E40019
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:30:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SERjqRr7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795537820;
	b=qFh6Hfpl+pS7ZdqCvLAIU8zzGYsGOt/oZ5Wf4euxCF6oUyuvKZvoT4Sb3buoDyBtWijk99
	t5wfxtKEg3qTjfN+D8Px9K8J5yjdQ97Ou2+IcRfliRvFeQvivHpfd7DUqZpskZTFpSem4s
	9sHCe5GWRYJsGmO+ERz/IFsm5wkwtPA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795537820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=faF1vod1YCIOE6mWZF0dptvadZIAmgUkLf51bGNhat8=;
	b=LCYKTQSiHmj3qeSmOcSxMoT3oBAZAVYkrFdOyOLvvQIeYvaouai/KCIX3MQd6ooAXsIQ+6
	NA9ef7V1FZyvcLlOTUaxVV65lWTAf8h+/9OnjwI5F8CWObxzs8KxAFr2sFVhAwR1tNOfnE
	Oz5aJTjr9+xCzGkr5cnrdtNu/VglsD0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SERjqRr7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c516a1623d0so414092366b.2
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:30:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795537819; cv=none;
        d=google.com; s=arc-20260327;
        b=c9/BNI+uf55LyMX9IdwCEMlJGPMa7PExcgiLYBtI8KRvLspbmZstTSvD/TYS2K8fxR
         9sN5EyLqMKRtmsqU8O8+ep4s5TbbDXq5vY8ua0LZF0d26MrJX7LN3bmS6l85t2RSoSxa
         90utUeCUD8q3faZoR1AZnj8MU8woKMiblQlRfuLibbPv1q6skv5q7HtkqIWHtKT+BdqB
         /aMuQW+HpA+BRfeUjBiiA4LmAicGKOSjsBi7SLCI0a0jAszoQQEunHtM/A67ziYtdpYA
         PoguOrEBx+uI96BRz80U8hZ5J5B26SS2WFF47brsOdvjFAANxI7LPGmwh4L8g7nvNhzJ
         bg9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=faF1vod1YCIOE6mWZF0dptvadZIAmgUkLf51bGNhat8=;
        fh=Ep6FVoKtgB2emz2fz8jRJI00AWszFSx8MoP6poFKeYk=;
        b=EgaJy1hpIZlu/wAFQ7wCV4kpJJaXmEf0N58WtDOsSkActJ89kG6YI5wtlhns7cq4zB
         vuHTg0k+C2y6w1JOhFSXVUU6f4/S6VON5hhyBwZIUKDP1S3ljCwwdORbxNOPqJwyCwxm
         2rh2gtAfhjcfATDzW94uFKsWg9wUoG6nBJ2L547YztxCMQVEpl8ypSkUZn+7ZHc3f06i
         cJAyzPEkIhPQK+MGXYLVfd0HmIL+7oTWsxf00Ym24Lg1jo75OAoVKFuO+rma2dbeRxtZ
         KOjvD7Im+dFhkEVlYICmBnxCSBClMuHAEqvXwxt1nA50lDbCcHEOjolxTHCdsAFp+JgE
         Bthg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795537819; x=1796142619; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=faF1vod1YCIOE6mWZF0dptvadZIAmgUkLf51bGNhat8=;
        b=SERjqRr7oJrKgRZIAZlV7HbEM1A56zEUbQuDLimMxIux5fimdrk5j8RHCWMOv2h5YB
         9N017SjCVf2IGwH0/6TCeA9E8Eqn+ODNDJ2baHdbX7OOeho2bt9X+EgmjLxpZE22JLVr
         EyKBfSYhEVTdWZdpsKd/kfH+hnHW9WpEAu57mFWwOWWQk/3nNiVR0YFg2GNdxGLVkdsb
         uJF3LehCQ1OZa8YeIPgkLMWk/ng4tTo87K9EUUNFt5o8b5TCybEhJauYjSBMnBAcLxBt
         dtFqf7tShgaKStzcIjilu2T8fnW8EZJ4qBy5ofS4GHiNuqTJK/wRIdwdJxUL4xPl+4w3
         6DMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795537819; x=1796142619;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=faF1vod1YCIOE6mWZF0dptvadZIAmgUkLf51bGNhat8=;
        b=bxsbCmSthFNwtEWrcR14Kl5Z8vG0NoOCcI2ndr8ZhO4boYvsHAYE9ybhrGN7b/7wPQ
         t1WNqxOtxdHV4PBdtt2Gpg3sirTkvUYfxMRyceJhDhneMuz/y61PRyjb7Blv/prIyXxJ
         Ml6HXpw//XJ18PjfTzGpT2VCu/s1U31to3hYTuuehDaqn/qgZz7lRtTdy6wALCc7OUUF
         N68uW/HPfdx06PbxWpLMn/IPDEVVl/sK+1qdgRKFZ0L94uFCJWE0dlrYvs6a0KX5tSSV
         TNnzSJU3UCUpqwDB3HO/qtlZaRauOffbk1MyzECvxzIE+Gle3MEW6oetJZ6KvrtpNzzq
         KlRQ==
X-Forwarded-Encrypted: i=1; AL+hErEDD7beU8vAbI7PsF9ig6LqM6ReypcmY4Y+pshcaZZZQBGYvvoDDXUf8fbWjQOxYisnmxW+UIaDQQ==@kvack.org
X-Gm-Message-State: APuU4Z8rQIAMdcWJhmKs4udHa8XfvmVfh0RqcZfomk/2fu6/FdbwZ6kC
	OSDwAjy18jW8Tcozdngi9SgSNfcJNmkA6/H85PKeYzPlxmBtIFdL9W3sSKY78B+u83mUzeTODlY
	YK6QI+2yfepCjsTzJXJpTcVcfB2RRfPpEEkBSKaMo
X-Gm-Gg: AZFdTZcH/dg6m2gMERRymf/ExQgnyWbP5bmjhEY39Pi+AYdZQvYSuPpuPj/3y5Ew9SJ
	vc1qsUupEDuhn1IQZ/So8j/lRn5DfbXv2IwA3+Yd0ho7I9UXtbF22eqI6rHFw/igQmKbfV+rcCP
	F8j58XRyYcFzd6mN7t8H+BSS4186+EVCznWSa87uRXrlraoiGHsehY4KgFDuXWQwNSl8EAUmbBH
	YrD5u0a3TaN+hlyUlhnjY4iboVs/K5CQbTxaZ5Fu7MuT94eR+daC3upsxF5Lgnx/o5ZrI2ao8fz
	zhF3DmzRYYQIjrRZybQ1N23WZmK9y/NhZEarcC3Ga6Es/WNlEzAOotT2yzOXd1ZZxQrD1Bpnyg6
	YRe/LKrb92EpiNBLEXQtUwRKt1+o7c5oN/rP1yJ8AqMyhAsXdDfkxNq2x8nxBHEDhLOFLwxjbs4
	nOkMFv2UWW3g5TaZnLeFOnGviZ+I635XBxeL/zQQCZVdwuF0j0wMJN
X-Received: by 2002:a17:906:2a17:b0:c50:f28a:8407 with SMTP id
 a640c23a62f3a-c513aac6733mr1140653866b.42.1795537818175; Tue, 24 Nov 2026
 08:30:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-5-jthoughton@google.com> <4508589C-2E30-4DAB-9465-73121835D0D8@linux.dev>
 <CADrL8HUstWR2pajfYYzRqL7HziVfzZAXJas6MqJkK6pVxSzXEg@mail.gmail.com> <4A195604-B83B-4608-B32E-5F6CC85AE96F@linux.dev>
In-Reply-To: <4A195604-B83B-4608-B32E-5F6CC85AE96F@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Tue, 24 Nov 2026 11:29:40 -0500
X-Gm-Features: Aa3M54oagh8xEkhaXUUOR7MGGzOxphU25lezKmhke56V0En8IXvrXq6W7VgHea4
Message-ID: <CADrL8HXQShKvEu_6KVq0wZXbPjWMcR73yZ38iuePxPRZMDjXmg@mail.gmail.com>
Subject: Re: [PATCH v3 04/19] hugetlb_vmemmap: Use try_update_vmemmap_pte to
 update in-use PTEs
To: Muchun Song <muchun.song@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3284E40019
X-Stat-Signature: xw91ptxuh37tbdtjoqfq8d8ik4z3fwtz
X-Rspam-User:
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795537820-153789
X-HE-Meta: U2FsdGVkX19tRhJzfQgU2J6nNMagoz6OuMyaWrN6MBmncOY4Rn3vVAUKNSfmiw9LvV0cxyzf2qLOGEV3LnV7jyRlOV0fbNpeO20/Qg+g8ntvt4aW6zbJvogu8JtgaZXRo5PlZq1OptsIJZhtiWORdwTPOexOsbOOZ44xjPkFDPQ3769FZYd4OGA2iOKPNncVSXCfpDOe30hIA26+paWhYmQShaesnffQqPuqizBOd+YDgJrDarGhdr8A+sXTy+FxmN50c7TqA/OtZ1VgPxpyo6sdSYAfPfkNXbTgccPwm0Sdct14pnVYRsz/2z5mVk5oglgTn/0UpyKSO5KMHBa2egTYMbVhwkaCzqVHMWXJmDx2srqJ/S9wGHh5fO1gNrInzMvL3TX9Nbc6+JSkMcHKdoQ21p40IBDfDBvOchaHegTX31AGQbHmkJLs0N+O8YEX8gKj142+H34v59cTwTtAi0PlvplmXwGncWr5oCVXjdvU/E8mlFfWaeKF1PVozdASYZ7A6e54lz5LeYAF324bhs03U3pZeOtlNqyn82xqoMv8CUthvOCqFK/JvS7phscBB4NaPXnzyAJ6izW8Srsq1r7D5logfrAEiz+KTrVmBEoS/vjWg/3cEmBpyxw4OWrXn4IFrli7bi+wIRO/ciVpX5L2TIIVlw5/RP/JF38gtPwwoDkMjJuTYHIVzmYEvAN0E1huApyyVIgsKJfGVioHpCxlBizYIg+bAqLbvku1S10z5QmMjxQICttNkBzx6AeocPjyjk9KaVjn4qJVeyj0jrM8s5tdlpDAbwIyDjO/+cX2pv2kpdG6BHEglNL9ULTKjjYGQCwR3d71gy0+T81Sbb3ZBgSwiDKcprfQGZ1C3mRPnPDq8U4EE4TipUAv4CKdrIwsnpEQYeoQwssgUZSQeTzvT4DwUpyMVik5HUmQZ4gxC6GaquKf29hGy7wRNtmTbWMFYATOUPF9JkSGt8i
 3+GH0sQ/
 ZNcJlU0gFDc5MXGma830EVfuZztHZELe7rMNXCkVTICAoQNaKE4UctK/3cMe/apI23wywATEYtOy8C7G+TySOnkXNFmCk5kHi1jPLIvjwz23GNx2TPhNrHHKcL2ow3cp86ss33DvTe0ac0IzwMp8cX0P3Soi9WuTZGrH76nNHF0Pu/esGNevUIx1rJY8MwcxaodZpp6WgZG4B66iuMg5bFK5RGeXrVYhGscTJbtPst1Nqi1wKOx3FU9lwBE5B7KmqWRpcbQ8TCbW0bqp44IZAWs/+9QzPlbgDnW+4cPF/0dUWeED+tLMnttWDtgCMPeKTSfHSDuGD8b1o8iJhEOHncC6PsDpex8wE0lAiZl0GKSQZKClyjhpA1lAKzwjGejgrpZH+ogIbSxsLv/BqEKFJl7klBx9n4XquLNwGklVHkVx5zNPetV5dTVW9AYotLGFQv0KY7D4rC38zvV4QWNFC/5lI54EyOdYuam3FeIPq4hGLYoi0G13kHfudyu82IgiseiKc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 9:29=E2=80=AFPM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
> >>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> >>> index bc1353f03b08..ab33df268955 100644
> >>> --- a/include/linux/pgtable.h
> >>> +++ b/include/linux/pgtable.h
> >>> @@ -458,6 +458,28 @@ static inline void set_ptes(struct mm_struct *mm=
, unsigned long addr,
> >>> #endif
> >>> #define set_pte_at(mm, addr, ptep, pte) set_ptes(mm, addr, ptep, pte,=
 1)
> >>>
> >>> +#ifdef ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
> >>
> >> Why not ARCH_WANTS_VMEMMAP_UPDATE_PTE? Then x86, loogarch and RISC-V d=
o not need define
> >> this macro in their ptable.h.
> >
> > You're basically asking to make this opt-out instead of opt-in, right?
>
> Yes, exactly.
>
> >
> > I like making the different architectures explicitly opt in to the
> > generic implementation; it forces any new architecture to decide if
> > the generic implementation is correct for them. But I don't feel
> > strongly.
>
> We already have an opt-in config: ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP.
> It already forces new architectures to pay attention to it.

Right, but that opt-in is different. Requiring architectures to
manually specify ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE forces them
to think about whether or not they need their own population routine.
But yeah, I guess we can just assume that any new architecture
implementing HVO should have already checked that. Okay.

> > I'll switch it to opt-out in v4 unless you or someone else tells me oth=
erwise.

So I'll stick with this; I'll switch it to opt-out.

Thanks, Muchun!

