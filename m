Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C79D637B2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1996B00AE; Fri, 19 Dec 2025 23:29:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94B316B00B1; Fri, 19 Dec 2025 23:29:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824326B00B2; Fri, 19 Dec 2025 23:29:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2456B00AE
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:29:46 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1E2BDB6329
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:29:46 +0000 (UTC)
X-FDA: 84238571172.01.DD8C950
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9A76918000A
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:29:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kuqnLWCA;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moxrTDRP6uua1SfOpGtjjCHSc7BhEFDyhQGMp73I3aE=;
	b=BKyH3hA1G5KgI6qdpo7Le5BqL7urmsAkZk7oRfqB/V+7HdGZ3TtxqK07eopiRfIzuRVzu3
	Njb63b4UREfVNoPJ3fgnoP/BW6dxrMAxxafVou+Q/40U+quEWg65nPVUfD+JBvSU5AzhOL
	eGqRaCaevslzg9riu6dmwZLhXHEBrnA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kuqnLWCA;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204984; a=rsa-sha256;
	cv=none;
	b=VlDl67dmjKkQ8GuckJNTNU99nq+++caO/bBG7TMdUe1MW4pv1/jFa/3sQxX14AUVn9bHxs
	PJJUYxhJ0i0Kcltjn4uHlY1S86oHcDY9Gko9dR7DV8Kh6myQLrRfzTewaJSVUW4kbTsJay
	+3QOwbfPa8YOxnYYDw1FQuHdAlRjdH8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C530B6000A;
	Sat, 20 Dec 2025 04:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39741C4CEF5;
	Sat, 20 Dec 2025 04:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766204983;
	bh=LHAu/dZyFQqqK29xEpICrXmsoRaq6iiP4g0Utho5RUI=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=kuqnLWCAZTNO1hFuZFoMgWDhDNkPQA3euPYG79oVTR2ZJ9D365HS8d7tZSORwJhJ/
	 2rudc3555K/aZ5zARBsFmLwnjDNe1ZNRhrygMNOp7EV43nQBvb7diJ06zvyUEAivvL
	 EV/nJuLjVrIndgEIHzagDZKITQLb7OszTygz3PYiueJx8zWJRMMrf9S2DPsPcxGljK
	 FDQpbW46oxRN9EWFbWngsVHKM8g8bFmIcyBoavAo+FdT0xg9MV53pN91Goy79/BdWj
	 unZPMBTA7pti/eLQ+vDZDTUbGzbQLVLVsBw0Y5OH4vbq0kxsouTsimqhyNW9VtExpz
	 amjowlt6QNPtA==
