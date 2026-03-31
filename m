Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E2E1109B491
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1CC6B0096; Tue, 31 Mar 2026 11:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889176B0098; Tue, 31 Mar 2026 11:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79F2F6B0099; Tue, 31 Mar 2026 11:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6600A6B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:34:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 334661B74B3
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:34:52 +0000 (UTC)
X-FDA: 84606756024.15.2B742E7
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id 18F8580011
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:34:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="s/gjA+SR";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774971290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kbC6DRNJUxFn/ggqNRgjVNMgVXnUw4VaYyyf9fTTGQ=;
	b=34AdncKQ68F9Ud+rMfcvKfHg8VhNrk+9TLVnFBHPwYR7Tq05PUqTKvjkNTe2u2HmNfIReq
	SCeDB2veodU5EFNd7Rry0+faRR5lnYMH+DVWcWz2rQwQck8E4JbuuuEnOqw2vc0UprqulU
	v0cxfAyWIAY7m9vhU1/p7x/Ik/izoQs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774971290; a=rsa-sha256;
	cv=pass;
	b=BKhzVI2XtQpGArNOII/0B+1locTE2th4my+Fj9jiNjMO68MTayqeNUTZ2ZzdwtUhNIF8HP
	aiuys0hDovUW5Zkt1XT+ULHpiKfMoQd7E98IPkmhbLOqDjgKrzyfHywMuluUJ4T0RVdgvD
	SvWAY5neMao5xTxX8QVIx3cbIor+YBA=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="s/gjA+SR";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-66bb7118c96so14058a12.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:34:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774971288; cv=none;
        d=google.com; s=arc-20240605;
        b=kyjqJgBGh8bORkzLslKNFqyWdDZPAOMCOG5Iq3Wu6fGvRl3eQ3lagoDxQzpeicSRNs
         Xx1hM5Oc256VI8Ij4j0+JluUrMXUx6Rm137+mfYoaorbTiKnmAApAymyQxj4dNWvVkju
         z3Zku9ZrxLQJinItN7SaF+mzkDtsGjN2XFPkf/T+7zlzH50RhAAQ5KDya9icLK+iQmQK
         1LbU0gC6+nv46M2E6TZEzDuh8eS7/h91ByoPksnFJX3i3X7fM2meAOfuNAEVDKhfYFGH
         0jigdx2MW60Z3rJNedhtp8h0/hOC0zuk+jXyE9gMN/eW9KBnERxV/ZVUgiDfPQDDp+oO
         BfAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2kbC6DRNJUxFn/ggqNRgjVNMgVXnUw4VaYyyf9fTTGQ=;
        fh=obh49sra5+dQvXlKLqvC1bb25ENYKCOVAdTdwGIyk/8=;
        b=kAhuqM3XyAGGA2HcBhzqJ/UTKPCa57IbJRajM3RI+hVRtL7iRYvxstt9bv4HimjXub
         kdfS3douyxZYpjMMrax5xsn5Kuqb765ZGQDNSgS5CczpvjW6u5gd7WqPxokPsuabN+Wx
         SC6AAh/eEPbyLlrOzoeoJ2Pg9V6Lt+DZfy079I0Lzq37HeGnx/e8z7xABmxc2BUFpF8Q
         gsbqPt+TNDrZpSfdIjV4rLbEzyWxEEN670lXNJHsT/+5W2haRnz1z5JiPzxMkeEXZ4jt
         AdpDIsbo2Ywve0Lnki1SCWuen/tNRUWk8DXQ78RaeP0aQ9q+7MTewh29oDbNlunUJlUe
         xHtg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774971288; x=1775576088; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kbC6DRNJUxFn/ggqNRgjVNMgVXnUw4VaYyyf9fTTGQ=;
        b=s/gjA+SRTffOTxkxGdfTBiK8rmCs5vIibz0EFbCsJDRwgCaVWwZtg6xtpJ9SxvYv7M
         l5revVJVS4QsY8EI39AcFTvnAsMDhhBRn8KWE7yaUDI9ujYFlLCHdT1HKwDngDsLSKE7
         /VlkoRGtlwwMcp4hOwbrbShr/3O1Yenlp1HKcEByhIDWO6jXgKlg2LPyVNpm/avhTsy9
         aPZJE51nY5w/va12ZN6teVrbuCdCN7ZsTPESYXOKA5217gvkf4+W3HWDZFs8ZVfKoc63
         4oIcEidyPTIP9WyEwdXHAPdZidLjIQcxex1tBkEQ6M45ucB8xYmkuNFyxJy431/AQyXP
         8OkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774971288; x=1775576088;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2kbC6DRNJUxFn/ggqNRgjVNMgVXnUw4VaYyyf9fTTGQ=;
        b=OGfL6SF20N8thIRcqweB2zmf1klRy1O/xESiVOF8DZhHfRFEoY5tv1FBea1vs7Gd3b
         WI0JIbMbDLs+ct5KpEPDcddYHfa1YOENTIywsFTGlsGegW5Ccmn9TTnCS+xZXyDW3IWB
         ICQRvFz6gyImimv6R/6XkVR34YK7JgOCAYS6yu22mBVZuscinLPxNsBPc31cqgrIsq6U
         MsnHFD1pQVpgkmdjNXVlOoQUDxQevaD+8WFMMnB+iGkIfhPMbcZHFClj2ldGGP/QuNLa
         MZvaQW64TdquzM37S1NHQUzEsFb5EjZpFqURIkp+hl7d6zWyqIjGS0auitAjayuWir3E
         swyw==
