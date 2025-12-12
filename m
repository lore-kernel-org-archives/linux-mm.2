Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46719D4415D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 09:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7DE66B0005; Fri, 12 Dec 2025 04:37:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D916B0006; Fri, 12 Dec 2025 04:37:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91CA06B0007; Fri, 12 Dec 2025 04:37:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2B26B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:37:46 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23C88135064
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:37:46 +0000 (UTC)
X-FDA: 84210316932.03.C9655E4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id AB1A64000A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:37:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X6ZMKF5w;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of dkarn@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dkarn@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765532264; a=rsa-sha256;
	cv=none;
	b=Y81r7d4TkAKkSWLysh4Tnkzt3PH58mHl5BZcUf+g8wHjOL3zsVyfqCtSib5HPwJRA+ar4Z
	Kz+z1mvi4fG3TpI1ejCN09aDtqGzuj+UQWLaeaIGlfrHcw/4pSPSetC+owdgs5LacGU5XZ
	n61yxAbCmQkHKwRxHQ4/0b7SKy+Kt/o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X6ZMKF5w;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of dkarn@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dkarn@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765532264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2IeK2fmxKCyYFISZ4y5sIfqoCgkHvoGQR0PUve4ax1s=;
	b=YxDcxyRoh2r0dKUHK8duGd0jbGO5gnydYcZVMR1wblN5eVsI4R+3g4UJHue2QP8Dpc+l9Q
	iIAIYYNzPZL0SGnrtmlW3fiBtkDn3DU1PIyTh5V0Q/ePtJ6ARhDhHQvl6ZD93OzYChOQVE
	GZypaTmWPfPW8roDGFO5As6Buz4Mblk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765532263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2IeK2fmxKCyYFISZ4y5sIfqoCgkHvoGQR0PUve4ax1s=;
	b=X6ZMKF5w9kWDE9PXUsXsbHxdy/qsK2CgyfGqGUdYRtjJSGFtSE+T9zt7Iz8SXDKvAxtH4k
	T6uqEOVrZugQxavZ0JZesJwgcn1uc+QUcER5NHYgpURvzLtCi8Dz1njyDXiCH1Ti3kWWRo
	b9B3gLO4rFEW6YhQ892qME6sWZvFNec=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-4C47GY3sP_OnUj3zfbJkIQ-1; Fri, 12 Dec 2025 04:37:41 -0500
X-MC-Unique: 4C47GY3sP_OnUj3zfbJkIQ-1
X-Mimecast-MFC-AGG-ID: 4C47GY3sP_OnUj3zfbJkIQ_1765532261
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b79e98a23c5so153337866b.3
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:37:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765532260; x=1766137060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2IeK2fmxKCyYFISZ4y5sIfqoCgkHvoGQR0PUve4ax1s=;
        b=HTTp3JP1ayYEft33ZIOmzq4xKU/IALB1wWhRcLShHTojTjBt02Okw12Dw3beHgiaVI
         /H3JIJiUbUgkWhIu0rm1dhLt/7mgGCDsTjc4SPj4LFiqd9WKqbJgxxa67NxbQpekGR4e
         FAu16qdcCGbIBCYd12sOYYuhObe0WuvMOlZZsqWdO3OVWg2KzXCrlmgLHLlIS8nkTp2m
         oadMyzz52OG3v0iHzolXqCYtv3q4GpKZIL2MviK7T1MBUlG+lq98riV5R2lrfWeExIYI
         rq/Iw5uF715MVmBt0+RcMcwT75bb1PQORCCUH5zjnuTHYvdzz6iFvU3Cx79ncxy3Cqpi
         GekA==
X-Forwarded-Encrypted: i=1; AJvYcCWxNp39La30tmshvgOwFQR4TQWcmSgAzns8p0B/AIKuUr7uAvzb3c8MAPW3AlhAmHKfSYxhQX4ZdQ==@kvack.org
X-Gm-Message-State: AOJu0YxLok3fDBd9MVGOQMwX9IxOOs9Mprc9XjhlGE+y+UpmNLYn1G5A
	+G+dJgZ12+2zdlvP3y4P1GJUo7Bg1ber0LFzoqrcNKTWHcvPUYoukNwxl9hx2zfs1/zUTiMlb/T
	wmjGVo16mrBGJsmXkBOkxcwcnXEBx0rmAui5Uo9s5sZd9gukCgYjv39BOZqT51j09zu0KCWdq6+
	RRq535e52wCVy6BhaJGRBsb8HAOA==
X-Gm-Gg: AY/fxX7KnK5RwRrmUgzOn8j3liu4aNgq9EXsNLK1ObjJOtf4h+okP0yBKnikDFGAlPH
	AmAEzZe7mQjE2ls7v6sZmlprw0BxGTj+tPl3GtoK0Pdd+a74JAyEgivDMVTcnVkMt48/x4zcT6c
	B1wJ2fqtaWzuCjAYhpUK/Gvs4m2IgYOOdrKIq0HAtO8GP/EX6oV92+v0TunfJ9
X-Received: by 2002:a17:907:7e8a:b0:b7c:eb19:2094 with SMTP id a640c23a62f3a-b7d23b84741mr119341766b.48.1765532260496;
        Fri, 12 Dec 2025 01:37:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKs+YSpkXeGFW6Wdv9ENF6584RosIUQzla+swfnaa2obStfpBKi31WCvIbxALTkc4KySlIExdmg14SQGDHhR8=
X-Received: by 2002:a17:907:7e8a:b0:b7c:eb19:2094 with SMTP id
 a640c23a62f3a-b7d23b84741mr119339266b.48.1765532260057; Fri, 12 Dec 2025
 01:37:40 -0800 (PST)
