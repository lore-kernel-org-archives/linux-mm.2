Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F02BCD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD206B0088; Tue,  9 Jun 2026 06:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4896B008A; Tue,  9 Jun 2026 06:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9F26B008C; Tue,  9 Jun 2026 06:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4866B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:49:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FE6BC1EC8
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:49:52 +0000 (UTC)
X-FDA: 84860053824.21.06D00CC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9D86118000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:49:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B+5Tg1iR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781002189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oybSjy/BUCusB5v0qku6caRMlW4QF0kXV4iZvPCHaIo=;
	b=XjykwZoYJ3Ch+tVz29BhsYXLQLuxXlz68XQvvR7/fm2mdOanKbjSyX3TnogRRpIO6oegmQ
	uzp+gBItOZoh5q1maNM285BKyXgt/ehIZvH69R3bul4NuMj/70kydTYRMvIqv5IF4cqHOm
	NfM/+KhgEQKQ8z5TXoTdx+ZOMA8HwgI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B+5Tg1iR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781002189;
	b=QUdyo99Khwg12m5SNZRa8RjJO7eND3nEQH1ZiQ9U4frsvNYZr9L/28voyHILAXLGAxT9hW
	AyxgBtZmwWio1vyT1nUOPsQkoIpxb+2mVg8Od+GtZC2dtH1DB1jrJG3JNPTFzFV6WRRs2q
	bwlzgXxbMVoI9oFrLiL04oC0ErR1otw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781002188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oybSjy/BUCusB5v0qku6caRMlW4QF0kXV4iZvPCHaIo=;
	b=B+5Tg1iRSuxsWME7RJHLA9N6S4uEjPcAcKhkFj+1CLkTMGVLEleFDY1GNmk5WHuCB6CJ20
	p8xwg+MjhLuu10/Tk+6JCZPXvrY02KR25MLiFFwU5Hdx1J8AZ7ay4i/xTV/UbKSCILFnqS
	paqFVg6fQIBQcBeBBaR1miCn9wzBIv0=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-rNLjlaloNDKq7cqrlQEMfQ-1; Tue, 09 Jun 2026 06:49:45 -0400
X-MC-Unique: rNLjlaloNDKq7cqrlQEMfQ-1
X-Mimecast-MFC-AGG-ID: rNLjlaloNDKq7cqrlQEMfQ_1781002185
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-6603b45ec02so4523586d50.3
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 03:49:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781002185; x=1781606985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oybSjy/BUCusB5v0qku6caRMlW4QF0kXV4iZvPCHaIo=;
        b=RfqV3BQXG3rcI/yLR3T9iFGd4VR3bCRNuuvlzTactNiFLOxY1BOq7GQO5GGFvxnPzy
         ic8ZCmVSZhRPknms/osQ4DCZda0BOJ8gn7SVrGmE18kzxEqORHf0yiTj2wmKBV0IxrjX
         BDVtho9FPHkYPlR66xmchD2QVEP9jxEcvi7wsEhSkyJEa+0TC62tk5o08xVo99rzYTnP
         FDOGjSTs6A42bhkY7u3Ex9nlV8abP32zOySYHtslzo6IaoDF83FIhFV9ojuNrvkv6Zzq
         fk5ar+SGFsuR9CaExRfL/GOJetciUHrc06n77TOz0U/ChZ5ETi2Ee+qDJ+EkpAq9zRzO
         aXPw==
X-Forwarded-Encrypted: i=1; AFNElJ9cn1V5qPf24+fLijY+khuZRW9ZrhO3W/TPmjqVcHcyJSGdmHVtVZE/K71ifDxIW2XfaG61ug9vNA==@kvack.org
X-Gm-Message-State: AOJu0YyH9/HgXRFdfQWaYiwJtkmOkrvFk/wZ/mD6UXxDY8jMYH40FEWH
	RGu3iEUawQXfwk/zqnePq6FHVAZjOLJODjh5gJbispndwfHTUNQjSEQHviAmQT34IO9WyFX6OSa
	R0KgCp5MKW+pgwlIzFIutumQb5gVgtnzUODLIGbM8jetrdVNwGK5NL9F4VU6bIs48RXuEBIL0Fb
	D1MVCF22rynY+x1/qzAFSPGWHJcDU=
X-Gm-Gg: Acq92OGD+5y5IbfiI7T748sYqds8YMauq9MBjp9P4MRpxVA8iODjXn8M5ZyWeGugzy3
	2dYMZ3jk1DL4XvrgK67y8LUt7v8e1LwuiKdMogx1EINJR1w5I97du7Z5vQ39rC6p4vuBNHVLouI
	s9+wy8563oiHFCQZVLqS87cA2c/nbc5plv27PWm0Cry91x3W7MNjff/AeD1rJOdBzbkpvkDAMyu
	cP7QNXfwove7SJm
X-Received: by 2002:a05:690e:bc8:b0:661:1307:3d48 with SMTP id 956f58d0204a3-661130740c1mr14942542d50.23.1781002184697;
        Tue, 09 Jun 2026 03:49:44 -0700 (PDT)
