Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8EFFCA0FF9
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 00:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88E68E0002; Fri, 29 Aug 2025 20:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3A098E0001; Fri, 29 Aug 2025 20:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4FBE8E0002; Fri, 29 Aug 2025 20:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 959E98E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 20:56:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24BDBBC3F2
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 00:56:00 +0000 (UTC)
X-FDA: 83831606880.23.242ACC3
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1E465120002
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 00:55:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KU3k7m/z";
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756515358;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4fmjVDdFrMx9ZSS1uNIb9RY2hqkvjiZO5mAN50cFP8A=;
	b=4BYdpdqav66RxSRrsd25OKnwZQ0BAx8tMpEve+udQf+ld0zoRZoRsJQ9MIKRccbenDp9pp
	2C3b1qsZukw867Ujjo4YgOST4GWyOBjkEUsc4v9psdw5vmQhSZZKQVIUA5vCAcuPJA4XPo
	Pb79BYBWK4OCFPoI4FS7IsxejyUSZVc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KU3k7m/z";
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756515358; a=rsa-sha256;
	cv=none;
	b=jUBPsZSEd9yPUDJ5Zpy10W1IbFrUJ5K0bBJW9EG8Mi49D6xMxJKrvQNsJETHk3946+Ng2O
	RBJkUZgV3BG616npYTiQhrXmtIwIIFsFmMwv8oxe2vbQYEReoB6T6x5Z7Ewg6fDBzMvQjR
	EmGHSYh/6/p+Z00hKCFpra4i+J//7c8=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6188b5ad681so3242583a12.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 17:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756515356; x=1757120156; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4fmjVDdFrMx9ZSS1uNIb9RY2hqkvjiZO5mAN50cFP8A=;
        b=KU3k7m/zzBwXxTIkyVQcVVX5qd6ihIR8hJkTRR9c+TSBNx7a3Z67sIBeyjoNS3vDv6
         8q3sHl/3pLaroQEQF/VLk6+4QOZXmZwZIL1u+nS/AO9Ar1KASfal015ypKrBodkm9jez
         oZ4wr1Bt1vi/H25msXUA1Xj1mhQe5b5kc/MFn/O//1172RbDsqXrbGc8YwiNKBGJJc1H
         c/GTlVgEh5v9tXRE92S9lLZzSd9MvJwabesBYyrgubzVimRmW5yVR3emdMF0TRCxi8wu
         H3sHkZ8G4MNAYuxppHWg8vOFyrARXuvaKvtWpV/kGtkjnXc3LZ2/ZBUAObcaLuUu8G5G
         apVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756515356; x=1757120156;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4fmjVDdFrMx9ZSS1uNIb9RY2hqkvjiZO5mAN50cFP8A=;
        b=L0ANx5ZOYms3EKk2k7wINnkPiv9hGMjdfp1sA31sWntHlplr4CO7Z/6FEWrXeE11ga
         u/bKBUusDvpVOohdlbXBRT/c4tO7eoGqx9yyvj1qjdplVRnOZOtbIrpipWwHq9btDumQ
         rzx07+5TT13ipAbnrFTuGH/sQpoMPTpSiNqllfzZndN2Ob9Ml0qk9IdbeLAWrnqNF12e
         atDo94Z8fEpQ2WVw+SDT3jXmgo8qngNJAdzRE/DGprWns1dPMfJBYXhnRs3mZp4BwNk9
         j6d8MOlaZNMggC03QYZzs59TIYKpcPHiHipRh8gDjLMuzAjzL3PEh7Eo2/YgjXLmxJ1N
         F1zQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXUp2u5XXEp/ngbmNK8TW5oKDdTch9fSAe+5F9ZPGuRYZBpkoI34o5g0J8KsNgvOVwAAmbq5nTYg==@kvack.org
X-Gm-Message-State: AOJu0Yz+XMeYfxPTepCjq2kBRdatw6rt+pzm6qSb9LN4ulvqj5xIIIPl
	1ZORh4KJWTJmpiRl1hRDNIphudl4eM1r0dDsDGLSFv27jh2NKkX4jxm6
