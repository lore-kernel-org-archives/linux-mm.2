Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEF99D1489F
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 05:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256186B0093; Thu,  8 Jan 2026 00:07:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF026B0095; Thu,  8 Jan 2026 00:07:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02FF06B0096; Thu,  8 Jan 2026 00:07:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D793D6B0093
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:07:55 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90C38595B2
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:07:55 +0000 (UTC)
X-FDA: 84307614510.03.F39721F
Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id C580B4000B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:07:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EUPcex7W;
	spf=pass (imf07.hostedemail.com: domain of 3qDtfaQYKCO0PkPVXcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--avagin.bounces.google.com designates 209.85.167.202 as permitted sender) smtp.mailfrom=3qDtfaQYKCO0PkPVXcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767848873; a=rsa-sha256;
	cv=none;
	b=rXpfwbIkBjJvtWsDKMLEQe4NthSnQWCeeDrUzDuWOS+f55JhYAyd0qDcpJ+DQn+yBkCVDu
	Rg6L1TmfSSQtv3HcpOhVpERC8t5fEyg47QbTDTCr5y3T83P/a55U21qBpC1AbxqJPLbY7f
	O8t53ynxAhdZo9bmC5KkickMQ4q9X3k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EUPcex7W;
	spf=pass (imf07.hostedemail.com: domain of 3qDtfaQYKCO0PkPVXcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--avagin.bounces.google.com designates 209.85.167.202 as permitted sender) smtp.mailfrom=3qDtfaQYKCO0PkPVXcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767848873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZQOsX2pgJ2tnboOIsX6ynvBnKeb3FSCcqmuKWQBi3o=;
	b=mQHSPB+rg2l1H82TDJBboAA7tIeSxWCPrFntr0OGgFda6N3zRENWVCSzbmbreTPeN+Fmu3
	o1LHKyOd5xVaC7zUu6mL2ZR95BhCtxF2rYEXZzBuJiDf9+F06zw6eXTv7b2vTeVBzhNMgK
	WyTlePJ9KEn8ON7U9uDZGHDtBBQXcAA=
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-459f458b781so5294237b6e.3
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 21:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767848873; x=1768453673; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dZQOsX2pgJ2tnboOIsX6ynvBnKeb3FSCcqmuKWQBi3o=;
        b=EUPcex7Wxcto3PPOQxbfsG8QIhRMIETqr6s0yE4tOCbtSi0RxbkA3EbDEZgH8lg37m
         ixXzEvptVdxo+t7I5XKTNOkGyQrO55dZB4Hr0CaZo4h+6CM0cP68vQtX6dMKkQeh4aTU
         XnmYjzLqv074Rj567kbEz/igFsuwsIQKhyGzaC7GxI1fV1hgnBSfOHvHLQp1zuuhz3aC
         lDxXKhAl7dYCQBrOIzRVLCQOnlOhsmX9ddznXEvaAFNRWjEs4QHmRWtb3qp6u/Fzv9vy
         UWnfLOfrYQQw2kjNahRUIGItib6JdZBUpXh3QZ2Ytc1CT9vwmn76ldlvtp8eTVpRyZBm
         nTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767848873; x=1768453673;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dZQOsX2pgJ2tnboOIsX6ynvBnKeb3FSCcqmuKWQBi3o=;
        b=QBYwXTelpfzUoCAClSb1AHNLIuKpIgIWp/tv2dxCJoczQ7Z02+tj4f4oW2bbf1t3SX
         +fIIRJm81Pctj+WkPv2p15KvQhf3gDP4MEeJpcu4HYEbnGQMaV9V0JE6r+EYqZd/sNiu
         rXT6nq2rc8TZaMbhIwZxu26sOOrLCzXtrI1sbI2ihyegm5JjKESJDPG2NwAtm+HMZQHL
         l3EmiQfy9rxeyNBtr0pazkcM92HXB7vsamHZPWg6PZ5daMekvCNZHAuB7pUcl7TusRAf
         SX/B5TPX0puOoOU/tvQFiYtkKyoiVRb+beEnO7f9oxs3vJWyuaCjoGUVI/Sbr//CEeDG
         XW+w==
