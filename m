Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC34E60A262C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GqIPqxUf
Received: by kanga.kvack.org (Postfix)
	id DF8946B05BF; Mon,  2 Nov 2026 08:03:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA9186B05C0; Mon,  2 Nov 2026 08:03:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7466B05C1; Mon,  2 Nov 2026 08:03:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD2616B05BF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:03:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47DCB1A0CBB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:03:16 +0000 (UTC)
X-FDA: 85390194792.20.25CA10D
Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	by imf01.hostedemail.com (Postfix) with ESMTP id 343E140010
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:03:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GqIPqxUf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793624594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FXUqkUNHxYE2NGpJQs5al5RvPwIjMfRnSOyTuQqz9ps=;
	b=lsK061MjWOuw4QuGe6apMpvJ8IE3gcJPXGzQm+nQZP5vGmSeyoZfWxDWFVELmnsMYr8CyT
	b8Me3VfrnvP6ov2VNkff2kVZ8pq04eycDK+aqK2D5QSW2nOCuVZuXaxAVNE3FnytiLawMX
	Xx0DIkB2RAf7cqNtu2so70yxFLhMsak=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GqIPqxUf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793624594;
	b=GSV2zFdtGpptKdbvy6GofskIUy1iiL3BNym9KSCx0xa46arMQzPGv3CRoH2GUHCtgvdmV8
	xgeMNgXAnlfp8qtTmgLZT5cMg8Ce6VajGU6EzTcIE6bBgBZ2HdbcYahZALdhGBkWhrpTUl
	rc+RnPsy0qddQWGnpWa5QatlSEhwtOQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ReST3cWLqWrD/t1sA1J8bJ67KuQOqTddHpAzRisO018=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793624592; v=1; x=1794229392;
 b=GqIPqxUfLfW7mSUNjHodoC2JNe5t6hFUMQgYL22fCM2tZQyOnaGgGP3RC6UReR655Qj/SKsD
 BzAoJI75o5CvVAA+tJBk0Lsb5rKxw5yZXAmUpWosbPLWvracM6vQOrbqjbAh8DiGzvDD6gHZxRS
 ZS2fMbo2RVsmx5OnsnjK8eNA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2247600f0cc60053;
	Mon, 02 Nov 2026 13:03:12 +0000
X-Mizu-Trace-ID: 2247600f0cc60053
X-Migadu-Flow: FLOW_OUT
Message-ID: <32e80536-64e4-4ae3-a7da-4a37ed415f0a@linux.dev>
Date: Mon, 2 Nov 2026 21:03:05 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
To: Roman Gushchin <roman.gushchin@linux.dev>
References: <b36ab4a7-b692-49e8-92b5-1dc4d76dee00@linux.dev>
 <0BEF7489-16EC-44EE-847B-A6AA380BE11F@linux.dev>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <0BEF7489-16EC-44EE-847B-A6AA380BE11F@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 343E140010
X-Stat-Signature: izhjhyon45ux1up963a1mwy58tya4oxp
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793624593-175854
X-HE-Meta: U2FsdGVkX1+VXeG8JLlEzR+o//zecCoWZt66Of27Kt+5p5efkVLUKNMoNMiw7iuN6P4UNLJmfdQNmYlEjWdM47+7rxQmUkz6yryy0A0AKbxBRcnATethaID6bHeLhhIzjC4Sp0wscM22r+VgJ/ohPOqbx4W75fSsu490Eub10jz1h40zrQ+87Ib5v8U2VNceyV9YaefF/BVjIphUMH7eZNDWmF1fZzhme+Hb9iKJJInEE4hx17mXB8T6Oe1HG/UwcRS2eFKgvsm0Xxr2sESUnFUnXvYqTexu0TadI3AzBL3jxl9XRG/kDiqlLQKavI5i1OEXmhoc/qLcwLd1xjdGGEExYaYPSAaKbnZ80t59iTg6O+IU+wGjzNCXIYP0Gjmyj/4ymHFPXHuoIw8iifFylin/QF+KqgkhouBZVQH5tclpyPOhiDV9Xc5vB9tpIRAhMc9MZVeD+eWWFR4o/lw3rQ6TXT8nrnS7Sem23lLeqkCJdfKX9CKAa3aB+ok82/4HFr1AXYFTd99ewscxFjNjImoAuHX5CW71FwFzPt5ViE6l3sP7dIAWxczutWSaAZ0CFND/GqIRrkfNMKpKRDig7NLPKyGLVDY1a5vqMcBVQBIamVugjuVxejeU1dC7t3MMRsgfBr4jsRpTF42sKJJwKbhShHuqQ9Gs1XX2ACti9zq5mNDgXmWdycSebNfRiXYuH1iasAAnHobLeR4uUEDGR2O+teIeczzWtwR88HocLz8y9VnwlodjJUuEEotKJxSPZRuLy3L1SCQNsSLp9z7mL5tcdPLC+FXUX9ZiuuySGrL5gV0bg2ZctSnE/k2jRiva0k+qtWxpMqNqfUXce9FTCd+nh4rKhAQDVYd3IicFMGqp4jtmJwI91iG+ozAR5nOwpw2PNf0zvsCjfy9OfxhPa+TJu80M+q1m4ZoaZPaiFhIGmGkkagehuarq4yTcY7EwWTSMR3UCIcBev+AfsAG
 M1MUeoBf
 o4L8QIwR3EY+KgGlQWUBTRFT9ZceMEY2McV8uDEvAPiwy3aM6zB9LLJg5siYA2n1/k9hd4fTjDrejyRb1xogbhomjlDqX7Q/4bU5zWvWzBWyhMOBeLISJ4iaF7jd99JuVvyBROBb58pevwUJvtdmcVqigbHjjR6+GSfXXPlvrzbmaKJUcsInIqKn0SBlhy8Oo1N9LbHmFFZR954jJhLt8f3tANas2CDGs1yQABBJLCZngJ/haGyF0T1U1YVGeJq9X6ANq54LZ4CfWx+1WxTPyM10WelwJJmEwgfSlwOuBONkIX2WAw7UEJhseLTbXRzXdGfy5wNOdg4b0L3uVRY2oXgNnmZwUnSFqYcfv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Roman,

