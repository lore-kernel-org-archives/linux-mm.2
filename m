Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D0F8F3028C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B10BB6B013D; Mon, 16 Mar 2026 02:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE91B6B013F; Mon, 16 Mar 2026 02:29:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F41F6B0140; Mon, 16 Mar 2026 02:29:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2D66B013D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:29:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51A7659F5A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:29:29 +0000 (UTC)
X-FDA: 84550949658.09.F04FD6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B451B1C0008
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:29:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u1EHAFsp;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773642567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vEla5+A7WtWKdOb9dPS8dy29NvFV1BVF5mibY3BKgOQ=;
	b=GFVn61ZiwRVVJPXPXxvyT2rZTG9iFfaI5/MxnC6ofh61SjL7mYc3XvXNRLpL4QzVhEs+9E
	Qlx8ju4DiGR5rBH6327Z4r5jcsBI3tdvCFOG/rk5mD1zwBoDjr8Fbzst4oanfzvd64E2VI
	Dgm390H4WWdN9y+PjS/jiiDcNeXpw+c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u1EHAFsp;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773642567; a=rsa-sha256;
	cv=none;
	b=n3R1/ok0YFID+A9XISJFq8m1qobmnTRE48rhXXZ/YJYxHYsIoUlmVtNmJC2PC6FAGv3p4H
	5teLCMD98S9zbuYu4RRCMlA0H0++nWFCmdHSb66KscVZ6zY2Dgz1Qz244eG5u3+yQHfdHm
	xTHZgVo+9VSnrtaf9gDgE5UMT5yUDX8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 16A2C60008;
	Mon, 16 Mar 2026 06:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A81C2BC9E;
	Mon, 16 Mar 2026 06:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773642566;
	bh=ktXRXkP5hrIO2loAV8z65+7YYpRkolR39H5JtUzQg6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u1EHAFsp9jlP2J2cwUKw8HzJN07gL/SrtcH4P4ScAdVPoK3NKpmev9F1XykTIgAOw
	 FvMBt/kSQgiNysyDgoNWApuF1zHEqvzk7B1H73sbpJbSFrjSAyBK+FGVD1jgfBiya0
	 veXnsLgv7Q3o0uGoOwKv0+jveNvUsf+/MtDmmyszyBdKFvLx4mUsH9oBWGthwjlIw/
	 TxN07vLkVnVgvTKlUGlBkcbQHJk1hIrWmbO0u8dDuTnwsc3LadUJ9YuG5prA9ca1kM
	 L/4IM9vXIATWNgSDjOnNaaFNmtV4HfdE3/4gRZojDX6qZqheX9SgM84Yl/GtNqnpmr
	 ya8fMRR8FVwZQ==
Date: Mon, 16 Mar 2026 08:29:16 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev,
	Li Wang <liwang@redhat.com>
Subject: Re: [PATCH v2 4/5] selftests/mm: split_huge_page_test: skip the test
 when thp is not available
Message-ID: <abejPBPP0J2m8j18@kernel.org>
References: <20260316044335.1390608-1-chuhu@redhat.com>
 <20260316044335.1390608-5-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316044335.1390608-5-chuhu@redhat.com>
X-Rspamd-Queue-Id: B451B1C0008
X-Stat-Signature: 5j3n4xqkfbho1xz5zbejsrpny9jsrhxp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773642567-399347
X-HE-Meta: U2FsdGVkX18X8UjParCkvYDO7OdmYDyWXnDVs2Pd+ctouaoYcIfdu4VQiA2SaV+h8BcSkqiYxjPDne2OCTtKNIEg8wp+GhP+mdYGXNRJBsNuIegLqS1Fna4LGcWdgRPisk14GeQgidu5P8+4aAbVwtkR3ZmyUJ4b59kU7eZmQdoOh6H/YEHR7pF7J2jkamscLqoIZp2l8EoBU61TEm5GJ8bCQGknSlWJZMhEZ/xADoLSZK7/vIqm+gWtOFFRWiM9U22YKryY4vqvAvfMPSp5lROe8co+f6blUovf2iKOsjK/QQL4Q1xmOqXXo2tg6JvY1gKTptHIFzjQ7bRRiF5XS1V8rKg0zA3QMu2Kou0eVCE0KhGVZ59ZQW2H68khFMf/KkroqSjqzxQZ32nqWGt3ILQjGygIlHBXKnQOl1veBHkEkHxxxoD0giy5YDeSXjPtoW31WXejF4f1MAQrK+CpXKev480Liy0HSLaNCzLErmcwDS45apce0h2dEYE13sh+QkClUdpMzwvV5v/w+wkzEubPPX8UZK7Rvj++aznMXXJutQ6pjgdxi6UhJlBFjW8QDhTrC/cxLLZry8c7DQs2mUdFkcvLw1O6JDJUqf+mJXoe2XeORmcJFUT9c1gbe8n7nCnh1CpG0AkbfOyZNFVAiCKyhpFVyCLnvxYktO7SLsrqi1YPsiY7saooh7OpIYiW/NgOm1vV2Q0i731I7uSfKTswbfwW/YkOHLsp4O3BCKc35TOCnunOLZ5yBVJ/PFvKdPcNGMQoYSede8ZrWF247DR3t2ODgv9/D7seDy9RNXAZHZz57mt0Fzj4wToyjv//n9OF7kjN+DcDRruz21UWWFrkxiy6MjGOvnyr3Mjx64SFSPT3SUXn+FZyrmVFIEFhWzdbo573849QCw5lAWsmmP98VLChNnxj2X6L7ik2eMOy9H1P40lqB5V36PRgIhT0IQ3uCUqm4XBOVx4vQ0o
 pFL8T9WY
 t6M6oL5kDQyOGwRcmVVA0lAUsBQdnLnc1BT1hhzxwOyhCgkiblhbAVLFMaK7CDgzMsO6So8YmzYKgqdq+QUG4Pdi4m+xhbtxEVDyEvNqPw5JvUtelevXzgzHyCsyOUO3ganIxg8sojmykfWCsoXK822iByMj7CEBQeyWXVSU7SyG8cPf/RSMKrGc9NOWzT1CD5RVcVnO39Pfodp93kDbqsh/dHp4oAY/G31IpWLmP+KMMkQhEpq0zcrjOLNFAjkjcY+Ai0CsnlAL+RZt3HPNRrlkSoFVJSyJtP/lMSUwkgn9z0s9uOL6cNwEdahZJ/8AzPHKW2wkQlU6WBbPtOvSO3xey5q0wVTJoAWXD3wIi9xRMVpEwRPrlyALiQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 12:43:34PM +0800, Chunyu Hu wrote:
> When thp is not enabled on some kernel config such as realtime kernel, the
> test will report failure. Fix the false positive by skipping the test
> directly when thp is not enabled.
> 
> Tested with thp disabled kernel:
> Before The fix:
>   # --------------------------------------------------
>   # running ./split_huge_page_test /tmp/xfs_dir_Ywup9p
>   # --------------------------------------------------
>   # TAP version 13
>   # Bail out! Reading PMD pagesize failed
>   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>   # [FAIL]
>   not ok 61 split_huge_page_test /tmp/xfs_dir_Ywup9p # exit=1
> 
> After the fix:
>   # --------------------------------------------------
>   # running ./split_huge_page_test /tmp/xfs_dir_YHPUPl
>   # --------------------------------------------------
>   # TAP version 13
>   # 1..0 # SKIP Transparent Hugepages not available
>   # [SKIP]
>   ok 6 split_huge_page_test /tmp/xfs_dir_YHPUPl # SKIP
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> CC: Li Wang <liwang@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

