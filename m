Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D01D3CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 16:40:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 180E78E0008; Fri, 19 Sep 2025 12:40:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158C68E0002; Fri, 19 Sep 2025 12:40:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047548E0008; Fri, 19 Sep 2025 12:40:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3A518E0002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:40:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A46B285F6D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 16:40:33 +0000 (UTC)
X-FDA: 83906563146.27.4F24AB2
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id A66AD4000E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 16:40:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J74qHWyy;
	spf=pass (imf27.hostedemail.com: domain of manish1588@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=manish1588@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758300031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kfuM6yjN2W1uFxjBaIpJ1Fe1vU4tSmc9A7tnN6PX2N0=;
	b=QSGjCo+lRR4kKuOyIPkZs9EUiyDF8iCUxwE9EWXEIPyrzydhA8D/cLKSdrLU7NJ4C4H5WJ
	YynumzcC/w1StG1yDfMjddJvL2HUQcejUqM519Gcb7pwiKWZlr0ZgNetAFK7vGhJc6YE7b
	WiMQh2LREuwc6qVwmZ0w27C4rszxuPU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758300031; a=rsa-sha256;
	cv=none;
	b=xS//zm5Hj67s9VnjYJv10QrdAC0IauVwsbgXvC0hk0dkCAtXwxtO4rrIIfCE4HMmmO/jcT
	vyZvUUCgOYO3VU+HQ1kcwWAEV5gLpC3L4PHDgp1dN1nOxcyJFAXt2qWsitmX2eSG4wKObZ
	koS0mXq4YEVIXY5FQDcWPvywaG+a1pw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J74qHWyy;
	spf=pass (imf27.hostedemail.com: domain of manish1588@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=manish1588@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b5241e51764so1761522a12.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758300030; x=1758904830; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kfuM6yjN2W1uFxjBaIpJ1Fe1vU4tSmc9A7tnN6PX2N0=;
        b=J74qHWyyy6ON23egu65TgqA3Hco7YDcIGM+BUEfZdh/9j/u5bd/i1FwcE+XBYSOuJm
         KPJmwqiStdIRZOl8d56CeCiX3SssxPy1TEre3x4EdaVbcnX23Xr52E2AUe8sgzLtFbCm
         s/8vlTl9H8LSbUoJRpKytllkJ6TWn0V9cUNq3PtV50r8rOB9eO6CQSyf+kzRnU+vGZuY
         dY01z1U1BMIhOflzHjbXxM4xFDdb9Y+aLYIP22Nt8523NadArR3OALW3p3nJHIqsRvRy
         sDkcoJ7w3H62FuxOoL9QT9eS9kotqz8GzT01iUvnHFaHmiSmD7ZXXXUp1t2tc+Ua+W6t
         3Jkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758300030; x=1758904830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kfuM6yjN2W1uFxjBaIpJ1Fe1vU4tSmc9A7tnN6PX2N0=;
        b=dMNSqVShFR9sUsl4FHtwLjOOh6naj2NKR8q5lm3S4MCs+2Li2fpw7pWQ+7nSKpzOBy
         jXJxQwAA/fa548P+FfenCbtErF0aubQNxhaugydLp/JJBQ6X0t62EfnmFdLRUQ9fYgq8
         v8iN8Ywtt+ADGi0cvzGV9c4ZgwI9+KAKrkRJxOve2soFOwsg1MSQSUBqU0iBLqCAPwha
         OE5hler1vh3zqj3SHVqW25YovqWUN3G0pEx2UNPKS+ZkWo6YwkTDzsLFqDAhpc+HCF4d
         jB9GFByHzWx+2b+DnBIW0mnycxMsnw9504syel2zZenlzpJ3HMGS2xZPLTcXl923yzec
         CK2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVbEUOta+NX/4lhjleK2rqT3B1YXso09Gu1k/AbbT2Zdhk1/+goMTQyOB8xL7qDoJUV4eivNSSGzw==@kvack.org
X-Gm-Message-State: AOJu0YwVvI4HkLYhn4Ml2ePXzzttcapcp/9o8xbT4aBFfR9XcFfPMNwU
	S2jhtyNrb1soUSaeDG7ou+V+diI1/VLhDxZgiqWRxnjs/Cmn48CTXHSJ
X-Gm-Gg: ASbGncusmmdz+CwHxziwQPEQF9EmVN2/STaXdluO5Ii/9orTBTNNXQqV9iU2jLryXKW
	Gi80V8zbDY6CUW/7FPXYMACLs81pakYOQhqUmxLpmzz18+HaB7/biTmmURbCWnwDBv5G5r1mBuQ
	YnK5J678L+ckkg9jAs/e674mQMr563VdEg4n7+NmnPn80xfwfKmgRlL83QsfMHlXtdyFHKq6S+D
	TcGy/u9POdStfLqPJw3iSVTS6uOA43kjbOS4yE//+5Y1x1aYP74HUbgJ5EY5YYmvyff0JmPrKxz
	MCMOlgTYzQBWb3Qd7Q1xN4OG3TQVPkrjMS8Nc5lX0RW8pGq3v40qtCcrSpwzbxD742+2F1XPbIQ
	Ub3S/fHoUhdnG6gjpbSfVa8M=
X-Google-Smtp-Source: AGHT+IEs/HDVU9d1bKYBVI4/TMeUANvetKf4wROv5hAy5IcHo1GI7fn/8BsZupvd1dRYhfXL5TJCeA==
X-Received: by 2002:a17:903:124a:b0:261:1abb:e302 with SMTP id d9443c01a7336-269ba43a195mr54404335ad.14.1758300030289;
        Fri, 19 Sep 2025 09:40:30 -0700 (PDT)
Received: from muxbit.. ([2401:4900:1f25:17d2:d73f:a989:54da:943a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2698016ca44sm58453735ad.37.2025.09.19.09.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 09:40:29 -0700 (PDT)
From: Manish Kumar <manish1588@gmail.com>
To: vbabka@suse.cz
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/show_mem: update printk/pr_info messages and replace legacy printk(KERN_CONT ...) with pr_cont()
Date: Fri, 19 Sep 2025 22:10:17 +0530
Message-ID: <20250919164025.98930-1-manish1588@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <e8121724-a436-47d5-af3a-a16f81cd0649@suse.cz>
References: <e8121724-a436-47d5-af3a-a16f81cd0649@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A66AD4000E
X-Stat-Signature: ownmqipqb8m64bjnqiy5d749w9c3goxz
X-Rspam-User: 
X-HE-Tag: 1758300031-673929
X-HE-Meta: U2FsdGVkX1+rVSMv8LdOlJFGXuTNXzf0YuceC0V4h1gmTSaydb3cOPCdbYzKpGvIg1EhOBQDzVcgU5q6BLLQlbAZsAUzUUEGAVDfZcw2J1V/ENkjL7yhob+jl66bTBp37jJm65mQt6Mobcqoqe81BezmSyrXv7T7bBbBAhvOeb6/EtAU1q5rh0JU1iZ0wGRSAE5ALdp62724/grvmHV3Z7lUHADoDFK6KqJ5yTxc7YReA9zKCZBKQ4bC91s1Qsmma3IYg8a/6y3frFhoE7UtxJIY84aSiKU7rBByb1R1676Ng/XascOyDxCRR/9M7BK0jzXlU0QKKKem+wqSU9WPLJOF4IfTUOY3UQy0gKGa6+IIPhU4G2gPG3GRTkwxqyExpJcHmJVHl8j8aheUwbgLKFhzPT2N6qjdQECDAHblpMm8+IlE9QHSQAleaNX8MJIXFGwSSh9ifc1kp5o267IzXmYMGKZNnNlAVMv5f4SyE/etLt4317su1bM2zBTFa+eCNQJtg0OrFViMvqXbmA7cg3b3Rq5LocjYMPT0YseAtG5T84LoZf6Y4kROHNJ5injjMXT+2JkyUbB2mbrwsZh6nII+kqGkzIjecYbcKKr74xkcolOruGpPgZGlNOlk8LEY3OCSM3kINIQdcgOKdPejy42JxH9GOI3WRudYDDTlcvoVfDDAs/7Gvk1ASMQz7dojqslwMNVuH3dyKQ69Zey0mYgGWE2eNL46UW0bWvpQp5/F/N9oNqarof6DWAgW2/PFCrTzlJDC2PBD5cq6mt0WZ4roB5316X9LQPLZg8ku+2Xo8VeGvwgeanxiehJZbbDYWNgaM2+iL37TBv+rvNP5IyQ+YOx64dxFREztvakwgyCbezUfbPXviF1mVOyhYTULArGC/9/MZ0LKttHB7K7nAgdEukoaZhatA/IESNs26feHdD+u+vLP1Nsfd8NTSOGo/eIkIYbpjIrNDln3HY4
 8iybOyle
 e3zGrLE8YjFmqnq6BDfgYbn6HUG8fPrbcwb6msaLfQgWrhgi8QWA/fC/Ae5eEgmeSP73OB/c4FgsHKxdWFMxykQbgwUzjujvloMzThSqf4OuO5lHwcGKQJ/Kq0s3dmH1IyXEnEFTA+KepUvGajiSLeikw16FOHOvZdpj1ZYKQeK1nYp4ZrTuwCcTrzIvWyfDIPUjIy2h/8IzQO0QfJSY9DpIPXzb0W6blg6zrKwhNPbH3r3u+8VQfoCXejsmGtHshgJb7/GebwlyLlRiJoTElC+TWMd+qkM63vgQsZoQUINHuBq6a1qkte3oAs/PEguuhLgawfWaIhX+xkPbqT+5wRRGoGalfwbhSerkDZyLsKaZI8ZalVMlVJmDF50gQCXi3BX8JRVpJPB1jg6RI9PtaOo7Ml3K7OLfRmgiyvNbsX8DvV2HiqOamINwcwqiaXwCyajiFRV1Psl7vQNT9/0tL1I9EiuLFkpTQrwRGViX7h3ifbco5MjBSaO8To7LaWdywRfSn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000073, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the feedback. I understand now that printk→pr_* cleanups
are not accepted as standalone cosmetic patches. I will drop this patch
and focus on patches with real fixes.

Best regards,
Manish Kumar

