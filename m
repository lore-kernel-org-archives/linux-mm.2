Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB69FC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F216B0092; Fri,  4 Sep 2026 12:18:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10306B0095; Fri,  4 Sep 2026 12:18:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26036B0096; Fri,  4 Sep 2026 12:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A74DF6B0092
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:18:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D9DF120134
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:18:36 +0000 (UTC)
X-FDA: 85176587832.29.FD364BC
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 08ACD40006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:18:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lgoUnUvQ;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788538714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LjUp3CV9yKEnetekUyHn3RayljW6XMUXGPpbgLl2ZBo=;
	b=4o23fcM8Th7YjsDkh2XYF174NeWeOO4PD69Dpvw3jdvCW7f6ClhCqkQnMpPFgy4SLfxF3A
	WSHhwULafayRHil2hshANuhmd5J/o2n42j7IdcrnEQjTe2lVn76ngGyJopD1WttjrxdoiN
	pnrUzu4R37eGCmjZqUrNAYYOrUBr5Is=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788538714;
	b=7wKHJHCPmG/u6cPLj6WdUsdrKrZPLNfp0SdBFlXAca2zx4R1TwNVyuTjhrsMA/+1hMrdyi
	DmD8f+v1HTqJcXtlwX2uAsymzIa4qgR4R6RdHuChzCVAWrIc8S9KgNk+zcic3WE+3XQ5F2
	2iMGvESIjczYHptnICOVRcgea7oAzVM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lgoUnUvQ;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c0006ea8eso16691841cf.1
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 09:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788538713; x=1789143513; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LjUp3CV9yKEnetekUyHn3RayljW6XMUXGPpbgLl2ZBo=;
        b=lgoUnUvQH45VQMCZGUvR3hVvQ+HemATTn1z2B4Z6N8Nhc+Hn6SyNGWwcMhfpvZN36d
         /3Fgyfhbh+Xi+P4O8fRSqlM95nu5zkvbrrlnJscYoqGGnkBAsRWeNqNs37UfUvx9vv6R
         INEPXN6pABWSTZOKChF0rjBdOQ9ZdcvkhB1nTbqdLXzXGwBoUd4g5CgF5s+jkIxWzSmw
         e+Wvz1P/i+Tr9D7+OS5vKAp6gepzADXCgvaxMivVDAPQs7PMLxa4Y8EMpzXVymk2eEt1
         yNwKNxQvHa9fsabE/Hj+HSco9khLxmCx70U259c4lera7bqBD55RcwAn3RjEDFAweWEX
         7x5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788538713; x=1789143513;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LjUp3CV9yKEnetekUyHn3RayljW6XMUXGPpbgLl2ZBo=;
        b=eCIYZDaS0pSywXabPEJb1FOFbp/+us5JDjEI8FQjltDzSx4k24LS1vUT1pBKGEYg9I
         tSfBUl9jnH+jAVM0EF6ZWzilSLHh0ayROyK5Qe8EXLxXkwPFqxw5z37pfdBmTM4rbcSl
         p9e9X8+LymE3OYeISKCGFJaxT0zz1/tLgmGfZzyrN3Ri7s4jO6G2WxNJpzdAWNsb8ZLM
         Io+/4LEMrbuWLUZh/T2qpBu6XMzixFkCZK7TKADSFZ1eztHhJ2NxtOGM5Wy72uRDbah/
         +hmULSmLHyMEeNe6Eib5aZsI1p6GEqd/gIntoQHuXRe86pqwId+EVTQmYE/rid01+Ls+
         Jp0Q==
X-Forwarded-Encrypted: i=1; AKwUvBw+cBh6LuQOm+pUCiQcTnjAtWT3lx7nPEqTrp2P8y1oH2gzHAH3pR3UuSPahHfXkegzOYJRSnBa4w==@kvack.org
X-Gm-Message-State: AFuF++nTSWL4K+ZQzl2CzrLJwXH2n5P21e4SDzn9zCy/CJFXg6JFl6yO
	6PLnhjq2T0HO2qq2E4LO0mbQoL9PoL5QgjlKkDBau1d4VPjKLuneUELa+6vZzbx20Lg=
