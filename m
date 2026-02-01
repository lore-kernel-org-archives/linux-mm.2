Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53DE6E7C6F9
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 00:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F236B0005; Sat, 31 Jan 2026 19:10:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819206B0088; Sat, 31 Jan 2026 19:10:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B5D6B008A; Sat, 31 Jan 2026 19:10:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 607456B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:10:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F06EB13BBF5
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 00:10:54 +0000 (UTC)
X-FDA: 84393957228.30.6F4DBCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3DCD9140002
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 00:10:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HZPRwdjq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769904653; a=rsa-sha256;
	cv=none;
	b=0pBpoJ4rfqVswB4sWa50YW4LF8sxTpMcfYgkMgWzTAqjpDK2vndPPhMGJukOoWlaK3du9o
	p1j8QoCDxjh/ymWJC6ujwt30cIlKXFfM+vLV8yMH/48iws0knJ6yKZnojohIsdMBMf5L2i
	/EWX6RKA3nFSTULUsJQx7nRrIj+ty8s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HZPRwdjq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769904653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+9nH2SfyPpXQdVSnM33OFp4xaFDuvRVZPTBd7l7Hu4=;
	b=V40EBpu8Y6JgAgV6DLyQVJc5XlKJc8nxgAqrmJ9S5XYAL3pwg/iEgLXS8Ka62YDDSFR3XP
	guE2e/33gtVi1yxD3QKOfXntYgdyvL0vnULhNtxSDtznehkVtlC/DAJTPISD8fC9P3NsK0
	iTtONmrPP67NGmB0zGAB/sdHOAYwUiU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 06100436FF;
	Sun,  1 Feb 2026 00:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85585C4CEF1;
	Sun,  1 Feb 2026 00:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769904651;
	bh=kQPODrUPiUY8ypJn9UfaCgFiYZn8Bv06jSOIpi+1vNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZPRwdjqd7n51HsggBZHcRVQhVZcoHGaVm/A76ifsFWXIUgfeox9jNYRIygd5ZJmi
	 fRMOOnUIhuwoxNnA4s1OmUx0ClDPHqwpjmlzAcw0/HhxWXu4cYdUWwUx+6lWw3geZq
	 I0XWjzYWi5teATSCzv42KzGXruNdU74PSejVu28MQQiR7mhV0nuUHWb19epJSReB+V
	 wNMOBuGBUelGqLxbYZOIw1E5KrNsCulOhaoc2/BRVwnlNRuE0TvEKyAQEiMxhRjKgC
	 M4dxaW5TukrVdoWMgUYxEDUu8rLZ02GfpWHZPbTDRPmsQSQknv5xHShNv0dpchRYj9
	 A+y4cc1DxZ6eg==
From: SeongJae Park <sj@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Alice Ryhl <aliceryhl@google.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH v3 21/30] maple_tree: Add cp_is_new_root() helper
Date: Sat, 31 Jan 2026 16:10:42 -0800
Message-ID: <20260201001043.88706-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-22-Liam.Howlett@oracle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3DCD9140002
X-Stat-Signature: pu4dpjefbsb16xp8knbemn7uesni5a3t
X-HE-Tag: 1769904653-543793
X-HE-Meta: U2FsdGVkX19EohTsEl66gcMnJI/c6ZPCSAfZfF5v8qjhTnYhW7axfmNWQkktQph2RPJDrlJfRGQDbqzMXdXg5Lzkd7i8hVG8FRaJxXSgVpJcPk02TNC6j50RMymInCqyHs+4WfkTg0ZTm2rjElnP9KMrJ9W61T9QgSG39awtNj741q5nSArDQrk0RqIufN+l3yupvcAAfG0RqG2VDLEmFqLbp5bi/zCht3IuQLET/3kF34EqzMR8nMygdeP3jN1Pmvzr01mR3IbAJPvWM5kTY1yVIP7KnJCTppamY2yXrooGB7jQl4MWTi7bcOVbC/WD+C34hH9RuHEcRuYNlrWk4Tv3rKN5sI4yollhTl6iNoS1w4z3CTe7aR98FUa9NmDDOIzjuyb1/IlwoNUvwWQRHjVEt1P5LhxSdDSpk34WivuTePC/HSEmFkmNlnxc9ZdeEq7qKMAyESmtJYW1D3IMiayfb/vI+Lez1tt4e+6J1m+46YCo4ypZELrz66xgk57/NITrHpIh4QE3m3ssiUfzRIzIVFkcupiQP35xA56JZ65QxXZpnivLYQYBRZGCy9pOZt2JiQ1EHIyEPq2mvp3dMwdHGqBaMM1boiZGs34LTHQkPLdX6T9C1kG2RRQTSr4NZnkj2mXigL0DalKdqNbN2r0wTNCPj9TjUZbMePIQJaB3AHyVSzGT5RY35E/geZ+AmDOUPkRXYov6KGKSTnd6MJggOY/B+JNrTUEmuI7oX1o4l5gokfDGCPNbJYjfpSP2AnQZdrad3PjTJOTPXAC+G5sZ5xMFn7JqGinolLtApl4b2u7UuvDOkYaGUneluoiCg7Bg6CQzthLoW43tzYEqdqqPUlY6e+WGR2elndp/B8GUi3MNH7vRydVajW+w81p7AsKmFWKlEfJJU+5tp3hwkcjmD+2nMDqVb8F3JYlSxznRN/hPQZWp4kyKsYcFY4k7V7YDHrmiHaCNs/apcbs
 jjfgFV8q
 AqrpJ2p/3cEnFU58mkZo9Zwp7gXOCl8AGpYhLYqqJEyXVN/EcBY0hkVBuCl05Z3VUblPxC6NzEuj1NKwAcNoD/0bQnb7tYDstpiSmOEtIuHf5gWerVPCrlgLmwdGYAnoS63THVV/7owgMABh53oOoMUiucJUG2bXT+Ty/gSu9BbFj59bsYPd93xTEJfxk3UYtA9rlSf3Np8g0+OfQA4UoNoNORqhCNDwLGbx5kzZXBruy5zKZ4abKR3SCfiLuE3GhxdsocK3pt0v+nCBFlsJ6StbA/j5TECfnYA5RG2qq8l3lvXw/K983BlYOYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Fri, 30 Jan 2026 15:59:26 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> Add a helper to do what is needed when the maple copy node contains a
