Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A539CE8D76
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F0E8E000E; Fri, 14 Nov 2025 14:00:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C208E0006; Fri, 14 Nov 2025 14:00:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01398E000E; Fri, 14 Nov 2025 14:00:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6188E0006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:00:12 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 698A24D254
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:12 +0000 (UTC)
X-FDA: 84110127864.03.65AA968
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7E022C001F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yf+xO++M;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763146810; a=rsa-sha256;
	cv=none;
	b=mAPUR+cM7MgRFUkL69RqT8KuFkT0Is/i2cuGwohmLP2v0duAL0PUyj7m6DDRkv3nUpvU2K
	281jXldpbdKKDJcR9TC257Xyht2Yhipq7WSHNYEYTBTDuyXdYiHTX497RXuH6qvHC2mC1Q
	1vQb5mQOMccgYevsAv0X55wVBTxyL4k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yf+xO++M;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763146810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YXc2jA2YT77trJs8AGCJnVExYUqZkyW6ilvAJCLy6vQ=;
	b=nkxy9w0QDoAZQo3cPp6KiOwLrIlBoyngDUJvnqh/Dl8zGcGZq/maVkzptq7AzfJFwPW9vL
	0PnJJmFqtjB4Wfs00HhJc8U7/UxVfzjObgU4TA96Hn1g+k9/A65bN7QJH1k+AFP7XT9d9P
	5vZNX1h1u6UHpkkjSpH03LDZNY1EBTM=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-640d790d444so2124217d50.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763146809; x=1763751609; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YXc2jA2YT77trJs8AGCJnVExYUqZkyW6ilvAJCLy6vQ=;
        b=Yf+xO++MF+pEP4l9Jpjt5RdeiA6rTXfARwFdcD82xim+jChjSZe7Jxt7Rh++t1L5FC
         exqAOFNureKaek/vsT9rQmZpHXAZhHmvbq1ULVz4xTeGvtLAx33igO3ZEiwB5OZHIanO
         wIg9XHQyVNtOVQFatdAAWyKwQi4zRlboHYDYdh+MKwmDz2fdMw1rREDI7HuAvXzDbuFf
         9PVaPbtXRe/r0QeUPcBgLF2SftWQm1svY1VT/Wvr9inm2cp0BFrc1fWwLKMyFQn00CQ7
         jsy7PHkjIwA8Y9Qig35Ns2sGoFmVLpaVkgCZREWBIWNuILUocZ+5fvy0anyYfS2CSDs/
         syow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763146809; x=1763751609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YXc2jA2YT77trJs8AGCJnVExYUqZkyW6ilvAJCLy6vQ=;
        b=CaEQV5NdG0zOP0wxxwjZ0v2556crcikUM5iFR2Muq57NmHkl6KibB0zvWXuq0as636
         tU+OrlLahfbJnBFDPgmn1m+wHFzO3uZkq70h/fJD+c7chIBGU2YFRtYTlLYkYyDVrWEz
         fgCre/q9a1UVlZ/uAFdO6AFqPd29cJahOW2hWl01BtZvZW9HUUo+8oq1qNKKOCEAr8ra
         gQzdqkrJfp/kUwxJNGMm1TGxpluwmm7MgAak4wOxi84V9K4raqIb+K7wssDOZuL990FB
         me+AFxsaxUCF4+DpSL5SxtxDDNtD04xFtOAFhey0f9jLI6oKvBPYIQq5lSMFPzmuGbE7
         dqTA==
X-Forwarded-Encrypted: i=1; AJvYcCVgh71CcOOAyFVdaVOO27xQAjSHNaCBoMwiCL1nQ9vICYDkfdTy/FxfYDpRfGJde2/pKZgHY1esvQ==@kvack.org
X-Gm-Message-State: AOJu0YxYudloYcTXDM3WGBSunuFojE+76W/41x6q3Zq61p424uOlZazg
	4DgjfRwwdSWsTiGafbFB1w+vkL/1qRhP/TGiG/U+DLumbBQT9tFwrhXaDsxUESthhVU=
X-Gm-Gg: ASbGncuuOoSq314et3OGjoUUOqK/YZqzv5QlNGX9sy6Q3UlOsUHjLFzWiF4f8LV8UXb
	wsYhgeWSiN6eFByH+iNh7akgn/skm7habwt1OQRl3I9xGL4uBPMrNMO61FZ7EOqN/N/fPKriMlb
	zRR+YHiyPEKLgITH6qWzijQCiOEBJRsZRmqDfnvWCqszNAhl0DnqlsS+FrUARWAm1PlidslqJeV
	ENDoApqiQuYempXdqUZ5dkT4JCGgmIJx2onYFluPiamL3Bp/iaMgYl8xR0CANFRlEalf8ZGjzha
	A5UXfXkZL1eWvbeiXR5eqvKDP0k7bNcdyFekxOgxJoH2an27j1EHHmNcilroPW6AFQxiGr/AyOb
	hD9N0md0orDu3WwLjTQAESFmoyxaggxt4qEUgVbhU7V1DqlD8IzcLvljg3hb3uU9PENPhEuXNfH
	ud7nmcWzwagmIQ4/VjhCt0L8ukvlCOQxLCHW2j3tLcDB4R5eSCrzeFwagIuxsgHgfsdQYftvJEj
	lTdzqc=
