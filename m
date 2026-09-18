Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A507C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700836B008A; Fri, 18 Sep 2026 09:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7926B008C; Fri, 18 Sep 2026 09:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615406B0092; Fri, 18 Sep 2026 09:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 441106B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:13:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7A43A068F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:13:34 +0000 (UTC)
X-FDA: 85226924748.18.E0678DC
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0BAC31A0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:13:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dmSn1jec;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of karthiproffesional@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=karthiproffesional@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789737213;
	b=jGjTgTdt77mhp5S/UJ9GA+JCavoFJ/YdI+PwCOCOHzJzBOW8sc8785CxVUQMm2tzcjIaPv
	tHubnU+q6Gk2DaDGlcp2O04T5Qyw5eFcbCWh0r6mqOl2u9w30R8L0rbmJIKpFpT3A+aukZ
	REoYs3b/N/R0q/F9CAd/o+yaGKvHA8s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dmSn1jec;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of karthiproffesional@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=karthiproffesional@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789737213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QqKItCu17DpUKMJJO4kJKCuEQNfwXM7mJRhT2VHmkuE=;
	b=X8mO9H2cWOgcdBbzs7eMd3aJ0Yx2zd2VcSdzGG4brfHFzHVrburTgZu68hwAw8a4vW3cd9
	Q586aICpHJJonmFP5UgVtZxFcLI71+iHGH3CtZXuJSR3SCcAlQuZUPjGijYSJzEQkK7UfO
	5EaAhOIQlRTprEEvN4KnJJ3K59rothE=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-39b2ad83dc6so636870a91.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789737212; x=1790342012; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QqKItCu17DpUKMJJO4kJKCuEQNfwXM7mJRhT2VHmkuE=;
        b=dmSn1jec/2kKHUGNbJp69wVHTCo9bSS5+PTldn6xTMJ2D9f5fPStMIKxYSifnedd2Y
         ce1EHTlzZqKe8bQ7GFTx7mYDqiltms5zv4IkJzmtRXYQni4lbWrjjmusuzt+Ds32CGqd
         wuSK9f8AZ4CEq05EDF4l2GuAw7cB130iU5njczi7CWGj5ScA1crc5ZSMgWuC6B5T9q4C
         pOWhwTnV81EZL2GEmRsk4Ov+9VZDf6+z7RQnKExFLmRGytoUxR/ce+hlCTDS/kA39tG9
         1jFF9YeGIiXOEfaLlWEbWkCcZJ3epo+LpGCic9rmPpxE4pV/73KFyWNhV2lzuRdEfKbZ
         wPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789737212; x=1790342012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QqKItCu17DpUKMJJO4kJKCuEQNfwXM7mJRhT2VHmkuE=;
        b=cU2mqST279rZ1aWQPf1ixolJ8V/3qH2hkiZNEFOUytdjg47acT2es2+poztT1PmY7+
         nGQN1Rh6jsAL4QaslSVAsVJIHpRFtbSMCkuMhSf0QT70cqyl08Hsw4wIhO8MVpMaqcf4
         vCtOiuB/YD0Fp5Pk4opZsnyZcpUd4aSeAchJ9byCZsFfhk7Hggo9Vsdr3sABn4Q1M0D8
         UJZRAlZHlX+Vy40o70GaUg3EJtehURd6GzQ/4WDpi/aNHaySaTSUipMxvPpVPeAF8sfU
         cEpxbjEFyEB4mO7+e/4Rg0xxnur0pRGic4srm2EhS14TbWhoa0JblcFrqnLo0A6LPa95
         34XA==
X-Forwarded-Encrypted: i=1; AKwUvBx4oVnJJb3DzjSFahAs4En8ZKIaqtxL+5cLc2C2M2bnBTXelW9UJ3Re4y58G/q28nAyuHGyL4G+pg==@kvack.org
X-Gm-Message-State: AFuF++mJdsLwcWdUVi0zQmbf5ymr1p3lbR6xTzM++zsEIbFn6/FhbwyL
	lwhnju/nGNYcjZwcTyUhM12BEn5O5TY7fse71qyvJBnZHal11OCotdzz
