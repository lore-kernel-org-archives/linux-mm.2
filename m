Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F5E3103E2E7
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 21:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88A9E6B008A; Wed, 11 Mar 2026 17:17:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862346B0099; Wed, 11 Mar 2026 17:17:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761056B009B; Wed, 11 Mar 2026 17:17:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 65F5A6B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:17:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 187BA1A03ED
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:17:30 +0000 (UTC)
X-FDA: 84535043460.22.06C4406
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id F295DC000E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:17:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=multikernel-io.20230601.gappssmtp.com header.s=20230601 header.b=FjVIiRne;
	spf=pass (imf22.hostedemail.com: domain of cwang@multikernel.io designates 209.85.218.53 as permitted sender) smtp.mailfrom=cwang@multikernel.io;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773263848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ppVJFpYyTTg7JU3XTKehbLEEqR9bKUGCgZ4sHi+Bw98=;
	b=bHUysGxQeHqSKu+M7szqaYqCxE6clNAOQshpjqZVqxSN/o3w2T3VHyViuF2QG+kgka+gvO
	msNlnjUnWJ5RiXYgZ0Rcmyj8X/JufX8Ft/MCEKrPgaIdKFheLVL80pL6lgON8SJloxBQQz
	uaElumrFSv4hcr4cKQpRD9OIu+bZgnk=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=multikernel-io.20230601.gappssmtp.com header.s=20230601 header.b=FjVIiRne;
	spf=pass (imf22.hostedemail.com: domain of cwang@multikernel.io designates 209.85.218.53 as permitted sender) smtp.mailfrom=cwang@multikernel.io;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773263848; a=rsa-sha256;
	cv=pass;
	b=4qF0Gs+3IiEbiaMy+0zaeIAVIxb1RFNIDqh9Lq6zNNGFp+IcKTY+sBIpNgWrIvSyYt7fFF
	bwJA1gBV9/btr3eYwSLr7z2KgoLpQtMWqagOVr3xyK/vOZ/lS8DLzPImTUVhmRyFbbddhR
	ZA0ETs/cs04nyjCW8qCrfj6yluHtVco=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b936331786dso34173466b.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:17:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773263846; cv=none;
        d=google.com; s=arc-20240605;
        b=Zql1kxOO2vPAqcRI8Cu2I7/P4WHlIncgU2ipGvVRyzi2PQGKQu995IHk6OyDMYo5B8
         rpjt8s5sIX7GQFGD+5KiCFJX44pRpJJSkDbr2sBvJcEPeqHVVoOFGUJ1pp+ahJ3bo0j4
         irGaMtYshwtzQsKJ4rBHZR1JCeqYxcXFf7xyUUXSoTl/9Rlr4kYgZH0kJO5jxRrlqsSr
         z7vYftOC2zl1dPQXWpM456z0Dtf7hvYT0A9UjfOxcqCGCA/G2txBOCmvGMkXVxaPsj9s
         L6K+Rl7CHufi5FYHYNxV40bcwZltVG3S2quwcqGJ2qjF59NALti0izrsdo8BJ6UCXt2z
         b+8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=ppVJFpYyTTg7JU3XTKehbLEEqR9bKUGCgZ4sHi+Bw98=;
        fh=C3McE8UbAuaCm7f/kTiPnbaRF9+kwvFSOOblcAj1OJM=;
        b=kvhlwnUQbm8bko2K7ajcwtEKn6V8qHP78+ULDsABeyL9xdwpgx0J0kpuIOjr/8Np13
         MeeLw+2xsXKur6H9fR/6Z25qJAA7tLnql1/n2AUY7aAVafcUfgAMvxlpKK0VFCL647TM
         +Wj+rw7aLXd2+ZBMXlgx480OOhUrAsVV9iyfbNhdWzLn+b1+PDi+Cx0y4Fpjd8RR3qdB
         dwRt5+xEsONVaox2DwGfNjHAKF86JpoG88W1Z5Qp3udZ/yPKjIWlWsfBOTXUkZdJkv1f
         Zc1mJfzydCAHyu+LKwQyKvdSz5fio2W4ODBwszIf8ItndeT9yfFWp5RjIbDe+JXjU7Rk
         ci0w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=multikernel-io.20230601.gappssmtp.com; s=20230601; t=1773263846; x=1773868646; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ppVJFpYyTTg7JU3XTKehbLEEqR9bKUGCgZ4sHi+Bw98=;
        b=FjVIiRnevAPWQvJOVQMUc8DqypLmHnOjqGRc4OHPXcXYDJZRzWPUzpxevV4xogo9w+
         7vVBfMaYqLgU8D+DZrYFtfD1CccvvaKeujroHK7xnBlrgDf6l2WxWBcUMdxdvInXgd6R
         O5LDX3Mg9heU3FumkJSWcKtS+1bUGLVb7teun/kV3dDeEaB8xaIe2uXn/Cc6GF+9CaPy
         DNojhLIbJMmxYckxdq8Z0uqmuYWWyCXx5QVEmaC4rZeiBsVOjNjP7Hidqyj8d1uMcSK4
         4Hi9AFjUMkSHwXNZoKPRbkPYGmjjRTajnFQJzMo0ioVHAgTbZ87RLctPSQF60AURcNYK
         +c2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773263846; x=1773868646;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ppVJFpYyTTg7JU3XTKehbLEEqR9bKUGCgZ4sHi+Bw98=;
        b=vmNipp52xhazle6qdHRnfdwsdsx5nhf7ruJpddgy5yIUoOojm061AeQK2XHoGNMbHw
         tWcEtC/I6iBdRM2RnpJNexVJlcZghrpvnBAH6M0TCqzamhdSz83tlPFxBrcMsnwvCopr
         172gffH34uwO0jFmUUbFvmJRd4CvG+RBGOj9zbTH1a1I0+9G7Mad4wVyZRsq6mvnffgd
         WFfv9dcY1KyRttaWgNHmrkyOzt43oc0z+AYS61HuJtd2HsJZQ/vg+ONBBqD/EFfywRP5
         i6tPzll4dIqruZ4SHt951+zjwh5H/RaMiBeQ3ExhwLZ9iA1aIxypibZJeQl7V51jAMr4
         cK8w==
