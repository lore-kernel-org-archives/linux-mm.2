Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FE7CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DECAD900091; Wed, 13 Aug 2025 10:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC427900088; Wed, 13 Aug 2025 10:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDAB3900091; Wed, 13 Aug 2025 10:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCB43900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:07:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8070D82B9C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:07:47 +0000 (UTC)
X-FDA: 83771912574.30.D64F1EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D8F3F40012
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:07:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gGLp84KU;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755094065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QXAZlCNvGhjj0PAqYX6z5I/kzH1X3h8hNhZCWturzEE=;
	b=Yz1aa1SHj1OwE2juqd2GIH7ViX6xJMFK6Knxrd/CkL5ybeWo1Z/aNgC7OlndF3RFC8YQaQ
	OdCvnfPbY1sxxcqdRvH9BAGo1axdavt38kX0lhtY1no8V2Ytuwfrss4PeNQdFvIIHVEWgY
	DZbAIXqghlAtESsLWsLnZ8eoi/CwKGM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755094065; a=rsa-sha256;
	cv=none;
	b=fhqmPwxXBGxC6iFAzZfDxVtTOUIPENSlbIi1rJbBUO4X+wfrkRj49SLkpQdIRdNuBMXK39
	J/lyzvxUqN79znXSrBBCs0SYRravUp6UgTX2nWce/m/CqP7VMjOcKiYH0cr7+WuETfnutZ
	IJrEHfz85xy9vRa7hA0RLBV8XlIwUBY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gGLp84KU;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4555A601F3;
	Wed, 13 Aug 2025 14:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74674C4CEEB;
	Wed, 13 Aug 2025 14:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755094065;
	bh=zcy05gnuZEZXeY7AcRHHwUP4PLtQj6zb6GUfETiaQHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gGLp84KU+EeT4RVlZZn1mxWiEgYlbumqzXI8nKzbJxjlVREp+Zs6ALnfyvnMfFErF
	 31fMPzmEx4EHqHpO6Wu+CvDMTmtPDQeTuasIg9iW97uzRuAkFrD3HVlkLpkJtdUC0l
	 ISlqWHNAoicN7z74YGHwCmCT5XmgE13ppqLFcXudAJlJePhowH/MHE5zDptawuAka/
	 PGrwr9CP1+eBvTPWXq0sof73YzBVS30gLU2D1l7w1WTv2nEV7hmDkoo9ZjYPVRVx+v
	 Z3z3FIshqVLGS6KWgkksnaZeqt4mLN6fbPaYtpbZk+O1/boH4govioIDHsln6O521V
	 nqV9cl+peU80A==
Date: Wed, 13 Aug 2025 17:07:37 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Shuah Khan <shuah@kernel.org>,
	Thomas Weischuh <linux@weissschuh.net>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/3] kho: allow scratch areas with zero size
Message-ID: <aJycKRCEqbW0pgwR@kernel.org>
References: <20250811082510.4154080-1-rppt@kernel.org>
 <20250811082510.4154080-2-rppt@kernel.org>
 <mafs0349vwd1i.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0349vwd1i.fsf@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D8F3F40012
