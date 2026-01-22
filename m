Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69180D6CFAC
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 22:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB05D6B037C; Thu, 22 Jan 2026 17:51:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87CE6B037E; Thu, 22 Jan 2026 17:51:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9DD46B037F; Thu, 22 Jan 2026 17:51:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A8ADE6B037C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:51:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 790291AF16C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:51:26 +0000 (UTC)
X-FDA: 84361097772.01.4302D18
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7849DC0009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:51:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=faicmZmp;
	spf=pass (imf22.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769122284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFDzRwmjx4EhXlLQDIcJTBz1IG6oyRoOclxZcGUtJtM=;
	b=uYffh8QeNl6WjoLp5CWJ4CoDJiHH0v2KGbPlTW7bDrj1L+rzPy2VGgVw1qCxSVKLUQM6T5
	k6gpHbvwczJ7JT8Ecu6oExzGKoF5AuO4visp8uMWqSwA/isGrPSNAXj83nYZQDLhXooPf5
	b+rm4J5LjwwuM7lvH2scAXHyA5EHIPY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=faicmZmp;
	spf=pass (imf22.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769122284; a=rsa-sha256;
	cv=pass;
	b=DeEymCqQxLdQ6zaJ0HnZtq4FurM3/VEAUWjn2Y47UkvFfpFsDqcYAe/BUUPlTGdYaJwC2t
	mIJuX+VK4Y8LibZnz45fHquzy5yK8v6YvlcJtKs5z1fLhQMVZhvkHiy+/WB3rWibukXAQJ
	JGFwAwpNnQkF720x97ay7ESCsReCxk0=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4359a316d89so1220856f8f.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:51:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769122283; cv=none;
        d=google.com; s=arc-20240605;
        b=Gv5jmHWXpdM6Sfz5N3jPpUyrVTSpK+4DkxXNhGqugJTx3zR3Rq7PaU9+NI1KaWw98V
         PsuKfXmImCqHyjxhsZFOQnJ3wI21qeZQytzBYlmrgF9bVEUrZLfzSlH4yjxhVH9I4ZHW
         0Kp/9DWWuz3Z33ITZbLqAuVRa83cTzw88oX8Oo+jgMIcgskxYUD97rBj1JVxtBNiZE5y
         Vi2/GnKMGVPQ4DJ+3w19jjVZTte5zraampCIhEgKDr58G/0ueKWDG2/UhkKnxYnBG+b4
         wNFyq0D2N3Kr01C1a64n+zVJZ3/51Xd89gotPksn8OtFH1JF2KDx7ZDzX3NvWKYYeE3M
         GLBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rFDzRwmjx4EhXlLQDIcJTBz1IG6oyRoOclxZcGUtJtM=;
        fh=87F71ChMhQKovUZp2ylIfOQ4GmpQywvwwhNlywh2Gw0=;
        b=aSHMJlp531sBWqPlciIgJkIbUg/mAZXKxuy3t5/7Z70626INcfki9NYj2K2hMfmYes
         Btc3wOMEYlhW95X16RM/vtrcpTkf8ai4ANHKufL1G7iK/HDp4+IGw2RP7HsV9J9GToQ8
         /TtVMTIqgK9e/GXUMYBO5Uci3waGHsZQKI/cqcMZUVyP1Nr3HUrrdqIiRioRrC04AUu9
         LMxTQG0JklLOfExRoNVBGMMSNWuYBAzinbiXcu1lRFyXU3xc7oumqmmRXSqN1Gg3yeFL
         FyCpsu2JLbbKf35mxqA19TfSacZD6Te5vkDfAbbrsLjqEch5HxLDuFC6c5he32234ps9
         sghQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769122283; x=1769727083; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rFDzRwmjx4EhXlLQDIcJTBz1IG6oyRoOclxZcGUtJtM=;
        b=faicmZmpsyrkOMUE3s4PeRtwhWINRrODnyeo728bqOoWDUwNsggmhEHQaTjsC0cLkM
         CNOIV0YjJme+zAyigmLEVU7rwg4bATuU58eOu3qhwY8Wnk7ouevSdPsB85sIdZPheDp3
         5c7Jhi6wT3mfXIk92AVKvuOVtExhrlQeYNNkVZsHRuN+B/k4ouBN/EogJELEhjWScJGD
         U6/J2kFoYaqIq2uqtmfI5LySVYVQr4d1R7qbHzlSAilIUbe71aY3qvFZJDd6j7idMs8X
         hq4UEtybYRov4RMLmPoaZhSnyU26bPI5Cg7AZU9nnuvgx54EjkDQa09BLXdBjpsxz0bt
         4i3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769122283; x=1769727083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rFDzRwmjx4EhXlLQDIcJTBz1IG6oyRoOclxZcGUtJtM=;
        b=DSV3n+LAkCd71afy0GFclhDAq67CYg2Q14PqkpFdn70er/UIEYJ+0cMUTXj7siRwUv
         HaxW66mgEpH5xKB7pyLs7WfEK24BCWbdi3QQnSUQGkNkKN1r0Plt2MUU6ud2F6N1HqCd
         +qKBRIkJw+O0GqO7fV7b6/XXcpQHivYoftjY+nLwf5GXHKObXCoHjkHt2gPHb2QtACz4
         UadGW4NWB7diz0XY3BTPG6zNso0eE3IQ7d5/oM8+Z4YOhVSn5i4EJn+pSCL2MU2WltGN
         38PeDgibKrtrJ9hfuhK/1eNAYdOfR0HUxXk1CzzB6E5FPOSP6ps6mkMjpB47U+dJKX7Q
         yr2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUW8440CO2J1hM0M6sY+0LPXBGOyts6pOwSpBoYH4xLxn5CwkSO31yFKlmRjeqCKeXpjdyWEMrCgQ==@kvack.org
X-Gm-Message-State: AOJu0YzXeZo54k11CBPvulM1ZsmqXRj/50KbgRoXrurXyIrlMmJRPAAm
	9LXburqYyC4veLJ/DvFCy+UueAkzX8LLVt+hhLo/vPO8Lc2iZBplXQnNkvSy6+EJ9/u7TShI/LL
	5jFOIfO4If+/uF59DJifi/jWx8Prx5Lw=
X-Gm-Gg: AZuq6aKe96KCz/ghGIswNUc5bEoy4VViSyrsHgUP/pqvpa+5hhuXT3uYK3WzIvoMWqJ
	0SIAm1roOCCuRFYPuaob/sk5JfMMDDHL/I6oGrMUp+YS0CQBqRwO5LrLA4w16ZW7ykxb/7kaEvR
	XoHy65tmFz7CP1X+4cs0wtt1jw4wBG8if5asQI9cBBMAZOkl2/wOWtoXYCgAmtvWnB3JZrrMiUl
	jfTm3z33ag3SYq3BZk+n7kTG+jUT+46J/cDci6ym5iOBM3yPW28N0eGdXrJm1IKNC27U2XsLur6
	zyqG2QaXzf2Z1dUIQ4PIbP2q44+yNIhou4hy48dC
X-Received: by 2002:a05:6000:2384:b0:435:96b7:e0db with SMTP id
 ffacd0b85a97d-435b1594374mr1855311f8f.17.1769122282735; Thu, 22 Jan 2026
 14:51:22 -0800 (PST)
MIME-Version: 1.0
References: <CGME20260122041606epcas5p4fb3f5c418b79bf19682e60022d7f1718@epcas5p4.samsung.com>
 <20260122041556.341868-1-maninder1.s@samsung.com>
In-Reply-To: <20260122041556.341868-1-maninder1.s@samsung.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 22 Jan 2026 23:51:11 +0100
X-Gm-Features: AZwV_QhMwzaIv31P0NE6po4NpU8l338O_JlbC8ak064KxR_6vqfyzHCQqvW3ngE
Message-ID: <CA+fCnZe+J-G-g594hXZf2G0BMoCuRbe0yM-gsxxQZSymyx8_MQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] kasan: remove unnecessary sync argument from start_report()
To: Maninder Singh <maninder1.s@samsung.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7849DC0009
X-Stat-Signature: 5g6ahihimrbfmkhaa17fj4paw4gjutnn
X-Rspam-User: 
X-HE-Tag: 1769122284-226155
X-HE-Meta: U2FsdGVkX19ey6/aR9gu0pqjetfLWlKRbksh/u9w16sNhBAHmy5PqNF/KZ2VhGsQC3Mgy6h8QZzeuUSH9WO3O7IFp2VdFBBhiBA4ZcK1yhFQR4gks1zxVvoQYPv+CA3+jTE7DXFPTDSdymyfbc9RnMtDhzCCU+XIiDr058GaNj+2ck7tt+H5xYYAoWdbfDXnCS3CVvinlTplas3+IsQZX7r61/BC8nT7o4jQcmcC5VczcbyYLbW4FRrQPp3dk7YvCmYSvKJxwxiRLDZ87Ege9dl7vw8dUKdVjgj9PAepEH0w9gHvdEtwtqzRerH+77C74NijhIONgmir2eirywQ1lolB0fi8KRA0OazHKdq0wIYWRk9Xk0uMVPdgXjciwgcqE6YGoo7xGJJw3LsEjKK9kZd1hXsOz6noYO62NROta4QAi6UcJ4V8udxHvEctu1PJECIyJf9VjIE6GVb76a5S5d6LSUA7MGV0tydU1QvvV1bSxd+ffjpTONYcvT/SJhkJfalq/DIz5yAMcSH6rGsSuGbVhi9oS/nx0sOn8nbMspYfPcrcDk2sbPaoN+roj+gR+WeDMHE2usEiP/oYj8Ypdu1DedGLWe/p00xbMm0W/aenmbEb1RvVKtCSkWK3OvnYtR0yQmkg9EU1VDwdFit+xfrGNkkCbdKuJ+zJ4Pc4MYYz0agFEC5g/HY8lhD5uLLXGJRoxg/OrL7Dnsfd7hW9boPkiMgFFO1s/KsMXiotVsYneQPJKHj53Qjcn/06UEWkt7kJxWSGHrL8Lvo8NtnoX/7wq8IJs2qiZ1wCTTSo3dKiCQu/r2wAT9x4GaZhzHPFVPaBdVKIBXq/bHgntJA95dNF1Q9I2qL0VMu01ZoQSGNj0oyShcy9Y1X2XhzW5VrhJaiT5tC1saORAIybU3h9g5ELD9rMqPUjTusLdm6y1mOXRY/gtwCSYlWEi87DlJk0R6H1bVpp2/2mbjvyzWd
 SZ8wXRqX
 3U0P0BbrkrAKV86PnyNycUT3UkdI1JIM6PJj/xQlQyqObD6oKeMUpvTrKf/8SyjkOnNGE43T4TW3raU0IqXSBZyO0nUZrv/dyuqpDNwvKUD3YZcY2k0OMxX7TRABIaNN8cNFKsz9PC5rzSohZvXPWp8H6YnAiQkOkLZFT2GOvzZaUxfZNPlraCiyHkVJWIqEsAaWez+BYF0+WrrKGrXcx6/rXcjMar1nZsfgcifA2ZA8B49RxE5Bau8jXjqTNQbPblbLKypOZJMGPCS9Yabfx1auhG0ZgO080GiLfnto78rM/QxYsqScdLuOjSnYcc9J47PJC5emrFBJ3PF664TLCPNooioAXUZ4ycRUB+jcRO85igTLJotb90ZLRJga9NDFdf8/PksOyfLp5RN3moSEJtqDjbtZF7o6+0Q7UNzTi0VLNsYQNyct2DahhIs2mJSHBB7nY9ZAK6CO8c+JXA+9H4zzvHk1ymFysNicuQGLZGV9Hi/Lx47a3jRzN3arsx46gw3M5gd8yhUjtKrtVWcNVZYKB+/lrRBabsureqDjxOcY/pCaP78rdAchHTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 5:16=E2=80=AFAM Maninder Singh <maninder1.s@samsung=
.com> wrote:
>
> commit 7ce0ea19d50e ("kasan: switch kunit tests to console tracepoints")
> removed use of sync variable, thus removing that extra argument also.
>
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
> ---
>  mm/kasan/report.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/kasan/report.c b/mm/kasan/report.c
> index 62c01b4527eb..27efb78eb32d 100644
> --- a/mm/kasan/report.c
> +++ b/mm/kasan/report.c
> @@ -203,7 +203,7 @@ static inline void fail_non_kasan_kunit_test(void) { =
}
>
>  static DEFINE_RAW_SPINLOCK(report_lock);
>
> -static void start_report(unsigned long *flags, bool sync)
> +static void start_report(unsigned long *flags)
>  {
>         fail_non_kasan_kunit_test();
>         /* Respect the /proc/sys/kernel/traceoff_on_warning interface. */
> @@ -543,7 +543,7 @@ void kasan_report_invalid_free(void *ptr, unsigned lo=
ng ip, enum kasan_report_ty
>         if (unlikely(!report_enabled()))
>                 return;
>
> -       start_report(&flags, true);
> +       start_report(&flags);
>
>         __memset(&info, 0, sizeof(info));
>         info.type =3D type;
> @@ -581,7 +581,7 @@ bool kasan_report(const void *addr, size_t size, bool=
 is_write,
>                 goto out;
>         }
>
> -       start_report(&irq_flags, true);
> +       start_report(&irq_flags);
>
>         __memset(&info, 0, sizeof(info));
>         info.type =3D KASAN_REPORT_ACCESS;
> @@ -615,7 +615,7 @@ void kasan_report_async(void)
>         if (unlikely(!report_enabled()))
>                 return;
>
> -       start_report(&flags, false);
> +       start_report(&flags);
>         pr_err("BUG: KASAN: invalid-access\n");
>         pr_err("Asynchronous fault: no details available\n");
>         pr_err("\n");
> --
> 2.34.1
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

Thanks!

