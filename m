Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23E7FC5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE7DD6B009B; Fri, 31 Jul 2026 13:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBFC56B009D; Fri, 31 Jul 2026 13:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD4D96B00A2; Fri, 31 Jul 2026 13:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B30E66B009B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:57:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 299DE1C0D4C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:41:12 +0000 (UTC)
X-FDA: 85049636784.22.A35317A
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3CA0620010
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:41:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="fAgU/r4j";
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785516070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+S0di2X0YwWIaY6VQuq99O/SRiscLkhJLs10nTFRS8=;
	b=JTttI5/cZk4a4tpYp3zKzlE2+6tMX+M4JGGdzlQalIcZPMiM/4bkMJPda+ZLXOjR6l+UMk
	y7JKwAo09bC9vjawp58n9GYyxOWqZPR647WujYbDPOOBcwBIprVQK/eV8JsjCGiaM8+39o
	zRUz0O7GIMx8mTKtpWKYkVXIP2QdAhA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785516070;
	b=rsyE/XyU/slUaaVsKVp3OrY+11pxPGRI8DnYjm8i3M+BfdQQRr9emXMl9SWN2DcxDOq0kL
	0XQUspTkTD0JCQDelewSUO1rqY+NFlf9srw2ECtYZBSSZcU4wanRmKn2rfL8y5XgB9/rNj
	3al8e7nMJzBtzoyv2fSZwkJlFQpCx0M=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="fAgU/r4j";
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c10e86e52so291101cf.1
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:41:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785516069; cv=none;
        d=google.com; s=arc-20260327;
        b=Bp1Z9cG3vuQS6POelZkxZ2ScGwxdgR5yMIrylyaowEnjt64uyPpcuYd+Kze7LANexL
         UbWYBUjCG2aEXiwW8xSY7hB/nv3pSn4WQOnKOwlkkRocQ68LQgzTLMcJdLi1NRnm03+b
         NfQEdqmMETGbDb/UM6rb9A8jgyaS6slVCUGBrCBQhweS6JW2r3P5LDyx/L0WzKImJfa3
         F+0ZRA4zojk3N61/phsCshfKIHaU+s8nHNdth4OawIax/RLfnIcOM5DuDajnnNgpY1R9
         0Begn8jTeD3HwvQaIKjJ8dBOYcFoUmZCm4YoAH2Jn3XlbWmXHklGta/Vw4s3lHT9OUi0
         A8lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i+S0di2X0YwWIaY6VQuq99O/SRiscLkhJLs10nTFRS8=;
        fh=SJcN6WiQSSkAb/zQsFieIH+zgg2AA5TIsQrN/toXZm4=;
        b=A126tB8F8J2WrgQfDO9rzLBBUkIbvn4lBnZA1UsRq3cO3pRxi/RBi5WzXZba8I0wsN
         6H/1yONp+h5cXXpr14f8AfPFQx0hKdskYsuw4GBfsRXicAKBFfi8C809jPDzq2LnPIjD
         nr/JaPjPOq44L82mia4GLnCqNaEOA8WK9yqwkU6LoN43yhosPIV3rf/PGj7V6ccObRXJ
         ElKlFLPJ6uue/mv3Ir8fGLR3vw+NlpAcEAW4JnLATdmegeSwdcNyM1u/XF+b2ga0P62t
         klCVI+CL6TrmGpEKoCgUv38NETDhoB2DPWFk7QjeW5wDVLes70PiCPbM61Y4q+1kjveZ
         vDFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785516069; x=1786120869; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i+S0di2X0YwWIaY6VQuq99O/SRiscLkhJLs10nTFRS8=;
        b=fAgU/r4jOGhye/85okdjk7n6ggWMyYymwUpeclz+Jxib5NUWXv7VqiM3/ePDvPnei9
         WGSf0g1DryF8VvNuupC6VaqMvWv4OVPX1I2PvvxDwPeCXNnapZB7YsOW090WzYeOBQk+
         T2qTaC88280BfdP9Rcr1Q1LFEo1v8x6z9DzwER+GBm48ybjU6k9fO6BBauv5H694azzI
         XHcSCN1hP+Bq8KttzGoUxWjsiA8jXG714c1CIv41wbpzBDYuI57rGyhoM8Gqhqi24QYU
         zlst3aiogsEV+hWCGB/u2YCBRN3jlz6dd6CLfKOrUsBZiXabcZCuMyHdtTpkECTMUmsG
         NHQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785516069; x=1786120869;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i+S0di2X0YwWIaY6VQuq99O/SRiscLkhJLs10nTFRS8=;
        b=iBWtaqYZbu3+cvPwhMPmij65Hx0y4mOzBJNih7g8EFsxK7OM7LuRcyGsyyArgZPGvB
         DoHeoZkTAx377WWj9xR1YmJmNHBuW8jGBwCLiiqduDles73cDBU4XPndpeN5+TmiwFvl
         cGYRQGYZJsW47cBnY9zwwvLR1qfuKYyE04XGIxTNfGs8GgR+LfzzKQPhXbfHuRYYRiOU
         Rc5t6HKClNZ70UwjuVQcv9c6WVXqOepPubPyi3tU17XkyBFrwSBokRRKQzZ2z05pp4zc
         BhwzQojMf8fnKy2r8MY4GcR+XpxoheGV5anPu1B+XIdxROd1wEpHVuysH5m6C4RhZMUb
         yDIw==
