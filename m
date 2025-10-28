Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC379CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 18:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72FDA801A8; Tue, 28 Oct 2025 14:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0EB80199; Tue, 28 Oct 2025 14:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E2B801A8; Tue, 28 Oct 2025 14:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC6880199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:12:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 148B314052E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:12:49 +0000 (UTC)
X-FDA: 84048318858.26.CDC8505
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf06.hostedemail.com (Postfix) with ESMTP id 36900180003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:12:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lQS9HNn2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761675167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/mIcK7vCMiNf076l+LaWZKI497HGob3OxvsLoIs/FEg=;
	b=iQYEAyRD4NqxuGel9nb4e5p5QFmBmXPKLWdkOnmc3lIf2lSyU6NYPqGNs6S1pqhvLaUETR
	/ZL84bjhf7Xw3JQiEbC86BHMSatfbPAQ0jN6Ookkr9PFPpVAWL4t2tXnm5OFaxcwiy+Rgb
	HMiNUYKReStDJJis6IKdXYDkU5UTasA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lQS9HNn2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761675167; a=rsa-sha256;
	cv=none;
	b=yrqqfSrXidIlKulOCKypuTsAivQKyDurRERPNxD72ohE4Ap2R0Zh67oibKTIel6h2h6jaC
	HNjyyBw6wUPm1rzWaUr/F+GBu7h5+RcTaOPIa4gbeghmUEi2tjU1xyjLAPWzF5+l7WphUo
	wk0UrQZXXNOri4bpA9nh5fUqqvP65yE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761675164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/mIcK7vCMiNf076l+LaWZKI497HGob3OxvsLoIs/FEg=;
	b=lQS9HNn2xXA7sE3Ntv4jDLBzYAliouwdGZ+N3LRU21VyhFQwa6LZ/qS98WN3YIK0dl7m/U
	IPp6lysrkH4QjjvO5HK/WAeejgtUQvlJMHCCSokVJGYZHi6pBnr5uI9D9SY/4jb4sywY3j
	/EM9m2P5QogpPrIXFP7YPVLZbXSyLmo=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrii Nakryiko <andrii@kernel.org>,  JP
 Kobryn <inwardvessel@gmail.com>,  linux-mm@kvack.org,
  cgroups@vger.kernel.org,  bpf@vger.kernel.org,  Martin KaFai Lau
 <martin.lau@kernel.org>,  Song Liu <song@kernel.org>,  Kumar Kartikeya
 Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 08/23] mm: introduce BPF kfuncs to deal with memcg
 pointers
In-Reply-To: <aQEAnB7Gjs4vew8x@slm.duckdns.org> (Tejun Heo's message of "Tue,
	28 Oct 2025 07:42:52 -1000")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<20251027231727.472628-9-roman.gushchin@linux.dev>
	<aQEAnB7Gjs4vew8x@slm.duckdns.org>
Date: Tue, 28 Oct 2025 11:12:35 -0700
Message-ID: <87y0ouuc8c.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 36900180003
X-Rspamd-Server: rspam03
X-Stat-Signature: sq5ykj3qo3d4dty4p595jmtd6biebdqf
X-HE-Tag: 1761675166-121384
X-HE-Meta: U2FsdGVkX1+koRnpnlbDwuu8bLRTZDJ/KWKwl8bjKU7M1gTnGVsyFYk8ct47VCl5hkeBi0IzgxtVhViamPpowyGoDbjzTSwVyJiJrnotvohx3fj0VczVisG4q1UrcyFQ64mFM8X8S6oTCm9MI3v31mtp8h/glVkq2LGYFyLfX4Aj8DO+/vZSTLGBXbJurPxu1MfkIFip6ir67CnsgSF/z6cFSbyfJ8/ZUo2oBkNj54euQ3Qsk5n8KWNeLwUPd4ougeDH3p1APIhrKaaH9yJ0irssT9IZxRSkIyToobix42tGGLdxTREje3WOnnE10IMRClhv++U98qt2/3+azEDdh7h7zSRR57k8rjCfx193bKmYn3mmbHqdQidCSA7GcsYM3a2V9646ujusKQtmj11n2p1Qm7+oOe/nMSO6sWllyaoGUA11iGByyK35xfuB5aSOZfAPdos1fCyX4nEY2Otvndqbno9zSed5VABjJEtaDgI4nhFycTiWfr3Mmc3xkE7JW23O0YyTIbDkwp5XAM2e5hKOgX87XJYy83mLVivJppptjFDfdEcSQDiJyStoXb8ecXVr+mvafGOG/X65vPHSFZrKeSQF9m4DCNqJj4eAxrzL/rsbIWKl42XO6NGSk5V0pJ7LCvA140ol6BOBijMEFix73NIfQV7kXwCnx+JcIW1t0g9oSCt6l5cs/gHA+9QcTP5LLznCi3+btftOJKXCDtopaPXt+1PIMCylsvfgFCkyDQGr2HJHKYkmQLVJZ7yn3RnYS23ROftpTxXmGyW9XIyiEySev52k1C7SH0xP2c79NqvN2ZswfFWtNQ5JeARtkRYOZJVrC5x+wTVrqOpH2JPyOpZ0zdsK6rBulWiWwvQh0xPA5xi+LKYm3GC3pa92e8lSCiRL1RwaNuMz0DMx2su4b26gZVfU7S5pUX92jI8TOCTwKuf7Gzild0AnSB8jVT8Yk1bFmeEung4jb3U
 3dglDtpt
 fKRHSvKe9CvMqDrpRkudVPMPx2uJAnEwp7f6cLBKPvS3rIMZeIlG16Ay39Z/1DeUwUkBViriougOrvN4Bejuyb5rKS8DuchOtUaeu14twT2NaCGkTOKBr+lI8Uf0M7CthvaJtHcm0pyL9LERrSJIIRs0OBkUmdlaoHrlczEF6bA6TLbay55OSjOIDeQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tejun Heo <tj@kernel.org> writes:

> On Mon, Oct 27, 2025 at 04:17:11PM -0700, Roman Gushchin wrote:
>> +__bpf_kfunc struct mem_cgroup *
>> +bpf_get_mem_cgroup(struct cgroup_subsys_state *css)
>> +{
>> +	struct mem_cgroup *memcg = NULL;
>> +	bool rcu_unlock = false;
>> +
>> +	if (!root_mem_cgroup)
>> +		return NULL;
>> +
>> +	if (root_mem_cgroup->css.ss != css->ss) {
>> +		struct cgroup *cgroup = css->cgroup;
>> +		int ssid = root_mem_cgroup->css.ss->id;
>> +
>> +		rcu_read_lock();
>> +		rcu_unlock = true;
>> +		css = rcu_dereference_raw(cgroup->subsys[ssid]);
>
> Would it make more sense to use cgroup_e_css()?

Good call, will update in the next version.

Thank you!

