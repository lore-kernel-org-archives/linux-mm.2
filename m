Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE76EE6428
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 14:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3A546B0088; Wed, 31 Dec 2025 09:22:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8736B0089; Wed, 31 Dec 2025 09:22:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC9316B008A; Wed, 31 Dec 2025 09:22:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE926B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 09:22:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8056F1A569A
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 14:22:02 +0000 (UTC)
X-FDA: 84279980484.03.31C86B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C57EF1C0002
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 14:22:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fdkIy6Sz;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767190920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXYjazt0zE5ZbXPCuIYC2wRZQfZaaSTiX/lQQ7YM9M4=;
	b=yGK2GqHUZa2+Nvfkj/IHfU/pc0Kfbv47mHK3Dqcpk9SgwR25ymxVi4IVR0gTS+fMHMT0oo
	0F+qKcrSflzuvoveFklS5tkurUVJrAOlgEy7CQ55gxra063xnMgvpufjOCfEsPUIWtxclC
	AplOGrKgtALldlhelq7OGWGk9JDSRhs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fdkIy6Sz;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767190920; a=rsa-sha256;
	cv=none;
	b=1puw4Nz9/pFfZKq+HCPf2fZeoV4QaW9OcpHkaE9Gcw0VV1CgsC2YlJRrUP3LnNqThtwf28
	9vG7nIzcNgkHTUiVr4do2uDdrVFbi58KAzNmvWR2TbMSot5xT61geScynj6BcDnDHzKXSR
	mZ/WgwsNxR0ihrfmbbx1FKSUXDxCVo0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A02760008;
	Wed, 31 Dec 2025 14:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D7AC113D0;
	Wed, 31 Dec 2025 14:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767190919;
	bh=ThxbPyVAuuGbA1hxol61p5aRyqgSEJPk5GSWaXCro3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fdkIy6Szlw8k7WZ5M4sr0W+mpchR0nIFJWieDi+fUljSS8EAjYlSchHFr67dKhexm
	 KJJMdMWfYo8IWLH2chBoG8s+ZzgqZmkjbUlBC+Vq0AxW4efi7nbP/ljmMjJI+NbTL1
	 sLgKSLCCNSmx6D/VujTYD1MVuxw2wr6bHhfmYE3B+2Va+JDWfgi0fQhFtPsUzwhJdE
	 cLIAzLkpUT7dXDv7EQ9Fky4+vRRiwgjcI8gk7iiqsUR7/k1wzYboc2OATWu/Ld1MR1
	 jUVkuUAHST53zHzaocUECX2wUK5wFha+6qsdBMVyGyNbCMW4qKIWzEnCyzkbvzH2oB
	 lq9ruU1QKaHig==
Date: Wed, 31 Dec 2025 15:21:56 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 14/33] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
Message-ID: <aVUxhNlKaT0r6F5c@localhost.localdomain>
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-15-frederic@kernel.org>
 <8ecb22ab-d719-44b4-ad40-5af0a185682a@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8ecb22ab-d719-44b4-ad40-5af0a185682a@huaweicloud.com>
