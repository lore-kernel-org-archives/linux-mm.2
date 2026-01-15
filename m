Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1410AD3CCAF
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 07:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F60B6B0089; Thu, 15 Jan 2026 02:05:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A3906B008A; Thu, 15 Jan 2026 02:05:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2F36B008C; Thu, 15 Jan 2026 02:05:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 274DC6B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:05:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB6DC1AEDE
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:05:27 +0000 (UTC)
X-FDA: 84333312294.29.53481A9
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 071B84000D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:05:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GEfZ9CbA;
	spf=pass (imf27.hostedemail.com: domain of nroycea@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=nroycea@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768460726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6XeJk03NKqEGuzv8RHPFMvVNUV/WQsjqJDUEYuNTlU=;
	b=x18YV9A1jCQ073uNm+43/AKe5EojXvcglV7/Nr2Z57FKFh5hPlpBYyYP/9d75kYKvrqPVn
	Jwsam1c8rBLxr3JZIdyo8L6DM0J4gJIC7Xosemt4iwGOJbo2FJKYnEXIUcBqmiiZedg5b2
	vZHYeSlROTXkVjhzbrtWB2eWs+mpUYE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768460726; a=rsa-sha256;
	cv=none;
	b=Z9+AcPAulKmUu+fJFXwAkrgShifiLQUyQ3GXwVA5cs4PcFqsrB/PX3V+L7H2DHQaA2H8Hf
	y2Orr22SkymrgtefeMzk/YfvMlU6re8qqXHmonq3E+XELsKTKAFKGIZJQLvBhd3p4s8IH6
	4XCbJRtb9tN7Fx9ANNPyGXcfJiUG9Yk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GEfZ9CbA;
	spf=pass (imf27.hostedemail.com: domain of nroycea@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=nroycea@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1233bc1117fso517452c88.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768460725; x=1769065525; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m6XeJk03NKqEGuzv8RHPFMvVNUV/WQsjqJDUEYuNTlU=;
        b=GEfZ9CbAmKidyYnh1Eh/QPL0G6eqrHX/aZPVpnMAGYO1A+aemxzmBf18WLHhCdTwWe
         aE7s+c4bl/DxeLDQzsk2B31X/X1FDGc6wOSdpmZf6r3CiYO3vPEhOZH6/XSCd3YkwG/I
         IgXPNs/zEHe5Ei0gDvrTX6vY/Rl2ImP4negEtCvNKUT1k8177p6R7LQAlt5cw9+B5/7G
         MKUWmReg+5bOqyaBHTbVkH6gClcwxWWtWh8+7alfDfJYYu4vf5oqvP8Dq6SGypm48pvm
         zK8JpqOyN8yDnYuXHWeqlUyjM91V0t15k1YPkJWn2lHFm/3KHh+OuNIy4+yu4uvEssMx
         h+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768460725; x=1769065525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m6XeJk03NKqEGuzv8RHPFMvVNUV/WQsjqJDUEYuNTlU=;
        b=SgZrIfJMSvoK9gJqwAgSyzcpqgE3g59ePDEPQqcpbr5Pn7twPlw4lST7K7yh2EgRn5
         Uz2DPyNhS1sehYBSMW2Z9BVdIe/p126735Ww6ukS2XH04ltJcBIHVb1o3OdBUFyIyaPg
         BnqTqw4k2eKec77ttNVRd/CP9UUeg49E27iQ52n4Isl0LXe7tvvaWgRRpPB7sGKCZ3GZ
         DsHDck1jVogYGDp/nc6UTN0xe4eAXx7DpAVTFhBgnTfl3T2K6QX66g0q2P1EZrlnLT3S
         Zifj9ryrCrPPv2f2aWinG3vHfcqg6XNd3SghuYCOZHCyNFm3/MGQzFvo238J6iKXuV/U
         ETRw==
X-Forwarded-Encrypted: i=1; AJvYcCVlMMkKU5YBf0cPEzdiZ69n0A1qn7kYOm4spMBYenboGCyWNMmFRdVUzN2RKkDcYRDH1ZWbiGdvYw==@kvack.org
X-Gm-Message-State: AOJu0Yy1ZmHQVoGKty30GmY0gWtvKYNBbK1jCNZ7FexsrviGsUCRboZz
	tFmn2NlGDbvP8ITTBKZhfPoDnFe+60BuLFSy1Q2G9Yts/fnJbytuQUINtaNma9Ex7M/OJXlznOg
	Kp2D9AA3cnSvveQvz1qDt6sCg9Ussl+Y=
X-Gm-Gg: AY/fxX4JJOwHy4qK2jGvYu/JcFhhReGRP0h3hCCQQ+FyrMgaMio5GjpchLtbV8peSwm
	S/aJugwPwMNW/Y7On7HY2L9vSesJUdc0wftwEyrF8v++cVoGqPQDcg50+3xx2NpGuxgdJ4ulne1
	6TqHKgRjdsmItDDLqjdi9m4RAzEksSsV25bzLc3Gq+B9raJK3pXUgBgsG6kJ3OCdv9v4EqEAObn
	quVFUGVPpdIwM9Wg7Awc9B8kcMAzab0WvNfsgtFMEe3z/Tw1hZZeJykBMUcv+uFfLdg1dWp
X-Received: by 2002:a05:7022:e80c:b0:11b:ca88:c4f1 with SMTP id
 a92af1059eb24-1233d065dd5mr2636495c88.20.1768460724476; Wed, 14 Jan 2026
 23:05:24 -0800 (PST)
MIME-Version: 1.0
References: <CALaQ_ho-dx9CTee_-R1VFreX=jB3Zbdjo68fdnnwC1cPoPcjVg@mail.gmail.com>
 <20260114204352.GA19200@macsyma.local> <CALaQ_hq==FY64FcLedWnpgOXf_aT9g2eNyM6BgWwvTv8r0FR7w@mail.gmail.com>
 <20260115025920.GB19200@macsyma.local>
In-Reply-To: <20260115025920.GB19200@macsyma.local>
From: Nathan Royce <nroycea+kernel@gmail.com>
Date: Thu, 15 Jan 2026 01:04:48 -0600
X-Gm-Features: AZwV_Qi0oVu_BygaWJ3FI2EzDCBeS2pGJ3Tr4kNuLbzKkek0BrL7Ryr0bgwf1eQ
Message-ID: <CALaQ_hpNLkWBxKbFdCKyE88OZvydFN1Wg7-sbr-yZ3vK3Anazg@mail.gmail.com>
Subject: Re: TmpFs Incorporation Of FsCrypt?
To: Theodore Tso <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 071B84000D
X-Rspam-User: 
X-Stat-Signature: ns9oja85cjr9pyownx5at1sc776i5xqr
X-HE-Tag: 1768460725-527101
X-HE-Meta: U2FsdGVkX1+0NzSn3jhYurHjB3HZbDeO6c6hR/0n+IhvwUGxVbgX12nwxalxQ5bnse+aTkQK+tDaFZeZvGWe1WM2ZFchRS1yTvWJGl8MY1CcpzpEiv9bkgZ6C4rASxhYSs5l4B1uiClMQHTmXZEzbF31mmUgMRl3uXHQ0HCwrT9pppIauN5xfQtk+Fa+qD14UsTC+0MZEz/jzmD8fvyjm5ZD80OVz0p1+xSlYMiyHXqJHlSdqjJ+06tX6k6OP3XoK7giNbyI9We+6dkTrlZr5tqpEONOww441l2qWhRFTcBtacIeB19Y8VA/jNAf/+d5MWXccrSKVtxj9b7oqXYwURkEGIjMrOJVwMxMyIts4bJQceUB9kUVLZ1xHW8HSjOlHFMI9xTug2/ZHMoNqvaFKk+ltumG8GHcHh41k8idrgHWEIt/07X83OJxfhxL0zwTFruZhjx3014llHAEZ85AzhmLFyJnluxeJGlkpH+QO/GderW4x8m86JDdLJm95I18IaFbgNUJuwVYjSXo609gYXeVcmWUpWO8RPK65BrSsQ7GpezkpM5dmJg/8vXpV3ofA0/4/9IJccYdyUZXqU0xc7f61t0yG8zSbn176db5meN2Y8nbSLQpEY+BSp26AqTJyQYeqwC6AUHnuZ/223ayOprVPd6wtQemyXTCuo6v8hkvjt3GEpbQGZ4leCl5eWDpNS3pSX4L90h71O4lfFix77RL+yhy65IQJP6QXnvqIbHyNQDYJW9Z1e+1LvnvbPhnPb1ec4zDRLrBjVOyvI83UuKDCGe++1eAlT2JK310SxkAfkCjP1iqXHb/7Iv7NfbSdhjPWFC1BsKbGaACdu5rC7QblsxheJ0bQOsUiwnxp359wJIu29l9ciBEyd34ir4STLYv5Cm2reHDkXSHXRG4EvdlMwPNG09KQFuN/W596A5NkRsXepeGYpUjE6RVpn0sE4yEyf4BEqtWvpZo6TY
 zhkyVMat
 hZbDf3B5XR2qgtTXCyCjVMzoDqbgHsH/+uM2R6y+b+Y64EzDFrT3ZvA41dAU6NQy1syIcvZQz9CcXdw6SULcbBIjolbWy8Y+9VVjGibG2+8Wx8amvE6Ifr4BQaz9+EIGUSVrs5EASfaaH+PD5la7DCqei+OtAVs/yDJYMMG8hwZYq+bqtsWqRo71I7paP2AwnVrTthL8h6SJRJSjMuRDF5QVcFexG8kMBd4MLS0lty/YafT29DMeBoHtKVlkDW1f+vZ1W8qcG7s4Vl1mweBZIWmpmoslPD8IwsjslnFBCkf2EoF+1bNInr0AlD0nCM7Ef3+N7yjdw1DhaLj9DpSIauok+4Rfb9zItKPAoh8fICdhObrApw/nuSq2Cwtdsj4O/GSvPwYdYPbhyggVUj2jWuQuRvqEY2NsxMqPrYm6Rzef3JaSSs6rWMIYi+3qnk9hERxSjSrJ3KooQ43A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 8:59=E2=80=AFPM Theodore Tso <tytso@mit.edu> wrote:
> Actually, no it doesn't work that way.  Access to the fscrypt key is
> on based on the keyring, which is session based.  However, that key is
> used to derive the per-file encryption key.  Once that key is
> available, it's stashed in the in-memory inode structure --- and if
> the file's unix permissions is world-readable, anyone will have access
> to the file.
>
> When the user logs out and the key is removed, we will iterate over
> zap all of the encrypted inodes and dentries; see do_remove_key() and
> try_to_lock_encrypted_keys() in fs/crypto/keyring.c.  So if you have a
> ChromeOS device which is shared across multiple users in a family,
> when Alice logs out of the ChromeOS laptop, and her brother Bob logs
> into the laptop, this is the mechanism that prevents Bob from being
> able to access Alice's files, even if Bob has a zero-day exploit,
> given that Alice's master key is only available when Alice has
> presented her password to the system, Bob won't be able to read's
> Alice's secret dairy.
>
> The main advantage of fscrypt and LUKS is that we can have separate
> master keys for Alice and Bob, as opposed to having a single for the
> entire dmcrypt device, as in the case for LUKS.  The other advantage
> of fscrypt is that Alice and Bob can share the free space --- and
> indeed, if Bob is logged into a ChromeOS device, and the free space is
> almost exhausted (since if you have a very low-cost ChromeOS device
> with only 32GB of flash, we can still reasonably share this device
> across multiple users, since most of the user's data is stored in the
> Cloud), what a root process can do is to find other users' Chrome
> cache directories (e.g., such as Alice), and while the root process
> which is managing ChromeOS's storage space, won't have access to
> Alice's file contents, what the space management daemon *can* do is
> delete the oldest files from directory that happens to be Alice's
> cache directory, thus making space for Bob to cache more files in his
> home directory.  Of course, then when Bob logs out, his cache files
> might be subject for deletion when Alice starts using the machine,
> even though Alice and Bob won't have access to their siblings' file
> data.

Ugh, okay. Thanks for that insight...
This is the flip-flopping that I'm talking about for myself, because
if it worked the way I was hoping, that was the real draw for me.
I just figured the inode structure might/could also be session-based,
or a mix of global/session.
I was surprised when you mentioned the ability to reclaim space from
encrypted cache, and went to look into it, and came across
https://www.chromium.org/chromium-os/chromiumos-design-docs/protecting-cach=
ed-user-data/
(even though it's ecryptfs).
It makes sense, and is a valid good reason for keeping fscrypt into
consideration over doing something like `homed` luks/btrfs loopback
file.
Thanks again for setting me straight with my misconception.

