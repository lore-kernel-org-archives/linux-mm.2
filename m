Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A07A5C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 10:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BB976B0088; Thu, 27 Aug 2026 06:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56CA66B008A; Thu, 27 Aug 2026 06:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45C536B008C; Thu, 27 Aug 2026 06:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 119046B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:26:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F78E1403AA
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:26:10 +0000 (UTC)
X-FDA: 85146669300.30.7D60BC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BEFF514000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:26:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UUgQcPHw;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787826368;
	b=SdOP0HtrmF5KcEWJ8m6Ho+8PnqDvO57VbLt/b7kKfq9DgYO02bjMDG9sVVtnSuJ1F4iLt7
	BdVNDKVd0nXX2n8pPySBn0tV6wvqZwrkkcBl4fPOwRyB6M8uE7ry9THJyX7RhGy9e8PlJY
	FMCBKeM9XHX00sRBavJphVR/MoMhzfs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UUgQcPHw;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787826368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Yqh3iS16BKHB91PJME2pWLwTOseAJGffrM+2MMe64M=;
	b=FRu5iMgR57ijEJ6IDjEE5PpTLd4KyQoZT2mIkq/A8c4RGqH4x6zc1sfoGyQ/I7oiG9RxDF
	wDuHGhFmSUyJhFEjYde+gGvGJozGYB+jedeDwL+4JaCKDilYDwE86P3To5JeZsKqR/6Tet
	AuYnxLXcYQnxZGj4PPev+wl+kBM1zLg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7E8742B0F;
	Thu, 27 Aug 2026 10:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4121F00A3A;
	Thu, 27 Aug 2026 10:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787826367;
	bh=8Yqh3iS16BKHB91PJME2pWLwTOseAJGffrM+2MMe64M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UUgQcPHwUg95r09B5/yuhUxugChiVBP/REvP3e2FwOCMwPPg7bVM78uuwd+AhzxM/
	 L7FU/02FEUhA01lPm/UIFZHGZaayYg5vp6eYDd/vCivN5UzPDgX2cV+ktPdOM20p9n
	 GPj2mD7oIqnO/7Mfxvz0YpP1XY4xuHhr3a/dooijeMOwExEboM9MXGN1GFe/uTqokX
	 wCm0SRbf//ozJ0xPQ7oKz5/kjHCDSMTjDe4ilvRR+WzVvcLFvrDWtYGA0H57WHamOM
	 JKq7vWe5Gkv9eiqjdUCsF3+7JMUq9oFPgNSyjVXbwowbobEL2pKxS96LimTxpKdeYs
	 fbpHonZJcUw1w==
