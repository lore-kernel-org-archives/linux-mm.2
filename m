Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 744D6C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 19:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737826B008A; Tue, 21 Jul 2026 15:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E87A6B008C; Tue, 21 Jul 2026 15:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5BD6B0093; Tue, 21 Jul 2026 15:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 269AB6B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:04:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA12A1C0140
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:04:18 +0000 (UTC)
X-FDA: 85013709396.22.FA113F6
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0081C1C000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:04:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PJnlft8S;
	spf=pass (imf20.hostedemail.com: domain of harimishal1@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=harimishal1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784660657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+JqNpnriZg+duzi2qkjlrmcfUYuT9EqwRHf7/xL8TkI=;
	b=gII1YHtZqzgLjh39yqTYI4Sw5asaHWEZfUrCLMjiV/WFneIdvR+DZEtLHaw/xmz4BKHIq8
	25czk+x/Fakdje25SbLHKAvRMdtRTuYakQEIZOP/4VquMPOWRrx2r50aJeeBQZuM3VWarM
	TJ4BoFxDwFZqVJd/mCnfx99nuLemc7U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784660657;
	b=WqYs5eghDTVJUaojCI9yeVdCBbgkaEqr3DHTRHZqsyjOpluFpEYniYM5bdEb6bKCjzgltT
	ahi89K+h99jHhVV5pUnxBqyxHLvwxF0kK/Si40UwtIE0LaWsbs3jS2MHqfOq7KlJa/1sp4
	AzWIMLdzNG3IZIUU5P1yodCKtEVnShs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PJnlft8S;
	spf=pass (imf20.hostedemail.com: domain of harimishal1@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=harimishal1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-69e7a5b61e4so5284064a12.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784660655; x=1785265455; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+JqNpnriZg+duzi2qkjlrmcfUYuT9EqwRHf7/xL8TkI=;
        b=PJnlft8S9iZ4dT2nZImw9VK3WCzgG+xdBWDIYYVh/rrmox7ZIKvdk5/i8ct6pt35ME
         2irLLx7hjQVP8RHPWQQYBIylDpdc0VLbs6u/kjtH9VOA2NHQIxCfHJ9PNISW5xidkFbb
         hHsyqCG1vXqZT6M3IVEwv4m4ajkUSkoNJJVkM2TCqKabtVYOK8fjc7ihJkg8MrigUKQ9
         bFUQI0tq6P9q3wZKRvjP4/1b2DAg6SM76XHM/qvoZYO5gZqw+mvXJhVG7PMXGmT5Uz+S
         EArFZGvNVyFkL47sWr7RO86Qz0RNLw33EO16HcBQ+AhyYajLUe/doJsidp9XquB9NQ20
         3Uhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784660655; x=1785265455;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+JqNpnriZg+duzi2qkjlrmcfUYuT9EqwRHf7/xL8TkI=;
        b=CilwPP7MZlLX/NxPNHZUpi1RIrm1OHAHUac0Qo0zzM9yVAZ9o66Zanq6V8cRuSXRp4
         dgL9x3FhwC3RyqVHUxkK1otg51RQiZcY0I6kVkSo6LqJL4N4Oa5Y/lydp6BNQOqYcKvL
         RBwN+IgdGbXIzqQH8RD7VDm8hPoBkRdD1pYuJCRmJsrYla0b/F4qDzyNJ63xj/Fae4VM
         bmbPZhcYvHpSwA2Bdwo5Ik0bJeTyQ9Vo6Q1Zwh2qHRi8vzZHFddBA2vLYCYAdexrhvUk
         ifyp1j+RagX2PrV2UGxgdS8RGKe56tatwGaEU2g+f27xFZ4GnbfkTcqWqioCpnEhDEiD
         ngvg==
X-Forwarded-Encrypted: i=1; AHgh+Rrx/ME5SW5Q9qFGAvzeeEqQamUlFCaRbahAOCJ80QKzVOdK8RnTSj6el3tFOdIuRkC3/lQAAgzkPA==@kvack.org
X-Gm-Message-State: AOJu0YwwHCXEAjQ2++rgk/peWoj+797qCpi+3mTyapTbFFEUG/NhCDh8
	GUlC11pudf27guu6kjGJUNH/FNz8HkxbdRqjBmNYUlKYs39Te0lwktSFLjF+ugsqmCagzA==
X-Gm-Gg: AR+sD12oY181Jw2/tNh2D2ZoE8FBt04LjCTNDZpy3b/0V4mJYlyjMMFkxtkqiYjDCxX
	RTgeucsCqzcgu4uLI1bZ7fJ/on0HjwtTWQy2Anqd8ZaYYdcUAC2nJZ+R27qmMMFJhb1MHsGEoPS
	nbXunVVHqXI8eKPG3SGqn3u7Np2fz5J8vpJM1XBqxm3Fyy3qSBm+ET6iDIJVPe1c7X30MlFnKev
	+u7S+Sd7/hs3bsyOHtF0q4nCBz2nHrloRUE8pzi8aT+hBm+BQKCvWFk4/++0bQbvdak6FUJFQgz
	xCP4kNdk94A3QJy3azxf+23HZ9c75iPEDIa1T4toGZJXC6GGTU0Uj0HG0qJUNrYPpaxgdAToXqG
	2JtZzTXSWYtqF9nDp9j/M9EiWD9wAd0z9BawQEK2f5mfjlOe3LBA/oSguPmAmECgtu/dnfzAR8Z
	hHlrL0OTE5BL2pqbWnE2ZQKJkhjnMoBbjJxazRtQjD6zs5wRXj5fRVfJXlw1jfloEswOHo7vQWD
	gRt
X-Received: by 2002:a17:907:3d45:b0:c16:1901:6ba1 with SMTP id a640c23a62f3a-c16b47c50b7mr857110866b.34.1784660655267;
        Tue, 21 Jul 2026 12:04:15 -0700 (PDT)
Received: from misharu.home (2a02-a463-a071-0-1315-eb9e-fdea-db07.fixed6.kpn.net. [2a02:a463:a071:0:1315:eb9e:fdea:db07])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32ebad78sm8903366b.46.2026.07.21.12.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 12:04:14 -0700 (PDT)
From: Hari Mishal <harimishal1@gmail.com>
To: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hari Mishal <harimishal1@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/damon/sysfs.py: clean up sh processes used for obsolete_target test
Date: Tue, 21 Jul 2026 21:04:04 +0200
Message-ID: <20260721190404.135937-1-harimishal1@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0081C1C000C
X-Stat-Signature: ee5aqh3fhwgododa5w3bhfgz5h1pk1fr
X-HE-Tag: 1784660656-506239
X-HE-Meta: U2FsdGVkX19G+MaXPDsVtxZYGTKiF6+vApuFShL76gJ/YGFF9iZFFowJuKocUghxUjtBFoPHuq1D7JgSrkHo+Ds8GU+bWmG9IGUnzP3zzfIcWg8ye6FyfVOwvshL+8mdOohP9FTbcXajJEsVaoF8jrhS19CDBdRiMNDj+C5q4TL1uCQHR81V8QBKRQq4wBd7JP0WOWZ0PjBkrl71bv5dIR19db1eCWCtMKiUDlGaR7ysZB63Lm88hXuVto8TLLLC445AlVa9ZjkEsHD6QZj9gdKkz4fSlbyT75Es5Up55akZeKIYicxAl9S+IJGeK0Cd4LfvriYq+LHazxWJ3TPFqFo/EVkzMojwJz8QVW+csUVucRxiFvnrwdOwruAafUkrqkMnEVPqE1QPbtLTM0hJ2HPbiox30VpjmSupaDaKdDGeBxs/hIeDAw9LfjdJ8Oa9bQwD2LTER3reDa2oSAg2WQN9YDn600BD/u580sBNp4Jpld04LkO2uKM2fmNajH2FZzvhUxtBLCQ53gKrzBr82Py4WAvYCylMloI8tBxZoRKXGp78996f3B6GG7I4ZoxjiVdQam5rXDwzbr0xz5JLWBxzVfTwuLCrdgQD2RYv3b7x114vV4hSefm9GvmJgKLjV+uGIRu4ReIT8v7SdfL3NsdGbbBfWfx3/vD8wJ3RG5yM6Tq56AmU7tGCFHIKtQ0b9eoYOHNFoVBcInfZP5uhuKHjnjkvNiLn0sGA5PSwg6tQPVYw28ORrNNSKM0HuZ2+z2VMg2wopURIginBRU+i8fLMshRI4xXbeoIubwDL0e12wcUQ7bcF26HhANmR0uHPtCADoZkIP3dQQAitqvCwazT9N2P1h9kout9o58fdGzNNYbmIP5WJR4Pmmww7JpJyDwoNhWAFJsLhO8ujVRxDwtuWkGGRCUApr4p3DNEZGYXNGwJAmzphvegyzUdb6sQUDVWj+SauZZ2R+2syXda
 oAXu3usC
 Wf6XksTq2F2Zvh5yiiuUppUylEadvhBKNmV01Pisv+ynBFJ+KTlzL34VUpejEVgCmBkvrnyFkmnIBcwiAfDjTobEeWWdbrv/8WawWS/t7L7Q4Bfw4hSNxt1wUPEMRzIopLQK7r2VMfJutoaWchm6amb9Fq0e1H5BAFBBmXRFXo1x1ZaSlVq5UmPSpg5YmEPiu8nF6EdH2nBXdeHQM4mY2iC5dcBIz7V3EhexNQcQmX29jUbXffqrtRjqF0PnBSnpm8FNRxijjYcNdlFfaoTTk9TAkGShbOInCaeYHApNwHgpTnMyzzznDfvkvixdSATf5pcGMPMhmSvl7DFyS3ki24OkevYJELoxn5Go8GBEEnRw8frTOOBQIFqupKlMUwCWYpUFDGClrNSU5FWEAw+RVYZjEgCjLQ46uRZIRzfEFy3kocpr0kvYAitGbBr1DJNIxHeqEXypsVHTcBPPl5Oab9AaM4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The obsolete_target test spawns three sh processes and uses their pids
as DAMON monitoring targets.  These processes are created without their
own stdin, so they inherit the test program's stdin, and they are never
waited on or told to exit.  As a result, they are left running (or
become zombies) as orphaned children after the test program exits.

Give each sh process its own dedicated stdin pipe instead of inheriting
the test program's, and after the targets are no longer needed,
communicate() with each process to close its stdin.  This sends EOF to
the shell, which makes it exit, and communicate() then reaps the
process.

Signed-off-by: Hari Mishal <harimishal1@gmail.com>
---
 tools/testing/selftests/damon/sysfs.py | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index aa03a1187489..d3d50a5a1d56 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -328,11 +328,14 @@ def main():
     kdamonds.stop()
 
     # test obsolete_target.
-    proc1 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
+    proc1 = subprocess.Popen(['sh'], stdin=subprocess.PIPE,
+                             stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE)
-    proc2 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
+    proc2 = subprocess.Popen(['sh'], stdin=subprocess.PIPE,
+                             stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE)
-    proc3 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
+    proc3 = subprocess.Popen(['sh'], stdin=subprocess.PIPE,
+                             stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE)
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -356,5 +359,8 @@ def main():
     assert_ctxs_committed(kdamonds)
     kdamonds.stop()
 
+    for proc in (proc1, proc2, proc3):
+        proc.communicate()
+
 if __name__ == '__main__':
     main()
-- 
2.43.0


