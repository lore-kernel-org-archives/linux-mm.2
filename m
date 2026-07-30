Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3255CC55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:10:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2D86B0092; Thu, 30 Jul 2026 07:10:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193736B0096; Thu, 30 Jul 2026 07:10:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05C936B0099; Thu, 30 Jul 2026 07:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D029A6B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:10:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7503D1C12DD
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:10:37 +0000 (UTC)
X-FDA: 85045174914.12.D068A0E
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8F5A620009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:10:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf03.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785409835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SG3+Ctiv5CBMt99JWya+IGV0CdVdoS8KCsUDeNPa2No=;
	b=x+kg7zLJwtafrGZ7ihrFiiogp0cNCPB5CCwiH218/sy/sA41uwQU7EvsqPJ78aEwfIlXZ4
	bxLSsZXrUoeQKD0QWrSVQt1hMvmhF8lF95rxPme1zbyJAN246LzsdiAgLsIi6/R27EiHRN
	namg7Gu3xhk0Onj52SG6VQBCofNlCf0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf03.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785409835;
	b=stAO89yGJfUQDC8582KUU0eZJ3s/6lBkASjvRcIk3gW1StiUMLN1VQhGQRkF5o/yJ6sRnS
	g0I2dyEqM31JlQzmyf+AexAoANGBFMaA01CY6bbHDha86Z4UtWfC4HfAwtm7vN34LX2hls
	lV3D9YxFXd9lQ/UUuo/7TNLZbUKz+n4=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4h9mhN3BGgz8XrrJ;
	Thu, 30 Jul 2026 19:10:28 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 66UBAIxs066128;
	Thu, 30 Jul 2026 19:10:18 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 30 Jul 2026 19:10:20 +0800 (CST)
