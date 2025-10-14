Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F610CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 06:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E8F88E004A; Tue, 14 Oct 2025 02:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 699C08E0005; Tue, 14 Oct 2025 02:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7358E004A; Tue, 14 Oct 2025 02:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0CA8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:30:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA08BC0764
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:30:10 +0000 (UTC)
X-FDA: 83995744980.05.787A968
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id E09D8C000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:30:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J+4HS8aA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760423409; a=rsa-sha256;
	cv=none;
	b=47KevaAtWnTRd5oqvCYojMGkp3rQ/BshYwL31EEWwtOH77q2SlXDRsM0lxQ77gOAoxtquv
	8Zlp1+Rikk9cCSQg43f4TpN4L0Rzd2tkW9TDtDfWyzpugCqnrxL4L7E3WBN5kPd2noit04
	KOQslnICVrSHCv3XAkp8kzSBrs0NkZA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J+4HS8aA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760423409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mY2d5wz8SPhzT9FWDnBCfsBkarH0PpWep0DbN60+1SM=;
	b=8hv2VY3k450R7XITadHLOQ6TdIXN5KqwUs9cM5AOBefbwQulXWSKyy+4rAT2/SWI3RU9mL
	gnvfORFnSom78in37sKwcp22FeHGyDrVzlfxiEtXpyZVa+b7L2zSVt06g6lfJR+Ia5xlMP
	ahqFsee6u2Mrp6qP+Mj3nrXBOLFnmH0=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6399706fd3cso7280990a12.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760423407; x=1761028207; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mY2d5wz8SPhzT9FWDnBCfsBkarH0PpWep0DbN60+1SM=;
        b=J+4HS8aAah9+IrKD7Dul8cnX9dXcut4L+y/u9L1tazpFxkuiYcQKN1ffk2R/qCvb80
         0AwgeN6iR529gFhN1AUkwjE8MD1yXG/GzY8GJjCDDqyA/u0XgTb6SrQjQx7U3JFcKLM0
         ujJnj1zxterLOr6GVrCcK2JNHlv/y2iipffkEyT6uO9pmcm7IZ2JTqs5FcRyFEwYOxRv
         tTZlxNgePxvzD40az1V2Cpb+fk6JqH7DpY0mFbVaGhgGEOibMB4hgMX0vneACLkA9IUk
         gQVEd/tFqx2qxItzTrz8zJIeHiR0j4vFBfw5iJEfcGFoTLoMNc5Qyddw5vOfACGMTbmo
         9HvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760423407; x=1761028207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mY2d5wz8SPhzT9FWDnBCfsBkarH0PpWep0DbN60+1SM=;
        b=HOK7MZDusTDzuJUKSUO2FRrPt2FohHrXy1F+7uj+ExqvCJqmygyJMYnXZKqDlq6utZ
         /fhATXgD5bhD7AccnXELza61Ucz2887Hm7rJzd6QOEkCFdyRvbPPcue9qXEcszgLrhGU
         AGmIV6Q11h924OE6qfPCmRIQpgDcHHhfcDssY9IU0JZ8SDx2WWtoRUboHvQMSrrKweoV
         yY2O8Wax8x7gFm7W7/Bn+b9+c5+ipf5yGp1BeklZzahdTm/u19wQrM+DJNLLPhtPdzB8
         Ohe2xFf53/jgjZ4ed2/n/EZPEBfsix9g+MV0b1pybUpGBoTnqWnTjrEXKY/UJvTLfJbT
         4fSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUa7HJPhPSUj/143H1nlVc1D82BDWfbEE+oV8X74/yPplAL0Nk9YwQwyRnGFwXgcqWYGpCn/wmIqg==@kvack.org
X-Gm-Message-State: AOJu0Yx1eKqyAULn0WaAkpdIhA44lv8nFMSKZDiACFDuLuhC0UdaU/ht
	PvYEuQakaHu2YUgaOBdHy5ciIhomz4mHsK2jzOCyyGvygwkE58O69o2T1hlU1rJcILKV+9wnyKk
	3rPS9c37LNzplNLICk8n7TJ82jZr86bcUrQ/Pl4g=
X-Gm-Gg: ASbGnctsO9h2ZxO6zl/xgByxVvLkacVWHKTP27qFaI8Bpw760tcXET6veHgKHQMyAeV
	KsDGO0cqQK50WSVBJ+ZHPdHX+YL8Q9ni49q/UrxB375YKTDhzp74TO5uV79zYurtIbakzcNiZFU
	TIg79i3mObTA9ox3+k0OTHKW14c360SM1qjIZ80sy9tNy/5EDDyfIJxvkhlMbeZ9DYBSQzTb/CV
	ySD4iKxI6WbW4ethKxCoWL+MA==
