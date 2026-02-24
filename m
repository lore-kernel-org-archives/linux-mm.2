Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71D8DF4BB89
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 21:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A57846B0005; Tue, 24 Feb 2026 16:14:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04BD6B0089; Tue, 24 Feb 2026 16:14:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 910C06B008A; Tue, 24 Feb 2026 16:14:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 77B636B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:14:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2EB8C1A0339
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:14:47 +0000 (UTC)
X-FDA: 84480604614.17.85D4DD0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id B5A2E40018
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:14:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pn3ikjAd;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771967685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsHKsPxhsXCIwvcMps3to3hB57VV5Rd2L0CbZ6BM9DM=;
	b=o7/iAVOP9bRqCpm7GFwWdcnu1AoWk7HNp4n0q7NRxupC1700ni71fdbQdsXrWf75iHgN+T
	k3QQiCUnHpBBAAehf2H+uACSjytgjdejDrxVkF6WcOEj6ZhoQ1prnaKgXPeR121DyzjC54
	cdOhuqXhIfQFULAZbkMxr8stSWoa8FU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771967685; a=rsa-sha256;
	cv=none;
	b=eL6W2Lc0jVhhIFICfoNjV+guUv6IA9xJxPBg693DnBOZvFdY4vypE2s4OnEkEr0mzQzd2o
	Lc6jmd50RdSiOgVIoqt2PMSrrrW0iS4AKFEdj29ROcn1GyzOBNDIf5Lx1wr36QpgsahcZh
	u6KrpeN4l+UglWuCQ2hth6WV2mn91Ec=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pn3ikjAd;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771967683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JsHKsPxhsXCIwvcMps3to3hB57VV5Rd2L0CbZ6BM9DM=;
	b=Pn3ikjAdp0zVLJCtNKVXpTNGgthgiZM2Apz5gNY45p36lkgQwHNOvuCz7M0m6589ny7jWN
	WDhpqryQR4c3aLLiOkC+5xjSZuAkV7rEwoe1POzpQVYKWua3R0cGPmjDkWv150kaXfIu8q
	LL0C6l2p7/lbeR95VhLmZ79hoL7CX4I=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-b0I2D415OSSqnY9J37bvGQ-1; Tue, 24 Feb 2026 16:14:42 -0500
X-MC-Unique: b0I2D415OSSqnY9J37bvGQ-1
X-Mimecast-MFC-AGG-ID: b0I2D415OSSqnY9J37bvGQ_1771967682
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-64ad0c50067so9525068d50.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:14:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771967682; x=1772572482;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JsHKsPxhsXCIwvcMps3to3hB57VV5Rd2L0CbZ6BM9DM=;
        b=JX0b6dvYq9D4D9jHVtv73me0FDEcdTZuqwYleo4SpIuTA/KTaRqnWSLPXKKy9uWTOv
         JL1v0pmrWqLVNFY5ansU4C9hDkZRHjl5G7YgqjEaibiBtBm2U9KYUg/ALh8WnsiNMz/F
         kJb3ZDcPrUmjgftyEYqwvI/3193MCnIkm0UyoF5vH412tB9NFqARKwePdPxDdu3Tfc5K
         mH91BzW8z4QXKqNMV1TcP7Qro9Vj0uW1dNzXFGBw7UfqohfyTaHres9vXMZmn5bUJSso
         BdEBPbMAh2EyqsEKfD3hfFsVoO0JWFq+axH9p4XLacuh9baqzETMZODkw8y4AZUX7WLl
         Rtvw==
X-Forwarded-Encrypted: i=1; AJvYcCVHlyfMmI2yN7ZgsWDNuKA/RHeKIbyNJkrcC4ngPTggJ2t4tvOSatJ4hfXb0xI+Ph9Ycameqw9jYw==@kvack.org
X-Gm-Message-State: AOJu0YzcG55HupElyfUkOLUXrUqwP/b9h5SQ/RqDg0w67S/SZ+FfuMe9
	3uvbAT+0ppUHy9viBx+vEofrnlqs/1iUbfURc6mmVV8HPbJbOi3HoGQzjCsaKpDntbAk2lDyd7P
	EI1eFBdaLovX8+oA1nDCWmlBa1bzns7Li/CUnEeby4AeTkS9biJZEPfI5ToGBMZjn30tcmSZzY4
	Cjt+uXmtUwbzZejiCTkOmdVO4wqRw=
