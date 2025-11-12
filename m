Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5FE9CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 07:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8E28E0014; Wed, 12 Nov 2025 02:50:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D08A8E0002; Wed, 12 Nov 2025 02:50:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E74D8E0014; Wed, 12 Nov 2025 02:50:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0CFAD8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:50:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C12384C7CF
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:50:10 +0000 (UTC)
X-FDA: 84101181780.19.BAEE4A5
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id A7F91120005
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:50:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="YE4Bwg/c";
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762933809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ipL3Z/6wC6GRR63sS5vId/ptcyhjHxEgUXfHm/LakcE=;
	b=utx4YYZAGkB/oRpkweyZEAdiOl/HvLbAa6j0x7DIf/VXxDLCJMWdRTT7ZjzjwBTMY8z9iv
	YGsb5IthfIyBa9FVYywOurAeNQQbKssVDIWp+M8NniZJhE0kpAO04Ifgio/9YBKmfsk7TT
	YWw4RaU0ZxYB0RJkuVIWYbTxyIW7Pl0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="YE4Bwg/c";
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762933809; a=rsa-sha256;
	cv=none;
	b=oWuHdVAGySrAXRHAettnvlQeYV2oT4IYpSRZHmG9ZWMnJtU7sUXFLRE/w6zC4ym0DNBI4k
	g/VwaT2eoXz/hMoCMEmjaeStZZ1YUds34NtAeQHCsNIm1PZznQ2Xr6W/rqcUbn/vbfBGE5
	KbJ5vSTh2j5+s9/Ul8vZYkvUaRvhHDM=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b3d196b7eeeso91017066b.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762933807; x=1763538607; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ipL3Z/6wC6GRR63sS5vId/ptcyhjHxEgUXfHm/LakcE=;
        b=YE4Bwg/cGEJ5Ycvwrp+ookC+EJjafQ9uvSlgAOmRF+/2Aje0neibwlorfhvdTDyiPU
         +tJ+NBQmml0NgQycV64uYb7R7CduKpmK8VyelfAQUFoM4lIhCp+Hr84zxFHuWC6vZ0Dl
         h2Y+gvx27+IDosYGHSOogiv0N4zrI4G6vCAFVfNHom+uSfKKkL7Sc5wRHH1DCMr4+lgf
         RmWXyW71sZBfyVmU1XvQs/LhOiBoE2KdH/e9P18fHzR8NiFjlvkIUCrn/5idarsz5ByH
         IUJLPpIegyobqmR+DzaygNEXK5I0qMVvFFUGRUhkxPT0XCWkbS0QFy/iNL08f5RXAWUQ
         5rFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762933807; x=1763538607;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ipL3Z/6wC6GRR63sS5vId/ptcyhjHxEgUXfHm/LakcE=;
        b=qALJOZ0cGKQLb+VdRaL30SmPWP1xUjudvOB2GP5C+nZfK30/IF0aWkudQPMy55cd4S
         Nlo250u8JtWvya4JDedC9Hy7gCMxzHbMTUo93mxnkz+mvrk6KWwoMJwuYaxrjp/YCkZ9
         R6qDi4MWKXpQH3g8IBJQD9c94Mw0wMmRwmlkd2ICIhALJIHYffhEn5cfpL/PVudsjsy6
         wMZ6KCylbIapufQy7EYYXkPnQGRAaepQIfW5QmjTKGHZiRbb3f9P222nwOFT4sXvOAMw
         0s7tp49nXxvoEg3DYtDsamiMIE/s7diG7GHXzbmNrwP41MFwmuNUqiWp1+7n+SZ0Rq7N
         1rXA==
