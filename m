Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 608D1606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=bSYWm2Fb
Received: by kanga.kvack.org (Postfix)
	id 79C8B6B05B4; Mon, 26 Oct 2026 22:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7745F6B05B9; Mon, 26 Oct 2026 22:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A0F6B05BA; Mon, 26 Oct 2026 22:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4256F6B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:40:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BEADC808D9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:40:11 +0000 (UTC)
X-FDA: 85366851822.30.B8B605E
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id D1EF71C0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:40:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bSYWm2Fb;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793068809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqs34zcQCNfaKeG0W4YG4prKIZumwiPNl9JfXSdONU0=;
	b=xwebE5Vn8h7Y4Oq5JvA2lrJFuRqQ/Ti9aBKqgmmNM2Imp5LgOdcPf2fdjJrf0zU2cffHRy
	2d+qAkbQdluPex2AE4i1KNIGE+vs+/OouJdMo1tBxYQ3CsNnsrkrTLqM2XygTQe5SWGXCU
	Wd04x8In0HDfDVfr/LEQ5spr+dGpeJM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793068809;
	b=2yEH/lDexLRsCF5D7xD7btx0+UYm0T2lGb29K+/e6h54az2UdWCQY5t3fI2yfSO5+OEbYa
	LDqN6JKyJsuTwNYQgksKFG1OnLucPrp06q93gd7aEAmtOXOaty2ourLeYJznrVA4eeKtEc
	x1fgVM73pjI4AU/SJRhbiCJBlYigwWY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bSYWm2Fb;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-533202fe429so174001cf.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:40:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793068809; cv=none;
        d=google.com; s=arc-20260327;
        b=fhuX0z8QWetsVhd405Vs5dTPsDIiJAvjmStLIzttx4lo4TM75DL9nwrF/f+5C+CbY4
         5wKxijmwINFVCr039056DmYnb67W0l72MyWewHP2ScxF74lkJtyrFH6a8QfaOsiuDRyW
         eScd0m0BjNlhW141153RoFCg8ABhc0rB1hzlCgGevXf7wtoqqtF6Uvp0PZSHUxTPqk79
         S/SiPxswHMkyNgM9PpRxMdtaWs6PR2Lxr/IAshKTLnczuJZJ7Mlsaq+JrZFG9NCViCkF
         x0yY3KhRqjtFRVp6WuymyD88X7G66tJ4RKWaPcj+AC+a/AuRwt0b8ixJ789L7JZy/0Gi
         9e7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uqs34zcQCNfaKeG0W4YG4prKIZumwiPNl9JfXSdONU0=;
        fh=IL4hKCplYGcedAiMVkjM/CI4cGE9lpwHGeAr/L1+I90=;
        b=jmygYzPL8PhMTsRQWH+4iLoJWm8BXsB8iHscMa1RZCpeRo8U4XRpB1YrPrYZxVXv2d
         vPB8PBjPoOHP7ikPA57maR4YVQTrJI0kCnFkNBTm7PAhKVzulI9PvqO4tZQ1ybC0+Z8v
         PeW0TGDcuZs/cBIWuADWHfyjHG0pFN2xQJ3Z9uaLOnU/twOo8ALLePc36AEQ8l475kRZ
         zDDo4xdULbWZwOxBAECFo6LF69fVAjq0i88inMa1Q2UxPgs75nSkyjfb19Wpzq4hszDs
         NaI8Edf7mgM3ODZglHIm4g69wf/NKioUKHUsCw3+p2nSexkWIqjJzxA9NVH4Ps9ntN0v
         xOBA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793068809; x=1793673609; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uqs34zcQCNfaKeG0W4YG4prKIZumwiPNl9JfXSdONU0=;
        b=bSYWm2FbhgHMgCH5Y0XschjONxVYAD480xuUtenuB2c5zvoD9p920tSFC68n1xcsXJ
         l0UXNYR6TlRsckxt4jkt2f5UDYqDnypXttDO8Co/LKeIJHBl8f11nvnlCsmUu4h8Nhu8
         +BTyKe1aVg8+P7Y2SvtLii+d/lXum6Y1gjbhmlvZWHxxSiOPMQ3+tsuPkXPdV2eHTJNT
         24u5QfvCUW7WhbxpWa0clk3UwXFtDO4eWiYnzAFIpbC4346DlEqMg/VcHCX5m1uc/CgO
         hiVoubOEjlLAFp2mADgao8M5pmAchMZF1jxnG8Ht8KOH/DiFDDDrpTdYnMsV03mqUJmO
         QPOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793068809; x=1793673609;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uqs34zcQCNfaKeG0W4YG4prKIZumwiPNl9JfXSdONU0=;
        b=YahTIx5tNgkOl4lB+5WBccxGn5rPt4Bta/2DNKN3Lml1XNJryD1vcqr/o2qeAPbCIt
         cuS06EuTjAtebnoRyMXNAfn44F/UyCbQ/2GHE5FaqhCFy+OL5CJhOxMyt+LXsfrcuV6I
         hC3Rf2mSa9Kyx1zalgdPxcLlDnQHgsTaAJCJpkQgosuvDw+SadPFf+6laj09xkeFm8aA
         DJ1Z8Va/KhEkBPnhXgkyOD6fgREAc3YsAxeuTVTvzOBgWgt0SPgxmZHcWwEF45syBy7u
         2VG7+4E/8UC8RavEsObtFW9GMKnlFe3I0J0CSYEYnwKIheccC+TZ/hAy20NS1vNn/JGw
         sXgQ==
