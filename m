Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AE0ECCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906A88E0012; Thu, 23 Oct 2025 07:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88F0A8E0015; Thu, 23 Oct 2025 07:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72F988E000D; Thu, 23 Oct 2025 07:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A45C8E0014
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:29:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 02F34160B03
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:29:27 +0000 (UTC)
X-FDA: 84029158416.19.7E4CE5E
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3070F180006
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:29:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kjwYAecU;
	spf=pass (imf16.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761218966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GOi8L/T/sc914HyVaQllPfco9t+JbsWkC8LrVlAzwL4=;
	b=nH0Al7XvlpFfN2tCuW5XN6bsRDQN4ssnoVOcM8uimX/cMumPTqakDBHR46vawoELeEA5tB
	V3gMMloQiekfmkOI3oGY3RNnEoTS9XSX4A4CJ0X3XCt+s74oJsfOhtcBD1ks1VwQaJICDI
	/jgWUihjMuBfV7rqdZQhcbnaSqgX6cc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kjwYAecU;
	spf=pass (imf16.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761218966; a=rsa-sha256;
	cv=none;
	b=4BjodfmTLrSkneZ1g6nRw/nKP1/tEv0eLZpMTY/LE6xmNodz4SzwaRo1yDIUU6SfkL1hH3
	Nd1Ka5IZOMecXrW9aoqeU21CxDLS3X7o3ESu5olzTPI8/aNjjkpDeR1xO2/9Z6LWTv+GTQ
	loZ4hiUUzn3fgXcFub9VN4e8wKhHsHU=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b6d5c59f2b6so54699366b.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 04:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761218964; x=1761823764; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GOi8L/T/sc914HyVaQllPfco9t+JbsWkC8LrVlAzwL4=;
        b=kjwYAecUQcmN6elcmYOPK6AFbXDSn0Osn4nK94DHzA8amCX+7Z412zvdrhA724OLFA
         EaS9p84WpQPx8F+y+/nPNXNpRhCjyIoCm47w/EOJ2Ib0GI0D5CYEIQ9SbJ04TYOhtKfM
         lY5OU7PquTwYFO5IxqdYNmHQtxxM69cKV9Ntr8bA1YPOK0xeeJduBun/0IaIVZOUTOXf
         iWmUFz4ICYslSynJP0Iqp2vy6AOkj8j9xF+YIQTKGShC87ki437SLjTtM/pO8yXiX3ra
         Dfyz/c7x9qvTQ9MZMq+24GuF2Bd2ng9I1/yx8lcpnNoLOkSeuwsHWSg5otQlrsIdFCgz
         yXmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761218964; x=1761823764;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GOi8L/T/sc914HyVaQllPfco9t+JbsWkC8LrVlAzwL4=;
        b=RJsHq68wc4Wtow5YQoGpjL4XZgjUv4KUf9mLtat/fU9DFL8G+4GlerWLr3GfGtel9w
         tsx3Nk0LLWAm0uL+LyIBNwhyOMryYEFsotqRpTJO+2A0pPcugGo2UeN1ATtRm4r5XVis
         peHSlAX7LKRpC6GZcP/nCYYsOyWrvLkTuSl8m4tiWE723y3qnLOVMQPQrA2mmbhMCbtY
         NUyPNofg5vsAv5m8KyCVaXbZJmusdOoXuEDwI08/L4nf91Bdnd7pInRnvDmkviIEyezp
         JzfO7nC7cZUc5caqOw9JzoLznOO3uMw6c6bczTIf2DuJIwrWaSyUOHHenuzO2nqfeZob
         Fkdw==
X-Gm-Message-State: AOJu0YxpS5rgBdMv9wdxDMcJw62WJ2mOjSuKnVbR90gGTFq2DXN/4olG
	E6D3iNJDVixkEITUUNJiyWIVmurH0ZghWGiZXmeSBX6k60r08yNWUXsuubFrCsEB
X-Gm-Gg: ASbGncsmi7UsjaAQifl4KDEK1PEoZ3jnWFDrj7CzFGkeQAYC0MpqD3nugFAA2eWtC5k
	ci40xLzROyKLdxmx283AIBeyMBn9ASVtvEvHoEn1zNMzGbFnUXWy1eb0C5TcNxcL9fVk2hAoxJt
	bO3OyKY0a6LNiWtb8+7+QzdjrzPh8T1Qc/f849gUFhzi0Pof5mApllRv/QTPyU3+6rila0/bX66
	4Ni2rCp6Uaah3iYcwOs0bvUjsjeWCwygx9RWK3Oj+xqoej+r2eUveza+oHeDsPtpmmyAdIYZnhZ
	Fj5fjbmoOgzy8BuuN/kWYpanrIVIPEORPCAwlhWo6MmCatoUBtOg+j4MgDdVy5cD8b7fxGiX6P+
	F82HjsLcdzrQo4Jw7f4yJXvqmWIyhzrn3ph3MJ8jlQ7rOCthp7akm8ln05rPre9CnPdpxReduXF
	3W
X-Google-Smtp-Source: AGHT+IGVcD+OUFGiPRHpX8Zf9AyspMjR70F5rNVEqM4+m7vN8XE7B3HIHBPjz9kYyXDPcdhsgkufaQ==
X-Received: by 2002:a17:907:1b06:b0:b6d:2f3f:3f98 with SMTP id a640c23a62f3a-b6d2f3f4014mr685674566b.41.1761218963986;
        Thu, 23 Oct 2025 04:29:23 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b6d51471ef6sm182393366b.72.2025.10.23.04.29.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 04:29:23 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	lvm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	"DellClientKernel" <Dell.Client.Kernel@dell.com>,
	dm-devel@lists.linux.dev,
	linux-btrfs@vger.kernel.org
Cc: Nhat Pham <nphamcs@gmail.com>,
	Kairui Song <ryncsn@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	=?UTF-8?q?Rodolfo=20Garc=C3=ADa=20Pe=C3=B1as=20=28kix=29?= <kix@kix.es>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"Lennart Poettering" <mzxreary@0pointer.de>,
	Christian Brauner <brauner@kernel.org>,
	"Linus Torvalds" <torvalds@linux-foundation.org>
Subject: dm bug: hibernate to swap located on dm-integrity doesn't work (how to get data redundancy for swap?)
Date: Thu, 23 Oct 2025 14:29:13 +0300
Message-ID: <20251023112920.133897-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3070F180006
X-Stat-Signature: uiyxk7b9jiqa8qj7tbffoer3emmox1mw
X-Rspam-User: 
X-HE-Tag: 1761218965-623395
X-HE-Meta: U2FsdGVkX18QBaIaJl3WDGTcN0ti3i8cQwhn6CUVZhEJ7bUFvuQLgwY+j9wUnARfe/W82oNdXsMgVho4MDM1tEdZBVHGmnDPD/snybVd6xaMkBQWE3YKYsc93RAnJlmWNH4iW0x99wEYbuTzRJuEBdTSPTor0qYLgsKXT6/4XeWnR3rWZQXnHYqArDAvoliDdcsbu9RoTScDLU9VivAG/bMyBNw1801SoG9FLz1fcGFC3+q2qJdX7nq44oFMUmI5ZvaqmeQlTLhCY8KjHZf583L8Ln15I9ysa0qUb7za2dM9FXRQr+D0NmmF6+ilINfdsm/rmnkB4p3f9IenbaCXOyPJ6vYqw7j7RTzIi4NnmqsGAlNXMf0PV76ASbCyWACNNidJNKhjb3bm8vOAp3FphFfSL1cyDNryQsWx/5BuKPUImtMkvDOAk01Wxumt7QVixp+zYs5M2h4YydYYrMktnNJlC2yjMFgQEXIG1LN9iVf+/FiRJdmrkN29LF6eP29Ee23k16dw9LeiNcGWHjtLMXg55cBNLdtJiU8kpI0pXTYkOsmvHTlc7M40g5BotNrHybKJFGo3QiWBwLB2v4CBuzR8O/g5iWg/HJhSQVdsDTiX3QIxwals31GE8lIR8uY2U2pNC/e1tq0UNNER1uDyK76DUMqP6A6v0aFoY9iULfdbwRIwIOX1oWTc/FCdeEApB+Ib/7ZD8x7vrcAiB8QndiDawwwMvfu4Zz/BwmN9/2MHATG1fVH+EgOMgU8NMs7Cr1r4xTn/Cmy5fO81+bGuHZ7Qwnm9jPi0vxLMKg+wGjClmE4acdwLLeMG3TdL8epCOKCMbOHJtzBWG6cKC4eHVvM6lwVbz8fEgNVYeESjIhFXv7XKVH6pMJV+BddPzveazwlHgCDI63lWORxrls+y28ej2EmxDMwlFNItUx6L43mdzPNC2SKptjboNdGBHBpi0JTZr40sdLGVYqp/388
 Z3gjhv5+
 YzDryBeaKSD/nSaFPjqo0PNchv++dLxA1lZJOpXUDpMBNGq/hD59tHJP+gMnf+OpAYbApjzsHKT0v5ACV/2mbSbe5QdjR/MzOQrg0hoxs8SoHrVGGRfaoBc5CevRom6uAeOK8+jLY+4NpzS6BRWqVvjTVtlRdI8T44yLJnagH1vJ/9t79y9oq9MBRyUk6VrNMUaRkyeSLYO33Eq5QdV4G2Du10fOHX7BdAwszFekKmmsbREuz3x1Gbb+y2NYahVOEggfBTVGa6u0o7fQZuiEOg4/bsj8U1KRt1RU534H1AUyA6FMLx0d6pZ28zsU7T7sfLC1kaYE6gEdNRMCDoOS2FVTNG5EvKxvVFb7xgoTb3Jn61fxPUnp0FToK7u/G1ZXoO0ha8ElmoLw9JvPJzAg7P12aUPju7VfYURgFD0lXgXjjhPr+EUAcYKOLWQDMSPALJ4QbGQ4O6XP1HW27JYnCy2k2rMpl3mgjudJbIOqmsnULT99HPKH+5twUA9BRUrqyWM1meRYW8MIGzd8bCj6O6A2JYmo900Vw5GcN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi.

Hibernate to swap located on dm-integrity doesn't work.
Let me first describe why I need this, then I will describe a bug with steps to reproduce
(and some speculation on cause of the bug).

I want a personal Linux laptop fully protected from data corruption (cosmic rays, etc).
And even if data corruption does happen, I want reliable indication of that,
so that I know that I need to restore from backups and replace faulty hardware.

So I did this:
- I bought a laptop with ECC memory: Dell Precision 7780. It seems to be one of
the few laptop models in the world with ECC memory. And probably the only model
in the world, which DOES HAVE ECC memory, but DOES NOT HAVE nvidia card
- I set up btrfs raid-1

So far, so good. I'm protected from both memory errors and disk errors.

But my swap partition stays unprotected. And yes, I need swap. I have 64 GiB of RAM,
but this still is not enough for zillions of Chromium tabs and vscode windows.

And, according to btrfs docs, if I put swapfile to btrfs, it will be exempt from raid-1 guarantees.

It seems that the only solution in this case is to put swap partition on top of dm-integrity.

Note: I don't need error correcting code for my swap. I don't need a self-healing swap.
The only thing I need is reliable error detection.

There is discussion on Stack Exchange on exactly the same problem:
https://unix.stackexchange.com/questions/269098/silent-disk-errors-and-reliability-of-linux-swap .
I think it reached the same conclusion: the only solution is dm-integrity.

Also, as well as I understand, md raid is not a solution: when reading, it reads
from one disk only, and thus doesn't detect all errors. It can detect remaining errors
during scrub, which is too late (wrong data may be already consumed by some app).

Also: I don't need encryption.

(Also: there is other solution: "cryptsetup --integrity", but it uses dm-integrity anyway. We will
get to it.)

Okay, so I put swap partition to dm-integrity, and it worked!

But then hibernation stopped to work.

And here come steps to reproduce.

Okay, so I have Dell Precision 7780. I bought it year ago, so I don't
think my hardware is faulty. Also, I recently updated BIOS.

My OS is Debian Trixie amd64. My kernel is Linux 6.12.48-1 from Debian.
I created swap partition so:

integritysetup format --integrity xxhash64 /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7
integritysetup open --integrity xxhash64 /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7 swap
mkswap /dev/mapper/swap
swapon /dev/mapper/swap

When I need to activate swap, I do this:

integritysetup open --integrity xxhash64 /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7 swap
swapon /dev/mapper/swap

When I need to hibernate, I do "systemctl hibernate".

And hibernate appears to work.

Then, when I need to resume, I boot to my hand-crafted initramfs.
That initramfs does this (I slightly simplified this script):

==
busybox mount -t proc proc /proc
busybox mount -t devtmpfs devtmpfs /dev
busybox mount -t sysfs sysfs /sys
modprobe nvme
modprobe dm-integrity
modprobe xxhash64
sleep 1
integritysetup open --integrity xxhash64 "$LOWER_SWAP_DEV" early-swap
sleep 1
# The following "blkid" command should detect what is present on /dev/mapper/early-swap
TYPE="$(blkid --match-tag TYPE --output value /dev/mapper/early-swap)"
if [ "$TYPE" = 'swsuspend' ]; then
  echo "got hibernation image, trying to resume"
  echo /dev/mapper/early-swap > /sys/power/resume
elif [ "$TYPE" = 'swap' ]; then
  echo 'got normal swap without hibernation image'
  integritysetup close early-swap
  # proceed with fresh boot here
fi
==

And this doesn't work. Hibernate works, resume doesn't. :)
"blkid" reports swap as "swap" as opposed to "swsuspend".

I suspect this is because hibernation doesn't flush dm-integrity journal.

Also I tried to add "--integrity-bitmap-mode" to "format" and "open".
Resume started to work, but when I try to shutdown resumed system,
I get errors about corrupted dm-integrity partition. (Of course, I
did necessary edits to initramfs script above.)

Also I tried to add "--integrity-no-journal" to "format" and "open".
It didn't work, either. (I don't remember what exactly didn't work.
I can do this experiment again, if needed.)

