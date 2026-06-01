Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ECC6CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 06:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2076B0285; Mon,  1 Jun 2026 02:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 099D06B0287; Mon,  1 Jun 2026 02:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F18B66B0288; Mon,  1 Jun 2026 02:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2F026B0285
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:22:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A9CB01A0525
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:22:04 +0000 (UTC)
X-FDA: 84830348568.12.E5B66A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id F07604000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:22:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fW0n2LvL;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780294923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JC8ooVvP2VP/aGda96PWkp1u1gfkWKF0V7K4OvYMrQ0=;
	b=gPUjxNwR5eVel72OyEd9dbiyQmii8qlvh+puYl5ZTtUeKqDAvOwBW1opAKI+KZ0iHBkrRU
	YNunxQwzF6oLh27lv4N8nF2JRiFQFgYJ4umrIDU/LBs9KkVN+9uMdcjV8OQJkBipGqSyeK
	eDNNts1KzuZP/XRoTOWemOhAt2A98AQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780294923; a=rsa-sha256;
	cv=none;
	b=nAGBJEVepR4Vg/26eiIUipwKPos1YTkxXongG4voStzcERmmrFnu6wqKdJ+dH9FUUaDq14
	U+gnZ37AUmX7l6D5jFnG79ThZJscP+WOzkWjxqzFE4Cc90gFJvE0VrDFPRfG7c9t8SBKRx
	ykNuWDn6BwEEXxB8jGw9OZoBX1YOPpE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fW0n2LvL;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6066A60018;
	Mon,  1 Jun 2026 06:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6EF1F00893;
	Mon,  1 Jun 2026 06:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780294922;
	bh=JC8ooVvP2VP/aGda96PWkp1u1gfkWKF0V7K4OvYMrQ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fW0n2LvLA05tb2iQ906w0acukFZB8rLE3cTd1M/E6TWaNZTa7efwKjZR2iJ/XTWtD
	 AfsMdMqXq0uzEb+suh5q0lWPl5L7N40QUUeZM7mMmFZ+mWQdCXweHKjMUM4MaZtfCa
	 a9cfW5u2ZJd7OM7vWe3vuxhUGSm7LI+8uJL4Tss0=
Date: Sun, 31 May 2026 23:22:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavithra <pavrampu@linux.ibm.com>
Cc: shuah@kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 ritesh.list@gmail.com, david@kernel.org, ziy@nvidia.com, mhocko@kernel.org,
 osalvador@suse.de, lorenzo.stoakes@oracle.com, dev.jain@arm.com,
 Liam.Howlett@oracle.com, linmiaohe@huawei.com
Subject: Re: [PATCH] selftests/mm/run_vmtests.sh: Fix protection_keys binary
 name in run_vmtests.sh
Message-Id: <20260531232201.7613f20b850f0bff4f133f3b@linux-foundation.org>
In-Reply-To: <20260601061314.898388-1-pavrampu@linux.ibm.com>
References: <20260601061314.898388-1-pavrampu@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F07604000E
X-Stat-Signature: 7usa1pd1fh1y43pzaqdprpk4u4nmuc68
X-Rspamd-Server: rspam06
X-HE-Tag: 1780294922-780978
X-HE-Meta: U2FsdGVkX1+rN3am2WhP+aFo1ClqtKRvjo2XWe0dgDfMzMB7iuiaIUCrVaqai2Cl8fJcctCNXugk9cFUkHG2iSPAg8zRBZx9HwvlRyrZp4bdhv+/glXBwF3mK7M0316U7VQhYbdlCmbwbBTeA1a1f6uaD35KqHEnQvqd1oO1Mtxd1MEr+OLG/NPn/Aow7bMGMye76sZjRLysuc4uUwpCdlEhTFwMhdK+J2nIqzQOdUWIE8gnL+g8SwGnf3CdIqV7eNPkGYr03cNMyYHTCtXgzbpEHAhyubp/OltCmGfioKAEHF2p6Z0Y4xaiy2njguezG5WJcyPP5IXzNeX3sBIH/Xu0qtR3bSmNK4/2Pm92Op5R3Qtjf6VgUVmGJrci1fwoNR4WinRvOO3r3PinCw/HIUwzQ0sy2bN7Mej/fqhDRQ00LW8t2/sO5/TlG3VH8QDN+DAXhzyKAUWmvkm9ZGWh9gA8m57v7/flSmufkFp46LRWgM9X81syPmW9teqH19FI7280KdoOblFftpZgzNZ5YGIyBiyHQ+ToEb9u2eAmbyRTExY6aHdRzWo3Wnsbecfu5zWqcAoy+ZO1zyWy8vvIh5MIHq/TTBXGc9s8NXQzxUSXYCXWt3+EstbX+U05/LnP4uDQoe5rRkHip9X8ZKcdWzsxhRV2scHZTKTlteZh2qHQi20OsPw9YsWC15NUWBg0c6P+IUaLRa64mA8SiGZk4meKsb5Z+D2gmw6pWp3CB2kr034uYmKh2SfeKgIRi7D4sDgJjH4+0RYzDdhdk4cBF+WtqD7eSkwLkMa78D3sgnZFV4Nh15jLJZrDwuToM5hgeEKoTEutx2XfPkw8RfVHsZgEKcfIvdHeEHp/VG7l9+r7W4vrKTceFJr4xhF9FeaYO2fQZzVEUhDsL0dGnzC5Xl+YiUfjiacCxS+6CeNvxw4q9raHm5d7lu78W33VECGggnhDEbUNPNl1toh4SRc
 ZTJRxpen
 RK4q/qm+0S865dwiYZ99hP1I5I1lNPchkWH1nwUj6mKPKKwK6j8gb5fuM83F6Wm/KCCkpq90Xl5OBJVCR5aIkAFf8WoCjtQy8VZjRrqh6Vw5cCMGmL9rthZ1UmAj6NqVWPf9p+SSMfKmH/hrlixaQhyS8jw1tgGosdYy3MvaMO1Vvf+vUomvCX/MkuBrmor58pbxQFwRN0LY4iEwn6XSFYA5+52Bg4a87BUag5ABwBoyod/oqLtvtDGLIkc4dRrg0tYw9rKHVX8zafZkKsYHlAT9THlVclSJNBmxnz0nVPb5TdNLvjQbrV370Vp8qknNEbrE5oj5DPDsFxatQf3C7nOP2sRmgCkj6ywOgv1T6xouvDW8/m2zlo9jv8cLbzBQ1A7s3CNA6jpYnuBY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Jun 2026 11:43:14 +0530 Pavithra <pavrampu@linux.ibm.com> wrote:

> we have protection_keys_32 and protection_keys_64 tests mentioned in
> run_vmtests.sh but the binary name is protection_keys with current
> kernel,

Is it?

Makefile has:

VMTARGETS := protection_keys
VMTARGETS += pkey_sighandler_tests
BINARIES_32 := $(VMTARGETS:%=%_32)
BINARIES_64 := $(VMTARGETS:%=%_64)

hp2:/usr/src/mm/tools/testing/selftests/mm> ls -l prot*
-rwxrwxr-x 1 akpm akpm 117792 May 31 23:20 protection_keys_64
-rw-rw-r-- 1 akpm akpm  48448 May 31 21:54 protection_keys.c


