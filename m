Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30646CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 07:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743B528000F; Fri, 19 Sep 2025 03:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71B58940009; Fri, 19 Sep 2025 03:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630E728000F; Fri, 19 Sep 2025 03:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5024B940009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:06:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86F8FBA2E0
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:06:07 +0000 (UTC)
X-FDA: 83905115574.28.9623287
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8F7F3140006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:06:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kNTOTWJp;
	spf=pass (imf26.hostedemail.com: domain of elver@google.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758265565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Klo+L3KBBL4ssbFZ2YOqJt7BcxJ8M+dYCfYzeUYYBY=;
	b=STcBYciDpnZQZxPKDXn5YBnpaUbVjeX0YaV0taeUA9tFxNPJUtMzR643K+vxL5sEEG7zp3
	USSEBkgI0nZQn1N+lubqhFPWG0jXaDXqE0jIiV/xJlY7TNVicGhkl8rrhe0S5UlIhpbJ6H
	THQ8rgMDOiJ4nfQtbKRK2bOUGcKVAyQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758265565; a=rsa-sha256;
	cv=none;
	b=iQAFjxjkcmwWUNgj14vi3eszs7UsILY8vnc2TNW92TyF6DJ026+YCcSu4fy6Pabgvuvctc
	WMGIdQm0N1JzyfkRWmz/8xYTTSPpIaRoIvqAWVKYB91VJROuuSaQ/wmXtqqR57IkyjZ/2C
	lwk6SifcLBKvceVUcSY8lhJ2Mw9B4Uk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kNTOTWJp;
	spf=pass (imf26.hostedemail.com: domain of elver@google.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3e9042021faso1259212f8f.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 00:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758265564; x=1758870364; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Klo+L3KBBL4ssbFZ2YOqJt7BcxJ8M+dYCfYzeUYYBY=;
        b=kNTOTWJpf/h8PCCK22ogquE40QummZVfUHolh2QlbuZFdknXhrO5tnYTJbRrz9B6iS
         ysHR3PxX7CwOyVymtujiWnNBpvvRnj2uQrZ7FFIg/FKp0zejA5xKj6zZtTcdREbBrneI
         v9LxxDAth/N9t/faopO0iw7q9z6KAd5Mfa/Rl+Gq1rQuQRGbtSZfiUlolg3qRxxrm+3Y
         nYzUlbiPjhkW6zg7uWIjJN2vs9Ua17B6W7QZodVjaIYlo+Nl6Rqymyw/GYZEenqb20X2
         6VdCj5jIeAbIz0MKPtv/L2ZDgB90vvqkEJD18L+3kNLLAIeQ8JM27205SAg0HX5P35iX
         wNgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758265564; x=1758870364;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Klo+L3KBBL4ssbFZ2YOqJt7BcxJ8M+dYCfYzeUYYBY=;
        b=SP1GCG5c4mdy6uLOO6UeT4We2QxniaufTC2OxUPR8Zmotlc2Fu6yfd/TRoWzhH9sQl
         8UlL64HjOyOjCq0iWKNWlUwOEXxPjkgkTuZFTjQBnrbfqINhRFoUl6APAu4BJO1DTgPl
         RnY1yql5wMvWRwBx8kf6q8/Nu6EaiX5CcklxpQhwk4q+PKNzBQwzR3+xzv1VeZxdEEts
         6a7hJyulPwithUCknHNEa9FfFGRzr0JlrECgJpyUz+j+c4e4QWihCcoCRTHjT6auDekB
         TpsUd3DTfuEqXhAxaSzDwUznn/JGfBtFtoELdlmndN9GiDsLsxAuFKRYtIWsGQ97nHvK
         7pEg==
X-Forwarded-Encrypted: i=1; AJvYcCUbXclpnX2dw+OZX62c4B2Ca4sR5nfsaZzdThtEj6EpNKeg2lNvVOLkBbFe5KSQzpmqEP4wJ+uAIg==@kvack.org
X-Gm-Message-State: AOJu0YwW5OiP6eDa+P1QQqBgh8C5KIQGyU78KUHj0YowvsySQuUoEtO1
	pDUD7cksnYYAXrLFT5NMzhEfnggq+xkkXpOZRKWx+1BmhfkSFtAn8l/wjBGtST4KqA==
X-Gm-Gg: ASbGncvCBV5cKN+CKm0juULccRZ88gPz3dGZ5rzf7qF7bOzVNitq+BYPRUFWLDyeUEo
	s6Brz4Nx511e+VoQWEqCyJwPyU+irAp7gXBot1zXND+CNN9/sbvQJ3I6OlE/u/lDqhVlBB3HwY0
	u+zvhQg1r3oP//BtRKIHiu/G5BqJV4oSD69cmaMS4N3PiBocz+QVcfaaoImIeOsn91FaClTGQT4
	gIMd7Czk5p9jSJQj1ccj7aycWV4qcKHGRwg4qBhpBwCfRiLlYr0DapRWHywTi7D7R3xEYGzpRXH
	TsUW/RxANQY1qkZjf182ofDvCDR9pAO2zzjdI2qsg02Aj30yll6fsyuq+q3tO2TuCwVo/aQ5n6U
	F38RVVsQsdNNBeHsKhr00RCOFnP7JzkN5bRTcaoLDSofB/Ic20WlH/q/Yeps=
X-Google-Smtp-Source: AGHT+IHPi1pgPaxjy0qFYAQQyA+9c6RpQAFZf3vA/UzVRkHTrs+JR5MqjC9zARfGu5kWXbLyHGkoeg==
X-Received: by 2002:a05:6000:2c0b:b0:3ea:6680:8fcd with SMTP id ffacd0b85a97d-3ee7c925245mr1570227f8f.13.1758265563176;
        Fri, 19 Sep 2025 00:06:03 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:2834:9:1f7a:8520:7568:dac6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbf1d35sm7200088f8f.55.2025.09.19.00.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 00:06:02 -0700 (PDT)
Date: Fri, 19 Sep 2025 09:05:54 +0200
From: Marco Elver <elver@google.com>
To: syzbot ci <syzbot+ciac51bb7578ba7c59@syzkaller.appspotmail.com>
Cc: arnd@arndb.de, boqun.feng@gmail.com, bvanassche@acm.org, corbet@lwn.net,
	davem@davemloft.net, dvyukov@google.com, edumazet@google.com,
	frederic@kernel.org, glider@google.com, gregkh@linuxfoundation.org,
	hch@lst.de, herbert@gondor.apana.org.au, irogers@google.com,
	jannh@google.com, joelagnelf@nvidia.com, josh@joshtriplett.org,
	justinstitt@google.com, kasan-dev@googlegroups.com, kees@kernel.org,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, llvm@lists.linux.dev,
	longman@redhat.com, luc.vanoostenryck@gmail.com,
	lukas.bulwahn@gmail.com, mark.rutland@arm.com,
	mathieu.desnoyers@efficios.com, mingo@kernel.org, mingo@redhat.com,
	morbo@google.com, nathan@kernel.org, neeraj.upadhyay@kernel.org,
	nick.desaulniers@gmail.com, ojeda@kernel.org, paulmck@kernel.org,
	penguin-kernel@i-love.sakura.ne.jp, peterz@infradead.org,
	rcu@vger.kernel.org, rostedt@goodmis.org, takedakn@nttdata.co.jp,
	tglx@linutronix.de, tgraf@suug.ch, urezki@gmail.com,
	will@kernel.org, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: Compiler-Based Capability- and Locking-Analysis
Message-ID: <aM0A0p4-3lwLeAWF@elver.google.com>
References: <20250918140451.1289454-1-elver@google.com>
 <68cc6067.a00a0220.37dadf.0003.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68cc6067.a00a0220.37dadf.0003.GAE@google.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Stat-Signature: 8upw1jsxzrd1smejg6ec7hm9ci68xsgz
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F7F3140006
X-Rspamd-Server: rspam10
X-HE-Tag: 1758265565-57090
X-HE-Meta: U2FsdGVkX1+qZOnCDoW7PeLmrLGt8duX3oYA0Z1UWcN+cMQFDqWg3vV9ZxfSyVUogAb9vyBF4+6jRej06L9Ulvg1teM8UtxGME5PAGVqErdRbHmzJDv/zpIrNji62o2XEmTTf3pyPbaF2cyBGs7PtHubHBpM9sUrEwK/F/j0HZ9aJxH9SAtVZklycHUS27UpeHIqoZA6LIpce2baMJPzRlUSViBqz+OoznEezZSMn5OtLAh7Y9xsAvO2+Epf4fsGcbE478AE/Mc1VNHZ4ewNijCPulo4XHz3HpVNsnU9vveq1zs8rUumFfS5LRRPXxoYS9MINtAIcPMvk1iY1D28+uUSpBX7DnQwiHU3LbfiUwJN6Qq2cL2HsbxRvTwSuJkT8xVnypjCGnA6e5IPRkCl0NtHfVprFhAx6qldjJaTtU0TKBso6Epjo68g3b8QdoukVzwzB/IKECGofylRGvKwegCVLBwNKEmecceMaF3X1wkImsgYgvdA5mBqvs3qBB5LSOhUtUToTXC0WMIi5iFiUpZzAzSpo+D6vJNtjQHbdSbCgtgIQL59GQ+2XPoe+H3yeVkVmwz6sfACIek/0ayjs5ErCUYXVfwIEnuKFH2HAxTrq98ViCpQFUOWJJcAst9CReY1sZL+HYOV76lWLGU9uQ3xONsizVMF+Kw69RmkN82yjreJ1IXQ35HgyTZcnRKFgaSLM1zRBHHVf8KTtHQ+g1K82UyoKtJt8A+OZlNbf+J/0SpvkKqudVnhVNDnHvnu3O7sXIU0FrZJvQVcujXfjjxWljwGaYO65tGS62ZkP/JnavSZT6cxM9tofe32UUgi6I1EDcp3hhTP0/A5Q6cWwhOOvS+eTipyeNzZo8cT4sYFJcOdv/pz9yHWMy40eXFXDzeXR+/K19uQP8WF7WhjbmYpKrgoV0wA8+Xt/453QTAZKiGkI6RX8B2Ze+H69okHlvxjjD4HIVYPLIKvxgd
 8IUOaSju
 apSMzBK8ueI4PIXMJx65+bJr/oaRneGgseT2KNzRB7ouBNkMR40SrJCvBYkzrMVyM3UVHB44ivXxsrYB15SOH00HOYxulPszZD3WyquEsblJbYxH9/jBKV0xZWjhAkmTl0lG/S4EUJumlXd+ryUxYbmVJQijyz979U/nYH2DIxrH629YNUA9SdbVwz7CDBPAWTwp+T5gYy9gUqNcNiwslS/jSZjRekCwKiJ+2DlMwfxSb/67C/eU4663ZVP5CHTZmkQ/+g+VNrmzjici/hgJgq4AXgm2xLZyebsWdOny8zQ4LJZSqwppkPMHOIrXz6Mn3iE1UtJQiAwIckSbxpH5SgoD7sfX/+EegN8s/N2d45QplKBCCs0TK2TIpaa/3StllFjYTttRA7FQnVdUnCWgO7H5W9grZrDqlDdRa8UDW5qfvvNYVKz+mX3+f78p8tWvJ0kXUaefIsSjR8ZyEEAWRNrEsTB7ekM/FXF1P0mmKH7CGikU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 12:41PM -0700, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v3] Compiler-Based Capability- and Locking-Analysis
[...]
> and found the following issue:
> general protection fault in validate_page_before_insert
> 
> Full report is available here:
> https://ci.syzbot.org/series/81182522-74c0-4494-bcf8-976133df7dc7
> 
> ***
> 
> general protection fault in validate_page_before_insert

Thanks, syzbot ci!

I messed up the type when moving kcov->area access inside the critical
section. This is the fix:


    fixup! kcov: Enable capability analysis

diff --git a/kernel/kcov.c b/kernel/kcov.c
index 1897c8ca6209..e81e3c0d01c6 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -497,7 +497,7 @@ static int kcov_mmap(struct file *filep, struct vm_area_struct *vma)
 	unsigned long size, off;
 	struct page *page;
 	unsigned long flags;
-	unsigned long *area;
+	void *area;
 
 	spin_lock_irqsave(&kcov->lock, flags);
 	size = kcov->size * sizeof(unsigned long);

