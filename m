Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4115660A6F78
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mkyHKAu6
Received: by kanga.kvack.org (Postfix)
	id 6048C6B05CF; Thu, 12 Nov 2026 05:45:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4666B05D1; Thu, 12 Nov 2026 05:45:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F1A66B05D2; Thu, 12 Nov 2026 05:45:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E8056B05CF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:45:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CAD98A7E1B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:45:49 +0000 (UTC)
X-FDA: 85426136418.19.CE70B07
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id E25021C000D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:45:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mkyHKAu6;
	spf=pass (imf21.hostedemail.com: domain of elenchist.dev@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=elenchist.dev@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794480348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ddYVXCpBhwQ+2ajmiZG9m0k4vsq/lXRN7BsHqaZoQkw=;
	b=4sAp1tV2cGp0dhzJD81PAoJwXyk2ro7JSmDCcMjOcHXeHwk1FxbGFINBZJYJ+9DL9jCpDe
	EKaxIXfFfCqgc0o+2vfaEWr3n0kz475fOSuJ456waMSUS5ASoWbjrPCs3u6tydqCYoQWVZ
	2t11LyOCKuR2DAoFq09TFJVuWXoQxOE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794480348;
	b=c1GBCVolhN1WW+3kdO0kyFIblUqFoCJWF1/LJ92r4kBPZNodzZjk2EZ65dPIlKCtPUayC+
	lM173oFGPmBboe+BvIL9cGeNeNGlrBB8IuDiiVjrXOy6qJJX8GQy9I80YZGFRq1iPnqf8A
	TWUHHheyZQFLr3crZQmbE18lUU0oqFU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mkyHKAu6;
	spf=pass (imf21.hostedemail.com: domain of elenchist.dev@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=elenchist.dev@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6fe4372c5f3so2393248eaf.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:45:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794480347; cv=none;
        d=google.com; s=arc-20260327;
        b=p/Nr1Lo4EI9vigyoWdzwljxNDemYoEPnLGqJdf4Zd3Kr3pxJ4J+JlLUF9eTwfEr/m9
         zteIkQXKE4qgYCo/nlr1XNNbaLvB9fzNLRfbgmvLAEUPc9TLYQe0b/7y9P4rs3+oTwqY
         YuKG5iT60aVfmHVFzfc9rm4Bf684h9Ah4y30LXLcebFjjr8Oe9CmygTzgym6zaLj/VqE
         45S4qPDK7oj1qgue1UCzgCQpi28WvU2E8HavB6Le6jvddpn67L5tvaP8tSkHrVJUJm0a
         GqhzJjhDTXz3f5/RxoRBrbSJd5YoONe8SZGmtaFDh02Q6OFoY7O4vZ731DMfbPz6nhTm
         xKUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ddYVXCpBhwQ+2ajmiZG9m0k4vsq/lXRN7BsHqaZoQkw=;
        fh=aauW40gC5OKkNVBEKtv8wNsEvcO5h09fsbsKAWzyH20=;
        b=XF/BNIxqJ41NJcGeXyWRdiZtAAz24/3CJp8bL4tL7sS1su3hu0TufIFnVw3rfyu43h
         nSVDB8kv+x2JcY7wLA4Sc0Dtk70xiY8iFeD+VK4XBBSiHBE9LyaIBP+1c2dnxvz3w0JH
         cL1CGFUI+yO1W2MkV6VnB+QQ4KjKvlIDks9pXYdYAgqGqIgTo0TLcJOGNkLTfqirhCav
         RtW3aArX0nk6yFIBirf0NgoXJdG0Wdl5eVXCDibjz+FeL/5bw6vvPppVW2rXZhel9rry
         Myon3+LNPscSS0YyEMMa1zFhW4FFmExnFtKFIike/0HFsKS3cQEAIGuezkcNuL1PX4b3
         rs+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794480347; x=1795085147; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ddYVXCpBhwQ+2ajmiZG9m0k4vsq/lXRN7BsHqaZoQkw=;
        b=mkyHKAu6d2Ra3bRYt8fOrR4bl52BIZLqgiN5ky1LkRn7d2GSCeVrr6Uqrgsod/xzRT
         HMwNGSwM7jwof+eoSAsUtuyQjZCbv88b3ZE2KeUCEl8WbMEGWIlkLHCEyWhU+vNJG2Du
         hnZ6wcHbCiyXbV1m9lGfMlk5Rp0NN7VqxlLL8GjQzIxz4amIe+R2ozBXcQvzmRKI/JVD
         pq+X6XGEpvvjSF9/h2ynPpFbLRAfb2Zi3LdybWtJQu6a/CIyhVawoZ5bt/Xtcdn5a5PE
         i6QOoCg4h3H9r1uopT4LbDyw2MQ0WouRqzKRcxb6hsmGuLf4eIzW+CSYPoehvIK6oCTx
         EY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794480347; x=1795085147;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ddYVXCpBhwQ+2ajmiZG9m0k4vsq/lXRN7BsHqaZoQkw=;
        b=mCFSKT9d6tdYJ/2ripDYLVMnZufA7oTlW5XL5TjWUVaMkdbUDuq5pnM85sViym4SYm
         kuU1xGPg4Hr1j5TDQwpJu2xTS/sUb1ViAj2RISRRJbYb2Pnqh/+DvQ+6KXqt3g/7/Nir
         3n3KtQR8jwpw7WKysKFcLcUXzd4AXrY3uv5a7PA0Q6yjHsLoL+lzNVrwbhqe6rJa8ICt
         fXcb7AdVvAx5vFQfRyodX6imIILbZlCfiA4j4LDPJyHc0D/N+FfE2LJP9lzeeZ3iSvrw
         8QLWS2dVOqhOBTpx2T/n6N1Im2YEsG9+1GH0O5X7bsdcUSeXVxP9dYz+zWJusBjW70eJ
         Cl/g==
X-Forwarded-Encrypted: i=1; AL+hErFzD90UN9zp3So/0aHgGWgk3GSv/Ds6aCHZFEHMm3MAms4ZJOGNxk1LQDc7mBLclLA1+k+6CyOreA==@kvack.org
X-Gm-Message-State: APuU4Z8oWA/p/jO+OKfmGjwHXTW1Fj7RZa7U+te9XuaZndrCpf2EFEem
	WzHjT1C6KKwSMMe+Yj/JVCyGZ1Hpq/OJGH6+GcmbRrBzLo2DNUTl9sX1dWmz6cY2afgKAfoRlJN
	5+7yvZg8e2qHgten58f5qqFgcpttA29U=
X-Gm-Gg: AYBFou3VeuhYsCIy1wFYNrTnibc3a6qaqD7+ojfSCeENwITHCnThiXU6afLFwuXdWPx
	88I6D6yDf+LWw0rSnEF/tpcVkVGaHDwjPWWGS8DOKCPVLNQaemyD55EgenPBfw6i/pKUiq4NDan
	ku9aC5sl+DHp170vWjFShiasYOXl1KzUhbJO9APSvTE8okM+os9bOLFYxaCI1jNTOu3IujANV56
	D8W2cIT9vS3Mz8ZX2N5U0MDRnC8IMCnr0N/5r3CeDFZYFMr0NB7yOjW3a98Vl7So4oXir+pmrXv
	Hn6GxoUC7PcaOKvBvYEjM8kdxuJyTYfwkexCHDjYNx/Jw88JwQGcEGx0t4UeUU/p4VA2/vReM32
	pkh5Xuxy+Ydg5CNzLxwlYHU2V6hbs7rhkcj5ZcQw=
X-Received: by 2002:a05:6820:1621:b0:70d:77b7:6879 with SMTP id
 006d021491bc7-7191788d816mr3318135eaf.36.1794480346869; Thu, 12 Nov 2026
 02:45:46 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <avA1wXhTMs9eY2NF@chrisdown.name> <6B8E9261-3FF8-441B-8F47-7D35834A8D35@gmail.com>
In-Reply-To: <6B8E9261-3FF8-441B-8F47-7D35834A8D35@gmail.com>
From: elenchist <elenchist.dev@gmail.com>
Date: Thu, 12 Nov 2026 19:45:34 +0900
X-Gm-Features: AclHuK8UhlNcIj8rZxl-jPAQ-TNb4Ro929pQ1QbaMvl25O9AF4j0sdfra1fF6R8
Message-ID: <CANYAW49zq97w7ptUO6xkXZ3e+CNMzWH7qxQ1bQu4an1L6_kXuw@mail.gmail.com>
Subject: Re: [PATCH v2] mm: memcontrol: Don't lose track of exiting OOM victims
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Tejun Heo <tj@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Zhan Xusheng <zhanxusheng1024@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	regressions@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: gspqcwktg9qtg896zngqkouarnxu55th
X-Rspamd-Queue-Id: E25021C000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794480347-479011
X-HE-Meta: U2FsdGVkX1/8CbTo4A1eKYFudHGWh7wR9Y1PMBHqPmVLxkjmTe4FH8TuCuH7r1mPgbjkXpqkoW9Wk347sL3VrHDSjxLVHYdZQWOIqoFEVhns1Q5UEZGZ3sGF6qsKgBvmaAnadvDO6EXEZGmIHyfUSTRrKPelWqByhaUZM5ZI6XCWueBHs0omcY41yogDt3Zqpj7OBO9V7Gc5FplUeiH19kuh4saq+1uXSVy7bEvwGOrnaZHlZxxS+U3euSk0XAxfQnwczPfYsumutcPdq24nGdx26EIpoOHaa12hOssJbDo4kaUeedUpAgpAcyxYsnOHEHTvZ99tCfv2tKDAWL3J/+KQ/yXhEqPkpe1p0rd261sYi1bSA+Z8b+Tyn5aEiQZxIfsrLbbywA0kQNssCa1Z7c2yS22LQvzAmE+9bU8VKxKa7hyurtMgWVWCKF5rG6atmIGtDlS2MbOyCERL/JIQpu5t7LKnOQFwxLtyirZPeS6emB53wY6BlVRZ4ITwTIALqzDioXQ7DN8rbKjEIg0TJvKZc2hSt8Q/GbX/myJfEuDmbdPi/r05gLGqAyl+m9dV8LbhIqqMSiYXSU7gQdRFU/0NyrKIOb2f8MgziX4C3pcTq50fmzeD9IihB4Cv3AEiVeYjY3ZdyEioE10fi1PyoIokFW8sGhEirPXHHbY7mcjPcnm6Mi0LxXLj2Dodo8bFyxqHCEeRdxWBgW0h56OwE31YXE2PnYqyKYTCEst3yRY2/Za2Q6x+YBl0rIx1IEQ9cqaaeAAM0xc3BRJUOq6/0joLn5LW5OcIUgKP/Ge0nPn7iFGx8e7xJHbbeTFtBYmqNXDWyuONxIbyDjLEvuaDomyajFJ8fzUOKgj1+KQ0cssjRBMZ1fN54zHLBysihwdHyQpgae+VyC4SRjdW/DXfI78/gy0foS+IyAmYs6b4imrGth5XFdawy9SkvXGQ3xeK7KtHROI0TmaPFkdp8hS
 BgXAivhF
 q2r90oupeO3DH2Bk2KXSnBJ3pZm2ju1P+ODKXBIoVQMqSU1t6DvcdxOJU8Jk/25jaBfIYy/8Rcp76tk1dAMpDUQKtIglM6/XIrZ0Wy2hB13pyw2aK3RmbBS03ci/iGprIBbNOTQ89jXLdwILt7Gp624rTzq5Br8U/l5r6o73ilqyAWFIhZKP6BzGaSRYQoGfk0ChnJZHUo1XsmYgV8hvBpvVJqbQ7labjJgbjc45dfGeHleJHPzxdcyxDJgvxhn5W4EE4IUcqssTSEblWA5Z5jtMRF3WvngtnuB0pLJKPCYwReL97YXWibvcLTvDPs/ZzPk7L44tkB3iKZff2ePW89frrnbmV2I/l2+AC/3rfOSH/RRaMyWIAdWFYCD88FRF1ZV/xWxVw8Cklye+Ro0GfQSa8S3CBfDoKRTnIJXrmwesImb6nOmL/9KVVaeufZ3EvUaspH7chmHCwQGqmyslIwEzks0lm/rCiNppwYzYA5KYFryIwpePOzbcDSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

My mail client turned the backslashes in the reproducer into yen
signs, sorry.  Every yen sign there should be a backslash: the printf
format in overkill.c ends in backslash-n, and in run.sh each of the
two "$" right after "echo" has a backslash in front of it.

