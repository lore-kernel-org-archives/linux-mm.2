Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E493D277CA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 07:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 596366B0088; Sat, 10 Jan 2026 02:10:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547526B0089; Sat, 10 Jan 2026 02:10:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441E36B008A; Sat, 10 Jan 2026 02:10:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 32DF06B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 02:10:24 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D74BE1A0169
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 07:10:23 +0000 (UTC)
X-FDA: 84315180726.26.E3B6CF6
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id E78824000A
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 07:10:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="PpSsU/vh";
	spf=pass (imf27.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768029022; a=rsa-sha256;
	cv=none;
	b=5ST571IRzukImdxbTaOD7z3MPMCyIBBrP2ez7okTDNjHgOihXKaqQLvNSW3zfqMdmeqLML
	7C4GIatpLZh+4b/gZn5Y8KbAFDyQZZqtOh/6UihUbpoAv4Ftm8B077asxP3SGRZ24GvGCd
	EgMBGa28ISBq+fc5W3fIRvZ/+9UV/ck=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="PpSsU/vh";
	spf=pass (imf27.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768029022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9zhJ/KnJ4nuVYRbgh5GHLh2WMXnDEuhfiTbk330bQs=;
	b=eM/t8VbQVlaQXq6XF2tk9R0x0l0Z/E3A6vHyLFRVjts8xDUn93aGTBh/hOx0hmtK3Vt11F
	3C/6aecdAvBKbPXDXF+JTYJ0xcfp/80EcP6hjE6rndr7AepM0cmrvEKSrLW+qZdNs1yikr
	c3bAj3BTgaSyeCz2IuxwM1MAUgmaaMc=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-78fc84772abso54977067b3.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 23:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768029021; x=1768633821; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b9zhJ/KnJ4nuVYRbgh5GHLh2WMXnDEuhfiTbk330bQs=;
        b=PpSsU/vhB3QpbPO91RAq3Kvinn3a9I3S5wux663GK2k4iZWDmKEXLK1YttrzRQdvqL
         9AlW4g4mPg8zX6rmYU+zVV2TqNvH2kUo55tY8JgdCDAAvktN+9uL5DhcxfR4LN4hKbFi
         xQfLSuVTaNLLkhfN3WLAXpf+q7SxAjwkh1UhceB/PETYdqyqdgTdQv0NIBpkBA/5LdVi
         8Rv6Howg5Zvi2GQiGfqNWrdghJV/oXBwrJWOqhyKLwyaqBavP6XiPweRqN6/sIJiPMmS
         zuzsz8JFSvWfH37XJ22XzyaL8m0Zdr1N28t9kLLU4yVVGFWDf/UNNbsss7b5VKS1EESP
         fUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768029021; x=1768633821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b9zhJ/KnJ4nuVYRbgh5GHLh2WMXnDEuhfiTbk330bQs=;
        b=Ymp4YxaKpN8u38/HKrd33HpOb3HgcpdyHXropHoYC9V9vbiL2PnpAZIAYYgsT3qBfq
         V1nmzWzTR6/akpZc4pHBmEtOGurHdyXRvK2oS6AQbB7A8wubLnUiXWNGzxyTtAOOM5sr
         OevUYIVxxVRa4ZX7K0kwpGBGUt1DKrK7xtbPsorp891ILueu8s2OySWeza6b7nN8GRX/
         F65fs1UAUfOZdTipthpyyoBdA5T4YJxmwJlEXEJaLMj3g4nv4xNVVcoMAO8vkCPmw4nH
         CJecD3dJ6JzZnEMedtupQenNnKRdsdAykcvasyl/Fc0LKO7mpUNvYYI8rxo2+Fyfrrn6
         0KXA==
X-Forwarded-Encrypted: i=1; AJvYcCV2sBesP7kme/2T8f84Pp1A6lidq4XJIn7+oYUdpdiuJsbWnXzPdyItV1TIepohjTcamspZdx9Zaw==@kvack.org
X-Gm-Message-State: AOJu0Yy4n0DyeJRjyH3F1nj+FGNJmw1RmLmQpW4k5Z4WBUzMPnXwmxH3
	IUDOW7JhZsQUi2eK1mF78ye3jxPp+qsyrUPCC3hU6o4dK75a4FlXjsBN7JxtoCFFYUUpAp4Oys0
	mA/1VsaDaRK+Gdlt2PxYyO/GUv7yv+Vk=
X-Gm-Gg: AY/fxX53v0y4xnpwvLS0E/E24Lt4vljGfGdGjWxadN8ugTeEnu0JJEFE1AIm29qzCkt
	NSWWhLux85HhNDQwWQcHPOjzSjIu8GdMZnIgFfISrYw4iC4q+YKq6rdUaz3+tcgspE8bRqAyGMe
	n52dbAgURKjg18N0Np9efNtt0/2AZ9rzfW+slXk3H/eAaH38lZt8KKv2G+mz+D4EmCyPS7ZJSAn
	FRIpLeqGvy3AItDf9lifx+El1EcqUwscdHgtZc68ZvAP71pXJU7YGch6Uno/Q5PYhaQYwc=
X-Google-Smtp-Source: AGHT+IHIllpd7q/rJGzUdqWFNm+J7R1gHevcr8pWramX8OHrYLw1D8uVZpNDk+w/jhy+xG+xc7kXdV+AyejbU7TMxbs=
X-Received: by 2002:a05:690c:7a1:b0:78c:29aa:2798 with SMTP id
 00721157ae682-790b55d779emr116634487b3.24.1768029020880; Fri, 09 Jan 2026
 23:10:20 -0800 (PST)
MIME-Version: 1.0
References: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
 <20251211182429.3300562-1-safinaskar@gmail.com> <eb3a9746-83a0-8271-6bd6-867ecfa49aad@redhat.com>
In-Reply-To: <eb3a9746-83a0-8271-6bd6-867ecfa49aad@redhat.com>
From: Askar Safin <safinaskar@gmail.com>
Date: Sat, 10 Jan 2026 10:09:45 +0300
X-Gm-Features: AZwV_QgfwDamsOA316OsYVlATivpkfom3nXeSEAkD6V9RwdTqcHdaK1zQEU0IxI
Message-ID: <CAPnZJGAvA+SpkMeOdZx+SZG=qZxSXOThO+Or1bgw=3QqCoEDgw@mail.gmail.com>
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is exhausted
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: adrelanos@whonix.org, arraybolt3@gmail.com, cryptsetup@lists.linux.dev, 
	dm-devel@lists.linux.dev, gmazyland@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E78824000A
X-Stat-Signature: dhu1348s9kx3133ha4f1s6631paojgkw
X-Rspam-User: 
X-HE-Tag: 1768029021-666087
X-HE-Meta: U2FsdGVkX19R69sEKw4xZWJkXEDHjDjLa4cd5DcQk1JCdC+RiYMCmNJw5G7Nyr71aKJVQlETwzxyU//Ce0okOLxGEJV990y6IISRJ+ay2v9tiqWx8LgIp9QOUpuhzpppmjBnlMrwGXlRAuf+2hwAz5MSU9f0fdvCvEN3vflh0e6P9FYPxZ2bNn5ccdGJoRZjUBUIFDApWv4/Br+WCHAvk4IPcawNuUDzmKSDgMBv05petUGGgoZYYouWTxpNaiy9KeiGSffX9iluj8JZPgxmeWPbiaeXRZjKiEPniUGYQ+MvHwER1tsKxvHUsR/IGPDkFwBh70d9qZ//U0FlmkpMnqG20G1VTf38R59XeK6GJ5p0GuGxjwZzws1WcmAWfJAjqOBZHpFSonPp6W6JMY/3zJXBx+qyORIL+w8O7Mh4vga0JsWrXhQTFQXDBTzLvWTVdzmvOeMXsavKTMnDw4QIr5Ym59t1utkcwOgtwhUKZrj9Crs2gx/o3Y4o8PJXGe/uxkqDXJ4GHaROP0hzdFS2FGq9jdnQ186JBWqnw7E1n552EEcrX53P5mKuGsOkaIG2Qi6he4Qwybz5PFQ0ZtPdBfvOq3tap8o7DWo4pzhQJM/ZOk80BJI9emgWLcYWFIrPGrJpJMCVFvmQCuLacdn9muhWhpckQ763HSOsEsI5oEbrqZ0MFRPmv6vs7d8/rUpWS6lOL4nX7mWnZCNVMb1UovTTbRWSnKIjtiMMwbAMhU0tP8oJH24t8BBPKUorAO8nMCLX2rQ6KgZmhCApoZrMsr00y2ycMMvislUuJldtz2wJemdrViDWfGDu/bNmz+tMnt/7lmMKgFAFGSg53nsAvYyAlN1Ni2cgS+0YE2XWLdNZ+FqtOKC4mg0z03EJBvsS8a1p6EknayCyZN7/70WmiABxvz58KuzsMoTpzgADMgsAgOgpltNgCpVNVHtPI476TWFcR/VietT0HW9Sipa
 Gg0WAbxe
 8h7hoh9RKINGVg0xliV2A2scfwbQ+SPYM1kEE4AooVmTkpp47DpUA0sQj9VqJ+y9uWxTo1IVIU4NXn13tlr6QIdz1v11JNIO4Yk73nWDOxg1m1LULeNtzWnvcdPcu3Jz3AcYktIKRu3zYqsOd+Xbg9wwv+Fxvsh1X8jOI5O3fKqS+LzXL7r/w/MOi3zk/djixD2IADYPM1GGh7LIasnfuJpJAoEv6NK0Sql3hBPdu2QEP2uJ8sJLFFJIKDwVb6opQE5zahjntjOX/dl/pWyKVUJQRtzGKsJVTVCW6/f55SgJPUMEI7i4tIDLC3yIkLYQfto5ccCrz7hvLyDmywq5xSYASnCojeF5jEmgOZizov8+EVjkEboZ+nGDD0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 2, 2026 at 4:47=E2=80=AFPM Mikulas Patocka <mpatocka@redhat.com=
> wrote:
> Hi
>
> Dm integrity doesn't need to allocate memory when processing I/O requests

Thank you for answer!

Unfortunately, my experience shows the opposite thing.

[[ TL;DR: my experience shows that dm-integrity journaled mode is buggy, an=
d
non-journaled mode is not. I. e. journaled mode seems to allocate memory, a=
nd
this causes temporary (for 4 minutes) lockups (on high specced
machine). Or maybe journaled mode has
some another bug, which causes such lockups. They are not reproducible in
non-journaled mode. ]]

2025-11-06  I started to use swap on dm-integrity on my main system in
journaled mode. My kernel
is Debian's 6.12.48 with some local patches. As always, I had a lot of
browser tabs opened, and
my virtual memory didn't fit into physical memory, i. e. the system
actively used swap.
Note that this is very high-specced machine.
Swap is on SSD. Swap size is 378 Gb. Memory size is 64 Gb.
This is Dell Precision 7780.
CPU is Intel Core i9. 32 cores.
Then somewhere around 2025-12-15 I opened even more browser tabs.
And soon the system started to misbehave. The system froze for 4
minutes in some moment.
Then the system thawed on its own and I saw in journalctl:

Dec 17 10:29:01 comp kernel: INFO: task pipewire:1303 blocked for more
than 120 seconds.
Dec 17 10:29:01 comp kernel:       Not tainted 6.12.48+deb13-amd64 #1
Debian 6.12.48-1
Dec 17 10:29:01 comp kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 17 10:29:01 comp kernel: task:pipewire        state:D stack:0
pid:1303  tgid:1303  ppid:1254   flags:0x00000002
Dec 17 10:29:01 comp kernel: Call Trace:
Dec 17 10:29:01 comp kernel:  <TASK>
Dec 17 10:29:01 comp kernel:  __schedule+0x505/0xc00
Dec 17 10:29:01 comp kernel:  schedule+0x27/0xf0
Dec 17 10:29:01 comp kernel:  io_schedule+0x46/0x70
Dec 17 10:29:01 comp kernel:  folio_wait_bit_common+0x132/0x320

(this repeats for multiple tasks.)

Here is "free -h" output:

|               total        used        free      shared  buff/cache
 available
|Mem:            62Gi        42Gi       2.6Gi       2.9Gi        20Gi
      19Gi
|Swap:          378Gi        87Gi       290Gi

I noticed similar freezes multiple times.

Then 2025-12-24 I changed dm-integrity mode from journaled to
non-journaled. And I rebooted.
(Note that I reboot very rarely. In other words, my system worked
without any reboot from 2025-11-06 to 2025-12-24 with zillions
of browser tabs opened. During this time I never rebooted, but
I sometimes suspended and hibernated.)

Okay, so, 2025-12-24 I changed dm-integrity mode. In fact,
I changed two things:

1) dm-integrity mode
2) I upgraded BIOS from 1.24.1 -> 1.26.0

Everything was the same. No software updated. Same kernel
binary with same patches.

And I didn't do any reboot since then. I. e. I didn't reboot from 2025-12-2=
4
to 2026-01-10 . And during this time I never noticed long freezes. Sometime=
s
my system freezes for 1-3 seconds, but never more than that.

Note that my load is very big, similar to that Dec 17 freeze.

(And I'm totally sure culprit is dm-integrity mode change, not BIOS update.=
)

So, it seems that there is some bug in journaling mode.

But this bug is not important for me. I simply plan to use
non-journaling mode.

Moreover, even if you provide a fix, I likely will not test it,
because this would require me to use my system for
several days with high load. I simply don't want to do this.
I'm sorry about that.

But note that another bug I reported recently, namely
that "dm-integrity + hibernation" bug is important for me.
And I totally will test any patches if needed.

--
Askar Safin

