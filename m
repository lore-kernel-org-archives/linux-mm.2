Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42BACCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 11:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5D786B0149; Fri,  8 May 2026 07:33:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0EB86B014A; Fri,  8 May 2026 07:33:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924266B014B; Fri,  8 May 2026 07:33:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 805736B0149
	for <linux-mm@kvack.org>; Fri,  8 May 2026 07:33:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFCCA1608F5
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:33:21 +0000 (UTC)
X-FDA: 84744041802.09.3A25192
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1ADAD40007
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:33:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bE2J9PfS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of huangzjsmile@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=huangzjsmile@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778240000; a=rsa-sha256;
	cv=none;
	b=w7r6B53cPzDtRUEYWmjC9TRlO7PfKtaD7ENiS45/NHIvvM3f4CcT3EZV2Sd+/+D/X4MLb/
	qVARThai/BIDVkEtwJaerQS6Yby+6iEKkKEWc3mrnd9UiU9BlW6MeQ9ALwLrEY58xTRuMb
	sU/tPkWWsMpbfbQGSk6Ih/AJhR6W9YE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bE2J9PfS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of huangzjsmile@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=huangzjsmile@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778240000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hKWKUjZIOmqVp19EojvK+i+EeroKEm/+4BJnuazyz7s=;
	b=tzbyS7p/UduQbUOzNuJHKH/v1n0IPFT8XXyuO2pziBNqQ21OsQ5rgN9mJbnvNuZrAzM7wU
	pMN1/uci+sR9bzbgEqYpJmGxZzUNhvxYCpgq7reXKG5LNOCHM3wD5fYSs5USZEqxM5JIya
	7imd+R+DEjzNBQ4qm/6poheZ2AYy/Qs=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3664df30f53so276793a91.1
        for <linux-mm@kvack.org>; Fri, 08 May 2026 04:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778239999; x=1778844799; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hKWKUjZIOmqVp19EojvK+i+EeroKEm/+4BJnuazyz7s=;
        b=bE2J9PfSmvUw51oPgTo3sbJ41YHtxDrmBHeU0P8jYcc/XfywBlSRoyhCiUdw3hTAGm
         ufcI+hPP1HOe6utRQbY6N5RyFs2WcwYohdhe3S9phbKYkX6RTBtKGSpOuUKPhmHgN1oQ
         y2zPEqeYkL8z3EEGFORBRuBbZ6+v80tQhlyTJAAak4OMOjM7IO4DBTUWdp7ylLBSIMuh
         fota8ZxOWj6D4um0rxav9/gOCQgngyyvx2+GgqZHX6ci8bSgcjf7MIF7djqE9osU28EX
         8anuZTIoKnuOg89KRk3VLTF6oBqXVIPK9+SV6kApEWQdhP4Na5YvzxH1rRBeovVF4jVw
         BZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778239999; x=1778844799;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hKWKUjZIOmqVp19EojvK+i+EeroKEm/+4BJnuazyz7s=;
        b=tEKWH07BEwY34jQ/di04Nb4MVBSGndnTWeG5LEZSF6zfZCbfw2zy6w409v6BCUPJQZ
         LtxFI/f7ypFaHJSgI/SxtbLsIArEfvpSF8bAVPlau+aieZu/oC7QHUPIUKNvo5IDxf55
         EXeuahJypnSC+L9++8Jgx1JtH7evcGGMmD/X4uXqWeJS/Fy5jXKKkY2RBuSAv/mvHfEd
         I/Aa2gFCnLKMtLw/Xeiz6w/Me1eVWwKDFWLCSuDfN1qXKoFgPOAmxpe2XXtQdgMzNaxr
         BrU8ahu4m+Sq/d7rYLrwxiajSMP8um9rqmCyc496lmnbDgNlGpbGPXcViCTuKkr8NlVV
         auJQ==
