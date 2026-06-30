Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 117CFC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B0EC6B00C2; Mon, 29 Jun 2026 21:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887B26B00C3; Mon, 29 Jun 2026 21:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79F3D6B00C4; Mon, 29 Jun 2026 21:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1556B00C2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:22:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABD57C1834
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:22:58 +0000 (UTC)
X-FDA: 84934830036.14.FD6D76D
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9D73CC0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:22:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=YnLBM0G5;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of xmei5@asu.edu designates 209.85.214.174 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782782576;
	b=h3sHVtileeHPHxrp3zw8YDX8U+WP0fiTRy3xLSA8XIpmSapCE+Dkj+Alnt5sqUKoRqMM8l
	zosLG84s9LeF0/+sWN1ySKkXV/lLt4eJ9wXzw5DCmJn+YSsGoGY5kKqqK7AMZ4y1rH6t7q
	0+pygbyTdkagSAM4436msl5jvDtmk3w=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782782576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mJfRZYUuuihM6LVzR7jlhUxtHuYi9//80+qlG/kJg8=;
	b=B+M4LI+RiVLm4ayI32n1qqRpBf8f6/U5rCs4JCS7Z+qg1DEjkK6iYQGh1V8wHICleE9m91
	VrOVqzRi6o40AnliPocwSmSE+KFK2N+bGML0GnJveT1/CMwumtPSQfsiDJZ+sERc19FYTX
	De5AbsvWRyAZMsEsiFYjy8h591OBsVA=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=YnLBM0G5;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of xmei5@asu.edu designates 209.85.214.174 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c821a50615so19774065ad.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:22:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782782575; cv=none;
        d=google.com; s=arc-20260327;
        b=oSfArOrm40dnkvQ+IHPaN8RqnDkiH99vb4bDJc5Z1dVZO/gd9QeXg+dVoTohD4SNtw
         lOPN3KkBOGVPxbiH8bsTr7eWXWWozkmOnQNbxy4Nt+yPCc+Uih+nkRpRFpIWkMJb8S9k
         AG0LKMsIgRtHmEGrueDyoGfSlxJGkcnJwQ0Kl3gsH+xbMziXmiMeSisHkz9ZKyUW91hq
         vvWG8VwpygS9MPfYgEBAK/8v+OGKPD4ZRpgnpkhrNTt8+n/W1Jh2B1zWvETGm3xHzlzp
         TCrt6Cw0FDKyI6jeKEvQQHLGlYj2FPwcCEKGXT/7eemUFvy92xZkICOT1Ilyc8hLFwef
         aHZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3mJfRZYUuuihM6LVzR7jlhUxtHuYi9//80+qlG/kJg8=;
        fh=JQYmvdMvDwP0air77MtL1+Tbk1o61ihMlP5p9XdjsAQ=;
        b=DyKs8n9wEim2uUfjLwKFFYCyxVDgIaiSsHNaiAaEFy+WK0m1H4hIikh0nOudb1iCpJ
         8YM+6NJnCO5nnNRacI7ENqhO7rx2oNEGBvSYPQ+5DCDHh86BGO1dSu9l/4zxxgT/kCh9
         jMSkeeHKAtSoJ6y3+M0LcQv1D2TndOY72Ci3jH1eVfNod3bjKNwhU3X2X+or/EI06zAn
         Fdd8Ogw8GEHzSXKcNyDsrlsIIkP3333r8KbsSPgmTYLda67CEJSQsSGg/bVAViiKcIGz
         9i3zxsGvjQiprhLxJg6GICcIRYQ+Ojn/1xuuTeClFtzvLWMT03BfynhBbb3W4p2cfBYT
         pFew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782782575; x=1783387375; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3mJfRZYUuuihM6LVzR7jlhUxtHuYi9//80+qlG/kJg8=;
        b=YnLBM0G5czbZ3y32M1+8TLRDlIA81jZ7jjpCznHCNK+QI4iDaorAkTnrjdVRf30oRm
         2t5dxUIJpYiK2MEOoXRgVZDjHMCYtUztekD0Vvo7mh1mnJUx12O4QOp5IjWIBVN2JrBx
         eqjStYShA6IX5DI3mdVSBTtZ4QpdCt+PseOOoLMoEuYuND0/OVnjY6LtbMObTqdojpOK
         XQq7uLvbY/ti3R0WIn2V28b0j6vG6UZBxUjRCyhJu4/9dAMUjRaIRlqAM+WfNtTJOlHx
         mltMWB/Wof3G+UCdGrk9ioCflR5KAXIVdms6SRkEnzdn1Sz10dwhSkfNNcioKV7tjRAo
         4Xlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782782575; x=1783387375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3mJfRZYUuuihM6LVzR7jlhUxtHuYi9//80+qlG/kJg8=;
        b=sTAqs0Vg8KJ/kxDxkFsOrbq1ItFY0fCE6/DrbL4OqBY0CFuPEI0kU6yyG/j9bUhkYk
         NAM9ZxgKIL9LOswwqsd3sWHg/Nys1Bo+8cpk2ZI3/fT0+EYL1sRuPkHLA/Tvk0gAoT7Y
         76Lcv+VzjKkI3hEroVxSjt2rm6OaXh+RHph2mjNSbofEDoHaRSNR6shxAS3Ayx20ytTe
         Rn02LWPrlx4cemhQ79ydaU81lOIFyvqzQcbTuU+pIDTZvtJvrri5rvorLVDWwyyGTXRo
         AIdqDtDwCURB7mTtz1tYT6n+wd0+TD3zY7e0SHOiwpazylD+hJJJ0I8SP5mDlp9cMJur
         YGZQ==
