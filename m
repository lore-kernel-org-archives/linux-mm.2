Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42926606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 05:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=C+vG9SFB
Received: by kanga.kvack.org (Postfix)
	id 3FAA76B05F5; Wed, 21 Oct 2026 01:40:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA4F6B05F6; Wed, 21 Oct 2026 01:40:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FF1C6B05F7; Wed, 21 Oct 2026 01:40:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 129A86B05F5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:40:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D763C047B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:40:42 +0000 (UTC)
X-FDA: 85345533924.01.E807D5C
Received: from mta0.migadu.com (out-139.mta0.migadu.com [91.218.175.139])
	by imf10.hostedemail.com (Postfix) with ESMTP id E52B0C0002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:40:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C+vG9SFB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.139 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792561240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MXiUGp1caAHyyuVtstCR/2L4nYD+n3m1gvu2wPtLXMI=;
	b=fbx7U0rPk+vUvDbhALGAENXKrUqaJYnXEWlmzVvTiued5KP1FPlk88TmPyML+jClf8Tv40
	4TM7euZctziNIK15iJJWpeEjnz7wYtfPSOyFoeluoclDdJm6SijHQ1d85kQZ3LwHX7UN+5
	2Oe0U0sltcDdWOhWDbnzn0w3aKIPjHY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C+vG9SFB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.139 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792561240;
	b=pynxpkra+OtcGwi/HBSsadSOiiEIdl4F0JNhRczZ3tVSczaxcFDPd+g6xXy1A0TPJw5zWR
	yV1hjP/mf4Hwmmj+Lp1buObGkcbTiqXzi8ORwwoKmcMesMj4nrUbgeWV+dTKFU+p5H2G2C
	3JXEfYAcMJz9tmM4vRY+KeWYSVjDZ9s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MXiUGp1caAHyyuVtstCR/2L4nYD+n3m1gvu2wPtLXMI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792561237; v=1; x=1793166037;
 b=C+vG9SFBdBQyzmPAziKyxgOkVqVFMKpFAz91RKnVqhXiTWdcCNqsz48DU9VR4qp/m0yzSUQV
 Ukar89XaW1+7SLsXgAbtzL1jRmim1TE67erPvFkI9qwWgjmSW5einQc4C9m+YgKG5Gw8xPPaM06
 EGYG7YWYbrPWjGGM4uejPjW4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d2fc8a9e32f8bec1;
	Wed, 21 Oct 2026 05:40:35 +0000
X-Mizu-Trace-ID: d2fc8a9e32f8bec1
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de,
	maddy@linux.ibm.com,
	corbet@lwn.net,
	muchun.song@linux.dev,
	lance.yang@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	qi.zheng@linux.dev,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] powerpc/mm: map shared vmemmap tail pages as read-only
Date: Wed, 21 Oct 2026 13:40:29 +0800
Message-ID: <20261021054029.98875-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261019090830.1917657-3-songmuchun@bytedance.com>
References: <20261019090830.1917657-3-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E52B0C0002
X-Stat-Signature: gizypr8u7gtzre4ukkukdefuwcap4gb3
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792561238-837932
X-HE-Meta: U2FsdGVkX1+rklGFCmG88FwrjIz4tPUjbxrshVSXn5UIq1F2fkPEx6y5xBK4tJxgqAarwq9/d4OevkVdw6RIBWp6dQxbMhaMZr6iT3hw4ufG5z2vPLz70svM1xSEbEOLDnIuZMyHFLNSbmX0IsS8agHkEguPmIx/trS1Zbw7vYdYxSxP6YGgouvB3S/hVKgAmmprUa0/FYbhX/PRl7bjNAjCRAudcCSqZU9Bgi2sM6/6nDH9xoOYKL1aK+5nsVDWCTTCSQMRGciORw7lQNeU2iVenwRX9UxSsr3FMOOE5L98FG1Q8g8O8vbNoHNdrsVHeGhmJHDvgrVDdvdIynAwtWFlZxhfUmX1RgVubQO0ED6R0uuagTxUXNhJVluTRK1xVcS19M2wOEiLw/njxrF720euuojl5tevaL7ooZbIkkBqAtB45HjTTvNGHFhozmHeajHHEHWJW7BL8WX/lWfmui+WIoZfVOdszWmmOdKsMsxNxFsy1ZyGeWCpxoW/+sBa5+oGSzzTFkGLdDr5295FocdE+8GeCGSfA1BrL0VLwzZm+fVCihZlcUjieOaqoCnT9+x9QedcaXi1mLEo3UhFzi4hqXp1xCYVdPTdeEdsCzQimWRtsEiQTgKPYImq7Y5BIugTh9EntOhvS+6w/Vx7REeoDKH/ZOnmx+ksrYRCPhTN4G/ixGNcEi0VFeWf/qrHQsrw/FxrCYRz2uR67zL47dR3fEsTpKByY/w5jbU776eeuMBs/Wue3/5EUP4MKJPtQ8ybvRVmGaIVxCvY4fiMHPOd7FcDk6ZZc4v5qGv1DDG7D+3iFgTyF2inxgQ3uOp0MccjV66YfeIXGn73lOEykEzYRKAizcLtBSe21ubaHJTQikUTHIzbooeeDN/c3YacU+/qtyOy+jfcggGGS7ypwrJhC2JLjdchNy5lvjsWmyh8bW9utqY2LrJZXWL0oyI7sCmbR7vpuzA5LJtnD5d
 QSkBFwB6
 sMNSB5GRqfP4cDK8JfldkjdPmQZNc9rrjcxmqVblXEXJAsetZ7NrTB3Ct9Ee6nHkGnptt2xcODVKyoY7VN2b8r5yNa4x4y1XAl0HXlpsb2aG4mWmczCTIpZcM/SlTqy5O/6ZIZ8njf8qSHvRQj61W66amSP/e8vh1qpD1QidW//YCJuRZGWTgrCiH0Lwz4AYF6d1wqaO3zv+CB9efkQiwgrw3Y5WhS61l0qBldUt5u2f7aQ/1nFPZMfMAEgetH5T2oK1ovc9dBBuq2tyo0O+hyWM765G28EbUb8TMK9AjiBKrrsZZe/7hSR0cAYRYpUzG4rNCfG0QoHIXHJw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Mon, Oct 19, 2026 at 05:08:28PM +0800, Muchun Song wrote:
>PowerPC radix uses an architecture-specific vmemmap population path for
>shared tail mappings, so it does not inherit the read-only protection added
>to the common path.
>
>Protect these mappings as well so illegal writes fault instead of
>corrupting metadata shared by multiple tail pages.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

Nothing jumped out at me, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

