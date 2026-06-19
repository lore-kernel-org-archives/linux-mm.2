Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41628CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 17:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0534F6B0088; Fri, 19 Jun 2026 13:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B5F6B008A; Fri, 19 Jun 2026 13:43:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C196B008C; Fri, 19 Jun 2026 13:43:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7B186B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:43:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B1551666FD
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:43:21 +0000 (UTC)
X-FDA: 84897383802.17.780AB28
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1E68A40004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:43:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gvCTDy8l;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781890999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kay5wp1i1E+dRCDTPAxSLQ9GOQ/50mATiU8b8y6jipg=;
	b=8QcVPu1sWlJM+PatS7IcobreRMvJxNCUArvFYwNGeaJnisCtn9fSTmEuHu1A/hZwGvghFU
	+sk/T8C6uhrS7ly9Qwckq+McPUBQOu8G7FW+3bbaqLI5cnMcqwzLbQTkiFtFsWqbR4C4qU
	CoZK7VHVg+nRXBtAyt4wUiT4uqWXmJE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gvCTDy8l;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781890999;
	b=5+0Af3zoP98kDlKRr1+KZJa6s46xhT1C+JpWmFLwhSNBpncaTVRhCrS0eJgBwyjaKEzT4o
	Vwyu6u27d2+2181stCiiT6K72qGpqhvhTZuypkLKGm+okTmMpVeHQDEgWj3b6EEMyrdW8k
	v3AhT0K4A22BjyyHnA1EvolMDDuduU0=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51765331535so260971cf.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:43:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781890998; cv=none;
        d=google.com; s=arc-20260327;
        b=ji8ltyza8xv52yhGDOdWUi+XgmjGQUISC2413rPdIbE35NRuEFWNB7gcdeKxLTfrig
         MJ5awzPSaIJ7bBc3ZCXemISIlG154NIEm8ELoIzd8VICRlSYocBOvsLfO+TI3byzPWYG
         w2bqkSbwHXScMpbE+5OS1nP4rQXA9o/gy8/M174us6PXfiSSxw/CIoU8sYuhcOUabpBZ
         2yePl3sbRmlJOsMEgmPuruWkxgI3Y0BtTFIIq3JNEa8+LE6ZjmcIlkQbrYDpdDa+DS2d
         LcQCHw2lYqYK2ARo/I/T2arQMnpF6JzB+QB8mGkDuWTODlPK+rCjP3AtHy+l7o2YKVul
         jYaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kay5wp1i1E+dRCDTPAxSLQ9GOQ/50mATiU8b8y6jipg=;
        fh=UXJu0ZpHC03k95DR6U5FAxX107/2rdpgN6/ZXwqppjM=;
        b=FkA30iGPXCvtsr7lVxmfMGOTABwVoBDdkjeyDSC8VSHOqYPMiuTpCPiXUlOpP4Vkoh
         6dw5FSHfY5jlnPDMv+PFgrOBbjyRGrNCnXYIa0puVO4sSKreK4rmb7LE6iskmU42pand
         I+8LS3C1qvBOwV2DhR/L5G22uIzDGlUfiIGaa7GTNURYW/V/nAAbRDA8nVhJHX+M8ifI
         3C2DfKOPpZP3rSk25+ji0KOn1IJEieGUtWwQlt6x58MmWpwDFwh3Id3XicThapR+AyjV
         9A1Tve6EqJCTnnl7rs875w0A32WdrGEL+YNDnRc8lo1di+1HM3u988RIaXkx26N+Vzou
         FZ5g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781890998; x=1782495798; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kay5wp1i1E+dRCDTPAxSLQ9GOQ/50mATiU8b8y6jipg=;
        b=gvCTDy8lIHaClg8Q2BoYVD6r+JNxivO4etfQhNJtwGERe0pZ1VILAhdxTYGtedjqOx
         ZU6aqT+xAK+Mw5VI0ubPEMFLTGg+O8CeLDCx4DaeUqD8ZyhC0/5B4/Z3JBQshOIWsVuN
         tIg02SGqMrwAa9Om2AYZ36Es5e50eu4JXp7vETkq3whPiBQwjn6mw9RuQTroSEhN4vGL
         hWFIggj3HiO8XGr+fLg2mYo0Qbs+Rd6tjwZWkcFHCB5PQ/jnYpM2wKBVo70UftMsuLd0
         jWMvKcvJb7iMZrqg5DbyTEZIzmjCPfxU2iCk5RjRNkTEEoikRlqE5tx4yufPHtR8wfCe
         GdfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781890998; x=1782495798;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kay5wp1i1E+dRCDTPAxSLQ9GOQ/50mATiU8b8y6jipg=;
        b=i3FZWHMiKcnTWxf5aHhjCdp9Ojch0Y9nOzF4Rpqww/suR9T3yjQIC6u3KSvlekvAH2
         NA+dlJHOvttHQ4xzqtt5qrEdEMncktSAZVtGSKckdE6DcBLzRh0RI96ee54ktRpdRc8y
         0546g49XYr/5gkf5tluel+wR6abTmujQJxyb5DGPY45jd8XjSWnRHlz03REqRawtFt8n
         M/j4KLSjKA3BN+/cP7QH+bNy+vkrbtPk7HbmmZ+blA0oVeMdR64xKtQGGlRXyPol0B87
         UbSxOcwdB9XF7eu8nmqYSM1GaV9SmtuRGRn4M8m9LhDew/Dg4beoZqu/6wsVJ580ct8V
         ugog==
