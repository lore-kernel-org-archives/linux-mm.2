Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC95CFF510C
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 16:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11EBC6B00BE; Tue,  7 Apr 2026 12:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A87D6B00BF; Tue,  7 Apr 2026 12:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB26C6B00C0; Tue,  7 Apr 2026 12:09:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6C4D6B00BE
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:09:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EBB48C6AA
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 16:09:18 +0000 (UTC)
X-FDA: 84632244396.18.7D24890
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D8393100008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 16:09:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zg0VQW9G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775578157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlJveMDYEKfKVQwJqQFhg400ubL5f912Md3XDsqP01E=;
	b=nkpbrzGiSqyPIdYx4Ulr3XJELwkP96gaKLedL71IHw7I7/dYwZnfC4OBjHooxoqS0N3J2g
	FnfBSk3u40GX5KhgHA7cCYDhRdt86xayYk/1JdDdAiV+RUgruA5avEsR/XI/9SjoqfeCyU
	Qyqgy+dkI0o2jX3lzZeVf6Iegho42cs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775578157; a=rsa-sha256;
	cv=none;
	b=BYdorPTwxQjGd+EQWfEBhnrr6tnzhCpYTCch4H8chLBYRVWaJR0GzO9V3tgy3RMMzXX69r
	xqT1+64jcfyu0sux9yPBLJBRJaXpXCYT8JYLoqwFuYgnvl282cJ59Kirk1zQ8pNHJKQUFJ
	ENLG9F1SkXC3vU0XroqKyx+cotw3FNs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zg0VQW9G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A7D4143429;
	Tue,  7 Apr 2026 16:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54141C116C6;
	Tue,  7 Apr 2026 16:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775578155;
	bh=IZq3eFoH971hNaQ5fWFSLPAm17OKpP60ehLVeEyCFXs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Zg0VQW9GzIUTKfH117MbdYQt2PE9Sc4Wr1nEsCmi3Da/xmvEFGTxKHShSUU0LWHX8
	 X2geS/H8OmV15mGL62gAEYxqx7j55Uw+TapBNrvWuX6xrpgmzbAhiTdKywdkj8tiaj
	 E8d54gLfpkyftc6CjHlXn3HGKymPd3h+4tFOlbQu2KoLSABJlooA6bzhKTwFTCOS+C
	 Tcq/vALCBfoRSHWjIakzvJMjPMt/SY2UfHf/23DhBbCo8lVzCiKXUmYheuxryZqLrT
	 NIPyhEcg9hC4LIqiCuL3J1wXroInDAn7coPgaBhrDN3N+2Mfww22UGKsEbj/VYHGRH
	 tGrftCCULKaCQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Michal Clapinski <mclapinski@google.com>,  Evangelos Petrongonas
 <epetron@amazon.de>,  Alexander Graf <graf@amazon.com>,  Samiullah Khawaja
 <skhawaja@google.com>,  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 1/3] kho: make kho_scratch_overlap usable outside
 debugging
