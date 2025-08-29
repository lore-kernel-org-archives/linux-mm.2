Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84ACECA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 01:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64C3A8E0003; Thu, 28 Aug 2025 21:44:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624108E0001; Thu, 28 Aug 2025 21:44:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539EE8E0003; Thu, 28 Aug 2025 21:44:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4042E8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 21:44:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96DE4B9BAB
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:44:03 +0000 (UTC)
X-FDA: 83828099166.02.9F2B69A
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9320CC0005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:44:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=abYz6FDu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756431841;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CHBd+IlZFh0zNXe4qwll2lktsGmbBJatMBbb3xWhGl4=;
	b=TKLRBv/8I/KRsXYxWhmhXix1fFBJO0FZVQlyBOKu2K/Gpkwngt/6cWf2lEflKbFDHNWZyW
	gcl6u69sRxCOZQ5h7FkO8hpy9EzvicF9miaBtKqLbtj4ZbXHeoq0MmvCPcI+GQ3u0ANOks
	gvx1NkQRtJdC0eQmUgp1YIyGXNOgVlo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=abYz6FDu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756431841; a=rsa-sha256;
	cv=none;
	b=FmVZkAS2d0sR00IE7siRn2+6RdN8G74pwjSukz4hAYdaGT3WoLcbo5S1DOj/U5Urdy2Ajd
	Ou7L81xaVqJfyjywA0LDLo3JhhNny291w4hFQt7jlJfqwADj9x0uo+PwXzaLNKAlv4hmTG
	pl7q15+MkLxfKXj+Eh6ATUtPwR5wkNU=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-61c26f3cf0dso2554317a12.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 18:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756431840; x=1757036640; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CHBd+IlZFh0zNXe4qwll2lktsGmbBJatMBbb3xWhGl4=;
        b=abYz6FDuPdu9SGFTHN9i3bB3tkyGyLo6sR39h1d9jY6jgeknp0Hd780pXl8WYhecDu
         La53aF7dt8Qt3XJ50Yn2TdhJl15fSpUhE7OdJk93D8LFuqLu5gg7Ni51SwpasDJr3Jn9
         FUMZSiAiGyzFNbeaZIWIgmHPvuhp+7bWOLK3Bo78lsqCz15xaBQ6eegs6pb5WTWgHyDS
         5uESIrUrijK/dPQoctaQqpvvnlyXG7FXSQ5uSkRsfaYy/JtsocHW9unCDalcT0/iNpTw
         GIGAJD/hcwRNi9pIZqo8m0TjsEcZ27FsU7ZTWAE+L2amz0E5ExtRm9FyM10j3yV4a7Bv
         Qa0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756431840; x=1757036640;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CHBd+IlZFh0zNXe4qwll2lktsGmbBJatMBbb3xWhGl4=;
        b=gAyN7ADmr7LYOJLJXRbRFoLpav68XHnSg5s4HwXY1737nfGk1ZyY1Hui/69BFyDPPr
         kkRfkEEHoH/j583tZQkHcl3HTRYepycNXlSE0rrg7+8MKucfDMYJ5cVEthJj31Ef17Vd
         SvLR3nLRfSgBXLBt+8AbLmKWrd/QQlpaDE+1G4n4RjG/TYLP/wHWpV2+COnJ1V5NaDAn
         F6lyLJrSHXyxKO2Y0sMCW0apVGwbnAvI3qZNMWE/BTuXWM7rg4UY5NFhZX3YXTP4esVQ
         4gHWIkNi5H0GXAHKFqrn38gT/Fz2vEOhks5T8Vo6pDdywx3Wf/RWP78Ily1ZMJ9LbxOp
         j5QQ==
X-Forwarded-Encrypted: i=1; AJvYcCXY3SYH2AufHa2jdtuGtuw26Wqc2OzK8zpW5+xvIfVZMh+5rjTgwNzWx/9bFquJOz/fFW+KNFOK9A==@kvack.org
X-Gm-Message-State: AOJu0YyBEuLbSwDsLCMkT4u72M+tJryqKyv4YP+g99par9sGUy4eDdJt
	4oJ1CLaQjh2DquTzYRD2kDU+exXdhmEIsiMrT8WIkqlPz1CwkTcFP03M
