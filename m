Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3593606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 05:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=izesOQcJ
Received: by kanga.kvack.org (Postfix)
	id 06B5C6B05B2; Fri, 30 Oct 2026 01:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01C426B05B3; Fri, 30 Oct 2026 01:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E751A6B05B4; Fri, 30 Oct 2026 01:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C132D6B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:40:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3568AA822F
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:40:39 +0000 (UTC)
X-FDA: 85378192998.07.21B41ED
Received: from mta1.migadu.com (out-126.mta1.migadu.com [95.215.58.126])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0516D1A0006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:40:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=izesOQcJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.126 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793338837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CdWUt+AQIcUlWqOchiPx3xLQXUT8mVi20ovrVe6TqxY=;
	b=IPoMTw8J6YqE3BRSum+YkUgJ70e2xysEnzolRjF7gdnmTk4dFWxni/FsbfjhuAAHn/NbTT
	DIeIY+gVX0tnFQOQneyTPZEa44CbaspC0WkmwOnvlmUCMagV1fw6IRfYOyv61hGgaHKihY
	sc2O3zPheSPsHj4+63LcYAxpCX+ILL8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=izesOQcJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.126 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793338837;
	b=TsDzIlGMsZUOb/QxSfuUPUWlKJX/Kd74ZkhWkaqMmAuwRTQguiimnrSHsyRkTXfToh1CBS
	t/JTBZcp/fsHN97s+3nhDvWlxwJBcaSESmCm8aaJlGXnZjGxh/seUXdmrxvH/MHQv2IWtz
	UR+AgbOMoIuO7uA7JDnoojA3EBLb67E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Fp9j4vIf/d5KUh3gOQVHtCSAX3O/PbmV7P4bWJC36bU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793338835; v=1; x=1793943635;
 b=izesOQcJM5E9h+R5MSvYiurMQRyYhpA5Yw54y4gXe71PcPWxt+pobP7pmWLbuSv7crpyjZvb
 gmsfZBdiWOgHcTLDhs5pdI1aaNzbPDFsT59DzTsd3CZMwfx5nkT5vnJd9Gz8v/gwKfrANhixSro
 +nxd1ZVhT70aqZwW51TjTAgo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 04770debc8262b1a;
	Fri, 30 Oct 2026 05:40:23 +0000
X-Mizu-Trace-ID: 04770debc8262b1a
X-Migadu-Flow: FLOW_OUT
Message-ID: <b36ab4a7-b692-49e8-92b5-1dc4d76dee00@linux.dev>
Date: Fri, 30 Oct 2026 13:40:14 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Shakeel Butt <shakeel.butt@linux.dev>,
 roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>
References: <20260916125737.1095414-1-cui.tao@linux.dev>
 <aqxMk6yaiFHeeAAg@linux.dev> <aq0HNe5s3zvOnM_I@tiehlicka>
 <aq1lqJdVZ1stTKCn@cmpxchg.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <aq1lqJdVZ1stTKCn@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0516D1A0006
