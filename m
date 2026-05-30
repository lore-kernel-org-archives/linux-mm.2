Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB612CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 18:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEA206B00A1; Sat, 30 May 2026 14:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9AD46B00A2; Sat, 30 May 2026 14:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8AA76B00A3; Sat, 30 May 2026 14:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8BDF6B00A1
	for <linux-mm@kvack.org>; Sat, 30 May 2026 14:21:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C4D91C148F
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:21:28 +0000 (UTC)
X-FDA: 84824903856.19.DB754A9
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 46D8020004
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:21:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sUbmiMvF;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780165286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sjq61YPS+2EWRhm8mek9VpsMrYhJ4U81YWVgXn/kVH0=;
	b=Bh62Q0iChpcGhuaY+Hz2yNIs6z4aOnrFARZ5dKMggh8iHj1nwF12rU20D6DXH3b16Dk90S
	/CQKJiB2GA5AEWoGvBkdXKUFqpgzBLiQez7vtQaln7vsg12sYN7CE5Ng0E1gak417TijWv
	k4gU0e+ck962TrwycvQ8pMZTOQTIAd4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780165286; a=rsa-sha256;
	cv=pass;
	b=pCHEJ+1AD2DSpVEU9kzDKCUzYjRhxBpEDbGc/hnTv8ijiAAO4eFHOb5nNBKJrKUsUa+Asf
	Rtu59WXn5IZyDltA0qCUhdJ6QR/WYVMkuYmFdgGt3BFITEuLesObu+KdVOIcNnXlNHZP8h
	ha1xNiM2Q12xHhpJ5C5Z9rwGxhcKfHk=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sUbmiMvF;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4904fd4f6aeso72943125e9.2
        for <linux-mm@kvack.org>; Sat, 30 May 2026 11:21:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780165285; cv=none;
        d=google.com; s=arc-20240605;
        b=C0QFHEYEPHUt1AFx77OeT+a0YshFCx8Gzd5D0jSMSBLt9mI17yG4I9bnD++GNgUyhk
         vlZ5wcpfljwUwUjVY+HmvB3V1EbQVhgxFrep+NZA43vhEB/tYmuyZoJV5GE+i9euzpG/
         +AnPglgKJ6Bfhb2u6p9f1jd/RxRZmRpQKVtmR6nTfseI9gX5il9cY5otEgbMzM+lsmy6
         bnwRcXAyMRT1NRYWybhT5+h72PJquJtufU96wapeaUx/sv6lEnBhkGqxv0zINfwI1mDL
         rU/S2lVLK0bvV3inK2EAX7DQrv6U5NeDOaZsuD6VIGJtJyoO7FzKtumNDDxyk5dq3MaO
         VzeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Sjq61YPS+2EWRhm8mek9VpsMrYhJ4U81YWVgXn/kVH0=;
        fh=F5OPLvYHRXLAwDepeot5kkxwfhQgl2YJgegVElxU7As=;
        b=NnupSBs1yHkh8f794srJiZ7jzj3xgJ1XUCPrw2a1byoLXuxW4As7kg6O7NSKjriix4
         cwtLiw5wZ6aWFrzge8BifoYfTS8KzNRSaujqWmuYbgFuzXTFMCUL7wOd7fEvTSShfUzM
         8Vjh/mpzUZAc2b/vBy+2kMM3dGPErb3mCk6OgSYL/vM5uZWepwiYwoUqXCSd76LReoxx
         8TFe5pyWI/5SXS4sWL12od8DrLRQ4Eafa1UbE/2Zkp/2qxyKGtAuNd2QP1EbgyQ1z8+R
         JKdzlRJfr7r9G5WE4XLKY44PKh978MmIwoWJRmAXpnAsSe2gLTcEk35M0IFBNiolXj0Q
         bB7Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780165285; x=1780770085; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sjq61YPS+2EWRhm8mek9VpsMrYhJ4U81YWVgXn/kVH0=;
        b=sUbmiMvFBgPAXz90E8HGrIbmHWqwGwZqNE0f6XMbnrjMIFr7XQXlnFTEjcmX81ADuS
         1ZWEtowSlDfP+zXAfhj+oJQJlTcJQQbSdMXRxTkr8I7zgMf311Hlnd/CbChADJSUwIQN
         asmROlN9wchFf4R+kicEp/VY+WHgxL57IucLuSegeP5Mp12wd6IFqUfmdl/r7Qbt+tZ3
         XSru/+JO7U2UF5fijMqpEdQXEF9quFIK/pC7f9IqzxBPGXZmH4iNxoBtXVDVyypxgsuX
         l0wnayZUsRAjkz6sZ+ihJkqsjbgbdJSnuWTmvF9hxwpXkrLo5qaEtu3AOnWPXPLRB3TA
         IfDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780165285; x=1780770085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sjq61YPS+2EWRhm8mek9VpsMrYhJ4U81YWVgXn/kVH0=;
        b=sHcgh63C2GyXZ+/lApz5KierVN6aoPIyAVZo9Sh0y7SMbrHzn4FkY0w8S2m+OEwRmp
         G3PfsnHW9Nh9jLQIGBZxOeIOiFCOKstnbZbWMlZOZez0kSo2SNbSEGyZZksHD2cw6UI2
         ZsHL8LJjJ0sp2wbimskVuc12Jx8DCu8Zjq+oB+U4HIKbMcWAkrZf3q0M8VvyCXlYBxv/
         BLJ1vRfjtss6+t53peYc8qgO6jVj/y2LK8GxxKIS8vL6ug5om7f5/j+pI2mqGoplFRzp
         qZya0jOjqLmVtTep5ZNhAioMI3vhmP1utAiEqRkWq45l4vC4qZM4hc6M3FUbDfY/TZA+
         lfag==
