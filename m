Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B92C7CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:59:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04C9C6B0096; Fri,  5 Jun 2026 13:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023876B0098; Fri,  5 Jun 2026 13:59:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2F46B009B; Fri,  5 Jun 2026 13:59:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DBB016B0096
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:59:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B977C13EF
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:59:10 +0000 (UTC)
X-FDA: 84846620460.22.69956AA
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7BC704000B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:59:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U1Y1GlEa;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780682348;
	b=U+/PNSieBvRq7e7B3HwejLrLme1TLsxRPGhgHC8qLR3LrALYexcn9qfbC6u5Blb9cZnjI9
	+VrutDp+v6zyExQgrOVZfA5RgXHpORuRUuQ+GjaYCFefEEG6Ti/YQhV1MxRTd81vDfo0yY
	gS4GQnFjoiiTdo/kIvwa1Ju4jM3KlnM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U1Y1GlEa;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780682348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wLo9VkKSjHAT3gGfj1DF3PurnST1RSxuUkL3MaXTpW8=;
	b=FjegRzTUJb7dXoluo9sVo4q27/jh0NiYNfwm1zSQzPYIk1/jjn6Mne3vemWa/xQ9PiEKzX
	goteEbML9DSh4mlXmcSPkDKE+LHt7mXP/S0deCO7dYodsKxeKv/Sv1S8BNESHrY4G/w4J1
	oT7MfFtJ26OsEpOwjWE0J96qqgj90nc=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-45ef5146b56so2138575f8f.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:59:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780682347; cv=none;
        d=google.com; s=arc-20240605;
        b=aFqtxWQPAJoLluqin2DQUi2ryNGmX9vN8gI3yvghVht8q8nINnWWuCjt0+EuoUAbuA
         4CnxnlmdDpoiKAWKTxfadg5UutfbRXvUc8fO72/Vc7x2MRBEAxy3JyxB9t03G4zp36zR
         hHtieS9lAiGUv0bwGbtxSzGKBawkTorfgmfcXygz2xwum1ROQJfKLfyLQDpARUrN80E2
         TmcTuDzo7m9OXibx5v4+BNL575ywS1dy6bJp3jvPUkCSarUblE1xLJgxxG4Xj1l6+CoA
         JPvKlo+EodBifdMcLpULMQBuI9swbI7GxXEhNlAgu6Htj/qzUpjIBkT1F9Xs19kjRI1s
         66jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wLo9VkKSjHAT3gGfj1DF3PurnST1RSxuUkL3MaXTpW8=;
        fh=N7zW1P85F9O7EDmxqTCfog4HPypnntyUaTFI8tav9GM=;
        b=RrK2ZiOXv0tkV+8QsbCQatCs+EL2c9kxSXdnYq4pB8AofZUtEw1UG8/Ni3Lsy+BAYQ
         IuYXkYpXqxHYMLMuHLJmBaKcLTwyGIGWDHYyeeYYfbMashp+6b7WkfVtO0crqVad5XFM
         /NnuAbtIQfzh84FDPdPp0XArcbXkSSqNv2krfQAu75UbXpPYkBbc3KLnSiNWcd6Ipxbu
         bv6ezUAYYDWhL93gdzsCWIPw4/6Gzme9cO4reDgikuTUcWYO6E3GyPMn4GtmK4ZuEWpd
         YNXRQYh/Zb88p1MkhF7omLw+6m/w/zI+QsP+jJcdy9xN14fAdLMeiBLIRC5WbGHQjJ7x
         su3Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780682347; x=1781287147; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wLo9VkKSjHAT3gGfj1DF3PurnST1RSxuUkL3MaXTpW8=;
        b=U1Y1GlEaM5BhvtJbuVGkohP7SScqqJBruvewUGjlojRCeFe0UVBAknpC9FaHzchP+X
         dcwnvsjq2XCG/+nePTlEy4v7kLLxU30ipOHBPwTQiBgOeggSszUVGHzwT2WDQU9TEvdo
         B3jcVPH5gu2DIld+8ToXKB8sHeEil977iLk0NhPpPqzndudCWQfhYeZZI7Akfw3aMmwj
         +e6Q7EWu+oOHCai+T2ZLKVHqOU+bdvyost8LiAiX7CjEwI+eHoOE7YS0Iy47uORfLyyx
         oVZVc0ASPHTDQLTxa+dzCYwFh0voz9STXmrJjtdKRXVtkJGsEbhHJPNhoCqFy8+qtYAT
         0t5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780682347; x=1781287147;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wLo9VkKSjHAT3gGfj1DF3PurnST1RSxuUkL3MaXTpW8=;
        b=tABzFDWPkhiY/qRsFZFLpzHfmVox5C1BvOt5w8mY9ONSYe0TnUSBCr6uijhLx75Z13
         RICb/gxg8PfJqh/B18ve8U/ELLtT/xeG07dLpKfboWF+kMW8pag+GJeGE4Y9OWu8g5u6
         4LkCNceC5jNXBdPPofPrG6HeLBeDneatPcYekZHKYdDLtsjBf/UZSLOFbiucKzAHuua3
         sxnuGuqwFeSoy3M0phD8bi/FqaZZynzJbHeUx8sb01ACH7cwmV81OHtuwwsDofpN4Ye1
         SbtF7ROzojJ+dBJkVVj8Ks/q/3JJFwQ4F+4ymTUCU+P/TsfzbyyiCO/kyPFYGJpJT3X1
         VjuA==
