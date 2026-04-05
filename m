Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F33DE9D800
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 17:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2B76B0005; Sun,  5 Apr 2026 13:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2AE6B0088; Sun,  5 Apr 2026 13:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8976B0089; Sun,  5 Apr 2026 13:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA1B6B0005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 13:18:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41977BC9BA
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 17:18:19 +0000 (UTC)
X-FDA: 84625160718.17.A115EC9
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3D0D8120007
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 17:18:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TuZa3fjD;
	spf=pass (imf29.hostedemail.com: domain of julianbraha@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=julianbraha@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775409497;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21tVDycDW9dNNLzoeZHHgavbeTlgtwmlBmn8/EZct60=;
	b=nr+OA7aH8v9D8ZOLuqMDj5Vx6Js3HYItOOyazMKNHChTP8Mr1jhgWn8THC8xNEVELLWwwX
	cWHezCCeod6BmXPrqd72AsK6s5SofPUEzmFYhU9EV8O0kQ3MmwKDSh9qhFsgtQ66MTrnRi
	Tw7grsig8SIaB1Jd36ZqlLxe829oWOw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TuZa3fjD;
	spf=pass (imf29.hostedemail.com: domain of julianbraha@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=julianbraha@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775409497; a=rsa-sha256;
	cv=none;
	b=OhBrpsCafOsjzIoQ2tNVSuJy/NpmdvrL0XapylE7E41uQKOwRf78BGVBsHX1rp8/DKGl7l
	gDC4rGl8aj5/eowEtl5cfmSwOKxiHH4AJ7zeNRbo51lXDWzNriBa6yyu8pVvN6DHuUvZoT
	ojEfQtAUIj/J8rxt39L7zQhhKlZFoJ0=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4853c1ca73aso33709855e9.2
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 10:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775409495; x=1776014295; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=21tVDycDW9dNNLzoeZHHgavbeTlgtwmlBmn8/EZct60=;
        b=TuZa3fjDoJraGlK6IcCptepjQp0iAGyAVnnWMava7+pB5s3HjEZvFJsxFI4uWhcl1E
         +hmp0Wgh7Ah8c9flTmWrinnj3oxvXmDgJ02/hq1rLZHewYLdi0ZddECtNH2oZ2iM+QIF
         jcQwFx+VDEZ68L13vqxwZ9PUXOqZZmi1lpHAf9tjG/JrYsPIcVvBzwV/M7dhucYGlwUS
         8IRPpfu60r8JhdE2aOx4B98XJLyulMag0OwR38IVK9CE9fS00qoh4F5XYcLQ59Kid0m2
         WDVFNTzEx3YboW+btfpZIY1b7BxiDqlDx2aydfqI4D0VQAAU/XFBaWfZDnGhEQarrBHK
         3MEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775409495; x=1776014295;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=21tVDycDW9dNNLzoeZHHgavbeTlgtwmlBmn8/EZct60=;
        b=Mdn551SbvASPXhm7jvKEuL2ncA3p8mLbZXlYqdmYZ4kFmHmKxJixzO3RxUywusk8UZ
         +i+IChyVR/b272D9fWrYsHr4Il1tBjAc+DfiODLVlJv48KtK/FFO1KwTyTYns71GuxDy
         T+vUeh/6NmwfWvoVAmbh4oRp2XHGS/o1jwkFBtUCyzk98riwS0WkE+7rh3GsOwN5TXP5
         Vv8mrCjSC/fnxXPOPIbdWJzKOSAx8DQ215KnpnlcUfUfU5M+WwHXer+vVlKgdtFv5xda
         VW7W5WrdA9kKAIyuy5GsEVU3HF4V1ax8J0KKcd+8jHdF++oyMcV+mmWNcsgvGSd4gxE4
         6AMA==
X-Forwarded-Encrypted: i=1; AJvYcCVAIKf77OzalH6TNYfXHcTF4sjSlPhOISAlYvDlxc/KmXWYTSxoi0p3Z8CVhiYIlu6WaKpWL3y2kg==@kvack.org
X-Gm-Message-State: AOJu0YwQegFwUk0n/LaayXpOa/qgGIHDs0eTnsJpW2VUxgknoOiVhmHp
	fL2QpNEXcxkTn+5XFsx1V2atqhE9XhzhdCXxIoTDukCehIUqUg43xIDL
X-Gm-Gg: AeBDievqwVZPneb/KDATRMxqfWL2tZ6P9IvCtumn99SSxAWmwoiHqeH0o/6J/AyfimV
	tg93rMeUt1c4BGDClEGlEPnmwIUu91xGE1rjirKVR/FzeyIWwworDSLw0poPiMCscfHXgkgzlBr
	LTEps96L1mXXXlg8iRS76KUn9Qs3jPYfiUeEzqisxSaKTfDX9Ikq+wWCyW2PwAV7yebIMnqfvNN
	WARatyPFKbc438sWPhf4NaZF4Cg5zA9FXbAHmpi8s9GSKdLnsCP6+hTnQvw/x37983xae9gQ/RY
	DH38+SIT4MoaF9nzP1lYd8yQbqD9faxw/YjntJiiFDPaSwCvrNQf+eGhLhCix0jU70quANsGq3A
	QoTELL3EZvT/ifZrA5I8VA/6jNfqz16wQHv8bRNWmu1wR1EDWslU1TI8j52J3bseSKiHpEdJe56
	yorlpJUa+enE7EAfE49FWRCAZfOpapM/dpqvEiqx6SlazuHv6ykhucTnkn1Q==
X-Received: by 2002:a05:600c:138f:b0:47e:e076:c7a5 with SMTP id 5b1f17b1804b1-4889970e3c4mr142911865e9.11.1775409495511;
        Sun, 05 Apr 2026 10:18:15 -0700 (PDT)
Received: from [10.128.11.51] (195-23-151-163.net.novis.pt. [195.23.151.163])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488a8d6e27csm143362005e9.6.2026.04.05.10.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Apr 2026 10:18:15 -0700 (PDT)
Message-ID: <3cf0c280-e5bd-4e5b-884e-6c734619b821@gmail.com>
Date: Sun, 5 Apr 2026 18:18:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/thp: dead code cleanup in Kconfig
To: Andrew Morton <akpm@linux-foundation.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: vbabka@kernel.org, hannes@cmpxchg.org, mhocko@suse.com,
 surenb@google.com, rppt@kernel.org, Liam.Howlett@oracle.com,
 david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260331070730.33915-1-julianbraha@gmail.com>
 <bfdfdb05-77e2-455d-b68d-9da3fd9d1c0d@lucifer.local>
 <20260331173744.925a6ee6fac299f86a07a7eb@linux-foundation.org>
Content-Language: en-US
From: Julian Braha <julianbraha@gmail.com>
In-Reply-To: <20260331173744.925a6ee6fac299f86a07a7eb@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: usrogt63zzq5e4rz7in8f7mpks11oh8f
X-Rspamd-Queue-Id: 3D0D8120007
X-Rspamd-Server: rspam09
X-HE-Tag: 1775409496-366517
X-HE-Meta: U2FsdGVkX19Emwvi8t0/aTSzeLp833sQK9wQfElTR8oXqLGXXx6w1MC6aTtPqdciSBC18IY37dnLgYem3qnBC2vcWGXka8Cej3N+2TBStcwQkOSdi4mHgeP2VJcp86CvZwHlMlA8OpbZ5z22prub6HLDx9lfiXlHNocEqJWNgsQwITNLnVZrOHWlpgSuYcjjlbKJpMBA71LfIgDbrVEh83ykndsVcl5OfpvscTpS/OWoB4Y2y1M5e0eOIaspeUO/Y/jJWGKe56SkeG5vdXwwJNwn4dK8geltCzA5wZiqliIYKsLq1jminSnKxpY0Ai5e3s1ZazkqqBt6s3enAmmYRAkR5H0dqIICB+sRmRcJ0ne/Qv4R2btvYTz4FpOSqzvAuVJX5zbv/a+4fxsBVfFVwEcIpm3/uR25dofFcdnYvN3W0ssOUHHxlhLHJ77Pbdx477YzfNrMGj8PReOtNeoN9OxCVl1WWHlXLs5elkkKyi27Zcr8NSRUY+huDumTAs9x22rG0hrW7l/uy8QgsyqwKcFXc7ZyMYGPMnGNqGEbnqZYbEk18+tWSyFA3VOaLcmVn+Lx5v5T4sCQoh3zuIZhS/WAGfE6NuqtALuWGsq+eRrVktxdaMk4zk7HIqSmkXGBgUrHlu0xAE3naRf/U9sdlabukmO3b4YLmUvdsIOyU348rB/DgrQnVmOGBMPL8qBesSI9M49nn36qkZi3FLeXHWJ9SI+DDlfWadPEtIvtY3Yvj1ZVSk1NqazT54S1Itefp8Y8gX4RUIw0RzmnbjyOw6GR4swSe2iSco1iQj7R1T+bTxfaFzeQ63Zs1JW/cwelpnFPXyzLy7IxB6+loKdvoWwVZRDmSbMYB+VJloEhZ0tCLIYNiJ0C+2wlnw/Vkx45Y1SVXJ0Ak86i7lDrS5QcFiwaCK4wob8jgMNvDAkX3kJUpCOY2PcKM4Q0YDPqpKzmuH6eGNVclCRBUHMKL2g
 1eECo5Iv
 KYtD6yDEN5rVWWzOMpHXf5FH4cAXTLb0OLvd1QqsQDvhfDD7pTSBCvvtdqyJRP/g9NxLvCSvcZYQYArAPWiaATZyEBepdPXC+XBOpHetXLkGlMl7NxqicQxbUlig3PIvm9uXPx1tiXDE6r1juXso6JubhfxVSgj5SRxwN7CR8AC5M7qWLKtMfNcrDYiyMpIGwFd3ur5k38BUI/JSiF6/gXqYzGozjD0VI0u8EKAgpqhoCW+OLJiPB43y/O/zDsTSFNhLLDp8FvRUQSg1rx9dxgtU0mXyATi+nnOpOdrhvfaVxctj5FieQ5MxxRk2wRP8UfmjWwUuzdAMGucS9h7QXqGgtfi3kciva/KawGHfiI4xaL31CbVl8LkCcZPkzO5ZqZK8TkURMbgJoKh4TNVroiUkoNFDeC64PG+aG9apV9qH6SlNM1is1P/lGsuezc1ZMJu2q7UILlVeCJh2r3jPzfOZqSfo0Obas13OkgRRbjnyuR3YIubJGqyd10XwzaZ7aKBDskvRj7NNlMCPDw+C8wV08Bglfd6PQMSD/gBOK7Y2fcy2lKjikWtKVGd0kfuP8hWunpqFwPodZgtQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

I've just made a proper announcement of kconfirm on the mailing list:
https://lore.kernel.org/all/6ec4df6d-1445-48ca-8f54-1d1a83c4716d@gmail.com/T/#u

Additionally, the code is available here:
https://github.com/julianbraha/kconfirm

Best regards,
Julian Braha