X-Forwarded-Encrypted: i=1; AHgh+RpHKquEYQQrNmJhQWi4HvF6z7Ke2GszRhPRjYF8TxBAMrJ68p6W3GvBYhpZKX6+hHKJN9iSA0/gvA==@kvack.org
X-Gm-Message-State: AOJu0YzUI1JQ8yaICVpQifM7MBumkDiW0NmfsVt+TEuSbGsmiWI6eqoj
	3emGHskUs5tmQAZbK4ql92WWRbIOyV4QcE4oAq5N/bPUoMiUc0KaLGrhi+KK/LdRbZRpmBWqvmX
	GxudqEgcb7vU8AWeU70L4eXTbVFd4wBYN0ADkIWsf
X-Gm-Gg: AfdE7cneAtstWSQMy0+SfpYVbD4HTjY7kgluuvdJIbYnhyQU0oEcKRNYaHI3g2OiB9X
	1NqRM3ON24JRn88wZKSkNaH8kpEVNV1L1p/WYGLGT/cd9Zi9Z54DAU3gjcjXzie6OE4vr5IbufN
	g0Y8MwHDrw4k58aykp3Lis8bxOzsbAEutAWs6/RIMDhp6fF2zm1jw8CPoMfHPS08mK1na3n1IxT
	ezoR0rfhyTQqAmrGcc9MWBih6ApbASiH4mdwfu8rYcrR7AuojR8pb9laHlx6jQuHfoTcZ3X90eu
	vIAs9C50kvsGvCsz022r7itgIRmRbidFU4Pj0kRR
X-Received: by 2002:a17:902:e788:b0:2c7:f12d:5d37 with SMTP id
 d9443c01a7336-2ca2d564f4cmr12503945ad.17.1782782575601; Mon, 29 Jun 2026
 18:22:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260629214712.1198680-1-xmei5@asu.edu> <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com> <4e96acf4-25e7-4f30-8455-f9b3f49062be@intel.com>
