Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3928C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DD586B008A; Tue, 21 Jul 2026 14:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68F046B0095; Tue, 21 Jul 2026 14:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 531196B0099; Tue, 21 Jul 2026 14:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 12B546B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:58:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BBBB12029B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:58:37 +0000 (UTC)
X-FDA: 85013695074.09.52726F6
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9EB8518000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:58:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RiWzuM7Z;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784660315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ph2nrzNdOcG4O+6sViE4/GF9/J/wGPGKSUt3l/AEY4=;
	b=pNUhg9wp0GE9iUcckJRAOvCNL/uXryrVGYccOtMm4urYqaMAJiymbhsHSTfM4FIYE3JAl4
	fyF4Z+k7EAI5rzvAu9wLJogPSo5NKO9BLA0Q9ZEgoLo6geJd8OVOxawVGxmZjLV+mvzEsQ
	atWdmE0yv7GY2kmbGNDrm4Auy9vHVEs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784660315;
	b=KE/Kp8q78g9/i289u9OhVoZV0K4lrPCilCjvTsQm6f82pp2rP2WSBh/eQYXb9f6rIgdiEW
	VYGQX5nvVL+4EhKC/IJQHqRsl/Lk5VqJJ9vQ4rbMTtwK4/AbQNRuZlPKeSOglMPQAXfxSC
	MgQWSvfllXZYk+0VjY6MpabCPbamY5U=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RiWzuM7Z;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47c6e9a694bso6630890f8f.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:58:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784660314; cv=none;
        d=google.com; s=arc-20260327;
        b=MugSvHTJ//X10rc32F0MmUn++PkuTyEp9vGlO//5LPuVWDy3KJ5q7QTsQuSczsqzkh
         uJYOo4FJNC1bkCmfjQnCj3IHKoNvQN4u2OM7tF+kmsznIkHdypJvHL/Pge32huxzQxqg
         5RE88XPJFng2MVUgBful6liU+vEwfHVgJTg8ETuD0iS0FoUe98FNy10a3tQ0NbPY1+jn
         oPhlbUbToVZgwCiezpavFLWRpwqhDeHP1oOXbQ0oLK8QHdrCAdsOABgPGVKmE6B8gxM5
         U63xxcbJzxoEij3tnfIgDpw/AzSqBrEcVQnZWO3Qn3oezkS5UfRkrzM34VZIFMeEq432
         giBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8ph2nrzNdOcG4O+6sViE4/GF9/J/wGPGKSUt3l/AEY4=;
        fh=ty0ZxDV17Icl644pjYdVX6yeOdkdhIgq1v6RJeceVVo=;
        b=nH+vJxATETH60DRHKxZjr2uhN/qTIznMW+OGD6qDyuRGX9pu5yoHU2ZgP31djZeZAL
         TQe+ptUicg2VlFxgPvwG59xumBPx8c2IyHTmhE/OLADq9tcuDqwh6aXN5lEIHif3bcJJ
         PhhD2rouza0Dd65tzZ10UhaqtjznnBCadUXMcTeUEmlGzPRDcgNNnxmBqlZmJUf6UXSS
         RAnD4FRn2G5OaCAXNseztuqZUKtRJgXw6J0CqRKMtXo95wMku6dpT76dBpccYq9UqJ+p
         TNu8Yh1PAO7jofAJRwlBg5ZERws4fKGCOSHdUXagzHcSIRMATVF+hJWO5JxuQ1IfSJ7O
         E+jQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784660314; x=1785265114; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8ph2nrzNdOcG4O+6sViE4/GF9/J/wGPGKSUt3l/AEY4=;
        b=RiWzuM7ZcULnvUMrHWIS9BgSfZzEV7Lhp2+jKeUzlWr6S2NjbR6/2OVMyOmN3Ob+yh
         JqPSy+LoG1qjLyGVEa95Xgn43Oq4DPKARgr0hJi4qFsvqv7B3Tl/lToXxhgYhg/Uc97G
         FGBfoVwniLI8MCH/DlIXHf1CPiCy4U1iUVSg2C84ALbZiWMEtx41frG/U3Xaz8Oq5Duq
         R3TXhAY+gHIhIjbAUV+Tcx/gbrtgsuqY1MSXxlsXDXijLziPu902io7Ym3JYzl1XwCIc
         oTxIr5Gy0T7hWlWS+d6Lcmi/fhZMwZ3skUayp8RZrmkhCu3gW+9Gm54hv7nX+Bs0Cy7s
         T/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784660314; x=1785265114;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8ph2nrzNdOcG4O+6sViE4/GF9/J/wGPGKSUt3l/AEY4=;
        b=QvCyzHP6j8bBS6r+FlF6whrNwgsfs8rQ8TklPUgUH96jmIdUY+2/fJSzzwSZ9BdTqc
         5AC1x3LXq5Tna2BiIiTaTT1gvue4WE7jgtCdo4vBtXRtPVKXtLH0dR19A+3A5UfHJ3pL
         esKx5ZPkjVKh4S+l86Mjxru81ajQ/i38cJKXIkKZshwqFsp/2vbOpiikz38N+Iw8Gizh
         Y8A58VHx8qJ6fIByZMNciK3qVwxXo148sYk45NG/l54RFN367/TFh5g/29PyH6gDaO4i
         4b1cSR8oqynKxUY7Ba70P1K8F2jVIwxTznsCg9LvEWJp6r93tMlaYoakgznZj8mWURu8
         44WA==
