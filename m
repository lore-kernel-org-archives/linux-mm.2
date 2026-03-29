Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA7B9F3D5FB
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 454AE6B009D; Sun, 29 Mar 2026 11:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405706B009E; Sun, 29 Mar 2026 11:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 342BF6B009F; Sun, 29 Mar 2026 11:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 246B06B009D
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:34:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEBC11404C0
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:34:10 +0000 (UTC)
X-FDA: 84599496660.07.5441662
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 530FF140009
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:34:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BclJe7UX;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BclJe7UX;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774798449; a=rsa-sha256;
	cv=none;
	b=NS+8yx3B59z1XQ99F9B3KmvxTrl82Kl093wTli7e/nNgt1Qw4GmW+htUWVZ7Se2DXQfN6K
	INdruaLYoOIUXq6qq4cVFcoU0witWbPo70vijHo9BnCh+5X4SJ3DMnaH8lTGcWT90MZeca
	lS71anA8jJghm5Tt/oDxF1mv5GiN3tw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774798449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTTSFy3ooK8jjlea3QojN/WpY6b9EVd/Woi2IQOIKW8=;
	b=eftf1i0gA84S0CsL2ou1KeZeNlgscPiDGMd6KHgwK5266PcZf/6XnHrrChQ4OJ+JL/DxIP
	DOxS1vbFSVr7gG/W+Wej89pLOOUB2wTGZUhEwgpAowhj+GuNgi04Yw4t/yaIc6x/U2O82E
	5gg0EkQ8sMx79y/kHTW8+pxIszFcIhw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C82CF600AC;
	Sun, 29 Mar 2026 15:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFA9C116C6;
	Sun, 29 Mar 2026 15:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774798448;
	bh=O/uNR9JRfm9SAtj0sIMwVCHj3HMc0F+KuWfakAn3bz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BclJe7UX4PJvoIUgHUpvGBjveSkdKutvAgrqYPN/Da+DQ3gjmhQdO28N4Exh1rYNE
	 Y7O5dHFS4GkWE7k6XZwAFmAUCFwUDHmjhoExMrt52o5JXyZFwMjh/GlAyw6xCAXh++
	 Yl7dVxasLJhVUOUtKmBOMj5WhTlrgHn4vf+G0k/r6eR49WQnj3+5Rwy7MYbdRqowEm
	 5ojRUyrGR244pg300rfIhhOk5DxqKPV5ODOnQTCFsp1uBE30TNdS6khe7uEaabloaF
	 cdPaS6d9WFTgVoJNCh9JW2ZSw8K+AHS55ztyf6L39F2ICY52F00l0aeTy8ryGFVo3D
	 SfvjDEz7EbVQQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH 1/2] mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
