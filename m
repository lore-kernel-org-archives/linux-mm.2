Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29254CEBF93
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FE948E0027; Tue, 18 Nov 2025 02:55:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AEA48E0005; Tue, 18 Nov 2025 02:55:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69E648E0027; Tue, 18 Nov 2025 02:55:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 520108E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:55:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5FEB88EED
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:55:37 +0000 (UTC)
X-FDA: 84122968314.28.968350B
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5ABA81C0011
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:55:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WP3uKjAt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763452536; a=rsa-sha256;
	cv=none;
	b=djqaXXNXS5ZkADfhfaZxymEBNa/f2DnmX7PAgB4hauyoUGdAvaNUTyqdSA/dMnrkPAKfsf
	3UxLbCMGJemR5H83I3WhnnPGtyX9ZaBmNjc6aXDFnjeXDKUpZPFwoODFBzDpR1qORQmt1H
	aJ80tmfnfgvsIr1RYTupL9OZzWviGrA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WP3uKjAt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763452536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=o7/syqaVN3OFRUvQzya5/mq097BnRjYmCSiy+yZAENc=;
	b=h5gS3IkH4Kskaft9sPCZ8kb24WXp9DuI/eD749v13uKeuSwpzfON6JFVd2ssmGQW9MJYJy
	IE4RAgeROX+OUROWqao7QVXNU0DSmy77oCCzqBtjGgWpSgs6ERdtzEdeV+YNX3/AgRM9+l
	ZprA93nJ4PWYEUIdC/BvgIPwRSg28uk=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-29853ec5b8cso60366705ad.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763452535; x=1764057335; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o7/syqaVN3OFRUvQzya5/mq097BnRjYmCSiy+yZAENc=;
        b=WP3uKjAt2pLr2MhxFMtfIWaZvYxgjPOc/R4uIduDqwQVZT+vIV1Ai7JJrpsveCMMFN
         riaZtBTLAvgIg+2xh0CaLm4VxC0Lb/94uyIwpnA8hY+m0RmisFNGvPRjzJBiHqx5lYGc
         ovISahYhj9aOvIcaUbIQxAXRG5uHNaBkCrX48V8lUK5nO/hNj7DHZu7fyN4FNRLsJRIg
         3L00oKC5DOv+gLQvesMOl76knAnS2zp9FxHIf+qsa/Me6KD2NE2iyXzqvXtUzy+udhLx
         /rceRl+iLLfoqHOMn2P4BaF6LEaVNc2onjXVk8p6pDNFqFrrQbPkuV9qk3DOKFW2ab3W
         w0SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763452535; x=1764057335;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o7/syqaVN3OFRUvQzya5/mq097BnRjYmCSiy+yZAENc=;
        b=EUpojLAlsnqDQngABJ6CBG7U14tHS2nVBre9phhs3Tvu8slHxP3i0wbattpB03Oawl
         PYU0GO0ZKJrBnmst0vm0EqMMsJ2zJ3YoqNnOda1dB7Ra8ML2ZgQboGdk46q7F3xfLm2W
         gEW5mlrkZcD/Qnw3U8W0iJk2uvI88r7zcxaZ781PIaF15HkD9/Mk0MvMkhyIxAbdGy0d
         cfUrwjeiUj1E/uxd5WDiZLtx/EbFfV4hz517z9IF6NkmDa6voZo4c5QrE8yAEl/b5W8y
         qClQ1rIVFiXfVWIFhJ5wJcNDu22viMiNMCnQCcT1R0T6T2OSS3s6M7idTpzpane9XA7C
         KoUA==
X-Forwarded-Encrypted: i=1; AJvYcCX4HE46hey5GSV/B57zjsiJzFQlCtFIz4+c8mIQizS00UjqHlbWUkI+puLQ/TBIAQAk5+fk5J6A0Q==@kvack.org
X-Gm-Message-State: AOJu0YxYA+dHoCqR+SdDuC4wgEBRN2PjpVA7viGECy0Kzkcnk76inD7x
	/4coXTI6FIOIbsso8WuG9Rsler3CBCY821S+XUtgyttDpNuApoC5cH0y
X-Gm-Gg: ASbGncsUpEi5XFfIFlez6HmCzhoXw50vMU90wa6E6eLpzJJIurNU6sF9A8Mxg3Li5kJ
	jTQMG6isAAXctHYnQY3afkzBE604H2iXuIN4BvC735d7GROg4BjZKQ2ihww3IfQosS6B+CorBqv
	fVmSPmZIshgQPqPZLW0c2J3+qOTgdomQV0GRjGqWkATIkTFENl4AT7y2JlmyVbGhYXXR9gAYUAO
	LvwvVp6OUjzJ/yHCx2qd5e8w9vFY+1QO01Vc9nOfJ7NGgA2B15BheBrlSm+9DybIHl51Z9eaewt
	CWu0ZQEaGwpvbVFdyGJHSl8eROXGAIeNBUGYNrGQmEOzomLij3WL0so/yLARUCJBMPFRI3sOmvc
	m+DYcGUnaMhP0HfwMT8GCHfG/S3NGKPaFF7xOBqblvhDXdMCxbYe0welhBhPRjocpfXW33Tv3e0
	XlhA==
