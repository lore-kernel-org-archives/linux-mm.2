Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD869EDF176
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 16:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43AF6B0005; Fri, 13 Feb 2026 11:05:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEDDE6B008A; Fri, 13 Feb 2026 11:05:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF0456B008C; Fri, 13 Feb 2026 11:05:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B19D96B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 11:05:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D47B59800
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:05:22 +0000 (UTC)
X-FDA: 84439908084.11.29D703A
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 482EB180009
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:05:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d+RGa+qj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770998720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MkwgwvPc/TGYeUZeINeLlvuSx+DqSyksHTVEFDYyaw8=;
	b=ikap4BWobamNd3S751Bx8wM+jPkqI069uqca5BDWhG5NQgbqZM5qQz1gCuaG+qAz4LPm7h
	cehupoA+OOVbPp5gdHDhI1jLzVhH+3pP5c+3dyqQASX0kLh0OEUtcxme+bVW60ctNiWQbf
	sjk9OuiTvC4W8gGiayzIYJnc4BwNEhw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770998720; a=rsa-sha256;
	cv=pass;
	b=Q2fHfeFKdmoRnVsVoqWjm2uonPpyU6uO1MkD3QVM3w3hOwxxWkCam1oLy9xeXQWQc18mb/
	jb8TJUBiGOB21xgXg29tG2q0Kmkfq/8ujL5RLQ+Jqq+aZo5arzsRm7iu+T8WSEt5pWG00i
	mRqZ2SiMfcPiRtF7F7+4fagR5RdMGlU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d+RGa+qj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-65808d08423so1646630a12.1
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:05:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770998719; cv=none;
        d=google.com; s=arc-20240605;
        b=hQxnXVn/+wkFVlFqB09WwiWIubN2PxbXxlsBDxW+BdunsGN3ShLqNPMQQiP7sdNojN
         LKxABDjePbptkhAfgJTngnYWrecRIVXsQ98S6qJNqGKtODBe3q+CbkKaBP3pbgsKAk+5
         Nz5velYz/TKshAY55p3YTFid9RIx1y6qyXLzMR5Qe4JqvQyhg1/ewJ6yz+m8HvPz45WZ
         ZmHGx3Dybm5MWx3FNOVBY3GrQcrEdhX4EpZ+6iYPZ/M2WtYodj39WDs/vlKN1Eel+gSb
         ke7Xo7EZwsT1IJaVBkXRTNQgsUw6D0kOkjsKDbFRrqx+vEVIUm3ctVmcHXwnPRscZdKM
         xJmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MkwgwvPc/TGYeUZeINeLlvuSx+DqSyksHTVEFDYyaw8=;
        fh=mtKGnfEatMpO6/5y+fnMHca6JomkZzo5BKkq0yfnuIE=;
        b=iNbQRN1BLyJPl3ybnl9xxks1kSWShBnuAzkmLmKJz2be2j/4mh1iqMp+4SqMRBvvw/
         3V8pokFyatFyRYbdwZb0hcNOct9JIYH7ifL1CfPVGXUdgk2NOVP4Xxxd7nqsIjzzOAuv
         iFARC7tNf7O25ohu7blsh/9W6e4s6aeJqbaZkLq/80QWsmQ8Z0ZvxPtUTFlcVtqbYO0d
         dlUgyNhu1LQMoUmbKiYvpZN1wyQRm3ONxYK03IlxiOwCpQmMT8z27y+UNAFM1oKs6YyT
         O1tBYbjyz+RKl85gKDIkyPBBxMpkaRhUokRlbSIMH0Ef9rIdeQyLLbCX1uXYaFp2YSem
         OEaw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770998719; x=1771603519; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MkwgwvPc/TGYeUZeINeLlvuSx+DqSyksHTVEFDYyaw8=;
        b=d+RGa+qjKbk7XGkJHv2QBSV2YTh0gZYinhtHQvBhwRU2ZBkJ2kZ3RKcBJNoeT0QQpu
         xSb0UxxVIr4XLBxzFREk/TlwSVcrE00Ch0RKHX+J/5LkIo57FslSU6Ybg1Sr/KAfSwmd
         WGuW3STTIGdtp/DtUyzdm4Fl8bkmKJKzLUJ/ATBY3AveMOdOZbRTeReSsl8axSWpdmh3
         c46AYwBmniLvsa58gKUcxvLyYC6uLI0/Ff8kcP/sWPiXUEcvye+mhsgHF/dK+57PwBv7
         ozedjdptXgWGojL5PjAwBgU5ECX2O79o6gYboM/jcLdJz7Z4y4Z5Y2BVrQ4tiFj8qFMk
         34CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770998719; x=1771603519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MkwgwvPc/TGYeUZeINeLlvuSx+DqSyksHTVEFDYyaw8=;
        b=VVMdFtkZBfDA4F3ZZnr73dsS0Jci0134ffaAAwN2wdH0wo5GXUA5vG4uXDgiYdTI+U
         8tYcb9yGqTAjp9eXPmskt/zTrhTRMAiqeDeNtudTBSwYxtDqtYJk+OMYDbmq/JNU2dFs
         s5qKewx+7VuUm2cioK+1Xx2bnGwIdA+Mbz5lgrGcvQWpXLCvpqkgC0FnRTk0gqDSo8+a
         dypXzz9fst9Nyt3vgRKhxEeh4HMOZXrblglANpUSSMeSl37ulsC1SmhCD1zYGQjvLjP5
         lBdAYQau+El+dKuCflQqJFmX6sRqA/7rD7CeGNKKoGeMPMXeOPSkmQsXwNRerLBlAxnC
         3XTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZywgsf5anE/TDPO/EabT/ra1HcxLD4utngMCsiRRAgaB3bj9OG1okplemZxl/8XfrZ4Yr1ScN0w==@kvack.org
