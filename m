Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF2FCCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 20:45:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550378E00DB; Tue, 14 Oct 2025 16:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5278A8E0090; Tue, 14 Oct 2025 16:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43DAE8E00DB; Tue, 14 Oct 2025 16:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2208E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:45:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC4ED140AD9
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:45:57 +0000 (UTC)
X-FDA: 83997901554.01.AE767D4
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id C18C5180007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:45:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=3RdVcyrJ;
	spf=pass (imf06.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760474755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ProMLWdJiYhd+ReUg4Q/nfu5OGup3NKBCnvPEIlS8hk=;
	b=dmj2RjNP9LWY4aDPJ5/vWPwGVJ1YAcMbN9pdEdQCYvBQOu57pQu1yRnHMIo/WtDNtjMB0y
	/GA9aceYExdvh2YP0GOl4yvKFdsq2/lHpg2Ff+0wprN1PkaByD3uwzMm6c95MdYAOvBn1T
	ZLydAehHW+cbfVeIQyZ9ECDmsjcQBIw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=3RdVcyrJ;
	spf=pass (imf06.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760474755; a=rsa-sha256;
	cv=none;
	b=J65/0/AzooEFwFIE1xQlCbpx2YIeWVizAiG9cIXyV907fWkZJ8MSOZ2zPZj956Lm8XUL4g
	/YM7ovyhKcMlUFH9lHnxn/RtD6x8kNFMnSUcbCNBe+Gdk6PvC4YV4F6kAOLK7T0tdRudYP
	K9PgB7z9Pobi6nwY2CcPkZW13qhbREY=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-781010ff051so4175253b3a.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1760474754; x=1761079554; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ProMLWdJiYhd+ReUg4Q/nfu5OGup3NKBCnvPEIlS8hk=;
        b=3RdVcyrJEdN2F6tZ1p721+VLB6T7iAMQJ9ONhDFT9Dbd8FAzLqJseCp/yG3JwBP05v
         a+paCzXv2bIWeF5FlHTTOchLgSa4z6QL17w6nN+KovHMMqHTPDnPGodZCkEW9rGTiy9T
         fpe0VEm9DDYQdoPJYZCnujelSohodsJP0pxEUVbBPTsTZAHzdWiOmy867kgLCjMY3u3I
         MkmvbTOMw+lq4fgltpF9xkmg1Gs+ZZaZT4W/pih8bC/OC7vdNADAY8eqPPbXes0m/cQw
         bciFF/TX6SxDEK/Gx0wUfQO+d2Si4X4WmIX2ZfxLPlWONdQiamrSbNovkhd4c+lqUDiH
         jAbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760474754; x=1761079554;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ProMLWdJiYhd+ReUg4Q/nfu5OGup3NKBCnvPEIlS8hk=;
        b=F1gQi1TzsgX6UiKM55TMQGVGfo3QS9mOwTdYkIP80JidzluBkuTRTiM3lQhQCPQwfC
         90G4Vx+IvI0pQo3WU/erYQarpjog57nk/NiAewey3WAVNHW2qdkbQX2/6GXD9PaPhz1R
         KK1g3bcWo3LZNl4TkFHdjVm/fJH0oRp0sAXIbtQlM1xfoICpFvzb3TTLzAs0zhaxxR66
         89+rvliWQ5Uvk4JeG/coyqhljI4+mPbt4B6VR0Q/JZ++k6LJlZANchy0IbN3uJldnWeh
         eX5GkQz8ZoxYGlLpTmvyzWTCc2tXcrSpZ4lgqY0aVap9erswUftex3AXMjNtlgMPu34I
         AYAw==
X-Forwarded-Encrypted: i=1; AJvYcCWnbNO/+1uS0w3Zo5YMh1YFZvJc2vE2SphxGMR7bJ0DyOI4j8dpq1S9Oxhs2pljfBNx06OzN9dHBQ==@kvack.org
X-Gm-Message-State: AOJu0Yz5nTFDGSbv6SQiZwkpX/bgqfQ1H87/kS/0jxH4IRk1O1h7f5Ic
	zDT8HYlWaNQpONfdN8pblnXUbeKQGPyj+f/9GPBDKDducW5OJy9ScQGwdIC/8dzGX7k=
X-Gm-Gg: ASbGncvGl99OBPvhRCKljOnnN3YfpGNic+zGrD8oz2GDf/q6rG1IgOtpmxEv0lcw7Qu
	nMgY74C1YVRVw1Li/IGg3qSQxu9NdAz2T0dQW2DLIM+efdm12YCh/LB/xQAR9RJBwZc09SPbyHM
	bLA2ZfJbP+5nqJkDjoD5cui28/rJb6OV3H1BZ1W6A0Pj+ucQtvkVQgZ15Ozj5TOTzBuxOuPgLhC
	uHKYowAGXamY83vzkObEylhpXLeYD2DX5F4a4Kx5CsMNrXhT+ote/dJGLb3i4RTZS/w9l7z8uf2
	mLCcK/A1F0qkg/kpGkFewrSJ7S559NiXrb0wDtT5rngbVPTK/eoTGTK6vMpYcUhCeHtJ9f9XG3u
	u7G+p7c8qQNjvIzPR/AaceKv+iK+sam/z8MHggd3911HKH8adUfuzo49HoillPjdXBj4t1oOsj4
	KVnCUIrJLVh+wcZ2qG
X-Google-Smtp-Source: AGHT+IEha/464YLIDe1S05FMmmIwJiiHJqNozxP/E/7ahWiUSHSloNCgr/S9uHudRNKH/rfSTuG4WQ==
X-Received: by 2002:a17:90b:3947:b0:31e:c95a:cef8 with SMTP id 98e67ed59e1d1-33b5139a259mr32044929a91.32.1760474754350;
        Tue, 14 Oct 2025 13:45:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b62631266sm16839994a91.3.2025.10.14.13.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 13:45:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v8lu3-0000000Es6g-0Y5G;
	Wed, 15 Oct 2025 07:45:51 +1100
Date: Wed, 15 Oct 2025 07:45:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org,
	v9fs@lists.linux.dev, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, ocfs2-devel@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 06/10] mm,btrfs: add a filemap_fdatawrite_kick_nr helper
Message-ID: <aO62fx2B5ZZLsRVM@dread.disaster.area>
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-7-hch@lst.de>
 <74593bac-929b-4496-80e0-43d0f54d6b4c@kernel.org>
 <4bcpiwrhbrraau7nlp6mxbffprtnlv3piqyn7xkm7j2txxqlmn@3knyilc526ts>
 <20251014044723.GA30978@lst.de>
 <qh7xhmefm54k3hgny3iwkxbdrgjf35swqokiiicu5gg3ahvf4s@xhyw4sfagjgw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qh7xhmefm54k3hgny3iwkxbdrgjf35swqokiiicu5gg3ahvf4s@xhyw4sfagjgw>
X-Stat-Signature: c1po4namkdgnnz8o6dm5g6fey45zg3p8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C18C5180007
X-HE-Tag: 1760474755-99863
X-HE-Meta: U2FsdGVkX1+0Gr9QV2uWcIsRc9ItZ2vpjE0DMj9FLv8A4ZoP5qN4xVq3O4LppCVUmXifEm6G0S9qbeVIOBOQW9fZ9JRC1YGu/jPkQ8Xee4EulabuYm1t6bNCZ0DSzqQKPIxV6wAZYABTTAhhuCAqGnGjbqNC+1juvUGxTyz7EHiX9g7RxaZvqeJq2ZLdxiBUiugve3JjD/FaFkx0FcGi0EhBPS2uMeN6N76Q+82G0Njdk+9WhcV4zkpE3Xs4pxiOi6yePFV+G6j2oOiORyzHk6xB6bPCUC0+eAH/vikbPDlsGzvrKfz/moNGoLwl1qJfK9Z6d/WhPAI/VUx+4x8kD/OMWH5+Hru47usPdBq6B/iC4XU4RiJrXq6CB97+xjiKT6pFlETsomWFC8Bu/ZfWp1x1bEGN+Zs1sE97EcF9zt8Ia9wm9jYlYJ434RzYfvFQyc+COIj5VOPGdKKgzLd9+QyFeaJa0X7ScsqzFRHUcjVHiK+jDvrxMQXIyiJ7NRw+x4P6kCLDajf1sBb+TOfXoE7dc3x+u8t8keF+4Fj6zcLfAr2u1zevNn1r+nBBiaf+78suOeY2lS9RsQEjKrjDO9nRvW9bU3fRrsRqID0pKcGENNCnswEzVLvllHmlSTVvHNLIcFGA17uwIdBeh9kY9C9U5F7K+bvQcCKzJMsf1IQ/ZIVd10sOvrXN65VN54aEeOF989XokrFYbObIRxc9i5J9vOGtngQTANk9F1sGHv9WJ0JI6p1tXHPFTTAFDM6vfjmSCgP5EHAk0zqX9D/nxtaEkGiXUtDEpakEb6V/pQYNKrzbs0Pc3tin4pw6rDYrDg69Bpy/teGmsVUKudE88vMbAAnKg3zfN/oKw4qVMLRLtFOecsn+g8Ai1Tpi6hNKe+iyRc2nxMm7QIqDwCXeuWIfbGAHiSQIh/Bb6NV2n4vehDR0bfXeI/xtsz9imXpIaxreKLH4WOy+b6YMEe6
 uBzsmS0+
 XvMVrLTWnkjsSzdHJFkFEBXkoFyFL9njcWwOUxtQXYBTaQWhyVM1orPAEYF9tycYeg2ivFiYCmDAhUPOyKt5nGuFg4ePB0Z8sLhvD891VUdWffkxX4GxjpGlqrDsLUnpA/kKvXxtEupJ93iIIamVn3N/yKDx2H8b5Kac5h4FPeU+GWHYls1j8mY8Xy7vIigvTu3VkTuwYjMWBweJZTANbNM+NMAYTBkM2uP/py11SoPPrg+oBfNOqILwEal4iCD5vWJXLnaBYBBt1auP5Ca7yQzMlkeNDloGgnVzTEIfvqUko/MH3ZIWMAD7O6uUKHwGLxuWpB43GYTEgEJqm90CgSQGDTWDWFtiJCHlyzO5KdTmMXB4y7tmLm40t8ggvK3CWhLj6r/kN9sndcyANDczx/kerR65c/5wcXUp9FNbCHumUoDX7B/avMu8Y3me1/pSIj+b3kO0tny9k8ht+yDSA2GC9rgNGMuGXAJQBgvm8X3260Fx+oqexwLHQhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 11:33:26AM +0200, Jan Kara wrote:
> On Tue 14-10-25 06:47:23, Christoph Hellwig wrote:
> > On Mon, Oct 13, 2025 at 01:58:15PM +0200, Jan Kara wrote:
> > > I don't love filemap_fdatawrite_kick_nr() either. Your
> > > filemap_fdatawrite_nrpages() is better but so far we had the distinction
> > > that filemap_fdatawrite* is for data integrity writeback and filemap_flush
> > > is for memory cleaning writeback. And in some places this is important
> > > distinction which I'd like to keep obvious in the naming. So I'd prefer
> > > something like filemap_flush_nrpages() (to stay consistent with previous
> > > naming) or if Christoph doesn't like flush (as that's kind of overloaded
> > > word) we could have filemap_writeback_nrpages().
> > 
> > Not a big fan of flush, but the important point in this series is
> > to have consistent naming.
> 
> I fully agree on that.

*nod*

> >  If we don't like the kick naming we should standardize on _flush (or
> >  whatever) and have the _range and _nrpages variants of whatever we pick
> >  for the base name.
> > 
> > Anyone with strong feelings and or good ideas about naming please speak
> > up now.
> 
> I agree with either keeping filemap_flush* or using filemap_writeback* (and
> renaming filemap_flush to filemap_writeback).

I'd prefer filemap_flush* because most people are already familiar
with that naming and the expected semnatics. But I could live with
filemap_writebacki*, too. Both are better than "kick", IMO.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