X-Forwarded-Encrypted: i=1; AKwUvBzt/z6USg6Qy6ERCDnhDGexqVOkOZ3XPyi3F0eZQcOKPP5xG1XaalRN+Fb1YRIW+cF0cgB2bVY4GQ==@kvack.org
X-Gm-Message-State: AFq9FYJ+lizBdkJqPjYI3R3nAqZvibR7xEAtlNGwgoOcOvSJ6Z6Lf28s
	r9O7wd0ryg+k2R1CiBtXkas0Ky8y1mWsHVE3R/VU6Ez4Rnkylgz8OcP4sGnwDd84EDy8iLWA6IV
	5GBSeXF56RD1Yt18Hi8yYjpoQJzutSrTuApLQSQHl
X-Gm-Gg: AYBFou2neENpUu7Qz7CDShLl3vGPsIfvZk52qeVd0cE1cySbifdkWNs0AEWJeCdS6PR
	G6WnC7H5P/y8ZVaGJmaw9UjEY66DSv7VZXm28xbNYLrZOj3ILGLtaOrVXxux1ztJtSQCy/K+PGU
	EblS2wNl8VA+leOs12BYx9/zUh+e9v/JHzNlPPamdDxJuvMtiunONAenZrC552Fn1RUJJJDVCy8
	EH98YK5uNKUmdOSC1W7fm0YLiQZmteCJrxSOEUi6XQfQaBHjwlDWRVXGnNNh1TGvi39x7zHl171
	AXFC510psM7l7JjEkU2mRa7gmztlHyXHH1nWQoYw8ClT5PjQqqznS1s9tn15VgQZaSliy6oEmC9
	WdLbtqOlpZjp8/wIQcHX+FyDbOwkm/hgZWI8=
X-Received: by 2002:ac8:5cd0:0:b0:534:b7b2:634f with SMTP id
 d75a77b69052e-53e74f18ea0mr8104501cf.8.1793068808195; Mon, 26 Oct 2026
 19:40:08 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260911025613.1220845-1-zhanghongru@xiaomi.com>
 <arFYRAa-i7CIwmHL@gremlin> <arF-E3Nsw9ZliH0t@casper.infradead.org>
 <arI_w2wTfA00Mgy9@gremlin> <armexcXDiG8ryZd6@casper.infradead.org>
 <CAGsJ_4xuFi7K+crAcFQ998SxXS0xPM6QeA34JV+6+Sy005rXLg@mail.gmail.com>
 <ar7MsOb6IJLt4eLo@casper.infradead.org> <ar-o1TrOMGrrcxLX@gremlin> <ataDTEZIKOYtwhUF@casper.infradead.org>
In-Reply-To: <ataDTEZIKOYtwhUF@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 26 Oct 2026 19:39:57 -0700
X-Gm-Features: AclHuK_tjvOAxlKicwQpIP5-vlb-UBKyvjNqAPJfVeuqkSwvVjNbbsDgO4TDlgk
Message-ID: <CAJuCfpH88HGXyLzBr6YGxzTrOq18HaPcRvhN9RwEBxG_ptv7KQ@mail.gmail.com>
Subject: Re: [PATCH v6] mm: retry page faults once under the per-VMA lock
To: Matthew Wilcox <willy@infradead.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Hongru Zhang <zhanghongru06@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, liam@infradead.org, 
	mhocko@suse.com, rppt@kernel.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	zhaonanzhe@xiaomi.com, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, 
	chenhuacai@kernel.org, kernel@xen0n.name, loongarch@lists.linux.dev, 
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, linuxppc-dev@lists.ozlabs.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, agordeev@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org, 
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, 
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org, 
	hpa@zytor.com, Hongru Zhang <zhanghongru@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D1EF71C0006
