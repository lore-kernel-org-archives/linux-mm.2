Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99CB1CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCC8A6B0096; Tue, 26 May 2026 08:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7DA26B0099; Tue, 26 May 2026 08:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45C26B009B; Tue, 26 May 2026 08:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEA416B0096
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:07:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AEFEB8E099
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:07:10 +0000 (UTC)
X-FDA: 84809445420.07.AC41D16
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 41EFC160006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:07:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HVfLzUdF;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779797228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eiAFrFRbjd4+RPbTvUUvKWoOw3SyaKiqWrxbSKz7lDc=;
	b=IYrFI7COcBYDIkyOsNZc6kYdJK6LR9pw7D7CyFBsminutPxkala/Oa/vkL3C+39GbM+Q9A
	BfvTiI1kC12J8RJirMHF5IWieV/NcSKBJA+kGwm15E83KyzqrPXFPo3hqGOekGqy1kb8UC
	NfiKM+3ceSbqbOmmF9ueACfxydTvxCM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HVfLzUdF;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779797228; a=rsa-sha256;
	cv=none;
	b=g5pMhdc2PZccykpDfMrHSlztbRmDeFWB+2JxIkeljSVBfzfn+GCcxyT+mgQRdpzkLqaMfQ
	ftjxy9viPaEyg2ynIOQUNwUxnY36youRM31sIhGiz0+caRKhIpUDK5i29tfxgHuinQAYZY
	CaVhCr0VmTOOo2bQrJ3Dn/PaN3QcA5s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779797227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eiAFrFRbjd4+RPbTvUUvKWoOw3SyaKiqWrxbSKz7lDc=;
	b=HVfLzUdFsXzTQaZXilIzZ6HO3cqMnKiyJksV14dvWzuCh/5s5snF7PBsabi/ExVLhj8Uvb
	lTt7PWF41tJKTXkORP5r6PzKmTFg2Bf1NaKPRwPpkjpxjdoPHT01RumLBRxFOo1uw3n6qQ
	IqZxkBPQsxniKdseE0JHY8yPuO81sOU=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-6jrgVoVbMvefDwMWPU_Mkw-1; Tue, 26 May 2026 08:07:06 -0400
X-MC-Unique: 6jrgVoVbMvefDwMWPU_Mkw-1
X-Mimecast-MFC-AGG-ID: 6jrgVoVbMvefDwMWPU_Mkw_1779797226
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-65c5afaff48so19403783d50.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 05:07:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779797226; x=1780402026;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eiAFrFRbjd4+RPbTvUUvKWoOw3SyaKiqWrxbSKz7lDc=;
        b=DIe7ufrZJjPhwNoB1nqnvndpE0ZDviwkLoCttg2b91NW1jtQx98u25tBKBM5JwGUv9
         g2rptQ3H+AreNDkreSe/VN+OtqOKvGHH0yJ3AuIH9p5wdzO1X0OZ1xm28jaj+s7mjgEL
         jtfORpxWfh5MBP5/+YVKxSUlnwlJrxhVnR9Wo3iRPLWsiWWA+cvbe3YH1YYEGPO4UZTL
         DXpHO693lwvMagsmxQiHJf/bRZLE9PqNysbD/2WoaNDoMHXxl9N6KpzopbMVQfiabYo5
         gIcVM1ojycOW5j9cOZIkGZPLs1HHrido+nl1B2MgmvlgJhn+0VIrS4xQHDozkvbVfF1n
         pTWg==
X-Forwarded-Encrypted: i=1; AFNElJ/oMBmC4Cn9x/hmjqByWMYxNvcqvvLPFGX4vIT+iawZlFtPQZdKSPdOJXi2R51rDVV846wxgiFxiA==@kvack.org
X-Gm-Message-State: AOJu0YzvtzCrBAcnoLMIpNuRaqRakNkfijAxWLyOMEXi1iuYP70x3zEK
	ZeQeuke9TF1rqdeAGXaqpKUiSNGuOTM7zLEsRkvoPzPxSTfQ+TyNUcR6qo9KJPisjrtlcb8Xs75
	rM9Ic9EWsFyhNHeAdXytuUIPCHGSlEXvIpd5vOaLG2fw2jck6ij/b8NcKtlWHm7erHZgC6DETlV
	IF+4uD6dhfsBhdFk6q+ISem26DD18=
X-Gm-Gg: Acq92OG6zOep+aRbvkkkWWBfbtRxpIe7OTcXCS65Zr7pAhGFFGKeEfSZB/UUuDHejhw
	Q5qgVzNtU0PQEe5uk0zcGEj9huysDI3z028bbkz4CNCRAF7AAlAHzNEzfpDGpfV2SGNZ0JVVxkz
	v8Q2PqyVLsQlLxx4LbdHmcQP4jR0OEmJv4CLi4kyBt8vxmSYnXGj+1B3wjjtdrPDvuwyNOmZXF5
	6LgYhiwWRUssaYi
