Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 112A8CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65D5F6B008C; Tue, 12 May 2026 10:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634936B0092; Tue, 12 May 2026 10:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B5E6B009D; Tue, 12 May 2026 10:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 45EC36B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:50:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDFC11C0288
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:50:44 +0000 (UTC)
X-FDA: 84759054408.21.73D54AB
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 08E0140005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:50:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ib3YTK+l;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of 1234567weewee457@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=1234567weewee457@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778597443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIk76PWOcKB2l3yZdOPVMHe0lxkjQ0sieXJNUO91W+U=;
	b=WvBnH7yiVP//4giVWxSPZJrpiFuD9gkE99fuK160VmG9y9nhFWK0LbsDekn/eiEj2qzEQw
	fhUwIbLd/jlobjOXukdurAlmuJUAtR4KdzskvGgxe0U1LSBsXcBfuwkhvQRcFAHYhyGjSk
	dwvGoyh1xF17XIWdWbjtH9Jaa3O9wP8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778597443; a=rsa-sha256;
	cv=none;
	b=KYrAN47krHtg1u+UsHUpfbUb0PcYKvoT/jDDcQEbivm1nQFo6LmcPKnsqr1DN1oRSzvssw
	eS+qZLIue1m3U/0dQ++0B4SqtAr7P08qa1SV1J9uZly0dyZsIVoDKyKy3gDOaUSaiwW2p0
	OFZPq4ey261mbqAU1XYVoxOWgDd5fDM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ib3YTK+l;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of 1234567weewee457@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=1234567weewee457@gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2b941cd869cso35370015ad.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 07:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778597442; x=1779202242; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zIk76PWOcKB2l3yZdOPVMHe0lxkjQ0sieXJNUO91W+U=;
        b=Ib3YTK+lou/f1iHpFx+9rZ8nbERQNQCFaL30i5NFBDXg7AHRn1iSGJguMUoHjEB7OI
         MBHrhoojtH0jGw1PGQER0mV/Bg8eq2mIdjx1c2K7+Oomxrz7xXVXCmQpmnhOCNM0JT9J
         4WLL55MRR2akcYB/DJ+5YBgMjb/RKsXsQwL80qyzbFSgygooGwW8k70cqtMqc+KBuzOS
         rvmzxz48g60VdSXJ/t4Ik4KtmuFDPcNgpzteSsODj/IS6DiHvHC1vfXhLzEB4H571GtP
         shWI28WA2yVidx51auLC8YYpXFkqC38oP9XOe0zTDPUNXo2kioInEls3O8MCuE+BJeMi
         Nk2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778597442; x=1779202242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zIk76PWOcKB2l3yZdOPVMHe0lxkjQ0sieXJNUO91W+U=;
        b=GxWAj1vWKwunW5MG6uTO4DZmAWitSD7mzn2UgOQKCm59mqgnYkAAkhWbC6uqAbPd79
         jSmCPIUbX9fYo9E/XWOwzi80/3knCdNAOIJxZeWX9UZ+IK2GXKelUl5lJ5AylcUUeb6i
         Bd83MQxJ2E/+5lcwjmeckLs1Vtrx97ft315MRP9AZ9w76D9J5CymysquohPFt9I/1EPk
         GiHx/3HKCnqTQbpeGbg2L+GjKM4ccuskAkHWl3kXXXmvIRsiMaySgyuQVZYQcgZ/gTjV
         eL4VD2JLSdqhKrZuQVnjFlBJxlzejBsKvZ0TvaRKmZmjScFOWuP3t+V2j/VM9LwIUhTZ
         QEpw==
X-Forwarded-Encrypted: i=1; AFNElJ/tGlwVdx0HTcmGk7zsOWiit9o2V3Rkr1etYTT3x6DA1D/JZrHqE0xbpA+NUPPd/5ahgpt8kkSpOA==@kvack.org
X-Gm-Message-State: AOJu0Yzh4YG4EQZ5xSUHKizViIHjp+qvu0oeMq1TAAtuJbeMwvfZWsTT
	ugCD4l/SQN8oue2vzLQEJBkYKtDwG3h7qlk0n22+fZpuQBain4kyKr+V
X-Gm-Gg: Acq92OEl63zRSUf+4CPPkSL3vbxmZ99pAOq7g7RZAZLMUiJ0TBLOoUyCiJ8k6vWN/ag
	spsAvkVazt0YNgkoHAG4sU11G3Q5H4oJaHUfS30SNERpUc6RyX+qdS1lMfDrzxpQWiR6ofI1zBd
	v8u/ej6gWKgEFHg73RELOl2SaE29cADyxHEmfPBDuMGxOMJlqWnyI3blggCRkNL3Nd3LToj7ldO
	+p6f8eY0ai0uMrCGb91ekPpcb5JMlRr66IjKRHOw2OTfc5TbYqMSdJKoiXHObpSvmmpdkX70YU1
	GdRX2EItFWh5TDyuYKKuoJIq7vPnY/lqIULnhJCLlxBTvr7EaAbMgjdznFvxkQBVGoB3SE9vfRH
	yeHZduTVwJzkNgRvKKfFX86Lte0o87aUptrRJ0xBrqCyXaUNywypuMIxQcSsnfHMOiSh7nMqyBD
	2DXg3lSCTo4Oaj4r/tgIH4heXANzqZMplaMtqXEmZDvm3MWfZn