X-Forwarded-Encrypted: i=1; AJvYcCXVnqx7AYJqArPKtXZ0vXFXD64Nlw665i6hPwTDXcLZ0SwjBW+br2+VueVJzKSIeyVb6DQIBUznsw==@kvack.org
X-Gm-Message-State: AOJu0YzS96Kz8DEfuEFi1K28uSDnh2yym+mrWK+b23f+XSLi8bXJuV8C
	+uTZGR7wuDliAKntQClCB/ga0au963UPuq9HrElzdC84PTjLtxLG+XGFIWTLHBP7Fiaik2sUbdr
	SDVJiWJqwCkZUqzzzmjJ9SRnVcFKINT1oTXwuHYABOw==
X-Gm-Gg: ATEYQzwBM2FeNP8OLIe6QuATUsUE929ahhMyOvWTE/W6AfEgX0cLMEc9O/Ym1VenGzJ
	3hh5LqvQHzWfLMo1H0N+XPlEoUM44iIv9V2Ab4QhyJw0HHuDgAaFVFe04KymnTqJDmkN6oINZA3
	dT009ST0lZkLvoGNgEiLlhjAhjulwMaTxCbKqU4VxHoEumHo8ktnTOqPW5RzVTKhD870IMHT/RZ
	b0FtEVTrB0NNOmGa2ltFPHmQamFklIPhMkBLK9z0DXxkB+8vBqx68GloYRJkBkJGYRj/ttccAPa
	3aTy4QtEBVFvuP5n0Tha/zAc+J3KElcihtdoMwFAVRpliqQOIyc7D+Ipat1UZ0ntz9M0TOtT
X-Received: by 2002:a17:907:3d11:b0:b73:8d2e:2d38 with SMTP id
 a640c23a62f3a-b972e5a600cmr212089466b.50.1773263846044; Wed, 11 Mar 2026
 14:17:26 -0700 (PDT)
MIME-Version: 1.0
From: Cong Wang <cwang@multikernel.io>
Date: Wed, 11 Mar 2026 14:17:15 -0700
X-Gm-Features: AaiRm508YzrHCa2l7XXnMVk16snAdeXhGJHQSfniSLO6k-OgyEdUexZ6cgQ_cdY
Message-ID: <CAGHCLaTnT0ZEpWt3wRVBQD8RYuzWuMne1gPY-RvsYE4MqO3nAw@mail.gmail.com>
Subject: [ANNOUNCE] lazy_cma: Runtime contiguous memory allocator without
 boot-time reservation
