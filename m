Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FEE3CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 04:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B3F6B000A; Wed, 26 Nov 2025 23:42:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D632B6B000C; Wed, 26 Nov 2025 23:42:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79AE6B000D; Wed, 26 Nov 2025 23:42:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B52866B000A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 23:42:39 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01A828A70D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 04:42:38 +0000 (UTC)
X-FDA: 84155141238.21.3E02859
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4EB9420002
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 04:42:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eHsW+ylp;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764218557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEhopEuyFNhgXqkSaWLWBfzS2UzIUD/ULoq0kMipD7w=;
	b=D1hC6h+rkC51/Et5ialNlFsoCZKVBSdClp6hymIBMaQNx3QkxKrh/NxVra3FkQvjzZalS9
	JxnehaP+PH4Tad/V3UeeC6UOrw/DryZP6CsZMaQkE7JhcqTssck3dnOEN9X9XrliS6IABt
	jYntqd1QEnHfGxtpw21tmZKz/uVo9iY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eHsW+ylp;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764218557; a=rsa-sha256;
	cv=none;
	b=gQEiO4SyTfg080Ei5Wxr13vyq8yLaVVcV6O2ZQ69kV9h2dZvPnPMi+iVIcrou3NkSU831P
	cN2e+6NDAkwj6rk7p2iZ0WkRrrNtamFsJ755ZtI+62sMurAcwFo0w0o0bIyrTmY94ouy0b
	64kssu9a0evBRdxB6zLioHUmZppn9f8=
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-5dbd8bb36fcso430767137.1
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764218556; x=1764823356; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bEhopEuyFNhgXqkSaWLWBfzS2UzIUD/ULoq0kMipD7w=;
        b=eHsW+ylppBF8bd4VOcKRdTrr+vfVyfEzOwc+wD/zlaufqIePu6+lGZoDEE4SWOT5UJ
         AuGsYdT2vYh7SeUAL2n8GnlxPZCLSiGyYgCYshuUxbkTc1wZTb5ypEsoDEI1z0YpSvqP
         T5YtcwqaIhnRaYpdxDQ1s9o3wTn4WtCnUDdV/wi2MNduPIt4HjxPFsVGN/1ClIQvOkhK
         ILRIi96cCHqEVDYGGf4VzfbnmhwAnqN5cs/8qzuALm6Wjd+TSYUmdQDIjVTSRw4loIeG
         BKoyOCUatdD/qPWjacy8q64PIEbN6qoUWJOaVYJfbSCrRnqggX2p4GBKWnuzOIUFa6ot
         Hjvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764218556; x=1764823356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bEhopEuyFNhgXqkSaWLWBfzS2UzIUD/ULoq0kMipD7w=;
        b=R8u11NR4xuowke4m4Wxe53/B6SwMNY3uTdDORL7fWSO2pObnmmev++Lfn3VtRf8/N/
         zj7mwzciC26/tr835qJrubrhLndkyCnhIzpqqkmwynxcVDoZP82vF2lEveTHsZzGvtLY
         /9wYpiieAQodl3sNzNxhr7bBarXNZtifUT0IiNirs+kIkPoA+8spU59lOrDYyNYdWzud
         b5K7WnWM9zM2e7cRAyDR9osfBGsOR29KvuzX1JpjvW1FTvUadSar2X6PM+771qAzebLl
         XS9d20J8a1C/EB4Cunpewl+tWNjwBdxuM60C4aci+MfIpmy79dLafyqdalJf9RUqltjV
         dCBA==
X-Forwarded-Encrypted: i=1; AJvYcCW51G87aCnVMVzs2VMCEIHLJ8qtsWTLLeqOFwAFNYToMEVe1nDBNoDdxvT23BVCdU++47HvcpBp+A==@kvack.org
X-Gm-Message-State: AOJu0Yw0c1/snFMHsndRVqoWHbq9tVXKBUW6rTK5jeRKbb//quRQh33N
	AEFsCTXeym3K6ZR5B3mv8+oWTtzImPF0UIV5nta2EYKJOxlyeEk3Zcq5aY9/uc4dnoPKhqF8llm
	DjmcRNwK3UhuM9goLfXpjrBwgbRrGe/E=
