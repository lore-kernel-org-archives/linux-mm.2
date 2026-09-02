Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 886BBC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E6716B00A5; Wed,  2 Sep 2026 10:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995E86B00A6; Wed,  2 Sep 2026 10:53:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85E1A6B00A7; Wed,  2 Sep 2026 10:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD3D6B00A5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:53:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA4B180201
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:53:32 +0000 (UTC)
X-FDA: 85169115864.30.8E2ABFB
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 18E1440007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:53:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OpkdF1q3;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788360811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cz1/Y0DZddHarQG1HOQ6HanJnePLmDeFZMT4+NnMnkw=;
	b=JayfxC9C4ntLJcDyn5ypw9yQvjVi4BKZ+lnHnsM1zrejoM9zclvus/7U0OYZxcrB+HK5ro
	4AlN3W2jTz5fvwrgc7IWSu5GaNLD5IqrG5hWUuqpKc1fWb7mdluxAngvbMnjBzNsBZi8K6
	39DhuaOVtVkSCT1n5JfixClSw3gDzsQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OpkdF1q3;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788360811;
	b=bJcYLux3iAHS893QuJH0V8X3HOWIjXAR3+haBuZPCDG1IpNjGV+/gEWEFvJO4q23mF1vEZ
	fvy7atMM8RlKBpCL9oBclf8t01X2/Oge/i2kU1eLXu9aOZzvO4vY1txC4J3LzrN/5xsNaI
	Ij0GvJbS+VgqIKysDk6mrjBZaLCE51k=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-495590dde14so11871395e9.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 07:53:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788360810; cv=none;
        d=google.com; s=arc-20260327;
        b=fhaYyanT+ercZheQqgBPJ1y41bsmkJ/tn3y6XI0eWDwqyyF7kVHKpYscOBZcL/jNTv
         TstzwwmxxLhcAl2iCqSYPl/4o2WnJF+UR2jbPXDWYRlbaYa5P7D4HkffQAZ4OeYybRp+
         zuoZqE8pJ0zc3w6LdjHNN0tx54pdSwgb8gMdwUbBK3gXzQ6YiTwAlp7iQZxZ7TeOAv5T
         uWxHGF9B13Euw5hrhTabn0nCjAL+Wnq22EDq7hO+pToLkXOFPBda24PtyEZT633859j2
         JDwFm1MAjpP6fvWGOsGXGy/bXDzyYCWPi0Scgxg5SIMATPHeKScfXZk7FP2hCujroMRJ
         HG2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cz1/Y0DZddHarQG1HOQ6HanJnePLmDeFZMT4+NnMnkw=;
        fh=KewnQt8I1RGzkGmgAsxpY598ouhBlUDawARPe163as8=;
        b=MqJ6rx4xXoUwl0I1fCsxqtn2GtRqi5Cukck77vnNkL4l5IO4/qROyJrLHUWM9KHBvB
         hp9lw6C8aMMGTEsnf7tZd9EKQJQ4GcCJDoPOUS/4OI9dF4ToK2GIPdraEzm7/Sk1/ZKQ
         TaIKvxO3iehTG+Qe1ELhpKDcSqCsrvksCmG5khAC779jpPTaDfikNKfLdC0v1CKlNvN7
         PmS5YliAgC3RL8uPg/5h7k3XGGHYpYosXrEWSuTzMSYTMYgROAyl/GAwZ3hQ2SZbb8xV
         vwK8pvBmezAFDwKzY9k4DJrAivF11B3BaK/Ne4w3TWX/S0JcrGRJUsaxBg3l2gx27Xoc
         S98Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788360810; x=1788965610; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cz1/Y0DZddHarQG1HOQ6HanJnePLmDeFZMT4+NnMnkw=;
        b=OpkdF1q3r0vYiBkkkaXgFL6ae/Tzq/8bf2/KA0zuw+NvVuribRi6wPDOYqf78MiGOv
         q4hHYR5QHFqxNyIe6GEwAFMH7jfDQ7Iuf4cS8zWWpfcpXurCYgLc4u5BlmVWDyaUoxdM
         4VRWBl4YX8hufSM9V7VaLZPgGHyaxsxRVdeJYuUtsQD/Hht6JUX4Tr2vIcIlA0B7orls
         P/qx0WTch3t7MQS0NTDeAPs8n3wSOiWrfYZoV9OjlFDoSTd2f8FpoNDCd2puocILZOLd
         M9uDbkNogvLzCskI3WpBWvjhyYH9lRdDdpqjXJd6f6AshLi54L/pr5jB/O7UB2FL+bqQ
         jDrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788360810; x=1788965610;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cz1/Y0DZddHarQG1HOQ6HanJnePLmDeFZMT4+NnMnkw=;
        b=LLYNi/ZB/rYuUYokp8yRmdzpcuSXXhNajuYq3Gbqzo81DqG35hS8R9T2BuupwYxsWC
         C5B+PE/DjNaOypOC/H+o762wEHmCD8JtLcRqcgho+YtYsHO45ymOyp3SLAgKqVd1S5Ng
         mF0p5F3X9yZmFljqclZqc+DzQro8YTqmaYutxNbikNgyf2jW8wGVTcNlMJR69h7vBv2m
         zvQA1AsylNZy6S2j0puo+jBRnAxL+iw946cnuad4ixmnlj+7UPVF5lvcqlBFxfNWDJcq
         seGM5SXNK4FqJBjVnKteXLe82v5wi0iidk1oyTszeKsmm4Os/JKphWdK0Sp/p5xN1NBw
         6UOg==
