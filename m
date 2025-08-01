Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB8A5C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 18:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211316B0088; Fri,  1 Aug 2025 14:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7B46B0089; Fri,  1 Aug 2025 14:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FDA46B008A; Fri,  1 Aug 2025 14:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0385A6B0088
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:21:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5724B586E0
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 18:21:10 +0000 (UTC)
X-FDA: 83729005500.29.B4603EE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id ECEAA140002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 18:21:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KTCKRyCz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754072468; a=rsa-sha256;
	cv=none;
	b=4I7WB0XPJ1Sagsp8KlEBEBgAY2moZ1w7CAnLmnab36rnz2NFNiRJc2GjJ4hM5HVi4viVkX
	rzlG7Gt5jjHHzBXCC6nkVqOzD34WiOaNRNyZxLAAIhzl7KM9KmjSiA4X08GDPY8VEUEgZ1
	pIm02TA4LmgBrsQpCPNs9FznxO08+0Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KTCKRyCz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754072468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2g39l8sL+vMNhyKGrd5r0iuwpLk0Okh6OkF+13JKUXU=;
	b=M4sCChHp/3PucxHFkMbPhhHZV86jJGB5hTlfhU8yve6qHHpIt4Cbz9MBK6y8lWnHzsMerJ
	DVq43GNMvXiJW3Rf6W/mNStyL18GCHx4XMYA5vNSFcAmcy/kJfVRbdpDaB+5Orq+8wf7HC
	1YMPDILLiD5tjmHvg9j5lODGXW2S0AQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754072467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2g39l8sL+vMNhyKGrd5r0iuwpLk0Okh6OkF+13JKUXU=;
	b=KTCKRyCzlN2mPP7BCcsqzuh7PbfhshLzlcsciQM0QHHUYihqmAo9wBnMJvbHvEQIUlI23C
	0bRKaRV9fqNTc1N/gyeAmhFqThAudH4vw7xTsZx6c0zPuf/sjXN5e8LPufIt4txJc+YfR5
	TS83s20nvCU7dBUMxQZTE+lM5gkiGOI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-liUKdf6XM7-mLzc8LueWxw-1; Fri, 01 Aug 2025 14:21:06 -0400
X-MC-Unique: liUKdf6XM7-mLzc8LueWxw-1
X-Mimecast-MFC-AGG-ID: liUKdf6XM7-mLzc8LueWxw_1754072466
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6fb5f71b363so24177816d6.2
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 11:21:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754072465; x=1754677265;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2g39l8sL+vMNhyKGrd5r0iuwpLk0Okh6OkF+13JKUXU=;
        b=p+wCb1FRTWrMb0aH69sSDoeZO1JejvZp05ENnC/y/tfS3ljV/jbsjo4jiqai453KE8
         MZtzdtMD5h4Ij1pCybCq9duJe8AtYw7oKornUQzzT0Gg7XdYMrd/Jytk8MZoMGZZeXJ6
         YvVVqRQwuIbeCkZDBAqkVu/WktZBfLHpBVYFgjKLEJHmlV0BBxHEXSesX4PSnCOsjsiS
         VvucDRwimsyoPat0fP1Jjw8aiOBHXo54k72ayFC9DTRx6LpDGpN0Re4TRY432CqkTiWE
         bL0LyWve5PmFybTMXvLOq5WfjV3/Z8VRZwXiorvA93150GnDFFX8HhXB5+XLQ5/6B7BM
         I4wg==
X-Forwarded-Encrypted: i=1; AJvYcCVIUS9nmCcY+HtEuI4H02Mb7w7fHlQ0m6JNCN9GpzApQu+K9lv+SpnPoyLNM396DEgH3yyNIDVJMQ==@kvack.org
X-Gm-Message-State: AOJu0YzCILtVWKMJw7gMZmDbgKqpW557MeJ+6K7IZ6OpPmE74Bj8qfYD
	ELfzDZziLxnegrTTlc9N6kciSS30x7Y4XpAFlCKXq7K9+uKhGvomgw2h3E8ZAq2n62/csIPZuKv
	QFK9MM5uMMQnV/vf7E3we3mR7Ss04AO/0d6YmZw8k/9TzJ9TPhGae
