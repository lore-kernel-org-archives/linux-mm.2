Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31B71D185EF
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 12:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762426B0088; Thu,  8 Jan 2026 07:49:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7398C6B0092; Thu,  8 Jan 2026 07:49:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679556B0093; Thu,  8 Jan 2026 07:49:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3CF6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:49:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10D841607A1
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:49:05 +0000 (UTC)
X-FDA: 84308776650.18.7D0F011
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1D36420011
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:49:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lt/FEwjd";
	spf=pass (imf03.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767876543; a=rsa-sha256;
	cv=none;
	b=frPYZUaF3YAnNsNQ3Qo+J6K9fI7XZ7zEt/tVP5R+mqRb0/bGog9SX9oO9b4DHbdBEDUpeY
	f4vaV4F5zG6YPN0Qo5asixQjZmN5T8NuPggrQhqA5lw4MoqyJ+ZZvjzKRTsjcBEDAIqXbz
	/a+PuyqgJmwjJWm6mVlyFqtMfGbRjkI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lt/FEwjd";
	spf=pass (imf03.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767876543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41tszTVbNyb1pXQ8d9AUh0ygD/K3N/1floSqYXpSeHk=;
	b=s6AxHRYmAMDGqZ+4uiyyLn2X5ZUPLI4W+MfV9kBF0oQRKnlP+SXTE80S5xuMB4CuD0fM8p
	wWlo/KUfNPzXkY5kdotu5JIokS0tGxHXfIwlaqdrA9t+O0b+mQrahnOs0xA6CsKNFXWih3
	5taparje8iu8rDHrieEqktPA6lmP4pc=
Date: Thu, 8 Jan 2026 20:48:46 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767876540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=41tszTVbNyb1pXQ8d9AUh0ygD/K3N/1floSqYXpSeHk=;
	b=lt/FEwjdv9cQk1Ejc0NPM1jhoA3VfUQ3CR4BWtX6aURYnKEvIyEzT/JdOtXzLkEq9rF2kZ
	mHryCyyxFAxHlBuV/YeIcOudNg57pGZAGLQb56iy3+rkn3x+4Fdc++OUcqJHUbinO2t0GB
	QRbGRvWdTKzhwAHDmKD9VVaHoOKyktQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org, 
	andreyknvl@gmail.com, cl@gentwo.org, dvyukov@google.com, glider@google.com, 
	hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
	rientjes@google.com, roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, 
	shakeel.butt@linux.dev, surenb@google.com, vincenzo.frascino@arm.com, 
	yeoreum.yun@arm.com, tytso@mit.edu, adilger.kernel@dilger.ca, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH V5 8/8] mm/slab: place slabobj_ext metadata in unused
 space within s->size
Message-ID: <pyhgduyryvfoxfb72hdnojd63fkgwx2jbn5r2h4cuthkki2ouf@ntuesnpnterc>
References: <20260105080230.13171-1-harry.yoo@oracle.com>
 <20260105080230.13171-9-harry.yoo@oracle.com>
 <fgx3lapibabra4x7tewx55nuvxz235ruvm3agpprjbdcmt3rc6@h54ln5tfdssz>
 <aV9tnLlsecX8ukMv@hyeyoo>
 <7uiizca4ejiqw6zegjwmou5va4kw7na7wivy4kxebrju7dsdwo@5brr7vhwf5oh>
 <aV-Kn8vfyL5mnlJv@hyeyoo>
 <30ecc144-ea2c-4259-afbf-3d96849aded2@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30ecc144-ea2c-4259-afbf-3d96849aded2@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D36420011
X-Rspamd-Server: rspam04
X-Stat-Signature: sp8yx77w6j97669uiu4w9cst5czo7a4h
X-HE-Tag: 1767876542-317965
X-HE-Meta: U2FsdGVkX18QBOoU9LylDfsqfPo8WuisFdhx96UudFG2/Z4waR6EEe8SOBHGcYsBO0jlApgpLWbS6CGSyV+APcRjsrsgvleEQEOJMM4zr32tMD9YC72+EO4r7dyYDLSO5vpPC4iHM6AeKDMM9i4lbBsbIALyrupPGT+XddGE3RHCiuH0Cw7SS0Ob0tBsP+xnfSQz9K2lq30Jh9SSLJp7QpVkvjh+BaOYmLqlKLaffrRCWcF2++EShp/VwFVHJ/yapZvmQHvviPW7w9sUf0rjOGMvfiyEpy1vllBgF8aZFCfAmznQ+L5EomU/2hI5bMQYrAyNOtj0Obki5dCCHDekHjih2bZXARvCcfRzRgyzswAeM6CqzJMwZXzyiTOe+HEbCjLvgi+gt1Kq0zTr2QV1GqYEcWE2YdpD0dLZvBJdQ6SMkfEhuW914RVM9PZ95nmullYZaa2OXAhg5Zf50VhEYjXFIFPk2hwOFKxt785DevXZM4qgHELbcFLCcZxCeesEsFlvIFP/wHDBb91hTwWmJttSMP18HnQJlTxF1ebbfpG803GB0MKbRRM9W4uIWpFQr5a7Hy3qPdgCx36nIw5XlT58/wTQRn6wbi2+IDuhoi3kB6cGfDkwSXOSy+XiG+V8RaMwtSUiNLWPEbTdUWHso5uKzfEp3PvXXU9OLLobt06pyTOrHSJrfe+5xtysA+jWQ2CopSYMODtpIctVdAZayiBDNWO0OfJhQUxta+l70fGsfTWl9LVs5EYCfRB5+WpfLIpjylm0kv11MywX/YsONLuZgzKxWvj+RqjZQ3pVjQlPWhcBiwaJ+sYgq+gLttPPuDoBplEeCe14crybB6y6b0NFUEweHotgPGTczjCtZjELsrriOb8KNGMxLYqYhnuSp55UimBn4ebpxeEvPcbtPF4wr3nKJmzZcS6LEsiHqY/g+cV8/LpzKJogmaY2HUs92wNpHx0lJnq296MFjy7
 GMEQBg05
 tLuCf7+iTbOXyJayBfmYZeuWQuGkLZvC55oYDdOB9+JwhRHBGF2C4w9qcR469Sdn1nAqyOKzEd2Mlj5kVybcnnOgqHRTyWHqxXbg9nxc+PGAKKj7WVpqVyhdqdrS6ABZXRW94zVvFrIr06gd6ieI8IppZEJ0SbIYbN/ItaVzfg2Cbg43E+64xObi24igqnU8Kb/47q3xdLlBEZS7LxPH9j9LEHXxlSukPx1j0cil0xCiNhgZ5RnY5GPU48WkGOf/iwwQUgwkZZ9elYShV1wPY4CElyrkxnwonTyMNVUG/XPkQdagxoyntnAWCX2uMY3Hixvr/PO3pzkTXyvw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 11:52:36AM +0100, Vlastimil Babka wrote:
> On 1/8/26 11:44, Harry Yoo wrote:
> > On Thu, Jan 08, 2026 at 05:52:27PM +0800, Hao Li wrote:
> >> On Thu, Jan 08, 2026 at 05:41:00PM +0900, Harry Yoo wrote:
> >> > On Thu, Jan 08, 2026 at 01:52:09PM +0800, Hao Li wrote:
> >> > > On Mon, Jan 05, 2026 at 05:02:30PM +0900, Harry Yoo wrote:
> >> > > > When a cache has high s->align value and s->object_size is not aligned
> >> > > > to it, each object ends up with some unused space because of alignment.
> >> > > > If this wasted space is big enough, we can use it to store the
> >> > > > slabobj_ext metadata instead of wasting it.
> >> > > 
> >> > > Hi, Harry,
> >> > 
> >> > Hi Hao,
> >> > 
> >> > > When we save obj_ext in s->size space, it seems that slab_ksize() might
> >> > > be missing the corresponding handling.
> >> > 
> >> > Oops.
> >> > 
> >> > > It still returns s->size, which could cause callers of slab_ksize()
> >> > > to see unexpected data (i.e. obj_ext), or even overwrite the obj_ext data.
> >> > 
> >> > Yes indeed.
> >> > Great point, thanks!
> >> > 
> >> > I'll fix it by checking if the slab has obj_exts within the object
> >> > layout and returning s->object_size if so.
> >> 
> >> Makes sense - I think there's one more nuance worth capturing.
> >> slab_ksize() seems to compute the maximum safe size by applying layout
> >> constraints from most-restrictive to least-restrictive:
> >> redzones/poison/KASAN clamp it to object_size, tail metadata
> >> (SLAB_TYPESAFE_BY_RCU / SLAB_STORE_USER) clamps it to inuse, and only
> >> when nothing metadata lives does it return s->size.
> > 
> > Waaaait, SLAB_TYPESAFE_BY_RCU isn't the only case where we put freelist
> > pointer after the object.
> > 
> > What about caches with constructor?
> > We do place it after object, but slab_ksize() may return s->size? 
> 
> I think the freelist pointer is fine because it's not used by allocated objects?
> Also ksize() should no longer be used to fill more of the object than that
> was requested in the first place.

Yes - being conservative here seems safest. Exposing extra bytes that
callers don't expect could easily break assumptions and lead to subtle
bugs.

-- 
Thanks,
Hao

> 
> 
> 