X-Gm-Gg: ASbGncsWbSoouzcH9tuvq6QHEYyBsZCux96ax2/ASAVRArLaQoZE/5SE3o0YuBYw+2N
	GdXtVBBGOXnpnb1Ig3mFQYoFf7nAeXaHqBFekNR29iZO+rjPdIAE8eMY/SKX6vRo5N5jyEphVcq
	0RNMjeshWvMoosrHT+kU6CFCDz8hLaawUpyUfXO2SOlAdHVbAn8G2/6ZY40bhByIwKKaPNWE5gW
	XSCpgAWJD/BM3BwbIzNlfLuxBTS3hjnmNmtB124l4A8LNEYAB9fXPKyj8Mo/HfKTaAR4A==
X-Google-Smtp-Source: AGHT+IGH43TrgsJFNtUr5ao/vogWT9GdRhnXVZ07KbbMX+jdayVJE8Rn0KQfN/TjkQoluZkh1Kzptkw+oLx2u2WmID0=
X-Received: by 2002:a05:6102:54a2:b0:5db:3c3b:7767 with SMTP id
 ada2fe7eead31-5e1dcfaca59mr9155596137.16.1764218556121; Wed, 26 Nov 2025
 20:42:36 -0800 (PST)
MIME-Version: 1.0
References: <20251127011438.6918-1-21cnbao@gmail.com> <aSfO7fA-04SBtTug@casper.infradead.org>
 <CAGsJ_4zyZeLtxVe56OSYQx0OcjETw2ru1FjZjBOnTszMe_MW2g@mail.gmail.com>
In-Reply-To: <CAGsJ_4zyZeLtxVe56OSYQx0OcjETw2ru1FjZjBOnTszMe_MW2g@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 27 Nov 2025 12:42:24 +0800
X-Gm-Features: AWmQ_blP9KP_04bFNRiiSxH6Z8Vu2JxzZ1V6hdafxe8pxPoB5frW9rAs1E64Uhk
Message-ID: <CAGsJ_4w8550U+1dah2VoZNuvLT7D15ktC6704AEmz6eui60YwA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: continue using per-VMA lock when retrying
 page faults after I/O
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	Barry Song <v-songbaohua@oppo.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Pedro Falcato <pfalcato@suse.de>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, 
	Oven Liyang <liyangouwen1@oppo.com>, Mark Rutland <mark.rutland@arm.com>, 
	Ada Couprie Diaz <ada.coupriediaz@arm.com>, Robin Murphy <robin.murphy@arm.com>, 
	=?UTF-8?Q?Kristina_Mart=C5=A1enko?= <kristina.martsenko@arm.com>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	Wentao Guan <guanwentao@uniontech.com>, Thorsten Blum <thorsten.blum@linux.dev>, 
	Steven Rostedt <rostedt@goodmis.org>, Yunhui Cui <cuiyunhui@bytedance.com>, 
	Nam Cao <namcao@linutronix.de>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4EB9420002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: o8fhb5uaw5ut6dczrf8ia1tckm7coquj
