Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01F24CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 19:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00F6E6B0005; Tue, 19 May 2026 15:03:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDB626B0088; Tue, 19 May 2026 15:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA40F6B008A; Tue, 19 May 2026 15:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C610A6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:03:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60F9191CBA
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:03:03 +0000 (UTC)
X-FDA: 84785091846.08.69645A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 01503100005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:03:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WZiP1V2y;
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779217381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVAA2tyy87o83ai/87dFFBv/pFOI8NrPweDff+Gjdvo=;
	b=E1Ro/ODPIF4GEiRSB1BmBm5XZYc+FtrAPLmDsRsUU7cnIRDgutVNwmGE1Q7Rvdl8IeBZkx
	UeAXXrYtllcspZFykol8OJcC+HUPPCszUbCMaM3XPKEGWvQgkhVyEbXIACdj2lOmVXhJrw
	Y3Z4ZgO++8Ln/orx8hHvbQMu0CvONUc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779217381; a=rsa-sha256;
	cv=none;
	b=f82NCdzq701sbRNft73wwuz+iUkkvj//GiSeWeDIw7eY7CnZQHIdri/2/LTb3N+O83YXfq
	Ey5K29em9Rqi1UolnSfVkK11ZmGYfPWSNYxjRm9Q0qR+pQfiDV9zsbNAX9NMt8pCcqEI1i
	mwHhik2VhiXb++TEPiw62HYt7UKXTJg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WZiP1V2y;
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779217380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FVAA2tyy87o83ai/87dFFBv/pFOI8NrPweDff+Gjdvo=;
	b=WZiP1V2ygvGN42b6K6nkGwDvaAq8sPccXLvugT7jNVhfjvqbzWSYCNXCiYLnS3E0Pnsz1y
	T65B0xiBvm0zsm44QUohwDk7Kj9m2YzO5vQs9OLSfUnEsjTo5dKwmmL7feRdJlaT+979F6
	le0GuR6JsaJAUXb+8E3L3zrYfidlfw0=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-D8OqoTxeOoi8QZDbumdNwQ-1; Tue, 19 May 2026 15:02:59 -0400
X-MC-Unique: D8OqoTxeOoi8QZDbumdNwQ-1
X-Mimecast-MFC-AGG-ID: D8OqoTxeOoi8QZDbumdNwQ_1779217378
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-651bd2131f0so8045583d50.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 12:02:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779217378; x=1779822178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FVAA2tyy87o83ai/87dFFBv/pFOI8NrPweDff+Gjdvo=;
        b=UTZ9wNGlVz5iHEs8eKOA+FA6y4i/8AxSzISgeZ7egYJ6eOS3MiNPN7CSB4zKI4fsQD
         daVwpyfbl1e6hMctYksAE/AaMD9Bx3tjW/S2nLzmxYr5jfp/Dcc/sF1+KDoBpFrqeSB4
         FDG9hDes4RKiPaDLMWia1wJcR60Z2MtiK2bsvn4ZNjlwTTKXNPblEi41VU3PPA2bVZn5
         LhyydsW5GKuF5cDhfAcw438XcmvwsqnHj6GhHViwh9UuTEKqT4j/QWApHKMkESRA03mM
         1lSHz5Qyjss2g3UAHuFQGzp6Rui/vuXT5Yz4gdK7btlydPrC6Yy6chaMwbBTbSiecv6i
         FUSg==
X-Forwarded-Encrypted: i=1; AFNElJ/UvZdQ0ta2243DUum86Cl4QlLs155q3uLZMmUlM0vg7nljIYqLaVPPLghEv+DtpsKI4qQWy+63CQ==@kvack.org
X-Gm-Message-State: AOJu0YzNgIx9Kx/XvNVzNfJ/NTFgnAEzZXNDz6VxHhfIZfOzEG5sSuqK
	4qUaLg+EEyExRMum61pZtxjVg+Pud9B5Ry+QWlwDU7i+gx1OmYkXTpMnzZ5QI1S1VxlDTwdfzlg
	STiqhLBd8x6JUmYhSoorY5snHdIYBhUpBUK4XJJVsSEk9x3/lqzo0AroWuyxq4pZT5gZWXry8a/
	7hGtTzy9JevdyamI1oYEH9Va/ntqQ=
