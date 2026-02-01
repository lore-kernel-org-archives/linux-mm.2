Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D733D172AB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 00:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC626B0005; Sun,  1 Feb 2026 19:46:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040266B0089; Sun,  1 Feb 2026 19:46:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63906B008A; Sun,  1 Feb 2026 19:46:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5CE26B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 19:46:47 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75C56C30AE
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:46:46 +0000 (UTC)
X-FDA: 84397676412.30.CCC1FCF
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 90BFF160005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:46:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SO2viLzg;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769993204; a=rsa-sha256;
	cv=pass;
	b=nWYKI69EYZZlBVY/nr21z8v8vOY6dJ8z8SWLDjVJlZH1CsJpJaOho8lLd2VxYBja6sN6jy
	toWcHAJK+QRgVYs7zd9GwMJVbNWXo9G6IWIFk8f7vpVe9bM4FW07Y+sOl6VIGfXvWmtpxf
	u3cZ9HA7XWnJX2Jc64EBCVXTh0tCS6Y=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SO2viLzg;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769993204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xCIt2uU2uvO03164qoXDWNLcJBxpasHHgWM7wjJ8E/4=;
	b=nym5xrs+z9yHruSy3Aar2Mxk91Q3LCeF5LaH1G/QO8s+t8CgpgeuxS78Djbw6OUIVLjcGB
	5Xl+cSrJxVP29/vtdDn1qABIUPj4gEjVvbG9SfEtR/+cXwLpDZdOycAEML1jrHVbWWRg+U
	VsZhnpk2xoBc3wDCMZFPXuxhaulWyH8=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8947e6ffd30so47157296d6.0
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 16:46:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769993204; cv=none;
        d=google.com; s=arc-20240605;
        b=knA1RrHTaiaZHGOywV6ztBE6e3lhWGfF0C3sQptQ888srX6O+jHDFS+ncZyhQodtzy
         ZxvXv4ogTpx5RASvMJUF97/C4yjnsor6eSQMbZiUxKr17mgIV2vtHKALoB7Kf1uK22yl
         z1e2llsCHZ99iWGTOjdzlxv0JaRkTsxqxxYFL39eWYJhaJEoDiB+PBhQSL83FrJyAer0
         xP0WiIxoeKUp2xI7JDaiFe/XlNmBAer3qTOgFwSp4A8hoYj5AbYD+BkdffG8t/ctjYUS
         lzY/6qRVFaWZnMeMdxdpWstDW5vO2uA0pRdHbzCssIZkK4uoCRFPF1Su6RuP+t+gS2M6
         ccig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xCIt2uU2uvO03164qoXDWNLcJBxpasHHgWM7wjJ8E/4=;
        fh=YJKceG2e8a4cPA5ltg3QRMyZx8e6gMC/0TgDFIdvdx4=;
        b=Mh3azKtcYQw3skM+oL338MHb1Nfqpq/bfggcGAUwAAdVpyoWCfHqX8o+GdZsrcWaLN
         mUcq7CJwUFndABGYYe8lutxIo3CzPOspXvbLStn933bJWH1X7s4P5vFozKxZzBC6Cffi
         n7IY+WD1ehUdynRMzNFowSyitCGkrCEe5DTVPoaFB91I5IUVoA+m/+BELeSBaFtu8ddb
         auTTAggxYI7Hl0v8vEUXKWW8xnNlPnzidnrG+w2I1jZLi0FtyVxEewt3qtcMwC/cb4VP
         E8KP7Cb6vu93s1vfKdVWLKr5TdV8prGOj6uPaNGuI73DWIWTCBKSNYP6Mz6quxd/TfN/
         op0g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769993204; x=1770598004; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xCIt2uU2uvO03164qoXDWNLcJBxpasHHgWM7wjJ8E/4=;
        b=SO2viLzgIo1Tn/Agxan3Xl1oQcoDM61/V4NXAT6CsXYToMSEn0XDAbLK4IvkUDwjGd
         +hlbZ9Mqy4qKT7z/CrmC6F/UhFTJ5M0Hc2VfdQWATXa99YSB7iCaRuC7Y4+kTut3qfF6
         JZydDa3rPFV+Rc9xiRdOb4V22X0FLkOXvkmg5S53D+XSNRS02Cgt3kyPa1SAxXbUDd0P
         yGMzPlrA3qUwSwSrFti8X+OG+9fn5jCw6wl7lieyYyIkoF4cdNrPS0ViREjbOwKry/Z5
         gTlutJtwRX3YDx1JdSx1VQu7lQknO3YyXuPopHx25/aS8E3Sr2IFU0QsABVWvMAzBFfK
         /tKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769993204; x=1770598004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xCIt2uU2uvO03164qoXDWNLcJBxpasHHgWM7wjJ8E/4=;
        b=o5tMugNqna7QXzka2HQDjm9/zDjjvzIpQRKRx/c+DjEbe233b1AJSp+3SXu/prOh9O
         c9mt0wx5IVUnPYEHdDO4diq+anhcL/Jh7WCyK6ywrypRST5TisgjxOvc1ikFSKgJvGqN
         zfNT21aHDFg9xjZI6iW92Ag+MRKLQYJ9rcKcaUfekbNB9GGIijz6xKBxrhVNnzHOzusG
         FJD0YRRkPyONWGqPysrh4yrIgBAjNffT+YjhHa+h6ffSkIakPH+VIYf/8TZGnlRHeHfr
         uHcDH/eyw4oE1S5q2eaeWsUudSPBRXXrj/XR1G6OP/oYUnFoV2Tj8dzxzH2seeGKi9ck
         cf+Q==
