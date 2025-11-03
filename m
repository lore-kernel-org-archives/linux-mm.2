Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 446C0CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 23:17:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762B98E008C; Mon,  3 Nov 2025 18:17:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73B258E0058; Mon,  3 Nov 2025 18:17:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677CA8E008C; Mon,  3 Nov 2025 18:17:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 565C78E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:17:54 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1BEB24A3FC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 23:17:54 +0000 (UTC)
X-FDA: 84070860468.10.A8189FE
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3E20D80017
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 23:17:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=M6Tf1TUK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762211872; a=rsa-sha256;
	cv=none;
	b=7zJOemeTO8BZWYQhlCCTG3Ms/HZLMR/xsZ4nzy7IxC39n+RYjAqmuh/1tOOf09GPVFhFV/
	AHT+Mt5M9bHswqWXCg4A4MvNSnYqhNzTv0W1304BUVI5QaGvjns8bGcegJYCOgvs6/acxS
	iWYsZ/DMjsGYIRI3wnu2Elw5ql9Txns=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=M6Tf1TUK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762211872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fTPNz4WRApFt5wxHNB70egXXItDw+twybx/DEhnB6Y=;
	b=XzOiGHaehPfLKTtj0HQkF2qkMxTCUR5lDOca8dY7ZOeiDyBuP/uVuj4jtnWDo8Pi0Gvchq
	CcuduYWzmhIWp4TCwUQfYa6Nl4O7NANwlRGbbp4tCC5MFV98Sdf8h4TyHU8r8CzbHzLBTg
	lOukv2BAnOHoUUPTiQeo5O5+SPAaaw8=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ea12242d2eso61701cf.1
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 15:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762211871; x=1762816671; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fTPNz4WRApFt5wxHNB70egXXItDw+twybx/DEhnB6Y=;
        b=M6Tf1TUKUqAhLG0G3x6pbhZuvGaCmuRy/u8QfzCPvNKgRr7HLkPr04HIaZ53fT23i+
         CHtu+EvcKO6Xck6pMqI7jpuGlVFubMgrBpDXiKCMN2cmnBKSsny94x9DF3NuT/pX2MhR
         s5O0ts+koWp4GkpSHsTBd5DLuyBbfUOfJ6zA5uk8rpUNEgjDNqMK5Jx1/OrzjOCB2G0X
         JY5dp5Z00NOlYLAUmzNKUvBmvYt/8QnzYw64GMnF8ARrPVBO9Jj503P1omNov70awhiI
         rEHJKWA8jjEQbk+FYTlmYlhPAk9Z10gby1Ffx6JBcKqyPgqb0QmPU0Um+VwqGF9u9Bnh
         77Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762211871; x=1762816671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fTPNz4WRApFt5wxHNB70egXXItDw+twybx/DEhnB6Y=;
        b=NroVefwWUcNqwpaNB3Lz/maPbDrTnuXKzyNrOBlNHJvJhSpcdVs+FpTfryZMxB0tnn
         dnuUV+y/PewJKBBPooJl3vrJnB2XaPBbDyUjH2ZPZ8q575TGlbo6Pl3cWAK8B9pPWFQM
         1dtfxpmpm+pe0eyWTXc+PbL02N69XRZulSOoI2PHgrNppH90BpBA8YwNVxQs0wGBNKI9
         rXmby0BxvAainSKv/UboPCR3/PJp1k0dfastGoxkqCuPLACuYReQpoINnvhyFk24blHP
         fCPxD23Gs0X9R35NYqRckD+dYoJMzhgOFNWXXd/sLJ+mgaNEje1kKdcQxionUAU30aAe
         jtEg==
X-Forwarded-Encrypted: i=1; AJvYcCXk7Tzgv9ejgVUG30ME6oD3wA2GMiVDaq6p/N2LnAuAp0eWe2q0txmcIRRYz4o8fPU6usDQ5AnP1Q==@kvack.org
X-Gm-Message-State: AOJu0YzUibMfo7+OtNnausnxzW2h13nE+Y9Tu5u7FmUWxxMmrPoRTPjZ
	03Wx7T9frqGwY5JXl8eBTmlsXo9a37wZI4/5WBrAXeJO5haKo/AW92SfYX6pG8ZVjv3xBofqIjP
	CAyG0oOnbpQqyrBniPy2ITrhMxL1hEH9Wcp+y6rS0
X-Gm-Gg: ASbGncvq61UQxmqJVAIMFlNxgVYEhHMn0bt+lL1dICPFAxEyTXF7tA+T2JjvziZ61FL
	y0ZUUIeaEX9ejCJlKZewyp3wK5ImGeLMV9YVXcOQH674oI3gnI1gPUyTfVOoJJH8JzZyx9i/ZBj
	vj7n3qFgK47nwwyZ6aza1N0hC41I4zhaHD9WT95hqSZfb64Lls+F+K/92YVdRdH2nDfkW7tEq1s
	1hel9D6je/Xh/oARUVdDLGQXCKPcYK5oerv2tJEebbgLNHU0Fj0mKq3ivHTtEp5Io5OBA==
X-Google-Smtp-Source: AGHT+IF7rODbFNkhivyhVtTQPFkQYURjWBKo6IQpCJCJ6p8BXTcbnQU4tU3G15EixIWCyQpnr7FnZRgw8HPovXyyJ2c=
X-Received: by 2002:ac8:594b:0:b0:4ed:18ef:4060 with SMTP id
 d75a77b69052e-4ed61c2b01dmr2705781cf.8.1762211870947; Mon, 03 Nov 2025
 15:17:50 -0800 (PST)