To: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F295DC000E
X-Stat-Signature: x9814a48qrhw7b89g4a839t1skdpq3zr
X-Rspam-User: 
X-HE-Tag: 1773263847-299619
X-HE-Meta: U2FsdGVkX19iRpRTNk9McWmIlqRJ66a3LcElowY1uBLibCBn8WXFtxs3DD4H5muur8Uq4GEL7Rkq7QGeKFvlfsgXXqzYZtXYZPC66hDfax6dWqQLTlRXXK+n+b2RBU34QsBGvR0LPUL6DqrNoqNtSttV3LfErAgG3IbZ3ANJC4BofQrhi/ij3XXftwFnVmY9ImAz4jQZdERTe2t/MTF6oGDf9fB6jWQ3Hi2inhQlT5JiVGOWBzRVInq+q1Rt1pc24zhtGpymu83Iw1wRQHzgpLXo98xayHSTV71cL4Ki77VjqlQvKld0zk6l2U1D2hE7PzOOVGTBhQIOGh0daEecqExkore5qIEaip1jyVdl7XdU0UoyHyB0AX6jjMVhM7Lwkhg/aypZoQOlSZf3won9hZs1Umvcmnj5HDXpHwUj10lIp7St3j5a2NRYcJnWTPE0FN0RFzgOZBkVCqN1+rzs1cl1azXwksCDX50Fv6vuF8QU2XnhxRTG2Sq1A5ph9BGNx2cpAeEv7wrviMjcJuQ3T4jQnm1kL9vVc2rOnntONTjT/1rzYRdtbLOVudECJnuiKLfEJX3Rfc4veGB8W/tWNa+0dr4wev60TOP9UmfLn5a3a7pR2yoeVwtwhNzOWRMT1Curlw8W+0JlcL9lf3rUfL/JncDxZzu6JZxgB8NEOgoveugvZmmwB2ysiG5uPM89onercCbCh9IQ3BO3OgZz3gnLgYddm1ycqV/8gGgFxmSGo843dRAfRIC+wpJv4dPyxAKs4k01SPd3wDcRWLzr05pfDNNcGuL6Nl5PQ1UrqPiZ6S8rIi4AxcIHn4C63pNCtTUZf5i+dI7KhTU8FgpSEB5DacX09vWTKvwFR2/qa2Aln0AYyc+wN3hul/0cWebIxh6QN1KH/vci5v7cfTsFmtU7TqkOPV5AnyRzd7YNAq9wGUZz3Q8+XOfx7sCeCqA7wvB3QcvdCJ1D+K5rOfn
 FTo9r/ii
 4CLV6jt70qYRQffj8JDMiUnV6rZ65KJLxGZBdpiRyfYFACqEQ3/kUVLkSo4GxwAwlmllCMEYGI9YMvVwsJrTyIkMUvAkbvmlZ88e9F/DIABQQZadxJeB/86sMpEEBQgNjJruZjzTRXo6L941sgSXF8/fVNQ/uesF4FTLvlKWXRxPEP9QR5LjzqG25N6qyCYWU/CbPzAQENOFMGh88pijjAvqx7q/Z057RMTTxvmFjMCWxRgc+4s0pWspK4+LrVcWqurR0XIXN/W0X1/FrDXJQJun7b5uQPshxjGaNwNwjOP4GlInmz2ARH4jICIrVmufmPif+09kquAFGn6sdUakdBHS9hh6umAz6gRAYzm6xB0Y61M022dcz8kq4JerjluIhZMtC3wRTUoTE5vVYRy5wOl4gmqzKG6jl8DfUmbRw9E3lZfVbkKZz4YlsI2WmApyx6SgoSw9pG9K5TGPnxQzWl1BhL7yoyfjAwlzaOdkFiMf0COsqPMF7SFak9OzLbjmtaOQ+uOAcDSGafzNbdenDg9V7iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

I'd like to announce lazy_cma, an out-of-tree kernel module that provides
runtime contiguous memory allocation without requiring any boot-time
reservation.

Anyone who has managed crashkernel= across a fleet knows the pain:
pick a size too small and kdump fails with OOM during boot, pick it
too large and you waste memory on every node. The reservation is set
at boot, so changing it means draining the machine and rebooting.
On heterogeneous memory systems (CXL, PMEM) the problem gets worse
because those ranges are onlined post-boot via dax/kmem and cannot
participate in CMA at all.

The same pain applies to any use case that needs physically contiguous
memory: you must commit to a size in the bootloader before you know
what the workload actually requires.

The tradeoff is that CMA guarantees success from its reserved region,
while lazy_cma is best-effort and may fail on heavily fragmented systems.
In practice it works well when sufficient free memory is available, e.g.
right after boot before the workload has started.

Key features:
 - Allocate/resize/free contiguous memory at runtime via /dev/lazy_cma
 - Allocations registered in /proc/iomem with custom names
 - NUMA node selection for CXL/PMEM

Target use cases:
 - Kdump: reserve crash kernel memory at runtime without the crashkernel=
   boot parameter (see also lazy_kdump in the same repo)
 - DAXFS: allocate physically contiguous backing memory based on
different images
 - Multikernel: carve out physically contiguous memory pool for spawn kernels

Source code: https://github.com/multikernel/lazy_cma

For more details, see the blog post:
https://multikernel.io/2026/03/08/introducing-lazy-cma/

Thanks,
Cong

