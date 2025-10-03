Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 200FBCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 22:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F3C8E0003; Fri,  3 Oct 2025 18:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A91D8E0002; Fri,  3 Oct 2025 18:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3707E8E0003; Fri,  3 Oct 2025 18:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4588E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 18:51:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A3DC95BCFD
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 22:51:29 +0000 (UTC)
X-FDA: 83958301098.20.71B3BA4
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	by imf26.hostedemail.com (Postfix) with ESMTP id BA4CC140007
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 22:51:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cqe2wRaP;
	spf=pass (imf26.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759531887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7u2P+PSagmsp23Fv3FgF+5IpL86SkzAWEDMP2n+Zzg8=;
	b=cjiRvbUB8+ILoEdKIa8H6lKY9PXSwyeUlct0pAO3hDu6/4WUz27xR5yRdYqq/MFxPsYqnG
	rfBlCPUy+0OflyZajZ/4pgSUrfAyxCXAnK98fcScbyBO4zTqCGGNOmGvSd/LhaaNsNhQhr
	L9gjvCW5JYlElO5Budp4bEp+tFNEHXw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759531887; a=rsa-sha256;
	cv=none;
	b=wJsjtCXexSbrlETkzO3EQTY73NEpUFNdnx20b+rDtZn9fY1qgfwAjMrVJjzNJvt/uIJsNV
	TGBATkENci/h878l5kEAdK0zJqP7bDrWgdTw+JVxtybW/3BTjFzCWFocpvS9krLpcWk/Sa
	0mPGGc8254oqwJWcWhuUNdRSz3ryT+M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cqe2wRaP;
	spf=pass (imf26.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-27d67abd215so82605ad.0
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 15:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759531886; x=1760136686; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7u2P+PSagmsp23Fv3FgF+5IpL86SkzAWEDMP2n+Zzg8=;
        b=cqe2wRaPfRSiDe/3BC+UZZESeUYHTKQNkQVLATSU8T9ULc7YlN0eUT4JNOmL7+5lMi
         qyoPsAalaW3p0h0b9vW/HvnbE8On4EKdLfkWD5+TSYalYsOLeW0eqKUkwEaWpWyNSEbg
         ImMD5UfDFSWRDl9c5DM9KfQhLw2Ubecgy0MBxsbsujAoHlBnWKEuJZKJSdYQHM2bG8fF
         vaoK7SO7k5QcfsrtoeBtpx1Qumx3nshUNPKTpnKg1pTX5MLDdoXIQyWGTlL6PpxPL8NY
         wJtV/a+EN821MGi92oQAhDjSTW6jXx0emW6vZV+NT9I5KcB+eQRb2oSfSF/2a7y8DROn
         zDLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759531886; x=1760136686;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7u2P+PSagmsp23Fv3FgF+5IpL86SkzAWEDMP2n+Zzg8=;
        b=Waf6QLvJ3s2oPuOl6Omp35RLhw6QypTBfPCtBO1iUFMTAR764cq8J9u0bfM6702BXc
         PA/grYXKDZ6Sy1cQ5K5d1blbB/U8Mw7iHm8VxkUnkDgtRKrx0wmJsNAZVcaOOvgTKqRh
         k+Vv3pTpsUorvaiXFPFXgFlQJnt+vRKuviWLTAoIoSDVR9wr2EDaUdX80eyhn/2tK3C5
         m9x+a6RBed0YtasMI+zgLDJq+MneNzs1XlDxEXNaT3uc0Na6+KRCcYhU5d+JQTx/hAEp
         n0VFa7lrqHgHyqPSH1jFIiU8FdZ2IfWPkK8acmJdMp+Fhmo/1qcMpJiHgQc4wqJga2xM
         pNyQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7BX3WN4zqUVss/lJ6PM0QMTsHYjYA1RTdJky7XM0KFbVUxcGbhVtt+ZGQI8ak2zsLcuI1NH+teg==@kvack.org
X-Gm-Message-State: AOJu0YxaA56WNqjmW+Sd9aclVnwnnv2ZGxFgIEcOPpdOoCoIWOzd2Kc4
	dgeC6H9OTD/WoPErHHhP25akWgU4iA1/Ms+rYVB3nb8bS7hvbreaKnTQmPV9FjUSOw==
X-Gm-Gg: ASbGncsjCpdhnU3BhGP1iuDXjnpugCowYUVvopEw6aZ9UxcEAMbnuZPxmQnQak+c4jW
	CDoEOAFLr8nlH0Gsz1/yuW8bmtVHIdk9kZMZKBzHZtSAFPF3u3ti8at+CkMAeKUjMWWFlveaMC1
	D7A6xGGpW4CsO+ajp9r8/rDgvs+QhywMGNcB4cXZSfU4qque7L05kql6rQMYmg8aDEgTxhiwOwO
	DC+HKcYp1ESpVmWQbPZshQicSMgJWmzzt0isi6doa1RMk5MqZqY4aGekabIVHmkbNdeiPC4vPaz
	T6Tic5ItzcJ2vAhjZ5S3rPy6yfY7yEuKJgbjXhdWcutOPWlPjpK/5vNAfTpQ+PEOf+J40IJFisB
	fYoQludDXy2pSM1bSiQ9C/xTyXcXajNI/uBRKLW5zPLHk4Mr9x3/FPQGm5NM1tRH2zy2w5TjBIq
	zc6+XyVVDRCCkVJJlSmKJsx9nb
X-Google-Smtp-Source: AGHT+IHA8zSvfzM9A0JES1HZ6Wla5qDr5R3dr/EmP4gFU7QjRiucWkm3AaRWAh7ay0GuYtgIuX5jSA==
X-Received: by 2002:a17:903:22c5:b0:275:8110:7a4d with SMTP id d9443c01a7336-28ea7dcec8amr1599745ad.0.1759531885870;
        Fri, 03 Oct 2025 15:51:25 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b0204edf0sm5962934b3a.44.2025.10.03.15.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 15:51:25 -0700 (PDT)
Date: Fri, 3 Oct 2025 15:51:20 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org, steven.sistare@oracle.com
Subject: Re: [PATCH v4 26/30] selftests/liveupdate: Add multi-kexec session
 lifecycle test
Message-ID: <20251003225120.GA2035091.vipinsh@google.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-27-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929010321.3462457-27-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: BA4CC140007
X-Stat-Signature: te5cq36sxyom3kpqxqtd59wkncn87kkr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759531887-847096
X-HE-Meta: U2FsdGVkX1+57e1cAyL30fd406UBrUImgiRyjHRcplPh7ntjgVXSDvNYIiFgwUXd3q9IlapEW+YMs4BW8c6aw3LhrT35tnh9OJfnj2d67AA/HfhpgL0ElcAM10cf2VpuIrDC0/o2xuHTvWQTk2Jpagy+QaExHpfK5jN6AG9NHQeh8NkRJBeLjvSEqb4Hh2Whq9Vj4QP8Ppfdxkjo8iJXCb1kLuFZG9gfv+ebdg/D6Mu4xIVNgNK999HDeGgtRic5y2FXxzBmjjXDL0JGBnO8z3ZLRKhMwc+1v9kmi7fmTx0S4KzIkikWKdP43b+UPomdnf/DRkjnjLlfTTgL672jwnbyhKFPgrmy07Q9tLNNtGWb7balGqVKecD262nYnZF54JelVvhfydWheI7IDyhkRwchObWh8YIgIcGL36sYXJB2ycQ27aWz2R4PHdTTrxXlPlrlFlJVUvvzGlPIk8hNDXAZyYI9Pt6HhmagwATEfYBtiOjDhhhOt5j6eb1urtLk7wDFoOaNtj3vqXTFywYni7Wnz9KnqyDkQcCIujEX/VynnmH5gluWZo96JHaCVmW7lJnYgUAtzCtOBzwaLlj9Jz8Xo0sUcAOXbF7hu+FMCZLqC2Lnbl4GdyQxX/xpKwN7Kgi96mLy6CDmtQwXheVROL3B367J063m5WLwVU6whj1FOI2YiEDZ0kC2AnGZay6V8J8nhrdEV9j3K+3tgbGoVy/5b6C0F7Rlx0ii/S9k2ZASTrH1FUfmSI+JM89skOIYDcVtCrru0uwOoSztNbcl91VR6h9XLbnF9o2d/QLI/KKPfxwifU7m0zvurJ0DE4g0kTGNd6EGdQVHNxnuPJxn+0PTrm3yXGU6HN02+p6nc3yfI6mLU0xwd4MeDO0IJOaLES8RsLdYD6iAlZcCZNoUTvSrd/klXMEhpmvtVTljCixWzvPBOPF2DkNkOmM/0ZdgwIvKZL4/zD1vJvpGwoM
 m0iLImyn
 5PyNU8kb9s7b69UGLDGgAyXg0P8x8uF+iZD+1hiY7PUZT9vQF/+Zm6X8uxa4zO7MBSo5B0/8T/zqTISiTXvqOv7L1+PODIAkhOq3vkppRGCOZ3SpXXO4m/rUrW42OYVRmLKZSawSDaemYYZlGpvxT+C33RwSXYcslMkiHoly44aTecceJokUGw+LHWiPVjmBHoLUMl2LMYK8phdVUAHjrE2jyIDSjHk5yiEsv6Wzleb6Z8hmZpZeDqkGRzT9/PTXFb7oASA8UDKhOCgbhjLxtmkh+/qJsUq6T6eETK+achBKb0r0Xth000p7cBzx2bWkrAPqKZkfb7GmB9iKlkyXyXJ/N8ulfUQpdBOgQesf1wY/FwtKpvuITyaFTpbLepcxmN/+nPdvoigB6Pzm0zQICJU+GkUW8ygfrLB9otviveDVTMYUB+V2k7xtp/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-29 01:03:17, Pasha Tatashin wrote:
> diff --git a/tools/testing/selftests/liveupdate/.gitignore b/tools/testing/selftests/liveupdate/.gitignore
> index af6e773cf98f..de7ca45d3892 100644
> --- a/tools/testing/selftests/liveupdate/.gitignore
> +++ b/tools/testing/selftests/liveupdate/.gitignore
> @@ -1 +1,2 @@
>  /liveupdate
> +/luo_multi_kexec

In next patches new tests are not added to gitignore.

> diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
> index 2a573c36016e..1cbc816ed5c5 100644
> --- a/tools/testing/selftests/liveupdate/Makefile
> +++ b/tools/testing/selftests/liveupdate/Makefile
> @@ -1,7 +1,38 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +
> +KHDR_INCLUDES ?= -I../../../usr/include

If make is run from the tools/testing/selftests/liveupdate directory, this
will not work because it needs one more "..".

If this is built using selftest Makefile from root directory

  make -C tools/testing/selftests TARGETS=liveupdate

there will not be build errors because tools/testing/selftests/Makefile
defines KHDR_INCLUDES, so above definition will never happen.

>  CFLAGS += -Wall -O2 -Wno-unused-function
>  CFLAGS += $(KHDR_INCLUDES)
> +LDFLAGS += -static

Why static? Can't we let user pass extra flags if they prefer static

> +
> +# --- Test Configuration (Edit this section when adding new tests) ---
> +LUO_SHARED_SRCS := luo_test_utils.c
> +LUO_SHARED_HDRS += luo_test_utils.h
> +
> +LUO_MANUAL_TESTS += luo_multi_kexec
> +
> +TEST_FILES += do_kexec.sh
>  
>  TEST_GEN_PROGS += liveupdate
>  
> +# --- Automatic Rule Generation (Do not edit below) ---
> +
> +TEST_GEN_PROGS_EXTENDED += $(LUO_MANUAL_TESTS)
> +
> +# Define the full list of sources for each manual test.
> +$(foreach test,$(LUO_MANUAL_TESTS), \
> +	$(eval $(test)_SOURCES := $(test).c $(LUO_SHARED_SRCS)))
> +
> +# This loop automatically generates an explicit build rule for each manual test.
> +# It includes dependencies on the shared headers and makes the output
> +# executable.
> +# Note the use of '$$' to escape automatic variables for the 'eval' command.
> +$(foreach test,$(LUO_MANUAL_TESTS), \
> +	$(eval $(OUTPUT)/$(test): $($(test)_SOURCES) $(LUO_SHARED_HDRS) \
> +		$(call msg,LINK,,$$@) ; \
> +		$(Q)$(LINK.c) $$^ $(LDLIBS) -o $$@ ; \
> +		$(Q)chmod +x $$@ \
> +	) \
> +)
> +
>  include ../lib.mk

make is not building LUO_MANUAL_TESTS, it is only building liveupdate.
How to build them?

I ended up making bunch of changes in the Makefile to fix these issues.
Following is the diff (it is based on last patch of the series). It
allows in-tree build, out-of-tree build, and build other tests as well.

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 25a6dec790bb..fbcacbd1b798 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -1,10 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-KHDR_INCLUDES ?= -I../../../usr/include
-CFLAGS += -Wall -O2 -Wno-unused-function
-CFLAGS += $(KHDR_INCLUDES)
-LDFLAGS += -static
-
 # --- Test Configuration (Edit this section when adding new tests) ---
 LUO_SHARED_SRCS := luo_test_utils.c
 LUO_SHARED_HDRS += luo_test_utils.h
@@ -25,6 +20,12 @@ TEST_GEN_PROGS := $(LUO_MAIN_TESTS)
 
 liveupdate_SOURCES := liveupdate.c $(LUO_SHARED_SRCS)
 
+include ../lib.mk
+
+CFLAGS += -Wall -O2 -Wno-unused-function
+CFLAGS += $(KHDR_INCLUDES)
+LDFLAGS += -static
+
 $(OUTPUT)/liveupdate: $(liveupdate_SOURCES) $(LUO_SHARED_HDRS)
        $(call msg,LINK,,$@)
        $(Q)$(LINK.c) $^ $(LDLIBS) -o $@
@@ -33,16 +34,16 @@ $(OUTPUT)/liveupdate: $(liveupdate_SOURCES) $(LUO_SHARED_HDRS)
 $(foreach test,$(LUO_MANUAL_TESTS), \
        $(eval $(test)_SOURCES := $(test).c $(LUO_SHARED_SRCS)))
 
+define BUILD_RULE_TEMPLATE
+$(OUTPUT)/$(1): $($(1)_SOURCES) $(LUO_SHARED_HDRS)
+       $(call msg,LINK,,$$@)
+       $(Q)$(LINK.c) $$^ $(LDLIBS) -o $$@
+       $(Q)chmod +x $$@
+endef
 # This loop automatically generates an explicit build rule for each manual test.
 # It includes dependencies on the shared headers and makes the output
 # executable.
 # Note the use of '$$' to escape automatic variables for the 'eval' command.
 $(foreach test,$(LUO_MANUAL_TESTS), \
-       $(eval $(OUTPUT)/$(test): $($(test)_SOURCES) $(LUO_SHARED_HDRS) \
-               $(call msg,LINK,,$$@) ; \
-               $(Q)$(LINK.c) $$^ $(LDLIBS) -o $$@ ; \
-               $(Q)chmod +x $$@ \
-       ) \
+       $(eval $(call BUILD_RULE_TEMPLATE,$(test))) \
 )
-
-include ../lib.mk