In-Reply-To: <CA+CK2bCSoKGxfV+0QL46p_GqC=rj0YhcvP__bLrM2rVTgTNr=A@mail.gmail.com>
	(Pasha Tatashin's message of "Tue, 7 Apr 2026 10:18:24 -0400")
References: <20260317141534.815634-1-mclapinski@google.com>
	<20260317141534.815634-2-mclapinski@google.com>
	<abptg2AObfxkkxKf@kernel.org> <2vxz1pgravke.fsf@kernel.org>
	<CA+CK2bCSoKGxfV+0QL46p_GqC=rj0YhcvP__bLrM2rVTgTNr=A@mail.gmail.com>
Date: Tue, 07 Apr 2026 16:09:11 +0000
Message-ID: <2vxzse96ah20.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D8393100008
X-Stat-Signature: mu388wbz7qyhw8gwweia8jeoxkhk8smi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775578156-865908
X-HE-Meta: U2FsdGVkX183sbLBGpno54gC0/zcVJQresA4kYjrQzI5VFLkuyF8XhRIVTNdbQEnLDt7aHsRRcqs6gno5JCX9WqcAk7E8L6hJPyc/6w4sW9t30V4hqsEN3MlHthJxcn94Dq21nbTZMuIU08Dn2yRVx/OeOXueV8ito7Rcki0g6CHS2/mEdTUtiSbqHtJEtOpLctPV/tv8bvUHE+9gJU5fxtsDS+cOfZj7m85lf/2uJ5bIcD7Osu77Lc09WsOfIL/AjwgDrJw678V5nRsb46qkrQKVWwsuvnVPnqOQJ+N7occtmQC7yG+VJgp6ajhA99ZFswei7p4KSWoP0xPqsMtdVw3vXh6E2y8zdQSXFM4+OCEkmLkx9WQOJT34/GQOM650UF/yPK7ZDkopUbLgkB/jDp49A2BH26XSyI6yUyHGLTAQAIN7WsQUrhDR7RR4lfDQfv0JpMhASA3yHm7pUOEfGxJBnj1DACLghL/dlqi17LHL1fPyNFJ/wKPxrbjj76KkHlOIUUObEf8YNg4BQmbis9OE0tsjxIpx6CoDi/ZL/cIYgWNClomTFVWdT+2PjZv/3KcdnIpe9f5OJ21O4g0OHeUks20n8tWA5l1PlCzjH9tnnipZThiwOjRHUkALSDamQcy+BQg7zrP5q3t0y2O36ZcXWhn5j5dIcmQeyAm2gzDK1Rm0wJ/d1DCVxw3lrYNJrNIJSIwHf8eCMQORhF9mDYvsmieLKgQFbDUxx6nkDUO65qevqQbeAKTafvHQG9w1mvUE5E4CWllQnrQ0HFlurhoSdYf5HVfy8oOJCNVTxbhwoOo2aEoGxpe+nGCwtGXFtXZTRY+3ZR5CxsmLSmrMSK7M7E0BHwOVaIFtwnCH6Nd5pfPG0XlOd9RcbyEnPFYPZmXd2iH/6QmZ7tnVJ6Mf2vYOY07tYCUh3HtSnwp0Pr5ulBI/xmoPTYlhNwWE1A7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07 2026, Pasha Tatashin wrote:

> On Tue, Apr 7, 2026 at 6:55=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>>
>> On Wed, Mar 18 2026, Mike Rapoport wrote:
>>
>> > Hi Michal,
>> >
>> > On Tue, Mar 17, 2026 at 03:15:32PM +0100, Michal Clapinski wrote:
>> >> Also return false if kho_scratch is NULL.
>> >>
>> [...]
>> >> diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
>> >> index d2f779cbe279..dc352839ccf0 100644
>> >> --- a/kernel/liveupdate/Makefile
>> >> +++ b/kernel/liveupdate/Makefile
>> >> @@ -7,7 +7,6 @@ luo-y :=3D                                           =
                  \
>> >>              luo_session.o
>> >>
>> >>  obj-$(CONFIG_KEXEC_HANDOVER)                +=3D kexec_handover.o
>> >> -obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)  +=3D kexec_handover_debug.o
>> >>  obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)        +=3D kexec_handover_debu=
gfs.o
>> >>
>> >>  obj-$(CONFIG_LIVEUPDATE)            +=3D luo.o
>> >> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/k=
exec_handover.c
>> >> index 532f455c5d4f..c9b982372d6e 100644
>> >> --- a/kernel/liveupdate/kexec_handover.c
>> >> +++ b/kernel/liveupdate/kexec_handover.c
>> >> @@ -820,7 +820,8 @@ int kho_preserve_folio(struct folio *folio)
>> >>      const unsigned long pfn =3D folio_pfn(folio);
>> >>      const unsigned int order =3D folio_order(folio);
>> >>
>> >> -    if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << =
order)))
>> >> +    if (WARN_ON(kho_scratch_overlap_debug(pfn << PAGE_SHIFT,
>> >> +                                          PAGE_SIZE << order)))
>> >
>> > Can't say I'm fond of kho_scratch_overlap_debug(). How about we make it
>> >
>> >       if (IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG) &&
>> >           WARN_ON(kho_scratch_overlap(...))
>>
>> +1. And we can get rid of kexec_handover_debug.c, for now at least. We
>> can add it back when we have something else to put in there.
>
> Are you proposing moving kho_scratch_overlap() into kexec_handover.c?
> That would make it uglier to have #ifdefs in the C file. If you mean
> removing this function entirely, I think that is too dangerous because
> we have already had a memory corruption issue [1] that was challenging
> to root cause, and having this simple check prevents this from
> occurring going forward. The problem is that changes to defences such
> as kfence, kasan, and asi are happening outside of the core KHO code,
> and it is very easy to miss when something unexpectedly causes a
> preservation from the scratch area, as we have seen this with kfence.
> Worst of all, some of those mitigations use randomized or sampling
> approaches and might not be reproducible on every try, so having a
> CONFIG that tests it every time in a debug build is the only solid
> defense against that.

I think you miss the context here. This patchset uses
kho_scratch_overlap() during MM init to set the migrate type of
pageblocks. So it will no longer be gated by
CONFIG_KEXEC_HANDOVER_DEBUG, but by CONFIG_KEXEC_HANDOVER instead. So
there is no need for any #ifdefs. All we need to change is to have the
debug checks gated with a IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG).

So the function stays around, and so do the debug checks. Since core KHO
now uses this function, we just move it out to the main file. And since
kexec_handover_debug.c has nothing else, we can delete it for now.

Anyway, based on the discussion it looks like people want to ask
memblock directly and not use kho_scratch_overlap(), so the next version
might not have this patch at all.

>
> Pasha
>
> [1] https://lore.kernel.org/all/20251021000852.2924827-1-pasha.tatashin@s=
oleen.com
>
>>
>> >
>> >>              return -EINVAL;
>> >>
>> >>      return kho_radix_add_page(tree, pfn, order);
>> [...]
>>
>> --
>> Regards,
>> Pratyush Yadav

--=20
Regards,
Pratyush Yadav

