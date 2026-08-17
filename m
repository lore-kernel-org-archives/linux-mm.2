Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89726C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B676B0105; Mon, 17 Aug 2026 13:27:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912DD6B05B9; Mon, 17 Aug 2026 13:27:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850586B0872; Mon, 17 Aug 2026 13:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AEF666B0648
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:27:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1BC56A08AC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:27:39 +0000 (UTC)
X-FDA: 85111443438.03.1632181
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 750F010000F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:27:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Th24frw0;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786987657;
	b=MBK7lyVH9GZZMeYnItuN13f9L0SWAqyPl72Et/aZ1EiiECwcuUk4zx8qEvlReDY5+GDOQN
	+zOYcVGhMeCXQhWHdiP44LVtc1koNZUsSLoCwsbSLk/igX4M4MmFJnTsXTeUHAZThzyt15
	yugMnWdxMND2/TSkLJo4PRkbA/8WVeI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Th24frw0;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786987657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ctq0R6ygMT+w8aMTiqyYjr0f9Uv7YPSvV/JndH1xvEw=;
	b=w1+857gY0dJeDbu+JOjusJyU/tS0C3ZbHJsPFz8avfTAwHrFBsEwwAU/PFbUYT3QK0kjuT
	CwRwAjxxJvAt14wGowOKZQK4g+Pywf3eTOUQDOWdSDJ6oF9Ngby7nqIaA06ldUzkQebVWA
	U1iUoaCX44APtn4XwkG71Y7sQ1kG31U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B6674122C;
	Mon, 17 Aug 2026 17:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDA71F000E9;
	Mon, 17 Aug 2026 17:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786987656;
	bh=ctq0R6ygMT+w8aMTiqyYjr0f9Uv7YPSvV/JndH1xvEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Th24frw0jFcKHuDZg3UO7g1KT7uq+mOYUNtUNsw9syUFm5Kdy4i12BrpxDSrEw23L
	 3EqBiajEZwVAxAjwGLDHvNVl7/u6ZQIprzmcE+VKsHUhDL2gcBBbOm3yJRkXNypzbK
	 yTrAwCQMxhjM41wo8tdOX+WXRidz+jW6WRmpxuPgqlAjhVnBonHvorYXPyLDUGHpfo
	 BdN9qLAj7ofjbJH8IAWjcT5Q/Ljtl5yGsnhP7i6EPZqzngCqRLDHlvQy0Qosz3Dniw
	 6WPgxFBUPsoWnGlj5He2Or0/L3qfT2jq2TipPJs4/Lr945GPZV7ayCLY18jcwvBIJ0
	 h+Zsrd1I1nUCg==
Date: Mon, 17 Aug 2026 18:27:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: Eric Kim <seohyun.kim@outlook.kr>, david@kernel.org, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v2] mm/rmap: synchronize lock and unlock target in
 anon_vma_clone
Message-ID: <aoND15MPOJcfykwN@gremlin>
References: <OS7PR01MB1391443074B4A2A774B7A956C96A72@OS7PR01MB13914.jpnprd01.prod.outlook.com>
 <a2ec5fd7-fe7c-40ce-a78e-029b2fefcb84@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2ec5fd7-fe7c-40ce-a78e-029b2fefcb84@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 750F010000F
X-Stat-Signature: 3qkc8omzeo9kg48dgjh756s34uzy6m4z
X-HE-Tag: 1786987657-242495
X-HE-Meta: U2FsdGVkX1+pkDvpmSLMwTpKpkNaCek2QUwop3PL1iYmF9DI9Y9NOb8mu3VbY2bWhB6lFfnyRxiADJjBeaGmYz8UC0engATJS7smi3JR6ggsYSJI+WuAW2ch85fcTbKkD9SJuZOP1QDYe7nFGgLHMy670lUia42ZkX0AG1OHmKXcmfqIiwaoUnpz8P3Dj/KnRjz5CtUwEiRYFOK9gA20TlNSSHpS97HAarz4ofSGvkb60PBSEmdXonhfIDOhlQi1fLkxhpQDBJz8MJOcMFGRC7t1i8PovdEg1meMrm6UcFY1XFkF+yjew7i7UGOMlSTMUu7uwMQynb4TM6Emd0pv/UI/GRlsVNN1N64WO/QEDCzeYqUvCaIlerqsurYY8yJnJiIxs8taMmqSNhGY4ZIRn4PuchPhA1JwzmpImU+TaCo98+mkjNMWVHpDV9AGvITs8Xx1BD/z5x8sVezy1F8LtmnGLxzevklNGN5zmSy5QwWoP4tqMgCYJT2sfIHFwisDeeXsVCBaCMUCgbR7L2xgLrcepVeZ9jZKj1CAJM6C1tO+fyp/RdN3BKZ5+eczeTqIadJTQ9R/ykZXtxx1lHjCakO+B7IzywiJeCKpGe2SMlZ4m7DQn0zbUsa2kEM/2OeAhKy40VMJKM6DjyYtecHQZBvTL8v6KZFmu+rAORes4wD0EhEezjJPPAkaoegTfUAnbFG1ooBDwxkhG+sX8HKWn5ppaPg/Tsg3sMzQfYgWLDxi4o+lKqRUdcoKvq6AlPzi/0gGqPD+WY3MhR87WTHeBDDD8W+hwwMOn86TYPkv4jOPuTMfgXtErUoLNy3qnBXAPT/yo5ZWUW6DdBYyax3zSYS7gz+1QuM8iazQMDGAeRGb3b2iP0DO3k3eMZrSelhpxdIkBlgVm+Y9C8LN2K3tdirw1npz45e6pHjV/nWH4EtOtrP4qsNgZzdRXkaeIhN2jMZ3MW2wvAbigRRHZgi
 KWBNSI5d
 57L8+FVvEc78BCZ/ySVCb5wfAf4cC85o+OCUlw4EE6hytdmc8bZm7i8mOAZg+sfKg7AMEe8rbIP6sJ+DyJAPCMM5HLmW7ryuxNAG3Xz5TRf3pA8kDOa+InhEr2AHlKRQhEKV0RFgPRFF2HNfyxJshmtgNpvfSplzcBiqMmLEca4ELCctEJEPsNa3Y887XiZfkkBMsxC5WHerd7WttF0kjusXzofuI8ebxEWFu4IHbRbHA6/ZdRK+Azr2PBcuVLzwPuBSTFKFen3/xIW5sn0pEINILB7pvxGZNK85CCksumK5NvVUR+QnvyuXPzMibqncSyz2w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 11:07:49AM +0800, Lance Yang wrote:
>
>
> On 2026/8/17 10:34, Eric Kim wrote:
> > Currently, in anon_vma_clone(), active_anon_vma is assigned from
> > src->anon_vma and is used when unlocking anon_vma after linking
> > new AVCs. However, the corresponding lock operation uses
> > src->anon_vma directly.
> >
> > Use active_anon_vma consistently to make the lock/unlock pair explicit.
> >
> > Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>
> > ---
> > v2:
> > - Clarify the commit message to explain that src->anon_vma and
> >    active_anon_vma refer to the same anon_vma.
>
> Just a heads-up... since only the commit message changed, the Reviewed-by
> tags from v1 still apply, so please carry them over ...

Yup, if you're not fundamentally changing the patch you should retain all
existing tags like this.

FWIW:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

--
Cheers, Lorenzo

