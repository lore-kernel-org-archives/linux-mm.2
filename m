Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6510FC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 16:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22876B00E1; Wed, 23 Jul 2025 12:36:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD36C6B00E2; Wed, 23 Jul 2025 12:36:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE90C6B00E5; Wed, 23 Jul 2025 12:36:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC6486B00E1
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 12:36:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67327140120
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 16:36:54 +0000 (UTC)
X-FDA: 83696083548.08.2913949
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 829B5100008
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 16:36:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AUD9e2oA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753288612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fx+A7/q6ZUtKDHiMJp4IBXILWaz8CBy/vW0OU23aX7I=;
	b=ZoqObHe+Ob++QPgtKi35wg+Gt1wKrA1tZspSGO0WF2C4dNFz6LSzk+NizFxkj63b/j88QL
	A63fiFeLXlvr8w9YD+ACQQBGcBxdIYqNMFsnB2xYSw51B5WEZrzchbfInRad9GJWClgQDq
	MrUXK7qsSCnADUmEpZ6VoeHzwt5mBnQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753288612; a=rsa-sha256;
	cv=none;
	b=clipVlkkaoDvvxC59Y/jR9jzD9aNP7aJfVLDG8JIEm9kOyAqj3Ey9e64Rf0rft/k0PfpqM
	/mV77cG47hPJ7L8xyuGI7eBni/3X/SkRqCLmB3kUhuomKTOQiWgMNo9GfyQ+gfZwU6zyWo
	G4St5DkV5TzHsKEVfqoKWmrOtvyLPkE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AUD9e2oA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-23c8a505177so58155ad.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753288611; x=1753893411; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fx+A7/q6ZUtKDHiMJp4IBXILWaz8CBy/vW0OU23aX7I=;
        b=AUD9e2oAFsqI5rAOh0M9SEhjEMPH8Ngkcx4Bdr+66mKorpXdkiSZYe6zETExMrzhEh
         4KC/NXAopDBPqLcBdZf3GQYYK3tncnHUBGXasHQhNYPHRc34tk4V8RQTeKOdTujh9hIl
         0o7ulufupz3hbapnp3BRcGs+wSkm34GRRI5B1URTKF75Gx8RH0AXgWf61tQKSENL6bMM
         SyOGxaNpmoz22Qw6N77QQJBt2J83j5c60Ve1QvnmDREkBZQ7C5c+Ar6G8TrhZFsAwS75
         SgpVcY3MCCTX5A7WCUI9h1+d42LHdEqH8OitjeOUMbNpd0AZzgUwG67k9uLAXtgnLa1L
         7YCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753288611; x=1753893411;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fx+A7/q6ZUtKDHiMJp4IBXILWaz8CBy/vW0OU23aX7I=;
        b=H0MIY+BJgEu0KEMbtOfudgxfl24OhDr4hQ7gbyA7MjhwPOMSg5bHCbUbGVX7FsmFpj
         gy72MVNc4Ng6LW2q3FEM+dKYJhlg6fuHnzHvg3EjZkaKO2Edx2qUfXKxZcXMC0SNsF+a
         oeEki3L2fRa2crUTzGiOs4qhyCowjd5FLLdSHE9F8SflhXRVfAJSui+EdnH+opt6hCk2
         eewbkuN8QHwK/COb9twlUXMy0/xdEm4UdUBKjUIT4+RT0N+Zh/HprFl8/KaMXolnRpOY
         wy1PfoJDPlj3r5ACdrCSaxKHUtxFyrWmA1/CyEKMejV0lNS+Xi3ga/jj39x5Z2LTPsbX
         Co5w==
X-Forwarded-Encrypted: i=1; AJvYcCWzcq8eya2xfLANgxKolROAlCq3a7dCvX7d/61hDpqBQKPz3xIg4GVW1LdpSS0vHcqz9A7GgbfrNw==@kvack.org
X-Gm-Message-State: AOJu0YyIH6GB5WajkuAyWc6KT8rVJuJH00aXpqofVFJmxcD6MmQyX5cO
	piQOiwyLezWgO+6ceCRSoAwSFXpuzBi7Z7F2iDWCwUlan4UqeCjdEtkiZBORDQ==
X-Gm-Gg: ASbGncuVgqHh66VhWIdtiCFIBhg0v6i3HSUTL/22X4ud2lc7650OQ6ajIbKM4NpI4mn
	L8WSzf1C4g+aElfopsyLU+Y0juAs8tDwzNTOq1P2teKPzSFGDXOTZIv1uI+MdnlLkBZURqDt+aM
	XKHdyAuJ6b2+Dtwm6RzccYVyheclZEEsW0rtoKGadlfTcC6g6aqXyu4mJMwaC95kUUqWCKDIYaY
	N/YwVlX0kk71/NGb3iCLRh31RoDhof77su1ML8Helh8ONmtWtZv1DCOhNXaNHRNkVKwnpU6H0h0
	7gXGHTA+UJPczG6UV3UdEW2gJMT7h88cpQdn0D7clOWT2I2dlLqxydeze8+DeWuHPhMGbUF3YUQ
	dQvJZSlbo6w900glGpSmH+X01prH/ZoFNST7taFhmg8/DYR1SuL1BAg==