X-Gm-Message-State: AFuF++nfQ7cV5I1r3/jkFwTMlUqLDjo/zbgPvVM+f76+8QPJrE0oX83u
	c1AjhN0ly8wO9f+vK6qq05e18flhPKmmamyuBbDwplxOum4iOJWBxKN50ymm1fDag6iOHw2B/gU
	mD7WPjSAGoQGaHkbIGLFnW26V13f1a/s=
X-Gm-Gg: AR+sD10COJ+SD5X4W20/nmileNTS+5Gp5AMp9iCmzbHbc9BPxI+X52FgQCDHDnNV5lo
	0WgOSnsxUPgZsM9dw1YJs5BWlgvV1K0r4qRwbTT89ORZdwCwftGodc48YVOXN09UhBCXtXFrtTW
	l0GsAgesUoidcdNK8CtB5N03djfcmaWvaU7otRON413h4OKn0boHYuDiUFVFlugmAZri/DJ47x4
	As5Qk6y5gROW763ALWZkb7PBtSSHemop6ns0fJVg5sYXDv2t7guMRpcFtzxyJR3QfGLCRoy/5go
	9+5FcDvQtXNcl2hdwY42Y+Zf+RraiedP66fHRQetw2CX91l5K/dPtCqdISXaadaLcSJyqizEiTu
	6eARLYnub7ifb
X-Received: by 2002:a05:600c:8b86:b0:49c:d27e:8f7c with SMTP id
 5b1f17b1804b1-49ce5843b42mr98947975e9.12.1788360809577; Wed, 02 Sep 2026
 07:53:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn> <20260827094509.1016740-2-hebaoquan@kylinos.cn>