X-Forwarded-Encrypted: i=1; AFNElJ8EegA0P4D1j/y4ZQHWFfJkOc2ZglpiMSi8PG9ngvi2BhL9HDgSfzBtoQzL6KIUa9F7idF3wLtcqA==@kvack.org
X-Gm-Message-State: AOJu0Yzux0chW3MTU2Qx5QpUEWEfVAjTcU8VerwPMRQDgdYEpeCi5enu
	iU1SM6GO8wFX0o9XsvbiY2IkZ8h4wxgaMJjoJkvyP0FvLJjVo1EkS4ZhbV71ibAYLBwkYlQXhxr
	KepqqaiBYBBlAxBz0aot3AB8pGqFuQTc=
X-Gm-Gg: Acq92OF9DUygSNag1znerebq1XpAj3NxK92X5L+qzxeft9KBZCg39gU3En9Fld7tw03
	h5WvaZ58G0ZQQ8XsaQA1io5RTtJYpo1l6A8G5XY29VJieK+WKGqbkWoy+KYDodOc9mXYEJDJjz9
	paiu8sxVYzFAZhZUrjHorAJunHv2UIyYFwUT5JYCSr7RhSd8sRRrC0DWRf8G2WNDT68M7CyZNMv
	/Xw3ZVnoxzdozLLYuSZ3bix2WzG+dlZ9J8W0mh3zI95Fhx+gbj0zswIWu3xtT3ta3Y3gtAnaldd
	swzwVFLn1haS7TxBlAA9Zp2BRjJSC7P1+PmBuHA65LXR+Wtv2w==
X-Received: by 2002:a05:600c:630e:b0:490:a2fd:e1e5 with SMTP id
 5b1f17b1804b1-490a2fde21dmr70218225e9.17.1780165284839; Sat, 30 May 2026
 11:21:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260527062247.3440692-1-youngjun.park@lge.com>
 <20260527062247.3440692-5-youngjun.park@lge.com> <CAKEwX=O-_OZ8x0UC96a_k+0eZfAE+mWMWDdn68uy1LHRq=JC0w@mail.gmail.com>
In-Reply-To: <CAKEwX=O-_OZ8x0UC96a_k+0eZfAE+mWMWDdn68uy1LHRq=JC0w@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 30 May 2026 11:21:12 -0700
X-Gm-Features: AVHnY4KNVzosVVQicpkWlglXC22bvDfqtlOtZii0IsLLSrbEukjjd4dfH_fUg50
Message-ID: <CAKEwX=N2XcMHN1jatppOk6wnmz-Shab5XMtTtzgYOzRvU_6YFw@mail.gmail.com>
Subject: Re: [PATCH v7 4/4] mm: swap: filter swap allocation by memcg tier mask
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com, 
	baver.bae@lge.com, matia.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: 3o6bft5ujn8yu9s1wwhr4gfnuix3c5m1
