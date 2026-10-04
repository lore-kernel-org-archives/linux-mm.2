Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44C52CA5FCE
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 06:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E993F6B008A; Sun,  4 Oct 2026 02:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E484F6B008C; Sun,  4 Oct 2026 02:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36AE6B0092; Sun,  4 Oct 2026 02:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD8B86B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 02:35:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8D2780AD4
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 06:35:04 +0000 (UTC)
X-FDA: 85283981328.04.7C1050E
Received: from mail-pj2-f38.google.com (mail-pj2-f38.google.com [74.125.227.166])
	by imf31.hostedemail.com (Postfix) with ESMTP id E0DC620002
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 06:35:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zit6FcNm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.166 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791095702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbnHNbDys2WuStNEMWb1PaflkNK/JWz914uaZlrZP+o=;
	b=ESy2CxOMkLCW0sahxGRbROFHNZKu3R/EqgkkVXnXEFzCQ+5NLfZMHpTBwNR7u/oJ6N1BCW
	F7uavj55kBObfniJRaLJV19VuQubcK4Efz5xvtL4P0HclPsRt1mx3DKT/YdvBKA9gS5gnM
	OkZhM+unnRvD/fX/WPr91LjWVqE+4yc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zit6FcNm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.166 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791095702;
	b=gUseutAeSLuJl0vQ4h6e3Slzl+W3F2E9RKYIX4EEqZr7k+b4NLQ/OEn1wZuMwiPi5FqEkt
	x/fLCaXIvioysBvUqlZdakKLhzWWdyetRkdtxSVasOwZGJwVpfZwVkUVu9MF18zhJVnwNc
	AIAJMl+1m3eUpE/WZVRHe9l/uQpQc8w=
Received: by mail-pj2-f38.google.com with SMTP id 98e67ed59e1d1-3a4c276e1c7so267205a91.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 23:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791095702; x=1791700502; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WbnHNbDys2WuStNEMWb1PaflkNK/JWz914uaZlrZP+o=;
        b=Zit6FcNmq3/W2+yob8EVpnIlCbykrn6KDQg64H0Sk4sjgunfHQPxsMzmcVIl4djeIu
         qMYZYCCb8HuEg4n/MpUd2cDSQV1A7qH2PrH1ToW2bcIPfp77xC94hOxyAiKWS+C9hx7z
         omINEXNpJ7GJIcGr5XsTj5a0Cd/D17V4czLfq+OhAK8mQHkdAzO9ldC6eCGnQtfaKrYi
         uYbyiwktl3VoRgfvMK6Li6HbgnmVB+xOCS7pmJz+0+u/Jxh4CQ+fpw7KG/JX+Fqx+Vnz
         Qk1fciw0KzOOYaRDGN0hSddJJnKWLCTMEKHUqLmZhTSNhD/5IUbWBggp6fu+TdBafgB/
         5zCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791095702; x=1791700502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WbnHNbDys2WuStNEMWb1PaflkNK/JWz914uaZlrZP+o=;
        b=k8vXMc3fRiLdLBgZ22dmz6aZDMWOpbNxu9BnaD4BWgW4X0NafwJbrEp92yyI9weF2j
         7uUyJdaTzTTLqNxpCI8DxxbhtTzqj8SK+Bq4GeG0Via8p0NPTGbeXOmJG0OQO/DUdiYj
         Odk2z4oFheLhhJ3U4XfLiFJewYP8dId+FyRRkNx34bjFyviwJhOlnSuPCzRmTEAWo9uW
         w7UmUOOVeB7ckL7Jzi36qlnGDdwAnJRXChNx24bPw+8XEQ6C/Ih50T3l60sSl4j1o36j
         xifmPgRx4xeQ6sIzG+UscNKl66iHwFXW+5iWNqxnBUDwJedovMEdO0HLipYPk6BZtUqC
         o87Q==
X-Forwarded-Encrypted: i=1; AKwUvBwy5eQ0OPjD+i2aOZnp1BiNXXH++061fWxuJf1Nj+xrMrl4blltEXmFii2G/KjJB7dcRz6NMxKDXg==@kvack.org
X-Gm-Message-State: AFq9FYKHpI+HMTLKTCvraG1g91siyTUUJhacHLN1KJRbuGCnns2kqXP7
	3GZ8RcKXdQMj8PtoFFZrdWtkhJ2nI4+WrLuKEGr85V7WRwuAQLBxl32f
X-Gm-Gg: AYBFou03t4wglQJ7QJYFfeThVI6kINgnevzw7+zfkuza0vmcwXUvBww+qnDDpddOhhO
	LSH84KmGCLT0VtmRz21tLAeuVjlj7ZtuF6epgnjC54kolFRR1oiVR0/yMiCEd/FHvceAUY0qQd1
	3qxM1TS5YWNv0Nf5HvLZ1A17V3tKkQLhxFzOslVhm3h23fPtf1i4jZxd0zB9Pf6wMOe3OWHNzPh
	00ErueT7FkO9IQpUh0ZV7kTN9kQfoTH7IFAWxzlUUuDmueARiZZrNWHmVUegXMUAU3GBsGqXAIt
	IUmf1H1HLqZ6jHBE7l4eO+BhkrIkSuEB3KJHcRFKP8ZcIFsF+AOdkaEA9bu0Saggv2evvlO5aur
	JAXTYr2nqy0GCH+RGQ9o2Bz1T+UkK0UKQm95Cmdt50oXHtgVs3ZYYBoPspmLojKaFhU7YL3Koch
	dpNH2wRJ9sDQPbM2LeBGb/L3fGebrAXz43Wcsy4QnwVG9b9W+P+z3tFPYwn2UPKQ0ynSp/
