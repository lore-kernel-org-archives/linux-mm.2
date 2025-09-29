Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BEB6CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 11:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0748E002A; Mon, 29 Sep 2025 07:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50DA8E0002; Mon, 29 Sep 2025 07:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A40308E002A; Mon, 29 Sep 2025 07:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D6B08E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:43:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5E309119A55
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:43:07 +0000 (UTC)
X-FDA: 83942101614.25.B4A78BC
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 647F8180011
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:43:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Au+XeKIQ;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759146185;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6mbjVJui29v4n+pWGfvI7ZRvpZGP8q8p7zkZRQub17I=;
	b=7BVopu8mufHKjNNX4QAMIhnzhOL2A2tDxY36tRsyZwroEMA0IJBEU66UU/F8PdeBxk5GG+
	dD/4ORCA0mYzK46CRgQvPnMbAcE7lc3TkD1HzJTwUpdiutL7dso82G0I6D5PciqJHijGNL
	YN9QwBNJjEQaCbSniQv8YV+vBOCGYB4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759146185; a=rsa-sha256;
	cv=none;
	b=tl6phjSAHvpOzp1cYeTxJWjDbZptuU5W5D8iwcbKZYehhH7Z1zA2PKF/SnTm52+T7f+OCX
	YqhpvUjY17vpEY0jthwXYcwIHzTgO3bASAOErf0PwK5KF2x4pPTNokWv8QODKRBbigUnXM
	jai90sskj7DUl/5iXMRVMR3o+c1b6qA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Au+XeKIQ;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-62fbfeb097eso6494485a12.2
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 04:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759146184; x=1759750984; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6mbjVJui29v4n+pWGfvI7ZRvpZGP8q8p7zkZRQub17I=;
        b=Au+XeKIQ4pCY7qd+ptHfaVduKzvjvqs3pIndCEsu7bKhf/D3ky1gbqluq7Ydt91f8c
         FbGhYFqGjuMEyawBAFVrObBZo77TwIkN66u5aj5annNVXnhAiBf30ruXTfotIILx+InT
         ymlA2IDKUWfJ+vG8WCOWxNuKuqWjAPUwLxlOWRUR29PqUFQJ1nLyCqmEhjPHS4rE+4z6
         5z16ILnwCPM+4DhdG1UowW6NRDTbCBtkpjv2R2TGDjRjSWpoCi1R47To/9XwynVyD+mV
         nQHhB1r/++92NXpk2bqSpJS4igOqUl7Cd3HioNVPbtDEp+TLQfcZAeTP+Ld51grBiJ6K
         /RQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759146184; x=1759750984;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6mbjVJui29v4n+pWGfvI7ZRvpZGP8q8p7zkZRQub17I=;
        b=iwg6p5jOObdTezD2JVl4BhYg+mASfUGXP1F7cX0TpRrb9CA2bOG8tz5A2gvSHzTgET
         2THBv3FCv2kR2nW9YgtOlSBIM3935ReK4Fo7THjxBQCgPpEJHGxj4k0e87KNYDzLW7aK
         YOMUuKBac9D6r11xI6pNMLnKdQn7U4BGmz0ppvZ1f//XmDf/K8xhENuY6bJ1vuV03zSM
         Hb6wQKTLJFVRtH514ZQ8qYnFAAE9PlbFA4IB1y816M7CNbl0BAKFwIBlUY5EYWH9FsUi
         ni79yQNgCQ4xYOH3L9CdFADsvinjlGn0foe9tIULqYNevqAy9tnk8V6fIpLUimUwhSm9
         5YAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQV6JyQGgsDUMR4G0UKYL2SIvItTbYBLuRBCvVjmnkDfbZHDRfQH3D9kfFWNs/dEcbNvi3a50CQA==@kvack.org
X-Gm-Message-State: AOJu0YzVCXGx7lCoBIqm9pzPTcngx7hjGAsMDWqREhyiu+glG84xaQkm
	GzLIVH086yixUObyvBZmnev+LmF4L/b72/9ao2dunsv6reCrzLB9R+4W
