Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BEB7D12691
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06C916B000C; Wed,  3 Dec 2025 04:29:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044536B0095; Wed,  3 Dec 2025 04:29:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4EDE6B0096; Wed,  3 Dec 2025 04:29:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D2C4F6B000C
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:29:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A81FCC042E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:29:06 +0000 (UTC)
X-FDA: 84177635892.13.A825793
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id C7CBF1C0013
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:29:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BosBoc/N";
	spf=pass (imf20.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764754144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ighOjyvrf0/Zx4X8xYQ5PxpLMHcY6lBYspK5VjpofZs=;
	b=10A39PynUxGoJfck4CgqCjnGqGr9pbG6+FgNoBfvvi5G++qVzbSMMfD0bJlwwpYoJ14M+X
	RlFXLumS5Sm06NwgoSrF1KO861aWU4MwX2VomvYKTSmUbfoJJPOHr5opzF/yXVXrwPRbmj
	WtVDSqiRJlkmh93fpptTzZcgyqa1/nM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764754144; a=rsa-sha256;
	cv=none;
	b=7kQFg65OtKtGMxl4/TT/+BidkyTSkz2RQtU4sATTrI+vL4PkaTerbSMbWNhD2jCU/mGFbu
	8/wCY2r9BBgkzCXYQa2aG4HQ+FYMQ8CDg2guJfP4xRRPexARpa8lADdNWE79ZQ80Ycjd0c
	0zWBQiwZSPPBXaxGc6NR++qefORud/w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BosBoc/N";
	spf=pass (imf20.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-640d0ec9651so11500275a12.3
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 01:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764754143; x=1765358943; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ighOjyvrf0/Zx4X8xYQ5PxpLMHcY6lBYspK5VjpofZs=;
        b=BosBoc/NoggSysWAps/chw5Ei+1iS6vzDuib4Z8O/l6yJtx8FHCLrhfXDHhyJS8dW7
         WMmkeVIR6z8c6J2mVaOWSsQWmFtdf/3YswtEuh1HlAruUBTtd1VJljJmwjmJes9QvdCU
         PN0zGA3BDPSXdvF0EEAygDquULOtCT2Ty3LsA0B4QZ/ZMihkMJ87Z7T4snjFb1xALfzb
         UaUK9/7M9uKW0MrmkGj2Bo03vRbx/zlVqQPnBmx28H5Z9fzwVDgLk9eYzk8Z/Eo/3ZuV
         LQ4dsKxr+/UB8mHR1W0zl6Ljuni6307u4iW2WKiwPilt8oPpscbG9Af8yUiL02sAOw4y
         MJWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764754143; x=1765358943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ighOjyvrf0/Zx4X8xYQ5PxpLMHcY6lBYspK5VjpofZs=;
        b=WsFYItNSY6Cl3nV6vvkLecL/A+UivmY1pqnY5fqptt7eJVwArTemlwsB4qBLogq+Ax
         73uLvM7fRNhAuRhfMFavBd7iTp2TMSETw/iVmbV7DuyucyYMKXA8Rd8CbjsL4xCsAu90
         JWOjldxRjEaUp/zxJG1sv0nvbaZ5MUlBUBTt/gGwomJ5451NXksMHtI3QbZoEXFeOcvV
         d/06C042ezYY1zx4obpY9SvMjp1wf97mfPPBh4/JeQQ3PsOcLjUSAf09VPCCcr7nq1UW
         2Ew6M9b0uVSd47kgwui03DxhcJE9B9Q4coDcb3itRldA0oiw97dBOly7n2txr77qpAdi
         Uv2w==
X-Forwarded-Encrypted: i=1; AJvYcCVeIxwq/O6yOIorIRUMzFAlhYxP3XHUnkWsyNKBQbjhuY342PfhDouC1yZGr1xoBM14fSalDlhaCQ==@kvack.org
X-Gm-Message-State: AOJu0YwoyX2Ovxp6lcv9g32CWsMovIKfNn0Mdq1njCAp4JMXAGVMVrH6
	LrCRQ5r5TJq1cSaPGmdYUMbLPPhI19YN+ny6zGFSUHHMsKHZf4EM6tmq
X-Gm-Gg: ASbGnctqhkd70wxdxFKHKIo1OhD6f1zMM3P7uPen1+2KgY2XrNyqebgbV16oJlj+R4Y
	NTWXvr8g+TtYryz48JmOidGebkfgQnIgN/GUftPYMlwbbN3JqzzLI7NF7MaNEwkh7bf9wvB24gJ
	NNgu7AIr7YIUW+rtl88DghxWJ3YQVG2tK83ePcHSjEz58VTES6HHpKfLS8tOyFfrvyx9hQbPDXJ
	+HuY1MRErO9GtRirI5ayNOBZOuX7rT+YlFfPb5kqCSIYYjD2YtIs/LOSW2/Z16umAYiX/eXwSGx
	v8zpPZQhQXVuurlr1CRMezcLxcMWdtod9yDEEgLPDPowV/H58l9O2pmutKEDW1212Q6FYjm6UQv
	N8x6AYqPuSiWXzzv1dOhgkVnVFHJBN5SPoplsnpiXuNTv+yLBrs4pcK2mIbejjzgDzxv2cCo256
	/shVsqabTI3Y5DKGkUKvrD4xt46UUkdzFM8tD1UjFrkhrnpUjDPHw5ANmiANz61LgEofhJsQ==
X-Google-Smtp-Source: AGHT+IG/yyPdPy6ledU410KsgIsElOobmCF5nw6rgVbZS+p0uJGh6qPsi6bQnuwzwkvntLO05gO2GQ==
X-Received: by 2002:a05:6402:1d53:b0:640:9c99:bfac with SMTP id 4fb4d7f45d1cf-6479c47c53emr1439101a12.13.1764754142831;
        Wed, 03 Dec 2025 01:29:02 -0800 (PST)
Received: from f.. (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64750a90d14sm17859981a12.10.2025.12.03.01.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 01:29:02 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: oleg@redhat.com
Cc: brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v2 1/2] ns: pad refcount
Date: Wed,  3 Dec 2025 10:28:50 +0100
Message-ID: <20251203092851.287617-2-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251203092851.287617-1-mjguzik@gmail.com>
References: <20251203092851.287617-1-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C7CBF1C0013
X-Stat-Signature: wbyw65x8rj1eeabtepcumybm6xj9iwux
X-HE-Tag: 1764754144-785067
X-HE-Meta: U2FsdGVkX1/V9EYQC8/ecY/IMcwvhJ7yBgSoNKdkravOyRfyUi3SZmEz6jhTWwtg8seCfiaOykjK+Cv7BwSaU0HVT0ktujKWghhiKBmHZ5ZcoBPjhtWYbienIok2Pf/gJb1S+dR3VYb8TO5IQEtNtE86tmYfwbRsuO5SLSclcRjkr0YHkPmux66APMFInz2JC/YWOUHtiA1UlqXZXrfDgUCLAOOMjVS0G9lqsOBaKN16pJFpfgzQTd9V53KMb6+zU7qESOq3KWmDquOii8OiVORaLtDCH8YLiGTsbFG7fBybXan5Ys9VWwXjcbPUuBwqFz2wuVmJiQeGXhp/eC4ud+gB5y48pahs67jZpIuMlFDz21HyclJekv7UFw+ieXKugd/Sf9ML5b1bpDkP/HU0nXofCwA7vQ/N7hEou09LwRdFUeZbCdTUo3/DGYI7NfiGcz2YgxItNkJpT3CC4ZpamkDQcDpsR/+aqNPCBKL/kqAkqCJu+BkV4H2akGThILeHdbCs+BcX3cDRvEs6yXDl0DF1XUFf0E8OOnbCA7K68ee8LYo6VkbttCv/3JYl0vnk20Z+SBnfNHTub8IW9jnbn67gPL8hrFDS7z2lEJiCytz1kxYGyrCXehxSonu26cYNyJbomVYTyg8nLic+1Igrrr9Uq+3npLfYLwMvj5XYcTD9xDR0XYojfzzjrgyOhnBW97ILSB056RxEfTmSFzNJ75L/uRTfTup6QzcMWpahK4guKFbd86Wp1RIoy2XJ5n4e2rHlA8TO3OHyO62uTTqxk9LxlmRwXE4+x3g78g+cx0CiPCej09bbM+dXfhQJfjvRYDlWETFx9p8hk0YhhF4q+SfUw3gCRlh0Fio8NXBcbQfr5cevFB11cEe+z07RqEycwlKdztkp6Y4r/dYV0j6IJB6TiNgyvbqU136Eduq4Sq//VBEQlBcXUmyxKv5JAOlg2EVsCwW2xby5viZyRk6
 Mzxm7myt
 uRhlr1fHv+3GYlDXnY7djspIS2U+536VRRCS30fZiaUJW8LTl3wOvTBcsKey1Pw0v74MThVTAAPOXE0pXM5dgdxL5J83OKNCDvSkGNCFnXPfkeRgrNhFo5O1Dg9tbSGpkcNXaopxC+UgrY58IfIDH9ABQMzhkeW6OPWALpHf9+X3QGw3IHtDlIKfShSIodIHq4/n92wCkG+iyVm0zV24mKj/zc6SYKhbbidYxfamSu+Ko9ZTnpzmQSgShvSMfxtH48CyHxuDN7b4gswE1Dim8Md85/zuAMqg9eC9VHYm1B6FKG6wCXEUWG5x6vPgHVi+IIxTRnd3kZ7dZNfhGTACb12WaFKelyqK6szKk0GiPkcn96CFI97o/KoJYQaeb9Qe6DsxCsDL6DGrVN6dEXN1xqlu0E8hAnNCJLw6oux4EntdUQ2apI3TIXQUV6DUtPHLmHhx85/mU3BRECq+py5lvnbDRH0J7UqpafDrBM4jXPHlPo/7doLjZHEhULA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Note no effort is made to make sure structs embedding the namespace are
themselves aligned, so this is not guaranteed to eliminate cacheline
bouncing due to refcount management.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/ns/ns_common_types.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/ns/ns_common_types.h b/include/linux/ns/ns_common_types.h
index b332b019b29c..0014fbc1c626 100644
--- a/include/linux/ns/ns_common_types.h
+++ b/include/linux/ns/ns_common_types.h
@@ -108,11 +108,13 @@ extern const struct proc_ns_operations utsns_operations;
  * @ns_tree: namespace tree nodes and active reference count
  */
 struct ns_common {
+	struct {
+		refcount_t __ns_ref; /* do not use directly */
+	} ____cacheline_aligned_in_smp;
 	u32 ns_type;
 	struct dentry *stashed;
 	const struct proc_ns_operations *ops;
 	unsigned int inum;
-	refcount_t __ns_ref; /* do not use directly */
 	union {
 		struct ns_tree;
 		struct rcu_head ns_rcu;
-- 
2.48.1


