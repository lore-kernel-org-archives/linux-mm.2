Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC6160A381A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dNl8kU2Z
Received: by kanga.kvack.org (Postfix)
	id C4F9E6B05C2; Mon,  2 Nov 2026 06:22:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C000C6B05C3; Mon,  2 Nov 2026 06:22:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1566B05C4; Mon,  2 Nov 2026 06:22:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A3966B05C2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:22:40 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2BF4C40CDB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:40 +0000 (UTC)
X-FDA: 85389941280.28.032F4A5
Received: from mta1.migadu.com (out-148.mta1.migadu.com [95.215.58.148])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7CA0F180009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dNl8kU2Z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.148 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlYYUg5m282yLIStEKkIHTozLzxeQHV9wO/ECVNrg9o=;
	b=qGvKIqLqHn3ZbtnH2BtUaH9gDpJcNB8gG75ln/NLRwBrOmTyctJQyEn4GxB9QNxr0JqzHD
	fyWP+A8MHqRjjhxQtfJ8nitiLAHMjXEQCM+Nkp9i8QkY8rvZgozEPT+OKT1T/M6QeirPrC
	UdAYin6l6pFRnHHdveXMDHW2HjMNMmA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dNl8kU2Z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.148 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618558;
	b=UyAreaKUfAIOf497sNht8CqOPghGEaDAnzXxX+HRD5hxctE/WB4f+aYkEmreFnnsnKxNkD
	rdG0bnOK3MJs/S/dBfZd2pgNoGwfk8eVIB1AYuOsai+8xJwFWwiqK02uVKINiBpvU2Y9J3
	VwcN+RexijOQVR9B2JJW8ldCywVKaQo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rlYYUg5m282yLIStEKkIHTozLzxeQHV9wO/ECVNrg9o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793618553; v=1; x=1794223353;
 b=dNl8kU2ZZnY7p+1AZb5FkPRPxnYNE0pNnRkYzfMXhsQ6nzU8z5o/GWyH69JI2jndGu8pOXov
 iCXfD2V18rj7VtN0dm54SEJgnoT8r9LSk12pObDE1JIpBZph6bgTHoxZAQEPzv45DOvyDH48795
 PK/VAB0uVps+jfwrxgnpYmZo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0a735c2090dc6b54;
	Mon, 02 Nov 2026 11:22:32 +0000
X-Mizu-Trace-ID: 0a735c2090dc6b54
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kees@kernel.org,
	peterz@infradead.org,
	jannh@google.com,
	pfalcato@suse.de,
	hughd@google.com,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	riel@surriel.com,
	harry@kernel.org,
	apopple@nvidia.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	osalvador@suse.de,
	minchan@kernel.org,
	muchun.song@linux.dev,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	youngjun.park@lge.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	jgg@ziepe.ca,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	mason@kernel.org,
	stable@vger.kernel.org,
	skhawaja@google.com,
	usama.anjum@arm.com
