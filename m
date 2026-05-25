Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79C07CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9D8D6B0099; Mon, 25 May 2026 11:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C757E6B009B; Mon, 25 May 2026 11:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65046B009D; Mon, 25 May 2026 11:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A69266B0099
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:45:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 707D58BB1E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:45:34 +0000 (UTC)
X-FDA: 84806366988.15.819B897
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf31.hostedemail.com (Postfix) with ESMTP id 686B82000E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:45:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LUbnewyy;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf31.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779723932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/KJeVQcoYJeZ7NEMluoiY5LeaLQ6MRIkXZPWciIjMs=;
	b=HX6npTDH59+nvzS/ZnsdyYjxoqqiqATtJMN55c937XcsTGi4zt/KGyx9JmYu6YcuKWNas+
	HVkpM3k9wu63OsSYVKkviSXCArKP6QXYe88uaizV9GKdeFLe8+ZW1podHbOpwwt5QWCrZa
	iv6cVWrbjH71fLTdsXfzvzG7i0/YZz0=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LUbnewyy;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf31.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779723932; a=rsa-sha256;
	cv=pass;
	b=k9GhsLJPwm+y0njXsvM1j7A5tN5X2KgG3oMcqItez4ogYNbXu1h1Bztc52jxzur4qM/h8d
	vnTl3g+k59CXymycR6t9F9YrkfYDAoGKRZubzWMgBEwOUmUcV4Dnh99Pv6EI6II/xwW408
	LbRil+xdWmWrYRARn5Kx/kD/aIXe2mE=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43d734223e4so6152107f8f.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 08:45:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779723931; cv=none;
        d=google.com; s=arc-20240605;
        b=G5A6xOmpRa8ZH3H3kYHYP8htQOWLoffbwtxIplQrbvcvu/plBNphw0e5xMhbiqleBI
         XHnROk4u61s67QMFNQHXISaWRQPcbj/09IqX8J+8ZuvAiXep73+jXtFrio5Q94UFy7v9
         9nlg3ufH2uJIZ7HmlSxAuO8pCEnfCNcqzgF7DMFidcnfkgSLHGsiEQAXQ5MX/Fj6WS35
         eIS1Pf0CSFWUZEJF1TmDtZaUtwJaMYHihmmlus/XWIuChxpuWasZEQK3XTjB6Tc5M2Xe
         lhRWIIAKbo56FAX5oSNwjihxV6kkXafPgF6rp86lVFRItHkldhfAYb9fmNKL9ST3Hf8M
         9G7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v/KJeVQcoYJeZ7NEMluoiY5LeaLQ6MRIkXZPWciIjMs=;
        fh=gwlhQPMCHZZSicJkrSzvwEqwPj+NbeI/4eDoZ6CaiJA=;
        b=lD41O2Bv0Hd2FDW+V7oyromDd8k3CmTQ/jZjc9BtSgPsA9NdGYX6VmOYDnadwobjmn
         atVOpvuNiaaZOxXRK3o2gVGCmFYNMIpn0Gzk1VuiHbUzVc6c+I1MrJOBIsmUwR02oGPt
         T5ys+R3XE5flUp6wHYjbzQfpsZPBkbPNEu7umr9ZGuDZ5XgeybsCYL65jEnvxUG85/Nw
         cfVH7eRZzP9hs0a3UYh22ObaC5PFJgN6ORXdP7WvI4jFuVRTCLgGcnLvWzC8zBOGllXD
         GfDmFd3ZxzMD/hYq8w627ds9v2WD4ELcxt38FMDPiFt4bnq8VvBvBwl5QmQ7//lQ4YvI
         qSJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779723931; x=1780328731; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v/KJeVQcoYJeZ7NEMluoiY5LeaLQ6MRIkXZPWciIjMs=;
        b=LUbnewyyDQ9DDV+j5ff709QZCwhwO0JR/964oc4AvBQAjDk55i/6IlyrfGwsij1Z5L
         krHVMvMEF5Q7Reiy4Hp3+GHoqRrLzO5klnq99GrtaDaLY7GLOwG3xUHPnLF6KfuEZbl3
         mR+1dXZ5joI14hcfPuD33PjlwUjN1uymI3a6M76aOS1QBGHNNZgfyrVpKXSa6quNlx4t
         1PQb5biXg0Vv0rMfBdiFl6X1pdszpgn6VF253kRCBv0zPnyLbGbBiTVdD4Lnoa/Fqv6k
         4SXQz3mA3byYc5htg5byE4haLIQRmNLzPBWZsjYm1+6/bXZ4qnBlcEgun9VDbBpMzLii
         o5kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779723931; x=1780328731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v/KJeVQcoYJeZ7NEMluoiY5LeaLQ6MRIkXZPWciIjMs=;
        b=g0bCy+4VPopS1JeCG6MBSTEPt53uvzuC5r4ZdDnQ2qab9y72P1X0jBsZBZ0p2IDEb/
         Vzzw+eiOY4T9vGUv3yXSN74me23xk3u7zL9JWq93SjmZg6K9y6zPReK5tM0RYJ3Xe/yq
         1MYtzfQ95+pFZ9D/J9Njt52dykuh4Bfa+o/gvs/DW8Un4CHLquh5PMfAt1h/+AIxO9dT
         ZxfsNdDM1HH4roZtgOC0w6PFQSwVBo6MLs1JX+13PmOh6P+4bcF7a6X8HHP8OAaUN5Kc
         z2VSqwdzrwcRSpvjucPoHKSTd0kU/m+FawUd938SMMqpBWTd4dK03QfBr21Wts50YmcV
         Oezw==
