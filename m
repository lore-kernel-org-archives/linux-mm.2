Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA38606A338
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 08:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=fN9dhDJ/
Received: by kanga.kvack.org (Postfix)
	id 5E03B6B05B6; Fri,  6 Nov 2026 03:58:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590E56B05B7; Fri,  6 Nov 2026 03:58:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458016B05B8; Fri,  6 Nov 2026 03:58:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2559D6B05B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:58:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEE03120CD0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:58:02 +0000 (UTC)
X-FDA: 85404092004.26.7682F61
Received: from mail-m1602365244.xmail.ntesmail.com (mail-m1602365244.xmail.ntesmail.com [160.236.52.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7BDDE120005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:57:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=deepseek.com header.s=default header.b="fN9dhDJ/";
	dmarc=pass (policy=quarantine) header.from=deepseek.com;
	spf=pass (imf29.hostedemail.com: domain of escape@deepseek.com designates 160.236.52.44 as permitted sender) smtp.mailfrom=escape@deepseek.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793955481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9b1zETzpGuZPT2LRJGQZGXEXsJRKPedVyL9/8wejHA=;
	b=uyDLVK8Lt4EQDozbN/CcTif4fmxd0qwPNN7PFfiIFMysbNHFgPw6BXjyupOk+OPJZZjXPt
	ie9n5qQtZkzj4cIIxOb/vxml4quot4zoaoecwjJy+HZZUEWxYKDPHRSq0C0mRnyNXZ5sLO
	g2T5iliMkty0ow00nw9f9ecgK3z1uSg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=deepseek.com header.s=default header.b="fN9dhDJ/";
	dmarc=pass (policy=quarantine) header.from=deepseek.com;
	spf=pass (imf29.hostedemail.com: domain of escape@deepseek.com designates 160.236.52.44 as permitted sender) smtp.mailfrom=escape@deepseek.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793955481;
	b=mglSV/LRFZ7yxSSjBYCktpWED8E/9Uo14CZ7cDSKch0UEKGY7BIeu9XiBMqIWODC2iWjWV
	R1wyeiQGH7eeUtTPUQaxVMOX+HmpoW1N/NrLEbiuW19cj3TcVbXwRrShtvQL7Ul6aY+9yP
	InALOhrfMbijHAeB2lsFmFhi6X9DhUg=
Received: from [198.18.0.1] (unknown [183.128.151.132])
	by smtp.qiye.163.com (Hmail) with ESMTP id 53c046e8e;
	Fri, 6 Nov 2026 16:57:53 +0800 (GMT+08:00)
Message-ID: <b58024d2-5e71-49c3-9aeb-15fceb0671e9@deepseek.com>
Date: Fri, 6 Nov 2026 16:57:52 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: fix memcg_data reads during a THP split
To: daejun7.park@samsung.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
From: Tao Yi <escape@deepseek.com>
In-Reply-To: <20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1b01426ce09dakunmfa798b8f1334d6
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDQkpLVkkdSkMaHx9KHhhKGFYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKQ0hVSklDVUpOSlVKSElZV1kWGg8SFR0UWUFZT0tIVU
	pLSUJNS0pVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=fN9dhDJ/rsrUdQSQUvrX+sSjXePEn1KkXVgiNuICZPS+82bSnjrldyaoZI0FJRNOt6/8hd7NrIv123U6e97kg/VqpL9wZ18392PV3gqWQ1Fy6zc8xMXi7I+otQA6tfacH8Dj/k4VeHfIA85uf+5UwRc0oR1MGxqj2N1QT+HEWk4=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=Y9b1zETzpGuZPT2LRJGQZGXEXsJRKPedVyL9/8wejHA=;
	h=date:mime-version:subject:message-id:from;
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7BDDE120005
X-Stat-Signature: 7bzwshu3k95hkfgho5pj4u6xk57173hs
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793955479-81533
X-HE-Meta: U2FsdGVkX19JW8n4N2HkE2lBb82XBDW3ri3FJtKNNN6bk7WQZ9salHLieB2788448UGqiIHACGMYO/LzghEyoCvy8s4O5Okg6gcJdSVGs+zmBTMcp22TlZ0TwgP2WlunVnHvqoN5baCSXm491sW1/4eMJQQgIPFy/u/QFRrUZ4uo229kbh0FNMvfTDIcQZqJDt/poGXKTqFBdF3IEvIqt+Zdmdzrvzq0QIODkDi2j9Tre4dIXvu6isBrMf0Vejzz4k7z7ThlEssZulC8vmwVJbbED+99lTFjfa4m7XsNw5nhB7W++giiP2Xq2dQA/DHAjqabpoIloyU4VUqQBox07CGX279fbju7bprr7yMU/dU6qi4WH5UtZx/b4YdmtT8XXnCSjrP9yBX/nhHqGmEEF/+93aq8DYKnHNplTE/dk7WRhXbTxx/GYgNtazLtGL01sp1p9UQXEq2oXr8be8a7HmLoil6w6CAk/26jym3abmDaqIjgOeJAn9hISeO9WVBv3DaC+8Ztcjqeh0q3Oz1RSkfYo0e7dzfNwtrzvAjI91KuE2VzLRXIWqfzQTIBDEBL1EPKUJ+T4UXtH3sqMLUH34aN0HBFt0JCdDC4/W11c47r2Z5yPLcSpKce7k35rTFcxEEaXP+PN8bPnzuP9Y53/of6T+zzlW7n4gVlK47h2Rqlyi/Wpy2hJtO7zZLGbTDanoTyasqrW9Tn+NRy2Ps0LdewSN4cqfKLEVVO+QxQf5shV8OEk64ANeyMYnHQ/I83cchle1KlBu6n4PCSKl1AQC4vm5L9AOtV833vfnkV6MNn/6Ddt7cB9d1hVwixkzScEEAVE1y9aiX3dZ0p36mNYwYfzjgQxWbO9rk6sCec6ZrS9oGIYVKvSR+NZTHCyTCfAHeVXmeKof6H57sKp7+Itm0rpmJZeY9iJm/cA/ql2RMNIAwDP2JMsWmcjVsnqoG0hzo6W/SlA8AfwMt+zHs
 tQ5TkrTr
 rUX13gZq6v8c6jkxTFvtbeu2zOI8zjQyT1FPPllXPIDdbTpCAc+caP58VPqxqD5XT3SIUIUDm0ibiWxT2onI0c0lwTPJytxpfRIo4VxR3535VCKdntkxyxxpomZRm3gz6I/c3rkee7jznRN6GKFMKeFdtLXiEJmBhEPdSayiBZT2X3Ye/AaVNlVOv+hWJ8wdF+GqC5CVl5uuQTPyjjiAf0TwxM6Bbhmo3vprYhIHVma1GpNJvS5bdc4dm4ElbFdDJ3tF2h6wjJF5rv7L3aFqZmBoreqwwG47znJIn0qKBbwVha5oEPfPtEBoDZqYjGCURbNhHB6iOai6F3BcdwABtWQbbWLSNAxRh+du2bgMxkZZKzbQAZ1j1YSmkqCsQXPspb245
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Daejun,

Sorry, I missed your email on the RFC thread. Thanks for following up
and for taking care of the fix.

在 2026/11/4 17:59, Daejun Park via B4 Relay 写道:
> Tao Yi reported an oops in page_cgroup_ino() while reading
> /proc/kpagecgroup and traced it to the THP split in an RFC [1]. The
> RFC skips frozen folios in the reader. Patch 1 moves the memcg_data
> copy in the split instead. Patch 2 orders the same loads in
> page_owner and needs patch 1.
>
> Charged large kmalloc pages are frozen, so the RFC would report them
> as uncharged. My review of the RFC [2] got no reply. Tested on x86_64
> with KASAN, see patch 1.
>
> [1] https://lore.kernel.org/all/20260907124001.1544655-1-escape@deepseek.com/
> [2] https://lore.kernel.org/all/20261028040418epcms2p7ac0f584cdfdc6a0ea9b7f20eadeada3d@epcms2p7/
>
> ---
> Daejun Park (2):
>        mm/huge_memory: set memcg_data before a split page leaves the folio
>        mm/page_owner: also check PageTail before reading memcg_data
>
>   mm/huge_memory.c | 17 +++++++++++++----
>   mm/memcontrol.c  |  9 ++++++++-
>   mm/page_owner.c  |  7 +++++++
>   3 files changed, 28 insertions(+), 5 deletions(-)
> ---
> base-commit: a13b500946e5dc467976838572b8ddd2fd777ca7
> change-id: 20261028-kpagecgroup-split-8a749c6ee27e
>
> Best regards,

