Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ECB6CCD19A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 08:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE1388E0011; Thu, 16 Oct 2025 04:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A278E0002; Thu, 16 Oct 2025 04:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B938E0011; Thu, 16 Oct 2025 04:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98B628E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:23:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50A0AC0224
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:23:22 +0000 (UTC)
X-FDA: 84003287844.15.AB8ED5B
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 557C314000F
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:23:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=GnVLqwwg;
	spf=pass (imf23.hostedemail.com: domain of david@fromorbit.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760603000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0VUZMtcOk9KdtskCy8ElFmsJ9tky1TG1GiZcpekt6s=;
	b=1d8vi0LMw4KHmqaAMoNHP06wo80PLSHD9N0Hf72bHCaWmjJ/sXAbdFigyvy6rXuw7frnAi
	Q9rBYPELFvKb+mmGwAnl/GPhf8bYIxca6f55/kS7bgKrELewLh6SP/mw0CNLTEXaurbA/T
	2RojUeet2q+ApiumCdvAWBHQoWEG2q4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=GnVLqwwg;
	spf=pass (imf23.hostedemail.com: domain of david@fromorbit.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760603000; a=rsa-sha256;
	cv=none;
	b=fTRwg86Qma7nvcnUmSpCpLWoVxvDFEgnhvYmZguVC4RbFkvsn3BQwzUjkiwfruqnAj2U68
	rSbpJ5WCnJtuEANOk1/unlzfBrsGVYjMBaw7nj9IwQOaM/qBr/lqg3Bv5hXkIyOPiPFrFt
	zILxDapS84vMSzVP7TVHMRBUWZoPP74=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2698384978dso3451675ad.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1760602999; x=1761207799; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+0VUZMtcOk9KdtskCy8ElFmsJ9tky1TG1GiZcpekt6s=;
        b=GnVLqwwgiV0BDTZtjTrCKmNK46R20eaRbYoZBiq+Pe5wkKUyRDLrexHHnov8rbJ8o1
         oy0WXsgRhE3gGR2zTkynlIyrEBfahXZWaKkziVWFpgmqKV1FMndz4W8Hzgt35TF1XUlQ
         5hj9etcnObseXcIGzwMwjno6lRVTpWCmLE2PCsAqnGA5ihQX6syWD9LUOSzmVUhIqwbE
         +LM/iqGkcOr+2NoUzij1GwHJdQFOky/rR3YSk/gFkDZCcsbUQVgxglpCTEK+j+Cv5V74
         V/OxWI+DV5CFXG54aAlLra1UsAEeKdnvPM5iW24FnmOBVYL4rC+dZeJ4CCVjiqZ82Myr
         25QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760602999; x=1761207799;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+0VUZMtcOk9KdtskCy8ElFmsJ9tky1TG1GiZcpekt6s=;
        b=fp2VI6RKTIWx/ZRda60mndO9Nt5uv/X7xsj95NLmfvKCemrzpe9qmDJme2LqTO4K2x
         dEkbh5r4HfWbDx9e7sRFP1P6acXs88X58Jr9a72zbrT5wh5XhV/zugtEBk5fpegQx1Oo
         rAFwrJONyET5pePNlXK+tl8Al+XrabU3oapXvivdQPOjXEdhA2CGjfe5Bs2wYX7Lib1L
         AUCLPyLA2h2jafY25Ilsigy7jNxh+NwFSq5dVGdTXnNU1ZfhHfdm1rSGWcL2wtiFwQ15
         51pTDhqMmJYlDKLsLhTOI+Hddh/Y4BgBGbnvOXrC4zY9h8B2/sX8Ra/LREKG8STR+/QQ
         rSIw==
X-Forwarded-Encrypted: i=1; AJvYcCUoy/bPLYChkWDyE+ydwx25S50FPCB1hNmR9nOJvT37Iqh4XTmh/VBy/eE5xpi7xI7se+tjWpNhbw==@kvack.org
X-Gm-Message-State: AOJu0YyZLYGQJxlgXRt1G6Auizht64cxM8Fe+IXF7FkT0qKwU8woeFJE
	KV2iFN/h8n/q2gipLaWktZbFTNNnwgTPa+Hhk94AOD67LgZnoC6n8hj+9V39H6nOmyM=
X-Gm-Gg: ASbGncttGmej2MqG/ZqxJB6RQYEkde9Y629vK9Nf4LEpeE3mcbYN/n6pFSl41EinqnH
	CcYx87O1DbRO80iAylxN/wvlfIcRoWtEb+KcHO20J1Cbzj4/uRVnPOvTUOHtbqjpIhg2MpBmcR/
	SU1x0EzEH8LjWa1F9+w96EoCtGjlEp1/UN9GNynzQoPJUbESwZXvUl6nJr5/Oe3qWIeQWKWfwk2
	nnN7DyU6ygJXEM3UlvJ7RF81WkZipxEvsukWFL0v+BMlrdooGvtgyiiU3dFHlCa+gJ4i2PgpjDa
	828jzm1bumpP8dbvf2cfBLuD6cb3Z7/DaC12BTKMkQijbbqia0T3iaAv7EGOsEVGVax7rQp99w4
	kZkHDDncy0sF36eOXBXLCbgYlp3nkx642wMqnXReGA7UsvHyHdzwXOBrvNO910LxxSeNt0hW9Mi
	P6JwOFa/vAtREzF3WCeBaCfE2c6AKVMJqrgHeCcoQn0jJxEqRBGSabtzjqqdgyRJ5k6o/ICQzd
X-Google-Smtp-Source: AGHT+IF1CQThIQIcsUYNeKF6zSjisAw+PGIYgUlb6D8gypneTiF3iak1UWrAgN1vx7iI8WrWlF2NeA==
X-Received: by 2002:a17:903:1b4b:b0:26d:353c:75cd with SMTP id d9443c01a7336-290272409c7mr413436515ad.21.1760602998773;
        Thu, 16 Oct 2025 01:23:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930fd3csm21322745ad.12.2025.10.16.01.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 01:23:18 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v9JGV-0000000FW7S-1kMH;
	Thu, 16 Oct 2025 19:23:15 +1100
Date: Thu, 16 Oct 2025 19:23:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
Message-ID: <aPCrc5GvQRkwmTOU@dread.disaster.area>
References: <20251015062728.60104-1-hch@lst.de>
 <20251015062728.60104-3-hch@lst.de>
 <aPAI0C23NqiON4Uv@dread.disaster.area>
 <20251016043958.GC29905@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016043958.GC29905@lst.de>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 557C314000F
X-Stat-Signature: ph4cyawkyhr9n8mk7yt8zqcioztysxcp
X-Rspam-User: 
X-HE-Tag: 1760603000-922
X-HE-Meta: U2FsdGVkX1+/0MWEHh1meF1Dk2KEyl9SmgppFeb1gN1e5P0JZrmLC4iV/Rt+6cejbFmCnlsGREzwT4lAWWBRDYISYGl1NYdw+NjRi17Ao8EcBF722ni3x9AhMLOlzjJfxzK+7UcS9vxMTRywcByUaGYK/FXWz29+xJFHUb2lvZOmRI/+1wy82FKUSc0PX/KY39vsdGpcbHKcOt4wPtjhy0a1q9MRwdbe83V3BG4MSxLB+PotGYXTjhVDBqVCNLPi2qIiGYHtvl1CSLwvQh/UL1QUGKoIXfRBZkJDZIo2wUaLqH4Kq1Yx/dI0naM5SLWt3l3NbDAeJseXJUETOxyxOBvtxWvZ7++LwROCOfXFjcrwtE8hoo2rSP70nsgU1MrShOJ4QcyWBBGXJ/1hFB6a4nGWCvYT4ItCF74d2z8Aq4brRcpfcAJ3o2dnlsHTOYDwzxGjv7FBHoiINq4Pb0p+D24IykyuG4OsZa+EJNfoqzvJDizeslOblWzwFZHtvmPTS/c6uAHeL+7tmbLXDWoG9BuDuBi2yVdMdGBm2CCpXlU7iqaBqme/pvrtZ0HTmW656/6j8neW+wdEbj1jPYgPuLALNgv7vrWsBe6uSSrdIjNQFLbqOYJDPHnkYVrfx/aMSIim1tmWZrjW6aaXUc+EdTTXIVpKgYydGuqIGDh0ELORNAIOqosMUhVYearHRQP6lQ77P4eTfuJ/9yGi2mVb+kJE/l2J3hgx2zCUhUVUsSTiFa2rDq1MNF+sdErHx7ELU/CJA2VcCNLLPZgjHCVJHHJ189qrRVO54LIQ+6q4YPsJoJHQRn1Mx4wK3CZoHyLEEt7l8LdGyJKG8H34HM/LJT6XkMWyrE7oJJGzQa3OAIVwTun5dOyX03PSPjT31ZKIBRI7Ji5vqqCRnDeSQrB2VWwyhmxGhVE+ZDejFNuiDSaQf8ZcF9zq22MDCTX8dZGk+mzP8ph0IWN68dByrvo
 IGck25Gq
 mxEPZSont8T+Ejfz9jwCdAOmgmFsO8ZvporwcA8vs0zKCc+loqoElDpdIdrRYyv2S2FLuSrO3S+IlVEztOJVHEB2Bww6S7E4eK+kbvl3yrTI27eOogp32Fiz6ppa2C4tOiire3tmWu/dxdbWtzGOPL1G21msFRq7TosDESD+T8UP1VHC1GBkV8Joz9ZiXLlafvRE03iWKs7jPFVMFGx9Zp439bhaYec/bijlUPp5m8cd84z4oSLN/n/1eT0RnJVuoUmBAo1C+BlEjy7OZM/79hdu9ElPs961f3KwUbDvwMgoqJte/Chw4JTN8UZelHvvR3JP+QIaPDeP2w43tit9Nuzzez2cIGQKJpEZNBsp+XHNGCw49+Un4SGyC9AkuHBmWIR6CeXLFlM8jW4CX8Eed/2NHBByD/+Qe3TjbHSzC8L7nt+HzeAd3G2bVGPC6Wmc8dq3D15YuzN9Yt/0QfmcrjV4+oC98n0vWjW1xAMREaNUx2tfFQnAbS2r7PA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 06:39:58AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 16, 2025 at 07:49:20AM +1100, Dave Chinner wrote:
> > On Wed, Oct 15, 2025 at 03:27:15PM +0900, Christoph Hellwig wrote:
> > > The relatively low minimal writeback size of 4MiB leads means that
> > > written back inodes on rotational media are switched a lot.  Besides
> > > introducing additional seeks, this also can lead to extreme file
> > > fragmentation on zoned devices when a lot of files are cached relative
> > > to the available writeback bandwidth.
> > > 
> > > Add a superblock field that allows the file system to override the
> > > default size.
> > 
> > Hmmm - won't changing this for the zoned rtdev also change behaviour
> > for writeback on the data device?  i.e. upping the minimum for the
> > normal data device on XFS will mean writeback bandwidth sharing is a
> > lot less "fair" and higher latency when we have a mix of different
> > file sizes than it currently is...
> 
> In theory it is.  In practice with a zoned file system the main device
> is:
> 
>   a) typically only used for metadata
>   b) a fast SSD when not actually on the same device
> 
> So I think these concerns are valid, but not really worth replacing the
> simple superblock field with a method to query the value.  But I'll write
> a comment documenting these assumptions as that is useful for future
> readers of the code.

That sounds reasonable to me. Eventually we might want to explore
per-device BDIs, but for the moment documenting the trade-off being
made is good enough.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