X-Forwarded-Encrypted: i=1; AFNElJ8FEFkigc5LJJ8FXCXf92uNzP2nUwIg2qoEJFaNLkrGd0ODa2zOhS2mrVMKAvjvw/W56KAhGFVVhA==@kvack.org
X-Gm-Message-State: AOJu0YzGsqURYWZdp0WoxlQtbKIU5BcMirp7tJ6j+FHanOvt3Sk/UZXl
	YQ425lc2L5BZ9c7RiX5a2YN/6w19KiQf8t70b+Fx5Z5Rw+vJgnjFIy1G4AUb+hmu+CBcP9ES4tH
	MmvtfhkUROhgVec3fzzonbhdIdG2nvak=
X-Gm-Gg: Acq92OHZubg7wMxSqyyMcCw01K7qALhxePkj6Gn3Qkm1U8CUa9mTSNGau5FOWXtX8m3
	pQu4uMNyi3YZeDi+SXVZdJtXe0rIshWmxeJNEoW8BwIOPuYm2yQoip/9RPRmLheEII26h3+KK7z
	WW18q+3CB6wkWQyvY4UZfu08YZOWa64LJdPfOKVSiGqH60Bh8Ph0cRx3aXD/ngjuOojmrDvjb06
	TQ79o3gEWK+e/xvBW81OZuR5Qki3zZu5K702pRlQt4kO9iK/rNC7LYo+X9akKuRUV2WI/i33L+G
	1TTb/xZ+vHAkrPzgPAAeIRZ+DwxGeH2aOGU1EwRjTF+QTFMJAxSsPofZNyA3oS/GM/NLrk4Htl8
	5f61G13tUbXMqUX/yfY2sCeoFUgyQJBfZ6yt+
X-Received: by 2002:a5d:59ae:0:b0:45e:8526:7dcb with SMTP id
 ffacd0b85a97d-45eb30deecdmr22155169f8f.7.1779723930477; Mon, 25 May 2026
 08:45:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260522172219.1423324-1-tj@kernel.org>
