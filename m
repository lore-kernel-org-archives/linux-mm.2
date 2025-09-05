Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 380D0CA1002
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 00:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948DE6B000C; Thu,  4 Sep 2025 20:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91ED86B000D; Thu,  4 Sep 2025 20:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85AFE6B000E; Thu,  4 Sep 2025 20:14:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 745106B000C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 20:14:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C409160463
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 00:14:35 +0000 (UTC)
X-FDA: 83853275310.17.5726C5E
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5213F40012
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 00:14:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HsdMlPej;
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757031273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsW/czUCbQ7OZLy+yNicQSZepTUp0JVIomaauiZ5/mc=;
	b=O9LOH2j22WzEukuhlJuzTTePM/TcCBgVGI4boxKmdeq1hc+9xEfRU7WKOgeck0ruz95+Ke
	dHqzlfrn7W5ydSlx/QTiusPSeaU4Sds2gKl4R9CNhzzO51qO/6OWpveajHuU2qTdvKdI2C
	XGZ+iCRl+z7cMlOpOqmmqweTJZggit0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HsdMlPej;
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757031273; a=rsa-sha256;
	cv=none;
	b=hRHTbDVXk8d7YbmPXf/JIZVNhehFIH4vD/UxUBBPvLhJ/WZa8h5hbNq1BJVYnbFs344k3R
	h7pMlPQQOSTPOiZD18bkYs98JfWu+PbG6QjUGTd3Q+uCnwLaGjHmiDEbANSvpByQVrl11G
	gTkGXPpYjtkOyBcho+No2C23AKx9qfE=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b48eabaef3so19163911cf.1
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 17:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757031272; x=1757636072; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YsW/czUCbQ7OZLy+yNicQSZepTUp0JVIomaauiZ5/mc=;
        b=HsdMlPej0G2xxNd8DH+dxEVm3I3G1XVRpYqVMfNzfX7xa/4VRxETWOhk9P1PMvUEqL
         313M9LfYlElNaMEAEib/UAcn18JQdoXomxpveuuvIVlSommOtzPmPj8lj8L4MK3H5brP
         HhwCNSaISPML7Ho9Td9UBJpwiUgOqzDCpcIYdwaNm/GeCtAQfSpyRfEazw0aG5+nzCH1
         Z+tBMtfsLg6juwmvzx1GVwf1a5w7wY/VEcMBLJp5tArdrnlcWiPezThQBhxAhyvY0LSD
         IEoV/k/JY9E6juqFzW1NRZy17oBAOXH/z3CqlVc0Z6JkDeKvk5McRBYYRJAejtUrTU6E
         RW/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757031272; x=1757636072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YsW/czUCbQ7OZLy+yNicQSZepTUp0JVIomaauiZ5/mc=;
        b=ZVjFDswqb1EL9hzgzAB2lIuCnvWgQpc6fyGBaT/VdFfF7sXQZGmL4EugPWry4x4zyj
         oqklWKIx7G9fSUvZWVtCidy52m4WzxoLMXOrb1ZSFOcyxaMNs239nW+a79rjcagv+yfP
         SXqKGP0ZrXMz91ezR6rTBkqu4jRFsuIYLu1xDzVthtuOpPSxBxJMCldnTdvr6AhbNvZJ
         2OutNZY/3tuPm5m80lbuBACDqfMUHKwPrJ36Pob3B6TSZZnLqv9Cl3oVFiwJQyiiCDdz
         fmDhPsvi4s0443IwFczUA2yIhvRi8acTN6dIm/k7TxFNL3DiqAoQeceMV81yJHUF3ug+
         S8bw==
X-Forwarded-Encrypted: i=1; AJvYcCWnLaGZZ7vpeDYtpEoLE3jxaIhHLdmxYGhXEmweOURvaWsAm7Gd9LhXOSqcjoMbWdFvTK3ZoOga/w==@kvack.org
X-Gm-Message-State: AOJu0YzjvQ7JTAK5RP5DfFEC2NDg/H6/5eDvKQuLdhFOQrcgV2ord9F/
	fS3rRtAN8bgBrQBHL4ngA+deY5VusOdBZRjgWWUm8GT4ot+y3jVERhVtpeznS029YB+xKysdheh
	UxkN0OpIYk5mYeNfQAxWofia+7ZVINOg=
