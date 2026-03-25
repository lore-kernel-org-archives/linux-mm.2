Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66565FEA803
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 03:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815A46B0005; Tue, 24 Mar 2026 23:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AF8A6B0089; Tue, 24 Mar 2026 23:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4E56B008A; Tue, 24 Mar 2026 23:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6396B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:33:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F34C113B7BA
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:33:17 +0000 (UTC)
X-FDA: 84583164876.19.B57658F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id D878A10000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:33:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="B/cDWk8W";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774409596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIqXsf7qQRyhZC/GxHM1lgBAlnhtV7VGCfnX70dQLZU=;
	b=2XbkWFLEkD4dmsAao3OSqu7H1fFU0BB1N7ogP9Rd/DB9fjAh176dbSUqaNrm6bfDFe4QEH
	ovnkxck4hJFSwFfEJGQa2uw2FGb4Ksl9EMI0JtS3nHFBcBg18nUfucn/2Z5DmpcCrcVgOq
	X0h4njCqjG4wDBZyrtJ0UfoHTVr9i4w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774409596; a=rsa-sha256;
	cv=none;
	b=uB9yOxSs3hzKGQxh8Iaug3+EkvIHT0Q3S4ATCOa2i0NlW9mBMYn4Um9u4ZxkbhxUm+YQMc
	IqnvpBod6jlc1x0GP8FPcgbEfS167eD7C1sXh+O6YpIP1T9f97B9GvVO6I/WlKbRdYPJOM
	zUoyiPeJOs7bKe2eusjowrSH40J8rQo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="B/cDWk8W";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774409595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pIqXsf7qQRyhZC/GxHM1lgBAlnhtV7VGCfnX70dQLZU=;
	b=B/cDWk8WcJlhsgO/daKo4lRHnJywLI03ttVOfESSkzxAWv6BXb2NDY0xO+sRA5c+c0xOu8
	4hwozA6dMesepwaUiSg/rNg6ciiQz77hFcZnoOkBWgn3JR8Dsqf5H2El0YCa6H1CPzGxxg
	+jRgq9N1GhyrTikbBKcYF5R9F1vO1iI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-361-e4auf-kGMv-Z8m6w-sMMkw-1; Tue,
 24 Mar 2026 23:33:11 -0400
X-MC-Unique: e4auf-kGMv-Z8m6w-sMMkw-1
X-Mimecast-MFC-AGG-ID: e4auf-kGMv-Z8m6w-sMMkw_1774409588
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB67319560AA;
	Wed, 25 Mar 2026 03:33:07 +0000 (UTC)
Received: from [10.22.65.192] (unknown [10.22.65.192])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 343DA1800361;
	Wed, 25 Mar 2026 03:33:03 +0000 (UTC)
Message-ID: <201249f4-d07d-4baf-a77c-d77543a9cd55@redhat.com>
Date: Tue, 24 Mar 2026 23:33:03 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] selftests: memcg: Iterate pages based on the
 actual page size
To: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 James Houghton <jthoughton@google.com>,
 Sebastian Chlad <sebastianchlad@gmail.com>,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260320204241.1613861-1-longman@redhat.com>
 <20260320204241.1613861-4-longman@redhat.com>
 <CAEemH2cJeTWLCLnmHqQY+tAs8b8FM+AmQ3UYd8McM760cN_Atw@mail.gmail.com>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <CAEemH2cJeTWLCLnmHqQY+tAs8b8FM+AmQ3UYd8McM760cN_Atw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: mcNfCGrqXYuTe8xIcjxRg_4FPNFXsDbVAplG20ORWTg_1774409588
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D878A10000B
X-Stat-Signature: ubi63hysk4oe1xjb8r8bbrw45mf6dp3d
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774409595-288667
X-HE-Meta: U2FsdGVkX19YiXgfMZ6wUpfmY3kLAhvgU767/rlToDmgCmm3NkXzqy0iExSSrlQeOrDLorQJ7emGmRDZnKh3eLtquFMtAJlggC7p2mVCHfsbjAWlDVgOBw/TmgU09jo7lt+NgUlB17xbfTMy3YMQtZD4dS1OvnJkCfjPrPcvBgE+Z/rwMYb5DinKmfQtRrFc9flTMeanBibVTyVFGxXvOjArWFKnJ9Y2r+qubwMZXnKewyWUgp/CpsekljNMUAz8VtIZ7Dym0S/d14F5jUzbzdnxuVu27bB2yJ54l3P4fjBLgyl1PpC/4U954xsPkAq39eGfOq5SLX+dUsEFBVv6SXcx8wF30TDg2cU5y8/AY/jLAT8mLBr0wjoNLg6xtiwIw/6T8XbU43D2ej3dXTbC4ouMoJxq5xlGT/kgwLqeN6mhNeTyW6kiEUbb3KgkwaCzYkJoFtcg9+RqpcFj4yYFe9VDj7+TrPy2G1gg9WrYfgw+TvlIZuzKpTqjNPYts4UObIQK7dNwb7t/qhGcFenRqlWbseGwnXbXivZJkOLkLuyDhz6vc3Lutjg8zcUYkH1OVknO43Kyy+tuzTNjv6Q3Be9OjBUNoVVWTtvDtDMxzKEqwiCG15u58U5WWPAS0pCr2B83CQF/hcXkJYpZxM1PeWCsakrQ3Iw10RpTGEG2RULlPSyS79Ul5/8L9RFdhT9w2WIhMXuNSblPV35aKOMss3eozlFOt5UXF6QAhoaItMADGmsNWElQ2U5981nyTUMhbstg/LxD2ucjqX7jJjajCM8HNXlGk1LbRI2ZrB3ZOjJEsMgS9rK6zmQFT/DvDPIzjgl/dEitFvXZOEXcKWePw9I9yI0cj29LK071vlepIdTZgvBfY9vT2sAaCEy00b1khQLzSWsqJNjMbLMr6PN3BMtqpta6gPL7BYACa81XnkbZADuycMdh6GXxB2AvG+b5alEqmWgJgfky9Xyj2wh
 3yrTLqT1
 8XBmFY8Oz2D4Z45pgzCAKaH3mFPm6gMUq/jEzETlwtpkoQ1b/AUaiP9H2uHPfusx5bO/tzDmA3mlC+e6g6WUOkCFqTdYUFRAL1TpomSRAdjW1hSKiOrAr1sUK+vMfz3q0TTxXBG4u+9tDyN6sqLMS4JEzIKyksvZSXl8f1ua4vWZ9cmAyGXcIOFqiFC6mKzQlkPccBlzslAPRNKB1UDaMeOBp0YW/vGar3YytlWffpnnIjf3tUfo626Sqx608dw8FGyV6/aqVUhvnY90PysbrRa3rJy3oSM4GfWSuen/QZdahrkA1FeGvHwbhqu2YNlHxbU3WNyhgEwPpaDGx5tQ2/8n2AnHg50W/Kuy2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/22/26 10:53 PM, Li Wang wrote:
> Hi Waiman,
>
> I currently have another patch in hand that is functionally identical to
> patch 3/7 here (requested by Sashiko).
>
> May I go ahead and merge it directly into my patch series, while
> retaining your authorship attribution?

Sure. You can merge this patch into your series. I just need a page_size 
global variable to show the system page size for the rests of my 
memcontrol.c changes. I will then based my series on top of yours since 
it is further along.

Cheers,
Longman


