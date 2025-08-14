Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5B5CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 22:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8FE9001E6; Thu, 14 Aug 2025 18:00:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932BA9001D5; Thu, 14 Aug 2025 18:00:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86F989001E6; Thu, 14 Aug 2025 18:00:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 765AC9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 18:00:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 026CA8376D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:00:15 +0000 (UTC)
X-FDA: 83776732032.15.F6A1FF8
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 42088140002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:00:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l3PPGdMJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755208814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=anDT9Myam9siQZ6MO+5nA7/YHXUugpAjr2OR1VCdLsM=;
	b=Jm4bjCSUbG5Ro7ICM5pe0SK4xXfGKZKoYhkwCM1s43iKjnFZJbLKcNVI+A6SRzcfP8jhjz
	vxFHuOQBExNN7CbxPOGSoN6FO0nyGkNbMSDw0CFX6Uz5drREgX0rHF0NfP0NX6xj+weS1H
	aN7rnzNLWCIxJo0dDUF1u0LxM2SlPKQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l3PPGdMJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755208814; a=rsa-sha256;
	cv=none;
	b=V382eXofqK8+SRg/c1Q6zgTUwW1IOxQRtTNcNjDlFhDMen7ewaSHJpbHMxBIavql6P5EcT
	FJSKy+TFanBhFmC5pNzOnVhtN2e3fLjQgbYSNLSt+fc1l0RHqkycFdHcXOJHuy9JAh045W
	rnYccPbFL2KEe88JBf4enb8s3HRvB3Y=
Date: Thu, 14 Aug 2025 15:00:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755208812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=anDT9Myam9siQZ6MO+5nA7/YHXUugpAjr2OR1VCdLsM=;
	b=l3PPGdMJQHFbfQIGSmCznlTBp4b+dcz315PCI9QqME7LBd37kTyp9hqriupi1OpVIHKlXE
	YQSi3GakzDxwvQTeIVAUQ8ejCYX9XZi6jtRXtLogJIxmmo6WdHzJFOgsLs2NBkJj97Y5J9
	r81c2RVgOWQYDz99sDWKSuoo0b11kB0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Mina Almasry <almasrymina@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 net-next 09/10] net-memcg: Pass struct sock to
 mem_cgroup_sk_under_memory_pressure().
Message-ID: <pl47mmcmxu53ptfa5ubd7dhzsmpxhsz2qxpscquih4773iykjf@3uhfasbornxc>
References: <20250814200912.1040628-1-kuniyu@google.com>
 <20250814200912.1040628-10-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814200912.1040628-10-kuniyu@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 42088140002
X-Stat-Signature: 6f4truhemtwosid5twduysnezmajctnp
X-Rspam-User: 
X-HE-Tag: 1755208814-493826
X-HE-Meta: U2FsdGVkX1/Fxl1TFbv+ztIQcOsylZdV16dwIgXow9f0w2xIx8sTuauWUQAjNT0gOkstP1rftYP2QKtdwuiSvt61f9X/hcjiUPrg66uvBSX5e7i6BSxychXiziX839vdvE04kq0ZUZF4mEeyX7ZyptB2BvA6NFpEHtSlmczn6fakmfOX9R/quUfYXx3vbuC5ZQopzr7qa9e0CI8EAkGlPmdtldJJDRxGlEU4BqEouqY8+BqMGk9ScwiaLRGYfaXw9U5zgX+aCreRXBGpUxYRF+Pf/jijQaPgm6AMypMQH/adTkiGkqRuSV0e+OLeTAyO9JQl5bTrJT7ph5AafvhaoxyzE01wWQVvsokfdawu7QfAIq614oKwdwLMwgmY/6g+cS9Fko0QK988Nuz4Y0dZx2Gtxi24TMBP9sqslJ0pY8iIL7cHk5NbCWgRWvFOnhp1YAtInZeFYwf7DpDc9UUo/29W0yZX/exiVQvK5TZOZ5lsERQV9mgMZBLY+2om12gi1H5RdMROlrEFqxDrug1NqG6QhODQOGZ9ZSFEDLmTV+y8rwMMMbzYY7ki9U0r4WbowXyINwkIX+p7NFXvXREvmq7BtJ5N9boMiRxT3spKh7fkhS3ObwhmTXfttakfTXPt+PG00ZceCJLM6CrBWLrvjTzjGpGGHZs2CeOeA0NkWlTYdNoDn/Fw1wu2TNvf+xA9ivtTZp2vpOOcxrdIxypBJ2TU9wiXeSNWqDQBA3KwwEfETEyIdI1K2aVD8glQQTZy0f2McpRLEFO40ednqR6k8hDNlsGyuEdzJllK2MOwr4yZoTndhO2h+6cCnr8VHJam4kpFpZTBI7Xn4Lsu0uTxi/W2ixFBDb/dPIoJu+mc/Oe8R9T9/t0UDuGK+M1NT92UPEUhbTADSzcGMVGKHqV+8qPGRNQfCYJN00rLkK+5J7b/GyywqYrVfPn9OBEqoQ0PmeFmFKppuEPssSWA7z9
 EGAybigz
 LZyrMukEtRCYaGOjBlbR43mbiH3v5c3EZXj/+A+okZYCnjYnAs+z9M18k7lSG0cq7Ryy7yCJVtgmXK/NYkOApt4ORdMXb5e7P1ZRutwE1ZiXu4n3Z3aQdeXp5qEt2SKx5AahtRz/rVMFwTrqZIV4YTAkm10Ludtn0lTUjQtJ4cJ6/14bo8SggHZJF84btCnHpupZOnXIQeGGPAKM8bWydD7MXfzdsqEImhAuYPyUuTtR/qXNWrfQxfEXcGaYaklCLd4xQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 08:08:41PM +0000, Kuniyuki Iwashima wrote:
> We will store a flag in the lowest bit of sk->sk_memcg.
> 
> Then, we cannot pass the raw pointer to mem_cgroup_under_socket_pressure().
> 
> Let's pass struct sock to it and rename the function to match other
> functions starting with mem_cgroup_sk_.
> 
> Note that the helper is moved to sock.h to use mem_cgroup_from_sk().

Please keep it in the memcontrol.h.


