Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C038BCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 18:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189218E00EC; Fri, 24 Oct 2025 14:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139EC8E00C9; Fri, 24 Oct 2025 14:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0281D8E00EC; Fri, 24 Oct 2025 14:22:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF2488E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:22:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A5B889529
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:22:55 +0000 (UTC)
X-FDA: 84033829110.25.98187EB
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 88E9CA0007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:22:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Pnwy/JeP";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761330173; a=rsa-sha256;
	cv=none;
	b=lsf/QWciJXdWLvN0ByIviF3wKuMmse4BfyaE+VSH6Xrrd1SEHbauSQ2b9unCnX3BMIcqui
	9JbL7U85yD2gFrTcFZ/nq+dCMDWntLHVwWCWnnTsuZ511pRLwPYatOkxSSwA4osAKvXKo6
	+94Y/b0u8JqIp/I9+A3p6fes00djz5k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Pnwy/JeP";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761330173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45Glqcg0Gem2buj0wbJpYwnV1KF+cWqGHfkH8qGnEIw=;
	b=WjdabPo6Uliiue9T5eSXuZQVwHrmv5gH8t89UgYJ4r8pAtoAVEtxs/zijvyyag78VDEgun
	11AH1Mq4BQY1kN7lyEWtnr9+ogrHymEuio3jZ5XXzHiJSV/bBS2YN8JMF+gdGP9yMuybWT
	f9aSeSAZ5pZJUiszsec4s2f3zM4Xlik=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63c167b70f9so1310a12.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761330172; x=1761934972; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=45Glqcg0Gem2buj0wbJpYwnV1KF+cWqGHfkH8qGnEIw=;
        b=Pnwy/JePI3H4tttUtBdX03B//UPwzs53YnMszJh8YXwDC9k+daC11sMstiyrkgBvPj
         pRrc6kbXcjyec/xr0cMXcRGPY43I6YA2WtURFFUr+kNnFH2u7/ncsCIsPYwpnMGBopGX
         D2c0f0IyOYqzKS9nI9d0hhEwj3CECZLv0TaGOhY/UpeQh1/N3Dx4M4THNPrTFNCXFJW+
         8unS3gciry8O1W+ZiTup1XYKwordFO+C68FsaHapOOEShUzD9MlrNyyx3IaT3fkTgqi0
         LqCBVnzGAo4Vs4ytecsbO70eWVUq75M0snGadoTX8Bc0RHCHmh59njDeIcfq/95xK6pA
         WOlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761330172; x=1761934972;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=45Glqcg0Gem2buj0wbJpYwnV1KF+cWqGHfkH8qGnEIw=;
        b=SuwtZri9Ut+ZywBXKAMXeblxj26o52iZ91Yy04EIk8wFIE4ek9xbXt8lQDLBqA4z57
         XOFYNdPeI85TSrLN5m/jU2jPWDNuaIwEULlYe6AqH7KrFncZf0TglgWvNFko18m3UEU6
         f6Xudi8XG6qLTOiOp8U1NtP+bjLXOasvfCvNLPnnGVoUtNLvmhYuoCdVJEUc/Umw9+hm
         1wVOaxtwQ7KRDOfQQW5gjIsQ5WvygIr5j8IWoA5IsWYS8gzJDzUDalyQL+34Tmr2hAd1
         3Y1h9J69OGrjlRcbdvuxF/tAo312PyAFHAwUho1xv7e8zwC5tjCYuVmYk8WE0tcg1sKg
         JZ4g==
X-Forwarded-Encrypted: i=1; AJvYcCVejlBYW41GdcAiE6EFYCfkDRehlcPH3Nv5QRVAd+vf6wS9acINMnNa69uCXIxvQ4aw8a6PgZldAw==@kvack.org
X-Gm-Message-State: AOJu0YwXdDoPNLE/w5wYi4YFSJxdzaRCriFMR9ziXPWOTe1xUp9+MRRr
	E0caUMVq5AxZUGAFHS7Ln6g85JNcLKmi7Lp1xwNOYBCYHrVymln4EBFfofJRCkE76u9seCjmhnC
	xmYy5KwsYXUkaPhOek9MWhbb/cIJ+uHzNHlPPkyIL
X-Gm-Gg: ASbGnctfeboltLTi9xfBi7BxNNpSoUGKXefX3xZbQ4YvXwZ7Viy4LVBtGQeiGd645hP
	2s2oK0BIRBlb/vvQOiDWUcoXXryunRwh8U/zT1A6Vrugh+eTQRohjqidbbPnNDYszWo0g6LoYXY
	BusvXI4m25J73G5MUEFW2Qa9VtEsW9UK5IQ5VpF9NIXX0TYbyxFOO2jdwy6Xceh2DLTG1AyaiHc
	nA1IcWviqbUIePOdDGCoDIqIf7U72jwbHRuo8IANWmCkGb8HBmM6hzwdtENf87AQ1cdnd4RHl6q
	aBaXkwZZ0mL2xVaOLA5CPnBR4yrZx3pbu7c=
