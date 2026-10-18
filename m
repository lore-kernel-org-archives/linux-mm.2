Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7436BCCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 06:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 131486B0088; Sun, 18 Oct 2026 02:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBAB6B008C; Sun, 18 Oct 2026 02:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4196B0092; Sun, 18 Oct 2026 02:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C80EE6B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:22:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B968040489
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 06:22:45 +0000 (UTC)
X-FDA: 85334753490.12.7E45F8E
Received: from mta1.migadu.com (out-224.mta1.migadu.com [95.215.58.224])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9E64040007
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 06:22:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OsHCmT4y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.224 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792304564;
	b=k4tuKDcLC8IAKdg29Q+H5LlqAGM4+2JrpqYxHAITJBUL8TPoV0YgmwNJI9yz485PYcgYV6
	T4X93vOzI3Chp+1W477hmnQgrNN9zrzUunsStXYYSCjw8L7C3xtD0FSzCna5wfwVLsKcOb
	ZkPGLh/pwy0yTnQP5dJm7/lTf+30NWc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OsHCmT4y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.224 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792304564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5Dnhm6NG0TC7wQ45/nC5deJSj63hjDiiipgdq6joRs=;
	b=S/zOpL9clvLM85nr1AgA+B5xglofQueS79ooz7tErRCQerU5ef0oINOJRhApEonhZJKzzL
	dSNUjLHmvYzPqFY4uOxvcPHJvYe+A+jkWprp6gUBtoEjRVMnOMtRVZEwNfa2h3hC4xnSlK
	JHUtQ/069KV/SMOb/TF48nRbsYOtDC4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=L5Dnhm6NG0TC7wQ45/nC5deJSj63hjDiiipgdq6joRs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792304561; v=1; x=1792909361;
 b=OsHCmT4y/LajFmI0bK7LG2zgbrqRqa+ldNTsDcfgUbYxYYHDLVh5KAERwWpzGFekusOTShiS
 bgOyjNeY1r9LTv8EbaSHJolXmvehSG/DyoLfdzRZ+92zM1tT5zw+5jIXa1FHjRrFmipVxmdMoo2
 ceGX8Fs+qtXYggUpm/R+I9Tg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 582e136e2d86482f;
	Sun, 18 Oct 2026 06:22:41 +0000
X-Mizu-Trace-ID: 582e136e2d86482f
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	muchun.song@linux.dev,
	osalvador@suse.de,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	agl@us.ibm.com,
	mel@csn.ul.ie,
	riel@surriel.com,
	peterx@redhat.com,
	kas@kernel.org,
	rppt@kernel.org,
	josef@toxicpanda.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 03/10] mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()
Date: Sun, 18 Oct 2026 14:22:35 +0800
Message-ID: <20261018062235.15630-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261015-urgent_fixes-v1-3-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-3-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E64040007
X-Stat-Signature: tm7sygq177cjfgmewk4jrx8rfaqnrp63
X-HE-Tag: 1792304563-177565
X-HE-Meta: U2FsdGVkX18oN8i+rEZ98hRygrf8qPIwo6iqJMWsGIbk5g67lsgmD0KA/dG+F2hvcbdrWIX6SMNsBr7M1/Qfk2e6EriER14h80qjfwLTofHcJ76q+p0D2VE+q9boF18Y5FTyV++cLdTb/i8Y9PytU+g4ZeRjGI+F3793b1bFw1Beyz7bU8WbqBCjNFp2Mfhs5x00CXdEDviGtMv5Mh1d1ESMWXR+0mE0BF/hhPOhPkEcl6iRGN8Nmd8QgFQrDGkkOA8E6wIWDI+1VKdAn7TEZkfaIfUlydlx9wnNiZgr0eTOuQ97FSVSE4HJAM4l6S+DzIQN00d4KuzdhVyF4ehG8rjsQe2Bqdg4h2dT6MC+wnJLAoGmDDh7+9/40THSWOJi6Zu2R//RP97iNj+G5Uf6/rUpuxt3XuDNccbU3Ha7ntmrfIUqEwy4uXdo4Y9TuX5c565/Idvtn+CshHdvkfFAD0P1XisbKMG3OP6/13ZJGR0nyQMGxo4IRug7Ml/kXhBzedU071X1QrJPw7BiGpwF5aQrKO6ecn8ZvzbAH5r/X6KgjWNAIfrksr3/QuZQ/TExQ4dAZA7YBsmoPUpnAn+AHxAgoLl6SRkwAFaxEP1IB/LMtqEgUCsSwhJJTK815hiLrP7U4SPh4At0ssz4VEiBqEePolCWdPPrfmFm18lDMYKCsThnp6Qur1GRzAKPiEjeU2+phC9aCNkMBntSjLGmdn/8twp/keyzLBkqVMioZzEsJU8MDHeYberLUmuYn9PIGUX1y0u8kTjY2ST1ZWVwrgPEuAcszc4kVAAaTMRlH5hRSNWEKMFpjcClCFCUEv/ltBRwRV3S5vrVVAQGxVbz2bbCEw+sAKLMQkaTK5JBLOXTaf59DwMlaICNTHsB5fpQ/8Vt9UBj8ppdASUEtkif/g7kzZic1jjXuhbimF/+B8gcvCddex9IRMssFaytfKqguidBxFwU3VVcVa41H2/
 E8x74YZR
 MYdhiHKeDBqebw/UNGvDg9+ut1+6Y/znbRDcefWgUmkh5y/0Dp0nAWBauKHqjF/BecEhgU6DT3+8zOf+WpiDzW0zmYIFlAYJf3f7ImS1cSm2W8g9etT3Eh2xJMMQsIY69v1nnvbfaCFA15UtJDp9gcPTTwbkAvmQK53CxbUICL1WEyeqK/l6Wt8GYfmstB4tVvzQW5MpQJm1yQG9QQ2rsLRaS5K2heFXAWZaHNa5/Euj3zvSIngDSYpF4lOv6ZwbEPwkPrM17tXX91hm+fDnHiWEYRnM0I7Db/MpVQE+wHW6syScFS1c3rOIaK79UQt+HnYYyxhA+usqEjTsDXs7wRyH5SYHUkiBH+AXQs1mvk1wghypl/R21ydthMua6qFfMUHMz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Oct 15, 2026 at 06:07:09PM +0200, David Hildenbrand (Arm) wrote:
>Let's fix another instance where we use a folio after dropping the PTL,
>where someone else could e.g., MADV_DONTNEED it once we drop the PTL,
>making us trigger a use-after-free on the folio.
>
>Fixes: cb6acd01e2e4 ("hugetlbfs: fix races and page leaks during migration")
>Fixes: 1c9e8def43a3 ("userfaultfd: hugetlbfs: add UFFDIO_COPY support for shared mappings")
>Cc: stable@vger.kernel.org
>Reported-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nice work!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