X-Forwarded-Encrypted: i=1; AFNElJ/3Mbm0WU3KmTniRzUdSSsER2QyMjw+HLGMG6KS9ISs76WWg12fiwcSr3TH+eHQpyLA15yxhrogZQ==@kvack.org
X-Gm-Message-State: AOJu0Yzrt8R4GJBhw6FRm8udX5DnuAE2Q4PQgO0fw0J6//tMKGC/6JlK
	hIvD0vdoW5Xvi4qyZaqjfkGOqvufMtew81RYGWVUCGJX5yiVchSr5xrucTlkZV+usO5ztDzKaMF
	MkJ9rtUwYeePIAPYCAvhyOC/vBtsod4E+Agkk/wh6
X-Gm-Gg: AfdE7cnM+LsXUR4uBPSv4d7o7yyvD7st/biUL2WwRnHhdCBvqShSZigVb72ulmlFp0g
	pg2AJsyjcWutTY/Ch3sDYFvfhGcRY3U7GrQF5e34Sq4ay/+ry38qncZzq8rEJ9zq4zJRTs/PFrJ
	FpTsstpB9OezLApBzOsLqVtWd7ZIJoIdaWTzHpnCFWiq1619gvXoV+PjQOQWGf/FBBXyjv9A37z
	rNwDvP0kmPsITDagstxXzCJgSDNywoOQMe16A6AX0AIm3H1oGtqjkNddgopt7A/795b/Boo3YAv
	uheyww==
X-Received: by 2002:a05:622a:5513:b0:519:df4f:6c93 with SMTP id
 d75a77b69052e-519e4a70447mr8437651cf.20.1781890997445; Fri, 19 Jun 2026
 10:43:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260619112852.104213-1-ljs@kernel.org> <20260619093711.d0d37c9920b3a16394c356a6@linux-foundation.org>
 <ajVz1nhMn2JwucMY@casper.infradead.org> <ajV0TbwEyaKMzoa6@lucifer> <ajV49Fyogfa6aIjy@pedro-suse>
In-Reply-To: <ajV49Fyogfa6aIjy@pedro-suse>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 19 Jun 2026 10:43:06 -0700
X-Gm-Features: AVVi8CeEMjgy9L2eBvRLZA5Aw02A7ftxRU-GzBSdQ5yz88FNkOKgb6VgPbpFz88
Message-ID: <CAJuCfpGdxsPDbxOwQFdY+Xt7mZGFvoKWmed6FteTongvFgjgww@mail.gmail.com>
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead to
 VMA boundaries"
