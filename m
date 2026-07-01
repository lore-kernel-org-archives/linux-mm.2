Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8132AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60BCE6B00A9; Wed,  1 Jul 2026 02:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3306B00AB; Wed,  1 Jul 2026 02:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FBD96B00AD; Wed,  1 Jul 2026 02:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28EA66B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:24:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 973EF1A0259
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:24:00 +0000 (UTC)
X-FDA: 84939217440.23.07DDBA9
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id B5A22C0007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:23:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IZSf6ani;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782887038;
	b=eAWONVkl8xngQ4qnDVV3wrwJ2E6zyECgvFb/HKNxavsBfoRAy9OXXyge7MVkKgxKMwAk6x
	HNJV6K0FDHcyJPhI+X2bW0vSWZ0TthtAchTbsYu0desJMsBqGIjuEFQGXMTeDwlw7DYZJo
	7sv1cFZjlX6PpDu0BUn62bmxvUnhEGE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782887038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xWJ7lGSS4cy1ExwRI73Ip42ktEi6AnmleUk+CzcRsY=;
	b=dTElGeJJ0PuWrjNR7i0rakJk0la1TqtpIZB9QG38shJB1I/EkshV65WPa7guDE+erlEfgE
	3Kh4zCPt+vSB0afuKesR38ysyGIQVHGVcDQ0U6QSoKrHCBdfOLdpcmHsFU2JR/3LSU97Sy
	0g4ejr+kNpLDcL9R2ODfaYAslz7FCHQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IZSf6ani;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8eefd4a8057so3950926d6.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782887038; x=1783491838; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5xWJ7lGSS4cy1ExwRI73Ip42ktEi6AnmleUk+CzcRsY=;
        b=IZSf6anir1JjPzwwkOSfpRn97TVL8pQxZT9voQDqdnXxmCwjjxwvmNauaqutYN8VSk
         LSvKZ9gzUb4VIZ7GeLXLDyrKmfRUOmQ7c2fcP9HJAIfjOBfE6uCvWz/KpzTsH2hCS5JV
         w1O6ObmwzRTNOI9hF+eWUKkSOWE/lPbV8I8JTOGuSW3+mxIk4nQPDa7EfO9JVxdvBHOZ
         qreXeJFrBTWCrlcaKLibGiY2snmwoYfqMFZF2Pxuh+MDDkz9AU9F2/9upwDjmEICfXWl
         ywhR2BnH0Sl7rKmz36eECz0Q1azsY3mUQXnaoBfbufVY/O6hW+NlRM6dWVhmGNoGI6Lk
         fhRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782887038; x=1783491838;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5xWJ7lGSS4cy1ExwRI73Ip42ktEi6AnmleUk+CzcRsY=;
        b=RdjrtrCbovzJWwhZ5lB3ItQKHrdYo6YQOe3iArbXJl+jrxS89vktD5SKp9JAZKX+Zu
         N7NaSs05XC7WF7Wx/U3QWI7s44UCVThQ4Mxerc2GeqXf1qCsYqwbdHNPa83wVVfkN//l
         9GB4wb7VGT9C6+8AIvXPB5nNDKJzugoA8Jm+80lPwzDbm097zHm2GeHlk6yVWUadkxB4
         LCcC/Nwc5qVzrwdIqW7E0GiHl95uxdc1mYc2UA/9MtvUIMy4MtSTbHzjXj8KswfkLmNw
         zABwY5mYDzf6pfthvfPcpZu4jzsE9nKPSiz1X9a0UY4Z8TChGV556zjxERDM7QU/W1aV
         ny1w==
X-Gm-Message-State: AOJu0YxgFqgKw6zCi2VRcKG6sPesoPY+9dR6a/KG0PLOwK7iSBGxrgHK
	g4DH+MPd6ri8j82gOuwSxigr/z4tH7UGnyx+jD44Ko95+eu45+ZGbhau6NEaN1RgWI7a6fknN4O
	EvNBO
X-Gm-Gg: AfdE7cn9fDFhycwhh30YgXUHYgUxLBWPC31xNDF4oHavb9AZjkNdI6f8APuCUBZ8wse
	ziECyal2S/mfsO/4aEWYrh/FIB/q+m3RNokLihvQbdygllW86BdAcI+4gnhjaEh5zB01ak2SRdy
	hGsOB3PH/NDpUUQXw7Fd6zXzGZHr1Sh2YmMCN7znnGR/KeOBUEyloHPKhIRHAN4lAXDqW2nGFxj
	gVeUAH1qzwDLjwnOAkSNc1fw38+SBi/dw4B+gxNEWjTUB2mIFRMN97Qde0rSEEoq4em01tAp4t1
	1dAIOFHApcDLyXx5jH23yf5/NA9DHbcLQ3qxT7FA2PQp4Ff+y/p261jwv5m/WZZA+FG0q1tGHf8
	allgCOrTkNnSzA9/QcDfvYQT6etlmYgtjg1C6pgYawKZ1tO+IC07c14VlUn5Zf422jP2AoI5igL
	SfTYXRPQ8j2F0z1me9LQ8arZP3Ox9bhJCLsqiI4RH1MbUgESm5AXhLu3U60HGE7dKwJlBM
