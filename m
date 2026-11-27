Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B3C606A33B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 02:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=AdoBzAfV
Received: by kanga.kvack.org (Postfix)
	id 2612F6B05B3; Thu, 26 Nov 2026 21:06:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 212436B05B4; Thu, 26 Nov 2026 21:06:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128A06B05B8; Thu, 26 Nov 2026 21:06:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E78D96B05B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:06:25 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5AA6C8013E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:06:25 +0000 (UTC)
X-FDA: 85479259530.25.124050A
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 57517A000E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:06:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AdoBzAfV;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795745183;
	b=P5J3rcQUDAFClpXqvGeBeKMfE88+n/+l+f193zsCDl84FABAhlOq3dfQxv4wPp6yuYacJy
	V4MXmAbGikrq5R/Mv18QpmV3kKK8O/0+/POdbUVRIM6pjIGQ8yBWsxhDrBcnPJnccQr6SH
	C9PITqzLEdi6r6S1lN6IE8U7QD7qeqI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795745183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gi8i700zgzoGE4wii+o6F4mqGWTqx4rmov+vyFiH2zk=;
	b=LW5HAqVa992D/nFyfeOcxLTfTEkX1IxCp8GV7VoDKHeYeuVpZCJIYb0K5zbCEh4FmTLH6p
	6W4THE/pjFXNVgfm4Dv7sky3Yn/48kQVmjOoVYTO/ScNhJZkYdpAx3O20BoBguSqimJvri
	q45FJwkuFBKm3CnZFe0LGyLhbO6XAls=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AdoBzAfV;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc147d86bebso4649941a12.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795745182; x=1796349982; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gi8i700zgzoGE4wii+o6F4mqGWTqx4rmov+vyFiH2zk=;
        b=AdoBzAfV3lj+TOo9lcZNVlFPTkr+ni6NhnQULeIGG8DER5o+ZPBZjaMXDswBC914Qd
         KuC5j+V61fPp+962zTZoJYXTBsGj1VtzT2EAZf4MZ1G/e3NBVIVPqvwy13/CexYKayFt
         o7s5YEM5vZFyKQcoVEsOWwUmHqk1l+5MV6uus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795745182; x=1796349982;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gi8i700zgzoGE4wii+o6F4mqGWTqx4rmov+vyFiH2zk=;
        b=DOVYiKYsUNges5eHq/IGAmY+X0otg528l54lWZgbnKMGqRPq/DSMPJyxhAV8Lv6xl+
         J955F91zBVcqXFMSTmk9FwdXIYCN7U2qn493yLCtKjUv7N6U6ws8dsYZ/mQ/HOhX2Mq0
         aupPTcMow9R1yRHZEAkJAgfSB4Sd60e2LE77iScqs07Tg1bWOj8ZgYHCm8x4jNyH4r+S
         doXsLCvpttGTybivmmtBbXKY6gbRQOrA/sK2NfUebTqVc8jjsx+YayBUFYfj3BnZzD3/
         6zM7xLmSTjHK3aNLky5iDY9+/gb1CnnX9wU7AxtyBYbvN3J+o77FK4xZzAbgng8AHVbU
         2iWA==
X-Forwarded-Encrypted: i=1; AL+hErEvgEnukoGzbUMXvDy/xGHNIuA+8tP51VNHaT0woTjqq4fRJa0nYfL1pbMxWk0dWDmZtPDtrD+LOg==@kvack.org
X-Gm-Message-State: APuU4Z/AncnVsPWAhaooIr9n9julwvXSkZ+/+m0xQFHH/QzsdMgLr4VA
	DWI+JQ0A+z2b+PAakp386WjLbyCCFGpz4+2P1Ekq3F8Z2DDO8m2UUp+2KGuto3Apxw==
X-Gm-Gg: AZFdTZe0EuK6pBeldOUzSCnfW6hORufVyntahQqsTIbCcfVGuQ1UIvInYZvqL6BQz4L
	35qYOqPCd/GtzVO0oTMSB87cYPgesEscWIflqxENsiL16t9ekPZSnBosHynHqm8bRVajVmVasMF
	z1BvjY1TURyyQpGWI71MtK9n66k/ykt1BuM36pLprMC8Dg0sBkwvF8mVSIr67uw7GLdJuymfFDG
	Cqok6EZUFw9GNKUONqjda/prZT2pdDFlvrKE2Pbm2ZCF+jpAfUiIrLDPhHxjScIWs+TqO9LlGCJ
	Y+eJpggczNMrSWG20MMoRmUJC36gZGevpF1EX7wzw4rioFFqwrYMAqs+EQwI7JVmdWd4EnM3Ujz
	h7R9Jkl0E3wKYhzX31uXxyaEMLYMicQfhJL/Ue9FiBWanYJu4u2bkEwII5vV273NRIepvB1QVqv
	eLERzNZX2QR5mgZKj6SQB4UWHCs/5RBUECj4vU3cnYQ8ll7LuTICQT0hU3Vs3jAQuaEJnX1HH47
	b/HSDu4vC9ybVD+l2ihK73PuG1Rfu2u9JrNe5eCTSXuxUa0TmK/rjOytvCIcacrvUDmstz3xkY/
	wiqWmXNKb22LYgLa2RGTC7rgVZGsxcFtBc2QG7k32d06NZH23U3ZL1eefkug3f/LLR76N1zeeAJ
	UYEbsNBf7wlHg+A==