X-Gm-Gg: AYBFou0pDB8ZZ5nkRaKenmylFYJPWIDE+nVc6GGv8Cp4RFRqYhRHR5bSyfp7TljnFDs
	FKKms+LkEjH+TN1wN8J+eED9VlzdAEf42qRCfu5wYsQ+opbET4nfTPEEa3qCR/K8Cq2XUZTe8jX
	8Kiuw1rTyMjuMYJexMo8Tj0LiJQyY0bSx95AWq2DpgisXQZng1npB3fpzZjevHMyqvX9JM8dbj4
	8daJciKcxTdaAXh4HpxvuKSVudklL/Waz30ctQWYkNTr653sMYkzquaiBbAUM9THDK/Jp9yq3gG
	ruAnfhRNmoxhstEldLW7RxV14+ZehUnrkX2qRTbhSemjZGRmYr4O0LOWZMV/DBnJ3jasfkyUHl7
	lWulXSHEPWfDxenM2h3k1mf3eqqzhWI/LbLVoASHAEwpfWq3pzwJ6lmVvG2ctJBwdo415vs/Vz5
	2cB8eQGWF+gWikrXsXov6HZkPsklrok4cFTqy5K+IS77WL2SbRvITdEgkdlRjp17YI+baOZOpcB
	3fcGTxaFRE25EnYQbbUImrDhw64PWbm3t+izVN+ZbhtwANU+XPjW8A+gKBRqcMqc+VpG05NEknQ
	98GzQbzJAs8MtBzn7HvsPpzFmG8tjaepzWVl6z7ygVlh15TRB9J6AAIB
X-Received: by 2002:a17:90b:574e:b0:39e:1fb6:9659 with SMTP id 98e67ed59e1d1-39e54f0772fmr6160682a91.22.1789737211777;
        Fri, 18 Sep 2026 06:13:31 -0700 (PDT)