X-Received: by 2002:a05:6214:2dca:b0:8e4:d2ba:d677 with SMTP id 6a1803df08f44-8f3c7e708demr3649096d6.29.1782887037749;
        Tue, 30 Jun 2026 23:23:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f361ba3efdsm12323456d6.39.2026.06.30.23.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 23:23:57 -0700 (PDT)
Date: Wed, 1 Jul 2026 02:23:52 -0400
From: Gregory Price <gourry@gourry.net>
To: Hannes Reinecke <hare@suse.de>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <akSyeHnfcDmxnCSz@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
 <akQ_xlJtXNgnGUdf@gourry-fedora-PF4VCD3F>
 <abde41f0-7d40-42ba-a232-cc0538cd0e4b@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abde41f0-7d40-42ba-a232-cc0538cd0e4b@suse.de>
X-Rspam-User: 
X-Stat-Signature: sj1bhw54nx7p7c5bfhifgyqf5483ade4
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B5A22C0007
X-HE-Tag: 1782887038-173736
X-HE-Meta: U2FsdGVkX19ChqdCLNyqRMgNSYiiSQPHb0B2w6brQR7G4rnQE/0yKXKiTAD/l6NljI2U4HG9fFdcAu46ElTDw6RK0/anuxuTvxuYKetZoFkthedP+sJinwO/KVZfoK9ZDouLGFPs+vrrTEMaLyaGFZh6cRW+bd03Db4w4y1hA1A1PC4mVzihF9Ur1JHcUGzGBncZA6+E3oJ/+xtuFLZxzNvzHikDLoky1bzqh5uwFiMuOeBK/u8SQGVYGBz8rCoXZze10GsCVq0PDYRnYxxHdbUOY9ofyojUDh+CdaTh1ivf8x5myJtFT+A4gZeFliqV2cuqm4VjcNMmvjj7HSRpGvNHwaMwwiVU4ZaRrF+hUuPqHy0CS2erD0tytk5DsfTcvvedVW5vuj8/EwPIf/NPJmnBKU9ioaHjD7r6bTA/a5yvunjQ+XUlt3usNAvb/tk8xjs1KQxFEZi8QSm+EYg0E55xDiPiN8qb4NlZ87JNHI/LdfvB1XfaKOrugDh/0N9yAE+65PcTzzdaNoFXJ1t4SpQFXpSXOb2Ry5yPtkfsaUFSBf85l2gpDK+O2kgCyNngWq2b5Wm0NyAs3xZIB+I1UvVsLego4BFhNJRioMh+ryMgSbjYvcUuDC0y/DzLH4zvAayc0T7JLQyi9CFIlEOKlll0QlGQNnV5OasCr9R9Yig4wmb9PcGg1mguWFPDRJGlPsryVPG3Z2Z/1kf1x0NWSpE2u8Kkfg4btfKzNM/PkPpWpfQ1+39hBmxBiYqTlZEz9HEEL+GHUzzt7dOaGw8YdXYvhoWD8JVySb1jgfhsXnHlQBbIvdO/ykwb8HlSHgvarn4iDt9mygdEIDfB4pufjF4awvRlQZvKlnoZX0coIXROv26O4cF+9Q+HbDUhzMBbY3zDR0evA8LKTlMf/Lo8CZyQGABl2MN56/+prWELXwAhPU0DNqPxorHCyho5KGFKc6dO8GiMZoWs0+eONtZ
 xUOn/CVK
 98wkz7DhFbxnSwUZEpSQpxcicr5AM9TzTzVi+cAihm1WCG7/NyCYqNOsQUZFLLPgm8lPXZ9NpGMZ0nx7FtrY7Gk/ZlCUSI+rVEOrAMuOWJn/OnoSPIyR1JLBm+DVdb5magPTOZRdDaLsw3jLPj8CoQZRJIVKFXNlXIBNc4qS+7EoeWtdxPR9Sz/PJFl1Je7WylHChjYH8uCygSou+17F8/0MAYiyum2XRU9PZfwOtrpkineMZY7dyJHsf8ZUln0BH5Q2V8km7c4RxnltELI8UyBF/3c118q0ak/W4znsF/rnKkIepE56pYFkXIqBC/HjBkwj0UPKNpK5CFD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 08:13:28AM +0200, Hannes Reinecke wrote:
> On 7/1/26 12:14 AM, Gregory Price wrote:
> > On Tue, Jun 30, 2026 at 05:18:41PM -0400, Gregory Price wrote:
> > > There is no atomic mechanism to offline and remove an entire
> > > multi-block DAX kmem device.  This is presently done in two steps:
> > 
> > ... snip snip snip ...
> > 
> > Sashiko pointed out a false-positive, but adding a fixup patch
> > here that adds additional consistency.
> > 
> > On total failure - release all resources.  This makes the sysfs
> > interface consistent with the probe failure path.
> > 
> 
> Speaking of which ...
> With this patch we now have _two_ interfaces to do the same thing.
> And both will be generating uevents.
> Which is far from ideal (one could easily envision _conflicting_
> udev rules, one set doing an 'online' on the old interface,
> and another set doing an 'offline' on the new interface...)
> Is there a way to not sending uevents for the old interface
> or to make it configurable?

We do not allow "offline" in the new interface.

That fixes the entire issue - the blocks are gone, nothing to poke.

~Gregory

