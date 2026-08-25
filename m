Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A2D1C61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 07:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7496B009B; Tue, 25 Aug 2026 03:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 897706B009D; Tue, 25 Aug 2026 03:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7872B6B009E; Tue, 25 Aug 2026 03:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EFE76B009B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:40:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 841A940392
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:40:23 +0000 (UTC)
X-FDA: 85138993926.08.1EF48EF
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2C3FFC000B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:40:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WkyozPtw;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787643621;
	b=THfbRGvGYjOH8o2Go5D4fHg7HfHTUBgDTe6wrXjJx4fkY+JEx2+3co6HZUhdkGyPX5GJzj
	gkeL76RReG1IuoKXIvHOy28A+2QeeahXbsQtJxPEVXWf+pD3NnnPufBw4wsXPa1q0hYv+k
	D89Ki6Hon8mekcdjJ0ABJs/b7fgzNtQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WkyozPtw;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787643621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HvIHRFnGldbLfSeUQWu0/lotI0W1auWfZBfJjbwacgc=;
	b=6KAxuL5IlJnlCQFZkVnyvBAVduDPKGmP6MbmJZwyJaa6y8upYT6amvF8O0QuoXdL4kgGr9
	XPvRGNdN1mJ5RFkdOjSLe04ciENHQa/GuT4rsecBw9MldfTdtYtOPILBOyzopuu1ZE1zl6
	TU5eUs9PXJuE6IdkFGbHTeAhZ2pYoVs=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c2022323c37so693879466b.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787643620; x=1788248420; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HvIHRFnGldbLfSeUQWu0/lotI0W1auWfZBfJjbwacgc=;
        b=WkyozPtwJ2cYjfq8aRrOfg3EXhDUH2AnlybmCXRb8TR81AJODFRNTEptax80VAkra5
         JaenugIcah9khz4Su8c0Zb0n2SFhoUdNAO1pxsgRv4KQSKu4+fy23k+Z1OcnYDanMuRv
         vhar+GL5HVIkj4YSO5qce/5X1kqGihh2fkecT5fYEC/21nlKqmZKxJAlzKXsvVrmw98o
         N3MyZ6M9hfIeCohQw3uGqagUVh1LLE2CEnHi3ubybAosDxYptf6aynJjVJTzhHN9MB8T
         CDYXXdYQSJ71zOgEvqN8MPWG01fJuu5uIM8JCoIFOSmm17X1C/lC+Mt4o3Z/N2eB2jEc
         IdPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787643620; x=1788248420;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HvIHRFnGldbLfSeUQWu0/lotI0W1auWfZBfJjbwacgc=;
        b=PoHqaTA1Bn8d5M1PBvwQI1IAtx5G6c3HjD0VdSfB9zwM5RIKYmrVTbI5Gj4gIH4LTo
         8/T0rGI/yLrZ4oEAsXNROb2NfkrSnqqH8HvCIBetwJxhiWHZXbYCzCccIY2LxQNcVRA4
         POnvus+XRLDYNVr/wSivHkaB0P//JhNxP0VPdff3mQZaAIueqWbzgfXlSQAoEFqugnKt
         zhPY8oX5YNHggbv2txIB2KwLKWDrDJpQTg1fa83GhLpx4k7D3D6vcBIBvAiw4PhsqXCk
         QUoUyGM0V4n/39JiRaxATDJLz9HlFEkp46e1L3hVlnCsRICXHMJnD8bTpJaaeEVCMohY
         AZ9g==
X-Forwarded-Encrypted: i=1; AHgh+Rrj37tK6vcz/7DijzHOFsaasFGeJXnMpoR5jWvPblMqk+YFQ1myXTfyr+w1F1daohNRQkA8fY82SA==@kvack.org
X-Gm-Message-State: AFuF++kBH5rXD2kvNXV+anVBXc5lPLeybkzdWRBB+JoyApofBj/Rr35j
	g8u+nR8T+OeofZvhsm/0/BNbyQQMMZqO6Vqt8kH4WBNufRF+toAq8Y2YIWcRLGmeFBk=
X-Gm-Gg: AR+sD136O01OpzI860ynMQe/0ef7DNmPK5HSPdXsc0mDKEZcIAkiHZkLPbNoc8by0ra
	Bv438GKeuFq4dgZOg3H3fkZVnzQ+7qukSI0CQxJdpboIp5bepqr487OLhO5m49QCZfCQmaSMhO4
	JJeksPtVfAyDXOlHrD2f51ImrQ1fu/0iqndyvmuqJaw5JyfXFFE+SQVygjp5g1IVLed0XF8NmQk
	SO1gYELhVC06uFlYPSw6kwv2GEcVPeBlcqc5CyXV+io/XxKCJMFdljyTqS30YBs93Iq0G9/5uOq
	akYs1Aa9oHSmhqT/jhsFeHloUCPIPtJehV6KvVPeONcGQcFED1ZqM9kbDTwT0Pna6sxc0GDWRxE
	pOiyPWEVVm/yEI4MwcIKzAmrs/LN1YWJctAeAWwliO7IEMNMozOXc0n7tkBVAeT/lWD8EFd00uZ
	0uscaE/oWPSW+7BRKqWpLPyiW7Rq0SMEeevxpOb2k3unhqmZV9PF2KpFKotUyFnkT3dL8M2uS9G
	g==
