Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CE79606A32F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iMtqhsfg
Received: by kanga.kvack.org (Postfix)
	id 56E1D6B05C0; Sun, 15 Nov 2026 15:43:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51F226B05C7; Sun, 15 Nov 2026 15:43:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7856B05D1; Sun, 15 Nov 2026 15:43:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D7B06B05C0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:43:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 967851407FD
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:43:20 +0000 (UTC)
X-FDA: 85438528560.07.2AAC81C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0B6FA1C0006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:43:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iMtqhsfg;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794775399;
	b=iM+vBUVnaXuUpDGDMa9Lr6SkloduZ79BEKZFo39Zya3i/XITpy5ffvRzszPUxn1C6hIFiM
	BWXa+xxgJMuE5eJo3leKYREj3Zxzv9Ngbl/5pxz0GeKZb6dA62gSt5DlIf54UY/QwxXPE7
	3piXh2mDzSn+QVkeG3INconHj2tTEwo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iMtqhsfg;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794775399;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fiik83/QhvtlEoJI3gCdvb+5phsJYJ4Jyx4TYMDaxuo=;
	b=2b8jwlcQ6KvVwyX+bjnYqS0R/ZKubQcu2oDqonlpjR6pBBcof8lj/WVnTRF3fuHPNGD9uQ
	ANFXsq+YF+WlBIZzw5AKK9MTn+2A4M8eWpoPX+olfaj6HG+pC4I8W7KSwsPmyelFUQetNc
	ojZeLF8OaSlNSE3tF6kIbuTorcHRk2s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95325601BE;
	Sun, 15 Nov 2026 20:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6B61F000C4;
	Sun, 15 Nov 2026 20:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794775398;
	bh=Fiik83/QhvtlEoJI3gCdvb+5phsJYJ4Jyx4TYMDaxuo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iMtqhsfg1BSaB6CmoHW9qLAMQOWX+U8vkukqgvaENhvjEbQcpNgFM/4HPc6empvF5
	 BQD8LqMWfJX5PudsPXZWt4csLVc+LIlZ6Vw3upjElpKKr/dP9eDqIW0kLY2e8hqAnS
	 iX/xBCVyIvAcaaH1YNVCODciUBHcQZNxVQmg5T7kzKf0g5hn+2Et2JDGwSU4L2tlZL
	 YH4eL5YW93zz16k5j+CYqf2+MhnqAOZgz0xtFCaNLSKfTADkrM4DmYRpbUL+sf/uAK
	 5BO2oTfuuFll9DxdFLY73PnIjdU3P1TSVgyP6gKnfzr2CPayFp9F1BizvvkkZx0mFD
	 PdZwvzqs3nrhA==
Message-ID: <sashiko-outbox-215852@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 23/27] mm/damon/sysfs: implement submit command for
 report producer
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261115202849.99134-24-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
 <20261115202849.99134-24-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:43:17 +0000
X-Stat-Signature: jb7tck3otzq99ryr3ttwgp7dsy1zgnm6
X-Rspamd-Queue-Id: 0B6FA1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794775398-673052
X-HE-Meta: U2FsdGVkX1+6zVRUT9+rfL4bGZu+zDKF3omkIprqEprYhiwnu4zL/8TiloRNkElzpLJLWlQp7CjmciVgElsDokg7R+oyE0uegjWwsVKh6SFQIx41qn8E9WOY0JbtsYbtjAZT39TR9Tqva60Ym3V+mFMlpYTFr1skCOZQHOqWI3qkIh1dkPbPC58yKHlsT0uySElvXBOHo3tbhhcL7qEwiyVda3gDO76ry3ypC7rPVOhRdpYJOGFBz95ElnGgJVswDmXGob8HzokbXKKevedAa1u8EgTg8EZIvlTTJanaXsqUp2o6KpLeR+eG6xoUqcUEss//s9oxUTBJtfrpl+7CNZj41gHIySf40kYDdPWCijDPVKs20+w0cm14xcnAnusadGmhztqLBQKaUB3q//zmy7icb/hnIxtTwYMfBNte/aIgYQGG8YRcUtZ8OXgFoKXHakE+ZJTu1FTPi0+sjLL+EZpr5TgndONIenTvtEXEfRnsFeJIY92JmPABhXUZ/LfGOo5BmRiGBey67Qn3MKRmD8w2C/YLiA7MQVthlHgcPPVhgCG+W5LgEdwjd3Bcr+p3d836ZCCdWkW0x5ocfsGW6mUgIwZH8STOIVcygNt+JVdBAAofYdrjsyimf4akEzIf4/etvMHB+GBdyOnYSudpMvB7D6gjf71SJhzl8o856wwn6hrG4cnj7qowMWSOWtIluma0giEfl/GG86pbckXLb4PbftiGCScmn4JJdpfRbB+3MWqfc9eDj7Pxt8befYot02EO5xRzSu2C4tP8TS0UdJA7ebV8kX9vaDaln+WNRaZ58fKppxdxH01Ffp6j8OdjqDHGetrLr3MrPBIw/v3Thiqun41JqZ1Zvn89JA63l8cupamXH3fASeA+TVLCsdGGGmrVJA8sSKdVqQDs7EbJmwzu3Gxe8iVTmV3KyGIRlc88Ueyi9N3siPoFbwQXwwPz5nWRPrrIZ3B2G50m0MF
 kTfc3m7B
 iH6+Jg1AyxFjc4P34MkvTIFIlqkIwuXcG9hdVzCpqDKfx/36lSo1JkxpTDLAErgXS1REpGawjWe2lLDBglTNqnaubYbYTmtd8mZEIJLlJgAJVwRG7I18yHe3uJXIDFxx/xCeCqHu2LTs4y0wU7yMZ51EiygFF1zd4pS55eDPHqAfhpsJ7KfSMlr3fflR9tnbuTgbOHYrRhHKI05BHUKWkDIYocBCqyqEA6mncagwPJiGVwbLOFlNvvdPMGIdu7VDRinLRgoYAYNGWIm/dCiDGbaQLvcjKNcG4XmamhhdDtQrhtSL9PL9MBY6//jXt21Gf087PKnLj6Ctibf9WT26J2GNChorRrn51Y2ql0g0Bxrc0rMeRziEdr6+Sx52fbeHdZ35oj0pF3iJNb9daYHDAs6YAutHHEWsf4TOYlh/XkJN8PXMwOeiVbr49vbst88aG4PWA16OeQYaj4+XMohDBCmlFC/7MAbOtFTr+1Pmdl3WKkuJlyFhbQQtKzA3jMCDp+dlk4ZHN3La/qt0UHYB1dEKLMCtiBWtCZEFk+3jp0wOmnLfe3Q1tnu9l0x+tG31dQ31awPsOEj1jKBiuwGUApngQsQ==
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
- [High] mm/damon: OOB write in damon_submit_report() and read in
  damon_report_exist()
