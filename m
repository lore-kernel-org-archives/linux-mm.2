Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F377F4BB73
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 18:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6356B0089; Tue, 24 Feb 2026 13:26:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33866B008A; Tue, 24 Feb 2026 13:26:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3EE06B008C; Tue, 24 Feb 2026 13:26:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8F66B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:26:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 71A541C1EA
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:26:35 +0000 (UTC)
X-FDA: 84480180750.04.EE26B28
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9051A100010
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:26:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ExszyUmY;
	spf=pass (imf05.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771957593; a=rsa-sha256;
	cv=none;
	b=O6/iwuG6hBaFrHUuOYuUCX02X9ORuyNgS3njiRZMYjCOV2TFcKvbGyKWuVDmeN05kzrOMv
	pMYXJY9lSJtwYBlEbY2EwUhxv3ggGJzpc5IwlVZ0pq4TGsegFIarUbvwAQzbnD3ySof7k+
	TnJSzL14Naaad28kFMjOET+cGks5Ru0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ExszyUmY;
	spf=pass (imf05.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771957593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Uf5EJf+Tw5nbDLapVKw8M9tfsonMMBNq6SuwMEXglI=;
	b=ayIyO4McqKmoVbZcLwcMcUH8H5z+xsG1EsHeKTaKspYrbeoUZDT6NUDSpvCCCly41N9gmL
	QohL15yuKs1w/vBMMPdWUdY3vu2M4XzPjazNQGebiZ0eu9/hmVywPL6/1EcP/1iMRvql7E
	AFBm/sbRGoh0BR5+a84AefDdbVDnd/8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771957593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Uf5EJf+Tw5nbDLapVKw8M9tfsonMMBNq6SuwMEXglI=;
	b=ExszyUmY2wWcVojVaWKSEhC3MWK+oYfxZGphAp2CLpPH8WlSD3oNBxAEKA2CddCBMWhIt1
	janup6CZJFi++xEDDiQ6RoLNYEDnG3gSUPMZLPAUGheT5dJdTFWKyhJJ26RFLIn6McWjN2
	yuTnL6XVVfhmB/HdbvlWY8iLAjzSC9c=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-414-58eZhZIcMliTHgOPkvQPJA-1; Tue,
 24 Feb 2026 13:26:26 -0500
X-MC-Unique: 58eZhZIcMliTHgOPkvQPJA-1
X-Mimecast-MFC-AGG-ID: 58eZhZIcMliTHgOPkvQPJA_1771957582
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08FF21800578;
	Tue, 24 Feb 2026 18:26:22 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.3])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2CF1C1800370;
	Tue, 24 Feb 2026 18:26:19 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id CBBF340164D27; Mon, 23 Feb 2026 08:20:51 -0300 (-03)
Date: Mon, 23 Feb 2026 08:20:51 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.com>, Leonardo Bras <leobras.c@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZw4E9+aN3QjMZsB@tpad>
References: <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <3f2b985a-2fb0-4d63-9dce-8a9cad8ce464@suse.com>
 <aZibbYH7yrDZlnJh@tpad>
 <a1c11a09-da88-4edd-9571-0f792b59e9c3@suse.com>
 <aZivpwJnIGKdAMYE@tpad>
 <aZwZrw_LTilXsPd4@tiehlicka>
