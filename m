Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46A0606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 15:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OwJnxig3
Received: by kanga.kvack.org (Postfix)
	id 0D5076B00EF; Wed,  4 Nov 2026 10:01:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086766B05B5; Wed,  4 Nov 2026 10:01:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB7DE6B05BA; Wed,  4 Nov 2026 10:01:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7DD66B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:01:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5005FC079D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:01:31 +0000 (UTC)
X-FDA: 85397750382.24.21C1654
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 760B6100016
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:01:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OwJnxig3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793804488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YxOPHeBFVzKRVOWsijIHFAGxsh3bvwNNvRfegWSMFo=;
	b=0k6BptPZsJP+tsSeL8L77CigA+iO2EQG7vezz7diEM4/naYZbkHq7HdLbvBW3R/t9aK/IC
	gffZXbhdE9yDjCSg2lJ8oWDzAG72qUxiB3WVGPeb+hT/cxqtm22mtvggeBgjeysv2V5VPm
	bVo0eE1yjBfgM1RLEpmlheZDEunWVjg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OwJnxig3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793804488;
	b=rIp0nghcD0wxTDdlL9SkD68Ojgc9X2KbMqS7NjQVuqav+uepYBmkUa6SAgI1DGsfCzUYDA
	wGIp0Ju3JmNn2F0AuRm3TjbuhtyNQOVg8Xcjdi5uQrPcqvZIsxP15nqRslLjuuXoXA2uuC
	cwB9O8giG71OIDYbvUrig9ZayZFtJVE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7AE760546;
	Wed,  4 Nov 2026 15:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76AF1F0093A;
	Wed,  4 Nov 2026 15:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804487;
	bh=6YxOPHeBFVzKRVOWsijIHFAGxsh3bvwNNvRfegWSMFo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=OwJnxig3rfoGKDzHfgnzBO3NMi8sr2bi7nZPcIXsVfqDqD2ml4RCvESVjw64EXsZy
	 0Iq0Rveie9/lMNePvdQHltK6+H2sKsmqZo/VM8NHEF1vn0ybRJsZeSpdeNVHnfYK9I
	 9JSalFL53Wpknx1cYHqboIWo9jjPjXzonHiRjCgG23CusXijz7xRveiT4cnAjU9Yc6
	 0GnKo5RyD3TENvFcCjOcQWx53fWl25tXPxDWbTew6D7VkfDMp+7jSrhY5l+qRtjJJ7
	 eMAeeBXN2mLzMiJ8zChNdFZCpdrJH2V2dbL3LkaeTJ4ePFuK4SZctGZZtlmPPCnOTn
	 aEEiOhq83RuYQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Christian Brauner <brauner@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Hugh Dickins <hughd@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 06/10] mm/shmem_luo: Don't make early retrieve
 failures permanent
In-Reply-To: <20261103010216.3447716-7-dmatlack@google.com> (David Matlack's
	message of "Tue, 3 Nov 2026 01:02:12 +0000")
References: <20261103010216.3447716-1-dmatlack@google.com>
	<20261103010216.3447716-7-dmatlack@google.com>
Date: Wed, 04 Nov 2026 16:01:22 +0100
Message-ID: <2vxzik2ck5dp.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 760B6100016
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: pyr48piyt1wfur3xkfgugr89fsbcgbex
X-HE-Tag: 1793804488-334246
X-HE-Meta: U2FsdGVkX1/3xCUMWDFmfFz9E+uo9tZ2EVubXQuuE7RK2T/fkud3aeDmLFtpmz7lzRD89uLsKI0JfdThikgJ+oLl6HRneGSMHOuPYQiPMM59cIUqor1rYpO2DIpvxJTZsavC4od0YJXW1kBW/jfMF/2M/9PKQY86Zd1GU8KmxnnxIKasjxlFtyYjxw6J9fQtSEkEG14paLKzLCe0BT14HpWU0BFTzxl/8mo4nmrBqKCbqA1wLe8z5BViTZ9vdNDM1BGhvzU+aK0xm4fPwLYkgADmOtmN2krQPaG6exSsFN3kAw4njqgG4ZYP3+d/8QY7PvEmczLGBpy5IaaZLcyC6v5rq1fhOseGPbfj76B/8Nq+jXtEGSLCALrrKEbeX8XJGBfQHZMoxHA5TRfxxVaWj7AxeGxKofdrevWg0Mw/W1t2Z69ncDlg4GUgzKJZrJvqp/p3oMY/slb4UEfI9etSYsHQQisQxO3Q9SJuYDU9Fz0+z83kS6t8lTxw39lH6kxNX859IXpGVj3R7DCKQL8hFjdpe+B3MBVwMEUHXS/LDWqAnmSAeJfrV/aljZxrpBbXCHxjtDrVsZEtvzeqRS6a7lqkx4yKF3/4QyOBd+6T198LvsgRcXVKljONTIkK/Ll9K+3EcEA8WcMu9KJ8AJWtYJb6bOMP2KwZPbRBIaAGcXGPW6XMxqENJ8CFsc3gN48Be4UgXYOhAlxtQ58B1Z7KlbeGCn7nCcp53gvDQoYWUB39xNu2+CYdS6A49ofw1CFBgEwUhqciA9lZL/2A5EVm8EmNWf/UWdln7jGl4/AIFQ/cK36D2nvy0uuy+QL6p/2xoIhlV8XZP7vm0adBHv0nAPOEs79VRrkElAEQlkJUOe5K1fuBu4NG3JI4ugMSBHtlplT93FbGBYj+23gJEUIpadLl981YD7PDSeNxx/CYD2nRbN73aEpc8Cxd7QIrYOfoasyzMWzkEPqeR3QPbLs
 ZfUZV173
 Ai7XlXPTIslSJJMbEH7PZ3cHp7VTHRhZ0H4aIdSMD/OjjlBDKpXS6CsQaqgd8kQ59KysaXbr8CYVDqayDup6P+K6ByKMSxa+C0gj5ER2nn8rWvbt2Y6FABVqzT5s+HXS5iKyOi76hkQxe6vVV55nys9z8+LIEtv4HvYGeHmddMguYuHgPUmtLQdk9NtdQ5sRbtlfIyBp1vNr2GIC5DHSSsJRloSiy/E6PQ2hung+nTS/jIWJrzhcaXNmaSP+HutgkNs/c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03 2026, David Matlack wrote:

> Mark failures in shmem_luo_retrieve() before it starts restoring the
> folios as retryable, and return the error without freeing the serialized
> state. If no retrieve succeeds, finish() frees the preserved folios,
> like it does for a file that was never retrieved.
>
> Nothing has consumed the preserved state before the folios are
> restored, so the retrieve can be tried again.
>
> This also fixes leaking the preserved folios when one of these early
> steps fails, e.g. because the file has seals that this kernel doesn't
> support. The retrieve freed the serialized state but not the folios, and
> finish() then skipped the file because its retrieve had failed. There is
> no Fixes tag, since the fix relies on args->retryable, which was only
> added earlier in this series.

If the seals don't match, the retrieve is not retryable. It will always
fail.

I think the only retriable part is memfd_alloc_file(), although even
that is quite unlikely to fail. But I think that also fits pretty well
with the most important type of error you want to retry on, which is bad
arguments. In later patches, you check the argument on
shmem_luo_create_tmpfs_file() or shmem_luo_create_memfd(), so perhaps
set retriable in those functions?

[...]

-- 
Regards,
Pratyush Yadav