X-HE-Tag: 1764218557-956377
X-HE-Meta: U2FsdGVkX1+U749XuH3XJttw9qzvkcPjnYoN6MrAgb+6fWoF+E6Prcq5VNEDTqx8YCten2q/uP97amwW5mAGsUvdl4vmeZBOlwrFt0Yf6iBSsB7y7inoNuhwVOym71r+/kRjzMm6HQ3/w9dogfAx1vSIONIOx2R3xk6BTcOqzY4kJ3rc48KYjyojBCm3gxEB7H2+sJnrKcSiT7vJBo77wcGPBf4LH3wiSOZtqUleMBGz+UbFDlWrnrvmWhnHQh39yfEwvFqS4Nq62Wa/0tqqQc9NsjGUCeVKjYk+gAey1c4mn1Q+jD7ifiYbLQh5AwZMhWoIL+kAEV+6vr9fNXCxTfIbYuNqQbgtUVvFFNrh8gfjznFTa6xOTEHHDkUdkXS0d/qQsgraBECB22PdHfZbYw5u03rbekADB6Ye5A1u1VYmEgLAdKFZS8ZW38Q27hEAC7e3yPUwtttTNKsY52lvvpRjNvOgngzYjmczZs6g+yvCbt+OVFBPdfAnPnascXauVFC2AiV3FGyqaFDfOFNs9zd1lVXW0cLvcmgtrHMO8WrcT32CqzF+6t/8g9eX5ojwAuGVeQ5n0uMjHlxoAN1/JvlkfsnrPwV1W1FuVQFYpj4XoxwtoKVojZZtogUhMuh9aPqBlo8knAIDiwR0TVCR5iBavQZTXf3SFLUgEuRDryy2i9Lp+9rZlc2DV6xjEmEhnrSJUS+Y94Y+qIaWfRYG3pMHpudvHc+PBQ3vgMrUMMcX5q93RZDkIHyuReTdSW/LMMPLTamwREvJJtUu4y60tdjxIJzFGDs5L1i0Chv/m7nK8XlQlyJQ20N0gChMcVN2TSxwcfAPLd0OG3AvfIrUf2LGt62ylLe8mQ6kKORy60K53aR7m2n6fVMZY+YFDuPTD+8Xio3vs+3zdd+OuWOWRixKCbc80OyC4Xyx2xf4yAmnia6L0oYaBSBggdIMA/6W/r83PrG41KFuXoxUEW9
 xCAzRi0U
 3/6mqBD0AMaaJOo8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 12:22=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
>
> On Thu, Nov 27, 2025 at 12:09=E2=80=AFPM Matthew Wilcox <willy@infradead.=
org> wrote:
> >
> > On Thu, Nov 27, 2025 at 09:14:36AM +0800, Barry Song wrote:
> > > There is no need to always fall back to mmap_lock if the per-VMA
> > > lock was released only to wait for pagecache or swapcache to
> > > become ready.
> >
> > Something I've been wondering about is removing all the "drop the MM
> > locks while we wait for I/O" gunk.  It's a nice amount of code removed:
>
> I think the point is that page fault handlers should avoid holding the VM=
A
> lock or mmap_lock for too long while waiting for I/O. Otherwise, those
> writers and readers will be stuck for a while.
>
> >
> >  include/linux/pagemap.h |  8 +---
> >  mm/filemap.c            | 98 ++++++++++++-----------------------------=
--------
> >  mm/internal.h           | 21 -----------
> >  mm/memory.c             | 13 +------
> >  mm/shmem.c              |  6 ---
> >  5 files changed, 27 insertions(+), 119 deletions(-)
> >
> > and I'm not sure we still need to do it with per-VMA locks.  What I
> > have here doesn't boot and I ran out of time to debug it.
>
> I agree there=E2=80=99s room for improvement, but merely removing the "dr=
op the MM
> locks while waiting for I/O" code is unlikely to improve performance.
>

One idea I have is that we could conditionally remove the "drop lock and
retry page fault" step if we are reasonably sure the I/O has already
completed:

diff --git a/mm/filemap.c b/mm/filemap.c
index 57dfd2211109..151f6d38c284 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3517,7 +3517,9 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
                }
        }

-       if (!lock_folio_maybe_drop_mmap(vmf, folio, &fpin))
+       if (folio_test_uptodate(folio))
+               folio_lock(folio);
+       else if (!lock_folio_maybe_drop_mmap(vmf, folio, &fpin))
                goto out_retry;

        /* Did it get truncated? */
diff --git a/mm/memory.c b/mm/memory.c
index 7f70f0324dcf..355ed02560fd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4758,7 +4758,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
        }

        swapcache =3D folio;
-       ret |=3D folio_lock_or_retry(folio, vmf);
+       if (folio_test_uptodate(folio))
+               folio_lock(folio);
+       else
+               ret |=3D folio_lock_or_retry(folio, vmf);
        if (ret & VM_FAULT_RETRY) {
                if (fault_flag_allow_retry_first(vmf->flags) &&
                    !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT) &&

In that case, we are likely just waiting for the mapping to be completed by
another process. I may develop the above idea as an incremental patch after
this patchset.

Thanks
Barry

