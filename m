Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDEBEC44512
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 05:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97DDF6B0088; Sun, 19 Jul 2026 01:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E756B008A; Sun, 19 Jul 2026 01:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8444A6B008C; Sun, 19 Jul 2026 01:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E74F6B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 01:59:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00726A0C35
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 05:59:35 +0000 (UTC)
X-FDA: 85004474310.11.F0ECDBA
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4093320004
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 05:59:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Px/oRN8k";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of shermanpauldylan@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=shermanpauldylan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784440774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JjslKGFeWd4hribL9Nc01nQJxu5zitA/mAnFyKARFv4=;
	b=IIFPgdY0nGpgbyvSA88lTPhjydRCcoFiP3jCZNduJX3LUrq6vi/d9rfCcCS9zGovm/cAXV
	nl5f+d+2JPuV8skGEs/C1j8anfDOzgazxnRK4wYk9RxRRJLzhEyTB0q869eXuzJplWsRi3
	S5INAZekWx3PtN4FbFxPj+IbORW2w2o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Px/oRN8k";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of shermanpauldylan@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=shermanpauldylan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784440774;
	b=KwHt+iI6+qd7tqRv/JXYvwDIQBnhyZy1Ry4ZB+SpIMCHMAnKWx730ROdIwfztIyOPFLmrj
	LHIJXEDbYljSZydLR5Oa87Iq2pnekxJPRaDX3FUOxLcXJZQfcYYOr2wINJPF/AfMsGh5Lr
	gQvsfUEn0wJSxjbaEd9vqAFtAP1iFhQ=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-81ed2a06b9eso38132137b3.3
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 22:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784440773; x=1785045573; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JjslKGFeWd4hribL9Nc01nQJxu5zitA/mAnFyKARFv4=;
        b=Px/oRN8kT15L3EPEEULSW2igLmyw8+5rp/wVrzJWlLBNUwKA0dyBd3/Uwbcsx9yeOJ
         UJ5OH3GQnoG2hJZCwv99CvnB2/u3NZpzP1dRxkGh+6nxeESc6CVDIjHzyPCu39jHeLT0
         kFxYXMP+h7K3oxMYaCvWQ6V+QSWjzmowYJY9c51PAPwgABSWbnowR5Dkw7xX2+tjP9cI
         zOpAp4XR8fvSj4ZyOokSLWhKXRPyYqXT6XG2cw0IurH5dLP31W7GR9xMEWcDKvEY3TS0
         wSXfShI2YGyhw04q9VvHy3WhHEVexpjtYZMYn9fUMDRWZn8yIQFYXMOu26JuGM/qe1J1
         R1QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784440773; x=1785045573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JjslKGFeWd4hribL9Nc01nQJxu5zitA/mAnFyKARFv4=;
        b=TGK4SA9S/mZhGUvecKtqXMz/dJcQNL0nTe3o74/eJhrZHJO5n+IAJ2I6FdZ2koUOG9
         S3ZwquZjLDneh2zH75wY8SI1NfPsPNWV5O3nitIfO54vcXR93vqrdMs//2AnpI3UiYJd
         w+mTv6M8xFrQRUF6kclNdqsHYZCh0rRYCB+2WOgMbtixTMt+wAbffRPlUbPoizP4rQ5S
         7iEwA/un+Akus4G41MRTDuAxObB93SOpdzwITONaiuNO5xQjcDsb2+OnRoK+NTtaHc23
         KlZZVntjZ7Jc7vPn1RekRe5OF74epXlDSHfkKmtv9PNWPkketLFe+q2tBrthnQIGJQzT
         g2jA==
X-Gm-Message-State: AOJu0Yy76UZduhht6Wg0ZUQ2lMb/s2/YL4hQyrHJS9g91wsXTdL/yBKq
	XJI+im3FOnJ68afyMcdFzppNqzXl34aeX60Fo8A/tncGO903eDc2UoVgL6/BcF1F
X-Gm-Gg: AfdE7ckFNB+v27jEU7HV1bRjaEFaLR+y/sqyUnQPHGCdpmNj/fj/EDPuBvxO3pYjNX6
	61TRG0gbu7UllmD/iO3GO8ZWO8msh8vSmdwkNECQFAQx2CQvG+/cj4pUuo8zlszJAiWe+8VLdcV
	OlRRQ+U1zvqGc2gf+huwx8nDRPjBDOz2ZsR1usKJJjktPrHKAjtHplaf4cB652WKNdnVnZIvmYm
	IkoWOl5YmRCRDCjACs4W59gGCIsweo9sPdCA92/1Hggq7WpD8WHbi3Y+4Wt5KEGDLLHzmb/q3dS
	8w/zAQr9NRZXNnUUk0GTPqYC8NHxaY3ZJZT9awS9ESUnZp0JXgUodtsBQwz8I50WINTvt8nr09t
	BAhwP1ui1ze2q/fW5ErUQEzcRTdhlS8IJ+I4EJvbgU7Idttkjl+I26E9wmvmFAbjFjK42AlRTgK
	SRlq8yijYvWmxSqDP3PWqMVP488LpbQR45IwvcuxquTXiaFgevP2tVfcWtfw8iQK/rtg==
X-Received: by 2002:a05:690c:698d:b0:812:c9fa:9910 with SMTP id 00721157ae682-81ef2405ce3mr34117777b3.29.1784440773345;
        Sat, 18 Jul 2026 22:59:33 -0700 (PDT)
