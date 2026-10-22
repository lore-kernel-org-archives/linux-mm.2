Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C22B606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 11:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DAE6B0915; Thu, 22 Oct 2026 07:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717776B0916; Thu, 22 Oct 2026 07:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608D96B0917; Thu, 22 Oct 2026 07:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34FA16B0915
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:40:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C7E4407AB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:40:49 +0000 (UTC)
X-FDA: 85350070218.26.6B4CA2E
Received: from mail-m2456.xmail.ntesmail.com (mail-m2456.xmail.ntesmail.com [45.195.24.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id 978B2A0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:40:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf15.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.56 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792669248;
	b=X2gihNq/FCi5MYFTzgo4ewr0I+nD0cnIUrG8el23Zs8Kh1YMa/dysns8nKoGzdXYaMi9Z3
	Cj2HWtz3ccju4ytFxkuly1DNLgUm2McUT8A41MHfuqrO+dH+uvjXAo/o8gsfL67f5Y/SF4
	1nkTMvfHSH94QY+jEEu+swCGKXT/BvY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf15.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.56 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792669247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U0Xvu1qIA/L+bG5Y4RTEQS4ShKfxcS6BTZgoVihscQU=;
	b=SMKKqZeb4FmLWR/IcZqpUVeKaO535jUMMBvUgHEJ/GgN6T+7zA4r1AwheLwCjJxREiq5Ec
	zVSL2Ky+U00F/t7f26pl0Dh2155cqSkXMCG0FZ/D6YheKo4bQLIDr11Hki69UG0GIbNwvS
	E+I5gADRjCULYrDi9vdK3RJckhbUDF8=
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 205a7933a;
	Thu, 22 Oct 2026 19:40:40 +0800 (GMT+08:00)
Message-ID: <94d07572-0b9e-493f-98e4-c751e5838e7e@easystack.cn>
Date: Thu, 22 Oct 2026 19:40:39 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] mm/page_owner: add bpf_iter and kfuncs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 eddyz87@gmail.com, memxor@gmail.com, martin.lau@linux.dev, song@kernel.org,
 yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com,
 ihor.solodrai@linux.dev, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
 ziy@nvidia.com, shuah@kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261021112437.1799213-1-zhen.ni@easystack.cn>
 <20261021115240.f195a2a55364fe300cbb6983@linux-foundation.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20261021115240.f195a2a55364fe300cbb6983@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa16369cb290229kunm3eba54192ba45d
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaH0JIVh8fSk1OGktLHh9IHVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Queue-Id: 978B2A0003
X-Stat-Signature: g4ojkxawyc76de4mhbbcdmegugrtz4s9
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792669246-602413
X-HE-Meta: U2FsdGVkX1++IKBC/ZKzGWQbc1Bg9lAWvCVt/UnOxbIbwU6RwqYfj+EJnZqneRsCznnTCbQ6vjthnCPXTnSRyfYpielUiEXYqgIwfhhJtZx4N7tHkubNDrjVCI2SKDjzbeRSviqmrpijGu1THV+TLYJI4M0aSizxrehjiYoympfJ+kqNXBRLL0aDbfodnj+6rrZqjKPGNPii2OwXnJvLuhxOPvhmiM3A9wiN4JBs+E8KlYbHDgDhiBGJLSg2K3euNawOm+q5/hvw0UTXeUOJXZi6lMBZv2WkiQnNe0gSS4vzDblqhzWF16T4DjcVdMf5mzvxtcDUorD5nZBeJi/Xc/ELCayZ1MRzTydlcS6CFiIc0pHIGtsht+xP1RC55odEWmYBVL4UtOwY5SbbpTOl6HzY4wDKK3lQlHwwGyAdzt2tlM4dLNTF7S3meH6jYFJf03C5+lzcm0pDBbhB9IyVo696cMcHyDEcTUPltnvFINRbafA0rnR0+p4cg4SLGk+G4Hxhe+t3FWn/Set6CFSZJkL2p+LRSwVGdVsht1wL5RkqPpass6HB5byEQ0TG7w9dw+CU22FCUle4WXI694oacyFQ1ovgsVKzkLXJm2vhZ8SwmEBzwzMzK87lvp1405F++MXoXe6Wu5vtoe+lFK8K0bq1EivCXNGGB4xbqj/swbFpBof0lyUuM50G/Idh275h1uCXMAvezbyEQ8Hmgf2n3Fw7zyLF7FgCgmGefLiFUiD6BxvbZcGzGzXukcrjbQeaOljLiHNwIDXtWyRak8FzwUfOZtfPxaOSIE7H571OXwKvpMPWPexOJtJ2wxFemDHCxbd5OHipc4rODTnc0CUTH+BfV+vV4E4V9W1sUNrQX7ebvyf8L+HtNBNa9uB0zJusk1Y795fuPD9urBDgb7kgDctfx9HXgkOTj+LcGO8TSSE5oYR3ck7MwvzK421cbUrf97RBix+jV840aDzKG7o
 qojwflW3
 +OscVX2JxMfJRbiAlRt5gtYahuG0W8bge91O3OV2fuJUrxZkMwE9JsuMVISuYOjrEKT5QSU5qAi6+OJfgrQ5CpDg6zvAkyKqe+gW3X2zitpF7yo7//rByUjR4dq9vDSug+3XzHA+0AKXJn4pppbA3U2Mt9hD+hp8aFjcmWMm5TSae6nZ7NnbfaLe5G3XOKbKfcFPIVkv+TDlRaXbC12SL3VyPtGXCgGegmJ1fBVnX8EvdGGBGSZQfRRc78Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/10/22 02:52, Andrew Morton 写道:
> On Wed, 21 Oct 2026 19:24:30 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> 
>> page_owner records who allocated every page and is a core memory-debug
>> facility, but it currently reaches userspace as the debugfs flat dump:
>> slicing allocations by pid, comm, NUMA node, cgroup or stack, etc.,
>> means streaming and parsing the entire file in userspace, which is
>> expensive on large hosts and hard to query live.
> 
> Confused.  Your series 8570b65220e8 ("mm/page_owner: add print_mode
> filter") addressed this significantly?
> 
> 

Thank you. I'd like to share some background on how this new approach
came about.

After series 8570b65220e8 ("mm/page_owner: add print_mode filter"), I
attempted to further extend the filter capabilities so that userspace
could more selectively capture page owner results. This effort led to
the series [PATCH v3 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
filtering.

During that discussion, we gradually reached a consensus that "a BPF
iter" might be a better solution to this problem. The main concerns
with continuing to extend the kernel-side filter approach were:

  1. As filter capabilities grow, the kernel side needs to handle
  increasingly complex parameter parsing and various combinations of
  different filter attributes, which is not conducive to maintainability.

  2. More fundamentally, kernel-side filters cannot provide truly
  flexible filtering because the filtering logic is hardcoded in the
  kernel.

At that point, I did a POC to verify the BPF iter direction:

  
https://lore.kernel.org/linux-mm/99a94068-ab37-47c0-878c-7c1ada5204b2@easystack.cn/

It seems there is broad agreement on this direction. This new series is
the implementation of that approach.


Thanks,
Zhen



