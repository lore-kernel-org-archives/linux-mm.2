Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1E76606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=K82No4gD
Received: by kanga.kvack.org (Postfix)
	id 114E66B05B0; Sun,  8 Nov 2026 04:23:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09F986B05B1; Sun,  8 Nov 2026 04:23:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8E76B05B2; Sun,  8 Nov 2026 04:23:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4DBA6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:23:27 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 551D3160421
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:23:27 +0000 (UTC)
X-FDA: 85411413654.14.748DFF6
Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	by imf11.hostedemail.com (Postfix) with ESMTP id A687240002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:23:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K82No4gD;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794129804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5XXct/mS8QSJCzfaXHvfDvD/GjABqbPTOqaOMdXOtqQ=;
	b=E83kUapjOmyUlb+srXyotQ6oFHz5IJBwowdkYHe8r1jgVg19mhyAQgwGv9OVyl89g4mavr
	Xumj4tmJSF87UQrmsIpX4sV8bLlF7OFcqMlOq+lIeRVjNmQH6wB1nvwefodVIROGRiHBz0
	WWbXnKz+5KBwuOI4Ci+QzMdbjhG0RUo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794129804;
	b=cU08E7aJFg/vjwHF2IIraAkKhTCCHaZO2c59eo+SGmqnqMXX/iRfspuGnqNBaAzIjwiZS0
	j2Woq8tt+1NugVNTPf//BkRe8andy9rt+R2rM+1YoBMhSRuN72hiN/iYF2E0OABGU7m5A8
	tRZSh4u+XhsHy+dVjPwFCAfbhRbWAjU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K82No4gD;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5XXct/mS8QSJCzfaXHvfDvD/GjABqbPTOqaOMdXOtqQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794129802; v=1; x=1794734602;
 b=K82No4gD/U0EDL8G5b0U3E/LJ/m2ZvtIurq4uACX0LgP99VkFG0/tl/mLp9yB/4+LZc8Oqyx
 y91WHpBUYPqB+EC56RlWaLqSTWEwxtt9cN3p4O9UVS6Ss8cvT+MH9gSuujZ94cxLHGxpsZP3usU
 bGtGN4oEaj5k9niDGR5r6uZ0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fe3ad667d8daeff1;
	Sun, 08 Nov 2026 09:23:22 +0000
X-Mizu-Trace-ID: fe3ad667d8daeff1
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	qi.zheng@linux.dev,
	hughd@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm: don't allocate a page table under RCU in do_set_pmd()
Date: Sun,  8 Nov 2026 17:23:15 +0800
Message-ID: <20261108092315.89639-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261106-khugepaged_set_pmd-v2-2-d2457b5e377a@kernel.org>
References: <20261106-khugepaged_set_pmd-v2-2-d2457b5e377a@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 8zx1yak6kyqm1iaiuizdindzdxprbfy6
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A687240002
X-Rspam-User: 
X-HE-Tag: 1794129803-638556
X-HE-Meta: U2FsdGVkX1/bjkfaDOdX8g55Rlf/ODdMuNHVpoAC+WM2ZfVIrnusnRxWnh2dt+BPddWaqb0x6FOzTlbE7s9WX4eZ6HbZ1R/ptLInZV5KidkJ145oCa3xxoQOczEKo/bvwtGVhS/KqsGp1A1FMYMIjRZ0wRwxLrZRN3i0sl0kF6JT2d6Lgz74Y8y3SAlL2H1k2sQ1Q9moVt1rucjlcYTWZ/0V3iysSvQjYFOqKXGpdQZGfhGFK4hZMkTGlR+bod0ijewQAdwQf3mZYvNl0FhYKUUFw8buF8ON9KtNVsrRDW+pZj24s2FXpba9VOtXGfuSfcAB4sxeyUkH0h4W1WKcZidZ/4sV3GDmTG17pmcYBY16ZI0fu3p6lAW+tHbEuy8NsUlregguS9cMlaHz04F0CmP8ROrIk1pmzt5jh400tq9y8b1lcYpV1d8NM2OyLQMdLqbNM/1KjaoBtzq7Yf3wITky0Ztke083hrWrjO+CgBDmXeKfdsMNLBdY+NFenCtkRK8dAXpf7p1wd0ln/KxZ8wW2KR05Z9Zqmh/2iD90jPkeYhIOqrwdC95/w+BLlOVdUa1axp3osaa9pB3roliNYvBXRWsBzzE9H35Bbkfm10YPf2jaoc/9imrcyK6tXGQINI+WBlIngQtQctSKGOmhtGa7yltbuTlS04dllwsY/ZlZxPaMcJP51AX/rSJy8A2kfxTB0oLX/5OsPCiVcy0QU+hUgpanmxxCm+imUV7dLJ7Nmtbq5Mka+URD6Orz1CQdbSgQrkihtcyif5B41mh6O/oXMkINxG6QOcOQRc0xktsfK56E5i0XTKC5jlzlea9Xbl5/1JXFsbw1bFknSR+rc2EXvJGyJxi73b4oyg9hkvAJCIT0xHIgRJvtPZbzJE6EIyq2Zf+pQYtkXwLr5Oq9aVyfJA+Tzp0iZ0pKHHVTf+dpr6iHQ9Je90xcqpBnUxxZS7YBixwSEmT2K3NRqrN
 5doT7S5A
 FcKp5F+MVwBfUAtLfzSDXau6TIbeZDEuCKqq6SKJZvHkpd8lC3Mqkha095qbo0z86B4r/u9J3MUo0NPpCiiFyY8lkhIt/gFYsBHzPJV/yUiUpy690dOcudQ2B6Xz+/B4p+ec9EU9Ut1wvgXSpHzGieOoSjQmvm080C/AT1FcMsO43rr6HnEFuS7Ev+DxCcQTo3C79URU+bfrHjUtNj6FEzOMFaJknhA1oVmuRvc5DFQZrMg6XnyAOkw6FcqOoz230J02m8sFicDUs2BbPW7LJwk1NM4hZ74nvgEWj7Ef+XU0cNyLA00hLdv+83Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Fri, Nov 06, 2026 at 01:36:13PM +0100, David Hildenbrand (Arm) wrote:
>do_fault_around() skips PTE table preallocation when the PMD already points
>to a PTE table. A concurrent collapse can then retract that table and
>clear the PMD before filemap_map_pages() locks the new PMD-sized folio.

Right, having a PTE table when we check in do_fault_around() doesn't mean
it'll still be there later ;)

>filemap_map_pmd() can then call do_set_pmd() with an empty PMD and no
>preallocated table. On PowerPC hash MMU, do_set_pmd() then tries
>allocating a PTE table to deposit. But filemap_map_pmd() calls
>do_set_pmd() under RCU, so allocating from that context is not good.
>
>This race became possible when retract_page_tables() stopped taking the
>mmap and VMA locks. Previously, those locks excluded retraction while
>the fault was in progress.
>
>Add a may_alloc argument to do_set_pmd() and pass false from
>filemap_map_pmd(), so we can fail with VM_FAULT_FALLBACK instead of
>trying to allocate.

YES, just fall back and let the regular fault handling take over after
leaving RCU.

>This issue should be fairly hard to hit in practice.
>
>Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

LGTM1

Reviewed-by: Lance Yang <lance.yang@linux.dev>

Cheers, Lance