X-Forwarded-Encrypted: i=1; AJvYcCVeUJyB5dDK3UEYi8oz/f4XHLcSCRRsIyzLXUOKCnJXm4QEF09uuf+/2up5dfWuGBKxPEFPDtre5A==@kvack.org
X-Gm-Message-State: AOJu0YxauL4ZhvY15dZMBdaI/EjkTsjMNgZKF9Cj4zrvC4JJxD/sQ43S
	SBOvaf7dJ37ihOQhCHHoji2i/T4unyPKCXYDfRlYpcWLZqLZdfWJPMW0wGBcfyhE0B3OYt0xzSA
	okf40H85/s5s5Lqu01TnOphGVJUdIknGUaPstAZGe
X-Gm-Gg: ATEYQzwDecRdjawei74Kh6hmnhlmTOos8HnkBRefjjLzX0bsFywyFC8NEUPiB317LQG
	xLGkVJe6cqHi2u8jFP9L9cMX1i66ZHlfWD73CWPuyeOgCO/7s6T3/A/c4TbWae5YYzD5r4Si3YC
	f7xCxzGWwF9goE0HTHhl9zs+b1znYQTWxHdErY4I5T5z5Zy1vstmS5nAnKBDgh8COCj1rHA7+ni
	s+LsyUKVvInxTvxoyddEQC8MeURIVtNYSO/b1m9BLcBpazT89wjTq4x38LhaCo75LjPx7ceUcs1
	Oxw2yv7au4whxb1T2DxcMjXakFlLC9/QKgtNzw==
X-Received: by 2002:aa7:d157:0:b0:66b:ea0e:1782 with SMTP id
 4fb4d7f45d1cf-66d95ac6b83mr3294a12.2.1774971287536; Tue, 31 Mar 2026 08:34:47
 -0700 (PDT)
MIME-Version: 1.0
References: <20260327205457.604224-1-surenb@google.com> <20260327161226.17e680fec33117d67dc8b5f9@linux-foundation.org>
 <f128b795-5577-40f9-8dae-936be4253642@lucifer.local> <CAJuCfpHmUop-UzxM9QN7OiAnXUzj461+9ErgtXrtve_bR0_NjA@mail.gmail.com>