X-Forwarded-Encrypted: i=1; AFNElJ9nrH+X/MPC79/df9MAgOYdtClZ9gPY4SzVa79HGSX0WfUHzSTpK1gghLxDXwH48XzlG3Z2JPSO7w==@kvack.org
X-Gm-Message-State: AOJu0YwJb/sVG1AJP4WEiyZEgv8eh2BaroAp68oWmLgSSp3zdt+2Zywr
	12NWD/h6DrC24y1+ER7De7OeehYOXsKaHIU/1KUXW155e/lAZhY62NDl
X-Gm-Gg: Acq92OHeUWARDcDnsgSvTM3k0gaTwMgADt20PI1D/7bSq5oXg/O55VDfxVX6ph0d29e
	NVsEmstalijwBjQf2j9e4pyzKH9SFGRhNRLe8+XO1razUYX7ZcFQ2Lyd3vQLupUD0fELi5tU7fi
	HWS5Kp5uhsU/UII+sfY3AikXYOoe93ASWRAoQzCFLowvRH+q9trSw6Ct7spiPd9psFsb6T/D6oK
	8I3ooUwIlgRZ6lemjwtG+k2VSpAl8MLqJL9c+Opb8jaROih9us77Vw/HIJtLDnDoOps9Feq1pFs
	wv+DJToUyXaxmaV/k1GcqP8hvmfH4KpZHdle8+1gmJWOHggBsgySPmAj8LY2qWX+d0Lg9jqE2Kg
	OB3/6iJpMs8h95PIg5gpmbjrgo7zn+rb9O+MYoulQjVPVI2UnuUJRlKn4lCKWmjbs8IyPdmuRns
	46VraljVd5Ewc81phuNIVW7slZye2j6N5UwuFyzFdKl43UipDrHpOFbAhSx8bA
X-Received: by 2002:a17:90b:4c07:b0:35c:30a8:31f with SMTP id 98e67ed59e1d1-365ab3e5b2cmr12180347a91.2.1778239998719;
        Fri, 08 May 2026 04:33:18 -0700 (PDT)
