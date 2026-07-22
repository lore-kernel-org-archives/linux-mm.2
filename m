Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAFCAC4452D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 01:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 676326B00B4; Tue, 21 Jul 2026 21:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627C26B00B5; Tue, 21 Jul 2026 21:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518986B00B6; Tue, 21 Jul 2026 21:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 257906B00B4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 21:23:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9EAE112033E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 01:23:57 +0000 (UTC)
X-FDA: 85014666114.13.F8BB167
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id D8A0EC0002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 01:23:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nmFigF3E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of harimishal1@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=harimishal1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784683435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbFXTrauONRUcQG2aMTBcn7xFxe1QUlq55ZfdY6FsS4=;
	b=dRapMTmwVPRpbcTVe94kjP1pruzWFbLPKU83nuHh4Yo7qcI3zI2m/bNBqj489DnhM/TJsN
	8RIFSoQIR/iGCxS+pAuaSJnV/BytZ79R3dGrzeqd8G2KU8yvbVf0KxoTJ6PkuDj6w42pOv
	C6DHpWWFKq9VLKZ8nUSYv4QhdWETGZg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nmFigF3E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of harimishal1@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=harimishal1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784683435;
	b=THB3DhB9oblClntlJ/yyRs1iWJ6K2r9MD/Y3OZw4xRQjA/jBeLqV5NzFlRvaCg3UsZV7GH
	s1WoLY7z1fFUWBd65TTfPgPN0gGwggQce4mFV44UVixEa2QSj5U6CUGpa3Fj3TlhZfHqFo
	svXIhTiPQxwA8/nSDFxlh9AlGZD0Wsk=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-69eae037da1so5646972a12.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784683434; x=1785288234; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YbFXTrauONRUcQG2aMTBcn7xFxe1QUlq55ZfdY6FsS4=;
        b=nmFigF3E3pBtsZ9Impy9J6akLNsfN18Ez41KOZaXYLJ7ItrutTD+fmdlTMW5Nyt7Hu
         qQooiOO3oGFdW7OuUO6ybHLkpr9Tdb5hEE53Smrkl1TUv9sc6T63btiBEyIQ5ikFtJEk
         mvCt7Rcl1WiVn/DLdrF77E9XLRVX+QOb1nB1KpnaOrajY/Fi9ZNZs09wd9CEMnlGAkjh
         7gtmVL0OwQmx67nL1keJ9InuCF9OlXH0LZ+7kQzF3nBBPtSZG972CCz35UPppe1mw8Nc
         ZQBPv9DGkC564T0Z2PKsQ4TQpTXyglmWyNsVcbpQLWLWaKKZTx03XujxgqtRndUfZazF
         5D0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784683434; x=1785288234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YbFXTrauONRUcQG2aMTBcn7xFxe1QUlq55ZfdY6FsS4=;
        b=eipobUpMnXC0HJAkhViSp2pZYx+lqRknPHCPbLlD07Dy6ga2fQtwoE5oIDxpsW23yt
         5rGymjHuc9FZncOMvIGHDxBa8hR68fVKFQNECRPPKH4uQf29W0+ptiYxDvqE84eAnMef
         RypdVVHzVprKGwulcNH0bsdCfVygAt1plYAqPoRzsCY41pMcDaXc44x5U4Ul7TOey/DG
         2SL0LaQzr6Lg8t1EG/qGDphw6pAjmurbkVh2SIYvqRRl0sl5XF2Cd1S9yhcJf8XwkQME
         Pp5Y85s6MyYGUy1G528wnwnORjg4M+IH/STdC6NIuSFRyfKhjT4G8RcVmeQJx5l3KCe6
         2MCg==
X-Forwarded-Encrypted: i=1; AHgh+RpYIW4vtmBqNxoCFYQDwoRS42RlbGk38or8uUSZQFroCLv5yfNkhx5cuuZuGM2cVD8Y11sc7gUSRg==@kvack.org
X-Gm-Message-State: AOJu0YwE2sZVtKdt9M71mwtfHxJSPEQATHJJN1o92zRcJDIUMScE6xxv
	LiDPiy0da4ChlFSlsQIdp1DrQRqUmpmOSazJWuKjBlmNB27ultyM2mGI
X-Gm-Gg: AR+sD12zPF8IxEQzfaxa57W2/5wqgJJqtwTovdorPOHuDYzokl2dE33jnhYTByn7CRH
	h0aazSbeIaP0bp+VS8f8xoRCqC4TIdQ3gcRMhrUiebvumt1d71M54NBpTout9j7wDhGepwHQGk4
	0h9z3U3/lWDlSKJzz/1/SR8VvZ1HEccxAYvLtCzFpY2lXDxFh/F+34CNBbV4wV3ojcGHjA5/UIp
	LxFYuzpnSUkC+6qOtwBdYHrh9i7xzaxsXVFChMhOJ84WR9SvHbE7YllBuv6dy9bc6kVEBPZyrs/
	9KTTlqwW6QzxWoXn8brpEWxQ0nVBKI6mNBTh9JQhRL1Mhizn6pY4uJviy2c4TilRkqQmKZvKIYo
	StYGveVZMpZZQ8NPW49TLV62fCgwPL+co1iIxaC/gBj0asLAZ/5uM9SWKpNg3LOJcqXKgcAnz+8
	nzYYSi40NTcvqApZU6gcCkDx9g/QOzwhGo4ZFweQ91uSVgC9syTnW51UkDHDkK12vXIw==
