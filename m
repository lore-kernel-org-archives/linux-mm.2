Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48ECCCFD2EB
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 20:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B74D6B0010; Sat, 22 Nov 2025 15:34:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48F836B0011; Sat, 22 Nov 2025 15:34:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4DB6B0012; Sat, 22 Nov 2025 15:34:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2677A6B0010
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 15:34:00 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADC171A09C9
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 20:33:59 +0000 (UTC)
X-FDA: 84139394598.18.CE70062
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id AE6951C0006
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 20:33:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=knlBzNrY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763843637; a=rsa-sha256;
	cv=none;
	b=GVpSPSSyOApjXA4raPMeVq0Lb6OYP8wwUNao8FMdzK9sWKuao1wxlgpOJc38TfxVEpU/jv
	Bdsvw2DJe34ihxhGkmc3/AzX4g0nIU8QJmha/B/Pl7bf91LMpJ0J9SwRCt4UJVdRf97JW1
	TyIJdhCRBxrWbHliV/2s7MCAldafQcg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=knlBzNrY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763843637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFn2EwqFqpnjkFoKzC+88UIKZbJzPZxsjNZNiF3KFj4=;
	b=OdM+ztoTBL7C8Kbc/rWQxel8cTTBDocFtc6zrL3JUS+YMbauLvpANSpfjT4/U7Zx+Q/GZO
	l2pzsZXj+Je6lHhkz94Qc9MlejBQ793pxZ24xT1W4Ox9xivTbK/gPVxeJnTm1z4npILrEH
	5gOCDVtX9hEDXMDte/1nHtJfwlfSbsc=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-37b9728a353so32507791fa.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 12:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763843636; x=1764448436; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dFn2EwqFqpnjkFoKzC+88UIKZbJzPZxsjNZNiF3KFj4=;
        b=knlBzNrYOz7BFU/NHoEceeeaEO57GeicKROaLynSPHipQG6ahPcryxDXihYpdfcSTW
         6Lv+c4ATqxdbS+he+AvIGcv326seNzp4aOCAx82BD8WyPcuTYoojdWydIraa35bjyMgo
         ZfhrVdeUrvSltDkTlDIDzyRiJ0r7B39ozeMbANhQgNKD0qcRTrZEkWDlyZtTcDG9uDdk
         anQVggdkWBwSrU1GwkWCP0BMIjVr0adoAurgP/gKQZj7oe8zilaSODqbt+Qw3+A7ywJr
         U7qmTEA8Ldeb5PLA3vqvp20kQJueMbv5X5caJeTaeGATCIJ5TsHB7P6oasckc24Ijim7
         hauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763843636; x=1764448436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dFn2EwqFqpnjkFoKzC+88UIKZbJzPZxsjNZNiF3KFj4=;
        b=PflmA8lVkc4qq/0e6PKlKrywJh9syqTmxbeW50ZODl9nOEvPgksYEoJhX4bbpt6cpi
         b/VAG8w1hN9K1NXL6xMmUaS3GO2s5c8gowiVJ44i1mI/rlgC24dwQC0/5cGKtDUcV7bm
         GF9CmeenqE59e73YmvwxGj6otMLRYBYuU1gqFRIqzdUbFPbl0mWfwggPKSSMCbzflTmr
         kAW/QOqp5mw8GvvNBFPDtZ5btDoUPiV3bNbGVodynn60KZ6txuOL6gfWNPb/ZvePD271
         8RXUS43O5dItG7UwI+diKdPSDiqRyc7Em3negD4CtYTIt54B/UDilTt1aXwlspbihUvQ
         d9WA==
X-Forwarded-Encrypted: i=1; AJvYcCXXdMo9zd8qaSCV1ouC4S9KeBPLev/zycC4JHIJ4KwXsUSJhLgYYIo+Rffgqr/O9tcWZgb65jk/Ig==@kvack.org
X-Gm-Message-State: AOJu0YzlGN2hB7CqN8ZtKU33ccSuTkev0ZL2o1Xt9FBToRTqfGGY0t7F
	MsOOF6XHrTKvaou5FpngqP4nw3dDx4pbQ/CxjP7WmrvM02zauTggJxcM