X-Google-Smtp-Source: AGHT+IFTeJN8C3xle4lIl1VszJExDN1ZHfVLP79fty/hDfsWXLVGkgQGQJiLdHdZfgQ2JCLp31hFHxNB8psS+idIW4o=
X-Received: by 2002:a17:907:3d89:b0:b3e:f89e:9840 with SMTP id
 a640c23a62f3a-b50aa9a1e57mr2486576066b.20.1760423407136; Mon, 13 Oct 2025
 23:30:07 -0700 (PDT)
MIME-Version: 1.0
References: <bug-220605-27@https.bugzilla.kernel.org/> <20250929160727.a0119e93688378c570a3c550@linux-foundation.org>
 <d2729b26-1bde-41aa-8e2e-b6ca861185b3@orange.fr>
In-Reply-To: <d2729b26-1bde-41aa-8e2e-b6ca861185b3@orange.fr>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 14 Oct 2025 14:29:30 +0800
X-Gm-Features: AS18NWClzCfLGHfCrmfpcSiXHHzGiCfKWn-Hrwy0D95p6tqbme-yce4l1LUUhnU
Message-ID: <CAMgjq7Ce_WXHJeV8tmbRT1wAYY2_2f8G8Z-9tbSjkjOg3077ag@mail.gmail.com>
Subject: Re: [Bug 220605] New: Very slow access on HDD when a swap partition
 is used on this HDD on kernel 6.16
To: Pierre Juhen <pierre.juhen@orange.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, bugzilla-daemon@kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E09D8C000A
X-Stat-Signature: hwhq9d7w3oaf7enth1mtiw8t7gte9zp1
X-HE-Tag: 1760423408-873973
X-HE-Meta: U2FsdGVkX18o6grqL9MCN5+Od8ppvaSpTt9aju2cnHg/qqke0Ll6T2LWnWCaxavtt9rtb546GSqybCKuf3a5Ry6/xp6zKBVGHUuFWvO0p7Warqip3ZCZCp4g6AlZsE8BW64MkbRKNOA2jMJf+YlQTWupxYA6l0CzDQH+KBYSaYMWeQv4aBnTx4KQNlyKR1MGa1wXGmGhY9Mk0zrunIs4wexhKGoVtZuffLL2MBcI3ywscRPZElr40qVwl6KeMqfDF2V4BoMiPmlgBaEEt2wCZ5Gd1DtnN1KM6qSg0bKfbhTJiM3IpIRrAhlOE9fZAC2R5MG20t7oNNskLXsjcmiqQV0kc7blWbckw4ew4Tk6TS0/qmZxMJ8LT9F8Xv06biCDaoyvRiIWymm3OCkHL6v7P4VtGgMO0JsKNWM40tVEkNgvyhuwZVyIR9GkewCKq8pUKpDRz5WSMqOP/51a78dJ1qU8Bc/bc5pA1RDwtWA+8VhWbTbe8faR9z6KHMqKgo+68InqLIJyfRdoVK673QDPoWThgMK6ARuNMAJYK2nY3fRYQc1DnzVADmERKOFvOrk2ZJj15BVu+U0fc7sTFFI9Zkbe8QjJ6sq4XHvM/CkTYgikZtIZz/jS6za8GxPE6o37rcM9nZZqNF5mqr7QaYQNpSLKgk8+fetpzJMVs7OKG8JwV/N8DR0ADu2Tt7BakMUCYnIkwv2jY676EpkacmLtHCr06Ple7LuPzdnJZlOOjj18pFXs0sxCa4bQwtuy3JwZgnXnrtKaZgBw6xzjQs+XYxa+YBSfZWUgugrSk12AbaNJOz1rwikqSAsCdhsCjWdy5AdEnXIie+XqtGIe9b/4UM7EANdXUk3vqWV4yZx8kyu1D7x6iBjF70NzbacK/Msvq8gA6y172ko4Ei5cc4OAApM6fRgGRUrsDtd2J5avqqiwhux8el2yytkkiV0qz5iCP6wgK4GvQBr39m8fj8z
 2Pzc6YsO
 20fzRwafzoBrT2mRQuHVM6taVmPJ0JJpwdhHqzO0RzSERKcYszB042lH7DsNQVT2oI+au/Lid2ZtCJ4pWx65G3qXJUoj2SwJkWcACL1sHZRLJZ3CaGRqIQRrpVuCc17oSLnQNYZBeQOT9wBJR6MwAYxb8vMpgwTxFQIAssjN18kk8AvRDBSTbbDEnISG1moQbeP5CkaQ6HKGZyCGtWshNuRp6witP6PrcW28vbELwaIui9EtB3X9aCexr80TXWDfDNBXVHQ729J6fCDrsXUJb4Bhmht4LnF/VpXMjzQXG3IoKmM/kiAIwdd+DcmoE61uRaeVvQ4687UNE2V4dT+jXAPHB5p/bctZJRhhijQ42TNQ4l5fOlTTpnamDRSsaUbK7973KkjKXNOUtHnQRbiDENdJamg/5io28PAyEr1gkYcLstEhrbnPaiP4d03BLveMlo9AfQvEA+qhRtz9uzo7l6mz39g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 11, 2025 at 3:42=E2=80=AFAM Pierre Juhen <pierre.juhen@orange.f=
