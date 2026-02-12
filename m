Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B64A2EEA851
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 21:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A67F6B008A; Thu, 12 Feb 2026 16:25:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253AF6B008C; Thu, 12 Feb 2026 16:25:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156446B0092; Thu, 12 Feb 2026 16:25:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0339B6B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:25:33 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9989A1C0F0
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:25:32 +0000 (UTC)
X-FDA: 84437086104.12.6D45834
Received: from mail-dy1-f193.google.com (mail-dy1-f193.google.com [74.125.82.193])
	by imf08.hostedemail.com (Postfix) with ESMTP id B1C0A16000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:25:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k3FDW2V8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770931530; a=rsa-sha256;
	cv=none;
	b=FRQ7RxiTUj4deHrRtd09QlUKcJDX+iBhsYoU9MyT/v1T02TriQ430FukIpMbLdphtCgrzZ
	ScGsr9EzRRrPlFcy6iRPRlfTIQwNDYBszvnUWGWjCLj2TD8KgVFqGVOR6wmIuDl+DlIR7q
	WmoqDgxEPY5VIFN8IupsPn74y+EWfTU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k3FDW2V8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770931530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCh0D1PgFCAnFv/ObCs8wiM+Hp+1ve3byqWcWmOrNFg=;
	b=RASffkr/aTyay2nRJNU3XNczVcX2ko8CgO+C+rA84oKZHBpm8SNlH/lrdqXoSWIVCF8b8l
	+d961WKOn57aRiB238rUQ/Fp6fwa22VHLX64EgZV44U1xcia4Y62hP4917RVWlMX+1S/Et
	N2l8/ZagKOPS+goY/7JH/cdz1IgGcSE=
Received: by mail-dy1-f193.google.com with SMTP id 5a478bee46e88-2b4520f6b32so386700eec.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770931529; x=1771536329; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BCh0D1PgFCAnFv/ObCs8wiM+Hp+1ve3byqWcWmOrNFg=;
        b=k3FDW2V8SW4d1CChwOLoNWXo1FA5mlxjPR8YBfI+rRcjgzztncpHZnsLwZDbGf5ixw
         H/tpkofWN7hBfTIa9K9pnW9tu04pSDpR3MLBzxZ1CVE8ELqdjlubB7tYY5IWbuijptv1
         htLxa8zbIM5sSJlbs4nSskWu1RUZCu6Jwrb1XuFLIrrwi1QRh9A0RiNVyYa14GcpsSTr
         7fNe8b5N01jG4OI/C5cThJafoquadjwO0uGSwetdpg1SALyuvOJN1Bm5Rj4Jsu7Clxgh
         W+Q/WsRnH2XIegybQg1YKWbsM1SpD98g1Qa5D66ixE7902RFLwH4yh/p7UwzVdM8hQN6
         f2+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770931529; x=1771536329;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BCh0D1PgFCAnFv/ObCs8wiM+Hp+1ve3byqWcWmOrNFg=;
        b=ZSGOHKDARhibYPX1QSXG5nrashGBDQpFqrheqBxCpnNQHcrg5tOH88AiUDOUZFsWLv
         2lD/YyFyqhflNo74He0Nr6W/XkI4HB6skDgDhgYPmtyrepI4nwTjz3KJZ1blH2wvOS8X
         ToUzI4TV+/FZGcuf6lCUfDEoZXhpHrqrqFsEPUYlq5WR2mInJFQBjNC+TqtF8KwQ0uBv
         A6RMVZgzn/skk9EtclHDhjV5lXuzjiLHGkgtj0K/3fyWJHrZeTvzeLlHjF/DtoG4Dda9
         AY0fcMRaOACA86kYgbNwgwKNfRCsdOXHUnV76E30ScdR3cdGxcyN8daVj5bzbl8FbvY4
         2mRA==
