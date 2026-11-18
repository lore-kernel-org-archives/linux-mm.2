Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 618F5606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RcbYZgYK
Received: by kanga.kvack.org (Postfix)
	id 6B32F6B05B1; Tue, 17 Nov 2026 19:25:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663906B05B2; Tue, 17 Nov 2026 19:25:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57A4D6B05B4; Tue, 17 Nov 2026 19:25:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 344036B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:25:37 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 427B21A05FE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:25:35 +0000 (UTC)
X-FDA: 85446346230.25.53C4732
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id B792F20002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:25:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RcbYZgYK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794961533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FtVx+bdZ2ArSXP0mcBKd/WQHCmPoQ5KtqvMi55F/xs=;
	b=aMReNK8qCmO6ZnRf6/zJ3AG6RNftJtCxy5pKk7bG12FHgaQqlO6TwTtFAZrtbZiL+A9ery
	oikc8QVZg4pIMte+qXXpFi/aIs2luhXkagenfDP6S21s9te6s9WPV9z+lXb3+m8xV1FsJj
	rYb1c78G6tPWR5RpQcx2c7FdNwIaqB4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RcbYZgYK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794961533;
	b=cSnLaPC/oIkB217wu1izDokfsGAOc6iK4rstRKeem0Ho+vLU5Ge4bCS4ZvMGiEzcUh55ck
	xb7UUBROfaDwAAXetjCJhHX8+m8YNa4zXc/iZ25cX1CtxWomDBIKhTrgMULK9yRvYyDnji
	3srFW9PI9Xo+Hskomn4Rm1CJJ3hfne0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F80C61D41;
	Wed, 18 Nov 2026 00:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112E31F000C4;
	Wed, 18 Nov 2026 00:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794961532;
	bh=0FtVx+bdZ2ArSXP0mcBKd/WQHCmPoQ5KtqvMi55F/xs=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=RcbYZgYKuT8rtNBavT9z0RMeM4rv0wQkI8zvWHGBOBvEBOgztWdMgNcwrojSs3pWx
	 HRRaFKWgBtsPJfe0t/DO4Bbcp04o4fMI9CXSTEo+D7alzjW73Kmofjb+seANrtRMXg
	 PbXFyPiP+fZj/bQNK3A3AMBPlvGQE2r2QDwBeOp0kkL2YEgx+WSPQZyx+ZCwm1Fctn
	 xkVDBtaBfAt5+4g9ucbO/tXTR3RX0McYZgbPwcNcNfrQ58eFBavf1XIYebevnXW4/K
	 A7jlS6YsGDl3fqMDvPR+spnQ2RThSzCEcsf2Oa0e/rpWh4VVy7jnhNwQN27f2d3G/9
	 4l3d+Yv1MXXkg==
Date: Tue, 17 Nov 2026 17:25:27 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
    Chen Pei <cp0613@linux.alibaba.com>, pjw@kernel.org, palmer@dabbelt.com, 
    alex@ghiti.fr, pratyush@kernel.org, graf@amazon.com, shuah@kernel.org, 
    guoren@kernel.org, linux-riscv@lists.infradead.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
    linux-kselftest@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v3 2/4] riscv: Add support for kexec handover (KHO)
In-Reply-To: <avLi0_mYXatBWmpL@kernel.org>
Message-ID: <6c377596-479e-439a-f68c-5d61fe40824c@kernel.org>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com> <20261106071459.2003-3-cp0613@linux.alibaba.com> <179415145358.358073.165272378597657083.b4-review@b4> <avLi0_mYXatBWmpL@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B792F20002
X-Stat-Signature: qqg1ywufdztwrkkiwybz4th77epea9xh
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794961533-367577
X-HE-Meta: U2FsdGVkX1+8307+X6jdZBGM87BeDuE38KkxJ+p3BScIEpg9pf2UG865zFBSNnFDD4ZkYXZ4hij9c6i5iRU2UJfyeFMGpEtRLHcUbWHbk+eHx9vBIZfNoeTTik9+lTgyI2rpvy7GGZU4M27qQKWHIaKNMdssURmuhSk3WMHY7rPl4BW58CY5hcsvU19f4dozLp5axds++BEtzQtntGthIbHJF9or/V5+++1tx+8MLRqQhAY4p4y6PYiIIQ+jYRVuCQlcO5eFu/NC39BDrY4hQ8NHDuhiR5ZxjZTPe7LSrgqvzdquzxMi10hyAJLkA7Ot2F/DKsDg6Vp6me0rS6b5y+zoJPEjhyrI68T7GQvMWMZVtKy4m6DyxzCZBPehtO8Cy4RqeLw/odWb4BrWPqfiIeF4gVH8F/8rynnLYuDKNu0h5oBnck0VzcvBizL/xwVKW5xn6uWrAWBDMlKwdlsPSl4dJI1LXs+qrfBpL9FS8Ta9wf8NnCtXAC2Lijix9LZ06nLGzI6xnR1fsYVZJezipS178oSlGZWJw1JjLtZaivHNAR4ncxWpY1xSHLwZMFdhbLVF8r9KrLdgao6hn+wfrg6cd++/2k9snHiD8ql/rD1mbLi4+5o6pbcdeIsjqTCXBDSU91Rq5H3FBtABlXdJdmNLqWdxbdISQq/WB+ocpxiZ6WZqfU6CvHCUayaEIoqfJGrtjuLrCG4+ewAm6OT/XyWCQ2yZEkdfM1W0KKSvTfz3wYasJK6GfE4iQ8RpdvExINPZy1Vh2ORC0BT5q3JGceVTgiKsAZZQ3kN6at0M1OwUwy3xZ0jINFndyD5uAeKptC4nmiRdeb7G3FIfFMP/FGpsoKKUgoN/ccyj+Q6EmHDF32abIY5SdvOH5x+kyC6hOMN3K8NTO+GuHxBQQzwAqHuKIlVxKiqzwzRnGP6iqWHpphR8OGftTOFIP0j1PhCOVCNfiR/ww4ZTBYhnB43
 5Fs1n+Yi
 j5LqDJ6o/V55lXQzQ/AxzQqoWusJYxo8Di9Hs51mo/6ww/9Q79BB2BAlYEYJ+yc0nws/YyAEuTP33vAh+UeKQyLd7+gKafhEr3wMZasWikaRHjOnmY9J/axbi79lc7Yw6LC0FTf7yr8+1AVrPQ+9oTK2RydRkUP/i+H6xKz4u7TSJFK7hjBgLh8wu1Z3rWwTxa/TgBKbQL0sDvF1uLnwiA2E1A+QJ6bKL3vaA1v13h0FDwUVr3zZhU1s5hZXPy/IxFUKwhN5ex1Kz6FVHQJOdPEpmxrVSMedber3y1KdwZNWft1v3fuNTzmk7sRfDWwHwFJ/MOfOk1skGcYJamP9qb5KmuxQGOv4yWeWYQn/SjL8RNT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mike,

On Tue, 10 Nov 2026, Mike Rapoport wrote:

> On Sun, Nov 08, 2026 at 10:24:13AM -0500, Pasha Tatashin wrote:

> > Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 
> > 
> > But pre-reqs. should be applied prior taking this series:
> > 
> > 1. https://lore.kernel.org/all/20261023054518.3258350-1-gthelen@google.com
> 
> I'm planning to send it to Linus this week.
> 
> > 2. https://lore.kernel.org/all/20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org
> 
> This is easy if we take it via liveupdate tree :) 
> 
> @ricsv folks, how do you prefer to play it?

Sure, if you want to take it, that's fine.  I'll send acks for the two 
arch/riscv patches.


- Paul

