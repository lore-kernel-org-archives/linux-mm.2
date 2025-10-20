Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69D23CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B29118E0005; Mon, 20 Oct 2025 09:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00808E0002; Mon, 20 Oct 2025 09:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D938E0005; Mon, 20 Oct 2025 09:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92C1A8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:46:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45BE456241
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:46:58 +0000 (UTC)
X-FDA: 84018618516.17.A5735AC
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6C38920004
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:46:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=A6UexQmT;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760968016; a=rsa-sha256;
	cv=none;
	b=daELef9l424p2QNm0fn0VvQBrksopWXoM1mvCQmQDTCCLoNhe3bU7ER3a2vrrUXj1VG9q5
	QGb9T8syAM/RjyX2uLcwbIuGkm5xdLCyjzehLW1EZRz1QufXNi2EiPEadfgmcL/d+NBq1C
	KMFyNmIx3nXSTeUoCpTn5jlomXs7lFQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=A6UexQmT;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760968016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DvZhheMKMZpe9Bqdfjty1jLCUGi3kEK1+Ph1/CM26U0=;
	b=sFLDvH0D6uBGvX003pOC3yan9eYYP+Z34rLSoBRFOyJl9F3tqlboEC4dbNHldh46nwmBCB
	gQqaivDsIN6aXouFt8u8s4RY3tKHkxo4+LqPhEvamGR5X5W6JynAUmKRzccjJGwreMhpHn
	YHlDPAILKdk90ruJORpmyaVFchBNjT8=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63c3c7d3d53so4641671a12.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760968015; x=1761572815; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvZhheMKMZpe9Bqdfjty1jLCUGi3kEK1+Ph1/CM26U0=;
        b=A6UexQmTANMkqpuX/k8gkxxvNgWHPxDWLQt/ro72QH5BrZIAkAU0FtmjfO1zqcIzbk
         uLp5dKV5T1zkdrfxE7XmdG9EKHOgBoXVFnDD+2udekOY8dKSZTXVV7Mbu99A1Nl3QOO1
         x5hcD9eHoX3j2lhcoA081eLsrk49vapvb7XMo0JryP/fZg3h+trx+c1Y2CctR3pWgNUk
         nz8n6xd8ZdlmY3MTksgfUqSAVr8oYG0Z0mbtGhASxQTWWmRJmzdP5TAdDGiyZAVcAg3n
         wPpP53JI85zJBfzMTcUtiPJO0edNs3vMbOhWjA+oxaASaBA/hVOrPVgdo6udvICWwnDC
         0ZeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760968015; x=1761572815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DvZhheMKMZpe9Bqdfjty1jLCUGi3kEK1+Ph1/CM26U0=;
        b=BNEMwncWOh4lmSROCO25iB3fXuMF/aUfj5oHapQs7lJpry58B8bNIZ0Uvuc98LSqcV
         aFiFbn9VTX4aGB27TGUVrw69DonWhLfnoveVgzXeaXh/5oLXTLuZSXoSyo1FO78blaSq
         1MkD4UJCbgVlQwVEzyJggjElcZGzE6DFBgTA8QZG2x1RW2F6fmK7A5X8MEVub06Wg92H
         XhEQtBvCPVPpjWADuaEzi2ubwx28o0eTHIs80z1xSyImcGO7Z2keImIWtfFuqrg7jngE
         8OjN/SwI+TjefXKti83XR6vnzAJdq4MTz0AE40pE53SpD6bwy0af6M/z0bjeSO0gUSfh
         RyAA==
X-Forwarded-Encrypted: i=1; AJvYcCUJhR4yijzLF46zxtUPxwcawNfVLtC92FEdqEFdfQWQCEGiMMGImJD6mkuoef5hqnCKkqRAAxaIqA==@kvack.org
X-Gm-Message-State: AOJu0YwAw6AFU30LEGf4SHhveP+sBDn2EGJLoBUGYppNCmoOGUS+PbMm
	mLi8mt1wlRtouSo5w3gjkECx27CT8Y93Hba5DiLaBczlN/rys4bTByrnF80AndyAzUcGohSt3/j
	bVD88XL2L9hmxsOSwqgeafodpGMp/qLXD7C9oLG2dUA==
X-Gm-Gg: ASbGncvrXq/8rA+lezh//ytvAhbQdPnJVJwQwjQnrYjDGSCJC6zf2n9+QOzocBLgrqS
	Az0iFj76ClMexjsQDfFou/SkOyhCpgAKO8AUn57HyR+jHv93JpOMxMotgGXXcj7bi8gBAnGYBYG
	4eFJy0niYaqTy2GITAqr1hy7/CZP3fBbBQ7HFY5J5NcTjEV/dM/IkGBdo5Y4VDWa+AH9vE1sCM9
	U3rf1rgpX6R2VnpEAvLnCMbFqjE9hRPjCf/2zSkTR2uUA8JVDKzjrC/ww==
X-Google-Smtp-Source: AGHT+IGTtXofa3Tuh8IL9I7GRE8Fk7Eo89lAqHP82CDJnTPRhPkL7vp4I1N13r1UMPC1uhalgHforXCkmCNuNpkruuY=
X-Received: by 2002:a05:6402:520a:b0:63c:4819:a781 with SMTP id
 4fb4d7f45d1cf-63c4819ec3dmr8180303a12.11.1760968014329; Mon, 20 Oct 2025
 06:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com> <aPXz-IPDRniMHN0u@kernel.org>
