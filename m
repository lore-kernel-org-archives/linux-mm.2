Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9ACBCD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D9516B00B1; Mon, 11 May 2026 12:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0976B00BA; Mon, 11 May 2026 12:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C68E6B00D8; Mon, 11 May 2026 12:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F63D6B00B1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:48:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA7E6A01B5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:48:43 +0000 (UTC)
X-FDA: 84755722926.13.5E693FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0746F18000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:48:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K5XIpmrI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778518122; a=rsa-sha256;
	cv=none;
	b=II2UvsohQSnTaCit7dsOHAWDD7fYyg0/Gs8J40GLMjhLofRH21R6y5ZY6ByK3XC519zHMP
	5KxbUS9QFc06nY0/C7vXsLuG9BMNiHdLzW9CHIyLk8+adDwc1mdZT88AE7mPbvGus0ciS7
	PygZFfisVs0KkJPgzRvRm96TupmWboA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K5XIpmrI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778518122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqPUNyfX/DvUavK2Y8wT0ZghDSAbcNGXOS89KdqJQ/4=;
	b=w00o/ttHsAEDelVXYhMr+qQQbWcYhMA2iDD07UdxpPrO5kxjYglPsADrydZ83mE+ztVhLB
	PB0pwU1NIrX6i8St2KmUwErCX5hGigJJ3WEx9vW0hGNhdCMfMeiHfD6pUaOK6Vlu+dy+AS
	bWFUAMUoqw3DEXLbgYCsQ9YtMwxFmNg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 072DB44171;
	Mon, 11 May 2026 16:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6EFC2BCB0;
	Mon, 11 May 2026 16:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778518120;
	bh=QQGKCQXAtFFxjOd54vbilU9n1JNF7kVa2ekxD5peAds=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=K5XIpmrIAV/EGwIzcIzruPImlbD5rxQPu7qAr+y4fWfSrVRzeAUiPf0NmgswdXG8q
	 UEhHoDOyTtOUgWhO6lVxIZ7X1xlIp/Fa5itBYE/YcMMWo5DRg5qerGQTFtNGwoADkn
	 xta5TMHWThbryariRnvp3CDvuri4wcDfS/qG+e/mUHrR2qg3ZeagEIhg/hfAeBJUtX
	 n4VxRiB0SufY4hZXWTbw957xB7AWNqygka1jMpQwuT2tF14af+A3M81ANr9x4SYRe2
	 0XBpI8tLpYzDK6ci9Cp8EobEiY6fpRIN/YXN2BYe5UNdPQEoJhgEU9egOzVtFDTgIT
	 Oh1jbHOfE7Ldg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] kho: return virtual address of mem_map
In-Reply-To: <agHHzJS7bLPHk1GJ@kernel.org> (Mike Rapoport's message of "Mon,
	11 May 2026 15:13:00 +0300")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-12-pratyush@kernel.org>
	<agHHzJS7bLPHk1GJ@kernel.org>
Date: Mon, 11 May 2026 18:48:37 +0200
Message-ID: <2vxza4u5c2oq.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: zprhco8ku6sphfqf88r38pbea1mr7a99
X-Rspam-User: 
X-Rspamd-Queue-Id: 0746F18000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778518121-338453
X-HE-Meta: U2FsdGVkX1+tht4Vp5BPWkbevWcs66EjCfsKgTNW1Khe40lVCZLx3gd2nx2PeqCxW/s+zWqPDJoGID/rTWdqKqCsQxVJQwCDJ1aEMu2q6xpjTc9DUXNpF3L6lfVTt4dpRDqH9mDf8P9YK3EkC0IM3AY3jyU3xfURseNj3boTboxnyeE6E7jV3B7lHPh7ItJQcRW7Oh6fZCiYPvocYUYdbJmEA+PzFI9gRcnVwT6Y0H7MVwPf9I6Kn7ewyNmBPwHQ62xAiJyxhM1TJ9BnWHFDluSw74NjXkiaLXP+PqAaswOY4yIysMXN37qQwsYvPp83aDriDRe50hbm+hP/roH4uLrZUVHs87n39pWkdKNK43M2g6SGUi6iG0BQn/BhGsc3uVeoP840Mixng6BzgdXOV1qsqloM+C3a/JHFYvNNgNwcvAK4itZIgZWw2JkYWsgPSoMn64ZDesVb5YJJ4RQoZQtzA9wsVjXziorJ5MV7TOyFw+BxTq8hDLbdWYUkrss5pAM/8mlB+lsjgT3xyqmWYPhiHjOzQtZ/kdHPqIgBIPxx5OvQkxbzr5c9JiHlUF1XbzwWaPaDgaXWQCzwb/CvjviNSUNlpTrySVq0mjWe3Ac3gRsDKbLNU4B0I/pBTYEvnwK2/keZI16pMv4oGyvnvv5jIu6bBPQ7nL6o5+QLwZHaP1cQyfZ5XnflrQFm6vTTXp8400O+jDQ/o97oJYVPwOJBwycwElwDS7QpRzUS/jlkA/kioMsfR0dT8+MzLB0pztLUlsc/eO6e/YcuSyMYpprazrra1Y8iAwVxYToUguqtC7YNxfb80zzGh8c/snQv0Bjx/vimTL3l/kqI50hnSgqi7xYZGYzKVxH52Wwkn5OebhBPH4yN0QqIMyw5F0OgPpSEMnUXieT15Mb8U66KqvSOKR7YeaeYRpzBvQ9wsJ+UohOzwhUaaSBqhw/zCJQMfMUEzUY80xJU42f2qx/
 gXYl0xXK
 ogTUJAdLX43UcHeIgFm1/TEVlCj2FlC2sqns4GejlpDYWshN0fdmWAxqCUSCvuU+AVcWdJUF9mZ2PBsdnbAiiMQxWnP6AqR/mcGIXru9AmwDRArkShYQQoP2narYXJ6i06M1YlYiBX9TdQukPOFlg8oOAizvrJhouXXTYSC/nTcmGb57AsplOpF2tZjUkhdgZHr7BBLRxFw97OaPH1osV/dCNfnOSoAtmTSOObLeYD+QiNwdsWEOVFuN+3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11 2026, Mike Rapoport wrote:

> On Wed, Apr 29, 2026 at 03:39:13PM +0200, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> There are currently 3 callers of kho_get_mem_map_phys(). Two of them,
>> kho_mem_retrieve() and kho_extend_scratch() need the virtual address.
>> The third, kho_populate() doesn't care. Make things simpler by
>> directly returning the virtual address. Rename kho_get_mem_map_phys() to
>> kho_get_mem_map() to accurately reflect what it returns.
>
> This should be moved earlier, before replacing open-coded get_mem_map()
> with a call to kho_get_mem_map_phys().

Do you mean move it before patch 2 "kho: store incoming radix tree in
kho_in"?

I can do that. I did it this way to show a clear need for this function,
but I don't mind doing it as a preparatory step.

>  
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>>  kernel/liveupdate/kexec_handover.c | 28 +++++++++++++++-------------
>>  1 file changed, 15 insertions(+), 13 deletions(-)

-- 
Regards,
Pratyush Yadav

