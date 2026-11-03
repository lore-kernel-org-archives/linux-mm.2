Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53AFF606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SkCwXUU5
Received: by kanga.kvack.org (Postfix)
	id 3F4CC6B05B6; Tue,  3 Nov 2026 07:26:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC346B05B7; Tue,  3 Nov 2026 07:26:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AACC6B05B8; Tue,  3 Nov 2026 07:26:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBBC16B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:26:03 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 758281A03CC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:26:03 +0000 (UTC)
X-FDA: 85393729806.02.9B2BD63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DD29220008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:26:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SkCwXUU5;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793708761;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VbeBJ0hSkAu5QaMuXPLVTRueua6XEByOA1C1rz+oDKU=;
	b=VgYp/0m+SjRn3zoGhWFucEsMCIDkJ0zp5YBcLxItCJm5+TN8YDDM39sdxRIfyNjD08gOB8
	/i0dpi8R1tUxR7Vr+DQ8hD9kVc3b5Num+2yILmifhBciRhpuOak1dYe0Fb/zwL2/C5bXfE
	z9HDCAg/W8I8f2aIMloQTi0/+VaiK7w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793708761;
	b=M1muveTwCGWDAx9G4SNlDO8KCYoj+c4APSTh3z+o6GWGuW/v11jRIKc1MPSyIBjx5shezc
	TG7HndMSJApLWSsWa38jJtwxLlsGVBQsmofGdKYIRbC/CNb/OiTfBRuxBTnrhMxhX+beLM
	OZiU+kYC8dH5htHcN8iSqCKEf27JuUM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SkCwXUU5;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3023B42A21;
	Tue,  3 Nov 2026 12:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856C31F000C1;
	Tue,  3 Nov 2026 12:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793708761;
	bh=VbeBJ0hSkAu5QaMuXPLVTRueua6XEByOA1C1rz+oDKU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SkCwXUU5YrjMfn6ZCzTA3wgCyvxEq9hPm/ynTGA9YnwRgkOW/j/6x5pvgK9K7Y1Xc
	 VD3KoKvqdFmxOZcfCwHXBACYGQYihq1TPBz2iO71qmJO4m/WqhKktdUl9q5QpA1MLm
	 hgnfP+bWRyxVPIz4Uz39EJv/z7mQWInUvn3JDbEznPnrZEh9VUlUEPZznDIUmrJLsu
	 Ib7QJTxu9rbCaJeoLKkdWlFhYl1utYGytcmBmIRg432KBT1sbl2g0DJZICBC3WzieH
	 0yYcj87ImVy+xHbUcIlcq50Dk22W5YhhmQ1uT5aKLoZaWhzcpLIZeKaDqh59GIvSmn
	 lIpjtAqnXEzFg==
Message-ID: <sashiko-outbox-195237@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] samples/cgroup: don't let dirname() clobber the
 monitored path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Song Hu" <husong@kylinos.cn>, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org
