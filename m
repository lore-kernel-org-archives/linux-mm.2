Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ABD9EB3637
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6F7D6B0160; Mon,  2 Mar 2026 16:12:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02FF6B0164; Mon,  2 Mar 2026 16:12:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A300A6B0165; Mon,  2 Mar 2026 16:12:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 917106B0160
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:12:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 482BB1C2A1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:12:52 +0000 (UTC)
X-FDA: 84502372584.06.B7FBC46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4830714000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:12:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ujg34ewx;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772485970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wmtf7AALP+rzMpTuXQp03PH+6JPrz1qk0oYPfONru58=;
	b=D8mEUG0Me8R+FXW7b07dH41s1SBCQnJIh0tQKfQR74eD7rBWuyshClGQM6s5/A+x2oBdTF
	pP6qhS6zGlFpcO/nJiCEaMxCsa8B8Fo1ifENIZHLd/wM7zOnEuB6zhidJuJQjLGlN4uA78
	dk6QVPDhRHZpDQ8Jiaay8809fSDT6nI=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ujg34ewx;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772485970; a=rsa-sha256;
	cv=pass;
	b=O0vkE0DJ1FTAzvnfSb+dRYuPDJeG75Hca0W+en1srzMzNRqWrmJbMKQJspk4cfmVxJRmzZ
	y3aBESNRIFY2g3ClwDcVt/NIEvuMK9EAp/Eys+3v1PhyeR+QTnKhmkBC6h4kL41zZJ8K9s
	bRCZ4M9YwhR8xDW4yCbu4Rf0Vd7qK1g=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso42529905e9.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 13:12:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772485969; cv=none;
        d=google.com; s=arc-20240605;
        b=XmWxsFK2lZorTaxmtOaqHoQbjenyQHFKJFLVsCb8nH8VBYXGldDNgW+TO3oiP8nhvs
         UXKX4fUabedpds3kSegk5bf0uSFcRiYysn3XWgstYqjWQeIoOv+VWeDHVplfgDIFAEQv
         Py1mBZPsLwmWPMqLd4BI5Vn5+EtHct1rxYeYJVlPXI0JuLrFag8h5/8HD5dJsMZXcYN5
         F03kIIHv0IiJfOQ9hAK5Nkj3G22J60Hftkv12Py74pTPpKQ/BaQWlEc+WGtdnyBvwJFO
         sFtKovek7H9Bfj3tMFvtjD/XQBcDaE/Bs8s7MrWegvmdOGOrJBv8/Q+RzO2htxpUiPQa
         YFug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wmtf7AALP+rzMpTuXQp03PH+6JPrz1qk0oYPfONru58=;
        fh=O+CE7iRGKkb/ak1ZvvOjbFXXY/p362zF6Vta9wjv9FU=;
        b=KUwaUzBuqCzu9sQTaYA831En7TVdARjSA66F8ACSpYzBN9Ue8WJgYuKS3Flic2tEmL
         j7v82h0RYP5FIrVlP2eN0RVgmSUK8w81M2fgkwO9ejY2wtdx8OOS3bTxVEo7Ul8V9bgF
         +SNz96131qoGxljuUR6tUaZGNRXnwL6ATEGVPGRi4F2e13MxIOlpFY9S5Eywy/H1TKjs
         1FICpnaAttAxzy62vo/shAM7Sz8N2GHfhkIDs0IVCfgR10VNkSQyzotKjq6mnS02oca5
         5u7BzARzwZvdlednt8pActWo7P+CMI60+ckJFO+yIfLsgTPg/JuvZzkw/6kkoqA64Oi0
         pbjA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772485969; x=1773090769; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wmtf7AALP+rzMpTuXQp03PH+6JPrz1qk0oYPfONru58=;
        b=Ujg34ewxhQ18sWgnuR1Ml82IkTtyqiKfgIGHj21SzNhYbYnipMRNrU/5UN9EAjXRov
         tqlJMDiWNPnfLWgduz1ZeJ65+t2krS+aZAsdVk22qSmkd1lUtECHmfB5r2WsTxTImEvS
         8G8ZDipii+GX/JI+HcChO0H/F7ZTSyOg0ld663NZfLZvCPHFoRHV+uUewXrb+xXiNFPC
         YIGoBT9Ap5I21tZSv2XhdplQ68S3SitIfQZ5vN0qHEVGiiYYutFhI+Nbb/+cqzO8SQg2
         V/ENPheLkLG2MweCEXozbqurYBIEA19bejQAMhTCHcoyEPJVkPWepH9UHovEZWOU2ddt
         K9Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772485969; x=1773090769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wmtf7AALP+rzMpTuXQp03PH+6JPrz1qk0oYPfONru58=;
        b=YQIldxA0C221a3HpBBn82tpCrhdgqCBOalkHeWcGccxOLkOgYQOcybMbs3zFMPRROa
         AigjM/t8MtcSgu39heJU9eNR/JYuKYqdg1IiDYPaMxmhoeeiwcRtuGEQIqn7LCOxe2Vn
         R3ZRFGni3mMCQHor7A4EpOZQvKK5AHMcqRUyz8mgUdYumlCkVixmVEjBdtfMo2hCLLMN
         4Bp1zsB/3iE6cgMFRSpWoXUBuNryWXTqkmunIQ4tcDfe3s39pfuHsM/EaPztzlYprLOO
         1AGgxXhRXJWcG78JQr3HwvrPHJ55vvH98rKybC4TN7GA9+ck6oWdKSpQqPk36FjM1umb
         Ig8w==