> new root node.  This is useful for future commits and is
> self-documenting code.
> 
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>  lib/maple_tree.c | 70 ++++++++++++++++++++++++++----------------------
>  1 file changed, 38 insertions(+), 32 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 5280fa6d2d6ec..42038e42a4c7e 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -3337,6 +3337,43 @@ static void mas_spanning_rebalance(struct ma_state *mas,
>  	mas_spanning_rebalance_loop(mas, mast, count);
>  }
>  
> +static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
> +{
> +	if (cp->min || cp->max != ULONG_MAX)
> +		return false;
> +
> +	if (cp->d_count != 1) {
> +		enum maple_type mt = maple_arange_64;
> +
> +		if (!mt_is_alloc(mas->tree))
> +			mt = maple_range_64;
> +
> +		cp->data = cp->d_count;
> +		cp->s_count = 0;
> +		dst_setup(cp, mas, mt);
> +		init_cp_src(cp);
> +		node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
> +			  cp->dst[0].node, 0, mt);
> +		node_finalise(cp->dst[0].node, mt, cp->end + 1);
> +		/*
> +		 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
> +		 * documentation.  Since this is a new root, there are no
> +		 * read-side operations that can view it until it is insert into
> +		 * the tree after an rcu_assign_pointer() call.
> +		 */
> +		RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));

I just found the above makes my build test using an old version compiler fails.
Fortunately, seems it is same to the one we discussed before [1], and same
mitigation like below attached patch works, at least for my test setup.

[1] https://lore.kernel.org/dwhxxuil4zkesmyj6xviyyyfedrcd65h6qd4bplmcrsg36purj@f523i7t6nxag


Thanks,
SJ

[...]
=== >8 ===
From ecc4e468d72c431d53043c8a61fddb6ddf2ecf7c Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Sat, 31 Jan 2026 16:02:56 -0800
Subject: [PATCH] lib/mape_tree: temporal build fix

Without the fix, build with old compilers fails like below:

  CC      lib/maple_tree.o
In file included from .../arch/arm64/include/asm/rwonce.h:67,
                 from .../include/linux/compiler.h:380,
                 from .../include/linux/array_size.h:5,
                 from .../include/linux/kernel.h:16,
                 from .../include/linux/maple_tree.h:11,
                 from .../lib/maple_tree.c:56:
.../lib/maple_tree.c: In function 'cp_is_new_root':
.../include/linux/rcupdate.h:555:36: error: dereferencing pointer to incomplete type 'struct maple_enode'
  555 | #define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
      |                                    ^~~~
.../include/asm-generic/rwonce.h:55:33: note: in definition of macro '__WRITE_ONCE'
   55 |  *(volatile typeof(x) *)&(x) = (val);    \
      |                                 ^~~
.../include/linux/rcupdate.h:1046:3: note: in expansion of macro 'WRITE_ONCE'
 1046 |   WRITE_ONCE(p, RCU_INITIALIZER(v)); \
      |   ^~~~~~~~~~
.../include/linux/rcupdate.h:1046:17: note: in expansion of macro 'RCU_INITIALIZER'
 1046 |   WRITE_ONCE(p, RCU_INITIALIZER(v)); \
      |                 ^~~~~~~~~~~~~~~
.../lib/maple_tree.c:3364:3: note: in expansion of macro 'RCU_INIT_POINTER'
 3364 |   RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
      |   ^~~~~~~~~~~~~~~~

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 lib/maple_tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index c522419e99f4e..eb2855269332a 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3361,7 +3361,8 @@ static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
 		 * read-side operations that can view it until it is insert into
 		 * the tree after an rcu_assign_pointer() call.
 		 */
-		RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
+		RCU_INIT_POINTER(cp->slot[0],
+				(void *)mt_mk_node(cp->dst[0].node, mt));
 		cp->height++;
 	}
 	WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
-- 
2.47.3


