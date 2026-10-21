Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58486606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 18:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XVmYSRoE
Received: by kanga.kvack.org (Postfix)
	id 7F6F06B0769; Wed, 21 Oct 2026 14:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5BC6B076A; Wed, 21 Oct 2026 14:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2406B076B; Wed, 21 Oct 2026 14:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 514BB6B0769
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:52:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C87E34034D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:52:44 +0000 (UTC)
X-FDA: 85347529848.15.BBD236E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0DFE416000B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:52:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XVmYSRoE;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792608763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9XNWFo/CYTANDrafjipXREwd0B+NLKGQLy/y5ee2/mU=;
	b=dYOPcU/GSU/8XYNc547VW9sAM1LMfI/jmfI0UL2CsA+FVRjBR+3RolPVhEnz2YMX5IG15D
	UQnQ9tcsbXocGDiUTpYFuH8mJAW/rPuZO+0KIiGsPrV+ltLB4Q4kp+Gmua4k+U5xVjIeXg
	LA+zbikYq5vOHyqeh/OGFV2ZZ0d8Pik=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XVmYSRoE;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792608763;
	b=SNEQy9phFpSc5wwi9wpMA2PusBMkJm5+WUOgu0XRDibznM4O6Y+8dK8OaGmBb3Zj2ntf9g
	3veTHMDhm31PUlw55wZ/QlkkM1CwXZo+SS1+kdk0/C10RZUU1hl5RGukSQRJ7B/2ZzI8Wd
	VF2hvS20rXqQUNz2C5d7YdlLcyuDSDM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CCF6860008;
	Wed, 21 Oct 2026 18:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D5C1F000C1;
	Wed, 21 Oct 2026 18:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792608761;
	bh=9XNWFo/CYTANDrafjipXREwd0B+NLKGQLy/y5ee2/mU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XVmYSRoE6euKHfFwnaiDhnpBmWGbT907C2lFpgaBfbpl4U+4ISxr9AqyT6pARcZaX
	 wJeE56M0QsINp8WXWmFS8zXuVk/sMuPJxGXhNzXXM+zGK/e+2KGPy0jMuID4x8Ke3P
	 C6pCbQm3HD1d/C4kmi/btMdNA8+N/HVKL7FgMmeU=
Date: Wed, 21 Oct 2026 11:52:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 eddyz87@gmail.com, memxor@gmail.com, martin.lau@linux.dev, song@kernel.org,
 yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com,
 ihor.solodrai@linux.dev, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
 ziy@nvidia.com, shuah@kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, Zhen Ni
 <zhen.ni@easystack.cn>
Subject: Re: [PATCH v3 0/7] mm/page_owner: add bpf_iter and kfuncs
Message-Id: <20261021115240.f195a2a55364fe300cbb6983@linux-foundation.org>
In-Reply-To: <20261021112437.1799213-1-zhen.ni@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0DFE416000B
X-Rspam-User: 
X-Stat-Signature: 3mq1yc19b1a4iyqajpt99d8jpf4nbuay
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792608762-689740
X-HE-Meta: U2FsdGVkX18nrL+jO+YTFIAFBBaJgeQ0BL6g9m18CFw1AYVTedX7/avfDNFH54fNgLZEoBK8D2ynew46mCCubwhFpOtbbsFqbzdsjluMyaemQK48JiX7k49QhK5SgvTuCmMYXNx6x4JFhaJuIE4IxfJLUmnRY1WFkMrUb45gO72Z7FJUU2vpkV6cLYV2b3LMr8tCmGIslie3eVXFbToTT1RSOmHotN4qQ64yz/wvrbSahKKp+wMoqvbA96mWm15YvTR86ETJ1bN4LcYsGTZqUnzTBHSy2ugG3bc2BbyEfqrFekfFHgjW/odblo12LaIdBIwmSDVIQg6Nj35Q8rPc2uXiEaXL+yt6oJxjftBjl+2rbc4VealcbyL0Wof9skWOa5a7rK/0mWsY4KG38qpfqk7++p+gnuegytnOrpgQd4X2qoQRXzqm15xk9Z7cbTJ17GLmYWaFchrzcnASc6RVkjHTfikY9NHzxJA0lA9Y5xu0l0SpDROkVh4MylqB26MJMT9W2Wvw2b68m7hNZQgg1MiS3SVK3TjfPCyaiOhM1gt28NBqoyyAFSMfgMOe1F66G1QtCzaLi/4KIgu9sTk/l/AZq4MSLE8HigtBdG7e72U9Jow49IE8fLJDxUGAWOIVv4DXm6K0RO5jaViFfe82Pi3MD8DhszX0IOHkkqAxQ4sP24yUphg0HwqKiLJYzGz8JYsBUgwmarqjuvw1iSjn+gtTVyw+qf/FRBja0mh1USm4EXtk/efoAb5rOBELmyurfOBhZ6ywXVrsRd3alhGl75H/clO3lqQy0PzfocFMQc3IKN5U8xeb1R6hqDISov9SgVKC7KmgOWCYh/fRMrKFih1/sfsLq3trsdXsyw36RIHgk4ri9Dh7adzaL+u1wRS2y66woBewQqR84jXj3b8ZVKsfBFZczd1MobbLVWcGYz72IPbMoH/7hNG0hA9lWP3Qkh89/IocRmJk7bFpgZ9
 afyW26xf
 bz9gQNxr4ZrUQdFXU0kVokRMYJlvfywDlVAhEPtmE2A4f1wWObr1eLE0OkaMwZacw+79XAroueexs2GeOzAzNeZJQReDAFBqd+VYdMmAl1f4SIxPz17X2axLABC+oGT/B94PqcYSdIf6Pa3AaIZYHaSpE9BJ/Z++QtOYmYbND4Uii+Tqy7RUmXB0lVFRwDnjmFtn0lGpqInhEngvwrN3LVpxthao+1ZYfK3CyiveH8KH9LreydPnj6s9R9f3ZQiht+QDi8hJDuUXfSlCJLapqTSlgetpCUjoee9h+Cbn6ltsE2Ls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 21 Oct 2026 19:24:30 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> page_owner records who allocated every page and is a core memory-debug
> facility, but it currently reaches userspace as the debugfs flat dump:
> slicing allocations by pid, comm, NUMA node, cgroup or stack, etc.,
> means streaming and parsing the entire file in userspace, which is
> expensive on large hosts and hard to query live.

Confused.  Your series 8570b65220e8 ("mm/page_owner: add print_mode
filter") addressed this significantly?


