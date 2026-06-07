Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6AD5CD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 11:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E4B6B0088; Sun,  7 Jun 2026 07:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF1B6B008A; Sun,  7 Jun 2026 07:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E48D6B008C; Sun,  7 Jun 2026 07:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DFAC6B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 07:58:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E0C41A0794
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 11:58:19 +0000 (UTC)
X-FDA: 84852968718.12.A5C223D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6941AC0006
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 11:58:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QMjl1xiS;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780833497;
	b=DehOcE9993RENbCggfLLvaWoGs+w4RGi8J0XB7VNfIj3DHHrFPowFvi85CMZEEQn56GnQ5
	O9lqWN/G4oEADmDnqhF7KzJI6RQv10oMjqZ4X2PbIhE5FaQpPwRIkNRvW/v6abYkNzXEcA
	EMzqZ+svvLyRDSvwB/PebeDbGLdv7rU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QMjl1xiS;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780833497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNB4h4utZuNVxiAEqzDEuzLMJdgTJVcCVWUJqa+wJiQ=;
	b=cS2FfL0BFZtsuagL7XZjJzXlI7Z5uKE6MZvOH5NMARAKk+wIsKfZfKczkNtQxpoq38w4Pn
	LjxLGfP3Gu0ywcb1lpmX3k41AtXCsdx72uvr5XoqOsH2egA1siiFWnuDSnIKX8RGIF/O+I
	xBPGV2Gw+Vj0NcfKsN8On/SWwpc7PTY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6C37600AE;
	Sun,  7 Jun 2026 11:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B8E1F00893;
	Sun,  7 Jun 2026 11:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780833496;
	bh=wNB4h4utZuNVxiAEqzDEuzLMJdgTJVcCVWUJqa+wJiQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=QMjl1xiSwtKwrEq23rBPX3A0XsSxwc4cSJ5sHlFSziemnPv0qynpJ2Whc1E7Mx1cb
	 FxsV9O3WNpHYknPYNZSmK6eQt+nsBpaqZWwryUxSaTtObyTKtbqYDcPhfqz7M1nom+
	 MJsRUUCXBAzGqa4+CCmIE/jrnA+l6bfvRFsuAmQ8iXH7LNhMYFsA2KZzQpdwEmBNHj
	 FytGpxqTRDm81hZo2xT9cKp8gCMDbTXSDEYRpmaG3ZfsE0pIFQlbtmwHRDz6ackGzk
	 XJpuA5coF6Xqz5BJyYdhCoKs6qFL2SOjcmnQO4a30hUn+K+rxP+c00cQ/IbQpMlFZM
	 2p7T6LpAC+ykw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC v1 0/9] kho: granular compatibility and header decoupling
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
 linux-doc@vger.kernel.org, jasonmiu@google.com, 
 linux-kernel@vger.kernel.org, corbet@lwn.net, ran.xiaokai@zte.com.cn, 
 kexec@lists.infradead.org, pratyush@kernel.org, graf@amazon.com
