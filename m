Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92AE5C55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770976B0093; Mon,  3 Aug 2026 15:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7472B6B0095; Mon,  3 Aug 2026 15:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637346B0096; Mon,  3 Aug 2026 15:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D16C6B0093
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:14:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B02A61A07F8
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:14:04 +0000 (UTC)
X-FDA: 85060908408.05.069A4CB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6DC864000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:14:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V0VLQFIp;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785784442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/pPYy4RtqDllz1NWY+EKpFVQLtXvEhEAFb226eyjbk=;
	b=TRlecJ9eTGg9YfKISvPaKnQlPQuQUcJCrOCuN1Lmz/xC5Yr9kM/iKCxAk8r6nwL2UNWqG1
	iZV7vrVcx6HmXslCR6AqY0gbZkDTAuy3t6+i2oPmY13YkqP1dPoU0wLYb/IDn9+o4uCxuI
	548qrtxSguaBqAALunWozYUXXyYJXAc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785784442;
	b=1odTEDdjQk3JWpn65BCgn7Mf9DMPEQjE2b4ajd0qHoRPO6KpVHmtZ102+s77Bf5P4BlXeQ
	4Rzqj5ynBjSIN78sakE9VnZeJUro95+mMKza4mY9L+q3XJ5ZCijBCejBc2r4Ea/ILCgp/l
	Kk+J/Nai916Ren94rTWV7DNQ7RpidMw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V0VLQFIp;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785784441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/pPYy4RtqDllz1NWY+EKpFVQLtXvEhEAFb226eyjbk=;
	b=V0VLQFIp2QSR8JsXvPAReliuRxQkiy6SnYrldZMH1Nv/YKO2e2i84iRynlkj4W7uvXTTIw
	7gu45UKteKo+8CzLgiDGUZqy3Hj7Q4oi9ria7XnoofnTHlW20FNuC/FAdV8BB2DGfJcju6
	EkIhfrEuHx0Bn9auKwxj7SdwcntTlJY=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-uPVEpj72Ns6oScaXpIsTFw-1; Mon, 03 Aug 2026 15:14:00 -0400
X-MC-Unique: uPVEpj72Ns6oScaXpIsTFw-1
X-Mimecast-MFC-AGG-ID: uPVEpj72Ns6oScaXpIsTFw_1785784439
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-39f7feb0bb8so12226271fa.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 12:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785784439; x=1786389239;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X/pPYy4RtqDllz1NWY+EKpFVQLtXvEhEAFb226eyjbk=;
        b=hqN3ElpG9RhqgNfQPqqDS5Lp4jhT5FAgPfBQfzwcHyxGjfWO0WwRkVLSaN21pYlqx4
         dJE8ZPs243Hd2PdQEET5SJ1aGOzhPz319BDUZr3HHs3xbWCB82uhwpFg5T8yqflnuv80
         GquBvz0IkK8Q0hB+ipL5YnxYZHJbUEeKP8BZwAUXSMPkOqkDS+5UB91whqXSX3i0uuu7
         BRYsd1oJd532xvLfnwTR71hAEdG0U4jJajB95OO9dr56OzejBGJzwachlExgBVotR3vG
         8u29Y8+c7rGM0Krwkv82gR8JH+9uXh7s002AxlW6m/0NL+4HM0XcJ4daKggYuSe24GMz
         z/NA==
X-Forwarded-Encrypted: i=1; AHgh+RrBn+T5YW49h8FomGEufd/z/LFpQ802ijdsC6YGrYMIaYkWPVR3DcE2WLE8Vz/eGm5AfW8cdd6rZQ==@kvack.org
X-Gm-Message-State: AOJu0YytefI8KKUWr95EZHkYvuAJNd3dLND7wQ8bOhY/omlZBws3m6TG
	QciGpAVqJ+7JOskCK/zHm0K0xAbYC/ijwzMLXE/mP24sTiO2bAfNPVQ/4OvI1I1NpZr3RiSgiSB
	AIHm8FT758aPgjn8J+UQfdTVPdIAgiPMLB72/yM2IdWDcVEjgEQo1kChXOUz9WSOfSGLBbefJq+
	Y+uFPJGN2APJKrFZBfI60jbZVgrfE=
