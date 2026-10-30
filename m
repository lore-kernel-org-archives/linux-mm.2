Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B9CF606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 00:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HVK/tpV0
Received: by kanga.kvack.org (Postfix)
	id 0E4846B00EF; Thu, 29 Oct 2026 20:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097EA6B05B1; Thu, 29 Oct 2026 20:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA7C76B05B2; Thu, 29 Oct 2026 20:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5C5B6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:04:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56FA71C3CDE
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:04:59 +0000 (UTC)
X-FDA: 85377347118.11.AE47918
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A8553100006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:04:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HVK/tpV0";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793318697;
	b=hlNJmtZk2lKtOPIcvd1mMk2yrGadMFSoaae1gsN3/hkh/g1QoF2CW9qhcQSb/cb5uin3Oj
	wfWTJDmsFLGm5d2bzHVFczayGxRVKDwzqOANrKfwA35xEmH3NjyTlklMUlYym3Dpv+wcRy
	ELd0Z/LAJO0Xed3QO7ygjpNOP7731vQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HVK/tpV0";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793318697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HBJvZV2dPTZRQu5LKyPil8pJlXI/lZDJKNMF2wLkEc=;
	b=558UJpA37RgrQ1Mb+MNYE+9JRzUaS+VWsqhtU9PNtfylDghNi4NoenFVHp7ukoeZf8wiQ6
	X02p9ZnEYC0FWz1ijs9ubcSTf/f1xKI6tBiu2JLOtF19/h9SLa7GeTP3ZyrS97Oq27LXaz
	ymOy6eQy5FibjroNTlqH/9RsV43R+2U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83FD5435CF;
	Fri, 30 Oct 2026 00:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E302B1F0093A;
	Fri, 30 Oct 2026 00:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793318696;
	bh=6HBJvZV2dPTZRQu5LKyPil8pJlXI/lZDJKNMF2wLkEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVK/tpV0ZKdvtF02lea0g0LqWP+h1081rOGwZG2eGA484KV66l9vfQt+KhQDtVqOQ
	 hlmEVtrokSTyRQW3iTgbfzrNeaRRzGcll9GRoDDt1wRBcZMX1ZDhYLKVYoKH0gJKGs
	 RfkYieSRU9NV9n03/2EQf478Fb1mrQWjWjlbau3RSxjxm3E/8C9+9Q1xyC347IqFH6
	 OStkSpvmB7Er5L0uSt27Tv5RA2yqde5I1arQBkGLGriiTfWjEqDVkAUM3aJl/yFlZU
	 gDQLs5xaiAcnUvqmvc26UZd3QqAI4zeTvJZRw/8Zr9/+s4ix2YON6cK8481/ZsgDkk
	 ZChh0runNeBlg==
