Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B89D31A13
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3F36B0089; Wed, 14 Jan 2026 02:03:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E906B008C; Wed, 14 Jan 2026 02:03:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73336B0092; Wed, 14 Jan 2026 02:03:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 945386B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:03:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44B12C19D1
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:03:59 +0000 (UTC)
X-FDA: 84329679798.20.F97CDD9
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id C676E1C0004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:03:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nl+KKXJG;
	spf=pass (imf20.hostedemail.com: domain of nroycea@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=nroycea@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768374237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pYxNT3iWLQ0QEUjiEbEpnARlU5xv39cAFrdK070asVw=;
	b=GU1UPXIOFCXdjrBCuK2XTHxGsWoY4FK5di+Sl30W3V0aw1WzjgdrM0mVyjkijes2Rf5YGL
	0Xtg8ly9JbFpr1XlCE2Wco/1AEYT+UbgSEag+YpUt4LRuOD/c8p3XDPM7WBLq/AXO+ECDX
	jNBNp/K93qV1fgcgYTNVkjZYMlmQqCc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nl+KKXJG;
	spf=pass (imf20.hostedemail.com: domain of nroycea@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=nroycea@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768374237; a=rsa-sha256;
	cv=none;
	b=5vDjEEONRvwv3+VjUZEzeBvnI1oZeElkW2LFxPO46tSgDoYi0oCW5F9emFDXqLjFAqfW6l
	IRi7SkVJuWjq1Rm6QZ437hOt7+GVfVnfnf+Mtrgd5oPxpbYAyT8t+2rLptiQ3Aa8MCRB1u
	U50Am9E1bcZc+wjWKg/FAe2qGETremI=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-121bf277922so10076458c88.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768374236; x=1768979036; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pYxNT3iWLQ0QEUjiEbEpnARlU5xv39cAFrdK070asVw=;
        b=nl+KKXJGYtIc6j6qUq7FLfDtqeP3mV+YAsiAr66iYL21uujLmBE0Qhl0D534e2RI5A
         yy/lyzVCif8cpYfBaYRtqLfmpsbgWShws4ZVcglptOrolsg/2Br4vqPGHU33Vy/HDA1c
         wKFboulFaLfmv6+TGOlUKOT8e4Sind9JodRIHwvIWJS0sc3t+F5/f1Ol1q3hJ6fsKA7E
         tUXlL998nQBkZ9woAeDrfbaOBKXYzn0jrYOmtE/QixiANhfrcMpElR6Vha/NyOanzdFf
         mpXIeZCSsgLsjW4Xq2qwWttcXKd+SICK1beBeDGG8bIqe2GZlX1JW0vDU8hQFuoCVPHu
         k4bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768374236; x=1768979036;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pYxNT3iWLQ0QEUjiEbEpnARlU5xv39cAFrdK070asVw=;
        b=lGFUbLN9+FKRrQ+f3nTYpFKHBH65jt+ei0apOAVLE6yMjMvByXaUCpaiy7SX5pf4wy
         4u2R1EOKHOU/MtFMNaTeJ8oOEHKwSpl7sfah+lMQGM3QGQcyodUZZZnHnl07AilxcRG8
         o+OPS+qjhz8PiypLkSg5XCwz2PRNnxbEA8KBhyZ1RLs/xCRFvpsGs8HT5ZGGFyoBFBqo
         +lcCzQAheZueUUDp7olU40A5LNCRLLKaEICP2rkBwtLkbeC/4HxUdhE0pkZeciFGkPgi
         VanmRJdjH7Kd5XhLhhMxFV2e9lMRM+Qql+2CnP8FySFqEZ2MaF+e0c4wk1Eb8HXDloRl
         F5sA==
X-Gm-Message-State: AOJu0YwXC4IN22CJLHno/NzlZwXD+V7M4ByI4Skq4zlU4ZvVKk6DV6lJ
	ois8NfGOLf4rvuhJTXXAnN+qWqAKYjfroi2IASZZYpqkhlKBeP9LMgEmpw0xhlI2NEJB3kYpsqB
	RdZCta+hAZAbS3G7Bj+UzRCjteKZMVe/vpKEKjeA=
X-Gm-Gg: AY/fxX7K0OBdwED2e6PNB16bIou0ic6GrDEUTIHDmYZ1dqt6lucrgOc1uW+OyeMgGSf
	r5cWjZ9XmIDq1zecHmviGW8pMuY/9tHxyywAIwHouZDWtr0/YHRQqLfx36S9U1FNGO4Y+/h+k2i
	99kCvmPerPRPU3HhJeh76sZfpUWUT431zlPTBpAEXOBZ1O1lvRHzMl/ZfAE6B9iRpvuIP607HxA
	YwHI//3rIwCeKnPU50/WtyAzpFQRqdOsALvpbqU8t9vIWfdjF55FyJ/0H8xasrWkDqrZjPp
X-Received: by 2002:a05:7022:e992:b0:11b:65e:f35 with SMTP id
 a92af1059eb24-12336a23120mr1559347c88.7.1768374236405; Tue, 13 Jan 2026
 23:03:56 -0800 (PST)
MIME-Version: 1.0
From: Nathan Royce <nroycea+kernel@gmail.com>
Date: Wed, 14 Jan 2026 01:03:20 -0600
X-Gm-Features: AZwV_QiGfFltaJ2lzVzNuYaKV8ZfX3mpfQ8_pJXXGJFhOW8wo1gl4L1K_rd0_IA
Message-ID: <CALaQ_ho-dx9CTee_-R1VFreX=jB3Zbdjo68fdnnwC1cPoPcjVg@mail.gmail.com>
Subject: TmpFs Incorporation Of FsCrypt?
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>
Content-Type: multipart/alternative; boundary="00000000000030e345064853b66d"
X-Rspamd-Queue-Id: C676E1C0004
X-Stat-Signature: swbtnkenmbrg4o5npknk8z7wickqj3o4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768374237-568816
X-HE-Meta: U2FsdGVkX19RxHa3ZadAcd99n+7mGWLEAkEqqdxyQKfR2BYyh3NvLZFK/Zul3q9O5ZYDSq6ICsXarh0EjBQ19zUp8qIo42J6ZyY6kx2AWB5xRI5HEzGwjYanw/pgWYL7VmXwAfDI90MfwwRhsrLJwuvFM4GLoa687cF332MglJfnCGPi3M+3bCRsK7lW5mZm+VV5GXPchx1XvOsKoqiaw7xTur+2sEBu7Hm0OgFR4XSCSiaNlxTcfBN72948E1NYWSTc0GqV7i4BOhefiNo/Oo+YZXuMsZVMCjW8Ju7I7YmtwQ1NAYvLEMHPadlZLo4M/RcWdArgntDJu++6BiZ4WdVtyG5P5sFZsWA8O/FencUbLxmvZdi/85m96v+SI/78cBFkC3k2jIAVcPScAQX4DNFpCYiC/zY1CQKV2buJ/W3DYlbavmdMbc3kYaraBnXc1NnFedwKXC3l8enM5gcx4SdobX9iDzdoPpoTSef06aIzA4xo/nh2iVhJkmpW+TFH00zur1OcfUhO1VC93gBL1d8Mgc7vsS/idZbdL1DivuY+NKFKVJGIMtLYAa825ijhKNA4gS4y3yVJwVij02YjnxCEq5xLPjwsW8G0aBKWo9CBRxOAXYgFhgl7nf1+AHGQtl5P7VgzjCwqNNl/Rm2D4gMH4cRgtK6kKhokvMbAnLZbUk5gNeZrbQ3oiN/xM7FSiTGQrwlrevDZE6QcKZsn56P9RJtl1tMk7Q3GtXicU9McLGJ6N6BA5XWAhWHVcjoDh6HiH4a8VcRGrUe4SYuau2S6NGJajLfy95BgzanUoZjM+Jl4BEoglSDqyoAFosZ66HGUZGwq87d/S7HGopG+t+cZ9aoLq7oot+/WSVy4/eYsvvYeGox4f2sgnLtmChgOlPjnjbxJDO9kOEYuLNxqXurCtNRKty286RuwfFDyHxiq/7TGh8854YFyxOM/3CdPNRsL7FSOHU3Ntb5b3IV
 EmUOHzn8
 FNQT16HTfbf2e6Ohvog7JydXh9/rziowOUdd6sMT4Qidha6LbnFOAGrzW3sh06wq9X4oKE4y3K2m65iCv2GB51wYNMqxn17P5gU6/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.007489, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000030e345064853b66d
Content-Type: text/plain; charset="UTF-8"

I recently saw the PRs for BTRFS relating to FSCRYPT, and thought I'd
explore the fscrypt package.

I started with `status` before moving to `setup` on the `/tmp` path which
is tmpfs.
As expected I'm sure, I got: `[ERROR] fscrypt setup: filesystem type tmpfs
is not supported for fscrypt setup`

Looking in https://github.com/google/fscrypt, I saw:
https://github.com/google/fscrypt/blob/ea916da7fa9844cc3da608e75510f478c7b09f7d/cli-tests/t_not_supported.sh
which coincides with my presumably expected error.

But I also saw: `The source files are located on an in-memory filesystem
such as tmpfs.` in the main README, which makes me wonder if there is
intent/plan to bring fscrypt to tmpfs.

I'm kind of thinking a use case of having keys and/or a password manager
database on external/encrypted storage, that gets transferred to some
random path in `/run/user/<#>` (tmpfs) on login where it is encrypted as
well (then the storage is unmounted/locked/removed), and the respective
program that uses the file(s) would point to a freshly generated config
that points to the random location.

--00000000000030e345064853b66d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I recently saw the PRs for BTRFS relating to FSCRYPT, and =
thought I&#39;d explore the fscrypt package.<div><br><div>I started with `s=
tatus` before moving to `setup` on the `/tmp` path which is tmpfs.</div><di=
v>As expected I&#39;m sure, I got: `[ERROR] fscrypt setup: filesystem type =
tmpfs is not supported for fscrypt setup`</div><div><br></div><div>Looking =
in=C2=A0<a href=3D"https://github.com/google/fscrypt">https://github.com/go=
ogle/fscrypt</a>, I saw:=C2=A0<a href=3D"https://github.com/google/fscrypt/=
blob/ea916da7fa9844cc3da608e75510f478c7b09f7d/cli-tests/t_not_supported.sh"=
>https://github.com/google/fscrypt/blob/ea916da7fa9844cc3da608e75510f478c7b=
09f7d/cli-tests/t_not_supported.sh</a> which coincides with my presumably e=
xpected error.</div></div><div><br></div><div>But I also saw: `The source f=
iles are located on an in-memory filesystem such as tmpfs.` in the main REA=
DME, which makes me wonder if there is intent/plan to bring fscrypt to tmpf=
s.</div><div><br></div><div>I&#39;m kind of thinking a use case of having k=
eys and/or a password manager database on external/encrypted storage, that =
gets transferred to some random path in `/run/user/&lt;#&gt;` (tmpfs) on lo=
gin where it is encrypted as well (then the storage is unmounted/locked/rem=
oved), and the respective program that uses the file(s) would point to a fr=
eshly generated config that points to the random location.</div></div>

--00000000000030e345064853b66d--