X-Google-Smtp-Source: AGHT+IF+7PIFIwxHxFCd3fmVGl5Kwhq6RM7BuCanshOuUY/aXQHU0NqUgVTlYaxJn03calPDpIPI6w==
X-Received: by 2002:a17:903:b87:b0:235:f45f:ed2b with SMTP id d9443c01a7336-23f981619c9mr51840655ad.1.1753288611270;
        Wed, 23 Jul 2025 09:36:51 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b6f2306sm99985265ad.213.2025.07.23.09.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 09:36:50 -0700 (PDT)
Date: Wed, 23 Jul 2025 09:36:47 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] tools/testing/selftests: Fix spelling mistake
 "unnmap" -> "unmap"
Message-ID: <aIEPn8O2z4sNB74l@fedora>
References: <20250723095027.3999094-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723095027.3999094-1-colin.i.king@gmail.com>
X-Stat-Signature: 8efp5hnj8q66fpages8pwut31cb6fqp5
X-Rspamd-Queue-Id: 829B5100008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753288612-432835
X-HE-Meta: U2FsdGVkX1/tswtTOsabBvhEDmmEpC5CbbrasiuSpBmtCKtvn7lOrcmd8NGr6JVIpBPwzxZDwnJizc2ZtatGcL0/zR+Al/HOZA6Z9Uq96HVIQP1cO+noWu8l3W9ZUya6PxuTmzCu37J0OmU0UmoLOh/AVDEMjeo6EjVc7lMqzuM7Dh/L0rt+SMGvlMZMWtnlr8AnFF+jEDVpTyD+TOhPDPf/AC/TPHwgtYyFA/c3cvOhlX/x16UdzTNpKgHPTmSG55FUf/qfeuLFZxUrpJ/Hhd674jVmMiIBMfBpKszUeuRM+Lloinh0ogkMdt3IK6XKjJMhhMtp2Atg2u4OPJHgqK5zMsv/sPGfR6l8GGkEuYz+6aiWtXGcY8fJ8TUvaHVCeWF+YQapM64B2R0a4BHQToA/YaWsbvJX37h/RcTMqrLPBaLJ6gz29sjo1E+794h5DrugI9OmPxqTdssPfYPpueUhEeQheM6/eXCJHlh8rxpD3M6rF8wabcHy5z8+FBEUpi+mWuErlq4421GsnwytfARz5uV2m+Ke7SDyMV7EycFSIcTwqK0jf2xy1YJqtBOdXGByjUvOZa/GL39CW2u3EPy4VTii5HxC2ONVqJueMBOgwDAhPPNYeASEmZ9qr3d00lyMNNyvQ1r6Mqfqf09mU/MbVPb5+ZLT4Vlkvx7o8aV+sCxsE4vWlayWdw5htp18AWudoXyZqKx1HkhoiRAvt07/RUPfdIcGL0j64LrcmmuDtgGIc9F6BXn7UKKbcv0N7x+YuxeQQdq/IGZSeqNM0tn/Bv0EqfXvxv+e3CVTf6P1LE46wsD+IMR2NDyCZYXCs8V7BUP8Ze5NChXIU5Jzzu1DQCzkTMbkDs4QeYuM/Ly2c0lAGBMumgYl8Wl7Ui+sVrahMwAteTRZH45lX8XIoRqSa3PPpB/l3lfO6yd38+jEbBm0qVkCDOozavWHFXYAhNNYQxZcSfcclr+pg/f
 DRzM6M/r
 VYcHqutCQdmJuXYrYPJn6uVGj2yTZ7NHNIrRNU/fY7YL4n/OOhYRQ85QYDjzQY6Uy6B4cZjc/bN9JqGAIx4lQa75fy674smYF8fb0B/c+hrDqewhm1/pskwduxesYslVEK5XlEGwzbFfYs6oKJRILAJiY2HGoDh0iKCuGXCb4fy0myegXU/yvDXgwT5k41TwrnfASKyMsA5GtPjfgalQDaKcfyD13dT4zmeBmpk1tVk2Z658VEW8puBptflNaXGOVphTEp4kmTrbbR1xRC6qKtIv4TtdlSdMB8DU1+ecxgvTNyL2AatWFP3C+8qA+2jgJSLtC1j+vduX0I1w0Xp5sMks75pPiF4TQQLvs+iLWLMhe/LwCuQPCnDEveGMq24Q9jiqXrYDVjFR8ZBi6UpW/eV8Ntlww7AiOFX+Ui1zoLF9+wYIv+T20rJbE389u1AmaNmY6RP0JBsf0H5ai2voCMYxmW0Lm2rzSz3qAJGe3S2fw99ejQRJn0tWfD4gIheoB50VHwHTivIxeImFWk6l2Ga1jJrEh+oNa94VZtrZKJf0azdJbVP7KW9DA6L2mimYSBlS2EO8lwma4EV8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 10:50:27AM +0100, Colin Ian King wrote:
> There is a spelling mistake in ksft_test_result_fail messages. Fix them.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