MIME-Version: 1.0
References: <20251210200104.262523-1-dkarn@redhat.com> <aTnn68vLGxFxO8kv@casper.infradead.org>
 <5edukhcwwr6foo67isfum3az6ds6tcmgrifgthwtivho6ffjmw@qrxmadbaib3l>
In-Reply-To: <5edukhcwwr6foo67isfum3az6ds6tcmgrifgthwtivho6ffjmw@qrxmadbaib3l>
From: Deepak Karn <dkarn@redhat.com>
Date: Fri, 12 Dec 2025 15:07:28 +0530
X-Gm-Features: AQt7F2pbIgM3tqCd4EBNu9cORYdXSy43drqVb-wsluyzXe0wXWGaXmMb9M_9TLU
Message-ID: <CAO4qAqJVn95XZUfrYm4th=-bqWPcndTf3OzUaNkBho1=EvTUKA@mail.gmail.com>
Subject: Re: [PATCH] pagemap: Add alert to mapping_set_release_always() for
 mapping with no release_folio
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Liam.Howlett@oracle.com, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XyxSH-JPGELH6_nAnrUFNeTOKTqG7hg8XdT5bUjlg4s_1765532261
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AB1A64000A
X-Rspamd-Server: rspam03
X-Stat-Signature: kw475axaqsryegckpash7hnemec8c3qw
X-Rspam-User: 
X-HE-Tag: 1765532263-381273
X-HE-Meta: U2FsdGVkX18KKWfXX86MN0iVZqDWnv6ThF/aMhbegBi7YWC8xPYg6nDHkIbc+QT8VbWJ5O3aRnKReLj+XIy+8DDrytsXyCdBYfNFyLqsK483C2AQgoL7MoxPueXtc02gpTnUTpo+/eJcba0zt+mdDWeHCXUuNYjjO0lrm8Se9sYNKQsjHTEWHyYsfsGOg565PFPY27YtvkDdmVIub96YLs1uYfy4HLwJv/ZtJJv7JiYx6q1PUAhp+X1PBefDH4fbvGwe45IiIAbWA+o4AEFUW4eTQsvQvHsOqER6KMWvyBO0X83gygob2ZtFQeQ27q92IrKoBuk2AfcJ5K/Qa9lbnxomhYAascrsbAiU1njnsvpFH6Zrn+vxKvtt+4wnF9s1tPsU3gkk/IKrUGRG8p2HXzZkU0Cx2wxxxL8utBxuxXRAJvP0dSb5bwLZ+caroQB18m4NEMGdR86VRt9JtCKgZb3JJ4NEU4YB8Mq5opalsj1AgfwEc/KcygHKw3TssscukZKda6soplSLc0F1u3zOnbo7+HJBX1Nt5e1CdKBqi/Va6OdtvDTrcsyZzvPbM2xWDa32wEPhh1LDiJukXjbQNXXsRKnZJdTWMzby6fXE2AulXU8XNnDdi/nsIobsRDfQ3U1w4fZGz8TYNgyog0L5fo8U5naOb2HZHzUp+ixBSt5zDzcU/4C1/BA6Cq/SkUIx65/JuH8JAjDgROBu/0hR68R0nmcwys4KjDmoJOrqcEDq0XQp8xHxLMmqohmsSb9PldBZCCUq453TYYrPYYOx31NYNqxg4KGrHUz1dQPlg78P5V25RBvBTPLOjeQspUCZ05V6iwfADot6HN6su6CSE74LvXs7dBSFJ/52m2D3K2U5N+88G6c7N7yIrtBn1jt3FYFUh3uDL0e9gjmtOoDI0R/qAtbpxFmJpnD0Wethl7aKCwgJojV4QTw/fldPpG4Gk7ka1Mwt5Nqt2Bm74NI
 pRUzviS2
 B+q6a3xymuH4CaJFCAlSl/PYMkj6kVrdcukSby41OwwpyRhnDBCqWcQ26o+vjzN/qeqk8eZHsG6PI6soyui/qiZOVM8EwSYPf1RD8tgoVoueG3dV10efiqZYHQTus3XD2G9WWAIlf+NBa73FiU3tzKUz4Dokzmpr0Ht50EHNaxeCC00tBW5MrDQTRnAhpdyfDnOaiND8UjfrosM7t39g5S2Z//J14veI7/W0GinwpZxOWGo0hegpRpAgRAKEs6tyxM7jvqSwVkPs6thlwEaGxSnQB7ltQ6fcttw+cuYHLFJJURr+43fF8boYFRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 2:53=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 10-12-25 21:36:43, Matthew Wilcox wrote:
> > On Thu, Dec 11, 2025 at 01:31:04AM +0530, Deepakkumar Karn wrote:
> > >  static inline void mapping_set_release_always(struct address_space *=
mapping)
> > >  {
> > > +   /* Alert while setting the flag with no release_folio callback */
> >
> > The comment is superfluous.
>
> Agreed.
>
> > > +   VM_WARN_ONCE(!mapping->a_ops->release_folio,
> > > +                "Setting AS_RELEASE_ALWAYS with no release_folio");
> >
> > But you haven't said why we need to do this.  Surely the NULL pointer
> > splat is enough to tell you that you did something stupid?
>
> Well, but this will tell it much earlier and it will directly point to th=
e
> place were you've done the mistake (instead of having to figure out why
> drop_buffers() is crashing on you). So I think this assert makes sense to
> ease debugging and as kind of self-reminding documentation :).
>

Thank you Jan for your response, as you highlighted adding this change will=
 help
with early warning, making it immediately clear during filesystem
initialization.
Also as Matthew stated, the comment is superfluous and doesn't serve
any purpose.
I will remove that comment in another version.

Regards,
Deepakkumar Karn


