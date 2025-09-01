Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A63F1CA0FF2
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 02:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C266F6B000D; Sun, 31 Aug 2025 22:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFCC86B000E; Sun, 31 Aug 2025 22:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12CA6B0010; Sun, 31 Aug 2025 22:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D31A6B000D
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 22:58:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C698140628
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:58:30 +0000 (UTC)
X-FDA: 83839173180.15.556C8E7
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3D69E4000A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:58:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LPP/82NR";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756695508; a=rsa-sha256;
	cv=none;
	b=fRRTyYU+BzXwObCQ2HVbFlD3MeZtBlUXsSFXh6E3SCfKkcEf8jD1oiA9zj3Ly7zity0lLB
	7TeCh9HhzMZUFYuOZUba/TM+jnLegtcfkSUae57+3BeMRJEEfzVYHQOvLjWjUBpyN+GY7/
	R2hWIIYGlbtDQxo4bW77OMQ0gE7pHzw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LPP/82NR";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756695508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xc5xb7dUSiUl+N7EzdGMbpJHVkz/svcP008qWdxybM=;
	b=lYZnMdVwzZFejjgoQpSW8t+rv0MxxymF+MmTlBtnUEz6QMAIQaTOyVbK/VT4QSR1Mq+Fx9
	6yeo0Aij6rNFy6eosu4Tz+pMsCxVythkzx+YVjsuo7C+B9zIQkKW7r2GquxXzlTI6eP7lB
	sVNsZkm1g2554IaxJiKuIK1WEGOEjAk=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-248de53d12dso22716655ad.2
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 19:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756695507; x=1757300307; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8xc5xb7dUSiUl+N7EzdGMbpJHVkz/svcP008qWdxybM=;
        b=LPP/82NR+rMxVovtuWbkBJregp65u77uJG6ayNwzSHExy8ZG4oa8YuoTGuaaWlt1zI
         x96eZ2GoazxxA7sfsa/sx/84H2BRwIItDRoz7FRhbMcSX1MoGLoU61bK5BoDfGk1vDqZ
         5dhKnoQRH3mJqgyvycc7ZZT+ZMjB6nfKsSpFdPYFwBsGjCLLD/7FdPzC/t6BlZEY1g8F
         zUWYvvQcgcftsMJnG5XikMLsStK9RshZZNePlENHxRTekClyzANxX0x6vcUxKMdvrWop
         xd0tUg0PAJJZIESRatJNs6dsvsqY5AEddHhpw6fPesHa6Kfwd15CCHhBWrY8Y1UVi1G+
         pQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756695507; x=1757300307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8xc5xb7dUSiUl+N7EzdGMbpJHVkz/svcP008qWdxybM=;
        b=d+AcIqSiRd4XqK94izaQ3YwX8A/0tHodnUSehemEoKytegr2+xC/Jm0Zs/qWHKfQgG
         +nNOIPrt8r3TD1n4e6pSdwMFYFr0Sfujsnd/pAPKFUnq44anBnNI0EoulDjD6AtNNSBw
         Fay7IPXZtdC03zf2uTjlkC6pcQUpMfTGUr0AviCxdimiST3d2mxXgNHBlMpRS8V6zWBx
         F5H8WXWePRWvBnPo2BEFQSfh0TikcjOoe2LmjcDke336tk7NQNoS99o1REYcKfTDN/2u
         jSm+C+o8j8yIXcLQJEUm2j4fHe/0pjQL1AW7WhDSS8CS/DC6VO++yI+z+WRFfxqfWKE0
         KhzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcTkudTeSLPShwZNkoU9WCDamaC8cAoJlWekmUrlruSLxRY115+Hj+n7enbnxEUl1m3sPRswEBbA==@kvack.org
X-Gm-Message-State: AOJu0YwILRsGIq3t05ka4MGjMbG3L7ciqVnE0p1IcTyARVwiGl+xYYmy
	BaF3y9PrAKP2HjerjqPCPCuHtmtHcyG+vlYztVzAXsx5p1q6K3Aqd4t6
X-Gm-Gg: ASbGncuRWOIgaDx+EKB+4psrp9Uizr+YIQuhCw1eEmKx7uM3MhsP7KUj0xsSjN5s6yL
	tsvXde1jqc4rjfUiQ9BY4SRkImQsjOiVe+yZ6DXHBzhQRolUX21Nr2LLMfNB8ZoUCbUWxCyFhsY
	n35BOtXW0oukAv8G2r0keAchUXJtH2Wc289TPZF4z+Ke2ZuD4ZcSv34MfTG4RyXWxj/BueLthiG
	TwTk1D84hxF15NHLPQuiQAa0p37Kfr8ELUCLOv9EjU132eR58xgPcJB+a/LgyyqS7Z96lEcwuF5
	Y/sY6Npnkh6u1bk04ngPCM6fpfofuuFr4Dmf+aY+bPu+SiBDk8VzhRtJ5bWtG4ygITwK/9JFS0s
	qiPnrdxL7EGNUJhn5S6gieA+c98QEywExrKlyYZv/2Mrl9ZHKxi6QSb9zdE+4lnPK6eMXsw/jYX
	76nTPmk6TczdhkaolpEA==
