Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26D4410BA430
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EFA86B00C7; Fri, 27 Mar 2026 03:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0C66B00C9; Fri, 27 Mar 2026 03:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6A66B00CA; Fri, 27 Mar 2026 03:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6790A6B00C7
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:14:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 070C58D771
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:14:17 +0000 (UTC)
X-FDA: 84590979354.10.3A61BFC
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1FF03140009
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:14:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AOgMqHKh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZzuSLhFEjANxlJ2fyZwwyQQ1OfEXmu8TUE3Vg6THPg=;
	b=Wntj2ryc4dK0quC7XdazhoKwJImH/F7jgwacLdYLwRXUS4rCJzWNJ2qrW+Vf8AON66U8+b
	MicDmZAWpsyY9++YLvrfpbQ2Po1cWcIIaHZIBQx8rEPUBE3cTpdiTOLm0lM/MXtrlI7fK0
	FedzVKU1Lnpf8ikvg4UwesvYrJmXSX8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595655; a=rsa-sha256;
	cv=none;
	b=4ge3jXG/4V7zSo+UhCgYzOurgLHdlYAJeQWhubz4RkCLXrItbOcWQK2Spjpz/4MAWGEj0e
	5ONi0b+ACk0ovwDtAnUrehdl2wLOuy3s2ceMcJG81n7tiNpfdZPMx2ZbdAzqeFPibKQOUj
	9sso1TfN66mcB/OjOSFsAyc0gvDG2U8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AOgMqHKh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-823c56765fdso982349b3a.1
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774595654; x=1775200454; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OZzuSLhFEjANxlJ2fyZwwyQQ1OfEXmu8TUE3Vg6THPg=;
        b=AOgMqHKhddmLzdOG2P2rcqTGkS0AqN6zhDPaeS9bOuaLx9S6uvpW6v50+IldvoQtcb
         tmc48KnampNFciYAEWptrNOb1TX1yEssh+OOQArA/xoWherb0cjY7rNLSA2VrdBxKQuW
         /BTR2E/CsrlsVg1HV15dENny6B4u38vny5FqqEtFl9uC8R4G6l61J6JtO70PYfVSpEWe
         IwCDXrqjy8Zncabw7F3seTfW8p9nLLF2dPFJJd43IkuNrJcMXefMnHgMBaUly/0iYJrm
         4IKxo1f119LjBBKPsBLjR/5TB9W96CNlO5V47/K5UtDcKMUXMgbC0AL/9cBk7npDy86f
         tejA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774595654; x=1775200454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OZzuSLhFEjANxlJ2fyZwwyQQ1OfEXmu8TUE3Vg6THPg=;
        b=M1qvGhG88501IS0qPD3WVlkLPYlDEQ4j2wxhe6kzeRy2Ds+Mq9PBf6CKnw5kanLiBC
         UqUdoVekH+SVMKryfBSnelRlJu8GJ2vuybMMbyollkMjQ2KM0xqMFNc2/bKD5bd8NZTh
         NbHTSp+TugLxYjZWezQp/FLLZWm9aylbXbk4XFt7njB6beQyUUkUZ1IVGLQDJfSbXwiT
         3c4EqOK1Uqq9z71uG5/LaK/8gifXwiK/C6zpfDUhgA6jyfObxYcv0E9Hj3/yUUOOJr/P
         X1Wmu9/lihGCbLpacVbhKf0oAyf8j5fO7Z3DH9rNfPoyp0dXq3Tu6erE9piX9pBwft9B
         BcAA==
X-Forwarded-Encrypted: i=1; AJvYcCXeZY5H5STkgwWdUrXAN5027wSTGq53YWBMTFJrmkfandJjb2IQPMr32FPNRdvyVWH6S2FgHLstJw==@kvack.org
X-Gm-Message-State: AOJu0Yx1NOgbGzPU5GceipsNQKOIvf93eMdl42V09rQpFqV30/Td/9JA
	2cqbCGiOdXVZL+hNTuz9SuLlbPs5QkaQwq7gZXmP91G49PUgsxPmNPupGPplng==