X-Gm-Gg: ASbGncsSlmyB86qvpZ8thauMBJzqNlrJXTTOhSaXL5zwntX00QD4zQV5P214PVYl3YK
	9ffLZdYsz57gABhp9eI12hsqBAUIkSuWDmkOMtNb1yy+97g7y0UMJyIUmoft85i42A0UvXmN+vb
	kP9wmBJ3j6K8za6rcCR/lmjaOtivUL/E379SjLlvd4QR0Xgs5jVYcboiIGEjIf8aLRBwHVtLg9Q
	p/4dTThg2cCbLjD67MkbQsCrzSUGUneGujd0B86ZP82KJxuZdeRRG2iavoaxT0mZO3nJaL4FxV9
	c8v0E1H5WHwQg5REuvym1O03ABrB7uEKsywqzpfFFBEm7FxG4bnt3y3VK7ttY6ynd3oHEPbqWAr
	+p9c95+uflQdtIPVaRfP4AUMqOA8es77iKSVt
X-Google-Smtp-Source: AGHT+IE/li/Ts2UpBwuWVuVSIjcO4SAipUbYlLSRWpymiN4ghQfYMrr6M82K/BEJSs15LPmF9GkV2g==
X-Received: by 2002:a05:6402:5cb:b0:618:bc4:5777 with SMTP id 4fb4d7f45d1cf-61d2688bff2mr442032a12.9.1756515356279;
        Fri, 29 Aug 2025 17:55:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc214e2csm2654649a12.15.2025.08.29.17.55.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Aug 2025 17:55:55 -0700 (PDT)