Received: from localhost.localdomain ([107.198.84.185])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f07d2830fsm11090537b3.0.2026.07.18.22.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 22:59:32 -0700 (PDT)
From: Paul Sherman <shermanpauldylan@gmail.com>
To: linux-mm@kvack.org
Cc: tj@kernel.org,
	vbabka@suse.cz,
	dennis@kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] mm/percpu: allow embed allocator when total size fits in vmalloc
Date: Sat, 18 Jul 2026 22:59:28 -0700
Message-ID: <20260719055928.1939-1-shermanpauldylan@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260717231616.9126-1-shermanpauldylan@gmail.com>
References: <20260717231616.9126-1-shermanpauldylan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4093320004
X-Stat-Signature: h4opcq9dkwxt5nmpndxbashbfq9fx8ui
X-Rspam-User: 
X-HE-Tag: 1784440774-948334
X-HE-Meta: U2FsdGVkX18yDQCk65eSISuRolMvAyKil91yZB5Cp7KnW7E+jPDukiHGg0hBroUs+Yg1/0gr9gBNdNVAwXaH+iqSIDM0vZNIRDDOQTdKI1HMBqZoraE06iJaT7nZJSxPa4CcwlK2JkBftRb86J9QBhfinILL3SNeZIKTPzUlQMog/ix0TZNmgb3YZ4LEeEvtc4Pc0xFn/OzYk9Du51raYX2r0J1/zidaOtgWxATkAPzOQ+zveNnbSi6VFdQBsmW/CNAdN2/m8eJMP45g4k6B9h6FrCzZUdHeHMJETF8JBRea1twrKC5kQjdowRRrrHulVvSF2Ks2JuC+GrSsKIeKTWjHENJjMS7DN9upJOoX1pGB7XLd1sDriKvElt19WIqzeQQ5VCVOGrGgnlUEhPkuqJYvQnF45ysWNSkKEvmtWwNXcbQoShXHjCSoHPLNnYCNrJV0y7ZoQi6rRCG7FSnki3hRfgEpTNYsgEzGN8pXlDuLh5zzyCcLg3lXOhIUBkd1I4n2xlNMFOn40Rr4FRL08F9RMmMLJmvdKxUe3CYAT4+b5CMDla+wXhNisEY0ZK3wemAjW9AicwXY/KdjPKwFqU3IyXXk4vbO+q0DFx8Pv1cG3OIcUKt6b54jNswutGbQcCLOmmxcqPbWitiXWDDqTrL8X1nspUoOrxhEGXUGXnWKll+ru5PF/YjPJYx/f1BvTJHYaMhdU71KMq072R7KMr3KJ3ljsQhMK/U0wXhxu7yo62fAKMXDhW83Wds1j7G0oQeBblnZk8lnXqM83PVxzZAymHA5hqQylfFbphtWxbLoEskmCuj4GLtgneF+6hgqiUk6ZtlG5zn9xUQgW0YF3BIOYtv7dYv2KXq46tyXd33mZ3Op6lthq3gpEsjLRuhfKvVNqcM8keZ4U3CCBimQ6IIl0meSpNMBAaGqs4IhmVG/5sLLd82TB0r2ZKVsQ1+n3TfBT/wNtBJhrbNZyYa
 dL4R234A
 hVI80gLSGDE0I9759RC+D/zgYsEyLcNub5Q3SVPG5bk6zoYH0Sl73DCBvcORpZmVYM2yr2tSAj6pfce974izlSvs9gi+R56Mw6roi+4vcmxqQ2YlIEzMSMTOYprN5V4F/e1KPI7BvU9Z1kQ54Y3+slfo7daBrIB9K6Isi3CJIF/99LQ5tNJ45t2l/s4OCDlWBSULacQ/hPctNWDBT0yq3axzeU4B1/afdPj+F2s3bo78bkg/NckeK+yH5a263Lif9eCA1jGhLyBw3rn0QbIvRp9XWNXHflbYeiqQoRm8/dX5AEb1WPvEiIDCLEv9MRRATTWFI19JugzmpZ78ISl/rfPvVvPqufcKY9hzlJos7otx18B93LZuhzlgS2a/x1SqWg4/l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew,

Thank you for the encouraging words on the initial submission.

Tejun,

Further testing on SG2042 (Sv39, 4 NUMA nodes, 128GB) showed that
the proposed change allows the embedded first chunk to be created
successfully, but later dynamic chunk population consistently fails
in pcpu_populate_chunk(), with warnings originating from
__vmap_pages_range_noflush(). Reverting the patch eliminates those
warnings on the same hardware.

Looking through the code, my current understanding is that dynamic
chunks inherit the first chunk's layout through the shared
pcpu_unit_offsets[] table, while vmalloc reservations are driven by
pcpu_group_offsets[]. That led me to wonder whether I've encountered
a fundamental allocator invariant rather than merely an implementation
detail.

Is the requirement that all chunks share a single pcpu_unit_offsets[]
layout fundamental to the percpu allocator design, or is there an
intended mechanism for decoupling the embedded first-chunk layout from
dynamic chunk vmalloc mappings?

The answer will help determine whether the correct next step is to
withdraw the patch and instead document the existing invariant, or
whether there's a larger design direction worth investigating.

Thanks,
Paul

