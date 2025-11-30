Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D13ED116E2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 01:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D9BB6B0010; Sat, 29 Nov 2025 20:09:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98AAD6B0012; Sat, 29 Nov 2025 20:09:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82E2C6B0022; Sat, 29 Nov 2025 20:09:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 693DD6B0010
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 20:09:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D4F413B2A0
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 01:09:26 +0000 (UTC)
X-FDA: 84165490332.17.5FA0B64
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6586780004
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 01:09:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YyabsjbR;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764464964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BvMYQXO8j67HXrkaRo9OFr9r+KnzegXxYt4q7UonkDw=;
	b=aosVhoRWXuMzkuaoPiyUACwe+NGQdEbxC7oO+brEZSsOpTjMTmLzomuaSPNdCQKPRtRMUe
	h0JYjWKdT4/UdWLXKpF1fh3L5VovZ3Npmc3VuJjSnofIc6h1fBoXUtUgvm7YpQWO47KOdH
	Y+71ITRAwldO2qufRHTGi2zStY77dvE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YyabsjbR;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764464964; a=rsa-sha256;
	cv=none;
	b=vT/QpZnS0ZNt2tECuWwfQl2QpgB7672zU9p3wVQi5fZ6DzWubFPh7rOWSFjtLaNHfC9f0C
	uLTX+Tg+3uckhWhbRAstT8+TizfxX7T5j9njjpDBQi21a61yo5zqwEHpud3VRp88EMqz+1
	4/10qcrX2seLmYeSWmf7h8pvEdeZHq4=
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-63fc72db706so2334687d50.2
        for <linux-mm@kvack.org>; Sat, 29 Nov 2025 17:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764464963; x=1765069763; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=BvMYQXO8j67HXrkaRo9OFr9r+KnzegXxYt4q7UonkDw=;
        b=YyabsjbR0fTG/fgCiNcFGC7w9KCMl98fwYJW1ANY3f8bJKtgOpZB9Uy70QfFfMCCNC
         82l38TJIndfTbB09/ZhwdjswC9UIFXJKAW9RB/byKKO11jBzXVtbueaqE3jJ3SdJFcHc
         gbPbgpejZE6YqMeBz3U5ul8lmS51wZb2a6IaLeEAhnDSKsbsDE6HIPqWJj5fu9euit9H
         wCKU8x+JQdjr68CTd8PSxHwlaWrcp+TR73qiufjpi0VJ9jwOWs3tnyfcf8e6kjpa5xyd
         geqrPqQR38aISspSQcw1S51zssntCeNNRO+eXXWfrbsG6v4Sle51Tz47nQQNEnYsudin
         T6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764464963; x=1765069763;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BvMYQXO8j67HXrkaRo9OFr9r+KnzegXxYt4q7UonkDw=;
        b=X9k71jimNCxvC7smEpAlv9VwihJCtVG1SkxcMLcn531sEpaQhNlzQZC2oz7Q/p1jSz
         R327rUBIeRzRpnNmwskRfHAV34SZckvqqFQRdXwJRgtjOklYuvUBzphM0nYbAuJFkyPR
         m0RrE2Orzz22suxz4p02ZkFVBjxVH51LQOYlkE16UAIEbW0nQq5NACia2CVPEHY+xdFO
         KnoFnPfMlQr38Nz1oKT5VsjnvxD8dvvKsAzsb8hfRJQaB0vKpulalgy7bDTT9zdBPLuE
         mbm7piDSS2/Po48hTb0WPkD1TXHqasDf6Dft2Xb/V3oIPl5rhexU4eECucbAuDiG1oiV
         pyvQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+oFovYkTMtqsKtFMYe2ExgjX14pKr5TyPQGRkx7iwF32gkHh053fCApenig9RmqOiMXAIef6AJQ==@kvack.org
X-Gm-Message-State: AOJu0Yy6fDkCh+oPRqjcRkDHsGib8naBI8KuBrFEgRDbGGv62l51SGMC
	n1FVmkomIvOjG0Ylx83rt5r6Gzqom0b8BuuZd06OnkyPzf4I9hczrqglAlrDNV8+kJI=
X-Gm-Gg: ASbGnct5EHCzxc7Xc/SDwpKjY+Y8Zqf5yy6PgQgXOo0TWoGXzjriSB9v1JXmNXFEQjc
	v+yOr+mhzwVYQycSx9m2w+x40twaL617f/1yn8vO5h1i/SFvil4qAZSValICiS2x+hABGoJd4z6
	YPyIHAD5dhTuGyy937HGGbuINX/6Q09nRttDZkBU/uO5oScvp7gpXsqkRWSITYfv58/4WCxnB+l
	m5khwhaHlfqM6XakfyCqrtWLDKiUQ08r5OemGj9YmKGVyKj9biBOhP0MV6KIhrufU/EtXbBaZfx
	47RKEQm1PdvW8gcrrF+s2xRzM3AhkYHFgm+ZJ1mOgky8N0oFp2GY3EfFvm5p9pQwyOjCKdvnSRH
	BFUOOz0EDSys4gzVChpDE56vFKFMWkQ6h9432aYcMnUyMPlRdRmx73tJ1kzk+L2u1sLcXsApeR/
	+c/pC0pD24MchMuSY3smrspAPN8HWrquqvw7dwiXK1Z0HGUJSorGdKyxsip1NY8f3LPru+li33r
	yzuv/k=