X-Gm-Gg: ASbGncsGswAK2ZywotGgNTYEiTeSRIyH45uIfPOjmwNQIJmiIFrhUbq6aNliJVKW+Z2
	FsiVQ6OqYbbW43bgomY8D7DniF1cY8eoDKBRrxouQkqyNEKa24vjs22lKLN6VB+HuUAliR1a+Pj
	v2fMHxpKrzA4WPzdSE6JH3LNNIrHL/kz+i0+BAKEuGoHYAWfZfSbNMWviIh6rGC9Sp9OVs6KJ4H
	SkB62Q+rVw7eB95Mm1xUAmQ58dmhkP2GonfQiG+3rbw/own6gWAVqESNx20Wh7odtsggZ4kFvhe
	NPGWGUSwgKwgQzOo3xlX1B2l4zx4VmMtVka8QS7yKMi/Z6mI6k966zEDdCsIZDdSq78DQmkrqyv
	Z9xKIbWFfS0e8QM6T6u8o4pw61+QdBIv7pO3V
X-Google-Smtp-Source: AGHT+IGXzVFtf0umylBRxC6/BmYbJC8jpiFexix+nG4HrfEucqpX1yTWR5nqIgNiEJl4btVGLDUxpw==
X-Received: by 2002:a05:6402:2708:b0:61c:58de:85f5 with SMTP id 4fb4d7f45d1cf-61c58de8a22mr13525524a12.31.1756431839732;
        Thu, 28 Aug 2025 18:43:59 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc1c77f9sm781288a12.8.2025.08.28.18.43.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 18:43:59 -0700 (PDT)
Date: Fri, 29 Aug 2025 01:43:58 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Cc: richard.weiyang@gmail.com, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org, davem@davemloft.net, david@redhat.com,
	edumazet@google.com, gnoack@google.com, horms@kernel.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org, lorenzo.stoakes@oracle.com,
	mhocko@suse.com, mic@digikod.net, ming.lei@redhat.com,
	pabeni@redhat.com, rppt@kernel.org, shuah@kernel.org,
	skhan@linuxfoundation.org, surenb@google.com, vbabka@suse.cz
Subject: Re: [PATCH 2/2] selftests: Replace relative includes with
 non-relative for kselftest.h and kselftest_harness.h
Message-ID: <20250829014358.qk3zme4qlaojun53@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250828081026.yx6vgphtsf4pmr3y@master>
 <20250828094016.18063-1-reddybalavignesh9979@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828094016.18063-1-reddybalavignesh9979@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9320CC0005
