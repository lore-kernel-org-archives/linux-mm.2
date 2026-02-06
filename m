Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB48CEE20B5
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 16:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310E26B0092; Fri,  6 Feb 2026 11:16:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AE336B0093; Fri,  6 Feb 2026 11:16:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B0BF6B0096; Fri,  6 Feb 2026 11:16:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08F996B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:16:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 241C6140251
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:16:38 +0000 (UTC)
X-FDA: 84414534876.19.55B27AA
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id A933940006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:16:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b="N/y0NUAV"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770394595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXBwmNKPEdoE0IrxOXoigu90n3lwige5LY0Xe3wI01M=;
	b=af7WRloeUGvotvvlRX/1Lms6gg/91gQG5kRFX/7GrDkeEiMx/IaqjzPsebFAg6mBZ1oiKF
	6MWU8uJ1ApspEo4Uaqbk0/oFKTkcWIOgM4gKaOBuaoOABFDpsOo+OETbX0KM2v4etfDJ/K
	Tna9dMoU+DALJ/5qpW5gHcBO7RtYKwk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b="N/y0NUAV";
	spf=none (imf12.hostedemail.com: domain of boudewijn@delta-utec.com has no SPF policy when checking 209.85.218.51) smtp.mailfrom=boudewijn@delta-utec.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770394595; a=rsa-sha256;
	cv=none;
	b=JmSrK0YTNWtr04mOctiPzrqyTAHlVChLV7GHe7nsbBtkh8GK44g9U4wfRl68BfZojw6tEy
	Vkzk32WoWboj1muTjsZV9D0oatM37x4GI+MIO6Zl1EYyY2o+Q+1JweAqZtIoAWs8EaEa9b
	dBv/zzs5E/IMz4b7a3jpXk/1gqRAEas=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b8876d1a39bso124004266b.1
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 08:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delta-utec-com.20230601.gappssmtp.com; s=20230601; t=1770394594; x=1770999394; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VXBwmNKPEdoE0IrxOXoigu90n3lwige5LY0Xe3wI01M=;
        b=N/y0NUAVVlCJjjhXJZLp7wZKt1UP35NJycbhDCuwVeFiL1InRAHqcMhBiKJqT0XvKg
         Lp0hVOlm1zwqMXlQztQDJmoGha04ZhFamtATkBW3K0TAlGKlhWLo9Uo9AY+3buY/H7Xd
         AHmEfNdovIeY1NVOk6n7tvScQGnBYwcIu1CZpnKhDKjPIB9FuPM2dN2esCW/M9HFDW/I
         7fDOhk6OsnJea/Z8XBypqJUyhFV2izTV1vthkg7CttnwDZhSeNL1gIbXJG68vzDi6sZ9
         hWfkAJcDE6QjxOQwmJvhhhkskert1hPUa/UEDQkDI0/SBUT4RBVn/S/RIV/2wjIsTnNf
         tmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770394594; x=1770999394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VXBwmNKPEdoE0IrxOXoigu90n3lwige5LY0Xe3wI01M=;
        b=FcebfHaJg/Tnz8ysdtNK+XlPKKgXY5t9c58zowfbnhCC5MrtxWx54iJMF2hFaZcVC0
         cDlrwNTvZ4tMw58CyHeqeOTiFEMfJ6MJlott6oJca2JOn6/q4SHzr4W0mHXAzeKMC8lm
         WLBNXSHtc5tOTrOGNrnECQqKLZEO497MQhZ7/LlmC4ceEO3JCRISgdulfEKrZFya71k/
         s4bwwkVBsVN9Psxp1N8fXK9wSavHqjEkJ9hBvigTxgWJZ9n5PaB2YJxGNGkJ2gYayAcI
         /rSsJCkzbwM8fP+wHoCE7Pb1vGXRe/4zHwGmXaENLx0LNtZ4OSKCqmUY0ivh6oDROYbS
         5/fA==
