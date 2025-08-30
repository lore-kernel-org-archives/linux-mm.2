Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DE8ACA0FFD
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 22:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C9CF6B0005; Sat, 30 Aug 2025 18:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A206B0006; Sat, 30 Aug 2025 18:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18FFB6B0008; Sat, 30 Aug 2025 18:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 086A16B0005
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 18:30:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0D451DCB88
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 22:30:30 +0000 (UTC)
X-FDA: 83834869020.08.2E396E4
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9B8EA1C0009
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 22:30:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="cn/esNA5";
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756593028;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8MnctxU6ATOf/IhsFdPXoMq8IG2wmGfWPzQafTwHWU=;
	b=vVfiqOkShOMmP/qFzPeFjjbx0TMnPYtB6l6jvD19gKixo2Ixuan8LkwWdBnWCrv6c08QuN
	yXaEE7qbr+nVKFh0PibIslX5PAHAFWc8fu1ln6HAyMLIEoSEV5aqiYyh6W7zVBEsbGNio3
	exRwOyQBTaW6AkcmL/wzaJaCLoM2Sdc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="cn/esNA5";
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756593028; a=rsa-sha256;
	cv=none;
	b=EcAPi1EWydPZ+K9h8cwyCaeXXsJyu4Jl2Z6kO8bDf1ufY/21CQS9yNBxjGEYIBnflUtfdN
	bYEqOB3+7wCGKLTABgEEIXyckWzlFnKupp28g8927Sxm0jqCvS6nwnGmYIw99xb3M87N4y
	WbLlC8a23V9daTLEvBodj8Z9GIj4hsY=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-61ded2712f4so58108a12.1
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 15:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756593027; x=1757197827; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y8MnctxU6ATOf/IhsFdPXoMq8IG2wmGfWPzQafTwHWU=;
        b=cn/esNA5R3X0MvQR9M3lLqa+icKb6Rw8A77IwWG46VsoIS3ItIcmFYzU/N+d1QAN91
         t1MVRiox5hcTB41UKCgaAlVZP29FyUpPVoXNKNtW0UmsZpcs/wGGvLubfUMBucmIqmNh
         uDziqsHpe67XE+5hxVsgBWw0Qtyktat7KH2QF10u4IoDszTKNUcD6TiSjv73kNy1gVep
         nVeBEBVF5Heu6OG84EZKt+KvAOYOIL7IB8L5ENwzyIBxtVxyxYXueZJWsaK5bSwBb8aI
         DNd33ykxwsYmuA+nu00c84+Hi6VHZrTt5Q0PI/qz27xE2Tf8t7Svcw1XdUBzWFiyeeBH
         6qjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756593027; x=1757197827;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y8MnctxU6ATOf/IhsFdPXoMq8IG2wmGfWPzQafTwHWU=;
        b=U5YasnKDuhDcGey3t3FGTh/+Y+KxflzSIPC2vsO6SOLGlpXQC4b2yWK0njOSvyMAVj
         ZSXKcki0EtWZ0hVt28L/9vi8ifSPS76i/djxwR4OOubd7x3Tapwq1TcE6WzylJuC/fsb
         u+NT5DMxiqEyxebugTQL2sZdi0Fr1zGudRUdWAIhTicGWkTLZOrOXLTCOZ65BIYOsNJP
         uwAES0YHOO6tEDuHP28ApCFGkexk+GrZMaUkSl40ppudQB59dMokzuWj+MLvJOEc8BBB
         /Q/zbRgT1wrwemA+z3ChyrUWiAtjA8X77+uI/PP3i8Hi1kc5Vp4VVdJI1y/vjRbJZuwK
         Hr+w==
