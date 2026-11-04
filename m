Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E0B606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 14:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y54fUfDF
Received: by kanga.kvack.org (Postfix)
	id BE63A6B00EF; Wed,  4 Nov 2026 09:51:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97076B05B5; Wed,  4 Nov 2026 09:51:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85DD6B05B6; Wed,  4 Nov 2026 09:51:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 873DB6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:51:25 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2697C406E9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:51:25 +0000 (UTC)
X-FDA: 85397724930.09.7C39DE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8A85618000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:51:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y54fUfDF;
	spf=pass (imf16.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793803883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G02WW4a+pnsj4Xew0EG1BLUmC46o+u7VzGgK76hwDrM=;
	b=x7Gfae9bHo9tMIsQdLhv+UyeRjd66Go5PJ3jTX26Zo7chOa90Bar+rHukPS1fwKlVe7Sw3
	KL6nbcWDD3XXh5zARrBOdVQgt5ezaC6bO1UOFq+7Aqpmxlc3ge7Ue1aEU8iLwzWdiq00Nn
	mcBMTkWYlTCCffmyO1DTSIeLqcobA9Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793803883;
	b=MQYaHWEVqksvmzh8l2qhAxfR+6RpNQJf/uPmMfty7drB6PWjiTjV1dI6j0CCp9+iswkR/v
	3sYBmgu1K8F+WWi/YIE+/0vNpQ6bM1jMW+I7lRY4LckKvv7gyxU7CSvTPzInSGU87fEian
	lt9K5RTp0JVZvxxepbyYuOqJs/E2h34=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y54fUfDF;
	spf=pass (imf16.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D02D6021C;
	Wed,  4 Nov 2026 14:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860061F000C1;
	Wed,  4 Nov 2026 14:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793803882;
	bh=G02WW4a+pnsj4Xew0EG1BLUmC46o+u7VzGgK76hwDrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y54fUfDFAQrOERrbEmmDGyONtEjxV7NTUFGA4jt0noaGH1QxTVGPopcQ5mZ8qDWUK
	 By1vSyiX2o7SFTzrey5CiXT3eZvr2jSfz9Gki3PrdwZOBpi+Q1BAgMNWrBv8IGzio3
	 cN441jq2bIQ9zp7H47Jr3vVCExi9HFu1mJM0HXs6IDibH3KpyAdMMV19Qx135qk2zi
	 qozlbpiYZiZO1NiAmAo/RPonKUo2fPR+3nv82kaePMtoNin11it4cIfs4efSU5fXYd
	 BQdYu/Y0fBxfp7LyFZmt1zZzxpxqKMfTaYlyJANnBugtho8oE3zOJxmDNQPlDoIKyc
	 BG5dIrKL4OQfA==
From: Sasha Levin <sashal@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: test_zswap: use the total RAM in bytes
Date: Wed,  4 Nov 2026 09:51:20 -0500
Message-ID: <20261104145120.3806026-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <0fd8f5aa-2636-4171-9300-3e04ab98d393@linux.dev>
References: <20261103163919.641249-1-sashal@kernel.org> <0fd8f5aa-2636-4171-9300-3e04ab98d393@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: koxrye8kdh1i54kxwd8apzth1dp7gzc3
X-Rspamd-Queue-Id: 8A85618000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793803883-191270
X-HE-Meta: U2FsdGVkX1+X2jDgltsye73PP7h+lJaVTRXc6tkLy3cyIUAYbdDawDa5kI1SbjNIDWxZ4ZlK6JMtF6PZiEWfs2LF9sODQMLUvq0OIiaSr0J8rtkCeRMSVJM6XZGZMl6zzEvw63uFDnZ+KgCrxx7rJh4lHR8DLuoiVV5UWBqpJHq1nlZT/aHz44SVwctSAFJ0I/ANqnwaJBxOUG6hPVr9eIBCbtdZyADjlG/M5fLtnPXC89nHOefDfdKgJeAkdy8CWCAF1J+zz8jBWbGqLbxmtUBfmdhahHBX0yINwroBayvSahTqHFz7LVy3VJDjPo4IQLrEl15gzp0T2wuAYXvHCsH95S8M8Sttg36g3z6DreYFMSGsYRJ/kYfBeWfDfMjZrdc74kCBdCokmkbWQK7ciaqkDKcC4F4tuf+0wW62DwZTqmxuCmvbr8+Ys0J5eTAXqJcj5S+hEOnxlK/SUsRxRRFvBaR1QuXZplF56Gbmo8p2UvyJgpSYFxgSQgVM0CBBZwKJ2j3eXa9qnjSY9A2ld7HtyV6VGi/m7SoeUuMVwUjNrxoqdT/KcbgDStYsGPIXrtN9nOKQSClSawIIZnrPMMRPr3QQ7YtxxgOruYsB4k+Nlrn9iBTpYqDUbSWeeB3FYNMtni4PFFvEbTVRCtjgqyMwfKm2RcNT7+v5ooz6YBijRBiG+6JgR34FZQGjox0m+8tcV5l+ZUL7SWC4KIp4KuoPI5ATb2knH+Pl2mH1tCNpGJyF/j6ea+11ec8Cbnab696y1XsXkAuSa/bMg5exkHicsTykFFhcbV5OqxJY2c+7vpLti1TSDIU00njRRoNBwTQv0Ood6wg/zfJcIByOXJVYMLsUoDlHGXTxECSLfzJqWecMUV9xTSvrpgrLo0VNqxcT+UXDrj4TJaKaVnJS+rkVmxcT4ds5owYibtg5dLMNQSBc3o2qmtwHSrOvhLN6UieKZ/fQza/FVmVAnFP
 7WcVvQR4
 EX4f6t2JL13hQSAxTrtFhawOBOsBZKuTJpXV7tPqP3cbXvzQsAgSanOTpBL/snbje8VbHQkrjE3l+rc3GK+I9dDVlnr9CmkZ3Yq6Zwak/2f+6WgOuJbsSholXRT6DRITfCVzSriVG80ayRH9Dwd9SC2O4yk3snLLj9BmVZ52TVUg37QJM0eOolw93R+zcAM31T4Dcw1d7oMyAd1y806NePmB2rBa0ceuXYnvuXaL3KJUGqbqpNEAqzVoeYI9m/yZ124N3QW8BQfv4ch0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 09:22:31PM +0800, Tao Cui wrote:
> One small thing: could you add a Fixes tag? The issue seems to date
> back to a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem
> bypass test"), which introduced the sysinfo block, and 6f615890b848
> later reshaped it into the current GB(4) comparison with the warning.

Yes, the original check against 5000000000 could never be true on
32-bit either, and it already used totalram as bytes:

Fixes: a549f9f31561 ("selftests: cgroup: add test_zswap with no kmem bypass test")

--
Thanks,
Sasha

