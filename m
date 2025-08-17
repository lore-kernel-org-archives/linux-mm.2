Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A8DCA0EE4
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 19:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1BF96B009F; Sun, 17 Aug 2025 15:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF37F6B00A2; Sun, 17 Aug 2025 15:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E30746B00A3; Sun, 17 Aug 2025 15:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D118F6B009F
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 15:37:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 675041DD9A8
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 19:37:32 +0000 (UTC)
X-FDA: 83787258744.27.17BBA47
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8173B40009
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 19:37:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=a0rfHCpu;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755459450; a=rsa-sha256;
	cv=none;
	b=tMkhLZNI67f7G19G87SCQRiWqDpp9MTtMX/pXtrcPuqkdewEbWg6ZqkQJ82xvQH7uz5HXh
	xyWZavKS8dchvGnZWEE3yCfdGLeKo7NdcpfP9nQhVIZB63eR+PnN6w6hjJVMI8Gb2qQnNe
	PF/G18CYJ7J3Z2KkrQn838Zi74h80g8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=a0rfHCpu;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755459450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OOgGDsYpV57/W8Toy6B+hnOqdrJoqmubygLXKp6pFl4=;
	b=ZKRgl5q6jQMMweqPdH/c+8KJAwnJ+BLwRmTLWQ8UEa7t3zyyuD0ARzoiVw7Byom9buFDZO
	8CXtceBiluZZgOUdLExG9gzulm3bwGHCQk+SR1OkjIU1e9k50XciC87a+WiU0YQYbKfVUh
	B1MHkBieWyoDlIlA0w4+09/jyo9G4H0=
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-45a25ce7978so5394145e9.3
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 12:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1755459449; x=1756064249; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OOgGDsYpV57/W8Toy6B+hnOqdrJoqmubygLXKp6pFl4=;
        b=a0rfHCpu7xm1AhqKNeix7vh9cxykdrtivvMdLWKWwmrE1AWrfGjnpZifiXKvPp1MPs
         q+8kh7xq3U17K1OEVHFQiQAiBfctkTweD7kY46WbZyHMPIYfsUHb5QsONF+J/emz9gKj
         l4TBtm++dms2s937uyLaMqN2Hp7L+i17aFu6f0VVm/uYAxCeV829FW2jr5zonCC0QUX8
         yZHJPoPrejdHqZ71DRA/MDx6kcaOr7rw400LR0Wl3Wx1dNQCJYBXGJ6XdJDz7aJPI2kG
         aV6iEHTgwPi+sNQRNtk6a7Mwlw6H083ZwG2ZfhQPO09z5Q6sglK1vKw5YASxj85Ax3+q
         XcLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755459449; x=1756064249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OOgGDsYpV57/W8Toy6B+hnOqdrJoqmubygLXKp6pFl4=;
        b=CQ5HJh02Nz9nEWrE4QZBkVTjFyyWRtrhZAcKGHQ4pLKF9dUZqXF9pnLl3nJBIdcpbt
         DXgLIJrHs4z094/IH5MCgixW+5uZrPEbz1V+zXyoqS77AUCa6XOQcYsTCnHowyoXQA8c
         kLnyHFuuUVAG6lte25ZnlFKoiSM/9iuRc/MCZgDtOaN93GXReBWXmPcFfKiqBXWZZdSy
         UiEt434GVVH1YHPEae2bb1GOGQodMnXkt/l1dskAyyvAa7hlGJeyOvNP5E2CIoPRPkv7
         6ofn7QVOTsl+xhYFfSN5RSOLhlPdeP0LSR+FHUdpqAB9SiZWBV86IVqdsYxYXHEbXkij
         vV2Q==
X-Gm-Message-State: AOJu0Ywz2/RWYKE2TY2Yf6/4CzHua/6rFADaXI46sTAJMvp55eh0QeHI
	uXAU5O33EWl1IHzTAyJhPFf1lWF6ySn+NFFKtuMQb/QRwd2dfreUYnAc+h/atlO+XZg=
