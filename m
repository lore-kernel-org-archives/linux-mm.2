Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16449606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sW+tUfau
Received: by kanga.kvack.org (Postfix)
	id BFC276B05B0; Wed, 18 Nov 2026 11:07:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3256B05B3; Wed, 18 Nov 2026 11:07:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB006B05B9; Wed, 18 Nov 2026 11:07:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE8B6B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:07:18 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B92BEA07F5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:07:17 +0000 (UTC)
X-FDA: 85448719314.03.FAE6B1B
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id AD1CC180006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:07:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=sW+tUfau;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795018035;
	b=BTQq5/kBDy9FZUwIDzKjy9EV2BauoBeIlhq0KYpah0Gmg9wj4TWnjMDa8OoWfEfFSWnwrQ
	IH3U/kQ+SRhyUl9z3uuGAuWxbIJ7PJVTZgihC+QJQyffHkGE/DGOgm9W2AQmrkrDftRUSL
	woJGACmhKNqVs3PUbji7Sqx46b37HrU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=sW+tUfau;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795018035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K32A9j1K1n6d28StZlwXJsqK8Zlxs4R+GUnH/hh6Y0Y=;
	b=DGzdgbGV35VWBEk7KIAHdSUMc8wO3pt7eJilCuGYEpSUXUKvQzLGJGSkRysN24CrH3dH6v
	BZctLkjR3XfoZwzq1XdJdZIevR1fpJ09p152/y9F/ZNp6JXomo1ZdJqqQltPPhpzxn4sHW
	UbOzWgAU/yduTsRa+i771CcEVwSESgM=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-49a92144733so540902f8f.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:07:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795018034; cv=none;
        d=google.com; s=arc-20260327;
        b=RVzbT/N25a53FYzY+UwzDRlXxKdQjcnlTEr0qWg3MIR9FvC8lMmSsOEDLGRpoU64dv
         dZqtu2k8WAnBSJc39AC7MMfIgDuUzSJq88ryFJabPP9CwZhVfjr2VLinoFV0VDM/ME0J
         VQrzdGkRhpFJ2B5MHTF/nuuQIOZjq2mz+Tq7fnv1F5a0mnq5KYeZoTD8d4t2iGae9a+h
         mKdrUnNL8al0lSZV3l86rjPjDesLPzgnm851fEhZuwNrs7UaAm7wV8wxT6i+m7bIETGe
         zLsvA2X5w7q/WfgJPY8r5LF3+MCV+kBfxkNYDnbsz38TsxAOaYJryRgH+hmdKuL4PBht
         XfMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K32A9j1K1n6d28StZlwXJsqK8Zlxs4R+GUnH/hh6Y0Y=;
        fh=nA7lW4Kt6to63opw8aZSLCsk4VI5tYpRRR5l0bHs93Q=;
        b=PtPi5BbkBW4IphdPD8jzT3ZRb7kZm9ETbd9RX5XTersZsrX/9oPojVEe+yXlrdRC4/
         7MgKnXMhplMqzyP8zey0sMi4FhqD0agiQmsjD9kGsXrSE/L/Cf7KW5EX6dLVvuQhJ6Y9
         nlP6InBR1nHQB9tOf2qGQVfFmyX7uX73eVmzEIdKGpg8Ebr6ofgrcGbR2h/zVieZJbnj
         m6L8zesVYlAkmqv3Yjpy3h3u0BNuODu4pIJr9Z3XkzS+vCTlOZLx45ZcM0OMQq8jBd6Z
         vG/rxwWK2pzYolUYrmmgyQp5toJmoWa97comyUP8B1ZbjN7G/4hSMgL27UsrVTePs/wu
         Cyvg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795018034; x=1795622834; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K32A9j1K1n6d28StZlwXJsqK8Zlxs4R+GUnH/hh6Y0Y=;
        b=sW+tUfau2/TIq9ubkaZW9VlLm+hI6iadVlr5JUd1diN7CCoOBt+XkQQSs/8OYYuV48
         TRzn7xBNjafjr58P4T6Cr7Weua5OBvbD450Ipd2haEk+1clsu8sfMQzvMiefIUcK7XwZ
         RAu6wwBZRE4Gp9PDQhUkxJaPvw1c8vsz6c99dPmTiN6HqfhDIn1dcUtMtGkL2ARy2XT8
         jDWyunVBtDvEBsAuzyWR1N3JhjnBi/4sXHOLfID5JC9xvK/oggACFwvz6slAjfbUP6l7
         zRxgLCQ6pVOqUjF/n5AtTNfbuyTEufsWiHr2IlrA4cfQuo+VuoJRXV39FxcVYZV4qtN/
         cL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795018034; x=1795622834;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K32A9j1K1n6d28StZlwXJsqK8Zlxs4R+GUnH/hh6Y0Y=;
        b=chagm4iOgQOKALntuS7gKIxScoUtgE8AB9Ut+oKkI92SLJtM7V/VSRv+gUMWGusn2A
         AdXIWayoGHlgYPGBkMY587YgRLMt1y+15ugqpabEHcrKVtrCkx4+ztela5BFBxRc2J3k
         Fvf5FwpvPXXKMRdvTD9oz/11FlwiN/VTip0hVEGm3RdC27ejruoVzVw30q89YZyrBZck
         t3RAF7jwiFxl6sxBBeF/c2v8lC3XIPbryhkGPT+xmb2bCXNPODVdXToy4rG0XWTh6NEN
         64tlG2ZODXBiouXmQD1sxiCdkp7PDTIdfKiMdtJOcUXGLeoe8kmM7C33aGsSq29/w8mD
         8CFQ==
