Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45202D1267F
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 23:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E1AA6B0022; Tue,  2 Dec 2025 18:18:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991186B0024; Tue,  2 Dec 2025 18:18:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A6F46B0027; Tue,  2 Dec 2025 18:18:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75F2F6B0022
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 18:18:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38ACA132A2D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 23:18:56 +0000 (UTC)
X-FDA: 84176098272.08.072F197
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 52AA780006
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 23:18:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="D3lbk/j0";
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764717534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYjD1KC7LKwhQmMybkAlbHo11LR6BNRCoCUD/B/QiUM=;
	b=248rzb4i8jvCcOnbg02zLEfNAWFT/s0/0v0qEN7ECXkLa5onZu3rcBMTCU4L6jCMNRhSOz
	C+Ir8xVqkwIdj5KluhddE3kEu4NxDFv/FKNfOu91NLqCx6DW+gxyz5cSLbsrE0BjhIPFl3
	z1tJziPVWIA4Y3khyZ3AuCVEZ7w3wkg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="D3lbk/j0";
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764717534; a=rsa-sha256;
	cv=none;
	b=ihDtb6Vlo+X5EJFbnuLCHfnFUUxJTzMklTAhp5DZokJMSxe5n77cqaWWNEn2D+ogG0p9JQ
	mTtpagBKnj68IapRr7tuytMJXyS0H2QcMNvXWmYhylvXXwPogKEgp8svG9XSFGw2bHnDxI
	GDSRhsjG0i24UXJzjp8nA0FWzvsXAGQ=
Date: Tue, 2 Dec 2025 15:18:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764717532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tYjD1KC7LKwhQmMybkAlbHo11LR6BNRCoCUD/B/QiUM=;
	b=D3lbk/j0I16VjzHWDqhQT1N6rVhT500zGJut0+GOVA0Vt36HFWVZ7lq7nZ+FwQRARGJ018
	y9GR/gj+VEXfurF2gGjSRvlQKPZwA2+73Cunh3AhKVSNki2RNqI7Jx6AdqRDprrTG45uiB
	zDMbAvE0G9DbRxJ0BKQnzPIJ9pQ2NYs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: tj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, mkoutny@suse.com, muchun.song@linux.dev, lance.yang@linux.dev, 
	shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] selftests: cgroup: Replace sleep with
 cg_read_key_long_poll() for waiting on nr_dying_descendants
Message-ID: <3p7o2cxir6yz4baonmkrzumklg5zx3oddhi7mqlmxu26j7ze33@u2mrvj6pqad4>
References: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
 <20251124123816.486164-4-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124123816.486164-4-zhangguopeng@kylinos.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 52AA780006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: sgkeszyzmrk97ddyuu4afrnrhxkmgcpj
X-HE-Tag: 1764717534-149593
X-HE-Meta: U2FsdGVkX19E2hKy3iOTfTyZ9FFARxMqAB/rz5lH+pduT+ya4O4XB/iuk+G7iSp365ViDnuOD1e7dKAwlYdOI+NbztCENT5zcBG96d4jdnzXdVU0j5Epfm5oFkqIGAa5OexFMCmmkIyqoqr3WR8es/+fADqTXjviga2AG75K+lpt2elMvJTqP5KZbt6uV3SFJ7MQJ+oQKyHSeNmS/6TwYNKKkTd6bYES2D7d/wABo181JkNjb1T+Id88+ct+dIO7+9pTgoxEt4OLWw6LzmClGfJIv6d3Nn+GtlQXdplrqm8G5Tlm5WnSu+ol28HHCHcLGLaA+uzR14LnOtwDokhQ8jDN11d4/vvN+w/pNRg0jt0lApEHa4+2FQCH04dBG7dIMGC8dzhLf7t21SHFyQjLTLiHHk2C93zIVM19tpMsQJLGs97PgxAv0A6UXNvwOeMrmXemlvcSsaEowMKDOFNKlXIyOVeR0h2eX2ilWLzLVuAbFPbu2lcdGXqrCkAagZ7Uf7XuVSiv0PnDqJ8jUzVYCwWrAqJX67Qk1yvH8b2n762PI9JaCShYjzU3ek+gv8yASF9fjVAyVJv8KxgtxDqAncKC8urvw8qBEBwhGtkJZdFunokhUyCpCq9YMobN2af7ezAeUHSryOiEuFPNJIejyuE8eD9RUw+TBSHyvz/4qL4sd0jPSeVAsuMFz+d/zjs9gjfiSWWLqQgrCttxcJkelyDyOa0F6zi6LLC2ghJXOvH6k5kzd9zPvWERadZ4x2RwG9StM+O0Z+CGJVOrq0lSLOSMPHfy7CVDCd2ActBEkELhZQCiy/jnvl67O1WFJbRhDDxOr4jRBlWp9Wxh+ckH6cTEHkgqgW+zJTFwWyo77ObTmSUGNUwW0OBBqGbE2jhtyP4Wu60mdReGFhGNXLvf+cXEdlHByBBzHWFhu3Um1BhvTG9vA7sjyAUoKZCStNg1aDiGBeUnSgwIDOtmE9/
 Rj6KLvFi
 DVeIyI4EJb9yHSbnSm1/zvLsMcxkty5k9qfpF74KL3B2S7Qa79Vf9YlkHREVzhH1tpFcQ9foOrvF0p/BDWvTMszTPK/ZWItLs5sQKrTIAWa+doZN+AHaZuhQOkWOpIdqz8NSbChFpOmoHN169/irKQVYafPOnwGq9+rc2vpflXcBjus+iUwLfCDgvitS0R5IzFZIvItugOING9vbzpGKHFNM9Vr8sZWxZp87wweNOegQcNgxnz/4cYgDzx+QWlEmoZi1O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 08:38:16PM +0800, Guopeng Zhang wrote:
> Replaced the manual sleep and retry logic in test_kmem_dead_cgroups() with the new
> helper `cg_read_key_long_poll()`.  This change improves the robustness of the test by
> polling the "nr_dying_descendants" counter in `cgroup.stat` until it reaches 0 or the timeout is exceeded.
> 
> Additionally, increased the retry timeout to 8 seconds (from 5 seconds) based on testing results:

Why 8 seconds? What does it depend on? For memcg stats I see the 3
seconds driven from the 2 sec periodic rstat flush. Mainly how can we
make this more future proof?

>   - With 5-second timeout: 4/20 runs passed.
>   - With 8-second timeout: 20/20 runs passed.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Anyways, just add a sentence in the commit message on the reasoning
behind 8 seconds and a comment in code as well. With that, you can add:

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