Then I tried to do "cryptsetup" instead of "integritysetup". I created
swap partition so:

cryptsetup luksFormat --type luks2 /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7 /tmp/key
cryptsetup open --type luks2 --key-file /tmp/key /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7 swap
mkswap /dev/mapper/swap
swapon /dev/mapper/swap

And, of course, I did all necessary edits to initramfs.

And this time everything worked. This proves that I didn't do any mistakes in my setup
(i. e. I got initramfs right, etc), and this is actual bug in dm-integrity.

Unfortunately, LUKS created such way doesn't have any redundancy. So this is not solution for me.

So I did this:
cryptsetup luksFormat --type luks2 --integrity hmac-sha256 /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7 /tmp/key
cryptsetup open --type luks2 --key-file /tmp/key /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7 swap
mkswap /dev/mapper/swap
swapon /dev/mapper/swap

And this time everything stopped to work, again. I don't remember what exactly went wrong.
As well as I remember, that "blkid" again returned "swap" instead of "swsuspend".
I can run experiment again, if needed.

The commands above use dm-integrity internally. So we clearly see: if dm-integrity is involved, then hibernation
doesn't work.

Here is a user with exactly same problem:
https://www.reddit.com/r/archlinux/comments/atg18t/hibernation_wipes_swap_and_my_system_hangs_on_boot/ .
I. e. "hibernation doesn't work if swap is on LUKS with integrity protection".

So, please, fix this bug. Or say me how to solve my original problem (i. e. achieving full reliable error
reporting). I'm available for testing. Send me experimental patches. I can provide more info, if needed.

There is yet another potential solution: uswsusp ( https://docs.kernel.org/power/userland-swsusp.html ).
In short, this is hibernation driven from userspace. I. e. uswsusp allows for finer control of hibernation.
Thus, I can write my own userspace util, which will do hibernation, and execute "integritysetup close"
after writing image. Assuming that original problem is what I think (i. e. lack of journal flush after writing of image),
this may work. The problem is... latest commit to userspace implementation is dated 2012-09-15
( https://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-utils.git/ ). Do I really need to use such ancient
technology? I didn't test this yet, I will test it in coming days. Even if it works, this will still mean that dm-integrity
is buggy with kernel-based hibernation.

-- 
Askar Safin