X-Forwarded-Encrypted: i=1; AHgh+RruoYLG6MeKTJ0GQJuCVW6YxLpMFmVjLNLTOZB2nv6nEBjm5izS6Yj2pnIOenco6Ca39mxjkfzdWg==@kvack.org
X-Gm-Message-State: AOJu0YzgxnM7Tw94HN+eYmlQjqpNZof6scjcXbfWU3TOWpAZJc3Py0sZ
	ja4QtKgHOJ4Uog5/SZJtzUrYWmB3XfayCQcwPFb2gAkv0SNui50ax5/8DKuTwgnlr4Ye7HSwksR
	MQxNvYzpeivSbUbL0Y3REF0yINWHY3II=
X-Gm-Gg: AR+sD12hq0PBknMsoo+cjhhamsute8BNycljjMFYp5bIHQfbFhxwoV4V/vevwUIYSLB
	eFPgngO9OWFSerdExwIoUoedFxR8JgADDu527SpHa4kCmUmpxyfhsmG6aBQHTKLVv889IHbm4X1
	g+Atnby+TBLMPOQwQ/HvJq3YlmJoL+ThGnrEGQb2oZJsKk0Qkb7UBwi5f5lyLPzDMgrOe4n4tWs
	w+6ycsouBzThLcvjtiPSHKIXfPonVf/XmUPgUYwa1g6iUGIpO7ElqYIod1ROCq4bnUom7IBmmhC
	1tL0YjqEdM4mDgXXE97R+OJ9YJ4U
X-Received: by 2002:a05:6000:248a:b0:47f:4ccf:1386 with SMTP id
 ffacd0b85a97d-47f6233fc15mr24457458f8f.57.1784660314197; Tue, 21 Jul 2026
 11:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv> <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
 <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv> <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv>
 <CAKEwX=Pm_C6OD1jAo818wzFVVhLwgVFu-4bLdNrmUZ01URpLTQ@mail.gmail.com>
 <CACePvbV62T9LA894vTXzBZQ2PNh6iYZD7eH6=UjeFSWhUW2aDA@mail.gmail.com>
 <CAKEwX=NXJ1LKQOA8Qy_4YOS6v+jGbAJnbD5K0=jNbgC8Da0iKw@mail.gmail.com>
 <alo7tuEKLjA0IZQe@MiWiFi-R3L-srv> <CAKEwX=Pm2=fdPYE6e0o8bO2sazACwGhKCpstii-P-8P2AxWGDQ@mail.gmail.com>
 <al8ohWshSSZ64AtT@MiWiFi-R3L-srv> <CACePvbUBfut0rjfK_4MTGrp09KHSXxtU7neS7O_eLNW8co-DaQ@mail.gmail.com>
 <CAKEwX=Mv2gMsZ5FkfmyaNofz5CwhSCipOtWfax1oVTtom+OoQA@mail.gmail.com>