X-Gm-Gg: AYBFou1SDd/iutXpURZ/AtHajV8E7Eey2bRBPPpLFqgqdhndwZi/TbIp/p8s8nPiWcF
	oysxSiAoP/JgbPXA8hKhXdQc9e356nOoTYHuWumzgJPnwKABz2StSY/9qROtHKtHDtscWrGzp5a
	sy2bUYOmx4qV6FMioZMrpeSlbaMpQRhMBEER60CLakI8OMKfcV6S1LtlHDQ1UoH6ngBY2aa8sO7
	GdDpL6vUnVCAQQS8r1/oysUYjByLfYvqywtUEUHMtuAOUptdf50bSXqqVpoyC2hivrn+1oi+zD1
	EWHA5nzWZJIAGuYOlfrq1p7Ksk47edApQ8jDcDoEJlSVi+63bT5aQ8OnJsccnlaZE9kltTotN+x
	XPEp7ullvrODJw5fkrgaY422g7DYlCqJCgMLDX7K/OYdkNH88ZJnkbCuYf0Hgv+9U7D6xun/UwA
	+KJSq9gy64jw/4MfvtilTfIRWR8vQ/krW/qXiu
X-Received: by 2002:a05:622a:5814:b0:52d:6de2:906c with SMTP id d75a77b69052e-5305484e3b8mr66521431cf.14.1788538712939;
        Fri, 04 Sep 2026 09:18:32 -0700 (PDT)
Received: from localhost ([2603:7001:f100:501::2])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53054180ba7sm23626471cf.18.2026.09.04.09.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 09:18:32 -0700 (PDT)
Date: Fri, 4 Sep 2026 12:18:30 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, yosry@kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3] mm/memcontrol: skip non-hierarchical memcg-wide stats
 when v1 is unavailable
Message-ID: <20260904161830.GD6641@cmpxchg.org>
References: <20260903215616.1456239-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903215616.1456239-1-joannelkoong@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 08ACD40006
X-Stat-Signature: erduotmc3op5j81fq7rthsa8acedk7cg
X-HE-Tag: 1788538713-960568
X-HE-Meta: U2FsdGVkX19jNHVoZaaamdB9Cz6/05X0i5JTGnxIELRF7uNA0GsDoVcH//gxBYv3ElUOfOmRMNV76ZV0OfCYIbKuvTV7EtZr15IH8niCvdvygnrAs92pTbETGl1YFI9di4uHnnA6QomIUex20/qyDpkrXXEdab9OzM6GoTURWZ6k38g547bX5GOn+b2g7r/LU2d8yo71l+oFPNJdOCY9jNDt1v6lZT05hEyA6fDXmc/IyUHbCQTpIp4RL85U7CU74wrMyKsjGTw8CQArW4Rx9Vf93tSSxoq4OqN80jzORQz3IK0ASCrLYCNCAYdMxk9hqcwBXIcFLxeXewVCkKQyiJ+/004YYFfkiuruHcf666EeXa3QQlDFLJjW7mbhXK5MA6AlOq+6amvoX+UGYzbb4ZA20Nc4qtDwSyvDoUFdW5iI/e0LxBsEd3aB6VdYYijorsELhrwlrKJ02kh4Ih1KjxW9kDgEpATpFCCKiL4BTf3wO6CPs09v2MJ+jsWMifY4xqZ77HnjdSwsDc0mao6OqsNnLMe7yP5tuxdScOnG/e3VhpGVoIYqWnEnSvKbGkRqixT6xKyIMji+c7TXCmZNJVfbUL7lztCz5GN5FoYJixv1pWGZVa+5BRO801QEJNGcFK+Uu/hmBKl1b6sVVkkRRCtwLiRlycJh2dIc5c/pIZif2dFaos7OmZTe5QaUQhxZAy1qp4t0QL1CoqZB6boDRb0UhP3E43HGaS2Uxhimx+RpI4b+on3bR7txCKqEHfKQtfqtdOHbEiT/dBvXPafYWxSlNsME329wOC76quvgWGYC9hn8dEf/FeXo3QmOSr1qvevXX/wmxQABSK3/G5frEnjscPZ4yh1FBkfh1Ko9iyZPm8fuYfS1JV4KlNyba9zXk0y+Jabgg7A9jjt5TjWd3P4vzAYvYryjOcg44ExTzdeaS+CCxSEI5h+TEEbdVmgwY0R0096h3y/IIzN46mj
 sE1xLGSQ
 7lPxflfFK5BrmuOON2pGqgnL24yok4hOa9kXBzKrHCsiR1J2rFIFPVy1LefRSH/1WCRn1M4sDmuzJWDSnxr5h1sR1c4D1xxTlXHcLFutkrDuaUUySkzqZ1d/uCAoY0pocadAaLH9jOR8m9fAN1dfKcw2zPg4CxUeS+zRwkweJI5z4WgDQrU+j7WpI6cUOs/wyUVoF1E+Qn9UdJrATX0+5now1wOKmYJGmeSKlc5JoIe65KUIfOhioWod2FvYanLQTLA3HHS7vlFpQjBFrwE6PdX7zySpm6zmyUwXPLVqv3JE1CVkoAcEDSosDXweBVUTNDhdONpgsk52QQnV0pzZBADzWthgZjgxdQ5Kx2QNrIO+QYPY1njNUIrff3nCfusSbJZuJRaI27CJLjfm6DrwDP+gbXxUa/XF6rkGEPsbm+AjTGzPqvZuFzLgOX+rff51qJJ3v6g55ae3Ax5s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 02:56:16PM -0700, Joanne Koong wrote:
> memcg_vmstats keeps a non-hierarchical copy of every memcg-wide stat item
> and event alongside the hierarchical one. The only readers however are
> the legacy memory.stat and memory.numa_stat, and reparenting on offline.
> All of them live under CONFIG_MEMCG_V1, and their accessors
> (memcg_page_state_local() and memcg_events_local()) are already compiled
> out with it. This means on a CONFIG_MEMCG_V1=n kernel, memcg_vmstats's
> non-hierarchical arrays are written to on every rstat flush, despite
> their values never being read / accessed.
> 
> The same holds when the kernel does support v1 but the controller has
> been blocked from v1 hierarchies with the boot param
> cgroup_no_v1={memory,all}. A v1 mount is refused in that case, so the
> legacy memory.stat can never exist and the arrays are just as unread /
> unaccessed.
> 
> Compile out the non-hierarchical memcg-wide arrays if CONFIG_MEMCG_V1 is
> not set. If it is set but cgroup_no_v1= has blocked the controller, skip
> updates on the arrays.
> 
> This makes flushes cheaper. mem_cgroup_stat_aggregate() can now skip the
> read-modify-write of ac->local[i]. Nothing else accesses state_local or
> events_local, so those cachelines were getting pulled in solely for the
> writes and they are separate from the ones the loop is already walking.
> 
> On an 80-cpu x86_64 machine with 500 cgroups each running a workload that
> dirties anon, file, dirty/writeback, slab, kmem, mlock, and reclaim
> counters, timing mem_cgroup_css_rstat_flush() in-kernel in TSC ticks per
> flush showed roughly
> 
>                          before   after    delta
> memcg-wide aggregation   1231     1180     -4.1%
> overall flush function   2452     2397     -2.2%
> 
> These numbers are from taking the median of 70 samples, one per 20s
> window on each kernel. The 95% intervals observed on the two deltas are
> [-5.41%, -1.76%] and [-4.53%, -0.14%]. The values above include the
> timing overhead itself, so only the delta is meaningful here.
> 
> Counting the items that actually changed, a median of 1.5 of the 77
> memcg-wide items (57 state + 20 events) had a non-zero per-cpu delta at
> each flush, which means the benchmarks above are with one or two fewer
> cachelines pulled in per flush. The count is low because the benchmark
> reads memory.stat in a loop to keep the flush rate up. For cases where
> flushes are triggered only by the 2s periodic worker, more changes will
> have accumulated between flushes, so more cachelines are skipped and the
> per-flush saving should be larger.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

