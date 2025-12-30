Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EF8AE92722
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 04:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC63E6B0088; Mon, 29 Dec 2025 23:10:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A731C6B0089; Mon, 29 Dec 2025 23:10:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E726B008A; Mon, 29 Dec 2025 23:10:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88D996B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 23:10:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 163D2C7794
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 04:10:52 +0000 (UTC)
X-FDA: 84274811544.29.122D4B5
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4103B40005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 04:10:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jCpcN6ws;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767067850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VusSe/i/yPDqDglZQQDshQcEKXLbvkHCx5to32uFCEI=;
	b=qg69ujZGx09thLodRQJUV3Q5hPSLYzYTsVYvaJgQz1l4JsJh17/I7+PoRY5Pa7gxA8z5g3
	KTUtpdJH2ge+sm02yMrY4NNyBttTgUtt0LgQ+DU+LUxBucgrNFkjJ9buAdGwtqQlkeHpsP
	a+z8KI1tfwcM5hH3yBh4Gz0HQ605IjY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jCpcN6ws;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767067850; a=rsa-sha256;
	cv=none;
	b=b0bMlbw9TWLoO6MzOlFN3wuhWtJCBmApKG99X/y1bgIRELJK5B7JZaEH9E9WLE0mwTQH6y
	k8Xtw2AQ/sHNauvbYj7QKuWwZJM59uPTkScGbciVRYZ8RqhA1By0S1imMRgbn/Y2fpuJ5b
	samY33MXRcnjGoKFbw3URWO0pN0qX9E=
Date: Mon, 29 Dec 2025 20:10:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767067848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VusSe/i/yPDqDglZQQDshQcEKXLbvkHCx5to32uFCEI=;
	b=jCpcN6ws4VqurtwDp1F2n2heKylMiWZbTuOiUPvHZmn6UjLnVSG/qA0PtGkgWnnDIqJ8l5
	nLl/k2btzg9tBHvZGCHXIpaJdmt6fwtdquLNxOn6T8obKwsbnpsyvE3aIA1ucy+jcNg5Gm
	MdZwfkOBoLVvWLx7Skd/5ueQAnphsmg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org, 
	Jiayuan Chen <jiayuan.chen@shopee.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
Message-ID: <hgknetkzqpunmtj2ui7kednwrrc6gu4z6ooxgfzoogqijdxxqe@njfmrkrwpkg2>
References: <20251226080042.291657-1-jiayuan.chen@linux.dev>
 <20251228114622.9a8534ede47866c42322b0b3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251228114622.9a8534ede47866c42322b0b3@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4103B40005
X-Stat-Signature: xnez5gyzzuaekntry5knhgnfx8yqoa3k
X-Rspam-User: 
X-HE-Tag: 1767067849-573018
X-HE-Meta: U2FsdGVkX1/9uqQaT8p0UgEssAklyLqDf+/o7NHMOCDHwa+vQB6E0x3/tITHNWv/HWYsa5bk4SGYc6Qoj4CoHuqEWZypFFA2AkZ5p5AkcLbNGaUBDOqt2M+e0sNTsUnnxMIRWhCQL+NWlVMhVQZ6piU0BxR1g9GlGpzydIpX99rVmGZsXeVgzHO8bbyF/HKQhQcab+T9nDagFYlYuX5uMX2aaZwSvm/plq6klsMNtRgvkRFaJ0OnbGaNwkUdrH61FPGMWferFXv2pcYFQcdu+fLaJwp6Zdq2Jqc/McMzRYsTpkg4y/+abmgsZ3crZF/Qe4arpQEkj6hRfIc6pJyZjfyMZFODDS7RgykL50726816r+a9DLclvS+lpubaaYw3shS+wO7QKaLB/ShbHqsEufLTdrP8AGqbYHgCRLrH1CFRDxMZPOa6FD1MWEY1shfLjwOZbqnv+i7SgjqJtzK7htOhhoySRzypVxTbShT4r0zfjt5UqrKjpZYR/z3s/eVlLcSGMNA+fpv/ZCIgBMT0d03Mc2tEb+pS5+ZB3dAjN4WwCXExyKNA/ASnP1RjpfXXLLz9KGc86v/5CTyDGgvGyp8V3s0sFmkHuSZ+h5EiuugXDVL/NqqSm9ho/JQGcDW09CGuu1XCzW52i8i4rsYD1FbnhEadmvJmP4L+gv1Cx4Ly4GcQbHdMuPIeCGhyhUu+7H2ULoRFoliUTK73G3wyZbiFmDyel+uaCoKRaKv51s/zSdXlO5tYupJQ7nPtXQ2IRm2mjGKF5ENrWAvKxVIJnYJli/+QIls0qoyCTyNpzKrLSFmpRhjj/uZIbo99RHNMmUnmNTpvphjto40OLt4vKlikS4rOJDxK4UWglGBtaTXkBZbGrEhPGbcnNSJQhCT9q50MflCIbLWSx5DfD0g4hYGgjzHXVhtgkrJY2X8doqEdY8mNFviVX4eVb5uvBsaS/cs+wEF+pzvikVh2M0p
 5tDqjrAx
 ugzi0XVqc2txzbHaBqtbAluRu4i8Z1c+xjPgFduL3ISs64dHPPz42wplWcf3abiPUZNNjttZkWNfkH+n1tPVMZflhwmKGiDS4PCnvWYuFkvm32nDSeskBndWqvOsLv82Nx+fQVGIL+7YGkmJpmanKZWgagPEzyNgxc358AEhGFb3Mb91QNiiAaQoqGrj0JGB/v7P7ib/6CLzwhvVTohPpLPPT329PQ7jTKPfzGNdDWWEMOUxpWIlQJziFxW+48vze4v/J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 28, 2025 at 11:46:22AM -0800, Andrew Morton wrote:
> On Fri, 26 Dec 2025 16:00:42 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> 
> > This is v2 of this patch series. For v1, see [1].
> 
> This isn't significantly different from v1.  You appear to be
> mid-discussion with Shakeel on v1.

Yes, the discussion will continue.

Jiayuan, please don't send a new version until the discussion is
concluded. If there is slow response, just ping on the same email chain.
I will respond on v1 to keep the context of the discussion at the same
place.

