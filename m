Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8026F606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 21:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=haum5AZO
Received: by kanga.kvack.org (Postfix)
	id 815A86B05B2; Sat,  7 Nov 2026 16:58:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6A96B05B6; Sat,  7 Nov 2026 16:58:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7045E6B05B8; Sat,  7 Nov 2026 16:58:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE886B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:58:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CECFA80162
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:58:20 +0000 (UTC)
X-FDA: 85409687160.05.F02D790
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2A9AD180004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:58:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=haum5AZO;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794088699;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6TrikrwQyh4DkStXHhkZyFBHAXRA0BcKw44gzNrj3jE=;
	b=rdfgerCk/GxcnJeYFAsNVuXm2/JC0HYbMnMmHTvnfjEuzo7M8RQLVOoMMvXBFBjodSvV7j
	Gt6MrD6Ow6sC4Iz6DlHQIIunVVBlE1L/YKP2v2fMzSuDPKz7nszoAkhvptdVb6QVLToH7q
	HrcDpsPyED3SH0QqqFb8KpBN9CNdV/o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794088699;
	b=cj6mAW0egE1b0mFoQ5QdtIvOVd5Rk/a9Pg0DCWSQdn7e1SsRtPhniXQisD4Q5GQuBY/h/Q
	a6rmTHKbWJ0U8wpH0c661fMuQ0pBs+k/6RbACAWw1TQhSv8xhiI86kGvAlJXBMuuu2alU1
	o6Lq9Lc15KIeet4YknICLboyp7RZyGM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=haum5AZO;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 527404324B;
	Sat,  7 Nov 2026 21:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBE71F0089F;
	Sat,  7 Nov 2026 21:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794088698;
	bh=6TrikrwQyh4DkStXHhkZyFBHAXRA0BcKw44gzNrj3jE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=haum5AZOBQBMcXJfv6OHeBqjEXed5HZFCRl9Fs60Zw+rj3j2HU44g+sy7byDWT233
	 TTSoHTNnTZXDfjCT+gVL2Z2o8HEE3dvry3bYVOyoYDk18+S+TbTXUv5jD0VtXITT90
	 /vGpfSomDfM6IAeFlrDLAvKyut6GpUFsWy3oB59Jz+nKrKNWPJeNDGpVxwCxAdfR7I
	 +SsskeAWRqLp/efxMCpEqblDaHaMTa9eqA0RQ/IIrwaTUfoOUpN4Tr6LwzelLjip2c
	 sHEGMm4ttz+cQypaYTePcmh13rG4abth0/ZBnz3wubwD8lJoq8cXaQJTBQjJ4l62O6
	 Ne3tUBkkR9YQw==
Message-ID: <sashiko-outbox-203351@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6.12.y 5/5] mm/damon/core: remove unreachable damos
 charge_{target,addr}_from
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261107214525.304638-6-sj@kernel.org>
References: <20261107214525.304638-1-sj@kernel.org>
 <20261107214525.304638-6-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 21:58:17 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2A9AD180004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 7u84yncbptup383oqsh65jpten7yeztk
