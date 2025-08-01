Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B3AC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 14:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8E8F6B008A; Fri,  1 Aug 2025 10:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3F956B008C; Fri,  1 Aug 2025 10:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2DF36B0092; Fri,  1 Aug 2025 10:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C3C6E6B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:16:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 535BD1A0152
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:16:24 +0000 (UTC)
X-FDA: 83728388688.05.ECF9D43
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 10528120011
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:16:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JQrB/Zo+";
	spf=pass (imf29.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754057782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OxZ9pu4hPNnD/ub+/DxG4Ghav/BT/6VOf4b/nhk7vKQ=;
	b=z3sB01zgRJ/TgCELrUSUePhiu6eBBW76Q0SvYqAnrPDTFHXsSTE3nhRZM3wgGN5/nYe8EF
	FbB82JDJLg8etUC3naUDwV95SyX1B9NLdPBwRi4Ch+3hI2auO46AQofnXEME9CS2o07vqE
	dU9yTAZ2R1etci/4dwHoC6iiusP1GM0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754057782; a=rsa-sha256;
	cv=none;
	b=lcH4iJCLKJ1H4PmD5UJyatYy9sYv3rYnKixU7LrNGDJmGZRybOL5iBlqCQPij095WI+sAR
	iGq+OgD9wjCDLFbU2pUoqK+ivHADd6F6KuoL4Uf5Jsgx1L9xRKmNFg2hSeZ0R54qGMoQpm
	AULwJzFA8OqJLVyankrzDNTAnyIQyuY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JQrB/Zo+";
	spf=pass (imf29.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754057781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OxZ9pu4hPNnD/ub+/DxG4Ghav/BT/6VOf4b/nhk7vKQ=;
	b=JQrB/Zo+zjsJ6p+hz9v8U7xfDzl9MvOB6NcrRA+r9JVzAA5HOAXX3cxbwFMhTfiY7aT/UP
	E9uuQ5DHpULqj4qASUoVsyzMvTP/5/uYLqccv2A5VqRAEgOSY/F3a0nxsCUDfpmzMtFVIk
	IqRY8VFAMuT/RiDdxZpkxnPI4w4wWeE=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-ByCtnRSrMmiYd8t8lM6dDA-1; Fri, 01 Aug 2025 10:16:20 -0400
X-MC-Unique: ByCtnRSrMmiYd8t8lM6dDA-1
X-Mimecast-MFC-AGG-ID: ByCtnRSrMmiYd8t8lM6dDA_1754057780
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-71839bc5591so31251927b3.2
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 07:16:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754057779; x=1754662579;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OxZ9pu4hPNnD/ub+/DxG4Ghav/BT/6VOf4b/nhk7vKQ=;
        b=o+QagSgUbTC5m3TOKdOb9WNSJMaaZIqYZp3ZTgJ2IenrGQot4KLh3wc1z6IjHksZEF
         auaqN4nX0R2oX4CHBGyFDJmLBt9fcWog5FtqGnRefdE2f8NIED5lW4XistDrwCLOgh1U
         5zE9wdNaFO4j/XKrko6+zXrUDFgTzM4pKUT2G1KtdlAARpXt2LqQuursdQEiJfkryLWX
         H10zoJaBrve5UqrJUNC2Vowa2JhSrtm1sGOMYkUrj2jgqmlzAa5XA/Xdn4jazFnwvL7i
         5mjMCQKDOHuz8MK6KpugMU/UP+ehO10Typ5PnGg91tEkdEetQG8xvYMz07rYZEhyLxOj
         qqlg==
X-Forwarded-Encrypted: i=1; AJvYcCUaReHSp1f1bCMqVnQMvaaJJ6qfbpYBOw6iajc9lIOwxIsNNpTfOWCC1KKO8+B/iEq39qMq0ozP0Q==@kvack.org
X-Gm-Message-State: AOJu0Yy2wU4/0odCOsVrV0MqmVUwLvqE+d280v56iLlagKReQK+Q+rCd
	VFp+DA1h4vk+q36NKOIc9Enzlq98TpmDg2Ud/b474nlM/a0hIqHJ0Lb/VmsV/VoFF1DzkVBmw2O
	ULYrVLlrBPLmlIocwSemH82Hb+dlkR4b9dMe4GF0Q4EiVVV+4no03RYoem1e4
X-Gm-Gg: ASbGnctvpBkGKgid2/7QaBfaQ32kwKRkQZAxy8JEglCvI0QR7IDDl9jfR7BdfveWJPJ
	ORR3FZi0WDs2WTwUX2dZarGpjlb4U4AUyTApWCUHz8/0XrfP2CoIIPc9Gdt2MeM2Cat3RFV8cdU
	3R0cbpJefbyeGwATQXoDJeW104ckGYQ2R8zGUeuWjw4JLCkqiklNFkxlS4n/MUwlz8kHb4a5r/V
	Y6s+MPnmC1IkrHJt64PvdwQf0X9NxeLhirbwnFm+Yi5SwF3MPgASn0c7RFNyaFi8P8OCnINUBm8
	+PjNfHeC7jPBASEnkwof8ugVmwTKYtVq
X-Received: by 2002:a05:690c:650f:b0:6fb:1c5a:80ea with SMTP id 00721157ae682-71a466bf02cmr159522117b3.32.1754057778946;
        Fri, 01 Aug 2025 07:16:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0HREDaQfPbkGMZZI9Cdn9rppctb576Z8m/N9WTc3IgN7JerdXDwBFB53QUPtyMVn+vGbl1g==
X-Received: by 2002:a05:6214:494:b0:709:355d:6bbb with SMTP id 6a1803df08f44-709355d6d79mr522926d6.19.1754057766004;
        Fri, 01 Aug 2025 07:16:06 -0700 (PDT)
Received: from x1.local ([174.89.135.171])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077ca3621asm21820476d6.33.2025.08.01.07.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 07:16:05 -0700 (PDT)
Date: Fri, 1 Aug 2025 10:15:54 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
	aarcange@redhat.com, lokeshgidra@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
Message-ID: <aIzMGlrR1SL5Y_Gp@x1.local>
References: <20250731154442.319568-1-surenb@google.com>
 <d2b6be85-44d5-4a87-bfe5-4a9e80f95bb8@redhat.com>
MIME-Version: 1.0
In-Reply-To: <d2b6be85-44d5-4a87-bfe5-4a9e80f95bb8@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SYV-dfRKiOUNT6oSTgUVEns4guR-Mm00mbuX7DLsP0k_1754057780
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 10528120011
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: tm3kojxp61xzrzenmzmsixm4yt97czxg
X-HE-Tag: 1754057781-179437
X-HE-Meta: U2FsdGVkX1+tCZufvA2qzr7A+twqSh2nFj3NHzAACgB56V9MrP9PTw4LmeQHMmncu4wUeCzHDQgZTgPqVcKFE+dYRQac0gwoUunQIC2RRrI1vppEI1AyWpxNpwUnrKfSEF9wEcheJrEFkzJpvuhc98a9eHA/sUixJer4jAGOkkIxiNL6sSNFhTjwEKsHEsflaLylrqu666EOztqibbXffHQiVaLL/rQTmVz7744n53569asCDwqBcWXhmGepQicQEV5TPjElW06RtpwYaRzIEaIc0cGkwgeq7fbFtX4GMsnUXJDgGayFtBONSNwVfoqcbuYW5xKl97wqslGGM6hlcmczqMq3hFK1v38dCVtWhZMTOgqvX82W9vsswKR+9hrKMYfO/GzbWvyMK3evyYFLn3no3zmMacDkSaFtFPQRTGXJozO3Ho2utr3P8NtmT+wul//3A2yLuCwgtHFQFgDTLSEGHyIG4V9Fnz8DjOvMYDia7MUy+CbEFkHar1+974ZZtPcrOFjy2tkoUjz+ibfOqhCCPoeiS/RK9f/bQrArOkbMXtlJIbhZj1i9gXA09uDh3BVtO6DpFjTfZInAQB6cl0icWq3KhcFSsoIcNSK733cNRRc/Wo/TT8zc1udcYUbIf9eJTGX4RjP0ttTEgDJLPRLuhbdvH8UeRJKY34yv3pX5vpzJskUYgaPUvja/hkyiIIsapbXMpidoyR8nZ8ony4rUTNMZUm2kIP5iivTqZW6ODnEWrn3Yelhlmpm8VqjiogkNpuPjdI/fAHVviODKpqIP0QucaGk+OP0AVRwFhOmqLRr01zwHLF9dbWe7UoCxQj+HSzy2FJxqo2hQONhFWwzfCjDteVNCvxaVvvSlaMWUAgQaoLVGTQNe+61+lrTkme3xz1+2I9jcRdWNZy5bjH7DeYmNdJiB/AufEi3eSddzjR0KkdgOJYz1iJDKgjzHrU665+zc3wpWTz6mtFo
 5nQanGzd
 iYUh/u6EvOTH4GpdoSdNo1w/6sYsSTdoLCH6k7DXcbKvB7HAcPloXlIUKH7g65PWI3kIBnnSPdsxw862VziCUUaqLdcQPQpvgb2L167uK2JxLU3GTNDkETqwhsKueFpVIBaWX9iu520CstSOgBODUZJRC4rSvn2a5U4NoNOFXhA/sv3VVCAghbeUAbakJqIdCtGl4VIcxI1bSLOTQYdKJ4WxSTi7N2AouyqQyIhc2OAmg7df6BKr8YgUjUac0OcymzAC0xOrA6hR5pRcupY8DN4ZbNiLlU9q5rPxxQzWnmoU+e48lBS8liHgLhOYUq9VJI2C0jaBxj+zCDUPgX+Qn2x9rZO6HWiTEPRa4XDK9obCoVJaKFopKAPx7Zn3hEuLFkf2kdl6xExNs8QgI79OiB0wXTXF5k3IMH1/3QIvixtXEF7Qrn3dWAIL0dLDF089wt6yQA9fYHqQJdCcadrJn/rtFDDsN8t4a3/l+dp5vtNphWAX27XpFIJK5PsDS/q7xPwV3k6Tq1pPxMoHkfkbsX2CPuNK5hxeOTbLy4cb8I5KRVILriKqS6JxABmyqBDAPa/ZPiOSZFfziqMBYNBeMFoHE9svHX4bTDRBR61IDLydp6nA/9wKdXXjGK9512Fps1rt/MKSDY4WN6oECvo0QkutHN5ckdAsnCgNdNWPLs4JcfYI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 09:21:30AM +0200, David Hildenbrand wrote:
> On 31.07.25 17:44, Suren Baghdasaryan wrote:
> 
> Hi!
> 
> Did you mean in you patch description:
> 
> "userfaultfd: fix a crash in UFFDIO_MOVE with some non-present PMDs"
> 
> Talking about THP holes is very very confusing.
> 
> > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
> > encounters a non-present THP, it fails to properly recognize an unmapped
> 
> You mean a "non-present PMD that is not a migration entry".
> 
> > hole and tries to access a non-existent folio, resulting in
> > a crash. Add a check to skip non-present THPs.
> 
> That makes sense. The code we have after this patch is rather complicated
> and hard to read.
> 
> > 
> > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Cc: stable@vger.kernel.org
> > ---
> > Changes since v1 [1]
> > - Fixed step size calculation, per Lokesh Gidra
> > - Added missing check for UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES, per Lokesh Gidra
> > 
> > [1] https://lore.kernel.org/all/20250730170733.3829267-1-surenb@google.com/
> > 
> >   mm/userfaultfd.c | 45 +++++++++++++++++++++++++++++----------------
> >   1 file changed, 29 insertions(+), 16 deletions(-)
> > 
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index cbed91b09640..b5af31c22731 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1818,28 +1818,41 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
> >   		ptl = pmd_trans_huge_lock(src_pmd, src_vma);
> >   		if (ptl) {
> > -			/* Check if we can move the pmd without splitting it. */
> > -			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> > -			    !pmd_none(dst_pmdval)) {
> > -				struct folio *folio = pmd_folio(*src_pmd);
> > +			if (pmd_present(*src_pmd) || is_pmd_migration_entry(*src_pmd)) {

[1]

> > +				/* Check if we can move the pmd without splitting it. */
> > +				if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> > +				    !pmd_none(dst_pmdval)) {
> > +					if (pmd_present(*src_pmd)) {
> > +						struct folio *folio = pmd_folio(*src_pmd);
> > +
> > +						if (!folio || (!is_huge_zero_folio(folio) &&
> > +							       !PageAnonExclusive(&folio->page))) {
> > +							spin_unlock(ptl);
> > +							err = -EBUSY;
> > +							break;
> > +						}
> > +					}
> 
> ... in particular that. Is there some way to make this code simpler / easier
> to read? Like moving that whole last folio-check thingy into a helper?

One question might be relevant is, whether the check above [1] can be
dropped.

The thing is __pmd_trans_huge_lock() does double check the pmd to be !none
before returning the ptl.  I didn't follow closely on the recent changes on
mm side on possible new pmd swap entries, if migration is the only possible
one then it looks like [1] can be avoided.

And it also looks applicable to also drop the "else" later, because in "if
(ptl)" it cannot hit pmd_none().

Thanks,

-- 
Peter Xu