X-Gm-Gg: Acq92OF3xSAeQHiW7Cw6mKauQnJnao57KBgBnV/XfwdW313yukktzy0vO7brvfjtMFU
	++ONYYeGZbDGiUJXUqiNv2okk0cwZoLPnwaXXxUxYO8Kbb0t+rUc6auf+RFF11GwViOJdNGStzR
	hN61/TL/7MQlu4GnucWP6jU+f9hx5lWyYZZA+IILZ11FEa+Eq2Nfi/vxGTWVtBFyPY9ufzHZqAr
	igaDg==
X-Received: by 2002:a05:690e:1501:b0:650:38c4:9d80 with SMTP id 956f58d0204a3-65e22808b89mr19193838d50.35.1779217378230;
        Tue, 19 May 2026 12:02:58 -0700 (PDT)
X-Received: by 2002:a05:690e:1501:b0:650:38c4:9d80 with SMTP id
 956f58d0204a3-65e22808b89mr19193751d50.35.1779217377583; Tue, 19 May 2026
 12:02:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260518115553.3513034-1-usama.arif@linux.dev> <51db205d-77cf-416f-bfe5-fd9d0b12c433@linux.dev>
In-Reply-To: <51db205d-77cf-416f-bfe5-fd9d0b12c433@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Tue, 19 May 2026 13:03:23 -0600
X-Gm-Features: AVHnY4LOZz9hIpEKrtfLZuWF4c69rvSr03brNz_SdNAbFptVm56-2ZdU64Y6lF8
Message-ID: <CAA1CXcCTnEP85mdawwfxKVP4cRqC5wLCXe47kf6w7F5Qn2DEwg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v17 02/14] mm/khugepaged: generalize alloc_charge_folio()
To: Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, liam@infradead.org, ljs@kernel.org, 
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
X-Mimecast-MFC-PROC-ID: JyX0cyBmhFXTp4wf54K8HQd8Rpb_2aWG2iJ_ttQsZtg_1779217378
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 01503100005
X-Stat-Signature: bcp8owofdjroswy819e1mgo5yoz6mucw
X-Rspam-User: 
X-HE-Tag: 1779217380-966217
X-HE-Meta: U2FsdGVkX1/TmQmqzWwMiYWilaj3u7Fv7JxcuELQbkeOfU6yRR2W7JmkPKwXpHEob3LW3/hD9aUgAmzeCHLaQ/ldiF0E813ggUeEkHwDdKjpqYZD5cvzCHZNwp36sA2ZnalX1rUjbnCwgNLXD4QUclFekXKinnnVm5/QQq99XmpZYsluL5Z3xSTMU4U0l00xaEtMRlDC2XlqZ4RiXRyJL3acLWX9i/YftXrVYhlbXxVgQvN490Y3nJexyQdJlUGdYhzgm6nLb8Fd22H+XC9brQRiH2vNLqyGVNYc/0R4JSf+AbPhJJv9xCNl4Om/vkkNxd+ZjVCl0XmvKaxEDFIwwPRE4bGX5FOk6MY+NnLPr7BiwdXo08bJU6WvQ5nbsITSvUSUZo4Lu9R0CIQY8PdRMv5NXFrqP3Uhz0WLkDW+kmS5sSvdTUOLIOj6K3pW4G9i144Teu8DoSCWn969xEtGPDmHG6QOwDu4FB4S0ykp8xrG563qXYAz/8XWlHowW3GNrLABoa/cmEliBXgCXt8rzF99dQuxARROQxPdhzzto2Oz8qk6dBcf7xOXjj3awNITIXTsvVX3AtU72QVktVZcaski0CmK1Fk0EJHn6ZqIDYCWuOBL4t+GVjI6ALoIexkeE7cgcBPWRrgkBa/ALP8Jo1Ps98sUbssxHCkLpBhvumaRqGr62PzeA9A1fZRA0n/GmLCeoCeI0rL2KUlGvHwPo/T99U9+Wn4riUAA/DMBFBdJYezVcoRDwk7OYheqMJNWlij1cGzUvWcf1rXhuxklv7cUI+PC+MugokdY0NG2Y5TLHrvnGl8WQbSqdF53YUB91hXiDA+GROO7bWVArD8GN2Lr+TIrG+XwfKYEAZ512ERZf8GpVzv2n7/Tz/ubzkpO4QaMDF9qG6WtkGZJ5xQIBhLa3x0fGbPTJKXX6N36yHAyaGww5k2Sk5ioWIiuOPflbiP3wld7byu7ePalw4s
 APiEXMPy
 Ws29twk+YeFtXUVAOeFjV6D35sgrvVxxkR0h3rqXq6I1csQURCc0B+VQmaj9jUTS9lxPuMM3R6S48aKlf+lK/lGg5A8RMcxTMgg+wz/hHJElLlfJicHBobV7/R27RywbOMcvLPQcko4sCY+FEr2LfzKII7QR1/aM5z9j3st05AxzjQjDPTepC8XiAInjASGeSZuSAint3CCcS/qqqMjHGA0n38G6yZnQFkeqR2mCx2SIVCVmUChjPRwe/5RXrqzVyOOhJctRyj8IhBa7nlpP8lllGaQCEd6CISTrL8n1VAXV9t5lXVmu22yu2/sqh3rDDfxZTZhiC4CgWEBOHyL8TgmDcaCInVBLsrhx34fUetf1Swy2XFEegEs/Ud9AhSOdanKVALw5wID6LeyZPwYFJAJSHfrCfhntFsMA+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 8:50=E2=80=AFAM Lance Yang <lance.yang@linux.dev> w=
