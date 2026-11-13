Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B79607105D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cFHMfohK
Received: by kanga.kvack.org (Postfix)
	id 1B8756B05EC; Fri, 13 Nov 2026 13:58:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189786B05ED; Fri, 13 Nov 2026 13:58:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 078DD6B05EE; Fri, 13 Nov 2026 13:58:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF58C6B05EC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:58:22 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 130ABC0178
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:58:22 +0000 (UTC)
X-FDA: 85431006444.19.AC0DFBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4CB9140004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:58:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cFHMfohK;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=plduXl+R6cqY32R5PgJwlwqrejdYEcZNDX1tD+foFH4=;
	b=1JjdFAmIQRUt/i3trLXEXrt4cS5JNCRQkYENOOSGjTukP7tx+7P3rmQcmWI+1APjRWOKrL
	5rC+RyLdo657ftIWlBrBKaadkr71IBu/NVs6Uprx3Xmij7J7pknLJJdhm+3gTaxftUKtVM
	1OJJYaz6jXMFIoh/UGSxf2WArEb+Fwc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596300;
	b=g290rCf1s/wvO86s7A9cdiezuY7bCHcSraDoLyhQ8Sxh5E7lliquHpJNThkVxMSIN3rrrN
	2l3RifOTbGm+HqQUWdfLMF6pQbFWCzf1+lc2xu/KdGJhK/eQYO1gbVrqUTpZeDbzXmGSP4
	McJp97wNddg3wuEYIynpTdeV+xjHPak=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cFHMfohK;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6A8C623FB;
	Fri, 13 Nov 2026 18:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A6C1F000C4;
	Fri, 13 Nov 2026 18:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596299;
	bh=plduXl+R6cqY32R5PgJwlwqrejdYEcZNDX1tD+foFH4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cFHMfohKIP9bZkMX3RyFr/Ll4R+czW78WJbfwmAUJfkYxKrc3F5eycBDUkXneLE5J
	 zLmy7f4T3SKuWAbJfOjW4wASWun1i2hpcPsSRgg6sNBUSxm7CxmKMEGeUPM1hXAMIH
	 3GKF4t/5yePvyYKMcZlLAbEjrBlxqOByEOlVcR5r7Uvpv4RTQO4oZnVFlQUkxtsBTt
	 Qanw4sSGu2xtFHluqWwh/ghF1SF7encSXNNqYrl7JksRhjnMYE4wNSfAafURUA57/X
	 GrydL0T9XVbUhYn6/7nrHwJRG8DZESnJdoN6m6Bg1l6eWdIuolgbk3ZPEpxgXtYvEL
	 husZdF7uzgD7Q==
Message-ID: <136002e1-646d-4607-be3f-b6a6a869bbec@kernel.org>
Date: Fri, 13 Nov 2026 19:58:08 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] mm/huge_memory: honor MM_CP_TRY_CHANGE_WRITABLE in
 change_huge_pud()
To: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, kvm@vger.kernel.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-riscv@lists.infradead.org, seanjc@google.com, pbonzini@redhat.com,
 akpm@linux-foundation.org, peterx@redhat.com, ljs@kernel.org,
 imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>
References: <20261112142039.907090-2-clopez@suse.de>
 <20261112142039.907090-5-clopez@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261112142039.907090-5-clopez@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4CB9140004
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: p95sy5y8d94smn953kchc8ahmu9f9s1m
X-Rspam-User: 
X-HE-Tag: 1794596300-177628
X-HE-Meta: U2FsdGVkX1+Wb2OPd7r2aZe8fHA1XjPsbKkxYXAX6BUMIseCeuzys+XBZPJ8T4xzmJ/y9cVZPoLItwf1GLVDDNG9KvZ8miMc9VVYU1xjy6Fae3E2/8KYxN0hDwpvyBdkLVhYD941F7e37gduyornDZtNyfjHTrOhuMhlIJcP0J6VbA/plhFrxDLhT5tMi4UfiaYSFdvS5QPA+QJeFPz+CK6nQUsmj854URUu2ByZOaMf5NvenjC77ZV/KoA1jfzRYYUq+X8V2PKvgatUuTpFHsP30M/j9/U4QQa2Ds9kKfnsLE60PI9FL1mhz7vddwCTVPU6T/+oKAlODwaENF0KdhL0n45uGr2uSAxZuletz9IipAJwdEDuQWkmzPewURvWg6y00XQ3LF83LMYuHHMBBkTaLoe3t+YQnwIXjUDtLjHl3VvoXBZOKlEh6St23OqRzksQJv5kBraNu4bP32+rzTvwVw1XG8EWUVMm3lIi8r0Hm4UCkQDqioKeAwJFzgdFzh05fDE9kvGXSfSdabA3iA5SGAPtla6d6uMU/i/xB27+K75za9d3ihfCaARyY1ivm54r9wySVXqXXdsI5JyBYJmoZVi8V65P83ieF3A6jz+YQrIMBzRbkoopo4mrV0m047pakC2rE9T0avFqzd/QhbUxDVzNahyVg8+jfuozFJ0/4U/bUd73oehF9zOr6su8OlXMmufWbS0MQ7Orc4ZfTyyhIv0Icb8szIZruA+GB4ifvWkHfmu8KFOUfl+jXFWMWX+rF/XGtgtmlEgAU2m4xP1AczvBplIVIR46CRYFJRzLzzwmrMc6ftKUR0ZLaTm2s8D+ZE5X+JtAr9qZqAWsyZSBSA9YC/mXO8fFGBvhzJg0grLgA3bQlGAnnT7IrK4uizDUBX4PSHgbiBQ29EytEt9eJtRao2yru++SZulHXUNvM1mCLGRrLL0mOyAsmxUZJf90wP/SUmHRWotgxd2
 Q/aVt0sB
 7MCmLI9XnyfKdN2hKLI9qbWgtGZROhuRhZu5BswbS4xd1Ilxm+ueW1BjgvRphxj6a47XuYHfPvJlg2O7WxMCbOfTNKPtTDJdBzGa4bu5X5aFlLWq7476eAXW3YvXXHTZ7jXwAZx5vKbDjxLiA125D+c7Zv+997M3BaBJBYc5JNzffQ8IJ1At4Lz6WldkahgWnlw9zHmqXqKLP+RyFfN0hc3qRrGuCdyy1yQ6Re9IjeU2g6mjpjeFxAM0L8pCGVnDHkkWZ9y2meCtINjgtUlExcX44YqyzyOIc4FO8Urj6obEmqjO+8TzFAdVTHYkS6DY2R//aSNo/Qijn/mQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 15:20, Carlos López wrote:
> change_protection() applies vma->vm_page_prot, which lacks the write bit
> for CoW and write-notified mappings. MM_CP_TRY_CHANGE_WRITABLE makes
> entries writable again if a write fault would only set the write bit.
> 
> However, change_huge_pud() ignores the flag. For example, device DAX
> mappings are write-notified once soft-dirty tracking is armed through
> /proc/pid/clear_refs, and a protection change then leaves dirty PUDs
> read-only, so the next write to each of them faults.
> 
> Fix this by adding can_change_pud_writable(), based on
> can_change_pmd_writable(). It omits the NUMA and uffd-wp checks, as
> change_huge_pud() bails out on those changes.

Again, please keep MM changes to a bare minimum for your work.

If this is not required for your work, please drop it.

-- 
Cheers,

David

