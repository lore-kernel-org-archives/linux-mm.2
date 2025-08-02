Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F21EC87FCA
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 00:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3D66B007B; Fri,  1 Aug 2025 20:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5196B0089; Fri,  1 Aug 2025 20:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B939A6B008A; Fri,  1 Aug 2025 20:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A97546B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 20:32:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51AFD1142CC
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 00:32:35 +0000 (UTC)
X-FDA: 83729941470.05.15F636F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id EAD41C0008
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 00:32:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AZxQIa8H;
	spf=pass (imf28.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754094753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2kHJlrQseChL3F3Lej9Uklzvin/23o+r6QXAoYU51E=;
	b=uxX7waKqqEGM7yH0IadtosKk5d4WupqrIn44jYWSHYOs2+gxjjdtow2gi53pTs4jN/95y+
	JLkf6zANFd2BrqanY7POg0HYXi+rVqiOS6AZeEmt64atzhQxjWywtF/zw83nmPHnSI/Tcw
	uGk7BlkgCuRq/aa8z1uvqPU9Kip+ri0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AZxQIa8H;
	spf=pass (imf28.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754094753; a=rsa-sha256;
	cv=none;
	b=PxVzQspgtxiDTvJ63SptUC9Ya9vTLHKMAziXM6wD20GKdIMFuj9ETyeqMvrsl+Ve4dzox+
	A1z9d/acO06NdzVbzX6Z/D7Eb2MYfnJnM8FzGdSNqIXapZiXPNraciQ8TCAB0IpNtlntMG
	CCdVERtWqMgQmR2oxswJx4R+7TbsZv0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754094752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x2kHJlrQseChL3F3Lej9Uklzvin/23o+r6QXAoYU51E=;
	b=AZxQIa8HA6LOtvsgblsbO3Xoc37XAqd52bGUAQJJbOaSZhNm1Bt8uGNkwFRkbJsbdeoIQL
	Om+fsLHbbe1cx6COrzxiu3zR6dleCvz+Un8LIhWxbPjSAzZGwlWqOIimOIRFb4eAnaCiAD
	NS8YJpxOh61ykrKMLkBxEjXnhGu3BDU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-jdBlho-APp6Y9uAgMp5myQ-1; Fri, 01 Aug 2025 20:32:31 -0400
X-MC-Unique: jdBlho-APp6Y9uAgMp5myQ-1
X-Mimecast-MFC-AGG-ID: jdBlho-APp6Y9uAgMp5myQ_1754094750
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7e348600cadso459301385a.3
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 17:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754094750; x=1754699550;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x2kHJlrQseChL3F3Lej9Uklzvin/23o+r6QXAoYU51E=;
        b=Ep2IiHNQnUw35ajlY5s84zEdV9Wq2ujvjxO2vtcfpoJO0KZpaCTIMG8Lkx65801JIm
         3rNaUwMDrLc8ziAuk7uS9Hzi5nfFFAnpI370JlzjS11CNxyShavBu+ty2S8e+2aBhUth
         Rin3LvDvvJcHnYFZIaCFyKeafCneh8GE7AjCO9aFjTt2aAAKPtIeNuCRbULhPCVaWkof
         3dy7hczf6pjMbHq7/ad83Id2Iv1NICAYRtNgkJNHjwEzI+8C3Hdsi1pGnR7aK1QWmLj1
         Xtrc2SHEXwKWEh1JSB3VBBMekKrCVhbLOk6BQPrs7kUFfBou57uFhFp3KpMpjm7eUH9d
         +EZw==
X-Forwarded-Encrypted: i=1; AJvYcCVtKQBS3xpyy5RRazmskrc1VLfRAUe4UKi4q79AwNNOLQJcRq4JBfQLY2fpO5T+UrsnlQGBPnGzxw==@kvack.org
X-Gm-Message-State: AOJu0YygnL96gsbHLVHYui9Y1ur1cUDM3J5N2LC/IONk0I3xZ38RfB1z
	RU71/oqQHXEIlzX3lYELsKjUWIr0udEkwVBoTqqfIUvXdeebfc+UvlR+33zwKNpsUiNFjrhionu
	iqF3l4DbNM1Hy6wO14eGa5yAofK6qH2BbG6fkVVxW4B1y2DSMRrlh
X-Gm-Gg: ASbGncuSHTSDAtNppATbj13+orRNXMA7lBBRL0ohxQliiVKdDh5qOOmh8KIqoOeNA9z
	YRgas//ckqnl7ZWeJIVA74/D5AhthOWO/BCHfYMTvNz2Hnlljvggl9k8ggw6f5mLc/8XRMdB6ce
	iGDABClIlKpFjXdxcfN4hBAGSTH2owCMfD/0bGvt3hXMiL/ZIPRJY+RHHpSB8t+hmx37/DMRpDC
	7PAc8PhfSpQh2UIig4wv/8dfGTFh5M0lHiPTA7rjiW/vz9Hfl4gnetdYZCj7nOAYWSmF+NCZZRU
	aOGzeU0blI0593ZQDc5qQpq5zvF6+XBU
X-Received: by 2002:a05:622a:424e:b0:4af:23a:4d8f with SMTP id d75a77b69052e-4af1094bb33mr29893721cf.1.1754094750235;
        Fri, 01 Aug 2025 17:32:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcyIfCLQARG8ajrAkxw6gecilHP9OwpIaR2rAKxNNqso1ts3GOWxdhyD6yzWs4HO8O8IpDiQ==
X-Received: by 2002:a05:622a:424e:b0:4af:23a:4d8f with SMTP id d75a77b69052e-4af1094bb33mr29893491cf.1.1754094749728;
        Fri, 01 Aug 2025 17:32:29 -0700 (PDT)
Received: from x1.local ([174.89.135.171])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4aeeec005c2sm25861691cf.16.2025.08.01.17.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 17:32:28 -0700 (PDT)
Date: Fri, 1 Aug 2025 20:32:16 -0400
From: Peter Xu <peterx@redhat.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
	aarcange@redhat.com, lokeshgidra@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
Message-ID: <aI1ckD3KhNvoMtlv@x1.local>
References: <20250731154442.319568-1-surenb@google.com>
 <d2b6be85-44d5-4a87-bfe5-4a9e80f95bb8@redhat.com>
 <aIzMGlrR1SL5Y_Gp@x1.local>
 <CAJuCfpEqOUj8VPybstQjoJvCzyZtG6Q5Vr4WT0Lx_r3LFVS7og@mail.gmail.com>
 <aIzp6WqdzhomPhhf@x1.local>
 <CAJuCfpGWLnu+r2wvY2Egy2ESPD=tAVvfVvAKXUv1b+Z0hweeJg@mail.gmail.com>
 <aIz1xrzBc2Spa2OH@x1.local>
 <CAJuCfpFJGaDaFyNLa3JsVh19NWLGNGo1ebC_ijGTgPGNyfUFig@mail.gmail.com>
 <aI0Ffc9WXeU2X71O@x1.local>
 <CAJuCfpFSY3fDH36dabS=nGzasZJ6FtQ_jv79eFWVZrEWRMMTiQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJuCfpFSY3fDH36dabS=nGzasZJ6FtQ_jv79eFWVZrEWRMMTiQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Yhl6KhJnbVrlgF7imWY-1bscqZVEvDXdadziy2EH7ws_1754094750
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EAD41C0008
X-Rspamd-Server: rspam06
X-Stat-Signature: was3rep86rd4ewaw8pbnrttu9yhrrn45
X-HE-Tag: 1754094752-300961
X-HE-Meta: U2FsdGVkX1+tf360iVX4O//PgT/reO3K7JPcjr3g+iVo5FApmJ+6iJVcTaFNlZDwur46IVfpXOLnp80HJBkse/ofSwhf2Uu5H2wNRgbfQo769m2PxlU2UfXd2T7nULwFzUkVRuFT9A2y8ysTg0fH0DkL0DErfOi36p/zwjE7KDIY54N905OXemR09xt3PWZ7tpqnT84uZhp78sotl7imz/yrDesEoQroIP2sxB+XIvP0ei7P4+M0AJyjb3qjuvzI8jQVsOfHn8/lCXIOTBTEZ9y3RJDezXFlt7UutItoAlsI7hg/nm/p4Qi+40ijUHRKcLIdUpCviWIkNmvr2M6/8a7b63f+afWZfXpPl+KBVDQuLSyht7YGnzGOTRR+6z0htAdPnEnxj4JpGH3/i7speZ3G4ogiCPT1UxZI30QQC7/RRxomWolsgMRMQzu8dvIXOTbXZ1mjYQUF7s2oOcRn8AmAFsS1lZeP9W3GgKtigxpRBXH2WR7LHJG8QIe3lfssKmqyrApZV11sXf2jqdN6Rv6DW5OgIEinBRRsMGA1d52lZaAcAVs241rj7x9QILUhCpcTf3Svoapd8VKqzKzL1eRj2UoMvTzMD48ijwhZ0dLh52evyRiXrkrvKFJ2zefZfOif5MyyPU2HrZdiOhsszHnybyYPp6L+zm6AGynIVkK/lu8DxmLkrTMvyqK3k2653LC7cZ/xLJAZiZ9Ix8Igj12fyoy/r+2auDMA1s98IATr311Iexh/E3iVpsXhhUBrCMRSZx+sxsnLCXEPG2XFyLhv8dWjB6Vjj8G+LBDs2NppHS6x9OB/FNe1q42mmD1mpMbxvMm6t5ZJltNPd3dA8CFotb2MiFqhBgCaoUh/3H1IzX+To14MYxGiySfNI/YWPfZJy0mvKvLyztXl3x1sTWeX2Eic/re4Xe+E+3KpEvGaAY86B6xmTDFKme+yE1tSmpP03AIIJkTwjBTl3zc
 lT/szV6q
 QtZSJba35TteTpv3uod6aeHcZIiK0KmwbSKdzTEC1R4mG1rOkSJoY57S1PdxGFT9wiSkf3tRw/vulU4LyftFN+cF5LuwKKDy7C68oj7yZTqY3uwk1m0+Nyj9Q1noEue7GtbeLvnYDhWIAcvlaNWFFLJ/mpQS8EgjTbFFowJ6zrgEyyGJQbDohpfd6dkhZUpUmsVdTTFtCK0JF5W8HVNBR1HeunbmY+OeyguT+tFLh3ddRU9WsdtEo9OGeAzGU3n4J1boFxI1/1r7xXlw8b1tHlEutjZCtNKWdZ+2qK93wJfsetlZAO/ZCArdLW3PF20m+XSMoM/J5SsWOWv+eaAYlveCnmtRjRxUk4IZA+ALLlpF3S5wsVkPX49JPftULjiRR1uZz9vHa9JtOjZnxuGVelax4n5pWZZm2lEAcVCgBRrzIwdMn7XKVVixReYjgfjEyxWPz/sNzAdLLXEvht1A/+kEeg9LNZsZunVSqG6FVReFOt36FZPJqNR/drtCUMrD8HsB+0pvVmEMA41FpEfzkyERSK1B+VfDDErgfGOlXiwmfbp6W8Wp+S2c2a4B3ojAEpVzC4Ax91iT+YtqMQXdLnn7i8oF88meofhrsesKsBv6wUAACZU6XscMQ+fyKMZO04tuUN1BDdpQvVcdvvdpb24malQ3GQZOrfM69j1IPvwjiP6P+rqlrw0bIdlXHjQ9jCvYblbH84Dzqs0el8XlZr8j70g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 07:30:02PM +0000, Suren Baghdasaryan wrote:
> On Fri, Aug 1, 2025 at 6:21 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Fri, Aug 01, 2025 at 05:45:10PM +0000, Suren Baghdasaryan wrote:
> > > On Fri, Aug 1, 2025 at 5:13 PM Peter Xu <peterx@redhat.com> wrote:
> > > >
> > > > On Fri, Aug 01, 2025 at 09:41:31AM -0700, Suren Baghdasaryan wrote:
> > > > > On Fri, Aug 1, 2025 at 9:23 AM Peter Xu <peterx@redhat.com> wrote:
> > > > > >
> > > > > > On Fri, Aug 01, 2025 at 08:28:38AM -0700, Suren Baghdasaryan wrote:
> > > > > > > On Fri, Aug 1, 2025 at 7:16 AM Peter Xu <peterx@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Fri, Aug 01, 2025 at 09:21:30AM +0200, David Hildenbrand wrote:
> > > > > > > > > On 31.07.25 17:44, Suren Baghdasaryan wrote:
> > > > > > > > >
> > > > > > > > > Hi!
> > > > > > > > >
> > > > > > > > > Did you mean in you patch description:
> > > > > > > > >
> > > > > > > > > "userfaultfd: fix a crash in UFFDIO_MOVE with some non-present PMDs"
> > > > > > > > >
> > > > > > > > > Talking about THP holes is very very confusing.
> > > > > > > > >
> > > > > > > > > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
> > > > > > > > > > encounters a non-present THP, it fails to properly recognize an unmapped
> > > > > > > > >
> > > > > > > > > You mean a "non-present PMD that is not a migration entry".
> > > > > > > > >
> > > > > > > > > > hole and tries to access a non-existent folio, resulting in
> > > > > > > > > > a crash. Add a check to skip non-present THPs.
> > > > > > > > >
> > > > > > > > > That makes sense. The code we have after this patch is rather complicated
> > > > > > > > > and hard to read.
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > > > > > > > > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> > > > > > > > > > Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
> > > > > > > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > > > > ---
> > > > > > > > > > Changes since v1 [1]
> > > > > > > > > > - Fixed step size calculation, per Lokesh Gidra
> > > > > > > > > > - Added missing check for UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES, per Lokesh Gidra
> > > > > > > > > >
> > > > > > > > > > [1] https://lore.kernel.org/all/20250730170733.3829267-1-surenb@google.com/
> > > > > > > > > >
> > > > > > > > > >   mm/userfaultfd.c | 45 +++++++++++++++++++++++++++++----------------
> > > > > > > > > >   1 file changed, 29 insertions(+), 16 deletions(-)
> > > > > > > > > >
> > > > > > > > > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > > > > > > > > index cbed91b09640..b5af31c22731 100644
> > > > > > > > > > --- a/mm/userfaultfd.c
> > > > > > > > > > +++ b/mm/userfaultfd.c
> > > > > > > > > > @@ -1818,28 +1818,41 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
> > > > > > > > > >             ptl = pmd_trans_huge_lock(src_pmd, src_vma);
> > > > > > > > > >             if (ptl) {
> > > > > > > > > > -                   /* Check if we can move the pmd without splitting it. */
> > > > > > > > > > -                   if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> > > > > > > > > > -                       !pmd_none(dst_pmdval)) {
> > > > > > > > > > -                           struct folio *folio = pmd_folio(*src_pmd);
> > > > > > > > > > +                   if (pmd_present(*src_pmd) || is_pmd_migration_entry(*src_pmd)) {
> > > > > > > >
> > > > > > > > [1]
> > > > > > > >
> > > > > > > > > > +                           /* Check if we can move the pmd without splitting it. */
> > > > > > > > > > +                           if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> > > > > > > > > > +                               !pmd_none(dst_pmdval)) {
> > > > > > > > > > +                                   if (pmd_present(*src_pmd)) {
> > > > > >
> > > > > > [2]
> > > > > >
> > > > > > > > > > +                                           struct folio *folio = pmd_folio(*src_pmd);
> > > > > >
> > > > > > [3]
> > > > > >
> > > > > > > > > > +
> > > > > > > > > > +                                           if (!folio || (!is_huge_zero_folio(folio) &&
> > > > > > > > > > +                                                          !PageAnonExclusive(&folio->page))) {
> > > > > > > > > > +                                                   spin_unlock(ptl);
> > > > > > > > > > +                                                   err = -EBUSY;
> > > > > > > > > > +                                                   break;
> > > > > > > > > > +                                           }
> > > > > > > > > > +                                   }
> > > > > > > > >
> > > > > > > > > ... in particular that. Is there some way to make this code simpler / easier
> > > > > > > > > to read? Like moving that whole last folio-check thingy into a helper?
> > > > > > > >
> > > > > > > > One question might be relevant is, whether the check above [1] can be
> > > > > > > > dropped.
> > > > > > > >
> > > > > > > > The thing is __pmd_trans_huge_lock() does double check the pmd to be !none
> > > > > > > > before returning the ptl.  I didn't follow closely on the recent changes on
> > > > > > > > mm side on possible new pmd swap entries, if migration is the only possible
> > > > > > > > one then it looks like [1] can be avoided.
> > > > > > >
> > > > > > > Hi Peter,
> > > > > > > is_swap_pmd() check in __pmd_trans_huge_lock() allows for (!pmd_none()
> > > > > > > && !pmd_present()) PMD to pass and that's when this crash is hit.
> > > > > >
> > > > > > First for all, thanks for looking into the issue with Lokesh; I am still
> > > > > > catching up with emails after taking weeks off.
> > > > > >
> > > > > > I didn't yet read into the syzbot report, but I thought the bug was about
> > > > > > referencing the folio on top of a swap entry after reading your current
> > > > > > patch, which has:
> > > > > >
> > > > > >         if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> > > > > >             !pmd_none(dst_pmdval)) {
> > > > > >                 struct folio *folio = pmd_folio(*src_pmd); <----
> > > > > >
> > > > > > Here looks like *src_pmd can be a migration entry. Is my understanding
> > > > > > correct?
> > > > >
> > > > > Correct.
> > > > >
> > > > > >
> > > > > > > If we drop the check at [1] then the path that takes us to
> > > > > >
> > > > > > If my above understanding is correct, IMHO it should be [2] above that
> > > > > > makes sure the reference won't happen on a swap entry, not necessarily [1]?
> > > > >
> > > > > Yes, in case of migration entry this is what protects us.
> > > > >
> > > > > >
> > > > > > > split_huge_pmd() will bail out inside split_huge_pmd_locked() with no
> > > > > > > indication that split did not happen. Afterwards we will retry
> > > > > >
> > > > > > So we're talking about the case where it's a swap pmd entry, right?
> > > > >
> > > > > Hmm, my understanding is that it's being treated as a swap entry but
> > > > > in reality is not. I thought THPs are always split before they get
> > > > > swapped, no?
> > > >
> > > > Yes they should be split, afaiu.
> > > >
> > > > >
> > > > > > Could you elaborate why the split would fail?
> > > > >
> > > > > Just looking at the code, split_huge_pmd_locked() checks for
> > > > > (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd)).
> > > > > pmd_trans_huge() is false if !pmd_present() and it's not a migration
> > > > > entry, so __split_huge_pmd_locked() will be skipped.
> > > >
> > > > Here might be the major part of where confusion came from: I thought it
> > > > must be a migration pmd entry to hit the issue, so it's not?
> > > >
> > > > I checked the code just now:
> > > >
> > > > __handle_mm_fault:
> > > >                 if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
> > > >                         VM_BUG_ON(thp_migration_supported() &&
> > > >                                           !is_pmd_migration_entry(vmf.orig_pmd));
> > > >
> > > > So IIUC pmd migration entry is still the only possible way to have a swap
> > > > entry.  It doesn't look like we have "real" swap entries for PMD (which can
> > > > further points to some swapfiles)?
> > >
> > > Correct. AFAIU here we stumble on a pmd entry which was allocated but
> > > never populated.
> >
> > Do you mean a pmd_none()?
> 
> Yes.
> 
> >
> > If so, that goes back to my original question, on why
> > __pmd_trans_huge_lock() returns non-NULL if it's a pmd_none()?  IMHO it
> > really should have returned NULL for pmd_none().
> 
> That was exactly the answer I gave Lokesh when he theorized about the
> cause of this crash but after reproducing it I saw that
> pmd_trans_huge_lock() happily returns the PTL as long as PMD is not
> pmd_none(). And that's because it passes as is_swap_pmd(). But even if
> we change that we still need to implement the code to skip the entire
> PMD.

The thing is I thought if pmd_trans_huge_lock() can return non-NULL, it
must be either a migration entry or a present THP. So are you describing a
THP but with present bit cleared?  Do you know what is that entry, and why
it has present bit cleared?

I think my attention got attracted to pmd migration entry too much, so I
didn't really notice such possibility, as I believe migration pmd is broken
already in this path.

The original code:

		ptl = pmd_trans_huge_lock(src_pmd, src_vma);
		if (ptl) {
			/* Check if we can move the pmd without splitting it. */
			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
			    !pmd_none(dst_pmdval)) {
				struct folio *folio = pmd_folio(*src_pmd);

				if (!folio || (!is_huge_zero_folio(folio) &&
					       !PageAnonExclusive(&folio->page))) {
					spin_unlock(ptl);
					err = -EBUSY;
					break;
				}

				spin_unlock(ptl);
				split_huge_pmd(src_vma, src_pmd, src_addr);
				/* The folio will be split by move_pages_pte() */
				continue;
			}

			err = move_pages_huge_pmd(mm, dst_pmd, src_pmd,
						  dst_pmdval, dst_vma, src_vma,
						  dst_addr, src_addr);
			step_size = HPAGE_PMD_SIZE;
		} else {

It'll get ptl for a migration pmd, then pmd_folio is risky without checking
present bit.  That's what my previous smaller patch wanted to fix.

But besides that, IIUC it's all fine at least for a pmd migration entry,
because when with the smaller patch applied, either we'll try to split the
pmd migration entry, or we'll do move_pages_huge_pmd(), which internally
handles the pmd migration entry too by waiting on it:

	if (!pmd_trans_huge(src_pmdval)) {
		spin_unlock(src_ptl);
		if (is_pmd_migration_entry(src_pmdval)) {
			pmd_migration_entry_wait(mm, &src_pmdval);
			return -EAGAIN;
		}
		return -ENOENT;
	}

Then logically after the migration entry got recovered, we'll either see a
real THP or pmd none next time.

Some explanation on the problematic non-present THP entry would be helpful.

Thanks,

-- 
Peter Xu


