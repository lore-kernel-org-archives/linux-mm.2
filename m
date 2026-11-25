Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A71A606A339
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pp/KvrMf
Received: by kanga.kvack.org (Postfix)
	id 6CD0A6B0B2B; Wed, 25 Nov 2026 17:58:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67BEB6B0B2D; Wed, 25 Nov 2026 17:58:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56C5C6B0B2E; Wed, 25 Nov 2026 17:58:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 30F326B0B2B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:58:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED20DA0197
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:58:48 +0000 (UTC)
X-FDA: 85475157936.10.7B8AB83
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1138914000E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:58:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="pp/KvrMf";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of elkin@google.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=elkin@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795647527;
	b=2AHsdMTH5L3aUru7sXe1xA+RMGYargZZgHQaSGwAXa5H2bqS0iFlIRnmjtY+DjU6aDsEkl
	+WaLieDbjRj5bDNtw7J5rZLbbVP36vZVVqYngNV2d5oKioVX3Qgv4/iUD44gpF5ScTojx5
	tz1sVg8E6H3PJlkoI2ytyC2Q9Bb3jmc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795647527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bifZaCO4TaTv8tA7DvDvwVwTAzZVHPafBMZMdjCezBc=;
	b=izHGWPGgYloCDEaS3nbf5r7nalRRoZKs/UCD3apxY1U4BnTRhReOzRKX/xjQBPIvwc90o0
	3IyausCWe7xhOOHddACzUep0eHDYuAL/dZ0olgb3bn+Dt3a6H+kuDA4EPiw2XGnf0zU9K8
	y5Zr0Hv/gOMaPwa8h8Sw9j2aMPuwvUI=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="pp/KvrMf";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of elkin@google.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=elkin@google.com
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-9906034086cso1760293241.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:58:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795647526; cv=none;
        d=google.com; s=arc-20260327;
        b=rjsC8L0WMGHg1hH9ScWcntbMn9uZHfP+m52ucTiBUArUq91d2rE62oa/HPFmbPRdIz
         INYSoPaK3flZsMLmsVvnDvmR2nmEr/MKaHWPk9+fXNoGo0eyT0eQEDK96qE/L85BN0TX
         mLw1L/1X6DspWLJsvX6viHSTSh8+og3Yp7fjrpzFAwQ5qhm5WDw2w2Eo0bR3ztNHKDFe
         iSk52PgrM9Bl7MNOAx+uPZFp5Sq62Xal6Vh/CsvPU6fKOwHwhPCyVqnxF3y9sItw6Wn5
         ZyQZT2lF89EHjCzjr8ErcHHPMN38ItpOyJAoj/e/kU1lLkrlGhNSZbrUP1gR45eRCU/Q
         F1sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bifZaCO4TaTv8tA7DvDvwVwTAzZVHPafBMZMdjCezBc=;
        fh=C27Ll1c5qNUMtOaTfG3HYfCCbGRSYMdJ2yWQadpM+VE=;
        b=KkrGXJ2DlCWhGKmbWnHkC8C/gVuUaIv7wOdXHJvf1t47DGIEWHIZGIbCm2itU/P5gu
         +ho4njbtTgLFJrGkO8IlXciFifS0REXnjaWsocj22+EPKK3hJ4KEssK9SH+zmPCg/20+
         P03kNAyHNCmmE5kEfUJwlMUUFa8jowqnvPJNdqs3OJTg069QTh3PQmGal764UG4nHPI9
         I9uGv1vwPwkdUKYEGKciS76crOsXMVbP4zUeunNA320qpjwi0aHU11CfMM7j34BSAYBU
         i71/nJP4OvJFYJYHEeD8Sv7nOe9Y6FG9P0sgIGEhM4MFLndXuIdxIm2li6MiIlg6PDZt
         I+6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795647526; x=1796252326; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bifZaCO4TaTv8tA7DvDvwVwTAzZVHPafBMZMdjCezBc=;
        b=pp/KvrMfIwHKhmqkpPNakFI8j8WyUBrOjE0znJsOd5WFKgd7fVxfRrTyOHbZRxlIEU
         Z3dsQXxVfnnfW1nROCgSRhWPNbx/dZEFD32yqH7s5fNLLLWU4t2Q9mDOsqPobKb5EMBe
         846hzpoen+6eIBXrL0aWjmLRQcnZjM7Z4J/6CYpJ+Rjy8ZTkp0PDUGkDhZeu+1F7qhPd
         xDDkM6wI3zKEVGnN4HSudTAAiPIGVXpHGdNB9sI0JR0lGPLXpHcrJmQ8PssVAJfi4yxj
         XHNaqgsTHLMYjPZyr3qyK62g4fY8ShqWP31MgX5On5u/5lbqkAl4tGgenzwOYANv4kkK
         UfvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795647526; x=1796252326;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bifZaCO4TaTv8tA7DvDvwVwTAzZVHPafBMZMdjCezBc=;
        b=w7VlYluAi03N9GtJSrDo3at/Bog33M3NKnyZnvbepams+7Z22GDQ/Lp6rzQfn604DH
         QSh9TU/IMn3D03jnoP8S/XYnj0SrnPZ1+xw7Zkv3wUqLjD5sRb3IeGZWTH2TLzOj2SvD
         WFlyMUv9THnJWiNmXyJcS3caCQRHtQrzQHfe+ujWKjF9GnqLfxqGirFoJIM3xBb8ZKBS
         Xt+NDJq4jk8BYwxhIHl6n+PbNa6i5gYkUsyrLrjHNpiNC7PGNNuAYICOUOGUMDqKCOPj
         xnjmG8YRZlaVCfYZouhKOu0TR1pMBwhY6mHOuQQJNRPxjthevgdCZFtnhaGMQeheWf9T
         BGpA==