X-Gm-Gg: ASbGncsL+wtP1XUEkASYoQ6b9gQ6hCnVP+coBj4ZjAOUGbke7hmXmW+xwYKno8aQ87v
	aIXY3ci0kHtGo5UX+HO4UfPkA628/e45AnPzuO+Lw0I85I9dv3bR7/A1t2Bzo9X2mhMPvszHtIR
	MPtg+PDsbnwvF5U/Afv2eIWR1qErPeRGfW3cfoe3KxKBZIr5wssq2moGfpLEBc3M5WB4IafHutG
	SQx55mnu4XgEu7dzjz5kjytg2AZyvYHosNvcM/GWbOpySFjdtGuXPtlFU2F5oBJ0DYj13vQIwSO
	sz2dEkrpkMLWQdKbYRqW9rC2TTiKxskz4lJ1+T25Vl3rRIjXYOB5xX4nvUZBvZyBc29FMXPW3dG
	gUsNI4sUunI5PWWrwvlU3oBrXmDc4oERg5IIgUnD8/NJiMg==
X-Google-Smtp-Source: AGHT+IEsOhkfxrKr9sjeVX+iZz5YxDYnWDjwo7hxMirg6nhYueecpLlVylhw4FLWKnSFN/b3qszYZg==
X-Received: by 2002:a05:600c:444f:b0:459:dde3:1a37 with SMTP id 5b1f17b1804b1-45a21857639mr69799095e9.25.1755459448909;
        Sun, 17 Aug 2025 12:37:28 -0700 (PDT)
Received: from localhost (109-81-28-101.rct.o2.cz. [109.81.28.101])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3bb7f02578dsm10423195f8f.62.2025.08.17.12.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 12:37:28 -0700 (PDT)
Date: Sun, 17 Aug 2025 21:37:27 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji@honor.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, rientjes@google.com,
	shakeel.butt@linux.dev, npache@redhat.com,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	peterz@infradead.org, dvhart@infradead.org, dave@stgolabs.net,
	andrealmeid@igalia.com, liam.howlett@oracle.com,
	liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH v4 2/3] mm/oom_kill: Only delay OOM reaper for processes
 using robust futexes
Message-ID: <aKIvd4ZCdWUEpBT_@tiehlicka>
References: <20250814135555.17493-1-zhongjinji@honor.com>
 <20250814135555.17493-3-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814135555.17493-3-zhongjinji@honor.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8173B40009