X-Received: by 2002:a17:903:1aae:b0:2b0:60db:7927 with SMTP id d9443c01a7336-2ba795bdee7mr304729035ad.28.1778597441578;
        Tue, 12 May 2026 07:50:41 -0700 (PDT)
Received: from honglab.tailc96cb.ts.net ([140.123.97.73])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e35ba2sm146193705ad.50.2026.05.12.07.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 07:50:41 -0700 (PDT)
From: "WEI-HONG, YE" <1234567weewee457@gmail.com>
To: fedorov.nikita@h-partners.com
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	virtualization@lists.linux.dev
Subject: Re: [RFC PATCH v3 3/7] hq-spinlock: add contention detection
Date: Tue, 12 May 2026 14:49:08 +0000
Message-ID: <20260512144908.610907-1-1234567weewee457@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260415164459.2904963-4-fedorov.nikita@h-partners.com>
References: <20260415164459.2904963-4-fedorov.nikita@h-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 08E0140005
X-Stat-Signature: r8wf8ru9yijmpemd5xctsjyy7kt58cn4
X-Rspam-User: 
X-HE-Tag: 1778597442-613063
X-HE-Meta: U2FsdGVkX196gCHxteFiySzKjBPWtd1trcC2cAIXBXnZKV3BfNALzCJn/AcA2MwVwyvk19nivMKqVajwDE+W9TsVjhVUrHcZhL457UN5C0co1iz01szx19rd+Ao1gpIsSy7TipZo5JNbyr2TrzlKPImyog5MUzb6ARf+V24sEh8jBYZcG0p1rlQQqmSyTgi7BsM7R8ITeR5VipmnKv7TMjEQeUY1EICQK40Id+O5oUY691x3Fj2OLMgmLYA8HxEq1m4W/kjN6k4yArqm0Eyi14ZqpQ31VpDNj+2v1FDSJVWlLAeok9BJUG10Tgj5YE9yj6mg5F8zvcdNFQ81lf+URSCOGHZrw/0Snj5MCw3ZnHy4FuLEnVAmK5xflii2wMyPMgctUO51r9HRbgoQ8o3BHX61nLpGDrKhTVVovjAWyz6Wh1C6d8ZcX73OpFoyXzcMuM4Kjn/aSDGsNJS9LilHbxbo9zSZ3g5+m52Se4fsH231VQbg6VQA2qJscdOMronFksCKTrJWIe1hoGuVoCkX3cleVxiGt/1LcBvktzX32CCL/OOpo9HFcSxQF/QjEmMLHeszcnAfo2RsBi+ry8RT/Wl58Juix+8eggqKgpf2KxVwFC9McEilt2kdqv4ChCsrxbUA2uqVcdit0QTeswf2qIDcop2nslrdAm9pfo1Mk4vNVStBhm3onPCKt6IZ2nR76yvb7lIt0x9mCKG8aJR6DK6T0OQPSXMm/xu0l4nwip3esA82b9wmPKiLi+bj2dv9QT4l/qT23Djjs+FKY6m49zxxlrdTU0LtYvjyDfHEU64XtBGmsaJBqVP7oh8POvIpJ7o69oxKWMyxo3oPnnX2mluFWVQvgZcA6bcZ6OikvaizMzNqreW21Sif/ftSAGVg/J2abQ5IcqcphxLOaBvHIs4sInbqBag3dudPJSIQseVijUxLsiczykYbm1i5+3XP5rA+FFcZWaywjDxBKfT
 awztzyOm
 v3ey6lKqtcU9iZRJPJygtN1botefPNFmwyes4o8BpX/rC/YGAWg8UyoFxJ0rpbNtsUTt6XA5Ea4uq/Hkfvqo0RreG37Fp9cdLgSXR64eClKFWBzPjgUekUo/km2SsNha70vp8tJBkx1CvOY+B6KA8ePNS/3PsQC31zVhtjoCVaV0c01kjEDTMLOjUf0RNJAV2jqvYCBul6mcrShXpLTESqTzXN1rihKDCF9xBdtKo0qiGrNrIuVZGJyFXDboyPge8mDzBsBkXTGyQx2zELTpWmGKH/+4qpDPXir3REoOfMFCB0Wu3ANfyLPH2gqdTneSaNh2UTudpHQpM9iVhpoPcXI0EFMv4i68R+x+dodTnAjwzAdK5Jq5mQNo1/7gZUChyg0zw5FfuUEvkAue5G/slPb2iAR9IreH/o1NkmxQHJtbOAx/dIjCoJEyoU319D2um/yD1QGrbuyi66a6znlbuYkPQHrLocuJ7Hs2f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I may be missing something, but this patch adds
`update_counters_qspinlock()` for remote handoff accounting.

I tried commenting it out locally, and the kernel still built successfully
with `CONFIG_HQSPINLOCKS=y` and `CONFIG_HQSPINLOCKS_DEBUG=y`. I also could
not find a call site for it in the series, so it looks like this helper may
currently be unreferenced.

Is it still needed, or was the call site possibly missed in this RFC version?

Cheers,
Hong