X-Gm-Gg: ASbGncsLqLNvUMa20QtrZ3K6x5sqF36bVqjv2CPMgWnRP3xePNj3c8xh+0O6D6+2z3j
	wjCOXTkRafHuVtr6M/Yu33uNMWhQd6hHu6vNAikHrVVqdHrw+ZR5Kw7NzssXqDoB+w7hBSeRoAW
	udiYJxtp1JvgouZ5NtGXiUfk5gg27nO1j4zWu31/KpYG/3nWVs75qHSmwr+oMAviTs2YkQU2Fnd
	1TReKhYhl4z3QNPAWxUUeyDjHPU9oxwgcQneAMaDGSvpQWAAUEJBgDYLWg/yR3TS8Glmp6MM5Bd
	nDMPuC66T58y+QFgmmKboeUSD4rjBJ+E
X-Received: by 2002:ad4:5e88:0:b0:707:5ccb:6c4 with SMTP id 6a1803df08f44-7093633522bmr10005806d6.49.1754072465229;
        Fri, 01 Aug 2025 11:21:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJHvaY504H4W8dqLVRQkrI3AZzsoZBUQlKebveXmIXu7VcAHN9hG/HeWlxIkI0yMFKMrPIQA==
X-Received: by 2002:ad4:5e88:0:b0:707:5ccb:6c4 with SMTP id 6a1803df08f44-7093633522bmr10005226d6.49.1754072464631;
        Fri, 01 Aug 2025 11:21:04 -0700 (PDT)
Received: from x1.local ([174.89.135.171])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4aeeed62d1fsm22935171cf.41.2025.08.01.11.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 11:21:04 -0700 (PDT)
Date: Fri, 1 Aug 2025 14:20:45 -0400
From: Peter Xu <peterx@redhat.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
	aarcange@redhat.com, lokeshgidra@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