X-Forwarded-Encrypted: i=1; AFNElJ8IyF6Tj/vRQqMp93rfU92KbI/IQrrpLFUXd021Sih9cRDoZZ6ZS9LWPmv5Y4MjFHOM7ZNpqMDXzw==@kvack.org
X-Gm-Message-State: AOJu0Yx0JesbVrnfZnGMlnrTVMn6B+CLKzMTCnG6oem7om8/4/fTtiHo
	ACyLSGuvAlPI3jgwf1/zcBGb0hHvydSghu2kyT+bMBqCx+W39CA3ffPi+n4GbKg1UMal78ryHlS
	PwzlbjC/+miBSQ0QUu7w8+b0c9JdBpC4=
X-Gm-Gg: Acq92OGdQxx/fLxNDLL49+GpFKlw5V9GJAEnYpyNCiivI3DrudIRpQ7AZjR/Xpsmxrh
	cB1Bj7KAP8DIiJDFddMhiG+ian0mU5HXM1AvJzQpaHHWk37OLeIzV6l6CIVqUh+5VOl/hWvKkxF
	Wk6nL2wsrsIYtohRre0yNXT1alNlNSh0qSMOOVB7+D7WgkGGy4ixO6+CtZMnQH13cKheFYF056P
	1nx94UkdV40CGXNxqGNX1tN3SDINr4NOdWGTRYpMehayv60to8sDP1CYPSPvPIKEhhi7T3j72NW
	SswJ2Bldc2lgu5KS/nP48/kcJATs6hjXBCeGnfveRLA38RXYSA==
X-Received: by 2002:a05:6000:4802:b0:460:1330:f50f with SMTP id
 ffacd0b85a97d-46032b61231mr6206314f8f.6.1780682346894; Fri, 05 Jun 2026
 10:59:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260601113449.3464734-1-hch@lst.de> <20260601113449.3464734-8-hch@lst.de>
