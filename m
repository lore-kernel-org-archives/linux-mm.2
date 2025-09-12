Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D584CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 16:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F3768E0007; Fri, 12 Sep 2025 12:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4378E0002; Fri, 12 Sep 2025 12:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0FE8E0007; Fri, 12 Sep 2025 12:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 39FF08E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:16:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C9CF01A08A3
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:16:40 +0000 (UTC)
X-FDA: 83881101360.21.321F49A
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf20.hostedemail.com (Postfix) with ESMTP id DEA521C000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:16:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PszUAUam;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757693799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V1s+nFYjm1BpxiJXuCQc5sgO3Fa1nM6X/7/UG+can/4=;
	b=jgwY0PBtaedhpRYqtJuyx46+rklDc5+o/8NB1alB23S/bHwY4VTT2/30kJ4Vlp5Gz6cIMV
	Z6OgxxrCne6kmBnow7Bjc6FS1drVs6T9x1fqsDIjUMfTnfszT1gTxSyFpWFF5RbJHu20Af
	SPoZ/D8PLWXy9usgRvh3oQ91CTDKagk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PszUAUam;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757693799; a=rsa-sha256;
	cv=none;
	b=ZVOqx8g+HcwiM1cx46moN8Ym5wJr1urzkNOCH6K1XuSj7/4iUvhXjDKz06fW1iOGg4oIN/
	QvVJVFFPnTnEEM9WA+zIHDd+lQfvu+Ah51Gg8aNRsGDlW1g0X0M4UchQbvlfP5WZSXSERy
	l5Km/+5LJyqCd4dGVQQ48jS/dcwzixA=
Date: Fri, 12 Sep 2025 09:16:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757693797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V1s+nFYjm1BpxiJXuCQc5sgO3Fa1nM6X/7/UG+can/4=;
	b=PszUAUam6aowRxm6ZI/acl/mBwJKKxfq4NU97UBuocvbxpfWLDpBxO5mbaEm5kzmwhyHUR
	ngSILCiSozH7WWna3NVXykdXJDAyZvwgVAhv+pFVBh1bGBctE6H8K5nBj2ObrmK++2YurX
	8VZs49fCYqPVDzEcRqzTYm9R90lfeVw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, 
	hughd@google.com, willy@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: vmscan: simplify the folio refcount check in
 pageout()
Message-ID: <g3seb57wsx2qn7tks33gudalcxfxk7ejq6cmkdbsfalb7sxoru@2esiwxtv7wia>
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
 <e475c5ddbb94763b12d396122ade8ee3c711a967.1757648598.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e475c5ddbb94763b12d396122ade8ee3c711a967.1757648598.git.baolin.wang@linux.alibaba.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xdiztw9paqne44c5bojoiur5fnm8yjdm
X-Rspam-User: 
X-Rspamd-Queue-Id: DEA521C000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1757693798-978119
X-HE-Meta: U2FsdGVkX1+fgiTYg5gZIvDKvRaPewnksjWx99UiULdei5QeEktAkARNq8kiySJwOzPT8Ag6sEEQacdOiM41YQn27qGJ3ilvFHsm2SFLOCQ1TFZerleFqlor6OrwqNVndvdxVlLWJDaVGC4x5j5FHRPZsIlg0X6Buex/nfqJMEap5d+GBrPLXq3UPoBzXvNuB7pKP1FFs9RPLMI6obImqTtJTz4TuxyBKOo91a+oZTnPgTDDhDWVueStGjoCQbioLI1l7aF5h4LmS4UPBmpl5gBZRcZdTjGWzyT1Ev22GuJ9L0L0CrJs2O015VvZtxXbuvLvjwg7jwYCM9OBTuBAieh68Nn4LCKIXZTSdyQDWVFywNfkWwDhyOuEdG3xQHuw0HX564O4n3WG1Ogrjobl2RmbUguoyVonIpP8ev4QNn76Ve8U2Wf9q5FvUescEgspPjMzeTqWPlcXkGmO8YFE+841IHvi/aL9wygwVb9Mc7NRKrtRKG5c3Ab4xfoIPqdxgXQQodVNf1jRv9SPaGPCVwfYDfSZPpdb6yh3ygQYYMghiJ35rdK1y4dyRdyLfyxjm8vyWsAizzFtIQ3Jgs7Zf5POBZNM2Z4lQTw3H2HX19GSSvht94hIdMMsFyLFD9h7PJu7I2Fe+I1sW0JdAIKW/IfZBuuVpSGbNMIAzE0lP2tHiYWPpQGDvIHVLrvuA8nXjpQw75zZxqv1OuXRhNEYqzhrvg+l5k+ICgNVTg1ywLlRprd28bfddHpyy8QMBBiQfqA6dzyYIFvzSe+snteRmuGaZHh/hY7XVVn/FmGFQLRniuG692jnuASzsxnDJSkiAUjDtDTIwEDHix3FS69BBr9xzq//eWa0Ayut557ffyD3UwmtWh8/R9+qT3DBM6dQBEfyDIJChyshFLq1261NrL1giU5NlHID7trmBwi77FWfAxUYlagT2jsMqQj40gb86BiAeSqQqhCCC5RnEtO
 xTjmllL+
 8s6tmjO3dAbCXFKwdOUUFOsvvbIPwjcmGscg1mL7oa4n3Hq5ttCkWYzyfiA+yGLOVrZ1Vx42fTJYSC/FGfHNpqxBNxl8hcNtDerklwdANEc52/GXLBni+kWSMJO75Ddm111KpsuheXxAiQVXDr29ml19ifXXR2F+pk8RcF+c7u8dHTO1/3pKOWzf/5i5oU+Bk7K3t+CR0sEQ5iUZA3jHZJBU1o5fxEVP7Qxsu9NBw8Z67yykH1PQLh1+cQXPKqqhDZAmcxq6kHkH/tHAcwNVSzDBqtBJHZ9Kk7DM5Dcai9ZIzpAnJGjjHBCreXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 11:45:08AM +0800, Baolin Wang wrote:
> Since we no longer attempt to write back filesystem folios in pageout(),
> and only tmpfs/shmem folios and anonymous swapcache folios can be written
> back, we can remove the redundant folio_test_private() when checking the
> folio's refcount, as tmpfs/shmem and swapcache folios do not use the
> PG_private flag.
> 
> While we're at it, we can open-code the folio refcount check instead of
> adding a simple helper that has only one user.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

