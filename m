Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0157F5A8A2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 00:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF566B0088; Mon, 20 Apr 2026 20:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6E36B0089; Mon, 20 Apr 2026 20:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5F46B008A; Mon, 20 Apr 2026 20:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C96D56B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 20:04:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C0A5160BAE
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 00:04:23 +0000 (UTC)
X-FDA: 84680616006.16.E200D8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C347740008
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 00:04:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XEefj2S4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776729861; a=rsa-sha256;
	cv=none;
	b=cZPKwOUtPMb1xvn91oK9mI6pmbFTkC7ryRmU1kenCmSOihL1kS3X7i0ei017gJgNbpPErf
	wCrpgRfvEyowz+jRfnucsj1j6Jjtlcm29U2hD+oiSlsC6ezPE4OPZ3wexsdYv8B7Jt+YS4
	FD8VN9Hqj8R01UraHKnuX53OWT0jvx8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XEefj2S4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776729861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WrrmfBEWZqyHhaOBDsU70QfmXtKgfla6Ziuo6I6WqN4=;
	b=cHgal07NLxiSqBwyou59uW/rb+TmUBnmvde5dLWB2ywUy07BUMxBwcIwTSqYdvFI+QhD7k
	JijH4cqEwDNupC/07hvnOQLGgbWVffLO8eKaF04XyX5rNxVE9QPTri/N7PPXgZ1PwFChpv
	swrNsq4ABP1SsO/cCkJL6m8858awtHk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88C134434E;
	Tue, 21 Apr 2026 00:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E924C19425;
	Tue, 21 Apr 2026 00:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776729860;
	bh=yWWpUlqoTvoUZbkXa4dm/1YNtAHQcPcL84yxHZN/7Rw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XEefj2S4A5GREyBXpMRQ8CsgwWruQhAfSzmH/00pgfdcyM96SY9MqmidnJ8TCPT9o
	 UWUrXMw6qyugDKWLdP/oOVRIx6gEQHHxHsR7GxsISy3PUJhSXEXsSV7ibczx7zZ773
	 iTxLp1gZY5yPanECPtEZjhgR+oclCugunBd/I/9hDvH3mNRJXj0JAEdR/j2cSLCMAH
	 mfWQM7fd3caSMQjfRHE+O2VO4x5UCyNKARQTb3ojHK1NH7G8CNPWVGpTLnTLnqQfr0
	 Yvy0jmhY/cgqsTroO2IpBPLwWTXhLtMGDQ9GtXMhsJCr8zjmwSN7FO8lXSDxEPlBQe
	 p4BFmREBwUvSQ==
Date: Tue, 21 Apr 2026 09:04:18 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs/mm: clarify that we are not looking for LLM
 generated content
Message-ID: <aea_AinEe-91iYHg@hyeyoo>
References: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
X-Rspamd-Server: rspam10
X-Stat-Signature: zyfqqzkt481y7wueu53yphnm8xx4hrb7
X-Rspam-User: 
X-Rspamd-Queue-Id: C347740008
X-HE-Tag: 1776729861-615152
X-HE-Meta: U2FsdGVkX19ckGkZCYajGXPjBCI7mDk5SGSj/QVzRLsOGiE5FJiiwh418aDH4T+NLk2u2vWG6KtLhNAB7YSCikFf0EsT9FQw5507TP/oP2RukSiCobb/C0nB0hxIe/kOAwBsRNy9gvYjUa/q+AVzUXTwDyAav8NYUoQUgLC1nDa0ZKlxpLAOgrimSSNG/CCxrzuI6/lqv7nz+O0sb3hP6qIYILJHlkiGvqwqcWJwvuwM8JxtYQQDR8qjRyDCZk8IhbSGk60196zGSt26bMuOp2QK3cBRzgPCTOAJa8wM/slsoFMlEI+I8dGiZtgnl8+zUReK0bqXQYqrhEe4YTrYnmnG/nJGx3MlN2IPiVVPc0AOoz6S2XwEToCf9+AkyHI43bdJImbX3Vi6SazdF+XJmHiUJzFw0m4/wD0tGHZwrQI1++TP2Wu9C31o7WXS1IlSIAd0SXaGn1wFpR4+pu+5tsVDNrVq62NPSZCyVXYIq+Qrodh35eif8cUPF3bn+d0I/Mt4BL4sJrl3KF6GfQfbq9B4PRtdLJXHpI+0NguIr/3aC9CAMPWfdRvpGGM3kVGLa4M/Q3t5xldCQ7udkTuAP4u9f3DH6cPo5kpsYTQNl/FWfRo/qD8eU1LidQnZ3ES05UZsdnkqXbivicsRbBRERbS7ZhdqFMhy9wOLjAr2ZHlIsUkekG9SS2jAfqK6CyMnztl5duIvc0o7AZx3FAvPMcIyWdNCKJPPh5UpxH4gI2DUibj9K8FAjg4m32FguEAWOSaeiu0y/VTCVbcOXDJl2ysPlhRTxdHwT9jG+uc8ao5/n1FEdk4Uai5KgjGnhbdJufv1NRWGJFphNwVQX2R6XPJLsO5hbFfKDaFZSUZpQmDmaNpnkBVI4rEcg7wmzTBNcMjL0xspgEHOy+gf4QCqu7rPbB6Shg03PyLZSY7I47aMA7+p2Zhj6b8jlMl98vHbaRfOJlSuZy+/TER2YZe
 c3vqW3mb
 ti38gWWYquqM+UMCQ5C2zgp+sYOq6pbuyIqxEoTZNTDlRrx4338VrSWXd8ol3Rl0wusSyqBsiOTIN2BIwfJWjUco6XHAyVzaLiA7b8ubXxsS/3JgFZ8ij4ZM1wSBOnBkMEFiEmzNNejhz32qTShsXeENlWyPigCxV+j6uzRgynP/GvB6VYQIdpZkoFmq8fP4+wlSVCi/DJ/YJnP+LB8Vtt7RyboB9M8PvbUkAhSgw568ZyJaDy0hQPEuIRRsuugKQmt9Vpzo2s6qHbp+7s9mokaRbMItkKDnZKBQTs5sck1ty0UvnbGsiNaK+RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 11:03:16PM +0200, David Hildenbrand (Arm) wrote:
> Let's make it clear that we are not looking for LLM generated content
> from contributors not familiar with the details of MM, as it shifts the
> real work onto reviewers.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Looks good to me,
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks for submitting this, David.

-- 
Cheers,
Harry / Hyeonggon