X-Rspam-User: 
X-HE-Tag: 1794088699-517502
X-HE-Meta: U2FsdGVkX18YbQap4ZDGKd5fksFcaxMB0VSnulBJJI4yKpR5QVMS1UXJcNVdYjVhTlAdOhSAsT+Sf216icJDKkDKwId+fOtLNWw6LSAjOt1lVNLb+cw/aTY21r7Il5TWhdGs8VZRr21Pxe7Ejp/am1ByxjtZr3+TciIQZOOmt8ule/VUJaUfiPpIMF+K5iskUXZ+uemJPM2aPdEc6klTqNbOwxPBX9DOJnDatG/Ou2L/rfImsLo1OxrkUwsaj5DJ+2oEJZdWgFmnZ2IGB4gMiJJY7jrwbqJcLugqcaVHp9WddE4OiI1mf+yGiJVE2+HrGRl6BZaLJ8UkKRDPwKLFSYd3EBdBO9B/21kBOFwhg0JzlZANrziq0sc1VkJkMuh5zMRGO4yyY75QSJuZSH5yFOtwaGVqI7ELnE3wyxRKCxnZVSLi/1PrMCHnIwYlU5lD/G/ZsAJfUiXonaT5SoBbwoEOv9Kbfw3F3rqW06zEXnIm9NvhQLBNOW6N7D7E0GgdRfpleW3ErdFAp21fE7LgI4gL05kYaw8DWLV1LIwUTibG1+NDFC8Ji+qXt8tbLHN2SJQ2L2R3UGPCbnpX2zKRO4xQ99iQXmpX+Gnrg/0SVL1RuT8lhXDWyXAQwlc6Reek+YbjmE+BZ5yAJLNL/O2etSNihCsOdrvBF6UO0x1aS8uiwALDtmLgYN6OA/rsGT5Y4YtKefh1/rQiPv/d7lqIaVWYnz8J6NChCn30VcSJfHixLoRMq77BzvQ6KaezezATaX2BUMbA3517ZMEGem57w1lzCdY3aWxEJ7YR6BwpY6sqLSTap1CAKUsBLtdAx94sgjLDl75Z/aW+B8A8k8JK/ziWnbfeOTcnYUvIuRyDLBzvp++nYqualioyj2iuPnts3Xb2xEymd69kA6A+e0YurOTltH3XEuBPIgOn2lcRuJO9xF4pIm451YtegTqGji6Xw0cyl8viZYH99slEYvJ
 JiSvCVul
 9RQkIKc2ZUsn4E/pUIdn04XlLh1FmxqV01Xs6LPndwTtFvk36/RL1FuZKxzhrjJBSuN+543tshTc8DJug61/tBlgr3YdlUTWj3xTHYL5OjI5IBTYQMqG7i0L84fwPFax7INqMpt4K1eOafvdAdlOhggXMDCCCNpbXPyKntNZMIjQPW0qKBeGQ0MVGlhHTNy9XqSaqgwt/aCIokHZws3SsrprdZnqcht1IlwunahdSuWe/S7a8WLcwEX5IGgmkMMepiUL6JfuL2DTh/dSNgxum9gqjwVumjhSe04N7bBKjm492E+SiT9erM4546zlEhpO2pPPWU9+2dG8TMik3tXxdA8SRGo2/tN+5P3U6Tp1dXNLTJFtij2Q8RHOENpTBYnmyfhX40Yx7M4/Z45MkPJ4XlOyOtDIC7UgX6brmLp0DF80PMSGpSM2n0e9E/DXXxeji+Al0x0QXtd7iWchYYKaSgiZPF5OmSNoESFTabFhTpTeTqm6UKLbhPU/Q7oJW+b26klHR7evBUQUwxVHyBj53hvs8t/GbFo5M07Jen/og5D48EQaOsb4BLYDrDbwDOQ9LDwYY9+YLRFPyKep54nOMMCIVIjGp+/ZNQBcy3vb4DvddEEsw4K9l1mSxWiJfmM+dyCKU
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
- [Medium] mm/damon/core: dangling charge_target_from ABA reuse in
  damos_adjust_quota()
--

commit 6429d6d07b9e92711137f889d5332896002d4342
Author: SJ Park <sj@kernel.org>

mm/damon/core: remove unreachable damos charge_{target,addr}_from

This commit adds damos_fix_stale_charge_pointers() to damos_adjust_quota()
to clear quota->charge_target_from and quota->charge_addr_from if the
target was removed or has no regions left after a runtime parameter commit.

Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 046c07b86a6e7..badd0628e5eb2 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1686,6 +1686,26 @@ static void damos_set_effective_quota(struct damos=
_quota *quota)
>  	quota->esz =3D esz;
>  }
> =20
> +static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
> +		struct damos *s)
> +{
> +	struct damos_quota *quota;
> +	struct damon_target *t;
> +
> +	quota =3D &s->quota;
> +	if (!quota->charge_target_from)
> +		return;
> +	damon_for_each_target(t, c) {
> +		if (t =3D=3D quota->charge_target_from) {
> +			if (damon_nr_regions(t) > 0)
> +				return;
> +			break;
> +		}
> +	}
> +	quota->charge_target_from =3D NULL;
> +	quota->charge_addr_from =3D 0;
> +}
> +
>  static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
>  {
>  	struct damos_quota *quota =3D &s->quota;
> @@ -1714,6 +1734,8 @@ static void damos_adjust_quota(struct damon_ctx *c,=
 struct damos *s)
>  		damos_set_effective_quota(quota);
>  	}
> =20
> +	damos_fix_stale_charge_pointers(c, s);
> +
>  	if (!c->ops.get_scheme_score)
>  		return;

[Severity: Medium]
Can damos_fix_stale_charge_pointers() match a different target if
quota->charge_target_from is left dangling until damos_adjust_quota()
runs?

When damon_commit_targets() removes a target via damon_destroy_target(),
it frees dst_target without clearing quota->charge_target_from, and
damon_commit_ctx() then calls damon_set_attrs() ->
damos_set_next_apply_sis(), deferring damos_adjust_quota() to a later
interval.  If a newly committed target reuses the freed slab address
before then (or if damon_commit_target() overwrites dst_target in place
with a different target), t =3D=3D quota->charge_target_from matches the new
target and leaves the stale charge_target_from and charge_addr_from in
place whenever damon_nr_regions(t) > 0, causing damos_skip_charged_region()
to skip targets and regions up to the old address.

Clearing charge_target_from and charge_addr_from directly in
damon_commit_targets() when a target is destroyed or updated would avoid
comparing a dangling pointer later.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107214525.3046=
38-1-sj@kernel.org?part=3D5

