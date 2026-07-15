Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04377C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E7556B008A; Wed, 15 Jul 2026 09:59:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BBA76B0092; Wed, 15 Jul 2026 09:59:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D1AD6B0098; Wed, 15 Jul 2026 09:59:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0CD656B0092
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:59:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5786C0128
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:41:52 +0000 (UTC)
X-FDA: 84990972864.25.F5346A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 23DEA40006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:41:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eElLlbTE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784119311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFYijXd/eRRjsT6uSgIi2DnkFRuxM3htkW3xD91av44=;
	b=zTY4uS7kjOlYvzEaGPgP0ybVwJOLBD0UEkJr+TlayaQ8AVeAH4XmIOcFhfzDsynbSeg6PC
	aP3bZ62R+mt5sL/Q6KLmOVOw1ulkQCDHZj4MSLVFxg1wdf5QroV4G5XcXqS8xNAUsQ71Bu
	meuCN9umfSPl8od6P2l9YofVB4tzdeE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eElLlbTE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784119311;
	b=v94Q4pBIq841nekGY/sje6kSw330JlljFRN1R/7EU1DjSJt/lXYHBX2OPfKfZAIq8OeadR
	oaok8Kji59V73hMTM58NAo4MbHys8S79K6xVN49aI4F20LU3AmMpXzhS6K7abiDP1Czdbs
	nPo/hicBwTMaxKt4/FoAYm/JFbOWqgU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FDF1600BB;
	Wed, 15 Jul 2026 12:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0010E1F000E9;
	Wed, 15 Jul 2026 12:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784119310;
	bh=LFYijXd/eRRjsT6uSgIi2DnkFRuxM3htkW3xD91av44=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eElLlbTEYVW/Jv0j5NkpBDZmaXElwE/+fDmcnfu1UvCt7uGcMFYiLv1KaEZA3HCXk
	 4/R42D0LV7X6nQ8UJ+lhfxI3Mt8el0GSnM3W4P7jD11TilEUq9ug7431XSZPN+fzKN
	 eXn1hBbLgcDg4YgdjjjBS7zMgJEtBvqu5fhWNjMEP+F82umJBb+ZEs3x2ZSiECEO49
	 hZQsDTx85qRVroPgev2eTkvGta2k9aySNX5ysXR+OIpRpCqSoDdceLtpthwpSXOKTW
	 U4BIJCdmMz6pLo4FeuFM4ZgqIBSRbkxbKrmjOtcPaCIdT1KHnVXu7CyH8SUIEYB9OX
	 467FF/XXPbOLQ==
Message-ID: <4300f09b-8f93-4605-b072-7c09a82cb16e@kernel.org>
Date: Wed, 15 Jul 2026 14:41:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] mm/hmm: Clarify notifier retry state and scope HMM
 timeouts
To: Stanislav Kinsburskii <skinsburskii@gmail.com>, airlied@gmail.com,
 akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org, corbet@lwn.net,
 dakr@kernel.org, jgg@ziepe.ca, kees@kernel.org, leon@kernel.org,
 liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org, lyude@redhat.com,
 maarten.lankhorst@linux.intel.com, mamin506@gmail.com, mhocko@suse.com,
 mripard@kernel.org, nouveau@lists.freedesktop.org, ogabbay@kernel.org,
 oleg@redhat.com, rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o7bssty6qcroishcrxz9o8kyrt8c7scr