X-Gm-Gg: ATEYQzzbr9hCVDws6DHNHYL+utR/Xar9K+Dq/ZdsvH99wiilDRl1vovra2TJzSok+p4
	mZ1xHNrnjGfJEWsyY2Q/9mMIPI3H9sw5e8Ke39gaZab3vCFd2ctylHc4I1cjqz84B0o80iO2sAj
	9y+gETo9Uzo3uJflWkJ82L9V9SaCKtkML8TJdpwcJ2vYXGg65jmxnMMzJS8ofA1u0wyymErmsae
	wHb
X-Received: by 2002:a53:ce81:0:b0:649:b2cd:eb7d with SMTP id 956f58d0204a3-64ca8d0d9ebmr149201d50.68.1771967681702;
        Tue, 24 Feb 2026 13:14:41 -0800 (PST)
X-Received: by 2002:a53:ce81:0:b0:649:b2cd:eb7d with SMTP id
 956f58d0204a3-64ca8d0d9ebmr149148d50.68.1771967681133; Tue, 24 Feb 2026
 13:14:41 -0800 (PST)
MIME-Version: 1.0
References: <20260212021835.17755-1-npache@redhat.com> <20260212022512.19076-1-npache@redhat.com>
 <164bfaf0-5e8a-4bd2-a04c-93d61856a941@kernel.org> <CAA1CXcCA6HN_Y4npsH==6tbCJbtMR=+OBmRWowb5NmficZdcHw@mail.gmail.com>
 <62d53608-ed7b-42fe-baad-3023764383a3@kernel.org> <92e9d637-988a-4201-8c8b-c29987b727bb@kernel.org>
