Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C73B9C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDC296B009F; Mon,  7 Sep 2026 10:04:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3736B00A5; Mon,  7 Sep 2026 10:04:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA1FA6B00A6; Mon,  7 Sep 2026 10:04:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8AEC26B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:04:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EA4E120192
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:04:27 +0000 (UTC)
X-FDA: 85187136174.23.A0AF9D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 22C98140011
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:04:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cWwO//7N";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788789865;
	b=3EdukyggBdtkJacBD+p/gvdEVo8UQbW4mXKlZ0RFZ21+OJE73ItZvWZGNJtSojbJOn6Y7z
	XNXgM3dImKUYPUHcwu2WSWXW2CoFYaaM/opOQlMbVlXz79j5WDj54lOX8vi6ICtqGdq0O4
	Y0nkrfcYpRx2bj7Tyv7LpJFPhmqaNY0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cWwO//7N";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788789865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vd6GZgH7joLbpfhKBwoB39Qg1NBV6ab8x21f0nPjXjY=;
	b=4T/6v/Tk+CSaueFZd6ezs5c6ZKG5/pNcfKgd8IJylMHOQiHMUOvC9DWvjXsBhbzYTXSJyh
	iXoSSpGmAQZEfMBIBGLJRlh4SkTaf++rwNwtBOAoRA0QQBvo3ILvpAHKKyFnQiUk5I6V2M
	ezXcLArF2P2u6I6spJjBPHU6Cj37Ayg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4975840F84;
	Mon,  7 Sep 2026 14:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C111F00A3A;
	Mon,  7 Sep 2026 14:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788789864;
	bh=Vd6GZgH7joLbpfhKBwoB39Qg1NBV6ab8x21f0nPjXjY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cWwO//7NDOO2LqmDpRyUwhD536OQv/cSwNQWn9enKym8mRYzQB2K6c7J8a3Or+WfD
	 9P1L3gdsTqcrqmnT7t4PJExzy0d5/QJQDXXoMilHxJkSS2Utyv12+G9PzTRFmee4UW
	 3FX1FsBWPq42ilUOUX0Dtj+wJ8RNfCNg4Cr9kpgV3aVYJOKFHBBRwgsMIuDKjFuXOs
	 Tfvlr+enI4l2XdkRjlWhjTX6AKdL+eZNq0mByvzWver8y1q8eRQgJE7JtxI/FzwE/A
	 3iBEHEXdDvTSPvtl1sG7z0jCYVadkzU2/HO62tmnSNqdR980Z6enK5MRqc4wBxp3Vd
	 ryWUUYNVwXiOQ==
Message-ID: <571424e0-f4b9-45fc-b9ba-3437352cc11c@kernel.org>
Date: Mon, 7 Sep 2026 16:04:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v4 1/7] mm: Add copy_remote_mm_str()
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
 bpf@vger.kernel.org, brauner@kernel.org, daniel@iogearbox.net,
 eddyz87@gmail.com, kpsingh@kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matt@bobrowski.net, memxor@gmail.com, song@kernel.org,
 sun.jian.kdev@gmail.com, utilityemal77@gmail.com, viro@zeniv.linux.org.uk
References: <0e4edfd3-0c82-42e0-ad09-19ff8b8d1511@kernel.org>
 <20260907134101.424017-1-tasos.papagiannnis@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907134101.424017-1-tasos.papagiannnis@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 22C98140011
