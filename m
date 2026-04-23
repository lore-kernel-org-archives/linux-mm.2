Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A024FAD3F0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 02:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82CF56B0005; Wed, 22 Apr 2026 22:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DDEF6B008A; Wed, 22 Apr 2026 22:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F3AC6B008C; Wed, 22 Apr 2026 22:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A69D6B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:58:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 00D1C1A0465
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:58:25 +0000 (UTC)
X-FDA: 84688312212.08.4D4D862
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1FD77140002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:58:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UO5duJjZ;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776913104; a=rsa-sha256;
	cv=none;
	b=0ow5Cav1Yk3WGS4B0+7aSI9/CYWmVi3SsCLOrpqapzfIklyG2ng1A4l+r2CpR1wRcTrtyn
	Brjm0VvDjX/ROz4miBvrs2I8PCSk/Od1PxlAk0BgAAWk7LTfiQgkB9bB2IN15fGDHq+PEM
	XD/9ex5a9Pw/5bZMZFuf4BL2mRvX6Jw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UO5duJjZ;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776913104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4t1KTkHst3DgzF7ovXnj4u2GEhX05NNYyESzxY3DxV8=;
	b=fvPtRYPP+DZMdZ3aAmtprKdvo8n3ryP/LKHaVPVFmnbEznYtilX7Ypw5M8k/fUCOHiifIA
	9X/wH+HOAZ5XIap9nNYPy/RaQSzKnqnmNYa1FLXS2pserLqq0Jlv7hQLDb8LN6K4EBIVJU
	2kWcZjc0aOC1A3UY2KdMsBP9wabc6l4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776913101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4t1KTkHst3DgzF7ovXnj4u2GEhX05NNYyESzxY3DxV8=;
	b=UO5duJjZ6yiGRNA3D/aSiBQ+FMx26q7Jd+G3mgJww/pIYxzpHjow/2cXV5oVtY8XjuEyHq
	S6zPEeFG8Bi59JWil0eQxniu4OcF+/gXAwY6TUUI/GkxLwP1Ajteu7pI9YxvsYKQZ9febS
	rvWCexq8PM7izD9DLdCDmDxFyi24vek=
From: Lance Yang <lance.yang@linux.dev>
To: baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	hughd@google.com,
	willy@infradead.org,
	ziy@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	lance.yang@linux.dev,
	wangkefeng.wang@huawei.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "tmpfs: don't enable large folios if not supported"
