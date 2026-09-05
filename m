Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 632C4C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 19:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94466B0092; Sat,  5 Sep 2026 15:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C0B6B0099; Sat,  5 Sep 2026 15:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84EF6B00A0; Sat,  5 Sep 2026 15:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CFA86B0092
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 15:49:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 284E61603EE
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:49:15 +0000 (UTC)
X-FDA: 85180747470.09.C520313
Received: from outbound.ms.icloud.com (ms-2003e-snip4-11.eps.apple.com [57.103.72.141])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2A849100003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:49:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=PlL1aLc4;
	spf=pass (imf05.hostedemail.com: domain of bfguo@icloud.com designates 57.103.72.141 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788637753;
	b=tztcO/NsCCmMuwr3eLU1z7rBXKmrdhS/GZNuinaEMFzPiglw3fgaPZYPcp5wYaimyYw+tS
	PW+9guTcmgAHXprt5utx2xn0iV+zD7cMVYZXR49oEJxRZws2ADLXkWEhm9BWHWI11pFNz8
	OGL0gYDw0+mgooUwkNnCCeiGt8GaYIA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=PlL1aLc4;
	spf=pass (imf05.hostedemail.com: domain of bfguo@icloud.com designates 57.103.72.141 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788637753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NSqzY4DKPEYhVMjHXh3bB0AeqlXjegvLRaBRjDJ/2A0=;
	b=Fdb4pkEg1Ttsw/yJ9RabwFGjJrQUP3C3hAcuBEX90asFqbkrt7Zt8AB+CuR6QsuPkO+bFN
	0eFyxr4TM9/ES/2mBL1rc8/2zdJ5UtlTz2us03s4Z5ph67xcgz/hdzN+G7/jo418npvzj7
	jDu58u2PLrgOgFS7w8Wem/VUrbwbhGU=
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-1 (Postfix) with ESMTPS id D572D18000B9;
	Sat, 05 Sep 2026 19:49:09 +0000 (UTC)
X-ICL-RepId: 01a0731e-222b-7a26-bab1-9d9516fb4bf8
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQtPHV4PRQBAC1YGVBcOVk1bHlQYWCtbE1UXRgkZCF0dGR5XUF4IXh9MHB0OWAYSAlpFAlQXA1ccVkVcGEMJXQVXHB0AREVbE1UXRgkZCF0dGQhHHwowA0IOVgNDB0UALRkcV1BeCF4fTBwdDlgGEh1QHA5RVhtKCXIPBjgAIAoGcSlFF3cpez5+PnIjcCxnPxQ1cF0JS0YJSR0OBFQHXQVd
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1788637752; x=1791229752; bh=NSqzY4DKPEYhVMjHXh3bB0AeqlXjegvLRaBRjDJ/2A0=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=PlL1aLc4Lj5TJqea0XzRA4TYqIMemmIrh/Omi9jldmCChXsJAsfHDTbsq6ymr4ZMRFTOquJTL1sVbRRjI4rJrlMmME3pMPScY31KFnXziUB5gb6c6oiWNCmjBNpiPKi/QEL0MEh00gytgW86dVemjlGoOSEgQmau8rOfI4xqywVLG+aeJFTpf+CW3/tPVH0KLZYoi/uafuPSaJmZErvv4qHeVwPGqalYTkmEDzjbeinjBcCgNqm133w/JXvy5LNmd2MPNUx/T6VcRCS4rG49vABGpokXwOQlKprdwY5FiQRVchC84HSa2uCFd68HfC/E8TvHr/TPsyMMrwo7IAVDmg==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.156.208.39])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-1 (Postfix) with ESMTPSA id 77D861800092;
	Sat, 05 Sep 2026 19:49:04 +0000 (UTC)
Date: Sun, 6 Sep 2026 03:48:59 +0800
From: Bingfang Guo <bfguo@icloud.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: bingfangguo@tencent.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [PATCH RFC v2 3/6] mm/memcg: pass the id itself instead of memcg
 for putting ID
