Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A551C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 02:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28BF36B0099; Mon, 13 Jul 2026 22:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25FA16B009B; Mon, 13 Jul 2026 22:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 179206B00A1; Mon, 13 Jul 2026 22:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A13BD6B0099
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:26:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38368140211
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:26:12 +0000 (UTC)
X-FDA: 84985792584.12.7A8D016
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id CAD6780003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:26:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LXxZo6ik;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783995970;
	b=c/dHywaGfzwroI1ixzQM4YwZTl5tteoWWb8usCAXni7JLMN0Y8fznebGdMY+CXbfOBijcF
	f7D5RRQW7pBcSY/n1rLk5l/MTWVP7PUwKazYurOHtpoxFcf5xEPq23qtocMfV3SfaNxrTw
	izWCsybbbF+kYDECd0Amcibwy6g5vO0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LXxZo6ik;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783995970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9fRwwQkeGf6F9r/P3GuaK/upsaVrmeQr74oaf89FWQ=;
	b=pzX+bgSpcRjPSNZ1V5Eo3Y9cs8rtnTTq7jgoyg2NrJm8dN3sXPvbnw+SvQgsMdJ/aJeDWH
	++ZEOuNGTxwtfxrPkhSm+KrQQVSEqwq/2yTMEpOBKRlH8z9O4kcfjEGfz9pdGVeWdqNesc
	DuKhz2gFrv1tBNQQPmcebsoXp9V6KXY=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783995966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W9fRwwQkeGf6F9r/P3GuaK/upsaVrmeQr74oaf89FWQ=;
	b=LXxZo6ikKL5FZ163ux6l8K6IjX7k8IwSsHb7dHSp7a3/yd7Fr0eE9O9gdF+lz2OSQsBBD9
	v01jqlH6V8pgCQRalgifB+MISHI0vVZBJLolZotqMWhWmPoQRhSc9FHiRG1gB2BjhQuNyQ
	iiiVTG1vfrCW5//A3brF4RaLXSL5N1U=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v6 1/8] mm: fix stale ZONE_DEVICE refcount comment
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260709112520.24857-2-lizhe.67@bytedance.com>
Date: Tue, 14 Jul 2026 10:25:26 +0800
Cc: akpm@linux-foundation.org,
 apopple@nvidia.com,
 arnd@arndb.de,
 balbirs@nvidia.com,
 bp@alien8.de,
 dave.hansen@linux.intel.com,
 david@kernel.org,
 kees@kernel.org,
 mingo@redhat.com,
 rppt@kernel.org,
 tglx@kernel.org,
 linux-arch@vger.kernel.org,
 linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 x86@kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <287F70E5-78F2-4C52-99A4-E72CA16C7635@linux.dev>
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
 <20260709112520.24857-2-lizhe.67@bytedance.com>
To: Li Zhe <lizhe.67@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CAD6780003
X-Stat-Signature: 5op4hef8ah5hrxkx61c87ha366pzg4qg
X-HE-Tag: 1783995968-277233
X-HE-Meta: U2FsdGVkX18fn5K1xp1Bt/HYAHz54wUiVgS0umJpsgXVT0YyVocUwD5FUXtk6/rue5YH2l7qTjNksPv3Hx1YMG+Zvh4o+CPNLU2qKfiY1Zn8oflsOO7npvORKXqdY3nxmrgKk3qo9QYvHyNrt0tjAZcYrv7327R6LPO4sDxLnOD01ci07YiCHARjlHX7Ef9BzrKCm5MIcX4zIT0s5k87SELsWzGJ+T6Xj3+0e7mOspVXJ1E4NT0S4EkkYIThJsHt1wx4Ql1rRNTQqqIzcEy/iEt4ltwCdr0TsQV7naOTznqdiFumgVMR0wXmZfzld6k49g16Un0mEQklx2mbMM7oUafGr15puP0M49jUYcFvPagk7dBusPIibmhK0rnxSfoXxtP2Z970MyvJoO1c6UV+Z2G0dHFsgNoIlTglyVGGyqaUQxMv2jv+nXTJaBnR2zDNEVtWsoDrhKFYsnynTmenz3n8HAc9KDE8sVJ/QxgzLNPvBYQU+5KwDISnl+YIouSjJ15Oa2WQEV6oq3mSFtTcvLOt/yGbVZadO1AgvyEVL9PdnBdrCKMmwll28Yk8M4XKdzudmBrAD9Rx3BsTqZrMQERzW7GzhLfHk1BGsd0ewT0v3RW/Mk7VxmiQr+VNf7Tdc9XIIUK2N/g3OXhXWJIQep/aG6qXPfraDWaqo+IDr9h1UJgmJ3x/IJdw7GfWi1lXC7kzSMqru5pvX+x2uRyKwlUkmC7IPMW3l5kSndaqqpFb616BAA4n+AyVQjz7cDzwULUMs7Is7YDsU7o96+4PApt5ahRgR6Y636zFHMQQG6mYifeZiIWVoAnTKNt53cKekKvq1WSImvEjpH8r8+X/O+rzTWAIEyp/I3pcqQVoAz5COZxhC+TDNmDueZSMPUAlzpjGHHovEEDc7ZVC4NbAmzO0nsMXF+BGDlvJvNKo6dL96RelewabFxAS1FwjYAA4iTxtg3SSVWtQQSlDgql
 8SK13JMe
 yNXktZMSh9X22JryfqSRytB0bDo38WyunpQ5jDp5lc9edv/3+gTN4E+ej1O8h/wOW0JMoODvYcx5F+JNOicKASi6vq0dIpbooBPwAPXRCezWKSJ6Cl05xF8TKw1QjDV/owqlUHzeNevINY92Fyy1bam8YxHW/OYP1zRNAE02WAqrUNAZGUl/MO5GsCL5JyW71ld7S4/nziRqiq2s3HGSmvN7dCSukOP0Kp5ZnmjIwlo+oREHVNxjppQ9taX8kvqgP/PawTnD8qcbMagkb+SnHJ4VMcNpITFuQXyu9pIsKr16yLJ04DdBT/pvFBgVxzFl4JpZj7Wfvw5Rtg/1Pnu3boL/RDa/Bhtq/gliT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 9, 2026, at 19:25, Li Zhe <lizhe.67@bytedance.com> wrote:
> 
> The comment in __init_zone_device_page() still uses the old
> MEMORY_TYPE_* names and implies that FS_DAX pages regain a
> refcount of 1 in the free path. That no longer matches the code.
> 
> Update the comment to describe the current policy correctly:
> MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free path,
> while the remaining ZONE_DEVICE types start from 0 here and raise the
> count again when the allocator or driver hands the page out.
> 
> No functional change intended.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Alistair Popple <apopple@nvidia.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