X-Gm-Message-State: AOJu0YwOdUylVJJyA1K4FMkcMQ+YxEHPHzBaEJ9Nu4WEqCqkTdYcwOky
	O5GptSElBljWYVvzh4U9/bRfyVO1cUpnKzXZh7JIkAKcON/rbc9YDqD8GHtxjaZADMjK/qxzuaB
	NKYDfH5kKWniHA9hDptwKHEmoGfnhPB4=
X-Gm-Gg: ATEYQzxvlG0YbQR4sPpG5fdi15sfJ3K+rfoBqsX9RkgPxshNL/np2T+TZ+mN+0Pbtpe
	a4983oAZ0V6kdZtLFIS1snW6kKSvP+eCmdObF0wohckNiywKTvQ60dAiLBWV4opImPB/mrTwxE4
	W2R3PNu4LLlAT6oVkwmcAH01vossnxv8JyZ+jeopfizwTWP1NPoYxPjwlMBYStr8ZlDMs+H+RPb
	fGDTLvyzYphSa3fDaT1mbGaqdYYhGlFf0gc/hI7XeRoNfA8P1FSDmbMt7Zu1r4Mamm+bhWM327B
	ZAn6IIEx2tMxZGm0QLROo0c+ZdpD6E12NFQ9YCg=
X-Received: by 2002:a05:600c:4fc8:b0:480:4a90:1b00 with SMTP id
 5b1f17b1804b1-483c9bead27mr236617435e9.20.1772485968549; Mon, 02 Mar 2026
 13:12:48 -0800 (PST)