X-Gm-Gg: ASbGncvQX+HAgMnmbeC5d8c6EmsBWMeWBFWzRWarYcUfXJE4dJ/ZGRm1HQeHDc/3DRE
	wOWcnn2AJYGya1bt+rkeWfuN0NIcb/JLpDhVt6aVOdml3XXtb9RAkK/InXBxMc/MSaTTtVNb8Ns
	Mtq+QhW3C6xGcg6G3tZ2XDO5Wnp3fUwTk6GFgKMWfOMoryQEXVsm7NOOIQM/TlRD4E03xKwPO/7
	1iITe9J6+LDzm++tAqjuJcKITFtaUXQ6oXQI4P1baj1tx2dMFYhywgz3aotvJWu6hF8ZGd0578T
	LOhTstoNX2SWxgix0wGvNy78ba7KIlGaPbCLK48D+jB0i/tA9jb6dD4Myqr2+ub2F++TEY+Hn8g
	emOXUuZkc4OUkrSw8MKOkfxhhgKu/MxmMS/ov
X-Google-Smtp-Source: AGHT+IHpSaj2SVniGIDju9aHpbyUh48ii8/cQ5YSVvAGh2d+K7m0MNGtY13FQ+XBP5NLGndaXCuTRQ==
X-Received: by 2002:a05:6402:504b:b0:62f:cc4b:7b53 with SMTP id 4fb4d7f45d1cf-6349fa932c5mr14065525a12.37.1759146183418;
        Mon, 29 Sep 2025 04:43:03 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-634a3ae3080sm7873345a12.34.2025.09.29.04.43.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Sep 2025 04:43:02 -0700 (PDT)
Date: Mon, 29 Sep 2025 11:43:02 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Jianyun Gao <jianyungao89@gmail.com>
Cc: dev.jain@arm.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	baohua@kernel.org, bhe@redhat.com, chengming.zhou@linux.dev,
	chrisl@kernel.org, cl@gentwo.org, damon@lists.linux.dev,
	david@redhat.com, dvyukov@google.com, elver@google.com,
	glider@google.com, harry.yoo@oracle.com, jannh@google.com,
	jgg@ziepe.ca, jhubbard@nvidia.com, kasan-dev@googlegroups.com,
	kasong@tencent.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
	nphamcs@gmail.com, peterx@redhat.com, pfalcato@suse.de,
	rientjes@google.com, roman.gushchin@linux.dev, rppt@kernel.org,
	shikemeng@huaweicloud.com, sj@kernel.org, surenb@google.com,
	vbabka@suse.cz, xu.xin16@zte.com.cn
Subject: Re: [PATCH v2] mm: Fix some typos in mm module
Message-ID: <20250929114302.eshtdbqkjiuflsib@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <3c3f9032-18ac-4229-b010-b8b95a11d2a4@arm.com>
 <20250929002608.1633825-1-jianyungao89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929002608.1633825-1-jianyungao89@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 1dc9a5qrk3cchygncsdmhaozaedsz3b6