MIME-Version: 1.0
References: <20251103180348.3368668-1-willy@infradead.org> <20251103180348.3368668-2-willy@infradead.org>
 <CAJuCfpEGdMLxKqPZND32BZeYcpmRb7WQqBc2Qq_Z2Dk1LZEVhA@mail.gmail.com> <aQk3c0vzEeC8lotz@casper.infradead.org>
In-Reply-To: <aQk3c0vzEeC8lotz@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Nov 2025 15:17:40 -0800
X-Gm-Features: AWmQ_bm6w4xW4z2tVLVpbf-e65wW6S_fTHqnGM3rLpzrm1Bqxai6KXE0bMbuxXA
Message-ID: <CAJuCfpHB8TBpmmMO3xyjqKnuhEFgg10Ani2+U-YP5vu8c34UMw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Add vma_start_write_killable()
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3E20D80017
X-Stat-Signature: wugf4cx18ymf1jhf86hacoeix8n4gp3g
X-HE-Tag: 1762211872-271625
X-HE-Meta: U2FsdGVkX18O7jigULzIPIHgxzFfJKjHxh/9qwt4XG1uf/zXrp4Cxpuz9OA2Q/i87+6mmVlQZbdLuwKuxc6HgVqUS0nu32yQxp2aqgSh5X4Jv+mhQ8gYjkh3+n7R5ocNys4EtDCe43Zfc2GkM4ENG9T0SJzFbeIrdg2T3VwLwqwNoiQp7r6uTJ7mzXvCIH5sySx5OReQcenOFREPocQawUHdEz43ttI5ESCYmDAF/ZVscpBUnQvISgCnM4FnZ3D/FXgLOcTG4gjxsDWMgHNhkncxNaR/vxchlP9QjZjrwjHhqvLAn6hlhnLsnXpSTNRNL22wY7Vzf6t98riAitM98upQluaOGy+3o7XX2VKmaFZ5EcpcYS5Dci1teI4DZ8Boq9Ul85eDDIYkRkT7ZbIX9q0bAJlr86lkIDQXZIBgUsUqrLQIV27siws+8dlGjh/Vy2lhqnf85JQBHYmW9bVw7o64dfs1h8UWv6EqXVdtcFny7KIg57Ezhvj0nPljTkRpslCIJbH1iAEywrTdl4iHRnr88Q7mWOSK16iiF8Zb8k92DmIn2NjZ6pRTa5p6+9WaL85Ib/zXNMeKorZSpRG4ghYtkuoBG2itP/QMSXx/CRlEqRvW/BBdWIuL4wXMTEvWhZSMCcVk5vKEs4igI/kJBahEuCJ9K3Thkh4QQyXJOewi5JtGgTUzvrReDycXuIWXiY7xD2q96SD21zbQ7DswhHvTjGDzMT8GQbJgv2fdFs3QSqGHfkudJ49ciIGt4cGpeGZEkfTl22JD1IpzuqZqq82zDrgLxA2rRnV0XdWr7J0i5qQ9LM1q0vax6pzJvQ+8yn8i2v7YxyM2CfJBDBu8myRiDg5wGf7DPSUK6s2CdXhkYGzlGTr+5TCzFvNT8hUETVtbT1G/btaXxop0rxj4xT7KgLTyRnqOZ0oNy5Xi8JAL2Q30ZiMf+WqY4aYknbtUpQfb4Uiz7Gif9+uhlrI
 2xJLnTPT
 G1GK3o+GeWPWL1+nmvOfZGGKlw13PvKW2XXJNnfx+vaHptRIKYGpGTuPh0BDx17r04aUc8Q7iE9dv0nvZsF9VkfngV4F7zlRuJL2+aqIDJtx3/ob6OJ41Cmr2M/jbyfeeOFDMTp+OhBpltKrv0h9JpDj4JEyAA7UwszFdBezv/HPJJYNWevhXGWqcP7bk8SeqrD6bQ3RDQ39tCWV+hPUBUcKynutFmftf/bL/rFk4aE6uq58eImeqm0SNvBH0WmEkppWC9smsWMrAIZJj0SXN+hPBnYAdOCswc50q5D0IkWB5Ue0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 3, 2025 at 3:15=E2=80=AFPM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Mon, Nov 03, 2025 at 01:53:44PM -0800, Suren Baghdasaryan wrote:
> > > @@ -286,6 +310,9 @@ static inline struct vm_area_struct *vma_start_re=
ad(struct mm_struct *mm,
> > >                 { return NULL; }
> > >  static inline void vma_end_read(struct vm_area_struct *vma) {}
> > >  static inline void vma_start_write(struct vm_area_struct *vma) {}
> > > +static inline
> > > +int __must_check vma_start_write_killable(struct vm_area_struct *vma=
)
> > > +{ return 0; }
> >
> > nit: a tab for consistency with other stubs please.
>
> No.  This is a stupid indentation style that's not in use anywhere else.
> There is not one inline function in linux/mm.h that uses this formatting.
> If anything, I'd correct the other stubs to match the rest of the kernel.

Ok, I wasn't aware of that.

>
> > Let's add a comment to list possible return values:
> > 0 - the vma is not attached;
> > 1 - the vma is attached with no readers;
> > negative - an error code;
>
> I considered doing that, but decided it wasn't worth doing since there
> are only two callers and it's a static function.  If you feel strongly
> I'll add it though.

If it's not too much trouble. I think it's not very clear from reading
the code, so a comment would be helpful.


>