X-Forwarded-Encrypted: i=1; AL+hErElNoY/fYeXW3sfzb9dP1RxyT8u9wDHZQAYJsEMxPNvohR7vDwxtJWXHdh3O2tTcJD5jM0mY/StTA==@kvack.org
X-Gm-Message-State: APuU4Z/vbyCos2xKmRgeVE9cdEQpAvWkjfv4REBZ0Jy4LjXgpMix5BSF
	KX1Un9dFyQ0fyhx9PW6N5i8aibL9qngJl+QcHodcglBFXpbaZ1wPOcpfpXb3eKoU+0idl6b4Y9c
	1ETtvElX3/oRWF5l6ZHIBCqPji8xsmU7OzMw21HFC
X-Gm-Gg: AZFdTZf2lyIiIZUIN4PBzCu4IjqMtsgIMfyEVw0HCuCzSlxaMg6EQyflvg8I6nek0DK
	veSLsk+A7BxpYfZF5QxHkz0ghiH6TCykJvxqmXt37K3Vu8uZOUVJUMTydApRH3worPVniBoJM7n
	5vu/QZ3jqZuyi6JhixRCasOidD/pIotE8XTSC8XtweggPydfFEo5LzuDDKKqS1MRZyozwMj8umN
	8k3tfl05a3OfKEotFKGuxNYT4FmFajWdinrglnTiuMVfRRiXn5a15TudH/wpiTzft8ubONactp9
	msFYR3BjzokYhhYpLLdoce99Uq6ZH0abO3oTwMuIoVhZyRblQDYVvUW40Tn1Csq6Ax/62qTjdK7
	DksHBNrg6w77QWiZuGzs97EhFUattCyejgWUTIR8XK9JD3k3avKcRgRGPMPiw1TrP9gc=
X-Received: by 2002:a05:6102:c4b:b0:7cc:174b:f7bc with SMTP id
 ada2fe7eead31-7d7397267a8mr10844584137.15.1795647525632; Wed, 25 Nov 2026
 14:58:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261125222713.1450385-1-elkin@google.com> <16ad231f-0cba-40a0-992a-a0d430da5a91@kernel.org>