In-Reply-To: <20260605033235.717351-1-pasha.tatashin@soleen.com>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
Date: Sun, 07 Jun 2026 14:58:08 +0300
Message-Id: <178083348872.1648214.17778188633648887952.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 6941AC0006
X-Stat-Signature: jip7g1rybmwawemas33yxfqi97cafz81
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780833497-550452
X-HE-Meta: U2FsdGVkX1+tLhzIhhaQeNZtJTqydOjS2/e00QMYQ6r+e/kI6BNQO85CyIgsjk6URua5eP+PE3Q4tjupAVtYxX+1LfJtARERgHkvlI77t77XjrVL3TqGoF5GLEe84SBnQLXJDjCz9c90V4G+SBwi+s8qkmqhidxSlxKFcC1QEfyal8BE//eep6dNfXSEQsG3squoSgxqIskx5n8Fp6HtlMfRUycfca0p4lk7PQrfxcXcZJ7RbwsawZ6jLZDih2sXXU9jJcEJW/wwm/ZVR0mOAgGarhLZjVM1cucPZb1gbTZ+KEDLkE1WdYs0/oP6gA6cMEEb1kXKsfbITwVDa3H0Tv/hpMr/A20mRHTpDXGTD/pNcj3iTMBDrRpTXjzH6AP7+ppfbd6bQxtufvsQ/w7OQsurFvt70yh7D+sj5I53VZET0ZBX178NTY6zAKv/UvjoiHLvKlCikC8uuCrKd4lKdbOutPuZ2iz4XTIYgaKRzhG1qQ1OsXnFNDpSyhSF1P4zWcZp1pxgixCfKSe9Eef4KNlQnaTupBtUUy3XO+usxgtPnTgW0Qk4+67OvMdisXkf+CkMGJ/g51+KM/9oW8woeOc49aVlbKYbqjo7yjyKp4367XGyYmR4zzdDVuFPSeVupRQhhOQjOZ8kLoOcZ/4+fINl1T9q2sT8RLuae4f+SeA60oX3mRpwx9lPfzy6by8EWtl91pQSiSoBvxNk+pzkV+/kAyZUn6CzV/S/2umkJ0dv9u54OhVAEebeNR7KOq0YwZmH8lLYQdRE9KN4cWkZrgfJ0SF+3QORh1YkJqzQeG0N6RGnpXTuI0y1iM90eNTZc/4z8fTzkgmLpCA+TvVwYWTP6r4KAHs4NpKaxi23H/KYOOcgfll1TP1Jh0DmUaNU9wVEl6tJ1aQshXDPXCZSUrXyFEnudkgTSJMOPYguYUc+6NWOXDRRAzUOJ+S83ftsO/fz2mknzIi8Y0VBtgJ
 Y4DCVuWb
 Uykt9UxqBwvO7nC4OeyD48rzi4P1HJ4qzQ5j/YROzLONvqHFOKy9nhqTC3k1EG1y2Qv19yOawYJW4CeABcsdXEKFbPN3P4SU0EyIgQ6NeUsMM1nabz/ZaKR3KWxZ3fRwW/HnraFpvZGY53+SOlu25YK4+elxhheT4KWcak1DnBtvkyFRb6rMaduTp/SB+ujinmPaIdE2mJJlNBXLwDMR+J0ome2JtYSuvIdqWunoECT5l1fGhyDn5FufDEzTD6afbTsE0OyvF04nzCDTd18WhAErZPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 05 Jun 2026 03:32:26 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

Hi,

> [...]
> data structure. Keeping all of this within the same `kexec_handover.c`
> file, and also under the same global version, is no longer sustainable.
> 
> To address this, this series:
> 1. Refactors and reorganizes the code by splitting out radix tree
>    and vmalloc into separate files.

I'd keep vmalloc where it is, it's more of a memory preservation primitive
rather than a data structure of it's own. The data structure it uses is an
implementation detail.

Let's minimize the churn where possible for the sake of git blame and
backports.

> 2. Moves and organizes internal and ABI headers into structured
>    directories under include/linux/kho/ and include/linux/kho/abi/.
>    Instead of cluttering include/linux/ with prefix-styled headers like
>    kho_block.h or kho_radix_tree.h, we use the already existing
>    include/linux/kho/ directory (e.g., kho/block.h and
>    kho/radix_tree.h).

This looks to me like unnecessary churn.
These all are bundled with KHO anyway, there is no header dependencies
that justify small headers for each two functions and netiher
linux/kexec_handover.h nor linux/kho/abi/kexec_handover.h are that long
to start splitting them.

> 3. Introduces a standard set of compatibility helpers in
>    kho/abi/compat.h.
> 4. Decouples the compatibility strings of individual KHO subsystems
>    (radix tree, vmalloc, and block) from the global KHO version.
>    This enables independent, granular compatibility versioning.

I agree that we should decouple versioning of these components from the
global KHO versioning.
Can't say I agree with the way you propose to do it.

I don't like that each user of a KHO component should include that
component version in its own version string (or whatever it may become
later).

It requires ABI headers update each time a user decides to add a new
data structure and worse when there is a change to that data structure.
It creates coupling of the data structure user with its particular
version and just looks ugly IMHO.

Suppose we added new fields to vmalloc, but made the implementation of
restore to be able to cope with both old and new versions. 
How this would be reflected in memfd versioning?
We'll add both versions of vmalloc to memfd version? And all other vmalloc
users?

Or, say, we add support to kmalloc() and use it in kho_block.
Then we'd have to add kmalloc() versioning to all kho_block users, right?

I think the versioning of each component should be handled by ->restore()
of that component. If it sees an incompatible version in the preserved
data, it returns an error. The versions can be stored e.g. in the base KHO
fdt.

> 5. Adds a KUnit test suite to verify that the composite compatibility
>    strings of different subsystems remain unique and sorted in
>    alphabetical order, guaranteeing a consistent and predictable
>    representation across configurations.

Without "composite compatibility strings" we don't need to care about
them "remaining unique and sorted in alphabetical order".

The need for this test alone is already a red flag ;-)

-- 
Sincerely yours,
Mike.


