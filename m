Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5263B10A88E5
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 16:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBFCF6B0095; Thu, 26 Mar 2026 12:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96C16B0096; Thu, 26 Mar 2026 12:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4086B0098; Thu, 26 Mar 2026 12:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9D81A6B0095
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:40:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57253140E8C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:40:19 +0000 (UTC)
X-FDA: 84588776958.11.ABF158F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id BB2B9140003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:40:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oWe1AHWS;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774543217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYKlQ2o7FUUvHGc0tCvyTQqKxg3laNIlHyL2Hy6ob5w=;
	b=r1s4ugvDq0Mmqhg32YZ/uB1acUQZWQdjj7dYwubZIWtN+j+0Casa9s2RiZs5bwW9Lv1kFv
	DoJrOBEMaX1tfXTqQV6cdNhuAPKNY5tj9XUBeV/MqPqBnWslfzlpZ6ywmhBoRSI4EGl37r
	Xjlj6lGRCIKSn3Bnq3DnRzyfGlDObP0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oWe1AHWS;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774543217; a=rsa-sha256;
	cv=none;
	b=qtBVQ7/4gncZu/J2vyl6+yHFznHZ5u4SjGs5PZ2Caiw+pCWB/Vf0FWEO8jL1RCrM4TjRqz
	cs8KfyuxI5B/mA5zDp1lGLS0fIzsZdf616pD26mizG4ZpsVMeqOo5X1lSeKscbYWFpBnDU
	XrdvxrVwjRIyplDOsWpCv43X1ZWvnug=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EEAB600AC;
	Thu, 26 Mar 2026 16:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AD7C116C6;
	Thu, 26 Mar 2026 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774543216;
	bh=cYKlQ2o7FUUvHGc0tCvyTQqKxg3laNIlHyL2Hy6ob5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oWe1AHWSW+pwYbwC0VcqRbQdmlNq3VaXx1KYEsfhH6r9/QV24i8AergiggbHgGuSd
	 6M7dkjQuO2qD9gVUhDAGWRe9lp8U0vCNUayFKnEQyBfXPzG4Loaja8HMp1jITQUsm9
	 63Yd7NeYjqqMIsQDdGOuQZcm9y9pISfsqqBaxSAakjs9xH/DfI4yNRDdxBarKGtMdk
	 tMdWKCw3ZLD9A+iP+pcvn/2WHOU5PQA22Rf0crNlcDPxmHmhvelPwTDogBXIOzdy3+
	 UMlYBIu06ovaY6xJbp9X2grLD5o+bMcxiyzRq41Kn7ETRZzoDKgGtQM3bTOByydlDe
	 2QwAF7oR3ZosQ==
Date: Thu, 26 Mar 2026 16:40:08 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, 
	lsf-pc@lists.linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Alexei Starovoitov <ast@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Kairui Song <ryncsn@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, Barry Song <21cnbao@gmail.com>, 
	David Stevens <stevensd@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	David Rientjes <rientjes@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	wangzicheng <wangzicheng@honor.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Suren Baghdasaryan <surenb@google.com>, 
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <7b7fec8f-78ac-4b6b-95ea-8509d8ca95b5@lucifer.local>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <42e26dbb-0180-4408-b8a8-be0cafb75ad9@lucifer.local>
 <acVPrEyfcE4Naz5b@gourry-fedora-PF4VCD3F>
 <248a126c-43e7-4320-b4bb-282e0b6da9c4@lucifer.local>
 <acVftLYT301ITlsO@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acVftLYT301ITlsO@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Queue-Id: BB2B9140003
X-Stat-Signature: cbka99xstiaze8jf8k14m81a6fikhge1
X-Rspamd-Server: rspam06
X-HE-Tag: 1774543217-619860
X-HE-Meta: U2FsdGVkX1+dZTeyf1LAd8IgJ98hDyWk/qXbt2sX9BBb+H0Hcenua6QyKcOSmnoSNyKpCOm48p67rTycTtn5serIG5VIlBWgHDwt7GQfMoROaOKfMn5nP9CVSh8+/fc01ApzzaCrkgB9kHVLcN3mAUrG4nXNq/vViQatOxOx3pr+1jTGVVj+Z/pC4GhI5kSHXLXbd1ZttPMhgpAKW4CNtL2CpY2FJnJpcRgALK4VDxBC6W/McXFm2Bnq5N/N989wiXG8537VoYLdDddgcxzyZFmb+yPuEcj0tCe+0oTmhlevzkrKjUHouG25GPtpiC8n4pzXNgLvBTQEscvLaSccewF/ZmNJRJHVQNVoqMMe93szQ9piAfkZFVlICHPXf77oNJCvdB8jbQebVSRoNpnBH55tvGzJbK8dkrUGlLAYnKQTlvYcMcutP++W4/BpTV9bzAlt9QnqOhrHgZ3lQkHFeN2fCbv1J2bne/x2KLhPL7MtGV9PT9x2R0Dg/uEMZxwJL/QSftVcwaM9ofg9q3FaEWHbRU2fyEa1q8WV7ad695m6EPoqQmul0rsWZi2QGg77mAu25XWQBRgmixQnV4Q33LfFuTohHM7gbfvszvCGX/jeVE0vkXGNsWbmgxaTPuec/VLLnQYn14BdsRVM3/CyvZ4VZlgsLvGWdC7oI47+9KtP8DdGxfAirOF28T72hK4lPWSZX+r2QN5NvILoTE/awCWcZFxxvzIvEiBMRRTsbrxwNOCwQNPZ3U1J2VdcQUvAZ9IKTEb/c3doVb+uYdCK/5X3l1ZLo3IQQoBrdll/lKTrsf6k85wSBfI4Ue428aasqVXDFovk0yeCMst9SjbMl5w74R2I26XSzU6XZBu5U6uqjW4jpIGfdpaacE2b7e1z5l4jBcgQntkqXOe+0P9YG5g3Tv4lapLObJriqQ3eyJ0eLcRaadJOB1+4CAtVtzcdPjZ3JLv9jyIFmEKxhQB
 8rslmS3P
 xw8H2x8/7OkjKJWzPUyiZyDtqXDgovdm3KCVuD2AxzHUcqTV6DqLWZ2b4K2oe8NI6OeEjvlOd1YZBUNiXB4I1K+MPOcFYcQd97m0KldsURAS3OsI5Ae9HUGItXy/QyqguhwqPqEAdqgTsz68Ck0uYk+O9lTu0UkjpqNJq5fiYECsYk1tSKlMmUW36wTyYgimmJ+hY826dzl0XQHsDaYAVfp9F56YbHoylSTPgDcnOJBsmpDIDHZYcSE/6Q85hW7quxk4W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 11:32:52AM -0500, Gregory Price wrote:
> On Thu, Mar 26, 2026 at 03:35:28PM +0000, Lorenzo Stoakes (Oracle) wrote:
> >
> > Maybe a stage 1 can be to separate stuff into another file, because that'd
> > actually be pretty easy to do for a fair bit of it, surely?
> >
> > Can use mm/internal.h to handle stuff that has to link one with other?
> >
>
> Yeah i don't think we absolutely need to jump all the way to ops right
> away, and splitting into a new file would at least give our eyes a rest
> from the ifdef spaghetti.

Yeah as I said in my reply here, I'm if(def?)fy about the ops tbh.

But we can defer thinking about that until last anyway.

>
> ~Gregory

Cheers, Lorenzo