X-Zmail-TransId: 2afb6a6b311cd3c-c8b39
X-Mailer: Zmail v1.0
Message-ID: <20260730191020843srkTQnCknZzmYHU694CZi@zte.com.cn>
In-Reply-To: <20260729-kfree_rcu_nolock-v5-2-a28cdcda9673@kernel.org>
References: 20260729-kfree_rcu_nolock-v5-0-a28cdcda9673@kernel.org,20260729-kfree_rcu_nolock-v5-2-a28cdcda9673@kernel.org
Date: Thu, 30 Jul 2026 19:10:20 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <ast@kernel.org>, <andrii@kernel.org>, <puranjay@kernel.org>,
        <ameryhung@gmail.com>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>,
        <rostedt@goodmis.org>, <paulmck@kernel.org>, <frederic@kernel.org>,
        <neeraj.upadhyay@kernel.org>, <joelagnelf@nvidia.com>,
        <josh@joshtriplett.org>, <boqun@kernel.org>, <urezki@gmail.com>,
        <mathieu.desnoyers@efficios.com>, <jiangshanlai@gmail.com>,
        <qiang.zhang@linux.dev>, <pfalcato@suse.de>, <surenb@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-rt-devel@lists.linux.dev>, <rcu@vger.kernel.org>,
        <bpf@vger.kernel.org>, <harry@kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NSAyLzhdIG1tL3NsYWI6IGhhbmRsZSB0aGUgIWFsbG93X3NwaW4gY2FzZSBpbiBrZnJlZV9yY3Vfc2hlYWYoKQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66UBAIxs066128
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 30 Jul 2026 19:10:28 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A6B3124.000/4h9mhN3BGgz8XrrJ
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8F5A620009
X-Stat-Signature: s4wehypd4sm57nauksx3f9aibcgh4cpw
X-HE-Tag: 1785409833-682837
X-HE-Meta: U2FsdGVkX1+hcXkKbLGCpmIb+9S2gEV5pc3Iu/q0Ze+1b1DF/TVUyz4NnNVSfRlrQr2Wl6FE/HHp1xlA7UPZLKLattpOpLENJJcN9Q7qKtu7v3MSx2bBFBa4/NGSrBcLQVrQJJZcmBqmV62Krh5Wrbfn1caGI2kWx/faqTm7tD4P9VaPegVZrlbmN8jpubUyG+cQvQ6gdDpPqHwC6x3oCjKsz2kNNRp/GZ9Df3FqrSwpsAM2Cn735w7elHB+BO2OclwbQ0iozvC56GNwh5HLD9aPWdvD0wHWF/BnAtj/BgV4F0ggn8je2xp+YtO0qECJpXSwrjaVwjgZv9TMp9Yc6EJAkP+qKCEe3AJelFKNiteee579GoL8kYx7ZORleb0B7w+Sn5kvsr7N8aeup43kRNxRCClMoiGgf9pGTpv7MNOwmWwbfH2TTZdjFiNi4jOqVI7mXg69iMKg78IYgdpFPG/w9hVSzeEqOI/HxhCBUxQnw5v+tud873KRrjJKJjR/RHF15vc3bcZSwAOKFpmDxJ29TSs8BOF0ixnSzcnA8Q7sp+ZTVAetPwxEfEBWnHoi12x6P1NfhY/s4iEbMyAdKMSpyAxQBdGBcLIrB9Ug+66bMyQIZGall3EbkxyoV+p9G315MUN1E4uwXw8UFjmf9Ff3SoBWX7eUwhqh06tFYrhsDKBD7/NmTgTyY9bq4CrKn7k6oLPqmBe/QvdbfJzdQvLkZSy4DHcA96A0Uc/1bm2mUUA22xTqjbkxcz+Zw/06xFWm6G3apDcN1DSvJ6M6/+3IOjnEjIB7TEpTV+TpMvohtYjJOgMj970RKGrJY7K8FiaLO24/zgOREShdyIjfLNF+C24kspX3OtldBdXkcNOtLsJW6OVVTUFS8YzuvQxrsYQ6h6FZVLv7tcdnDf522RcFUYQu+QxrmUCG3G4q8jtAiMgQWFPCa7ZDk3rSxmplxju+eCB6WjPJHAj4J7H
 RT8H0LjM
 269tF0ZUbSHF3s/cFjaM8Es41Vj2f1u05H1htk5MyI/fp+IHtXvN3i3iyggOrP6uyNJoOtgL7IihivX3+aFyym5cjM8usURp85sQv1fbeocRbGdGUhgQ8g06oyyd4kss/DkT9CCSMqvIaCBEcHnvi3T6rUUWhKUYbIUsCoYWg2ut5WGGi4G2r3QQH8Ed2KtDZuLpR30Ev59zWF6evB/ahb5dj7bTLp20ciBsUQQebSpNl01eUyO25u85yDbqFtkszxBNuUpCTkoL9myQruIhQ233yneCizx+ktqKuAv/9cyRhDOWcYBEBsJC9Sbq76Sz94MPRYojFpejz/ls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> Teach kfree_rcu_sheaf() how to handle the !allow_spin case. Try to get
> an empty sheaf from pcs->spare or the barn even when spinning is not
> allowed. Unlike __pcs_replace_full_main(), try harder to allocate
> an empty sheaf because the fallback path will be more expensive than
> kfree_nolock().
> 
> Now that slab has internal alloc_flags to describe context, introduce
> free_flags analogously and convert free_flags to alloc_flags when
> allocating memory in the free path.
> 
> When trylock fails or the kernel observes non-NULL pcs->rcu_free after
> lock acquisition, free the sheaf instead of putting it to the barn.
> This is rare and not worth complicating the code.
> 
> Since call_rcu() cannot be called in an unknown context,
> kfree_rcu_sheaf() fails when the rcu sheaf becomes full.
> 
> Link: https://lore.kernel.org/linux-mm/872bd673-3d45-4111-8a41-31185db3ece5@kernel.org
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>


LGTM!
Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>

--
With Best Regards,
Shengming