X-Forwarded-Encrypted: i=1; AJvYcCWParJWODXZdhWYpT3ZLCj3QZdE+Sgnh2FcbQt0c1KN6C1Lbek1trsk6EfAkA4FZJQGrDyiFoy9ww==@kvack.org
X-Gm-Message-State: AOJu0Yy5FPg5TTn/DSI4/LaARdDss5UWy5TDJ11mwUj3qswwC9JqF32N
	1dYwD5Ex0I3/iiyyBqDNnGuwLb6hh4AQupsPHOT8FI0KZwZ+rqA6CaytMWlCTrh3og==
X-Gm-Gg: AZuq6aKIGCq7hiuMOOs6/lAJl4pGDAtv62d0SJvHNqR5XoCYs6brhPVqBAw/haklSMy
	cz4RsobRqvZsZAGJYOaCiYN77XODHUVEV3dvKCKWbM+bAOQT/bUugiATh/T6bT1w5J+74MgX2TC
	rJDGpEO3YwDbnaFMjwjsAVqEJEQTk+EEwhmpQ8be1QOiKU/Q/HtJ+KYF5pv9B3BwTs1JuVti77o
	/pJXdkLhX1gwcNrftvAr+QLkkwzk00c6MJHy2pbMb63qsgNUKPFCV5mnbox7NYPiJG8X/8wjmKj
	i0/RMK2KluHAbHVAqd27Y9O4Yvy5rGxY+i2KY11H2hpMlDTB8WTzy1jvwpsu1H2Y5SDu64AOehe
	WyGhoC8eZj5lT0dBbwX6J2g9K9X2DB+gvONVOLVrNrr9NBDDaA+qtZHdaXb6SY82L4H7VT+ZUe/
	HLu6rob9Oj4H6QiwLAy+cQfYZMqDfN+g8T1Fy8hkN0wKyIvKu6vSXpOKOOssGuVElCmJ5Bm4jqm
	8hnEE0YrKfSOvYjdhnrExHHaMjGPbVkM3Gc5qcuV4O19Vl+ug==
X-Received: by 2002:a17:907:3fa2:b0:b87:324b:9ae1 with SMTP id a640c23a62f3a-b8edf351ed4mr193961466b.40.1770394593703;
        Fri, 06 Feb 2026 08:16:33 -0800 (PST)
Received: from bou-desktop.arnhem.chello.nl (2001-1c00-3406-8400-a56b-f885-268a-3912.cable.dynamic.v6.ziggo.nl. [2001:1c00:3406:8400:a56b:f885:268a:3912])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8edae3c255sm91818866b.62.2026.02.06.08.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 08:16:33 -0800 (PST)
From: Boudewijn van der Heide <boudewijn@delta-utec.com>
To: ziy@nvidia.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	boudewijn@delta-utec.com,
	david@redhat.com,
	duenwen@google.com,
	hannes@cmpxchg.org,
	harry.yoo@oracle.com,
	jackmanb@google.com,
	jane.chu@oracle.com,
	jiaqiyan@google.com,
	jthoughton@google.com,
	linmiaohe@huawei.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	nao.horiguchi@gmail.com,
	osalvador@suse.de,
	rientjes@google.com,
	rppt@kernel.org,
	surenb@google.com,
	tony.luck@intel.com,
	vbabka@suse.cz,
	wangkefeng.wang@huawei.com,
	william.roche@oracle.com,
	willy@infradead.org