X-Rspamd-Queue-Id: 647F8180011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759146185-628740
X-HE-Meta: U2FsdGVkX1/HB+HcyVu6t5W7JlpPfszvOKtq2LXJ4Z+F1PWMqWB/h6KC/M/p1k39UnT9CkLdiyjqtoNkweXdnlnbRAgroVlHuUmazCR6bB8DntGtopQyc2O2O/bBhW/0pLX5VT3vRX/Q+FY4xJZz9jpLQakZ9uCeCLFR4zrnf6Wn5O1jyQu4CqdhvfKFjDUw1tVeD2wqfPoVx4es46asKFya+rXZxyUjMr1sNx+d6lEE0oLUKAqBK5iH1tRiM/W6ScxWEp3NZBZxh3WeGIYM3WaTtWeFXMQCpsdiAkI5EjKQmp6jk/8R5MDNFNUJ7o8f1cIddvc45TxH1gKBP5yi0g5HabxIi9X3eO5VT+g7lxCp1/aU1tC1JhOxFtB4Rp8vIJI/E+B+YwQyDVrGoq3Vs0JtgUC1XV/JmM/QdVs2VYVhiG1o+iQq1fPnV4je32sayrz1plbLl9EOdzZVAfvT0QR9CQyRCgBVDpgsUWohlhFS0roqYO1mftHZiIrLP0bP01tcKlC78IXcICy3cyfEIwcJFgTKyjBxADZDH1wRXjAB0JHEEKxX9N6ItDzglGMnZN6P6rrhxiaOHPFU4nWFn49TkQjvddpIlo5rSlx/7TGk3JIHQE9T8b3PC9fNAC70fI8xzoiI2w6wmGQElJZd6bE2lxIKv06IcvyMaIM75dEZmy32H6x7WjfvkVJm3C8UC691UwnNMW+168YOG69wPvI7sdKlWoUJfre+UfMi5+IV+uhHgOMVesSHz7S9bT2V4137RqItKPYrEkuoy0aAm96FHePAubE2u4LBajJbE3xC9AdKIcR++AMDopcYSbeQS6ftUmVZ9AkvY0GaYmEu+phkf+Lspl17WcUt/FnbHJviw4GvOu+VGmTwH3hHZBCIsVwYka1xoiP0IEGp35lCmWvAiwrbIqXK6nZ8bfFP/b2x//VarDAb2qHXlTeXsxv3hlznFkuy/DMwaXV9RJF
 cfGg22yw
 vEP8fQao4oZZnBIj/SGeykQWtW3hcbvyUNMZDuostq9pH0QUfYMUdThNtRrGHkjPcPWjFEXcH0nQ6LOMKzRe2mXc5oXQCi0iN2uaWIC32qFOxtXMj/QIdOz8DU1y21aDRdjlPx5Sel4AVcxX35DaF9Ftx7On1ok13bq0vAYD1Rdl1ZrWTuP3nc96Few9DolEzRbAFhHTgP2mx1bHe3Is2GiibWuv6W3w/N3ceItdworwSzM1mTDi3Y/LZ+P047QN/SHj/Zsp6HLokEQZq+hK3exewRvl72y+9rjPeJKuYI93ODLpsOPQp7eu+mJa+8ZZ9HtX6m5J8v/cqKc+ffNPf4YXcVuR4Z/xe0mtoyhrLbugd6be+6194lcGzwSOYFlMV7RHRih+tsNQFD8on6dU819pEvkbtpODzrTdZKpPIGjRz38aih36XEyepOOcuMR2Qh0Rf+zTM99vRUW9kvZma3AZJlOaeJZLdgpp/7mYxNPtlIsfkgiEXRHfHdSMA9dPHf8I1KJhlkJ4REF5bAtJ05SaRZIvbdyZM6J//FRxjSnPmyoKho1Y6JF/xA0iOamnGyuBH86V8k2AOc84jqmawlUbYX39axU2mlD19TsRiALa+xWpyWmKMPh3Pj8J0BioyEcr5fDsoy/TygqOCTnX6j71H2iCqXd5roh1H7uayGSCVunncT9h3UTBNatJw55paop9Qgi6PEOSbTSA6C7MTwnKGM8lmh60jIMvI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 29, 2025 at 08:26:08AM +0800, Jianyun Gao wrote:
>From: "jianyun.gao" <jianyungao89@gmail.com>
>
>Below are some typos in the code comments:
>
>  intevals ==> intervals
>  addesses ==> addresses
>  unavaliable ==> unavailable
>  facor ==> factor
>  droping ==> dropping
>  exlusive ==> exclusive
>  decription ==> description
>  confict ==> conflict
>  desriptions ==> descriptions
>  otherwize ==> otherwise
>  vlaue ==> value
>  cheching ==> checking
>  exisitng ==> existing
>  modifed ==> modified
>  differenciate ==> differentiate
>  refernece ==> reference
>  permissons ==> permissions
>  indepdenent ==> independent
>  spliting ==> splitting
>
>Just fix it.
>
>Signed-off-by: jianyun.gao <jianyungao89@gmail.com>

LGTM

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

