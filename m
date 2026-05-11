Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6829CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 07:16:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E55D66B0088; Mon, 11 May 2026 03:16:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E064C6B008A; Mon, 11 May 2026 03:16:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4CF6B008C; Mon, 11 May 2026 03:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE1B26B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:16:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 669CF8B672
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:16:21 +0000 (UTC)
X-FDA: 84754280562.25.CAA5772
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id 80F8080008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:16:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FQMq0X5x;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778483779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hLmOJpxvk4ryAkBCtrVBgXsL8rxo5fZK8cu+U/4yX/4=;
	b=IkqUfUPQH4ZgN459AdFyv9TZNXSQWDakVHPacLyqRwuZnZN5lxl6tiBdDVpZyOVOvrRsQa
	ET645gAf/FESGo1wuneJQtwZPpk7HEs8ry9BayRWMx2qh1+ibhVuf9Ft1beFUX/Is3Y8uU
	D7wxfvybdb2tqIMzKPzwiVX1KfPHHsQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778483779; a=rsa-sha256;
	cv=none;
	b=j+rBVrtFGAxKo9qfj/4nytkhJDb9RgXKLWzYIS4vheG8f59NMzS0sNXj89pSlvvIv4Hyqi
	B5xtDL/gby4q1+9w0F8SQCtBfbtw8Lb7KZ7WsF8r136tcE7/qz+kcBLHI9Fdb5YqZjoYpn
	NTdZi3v5w9rckKHLtPBEIkNAd1xjTFM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FQMq0X5x;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778483777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hLmOJpxvk4ryAkBCtrVBgXsL8rxo5fZK8cu+U/4yX/4=;
	b=FQMq0X5xrfT80StzUjWtt0oClo+roZ7fhAIf+kT1X6hiMVe0Itow+9sXHbjtdKiWaeH01r
	uXKHYSxyMMppsI1AZjmZBejBtgQNhQCmXhsq/Hd5/sBt8//5UgigK+CAFXVgtEIV1wzr+o
	NS+rfAII62UAXUC5MNO6xXBkwOzHHo8=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 04/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in hugepage_enabled()
Date: Mon, 11 May 2026 15:15:48 +0800
Message-Id: <20260511071548.13941-1-lance.yang@linux.dev>
In-Reply-To: <20260429152924.727124-5-ziy@nvidia.com>
References: <20260429152924.727124-5-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 80F8080008
X-Rspam-User: 
X-Stat-Signature: 3dxa5cbmcih9u55etneq3qsdnan349r4
X-HE-Tag: 1778483779-443392
X-HE-Meta: U2FsdGVkX1+RxKdXzs3CSPrrRB4iyJRU7IYo7bVbhe98Fm37ScD61+Aut2YVbiD8BRMpLumfTpttqy/qPC12krSf5Uf0StusBKQVAzmsnYFz3CqDG6fnRY2y5wCZEVFfBPFgpnANcXQP8HBndJ5NPtcasIjjilYf2wH/BuYxDL5JmD9kn1xD5820b7x5ZzIFCUqFmtcwSWJ6Kse8EgZLM+X4cp16Ii8KXOf904KbpWHFHOnVbpZ0sdHivNRXX9A73fONMuOC3abxVoHUX0Y23NDApqQuZk9pt4qXahkVkylFYvlAdCrgUJk3kdmIYVMsIG4vSMpIwrG64Ng1Wxy1DA2Xfq1TfTRwl1jLKL81m87ZVmZ+VcAgxQQRZO53Yg48uGuFjTXzjW+5DBWE+kLYhhDrTff9SeQ5lQaYDUYr+dUZuo0V7iszdsBkFxdrJtDOGBdu8t4dBtyLw/+u9EBxAJ87a59DuQ1aXH2/oRNgaYv9wUGJ1mFnPkonNCMgMwTkrCaRnBWG45KqVQn/KaghqCHxSvIiZw+JpxUdk3xThoU8nbc4IoIpLEsCQgtwWmFQ8xyU6qdGn4bIZwR8TcnOJqjcLM1tGdecGNQNYEQShTcksqXPhTDZbf/O+4TIfWV6ZuOXoell4pNw9zrOFJgADC+oOKysEjtlO+6pAaDQLl77WA7c7ImuOxji8JvcXIzjg3r52vxgvbwdM16x77LyXD/xtrXNjEVjzZjV4F8lXFFzhenEQpqeQ4p0dKEKaHQrHfzSGR+iYj/BZiConHxNQ1O+ZsX1Y9KyqgqllnnykXH91DjMvl0687d73eOKrH+FGrdeFUYzljk4yPR9hX9OTbBA0xWKpkMYTr5a7ZDnrMu8Dl/+PWPmeqWZgIxybr/0kjh3K6id9G9dRsslIyQK2349NlG12+n6PwnhcYOeFqFY1BinspwlAESyqB7xQmVsnEa+l8bQELGdzDRyxZK
 sksftYb+
 g0GGWs2LT7qdH64aTrIpWlNqDoCwBzL5NO8E+YOtPH3Gjomnk18QGIKvF24hLC/qUvR46GbSNAPOlAV3wVBuqKKFdRV7SJwPHDzWrX5OaKzdVFCwcBFk1MSlO/STZFZ4UjkwWWOFwDmkCXow3rGIqYJMT4MRx45pTxXGOap4MVNRIuaUUb5slXHIm8vcZIofK+gv0/VMC9rTBb9napdV+HaGk46pE5ccPDJYH0+k2+8s/Ec1uh8MLFte1wcNXbQBu5YKLtA0wVTL76XeiR/+OcmAlHD//N5Eynl0J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 29, 2026 at 11:29:14AM -0400, Zi Yan wrote:
>Remove the READ_ONLY_THP_FOR_FS gate and khugepaged for file-backed
>pmd-sized hugepages are enabled by the global transparent hugepage control.
>khugepaged can still be enabled by per-size control for anon and shmem when
>the global control is off.
>
>Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
>IS_ENABLED(SHMEM) in hugepage_enabled().
>
>Clean up hugepage_enabled() by moving anon code to anon_hpage_enabled().
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>---

LGTM. Somehow missed this one earlier :P
Reviewed-by: Lance Yang <lance.yang@linux.dev>

