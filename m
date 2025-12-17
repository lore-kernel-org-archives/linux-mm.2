Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD0D9D6406A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 01:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB426B0005; Tue, 16 Dec 2025 20:09:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 059316B0089; Tue, 16 Dec 2025 20:09:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99AB6B008A; Tue, 16 Dec 2025 20:09:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7A586B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:09:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7949F14089C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 01:09:54 +0000 (UTC)
X-FDA: 84227181108.09.9745DBA
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 81E99C0004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 01:09:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=illinois-edu.20230601.gappssmtp.com header.s=20230601 header.b=wrmI1lTq;
	dmarc=pass (policy=none) header.from=illinois.edu;
	spf=pass (imf10.hostedemail.com: domain of wentaoz5@illinois.edu designates 209.85.219.41 as permitted sender) smtp.mailfrom=wentaoz5@illinois.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765933792; a=rsa-sha256;
	cv=none;
	b=chMWanFN4Kecop4xuJk9UZfqv9LvFJiouOw5Uueg3GmN7U/DsW3m9TKWm5XDJ1cGqhNQXp
	vgPCs6kraV2Z/Z15rqNqI9GyFKtvzZOWKEXJq9WP1KQ45sK47/giR8nZkz2GmNzVF/itw0
	DC0CLNWh4Z5cBDCtupy97hLG4BLl2aI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=illinois-edu.20230601.gappssmtp.com header.s=20230601 header.b=wrmI1lTq;
	dmarc=pass (policy=none) header.from=illinois.edu;
	spf=pass (imf10.hostedemail.com: domain of wentaoz5@illinois.edu designates 209.85.219.41 as permitted sender) smtp.mailfrom=wentaoz5@illinois.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765933792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZf/eYpssSDfJG49JiyiKh6ythPIDtWBJCMznOyLz/w=;
	b=7SLDtuODEHGJa8bvOMebfTxZ0//O7exV+vKuvt4u4OS9pz48keFJopVRoSAjWthg4180WU
	bSldyoiUWOs2BETnN9ClBk+IUyrxQraLQCPLXV/oL3lyTtesNjz4M9zrca5lxAFI6muF+h
	FPVGaDDcwpLP3tT2LelldnAeH2OBzSo=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-88a3bba9fd4so23299086d6.2
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 17:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=illinois-edu.20230601.gappssmtp.com; s=20230601; t=1765933791; x=1766538591; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zZf/eYpssSDfJG49JiyiKh6ythPIDtWBJCMznOyLz/w=;
        b=wrmI1lTq2OwHR/kmC8/2mW/+aE5vqQ0KReZNh+UBaHNNZxa9wSezEJvBPx5dnW0xUL
         uw2hXdUgfJ5A41nEebk9MgmelS6pej5qW/kPT19iDxqPCn+N6m5VjCc0VDoIboGfBO6L
         Zr502VNGoriKFVnHQZ057NOUS++SUKoB046TNIH4QIm+B67ryjE1bjLnM6TjJyfTk0u+
         oaFPSZaSZkR87OP5EDbXOU1JChldtyrNSW1pXH/09y1O1K87IM0jIORm0P3Ty/er9fqY
         tISDO3Y6Q4v+9PBbghdXyZq/yR+B+D+oXnIw3hftvZa58ue/cptvXyPXCn09EEHzSn3d
         UlTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765933791; x=1766538591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zZf/eYpssSDfJG49JiyiKh6ythPIDtWBJCMznOyLz/w=;
        b=qs5wqfF37UDpIwZ4h97XUD9rxtUUfpbCgI13+HvtiQ1y4z+VDHmfpdsvL0dajcTwH9
         ZUDaEi7KicRSkJNA6kaVBUvDby9CrKpvHobEsZ2+hFGw/UtdAPmG/KavzAVxN4yOcP3Z
         +SL0090+sX7ywTCgy+9ShrGKz4VkhQ+vF3VVLbvePIkPFQmuPJzQhO/iCIhlZQwdkrur
         QedqZe8yvWe9J9O8hoCNeE7gsWLtLC+qyj2SfISuftb8Awi+lw4bgr9jEudetoM/K/Gy
         ZbIg5JXcENeROrIGo4H822t7ydzqOS7MImZamZ8Xo2DynTrq4MPlO9nYc+yRoefz7gPX
         HyXA==
