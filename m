Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0CBEEFB7E1
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C7C6B0089; Mon, 23 Feb 2026 21:39:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D44A6B008A; Mon, 23 Feb 2026 21:39:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DFFC6B008C; Mon, 23 Feb 2026 21:39:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 294F06B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:39:00 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D25AD1603FD
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:38:59 +0000 (UTC)
X-FDA: 84477792798.16.9C612DB
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id D49821C000A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:38:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bk1rw5MH;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771900737;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Co5jOQY5Xwt0Q19IYGp0vH59NTwhi1RMjwKAltkdA4c=;
	b=FYFptmrtyp35985BMQUOKMLVT7cBTUzoyN05yraQh2RCKjhI8nu6QSeRzZpZyV5qyowXi2
	lWEU3miF7+Q3Jkkc1NMwuw3R4V5Sbt/kZz8LC8Pi3xa7b/NDw2WVTEEbrW6PHIao5JLtWV
	Ygin62R0e63NHkK15yVlB0igwFdlm5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771900737; a=rsa-sha256;
	cv=none;
	b=MfpkNmSUvT+q0ejejjRt8+/nM07WccGEBKQcoJoBg37WrGeBYYKaNED3k0qjSByxzcjzRC
	+bnCKDQxux25WjMMAGVmEXD4hLWDwT+BRgoIgFVf0Fveb9pTf7mW2sj/iIZkxkhzvgk8Zc
	ZA7FRJiVT9v8Th7dC23gxqrMLETSnCI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bk1rw5MH;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-65807298140so7470436a12.2
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771900736; x=1772505536; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Co5jOQY5Xwt0Q19IYGp0vH59NTwhi1RMjwKAltkdA4c=;
        b=bk1rw5MHV8zerKXvFIgn71TslRYjgfKHfIux7b8Lmyi16gmVqhim2nxOryDh07SmJY
         qp9EvubxJFzNIIQ3TyH5IId4x74cvhCC0H9nrWpPlhJxw2zWmAZADcx9907LKU/CoaP+
         YlkhwAEXc9nlhgFdXOZHT+lYVDDBQW+4zHKun9lGmonIWHgqgHdsiLNVKWrj9ydKQjaC
         VcEzhv7FbG+Jpk47r2T+Zdms1Y/XYnX72JKlOWXuea+agFKMj4vVhR3w22+Nuz3V7Lyr
         UYCNbCtrqUMqrsA457VWnHrbO0iVKfHWq3KPpVhqG+VbfoiodrBGLyAamGbLPv4WYm74
         PUdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771900736; x=1772505536;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Co5jOQY5Xwt0Q19IYGp0vH59NTwhi1RMjwKAltkdA4c=;
        b=QStt8lljNVBK1ATIgUwL2mEsWptCNx3yCgzcyFFHepOjxbfuD1VzZYQj0vr/csVAmV
         FJ/61SMpIW+JcUtRo2jMEMpcYro/PIxnjUqhsrt2L1yHzBiOMX2G3LP0KDKz8/mmnxBX
         LiEf0Sb3dQpYLf0i6MnFrgi7OP2KZ0XeQpXdE+acB+jk2biu0MpCoQj/cb93vj5plxNY
         WegwYqNObBqSB9S9x8ohP1ApbkXJ+HLlJIa2UfGiOJa4OXaEClb6Q/mQrshHmMNX2An3
         JeL84TAk4TU/qkUI1FAIZzC7uUfVlGBmRWs8nbSc1RuhAzkqeCQEkeUAFY/bcR49DjWx
         Hb7w==
X-Forwarded-Encrypted: i=1; AJvYcCWLZh5nVl7Jvr80It7TbdBA7Y808DVkYFRB9T3v9Jqdh/Qft6IDGh6gAKfChGXzclXExP4tQS5x6g==@kvack.org
X-Gm-Message-State: AOJu0Yw8RjZdxEY0jNAp4HLvCZAWce5v69Fcs0vC8QxnIblmTx93ZjpO
	8MYGH5IHPOeeHdkQZsfNyMucL1M1ZW8bbn4Ipcz0V+OkvlMTkWBy0JJr+5JjIQ==
