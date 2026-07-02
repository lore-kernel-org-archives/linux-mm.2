Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57DADC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DA3A6B0188; Thu,  2 Jul 2026 21:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1D66B018A; Thu,  2 Jul 2026 21:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4676C6B018B; Thu,  2 Jul 2026 21:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDBEA6B0188
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:11:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 888A21C1339
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:54:03 +0000 (UTC)
X-FDA: 84944433966.10.D542080
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id E28EB4000B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:54:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GWosjpEC;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783011242;
	b=ulMntdM4M9y7sH94ui3CirHVecqIzrrfh+8bl+CJ+9PnWxWOSMmUAXjJRl1Vk4Ov6PrhxS
	mX8j/DKaiJ7oXa3aq6E/hQfn93tHwdQtaQg2K5IRR8oqLVbNqz6sahBgsJu15sfRz88fBH
	4xB2ZfEqdXzgEkCYXJwpuO2RCDMcShM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783011242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGNWDJlk6DwODfpBNfvuIjdfDz4b4TnwObejyBQmtwU=;
	b=HKNtpO2zXzoAofBW33ZY6royfijC0oFQPN09+WR8Ve2PGxKUkAyjVsdjhJcHSSHk+3Dg82
	I3h1Xx5UkON382xtiED0oBpmVANPFbdpk923HUCqBH3hmhe7Q21M9Vbb6Gh7TPzTuIIqNR
	LhHgu5/dzZp5zlw0tm204UA4FaqtSkc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GWosjpEC;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 839D6601CA;
	Thu,  2 Jul 2026 16:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAFC1F00A3A;
	Thu,  2 Jul 2026 16:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783011241;
	bh=MGNWDJlk6DwODfpBNfvuIjdfDz4b4TnwObejyBQmtwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GWosjpECJhOR/x2RdqukgEQ2EpEXIeCNjRKWZYAy5aXRnJkiDuCSvDA9iyxpYkFpt
	 WRD5z+f0i1+QGoIu9CXX7rG9Sdos/2XbPwAvyWExEOncrMtq59GhhKUD4QWwDNQa5B
	 +NPIbOWyz9wjwqOl3Owcx4VlLA4TrzBECaCHSiOB3zn5aeu5xg2jsyyyU2KvbDIFqr
	 DAV9W8tVL+fWp0xuQzEeFgndNqW0mg8MyUX1fKGJJNiDT6IHfTpLNUKOQrn62u+Vro
	 MX9zz8Vb+L7JsJE/3g1QMYyVQZWuTKuASCkqYPgpRgi1ovEaIUCHtUKpasSumpp39c
	 fwfzuVRlhQRRw==
Date: Thu, 2 Jul 2026 17:53:48 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Usama Arif <usama.arif@linux.dev>, david@kernel.org, chrisl@kernel.org, kasong@tencent.com, 
	ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com, 
	Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, 
	baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com, 
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
Message-ID: <akaXQyFlZi82SePE@lucifer>
References: <20260630164143.1595669-1-usama.arif@linux.dev>
 <20260630125024.6c079ea708630d99708e26f6@linux-foundation.org>
 <akTJsCTKZ5hMBf5V@lucifer>
 <20260701164613.008aa13cb6187ec9597bf652@linux-foundation.org>
 <akY_L-yuaCXBOXb3@lucifer>
 <akZis7j6xSjl8K_D@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZis7j6xSjl8K_D@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E28EB4000B