X-Gm-Gg: AR+sD13ssbcTkJ6CLUfRU5+Mfyew+CFZscDhA3HXlTkMtNNkZ9dC/+Xx3PCpc6lBzIU
	aoSfLv77UzuB+0ULPl/LTxiy7RUIfiVlUjvbSBXwFBG/9SK5uVGRrUhmj4IiSDkY3AY93glG3iI
	IdtfgMSF/2cBq8i+PdKXv6CNZJMGIkJhQ9TC78nyqhQ/XlscGxArlqKSTtQw==
X-Received: by 2002:a2e:a888:0:b0:39f:75e1:9c4d with SMTP id 38308e7fff4ca-39f8644f5d2mr26056171fa.32.1785784439058;
        Mon, 03 Aug 2026 12:13:59 -0700 (PDT)
X-Received: by 2002:a2e:a888:0:b0:39f:75e1:9c4d with SMTP id
 38308e7fff4ca-39f8644f5d2mr26056091fa.32.1785784438664; Mon, 03 Aug 2026
 12:13:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260715025941.1571316-1-npache@redhat.com> <20260715025941.1571316-4-npache@redhat.com>
 <1886019f-62f7-4662-a2b8-07f035fb0a73@kernel.org>
In-Reply-To: <1886019f-62f7-4662-a2b8-07f035fb0a73@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Mon, 3 Aug 2026 13:13:32 -0600
X-Gm-Features: AUfX_mwVzN7oC0K3lC1WSdyLJudNDTY-fBtILqGmGKAWhFWWmsT44hW5fIJvtzY
Message-ID: <CAA1CXcCofU8t_um5K0GWZY8_qOM7VC1tmw5B=Q56fGTAZHZ58A@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] mm/khugepaged: introduce a count_collapse_event() helper
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Usama Arif <usama.arif@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7U9rehhzG_LezHpDNnINkPKhyDQDQqAgtloPrnWkitk_1785784439
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6DC864000C
X-Stat-Signature: tc3we5a6s8keashab34c3cxqrq3t6qej
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785784442-341812
X-HE-Meta: U2FsdGVkX19JyPK+302zWi4AaS36QCtAUM4T6HssP2nBl939i1+DZxV40KvAYLwzcLyLbiGbqzxAl4HkhAgVTowSmoV2pdc5qy9nRKdVFbmO495l63aIYbIys3b9SLtOAhqupcP5D3Hd9NFpv3GyEsGNgc4UrUXMUmzXjHjaG6FJEplJghKw5hfL2k1SIKcs0ZpL+p5u7jhGKkLYD/FStF1N/9+TxqLC61KnizQWKMLtXWcYlkU2Q3DWShKRv9gBZEmicr5hsxwLra01VYUTRP33jm0SOzj6rMDhgEJMfKFxT4XG02U/U6U9I+mB8hC+SEWl9Mct6opOkIVI0virtE9GCPqDQKfANxezQkjPPwJ+xPSOg8gVEqXzBPA2dgfcbQi6rYo8ov7uEW3KyHRGa9ZGueAOzpvXIPgRv+V+Wi2AlfNFkzQZigq11H4KZnANoCRQyzH7THYQ6Ix/NkWFVT0K4Qmp/8LZFq7YPGQxJ4prooZ7jL+T/aWX0TcYFzmuSEt7dzpSBThuXYq1fZ2eTPHHohZuTtsqWfxYD0FOos+sNYCv8olXnJ4SnlFePHhO8Sl6aeAaTHYzCpeRRjLari367HaKv7zSzwsyd8/tKUnhmrZ+xULMTulCK3qPdsshSSRCDjSD7u1m4HF5IPMNDk9wp92Emc1VILuF4N3pTXTsGaScbjkcPkQy9z+Rx3nkO2xjxxdVxyUDWo2WXcfFuemM7UTPqzZ0aXjSbPdoHEvl2wMo4Sr5iT1518R+2DZJCl2oMKo2+Hsl10b1yN7dqtpzqgd3PCNV1OSAcomR2UDgRIbKFu/lkwtlnbv3ZAo6Z8jQFcRrN+Ztdoc/E/QZPppz4mBUGrwKx6FJ8l1QYs8/sZrjrSybs6O5eDw/NjlxubL8ZRRf6JupLSB2nLVkTeUg370IUIf8u2ThN519M6toGnEtcfNk+hVvxUrndbdgCwfJ3Ecnr/xa3ibiKek
 qnDp33Sy
 RcNC5BVcx0y2lmTunotQvxkwv9ugL/4+tfLF7iQWxM/RpkY5tX/H/f5RvtgztfLv2VU9CEidWPPeTnmAARQOo+n5saIpNOKdaaMc8nenxfszQfNgx5FVMmgatpuGx6a49Bf/nK0P7jXyCu/kAHB5AB3/Lrop7OTsXCFF777qHhpeS/Ykz0a8hGgfzHHejozFnpj8HnXBo40wa1fpzgQPuxa0un2aIg3BNBeDutuPuE/qCIMvLiR2KhWeECtniqqqPdrxhwZq0HTmCgbcmhuhy94ahxys2zq+gPooSfglwOOjB8VNxJi0l+Za2/1nO5Ioj5i+rC1Nj/2uCY6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 3:43=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 7/15/26 04:59, Nico Pache wrote:
> > Provide a simple helper function to help reduce a often used, and
> > duplicate pattern across the khugepaged code.
> >
> > When collapsing to a PMD we need to record a vm_event and the mTHP_stat
> > event. When doing mTHP collapse we only update the mTHP stat.
> >
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Acked-by: Usama Arif <usama.arif@linux.dev>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 36 ++++++++++++++++++------------------
> >  1 file changed, 18 insertions(+), 18 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index e92e2b928f17..f65bbe2051b3 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -689,6 +689,14 @@ static inline bool collapse_is_referenced(struct c=
ollapse_control *cc, pte_t pte
> >               mmu_notifier_test_young(vma->vm_mm, addr));
> >  }
> >
> > +static void count_collapse_event(unsigned int order, enum vm_event_ite=
m vm_event,
> > +             enum mthp_stat_item mthp_event)
> > +{
> > +     if (is_pmd_order(order))
> > +             count_vm_event(vm_event);
> > +     count_mthp_stat(order, mthp_event);
> > +}
> > +
> >  static enum scan_result __collapse_huge_page_isolate(struct vm_area_st=
ruct *vma,
> >               unsigned long start_addr, pte_t *pte, struct collapse_con=
trol *cc,
> >               unsigned int order, struct list_head *compound_pagelist)
> > @@ -709,9 +717,8 @@ static enum scan_result __collapse_huge_page_isolat=
e(struct vm_area_struct *vma,
> >               if (pte_none_or_zero(pteval)) {
> >                       if (++none_or_zero > max_ptes_none) {
> >                               result =3D SCAN_EXCEED_NONE_PTE;
> > -                             if (is_pmd_order(order))
> > -                                     count_vm_event(THP_SCAN_EXCEED_NO=
NE_PTE);
> > -                             count_mthp_stat(order, MTHP_STAT_COLLAPSE=
_EXCEED_NONE);
> > +                             count_collapse_event(order, THP_SCAN_EXCE=
ED_NONE_PTE,
> > +                                             MTHP_STAT_COLLAPSE_EXCEED=
_NONE);
>
> That's not how we indent parameters here. Unless my mail client displays =
it in a
> weird way (doubt).
>
> Same applies to all other cases.
>
> Apart from that LGTM.

Ok sounds good I'll get those fixed and send a new version soon.

>
> --
> Cheers,
>
> David
>


