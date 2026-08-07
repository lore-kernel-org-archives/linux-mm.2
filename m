Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C5A4C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BBE86B0096; Fri,  7 Aug 2026 11:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 591EA6B0098; Fri,  7 Aug 2026 11:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0026B0099; Fri,  7 Aug 2026 11:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 286C66B0096
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:40:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A46E8A0457
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:40:20 +0000 (UTC)
X-FDA: 85074885000.27.0003198
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 728CC14000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:40:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EEyLg4q8;
	spf=pass (imf26.hostedemail.com: domain of audra@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786117218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAIv91ZG6RZhCUiLfO509k7HKcESuAJJr1DwOx37KRE=;
	b=j+xBtjO++TGY7JQbxiWG2QYT/Lv16R777X1UHm+Cw4Qbpa3HPavTtGwKDDy5rSXcDgwmhg
	cc0hLMTrRzYpKP14JhPBql0iFT+WLt/D31U9lXASCST+tfyRSHN7sQqqF5HqJHEdalqsC8
	AY0JXiGeYaCErC9l2ICHYZovZwYyqo0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786117218;
	b=7phWq8ffagorvsBvhxMfCZELqbiW+W7oz+LJtAdz5pSUBxLiktFP2hkBOSPqqB40gBzbX8
	WiRtUI8cvTNfWFtBpMfAVcsjqVzvIB31LjMg5M5BRGxT84PSHD8CygevsMjyOxVKLeRvuT
	PF+uHAC/HZsl3w6D91C40KQSd6kaaFY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EEyLg4q8;
	spf=pass (imf26.hostedemail.com: domain of audra@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786117217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aAIv91ZG6RZhCUiLfO509k7HKcESuAJJr1DwOx37KRE=;
	b=EEyLg4q8C6Iuew6WWoYOJZle/849pFnbxuW7qkxd8kEn5fpVihQFImbrKyiZCyQHWCOrqP
	Rb2ODLvtwwYsRf2/JfAFvUQ4x3007h+KHNxJxOide20P76uVsOBLFg/oScKmDRREe7sWwE
	NCwE09n1rtiXrFrewvIQdZR9VAhDfzY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-662-aWJUy7s1PZ6g8wWe1wDoeg-1; Fri,
 07 Aug 2026 11:40:14 -0400
X-MC-Unique: aWJUy7s1PZ6g8wWe1wDoeg-1
X-Mimecast-MFC-AGG-ID: aWJUy7s1PZ6g8wWe1wDoeg_1786117213
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1F3C19560A6;
	Fri,  7 Aug 2026 15:40:11 +0000 (UTC)
Received: from fedora (unknown [10.22.64.85])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFA10195DF96;
	Fri,  7 Aug 2026 15:40:08 +0000 (UTC)
Date: Fri, 7 Aug 2026 11:40:06 -0400
From: Audra Mitchell <audra@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: david@kernel.org, jocolema@redhat.com, raquini@redhat.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix unbounded loop within try_charge_memcg
Message-ID: <anX8VgySSw5OR_Sb@fedora>
References: <20260806151004.1825320-1-audra@redhat.com>
 <anWSHc04JJBJ1VbS@tiehlicka>
MIME-Version: 1.0
In-Reply-To: <anWSHc04JJBJ1VbS@tiehlicka>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: Hfe0vFSjVDw8gZxY3u4la4j1y61M4nD7Z9AfRyE7Kb0_1786117213
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 728CC14000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: gcaikyzs71icxtg6h39i58essuw7gwoa
X-HE-Tag: 1786117218-601260
X-HE-Meta: U2FsdGVkX1+1XjHe/pzVQgcqDmf2UH8Mn5JGnTZSiK3ZsQKEVmxy87mK/7H1uVDc+B2vnQJ4sh/Xujzuqc5hikb6z5EOxPj1g/+th/3QcInZQK8iHk2pJa+jKfai0bwepRVtTmKNuXETCFZaZ554DkLMi4oSieQjz5cKBhYeiRwj4r1FGg+J9MSiOe4lFgeTphFiWkY4E0z9bNgTu4VecYUsYm4s46Jttk4jt2GqEJThlAXOLLmjmyAc2vgKPwxg3gNfOAmkSnVsgfSo308TAYsJNtRSTOYQt+GBxKkj+nsVbH/+THcFpQLEW4gOgXV+HaD5iJQykZzl7nZJZna/W5lJnnktQEsIH5aVs3PcqeF2ytLf+j4dJHu7NHMZjmqCNobn3ZhzyBARxme6TPgIBJiEkQZiKqR6A2W+HnL1D2b9tiwHAbImtvhFfgG7oPTz4VCDTR7FTdD9j3oUxYe7FWmYpOJTO1CYf7+iypfodlHo6xw7TdyDiQJKCDbFnnfIcwixHPvF3MIoHbOdfmCw3QPh67V+e736AT6hSpGgLn3o7nJpAcsZWIqnb99bb456+FdtlHXse4PfCcm4fvBq8XnyvFyOcPUV3KApKH6Su85cwR1VFu4cucKejx/03BH7TkAWWEMYNmF1tZXLeScg5xJav0vNyclk+/GxkBAAqbEhX2Ffw/gvq22fQyd4BhwdTZncuNkcDMCoNLOlGlNZiXwPBCWLrpCU6psh4Zuz82uQxmSXuR35H/ZS4v2UK8YDj9idhF4xi+vCCtBEZFybk0kFLBLnZPMkFeZdev+mKBvtSNPM+7gZtifVBi+V2eJn+FXr5CCligjTvPc0Y2gGm7bVlsiBV3ujxGBVPhh5cgl1G4pioXqYM5/VpEnwBBAHEq3UF+A0hDfyKCr0yh6TK0ci5ptDfwnCLCtgsmKJJxf1WbefuexhAVs5JRu9Bg36tDJrdleYpXxrtaxIaD5
 dpNYd8jp
 7kLp+mMiEr/PK7R/uDSFl5DYSTm4PeZpnmgXVnTsu4BSBEyGdJkvmReOobsyd8MFjK/bnQdNLnpRoE8u4VzaGEdlzQmWe/JaOJk5nXF2z0H+CH71h26ldXrqZzzFYXfZmjELr/0vTJ8+dK1Lb+MdFvBZPvQURkT5p0aZ4yn/AFZrVgXd0YEY6i6bNM6k89SY2VHqPPYvstkBHLKrWDehFbBF1PR8cVbvTa54YZy0yNAZXL7FPw/mMoJ6dlKReAKJqs8/Vr53UXEfElr9qJLeEnHTgDxmfqMQaBBW2xOh3dDdpU0V6duD//jGFQxXS/LvOIXE4gtpPjN7NPplkikXbno74jMxQ0mneiT00vH/jEwjvYWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 10:06:53AM +0200, Michal Hocko wrote:
> On Thu 06-08-26 11:10:03, Audra Mitchell wrote:
> > Originally nr_retries was actually nr_oom_retries and we used it to track (and
> > limit) the number of times we entered the mem_cgroup_oom path and then attempted
> > a retry. The purpose of nr_retries counter changed with the introduction of
> > 9b1306192d33 ("mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL
> > charges") so that the oom-disabled and __GFP_NOFAIL charges would also continue
> > to retry within the desired nr_retries threshold. Later d977aa939fca
> > ("mm, memcg: unify reclaim retry limits with page allocator") changed the
> > nr_retries counter from 5 to 16.
> > 
> > As the function has evolved we now have multiple paths that have a goto retry
> > path and we have lost the original purpose of the nr_retries counter, allowing
> > us to take a goto retry path an unbounded number of times.
> > 
> > Fix the unbounded retries by nesting the code in a loop and decrementing the
> > nr_retries counter correctly.
> 
> Are you trying to fix a theoretical problem spotted by the code review
> or is there any actual problem that you are trying to fix?

We have had some customer complaints that performance has slowed to a crawl when
the cgroup memory limit has come close to the maximum limit. In those cases, we
have noticed that each process is spending a large amount of time in the direct
reclaim path acquiring just enough memory for their specific allocation, thus
by-passing the oom condition yet degrading the system's overall performance.
In the global case, direct reclaim is bounded by DEF_PRIORITY, however, a cgroup
will go through the try_charge_memcg path which will call
try_to_free_mem_cgroup_pages->do_try_to_free_pages each time it does a retry (16
times). If we bound the loop in try_charge_memcg, the worst case is 16*12 passes
attempting to reclaim. This patch is meant to address the unbound case, limiting
the loops to 16 attempts at following the direct reclaim path. An argument could
be made to reduce nr_retries as well, but given that the nr_retries has been set
to 16 for sometime, it seemed unlikely such a change would be considered.