X-Forwarded-Encrypted: i=1; AJvYcCXPJ/yzB4hbCaeJdeqT/hWHwwhc11xHC+OG6K7yBgGgbsxuKDZAB5lNaTqOmIIWQOtcCrvwzRCFSQ==@kvack.org
X-Gm-Message-State: AOJu0Yw1PO4Bn6h5/1CzUjl8wi8rRhc0hKheeoQFSO449OWQ0pp5PGBd
	EGONPXVFzXtRtHLLShjAfWMY0Q3uDGy5OujcbUeWlGlYdeDu3u0xLrHXJUvpLrCSrYk=
X-Gm-Gg: ASbGncs08IHE+C3G3C6Gwmr1mitgVC/P4GlYod6lVYAkEUVnDntii5nGXT4JtxszvpU
	M2bKjGpaApVriHwbkn7J9xpv9dm7Q/5hCHXhWeYI6zdf3hi4rj/CqYButFMeHwFnesyj+fU7G7x
	eDw3fjvNB/rMIAiMKp0cG76R0fmI8hfnSpay5h95Y9Gztbay2fLiCaj0Z9b+KL4GWpcSCUAT+ae
	Od9omodW3DfsOrPS6nSEDfsxdsmDrGMl1fMm1Fo/wwJpVxXtoRrbEKVsxmjhjHhtP5OnoX11A2z
	9CKErRUMXMsB8pWMHGvA0wzCD0o5nMZS5reFoJz9xoPTU1KizA4Ki2i72fTkz8wZgEMp0rTngbK
	IdiyExdRs8PIQ78/HsyArotdNUY4CMbr+ubsTK+qzgk0YCEb+5jTNQGXQey06UeR4z/LBUzC61L
	4SIK0wGzVU/e3+Rg==
X-Google-Smtp-Source: AGHT+IFkrb3GSMhhW1bzYaSDD1E5kGgIrUWkWimOuuxU6/CLGbZTn7iNA2cGrP2NCWseV/3pUPbNoQ==
X-Received: by 2002:a17:907:7e8e:b0:b73:2bc4:ebf with SMTP id a640c23a62f3a-b73319649c1mr168849366b.2.1762933806298;
        Tue, 11 Nov 2025 23:50:06 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf9bc214sm1583946166b.52.2025.11.11.23.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 23:50:06 -0800 (PST)
Date: Wed, 12 Nov 2025 08:50:05 +0100
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
Subject: Re: [PATCH v2 13/23] mm: introduce bpf_out_of_memory() BPF kfunc
Message-ID: <aRQ8LQWxoRF0kgXk@tiehlicka>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
 <20251027232206.473085-3-roman.gushchin@linux.dev>
 <aRG0ZyL93jWm4TAa@tiehlicka>
 <87qzu4pem7.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87qzu4pem7.fsf@linux.dev>
