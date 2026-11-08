Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AABB4606A33C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 20:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A56ATWUD
Received: by kanga.kvack.org (Postfix)
	id C61756B05B0; Sun,  8 Nov 2026 15:36:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20746B05B1; Sun,  8 Nov 2026 15:36:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B613A6B05B2; Sun,  8 Nov 2026 15:36:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9AB2D6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:36:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D5AEA04EA
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:36:21 +0000 (UTC)
X-FDA: 85413109362.04.DDE7820
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id ABEB380002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:36:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A56ATWUD;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794170179;
	b=CXY8LFGP4Zmb0ZiGSIpOFjlYk0QZkAOX9ZRRlxDKGqbFHEif8Yu+SnWKZEjOS3quGq+Jx3
	Al23y61+jhGm95nDHeiar7gjXFuvmaERFDjbfcU6lFg6Jokaud/Tu/jJG/8GYtU+wAnpMt
	+MjpgCJHsIxJOt+aU35TgRzqdorNQPg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A56ATWUD;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794170179;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8azARso06dhqTAeLMc7skppXLvcYQdPyeFCseSu9tM=;
	b=oAVD+U7NMKqQsWBxWnGKm0dOMGkIubweBVRtEeMz7iZzlPueNcMUnyifT5TEVmLS1XfHCK
	8bWtqP+RjrrITk+MWZaQ1H2TTQLvSCwNL8UZcF18VQ2o25FxsJ5QKkWax/RBVgPcubrHd9
	QCsSUdwRkm9gEYy8zP8feTafMEw8DpE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3AB1C61184;
	Sun,  8 Nov 2026 20:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6B61F00922;
	Sun,  8 Nov 2026 20:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794170178;
	bh=v8azARso06dhqTAeLMc7skppXLvcYQdPyeFCseSu9tM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A56ATWUD2D90WHekZBP0BIe/F6dic9aEjtoOn6sJPFtFP3mwM0xtLwIVElLK0lNCP
	 45ldKrwytJ/zbX8oPPWrnu85UUuHexiURgehqfGEdTjBXs0Qs5nIt40E+a0iCOgvmu
	 vzlYx5HiifGa4nygHuRtaSuhQCWqu+Xkw/CuiBNE3S8Oruqq4bxJko6cXo3grOcS/X
	 WwZT2cH3JqBHFsis3o+WJ/2ACN9yPIJ8jjkEv1Y631UbcW81mL7puYvHnsDHWyMGI5
	 plFVg9Ol5A7+06AHhA1Fvswu7LaG9u6tqqtW2pVGvhVPW4hBDbwR/E8llOWafozPD+
	 SJIFP0OLRcjIA==
Message-ID: <sashiko-outbox-204020@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.1.y 1/2] mm/damon/core: skip applying scheme if region
 split for quota fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Usama Arif" <usamaarif642@gmail.com>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261108202759.117377-2-sj@kernel.org>
References: <20261108202759.117377-1-sj@kernel.org>
 <20261108202759.117377-2-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 20:36:18 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ABEB380002