In-Reply-To: <16ad231f-0cba-40a0-992a-a0d430da5a91@kernel.org>
From: Elkin Cruz <elkin@google.com>
Date: Wed, 25 Nov 2026 14:58:34 -0800
X-Gm-Features: Aa3M54rX82vBgzUZ__ab0jzhalBL3zfUm3mwj2OyMozxs06Jy0Mm2mHqwLtG9LM
Message-ID: <CAC_6YktiaVRXr3jbfx1ybhhxzHbO4NyMnseg9CLL5CNJgYbCvw@mail.gmail.com>
Subject: Re: [PATCH] mm/migrate_device: use locked folio in migrate_device_{range,pfns}()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	irogers@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Stat-Signature: 16pka4weggkshsp4rkn7dkb8rsezrmw4
X-Rspamd-Queue-Id: 1138914000E
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795647526-560858
X-HE-Meta: U2FsdGVkX1/JYgapostZREm0t90c4fHtCNA/yWrseeioM813dGp+Y2prXfFkAzRE63B1YOMf5YoZk0Mr6aisFsJp8zbtIhIE5C5bIWDegrNeztyW+QldlB9MCFbaIdtQCodFqFEWn7ParXAxabSXd0GzDnCpxYq2t8nxq7S4jIeuVL16ZDylHf5wdhRealKk6qx1qHjsBLS6FYpZ668srlIbYlBdPJGGoNd91RkOAS/APQKrD4DAhqX9nWtETdC6BDz34fQqq45inVVWadXDsbYbEHnK6Bghy9n4fmjwPUSjQ30PBlK81nPdfcDeqTlLemqjKFT2Ze/jXD2BlbiE0RE3CfH3EN7oCRWJOzIy4Cj/KfaRuANctksN7D1/QBabJpmdNp+Cbpx7IJNWrS+aAXFrHK9mO9lxUF+m4rgT6V+dgByUif9As6svEyUMOx481b/fG5pnRHcUtoAH5U+Kmw5u9zOrsQ0yNyC2ZNA5fGOWyB32tvnuRRm1VwsAc4HxXn8dKCavLXFrxt2UJ10YsSMjMjvPPJK1SiixrE3Vn4jfHkqiAjzNBZePvP+paAhCHEJnP1gjbRR0/Dydx2a4kWbvk7sIdtXD08mf3Kl8DEct+12YmBnR0pQP1g/gvGOiEfRoiXIAvxN3GOKPVb1ISfXDeAa23HTPrkXSWPNNxzIaSO0wLrgysDhLoOtVjFiCfZbgHSvziF8ht5XUdqtJDB+qTYMl8lw7IYJ0kHVGd0l9lACB5hvA2KMyr7gnMs5L2umA0sn1fsrjSmkfhJECqUNKTqvbFlLcnowQQgNvHn0KuVnWRD84mu57w1nmcGT7UHruQ3z1m7BxqN48iR0pOQd5zEIah2i6e498M+RBosxbZBDP8gUxf6ao7EupN+p3A79hcELSUFebb+OdhS46ncaxf/fTUkhxuY6y5V3BJVzc4Zr6CRAYrCTS2pVcOj2asjQIy4j0qAsEnRsNOUB
 8p/qkzOb
 mLUCFwWDiAr8zFADuNPxBYXe0AR7GX982FJ0pcU4LoGYx9r7vZQRTOgUTMbdWxuCpHIwWgSEfoCnZK+9asim1brhNquebtw39FhtZwVKRT3BPl1ujELE8s9P/bTozMI6xhMxsCM6uA9vZ0OCj3AeyzEy82z112YDKYfuLMzpNz6P/Bs4Jq/AHli/UdOwqksxCgQSlu0ZfUloB6iG8FnFd/iZ3VAsVyhmAa/Yg1zbHwdyig32CKqsqSShKbWq3jS3Qe2QEcJafmJRNvPifYBmSQ3stYc8bnvFN0LmhyYfGOFCzkbiKpsQOFSJMusZdx3xVoU1L4Ir5Wo4JGK6zsBH+3j//BbL7uygJmD4fz1cFenaN907FHwyUI86KrKdruP+mBlKO2wvbCVrLsls2JmTH4um0cUyo1uHAUmYVTwJCvgkuGL5yPiSTZJCKM6pj0pqDILDPUmKSPGLrPvKvXbh+Rj/7/kqqL692eFKKM+bAXPudlVPz92oM2EH6BMyk0sFL02vsq522qpmxg1VtYwMkB9aTydSAndBsK3ZlY7pnETEk9zNQoKnKjKHc8XKMGOoghQEj/qdtn6SVawZ1WjSSitfWYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Before you send any more: if you cannot reproduce it in the tree, don't report it.

As with the previous report, this one is just a hardening patch on a
theoretical case.

Please ignore this patch.

Thanks again for the feedback!!
Elkin