X-Gm-Message-State: APuU4Z84GsFElc40VE29gzN2+0oF96R6cKmZJlOQGXOeNb1sPd5u8L4U
	JzxXZzdewgQKqu46ThK9Tj3plXbk1YNy/zakKEyWWE3WT6oeQkNFcR1TimPE012Aw5FYsUqA7Jz
	FLUZiI5D7S/x/0tlGL5vdyUFCxJf+kWE=
X-Gm-Gg: AZFdTZfxAV4yk5+/ngoDIiog7wBaK7tF0N/nhgAvj13Bf0ZF4aipPaKoxLOke2+0lCe
	iLS2Ex35xf9sJ++AJ9VN6iP03Bt8nj48Teouf2SKJ1pSEDHzEI4i0/ChAV89mVaIp25tM70NXiz
	A5HD8xL3SQw3oQk4moEwdMi6hdV9/F95opQMnHWr4ooMtBZzmNgyrHchx+XyAJERX+APyzOGo+m
	+vL93fvnog5Na9Ci0dd+wrTl4oGdSxvyGsL1hqtN9dod4TAmmOkNVu/frKES/4RWeXX1vCnM6js
	rh4eTNQQaW5HFIZsNmuzEdSE9BdN1aYbEuIq6alm2uhAe2fgpauxHPXkv6sUIH1wzd7aBD5FZjh
	2YCJxQOSE4FsNChgrZ7pTnhMlt7sH3kUnAG1XmrsYYqmVik2eTw8s704WnCqg7pdBxY5Gn5dR3l
	kEMWntUJ2vQ+5K4ginPHuH0nSKxooAXWchxZMWJvgc4+97BeEqpxU7v2c=
X-Received: by 2002:a05:6000:4a1a:b0:487:13f:f612 with SMTP id
 ffacd0b85a97d-4a63b6fc6edmr6113937f8f.37.1795018033801; Wed, 18 Nov 2026
 08:07:13 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261118112610.122799-1-oleksandr@natalenko.name>
