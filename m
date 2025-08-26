Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84210CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC81A8E00E1; Tue, 26 Aug 2025 09:55:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0078E00DC; Tue, 26 Aug 2025 09:55:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB53B8E00E1; Tue, 26 Aug 2025 09:55:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7CE58E00DC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:55:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27EF4114D69
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:55:11 +0000 (UTC)
X-FDA: 83819055222.16.6FBDC01
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 61E614000C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:55:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dpvEiw4N;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756216509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXrsBqa903YM8Bb/iVPoGxewN+EOL3SzPn1F/Ek/XpU=;
	b=XcxTHHSeFxyzFNYRr1RcFI0aB9RcHKovK81b5J3VstK2vTlcsiSCKVcXUbsx4DfGBa/Eay
	M/rcK5zuH83SWzgp8FSFfYZycb0/pX0tXr72nRAfd6+0b7X35nx/CjmC9CmVOQeMFc/c6M
	9koxJMULR0SkkWX8eyDfo+p7Gmp4S7o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dpvEiw4N;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756216509; a=rsa-sha256;
	cv=none;
	b=yCahcURU1eNKnbUPsC4tw6wdwEoMhRQIqTFpEP0kAclGU1B3veYJrbXe0sB8/10WjVhQXm
	bX7ZBwYNtQetVV/XOi3DJ5PHT5Pew6JO5fV06KxrR5vKCVEFZJWCmsH1JYg2Bj/7nxVlWt
	yEK+WTtNj9nGNebMBvjbl+1QjuArYs0=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b132f943a3so57344651cf.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1756216508; x=1756821308; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WXrsBqa903YM8Bb/iVPoGxewN+EOL3SzPn1F/Ek/XpU=;
        b=dpvEiw4NkzMb2EQtcLr3toXGahwtAUlDI6j97F8fq4qPiph6lXkL+qA2tYRJk2r3Sk
         v61PMwcX6T8DIvPK0m5Is64SDLBbKI6yRNgKFYu+CuL+Qel9KgDwHiYw+zmY7xCYHxsz
         hvAS33WIctPBB/aFpBlEA3ls3c1m/TOCVVd96bREAXlW01333E68Q0FlZg29G8Kw7Ydc
         xUqFS/vGOoeq5FFuXiub4KbQOhDhrJjDWAZ4dqs8J3az7PVeKW6RwOlVpc8n8M8m6gVS
         cc4e2dXuezU2WPPVku8cwRHYIGTBxoP+oM/ok+isrXAmJdj6pMq3l6ak68A7bjHwmBQF
         L5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756216508; x=1756821308;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WXrsBqa903YM8Bb/iVPoGxewN+EOL3SzPn1F/Ek/XpU=;
        b=Ud3Cr7EZ+sYLIqOixMWQ7gTgT5NKcoeiyO4iARl1X7/iOWm/7ebrURdC9gCzaAVbIY
         JANZZCXZ5tum5dHK6TVjGnzr4Ehb8NtNkegqYYZFaic7uJYY5Hldn8zx3JcB7JLKC+wi
         JfbSE5UsTzaVyqnZxlCU/JGGkJgBNnkA3oTOI0A017q9SWu3mQjE9NdpQKij7uzyMwcb
         2/cTm7L3CPaIwrJxIQQIorReyRwl31aalJyPl+CxIWQfbcWIhQ2z7NsUffzSbJToh/qU
         pOxNFXlx8z0qv4Qyv125w3Ibk9+DxYRn6MiHz48AdfuWKZe8LHMP/owSxr6ws4VJRK9v
         +MDg==