X-Forwarded-Encrypted: i=1; AJvYcCUPBsHL+PRkfflc754phvzRkAy3jwhVXNjphHYnwPF5BfbihV0Y5Y2Ucdie4bPdQNHrshioaqnhqA==@kvack.org
X-Gm-Message-State: AOJu0Yz6VWv8NfyqNj/Sj4hUgho8v/+dQBc06bM/aF4OB7f4pSvmFa2l
	0fcdNckpto280X2v2C5Wf08AAqv1h86GX4SPTx8lEnrND2tewBN8XnwcDtNwI4D5hg==
X-Gm-Gg: AY/fxX6Z/9LNzTu7LmBlvtT2fpPuMJNnz/F6W3O+FQbjMWh8iO08epCcQk8fhfBh96b
	GZYV5RzJW/nmsRB0okmNfX9dqzODbmjdf0QkFEc48ShvgZP8omv2tRByGD0oIONNqRxCA7UoQlK
	pGoXt52Tmo0JKjRwtbZrCt/pvZ4sx6Ow1asro4o57EtKe9Cn+/LGRMmRMzZ58nopZ8LM2JOB5qY
	s1CY2PCSM39QnVInUhlXU2jJ/YfmWCSwKvkj0es6UksOtmtEMk03ob3xvm7U8xwerP73gwVhGy4
	Ld5++AAXwPeTGBLjZEE+OcP0QRAeMGnAKTDS9dqqAtV1lXJHfZLRXfJvS0BeBs25G28gaK2eg9t
	tRYXIMwr+LwFCMJsBAtaYjAi3aGmeWkTnfiRhkg7MReNvCFju6F1snnZtLL8k4Tm4h+gHDYH2o4
	41K/uefpo6CZsZrR9D5JafGbdYMOl9GJ4AQKYr+20aWGzSl1gFtvpzgYbe1hSOd64cPVe4uaah9
	WP1qGe5RZZ2noLoYpd/HfXkZAdIPKIZFw6a/A==
X-Google-Smtp-Source: AGHT+IGjDFK1S6VyM/fYfOLilAfvt70skQ1RowZxJxQP6nlHFavUZNX8qMKoQ5ih8VuDr+Ib7S1xwQ==
X-Received: by 2002:a05:6214:509b:b0:793:dce5:4540 with SMTP id 6a1803df08f44-8887dfec0a2mr293576516d6.2.1765933791524;
        Tue, 16 Dec 2025 17:09:51 -0800 (PST)
Received: from wirelessprv-10-192-243-69.near.illinois.edu (mobile-130-126-255-83.near.illinois.edu. [130.126.255.83])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8be31c75b79sm290605685a.53.2025.12.16.17.09.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Dec 2025 17:09:51 -0800 (PST)
From: Wentao Zhang <wentaoz5@illinois.edu>
To: ethan.w.s.graham@gmail.com
Cc: andreyknvl@gmail.com,
	andy.shevchenko@gmail.com,
	andy@kernel.org,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	glider@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	tarasmadan@google.com,
	Wentao Zhang <wentaoz5@illinois.edu>
