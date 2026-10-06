Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF814CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 08:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF526B0088; Tue,  6 Oct 2026 04:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D90566B008C; Tue,  6 Oct 2026 04:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA8496B0092; Tue,  6 Oct 2026 04:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A45DC6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 04:38:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A1AA1405D2
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 08:38:47 +0000 (UTC)
X-FDA: 85291550694.06.259BA12
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1E1C5100003
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 08:38:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b="iigl/7S3";
	spf=pass (imf14.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.172 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791275925;
	b=UqUPVL+Fk5B6H77F0sd4BuVDa86Q6GMeb3De9iaACnFBHRn9A/oQyzXp8BmXFed3OfGe84
	G9BvXarLRNcoFdg2fmUkgY7DBvGQ/sQV6PN7BIc05oIF2s2Jg45C+lXPmGudl6YIdWbI9a
	/g4YJpnOTqhNNgNCYhuJmCQC6XfPeMw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b="iigl/7S3";
	spf=pass (imf14.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.172 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791275925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S7mbjJsdOH1y6cZEHFsKN84sSmvjkVA8r40kT4OvmcQ=;
	b=gXwsOskanOWyrylow0czSvQXya0MEkjAOGGeQYBFEGsflwaZjExX8mmz5pXI60+fNquFtU
	iPPzfQqrJ1Z5uv1k0pF6JNXqItvjZhHI7D8kDu1I5ggMNCg6cgE0o3uipQCZaPQxgG1UF0
	H4bJ/J65Jg/W2HAAbtRlWJJMmG5ISrw=
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4hzV5t0L7fzMlT6;
	Tue, 06 Oct 2026 10:38:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1791275922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S7mbjJsdOH1y6cZEHFsKN84sSmvjkVA8r40kT4OvmcQ=;
	b=iigl/7S3287vT3m4CcJM/cC+eb3MSdf2VrRcV/6tNkYERSvUJfOAQyd6vG8Pip1ytelUuT
	rcGTp7e5kUgcOD/R1L9vaRYprUGUdr5tYw4ghxJWp96rOl+8DwWAyjkJ8MRmKxJDI16rHX
	gso7NJ6+puFdMuqGKixccO31uB3Aaalft4t3p+gEd0hrbuytlTy/Do7iRg85DthegFDkqH
	fFfLFe83tPHoBk+FXtElYWElgmH1UuRJ6+0HXgXP7oGeFtLJN2/gNiW195Nmc0vGFlBU9b
	QzCqJL9GCezqx8zg6+51GHipDh+m2ylRhQWvpZQHiMtscd7ig86R5An0nyusww==
Message-ID: <c2c4279ac5948b1debbe597eea1210fd667801f6.camel@mailbox.org>
Subject: Re: [PATCH 1/1] mm/damon: fix typos in comments
From: Manuel Ebner <manuelebner@mailbox.org>
To: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>, SJ Park
 <sj@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 	ahuang12@lenovo.com
Date: Tue, 06 Oct 2026 10:38:38 +0200
In-Reply-To: <20260915102746.647-1-adrianhuang0701@gmail.com>
References: <20260915102746.647-1-adrianhuang0701@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-MBO-RS-ID: 4f7708e9e185bd138c8
X-MBO-RS-META: jfbsa4wbs98wgj5dz7dihncj5qdkb3ur
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1E1C5100003
X-Rspam-User: 
X-Stat-Signature: eg7efser9sdg44ukm4q67au8ksr6htrx
X-HE-Tag: 1791275925-987101
X-HE-Meta: U2FsdGVkX19s6qdomf625VU1WMjW7XLtPWE1p0cx/GwQN/XVd/NToILCeadcYb/BhSOl/YQo3LQEbHq4aJxHQAlpdvaxkIpo8ecLfybExFUUcQY6C6rlCJYtb4VkOSR4SIBhgvbqDgSirdBIcY8Bl7+Hx3L2TDg6C+6w6pAyKOeh0RQUAO3Sg1kXvuKDEAmlmG+l8/rXqnDFG3/haok/lFTjqwq9C4D7qiHv6D4PTm2MuUsGDBQikU8xk1VGfFjQkBHDRxn/XPp5mmxJF3crwDF+rCHuOkg96fCBuXi0eX9oXFGljDNImIsaNYS2FjtsDIy8UFbWORICyzQ52QFcOGJLWg4SAvoRDNDNWOoLZJAA8XJMeaQ0f3nxhkpHRw8Kau9vS7z+4CY3oNBQeRPaw03Uxtsgx6aYLWlFrn04jD00GT00CjU5zUvx+qgaz5bBJ+qvXNf6TG0B9ZkrfkjehsS5xRUVC3M0HCit2nyJGyI4wrHOienc3IbrX7hkBSK9LKbJIZseEoegG+/7aLwdjapMr8+HEYgLH6FTl5iPvLcMZCRwm0CX2T3EluxecQ6BpaT5DOD3Kjt7+KTmnJZUXHg1TsplbTGZZDxaPqm0KU5LtFPOFLcLqLVKwqgUmp5VsWYxBERWDaCtUUBMivf+Oopg/3ADv0okbhVRoV4bHFrwCB7BrmP9DQxBn6zNAIp0kWoNeY2Ezcp0OXpfy8khZx2COiUGsIh63iuwUfIwKcY9GVEHksYBYn0gE/AdWKpVmMo4x3PL7lTfo3Vqn00Zjz6GKRJSSt+RaiDuxJ9O5NLM+jLItXrli92MZXdCkGuzixQZ/3O61zLKvtA6n2p1JJRhCbBFyFkIh4qy8MZdnAdzFU3V/PNrbMYz/8ipjPHjgXBoKFIBOaXyJR8MzMUQtqA4KaXEqpRN3xZNpZPf0EppHafDB7muRKCXZ6mj+Soo2fQJqxCq3aMTj6gKBy6
 Zu91e8IA
 ky+4HFbcIv2g9K2oRelhqfqk3rCvNKGDw1zuQyJZWYLY8xBMeLrhq3luAdEzK2Coj420EUg4xGPaC58e5or0x9xIe6Ft/HQONMXpTLC0sVljRZapGnUawsTzncwk6ORsqzGkxM2UBPbIwfqNZVHPbtAiu/cIYsKcZDmhI2cLAuLOGBasVs1Xc5JYO5TYPyjyaRuNmolBa6P1sS+FpznCYg3V7EW7qAOs/NgLY2twnAJ0ZBVcR8FiBEKvDOMkpSrOq2SlmNBRvR+VTXZ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Adrian,=C2=A0

On Tue, 2026-09-15 at 18:27 +0800, Adrian Huang (Lenovo) wrote:
> Correct spelling mistakes. No functional changes.
>=20
> Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
> ---
> =C2=A0mm/damon/core.c=C2=A0=C2=A0=C2=A0=C2=A0 | 6 +++---
> =C2=A0mm/damon/lru_sort.c | 2 +-

could you add this changes in this file?

DAMON_RCLAIM -> DAMON_RECLAIM
'set as' -> 'set to'

> =C2=A02 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 0c98f7e267d0..981a153619c0 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2447,7 +2447,7 @@ static bool damos_valid_target(struct damon_ctx *c,=
 struct damon_region *r,
> =C2=A0 * This function checks if a given region should be skipped or not =
for the
> =C2=A0 * reason.=C2=A0 If only the starting part of the region has previo=
usly charged,
> =C2=A0 * this function splits the region into two so that the second one =
covers the
> - * area that not charged in the previous charge widnow, and return true.=
=C2=A0 The
> + * area that not charged in the previous charge window, and return true.=
=C2=A0 The

Please make it 'area that is not charged'

Thanks
 Manuel=20


