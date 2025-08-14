Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3A0CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 14:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B50AC90017B; Thu, 14 Aug 2025 10:07:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0201900172; Thu, 14 Aug 2025 10:07:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17DA90017B; Thu, 14 Aug 2025 10:07:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 928D6900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:07:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 487731DDC2C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:07:18 +0000 (UTC)
X-FDA: 83775540156.10.B07F17C
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2AD7620007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:07:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=Xc9BMuYQ;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755180436; a=rsa-sha256;
	cv=none;
	b=eNbvwFm/gPrX2wOA0SSzFVFmeYEyCF0ECDCKAjqw+stQdrqeXJN3QP+mFeNzzOLrhAZOga
	BKSsWKRQnI31uYNuZ2b6LEp71W6VxIWjCtzTDpPmQfkXFmoqOoLPDbMT6IdEyZjlS6Ilpt
	aFDhoJZxkTv27cajDnCjlMGp/s2vhbo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=Xc9BMuYQ;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755180436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wJHKe8l+vOKZy8o1OFSDsfg10P95a8j8COGNf7Nlfyc=;
	b=Y1vDj33AME524l1hEuqa9GqRrkwA/4iQGnHptqpLPRY3gsYCCApSQvgRm2HNUzYoXdXCal
	yZHI5gFNuh4f4JLx84qanLnUTAkTFOjXTj6VmGcCXf6CureLYQAkaGFAJhsY2mXWIZ+dSz
	lEwdix2ANSHG3eVqqGZxbxhTv2pWmXo=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-70a928133e1so8925426d6.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1755180435; x=1755785235; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wJHKe8l+vOKZy8o1OFSDsfg10P95a8j8COGNf7Nlfyc=;
        b=Xc9BMuYQgkY2iUkr5V4lHlVk/215xCv06bwIjg2dkqkyyR/EToEQH1aMpjFdtgH2bW
         xbxIXsaacJpV1gTTXDm5L/e61xjw5cpKGDJY62ayBAUWGTF36MumUX52ELuYU9hNu0HU
         6Y/CKKuu1t96wgoEBGR2FfmBAqjxjeGG3+TD7YdUqvhYno9Y6COWHNkeEGjRiTnyz7jd
         TvnLHcI2LNcFzpCUSZWeMhL575TRG1OuuKomfANExyitfXap9utQAHRGcv8QeiOOP5ey
         XFkNLx759PkHDwxs5VB7/JzCwOpEI2FUildsISJYZTQDBu3G/wbboyoR1eeoyqPMmGRb
         E8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755180435; x=1755785235;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wJHKe8l+vOKZy8o1OFSDsfg10P95a8j8COGNf7Nlfyc=;
        b=WTzeMZDiaHNxrWG+c/A2U8A8ZBOHRgZhy0K7Cpu2GTC/UV/yVP5UbNCCf/KqfDEOMG
         jNPjCriWoqfB1nmAhRRtqn32iqKBKl62BXgn9ubch4OWVr+gzMpj2raAHjfgeXh6iLP/
         VM0Wni9vkPrehh49UYtgHkK6hL7ilYf3kfbaP5wEHUAH89bEOozgNLRGw+hGi0gQIYNp
         0U4a0gGoUqkPCMLmWCle2o/V0F4jZtiJ1PbVzpIKlsfbSnl7OUjCcl0YcU6z8DGl2aKG
         8H83I7+7qt4xzhGT7Do25BpaWY2EjfqRZsgxjjeAtb/VTE8vIzEvHKs0pQx8sir6/oyz
         fqJQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0Dzcx10IttiG1wQhXZfyEdh9IwTYuTYt7BKN03Ywq1BZh5nVYtXrP4FKB5gOF3dII0WlNkZtUBg==@kvack.org
X-Gm-Message-State: AOJu0YzKFAtOZey4VuRmiGUFr882V+sZM5FCOwGsyMXp6MSKUv37R/uc
	ZH0317vlR6146sQ08vO8whYwP+4jOFBI4GUPOrDLiKUUoGAmgSKjbAUyKFt04sHn1yk=
X-Gm-Gg: ASbGnct9tHhqdaSzr3twctaBFMkkOD4n5u92Lbm9PrlPdRG6dA6A9mc7S8whSdQfpwn
	m6cgS1HW2MkGhh9B0/vOrI5SvsJ9hZzp339Q4Go7hQEPx19z/S9LjVQhoP5q3x+p0iKSEZCAcR+
	R6+fyPqSO4g3X017Em5k0pT8grUGBCdEo6EU5ZnAbZ1Q0QJxXdjiL/v95QK8fyRfN/fyftVmrHZ
	tAk1nGJ2zjWSxX71upQzNhTfzKlZ/7lmz6YfeUAJDYXRSPJlQeEmo+700omWwo1+0pqLQbuqfsO
	MkqQxTiinvcyFOc6N9yFuXYL3DpPDNuYBnBZuuV9t6NXWVv49lIoALFjQOFNwz85ivj89rjBxqu
	L9xeh6hbFMHAWHws23NmhxA==
