Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6BEBCA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 18:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90F8D6B008C; Fri,  2 Oct 2026 14:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0E16B0092; Fri,  2 Oct 2026 14:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FD1C6B0093; Fri,  2 Oct 2026 14:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF0A6B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:47:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB0994081A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:47:36 +0000 (UTC)
X-FDA: 85278569712.20.A770AEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6559A140002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:47:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yl6jrsKz;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790966855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyUrA8h6yWS5RyOPKr1WsM35VmKklcpbCOnMDCuxpWo=;
	b=GeSC780APHRav3rzcyCfTORcdc2FvYNdj18YATj5kK88ilz+RjKaYyJeg72PkKCSSaAr2q
	+/NSuNixszzjyIP/Yr+KmE43eKN3z9mo7Hse1Xe5Pug/5Cb6ZaEH8o3pjHBksQVjFgjH6n
	SQMRq65m0v5UhPeRgV02CoIszIw+Z2s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yl6jrsKz;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790966855;
	b=dEhZSlsR/jmQCLxmCom9Q+O7X4TfADS+IeQRDLtoAW95babvtq+EqU1YbFjojLKgj03U8k
	StqQWCEuCgVekvG2Urm6EgXWdSfxr2SU8eQ7w6+/LokN1mqRVHH4+gtbLdNlx/eNjvBNaT
	ypPyPLZu+Sc5nwfHBOUEnmM1DzTX+l0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C67FC60AAF;
	Fri,  2 Oct 2026 18:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670801F000FF;
	Fri,  2 Oct 2026 18:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790966854;
	bh=GyUrA8h6yWS5RyOPKr1WsM35VmKklcpbCOnMDCuxpWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yl6jrsKzXjGPTQNLFE+7pzbS2k/Tpq0t20ssMdimxEO4WdY+/gEEygqThMDODoYQV
	 5r4cCbFQ/f7+AKE0t6ynyuIye3mOwoo4LFGvADzWs5d1/WCFA3tKcuicLOKVz4w14D
	 VM3z8nUSMxZKdyNUHdlQkbyPTFLgD5Sn8VpydqjHvRXRSRQQ5LPQsCO5ep0YYjfErQ
	 7Xnp1gL77D1yrK3BKOoWVLE1enK/igvCmEZJ0LgcjVdjLom3kmLyw6ZA2faBFZQFpj
	 3jEm1UCCju7Y98c8OuEElKtdu6//1jhvupR4KXPKAOn78+X1Pbw+fbPKjcaVB4Cykh
	 lhp8GAnt+Xy2w==
From: SJ Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 3/3] mm/memory: merge __vm_insert_mixed() into vmf_insert_mixed()
Date: Fri,  2 Oct 2026 11:47:28 -0700
Message-ID: <20261002184729.41370-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261002160535.661399-4-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 48wbfhh5gbpmanggmp7syjrqihrif8of
X-Rspamd-Queue-Id: 6559A140002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790966855-963142
X-HE-Meta: U2FsdGVkX1/dPsRIliafpnBcsp1PZT6C/Av4zgM9tcpMjLyuUhpR8NPFRdHiSOqohowiPdvyxcMZAQAYmuqRDVFHlGWXWr3/+sLNjq70eWTh12haxuedPdYkof/gAbmqG+pqFIQNTXZGW0WvFwp0H8fMsWMP9sAEciN613l+vjmJYPPdI4J/loj8a+2NYHaK4rSU1IZOcEiLkP/Pga+mUxH5PmE4mx4orQHToh+v/Y2qC62Olo4QjF0ubELjPHfTx1Nkx3YatrrtHzNx2p2ScuQBT9cuEPUIFNcebS7ju7KVGQP+sW6lkNkcURr7lC7aejf8Vl00KwNboO3AVykQzgZEppnw6Fg+KoOFgUbMkw/gAh1ISktJf+Va7vKKRoH7s3WjmSeqFZ0j4LJ4v696lwXw5V5STSBCwjzPQcPSbkmuJjDXxtiuSyTH7u+KXUpuxHE0Xi07EOIL/aKhWtk/6nEQISkO9ZgmN3xeGOTUZXcY/FzNlZNteiFV15Ex1G7KEKC4WdBR0e8Fr6ay3GScJml9eqI95MMd60mRGICH+JvfvUJHMBgebmNXtbXqyzvCshZFsRj5XMyvCJ9O8Owu/JvFNq+w7/jy5GqwOs81vWulyslfbwV4OGS4DV9UEhoXkhlYGa15HjC51UX8alUNDapc5Fcn96rfnZ96q09j4SJLQ58ktkP5aNGew+jv9t1KsJTDYmzjLtjRYzOgkNwUA2KKkVGv/bV9EQK5IkRB6NHq2LoRuA5VYCjPUVVHdH9gLhe57/YyzeUYpmXCQJF8F346+0M1a3cLA/YQZkTtfW8y8mRueYXJ3/QjZkzU3tMVz1rnKKwazldRiDtFqtkaB6SweT1awe6+tL+W9GKtzdsUkUM7J5J2gjhwavqvmBVC/NCaxpUWJlAbqxHgHZ5cq2P0CD6FIWbhZOhOtj6ayjeMKupW60qkLkWZx4OFVz/iASpVCe+Hfd9vk2F7w9p
 yTRvujng
 wwUT6ariCbcUeUpFlpu0VkcIwlJvqU8T6CcOC+3kR4QtFdKaMvkW+QATwOrcU6us+SlCzL8NquNq1uBxnLAepZWAikgyXdQbcUhWh+rSUdt5oBbt4ki/t75iytYsApCqHYtMd8pfWXvP6q7WA/uljPZfOLp9VOX1rzqhQ6ZUg0Y2CQfDo6JWYYSGQV8Y3QZQZchD+P+h+r2JUnkAi1kNPsjf6JTWrxtwAjH6IrvunnfUxNk63OnYpwuwjGDF1651CJ/bZUPXYXLXcY+KwTxUrN9K4b89feZl/1z6AQB/J6gzwcIo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  3 Oct 2026 01:05:34 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> vmf_insert_mixed() just calls __vm_insert_mixed() with the same
> arguments.
> 
> So merge __vm_insert_mixed() into vmf_insert_mixed().
> 
> No functional change.

Makes sense to me.

> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

