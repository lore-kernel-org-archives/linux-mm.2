Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25B33CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 07:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF236B0088; Thu, 15 Oct 2026 03:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F596B008A; Thu, 15 Oct 2026 03:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7DA26B008C; Thu, 15 Oct 2026 03:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8A846B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:04:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33C85160962
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:04:39 +0000 (UTC)
X-FDA: 85323972678.10.122871A
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id 16AB1100004
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:04:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XFXPaqjV;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792047877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/3aSoEQ03reUr8m22oz0Rnacm8T+cI8I55Y5UqdBhw=;
	b=IUH4OJIRnOodyLAnnPvtLXBOdApgqWTFbAt4UR/aRpkgFv2MNkdgbeGF5ClvYFLLQry7/i
	fVGd83lv/Id6DeDgzonmHeLa6kIL/IRqs7h7ZNtiduZp7JlhRGgcXWcMoAKV+f9NkYz4fJ
	jNKEU0mEaV8t+Zbm0WEdId5/HO3YfhY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792047877;
	b=DH6FWRjyzVncwHcr1g6pSD02xXCSPmWNSLXh/b7eLIfvz3SxAJh2quereO/Cjs8p84k1DO
	+/spS9P7eRXCH5P+43zdlSBKCNaEQqEMHVnEILGd9uH5u49NewHS+jT1tAxtK8EXLI+vEX
	KSmWnNtfae7aklweD6JDEfzlyqaA1s0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XFXPaqjV;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a01933b584so42097385e9.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 00:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792047875; x=1792652675; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t/3aSoEQ03reUr8m22oz0Rnacm8T+cI8I55Y5UqdBhw=;
        b=XFXPaqjVW8vRJTEUU8kw5uSGKrDYiRYGGB2XCU2OAO2NJMPl8xraWIuQAPX3JCrlXZ
         j4KTg1KEmH6sf/eSfM4y5xE2tCQRbAlf6HopUWhDQmm7AYhIbeAsQGwTvCgmBzRBuRSR
         dePcZWmOfzjLPpgeSHfP0daGOEHY+UGF90ZUEE9rKRrfKnoUIQJCXP3zVW1Z0JXdYXMS
         CuqaTlA6piZdRUMaLeTaygqJ7BgnBUeaL2P5twptlhNOUS9Vyvij4QballuJTL7Xg7Gb
         T7NlIJSxgmKqn8zsbaJEi2o91bTq0hXA4U9EPxnvG+5AIGtpk4npmUFp/KFvQj1l2Yij
         GnWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792047875; x=1792652675;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t/3aSoEQ03reUr8m22oz0Rnacm8T+cI8I55Y5UqdBhw=;
        b=aGsxCagdqnIHUrxEON+4IUP0L5G2Py5eoDYYKA1LdzPAkmyMPtDCXfGvLa0CX/3x/0
         sNOGLShe57ZTbIintdypjITC5TglUBSihop3umrLnK9+P51t8X8kMXVFxALTOV3YlMNt
         qpr14//zBWdTQYa2DAetIYBY3V9KBtluHhEg7FjqqpQjV3grycSQcW2NOcxhCnJvAd5s
         5pz3f/cJT+dUEHNcAnB4mz9bxg+vHsfzKWgGQgtNOEHw/Rqzmb6FWQ8+BxWnW8PYn+o3
         O5SHV5L7XjghmDnjv05Dp5Ve3hYgTWbz9xL4DdgYng1kd55830UiR6AU0WL7Tc1YOF6q
         FSgQ==
X-Forwarded-Encrypted: i=1; AKwUvByj8lzdw0K059k9/IKw1EZ7mM0FjpbQVKyZ0EdJ20X+/9Sp/PJzwM4N9fgn3JqT01201ZA1mxDh4Q==@kvack.org
X-Gm-Message-State: AFq9FYJHNati7h3mIYGelu+rQPd7GNpBH39nTz2e6j2S2ORHLMyEXjiG
	IgEAi/zvvwOZo7qhiTaR1bexv0VTJ995HQtG+Supn+7B1pSoqHpu0mq9MD9b6rGkt1E=
X-Gm-Gg: AYBFou3W/Wr/2BL9yfpY1VZ6cLxkUhnx1/NVelWvhn6knuLgpaY3k7z0JQSwCjDNLco
	Xz/jY203c0L3+gNKP/WJo92eVy/0/Qar5+ER+j/0ZwJe0KvkJGCm2ckpIKQJQXc6fZ0Iu2zTkIl
	OPzfmqHF7CJYErmTBWXs73Wqt8gOdc/5xiFvgQYA35ensdomtxdLOBnHU3xk7YuNfTLcDy7Lal3
	snVBfYa7yj95l8WS4VsyINECQZK71o98IZZ4dy+/MkkFM36IxcQIjAAStubxF++YV904DShv32f
	DPqwM+hKJI16HzDTN41bQ4hJ7isN1F+jPu9/EALZ9+DU1+SVhfXnbAPMvqNjJv6oasxaEHPmLQI
	4SbopskGVqDdlg2ZrD/gy8T/7Acgrs4zlxNco64FP1Jg3Uprsuz4dOidKMdWU4EzrVi3JdjaVuk
	/PVoSPR1iT34eSWjZKmN/ZpYCzKX7xoMoOetwKayoZ1osKmba/IoXsAk9NiB1xVWTJr2p4uGZhz
	hP74Hj6pVNB
X-Received: by 2002:a05:600c:548d:b0:4a1:71e5:9420 with SMTP id 5b1f17b1804b1-4a18e49c128mr367720005e9.13.1792047875368;
        Thu, 15 Oct 2026 00:04:35 -0700 (PDT)
