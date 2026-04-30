Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF5BBFF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 14:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13A3D6B0092; Thu, 30 Apr 2026 10:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112BE6B0093; Thu, 30 Apr 2026 10:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04F986B0095; Thu, 30 Apr 2026 10:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED4896B0092
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:23:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2544D1C26AF
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:20:26 +0000 (UTC)
X-FDA: 84715432452.24.A9C4850
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 966E6A000F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:20:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LRbEIf6a;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777558824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sDFbLQ0EMnr18AHEJ6eA9PT67Nuf0F7imZzZ6zokox4=;
	b=fJs7oAk9/t1YqmTiK7COz4UEZsCNUBxG7IzC679zHlLm1+W7tAJmW8IuAE3IxeeXqnOt7a
	1FZIkx8KN2NIxwkDIYB7Z78tvWrZUiA5BvAUptwRpzrx0FmXyB9oZiYNqYalioQ0QjAUyg
	4zCu1FohBbSegVCErebmakoDDni1sbM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LRbEIf6a;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777558824; a=rsa-sha256;
	cv=none;
	b=IFFHx4SucmC99/EwmDA4vIjtAOUM8WQc+RvJTwEFnKnPAq9Sv1+6FLq270TWm62kDGF35T
	JBcLjStAs6lDFRN2chNIpo6uRGDJlk/9Oz2KSSP6zyty6qLBsOXTLBl1qxevgwLLDWxUd+
	ImjRDKjQjHLn9qcSNxP//F71SJe0Isk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E890C60142;
	Thu, 30 Apr 2026 14:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BA0C2BCB3;
	Thu, 30 Apr 2026 14:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777558823;
	bh=E5B83sxytNbrJA03BcZbM7JWpgeC4uEKhNZhIPTXLRo=;
	h=From:To:Cc:Subject:Date:From;
	b=LRbEIf6awF9GrzQHSCeFiaYvy903gtqCV+HgwbkqOFZFGvxD5x08gJMRWOXLpDYRn
	 +Yz4K8zuyUyChAVgciqoQcZMzmelqRfTaY1f5ihkMCZ25HWjbbnRQ9gzUBiWUJ/pfY
	 r5ssQwLNjYyDDGtGXPLJyNetUgtKKtBmP5MXb9WFCU6ciJgHJFnlBlz4LkZDPhfiHL
	 y5hyqeXIGEVl/UKhsca8NuW5PRaJrtPg7AKtlXcxM+7/mrWImKt7+/jjaiRsR0ZW9M
	 K1w8vIoiNdjvvYqJWF/lnEgbwCQ5Gp4cEP2QdwZR1NCdGlu/LeK+ljBfP0f0DspW1N
	 jSBEZeNZE4m7w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 0/2] mm/damon/stat: add kdamond_pid parameter
Date: Thu, 30 Apr 2026 07:20:08 -0700
Message-ID: <20260430142013.80993-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 966E6A000F
X-Rspamd-Server: rspam06
X-Stat-Signature: aaeiocz7euugwixsyg18r4otxfwd94c5
X-HE-Tag: 1777558824-651803
X-HE-Meta: U2FsdGVkX18+bkdsmeYtyU9457awEoa6BIGgkoYFGIV+Cp61ai9AHpvoM8qSWQeNrmuv9H1d+twtzMsyxJUeii0u6IDKlS6vUxOliRsCcSyII/mmyceakZElBnb+tOwlvV4tyhSgMy7KIiozcuYA81I7FpVJV3AEpAkDoc/q8rvSCWvfZa1izghfe6H0vpH/C2eHloYoIxG7CcXeK0TQ5Y7qWIqGDYNnTEEIC/mCWwEGKZ82o3vTVRwVMFhjuEigtAXm7Sm+AgsfWjz/PDU2lnr5ov0VMWyJA0K886CyUZbd+eTa23jjTSUnBzP5vNfpuX6ivNSBo7hrTQHRUN7Yyz9yy8GeqlCHOC70qBrtIXt3u8oUXwyv92DwRqXLPsaw3ljz8uhKNPlAxSp8gmnTGqtZhjf1OFmK7gIJn1kReqwHT8mDCB1xbMdfAbcfJ6hW0df/CkqgH0wxDCbUKOU+1ymob/048h3JDh5LevMkURrGhv0hfitR9ECjv0kFwrFEWHsJWcwZ96h+2mkuwJ3e/QVfxIiCKrxKoQkV8Qm5WFI0PKJSHkk2ZOgMYE+92ferRvb+NLZyor19hnW3EPUBq7EPLxRrvDP7UhOT7xducBWsyNy1Qct5norb6QfvDxbeNHGGOqsjpb6n70a5uOo6H28iMkeDA4d+M1jz6GyWjVhAriJBwr8PcsXGnOwBTve3/TzIz3XWGJDB2LS4FT8lP0UENiQwx8uUSv16vLmVdZzOjhT5HnAKnBLGYbRYlt+FOv4RtzH/XtXXnW+K0c3lDe7M0KRBnut7WlAf0elHAtqQJ8fBAGPJij1TKhWajYXqQ0wlQPqYzhP6mCYNwfYUbjz0WZaBRtiACbTrr7GCBfI8gQQEzHPJ1H9+pzD+hIHNtWNNv+cZFjaT/wFoH0fuyaQwH5Du83mirPy2OAX2cX7x6pcNO1Rs4rhlCtl9Raw3rZxHQU/glGIuIBZUY3o
 JpNheWZW
 rO8GfKHqyncnKP6Fxqr+JeNHRi/VJ2j24Vv3zhUl6lKV9la6sjg4yVgwrBVxJWLh2KhYI66/CnU2sw7tYN7dqzr1ZhSXGzVSg3tO8xzIe+gTPWcLSxJx5CxqjRzQD1/y0XTZ5A2X1gzrbEi1cZYgYiZXfgk5y09C9UOHvN2TOKDVo6T1lfjsnMzBVUHOgCkS6eoI6Cb7afFZJPrc4rI1Tbq05SrWtnM2Ft4SdJYrLY/cpalPJI37/Soywmnc9lmVi2tEc0BY5WY0U02xllZaTNJQF/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT doesn't provide the pid of its kdamond, unlike DAMON_RECLAIM
and DAMON_LRU_SORT.  This makes user-space management of DAMON_STAT
unnecessarily complicated.  Provide the information via a new parameter,
namely kdamond_pid, and document it.

Changes from RFC v2
- v2: https://lore.kernel.org/20260425203309.108879-1-sj@kernel.org
- Rebase to latest mm-new.
Changes from RFC v1.2
- rfc v1.2: https://lore.kernel.org/20260416002149.87090-1-sj@kernel.org
- Detect and use fresh kdamond pid.
Changes from RFC v1.1
- rfc v1.1: https://lore.kernel.org/20260414235912.98174-1-sj@kernel.org
- Close the parentheses of error handling block.
Changes from RFC
- rfc: https://lore.kernel.org/20260414053742.90296-1-sj@kernel.org
- Fix damon_kdamond_pid() failure handling.

SeongJae Park (2):
  mm/damon/stat: add a parameter for reading kdamond pid
  Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter

 Documentation/admin-guide/mm/damon/stat.rst |  7 ++++
 mm/damon/stat.c                             | 38 +++++++++++++++++++++
 2 files changed, 45 insertions(+)


base-commit: b8e00b62c650b2aa471195f663301118fde889c2
-- 
2.47.3