X-Stat-Signature: 6kffdbqt7umuompupi9kqf98usbzr6jj
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793068809-11573
X-HE-Meta: U2FsdGVkX18ET1LvZHOrsUKpF/2I5ETIPYHt9+C8bW8qUg7DlE2kfiphJaDXMmN+0Bw4hTkIRKZCkFwcnDhxXm+zHMsGSXkh3vq3bqoirRJ4X4aE7jrcYwA005wWMBkh+tytrr+Mj4onts92Ubk/s9AX/kyESWIlSVJq8V6nCHIAxy1cdGFI2R+9eMTtganboIrpJO8rGBGIAA41CbCNxOVGo24eZK+leF1qQzttm2mjnhBkqgO4mdDAsZpm2BTSOWC5LexB+wil6y0FwvIRIINR5qwTgAuOKAx8KXiGGMikAiy4IlUcssPObO9vZ3KMUxYsOTW4GxlG7VJFOQNEWY0H9BufaPjtPfkjMunPmmBt4sR4deIGQPiO0xNnQwRbHP6tE1Whp1fDA21y4hd8tUQoHGTQ1SDpu0hJ/7eiCLdO6GCMw9m0QRW9u9yI4IEE13NTSQNnOG4DS/OjN4B0uFu/E+r5Ikd07/qrfIye6xlUffdvxORV6Nrt8XucRT9EFRdLPx0CLgVRqU43nBgAQjQhQKVPUQPfz5VQcmB+xS3rFbVTCmpfJeS4OrYFrF1N3c6OBOveCAOaUd8yVs+cFNrB7pWPFQ3Z1Mr+jW8xbJ0xw4AYEjVp27k+OfqFSDhRxgbx2aCj39E1GlXyL9yY0QGVpNavqDhOa/biK5PJAZAHjxn/FvA/YImRC9pxmMxS1v0OWW/+bQO7iUuEfLwvazPP5XOIAu+p2AkiaPACvJw/AqtVayur4aifyG4JxFpReaLES09CVOzP/mX+sWo4nhPCzRzXFz2okXn5m7yjPHQwwgFsQKCCp7ISgrcw7nJyqL569Bxv6sTSV7yPs30BQInt9ifAYBN2E8J6lEaldJ1huy793QGBaPaO3UoFeama31wtnQTIklsrWsBnNVNOFfUC3TnGBbtT7uxucI2PqqLfxDvoBJTuTzBJZ9HNBzVp+s6vpSwdhYb5HTWrNUW
 hi6Ryll3
 C4LEiEhxGXXz5C6EApc0iG+W5K41xacfFuAFl7j4thX88rytoSANFmnuSHZnIV6Md9yQeWlJtEPV5Ari105+YA/Y32mm0KPyojgEt9/odhoQNzLjc4kfQ25KR5YoVyrZGSK4rQ2U+lBcHWC+HdjICl60XiMek4ZN+8H3pf3M7RPz2XtkayBKlx8xd2GxUleug8CTZet3L9+40I3dSnxLsXjIh3glu7gwdxp22tARni3yYtvx2etySxNLx7x/xwB9X5DgnLwJuAE7fYroHEeEke78t41steDDrDVldJG0VW1P91UE00n3aVf1UJ2jyFkUmqLqQsNok6GjK7rfWI85Bq6Q68jNDtR0oUIFI387FhSQkWqGwZeSPIANMELLWWRqQs+dmoFA3vBT8wuD4QhdqvkK+bA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 1:53=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Fri, Oct 02, 2026 at 02:12:35PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Oct 01, 2026 at 10:12:16PM +0100, Matthew Wilcox wrote:
