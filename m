Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E0FECA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76A298E0014; Thu, 21 Aug 2025 12:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71A0B8E0001; Thu, 21 Aug 2025 12:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657728E0014; Thu, 21 Aug 2025 12:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54F308E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:59:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 09535117A70
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:59:49 +0000 (UTC)
X-FDA: 83801376498.06.645A906
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3D98618000B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:59:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=af+Hak+N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755795587; a=rsa-sha256;
	cv=none;
	b=Nc25/1SjJlQVYf8fK5BCkGuJeDSGVfSU76o3EveThsX0gsNH2XGkIBoAl9Q6Hq40/T3TMA
	MCK2gAGP8um7UUYteGoSDBzAQz/T2ueiCy4LfdXGZ8a/sa4CLSzCYYhvmmcbOF3Oji7/M0
	8T7EFcYQHGuSiNLRhVU2BxIndpbSoaY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=af+Hak+N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755795587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkZAa15LuBS2AmEIVvDAYKNM1p5/m3Ph4Sr+M3jkWbc=;
	b=gqar4bKJ21HN2ZoJ9LldeoPsphJJF0ZOlqWbMAE7IdCtL83xaGPQIZWC/qXD/yPICPX2ZJ
	3ZV+btsfjt0SDq/89m8bnOmzjy/0bxkhGRn4NRHNaDNwSiLqi9vFp0srE4WzF2eAKzKXI6
	GZdpjhv9n4hlMkxDiF5YqN/n8liqKNQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3111E43942;
	Thu, 21 Aug 2025 16:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A4DC4CEEB;
	Thu, 21 Aug 2025 16:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755795586;
	bh=pp/gk4pOi/0v1HmMWUiDkoQlsk+QIM6imhIi2GSSpK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=af+Hak+Nfuz0y6X0Qr8P866fWXKOmFsFqBUtxHcrew5O8pLnWjiqhMEcRwul5lFqf
	 uDCDxPRYZ1BuFhfghVTm+7r4DJWCvD+ES0luQVuh3/4x9Mio9Q9Yzn0bjAvy4EQp3I
	 3tgigV4T3NrYBKO4FVr7LkF0SpONlzLKAPcdDMQ8F0ZwA3Hc3HO69utwGNyFYsu0LI
	 Xnzid3gnttQZM4kZTUzOAs5IHLkuMBGVw+hZ6Krg4nXe/KsdTdSTPFMoxT+8RVAYg7
	 H0GuZPtY4Z0BcnLVXy3ZUiltSZMtcwU+VLqIB+ll+7ePtZufzYkWmSsMRfPsEJB0L8
	 63lviEWaVEnfg==
Date: Thu, 21 Aug 2025 06:59:44 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, axboe@kernel.dk
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
Message-ID: <aKdQgIvZcVCJWMXl@slm.duckdns.org>
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <20250820111940.4105766-4-sunjunchao@bytedance.com>
 <aKY2-sTc5qQmdea4@slm.duckdns.org>
 <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com>
X-Rspamd-Queue-Id: 3D98618000B
X-Stat-Signature: 1yew3t8w9wreywmppc5949m9ksosk155
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755795587-790076
X-HE-Meta: U2FsdGVkX1+LMe4rmGLR6PS4h9p42uG2heCvGsm4gEI7Chi1UbkIvdosIEgTfRcWrlP51g9UO4HeO3SPYwY+QxbuJNVY4wFugi32znVwQcoZT8SP2JJjvH8TCpN79oEeib0ivIUetGLwLX53PTV3EyOiJTOkUYoztVKz5TESDKe3FCaQEPe7xth3s0/LLmwCSWkmo+rNlnB5RY+YJVSjLv+5itTnomQyrzFsxIzaXVV0dQnfOXvSucQQjUYAtWe2IyBWgOCkFQv+U895L37vC6wk5dK9/iytLTeVqXtHV6gEbftNPwRJpt+Fk0lfRQ5CDJ7KAoMQ30c7zox2Ghzjm6COn/vjL0YWFfKZz/WDbkNop95vF6KTPhXv3dRVfc4b952ZeGM8sR7Ncd8ikrJQulyMrRNZElQTBzulpBTMENWvDy8xa6O3iZyCuCbmRLl6hTnxWEzps7OIb1Ekaf3kiuDt8Zz31WQwI5M9BrgYyk4qnKRBTorW/a5EIf2OL3rdTMOwzQ2RkF7FBNhXMQRj810s4lcz02UOShb7PUxfMHJ2YCiYxfWSbPAc8eN41kO++45k0Zq2ziihid0T+qwrkA01yY9dwGnja3VBXcNbOOfJUjliESjH5veR6ivW+qBFgCE+SDb0TMSbAilQh1D97FUlZ0n5xjHjL2SUyIU/crIrHdB8biN3t32pr2cB+dxKK7jMk3qj0CahVrAMcHlAyd83UDgjD7lQ3oQvTfYMGYYtokhMp/viCOr6xO2Ww8a+OEQgy+j+MWjAdnwKoeMI7K7/wlngpxTl5yv6760xk3rkxJo2Ypdq/Az0F1flzDtEtPhT9noXsAgnj/m5FOFcN3ri7HUkcegWAAiuYGkf9mLkvP52TMuqGRhnmJV1DSz4kyy08BJIAyYgYMLlFtgrDtvZ949uXiGg+QwHYk32Hx979vJs31BTkgXiE3tDsPaVD5OQrshXSMrhi05M+0k
 /7tvk8Qb
 xfgOF7guFNtOcTkWG1wfjhmhpSA5YOkny8tM++JWvvd9sS6trYfkWvWy89gyi14a9Q/tZ06JHM7c5ndTtS+neHgcKoXYZFLdaBaiBABYuukC9OgIb3Mbt9mIl6QaMVuOQ4DoVjzKeZUzYDVcK+2f1stI8Pbn6x0gn6xUAEnlGfv23ykfxFt0h50HfbdGW00g9Rv+l1vt4OGytMPW4jNWC/zKEle/p5PmcUbuHbL6rNMVqnBfM8SWSDNw2lsZiWU33SZmYaIecY1Q+FCE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Thu, Aug 21, 2025 at 10:30:30AM +0800, Julian Sun wrote:
> On Thu, Aug 21, 2025 at 4:58 AM Tejun Heo <tj@kernel.org> wrote:
> >
> > On Wed, Aug 20, 2025 at 07:19:40PM +0800, Julian Sun wrote:
> > > @@ -3912,8 +3921,12 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
> > >       int __maybe_unused i;
> > >
> > >  #ifdef CONFIG_CGROUP_WRITEBACK
> > > -     for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
> > > -             wb_wait_for_completion(&memcg->cgwb_frn[i].done);
> > > +     for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> > > +             struct wb_completion *done = memcg->cgwb_frn[i].done;
> > > +
> > > +             if (atomic_dec_and_test(&done->cnt))
> > > +                     kfree(done);
> > > +     }
> > >  #endif
> >
> > Can't you just remove done? I don't think it's doing anything after your
> > changes anyway.
> 
> Thanks for your review.
> 
> AFAICT done is also used to track free slots in
> mem_cgroup_track_foreign_dirty_slowpath() and
> mem_cgroup_flush_foreign(), otherwise we have no method to know which
> one is free and might flush more than what MEMCG_CGWB_FRN_CNT allow.
> 
> Am I missing something?

No, I missed that. I don't think we need to add extra mechanisms in wb for
this tho. How about shifting wb_wait_for_completion() and kfree(memcg) into
a separate function and punt those to a separate work item? That's going to
be a small self-contained change in memcg.

Thanks.

-- 
tejun