Subject: Re: [PATCH v3 00/10] KFuzzTest: a new kernel fuzzing framework
Date: Tue, 16 Dec 2025 19:08:53 -0600
Message-Id: <20251217010853.54863-1-wentaoz5@illinois.edu>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 81E99C0004
X-Rspamd-Server: rspam10
X-Stat-Signature: a8877ie8zh9rog91toa83smgerg8ajgb
X-HE-Tag: 1765933792-933345
X-HE-Meta: U2FsdGVkX1/v9t2pEoCroWgpK8SwAfTvqUTmRlwFmAsPduij30Nysk5T/rJz+LK91nsNamaoaxPa6R1wQjNOH2desvQMqZ6zlY4xBAbwywOsnji+hcRWE96dOqnxkoIRCZ8e/fxfwn4zzeoWogqkQXdtqtREjzDqJAw5/DNDrbRHhcAmM9cZZbyHqRkTQ0eISwmqP3oCc1tycp7SAXLXUnG1pqWWhveQiRmdo6ig8qzDvW68IyBjL4+16t8rPdKdP7mrEaXIFNM+ZVHRDYOSRE6c3UKeBUiiud/r5QXYEzpP8jEUW5add0w9ME1RZh7lJcuL81XBsq0Q1hgWl61Vz73ZyLrJrHIxOayTIfd1vXpR0Gdde41ktCqiYzufVb9P4slvuvMQH+LnHf2HsbsTN3wUy8yr02XES6R1DDiSBzvcaAMDcSNib0u947q2tmHhhYgigL00WTnC9t9upPMpfAxlHeai4UMRMQhm1DvIfieoQds/B/vG+jSTDVVjVqdTGx15j0iXe73LoW9q65fY/zbIezSXAfsVM4rpW4JYQxK79jeTYyAvTQ6WBNSCmMSHlXztowm8ipPaa5mlgB2rgSAzFqu58+4jMs3ZlnZZbtQGbHJKCJDknD4mpiRs0e3dUaBYOaCj8cfy4L+RoqsQpiz4WgmfrdLRTsDPm/gpvn8v8h1NGSXrQHZftbE2RYqXryBWLnBVmPCWO6TyLLodmv3SavUQgNFqRmbGmJWr8f1I2fJIaXsAjBTWQtTQdxCchY6y1bUV4vk45rP0QJA+fbXthUK7Tbs3qg5RcswR2dVZZrzrwqmZmvw1ZJxyT6pYDmsEHzomojx33xo2zGMC4ThLaha+0PsTgJRuna3PVREiGTJ5MbPdxBV+gS6hkk+ppnn27ay7r63kbDYhXdu0e0ZLHazBn8MDLxjQx0PEayTHQh053WBxXte7e8Qt+1JHmau62rg4EXPFiQ7+ORc
 70WAB0P9
 zSj5MxYYVbp4WSsaYkFtuj9XJgRU8BkjIZUo3Q1QFbgWNiA+b+aD+/XDEENOuLHmn2vf5AKE1HYbCz3ob4ahKnGpWTexm+oW8sC1eJDsgChuwz64ST300Z7q/RCGTmJy1dQ/mES9SbsBx21j//0I5a4LwzJ86c7p0dmK7h3T0NL3VZS4AIRZFCsT2xk12Rqnyy+I/QlDz9vwfaMPOTiS/3ScMmA4V3Dfrqf2YYMAer5ffP+5L8zYyQbaWrY70zNkLy4ll2Iz3p6xxwcqJ94uEt+1eWq6n3PMuxafkwThLCspngrbYIFIcnxLf0JD38Fyz9kx0UhKV8bf99cBlVem2Y4ZdV0IdJ4MnGDAwepGWvE7sozAcr7airOBobh7ubTyxI9Gt89Cm4QR7Q+t4t44m4R/rjS8JuUyfvPQ0ZqE+UkZ7uBMMebG+Suh/w29C3cECuNs/at5+uooEU4k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ethan,

This looks interesting!

On Thu,  4 Dec 2025 15:12:39 +0100, Ethan Graham <ethan.w.s.graham@gmail.com> wrote:
> This patch series introduces KFuzzTest, a lightweight framework for
> creating in-kernel fuzz targets for internal kernel functions.
>
> The primary motivation for KFuzzTest is to simplify the fuzzing of
> low-level, relatively stateless functions (e.g., data parsers, format

Do you have any idea how this could be extended to target more stateful
functions?

> converters) that are difficult to exercise effectively from the syscall
> boundary. It is intended for in-situ fuzzing of kernel code without
> requiring that it be built as a separate userspace library or that its
> dependencies be stubbed out. Using a simple macro-based API, developers
> can add a new fuzz target with minimal boilerplate code.
>
> The core design consists of three main parts:
> 1. The `FUZZ_TEST(name, struct_type)` and `FUZZ_TEST_SIMPLE(name)`
>    macros that allow developers to easily define a fuzz test.
> 2. A binary input format that allows a userspace fuzzer to serialize
>    complex, pointer-rich C structures into a single buffer.
> 3. Metadata for test targets, constraints, and annotations, which is
>    emitted into dedicated ELF sections to allow for discovery and
>    inspection by userspace tools. These are found in
>    ".kfuzztest_{targets, constraints, annotations}".
>
> As of September 2025, syzkaller supports KFuzzTest targets out of the
> box, and without requiring any hand-written descriptions - the fuzz

Do you happen to have some numbers on coverage, convergence time etc.
before and after KFuzzTest?

Thanks,
Wentao

> target and its constraints + annotations are the sole source of truth.
>
[snip]

