Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28920606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DlEqMa82
Received: by kanga.kvack.org (Postfix)
	id 497646B05B5; Tue,  3 Nov 2026 07:04:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E636B05B6; Tue,  3 Nov 2026 07:04:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AB506B05B7; Tue,  3 Nov 2026 07:04:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 172E76B05B5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:04:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F8C01603DC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:04:07 +0000 (UTC)
X-FDA: 85393674534.23.CCA47EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id DE2651C0004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:04:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DlEqMa82;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793707446;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WHfBAJW7tBZ/jpc0vscD0oFhU+5t1WH3jV5FJLIBPk=;
	b=SxS/gCK555XBTvsCJkdrSw749gRmc48oSQeXC2BqV+TLifV8tzyZ931srRZq8Vdi1cfEqa
	cnE4nBoWW7f1RbYrjnlzp+E2Okrp/d8hDacFV4v7q98faax20gcxWWlrDAZLRa/eaPlwtB
	Yvs45RHH3x7dY+Ng9NALZXi8Q9sy6xM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793707446;
	b=PJlSWWR+6Gew7SKnZvJUijRi9hzI/TWhTasxJ6b0BuJTjb5+t/QQM6eRkihbE3XvRq6ZgK
	4C6i1np6UJZnMpCIoRvIh7/8E5nZN5Gygj9YvFPXx45wZ/Go/Av7Ct6O0YPp55kN4RhOS1
	+lgk0VjhONHLk4LLF4nNnwya8clBsGo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DlEqMa82;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 108F840230;
	Tue,  3 Nov 2026 12:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8640E1F000C1;
	Tue,  3 Nov 2026 12:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793707444;
	bh=5WHfBAJW7tBZ/jpc0vscD0oFhU+5t1WH3jV5FJLIBPk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DlEqMa82fbVZ/wFQkULtTKCChAspiAFzDxCBp7GTVibIsug4Us8FezHdufB+IZahV
	 Tpal14x6qpiFlrt+hLxWaHVZQpOAszvYFFcQsM3CFa1K4pcyTZj3fl4b16BjhbqaNy
	 ITjHL9UNi2RUO2xMHBLyGiEnjg2aqfFTWQrI2EiYWvETHs769cBEeWrhlmpxd2TzZ1
	 ZGs5goW1XnHJ5vWmr3s1z5+tiEmSh2M6iMr0hBfwMxH8gcwTzCGUJ5VylS1L3rj93R
	 fEVq9wAG9Q4XoPw79lqLELrgQt57eQUo5M1lh2KM4k0XwbHcs2Y4q39NZPLbv5OXxz
	 0J/bpmgxHeEDw==
Message-ID: <sashiko-outbox-195212@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] Docs/admin-guide/mm/damon/reclaim: improve language
Reply-To: sashiko-reviews@lists.linux.dev
To: "Manuel Ebner" <manuelebnerli@mailbox.org>, "SJ Park" <sj@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>
Cc: "Aveline Noir" <jm5905938@gmail.com>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261103120043.100887-2-manuelebnerli@mailbox.org>
References: <20261103120043.100887-2-manuelebnerli@mailbox.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 12:04:04 +0000
X-Stat-Signature: riqupk93qhictz13anyqhgbpak8izgtt
X-Rspamd-Queue-Id: DE2651C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793707445-779147
X-HE-Meta: U2FsdGVkX1+kj3Py0hue5zPUHoSstKxvT4us49pOGa1CZT11AGg8wCiYyGGXnkc2ynm9eIYorpNW7UcMSoiMgUBEIDYrncyY4m1YMkjW2r9ynNuD0oqUpqg0+2ltxh1mexTg3PoV3v2F6exQJATFqOiISGmg3pDYaN1Kl8kSZWZdzY83Db5U9mx8wuEmmbo+5a20qd96y1l+GTqJ1ajIZvQkCXK/kKGdUYGmax2SmThfl8kyNa6hWLoP1frNLPJkRCcOJgYCIs2F5pvJYJJyMxjWa+pvlvrk0yFPCXfxp8AvT3pTsyjN7BPrOAADumr/OjnPNh3IPtCG4rV2/iXyUVZRZ8NZbPjoDjG47KLV/z07zE04mkXn1JCEt9IJQnQVM7yI9QtqFJr5g+H8G71HUlwvcUKZX9qNKQ3kTGCt3IbZQa/AmQRAsPopNGvrlhLGyKLG+LR1k8YV3mlI5PumbCnIoj22d56As54eIxxHWKWZUFMerC24oILfkMNhyca1kqAln2gnX1bCjs2jiHEmmdMO3fGnybgoo/3o+SQxvAGM1NkWvWEmWrLuh3HYOTGTebooTNe7ImXzmQ1h81sh6K/XkSMpufuGYlEqASBR0xdUEe05Jk/WmExAE3Wd82rt2fU7SAWi5HkSagEqqK7kuwCF0h9WH6civgG+Nv2hLSrK/CKaF0MgQqNTjNcpIXDqwfLoLTrEzvogVUWTBqE2ULEi6J/8r3MwhIaBVqeFe7yY6HB0ceF6EAWk1g5egs27TSXlY6Nbuu4g1cKbDpksHtRLKr2+GxanInOf1xrf1nYxccftNGpW1z7rSTAedc+OsaNI94Vv+C4/C/izqHNIuBuBrb9E57ZaDMxtiqc1jFYydueyYGJhMSKQw6R9ZVSsYjOEO4+bcfXaWbjTK3uzchWB3GFhE2Eww37Yh9s231gMfQyOh726g4F3ZUFdnrKlwSFN/V9JEuIR4ofYPsZ
 tfEfpl7G
 3gYWllKLQGaURNBgZQb71h4rb9KbUDQiCkRdG3WLg+El5rTjqRnN92u8CMBCzaKlJS/9qVAQ5wqyKjGiW10IyuE451X5gwS8oypQfgJ+xyC63iosEo3OmdQFsQB56VM+P5LOuuAucFz+Fpudc3NX9FnMEfa4kx/MI7ofRO75yaTf9HBF+6yZ2aapQnR7Z5WDvBkUbbguAJ6TKnysnTupQ7mdDOt6RWI5kAdfZ16n9KJlcq9NmkPyikcTRo+d4djFfT0XZ1OKzKu67+cOmBpwKKrb6wSBcbFCtJXRWdfQTlxM13LjMzrwJf03dBzMlLNd9iCfxUXPg3N+FjUXlQgr9qcANgeIRRZiyGu0J3aSoEvnkbEtU+vW7oRMmt91aF4nPEYpwTE2rM2pAgArJ+UXOetwTOwX7BDhhiDlhXtua4ozPzk0y6h7tRetTV+p4LNkGxvL3k3c+8/4LonPe4pG9wClzGOookeSCkUfEf2YzdBty2WG9SmYw0cX8+9hhIwaxRq88j1nZ147en735ID1Vg30na5zYPusN5fOjRa0w/7ZY8RFbjFLVejCce0mfBFZ2ILF5TiMwuBJPqw5U6BQK66eBZAVWPS6d6kKpTTuRHTrcrhQN4YhKd3tFwagF92q54cYs7B1yn5djcjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Docs/mm/damon: typo 'aimes' introduced in reclaim.rst
