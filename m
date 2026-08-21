Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C11ADC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22CB6B0095; Fri, 21 Aug 2026 14:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3BF6B009B; Fri, 21 Aug 2026 14:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE97A6B009D; Fri, 21 Aug 2026 14:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8579A6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:42:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D819C0207
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:42:06 +0000 (UTC)
X-FDA: 85126146252.14.EC6C2F9
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4EFBA100005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:42:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Qpgb/ByY";
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787337724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZJ1gDUH+GzGBn6NOh4hEOLkLDX+Z7WrRip/EASVTmE=;
	b=k/rNzeG3m8JnAOaF46BQsns9g0NEypbY93eYb43AFq8KTNph9vxkq6emdI7UHsSo9UQalC
	qH7XCRVpbERtA/AE9SBXkDhl/VuR8EjyBK/Zf43aHAHdC092OXJvJHj8tVVi/AMw5G9kpI
	AlrYIkqR3/ExRABUmu7Z0Y/jrIJtpts=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Qpgb/ByY";
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787337724;
	b=TUsctfQFMOZi4URconZrx2lm914QoZxdF6IqbvIu1Qj/sEEXYcbBhEq8fWK7y7o+XX8tWB
	mN8JLwFeqsG4jFpb8G7ZiHCjdbazgK3XHMSmPVhNebiNvh7sZzT28zeapCBRXsFwbV4dts
	eoqGpGKCnQXBJwXtA2GlBf7AE6LYQ/0=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8f1e274ccb9so7133826d6.2
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787337723; x=1787942523; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7ZJ1gDUH+GzGBn6NOh4hEOLkLDX+Z7WrRip/EASVTmE=;
        b=Qpgb/ByYzEjePEx72w3th4K3pWs8/kKi2QkeqxdGyBjgzO6+Pt3BnYDkPfduC8H3Gg
         GspheoCT0Zs/KPo8GOBbn8jSr1jvPCXX7OzZRNBtzDfmeWU/O1tHmpJWzjrPNJZyz9sy
         ivydtyGDr/4PI0/zlz56SdHNO1y2YdZqKmFTPWH9TAQz2PPvZreS8U7d1UASzdbGL5Fe
         0JPQ0a7F5BkIl4BpI9MMf6vToSb77JpbJxrHNSTQduRpVJBlt2F5wQWWp6f3nDLG4lZn
         EPXJC1Ng6qszSa8wuZcoZQpcChb/B18SPZloxM6eIdMzhLOrTCsig/0X0bfPxQq+mLMv
         U9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787337723; x=1787942523;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7ZJ1gDUH+GzGBn6NOh4hEOLkLDX+Z7WrRip/EASVTmE=;
        b=QhHmHbheeJJTHnCkcDpUoS5N9y80tNAvfd4tHeZ8isFMd+ScCy7/x0+yzOjcsy0Gpb
         qIuvr/nI/SiSOXrtBbtF6t6Jb7hZdM+1le1fV2pStwHrRVUw98nnGplsJOo/IDCjuGsn
         SXSQjZDru+mEa3g+03wZ//dikJsCaBEBFDMxA7JwgVDYDFZRFA2OHEw6hthxTQKHwMUw
         xEydUlaL5EtkBwEkk3UsOfUm90PkG+BHy30OmyBtONtEt2xGX7rayy3Krb7tMZIOiw2l
         y7fzbXTldEYJh1u+AhsvN4AI2/2U7j7CUWmGqppjC7u58cNzTdCJZV5TvJIwvhN5NaPV
         xkNQ==
X-Gm-Message-State: AFuF++nc8YFfHA3acxtEq9SiGbEzv84OVTZQczFtKYw6dhSld6nKDiZf
	WDHC4xx/PWr+QVx2XWu2WTbhN2Vysc9brJYHYw1zDegPIAQtDXDQvhULUk2gBiT/7JM=
X-Gm-Gg: AR+sD11qWgm88ILITrs3lT0ODjkbCgg952Oy/J5NS+QKar9utz/B4PUBAuU1nD0YjyB
	wMt4jSniDcshWmO4/JxHJbUlsRmiQ84Gwl8ZJFuAQq/4GN6xRVqWwdPPWrNcXEeOt4JGzTGgOq1
	Ewyd7Br4cNCW20xpsm2vrl+Z1tP5fwAoDxxr6+dgqPrwSlY79/agt1kdd7y6PVKHmlJsB2KqtZC
	EtNEFOB7MhZO/UMLfB0c+t8DpDgdHkVm4Oa6IT2lUCbES+kiZIrrtQCDqeLsjbnAVknFXd54azb
	2SyRGDNOeXyzneN5I1BhmGvP3LJwpPweC0zRUPuSF4xgFlx9PZLlWql6TxZymLF9SCvEBwManpg
	sN830ricaX+mQqbazNqL9FgmR36eAIADoKQlEyEvtDc9p9dSUwvDU+27wDqoo5xLImPiJXcceUP
	4Qf+tn6iNCcq+BqfTkOKxWMgU6uF+p9BxiLSg2KKYfG/e1XR4I5ZXrZncZi6w13GC+PE0xz4YT3
	YGrd/KmkhXHLiIR6tNcQZ219ZfCnjoB2tcTw6+pp6HX
