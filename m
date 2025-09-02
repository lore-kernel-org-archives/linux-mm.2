Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81CF2CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1098E001C; Tue,  2 Sep 2025 04:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8638E0005; Tue,  2 Sep 2025 04:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACEB28E001C; Tue,  2 Sep 2025 04:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9971D8E0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:36:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E05813B73D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:36:19 +0000 (UTC)
X-FDA: 83843653278.09.A925297
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3F8F0C0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:36:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MTyhUqZG;
	spf=pass (imf22.hostedemail.com: domain of 3f6y2aAkKCP4groikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3f6y2aAkKCP4groikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756802177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QH+dNhuwk1lL/MGBDy4gK3rPW79vkNW7Vepzh60wxeY=;
	b=CBzgKV4HkSSB/UIT26O7BOLXkROzNJcLzW/CBkCKuG/f7QghNWc/EzNeyRNOqEjxx7r73M
	pO7wukcJZUG0dhjEcFecgKs1ICoF+KaQTEO/Gs/o+co117Wt/OgyG4UK3ElsmHzYVHq6+z
	i+KcuQDeaHGQmmHWjuWg18OIfpukFpM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MTyhUqZG;
	spf=pass (imf22.hostedemail.com: domain of 3f6y2aAkKCP4groikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3f6y2aAkKCP4groikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756802177; a=rsa-sha256;
	cv=none;
	b=FkCjTPEWL26Nk/xZrHlswgPu/T9fckP2/cTR9Nl75AsV/Mz7i05Us6g+pNNo9K+MxwY13L
	/LOFaAf3XbMk6qKE4N5/ZC1knxKXwPSFodsSLKgpCSZBZsUvQTe1PTBFP+gkkDJV1TPEku
	A2Rhg5Peyx/NX/GLFrR5glO8k9ngmB4=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45b8af0b8deso11169145e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756802176; x=1757406976; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QH+dNhuwk1lL/MGBDy4gK3rPW79vkNW7Vepzh60wxeY=;
        b=MTyhUqZG7NoPjDJWFIKmGtgDEV/AwOUyqaikIpQhXTqRnWJ7O0bMIQIssh8UOzRjwt
         6nLAwohN/TXAgNhn237s844kiYBpc/BkcSQi8uUygCTx3lH7OCMKrPDONvMJE5BnHnU3
         Zt1ukTk570k0JqyTtBUy2/dYu5UyYgLApBYSg9jgcR/6tgtjKbkQvN4ojSuhAKId0r9f
         xPEp9YN2EG6XajL67anemp/6vCe9m3O8NhaMWeOu/OZG9EuLkRPp5+SwnZCtU1bcGi9E
         EeGwJ8J1gLPmEbsEuJdPH0hvngzx4GEJb9fTl2JE+EDOF+1B8NCMXw2mWEMlTAY+b9yQ
         Ylfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756802176; x=1757406976;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QH+dNhuwk1lL/MGBDy4gK3rPW79vkNW7Vepzh60wxeY=;
        b=WFBg7Dg9QJaOUwQqCy/mP3FLj2utfqxyVIx6l2VpS8gvo4JFl/H+X+0JMtPWEuTPiV
         tLfe4pscJIMhcFfWEIJ+tiGUqk9iRC08PFJQGd4bYthQf8L4WHtojqmoeSwM2w6TDtR9
         /hlC11VUvlY+HBWn5F0sqzxCVbUTtsCraz71PP10qHK06kTsdeHNsHy/xiQLr9zMev31
         V7nY4HqgUkKTC3XI2XVdzPITTbq1fvbAxAzvXuoC1rJCpFO16FaX2K99h8b6BVdEeCvw
         sLKeA/hd8+J6XRcibw4HOv2sNaIQ94ZzEaF5yjs6ZTLC3h2bOlEwxZ8vwaW8Bh9OvoYZ
         orig==
X-Forwarded-Encrypted: i=1; AJvYcCXjEBcx2OvJdAhsvkjG9/hhS5C8mWuQnxXbw3ZFu9I2vzqD6JcyoZWhEXWByNauA7Y0grPLJ2pUIw==@kvack.org
X-Gm-Message-State: AOJu0YyIQYu07DMBH6hFIw+KZzFCGN9eQQo4NcK5rfbw7oGOlUCnqig4
	kz4LLzoY8gzfEifEORPoEKW7G3tulVUYYJKNN9ga4046S8J0Dxalpt780s2Hn4yM5W3peFiIsh5
	kYpcwRwwSYtSkNjmMfQ==
X-Google-Smtp-Source: AGHT+IFrwiLMwac2efeWQGD8tg+3earadoHpSjr59iffX99070qwvna5zy2O9EDiYznHm5rt2CVI2cPNwcE5eb8=
X-Received: from wmbep10.prod.google.com ([2002:a05:600c:840a:b0:458:bed1:8923])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46c8:b0:45b:7c09:bc0e with SMTP id 5b1f17b1804b1-45b8549c7admr85100405e9.0.1756802175884;
 Tue, 02 Sep 2025 01:36:15 -0700 (PDT)
Date: Tue, 02 Sep 2025 08:36:11 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAHqstmgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDSwMj3dzEgpxU3Zz85OyU1ALdAt1ES2ODVAsz02RzsyQloK6CotS0zAq widGxtbUAO4ntmWEAAAA=
X-Change-Id: 20250902-maple-lockdep-p-a930e865c76b
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=2041; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=QnfwVPV7sl+XBZzzZ+jUFbEpa7KtnzFZK0GxLBS3hSs=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBotqx/CYGhzcPznFiE7UDh9XQoTakkyebBpyup4
 FA6tih9P9+JAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaLasfwAKCRAEWL7uWMY5
 RszmD/0RBaQV9WIxAvZ+VnmbMFTKWuCAP44AGbTl/3sQk4GNwQFQY9uNosttG4sVrjzvQo6CTyW
 ssJ6yEm0Q6z6beDpkId7DyPz22AG9PkO3nLxJaI4tge9qKiw7MPDxBhMDBxirdYiD8VBhMqICaW
 RQJ3GrQrlFmgfmxgF/P2Lq7tVEuevZQ6Y63z5/iNW7b0HM/a3cRaJj1wKSqvkGL+3Dy6GsKBSAj
 jsofZrZAXvHnbRViM86JVCRcK8Rl61lRiaMAC3iMbhV3molQB5qWSEQFBscIkLoa6UBLhKvLuUC
 PvU2199QpdCFl3rM0ahASdsYrb0hDkTUljpLu4SOv5hGDqNofoSLg0TqG4CyVevrnmNXynEEY5F
 1twK6PR3dbAhfKze01E6Y8cTRxgeJtgOR6xgLV59rnY1Jhb7n83QZdODGrKnbFpIG9Gq2YMQB1T
 wbTbMi2yVf9ZxlI5ZF2aGhPuIHMtFx8kc5iigDyHNLojAnN8IeN26oGF2jgUJgvUMGdVnaXOd+/
 bSIsPhTcucBM5bW1YKhe2Ya4XH3nGT5eDwAUfIL7wUinYIayPZeUe/oL/5f3MninIpDJg7phLyH
 8oCWYTXP7b/Pd44KqJIdOgcSPrWZACiOi+Wn3joeYeNQxwsL9Zx8y+KYwazcLdY7MqunZopAdj8 ZrYZJc1g8fHGUPQ==
X-Mailer: b4 0.14.2
Message-ID: <20250902-maple-lockdep-p-v1-1-3ae5a398a379@google.com>
Subject: [PATCH] maple_tree: remove lockdep_map_p typedef
From: Alice Ryhl <aliceryhl@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Danilo Krummrich <dakr@kernel.org>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 7w1bqza4h6kdsc4fby843qiryjmd5k5b
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F8F0C0006
X-Rspamd-Server: rspam05
X-HE-Tag: 1756802177-906310
X-HE-Meta: U2FsdGVkX18u8N5FOM7fJ0uIRz0oEtgnOglesw+3ZNPBQh//gQUQePk+VJOzz1L72g6o/VrpbtRk4loyd4vmdoRH/iaocf3719Z9ewXI3Zb912AVEXYtMCaKw8/Eah6Yx/XhVFLIXRxb3qjwXnFpG2Dk2bfcZj9EmPsLApU1aoRM4n13Iqkve3wQFRuvWY2jTmev+RikQqpTaKJgMkix1zCs4lreYnUVLhWfjfmlaDVRrPBhnBvbY/64HXgp7NzgQmXvwR5E3dLOQajYUqwWlaSa/Ae3ZVsiIfeBBUME1uZqfix6zGYIWMO+Mw7FH18jEKf1XpClKcJPJ5/WmA40f1euw+nnm9MmpkAeX/ZQq/LA4ufI0qM94lGLyWODccj3XrnMbBPxE/QFmlpK26QVo3+tuPrHuOLmuADB9h8PrCPiRe4MdyDXG8nWuhzDJfwHrcCNjYBDYLTQnCgn3Vpq/xoqaO6rvNysvaIyUEqp2Cg68PX+06P3CCKD4ui+MTazmj+c+Trlzcx0DOBU+DMxi7OWXeOo+SKmW7yYoxcOLEVqc10D+TLi200cc+uVofR5Gouqr/i1XVCpryTsSo19/Fdh7mXJwN1StmGVWfNTF2OhQm+Pb1g9SsAhlY6nPDplgwL8xbq+dEclK8UiNA3vAuqC3BXb25YP847D4jlySAAC/hiC/4ppVPFvthqXveY0WA7Jj1Fy9B4PeIeArJbdC8bvfKHvm9UmM1eKloeV0A3XqVPzwLitKwthKtmI5YDdX3f7MBr/xZvhBwPHP0JRJozW87ZRDnKJfof7HBx/rfPVIUk84cjDDbDkqHvuWTkl4oQbt3JLuml5RRAaSZWGR+KkVHgoaSNLipREq5pywLTkSBnEluLTtpCPFH5qITQM7GRZxenxPOkTpUgW3eBTwGodwvvxKXoeBAs1gFKyTXNMDeC+rNCDkzTY7Km0H0OyEyD10kQnMJZ5W/52NBd
 ZtfZ9HOM
 Uc0NOk9iHj/3YQQY2ALt3eeCIltgiL2bzvAdQMLXxVyVo7V1qLbZ/tcefaONHJ10DQPg1Osqxab8zpgnzsO03T2rvVGydAwYarcNP2XQ9N/JeaXrTJBVvsT3GNO/jisNtDfMbv3U9LpOplyTH77yKlgPGYc5owCIBJLigoc7CTgNKJC104uepLb4Oq9v3Lff7e8L7Fl7me901jORWvARQ7Mh51AWGJKn4VZqZP/ilLYOFvfivVDKuwos6aSblCv0owSdriU6HP7byoNHaaRLXbc3i9nqCVG/I1Ba6+GleGDd6qKfMbqkhNgQjoYyG2usoufoFdcLa+wyck9UzXZsfuxeVIljCE7dKKXdlsEyq+2uEDB2ywLPGSrmYJ958knTqiQXxCPikcbQ3uiMz2b9vSflgidNJHLMROEsr68JzSTB/wmyX/8k6LKRrphhA6jokjhftvkvsb0K+VpNZJ0LKsCemuLIB9/5Izw2O9cTsZy/Pc2G3QuGsi9w3JsinqmcFQ7v2ZPDMYf5cAoShJeeZ0iv0AlO0oCI5vy/WPfFaQW0dMlMvpiaelB3DfPq+he1XF6CnDYmlftPFVslADMaOZlsF3ry9lYIWX+fU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Having the ma_external_lock field exist when CONFIG_LOCKDEP=n isn't used
anywhere, so just get rid of it. This also avoids generating a typedef
called lockdep_map_p that could overlap with typedefs in other header
files.

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Originally sent as
https://lore.kernel.org/all/20250819-maple-tree-v2-1-229b48657bab@google.com/

But I'm moving it out of that series as it did not have the intended
effect on the Rust bindgen output. However, I still think it makes sense
as a pure cleanup patch.
---
 include/linux/maple_tree.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index bafe143b1f783202e27b32567fffee4149e8e266..8244679ba1758235e049acbaedee62aae5c0e226 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -194,7 +194,6 @@ enum store_type {
 #define MAPLE_RESERVED_RANGE	4096
 
 #ifdef CONFIG_LOCKDEP
-typedef struct lockdep_map *lockdep_map_p;
 #define mt_lock_is_held(mt)                                             \
 	(!(mt)->ma_external_lock || lock_is_held((mt)->ma_external_lock))
 
@@ -207,7 +206,6 @@ typedef struct lockdep_map *lockdep_map_p;
 
 #define mt_on_stack(mt)			(mt).ma_external_lock = NULL
 #else
-typedef struct { /* nothing */ } lockdep_map_p;
 #define mt_lock_is_held(mt)		1
 #define mt_write_lock_is_held(mt)	1
 #define mt_set_external_lock(mt, lock)	do { } while (0)
@@ -230,8 +228,10 @@ typedef struct { /* nothing */ } lockdep_map_p;
  */
 struct maple_tree {
 	union {
-		spinlock_t	ma_lock;
-		lockdep_map_p	ma_external_lock;
+		spinlock_t		ma_lock;
+#ifdef CONFIG_LOCKDEP
+		struct lockdep_map	*ma_external_lock;
+#endif
 	};
 	unsigned int	ma_flags;
 	void __rcu      *ma_root;

---
base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00
change-id: 20250902-maple-lockdep-p-a930e865c76b

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