X-Forwarded-Encrypted: i=1; AJvYcCUNkVWOsVkrjtD5bDdnQxX0uBs1P++zoSkS/vu0yJLzQBxEFdcfNz7wCANjqD7Iz/djxNcFLKMcTw==@kvack.org
X-Gm-Message-State: AOJu0Yy9RYCeLcIdZxv/4Hozz/gKAIA2yi+W2YQIwqqL+byKoS2I7HTk
	zaEFyJrHqP7NX/ut33QYdFC6+DcmyrkrejK+AxpUbbIDK3lpUZ9+JVuFtPy8W9e1lmi+MllkTRe
	2Pis0mw==
X-Google-Smtp-Source: AGHT+IFrclr5UQo7zl+uW+fx86un/1H6WIw+B6ZZGi+Mh3xwDR/cU/G0W87Tu8yHbTlESc7N66Kjw62yaIA=
X-Received: from ilbdr9.prod.google.com ([2002:a05:6e02:3f09:b0:439:46f3:4729])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a4a:d666:0:b0:65c:f12c:e74e
 with SMTP id 006d021491bc7-65f54ec7815mr1678998eaf.6.1767848872864; Wed, 07
 Jan 2026 21:07:52 -0800 (PST)
Date: Thu,  8 Jan 2026 05:07:46 +0000
In-Reply-To: <20260108050748.520792-1-avagin@google.com>
Mime-Version: 1.0
References: <20260108050748.520792-1-avagin@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260108050748.520792-2-avagin@google.com>
Subject: [PATCH 1/3] binfmt_elf_fdpic: fix AUXV size calculation for
 ELF_HWCAP3 and ELF_HWCAP4
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, criu@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Koutny <mkoutny@suse.com>, Andrei Vagin <avagin@google.com>, Mark Brown <broonie@kernel.org>, 
	Max Filippov <jcmvbkbc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C580B4000B
X-Rspam-User: 
X-Stat-Signature: heikpa1xtt8owa1happrigsg5sap79w8
X-Rspamd-Server: rspam07
X-HE-Tag: 1767848873-677807
X-HE-Meta: U2FsdGVkX18MscF/XSVztT8tzeveCfHzo3MSEY9k9BHgT+aXFibD9JukATZCyWP4tn5+UZ3sVTC1U3L5xMUWPEcn+ve6gJf+2cPHAMr4h2nHuEIfSyojd7nDj1541u6LIhbgNhSGi49iwfVx53KXtoHOx4XwZ6HhXoz0bSkG+KI4qaK9i8gfJD2JWqBZ8r0zQRnYPW5X+BeD20GN39lqy9UsV9VA0q6NkBPlNfAcOB/zoyJ0oPRgT5tcCdllvChV+gbedfKi1uIAyjwRBkn0Ig2oL5O+HHPNlcEZDsiOlGjzZKP6F99cHmnzyX5aLnYtfnEsfAOp88aqnaErwVdA9Tz5Hqerwrmfu90ZckQL37F2r6YIUgnG6IgXJc3C9KApim9m5wK7y7Dc6DK9nY2ZX7cpx86OEmiZR3IIgUFODVWBwG0Cv7Iu51S+dLGfv+X9rqBX9SzuxIKG4z/Nj1THKtViHGkYNvcjnKmDikOFC9Cu58GoTqxQkkogiFN66FsVkPHEsKl2LXhCJZMvWAiEe1+oDQVqVbbj8HLmHRU/H4DnTgmVXq0slyAW9U0UTAy+hy3csVvKVSDxPSCuOTbM/TAlgybZm6h5ElIgzkDLq2pG7YMEwHmLZnQc5bhJAkgvFseoXCt0jChwKV+IWiEHNMW0nzldaH/Qya8/DJc3D+j5fok7ymWF3qYGEeC310kljSBPYzc+07f0Mo03bBDJzpXzS7b3Xr5Ol/oQGfzGm8MmB7hAv3D2gG0Kf4Pr+uIvIESuuduMiFuIjeZsZg9MO2cModbCRjxDLmjTzSV43If3lVVqaiNcw8pq5M4Rt6Xqs4rvQRHSE0GZ53HY4Y0pGFsEVfRCAsbWTFA7NiO9Ka/Xmr05FoAeZRG6RVPqpszJaU5gN0vqbqYSGFUypWLEqWne6i/7ijo89AFxH4g4BmnYx1qMSgm1vPg3bhX6N6sSn3rQOwfp1hdE8Et1pEm
 2OCTAr9u
 YkzTNjsohbs2exf3Dn8p6GO0UbBqe3cTCP7A3OXVwShJQuWqqzi/FIjFeCfjzKD4EWNNNIr+L69HgbeX+JaZnGzq6Q3oORKdsofyRi9WCy9aJ32N8g6yY6gQ1rEQWphX0TFxRIFLo5mqACUgTBIqiRTmJSkxPNCzxjVOkhRf3KOpVOwXfUfRkGOGFzDN82oj4mElitovAdrTGcellYIK9x46jfNpOH51nef9I3/mN0u8g9vaP2hoKeugSZcWuEqivSgMooiyl3D8Pyo4mxcAMfQN8RYYI/YxVzVUsGFcKIcqImxyoMxudUeqtRGFYyE5xg9nJl90fKhNleH/LORqxls+2Rj7JcQDB4t0aj5EyVTw56xszJhCrc/agc8izbyABBNuYLrNCt/dgtWcep8YJ8mUHcZC+PiAph1jjyjhpLNAFpma4B2hvVKCtSY1rqbn7rC9i9IalDLPF74iKkLIWk9/0AbQcH1KsPPi2DM0pIpNSe2DdhkY2EULilhwRG0uS4qCGGSeOwMKa02i2NMV5/A87s1OymcJmNZYk9pJThZZ+Ce4saJCmUaytKqnkPH6e3yCbaYosliatMTP0jaaAmgSiB8viR5hCXPdJBLlgBP5iEt/044C9fusZRsBeVjUVmXLZZ9QBGdzlYbCYKtJko+14MLT/ydLUnqd6JwUTMpYw9hsxD8hYekUaOdCNZ1PcQAjYhoLX6GP3pPZjedfUmTmDKO7JZmg46whT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 4e6e8c2b757f ("binfmt_elf: Wire up AT_HWCAP3 at AT_HWCAP4") added