X-Forwarded-Encrypted: i=1; AHgh+RoMVwRZJOIRIJcLb9DuEw9DQqoEVKvU70CQ+QDPgCQ/Nt5n+ECAAJZg0VEDXcb9338gk2x2AuG9Ag==@kvack.org
X-Gm-Message-State: AOJu0Yyatk+PXAl5/tcvZqGVTs4Ml06Q6+MNdFd7PX3UD1LhqwXuvtVK
	ZSUvLHCD6lOjxSGUKkckbkbY2T23KWJNeEsS2wtPuf3uMkO/BJKYZSzSs4BfKpSd71/EQ955O0Q
	rhzV8iO+7ykPrb+MhZnPNSLkrK+zdmqTAvAVtkicX
X-Gm-Gg: AR+sD10Uzz8g9WFaV4dfJS5SZM0SqfC2upofBGWFbG/fryUutr1mNozmr88Ck2grCsU
	z3atbRL0FQ42nU3sK8fAUWDgoGkSYSRuscD5ok+S+bbnmJGCk1S6957HAjSlwAPGaxV8KGlItut
	bFbgaj5vnYiH9Y6PTB0E/22rz5taplqcroUVeGhsHxFCrxmDTvRbpOh1yvsyo3zz3x0R6TL5CKa
	BOdW5sDgl7phmcooxuceIuPOjfJxfFBzq0zThohbNzaXR9BTZl5n8S5atb6yOBBT1yC+DaB4tdp
	sjEElWrxepSlij6bAuVMxB4Fme8p9eHsDNoxCI9jNI4JdmzchUyX+Fq4FVvIgSQRjyHHVnkw
X-Received: by 2002:ac8:598e:0:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-52b4aeef4cbmr14633211cf.1.1785516068661; Fri, 31 Jul 2026
 09:41:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230415.C0521C88@davehans-spike.ostc.intel.com> <5b27d22d-a3fd-4267-b63b-5de9e6586d5e@kernel.org>