From: SJ Park <sj@kernel.org>
To: Dan Carpenter <error27@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Xiaolei Wang <xiaoleiwangxiaolei@gmail.com>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/tests/sysfs-kunit: fix leaked pid reference in add_targets test
Date: Thu, 29 Oct 2026 17:04:48 -0700
Message-ID: <20261030000449.154316-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <auNjrR4FyTf4WbgI@stanley.mountain>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A8553100006
X-Stat-Signature: zfm9p1gsz3h91sxkx3dirrpf97dyqiyd
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793318697-145468
X-HE-Meta: U2FsdGVkX1/D0Wdjr5BVjO0xGajKHJLIJHCphwHvZeoO/56N6dimVGWmset4aqbzMDNxKHGsIjfsfH18VbCbxCk9ExvfzY58TNEZmzcWR+8e30+qF+3fsZDap+yljtcQ6KwXjarfVGD4TteThAEKXVsyAZgAaBWzle978NhplFljyxAYAgBfAVneTxfOGgPSD/Pv1L/0Z9BRMXyP1P7K8h7b7zlTHaej8T7FPsKuHXcdewSL3hykZFrEsC3R6DBO0ro8WYZjmK+tUGeg8rAs0bhB6CBKs4bXF7jVIsol5N2qV/opHhWQgDQYyKki9MwziXMe5sjm7hD7KjFG9cwmmE003zlsBfmQ6uLE0mDPWMrDAdVOmvQ9R2Ke7fVnHW5nmeJezWgSEyzaijb3UqaaaDnf+wWWSYTVhoBpVNXuoJRUljSH2ljKTA1Cdd72Zk8Eyb/pL6VHYrZIvBI74UFqIxKH4b9GmCUh3R5ZWaTFcR6br0GkiMgORa6sHT3MBeGtLa1EtC6mX/scDan0Sh2RHfvVOHIi0x7t4qfS70JbP/fnZx7qiMhypTsXMwMI2e6g/zdnMK5Xk7+R1ddpIeZ6JHz20xVXi16Re6FXLzfsuXb0peELBi+SoXW1z0ROwS6D6fkyjdigVDHEG791o1CKjNZLmjzBVw0BKhdS45NiNk8A2yhZG5jtEYm4V8wbvuDjJx6GMmQRy653E/yud1korWgN01Gf3o/Z3KhXHEA6zw17NvJPPqyQkQFfVbRmQ0HhQ5uwHT8HJLZQhYTNtRTnJhAay8xqGOh8092zUCJUr6vsBJ5gaYK805dFDp4dNQprXn9w5ntoX/nRbRE4XP217Ac4XEUhcleLnunUdqzibeT16XzwtNg7/tuqnfnh6sAfqXEpi9w5KCWMpxDb9GKQx/2Pa5JiRy7kRw63+QK4gkhY8pxrDelwEfQ32r1+f6IB7gX4lFfBH71lysnvGwt
 2cJhGS+C
 CWx+vhHc6JeZw9LujSPbGV5tKkh6sCzHYc3FEm+7Ux4y5e9ikbwGrXa1FLACL8g6iyI1ntfnoS080yiyJ9qRKhOBgPbY0XNjzy7OhrmgRv8Dtx6h+YXKwG7r61ZDs7ACeTL9T4tSto2b75L2qNEPXAvkf8oPnWdH4w1oRZ5CY3dMNvf/X57iUASJsyVA7COfEHgBdt091loE0bPsKmi34AFATaDaDUKaqvprXbbxdDLefvrYrGAThrXdmo1HFs1bqBbE4WlfdDBcxz3Ohx1EZWcadZUtq3YMocJnwYfk+SsYcztTAY4UpYzcJAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 29 Oct 2026 18:18:05 +0300 Dan Carpenter <error27@gmail.com> wrote:

> On Thu, Oct 29, 2026 at 07:10:40AM -0700, SJ Park wrote:
> > Hello Xiaolei,
> > 
> > On Thu, 29 Oct 2026 15:56:09 +0800 Xiaolei Wang <xiaoleiwangxiaolei@gmail.com> wrote:
> > 
> > > From: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>
> > > 
> > > damon_sysfs_test_add_targets() creates its monitoring context with
> > > damon_new_ctx(), which leaves ctx->ops zero-initialized.  Since
> > > DAMON_OPS_VADDR is zero, damon_target_has_pid() returns true for the
> > > context, and damon_sysfs_add_targets() therefore calls
> > > damon_set_target_pid() for each target it adds.  That function grabs a
> > > reference to the target's struct pid via find_get_pid().
> > > 
> > > The test then tears the context down with damon_destroy_ctx(), which
> > > releases such a reference from ctx->ops.cleanup_target().  For the vaddr
> > > operations set that callback is damon_va_cleanup_target(), and it is the
> > > only place where the reference is put.  The test never selects an
> > > operations set, though, so cleanup_target is NULL and both references --
> > > one for each of the two damon_sysfs_add_targets() calls -- are leaked on
> > > every run of the test.  Running the test with CONFIG_DEBUG_KMEMLEAK
> > > enabled reports the leaked struct pid objects as unreferenced.
> > > 
> > > Fix this by selecting the vaddr operations set for the context before
> > > adding the targets, mirroring what the sysfs interface does.
> > > damon_select_ops() fails if the vaddr operations set is not registered,
> > > in which case the test cannot exercise the pid handling and skips
> > > itself.
> > 
> > Makes sense.  Thank you for finding and fixing this.
> > 
> > > 
> > > Fixes: b8ee5575f763 ("mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()")
> > 
> > The impact is leak.  I think we should add Cc: stable@.
> 
> I wouldn't bother Cc stable for unit tests.  It's not something
> which affects production or real life at all.

Thank you for your input, Dan!

I have no strong opinion.  But we got CVEs [1] for this class of unit test code
in the past.  I'd like to keep it consistent to the past for now.

[1] https://lore.kernel.org/2024102930-CVE-2024-50068-2e3c@gregkh/


Thanks,
SJ

[...]

