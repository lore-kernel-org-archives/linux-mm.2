Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D59C606B0FE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ikXvDapO
Received: by kanga.kvack.org (Postfix)
	id 973D16B00EF; Mon,  2 Nov 2026 09:33:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94A046B05B2; Mon,  2 Nov 2026 09:33:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8614E6B05B3; Mon,  2 Nov 2026 09:33:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7436B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:33:48 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DAC56120137
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:33:47 +0000 (UTC)
X-FDA: 85390422894.16.D340C9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3DC53A0008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:33:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ikXvDapO;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793630026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+VBk2hdhwXO8szEGD9UTxz92a8YICR7g5qxYYzqkKWQ=;
	b=Rgnu3JE94LwQQei7w71Sz7r9nykj7fFVde0xzr/p5YMkrz64uhxK5kK1RE2DKXs2hATikJ
	r1ewvLQ67FJte9umsdTuCBCeFB0KVPRCOt3FDQqyW6u7ko+/WvecvQFlmoU+3+uzei6Eoc
	2WPyquMGHOkC3u9zoBtbSbB1Wa/GzzU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793630026;
	b=ERBr25/orvfW594988EDTvkJ5tymYl2ZBjhv0XgI4QPEc0PBJaiPwLDzJMV9Pq+1e4jw8s
	/BHlysMwtZ+iRZAS73MNvV40miJSlb0Q62wAvCN4T7ns6eVvUAfZYuyCio5sImX+3S1il/
	U+aUG1us9bOFLk9miTW4Nc3kIjgC65Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ikXvDapO;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B9494600DB;
	Mon,  2 Nov 2026 14:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027CA1F00A16;
	Mon,  2 Nov 2026 14:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630025;
	bh=+VBk2hdhwXO8szEGD9UTxz92a8YICR7g5qxYYzqkKWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ikXvDapO6W9ZeW/A3wJsYfsdPuZwHI3H6LV9ZWqRIupnrtTe4LG9YmSY/Znif43ww
	 MymWgELuK4BRPZtPItmDlHu3VH07iGWSR8cZdsdoUe73ORWJjxovO+MG5y3ZxL/2Bk
	 bGgv0DZikHZlbS73Ni8Knx/8lbqwvXHo+wmaVR4JJefVH7ZzTfWb3FnwxfcGPyP8Ib
	 k7v++FY/xWfD6pDfirYI1RCUrETldZuzPyVWx9HpNBDiJiIaVBw7nsG/dIqemJ3kon
	 DhR3LQyFCT0bD02xOnVW7AwrRn5aXoKyzBi852JIl8bie/9uw0nXBHNmm0PPer+m45
	 rlNCPHVOb4HqQ==
Date: Mon, 2 Nov 2026 14:33:43 +0000
From: Harry Yoo <harry@kernel.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: vbabka@kernel.org, urezki@gmail.com, paulmck@kernel.org, 
	qiang.zhang@linux.dev, akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	rcu@vger.kernel.org, linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH 1/2] mm/slab: restore the rcutree. prefix of the
 kvfree_rcu parameters
Message-ID: <auiedkWD41Ok95TT@thinkstation>
References: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
 <auIRU802S4Z4yAmo@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auIRU802S4Z4yAmo@thinkstation>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3DC53A0008