X-Gm-Gg: ATEYQzxzjkwuDeuKKoemIIp+H6Ar+7dQxwUoS2zzrni7EhZOdtcdxQcy7ydIK1phK2M
	M4OHIXbwCNIy2VfhNHZotwOV7s0LXBCULMLZTTJ8EW1DjUUwj5dLilqCKu8WtHRArUFAJvm4zTl
	krKYZXrkZlCiodDbLj9o0nmLw6/jGG1n8FcTRY+DcbpVG+L2/ettta7AdfXq8ay/IR+BkY62kvW
	nj3ehfM7EkP5pN3sw0z3xFFHEJN0mUV68UWYYTZGjy2fFqm5dw1fqNmnh5exKG4jRWkdn3pTpJ2
	sOTuFNdJEUcZj53cppuH2ClaJ5iK0klXi0Ixsjv4Bf9xkiKZp0oiTbsvjBRBaEW3NzkNCKS//OF
	MjnyAky/NE7V6uv2yIkrAIXHtFKdpmK3MRAQBFQNZ/+peTTtOW1BnqNdU3zDyVgA5WO0dtNfUPE
	AK6E+D+M2/4XpE1jNMlvMERA==
X-Received: by 2002:a05:6402:1e8f:b0:65c:5af2:902e with SMTP id 4fb4d7f45d1cf-65ea4f0c81bmr6681492a12.30.1771900736113;
        Mon, 23 Feb 2026 18:38:56 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65eaba2e183sm3151381a12.26.2026.02.23.18.38.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Feb 2026 18:38:54 -0800 (PST)