In-Reply-To: <CAKEwX=Mv2gMsZ5FkfmyaNofz5CwhSCipOtWfax1oVTtom+OoQA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 21 Jul 2026 11:58:22 -0700
X-Gm-Features: AUfX_mwwwW0L-QL5XRMfuuDJO84_QXW3zyaxzyWWcVtf1T9D-tDz0oMbSFlqVQ0
Message-ID: <CAKEwX=OJJBRzyHkXdpmsskzRxMqoYrwbA_KBWSYJ+yEmHtKt8Q@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9EB8518000C
X-Stat-Signature: o45c7utda58u3fudmpptzuiu5axeqpdo
X-Rspam-User: 
X-HE-Tag: 1784660315-99557
X-HE-Meta: U2FsdGVkX1+tfAOuyTgIVFdEu5Gwda8phfyCtVXj60Z+PLjq5ssw80RBsggtJNS0YX3A7Ac3+rZfY+UKHPFwupSacA+xnrYEMfrsKKkXlI87WQi2ZxlkQtpMHl2pTvptsftXcUpczlwx2T7VGGWeIX5CnQ/MP1XMUvcKnyt5H/geq8li1jns4XpcEJuHmMO+0EiTlNl79aWHOAjlRS1t22NPzT1BGkNTc6FWZJ4CaoaCG+n+ey4gwUQBAFqO+3SEY5Qwave7x6FznyV9tOARCEpv3LAy1C0tDo0GoDXjnojHe0dEYdEz+TMRR6aXCxjgZarfsomIo/t4Kvlaj0upFdiDDg06DFFCS2hjs13XA49Tj/Ea1GrP5cIA1GfvtZaiqlQZRg8nyQbKpQAjfqctfAAh4cJHaVasGkNBmlbU5XdHO6akQ+c1SOsla5aPYKUGsh2mQZzN0XIH69AgilCusviLKfsRHd9QhDD9W5i9+/Q7mcCMfycpl8DYKnfrDVfuaPPtL2U1HTUYPRHZCOOx1O/PTJYeIep/kNh6ScDvW1O00Uo3uJ0EouGk+iLYdouadG57hII3nUrp6YJakNlhKnr6MHnFVpjgkI2HcHiLTek/zasfGDk/RE8oHBbOTuEIdsiGb52MPUNvcv0Gef1fM8Bm8xswiQBkJ7wIXKGANOdK3o9aeN3wAO9ykvj55+sIgULtmrf+wr4d0GQjF2h1wLDyElvBZ4Mp2pc3vwpSbxvsCMOHN2wHY2X+lmGmUpMlUJh+b/+FR2wxaNgX7Jog1Dnp20Hay3XWf+9otLBfyQ4lLfrSsnYjbUWBn7JJTNnlV2a9NSRCo8B5CYSdxr4jOEwqWD5Cc1Iv+rVDexYeBxzm2gxE0kcAaQ64h4H4HyiHO1hm8kPPSAFrv1Daok6yAo7YGRr3pOksmrRlq7uhcxSzky0zu3W8BvE7Z2SQMeQFTlJcIfCy5yWPuhw2d3b
 CU9TLXw/
 LrnEfSq57yL+f1+1ebVSvNBYgF0/5IpoTSyf+wm8LewrOdkqmp49yXE5qmu/ZPvtx5q7wID3w3woZla900FI1HMjSe4hBn1icFFCSBa9NJtunU/Oa5HcP1pMt5YYeAM0H95IZJRnMfW7GhkqEbXZU++USIknzvKbg3/coauTETYSKtsfccbgOG89ccKanF1z1OKrp65rvaPFIDiJPd+wPIYDFqQw5uSHpAzvgCoDqgLlfE4VjXbuafhvvWVK24JzoVtmaQLPm0TDIFXOU4ogZZEZAfYZxOhnOnsZKZR8jB7BWQKzbuRzeVeCSQQ9ZV4NHhfwWGePIVAybcnr0GEFSUmBFvL0ryLLL3t3XTu5UQFNkz/mn7WRK8wmejDGmy88Gw6KIfdvm0kdOk+sb8R132c52G7HfZbhaIoz0tPMRDnOYoa/tsqYauzYvEFUe5WICbqJ+S1fLj7sv810YHKc7oKfP4Uxp0iGn3JEH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 11:27=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
>
> 1. If the page is reclaimable, reclaim path will take care of swap cache =
too.
>
> 2. For non-physical swap users, we actually eagerly attempt to get rid
> of the swap space (and swap cache) once the final reference is
> dropped. Zswap load invalidates the compressed copy, so there's not a
> lot of value in caching. I'm not sure if you missed this or not.

What I meant here was, in should_try_to_free_swap(), I added a check:
if the vswap slot is not backed physical swap slots, try to free it
(folio_free_swap() etc. does check for swap count).

I have tested my code and yes, I did encounter the case you pointed
out. That's why I added that, with comments to justify why etc. I also
had a version of it in the older virtual swap already :)