> > > So what I didn't realise is that fork() waits for page faults to fini=
sh.
> > > I don't think that's necessary, so we can just stop doing that (white=
space
> > > damaged):
> > > I think this is safe.  I've booted a kernel with this change, and
> >
> > I'm afraid it's not safe :)
> >
> > We already actually did this (by mistake I think?) before. See commit
> > fb49c455323f ("fork: lock VMAs of the parent process when forking") - w=
e shipped
> > that in 6.4.0 -> 6.4.2 and it corrupted memory all over the place.
> >
> > Reports + a consistent reproducer:
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D217624
> > https://lore.kernel.org/all/dbdef34c-3a07-5951-e1ae-e9c6e3cdf51b@kernel=
.org/
> > https://lore.kernel.org/all/b198d649-f4bf-b971-31d0-e8433ec2a34c@applie=
d-asynchrony.com/
>
> I wonder if we still need this.  The commit message says:
>
>     A concurrent page fault on a page newly marked read-only by the page
>     copy might trigger wp_page_copy() and a anon_vma_prepare(vma) on the
>     source vma, defeating the anon_vma_clone() that wasn't done because t=
he
>     parent vma originally didn't have an anon_vma, but we now might end u=
p
>     copying a pte entry for a page that has one.
>
> But we're holding the mmap_lock for write here, and we need to hold the
> mmap_lock for read in order to change a vma->anon_vma (asserted in
> __anon_vma_prepare() with mmap_assert_locked()).
>
> At the time of this commit, lock_vma_under_rcu() contained:
>
>         /* find_mergeable_anon_vma uses adjacent vmas which are not locke=
d */
>         if (!vma->anon_vma && !vma_is_tcp(vma))
>                 goto inval;
>
> so we really did have to wait for read holders to finish the fault.
> But commit a373baed5a9d deferred the check for a NULL anon VMA until we
> actually needed it, so I think commit fb49c455323f's logic was invalidate=
d
> by a373baed5a9d.
>
> Maybe I'm wrong.  This is all a bit out of my normal area.
>
> > Also we have asserts for this lock in copy_page_range() and
> > copy_hugetlb_page_range() which will now fail (and possibly more furthe=
r down
> > the stack?)
>
> Possibly we have to adjust some assertions to check that either we have
> the VMA locked or we have the MM write locked.  That doesn't seem
> unreasonable.
>
> > > My argument for why it's safe is that a thread which takes a page
> > > fault during fork() might have taken the page fault either before or
> > > after fork().  The faults will definitely happen in the parent proces=
s.
> > > They may or may not have happened in the child process, which can't
> > > possibly care whether or not they've happened.
> >
> > The problem isn't the child it's the parent - copy_page_range() _modifi=
es_ the
> > _parent_'s page tables in-place, on assumption that nothing else can ac=
cess
> > them (for CoW).
>
> I was perhaps unclear.  What I mean is that the child may or may not
> observe them as having happened.
>
> > And actually nowadays things are _even_ worse, you could also have conc=
urrent
> > page faults, MADV_DONTNEED, MADV_FREE, MADV_GUARD_INSTALL/REMOVE, UFFDI=
O_COPY +
> > UFFDIO_MOVE (yikes) all of which might introduce new issues + would hav=
e to be
> > audited too.
>
> Yup.
>
> > So - it turns out a lot of stuff implicitly assumes VMA write lock now:
> >
> > 1. CoW - deferred TLB flush race
> >
> > (The issue above)
> >
> > https://lore.kernel.org/all/20230705171213.2843068-2-surenb@google.com/
> >
> > This happens because __copy_present_ptes() does wrprotect_ptes() on the=
 parent
