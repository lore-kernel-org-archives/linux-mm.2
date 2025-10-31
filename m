Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D28E0CCF9FF
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 09:31:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A41A8E00A0; Fri, 31 Oct 2025 05:31:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1547E8E0042; Fri, 31 Oct 2025 05:31:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C088E00A0; Fri, 31 Oct 2025 05:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF9468E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:31:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 555B112AFA6
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:31:42 +0000 (UTC)
X-FDA: 84057892044.29.2EE5DA7
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4371C1C0007
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:31:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CU0PE6Ir;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761903100; a=rsa-sha256;
	cv=none;
	b=mmiev1InV7tVVGwW4vG9zr4sbKlwHZrbR9e9q5FJKJmJQ4O+0hb/QQTUxKSg1Ud63fn1yD
	8TbPjNgPwneZeKAmY92uohMkunLrAFMo39xN8NHZnNsFQYDT8uWitb3cxE9UgvZCjjyDHD
	lED/hVghw/xCZKlX/PpOSvKMmPTT1yg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CU0PE6Ir;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761903100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZqsIXX4i9fDMKAO6vBiIA93QUBSotAqCxkbGp8FfSY=;
	b=p7xfRNAotX3htb18+EPzYPwlLcNDZq2pfc0KtshN8pyC6wiwA/CjlUxmpA65ug9OtSFZos
	j9MLp9zDJg8Ob16O+n94UJO+/89onoK6u3n4BDKLmEM3NszjOvbpkGI6uVRBOXs+WPbezF
	CvFTGrz2bMjZV6GIx4hRn5b2CxCgmYU=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-421851bca51so1790864f8f.1
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761903099; x=1762507899; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eZqsIXX4i9fDMKAO6vBiIA93QUBSotAqCxkbGp8FfSY=;
        b=CU0PE6Irj8xopgpcCw60CasIKW3URawaNP9uDMLvk+zBo5fZOynileBTkafipEqp/Y
         y0ZJtAP5SM0xHASAIfFifT6DaxgIT/zjBLr0PBq5T2Ghr14tINfk92/45vWsZiQf8i1l
         z0GRAGwliUp/seYq5YCjWSrZhUwRBnjfgG4GIEUlvkUezpB6jVg+EeLgqT3CBgzxWnLt
         tsifgRNevCWdZJSSHtAbYJ/MYmmT1gB8oVygLrxxfA8YKRtp5sWem6rlthCPnped4jsJ
         FTQArJWgfDstolXY+l9iMJhdaOJUlOhU4v8Iwm9OHzQANUD202a7eJaRv7YYhqvqLRLb
         DI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761903099; x=1762507899;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZqsIXX4i9fDMKAO6vBiIA93QUBSotAqCxkbGp8FfSY=;
        b=PB+LkwB5AyvbFNo7oTQIdhnyY4R5nzflmG5OL3O/bMu7WXkEgVIADC+SSj9ukKM3Ae
         Gobx34KV1idcPd0uTNqO3xagnof1MfaxwgPa8ikWAUHUOWDJ2KJwQxapSBMgwGoDo40k
         at0NAAmpoLSqkW0VTLhjMaBLOVb/QvOL3gB8bG+nrh2+cGsHVUW8vmgmWWXsOK9pqqh0
         MESW6GrRBVYAfdh6S64FYNxa0Q+gkMZtIgAGvfZweWaEAWuFF4BvayorHliWYubziCfh
         aqGC7ioPyY6w/fN+ev9alenF9HGTKKtGz5LBzTregLFMBiwOn1lHR7kTvlaXm79cnywD
         yB2g==
X-Forwarded-Encrypted: i=1; AJvYcCVquGtMjEq9R5seoDOH+yvlf6a6gFhw/tTNi3YXG6YPaxLLYepbqydaYHebeEllsZsH8M6QmSJPYw==@kvack.org
X-Gm-Message-State: AOJu0YzdTSFmuYCGH2x0wLnvwf75BFrt57spdSCNPQkYNqHNhDyi4go9
	1ZUFuiHPw5b2zkOq+p3D46TF0EcYgcwMIEWsGFDzCoObKVzQ0GA8obuzRhUxAn3y1Ao=
X-Gm-Gg: ASbGncuSGv5bRwAPa1UgsI0zw+/9rNDj5YSzumfH2Qw1r2xPUHJ8smcGiM1dvka11kJ
	Ix5ZS45EwPT2iL7gNaQanSle52GovIZv5orWYpEqaXvG2OkNToIobS922E2TxapGdogdDkJkOyD
	TQf2duzfAKe2lffyLYT/tIYdYRue5o2vpV2xFcZJGBlUw1l3Nb4t5kA3E22SsqIfEVJh/eKBfnE
	PAsLnl/m8cJ4Mtxr7jQ0Sxvn5K4s8cMkta3mHP4VUsvolNp+1wffLyFRuHtYQyQG5UJJztTyJoa
	XrS3URMLZNF+ychw1W38ajicmIQEoYuXHUfaKOXENnAm/sClLd2/x6TUjERl0R3HxmPpFtQapQh
	YcH0fXYbA9IUxWIsMbOLGEQjVtnB3NLZ79BulgxiP7u71vkbIWqcun7s3J9chJGXFnGqV/9RhrC
	0CGjrXwCS91T+sUg==