X-Google-Smtp-Source: AGHT+IE+zn5U6MmZ5wiWKWqRM/hTgkUWWNRCtt+8nHxw42gEXznrNpPz9mjYvN8GIlVo+bY/DO2prw==
X-Received: by 2002:ad4:5bc9:0:b0:709:2ab3:17ba with SMTP id 6a1803df08f44-70af5c8880bmr40814616d6.47.1755180434870;
        Thu, 14 Aug 2025 07:07:14 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-70af5c68911sm13437716d6.85.2025.08.14.07.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 07:07:14 -0700 (PDT)
Date: Thu, 14 Aug 2025 10:07:13 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Ye Liu <liuye@kylinos.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: simplify lowmem_reserve max calculation
Message-ID: <20250814140713.GF115258@cmpxchg.org>
References: <20250814090053.22241-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814090053.22241-1-ye.liu@linux.dev>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AD7620007
X-Stat-Signature: ntzaq3q6ewgo3w4q5gn7qd7waspsdkht
X-HE-Tag: 1755180436-273277
X-HE-Meta: U2FsdGVkX1/5L4euGwcTQYNIrcfINqWo3zDZAaNzjzirwR194PaSpjKdaPNeCJAn75uwuKUTOuvWt9SMCrwdJey+AdoOzPWsT2V1g0FDqAoTIgFbFAPh3Rtya9h8BFzsfEuYhMJSgi9GiNAcB4jocGOAR4g/uLttLjp31rRPgkReDm5dgTzZJHgajDaXrfmFW83J0yRkAsWcDhguJ0ywT7yfrKKD9vj43Npr59rowEP0reJFGGZQWCn2wI/QRr5JGBhH/qATypZeOF0wa0MhltGMLcFOoTylPm9YXtAvcwJryB766fVPlNLJ87hBlrLZJvYBqDnVZyb7zuvSLhawbKB7B3ir6l+9Xby4N9Jrrs7hwhMC73Yo8OzfCFGCMlOfqtF0eERN4Evw9bgltH9xKOZvTHNirCfFqp0/WJWevkMC4KEneErdTC0OYK/Yb1W0GdqqlMmR3niXp+QSvkjhBJgjWmuzwtwy1FCpSFmRW6GidLZJVSgJ/TxaS98MLGmgRQp7e69Gd2+oFkRvz5sdJpUqmpZxWtte7umblpaYiJWXYHW85fcihuVy1kWs5Ypf9xYUe5WCZvpzIhB+bE66vM082AIkQHJoLijTZr9AgujbUz4vQQjW45vCJ2XYQ6HT1ar5Ie7hTKxTHJN4ICvCNlHtJw0mg1E/kuzkGTb7mXGZsNdQhZSiRqFQchkChTh6ivVaxrjNvdQH/wYCZLqo3IULU27l3ESnMJfLInyE+Iu/izxhEM/IjyEyD+nhVXtT1Vg75J5723g074JJJR4hoZx45G0jgf44QCoO63S6O5rxMF3gEpJQ/5iK+I29sD4E3QeQXvrXkiAZ2/31LT9rrqwsaiI9GlTm2rkmMhgsM0wQ1vcx8AjNQb5VhyCV0MedNn0AkFiBF+7Jrha6RoPOGWYRUFHMz0VjU5e6SkOQGHGmhJeCAGLuFXhjzXq2+kejUvAfxj7Hxit+Dsx5q9t
 2Ah/lXTs
 GcqwZQTpYcmE8vsTSVfLY48HSSfSgKMOup/p+fONBFEU28EH5ClTA7vQSaJdruSaW+5lTnwPrYt71KEtJdWQ/QUn57ex9xxZjrp67NBe7H0F4l3Y5AAzRmLELR1+qGYVuYyoze11F8rCNY2CVdON3AMoE6K3Rgw8zv4WgRFj66eDOxfjfKRMCIdX3iduOHnR10msgUaZh0QEQsTVCH8RqCstIfK+Ztp0RsUp9/EngKLqF/70xKxzRPuS6nibUY+X/BN/EE31H6gg+ER6RFi7hGBu/G3MClnPPbXy9Ic3slo45RWaeHpjMCBcUKbZfEsGP9LWJ0yigHxolUdZakXQQpURYYoSj0/121xROsP5pishiWav/Tqh4jEzgTL8Dj3vBOETW83Qd0ue9V8j6oLw8lhcFQYZGfH49FjWCBcJkWiBlHicrbBm1DIBrC4FH0B7hEx6zNWgGy4EHhkHpp5sUL7DHO/YIpbIH5GhGq6R7jpyn9JJgbb+KYzRkoN6umDbf9PDZLI93Mca8Mkb3Fn4TgUGBEuOXpGDKvJnGiI+TPfIs+JYy85+T6RVzUyMzO3sJDHsX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 05:00:52PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Use max() macro to simplify the calculation of maximum lowmem_reserve
> value in calculate_totalreserve_pages(), instead of open-coding the
> comparison. The functionality remains identical.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

You can remove the {} from the for block as well now.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

