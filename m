Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967E5606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wKOzZy9n
Received: by kanga.kvack.org (Postfix)
	id 87FDB6B05CB; Sun, 15 Nov 2026 09:54:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858006B05CC; Sun, 15 Nov 2026 09:54:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795956B05CD; Sun, 15 Nov 2026 09:54:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 586346B05CB
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:54:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CADB51C3A86
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:54:05 +0000 (UTC)
X-FDA: 85437648450.18.76835C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 051F71C0002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:54:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wKOzZy9n;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794754444;
	b=L995eK/sJ+iWlKSpTBUjxT/J5dGHmFNdnonoA7GCM6bbdFKiYxYujx7GI9b8LLntRm/wnS
	mNjZEDup9ZAs6t98tUvSzyH8ZaMD3eSgQ3N5cOMcVM/j1yfKm4BjwGjEBaHOGEq714JQak
	V39Rz6dfsVsTNzVO+OQObOlKX7EVJ9s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wKOzZy9n;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794754444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+Jso9I5c9riULwHU1kEXAc9fGEjvoAMCDTyw4f1fvY=;
	b=B3UKE2FRfFIgfgXm0WLFLF08+ahJWAHPwCrZvGtj668hDWjJFXCNL0pOYKdzk/AvneRn+q
	OVBc/HRm0q7wXr+2t2xaI2AOlb/+APYx/8ziQIwraBUIsUrs5CZ+ilXU0xApzdHnBz8fvk
	VNJvToIzCg6osoZiY47zWg7XIjfBLJw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3593943BBF;
	Sun, 15 Nov 2026 14:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87481F000C4;
	Sun, 15 Nov 2026 14:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794754443;
	bh=/+Jso9I5c9riULwHU1kEXAc9fGEjvoAMCDTyw4f1fvY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wKOzZy9nD3b98doT54vEvxjgW1PGSuPRLutSRd3EfjVq73n7zWs0PH2xxKCt2qIta
	 9om4DYaNXMEkQS+pjxBSAQnqIHvvd7CCOan2ToZ1+fNUiV6dVVKthVmR906ly6Bb47
	 3mgknZOikmkFKrWNUBmwK2bYA8TIyMaRALVF+/LY=
Date: Sun, 15 Nov 2026 06:54:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Noah Feldt <noah@feldt.systems>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Qi Zheng
 <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: mglru: splice all generations when reparenting a
 memcg
Message-Id: <20261115065402.90457052d92ddf668f7e37d5@linux-foundation.org>
In-Reply-To: <20261115124954.7146-1-noah@feldt.systems>
References: <20261111000913.22943-1-shakeel.butt@linux.dev>
	<20261115124954.7146-1-noah@feldt.systems>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: msfithc9hpx4tu37txrpiqubaaptpj4s
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 051F71C0002
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794754443-879447
X-HE-Meta: U2FsdGVkX1+hh2IDqam5rKDcwXD3F5vtHKxRGrImNCxxr2xyLPw61RsumO2haVXcuLx6BXm5EsViZ0+7Kn02E26hqOzCxPbyLyVfEXaG2OzDOEEJBe8KRNTJIihZ6hjyQYsXDmuJMVt8ZouxJtBYKxaSnVpBGUz3c3qb7GIMrHPWFUKBJW0uuh4ZZVc26n/ADmpMA3maLsKC23ZZMvgZUzmMeTFvSx67m/V/r91xgBR9RT8ICrAbPYr37ZqkqD+WB6pqyp9AqIj08z/+uvmO1Ha4O8mj9rgjmI3ZvQsbd4OCTlzLwEuiEszQk9OWc4j5Dcn3BtXkFYtVD51kvg8zpy/KIyCsMk7MA9pplWUnKn6BX+RtxRb/VA0gNMm7KoBMWTvqMHgdAL2ub56bDbRswkjrgLjBhRmonSf3RAy2S3y5bja1q+GQuArpgd9FemM3ORoMBgt3JT3aX3tDErlCeaigUVSsLsW6PJHWQlhn5kEKmXeHw3AyprzMqE5hqoxRlLFajA5Smnd4t5v3PgC7gKyOmPwbGcOtAKGE7WsE80xBdt+luMrgojVHTeIMg1M0VisDvniJTt7ozEIjEK+Gqyq0RA0kjUSfVVyPFM5hteX2qINuycpJ5fZTqx3gSw5Qr3By+cajakC2HlSfhXzSz1rxGTMs6/oUr25Qkap9hi5loW+uOkVCPRZFkjyx+QkhMb1UAMGMIN3aIH1ppDxqaD9jbx/YnMRGUj3QoUlesY8MQV/S0HhyOTJ0+mk3UkFxwyrgLez1Woj6BbU0OEgFcPwqdvT+fJf3Cp3ND7MYSowNoPqsXiOY3ZUnPAOTEZ3W5OJssvCwWekobKtjf4wYY01zGyki/MERaup3x7DdV2H5uTKoOjdeGZNcVhryf2cwIoYRKX74hZTr4q/zuLPLBUhRP/+371IjZ5DKPB0NvLAHTyqXNI6Rbe8oNKvmZbghayVUmJEY33wth51HCLG
 5rfsCYmd
 gEjyptamwCNltkpi28kwcM021qKmD9l0XWIpxgakPfekw+Trf+o7KpGTmaB1T+2ynPGDHX4SpcIlLRlz5Rj/CXwQVV6vuYsEEnAReveSZsUAfCT3IWEf48UnnPABITIeGGSBxOQdoZYFdxzHLKWF/Pbqhc0+uwL+f2UTiFTiQOX8/MPhXQ4nnlQ/4KhQoxM4o0GHtpC8RpMHEcoCG8R3eK+Q++V5sMfRlqtgZlCapu8oy1aIMrNg+XSNHgQtxG1gTiWsKAyXxEYDiwLn+1lxNyLjMzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 15 Nov 2026 12:50:02 +0000 Noah Feldt <noah@feldt.systems> wrote:

> On Wed, Nov 11, 2026, Shakeel Butt wrote:
> > Noah reported list_del corruption on single-node hosts running 7.2.11,
> > which already has commit bf4ade7dbd76 ("memcg: keep folio's objcg same
> > as its node"). The bad pointer is an MGLRU list head in a freed
> > mem_cgroup_per_node:
> 
> I have already rolled this patch out on our servers. Since then the
> panics and resulting restarts from my report have stopped, and we have
> not noticed any other unusual behaviour.
> 
> Tested-by: Noah Feldt <noah@feldt.systems>

Great, thanks, added to changelog.

This patch is in the mm-hotfixes queue for upstreaming during this -rc
cycle.  It has cc:stable.


