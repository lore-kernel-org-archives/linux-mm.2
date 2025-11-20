Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1AFCCF58D1
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 02:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8BEB6B0024; Wed, 19 Nov 2025 21:19:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3CE76B0028; Wed, 19 Nov 2025 21:19:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B7A6B002A; Wed, 19 Nov 2025 21:19:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AEE0F6B0024
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:19:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16ADB89B5C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:19:15 +0000 (UTC)
X-FDA: 84129378270.06.57AEA4C
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 27D67140002
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:19:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FeBywbMP;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763605153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fG/2l/sjWGh3NEPjE+Aqfw+mUrUlI68rlAeABXvsz4E=;
	b=ZHYrgJ7a7gk+ueSzpjrJ6D5v+O8wmmf0ljJj3dgahla9dbqOE3Sv7t892rnAIJtYR05ju5
	4eEN4GVw5n+D2pVKXMfBIU2Z6/agQqOaOIiUTUqnSeGE79iUPBUvx0l82qiolIWldO7p6X
	4p9pfeof7B2ET46FRTVAePpRYNFGICQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763605153; a=rsa-sha256;
	cv=none;
	b=ThdGOD0SIKduUqiyCqDSX94vurg6Hbk4T5HHW2wOmccfsinTiASFq7Xn/uGGIYZMQYfACQ
	+xmI4mkSSmS8elFU0a26IqPPST3/l/IppKRsWi8kmIwH4K2lunuHymnh8rTmhj+2pGlbHw
	6NUu72YibMN+AfmSKgJATkfQRhlMRIU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FeBywbMP;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b7636c96b9aso52283666b.2
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763605151; x=1764209951; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fG/2l/sjWGh3NEPjE+Aqfw+mUrUlI68rlAeABXvsz4E=;
        b=FeBywbMPn1WtxBRXp3qO1NNmevvYHXsy1cKB0czD+bd5bPemerlxuRbPvhljPxoc1j
         9TdwJOInuhx7oF9Fh0FW62tnGntjI4OIbnzC6L1CO0WoL8ZN5Ok//o7s83ZmpW++BjOf
         JM3arq4pV1yE+TICi72tO6m0oXEO5kDeWRnoSxLvmM3APV4af5y3qRXiGB+ufbplgSaT
         WNh2EGe8VO/pxlXJHG7cZBNsu6eBrRVqTp30oSzNayG8aEwamEax9oNaT5WQWhR/Wo+y
         lLPZb4/nP1IhVLh0PYFrR4GbygiTq090zwfrqGjkP5iybK+Nfoc9UadBnhgPGiSBUuxS
         PdXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763605151; x=1764209951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fG/2l/sjWGh3NEPjE+Aqfw+mUrUlI68rlAeABXvsz4E=;
        b=IDc5qfmuhMf02eBb8P+ElwodTqcqsarU/R9tuiliEHlo+46wwsVRjyuS1axAK3ODVm
         TTpj0898XUjpIm20Noe67Lan9ZseFUUF2ZuaKOU1+NLNc0DWJTudTQzy3AR7+GRYea0q
         cexAac5TxLJg0JKCKYchcM7mZCEliVbLBmFN9/L6wTE38N5oSgEXyWbqvbeWN65EMUTH
         ZL+clAxdSOlbPnX+z7IrRci+FyoyNkTQyc/03EpFWATGU7UEmmaOujp/66DGpkBMlt0q
         e774uj6C+RLkVoiTQhQUU0Xz2ywJU5Dls9pibz/Xoht70rOFOFMOjTF8cbMzB+fByUhe
         bq0g==
X-Forwarded-Encrypted: i=1; AJvYcCWs4D8f+DQWnO77z3fwcMB3MhpRNcXH6yHamoHFA/mVJJxGyrahPEHw8h9pOMsd+r+/nvY+sPtCOQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1rHR2i3kr2NqN+PX6QXjrWbkqQGPj5t7u5Ek3S+SSvmZ9BdRB
	0DY3w7I/UWd63J7N3+1wdJsJaeeAQrt+OihRYBpNd137Do9/HFCPlU8mIyBUDJoJ66gu57hGI9u
	mNVDNgEGKUT8fXEUuCTrvIhNsDMXvlqQ=
X-Gm-Gg: ASbGncvc4qUtVe+afCCto+N2fuyh0ybSeL/LuSvHCnm7L45u6JVbYs/JlePDuoSfCGQ
	XfE8gtbWZbRAF2JhKY8WM9W98+L+tfcfzBT/T7hygoqsccRq0/+SNFDRcCf+mgyTkKzJ5aw0AGe
	mrWe68oaxlM8PrEZUSxEArLyCi4wa9E0asuKW2b4FmVvLfGbD1Zyvhb9QvpSI4mkw8xEjgTzbLw
	vb53FJ2k2GLj8nGYI9Q1BrGEokGzny0hZWJDqKvU3SxR9YtjFBVZvswDJ7tBP0EmnV6mH/6qz4U
	VMANd1nHYw7lHJLIdaBVHZvCZ7GbOsY=
X-Google-Smtp-Source: AGHT+IH8PHlHZ38DAziNxg+eG55H8k2xBxrOurZ3SBbGYPORCC1wZsoJOfBdt60gTAKu3Nb2q2o0oA2FTbBIyDJVVoc=
X-Received: by 2002:a17:907:a893:b0:b76:36ee:376 with SMTP id
 a640c23a62f3a-b76554a5e98mr135808666b.54.1763605151305; Wed, 19 Nov 2025
 18:19:11 -0800 (PST)
