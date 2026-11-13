Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E59E606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 01:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sSN3pJ9+
Received: by kanga.kvack.org (Postfix)
	id 653756B063C; Thu, 12 Nov 2026 20:46:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604516B063D; Thu, 12 Nov 2026 20:46:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B246B063E; Thu, 12 Nov 2026 20:46:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 31DFF6B063C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:46:42 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF41AA1FD6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:46:41 +0000 (UTC)
X-FDA: 85428406602.07.BBA8D8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id ED7991C0004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:46:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sSN3pJ9+;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794534400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PO7iiVu1lnbvGxofjdgT3IfL7dvVln6UimChVbyzfg8=;
	b=wLf/5ynwQfJIEbYZdi4RNrqEMIc/xCR66EGY7Ew2QAmVgsh0S99RMWFOJVHl1c60irdxAX
	lTJSfonfpsCPjR+giFIYtjrNl+BPydEctoxZStnc6UkFu87IIUnCx8nxFAm+Ooh4ZmMwQ3
	r5DBR4dibjAJSxYbOvZRHENTHTQ3NbM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794534400;
	b=iulgDq1aEQEjchGHyGaw6Q03IkFw5iMTlWUHZ7WehHOwoCyYX/2e+m5RGstR9t9iDHfvEB
	UfMukldc6QeHTClxMVC3BClQYfFUKPvYp1b7Laj70TDu9Q90qdMr+RR8RBMe8nPZB7U6Uk
	PtujAAHt5oZNmpiKpFJULDULmnY6zBk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sSN3pJ9+;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65A6F611D2;
	Fri, 13 Nov 2026 01:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65FD1F000C4;
	Fri, 13 Nov 2026 01:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794534399;
	bh=PO7iiVu1lnbvGxofjdgT3IfL7dvVln6UimChVbyzfg8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sSN3pJ9+QwQ0rGEE23TD/4Tue2klht7L6xfKeGneNKLwdb32dVaXLu4aaze429o33
	 KBt2dWgZxpHhj9/L7qcqlD+8rM7Kb82YK7tuubMnjBuV45EM6+sBfy8OdtrlHAWAJD
	 u1J/WxY4ErvGkEUFYBOrSutqXaPQS2rZ2rDvMAbM=
Date: Thu, 12 Nov 2026 17:46:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Breno Leitao <leitao@debian.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, vlad.wing@gmail.com, harry@kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH] mm: kmemleak: drop kmemleak_lock in scan_block() when
 it is contended
Message-Id: <20261112174638.d467922035f9adeabc04589b@linux-foundation.org>
In-Reply-To: <avXgd-aE8QazfR1G@arm.com>
References: <20261112-kmemleak-scan-lock-break-v1-1-95808108d03c@debian.org>
	<avXgd-aE8QazfR1G@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: zm7uma5umre177ncuwhzfgkgy769dtkb
