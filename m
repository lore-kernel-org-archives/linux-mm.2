Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFFA3D31A15
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6634E6B0092; Wed, 14 Jan 2026 02:27:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6375B6B0093; Wed, 14 Jan 2026 02:27:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5571A6B0095; Wed, 14 Jan 2026 02:27:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41B006B0092
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:27:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF6861402A9
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:27:26 +0000 (UTC)
X-FDA: 84329738892.16.50BCFCC
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 08F2A40005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:27:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M/Cu6ecv";
	spf=pass (imf17.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768375645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iatfbkb039XtZtG7yO5eMvoMHygvxkVJOdhG6yXVCuE=;
	b=68XmFvgu9Mlm91wPMfXtowSRYMFeeW24lcYlSNaq92xt11ld5T7LQ44beTNLQVM/i2o4eD
	sCFqc5hOLkM7C3Z1Cyrn9twxJXTDzQ6dBfcfRC9uVfMcI473OIxVQnb2M1c1FOSFiusReO
	ZL8JN4OED2+BefmukadaEMQ5elTiTVE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M/Cu6ecv";
	spf=pass (imf17.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768375645; a=rsa-sha256;
	cv=none;
	b=Bnvma3jmO2+nYkh/DTaKGLomEPLgdCSlzIocc3sD9hHIWYjg8od3bVtJcsSbrcpjxjfo+U
	TABpV8ppqC1qlU3bNYm6r0XoVtoFfzknfdKfCaNJIbGG7bfNRcs2xtRnOQ0S4Vj1bZgO3C
	hwq2xR/w0izHXpXSfP6318IklRW7o2k=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43277900fb4so210083f8f.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768375643; x=1768980443; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iatfbkb039XtZtG7yO5eMvoMHygvxkVJOdhG6yXVCuE=;
        b=M/Cu6ecvBgPCnjLwTlEvLu+qMr8vsOLL8uyqktvKksWqBD+7XwsRWziwNV+beDQDY8
         ZvFYcYdGf4PBJK8smvaG+NDWFjUd5AKpn5RFHPzOz/tnnkK2N9CiePJaWOtNe3zvQVNl
         FCnip7SoBWtSKjBf7PWZTP35I/y9jkNN0OOyLQYp/CUxpqwyhZURICIYWKT9WZfn3Zeo
         XbVbRRuRtt9lMaLKYCyWucpHvsnhHhD4EQKF2SaWJMRPioA4JIlju18KZzJSfjPoEQV9
         v3+Op/k6erhWq+0BLmP/CWFnjqolvmoM6A+aeD8bzBjWVCKGiMhZuzwXUGsOLF6Nm3wf
         Gy7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768375643; x=1768980443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Iatfbkb039XtZtG7yO5eMvoMHygvxkVJOdhG6yXVCuE=;
        b=T3JSiuiWNzmN7EC/9BNhed5Mr+Qy7XlLd/9lTyn5cQLVUe+x5erFCk7soQXBJItug4
         fZImbl1Kaa8gZb6daRLlhna7HhqBB6L25H5fa4ZGUoILrxY8DlRIjW8D/5FIT+FdsZGB
         Pd5R7cgJU1DEgTDlz6I5XIXV8fS34iBGkPjiMdh14Hw5J7AcleiIKmwnPXD+CaL4d73x
         V0GRsf/10Bj9M1w3L8zrGHr1nHyyVBMxzWvtsG0yn1wOSdwPXm5AaQC+5czxFD13OTWw
         0/u56cqb6o7RowcoNH6Mmac5JJOrwWNwrCbGAYnkmb2ta53LIuIR5PI5NCInaByMaWM3
         6/OQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbZDDRuRqgVIU3Rh5TgkK43dq2bFsSiCc0xgIUPcib9GK7/KH6PTYY9arOCDFUBdXG6ZYrHbqpLA==@kvack.org
X-Gm-Message-State: AOJu0YyT/cxLjKyw7uOsUWkMl5jy+2s9Ev2RcLOfuw6R5zoJz3lIkddX
	oiwRZNP5cgo0uY+84isCismHqixYi/934zt3mbugO0Y8b5Jw+EeXgt8G
X-Gm-Gg: AY/fxX4YF+2299mEqc+LHSYZk/Ur7FkQzvaM24DTt2gG/BZTriIxY0bk6UxSALAP6eM
	YdzYYiK4+X0DmwY9TGsVxBXj+jp4wOtrkbitraUdnHJOB/VmlDryg1Kp3NqOPikvDB2txkr3jne
	VFt47rOnY1qbCTHKk8R+Le1RcTVnMylM+TcbKw2N8q1psy7pYS0UntqlKI4WQ1Uo/yIa7A6BrHj
	iKhj2A+p8Xh33/8yEnCHVf0bdGXf6Mml7og4dl+jVuczcTZSVEA/jFoyjrDVVPkzLC+JBsWabu+
	KkRlyqhZUfWE8CehdLfN/o5yvK7KBQtbgyIozChKggw6zRpIX3v/pq9XPMlNgPSr5hmQy0Sjidr
	xf/hYLT0IxCujuw2Fzeb6ZT5Z/jB5IYMRiC2LSwiu4ATPzAzi6ws0/onI+/OSLIpjDFvrknr+TA
	rRoH96F4Q=
X-Received: by 2002:a05:6000:402c:b0:431:66a:cbda with SMTP id ffacd0b85a97d-43423d4709emr6998700f8f.0.1768375642965;
        Tue, 13 Jan 2026 23:27:22 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-432bd0dacd1sm47532193f8f.4.2026.01.13.23.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 23:27:22 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com,
	agk@redhat.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	milan@mazyland.cz,
	msnitzer@redhat.com,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Wed, 14 Jan 2026 10:27:05 +0300
Message-ID: <20260114072705.2798057-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
References: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: j7u3wdc6ewtgcytrsjtwhz86dp3kf5bn
X-Rspamd-Queue-Id: 08F2A40005
X-Rspamd-Server: rspam04
X-HE-Tag: 1768375644-123700
X-HE-Meta: U2FsdGVkX18tRprcBehXzVGDsKQwI6UlFk/mDysqwrRWUcMdr+aXugGv1VSpJglRXysl3hzqN6/zqM4pRP+cVEMgtBNU2lpM+4cqKrDCtk6AvPARS2nMXpIzqQi7wF9XBhF0eWO376IvRp4PDzk+WB7Y5V9nldjzH3ZO49e4SKN5q/l5VTmLPmq3vWw6B0FnUAdaOaGE267jCMPj172WDl9/C0cp0p32cCOROu2OXNSv0QryqVIG7QsP2yZk5K9gE/ZdPGOTCBvVB/KwYpysEzl69yJKOmDpj1kWuVEuvm6fZlsK46pyrewZpmhewW/5fmkjqoD9vf3k9zyeTloF58VpzFVqBLjoLCZ2Ma9pD2v/ykbpFchl0JG4bEpeprtAZ1U2JokaiT7EmFxCUbrK7JI7R76BNMPpzaV16SiYpCN82QM/Wn8rAQjaNuXFd9duIP2J9T9RpwfmI2VxgNxnIbdyfgcD24+yYA/m4uynC838GX1u2OTHgdnDsHyLU1aKb3EZ8WrHa//3TF+EnxSxRzg8IIquUcFa6dn8GcQJ0sUlyIpLBA7HDfL5NqF0/17JsCjZ5uvqQ5ZOe+/ktsUEQ0idQ4l7JSeYXMg3HkxA2RpjuhK+TDFL1CfDEmWJ45gobsGubL4OPJadtoMqcipePYsPBZDk6kRJp2TtYaMcEkdVyL2UQZ0rbCCKS3gdf2LWtvWujSQI1VVLKxzddEXfkEfMigP9Z5GbBS+gObCFvnJyZ5QDn7b9kABJnjaAZ8WQOEowr53eTqcu5L6FlLALFVDMax3j9JnM8rDEq5iMrRZxCseO7LIldDn7mBtXJ7FQzrHx9YE5mfVUjiok/C9IWTfjoA//NQ376WuAU9TQVUTLWR4Tg+yZhEBVyDd2X0UAwZ0LWdpSsT6fU1pgTT+OUGnO3fK94jc7eoD9Fgm1Mn4B9mxHYmj8L2BztStvgWIrT4iVJJHboGC/s0Mda42
 g6SFB1O+
 oh/dq/+Xk82gokqjx17KUWIe+kLm7VvPULrNOHKdu8+xedibK/7Px5jyuc14EqlQUTXN+a9PBLseADSpYjP/AlYdRP0HTguPTPUnQ7V0oAWoEEiD8G4qgu1GGWcAYnqoiLxTe+wM/tEYmNgdwNsGCV7vU5HxUnTQ7nuhQjNJiroHyd/LTuTz46axrqEkItMqmEOwi9TDTacbFHRoVjHm1gkvoQjkZI0qHb6sLIeN16Ke23hG3KdskUxPMJcPX1XffhUraFhN1ZEaLY1QY6epFFKkPUbP9cSeQUe8XwUFyq3Kq77xkKpVn3CGjSg3sUO2iSLRH0BhNeLrv7vzOa8DRTcA2YoSfp9fDhF7LawXhi5HLMeAfU27a7v+0YnDVoXP1AfzfgeZi8FycoEmNyR10lqIi4pY96pKXRvSgIsiIdeXgTBGVVieuDdYWU1oSNbtBU2vu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mikulas Patocka <mpatocka@redhat.com>:
> Askar Safin requires swap and hibernation on the dm-integrity device mapper
> target because he needs to protect his data.

Now I see that your approach is valid. (But some small changes are needed.)

[[ TL;DR: you approach is good. I kindly ask you to continue with this patch.
Needed changes are in section "Needed changes". ]]

Let me explain why I initially rejected your patch and why now I think it is good.


= Why I rejected =

In your patch "notify_swap_device" call located before "pm_restrict_gfp_mask".

But "pm_restrict_gfp_mask" is call, which forbids further swapping. I. e.
we still can swap till "pm_restrict_gfp_mask" call!

Thus "notify_swap_device" should be moved after "pm_restrict_gfp_mask" call.

But then I thought about more complex storage hierarchies. For example,
swap on top of some dm device on top of loop device on top of some filesystem
on top of some another dm device, etc.

If we have such hierarchy, then hibernating dm devices should be intertwined
with freezing of filesystems, which happens in "filesystems_freeze" call.

But "filesystems_freeze" call located before "pm_restrict_gfp_mask" call, so
here we got contradiction.

In other words, we should satisfy this 3 things at the same time:

- Hibernating of dm devices should happen inside "filesystems_freeze" call
intermixed with freezing of filesystems
- Hibernating of dm devices should happen after "pm_restrict_gfp_mask" call
- "pm_restrict_gfp_mask" is located after "filesystems_freeze" call in current
kernel

These 3 points obviously contradict to each other.

So in this point I gave up.

The only remaining solution (as I thought at that time) was to move
"filesystems_freeze" after "pm_restrict_gfp_mask" call (or to move
"pm_restrict_gfp_mask" before "filesystems_freeze").

But:
- Freezing of filesystem might require memory. It is bad idea to call
"filesystems_freeze" after we forbid to swap
- This would be pretty big change to the kernel. I'm not sure that my
small use case justifies such change

So in this point I totally gave up.


= Why now I think your patch is good =

But then I found this your email:
https://lore.kernel.org/all/3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com/ .

And now I see that complex hierarchies, such as described above, are not
supported anyway!

This fully ruins my argument above.

And this means that your patch in fact works!


= Needed changes =

Please, move "notify_swap_device" after "pm_restrict_gfp_mask".

Also: you introduced new operation to target_type: hibernate.
I'm not sure we need this operation, we already have presuspend
and postsuspend. In my personal hacky patch I simply added
"dm_bufio_client_reset" to the end of "dm_integrity_postsuspend",
and it worked. But I'm not sure about this point, i. e. if
you think that we need "hibernate", then go with it.


-- 
Askar Safin