Subject: Re: [PATCH v3 20/47] mm/gup: fix clearing folios in memfd_pin_folios()
Date: Mon,  2 Nov 2026 19:22:27 +0800
Message-ID: <20261102112227.62593-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261031-fixes_core-v3-20-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-20-d6437171ecc3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7CA0F180009
X-Stat-Signature: y9gnbhtstfdrfq7xwdmx67xboscwsygs
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793618556-376630
X-HE-Meta: U2FsdGVkX1+hRWKeaV82U5BqXW9hJZ0QvRWplPiarLt8YG01LqqNpdIuXm3Tq5/z4+L0Qv7GBDNSOumBLEB0auyfVnfXLvdxuJrK7WiWKw6tULvDFhed3jymKEZFaMFM8zRHybmJoHf1kuQdGXUCh0tQdoXIH13EqToUg4+qoOyhqqxE0mUAhg+LXBNY2kQ8fL6A6wzXuZebF7mTrgIePvdoCbYWeg8PURNR33dNlVwl3mqa2xkxaWV1Ld5oyrVbSamDs6M/pA+mZR4WUidHU6h3oD03Euc6SJzlVOA1fbE5Ve+ZzOUlI7GscI5VGJN0e5CaceA5OxXkYc6JbvOzTp3HtJkSVvrgOQk0VORrajdWjruHdvxfl6LQ0V511reCmWEp+mmOP0CM70vX+6UsuQ8N+V5rtmpph4F1FmFg4jMYu0b7dpucfXe7V4ROUF/w9uonW1WOYDe0uALCGa7HMbIcjIk4sNwE5ZS2uepRnACpjKY60zOlGayw5YVyvuZGWJjxqiccA+khEe6j1KoFTtaFzr+yyXIrA0WNEPinq4csYj+c4lZjtDmlqKZaw5hyxySH6BaXD14txpCrvAbSYUA+DBKWAfcNc78+/a2DOEGNfbdDpRPovbQ5a58ovypF0hEV/2rwbKI9c9qzrjalLa+zI1n/dK8DiQCvyxWe72li8zbRH8rNvyj2R3PSRs8Xf+zR4W+aFbRLie3+tnZ6nBNBrib7ifCDJ8EqMOpH6vBk5u8rMRBmp0+hcMcO8APBQtOtISe+HPZ0pJ656IuG4kkgNWcbUh7ucM0p6nzZfGkMqKHxlbCJqYFs0I/undy44mt8r76Mvu3yhkxFuctOH6pB0mSzwu4nY6WzDJaIMhTAtIKA2peDBYmH+wGFmwVas072GG1HDiR208A6o74oIulry4CF88I94ID8Zlv3rV9xEqgjiJrq/JPJg6gyguuAJvfg+2XTTCvX78KeouA
 kcGaUWaj
 7AxV7IINdqUL8ar4y27rMkhkSkgktC0S0NbFFpCdj38A55rUsNU6iY9LL6WZgY9wQS5UuR0y371w8bDDifOesOJO5dwkP7ZnQ54QOHr+JdP+9FJScxZ8lrMUvUTVwRy5HnZo84bxoqn7QnrPFqr2vt6hR4qFbktVtj+iMPzW6EizZbckoYe0czc40Mu8Sfrm41D+TZLT7elmCdazpBOPHx1/EUyQeQw6jZaWadZ55awcW0oL9y4DBsrtJFxkkqJr6IoDhFaM9sl0OIv2hlH05QI2yXdwsjc4ewsXJEbPOR4E3MAhdQJMjvAOpJAowpZfQSbQsWe0wqmgevfTDMrYksBcbt9dprP1JRlnj1gdHcuEC9yPlnWo+xyt6LdRQh7mo7Cc1ffEz6CxYpt4nxqMY67F+u/D5DnKxMd1/8ZTLxFw0qLXQmei3bGCRrQHxCJJHbYDop9WZXj25cxbPTsAXHF05ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Oct 31, 2026 at 10:39:49AM +0100, David Hildenbrand (Arm) wrote:
>From: Chris Mason <mason@kernel.org>
>
>memfd_pin_folios() pins folios obtained directly from the page cache
>without checking whether they are uptodate. However, shmem fallocate()
>can leave newly allocated folios uncleared and not uptodate. Callers
>such as udmabuf can then expose uninitialized memory to userspace.

Right, just make sure the folios are initialized before handing them to
callers. They shouldn't have to care whether shmem deferred the clearing ;)

>Clear non-uptodate folios and mark them uptodate under the folio lock
>before returning them to the caller.
>
>Fix generated by an LLM and sent by Chris Mason in private.
>
>Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
>Cc: stable@vger.kernel.org
>Signed-off-by: Chris Mason <mason@kernel.org>
>[ david: simplify description and comment ]
>Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
>Tested-by: Samiullah Khawaja <skhawaja@google.com>
>Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