X-Received: by 2002:a05:690e:bc8:b0:661:1307:3d48 with SMTP id
 956f58d0204a3-661130740c1mr14942464d50.23.1781002184142; Tue, 09 Jun 2026
 03:49:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260605161422.213817-12-npache@redhat.com> <20260606102800.26940-1-lance.yang@linux.dev>
 <2553caae-9e0e-42a7-8b61-d1216f1e81fa@kernel.org> <CAA1CXcBY_2372eJru8VoCq90rUMxn7w23hHou68MmXRv48NRXg@mail.gmail.com>
 <b7fb4184-7a99-42c7-8ee2-4c7fa20827c4@kernel.org> <CAA1CXcAhw8V+_dYcrqmtZ9ht4Pqz5PPB8EOcDrVCp4DA4y7pLg@mail.gmail.com>
 <7e36f7f0-b4d5-41c9-b399-9e0079907d33@linux.dev>
In-Reply-To: <7e36f7f0-b4d5-41c9-b399-9e0079907d33@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Tue, 9 Jun 2026 04:50:30 -0600
X-Gm-Features: AVVi8CfEmBBiPisLcTlQkrBGxz8hwbio2e3oUzPtBYwEihX4RcQI0ruEO3CUrE4
Message-ID: <CAA1CXcD7WAiA1b9GTLAuNZ+kHaFx0SzZwpBkqAZ=s+RHsTUaow@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v19 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: Lance Yang <lance.yang@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bcyOcYe7crZa9nLf9IxZHiCf3-pxggxoNRO0iWMyDrQ_1781002185
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9D86118000A
X-Stat-Signature: 5jmdr4jw699fa3bhy1nwszpf9hshpd4m
X-HE-Tag: 1781002189-224615
X-HE-Meta: U2FsdGVkX1+1MlfJ32ys11IDBQUmES7+gLFhmgfkf36WIku5ATJwfVaIER82lNF2LemRE4q71Wn1MQEhJrDgmT4uzD3x4hELmD2z/hz+oudRdAtGFeVhGf5rEJKjXPbgP7xyNCR0ewjfpxRvjb7DWK08FbBOzl3yVV/+Zk9oVzsChrrL/187E5DxbuDFK3FtwpLwGN5O397vJ+wRZKdgXzv3yyC8R/S6z9yX9NeKMTCSzbKQM+ERyZGcvnhckiVZPYHnwirgJ9tYr8HDHPL60cYj52XH6WUTrHYF6+N/jYz/lTub3KnvurJ0TTnNREkt30VkYtd4CAa0JZhHN72EBZSX3W6JWdJo+MDpmOw4K/EKbSP9cFaA2ICptKufz3WAQUoGEpoEwJ+HDDWMS4WOK6996jy8p3XXtUTCM+yHDVZvED91YteKtvqHL6BdmWtV9i/hp1El39iA6wRNxIO7uc23FOsuphdA78mB46RDvsGrDKXDtVZ47EQA5Id8UK+Qt9L7H4wkXCwUEqLYJ3dVynzyKejJDCRkM3V3rHaH0TxqnGX8MeremPb9XnXZVzRYvOoc3xPhswJwxj1eyvdWTsPz5EYUaVDs4Ld7SCArNTZQlaRHihz/eG2mCdB9+VOn+7gELn+XEbKxabcRzVBdI8p4iCfgec3Y1u7eKpbmskH8irTtAbgzAq/xyPag960aDIosxGtiz+0IWjfatDtws5Frymry9hRWK32qBOQojWwQZ091Q5x9SicqAvRzMgO32Z7XufiXrMD45edJZy2/zU3z8GLhi3r/NGKhQ8KoTjkroG0+BWHZm+xPTb//L1s1A08FayGg+R+JpN0VPT+cJWs0Q79W9ryDFRZ02BWjWj2vzqH9a0wEZ16cdFhyseI5XZflefwLzfp+Xg9e321t0wZFOHHzB8vycrsrXxphYk+RpuxMfBkg+3/JJaLaswDGy3dx+qvkFBjPZE/E69Y
 mx+I5AuN
 p2r/9T+Y6rarnfyZeuO3RTDFbmpL4QDVZgABbANsRDgrCza8lcJPIMIrvBfWlrh7kNcVrVtBkc2By0UjAJEis5dAv0a7lbe7LLL9DFiAuV+mmi3D4pSTu2/uRyqPJwnWndVjwBpdp02D70mCHU5tHOm/otM9t71qvTlqPUiGQ/Giv6jrnXKxkkfXXgZCU/3ePoqCBtRhe4bZfjkvQmPjiDVbUBjuvKFFnOpE4odWVOar9vje8jOQeMge1mSvmf/8Amwz0BAgUq9KkMVR9q8Lypb2klUJXlApvM0tzI3HanndK6T5xKRAIxbZcsDmVae41ZnDR2/VpheExFcfFIr7l4SjDsipqmWcJ5Zp2V76UprHWV3m+wo9z7/z2fL2NSWQH/OkaPLfxcFggJJyAeoaqVgxkzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 4:37=E2=80=AFAM Lance Yang <lance.yang@linux.dev> wr=