X-Forwarded-Encrypted: i=1; AJvYcCWcHtZ8fV22UioQfoSpRti6FF1McZYuKGE/fD1TnbY8WsIWHeoNXQsoULEHpDBFiibte4XfTwcoug==@kvack.org
X-Gm-Message-State: AOJu0YxOAmK16hq2WapGo4F0Qr6XdeGPFrOSrl4rLpK/Cu+Gz29DIT/6
	oLIFDXvzRyhwvXHODgY5HiYtCHXV1jold4nQPjj9sYPWcL9BL4vtzAUU
X-Gm-Gg: ASbGncvzlrA+VZ9uiWEt0H0UxwvNt0bGq+DZ0AqQR4AmCdAhxxPYJYzY91xQyZPA2bN
	MlHNPe36/S7HhZRCoaQTfQPuOZLyZHnxNsHQZERd9YM4o0BrtcCFCn6+JP0FEzXd18E3DFRvuiL
	yB7yaj4MJDKLOljBJ7WTfpRAs16i0dbI/Tsn52ie+uFRtYW0rLbY+Tevi4jLud2POaQToqm7L1R
	Q+r/cyUlemRmohvUzc1VyW3PpXMa4h04GYMJP3m6kbWOZNjXkw1nMpcrdXltDlHV4PhmwAhIK9J
	SFFUEm1n7WQODn115XN/3nA1kAMyAeEGAblJvxZXLDYXjls1GHp1bRFLf8SZj0uYhZ3DdiNt2SI
	XZ5mKxpuXX5V3USOfd4ro+BLcq50B0J2A1tvU
X-Google-Smtp-Source: AGHT+IHgIevwvPJgQjugv5dspNkhBDjgRpzWgftt1Ak0uBVHjapJ8gJPgLVgUmwdqoDwaFYpCFFxpQ==
X-Received: by 2002:a05:6402:4307:b0:615:77cf:782e with SMTP id 4fb4d7f45d1cf-61d26d80521mr2521515a12.25.1756593026831;
        Sat, 30 Aug 2025 15:30:26 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc214bacsm4314351a12.16.2025.08.30.15.30.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Aug 2025 15:30:25 -0700 (PDT)
Date: Sat, 30 Aug 2025 22:30:24 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Cc: akpm@linux-foundation.org, richard.weiyang@gmail.com,
	Liam.Howlett@oracle.com, davem@davemloft.net, david@redhat.com,
	edumazet@google.com, gnoack@google.com, horms@kernel.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org, lorenzo.stoakes@oracle.com,
	mhocko@suse.com, mic@digikod.net, ming.lei@redhat.com,
	pabeni@redhat.com, rppt@kernel.org, shuah@kernel.org,
	skhan@linuxfoundation.org, surenb@google.com, vbabka@suse.cz
Subject: Re: [PATCH v2 1/2] selftests: Centralize include path for
 kselftest.h and kselftest_harness.h
