Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5045E103E183
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BD146B024D; Wed, 18 Mar 2026 10:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66F8D6B024E; Wed, 18 Mar 2026 10:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5375A6B0251; Wed, 18 Mar 2026 10:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5836B024D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:17:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DBED913B786
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:06 +0000 (UTC)
X-FDA: 84559385652.19.0F326B5
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id EE48880004
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OBwW1B9e;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773843425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttHPCX4MWc57OiDPcB0pv4zDHcsSOXKOATFAKs8NkL8=;
	b=JJ3ui1L15zR9sZKf0ci/GuQOnzc5r+nPJq0ESDemH2Xg7D3fNRVpPFD5GrcgQ1k3j1jcei
	ZC6JjIPip5zseWbgY2cTF9nqxH3BPM1bzYMDBILwsds4dFgKqH2e4hjdl3uMZ7G/0RBwPx
	pwIkmQVAm3Joq8T4t/e+U8q/Sqch35o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773843425; a=rsa-sha256;
	cv=none;
	b=NzgCMPk02ZxkETfd/vgqfQE6W95IF4u43h9hq2fj4HZUmCWxri9idwj0vx3Zyj7hNoo9GM
	oEr+576bhcnR3bD8BT7kf1ciEt3xzDimTCBal/FvhkLaqs9fBCwt2i0f5bWmWsWT2yb7gp
	bdu7rNyjG3zGYv3gzJAtU3iMQBjsovg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OBwW1B9e;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-64ad8435f46so7638811d50.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773843424; x=1774448224; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ttHPCX4MWc57OiDPcB0pv4zDHcsSOXKOATFAKs8NkL8=;
        b=OBwW1B9eD89IP7FmwSCS/1IjQBisah+TbkO5w4UnVbofhVAK79M9Lp6VciGk/D66fm
         al14dWWMXBB4RN9T8FNI0ildieXgWO6fzI4AF6gd01fC1asT4NNkYqBPfWZ2vrV1F3RO
         YeCiBRoUPYMvVZw3/10IrpNzuFkbtRgR3PitWTJQDObr7S2VOSHj2WjXUtGF1dw5Dzsz
         HEzUBCauE/LnjBkK/ZwcxDKa2tvIX2h8vtZu/6PMRAt8uJAEeL4ACiYt6TmAByVHkKQc
         cpBMM2q9X1/leg3i3irVWp8v+F8QDXNPU2ObvBJDK+0d1k8pxh1E+5V+jBuLUV791rk/
         5AWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773843424; x=1774448224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ttHPCX4MWc57OiDPcB0pv4zDHcsSOXKOATFAKs8NkL8=;
        b=aR7KikUX2ERxUz0fwmEuwkQU5twrdGpUgkm2sy1sE16k6hXI/Vg9Qpe8DUDmt9iMzH
         EUxcI7d8cYwh0i3d21iVF+4yGBPPXvrrgr3fC4n7IhHOO8jrIfIAjKs0x55F8zIuNbC1
         lcd0H8TE+4hPu65l7h3yuat6EfLf4UkMR9xgUE5CZ2afxTSBdvhk2jV/5eRHWoWMnTJP
         jfNmXPPstnZT/rT8p8wy/NazcKILxquqQQQ61ivs/zV66gBm/SlBV1Z98KGs5umrUdl+
         rQJ7lHnikSfiB2GCQIbec0PltFBPhQHtaWKnIZ8nw0VY+K54ehAQKeiIiisPHCIBR+TK
         Zhmg==
X-Forwarded-Encrypted: i=1; AJvYcCVGRqR90eX0Bqey31zboPZBy4UjXu9Nv+tVdlv08jMS71JrJhYUC82k8/LIbB7Q5vkpsVWp5zMriA==@kvack.org
X-Gm-Message-State: AOJu0YzlsvhjgIW6HssFXO9g3oyhTW/ExwL8tHPywwBvvZyI7Awi9RFW
	uVYShfLHbHzqV1w/gJEYl8SeaUqmHcoxhaywsw9C+OVYwD/RgmFif0b8vfocRKToVvY=