X-Google-Smtp-Source: AGHT+IF72XD6SS5uDBKsgbfB0n3K/IVSTeCBW002wjaTSguk72ryj0OlbZfGYhZoZqQsDkeyA4MwnU2ur7strGUV+P0=
X-Received: by 2002:a05:6402:304d:10b0:62f:c78f:d0d4 with SMTP id
 4fb4d7f45d1cf-63e7c419587mr8272a12.6.1761330171855; Fri, 24 Oct 2025 11:22:51
 -0700 (PDT)
MIME-Version: 1.0
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de> <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com> <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
 <81d096fb-f2c2-4b26-ab1b-486001ee2cac@lucifer.local> <CAG48ez3paQTctuAO1bXWarzvRK33kyLjHbQ6zsQLTWya8Y1=dQ@mail.gmail.com>
 <a317657d-5c4a-4291-9b53-4435012bd590@lucifer.local>
In-Reply-To: <a317657d-5c4a-4291-9b53-4435012bd590@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Fri, 24 Oct 2025 20:22:15 +0200
X-Gm-Features: AWmQ_bkmWlnCuKy5iWPqVB59F3jAKLbUke72jlVyJisSwjfh1b1sb1NWw36vd2g
Message-ID: <CAG48ez0ubDysSygbKjUvjR2JU6_UmFJzzXtQfk0=zQeGMPwDEA@mail.gmail.com>
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, "Uschakow, Stanislav" <suschako@amazon.de>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "trix@redhat.com" <trix@redhat.com>, 
	"ndesaulniers@google.com" <ndesaulniers@google.com>, "nathan@kernel.org" <nathan@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "muchun.song@linux.dev" <muchun.song@linux.dev>, 
	"mike.kravetz@oracle.com" <mike.kravetz@oracle.com>, 
	"liam.howlett@oracle.com" <liam.howlett@oracle.com>, "osalvador@suse.de" <osalvador@suse.de>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tet5p18wpqkuzoexrtwf499wjjyouprc
X-Rspamd-Queue-Id: 88E9CA0007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761330173-737099
X-HE-Meta: U2FsdGVkX19h7H5bU+HfQKzssDyQSRx2D4K1xBkoIoo/HkTvr02CF+FMaNgsEvQT2FgDR9w3Xvn17kAjv+2TSdTWF6U8nrpKWZKrHf6NOXJtAkkMh9sQv1ebxriePiBAzqrO0Br2L76/K4TMHIlI73Jg+Ve8201PPDNM3mrVaGqj8yO1xtc8x668xUDDGCRu3Hs3K0MxK3h7f52iRHFpEr3TlWbMh0CghI/xgL3RDoBMX2Rv9OrNp+LVYVV+1xZEWR+p0AoJ+0bpPVZ+kUhv1kI2b0NXfh7BuCuTmvVTh0/UxP+V3tbiEEjyMUFQ/FWTT1pbRz5sTJmPpfCWCtIbl5tmVDZe2cG4GYCnUM3W0D2oW/M3Ci7ghvJ2YZWTTsd8/j088b1q4ZukiIT0jw3DedgoMVTdBhyaeLndRc48/30FbGb4i6KkIeZDWeiVg4VFnqcDRziVwfNPoOwnYRpOE56WR2e/8mCsTRWcbLhgm3++pMUp+j0nz+oSnuUArZNiinQM1iMoBNfzXxXqxbl+6Kky8QnG2rwj1ePEymBfUTChhhVLgDo6sFPviKlXYgeMryPFrKO/TT+arLbw/65L8qW7zvWLjbZ62CnqzTDZcPnj9q9pik6WOwI3nMvblJzqn/qUNoYOdfsoDpa5Q+VNbOkwQy270rWF2EK4UbRgB+oWAp6Tpvf7Y2+4UozvEIHwR0iNh7Wsxei+XcB+n7WQ30uU0YItlQ9sl5X+qQEl5kHxbpZVX20oW5e0b1imScedF0yuPKTVzY8/xtY10Jt4Pgc32WYhQqEJasJ/KKSU2EaLOgQiQmcdDNj/cgS6X9K+QnDX4swzGiBf5q7qIinV2i7PjIDwiHrx93vK4G/Zd7tWZyXzeI5M+3Wtr7SNAUM9l7J9YCgsiKRU4ev2nVVFHpgmTbXsqIeNdxOPZCao26cOq+z8AgTWbgQdcfBGqu6JRcBuUEKEqE56w4RNc1G
 wyRA2eyT
 /pYK7GgKw/lOfkhCnoz6hSgv59zmHZ3Xh8wTBX/zfhB194XrOEQAOTCXdLkPrEwYxraQskLPxNfhchXygbOogYFB0nHEqYv+v2VvJi6EvnilR7561PIsFsvwhXvKAJ6miGukOg65VnNFc1lcsnUU+sDQVkL6hBW+2ydLtGpkVkqsh5vk/NGOOtGSHdVg+9klcIMBaOjEoGABLwyhczADJ+c+nlIrimuNcLAetIgUiTRgeBrAOWJg4BQXzpdXy8ZMyuDJ/59aG0sdhTcaPzWP3l8GEJUKtzMoT4XmPHfmpRChMzy9R8u+jq064bA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 2:25=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Mon, Oct 20, 2025 at 05:33:22PM +0200, Jann Horn wrote:
> > On Mon, Oct 20, 2025 at 5:01=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > > On Thu, Oct 16, 2025 at 08:44:57PM +0200, Jann Horn wrote:
> > > > 4. Then P1 splits the hugetlb VMA in the middle (at a 2M boundary),
> > > > leaving two VMAs VMA1 and VMA2.
> > > > 5. P1 unmaps VMA1, and creates a new VMA (VMA3) in its place, for
> > > > example an anonymous private VMA.
> > >
> > > Hmm, can it though?
> > >
> > > P1 mmap write lock will be held, and VMA lock will be held too for VM=
A1,
> > >
> > > In vms_complete_munmap_vmas(), vms_clear_ptes() will stall on tlb_fin=
ish_mmu()
> > > for IPI-synced architectures, and in that case the unmap won't finish=
 and the
> > > mmap write lock won't be released so nobody an map a new VMA yet can =
they?
> >
> > Yeah, I think it can't happen on configurations that always use IPI
> > for TLB synchronization. My patch also doesn't change anything on
> > those architectures - tlb_remove_table_sync_one() is a no-op on
> > architectures without CONFIG_MMU_GATHER_RCU_TABLE_FREE.
>
> Hmm but in that case wouldn't:
>
> tlb_finish_mmu()
> -> tlb_flush_mmu()
> -> tlb_flush_mmu_free()
> -> tlb_table_flush()

And then from there we call tlb_remove_table_free(), which does a
call_rcu() to tlb_remove_table_rcu(), which will asynchronously run
later and do __tlb_remove_table_free(), which does
__tlb_remove_table()?

> -> tlb_remove_table()

I don't see any way we end up in tlb_remove_table() from here.
tlb_remove_table() is a much higher-level function, we end up there
from something like pte_free_tlb(). I think you mixed up
tlb_remove_table_free and tlb_remove_table.

> -> __tlb_remove_table_one()

Heh, I think you made the same mistake as Linus made years ago when he
was looking at tlb_remove_table(). In that function, the call to
tlb_remove_table_one() leading to __tlb_remove_table_one() **is a
slowpath only taken when memory allocation fails** - it's a fallback
from the normal path that queues up batch items in (*batch)->tables[]
(and occasionally calls tlb_table_flush() when it runs out of space in
there).

> -> tlb_remove_table_sync_one()
>
> prevent the unmapping on non-IPI architectures, thereby mitigating the
> issue?

> Also doesn't CONFIG_MMU_GATHER_RCU_TABLE_FREE imply that RCU is being use=
d
> for page table teardown whose grace period would be disallowed until
> gup_fast() finishes and therefore that also mitigate?

I'm not sure I understand your point. CONFIG_MMU_GATHER_RCU_TABLE_FREE
implies that "Semi RCU" is used to protect page table *freeing*, but
page table freeing is irrelevant to this bug, and there is no RCU
delay involved in dropping a reference on a shared hugetlb page table.
"Semi RCU" is not used to protect against page table *reuse* at a
different address by THP. Also, as explained in the big comment block
in m/mmu_gather.c, "Semi RCU" doesn't mean RCU is definitely used -
when memory allocations fail, the __tlb_remove_table_one() fallback
path, when used on !PT_RECLAIM, will fall back to an IPI broadcast
followed by directly freeing the page table. RCU is just used as the
more polite way to do something equivalent to an IPI broadcast (RCU
will wait for other cores to go through regions where they _could_
receive an IPI as part of RCU-sched).

But also: At which point would you expect any page table to actually
be freed, triggering any of this logic? When unmapping VMA1 in step 5,
I think there might not be any page tables that exist and are fully
covered by VMA1 (or its adjacent free space, if there is any) so that
they are eligible to be freed.

> Why is a tlb_remove_table_sync_one() needed in huge_pmd_unshare()?

Because nothing else on that path is guaranteed to send any IPIs
before the page table becomes reusable in another process.