X-Stat-Signature: ht9hrpr1s9k75p69f4tn911mcpzxniaf
X-Rspam-User: 
X-HE-Tag: 1755459450-360318
X-HE-Meta: U2FsdGVkX19ya+CazVx9bl8yk7UWMp0RokzVmMbR0yPpAyk9ER50fjTOkz0akpDAbHml+Vk5ccR41jEXRSxv5vm2CfA7k2TMpVOXXYzVV2/teSAazIK6OAedFK601olQb6P7/1NVQFn1IYO0WRvpRuqhp33LUVrQIUSK+9pHfGtS5NhnsN2bgYxBxhE/cL7i6P15kMbxRRjPU6s0QzCa8v0ZGzqx1EKDpEI8P6DRzzH3KbXjYgQXqIJQuq9XKPsl4kWAMFoIjQxF2hRGOBl6OBubQDQ3yMSnkQVJnydA0y64wMR7bYvHW1Qml+SRCyVtOLkoxNYG0vutT6eWYsGJhQMF4dYVTM1W1ie3mWMwnDIMbaII7269+3Iz+lBxM5SjWAU+Gcc2UiZEBNHwr4SuIDU1cI9u46Tn+zpYJOwhe0hu8wmQSyUvbAc5RTffg+jkoB8Mjh50xcPpd7egKCFeX/2Y7RFLFpnQiU7OjlHx4Zn0utUweCiOPEAUdWgc40s5mwcML2VNO/9i7s4zfq5j2eBzeDBSiHMV2Q2DM1bJ2D5ZVh7RwDrr25BRf2LvgFiFRX4C/KS2EV8XtN1bcHauT/v7CtDsylpgUFyDct8JkrycR+uo1VhzxK7QI66rGu52CKa0IPZNXxQDAY3aDqUkfqcWkr766bGdXA9x+am3PwhmXMFzr1hdb9nncZHBAEdbT7kaiiw+enU/Wm2wT19utISTeDq1+24PwMFeNyh2R2J/9FE+SPkz6PukCErJyyNvI54X/k2ZMVt9FSGMIB8D/4Z37xFVYjclKgzmMNKCBakqJWWDZFYvnlR0ZAiyEVa36XZtJArpgG62AOYp4EmcV7zbnKspqXibg/6mt6oiVkPjhlf8/fk1gGtu6c6d4yPcInsqM6b4rLQC8a5KB3q95CodSWrRDOqa10dGS54JOhW3rTyFEbp9rX/n1NArBCzl2UGxeiKRm0/l4Vuayhr
 m35XjzQx
 Je6rGVGfXWep0Xhb950gThtPkIWlInElrM6i+PoMuQPYcDMao8V405J5ks6u86zgJx+4NT/gwvQ0xNZxWSvxPLTQCvLiH8HljXURJNyFGtuFCD7O8Y1yVhAKuzRAkBox7vqtZTzvIe7M2ey2yn0adFYASLHuzxb3Yhm993YlOBWgwz6cKJImVnmhIdgfQHkM4sH1ms1SOMF3LHRR/4eVJOI3GSr5WfzaNHgl4RqvX/6UnrXVnAolG9itrDTcFwArc/GU/E0PlaFPY/dl77z76CJRHZpbB0IiOvlZvBrvt8ZY+9FRrZzWlPDHs+5+vMXSB3ZZEBSoGcju8AIX5tCu3eorMmS3qXG2nNwWSWnGV0ZZiccLqzQ5ygyo1y550xp099icqcmqq3PINduMkNc946DutHwf0J2mRSDyUb4E27BZjsljJDagWyQqPEJ/lyciNTtoqbLcZRytQMdqMRadFFyRDBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 14-08-25 21:55:54, zhongjinji@honor.com wrote:
> From: zhongjinji <zhongjinji@honor.com>
> 
> The OOM reaper can quickly reap a process's memory when the system encounters
> OOM, helping the system recover. Without the OOM reaper, if a process frozen
> by cgroup v1 is OOM killed, the victims' memory cannot be freed, and the
> system stays in a poor state. Even if the process is not frozen by cgroup v1,
> reaping victims' memory is still meaningful, because having one more process
> working speeds up memory release.
> 
> When processes holding robust futexes are OOM killed but waiters on those
> futexes remain alive, the robust futexes might be reaped before
> futex_cleanup() runs. It would cause the waiters to block indefinitely.
> To prevent this issue, the OOM reaper's work is delayed by 2 seconds [1].
> The OOM reaper now rarely runs since many killed processes exit within 2
> seconds.
> 
> Because robust futex users are few, it is unreasonable to delay OOM reap for
> all victims. For processes that do not hold robust futexes, the OOM reaper
> should not be delayed and for processes holding robust futexes, the OOM
> reaper must still be delayed to prevent the waiters to block indefinitely [1].
> 
> Link: https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u [1]

What has happened to
https://lore.kernel.org/all/aJGiHyTXS_BqxoK2@tiehlicka/T/#u ?

Generally speaking it would be great to provide a link to previous
versions of the patchset. I do not see v3 in my inbox (which is quite
messy ATM so I might have easily missed it).
-- 
Michal Hocko
SUSE Labs