In-Reply-To: <5b27d22d-a3fd-4267-b63b-5de9e6586d5e@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 31 Jul 2026 16:40:57 +0000
X-Gm-Features: AUfX_myd8WR-rKHyxTRYIqU4O90PcBqOHaAe_5w4HYy9Kvov8AvwQm8q27RX__E
Message-ID: <CAJuCfpEnzS7KxYsxU4kTTGFsdYrgpY2gQ46nHR1QacyqLBo9Nw@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] mm: Add RCU-based VMA lookup helper that waits for writers
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Carlos Llamas <cmllamas@google.com>, Christian Brauner <christian@brauner.io>, 
	David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Todd Kjos <tkjos@android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1w7nig4fwua1bk79fahe4t88bkgmkn7f
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3CA0620010
X-HE-Tag: 1785516070-577221
X-HE-Meta: U2FsdGVkX1/tNGXFSGzf2BovNtTPtxvV7k5dMMBDVdO3MkNGhU6lY1jDD9AOi4TMc6h/XmGpCXtkrxJzQmNSba4N7eIY9R5PCk1wTislbVHXDjoAdPaGSjKRP2RS8+UPEtjgwemHHCP+c27V2r1tqUT+t1RwNfag4Z6mWafiVeA9eJXJ8BPnJVJ4n1TttPgXKpLxvUEtPLAobfmitkk+f500+JOKWUKNsP+HJYyxncc5Ja5JlSDZfkitJi172IJfRyw5cWV33dkM24mDit+t2GLQfmR632CIM6JQSXFGJ6vsxxacWoRYmjgLbeX8wVd3YGUF9blSWCUOJMa9fefve6ePJv+5DDY+S4cbovSdkbmsa5XSFKGEzRTMBAWTcOsRD2dDc+j0G+GNnajJBhL7Ol1DCSkHGXrYWLxlTX5/DdnSxqAsbaWGPSMdOtlqCbgVp780kT3FZcU1kHy6hmPNu92XV0jy1MZtSJy0bp/KpYVDAyDTTwVYeuXdEPp8i7wXI7nytU98M7kME8b1VVTrd5l/A8FoLozIG4hq2eDwo6SZuqOIo0bNjPl339rA/c9baII448aQRsdjQ3TPCT8hM0kBh8BoDe3w4058x+JJjWCoqXa/joLQ/FiW8NGRjeLp37eVLvi/x+1yyvuRekrK6RRX0RcycoYo5iwYZhN5O+1JudBlGdPNWCqJSe1XWPNycAEzlY4q5Yy1wD3FqE+nv0OmyIQzDno7Hzn38TQh2hLNzU4A7xKSryAKoORnz/LYyhn8rS8EuZEMh/mSsxe743FcAXT/Xz+qdNj/p2YlAklLPGNrx825vKy1xs9kDW8m8Qv+VRb9Fr5XpTlHvcH0KOVRfbdNy0bZFAdyBVxw0b3it4sAnU495Fx4EVg48lb8ntb+npOsg0NJ7HpdqkU5mM8s8cDamdkb9il3KuToR2PdSP8wu57p+NlYArVoFtssGpFegCdRZhmrT1kBT9k
 /LYPWdOa
 qMDuryjPrORjEb0NkkhqcSzvBANISmFYeQDinIGH+yFELfT/urLRtk7ImuBahw+DABzDRC1jLXQdd/M9yojlPhQKnsxyNKACfhAn5yv9rvhkPfhNcMufnU8oLO5GQno4dQidyBjRhlXFjqqH9htX8M8F/J5pObGb+fetx5j9lGEu/EDsOwojyvGycOOnvtYWQjzr+Ps9tn2F/s4uHUclKdTPxRECbNGwF3oQQ4reICfZ0c28VnkcNW8L+/1Thim36U2o3EYXXCwE23C6v2Kq1Dm+L7IE2iztmo/JYPLBi9D6hSuAQdtd7q7QvlR1N1+M/ZKP7Ru4Vs66wHxAZPmu7vmS2y/PKteDbemrmy9tSRtcklZijZDryscs3dHQGmY0agfOuFjIM4lvEQ28wy8CNIQ3lRUAvTBT+97iQgvk/rA7wFlUmspITeTkQAT8tuA4H3OisI3RnnUsybqV+NGp0ryFK+j85TQtuHSM3XPScIe1UNwDISp4h4I+T+4KJyNxJtdyn1TLi23qVsEqlVGF6I1Hx5T4OH60zvQD+eLItkQenbuyhxGT8euedPzq0Ej/vxp4NiZiEYna3f9Qg0m6eO0Nn1PhaiYfwoyZpLDktmHBbyVd8XMSlvCKJcqgsadSHOQ3CQLpAWRDtegkosD556/qpiTjXzccFpVNN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 6:00=E2=80=AFPM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 6/11/26 01:04, Dave Hansen wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > =3D=3D Background =3D=3D
