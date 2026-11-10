Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2ECE606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=T5/HMq9H
Received: by kanga.kvack.org (Postfix)
	id DB49E6B00EF; Tue, 10 Nov 2026 00:24:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63746B05B0; Tue, 10 Nov 2026 00:24:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0786B05B1; Tue, 10 Nov 2026 00:24:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A70296B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:24:14 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3FDE214051E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:24:14 +0000 (UTC)
X-FDA: 85418068428.05.189F812
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 80287C0002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:24:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="T5/HMq9H";
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794288252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tql7eR5er24MenGv5PCYQqqSyChkhlwFStj9pdPekzo=;
	b=KDU8fJbj6fhN/pNasZMBeIhkaqLJJ7iB+6Pz1tkg2QL2xVIFL+NVoeEMNdD9nxEGhWRHYs
	CCNRheV3hxKPr70aWiEQ3xEDA3MnOkCLZBZymh3PMk2mJNQzNhOk8vwuNjZk0/udaHTW/1
	SY6Aq8Gr8WhGVVE/ISiQoaHywz3O700=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794288252;
	b=HMWLRT3UrFVxqTIzpsfRR5lK+Vqar6oAE6KfoYe9+nv6NP2LS896oJ8GenTcogPdwsjJ+O
	jvvc1DP7QsPQ15ZDePCqyOMW0H7GLAM35GhpnHYOKj8wXgwHybGZk2AWcZaDoPaCEUn9DW
	U5wVKK8TIdwN/jyzl+PDpxJN7hTfkrE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="T5/HMq9H";
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 926B860AAB;
	Tue, 10 Nov 2026 05:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D101F0089F;
	Tue, 10 Nov 2026 05:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794288251;
	bh=tql7eR5er24MenGv5PCYQqqSyChkhlwFStj9pdPekzo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=T5/HMq9Ho6wBHSn2SyLD+V0y7apDVcIEcxsAbM9bnQuCbLvHw6LbrS3L8oQWoJdLS
	 xDaM8FBlCgcuAoUBNXFa7Xb8i2/V+MMB+YSg/oc1v0bC6dFoqwUkeA+EGUyi4PZaBm
	 fJDST0/5AG8QCpg5dZFPoHB52xvaiVPnB2IDMaeQ=
Date: Mon, 9 Nov 2026 21:24:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mingyu He <mingyu.he@shopee.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, Muchun Song
 <muchun.song@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 littleswimmingwhale@gmail.com
Subject: Re: [PATCH] memcg: keep propagating stats updates to ancestors
Message-Id: <20261109212410.ca24bffef1abcd50b3f58c13@linux-foundation.org>
In-Reply-To: <CAAoBcuRfhFf4p5qfWZnNs5=4foeE6jtGFggG5XHmMi6cXwje9w@mail.gmail.com>
References: <20260911032905.63683-1-mingyu.he@shopee.com>
	<aqRXqcynCx88D2QK@linux.dev>
	<CAAoBcuS=sqOAPFr9Gda9aTwuCMHMPzBMEee8qvPNHtNxrRWKuw@mail.gmail.com>
	<asy_L2s1TNcN7bOK@linux.dev>
	<CAAoBcuS5VJwsYyw9=77SaBUf3N1hL8NfRtGwpBhmyUUhT4+T8w@mail.gmail.com>
	<CAAoBcuRfhFf4p5qfWZnNs5=4foeE6jtGFggG5XHmMi6cXwje9w@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k4rq3umsnjef1j1jkh851mktdccqax6k
X-Rspamd-Queue-Id: 80287C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794288252-716799
X-HE-Meta: U2FsdGVkX1/xPWYoG6kbhLBdi9i2JB1XjqC4DSLpwyoYVrwRBrAScBlyuJny19AVUX7XOpf5S9HmQwJUtCBOxDjMS1B+l5eTl9wlcXySw8kmUVQEV9w2J9fMLehVk4aFMnmE01H1zbm/5jX+fXqK16P06naulqsQKDxaXub1GUAQuIH7qtLLqRxJpNfiZeTNXEWuuOTqA1JkKbwq8UugycOIbxvAdp0j6Im1+6yFs/2GI3P5h5t1njzLEzyqQGmNYCMEiPt/4YYKTy8L56OJznn7KLzqSyTYL8LPZw2f5yLGuF3sC06w+IxI2dfbVk7YdQb/WrkoX/32CsB105RTR2p4xg3bYcOndky9TT/Rq64IIsgX3kXnS8sJZFsc4e6fIiR/oa5Xo0angQgam9oD6+X+zrb7AbqccVlRpepXCONb2x1bZFCCoQrWg8fn/+UAKq82mggFcByF9q7F9Fvgw8KSlcyzm1bpiYq1uKRYepYZvcy4dx4RBBq6QccTAgU7OhhyACNKIOgFbBC5O9UveAVYkFYWOo0OtwRN1eeMePZreERAdJzRTGZ5ISqBpHwRnJHKe2Vzjxk9NlmYDCaOGAB+DzyvENrAMfTPNSbLHLlKH+RGrkcpXArCLA4STIriIiL3x5YYFKyi3GdjuFXEch2HEjRT0BaPrabcxWitDJFc4akYkZF6kcI68W3uxsNnpccBaSr9l8Hia9x+HUdnygwkA51AJiQ66L4Q4r31mLKLLb88qh4reDJyr79oehc6lqrBSaXxBDNcgohVf8OaNX/U8JAHCOMQI4JvpLYj7KWjW7+sSycIwuRdh5mf+aSpOOSCb9bk5aj+oQnwnfAB4wHNpc7AVV3sszRHpKsdqJmVWGrRWtwvgx2q9KFVL0Z0wILvqyOMynpqcWca/l4wU4FxHtveTsMAMMuRmIKe3xEguEDU9VCxv/ZSXPvnh1PyfC7PDkZYe/JgeAL/A3U
 GZTeXO4M
 E5hDHI67D5YWFt6r7DMYXYo/n79/RsA74qC/NrW+0c0OdqOVF3tVStgE5O0lW0RIOLGWAcW+SNBK219wKfTGVsZPkwA19+zsN167vpQRTEmDOharnIqUxHGaoZe1gRS6+7hCguZNh1aID1SCrb8HbGdAwrgt9+KdNjhzW5EawcDAepqzO9fPfmWA03uUSNg7tJZRYLMG8ZoHy1n34A19YI+NCVEjLO6gD+2pkJWEQT8mtPPVvOFIuVez0qRRmeli09P6ntNwULVmNvOxlLCxTSOv/sxr9YQ8s02EQCbr208G0zdy7fNss8wde+DoriSkh1d7FZ1XR/y4GpOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 11:17:37 +0800 Mingyu He <mingyu.he@shopee.com> wrote:

> hi, gently pin this email.

I think Shakeel is suggesting that the bpf caller be altered to also run
css_rstat_flush() regardless of the update threshold.

Your custom in-kernel caller would need a similar alteration.