> > without a TLB flush (that's deferred until the end of the fork).
> >
> > But unfortunately without a VMA write lock something can then replace t=
he page
> > table entry in the meantime and you can end up with data loss as a resu=
lt.
>
> Is it that fb49c455323f commit message is insufficient and we need to
> prevent simultaneous fork/page fault for other reasons, then?

Yes, I think so. It refers to one of the reasons VMA lock is needed
during fork, but as Lorenzo points out, there are a number of other
reasons that require fork to protect VMAs. Note that some of those
reasons, like MADV_GUARD_INSTALL and UFFDIO_MOVE did not exist at the
time fb49c455323f was written.

Below is the list that AI pointed out, and I think Lorenzo covered
most if not all of them:

Without vma_start_write_killable(mpnt):
      1. In-flight VMA readers that locked mpnt before
mmap_write_lock_killable(oldmm) continue running concurrently with
dup_mmap().
      2. New VMA readers (page faults via lock_vma_under_rcu(),
madvise under MADVISE_VMA_READ_LOCK, userfaultfd via uffd_lock_vma() /
uffd_move_lock(), vma_start_read_unlocked(), etc.) continue to succeed
on mpnt while dup_mmap() duplicates its VMA metadata and page tables.

  (Note: When this lock was originally added in fb49c455323f, one
prominent trigger was a concurrent fault calling anon_vma_prepare() on
a VMA with mpnt->anon_vma =3D=3D NULL while anon_vma_fork() /
vma_needs_copy() ran. Although __vmf_anon_prepare() now requires
mmap_read_trylock()
  when !vma->anon_vma, removing vma_start_write_killable(mpnt) today
still breaks several critical invariants.)
  =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
  ### What would happen if we removed it

  1. **Destruction of live 2MB THP mappings ("bad pmd" -> pmd_clear())
in copy_pmd_range()**
  As noted in the comment in copy_pte_range(), copy_pmd_range()
assumes no concurrent THP transitions on src_pmd:
    if (pmd_is_huge(*src_pmd)) { ... }
    if (pmd_none_or_clear_bad(src_pmd))
        continue;
  On an anonymous VMA that already has mpnt->anon_vma !=3D NULL, a
concurrent per-VMA-locked THP fault (do_huge_pmd_anonymous_page()) or
UFFDIO_MOVE can install a transparent huge PMD into *src_pmd right
after pmd_is_huge(*src_pmd) observed pmd_none.
pmd_none_or_clear_bad(src_pmd)
  then sees pmd_bad(*src_pmd) =3D=3D true (a THP leaf PMD satisfies
pmd_bad()), prints "bad pmd ...", and calls pmd_clear_bad(src_pmd) =E2=80=
=94
wiping out the parent's live 2MB PMD without PTL, TLB flush, or
rmap/refcount/deposited-pgtable/RSS cleanup (corrupting parent memory
and
  triggering Bad rss-counter / nr_ptes bugs on exit).
      =E2=80=A2 The same race exists for huge PUDs in copy_pud_range()
(pud_none_or_clear_bad(src_pud)).
      =E2=80=A2 Similarly, copy_huge_pmd() reads special huge PMDs
(VM_PFNMAP/VM_MIXEDMAP) locklessly and skips rechecking *src_pmd under
src_ptl assuming it cannot change, so a concurrent MADV_DONTNEED under
MADVISE_VMA_READ_LOCK could leave the child mapping a stale/zapped PFN
PMD.
  2. **Silent CoW data corruption / lost parent writes due to deferred
flush_tlb_mm(oldmm)**
  __copy_present_ptes(), copy_huge_pmd(), and
copy_hugetlb_page_range() write-protect parent PTEs/PMDs without
flushing TLBs; dup_mmap() defers the flush to flush_tlb_mm(oldmm)
after all VMAs are copied. Normally, because each copied VMA remains
VMA-write-locked until
  mmap_write_unlock(oldmm), no parent thread can handle a CoW write
fault before flush_tlb_mm(oldmm) finishes.
  Without the VMA write lock, while CPU 0 is still in dup_mmap()
copying later VMAs:
      =E2=80=A2 CPU 1 (parent thread A) still holds a stale writable TLB en=
try
to old_folio (now CoW-shared with the child).
      =E2=80=A2 CPU 2 (parent thread B, no cached TLB entry) writes to the
same page, faults on the R/O PTE under per-VMA read lock, enters
wp_page_copy(), and copies old_folio into new_folio
(__wp_page_copy_user()) before taking PTL and calling
ptep_clear_flush().
      =E2=80=A2 Any store by CPU 1 through its stale writable TLB entry aft=
er
__wp_page_copy_user() and before ptep_clear_flush() lands directly in
old_folio while pte_same() still succeeds =E2=80=94 losing thread A's write=
 in
the parent (new_folio) and leaking it into the child (old_folio).
  3. Broken guard-page (MADV_GUARD_INSTALL) state and KCSAN race on vm_flag=
s
  madvise(MADV_GUARD_INSTALL) runs under MADVISE_VMA_READ_LOCK and
atomically sets VMA_MAYBE_GUARD_BIT on mpnt via vma_set_atomic_flag()
before installing PTE_MARKER_GUARD entries:
      =E2=80=A2 vm_area_dup(mpnt) asserts
ASSERT_EXCLUSIVE_WRITER(orig->vm_flags), which would trip under KCSAN.
      =E2=80=A2 If vm_area_dup(mpnt) copies mpnt->vm_flags just before
MADV_GUARD_INSTALL sets VMA_MAYBE_GUARD_BIT and installs
PTE_MARKER_GUARD PTEs:
          =E2=80=A2 On a file-backed VMA without anon_vma, tmp misses
VM_MAYBE_GUARD (part of VM_COPY_ON_FORK), so vma_needs_copy() returns
false and drops the guard regions in the child.
          =E2=80=A2 On a VMA with anon_vma !=3D NULL, copy_page_range() cop=
ies
the PTE_MARKER_GUARD entries into tmp, leaving the child VMA with
guard PTE markers without VM_MAYBE_GUARD set (breaking collapse checks
such as file_backed_vma_is_retractable() and future merges/forks).

  4. Inconsistent address-space snapshots against UFFDIO_MOVE and
tcp_zerocopy_receive()
      =E2=80=A2 When UFFD_FEATURE_EVENT_FORK is not enabled, dup_userfaultf=
d()
never increments octx->mmap_changing. Because move_pages()
(UFFDIO_MOVE) only takes per-VMA read locks (uffd_move_lock()), it
could move an exclusive folio from a not-yet-copied src address/VMA
into an
      already-copied dst address/VMA (losing the page at both
addresses in the child), or move a zero page from an already-copied
src to a not-yet-copied dst (duplicating it at both). Even with
UFFD_FEATURE_EVENT_FORK, octx->mmap_changing is only incremented once
dup_mmap()
      reaches the first VMA using octx, so earlier non-uffd VMAs rely
on VMA write-locking to prevent cross-VMA moves.
      =E2=80=A2 tcp_mmap() sets VM_MIXEDMAP (in VM_COPY_ON_FORK, without
VM_DONTCOPY), so copy_page_range() would race with
tcp_zerocopy_receive() zapping and inserting pages under
vma_start_read_unlocked().
  5. Immediate debug assertions (CONFIG_DEBUG_VM)
  Both copy_page_range() and copy_hugetlb_page_range() call
vma_assert_write_locked(src_vma) on every CoW VMA, which immediately
fires VM_WARN_ON_ONCE_VMA(!__is_vma_write_locked(vma), vma) because
oldmm->mm_lock_seq was bumped by mmap_write_lock_killable(oldmm) while
mpnt-
  =EF=BF=BA>vm_lock_seq was never updated.

>
> > Same issue exists with hugetlb wp too. And god only knows with uffd wp =
:)
> >
> > 2. THP - can destroy parent THP mappings
> >
> > copy_pmd_range() does:
> >
> >       if (pmd_is_huge(*src_pmd)) { copy_huge_pmd(); ... }
> >       if (pmd_none_or_clear_bad(src_pmd))
> >               continue;
> >
> > Without the write lock, a concurrent fault can install a huge PMD via
> > do_huge_pmd_anonymous_page() or filemap_map_pmd()/do_set_pmd().
> >
> > The issue is that pmd_bad() fires for leaf PMD (ugh) on at least x86 an=
d arm64,
> > meaning that'll clear the page table entry.
> >
> > I think Hugh left a comment alluding to this before:
> >
> >        * copy_pmd_range()'s prior pmd_none_or_clear_bad(src_pmd), and t=
he
> >        * error handling here, assume that exclusive mmap_lock on dst an=
d src
> >        * protects anon from unexpected THP transitions; ...
> >
> > It's like the mess around pmd_trans_unstable() :(
>
> ... could we fix this by taking the ptlock during the copy operation?
>
> > 3. copy_pte_range() skips the required pmd_same() recheck assuming writ=
e lock
> >
> > It uses pte_offset_map_rw_nolock() with a dummy pmdval and:
> >
> >        * We already hold the exclusive mmap_lock, the copy_pte_range() =
and
> >        * retract_page_tables() are using vma->anon_vma to be exclusive,=
 so
> >        * the PTE page is stable, and there is no need to get pmdval and=
 do
> >        * pmd_same() check.
> >
> > (Probably needs updating for VMA write lock...)
> >
> > 4. The asserts
> >
> > Mentioned above!
> >
> > I suspect there's more as well.
> >
> > Some of it could be changed, but it'd all be at the cost of behaving ve=
ry
> > strangely (no VMA lock but mmap write lock) while manipulating things.
> >
> > And I am not really happy with changing page table entries in the paren=
t VMA
> > (for CoW) without a VMA write lock held.
> >
> > I also wonder whether it would achieve all that much really - the issue=
 is with
> > holding the VMA lock across I/O, anything else that tries to grab a wri=
te lock
> > is going to end up being the new thing that's blocked (mprotect, munmap=
, mremap,
> > mlock etc.)
> >
> > I think doing something like this would need a very significant redesig=
n and I'm
> > not convinced it's one that really achieves what we want given all the =
other
> > cases that'd get blocked by the VMA lock being held still.
> >
> > --
> > Cheers, Lorenzo

