Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDAB8CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 16:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6AB9000A9; Wed, 13 Aug 2025 12:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AE59900088; Wed, 13 Aug 2025 12:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C4719000A9; Wed, 13 Aug 2025 12:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B068900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:17:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEA23137EAE
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:17:12 +0000 (UTC)
X-FDA: 83772238704.29.B25C16C
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id B477240004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:17:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=In9cU0gt;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755101830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0r8lX0/1M6KsfijF5/m66QhjeQjFJTvODKoUvnEDMw=;
	b=2gtNNSSSIsJCn8l7FxQTZwQ5nEr0MQJSBVGlIQkJMIAqdYnd5SYj86nr1VbUN8zXVTDpY3
	XMHNzKXeysmCCAuzvgEz5Lx/wZrU7BG/CSRcfX8ZN952e/bUpirPmGCevzvSbKPf7d2uDT
	wc9u82jrJqyPf1AsDrJR6qbTZhM0xCA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=In9cU0gt;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755101830; a=rsa-sha256;
	cv=none;
	b=Y5mn1lB7DTRK/IuhpUOuUY7PcSd7qlL4Mb9/bUPWm2jpuJ+Vmn52CDh0HG8uwaeyPkdWgW
	Cs7Z/Flc34LgQb060JSGY563zABM3XE5nkIAMiX+SaAizOgW2iddNRY7c1QWAGkGsmpQaj
	y8/1h74a3bKvsZFU/Iz3QaEXfIh9prg=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7e62a1cbf82so478770185a.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1755101830; x=1755706630; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y0r8lX0/1M6KsfijF5/m66QhjeQjFJTvODKoUvnEDMw=;
        b=In9cU0gtUXHyMraglkh73efDg4kQUiWcRS9UcDHRsfOypYvdfeGcNL7TwAC92HDray
         qqvqO+jzdouTqho5qNdX/l3bR6DJr66reuAfPgyUSvW9dJqPRUetKqy+uuN2bEK0wttR
         UDQlk02iwI0jkocrTrB9h0XQkHYtQFcHa6nFob97kpPZxHoyM9K0JgvheXolnHba23kI
         i0BXSjlK9+ARF7BoRDQzrdWyYbB/hVzDiHrQJIJg4vwJe8AEZa5j6oeL4t7ZhB38dbx9
         M6QPtun/EUEgEbyBljY/QBVRcWDylAywBl6vxccD2tsTqItuHL4WykvQDJFJhihpaa2A
         jojw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755101830; x=1755706630;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y0r8lX0/1M6KsfijF5/m66QhjeQjFJTvODKoUvnEDMw=;
        b=fzzSRh7UiiZj3yIRYOMfzX437UDKuDM6i2J0HAnKMrPREAL0pNRZiUG2IzHpFWLyTU
         PmaOmSOUUMD+zZxCnbvvhOKaSrf7qcmNI37MMjAS68uToI/pCVAsveXIqc7hT79yi/xK
         KbwxCrHKjq1iOOw3GliR98yLSXnCC44PrHjf+UItAwk+wZLLDwcrLvdFZOsgMQqImTdm
         xG4LniUbj0VyfUdANo2UDRAvINPNr/+bUM8S0XrU6RGY8CJcLOXem+9XVMlx1NTxM1R+
         iJVoYVxrD2YM7h7W8lAPd2aQf9dLec9QQeU1uGUumZx+Ky4GXA+Vx5zg29R+CDWmIXKb
         ntuA==
X-Gm-Message-State: AOJu0YyiQjKB8Bcyd+p35A9cQNyaXAZjMvd/5mY9Zldu99dYQ9o+QRhB
	KeXSiOIL34gs02NgGkUhcmcKJuw1YLItlkp0d3jpmSmLNe2g5UYLFAvYVhHl1AcxaBs=
X-Gm-Gg: ASbGncu7rstFWZ7QySlV2OI+PzBTwIfy95lNdkXPBVmp+7xg2eOU9zig404/3P9Zjkc
	jY1IjJOEWh+QDSQOEsFl+9RZy7A/NADUs5FZss4LLdEA3ub3qjYu/UgQ9JaFo4a1vRbtGO3qORj
	UPzDLUiISkqukAge6E/dzCbtc2osVEQSNiHpSEEHB7XXh8Y5UPNg7Q9gYHFmSGHhejJoGIgzLq/
	tY1sn17oSctV9/SPq6TIc1DIlh7NdRBQUQz+70Gt9qOqNHO6Z9MPzgc/wTRDy6xhVS0VCqFTxTe
	aWZ2Xdw1u51V0q0qxB+Q0JSNsOFzALDJo57+ksimetoe9xgdAtpvOD067Zq+H1hw6CIaailiP9i
	wqvJRfsDUJxYNNwG3nnEb4g==
X-Google-Smtp-Source: AGHT+IGHCZVUArn+hQTSYfm5ZLOiQRAX3EihSL5rOgIAp2pUobtvdJENs5NTWAKywrm2ri8umYv+Hw==
X-Received: by 2002:a05:620a:560d:b0:7e0:e7b0:967e with SMTP id af79cd13be357-7e86522c104mr386843385a.7.1755101829593;
        Wed, 13 Aug 2025 09:17:09 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-4af230d8a21sm153187231cf.51.2025.08.13.09.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 09:17:09 -0700 (PDT)
