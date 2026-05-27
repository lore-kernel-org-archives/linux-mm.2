Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8054CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 08:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222D16B0005; Wed, 27 May 2026 04:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FA7D6B008A; Wed, 27 May 2026 04:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 112B56B008C; Wed, 27 May 2026 04:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0071E6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:42:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A1DEA0564
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:42:27 +0000 (UTC)
X-FDA: 84812558334.06.5B152FB
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 98D5D140008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:42:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N4xgKIgl;
	spf=pass (imf09.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779871345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKtMgPU0sFudicJhz4wUk7NigX5dEPGgvFzj77+8qJI=;
	b=50iZKo9Ua/IPMJ+XW/nhe2gDBqAjI6Vqv7/lS6fD3jwfSbCwgn81lF24wyk7E2/7idJ1f9
	o2XwOIf7HwOAyxUi+xvUjqODHA0m74voV6S9oTaLc/UJV1Z4bfwRrbrmZUIbZcC47lkaY0
	O+0I/ETiFDlGGCu3Vh65vWz4FfDzrlE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779871345; a=rsa-sha256;
	cv=none;
	b=e7+9x39RI6R/YS5VEwE92cdRRbxXcNByWrm9wQUWT99tx2rIZU9jHfHHTBo3OT5UT10Aym
	5V+++Hni+VQ+W4xLL5diJZ5C3Kcuf7tDbTbicmNfsk5IrXTGGoPSKrmorDevmN2zu53niJ
	H12CtT4G1B1240GADzpW5iitggkWYUw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N4xgKIgl;
	spf=pass (imf09.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49050bfe053so18487535e9.3
        for <linux-mm@kvack.org>; Wed, 27 May 2026 01:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779871344; x=1780476144; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aKtMgPU0sFudicJhz4wUk7NigX5dEPGgvFzj77+8qJI=;
        b=N4xgKIglv1LPsIiYKF9+lbymwNMDI1dmrOOTkq5fMAdansfAmhNWSZmD1E17wHf9oK
         TgksJK+44lrGSnWvuwPL74zqJdz8gEPy+ABiZgktbl+wvB7pL3BYn5MiGGfx8aTGXhQ3
         g4LjQAZ7GQQMVo3nUTpSN6LazRJqOrS5kESV4WbeM5I14AScngTCfP8PKlmNN4WnXS5L
         kHZSoor9USfSci8JqDMfvFshePhDmcdUa1Er4gC9xuH01Fa9eSEO2CmzCTNk2AZv+Hss
         Xec7xkQOp38PUch22EAmPeTb48+b15/urS9ATHA3AseIgnmmiIN9GvoNe6n0FP61MsnA
         vWRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779871344; x=1780476144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aKtMgPU0sFudicJhz4wUk7NigX5dEPGgvFzj77+8qJI=;
        b=d0DH5ASTPJ+H0aS9DiG7U9gcVTQ7m/OpZVtAYz4/ZlPcZOtrFhh3k5QoH35B2IbHAG
         +o64ZjjyUxA7Dqgd88MKddsxU8WjtnYEMGxl8LMYVPtr5kETFnD+OuWqsQSPy/zGNJg6
         K45c9NBWIJEPrjWt+lrI+6BKeTHRPLi2hwwPP8cp5liqZMcHFiHvC9k4HAbq6UWePuLB
         h0do5gheAgYh2PslopyOAaxy3wtSI0hPm4zJR2HwqJ06geJ5C7ILtBgQCE/22WXc4OUO
         KnuM+YYhhYiYQ0yBNdYvRWC13KOWv2kdPtrOI3M2WvJLtqDy4dTjTNRiDxHzVIlRGmDE
         7OJw==
X-Forwarded-Encrypted: i=1; AFNElJ+Tgz+ozxJkiq47hNQEk2gcSn/vWlYxct/fZOXzWQtkH8lDeDsSKxesDmPZ10IKXVfZS7wj9638YA==@kvack.org
X-Gm-Message-State: AOJu0YymI8ZOrpb3zbi6cTDEl5orH/o9ajzMs52rm0nbIxRyrP89NkjC
	L4G1HWiBlOUZG2292nDllaXjxPKTdbegOJgcN5c9qRr+QBGYmozfl+3p
X-Gm-Gg: Acq92OHhGLGBc3IPCZhjEa+rLsy2/TQaCYBK5nyFox4+SYuaiaV9LoW6spL0BkeRmo9
	t6nc4mu0c5gSTaKmx8P+CfpZhlYMjKA3khid550XRuNGXOb5/J0np4oAAcmFt404fwVlDJbWZTw
	RoHeTD5zNZxeZfGFv4rWjHLaG96tW2RFxruZnP3+5fXIVLZC9TrKoJt7fVP9S/xnjIFoqZ8LHeW
	wSlYG2vzun423mCtiydsPKa6PMU6QulrnTEJoc+qjExKPSsLFyfiL0NsZEE+M1BeBaIfuK7n2EU
	rM6Ma/be+a0YQyoZteHcMyx5B1Zf7r6CJ0IeF7jFp4iHfugfjFqQl3ELiN3jgB6paks114Sh83g
	Lff4h/0SpnAIh+QCb1Sn5gVJ9EgYhEWdlEoXqhb+N4FbGK0o3Qh2tGuIKG1Fp45rMg7/0TM8oV7
	971FkG3OspsIVRVQY7PmS3C5VgHYDAUtNCFiPTZ7rPjmylvY6y1g7VWBTkCuq9s6C+tmAF1y4Wz
	kQ=
X-Received: by 2002:a05:600c:5298:b0:490:778:4fe4 with SMTP id 5b1f17b1804b1-490428e03c3mr379889165e9.26.1779871343975;
        Wed, 27 May 2026 01:42:23 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4907e6a60c4sm19108485e9.1.2026.05.27.01.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 01:42:23 -0700 (PDT)
Date: Wed, 27 May 2026 09:42:21 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>, Peter Zijlstra
 <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Christian Brauner <brauner@kernel.org>, Kees
 Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, willy@infradead.org,
 mathieu.desnoyers@efficios.com, Linus Torvalds
 <torvalds@linux-foundation.org>, akpm@linux-foundation.org, Yafang Shao
 <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com,
 Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
 kernel-dev@igalia.com, linux-mm@kvack.org, linux-api@vger.kernel.org,
 Bhupesh <bhupesh@igalia.com>
Subject: Re: [PATCH v2 4/6] sched: Extend task command name to 64 bytes
Message-ID: <20260527094221.2f5b49d9@pumpkin>
In-Reply-To: <20260526123103.4facbaed@gandalf.local.home>
References: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
	<20260524-tonyk-long_name-v2-4-332f6bd041c4@igalia.com>
	<20260525114107.7fa5b4c1@pumpkin>
	<20260525114241.4b6f3050@pumpkin>
	<20260526123103.4facbaed@gandalf.local.home>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 98D5D140008
X-Stat-Signature: 7mbps8kyyzcf1ij71w8uyry3gdu7ioie
X-Rspamd-Server: rspam06
X-HE-Tag: 1779871345-958925
X-HE-Meta: U2FsdGVkX18Uup/9szFnFVTu2xJL3D0nr78xsUGRMCBgeF4vRHuiSDQ6+uGf+yoT3gd1MOugsmyN82+jRz4KS/VMNfZiNJQShcAarX5hB1dlPDmNYVS9ssBCa2hd54yJZlWwz6IMAbMYjImcGXhjXqgMNRVidJnMaqrA7WsERbq0OoHobwSL+tM5Zu5Gy25tjHlRUYKBhNEsiJL2SAAQo1QvKj5p3W1CkC1juUuYAqE5hAEzGNV6SG4jzA71abp0FNyx3GNRo81zC52blKnfqbDcv1N6jBnfb3rrmpzgJ7E4PJfwz1SLzNR+ztKdrmCvG6mbe0W/ZBBfc+UBixc/pQnM1RXt3YPQHSWWBCdeFTH9CaGic1kTLg5Q4c0nuiqbh+AVg3hzOEdoKIRkEFyaUbJj+CiQIJKb+NP2dzmMXu1lesK6msCcXaX7XPhL5DNH7z9bl3PRSVZF6U2bDzSliE1SZPjBtaIPh01Qr/wkToLnJ27KS7cKdRns8eguTOd48ziAIPModgyI1qzyu6yJuYPhdrBafQkP5O5SGG8GfiYymffyNuP75G0eJMP3fo0PihnVmTFBb99kjG4bCue6xUD+nkLkke+ywqAok53rMvu4Phn/vfiAGv/BZ6977CAcFsA7L84fiYfE7D09w2ePKFCDNw0eugvZYTExi9duudvGSwREqxOFDAbXMeo7kNRNYOLvzhVDMKIVdU88JVsZohrEqQhlkQzviVDWkEVHCelnIZo0tY3yRbfQbyII07K9ra0FhAPa70yqZmH+TwJ6HWwmPUVu/GHm6uj3vTX7vyjJm8KCsfq+nyXpxNbc0mTMVSAHGrslf9JjgBzlS9IOli3OyfuCPoZeDRFXevY4XSAUffzvuLtwqNT3b8mFRm6mXQOm3o6aIN0E48V7UIZgIK1HVzW5pLC6zUXWrkjV3Nk+oC5EyAhuAkVzybqhgTt5b8PphZmr4909JF5vktV
 YF9CdTj9
 EOQ7kYoidMyHvh7FlsBuGaccN9Ha28pX2XWn3IdX1P+2VCFyCvVtvey6h+rPxMiQjINI2gHhw9FC+GiSbQNYCpXHVEMaYO08gWWpw9ZZV+sK5t4HE7QYr3JUU30vdGGZcZeK+fk/XFjDogsyAN4D6/aLr3teGoqvM4/EK6j7O6N9o0jRKGDahBCFYrbYOi7sTXX4oj+o/eFAY9AcNFvnezIsCd/PQKuEBH+XjA/JpiEHYEpC/+yGYqlkXwWmK8STDHcwYjFFXt2kbNby7Kdrd76Vm3RtBR9QzlW8xgVqztCfICMHbshsVduyr85BHA6UzFYosxr0i3SGbinlNKVVSgAd3fI/DIhZvRZOJjCnBQQKK1Uc6WBeAHKcFyHiTa3ABe6CTEkAxLN/Cle1jkXn2mEluvdNVOoYQqIPMDQ1Z7NT3+tI5PxJOQX8ZD1IWzF2PvvF1mD4z+GbVNZy3fyPGPiDbAgGZieFs6eG8GjOiwYu33dc7fTjPNA6+QQqbYIXgDTHe8n7LuHC/mShbSqdoXpHOy50Rg3UeF9Nj38bog/OJ9lJfC28L9xmwvkfHbD0WH8MdZ6cTzD72L7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 May 2026 12:31:03 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 25 May 2026 11:42:41 +0100
> David Laight <david.laight.linux@gmail.com> wrote:
> 
> > > >  	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
> > > > @@ -2601,16 +2601,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
> > > >  			error = -EINVAL;
> > > >  		break;
> > > >  	case PR_SET_NAME:
> > > > -		comm[sizeof(me->comm) - 1] = 0;
> > > > +		comm[TASK_COMM_LEN - 1] = 0;
> > > >  		if (strncpy_from_user(comm, (char __user *)arg2,
> > > > -				      sizeof(me->comm) - 1) < 0)
> > > > +				      TASK_COMM_LEN - 1) < 0)      
> > > 
> > > Nak - you can't do that.
> > > You are reading data that the application doesn't expect you to read.    
> > 
> > Or have I got confused over the names...  
> 
> You may have gotten confused by names, as sizeof(me->comm) is the same as
> TASK_COMM_LEN. Basically, the above doesn't change anything.

The name of the patch doesn't help:
	sched: Extend task command name to 64 bytes

If you want to catch/check all the uses I suspect that all the
occurrences of TASK_COMM_LEN need changing.
For clarity this one should probably be TASK_COMM_LEN_OLD.
(that might be problematic for the uapi headers)

-- David

> 
> -- Steve