X-Gm-Gg: ASbGncsxtwOU6ABvk26lOYfjMf2lgGtEcrIdVFG2fOWAD5dsXA7nRZQTYY5X/6x4sJm
	A6Gvj1YA6al9EppMzuwnF+munQA1JMx+jnKc/Y1zgoP6/BlgIqWnK4k/92rdZsjAtqPklQ4Fkrq
	QV0O4fBNPHinkH/ozC2XGropc7jsAWzHHG920H78N4p4lvN2BxAAVN5h+2czvisQPIPeEhRWwLi
	Bvxr4+3Y41DJqMW8Hs=
X-Google-Smtp-Source: AGHT+IGEID8qAurpsErvZKNzDIpmP9VV/rHLEbw2pWPHg3bzNSQDoXQs1n+nPyAcatHBOhMGKo32MfCxhIma055fDIs=
X-Received: by 2002:a05:622a:4106:b0:4b4:7b4d:281f with SMTP id
 d75a77b69052e-4b47b4d29e5mr130092351cf.52.1757031272144; Thu, 04 Sep 2025
 17:14:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
 <20250829233942.3607248-13-joannelkoong@gmail.com> <20250902234604.GC1587915@frogsfrogsfrogs>
 <aLiNYdLaMIslxySo@bfoster> <CAJnrk1Z6qKqkOwHJwaBfE9FEGABGD4JKoEwNbRJTpOWL-VtPrg@mail.gmail.com>
 <aLl8P8Qzn1IDw_7j@bfoster> <20250904200749.GZ1587915@frogsfrogsfrogs>
In-Reply-To: <20250904200749.GZ1587915@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 4 Sep 2025 17:14:21 -0700
X-Gm-Features: Ac12FXwoE8ZTOsJHqeSMAAV3bMzh9nzvAn_uf7_dz4rvHllVYtbQbbm-98UHeiE
Message-ID: <CAJnrk1aD=n1NzyxgftoQfvC83OO73w2E7ChvGHAh5xfxKrM86Q@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] iomap: add granular dirty and writeback accounting
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-mm@kvack.org, brauner@kernel.org, 
	willy@infradead.org, jack@suse.cz, hch@infradead.org, jlayton@kernel.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5213F40012
X-Rspam-User: 
X-Stat-Signature: x3g6ocq738zwi6s57garues7bprmy7m1
X-Rspamd-Server: rspam09
X-HE-Tag: 1757031273-223119
X-HE-Meta: U2FsdGVkX1+8xrO0uZWyaB6BPZ/TIuBsorp2p63YStYRb1dDuRdNZC+iUqqRKYNd9B7mj+5DIFMksm1XkzUsuWNFhVNYIVmLfM5g016ySSR983dN1zaVFqL/agoN6VYyBAcncl9MaULIH//I3N3zEGFdvXz4AXmjBhWe6CvsZ2y3pHa7UNSV8GMrj5Ryfxp++TkiPg56/XYrb4SMGfy3XIDEA6zaQy1KkBILD1CZb0Ch+75F7IR0sufanEqJIKFbEPhLhBAtLiUvcZOJJdTdQ6oGJeoUYzMhCWy/bTimVnLM7Vaa6jgANEqggXhn6/HgV9ECNk9LXhXbuXdv//6nQA0TKfLVWROpAPabJDwDQjk551R5p1OGB81s5wixQtSnruWInMskbmXmnBluMS9iOsE5ovNakw9yLDed4OTNxOaEiNmhCNgFMQrnZ8ZhjqpLZkLjZg9r7G62++ue1rTziauJ5IpOjWGJwXX7Of+OjWcF2H1hd6sfdo5KkI56UukZ56Vv3r8ZG+4gY/iLeQ4svnU8VdFCi3rwteGVKMhJvOzoz1wCuHCJtLG5SQ519EiQIF+dafpoBLBcL4h8zfvXtsC7tK6MIhHp/WEod3r91wYWyrGpQjpYjjz6biwlB1r/kOE5yi4fFcYFGXu8osZm6oODOQXoslbGwLqmaNwC28N6cZOWhqZRKzjB3CfsNOzRjSeBkfDiKm1TYp2bvjr1N1wV7orZuuxlrjh4lU3FNyRFdDocEPjhMQmhtbX3h5fE5tjwuguUi2132pgv/fiVMfjomf3zwGVnCEGfdV6jGNbkv7Bf0PHoM0iIb/hubKhaRdwRfFkx+lomV2qESuzy+DQj5BOttzj2hS/Wl6JaQRGx0jVAdFqD/72Ddz011ndTcCk9JJ3DBKml76ihps6vcwFnO3tLLCN/rFTET7YsKzaZgV4zYkajeCkx6Jq/7UKyZAxBp/pgwqQdpkmLrra
 TJOBvo3a
 c0qkx9dgEDN6LCEZoE1cqK9ezlnfsuS1R++zwRIMzdoCmu3CAIk5iO9CaYLuuSn0+lVrCeWJi7ADVyH/6Yiwm0aIxKYZDQFgS0mEdOwHUna/I9DoGyn7lbVinDVDu1IC/eIP0XXCuP6Vq36sqK6cb3dxAy2oaRU+r4DQrl0SnJ7tJ1nPd8QwqQePzDdaSVYnco1zxtyz0CFl/SdAnjyQdw69U0kN9pUX8D3ryjxIh0lUAwO3rjppfOvk8gm+3/06NBcjmdWo89IIJSQL9blkF9ApR5zCgPaJ4oZdmiiB/ZSmpaq7Frxw2v62RqMEUVZ/09BjcGMZAoe54TL3ZWzvTgqujJZjvVGyDL+C3b1w25cEoTlZAQjgG/tLfgbnVpUWn+2xMQNasPRoFk1W5/Mzy3XKnlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 1:07=E2=80=AFPM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Thu, Sep 04, 2025 at 07:47:11AM -0400, Brian Foster wrote:
