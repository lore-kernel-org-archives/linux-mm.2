Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1C6BC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A906B008A; Mon,  7 Sep 2026 23:38:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FD056B008C; Mon,  7 Sep 2026 23:38:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712036B0092; Mon,  7 Sep 2026 23:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 44B196B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:38:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 220F3C036F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:38:53 +0000 (UTC)
X-FDA: 85189188546.04.E311660
Received: from mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	by imf21.hostedemail.com (Postfix) with ESMTP id 098471C0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:38:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fiwCzG6q;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.12 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788838731;
	b=J5wn8f8n0F6J9LKBOc53yceu8yFlhctHqIJWC8W516WHxW+DhwxlqfhsQFvsza+Uq+yXb+
	VJwI7KIOGtBBc4uyR8mpB00JS8uWN36JPH0S0bRyspQFtEwBvCMTZ43J7TBgjd4Oa7AUIn
	tx+yO7KWDD6C0v5VNGc/Kmg+wTbXL8U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fiwCzG6q;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.12 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788838731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mvLW1vHVw6yctp/bvtj48vciA0fw8Y1ns6IIReD+n9Q=;
	b=BCMrmCGf0T5nrQ2VAULN+UvjB69a2EQTztkfycZETw8nw2ZcLjlE6mQtD2nviTwzXQkvka
	lBxNLUFBcA+ipbv7SJvFmepxIJRnvEeMUeWLVwUxd8W012ugaSMZomNGgr9ZRPathkJfNF
	pTdKVft1ntzB0sIapehg5Cqm6jdvA6U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yhK03DuTQi1iPHr6VnhteNT4zGo9XBaXI4LIBpf19GA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788838729; v=1; x=1789443529;
 b=fiwCzG6q5l2EK+C7ceQ7vW42PJuwLirLfMD6Kt0zDudO2PT6n3IXURopkigUDUXnCUWRp9Ro
 iV7/a2fdjhtITqGk8gIKIqDcriwLoi2NlEgDwCrHFiImUxIP4C/Nb5PMrVKqodq8i1rLCy1edQn
 88G3ZvN9Fk7e1RhjnE9tfMpc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id d4daba85eac251dd;
	Tue, 08 Sep 2026 03:38:39 +0000
X-Mizu-Trace-ID: d4daba85eac251dd
X-Migadu-Flow: FLOW_OUT
Date: Tue, 8 Sep 2026 11:38:36 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add Baoquan and me as MGLRU reviewers
Message-ID: <ap-DPHiQEnfp8hfw@fedora>
References: <06e20ef4f603a4ffeafcdbf623ce2936281457bf.1788831480.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06e20ef4f603a4ffeafcdbf623ce2936281457bf.1788831480.git.baolin.wang@linux.alibaba.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 098471C0002
X-Stat-Signature: mbeg8z998jbn3zsm6wyrj3gzn6z8oyye
X-Rspam-User: 
X-HE-Tag: 1788838730-576076
X-HE-Meta: U2FsdGVkX192J9Ytph4mwjnNSny/Op7mAqZzkbAIqeiMGeuBvDooer6KREkZ0fFdj1h2b0Zu8OoMkl6JQa10K5En68OFEPuKphxgZbbwtZ7HY3FpRgV11ysfiiYxqLJJA5WxxMkZs/KK9yRnvr8r0j0WOVxFXHXpuUf3E1m+NQoMhGO9jYMQpwJZlCjb/wK8t9+t8Tgq1eTjYAp08tgrvKCQ9HfuQFpTTEaxFh1GXV6PjSA4SyI6VVc0H+0k1iQcyZVgMOCTKmWWQlTinT2C7p8g5ImCdlAGN4MRRmzrrWmMMOCMwDqwVYC5RUJ67EROXnggbnU6totuHd/Bo7HikIc32sqV1P0cQkXBKWPYJvmB/0IZh5r4b4y5RYWNkOMLKAr6Y40n+xjbT0AmT7dqNiQiQyKgv6/f6SMr5FVBq+Ppi6LMX+mrcxKBL6r/meLnQ788j9yLwxwABs0nL37fl/TIEaDK3wA1Z4vtD3kJ3I89UyptzkQpryhiUXvVCBLYfOVRF/aRNWGvhOead4DZJ0PaNbLJZ/OlSD9W6VEIs/Vm8ziV7oDFNJtNjt23cQmOdqGOvwbbCy+TGrmD4NAqGkQzhfamdAN/P2rnQJZmEPQub9k1369N6MXaD9udffHE/1QufxSfiNv3k71eTR4BgQfk5c9cYpcXjrGxHK0IZ7y+xaT1gHglKDhg6s90tc74IIXrpNhxhzUFCKf/PrqwcHlw+FkZD6n0+kh26Ntt2YG8BxDhxnKgcjSRzmZ+5tRAdK2/xBPAf0F3GY+2BAuZOk9Po/+3HlwCnCoi47JP1NIICKQbC09zA2XID+8T8caLJUNw6/JGS8u6rlvQWx6docYpHpAGtFlXT1dmHWO81jHjM88+dHbfnKPHCs5efgAzD6MI1eN/JXkXbyNuodhoI9hPtT7Z1z1MHHAtdRHmLCJXktRM/KZ+xK++C/hleoVNQxMZfRiLYQnOtppNU36
 Q+/pqHiW
 fIwDrZAbyLG/dSxIup9vYHm6l7K73y7PshanaKK9TcTqFUXnRQDvheJ81GRI8l97l3SKmMPDNAyydDiqZh+8IVx/7s2YBlXufNjZaXmBa7ePaUhrx+oM4qAIOcPb4w/lu48ojIO7c8+4kaY8JlbxEjUIS+f26vBm/hQ8qhBPl8jq2pUXOX1ruFpCE9dGHGEVmAlRs87GhJJhU5bz8hvFJMRI9FFHfi1RLenYyAuxQEIFYR8c/06DCru7Raf0hjhRqC3dJUV1F7bOkIrQTQ8BMQ1Ba+j29OcreIR3L4hv8p6agDYt/fDVXY2qneMlCGySdw0iDhG4ahW69cd4SOVUodzOLhlJyIloJEnBUabZggm5JsxwyOc9CtFlpiCnuyBJh4Lka6/o0OT/tkhAzrFMJybSuwgbLhVBQFnwhmJkVKydzAuUAYNe/0kB/2tkeCwjRfVN0fPZJbPFKoq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/08/26 at 09:42am, Baolin Wang wrote:
> Baoquan and I have been contributing MGLRU patches and helping review MGLRU
> related patches for some time. We will continue to follow MGLRU changes, so
> we'd like to be CC'd on MGLRU related patches.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4d1ff4c76496..c558d5370dd0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17242,6 +17242,8 @@ R:	Barry Song <baohua@kernel.org>
>  R:	Axel Rasmussen <axelrasmussen@google.com>
>  R:	Yuanchu Xie <yuanchu@google.com>
>  R:	Wei Xu <weixugc@google.com>
> +R:	Baoquan He <baoquan.he@linux.dev>
> +R:	Baolin Wang <baolin.wang@linux.alibaba.com>

Thanks, Baolin. 

As Baolin said, I will continue to follow MGLRU, actively review patches,
and participate in the relevant discussions.

Acked-by: Baoquan He <baoquan.he@linux.dev>

>  L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
> -- 
> 2.47.3
> 