X-Rspamd-Queue-Id: 46D8020004
X-Rspam-User: 
X-HE-Tag: 1780165286-207320
X-HE-Meta: U2FsdGVkX196mm7+8Qas+WIcXi6J6KOSF6umPXvNq4jHLuyTLT5tGjpq0Vhx+NXvCksG8iXwRv3exFlasTdlhOGjkAtZARnZJfzeudZLGFy5dfLaJpmGtrCYNlDwQYXl4nZ/TFxm8PZppSVFPEdwL2t9LfZm2ALDIdVDZaW/+G01oTZimVLuFIriJETNLZry3tMmH1wYw6dxvEAmOJa+m4fDLrSOZSPx7o4dJpPZSLOsy60EaCbWxR/FzywC/idG1Jz37qBRt0O3QLxmEM8J6OeF86Uq2QKrNtfNeH4buzogAKBPNvaF0blLvCRJmjJ+/IQv79wIgpZ50XNidmbBy2BjpV09gxzpmA5AT2ST1iDwLOZdFxYG/hwWx1M+uQD9f9Dl+i6Ceb27kJ8cdYjrFnqq+6RWhMEzeTksPWyBavJ5I4NPkdyxGuIszcC2GlT6g47TbXG7a2/rIs+K5BUCcYI0wn6T8A/erWGzxYiftR1U0rVy+gigWQIUkjTt4qGa5E9VrSbw583ZfS6KTYZMnYGtSqPccJiUzSKWrKjoxF3CaLS0LDtgFsLmB32ZIvbuy0UDHAQhfxlVyDcSN3ohwbiURy0YdZGErzm6ai52gCddRpc0EbProOyanEtLA5XtSGsBtMKh4p0wHONUiLeno03Sa0E6W7tXwGVONgNhkZmnLD3AHxELWXxH9BlYofYu/5pd4s+ZvC9Jg/OLZW1Q1MW6hxhKwE/4hCpimY7ryfmvk+D8sFIPpUrI1Nlh1IXww0KX+KzXuLkxSWOrGe8UD+1YQJDDZwMAAe11eAmtY9lKu0le3MdEzUs8JD3pDSocdkWEY95KeleHHfCpvWes4Ko/QoREenRm8yN8wV9+fNVLrDc1mTGeOnI7yoZW+AIX/l2W891HrqQWWNhvZxij8qDQdrKXc3YLSwxD/rwZLWU1/UDOJvXQ6zOGFZoVwBa8J9jPQeU59s3d7WlgPhB
 VVJ+ViVB
 GVFjISTzCbUbQkLKvUBGQ+oQ86Rqr6JYPWxsqBd9CVtHOVhd70ztWLZCOOgG8CwxgfyGLJMizrxlsN+jVjMnwkbbXZAQkaXhzHrTRmDuAOvKOLyo+6bLft1xllUh/QzfvDANInvTbBE5eNMohD7eruPg2INnJwTV/enSUzK19Nrj/OuBH6LZFlEEAP2QOQiE/ZGA/5ae8YkiFgDkPRg021fs5hKxmvv7dMMrYs6HB46me4ju88wx1tQkyVKARr+JL96Eht7JfRjmx3z8+E8TTy1bBmc+CxIVWGcBxe3dq+TNDb11H8PaO3mCe/OiOflnd+tDBMREeaHo1TrtQX/05OP5TJmvfx3lLjOu6Yowv2CFAwnoXXRj40LExuTrGNBMdSss6y98FeYsrGNhuWqmh6fc0/FzI5UEFEDqgQBUW40YgmSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30, 2026 at 10:51=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
>
> How expensive is it to add per-cpu caching for each device :(

to clarify - a percpu_swap_cluster per si for every si.

>

... or for each tier (assuming devices in each tier share the same
performance characteristics, and could be used interchangeably?).

Basically:

struct percpu_swap_cluster {
    struct swap_info_struct *si[MAX_SWAPTIER][SWAP_NR_ORDERS];
    unsigned long offset[MAX_SWAPTIER][SWAP_NR_ORDERS];
    local_lock_t lock;
};

Seems like 4 is the default number of tier right? So the extra
overhead is just (nr cpu) * 10 * 3 * (sizeof(unsigned long) +
sizeof(*ptr)) or wev?

