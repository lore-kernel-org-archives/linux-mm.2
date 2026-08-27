Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F876C61DBD
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 02:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716F06B0088; Wed, 26 Aug 2026 22:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7D56B008A; Wed, 26 Aug 2026 22:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E0D06B008C; Wed, 26 Aug 2026 22:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2B16B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 22:46:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9B66140288
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:46:35 +0000 (UTC)
X-FDA: 85145511150.30.E6A7102
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8990B16000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:46:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GyzXAUaC;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787798794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SnmN/ITWTEqibrBh99a+koqJj62t9wI4VWKThuaC6Kc=;
	b=jbYfZTiQmFpLoGgzdBrP6CSQbLqWSydU99zzBksl/td0IVaYC6/UftzCJdi+5r6kQGE0o6
	zG5+6lk18eDSXCPwkcjkKQRtdwkErbFNUN3OirH0KE+PGQVlT5ygqh8u35p4B8B+RJF/qf
	GIcDZkUQ5XqpFH79TmTmKbGsjoDrybg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787798794;
	b=QAJsyVnoQgYgZzxUSCqyOmw+0ylhCjoJ+J7W3VJuCx9AD/ZO2+4QHG9piLARChPMEVwBBX
	MxPDjFWD7IQakMsbrRn3yXGyFeSuTethBhnrojHqtrc6GvQpjkIC3dV7BiLkX7LL6V0/Wg
	MxiLAFlhc/PmDzxOdR9z0EyL2BNrF+Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GyzXAUaC;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SnmN/ITWTEqibrBh99a+koqJj62t9wI4VWKThuaC6Kc=; b=GyzXAUaC2Li3Oi1eAmaAMssJZX
	1oEfGvZiAyncoV54h2E+o4rGzrcJgaH13hmwlrunxMdEm7LmmKdjVk5VG6vVAH0bpwm331kMGmREN
	Q+9dXAWjGlZWbkojuTMJKD6qr1leruCYWwcUNIv3fVBerc9UuG5mEIQ2dk29ovvAnBjZ2pCJqz6h0
	mByHlqc1kl/blpReyNBSWLC4nhPi0BYhgdMMKle5Quk9SchHW4AGTW4q4v9gw8X/dQxcUs2SiE8aQ
	krIJwk5t2X1CmNh0Xxt6j5D24MxTerDp+ggm9sTOq/tJyJbl4XaBV9qZRQ0k0XYmOa3BD3dBdWIdY
	zz1EKP5g==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wzQ8K-00000003K13-39Or;
	Thu, 27 Aug 2026 02:46:28 +0000
Date: Wed, 26 Aug 2026 22:46:17 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Zhu <hui.zhu@linux.dev>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] maple_tree: Annotate lockless pivot reads for KCSAN
Message-ID: <kpzm3pcwxwnzk5kngcsfcybzst5jtyrdcphd3hcpmoc6dbtswq@atn5yddl23qx>
References: <20260826074430.1139325-1-hui.zhu@linux.dev>
 <20260826094147.42e1e71e91a5a537ced30a21@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826094147.42e1e71e91a5a537ced30a21@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8990B16000A