Date: Sat, 30 Aug 2025 00:55:55 +0000
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
Message-ID: <20250830005555.ebx6sq2j22mm3plp@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250829014358.qk3zme4qlaojun53@master>
 <20250829105306.6638-1-reddybalavignesh9979@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829105306.6638-1-reddybalavignesh9979@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: ndwxfnqkuiw9di1htuxt4o18ddsp9di6
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E465120002
X-Rspamd-Server: rspam05
X-HE-Tag: 1756515357-154642
X-HE-Meta: U2FsdGVkX19baCXnej8mmeQTFwbrCupsRJ+DiVN+BrfI/mBXNpljyC02onvkvi5TMFXMJ0O1wm0Dyv8i6fTFI1w5YJKTzjcIyWTpyfDbFKwGBtwEORrls+SUol4POa2yK+U7Cz3ubsfeABiOt2jMd0LMIKu/Z2CgqScLsuRU+yn2hKn8YI/GN+6A7PuQnTglAHPtvWtYxax3251g3cvC1/2Pa752IHXgZpsxazbWbWVBilhJJgjU4UNyytAMJKp3E0gsxpb4tMyRUasiS/E9F3DEmto+jWvRSRXesq2P+X95s76q1adGS2HkBka7Ml5pbbERn/qOA/CC+UZ2JbrC0IBKbn5zCfFQHa9hEgxel06YdA3BrZGda7vkAZOgHSwxxuojvyKZVUA5646BKv0ESEhlS4n7/lJQT6RCmd9I3T7+oXSx/wrYpIk845LIjDM9qf47ZX8v2cLVhUq7PiPO0HHxVe6zaW7qr9ZnZhJacL6xukdmiFi22HRd4sRWJ+XWMln3qbJHw8Pj0ur9Zr84wi5EUWYyACxbJiwxi6eeP2JvI6W/l66ZdBY/fO7zHFDs0euWFHMJE6gY77SeXPNAYuxVLqnVef8e5YL5Hg8tebM+MP7UUpl5Po1C0CD45MZ3pjoAiG25S9Fi7x6Y0c5cIQ8wxj1kfN6lB6HJnxHjZO3FoxGDbqXc4S16e9AOLdg71h7N91ajtENXrD/RZcKVkcDfhq1FMDPNKBfFt5hM/KJDtnmud2BNZCVNPNIsbFK+7124BrMNjJytyLltD/v0bvXVOZ60IFcE/fQjfpIdGGxCbJLg1dH8Z09Jpv8n0rR6XZ4wpj1jUBWW4ENqLF0gs2wLuFZwOa7KVI/fMTJt0CTKfMScwxMB5IBX7pQUbN5MriJWUnXHGWjI+gpsMW/zPy2r6ggbV/Hf+RMJg0Ha9nkTS9+65ekLKpQgAoquHBaUlv2fycUs34nYNd5vj/T
 GVymHMMy
 NPlVkr6QhKWCWyKADOuK59T4TPuplJrjafTN/+C0SObIu+MUpTtOmVkdatEDS9uboHeAMwMg/mjftH+SKnR0nEGuhGmhL34j4oPQ6q7vx52ksm9p79sfwXtyZCx0Uu0ZiE3prtg/K5/Xr0KVL0vwLAJ+9RgcWfB+95WWJLq1Hj6wcwMfxHJABKYNOCFdQZS9LaeFoF/nP9+UcsTG2mZdPZibOFW4RVZBGo5+9TA2LEL0h+/JBuJ+Zqlya2fDFGUKCQWSiN2ZGFIy83LtexyEFf/JZj2d9LzyOQuTvNqBxgjDEh8LPIov9srZ6UuuT2vZRtFxYN7DrxVBYaPdTAuUPCiF3cvgJkEP4LzgEr8ApWp848YAeV1ztgPHgUqDZCJlouWcSR3Uts+4qp5czKg+GmM0pr3jxc3wgOQ649/iXrZA6/0ga1sprJsf3bsYi6uueXo+MkXigP24ZGxQ1zGcrpPpEIz1B1LW6b52aaP8Jq06S2RN4RGIWzBI40q1Qqg6dfavEjrue/DJBXEMuIyqokdzgr4J6VoUqamCcJgvUDesEmhvU7F6s9qFPGFW77V8HBWj6FNVqUyeXuNX0uTVG3Scr+si1FaIcIp7G8DtzqwgF8Tjx9V00y6cTfRodYK8HEulnoQ2YyU9jef0vscBDk2+9lat4w/BPVPwgPIIq40XAxonpp29gzsPbGC2qIQo2bpjtC7OmpxXVGZUBV32dWB3oShOO19P+hLbP9f3IiCTiIiXFfacv0/fwFHLhBFBvbG0+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 04:23:06PM +0530, Bala-Vignesh-Reddy wrote:
>
>>+ifeq ($(KSFT_INCLUDES),)
>>+KSFT_INCLUDES := -I../
>>+endif
>>+
>
>This makes sense, but if we do it for mm/ then we have to
>follow this for all subdirectories in selftests.. that might
>cause problems if subdirectories are nested ones likes filesystems/.
>Duplicating this across all subdir Makefile adds churn and can
>lead to errors.
>
>Another way, is adding `CFLAGS += -I../` as is done in net/Makefile,
>but this also doesn't solve the problem completely as this also
>remain to relative addressing.
>
>But, if preferred we can add this snippet in Makefile to
>resolve the error temporarily.

Well, maybe I find a way.

Since we already get the top_srcdir in lib.mk, sounds we can add the include
path directly in lib.mk.

Some quick build looks good, not fully tested.

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 530390033929..1d3d0ad037d7 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -199,11 +199,18 @@ clean: $(if $(TEST_GEN_MODS_DIR),clean_mods_dir)
 # Build with _GNU_SOURCE by default
 CFLAGS += -D_GNU_SOURCE=
 
+CFLAGS += -I${top_srcdir}/tools/testing/selftests
+
 # Enables to extend CFLAGS and LDFLAGS from command line, e.g.
 # make USERCFLAGS=-Werror USERLDFLAGS=-static
 CFLAGS += $(USERCFLAGS)
 LDFLAGS += $(USERLDFLAGS)

>
>Thanks,
>Bala Vignesh

-- 
Wei Yang
Help you, Help me