X-Forwarded-Encrypted: i=1; AJvYcCUXHbJWb+t+1AGZFk6uQD9cno8H41DQv1oVv650ZgtCS42Q9JS3OSLFKHE65sUXar6myYPrSj4WNg==@kvack.org
X-Gm-Message-State: AOJu0Yz75BWuy37jD4VldEiF87OPHL9wprzhaPQFGut5DndmDELMraD7
	h9rHDdPys+6E2YVHndDe5Fva0MW4kE/6ZG1T2Bj2tLZGlkfzzoHZ9HT2lZ4F3hSgh+5M9ab3efx
	NHUE6WulY0GSpJwpq040JWcEW5u/EnelwFPx6CpvuWg==
X-Gm-Gg: ASbGncvCcAU0eS+5zh0LmmTp+aKIPC2cDiprFv0JLxgmLEIwP023pkU2723FVqCX16/
	nWwOBGazrrMazH4dYzV6d8OAjmYYd4iiJep8BjuOoLH37BBT6B/+cQEpeg2teEybgE2hWRox7lB
	tlHq4Vkg3/T45cP0BCcsucD1RT3IiDqEmwa1SNoY15RRfQbU3SpUao0DK8dTEuK48vvntZ3Fvdv
	qCj
X-Google-Smtp-Source: AGHT+IGcGuep7n1ZMQbOLWojaFaiFK2h2fVsewAul/Hz9Pfb7IpF4bpoR5o0QPDcbUbeNlPIwhAjeljdyRG6U6RmHSA=
X-Received: by 2002:a05:622a:4083:b0:4b0:851c:538a with SMTP id
 d75a77b69052e-4b2aaa81e96mr162452241cf.8.1756216507983; Tue, 26 Aug 2025
 06:55:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com> <mafs0ms7mxly1.fsf@kernel.org>
In-Reply-To: <mafs0ms7mxly1.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 26 Aug 2025 13:54:31 +0000
X-Gm-Features: Ac12FXyb-9ofKcB5jLMNzC24BIRSCWuL4lKgd8Qnfh0hAm4ydgvkrr7-UIknHkA
Message-ID: <CA+CK2bBoLi9tYWHSFyDEHWd_cwvS_hR4q2HMmg-C+SJpQDNs=g@mail.gmail.com>
Subject: Re: [PATCH v3 00/30] Live Update Orchestrator
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, changyuanl@google.com, 
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 61E614000C
X-Stat-Signature: uxqyfh9m7rfjwkos769kui1u3wor688o
X-Rspam-User: 
X-HE-Tag: 1756216509-44573
X-HE-Meta: U2FsdGVkX19CynHXW1kmElDu4I7lPaY2YztItkFMJdpK+I7E7iC6qgH7nBAdNe6dBE9ieCnnvk2nvy51wrrE9/TQWaV7AZFoHMYuNXAAJwMax5EkL/7P4vQZTi2WhzwbI8W2zIuGUhXx1hoSiGafZKPxcS85sJItS5i7A32LhZw1ysvDS7Oaub7buWh6T7uTXN9dcAi3SpT9/x8gWIaonsvbU1BE+7lhaeyovQLtI8FEl82hKps1Jj9l59Jfgv9rEBFnyzyZQ8ic3HjRi9OzS6QLzvsJs+pmzJ6y+zNNcrbdu9tgmTjoiwgP+Qd1PmK5i8rkIDKkQBUr6HZn5G6kVnPu5phuPVODXAJ7STQesbOgakrLH1iU7aXrKJvbXf2koOyfnRBzXehBOz6wubLKuQBETFRkzWmlikZMdfYBdncp6d7akd5Y3UAjB8LflIxb1PcSCxKOe6lqSPMPxclQQkFSmMM9CDhCsnYE+oWpgsMPjWSUXIf+od2XDSFJNzPvX9H4DLeOSGPQHLkAMAPUJJogjev/tQmioyRVWhgEa81ZdWM2XSXN/pHSelVVBwDXz6N85g44lwm0HxfW9yBjTb/mJaONlGAVFig//VgqBgPFQsLWaDdOWwsV+9fnhQuiF11Ra4asXRWRIYVvpweDphMcyyOKzkL6vpifVxQH+7Bz5SUFwGujaRzUWH2FPj9qx8B6sWRbHyNWqnE9nTW+9iHQDDpiSMgOCXGstzG0dzNwmKhiIJ0Rz/CUiPigQ9Do46za9AUIjwFFPHn1f0Pb4Vayp2tKIqyFouQylZUhyx0jAtgzv3dJuxt0NYIGx+OXqZZGcqaf9W5fWmsm0Ow/IwoHvGlNQ2fZ2xyDVjg2EMGmo9sEibsSeJKhZ2wIqksjU39Xs31+TQKYNLgTBauF0YKMrph3eUddiCvJHP6DiXqQEEVmDE1aWk11hJ5xS9fC9dfh0OCxTSMMesFrkP3
 5aEzFUx6
 AJrxqGSPIVZC/tAy0fGfG9pbFeD1zznKJElsMIlhfnaJfGiw+rt9JxuQ7IVBhebnDlNtoXZv4DrcFIw4FAAjaQuMMk3sp+T5kBLbV9S6s+cJTl6aodFLRDvKHXF5tuqYszbCcVViH8VVKZLam/zK7Xjhffz2/CQw8dBdSVD6aSDOlAA6IgHsAEAlv6OtjBAQThT5C3y0TtoLVLzlBDZvM+Rq7Sf40ofF9r8Hs6dJeTuBjHRHcsSMLkKzKVZBr0I2w+FYkvQoe9wjAgfGFMto/idLn+gq1CIP544A6A3/Pm5Rwj91h/QE+p0xDjvHiAVkDtvINMdL1CRBMwAGFEI7cDftZ2np36EEQWsOgRs9AWEhv+OEtI0BNBiJ7Ru+/0ecrP5Ccj4id/Bw/d65YooTObgDeiaEwM2noLOuubfNaQaxfQWBbIxmccuuND9VXZd8jBKaRVrVQWtedbw83uSaOA2ksF48CbXyH+EO+zy7F+QoIZDPde1yPrHL/0UID9p4gvoLr03ljfxomHZk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > https://github.com/googleprodkernel/linux-liveupdate/tree/luo/v3