X-Gm-Message-State: AOJu0YzPyDgwKI7ac3vRI8y2j82uPwp6GVoQMdEYkX8t5Z1LY3QxGoxw
	Kn1YfE7BZBLN3inG0SO6CC+ifVb3G+h876lG3isMIQxyfRaxNYX5iWSJnJS++ZKATgjLzjdmbTK
	Oesd+3BOXu2RYkj97lQrmKAF0IICNVSQ=
X-Gm-Gg: AZuq6aI7uGNSQO2XGvujMbJJ+Wcp0v1VkGpAfu7Vs6midYcfZN3+aS6eDap+Wd2UuFk
	YUWFWZT6gFAAJNXkJ+9cRxKpbx1/9e2vMXpeHapvMiOMzH6dcWwnQR3QaQQV8araD/63/q+n96N
	UP+KrA/OixW21pTIreQ57RFED11i2+mZGhnGR385m+yQq0tyXFG50Ai1p5Jz7AdxcOdSwW6EmN2
	ToWT6JGdjCfG5CbgSUEXH6BCFdYdpycEzZDrnJqfBhwzJg9veTQFOfUO8s4CBhvcNqNtQ==
X-Received: by 2002:a05:6214:5095:b0:890:26d6:97c7 with SMTP id
 6a1803df08f44-894e9fb782emr122787156d6.8.1769993203443; Sun, 01 Feb 2026
 16:46:43 -0800 (PST)
