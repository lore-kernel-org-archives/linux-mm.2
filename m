Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1BB7CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 22:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3AC86B0088; Tue, 29 Sep 2026 18:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4916B008A; Tue, 29 Sep 2026 18:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C7F6B0092; Tue, 29 Sep 2026 18:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72B6F6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 18:06:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0654D140529
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 22:06:33 +0000 (UTC)
X-FDA: 85268184666.15.DDAC396
Received: from tiger.tulip.relay.mailchannels.net (tiger.tulip.relay.mailchannels.net [23.83.218.248])
	by imf27.hostedemail.com (Postfix) with ESMTP id A66B940004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 22:06:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=iw4O0UlV;
	spf=softfail (imf27.hostedemail.com: 23.83.218.248 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790719591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnXRN2btfBjXlj9+UP5d7AbbpYLkqFmJlBHFxGuZnF4=;
	b=w9JYQH4bDQuDzaqSNHD2lqJ5U6/Grk4ibG2JkP4JfNSCWecp+138pymARqmcWJjZVZm2Aw
	nAvgBukZRoVY/uJhgeGh8BBlPcaRaBWhV4Q8eU7q1lDD3ycCFCZv4s+WmxxmTujPTV2/m3
	pqExZB46yk5VmZsocbLuNdEh08FCvVU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=iw4O0UlV;
	spf=softfail (imf27.hostedemail.com: 23.83.218.248 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790719591;
	b=fyrZ1PVV5dDEcAlFaGgxddnhlhvtXZ+uOrc++wKs49hSeYqjLTgyuU4HzTHvho1JzJa36V
	S2lKJToTDkP+oLll5On5jmfnEezpVMzxHdXzFaYmGTSkC5CcFi7raOAIBiA+c1ai2YXSkH
	rQgTWQoYooTN5eE5pEMBUb2HoJZRbsw=
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 35B04722F48;
	Tue, 29 Sep 2026 22:06:29 +0000 (UTC)
Received: from pdx1-sub0-mail-a214.dreamhost.com (100-96-9-151.trex-nlb.outbound.svc.cluster.local [100.96.9.151])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 6993C720333;
	Tue, 29 Sep 2026 22:06:24 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Tangy-Unite: 530991c145c229a7_1790719589024_875164832
X-MC-Loop-Signature: 1790719589024:2443551087
X-MC-Ingress-Time: 1790719589024
Received: from pdx1-sub0-mail-a214.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.9.151 (trex/8.0.2);
	Tue, 29 Sep 2026 22:06:29 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a214.dreamhost.com (Postfix) with ESMTPSA id 4hvXM24hD3z4D;
	Tue, 29 Sep 2026 15:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1790719584;
	bh=rnXRN2btfBjXlj9+UP5d7AbbpYLkqFmJlBHFxGuZnF4=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=iw4O0UlVuUCtg4I3HvnAX7SEl9beq1gzRb52FqW071b8inV64WZoIEJ19cd/REIb+
	 LK892wufLNL0knY0d1S+dBO+TNlEU2naQh7cfZpsuIuHaptH2/sn35Y3nvS7YkebE0
	 uF/0z0PfETllsjo7Y1GaiN42oNdDYM49+p5htjFxXyFhcHqgFQnyJ/SyFBGUEXQzyv
	 K0QbMPUlZn/EAK94NpBlitCNpXU9chOIR+XAjrYzkcrBKSy8+G4ZQtsVyGjjzh6yKl
	 RnXbvd7VHNOJvq+wiIBJ3QoSg3qs8twoJcA2PjJcgAlNRNwG6RQqvIIXAiYGZ3dDpG
	 DJpvI6Ac8OrEg==
Date: Tue, 29 Sep 2026 15:06:18 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
	gourry@gourry.net, mgorman@techsingularity.net, mingo@redhat.com,
	peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com,
	rientjes@google.com, sj@kernel.org, weixugc@google.com,
	willy@infradead.org, ying.huang@linux.alibaba.com, ziy@nvidia.com,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@kernel.org, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com,
	donettom@linux.ibm.com
Subject: Re: [PATCH v8 1/8] mm: migrate: Allow misplaced migration without VMA
Message-ID: <20260929220618.6czpcioqwwg66m7c@offworld>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728054356.291998-2-bharata@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260728054356.291998-2-bharata@amd.com>
User-Agent: NeoMutt/20220429
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A66B940004
X-Rspam-User: 
X-Stat-Signature: j3kgs1kpkxbdjc8rkrtsj151sojwypu7
X-HE-Tag: 1790719590-517714
X-HE-Meta: U2FsdGVkX1/OlcVYW83u2Iav61ygc5EbE+3bEqc+vbYhSL9kb7VUtbUKLRxMmSh4nMPvfHrI0UY4GcgQq4u+JWDuvqRMaQAjwmkcRb+sfk2BGZlChnZOp8At6/mY/FjM7kPig1O/RxtEkIi9MAzpMma4lZ74qytqdb7OuQwZVDiSXdzXswTnIjpCHkyqPuGXfSuZSZbkRGUGWricAqr7j5be6dZ8wHOckdcQYUkPnr9Q5L32LSSI1COwVcSubSwUtgwQaELA15ivPWWLZA/cuoJgHfG3J2mfJtlXYFh2pejoGQIZy6/MwRIenNCooa8bbz2mXCVMKZAAUzzCP4olKkYsKPGKnZjtJ81khlgFmAsxTiQfxLvTjywPXOfMFuWpiHJi6nqSjgxGE9mxNf4p2jXN+VqquTydhiGNwmaY5EFXXQ/m5hkGjwo9IMCF0jGB407WryUkakNFsX5kYiY4jPnWCJThQnLI5PXNPonIQvyONBUj3Oatixz7R4izWOttTRlioj2eLUdJMudmOvWXQnQMm3SSBxyPS3q38pNRjHTr0tuAIpZf+JDSgEno8uCAsHuYg/Jtw7kt5qys7qRqvIWK5nwwe0/PDBhGmMN/v3huJa7V1026zN23u/1GrUhbOo0NyG4lb5NGmZSPEi5puIaE4G/tvSWllO16cidlLz11UpvHWole/8hoPKnURwG2HHZozxDGtd2edY0bod8e/QXqwoLT/bZtlaZ7hc+tYvWC6bhB9Wm72d7oWTpGPML32S6e+jHGTJP8fEaOhHxJ0zSyfZNIdbKiybyHC2HFaH8P3zEg+SHEFjVnIqdrruGTjIglLBNYa9Ayl+26rrRx5lm2tAfovd/H09J+y0wtbNKMlmU5+Pal0dk6bVo0RommTU3fcE+3I6H2Ki9rYSttnfR3WbDyKMqySXQik+jsmy/oG40bjGPbc/NDyY6PP1nX1zjITXoZsl24cjwLxvr
 rxmqlzy3
 SN2VIRJGEklML4W/GDzO/Rd+k2Ux5mwQMwfCpTi09LzqRSB+5BgfEJ7dGA8v76pzegWALaakdl7gFP7F/4kUGF9wN51CBXCfQq65SdRFAajxo3bT19uryjKoZJ5WYijtXom/Rr3Y9rmFqRsW+oPZPUKa7TXKssdq6lZYzMejEub0z5FyJETHNzqPyoedfjd+1DXmKlfwEIkXEnsbIidBRpNgK4GVsMBeFv7HmmvN9ctobEQwz/ADRiHoRA94cnxUwP7vMlFHviWCrwCufJrh1PDBeXePBQACCPCZDv7qEThvfnwV3To4BGKbZ1Q5ceq2fKw5I4DcQyEtKBHm6QhTyoYCPmXtQ86znTHzPa26xF4PfrjpP8ELpy5jyVqL73TgQxtYtrEhCEbVnBi7J7MzEnnjOa8PZJIHu9hxjwuDBeanAi5Zv+ikOeXWcsF1OEyBiqlLcjePy9gnBoIs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Jul 2026, Bharata B Rao wrote:

>We want isolation of misplaced folios to work in contexts
>where VMA isn't available, typically when performing migrations
>from a kernel thread context. In order to prepare for that,
>allow migrate_misplaced_folio_prepare() to be called with
>a NULL VMA.
>
>When migrate_misplaced_folio_prepare() is called with non-NULL
>VMA, it will check if the folio is mapped shared and that requires
>holding PTL lock. This path isn't taken when the function is
>invoked with NULL VMA (migration outside of process context).
>Therefore, when VMA == NULL, migrate_misplaced_folio_prepare()
>does not require the caller to hold the PTL.
>
>Signed-off-by: Bharata B Rao <bharata@amd.com>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

