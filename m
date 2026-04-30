Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E66E1FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57F26B0088; Thu, 30 Apr 2026 12:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2E576B008A; Thu, 30 Apr 2026 12:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45626B008C; Thu, 30 Apr 2026 12:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0EF16B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:16:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C8F61270EB
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:04:26 +0000 (UTC)
X-FDA: 84715543332.12.672CFD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B48EA0017
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:04:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qB3bjfQ0;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777561464; a=rsa-sha256;
	cv=none;
	b=d2d0n3p0ZPnut/iFnigVigPAQv3apLvpEEkFIiwxAky/E0md1spAyqZwTrxF2X48eBW9jK
	jrY6rejrzeg8ld+tC1fmInDmul6LvCYgGkR2bArwnNmnRvGkENtcRORtZabIxInfZKRL/q
	mE6XWmZJ0ojbPFlXrdxX+LkD1Ls+40I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qB3bjfQ0;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777561464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PuFT8PznD3oZL+h6zh/YmyaAdPxjqm1lCU9/tnSkZ3w=;
	b=fqa532xZQ6g4NT3d73SNc3i4UUIvzEpn4RuRviA5iK79GzbWaVeXed76mQx4rqnq2II3MF
	HFJuXvlCKZtQ6TfzEGo6u+QpMr8YjYIDjjrDKRCB8IIlIbuFILVWyVsLo2HJ6WI920p6uV
	XkiDfBnQpOrUk8fwXkG/1I0qz5uB3ls=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3458760582;
	Thu, 30 Apr 2026 15:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F30C2BCB3;
	Thu, 30 Apr 2026 15:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777561462;
	bh=DPoNqejj7L+Qi9qzpFKoImHPM8d005RnQS3YCCnbqjM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qB3bjfQ03/ociA0V93GPGwkYzdmJ2oXxS3aBuCq3uttB8MlXl9/nCBLKxPuSOayon
	 vCH6Wu3MDdLDNfpfk6pkp2YsXoJPWKYByBXQ99a3w6f6/yx48O04urQTxCBnvZ+0oN
	 6VE5InbibO8ND/EcmXHJ2X/Mwnd0XUKBk9VfhxHo=
Date: Thu, 30 Apr 2026 08:04:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason
 <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v5 01/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
Message-Id: <20260430080421.902b8e38df2a3b79421396bf@linux-foundation.org>
In-Reply-To: <4C10A739-4931-4922-B2C2-245A610C0120@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
	<20260429152924.727124-2-ziy@nvidia.com>
	<4C10A739-4931-4922-B2C2-245A610C0120@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z5bzbf8hc81zwezbh9138okeqbbky8ij
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B48EA0017
X-Rspamd-Server: rspam07
X-HE-Tag: 1777561463-701195
X-HE-Meta: U2FsdGVkX18JLe2KWzGQpdM/niBGWuU4DI3XLA4EXokjf5i3jDyfu76Fy/AeabydZpna+A0M5EGWTw40RwkcrZfMW9TwtSjrmsQi6QNc5p888lVAeOKJqJbJV9bgJlsScjDzaAXL3ON9l+crcs8Ajp3Re1ykWaRsEh66pZyTzqoIayBhuDa+nG2I2bQDg3+GhJQsHg9NUzlzbxJhvqu9seUOCtLRUk3oLT9nlwqa+r7dgwPHk8SrQfU1tzjZcH73hAKWlXKbktfiEeAVRwjJDi2iMSEdp/kux5Joom3BZdPWts9fFzTAon2c1Z4RmPTMrAjGLHsxhoxwZtGNxVti5XlglB3awQu0pbrFMZkjhwOXEcw3ThKqnue4F7dwK0dGthn0CPsiU1091C63fFI5/Zkhm4KWVRloNsuIYhuLWKi02aAtAMOIk/1ypjtzLF8oqGIRZ62Dz9gs46FUdgyqYJMYmOK04b2EO5JKoykCSLfDjfLa1y6ftxqEflSNxPSRqRfKQvuGEuyupbKFMcrXPR0g82fUe2v6/XTpTDBrhugE5j7mrNx8TvIDeGZ8pSpwl4th1L9gqho2nb6fnS3VdHa5pwhb29NaJShxpcbDYwyfKsJxKVEA0W7TGqOl6fBdkI5xkj5C1u8QelXZgg2Kfp9Y1XW3Ch6wc9HRbRMTSIGtSFC3L5JNqIILkZEwIMw+HrLHpMNhU05kpHxhA2zZWvE6bcnNjsAL5yHhFskGw+cM72VDRHcKCSMNiHhWE8h1nIZGentcMbSeMFKI/XjzxgOL5m/YSzV4NjJavui3+bzD172sUs8n6y5+GV8LONCT0BT8kgeGbf26qcyvzS+XB2a4TeUXbAHcuZO11jzCzIWZlsNBmcRrpt/bxFX4HjzPmM8DssCyUHf9odPBmRTz8JPdm0OCFhymmOnU+lk7qvsZUwVqBG5g9m6UYTlMgjDq6N6v9nhutlqNrrt0o1h
 Kw+UGhZx
 v6e5bMYriQvLu+27IWy/hkwcR22HyzRBcp+8yNBwyDRgKlfvkGjAjZoQ209Hir5HfubTeBd7T557xDuZlxy7h5iBKyLGBLWw3Z2L7GrE5ucoRvDN6Aw4UTyTrxb8E3eT0+t1h2AlNjrYc0fxKp9Rudswv/t4HK49nQWt99SZT8whlgbQAJe6XMqj+NoalZmVvxv3zmQittrICT2VH93HkSGZz/mnpPLv+xuDMCFIDNRiHX7d0ssOASM+hKoM6bn7dmPKWPBHLcI32fJY49fYmAi9uXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 10:37:52 -0400 Zi Yan <ziy@nvidia.com> wrote:

>  +	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
> > +	 *
> > +	 * TODO: once shmem always calls mapping_set_large_folios() on its
> > +	 * mapping, the shmem check can be removed.
> > +	 */
> > +	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
> 
> sashiko asked:
> Is it possible for userspace to intentionally trigger this warning via
> madvise(MADV_COLLAPSE) on an unsupported read-only file? Although in
> a later commit, modified file_thp_enabled() will prevent this.
> 
> Answer:
> It is possible when CONFIG_READ_ONLY_THP_FOR_FS is enabled, but it is
> unlikely a kernel will be shipped at this exact commit.

Yeah, let's not worry about minor bisection holes.