> >
> > Changelog from v2:
> > - Addressed comments from Mike Rapoport and Jason Gunthorpe
> > - Only one user agent (LiveupdateD) can open /dev/liveupdate
> > - With the above changes, sessions are not needed, and should be
> >   maintained by the user-agent itself, so removed support for
> >   sessions.
>
> If all the FDs are restored in the agent's context, this assigns all the
> resources to the agent. For example, if the agent restores a memfd, all
> the memory gets charged to the agent's cgroup, and the client gets none
> of it. This makes it impossible to do any kind of resource limits.
>
> This was one of the advantages of being able to pass around sessions
> instead of FDs. The agent can pass on the right session to the right
> client, and then the client does the restore, getting all the resources
> charged to it.
>
> If we don't allow this, I think we will make LUO/LiveupdateD unsuitable
> for many kinds of workloads. Do you have any ideas on how to do proper
> resource attribution with the current patches? If not, then perhaps we
> should reconsider this change?

Hi Pratyush,

That's an excellent point, and you're right that we must have a
solution for correct resource charging.

I'd prefer to keep the session logic in the userspace agent (luod
https://tinyurl.com/luoddesign).

For the charging problem, I believe there's a clear path forward with
the current ioctl-based API. The design of the ioctl commands (with a
size field in each struct) is intentionally extensible. In a follow-up
patch, we can extend the liveupdate_ioctl_fd_restore struct to include
a target pid field. The luod agent, would then be able to restore an
FD on behalf of a client and instruct the kernel to charge the
associated resources to that client's PID.

This keeps the responsibilities clean: luod manages sessions and
authorization, while the kernel provides the specific mechanism for
resource attribution. I agree this is a must-have feature, but I think
it can be cleanly added on top of the current foundation.

Pasha

>
> [...]
>
> --
> Regards,
> Pratyush Yadav