X-Rspamd-Queue-Id: ED7991C0004
X-Rspam-User: 
X-HE-Tag: 1794534399-782897
X-HE-Meta: U2FsdGVkX1/ZMqe9mboxcHfNmQpQiX04TLtUKfZ9GHJPNOfoGkU9LHaGOSY1WXLpQw/2hlhNFqtSyahfGYV2vPHIbTjHMt1c8rXc46+bZdauidNYmzcLlAYr705uOBAgdxBEwavq5FjQyzWpfuiiKAs9+30C/LfC/CUo6tHvKXLACORmqAR/ylou5K36wDiPo4yifpDQZlNNo1k+RC9/Ew2/U0fCjfvLzVs4vpNZJJC2xbrHNsKineCrp+NqI6Lzg7+ZewQEjgyl5JXopf07i4brzkvNK3L49OwdMK2QQyyX3fYteYKXuhylcX3n0ZAWPCWri2fP20NrBXE2ZBB7mVI+7pzDvzsslgpZzaJldwk4eQE0IZSfDMZwtSRRBKN1/UC+yxBzk74ckxRnwpWNcQyPD4j0eS4c4YuyH4bk/yEstXhl8f3QqT5+kiy1fRxzD6ynFMz73iXd1V8HAt5oXMME4meVeXGzQhID3sE9irAdBItZ/5qvciLmPO7bEtj3j3y/EDLg/eMRrKAozlMIhbIsnET6EHdj8UyGHARSeS0JLsNLT4CrvNLGcixFzpZ06Yvpzio1OZPXb83VVj3OxbD4UzXsKIao493R+X6G3xziHruc49W+UUTx9+Zj18/Cn446cZiDbruZBySuUyfMfmfHAOOvT4h+BfPSMaCVAvxpTEJPfef0JbRzGn7wy1w8Yk/3qCTyhiBy6S2YMIgTsbY6Wamhp4kF+fiSfmZIquZAPHZqe4vs1xiE79wpdlVbkSqU8/ijJ3V0utAQhDlUMEJpwI+Kj/X9f8YyDdVyfPWlpH7P3hsv/+NBE9iEHRfLXMo6zoAsSz8kyKf3LuoVzZHQWtYej/8UDq5AYxS/VdsIwy4DIN/8N+mhIiQDh1wal3m/963P22wiCuOF1vGhpr4MPMyUp+rgEvEE/UQ81xIpJYYYETG0k3h2qJZR+P/PCMKEybZivYuqoF6tgzY
 1uEULF/V
 d437MK7NWXCEaacKHOQj04uBTgwcH65zk5/hwQLf0XnWO5nj/b2DVHcJutV1Q7HNxYi6SFCpwJKeRXMofHMjUvF1ZWYJEQOburK11ShmS2RgLxmMu8uTnaaw6rzp7IzMyITu+WQVUbfFKFaSNcUljVqVI42H77R03hzzcx5gwbkJ/v90MSKBsRadvWhaYX7jDMjIQv1H8uvsLNYb48KExdZKKgnmXdIg91Yn7PbjeswVPRYYh12jsvuk6MN4fg9G27JRvYH+B0IFwXb2xYi51Kjid5XEojSCtfoyT+NUiZBIZ3IwhsEczo0UnVAeLP/pvthRhOp/9a2lTthPmbkYn47yJwcXOslxPhswLcQ1/70ZkUqGUy3tEllX6ndYIZLKEmCTAn/m/BvI4o1Wcgc+NqW/i5IQBPc5a1a/87h2xvwhtYMVsDaSufdDetjRMfLqCGDHq4jCGHzdqCtA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 15:51:19 +0000 Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Thu, Nov 12, 2026 at 03:48:01AM -0800, Breno Leitao wrote:
> > kernel_lock is a damn hot lock, used on allocations, free, NET_RX, etc.
> 
> Nit: s/kernel_lock/kmemleak_lock/

aww man, I had flashbacks.

Then came along
https://github.com/torvalds/linux/commit/4ba8216cd90560bc402f52076f64d8546e8aefcb

things were so much simpler in those days.

> > It is also used on the scan, so, while scanning, most of the system is
> > mostly waiting for the lock.
> > 
> > On meta fleet, this is, by far, the most contented lock. This is not
> > a big deal, because very few hosts run with kmemleak enabled, but,
> > I think we can do better here.
> > 
> > scan_block() takes kmemleak_lock once per block and keeps it, with
> > interrupts disabled, for up to MAX_SCAN_SIZE bytes: 512 words, each
> > needing up to two object tree lookups. Every allocation and free in the
> > system needs the same lock to insert or remove its object, so each of
> > them can wait for a whole block.
> > 
> > Keep taking the lock once per block, but in auto scan mode, check every
> > 64 words whether anybody is waiting for it and, if so, breathe (aka
> > release it and take it again so that the waiters go first)
> > 
> > Releasing the lock is seems safe because it only keeps the object trees
> 
> Nit: s/is//

De-nitted and grabbed, thanks.


