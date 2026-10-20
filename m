Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E3C4606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 14:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jRdYyCQI
Received: by kanga.kvack.org (Postfix)
	id 806DD6B0166; Tue, 20 Oct 2026 10:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DCA96B0168; Tue, 20 Oct 2026 10:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71A636B0169; Tue, 20 Oct 2026 10:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 533766B0166
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:54:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DA0381A0213
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:54:20 +0000 (UTC)
X-FDA: 85343300280.27.C016C03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 415D7180009
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:54:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRdYyCQI;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792508059;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5ivZiRDgZARjIXxCwRmMWEsN/ju1KWgpHJDr2xQTh4=;
	b=iX3PpiLK9aP+pUwNHf3plQZMMM3NiHh55nheBSr4l3NJQk6YXGJikMM4ot+FfZ1lJMrTRp
	c66M0d+7ZGfZsi5BXMMWnlqDfvh/4COyBJSXmbJigd+YtEicx54dlghi5uKJB2hUGkkl98
	07IM6+gGSXtcDhxeIZRyHoBBSF+p+e0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792508059;
	b=NEvcopbdsbtkJGLkpZyJuM58A8LQwWf2fuvdh/7J6S56xD+iO7/YaYoslwQp46h//huyUO
	bzRx8htOFO1/6ozV7b0InLI/PngRGyYgT5TmIOUrAjZmTGZEhij7hjqpGwFVknSXdE8qNL
	+nMmQGN1Pa21FMB6Y0yGxHToeB6QNxI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRdYyCQI;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C4534390C;
	Tue, 20 Oct 2026 14:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1E21F000C6;
	Tue, 20 Oct 2026 14:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792508058;
	bh=J5ivZiRDgZARjIXxCwRmMWEsN/ju1KWgpHJDr2xQTh4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jRdYyCQIPrzoWk3yqSvHINHIOMhOzE/LSwUZLhN2DE2134XoUqzMFueQqbtvZBH6B
	 +iekQ/ECNmAeiMGoBR4YZUYTIcLgntXbB7ISOet5AoaaWJUVHZCUEZ7O5aOB/gC0Ii
	 oq/qONExx7g9NFJkfnbOXdwwXP37Im9Hc3DjoFexlgTto+AXXPxvbZMj+BEq7PL9YH
	 JHdmskSuwhpuPSPyd/3P7FTD6YK22xFDhWo6t6UkQVR5ZVfGU4uCv+IzHprJNx22QL
	 zOsb37fSQfsKj1GBoIMilY/fk+KQ56JCEeEWCEl9LjIiIPB3O2Hor/VlPJ1ZQZcyhG
	 1BUprXTYfcgNA==
