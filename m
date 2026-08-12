Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9906EC5CFC1
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 02:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99B3D6B0088; Tue, 11 Aug 2026 22:45:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96EEC6B008A; Tue, 11 Aug 2026 22:45:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886486B0092; Tue, 11 Aug 2026 22:45:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62FE46B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 22:45:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8A931402BF
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:45:58 +0000 (UTC)
X-FDA: 85091077596.05.04C145C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5078A20002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:45:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AObcdImc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786502757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wN4tIqwkqpx5GNi0C8cNZGttKmLphAMJrFg1BPO7Ao=;
	b=yStJ655LJsM8wcFxWer+TIqPfJudriJMJEfvbKvZFv2DG9/oKen0X2Ubv1kKA0fvx73xr1
	Y9r4vs7hpg121cF+3/rWvLJnPxFC9K07jOBmKRQteQO7U/W84jPVpeYHhscvGoMTuz3/jl
	BOVx1NlFYGHQeu+kYuyT0qeg6Ojd7tY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AObcdImc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786502757;
	b=dW4OfAIq1s0TNKLQVW9EHLVRl0+roEsk6rl8k017Dffk9ZX96EuzCdkEJv4kPKuEkvHiBX
	ispJNE8Lj6PchphWf0G3w5X5V4rVUsi88d2lPVi71uolxJukMaj/JFR/heFngJnVWGluQJ
	KxofNFNe/s9ddk/10uc0S//bJvcHiUA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3DD4600AE;
	Wed, 12 Aug 2026 02:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E07C1F000E9;
	Wed, 12 Aug 2026 02:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786502756;
	bh=+wN4tIqwkqpx5GNi0C8cNZGttKmLphAMJrFg1BPO7Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AObcdImc7khHLVpGq0Y9RAd14XKdCLpuqYepsxUdNSTw55wqUqKzNH2XBo7ZBtpwU
	 kVQuydSEH6wYUTkAA1yKrz4j4ROh34uG+vq67B6wI0UgI4JovGscNczZUhzSbANhcx
	 Kl6d8pFE9KIlJhdVbYVAsZUlKHxfr1Q4ugawg5zE26HAAQOXaHXxfHn5dDU6nKjPpe
	 yEAEoOzk70KaxTXR3LSCXy7/sWMxuTEMAS+0bsIyGvkb6X84JPkoqmSsqTjuTpQ/4y
	 BHv7Ydh/gKobIMa1i2qWB0oxmhoq/Sw+IG4RQD5+1Qei0pQWs9ClOMReLcrNThdfSH
	 dPNe5Z13Oonyg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tejun Heo <tj@kernel.org>,
	=?ISO-8859-1?Q? Michal_Koutn=FD ?= <mkoutny@suse.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: test_zswap: skip test_no_kmem_bypass if debugfs is unavailable