X-Stat-Signature: eprtfx55hhc9xnatk8khrsyf8citixf7
X-Rspam-User: 
X-HE-Tag: 1794170179-938590
X-HE-Meta: U2FsdGVkX19GTAKy6R+zBW7yg8nPumO95hEs+88t0AJaKh+pvqlWCx807+oBXP/+ompSPoKVpinKJ3Q5a9I2zTR3I4EKv7qpj//PBjgaVt/iLWNg4q9ncTRHWa/qORj0771nnSTiOuFmjmWhD7k/FELUcYTykHKbmAASJ8rEfRrexosFSGJqkXazxfy+YbSDDiLREpIdalHRP5zNQwPR5Xj7jWMEn8n3Os8xCnzJaymDxHywPVQw9HECTzKE5YaQYsCFMC3d2KUc5a548qceFmUbsG/s1E1OtTGgFafeyd/4hIY9aHHnexfqyQGmNlCCOUJtvzIOpcDgeaXMPyaBJ/OaUT9UoPJTDywFQqqqBx5DERpeek8DaZbTDMwAfj2efQ8JkhC3HfnnQaPfqZIkhXvDmGpW/uOcu+PepYse4TQguLqSAZtpIVUPYvc9qfxDyKL45wKTx+4NL4tcX+fX2AksMYbJC8HFm7GFncnJlzUY+opkc4TaBTUMw6HWBDie4fJVke2zc/psmdsgRI7uZtOhzT0DIOykyypy6bqPSPJDv2Elq7P8Xd2rqo7kKKzJJM8Zl2mEWZnnNL4kMZICe9TiIyPjgGd4Go6FNMu4v2cIjZW4bWKW17QiBL7HvftKGS7s7EeiJ7FQmoxQuzgDxU4/0+BOxfo5FXADQNdxf9jxwC7+YacPdeccexnTL0CztcOInHgpNeTl3tmF1/qpq/hu0HNwtBIYRx2FXttXYOBDO4SEjF1a+cwATMJ1PwfWUQ+WxO02i7SV0qF6vDAT2ayHs+9nkKxz35+JxObsX/5uUN/3SIcboNMZt7xkC+ZcfpCZaEIt+17gQ7UmQ3u6bMslc4nMTyL+wsjYldPlOxVcyLI0BH+hksN1TuldiXENdf+vHsOAsxm4DYbCR1t1VUqFejfcyboSP1dTsRRQd4vlPeYUe+eRX4IMc6enm0Brwwm5/ZbMhBBaiq3mOQo
 hUDuJ13a
 8D33VQzSAfgAhTrzWba76X7a1V9nACdFOGyh8067jLFzhQuUzceIraKq/uWnKrWXlfRJbCv0+jsztQy/NJndcAITX/zFex7jHV0vpbQJWU9ctY7iym06o3PXPy4qVhKO5fijFRxmzdd1aIWVcXL7LCv0zJzMGbxvYB2HHsIlyTuxTA8rvKSQ2jgfjFkhFPibpmq03txLIRjPjj2dybUteNR0vPKbNbUsqmJIHLpdOyQr9zXt9ketnHWhE1x5Isdxp5sezWPrjnnedz1vz8/8ddv97Fxqyr7DxETtSf2AhY+uDkN4Tdw2RFCP4wgnH/pjRBHP16zN8l+IorZfdAGdu/LmxOvIygZpQ988asb2gcFCVJK2M+okODQE+ub7pnvf/n1CfvgnoaO6TlQdxFkQ/ohEWsLNe6lwtN0pTmrQtHLqeg5Ky0+5rOQSdNj5qGg3f3o7BopDMAIPSAh8pYGU4a8So+yCnNWTvYZFQg7K1TxOkQgaA5tTJHjxCfEV8HfiLKEwZCUKp87EGU/VR42KJnyv4u7gxfhpOsJp4sH98AzOLLdcOvKeiJ8MVlG3Dg8F/op+3k50V6xAkVbJxFejvpXOgUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/damon: inflated tried stats in damon_do_apply_schemes() on
  split failure
--

commit 3b087258b4341cba87012b7cb96ed676fd164c12
Author: SJ Park <sj@kernel.org>

mm/damon/core: skip applying scheme if region split for quota fails

This commit updates damon_split_region_at() to return an error code on
allocation failure and skips applying the DAMOS scheme in
damon_do_apply_schemes() when splitting a region to fit the quota fails.

Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index f0da5cb2b88a0..9206737d05ae7 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

> @@ -810,7 +810,8 @@ static void damon_do_apply_schemes(struct damon_ctx *=
c,
>  						DAMON_MIN_REGION);
>  				if (!sz)
>  					goto update_stat;
> -				damon_split_region_at(t, r, sz);
> +				if (damon_split_region_at(t, r, sz))
> +					goto update_stat;
>  			}
>  			ktime_get_coarse_ts64(&begin);
>  			sz_applied =3D c->ops.apply_scheme(c, t, r, s);

[Severity: Low]
Does jumping to update_stat on damon_split_region_at() failure inflate
s->stat.nr_tried and s->stat.sz_tried?

When damon_split_region_at() fails, sz is the non-zero remaining quota
size, c->ops.apply_scheme() is skipped, and quota->charged_sz is not
advanced:

mm/damon/core.c:damon_do_apply_schemes() {
	...
update_stat:
		s->stat.nr_tried++;
		s->stat.sz_tried +=3D sz;
	...
}

Because quota->charged_sz remains unchanged, subsequent matching regions
can repeatedly add sz to s->stat.sz_tried if allocation continues to fail.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108202759.1173=
77-1-sj@kernel.org?part=3D1