MIME-Version: 1.0
References: <20260202-zswap-syncio-cleanup-v1-1-86bb24a64521@tencent.com>
In-Reply-To: <20260202-zswap-syncio-cleanup-v1-1-86bb24a64521@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 2 Feb 2026 00:46:32 +0800
X-Gm-Features: AZwV_QhyHJqz9U1gKxjncCAKvr9SUFAICHd6qWHcSAptXidNsL8-zgIrZibpab8
Message-ID: <CAGsJ_4yZeg8_Okjzvvr_it2RMEtEEpCbsmB-p8cKuTW9VUsy8A@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: remove SWP_SYNCHRONOUS_IO swapcache bypass workaround
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 90BFF160005
X-Stat-Signature: keqqofbgep4uoctwbs7dz4dw3z8urdyk
X-HE-Tag: 1769993204-674120
X-HE-Meta: U2FsdGVkX1+u8j0V/4Qli5GgcO4cUswj2s7AsxNp5LGGkUElgxypKBsFgl3TbVdytXQyRpBOqyNn2DQNaXBcK0d/PKpF05AQpNJsnaxURJMn/elU2cQaDqF/6XBvMtl+HSg39KOO317MVcpFIGFlbXssPK4I8G1r4Dj8qBp/z/WyCrcsEhtcyfc4Kn81njrMtdr5KfFxC1atYGOb0MRwQe0RXXvj0TQd5CTAXdNLiJMrPqYV+q88EJbhjT+84fe9GXeACO2YBec9TiVaVWYc8K7mTBHMJile8svKEfRp0XyKAWIelsPTmT7JgCTSpD5dGnQ5FyQMyDrxr68XFytyyGN1iJSwDH7KYk7cnTpcnX3d+5S9KOU7/fbAf7yix4GVlNRpE8Ds9bwHMwa8FeUlbg27+njKjYUFP+82nHE+0GyMj/Jh+4KAuB/DHIk/aDBaonYIcGaPyzIrRoCZfvwQ8NjBEOQ7cSGq/xaxauOnHyP8uQg3IABdVkvcMqV65huWiQkxgU0g7Z8cDMneL2ihkn0jJ8uLKANgrvdrwz6VWlgAub3zUN9LiQWJYrOZP/jm0cXExl3UayVRtVBIKODuF8kxIR6NAbm5Qas/PqPaESUXW8cnpD+OTKsRaz2T2ZJN6W/Nxg+yxc4+r9ZAQtcxCDk/u6R4u2qtw3x9XQLdhYCZ5vcrL3azlL7VlGf4HI9RJL6ZbFjXMyLfq+7jkQtFeqWtp2rvol4zJ9txRXEq6wdpKFO7eGtgn02OtZZIyoLGD3YDmDYudMb7oLmb1p6ldc42o7b8nJLOZt7I86hmrowYDSjQV5WcoMgp8//ZyLbUDbVdp3nDdrjbW2yyXPAiBzSdJDMv1CXtrFafDLe4JGvLbYHf5P83PN/pYVXxtEDb1ZHfxMMF4WpursHAQA48v7Tm53EyoB3OLtUWnkfHvfc/17j20Cd2ie4l8JRIaRzwtcSPuEkVCoby7pJnKWO
 vkt6Uv7b
 fzkmoFf0z5RCaZgwmIrN1l8Lp3N2XHDKZDDoiD7z9OtYPAfHWaEp25zV3c12HzvKclmY0DrJeXBcu+aaZOWpI81ak7xgNRyp4XC52c9Y2VfxAxS/+23nmyIAxnXKSTiViaS58Hxo7k0rzremlXWdnMxAqrEKx9wJW5Mw3EKC3DGCp09QfaTvTH8PrPusc3jLgfjDGIaYifTvdRPFNPkAFPD+XV4+0724YaddtVO/oD550VGy1p+RwdiqVCk4yKfYM8zEPwDBAryzB4HBRpM7DAZ7jq+H3NH4wKubkpIuV8u0TtSS04KQ2/QZGO3qpdKQmUdc2L0YpmD3Dv3tFzlOX6pxnB5KhR1odx25JLnHHGTr0CumePPOzWSxcxxIxBe53Kv/71j+3FhN8efe6sCzGIPfPmUqyyDBqBhrpj+DUV+PY5wtDYuWoTGg6XjvbKBnIAz3HNdx69+WfAMPIkNQuPmg7QlMYAFQ7J2+kFCmtfGEnXCLba7mFtMg0XalGdLtx4TAu+2vTnTN5yrg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 2, 2026 at 1:47=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
> for SWP_SYNCHRONOUS_IO"), all swap-in operations go through the swap
> cache, including those from SWP_SYNCHRONOUS_IO devices like
> zram. Which means the workaround for swap cache bypassing
> introduced by commit 25cd241408a2 ("mm: zswap: fix data loss on
> SWP_SYNCHRONOUS_IO devices") is no longer needed. Remove it, but
> keep the comments that are still helpful.
>
> Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>

LGTM, thanks!

Reviewed-by: Barry Song <baohua@kernel.org>