Received: from LAPTOP-97G9G880.domain.name ([106.222.202.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e5a50cd09sm3259882a91.7.2026.09.18.06.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 06:13:31 -0700 (PDT)
From: Karthikeyan KS <karthiproffesional@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Karthikeyan KS <karthiproffesional@gmail.com>
Subject: [PATCH v2] mm/damon: document that a zero sample_interval is accepted
Date: Fri, 18 Sep 2026 13:13:01 +0000
Message-ID: <20260918131301.75879-1-karthiproffesional@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918023859.13556-1-sj@kernel.org>
References: <20260918023859.13556-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0BAC31A0002
X-Stat-Signature: h76uxuqzy1t4jgebkypy89su1g87bd3h
X-HE-Tag: 1789737212-750271
X-HE-Meta: U2FsdGVkX18PpnDrdakJROq3w8K7dWgVww6bU5zzopSJKfrnnXGZmcM00R6rymMilaDVVDneb0w7Od4oNvfc72ebt8vt3mbuquygdte58PQvBjvVpTXcam//aszRarFNBZ1uy6HDF7H+a6g6bP+exkYPHfqUD+cWI9qNfleXdhUYS2rhZpnAYT4ndXNNTu/2dkf5GxLX325bG1nWmeez3Nnbny0fzqKzKz06HF5UCZXenpGJ7ZvWDD+CwFLaQm+dLIxkAXknIMrhnKgb8ejJw59jPk8+2dxtjHGp9rifhxSH1RfYPZFnmMau0A8ypnmWN6IuBm5Jyg897XI7utokXnnUB6DpIcHXtR3s6O/ZJyp5r8Y8/xqEzaH3Fh/J1Y7ZIrJJPLMlrNmw6bhWO1x6Gw/5/+L0i1rvA5ni52cW4U6s1LHPLjmDOxyboi0Mdty7ugR0yKvlM58e0VpAhDMtiHDq/NGhEh+sLWeudsP3MNTIxS4aeT/u+8sHqa/IPgZiLlrwryjPR+Ses52udJJ/GiUoBRIp0uc28QKUpbUUZhuAK60m2ZUlAx0pyz/GjxxiPTKUM3zrqJa8nF2KxOTttmECfV2cSRWapqWRGmHPIbD29EhDVMnqT8u6eHozY1i2QfCA3VBVMyPy1ZmNacskI0MfcRm5PpMVHK7TP5RCaqgPe5TH0G31P9uhJX8yeVFwhc5tJlUrMh3xwP6HeJFLb8A96ZlI5mbVZq4I9S+CovAuRguKDa4rbcdfkgdR4XXWYrbk+w58Fe7hdKhSW+3l7DZ5jQwgBp3rn9YkU+T5Mo9HxZ5ypoopl2ShGMUeilhFZaSU3BedUfF3BXe8nOfEVBCp1i9xns0TLP+YeagNReYHnp4tTQB10/+HJukKUq9Ij7ZTZN7xkgXvMK57U1rYvu7YTeGAe2/SFWXl8vyVQHT5MiH2o1GQYFbvm+dNnkcDsCWp42bhEvmQh1wjCBv
 txlwg5n7
 YM0mmXhOcdy0boSJ7kbiIqTNCfil6Y2RBZxtwwsyFKe6wVS4bddmrDvkQ3PIZmHAiaz7x3r4nAU5CWMILKHIRO9WBoH6Xhc8IIBBdorRBL8LPJFNBs8Beibc6xCnhvPa1G+uA0pcsJcJPANV19TAtq01LHOajF3yrlJPf/F8G1DeDxY7SCO16U8drTXhnw6LIhEIZIFaYRJDO+9Uk+Sx9J8xMI227l2o1q6J/5OcMYxvkK94OqyYYtBT7MYZehTJas22Nm1/o+0+aA3m6K0MpD/o+wb0yMPl0jB1RnJ+Q2tiNS3+fMYNCk7GG2CUF0msTcGwHDn/UW/TW6aeEt0sFvA+d7KyeSgaOKuk58rnjSpJRAO9iCFCilIYt0FJxy6VVwtetzeZeBmqOFOfvPJdxUGV5x/m0uS53rKYb4uSz+n/FtZy310l/SLqxibNdeUvmhnvj8BRoI91Vlk8D/hhx1Pidl+skGHnNJ/C3+8opA+/6BW6N+5CQMV3tSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_attrs() accepts sample_interval == 0.  This was reported as
a bug in v1 of this patch (rejecting it in damon_set_attrs()).  A
similar patch was already declined for the same reason: a zero
interval is intentionally supported [1].

Document the behavior instead of changing it.

[1] https://lore.kernel.org/all/20260722094304.3132750-1-dayou5941@163.com/

Signed-off-by: Karthikeyan KS <karthiproffesional@gmail.com>
---

Hi SJ,

> I'd prefer adding a comment saying zero sampling interval is
> accepted.  I think damon_attr kernel-doc comment is a good place
> for adding that.

Adding comments instead of code changes.  Let me know if you'd
rather the wording live somewhere else, or be phrased differently.

Changes from v1:
- Dropped the damon_set_attrs() rejection and the KUnit cases that
  tested it.
- Added a kernel-doc note on struct damon_attrs's @sample_interval
  instead.

Thanks,
Karthikeyan KS

 include/linux/damon.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 0c8b7ddef9ab..1a7ef416ec46 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -787,7 +787,8 @@ struct damon_probe {
 /**
  * struct damon_attrs - Monitoring attributes for accuracy/overhead control.
  *
- * @sample_interval:		The time between access samplings.
+ * @sample_interval:		The time between access samplings.  Zero is
+ *				accepted.
  * @aggr_interval:		The time between monitor results aggregations.
  * @ops_update_interval:	The time between monitoring operations updates.
  * @intervals_goal:		Intervals auto-tuning goal.
-- 
2.34.1