X-Received: by 2002:a05:6402:528e:b0:69c:7406:9492 with SMTP id 4fb4d7f45d1cf-69e652e1111mr6897698a12.39.1784683434224;
        Tue, 21 Jul 2026 18:23:54 -0700 (PDT)
Received: from misharu.home (2a02-a463-a071-0-7364-df4e-3b35-2094.fixed6.kpn.net. [2a02:a463:a071:0:7364:df4e:3b35:2094])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69f34ba67f0sm321569a12.12.2026.07.21.18.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 18:23:53 -0700 (PDT)
From: Hari Mishal <harimishal1@gmail.com>
To: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hari Mishal <harimishal1@gmail.com>
Subject: [PATCH v2] selftests/damon/sysfs.py: clean up sh processes used for obsolete_target test
Date: Wed, 22 Jul 2026 03:23:49 +0200
Message-ID: <20260722012349.9738-1-harimishal1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260721190404.135937-1-harimishal1@gmail.com>
References: <20260721190404.135937-1-harimishal1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8A0EC0002
X-Rspam-User: 
X-Stat-Signature: zm8xxanwrcohcqd4s6mqr7wrxgo7nrp7
X-HE-Tag: 1784683435-351666
X-HE-Meta: U2FsdGVkX18N9AV44/QQWOVs0sP2RCaQR8423uNOGXllchwOHn43Il70IMnlgQkVWLCl1hYVaU2XrfJ487W1Ff1dpVVLqyRZFjQIbIFP0GqdOdJL6rEBvDxIc59d3VorH6PmQcYk2D6BcICucu0KnKMRPeGjbDo/16gbk6L4CVYVrEl9oHaOsN+Rju23cxz+jAQhi8CHd4tPizcLmnQ9OvOM+SaFM4iFrXfM+ASV/hxiN6wYepCgOW693dff9UK+vk3K9EWRnOduOIDQWeIUChT2aQr0ujytTQ4eWGcQdlBxxMa9BicwasaxyUxk4Y9mNWz03Vh20+DZ0DO8fIiEctcxN0unygwLcFmtFAMeW9mjDSMfRfXuWUnlABYi0wp99zN98HomjxWxvYRt8kGSgsv/WAiJXHEypsel8kaItplcCR7fzcm1prFIYI0GetBZ6QYDEiIqTjLCSgS/gCdEQem306sJlixiLPzVw8t+i1K7ofs+OJnxXwy3UyUNGltvuivG0oaHzuE1yM6MTVAQK99cEPJMuwfU9uQU/cIoe3+B3SrlaFB6S0YWVXr+lpA3V0x5PNnFLqKutY3e8sRUxMY0vjMZJGOZiBgNOp2XD4iPBRz7uHQeQUIw/CD370Xwh2lEzeOY2QyOnSutZj+WSdkgxjcv57vMzQXWoW3IDk9W881KZqmjPJ3LSn96BUmHqGiyuXdjHL6ZREgjw0XGQSBTIPMdpjhAwHjyLrVokQm/p5ODZhgLu4asEsKe32tUgnS15sHyLfnnQkmSb9rdQxY7AQdNaebuin0Khwxh/BIBSSnvtPZgUPj0UQNY33htjKQkSjCdt36/eq6dv9P63+n2dNWrZNzGP3cYSeDlK/CD1+o2hSD5+jfgUOTHO6dOdTi5bDz1htLg4YPyXfbQZnOdS6mFKuOiwOWbxJWqi6DepMHSHg6OvS9EL+ujzLJ9cvJ+xjqZTkuHh+BAXSf
 NO4cZYu9
 tz9Z4aAurKHeh71vdXMfdASmHGeZ9tXrrwyxtQ/kJf5FblrTYeoEx7IwErTPjL8suwdHTCfUdPVNMF1E880jYoVvoCo1PTHgRBnr71MhrTW7ukqk0Ei9qV8Igb0lZgTYiIDl8BWsbRMMeFHVjgI9ZtJWD2xEBiYufHfUfgzZFCdUw2tj1u5enbCrnRJVF6/leE9r2OQZMzg9goC9QQmTLuy5F+Fbl7mkwiSiuuxIX3RMlAr7yJgCWwk98X4Oj3SrIQhVma96bIlhvswQS/LcmarSxq+CBT9Z9fNuSWU4Th7MFU5NeLFBJ0l2iDdbFt03DNmsYLFbUZ1TMGZoFor8aAyZz8uDGQHHg8052w+l15CT0DXto1QSP7uVgLxdYU0BKDL5H2GlRIEOPZTlorAB7WXQsA+QI4qv8LLjaIcgie7WQx6EeItJ77H4kdt0zCKFAfWgyxpZjg/vOYjA6mVPyZYoqxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The obsolete_target test spawns three sh processes and uses their pids
as DAMON monitoring targets.  These processes are never terminated or
waited on, so they are left running (or become zombies) as orphaned
children after the test program exits.

Terminate each process and communicate() with it after the targets are
no longer needed, so it exits and gets reaped instead of being leaked.

Signed-off-by: Hari Mishal <harimishal1@gmail.com>
---
v2: Terminate each sh process directly instead of giving it its own
    stdin pipe to close, dropping the stdin=PIPE changes and shrinking
    the diff.

 tools/testing/selftests/damon/sysfs.py | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index aa03a1187489..bdb37eb1d26f 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -356,5 +356,9 @@ def main():
     assert_ctxs_committed(kdamonds)
     kdamonds.stop()
 
+    for proc in (proc1, proc2, proc3):
+        proc.terminate()
+        proc.communicate()
+
 if __name__ == '__main__':
     main()
-- 
2.43.0