--

commit 2f4ed587e778c0d51407454ba3a19b21c1bc10c0
Author: SJ Park <sj@kernel.org>

mm/damon/sysfs: implement submit command for report producer

This commit adds a "submit" command to producer_state_store() so userspace
can submit manual reports via damon_submit_report().

> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index 5f9bb1955dfd5..0049aac6ab974 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -3107,13 +3107,26 @@ static ssize_t producer_state_store(struct kobjec=
t *kobj,
>  {
>  	struct damon_sysfs_producer *producer =3D container_of(kobj,
>  			struct damon_sysfs_producer, kobj);
> +	struct damon_report report;
> +	int err;
> =20
> -	if (sysfs_streq(buf, "on"))
> +	if (sysfs_streq(buf, "on")) {
>  		producer->enabled =3D true;
> -	else if (sysfs_streq(buf, "off"))
> +	} else if (sysfs_streq(buf, "off")) {
>  		producer->enabled =3D false;
> -	else
> +	} else if (sysfs_streq(buf, "submit")) {
> +		if (!producer->enabled)
> +			return -EINVAL;
> +		if (producer->report_type !=3D DAMON_REPORT_TYPE_USER_REPORT)
> +			return -EINVAL;
> +		report.type =3D DAMON_REPORT_TYPE_USER_REPORT;
> +		report.addr_range =3D producer->addr_range;
> +		err =3D damon_submit_report(&report);

[Severity: High]
Can repeated "submit" writes overflow damon_report_queue.reports[] in
damon_submit_report() and read out of bounds in damon_report_exist()?

mm/damon/core.c:damon_submit_report() {
	...
	tail =3D queue->tail;
	if (tail =3D=3D queue->size)
		tail =3D 0;
	queue->reports[tail] =3D *report;
	queue->tail++;
	...
}

When queue->tail reaches queue->size (1000), damon_submit_report() wraps
only the local variable tail to 0 and still increments queue->tail to
1001 instead of setting queue->tail =3D tail + 1.  On the next submission,
tail is 1001, the equality check against queue->size is false, and
queue->reports[tail] writes past the end of the 1000-element heap array.

In addition, damon_report_exist() starts its backward scan at
idx =3D queue->tail (the next free slot) and dereferences
queue->reports[idx] before decrementing idx:

mm/damon/core.c:damon_report_exist() {
	...
	idx =3D queue->tail;
	for (nr_read =3D 0; nr_read < queue->nr_reports; nr_read++) {
		report =3D &queue->reports[idx];
		if (idx)
			idx--;
		else
			idx =3D queue->size - 1;
	...
}

Before the ring wraps, the first iteration reads uninitialized memory at
queue->reports[queue->tail] while the loop stops before reaching
queue->reports[0], missing a single submitted report entirely; once
1000 reports have been submitted (queue->tail =3D=3D queue->size), the first
iteration reads out of bounds at queue->reports[1000].

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115202849.9913=
4-1-sj@kernel.org?part=3D23

