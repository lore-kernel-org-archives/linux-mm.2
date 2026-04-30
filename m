Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43AD0FF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 04:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5F456B0088; Thu, 30 Apr 2026 00:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A367C6B008A; Thu, 30 Apr 2026 00:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9733F6B008C; Thu, 30 Apr 2026 00:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 88D726B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:47:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BDD51A03EE
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:47:15 +0000 (UTC)
X-FDA: 84713988030.07.15DC7F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5E831120002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:47:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YqT6uRgQ;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777524433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iI+9MnHnh1VR323H8HO4nChCm3Ji+d313C9e1Pt63vg=;
	b=M1J4xkeinDeKldeDmou0m5oLSaftTzn4i28W2EIXJRLlu+KG/xOH3ooHqpusscQ736V26n
	YbtJrw8Se9mJbMNOdEWIrw0bdR03zD0ZVnon87ac1wUl9pp8VAW8JZulQhnv/R6CENIPdx
	K0ALAgMoOkodsx8xtTMnS/WTkMYtQzo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YqT6uRgQ;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777524433; a=rsa-sha256;
	cv=none;
	b=X3NLkR8Tn5dCtcvV+sRp299CuhYlqAq+53/8DQmBxpVPWB74u0lyh6SwNVNuDIo4i94Qir
	nO3VfsebvK843UPpD0bHBv3qtL7TvL9RBMOkscEp9QDVuZAvMI6UQ5Eb8zzQ6gR1dCH70d
	5tofireMtTlDeYphvjCuBijud4FFEnU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 76A3F60582;
	Thu, 30 Apr 2026 04:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F372C2BCB8;
	Thu, 30 Apr 2026 04:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777524432;
	bh=E/yh7MssMqbKR24sqcd/16bJQwoqXO9idoUrqSRK92E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqT6uRgQeiMgV6LaXGJpu+ONELl49SC1EESjimSweN54pm/XOyeUMK3m8LaD1GWMo
	 LqyirD+d0LA4s8Sf59sVojGYlYUx+kuWYJtcKuhpTxJuScImz54+YifA+yrUPoCb73
	 yS8wkF9qtOED4THBT5voqlNs/EzTm7dlaBBimJmnNp8ZIvu/8d1RVlSEl+R8KMrfq2
	 9WGb+aOyqTYy9sE0DJWFIgLnFRZtaq+L1vzivbh7tvKMpjLedrUQguWpjf6TjvEJuy
	 3LlTyJxkrH7CM9wVks8DBi282OwhAGAdDxtnoN9yHOoD2gsAw4QtIoPPQ4BtzAPyDD
	 8t0UkHsCtZLxQ==
From: SeongJae Park <sj@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 01/14] mm: decouple protnone helpers from CONFIG_NUMA_BALANCING
Date: Wed, 29 Apr 2026 21:47:02 -0700
Message-ID: <20260430044703.77862-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427114607.4068647-2-kas@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5E831120002
X-Stat-Signature: s3j6qsjbauq8ddtpx3cm918pzm8qio96
X-HE-Tag: 1777524433-545966
X-HE-Meta: U2FsdGVkX1/XpTzPlOBw/28onYk/Oc2XliFLlwegEZxy0XIhbp5bde3lDoP7W3tIw0fjoX6n4wz5Z5jnc6twcxzGPfxzq1gWB+QvIL5LIUJ6zUEwbDM5ID3bqpP+jHyvszWcv9IcleMNkxGAPe6S276rYRMxteSU6ZGt4w/hs9L6iSEl3JllJPvtNe9ZuWQ+n6joYHnFTQWIija3Ej881dQW5UnpC81Q8TlP+oeaCDhn7ObONjTBmyZTaO5CjXMpyFpqF7EZ7KiqNhT1Ylt/4z9INf6C0Z8oT0Jh9TnOoaT4jO0sBW40z/8z4HVWrgvbsF+Qm7wFle6vY8Zau2SadYi6uGYHKbpwa2ZgQuQVrAjn6JyUaCXfgjiYPoxko/NQ5pt4Sk0JYdtp+9x/NdahX4D8Qcmus6WxTk9KZZn3y8VRCfacu3msXieemf2ozM9e85dU2/eM1nmDi5Bm2UFHS6Zx2fcGXGUdrpEhRlXyzc6stYL5AzvutnUQSxOkw+syndOv+Ejj0J2xYjU98GYEnsys/GFab+Ch/LsUjk92QvrLkAwSn51vVW3tUB0igzeExnV5NcxDw7DPbnVQTC5jP1NKxLRZYXfA23fQylZBT/IPVr33Y5TO0IHt3QZcIyRSfJW77Yg+jpLLw/u4ej1VCvUSOUTHx2jxTYvqDNs2tyg5X2C+IqnBYBfWdIdIIlPYLvSQadRtR1oIyLEbAMx4Nq28N59GDn0h9p/Iiu99JomFSbr1nOMwktSLNMIQLHkf/Q+U1HL35aCAov5eO7hpCsbjd482OJcjMNv2soq7iXh15BltwyUBa78g1utoumyQknEa19R9h11C2/z6NLmgP+epWAiqViXQEp1kdsfRISM/R5pmiE5GgfRwwh3ERHlIgPYSfUcwByLGdMPp/GC9707fY9355oOz8PAU3D99MAzpZQW6hXA02R/zSVJzY11NE/Jz5moHEqOYOammgNS
 C0siKhuX
 CdScATA4ZJtFRpCOdYyTxO7dsyiZXGcRDIJUo8S/MdniChTEDW5U2z+WQgKriWrMJcAZFd2FV/NCVI009WCoMhrB9mUElzPHA0AT+o0+xqzzlRTZKx/RgOAeyY/QXHbF3DcauuP6IHI/hQDP2qSIRzfRVxmTPy49Y5xDDvBc+FYsxBr6PPMaCg5Nm9PBBK/l46IZD3TnunhNd5vaBh74ompYflHGLIuC4/jlU/EyKqfT1612eKtubceVYJVYeqRUWAki9fS9HhLYZukSdnw38DLwklNzrw9EiPZMMDbfr8hsvWhYGO9LNaO2PGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 12:45:49 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:

> pte_protnone() and pmd_protnone() detect present-but-inaccessible page
> table entries. This capability is useful beyond NUMA balancing — for
> example, userfaultfd working set tracking uses protnone PTEs to track
> page access without unmapping pages.

I agree.  It can be useful for general access monitoring.  I'm also slowly but
continuously working [1] to use that for DAMON.

> 
> Introduce CONFIG_ARCH_HAS_PTE_PROTNONE to decouple the protnone PTE
> infrastructure from CONFIG_NUMA_BALANCING. The six architectures that
> support protnone PTEs (x86_64, arm64, powerpc, s390, riscv, loongarch)
> now select this option, and CONFIG_NUMA_BALANCING depends on it.
> 
> No functional change — the same set of architectures continues to have
> working protnone support, but the infrastructure is now available
> independently of NUMA balancing.

I think this is a good change for making the infrastructure available for uffd.
I believe this can also be useful for making it further available for general
access monitoring purposes.  I hope this to be landed on the mainline sooner
than later.  Thank you for doing this, Kiryl!

> 
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6

Acked-by: SeongJae Park <sj@kernel.org>

[1] https://lore.kernel.org/linux-mm/20260218054320.4570-1-sj@kernel.org/

Thanks,
SJ

[...]