在 2026/10/30 14:05, Roman Gushchin 写道:
> I believe we want to delete this code sooner than later, why would we rewrite it before that?
> 

My assumption was that v1 would still be maintained for some time
before its eventual removal, and the goal was to reduce the coupling
between the remaining v1 code and the shared core structures during
that period, rather than to rewrite the implementation for its own
sake.

If the expectation is that the remaining v1 implementation will be
removed in the near future, then I agree this work becomes much harder
to justify.

Am I being too optimistic about how long the remaining v1 code is
expected to stay around?

Thanks,
Tao

>> On Oct 29, 2026, at 10:40 PM, Tao Cui <cui.tao@linux.dev> wrote:
>>
>> ﻿Hi Johannes, Shakeel, Michal,
>>
>>> 在 2026/9/19 00:24, Johannes Weiner 写道:
>>>> On Fri, Sep 18, 2026 at 11:41:09AM +0200, Michal Hocko wrote:
>>>> On Thu 17-09-26 13:26:40, Shakeel Butt wrote:
>>>>> On Wed, Sep 16, 2026 at 08:57:34PM +0800, Tao Cui wrote:
>>>>>> From: Tao Cui <cuitao@kylinos.cn>
>>>>>>
>>>>>> The legacy cgroup v1 memory controller has already been moved out of
>>>>>> the shared implementation at the file level (mm/memcontrol-v1.c) and at
>>>>>> the Kconfig level (CONFIG_MEMCG_V1, default n since 6.11).  Its
>>>>>> per-cgroup state, however, still sits as individual members inside
>>>>>> struct mem_cgroup, guarded by #ifdefs.
>>>>>>
>>>>>> This series isolates the deprecated implementation from the shared hot
>>>>>> structure: all v1-only members are grouped into a dedicated
>>>>>> struct mem_cgroup_v1, and every access goes through memcg->v1.X.
>>>>>>
>>>>>> With this in place the v1 implementation is self-contained: its
>>>>>> interface in mm/memcontrol-v1.c, its state in struct mem_cgroup_v1, and
>>>>>> its eventual removal becomes a localized deletion of this struct
>>>>>> together with mm/memcontrol-v1.c, instead of unwinding
>>>>>> ifdef-scattered members across the shared header.
>>>>>
>>>>> Sorry I don't see any benefit of this code churn. The code is already behind
>>>>> config. What exactly this code churn is giving us?
>>>>
>>>> The only arguable upside is that this would make it ever so slightly
>>>> easier to track v1 specific stuff (once that s@v1@memcg1@ or similar).
>>>
>>> I had the same thought. It's kiiind of nice to see which members are
>>> completely specific to memcg1.
>>>
>>>> I am not convinced this is sufficient to justify the churn either.
>>>
>>> IMO it helps that it's mostly in memcontrol-v1.c where the chances of
>>> interfering with other work are pretty slim.
>>>
>>> The patch 1 + patch 2 split is a bit bothersome: indenting everything
>>> into a union, only to then move it out in the next patch.
>>>
>>> Tao, if you folded these two patches to make it one clean extraction
>>> and changed over the sites at the same time, I would probably lean
>>> supportive on this.
>>
>> Sorry for the late reply.
>>
>> Thanks for the feedback.  Looking back, I think Johannes' point about
>> the patch split is fair.  I split the first two patches to keep the
>> initial step semantically neutral, but it also made the series look
>> like churn for the sake of churn.
>>
>> I'll fold the first two patches into a single extraction in the next
>> revision.  That should present the change more directly and hopefully
>> make it easier to judge whether the resulting boundary is worthwhile.
>>
>> Thanks,
>> Tao
>>
>>


