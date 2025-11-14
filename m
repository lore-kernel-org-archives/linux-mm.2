Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83285CE8D60
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA998E0044; Fri, 14 Nov 2025 12:24:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B7E8E0010; Fri, 14 Nov 2025 12:24:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5A5B8E0044; Fri, 14 Nov 2025 12:24:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A147E8E0010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:24:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C021C043C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:24:33 +0000 (UTC)
X-FDA: 84109886826.28.BEE9D9D
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 63FD812000D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:24:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Doh/xi9V";
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763141071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jr99N8EvfE7VSxMEgoXnQ9FQqP6csNpcKoPAkZthtV0=;
	b=wr1hopI5a3IwbDdqB+brF/983YnBGwuNvJ7+dhar9DTg/XM94dhfUvaEkRJvcQb6j06JKD
	Y60mFiVG3kWJxlYqNwkNIgnfYxubjov6jcjZd4KeYuUUH2l/LxswVbw3fx8Syg1oK0qi7V
	t254vHMjGWcQQ8WgUjBXNtui3t4eBFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763141071; a=rsa-sha256;
	cv=none;
	b=W/zYTV28Bnjr8wGqRPWjfY3/pvmIylkd8EJ39ucPIYiRm4OQYoV9Okn7KLGgPh+iK2n34K
	rU3FZSBCSKpRu48GYwKDRqgz/z+pixK2SHUUqdB0Zw3K2kdLXnmEzuG0AjDe7Goj/SnPJf
	RP1cFuXSBAuE+vY3juaeGs5krcZ8+TY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Doh/xi9V";
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64080ccf749so3204678a12.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763141070; x=1763745870; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jr99N8EvfE7VSxMEgoXnQ9FQqP6csNpcKoPAkZthtV0=;
        b=Doh/xi9VMT56DjKYOniCOh4DQu6dkXe6gXWHTA95qQQa012dnyJ9dqaC1yd+Y42kF0
         wMHYMDhGzwGny8nj27XF7kEXlDe7EkEFIMkfAQ/VinZ50xFlpVUjAKFrJKoaCN8+mlk4
         r7X5SNROAFqhEHva1RaKcY8PfBNty2LPmi/8hXs9iEzqRTN/7GtAH93jfJCMALoHgug0
         RNFPIgEJ4I8O2I0lG9vfg+y6zP8QcdQg0mA6gHp6pLGSWnn88zeUdnOuWdESbxShPa70
         dISYgHiQFFmiWwgM+ODdPjR1mNV4Gn5RN9f4PIO+HIarNVRthAbby9c/D2TGuYc3goIN
         zW7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763141070; x=1763745870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jr99N8EvfE7VSxMEgoXnQ9FQqP6csNpcKoPAkZthtV0=;
        b=DZrlKvgF4jo+AWZhPWnh5Be8Lq1x736kyRT2KRClDpWY+etX7+sbbZr0G9a3p3ownq
         nbsSFzFQn4dtkK7FfF+AsPryKEufBrSlNQ5mqKgf9cdkhdjkPO3mt0QlVeW8aDtsGZ2Z
         uUtN6jb/sV6oQgrwYbXMDshcMkkFDWMUIwBlEeJ/Ew+d1cTvVXV2GOQB3miov0zThyPR
         a4F1oujbQu9OdWwd8626Sbtzw3cQnFNKAqmev2GUBJ0C6uy6p+9AHqqOHlHQU3uk4KpK
         pry2VWeTlreJnb30SclDBeOyDtMchw27K8selsJXb02blZVKvbbYZBrywuQC8oshBl63
         3Xvg==
X-Forwarded-Encrypted: i=1; AJvYcCU7O5AbpQ8jpSV4DnOj9I6yF5umtDu3PmHxpgys262YK11PzKylbSBQwybzSrTWy8s4XC9Jjb/k7A==@kvack.org
X-Gm-Message-State: AOJu0Yxbd2Pe5VCMOxFJUGUyv1vjzhRXBnMq2/sn5K25k81z1tLwARS4
	O7YuYcGo9EExLQhy/yntfl2DAe12ae9hZQm+Mqja1JCTIsTN6+rF/CN99aPPVclEjlGV2DrXrXP
	/dfQPcDsjryD/JaMJ+nAHn79evdX098lJC07G48EHqw==
X-Gm-Gg: ASbGncsFuXSxmXHjLioxR/9LPKYoL8tl2Que6GBIprarAN+Twb3qdpn/J5Q2r4RfmI0
	7Dmz5+HSy8HPQJmhfy/0AcGBsdXznMXMJfa0dM0T34QQG/qW8YGw5tF+KxbbQApC+xPFznQdqHH
	Mb2Ll9txblFCqafDrNu/EH0YQl+bvX3QxpumWNEwFgtkzin4nMbMfgC91xULHMsljEzOrmN8Qo7
	9lg8Tg34hCFqL3mcYVqdrPczqgOkUNpPnXBa0EO61oYEXxBPtQhy0kSyQ==
X-Google-Smtp-Source: AGHT+IHaD0ZR24K10v+0sxxsxBE7BTJ1DM+XaPqvd21jueM2H9NAEGZUn/yDXQLn/HV5bmLvw3r9Ugvsl3a5yg3XZCk=
X-Received: by 2002:a05:6402:3547:b0:640:b06f:87c5 with SMTP id
 4fb4d7f45d1cf-64350e10fdbmr3182814a12.1.1763141069892; Fri, 14 Nov 2025
 09:24:29 -0800 (PST)