Subject: Re: [PATCH v4 0/3] Only free healthy pages in high-order has_hwpoisoned folio
Date: Fri,  6 Feb 2026 17:16:28 +0100
Message-ID: <20260206161628.78161-1-boudewijn@delta-utec.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2C382EC0-0FB7-4882-8B87-E467454178D2@nvidia.com>
References: <2C382EC0-0FB7-4882-8B87-E467454178D2@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: dfxm5ygp7d5rcoppyt7xtb8rzrawdtyc
X-Rspam-User: 
X-Rspamd-Queue-Id: A933940006
X-HE-Tag: 1770394595-687104
X-HE-Meta: U2FsdGVkX19JJiSLVmQL32yU7t0ygAFxxRNd5Wtv9oyftbiESnsa05J3nKEPSk6VkECaeAzhABThn+Q5pT5BAFNTsg31i/Tvvv5PVqt9F7PlqhdvEyNJY0lbY3nyl+/cMuXGmzXg99+lZbSIibUdPn/9q+Bnb6JGDz1sfvZgFpKWk7pF4PBPV5obIE1InQ60omJefm5zYXEjjLeuP6ohikk2/sJBhshlzCLhJBX8G/xbAIH9wrIl2kIi0Rf1LvWxn/I89ZCyPDkxVJlPofE+J0Tvft2vYAaGzHEwR1sfJkLeCBximrHi4aV/TmdVSc3IAoasTFdLTrKL8ymFbbrRJNI0oDfgBt1co/A5Sq4zE/ojvdpdvJB1uMf+QE0527032hNHPD7DPPrHTy6DMNgmW3Bys4F50qYwKgMRkET0XNWGFTaN90kLiSMQyu/tI6IVQMeS+A58gt4zcyg4/MbCpCLFmDSyqcdOc+LAHbfuWyC0SZWZEguBbW6aernF8UtdAH4VfmWk/h3hN7ev2i/UlcxwTFGU3ea/2WsdpJOVh7U1qAOa+wb0dnR63ydfImcDTDHBF3QkORt6YI4yRAyZEa6/Yf4U/6Z/Plg0QvrfSIqT3MbqJDvWbY4dROhYDzqLmV8RuN8suTR1EfjoZ3NecGQvfWwXSvzpOEpB99KoXudI9EnKqgLOdd/rRy2ez3y0cn5A7qx0Idwr09sYUcbxiVhz3K6VL29SN1EAmhqiDTdLtreRULiM3Y2W62co/M2eQ4hh5e0jOnACnXoVDAj+C9cvyY4DPaQ/fbddoIhZWWZN6JaHxbYhJHJ4Tc9Mujo4hzXoejLixm1WuuZRM0aK1uGtHHen1h4HbDaNuOD4sXzJY/6jpIY/S92ALz17qgYBFiE/4eZNyUO0xBBUTMY2PQSQ5bUVDSTlhmeArovCs7UFWGkl8ttXTZbNakIrZJWzcZOXRkk+J2jVpJbb2OD
 cDCW/qmn
 9B4RAHgkR8zuavyfrNHOO1fxg6YGVzxY3FSg17B7Og6/se3YK4/kCRUf4r3BYECIinN3848rNhcIKqn2HAmB1vcdtSokIfZE6m85G06FYGn8DJB8tuBbbbGi1OkO4bkUu4V4pDFpvHng1EcM2+hVxb1MuO/XQkK0hxWe6PJq6engJd9ybwTmNTSaFH12BvpBvfDinoysARyF/6z9jjTxCwFwvJ3wF2HH9Pendugrt+MIygg4QY6XURyvlLMfvqrQ1vs1zRDmutuf89cBD37sPzywCyPbMevjb1wxPQffpJ3I8guIT5j3eaSdQGFCR0sMYF0m8rYqwSmwYvl/tA6/OkwAlzmvVkR8f/ODeLR3f8k4i/y9sGibndAvAk+F9ImMuwTmdzvd6R4CsbEHZQzuAwPzSsiGJ6R/ZkK7Ha5tWlOXPTjEnGyo+iU3Lc3MtKDUS3Lz7gCcU1Ejct+qz5K1elqrzbii5VtDaJHwFFAw1rEINsLA58WMMojBg4+0drutvGugHurtcsCY/JImTc9t1Qzrikeeyb6d1MzhmGLrm2xFjsSxM6fWPMKtoYnWnCPcekLa1/qzXq85AJow=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yan, Zi,

> No, split code[1] sets has_hwpoison flag when it split a folio to a non-0 order
> folios. If you do not see it in your kernel code, you might need to update
> your kernel to latest stable one or one newer than or equal to 6.18.

Thanks for pointing out the split code. I went through the callstacks
again and I agree it propagates the flag correctly.
I missed this initially.

Kind regards,
Boudewijn