In-Reply-To: <aPXz-IPDRniMHN0u@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 20 Oct 2025 09:46:17 -0400
X-Gm-Features: AS18NWBlWOJhpsHXL5lE0ZnfEqYI5Gk6KDcMcT8UR3vRbPoVwxHnoa0bp6hkqoc
Message-ID: <CA+CK2bDMc8RdcNq_qmmW02DNzLePxQNWBgdOuwrfJ=jmr0YK8w@mail.gmail.com>
Subject: Re: [PATCH v6 00/10] liveupdate: Rework KHO for in-kernel users & Fix
 memory corruption
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gbeoy75bwy4scmtxinf44f1ju5758th9
X-Rspamd-Queue-Id: 6C38920004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760968016-316155
X-HE-Meta: U2FsdGVkX1/+9kuDqpkdcqgkkqKJS5ei7wujaxZtvscKKejEfNO/s21pFUm1907l7Jy37OOGof8unjxzi6jRFISyirzNi6K+MdwGPeHuR7EJVB/ojOsGGwVolQ6eATaTpv/vZcmygBq0jQwoJb60rtAJv7fKN95IyFJA38UXpfPoof6JcvIsGAu8C/iVPhCiWj6Icjjg/DxfaHoyTxDY+RCaQ1YpiYKZTaOkF4hGA+V4Uxk8nif5xuaHhEYebKiAOyXlqTp6xQHNzMGMCm+PLqkh33v/OIUrjF3KawwhmUv26OkoH2yMVVHe1OHpCkKrzilsCEw7jIHgPjQNcrBFQfHvSGvnXPBxFWPI0bwpVX4ns/IqaAuGAelYqLECaGEr4+1D5dz3TNvuMAlxL5bD71wpM/OK02ARkF4CTucGq5euHkmK/29/O8L3GRs7DMWlQnACoW4oB2mpZ+1OhkA2rSc4t+WL8rX+HHkzHZ+CL+UsSBOyZnVNvdjSV0SBVYu1ZnxaZ4kiIUWnWae//eJVetT0sM8Qc42Ux9uPD727cxyc1pHXp/xljS63HbZUj3aVXBOG9M+TYEZ8OHtBwV+RlB4qOBNNeWNDMDendpwob9qD7cs2Y+I7p0L+6AlG3uahhbZLqRef1XRTztzaISfiZlbA5qo3310hFAk1yuzORf5jxMqNI/2cDYllyut4KPdmbMiJNntMpVua09XKrGjg5b4um4hVxMHeXUtrneglQtpZyJEUY7HO93HMfJ2xdcJ+cNi3n4yoQK3sIUuUhvkewSrG37I9l7OrQx2Vgrq3i6s+GEpVOoKzOUJGsjBcX4V4sAQWF5m13542GAYMetAQdPDVlX70Gm3Ep2cFJy5Ga77zOG0Bhprk0TbcS4COZpWaAVq9yimh06IadzCTfgJK7tehNEHjKtih
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 4:34=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sat, Oct 18, 2025 at 01:17:46PM -0400, Pasha Tatashin wrote:
> > This series addresses comments and combines into one the two
> > series [1] and [2], and adds review-bys.
> >
> > This series refactors the KHO framework to better support in-kernel
> > users like the upcoming LUO. The current design, which relies on a
> > notifier chain and debugfs for control, is too restrictive for direct
> > programmatic use.
> >
> > The core of this rework is the removal of the notifier chain in favor o=
f
> > a direct registration API. This decouples clients from the shutdown-tim=
e
> > finalization sequence, allowing them to manage their preserved state
> > more flexibly and at any time.
> >
> > Also, this series fixes a memory corruption bug in KHO that occurs when
> > KFENCE is enabled.
> >
> > The root cause is that KHO metadata, allocated via kzalloc(), can be
> > randomly serviced by kfence_alloc(). When a kernel boots via KHO, the
> > early memblock allocator is restricted to a "scratch area". This forces
> > the KFENCE pool to be allocated within this scratch area, creating a
> > conflict. If KHO metadata is subsequently placed in this pool, it gets
> > corrupted during the next kexec operation.
> >
> > [1] https://lore.kernel.org/all/20251007033100.836886-1-pasha.tatashin@=
soleen.com
> > [2] https://lore.kernel.org/all/20251015053121.3978358-1-pasha.tatashin=
@soleen.com
> >
> > Mike Rapoport (Microsoft) (1):
> >   kho: drop notifiers
> >
> > Pasha Tatashin (9):
> >   kho: allow to drive kho from within kernel
> >   kho: make debugfs interface optional
> >   kho: add interfaces to unpreserve folios and page ranes
> >   kho: don't unpreserve memory during abort
> >   liveupdate: kho: move to kernel/liveupdate
> >   kho: move kho debugfs directory to liveupdate
> >   liveupdate: kho: warn and fail on metadata or preserved memory in scr=
atch area
> >   liveupdate: kho: Increase metadata bitmap size to PAGE_SIZE
> >   liveupdate: kho: allocate metadata directly from the buddy allocator
>
> The fixes should go before the preparation for LUO or even better as a
> separate series.
>
> I've reread the LUO preparation patches and I don't think they are useful
> on their own. They introduce a couple of unused interfaces and I think it=
's
> better to have them along with the rest of LUO patches.

Pulling them out to apply fixes separately feels counterproductive,
especially since we agreed to add the new kexec_handover_debug.c file.
The most straightforward path is to build on what's already in -next.
Let's stick with the current approach.

Thanks,
Pasha

>
> --
> Sincerely yours,
> Mike.

