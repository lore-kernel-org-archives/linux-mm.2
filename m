Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5664BC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:14:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5256D6B0088; Mon, 27 Jul 2026 11:14:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D60B6B0096; Mon, 27 Jul 2026 11:14:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C62C6B009E; Mon, 27 Jul 2026 11:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EA676B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:14:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A755160723
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:14:13 +0000 (UTC)
X-FDA: 85034902386.15.FCF13C8
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id B653840013
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:14:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M9Sz2cn8;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785165251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLewdajerRpOGOVFnffWvILbwpH/dHzXMl+c5ktYS/s=;
	b=OQ17PoiKBlFzw7eL9t+19eXlmgEy7HeuOdL4TcbOvWIO5utlNAP0IluZyry3jVlSOXhR2L
	6Lqbbr5TWwX2sTifGd+ehAdtDVNHCDT1tiQbvzdA46JJuSgbKf5PrmL2hy7h3wgrIzIk8L
	bkLtsg0GL2GlpQ2MXBbE946xdqRv5JE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M9Sz2cn8;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785165251;
	b=yICgwfX/bypLvBuNlBu8TLoqDrKxhFLsTrTNHnziCg5smK7MK0RTiCWXWEXJir1xQGYslU
	rSLNPfxXezbCKAA3LpV9asp1DFTNMrPFG3Ce6BxtFhX9Mbc4dCguY4DxMSAYJnDuLvzNUG
	+rxxuB2QoonQ1JwXf8hOi9UyUMwVpPo=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f97d310caso1973431f8f.2
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:14:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785165250; cv=none;
        d=google.com; s=arc-20260327;
        b=RpZZVVF6R6EbcFOYiiqkhOrJ+36MeAY/AnHPa/r7fZLJuBgf6OxkvvTY2Ex3ITYE0S
         zbfJ4S7y85PyobPBxbAHXXWEfTYED0WvzzhBRbT0ToyjZpO3JTLt6nUQW9v3qDECma44
         m6IorcL+LPvoNaAB0XCVepR6vR2pLrKoYsiKaCmq0zsuxzumuf9DwxDg4Ydz1OVMn8q/
         lcsQO/StPIWUwAc8TdNz9ciJ8hHJWv8z5uP5orn52SJnW4o07f/s6Nddfa+GBeVu/DWr
         kJZaH+M+uOV2tmsMNQrO7CAy0OABUxw6fN6tjL+HZOsuAaqvHV80bRqnA7Eu1DSNRzaO
         sD5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vLewdajerRpOGOVFnffWvILbwpH/dHzXMl+c5ktYS/s=;
        fh=8XrvDq9ieM5Z8DKkNaqXCuIJMDO3DtmjupLh6pGzwJY=;
        b=R1iAAu5eg4rbL0tCglvCqlGzuc51dcpvxKdqtn1tOS0fzMVFVFM+jX7mP7f1SXMyh5
         42AFskdZkBndPcNZCZX4CJMPN31tZrFVJOlVti7Q0TwjR2LajwgfFDhq2iFnX+vUkCWX
         yEAqoq/slOcDlexzVM5JVy5qQi9ELeaIWexJHsODrDvXvboruV7qbCfbA4a86lsn8OO2
         Bbx/Xh99lfY5BkkrrpyeUKdb8EXqJqP+1YvhHJqiAWNJ/9gXJeIJeMPjUydVbF8RD3B/
         uS4LEk6bIOF405eDGANLxbr6HR8+Yym+yi0JW3UbGtIM/d02e0BiwwDnGIlwkB2Ww4+m
         7tlA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785165250; x=1785770050; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vLewdajerRpOGOVFnffWvILbwpH/dHzXMl+c5ktYS/s=;
        b=M9Sz2cn8JNoC2XU9GJgPeK1qsGdyrSlBDg9OgE/ymzFSE8EM+L1LKXccU3qzigbd/h
         uzcrhiS2rdmb1v/Vv4uiVHzKvZjtB5SwSMg6xSIoiR44spEUQNr7yVRKBI57USAkOFfg
         DvxYAXkN9JsE3mso6EBJ2wiHZVmWU483TkaUOl79vuF26nUHExW5pFfKjnb1Fed+xFdc
         NDLxuDIisFsqZq34HgGeBXnketnFBKrvx2TeElA4fmgcvTfV9bdXyePzm0yMbbJmNcVD
         KbtoPBHs9AzesmRDWj69KWb4xZ5Nxhkqh+ZjvtaxgulD592IHB+lQBo7VgtG5lzm5vkq
         0PQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785165250; x=1785770050;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vLewdajerRpOGOVFnffWvILbwpH/dHzXMl+c5ktYS/s=;
        b=ABnCRPpDwnjFxZrdj98r1aPyjUrEyDfcsPG/fjMxFudb1yv0fGbnY7ORqAKAP65LpB
         DPB6+24CTb3WFppXI1p6LsAeM+Gn/LukUkSsiE+0V5ZxeSWyxPNGuPWr0gbWEpGmHFhH
         ycMu+h3PqWiZ4RkTftNVVe6P+SgWcNTPoXoyXLlJh0toiKM0rmVT0DY1f7/2eqAKDLqA
         6Wn7NUwu4CvPlqji9jI5de/oyGN0EveeTG0E7MgCsR8k/3kj4580AM0Cmq1SM4xpuHMP
         O9Gmn/TN+QXXyFoXrFB0aPWvwjfQB5BR+xqT6OmGYjhlXsN1bpkB0uK+Aq6KrClOjdVR
         VHhQ==