Date: Sun, 29 Mar 2026 08:34:06 -0700
Message-ID: <20260329153407.46989-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329043902.46163-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 530FF140009
X-Stat-Signature: qdozqx6718do3z4bbjixgxapqrkfted4
X-Rspam-User: 
X-HE-Tag: 1774798449-494567
X-HE-Meta: U2FsdGVkX1/99zauuN21lgfCP+fuYPTmI7d6a+wwHfMoLiq50mBO4+LE8VhJj0TMmRtjsMJ/xy/J/3xusxWBiC9IZq3YU1Gw6QdBqrnxta6ynBQLGPg7w7dGs8vBB7liRQNciLHX2GP0EKPm0/9heZeu8BsF1U0LPHbUtjH2/0UZ200vpOyM8NNp7NbyBUKF/otJoHM1pfuXpcsp4mk00vuhNJ+vHFdL1laeatPi2it5qvuu/mQhcNy92Jqk5zm2PHEwlFljseUgkcv7od7ZMCUeXU4cI4GrbEJ41VnnxtZlGhz+/BvFJLHpOdDoySDIZ3wAGWA9ovd6CPj2jjm80M9rW2GhIfmpwc/VUrWVLRZusAqlY2oow7qs5hSshEmx1xkZaI0bnmc2LL3O+YbdPSG01Lca2X+eeznjrGCqo1d5WiQk6qjRjP9+2TlVs84PLjRehdJLkfcMVgAXGx9m/mRpRkTf7Do/jljQp70b3q40wUgAmv64C0bxsUP8Aq45ttUm1KDvOge8vugs0zXUUNhGTSN5TCdvTCcNs9R2UdscnE4e0T8cRF5omUN8FU4Y8MFHcZFNflqM1wBUYoG6LH/fiFV3i9mQAsz5TRbdRlZiA4ROXqjSjYE1EV4MTx4IlMYgEPq52C4pW+n97MegDO+XYyqoVyasEROdq2YOlkOevtSULxWPPULLdjivACTqqoiHQjK7B5N2If/PKiRTgZWjxNngmZfdBU/qsfinXiOhX9KDBDkgot6GQRixEzP6RbseBcpG5KOWLdIliR6M+tBu7kWZ5F27TyObo5mvlUCfLsl42f8SoiYYni47e6sHo8xP4M8pdwF4iMrURtYQGmvwG1i5r7sLfYyj6x24q39B/pq0sM6A4ef5s5KOYV4BOwyYRernSrq8Nu5vIFzaM1uHc5yVykUEM5Wuu4GS58mOVdQUaVzBvompOach3FVmNF5WxZlEMXVDNutqDj5
 lAzQiG5b
 Pvd2K1xgeb1xcRn0vS9pm65rUIqvkAd0OogVpYiUnFHZwygXxTj2J6W2s1MupwV0s8bJn37OitjMRevBr+5glssTKlL1ebpl3/lwN9YQCEAwMFcZr8D+008wcbx2uCIj9KgsUOakojrATuOgyTp4Va5A6Gaep+z0PriRpL55hugYz34n27QoKEbx3huuj+B52Uz0Brlv9ShyoSGG1s4i0cU+OVUyZ3aT9hQC1F2DdEM9C2Sl9GwX4Adv4Yx+g9IpsV1FnAo0tOAJ3DCzBNknV3JdFwJU9V7VdSnNTL9OzZUYkmS5nYCS0SFSalcQX5NoFs5Ho66JQngZ7GlbBZ34nD9xLdsVVbFGfJ7rG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260329043902.46163-2-sj@kernel.org
# start of sashiko.dev inline review
commit 8c40c45c57722526c25cf1114b386d19a693fc2d
Author: SeongJae Park <sj@kernel.org>

mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp

This commit adds validation for the node ID in damos_quota_goal to prevent
out of bounds memory access when calling si_meminfo_node(). If an invalid
node ID is given, it defaults to returning 0% for used memory and 100% for
free memory.

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

>  static __kernel_ulong_t damos_get_node_mem_bp(
>  		struct damos_quota_goal *goal)
>  {
>  	struct sysinfo i;
>  	__kernel_ulong_t numerator;
>  
> +	if (invalid_mem_node(goal->nid)) {
> +		if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
> +			return 0;
> +		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
> +			return 10000;
> +	}
> +
>  	si_meminfo_node(&i, goal->nid);
>  	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
>  		numerator = i.totalram - i.freeram;
>  	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
>  		numerator = i.freeram;
>  	return mult_frac(numerator, 10000, i.totalram);

Does this code still risk a divide-by-zero kernel panic if a memory node
has zero managed pages?

Even with the new invalid_mem_node() check ensuring node_state(nid, N_MEMORY)
is true, a memory node can have present physical pages but zero managed pages
if all its memory is reserved early in boot (for example, via memblock_reserve
for crash kernels or firmware).

In this scenario, si_meminfo_node() sets i.totalram to 0. Since the
mult_frac() macro directly evaluates division and modulo, passing
i.totalram as 0 will cause a hardware divide-by-zero exception.

Should there be an explicit check for i.totalram == 0 before calling
mult_frac() here and in other similar quota functions like
damos_get_node_memcg_used_bp()?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260329043902.46163-2-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260329043902.46163-2-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

