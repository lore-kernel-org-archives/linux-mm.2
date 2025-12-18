Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 128B2D68BE6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BAEB6B0089; Thu, 18 Dec 2025 02:25:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7925B6B0092; Thu, 18 Dec 2025 02:25:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69E226B0093; Thu, 18 Dec 2025 02:25:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5716B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:25:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10185BE0CE
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:25:56 +0000 (UTC)
X-FDA: 84231757512.18.B5DB014
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0EDE018000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:25:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kmykkNkT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of kdipendra88@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=kdipendra88@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766042754; a=rsa-sha256;
	cv=none;
	b=wpdQP/GF/f3EUebwLBTkSMvkbEeBJGtlW5iK3LrBZpUHKxKUMCYMzn7lJbVC4/PUDN1c6w
	oYriD64J+y9wkj4egMcUZq8ldMSSrGFdDCNUD5GWecVGrkpOdpv2JQoHiZJy8L0mq+LRRl
	aSYI0A8jR2FwT/c8FvAlu6rd8PhBMSw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kmykkNkT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of kdipendra88@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=kdipendra88@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766042754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q4R88Xn/h+8caxsc4FK/Mwtw22v+IgmOvKUTH+FxRso=;
	b=kimsHmmsa71mxF6TL6a48KnIiA8GlEH3KOJj1PiUvLd/2tUeSn+eqTzkbxtT0baB88Xcs7
	7yQyI0hFHuhyWLGzHyW42f3N/NkyBG38PDVuMSM/MA8hayoefPc//+B6diX58U2aoGoUYz
	+eNq17tEJ6me5HGLR7zA6ZUpZh3GrhY=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7baf61be569so415828b3a.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 23:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766042753; x=1766647553; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q4R88Xn/h+8caxsc4FK/Mwtw22v+IgmOvKUTH+FxRso=;
        b=kmykkNkTOBsW4gDnK0ItWnbkkucNzO43WYfA0b8POWAKWNd0nMWltrNMn58cXIKs3n
         fqlPxBex63u0HklkSJlL0fcKvtrpug+BtlsuA0qmcPcC3myPXeB/0MZUtoLZmXvIzIvU
         jkY49LgHi0zESy65xjP7vwChIlApxz+WQYqV+So4ROVkfjNIdDUFpVr7cFk1J5++t6gt
         iQmsvwK1wRU5+i7uxpGRvF2t/g7PWcvBm5WbGuhu4tmtPuAH5idThLc8DxJiLyYihrhK
         Coo/suI5tB5WAheRpP8mcCbyGH39Xrvc7gHkUPx1BNcOHJ5GdZsn5vKb60wmy/DqGjam
         vfog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766042753; x=1766647553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q4R88Xn/h+8caxsc4FK/Mwtw22v+IgmOvKUTH+FxRso=;
        b=VBuEsfvExCmb+iRbuf5obK0C0M4N0owvR8UttV9lb91K+yYGqQtEnSyI7ehCXl+9Zl
         NSBNjDHu/T3oRlFKaDlam2bhviTJXuaEEwxHZ6sIPw+aVXFYvQBMXzfZu5esdK7vOhbj
         2Jcgtvm0/+DA8QlUStR2iqzjRLleYyJAZ0ovs1iS2evGE/IXkrFENPz86TtqqPCLT+MC
         xl9XQPb3zia+v9WzrSGmclvkqhRDeMfF1gZ74wCnrohpOJRbn+DKOfrbwtwWU60R6r/+
         QDthGYWi/MXYGGVK2C/ZJuFie8XXOxW4jFZkSuUp5sG9dHYZ6+vajOPZmlT0lPH14cpT
         3kFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCqu7hlJUDRmmc8NEwEc9p/RcH5UAkXkqmXDD/bgDCukhoS0ryo8Wg19AydiqUnC3ydrSGY5m7gg==@kvack.org
X-Gm-Message-State: AOJu0YzVqlYBRt7vZb+pMqkqCuknHXNSNPyPygqTnpBniQ4CKZl1/ouz
	Crp+HBD6BCIT/YOjt7ZqP9eRhaXRySIPzgxVQaL0kOncdxSH1HNTmzMM
X-Gm-Gg: AY/fxX65e8MApVoqMuWaLmsH3XiKKu7xiMnhDj3XKRw+fxd/5bniY1aa0q4e+eaR9K+
	VsRqRMI1AyVtoIUzOhziLz+F/E6UfynoY+77ORajcxpXmiOMKgpan4dzG3nlowZW+t3dwfpQz6u
	ek7PcV4fePnCOD9vEqNCtZF4QrHJU4jLrfdarpJoq7QkpwwbJRTQi2ZsEuBFstfLjS4kI0/1em0
	hYhAiVDxPtG4C0zJ4KtfqSyLTye9oBXKbK/5y2GBlJvJttbGXIFytCXhOnYQ0RtJfxvgnYO1sXK
	+vRHQChjcUwheBIPA2cTjqgCpVZ5QNurMHkytkbysF5WCDtlCjtIZ7DwrEn5c2PHEfDaMZzErzN
	5Dg+fZ4j9YCvyKUif03TdtjzFJujJiJkKd6rksa55DpN1YVS7UMtkJHNW5lIsIg4PiYUqyO0LAt
	BuK3OLfn81
X-Google-Smtp-Source: AGHT+IE7QD6jcxGZ721fK16jncezgZTI4shZ+xr6T/MCI8KS1Fg2nLGW1aiuenpQ0XBQS71PTipzjQ==
X-Received: by 2002:a05:6a00:3499:b0:7e8:4471:ae68 with SMTP id d2e1a72fcca58-7f669a8e5bfmr19659120b3a.52.1766042752688;
        Wed, 17 Dec 2025 23:25:52 -0800 (PST)