X-Gm-Gg: ATEYQzyvXZQLhzAD9B/HyOCK8Vs2VYkO5VnDH9FV00zM3o4mZGcSjYPCHWooTURHbur
	U0Mb6uzOpOfRr3WxUt8q4QiHKa6MqvUzfVLcHyEzj5yfJQ8MKVrqcN7Jc6Z46SFgJnTEB4sTQxL
	UUaEEzg6bxSi3f2/XknpIupZBMy82gR2+Y38i0LPjRKYVDL8bOQOjsikhU4ZVSXp0PFe3buXZIo
	wRR2Za/sSTYXFIxDpGobOq9x3wiedjg9JxqXs2bkQzcUmsH5bRMYUWXxqlrjp07T19wf72IKkBQ
	QdrwRUEMJIkeu9lD9jxn0ImZkMKWiIkA+BFX5wRCOsUjvdBhOiwoDl3Hr05qhwkdBMO/CAg7t9Z
	JqcbJwQ6AoSPlL612wKFXI4PZRU4mK2RrCm/ZM3maPEqz0vsLjZZkLawjZIV6MgREvyHskxbFta
	6EIMv9nVOgF8yRDPG/qIbNSvjIyr3eTf0+BreQSuoNdN8mtW8OpfClJpSmn9Bn4rg2IrpXpzfIj
	hzlNLWAFpDuWkaoHOXC+RgTY9OjCxlj0P+T+AWujQyyIiFYJA==
X-Received: by 2002:a53:b191:0:b0:64e:597a:f5c2 with SMTP id 956f58d0204a3-64e915e80f8mr2412684d50.65.1773843423813;
        Wed, 18 Mar 2026 07:17:03 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64e91be0e91sm1672028d50.15.2026.03.18.07.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 07:17:03 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org
Subject: [PATCH v2 7/8] liveupdate: Remove liveupdate_test_unregister()
Date: Wed, 18 Mar 2026 10:16:45 -0400
Message-ID: <20260318141637.1870220-17-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2549; i=pasha.tatashin@soleen.com;
 h=from:subject; bh=K0BUPL/dwXL3g5pX2ncyNWZVq0YZ4fBzU0LlavaQGd4=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBpurPP1LV3yCAjinWTg6lNdro69Oow89FShnYUd
 5XBSotUvG6JAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCabqzzwAKCRC7dyhM23N6
 3gxdD/kBAcbVuJAln8vuFoiIAN/2+S34O9sqBq1g8GB8w094PpFKGMIVriocJu24Nugz9RgvsJc
 aYXnK4/JiWqX8HH2J3v7lPblg4lHrxQdrU2BwTYV1zsXXgGuWOlN72SPcYr3RnadUL0JWLByL1C
 Z8iQRIPsrIXO3XPVh4ym+36kyAQqYTCqF8rB4jUu4RmQkLYKb7xogSPXz79WeIH8jCAbn01JWd7
 Bu7MkunLbH66XySlw86xMt7m2cjo6OySzpJSSzJQAX7TFoNkYmL1bhs4aWt60/+PXmwOskOI5kL
 s9F07J6nCAkvcksHFljYSlxWWDlXTQS8yonCFone3vpZjwSxtR95odn7coLdP1ZF9QOfnqGiFCq
 SYfhoi3lAnh6o8DCPhHPUvLSqQXIt3riz1iMF8wst4/PHvsPVpll0kJ57yT8FioUNqtBpIpaOCQ
 HLr6SXaOue7bV7NryUZIBgAoLH/gqdAMvN3W9uxG6EvtTQkTHr5TogqT/GXOUpNU729IjQA+B9L
 INIDFx/1WpjBN1njv04RDwITIsilyEcyZoORtbG0TdCPf/qQdwIA/qi7QUopi11DcztF1MippWz
 cIembuzdpPOOKQT/tDjQoPjwzJ+YjK+VMIfo8ow4j1f5C1soH+AlvM1ceVHiAKBnpvDzaepMtQP xXcnPwGm1ALSP7Q==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp; fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EE48880004