Date: Wed, 13 Aug 2025 12:17:08 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: Optimize exit to user space
Message-ID: <20250813161708.GA115258@cmpxchg.org>
References: <87tt2b6zgs.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tt2b6zgs.ffs@tglx>
X-Rspamd-Queue-Id: B477240004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3but1hjbzzpy3nhj6d5u47hpyjywqwts
X-HE-Tag: 1755101830-346267
X-HE-Meta: U2FsdGVkX18zmUywSX0ATFkXKqN8HtdGSsF7usrNmMMZr9Xgtrt2iwDb5XgfsZERS+EiQjK3qhrBGHdLw+iMW6IpeqwskppSJVrTLEnf0YoiqE6wydZVdY/QdnnyTpVU1Oz8sttEfv8gkuZFhxZ2K3FvtrqGcXgW0E4blLORksE6Zd3xwM6Bi//85tWDEeWRnjiNfrmH3Lz23nghewWhQUWmKQjy4RQoFIONmOJzA7Zs2ZvPhDJI+RYvz1AVCBb5G0QWvPHLORGinxZKRHlvu7nUX1RhZOSm/ITz+MxA2QEJqGcJXBrdMp15VIVJCr2D94+BHTA1qk1/uuuusQwU5NHjuSQOwkdnjw+WgK/0YEmvm0+pk0EjBqQdfJfRBphH8cEIrnzewAqF/XyZvT9MbQ3VIO7dwgSHtzcIJ9A3fEJzXJ9VS4frrNiGnj+EnX4I2Bc8YAKuNTs90EQX34+GIdTbgLus2uVRV60volVXGjUPw+SFx5msGor6VCKNa5djcMZoxcqK6B6GY3q1we7Xnj3JijD36s79KzaglPovuRuE1I5V95UYXI/PDUpR04arMRJ5W3AULQnm5SJOr2zO+popP9tYldPLZtlcMASxMi4t55csVqZShr1e8HAmjnURpgOb+RmGfoQX/L/7y1YHBUPrSSzbfBoInoWQfzyJ5a63MqsAOzwrYXFgZq1V5lj8Gb1xqRcbSRPaTvC6t7QB2ZSx+yI7WulAGAzOGzm2gvfXtDkv4D70KNCCcucPaxB5AhJN+D2ueCSCHd7Bajze965JzjWM7YkOb75KpPPNOPcLVNndK8hNOPJDAUNyi0QhF1lCnpcZrqTCMX1erd9cnFXP3ReWW9rahBPyBvXx+SZy8o6CHoKjs6MxQzgOGOWhT522Sie84sMqASVLG75rlcTv/FdiaM32B6uYv1/X8mkrj5/wA4qhuRF2cZkYqdeCNQHpf/IYZcqwMpds0tA
 aTxMkjgo
 wm1KBzrKM6aVAKHWDSPBHhbb30SLulwkudDZSyKx48ahxR2+/Ypw02mho+87kb45EzPO1sls9EwdpVkHq9YSL23K5alyqgXh1CSW/yKWqiCZN7ybo17ac6KXuInjcKxdi2ikmR0K5OKH+ZsKA6NL5dvyq3eAvXHHpiqBJzblsJpCB54Rl869QHWP8Ks72U2CQFdbJmMN8CbWkG8Fed5AMLsEmFvzPzfMzUDnsprBt2hOVwH4fmTXv7X/rQicU1mPUbV9y/YZG6xFF32/rqUJ2bqPLEZG9eci9jW+X1cuQKirJC9LrvSpv+De0Z+KkQFw6NPE7+r62FcnZl3Ttw+23VXyBu8X62PfRTR2IVQZ3TUy+JmzLYSY4JhwhLrUyhoTvPrAqWJsnPceF4tRIBmuTQl0QUUpPbUsM28UKXLf+88N2xl4IwPCrLwSKpZ+3w+pPCx+tm/6m73DQV4+IAKWVvqF9EaC3pqxJYFburJak9o/RvGACgr1IxEOvPmElRHdWtuzNBvkvCySr0m9L4px/Q/tnWAJdgA/YuAuZCZzgALKYZnoV2ei4ApIfJmGa/Ji6pSukr7YywtPxvndaRbJrTT8a215q/uEShwPR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 04:57:55PM +0200, Thomas Gleixner wrote:
> memcg uses TIF_NOTIFY_RESUME to handle reclaiming on exit to user
> space. TIF_NOTIFY_RESUME is a multiplexing TIF bit, which is utilized by
> other entities as well.
> 
> This results in a unconditional mem_cgroup_handle_over_high() call for
> every invocation of resume_user_mode_work(), which is a pointless
> exercise as most of the time there is no reclaim work to do.
> 
> Especially since RSEQ is used by glibc, TIF_NOTIFY_RESUME is raised
> quite frequently and the empty calls show up in exit path profiling.
> 
> Optimize this by doing a quick check of the reclaim condition before
> invoking it.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Nice!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