Message-ID: <apxyKw5U7K8vHQvz@BINGFANGGUO-MC0>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-3-8edd7f7a7251@tencent.com>
 <29c98946-cb26-4b1e-8a95-fbdc9c9671ad@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <29c98946-cb26-4b1e-8a95-fbdc9c9671ad@linux.dev>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDIyMSBTYWx0ZWRfX+r8YXH+6kE2+
 LkMhQYJcn7RqdUGCjmgTxUyMDpiGHZ6p6hY6DcUXjjdBv99hwzamKg1KjW2+dsicPO+EMAErERB
 oCJCfTimHAhgRBbS9TDHcmvxX0o2vfmOvfYGstlvzZRK2OGzqw0Iq7TN4HsCmEpYhwxUmX++Z+c
 QJSWqpiTrxNATzjxQtQeaC+BtznlImOULA1DwZdKUz4qM4knaN42kpS6hEXyWxZR4WK6QtB+V81
 j8lwp41XX2/nRqhlRp5IeDAlgwLm8pF+U6gFOxd7GdqSt9w7yCHsKmfUnGWT/scR8RXRP3EUDht
 BEBogSbVa3963CfV/4RFJbqvg0uY0NlH72sslMYV+lBkRgDfLrmYsJ832O7f5I=
X-Authority-Info-Out: v=2.4 cv=c5amgB9l c=1 sm=1 tr=0 ts=6a9c7237
 cx=c_apl:c_pps:t_out a=kRaGL2Q7qLiahLf3O6OaIA==:117
 a=kRaGL2Q7qLiahLf3O6OaIA==:17 a=8nJEP1OIZ-IA:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=a9KCvqYYD0B343YQoQUA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Proofpoint-GUID: UAb-OiatKCEAumbAE3iT0thEjCIwt-H_