MIME-Version: 1.0
References: <20251119114136.594108-1-youngjun.park@lge.com>
 <CAMgjq7CgwjqE9XVy6EaNe0XARYOJsOER-Ch16wuZxWfq4EdFJw@mail.gmail.com> <aR53i1G45XAqCzBd@yjaykim-PowerEdge-T330>
In-Reply-To: <aR53i1G45XAqCzBd@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 20 Nov 2025 10:18:34 +0800
X-Gm-Features: AWmQ_bkzD6Txov4tfJulVoq_1iJ7YTedPTcR8qX4HA9rM7n52SkyRgDg9BS_Ju4
Message-ID: <CAMgjq7C_ebrZv73VNBk-mhaSJwQXJur96R2OdW96YCM7vtJkzw@mail.gmail.com>
Subject: Re: [PATCH] mm/swap: fix wrong plist empty check in swap_alloc_slow()
To: YoungJun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 27D67140002
X-Stat-Signature: yhnodgniet4zzrufrzh94cwbe4dmp8rm
X-Rspam-User: 
X-HE-Tag: 1763605152-911022
X-HE-Meta: U2FsdGVkX1901cDlktEz+NmHeg1mg9xDDFbTHiCVX49aULv36KiaSsMGtZgDAPrIMhYyWgxt2m3wmw7Txc74zyN9Lzl+etw06nP4cgneXMr4AwHpiXNaEzIkblvAznes7i0diq3ktelaO/aPkYSi5ym7/0NkKTJeP0N6AA/uKulkwjkyqxBBcFeLjH7y34U8FKwe93fSddckAOGj+mVwehV9pKSNDO/SgWhcXqsPUr9VxjVbbnfklgeQfZLg7S7BVca2fPqCfvSWNuLS6NP9M4asGBEJaV188wXFF/kcsOpTTWbRNEYQvjLTBhRoeYwD6hxMr5rTXGgq9q46jifHFxXwtZRfiSwEaWClOV9nuiy8MubXcePae+CBUqcOxyRKCyEiwxe28y88p8hzOfOIJOotNEPI8zmJMDtCvzs8JkkeusExLDYXcqc7oj1256SmglKAEMCPn5tDzBqqrPwhXTu35TJeLvSUYNIk/QTlgeMCcjqe4NdiNyxJouDHMeHN4k1yHTSnrEcj8H7TYFvp3xvv7QAj3pohJQXv5PuMCeU/Yf0c8UvGG6D4qwOnpfQ3oz5QBV/e9FoHHUM2QLjDDNhgk20u6qSIKmqMtxG54uZSTjWqWIW9EHCH+IaRUSqssOcYDpvyTNpyWNdei5a10+fC4W3G3khRW0vBF47RffjUccPWdmfU52GCpIHEja4JK2OzIjVsj06zi41LKB+2x8ptMkb6PlS2Rz6FlZ9WxmmBBc1l1ONv/+wn3EnKhMAx2yIKH8ez7Q9+qeARMUgbNqEMfVv3yisM4BrhogLDk99CJU7f3TVoiTmMzpl/so2CkFrkd+OA5zGqbsLa9GJDMHOyZeCCHEWFwEvMORmxzvGlKswyCgwNGT5qiCD+Cd8uJ2/zq5WLZs8iGarhRJZkTkzO77TNaBkvlq0FfHLT0T4z2MLTYucX4JwKOexsjTSPsRdDHSqfkt0Y1cUWu+y
 IZl9McUA
 gH5fXvLgI8Sy1jTrJLFm9IBfU5i7f2n0GrRVqsybN7ISNHeifScg9+e4WrYn3fmJu7kKFb+rrv1lrn0lxAWc/BT/h2kRX9cDPLl9jSyOCWF0xw+mSy/YGY2wW5hTVb4Eo81Nhg81vnbXjLxsn9AU9/UkNTGgfbibAe/URns5gdB5v37bWJtreeIg8liI0sEd5X+zedKiCZ3u+0J2Xc0Vh6Gs/7WG2kunWQwnFaSBpI3bLj///HX2gPbNgLWs+wn07Dzp2p8c370TcpB5uVldVsYQyAiYQzXTPuuiOxNPStJR8LlsYrkG+Y+01UMvRlE0yMtvr5yBDdpYyGm24y4x+Cgsz0lAiC4Ut/iFrbcKhA639NupXvKQj8F7bywTj6pKT+113TSOwGbjMJz+yzW9D225mfoOjU7w1e68n1kHul3N3qH7eps0+w4X+KOKJepgSiwoEgySH/Uci5FA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 10:06=E2=80=AFAM YoungJun Park <youngjun.park@lge.c=
om> wrote:
>
> I've investigated this further and noticed something about swap_sync_disc=
ard.
> During iteration, it doesn't perform an empty check on swap devices. As a
> result, if the iteration exits because the next device is full
> (deleted by plist at this time), the
> operation(swap I/O) fails even when other available swap devices remain.
>
> Should this be addressed?
>
> Best Regards,
> Youngjun Park

Actually after thinking about it again, swap_sync_discard should be
looking at swap_active_head, not swap_avail_head. Changing to
swap_active_head and also checking SWP_WRITEOK is a right fix I think,
and should be good enough.