In-Reply-To: <20260522172219.1423324-1-tj@kernel.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 25 May 2026 08:45:19 -0700
X-Gm-Features: AVHnY4IIG790PDlY0_eU6bDIBpmGdEOYyU8PJIW44rY53Ae4UthkEJDV1ZzBOrU
Message-ID: <CAADnVQJ2r6qYRw-kRe-55Pwg9zAhj7SQkOd_eH=JSAyBFKKymg@mail.gmail.com>
Subject: Re: [PATCHSET v4 sched_ext/for-7.2] bpf/arena: Direct kernel-side access
To: Tejun Heo <tj@kernel.org>
Cc: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>, 
	Changwoo Min <changwoo@igalia.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev, 
	bpf <bpf@vger.kernel.org>, X86 ML <x86@kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pxd3tfjk1kppqaaztwxoemy6sck766sw
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 686B82000E
X-HE-Tag: 1779723932-534937
X-HE-Meta: U2FsdGVkX19fzsLgUUbhgxt7RLbqIFX6yPLEgMCeETLd3xHAYrSM6Qt/6TeDU1oD9VzYVVlSp3349R6BmitsKKekhwYVCGwNwdQDP9ddfILT5efV84tRsUxIodNr4BJ3e10rudtv5+Iub9yp6pxj8vBBKWTp7XEEoHZau0hSvJFCkaIxmAnlCJWJP7dJdwDFAF66xLxGYVW4GCmYWZzbhN818v6EDfm7w7bmkZAeQORCjAfO3HX0MsUZD0YDOsXjVtTL0WeHzcLon/EMFF1Od8ndYEnTxIemC3cjKBF+0/hIZuMjQr1rSOstymHmdRg+5imchjsZj5kBMjwROxJLbBEl4YZwOplKYHYwhfivhIoCVBFRtEpIe/IKlaWoPi34TOOyfumrMfA6N/SXgX/zZfg54dx4WlqGG9dOKQml8WhOaTu2sHDjLm91Vq/ilvsYTTrTpGzmz2I2/Jxoga0A1UsQ+YG3T1tUd6HUuU04pL28FdYRCdHUp9rVS4KpVPvvc5MlpQ1UyXyHJS3IK5CSKX4smpx86EUwJxvS3yEG029JFKrTo2R6SIHs9kT04i/h4LehPVHA4EDSWh0nX5JzhSRHpeFzB/SwP0X/koDYafl5ec39lHBp/e7oDYQDJYpAxPo9talx/Awmuh4qCLNZvluTquHzhKi5we3pMAXoGn2azJkQSRab/K+WEoDX4ICb1s3foXHL1DwwI2KmhkKA7bvuipUdlYauGz1EVS0IbpQVf8NeT0IkOl4LDC+4daqA56+OgHxrKVzKtlAFJwwgs6jZ9820sZrYnJjUOeEEuftuXd7kq4csv47gsLk9ityM+J7fZmh3gqF9POk5BmU69n9nGcTw5ouRqI03N/NTeF6ew/zBCI2vQBwWp4xcvQY8BLoWupLLP/iClQg0e8wlUBODaIIpXFA/p6BIP0hOmFCrLvaYShbYlcUiVL/EJYLp9SISCoWPfhhQ4ZgO6jW
 omkEBDB8
 SqcdqrQliO1T7HLUu0CP5jntnxrhSksBkEfSXgaXCnQRG08RJE8H72O3d8iddf9YgMlXj1PZU1zv6lXzgvaAyeWxhTXYSAj1ttDaX5mvAM9WxNEqPKfSkuX3M+QaamXWQEHRYFejHJScPh92MmyQxlRlodHfIFm3AAHlUn2fNdMYnXz53O6hDWR0HNRWq6DwSJhIbZnVdphfj5S7NDQr7JeClmKltgxFNtOLEN+8q+q0gKFf5sJXdHFYl9+wzc6qxRpIqxVUP5mN/GSA490WY5p1G0u/T2DX5sCUTpZF/VpvLrZnOFO29eLhWAK2SesAugpfdK+WxkShNTiZrRAEBebkQgMzGP0hDwzbcNOIhUgpV0AEWePlhyGA54DD08DHSnJaD2j42RttCh1EmREi7ymkc+66ni61HJYmCP5zmgedSFbmWwlLhIk2Olkm3Ae3rubPkV0kCU+hWnZL+oQrMEcTPljDdXOfVJUTO4IDdGxnUtcVetvFhHi1Jcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 10:22=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Patches 1-2 (atomic PTE install + arena scratch-page recovery)
> --------------------------------------------------------------
>
>   mm: Add ptep_try_set() for lockless empty-slot installs
>   bpf: Recover arena kernel faults with scratch page
>
> Patches 3-5 (helpers used by struct_ops registration)
> -----------------------------------------------------
>
>   bpf: Add sleepable variant of bpf_arena_alloc_pages for kernel callers
>   bpf: Add bpf_struct_ops_for_each_prog()
>   bpf/arena: Add bpf_arena_map_kern_vm_start() and bpf_prog_arena()
>
> Patches 6-8 (sched_ext: arena auto-discovery, allocator, set_cmask)
> -------------------------------------------------------------------
>
>   sched_ext: Require an arena for cid-form schedulers
>   sched_ext: Sub-allocator over kernel-claimed BPF arena pages
>   sched_ext: Convert ops.set_cmask() to arena-resident cmask
>
> Patch 6 reads each member prog's prog->aux->arena via bpf_prog_arena() an=
d
> requires the cid-form struct_ops to reference exactly one arena. Patch 7
> builds a gen_pool sub-allocator inside that arena. Patch 8 converts
> set_cmask() to write into arena memory. BPF dereferences via __arena like
> any other arena struct, no probe-reads.
>
> Base
> ----
>
> sched_ext/for-7.2 (f31e89a8f583)
>
> Git tree: git://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git =
arena-direct-v4

I created a stable branch bpf-next/arena_direct_access
with the first 5 patches and merged it into bpf-next/master.

Tejun,
please pull it into sched-ext tree as well.

Let's do any follow ups on top.

Thanks everyone!