--

commit 553db5dbc4617619eacc8a4470aca6b0504960ff
Author: Manuel Ebner <manuelebnerli@mailbox.org>

Docs/admin-guide/mm/damon/reclaim: improve language

This commit improves the grammar, tense consistency, and phrasing in the
DAMON_RECLAIM administration guide documentation.

> diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentati=
on/admin-guide/mm/damon/reclaim.rst
> index 028947f5da8ec..aeb2770f1d03e 100644
> --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> @@ -4,7 +4,7 @@
>  DAMON-based Reclamation
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> -DAMON-based Reclamation (DAMON_RECLAIM) is a static kernel module that a=
imed to
> +DAMON-based reclamation (DAMON_RECLAIM) is a static kernel module that a=
imes to
>  be used for proactive and lightweight reclamation under light memory pre=
ssure.
>  It doesn't aim to replace the LRU-list based page_granularity reclamatio=
n, but
>  to be selectively used for different level of memory pressure and requir=
ements.

[Severity: Low]
In the DAMON-based Reclamation introduction in
Documentation/admin-guide/mm/damon/reclaim.rst, "aimes" is a typo. Should
this be "aims" instead?

[ ... ]

> @@ -88,7 +89,7 @@ identifies the region as cold, and reclaims it.
>  autotune_monitoring_intervals
>  -----------------------------
> =20
> -If this parameter is set as ``Y``, DAMON_RECLAIM automatically tunes DAM=
ON's
> +If this parameter is set to ``Y``, DAMON_RECLAIM automatically tunes DAM=
ON's
>  sampling and aggregation intervals.  The auto-tuning aims to capture mea=
ningful
>  amount of access events in each DAMON-snapshot, while keeping the sampli=
ng
>  interval 5 milliseconds in minimum, and 10 seconds in maximum.  Setting =
this as
> @@ -113,10 +114,10 @@ quota_sz

[ ... ]

> @@ -137,7 +138,7 @@ quota_mem_pressure_us
> =20
>  Desired level of memory pressure-stall time in microseconds.
> =20
> -While keeping the caps that set by other quotas, DAMON_RECLAIM automatic=
ally
> +While keeping the caps that are set by other quotas, DAMON_RECLAIM autom=
atically
>  increases and decreases the effective level of the quota aiming this lev=
el of
>  memory pressure is incurred.  System-wide ``some`` memory PSI in microse=
conds
>  per quota reset interval (``quota_reset_interval_ms``) is collected and

Also, this isn't a bug, but in the autotune_monitoring_intervals section ju=
st
above:

  Setting this as ``N`` disables the auto-tuning.

and in the quota_autotune_feedback section just below quota_mem_pressure_us:

  While keeping the caps that set by other quotas, DAMON_RECLAIM automatica=
lly

should those also be updated to "Setting this to" and "that are set by" to
match the changes in this patch?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103120043.1008=
87-2-manuelebnerli@mailbox.org?part=3D1