rote:
>
>
>
> On 2026/5/18 19:55, Usama Arif wrote:
> [...]
> >> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >> index 979885694351..f0e29d5c7b1f 100644
> >> --- a/mm/khugepaged.c
> >> +++ b/mm/khugepaged.c
> >> @@ -1068,21 +1068,26 @@ static enum scan_result __collapse_huge_page_s=
wapin(struct mm_struct *mm,
> >>   }
> >>
> >>   static enum scan_result alloc_charge_folio(struct folio **foliop, st=
ruct mm_struct *mm,
> >> -            struct collapse_control *cc)
> >> +            struct collapse_control *cc, unsigned int order)
> >>   {
> >>      gfp_t gfp =3D (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpm=
ask() :
> >>                   GFP_TRANSHUGE);
> >>      int node =3D collapse_find_target_node(cc);
> >>      struct folio *folio;
> >>
> >> -    folio =3D __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nm=
ask);
> >> +    folio =3D __folio_alloc(gfp, order, node, &cc->alloc_nmask);
> >>      if (!folio) {
> >>              *foliop =3D NULL;
> >> -            count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
> >> +            if (is_pmd_order(order))
> >> +                    count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
> >> +            count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
> >>              return SCAN_ALLOC_HUGE_PAGE_FAIL;
> >>      }
> >>
> >> -    count_vm_event(THP_COLLAPSE_ALLOC);
> >> +    if (is_pmd_order(order))
> >> +            count_vm_event(THP_COLLAPSE_ALLOC);
> >> +    count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC);
> >> +
> >
> > The vmstat THP_COLLAPSE_ALLOC counter is pmd order only.
> > But after this we have
> >
> >       count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);
> >
> > which is not being guarded with is_pmd_order().
>
> Good catch!
>
> >
> > I think we want this to be pmd order only as well so that
> > the meaning of the vmstat and cgroup counter remains the same?
>
> Agreed. THP_COLLAPSE_ALLOC should remain PMD order only for
> vmstat and memcg events.
>
> So this should be guarded with is_pmd_order() as well :)

Thanks Usama, I added that.

>
> Cheers, Lance
>


