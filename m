Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C397D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700776B03F2; Tue, 20 Jan 2026 08:24:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8CB6B03F4; Tue, 20 Jan 2026 08:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4DD6B03F5; Tue, 20 Jan 2026 08:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49AAF6B03F2
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:24:31 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1E01C2023
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:24:30 +0000 (UTC)
X-FDA: 84352411500.01.DFF7EB8
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id CD71E120004
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:24:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="3U/8yi50";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of glider@google.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768915468; a=rsa-sha256;
	cv=pass;
	b=luyyLR8fgK62rMUrBPJK6yOBarzgX3Xpm6l5us6j6RMadu+JAuUEH1RkJ6N1Za7BT1wVRo
	xTxFCcmAJgwPfuv/Ldrk6a6H1pIZ13pliEZgRlYkJWjE9utO9ToAeMTrD9evgkKuytExUR
	epaxCu5P3uaokBYbhdlno0YQ9AFgwag=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="3U/8yi50";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of glider@google.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768915468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4nu4xZEY0rSvLbxW/bG040Gc/VM91yZ6fjUuBWMnaOo=;
	b=wmUPBrRWV20MjMfrawoIEWIkGKG3Q3FnZW1YVszNoGwjoeEKudlNtP1h7jxlboN7ghb6oJ
	91+GLSFWjllvIBKGKAM9gYjZ+xyu+UfjQD3FrA4sUhivE+B3jJ+44QPsGqfPaEIAZZoayc
	DQKW3kJZq3nvCOnw0gWaTVA1jES0E+c=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8c6a822068eso530253485a.3
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 05:24:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768915468; cv=none;
        d=google.com; s=arc-20240605;
        b=PAiAJ8w3H9MoNfULk+VNxSiwpqHcGHeDHG4PfmjZ0uq0GDmLYQlzzKbNRea15Cg7XN
         +BMYrBd/4NU4gGQveLQ/LqLjc8jvJVOZ6/ySE4jIz1NcRsO/VfDvoymxC0P6rhxZv9V3
         UyF6xFu3cXuYXVw8BPCEZmSb/eoRC0pffZwnk084UpKqtFhPylxtpyZtFmviKGlSvtRu
         1BbxYl1Ny/T58QTctr5hnjHb6/aIJ+5y39vD9tTZC27mvEPrUBLNtv1cSsKhumYkSfrA
         LcrpKpBuLzVVm/DJpRPVCht3E2qdCztW/K6EntH6ZCbmEYxvM2lBobNyjXp3pPchCCpU
         4ZnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4nu4xZEY0rSvLbxW/bG040Gc/VM91yZ6fjUuBWMnaOo=;
        fh=0BozamZgmg4yJhQmA1UyGh255SabChY6eycwXuauF/Y=;
        b=eXFF02ce3J7YLV7Mkafx8d99LYQ0eRGdtNAyW4J0/Xt1mcS78N4z2y5E7t3XmmoZNI
         vX2RSac7d16s8MD+a7nojqKpC+JDvLwQOxSpVTOHbwn6izrP17FM37di1biedAORzXMu
         WV78AdeNtq5IQ/mE8YYTBZRWs07qhQYRoY9m3nm3B/LctyoNRAqKVLh0/GJc9h7K/CYr
         x/cfp/pXaTmt9hyY6La6mrWy7YHVAEOqwfdXhw88Xbj+9xrZZ4MPeG5i7VDDLxQvw6KH
         CR3LiCNC8v4NhqjiLudmyQ502dH0x5unK6X5ORvDhdTwcwX0jjZFiMrG9aAvnBIYltQZ
         DDqw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768915468; x=1769520268; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4nu4xZEY0rSvLbxW/bG040Gc/VM91yZ6fjUuBWMnaOo=;
        b=3U/8yi50KiybYb64BArTSuV2zSfA/4sUT8MmQEkQ3rcIk9jrar4ZfbGJVNTSy6Y6Ip
         I7XlXkCoTUGl4x6TxjCeOeniXa4xEEQadj5zouufd17SX66Y4Sj/iHVYSAbIYMCNekEi
         urv6lA5dwoPLRpMdwaCNGA9+ZlR7j9NUXM0eG8MltzTyRB/OcHH3iVmGiKzhw/D52w06
         /wJWbsi6VIGw9ApE1z4Blqoa37Vi0QP/hnFBnEhCg9z+q5rNz6mkbohB0j3o4yoSCSIZ
         453zHUOjCjmroXEEJQ9cdo0EZSfl8LhxusWn4Y1PuAAEeNMrO+9ytMBtF7LPxRLbpNPN
         n+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768915468; x=1769520268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4nu4xZEY0rSvLbxW/bG040Gc/VM91yZ6fjUuBWMnaOo=;
        b=r5/vYdGm2sj7Y38cM7OFmWyFj/c2AJZ3s5f5vUyIJF/jeBAVV82VeLNcUiUFUIw3FP
         MsN9MspbrhQa6vxtPdJ+PnGTWuRTFNgw5dEceinjl0idTIkNbaVzl9F72OcAwB7NkbWV
         Gsh3yXbFxisc1MMkaeMsvplUKSC4fniobbilUFeoe5sKyoE+rZQ3lZItBuwemer+jLy/
         4l6QmxCwpmSFUw9A/0NOdn/+gULUpgH5rS44PVTeWaIkgM27MN9N0AGPstb9E1iPNmE9
         E5MWWxjb0pJE0c3/kFfOuqGNCZ56pkOLzhz+0rA5jwucwMztAUh1ddynLTarAiLe9aqI
         zk+A==
