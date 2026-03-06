Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD7B0F01804
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 08:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296476B0005; Fri,  6 Mar 2026 03:02:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26DC16B0089; Fri,  6 Mar 2026 03:02:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16C826B0093; Fri,  6 Mar 2026 03:02:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0137D6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 03:02:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE20316040E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:02:52 +0000 (UTC)
X-FDA: 84514896984.06.817E385
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7BCEB40008
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:02:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772784171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DXqSDHmo/vMLBGuKS962CKs4sTDVWAYdQly4atF5V8Y=;
	b=Bf4JjgE6aVIybXQgHwP42sVUWIhMUPWCHRfEWq2kgWEBPQ8Ws0Mdax34lF8NtBdhrWWEvK
	rQgWKtfIeSEx6DxjYuUoGYKUclECOwv8lEli0wqQ5kVTy1AERKHvXSo6zKkKWlQXFcNyzP
	SZYig9pLV6bohmfWNsVSvsSVQEevHpo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772784171; a=rsa-sha256;
	cv=none;
	b=YY2SzG1V/RqiJfkt3gPgFkGDjploMUB2Qv6TtwKziL8/fgVnX2XF10yP/vVaAu6umrMsNh
	Y/cEVXAHghSHt3b3g4aVm1NobGI9NH+V0T8XDvlv1YhMZYWBUSFH8idRdCjGW/VaAn8Q6Q
	nV6sFcQ9+FBRUGKo/TBndWUOP35zv+8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 6 Mar 2026 17:02:45 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 6 Mar 2026 17:02:45 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: rafael@kernel.org, akpm@linux-foundation.org, kasong@tencent.com,
	pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2] mm/swap, PM: hibernate: hold swap device
 reference across swap operation
Message-ID: <aaqKJQeO8wLQL7Zn@yjaykim-PowerEdge-T330>
References: <20260306024608.1720991-1-youngjun.park@lge.com>
 <CACePvbXVvPp_a89UFztZo5nGawpFea9t=NRisf468VcxHgkX7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbXVvPp_a89UFztZo5nGawpFea9t=NRisf468VcxHgkX7A@mail.gmail.com>
X-Stat-Signature: oci9f8pt5ajn5yudrg5y5wijsk7nkz5m
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BCEB40008
X-Rspamd-Server: rspam12
X-HE-Tag: 1772784169-950762
X-HE-Meta: U2FsdGVkX1+CkdOLeb/f/r5bJlcSRMgFFQZqs2sQLRxWQXiZJ7yRMIsy/FdQmxd5lx509O3cZwJ5bz+RMS/choKOhH6rK6GxthE6jqvd/c3FVyH22/zXA76JVrYkQGGOXdUALq35kj6rOMxfHT2axt8eoSf/g4xMc/9gMRRYUyxrcL6ISYEAY0W5Sh2Whkwcv9rbJLTGRe9Y53tIp63ntMv90IVTi6t2CQHFu0hZ+2AcW7/x6NXvCIlAcw9bpSyhjMLa2r0BDTUDGC//CoKrfyciTq58Y+gDBRIty+lhORdxUnoczNkg5GIPmbvciEI8Ur7V8AZASDELVjResFDiyhXkwzQ40SIo5oqctYVaVqdinV/CY+fA3c5WY75eNfR0OvqXRqqGSbn/cS3LYVam26YIlMdMTEIvfjgXszY3KcFPeZhXwVB6PXClB3rf4kwI9pQqVi9reRJ+wHAHuhI1G44oRHl+70fRjaPTamc0r6nRCRcHNsSqWmTDyo5npfCkV7EBrZ8WnLkeq8pm+OuwWpC3EMUQ7YCReg4FlQBPGDf5T42ajE/ozxP6mJCxDBmt0sxr65HGsUKvY8qB3bXDg0waFTx5xC8eevoTQKbrTQP/Y0skDmSTMqWUjtjrTIhEiXf5bf7lWyT7S9NPcVvsG5DCFSIz8IrkCuhHzwVoRgwBiI1ucG07m0a2z9AUucijPeHuPjG3qBNlZGeG49mRMiXLj1hu/F8UVLucp472oGm1n5ToZbRw2TMd5NThn8p9EEKyUWZ6O/n2YBD8FxXfmWEekpw8262mKRxkVgo7PsI8n941k1O7UgWtXeg3d5QwnGG2k8jwEK65C19tcuroRu5l1h6l0c7Oeo+5yyHATnwxL0q/Kx7nUnsh2N1k+D28dMwN7qyZ5R64ujtIucfKs+wk/1lYWRtCddeWFoQMB1x+frIKPWWTDEhEJ24ZL1+oSUOI7wcS6VXFIoxbFU0
 TzHrADtj
 heDB33R9DH3jlPEJ+s6mOw0d34OBc73ZSF8aBXSgVPvthXUxRCBym5fV/hXBeBDXRHL1ef+m7ybvOHNOpUk6oIROU+UR06rQ8CPIhqm1U+cJKxTI9YtRB+p2oMWXXMtCmDvjLvzQjFLLv8ZLzqHcdVq1KF8LTrzIZ3JMg5DglddREMxuPkWu284J/cSi8F4L6LvMzqBba8Ykus9fydSbcgasVNBKcz8/J03ryTQk12uMxUMdmXN8S+uJfDNy8bGqboP7IDdhpnpfZOI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 10:55:15PM -0800, Chris Li wrote:
> On Thu, Mar 5, 2026 at 6:46 PM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > Currently, in the uswsusp path, only the swap type value is retrieved at
> > lookup time without holding a reference. If swapoff races after the type
> > is acquired, subsequent slot allocations operate on a stale swap device.
> 
> Just from you above description, I am not sure how the bug is actually
> triggered yet. That sounds possible. I want more detail.

To be honest, I am not deeply familiar with the snapshot code, which is why
I submitted this as an RFC. However, I believe the race is theoretically
possible and I was able to trigger it with a simple PoC user program.

(not in-kernel swsusp as I think, cuz every user thread freezed
before creating snapshot, only on uswsusp)

The race occurs in `power/user.c`

1. snapshot_open() calls swap_type_of() to find the swap device.
2. We get the swap type, but hold no reference at this point.
3. [Race Window]: Another thread triggers swapoff() and swapon()
4. snapshot_ioctl(SNAPSHOT_ALLOC_SWAP_PAGE) is called.
   -> The swap device is gone or the type ID is reused by another device or 
      swap device is missing.

> Can you show me which code path triggered this bug?
> e.g. Thread A wants to suspend, with this back trace call graph.
> Then in this function foo() A grabs the swap device without holding a reference.
> Meanwhile, thread B is performing a swap off while A is at function foo().
> 
> > Additionally, grabbing and releasing the swap device reference on every
> > slot allocation is inefficient across the entire hibernation swap path.
> 
> If the swap entry is already allocated by the suspend code on that
> swap device, the follow up allocation does not need to grab the
> reference again because the swap device's swapped count will not drop
> to zero until resume.

You are right. Since the swap device is pinned once a swap entry is
allocated, we could indeed rely on that pinning mechanism to ensure safety
for subsequent allocations (instead of doing get/put every time).

However, relying on that pinning alone does not protect the window between
the initial lookup (step 1) and the *first* allocation.

My proposal is to grab the reference at the lookup point to close this
initial race. If we do that, I believe we can remove the per-slot
get/put calls entirely, as the initial reference is sufficient to keep the
device alive until the operation completes.

Regarding the reference release strategy in this patch:

1. uswsusp: The reference is released when the snapshot device file
   is closed(snapshot_release) and error paths.
2. not uswsusp`: I only added reference release in the error paths.

About 2.. I conclude that on a successful resume, the system state reverts to
the snapshot point, making an explicit release unnecessary. However,
I am not 100% certain if this holds true for the swap reference
context.

This part is the primary reason I submitted this as an RFC. I
would appreciate it if you could review this part specifically to
confirm whether my understanding is correct.

> > Address these issues by holding the swap device reference from the point
> > the swap device is looked up, and releasing it once at each exit path.
> > This ensures the device remains valid throughout the operation and
> > removes the overhead of per-slot reference counting.
> 
> I want to understand how to trigger the buggy code path first. It
> might be obvious to you. It is not obvious to me yet.

I hope the explanation above clarifies the trace. Please let me know if
there are still parts that are not obvious, and I will explain further or
investigate more.

Thank you for the review
Youngjun Park