X-Google-Smtp-Source: AGHT+IFyHhiruqCGi2RbQrXtTVcp3oahgZsFHaTw5UBozGNvye3RIxU3ujQdE+d1aHrK4k6SNgCdrw==
X-Received: by 2002:a17:903:2f8a:b0:24a:e25d:c704 with SMTP id d9443c01a7336-24ae25dc9a2mr7167595ad.47.1756695506906;
        Sun, 31 Aug 2025 19:58:26 -0700 (PDT)
Received: from server.. ([103.251.57.240])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-249065d1b19sm86681015ad.131.2025.08.31.19.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 19:58:26 -0700 (PDT)
From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
To: akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com,
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
	richard.weiyang@gmail.com,
	rppt@kernel.org,
	shuah@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	vbabka@suse.cz
Subject: Re: [PATCH v2 2/2] selftests: Replace relative includes with non-relative for kselftest.h and kselftest_harness.h
Date: Mon,  1 Sep 2025 08:28:16 +0530
Message-ID: <20250901025816.1729-1-reddybalavignesh9979@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250831130340.c096ab001dd38bcdb11146b8@linux-foundation.org>
References: <20250831130340.c096ab001dd38bcdb11146b8@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3D69E4000A
X-Stat-Signature: dwo5t3smbab5gfxqmfesmksyustrb57p
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756695507-3056
X-HE-Meta: U2FsdGVkX19u1/tTVMniiVXgrd8B6YFmFmZsnLcJBVaQbC26hWGSqQCj1Lgf7hJKujCPdthwtXnpOaBWK5GeAL9H2eLVli5mkOetVDLvQU4wdCfJhkm78uEkLLAAlCrpO5Pop+nDUXYi6fJtqRJHijx6XKY0xM5rmnsYMH4+rsptpkhFzoJD1HwVmY/tPDYPEwhm+L+SsQ8S2nBj6FgsjbGUycoks6l0j310l+CXKMJq7gLO5DuZHtGV0Tv5Wi+QHioz9MYD1FPcIFA4PbJwZ0nFzUrHf43LMai3MYJjEsn9WdLaYD7HNOJuQ9B7HR8VFYr1186sL8Vq3IPk4nSKhc64BBn1J2eRiSEseHfd8DYctmEDXQGFtlFxY+9cr3DPJMGZ0Vd+wc21uVkMDvFTieJO1LXGzCpnLX4MCe6ZhRHlPxCa9WUXuesusSXH8TTVoDPqRorA1VYytPwThLzZGXXF1SiJx5asGHTJ1Umlj/fzvbOS0AmKOch5xvIDIFi8ZV+E9pgznWSmypvjG5XkJQ7VZuflIv7bBPcjuq3Hvijy+d5HUb1/689xYF1b9ZQT/TEG+x5jRQ+fehcOJFrGEkF0Xzl/SaQyfHZqMH2rRq/bht4mLBIm+LtLQQQO6Xl1ltp983Du/6b51VNw222WanX58RJJyWDx18MphuNHRgPN8lMp3GtA+DpcZPPv6gFF5iGwFOcMoPztNhec6jIUgL4aocJk9VX0eyPt15h3G83/7zei9ZTuZ2jhbu2Ad0DQpcxwOzuOUqvRcolXXXN1pxs9eSU/DAU7Sj8J3t2K7jsmoXX9XL/TIggEdlLsmxxzq8IeRTiYwg1XPhEvCLv1UKKo4V3XbzYZfseXKSx2EX+54qQL4BNrDbKi2m+OPIStMA2nnp1v42unPl3i6BMnW8B2UrbpMgcM5F+O8zdBsIY2+Ucr6Z/2Ttxgj/+scE1BYH0tgxJ4S2w4Kxlhn+b
 8CNaxhNt
 ckWaqxgnfWQTVLH5IoeyzYqpQrAjMrl7Q2VwGQrlR8bMTlSMQhdvwt++qu3K666F2JiJjAw5497FOfwt9C5HLBSIxH+GvQPJMgG8fdQd/q0UQ0nwXOvTZ5IgCANoFiJ4ExkGsXFpyj/EJKVnXm1c6jw1+Fanj5KSM3wdAKN302bRHhocyPmMFDYIecxu3Swhfx7VvLjrKRE3r51WGPaf9y4Z/ockoqIlJmFJFU9sdtKEGSeGAElEAs/Cq3gfKDU4LCmG/kztmwAZTo3ERT74AvMCtxhyhwLOaNghHQwbyRei3mz1OdBrhDhAxMolEH0L8ii+DqI/hEvAKVLW5/zNznKtHCCyT6Shpf+MBHZNSHc1CsRxAZA0jcKqbDuen8Sj9XA+p7r8FOTlgc4N5e2o+kUPc3MvVhsrROwXGoUrHTyX07+cTe8C2gEoC3F5IJd4eJAF3q/qQL4+m0e5P74bJE2+M992Wec1kINH1OK+Kk9ktFRmkzLDvT9cxbOTrLHEp0pDEBVG/7KyvSHn59phvI3Ksbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Sorry for the trouble caused by this patch. No problem on
dropping the conflicting hunks.

I'll send a follow up patch after 6.17 to cover the missed
conversion sites.

Thanks for your review.

Bala Vignesh

