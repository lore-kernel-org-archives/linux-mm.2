Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B85CC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 22:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482376B0092; Thu, 10 Sep 2026 18:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40C906B0093; Thu, 10 Sep 2026 18:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D47C6B0095; Thu, 10 Sep 2026 18:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF4766B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:48:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA31F1A05BF
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:48:41 +0000 (UTC)
X-FDA: 85199343642.11.98B9C2E
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3733F40006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:48:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XqatBJMS;
	spf=pass (imf12.hostedemail.com: domain of kayracizmeci@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kayracizmeci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789080520;
	b=g5lNdZQyNVEFVqhTuJ9so8Ko5AF59SEbjfciOeNRNCD06fwSZNOrnO076KXZhDsJUwW2in
	qXbBzj5ec+FuCPogWTekbAOvjUslsRLHDXJ067vXQsjjmCY6dc6THoCsKDmuXqML4Q/pop
	nzfKNHWXVp6c13TODZmzvRaUnyNuT7k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XqatBJMS;
	spf=pass (imf12.hostedemail.com: domain of kayracizmeci@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kayracizmeci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789080520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LgrTte8+Zm3JUi96agAI4ZS5dvZUFrbR10h0R21xs6c=;
	b=GJExlKyoVhGzYPNti4r7E6YlyvoW7Q/HF+/m3cxnWpcFbI+1OacTsaeBtk9Taa6AHuBfAQ
	9gc+oFjbdxPv+hbc4pel+n1xYOCt1uFvPgtuolS8obCzLiSo4igUh3hIRBuxaFGzr6cIhA
	6fb8Pugh5/j176VgJRLbChUFjpLDpw4=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-48435ae9ca4so24855f8f.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789080519; x=1789685319; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LgrTte8+Zm3JUi96agAI4ZS5dvZUFrbR10h0R21xs6c=;
        b=XqatBJMSM9r5qjlXHsV8gJ0dQWJ4byjKR9zc5KtZ8KVx0K7JtN42yJTxtcPclCBMKH
         0l88Cj61CrKFgFdNkWAl5eLaaDT7ZboNLr5EVt0TIUHA+aGDzhzR4jcsPn4tCwUT9eyd
         yimH8/FQ3K8KafoY4/mOwS8Wn+BTsEIFxu3tZQotrnlxCMMrtbilpnzOW4xskDm0tLK8
         iJARLysKj/5lUptLinEgrJx295IsL7qA8ps2poGPHgQMsMB0RSdpMV7OlfnfGZhMT+7t
         IfpdpxNqlzBVYetsLSgq80alSlsNi+K+2KIWv7UMwXNf3B0TN117rB9rI59OCzjqbi/o
         z8Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789080519; x=1789685319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LgrTte8+Zm3JUi96agAI4ZS5dvZUFrbR10h0R21xs6c=;
        b=sTqp6cVthmAMQUKLj3ZfiFkI4Z/b9oq0gzXQgWR2g2f75dgohop8+wmOBc+23bI86n
         R3UfKZrYMAUKBHTu/1fQSbbm9C/Bf1b8f8XHtLrcqpI7VK266dv5OPcR6opzsXbRix6i
         38HtXgySOtW230JcMaXY3eEP0qNUTQZ15aShBRmS9q4LKvgvayr24jxQORH1qoAVQlud
         fBiq4jgto+Jik6ybJc4JxCGB4lm5lown+9ovf6QnybcqlKSELPy95HMhqU048+h1ymoq
         uDl/FN4T6YNe0Ah+i2oitG7idQhuyd7PSc5Cas9tDt8PzuwGN9gym3WmE6InTOYMjR9/
         8s6w==
X-Forwarded-Encrypted: i=1; AKwUvBzTZU7e2YNnEA6HjYYmPL06wyr83sU3xD+822Fps11rlmIHOU3PNR9OUfECeHUhxHAgoJbwMvH0Cg==@kvack.org
X-Gm-Message-State: AFuF++ks0jxC/yn6IOx7XTfHG1VX4z7e1P4fmrpZ4jqOHfQTd5gEhGB7
	JwFUjt30of0AIe9UGP6Pvkpm2AhwsdX4KBiv1/kDj7mtVRXN18OQOsyp
X-Gm-Gg: AYBFou0+TDE8xpopFZip/lro74ADuc//klf4hktYQAKA08xbIWV1D4z5oUnApDnKC6g
	fIG16m7UfiWXjHwtn/NQPtc2HqjK6CC89NoJ/obydKM1VLz1N8/JYjuWqD4q/nP78sR6rsNtWTm
	byEeLWvPLLAsQ2k+tF5zSujJP6CVTkj9Wg89XEtpP6oSCr4AWIXNoBkgkDkhwKuG9VQp2kZ66F+
	P/Um5lBvJ9Xrz0cj9onbOD/IjxBRJv8zVw4cCLN6um9FLe42xF1A1XLI3TiaqnxjNMgzqK6ww4U
	d8sM9W5yvRcdt2tA/GYDy4JOKSbCjrF7FKlMLBu6hP8gHNu1T5quSYwap+wPDIdZMDG3SaTvBex
	eL06l40f7JaCgNTgHWOckQBVAwOMO/4hrlAAokYr6YYTnn6Th1je7wV42QHy7e40uuGBhLLfvtF
	IH1NFOeP4O/w4AljKYojyilk55PKXrXNmpHYeI5KMXy93prPVxDx5bdzAHiOgMzubfFAbE3nVQm
	n3UHtI2MHww0l+nTAW3gM7SHJ2ElsDn
X-Received: by 2002:a05:600c:b99:b0:49d:1da4:511b with SMTP id 5b1f17b1804b1-49e619a8962mr11821315e9.1.1789080518610;
        Thu, 10 Sep 2026 15:48:38 -0700 (PDT)
Received: from lima-kdev.local ([85.100.66.184])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eaccaa1asm2021565f8f.0.2026.09.10.15.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 15:48:38 -0700 (PDT)
From: Kayra Cizmeci <kayracizmeci@gmail.com>
To: tim.c.chen@linux.intel.com
Cc: brauner@kernel.org,
	bsegall@google.com,
	dietmar.eggemann@arm.com,
	imv4bel@gmail.com,
	jack@suse.cz,
	juri.lelli@redhat.com,
	kees@kernel.org,
	kprateek.nayak@amd.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mgorman@suse.de,
	mingo@redhat.com,
	peterz@infradead.org,
	qyousef@layalina.io,
	ricardo.neri-calderon@linux.intel.com,
	rostedt@goodmis.org,
	srikar@linux.ibm.com,
	sshegde@linux.ibm.com,
	vincent.guittot@linaro.org,
	vineethr@linux.ibm.com,
	viro@zeniv.linux.org.uk,
	vschneid@redhat.com,
	wanglu.priv@gmail.com,
	yi1.lai@intel.com,
	yu.c.chen@intel.com,
	zhanxusheng1024@gmail.com,
	zhanxusheng@xiaomi.com,
	ziqianlu@bytedance.com,
	Kayra Cizmeci <kayracizmeci@gmail.com>
Subject: Re: [PATCH 1/4] sched/cache: Keep nr_pref_llc_running in the runnable domain
Date: Fri, 11 Sep 2026 01:48:23 +0300
Message-ID: <20260910224824.1209785-1-kayracizmeci@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <82736e1329bf8ed195bbbc4990486c87094e6789.1789061845.git.tim.c.chen@linux.intel.com>
References: <82736e1329bf8ed195bbbc4990486c87094e6789.1789061845.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3733F40006
X-Stat-Signature: hwcp3cayuhdnehrnu5s3m6xxirzxujma
X-Rspam-User: 
X-HE-Tag: 1789080520-688040
X-HE-Meta: U2FsdGVkX18t3f+HrfvdeoCpwK+yIYOV1nz6T6PZ7w7RQs3WWVFp6OA67UDEPTBoyaiI0J4kwb6wAvZ8TD0DFtTDmQNZVG/DoOvS3LhteizYrEAJylfUrZBzSayi5TMaf5uKg8/rafX1nzJjdnsX0xywnDWV1EIuYtLCEAvQCPuMre37NuIKQzY8OluyvfdYOULMYmNFQ/AGjVw7AlRQiGtce8J8PS5Xj9TDo2DcP9sy5o4duzHKpgCJVmomNs+qInSgGFExIr3goLKBWfw/TC5wFqex4/Kt4tRLlHQJOC21+A9iERuNbUtfJNcnQ+EuqpNxcR6fqNvjU+I9lfntkP7GP54jZJ0ftUtSpN1Lf1F6Tu0muR0jby9Dy44iup1v3rBH+6wvS1tRphYZiFkxyAyjsk3rdvZ+qdIv6fxsdUPbmCgcoyDAw0M75XG0nfpPr3ca/2qWjUZoJd8L5iWQ6WpAqi4AvLlJO6igs8JH9O+9swAZohGkQ82NqlLozClAVPWB0+jB1N8UXKijJV2+nlvMqZ0QZEAEpquAcFvJpdtwwgBXcXdWg9Wn+25Wc6IVlKr77qkIYmUqfSZYGEMl5tFoLVXDozojqIw7Gfk/xV3Cd72EhNkPKyHuxx++7CrEPZUpcevY8beMFg1DWCqVFTtuhiFe4npG1txLb44GQTuz60HO/ub9iYzcI68/DRy4erdH7EJkw3OBK74bVa0vpnY2HpH514xiag6EmPlOSqIVSK+NWdJEjTjJKHfps50Dx66zKbSlG8AzFaW3wOtnIjBSGubjPp7On5wRbyLHiTd/iUC0crygDttCtGiJqA8XuO92Bn1vwdFxi0AMaPDMrNc905zg7SogmHkzHdvdbbW0kVeQa0+zFR4WB3QLBhbWQ5mOwLCeD99EVGbmPKRDqzez7BYrHMfSZJ398rXlBaCPjv56AqUFEnxpn9nyUSbsTRZBZhDYDOROfn2Xn0p
 rbQaTFmr
 U5inoRBGSfNZbivqayWvHKLX8a5PWL8/0A1M+VNzAkoC/Zsj6uF1l0y1ZB/VXCeWD82EnKcFKjVRkr6EA7RWnsxN29QhrYaChAqAQ6bsSo2tzT1G4x1xEU+C6gn10YEl90RfgfEDAejLwzUScf7AIm5ImgGpHQwAGTXW5kXjL9tnbYscKTkUpksw/q8CdCOHu0glShW6KQYxwcR4uiKarQYLCX2baMsyD8ZpsWt9lHsnDgufkzECGp/TDqEe/BCWEUNBs95wiuPJYx5lLry9Mu7NyW00cBkVatXzx5ETxrcZtuISdXB8aQVqHyi+F1BrHfkgO4GGe/g3jGP1Kmp87w8DDaZCUggl6xDWDsNxnC9eQNwP7j5YDE+23g95jgzSouUu5a1mtgjSEQeLU7MmaH5+h6b3fD+rliqC7lK/GANPLDkSdAf1DJ4aZpARNNwEuXAT6+vwa2CRh2zynz2cE/yzT9Z92SEk5jJisJiRlq2/Snp/1cWfyH3IO0+mR6LZ+BCv0daFzlqqb4dDNUtNhN2q9ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Tim,

I thought about the older messages and I think it's really not worth it.
I mean, even if I'm right on 1 call site, the others won't behave the same.

And I think this version is cleaner anyways.

Only thing I could see was that on 1/4. 

Feel free to add:

Reviewed-by: Kayra Cizmeci <kayracizmeci@gmail.com>

Now I'm going to sleep. Ah..