X-Google-Smtp-Source: AGHT+IGOGhN9och8baUfhKaHjASGw/VORaspSG14Cq33C7ESIM+RUb/oPIKDQj3zWRv1mHSuuySjxg==
X-Received: by 2002:a05:690e:249c:b0:63f:bab4:fdcd with SMTP id 956f58d0204a3-641e76cac43mr2599528d50.48.1763146809421;
        Fri, 14 Nov 2025 11:00:09 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6410e8f4f2esm2014058d50.0.2025.11.14.11.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:00:08 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 02/13] kho: Convert __kho_abort() to return void
Date: Fri, 14 Nov 2025 13:59:51 -0500
Message-ID: <20251114190002.3311679-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7E022C001F
X-Stat-Signature: w59uhu7s1x7rq1xztez4hezok7w5ica8
X-HE-Tag: 1763146810-849431
X-HE-Meta: U2FsdGVkX19GDkb5WzEIFTHWtaG8tqKyecbxuarktG0XDQ5Vjpe25ifMQ1Lc6yIlgVtEYHwtuDpAZmI2xfLDS4QrkBz/X8ONX+P9SNGlzZsUlnIpVAEJBmY87GwI4uOWTmr3xd9kAFLEqUwHhF16oM18c1q5nidsvHhenFBxkDSyajFKrleKTiugdvDIdBpb0ZnMIwZ/ofH/nH5S9JKeff3ljfl5ZZsjY9PbxgIj7LqzwzIw5cRrVnwUnjETr1lxv72+ty0Vt/XLoLBZEpdLNOd6d8E6131LjZYCpPZwAcKPbOaaCeW3fZDh04Ef3B6iNxtsViqWDu2tXVQwrbG7yoORPK+3Mqg4FecAcuz9Y7gXV8ynMWM3P1tcHBrU8Hj67c3vtUGHv/WcdITE+IuyITkt0lif8Z/qqngBcZ6Uwm/ABw+aNDfVmViYGNXECQ2cqgGogZIcif/cHXN8FOYsS2SMII0mo1XvehMdvofl9Y1Pbq9N4b/PbxDQXm7/jPF6d4mCpGnuJps65ioFqlhRX09WcA+clYPA15r02bPjJXGR+njvq6mfPIRm6A/saMEGcIIuYD5C1HDhObqLMR5c4Xqv9NDGjyRsGZ2TjLGupcHcuBwAZFv5MnFOewg5XgO2XIBvM/TghwYc2IWO+Yd2TOvtKUarCQmw9OGUPGz/9+r43YH8MDs5bsqyZk12+NXmwtIBRVjq441AR0VNckyNQJXfyEppd5hSXOrITjV98zSl2LWjlHmzzNrxPKQN8GK4yzxKGDa5UWNOsP2D8z5rkBxz24II4mc59FrIKQB07evO1o9TP7p+PSbdCj57DHWIpTadEJXBaIyTZHJQEjM1R/D1MHHVfXaw96PnhRWpYGugF0TqphFrsru7h5AmG50QJsYkHpD4i8VngHBgVwVdgBncqtNvtgZJpvTSwpnV7CHfOoxMCwnHsT23+nvWCVxoyDVg1fXzIffNe70erjq
 Ma6kQGW3
 Q9JxZdKYIedBqoDfsrS21j1/ROaoIdt2M3NeAeuc1qojEf5bT9cRmUHd/11HxVregjG9Z+hoMio3Jl9ZG3qWOtWwwFdHH31/sVskUIoJ0n46irJPBrt2OrwewhjQkV1zgqIycAeeRtMgDXdVGyvkHFhtNUfGax3devONe+EiuchIZQ/uJ6mXAFVMaXYjrVcux+BmstWcR/5iGHNQhlKJqA77sKK8XLraekcwgVKNtIukX18C2AyV1Cw8CV6iRXb8dg5Pk2U9Xt4ZNh7bdBnQ9mP3fZUwEZ5BbmE1RFMKrD+N/YHiEtudEjUV7cr1xzydgrfyDYVyTXuf5eSw8bmkvdkRECEw5ubxe3ekl1pDuA5za5Xwg6d4Bf8baHKpSOVASdJgGkq1AORWbxgo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The internal helper __kho_abort() always returns 0 and has no failure
paths. Its return value is ignored by __kho_finalize and checked
needlessly by kho_abort.

Change the return type to void to reflect that this function cannot
fail, and simplify kho_abort by removing dead error handling code.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6ad45e12f53b..bc7f046a1313 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1117,20 +1117,16 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 }
 EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
-static int __kho_abort(void)
+static void __kho_abort(void)
 {
 	if (kho_out.preserved_mem_map) {
 		kho_mem_ser_free(kho_out.preserved_mem_map);
 		kho_out.preserved_mem_map = NULL;
 	}
-
-	return 0;
 }
 
 int kho_abort(void)
 {
-	int ret = 0;
-
 	if (!kho_enable)
 		return -EOPNOTSUPP;
 
@@ -1138,10 +1134,7 @@ int kho_abort(void)
 	if (!kho_out.finalized)
 		return -ENOENT;
 
-	ret = __kho_abort();
-	if (ret)
-		return ret;
-
+	__kho_abort();
 	kho_out.finalized = false;
 
 	kho_debugfs_fdt_remove(&kho_out.dbg, kho_out.fdt);
-- 
2.52.0.rc1.455.g30608eb744-goog


