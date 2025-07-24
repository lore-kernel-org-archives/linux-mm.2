Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354ADC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 905CF6B02DA; Thu, 24 Jul 2025 09:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891456B02DC; Thu, 24 Jul 2025 09:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757566B02DD; Thu, 24 Jul 2025 09:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 642C56B02DA
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FA36132B8D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:37 +0000 (UTC)
X-FDA: 83699308434.01.CACB443
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 429AD40002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="wWR/Ymv+";
	spf=pass (imf01.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.50 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365395; a=rsa-sha256;
	cv=none;
	b=WOXzCsZ6hqxh3uirdfvW2LlOuMmTCN33WFc4aihuwmn9N5ksC0jdwAPyKaSBtbjjg453rQ
	XrpHepr/BV/yoASQOgokIPvLBgDd680Ovz5SHmDLM+MmW+suTeqWwp3vAI77vZP1jTJuzK
	DSNBflxs+KORvwLNwPltVyxhXhG89HA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="wWR/Ymv+";
	spf=pass (imf01.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.50 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6EjHBZibILbBUp2qJIWYHcXS7kn/hLDSQS+TJg877Y=;
	b=0CkF8Z4uOyYuB53nrn1U/WEhLo1uPgbg899JhensVmYRSJ1qAT28CjPR65i7y9Qd1AlkRY
	aZJLITKXhYRfWBq3RwrlVwhc21WMb38RzJ8Uucu3WS28kM2dEhWUeaoZPuz1ewZ5MW1LGt
	nZk0NWB/xyWuXyMlJxljXBYft2e6BK0=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a4fb9c2436so547243f8f.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365394; x=1753970194; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6EjHBZibILbBUp2qJIWYHcXS7kn/hLDSQS+TJg877Y=;
        b=wWR/Ymv+LPk8CCn/LLS4bM9h2Up4yTrYtQOXZROa0ZQIfn8WpQ9AvpEWUp7juFR+N8
         GeuVf5+LoHCnTQWQGKOxFeGoHRYJHQG+Qb0msD6nr/s3hztNwTU3ZKbpv9jB8M98lQpQ
         R6tihkdop49Jies9zhKuFUKEPz+8Vu2q9Hga8pObqL8oWafXI+qEIjJH34jDJ9/8ZamU
         AFIXzctyzTEuXCK1osG3tqM5iT2NkSVhYUMaxeDpGTu4AvmSbUbJM0WAkCf0n8vh84Pk
         uhL/Fd0+nPTM3lo0NOpPbXQsDej+JDXBDNriSGM2EkrHMqVhPVpS1fyz4mf5D7eZZMte
         s+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365394; x=1753970194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/6EjHBZibILbBUp2qJIWYHcXS7kn/hLDSQS+TJg877Y=;
        b=jRunItx7jFsz3aEY7ZP2HZQtTJYYDn7VMmp5ZlNlly68DePDA0sprcgnnpNAA41vS8
         g1yMDfE6g0Smpc/jzbcTh2g8cZzxGbPUS+XsWlVp4WJZNfXVkmoWqKGOHqUvIA9xzvvI
         ICclyv1joRHLjnXRYRNUOppetv3H4myMp49mZCYkwmJ6XJj6XzGOH493wZdd+aWGZ88k
         Kzs7zQ7y5tzdzEum0GTbnVKEcYPgL9Oilp+P6pfsOR93VS5YEVyrjJ2YEQ30vG9FwtE3
         VdVUsgHjWmV9SQyx5z8G9026FvAXDcptEhrhTe14GJC6nlnc4uliosoRHQ1D1B4KtSeF
         qvow==
X-Forwarded-Encrypted: i=1; AJvYcCXNu9zNSg8+pWTvKyk1Ef/cbuZuELAMx/dz4M6IFLHpTYqW/uAZpJdaFeacqgHEnz/8bScaLRp06g==@kvack.org
X-Gm-Message-State: AOJu0YyBxQjJrvQSjAuf1Nay6dcG4FERzdH1QZAdvzPwn3JirJTzes5v
	MkP5J2ALmSpPhEOT64oRsVYlabwmVsiM72pzetT4yu9Y0T/rhide49kOvPTh4GHKOTE=
X-Gm-Gg: ASbGncv1AtfvzJZkSxaVZh6FlwH9+0dQY/EwFhxR3nyH/F5oAvE/zJVT/amUzozQiX+
	GzZcsuTdwCLqtQZE7H7Kp8dzXZ4JoVqP/9czedlaQdSzs3WTlmh2/5IcHP7XvWzRhuSANAJIqW2
	x0yV0YPyFbVwOvFI9BeI4Uac87mejgy0nOYW9/csGuq0TXVjGvd0jn626GDx4OzQ2dSai+dVjVB
	d4JQcPyEpOpi7+YQp/6ohFKyeC4vjnEcUAMMgjOLao35Ak6TOhywhw3vUTNp12AoRXFGTrmoIp7
	tKgfFI0lFcr6OSNQOfe0ddC6wpUYp9aiL3A7WsMGqps2lu+6ylQjEdNID0AjgRGcybDEx0nJ7j+
	mjFERblnn+c70thHrJPjPAJ6wXc7f8sJLi5Uz9r0AhHaNFnFZ+2ugujAQJCqMoHozMjJ2lz+Z0Y
	FiYjDMs1nusET8
X-Google-Smtp-Source: AGHT+IGRlGdpZ28v11nrKuEy26SoaDmKeIQI1w12F1VyMMK6OUtkgi6ZkZkyO989nTl8PB59Q+K5gg==
X-Received: by 2002:a05:6000:290e:b0:3a6:d7ec:c701 with SMTP id ffacd0b85a97d-3b768f1ab39mr5321094f8f.30.1753365393821;
        Thu, 24 Jul 2025 06:56:33 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:33 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 13/29] kernel/fork: Annotate static information into Kmemdump
Date: Thu, 24 Jul 2025 16:54:56 +0300
Message-ID: <20250724135512.518487-14-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 429AD40002
X-Stat-Signature: d34aexo99g43bbseawto6bqega3i3cjg
X-HE-Tag: 1753365395-754894
X-HE-Meta: U2FsdGVkX1/IiLRdkBXyqtwG+7nFXrToKQjhqP5QK7Gl9YEZ2Hkx2rzqr4n5Qc5fXGEPPyqKHh81eC2NxZwMjBnDq+vlHvGRZ8LyLLCxpbVyxUoMwJabsxEy1ApNE/S4Zs41YWrCj5uBp54hlQ+kh60JxDa2y2bmp0hoUsVFymDLGJLNlQxaBJz5VEkJXKoZbpIUQOfB7Ui6DpgiXVAEOLtofqn0ppIpOe++w24p2+WA6VcfhP2MyUuzx+ZVGHGJEmhB08c92NPbAPpjMxWdfugNfL2CrKEKd47svvXTURUNLiu89F4KGZlHlAMBVXDGcxoXiAbfr1BQhik/fUu3BRDoxJzrVu34hxdUkk2vWOQTGM8S29gyaGZOFEQw1Du9Gk4DqMD0a4+YFV0t/QedLaxx+8FLfEFVmyWn0C2s2rQoCVsvRHMctRvq4+Ndpr6KLtOJPlUk35CMRxqkrqE/tLMVxittMmBzVbGexsZVT9rdc7YfyNek/pFTfVUX+skgPoIPzjgPmHSXryRPatueAA6D9e53W5q0K+iHcHUaaqPnNAyO6ZP/oNjrVYVW6dvq5hQYGHgTGPXiu2TC5AJAQmq13NfyruPIMGN398uLLYMXNmqhM4W03khyv7qCUFMWl4LHs0ppUZXqnhlglTyKyDJ8QAvwe0x/TlHzBEjRwkkLHAMs8QukrSIBiBFEUZIznbEvfRDrsPhTBmUm+mRjDBY5jQfbGXKWmPmzRZiLdqYE6yKlSWGnpQK+FEMwPvGs/1Dnn33ISztXFfjEgqcLSkKZMt/OWDPIL/pb1tjQUBlozhVeyB+bPrlS+n1G2GBkBv9SoSNrHUILUcEiQSG2ZuvSv8K5y3Ju2Itu+nnvRlV6d5W7BHZWSb2kktPKAI8u564Ayc7xPP5gm9UH/IFBWx4nP7QGunAxGPwA/gkOMUUIom0N+7c0lq/x3yOHlyywD0Zr40FUBhZkZE8xg9v
 Iw2nSttm
 rldVHKs33vByt+pq7BE0uKDoT6cKpYr82HKlWbKg93PancLQGb7Ws3QuNPIyFtjcWriqnC1s+kD96opi+ON6qkNZ5njWDM5w3gG1Mig9Nm/nk4kXLVP9LRKFvjFmYgf2yBuyBWkV4/JHl+HFUkpQeS24nIqH522k+x/1aD/PeAkoR94dKk8sP7iyUD4wK7vucZLCdZo5X7QYtf/MjU2eXwbKtu3xYUsNGPzCgHpaGzYS7KdT7mmNPhPf08QQoaPvEm7vgz9xpLhYaHg/LxYkANp50ZiqdbU9hP30eQ/IauYRwdVrDVEIBSpKFVCO1r0hd0sFPT5JnsmJCMD4oGPT36GetyYPhkvfvcfzQpzdif2gE6eIL6OoZz6ypwla08f+pmRnpvWigo29wUfQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - nr_threads

Information on these variables is stored into dedicated kmemdump section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/fork.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index edc6579f736b..ae8ae9b9180b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -105,6 +105,7 @@
 #include <uapi/linux/pidfd.h>
 #include <linux/pidfs.h>
 #include <linux/tick.h>
+#include <linux/kmemdump.h>
 
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
@@ -137,6 +138,7 @@
  */
 unsigned long total_forks;	/* Handle normal Linux uptimes. */
 int nr_threads;			/* The idle threads do not count.. */
+KMEMDUMP_VAR_CORE(nr_threads, sizeof(nr_threads));
 
 static int max_threads;		/* tunable limit on nr_threads */
 
-- 
2.43.0