X-Received: by 2002:a17:90b:37cf:b0:3a7:a9bc:729d with SMTP id 98e67ed59e1d1-3a7a9bc9629mr911026a91.0.1791095701612;
        Sat, 03 Oct 2026 23:35:01 -0700 (PDT)
Received: from 027.. ([223.215.74.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78d65d85csm5504430a91.4.2026.10.03.23.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 23:35:00 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: baohua@kernel.org
Cc: akpm@linux-foundation.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	jiangwenxiaomi@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	urezki@gmail.com
Subject: Re: [PATCH] mm/vmalloc: bail out early on invalid page_shift in __vmap_pages_range_noflush()
Date: Sun,  4 Oct 2026 14:34:39 +0800
Message-Id: <20261004063439.95516-1-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAGsJ_4xWAd=VHPdGhS2AHKag2WhFA=_3MSOPuyt3ksKH9ezQ7g@mail.gmail.com>
References: <CAGsJ_4xWAd=VHPdGhS2AHKag2WhFA=_3MSOPuyt3ksKH9ezQ7g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zm5mdj5rz6k549q8qxuuiwu7615hnubh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E0DC620002
X-HE-Tag: 1791095702-376071
X-HE-Meta: U2FsdGVkX180mRMNPDNVSDdNcWmzlS7mHd0uj5ETsrwQBMuuYBicji5FAXREJ/q6+7M3oCUCBFCiuebKH7szj6+apBP/7L07Vwl3PXICY0qzvA56M6jbt61kqro8LxthEDErM/oADPc14aOUh9JrlnqOQwQj+0TBK9L7tOMdeQZDPAYMGiKsxzwr4SlPtQrZkzlU1a4fmrwfBPGZUXI9A0AsaYpYb8BeGFArSSo1vtd+v7RQDDKgdTo/AdxrZx+a/wEe4Glcdlgxg27JZqWkEDDAIdl2yLO61vzozJNGxqGqusi+DJkTb/jNav/80SMhpTj/v4JYV5FF6r+OV6xCMKq7Eq/Fu7hjXqHjsOS0P7JfYQuH5RIzwSsTIMXPlqruUbYb/cAzmYI8ZKS7IJHwVE4HxISFKdBuaG5fENcDtDX4Td0RV1R/h9jAKRZdtejy+21bPZFY/Wd/FVi68G9fB9VS1GoUz9gugJNSeTZv5Wa+fC5z2LqLdwTVjBOBQn/v/WKUjCDS/LNq5RX+4Fs1MuF+9tHiotOHiclW5NGr/0VJMBtYcKnb7Hb+VMK+6YFNRLJQ0gRS7qjzbmVaYcju2O7+SnldKfW7e/4B91NpkGpBj+P+AP69J5KhtXmJcFjqBb3UGZV5p8/7GXkXNLSQNdTi3v1gvvbyn2lPq7VtIFAgxbvBk3qNnT469nETDYy3v1YOMLfBq82mTG2PzSkJZxVgTUt4uNi/dQGumQX4eildYTpLTGxmG/V2n26gXrJYk88LTL8blR4TQJmjw0H6uXs9Acueq7+zdAvACQQjp7Wb5iNPR0HNZPRwYcOslyg2/hLzDdefWJuPAABHUblcNldd+CkNXKKXLt7gczrzeeozLb1If+adCtIL/pKtmByDbm2w49w8SxcLWLNjKqqnu+1NNDndSCxSOYtri3HY/556YQVWFa9Ej7sNnvq/9mZL1XyRsMlywoJdPqA6X9J
 0BG7XIAv
 r4mI4sCtzgqranGZ/vMF6+ag4kXkjKxg3frV4XH6ADreq140QSfHoM7c5HLZeaGp6Qd3WmGEW5O2rioGbPG/oh8Fek1KN4PjuV86pT8TyaY7VoOsiY52C7MUt3sIRYjMiG1o6hRNpP4BOnMpuaSdSMa8jifvtk7t0aWOUEaEclDoAHKG4m3E/62Bne1GeNC93Qx9bkGQs0nc4iR5pPMgEyr3XMRayM0kSe6T0AEObZcIRVk90EcPZX72BwMO/4BMV4Xlyr90Bnu48fyrMd4PdznQF+iH5WXr3pmh/OTJOunhsu3uv+3mfKry3WWIKqoKsI5z24xNJi2UrWMYbVMFNfHl1SGg/dL7oexAZCKbrZPWZCOoDlIEf+zUJoaXajWp/aBM921RUSiZwqPUdX1D05yEwY60KLy7CQc2mxeap2P7X8uo6LagSDF2s1cOGNTfv3brbdeRSzbcbigk7xXgbVxtyBF/U5Txaf8W3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> I have checked this carefully and confirmed that this is a correct cleanup.
>
> However, when I applied your patch, I noticed that the author and
> Signed-off-by do not match.
>
> Author: Wen Jiang <jiangwenxiaomi@gmail.com>
> Date:   Sat Oct 3 17:04:30 2026 +0800
>
>     mm/vmalloc: bail out early on invalid page_shift in
> __vmap_pages_range_noflush()
>     ...
>     Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
>

Hi Barry,

I'll send a v2 separately with jiangwen6@xiaomi.com
for both the author and Signed-off-by.

Thanks,
Wen

