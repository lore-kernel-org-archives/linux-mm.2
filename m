Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D612109316C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 01:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3BD76B0005; Thu, 19 Mar 2026 21:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC6E6B0440; Thu, 19 Mar 2026 21:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB426B0441; Thu, 19 Mar 2026 21:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9A166B0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:05:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49E56C285A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 01:05:01 +0000 (UTC)
X-FDA: 84564647202.23.5B39D93
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3730520003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 01:04:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FUbVfSv9;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773968699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gWQLEpkOhBgzDzA7ODMVGmPtwAaA54G60wz4R9umuUM=;
	b=Gv/RYksDFLu8J9qMANL3dL5MzQ/sOThOqnnfi1uZxa/dgs43vm7mVhVLolMiAn8d5gt2WH
	6K4mRrmUvdHCy8iH08YblwObIFBMqoQHN6+wGUGknt5B8lGnv7Nk/cj0NXaiBjb94qDmd6
	VcNjXND3/L0i3D+QxGyhiTIs/2MrE7s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773968699; a=rsa-sha256;
	cv=pass;
	b=RIIsibGBKL1EW/C7GWAD0DKKwbjIhkJSPVHNFxvMUGjQt58ZN/6QJzja2U43Ki/WpXuXeQ
	hlxU8Q74yvTDYCsq4bGg/RVseU0j012LyPETGRW+6dtOT5eMhLAQPcz7Ghp7/tC2sqdk5u
	gjKi877KnZghs1W9UpyX+Cx2VLCwsfI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FUbVfSv9;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6634bb959a2so2382791a12.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:04:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773968697; cv=none;
        d=google.com; s=arc-20240605;
        b=K4mkgyzEdjOyEtlC0uC53ujL4S7P5B7qf8+qT3hP7eft3d6hXHtmtv3r1RW/CSXHDU
         IVfd1prXIJl30NoJ/VaEwwdCzldgj+6GZtZSPAz8QYlSU5Ndatw/FnNiHfug0se66trc
         pvRpPtG8r9vK1KtOsrZML1VZe3hzkmdJO6CeFtGKhTpohKLVG3L7BHeuHMOGhGecSqIK
         8WU9ls/C5E9VGe+7wGQ/gxA35bzjsWiT/n58kUlm1sjhB+c54tVVmqgBSEmn/bMRHZzm
         WCtk5psQ4/iByaxt+0GDCS9Qc3XDrg2aApSQI1ngJ2eFET24S9zrajWww/RaXQfKQkOX
         0yNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gWQLEpkOhBgzDzA7ODMVGmPtwAaA54G60wz4R9umuUM=;
        fh=j6ccvwhYfNBtRD9dkU7pLejPVOGz+yt5Aj3UmIxDhRU=;
        b=TmGQ01/mW9a2l8fDK72aYvk9pePg4+zuYP8HhdxkiR3D8EciFDW4kZTUP9T5p6Kf/A
         7sacblxN0ShUaNiFhsZQQ2I5KXVSR5aac/K8hjZlkcJ6Ej5oFN6Xzjcvq3sRku/qHscA
         ITVn/hWGp4jjapaJz240iplZh8fs/dYD2+WwWFsTdHIlFRRznpAIXSIv1on0Jkrjg9WV
         AMR4Nev4biYBdQ7nazOQOawsc0Qtq4UMWVpJK22mgMyeOZgC+jCSsLLNxtt6rlzKQPSK
         7W6Ae1+GFAGTrvk7sXV7DAJmXyZMPUSh4W/erLvAtsFi3MlLsjA2DfSWCP+wVcr079M1
         3S8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773968697; x=1774573497; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gWQLEpkOhBgzDzA7ODMVGmPtwAaA54G60wz4R9umuUM=;
        b=FUbVfSv9GVLNUKsz5LqiqaMhYh2Tp++l3w/3f9LwQcqHYE8zVz2SmKfOUtUtE4jNui
         Yvxl6sxSUplDK5uG8mQKOiZrQPUrSk9OlX+ktfCelzHDPcyCG+9DdFQxgfyAYc9fAY73
         93K7bAYK8pCjaS+SiNdclV43h4grNwTONfwvjvk9TmGvF9wkpQnwXg+C2DrHIBlBh+Hv
         A7DRNPmfjm/RRqlsy5h70M9IpuK2aWqpHOAf/HzXslwGLu57cqy9qwNkgWAM028wdKko
         T3QldZTdNoSeWx6ITQTyxr2/ML2U/hJkW06n1iaUgzoy2oeo0MrANZZEZH/fYqb85+Ra
         rN8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773968697; x=1774573497;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gWQLEpkOhBgzDzA7ODMVGmPtwAaA54G60wz4R9umuUM=;
        b=HuKMtIz3utesnH7Wisv9L0zXDYk8TBV6UxjPhaAUdSWqW2JskS4mqttXLZZW2Nw7bO
         X0PiX8twtZNR1R98PjC8mZOMu2w+OEwMLqtv9BB25ESS96NK9lgC+8yMm8jj2pFVKCKz
         E0a/SKGueEKnIqA+08CYziG9gcsYDGNiOzqDFxE2vFy4Ub6vOZlw0G/6Uw28naw0tJOv
         gpDGgb5u3K4bPlhQRbr4Dbydht4rdtXotoQHgAoMr7XmLVEckLjic/+vlVrzWHSUZP3W
         omMgQ4hJudxs3ZPjK8WY0IhhOJ1qSmLx6RiMjCJYbhHW6vTYX5jnX3KADKlBSk7EoNIc
         f0Uw==