X-Stat-Signature: t5szjy1e7wmc3tmdrmz1deiyo3u9cdho
X-HE-Tag: 1773843424-336930
X-HE-Meta: U2FsdGVkX1+snA6btbrYweXVQDQF1ZlBuSOESohB+EhGwMnNMUWlJhXC/xB6HCSdYJuh9+05Rcx9ewkV04dbqV/z6Ic7kKOBQh9uira4BM58hRBXUDzb3DDOF28X+3q3ipsiHj3uxkr2Has9zMQNikphizhh5T6b59fpWLN2hyn2OGG7fxsUWYaRTZcRGfbohfNIyYOjZaSRpdQF5w/I6XJMUe0flx5zcqtkhhpzNCof1HcWFpy8GWjQRrwKlXClcT7NKR+CJSPtoW5l7tX6kLgQaCbkejCdaMXkbfmd8WctE7hhX5PwJB0lm5G6s90bJIZXmp3BPzUXPpt9dAxBM+omdGtvyS8mKamaLL9JfytbQB+fZorbDxOM8uSnW9ATJwleEpW0P5cn4EKUbrLyzU7Y7SOe8BZuR9/PFZ71OR7RuDoWBv8Fc7zV9kQQDxjTZxUMoMQj6N/SeKymVYaF3dcFDB11GVx35narCc/uF/skvjUTy3R+YSrg7NMDbZrbtzh9CYQ/u0/a7VpJc5nzotBVOBI282ol2gTUjsfXEh1/eKrvbuaAiiNGFBqbMEkWL1dPnHcAmx16P6oXnpbm6TDAdhh7cQU0YIr/ZLM8RYTpWYmGwbxWhaaUoYxdPlS6U3CLeb+ePYsr9nXURNEXsL61WIY9Rt/8vXgfljqRK8+JVQx+fGLwfWmHhRMjaL4OHYdy2xv/W2XnUn/omFoaFpdqUm44Ht4KodSntr5Cb++nocZYCdPyllZLToLXpAcxFWKCW1Dj1S9dQ25nHQweZXkf9bfjqKll+MxWK85KcRMqt0PceX1+zBFOOKE1+AF6hdqtF49Q4MtiPbFtAmqIs5XA8hfbRuM7331X92psbPCJfbgMhg42G/91D5DolIWux50Y1uGYabqgMzJt0txQYyNsolVM6uu/WvTsGJAD3MFZia7pDvHyI/n6vYC5uWbbNAD+qhtIDqbSA1z5f16
 4UkfafN0
 QKzC5EAGsc7RLByEbN+xpLqyFi3gf5kXFW+i0AEiqc8SkM8ZiL4i7u4c+sZktroFzP+ltFgmk9LetdpzMbDXzvkhEU4qVAPX/gyCAMQBnzl2fK9wS7eyMha3acPaKGOuJyN3kQ3mnrdkR+xgI+FTj0yyIcZGYMtpHPKNIWlGybT2d3a753roRYlO9/EIqL6z8Hsao26BPXA+txpZz4STTFN4RgtQH1BYrb1yK5ylh4IjVVBxRcIvgQwNpO4D6C3eYZLrPRWp4+eWHEbFdcL4clBTpulZw5s/pwuF6Ij/Cn8Br+js8SOizU4nh7et1AdzalBxCEtr30rGrb9KbJPeDIxSURA5ml0hosU5XPQcsJpM6mIy5PFjTmtOJXPfB5fq+KJLrURiL/tlN+8TSj7g3uIMVhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that file handler unregistration automatically unregisters all
associated file handlers (FLBs), the liveupdate_test_unregister()
function is no longer needed. Remove it along with its usages
and declarations.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c     |  2 --
 kernel/liveupdate/luo_internal.h |  2 --
 lib/tests/liveupdate.c           | 18 ------------------
 3 files changed, 22 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index b9ba1b8dce84..c9c26015020b 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -879,8 +879,6 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
-	liveupdate_test_unregister(fh);
-
 	scoped_guard(rwsem_write, &luo_file_handler_lock) {
 		luo_flb_unregister_all(fh);
 		list_del(&ACCESS_PRIVATE(fh, list));
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 730c3faa7616..137ae317188a 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -108,10 +108,8 @@ void luo_flb_serialize(void);
 
 #ifdef CONFIG_LIVEUPDATE_TEST
 void liveupdate_test_register(struct liveupdate_file_handler *fh);
-void liveupdate_test_unregister(struct liveupdate_file_handler *fh);
 #else
 static inline void liveupdate_test_register(struct liveupdate_file_handler *fh) { }
-static inline void liveupdate_test_unregister(struct liveupdate_file_handler *fh) { }
 #endif
 
 #endif /* _LINUX_LUO_INTERNAL_H */
diff --git a/lib/tests/liveupdate.c b/lib/tests/liveupdate.c
index 496d6ef91a30..e4b0ecbee32f 100644
--- a/lib/tests/liveupdate.c
+++ b/lib/tests/liveupdate.c
@@ -135,24 +135,6 @@ void liveupdate_test_register(struct liveupdate_file_handler *fh)
 		TEST_NFLBS, fh->compatible);
 }
 
-void liveupdate_test_unregister(struct liveupdate_file_handler *fh)
-{
-	int err, i;
-
-	for (i = 0; i < TEST_NFLBS; i++) {
-		struct liveupdate_flb *flb = &test_flbs[i];
-
-		err = liveupdate_unregister_flb(fh, flb);
-		if (err) {
-			pr_err("Failed to unregister %s %pe\n",
-			       flb->compatible, ERR_PTR(err));
-		}
-	}
-
-	pr_info("Unregistered %d FLBs from file handler: [%s]\n",
-		TEST_NFLBS, fh->compatible);
-}
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pasha Tatashin <pasha.tatashin@soleen.com>");
 MODULE_DESCRIPTION("In-kernel test for LUO mechanism");
-- 
2.53.0.851.ga537e3e6e9-goog


