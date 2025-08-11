Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD02C87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 00:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8556B00C6; Sun, 10 Aug 2025 20:52:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E68F46B00C8; Sun, 10 Aug 2025 20:52:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30C26B00CE; Sun, 10 Aug 2025 20:52:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C20D06B00C6
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 20:52:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64EA2BA663
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 00:52:01 +0000 (UTC)
X-FDA: 83762649642.04.B8B45F4
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5FF82A0003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 00:51:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S0q9O8H2;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754873519; a=rsa-sha256;
	cv=none;
	b=fDB+MROnkDYMs/7kFUPelKWY933tAmB9QYaV4T1RS4R4a4tVlzAXM6SbI0dUpXKG/5/8J5
	YBjJIMzT0Ne+SK7wtmPRNMiuKdg+FGt3shQrJncgC8+5RJ21+w9xf0uukpN66QDJenNTwq
	iagnBf2IgQjtVDwy2seMCciwr5s3s9o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S0q9O8H2;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754873519;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zv1IJoqgxHSXKcjtgFeyhterOz3vH8r5AnhGfX89cOc=;
	b=DuOfnA/8e8vOGm+vpkp/c85qjvLsqjtWqduGWfDttmh86WwdfXWKshwL0lDx3Dtjs3mKTF
	y7E47DO7MvhDBaxyoHOhei+jzq5TRv18rfU1VolT81VEjpqZAkxBdukcA2rlgYsP/10y2A
	THgn5fyJ2xYEMrtnPtYhxRLjJUFFnxo=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-60bfcada295so6376922a12.1
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 17:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754873517; x=1755478317; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zv1IJoqgxHSXKcjtgFeyhterOz3vH8r5AnhGfX89cOc=;
        b=S0q9O8H2UPbUm5eg8v9gZXXIE/QwjpyKYKVEpHGx8tLznZfhhXVfdZiYtGJE+c5tn3
         Ru2aX2iEannQ6gOpGWhYwgVd5XO8ZZm8X5erzKQYb9PYwLfUUmJr6n09qqwWCqlkYMSr
         mfVKWduG9atNQC1sfghg30DzhP+WEmOHfTe5wGVtr9mwjFaFoUYYjPnnGHq4tN34dLAW
         PGga3Zr1V2nsVLQ2QZZ6dGFHyFOmhX11Wko3t1amyysUOhZfeP+kkBNMG4BJ+i+5USGo
         8dqzRTM51k++VtVTrBLnYQ9ilGPvzXUBiCY2WebPMm2QuFbqjeCqXktM2LQVxL6pDcH+
         BG2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754873517; x=1755478317;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zv1IJoqgxHSXKcjtgFeyhterOz3vH8r5AnhGfX89cOc=;
        b=BBTKo7AF8twOpbECvuWKSapqscBuZujrM7bKSSfnD46riPl2W/zzQK6auKc4y6gl8u
         b4AQmezmCfYa+6PMGbpyJ00xxRZ0Q/zGg1PKFdqAeJqqh3AIuXv1nbWDVaJN3WEr/DG3
         5BDBD1vnDo//1HhqmxU38kcbvSY93vIb/OG2Ns7cOravYxSo+S1ldiHO/SrFWj0JDFjg
         s3QudwyHKOz0sWDHeG/TMF6BtwaWxmF+bSC5VanHskmsLTFAFTvDe9z5s5pDXp7fNgqe
         pVeLDLL5eNu0qAP49Eq7dlfpwZ2endzMaNnGJo3RoMgX5xDfw4O/uG9CKMQm01H3RSp3
         iLPw==
X-Forwarded-Encrypted: i=1; AJvYcCUvP+Yp4yEPux5MUxpe/Qbbwgh9oGNkFdZWohaR0fTBGo9sWfELOCx8l2y/UlouH2uxtUzJaDfVhA==@kvack.org
X-Gm-Message-State: AOJu0YxPj56uybT5nz8EX0m7JzjUi04CV6Ss4Qi8jEaTBI+LTzjmgj/x
	vN1Mdpv/Y98Z9PI2DRb3aZlhyL7JvZ6eiIztWMmmQ5JOmOJuFsGBz9lO
X-Gm-Gg: ASbGnctEX/c9Ta6i3tj9foy2WfcHrrKG1xToIL5sf5Gk2umzj6ctCV7XS8hDO5NTk1E
	MH+Fz2+B56siw3+kvH5TvWnbf4Nhoh8ZND+hQy/uvetFKKyNhy48qo/p6tzNqq04YFhJaXFKs/I
	Hivq34qKzzbbtlg9Aml2xrIr/OQOOYFHtzhvS2ijjBzuVw8f8mpa18i6pvHWEiGUlcGQ4kcXtW9
	6jRX0td0XPyR21VLrRPSBWVqwOKad5Ess81+DUjTluiXi0E1Ja4nOt7hw58vwqIIheu8sm3o0Wg
	jImUjLM2i6ro0172ct1KBbRKhL2J+6WubEKf20ZDW4tezS+5fStkrdD3pIL1MgASuvZTBvuWIvY
	ZSIAIPORBHxXU6tkgYsXYWg==
X-Google-Smtp-Source: AGHT+IHmYldaSBeO6dV/S7Yiju4l+VlWOSTR9stI/72nkU6ACRnZg3Ldx8ZoStARl/SNqNyVBZrAEg==
X-Received: by 2002:a17:907:940c:b0:af2:42e8:ad92 with SMTP id a640c23a62f3a-af9c65b2f50mr987442566b.61.1754873517397;
        Sun, 10 Aug 2025 17:51:57 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0a37a8sm1937794166b.40.2025.08.10.17.51.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 10 Aug 2025 17:51:56 -0700 (PDT)
