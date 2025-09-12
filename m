Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5420BCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 05:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B02E8E0002; Fri, 12 Sep 2025 01:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687CA8E0001; Fri, 12 Sep 2025 01:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59CC08E0002; Fri, 12 Sep 2025 01:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 47D1E8E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:51:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8C031A01BF
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:51:52 +0000 (UTC)
X-FDA: 83879526864.30.354C2AA
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id CBD40140002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:51:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UxFWwDVm;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757656310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wwxrf7orhL2KYO0iCZZdsGPUWyavjuMuxgjcqzj0tsA=;
	b=IyG+IKAFW7vLIwofCrJc1K17BK+/LQriJrIN4W10lvwI8d1rrQRxqQ0pKH4tlaVj2UClsn
	js38Vp1VWPJDw/Wy/rXVtXoc5ETJRNTkWfBecTzmbyeV9O9pdblt6b2BaTc0lCa1JMGCKk
	j8PBiThj5BZhnfK7pgEU8LYg3niQDy8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UxFWwDVm;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757656310; a=rsa-sha256;
	cv=none;
	b=ETHZjitV97zv15pLGEuRmg8i7bqKf4q1jtk8d/djQ/N0fUSEVISex1gB+KsEN7ajbe6x5Q
	vs4aSpikSNYHEfXM5BBoieyWK+/bASctE+X57sqKfzQDL6hs3fMSNlkpgJAFLdGHYJlWHQ
	8Z7jg6YQckehxJG1Ca8aWEGzTrm4z/8=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7724cacc32bso1284789b3a.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757656309; x=1758261109; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wwxrf7orhL2KYO0iCZZdsGPUWyavjuMuxgjcqzj0tsA=;
        b=UxFWwDVmSpg5BUd6QnvO/1LV14l4gqY4qQdhbSYo4jx7GlcfHP+tG0pIHUBgT/BGNA
         QxqWY2tlYltwi7LfMNs4PtMwP8o03sKb5qPNZYp5noi0yzVM6hMYEG1VmEt9vNNylfeP
         x5ZMaP6FCO3EU+RT7x7+D1mVLY5+pvKe/fLJ/fBbWLIy/ZB28oEAJciGol6EyYu0S72s
         /wH21IuekXQFGl5hNNYDwr+6kgtXxWxeuFS2+Bd++qXWCJ6xO0vyKOd2+Qe95pwSP1Lc
         6hq/QDespxoWtgmJ9kAOzYmjzpcdsCRjpWwU3z2bhgrTm12ck5zTvKIYJRF4no1K7lx9
         IrtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757656309; x=1758261109;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wwxrf7orhL2KYO0iCZZdsGPUWyavjuMuxgjcqzj0tsA=;
        b=CMGEck0ek93jFjUDyHnzGkFDhXiGIn4uusxJVPNmrvqt6xXr4sunBDJMbr/euC5BZ0
         fXzaCIETkIayjN1BPVeXrMwxu5b2koUQllN6mGDlBumXo459FQYI8GLDZ8UX9pQuHPGy
         84O3lPla3PsxKhyNLHpN2mS/YLjIqAuJGabm8MbfJJFK3laGgAGsHz1LFGrLNZq1WY0s
         7X4wQm+fYI9LUrYwuU2IGnoUr/Wu4bo8q4XPHAZCp/W2WsMvApyCFmjb38sHP2QHvSPz
         JKrHAk4F6wn7aZaCrbh3cPnAGon5iZb7gcLbmJJcTeic23F3X08YN0KUMn0E5Ivr4uNU
         +vMw==
X-Forwarded-Encrypted: i=1; AJvYcCVof+vrX/3tcFf7l2eXYsYy+iwZOYtYdRxTDngnrG0OmRePNm9fIkbGUX5g8DYSepGmangPdq1qIA==@kvack.org
X-Gm-Message-State: AOJu0YwgwPeH1RrApXKrY0PYtte/o+298ZCHCZsfhlG8AWhkPkkdxiYg
	L9dJyVFii/lc+6AAlRvQ/EXXw7GLM6MZMyI/cSW1ijiAtDSZB2WSAH5E
X-Gm-Gg: ASbGncsb0GIn/jbrpzDan/F6iu8TWwxp4nNrR0ILUGZZFdMfwobX1uAVzh/uM7SQqO4
	xEFyqUUb1aQHZWEJQZ+cvjKrhMIV2FnEuU3sWjTq9I7nCkKnq25ewqH/0hjXO4LNXCZHH0NqcZz
	kFTCoAY3D/ewU3kT14BrNkWK/3CJN6Rh3q5rJWNJpPYkiQ5cUpQ5HsVE8MG6hCeU1UTbk1ieBOT
	StVKWjm4lW/b0bzEd4quDfOh+I/U5QcjGyxkP+7ARUVQhpqlv+2mPOrsKSsVhJXXsPk0McVibTS
	ElBUbg6kKcu9aJjAM4N1wDh5WJ2ScyXn2fUO+dDy6M5380b3YwOAqC8tFMlFVhW6yPYYIEvuoCF
	Uj7ocpHlVzoDUomQJ7zTx6vd9Dwi06wM25UW7vOWkWxwL4w==