support for AT_HWCAP3 and AT_HWCAP4, but it missed updating the AUX
vector size calculation in create_elf_fdpic_tables() and
AT_VECTOR_SIZE_BASE in include/linux/auxvec.h.

Similar to the fix for ELF_HWCAP2 in commit c6a09e342f8e
("binfmt_elf_fdpic: fix AUXV size calculation when ELF_HWCAP2 is defined"),
this omission leads to a mismatch between the reserved space and the
actual number of AUX entries, eventually triggering a kernel BUG_ON(csp != sp).

Fix this by incrementing nitems when ELF_HWCAP3 or ELF_HWCAP4 are defined
and updating AT_VECTOR_SIZE_BASE.

Cc: Mark Brown <broonie@kernel.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Fixes: 4e6e8c2b757f ("binfmt_elf: Wire up AT_HWCAP3 at AT_HWCAP4")
Signed-off-by: Andrei Vagin <avagin@google.com>
---
 fs/binfmt_elf_fdpic.c  | 6 ++++++
 include/linux/auxvec.h | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 48fd2de3bca0..a3d4e6973b29 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -595,6 +595,12 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 #ifdef ELF_HWCAP2
 	nitems++;
 #endif
+#ifdef ELF_HWCAP3
+	nitems++;
+#endif
+#ifdef ELF_HWCAP4
+	nitems++;
+#endif
 
 	csp = sp;
 	sp -= nitems * 2 * sizeof(unsigned long);
diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
index 407f7005e6d6..8bcb9b726262 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -4,6 +4,6 @@
 
 #include <uapi/linux/auxvec.h>
 
-#define AT_VECTOR_SIZE_BASE 22 /* NEW_AUX_ENT entries in auxiliary table */
+#define AT_VECTOR_SIZE_BASE 24 /* NEW_AUX_ENT entries in auxiliary table */
   /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
 #endif /* _LINUX_AUXVEC_H */
-- 
2.52.0.351.gbe84eed79e-goog