X-Google-Smtp-Source: AGHT+IGIAchNoEHFNNrUZtM+TDOe+4ACVDLvPqJloOk/sC0eRCbgmSifY6wNhf27PIzrHEaASBfebw==
X-Received: by 2002:a17:903:904:b0:295:2276:6704 with SMTP id d9443c01a7336-2986a76821bmr154935035ad.51.1763452535158;
        Mon, 17 Nov 2025 23:55:35 -0800 (PST)
Received: from dw-tp ([129.41.58.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-345af26d8b1sm764612a91.3.2025.11.17.23.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 23:55:34 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Misbah Anjum N <misanjum@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-next@vger.kernel.org
Subject: Re: [REGRESSION] [next-20251117] ppc64le: WARNING in vmalloc_fix_flags with __GFP_ACCOUNT in BPF/seccomp path
In-Reply-To: <dbe42ce9543dbc3af95f95d6a6d9540b@linux.ibm.com>
Date: Tue, 18 Nov 2025 13:21:24 +0530
Message-ID: <87bjkz3hj7.ritesh.list@gmail.com>
References: <dbe42ce9543dbc3af95f95d6a6d9540b@linux.ibm.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5ABA81C0011
X-Stat-Signature: 6omoc3gwk33tmyttbf98f787dsmwrnie
X-Rspam-User: 
X-HE-Tag: 1763452536-768217
X-HE-Meta: U2FsdGVkX1+CoYFTqF9s7cgNL1TLoh/WjW+3YeyXCXv+5kxMv8VbrTzoM+hLXQvggh4IzxqnQswAqULet9DW44p02o6a1udkFuiwOzgQNw40UGErqNHHR/VuX9XfHn606lqIELnbFqnloPw/xNixrIVgfZBSKE336SHGQWdVk+aBwjFjme9FhPLwfl03U/GDIElEMbMRNX/pK1NKU5sJN8OKhWVkWlnVpAiXSFxteQb6W1U6wxlGd1amrOseDJvErHQ5ex0+SGJbWQ6EuG4WsmI625hZTauVqdgDvu74BPfn7DqUGeZm9jwnH3vJ5ydoEb9Cc5MajTvt+CzLu1ULyDS8o2v8aRjmJaHhKqT5HREum3oflTke6wPzfQPS4+7u/6BbIK5tNgJfQ7gmC18U1CYK17JkHjg14L7nsIPWZZwktpAFKyqWvjl6pErrHboUn64XTRKNLYhzLjci8LCvJNWh56up1+LPYsNu3z+MhKS36JA6KfJ1D6+aRlV0mNVtv+9pfxdNDz0ad4gO6ujcye7xZK5gghNW+kdfqwgwmXpHfSM5rT31zyOtikQzSPTmn+6HKoOM7BQmeJ1/ajFnRtICDjyJAojxoZlaqp2VXSRLwJrbGb4UsfZ5H8XFlwL2NcaFJrSaf2v1jQpJ/d1aGk+BhyKk0/9JCiJ7Kt9OYse55n4c+yqM7CDyFkjXJeXWIOleo56LCejKWwvn8h04TkSrHIXbzFmn0MVFeOleJRpnceXvXSiJBqRy4yhaEYg8LMpwby6yyr/cx6+sygdWnJsgyyd3x21KhqTi2MvgIpR0L7DDj1hKt2IDh7phrlKpJzwsP9Bn72/pxuv74LQHe4u3Q39QH0hjD6SG7NU91Yzt2lDgrqixxr3V3U9BwhioaG7/5l6IA2YvXx5AO44C417oZVglldZwc08s14weFCPuw2N3G+7RaNzSOItVAoiKJBWmsA4DKnNE5+Pwm/U
 aMdTxQV/
 VlNhKDnEEZ5UoKXPHfR6O0e93bSq6zV9OF1e06x88LamiJcq+6IxbOjcjlbDs7GH3s557pIRKrKPw52tPaWXJoTg1taaZ31eIWeN0JVTcxRxbnqO7DQ38n3zjbneQv7xaQlMP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Misbah Anjum N <misanjum@linux.ibm.com> writes:

> Hi,
>
> I'm reporting a regression in linux-next that was introduced between 
> 20251114 and 20251117.
>
> Regression Info:
> - Working: 6.18.0-rc5-next-20251114
> - Broken: 6.18.0-rc6-next-20251117
>
> Environment:
> - IBM Power11 pSeries (ppc64le)
> - Fedora43 Distro
>
> Issue:
> WARNING: mm/vmalloc.c:3937 at vmalloc_fix_flags+0x6c/0xa0
> "Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 
> (GFP_KERNEL|__GFP_ZERO). Fix your code!"
>
> Call Trace:
> [  523.921345] Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to 
> gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
> [  523.921356] WARNING: mm/vmalloc.c:3937 at 
> vmalloc_fix_flags+0x6c/0xa0, CPU#69: (ostnamed)/6500

This was reported here too - 
https://lore.kernel.org/all/69158bb1.a70a0220.3124cb.001e.GAE@google.com/


Looks like it should be fixed with v3, which was posted just
yesterday... 
https://lore.kernel.org/all/20251117173530.43293-2-vishal.moola@gmail.com/

So, I guess, latest linux-next should not show this warning on ppc64le either.

-ritesh

