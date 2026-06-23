Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A367CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 07:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255566B0088; Tue, 23 Jun 2026 03:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206946B008A; Tue, 23 Jun 2026 03:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E5A6B008C; Tue, 23 Jun 2026 03:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD8FB6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:26:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51AE440274
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:26:17 +0000 (UTC)
X-FDA: 84910343994.03.35F091C
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8A827C000F
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:26:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YKLqdtPH;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782199575;
	b=g4fONcQtcVTvqvgjxh9EccbZvxDAVZRvPC+2ifkyyBEictZFc7dnEy1OgzjaYUHtwZB7fY
	idkd5s9w3WHEjvIoVMMb15fx7eu9CEVCZbGoyyw4Gntmsi28fM2MzwD7BuNUNiFncmw8ZZ
	uD23B98NrY2zosWxJiUf1vFGoEp1vC0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782199575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zuaTe8OyzpGDUNIVA+uFcRVLeTjcxr1Tcp7dy1adM0M=;
	b=cbr5qDJYMXtjF0SLrv7Zg1JFrtdG9FMEaQSqgLNX9CJbHB9V3WknZuSjt4G4VWy9Qdildp
	ReftMxc7fiWDHYtbXu8i2E3rXzh4vzTVBG3E5aCJoYRoH4bq9uL/T+k+YbqJiOjM+aCO6c
	pS01PSnDiGuFS5+hEZZz/JXTkGEvYyQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YKLqdtPH;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782199573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zuaTe8OyzpGDUNIVA+uFcRVLeTjcxr1Tcp7dy1adM0M=;
	b=YKLqdtPHjSJizQIA7e48JK4rzzGxmmisdccbx8Txgm2GmTU8coD3fqaGdlNXnMni10wVo/
	ylphzZuLXwiX1EBp+fRAv6OnJWkyIOZWZUcaSsNFiqXrqwIQlAeENgCEHjnRH7I2Vin4Vq
	FsrcJXZCg515Nt4n3IA7AqvpYLEE3WA=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	baolin.wang@linux.alibaba.com,
	jiaqiyan@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH hotfix] mm/compaction: handle free_pages_prepare() properly in compaction_free()
Date: Tue, 23 Jun 2026 15:26:01 +0800
Message-Id: <20260623072601.78245-1-lance.yang@linux.dev>
In-Reply-To: <20260622-handle_free_pages_prepare_in_compaction_free-v1-1-fcf3b14abcf7@nvidia.com>
References: <20260622-handle_free_pages_prepare_in_compaction_free-v1-1-fcf3b14abcf7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zhmo9dn43kgmpdyctua97cxwr8wwnq9q
X-Rspamd-Queue-Id: 8A827C000F
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782199575-477008
X-HE-Meta: U2FsdGVkX18lzWDDG4WhmIccy7LrZhXbRKpLX88TTjadMC6KQsp1Q270q9OlefTkA3oTYioa3i2CA6kO7gVi87TbGLOfkzOy22RXbpfGDMBvyyoVR8VUT7dXD6rjQJ+jtXcBJa3rUNgS6haU9mLzdMarMq1xgoCT0vS+kw4SWPch05Q+bMUaidMrHuUdVKucR2Xw0Nc1pEwtSQLbme6KDDOqJ7Ky+o8T+MoDdhxrAVSg13UPARrfDst6Yk4Q+DTr8T+a8q0mZNmdc8m3b+joJNpL7o7xjd9nsPG40JfmlkeFPG+Vk/r7FJB+CsgC8TkIK9Tr94H8Y8QARorVHFmW6sf7zGm1nMOpe09cYiJ27KSMNfDTGIRQ1zX+w6TRzhX5Sm9CHd/AL/u5HrVfboNOZj4kdAhRAc5nTw+QpGQ9QZ2E7VmxDZ8SkjOaHSz8zGiS6pXTrOe5otEwLcOpGhHWP5BQAQEqdOcXewnZglCSvxNnYrlNTNqy86i1rNnxNQhviQa1EeMa4S/vIOeiP8ojpF4yL6Wj4KUI55ZdtsJbRbIC+9u/wPNBFcAOAWo86xfjHMpQorJ/3ZNPS2k5xwh03xjXr01C6YJnituIZAM7Zf7OI4VyIW9y9et+vwRd0B8kTUwFBc73VLHjHzNhqzXY0Ma2v9tqmDaO1JdG0dsGwIiDUYU7GPSh8j8DjibrnzE5JdNt8YtfKx4ljULwLBsdDFlYMmkbQ0pLZhqc3wjVN+mfM9/6fOpEI5tFolevHkIGwZ3xcxr4IuqeVWL4SXNaK4U3TEF1yvjMYw+bEg5wxvfphL9/AnAF0OrIKhPYqOsZllbScw7Svo2+6AUJqh4Lmg15y+1iH5B8HRK254r7IDWuPqAVvxrFLFGydAPyq4VlCMlHHJe0QeF6rr6YIZDE+HWNsg6xdBjdmv8knfK5QU8H12Qch5Jok4s0Y0OTJyFrCyNnVtPxY73PStwpgaP
 y160BGJw
 x60HZm2rsSbpUB3tFNdwzrrllBeh0ntmeuQepfN6T/eRTNt2wFaFOT35v3YHz621qO4+U+kkbYSFI+etLwQMnzokT6wk+Fx59XMsKTsWxNewlD5puELg+lgbGwjaXRFe7tV4euGSm5Pw2zWgfc5Gqj45j49A8nlV8Mo3Wnf2QUXOFVJ3ToJueYj6gevx1JSTqwgEnE6x/z3X/J9+HtoxxQAtO/xGKKtxVj4+1ZtX60cwmh7Q+ET98Dlsfadca3jOW2pG1YgAqRwvJA4sTUzUaTBZomqnCbO79xoLbmaQ+KKQ/ohQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Jun 22, 2026 at 11:30:42AM -0400, Zi Yan wrote:
>free_pages_prepare() can fail but compaction_free() does not handle the
>failure case. Failed pages should not be added back to cc->freepages for
>future use, since they can be either PageHWPoison or free_page_is_bad()
>and might cause data corruption.
>
>Fixes: 733aea0b3a7bb ("mm/compaction: add support for >0 order folio memory compaction.")
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>Cc: stable@vger.kernel.org
>---

LGTM. Feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

