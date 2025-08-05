Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B66C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 348746B0089; Tue,  5 Aug 2025 10:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 320B36B0099; Tue,  5 Aug 2025 10:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20F516B009A; Tue,  5 Aug 2025 10:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6836B0089
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:39:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B234380144
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:39:35 +0000 (UTC)
X-FDA: 83742962310.01.402B2E8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 44DD6100010
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:39:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="NP9PEN/2";
	spf=pass (imf05.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754404773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=osBUTD8AGmf3RzRhZE1d3AllWvZV7FgrCRdQPsKZtns=;
	b=bgMRCu9YgEn2hpgE05x2lhinZpk8vV28rsB24P8/L+p3nLXDtYpfAJfZhr07HWo9XZNmfu
	a9+RxBvHqxE8uhQdm5G7OMa4sg2ON5EPnd2rG0xQOCQox+Xh4Jl/ATcQsxXnef2vMhUDoS
	VeG7yRSpqqOqA0TGlotyzNI2deY+PPw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="NP9PEN/2";
	spf=pass (imf05.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754404773; a=rsa-sha256;
	cv=none;
	b=b2RCE4omaKzV6ZXbRu34Px8+E5FjtMlSxF3Zna1MCkgJHbBHQNkyVK9v9Znz++10vU+Jgh
	h/POwOAiA6nZ9W0I035/x2SLVSWwA7iTg/fMDXGuAil6xC3W4RSL6PxmDmiJ15e7SbIPuj
	B3MSp9xVPWSNm30MWdHJF4iJ/0emKdM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754404772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=osBUTD8AGmf3RzRhZE1d3AllWvZV7FgrCRdQPsKZtns=;
	b=NP9PEN/2+/7KzXrZ2huQsA67rTELw1YNg688keMW4zEE9BPFYI/cTXJtYjQBpCYMCew94V
	yKMO8kgdc1R+8SCF7nvVhfHRY/8O5r/fSb148Qe/N9lt1mlgwQAtSX50lJvABjuGSn9Yov
	EWraNa8nJMLQBLmphj9tydCuWrGP1AI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-swexPOpIPYG6DjzquOvGTg-1; Tue, 05 Aug 2025 10:39:31 -0400
X-MC-Unique: swexPOpIPYG6DjzquOvGTg-1
X-Mimecast-MFC-AGG-ID: swexPOpIPYG6DjzquOvGTg_1754404771
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4b08b271095so7344131cf.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:39:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754404771; x=1755009571;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=osBUTD8AGmf3RzRhZE1d3AllWvZV7FgrCRdQPsKZtns=;
        b=Vr/bJF3SlhEzxjo1zCRqFONv6s5NChND2Yoqvxi7dZqUuqa5yHyVQENse5wcweW9L5
         Q5sxU+OaRUFH6TtaqyM+KBUB4IyXYy6JV8HddCC6fqqkHblop7CrJ51aP/QTxE61yyIE
         n3ejCsk1JduV7PhJEfMrFASJBe2h/5RmVRaAHrhJLf1tdW/HrmoPeUmeCr474nQdc2sd
         PG1myWoi9PzAef/E0rtH6ggDZ1yFr18U9xCC2eBF3Ur3idJzTjVJ5GfoSXl3FBx8/BC1
         FEgF1T9b8sGX6FTORZUrqsNwD0ms2ne0NZM60G69s1iuN2f7vOGxXYXb8XOKtOkz4kEV
         AfsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFf6PxkBewMLT7avCwuolOZMdkKqqfjMKrL0VpKQ4htJH4LmpcgUKliwVMBjjckCSP7GKcKzzE6A==@kvack.org
X-Gm-Message-State: AOJu0YydxSOEEDFJjhhnObbwbKbHRUBdpdIuR0yp0NQEFa1M24GdenbH
	OlvdMdsiotbiBxEML1+bqO7Ww4iHlqj1E8eeLX1OIIQgYd+sXltU1p3N7B+W5AZDIna3AHlbSvs
	QTETgduMT1jfXfM8wb+tKYYmkXs9nZ7hp5Q9fyk2lZDWdAG5+YOn+
X-Gm-Gg: ASbGncswk0ZJ0jdfoHslDbQLWf6nn2ofbwXDL7HEjcq0SXVqu5J5rg3tDmhYu3J3jj9
	Un7kJ4Q2neRQHM9MwQHszBU7NwqwrwbGYA5G8UbpocZECos898DhiLwZtbH4vGVMh0DumOe8wW4
	oCiw3WaJxSD7b+HRQ610j3/S6KoeyHawxOvOYxNE//ntS80/TyZ1ksgv3Ux7VqNLTA70EsPrs5J
	MkzX8l8i0P7aj2PFsuF9TXgoYT9kPjiIqbuaaF6MiBA06N6cv19uTgB42M6wSE/sqDLP8G6DDAJ
	1kNDE+HQVXv+xi6T9q0+O4l5msrjh96I
X-Received: by 2002:a05:622a:341:b0:4b0:7372:1bcb with SMTP id d75a77b69052e-4b073722829mr97740991cf.15.1754404770522;
        Tue, 05 Aug 2025 07:39:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbzW4UiXSJV9RVR64B6UcBQaLqjWbfSx5kR9/jhgtO/J/1mSovc/gLubrthIt8BIT18R/6Yw==
X-Received: by 2002:a05:622a:341:b0:4b0:7372:1bcb with SMTP id d75a77b69052e-4b073722829mr97740261cf.15.1754404769737;
        Tue, 05 Aug 2025 07:39:29 -0700 (PDT)
Received: from x1.local ([174.89.135.171])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f5c55a2sm685723885a.36.2025.08.05.07.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 07:39:28 -0700 (PDT)
Date: Tue, 5 Aug 2025 10:39:16 -0400
From: Peter Xu <peterx@redhat.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
	aarcange@redhat.com, lokeshgidra@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
Message-ID: <aJIXlN-ZD_soWdP0@x1.local>
References: <aIzMGlrR1SL5Y_Gp@x1.local>
 <CAJuCfpEqOUj8VPybstQjoJvCzyZtG6Q5Vr4WT0Lx_r3LFVS7og@mail.gmail.com>
 <aIzp6WqdzhomPhhf@x1.local>
 <CAJuCfpGWLnu+r2wvY2Egy2ESPD=tAVvfVvAKXUv1b+Z0hweeJg@mail.gmail.com>
 <aIz1xrzBc2Spa2OH@x1.local>
 <CAJuCfpFJGaDaFyNLa3JsVh19NWLGNGo1ebC_ijGTgPGNyfUFig@mail.gmail.com>
 <aI0Ffc9WXeU2X71O@x1.local>
 <CAJuCfpFSY3fDH36dabS=nGzasZJ6FtQ_jv79eFWVZrEWRMMTiQ@mail.gmail.com>
 <aI1ckD3KhNvoMtlv@x1.local>
 <CAJuCfpHcScutgGi3imYTJVXBqs=jcqZ5CkKKe=sfVHjUg0Y6RQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJuCfpHcScutgGi3imYTJVXBqs=jcqZ5CkKKe=sfVHjUg0Y6RQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hFqAKTca-GdSFIW-8aV9C-gWRDmbBtJ4zW8cH-f6Xlw_1754404771
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 44DD6100010
X-Rspamd-Server: rspam06
X-Stat-Signature: 1jn7wchhihfq7ubupgu3q8xj99ko9zne
X-HE-Tag: 1754404773-76081
X-HE-Meta: U2FsdGVkX1+6LFpXOqRrXQD8QYEzhHard1xLqXkOYGi+eEXCvBQX6lgGlUXI1ie6bAPSS7htbcMfMa4LbvpX/prKf2xCzU4X68QNxBivk6Fw2pObxNOZkDNI6nE239CUCmRdzzqRhrTGoeKG5rVqTbTRUnOGydZ1g/C+WjNFzzxWRxhiMA6DOFfZ5EnbeyoD3VUL7rj7f3nyZ28E/QtCq3S854sVeREIdq9FaA7uwitlP9LuGPHlP7VP4HNsZPLZhg+8UGWMcDZGD97/2eQwk2+H2FB0fAC5eIlUx4FA9ExkyYWQpmOdCk0G/p4C7b6l2UU1cqZj60oMvZzZd/ukRfdUbCO95UE0NR4BqGl2bcdmPANWYPIOkMFh3SK7ox/8yRjiGli+09LIxXJrzZCaATqZEX01B6PQpGZHgSP+6NwmyAsgl2duUW9CqukhJ/r/MNEUDTTIZPGIQvXK9/VRX5gWTuZuvMWfrIIgzM6XxUolMb6VoNdPUrk2K/Gl4XhszBNQ5IYR/tZ7PbSclJ9pmtvkffeE5F6Z8wCWGOjm0Ra3yiVl4ZwFBgOMIRrc1Fw+DoRGmKCVGsEf3Pd6MQWK8ra148EBUJzcuQLY6ujJQHO7jjE8KcQM5MOSdctCPtj0xgbUXdI+DcoLUnMYF/GGE2KSn7Qf4Qf8uHgn7nbNQnKuU2Xs6+HgVX3dkx2ulYyD9t0uPhh7CVfHovZR5ZU3KfuxtEoi79wTjF2nkszAamwvnkSh5WWYbVQrKHdXbhFbY9IjOual9qAHk62KEdCUcnvqoE27QpZDGZnS6WvYtBf0+keSt6/yWL8ZMw5V5DljW5nz8b9pOIw24AMBi23EsjiQbi1Ol3zLr6MtCBVyG4A6aDr/+K1jtj41cASk2XWdUT545KCoFnNuX6ek1KJge4iLm0cizRtPow7FQktrIRkbGH0PA5s/+FNXaKBWtb6qF3t6VgrftTdrnUU7SaD
 lTwqGI1L
 jH+n8oTP+9sJCCtQu4IRX75FAuBJzhczQ9DbBKkOhcV/qXen6QzmzM5w1Icz1SMsCJgzNY3ZTOBz8hJczc7Xo+G+FA8uzZTgQQCiifFUSse6e7YzKqEcDu00jsEWxpmlNllFQSQ8BR6W0iTppMim2+k82iFERDjyGipKsovPgvSyLuicErl5GX8+CKMq33EAd0uPv7l118kpR0W1R+iHCY0XiVae5be/DBvKsd6Jpl1/6R/A2HdEsM3nelsLSlH2SEwwOhHeebaxgdwhvsIy88bXqyUb3N99yVnRyMVaUMdIaJvYWGOyIqXR7sUWTtFad3dVGJkq1v3ReV8YvTx9qAxcaXFVfAGISmx0alBJVCkV/AnICIZNdcLpBXha4ILjzOY3QzjEKeoz3P49r7dvXZswJL/k9Njt6rc4zETaxY5fAUl1/NszWX1NuygVa/gf4tiSPX2XSsqaIe5/Qibyg8vZfSJZbUmm7qqH3guQzshl20cPOb7pNsxezcOyUqNZkO7LrJwl7/smNJ30Spfxmaw+LL619ccIOV0Yf74+lxuy8yONkFbeB9kj+/1mhL3G2sR5QzL1qck7QyS/QXSo5xrcdcbHDwLzq4yaJnp1V5eXRaAUJdwmA6mUX2sKN1Ut6JM3UmWMnRZXjLKjtkprmcSek6k00dkKOP//7iohzkEJFtK2zPzU90yzsRxZxMdStAluWlaDGdkGMZ8jJfPoVNjv5vu6/WTb3QIZyAkQB9yoIDELc9xT3yef5zqn833VTG5nIJTQ93UVVzpXvBG8QTho5tQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 07:55:42AM -0700, Suren Baghdasaryan wrote:
> On Fri, Aug 1, 2025 at 5:32 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Fri, Aug 01, 2025 at 07:30:02PM +0000, Suren Baghdasaryan wrote:
> > > On Fri, Aug 1, 2025 at 6:21 PM Peter Xu <peterx@redhat.com> wrote:
> > > >
> > > > On Fri, Aug 01, 2025 at 05:45:10PM +0000, Suren Baghdasaryan wrote:
> > > > > On Fri, Aug 1, 2025 at 5:13 PM Peter Xu <peterx@redhat.com> wrote:
> > > > > >
> > > > > > On Fri, Aug 01, 2025 at 09:41:31AM -0700, Suren Baghdasaryan wrote:
> > > > > > > On Fri, Aug 1, 2025 at 9:23 AM Peter Xu <peterx@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Fri, Aug 01, 2025 at 08:28:38AM -0700, Suren Baghdasaryan wrote:
> > > > > > > > > On Fri, Aug 1, 2025 at 7:16 AM Peter Xu <peterx@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Fri, Aug 01, 2025 at 09:21:30AM +0200, David Hildenbrand wrote:
> > > > > > > > > > > On 31.07.25 17:44, Suren Baghdasaryan wrote:
> > > > > > > > > > >
> > > > > > > > > > > Hi!
> > > > > > > > > > >
> > > > > > > > > > > Did you mean in you patch description:
> > > > > > > > > > >
> > > > > > > > > > > "userfaultfd: fix a crash in UFFDIO_MOVE with some non-present PMDs"
> > > > > > > > > > >
> > > > > > > > > > > Talking about THP holes is very very confusing.
> > > > > > > > > > >
> > > > > > > > > > > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
> > > > > > > > > > > > encounters a non-present THP, it fails to properly recognize an unmapped
> > > > > > > > > > >
> > > > > > > > > > > You mean a "non-present PMD that is not a migration entry".
> > > > > > > > > > >
> > > > > > > > > > > > hole and tries to access a non-existent folio, resulting in
> > > > > > > > > > > > a crash. Add a check to skip non-present THPs.
> > > > > > > > > > >
> > > > > > > > > > > That makes sense. The code we have after this patch is rather complicated
> > > > > > > > > > > and hard to read.
> > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > > > > > > > > > > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> > > > > > > > > > > > Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
> > > > > > > > > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > > > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > > > > > > ---
> > > > > > > > > > > > Changes since v1 [1]
> > > > > > > > > > > > - Fixed step size calculation, per Lokesh Gidra
> > > > > > > > > > > > - Added missing check for UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES, per Lokesh Gidra
> > > > > > > > > > > >
> > > > > > > > > > > > [1] https://lore.kernel.org/all/20250730170733.3829267-1-surenb@google.com/
> > > > > > > > > > > >
> > > > > > > > > > > >   mm/userfaultfd.c | 45 +++++++++++++++++++++++++++++----------------
> > > > > > > > > > > >   1 file changed, 29 insertions(+), 16 deletions(-)
> > > > > > > > > > > >
> > > > > > > > > > > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > > > > > > > > > > index cbed91b09640..b5af31c22731 100644
> > > > > > > > > > > > --- a/mm/userfaultfd.c
> > > > > > > > > > > > +++ b/mm/userfaultfd.c
> > > > > > > > > > > > @@ -1818,28 +1818,41 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
> > > > > > > > > > > >             ptl = pmd_trans_huge_lock(src_pmd, src_vma);
> > > > > > > > > > > >             if (ptl) {
> > > > > > > > > > > > -                   /* Check if we can move the pmd without splitting it. */
> > > > > > > > > > > > -                   if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> > > > > > > > > > > > -                       !pmd_none(dst_pmdval)) {
> > > > > > > > > > > > -                           struct folio *folio = pmd_folio(*src_pmd);
> > > > > > > > > > > > +                   if (pmd_present(*src_pmd) || is_pmd_migration_entry(*src_pmd)) {
> > > > > > > > > >
> > > > > > > > > > [1]
> > > > > > > > > >
> > > > > > > > > > > > +                           /* Check if we can move the pmd without splitting it. */
> > > > > > > > > > > > +                           if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> > > > > > > > > > > > +                               !pmd_none(dst_pmdval)) {
> > > > > > > > > > > > +                                   if (pmd_present(*src_pmd)) {
> > > > > > > >
> > > > > > > > [2]
> > > > > > > >
> > > > > > > > > > > > +                                           struct folio *folio = pmd_folio(*src_pmd);
> > > > > > > >
> > > > > > > > [3]
> > > > > > > >
> > > > > > > > > > > > +
> > > > > > > > > > > > +                                           if (!folio || (!is_huge_zero_folio(folio) &&
> > > > > > > > > > > > +                                                          !PageAnonExclusive(&folio->page))) {
> > > > > > > > > > > > +                                                   spin_unlock(ptl);
> > > > > > > > > > > > +                                                   err = -EBUSY;
> > > > > > > > > > > > +                                                   break;
> > > > > > > > > > > > +                                           }
> > > > > > > > > > > > +                                   }
> > > > > > > > > > >
> > > > > > > > > > > ... in particular that. Is there some way to make this code simpler / easier
> > > > > > > > > > > to read? Like moving that whole last folio-check thingy into a helper?
> > > > > > > > > >
> > > > > > > > > > One question might be relevant is, whether the check above [1] can be
> > > > > > > > > > dropped.
> > > > > > > > > >
> > > > > > > > > > The thing is __pmd_trans_huge_lock() does double check the pmd to be !none
> > > > > > > > > > before returning the ptl.  I didn't follow closely on the recent changes on
> > > > > > > > > > mm side on possible new pmd swap entries, if migration is the only possible
> > > > > > > > > > one then it looks like [1] can be avoided.
> > > > > > > > >
> > > > > > > > > Hi Peter,
> > > > > > > > > is_swap_pmd() check in __pmd_trans_huge_lock() allows for (!pmd_none()
> > > > > > > > > && !pmd_present()) PMD to pass and that's when this crash is hit.
> > > > > > > >
> > > > > > > > First for all, thanks for looking into the issue with Lokesh; I am still
> > > > > > > > catching up with emails after taking weeks off.
> > > > > > > >
> > > > > > > > I didn't yet read into the syzbot report, but I thought the bug was about
> > > > > > > > referencing the folio on top of a swap entry after reading your current
> > > > > > > > patch, which has:
> > > > > > > >
> > > > > > > >         if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> > > > > > > >             !pmd_none(dst_pmdval)) {
> > > > > > > >                 struct folio *folio = pmd_folio(*src_pmd); <----
> > > > > > > >
> > > > > > > > Here looks like *src_pmd can be a migration entry. Is my understanding
> > > > > > > > correct?
> > > > > > >
> > > > > > > Correct.
> > > > > > >
> > > > > > > >
> > > > > > > > > If we drop the check at [1] then the path that takes us to
> > > > > > > >
> > > > > > > > If my above understanding is correct, IMHO it should be [2] above that
> > > > > > > > makes sure the reference won't happen on a swap entry, not necessarily [1]?
> > > > > > >
> > > > > > > Yes, in case of migration entry this is what protects us.
> > > > > > >
> > > > > > > >
> > > > > > > > > split_huge_pmd() will bail out inside split_huge_pmd_locked() with no
> > > > > > > > > indication that split did not happen. Afterwards we will retry
> > > > > > > >
> > > > > > > > So we're talking about the case where it's a swap pmd entry, right?
> > > > > > >
> > > > > > > Hmm, my understanding is that it's being treated as a swap entry but
> > > > > > > in reality is not. I thought THPs are always split before they get
> > > > > > > swapped, no?
> > > > > >
> > > > > > Yes they should be split, afaiu.
> > > > > >
> > > > > > >
> > > > > > > > Could you elaborate why the split would fail?
> > > > > > >
> > > > > > > Just looking at the code, split_huge_pmd_locked() checks for
> > > > > > > (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd)).
> > > > > > > pmd_trans_huge() is false if !pmd_present() and it's not a migration
> > > > > > > entry, so __split_huge_pmd_locked() will be skipped.
> > > > > >
> > > > > > Here might be the major part of where confusion came from: I thought it
> > > > > > must be a migration pmd entry to hit the issue, so it's not?
> > > > > >
> > > > > > I checked the code just now:
> > > > > >
> > > > > > __handle_mm_fault:
> > > > > >                 if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
> > > > > >                         VM_BUG_ON(thp_migration_supported() &&
> > > > > >                                           !is_pmd_migration_entry(vmf.orig_pmd));
> > > > > >
> > > > > > So IIUC pmd migration entry is still the only possible way to have a swap
> > > > > > entry.  It doesn't look like we have "real" swap entries for PMD (which can
> > > > > > further points to some swapfiles)?
> > > > >
> > > > > Correct. AFAIU here we stumble on a pmd entry which was allocated but
> > > > > never populated.
> > > >
> > > > Do you mean a pmd_none()?
> > >
> > > Yes.
> > >
> > > >
> > > > If so, that goes back to my original question, on why
> > > > __pmd_trans_huge_lock() returns non-NULL if it's a pmd_none()?  IMHO it
> > > > really should have returned NULL for pmd_none().
> > >
> > > That was exactly the answer I gave Lokesh when he theorized about the
> > > cause of this crash but after reproducing it I saw that
> > > pmd_trans_huge_lock() happily returns the PTL as long as PMD is not
> > > pmd_none(). And that's because it passes as is_swap_pmd(). But even if
> > > we change that we still need to implement the code to skip the entire
> > > PMD.
> >
> > The thing is I thought if pmd_trans_huge_lock() can return non-NULL, it
> > must be either a migration entry or a present THP. So are you describing a
> > THP but with present bit cleared?  Do you know what is that entry, and why
> > it has present bit cleared?
> 
> In this case it's because earlier we allocated that PMD here:
> https://elixir.bootlin.com/linux/v6.16/source/mm/userfaultfd.c#L1797

AFAIU, this line is not about allocation of any pmd entry, but the pmd
pgtable page that _holds_ the PMDs:

static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
{
	return (unlikely(pud_none(*pud)) && __pmd_alloc(mm, pud, address))?
		NULL: pmd_offset(pud, address);
}

It makes sure the PUD entry, not the PMD entry, be populated.

> but wouldn't that be the same if the PMD was mapped and then got
> unmapped later? My understanding is that we allocate the PMD at the
> line I pointed to make UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES case the same
> as this unmapped PMD case. If my assumption is incorrect then we could
> skip the hole earlier instead of allocating the PMD for it.
> 
> >
> > I think my attention got attracted to pmd migration entry too much, so I
> > didn't really notice such possibility, as I believe migration pmd is broken
> > already in this path.
> >
> > The original code:
> >
> >                 ptl = pmd_trans_huge_lock(src_pmd, src_vma);
> >                 if (ptl) {
> >                         /* Check if we can move the pmd without splitting it. */
> >                         if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> >                             !pmd_none(dst_pmdval)) {
> >                                 struct folio *folio = pmd_folio(*src_pmd);
> >
> >                                 if (!folio || (!is_huge_zero_folio(folio) &&
> >                                                !PageAnonExclusive(&folio->page))) {
> >                                         spin_unlock(ptl);
> >                                         err = -EBUSY;
> >                                         break;
> >                                 }
> >
> >                                 spin_unlock(ptl);
> >                                 split_huge_pmd(src_vma, src_pmd, src_addr);
> >                                 /* The folio will be split by move_pages_pte() */
> >                                 continue;
> >                         }
> >
> >                         err = move_pages_huge_pmd(mm, dst_pmd, src_pmd,
> >                                                   dst_pmdval, dst_vma, src_vma,
> >                                                   dst_addr, src_addr);
> >                         step_size = HPAGE_PMD_SIZE;
> >                 } else {
> >
> > It'll get ptl for a migration pmd, then pmd_folio is risky without checking
> > present bit.  That's what my previous smaller patch wanted to fix.
> >
> > But besides that, IIUC it's all fine at least for a pmd migration entry,
> > because when with the smaller patch applied, either we'll try to split the
> > pmd migration entry, or we'll do move_pages_huge_pmd(), which internally
> > handles the pmd migration entry too by waiting on it:
> >
> >         if (!pmd_trans_huge(src_pmdval)) {
> >                 spin_unlock(src_ptl);
> >                 if (is_pmd_migration_entry(src_pmdval)) {
> >                         pmd_migration_entry_wait(mm, &src_pmdval);
> >                         return -EAGAIN;
> >                 }
> >                 return -ENOENT;
> >         }
> >
> > Then logically after the migration entry got recovered, we'll either see a
> > real THP or pmd none next time.
> 
> Yes, for migration entries adding the "if (pmd_present(*src_pmd))"
> before getting the folio is enough. The problematic case is
> (!pmd_none(*src_pmd) && !pmd_present(*src_pmd)) and not a migration
> entry.

I thought we could have any of below here on the pmd entry:

  (0) pmd_none, which should constantly have pmd_trans_huge_lock -> NULL

  (1) pmd pgtable entry, which must have PRESENT && !TRANS, so
  pmd_trans_huge_lock -> NULL,

  (2) pmd migration, pmd_trans_huge_lock -> valid

  (3) pmd thp, pmd_trans_huge_lock -> valid

I thought (2) was broken, which we seem to agree upon.. however if so the
smaller patch should fix it, per explanation in my previous reply.  OTOH I
can't think of (4).

Said that, I just noticed (3) can be broken as well - could it be a
prot_none entry?  The very confusing part of this patch is it seems to
think it's pmd_none() here as holes:

	if (pmd_present(*src_pmd) || is_pmd_migration_entry(*src_pmd)) {
                ...
	} else {
		spin_unlock(ptl);
		if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES)) {
			err = -ENOENT;
			break;
		}
		/* nothing to do to move a hole */
		err = 0;
		step_size = min(HPAGE_PMD_SIZE, src_start + len - src_addr);
	}

But is it really?  Again, I don't think pmd_none() could happen with
pmd_trans_huge_lock() returning the ptl.

Could you double check this?  E.g. with this line if that makes sense to
you:

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 8bf8ff0be990f..d2d4f2a0ae69f 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1903,6 +1903,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
                                                          dst_addr, src_addr);
                                step_size = HPAGE_PMD_SIZE;
                        } else {
+                               BUG_ON(!pmd_none(*src_pmd));
                                spin_unlock(ptl);
                                if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES)) {
                                        err = -ENOENT;

I would expect it constantly BUG() here, if that explains my thoughts.

Now I doubt it's a prot_none THP.. aka, a THP that got numa hint to be
moved.  If so, we may need to process it / move it / .. but we likely
should never skip it.  We can double check the buggy pmd entry you hit
(besides migration entry) first.

Thanks,

-- 
Peter Xu


