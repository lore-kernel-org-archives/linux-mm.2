Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C69C61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 00:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75C776B0096; Mon, 31 Aug 2026 20:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733CA6B0098; Mon, 31 Aug 2026 20:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 672D76B0099; Mon, 31 Aug 2026 20:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4ABDE6B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:49:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6C00A0245
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:49:56 +0000 (UTC)
X-FDA: 85163361192.10.D19F8F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3A225A0006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:49:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZJZR+0kn;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788223795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woKBEbIMFtOyK1GVl+xRrcz9+WTfKDI3xViqIZ1ByqE=;
	b=gzZWHQJo45Hyx/w1u34gJdDWKEnUKvinktV3DRz7gM6jkhyyXASn0pj+7IxsNpyIpyPQvv
	W7YQENK7MDMaY2XUjrNKr4oJ5TNCzNn0DTx/iWeUNzUFu8d3OMrqUup9X/Qr/6hU/dEn5q
	XNdDHxb60f/6KdJlB6ySO7jWi+WuLa0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788223795;
	b=HrYL3Ue02cc0z/p+Jtd3teMwHnLfW/H2YpuwAt0xWV3qM1/TgTv2X2nvzv6zXCUpoEyEd0
	aLlI0Dxw6b0zc4p1SYFJbuiYMjupYVPXVJzlkWA9kd469Y6MgZdE1HU7o1nBW6SV3n91EF
	X2CE2Gr/PV872az953UQnI+iXZm6Xkk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZJZR+0kn;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 56B8840800;
	Tue,  1 Sep 2026 00:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17991F000E9;
	Tue,  1 Sep 2026 00:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788223794;
	bh=woKBEbIMFtOyK1GVl+xRrcz9+WTfKDI3xViqIZ1ByqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZJZR+0knq0AL7vYLE5VQ4SxQHjEFRaMNjUH4EKagbUOTNB65IsCsrQgnLZC8ayDnc
	 D7PY9JYGCm9e+owTZkC2iFTLQ7otxkK2A6b1E6z90sR0bjsyfg6K1qmKguZXoETfSO
	 2h0Rrv0OJ424KhNTi41+CHj5WGvnjnBlzq1937+ynpU0dHwVhUFyNfCRfd+EBCwEvn
	 1QtsBE7IUIbljcqnnX6oFn0sn3zyZdZjSdza/TMqDjAxJNRMEaWHWhetpTWf4DBJ0X
	 6VBS1x0ahC1/UHvGkCYNOg91Nu4vfQouUbnZlw1klFTIbQcfav1VXpcpgVZVq+qZdV
	 sYMX98emL2oNA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 0/3] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Mon, 31 Aug 2026 17:49:41 -0700
Message-ID: <20260901004942.89964-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831144732.80910-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5q9hrmicezagkagn4xsfrcbbnpobmre3
X-Rspamd-Queue-Id: 3A225A0006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788223795-501160
X-HE-Meta: U2FsdGVkX18NON1qLHy8qD+KfrSsE8z0MwCZKbSu2cEp4Y9FtBk3CFF5k3DXBGZPuZVIT3wlLqrTCjBNjXeXa2DAK+ms1NC3RzFzpBeq4lz6v8IevcXA+XJAkoE79INg/BiB2wDUHYptvJXMEZ3jvVTShM/dxouGxu4Q+5xvHZEBGxnwfX4NeTvMcRCHRI9+vsGigJVczWTOU0Z5hzfap97qAeWmFC4t5LICz9QRmxZQvms6wRNV3T4cQqITH6TSaWXLjwYdpEOFyNPIbDrITNgqe8MZxvw6uPeIIM85+QFfQ+q4o+ngo8FqA3Z9JBUWb019kiL57pfXhMsyLdHsmQ3eNMjxzoUfyw5JSS4xyyqJPr1UZAAB2zxILedXUW9dnh5u7U6599sv32CtF6wahXaoGcJ1eIUih2kiJGAUY+IR22ik4Rxb3MnaVbjf/ODSdI7s62n8DIt5ZDJoYsnwB17Bbci/uyreavAy4ipWLMCYYs5eHagGYhdgef4AdEyyyXChOPUUiPWtOISueaenGq3CQR//H2CZXviVr/rt0CfyBYyO8PNVTJr566JwFmZIp7io0gaEDIBxzADS7bBTjRQJVVeTkFSHOrUPFSoFjmYIU4vEGwNRm1tV65+AHjDCF99kf5hgmrQV+mKlEfo11s78rW1IyzAonYCw7qPp5Myufe1n3VUxyOjZrXeyKjr1jxh2d+yxW8CpFFnOmSrsDnPV6N/8qw51RQJoNMUHgdJ/MmvtrsC1ySUbrvtqS/HFXTqjlkbpnWIms2V/4lnvx5vpWflzZ4nxiEQXiwex7jMZd7Sd7ewJYh/q3vNLUKG81i/+Y6OT+sTxEd4/nJ+mhQg+EI4Q7GzhstWcyUBiiRuTwmjii31qcq1Tvd/Gz3xVfd/zkAfnmHbF/EFHCOGS83Hj0yp6z4PHt5c+Aom+3Ck/p6gciu7YyosmOE1E+VgopAeIRDTRQBDInkAJI6V
 HJQ5xOLM
 RgJjl8t+V4mXiu/KQFoFUYyfMuh6O1pvrHEZSg7O/wMh15qUIUeue1MDkhZqcuNY1vJIRjL393gDh2WVOf18OIesB6DcR+26CpXEzUHX+UkcKjHKWVNnN909FjICd2gEAWTf4RwAYrH2UxpyZY3Z6Nv4Hx/pJW3AMzemRW6rvvJEHd4UUjFKKf6z717Evai0dG4mIllCNzbdchFRLLIBVBV+G1tLzgQeaT65/eSqoflzdjVXo4lJ45Mzz/rQowUtO14oa9ulhHw/Z9ldX1oCeQmlYLBxA3Qck+0Mf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 07:47:27 -0700 SJ Park <sj@kernel.org> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Overview
> ========
> This patch set introduces a new autotuning which allows to collapse hot
> regions into hugepages.

Sashiko found no blocker for this series.  Sashiko sent findings to damon@
mailing list [1], and I replied to all the comments.  Please read those for
details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