X-Rspamd-Queue-Id: A7F91120005
X-Stat-Signature: umagwrrp5atayp4zydie8twqat64z1d9
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762933808-354182
X-HE-Meta: U2FsdGVkX1/CXQX/IsxOVh4x2OqoqRXiELmFabLX2tYCR56o2Icfb6E1SxneGSMLOA4kvPttDK1VdoAV//P04aYMgdL6cTbUx8X4qR6Tz31sLfnOgnre3e4KJl6/Kx9Gg5KZoGSH1tbW6xOyxYs95poAg8CJO5mzxm8MIw84KhKR1Df2L/zMljEzbd7GL0y/3UzP0BKwmDbPjT/EvQycY7Hsj/JE2b28RwoT4UsbDV75kF15XgLbY/Q3onxzCj5suaTROnXdoqX1iZDhXMvB/lwupbr99Bn4/bWrX7xloYy0O5SIU/3NrtSmZBw8MOmB7m07/q5BUFtKSaVFED2Dv0Kvh+wVbbH52/WGclXTKVHt7sdKxep8Hxkybz7/iDYVvV4opmUpEPuJsCdQLn+38bO8dBhx3xSc7qLZrmKkO1lpv6GHTVt3kd3qGuvZzqKtejx6JEPStxKmJirQJR5AoE+TOXYUorGKd/u0ByDEoRrbZzIvVs3WD318CuotTSOgqicVtt6j5DiaMeqcqOcrOUt6FRsR3zPG9+XBL9Gu633N4kJfwzJQQXjwjkNCl13w3mf1bFNxnfcpbjyXMV9JZC83fkpzjq4uV8pgFigT0x5MycJ8xluSCHWzNoYtjqhBNz/gPan6ZEi3hiPJp+eaR0SHc8TgWYQge4gtJ30ePr90pRkY/bNIreBoKq0ayX+jZMZM2hQGVKVxeXjwA2q8ZkkoUg0abJeIdaE7la5qeuplZcH6bp4oZYFkb+o68Ic892elstC6e7K9zO2UXAQ1hp0Tvxe9IN2YDeCmdOEsdfCd58IijcikysNGShOCY7BaQnoITpS9stCnN1zyMEa1cKZW3tCzljyNp8OWtUz+Xtlz3aAXjwU/8RylIz+cS61o5iXcu0ugT1JvN2j3IVF/wVudC1av/rC+/Ta7mT617XylJqt62JPVowJMYaTV+VyuWKhYSCF6k1iWkoPVdqX
 JeuuIW8W
 0n92V67jEfMn5U7S56vLpnrX8CYY+YXAuv2wgs6KJMREJapfRm+G5jU3KIT+4Lgx2D8d7PmMD6qXRzUvYOS8Sx8o+35EnwBsudUIf7S2TL5F2m0uvYQlGtESaUhHGWJRkb2T8SVa9ielA/A0FM3ZCLVEjpWgVuF5l5FQVTqEZlASk8jF/VKHpvvDm6dZtHEC4cBS4NranIc+S6xAIa7Xu6tcNvG0VcWMl4tfWdOpls5cOWCwudgT9dU8CB66oJBWEbKPIiPfZgqraV3EHLuu/oxi3SOXXVa+f+NJq8kaIpK/JHkEaH71pTOjh4lyqs/RCHVkE4gewfCwgubolMMxLZp2dwEQ7CZk7nc9G6sm045j2AL8V4mZA9Z8WQPnVzrRMW2z8lp2b2+0s6PmhKgszAXWVuMS39ZAH3pDd69SIbL8teF4G2rkv91uwz4mYDxvJ2IZGPwk2qfhJnNSFHxBVYqAB4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-11-25 11:13:04, Roman Gushchin wrote:
> Michal Hocko <mhocko@suse.com> writes:
> 
> > On Mon 27-10-25 16:21:56, Roman Gushchin wrote:
> >> Introduce bpf_out_of_memory() bpf kfunc, which allows to declare
> >> an out of memory events and trigger the corresponding kernel OOM
> >> handling mechanism.
> >> 
> >> It takes a trusted memcg pointer (or NULL for system-wide OOMs)
> >> as an argument, as well as the page order.
> >> 
> >> If the BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK flag is not set, only one OOM
> >> can be declared and handled in the system at once, so if the function
> >> is called in parallel to another OOM handling, it bails out with -EBUSY.
> >> This mode is suited for global OOM's: any concurrent OOMs will likely
> >> do the job and release some memory. In a blocking mode (which is
> >> suited for memcg OOMs) the execution will wait on the oom_lock mutex.
> >
> > Rather than relying on BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK would it make
> > sense to take the oom_lock based on the oc->memcg so that this is
> > completely transparent to specific oom bpf handlers?
> 
> Idk, I don't have a super-strong opinion here, but giving the user the
> flexibility seems to be more future-proof. E.g. if we split oom lock
> so that we can have competing OOMs in different parts of the memcg tree,
> will we change the behavior?

The point I've tried to make is that this OOM invocation is no different
from the global one from the locking perspective. Adding an external
flag to control the behavior might be slightly more flexible but it adds
a new element. Unless there is a very strong reason for that I would go
with the existing locking model.

-- 
Michal Hocko
SUSE Labs