Date: Tue, 24 Feb 2026 02:38:53 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
	akpm@linux-foundation.org, anshuman.khandual@arm.com,
	apopple@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, byungchul@sk.com,
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
	jackmanb@google.com, jack@suse.cz, jannh@google.com,
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org,
	lance.yang@linux.dev, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com,
	raquini@redhat.com, rdunlap@infradead.org,
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
	sunnanyong@huawei.com, surenb@google.com,
	thomas.hellstrom@linux.intel.com, tiwai@suse.de,
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v1 2/5] mm: introduce is_pmd_order helper
Message-ID: <20260224023853.if2yxew3ylkhfim3@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-3-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212021835.17755-3-npache@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam09
X-Stat-Signature: inid44xjnu8wjp9mo993nckse7891t71
X-Rspamd-Queue-Id: D49821C000A
X-Rspam-User: 
X-HE-Tag: 1771900737-641842
X-HE-Meta: U2FsdGVkX18kpbUz/16pUBReQF1/Y3zEfcKtKDOARpRZtw2jQ20pXmw7DJ3JRE+HsbrBMJgALznfDNbsvEuQC3AlpfZ5xzCvmeX0K3OmwFyhccFJSFLPgWzEvKVUC4pxAMAq6eWYrEYoWLsNsgWkxjUkBoVcPEqWN5m+Wae7Fm3sdM7h3mi7WY16eSzMGqAFOo8+qD3A8qHvYwuLCEpklGYCKuUGkkz94ikvvetjttT7BqptZZN3DokZlGSu6FOFMiATSYFq8J+923UpvZ9IzJeHv5AX0LhBw/kAzaHz4QNR/lWGw3KB8ii21O9qPGq0oki4M65atwx++FaI9LmTVKBSTXHFrBmAHW9BcQj+E1N1xsjRZN1cLrPw8JXmo/stCAP3oYjF2/W3HSW8tfKRnV5sIKT/BaTgiiMYfb6cH0gEwThODdQAsFh+1YSNinIwuiYLc2GSsHJfm4yPJ+X9l/sKoHG+2zQ6smLlKfcOVKDPUrXw5ObGcxJG8FlkHZCxDja7bHyQBNwIWjLdIMbQ03A+vcGYv3M77ZwORqH+yhdHytt9tIse+KmZF7Qyd2ING0isOfiR0aNTqX8YAzYDBpZpx2ja+MlcGOt4QkNAH/D+UR9ocnnpHiVmvTUe28hug6AcDTf6ZCT417u+RMu5KwgakTaXK4j2PWGUI53gahaHidrglqLnSCt+N113a5CFwCFByMN197xUp77Nl9WWl/VDCPFOTiN9nh54Tob70msmlVDc6cJu2X4dGUKPcrN3vdb7OYwAKBr0YaCbDOu8eW8pDdIOzR9/JaBqzvtzyEaMQBRKsI0n7TuDGbJn5OU+TIad3QjyZXcPs+SnC4d3kn9bfSBacUzq7PkmvVzREccMXX2Ly/zg7iRu7Tf3FbTH2FrAQjGAT4qAJAFn0XdXxn+NJt//va6/xntXYP/3ejDkkzcNKFjWsiBrEOgXlkBZ/BL47lJJJlR11/Pdx12
 slm3Obyf
 sFvQKJTpCL58/O0GZuTrL3Jhg5X5UhQt1usxQhDJFS3kaKltwW4JMSxm0dorinqxfzhm0JH0ygDn+XZTvQZnQ2iCO0aRy46bE+zkhvBBf7cYqb3XvnQQ+6ciPkgoA4VG763qFmP3wL+ag9ZTk1xoe2ANJ6ppRmjayfoWdOC80Rsq9/rtj9YvfB1OhB22vrmRoqVllr7PfFsSnMTmLGxCCUl0IG9FUCveynCw36HhaBc6IXtMd3dLCrwwGFcCwDoNCL2S+Efxms1yLS+zWqGwz/NorxQYULBPLeP1c1TlYC87nyd8iU3OE9ampowEn2FCSg4WFPCpP83cfW/2XolU9Lwc0iqKe4WBvVQPORIdIUvPlshvGrbSEmXbCtgcuc1XJrSs4pGhhw7iaBVwPlM5ofIEIdTO4YZC41NeUEJuTA7yBMdFSNVG9RHy2RMvgRH5764ZNq8mLu032OkUHHyXr3eeKzc3meIcipxc0fjHcM6wdJL4nnUqqMUPczO3i0ek+/btYeGFrxcPw0JVl+MoG+Hg+mFKtuXYJAKEtjrWW/QbodVpWVL4wuUebG6zruoCrTbme0rOlPoZCJOC2Sz9DChRaksNkpLl1hzmlI8JJILdxyJdq6Wi+8Sp6+4mRhNOtnoasRPcLcxyruR5/1s+SolOh3tJzrI+ZGoiZKWPzzFQ6P7NYufSq6dHrmBgCZHFyWO8X8CktiidYYU1v/q8+HeSGe06D4WvsKTHfOaS1nlwRqEwxq32hnbOg6h9lRm8IJF8obBq6u/FnTtuEfJogPcpg7qfp9ZZ7ieXa6dBAZpip/wfnI3Pwb0a7Ztqb6dEqOp1xxtrSrMF2sjz70rePin3QYWoa53Odht7Xyms3WpGMQI2StVPLY20jjQkwlTbSI+V8uJtL/fG6h0LAl2STI1MpGDYB+27ZeA6wjGKcS/zmbrZtUGTwMCJhrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 07:18:32PM -0700, Nico Pache wrote:
>In order to add mTHP support to khugepaged, we will often be checking if a
>given order is (or is not) a PMD order. Some places in the kernel already
>use this check, so lets create a simple helper function to keep the code
>clean and readable.
>
>Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>Signed-off-by: Nico Pache <npache@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

