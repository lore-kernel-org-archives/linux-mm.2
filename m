Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32745F45A13
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 00:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 469C96B0089; Fri, 10 Apr 2026 20:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420AD6B008A; Fri, 10 Apr 2026 20:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3307F6B0092; Fri, 10 Apr 2026 20:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2628E6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 20:15:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5B6901406C6
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:15:12 +0000 (UTC)
X-FDA: 84644355264.17.47A3F36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id BDD994000E
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:15:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B3duJlPn;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B3duJlPn;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775866510; a=rsa-sha256;
	cv=none;
	b=RLM3Twlgx4CvCpj/HK/+bTGPSZnLDL6glS5LSrt7RifFiY/n4U496Scf2wXrUP7xoIl2DN
	Z/xJvXzEMwkCwxTOo7zDh5DInJGdnGYUmTf4B9u8bjRMOq3DX2dnOu9A55YTGFWyGWkiUZ
	ksoEFw7kjonZK3FOaIH3Rbwmuh3KE6Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775866510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQgACKAfSw9jIQU5TLlRar7J1DmtZzIkk0GiO/TXius=;
	b=lcKvgFkM1zhs+OPDmhPwnQWNBxgUsQsv7VDk3P6KJo6nNdJlTOGCjBuYMy2+Y79doOgr7G
	mF+FCk83qrz0ww32+nAJ+TxoxtEUSydCWW+XXrRmZqUs5nFau+WzUv1vkn+ymx2xmS1pI0
	NoNeSM94lvs5BUHIGqjGESFfJP/4dkw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DFA3600AE;
	Sat, 11 Apr 2026 00:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B020C19421;
	Sat, 11 Apr 2026 00:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775866509;
	bh=/hprKzsu8I0mZLzmAZMS3rOujZINE1lzd39CC+PfBz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3duJlPndaO91FZfI0JFxTgOr91H9HHnX80tNiPWTE8XXqJ6VmW9oZlYGS6lI93EO
	 xrvxSICogGlIJxu1fFzT8BvPDsLrX53QtNeRpgYiF01/IpIgLk151UfYhbWPsSjskK
	 amuGtilHZwidifjw3z8+GkpsPM5nbvFY/AcecFk9PKGRsyjvZwTL34o+zkvMSHt6s0
	 bFKX2m6fzfqo6w8WnoBNsEkIjsme5v1XVOMBozW8h9xav117ALv9A9bU0gczhzpRGW
	 y7SfTDsc5nc08DLZ/tX9Xoq9zFxgPhyPSFqpdSgB1G8nbO+Gsk3LW1yyVKzcUoc0WT
	 ViQ48w0S7b2cQ==
From: SeongJae Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory-failure: use bool for forcekill state
Date: Fri, 10 Apr 2026 17:15:05 -0700
Message-ID: <20260411001506.91334-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410074740.2524718-1-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BDD994000E
X-Stat-Signature: 3pneena5nhpwtg96mft5zpza4uqfpyr7
X-Rspam-User: 
X-HE-Tag: 1775866510-36570
X-HE-Meta: U2FsdGVkX1/AqU4qarvDBWEBqbHnomdwn8ZDYO+6XVbmwk0OGcjwUCIMEUlFvpbLYa0JUMGUNsSNOEOAqKC1MlXVsMAjRVUWyzoLYuor1cl4yFqxYy+v4rhCPkjpKWmaCeZWAB4R2RXTCc9pZu9csw6w1zWf14JQ8Qc2uU3kscziqfn0rA27jzxlTbJD3JRvMsz4ZXGUCrUD0OpTy5zm6+Wq43ZHYf4uuaQ1deFGqI9naM6R+nfUkD2Xn8/uYOlvM+G+R3eaDuE1HWWBCLEI9tLMDznQQEvoLFuXEBcwUfmDqh2sKinxdk8N9D0fn7/iNkE+evodZobcCs58YFBEjN1ZJUthwq27MkNJJ0ODktrTCjc/BmUXNnDF7oyhfzjn5DXZajYZNMFVQzujalUyMAIGFcZ8XbulrBFaU7Bb7e7UpM6xgtqXrK0jRsGOrU6mI9Aby8WGUdYnBxKDP/wiFZ7YQv/sur3EJaeZFREdmWtQjqGLnoPMVKY7hpHf1qvTUzGondDblOpK1NKHJHJz4bGULVhYg1HVWTZcQHR9tGlTd+Y7ZvXr/6JQM5XXAdzu3rG/0xvai82QaRD+sKG2NwOJLXi37vlK9R1P94afBDjpp8rl4P25ysEga2tRwa802BQEMWmkIeTSn0DcV53yUu7pKFlsicaMa0GUqBuuRqmvkkKrmK4KvqxKUyzJc1y+qQSgShEoddLULK9V6rXaezFPp9wLO96/guDhqFJXnS3VvmzZ+VwBiWzT+9y9U18uoXkyr8nRVPKzdEc+56RpvSVJqpyRJT5lT1i1gpfHtnMNffO5v88i9ptbgEev8TNqh04RM4z2RJni27pDMHzKmWMdspSkE+IVhGrsERr9F/AgAr8xAMXNGO+oJC0b2c45Br+h5gErdtXd4cF7C4PKXAhDkdBLh9OWqtAP5tz1w9brMMid9iXyp3sOc44WhUh4/jJXLGhQu/HFLA/R7iN
 /a4dfprB
 N31Wm3sPJWWpmuvqmSTHPU1QRBR29wUI8rEF3jpTzD8ypH1anOXGbJdjM01DreoJECWicnEFfGZOWqXmk/fIiBjXabhcukknuNeXK+ir3qse2tyG9TzjMUSb7GhRSppw3ZdgAleD9tmlCUPe16/zI9Hz4VdSyc7lVfuaGciMEJDAQFoqPOQ5Y9qFmTGhFOtEuWyJvmKnKUNZnczqKiyB7uDSbEDnCrR8FAyo145u6hGyBaFbB9/eWW3wi7EmTAAqHPGvMspRuZzprTvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 15:47:39 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> 'forcekill' is used as a boolean flag to control whether
> processes should be forcibly killed. It is only assigned
> from boolean expressions and never used in arithmetic or
> bitmask operations.
> 
> Convert it from int to bool.
> 
> No functional change intended.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