MIME-Version: 1.0
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
 <20251114155358.2884014-9-pasha.tatashin@soleen.com> <mafs0cy5k7ct3.fsf@kernel.org>
In-Reply-To: <mafs0cy5k7ct3.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 12:23:54 -0500
X-Gm-Features: AWmQ_bneFQNsBKrT8Cx_1rm5coKnpl4em1PjNxUmKMGB5lxAwOhN1QTQg0XRok0
Message-ID: <CA+CK2bCS52_vU-Z5ZRPrceiVCnJim=8VoYRMmBkx5iEd8-B8tw@mail.gmail.com>
Subject: Re: [PATCH v1 08/13] kho: Remove abort functionality and support
 state refresh
To: Pratyush Yadav <pratyush@kernel.org>
Cc: akpm@linux-foundation.org, bhe@redhat.com, rppt@kernel.org, 
	jasonmiu@google.com, arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca, 
	ebiggers@google.com, graf@amazon.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 63FD812000D
X-Stat-Signature: cj9qxn8w3xwnkchsrjuxy5saiadn3yxm
X-HE-Tag: 1763141071-53935
X-HE-Meta: U2FsdGVkX1/3Sopay5p5dUA8Ext4Ca32P9WVDxYvqTfwmVJZcOUwcUt5R76KzGLgu4N+ZfUVIz4rHcOOetw++NONxp7WP+JI/XPv6JOWiBcQ/NACBMKUhSwAHJrhxBl3We9AFZYSfxGwQmzo6iY8/nqUJFDwKvtHWRR4Y+lTEWtqlZkf59GioxqZhbgfQ1vFFClkOAFF6r2rCWDS4aX9IAOOq0ZsYBJxW/0x3Wc+nY6CRb+O25FHWmhL83HvtNJ3a6Atiqi2a4LQG47CA/jvlu2ZrNUatvg7dPP4rlcsSEjutnFQoXOvmNDpPcdpKH4QOVRDhYlUI1eLcwTMB8v1JWeibwSZbjGJY2/sB6O9I1d53Yob/YVJP3VYuZFsgUvZ2V/izmYJtTGZ/GMvnstotUIy0oKeq5/QqsfQ7996bFSKUeTyRA+S0yIa5E78fGPIFH8zBnAgChxKJs6t98ku7oQRoxwAihY4o4ayOFpP/HWSEzv3nA/LVDIeZpjzvCDftXkGfG0VvPfUBamCsXZWZuSdtokuNj+dGg80Em1VofnnlLRr1Xz1WYk3WDnpTPTI4MnaY4SnK6SR5pFeKKwmRz2IXQXHhetAkQ/WDmr+69H7fxW3Sks5CdETOBGUPI3Pi17z3KN+gVdSNO7C6LK0tLEUIYtiD0pH0b+RaEIXxsoqW4STPp1pLwEPEpr4kL67XhuUdcZXSkFbMjJAefXK8zmaiTKdrenbsNq/dfMFn8tg8r4BdGaW4gaBSGN4WK89GFfw5pWkwyaj2WT3HcV603ZSOf7hu7AEucM31pfjPwMHN/EXYVG07mddLXmS2Smq5CoOeKAbcqDqVLmtX3t3KaYl3euvgT2uCHLwl4cYXWpMQOx7O9Lot3RaqjQISSzODYPlJiSdPZG1q5zZXxis/FyaXw2+Ek8ajZMHjfUajVSSUVbjlO1waYdRUZwy4QuJGWOGXLqh81gE3dGYSn2
 OxtsSCKP
 zFPfXSaTI9WaUyxyJMJMmHBYEJbQyOcsHP3G//iZj+KuZ48tD/IX0sqc+5HwLJ7lDAYLySFyxKAODhTtu3LFz1etY+ik8pX3WugvzOqapgroJpsKyJiD33a4bgfIDY8DcIx5k47dobCKdxk9zHgBM0pP36LaQdINCyRThwH8EheelnJmtwTpaLPvRkKQHwMPzMsDgHimLT4Dg1Da2c+JvMW47ig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 12:18=E2=80=AFPM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> On Fri, Nov 14 2025, Pasha Tatashin wrote:
>
> > Previously, KHO required a dedicated kho_abort() function to clean up
> > state before kho_finalize() could be called again. This was necessary
> > to handle complex unwind paths when using notifiers.
> >
> > With the shift to direct memory preservation, the explicit abort step
> > is no longer strictly necessary.
> >
> > Remove kho_abort() and refactor kho_finalize() to handle re-entry.
> > If kho_finalize() is called while KHO is already finalized, it will
> > now automatically clean up the previous memory map and state before
> > generating a new one. This allows the KHO state to be updated/refreshed
> > simply by triggering finalize again.
> >
> > Update debugfs to return -EINVAL if userspace attempts to write 0 to
> > the finalize attribute, as explicit abort is no longer supported.
>
> Documentation/core-api/kho/concepts.rst touches on the concept of
> finalization. I suppose that should be updated as well.

I looked at it, and it is vague, we are soon to remove finalize with
stateless kho from Jason Miu, so in that series that section can be
removed or replaced.

>
> Other than this,
>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Thank you,
Pasha

>
> [...]
>
> --
> Regards,
> Pratyush Yadav

