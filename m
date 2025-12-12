Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 107F9D59D84
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 18:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A22D6B0006; Fri, 12 Dec 2025 13:39:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779846B0007; Fri, 12 Dec 2025 13:39:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7146B0008; Fri, 12 Dec 2025 13:39:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DAAF6B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 13:39:07 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4FC914026F
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:39:06 +0000 (UTC)
X-FDA: 84211681092.14.0D5DF54
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9634B4000D
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:39:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZLd2qGxL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of dkarn@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dkarn@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765564744; a=rsa-sha256;
	cv=none;
	b=hU5xvLy0T5/GBx+HEbBIZf2E5j4ZBToDRKb096RUJnPQebWFeJtxveIavph6EtV7Jvhezf
	RPp+gpSKtQnVz4Tld4nAAG+cldgmYxipO3gJT060kKVQbU4Lw9CpN4lu9N0n+nQYAECk2l
	HqS6vKQgCk8GAIClOUJ5rBb7VWvXiy0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZLd2qGxL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of dkarn@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dkarn@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765564744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+hpqhx3308ATwYzN1NtxlgmadEIegTDoxPGbpzieio=;
	b=qEgPXlc0V3vWYEhIZt+FlxsdIHCJf27AC3Qy36vubGdBWqSvKgr1r/WGDwlKoK+PTbPE2p
	Fsb1v+tQDYHrBIof9aTcKuBSuxp9Db893VleiQ98Z2h/TXIS7e8oEvH3wEci72VVvsFBuD
	8pA+1RJJn2YxOp5YkKUaJuaaikunDFw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765564743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S+hpqhx3308ATwYzN1NtxlgmadEIegTDoxPGbpzieio=;
	b=ZLd2qGxLyy5fXjaMTkpl4s6q0lFWT8l+cI1nxpSltqbrllSVoiIt6DR99jnvc0dbi2m9E5
	QtffA+YBpYC7Oqih8QU8zIduWPuh2So8yIExSOJK/FXvhzhouOjfmvkO5EjHOdAPCafVJC
	tjiOYNkIxO/D7AVY5v/qmpBnK+Bk+f0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-7DYccD0tMii_6tjY7Jqk0Q-1; Fri, 12 Dec 2025 13:39:03 -0500
X-MC-Unique: 7DYccD0tMii_6tjY7Jqk0Q-1
X-Mimecast-MFC-AGG-ID: 7DYccD0tMii_6tjY7Jqk0Q_1765564742
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6409f6d6800so2939060a12.0
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:39:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765564742; x=1766169542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S+hpqhx3308ATwYzN1NtxlgmadEIegTDoxPGbpzieio=;
        b=KGfluoD7e4+O/n8/tugXp7qlBY5ZPsFgJuwkcXociMaSFE1oOGlLsT2R3wNPXNgd2G
         G1xVUUCn1AvtAecRX+QWURQ4o36ssmKFjERZhgrB0ZHQWjmG+0rekqo5qc6SnJCoBGJN
         BtBhCU25RfXQgySoHadPME6rGHe9ZEw8OlcNOEM1ZrZ/rD9LWQ2PkBHNtd7smAtU2SxY
         NuAL+DyGh+uzGaUpxvvi7muxsqRjH9QJSL58Mn5Br96Y/rr8HbtVOCmnzytj9WK8FFpX
         VU8nIZScLi/hneMks7oaYQrTuzmykiSpkQT3DPGNE4axaCd+5S4pARnZqJSyTL3/yGpp
         DbAw==
X-Forwarded-Encrypted: i=1; AJvYcCUedxKkLa5sZflaQW/4aGYBh2c1dCi0Sa6uLI3yS5jKm8A2XPnhNMJ21EYYAlt6DvvsMe0ZFEsHng==@kvack.org
X-Gm-Message-State: AOJu0YwvXnqI19NujcI5knJBxg2VLZqrWbnAKJ94lN7rrFFKC+pQ0pb7
	W1Dg5MxE4S+mala91/1YZ+0JFMs3JM8zNHcwLyciGApSDBeggmtQby/BXWDbtoroyA1fF14Jxje
	zYrMC3muhAFxGwrTVd4umYHPZjCwZYc4l+GU4I9fAZMS6AfJiFekK0Xay5Mir8tX5jOYKchKLVf
	Mjot1FvZIGP5WV/IYU1TeiIG57WQ==
