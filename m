Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92ABE606A334
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 10:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZSTmmI9v
Received: by kanga.kvack.org (Postfix)
	id BA5346B05B0; Sun,  8 Nov 2026 05:23:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B55FB6B05B1; Sun,  8 Nov 2026 05:23:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BF16B05B2; Sun,  8 Nov 2026 05:23:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 885956B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 05:23:02 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B54912020E
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 10:23:02 +0000 (UTC)
X-FDA: 85411563804.30.247AC07
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4CF6D40006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 10:23:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZSTmmI9v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.217.45 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794133380;
	b=BW7BjVRcYTwqSXbGcbLKbZxEJKbuekW+o4oklWDXQNep/Zu4D+hhMz2cJ/RZs0x7JDrMC1
	+yW4J3ThVHxKEjKjaaQ49lOYrRzdQo5LBpuhQfFB0Vqdvkw2Sd0w6BIzTKphYtIX8V4ukB
	Lz0YDsA17nwWzCcJDhlHaJVGL73R0O8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794133380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTRlnQ6aw/9U35t6NClVMTXH5guuqvWv4jZ/7tnzMkY=;
	b=vBVAf5I/Qd3mtUG0rdjcXxONSaIpkFXHYSG83Yy7KDic90XuksIzWJcmG2MiIMF9ovABAK
	TLnxwqh5jxDpar8smq7Qi9XXR4mguMZN1yKpYbTwGU3qhiMsG8DoZtbdzLha/dlj6bXwkC
	6dfD+dYleTyxJimWNvXoDy+/JC37nyA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZSTmmI9v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.217.45 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-7d2bf046d7fso6144137.3
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 02:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794133379; x=1794738179; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NTRlnQ6aw/9U35t6NClVMTXH5guuqvWv4jZ/7tnzMkY=;
        b=ZSTmmI9vr2kc10eYpL62c39dTEbRaxmaUfad8MalYr5pG0X3TFTEpv7IB6/152GTNr
         GKyksMSuRWvtax8ohLAoAz+qMWyDHZ//BGUpHsqAaeiLate4sbz3TLa7hGznpWGNZKtF
         zWT3Vis5YHVtDZqJaCHqFyYRgTppya0VQhmG8XQblPr1prUOLWFq53U49VRDeq2J+QkD
         fg9375DKqmzu3/DEwR6qZch3qUbdIke+Zc0NULIG3uNOdMRXjm5wjpf703WkLBJKaNMt
         k3AXDBj/v+RXf8qOYcaEir7BkxFEhKoHiPLu2ghNslzo5RC+8jtT643JpeMKnt7XF+5e
         dczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794133379; x=1794738179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NTRlnQ6aw/9U35t6NClVMTXH5guuqvWv4jZ/7tnzMkY=;
        b=fH07AJGAl00gmQYLw00m9fMxROWtZyjIbrU0WFvq6DExTHpVQdYbzNa+uIrH9O24Sk
         0DaolYaEcCYE245bEKcSdR+xubrXswj6b+g+rt7B8i3n6HfdSVNT0fz+e1R1HbLKQGms
         Yux9BmZgxtgk/z2c/WBvYXMuRKO4tWNy47ITUxBjXNuqzWBSF1rSgT4vdODnhbghZe64
         8qBilGttCHrrxhJyEk1FmkOjXaMvYTEfxam2x+sHtXJTmZCZG1IeNH5hI1dI7GRPzkCC
         ydDo+fr6JPzb61gm9poAQE7a9gaPpG5EVzuj8fFeffye4JEKxxqRkIiZ5K+ARw0fQSBf
         zMCw==
X-Forwarded-Encrypted: i=1; AL+hErHUnEoVIkCLqqXzZqishcRgWtubUu+XP56A7SHFmDz8kx30Qzd3gRbxzH75F+ZaI0dQkuziQ4KRUw==@kvack.org
X-Gm-Message-State: APuU4Z/ZSRGqLNRWNa8Iux7IZMt4xd8Q3zWP+ASDGYXxIeS0qHiw9kAK
	zT78x3LgSV4+1sHZ/BVlxDcAvlqj7CuHt5yrciAOnvp4qFJE3hvfv2M7
X-Gm-Gg: AYBFou204lA8LB04PpZe0Kp4eyoTbIUd40ZMgo+o+BTDiHp2RmtL3pa1xk6pSoWzdyX
	LqG7kaeNWLNq59jn9cCqrnCuga+8g4wA3E3dzgV9GmMzg2ZvjWnOZRxtu/d8AlC/sL0IOW4OG3O
	ok1/gEuoer+3gzN3Sc0RECoH+8/PzKnOb6JSTx8EaC/FNxgRxS05s95vFWnrwjXkpPkdH+9AHxx
	KFBMsw5aIn588HOn7u1s3wcdkVkayJF0YrfQFP+sEVXMU3PVD3Vo4QKm57DceDQ1zVO0f4+CdvR
	oWdib2GPlyb2r4t2JQ7DmTlHe72uI3jRLIKVMbfjDga+HYmsLkJLdHwx222tWH2JHbZxRGCSqUk
	7JWE30KmYZ7arkQmz32rZpHwhTZxQzvXzcETrg6qBqM29xdQxvqOyO4l945ntRUNFGVdejYuXbF
	rOYTh7GYI4zs4NJ2vIvpEQGVJI6k0al1RO15zGT9rA569WMYpEWbxwH+X2RPmYaoaU0RoseBrYS
	iq/q5KUeKRUrtd8AnQNnFiw/QZpAYYlQycPRM9BbI43JfeQ8hvaZD0XpcImcvk781yu60o6rhCX
	p48aT970HESJFaOVDYXnS6ew3xWzIFcE8bLidG6SKHCzDfi84tP1BmvV8WQWSNVjHDYReqlcQn1
	ay5fK9fFb+8jgQhXsX+jxHYiQ4mab2A==
