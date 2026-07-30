Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 236AEC55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0DB6B0093; Thu, 30 Jul 2026 08:48:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0996D6B0098; Thu, 30 Jul 2026 08:48:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4666B0099; Thu, 30 Jul 2026 08:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C804E6B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:48:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53152A012D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:48:33 +0000 (UTC)
X-FDA: 85045421706.01.D570B3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 93E4E180007
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:48:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jUg/WBkr";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785415711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UIfD52whRdajlRMAs/wH6Qy+tiFNtzMSJDrWVPET15M=;
	b=rUnwEez6yI3Eg0aLgmJ+UXRg5/sqmAGxvv+F4cZQTbzprbuFC7uHUjxhxESQ3JANpUFzT6
	VUBUcqTV0dcbZ2/SDTWQwO7vhQLVKO/z2oQYwlHSa9wrpVL+alIfPg5vmiUcuImVm+KtjO
	baMMtWblPet9vv99zURIbmWL8LD8w4Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785415711;
	b=2abYgU/MqDj8JpRHbmROZ6y9tK0zhUv6tBhMhzsGZjmoatHfDxzNTeupSlno00fcJno8IF
	mnGjpXqFvXjvT3iG9lIEunF+/VwINPbTf7a2qIfycN/tzX4m1kjPxualE8VSv4MAhd5lqw
	NbTTf1v9VyI4Qknwsdab8oMApwM6hYs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jUg/WBkr";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 162A360A5A;
	Thu, 30 Jul 2026 12:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EB61F000E9;
	Thu, 30 Jul 2026 12:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785415710;
	bh=UIfD52whRdajlRMAs/wH6Qy+tiFNtzMSJDrWVPET15M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jUg/WBkr561zbGX58qkiWcD88JbxTs7n3IAzWM5w5aLtyAGKEIjl1xHDWWdQ7crlF
	 rQSHXJm7KHaH4ZyHtXcmFQFnjRYQX6o5Hc5Ul8kJwRqTwBqxhRPsmOLvm0Zgr+CATy
	 QxGK2DH+HqpyHpfoEREFctTirmMHHWk5g1193Y4cSUDY1iw46aTiz54FxkL6w6caTD
	 /Edq8FHJaUGejWUrfjKOIklvUbW5AIwj0b+69OZDPo5WQUL0dN6Ukyn5NfAGY/bpws
	 P3ki/KyUXhE2vZL1rgriZRyDbco7BxiLiqS0F/ZXD6RlaWzJho/xsEQemw5qD6DMRL
	 GVwUk1XGyLnGQ==
Message-ID: <b351c5cf-bad7-4252-b6cb-1e728c97577a@kernel.org>
Date: Thu, 30 Jul 2026 14:48:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: unpoison pages in memory-failure
 teardown
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260729091127.1001179-1-usama.anjum@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260729091127.1001179-1-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 93E4E180007
X-Stat-Signature: in8txu5cpcwrnsz1r1b1utfxoan9szdn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785415711-852386
X-HE-Meta: U2FsdGVkX1+OUcHaFpyE6BWS4fz5/vv0JmxXtkI+jUPI8/N7fsw+Fzvepve9isyUdFb5zcLs/UKSYY8Bcs5jhP5mWa6cVjW+N2h65R6rw8lyrFWCTPAdL81zwZIbpaPGiCcHmX32fa+dsNzW8IuSu1CbmxCKQObBy0byWhqx4VYuAppunWTXCPgzcaHx8MTPZ8lwk1uvsEuHOsXtFu2HKaB/TDV3xL7LTIsZulx0jr02/E4QL/MPmpVltt5j2W4hewiA8ZX8zL80DM0N2TXIlNhfJI9j+zDB/rqQBq4xbRMmu1eCQmXSYav4L3CsX58HXtHikSHV5aS/iS4XlgyJ6ZmanoJMIICRaBtsPUK8DWMhGNSUtW41az1QKleb9NMok21FKdFnejjF5PpjlBln+bsl64UftEXmtdlOBtMHqxeZ0bgOuj9btSMsrefWlBjDim9stjYFAEUpwo1eM/IP1RkjyzSKoJX0SPyZwK0FltQnsuPx+rQYKA8xq1dUwoFZeuZb4L1bNSYmBHKSMPm2qc/359FdCQyaQElLkQL0nDRXgVHkBojPnL30Jr7CCFAT8fpGwHMnxn1QTu3wpovSG5FyhfxldfQprKmYH1qrDLIrfd6dkqyTsTnyMNP+GJiOzjJ5wVeqOdgFVh5OpHSOI3dZK/XSspAQ58Thuqn6QedEyjMTwny9EYejQ83Jgc4sXJJ0fDlIUcHsyQXrVSUyQOFH2z2DiyVQMwSuhw/8MZa4QQnlkfsutOEohu5syLA0/uvyuuxB0dg+nuHhapCEvZdu/+4ajs0Hyvs1VhIJastqHtO2iWVEKGy1T6rkxpoK4FSmBqf8YcLbHmJ3I+t7B0QN4/48es9A0kCJcUnQ6NVOoC4bEPN8skYlpo9hsejECKTbj9kKbG/UgsBXxmdsCTUAkzW4cWn4zIva0WMZafTDx309ypZMWpJhn8ozYQai/xS+RY7mmTGCMk5IdC/
 x2daQ8pl
 ajezDJjZl39e/BQcZBKB7dSo19wLAzkCwieFRwXiNmoV6LaJgdNLhYQ/7IpYeBUhTuXGv6fEaRUmip5fB7uCiL+yy4bzKEiT8LGOgBSKRwNWQqHqxXWsGaUW4BfndYMQdoiOEvVtYZBZpOvyd7+lYoDg8ZK8WTVN8ZWfQ2qcVf8KXFoGLC2ufOzeRrIkfv1JdLDyDg3KSSf52VlRniO8HfROOLq0HI+maGqCkJzpN4yQlNLr6SaQnwuGqbQlo6hd9Clxlps6co9cVleRS7P5nIxhoa6j9eaVClXb5Px8WEhJnCuuOdviPbU8cBj7XD6FQ0EtAj4ow96mJf6/1s8CNdtzP8QHmZifxnRcqkYtPL5mwxcH9f2BLTIOlBUd86jPp1z7SSIUNGTM0GYsaBe6kr5CpqDt5tD/ZbgNzBkBvXMc9MLliW5hwv5ZY1LtQ/XKNltTiwo4rAAf3nYM60Os+qSAe2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 11:11, Muhammad Usama Anjum wrote:
> The memory-failure tests call cleanup() only after all result checks.
> A failed ASSERT_* invokes fixture teardown and aborts the test, so it
> skips cleanup() and leaves the injected page hardware-poisoned.
> 
> Invoke cleanup() from FIXTURE_TEARDOWN() instead. Guard it with
> self->injection_attempted so tests that exit before injection do not try
> to unpoison a page when no injection was attempted. Injection can poison
> a page before returning an error or delivering SIGBUS, so teardown must
> clean up after every injection attempt. This runs the existing HWPoison
> and HardwareCorrupted checks on both normal and assertion-failure paths.
> 
> Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

