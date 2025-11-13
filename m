Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E036CD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF3708E0008; Thu, 13 Nov 2025 11:56:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA868E0002; Thu, 13 Nov 2025 11:56:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E09B8E0008; Thu, 13 Nov 2025 11:56:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7AA8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:56:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3CE311A0A62
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:56:06 +0000 (UTC)
X-FDA: 84106186332.15.0BC7282
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4C2E24000E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:56:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NP1f4mnX;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763052964; a=rsa-sha256;
	cv=none;
	b=olz9OGvopvntcyfTFasSL/M1ZxXmSNuhM81Dche5WGoR2h/aizSpEWFRJD24bPdJ48FEEm
	74MC9el16y9xQNjZkCvmzpdZUKt/rTeMtmJvBpJmBJVk47hRfR3XqewOHwS71NbE3dNX2R
	lsg/QCGWIoye1mGmwOsWbZU7/EdjqaM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NP1f4mnX;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763052964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vMCY5fmkZI76R3Lm7+dKka7numEpthvdX92HaVpx2Bo=;
	b=V6NSybflYrxCAbSviQVWTtnNOmm/UyfHAkKwhc8UO5DNBYU2iMoEyesjnHnH5GFWnbgOG6
	BkeZiI+34I8B4al/9fPY4JBULBS1VtAsM1fahaDHFt+AEHC5VCoSz1A3hWB5n5cpwaVh7c
	T+PSmPqOM+Q7iSwx54ed2k+l1oxD828=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so1724010a12.1
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763052963; x=1763657763; darn=kvack.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vMCY5fmkZI76R3Lm7+dKka7numEpthvdX92HaVpx2Bo=;
        b=NP1f4mnX4Kyi2exQVda/5oiMWnwJKoNZFobhCRIOiOaK3/wn/6zvulmIJDT+BzO10r
         s8JPKJp6D2Cktuthz2tQk6TBnbJ5P6m0oFhTyDtFbY0a0jYC+l/+cnT8ValubxCGMtIP
         PO4NWkUDOa1oDhbLf11Kg9sO8shH0YVaKk9IUzf33EeZWHpNdfwjfedGXzYH9jx1dQ1J
         inFpphseCl1Tgr26Po8eEN65SpJHNKEDIQJH38m8rL+hXFiRfffyyNIASZaiuTTyBhMM
         HFF2UkiaWgWhXEQt2sTCRYBq14M4Ng7hbLbcmT6JCOCWa3QlZGh8JYTzhL7PWyYsLRLm
         M5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763052963; x=1763657763;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vMCY5fmkZI76R3Lm7+dKka7numEpthvdX92HaVpx2Bo=;
        b=rSC1uhjP8/5xSzbiJMS3xS+2+G82/UgcwnNYkM01a4O4ClGIUW4wBGLirzhMH6WVOT
         7GyNQTzL8mFRgedD3lbgA5VpdMP422NYK6CxRFi5DJsRCN5kMek8bbA+BORSSZrLVYWj
         g6fr2Otr89MnWNzwBUSUelUJm1z7NcEJo8gtiYs48NIow454vIPmC4VQXsF3Gk73hQt8
         vs0yK+Tgv4DcM/oLnRAZ4bZJ5mM+xdZ/+qmSXjmPBvDU2YkDZ9ubf9vPy1s3ciSUAa2I
         tLXIqMjr1fOaeqKCFOp7J9fig7JKhm3y5AsonwVgaucx7mWEnu68xXR7sCqqvLW8A+dl
         ouMw==
X-Forwarded-Encrypted: i=1; AJvYcCXYE/d4iv8czoPtIejiF0DGQQYVLb9H1wqU4Btb9Go+H4MDLPDKbmkXkzdMAzYQWx57wmZt8C9hMw==@kvack.org
X-Gm-Message-State: AOJu0YwuCEYRumfuD/y9XniS1KxyuoZ9D1QcxgbA7m4nunmwTUN3xnO6
	NXoD3ETFawBygFpP4ZWeZ72CQAgAY/o/M1reejuC8jJVb3jBNFD9ayHWlNJAxi/mknw1xbULwm+
	Y9YXrMJF+oqqxyR4mwA0Sdx256jW6Ulx9d1YrnfdV0A==
X-Gm-Gg: ASbGncucdQ85F2OUTw+2pKynOMyoorLuq3JeVFyV0nUqy15KxGPbp+yU3WH9lDVDZrD
	UqyqlJ/ffaNXyyOUCE+7Ijt2Nv66zcjpjwsA2osqHWuxUD116eFLFbM1FnN/VrNAK6XeQSJxfzz
	zxPucUsJjet9IdF79tqgisOGtgNPjZXhoBJw77IcPhTu9CZ3S7Q84Q9QeEXW3IfQBalaG3FkoRy
	8wMZdgvG6toSgme6uSL2OYHQwhJlw9N9ePMNBUrZ43YdO2mablGb6fxweGjwx+GqSEh