Date: Mon, 11 Aug 2025 00:51:56 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, Wei Yang <richard.weiyang@gmail.com>,
	Zi Yan <ziy@nvidia.com>, david@redhat.com, dev.jain@arm.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: do check_huge_anon() with a number been
 passed in
Message-ID: <20250811005156.rbvgf4y3xhls2koi@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250807082707.30647-1-richard.weiyang@gmail.com>
 <0467FDBA-A2CF-4CF0-ACCD-760ECD30BA8A@nvidia.com>
 <207BD61A-5561-4E8C-B867-D1CFCAD37509@nvidia.com>
 <13D32FD8-FAC8-468A-9C92-23A1B61610C3@nvidia.com>
 <a1c64bca-9ed1-4d77-a838-4e74a35a1131@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1c64bca-9ed1-4d77-a838-4e74a35a1131@lucifer.local>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5FF82A0003
X-Stat-Signature: drnsdrd3gu94s3ernqrrmya4c4kaqn1z
X-HE-Tag: 1754873519-808760
X-HE-Meta: U2FsdGVkX1/9Mwi0xlhtWUXdti4qypRORmQiOV1PnR8NjbM8Ko18lwHPpWw22ngA6gSquOSrXJWYUgsLTMNlQ9stcLocRQeko2B+vlPWu/YEIQgxY8Q3INW90lAJrFWy04C+AMa3eDTlAC505sU3omkJjbAzqOYaAEPAGHQzCMcb15iifqGFAfFiOG+LjLkuaXz9zoL4PSvgoweatu2lL3HgzU8Al6LDw2wEXzvNzodYgpa8UDjueul7+uQ2WW9N8UN4efaYo/0qTkWiZokg2C+/GNnm5KekG9nJ5vEInKVJJQTt4zgLm7EZFW1D45q/VfnZ/F3vlnFCjV+nXCTciki1i1hW9qKzMO5/di9HRQ+UrQKMaEbGA0NVlDjerLRy7/dJyF11f8SGdYh//WaAbsyeV+VwvQ7UEbMwmzLIhM6yOdEFZLR5EQaTr7NDKDcPtsxs/lXuOeFstXeU6XA33uw4qgJfCX4lI44CRvCiqRll328f3OTIz0orzMf2S9GLUcbTeJcvVw6m/lLgP7mCLIfDsGRJMjvKGoH6Gj6t3WK/En8BHnvjdtX1MOlf8sFbE1JVQtxNYXk7zqblEkgNPwC5rSfZniird7Zjl+EViNMikKPldYz07yWQw3i5VQ53pWQDEQnqDfKQoM7/Ze8J7eJBzDZDpaVMVRwdoyPEL9u+b5/kviepMUl3crBBKaOqoK97sYhwKJ/z3R1Zu37bomHt49raIHOCGzuFU2tPVDOB6ay38BxKsvpMEkP7dsiC7WWruxmrriX42blHiX9nBqHlgdiPIlzuz+zY7KYXaO2dbV9odF9OeGzaWEqnlKklr204R6Mvfh+4DydLvHk/7OaoaMjOPftXCMIQm42+dnqIj3w1PYkQhNPFCOCk6TW+gqtGv4JYNUILbqCattY8TpGvY6QnOvO1CB9QvplaRhpGopeqMcGqFhmZ2QfgeGnIxpdSMMv7tnYmoBvKNxZ
 I0l9GyVO
 ZzjFomVj6mPgPv11Q6iztfH0/TMIlQKFThmXYGmoRd4laaCWRZsWFQ3VNrVvpC+HxwEgwzhd8grv8h7ay/3X4OG+ZOEP2WAoS3+pb/bh6VuWR0wuexa7Xk50vReyH6r0EHdJJk9lzJciu48fe5PW1JtooB+MQQQuX5ZwnLuUpNe57HUxaXUWDF13mYjPPIzJJmR1viwftpF5KfCpaViNo4CvcryvpBg348qYZmT/o1TpAjQbovjAfzBlcbRX1mU926SuYnP2EfZBw1Mmwugn23vtznS46EkPtQArTOsdmziYpil3YqAmHVR9c4fM+smOY9d3gdOTAlNFoOQmxwONs8hLuZ9/4DhVWHXZUzXZP6iDSGPubAR65xT6heC2ss6gg2nHXVWd9a8mDydxpf+l7ZHkMaKnuGxScnrWqfak1mSYGy5j4EeUCVqwtKwGx+5XIfS5Ypt/eXOfvv95yzMWXQHI3hNiYqUsV+qqJxJiGsuSg5BBNK+7jARmu3ogmpz+5vHzmHT25NRAyfNkfRu5VV/XvyiLQcOkXfaLc9K5AvHZ+/TtlK1UHRLkW8CjKvZJyC516CcGgyTr1VnmrOVfjhZTzG5qSxzCGBokZbt7zmwV36nPhtPzy5ttP0QJoMkGxcmAwkoOWZTdS5Y5cWZJ1Vjp/ktphKq9eqYfAeXqvB5FwpSxmtqyPBAdEU1/i6QPt5Pv5xijlW/UHR7/P7UMOch42hebzqbN8IMXepF77/8nIRJwg79OJsym81Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 10, 2025 at 03:04:08PM +0100, Lorenzo Stoakes wrote:
>Yeah just hit this,
>
>Adnrew - can we please drop this patch from mm-new for now? It's breaking the mm
>self tests build.
>
>Maybe then Wei you can do a v2 rebased on current state of mm self tests?
>

Yup, v2 is on its way.

>Thanks!
>

-- 
Wei Yang
Help you, Help me