X-Stat-Signature: ckphke7r3ha6c46em3dukxt5jzu4p5ex
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793338836-191778
X-HE-Meta: U2FsdGVkX1+W2blO2kFfZ7DCwZRKc5kqy+sFtRMLkkfAVUmirNAhnF1cGAKnvBGTmluZw608mb4AKohyll6CMlud7KzefBoMZWnYv+NUhQVYXhJGDsqITU39MKniA6dAgZJ9KjjBEp3NkjU5nDF5jsYHIC90czTBsvSGiud792qjGOu63Cno1AjzDrf1Va6bAIz2iVCbLNzIphQ13mrE6bxXHt6gL+LO0sDeJCcOEDPXdXcM1xzbr519ZdfAzdiS3fGa92TaB8j9bGaC89IQe1eUW5CG7Fn8LpOYoAXGCoN7ostHAxOANp/CCtnjkkeLdqMUxx0xYXfDSCgSnIkWcyAKmZrclA9ORXisyd89JJCRaN8KiGe0wpSO9BfKI9axH5oPMgOA5JoE4tAheTZsp+CgO4HTVnCwz7XD9aNtC7ljo4KOSbW7aRRB/uH6TkQUnB/n4C3mOJMBEjEEqzLeDSaRmW8PSyioJsLbgshBZfCfZm1yf8N2Su7mWsX+UCuSLIXO69wpiomEP8gvg7WgX+WTdHPheqPLKLmC6xPUH0Ich0PH1TbNqu5ObAP6+1iJ0pcHEKK2gTXRUJ4ya6dI+m4qNT29DY8u3lGNfVX/4RJKPCYZzEZRFXeNCruJOHhL1moBvQ76/kLR92rqdxdsucrinMvPgAvwW7fZfUMvUQPhum7fbsNIBz/LjyElCR9pNifJj1MsFPmJsZkmKCmwPbnC+i0drSMMnSbbsqBe+h9/t0DLFzE/K7dwe7cD28cO07KUtC0+D6GEMCBhgH+PLQZVx3j0umRfeUvKji+sivpJ0AJN3Ahr6PHyfu9Ti22pVl/rO1WeVgzUYLJuFNbtK/umsFrqUJu6pNRX+uvIO6XBU4J9DnfLtF5mRB5lZK8zMqZ0ekl72Snmb9d8pC5Ocrv6OgsnMfGgTLlBEEJBdOuwpzNKAV7sCisP47mTXdbdwnYbdaUKB5eCP9F7fsk
 pYwi2+54
 9gbmTeQ3tLzpveSziYv27VF0vSRdSMTWYLRvWzx7fi/KRI9f15qWPm//N+RUOPTgruh+sVb2ovatwhCSunC3P3KQrKX7CZT0BzGwoRg4N+ATNCHafbFx+ILgwWK10E8H455wN/Yg74xcN4BWKrEgqz7RmJW/6m7oYJVCfX/6t3MccapDSl+D/vGvv5nsyg7kVhxV+fHDVlv6lhAIcaaM4B/x6bm1dd5dVo2LnSm6CqVYxjQSGa5NFjcIzVYrOOwcloGxax+7YcXxhsABN5/Sx+FdWIy6Xr3iuWKWbXGeXzWsuY5Q4x8000Ga/JLVrviHr0Y7OvS1Thy+yYoUSWcqTXxC7578x6BX3Fecm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Johannes, Shakeel, Michal,

在 2026/9/19 00:24, Johannes Weiner 写道:
> On Fri, Sep 18, 2026 at 11:41:09AM +0200, Michal Hocko wrote:
>> On Thu 17-09-26 13:26:40, Shakeel Butt wrote:
>>> On Wed, Sep 16, 2026 at 08:57:34PM +0800, Tao Cui wrote:
>>>> From: Tao Cui <cuitao@kylinos.cn>
>>>>
>>>> The legacy cgroup v1 memory controller has already been moved out of
>>>> the shared implementation at the file level (mm/memcontrol-v1.c) and at
>>>> the Kconfig level (CONFIG_MEMCG_V1, default n since 6.11).  Its
>>>> per-cgroup state, however, still sits as individual members inside
>>>> struct mem_cgroup, guarded by #ifdefs.
>>>>
>>>> This series isolates the deprecated implementation from the shared hot
>>>> structure: all v1-only members are grouped into a dedicated
>>>> struct mem_cgroup_v1, and every access goes through memcg->v1.X.
>>>>
>>>> With this in place the v1 implementation is self-contained: its
>>>> interface in mm/memcontrol-v1.c, its state in struct mem_cgroup_v1, and
>>>> its eventual removal becomes a localized deletion of this struct
>>>> together with mm/memcontrol-v1.c, instead of unwinding
>>>> ifdef-scattered members across the shared header.
>>>
>>> Sorry I don't see any benefit of this code churn. The code is already behind
>>> config. What exactly this code churn is giving us?
>>
>> The only arguable upside is that this would make it ever so slightly
>> easier to track v1 specific stuff (once that s@v1@memcg1@ or similar).
> 
> I had the same thought. It's kiiind of nice to see which members are
> completely specific to memcg1.
> 
>> I am not convinced this is sufficient to justify the churn either.
> 
> IMO it helps that it's mostly in memcontrol-v1.c where the chances of
> interfering with other work are pretty slim.
> 
> The patch 1 + patch 2 split is a bit bothersome: indenting everything
> into a union, only to then move it out in the next patch.
> 
> Tao, if you folded these two patches to make it one clean extraction
> and changed over the sites at the same time, I would probably lean
> supportive on this.

Sorry for the late reply.

Thanks for the feedback.  Looking back, I think Johannes' point about
the patch split is fair.  I split the first two patches to keep the
initial step semantically neutral, but it also made the series look
like churn for the sake of churn.

I'll fold the first two patches into a single extraction in the next
revision.  That should present the change more directly and hopefully
make it easier to judge whether the resulting boundary is worthwhile.

Thanks,
Tao