X-Stat-Signature: jst6whurop5e8byeazaobsbmmgoacyeq
X-HE-Tag: 1783011241-970396
X-HE-Meta: U2FsdGVkX1/TtX25TvWKFp+s89sleQ6xH1dYnk2ZG0gNO1QWckDD8OIyLVdgkuvoGAZ9L4zTq6iRo1uesZNy7FRdIN9TJif8jSVOt/byJDfdBRxvpngvA+ZR8eaSjQHJcfsFlB+DFXikzbGs51AGiAdna+VyTCFeioxZrr9p9gHpXUHdDZewlSFYMtntcvQQdKZP6q04fCWUQQb8gXFV+jA6nHM7eqSdZxo5bowqb5bpkJhqZH9jZ0nx/FAlZqe9EoyB33hOmI+Trg4ZTDB+T3wCt3csjIk9niZGElHS3KeU3wUIh3tA2GZ75yiYX3hEK9HQHk5UyaddTq2r6nZWwKnA1wPwT03daqTM41GvesSyx2v+Z5IU840L2iXFewzEGQlLFVh6XyhZmLPj+6doOa7PpSVFQsTj/Y4QcU1lzyk+6fx1dnsKTjs/mLKUayyqi1c538oYnnmFS3wNXbW+lrwcpLgvMMTfYrReXkiJSWhM9SASx3jctraACsMu6zgJNB6jRcRTyjXBhKWr5oOS/2jPvYOMMmV0VZv9XxDHsS0jMMV4m/u8DP+VRbVCtDcvtMVJuvuuhPP0E9ffbnBq94XfFipuDmZOTaMp4KnQrm395kPk0dtXRZ6sn31umY6oZFOAdwrPkUwE0sEX+8T4KBZGNR2boHYWxjs1YSt4SHTRBWWfU9zzklnqm3aY4gCJvhLN5n+rYiQHUThaQPbGvD4PUqkIfbqQC3x4scFjc9GF+eNnhLx9oLbUOTZ+qN1fStUDzdIl8FdMuPtIQpgTdwXsbfWAmmaw4gi1K7RPhPGzr78pEoF2w0kflk4dEgCIYUmP2mYcLjVDhcf3RzmlD2onrMWT7SQAsvi5ZsJpbU9b2bbeAYY05VFBo+Qjuqbr1TZlfnFp6XFem2vMORPXWqXCSAVcNVX7Aej+qVWaL3N1GmE2gbO6RJW/A2pxug6ZronglVuuBlYY5qMw1Qo
 2w+08gR2
 VPShex9cvrbTZtFgLhwROWMg1FOJIpLTtbfOVf4yMLZDEMXhOdu4MTP8n75ZkgDv5iiIZ91DmDtki+tmucTktOU6cR9ZO6DRtix2J/SuVMA3LEMAnnl5dsntQQ2z0Oe03SpqRDmCUs0kLQmqJ5t8DOMm1yrldGm3gvQssvEGETh6WrL+hY3MKx/2lAucwvHKSzY5ZTA9fWkOGOPb2guE2sbWX146WFO0JMC+E1NI58lb0EIg1sN+e6EQ29nw+uMEc3nP2jSBf5yFoZV38Mnx/Hter91ggDmHkdEJVhGz0jow2s0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Mark

On Thu, Jul 02, 2026 at 04:08:03PM +0300, Mike Rapoport wrote:
> On Thu, Jul 02, 2026 at 11:48:24AM +0100, Lorenzo Stoakes wrote:
> > +cc Mike re: CI.
> >
> > On Wed, Jul 01, 2026 at 04:46:13PM -0700, Andrew Morton wrote:
> > > On Wed, 1 Jul 2026 09:04:33 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
...
> > > > Hm, my understanding was that mm-new is where we take everything submitted for
> > > > early testing?
> > > >
> > > > Did something change?
> > >
> > > mm-new has always been a few day front-end to mm-unstable.  To protect
> > > linux-next from brand new material.  It serves no other purpose.
> >
> > Well it only serves a purpose if it gives us better testing.
> >
> > We have a CI running tests now though, Mike - is that predicated on material
> > being in mm-new or does it just grab the email?
>
> CI grabs patches from patchwork and tries to apply them to one of the three
> bases: mm-unstable, mm-new or the latest Linus' commit merged into mm.git.
>
> If patches apply, the other bases are not checked.
>
> This patches applied cleanly to mm-unstable and successfully passed (at
> least once :) )
> https://github.com/linux-mm/linux-mm/actions/runs/28544575927/
>
> > If the CI is just grabbing email I wonder whether there's much purpose in the
> > mm-new branch at all.
>
> I can't say that CI I run has a great coverage. I don't know what coverage
> mm-new has though

Well we're very grateful for what coverage it has :) and that's nice to have it
work with email like that also, makes life simpler.

Mark - are you running tests based on mm-new? I'm not sure where things stand on
that?

>
> > Thanks, Lorenzo
>
> --
> Sincerely yours,
> Mike.

Thanks, Lorenzo