ote:
>
>
>
> On 2026/6/9 17:32, Nico Pache wrote:
> > On Tue, Jun 9, 2026 at 3:26=E2=80=AFAM David Hildenbrand (Arm) <david@k=
ernel.org> wrote:
> >>
> >> On 6/9/26 11:06, Nico Pache wrote:
> >>> On Mon, Jun 8, 2026 at 8:57=E2=80=AFAM David Hildenbrand (Arm) <david=
@kernel.org> wrote:
> >>>>
> >>>> On 6/6/26 12:28, Lance Yang wrote:
> >>>>>
> >>>>>
> >>>>> Looks broken for swap PTEs in PMD collapse ...
> >>>>>
> >>>>> collapse_scan_pmd() allows them up to max_ptes_swap and record them=
 in
> >>>>> unmapped, but they don't get a bit in mthp_present_ptes. And then
> >>>>> mthp_collapse() does the check above:
> >>>>
> >>>> Right. I assumed this is implicitly handled by the optimization in c=
ollapse_scan_pmd:
> >>>>
> >>>>          if (enabled_orders !=3D BIT(HPAGE_PMD_ORDER))
> >>>>                  max_ptes_none =3D KHUGEPAGED_MAX_PTES_LIMIT;
> >>>>
> >>>> But we perform the check a second time.
> >>>>
> >>>>>
> >>>>> nr_occupied_ptes >=3D nr_ptes - max_ptes_none
> >>>>>
> >>>>> So max_ptes_none=3D0 + 511 present PTEs + one allowed swap PTE won'=
t even
> >>>>> call collapse_huge_page() for PMD order.
> >>>>>
> >>>>> Shouldn't we account for them in the PMD-order check? Something lik=
e:
> >>>>>
> >>>>> if (is_pmd_order(order))
> >>>>>        nr_occupied_ptes +=3D unmapped;
> >>>
> >>> This solution seems good for a temporary fixup. but longterm we may
> >>> want something else. I'm still not sure how we plan on supporting
> >>> swapin without causing creep. So I'd be ok with adding a fix for
> >>> legacy PMD behavior until we know how to handle mTHP creep correctly.
> >>>
> >>>> As an alternative, we could either 1) skip the check there for
> >>>> pmd order (as the check was already done); or 2) introduce+maintain
> >>>> a bitmap that tracks non-present PTEs.
> >>>>
> >>>> @@ -1475,7 +1477,9 @@ static enum scan_result mthp_collapse(struct m=
m_struct *mm,
> >>>>                  nr_occupied_ptes =3D bitmap_weight_from(cc->mthp_pr=
esent_ptes, offset,
> >>>>                                                        offset + nr_p=
tes);
> >>>>
> >>>> -               if (nr_occupied_ptes >=3D nr_ptes - max_ptes_none) {
> >>>> +               /* Check was already done in the caller. */
> >>>> +               if (is_pmd_order(order) ||
> >>>> +                   nr_occupied_ptes >=3D nr_ptes - max_ptes_none) {
> >>>>                          enum scan_result ret;
> >>>>
> >>>>                          collapse_address =3D address + offset * PAG=
E_SIZE;
> >>>>
> >>>> 2) would probably be cleanest long-term.
> >>>
> >>> That would be best for future swapin support in mTHP, but I still
> >>> don't think it solves the creep issue.
> >>
> >> It wouldn't, we'd simply maintain the state we collect + rely on in se=
parate
> >> bitmaps. On swapin, we'd have to update/refresh bitmaps I guess.
> >
> > Yeah, I'm saying for the future, it obviously solves this issue here
> > as well, but if we have positional tracking of the swapout, shared,
> > and none PTEs, I think we can use this to determine whether the
> > collapse would lead to creep. If we detect creep would happen it may
> > be best to automatically collapse to the N+1 (or greater) candidate.
> > Just thinking outloud here.
> >
> >>
> >>> Perhaps we could combine the
> >>> two bitmaps to determine if it would make the future collapse eligibl=
e
> >>> again? Not sure but ill start thinking about it.
> >>>
> >>> Should I send a fixup for this using Lance's solution? Or does Lance
> >>> want to send a patch out with the fixes tag?
> >>
> >> If Lance could send a fixup, explaining the situation, that would be n=
ice.
>
> Sure, happy to send a fixup :P
>
> Should I send it as a fixup to be folded into this patch, or as a
> separate patch with a Fixes: tag?

Id assume a seperate patch so you can keep credit for the discovery :)

Thank you for all the review you provided on this series, its been
really helpful!

-- Nico

>
> Will get one out soon :)
>
> > OK, I'd appreciate that :)
>
> Cheers!
>