MIME-Version: 1.0
References: <20260302104016.163542-1-bhe@redhat.com> <20260302104016.163542-2-bhe@redhat.com>
In-Reply-To: <20260302104016.163542-2-bhe@redhat.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 2 Mar 2026 13:12:37 -0800
X-Gm-Features: AaiRm52tOGxqsE93jlX9X7NIgKof-T-xhcUgmHUbgfNXqC9QqbH_pUdUjtzKv0U
Message-ID: <CAKEwX=OZwnA4gXGWKMHtby5rTnBAPP3hqFaCEkBKzfFYfaD0VA@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p6y4eny5fyh1amj5z8qqmi69gx5agdrc
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4830714000E
X-HE-Tag: 1772485970-438587
X-HE-Meta: U2FsdGVkX19OUQPyjtyVHIvRwM0JbHfLLV0StaVjpCZCi7sUiM3R79zivF0Gz+YmPAqfdjHcJJLN2JE6LUV1XhcuhkkNVDNedN1t7T+9vipvYJSdjaJ1yx/Vh+kUhjcyjRghz8+CEIfb/mkgxmlz+5fH5L5qCRAdeefx4ea8d222EjUK/bbeZjYb2/ilRWJp+zbAK//mZJWfROkW8kyXy2fIQ3DuKW3BgVw9eV7PXhLKn3tK4EDYB9lZH90SLw5HYbD7hspb9XAsyOExGo1/dUbaKHMnHc0TS60iRZfVLb8bLlHJCwyTA7X3JvabCPGwax6C1HMdJUqBC1Ltp4zj92JqqyfNy5Dau4htMX88lMS91Q0rXglPKrJG7pdy1uJTQvoVmaex1WiM8nbUCO6kl4ctk8VUxN1tFf9x2ewyLo4pw+WTwmbbLgggXNkSVeXLv1BY6WZ1ETj/jRleXys+ihfyM7HZgOwAwDRddgMW2Ee6uuyvvisH2LbMp6NzO6Kqo5qPhqAv0bkKAMLohoe/+vdAZggA+pPS/rcRbl/a1OzrcYLH2ZZ/FvmdPfya/XoFy9jgdixuiGUqgEiRPf9LCb1sxPUfq8E24BSgGuYnE2XMXGJZdGxqE+nkYYUp9JFmIrzrfq3HcG/Tt1MefiCTGeoKgnd5rVsNFuxSVR+9leYBxLskwdZ7QIfQ7H2JF1rsVl9iB26IRVj5UmgY/yN6Olm0JmRREW/zH/1ZOPeD5i5evCdTtSzQQH6h/aivtG8JutluQhNKBLO4v9CYBWT78aCHKfcBxTvu0pjXDNPIzG7yXzZlLcIG86hwtJZzmtcP/bzCoWqLGsbKb+N8XP92UttLeB7e69Vo525rAASzpGHEv+/8lwUIRArQMWjPQdhJqQbFXh0t4F6pT8IjcnkY/BMB//xSoTWrzJGG3ksdjCW7vEqiM551JaWFCQhSRPaPJbKNbDjoJo+FmVzCO8j
 Ie7ielcW
 fsduX8E1m4565dklbzlUvbM70vBsR6UOmSBnNjnCI9d0upRxAIm/YjEB1JBk+dje0Q1JQaOdsPdMPGL5O0QhBhyYiIX6YqF+Qzky+5veN5PVlKqpBmDhaHhsh9ebMlj/+lM+MsjIn7BhcQK1BVx85rznzidiivYvmOr7y5aBohnVFZEmaayw14nKJkiQ0w+F6n5oIrBnkNyyFqD8RhhaobW/XKVIdc1Gea1yhJ7K/vAVz0Nv0XO1QrhAYglaxjmjZPzgZE4MtqPdufhOzbsMMVhWumbqnbnc8YbuPIUT5mnQqqaqn28E0+1zj1VSe09DBB5SSoF5EBm6Dv5+0oQ7bLu6gsme/62/rshsMHpcMm+nT3d4Xs7sGh/dlWB7r+Cub7KhbReOyz0iYGBVLqtYPe6L8X/4AVrUduAHI12zrOu9zwvyEPPJxxLtynRLliZtWvocqCMXv1U8v085i2CfSR7NugN8FdIumer6H7kDxRfFn1cazmSLF5mcXv+1W5WMPNXuZ11fZmN8va+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 2:40=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> Codes in mm/page_io.c are only related to swap io, it has
> nothing to do with other page io.
>
> Rename it to avoid confusion.
>

I wonder if there's any historical context here. But regardless:

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