X-Stat-Signature: karqc6nc4x7fx7xux88tsntu9m5qnyuc
X-HE-Tag: 1788789864-943151
X-HE-Meta: U2FsdGVkX1+uPxlHDDjjwFKuIvR52v1rh/b7caIaUjHzZoFevAV3JarHfu0byHKY4gnAlu6rTXt5L5jdnN+L8bdLTnWsW4IFASPVhtox+CeFfAjFssbdA5D8PLw/mEshC82QS1ctAUAXEnGcmVQ+m4okqr3QL+pKSP9irAAJWpM8UqOifXSOfIsT9i9UIUtmbbaVnXUd7QamMbHgLQQkKKCQkZ0MFFjHeZk4a0X20AEMWHwvMPitzlJikOODiAm1xLTE/NjVxv6ZlI12PW19KbSSifNEMDlBJipprPYyn3R+9kgmek6tmB6Sy/D4So3d3/ZttB1HDVZbZsm7KthrTDTH3hv6M5b/6bpdz/rIg05fe09UPqGHOLKDh0nz8Tb50fHj2mQC1Q0oN9S7GThaAYbobZA+HkYVAzeBbEMdoXrkYYSCZqL5U015s8vJkgvjiQrVbbH14C5i1qK7zTbmTwIdzzuS7C2fchmsiVZUx9ENEMvz+Em4AEbC4Oq6muQzie6Ul3BhhAqzqQPcZhte0VDW2aSZnJYpA+rJ3u4ppHSGJOmiQIv5A1aTZZ9J8byn/Hi+ZMU6SmiTwXj55z5r4H4cPnt4EiGa5rW2ds2MNobVgDbqpN/88dAwY2TuAK7Z8mt9eof5ksxUTQHHfESUUWIufMtcspUm5wE7JrodAoz1/dx0cbhdLR6bnAHJCUuL+Yl8Im5xY2xJyho/6MCUdRZGTbkvl4GBrDWwVuc22Hi7A/S5joLtCjlpoiM1dbal9WEiVf/bKr6ASQUbEofhuXRsMbmVdWmD2KHxLZHLis+e6KRYXinzSOn8mNDwgGAZBO+uDfM5Nlz83n3aA0BWB8v89RaN4yWfwGZE6wg95AmWtRzWFGEt+l6/s2vMRtWiXUwOBWAId0xZ0hCfTDIK74KbrfX0TLjRhJ9C85zENJknjaPI1/gxN3zQRE6V7XjoaCi8+r8+fPc2cxA3FJ8
 8RZS6nnK
 NmAJLUHbB5L9qnnxgULwNu3i3fWCpNXIBiesH1ObKDABHSJ2q3iIxNyhgdVSdpHCmu7DISi1FXijz2pOm1Ii4HGRwTmfami7+xEBdCsG4vF/WXHDquwFjW3dD4Rqfp3BLZ2oGAOjXjL8rWhXum0BMNbqXpmF2T1dV06CeR/7NOLY8UPHKo2eIoJE6DGD/akjX0nBcHzUB+DIYAK7py7Z78cwJUgTPpKIRyzwWoiJlmWpcrr40/kTFFqL3RTQkqvxxuoimPiU1ILn7yuZ6kss6QWgSP9eWJ0gRR/ACdy4Dwnj3Ib65Htj6KDr4eTkQFPERW7NhxswYKHfjyMkLZvSWSyUnwp6gf7CvKM90JX2TTevlh0HfrcSbxl8ntNHiVnvJHjJp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 15:41, Anastasios Papagiannis wrote:
>> We have this check in copy_remote_vm_str(). Why are we performing the check now
>> twice?
> 
>> It should either go only into __copy_remote_mm_str(), or if there a reason to
>> have it before get_task_mm(), it should go into copy_remote_mm_str(). Same
>> applies to the memory.c case.
> 
> Yes, this makes sense. I will fix that.
> 
>> What's more annoying is that both implementations of copy_remote_vm_str() are
>> identical, and both implementations of copy_remote_mm_str() are nearly identical
>> (just dropping the gup_flags for nommu). I'd like to avoid duplicating code for
>> nommu.
> 
>> If we could export __copy_remote_vm_str(mm, addr, buf, len, gup_flags) for both
>> cases, we could instead provide a single implementation for copy_remote_vm_str()
>> and copy_remote_mm_str() e.g., in mm.h? (I'd prefer somewhere else, but we don't
>> seem to have a good git for memory.c + nommu.c shared stuff)
> 
> Another idea can be:
> mm/memory.c: MMU implementation of __copy_remote_mm_str()
> mm/nommu.c: NOMMU implementation of __copy_remote_mm_str()
> mm/internal.h: declaration of __copy_remote_mm_str()

Ack

> include/linux/mm.h: declaration of copy_remote_mm_str() and  copy_remote_vm_str()

Ack.

> mm/util.c: shared implementation for copy_remote_mm_str() and copy_remote_vm_str()

Ah, yes, util.c is the good fit I was missing :)

> 
> This allows us to remove the duplicate code. Does this sound reasonable?
> 
>> Now, that's also not completely nice, as I don't want us to EXPORT
>> __copy_remote_vm_str() ... given that these functions are "#ifdef
>> CONFIG_BPF_SYSCALL" could we EXPORT_SYMBOL_FOR_MODULES?
> 
> Now copy_remote_vm_str() is EXPORT_SYMBOL_GPL. In this series, we use
> copy_remote_mm_str() without the need to export that. Why do we need to
> consider exporting __copy_remote_vm_str()?

If the implementation lives in mm/util.c (instead of a header), there is no need.

-- 
Cheers,

David