In-Reply-To: <92e9d637-988a-4201-8c8b-c29987b727bb@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Tue, 24 Feb 2026 14:14:15 -0700
X-Gm-Features: AaiRm53sWE_gR3qV0PRjcurefJSz310Y54UfLxIva0U1zInSf2-YMPrPMTaZPMU
Message-ID: <CAA1CXcB8hANuSobzicma98FMm_gNXzib0X5XRDwZTJC4jVtBWg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sojmPdGsQOCaB8uUkZr8JGG41_6Tj5OA5hRPT4a0oGU_1771967682
X-Mimecast-Originator: redhat.com
Content-Type: multipart/alternative; boundary="00000000000030b697064b9860ef"
X-Rspamd-Queue-Id: B5A2E40018
X-Stat-Signature: 468bs1juyjm1oow5tc3ojgqz93rhpq8d
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771967684-877684
X-HE-Meta: U2FsdGVkX1+iyjZFqj6K/JSpQi5+dvKojS8LMRAut7tUXiLVbJzpFbRcSw+vQaNlu3VVjmsDUmZ+tnwtJa/wG8llfe2CkyYkcntMq4jUsyfws7gQYKa8G6zFyPyq+Q6QB5XGNTWYHfkJSH2ld6G/5gOpUQya+lvkyWTCgujth7kXohw5E1XrMpJgzKXkVsATEP1X/Urik9XD79VBEyEkjVbBpnLNz3cXAL6kopOqgk2lYimL6JNcRlX5d9h7FAnr/NoItcb/Obm/z2VQnnjHlbqg4954n88eHlLsCfG5KAv7n9Mj4bZxJnyFHnJ00FUhtWRJ7+5Qf28X4kALVNBqN8G9bvBxluWH9d+ImyJICmveQiuriaOLtRwsB9MmVNa/YTlxFKuO2tErtZLkb7+OYjCMprBGD3syD1db3qKUpc2r8KAnDBhj3iHaIQXoDRNXImzTCeheEP4KaS8jd+WhXxL98cMADHV8rS5KNbHDeONtHFZsQu5g+nD1gip3O64wwiz/+fhXtUtkDR4K5St5YU++yZNe8zCRxS5oBPyka1eHeeoXVakmp+t3ns0hppJFjWGG6847R1n58bbqwZ8P0Yofs7qF4QG4zgEPZOCYmQNMyWQ7Nkx+zehIDVrnxwI9pmFlG7fCPdB157oyqhj76XlM/OMj1JgmdbpHJLWsaZ+ZPW283pO/RBQ391RGmIkWinqcJsBldGC58wXDLdY/h573QNTMpUGkSVTZA2Vf4Pe05MFRivVqND9q99/czArRv3t4cWMhlpWa33IbDtkhGaqSPeIs+GDQfSC8Wlo3a2fdndNF6dacdo63KMklzMZXB+RVlitOE7XHRHL1dPfbT0HKCO3ivUrqMyU+8Czy9ar08xChNLSCDRhyVoj32TDrDgOhIiMxF77Nc8EAUslvya8xCF4zDHwtoL1PRCAB/SS3vIeFWdw/e1Hb72xBGHn3ExwqwClICqTViB+so8w
 BUm0JMoe
 tRX/DlEr6o9u4A4Pb6H0NY2K1EzVoH6mitQY7hg8ne4nytr9FRot4cRKFLP48soyZZDSaBD+E8eCKoofZYRe+5qHLl/f2VuosN6Gb5zfa2EwBrLynFHWZVgoXMBTTHGqtWqHHZlG0lUYYW3+CtPyvawa3ei6fTbj3C5+Qn7d6lbsw4+f2IhTDTFnZmM13+UkYj83CBZDjSZqCwfyaw02YfgiT/LT47PSZMaVClvX7TWFkjVr++SWbjh0uoUJvIKnPBjTJrOnas5etIyx4trqT2AFViwHt1pryMolas72mNkaRyFKyq+cf8eUdaSh+H2ywE1IOKcOmqolBlBwGAwXN+Ntujgt/dY8U71shZaDMHv/3EPImZjBovsthXhsHy6FqsfIOqoFqfHyQnptRGSKtyPyh0NUbZJiA/CQn2BvIkHPu28OTeCkH2mJgJmENqrD4i+qc1fnDTOPjCGEj22diYlCF4UZ7HcWKO4DmZooLrVKoJgw9ZwW9u7+sBMJ5+ADxZ72/gBJq69+ttMso8NyM2C9xbWmSvRRk/8PG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000030b697064b9860ef
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 7:41=E2=80=AFAM David Hildenbrand (Arm) <david@kern=
el.org>
wrote:

> On 2/23/26 15:24, David Hildenbrand (Arm) wrote:
> > On 2/12/26 21:26, Nico Pache wrote:
> >> On Thu, Feb 12, 2026 at 1:04=E2=80=AFPM David Hildenbrand (Arm)
> >> <david@kernel.org> wrote:
> >>>
> >>>
> >>> Having triggered_wb set where writeback is not actually triggered is
> >>> suboptimal.
> >>
> >> It took me a second to figure out what you were referring to, but I
> >> see it now. if we return SCAN_PAGE_D_OR_WB but the can_writeback fails
> >> it still retries.
> >>
> >> Would be an appropriate solution if can_writeback fails to modify the
> >> return value.
> >> ie)
> >>
> >> if (!cc->is_khugepaged && result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK) =
{
> >>      if (mapping_can_writeback(file->f_mapping)) {
> >>         const loff_t lstart =3D (loff_t)pgoff << PAGE_SHIFT;
> >>         const loff_t lend =3D lstart + HPAGE_PMD_SIZE - 1;
> >>
> >>         filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> >>      } else {
> >>         result =3D SCAN_(SOMETHING?)
> >>      }
> >> }
> >> fput(file);
> >>
> >> we dont have a enum that fits this description but we want one that
> >> will continue.
> >
> > I stared at the patch and possible ways to change it, but I wondered
> > whether this refactoring is really the right approach.
> >
> > The whole mmap locking just makes this all very weird.
> >
> > Let me think about it some more.
> >
>
> As we don't really need to re-grab the MM lock, I think we can just do:
>

Yes this looks much better thank you!

Cheers,
-- Nico