In-Reply-To: <CAJuCfpHmUop-UzxM9QN7OiAnXUzj461+9ErgtXrtve_bR0_NjA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 31 Mar 2026 08:34:34 -0700
X-Gm-Features: AQROBzCjbp_TCkkxwhu_axsyxtZ1SbbwXiNA5twqFRnYfWa0PnszaVM289IvRRY
Message-ID: <CAJuCfpF5CqSMU4yz5mgSOTbSLfMsmATGk4vcKWiqrzV3rGkZEw@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] Use killable vma write locking in most places
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 18F8580011
X-Stat-Signature: adb3aker1qa8shddmnp8qxppswmnbfof
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774971289-314570
X-HE-Meta: U2FsdGVkX19hqw7TQM13vs7VgIs+o6j/uL4v5U9EVGw2PE3biK8VyHi/Ehyi0cwGeP6blz7h2utHw+tlrcDPS4pM3BjuFrzUK+7K/F6wNV6Z2jMPaD2RWJYzjLNbczjasXutfTUIs2hJohPq9DBCIn2xAtO5A3JNl5oKYlIKT+XGOfxUAmUSJSNwk2KmX7UJt05JTr+oXOUcaw378/GS4OLaGbHxdjaLJzDMdC1HE7RxeeUb6cLtAL58wSujBEZwDPyu3sQKqWuYhSdp9mbfVy1Z6LIHDjF4w76WegRE8E4QtrWd5pLwF/h1PEloGc6Z76YrTFTXl3dRka8MDdnSMHTVWc0J4ptBSsiBZEsGDSAHVQ6KwMgMAApWK8ueGn0L1cnhpZwqdbdLPewOpdCwroLH/nZhhy3NpzGROvV33r7rOfY0x/xhHjiyIvj8ra44DDYcadrIpV4gPW8WwY9RFz+pj+T3094nOGG9D+DSe4mT+uFrCxOHKCPdB9EYKVlp4Qi2gobngG29tOreYLWobcA3AmLxUGEbcVsGbz7U7GYP2/4aoLLLLSZEoXp8wT80KXwx+6hVnCd9EUqHzTpkFVNqfXobRoKjZsH6jpfQe/23fNj+VHCsnp6vngnMvkim5bGsj2ov663u7Q6fdVTXV/F70m9NHUNFnTCfyhiD3qvSKww+krt+8o2XK/anpGSdstTEPSgduvuFBL4Tj7w72TGBxfIgo/jr0I/k6yquermg1naUnKQ8QV7a+NViiPFkFTk7sTTWdcuwX7KVyQXLLw59WKyGKZy5dKujcFlT4oj18vxU++sO7aWVAKQWJTtb9PL4O5fwmwJr64Yf1UJPnLz4Xfqv4H9DFX2+T/QngMN7jF2brAd0XJabPUAZL/bAlmh0PXZB6Ezt8mKFH/kbt+6gpRBaypmQdPBuqbzI554isTBC6KBmSw0t6ea9OOAoKjcbCR+9EWoSVSuvbtH
 3eyn5ORU
 gZRC10XMYSkH+uIVpCG5Qn+0fZKzHe04OVmyku3B8YosZpdwhPI1gMRvAUUuTiSA6ufY6w0hZvL2+nH3xP518riWHYOUq9XWwaGrFTbaaSjdcNaNvDXqca7iR1dsPAj5CkO9sUqomlzvTrqdzQXXXi8uDZ9J8WCMIKHQ3SjCGMzNuoneHjCYY5EC8YN7K5w5DYGFhMAKeNsdDTaBIGZ+0RfKEPq+j++e814ms3Hottzls+vESPkMBPu9iduOQ/fCH9xZwnM3usisGEHsI1N2zdCbn4+Acb34pU2yUUSYumzVwf1LGjPl17YBsdtXlxE8r68M5MIm2CfkbfvwY8nDu2GawH/vVJsc9Masm1iPsi7sNTEX+/Wa5Ki+igoCAdDa27Pbj1rHnWv42ZmoHFec9kWjHJGbyVws8yC16hOruow4DMJH0ZYwh15n9mkZXsGImwDH9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 8:06=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, Mar 31, 2026 at 2:51=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@ker=
nel.org> wrote:
> >
> > On Fri, Mar 27, 2026 at 04:12:26PM -0700, Andrew Morton wrote:
> > > On Fri, 27 Mar 2026 13:54:51 -0700 Suren Baghdasaryan <surenb@google.=
com> wrote:
> > >
> > > > Now that we have vma_start_write_killable() we can replace most of =
the
> > > > vma_start_write() calls with it, improving reaction time to the kil=
l
> > > > signal.
> > > >
> > > > There are several places which are left untouched by this patchset:
> > > >
> > > > 1. free_pgtables() because function should free page tables even if=
 a