X-Forwarded-Encrypted: i=1; AJvYcCVRXl8Ywi7PyvSW4NoIiIH/ecOzZxbEOMmvAlfT1tFVh3HW2yKsKgaEgvCT2RqIHQymiIfbrFs09w==@kvack.org
X-Gm-Message-State: AOJu0YwAaChzRyMsn6ytqzDlItDEljnd3hBjwkYa/1enT9o8K+4A5ywf
	a5oeHarSTXZAYsPi4rr7S65vfWMkV85ymf9MwVR9ZmQ334AkRz5lvqXq
X-Gm-Gg: AZuq6aJn7RnOYUA43z2O4VGyXmCsNNX4P+eXJ1wQ3j01hHYirx841K0QgsvlykcWn5n
	IkLcma4lluffiAZcKE3Xmau0lRTFBZRTR4kXb4lVv9yqCsaBsdz2q6d9kEq/Ej1hKOwxHBs9exj
	QI/mHT19kcDgZcA3a7zDpUNqTg4jq+tQJwf4k+4dvzggZVBDvWKlGp+Wu6zego40MnklncBK2r6
	V0UdtummQRDIu7uwQxE630q/ggnICcezhHp4lXF4ZwJed+b01YNybWon5rfsrb6IBhL/U+iS1qq
	Msc3yfEfCtHgcG5/EFEIdgXforevAJ5fH/an+xWKA+DYxJLQYUAKYPZIVMpZlkqRNkG6vJb4nNy
	hDGWL4x7yNqkn8sNbDmWZlUAnl3WWhzBPlb7OoOndhfTmpZS5ZnK/Yz4WMT9kpy/TnCX01r0Lao
	0skMzQ5bjnkH/4OUeYyDp9+nZN6vJMAjHu
X-Received: by 2002:a05:7301:7c12:b0:2b7:f44a:a6ad with SMTP id 5a478bee46e88-2baba136a9cmr114756eec.42.1770931529389;
        Thu, 12 Feb 2026 13:25:29 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9dcd0614sm4779914eec.22.2026.02.12.13.25.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 13:25:28 -0800 (PST)
Message-ID: <b5927ae8-3108-4d65-bee9-be306fb697b4@gmail.com>
Date: Thu, 12 Feb 2026 13:25:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
To: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org
Cc: apopple@nvidia.com, akpm@linux-foundation.org, axelrasmussen@google.com,
 byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
 eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
 hannes@cmpxchg.org, joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, mhocko@suse.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, ying.huang@linux.alibaba.com,
 yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com>
 <96b63efb-551f-4dd5-b4a2-ac67da577431@suse.cz>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <96b63efb-551f-4dd5-b4a2-ac67da577431@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B1C0A16000D