Message-ID: <20250830223024.sgkgnupykrif2v6f@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827144733.82277-1-reddybalavignesh9979@gmail.com>
 <20250830163949.20952-1-reddybalavignesh9979@gmail.com>
 <20250830163949.20952-2-reddybalavignesh9979@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250830163949.20952-2-reddybalavignesh9979@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 3865sey7gaptck11cg8fpzbsce4kyadg
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B8EA1C0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756593028-95593
X-HE-Meta: U2FsdGVkX1+egaRxM8NadGYLBp09UbvZTrjYwSJp+/ff10h8V/7+6lmwhq/HcusTAsdEEGZzzbvZn8YiVWwkzqiDnbtRcFDieMFVmH3qyvhi2u8XTO5LYE5OzTFP4l6hGpw/GKX8o0/rVV/mI73tY4hZczS80jkPl1JupY/0cWcx4mXae11gFal7SMp0ocidXOgBhNX5L8Gcrzm/gR+SmiN1W4Z3JU15f+8cDSy8LYdmkLuIRIjPwaTr8nfoOpRzC0Hpg4GeXjPf93KChtTWvBvRfQNuOrfTNs3+IpXVUQ04I0AU8UwBvMICzjZp4k8ZWD8Wv3IkkxCwumrycYejDo3PaTK+TejGA0jvCu3x3mbDnaQj22U3JBFV1VxEchY9Ztj1vrsmQDs3arWKcF2ew8ZmPK9AjpANv5YO3r3xQAmXP4W7eU6VLEkfeSs+l3/jn1wsOrWsb7v83oVDBCOEHOWz7zThnfQcS91S1dGNV8lsWwoWxp4sT72RJMeC8yxxaaXhjiC8HXs2sz9xAANW8vrzDrZMPIieMlBMASHMTL6pZH4cb6VPZnAqQLjr4EkJcS3h9t5Y5j/5mQXwJ+mnfeeXaFIM1uFoTGxXSFMSNN+68upfZLujId04SokaoEQtNHmBn+xgJunICVC3wFJTrWB9yXee9mrCUqNgBHb5PjcQNnba/yDNcw0HpOH4TXnmHVU6n5P+DB0L1ezMtCy/WLMGWXHNGj75QzsyGxgGGmo3WHrjFNzCHldf4wFmAx3odYoCCul+1wqyHPVLxG8g8zBrazR16VE5tP9FsObCAN/69Gt68c1l/eedwzI/Y9ivAsQi27SOZJ7kEpggxyY/HOw6lI9llw1/1VGpW1kfLyb7M3Sfw7Lisy9ZYrGXwmOnfPNzX5wZyt05b0eHb1khaWkeo/v9fLfCkd7LliFCpLhhJpxQuNpDEotXPNldgl2RkqePkZRNcegzaOHzTFx
 YwUSEJyJ
 10/EhaD0lLJbh81YPaNqAgR8aeZhMZYJgqQWy/PCsklcvt8Cg/NexsO5g0NmtC2cI1F0iiW37s1H8EquE71X/eN79qt7KfujObKRbB1322HNNyJ+Tqyr6vAGIoYb2lFfbvK3aaxK2PWlPBO3VusfoRjIcHnbnRIMXe3RNtE9G8AIwAGJxA0/ODNBP8Vmbh4tzyAcQO2l93u5C5yhJ13/MKKuPfIlzU3FGKuZMhdUFAGOlrPxoNhK2e8FzHvxxuTdP+1WVnNpyQcn3qZuvl70S5J/zyGk+F9pC3ySuXM6/xRXQCiDAfa7DlzeOhfO2M82/FZAgfYZbnZyIqAUJrah9RGY64I2Fm0z5+qmDrCF3cBn/XeZF+dIC77JOIrZ8xjZnF0fJBP9WXFViI/B+CSxK5OsbQp+VXokna8/Gdk1jccXvaXbNsvtcopdr18LB5cG/i7zioAv9lxsczOvwQ4m1t2TIZ0U9s+AZPPsZPdPpK/bcpTpMc8CjMeLLU8SU51+27+MRd13BPG5+4891h/VSduDEN0AM6/zj4TFIkArVXd5wVDlEErLvRL7Dz31ebOrh87+II53EDDexzSn6fqv4+GMb0uxcJL+DViQqeFoD2xPbaJogP2Lx9izqletjXirQKO5oE9OaS+m02W44RrLFKwEtdXIZl/ZerNlcpWdSX9l/4prwFEJLjkWVdL5TslYlnt1vEVUPzQu3U87Zs2UdBqSulg/BgnfPfjxkGjyUBblXI1x5ekdc7DDwc3FIrLeM8BbNzXXio6Vz+dN9yxJSNaXm6VjZV2cIYYsOGjFon2mpjk93vOnB60IfJp16chHBxKaS9AuH5IddRWmVtw+SUpOuoCoMnq7pJ+w7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 10:09:48PM +0530, Bala-Vignesh-Reddy wrote:
>Add compile flag in lib.mk, to include the selftest/
>directory while building.
>
>Suggested-by: Wei Yang <richard.weiyang@gmail.com>
>
>Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