Message-ID: <aI0Ffc9WXeU2X71O@x1.local>
References: <20250731154442.319568-1-surenb@google.com>
 <d2b6be85-44d5-4a87-bfe5-4a9e80f95bb8@redhat.com>
 <aIzMGlrR1SL5Y_Gp@x1.local>
 <CAJuCfpEqOUj8VPybstQjoJvCzyZtG6Q5Vr4WT0Lx_r3LFVS7og@mail.gmail.com>
 <aIzp6WqdzhomPhhf@x1.local>
 <CAJuCfpGWLnu+r2wvY2Egy2ESPD=tAVvfVvAKXUv1b+Z0hweeJg@mail.gmail.com>
 <aIz1xrzBc2Spa2OH@x1.local>
 <CAJuCfpFJGaDaFyNLa3JsVh19NWLGNGo1ebC_ijGTgPGNyfUFig@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJuCfpFJGaDaFyNLa3JsVh19NWLGNGo1ebC_ijGTgPGNyfUFig@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j68uu6xiD9z3ETcoFCCwmk-Q27XQUDJiBkBq_dLudWo_1754072466
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ECEAA140002
X-Stat-Signature: rdzujy3iawjg8y3w4iaeob9m1n1kggut
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754072467-797265
X-HE-Meta: U2FsdGVkX19GkAVmG5rRrIcaGMZ5Fd+w/a9BIHEHl9WrV+CorZq+ScqLhrzSDxXKANOdHJTbhZZRy76zhAukFXfbwJS5js72Zdccz7XmS7FmkhPG3oZIpxegD3XYD6tnxk/FweKyIwoSGSOr/ZdVLFiYaVNgcKjyMuLPvq0NqQDNoh7Nkc8ayHgkaWBP33uCiJ4a8cklFGC9FnJhd7JTYsPxg8k4uaqzggu3u1+XyjheuqNlQcVZ/N8VqiOnMyNttAo59khE2OIoUqkodEn+yDRoJXxaL4Qk+p4fRPluifTT+9p+kWQNEM6qu64DQARYUVyqhd3Z72XfiYJQJjSVp25wca/SAU+mTKrAhdTvp8yMgyxvXpKoXjQMoDUGPmVCQEbN1/yftMX2xiAa3475BmXOXg6t54qDNkNC0ZGyvrw/UK6SZjHqrN9Scdzlz3brN8O0/HNBr19mkJ5+uARhmH9hDuG3s2X8bgU3uuxktIrlnz16Np81u3acJQEu7Pf2Lp2/bxceptyy87ywgsXDKuR+OOOgcJ+EfZeh771Dan9YOT7V1PXaERwmP/XmXOOwNTVe/yNT7cyMGqlS6rxWC1GkzZ2PaN8zypdThghUhJDb0zlLF8xDiAcO0BOuaLaJYPfpZAGGQxFMda36GiZ5+K9sLAO/leel+avFSQUSpcmkQENgyaP+A9RwipwTAX3lINUdypbfac2XvCNo1k263VuHBVQmLx0cyJrVjNBbERjsJwtl9EjhbSDZFwA/x+BmXWCpahd2IqSTcDZ6eJX5ti2DnTX/PIsM2XtG9YcUZYYbmTeOr2jEECnCOOrxw2XDXMUc+B/xRG7A7SO8d53SZwQpHLuOufZs86TlH1+tWpkeM0O2XTcLxmvAmDiw6tNVQZcxM/rWJhRLLxIa1EmPnV6aTfuH++nbHUgzEJpOYuF/q5qnYBc7fClTdopDPUzzOySHZgBsVoNt34i8eta
 LmB8r2A1
 yB+yrpCEN+TJGs2hbs3jq1m/KEXbbGx3T4uE3aXrHZcNiJnahs7+eb3P41UirYaQH49ax9thQaxlINUuv4JOCf0rm9xeE7LmWmh3euYC05MmVXFkQ7HSvxDCGJcZ35ueEzu/SZMhFXiAC+L7sGnvoDiTc2Gmd1wZm61tkflB4pt4QDLTV95AfhsNYExKpdkQkujy4WJzX0acg07rvcIDU0knMuMyo+LWvWBwFFSuB85GtC17o1v4aPRBVHQf+j6rAIz4kbs0CnmS+tgblx8OAvPYXCJr20wHxULrwuShuCL9o5x2/qzx5hg4o8lB6PdzwjDMmz4FeVJrpCZGR+i4tv2Rz3u0x55pILMkflB35Z0EcxJI1yEy9HNocMd8ce75hwlq1kT+Um2hXajCY0lIgnSBDBK68/0/mNwc3oBlLcPObjtkKT316HVAlhaBF6//KZyuAjQLCbyEfzac7iBbmFmXzDrCFEizjKqpudXCjYu3vlVM7xBVczG+uI1e8Z584K5bhKTMX14eJce8VSz78KGeMgv4viBNxwHNFqVzlafbka2yO5z92cu8EUmbkG0eZbaG1iNVvp8Y0gAzDKqF1ty6qyigx7SRhsabM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 05:45:10PM +0000, Suren Baghdasaryan wrote:
> On Fri, Aug 1, 2025 at 5:13 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Fri, Aug 01, 2025 at 09:41:31AM -0700, Suren Baghdasaryan wrote:
> > > On Fri, Aug 1, 2025 at 9:23 AM Peter Xu <peterx@redhat.com> wrote:
> > > >
> > > > On Fri, Aug 01, 2025 at 08:28:38AM -0700, Suren Baghdasaryan wrote:
> > > > > On Fri, Aug 1, 2025 at 7:16 AM Peter Xu <peterx@redhat.com> wrote:
> > > > > >
> > > > > > On Fri, Aug 01, 2025 at 09:21:30AM +0200, David Hildenbrand wrote:
> > > > > > > On 31.07.25 17:44, Suren Baghdasaryan wrote:
> > > > > > >
> > > > > > > Hi!
> > > > > > >
> > > > > > > Did you mean in you patch description:
> > > > > > >
> > > > > > > "userfaultfd: fix a crash in UFFDIO_MOVE with some non-present PMDs"
> > > > > > >
> > > > > > > Talking about THP holes is very very confusing.
> > > > > > >
> > > > > > > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
> > > > > > > > encounters a non-present THP, it fails to properly recognize an unmapped
> > > > > > >
> > > > > > > You mean a "non-present PMD that is not a migration entry".
> > > > > > >
> > > > > > > > hole and tries to access a non-existent folio, resulting in
> > > > > > > > a crash. Add a check to skip non-present THPs.
> > > > > > >
> > > > > > > That makes sense. The code we have after this patch is rather complicated
> > > > > > > and hard to read.
> > > > > > >
> > > > > > > >
> > > > > > > > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > > > > > > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> > > > > > > > Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
> > > > > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > > ---
> > > > > > > > Changes since v1 [1]
> > > > > > > > - Fixed step size calculation, per Lokesh Gidra
> > > > > > > > - Added missing check for UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES, per Lokesh Gidra
> > > > > > > >
> > > > > > > > [1] https://lore.kernel.org/all/20250730170733.3829267-1-surenb@google.com/
> > > > > > > >
> > > > > > > >   mm/userfaultfd.c | 45 +++++++++++++++++++++++++++++----------------
> > > > > > > >   1 file changed, 29 insertions(+), 16 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > > > > > > index cbed91b09640..b5af31c22731 100644
> > > > > > > > --- a/mm/userfaultfd.c
> > > > > > > > +++ b/mm/userfaultfd.c
> > > > > > > > @@ -1818,28 +1818,41 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
> > > > > > > >             ptl = pmd_trans_huge_lock(src_pmd, src_vma);
> > > > > > > >             if (ptl) {
> > > > > > > > -                   /* Check if we can move the pmd without splitting it. */
> > > > > > > > -                   if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> > > > > > > > -                       !pmd_none(dst_pmdval)) {
> > > > > > > > -                           struct folio *folio = pmd_folio(*src_pmd);
> > > > > > > > +                   if (pmd_present(*src_pmd) || is_pmd_migration_entry(*src_pmd)) {
> > > > > >
> > > > > > [1]
> > > > > >
> > > > > > > > +                           /* Check if we can move the pmd without splitting it. */
> > > > > > > > +                           if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> > > > > > > > +                               !pmd_none(dst_pmdval)) {
> > > > > > > > +                                   if (pmd_present(*src_pmd)) {
> > > >
> > > > [2]
> > > >
> > > > > > > > +                                           struct folio *folio = pmd_folio(*src_pmd);
> > > >
> > > > [3]
> > > >
> > > > > > > > +
> > > > > > > > +                                           if (!folio || (!is_huge_zero_folio(folio) &&
> > > > > > > > +                                                          !PageAnonExclusive(&folio->page))) {
> > > > > > > > +                                                   spin_unlock(ptl);
> > > > > > > > +                                                   err = -EBUSY;
> > > > > > > > +                                                   break;
> > > > > > > > +                                           }
> > > > > > > > +                                   }
> > > > > > >
> > > > > > > ... in particular that. Is there some way to make this code simpler / easier
> > > > > > > to read? Like moving that whole last folio-check thingy into a helper?
> > > > > >
> > > > > > One question might be relevant is, whether the check above [1] can be
> > > > > > dropped.
> > > > > >
> > > > > > The thing is __pmd_trans_huge_lock() does double check the pmd to be !none
> > > > > > before returning the ptl.  I didn't follow closely on the recent changes on
> > > > > > mm side on possible new pmd swap entries, if migration is the only possible
> > > > > > one then it looks like [1] can be avoided.
> > > > >
> > > > > Hi Peter,
> > > > > is_swap_pmd() check in __pmd_trans_huge_lock() allows for (!pmd_none()
> > > > > && !pmd_present()) PMD to pass and that's when this crash is hit.
> > > >
> > > > First for all, thanks for looking into the issue with Lokesh; I am still
> > > > catching up with emails after taking weeks off.
> > > >
> > > > I didn't yet read into the syzbot report, but I thought the bug was about
> > > > referencing the folio on top of a swap entry after reading your current
> > > > patch, which has:
> > > >
> > > >         if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> > > >             !pmd_none(dst_pmdval)) {
> > > >                 struct folio *folio = pmd_folio(*src_pmd); <----
> > > >
> > > > Here looks like *src_pmd can be a migration entry. Is my understanding
> > > > correct?
> > >
> > > Correct.
> > >
> > > >
> > > > > If we drop the check at [1] then the path that takes us to
> > > >
> > > > If my above understanding is correct, IMHO it should be [2] above that
> > > > makes sure the reference won't happen on a swap entry, not necessarily [1]?
> > >
> > > Yes, in case of migration entry this is what protects us.
> > >
> > > >
> > > > > split_huge_pmd() will bail out inside split_huge_pmd_locked() with no
> > > > > indication that split did not happen. Afterwards we will retry
> > > >
> > > > So we're talking about the case where it's a swap pmd entry, right?
> > >
> > > Hmm, my understanding is that it's being treated as a swap entry but
> > > in reality is not. I thought THPs are always split before they get
> > > swapped, no?
> >
> > Yes they should be split, afaiu.
> >
> > >
> > > > Could you elaborate why the split would fail?
> > >
> > > Just looking at the code, split_huge_pmd_locked() checks for
> > > (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd)).
> > > pmd_trans_huge() is false if !pmd_present() and it's not a migration
> > > entry, so __split_huge_pmd_locked() will be skipped.
> >
> > Here might be the major part of where confusion came from: I thought it
> > must be a migration pmd entry to hit the issue, so it's not?
> >
> > I checked the code just now:
> >
> > __handle_mm_fault:
> >                 if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
> >                         VM_BUG_ON(thp_migration_supported() &&
> >                                           !is_pmd_migration_entry(vmf.orig_pmd));
> >
> > So IIUC pmd migration entry is still the only possible way to have a swap
> > entry.  It doesn't look like we have "real" swap entries for PMD (which can
> > further points to some swapfiles)?
> 
> Correct. AFAIU here we stumble on a pmd entry which was allocated but
> never populated.