X-Stat-Signature: byyksyi97wn5dppqucfstcpbtxz4qu6a
X-HE-Tag: 1770931530-519270
X-HE-Meta: U2FsdGVkX195xQb+ycmqbyRgGgJ/M8Z0AqTfx8XuPs1+frLKlC4EBXBjZHgxLtkPEXc/nsceSPKTJKm9f1S4owrQrsfnpZ92OiYN23UwjxyenernNTTVFX9QMfPWR2V+/HOEzOmXotu5IqlyFP0Km+iLPzwTr8y6d30oWCeDXyJ7Hcqil39DRjbqZ1qobNhfcIjdlqfUuZ2oBO5r9Wyny/7+yJwaCtzeauS3w4KVXQQtOKUYHpvHmUJxqIT3hDx20K2dNlBLFin2vXEJl6mcnuJ8FIe0rRmBMsQ0Yec/KtSWVhi/I957jMFf16Srng8/f/wY+ZcQlJlMzj1EGOVo061npTyBhhiiCKcDVc0Z6zflStbkpXa1mmVoVwOsUEvDK24mCNkx8iowHm3pv04pfcVAn5y/LWbNjgwk5oZgT/JN3uzYPyj2MjdVPXEOh2tQSvBZJwElU2IBDS4nipf5453ziLi6M/BaZK5ujJ4fAYuCQFJqltkypFo4/AXKdCXTeqyjPpgEyZRknOVGj9058aanerJHOVKIMc3+80MOvEUK/TKPcM7j1wjwi9UlLEIQlFW/IWMqyOCdB5vwpcLFnzmiiSxSOpP3+PIhg9sTs4Kt2KylZWJvuAD4bpxTps/GGI1ifKOASWfajRx2Qz/M9o0RFRPzOgr9ETfwTeTHf2l/BhN+v6BsKlFuHq5XU8bxr9w74a8aqFRdNRubj2sX1djAbs6ogbEcAS5vNxghJtK73ILn6tMPPbse+4onalWeJZWYgx5MxbPeC5mc0dDPf2itEXIX4380Uo2KCAvTGKftVUpbPaVmgKnFSYVKS/GksWDao+QFBJp23XIrcsk6BT1YzQxZbtm8igowHMtuG+dLDmj44p8Lz6hzP7XxYQxqTSnukp6V3hMp2JkaoIVstfFKlv7BiPgdl6YIYQ6RcETY5IqH3yGPCN0sdvQCq+WA75CwVFds6qSFRPVVBqD
 4COU0K5u
 s1nEPnARmlbrBnx4JQ3deOlVpXHBrg1O7YDygSccKfG7n/v10MscvRLIaw95SSXgF3EfTb5BBusjuKA7iw2yAWL50yXkNY5OkxDYL8PRQNJKmgweCKhHD1SzJdqo8fIKd0COfPr7XgIxIcLgIr/BuZXDWQL6DaG87IUx3Y6LuDnTrHPg+5URnbPToOqzWpJeuRrY1iDKDwbWI/MROV8/p0s4UWAUZrsvWOAwMMh5E3lC+29Y7G2+IA1BDWXYmIUvA8UhUDXpvMKaQrHrAq4be2CCHFZHRMn1OOx2PNeNwf2ijFED6I79vbaOzBmLiXAIZtHRp0C5na391Xr9Ci8v3pT3CM9FQ0bnHz0eYW02klD7AQw/YsOfHcKjW1I1xeKI5ygXunQbVG7HgGA9A7dwk4UyG5mTOJM61La/fNRhhYH0MzZG+0K2c90eMAw2bBKU4nwKSan7AOw5ily6lrZBRhQ/zlUbA68lReEU+PZTweGLLhCPkwHhJ+0xSDJBrV3aDbzkX5kXiBcj6cIljmdgC0uACYCeiCM1Ga5XzlbBXCb5jI4Sr84lzGm01cm5oyfyb8oBnYY+gaFeFnB9j9blpuQUxNJ06hwktdSQg6v7cMxtNDbWiFGCXvTQZ0zqMm9CydcZaceaVvkxF+ykgkOO5b0Wwy+Z44oH2SDwwGiu3mSfn5ks=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 7:24 AM, Vlastimil Babka wrote:
> On 2/12/26 05:51, JP Kobryn wrote:
>> It would be useful to see a breakdown of allocations to understand which
>> NUMA policies are driving them. For example, when investigating memory
>> pressure, having policy-specific counts could show that allocations were
>> bound to the affected node (via MPOL_BIND).
>>
>> Add per-policy page allocation counters as new node stat items. These
>> counters can provide correlation between a mempolicy and pressure on a
>> given node.
>>
>> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Are the numa_{hit,miss,etc.} counters insufficient? Could they be extended
> in a way that would capture any missing important details? A counter per
> policy type seems exhaustive, but then on one hand it might be not important
> to distinguish beetween some of them, and on the other hand it doesn't track
> the nodemask anyway.

The two patches of the series should complement each other. When
investigating memory pressure, we could identify the affected nodes
(patch 2). Then we can cross-reference the policy-specific stats to find
any correlation (this patch).

I think extending numa_* counters would call for more permutations to
account for the numa stat per policy. I think distinguishing between
MPOL_DEFAULT and MPOL_BIND is meaningful, for example. Am I
understanding your question?