Date: Tue, 11 Aug 2026 19:45:53 -0700
Message-ID: <20260812024553.8493-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260811190611.c72f19ada3912791a81a7a90@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5078A20002
X-Rspamd-Server: rspam07
X-Stat-Signature: 9k71ik3e7gymnhnhkc7wwysdspe39hrz
X-HE-Tag: 1786502757-180352
X-HE-Meta: U2FsdGVkX1/5elxFRELRWRq24SGjl+kXqrXzKgsJ2+5nx4yT2XUlUqPWR1xskNhFaCRdnFmmTQfs5JraaZEwvrcVslUYDhdQ82oWolbEisZgphC4ZnHxqPx8PGiyksy4gQnrZxUafH14MkveFoF7VVFIa6EkJsqsG6HtZw/ypOf3vmzrmc5ZoroQmRXSTEhJ6OQ2ZpiS4H2OoBiqROn2blTJsB7645XKkzFEUc3ra37IPSYBi1v/P1SpH7InRloqac15/QvoN2IsubRRATbUZmwS9UpYe0HF3gpx23AsWpCY8LKbseFEOic0s5PyK5dYlh0MfCnHQ7wjLPCw4yWUwGj4JCN+Nq+7V64saMlACNGK5CFh8HxpjqbLhYElmi7fjjKK6C0po8b/DwrlU0kdlbNTg1Wj6M6ciVBpyY/EnifsrUPCxUuI4XYQw3J80ObyjTU4j01Fu+CtGPnJTR1h39Ti6fFSfmkmlLiRPzYJQoDNSjdt2fODg2E2Kciw7fxpvmAF2uqiX62Moj98nJ+FHaUhPA0ep1Np0fsJS5+oZ1/Dqk7Go334UDMY8HNwjPYuK4cnGLS6/FJs2TD/OUMH0Y8m/zv7JTbGlWw0vISXBrgZ6aSbOdJboioBMFngTFanenpWE/E006uU+72yO/8zldD+JVSTYgQKqUCBPmU7JAJqJ266nwF2Q6WRyedrwyShS+TpzF13dTXwFIGVO+KWXX+cE64foaaGWqw7r4A14VLtv5ut9xDjhG7ZjwwzRMhxBcnGqU1RTwutUis7m2jYZ2xYNNGPRpXa72JF73EZNqg3VQwV0Jq1sf7fJQBHPL0UbOUl+gEG3iXet7dMn6AdrnWmYXN2PT2/yZRSgz94pz4YBC7FdWT15lqm240Ww26elBSYlOmtgqXBKPDFcrbYDC1koCmxU+Oe6zuFvv0ysTLZUH5Mno05C2/E4xYZokjKRthWxEXoaB+A3pPOas5
 z2VHuU51
 f92+ow57ZZA1q9ralig8vbstdsJ48/IwwKMHZo1bJk6ipKRKLkE9MxAbVSogbsn+Fhh+0q22Y7vCtogJzfSy9ETCp+RqjOhh5VfPF+xY4bxXZqshFjDkq8t2OEo/jXCNWn/43O3l1OPsJibUJFoRMj/jnrPFY3xWEwxzsEfbTE7Z4vuo3klV+KpsLsfSeE5Msww2Jneu84PSGS1SxYw5diPDOj8+uITnlNgJ59YTJTURmCVZWebBEUh+CxbdVmhNA6BNjMdO0/yaZqP4kOUskbUtPIDi4g7YHhva4jsqrCDDVptT4ojHPtFSy5AcStIFKXFZ/pNhBfH76nuU9E5wi0jAD7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 19:06:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 11 Aug 2026 05:14:11 +0000 Wilson Felipe Pereira <wfelipe@google.com> wrote:
> 
> > test_no_kmem_bypass() needs to read
> > /sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
> > verify that compressed pages are charged to the memcg.
> > 
> > When running in an environment where debugfs is not mounted or
> > CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
> > loop to terminate early and report a false negative (KSFT_FAIL).
> > 
> > Selftests should not fail if debugfs is unavailable, and it should print
> > a message when it is skipped.
> > 
> > While I'm here, also add a warning message if the test is being skipped
> > due to totalram size and make the check for totalram more readable.
> > 
> > ...
> >
> > --- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> > +++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> >
> > ...
> >
> > @@ -570,8 +571,16 @@ static int test_no_kmem_bypass(const char *root)
> >  	/* Read sys info and compute test values accordingly */
> >  	if (sysinfo(&sys_info) != 0)
> >  		return KSFT_FAIL;
> > -	if (sys_info.totalram > 5000000000)
> > +	if (sys_info.totalram > GB(4)) {
> > +		ksft_print_msg(
> > +			"requires less than 4GB total ram, sys_info.totalram: %.1fGB\n",
> > +			(double)sys_info.totalram / GB(1));
> >  		return KSFT_SKIP;
> > +	}
> > +	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
> > +		ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
> 
> Super nittynit: "mount debugfs at /sys/kernel/debug" sounds like a
> progress message.  "I just mounted debugfs at ...".  I think the below is
> more clear?

+1.  I was feeling similar.

> 
> --- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix
> +++ a/tools/testing/selftests/cgroup/test_zswap.c
> @@ -578,7 +578,7 @@ static int test_no_kmem_bypass(const cha
>  		return KSFT_SKIP;
>  	}
>  	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
> -		ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
> +		ksft_print_msg("debugfs not mounted at /sys/kernel/debug\n");

This reads better for me.  I also find this is more consistent to similar skip
messages in main() and check_zswap_enabled().

>  		return KSFT_SKIP;
>  	}
>  	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
> _


Thanks,
SJ