X-Forwarded-Encrypted: i=1; AJvYcCV5Ua0lruUOb8Da+bRPWIev4HiLMQuZZkTtJbCVW4yiTr4jwjI6ugscWsrR+3v9zOh7Uo++Y2+tew==@kvack.org
X-Gm-Message-State: AOJu0YxZItvLlQV/2UPajYnT3fatuTbPKQHsQf5RJtSQXV/pyj9bbLX5
	hNTM0/h6iNUyubFm6bvAd1vpH75msGoPJ6BXQDdkFsJ37JMobrVHBDoANNj3OaRErq5Kgs6xHNb
	zSeC+xxvNuhhY2/EtA4lxX1O494oyr6VzrZJ+B3Aj1Q==
X-Gm-Gg: ATEYQzzxFpu4j1p8UNYJkhfUD4RMgnhd0R313KnNxe0l08sylyknscCJCl7GzaX2Z0D
	V6SQA5beklQVAdjOpVDd+GKtqh3gP1emBkTioHItn3I6fmR9fjkbp1NcRGlPspy7hRWdtNSfOQJ
	CjpHK/B9KJxyEnR6Qvm8dFmZEx/nx1YFQqkmViSX64i9rDYwTi5D7LNZ203pQQ6rbvcZuCZlZv/
	jTvaZabZmBMCF79HtLb0BT94bwkqj77gfDmzanHqbjdQts4WYK+hFk63joLm2El8E42xEGH8qiS
	X8q0Wzg+r/91pb2llO6w/+0TC8xbmmTkpy83vTD0Fa7Vqp1F
X-Received: by 2002:a05:6402:5250:b0:664:18e0:f42b with SMTP id
 4fb4d7f45d1cf-668c9214c95mr990680a12.12.1773968696998; Thu, 19 Mar 2026
 18:04:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
 <20260318141637.1870220-12-pasha.tatashin@soleen.com> <abyQJ_9xDg6GrU4X@google.com>