r> wrote:
>
> Hi Andrew and people reading those lists,

Hi Pierre,

>
> I still struggle to understand what is wrong with me.
>
> I rebuilt my mdadm + bcache array to be sure it was not something linked =
to a (too) old configuration. Upgrading to 6.16.10 didn't change anything.
>
> One symptom of the problem I identified is the time of the swapoff comman=
d (I have 32G, 12G are free and there is less than 1G in the swap)
>
> MiB Mem :  31952,0 total,  12646,2 free,   2226,8 used,  17587,5 buff/cac=
he
> MiB Swap:  36000,0 total,  35212,2 free,    787,8 used.  29725,2 avail Me=
m
>
>
> $ time sudo swapoff -a
>
> real    6m41,276s
> user    0m0,005s
> sys     0m0,028s
>
> Waiting for more than  6 minutes elapsed for 33 ms of work is bizarre.
>
> During that time, if I try to launch another tab with iotop, nothing is d=
isplayed during at least one minute.
>
> During that time, my computer is almost idle.
>
> So it looks like swapoff and iotop are stucked, waiting for some kind of =
a semaphore inside the kernel.
>
> Any idea  to dig further ?
>
> Thanks,
>
> Pierre
>
> Le 30/09/2025 =C3=A0 01:07, Andrew Morton a =C3=A9crit :
>
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
>
> On Sat, 27 Sep 2025 08:07:59 +0000 bugzilla-daemon@kernel.org wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D220605
>
>             Bug ID: 220605
>            Summary: Very slow access on HDD when a swap partition is used
>                     on this HDD on kernel 6.16
>            Product: Memory Management
>            Version: 2.5
>           Hardware: Intel
>                 OS: Linux
>             Status: NEW
>           Severity: high
>           Priority: P3
>          Component: Page Allocator
>           Assignee: akpm@linux-foundation.org
>           Reporter: pierre.juhen@orange.fr
>         Regression: No
>
> Hello everybody,
>
> I have a strange behavior on my system (Fedora 42 up to date =3D> kernel =
6.16.8).
>
> You certainly do.  I wonder what we did to cause this.
>
> I'll cc the MM development list.  Please prefer to report issues over
> email this way - we don't use bugzilla and it's rather annoying that MM
> bugzilla even exists.
>
>
> I have many disks but but my two swap partitions are on 2 HDD, sda and sd=
b,
> which are identical (SEAGATE Barracuda 2To). Swap partition on sda has a =
higher
> priority than the one on sdb.
>
> I don't use zram.
>
> When a swap partion is used, the disk on wich it seats is very slow.
>
> $ sudo hdparm -t /dev/sda
> /dev/sda:
>  Timing buffered disk reads:  24 MB in  3.72 seconds =3D   6.46 MB/sec
>
> $ sudo hdparm -t /dev/sdb
> /dev/sdb:
>  Timing buffered disk reads: 540 MB in  3.16 seconds =3D 170.85 MB/sec
> pierre@pierre:~$
>
> Sometimes, speed gets down to less than 2 MB/s.
>
> Lets turn swap off =3D> swapoff -a
>
> $ sudo hdparm -t /dev/sdb
> /dev/sdb:
>  Timing buffered disk reads: 462 MB in  3.00 seconds =3D 153.75 MB/sec
>
> $ sudo hdparm -t /dev/sda
>
> /dev/sda:
>  Timing buffered disk reads: 474 MB in  3.00 seconds =3D 157.84 MB/sec
> pierre@pierre:~$
>
> Now speed is normal.
>
> Lets put swap on again =3D> sudo swapon -a
>
> Speed is still normal :
>
> $ sudo hdparm -t /dev/sda
> /dev/sda:
>  Timing buffered disk reads: 612 MB in  3.01 seconds =3D 203.56 MB/sec
> $ sudo hdparm -t /dev/sdb
> /dev/sdb:
>  Timing buffered disk reads: 570 MB in  3.00 seconds =3D 189.95 MB/sec
> pierre@pierre:~$
>
> But swap is not used
>
> MiB Mem :  31952,0 total,  27091,7 free,   3057,6 used,   2343,0 buff/cac=
he
> MiB Swap:  36000,0 total,  36000,0 free,      0,0 used.  28894,4 avail Me=
m
>

So the disk is already having a performance regression after swapon,
while there is no memory pressure and SWAP is not used yet?

Are you using swapon on the whole disk / partition or swapon on a file
on top of the disk / partition?

>
> So I suspect that, when the swap is used, there is some sort of lock that=
 slows
> the whole disk that contains the swap partition that is being used.
>
> Logically, the system becomes very slow.

This is really strange if swap is not actually used. I just tested
with HDD locally and didn't find anything wrong about it.