Received: from ubuntu.. ([103.163.65.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fe1427026dsm1595735b3a.46.2025.12.17.23.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 23:25:52 -0800 (PST)
From: Dipendra Khadka <kdipendra88@gmail.com>
To: hannes@cmpxchg.org
Cc: akpm@linux-foundation.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcg: reorder retry checks for clarity in try_charge_memcg
Date: Thu, 18 Dec 2025 07:25:41 +0000
Message-ID: <20251218072543.5071-1-kdipendra88@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251215204624.GE905277@cmpxchg.org>
References: <20251215204624.GE905277@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0EDE018000B
X-Stat-Signature: kymf6wejuexhi5oiwxhsxcr7jt6hg63z
X-Rspam-User: 
X-HE-Tag: 1766042753-164176
X-HE-Meta: U2FsdGVkX18+G+U//Mz59GgL4509b3Lsc6UUMUJ7z+KV1Xd25c/t+dz0/4SS4ajy8D4LsVh+igcFLOoHPFoNG4jiX6MybKxpLI1E8Bvtc1wDkffjcoJ/KTcGjVzaVepvuhzwhd31wKcRnJEHjc2ptaje6XEgywm/4ZBnZhketR60qALdm0d9Vcz0eB2uvXqZQcCow/p4mppUBizQN2hM29MYxbHDiVJyvIm8hCECkTeIi8vYozRxDe6dnlOS9mwh9pNKKB6IQLIOY0c9LzrE0WaIAFlU/09UxN0H8My+ipYAaBqaX/Nfa3dpJkTZNvOoADrD00sBR53mybhIWEW5GzlvUg9oofEM83A5TSAgsSr5oavH7RSMCZZhlaJjxAVxFhnQ8aDn4G62n8GCMh8bz3g7TgOdExP4uzYtZXNsqGx1vb6h/m1DL1/tsJJpyiZbuuPZy+UdFKcTR1h8/lCOgOS/kxGNSZVzVHp9TN8KISSZNcIs0B3GmBmHWwyKtZ9b6oFYHDFaA6B49KE9AL9gHplfk/q0a/6dAE0z+EHT3fexfQhe68drNWo1+5/LdaWL0kzM8LPO7fGONj85XtKvWmgtbj4RtMJyoNr/BuJR0mVVNRk6DUYqIsXWpbXXHJH3XkSkHPxM8HAGFeoe9+kgSuoPTItGQnmLBS0IrbCJWjLgG7rJSfrta4zQBd9vyoN9+ImluPOGpOxG3wML+44QVNz82dSERBHvCg0KXnSk1fRxAQcHsHZ50GJpMadWpNOXhImOJI/MfkIES4oPeUNoySLvUvrJQgEhqV46q/7ui5rbaJJ6eTpZJnjqOgE1ZIQomL+rtxUjkIIF9KT69k35zUlG+VZ6ojIBvTAUissyWDuwFB7aETfs/LivSOlsZsUZeKMj7G2IkIG0FgM0GPfWs7v+7FsfkNSf/z74J8E2v/4wChLjMfF/hXTD1QGiWmngiKqjwWeR4ZB5J8gT4uW
 CwG224gi
 mbnzlQLQCx/lbNT0b+b1TOhFcfXlTiLjbRT3rvrk1tQr8zOczOMwWQa1VkM3RqmWBUZ9rIAftimbmW+X9yi8ngdt4tX4jBz4o+qSkyEFqp8t0a3PSbx/rxqBGpANyK6VSDXxPO2P5q4dxs55vUL5D0ahHbkazOH6u3pv7o3zSjvVFNi97PwB4FRSyVh30FgKZHk51UH2+DfCuiI7DoaiWSRsx2kCYYpC9FKXjSrldtOdeInzW+7RuvwfO2RPZXMg5/UHZo+4ngW2Qc/7gZ347JNAt8a0dOtLLGaOWqf6E6poi8GLLIXtW0rNznuSue+fsyXrKa2MGzjegbBXfZV7M4fbv1tinzN18mEtaKlFfnwN2F2IkxQLUmBbnk9JF+wHtsibo9l18xYVYmnyjZac7tQr5mrppXfKxtGCn+dnhMH2SGPApZc5ZFdtJ1Hn4RC35JnoqK+PyRLEsi5b1s8x5AjquYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Johannes,

Thank you for the feedback. Let me clarify the scenario this patch addresses.

The task_is_dying() check in try_charge_memcg() identifies when the
CURRENT task (the caller) is the OOM victim - not when some other 
process was killed.

Two scenarios:

1. Normal allocator triggers OOM:
  - Process A allocates → triggers OOM
  - Process B is killed (victim)
  - Process A continues with reset retries - task_is_dying() = false for A
  → Unchanged by my patch

2. Victim tries to allocate:
 - Process B (victim, TIF_MEMDIE set) tries to allocate
  - task_is_dying() = true
  - Current code: wastes retries on hopeless reclaims
  - My patch: exits immediately
  → Optimization for this case

The victim has three safety mechanisms that make the retries unnecessary:
1. oom_reaper proactively frees its memory
2. __alloc_pages_slowpath() grants reserves via oom_reserves_allowed()
3. Critical allocations with __GFP_NOFAIL still reach force: label

The retry loop for a dying victim is futile because:
- Reclaim won't help (victim is being killed to free memory!)
- Victim will exit regardless
- Just wastes CPU cycles

Would you like me to provide evidence showing the unnecessary retries,
or run specific tests to verify the safety mechanisms are sufficient?

Best Regards,
Dipendra