In-Reply-To: <20260827094509.1016740-2-hebaoquan@kylinos.cn>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 2 Sep 2026 10:53:17 -0400
X-Gm-Features: AcwNN1W9lD2KQqogdRdP50s00M41nMSGQxjnOM7hJApnRWk36-ObH5j8nvh2NWY
Message-ID: <CAKEwX=MqTYpZAwBDOOzdkuo7NP0JFRjFdQaedtrjk_HCNmTSXA@mail.gmail.com>
Subject: Re: [PATCH 01/16] mm: zswap: return -ENOENT when the swap device is gone
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 18E1440007
X-Stat-Signature: sqkocpqg6sfxryaijrmz1pn8duhe3ck4
X-Rspam-User: 
X-HE-Tag: 1788360810-876468
X-HE-Meta: U2FsdGVkX19VMO5C7wCxEohDFWwlMSv/IMaYyxxKIq6a6cDoTPX9JS3toKEspCE8onhEy4BDkOIIibgcQ7unT4XEzuQ5MRhDO/cQEoqsMpwQlHlnYDygcERnsgFrN+hQLl+Ia9Z5J3RrzuSw1HWF0qYDrmB9NOyMUIEeIJ3BdcpyivblhbjPGTi5fxG6oaQNfcjKasNqJUDNZFHM0JuSJOcdL+y9H00OaQLVIqzJGpUm/9BCNhCYVN2B2Z6HLt1Gmb4xQymAIuMmXGl8WdYEPXGnF8ruK73x/OAQaHZhNzu1SEqCJtASaB/ZdAiVvR+kOcZFeaupXCVS6DmxT3Gc6W1/xr5SsR6DpiRZmk8jdatxTzdDepbFxc68ojMSrAdTrDfVT4fPxz+J/3kI2w0MdV/wE2SFSZX/2PYo76Kba9OTvJZIDLVs/ewmouMR44B6vEw8DQLUunEsEA10RSU4+QX/prieW84heJtn0jexummvbphxPp++74IdZUCdUwaZ4ZyxtUk49/0Wy/H6Ny5dPW+bS1HWuVPeHdozbv5GyKmQftXmHlSS00DzfnVdXmiYF7PcKBT5AAmkNcpqqCEKxKgvoXiSbaXBl1hKDEOzuG+Ir1EVQB0tfdiuvU6+YYB24jEUQd/gs6zpyBG5z1bxpUBvj0m1DBFr4eVktH1K5O46pS3BIDGZTMbp29QrK5fhht9ArEeAc/VMAe998LaVnr86DvRutDvHnTVK2B3Wi8bXk0szzSHizbeHDILf/IaL06kT1BJa+K4VHuU8J8XV95D/bMmHkfYJ0OJDYLVEZNmJo47AmTo4PHl8fB5wYOjLh5Tf2JRUEEoLuCidUXAvm+mRNA2J6YE3YmJHWFeO1toQaEXvfXhkaKyWeQDdaua8db3+r4LFUqjT58iiPJTaRt+EqOc+bk9GascywBTBtjIvPEaL9IBHi/HF1vqQNdqWJSCJY6rpmhIt0qWZ7DC
 pwHnFaH3
 88iO74h+DNAO8KxLBhWQEeGlgDDWT7KwdgOayvxf346KCl+xdMUF0YLGVlYLwkd9kRCPKRqocmJTjxySHqxU4Te3jV+Mko28fVehrjkc0E7Ms4PJ8pCq1fHMsfr8p9xj/3eEWowlSFjWSAi370RgU9oqxPA4DIUT63pRjARMTd6I+09c9wHoeUW3E08/4840Rs66d3gSDrGA4QYSQ/ZRbi6CCm5bCcrZUADHpZkHnPwZgreiDv8syCtFzXIo7Cv/29uQsiMVhYO0E6DkSBFXjxeMx8ElEbh7MjtuSjz/1Z0UGzUWHb4s9ecLImzD24E2jA3/xn5AeqCtM3PMnQXh8OjqXd/8J9Pg+Gmg+kyrE0ZYWgc+F6OZxjBW9JPw/hYO5gFvNOex2vBJHRYfD8C1DaUzt+9XlgXnJhCP3SV+VcoJMg7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 5:45=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> w=
rote:
>
> zswap_writeback_entry() returns -EEXIST when get_swap_device() finds no
> device.  -EEXIST is the shrinker's "page already in swap cache" signal,
> which makes zswap_shrinker_scan() stop shrinking entirely.  A NULL
> get_swap_device() instead means the device is being swapped off, so the
> entry is simply stale.
>
> Return -ENOENT so the shrinker skips the stale entry and keeps scanning.
> Independent of xswap; affects all swap devices.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>

I think this should be submitted independently of this patch series!
It's a small, self-contained fix for an existing issue, no?

Acked-by: Nhat Pham <nphamcs@gmail.com>

