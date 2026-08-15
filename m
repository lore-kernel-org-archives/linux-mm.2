Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 458ADC5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 00:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193F36B073D; Fri, 14 Aug 2026 20:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144036B073F; Fri, 14 Aug 2026 20:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05A6B6B0740; Fri, 14 Aug 2026 20:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7DE36B073D
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 20:47:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E1F216029B
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:47:42 +0000 (UTC)
X-FDA: 85101665964.02.D74572A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id BB82080002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:47:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RouPeZYP;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786754860;
	b=mFO4js7A/mRuf5umLz6M0yCrDz02V7yKPbf+rTs+M9G2RJ6GFaKCy88yTEF2JgBTy7aBib
	3IiSDoWnN83CWE3xNun+N9smulhQeCLQ8wcM0k/CKT1mjRVIej22UwJi1/w/BIcO+7EYU9
	lPgKB3RDv+NGgfe7cW/DI6U3UzGR+qc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RouPeZYP;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786754860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EXjSPj2g8X11uO/ReLFrgauWbcYOxscwU3FcqHFGgS8=;
	b=X4vqvtf1WlhYd29gilY5Qln4tjQF7MDAi2pF13GpQM/gAhTjtkLcTykiXgbM24rxFyyCRI
	SjmiRXw24kRu4Rkcto7+ZkPW2E9eSsejx6vCPdK/EO06JjC/l+avp3+yUd33B552YBC5PS
	uSQsQVuObHflJ3F3R1Le8mo8kxyOjow=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1574660008;
	Sat, 15 Aug 2026 00:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE1B1F000E9;
	Sat, 15 Aug 2026 00:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786754859;
	bh=EXjSPj2g8X11uO/ReLFrgauWbcYOxscwU3FcqHFGgS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RouPeZYPBKyWMOzE44JhhpIppAimjKV75i45nR0uE78muv32i3ucJxp6KhPuGoxZO
	 Bc7ldcOkpEGUjQ4/YJeYs+PxlFTUGQTNvcTvnrm0g91G7bWKdPGPBrek9DTP1T9FCU
	 L4iZOK+Qa0WdyFH6pXV7t9ZFEJJHqMcFhPVQRc4wW8V8UDDU0Bxax2W3VXGr469PPw
	 QLtZsCGLQ7m1rDkCl42sj5ch5mCbPERQqoy0hmBegk3lqIBYxEoyvJpx7RHHppAYd3
	 IeDeW+yQIrxKoxjN1ezeXHqT2ggr2UYwIw8YnlmYbZqBbQpfO3wl/beRaPTVvYoq53
	 RHErsXlZugmmA==
From: SJ Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	enze.li@gmx.com
Subject: Re: [PATCH] mm/damon/stat: avoid iterating targets in damon_stat_sort_regions()
Date: Fri, 14 Aug 2026 17:47:26 -0700
Message-ID: <20260815004727.83755-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260814145409.553724-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB82080002
X-Stat-Signature: okuytezid3uouar1mmc5uya1kj49ydci
X-HE-Tag: 1786754860-587114
X-HE-Meta: U2FsdGVkX18tyNKSw9whdV1vQ/GWd0M6/+nH+BUv0Ki2JmSx4O1dYCzZPkSRu+2K27b67abPacOLxJqauBArNfyO33RSL6hbp2miMXk/CRhv3E9LBEHhrYqBM75MV6R8CuITA1pzG3Ij3vjQJ8m4SirAOn5jUeBhUd+f4XCmtBtWbhv4Om+5Rd+/utceP9yZ3XS6JAokXNRgKxNVe62JpA/1D2Xp7nVVFWt1Q+UalaBPpYIZA8TjkyD8LUimeVXunvhzz5ZdIEQpGDat07+K/xYjWvhdaF4W1bAM9J/yC2OJh5B0rOLjXHGMllV/TkPvmOlD1krGpHSZiK4toHdFqnBg2cjncOZ9cQRC0wHNeKW8MM4u8eHxxfn0jmXUi2IKivHwZyBJ6QO5kIW4ZRvmxL0MPxA8OdgijC1SJf3DOJPVqTaoE+Pwjd04apBlvYzp54cmEo+bf5iOlDyHMH0Cyvqn+8eUQNx2UqLZoatHzXMiuTnsj6gjy5+7vx31Qvkr5ai/6mr4JmqCOrpDHjpm4xOp3dMDIM3pfnrxd/334x2FVnQsAcluPQiSTUCZsLAkdyBJyfz2Zj4zYZ0wYXJDeAmy7mSxsOtr8/ZSO01nWZMSLhFt280KvGYtxwt1RcYVgZP1DD1+800oyuFZxmycJD8f+g2jM9CL3S1CJNoNV0JlzijA6dVO/XOrgNoUae1dm7NCCd9ehUBn1mP3wVn3kx1wgFB+xldUhtC6+Yj4dAz7XAlCYA1w26i29meWIu0BIHNQXJorw75NGT6K1Gn2ycoqEV58Cm3cPkySQ46VKeO+Q/GA7yZcKmodtZz+fXqyvsDMliN+JuLlh+qCNTDryZ4ov34OwscaCA6stppwTJDI5gtKLlehkNNUFe2S4Q82V2pClFVqWTea1h4x/LesFX+kUncROIopzMATxKcfBoulbYnj8w1SW7XuxGZzo4oOeAcEqZ7D/cdVlZKY9v2
 YE/hq4HI
 wzMfr2OBUc6QlcIn3uBPdQuF96wgOzE8AFTM5DPHSGa3LbXx3mqgLmHTBUMHPGi+K+z5RxDsozOmo3mTVl+Jxs0//WczytlPHJf8AawNtl23MvD2p2HGFgbBiIJoLb2OzfQNw5P7VfOGk0NZaq5LWZc6beYRGjppPuZWrbCNsGRbhk8NR2qNkQhzz1JZhEqIgioxn4C2EH7Djkrd9rAl3WFrRPuY6p+KebE3r3+8ERkcyJEb/yPYuNIhR/vK0m1C5eD9KjXwvDyCE/bJnIPrO7jaj7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Aug 2026 22:54:09 +0800 Enze Li <lienze@kylinos.cn> wrote:

> damon/stat module creates only one target in damon_stat_build_ctx(), and
> the comment in damon_stat_sort_regions() already says so.  But the code
> still iterates adaptive_targets with damon_for_each_target(), which is
> needlessly verbose and adds an extra indentation level.
> 
> Just use list_first_entry() to grab the single target, with a
> list_empty() check to be safe.

damon_ctx->adaptive_targetes is a private field.  DAMON API callers should
access the field using only public API that exposed on damon.h.  Let's not do
this.

If the verboseness and the indentation are problems, let's split out the code
to a function.


Thanks,
SJ

[...]

