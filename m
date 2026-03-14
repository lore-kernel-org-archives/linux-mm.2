Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E40E10706C4
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 09:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6678E6B0088; Sat, 14 Mar 2026 05:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6153D6B0089; Sat, 14 Mar 2026 05:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED3A6B008A; Sat, 14 Mar 2026 05:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BAA26B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:50:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D77D31A08B2
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:50:46 +0000 (UTC)
X-FDA: 84544199292.04.8F0E972
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1023A180009
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:50:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=viQcEvSs;
	spf=pass (imf06.hostedemail.com: domain of r@hev.cc designates 209.85.215.173 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773481845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+89Xi37wcYlP/W+L3Ja1g3s+pCfX5Ep20EarskpAcwM=;
	b=ndojTei8q5llVs7TSMnsCddZPZtRN3vQEa8Lg9xguYDd/YdWbCwViiOBLaZMpsaCpLb5Ui
	52NIZ6xzvkmq1vW0GB1i/myKI9iRUSTCOKdKIF6UgndPTxXt+ZeT6HWPwnuLWBeXpyWcF2
	zVA/VUagfcJU+A+Gzx9/RgT2bIJ/GUM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=viQcEvSs;
	spf=pass (imf06.hostedemail.com: domain of r@hev.cc designates 209.85.215.173 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773481845; a=rsa-sha256;
	cv=none;
	b=jqGSYbtjXX3iSBAU3OuK2LE9O3DaDVMJyVYuBiCEIog/V1CMvqTvIkSwy4nurja1rFzDtY
	dl95ICm4fCPeyPOJrIBveJJWN3XOj7PYDWBAUwYSvsZzGUQAivqIxEg0lmCuG6SyhIwRaC
	ZiyGQ+yV9R3GqY/TI2G/s88CPYFUKsc=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c738aa3cbbcso2228263a12.2
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 02:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773481844; x=1774086644; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+89Xi37wcYlP/W+L3Ja1g3s+pCfX5Ep20EarskpAcwM=;
        b=viQcEvSswCXqB5lCLRDKz65FTw5diCYXSGoq/MX80Z1e6CXDdy6ATNfo5b10Ts2kig
         pQRv+xnt7mzAwdb4CI578juq9aSI2QdTQjzsvBpRz+iDzGFl8iM5YBxMGAxiu16X2nT5
         0IeKurKigMPTVMzhmWWk0EiK40pbtCMGiM2ZrWBIM1lWeqW+7kV/xq1Q1Y+lKST+PQpA
         zkFonF/khjv3FDhfa+gfyfe9uRT66uFkk4l1rY3yKw1tISHWxLX+fIPjkpkyZqwqe4Ou
         KM9SE9JKIk2sso8IJBPhA+NafsMlevSnXASTrvRXpiW4sYjvjms+3K2ZuoA/LJpVGZ6G
         jL3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773481844; x=1774086644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+89Xi37wcYlP/W+L3Ja1g3s+pCfX5Ep20EarskpAcwM=;
        b=XRJTrcodYX3RDoWR1tWwuMs3HsROW0wW5dxYGAqLpp4+U+ln3CrYYuXNC6mf08kJul
         9aLVpX+BTQG3t5ZuYPoQKLlUEDFVL+NIFhJ7zL0PmpM5MlyjABAWmIOAST+ZX5kSHz3p
         Qqo/HowvpTxbCspOyoS+gupEzI7ZG2d0pVionSmcRSwlo8eVk4NKlP4MHu7mOg+OSX7b
         yCEtt+Qf5aQHifN12DfK3Dve6jWYU4C/W+gt/79tpMk9Frm8LhSuyEeCcDqKHDG0hUoG
         WCcvVNE7Hh+FaohuPFBAD4z1ypMUcZrDQ062hL8DuFp1t137Ds3DgOYCOswhDxFEOtQC
         5Yww==
X-Forwarded-Encrypted: i=1; AJvYcCWiA0n+n2YA5EqMwU7bLgdgaYAPkRIeWhylXYTE9t4Ap9X0PCz1kwx+osF58hxpFzSXsiaOWJcylA==@kvack.org
X-Gm-Message-State: AOJu0YyGw9ilEADPqeC0qZJMujPPD8fhJ4SHrWWRqxqATADIj2G7Avyr
	Yuo9uzn1ua64iqF2T+/x6QWNtGRD23gCrc35w3R/Z5BMepwOpWFHb3UvDAtMKuW9jPI=
X-Gm-Gg: ATEYQzxSE74D9RtUjZFb1PqR4SjTyH+Kcac55K5i597G+wHcV2/1v3ljBebLx/Vivgl
	OyPa44ivIRrzwz/mYbU1JZhJ5iteaOdRo1UNMmxQvludOQtA4Q/LPLbMj5NaFFg8fmDc/pQsBZ8
	nCPkStOcL/wm1d3FTE++3gV795O1htiTQen9rUlc6oQ7auBcjHX3ENsgoAL/psNgNF2wN4o7FY1
	MuSr16qxvp4yMZ/EnFuZ1tg4rr5WuW09g8ifEcxHipASmHY1+VhGHo/83QQ9l15qxrcJnI4ctLx
	UdIA4S73k4C4mXelZTDnFaCCs869WxGsQ7f6bHiFlg51jJlrR4NV3xV9yOIO+3oCfkitHLFRLr5
	ROLLlMOURwN8stxJGPs1jeg0B2B1AePms2QlPPFQMGhln9V2sXwDjMAERXAnju2EZkJbhR1aBFb
	qT4psgOJv7HL4=
X-Received: by 2002:a17:903:90f:b0:2ae:59d3:27f8 with SMTP id d9443c01a7336-2aeca999738mr61011205ad.19.1773481843716;
        Sat, 14 Mar 2026 02:50:43 -0700 (PDT)
Received: from gpc ([2400:8902:e002:de08:5754:7dac:85df:935a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece5f8dafsm47520565ad.26.2026.03.14.02.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 02:50:43 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: usama.arif@linux.dev
Cc: Liam.Howlett@oracle.com,
	ajd@linux.ibm.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	david@kernel.org,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	jack@suse.cz,
	kas@kernel.org,
	kees@kernel.org,
	kernel-team@meta.com,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	rmclure@linux.ibm.com,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	viro@zeniv.linux.org.uk,
	will@kernel.org,
	willy@infradead.org,
	ziy@nvidia.com,
	WANG Rui <r@hev.cc>
Subject: Re: [PATCH 0/4] arm64/mm: contpte-sized exec folios for 16K and 64K pages
Date: Sat, 14 Mar 2026 17:50:21 +0800
Message-ID: <20260314095022.217231-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310145406.3073394-1-usama.arif@linux.dev>
References: <20260310145406.3073394-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1023A180009
X-Stat-Signature: jgoib3jmqfpw98kjk6khrtc4ou16ohyu
X-Rspam-User: 
X-HE-Tag: 1773481844-817148
X-HE-Meta: U2FsdGVkX186dVtS85xl978V4nptj8V6POhOz4OmtqcOZ2iLbmcg0j5fMEtOfbFT2BC77W+Qpxb5Zt7qH5Odv4Y2VBOdCUAIVfY9m35CdHKsMhS8Tvt7eQQahywCm/+po84qYLmfRQLCo7FjxBDPQfkILcGtMAnwmRnssgoeHADjOAw/sTVR8KRPN3Pk24u+Tns5F9n9qxvuOgG+9vczU7XMPT5GGC5A5LewmpRS2cQgB0yDOBs21hnG1KcYW+4AZmhzn0ezE30RnVUNeMAi4yvm8NhkBQjO/S3ANHlKu7Aqf/XuXzUg1MimoAqNIRjJSAeoO4gWQ2obUSVxytAsYoT/4uuov/DPRRm4q4XqNSETRNiVpEQvFUpb47OU7eR/44jmRoD2D6rRylj1JURT3bkElnekUjdfdfY2btxefM1HRn5RazxrH8vHrXQ2jFAOWBBWzeUCAz2imuBN1sLfFO4s+ufeZabfKh+sOUtPi70RJ72uLvK+/5TeaHMpbihuYe5o5jWaV1Ai2ULlwN+40V+gUcAnvaBlCIN19BbKnJwH7HM/xQ+SfTvmtKHUzQzOxWjmKSaBhqhJ/VDVI27NfNa6lKonfIFG8p8E34VWQRdF1Td4Hz8oED35lsdxlyJ/kpA+kPg2CBTtI4PhX+MBfeg05mmV9wypFeoUH+szxtIO40YCznD9aT/pgmWL1nXYZ507QV8Ioy5zndB6w3QpxEd/PYWq75qn/m0v/bWTCB3Mh+b7iymaUsztf/D2haQHMYUb/02YMBYBXnneQLYH0p92Fl1l+Qva/tw3dzfYesECKKBXv0gTxs/To9q3jIkF/5Hh1J1jB0JdupuQOQww6mqKGIW9LpZ32FnZ+VpQw4AM89txmkJHsbFFg/onJpZBz2hMy7/ws6DEqGmboqhnbtxT66SJBO+aIghV3+VEloLpe9dQ96NW1TcGMdU4D2xEjyezl4K10wIJBH0wEqG
 kDLDmdHW
 EPc8S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I only just realized your focus was on 64K normal pages, what I was
referring to here is AArch64 with 4K normal pages.

Sorry about the earlier numbers. They were a bit low precision.
RK3399 has pretty limited PMU events, and it looks like it can’t
collect events from the A53 and A72 clusters at the same time, so
I reran the measurements on the A53.

Even though the A53 backend isn’t very wide, we can still see the
impact from iTLB pressure. With 4K pages, aligning the code to PMD
size (2M) performs slightly better than 64K.

Binutils: 2.46
GCC: 15.2.1 (--enable-host-pie)

Workload: building vmlinux from Linux v7.0-rc1 with allnoconfig.
Loop: 5

                Base                 Patchset [1]         Patchset [2]
instructions    1,994,512,163,037    1,994,528,896,322    1,994,536,148,574
cpu-cycles      6,890,054,789,351    6,870,685,379,047    6,720,442,248,967
                                              ~ -0.28%             ~ -2.46%
itlb-misses           579,692,117          455,848,211           43,814,795
                                             ~ -21.36%            ~ -92.44%
time elapsed            1331.15 s            1325.50 s            1296.35 s
                                              ~ -0.42%             ~ -2.61%

Maybe we could make exec_folio_order() choose differently folio size
depending on the configuration and conditional in some way, for example
based on the size of the code segment?

[1] https://lore.kernel.org/all/20260310145406.3073394-1-usama.arif@linux.dev
[2] https://lore.kernel.org/linux-fsdevel/20260313005211.882831-1-r@hev.cc

Thanks,
Rui