In-Reply-To: <20261118112610.122799-1-oleksandr@natalenko.name>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 18 Nov 2026 08:07:02 -0800
X-Gm-Features: Aa3M54pAB8fyqglTK0luLoQ8H6b-bFLrcjG9vdhI4RqnFqZQHPbfQvET4tqu0KA
Message-ID: <CAKEwX=Oa2zCjqmW6Lq96=GaRXHNpGKCHutRRsNbGkVpLGzJrkA@mail.gmail.com>
Subject: Re: [PATCH] mm/swapfile: really fix integer overflow in swap_show()
 and swapon()
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: linux-mm@kvack.org, Rafael Aquini <aquini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AD1CC180006
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: o9iibt983bm7zeedcfkrxja9meub3djj
X-Rspam-User: 
X-HE-Tag: 1795018035-387140
X-HE-Meta: U2FsdGVkX1+vmuP2xYlLgMlouODb/iq+q/52KF/ksimGJjXHcKPS5Yb6SdiX4dAkRF5ST6KztHTrohO8hygjM9zV6KbfkYrMLobBYPsxP6RaApFlU1It2XDq6nheMELdEGQdaBER8msaYMLKAl1adqqm3yRKJi0IZcuE0dQCrB6Oo7a6YBAjH+KTlndfIe9rlGUCMRx2JKsGbcEnAjNHb8VZrcJfv7PQ2X5VUUg52quHodmMa/yhgtppjMTdHOZA4AcSAy/gcQfOxcf83D5cYVM9tAtWtaNTOekYosIyye8uFgTti2ftpEGji02SzyZ+mv6GoTwB+gbmHW7gRsgv92sAMEg1ptlj9F/YG+ztx5vXMGTGhBsPh2ABii7JolJBmzR+DwT1iVbMWGv00R1z40E2/14Dn5JvLg0eFOV02utf7IP2BCWCAIHT9QSUy3RYAADYA1GOyYoO4oIrTvKY7OvapQVP19LdEEj1AMVbQb2+SdVZtx7cnZh3VoxAOX9ETZ0oFbzLOWTDsexw40lb0IymEzXkVgT5WsivddWUHqa46WXRfmAnZM54ap/EXF1j0EAlrommC2xYOrLjKKNSIdLse5lfNM9gXKq+f0Rgray6sAbQmeITBX0zMNCBC+Qm3K6LHEQw9/C3K51YbNqwuxFzCFyj9jyJ2l3iNyWDsCpBWHi86PMGmGmpS169Alubk+8q+/6izZ+iy5QNZVsPr1L6DSXLfXVQsn1UoQ1BbK8xAtu422mMVU/x5Vg8etRlVtCCoO4m4IsiWOYLVX6/73MsBPseEoBjiiKU6lskIGqT7imAzhJDD6ur8kCtxfVyt3GiDAafaMoMhw2oiqleevRnhF57Jww3yC978uQMl8s8loLeVL5g5uuND7sIIqTZ2FCnzQ4Wf/M3INQdpFXuEtOUDBZbCUdNMnHBo9BriOk/sDiIXEPKQQP3gOwByELL4zbILbP10C9GKP2ohg+
 POqZjRKG
 ssABxggQQiSCQhpYqzVwZRk4BGNLMf5IxiNtvUJyuK8xqy9tAYS+Hpt/HN/braEwQOHCOwbn+xO9GzHFBPEXKM0h+IjWq0kOZgWkU3oy8e1oAONU/oveDIRpfIyjjV5nuJbv8QFB+xou1Y+UXZ++h+aB2zmhKY3R6ltMldKVETxT19eGfOIVZpHoNLV454R1WOYI/Oip9QopVe48N77ezqWJ0M+h1qMizVyp5Nf9FGAORJ5ldBdJGtJxwqBbIt0vPX6uSKFwTWsjDLZogvPq35cjl5zNkkrl0OB11DpZxGiTVleMHj3VSphNDOr8meugeQjAMugdT0C/HlER9idAJqVoT/LeXYxbmylpVeIsf/yccCgbf0R5JFDoP1tKEEihzTYnDGV34ZQnp2hh01mQT0XrHPF1bsLGwhkU1gi3cGFfVOAc/Hysp+hmVh4wAFvyA69Mj/zIwqqrTeqAFrDR/lf/F7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 3:26=E2=80=AFAM Oleksandr Natalenko
<oleksandr@natalenko.name> wrote:
>
> One of the enterprise customers uses 6 TiB of swap, and the values
> reported in /proc/swaps as well as in dmesg are still not correct.
>
> Cast si->pages to long explicitly so that the bitshift in K() doesn't
> truncate the value to 32 bits.
>
> Also do the same in swapon() for the same reason.
>
> Fixes: 642929a2ded0 ("mm/swapfile: fix an integer overflow in swap_show()=
")
> Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