X-Google-Smtp-Source: AGHT+IG50zQtJd3CIUQKj9ncFkPdrH/t/rsOh53ftoZJnLGX9Bc7esexz1A2xxBb08Zp7FtUCXSR/Q==
X-Received: by 2002:a5d:588a:0:b0:429:b52e:351c with SMTP id ffacd0b85a97d-429bd69ff31mr2719399f8f.38.1761903098515;
        Fri, 31 Oct 2025 02:31:38 -0700 (PDT)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c13edc36sm2536910f8f.37.2025.10.31.02.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 02:31:37 -0700 (PDT)
Date: Fri, 31 Oct 2025 10:31:36 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 00/23] mm: BPF OOM
Message-ID: <aQSB-BgjKmSkrSO7@tiehlicka>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027231727.472628-1-roman.gushchin@linux.dev>
X-Rspam-User: 
X-Stat-Signature: b1mu1oj5i68inrm45nec6qkf8y9syk5c
X-Rspamd-Queue-Id: 4371C1C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1761903100-656301
X-HE-Meta: U2FsdGVkX1/1FltwKXtl4K8G0kB0COTJpFy4BSkrH5336l+3W3unJO8EVTN9NrEtmYmGywpsNO7ysLYfYQ0Um1ShLmgm9CiVVRiu5GHRxzdDBWfThclPqM1+8bOl7VhdwvW3Ueo6fL21/pADuQxoWlNGK2FngD5vL9GGelJ/499C2aA90acyRflM9LUiEvgfRP2QUUY6U3qLaxkN39dBcN8zbwVeIiv69hLVTA3f/bPg5eM+STbR/MH44Y7AVOgAeWVoYV3m7QPBsATXiw7AkWg+T869JJc8qzZQdLTbO+1WkNSnzkYyP5U2O1PTUNgdmWdJw2nsl9mYo0GMY5VSR2WI5h0OEmCB5hqymsJy2uVNkKI5UyiXd+QgGFXFLwOP9inPFHRr2Src860feItj8buGDeFgBKyqkqD0oChownPY9QMlGHs6CGhfHoy6f1l5tGbsUyPkpDl/RiQrWitWP/SXYU2XURfgulRHIcCcdEHPUnIulV0oyMUA0gx7ALFYW+o1QflZ19zsdJ5rnAsVislvBT8p8IrcXF9Heb20WjyAa3m9Bj9N1xx0GqTh+Ar0aOd2d8a8oapuEAHt0i5Sp91o0ZL2nATpOeeFcwvOxI9Mnexwq3dK852AGVe9lVHjDusnSVE4qpmwJRcWOy0NMWxg0y6Bf1HNM0r2czruc55JioYbcURTSHfZCieCVAFsVNahKYcGQ/592p8YOOPep6DKaR83cLwXwxH+spz4sa0nQTC4desULlElYSMdBTWmTjXC5mDeKGS9indfWp9kq6QJ0V+ELjCCZ+JdehcdrlH3AmEobilMRz8KyWm0pfhIaffylMfcG9HkJAEswLSDVZos5R4g/vkKwYDKnZXyvKeEa/yxWbxB+kvOEe9accmy2q50/tVL3u4upd3kzAMKzvNCs6Dce5AkfJ5e9m1mMllLIQFz0QhvNXb/GT9naOHiGELhBZtKFg344WyDzpN
 sPg/+ENC
 Qvrly/GCnWvWCDtbOXGLtPmb7mXidEaFEl6S/qnuCAFQnFGXgcZav1hRUDUZDON7/tHleDgr/ZOO8kZf4Vhy+CIv0MHHZlyirp7MnVNI6M98CNV7yNZXDmudYcAANZyWUlSoWABZMFiBBZB3VX2J87zO3Sobs2727Djs4uzMwz93cmJk5W6S8R5rq+unHXiK0VxFthUbrpdhyZcHP1xbRi7pMk7kGuNJ+r0h/VGNsOvNGKpY0789UOXG45xVEbyPxvxFfDs63UcAAJ0jwJ3k2iSraNkD4OZiq5s3vkVYjs6G5mKVyBgjc8UIpYiY/gcyn9PG83ntLZ3lO9QBjJ4K2xNlU5/5dgr5Uk8kZVpHjakkwwj0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-10-25 16:17:03, Roman Gushchin wrote:
> The second part is related to the fundamental question on when to
> declare the OOM event. It's a trade-off between the risk of
> unnecessary OOM kills and associated work losses and the risk of
> infinite trashing and effective soft lockups.  In the last few years
> several PSI-based userspace solutions were developed (e.g. OOMd [3] or
> systemd-OOMd [4]). The common idea was to use userspace daemons to
> implement custom OOM logic as well as rely on PSI monitoring to avoid
> stalls. In this scenario the userspace daemon was supposed to handle
> the majority of OOMs, while the in-kernel OOM killer worked as the
> last resort measure to guarantee that the system would never deadlock
> on the memory. But this approach creates additional infrastructure
> churn: userspace OOM daemon is a separate entity which needs to be
> deployed, updated, monitored. A completely different pipeline needs to
> be built to monitor both types of OOM events and collect associated
> logs. A userspace daemon is more restricted in terms on what data is
> available to it. Implementing a daemon which can work reliably under a
> heavy memory pressure in the system is also tricky.

I do not see this part addressed in the series. Am I just missing
something or this will follow up once the initial (plugging to the
existing OOM handling) is merged?

-- 
Michal Hocko
SUSE Labs

