Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BBEFCA0FF7
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 10:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0236B0029; Fri, 29 Aug 2025 06:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138B56B002A; Fri, 29 Aug 2025 06:53:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF3FF6B002D; Fri, 29 Aug 2025 06:53:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D694B6B0029
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:53:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75A4D1196F7
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:53:19 +0000 (UTC)
X-FDA: 83829483318.21.779661E
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9410F120011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:53:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i74JXfNn;
	spf=pass (imf29.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756464797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfWM5gPtVgoPnOifkHwbxrGhPNxVzmmMJ165dTe33yA=;
	b=OQCwwHWd5L9iil2/dzx7Aokt1LJYOn3RrsPN10TF3bVaRUa6Eqv37eCEGXcDibS5ZX8ulB
	1G4jXmrp8crWPFJjjMuUABqjFZgki5HBC/f0DM4m/d08UrIonq2JO0LfUDcLk5SaXKwrVr
	XVrRIk1MZachY6T6IUooJSCaOZTEXzE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i74JXfNn;
	spf=pass (imf29.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756464797; a=rsa-sha256;
	cv=none;
	b=RVwM3axSXR0TwtxlDzIxUusAcsi7XKSuwmEDBZ2k/vL8JxI0Hc0wyIAEh8wxD03Lz1MkNE
	mZxEWGk3uW1I8tzW90CbmQRVHI9V2jJRRoc+jtn1B4sCpKssqT4v3s1WrEy39mbWoGAIfw
	DlVGKbrVy0mUz70B027OqUJm3UxCnzE=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-77033293ed8so1735754b3a.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756464796; x=1757069596; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hfWM5gPtVgoPnOifkHwbxrGhPNxVzmmMJ165dTe33yA=;
        b=i74JXfNnUkHAc2mnfCiV7rbxKEfq897uIo0sDdngLnqwchpcgEsKJq9dCAciJ371ot
         fpFmyPOZsXi/WF4U0w4rR/5k+Ju36foekcP/QBgLctBwWFJMy0M5oS1eCys+GqWOEKMu
         LUuOag/LcBJrBNdf2NkdGZLDXICNqCD0O0FSIMBkdPd+zF2FyJI7cRoP1CMf/SVicJbc
         3Nc1dYJlcy32iZoSjxB9V4ppwN9k+JkMn0LovPBgsBF9ohcDRiU68e8Iwq9la2bSseuK
         UsnjMP2meHcPNv4g3c7SlUeaHlxhKWzzWoKLSOz+ffJlzQDsHcExGqopv+wfw5D7Aotc
         kTGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756464796; x=1757069596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hfWM5gPtVgoPnOifkHwbxrGhPNxVzmmMJ165dTe33yA=;
        b=aMTTqWgcnDnP+4ujruE5eyJC7GYI4O7CYrqy0mSn4IMKvdwMkSfROgR4kmWweDel04
         So9Wpd8+A5npJ+tkm2CtZLktZlT9xwj1kPW3lzFg6vJUdrse05miqhNqrQOZmcW4CmdX
         NRNdynsIwhX5NrX1jM7LoZRzuU4zgem8vL0nY95sou38WFf34i0aPZdF5uvXSZ10Ff6P
         p9YefllZyXlkq3QqlWu4ePTCHg+vm9GvjLwsKeC7iG6X3qzSebgkQvBbdv2H7mPecMm4
         pzo4viw7XE7/f371OxMnn3vBgfh6orBkyQXzqGn1X4ljYHFoDMlwerpCgTjQERKFwk9F
         AiAA==
X-Forwarded-Encrypted: i=1; AJvYcCVeu2BGF/q/L5KVxKFAkxrXJGY399VR4iFQZ4qiaZPiHrPR4m7DrHT2SkrzdvCfois3d7x0MZAfzQ==@kvack.org
X-Gm-Message-State: AOJu0YwNzLbNZmr/tsqQ7Lg9Iob/Y7keD9HzvI1Q/0iZy2q6JGXBzh+K
	tkufZO60M3F7kv2HG2wgKtD7MFyeTrjPDIVsRzOGhprNS6tjlAZX2McE
X-Gm-Gg: ASbGncuUwDG/e+yO/3CQ2kjJC+QRTmFqeqbjIBUTKg3CH04eMKj3Npjlq+s2owbJxWx
	FWt3CRtqeXbiQxAz5Mmb8c00vmsw3bjDAOwG82vh1U+0E3EBCLt0xjJklck6vpNc/Xm8dRXsA6V
	3Fn1ODvQXdXPIIl4C1axw6emW3RDzHdb28NU0WprZO+99FD3xKJDnqF0/CcBLORBSDig3tIwp/U
	nwS7L86W5EkbB29anQcww/9c/yge3iQhay1PgPbI2LFoXzzunXASt4wmMtV4RIhVgZ3W8k/zRts
	iL3kuBwfjwflhzfr/+TttjzKALxJticNJtkNumkh1PPVl8hTCgNTm0/a+rQ+RPKnLTNw6JZlPaE
	UX7CzwqoXl0UacAWBtLlOHeH2VUCqp2/o/RCAJ36gAHK1qt464OsfRpEkdlmyDvIVmXRGX9gwgh
	LSWHofBUl8SfY5AR9lmC4Gm1XyPBfY
X-Google-Smtp-Source: AGHT+IGeY7PCESR6PZttPTaRE+UYm3QcI+YG1R9VvupfIk/fQ9aWIiMXNoIMcW7W4YR2qBrV1ijFdA==
X-Received: by 2002:a05:6a20:7001:b0:243:6f4e:fba0 with SMTP id adf61e73a8af0-2436f4efc69mr19121813637.4.1756464796272;
        Fri, 29 Aug 2025 03:53:16 -0700 (PDT)
Received: from server.. ([103.251.57.240])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4cd28b38besm1900987a12.35.2025.08.29.03.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 03:53:15 -0700 (PDT)
From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
To: richard.weiyang@gmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	davem@davemloft.net,
	david@redhat.com,
	edumazet@google.com,
	gnoack@google.com,
	horms@kernel.org,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	mic@digikod.net,
	ming.lei@redhat.com,
	pabeni@redhat.com,
	reddybalavignesh9979@gmail.com,
	rppt@kernel.org,
	shuah@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	vbabka@suse.cz
Subject: Re: [PATCH 2/2] selftests: Replace relative includes with non-relative for kselftest.h and kselftest_harness.h
Date: Fri, 29 Aug 2025 16:23:06 +0530
Message-ID: <20250829105306.6638-1-reddybalavignesh9979@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250829014358.qk3zme4qlaojun53@master>
References: <20250829014358.qk3zme4qlaojun53@master>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9410F120011
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: rs7jh4t479bj4zxdhe3uds4emhjfqqqh
X-HE-Tag: 1756464797-448140
X-HE-Meta: U2FsdGVkX1/6O1ETCMZ/ts1Jew02XyjtvboObtq5CYTAISB1biu/sm/EAsYD/PeOZYRHH5fsMxyZoZ6D6tykcFCfnzhVPSDFf6yN236ed9XoDJsD+7Uj2zd+U9ETWTrxQQKaaTX56gqk6e27g3IiMaYax2yVuusC8lNml9XMlJPAtqXHSfFsFeEiZ0jEBf1L1/2mMJS0Kv+Vl2agxhw6IocjJhtg9d3idUafYTZWh4Ea/9lbc2po3wuEQZhRfnl4ogyAlvenD7EE0VCiqGVW4dEgpCfKblP6zdR//O7Z7RQQW3wkU8JcMTMG8qd3vBIsJt47rm1y3A/VC8Zp68OviXQSwHIv7a4nryUzER/MrIOJIScZb7s7/mC9op9iKSFBZRJh9gT4OJW/nruNsj3CI+lvbOcZczPYESb2mI2YLcOwUTeA79xBDDmq4E5+Xj3fnw0D51pRuoItmZzipnvKPh7bXmVKpvXampHiaJpsAfjHBWPX2RnKQfAlhu5KqRx3+VnId6TuH64DX8X8k2wrHcQx+rKgKYUHwtAkC/mTbi+sRg5uan4AXxV3ideiGlDN/6xZQDTdK0NQaGqw6x10cz2IlWdpGaSO7I5fJRlqjLaQPhwmFPFIj9ZZyI/kkUoo6Td/FUY2uQJgHCqOZuu6QWEzqp1cRJ8nPHrfxvR3hy96QqkYAeErASjwHIRcyNWhdWMr7A6xR4mg02qGuZ6Uzd5ox7pzISME7nqyt5NpV/59myQk+Wv9+/Z7qlyFgr9is91TghRl9b8jwI9kyqHrWIzPsN4cpApBIbRzWG1uhmSug/nzyL7oFZp69TK6Xru/DjgL9p8wJyzsYpLc79aalPO63bLisHs5z94viDUICbhR6egtfHsd7rOzlWsFRcSDnlyqxd/OkLp7lP9bqdnsBeuudJOr4HOJI2Ah4qrtx7wW+yu8JFtR9BwlsfeL7yKPY7yvdqB8Ho7jbJadZWV
 WzR9s6Sx
 XhjtC2jzmvzf/evLP5lWsQkPKep5L/j4nuVUe2HTJD/cx2RiCosnmsKaDLm5NlMzfrBPyubRZfwbU/zU3H9mxW7+cBLhtNrdnC+wCYZ264yGX+ZlfNLcW/EIcDKh4Ug7razIVXWkmsS2H7iBSBlRzcP+WB0XS0dCj5xbEw1NP9VCrXXGJMQmL2CJ15W1ZQHtu+MGrru4fA5XH+B9VdB9HYdWhuB1a7MsHIxVYbGL8FY7BPxxAZGuC6c1cgw7vo+HWyxKWkXb+R99QqVBM6thoulD7+mQXo8b1tDPvnHsvy9KrZlXXkYsvRUvxIXS0HdakuAAgQr3YVv7xYu1bzBcbmN8bvp/Bio9JREQonVNoTyFOvLT+9gj9K+DjuqGYVqsRCZc85rOCJpBW/9KE7N7bAOr3fF/KDvEsVfV8pnvPmotxnNxk0G37MuIcsRhOUApQ5b/9HPnnHO8iZ9T/eU9+siSINjxXcAFc1iDlr1y94EL4S0HKjR+KxXDLmHyQ3/UiInVq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>+ifeq ($(KSFT_INCLUDES),)
>+KSFT_INCLUDES := -I../
>+endif
>+

This makes sense, but if we do it for mm/ then we have to
follow this for all subdirectories in selftests.. that might
cause problems if subdirectories are nested ones likes filesystems/.
Duplicating this across all subdir Makefile adds churn and can
lead to errors.

Another way, is adding `CFLAGS += -I../` as is done in net/Makefile,
but this also doesn't solve the problem completely as this also
remain to relative addressing.

But, if preferred we can add this snippet in Makefile to
resolve the error temporarily.

Thanks,
Bala Vignesh

