Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0D8E606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 04:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Rc4KYIC9
Received: by kanga.kvack.org (Postfix)
	id EA1106B05B3; Sat, 31 Oct 2026 00:33:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51D56B05B4; Sat, 31 Oct 2026 00:33:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68576B05B5; Sat, 31 Oct 2026 00:33:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF0286B05B3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:33:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3CFD61608EA
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:33:22 +0000 (UTC)
X-FDA: 85381652244.30.63EE2B6
Received: from mta1.migadu.com (out-223.mta1.migadu.com [95.215.58.223])
	by imf28.hostedemail.com (Postfix) with ESMTP id D803DC0002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:33:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rc4KYIC9;
	spf=pass (imf28.hostedemail.com: domain of jose.fernandez@linux.dev designates 95.215.58.223 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793421200;
	b=ULa9eXUkD1LVWAsqrvbVOUvEtTa30WYGu+AOhB4+RdJhOgG3OH6ouoxTLSzdIj0bcwspat
	gIJiLYlEWI2O0+V9fXy/38KXE9u3GrBQDo6ECaHi2xlITekBufPLk+TslVUli+zNSxQfiS
	n/haPhKScq/G9CYY1rXuZ0mAj69uMyA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793421200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tArUjAi7RyNIs44mDcDEd1/onmpGhyZQLsYyXwL8Y3g=;
	b=UIm0m9tQhgdtQP+sMxga1jim56MZ6IMHMLEym++lHpQW11qc4SC6NJMFabeNqfUyHrOuBG
	au52WPzHNwdeZ/uk3UPyzDtAtjMfDERRA75Fa03umHS962szKvdQTMI8DG7oiFa9fGsOTS
	c8d+55u2nDkRUN0cZILsK5Zuo2wksBI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rc4KYIC9;
	spf=pass (imf28.hostedemail.com: domain of jose.fernandez@linux.dev designates 95.215.58.223 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tArUjAi7RyNIs44mDcDEd1/onmpGhyZQLsYyXwL8Y3g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793421191; v=1; x=1794025991;
 b=Rc4KYIC9owQQYp1axLtKtu6ytYWTfMvKNYNUub/cy2ph/TXFumz2vQ6CYqrK6QVcbicEDcLA
 Bh/VEkrn/qSnWAGE694BRT2khCHiB5WXWtvl2XjZmiI9yX8UO/tNsVAcADFoCV8bUBGj6P/DcC7
 koJOWoyWGGNT54l1o7TfdgqQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ea78379c5260a3be;
	Sat, 31 Oct 2026 04:33:09 +0000
X-Mizu-Trace-ID: ea78379c5260a3be
X-Migadu-Flow: FLOW_OUT
Date: Sat, 31 Oct 2026 04:33:06 +0000
From: Jose Fernandez <jose.fernandez@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Krystian Kaniewski <krystianmkaniewski@gmail.com>
Subject: Re: [PATCH] mm/filemap: stop fault-around when the walk steps back
Message-ID: <20261031-jf-mm-filemap-reply-r2-7d4c1e9ab350@linux.dev>
References: <20261028-jf-mm-filemap-map-pages-lower-bound-v1-1-0bf126e876d4@linux.dev>
 <0a1ad7d2-ff0e-4248-8f03-2a64a9134aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a1ad7d2-ff0e-4248-8f03-2a64a9134aae@kernel.org>
X-Stat-Signature: dj7hind861q9jybjfjyjeby4gkmdko5z
X-Rspamd-Queue-Id: D803DC0002
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793421199-597893
X-HE-Meta: U2FsdGVkX1/IbdQ4t7bm0N6i2mUairRgWlzJkuxTebz69RMWfpSUhkMXnw+KJ3+imEXmL5Q90I0zOsdmBmeGFNXQaBnArZWUKcf2VN4s7SymuUQ0jwviN8BUjGym4e2aMXYB34L9YNurq0Dcv4h+Xwz14K7EnaJEZ9KuuUsucgztNxDZALJCXDHDlMhI/UBLi1uGidV/LsgojGIr81fIV6lYwUjHoVNVxdZASecVKPM+hrrHlr68o4GleFCgGY1yYI6XzqHgeS9DejIsKyIeD2NsN07C4KobYmF6ejJ6u4B1oktVMtttzrQH/VBAEc63LkjFtNmb8rtn5tGM15lOI+MBTTGiXMTmDSMbpj42LLS6GR7WUHYCcxJjxmprsF51+E8EZlGRUsB/u/j/8KmJdqDllofQg6G47bUYf4j+9syh26MCULJN1d/WdwePUL9l+jFKtU2WlPYNN6CgeA3flKpzSWejIzy3YS7yXrK51Yn2WhguzEN9G1zzFFXcE4Q/IupBcfFcWHoUXDWxLef71MXzi3p5Gnda5pyuv1eM3TCTJuH8l6EEB3nxh+AghbgcEi5LA4G0P3HI7vF5lqk1Lp3NuuYpm147aB8oXqxCg5mKdTUz+4+T7yNtMbUC9soTuc96oum4UUpO/QbtJOqpfJMWDaI/PaziKX0SFu9yaGupd27N8eS2+xT13L5YQ/0b01U8Zwmgo6YzN8Pb7U85JqI/QGtBHVq1cb++yXDufAZYov+PUNQkdpNNT+DBEdpoK8FUPNdCcn13kRFansMDUlW38sd0Ys8n+hR2L0J7sTQHU0jPD2Vrl5nYnY6f2pecsoH0U1XNha4RL4V2Wc9UFOEhPCfBpIgKQM+jfyzlEZGnRNFa9S9ta+wcL8mQlUREiskbNLLwB/MF8DMm9QT3m8YyUTympnT3fkw9KuBBFnjxvBT42E+/Yszn471Ml4kTj+RMHUSOvz11mE1tk4W
 pBX63fGY
 zM1dmRxJXfYQy9EpoUfZAbGEzqsikb9Ay8cx07rLlDbPB0P9LbV97uET7eSxz7KlAVu8A52xawpKVmTPZhkSOophIoF3XdGciPXxwLAwpnfeBV6XJbK/lWt8Yu3vlRsyeds66seJTOaM0ToLbTLOlU9Bm0k+voWPfIKwGcLWgchnTZd3lFYNJacIJmV79cZkfZMj+lhhhehJpRkCCFRSkPJDBYMpZpjD2oc2vXVCH7wrpnK1k/9Etr1yMRCd3eI4b01TpgHmLCrO123SoiyBU1NF3Ah+eK1s1B0n1vG+WnN4VPXdr8XdHxuEEMJxaJPUm5jmqPz+F3SbLQnWuCJ9B039FommYNWX82ntQaNoigN3VwYzTdqtf5wmJ3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 David Hildenbrand (Arm) wrote:
> Only read or also write? I assume only read.

Both. KASAN only reports the read, but once vmf->pte has stepped
outside the page table the loop will also call set_pte_range() on
that slot if it reads as pte_none(), so a stray write is possible
too. I'll call that out in the v2 changelog.

> Sounds like we want a Fixes: tag and Cc: stable? :)

Yes, v2 will carry both.

- Jose