X-Proofpoint-ORIG-GUID: UAb-OiatKCEAumbAE3iT0thEjCIwt-H_
X-JNJ: AAAAAAABKSO1Yh2vZJFH/bxtvBq4L6Ui/bHz9sbiU40hpU2dt0rtaGXJaicnXSr8z2DbgpqhLhIPJHyREvs6sucghTGDi62CFEvM1ayJKF0IcbqGc97/pY2x8ft/LF/E+QFaUM4vf+2VRyz+5CQs4YxB8oteTP3eP9wrkE8g5c/CJPsU5aSc1JYeTmbP70p9vYcsmgVEjb/uCvudol8mYLdC5NOc+eKPY30vDQi0IyKL2l3PDVf8bnFOsa5B6OnMg8q3o0S4w2eVMTWCZty0VThfU9vrMwpkgeTVOi7WL8IHmAdhSfkF7WS08V66zAnWAcxvu8f6K3pG3NSGeGU5Zb6oZsL5urcXElMu86kjoAeLIpCXoFH45mRfALdifNaDSnWm88VKOrxAuRBt6joAeE4WiormWo/N5zz+si4RjUEzWvZRHZTAFS2gv5G3QAuwlgaOKt1mH9NblDXol7WfORUBDrmZZXmtgfEpmvRkc3vu82pFtn3X/v2W/R7TmMZxzjPk6QO4Gr9KJE2OgyI7GqK1CdrRFN2PipogWWaudqr1gnAdrfAPaH5M4tK+we/NLg4spo8D2zqQvgoJAs/1iRKR07IZLznhjJTy+8K4gqk2WQaIAf5BAq2Boz1mVWusQl6gSlvCZ18v1raTiaRuxNKQ9hMdjdM9hkOSG2WxlO/HkZB0h00kHZrk4TD+SNjJvqP1ndmfyX1yamnQnMxGSX1Q90ODtHkd1iMKwg6qZfhoA5MJGnsMCrMxQ8piOnfqxQToH342bwj988/NfObCCQSJeENHRje8fcMcTH+g5zMbZzOXf0h15kBQxD794IY/62zgvmIdEoOlMZLCvVgMNQOTzrMDw0Cms2VVgQYoFoN3YyLH8PPn7AyIopQP5GqJSTkSjPUIF4VSHZgtPIIelktl6035h/5jrK0gMlcR7ZezPWJjflzrAIVIjkW7O8AMaYiKjwTLIU7oqyCxIw62kJg
 AcuvtHGg
 wlU5gRKszLiRdtmSpJp/kE+FKj1MwUgwF7pwuPGU+BqM8aBpslkQ80Don+N1lsPyf/NWkP34TBvB+iniK4eai62ME6ppTGl+yqONf/1MUiIos6V3AvJ8M51Lz1xkkLvvDwJHoHVYTRBLt2xcdE4LqMC4xEFKQ6zMWjgVjB4+PPkiGCbXKM+4ewVTrlkzSTAPjBHKqWHaFvGIxXzIbylHNMva1linl5KY8DN5EffPMSqtAGbN951S/+nbmuF/UWr5ByG9MiQvlaaucKpKSLhvEMemawvIOHeCtA8pSaG9rPOyC0wtkbCiU5aAyhkNNiKefjQtnR+Se0MGsPxS3Q1tKuyQ7I//Qt2AU6BHx03u1QOGZl+y/uVsokGnEp6WMKAKuHO6rzzDTuPAlXU6c342x6RvBJiIUGnKf3y1VriNJ+pnEUgdjfuXNUmX2TodMOTGvk/xx63qWiYqPZCTvLm536or3JIWXfU83znCIfHOgR/OQNChT8Xq/YPvKyw==
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2A849100003
X-Stat-Signature: a8dra47hh8ewu33wuupyazdgo3gxxnzy
X-HE-Tag: 1788637753-669860
X-HE-Meta: U2FsdGVkX18rc1btNRMTsjHmTJNZx418EsmT6e6UPRTxIy3lM+LsxNniz/u9du72k+R0AvrbHLEKdZRn7FbfDlosauYklQCMaRBccTynQdczhCko+9zaoa/4z7oLo3dMIlF+OC/5s+7zdkiI+F2d7WzxC5cgb/Ya1D3Es16a8r6Hb+yu+qNk9vHBFWOag9lhjeyI+v0DCzRz7xiWGtxJnb4VVGJmvkxOiqQnx50hmyQJyR7G9O9Ykm4pkHQuCASG6dKIKvigR55ejSLGdZg9yNzG9+VdNp9FttJWldcwhIihnxv1xw/Lb/mwVUCXhf28s1GkVBfq6v4zJxyie8r1u00q9meMXAWVyumua2SGevBhumnFe55BOVJRJ0833Xa4Hvpny5l2lJW6yb+lD36JN2Ult0RO/z9MU5PndMxBZ3/NbC0M4PKXBAUTg/BTTelmgl3TjS37zyMDv6PUuPHXuKayHRjZ8H8AmFOo48BYJl2Fk/EiGzhII25+iPiApmondCR1wmWYwkZNK3IkU6pUMLhVrgTE1TUbv7JBCXGz6jFmd7Lt/o7/tijJMKL6ufbAtKuNBZgehaZdH3xkr1Ll4xkKPfh8vtCnxO8ANgosOKK0F+aYEq2GUDCc7+teqqoFrjPl/T3eRSfjb5DmHqUxXILzmvZNouZ4Yu4g+AiW/GBWM+lOK8kKf+E3EPuYQv+yKk1FsXSJE1SJOwmvS95Jp9A0tbExc4eeAM5Av3Ofxp5QRfC8t5Hsk8eoDnrAxK7TgNng3mWUzrv96KkrekiVPit75Vyx9vrZ3DkAzgNtsI0OQLAwtNggNKwYm2RDoWsuTHk7U/+9Mi2UQpGGIul+cQsL/X52DdiYh5LelLA9ufAB29KyRYPMvb2t4BT6ri5RyY2puB5mrHauhYxBp93tKui9TVJwhXK19awGrZSIsI0PLYf8Tu5lDN6PxxwXoSfNTKhoic2naAAIHE3th/L
 r1ldviPi
 0UIbm99x1RuEE2dGNv9MlhMsXW4lwUUON8uCTdnDSUYZgsHusiyR5p9APec37VshA4mpEQcnyvinlFPe8ExYMHnS+NZgX1jRArH5bX3HP0RMS7DyLuCsNYXO6vR92YqxXF837W1M7n5SzwDDcGVvYOpDACV1Ek/zWHiv1/erMl+UJJkknm3y9qy5PXGPcyLJGwXPBut4Dl8y0TCcKWKT+VPg5j+Vpj13ptJxeQYkkNd2Bvp92OSsivkhSQQpZEFj4okFR1ztmZbQVkaibdzgJDBRa/4wC4v14XHNb0i7aNK4e5hsHlHUMfGU06BJCbtFU56d6IYvrr2/GcJDezcqaBOkZT7CWdlKjeCeDL6YaTJQHuWvGETJ0M5g39+KfcvwwsoqN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 05, 2026 at 06:01:44PM +0800, Muchun Song wrote:
> 
> 
> On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
> > From: Bingfang Guo <bingfangguo@tencent.com>
> > 
> > Swap uncharge knows the memcg only by its private id, and the id can
> > outlive the memcg it used to belong to after we rebind memcgid to
> > objcgs.  Make mem_cgroup_private_id_put() take the id and resolve the
> > memcg containing the refcount internally, and keep the underlying
> > __mem_cgroup_private_id_put() for the offline path that still holds a
> > memcg pointer.
> > 
> > In the uncharge path, the memcg pointer will have to be read from the
> > xarray twice, but we'll fix that later by returning the memcg from the
> > put path, so the uncharge path can obtain a reference in the same step.
> > 
> > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > ---
> >   mm/memcontrol.c | 17 ++++++++++++++---
> >   1 file changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index ecb4fb07d7735..048c9bb0fad79 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4038,7 +4038,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
> >   	}
> >   }
> > -static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> > +static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> >   {
> >   	if (refcount_sub_and_test(n, &memcg->id.ref)) {
> >   		mem_cgroup_private_id_remove(memcg);
> > @@ -4048,9 +4048,19 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
> >   	}
> >   }
> > +static void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> > +{
> > +	struct mem_cgroup *memcg;
> > +
> > +	rcu_read_lock();
> > +	memcg = mem_cgroup_from_private_id(id);
> > +	__mem_cgroup_private_id_put(memcg, n);
> > +	rcu_read_unlock();
> > +}
> 
> To me, the direction of this change makes sense. At the same
> time, I would also suggest applying a similar change to the get
> function, for example: change mem_cgroup_private_id_get_online
> to:
> 
>     unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg,
>                                              unsigned int n);
> 
> Have it return a private ID. That way, I think the two interfaces
> look much more symmetrical overall.
> 
> Based on this change, it should be easier to implement the
> direction of my last suggestion in Patch 5.

Sure, I will take that.

Again, thanks for your suggestions and reviews! It's very
inspiring to me.

Regards,
Bingfang

> 
> Muchun,
> Thanks.
> 
> > +
> >   static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
> >   {
> > -	mem_cgroup_private_id_put(memcg, 1);
> > +	__mem_cgroup_private_id_put(memcg, 1);
> >   }
> >   struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
> > @@ -5815,9 +5825,10 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
> >   				page_counter_uncharge(&memcg->swap, nr_pages);
> >   		}
> >   		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
> > -		mem_cgroup_private_id_put(memcg, nr_pages);
> > +		mem_cgroup_private_id_put(id, nr_pages);
> >   	}
> >   	rcu_read_unlock();
> > +
> >   }
> >   long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
> > 
> 