Message-ID: <sashiko-outbox-179201@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] mm/damon/sysfs-schemes: hold damon_sysfs_lock in
 target_value_store()
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261020144726.88978-1-sj@kernel.org>
References: <20261020144726.88978-1-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 14:54:16 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 415D7180009
X-Stat-Signature: 3hmr4wjukdeice1p5zh8sbjcrahu1ioi
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792508059-345058
X-HE-Meta: U2FsdGVkX186Tccpjd4sXpVk/R6gGKHoEcxcY9P6bjQGyBbxIU4/PSY5ybD/HhTOUlkapA1Q/cYk5549ptX/U2lzSF9oqszuBbTjn/vEoYF2nel1zMrmTQznlIXndYSYzjp5AwjNp3ZwM2lKsifrxRk2SLbt0yHxeRmZt2eIFzIIWcFT0q0J07ZEcWPLESaum3wM49l0OB8IL1Ts3gmbgRFd8/iXBJy9q2Bz9p99yUTdgkktbkvSXCqnmGJ/BbNb+9uQTHgaizcp4p3c3KNnykl9vlfVqrE5MytDc/okCD943t8fEig1Z8yUwMhqmHHjOHUvoZl8GL6RmBMs+6SsrYtTvb5k3WQP3NDwq/Hsn143NcCTdj8VS2KYN/5AhjpX9f4v/u3M5qcGpvQxd5bd7mAbA6ekvWUfYWXmu+Dxu85AnqZJG1BmkQORJFo/3M7VdXzu18iGkE0Pn6QZAaA9Dok+17rrGi3KjkV005sem0Egp5693juFjzDWS2JKI6yiaPpHfR/HJUlfXXMH/fKx3ROgYFavMaoWQzQ3kuF9bZJYQcYqsJD5gqHb8RZsoZBBUwO8k1AcXiqe+djK8roBhhYzP8Ca4DT6MLrxmVyAVMr55sPSR4bmy/i7KskTB6oC77pECg1lth70H065IvMDsP/WvX1J7n5Rk1Sknfwpi2+9uQO6nxy07TiyWgTU9ugkL0RTkcZTFo0zL9Mp4skm9doTb4FVneXCxGZh5iAP0ilzAEhuc+cta8M/naRc+7d3YL9frJunSX4OCyIKTLN88eTR2GzmGzIGle9XC6/ZHXviFu1MfjdTiOayBUIxzrNs7FpW2y36cUyAviQt6uww6N2zMnvHBYP4eBRJMpUm+VezPKDwSbM7D84PLfMuV45eEEyAL1ZLg9F+aU0fqfcmUOFGFEkPaN/10SddT90HLE7ISI6H0NWOdctvy7pU47XrLjs/wplm6DynXLR/Ubm
 sFRbJ0Gc
 DTfXv6GmK3RnpqolzYhnoMaaXKGSQw4Ug2ixEDDbpoKH9HJx1fVGaABx0ToBqLI+kgPRTrpdaaA0nT+Ro05F573Z779fuFGVhYkUABAyjQgkoszmyQnfn/shsoL4Fqqa6PuAXbp34VDo12hEZD6ZCXIDdvFTyXG27haqk8OIlSOu8omU0+jilSEiEffypWiPuyIkamvpLlN1Os3kBw9QsHJL48YOnjZb5ytuwmk7D2BrCxL7Ycrc0TTTOIojE5SxKxINCOwqrXm5VJsK7CZlUbSSKwxYHDhojVjDADkEzsL8XWqEGP58Z1/X/pGdaS1ZlindNSuRAXSkCteUs81w0SLatREe1cOwf8s8VojjUy2ty0ay05eXxaCIbQAa6Ed4FXZWkZ4G7jc3p8A21oo13BtVXctMdrw02u4Vp27GhlWv5iU6wSSYCHYLOtOTK0b8FuLw8nDFq0+U35Bp6ajXpNe8lQceeAEUhFjlgCpT8S87wsjW+ofpRdQ0+wCbdeEeZRCisq2ytKEM/licC7wriiWoQxwWmTcVdjjoQjmGqn5X7duzT+XbNwz+jj1KIWYfuTi9XyFwyfW7ZuuzIcVE4+Lo4A4zR9uSEWnrJaLXMloDd2Q2wA6wIuBibvzuEjcwIY5KA
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
- [High] mm/damon/sysfs-schemes: uninitialized stack read in target_value_s=
tore()
--

commit f43fea0015fcb1917385f72d150c59603a9ae43c
Author: SJ Park <sj@kernel.org>

mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_value_store()

This commit holds damon_sysfs_lock in target_value_store() while updating
goal->target_value to prevent a time-of-check-to-time-of-use race with
damon_sysfs_add_quota_score() that could result in a divide-by-zero.

> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index 8f083611741fd..55298a17b653a 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -1355,7 +1355,13 @@ static ssize_t target_value_store(struct kobject *=
kobj,
>  {
>  	struct damos_sysfs_quota_goal *goal =3D container_of(kobj, struct
>  			damos_sysfs_quota_goal, kobj);
> -	int err =3D kstrtoul(buf, 0, &goal->target_value);
> +	unsigned long target_value;
> +	int err =3D kstrtoul(buf, 0, &target_value);
> +
> +	if (!mutex_trylock(&damon_sysfs_lock))
> +		return -EBUSY;
> +	goal->target_value =3D target_value;
> +	mutex_unlock(&damon_sysfs_lock);
> =20
>  	return err ? err : count;
>  }

[Severity: High]
What happens in target_value_store() if kstrtoul() fails (for example,
returning -EINVAL or -ERANGE on malformed input) while damon_sysfs_lock is
not contended?

Since kstrtoul() leaves target_value untouched on error and err is not
checked before acquiring the lock, wouldn't this overwrite
goal->target_value with an uninitialized stack value (which could also be
read back via target_value_show())? Should err be checked and returned
immediately after kstrtoul()?

[]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261020144726.8897=
8-1-sj@kernel.org?part=3D1