X-Rspamd-Queue-Id: 23DEA40006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784119310-418926
X-HE-Meta: U2FsdGVkX1/w0bgl32dRrBTQsv2kOAiKuvpzl4ZuUxLRPuZyyXGDzYDHTBy///+rcemu3ng1E0/ptIRXJhCEzOcovNggAJ8fe1CvbQpWAUFizpYvoLduEq+fQ+hT1VVM1O+CQRafrIafgNlMTWSBEOvBJhTHl/6SNDrS7Z4hyCX1gXIo0xQCJOSrAmsQJ1xq13ymSmvIleuz80aP2SLRtc0nBw/i54II772ffjwcY4WkQveM9oyv42JpusoI08FSz3fPX6WfNzbVjTvCWYm/EXkl7HVSeIUrJx03nfyuGyRxs4mFOiZaISUalJKBAEb/3CSyYGppdX2n5+tLviu5MbS3oXATpIExHtySomEN8PWsQ+uSx+7elcQeyhsqfom4gX7NTgZsYl2WwioB9be52ygjlPKEefh5KgVcSkKs64v9kkH23/ZMO9BXY1Ip6kk6UruMNup8H+MRKG/xKQiaPewKVmcqr2Hr6/t85Nem7B4uOen6a2fMaAjXStDKriRuV6NOS6Lb1GpnbGvJj9EuD4XAAxV5bWraFOXi86834wPAQ2UQsyGT2VutJlnhXsMNxw2IJ1Kl6OuviI/IwkMuomJcjZ23I7iOM+iLoHx389ffsYd7WrBZ8KB89n5CF+EXsDvcH5/I3NDok+2HKhmjFAgyBZejX/+bJy3nL464hShfqAtwFKvL/F1b/02n01dUCDM1MoY+c8eDv4sEEAEJsVV0+MHj0dq2XL5qlH7GTYFbgq4smYqCQtQNbxO/ctaOHLO7pBCFnMKfuCGyiYl428VLXoAv5tP+tqrXQWKsQrnbWPHfYs6cYjqErpk/kHFcUEREOCGxJSdVWyNi8fGpewP8gHBwpxcQmnF5nR33ziauXbCufEDsRYA3YPgCTrqTCJKU6mw+YHc9+MYKF2ibTgf2J67xsbOsSl+rQt7nRoQ/qCIgMwxPMQuM/Tb7XIU8qqLqaYvDG0mubfyv5vz
 Vedpwcbr
 xCdP3a3LAMCs64NGjF/aUPHEZehqDVJyZTG7BnfWzupeKhkfS5F972oUh2PfnhW6pBPvhvchAErjJOuItuoYGs57cEk4jVzLKypeRnM7prx2RTtTxOYwbOtjeKLeXsAmgfvRshTeEaLofTwA+oycF9v+/trLjYnHTft5AejPWYd6lIB0zcB88hSFeiPYWF7IIPx2OZBcPGRvhGh83YvTyUD5nA6JgUeQQzH9WuiR/8+hDP28oFi+XSRUA2FiuZWBmMMdDlIoWC+nZNOtky5bWcPV4J42aB3nyJz8g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 00:21, Stanislav Kinsburskii wrote:
> This small fixup series applies on top of:
> 
>   [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for userfaultfd-backed mappings
> 
> The first patch updates the HMM documentation example to make the
> mmu_interval_read_retry() state explicit: callers should use the notifier and
> notifier_seq stored in the same hmm_range that was passed to
> hmm_range_fault_unlocked_timeout().
> 
> The remaining patches adjust nouveau, amdxdna, and drm_gpusvm users so the
> timeout passed to hmm_range_fault_unlocked_timeout() is treated as a relative
> HMM retry budget. These callers no longer keep an absolute deadline around
> their outer driver retry loops or pass a computed remaining time into HMM.
> 
> This keeps the timeout scoped to HMM's internal mmu-notifier retry handling. If
> HMM succeeds and the driver later observes an invalidation through
> mmu_interval_read_retry(), the driver retries the operation with a fresh HMM
> retry budget.
> 
> Changes in v2:
>   - Kept the nouveau outer absolute timeout around the
>     mmu_interval_read_retry() loop. hmm_range_fault_unlocked_timeout() only
>     bounds HMM’s internal retries, while nouveau faults are handled from a GPU
>     fault worker, so userspace fatal signals cannot break an endless stream of
>     invalidations there.
>   - Updated nouveau to use time_after_eq() before calling HMM, so the remaining
>     timeout passed to hmm_range_fault_unlocked_timeout() is always positive and
>     never 0, which would mean retry indefinitely.
>   - Updated the nouveau fixup commit message to explain the worker-thread
>     timeout issue and the time_after_eq() boundary behavior.
>   - Fixed the amdxdna fixup commit message. It now describes
>     aie2_populate_range() correctly instead of carrying stale nouveau prose,
>     and notes that command submission still keeps its broader timeout while HMM
>     gets a fresh relative retry budget.
> 
> 
> ---
> 
> Stanislav Kinsburskii (4):
>       fixup! mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support
>       fixup! drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
>       fixup! accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
>       fixup! drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults

Why a fixup series instead of properly resending the full thing?

-- 
Cheers,

David