X-Stat-Signature: i8hnbtf3im4pu5rcod41p5q6qupdq4au
X-Rspam-User: 
X-HE-Tag: 1756431841-533687
X-HE-Meta: U2FsdGVkX19Tz7i2e65rkmuNmeJuh/9U333HfGg8QNBgBmj+ZQb9V4WmqV8gbbfJz9cEkFlKAxSR4MUd/AO4CNMca1LZek9oAyl/xOoV+PqmwZN+/Od4T4HOGrU0poYl7cZlwoIeV4h4U2yqayRSRJ51wNgHiDIgSdpyiKkDYCD6ddf+IbPdRHIYfKRGZMdnRehk65nd96Eafl28m6/jyQekdbumC6GfCj4Qn5ep+ovyh11tv5hhUlqIXTu7fqh0fCGekAcLhoQvc0wGtp2I1NGqOCeMB01B2fsiUCwW1fsCus0KHX5LzyYL8jsejI9eOibunNti8ECNe6pNl99ubLCkghjFT6LCrRAqGrwP0xubt4LpOXGwtuC96UuWXFiP368vO4rmw6LcInwBsD2Kq8o2/BlESL4xUbrvz4eJmXcX3WFHqPt1c7FXRJ0pVG2ppjt1NGezZynbUCf8sdESvydGfq38Dvlf6y9qXQHo2zUMAnJdVCw247xgvABQAJoTd05vTrppw1vRKy+uCv+SPUsCoAr0Z6IYDsUWws3Y0vo2QY1QOAkoXJHrQH5ersfOc8GUodSFnnuXrYdxEC7yDEz2q7TYfsB0gH4V5/Uuw/oHKxCSk0SusMwq/7YkHr5QvplYXsS5fCOkMA490LD47I1FTZjSsLjE4dDjwNAAx9Y8y7y9CVF9X3XknGHZaEnETJKRdZVD32cePYOP455yzJ4vBsdoSARlA4RZ52d6Laiau4HDx6gl7swJs2N+nl+8NZF0ddca+l6eYfVJQ2uhBKr5e3+ZIHr7+wMOaBM17VieVcNzH6oVzUTNnBXuU9j9UMA43nWCoD6MESB6KQD6YMB/QP+8vps8jkMC5IF5rKoVR+1QAvk/YXM1d7/XRLnjoRiPjK/PMCHxmyaiaJWTEvDLReaBRRFtx5E3QvBkq0c0rgWKm5g5DZc+22WEgqs0NeG96oYB0sPxzt7+/V1
 q42e4Pzx
 BuM+kQrwFUU8Ck/0ohWBrANrOac6wR/i0nKNFBOhiL4lrNjGfv0nyAnHGSgPhXjBejQrzbSznOXjGmm5Tw/ASbt5JrMU2Lpzp17tCsx8rgpDkoPCxRGw7SGW8mfDXSLgOkJ/SoOvCPfUyWH3WOJuZ5XEczqHKk5nXPhAvOOCiS/NbHLMFcDpVn5UNX6iQ8SYHdObw5myqftbRp3x/z6qsuc2KFTQQ7epPI9AbWdpkaLd2SuaT+DQbr0W8bNyQ+Fd7+mNHDpTnA2kPIUKbYYs8B1xTZN98o9WU0P7wqZoordX9MCQh+f0MnjyFgSOnaesh65H56cz6LrYACO5ImwHjEKvWLTRl0mH6VYNok+/d8Gvy04N5V9RtMWpzuEyHfIaPBR87BRAgnKklgwtdjWSItJ35UbUYtljaKMg02BBKCh8/uTSvEQuGkEB9687lQREFw+iL3T1itDxLnGM1290eB7ILpt8rFpX4IXl65LCPiNyWjY6T1jDD8g3k/iC6krhy/a6elGimGGiefo8EKBl6fG9T7gZ5juUPqdx40b3jkITyHvcQEieLXqN+EzvYMr+MDfLCCrWzBMWzDug3z/UQyvhbjsiDpVxdNfzlF2L2bB9srpf12aP/MIZzPYfOr7SAPhPXT9Afh5Nc9N8tuPfLsQ3cQWg4EwbCr/J0V43Xqa8WBLZ4Jd7KYbmEEQEpJdx89Y0NNL4mgexKky/gvHcJId65kvjEoTa52M8BEvE+bW2c++pfDxQmnZ85+odSKmRoDlaU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 03:10:16PM +0530, Bala-Vignesh-Reddy wrote:
>Hi Wei,
>
>Thanks for testing and for your feedback.
>
>Yeah, if you try to build inside a subdirectory, the top level
>export may not apply, so CFLAGS don't get updated, and even if
>they did, the path could be pointing to wrong location.
>
>As the docs recommend, building selftest using TARGETS,
>either from kernel source or "tools/testing/selftests/"
>works fine and doesn't fail.
>

But this breaks current behavior. There might be users for this form.

>If you really want to build from selftests/mm/ directory then
>defining KSFT_INCLUDES with a fallback in the Makefile will
>resolve it, but there is no need of it if we stick with "TARGETS=mm".
>

How about add this in local Makefile ?

For example:

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 810bd615b8c3..52f023071619 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -158,6 +158,10 @@ TEST_FILES += test_page_frag.sh
 # required by charge_reserved_hugetlb.sh
 TEST_FILES += write_hugetlb_memory.sh
 
+ifeq ($(KSFT_INCLUDES),)
+KSFT_INCLUDES := -I../
+endif
+
 include ../lib.mk
 
 $(TEST_GEN_PROGS): vm_util.c thp_settings.c
>Thanks
>Bala Vignesh

-- 
Wei Yang
Help you, Help me

