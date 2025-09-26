Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70573CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 19:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88CC98E0006; Fri, 26 Sep 2025 15:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D5A8E0001; Fri, 26 Sep 2025 15:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C8C8E0006; Fri, 26 Sep 2025 15:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4908E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:51:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13B751DFF01
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:51:07 +0000 (UTC)
X-FDA: 83932444974.25.AF657CF
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1E48440003
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:51:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kUSfTGKn;
	spf=pass (imf01.hostedemail.com: domain of chenglongtang@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=chenglongtang@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758916265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ip017FMnVxrXIHAt9kopjLMyNWF+o8u1hHFJYtAWs5k=;
	b=pqYI5FIQxY2peijVEq59nnzNZhu6xtctagB3ltvrnBJLO9UPvN1rpms88wMbGtaOYJbyGg
	L1O8bmpPqdMoj2IzOXDBKRJ81mnlUoU+rZ6nFHXhzDCOrZZQvWBBSQFAmrqIBwYHgViMXn
	zF3NwRyJW0eYF3f6g6w3PqdvzS+Au8w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kUSfTGKn;
	spf=pass (imf01.hostedemail.com: domain of chenglongtang@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=chenglongtang@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758916265; a=rsa-sha256;
	cv=none;
	b=frHZxt94EPN9C5japieASmzD68WOycl37pfm5noFSKbE58ghgoePy96uuCb329Y4XprufD
	iFuAMxm4znqTAqUTwRwd2bCco1Zbm3ldVI0ZGO09odXisari2/Bcoe6Tk42TwzTkpTgRrA
	zqqmYmPGGKrZ755dZ8ltmrJSjHeXfuY=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-57abcb8a41eso172e87.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758916263; x=1759521063; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ip017FMnVxrXIHAt9kopjLMyNWF+o8u1hHFJYtAWs5k=;
        b=kUSfTGKn1EoSygg3hmLmrDzYGGRaXBcpgj3jj0jV8RGNXl54CYXbYzbmQ3280+fHFp
         JU46f/9HArEKucvrrhSECy3mutx3fzFC5z2dULT/GoMrTe8PpyD2o3BLaPX7O+yOEnBZ
         FVva7WbyMNvbz/YaZwxW4pbgfRFIweEk8K5VrkNfmSqdig6UHdWyRCFUC/hC1YstN5hd
         Hc+RRTBRoJpAp94hqrbUjRGIjNBTJFVR/E6jvGtI7QaQlbkO0Ky4e2hXoQYbATrpcGw/
         FrRy+MSCZgUj7QAPshwDU+a89qELX/QMTmLQr9wz5a3WpdopxTF5ybgPT+4cYUOnCwal
         bzfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758916263; x=1759521063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ip017FMnVxrXIHAt9kopjLMyNWF+o8u1hHFJYtAWs5k=;
        b=wlpBkxxmxej66BGL4gewRnr4PjjsAIFoW6aE1gCJKyDvNidcpgGRau53bkPINa8iGz
         S1Uwt8HTzyAT+nmnKtJSFz6LYdvp5fDZETTNlkHe449ZMUQ8vgi7Tfstokm4N4aW1oaF
         uX5L4R8PsxEj2IxvZcYNv52yVfTU/3j1fTKXdyqn0d/t0uY1AAua1TCozhVQNl+mTLE+
         qrjKKR4eNuTk4GJQY3TWNNd8/v2HEVtxkF7zZGtQBTzozTlGHDG4ovVJk+Vn7HNXZCYp
         7hezAwa0HDoz1ZjbM651m0UD0tasnnUpquVCnLYTG+ttlS62G66B8nIR391vpob7fa7R
         G6Wg==
X-Forwarded-Encrypted: i=1; AJvYcCV+st2tSyMg6oGIIe4Rj9BqPK0uhurn5kpmSQr2U7o7BUHpgw7E+F5VFXa+SpafhD15cWeR6oNULg==@kvack.org
X-Gm-Message-State: AOJu0YyjmNv5CZAjPxmRSnr2WIW+MRAkN1dYniP649SX2O1rvIIMYPxF
	c4lpZleDEabmdExpwSAErFpFKfEFrUiX6RWIvzGALfIxRuAXmX5o3EuI6EcyK77t9gKfxfbclEX
	DZNRwMx9s063uNNLjmG6eZfByQkSzkS6aD9wP9Kvs
X-Gm-Gg: ASbGnctV5CalDI4R6mbqvEIZifyWFR01DA8QmqbArQ4kw5Yk1JdxbeNwkpmUdWcEYO8
	GLuqHp/yf7u6OkQxoXni1qqk4wGig0wtXSBC5D+FC7bdHXYxBcfxhQaocp/jYz7hUr84qaWfbdk
	4eAGOnHqayp/b4fwukhnAVWYn83db7hZYXAlv+muNuxawve3Qs3FmvRjbF0+rP3+uANqpGsiKRn
	MWvyzB6jepEgA==
X-Google-Smtp-Source: AGHT+IEE5OaYdO0IaMGFY36b6MbwvrxUfn/XZsaRUGWhiPwBfx1smyDXptqX2r5rZlNLWNxdoLF1cU0Oyz9dS7BV5oA=
X-Received: by 2002:ac2:4349:0:b0:579:49:344f with SMTP id 2adb3069b0e04-584303cd819mr413762e87.0.1758916262755;
 Fri, 26 Sep 2025 12:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAOdxtTZJqgDNMtqsq51hQ0azanFPLXHMAJ-mRhRS6yjzYhMf_A@mail.gmail.com>
 <aNSSNgUeMSTtlimW@slm.duckdns.org>
In-Reply-To: <aNSSNgUeMSTtlimW@slm.duckdns.org>
From: Chenglong Tang <chenglongtang@google.com>
Date: Fri, 26 Sep 2025 12:50:51 -0700
X-Gm-Features: AS18NWAN5nGcUSbNskAJzYe71VDRCVrJaJpdw8gBe4Wx0-59iqP8y5qS9LyHsiY
Message-ID: <CAOdxtTZmqGpT85ER+c4VsQfoo+AHDyWC+6MG__hm5i6+sVoaWQ@mail.gmail.com>
Subject: Re: [REGRESSION] workqueue/writeback: Severe CPU hang due to kworker
 proliferation during I/O flush and cgroup cleanup
To: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, lakitu-dev@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1E48440003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: stew8h9zym917gxxjprjya4hc9rmwsda
X-HE-Tag: 1758916264-19375
X-HE-Meta: U2FsdGVkX180TzuCdkwdHJxenIzNKZ7r7cnjXu2db9Bj1/cVKucQepU/sLwQOX5IS5ax26p/yi/dA5l7Ueq2xqJLp4Iz3IBRpzRZcpv7TipmDJ/KCVqnMSEDhI5ePSo1h5HswFUZpU/JBv7rIKq+Hjo9yMnu4x7gPXzii0x7Wmg0s6BjCbuzpLW9qnHsvqh4ISxRWSBjnrOutf8UeYMUClQJsZMU7I/v/ykSIsqmI7mrEHdwPxFloS/ccoPEJuKh4LLj8xWXasThEJYBMtYI0fW6bdZxbj8pXKELX3NQm7QvLXtQSnuAu4UbjpzPa++EnezP/Yjf1pWjQsMd+khjL1IZLkAK64hk/qeluMzX9BVCjsIV0aLW4cOinmPvtApJLhn650giVnf/Yo3CuAWcrd+neFwcMgvYU9UnadfV0duxrp556JkQifSMSm0p5JCuhWYp4Z7yQIUq+ELVHiciC4S2h0sF/rS8V/l9OEP4QZMv+RWq2/LtjjKxZEathXuC39R9W1326kC9eSmjXBv5DB9VJKJ1t+NmCSpz6lW8uSjWGREiKOcyLyX7nqsKUuOgbq0E25t8Lbvq+8dijs7FAhihnICdL1A5Lz509/m/xtz0O51IVswLMKpdUUZsDC7F5ibhj51y6SzNZwUp0xNAnzNpjMLcLqnR8a43yfn8acFEwMXXQi+9R1gVrdvkcILfYF1O/8Ovks7vVy7tiMae3PzVTvKkf5lIKik5/1NFVxvhgIwQprNjEGIhd4L6nfg3IPHaiDqtOcUbPlKfsQd4ysH2WcfDKxF2vmus2O8l2edqaNpfoshtj82t1nSP3oz+e0NvlSaMqH5OiGHxnBwL/ZJmcJkNzMb6GXgQ/Yj0y2yAd7RnGNyioYns/mH2qoTilcK2mrbFGQC2ih4HD/Fg/66yhq/Us0tpdmzBJnz1hdnLoqtmODFWkkiOW5bIxGzaD1LbHpzVgr/iae4FSIl
 Guw6QVm7
 t0dPurCJC4FeRYPUX4fmYJkpWeECw/sAs+LsjKY7YKVHMEfOzbcnTCRVQuVaftvANYFS485aZTeQ8DAMGprpR83hBJlxOF54M3lynqmKXj2Wz/9S5V15ZXg/KLqSiosURlF7nTU1buOfYLGVMis5ciGggJj0uBhlitDzWNmjhufsi9uHKk31pbEBrf1MNRRXv039UXIR3rofxSQarhY6F0NN0mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just did more testing here. Confirmed that the system hang's still
there but less frequently(6/40) with the patches
http://lkml.kernel.org/r/20250912103522.2935-1-jack@suse.cz appied to
v6.17-rc7. In the bad instances, the kworker count climbed to over
600+ and caused the hang over 80+ seconds.

So I think the patches didn't fully solve the issue.




On Wed, Sep 24, 2025 at 5:52=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> On Wed, Sep 24, 2025 at 05:24:15PM -0700, Chenglong Tang wrote:
> > The kernel v6.1 is good. The hang is reliably triggered(over 80% chance=
) on
> > kernels v6.6 and 6.12 and intermittently on mainline(6.17-rc7) with the
> > following steps:
> > -
> >
> > *Environment:* A machine with a fast SSD and a high core count (e.g.,
> > Google Cloud's N2-standard-128).
> > -
> >
> > *Workload:* Concurrently generate a large number of files (e.g., 2 mill=
ion)
> > using multiple services managed by systemd-run. This creates significan=
t
> > I/O and cgroup churn.
> > -
> >
> > *Trigger:* After the file generation completes, terminate the systemd-r=
un
> > services.
> > -
> >
> > *Result:* Shortly after the services are killed, the system's CPU load
> > spikes, leading to a massive number of kworker/+inode_switch_wbs thread=
s
> > and a system-wide hang/livelock where the machine becomes unresponsive =
(20s
> > - 300s).
>
> Sounds like:
>
>  http://lkml.kernel.org/r/20250912103522.2935-1-jack@suse.cz
>
> Can you see whether those patches resolve the problem?
>
> Thanks.
>
> --
> tejun

