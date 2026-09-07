Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCB45C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C430C6B00AB; Mon,  7 Sep 2026 12:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A356B00AC; Mon,  7 Sep 2026 12:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B30306B00AD; Mon,  7 Sep 2026 12:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8340D6B00AB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05D91801F9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:53:02 +0000 (UTC)
X-FDA: 85187561004.27.3A6417B
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3AFCF180005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:53:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FUhikPww;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799980;
	b=YZ993oAiix/LO3v5R06cJe5SH9N/JVPVEk/AeeetUYWZjAWV0c+d3BoN0Fx4VKvs3ySlS8
	iCApXsti+C4ywpMqpibzUObfCDTSsbE5ErJzBFdw2gGXEt+W+i3e9RyL8vfN6HPft7K1qg
	17EBfjoBN3SyYQyNRg8Tg2hs9+7Q0Zs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FUhikPww;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BcITG13Gvl8i0HA4g724jWVmnWns/ceZ5ECxTEaQlok=;
	b=FmFktuvfKx/Xdu2sVXzCR0r4WjiDh0aP7pvKbXYckUIefNweJtndpUltIopdPSoW7cdamz
	TPLl/jMlfLy93s3oWgbouIf8Duu/XAlXR/5hJS49+vOEF8F0Jwqb3I6DU2KD7lIvFUZP35
	jbSExQIoYjBTFcTkskPFoXry1xLDhVU=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48436251906so4294670f8f.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 09:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788799978; x=1789404778; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BcITG13Gvl8i0HA4g724jWVmnWns/ceZ5ECxTEaQlok=;
        b=FUhikPwwzBwOkuE2qz7KS65wMvLPk3eFuWmIWQySnVLbFwoFHCQn2hx8eX1hXYPc2+
         Ni2OPdsfOG4k+DVZMpUo8+Xv5fBMA2Hz73Mv5jdG4VpjMvbX5li+B1kHPo1qE3e8mBZD
         kNqvHNKjWhPnHicAAnI11ERUog435JE15NgcD7x+G+9klz6WXo6JxlSIc/L9s5AOh8eP
         C5rQnz/pLYyAJzwHs0rmWJmD0i9BKNnRdUp7iRs/HeCGh7e138ZoOdPWhENZDgnzk+l2
         DP2Nx/ejPPL0ihD14ZaRjgw3tyYHzEBGUOmn5w3sW1wASvZ8BR/gCVS6ICpiOY8z/eB2
         1gXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788799978; x=1789404778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BcITG13Gvl8i0HA4g724jWVmnWns/ceZ5ECxTEaQlok=;
        b=lkrFs1FpJnq7Vs8iEhh3jmd1Ja42PZC+LNIwTsQMHe2H5KFl6lqphmZNKUNKngUg8n
         +0cvGb2d5WueRLzY3J0zrLD3hwtuQvwxEzEnHDBOE7iYx0obZJP5A/MozIHqTtyL1iX8
         vflb21WXXupdo2U8A1TCsvT+HHO7rtwRIXwIURp+0xiVVz+ebV1tsn2xx3MSlwmm6wYp
         KSQ9TNn3OXW0iSrsXM8VMOw1v2rDemwl5xBP7Ll8EC4+0dfdeYyJxt9QmBLOpc/KdYT2
         Ec5Qu4/jFOQacjAVgfWqfXKUdnRMl2GGw6moUl7avUxtoN7AW8hIYWYHwLwVoaPAa8PJ
         o5fA==
X-Forwarded-Encrypted: i=1; AKwUvBxADkEn9qu+qi1Tbj6LBrHMqADlpfbsC65e3nUiLFjxe2u0qYxo9sw8Fv+JbiXmlx/lHlr5P+DMTQ==@kvack.org
X-Gm-Message-State: AFuF++mX8jk1ggYF+n3xFDXpTcyGAUnqBuHwuUjxT2xa+vp8oPmSXn0H
	dtO9HsByQ2vnWJO1xaHlKzyKln1skYHxguAHcmZuIKrF3HtsfOhuMiDT
X-Gm-Gg: AYBFou0kOeot1p+GNNp8hGA5EecfWwc09i7V0As5nd5nmBhDdDmrFVDikgI3LNViyQe
	9gkqc40lKzYuv9evW7uJ6kUCbQC2W6tTu2Sjol9EL3nIqRZkV7hLSFI3Ot4nXAhdwr5WkGZ33kI
	YeGv5eSDGHqm2OpvsfLG+i4nF/xOlVzdLtKm8Q8oK4hgXbna4H0dc0ou6qEneUPFIv2aCwu3m3R
	AfiMYrHf36brmbVJLjWZFvIOEBxAAVrKyrmcj0cEKoVsfclGwcAHGE2H98xhIMwFRUjRx6A+AYa
	x8t4gDYjX8ohIgoySAiN3gf+dFJhhJ37yMBj6Somv6ecFvPtxyx2ltbhyG6bwjKt2PcTnUJoiHg
	xvMilXtscmw8JHcu1nWg19tmd/BmqNSeEB9vMIwIIYDz7KXOrIpZ+OYHLWtFSFSfA0VDNLTschH
	zbkylldVnrSdEnKrYsK2s2Fa9YHhro5GCaMWawI6Npfdc9BTaBWS9P+7gf9tqEb1aOnGN+5XoAt
	Q==