X-Gm-Gg: ATEYQzwSQi46u28YTLltB/AcQ+GWLbI0tLgkCpLLb+LTVTwC67i66whbTujuZODfiMc
	mo/zAlkP+B72jd+8uWwmWJEnPaNYotWhI+c42qlrhKPXaMDMC9AwGkS7lv7MmuuGDfSpPlh8oll
	P4SGndr4/FG+6hXH8bWadxIIQkRriDX5WMIHELyQNwjBDVvsD27y1BsefdPTd/2jLnK0iUaW5hK
	v4jFbaUohCDk1dyuhGO4I/Y8/vmDS5W4lF7/XoAbmoIcgHdqmIRX58tCSY/XA5r5+vv+6IkVqNW
	HHjVLxoPyf+8R64MPD55yS9161Jzzn4j2XS/I6b0VttxQEOmHD4wJ+5Pe2H7TrJIl+JPS6f4vza
	5b0Cme1jiXSnPgdpPh8sM/rT2U2XExDvZhucHD2xhslTWO8oHoeBm1+VZvEG+V12KtOu1j8jABx
	2Q3qVwsfmQ2QwTmx9BTQmO1Z88WR8=
X-Received: by 2002:a05:6a00:9084:b0:82a:8aa:cbb6 with SMTP id d2e1a72fcca58-82c9607f50amr1358487b3a.55.1774595653812;
        Fri, 27 Mar 2026 00:14:13 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c7d3c1374sm5208488b3a.44.2026.03.27.00.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 00:14:13 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: (sashiko review) [RFC PATCH v6] mm/damon: add synchronous commit for commit_inputs
Date: Fri, 27 Mar 2026 15:14:10 +0800
Message-ID: <20260327071410.73642-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327070400.71707-1-aethernet65535@gmail.com>
References: <20260327070400.71707-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1FF03140009
X-Stat-Signature: nn453j3zhxuku87qjr1tss6grww6wuas
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774595654-903943
X-HE-Meta: U2FsdGVkX1/w9N6T206Q6a+f0fagwVSVrM8gvQ713nD7H6KdDOhN3q/S7kqllrTSA3Ro7QjlX8QUFBfZLadc0qnAlEJxBBv03ltkhE0sKO+EP8zZ4C66OybiUT+mkPUJs6IB2jCkYVc+/+x1CsnnvD4+D31+g/DLk6y8SLeu/TUBflC8D3ekeslKlOeQL5vliPLESGPh19IniV9jTu5jfi/2x51FI9AMNcU7Vm1oErNmg/zeyHuCzd10uajie5LtP1K7xglAdT0NDr49vXkKtSmEPlacIVDjW+UBtmzIOW/N7XzFRXQ5798pybEunCheGSufYy2K4Q/Wf8G7hYzwIbh6mwbchLvSAJSDkuu2uvff/DDrqNTmS5NYKgN4wLwWMS2P7kUk00EG6QLbjUuC/+hF0ba+oWPecdo2KWuk1Ws04SLuDcQPCgFvnENJwD4DK9dh8VsvCNPck4uP/xy8UBWFaTo7rLvzjTZ0dSuNSxqTQOWng/EUT3Hc+oAIE6qJrLEPSNWGsLwODyRHd3/vEmIKUajcfOkP2OoE0x6YK6a2BCZaeoFGAnalQxx6zka9f3CFi+uMmYt0M1Di82JKAjHtDevanVd+7AhGNCf0x47gDZZ2j5t4rHcidokyhWbf+RhAzrODEJ+n+Z4jR6KFVZGVmuwBGtfp2Cl1TTapMRAXpq1TxLbPN3wzBR0urCwatM1PJ8l3/rbsOX9N7uLLMcfvjuD09woBEBFlKNf29AQv7Wfw7IbzhotbaYGiMK93umsyuo80gV1Ecy9aJ6gLRS46oip5F54okR3aBYYMPKn/NC7lLJ/+f5Kc8rz39SsYfYNUkHszjB1ghJUezGGykDyPlGEZc6K8dHSYZZKhPgrELpb226WQ3zqafJDeDXnSS5iNz996nmAKCyJiuuRwqJ53iuhGwfjN4LYaokZA7gLtxZTTWwRQNi4ubAD0QDYIX7riTBPElrvLZm8IbxX
 EZRvuG+p
 Yo9OiV8CMIHjU1qsGpg43uE0l8zNTclWcc0F84L1gjbYQ7z/JCM03bckHqGleg6tSvjvy/Td1WtU1PlEphyhU/6wIETdYzGm+W1BB2qE4yQoY7sRTmKjAcLrQ7lOMlzxN3zqsJRvJzwTQTaWdekZsa2zI+pyXgEPOFDiAg8g7+dZDRK4lLsZISXk8cV1MYFgD+Sa6e5y15/Yyae17BlhwSJL0GYlX6IZg7/nV8O9pT3ONtrzRbOD0WpHUbiBfvXANUqk65Sk2Xe0ppfjvKnQK/JUvxX/zNZW5uIAYe+gfhUgbPzp/8PtUKBJR0m8zzcTKtGEjC02ToJYkRM0pN8xaW1ALDj7aeUyFHxn+cUnKtXkoxwXLeMKgPX2NhDiPBUF0zNpXplGu5lVZqJBMBtclSdtVGZk8L36H6cerpVQ8lQViB6ikeN8vNONIP2zZS0CWn5eAprd/RrysekEHq+aRgOPpygLku3yAKoEaGVpy56DlkeTYIjk2evDPIyG/W8X5+L5qJxNIeO4AIBASZyUIt0lDPdIA+261FRdXDrK4YkH06N8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260327062558.66392-1-aethernet65535@gmail.com