X-Stat-Signature: fcmz7inct4bgbod8k8m4f7mrqm8prjpo
X-Rspam-User: 
X-HE-Tag: 1755094065-279342
X-HE-Meta: U2FsdGVkX1+yNzTSUZnpeobrfEC69Ktl7JS76oLz0bw/IUGNDBrAtKsT45QnZFvH93qYSRyH9BvRRxbPFa4fC364Gl9Uwfd6tRW1rl4V3HHWh8uBgbyq8AGDbF2aOl3bbzctXbcYhM2ETU3t4gF2i+3Ioa0DFSnZJtDC88Ho7Ih4zbISNGdrVIJ9rQbFwHiqiDWtyv/1HwRmtMxPB0oU29/9U6d7g7KG18xjI/c/oWyBDQir425hzpXR12cQ1bfH3G5+cc6qoc2nWmhpxWlqPT/N91f9HdYH2OHPSbPLG0OEHfiVok/7w4bdwOwtFyH/EPSTJqvYbCCQi1AjpaLZ60//YgF9aGDsZrV+MrOrxrfuuPtXW3hEDpuSHYUV0MCerv8MYHAjC2Mkpe7SGnZr2R2SyRnd/kga9SacFS5m5qMyJXs8PS1GIw0f/XPUaqiSo8Epw2o7mxpuKZH+zOw6CU5jiJtqe09Tq+k+4CJncpIRlUR64zFDP/iHDdxEDSfnn+3rYXUukSpbJsajQ95phBY9AcETD3h6Lat41gp2oyMMA3mWnnpzZAnedb6U8K8+xALAoWhPBCAQ5D7MCkuij8gFoikpNTVG9cAE278scf3HnsTt3iVHRkymqxOiLg8c9ctAACr6GZhYT8rI6xFzlRbtis0Y2II4OvqFEmh7Vli7ZZHXot5W7xzHrAsqUxsBkxKeM13xLLHTevG1T8MYCW3tcdcKGu/Xabt/zFww9fkA+Uem2v50IBUK7EWmXc1Yx2aH7xN0A82ZRs8PLa6bx/ef2uMW8/tgcT1gaI5hlYTBnNKiUwLlpo/QfSD5ejuncMceFd+lXqoiXSMZBdWzviSh99UlLvvh32pSChMxnQsdQU2C41Be/St6832MtF38+kcgSzxhceoj7DoUj874Lejo29n0RoJcyzFui+LsHclBxXO08aK+vd7GqiyjLyum3dbEfM9L7il5LSNOSr4
 t3A7EYRO
 5mxZlrIgRdbksc7USqaxZzpJ+zJpDZn+luZUVO97myH04/6fiy2jZljqELGpkTuCUP7nB3CMokrb84sjBS/id3UbpG48Rso3oK35dVAUiCW8XBxQwYNac+Yfxcx2uuXDLHOT1f1IpKyCAmFLMXma4y7N5dev2XMCtodnHt+YZ0RqCzOTCYJ2SaNmZLvbjk8ctft50Cnaf+KE3oRuCMbDQXt4MEpjiFXov1R2/bHc4j80WkK/ewHctI4fEBadJB2Q5TRC4mXC10sRJNS+Uopivbq60Eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 03:45:29PM +0200, Pratyush Yadav wrote:
> On Mon, Aug 11 2025, Mike Rapoport wrote:
> 
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > Parsing of kho_scratch parameter treats zero size as an invalid value,
> > although it should be fine for user to request zero sized scratch area
> > for some types if scratch memory, when for example there is no need to
> > create scratch area in the low memory.
> 
> Can the system boot with 0 per-node memory? If not, then perhaps we
> should only allow lowmem scratch to be zero?

In most cases yes because most of boot time allocations have fallback to
"any node".
And there's also an option to omit the "global" scratch and boot with only
per-node scratch areas, so I'd keep the possibility of setting any of these
to 0.

> > Treat zero as a valid value for a scratch area size but reject
> > kho_scratch parameter that defines no scratch memory at all.
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  kernel/kexec_handover.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> > index e49743ae52c5..c6ac5a5e51cb 100644
> > --- a/kernel/kexec_handover.c
> > +++ b/kernel/kexec_handover.c
> > @@ -385,6 +385,7 @@ static int __init kho_parse_scratch_size(char *p)
> >  {
> >  	size_t len;
> >  	unsigned long sizes[3];
> > +	size_t total_size = 0;
> >  	int i;
> >  
> >  	if (!p)
> > @@ -421,11 +422,15 @@ static int __init kho_parse_scratch_size(char *p)
> >  		}
> >  
> >  		sizes[i] = memparse(p, &endp);
> > -		if (!sizes[i] || endp == p)
> > +		if (endp == p)
> >  			return -EINVAL;
> >  		p = endp;
> > +		total_size += sizes[i];
> >  	}
> >  
> > +	if (!total_size)
> > +		return -EINVAL;
> > +
> 
> Looks good. BTW, unrelated to this patch, but should we also check that
> p == '\0' here to make sure the whole argument was consumed?

Care to send a patch? ;-) 
 
> >  	scratch_size_lowmem = sizes[0];
> >  	scratch_size_global = sizes[1];
> >  	scratch_size_pernode = sizes[2];
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

