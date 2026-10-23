Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED5E660A2613
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A4/s7+Vd
Received: by kanga.kvack.org (Postfix)
	id 06D1A6B0BEE; Fri, 23 Oct 2026 19:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044816B0BF1; Fri, 23 Oct 2026 19:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5226B0BF2; Fri, 23 Oct 2026 19:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE7A56B0BEE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:57:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A5941601DC
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:57:42 +0000 (UTC)
X-FDA: 85355555964.09.B9FE642
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BCD7340004
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:57:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A4/s7+Vd";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792799860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ou58Y4yxXNGWm036vXx9oCfSGptfbJo2/vxGXksCl1o=;
	b=IOJ8U1Jaj/3rP08BOhuD6aZX1kfGfSml1NKGLo4RthG93c7sC+cTatFcHPMpeM+fR93qj+
	N3ghUdWHvnezbd3Cbps89GRLqlpXa1uf9DYdzUTYIJLj2nZmfJNESHPMD9n6VfYue13DCi
	gK0AY7Iuml97MrZHDDgSGvu/mH4gC/0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792799860;
	b=TbBlkbSfvhsz8gLlOKgPbCA9kilGaBQiddcLthF71iyrrvZ2DGtzDEElWo0tvE/AK5FBxc
	+0iDbMz2SR8cTCHhYarX/XRWOVgZ40zDL1kIgdRiIDSys+VW2MCSmJxH/b8ow3sI1YnUTi
	UKi4FyIcEEx3LLq03/A0teXVBcLBhgQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A4/s7+Vd";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C285343BAC;
	Fri, 23 Oct 2026 23:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E271F01829;
	Fri, 23 Oct 2026 23:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792799859;
	bh=Ou58Y4yxXNGWm036vXx9oCfSGptfbJo2/vxGXksCl1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4/s7+Vdge+0G2LfUOjLjADYzdPY50oLRCpfOyHRwRqkFwaYVicCJBcdblgKoPUpB
	 F0eUZcjaUwGd8Xn4i2dEaDaZ8skGLILfGQ2UK3ax5iOfXmPVTqiZmHmNOxO3UB2Zq5
	 4zw3ogvp/r2tQFCeffNoTAaIduwXE++UHGQK9X/x3EgZvq7Dn2NpP+R055Xi24mhMR
	 EqABva6v1uwiopCPe3l1XtcMRLOud74nvh696kTsOQa/BeIYN5RLZ97HJx7SpWN5ce
	 vwl+zfsTJELoGpESMpwqcZQ21jE9TS+uP9hs4DTtm/im6TjTokpAxDz6SncdQ2mAGH
	 vg/v6QSMOxIlQ==
From: SJ Park <sj@kernel.org>
To: Suseendran Bhaskaran <suseendranb@google.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zswap: validate dlen and normalize comp_ret on compression success
Date: Fri, 23 Oct 2026 16:57:26 -0700
Message-ID: <20261023235727.86376-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261022232734.496064-1-suseendranb@google.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BCD7340004
X-Stat-Signature: fpdp35cmcwrhb8n8ibe8nujwuyocttzd
X-Rspam-User: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792799860-600876
X-HE-Meta: U2FsdGVkX18zg2qbXjNwB7LLz4GaXAyB9FnexN8wsAtCg5F6/YiSgPbj1BmOlPZNecS3bOm9QflBabfNf8mBflk79YBq4h/uxlVkUQNGixeieFR0gt72+ATrnVIH/jclcB8fycwC1GHnWYjlWUR4rwrxNS+vBW5sfMCzLUfnWsGxY1k0lb5Zn8GVneeJZ+4lxryqmsKqC/Wccgl65XZlZ8y6TkXfoLlQhDaklXaKzvilOxN8gJTcPOBx79rx+Zjkkn7HCwJDxM7g90jnoWHET/8zsodYFsGw04Szvlo0xzdeUH7usNXPQyrlRQwnId6HTRml9T6mmdQmORfgpVbg5qrp0orKvSJ/7g8Z0/OHXXr+V33ZIvcXX0io/1Npp7ZY5142zO1zDHkhY+h1DMEfH6z+QpmSL/IpxgzdYDZ8GEzubB8TkxeR3P95ULtZXQAqEj/Z52ODGcrvB33KnffxJVrZ3eDdVTRA8YynERw13l0bXmTflSbwBDP/FBuv/RQ0Yu1YO2bYkDyEDBfJIWUj0MJ5hKpeUF7eXZb0ZLtEeUnfOxZAD/JPoEadwMoCnkVg/SOnn+9rX5709RpOyqoAj1ErJJF+91W5gnAIMIrn8iB3I9Fu5da091CAPmPpGqzyCnlVDsgVLIKtRrYiVZt5WyAQc5XlxIhCN/enHByHmrS2srG58qkUl9vcJ06m+atWKvDXAg6fgju2a7yc6gnWzV+XFhvyMWKjaeNQq4CeJfDBto4xZxlEaae/uG4MCyeR/4+ppuguZ+JjL2zkfSGmRgrAVLUtTNmp9mun6L+ijSoBhnsXtEXwtooY3IcxLmwexOnYufCji1/F8xuuHVdvhmVhakaEbB0kkMRK+wZ/VUKjV7OKfnYHUQ3ampzfJWznP+LtAwfxeQpI4ABRxB9nxvvfFDX3bxZtswPWR9Vpm71xR1YtbOH0NggtGa2yx7wF4th8aVvy5X5EPWmXi0l
 yrxTfjv9
 PzOtck77OT7AgVQjaY1EpYhJp8xmVJWbeGWoX+rAVUhj+VTjN/QGm2AzlRiLrXi4H/llUMg3BsrwSwYSb/jUkoyrW/CCWoP4nhTczotV7TZFpPw0lriojGa0MHTcER23kMWcBrVrPhSbI0RpA2PCdh757NFkFgfWyqgBnWqeqSVW7K+dStrwmopeEl8M2bxtaICNHjX+1o8E82NOWV7OwsKX2y2ZOu5VWRxxuSyvKvfg7CmhUgPKStsgGLsKpAeYjik7BiBzS/XqboVXjvf3IPyB1dTHegMOPjXzhj0bR5U3Wsi4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 22 Oct 2026 23:27:33 +0000 Suseendran Bhaskaran <suseendranb@google.com> wrote:

> In zswap_compress(), dlen is only meaningful when compression succeeds
> (!comp_ret), as compressors do not consistently set req->dlen on error
> (e.g. zstd, 842, and qat set dlen = 0; lz4, lz4hc, lzo, lzo-rle,
> deflate, and iaa leave dlen at PAGE_SIZE; hisi_zip sets dlen to the
> hardware-reported produced bytes).
> 
> When !comp_ret and dlen == PAGE_SIZE with zswap writeback disabled,
> zswap_compress() sets comp_ret to -EINVAL instead of -ENOSPC,
> miscounting the page under reject_compress_fail instead of
> reject_compress_poor.
> 
> When !comp_ret, set comp_ret = -ENOSPC if dlen == PAGE_SIZE, or
> comp_ret = -EINVAL if WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE). This
> allows simplifying the failure check to 'if (comp_ret)' and dropping
> the ternary assignment in the writeback-disabled path.

Nice catch and fix!

> 
> Fixes: dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is")

Thank you for fixing this, Suseendran!

> Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