X-Google-Smtp-Source: AGHT+IHhN5Il8t4t/4h+oWd043jDfj2577ge+lbbM3cGbKuTj6uQ7eWbTy3xjWmJNk7Ya9h0mT4JOQ==
X-Received: by 2002:a05:690e:10d2:b0:640:caa5:57be with SMTP id 956f58d0204a3-6432924ea93mr12230340d50.28.1764464963388;
        Sat, 29 Nov 2025 17:09:23 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78ad0d5fe26sm31189847b3.18.2025.11.29.17.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 17:09:23 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] liveupdate: luo_core: fix redundant bound check in luo_ioctl()
Date: Sat, 29 Nov 2025 20:09:19 -0500
Message-ID: <20251130010919.1488230-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6586780004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: q5bqig33iry6whdf8o3oy6fos3wkgi9n
X-HE-Tag: 1764464964-676337
X-HE-Meta: U2FsdGVkX18SxZfg08FvdWN6+lkS3fGRYcdx21mwezZoLx7yGebNyl5bFLT8iB5Z2KKmmXs7azm3fu8NTkqvu8zMFZyCVJEfblcOOeT/XOd0HiqM20uK6PqScW9TkfXZ+1bncxX1nhnJ6h8GDk52x5L2inJb1jGNJNCXgAGnDBAK4Welcj51A/iKIZ2PI4Tppz47Psi9NJmxTJZyYDvVllkeYd7gXhQt1WXtC4a1bHuKqzicF6wjChx1zXtIQ2CSrWa+gHJi5wkhMKMNSHns7V13jMhyYMjYiX1LZXX8RV33MpWiYOZ8zeOT9KbyPza5BaC7LYfkFGyls8yRcTKTZOtcbuQFzg+x9TmrzU+gc71UE4k8OKN1SqUqc0B+EsECGdTU6ytxqntXGkLnwu+oXFS9Su1vlMtRUt1WyqfShRdnlYBGa4k6FCj/eyyx+WnaiPjfnmGjt7EUQlhW27RxY1imjSTgufK0ALOQdr5pAdEKk+wmzR/NGsmKUBiV7A+rPrjFwNWKDkbGj7+dnDuRrLmn5ZDFCzgUK5U3GauuoNJvIUNsRFqi5cfgxTuk8bBpq0TzFswi/CFSckeyv1cgUlPR/Sw6ex8nWbR+yHdoNqzNtS+sq6x2Ykpm5tJDEt+bxCRxtE/HG/gpg5Zmysb+2t3vVWfFffQkjd8ZfmfCh63LfsyYUo33WaY8x1Tsh9raH6hhpvsBUL1sTJD4WatuIRNHcQ9s3eg5V/U0b/oe4tPRAPsKdekwo8hosogaNlGuOJWcV9JosPoklGlf9tdvHbLe8FodGchtQBcO7JBvDwp+aoHsoBLiIoSrrIHqVllMu0ZlSDiXah2z2N7PWImTaftFRu3CaoGaX3/kbj+ZPUlBxQQxgftA6yCWWRnlzqPf6a70esnqeRkBEuf+ZsXDtsYpryrNeBH3opW9C6oHa55QEMTmxQGbdoynVohpro3Ixo3Gv9F1+PQVQ7RdKhX
 CywrTda8
 x4Sehq2rHlb9nxP99ETHWEeZ/RD6IPHJi8t4mpSUjkYy4sgL7/LXenS5G6SLebm+bi2tR7wJGma2uANTFGoc7x25znH+poZLVhNWbqshLEkYRYxI5qEyRqlDVuUfAoZdo5mkpitk5a8S43HPuaqdzvbrD0q4TXuc9WJTyHIFLk8Yl9p/oTyWrz/MQmp8Hf7ThNbYaczebGxC8sAMwTAaEDc7O1lzysCGOLdu7a4AZoUb7BJYYpLoN9w//D3RvDB42srxiXlKR8t4stwrM9lsxGS2AKOOkskIubp7OELwNmDAXuKAzjtDe2vGMTD7rjfzq1KK0J/L1Df1F9MsMJRU+OddJ1KLI5qzz+pf21iJAdHCXbCZkZp8IuyQ8nQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel test robot reported a Smatch warning:
kernel/liveupdate/luo_core.c:402 luo_ioctl() warn: unsigned 'nr' is
never less than zero.

This occurs because 'nr' is unsigned and LIVEUPDATE_CMD_BASE is
currently defined as 0, making the check (nr < LIVEUPDATE_CMD_BASE)
always false.

Remove the explicit lower bound check. The logic remains correct because
'nr' is unsigned; if nr is less than LIVEUPDATE_CMD_BASE, the expression
(nr - LIVEUPDATE_CMD_BASE) will wrap around to a large positive value.
This will inevitably be larger than ARRAY_SIZE(luo_ioctl_ops) and be
caught by the upper bound check.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511280300.6pvBmXUS-lkp@intel.com/
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 69298d82f404..7a9ef16b37d8 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -404,10 +404,8 @@ static long luo_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	int err;
 
 	nr = _IOC_NR(cmd);
-	if (nr < LIVEUPDATE_CMD_BASE ||
-	    (nr - LIVEUPDATE_CMD_BASE) >= ARRAY_SIZE(luo_ioctl_ops)) {
+	if (nr - LIVEUPDATE_CMD_BASE >= ARRAY_SIZE(luo_ioctl_ops))
 		return -EINVAL;
-	}
 
 	ucmd.ubuffer = (void __user *)arg;
 	err = get_user(ucmd.user_size, (u32 __user *)ucmd.ubuffer);

base-commit: 7d31f578f3230f3b7b33b0930b08f9afd8429817
-- 
2.52.0.487.g5c8c507ade-goog