> >
> > There are basically two parallel ways to look up a VMA: the
> > traditional way, which is protected by mmap_lock, and the RCU-based
> > per-VMA lock way which is based on RCU and refcounts.
> >
> > =3D=3D Problem =3D=3D
> >
> > The mmap_lock one is more straightforward to use but it has a big
> > disadvantage in that it can not be mixed with page faults since those
> > can take mmap_lock for read, which can deadlock when mixed with page
> > faults. For example:
>
> ... mixed with nested page faults and parallel writers, perhaps?
>
> >
> >       mmap_read_lock(mm);
> >       // Another thread does mmap_write_lock().
> >       // New mmap_lock readers are blocked.
> >       vma =3D vma_lookup(mm, address);
> >       // This deadlocks on mmap_read_lock() if it faults:
> >       copy_from_user(address);
> >       mmap_read_unlock(mm);
> >
> > The RCU one can be mixed with faults, but it is not available in all
>
> I'd stick to the per-VMA lock term than "RCU one"
>
> > configs, so all RCU users need to be able to fall back to the
> > traditional way.
>
> This is now an obsolete statement as patch 1 makes them available? But th=
e
> problem is that they can fail and using mmap read lock as a fallback in a
> simple way has the above issue?
>
> > =3D=3D Solution =3D=3D
> >
> > Add a variant of the RCU-based lookup that waits for writers. This is
> > basically the same as the existing RCU-based lookup, but it also takes
> > mmap_lock for read and waits for writers to finish before returning
> > the VMA. This has some advantages:
>
> I would stress the part that the mmap lock is taken *only temporarily* to
> wait for the writers and ensure we obtain a per-vma read lock, and then
> dropped again? As that's the main trick IIUC.
>
> >  1. Callers do not need to have a fallback path for when they
> >     collide with writers.
> >  2. It can be used in contexts where page faults can happen because
> >     it can take the mmap_lock for read but never *holds* it.
> >  3. Its fast path does not require taking mmap_lock for read.
> >
> > Basically, when applied correctly, this approach results in faster
> > *and* simpler code.
> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> > Cc: Todd Kjos <tkjos@android.com>
> > Cc: Christian Brauner <christian@brauner.io>
> > Cc: Carlos Llamas <cmllamas@google.com>
> > Cc: Alice Ryhl <aliceryhl@google.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: netdev@vger.kernel.org
> >
> > --
> >
> > Changes from v1:
> >  * Add a comment explaining that this can not be mixed with other
> >    per-VMA lock or mmap_lock users. It is prone to deadlocks if so.
> >  * Add a FIXME about making the mmap_read_lock() killable
>
> I don't see it anywhere?
>
> >  * Add more chaneglog bits about the possibility for an infinite goto
> >    loop.
> >  * Adopt vma_start_read_unlocked() implementation from Lorenzo
> > ---
> >
> >  b/include/linux/mmap_lock.h |    3 +++
> >  b/mm/mmap_lock.c            |   27 +++++++++++++++++++++++++++
> >  2 files changed, 30 insertions(+)
> >
> > diff -puN include/linux/mmap_lock.h~lock-vma-under-rcu-wait include/lin=
ux/mmap_lock.h
> > --- a/include/linux/mmap_lock.h~lock-vma-under-rcu-wait       2026-06-1=
0 15:57:55.828431712 -0700
> > +++ b/include/linux/mmap_lock.h       2026-06-10 15:57:55.834431925 -07=
00
> > @@ -257,6 +257,9 @@ static inline bool vma_start_read_locked
> >       return vma_start_read_locked_nested(vma, 0);
> >  }
> >
> > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> > +                                            unsigned long address);
> > +
> >  static inline void vma_end_read(struct vm_area_struct *vma)
> >  {
> >       vma_refcount_put(vma);
> > diff -puN mm/mmap_lock.c~lock-vma-under-rcu-wait mm/mmap_lock.c
> > --- a/mm/mmap_lock.c~lock-vma-under-rcu-wait  2026-06-10 15:57:55.83143=
1819 -0700
> > +++ b/mm/mmap_lock.c  2026-06-10 16:02:50.723860779 -0700
> > @@ -338,6 +338,33 @@ inval:
> >       return NULL;
> >  }
> >
> > +/*
> > + * Find the VMA covering 'address' and lock it for reading. Waits for =
writers to
> > + * finish if the VMA is being modified. Returns NULL if there is no VM=
A covering
> > + * 'address'.
> > + *
> > + * Use only in code paths where no mmap_lock and no VMA lock is held.
>
> I think we have various asserts that could be used and are stronger than =
a
> comment ;)

I'm working on a resping for this patchset (per Dave's request) and
I'm not sure which asserts we can use to assert that locks are *not*
held. I think that would be a racy assertion anyway (the lock might be
taken right after that assert) but maybe I'm wrong?

>
> > + *
> > + * The fast path does not take mmap_lock.
> > + */
> > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> > +                                            unsigned long address)
> > +{
> > +     struct vm_area_struct *vma;
> > +
> > +     /* Fast path: return stable VMA covering 'address': */
> > +     vma =3D lock_vma_under_rcu(mm, address);
> > +     if (vma)
> > +             return vma;
> > +
> > +     /* Slow path: preclude VMA writers by getting mmap read lock. */
>
> Again I would say "temporarily".
>
> > +     guard(rwsem_read)(&mm->mmap_lock);
>
> Aside from the missing vma_lookup() I'm not sure we should also trust the
> result of the lookup blindly? Should we also verify we found a vma? Some
> callers might not fail the lookup because they will only lookup something
> that's sure to be present, but some might fail?
>
> > +     if (!vma_start_read_locked(vma))
> > +             return NULL;
>
> You can count me on the side that would rather see explicit operations th=
an
> the guard. Exactly because it's a subtle usage of the mmap sem, and yeah
> also the tracing that Suren pointed out.
>
> Seems to me uffd_lock_vma() mostly does all this right (but also does mor=
e
> stuff that we don't want to do). I'm just not sure right know when
> vma_start_read_locked() failures can happen in practice here (can it be o=
nly
> recfount overflow or also refcount being zero? hopefully not zero if we
> found the vma under mmap lock for read? comment in
> lock_next_vma_under_mmap_lock() seems to hint at that) and what to do abo=
ut
> them. We seem to have some unhelpfully stale comments around.
>
> - uffd_lock_vma() doesn't document that it can return -EAGAIN. (and shoul=
d
> the caller then retry or what?)
>
> - vma_start_read_locked() has a comment saying how it cannot fail, but it=
 in
> fact can.

I'll modify the comments for these functions to be clearer and more complet=
e.

>
> > +
> > +     return vma;
> > +}
> > +
> >  static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_=
struct *mm,
> >                                                           struct vma_it=
erator *vmi,
> >                                                           unsigned long=
 from_addr)
> > _
>

