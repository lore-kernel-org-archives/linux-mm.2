Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBB9BC9EC8D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 14:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60C746B008C; Mon, 12 Jan 2026 09:51:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D71E6B0092; Mon, 12 Jan 2026 09:51:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C34A6B0093; Mon, 12 Jan 2026 09:51:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6386B008C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:51:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E728E1603F4
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:50:59 +0000 (UTC)
X-FDA: 84323599038.26.482704E
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 185DCC000F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:50:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lpIHRPcW;
	spf=pass (imf10.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768229458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODLV4oLgczXgEDSx2mWzIpiAU4blaSGkvVSpyN5hjwY=;
	b=e7/C/n+f6QKzuzp5ZjeV6tNBjBlqWKcp6gPjtjXWgTUDk5ayxhZKulCxeVbUw0d97ozp87
	AvwGCteJ5wdywJMKAsEojQOvkx/wIdC9j5X+7QYOI1I999A+wD+8nkGF3tdf9U4SqxLC+P
	O/+dHC5eGYd//SaYw8TK7xpZrcTVNhs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lpIHRPcW;
	spf=pass (imf10.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768229458; a=rsa-sha256;
	cv=none;
	b=kuJxfnjd2IDQrxukOS0L64NGlzgLFPnrrhacieRPIZlGntBE5WImwAoqsfiGq5IccwiR9U
	R0DWtB44Dl6D4y1Naj3Tkuwfl2k9K4WZmlGIWfOf+yRPxZND6PlIq01aruaGCs4rGvESdK
	n2TveLipCimcRm8uRLDGFfYm6myGosg=
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-64661975669so6948365d50.3
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768229457; x=1768834257; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ODLV4oLgczXgEDSx2mWzIpiAU4blaSGkvVSpyN5hjwY=;
        b=lpIHRPcWjUJVxUpp8M/XuNNWID8DHg1GFNRr3oBAzjRDMtDhqmtPQ9HsFvYOW9WrEP
         cPEQ6JRPvye0r/0gd34JfobNQQLGNtmkaZMmwefLPo4qn62IIzarDOfVG+aIgmP6xFQp
         ZysGVuun6n4vMKzVm8yKCj4HuZ538eQRR5B/xKK4XmMX912PMeCNtdrrGjxNHTfEi+Ez
         AFrjNNGykiPR027f5SweZrX2X2hRFmr2S+HHzhUlRjjK3c86W8Pgvma27jaWrtdi70ns
         GmsmybNaIOY/B83dgXH51XmMz8YsGVqYJHx89+3y0FbPr4PSmgprA6kWzxWSxAJuuPs/
         Zo4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229457; x=1768834257;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ODLV4oLgczXgEDSx2mWzIpiAU4blaSGkvVSpyN5hjwY=;
        b=iKnxSoBZPi1vC2ZJ1RVc5iB0ZsYWKSAMPvQXVrZ+HbQeLT0qNRlU2fgnQ5VsuOh4q7
         kS34fjvg5SVuIQJkIkLTAdxAmYZbhytBI/S/hwZCVBPf/Zty0oyOAeHhqGNkHT4ToQ6G
         x18o00iJoaoVQbK9Ce7LckJaGVM1dovdrWR3SZ55yFBT56Wgi1A2to+pwlfz7gG0N08+
         TtD73v8oUGXHYR66NKiFJtWtXSgESNidWLjP0li72x4zKaQ3Zl3l//xYEBmtXiVTh8Hu
         o6z7uKTc0h6M+/+a/c05z3JDuahRvDgfAUbDGHxWWjtZgZbr6vZO2/T4LOgcKaTvGUxI
         GPFg==
X-Forwarded-Encrypted: i=1; AJvYcCUtehEF90y3iy/7U9nzDOcKQgmrcLISMAyL3qN6GzXJMP5HrBSJFRe1k10T0xlLk1eyGfhxx07ACw==@kvack.org
X-Gm-Message-State: AOJu0YwwwpqJjoWb7gI3HQxT1T9UVLKTTVoL0UYL0vR9/KLxZytLvbj1
	kn9Mh1UPeO1wFN3IN+Pa2Wt5xGbTkO9efo8mtR6GZ+B/0/JOKQiVSvDKVSNDhObvFRGLzz3hYAe
	M/vrHRHK/PhEsbNdTbOZVZSBsqd4QkSI=
X-Gm-Gg: AY/fxX72LU69ExqzuWB0DOYnt6u1v2itVcRbB3gO8jeNTva/ffAOXS3xqYfdFdDk7lb
	zPfolXECDMDL5JNych0JMS90GuDc2iPUblIiVKob4EEpJT7qPxvAWSF6qFClIiuz6pvNOE2xcEm
	jDi2wtAEWNz8D6uSP5832Q8eH4YUhm+r0sqrNS7WQ87MK2ggYNOQ2xLSvBBkGY5YcheY6vtad7a
	5UG3IblAOeLrTf6T0E9PWwx5VYHp1BDQVuTQqwzQRKWWBSQiuscrQt6H9B4BJT9VAIZHigRlCXq
	iH092L2nGbF5F4wjT0HEE4u6aYdYmQoWIkI0TMME2ZhHatbaufaZ+cNL0W5q
X-Google-Smtp-Source: AGHT+IHlXYzvUpNTUVTBBIirRZTbyQgrFwlw+ctUveNxG9CsA5cZWuJq5+cXiK7IoQToFMARGTelxtYTjQeKK8cGsWs=
X-Received: by 2002:a05:690e:40c:b0:644:5bb4:7b02 with SMTP id
 956f58d0204a3-64716b9b89amr11966863d50.29.1768229456814; Mon, 12 Jan 2026
 06:50:56 -0800 (PST)
MIME-Version: 1.0
References: <6964f35e.050a0220.eaf7.00a5.GAE@google.com> <20260112133815.2190-1-hdanton@sina.com>
In-Reply-To: <20260112133815.2190-1-hdanton@sina.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 12 Jan 2026 20:20:45 +0530
X-Gm-Features: AZwV_QjARb9LLRGnT6VuwKGPoAGdxehdX8bvZUqlvSs_RWCwUZR0FmWi_jJLjDQ
Message-ID: <CADhLXY7-56WHoQcQAiwFHf2y80WBd+1G7veU9EoZCKXuFXXPhA@mail.gmail.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in purge_vmap_node
To: Hillf Danton <hdanton@sina.com>
Cc: syzbot <syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, urezki@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 1z3ub45ksq3b1mtt6n5zgonzsks6j3ac
X-Rspamd-Queue-Id: 185DCC000F
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768229457-46352
X-HE-Meta: U2FsdGVkX19OSgD0iq7NPMkieqDiEaNry+NylvA6rD1U1CdkNnyQV8G73Pj4GUy0x48yQyDrbO0OPD8x1WuWzvhDqs+I3k991RZE29HtQ1PWEvcKJKEhJekFfImWPgjlSakETo3Cr8aJSMr4FwKie+TyP/qNzmQiTYzeH4tt0bEIw3JMFYpokcN4SMpmBwqwy7EfslSgvNK9iKGsp387lfKISbY6OjgJBU7LUn9tG3FbgGeSFi3O8WQSDVw0WvPBT6eNy2XbVnpHZuYUJB9eG++h+n2xKlZ4az3wQKhtYPqQvgsmiy54tWlU6JNmIXXj3tWtq+4cSPQkXr4gnSSAxKyJ83nv/9xOekFm0yn7NVcSpbHwGNGm23HR+LMw/WT4Lt5dxLaGp1YTa6X8QXWn4vyYjcy03CL2t0GQiW919JdfILdVcs0kNicCAJR85AavYl3yCiMm3v0YUNMlpHBNHjoFP/xbTVPHm3YePcx66jLRn8+hEh36y9soLAQzNrNLhjYDrKtI3Qjkr/EagiHVMLErUdSW1kZkGirRWstD3rObw+GrqxMtVKFcetVFjjZRQbcrfSpCGqGVgsigC+D2t/SSWNnjZ3+vQBXKZYh1bBwzHuo8w36OW9WWsizFvjM+6qnn9G+meydRPHMoSk50yRVfAWtaWjEaSwvjU07y9qFPJ7tIArMb0lZ9SqHRNVfnK7Kh0Nwf/qOWTg0o1ITTXfxZ6yNz23u714j3eY/snO4zdOIIybJDYj48Fwt1bL23K/HUBqZwmEoqo3PRBrHyfn63iBkfhQC5m8tUDgYrFqs10t8/mDXMHD3dTlrlL9GpA+U702gJAwXOmJNMe87XZHUJS0kXiXuw4xlK5L1oo5FCqawracoBT4sjM3j4Ym7mvrbV/TW0HlO0FfWNmwl5EYzyD7PdIEPvSb5iPXZBiMrOMrpkSGPnTHPGpAfRKlhwUCxw4grsM5GbYgyySOz
 Bs21Mv5e
 v12DVX1I5HdElRVIw5pUq1On5B0f3VXWShXRItwUi/kqeqrLE1MxuULRZlZ7yzDGLp14kn6ucyMEuxM1RgNq/+kTPSORcvXr5uhACixjUTm+sPfY1lzxRlnWQxgO7+f9Jq26eVDdZ/rLW4HEOHTMHLV8NrQcCdUNTJegYCyTR9rymNU0Z5M/Dfy6pbi7smHnwm+5yD90kMMtZSJrWwZQ6m2r/WiObU6PTxDUZU1LpiIwPaWsjHwOHM+Fi73NukPzgED4il4xd5XuCg1uxQ4Ixh+ZCQ2k2qLko9tLCf4m7BJBbcDjjJtaQcja/ocEC+Oh/IWWI75dVUbjudqn40b5hhMjnza8bO3tnpY9U+mmflYS+uORKaDRHOWMaMUBH61HesjLBOcepKHcdcmqdq9W3ZQFEuEQzr5G6AOaGOIfhFI+9QbZxbanEG0nnKdlytHy2G23WPgEdIspMPIpxv38IIaQPcHb/IFdBvpjcYqO7TyZAalNUI6iGHeVuHt5LsIepAv/lIqq61n5XS6T1myLwobgfr5RxbyuLbMiJhF7EVbQK0ehOSHcLOGaxaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 13, 2026 at 07:08:XX, Hillf Danton wrote:
> Given the test result of your patch, can you specify the root cause
> of the stall reported, Deepanshu?

Hi Hillf,

Thank you for the question. Looking at the stall in the test log, this is
occurring in a different code path from what my patch addresses:

My patch fixes:
  kasan_release_vmalloc_node+0x1ba/0xad0 mm/vmalloc.c:2299
  purge_vmap_node+0x1ba/0xad0

New stall location:
  __reset_page_owner+0x84/0x1a0
  __free_frozen_pages+0x7df/0x1170
  vfree+0x1fd/0xb50
  cleanup_vm_area_work+0x4c/0x100

The root cause pattern is similar (CONFIG_PAGE_OWNER stack unwinding under
RCU read lock), but manifesting in the page freeing path rather than the
KASAN shadow cleanup path.

My patch specifically addresses the unbounded loop in
kasan_release_vmalloc_node()
where we iterate through large purge_lists. The new stall appears to be in
__reset_page_owner() during page freeing, which would need a separate fix in
that code path.

Should I focus on submitting v2 of my vmalloc fix, or would you prefer I
investigate the page_owner stall as well?

Best regards,
Deepanshu