> > > > fatal signal is pending.
> > > >
> > > > 2. userfaultd code, where some paths calling vma_start_write() can
> > > > handle EINTR and some can't without a deeper code refactoring.
> > > >
> > > > 3. mpol_rebind_mm() which is used by cpusset controller for migrati=
ons
> > > > and operates on a remote mm. Incomplete operations here would resul=
t
> > > > in an inconsistent cgroup state.
> > > >
> > > > 4. vm_flags_{set|mod|clear} require refactoring that involves movin=
g
> > > > vma_start_write() out of these functions and replacing it with
> > > > vma_assert_write_locked(), then callers of these functions should
> > > > lock the vma themselves using vma_start_write_killable() whenever
> > > > possible.
> > >
> > > Updated, thanks.
> >
> > Andrew - sorry I think we need to yank this and defer to next cycle,
> > there's too many functional changes here.
> >
> > (There was not really any way for me to predict this would happen ahead=
 of
> > time, unfortunately.)
>
> Ok, no objections from me. I'll post v6 removing the part Lorenzo
> objects to and you can pick it up whenever you deem appropriate.

Just saw Lorenzo's other reply about reworking some vma error handling
first. I'll wait for that rework before posting the new version.

>
> >
> > >
> > > > Changes since v5 [1]:
> > > > - Added Reviewed-by for unchanged patches, per Lorenzo Stoakes
> > > >
> > > > Patch#2:
> > > > - Fixed locked_vm counter if mlock_vma_pages_range() fails in
> > > > mlock_fixup(), per Sashiko
> > > > - Avoid VMA re-locking in madvise_update_vma(), mprotect_fixup() an=
d
> > > > mseal_apply() when vma_modify_XXX creates a new VMA as it will alre=
ady be
> > > > locked. This prevents the possibility of incomplete operation if si=
gnal
> > > > happens after a successful vma_modify_XXX modified the vma tree,
> > > > per Sashiko
> >
> > Prevents the possibility of an incomplete operation? But
> > vma_write_lock_killable() checks to see if you're _already_ write locke=
d
> > and would make the operation a no-op? So how is this even a delta?
> >
> > It's a brave new world, arguing with sashiko via a submitter... :)
>
> Yeah, this is not really a problem but I thought I would change it up
> to make it apparent that the extra vma_write_lock_killable() is not
> even called.
>
> >
> > > > - Removed obsolete comment in madvise_update_vma() and mprotect_fix=
up()
> > > >
> > > > Patch#4:
> > > > - Added clarifying comment for vma_start_write_killable() when lock=
ing a
> > > > detached VMA
> > > > - Override VMA_MERGE_NOMERGE in vma_expand() to prevent callers fro=
m
> > > > falling back to a new VMA allocation, per Sashiko
> > > > - Added a note in the changelog about temporary workaround of using
> > > > ENOMEM to propagate the error in vma_merge_existing_range() and
> > > > vma_expand()
> > > >
> > > > Patch#5:
> > > > - Added fatal_signal_pending() check in do_mbind() to detect
> > > > queue_pages_range() failures due to a pendig fatal signal, per Sash=
iko
> > >
> > > Changes since v5:
> > >
> > >
> > >  mm/madvise.c   |   15 ++++++++++-----
> > >  mm/mempolicy.c |    9 ++++++++-
> > >  mm/mlock.c     |    2 ++
> > >  mm/mprotect.c  |   26 ++++++++++++++++----------
> > >  mm/mseal.c     |   27 +++++++++++++++++++--------
> > >  mm/vma.c       |   20 ++++++++++++++++++--
> > >  6 files changed, 73 insertions(+), 26 deletions(-)
> > >
> > > --- a/mm/madvise.c~b
> > > +++ a/mm/madvise.c
> > > @@ -172,11 +172,16 @@ static int madvise_update_vma(vm_flags_t
> > >       if (IS_ERR(vma))
> > >               return PTR_ERR(vma);
> > >
> > > -     madv_behavior->vma =3D vma;
> > > -
> > > -     /* vm_flags is protected by the mmap_lock held in write mode. *=
/
> > > -     if (vma_start_write_killable(vma))
> > > -             return -EINTR;
> > > +     /*
> > > +      * If a new vma was created during vma_modify_XXX, the resultin=
g
> > > +      * vma is already locked. Skip re-locking new vma in this case.
> > > +      */
> > > +     if (vma =3D=3D madv_behavior->vma) {
> > > +             if (vma_start_write_killable(vma))
> > > +                     return -EINTR;
> > > +     } else {
> > > +             madv_behavior->vma =3D vma;
> > > +     }
> > >
> > >       vma->flags =3D new_vma_flags;
> > >       if (set_new_anon_name)
> > > --- a/mm/mempolicy.c~b
> > > +++ a/mm/mempolicy.c
> > > @@ -1546,7 +1546,14 @@ static long do_mbind(unsigned long start
> > >                       flags | MPOL_MF_INVERT | MPOL_MF_WRLOCK, &pagel=
ist);
> > >
> > >       if (nr_failed < 0) {
> > > -             err =3D nr_failed;
> > > +             /*
> > > +              * queue_pages_range() might override the original erro=
r with -EFAULT.
> > > +              * Confirm that fatal signals are still treated correct=
ly.
> > > +              */
> > > +             if (fatal_signal_pending(current))
> > > +                     err =3D -EINTR;
> > > +             else
> > > +                     err =3D nr_failed;
> > >               nr_failed =3D 0;
> > >       } else {
> > >               vma_iter_init(&vmi, mm, start);
> > > --- a/mm/mlock.c~b
> > > +++ a/mm/mlock.c
> > > @@ -518,6 +518,8 @@ static int mlock_fixup(struct vma_iterat
> > >               vma->flags =3D new_vma_flags;
> > >       } else {
> > >               ret =3D mlock_vma_pages_range(vma, start, end, &new_vma=
_flags);
> > > +             if (ret)
> > > +                     mm->locked_vm -=3D nr_pages;
> > >       }
> > >  out:
> > >       *prev =3D vma;
> > > --- a/mm/mprotect.c~b
> > > +++ a/mm/mprotect.c
> > > @@ -716,6 +716,7 @@ mprotect_fixup(struct vma_iterator *vmi,
> > >       const vma_flags_t old_vma_flags =3D READ_ONCE(vma->flags);
> > >       vma_flags_t new_vma_flags =3D legacy_to_vma_flags(newflags);
> > >       long nrpages =3D (end - start) >> PAGE_SHIFT;
> > > +     struct vm_area_struct *new_vma;
> > >       unsigned int mm_cp_flags =3D 0;
> > >       unsigned long charged =3D 0;
> > >       int error;
> > > @@ -772,21 +773,26 @@ mprotect_fixup(struct vma_iterator *vmi,
> > >               vma_flags_clear(&new_vma_flags, VMA_ACCOUNT_BIT);
> > >       }
> > >
> > > -     vma =3D vma_modify_flags(vmi, *pprev, vma, start, end, &new_vma=
_flags);
> > > -     if (IS_ERR(vma)) {
> > > -             error =3D PTR_ERR(vma);
> > > +     new_vma =3D vma_modify_flags(vmi, *pprev, vma, start, end,
> > > +                                &new_vma_flags);
> > > +     if (IS_ERR(new_vma)) {
> > > +             error =3D PTR_ERR(new_vma);
> > >               goto fail;
> > >       }
> > >
> > > -     *pprev =3D vma;
> > > -
> > >       /*
> > > -      * vm_flags and vm_page_prot are protected by the mmap_lock
> > > -      * held in write mode.
> > > +      * If a new vma was created during vma_modify_flags, the result=
ing
> > > +      * vma is already locked. Skip re-locking new vma in this case.
> > >        */
> > > -     error =3D vma_start_write_killable(vma);
> > > -     if (error)
> > > -             goto fail;
> > > +     if (new_vma =3D=3D vma) {
> > > +             error =3D vma_start_write_killable(vma);
> > > +             if (error)
> > > +                     goto fail;
> > > +     } else {
> > > +             vma =3D new_vma;
> > > +     }
> > > +
> > > +     *pprev =3D vma;
> > >
> > >       vma_flags_reset_once(vma, &new_vma_flags);
> > >       if (vma_wants_manual_pte_write_upgrade(vma))
> > > --- a/mm/mseal.c~b
> > > +++ a/mm/mseal.c
> > > @@ -70,17 +70,28 @@ static int mseal_apply(struct mm_struct
> > >
> > >               if (!vma_test(vma, VMA_SEALED_BIT)) {
> > >                       vma_flags_t vma_flags =3D vma->flags;
> > > -                     int err;
> > > +                     struct vm_area_struct *new_vma;
> > >
> > >                       vma_flags_set(&vma_flags, VMA_SEALED_BIT);
> > >
> > > -                     vma =3D vma_modify_flags(&vmi, prev, vma, curr_=
start,
> > > -                                            curr_end, &vma_flags);
> > > -                     if (IS_ERR(vma))
> > > -                             return PTR_ERR(vma);
> > > -                     err =3D vma_start_write_killable(vma);
> > > -                     if (err)
> > > -                             return err;
> > > +                     new_vma =3D vma_modify_flags(&vmi, prev, vma, c=
urr_start,
> > > +                                                curr_end, &vma_flags=
);
> > > +                     if (IS_ERR(new_vma))
> > > +                             return PTR_ERR(new_vma);
> > > +
> > > +                     /*
> > > +                      * If a new vma was created during vma_modify_f=
lags,
> > > +                      * the resulting vma is already locked.
> > > +                      * Skip re-locking new vma in this case.
> > > +                      */
> > > +                     if (new_vma =3D=3D vma) {
> > > +                             int err =3D vma_start_write_killable(vm=
a);
> > > +                             if (err)
> > > +                                     return err;
> > > +                     } else {
> > > +                             vma =3D new_vma;
> > > +                     }
> > > +
> > >                       vma_set_flags(vma, VMA_SEALED_BIT);
> > >               }
> > >
> > > --- a/mm/vma.c~b
> > > +++ a/mm/vma.c
> > > @@ -531,6 +531,10 @@ __split_vma(struct vma_iterator *vmi, st
> > >       err =3D vma_start_write_killable(vma);
> > >       if (err)
> > >               goto out_free_vma;
> > > +     /*
> > > +      * Locking a new detached VMA will always succeed but it's just=
 a
> > > +      * detail of the current implementation, so handle it all the s=
ame.
> > > +      */
> > >       err =3D vma_start_write_killable(new);
> > >       if (err)
> > >               goto out_free_vma;
> > > @@ -1197,8 +1201,14 @@ int vma_expand(struct vma_merge_struct *
> > >
> > >       mmap_assert_write_locked(vmg->mm);
> > >       err =3D vma_start_write_killable(target);
> > > -     if (err)
> > > +     if (err) {
> > > +             /*
> > > +              * Override VMA_MERGE_NOMERGE to prevent callers from
> > > +              * falling back to a new VMA allocation.
> > > +              */
> > > +             vmg->state =3D VMA_MERGE_ERROR_NOMEM;
> > >               return err;
> > > +     }
> > >
> > >       target_sticky =3D vma_flags_and_mask(&target->flags, VMA_STICKY=
_FLAGS);
> > >
> > > @@ -1231,8 +1241,14 @@ int vma_expand(struct vma_merge_struct *
> > >                * is pending.
> > >                */
> > >               err =3D vma_start_write_killable(next);
> > > -             if (err)
> > > +             if (err) {
> > > +                     /*
> > > +                      * Override VMA_MERGE_NOMERGE to prevent caller=
s from
> > > +                      * falling back to a new VMA allocation.
> > > +                      */
> > > +                     vmg->state =3D VMA_MERGE_ERROR_NOMEM;
> > >                       return err;
> > > +             }
> > >               err =3D dup_anon_vma(target, next, &anon_dup);
> > >               if (err)
> > >                       return err;
> > > _
> > >