X-Received: by 2002:a05:6214:f21:b0:907:5cea:2f00 with SMTP id 6a1803df08f44-90c809444cbmr84527006d6.5.1787337723325;
        Fri, 21 Aug 2026 11:42:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5f2a2d62sm68350656d6.38.2026.08.21.11.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:42:02 -0700 (PDT)
Date: Fri, 21 Aug 2026 14:42:01 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, sashiko-bot <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/madvise: use folio_trylock() in the cold/pageout PMD
 split
Message-ID: <aoiap-yBdPaM_YQG@gourry-fedora-PF4VCD3F>
References: <20260821150912.183976-1-gourry@gourry.net>
 <aoiWZjgcitp0nSk0@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoiWZjgcitp0nSk0@gremlin>
X-Rspamd-Queue-Id: 4EFBA100005
X-Stat-Signature: g1tg6f6qcsmej98k8fut5s45xcdb7g1j
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787337724-732884
X-HE-Meta: U2FsdGVkX18gKb75Dn8UocUhCCJ6VA/+2qJ5vz/wqF2sJMRHrrbNWtAlwTVxiHYe5xe1Wd2pgrihIb3C6byAr4+P6zaGQQk1ew1BGs+/K9Lky9Pd5ls72Pnvq8TglXFJZ3OqMgX/hEcTIjoswIF/x6uBK6ZK8Er1ItVu1tOr6Tqp4qClE4gyTcG4G+gHqdxVoSIAuuZ/eK8IZ2KYlyghQQ2JAFdQpzgYqOPH4ezRoVOGLxxR+GtjTH9hmT+qhjnyolnh8O60C0NGom2duTeMtj1vztCW3mG5BMgXJrcs0R34aYeF6iiqVbWcmlpT4Qs7P78+XMJzUnZKaqRJsngOVk5ep3rLIakd5aSg0Idjw8lOcaD+noAcRy2io/1J+Pi4y1mspKgSTHkXhIpKIqL1uQTtjhXxnakj85G44KK46ArFb4JZuc6A7J38526CfpjJUXOY1GhgIyhiSmUSX4adRJwKr5uGbgu+AScRU8XqbLS2WXNWpTtkHEoM4zZlnq58tUScInBi+lUyWPd54uyeMlhxjJrKkEy93PKkcPJBCptPeydhJaQqpF4G2j5F6jgbs90jnMRvOpy8hovHZgv8qvLTkwi2cqgFQcxBp8HTAtsUjACte/VrD1gRpovN9Yc2mSUgVIASeElPa5kl7W69GhJRf5Ouy1Pu8oSgF4WV8wGAAaiGm47wp0WlZppw9RcYVaWL6Kt5OGVBS5DUZMSvz9YoDHsq8PGr2TeT8SRmteiRPF/4+v0gytIwlgQwJe7zB8L/THPWFvsrN6SE4zcCnaAHJpWPvg8TzfIEFj8nx1PuIK7WbU3D7lWWR5hvewL6vYj1KxyBMmjexwXGz/pl5x9tfm8g++Z++qDyngI8KBVHzTvVFvYr11thwXY9nY8kJOe2Sd0DkOprlRndYnntBTBtW2rJgHhmFKZ47gFLlkkegEflMKxqYOxu+hUbVCDj8rvIuXGSJ5TA65jViqG
 HGGzjtoJ
 Ys5Zo8eHqAJYwnsAGiez5tbcds1Jo9cX79l1VBLpNAgrTrRSpQkeSOroLmLqvY7aeIPG65mPD0zjoe1jYCgvYLzi9Tye1P1QohiiMHqlNq7RC00xd/JPwesaifu4/6FZKXvbIs8r5MAQEmWpRpjuGz6pptv1vDtkfRwbruIXuKdWWnANPdeetkWGiTzD5SRXt6bzXYFZSQ+NJu5iDnQ3K9Fuijt2dB/f84kjSYTobHVtogKwfSomJKJdpC0aOoyQHOBMVVkvDeODgxx9WJKKDFUHZ3QmCaoikbbN9R2fDShoqDhoPOXsNqUEhcVKLcsBGMrvtkEK58c1Msh0CrOWz4BUPaZbbVdL0Z8hLUfs0ienSRTHhK/V7hA7YGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 07:23:34PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Fri, Aug 21, 2026 at 11:09:12AM -0400, Gregory Price wrote:
> 
> I am _so_ glad to see an actual reproducer used in a sashiko bug fix. THANKS. :)
> 

fwiw i try to produce reproducers on all my sashiko submitted fixes,
i've just been dumb about including them in the changelog.  Trying to
fix that from now on.

> > +			if (!folio_trylock(folio))
> > +				goto huge_unlock;
> 
> Doesn't this violate lock ordering?
> 
> From rmap.c:
> 
>        folio_lock
> 	  ...
>                  mm->page_table_lock or pte_lock
> 
> So now you hold the ptl lock _before_ you obtain the folio lock?
> 
> I'm not sure if it being a trylock gets us out of that particular situation? And
> I'd be reticent for us to violate it... unless I'm missing something :)
> 

This was the thing i was least sure about, but the deadlock condition
should only happen if we tried to spin on the folio lock right?

It does look weird, so it would be wrong of me to say i'm 100%
confident this is the best change.

~Gregory