X-Received: by 2002:a05:6102:84d2:b0:7cc:24e1:77b with SMTP id ada2fe7eead31-7d2daab7329mr227009137.4.1794133379366;
        Sun, 08 Nov 2026 02:22:59 -0800 (PST)
Received: from fedora ([187.120.157.132])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99c02a4da96sm1405537241.9.2026.11.08.02.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 02:22:58 -0800 (PST)
From: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	trintaeoitogc@gmail.com,
	vbabka@kernel.org
Subject: Re: [PATCH] mm: clear pmd in pmdp_invalidate()
Date: Sun,  8 Nov 2026 07:22:46 -0300
Message-ID: <20261108102246.178548-1-trintaeoitogc@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <bf5c4e81-2c9c-4f4a-ae7c-9edf6a524d1a@kernel.org>
References: <bf5c4e81-2c9c-4f4a-ae7c-9edf6a524d1a@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4CF6D40006
X-Rspamd-Server: rspam12
X-Stat-Signature: 38qrhsxbj3rng19b33xky4nf78ni8tht
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794133380-364716
X-HE-Meta: U2FsdGVkX1/5DAQ5g9DTOkYPjog3WeRzN5noG1QTFwV3H7MoL6k1wizA5atoM8jAsvbhY5BcRZlhja3XnEGuIouPuIgAKbz5PvlrsQlD9zjIkFviF8UfPyn2XStAIDQFmqFRjGjK+iggABUyNxMvKAXWxTwQie4WYL44LuJDkAWq0WVx0MxLBgQ1XUaqyPeWUUzg+TwDG8FzAvub5ZD+fBcKajYaQiDggLkfXvGxBz4nyCgwGUVIUSquNNjdwBWLa7ll7oRK9Mo58YDMuf3OJcJxu/KzAFvMO/sRjozIlGjcJmBEXJiEzkFRXFkhchgFFN7SpJzsQdZDszsYgtuWy6u84XcfmjHws0DvVEGh7QinRWLVXCuelFsG/Exjy4B06wQIwhSZQGZivjmKw2o2bH1AgrtloxuMviL+xgv6ABwqpDHoLl8ejPjS0CR1y+qbuQAZuqKzEMP3kb3SQHcaCpxG3t7mauDBrV6jRBX4HP7v6HYr26d89oYKEN/V0M7bpNaYX/kCib23owa4fMN+EHNdGPlMJXPfzQGPFIyoHIHqxPg3GUlCLiJ/evM+GGZ949wvGvwnmco3eK5UnbI2Sk9RN+g8Lk2qRRMsOK17jf3OQL3NOQ8l55n/KxfxL5MuzKZshBKwOMxp5OgjkVHp+v8wUJfn5RxVfx+vFgupdIsp+kW21zJk5vKezgw+96EYatEtx3zFRZ83mg6pw8orTyvvNqUw0XZdaZ4m4g/CZUQiIlNkxjMP6Hw12U8Ap+q7z03OkNRdRSk+mSaJ5R29kVF4MJ/yZF8es/b9iB3eRVVc33merPguJo17q/BH8KPdGT9b37EQw1UHS2r0QnlFC46fNWHn+4IXEbJ+XGFlQK9ROiOkpkAq0BH/L+jOukrYzTzWrMibXcdwrIj4v6BboFFrymMNRSln6McHRlX9SjAyy2wEkGbRTCo1h4y7Zli4rC1krjPJLcuxED1LDi0
 V67/hYl/
 PFhri/A1gACdHe+PkzZcBEboVaW6a6VswBKQsjX7YfHgGVfbRogEAKjUtk9NpN1B1+Oc4nKB8t3g4Bx2H4E7v8ZIzrmyd9imKABQgjIWXEj9azvZPD3deJ93DeoPrtzqWeRb6m/VWZJXK/6ixTpN0nEo42OezwkthUaUv0PDnDcINTeSWfdFqNPH5hI5SJK/vRKFh9aSnDc5WT8YQvWsocPZJMh002v3PvboOs8cQ4rnONWIJ2Oz8ccfbjIDl2FZANBR6I/t6bLz/89Xa6u97i32UxXdL0pQA56vzPksUy43MpCP0GqZzEZjlgKyA0ccm1GuTcMzIOj4RyMaJpYF2V0AnIsUlImhk3dBaOxG47GIYpf9SKfxGCpypA6QB6eVshZZ28tgaNAdOP9Ub/lkh1VIyeW7M+KeJpe/nok5y3f5y+8LMNyMiPqmiy1ep39kTIwS9tswaNXGQeeUDms0CWvIPFIkw3rvBvvyLMnl+fUXVpZ8tQw/A2XsYK4Az8LavVyZH+oiMra2f/44esWcF/cPFD8ktdU0OVIEj/fYvl8Fazor2/ekgGB0ZHKJHWdwui2Gn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"David Hildenbrand (Arm)" <david@kernel.org> wrote:
> I remember that Zi is currently also fixing some pmd_mkinvalid() implementations.
> 
> Is there anything to fix from your side, or does the above fix already resolve
> your problem?

Yes I updated my kernel repository, tested, and this work and resolve my
problem.