In-Reply-To: <20260601113449.3464734-8-hch@lst.de>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 5 Jun 2026 10:58:54 -0700
X-Gm-Features: AVVi8CdjI8PDtXu8VId3pDCeG1Tpotzp5G9hzWenSKcS36GjMj_J00X3SVjbxBc
Message-ID: <CAKEwX=N+-0ihnxgZygEVstuVhS1NSxwAmxJPueALAARM41qSmQ@mail.gmail.com>
Subject: Re: [PATCH 7/8] mm/swap: remove SWP_FS_OPS
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, kasong@tencent.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7BC704000B
X-Stat-Signature: 4yuc3hwf7uoqpgm1o8teqbzmy9yqzx5g
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780682348-442769
X-HE-Meta: U2FsdGVkX1+XG7RWq0oPD8QJggJYUKddriYZT6/o/6myzzUWzto/KS9Zfk68L6hCTU53MkGM+hedBPcTStLGLvdcK50zUh+kGSpy4xZm8EdIo1oPKAyWR/IV5RUioCkAlBj10SS8lVH4Pa0TA8VkppYphBl/EBx1wOpgB7BA/ZMCw4G8EeWUnoNjZzhn10u72Tcn5xuDzQ7jYnd4j6MuZAF+T6BsS1v0xI1oafsxvESxuXG5JZFhiDOSkYYZcaBJD7H8dQtAmzBmtEt3Z8FC2L3+WSR9+C6Bzk7dNaPX4l9G/39azuf+UrI6QVEi2d5jIhDETZ3NXxUawSxPfNrrA8oK4VOrSMR3NsXfdnbxn7Pj5MuRz78y8PiS4sk8066BT7dDyAm24i6cOkGtis0iU0kbD8xUEEBUk4rkorbG5+uuUQcJaznKqCwELuqsiGrwR+jSqibeVdr+lwFiuI9ttVnhE96Ktshuka4T4y9GBJrrMbYqD5uW34drOHRuA3sWO8cwrgSipB+xkE/5hWE9LyBESwO+vwtTNG/gDanZVy0dRvhIWCrhkGO5gPIHupizEgpBSSoiC63AlsTFwFlYaRMtRdZCbixjDDMssxuEvAc/FP+BN/uJj9bNoDXcRZf8t31z4gvxcJTd6I+uIhMy0mxHznCMO+cXnnOdoKZb09DWXy1KSrtU0XebzcK6+TYZefFSaYcLBE4FwXBqgkwqUm+dyQGz1ppZbuCnEtLct0qlQjry60QCIKn28WDwJaUTYYYQZVlMAHH034EWAD5hEfuJv3RPxZxmr+YVPZ3//9xHiOkblhS4Yt5USq+Grdp8TDo8v/uw6Ew2p3a85lJs3nfb1QNaIbbqMiC2Pr6nfF2R1oIxG4psi0Ej8G2D6w8L0D6/YhxY4ygIkzju1DiCntrBgcVwxMq+w94YRcJdATC+z6SVwTvlyBt4JCfdtdyz/xmqJNWhfb5wh9rhwmM
 VOufHrDX
 VPYYkWzrPW7YaF8Lo+SOo2t0fxXsYOPWq76d76zfMUAvNLg4t3Oohkh01QODYKKQZ9Pv3LZ42+wKBVSD4RYs5eWDqZOoIIBN6Lg2oWmTnSQTNEDkjiJuYbqxEBJxc072kA1o8vafb1ANTFcsFONc3dTapi97AN5U8iT+Wx8WrYo/TZMMNCwyExWwNBAZLezCg+qN6/Rj6BjfEmj5Eu+mLxG5ZYtLuT8NVLgBvprjxHlLPquWU804CDH2y2DcRc26xtdE13dqb1SGDgwe1kLWLThQfb/WFfwPgGAqu5BDj6fW/7rh3QkFeLL4vAhdkORdYujHXXgQERRl8B7B8tb9YmLWcgUTdzQrt05NC+aNe6PqL6PvmBbSdf8veCI02gYIRiyaM2gGFHCu3ttDgZFLoP3tH/23dDKyOI50MWIxkKm950pdYYdNmYOoZx0OoPqZuo9nLBe4Xnm7FlIWUnK7PIcghtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 7:56=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrote=
:
>
> Provide a swap_fs_activate helper that directly sets up swap_fs_ops,
> and a flag in struct swap_ops to indicate of NOFS swapping is allowed.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Code LGTM, with Baoquan's documentation proposal. Tentatively:

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