X-Google-Smtp-Source: AGHT+IF7MT7H/N1FGVv2fGcWDDSq4G0lsAr/9izNZqOxycuQNiS8y26Pa9vU+efWnOrN6wB/Co4CNJQLTQPPNB+6gYM=
X-Received: by 2002:a05:6402:20d5:20b0:640:6650:9173 with SMTP id
 4fb4d7f45d1cf-6431a5906c4mr5014541a12.33.1763052961708; Thu, 13 Nov 2025
 08:56:01 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com> <20251107210526.257742-19-pasha.tatashin@soleen.com>
In-Reply-To: <20251107210526.257742-19-pasha.tatashin@soleen.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 13 Nov 2025 11:55:25 -0500
X-Gm-Features: AWmQ_bncXGN-eqIRVfciSwqz1sfkpOsYp0SxgOx72ZS1NRyOW1CKwiM1xe3CWB4
Message-ID: <CA+CK2bBmSD_YftJ-9w1zidLz2=a4NynnLz_gLPsScF145bu5dQ@mail.gmail.com>
Subject: Re: [PATCH v5 18/22] docs: add documentation for memfd preservation
 via LUO
To: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	pasha.tatashin@soleen.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C2E24000E
X-Stat-Signature: 1c973sbfygpgmyk7cozxq8ten5hpyxwk
X-HE-Tag: 1763052964-115608
X-HE-Meta: U2FsdGVkX1/fHD1OTOgXk/vgPGhcX4fpQT6OMGzDwPh7oIkYng+1QmJMQKpaXp0nfZj1iLRSyarFNDgRLVIvU4YCBK5wpXjzYt25EixNlSCjHR+nFhCI74xIsoYcum2jHz0EwoFdaf1YUyO91Q5DRfeYw1KqsYeQsUdH/mXk+8COnWjz4dKvDhQ9JUcIdIHqxx7O4cPidnlYVQeiervnvvQmwUI53SksZSwcPVztqr/X52af/9nbqIPhVjkci5k51/nLT+Vq4L+IXcRRJ39ZCGlUUUxDuf2yWueYVExWR4zDB31e65PUxv96vNRk4dtDOJevqgUDpCa5PNO0TEJMDlK46heg3GeHevp3IjHMKZgoHZNwBfFxt5mzCGAWHNqW8sIa8lTahP3A01+jeZR3QJk98Ss90Y/jflcTOXz9h95NR3THKIJ/7mQYjQAm93QmkLe+sVkCLGoslpTYgBIjJbKo+klblOG+xCODRe1VQ55Nc4PdOtcnoa5uPFS1pPQ2HvofJIf9xw5VV6pE5f6k6AcZqanMLRMxFHRjKRp9lRzSu9Nypfa5gOlxBVQGedKQcrw3SxVZecceYvT2Hhx2V/wcAKokyJ2x+yIZXHVPuZ2LSONKf8sYHyc/CJVUqqJz+SEaFQArl54XQEQgSrITX7tamc9wDVI4pfWD0nHBrdHVapSUib4N1y0NI5IYaClAj+60yBKW9gsOULIJTQoTkNtpH2zT+GuZSZrwOOaZkGMEowtFOHExkf/Y4Bgmags6JMVRaXQGWRZPnupNObZTIGN6IVXmOsyF2ZoYCQdPt/7OpoIFk2z0MrP17qFprYDqsnVgm80sLTTGCj8ec/DYSyB9Ga93AJtmY9BWXzNBV5Cg/Wtv16z4OFDJjW8tWGqE1X9tJ8CiOStO/SY3PxU4SK30l8UpfJkPFkMM6yPHzLdY/GZDmqWg9BVyhv0uwP7Mmr9rlQ4p6XnnPmgFBDp
 0WHQPDWJ
 Og2hP6VoLmapMfCurhlCFMvcjhN1oUeXHpMGJuSSayutKciY7mDd8W9HsSQztnoOqmRfdRdBfiE6jSl1+xFQrsf22CSP1tC8y0DHg09vJ1q445m4mE+kbH7edHukznPq5ymJVvzFYI/RK25HYLQL0fqQkefKHupyd72AdmJJD+GV6faBPwAHaNZKRn+svuWLLmq6xZhkHUoWiJd+jOGLhj24xYKhLEBFGQnzGKKLhCFWOikAAPx++N2DZXAviV4wUJQXX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +Limitations
> +===========
> +
> +The current implementation has the following limitations:
> +
> +Size
> +  Currently the size of the file is limited by the size of the FDT. The FDT can
> +  be at of most ``MAX_PAGE_ORDER`` order. By default this is 4 MiB with 4K
> +  pages. Each page in the file is tracked using 16 bytes. This limits the
> +  maximum size of the file to 1 GiB.

The above should be removed, as we are using KHO vmalloc that resolves
this limitation. Pratyush, I suggest for v6 let's move memfd
documnetation right into the code: memfd_luo.c and
liveupdate/abi/memfd.h, and source it from there.

Keeping documentation with the code helps reduce code/doc divergence.

Pasha