Message-ID: <8823867c-9d3c-4a01-a213-75f6ae0755b4@kernel.org>
Date: Thu, 27 Aug 2026 12:26:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/secretmem: properly account locked pages
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Daehyeon Ko <4ncienth@gmail.com>, stable@vger.kernel.org,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Hagen Paul Pfeifer <hagen@jauu.net>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260826-secretmem-accounting-v3-1-94cb04399510@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260826-secretmem-accounting-v3-1-94cb04399510@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: g98usz4hgigro3iyq4odbaf88iij4ncf
X-Rspamd-Queue-Id: BEFF514000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1787826368-428608
X-HE-Meta: U2FsdGVkX1/U7P+ufwo/neyY+HI0wsSn5rJgZsPSWfqHjwVkLoz7Rm32SE/cwRBOUHzgrSJTFzfcrD12PAvaS7qbaAo9VI44+LJZF9YkYnTh5Z+XnpU/6zeM3uxtzvXeNIoI6bt8N/Kzi3DzSzhEbgRu5ti9kuUk5JHzMg/cF0A+vQ3RrSdWavBQT5M/0rDZ00THMF5JRY50aahWgTfBxD/mQ8NiEsQVyBKv3P36keZ69NvIjrG48L7wfOldkXNrzl57s3VpzaUZNWxatGk+te2vDUwxDukcJ1n3Kp+9W+E6rWelACR2BVYXrCpMBQSgXJ5H/aOtrzGbsNoWwoOBUyRaanHnSjKWSrxcS771MvEFtK2T16lncfgdJnEGItIjTu0FcdAMbt7do9DDtVQZKk10w0FYeRGVT2eo7fBOIYK2wO+PjuGvzXc+DRaQTbb2UT/1iRLUCG0qItJnQ3gMyeffHrJ3/ks2XDyk+XdWz5BvbFfPcAXf6CPWhVGmWWOfV76pMLABTBrMkt6lNBru2b/Ph2zkq6xbIY2sNkKj+Fuy9wRMGHm19Q7UYYopwrHjHKlEqUqseBr9DEtUdznxlKmEBcD30V4yUzzk7FNEKGKWN5gi+bXzwu8nfHaHw7MI+8BgGDdIJbTgCOG/H41Tj14mf+re1nfjQE2F6G0gfGkzIuR9ltTxjMXjOHKe7n3WmwgyfxbkevX6eMQOOjQ/lxpukE7Vu24hIBMB//FETDlUHWNnoWzJkiyfskpol+F94jYyKgnVY/XZnrmIFhjnVuVm3GbPE5D3wpvHKvMGhk3kBME+VBWvihfzflV5XK/nIzrTTr22crHMXTHHwnX+Qci5xqhfRnAG3/02htOmyNEuB7krZxaHq2i8v52gALOEdsKXgRmkCTqNrNfZ0ifnr/VCZFCOAb+YwSz8wHtWos0OjJP7C9Z/Fk47CX3fk5N2gnOMXPPCvM12HMnxD2N
 z3G7e64i
 bmJ3bX2aSQYCkM/rAvUF31Naqbr7BYNKQ/8dMtbOs3zGxwzlnvI5KiOogXoQuBHz489L00Vmqt32+vFm1wk26NzdfhFVg2tDajRSwo2dzhCHT+zr/ylFX19N4ay+YzZWGp9W3b48Kq/XMoC+caxvLfav1NWMMNZXwTEMM+gIhNJULD3GSPe7Lr8noFZwQAeIV66mZkolxV78F8ew8jnhn/6wCR/Zu2ScJ4BWuFteqa1VhH+fqCS3M9grAuMGsPPmflYPcA1vqf/vFbxmxmUs+RjcTnG7EUdbhxt3h0ku1lIlPuCcSI3gjgNwzMf5l2julVVmJ5P/xO5BfEI2LZ3dJhjBOLof5ZKc9O3MF61cmQH1G01yO3jFiZgXC789ujQcJzWV6yI39ylMb6V6iQu7B/KDRFVfQG23/tVkW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/26 18:30, Lorenzo Stoakes (ARM) wrote:
> secretmem accounts folios by treating memory as if it were mlock()'d and
> thus limited by the RLIMIT_MEMLOCK limit.
> 
> However the folios are unevictable and remain so until the inode is
> evicted, eliminating usual mlock() semantics - mapping folios then
> unmapping them does not clear their unevictable state, since it depends on
> AS_UNEVICTABLE, not PG_mlocked.
> 
> A user can therefore easily work around the RLIMIT_MEMLOCK limit - simply
> map then unmap and VmLck no longer counts the secretmem range. Worse,
> folios are not accounted in the process's RSS, meaning the OOM killer won't
> know to kill the process.
> 
> Repeatedly mapping/unmapping (or forking) can then result in the
> consumption of all available system memory with unevictable folios and
> cause system instability.
> 
> A secretmem fd can be passed between processes and over fork so a
> per-process limit simply does not make sense, so follow the precedent set
> by io_uring, perf, skbuff, iommufd and xdp by tracking the number of locked
> pages in user_struct->locked_vm.
> 
> Since the scope tracked is actually inode lifetime, the RLIMIT_MEMLOCK
> applies per-user not per-process, so it doesn't make sense to bypass for
> users with CAP_IPC_LOCK, therefore remove this bypass.
> 
> There is simply no reason to carry on marking the mapping as mlock()'d
> since it's misleading and the lifecycle is now correctly handled, so remove
> this too.
> 
> Note that secretmem does not support any form of truncation (including hole
> punching) and the folios are unreclaimable, so the folios need only be
> accounted on fault and unaccounted on inode destruction.
> 
> __secretmem_account_pages() is more or less a duplicate of the code that
> io_uring etc. use, but since this is a bug fix that needs backporting,
> defer any de-duplication efforts to a follow-up.
> 
> test_mlock_limit() asserts mlock_future_ok() on mmap(), however this has
> been removed, so remove the test altogether for the fix. A new test will be
> sent separately for upstream.
> 
> Reported-by: Daehyeon Ko <4ncienth@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/20260813225328.2010303-1-4ncienth@gmail.com/
> Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
> Cc: stable@vger.kernel.org
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

LGTM thanks

-- 
Cheers,

David