X-Received: by 2002:a53:ac94:0:b0:65c:4a37:3975 with SMTP id 956f58d0204a3-65eac8ffbe6mr17560479d50.0.1779797225593;
        Tue, 26 May 2026 05:07:05 -0700 (PDT)
X-Received: by 2002:a53:ac94:0:b0:65c:4a37:3975 with SMTP id
 956f58d0204a3-65eac8ffbe6mr17560402d50.0.1779797225094; Tue, 26 May 2026
 05:07:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260522150009.121603-1-npache@redhat.com> <20260522150009.121603-12-npache@redhat.com>
 <2b2cda8c-358a-4a5c-989c-ae42593ef2ea@redhat.com> <20260525121041.2f2508a4f627c338cddd837a@linux-foundation.org>
 <20260526065708.oyyddmt2zgfwu2q7@master>
In-Reply-To: <20260526065708.oyyddmt2zgfwu2q7@master>
From: Nico Pache <npache@redhat.com>
Date: Tue, 26 May 2026 06:07:38 -0600
X-Gm-Features: AVHnY4JcK8OmA0BDu7BZOR--WqtBBKWM2GWs1qml7WVs0MOjDwCnB55pWKWIb9o
Message-ID: <CAA1CXcDXyDhMyiVAb8XbusqMU10JXA8nOUw6b4_2i9H-kV2vwQ@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, 
	cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, rientjes@google.com, rostedt@goodmis.org, 
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6hZwN1eGZxsF6MeFRXguDBRBQTQSum1lH7xGLPksFvk_1779797226
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: b7ihu5aekdnso8qj7ry6fz5gu13tobca
X-Rspamd-Queue-Id: 41EFC160006
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779797228-885313
X-HE-Meta: U2FsdGVkX1+rP/RFumYZqMxLi2PVAD446HH+Rf6E1RYMSBArqwVveM56XViIcLihzKY43+WRO9mRkRV5kl3xGwHBbXcLHjcPo8gA7N69SU6vjn/yxdT2co/mFcDLNk7feY+w3yZvPsX4UnqRkcmqNO0uTFlfvMHYYTaOwtgoxY0AtpWvwoVRVks73wm0tx2hQs0sci1lpfaiK7wZN6XbMrOp7cXtKw4O+tKidC9rmo40Zr/74hCFv9VnsPK9UJD3Lo/Ye7+Vd4uapA/VOYL3BJA0/mgMs9Nof6BUewXlel6t1VVmIJ/cW3wXFqDfN6ONW7+VlHL7khZGySQ75SI7mQQ4m1HY7NzROFY3gSGhRCPQW5wqw252m7KYvs51kiTKS+7l/82+uSIuv8O39D8JO6UEDmvIvOuOGgq0JbO5Chwxs4d9JPvLHdkc+YaoF/T+3q7hOwR/5VjOnzw/1GRkaAwb/e/za39yyoxKy5M/Rjz8fR0aejTG5aPMZVzL0GYMNrxUiHT6yqDExWfC3gQgGrfpkNCqlErGxiPfgvGuzSz0jchLGGIV7PFjxofk/A7djUaNjRdpLFWZxdvnI/31jKScu99WFlBy5stVXb7jou3vYXQ+7Z+tVRF9DJc744CdIcuy1q3B5qTN1Scd4HFToTneU7dG2sFHb0KThzEu9/DLIWacNy098uLQwEwhoMUMa0XFDmElvrNmN0QA0kXz99yIxaBP5PPj5F8Ge0jxQwv6wK92AmMLD/MSaxBJCIESXDDvZz00FK1IanCAe9BrhPPyU2JdKa4Y2FOEPqF6QhwDVttVlsrNJmhU5aJMVeZuq4+R+nUdEQ+eKBELK2pjryBaW7EJSYZ6Ziq1iOprybBhsaZ99LHV+KSqEfAvwuuQUa30qH3egPoN763jSFaDqjgDqAAEMlDK8IcFiyenHTxw+hBsAnkQxah2N91a+0G4/Q/IsV5z6kEpIl2dKWF
 +t+xCdeP
 i/lo5GUCzw/J4/0KmhI2WaqfzFOL/4i9oiZkFzwtsjp/FLoheJhmT/Q6Z9sPrk6wFh/hmEviHL/+tlJjoe+2aSVfXYsqKErPCbQiReDRXw9/ZzoYAIMckLBtKhBPo2YqxWdz7IHVOuJ7HOSYIWrBQTKnFIM6bJckIgMLHlbo3pNGn53COEhf49Ur/QCWekAlMbY9+TYiPCNtqiRec5dMulD/Ws6pLoqhsDNOFN/suTm9hY7yuzVpY/Qz2lSHRGTzsZxOlx1l27zyqhi+PiMBX5B952Ho3C2161xlFm8bAstQ0sN5SWAXBzMS32kJaq0gdOyipR0YSTmMvukFXoJ4lOnj5AQw3F6v/6PwQ3JHQtKk0HYE4I2VL2B0trr/0709vYfnHPZhmXUyYfyx2i/yOAuUIx6vob6FqeOnQhatchquoGKwS6By4dbgDsPz+wlSsIbtJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 12:57=E2=80=AFAM Wei Yang <richard.weiyang@gmail.co=