X-Forwarded-Encrypted: i=1; AJvYcCX4ohCJy2F10ibXSvzTSze/CWmqo0bA6CuYF99qAcbzcEWG+Sn3NummHP9mnhA62fcUee4kZYTm2A==@kvack.org
X-Gm-Message-State: AOJu0YwvDFUobG9riY00b5iIRwNinNuhqPTGzEqNyjmdYAyvpRl9tty+
	RVRcYzQXg8lmIyPk+HFr/jhtnwvf9VTmjWJO+t483SYjwLo8bKrMA1hA1BLiCP8JMQZ8Rzacdgy
	mQgO/2AUX9eETOqxlG2IEvaLXWCxIJKP2k06GvQvq
X-Gm-Gg: AY/fxX4CnZhLQPJlabTRpUTDlSjV0c7HNHY6+3Peb9szJe2JQllrs1dzj+WaVo8DbGQ
	XPyRmpPxQFjxKI1aFb3kJTqO61Ka3sdbxPO5gVJj8a6pt7vDJjQTdIulREQ2TYXQ8Cr5sOhOwAj
	yCHSRRQ2sfYcGAPOdXhNCUsRs7tDw4ddJVN19qVC7ACebBh42NwrqCH/WUg9fwgw/arvv60tEQ2
	QGe/UbH61/48u8oLm/7l0bgaJMtrXNvT/5y1/gXHC8Yl80OEDudkGuyg4D1crV7+bdoasVoLWdz
	3jT/yHNKKgkXXPeN6eoWU7g0CxNBVhWG3mM=
X-Received: by 2002:a05:620a:a819:b0:8c6:aaf3:cb44 with SMTP id
 af79cd13be357-8c6aaf3cd9bmr1776741585a.4.1768915467445; Tue, 20 Jan 2026
 05:24:27 -0800 (PST)
