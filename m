Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 595EAFC72AD
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 05:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397FC6B0092; Sun, 22 Mar 2026 01:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347D36B0095; Sun, 22 Mar 2026 01:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B316B0092; Sun, 22 Mar 2026 01:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0CEA6B0092
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 01:43:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE90D1E4FA
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 05:43:22 +0000 (UTC)
X-FDA: 84572606244.24.7A1A364
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf06.hostedemail.com (Postfix) with ESMTP id E961D180007
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 05:43:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eCjLXYXx;
	spf=pass (imf06.hostedemail.com: domain of 3d4G_aQYKCMwAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3d4G_aQYKCMwAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774158201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvTHfHDaEeYEd5IaJalf0yvJB887/iPHMmYQM447rIU=;
	b=XDABzILbywQR9pxH/WSruQ06sA7E4ris6moQB7bZBnwaPN7RU90gtIHjF4pA1hN8jpa3EK
	5nFPKHePbAploDfEiP9kPLsdFM8bFkb2jyjOu4V2BhxaMg/fsIck4vIymXYf4AO69ajaf2
	zE+rff0PNZ4T1YhkwvM/j0ZU1LLe4ec=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eCjLXYXx;
	spf=pass (imf06.hostedemail.com: domain of 3d4G_aQYKCMwAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3d4G_aQYKCMwAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774158201; a=rsa-sha256;
	cv=none;
	b=ksPSc4bJBbjdjbpbLJ8eAu0ugNWpsnrRnVaTRc2kZJsgEgZTBH5qRZbZu5cIOliB19AFRt
	zPEeq3cT9DknWBVhgM9k+XgJM4RgQpqnu83wgCdbpqS84qL+UO0y6N9cUnB+rUe7V/LtJG
	zOAAOAZokdwxMa2vdK8MohXRjcY86rc=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2c1030ca85eso6377830eec.0
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 22:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774158199; x=1774762999; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GvTHfHDaEeYEd5IaJalf0yvJB887/iPHMmYQM447rIU=;
        b=eCjLXYXxB0ZqHPuO99PnCgQeC53cbSp7mDPGxeNU5Rvvkf8oXZYXLC5+fJDRpwedqG
         2UgMX3GDpUfDgfkggcLeyPaTRY9X+yNe1GK9N64JIvg681XfAIqzphgOBjdtm5icsdMv
         Zmx9OtRKkLZPApK/rT6Hhp7jh0c+0C4glSYNaTR2s/Giy5rtNHis8brdIPz1w1fd5bID
         piQIHzD5J/Zj7G9e/VFWSnzkwqRm3dVLLkaoG7xBjnB2jAyrAilyhbtuHxXK8BtCNxcn
         oJ+00Ck+GbmUOkTGSK/e/HWBUsXmrAmHQlgquYMze4BfWM+VFRwe6fh8dJN2YJ2sUtAb
         SCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774158199; x=1774762999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GvTHfHDaEeYEd5IaJalf0yvJB887/iPHMmYQM447rIU=;
        b=UtFmH9ElLaykNDCCAl2UVU3fldQaE70bqxqOciwtC2tB3Job0Ag7vLF3/Cf36cSm/k
         dtZfQztl/CtVqg38SlhBDgxPhzPpl8d4mHxDiYf627Q0oKNvPY9qo5ZqqtW4fQPeTroW
         bFvbcPKQuJsM/nyQRdCPCQPXoc0V5/3E4zgGJWyBl3UhtBpW6C4DVWvsewdh221fY5Mh
         NRGFEa/bM2Av1lvQDFiq5GRdGIuiwjuVlASJWKXrdLJ/AgAaUuXhm6EnBdht8AMPFaKf
         pPk0sRcE8YB2o5lE7Yi84qGUBKctErCnR1zo0GZokzhRGsh6O6GGOIfZ3tbY9FBmOodm
         KRLA==
X-Forwarded-Encrypted: i=1; AJvYcCXYBltQZtHctMDmHGo22bh1xQGMFKMWmqDbvSh3a/MBzJGT50p8Y9fgffMG1LVf91OwOt6i+Q309w==@kvack.org
X-Gm-Message-State: AOJu0Yz0rt37le66W9zAF0586nXVu2BKIp8/H0QbHNKQpbqXEYGf5RbN
	/WcD+pZap+yf9mQqs2SSrp2wIQLzt+HXqirXbYBbVtBiUu2uB7OviQB5GWy/22Sq/XWuo0P9h/k
	FARwiiQ==
X-Received: from dlbvg27.prod.google.com ([2002:a05:7022:7f1b:b0:128:d754:39d])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:41a8:b0:127:33e0:ea33
 with SMTP id a92af1059eb24-12a726b3177mr4054533c88.22.1774158199330; Sat, 21
 Mar 2026 22:43:19 -0700 (PDT)
Date: Sat, 21 Mar 2026 22:43:07 -0700
In-Reply-To: <20260322054309.898214-1-surenb@google.com>
Mime-Version: 1.0
References: <20260322054309.898214-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260322054309.898214-4-surenb@google.com>
Subject: [PATCH v4 3/4] KVM: s390: avoid kvm_s390_handle_pv() error overwrite
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: E961D180007
X-Rspamd-Server: rspam08
X-Stat-Signature: p3x3mp1xc8qryntqi9ytrhcub198dtj8
X-HE-Tag: 1774158200-294445
X-HE-Meta: U2FsdGVkX1+44I4aXTPUzdRerI+HrMVFQwZgMgRXzbJriaBYVL5dw7u2uV4QvGhx4gGcJNMRPwev/FDv7jTTeN/5/I106johIEkSXTy+15YzYjv3jXLGF5IXm0HEDmMGCoIVWL8Dirc2zV8NUSK8dncnIH3k5QXq1yjUF9Jfiz0cijrSbBbAODfj8Iiy5FXsUjz/PUaveDsGKs34mnLVvFn9mJ0iHJ4ZxQXHAv6q+DdSLWlS3Hm8knpDctVZDJuODIAafaHd4LHgLamj5wVUY06wZ6TFhk7Q/g00Koiu6SUG2j9Alv26DN7boRB9WpzxJs3/JALPP1wwTJHvcI/KWUMsXfcX5LhVa1C4hHvRjDngZxHqleavKRpeqahbmEnnu5bEGhWa6TRLH3H7GaM9ZUcuD4r6WL1SYUOsxcAlEfFuQxFSrLiJChWXIJy8YSd6lsZ3aVbbs6WVLfGz6k7Vb0r8karn+tBqQKPVMMVrticcKv5o++MTcME4dsv6ooSDuIVTDaHa5DEoKBTHtnIxw5hV85v9gJw+WU717jLeFr7EQCXtakHQXUhNBUrEVgXUui5e8vCVv8KNx/tzpJ1nsUK/LDQQPwS5pSjKluBqLUsgP5mirey1VNy4xgArSToZ7tJdukTd9wB8Q5Cwbru9GYQ5ObKbBECUvIUlTmEJnvaYgQ9PSN0gm6J8/jQooQfQ4bvfmhxWj1paKDkpe6ZJzLeHhH5rEUlt2YJC5SdOG4W2wVEM8NBnOJJ9+/tVWfg7Yhlo3yfmBTpksZB7RfuWWkp624pU3Fokvr+5ztVLqA14Yz+7YY3U1kzC1HajCIR4hstRvbdQh6u4zY2Q4Ht96L2oqorvNmDAGfYXT8z7lkmwcCPrLhJzBNH+9S6gHVBz4lthjNAy9L6rhDu9dtdyBkyLIUjD1cpyp0QuYll6K7hHS5RZG67J9wjSyO7aAh8YcMz5d5nnh2i6LDYTBGA
 X1JHj/IQ
 KcrrC2TFTXcLXlY3DuzlEFzG3fmsrYEq0qYglLpd+XrycqFMyzT6NK6lw6Zhfdd0m4WULkY4T8kE6uU59EBM4zdzET4LwN4xaRrxk4TUcRlAat8kirXzj49NyqQwOA1e08vXudDx+Jt/9sMmjD2+r+stivolIzpGw4YzO6G11YwLZChHhkGqBO6BHW2CzcUpDXuKq4j3wRQcjEqz1M4BvTQbHgxVPUSX1Xs6+wD775XNN1YER1vpL9pkRwknAACHI5UmMp7ZegFAI7h3ZzVJL1JzTl8fLniC4HRVC5gdW/+5IhdAX9h3PWlDGs68wR6yAIkrKFVYYb8WW4kPDWZ8yiiemHOlp6v1RCTWV9f+/GfAX2UK4xnAIQHukKg7Mmm0GYNPOojymRyiRJPY1oH/y69MOHl0sJTth4xrqTQnhOlanlF691O24Da+piK7iMgV7A9HQOlovYw5mSPVubW7XWY5/622+8HUGw4MD308J9JS0AvNs6M2zlolu6kp1OmDL2Lq71Dg1Qrmu1EHzBywJm41Q7dUGz350Wq10pvhqoU/iXOyCyOAhQeDfvVedpSCecOjotwNuOet5ObzzTaqwv3QMeLYJsS3wC/xpCP6nBhMoopLTdU22zzV/MYnMOElcNgb9u5pU0Zm3aXA0XA18GgdI9gzImjxJ5QrqvgG+dCMp9dYJN7zO4KarbOGRYZQ57lPH4La9dUMM6PAinN8a1eGM0FxdEatSD4b7JgNjAlSX0t11Pbc38jLwsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If kvm_s390_handle_pv() call fails its error code gets recorded but
execution proceeds as if the call was successful. If the next call to
copy_to_user() fails then the original error is overwritten.
The follow-up patch adds fatal signal checks during VMA walk, which
makes it possible for kvm_s390_handle_pv() to return EINTR error.
Without this fix any error including EINTR can be overwritten and
original error will be lost.

Change error handling for kvm_s390_handle_pv() to alter normal flow
once failure happens. This is consistent with how kvm_arch_vm_ioctl
handles errors for other ioctl commands.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 arch/s390/kvm/kvm-s390.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 3eb60aa932ec..ddad08c0926f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2947,6 +2947,8 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		}
 		/* must be called without kvm->lock */
 		r = kvm_s390_handle_pv(kvm, &args);
+		if (r)
+			break;
 		if (copy_to_user(argp, &args, sizeof(args))) {
 			r = -EFAULT;
 			break;
-- 
2.53.0.1018.g2bb0e51243-goog