> # start of sashiko.dev inline review
> commit 405545126e8bb145d7fb1fbb4f36016bc1f6c42c
> Author: Liew Rui Yan <aethernet65535@gmail.com>
> Date:   Fri Mar 27 06:25:58 2026 +0000
> 
> mm/damon: add synchronous commit for commit_inputs
> 
> This commit modifies the commit_inputs_store() callback to use damon_call()
> for synchronously committing parameters in the kdamond thread's context.
> This change aims to ensure validation errors are returned immediately to
> userspace.
> 
> Link: https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com
> 
> > diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> > index 554559d72976..453033f3cb3e 100644
> > --- a/mm/damon/lru_sort.c
> > +++ b/mm/damon/lru_sort.c
> 
> [ ... ]
> 
> > @@ -349,18 +348,47 @@ static int damon_lru_sort_apply_parameters(void)
> >  	return err;
> >  }
> >  
> > -static int damon_lru_sort_handle_commit_inputs(void)
> > +static int damon_lru_sort_commit_inputs_fn(void *arg)
> > +{
> > +	return damon_lru_sort_apply_parameters();
> > +}
> > +
> > +static int damon_lru_sort_commit_inputs_store(const char *val,
> > +		const struct kernel_param *kp)
> > +{
> > +	bool commit_inputs_request;
> >  	int err;
> > +	struct damon_call_control control = {
> > +		.fn = damon_lru_sort_commit_inputs_fn,
> > +		.repeat = false,
> > +	};
> 
> [ ... ]
> 
> > +	err = damon_call(ctx, &control);
> > +
> > +	return control.return_code;
> >  }
> 
> If damon_call() fails, for example returning -EINVAL when kdamond is not
> running, err is set but the error code is never returned or checked.
> 
> Will this cause the sysfs write to incorrectly succeed by returning the
> default control.return_code of 0?
> 
> Should it return err if err is non-zero, or control.return_code otherwise?

Thank you for reminder. I will add
'return err ? err : control.return_code' back in next patch.

> > diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> > index 86da14778658..03e3300ce607 100644
> > --- a/mm/damon/reclaim.c
> > +++ b/mm/damon/reclaim.c
> 
> [ ... ]
> 
> > +static int damon_reclaim_commit_inputs_store(const char *val,
> > +		const struct kernel_param *kp)
> > +{
> > +	bool commit_inputs_request;
> >  	int err;
> > +	struct damon_call_control control = {
> > +		.fn = damon_reclaim_commit_inputs_fn,
> > +		.repeat = false,
> > +	};
> 
> [ ... ]
> 
> > +	err = damon_call(ctx, &control);
> > +
> > +	return control.return_code;
> >  }
> 
> Does this function have the same issue where the return value of
> damon_call() is ignored?

Yes, it have the same issue. Thank you for reminder. :>

Best regards,
Rui Yan