X-Stat-Signature: y5cubfn7i8ymipss6o8gzue4dgb4bct9
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793630026-491604
X-HE-Meta: U2FsdGVkX18LBm61O1U4NuNJKE8lKTB+GAQBCJlo2CRoNr8iVp0Zr3Nsfl6VDgKGMjMUm+bzMsSaYB4/vkCqbmP9J6kygn1xgX/NZcJEKQtpLGb4yZf3D4FlTVYvpTKc3OJdetlP53XPrrE1dYb00KiVx7GZqJF49WbOFVCyFF4qILUO0pBNrsVst8LVVQa9IHBR+Ru+d9HUxgGlFdFSTnF5gyuOX+VWjUctBBKGDv/kyIhPbCsPE+q7lAIY+whHE/0H1MFXszxgl+obbSPmJ+jKceBD3PMR1SChXXe/kUvY0IitEx9kTbrfNYgYf/8h+HoOvBSIGVsjO28HzJoqSX7YhAWTXaxQyk3g+N0jKBZJqFZmbLoIZSyKxA2IEF0k1fGL6rPoJsTKLSwzFT2jjk0EfVJCMzEdWQa9BS1fVv4kkWX43Gn6OzFN2A4MszJB+uFbsIJEvVTqy4a/bNHMMix+Y9uPzd7CWX5cXBrd6lTXBbvVYEhIluI45FlWgk4atFB+9MoaHuMC3ym7i/Oo7RDkoIYsGEy98bx5paLKA2yh6y8i8fhoar/vbQQEonZJ8d1oDT3uMKd89vzTryh6o1n7Kb2D3y6HoGySgcULqGAvfXN09uCZch3z9BjpT1cwI+r1NISL0CSwGQ9jsjeBziWNdROHCazCLgUUzCp+PR+sQOl9JXdVQoFL11J+sX5LwRc9d5uCM2ShC1L6dgw35vTJ65MsGTAUsGrpwYy3aVoexthTFLzfxEvqxBI41xEHfZEyNszLGBBWkvH9Fm0yRuaaOfObK7u9cdTAJNrjYOJY/kuQeOcJBrXhnsFdE2TbDab+5/EqVhRkE5067kGgQ07AjxpOXX87/CTTPcddMCkwRBRYewsLZRDe859EsKhNJmYadiywjFXhERg+lKNX9JWB6osNdGu4UVdmZOuojfuMfnavtX2my9Dh1PXT1IcNXrMSDL5UHmS2ZJ3l3io
 Cs6ljRRQ
 Uf85DsDvpIDe9cNKPZJz6bJvqEQvjLDPybEjYpyCauRWXM2KL1Lz7P91tpprdAnVi/O97WwKgDM8SuvIZENiKpLksQ/sb9TI+X14VEEj7m3f7RhBnoVJM3tVr07voGqV2VtuJQEFpHtO2vscSNBtiEI1+P34xmFSbNfRDYgCkg99wMmxJWczjz7HW2xsjwbaoNNFyIpPO1qYlQQGb9T0N0IwRPZtBEWKHL5q7Sz052vlD21rx2FEDW2WR7Y2N7dP9kUc4rcwfaNxm38ZpjFA7+3bpTIFcs1z9m+O0avhQEK9vONBToezFNeLlvgx9fCNSkjRayYfriQwLcx6Si5vxnGDqkrwGLWJUSB984fE6krhhnL87rNU2Xt0/pPWNvC0NF6WlzUb/B65o7X8h0nc81fmEc+6aMdZAeisEAHd3k5dmbU5j7Ri/HPsDNG0wHthuPQrJI3z1acH4Ec4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I adjusted my feedback. End result:

mm/slab: restore the rcutree. prefix of the kvfree_rcu parameters

The move of kvfree_rcu() to mm/slab_common.c dropped the "rcutree."
MODULE_PARAM_PREFIX, so rcu_min_cached_objs and
rcu_delay_page_cache_fill_msec became slab_common.* and the documented
rcutree.* names are silently ignored.  Restore the prefix; the
slab_common.* names, never documented, stop working.

Fixes: bbe658d65802 ("mm/slab: Move kvfree_rcu() into SLAB")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Link: https://patch.msgid.link/20261028134647.3176080-1-zhanxusheng1024@gmail.com
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slab_common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 01c64ef661e7..41dea01a8c1f 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1367,6 +1367,10 @@ void __init kvfree_rcu_init(void)
 
 #else /* CONFIG_KVFREE_RCU_BATCHED */
 
+/* Keep the prefix inherited from RCU */
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX "rcutree."
+
 /*
  * This rcu parameter is runtime-read-only. It reflects
  * a minimum allowed number of objects which can be cached
-- 
2.54.0