Do you mean a pmd_none()?

If so, that goes back to my original question, on why
__pmd_trans_huge_lock() returns non-NULL if it's a pmd_none()?  IMHO it
really should have returned NULL for pmd_none().

IOW, I still don't understand why below won't already work:

===8<===
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 52d7d5f144b8e..33e78f52ee9f5 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1880,13 +1880,15 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
                        /* Check if we can move the pmd without splitting it. */
                        if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
                            !pmd_none(dst_pmdval)) {
-                               struct folio *folio = pmd_folio(*src_pmd);
-
-                               if (!folio || (!is_huge_zero_folio(folio) &&
-                                              !PageAnonExclusive(&folio->page))) {
-                                       spin_unlock(ptl);
-                                       err = -EBUSY;
-                                       break;
+                               if (pmd_present(*src_pmd)) {
+                                       struct folio *folio = pmd_folio(*src_pmd);
+
+                                       if (!folio || (!is_huge_zero_folio(folio) &&
+                                                      !PageAnonExclusive(&folio->page))) {
+                                               spin_unlock(ptl);
+                                               err = -EBUSY;
+                                               break;
+                                       }
                                }

                                spin_unlock(ptl);

===8<===

Likely I missed something important..  I'll be afk for a while soon, I'll
also double check (maybe early next week) on the reproducer.

Thanks,

-- 
Peter Xu