X-Stat-Signature: zhmjrdr6notuzofbaaafbxu5ifgfiraf
X-HE-Tag: 1787798793-583162
X-HE-Meta: U2FsdGVkX1/wuHHDD1/m06SBVJzTsuU+ckIDO6wkvvP11CRJtj0abmD5604oxSCi1GUBs9eRPcPQ3eQTAY7RkEfeAbgulLy15c2PNkRYj8SNaLOovAFzcGRk3oF0zQOH7G2K45Xz26jctK7ymb+oBpO9//T63tAmg9d2pC2GvUKzSBfF9qA8GotS5Kvnw8SqhIf3JwT3OP+c1LvPQ3cr6BwuNk6fgSSsRhRTerB4Hslqm8XL2OzHVFCr0aYvrMdRtL8CUr0UhKWGwBtoz+2yapZ86pSG5idlz5f9IRX9GcxbZJULxmcazvcAZHhvM44t5HaJxVV6PrHPuwboFoPMYanCpB8uJYIjSgxkWUXWedhCjC+MG2t3cAMfVFBDC6glUc5ejFZGMCmYBYsJHfy/tzSpPj+Lwtqmmag+aiYaWZGBWGZappQGDNm0UUpppzqUaiHUfSxZjSUUXFuxxXNtrijY2ugA7ZcqCvBm2xxkmith5l4McGrUEk9gQ0W9ZrXWUTIMzOqNMZb+mfHnIj+KYRKvx76RDzDdHa2bIonrpKCbgsRH02u1i4D+74heRtK7dLSqEq3No+RXJ7esaqDYsPtCtfa+HWvgz1D50hXOAZGcuLp9P+d8gTxfNc/T+rDMAc3D/vXd1gHpdNOKnz7XHdoOMf56iT6YMgnJWt2arVnILXQPYEbPCptkXDSUZHh5dff8/CAbI/DWc1pJMWkjlOFb7jbimeyQIoDN6I7DhZcqUl4IZhe2w1wteaPcqNm/RdnkwIH2FEaXUUNraPUWZsz+MNSMXAh0NRpgKukFpGBGATLHicHXrFFNbbnp8DbQd8icJGe0wpT7izAr+piCPvC/1nQPj2GQmGskquG8Na7Qmy2KWMEMWlg7qHwRaMXN3R/UktL6EEVhL6PG4JbDf5QaWfDK8IvkbAg3UiCBasr5loM9+wpqFadOTCEF9IJDBCOKneB1xvSyYIUZr2g
 Tpi3uilX
 erQOO6BCIIOAiVk4q5E/nyntacr06CMEnG5AkAwEEa0bQPrHRh2/ZxvZLp5HFxq4EX2B17nWrG4kptxf4oHC9xNU95irUcisY2fPG87IKuT8UoCFmHvNu/C9wT0/oFHq1ma4yZYndH6txHR+QNgMX62mJrjgNEzBoRXLcDL6PUCTwSKDAmWcKDmtrm2L4wXg033CeMarovpTrmnSni8Ae+xM/6VRetXXlhgOD1iGoiVKHbCoIKZuDWgtNZqY3Xu0jEgAzlJvJOJA65sg/nI+Fz4cn7P2x2L4vNTxCIVrO9k/UW9nwf5+nwluvHOKZXTXBQzOXOzaAGa1HSDX6d84Oc0qqrAPswbPmHC24vTtoRt58DrAdnXcwejZ5Spd3abBO70uA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/26 09:41AM, Andrew Morton wrote:
> On Wed, 26 Aug 2026 15:44:30 +0800 "Hui Zhu" <hui.zhu@linux.dev> wrote:
> 
> > In RCU mode, replaced maple nodes are marked dead and freed via RCU
> > after the new node has been published.  Arming the RCU free writes
> > node->rcu.next and node->rcu.func, which share storage with
> > pivot[0] and pivot[1] (see struct maple_node), while lockless
> > readers may still walk the dead node.  These stores therefore race
> > with the pivot loads performed by the walkers.
> > 
> > This is harmless: the writer marks the node dead with an smp_wmb()
> > before arming the rcu_head, and the walkers re-check ma_dead_node()
> > after reading the node and restart the walk when the node is dead,
> > so any pivot read that raced with the rcu_head stores is discarded.
> > KCSAN cannot see this protocol and reports the plain accesses, so
> > annotate the lockless pivot reads with data_race() through a new
> > ma_pivot_rcu() helper.
> > 
> > Found by fuzzing on a 6.6 kernel; the race still exists on
> > mainline.  No functional change intended.
> 
> 
> Thanks.  AI review suggests that the patch is correct, but incomplete?
> 
> 	https://sashiko.dev/#/patchset/20260826074430.1139325-1-hui.zhu@linux.dev


Yes, this is literally every read of numerous pivots on any reader that
would need something like this.  Most code is shared with the writer
side, so we'll have data_race() annotation where it is not needed there.

I don't like the name of the function and I don't agree that it is worth
doing, especially half of it.  If you notice ma_ functions take a maple
node as the first argument, but your new function takes an array pointer
in the node.

The from address does not agree with the sign-off on the patch.

I also don't think a benign race needs a Fixes tag?

It might be worth looking at other ways to calm kcsans down such as the
type qualifier __data_racy, or maybe the makefile option.

Thanks,
Liam