X-Google-Smtp-Source: AGHT+IGzJaB63wIa8y1WxrhARLk2qyeDzg2l8cffF9pjyL26hVSSSTlaS01B7UHtSYXcq7zGWNVPeg==
X-Received: by 2002:a05:6a20:7f9c:b0:249:467e:ba68 with SMTP id adf61e73a8af0-2602c90cda4mr2342631637.50.1757656309414;
        Thu, 11 Sep 2025 22:51:49 -0700 (PDT)
Received: from localhost ([45.90.208.139])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7761853866bsm450111b3a.95.2025.09.11.22.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 22:51:48 -0700 (PDT)
Date: Fri, 12 Sep 2025 13:51:43 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com, "David S. Miller" <davem@davemloft.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/19] mm/ksw: Introduce real-time Kernel Stack Watch
 debugging tool
Message-ID: <aMO07xMDpDdDc1zm@mdev>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910052335.1151048-1-wangjinchao600@gmail.com>
X-Rspamd-Queue-Id: CBD40140002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 1dj6e7rsoditsgcrwwutaaor6ajwj78j
X-HE-Tag: 1757656310-236579
X-HE-Meta: U2FsdGVkX1/F+gjdMbIO6UhrztDJ76pjlPrjO12NOnVTBVLvyw418sdJEWPiOkp6pEgUQP/tW9RFparuZWR+YczgT5bcs7d3UaPXAnklzYUHJTpWouJr7BuPTtJh2rVO2JcQ/ktK7ZZlSU1ze9p/egQBOKDvHZMcrLg+hyj5Yj9pb8WK3JOHVd3/fyczWFZiaJ/RwSvRdCn9TetP+3nVRZvf4LCXl2H7jtVcF5ynOm9i7onmXqzD+hyQghCUHiZuseHN5Ke6EjeAkFFZYZXsx7aCY7A/XVc3d07qEAUZK4eOl0YTPIG1BGiTA+YZqzPcNBElsMQNZzmjp2ZL/hkfoFs25grW4uFMFHv8pKjeQLyQGOPEil16rGG+2mENZWWuVdp+P9CnqR+EDVaJyoBug3Q3T2oghg2iqHNp4Oy2HRDQR37874lW6fhGKgzY8tjvvX7dDf7r7RFNRf/LXxEkfEc+azVpHCWEmaxObeEctMIAYdVFZY3IqUkq6eIM2TW7u8+P7y+pMgYnkjEroWDH/QDGEMm1b4xxctYgEqgY+6h5T49lBu3FIM2vD51lyP8AM+i4bMmQKN1Sjiij1MZPNNj4zG2gHoJG7yemNqqTgQZpJ0o5vls5HSKL7nwFw+pAXEw8KiqO20zZGB/J64NaA7+n5Oqn8DQG7oSqUrVLAJnQaGOc8/uHF8xAlaYStl/4VLCxeD9WYhuT3W9m5PuapvdY01B5qDW0lKmd7wAWDYmZ93LI/Ei/ux5Nsn4cn+lYJ2ILhagEO5VTo72nlko0xDqItkuVqc6GxevmP37AKV4+G+kLFDoWJibElgSzI1R+YgOkB9prx2HySpL8PX+btdB4HSe0chNre7ziPRIcNEtClYJ/PGbnwXASuJmFIeX/sTxXoFTt/v6ypeoe4Cg6tnUyd75UHA9v0hPFDTYAxlmEECCfJIb/sVxkeR0mBk1WVXXhgnPcggwXh+7BBq+
 Ks35jB+g
 3oiQVtnZ6aweeSNU8hG7225vyjBkrPuhNaplzfJgoBAOFg/ur8vWfqg7YbshDxYwdI9oXXyfzh3vPosZflTc/Z1bKcz6TqgAk+54lCYFL/PzL/1T2EgdDJuhlR6SHebROiYDiLQbkj+yoasWXFIYvkW0O59f19il6wmGQu4pqfv/17Kcrni+f+HmiardV/5KeAEURr72lHGuqHKYoEUxCbzKzCXpNkuyvsdqlD7+iNwzjHbrJSQee5XazQgAJviPQbAnJTIWqmQCI/F0BeC7zAt1+L7KeQukFHx9DIOilMCX0AbMe+qLNP2NBLNhRvz9U37Yt+sFeTzFP1zHWgYkEqVeN8NQH+oAjqgWu1ep4YPgdvWg02RY4lvWjs2Pm+zd6Jhul1rFSE3r6xsNx6gt19fo3cy475cGLMa7hcaBdjLmV+U36RbD6kjXov1PYLsR642WDfFp/xHdo3Z9gQl8PakgukXZWZTyffWyCYQhcrT50QhP7sh6yahwj5eaWKY3rM2GYBgH/G28reg4sFJKAV1TTDAkmSLazuvPKhujtEnOI9Xd8TLmMFi3M9nDuvXRmKwt8KSbl9v7a1Kg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FYI: The current patchset contains lockdep issues due to the kprobe handler
running in NMI context. Please do not spend time reviewing this version.
Thanks.
-- 
Jinchao