Received: from localhost (109-81-30-108.rct.o2.cz. [109.81.30.108])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd69b2a2sm20612325e9.4.2026.10.15.00.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 00:04:33 -0700 (PDT)
Date: Thu, 15 Oct 2026 09:03:57 +0200
From: Michal Hocko <mhocko@suse.com>
To: Alexis Bouzigues <BouziguesAlexis@johndeere.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"liam@infradead.org" <liam@infradead.org>,
	"ljs@kernel.org" <ljs@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: nommu: set MMF_OOM_SKIP in exit_mmap()
Message-ID: <atB63fzpLyfWpzPn@tiehlicka>
References: <20261013-fix-nommu-exit-mmap-oom-skip-v1-1-cb957cdbfcc3@JohnDeere.com>
 <as80Rpm-VHhP14aK@tiehlicka>
 <BY3PR05MB82607AF910C023253C48CD26A09D2@BY3PR05MB8260.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY3PR05MB82607AF910C023253C48CD26A09D2@BY3PR05MB8260.namprd05.prod.outlook.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 16AB1100004
X-Rspam-User: 
X-Stat-Signature: q6ojnnoghkkjj418ziwxn7au7sfupjyw
X-HE-Tag: 1792047876-405841
X-HE-Meta: U2FsdGVkX19BJqAUgqeYaotdJJCkNEZX9Z6oGHbDziz0ERMWaWnpZUzQOHCrMJykvt2xGLwJ8LDd8bAmzopZfPpzEsc9b5QHLZx/Md5YAtZ64KGi5TuByd7CTG0sXx6Jx6kpOj9M6qhBa9yRvxB9VMDTWAlhbwGUOH5z1J3Ol0BNMY6xbiTDINFgeYkLmPJVZh1EDi86LyZ9/EiuQ69gF/CGLm5KiWsULqRgLyq70YdKhL95kl99AhIizOl/7lIYkNhUHze2nestI2zrLyD+hImkIVOxnzptAgwVwq0XNnDvGnguxFonJlSkLjEOs85NmxvHW0WvU1EjW+GgKl0lnWYu594RD7UAvF70jIaR1mz5yHmFt3s5kNYBUCU3joHqM7maaOakiHNvZYHLwpCVBmpHV4q9xMH5NZIW12HfMryfSKw6XUOQ7N9FFdA3HPCgMz/AgImxVBPq3WIrmL5p5dOMm8zn2Pg5001eix6INKDlvS9LVDEsoSlAFz9NgLcin8cL+cSQ05WzkIwTDNk1xHPVVMYefLb6u5E5CoiZqDoBBYh42kNSv4IsEslkgEt9NDRrHPPAI2glgipCKebXTQDyRGOwzppXjvnLCRmwqyMcm8e2suTSY4ltfvWh+1IyBlUtO8cgEvLZqhsbOepbXXXHBfqCPMpbYJ/4m3LQYte5FfwYxXrrsdDCB0cWxH98Cf4vbD/d+ApRgwLk7q/TQz4rDwSkS+gdKUW1zTnxquQj+Io6Qn5OsWLXMQvXrFrLy8Uflkocs4IOoCzEgblori/EJhgAUWaGdA6djY8viy6z+XIYXOq61a2OS+XVIFMJNjsO2wWcAnlaP0WY6OZQlpo875SOuhICGK6Nm1YAtE4KMKc6+jW5rQkuRi3DbUAsxv7fEAD7QIQ2VWje1wCh8hBZxnYZcDW4ohomYgfWKAwHEknZDr7+6LhKqYQADUopulplWG87UgREKxOBrdz
 WaXs6Y6w
 5ZqdA334SP4jtSL6ftkDFBqCcjbDQpRShXBJQGg5X/Fvs1JE3XkY5ajaHoWENWtFVPDghXit1pbiYAZD0wkh3E7UDcDSJkNXKjk/jCeJZ9ZSM1uy2ulomyOyK142KghL6YJLCvwAmv9tXxL3hhAMxVKvrSnGdGW8x59Le99ebCznEAUaOHZ5fg/Y7OJ1pk7UkbhN54vYH13IQdFDto08cVKyVK+mrWjL4fGYkfRk0AwhxYGQVGuGt2MVrOr1kqUKHXm+GdO/DT2gM64fjOwH8onXCPFklB1sC2tjOt1TkEF2UmGfJfb2WvaFzp5s/5j2R5FwMpcrpgsrIy7ZfVAMh0DHpsb4J9qQk4uAFXvefLnaAKZOJV6eaSWVoCjCmZ8OBNrkPD8oFLr+tQ0+GcRKCzJb2Ken+BMLk2RS49WvuKNgTjsra0RWKmwPgzWM68HS8B0o+VKMmyIXERDEfGtPiFUamP03lh9Hc4A7kat/M2cvcItn9XcdHhaxt6jVls90hB3wTRSqw8bNzMD0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 14-10-26 21:58:52, Alexis Bouzigues wrote:
> On Wed, Oct 14, 2026 at 09:50:30AM +0200, Michal Hocko wrote:
> > > Set MMF_OOM_SKIP in the NOMMU exit_mmap() once the VMAs are freed, as
> > > the MMU version does.
> > Is this a real problem that you can actually hit?
> 
> Yes, without this change the oom killer can fail to make progress to
> resolve a global oom.

Are you really looking into the code or just relying on an LLM?
Go and check to learn that the oom reaper is only compiled in with
CONFIG_MMU=y

-- 
Michal Hocko
SUSE Labs