MIME-Version: 1.0
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com> <20260112192827.25989-2-ethan.w.s.graham@gmail.com>
In-Reply-To: <20260112192827.25989-2-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 20 Jan 2026 14:23:50 +0100
X-Gm-Features: AZwV_QjW2mQ_xeztIGqfilZWMz9KqTXvzLTRYEAqSaJ4no1YJpwzVkinmD1XMRA
Message-ID: <CAG_fn=U46vT+gOAX1D1RxDP3oaduWbsRMs2RWG99U2ND+BM_Vg@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] kfuzztest: add user-facing API and data structures
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, rmoar@google.com, 
	shuah@kernel.org, sj@kernel.org, skhan@linuxfoundation.org, 
	tarasmadan@google.com, wentaoz5@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: my7h7now18idfcgdk9zipozihjt9io68
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CD71E120004
X-HE-Tag: 1768915468-898063
X-HE-Meta: U2FsdGVkX1/sZCNyYcCpeQliMCB17kFqkRweO6tNOT0QGWcZ5oWs7+aGTG0N2cY+57nf4NPWelfl+qbZX4EDb0eKpiVQTHaNgUh+Qme1jWPAwPwIvkZPbCXILRnXVNpI7R83lBjeeF3Tajes/d9UUpCCHksYQWBcVgX2eNOmxUTQC/BhqhdF0bGj6KnYh5ItvruR7zBM/u+DCt0Ulac3Dp9C5Dy/qZ/HgAMoiSL858s3JQ5jQuDjvp8yPD7cRIpSsK8s5VJKUEdZ7skBxzUJisx2+YlJW/+4ackjDDXHqxagV083wuERcHgoMzZY4AlnaaRaW8zRjzwWRADS99x9au7Yaspp4TQH+74OL2en0Cgnme20pcsqhLWTB4CszNHhnXZ0eaVfTy2qhLk8gN/miAthrEzMnM2utLaAZyLYcSwUxECJpckPJfcdgbmx60ZoK/evmEezFJwqXZzJ1O0aqDhMtmkPjUSSRQkbvRL9BI9Mp+7FS5y9BgzkpVPcgFeul/y9zq8Lae+g8OyPgj/Aj8NZNTFYE6vgHrL25hieXx/cCZ38isZACn4gJf7mW7iOqWsI6Mi9+a571YV66k5F1rzNb/GYNjzjOsiXjnIREBFrDngNpWy6T1Refgmyfkk7cliOJAPUXXHtcI4Ylt6dmijxTuVCfEcBbR8kUIJ6tqu9X83dlNl9NOtuH+aDLEYLYyRLs8keGAcXWnb5T4EzpYe1Z6+DaUvOdF6031vEYPnlaS8JU/jkpOkiOy9vN+fmlipuNMWFBnWsA0Z/+MLyCzJL2iqYAgrs9CYmNtWuerTr/PHaQJqbKxHO74tkdqjvtF5w/ZhcrMUnO4xut44SWor75nwJEYH5gbWAyO0itZNVksTA43iz+q3K4ojrRXmxNuhQydr56XtdZzU2XAjCNlLMxZDJisAtTm6mjOLaQwY0rr8hexAjJLreJ1t1EN+00G1pWziRCVd1eW8s6+a
 x68PR7Gz
 DyukF3n9b0Q/buEBK5mJVEwu38kBrfWaRhdqCZChB6ROxgITRsqTrIqfddHTocSbkDWyVqRZTlanJaoD1R8flnWwyDbr+qvVb4kRiDUzbJGS/AZi/IZZZypHw0nm52/qw+XORXq3qvfekuj0g9oa/gZQSy7poXW2umNZGT1iAc8YW41FbEPCSzQVe3PDF0NB+gHEtW9sFeiS9f593NoGTFhhwyXyy6TwM6gpIbUNOk6cSV7m0OjItw++hsOE6MqoC9d3q46WkgGj+2h3ABhYTR8KpOo40M0UTGRvRU1ui6ITDNJcyBMHPIpsgRWFWBU/90toayWFJvDm98kU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 8:28=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:

> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmli=
nux.lds.h
> index ae2d2359b79e..5aa46dbbc9b2 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -373,7 +373,8 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPE=
LLER_CLANG)
>         TRACE_PRINTKS()                                                 \
>         BPF_RAW_TP()                                                    \
>         TRACEPOINT_STR()                                                \
> -       KUNIT_TABLE()
> +       KUNIT_TABLE()                                                   \
> +       KFUZZTEST_TABLE()
>
>  /*
>   * Data section helpers
> @@ -966,6 +967,17 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROP=
ELLER_CLANG)
>                 BOUNDED_SECTION_POST_LABEL(.kunit_init_test_suites, \
>                                 __kunit_init_suites, _start, _end)
>
> +#ifdef CONFIG_KFUZZTEST
> +#define KFUZZTEST_TABLE()                                              \
> +       . =3D ALIGN(PAGE_SIZE);                                          =
 \

Can you remind me if PAGE_SIZE alignment is strictly required here?


> +
> +#define KFUZZTEST_MAX_INPUT_SIZE (PAGE_SIZE * 16)

Right now KFUZZTEST_MAX_INPUT_SIZE is only used in a single C file,
can you move it there?


> + * User-provided Logic:
> + * The developer must provide the body of the fuzz test logic within the=
 curly
> + * braces following the macro invocation. Within this scope, the framewo=
rk
> + * implicitly defines the following variables:
> + *
> + * - `char *data`: A pointer to the raw input data.
> + * - `size_t datalen`: The length of the input data.
> + *
> + * Example Usage:
> + *
> + * // 1. The kernel function that we want to fuzz.
> + * int process_data(const char *data, size_t datalen);

Maybe we'd better use u8 or unsigned char here for clarity?


                                \
> +               void *buffer;                                            =
                                               \
> +               int ret;                                                 =
                                               \
> +                                                                        =
                                               \
> +               ret =3D kfuzztest_write_cb_common(filp, buf, len, off, &b=
uffer);                                          \
> +               if (ret < 0)                                             =
                                               \
> +                       goto out;                                        =
                                               \
> +               ret =3D kfuzztest_simple_logic_##test_name(buffer, len); =
                                                 \
> +               if (ret =3D=3D 0)                                        =
                                                   \
> +                       ret =3D len;                                     =
                                                 \
> +               kfree(buffer);                                           =
                                               \

Please ensure we have includes for everything used in this header
(e.g. linux/slab.h is missing).