Cc: tj@kernel.org, tjmercier@google.com, ddrokosov@salutedevices.com, linux-mm@kvack.org, mkoutny@suse.com
In-Reply-To: <20261102122528.1498193-5-husong@kylinos.cn>
References: <20261102122528.1498193-1-husong@kylinos.cn>
 <20261102122528.1498193-5-husong@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 12:26:00 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: cwmzubrztqzptk8p8wxn7nkhix55rqiu
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DD29220008
X-Rspam-User: 
X-HE-Tag: 1793708761-768939
X-HE-Meta: U2FsdGVkX1+X/BScd9SrU8ZL+kI3Vq9dbWXRUQAQJYXiUv9sWDAW4z7zM1LpWDGV1/VWYYeCEOx18TLXMF+/0iw0Yzi+7oOSD1WFkd+2ERyUHApDKCIZv/UU00fs0BGfW3kevU7Tj23eWjADey5PJx+om6V70MUMdp2PzBfIgYSxsHIM9R1LKAByBUMpIBEUaQm2WuqDO3vDuxPmXBpcIDXkDp3XLp86xF4ODL9YaCmW0y1Oj6F+LLztqy4qbF9v8r2s+e3JigynRq39vuDM6kAf1Yd5EZuk200yEvkENBgH9UUaawHX/2D1RredYEERcD7Geeu5tdYYQXIScWl73iSt/I13WpWFChHVbGF2XwFLp2tS82B0F6zZJ6wW7LVfvYZGRM5rLcxDCheCgdIXgdvWg5dSZDH4x/6whHdsT0d77cfD24S1ImoA18wjPUyatsr6GWk7MRhWgYJOxll+gXlzIxb4dYSnyvrm58/fXWgdGUxwtvULj9nqjfn1xexTpC1eHt+ZC6rVsgu/7chY9nuT9n/R64eZPK1fKt1knsSxLuYlzmBekFxEpiEWdy73pmZZLxcN4HHnwiJKZRLhPgQuL2u837D9ofoxdLCwm8WuAa7FZArtmGvctRLpQW8naOwZ96o6uMZ2NgsYuQMcsjG+uFoJaYw82RWjjTQkGJk1wKnSI6mwl/nygvustVbI1p2anQWOHDxWWQU93CUSrV+FFWjkmq2KiDAdiqgGvdAnf6u2TdUZ/vEoVM9P+WmuUoKw+hhHjTjVvDY5x2xVWglc3Rpk00zRKgqaW5SeMGw9zhy9tXhyBkmPyOtd+gfuGeRtkqmvQITcxcly8Ej58qRxWwkZxjUm4X7pF7x97zIrOcwoNQtlRaY+KLVbI/WlE+vN/7EWQYSiXTBbOP6epwyWCjmIEswzw0KCSJudemPQrRz5XzD44jWErMPpbLgzjyio5QFBhJeBwpDLlW7
 jWkda4QV
 h5KgkWl0AzjWlOz6r1+RzNjrPlc2TtMjsJ/iPflnpg1xz7OkQqf2XMYOX496tH5ECTc7tEAYrBQKVsjoS74IfVBq02p1y8UkGbY1y6USq0KbavlhLc+UWN9jWOJ84mxYpYsZrIM82o1kn68UISmdQDveTV9O0db1IIaY2TQBUsa7JB5KkhzRFrO/VvLiJDp4e3UaZl5qiiEtDhuVsVgeYv9TvLQvWSvJ7/bmYxgoQ36koyRgFVfWBCYp3N8OCe4Alz4Fy87Pahj0TxrLX7P+8Ch4usEMY5xh0JOn3DlQe2iwMAUGWSMfeEE2fYi84LBqw8+Ck/hOVWK3gVGYw3P/JKxqMhLFtj9G8OOkWNQyes7eDCjqlPWQSHkKbqZDGkdkWTwuFxq2XiDU2EmNEUJ22sl9T+b0bK1m3Cr6C3C4HeMxOXq5Sd2wIlWahVayOqpv0keKA/kReIBI1ynK+dYGZ1GWSvCmLcjH9GJMQ0sTd56XSUoBM7CyVXB+Empj98aV/U7qbr2yitoPrfMrxV/ckK9mdGVne6BRbO61v+91S3ZM1EKLuggFJeznldke0VRY4o/Z1
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
- [Medium] samples/cgroup: main() prints dirname()-clobbered path instead o=
f argv[1]
--

commit e427c2a6d742e00fa3e83aac4c0262cf23a479ec
Author: Song Hu <husong@kylinos.cn>

samples/cgroup: don't let dirname() clobber the monitored path

This commit duplicates argv[1] with strdup() before passing it to dirname()
in cgroup_event_listener so that dirname() does not modify argv[1] in place.

> diff --git a/samples/cgroup/cgroup_event_listener.c b/samples/cgroup/cgro=
up_event_listener.c
> index 3d70dc831a766..308cacec80a8b 100644
> --- a/samples/cgroup/cgroup_event_listener.c
> +++ b/samples/cgroup/cgroup_event_listener.c
> @@ -26,17 +26,27 @@ int main(int argc, char **argv)
>  	int event_control =3D -1;
>  	char event_control_path[PATH_MAX];
>  	char line[LINE_MAX];
> +	char *path;
>  	int ret;
> =20
>  	if (argc !=3D 3)
>  		errx(1, "%s", USAGE_STR);
> =20
> -	cfd =3D open(argv[1], O_RDONLY);
> +	/*
> +	 * dirname(3) may modify its argument in place; work on a copy so
> +	 * argv[1] still refers to the monitored file when events are
> +	 * reported.
> +	 */
> +	path =3D strdup(argv[1]);
> +	if (!path)
> +		err(1, "Cannot duplicate %s", argv[1]);
> +
> +	cfd =3D open(path, O_RDONLY);
>  	if (cfd =3D=3D -1)
> -		err(1, "Cannot open %s", argv[1]);
> +		err(1, "Cannot open %s", path);
> =20
>  	ret =3D snprintf(event_control_path, PATH_MAX, "%s/cgroup.event_control=
",
> -			dirname(argv[1]));
> +			dirname(path));
>  	if (ret >=3D PATH_MAX)
>  		errx(1, "Path to cgroup.event_control is too long");
> =20
> @@ -76,7 +86,7 @@ int main(int argc, char **argv)
>  		if (ret =3D=3D -1)
>  			err(1, "cgroup.event_control is not accessible any more");
> =20
> -		printf("%s %s: crossed\n", argv[1], argv[2]);
> +		printf("%s %s: crossed\n", path, argv[2]);

[Severity: Medium]
Should printf() in main() keep printing argv[1] here instead of path?

dirname(path) modifies the buffer pointed to by path in place while leaving
argv[1] intact, so switching the printf() call from argv[1] to path causes
main() to print the truncated parent directory rather than the full monitor=
ed
file path.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102122528.1498=
193-1-husong@kylinos.cn?part=3D4

