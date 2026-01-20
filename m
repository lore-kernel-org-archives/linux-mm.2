Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E8FBD2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 14:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DB0E6B041C; Tue, 20 Jan 2026 09:04:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5C46B041E; Tue, 20 Jan 2026 09:04:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A9026B041F; Tue, 20 Jan 2026 09:04:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A3936B041C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:04:50 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 193E7D2671
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:04:50 +0000 (UTC)
X-FDA: 84352513140.01.F9BDC59
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4BAA9140003
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:04:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r7hm4McQ;
	spf=pass (imf09.hostedemail.com: domain of glider@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768917888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmM/dV1Q0UanGhFdvF+GkJPZvDrrzI7SS6CZEDHOhsM=;
	b=3V1xOcdKwjN8GO2h6+MASc9Pen84P/t4Lp83MFqmAmGpiv8/KnWSzwU3KOYwUMns7QXZxW
	xwh0vFESLxNov/o744MbY0dr1B7p4yNZfmnj8LM9eXyVK3ak+qe9btVgDOZ4JL9SnZ5x52
	gkUL6ldM0dVxNx9FFHAesMFwn3fj0R0=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r7hm4McQ;
	spf=pass (imf09.hostedemail.com: domain of glider@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768917888; a=rsa-sha256;
	cv=pass;
	b=zne5pE/OyRCdoxPwa7gCJlmw3KI22IGq1RLY58KOhiQlextjl1bCi+2WWgnIeZ+J7vieBW
	CCBlHAv3TFUInUpXffJ3ImDBKlUO9A4Bx5Q2apinOxDrLK3AEUYawcmOJUi1XpZUoDshIL
	SSdoCCZKT8mxnppi3f1M84/UYzWfKF8=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5029af2b4bcso23101301cf.0
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:04:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768917887; cv=none;
        d=google.com; s=arc-20240605;
        b=JDuIyr2OjxmnWEWqIS2MgnhlrdzqDMcIO2QT9KhZJD7Cr0rrkAgADlWdlGSi1/TYYA
         OC5hXZTcEVueP3+UgU1M6VC0QZRd04dVXebGfk61Cj0iXv2lsQ0F/FzZ4VgKOaFCxAw5
         m/xfjsXYzUcXv7tCsx5TMZz3ISehksJFbw+WXB2GluqnRo0WHN8hZQge3Wh+muJPZI25
         LQiGjomQvwBXChDCinO7sgEG/MhvMLTdpE87QuHD+d3S3f6GaKECFjbI9pIYhKFdm4yR
         LDN4QhM9G9+VecUO/L/OqbiLQkpNvxNp5gRY/azdPFhbKhFfR80wRRcMgoV/I2MOec4M
         nhCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jmM/dV1Q0UanGhFdvF+GkJPZvDrrzI7SS6CZEDHOhsM=;
        fh=Lp6BZMEwlyCEYiZwdVlkmnGIIaoZaothNdIC4wNsvcA=;
        b=Rh/ajcEwsst8ea4hHQjtUzneyww3h3+LDOphhHvrHYd7rBiC5RA9Ir2PCjqyXyG84S
         HU78gEN46OL91HORTjeVm9B/Bw8zqDXLCGIM+gtAthrXoVc9FAL8UKa+Mck7ThPZXV8v
         x3I5Hhb+sp4ycgx8luyPr4LkUQIV82QVXyJ43xz5fqwLXkf9+jv62qP4jkfXY5I6ZrT+
         eC6qwsgMrj98TsnCk1BwJKe5rg2YAZLfSYsbvuz6fHSOMQaiJ/hCbtm2968OVmcUmzZU
         8Eqs3bMTAVViW+diSXttcUCIHp7DLjkRMFXwA5yXoSInHNdu5W+0/RH42rZv2PoAPkRb
         k3hg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768917887; x=1769522687; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jmM/dV1Q0UanGhFdvF+GkJPZvDrrzI7SS6CZEDHOhsM=;
        b=r7hm4McQ0WSci98OTA8NBUlmn0UkaCFZA1utwL+WZ32l2ikA107kKDR0Xm7nMW2Jra
         ZeagL1QIIS38l4AMtvEmEd4iiKzcn6Au1P4XomaF0HX9QOWF3Rj5PV4ATS2SG/S0q74W
         tUHJIl0OZD4IxE/Z2fGhP0sY/PurQB4ogPXqzNLrFh/tfAxunKmcNL7Qn44bZ3DZgVGU
         U4PMQFHxGBY2Tdd+EoO7laklo/40xQTxMBfJ6GqDaJow1RT6NLGbK68hsBzLZAFCkoEI
         FN+sj4YFOvNTCit2d7zM6BllYOugq62ngoLzEW1TKCDQBHFC2Sv6hulm9mBrO5da47+R
         EmiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768917887; x=1769522687;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jmM/dV1Q0UanGhFdvF+GkJPZvDrrzI7SS6CZEDHOhsM=;
        b=T8ojrG7SGSBDQIgleIGUW/w/z3TPXot4GNMNrFB/F0VdA7YnwrigqfhsXYzQAkWDV4
         TcG0my4v5P4pNF/8ydFysFFllpHGgFrQWrbX54lYm+DTCC36uw55KkRSWKl/vOIUZMHo
         n9wVvGsugu15bMPpuHYhMUC7A9tDDCUeUIlCyEDtOf4K7yM/7UgYm1Uli73wrO8BUvl1
         5j+zHBHlP9bZJSZi5dxulfhTwlgFLH+W/3F5Ath5EvxAr2j1Zc9TaHqnXKYjh4HWMUQN
         dc0JKqnwmnBYlzxE8fcBRdv8KpyHpwg4Icey1csVTxZVBDK3NMmG0CQv5XH5lgl8aXtu
         +hhw==
X-Forwarded-Encrypted: i=1; AJvYcCVpqIOQesFUQxSUCXFG1MNsL7XeRrpXCDiMm76sBOY5m2VOLiVZ8FnKHGGTvXdg/GeoA/1FeRmo9A==@kvack.org
X-Gm-Message-State: AOJu0Yyz9L0bazzpx4f6WnBLa5i54O1vVoSSRzzg5sEaCwJ86O+OPbfz
	OBWnTfwOlJSETNwN4Eca0UXRA0lo8isLmHQ2q0K5N+fBtzbVKpdMdljLHtjajoEW8Wd+C0CS2By
	uWLX66pPKfRDq5LSB/nst/KyJwAed1RXcUaA/N3hZ
X-Gm-Gg: AY/fxX5ccCFIl986418XKpj8JEcbKwFW4h6hO2wmHXnFIBW5v+f90py5qc3VVqNGjCX
	gGpes4VZ7fuOiIIe+UYuX6fN92EO57NJqXhlNB4TzVWH88SEZ2IAZ3Oe/6kY+tdSExDomhgKQYd
	TbmAB3YfA4QYrfodUeq7g5D8BhGX7hOjihtSmH7sGuUn+7xhIJxyT4ij3jNBDUi7wkpbacKIRKt
	CbwhoDsImksPk/CkAUseZfHj+yzpKmfco5AGscmLGmjK6THVwkXn1QbPEMhni8OBQFKRyKEpATc
	xMLsPUvEcbJ+mi71LVvE0CuZ
X-Received: by 2002:ac8:578a:0:b0:4ed:6dde:4573 with SMTP id
 d75a77b69052e-502d8507492mr21826281cf.52.1768917886535; Tue, 20 Jan 2026
 06:04:46 -0800 (PST)
MIME-Version: 1.0
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com> <20260112192827.25989-5-ethan.w.s.graham@gmail.com>
In-Reply-To: <20260112192827.25989-5-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 20 Jan 2026 15:04:09 +0100
X-Gm-Features: AZwV_QjNl1xBiyaK93_mkyw1s5efrvsnk9WwoFCUyx7252b7lOOknPIAjr9SWYE
Message-ID: <CAG_fn=XG3sGS-_ioH9ThtQf8TCx60vTJZ8Cj33OTfM7FFW62Og@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] kfuzztest: add KFuzzTest sample fuzz targets
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
X-Rspamd-Queue-Id: 4BAA9140003
X-Stat-Signature: gwuxd6fozss1mi6ktznhs3hikr399f15
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768917888-897651
X-HE-Meta: U2FsdGVkX19CSuI3J2FfMYR8ziURTetbIhNRmbBMf430MUey7jp2PZEERJ8TFrD+VfTsAItcZ9VLlSiND/Cb05PgWJaW4rvWjS7WPJL19WElSbhyyMHqvNYiZFCScbaAAa4YiuYRPuA8lRzT5Y+os60BnqSVB8ygkqg+NzavBlBdLRqkn9izE2cfz3dFgx0lEPrlMnV1jaR0++Z3kr8s1B8RC09H4ay4KMAVU2xEQrZtihwK1EvIdAmrrrFbEW2svWyWo0z0XUOwYJUn8UKeNRx7wskIg8mvsAGaRtlQQjdDNAo1mPwWuhPcyAvVFEp6qyTZQ8OhOyRa9eKjGftUUXc4XTDsTPKQ4/mpQWvQNmfkZI5dmH4Hdlq6/nuIBLr3D4qayIrLoF4EmO+3OfKEWnjwia/YaOUZR1TVus+ROSj3v6T5hnZ88XtC/z4DIQ2MQr7W7akLr2wHEL5ANn6aoe3pQRlZR4cirp+G3W4CM04T9SDmJzyrAFaFKTJQkUv9kMNeckQeMdltEUHCa/zmOk3uG1bMUNGoaxFTNIMjXy6op9tgLC9nC7HMhnViPEuk+7QMK+hUPa4S83JCeNwjqb7cTe2V46KhUefigpgTlGsbCjuFJYkYfaIREDsGVZFgbGzKzTAJqRgpBhMsZ1SOojfa+TgOfo8U1TEtjh0W79/m1CiK3L1M0DdMyIsEFpeIdF4z+GOGjs82+g0wqPvV1KMhUBHDrpiReez61Denlp6fweZ9vb6Tlg3WNUEsAwMCKpCW1BQmbj8nYj4KE7zZy1HH2Exjafy47jSYBUk5PPGOjst9wpPFUlNFyMh/rFUY1u4KRZ2RewrrYAVSMOqJ/6EP+4VENJeqaQ4CfILndpK9l8G/L2+nZZy1Po1hP/aLD2FD22fgybuli2EagluAV7SvgwDeI6JfcfBrQTwb1x8Fn6HqjINsNIOE2RIOx2QOmrXln6rCh1BJ/Lbuk6U
 jkcrK3zd
 YSltBs7mzn0aRcfG/XFD+p5Tkszg8iFh1on5UJQWAjqWZcB5V5GHPLP4cLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +#include <linux/kfuzztest.h>
> +
> +static void underflow_on_buffer(char *buf, size_t buflen)
> +{
> +       size_t i;
> +

If buflen is 0, buf is a ZERO_SIZE_PTR.
I think we should allow passing such pointers to test functions, but
each test should then correctly bail out on empty data.