MIME-Version: 1.0
In-Reply-To: <aZwZrw_LTilXsPd4@tiehlicka>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: s2NlcqS22v3fu0y8Zes22-s5Wy3Q_7i2M95B_K4moCI_1771957582
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 9051A100010
X-Stat-Signature: htdpphne9u38s9fsdms55c8ysjcpe3ai
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771957593-306538
X-HE-Meta: U2FsdGVkX19tPJ0sVAmOVTc0Kb/i8d4eLvX9VZ1HbR6hBq8SO1I0ZZzVGKOxFU0hDPTpM3h99k+hfo9H3PeClTAMUGluvQVN2mLJ6Nn58C78PBm//wGVNzdP3PchpHdlktnh103Ho9mH+5kwhZ4mtP0lZKmaXCvAt2aZl2lr/v/RLQUjGQDPaLToG715x/tTVxiHJ0gXu4YOTfr4eeTtSV6CQIIV/vgZAxrjJ0JAmroMwud15u4huuPClQ/MpuLDxE7Agl8OEzjmarTrZt73y/EwIayIIymeHSPJpXXiI56HrO5qjEIsjkIahVpkh208j329cravqAzmr+burLruqKffWZK8S0171st8USzT9ZDC0wcAd7gV0sn+bXTGcfFT++FHE6wqoBKy96WXJn2f4f3r5O6tgXOi/le/YeSl0shTu5eACGZf6EeDuSpvJMnrbK/SJohinTiGyHdnlJwjtSRdqp2NtoEX5kvfZUgrWETtb9sQyxYqcpHg+2WiyJ9eT/9UEnVwNp/3Gm1wzg6TnZ5L2ZENRq3cVQ4f2+HdPUegzNa6lxSmPQERmQKGqMdsHeXNN0JWHXzckIs7N1XbEM6owCzHrKozmmRMAaMedsW9/J0Rf1jTLKE4mMGh7g65x8G+wrM2rp9T9NgE8mnpzvRrt6jZ1ss+IdkC9vh7A8MTrm47NX8oxMWfZFnjGgL5ZtlZ5tXqcDW+QpWxzCxvcIT79DWNG1m/3SlOEGyla0BExUB+qCwZneMvR85En/Q20Y4SIlP7Rgza4pWHI3zmKySK4eQIF7TskhCTw7TDK3MvohtTJydhRLf8Z7TGbaUNjTENEXO0L3mp00Oo9PSxriVVhkIBUki3DVx4oHLCFe5kgGsqnRQvZrv8kR2ZPtzQggCoNSM60VMeCmxGVHJDVCH2PhhjfkdiNCKKIErMS4sJaOBU8E5MHgjRjJZK2KnzDje8grWAnwCmi1FpZO2
 4k3dAKzj
 7qSd+Fv2PTnmeGCrsFRil4hRJMdTSG86CgMx0BhUJhTHtCQcOrkXOnGnlHXkA1432+JubOarQ4QspU4GHbgdbFZ5MzcSN5mAu6/F9Q9XMgVa8/r45EPJZCFnZBQoHqevtYiDGOKHnsxzaN6Qc6c7pbGDo/LgJplrpzceQ800T3bSCk1CgWNkA3ZlXZzIiw0ABADJzK5HWCNS105Dp3FLlkKDR+bXwkihUj2SUvnyhO2E7BWR15Dayn5OjO94vS9zqKEhPbDbHxZgxMst2ysvjVOGxV/GiX+rxvxHNwba3KbhaSaUD+h0C6MxcsuylB85AWd5qejhjsfm61wnca9PgQKW35gCkBaNAgzid6oImQMsJVLFuUtyDdPHDSlLV2UxZjRiSvYpkB58vBFSGkvfEDKyZdu26ZS5KJsb4KzGSrXbJN2WrNPsSNbVlO/B9Ich2UHAsAlWJvQEut+2Mq9uSZKy34a5y3fEAunM7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 10:11:11AM +0100, Michal Hocko wrote:
> On Fri 20-02-26 16:01:59, Marcelo Tosatti wrote:
> > On Fri, Feb 20, 2026 at 06:58:10PM +0100, Vlastimil Babka wrote:
> [...]
> > > >> So if we can assume that workloads on isolated cpus make syscalls only
> > > >> rarely, and when they do they can tolerate them being slower, I think the
> > > >> "avoid sheaves on isolated cpus" would be the best way here.
> > > > 
> > > > I am not sure its safe to assume that. Ask Gemini about isolcpus use
> > > > cases and:
> > > 
> > > I don't think it's answering the question about syscalls. But didn't read
> > > too closely given the nature of it.
> > 
> > People use isolcpus with all kinds of programs. 
> > 
> > > > For example, AF_XDP bypass uses system calls (and wants isolcpus):
> > > > 
> > > > https://www.quantvps.com/blog/kernel-bypass-in-hft?srsltid=AfmBOoryeSxuuZjzTJIC9O-Ag8x4gSwjs-V4Xukm2wQpGmwDJ6t4szuE
> > > 
> > > Didn't spot system calls mentioned TBH.
> > 
> > I don't see why you want to reduce performance of applications that 
> > execute on isolcpus=, if you can avoid that.
> 
> If you can avoid that by making performance bad for everybody else then
> then it seems safer to sacrifice those workloads that are much more
> special - i.e. cpu isolation.
> -- 
> Michal Hocko
> SUSE Labs

Performance is not bad for everyone else:

Without patchset:                                                                                                             
================                                                                                                              
                                                                                                                              
[ 1188.050725] kmalloc_bench: Avg cycles per kmalloc: 159                                                                     
                                                                                                                              
With qpw patchset, CONFIG_QPW=n:                                                                                              
================================                                                                                              
                                                                                                                              
[   50.292190] kmalloc_bench: Avg cycles per kmalloc: 163          

And its probably possible to remove those 4 cycles.

Which makes reduction of performance of isolcpus not necessary.