X-Gm-Message-State: AOJu0YzfcHFW5gmuSYwbUGVJ4g2m7h6hO2sq8tQCNKLA7ZClBoWXOwYJ
	jY9+983DQnQj2JvI76IsHH543fJN9Yq+a0XCix1laQpdCpI8eaZo/tOFormfshSpBZ3jNgGEvnx
	hRFGovd9fw+6nVpR8BpE4CjMn8dC4ioM=
X-Gm-Gg: AZuq6aLym3Xu6SxtHbn0VmAbOpTWNnUllr5sWYaX1lim6bMT/ML3jTf+xWACx43A//Q
	iQnFkcnTaI5gc3+OzSrcPOVz/iP8th0Ho4VXWcSs1EAhAUfksB3+Q/yCrfjbMn6MaItuLiL1krE
	GRT14xUVZsAXxtUsSkP5U7HBdVVf4Lo6jrnqX5vALL5UuiaPwBICtvlX4bxUVRrDGBhWmtFshTX
	oQUN/AeQYykjFXv8eGtjYxxcGZaw9z0YzmdSD+5wu0HG4zROvAvmN590JAS8v3wOnprvXJBympe
	cKaViFgLKSVn0vKgpoFLodbB7sf1rsNhhe+dcL+T
X-Received: by 2002:a05:6402:2811:b0:658:b87a:6eba with SMTP id
 4fb4d7f45d1cf-65bb1179568mr1262757a12.16.1770998718382; Fri, 13 Feb 2026
 08:05:18 -0800 (PST)
MIME-Version: 1.0
References: <69859728.050a0220.3b3015.0033.GAE@google.com> <CACT4Y+bd+PcL=XzkehM-bmsfAB95UA2y9jr5JY2ov8zVOp1DWA@mail.gmail.com>
 <aYYkvaqYGLXD3_P-@linux.dev>
In-Reply-To: <aYYkvaqYGLXD3_P-@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 14 Feb 2026 00:04:41 +0800
X-Gm-Features: AZwV_QhLIH0quixbRtysZ8YmE76vHilB5tNwj7k4LwVDO7mxrympCqPOI_9dgy0
Message-ID: <CAMgjq7DVNMSez70O-3v1ANuCcSzgwaXckusVcLyT6T=UD-WNOw@mail.gmail.com>
Subject: Re: [syzbot] [cgroups?] [mm?] KASAN: wild-memory-access Read in
 lookup_swap_cgroup_id (2)
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Dmitry Vyukov <dvyukov@google.com>, 
	syzbot <syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 482EB180009