X-Received: by 2002:a17:90b:5407:b0:3ac:9ad9:6afe with SMTP id 98e67ed59e1d1-3b41c961ed9mr14310208a91.39.1795745181825;
        Thu, 26 Nov 2026 18:06:21 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:5bf8:984e:5bb:e51d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0b52dsm38236079a91.5.2026.11.26.18.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 18:06:21 -0800 (PST)
Date: Fri, 27 Nov 2026 11:06:17 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: sashiko-reviews@lists.linux.dev
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	Alejandro Colomar <alx@kernel.org>
Subject: Re: [PATCH] zram: do not modify cont sysfs store buffers
Message-ID: <awjlWfhrLyoHcy_Y@google.com>
References: <20261126014518.1318583-1-senozhatsky@chromium.org>
 <sashiko-outbox-236427@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-236427@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 57517A000E
X-Rspam-User:
X-Stat-Signature: zmnnqz9nr1x6qzn6r3tpeydjkniiaxjm
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795745183-71281
X-HE-Meta: U2FsdGVkX19HGsAt5tco0JKdTVvrWqAluhOfGUH77BY3XJQFfSTsJ2eJcl81RABUHl0ruJQcWyw32r7IwHqSkr8Y86d01Qx+ZUkCTEoku/qNUieVI52LxRWVjG7zVC2koaske6TCGMZ1IIf+xKYjbbFtEwPNcCocX2SDt2Xa50a9uniUsnULE8uF1CavdW8SND2njX8rykWJQgKGAHsUUeL5Y/ofZtmQPOwH2FnegkdmoFNabnrkMhlfuN/+nBR8bC+IMp1Aln2Y6ddk4i0hhxLPCFM2D34brQGXgEJHA6zBEIKQKJ4lpcirgFHmyGZEROjGbxppmWPvq9pkQFsnItWKzCHY5382ZVqe1uBYeV8Yk9GWVCEGYgwVDM3J+CU1xoIM7ic9QOhsLMJiYcmxZhu84LT8Rm2EuK2NuY6G7J+EWt30MahWWVT8Tu3KWl2EWrVe4G5lHtN1TcWWBZXnRG/I8UF62jO6eNM3a6u5/CrIvT2XjTUrfAGLfh+l60T3ObApx0neTqJXYIYhsLAgqljawbRnab8Vmk01wsQowF8TZ+tRNFkWDlUcl+LVp6BAsGFetZS7Aa/7Iw3TGVZr1KXyZihX6tXsPhwOl1SP4VOp5Y25LJfvM/vPMz7WrlmkEGjMBTKtJhWuQhRJMYBY/4/2eR3r01m2TnqPlQK3GIttEseveyo+FtKHlo/w2RCre9MiihGKmZ4QadgNKz2QlvqVC76qQffaq0asc0T0UVFl+goCvkcRlMiyWASfHMYbjoAtPXCe583g4+z74sTsLV+8O7LfcCf9F/U9OK2NuS61jzZfB3Lej+tObcWEQqJy1QIrNvb2YYpsa/0S+m4dUG5ttRRV3JsraVG1cLXcrDcnat32nAc2BAbcjjJDap8citPfEeybqE6FV00FIj+zmJ93YdQwg5vw7/qqRbNcQSAjcTLUrUuVjU2jFTplbmuGxO6Qg+2GlamMXr+W2Da
 N2KfVzsr
 W5sBaA40dS6hgwGcLVVQGTDtZu4dG6gxjVOasqWTkeOkrGu/fATIAhJVrs0iorl7hG6jXbW1LrjNR0pTlS8W8bdbcpNZ7JR881pef6Mk6gfRkyGlLmNHtDBbfhdvx2ffMZh7snOvrbELTpCioNxTcU8TX3KC4Fx93f/Bo1PITgWuwZ1uBGCaTFqJniYvPrpOFtCZyAqdUiILDzEImHp1cJPYFAo2d25AnLKQZGwk2sBA/xb3afPuv3qACbi7n0tQFo29LfFmTjXMhlyg7Hhc9LljgEvs1y0gmkXWfvFp2XICjIwLJXQGB5/bE8FRtFP3i3EZECy70ToWyphRefExXXs1JV+CzFoZRrPK5VV9E/hQBUJaE651rCq/23kpj3mqwVQNtqgYvYsXgDViuPhvllqzf1RCQuw5+7BHw2/FyRygnX90xhz67xitFE7roqhzxPOEiVCa134EBFu7OTLpLsHSWGR2pucoGF8TjAHmKVMazogL6w/GbI1V0tXvmwPRfJG1onLJro28olh3yRyDDAgQ045dmlDxqGnxKmz2cltFpY5EEdUZMVBXB3pliOkj8odHeVSSqNqEtteqqS3mfPoMTVSy2m6xgeLSS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/27 01:59), sashiko-bot@kernel.org wrote:
> [Severity: Low]
> This isn't a bug, but include/linux/cleanup.h recommends defining and
> initializing __free() variables in a single statement rather than declaring
> them "= NULL" at the top of the function and assigning them later.

Yes, that's a recommendation.  I decided to follow the existing zram
code flow/style.  Like you said, this isn't a bug.

