Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91E58F34C63
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 16:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0865E6B008A; Mon, 13 Apr 2026 12:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037066B0092; Mon, 13 Apr 2026 12:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6746B0093; Mon, 13 Apr 2026 12:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DB8CF6B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:44:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A762B16024D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:44:23 +0000 (UTC)
X-FDA: 84654105606.19.4398B2D
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id BD91E4000C
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:44:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ehz/0s4n";
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ehz/0s4n";
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776098662; a=rsa-sha256;
	cv=none;
	b=iwjcLRemxV/e1xAJOjcAP5DQzpUp8NtR2rLb+PTEF+TjHVnGT472hPzRllRlHb+VyO0xWX
	Fgn1GOwRvgPMNafoGODgJ7c/aAMWv8qlPJgJzEUTNGdyPQT1xdRX+46KvoDTaT8KKmmqwH
	fuDfxt6vWqwUTO2SPkRWDcKH1i8psCw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776098662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGD68R6Uf2ICmpKMNcReMOAnqjM0xbCg+mOS+G4WF7w=;
	b=HFZaP0FFE9vGjNa9mu+75aiVPnB5KQ8RGu8pGcZ3/+1FEnu+VZ+pENXExrEzsq9wTWaNN/
	3ckB9ugnepN7WGDmPZ7WEqhCachDoWqrxmESHXtnk/71N3SUiiCXsDI5xNqeRBGfmm1kJg
	dny35GuMhvUygivJiG6qJdzgq2EHL0s=
Date: Mon, 13 Apr 2026 09:44:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776098659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wGD68R6Uf2ICmpKMNcReMOAnqjM0xbCg+mOS+G4WF7w=;
	b=Ehz/0s4nbqoB9CGWCN3L7jXsJGgyREW1oQeAdzzWQFJFw0dMRCGLsNZUvGNBNiudpCqSIw
	mZu/ZZDPolx7I98I1SkSzYq1LeNPLPC4RlBaIOzREx9xxy72ByOHWQ+nmyyxJtlvX2BPcm
	OK2sR2tA1Es9QNyYOBhkeH2MC3z4wMM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Cao Ruichuang <create0818@163.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, syzbot+1a3353a77896e73a8f53@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/memcontrol: restore irq wrapper for
 lruvec_stat_mod_folio()
Message-ID: <ad0clnEYxf1H4_S1@linux.dev>
References: <20260413064833.964-1-create0818@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413064833.964-1-create0818@163.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BD91E4000C
X-Stat-Signature: mgyoseo7xip3gdhruwmkzzejefkhx7n4
X-Rspam-User: 
X-HE-Tag: 1776098661-894606
X-HE-Meta: U2FsdGVkX1/YBq+MZ8jHKqgxLBEBEqEB6/mywm0sGExws0pGwzVhpNmqX97odNQYQJ1TzUxdZ5MY0osHLipb9WuKH0ke90lVPlQZ7rP5UEHH4aJPkGVACAI3+va8gOYpIxMmR4HkyQ3j/kVMugcVNFnrMrNcBC9SBNQjg/FSHM9Xbz6OZIq2LIdAjhzeiV/eOlT9T0hd6iP7AT4RP4Ci2RdxXIPjJhHlxaX37ib5L0N1sVNbWNEG10HEglmmHp6oVMDknF25FiVPMKE/MiJwxHe+yyS+c1LgJQFlL9yLsIBBHCMXgv2AytnV5Bm5LOoD3QoZor/SueeLDdnut6IryQyG93srO+K1T5c9JbzEq0FpzMlI48b6NIutPsmSimyH+Mf6MQOBMARtTkH8OzbvjUvQjrd5D4fNe4iiDsypEXisxXMQnWB3tpoWiEUFIIlfgxPVUyWxyw3Hx6s/AORvojn0+8GcViAK4iXGlMtvucPP8Cg73UUg3T4gIk7ZerGO1FAkMF3c00bkK1cg0FZCZtDPN6xoX7CqMvQrNdK75X7B/8Z0z802+FDzqp1uea2UcJXBmR9SimAxzsgU6pByKaWlhBw96Znj0QHegowb3r18B4Qs5lBWszZDfFWybl58Qht9Qi2/Rwf4msAJoMedQOcBEB+RrwhnUapIt9EZGqA8HxbnIjD1Yqk4nDc3vESoP9qWlrUWe9N2+rHfDOyym3K7DzhFFkJYkVwVfxpt22SQl2+d8U3d7rR1SLVrw/V1NP0Z/SYWnGGYYnZ1H1+7YYl4229uQiF8nxNEqHuQvDHRC7fpf86HQYwb8TTc2jHA/srubocoj6IX8ULT2AqJxEEdMzT0S9fnwySKuafADpgGrtT58a086A3MnldFtvT8qoQG0QJ7mImv1NRTENDOwp3N/WhAZiw0q3zOOGHNxC5cAlHICWIyvexUV09YSzzzvRfu5x5r0xCv5l7s25Q
 v4rbjRlD
 nL5aYm00ftQZKcgO28f45p+59gmdAmtGvGTRiIUV2i13gNdnLiaxzvn/+5835c/X8ilHxa/OOiWs0A1lrQ6unNevUcMs2yhpff5JJvZvL+uLwGTtTpfOteJGU1eKvKdGX83iOqoVozHPkknu49/h5AyPp+uV2MeRMBNgYe7l/9Z3DxRb0t86i83Mg2N0/mb+wEdoasVQz/ogsHUtpq1nOgbrPJl1t5ILxnTfgonMf8eEvjSliFlm0iSLPNiA7EXQiJ/SkionHA7kRLsK117xNI2c6I9whUkRJisOjvJTUjtrn4yZvl5mUoOxOrcMwS1Mr5lW1QZ950dDg37GWge0IfWT9g1YWx2YkNa9B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 02:48:33PM +0800, Cao Ruichuang wrote:
> Commit c1bd09994c4d ("memcg: remove __lruvec_stat_mod_folio") removed
> the local_irq_save/restore wrapper around lruvec_stat_mod_folio(), based
> on the assumption that the underlying stat update path was already
> IRQ-safe.

Why is that an assumption? Please explain how lruvec_stat_mod_folio() is not
safe against IRQs?

> 
> That assumption is too broad for lruvec_stat_mod_folio() callers.
> This helper is not just a thin stat primitive.  It also resolves
> folio -> memcg -> lruvec under a helper-managed RCU read-side section.
> 
> syzbot now reports a PREEMPT_RT warning from:

The syzbot link you have provided has the kernel config without PREEMPT_RT?
Where does this claim come from?

> 
>   __filemap_add_folio()
>     -> lruvec_stat_mod_folio()
>        -> __rcu_read_unlock()
> 
> ending in bad unlock balance / negative RCU nesting.

If there is bad unlock balance, how is disabling/enabling IRQs would solve that
issue?