> > On Wed, Sep 03, 2025 at 05:35:51PM -0700, Joanne Koong wrote:
> > > On Wed, Sep 3, 2025 at 11:44=E2=80=AFAM Brian Foster <bfoster@redhat.=
com> wrote:
> > > >
> > > > On Tue, Sep 02, 2025 at 04:46:04PM -0700, Darrick J. Wong wrote:
> > > > > On Fri, Aug 29, 2025 at 04:39:42PM -0700, Joanne Koong wrote:
> > > > > > Add granular dirty and writeback accounting for large folios. T=
hese
> > > > > > stats are used by the mm layer for dirty balancing and throttli=
ng.
> > > > > > Having granular dirty and writeback accounting helps prevent
> > > > > > over-aggressive balancing and throttling.
> > > > > >
> > > > > > There are 4 places in iomap this commit affects:
> > > > > > a) filemap dirtying, which now calls filemap_dirty_folio_pages(=
)
> > > > > > b) writeback_iter with setting the wbc->no_stats_accounting bit=
 and
> > > > > > calling clear_dirty_for_io_stats()
> > > > > > c) starting writeback, which now calls __folio_start_writeback(=
)
> > > > > > d) ending writeback, which now calls folio_end_writeback_pages(=
)
> > > > > >
> > > > > > This relies on using the ifs->state dirty bitmap to track dirty=
 pages in
> > > > > > the folio. As such, this can only be utilized on filesystems wh=
ere the
> > > > > > block size >=3D PAGE_SIZE.
> > > > >
> > > > > Er... is this statement correct?  I thought that you wanted the g=
ranular
> > > > > dirty page accounting when it's possible that individual sub-page=
s of a
> > > > > folio could be dirty.
> > > > >
> > > > > If i_blocksize >=3D PAGE_SIZE, then we'll have set the min folio =
order and
> > > > > there will be exactly one (large) folio for a single fsblock.  Wr=
iteback
> > >
> > > Oh interesting, this is the part I'm confused about. With i_blocksize
> > > >=3D PAGE_SIZE, isn't there still the situation where the folio itsel=
f
> > > could be a lot larger, like 1MB? That's what I've been seeing on fuse
> > > where "blocksize" =3D=3D PAGE_SIZE =3D=3D 4096. I see that xfs sets t=
he min
> > > folio order through mapping_set_folio_min_order() but I'm not seeing
> > > how that ensures "there will be exactly one large folio for a single
> > > fsblock"? My understanding is that that only ensures the folio is at
> > > least the size of the fsblock but that the folio size can be larger
> > > than that too. Am I understanding this incorrectly?
> > >
> > > > > must happen in units of fsblocks, so there's no point in doing th=
e extra
> > > > > accounting calculations if there's only one fsblock.
> > > > >
> > > > > Waitaminute, I think the logic to decide if you're going to use t=
he
> > > > > granular accounting is:
> > > > >
> > > > >       (folio_size > PAGE_SIZE && folio_size > i_blocksize)
> > > > >
> > >
> > > Yeah, you're right about this - I had used "ifs && i_blocksize >=3D
> > > PAGE_SIZE" as the check, which translates to "i_blocks_per_folio > 1
> > > && i_block_size >=3D PAGE_SIZE", which in effect does the same thing =
as
> > > what you wrote but has the additional (and now I'm realizing,
> > > unnecessary) stipulation that block_size can't be less than PAGE_SIZE=
.
> > >
> > > > > Hrm?
> > > > >
> > > >
> > > > I'm also a little confused why this needs to be restricted to block=
size
> > > > gte PAGE_SIZE. The lower level helpers all seem to be managing bloc=
k
> > > > ranges, and then apparently just want to be able to use that direct=
ly as
> > > > a page count (for accounting purposes).
> > > >
> > > > Is there any reason the lower level functions couldn't return block
> > > > units, then the higher level code can use a blocks_per_page or some=
 such