X-Received: by 2002:a17:906:9f8e:b0:c24:b11a:46fc with SMTP id a640c23a62f3a-c24e5be5ae6mr443422266b.22.1787643619483;
        Tue, 25 Aug 2026 00:40:19 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24966f6b48sm1685768466b.33.2026.08.25.00.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 00:40:18 -0700 (PDT)
Date: Tue, 25 Aug 2026 09:40:17 +0200
From: Michal Hocko <mhocko@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>,
	Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao1G4V-MhsjL5Bms@tiehlicka>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aoqbCyX-32doBJwd@kernel.org>
 <aoy88hVQcA6Gkfuk@echanude-thinkpadx1carbongen13.rmtusma.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoy88hVQcA6Gkfuk@echanude-thinkpadx1carbongen13.rmtusma.csb>
X-Rspamd-Queue-Id: 2C3FFC000B
X-Rspam-User: 
X-Stat-Signature: 5xmf7db65dh3hbts49khqh6e5qgxbmxi
X-Rspamd-Server: rspam06
X-HE-Tag: 1787643621-258608
X-HE-Meta: U2FsdGVkX1/kjg9firL5FfV7HGn61tIjJhhDoqYdPXHmeEQi5ltuhmtHUkscSu79Led80reI1SEZmwAPer4NdWMnRzRnEgVEqIZEJFDYh5KFSctMal1yhXzAXaoA6MEqkIPAtGM+Q7fVMU8L0rFx1x8FkQaqGP8E00UBcC7fwp/5C5SBXPNc2h7aY2pYUockfOeVNmnZuZ3I5DAUC+EfacVfdTrn9njs8ReVJaybMzaNVTelo1XCBmQJIzjhplGdTGWskAz6cxjm8Hv02AFvS+4GqhKRJfP6L8Iw1JQtxgPaEuybSw95kebgRYgnVVGighcNCQBIChD+YFnvJfkhyoNGp823t+l2q1v9qN/ZfE1BiERe1nZKyNT59yOgYAbURYmFZOWdBqR0FjFuMt+aTX7AVPqMs3FXfoWW8aq3URbxu4bK3/kEXdzeOU6rkIMf0sRawFlJbsXA4fEez7hoboT/9IXQ1F5+Y+qJhQRa4M3yiHCB9hv1/y4tIgRH6M6Kr2r0133raAOsSGHh1dgAjpb+QOF4pKumYSPl678qAvGvavIIhUbU2Gez7WU0iuoUo3OJKjPZ1Q+2ZvmQ2R303gs09M9322WDLD0xTQQkGduJwCpA2QMOpmjed0hj7ZdbM9Hw5XHnluA+H56sC6RcYpq3YnLv/Ip3HB/3Nu0fpF8NkAFBErXOsz2I6hNL8oZCUerwu7APqPnDIwztHSU7Kg5Lg8ZE8buaG7rKtMK54WYRjvZDfE+QPicmntEmFzl+W7HqnJnrS3rl3vZMsEf6O7JouUeJ/Y/Xk18PSH/hlUymkPa7erhLM0OMkD9oDpTGzFU2cNyreylM4wKUggfeVVc23rTMb5cuOETOjiszjWlxeQCWJeyOVVcevWW+UOzI7zNJByLcHZgClnkySGTotVBMuh9XoGqLDXXXvx7G7Pfnxk/KttXJQRrVg50ruJWQLJSt2mXgweRUm4DHIvr
 C00U7bI7
 QoDVC0BM47UU/rtOovF7URJVYrXwFJjV49jwEDuML3Jm/nAswgaxrLbDjx3JqcTeC3huURXZN2H1JJQb6xDXb5yWYPYWhD9sp9J645HsMn5illA+12F4H6AutjrXDQqHyXQOuB0fgF6TqyNdLMxTjEbPHInbMwBNQ+DWXODx8R+FFBprX1R5oyqzPJ4NLjUqiuA5iAPZopbhYI2QwFxysJu0SerPom8plFGHoWomD1dExB5rLEZn6ffLiFc4wfnPZXVmI9uuvGKqaL4b4Bb04WKU4TdHNPAOTxzui/xWYpXeSw1N6QiIdpbkVu9Q54Ldv+g1fmttGJIwXIODhsr427/QDEVyMsgWG3Kl4+os+EHQJP8ueaw8bh3mzetkGXht+bzju
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 24-08-26 17:58:49, Eric Chanudet wrote:
> On Sun, Aug 23, 2026 at 10:02:35AM +0300, Mike Rapoport wrote:
[...]
> > CI found issues:
> >  
> > https://github.com/linux-mm/linux-mm/actions/runs/32519133924
> 
> Indeed my apologies, I messed up CMA=n it needed a forward declaration
> and gating for mm/cma.h content included in mm/memcontrol.c.
> 
> I queued this up for a v2, with the other issues reported by Sashiko.

Let's focus on the highlevel design and usecase disussion first before
you start chasing specific implementation details.

-- 
Michal Hocko
SUSE Labs

