Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DFC5C982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E6BD6B00A9; Fri, 18 Sep 2026 06:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BE446B00AA; Fri, 18 Sep 2026 06:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB4C6B00AB; Fri, 18 Sep 2026 06:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 520BD6B00A9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:23:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2B5180636
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:23:15 +0000 (UTC)
X-FDA: 85226495550.11.0A93A1C
Received: from mta0.migadu.com (out-10.mta0.migadu.com [91.218.175.10])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8EF4F100002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:23:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aDfl18Hs;
	spf=pass (imf05.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789726994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pPUGnY4z3dE6RKztsxzatOTkV/cZkLl1/W6Oqt9KRzM=;
	b=V1QTSyIkvE7VRgEveLmVwA8lM/6qW3tqfRfMtYlsad8MgUHuKUkAQ2VptsoNLhvFxmwsKg
	VmtU+v5c+AklORVqyCLMCMQNwvSdBM8nl1sopPDywr/jIjqH5ycN9yVRbj4eRf5zkreLNt
	2hkbL+Jt1gwckVU6Ke5VDbU7QshXb/4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789726994;
	b=n3yZioFOqrv1LZFu5glfx9c2UMUS7T7jIuiAaxR+j7RJ+cOsFGkuA1pExrc8fkiJg5X2b/
	6Dgiy6UgjWn2v1+FmRMIyspCQ5oOYI7uhgXo/lUTTXuZQKt8a71k1ObwE8oOS0xq9QfJvj
	v4TRfao80CuLri3QqjF4xxhDXgv5vrc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aDfl18Hs;
	spf=pass (imf05.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yrF6fA5tlOM0xGyL9ZU1WnjTazhuz2mrZ9NL1QXtunU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789726990; v=1; x=1790331790;
 b=aDfl18HsfTBQ93648RB7nEKs5U6qqQTYncRFV75/11TDqHlHrZnEuqRdsr9AzQLDvZwHbxyb
 dY8NK6TrPj4WyM7g+mjo6blcs9TDmH4cmTiKT3DWFrA6R1BnFYEHYxI1eMI41Sil3zGiK/wYeYt
 9Yn00dMxZUk12PVTqH3UrTaE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 60349c2ffaecec43;
	Fri, 18 Sep 2026 10:23:00 +0000
X-Mizu-Trace-ID: 60349c2ffaecec43
X-Migadu-Flow: FLOW_OUT
Message-ID: <ada49654-0456-4b63-9f86-06ea9c97667d@linux.dev>
Date: Fri, 18 Sep 2026 18:22:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, hannes@cmpxchg.org, roman.gushchin@linux.dev,
 muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
To: Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>
References: <20260916125737.1095414-1-cui.tao@linux.dev>
 <aqxMk6yaiFHeeAAg@linux.dev> <aq0HNe5s3zvOnM_I@tiehlicka>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <aq0HNe5s3zvOnM_I@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8EF4F100002
X-Stat-Signature: 9kmsmghhmde67pkmidch5ix71gtz3gbc
X-Rspam-User: 
X-HE-Tag: 1789726993-597703
X-HE-Meta: U2FsdGVkX1+JMyx6rkxriyyWIpJwhxZer99OCxrREQ7XZZZ9Yh10OzHLe4K+MmMHCb3bc4vfJcimcKn/s5jOgoMelPtux8t4XtrcsGqgAhTOspTKHmotfI5F5H/bqbRYD19qsz1WDU/2wwEmi4WOu7HbRbaFqdiG+EDN2KT9Gc4luZrpebGr7vgEqBKhj+rT+zh+85IlAE/JnBa3jSLP/v2cnakRaR5A4SLe+m3eKcjLPNRyanITO3zz648Xrb1metP/9fgva5iKvmk6tniWK4kfQI1S52WYzdoAbXJwVFBmi4brdddW8WrremRhoG9fdildNLcr064hsZZPPeKHI3OwHJuc1qIlZ4KGf89bzM/olzFYg5ZeRTewAAXk8XghgomfsybXC87KXAmgxwozz6Ax0uXwJfxMCFWZhTwmf/8EpxphvoNqpXZ/P+VtpTrW6YKxlLt3LjrdrhILXLVutueF2aUKWBpKbiDcoH223VwR2gu/+7P+hJdrijfByd1RfOAWMQX7nJuSMj1VeZh2k/Uo1UIiJcxBx00/zW3FQ5AHqVe7XD4E9OlumZyXN2w+/WvPyGOmH9w0TbJGiRUTSjI/cBv/BpQ/wnOLmjcFjV7mFKOIJWg2Dqxq1xew6yk3+PTzcnQteguMi4Xc8spwifSjaUsuZvF7vbr+pqJYldHx5WXbj7CFYFXmWmwdFvVQ/xZdyzAGIfWScYDx7rylr6DSweeKrLYB/49QFsdzhm/aaQaG0TPhYw8inCII6/pGxLQdb8TqQ4JVR/HPYW5ByEX3Q+j1iiMv82fnf/FKFCEUVnVzLYbDxxrO9rDRRCEe7NTmXUcn6bV5LfOst+VD3rVI47CMCzpbD3gmx0DM7tNl9b9P7tOc5UYnDnryo/G3yYqjAiuaRUGVw2wE6xewm/XBSWVEY3gLAMnSnTiF4GyCgjIPef/6d45IWCT3KbDtNuoV7MEgj+5zx1XaF2l
 M4x6nfvZ
 9ppZY0FSZM8mCKdMeBbQGsyuAU/cSO/jdkoOIA046maSpEMskfE9tZKaF2T9LfG2625CGTXt6aDMIOWUzo0rfeLuuG8Sx3B/BCt1tKdnpE+ABw0xssPHrPng60ioOFf7tLvpocoHLsEDb5zRurkQKb+QBFHhWOL6es9NUtVrGRGyHmDy7G0X3TTo1gd8tIOChlLdDiceNsFVNBW+xCdgf38V8XmeHWHyh4IXHMofuvXr93r4kCyYqFdrROqHRxxoRpcd9zDBF27vTpou0OfWHtoTa4N5sJrQT6/GTczWyE2IGA0D7zMWZkKOx3i0y8ELNqRinXHoVoi9KGYeF3JO3Fl33QhHbnUh3ch+y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shakeel, Michal,

在 2026/9/18 17:41, Michal Hocko 写道:
> On Thu 17-09-26 13:26:40, Shakeel Butt wrote:
>> On Wed, Sep 16, 2026 at 08:57:34PM +0800, Tao Cui wrote:
>>> From: Tao Cui <cuitao@kylinos.cn>
>>>
>>> The legacy cgroup v1 memory controller has already been moved out of
>>> the shared implementation at the file level (mm/memcontrol-v1.c) and at
>>> the Kconfig level (CONFIG_MEMCG_V1, default n since 6.11).  Its
>>> per-cgroup state, however, still sits as individual members inside
>>> struct mem_cgroup, guarded by #ifdefs.
>>>
>>> This series isolates the deprecated implementation from the shared hot
>>> structure: all v1-only members are grouped into a dedicated
>>> struct mem_cgroup_v1, and every access goes through memcg->v1.X.
>>>
>>> With this in place the v1 implementation is self-contained: its
>>> interface in mm/memcontrol-v1.c, its state in struct mem_cgroup_v1, and
>>> its eventual removal becomes a localized deletion of this struct
>>> together with mm/memcontrol-v1.c, instead of unwinding
>>> ifdef-scattered members across the shared header.
>>
>> Sorry I don't see any benefit of this code churn. The code is already behind
>> config. What exactly this code churn is giving us?
> 
> The only arguable upside is that this would make it ever so slightly
> easier to track v1 specific stuff (once that s@v1@memcg1@ or similar).
> I am not convinced this is sufficient to justify the churn either.

Thanks for taking a look.

You are right that the file and Kconfig layers already isolate the v1
implementation at build time, and =n builds get nothing from this
series. The benefit is only for =y builds.

In a =y build today, the deprecated controller's state is still
embedded directly in struct mem_cgroup and common code accesses it
directly. This series moves that state behind a single
struct mem_cgroup_v1, complementing the existing file- and
Kconfig-level separation at the data structure level. The layout is
unchanged, so there is no runtime cost.

My intention was to explore whether this could serve as a general
pattern for isolating the remaining cgroup v1-only state, rather than
as a standalone memcg cleanup. I should have made that context clearer
in the cover letter.

If that isn't sufficient to justify the churn, I understand.

Thanks,
Tao