Received: from localhost.localdomain ([14.116.239.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3664908c8basm1056532a91.3.2026.05.08.04.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 04:33:18 -0700 (PDT)
From: Zijiang Huang <huangzjsmile@gmail.com>
X-Google-Original-From: Zijiang Huang <kerayhuang@tencent.com>
To: chrisl@kernel.org
Cc: albinwyang@tencent.com,
	baoquan.he@linux.dev,
	bhe@redhat.com,
	flyingpeng@tencent.com,
	huangzjsmile@gmail.com,
	kasong@tencent.com,
	kerayhuang@tencent.com,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/swap: Add cond_resched() in swap_reclaim_full_clusters to prevent softlockup
Date: Fri,  8 May 2026 19:33:00 +0800
Message-ID: <20260508113300.3977280-1-kerayhuang@tencent.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <CACePvbUy+rg9YuDAikGiV1_W5tV8XJnpdcZ8qy8zRqBY0x74aA@mail.gmail.com>
References: <CACePvbUy+rg9YuDAikGiV1_W5tV8XJnpdcZ8qy8zRqBY0x74aA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tjmmydztiwkcr3xancjix5amg8g73gso
X-Rspam-User: 
X-Rspamd-Queue-Id: 1ADAD40007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778239999-280207
X-HE-Meta: U2FsdGVkX1/mlrzJRd99NXGsYGIyPLb2FZ4197j//2r701NG+7owIUKvGm7OiTm68bB5djC1OaKhVW4p+9IaKVtjQjwuQs8Q/uB5rbIMRr49SsHLuJnr0+GoP8nduROLg4OTHQPp49iPd2ES+TRl3IhPUIZ7ual+GdbIBWy7D38XspgboVQcCgM4znGSM7TiJoYuWBlFKol1CWqCW2VKMU/eEgT213rRhqXVfE0LxsJ6kw5JbkS/lPMSVPXL2I1g0g1xWNM5Zd8DVAkTIOm59hQB+VhMeCpkH4/1nKad1Zpn83XxebWvSqlV7JxTg9TqM7oR0DQQ5M8/GtPXN/i++X5iW7fR1LHhYo8czo5jpataJjbNh+GED2MPPCsECw9DCklUCQwrKOMh1AWxzh4mAAgVzDJIwaiW05tMRaOvXfzLdDZWzTpuPrOa5UfZx1hTXR4ibwGxL1cAfSb14oMY/uMaxGDea9JaCXRqlNUMLj2AyXRbAdxwGsQ1CaeyaIqB6KcZ2Nahdx69aJeMHSu8sAhgl0/5UIPYv1QKC/D1Xtg+XqVxO3PrTWUP0jk9PyU34totRtslmt/hi2MrHQfw1AAUTDHwVgq9zv822oeP8KGCVpgxajGXJMe3Qr8NCCy8U9aPrBxEbAXFkot841brcpx0K0T5sr4HeVyIZ2zr5gaTqJFEtao6wextnZLZkRrYQFmxW9/uqopMnJVKDRZH7Yx8yOO8Z/Kh1Hl1hcIdkPOkI3qAnFvelPwP//eVwQe1Mws9mIM1xXDV/MzOWhdRjOY/u+t3zUlwX5LWBCtATk18ioEH5YxsFBMe7eDVWtbA+sE6OWJAHXgUAb6a5Vb5BBdvCtyaRotNvJAq5kn1lpzDw00fVWQSu7ScHoly6up3ZXtlxjk6M8REyP20MfWRoFoVavbVd5Bw3U9D5i0reuVI/BFINpDXQdwgwRY3k4uvHGffQAkYN5Opl4hYzgK
 yVVZLVhs
 fnDXz95TYcTchnA8gtA2sPCGbkGIpyW0GsrO1KfzZ8hpvvgFePsHXtkAZUUhyWTSaF7SFzWn/kB9dgg7SNM0qf9kEejTJ3i5K4C2fLY7s2tvh6WR6Gq0KoWiNaTd4Y21gkVceGBn67xUfCas5dctcI01ZWgCooeGaDyAwpNnOeXFDwHa3rVWeN+xeL/WHoJk4sArLKwT8qjIs7fh3KZSElKDpL9js7m2SS/64MzkfvZMNW2NN9TbV7twuM0ygyWGfnufTg13rAK3u2/OFY3ltYMRs7n0TPFjQs6WKUfNcRaL8/e30tAKFFWBu33it5qpgr0H6qyc9KHjBcEAK/u48HLC5U8SxX5v/nHeMits9ug2uhxKIk8qr5uuJep6CH/LQYq5WajOwhLxqCIve5T/nuCc7PrWGgr8N5+PRKTbzGbEiJ/I6jkUdkqaFLr001Wzn0E06
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>On Wed, May 6, 2026 at 4:56=E2=80=AFPM Zijiang Huang <huangzjsmile@gmail.co=
>m> wrote:
>>
>> We hit a real softlockup in an internal stress test environment.
>> The workload was LTP memory/swap stress on a large arm64 machine,
>> with 320 CPUs, about 1TB memory and an 8.6GB swap device.
>> The system was under heavy load and the swap device had a large
>> number of full clusters. The softlockup was triggered during
>> a stress test after about 3 days.
>>
>> So, add periodic cond_resched() calls during large full_clusters
>> reclaim operations to prevent softlockup issues.
>Thank you for reporting and fixing this issue.
> 
>Can you add that to the patch commit log? This background information
>is very important for the reader why this change is needed.
> 
>Assume you will update the commit log. 
> 
>Acked-by: Chris Li <chrisl@kernel.org>
> 
>Chris

Hi Chris, I've updated the commit log with the background information in v2. Thanks!