X-Stat-Signature: rsfdei68quahqunadmz6rjkwhi9osgpf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770998720-54445
X-HE-Meta: U2FsdGVkX18KgAZ5dQsHKVYT78v5miH+2YMzSbFQGVJ8nNPXB04sTwKW8VJ5VdTyJAytahEcvxWjBatEDPFG914MwGOoF3DMH/A9G74oXzAnfWPOf/fcZ2bUd0oMti4oOPV7LVhcqiWNobKj5IjPxoAyiKmN+AmUtQAsPXFVHpv70H+vyzVDmfOWc7pm7CfiVTTwDZg7UG+SxZHquOoANDXTyXy1FFSRyl4SyC1aFT7UP0wA/l6hDbNoKxdna3dadTL6fBu+Zayj4ibDYHggcbu3VPE0LyGzE0LUNMxmsbq9K6FzObfLcmbfa7pKJl9M+7XTIzAva6fb8U8P2LlUykC/msnxRCWeAJf5qHZrwInP/M5etpg2jOsOUKKMLyTA5+TrxD6QplCdHgJAc8Vi977Rodf4/g5dU6ob+IisaX5TxPiXxnNCSVEH4VsnxeWaRvAGPzdeAuogrynSLAzjeiQgx36dSQTacyArd6X/GM+V4VxbG3/V9ZxP1xqm2D/PVPJ3eACdrVgWjDAKqIaI+TUy92SOCKHHimkb3H6IBHNQDWebT75li6/xPIb2TNKqaCPQXTIjG/Mt/FiOQ6fMAJ0p7gUfT8JObxObHSdil/t++01aqZHYSW4v0ywHQvMMvSSoExXqJZbypXMHwVYlXVwoKRVMfYBFsmD5MOlqta4tIzS5mN65gmAvr7LV5Pbcir+MuqVNU23fkjbQUEry2f7WxRRiiRKVWgvP9j4xqUI6TQMErPTEvVSr/CHZkKUj68I3Iq0+eQJS77/eNcz6Qtym5VCRjn8Uye3q44YZy7G71wbBoq6kzkCXI2jhbBsQTMgLrPTcowPxBs/PK2+Z40Vh6/bdGoN+KQUV4J5QPEw0wUfDUBJtnv04GGXMs3wQbbBc3nSfLWecXHChNIouZBrNqQl8bpfZWHS3USTsx9McX1NkPNekAIFyjB4scHER39cMV6mtZFaT8Xl3NDK
 b8arRc//
 QHFl602q2cKKIecXTO4UkGfNXlm5yeQwq7XHT3cVOy3egMqlHHVHxHwRCU0lz0JDrEWRf+iNPAepeA6Lz3kWRltRowNnx+MEdBHJxIFg1rwC/inEh6QXx5xLufgsmnoL2nxTib2lp7wd59SmikCxz969J1h6yyZfUQwF9QixMixnuldZgFrVsZ/PBIx7deFydiLYT5XakI2Eh3fviu82AlKqjgVsRio72xs4O3d1LbQMcQRb3fmF+WqRFm1yQf1JZkgLMMqmoykXRblUmXLG4bTE7Nr6p5o18P2sBhBQ+2vECOKg5nKUV5DasVtdkoyP53oGJmMRFJyLXrP6B4K8sdQZnij9iPP77r9jlF/ksZORG6cGJjX869l35uY73sZXilg+xQRiehbLRfd0dDTXHSlhZU3G77HuECHHHTLpOkqEuWUPXoja+p+lvxftB41e12vhbZqsG1P9ZvviTdG5i/MLVNYns6Y0P2fPz+CGfvcd5rjfUw0uDIt8RpyXpA3qc9Khjz5Vf5wCeJuWY7jJiGJDfXlP44J0ywtHqyZ4uv2GrvQlFobMmc5nZ+qGT7jorGeTOVvyH9JCGrr44MXo1RxDCmJsYBsvC/VUC6npTUzBlTxKOD1MIZBM7v2l0IvGh5mR2fC+wD5KtYiMx2+LtfjrRGnU5zpF/MLblCfOKDc1OLkOxI9vbyvKV6GTg55ZbTR8aDq3mRvFSCy/cag9PkAJ9psT4mxCniHWC8MkHN4YWE6S6Nr8pRotfEA17cgE/j6kkdANoFCRKibnrp8V6vT4KjaQeYFdP58ZZ4Hi0jI5zfdqqpMb8gNn9SEh+fvD5AFrXbnA7eCXfrh0SfYY2eZpuWh+yPvIseNmcMHKWRJPmI8I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 7, 2026 at 1:30=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.dev=
> wrote:
>
> +Kairui

Thanks for Cc. I just noticed it while cleaning my mailbox.

> On Fri, Feb 06, 2026 at 08:31:19AM +0100, Dmitry Vyukov wrote:
> > On Fri, 6 Feb 2026 at 08:24, syzbot
> > <syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    18f7fcd5e69a Linux 6.19-rc8
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1428fc5a5=
80000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Df1fac0919=
970b671
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3De12bd9ca481=
57add237a
> > > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils f=
or Debian) 2.44
> > >
> > > Unfortunately, I don't have any reproducer for this issue yet.
> > >
> > This happened before:
> > https://lore.kernel.org/all/67d04360.050a0220.1939a6.000e.GAE@google.co=
m/T/
> > and now 2 more times.
> > All reports look similar: exit_mm -> zap_p4d_range
> > And all access addresses look the same: top 13 bits are zeros, then
> > some garbage (0007fffffffffffc).
> > I am pretty sure it's telling us something, some kind of tricky race,
> > rather than a previous corruption. Swp entry is somehow invalid?
>
> Thanks for the report. It would be good to have a reproducer. I will dig
> deeper later but good to have eyes from Kairui who has recent changes
> in the area.

I've just checked the syzbot's console log for the two times it
catched the error:
https://syzkaller.appspot.com/text?tag=3DCrashLog&x=3D1428fc5a580000
https://syzkaller.appspot.com/text?tag=3DCrashLog&x=3D16c2c694580000

(from https://syzkaller.appspot.com/bug?extid=3De12bd9ca48157add237a)

In the first log, before the panic, console is full with:
get_swap_device: Bad swap file entry 4003ffffffffffff

Which indicates there is at least one, maybe a lot of invalid swap
entries of the same value in the page table. Unfortunately that's all
it can tell, maybe something corrupted the page table?