In-Reply-To: <abyQJ_9xDg6GrU4X@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 19 Mar 2026 21:04:20 -0400
X-Gm-Features: AaiRm539yoQC7zEJZaRk3tzI_LkrdiZ9jxxxMjUjmd0NvmO_BulMBdwHtSpLey4
Message-ID: <CA+CK2bDONAnry0n9qOsR7GSDTw4Xw3g4ZugRPwXD+NdMx7rpsQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/8] liveupdate: Protect FLB lists with rwsem
To: Samiullah Khawaja <skhawaja@google.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 39bawktiwxzttwuwxx9nfms5yut3h6ho
X-Rspamd-Queue-Id: 3730520003
X-Rspamd-Server: rspam03
X-HE-Tag: 1773968698-585306
X-HE-Meta: U2FsdGVkX19k6JUo4+AqMVYl+5aDLrF+b72pKRCT8PVMgDUVDlrza/7Z6yd1XAMOMxMIleBy8u5FAIei7E7DWOgoEZlXlxBNxyvGL+EYWq5ycSIlCUGCorbrWR0Wnof635VVpFD5JZv7a4tNE4P85bxQxETHxQVDcgvP0yTGZRXD4JopGmUrOr8Ufp+Aahil+89EjBegHcFiEtbyVEaqf/qBP9/YU3uJ9/xwh265TH0GYIZAwbl235lqaqmctHFG8zElyJIBBk53G/YYimqoKKdBgpYQVpjjXQSbYb3BAP6OpytfhifYTkunmpzE6W7P6X68wwlq44XewlufxeF2SuEPFeLFo7jf4VuQjWKeqLsxQATx0DI1hatx4Q1pmpwTB6yOIvd7XOtUQbonYN3Ud1YMx6t8E2cwTmWRubkIqhe8g2SKpUM+F8J54rpgmzE0BDxIzePV83nZYrj+wDzcMhMikASk5rRVE5JYy2EkL1VEPWc/Gfu5scPOBlnA2/v8okg+Qktol9/4yauxMiIGVc1I89b1uRf7CusE9Lbi3CO5royqwM9NdAN1+bGaenkpXC3kRMDWia/+EgyTuWTiMIX9xQ25Atgx+DZ5fFED5dhXwgeYcXeaayLrg/5xLJNzEnyq3Qe09ppsQH/9e1g07nLfERruMQ7B2KyZ4Omk8cTdeOh12v+GbaKnUwg8R5iAWpILq2HMkvk4XFQASbJDZPz1BQ25CIUp4UdAdiAByiCiHjQUA08yGRWqk56NhdgEIWelTk8+c0p+rPM8tPUZ2Ql6jFiIbhGxNYqDtm9YFiglIwMl8CKHn28dZArdFAqGES/m8wYpBGrfvGJ4pn1KC+EAvn245br1zaD+ObrW/V90g81jtTq12sz5Poz0sauuRuyiNm1uXfTSPjoI/5HjtIFK4h6d1rAKnwL/WzWZklWQliQzZ5EyjpHIiwqCF9v/gTPGQBLbqtHbwYE7f27
 tgKyyRHR
 962Y4CdIMhhEpt3L6eRDQLpSrwx6zdOVxjMlBmDjWnUWy07ucRqM8VnhfkFervhhm8I/YKalIDnq1U3WSKApn48c/hyvDEBOJ/vxHVou/U/Vp+Y5kmkwtg+l00ntC2UhhXkHgp6+64aR8DrRBn/k6jnEVyDqvdzokFRgJmRaxj6R0+NNCZK3I8mwhF4D9pAXQwJP9WeH5CbN0M8us29v6wmp7k3yjIgtFYwc7Q/Qb4Sb9D0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >@@ -355,6 +363,9 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
> >       if (!luo_session_quiesce())
> >               return -EBUSY;
> >
> >+      guard(rwsem_write)(&luo_flb_lock);
> >+      guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
>
> Since FLBs are linked with file handlers and the file_handler can be
> unregistered/registered while this is running, should the luo_file_lock
> write be taken here? I think maybe we don't need a separate luo_flb_lock

Hi Sami,

Yes, thank you for catching this. I thought we were safe since we are
taking fh->flb_lock, but you are correct. I am going to do what you
suggested below and use a single luo_registration_lock for both FLB
and File Handler registrations. Reads will also be shared; this will
simplify locking.

Pasha

> and the luo_file_lock should provide enough protection if we acquire it
> here, as a file_handler is supposed to be registered first and then flb
> needs to be registered against it?
>
> Maybe we can have one luo_register_lock?
> >+
> >       /* Check that this FLB is not already linked to this file handler */
> >       err = -EEXIST;
> >       list_for_each_entry(iter, flb_list, list) {
> >@@ -444,6 +455,9 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
> >       if (!luo_session_quiesce())
> >               return -EBUSY;
> >
> >+      guard(rwsem_write)(&luo_flb_lock);
> >+      guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
> >+
> >       /* Find and remove the link from the file handler's list */
> >       list_for_each_entry(iter, flb_list, list) {
> >               if (iter->flb == flb) {
> >@@ -638,6 +652,8 @@ void luo_flb_serialize(void)
> >       struct liveupdate_flb *gflb;
> >       int i = 0;
> >
> >+      guard(rwsem_read)(&luo_flb_lock);
> >+
> >       list_private_for_each_entry(gflb, &luo_flb_global.list, private.list) {
> >               struct luo_flb_private *private = luo_flb_get_private(gflb);
> >
> >--
> >2.53.0.851.ga537e3e6e9-goog
> >
> >