X-Gm-Message-State: AOJu0YzqlkhB+P5xTCCQkCgoKCmELvXYabNqC1ykAbLMldnhClSIMvts
	pMXeEXNHnHlbaotedf0gt0CbV7Hp1CWMqy6MdZ27iAVnse8uBN9Jum1jMk/GJ7qGtmILaarapy3
	wY7hKssbcmc7Eocmzp2aFrth/Kz4MS/I=
X-Gm-Gg: AR+sD13EinlM/cpQwZ50uklc9fqrmCYcPka1m7uvDTH7Hwr3vQ+FULH5o2/ddzUHqkO
	Nl2iuPFKwDG10QYqLYGXOxGooWBw4Y5QDj4sbDLexJQ06s4Ku0idguU1JmaDbwtDV+z02iK6gK1
	Rb4s0hpUgtYLYtuVuAAuEeLgpQHe28mi1gl9P48/TUEzH8MX0LaukDYEKUm26WWVO/x/1+GXO0v
	XsXp8+AMESE/UIaFqD1t4T06/7D+cloPy8PxEIyhikU+9OP0wXD/sNq+oEqp7VIgdsoUyNo+99H
	N0ecrHc8uNaPdiqBIzGy9sj0WREY
X-Received: by 2002:a05:6000:18a4:b0:47f:6d4e:4cdf with SMTP id
 ffacd0b85a97d-47f9febcb55mr11127405f8f.58.1785165250165; Mon, 27 Jul 2026
 08:14:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev> <20260727140503.1060918-10-baoquan.he@linux.dev>