X-Gm-Gg: ASbGncvTuMMNWPprLqBfvNr94kpCFPzCbcy8X0NWIhkAMzKfLqSW4uF4e8Uotiofu6W
	G//NCJSsm1HcAwEU2uvix6zYZkMNjv5AUCVwqu3dcz5n2+a06qIF6CpUPXFVbJdHDYhTR2/q/3r
	ZjAxZN7EU6hBUDPH6Eif30kGK3clWsOUV/+pxro76mbeR8Ey4c2ZUA66M1k2z9Ucoi8GorawGiN
	EziHe8cVGU9eSAlKxKDM2ISIt9reGPcWT04bGyBWTqtts7pmk8j6wuJaPkAAw5Ow9HqZM6jGoMY
	GoZ6MIeZ5rV15RLXZYvf3HOfFGJX3JIScbp40yT1QR289CfOxf3CFfI0De30bWBq1QYvrUL50+1
	oBCYyn8xC6FpVqqVZXrt4LPqvhGWEvgdc6ZW4viS6Aocshx2sC8EzNvQ1hm4qs1pijXNoUJOokm
	E6y6RHQkH2
X-Google-Smtp-Source: AGHT+IFhSsUjwtf7XXEFFhGewe4/WzYwa1EvQXhZvrF755UE0d1dYIej0yvrkJ/oBfshVizcRSlPOQ==
X-Received: by 2002:a05:651c:4416:10b0:37b:aac1:282e with SMTP id 38308e7fff4ca-37cd9287c95mr16773881fa.28.1763843635543;
        Sat, 22 Nov 2025 12:33:55 -0800 (PST)
Received: from localhost ([109.167.240.218])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-37cc6b597b2sm19299711fa.12.2025.11.22.12.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Nov 2025 12:33:55 -0800 (PST)
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
	safinaskar@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] pm-hibernate: flush disk cache when suspending
Date: Sat, 22 Nov 2025 23:33:42 +0300
Message-ID: <20251122203347.3484839-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
References: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AE6951C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: 5uwhroz1mcrot88njpmkcduxdgsg6xk9
X-Rspam-User: 
X-HE-Tag: 1763843637-814455
X-HE-Meta: U2FsdGVkX19rtQEUtcLFDx1dwbQ4BjGGbcIZMnozFjUOBt0KHcqVVq8tsu+mOnOJdXADoFDYDePcdOmUQ5nCRroae1Q5p/740lY7NxfhxRxhNqWNNG6R7Ck0aPc2Vxsym8OxdCCjt6QqJ8g4o8Q5KAba9ky+iBQzX+tcIbUb8DD2o/le12XJUwe9b6LxLX6FFEgLTux3VfyfxyNgr/5JHMRYIRPCG1TCJp40l1B0Oy/rzkamhREgYbVOGeyq89MFhn/EKwRbBU6/1Pexbsg/n1dksSmvGYMB7gQPKlq8dBUH+JdDChXKnhLyHVALaYxViCOhPhnO+7qxU9kiURIMCb693BwkWFPKy8r2FKulLdkC+ap1cpcR2UmevUBnpgtBAbnomLOWx5uVlYmIVFZWI6fDue+zgkSjbblrajS8DT5yzk/vXfijRckC5k03rYU/y7pU5i/W60GIxc93klDciBYplvlsNCKDHVOW8AqDQ25rtg1xValHm7yP9nlJlBMRTWjtbbFuT4NLGuXjDg42Uf+k7JM+pscExdS/3RI7IumeIywE1jO9/dsdK4nh4mtoTgsg2YpGdXQHA8Twb+fxMzz11Oxg1irZlofVIXHZqOh8+3Erqm1w1A9HSF3w8mjhCWSvBx5Prpnsi8O+lorX6fg3nHU2hvDN6UO+E89gEnRWXSU7ZQRilwUtuSABsyHv2t9O9BF7FwEN5YZR0BzgM76DkgG16iVhcwf/g1TGTYi0PodZZSzpe0IVMsUINXUVEy56+rUS4nKQQ07SpNZVGukyEXd04JBLJ5i++3lrcqY2hV79BbllXouPg3WM7rwwb6SRyjkmNKFOpgihwK6BpiDHqk0xVLn8Wg6mcM5ZpOEbQ/22KqGUetoO0B78naV1RsXzdBRNdUa7EdnsZwM+BH71Sdj2PP2x5741Ka9wogqATNZLf4FPfQ44txNN+46aC0ccm1ACUhsUPB740RF
 M4qtEBns
 pdtIcXREUr+Yw62saK2iTtMZMSayGx6WJ838+3FG6fcCISJp1bYrqnLSq0QqgFNlpIqaLRCHGD7vnYMyT3J6VhXI1n3IjNPRBO4zOBvjuyR+qQwybhu48w9zaHX9FE7rI0VgGKUuuMJx350/E1a3OV8DSCehCHtw+H53hzc2/fx8n3QRNyhJMqYk+BiOgkptp4+x5dXWfl8lvC8I/q2j0MKhXBO5hO7xCgpakt3pp8HDEdgoRGSsHW+vBx8/FQmpQxemtGMNfpqCqkP4VgPCMne2x2mTQWNaDyLhCcwfDfiLy9iGPmINP8E/oGFC2CsEACLxnEZ/ZLtf14R7Q7BDxqtTW2MaCQr8BQ+MuiYufNQaPTI+DscHeJCW7OcG51BnH4NN7k2/l73bbFCaPeqJAJkhMLmJnS20aE1UcOyFW3szWPgCyuTOULVuur2XHM3FyMTVOXVrb5KurL3BNLVBW0o4dvdqll7gnSyHs9bvz+pungWFM9vx6RQnSQXa5fD5kKBCJCeWCKz4UT5Q1ml0GlO5pex5oddtPrrzEKq+SYk6TJ0lPfmmCjbS7hB0V/mWox26y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mikulas Patocka <mpatocka@redhat.com>:
> [PATCH 1/2] pm-hibernate: flush disk cache when suspending
> 
> There was reported failure that suspend doesn't work with dm-integrity.
> The reason for the failure is that the suspend code doesn't issue the
> FLUSH bio - the data still sits in the dm-integrity cache and they are
> lost when poweroff happens.

Your patchset is impossible to apply using "b4 shazam".

Here is what I get when I try to apply it using "b4 shazam":


d-user@comp:/tmp$ git clone --depth=1 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
Cloning into 'linux'...
remote: Enumerating objects: 96577, done.
remote: Counting objects: 100% (96577/96577), done.
remote: Compressing objects: 100% (93936/93936), done.
remote: Total 96577 (delta 7530), reused 20945 (delta 1607), pack-reused 0 (from 0)
Receiving objects: 100% (96577/96577), 267.21 MiB | 1.85 MiB/s, done.
Resolving deltas: 100% (7530/7530), done.
Updating files: 100% (91166/91166), done.
d-user@comp:/tmp$ cd linux
d-user@comp:/tmp/linux$ b4 shazam 'c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com'
Grabbing thread from lore.kernel.org/all/c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com/t.mbox.gz
Checking for newer revisions
Grabbing search results from lore.kernel.org
Analyzing 15 messages in the thread
WARNING: duplicate messages found at index 1
   Subject 1: pm-hibernate: flush block device cache when hibernating
   Subject 2: pm-hibernate: flush disk cache when suspending
  2 is not a reply... assume additional patch
WARNING: duplicate messages found at index 2
   Subject 1: swsusp: make it possible to hibernate to device mapper devices
   Subject 2: pm-hibernate: flush disk cache when suspending
  2 is not a reply... assume additional patch
Checking attestation on all messages, may take a moment...
---
  ✓ [PATCH] pm-hibernate: flush block device cache when hibernating
    ✓ Signed: DKIM/redhat.com
  ✓ [PATCH RFC 2/2] swsusp: make it possible to hibernate to device mapper devices
    ✓ Signed: DKIM/redhat.com
  ✓ [PATCH 1/2] pm-hibernate: flush disk cache when suspending
    ✓ Signed: DKIM/redhat.com
  ERROR: missing [4/3]!
---
Total patches: 3
---
WARNING: Thread incomplete!
Applying: pm-hibernate: flush block device cache when hibernating
Applying: swsusp: make it possible to hibernate to device mapper devices
Patch failed at 0002 swsusp: make it possible to hibernate to device mapper devices
error: patch failed: kernel/power/swap.c:1591
error: kernel/power/swap.c: patch does not apply
hint: Use 'git am --show-current-patch=diff' to see the failed patch
hint: When you have resolved this problem, run "git am --continue".
hint: If you prefer to skip this patch, run "git am --skip" instead.
hint: To restore the original branch and stop patching, run "git am --abort".
hint: Disable this message with "git config advice.mergeConflict false"


It seems you should send patches not as a reply.

But I will apply your patches anyway, no need to resubmit.

-- 
Askar Safin