X-Gm-Gg: AY/fxX4f6M6ObkEz23udiJsZfE0ZelFoPTYph6kBiatKWW9YSn4AlPaEC6doUmmKTOb
	DHP9i86E86oS1Z0g3kST5PpeYhNtQQlB0ZtbEDta5QoTtbTtxZMd4N22AD9gASmgYbl2CVlpqUy
	YKHyHEnmBRSHHLtwLqkUERLRlVRnVW7C+aTIdJ7xXGkLXG/MQvKzE04bbpTkZf
X-Received: by 2002:a17:906:9f88:b0:b72:6a39:49d7 with SMTP id a640c23a62f3a-b7d23c1b192mr329954966b.33.1765564741591;
        Fri, 12 Dec 2025 10:39:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFH5hEfEk+Qd/TQuO5dmZhx0Ve9hkd3hngFGgcBfMa/BZ+7n602U9F6HYZJh/uoPAXYcPduxx52GHJ646gbZCw=
X-Received: by 2002:a17:906:9f88:b0:b72:6a39:49d7 with SMTP id
 a640c23a62f3a-b7d23c1b192mr329950666b.33.1765564740878; Fri, 12 Dec 2025
 10:39:00 -0800 (PST)
MIME-Version: 1.0
References: <20251210200104.262523-1-dkarn@redhat.com> <aTnn68vLGxFxO8kv@casper.infradead.org>
 <5edukhcwwr6foo67isfum3az6ds6tcmgrifgthwtivho6ffjmw@qrxmadbaib3l>
 <aTwIAwjeSrALbVww@casper.infradead.org> <7pottkepdngwjiz6mi6rby67a2xpm65ulx3oflzhrv275efq3y@e64lbkl767eb>
In-Reply-To: <7pottkepdngwjiz6mi6rby67a2xpm65ulx3oflzhrv275efq3y@e64lbkl767eb>
From: Deepak Karn <dkarn@redhat.com>
Date: Sat, 13 Dec 2025 00:08:49 +0530
X-Gm-Features: AQt7F2o9HVOS9-O3c1b2kzj6ir7__uDkNTKy0pS9_N14HeUb4y18fmVn6ULV2e4
Message-ID: <CAO4qAqKX=LA1PHjGJ0BO1YWE04BneJmZmximqqF0BQ1i6emhNA@mail.gmail.com>
Subject: Re: [PATCH] pagemap: Add alert to mapping_set_release_always() for
 mapping with no release_folio
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Liam.Howlett@oracle.com, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Gynr5M_C8LNE-Ovb0xesbkuDQ5rmrHI50erFTlJ6q_Q_1765564742
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9634B4000D
X-Stat-Signature: jrc6pf7wxkz8qsn8oghk89mmjszxhde4
X-HE-Tag: 1765564744-656622
X-HE-Meta: U2FsdGVkX19fYK0OZb7Na3zwreWf3nO32rc3MzZpqFFs2NiwrBV2KCSqZRju7DGofdditSYuWppuZDFb5g7++Jl1dVCiyRNwX5YKepzoDxfqIPcp3atM8X+bdLbThlhSod+Ed8bzJO8Sc6HyRKnJgBOo3SapPl3f962uOfHxRHd09tZvvivaQKjI9ZdqS5acx5WPRmnbxC8z7MeULiSAvxCtW0RCTSNr0sOG7effwxvYZv6cNcHyyIH37N8jLDqH83izMAcY0CV0FED9yzFHdT6x1mmFT4tHQrLd1Ld2noB9a+k6/QAqqCaMrEb1i43jUj/ajpN4/r7ycDWENLPDGHcDv5MYQyjPXxbuGNynSsE+LiiWlYG8vfT9W0yITsmv1r+SkygnVskFonN6tZ7ls9zjokjmRkINJZHT0pcp0GpMN1eFMS55BNSvIU8xwWsk7/+Px/UVg2SgwLzbLdNb2X4Qi+oKSIsIgg+AtBSdptt5ldYN77N7EEJ5Cdh62trlHZAWe6rlFuSG7YG28DtIqA7VnCakVaznpNEmm8cJec8RW4vLCuBl2TIOqxLgOvATscp45fH0IMUdA5C5ZbojaNTcdLXihRFSp8JZb9cTuTm9G9czR6islxDwKhVvTLIQtHhB9ZBeTMjWdgXNix/wYdMwRBC+fpFZWCZI+2ws8g1uXk7sFKy6ZZhcWZUv4HgZrdWiqcOeCiMvXRnjetxJDnB2bNmzAVNtC3kxTD0U3isUjvRWuO4VijOs/aOjXVXPc0NGxE1mQcTCvsVEp+87/RY3Ts5pT4r2slZZLrrkCH6dA15nEiFRA6Uuu0aM3RsEGKbxeGF808idNVQv7yKnh9RrcEobkKoUN0j4GzL2byn1oxyiJbzq97x1Z3tVszgoEKdtWLBDUJZjFSYDqE6pqK6Xk+Ex1cjsHeAni9qHxV3jGv1APAGT6Xpe0TmgQx+KnIsBMfqFEDTiV+mFDVC
 bbuTHdaf
 EHbmmcLCGsv4yBP3UzbSzf29vnI5JKWAZyovhkHRAcuPCLXysPpmfAQ5np0s365LjBd+A8STyTto3hQ3Tn7n/HK41uwzrTTZ49c1fxdMkXE1ERq8jAHUHX+cZhvbyHvjsyi1MX8j8Z2d6KMDFIGDJ3QXpYSi4M7rpRa3DvkIuX9/nFkOdTytCyFgI4/4SOEZ/ak0PDC1C4XAHvGm+EP4gPKUCF2xwdLBFkYSFrbYyDp1APaA6Ss3DzOe90/kEb/RlEAorrWvI3gIxMm29QBfmLzg1sAfLyIh2V9MxSC2gBh7C2zq/NxAcT0igUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 11:17=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Fri 12-12-25 12:18:11, Matthew Wilcox wrote:
> > On Thu, Dec 11, 2025 at 10:23:13AM +0100, Jan Kara wrote:
> > > On Wed 10-12-25 21:36:43, Matthew Wilcox wrote:
> > > > On Thu, Dec 11, 2025 at 01:31:04AM +0530, Deepakkumar Karn wrote:
> > > > >  static inline void mapping_set_release_always(struct address_spa=
ce *mapping)
> > > > >  {
> > > > > +       /* Alert while setting the flag with no release_folio cal=
lback */
> > > >
> > > > The comment is superfluous.
> > >
> > > Agreed.
> > >
> > > > > +       VM_WARN_ONCE(!mapping->a_ops->release_folio,
> > > > > +                    "Setting AS_RELEASE_ALWAYS with no release_f=
olio");
> > > >
> > > > But you haven't said why we need to do this.  Surely the NULL point=
er
> > > > splat is enough to tell you that you did something stupid?
> > >
> > > Well, but this will tell it much earlier and it will directly point t=
o the
> > > place were you've done the mistake (instead of having to figure out w=
hy
> > > drop_buffers() is crashing on you). So I think this assert makes sens=
e to
> > > ease debugging and as kind of self-reminding documentation :).
> >
> > Oh.  So the real problem here is this:
> >
> >         if (mapping && mapping->a_ops->release_folio)
> >                 return mapping->a_ops->release_folio(folio, gfp);
> >         return try_to_free_buffers(folio);
> >
> > We should have a block_release_folio(), change all the BH-based
> > filesystems to add it to their aops, and then change
> > filemap_release_folio() to do:
> >
> >       if (mapping)
> >               return mapping->a_ops->release_folio(folio, gfp);
> >       return true;
>
> OK, yes, this would work for me and I agree it looks like a nice cleanup.
>
> > (actually, can the !mapping case be hit?  surely this can't be called
> > for folios which have already been truncated?)
>
> You'd think ;). There's some usage of try_to_free_buffers() from the dark
> ages predating git era in jbd2 (back then jbd) which is specifically run
> when we are done with journalling buffers on a page that was truncated -
> see fs/jbd2/commit.c:release_buffer_page(). Also there's an interesting
> case in migrate_folio_unmap() which calls try_to_free_buffers() for a
> truncated page. All the other users seem to have a valid mapping.
>

Thank you Matthew for the suggested change. Your suggestion seems to make m=
ore
sense to  cure the case. If my understanding is correct, with this
change the failure will
happens in filemap_release_folio(). The current change isn't solving
the case, as it
doesn't mandate FS to declare release.

As Jan mentioned, about the jbd2 and migrate_folio_unmap() cases
(honestly new learning
 for me, @Jan) this change should be okay. I will try and do some
tests with this. I will share
the updated patch.

Do let me know if I missed anything.

Regards,
Deepakkumar Karn