In-Reply-To: <4e96acf4-25e7-4f30-8455-f9b3f49062be@intel.com>
From: Xiang Mei <xmei5@asu.edu>
Date: Mon, 29 Jun 2026 18:22:44 -0700
X-Gm-Features: AVVi8CdJuTsl6a0UUGxPVPkpf9hXXLqmOnUrxku44YqGlDUi1EXbNbnfzfkvjS4
Message-ID: <CAPpSM+RhcW=xciX50W3G+2mUVNkmLfL1-BScPN_2TekMbzYVcg@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9D73CC0002
X-Stat-Signature: tcrg4rcebdm77ctmsbo9yjw4uf3imu8e
X-HE-Tag: 1782782576-52381
X-HE-Meta: U2FsdGVkX19Xv+JjKquD3LqdLU5LE+n/bCDX+9mMoFITPn2fmCBwyKa/FC4vOUFh8E6ytsR/tH7yvQgf6Ua136d6QKQIUHQgM6xRjlROMhGyrE7WRf9ssdqqR/zGIwWjpTjxnDHxJjCn2t1/3l1UbsVo4TQ4jYvwL6rTzVvS2dyCDJNEHw+5X9aCAdbq7OqSvlawsdqJ9g4LiEhzQLojR+TcQJ8uZWAfV8OIS2Sg9HaoV7tb+N0kA/lPOkiM7eEIM+eTliZPl+WLKFxlImL6HW7Q55lBI1t+GNE81nXCkJrPjnx62c9XMLhhbpaPHQF1+LxI8BbZ+hOgD4HPAUT1E3/KMEJv9errLjg+ZDfessKOJe22Bb1GW7AzxBNsLsLjldX1k+hHsAQpUd9p8bptyD74PAhtkg5QYkDgvVzTRGtMXNsI8Gnu8etf/u2gaMKlHvJqifGyi/fv654uuu8hxScHhZVi/rHKzzNiwUwqptMKrpTAocKPmbYADWCbG/iSWGTqMCNtDF+mfmzfGbZ1BHgyElGpFOG4A1+is8jCNYdM01VLoJCxf0/qV8Z06aET8p0JLsebVlSxT7n5rETS3qHCjzLBgy43o2q3fgQxV8FEcHjsw/xXLVANuioj7aMYGlyr2PShMNBKw3os3Lpjj569BwV56dTdRFZFT0ExTgdXKrdYzCmYAOlL99sHwPT1AsyxY1Q2hstdOTdfJ/hncpIQu4GF7Uu6nyhr4lGf/lJFi7amd7qgxOuwMJR0Tv4grfHH7q3vl7eFKu6isrKGtPH/s5kULjkzK9zwkOXrzpwN5zyKwBCY2jzAqWFPxEXkWJTBGVzPolu/lWHL9ttabjzAy7e7ipgi2x0ARacrzM0jTfx6+gf8jm2wA0qkkIy7ZOQ+uMxC/yhRONuoy5nA9Pj+hE77XoNRlz5RePG4ufgyCzfP6hJMkIpnyP6LTyc6UWbQOAszGn9HCjqkDbt
 BzYdBB69
 h9p4yiHSh72okvVMQiEPKXEd6lfYvaWCpjogz1jwLhdDDjjJy53ToQlGQNR9DmwPofiPuYgUaMTjOM3ZsIbVowQMw4ORDGld2eAGWZCWdjwG1djkoo4cUU7ENMAh7XYDAM3VYSYU9XY5A9D6K32J4I0ZyqH3cQ1VempDJzDLvAJM+APtSV7UZH3jvYtXbWd941zQE8N8orsCv3gKDiAezNQ/ypJdbMKXFN+a9EVcPnh5UneJ1hh81evml9nuasTjPxZJU7QwHqhhfPn0dwzOrbinLls/Y2BmwMoUfBZJ5c9Jzar8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 4:37=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 6/29/26 16:28, Xiang Mei wrote:
> >>> That is more than enough to step off the current stack, across the
> >>> one-page guard, and into the adjacent sprayed pages. When those pages
> >>> contain a return sled feeding a ROP chain, reaching any ENTER gadget
> >>> (opcode 0xc8, abundant as both intended and unintended gadgets) turns=
 a
> >>> control-flow hijack into full ROP execution without any register cont=
rol
> >>> at the hijack site, making it a one-gadget-style primitive that
> >>> significantly eases exploitation. The pivot happens after the control
> >>> transfer, so it is not constrained by CFI (kCFI/FineIBT).
> >> This all sounds super theoretical.
> >>
> >> I don't think we should mess with any of this without there being some
> >> sign that this is an actual, practical juicy exploit target.
> >>
> > Yes, I am sorry to reuse some incorrect comments I copied from v1.
> > I'll remove the CFI-related content since we assume we already have
> > control flow hijacking.
>
> I think you missed the main point: this all sounds *SUPER* theoretical.
> In other words, no real attacker would ever need to use ENTER like. Only
> make-believe attackers in imaginary academic papers. Those imagined
> attackers' only goal is to help mint PhD's.
>
> Upstream, we're concerned with practical attacks, not theoretical ones.
>
> You've done virtually nothing here to show that this is a practical
> attack that someone might use in the real world, outside of the
> PhD-minting industry.
>
> Please don't even try to send a v3 without addressing this.
This is a demo exploiting CVE-2026-31419 with this technique:
https://github.com/google/security-research/pull/397

I have no comment on your PhD-minting story. Let's keep this issue
free from personal stuff.
I would like to demo you that this technique is practical. Please tell
me what you need to prove that this bug is practical.


Thanks,
Xiang