To: Pedro Falcato <pfalcato@suse.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Frederick Mayle <fmayle@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1E68A40004
X-Stat-Signature: u8erfgdigx13abkhn1e4sx7sa5axcb3w
X-HE-Tag: 1781890998-822231
X-HE-Meta: U2FsdGVkX18B+8GQTfjLq1AIQ2UFxtca139/iky+od1FRnlix7a5SriqPtk5eXqKJ2jtPFd5NwAyEilesTiEN0qad+fZQ5gTbw4VJI6/xRbnRZCxlHsp8DwfaoEJGNl5A4Pv9Lj9/EU2SICfHVLFDrj/AbbST94zdsx4hp1NMuGzcit7eUmI20drdiSsqTG1OeLACoLOHX3K7RTvnieS/ARapWxRV+dBwcJ7U7x7bUOfBYYs9XvDmSzjNswe1toHESO6S84euffDBzA2yvXN72E6s6sZveRJnZRJ9urByxfHbtre5KMVYqBAzgxETHzxs24puiP8K3fBPf/F9fHai/Hg9fn6VehAXx7FJwt6jwq8EWGiwO9fhwpkKyxQn9ddDI5mx1C+PQJvQD0lwq1MG80VI2WKnwjmzuSJh8ol8IyZzk51WwVSXlAh/D6KjV3FAlY4GvqVWG1fNh/8wc8EwRehXTQ3342Sp0wxvj+eA84WeKRWFmvRHNsty7TPUjZ6IUzYGvvpkriqpYeZWMDjX88GDDkhDbTV4ytBJqdCH2fy8QjWkyyotA5wJX7AYmn6uwjtAw3gAEypEzZ5R57yQDqZshXLXT7WYhSLobZo7ESrj4W/JHK9HCTdrXDC4fJTCBUZVc8iRYnR4VyYAQ1aShv/swhi9Xi32wWQCo64ZGJO3/fjkndC4/NtwKM7G15iBnQpECXuX80+X3SZiSV/3cyMefOAGN8hcpbWfh6BW07yuJ/SQzvBaJYBihmH6q0ZBsURiE/6g6X8nLMW7tycTsi7i77V96zODjGPpIZcWcHaN2Rf1w7/UfKDgekzCWDLWpIvxnEKzXARxNv6R7m2PhGWGNtLmKmgdxB8pNsi4JY6qayCBcT75EwFlEP9FAJq4aoXIbrMMpaFPeDh0liXO9pxIdJli2m/mupPCY2USOfu743gSnXll71RMeuoeZvX2GlBhGI/FIOk3gXsFqZ
 jFIo6bqM
 OU6byVFZp145EpMB5oZH8WoI/XowrtLWQgImUpvgnlpT0RThr5TQYbv+4SVORNvE3hExnnThgg1nOeLzq2jEA7BgE9kEsKHg9nwBX+wsfxYVmE8gbkMDKc5+GswvwAeEczlRjUQEWG/BtXeiCkoVMgPapOeDDuo9ZrRPnkpdFZ4sHgLLVZ9RD05eHwQXkex8BTqr3XX5sWxl5YM5dVrnSwix5THbvyERXCPUtsPSCMsDGt+jM536CppKwnZL7Ib52Jg3BhqxWJcq210P8BH2gfsblqJG5k1BxCZh1kYIscMQW8bCWOwpI0U62og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 10:18=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> w=
rote:
>
> On Fri, Jun 19, 2026 at 06:07:30PM +0100, Lorenzo Stoakes wrote:
> > +cc Suren, Pedro, David - I messed up the cc on this patch.
> >
> > On Fri, Jun 19, 2026 at 05:52:38PM +0100, Matthew Wilcox wrote:
> > > On Fri, Jun 19, 2026 at 09:37:11AM -0700, Andrew Morton wrote:
> > > > On Fri, 19 Jun 2026 12:28:51 +0100 Lorenzo Stoakes <ljs@kernel.org>=
 wrote:
> > > >
> > > > > This reverts commit 7b32f64bc512b40b268776c5ac4d354b325b3197.
> > > > >
> > > > > This patch caused a significant performance regression, so revert=
 it, and
> > > > > we can determine whether the approach is sensible or not moving f=
orwards,
> > > > > and if so how to avoid this.
> > > > >
> > > > > There was a merge conflict with commit de97ae6222c1 ("mm/readahea=
d: no
> > > > > PG_readahead on EOF"), care was taken to ensure that the revert r=
etained the
> > > > > behaviour of this patch and cleanly reverts commit 7b32f64bc512 (=
"mm: limit
> > > > > filemap_fault readahead to VMA boundaries") only.
> > > >
> > > > I'm a little conflicted here.
> > > >
> > > > 7b32f64bc512 avoided readahead of "file pages outside the mapped
> > > > region", which is clearly desirable (arguably a bug fix?) and we ca=
re
> >
> > I wouldn't say it's a bug fix? The kernel has always done this with no =
reported
> > bugs.
> >
> > > > about performance of executable mappings.  Whereas it isn't clear t=
hat
> > > > we care about whatever the heck that test case was doing.
> > > >
> > > > IOW, the revert might make the kernel worse, overall.
> > > >
> > > > If someone plans to get down and analyse that test case then come u=
p
> > > > with a new version of 7b32f64bc512 then OK.  Is there such a person=
?
> > > >
> > > > I'll park the revert in mm-unstable for now, but would prefer not t=
o
> > > > rush it in until we better understand what's going on with that tes=
t
> > > > case and what can be done to address it.
> >
> > As Willy points out [0], we've identified that it's a real usecase that=
 we're
> > regressing.
> >
> > There's likely others too in the real world.
>
> Yeah, the mmap usage on SVT-AV1 is a little suspicious, but I guess the
> pattern may come up time and time again for people doing chunked mmap
> reads. I think we need to take a closer look at this change.

Frame-by-frame mmapping for a streaming workoad is quite questionable
IMHO and I don't think we should be optimizing or encouraging such
usage, but I understand the reasoning for the revert.

> >
> > This approach has also not been without debate in the past (see [1]), I=
 think
> > this patch slipped under the radar on that front a bit.
>
> Yeah, sadly it seems like the patch _may_ need a rather substantial rewor=
k :|
> So I would err on the side of caution for now and revert it as well.
>
> --
> Pedro