>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 844a8a27845e..d546ff173833 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2395,6 +2395,7 @@ static enum scan_result collapse_single_pmd(unsigne=
d
> long addr,
>                  struct collapse_control *cc)
>   {
>          struct mm_struct *mm =3D vma->vm_mm;
> +       bool triggered_wb =3D false;
>          enum scan_result result;
>          struct file *file;
>          pgoff_t pgoff;
> @@ -2409,14 +2410,22 @@ static enum scan_result
> collapse_single_pmd(unsigned long addr,
>
>          mmap_read_unlock(mm);
>          *mmap_locked =3D false;
> +
> +retry:
>          result =3D collapse_scan_file(mm, addr, file, pgoff, cc);
>
> +       /*
> +        * For MADV_COLLAPSE, try to writeback once to retry the collapse
> +        * immediately.
> +        */
>          if (!cc->is_khugepaged && result =3D=3D SCAN_PAGE_DIRTY_OR_WRITE=
BACK
> &&
> -           mapping_can_writeback(file->f_mapping)) {
> +           !triggered_wb && mapping_can_writeback(file->f_mapping)) {
>                  const loff_t lstart =3D (loff_t)pgoff << PAGE_SHIFT;
>                  const loff_t lend =3D lstart + HPAGE_PMD_SIZE - 1;
>
>                  filemap_write_and_wait_range(file->f_mapping, lstart,
> lend);
> +               triggered_wb =3D true;
> +               goto retry;
>          }
>          fput(file);
>
> @@ -2814,9 +2823,7 @@ int madvise_collapse(struct vm_area_struct *vma,
> unsigned long start,
>
>          for (addr =3D hstart; addr < hend; addr +=3D HPAGE_PMD_SIZE) {
>                  enum scan_result result =3D SCAN_FAIL;
> -               bool triggered_wb =3D false;
>
> -retry:
>                  if (!mmap_locked) {
>                          cond_resched();
>                          mmap_read_lock(mm);
> @@ -2838,11 +2845,6 @@ int madvise_collapse(struct vm_area_struct *vma,
> unsigned long start,
>                  if (!mmap_locked)
>                          *lock_dropped =3D true;
>
> -               if (result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK &&
> !triggered_wb) {
> -                       triggered_wb =3D true;
> -                       goto retry;
> -               }
> -
>                  switch (result) {
>                  case SCAN_SUCCEED:
>                  case SCAN_PMD_MAPPED:
>
>
> --
> Cheers,
>
> David
>
>

--00000000000030b697064b9860ef
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Feb 23,=
 2026 at 7:41=E2=80=AFAM David Hildenbrand (Arm) &lt;<a href=3D"mailto:davi=
d@kernel.org">david@kernel.org</a>&gt; wrote:<br></div><blockquote class=3D=
"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(2=
04,204,204);padding-left:1ex">On 2/23/26 15:24, David Hildenbrand (Arm) wro=
te:<br>
&gt; On 2/12/26 21:26, Nico Pache wrote:<br>
&gt;&gt; On Thu, Feb 12, 2026 at 1:04=E2=80=AFPM David Hildenbrand (Arm)<br=
>
&gt;&gt; &lt;<a href=3D"mailto:david@kernel.org" target=3D"_blank">david@ke=
rnel.org</a>&gt; wrote:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Having triggered_wb set where writeback is not actually trigge=
red is<br>
&gt;&gt;&gt; suboptimal.<br>
&gt;&gt;<br>
&gt;&gt; It took me a second to figure out what you were referring to, but =
I<br>
&gt;&gt; see it now. if we return SCAN_PAGE_D_OR_WB but the can_writeback f=
ails<br>
&gt;&gt; it still retries.<br>
&gt;&gt;<br>
&gt;&gt; Would be an appropriate solution if can_writeback fails to modify =
the<br>
&gt;&gt; return value.<br>
&gt;&gt; ie)<br>
&gt;&gt;<br>
&gt;&gt; if (!cc-&gt;is_khugepaged &amp;&amp; result =3D=3D SCAN_PAGE_DIRTY=
_OR_WRITEBACK) {<br>
&gt;&gt; =C2=A0=C2=A0=C2=A0=C2=A0 if (mapping_can_writeback(file-&gt;f_mapp=
ing)) {<br>
&gt;&gt; =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const loff_t lstart =3D=
 (loff_t)pgoff &lt;&lt; PAGE_SHIFT;<br>
&gt;&gt; =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const loff_t lend =3D l=
start + HPAGE_PMD_SIZE - 1;<br>
&gt;&gt;<br>
&gt;&gt; =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 filemap_write_and_wait_=
range(file-&gt;f_mapping, lstart, lend);<br>
&gt;&gt; =C2=A0=C2=A0=C2=A0=C2=A0 } else {<br>
&gt;&gt; =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 result =3D SCAN_(SOMETH=
ING?)<br>
&gt;&gt; =C2=A0=C2=A0=C2=A0=C2=A0 }<br>
&gt;&gt; }<br>
&gt;&gt; fput(file);<br>
&gt;&gt;<br>
&gt;&gt; we dont have a enum that fits this description but we want one tha=
t<br>
&gt;&gt; will continue.<br>
&gt; <br>
&gt; I stared at the patch and possible ways to change it, but I wondered <=
br>
&gt; whether this refactoring is really the right approach.<br>
&gt; <br>
&gt; The whole mmap locking just makes this all very weird.<br>
&gt; <br>
&gt; Let me think about it some more.<br>
&gt; <br>
<br>
As we don&#39;t really need to re-grab the MM lock, I think we can just do:=
<br></blockquote><div><br></div><div>Yes this looks much better thank you!<=
/div><div><br></div><div>Cheers,</div><div>-- Nico=C2=A0</div><div>=C2=A0</=
div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bor=
der-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
diff --git a/mm/khugepaged.c b/mm/khugepaged.c<br>
index 844a8a27845e..d546ff173833 100644<br>
--- a/mm/khugepaged.c<br>
+++ b/mm/khugepaged.c<br>
@@ -2395,6 +2395,7 @@ static enum scan_result collapse_single_pmd(unsigned =
long addr,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct collap=
se_control *cc)<br>
=C2=A0 {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct mm_struct *mm =3D vma-&gt;vm_mm;<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0bool triggered_wb =3D false;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0enum scan_result result;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct file *file;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pgoff_t pgoff;<br>
@@ -2409,14 +2410,22 @@ static enum scan_result collapse_single_pmd(unsigne=
d long addr,<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mmap_read_unlock(mm);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*mmap_locked =3D false;<br>
+<br>
+retry:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0result =3D collapse_scan_file(mm, addr, f=
ile, pgoff, cc);<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * For MADV_COLLAPSE, try to writeback once to =
retry the collapse<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * immediately.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!cc-&gt;is_khugepaged &amp;&amp; resu=
lt =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mapping_can_writeback(file-&gt;f_=
mapping)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!triggered_wb &amp;&amp; mapping_=
can_writeback(file-&gt;f_mapping)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const loff_t =
lstart =3D (loff_t)pgoff &lt;&lt; PAGE_SHIFT;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const loff_t =
lend =3D lstart + HPAGE_PMD_SIZE - 1;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0filemap_write=
_and_wait_range(file-&gt;f_mapping, lstart, lend);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0triggered_wb =3D tr=
ue;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto retry;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fput(file);<br>
<br>
@@ -2814,9 +2823,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsi=
gned long start,<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (addr =3D hstart; addr &lt; hend; add=
r +=3D HPAGE_PMD_SIZE) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0enum scan_res=
ult result =3D SCAN_FAIL;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bool triggered_wb =
=3D false;<br>
<br>
-retry:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!mmap_loc=
ked) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0cond_resched();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0mmap_read_lock(mm);<br>
@@ -2838,11 +2845,6 @@ int madvise_collapse(struct vm_area_struct *vma, uns=
igned long start,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!mmap_loc=
ked)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0*lock_dropped =3D true;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (result =3D=3D S=
CAN_PAGE_DIRTY_OR_WRITEBACK &amp;&amp; !triggered_wb) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0triggered_wb =3D true;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0goto retry;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0switch (resul=
t) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case SCAN_SUC=
CEED:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case SCAN_PMD=
_MAPPED:<br>
<br>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
<br>
</blockquote></div></div>

--00000000000030b697064b9860ef--


