Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68625C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14D5B6B0005; Wed,  8 Jul 2026 07:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FDD86B008A; Wed,  8 Jul 2026 07:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0139B6B0092; Wed,  8 Jul 2026 07:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF2746B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:47:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54A2B1A070B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:47:10 +0000 (UTC)
X-FDA: 84965433420.22.711B9D7
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf31.hostedemail.com (Postfix) with ESMTP id D5F9920002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:47:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=anB4SJg7;
	spf=pass (imf31.hostedemail.com: domain of daniel@0x0f.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783511228;
	b=abQhiUtIvLcmeO+YSjljdD/l7wvTurh7UFNxCPHTPySUDn/caalZiyb//P4HMeI1cYHPmZ
	b/XEaPIFUohwmQDjzpNOvjEhM7da6UyX1BC9frQeAR5RWlZ4+qRRsJkYggaWhmQ5gE4YVm
	gbJ7EOs+mFV0B1JZHVyhGLe/XhtRVLw=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=anB4SJg7;
	spf=pass (imf31.hostedemail.com: domain of daniel@0x0f.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783511228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9LcL2EmsnAfaS8zlx+7ddixnoRQmUi/LbnHQfSgG2I=;
	b=4OnHVGlef8NW/O5oNaNXhCnffxzE+pjvA/kRbfVO6PXZrJPACp3+Qm5H2znt5RENOc4TJA
	JiSJGs9NgNCLOGkXkfDMU83cOuDmCXM3RSgmPjzHZDjyGDVWvlLh3E/EwXyFvu0aZgAijM
	yoVFRGB8cZ05hZIwkdTgYVzJuGY1V1o=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-385b78b44a0so586092a91.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 04:47:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783511226; cv=none;
        d=google.com; s=arc-20260327;
        b=isPkTAk2dTC/aPley3WFCP4oPdPh6gcmjxfCfP0mmncxFhUbTFSQl4Gw2lHpiib8ob
         GpdyDrb/+BDi+P3yW8LmgCkb/FwjXkTSIxtxNcJbm2/Gy4x05L3MVSkiCsbsplq7/ac7
         a0fOs3pSc6/CmVKRIqjdxuV1RL+FSJCI8KVFy3MsxAGOPV6uksPQP68ov9U7G0QOgHfP
         ALI9pbEHjcvEElYbKrC/D1X5xhjC8r9kchGfKOag8oxqkg4i2iKAP4s9Yl3Y77NKNGSJ
         m2T1UG7RCazq8330ZtPYvhvS0k+hoEYcnKKC7gx1FrXrS15LGXkAJs4QvQUpt4EJ5C3y
         +tyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=e9LcL2EmsnAfaS8zlx+7ddixnoRQmUi/LbnHQfSgG2I=;
        fh=POuKkLZc+RcoehNikg5LR574ALtRCwvvPwV87CGtUGw=;
        b=kjilGfGBn9ME8p5Dxn9KG+mcxQbhp7nmehhdQYUHDBQTrS7ILLhNLS7KFObpH/Mfpx
         f+DWAHeqx0YFzUmO5kzS61sLe5oyBUPk+HgYiI61KSpAUHPgKoRbPz6NMOkdxK0OaOST
         92xJbf0xEx4pCzBbZ+VeYE9TPoMIqtTauOwsn0auJycjPAAmOVDVotAEDD2CWP3DlYlT
         1aaMookhNRnurs3ZWkmlctxxjuEmH9Yby2HF+zZRyNHjVCTUSBHWAYY4HwYcQF0Y0Kb5
         V9mxJ6pXB2gzSegDx3lbA1UvJCA1q49iRXAJZaBxqZ++0nqrPLATgFBY1rS/XTv44Guy
         MmZw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thingy.jp; s=google; t=1783511226; x=1784116026; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e9LcL2EmsnAfaS8zlx+7ddixnoRQmUi/LbnHQfSgG2I=;
        b=anB4SJg7EQy6EBVoWl1ieYJxkQB8lx0W3/CUUsMrtb6/dof3kidmWNeG+67cHVGjmK
         sDKF5iedlxkK33w1Jc6/8YJdikxUWKR05Xfs8bwx31XSoimKm0fwoTKtxdaGKmxwXHDY
         BAytpXXdgWEia76LKzbiAZQCbm/2I4Z/35aBg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783511226; x=1784116026;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e9LcL2EmsnAfaS8zlx+7ddixnoRQmUi/LbnHQfSgG2I=;
        b=RzFvM6GgDeatsfmSo64KLSZbvc6yPSdM7RLk8LJ1Rjxfl3p8Be5MWwnygozguuEJlm
         kriUmtPNUpCXkCiERQ5Hb7lN65HtqKC/QWADFegBRW/AT4QJWHY2GX6j/8Na8J3+LTdV
         7Bzl7GjM67ngyTnFASI4Z3cIGT+7MeWqSXPxKFtyMHhthG+pg55drhEx2GkZykv3QmI3
         lejQkk27kLeJeJ+/N+eFFcwlnQLmtMYzr1Q65J9L7oy7JLlZzRNIGdLDJCrhA/47uRrx
         FF0F86pQaAGNVQ3TJQPnXo3H+B4SDngXmZTT4q9qLJVtKcqrj12PUBbgxPUUivxGM4Ge
         6ubQ==
X-Forwarded-Encrypted: i=1; AHgh+RrHmDHFaqDXaY/voR1OitikxLSuTXjRlD3/KA95Bu2YBmVhEZLttNe+HDKwVSOqnO14u9Xk5+HXRQ==@kvack.org
X-Gm-Message-State: AOJu0YwA8z9o1tIoyRu32s+AqOpo5xy1jgByWGmz/gV3N3pGuD2Hlecf
	wSY2D/wrAUCGPMx57JBFULJw1C/IwXN/lcoKwHzQNgbQgt5jcV6dEH/ZXBowsdmeme3g+8qT9/d
	5cB2Ps7vZc5jZytiD3Fy7MeQBvj3Pop3DNOaZ0Si0pA==
X-Gm-Gg: AfdE7cm0mgeXfyza6Ug6KpUM+BAdI1kIFnJmxtFJdk+DP56EIZDv8CTjycIMcbmxBdE
	5XaikM8LqlJIPbrR204l0LqzW1aKbTwvUmUZr+eZgLz7e4ggc8onpDc+QuCc+v8cJYWrcnEwwjH
	vimoJiX6RXdOP/RqRSXrdi2mSF3WEuVtXvxAzUT6iXWPkU8kPAeONiTfXLlvi85ETTExnrEvw2R
	H5U+Si263DeHgbV4WjkiY2VTd/1EvnXwyCegSSqwf116TcJP/KIuz/jJ/oH0C68pBKjmEOvrhJa
	60ihL4+7HAJwTiGbLNqt/iU92kF3fZo=
X-Received: by 2002:a05:6a20:12cf:b0:3b3:fdb0:2288 with SMTP id
 adf61e73a8af0-3c0bc55cd9amr3035041637.0.1783511226436; Wed, 08 Jul 2026
 04:47:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260523130445.1101818-1-daniel@thingy.jp> <20260629205854.0062b1fc9588ba9928bb1707@linux-foundation.org>
In-Reply-To: <20260629205854.0062b1fc9588ba9928bb1707@linux-foundation.org>
From: Daniel Palmer <daniel@thingy.jp>
Date: Wed, 8 Jul 2026 20:46:53 +0900
X-Gm-Features: AVVi8CfinkEnutyTpIrgqLtLXGqwtm_mnz0TIuLo6KCJIR5SV-U6B6T7w6u6n30
Message-ID: <CAFr9PX=2sZxr2BaisdnX4nB5zvM7J9zkU6zWihd8mNxOJ=TudQ@mail.gmail.com>
Subject: Re: [PATCH] tmpfs/ramfs: Let memfd_create() work on nommu
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D5F9920002
X-Stat-Signature: qjstbus9utqo18eynmwzua7o9gn6fkok
X-HE-Tag: 1783511227-457328
X-HE-Meta: U2FsdGVkX182z9j/dlLc7i01R7s0pA98AJJGu2YbSrdQGJMWp49ZiFwhW7PXaVoyPoSkxNmbTcFtL/n8HrtbaAi1YdW+5vUauL5pdj9yixfHlcOp1UmvdU0DM+Lq+3RGIUHqnT6jBOBKfxuCEa85snIoQIogMyU7VM/M7J1IvNNEtWvNLQe+frb1YxGYZlv0m6Ff5eRtfHlPQN1EMQEn6NKUDwtrv2Bv2jSxW1tHc2kUkr0ZPjvpLHgTtu2AD58ej6sIiJ9nP8RsToOV05n5ZP5saavHg9taFN3cIgrh+92xfoo/8XqwuLUKTufJsLiHclRr790MBu66UQ4WRsa6Mb/RoPBIVfqOk9doS3UgILzg/ViSJx4tLcD/yNt0psfCNz+DtpKQ7r3sJJYHGQnKxwDWMqUw4y4WdpUlEhqRkvcrXCYAiwYort2YlJgIvWgfwjdPJEhPMdeIDbReMZ8Ipb05KXHxaDpMP/nhzg7KJ8BgQaL2cmqG8eSnx+U7S8KtyNcLrZfCoASvwW6TH1667iH11wT5ZvtfoBQ2o84wv32x0bs5682Zgvda8zvT+HzcjJKVhD0kXH5ncyznV6iDO/m6Z8j7TVErAN9TpWyoJ0U7owMKkArz/f7980KuwNp8iOWgeODCr7jIGjbSse7sVVT7kR0j+w/ICEHWb+FtZUPOnj7kvJeiL5LVJ2dP8kKha3KwsYfcXN0frAZcJ8nMPb2vth/WVwN5Xob5j81gVa2aXZ7E7gSOosgrdC8PJ/aNq+d1Xh+04YMg8cH85jxxqMVoadpmwGelIvkaICTztxpAQ8PGevlAM1zVNRqglR6VvtL9YCdm/uW26KQn9RnjqyFmMFsIcen23/qPBbBGevBXqmfDC8kDJYH/gPqJ0gQwnMCHD0DYs3AJFHzKyPuwXTgiFhJHym7qAVJvN3/0S7NfS0az5RsNVzsao+uvaiLutfqw8jlJEhrwzmBwCt8
 3pcmmN3q
 UIzZ0vxtF6cVlrT6egcEQUZ0lg4uE/XvAOIolRHU3Hr60DP155DHLGgnLWhdD1+vQViDrrnH+xo2cHgLXJAmf8rfL5KW9DfbJS6jE6LtqVsQDh+WEzqYH45pZAhyXBGHPCpzwhUUkBsO8PK+sksz5sfzJqPnHw2UjrbkGVByNd/FBGSff0YeRkqyvPOjv1Hrgj7T2ACl0kSGBnqKGLV/X+trfvmy2PB3PXt8w2DZMxYD5Nzmjy/GXOvtgDxkjZM9gmyftfkSdSFlNjNIy3X6nWe/JWPCyUK+xU57pgvaLk3sAnwiGE+CQTvN+hppUJi8d9chXik1Nl5UI2gd5rNGvZ3ODUXRt+6PeICJa3sf+9UbINDyqSSl6qDDl7m2w9oTiTeonwfwhQj9CzATwDsksUYueK+CRUC4lu+6VNssVQXcE6L/ZDdUmseYZtLapybUz5YrxBVFVzlOhym6BhG8UBE0DOu1WObwpzgBtzh/7Tqiu5Qo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Tue, 30 Jun 2026 at 12:58, Andrew Morton <akpm@linux-foundation.org> wrote:
> Sashiko had no complaints but it seems to have found some unrelated
> bugs:
>
>         https://sashiko.dev/#/patchset/20260523130445.1101818-1-daniel@thingy.jp

I took a look at this, made my own fix, fed it to fable check/clean it
up and it seems to think after its fixes the sashiko reported issues
will be corrected.
I asked fable if it thought there was anything else major in the same
file and there are a few minor things but apparently the bugs sashiko
reported are the major issues.

Once I've tested it a bit more I'll send it.

Thanks,

Daniel