X-Stat-Signature: pgfjm6jfgek7ku1o4th4schxh7ab76j8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C57EF1C0002
X-HE-Tag: 1767190920-809536
X-HE-Meta: U2FsdGVkX1/iPfxf8z7ziwcOFSe0pXbC0TTZH4Oe2rSDAlahZ7tlgR9JUmAuS76ZvEAWpCJz0j5Iqk6pU8FmAwWkqG5yD+ui/J7hqxEABmXGjeEwQ5Fv4RxkeM2DIbZ5pvOsIhuUipBGKkLX6obxkGvQFjO1f1twVNHp/0SMcjYvem90NgP6I0eNYBVhas4D1vMq8uYVTyN68SGQ645kCC9Xy8bFrkX14Rj8Bf5c2OGdZHmy8GXReMqerb9WYfDJh5I8L/VY1bFqKiLa/bROGcW5CQiX0aB6VSKTTFDF14n2sLuUAX3O6WjgfKGgOHBBQgNXXV3PqQt54QTIVp5aMk7JDrKLSlshNJI+Lckkr7LrRf/N9rNqXklLMinhEPFOjh/tSQgTkrN3kTR2DOMFeS0FzY/2IKpmyzb4oi179wrRWI8XOgkkwDUdyaucJlX/lirX4TKJJIQUFey8uNtqa1xcXz/i7dhnAcvAVFDiqDl6I9579HSePqLGlymHuXc4871H8h6UpHrTjpiUiahrJ6efbJ5Aq0KrYkGIkMirljs+3DdlSbliUnBariGztEaWeA8NLOm8B1QTyXpReYKspU7JYK2x5O29GKmOj3tg8nTAKWkYMMoCmNWCtAwwHQWYrcatUIqaXthK0poLyB9EiBpFafiHfhqEPQvDYbw2Z5+RM2n4D4MuJSFs+A6ByrWJ4pjy2mEEHSKBPhG+Tm+3hIOa1udExkuUy9vr76Ci4r5DH5WsT1gtLJfWYLlqOb6fPcDgHX9UwJUixHvMZevQp8vZ88kX4Z4BNOgjLNdbovt/a6HaNft/MKdsEXHn8AekAT59PMRyk/m0hAcrH6jrZ++tPWzzxUp6sBhsmxAmWlp94v5/Din7JzYY1mn8jEFfrljr30xkShdfHnYlTX7E/1nih9lXjCA7MbofQgAfPmMF7doSsD1mQ1G2OvUAUO0Y5E4SIIqZLqLOzlnzZF3
 Fq4T1hdg
 eS6asSnP1ThTS2YcR06CHltLjgBfSCupt7mSSVPfCx82VN5TLLG1GE09OyVjEAMezlT7XCL9QSqRq+WrSwFhrV+cY29Wb9gheOISrCO6CWvHSRhXAAmaMXZwFCkbmM+w9TQhosJ8lnxyzgnJq5zmS4reqy0LKmaVBVUKJ49orNbKG75x/lK/XWlI+Lo6Rm8gdPD/JaIOoCctHUzhhlJCswrCAnJ7jzDzDsqMKpFSf77Y+MwS8qUM+8GlNlWONbRMSoXADfuSSP+HVJB4f65lNc3qL5PbrVoB5q05F/VpcP9I3ewhXk9XTSBaiClTrJE49unWBpt/kXVp+i4QP8NWke/glwQL6qDTTJDPtwy+b81XQnediWsVot/4YzurFv5Zgautd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Fri, Dec 26, 2025 at 04:08:04PM +0800, Chen Ridong a écrit :
> > +int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
> > +{
> > +	struct cpumask *trial, *old = NULL;
> > +
> > +	if (type != HK_TYPE_DOMAIN)
> > +		return -ENOTSUPP;
> > +
> 
> Nit:
> 
> The current if statement indicates that we only support modifying the cpumask for HK_TYPE_DOMAIN,
> which makes the type argument seem unnecessary. This seems to be designed for better scalability.
> However, when a new type needs to be supported in the future, this statement would have to be
> removed. Also, the use of cpumask_andnot below is not a general operation.
> 
> Anyway, looks good to me.

Ok, let's remove the parameter for now.

> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> > index 475bdab3b8db..653e898a996a 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -30,6 +30,7 @@
> >  #include <linux/context_tracking.h>
> >  #include <linux/cpufreq.h>
> >  #include <linux/cpumask_api.h>
> > +#include <linux/cpuset.h>
> >  #include <linux/ctype.h>
> >  #include <linux/file.h>
> >  #include <linux/fs_api.h>
> 
> Reviewed-by: Chen Ridong <chenridong@huawei.com>

Thanks!

-- 
Frederic Weisbecker
SUSE Labs

