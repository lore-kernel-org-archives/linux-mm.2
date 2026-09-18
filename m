Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26F69C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5926B009E; Fri, 18 Sep 2026 05:11:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2338B6B009F; Fri, 18 Sep 2026 05:11:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F89F6B00A0; Fri, 18 Sep 2026 05:11:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D11046B009E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:11:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4475E805C1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:27 +0000 (UTC)
X-FDA: 85226314614.17.6CEFD56
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7A4A61C000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g1uynj9y;
	spf=pass (imf18.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789722685;
	b=bqLWB0b5Wn/KlZqxnjHd0ozyg/0rsqLd7rh+7SQG59rpInLTU/J/axAzCCnaxZA6S0ad/v
	Z4+yglSfd68u9BBiZFXRW8SC8fbapZtfV2LacMtFm0IwJ94gs1Y++n4+L4XpT9GLPh3ImB
	3CbnEBz9ZF3sE3u0PwwG3/sQ0Lcbi1o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g1uynj9y;
	spf=pass (imf18.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789722685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BcITG13Gvl8i0HA4g724jWVmnWns/ceZ5ECxTEaQlok=;
	b=ofVxjMzPH9///Mk9aD/Vvqbr1c7N3pFSG+EQux8FDl46csSMzfUUwSnPv09yb7XiHnJ8Wg
	H9dQ/f/MhW+cgWchjU1hsqEL/K+7E9cSRI19uqtNLopmEYJjGhXzNQLjAZHolNuY1PvHR+
	R7QEVwfLJ5HfRsM5hMU/dsjXiAnfe/U=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d1ca5b0d6so4009625e9.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789722684; x=1790327484; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BcITG13Gvl8i0HA4g724jWVmnWns/ceZ5ECxTEaQlok=;
        b=g1uynj9yDMzuttQ1cA05a0sElv9r1o1QN5ox50loe4Z1b1RThzSTaPGgrzjkuutaun
         AZWOtgH19r+0sPfdQKQ3Ya9cXAy8SuI1z8SO0MHZm9mS2JYLEHOLzjOF8zXxXMphjl2l
         k+tZS8m/qMl1x/7MxZ/+EBOFOgr91rZJJAAh5to420KP4fE7VR8oI3Z3ISP609Fas1a4
         6cu6f0EDbSuJcMoDcA3w1mATwi7WtFJhBR7058TAll48lRf8K+J69lLW07Xo0s31kUAg
         TQdTNV9PrLRBUpZFWxOV3rAm2d7Ya/1cH5nhYlnxpCb6YQ5t61alqnUC+5nfe7P5wliw
         TF9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789722684; x=1790327484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BcITG13Gvl8i0HA4g724jWVmnWns/ceZ5ECxTEaQlok=;
        b=bvFTs6AqE8c8wt/6YMiiYVRAo549N+aiqPaan4Xs3m8iPqbbLZyxEd4CNmyLnjPlKg
         qnhby2hM6tVEpKvKTHM1sq0TRBC1T9DYJa+MUiKi1rfUqDVUuDzgT+stg4c0wsWULyla
         6tlG9QiXb0Duvm5FOLZI0C6RNF+Y4Rdr47UdpfVtKB7HRVq5MmahgE8hbzviTjck1qyO
         UTswVh63ruhLwVsqRqqRuSrOx+G3wk1ICDs8SM9VUEpZXwBToIMiOD2XZjjUdSMu0nBW
         +JJu6brdyy3uiYUAbvTbt1A0yXLDvZb1IH47IQ+h+ZcUamuc6t2MkbVKkB5gQlb+/cjt
         Zz7g==
X-Forwarded-Encrypted: i=1; AKwUvBynozFRly9zgHbO4Pqk7aCJk2khrTUgkA/rUhhOGiCaUtOdvKgcl21gdtRA/AWAI5zZNc5WI9TEBA==@kvack.org
X-Gm-Message-State: AFuF++mFEMdvU2rmSQTOD3QfhQj0oXVcl7DEcOmCpBnaiYz4yM6q1bO+
	M7iqJe7rHOWH44tlQCy0QYni0AYwJuuhsSRmNhGy3lJ0lGovZn1lOXAy
X-Gm-Gg: AYBFou1sUfIz4zru2fhjgVeE8VH+kZAtKizlFzgt5qHZi8jZf5d9/UPMp9RHmKpJ70x
	B3Ig+YoyS8e98KA7kl9K/lieZtPqPZ4UAy0Yf1IgGFmSFehHyFWMaX1nxyh5aHMU+2wrDYbcB8g
	0GMIhTKTEXbFKEbbgxgN9lcrm99Pc2vYrW6IjOusGN7a7bDoSK03kZgLEnR121ogLmil/Zfnq4O
	FOj/C387z67Zkm6pqWTjZs+TROJCj25oi0tNvKTMbCQI9WsenyCQgSDiygC4HSHrqI5fvDHcz1Z
	/lVZuFVdOZFWPzCcKmj+yYY6jmwaKcXaxIac98lrVipLrrjjr8y0bYlIw5ju4U9yU1YD4HUwQrC
	FrpzsunxH0N8a7MDzEJz4S442FQzOcKLm1aKjBCYJDV0SPEZJzKTdr6baWOcIQju0GURrKD9RlZ
	CKdp9LYz1b7P2jv9BBONtIx1GKqrZ2YC9pwMry5pc6X/w7nINacE21zJFWB+JRdrZPu0OT5G3ix
	Zhq9K9pyX1Fzmo=
X-Received: by 2002:a05:600c:468c:b0:49d:16df:8521 with SMTP id 5b1f17b1804b1-49fc56811dcmr23639585e9.4.1789722683646;
        Fri, 18 Sep 2026 02:11:23 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd1d0978sm138774275e9.2.2026.09.18.02.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 02:11:23 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	ljs@kernel.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v8 2/5] exec: Clear bprm->mm before dropping its reference
Date: Fri, 18 Sep 2026 12:10:55 +0300
Message-ID: <20260918091058.297740-3-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918091058.297740-1-tasos.papagiannnis@gmail.com>
References: <20260918091058.297740-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7A4A61C000B
X-Stat-Signature: w3aq9ngtspkom4wqf3yuhja5m5h6h1qp
X-HE-Tag: 1789722685-77852
X-HE-Meta: U2FsdGVkX19GBe4ThKq4wYusqaxRyky+gMTblsoS6xaA9Ez+r3JEvK42nJnXTp0GmsnZYmmpOQCBjf5PiI/JnTnCzK8u8nRAE9LEvg6z8iJ1N081h0clFkw2XTubJ9lM4m+Tw5NLSnicqpIom8UpXLzjl3MtSnJk0Q/QAi5qKt/1ycz4t3mOkGAdAcIfI2pcvm1TUrPBWUjC5PJg4qxI9/8t58EWdHm4wBjil4Qy6zkPd5IAut5A0eoj1JLSp/n0tQUkbZcS0XtD2bN7rfbWuKCsCNhmSownXL7x9o/Z/Bx/wpZ6peZv0TM/Hc5Y6mCwDpYQm4vPsDWLTZNHbVuZlz7pRU1R5Jhk4fGzm6hlX6h6oxfop/QaqQS5DhvCgjnaR7OiVZlu6P212AXYgWrojWiZbRU236lZ/PpEJpC6Wu3RKNvOao5yzxra8rq10vxdgtmWOR9PbcQMeULBlMfD4T4jOWMK/EoMFrNGHPNibd6BIdicxGRq/0+orpygvnrQN0QGkOIPuZGBFUwnYa6ag+pDObsDGZFb0eK/oFZ9iOoSDAr++yANvGW93Eqb+7Zxn9H2HHK06HqsdmxQJsfDkc301LdmhRRDXPEZiH4QphKjqjtdDZRU57D9FkOhK72h3FwP+i6Y9lCpnxLVoxU6EwK31oikKtpPHHnJrukLPmtkIBAT4lLOBFJgNjSUTy8RGXeAfxAqBRaXt3/tryDuVbJ/DNoIF7CoGc6UrHnEm86USU4bKpoa3+dfW93q28lwEHmkDsIYAO9Tx2OtaMo37qt8zRVa8Hnj8LpmyBJPmE4g9iRgDvl/PHlSSc6iyd9K4OElt00Bc2+jupi2BVKC+YRdvJ/EnwI9Ga/3sWHv9JFTzFzVfix2a9ScG2Xt9uxNiEC0ibruflUmbbDcrSSJcww3iBK2S257Ty4pVG9cY9J7Gl/sPQDSsIo+Xdj7RIJyaNOBmH4on2ahowvTINV
 +CvCi9vx
 we3rIaEuR0tCAx2a+eSbVZlKvEx/ldKQxabq8Uy0AhDc14Sa3kE1yBemofc7IgcFOLmxFioFwEgSrkjDuKPrazj1tHuTxnKtl+H26v8a+A8Sej/fu0HIT/6kYDmoU2BQYAOB8jsmE4qnXnypkW9gXa4R0EtO+Dqhd4UgKmVg1X+GN0n9fk+uDjzQ5hP/lUUrA1BvCivAQhfMTzOsgZrdIy22v5zPY5Tg6z848bGD3TAR+OFAx4XPbrYqcNLCes2TUx2hsTLV/l9vpKFjoui2HBEmxaOd3UBCcCK0zC3C1zZOowlffrbiol9dS9wwdI8aVqiq5Am8bJUqicS9byYC01ya8zRzvZrHMJLh4okPrdA7yAFHPXjp6tf6gjsmyu81JzA5UjNo2Aq1Qqv6XfXkebgvnKYoDXuU5RFfLeFB4Tm748EonAtETJQX3kZVjPikkDNgF+Yq1Gr6KwqaigIzicBGPwg+77llXfmXpnxluaBGzsautiCiVVkCPSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once mmput() drops the final reference to bprm->mm, the pointer must no
longer remain accessible through struct linux_binprm.

The successful exec path and the bprm initialization error path already
clear bprm->mm when ownership is transferred or released. Do the same in
free_bprm() before calling mmput().

This is required for BPF kfuncs where bprm->mm is either NULL or points
to a live mm_struct to ensure safe access.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>
---
 fs/exec.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 745f6eb5279e..4ddd403fd91c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1456,9 +1456,12 @@ void bprm_drop_loader(struct linux_binprm *bprm)
 
 static void free_bprm(struct linux_binprm *bprm)
 {
-	if (bprm->mm) {
+	struct mm_struct *mm = bprm->mm;
+
+	if (mm) {
 		acct_arg_size(bprm, 0);
-		mmput(bprm->mm);
+		bprm->mm = NULL;
+		mmput(mm);
 	}
 	if (bprm->user_ns)
 		put_user_ns(bprm->user_ns);
-- 
2.55.0