m> wrote:
>
> On Mon, May 25, 2026 at 12:10:41PM -0700, Andrew Morton wrote:
> >On Mon, 25 May 2026 08:15:53 -0600 Nico Pache <npache@redhat.com> wrote:
> >
> >> Can you please append the following fixup that reverts one of the
> >> changes requested in V17. The issue with the change is described
> >> below.
> >
> >OK.  fyi, what I received was badly mangled: wordwrapping, tabs messed
> >up, etc.
> >
> >Here's my reconstruction:
> >
>
> Hi, Nico
>
> I tried to reply your mail, but found it has some encoding problem, so re=
ply
> here.

Yeah sorry I didnt properly configure my email client after getting a
new laptop.

>
> >
> >Author: Nico Pache <npache@redhat.com>
> >Subject: fix potential use-after-free of vma in mthp_collapse()
> >Date: Mon May 25 07:38:59 2026 -0600
> >
> >Between V17 and v18, one reviewer (Wei) brought up that we are not doing
> >the uffd-armed check until deep in the collapse operation.  While not
> >functionally incorrect, it can lead to unnecessary work.
>
> So we decide to tolerate the behavioral change?

Yes, I believe it is ok for now. Either way we needed to remove the
potential UAF. It only affects the behavior if mTHP is enabled, so the
legacy behavior is kept. And the uffd case is limited.

My future work involves further optimizing and cleaning up khugepaged.
I'll make this part of the goal too. My first thought is to do the
revalidation at every order (between the locks dropping); but that
essentially pays the same penalty... I can't think of a clean solution
at the moment.

Does that sound ok?

Cheers,
-- Nico


-- Nico

>
> >
> >We optimized this by passing the vma variable to mthp_collapse() and usi=
ng
> >the collapse_max_ptes_none() function to check the state of uffd-armed
> >preventing the wasted work later in the collapse.
> >
> >mthp_collapse() is called after mmap_read_unlock(), so the vma pointer c=
an
> >become stale.  Remove the vma parameter and pass NULL to
> >collapse_max_ptes_none() instead.
> >
> >Link: https://lore.kernel.org/2b2cda8c-358a-4a5c-989c-ae42593ef2ea@redha=
t.com
> >Signed-off-by: Nico Pache <npache@redhat.com>
> >...
> >
> > mm/khugepaged.c |   10 +++++-----
> > 1 file changed, 5 insertions(+), 5 deletions(-)
> >
> >--- a/mm/khugepaged.c~mm-khugepaged-introduce-mthp-collapse-support-fix
> >+++ a/mm/khugepaged.c
> >@@ -1502,9 +1502,9 @@ static unsigned int collapse_mthp_count_
> >  * If a collapse is permitted, we attempt to collapse the PTE range int=
o a
> >  * mTHP.
> >  */
> >-static int mthp_collapse(struct mm_struct *mm, struct vm_area_struct *v=
ma,
> >-              unsigned long address, int referenced, int unmapped,
> >-              struct collapse_control *cc, unsigned long enabled_orders=
)
> >+static int mthp_collapse(struct mm_struct *mm, unsigned long address,
> >+              int referenced, int unmapped, struct collapse_control *cc=
,
> >+              unsigned long enabled_orders)
> > {
> >       unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
> >       int collapsed =3D 0, stack_size =3D 0;
> >@@ -1524,7 +1524,7 @@ static int mthp_collapse(struct mm_struc
> >               if (!test_bit(order, &enabled_orders))
> >                       goto next_order;
> >
> >-              max_ptes_none =3D collapse_max_ptes_none(cc, vma, order);
> >+              max_ptes_none =3D collapse_max_ptes_none(cc, NULL, order)=
;
> >
> >               nr_occupied_ptes =3D collapse_mthp_count_present(cc, offs=
et,
> >                                                              nr_ptes);
> >@@ -1749,7 +1749,7 @@ out_unmap:
> >       if (result =3D=3D SCAN_SUCCEED) {
> >               /* collapse_huge_page expects the lock to be dropped befo=
re calling */
> >               mmap_read_unlock(mm);
> >-              nr_collapsed =3D mthp_collapse(mm, vma, start_addr, refer=
enced,
> >+              nr_collapsed =3D mthp_collapse(mm, start_addr, referenced=
,
> >                                            unmapped, cc, enabled_orders=
);
> >               /* mmap_lock was released above, set lock_dropped */
> >               *lock_dropped =3D true;
> >_
>
> --
> Wei Yang
> Help you, Help me
>


