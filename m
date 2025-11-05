Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 511BECCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 08:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402698E0012; Wed,  5 Nov 2025 03:52:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9548E0002; Wed,  5 Nov 2025 03:52:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315ED8E0012; Wed,  5 Nov 2025 03:52:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FCE98E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:52:26 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A538457AA3
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:52:25 +0000 (UTC)
X-FDA: 84075937050.05.AA8C4F8
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id A5DACC000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:52:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=aTilbZ0R;
	spf=pass (imf28.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762332743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gkg/vCbQBbLgfYhLaxoF1MxQ4LNFqiCSVDKlCPX94O8=;
	b=eCDhqF7yYH8b4ZVCNKNzaQnOPtWQUYvW5GXGZyfSp+zSnQH9FXJ/rBmCo5JC5I0yy5p+ID
	AsoHK5WRf4wZfxvlkbJ4iF8UciaySd2pVYCwr8HayBBU0/njgKbO9d2wYiv1S/23YrMIF8
	cLx+Z23gFVRfRgKVBjJ2SjGrY4u/AlU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=aTilbZ0R;
	spf=pass (imf28.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762332743; a=rsa-sha256;
	cv=none;
	b=hi5KKp5jZgsXg8sWTql38K074wQu45T9ellCBRuLXduMBpWnsmHCNBCmKYmjnXoYTBHAX8
	8y3mfJhGzXWTFCGFuLSbvUtNW6hv6FnDyJepIYOi+WWfpoXUOvUFOA3oDvW75HDq/q5zM2
	XHeDYmt0ISE3yP31cUFEY17KH6aMH8s=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so5723180a12.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 00:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762332742; x=1762937542; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gkg/vCbQBbLgfYhLaxoF1MxQ4LNFqiCSVDKlCPX94O8=;
        b=aTilbZ0RKCs8rd7AawdiISoqokmWo5PR1CT1Zq5ymGr/9v7e1d8k4JFRJ5mX0gyvPl
         oH3oSPCL/FLcMU/CYdNkXIeIDEY2y5KqplvcG8H9wSIGHK6uDha32ymnN6yMeNyialAc
         pI6G8giEbtasiCk8rUcoAdEzvMfvYz+7V5MND6HQaIN4/Gspk90NlvRYT17pt6imisJo
         e+Df+MJ0KvMXb3adW8zg2W9g2ASHmPjSCmx7U6Wfez9PBJaJNBo8YD9RSbnqc/Tzlvs4
         H21O0YPo9e1PBnRrWqxIpCayxYlfF04h7ooKtk3Lt8MXlBwSkXr+LJXhDA+3oXEBhBVT
         tqsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762332742; x=1762937542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gkg/vCbQBbLgfYhLaxoF1MxQ4LNFqiCSVDKlCPX94O8=;
        b=BPhS18DLbRGyl73baGcVn+5tjGyMAyIhWQvwhmnzLzd9dDNr60NfTAIk7QugAx0nfw
         kMLAknDR2/2/aTurs/0rvYTuCXxngfyejy02ZIqfMkiliXkBShrWSXkd1wHFGQMYe756
         mWMjhnVZzdkfBrnLiFOsLwqRqyzDAw3bFOtH+HGQzrK5pu+luh6a8Q2HhSWjrsz04/nx
         WjGM987Wrei761jIO9sJFOyIM0+vOfK4rX1CHx6CRVvWi03bv9QdbWOLR5784YvYfALU
         LKgtLcsldCK5PdSSppym2SfvOnEI46Zwi7NYX9JVU1a/xS+scwDaBnqDEHoYyAPatTCB
         BpOA==
X-Forwarded-Encrypted: i=1; AJvYcCU0uhcHYcnpasa4sX58qVQT6PGF/j34wPHqN2mmncOEPOJKgp6+NltQn9n80jGRxfgFXPr6cya6uQ==@kvack.org
X-Gm-Message-State: AOJu0YxbTvjlKqnl4Qy8vcP1SKWKaxGHbj5cPHHE13d9RCIswEZESqCW
	qJd50CN8lk5+FqlEVAFPhIs3cAklcs04iyYzWQjbRMOzgteYKAzx07g46DkhYDvtMuBUcS8fl50
	e5CFusT/2FgRiuEjfFPhYCHaGQIQIE/g6y1kHSXV2HQ==
X-Gm-Gg: ASbGncsFP6IP9yd9mQJL6E9Sk1Lm4D8V8MAcxxxLbC+cmg2rNbD27FH6+qQfBbhoSCb
	MklNglHPj8eMroojL1QQb53MOHPMv5ShQEdbgGBaZ5sPNVjQ38N1PVrOs/kbRfCCiC3wfytGk52
	wJU+aZnXdtWIWMozJrWhlVxjGJl6TKsutIykf5yFqdwQwu56elSTuoAcCp7Fy7P+6rYpqMURpOV
	OBcs6S12h4ip/s8ajGkmi3v3I1CI3egMkpE/ZI6L7Idx0KtWEUn+4sZUKpTiejsRohisA==
X-Google-Smtp-Source: AGHT+IFxxt2EdxGwLdk3L9EezdOqzEzIoElbn2uBq8KS5FKpSP/CV4oKR3J8eSFfaFisM3JEbR7uWvI68mpagt1N8hs=
X-Received: by 2002:a17:907:9815:b0:b71:cec2:d54 with SMTP id
 a640c23a62f3a-b72655a5d40mr200972466b.57.1762332741872; Wed, 05 Nov 2025
 00:52:21 -0800 (PST)
MIME-Version: 1.0
References: <20251105074917.94531-1-leon.huangfu@shopee.com>
 <aQsIq_zQXMfNNo6G@tiehlicka> <19986584-885b-4754-b98c-948e4bf9716b@linux.dev>
In-Reply-To: <19986584-885b-4754-b98c-948e4bf9716b@linux.dev>
From: Leon Huang Fu <leon.huangfu@shopee.com>
Date: Wed, 5 Nov 2025 16:51:45 +0800
X-Gm-Features: AWmQ_bmvHlhc5eJ8ueTjqxVXAa3vivPGkX-f4MR8OhK4W12VAolYXW0qkjbzZYQ
Message-ID: <CAPV86roGZa5q1N95+ehdPRE6GkXr6bZbEU89--BgpOD8td5SoQ@mail.gmail.com>
Subject: Re: [PATCH mm-new v2] mm/memcontrol: Flush stats when write stat file
To: Lance Yang <lance.yang@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, hannes@cmpxchg.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	akpm@linux-foundation.org, joel.granados@kernel.org, jack@suse.cz, 
	laoar.shao@gmail.com, mclapinski@google.com, kyle.meyer@hpe.com, 
	corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A5DACC000B
X-Stat-Signature: dj7g9a3wjd1s4pe139znistxd54zf81f
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762332743-12044
X-HE-Meta: U2FsdGVkX19caMZwpfwx/K5vVj5i1Xnyu68FODFA7PddFkFUg9RhIshfir9RkdeBkFFVc57JfFqKodXMS+uaB6lEDvFYuXXZRCxSyyPF0VBESP6bgecRBD4UZsUxZFZ55aWHvrrXpjtvu3qn06UAf5+zDL5RvotxxL13ek8CxhLxRltm5Io4ZWRFchj8AWJmryYnrq2Rn6x6kKvYgnoTNY7sbZoeIKRJ6g2y94n3+0ILF5t3rYbzOtOE71XBuegwb24LykwY2diFRh+uN0JjjdC6I1DOpQbHfwtstnFQ5KOviTWDfD0o3T6dp16aC72ThgrfePlwz6RU057RMtIWHCjpsMRiB9jN+dj5VCiplKcMIY7ldJuoX00WEJV/eNQrpBwSZ//mPsJQ6zUaby3r0gFW7SqtdSsp43dKx82lkC7BfQXW1cr8UnuddVch9/vbkUMqRrbc2Fw/FIYT5za6PGKU9yiuRGPgI7f6AKOwuKfODMOfxflWf+HkWUAh4Yfam0/tFTm77G89tN4yWj+xUpOBnqshL6IFPOIuPFqKU5guCksxkkNK7tx5BG6B5/6E5526azMtvv2fjyE7gPoDDXXfQkBBpSzETVg80qjGMzoJqF/qJa4vsJrM4aGDqIJeqQ/GHuo3GEygW9xGD7khe+Zy4+6uO1jtG4oE4kOx+FgPHV+fVk19h92lWq8Sq9UI9vbj+XC/SEg7VkMHERDM9IT1vMD2Lceoww03RmK4CpLNp6Veg1RL4NcAbaBK81I5ZTjPHEIfoZ80RKLpza0zr/NNsxXajabrtoDOAGpRCS4cI0Cjyzy7kVYqsxscaJfHLDotTnhJ3VZNeTHGe1cIvb9KRImOI3ulSEFe7wT7Y2RSJKfTZmO5twEeCTbupac0WpMMXUlP4xL6Y5SbwllpFvnqs3VK2pZ2/tqdhdsMIskD1Mnu0er5LkAQO/opv6RQp19g3XW7nUjATHXK0kP
 cUPRxaRd
 QCIb/dowaRy5s0FhUaocF1U1it3izunqMShTkHTFZBLrqyfDk/TV1o61FuP35s7fN0GoAIpuyqrrm1/T2XShjDcU1bdXA4CrwKkfd12YgZ8ao1xYtV83QPN2oyR5cNMSwSvx+8JCpf1kSgmxx3y/kSTP344WierLwi+yWiWp6l2mtcfO8nn+8LPuoLvNWxWBNVIy0tQ6k1KpCVZT0H7QLVRJs9USZ9J4LZs+VEwuL674MAyo/alIXQPgMo05OKHHmydRSGttB4ZE8r/I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 5, 2025 at 4:39=E2=80=AFPM Lance Yang <lance.yang@linux.dev> wr=
ote:
> On 2025/11/5 16:19, Michal Hocko wrote:
> > On Wed 05-11-25 15:49:16, Leon Huang Fu wrote:
> >> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> >> index 6eed14bff742..8cab6b52424b 100644
> >> --- a/mm/memcontrol-v1.c
> >> +++ b/mm/memcontrol-v1.c
> >> @@ -2040,6 +2040,7 @@ struct cftype mem_cgroup_legacy_files[] =3D {
> >>      {
> >>              .name =3D "stat",
> >>              .seq_show =3D memory_stat_show,
> >> +            .write_u64 =3D memory_stat_write,
> >>      },
> >>      {
> >>              .name =3D "force_empty",
> >> @@ -2078,6 +2079,7 @@ struct cftype mem_cgroup_legacy_files[] =3D {
> >>      {
> >>              .name =3D "numa_stat",
> >>              .seq_show =3D memcg_numa_stat_show,
> >> +            .write_u64 =3D memory_stat_write,
> >>      },
> >
> > Any reason you are not using .write like others? Also is there any
> > reason why a specific value is required. /proc/sys/vm/stat_refresh whic=
h does
> > something similar ignores the value. Also memcg.peak write handler whic=
h
> > resets the peak value ignores it. It is true that a specific value
> > allows for future extensions but I guess it would be better to be
> > consistent with others here.
> >
> > One last thing to consider is whether this should follow
> > /proc/sys/vm/stat_refresh path and have a single file to flush them all
> > or have a per file flushing. I do not have a strong preference but
> > considering both are doing the same thing it makes sense to go
> > stat_refresh path.
>
> +1
>
> IMHO, a dedicated file like memory.stat_refresh is a much better approach=
 ;)
>
> It's cleaner, simpler to use, and much more intuitive for users.
>

Agreed. Thank you both for the feedback.

You're right that following the /proc/sys/vm/stat_refresh pattern makes
more sense here. A dedicated memory.stat_refresh file has several advantage=
s:

1) It provides a clear, explicit interface for the refresh operation rather
    than overloading existing stat files with write capability
2) It's more consistent with the existing kernel patterns - stat_refresh
    ignores the written value, and memory.peak also ignores it for reset
3) It's more intuitive for users - the purpose is immediately clear from
    the filename

For the next revision, I'll introduce a dedicated memory.stat_refresh file
that ignores the written value (similar to stat_refresh and memory.peak).
This will work for both cgroup v1 and v2.

Thanks,
Leon

[...]