Date: Thu, 23 Apr 2026 10:57:37 +0800
Message-Id: <20260423025737.60982-1-lance.yang@linux.dev>
In-Reply-To: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
References: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1FD77140002
X-Stat-Signature: j83na7icemcaj591a6u64nbd3hsqhh9p
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776913103-105274
X-HE-Meta: U2FsdGVkX19em/UtIyHq7+iB5K6c8298+JZZpYzcl2Uf/ORM5DvXFZEtkmk9z/nPNdcy1qvjvNdx2RKVVyYVJjZcBLbOLXrkzdp1esyabo5NklR7dr/b6eug3Y0uSx/cUQUvlY73J2d9genD6YCe1M0OduFQOm2h8H3gTz8bMwzi6749/XfD6eti7WbrSD4Ho9Z9AXGW4bXyJMHMSsEriZytg9gBM9a9rNhTuhfVdMZpc6YnJJaFtLUFaB/HKjIN/aKsMfeezoXRd94t6rMT/dh7VLHaz+mA+fp5kkZgV0A1GPa4IYYxOxbD+Ou5Lr3wD4mxuzwX7iGcVJNcdNTP5bxw2ECz3k4pCX+xMgl5Y8quAEn/V1pU7C/f2iNh+OuAXrIXE3iK4jGqsxB6xFc23vRMTe41p2tOlFBUeH2Gtq4Wo8jkpdp0Suu3E8OmCon2EgBiubZUsCEofgSKlIpRVOAg2XESXAgTfL1QP3oQNEInA1o7TxzuK/iPnzocJGX4EPPyUOOlB6AAeTdf0z2yOsfQga+09kadjEiEePffpzEKq6Hu+ozVe4Bc476zzJJSwo+UI8jZsD78CCW+SIBxygU74RtGKe1Uud0nhuLikq7XI1BxcwdtuMJZbVZI/BFFabc79wN6bZz2Rh2xQf7JcH+wpt+sc+T+CqQV/V8JUnHmY9cfuO9azU1z1PZxC6bQL3QNnv/oAevsFpKZQ7k1sDVvbkSgc+/kXnyYSPxoIdncURZlNRV+Il6MH2B2poNFe6q4FyN8pWyNRkBWIBydI5n+WYAhaaXrhK//SW4fhP97UsTZ9MNYx3ZY5POtPRSjHxCPoXLTBpraHKd6Vls6nXndnD9vhH+BmOGUtjRz8MOAATXrvAZymvYUaCR7sW/wwBIHLfAdF9V0XuNGZ66Ki4gOweP4Dmly75+0zssJSW9ZNj1QvAvdH44OXJaMt1ekqvi/oJlZL211NBmpaBk
 33+dLpJJ
 wplv4wkiG0T4qqYigshkVjfiHDu2x79aWMunKKUJG/5JuHgsEe1KcCbqg+x11wjGfdJs5p/wtfljvKjU5i/8PpdA4NddtajiyW7EFmjmx17I+41zq2phToxOR5eiL57hXWDieVSBrrTBTWj9xBBEjwcSbjLtzXB89RA2CyCWCPnIukfKfAyq4MHEW83etzXMThK1L15WrX6BsFBaI2vO0JYFjGo9R1f/kbbMlEonxau3ochlgRLt+VJb5W7sNg/yrhQaZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Apr 23, 2026 at 09:41:42AM +0800, Baolin Wang wrote:
>This reverts commit 5a90c155defa684f3a21f68c3f8e40c056e6114c.
>
>Currently, when shmem mounts are initialized, they only use 'sbinfo->huge' to
>determine whether the shmem mount supports large folios. However, for anonymous
>shmem, whether it supports large folios can be dynamically configured via sysfs
>interfaces, so setting or not setting mapping_set_large_folios() during initialization
>cannot accurately reflect whether anonymous shmem actually supports large folios,
>which has already caused some confusion[1].
>
>Moreover, for tmpfs mounts, relying on 'sbinfo->huge' cannot keep the mapping_set_large_folios()
>setting consistent across all mappings in the entire tmpfs mount. In other words,
>under the same tmpfs mount, after remount, we might end up with some mappings
>supporting large folios (calling mapping_set_large_folios()) while others don't.
>
>After some investigation, I found that the write performance regression addressed
>by commit 5a90c155defa has already been fixed by the following commit 665575cff098b
>("filemap: move prefaulting out of hot write path"). See the following test data:
>
>Base:
>dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.2 GB/s)
>dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.2 GB/s)
>dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.1 GB/s)
>dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.0 GB/s )
>dd if=/dev/zero of=/mnt/tmpfs/test bs=3000K count=1398 (3.0 GB/s)
>dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)
>
>Base + revert 5a90c155defa:
>dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.3 GB/s)
>dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.3 GB/s)
>dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.2 GB/s)
>dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.1 GB/s)
>dd if=/dev/zero of=/mnt/tmpfs/testbs=3000K count=1398 (3.0 GB/s)
>dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)
>
>The data is basically consistent with minor fluctuation noise. So we can now
>safely revert commit 5a90c155defa to set mapping_set_large_folios() for all
>shmem mounts unconditionally.
>
>[1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
>Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>---
>Note: for more investigation and test data, see:
>https://lore.kernel.org/all/116df9f9-4db7-40d4-a4a4-30a87c0feffa@linux.alibaba.com/
>Thanks Kefeng for confirming the performance issue.
>---

Thanks for tackling this!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