Content-Type: multipart/mixed; boundary="===============1907785491009621542=="
MIME-Version: 1.0
Message-Id: <1b78506003b674f5e66bc7ac61f279a363f5cacc8d2fcb615d06abb0316ef00c@mail.kernel.org>
In-Reply-To: <20251220041250.372179-5-roman.gushchin@linux.dev>
References: <20251220041250.372179-5-roman.gushchin@linux.dev>
Subject: Re: [PATCH bpf-next v2 4/7] mm: introduce BPF kfuncs to access memcg statistics and events
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kernel@vger.kernel.org
Cc: inwardvessel@gmail.com,ast@kernel.org,daniel@iogearbox.net,shakeel.butt@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,mhocko@suse.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Sat, 20 Dec 2025 04:29:43 +0000 (UTC)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9A76918000A
X-Stat-Signature: ifcf33seq8szx9phqaaukh4f9z3srz9s
X-Rspam-User: 
X-HE-Tag: 1766204984-668739
X-HE-Meta: U2FsdGVkX19/8GxSZDTTUXUChTiAhmc8RMnUc5V1oXXQjmd6TEvJ1V1N226NqPzXDT9yQNW6ECtpqbWq1MORV7eIiYqiKcPrrgWKN4E9+az8ekW1DjsynRo7GZ8mjtDCoYcxsm7zxFs5W2ApXZdoJb5A+a4r0g4qXb3WOmrYoRTGhbr5jbmDRph2fefwqrY4FRticGuEY1JJGvwDOW2kmOasIiBG+ikUEejzBH9QoCDrZWuKq6Dp2MZjgOBV/f1IP+bqKp4alj5OoGI3QTEar7gVs55PVYr2tnqVkExH4fO6HIm96tjCEiDaSu5fBHNW3181axdwdad2vU6LwUbPxDbVmBMOTCjy7p9hEZrPQ5/Za+zEJ/dVPvxDRC9HsE7eRbtD9Qdkog5uy4TsfkdSQx8EFa7NIdf5Eezh5+L6nuFzfbita5kmrn7607YWk6NIJaPHyr6Wwb/oIJcTmx3dTLrTg+32AiGWi0d/Zlc7c68PktRxS0Iyo3AuBcQYbGk5DAXEO9M1/c3GPbYIc8330yyw5z2PowGyFCJLyimEq/4FhOb/Yz6F5bM+6qg/IXWmD61iFaJRlNc1fFV63GCYfaarwQV71VzFCfwvSQgCCL+HHuHmy5ghJ7o45qzjhO91T0tpElzeTmQlyUfYohHxfxnXA6T50cjoXPd8HvbI1P/i8kK7tf/JPShgrsK7vMrum7L3cZS1cjDKBMdnslzkUD7r4B19G0EsH/RxTqsgeJ8zqKr3xvPkMq6+NCKOF6iHo8lez+bcDyhUduMj549bBE68G3UArgVf/nypl71XLEy730fDOd5wwDqjMWO2q7B5u5W9YIJ4Mxl4FhvYZ2qQrtKm7k9e4f60kVp3L+JQ38Ye2LMge2xHgOkzeQEooNqeUGoYL3hhagQo+8QPiwfmmer1hZefvM2F/+Yj2b4pL7i6OvoF+QDKc03ugHDtJX5FefNIsnVaDFT/dSNR97V
 BUmUGM/n
 YJ3Ibqm9tovMcCMkRjDVFTMqK2+S8BSGjylLbxDhYM6b43idC6hwlSPxY8xzmWne+xu4k587pdZRCZAEcTmPXaSggWxz8ApS3kfZAKYjiPsBB2GP41tqlAikE4KH4cAPQM4MDI2G2uobf6zubBRQA2+DKF7Uas3U4ZRIpwMHtkXopIQSyqkSTyhBfj4R10CLpmI0JTtipCR1nAK3xJ4SIeWrSyY3fDBh6edNku/7ICOgPz8JfeibikRsTQpGaZhZBbG9+y97cyOWVoxpD5B4JLZV8OgtmrQU9DPJd8irnRJ9mmbeLUI8N4Lntxjm36SkYvY10uaFzBKAAM1uK+QvCf7+hFuj9Tn6jgb66V+AmC42l4y+a43pXEzlyzfHNmswOb26Cfi2haIzJtM/aNOkXXZ0lTNW7TmLIIMs+s40lJBOE9/k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1907785491009621542==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 2d518ad2ad3f..d84fe6f3ed43 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -78,6 +78,57 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
>  	css_put(&memcg->css);
>  }
>
> +/**
> + * bpf_mem_cgroup_vm_events - Read memory cgroup's vm event counter
> + * @memcg: memory cgroup
> + * @event: event id
> + *
> + * Allows to read memory cgroup event counters.
> + */
> +__bpf_kfunc unsigned long bpf_mem_cgroup_vm_events(struct mem_cgroup *memcg,
> +						enum vm_event_item event)
> +{
> +	return memcg_events(memcg, event);
> +}

Should this function validate the event parameter before passing it to
memcg_events()?

The call chain bpf_mem_cgroup_vm_events()->memcg_events()->memcg_events_index()
reaches an array access in memcg_events_index():

    static inline int memcg_events_index(enum vm_event_item idx)
    {
        return mem_cgroup_events_index[idx];
    }

The array mem_cgroup_events_index is declared with size NR_VM_EVENT_ITEMS.
If a BPF program passes an event value >= NR_VM_EVENT_ITEMS, this would
cause an out-of-bounds array read.

For comparison, bpf_mem_cgroup_page_state() below validates its idx
parameter before calling memcg_page_state_output(). A similar check here
would prevent the potential out-of-bounds access:

    if (event < 0 || event >= NR_VM_EVENT_ITEMS)
        return (unsigned long)-1;

> +
> +/**
> + * bpf_mem_cgroup_usage - Read memory cgroup's usage

[ ... ]

> +__bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, int idx)
> +{
> +	if (idx < 0 || idx >= MEMCG_NR_STAT)
> +		return (unsigned long)-1;
> +
> +	return memcg_page_state_output(memcg, idx);
> +}

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/20389033088

--===============1907785491009621542==--