> > > > to translate that to a base page count..? As Darrick points out I a=
ssume
> > > > you'd want to shortcut the folio_nr_pages() =3D=3D 1 case to use a =
min page
> > > > count of 1, but otherwise ISTM that would allow this to work with
> > > > configs like 64k pagesize and 4k blocks as well. Am I missing somet=
hing?
> > > >
> > >
> > > No, I don't think you're missing anything, it should have been done
> > > like this in the first place.
> > >
> >
> > Ok. Something that came to mind after thinking about this some more is
> > whether there is risk for the accounting to get wonky.. For example,
> > consider 4k blocks, 64k pages, and then a large folio on top of that. I=
f
> > a couple or so blocks are dirtied at one time, you'd presumably want to
> > account that as the minimum of 1 dirty page. Then if a couple more
> > blocks are dirtied in the same large folio, how do you determine whethe=
r
> > those blocks are a newly dirtied page or part of the already accounted
> > dirty page? I wonder if perhaps this is the value of the no sub-page
> > sized blocks restriction, because you can imply that newly dirtied
> > blocks means newly dirtied pages..?
> >
> > I suppose if that is an issue it might still be manageable. Perhaps we'=
d
> > have to scan the bitmap in blks per page windows and use that to
> > determine how many base pages are accounted for at any time. So for
> > example, 3 dirty 4k blocks all within the same 64k page size window
> > still accounts as 1 dirty page, vs. dirty blocks in multiple page size
> > windows might mean multiple dirty pages, etc. That way writeback
> > accounting remains consistent with dirty accounting. Hm?
>
> Yes, I think that's correct -- one has to track which basepages /were/
> dirty, and then which ones become dirty after updating the ifs dirty
> bitmap.
>
> For example, if you have a 1k fsblock filesystem, 4k base pages, and a
> 64k folio, you could write a single byte at offset 0, then come back and
> write to a byte at offset 1024.  The first write will result in a charge
> of one basepage, but so will the second, I think.  That results
> incharges for two dirty pages, when you've really only dirtied a single
> basepage.

Does it matter though which blocks map to which pages? AFAIU, the
"block size" is the granularity for disk io and is not really related
to pages (eg for writing out to disk, only the block gets written, not
the whole page). The stats (as i understand it) are used to throttle
how much data gets written back to disk, and the primary thing it
cares about is how many bytes that is, not how many pages, it's just
that it's in PAGE_SIZE granularity because prior to iomap there was no
dirty tracking of individual blocks within a page/folio; it seems like
it suffices then to just keep track of  total # of dirty blocks,
multiply that by blocksize, and roundup divide that by PAGE_SIZE and
pass that to the stats.

But, as Jan pointed out to me in his comment, the stats are also used
for monitoring the health of reclaim, so maybe it does matter then how
the blocks translate to pages.

I'll put this patchset on hold until there's more feedback from the mm
side as to whether we should proceed or drop this.


Thanks,
Joanne


>
> Also, does (block_size >> PAGE_SHIFT) evaluate to ... zero?
>
> --D
>
> > Brian