X-Received: by 2002:a05:600c:8b6d:b0:499:a277:e8b5 with SMTP id 5b1f17b1804b1-49cf7fdd67emr472395245e9.3.1788799978274;
        Mon, 07 Sep 2026 09:52:58 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d03543064sm233022415e9.13.2026.09.07.09.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 09:52:57 -0700 (PDT)
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
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: [PATCH bpf-next v5 2/7] exec: Clear bprm->mm before dropping its reference
Date: Mon,  7 Sep 2026 19:52:15 +0300
Message-ID: <20260907165220.52431-3-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
References: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: h9swwhpfr6n5aaaeakatjjcxh5zyg84h
X-Rspamd-Queue-Id: 3AFCF180005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788799980-14289
X-HE-Meta: U2FsdGVkX1/R1MU8fVaEmRi00MyqIbyJ705hiWEZ+J763nLco9KrkHAnfUJmQI6FpCRbM7gTm8UDYCQJstp452cqgYkEPmQWrYYS6AapULgT/rhRYT66APv1vFjiLkPVlrFJt/lhivHo1qqROXnVpg+WmzwW+wHXUnQ5FeG4wXFTy/IQfu/tL5nPW8y2z1KWOfskcG2hH+WdgQfXCYfQPZPPtQg7mdFZsqSoKA9yygme/VQTkOV0qCdAbQ+8es+AzgGGK0z42cCIgrIhbSBkKX9VEqeACY5BHU51yG3M0tHSTm3T2IXinXK/PE7o6VrGBOT0T5UHDtBKhF92UFl+JzhJZm6UbBoAcq92R89nMZsMh7oqBZ1tN4ZNq8jFF3CUiMa89UNkeDBYNqMS31saAsCjXF5wAUddtrfKCwyigz2tkAWxlYL4egKhdOtJFdC/5Yrh+9alODKSgVJzG7vTCCk6a7L8VW3wnSbKAJsoLPKbcvAA9SeOUujWy9piKRurqMQuPAKBVVNwXKYiFJChA1Uf9xGGrvQ88LZcWZuqgL7k3c0VJdgzcfa97pOeoXQt0Kz6RNzd43lZ5+UteszFuRPifp8pFEMDtPqlhsiVwhXhPGPkh6dj07BUxgwRtvF7qXkUP0czM8DiGCd7Hf2UuibhSXrsBYB/x0ZO3s6NLtGQoKxcaLjMvgh5kUgVe8Kmhj3AGnfVKq6qzK0M8bM3KnWBp2GKL11fjSz8HbRQSRUfS0gtaZDTz5C4vutO2okSU4yvEx5OZum69KwCnEgewpIAZcfRA6WEENHMAoeEtrb53NanWKPpUMNIXwIuPVjrOLF8ts3EVJfDW72U6tubdusCPgts8TLpWFlrccnxsFvD5fhkLGdeW2trjHqSmWWH8v0yeXXEVX7kWWOTrFTwBD+0IsDiZvrw2ZSHsU71oJzXLT4crr8z8m7803LGGsG9JZrQEInTZtlYvrnid+4
 HfKNlxDN
 okATmXkObtPUwVzu39G2IF5H2o3iQeAMUYwx+YlIimWWraLVmw5bZn1OwA5zBbWcB3I8415ZURvSlB8euVefVMxaMeIoG7NBoPZ52fi24kaBycfwhOWEEL/Rd4dcghRWNGqvM9jIM2O6L2UJeBbgBrGnxnyE7zUh3mxMrzgczh6cRRaa+L/kxF2/DKrlkQETGvTE/caKa/o9XyGyReHZG/mPGqtJG04i4efX79KybwoJ7/qYQkcTGOgBzX8PW8xWEJTHNqpI7S2PV3UkjNog5M7G5RU+ih3bum80hI3xWYoeh8tzd2u2pjUKe+FTJ564xx6URIbNpYsDR3RgFVZ4xz3/4sfgfnrKuygoiaUMLd7kgbcwzyG9Z9adSH1qtKHhpF82I+nGm+7FLcsLqjvN8PcKSsZUhsaTOd+OHA7BxKo0wWCALnwYnGfUf1ida0X0eONeqjfJQOGRhp6o0NmKWPg0Q/5Ep0Idc5FGlkY/fqV0MpKq7SRKav832rg==
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