In-Reply-To: <20260727140503.1060918-10-baoquan.he@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 27 Jul 2026 08:13:57 -0700
X-Gm-Features: AUfX_mzOaXqUFzEpeL8yu4jt2jAZueSTRdeOrUIj2mvCQ105pCnpcmIbo0_nPsM
Message-ID: <CAKEwX=NNzJ-7uoHFG8jxeN=PYi_O9D42xc4or3O1im0UJpF2ag@mail.gmail.com>
Subject: Re: [RFC PATCH 11/11] mm, swap: serialize xswap map/unmap with a mutex
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, david@kernel.org, 
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B653840013
X-Stat-Signature: eddukn5e78urp5ziumprfrc35958f8mu
X-HE-Tag: 1785165251-711396
X-HE-Meta: U2FsdGVkX1+ECy9mhAjfuKu/kdMF/zCXDP+tXqUDS1iAlBnkD11jec+Yd+AZhc8CqJWgAtjhGqUNPmnyeJjYPwZc9SWnsgBbsUsDehhYzF8mcmMZvHgvD4L1pDw/c+IFYziVf+pCp0WNYZ0i+bspGvhNwzPxqLEkLre87XLqLMN4XKBnmUK6q5XlRYUjr9qoAIPFJfYq7sYYZuzRTUBgO/zJ/p4VaEQaXd13LjBRgF3Uhuxtc7aSWfSBeB+xHrCggfPlRVkTd46kxb0VSIKan+5INVGyxUmPaxSI9SycBsA7Q5HpRqPu+8RcZq35LodTNo1DeHqbFxfyPsi69L/KcTJBloNgEUMaGrifCf6r2dUQADHkvO6jeXBqX3Pc9RY3+6Ca71hOAHC0Y2rK2NANBoLg5t2NAOHDPJoKPfBOxpMdJj7i923PiAK1HM0OxisTp63CZwEgh0IKKVxvJi4lwPlBtq0ZUx7UTF0Lsrat1sxQTdeWrZxNDPdXUxzbkyZUv6q7vvI/KIkvf+f3vLdcWi+YTu5kQiacZ0cfPdVwzqN5PxHYSzbrOVshUpZ3b6OtfcikHrCs0zZriZCJGWxnhz7fkXBlPDLommmRhL4IbjlycvblFvi+t0fnd2fu+IiL9JxEXYZx8B7wJxtdLbY7Fo21rTsRb2NipyJTCPMSKWMUHfuU4283d8ayWggp6RKJ0RXBtgBLW6/ZOGz3gQ4NfUkRcr2hc5c1NLLprqRsmWWJULNyhl5Hed/Q98HLjuzahkvVDEGZ+jf/B/1W8LAuLOQ4AtsxOmznd3vZ9vUJ7ZXpc0ENAOpynyXzL02ovy6/vbqOL2c3Xbzjvt3Uw+gFbteM5bFoyOZOBz0eTIG8L0Gqa3HGC3B5Yil6PZ8o81K8L6tE/DzUeAtz0+0TP/Mm9Tv0RBkoLpO/OAgRjbJ4vaGkuftZXRutLrfm2kqp1HoqIYhGp+39IMArQ7h5fEG
 my4ZcHGe
 uWG0O2X5vXEIGsXzObt0HsLvdH/Vo35RtulEKi+Y7r4tNZmz2O37Cwbq4imD++17+AUndNFrHr7gP5MMWp8wo8+HO6B8wING98ZJIlX7PnEVLZ7jWEIyPkFQCnEpB0ITH06jv1G2Nr0tmrxsJpKyCdH41TZcXYAQUuvAROZ9dhkfJMnwVVqdD7aieLFR5ZycFTxa6OcpMC/NVvkg2eSU8lBw9nNoS2tG8BwetCKk3G7+jIjDesSxLwz/exw//QolLaKBUQO5ImcCCRrpTpHNitqRHPpOWFoiI+efcbpQnmC1a5falxj8DY58PhHgpAHJgogjiO9SB6hYvFQS61f/W2jp1pnkYLDUWfALs9j2hB+lXU7Sw4ZoefGM+GFczn8ah7MoJEn0b02XpxkxH5sAfJTi3wA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 7:06=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> Concurrent xswap grow operations race on vm_area_map_pages(),
> triggering WARN_ON(!pte_none) in the vmap page table walk when
> one thread sees a PTE already set by another.  The -EBUSY safety
> net catches it but the warning is noisy and unavoidable without
> serialization.
>
> Add a per-device mutex (xswap_lock) held across xswap_map_clusters
> and xswap_unmap_clusters so that only one thread can modify the
> VM_SPARSE page table at a time.  The shrink path is already
> deferred to a workqueue so it does not contend with itself.
>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>

Seems like this should be squashed into one of the older patches, no?

