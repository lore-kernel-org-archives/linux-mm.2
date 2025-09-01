Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE493CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 322F58E0017; Mon,  1 Sep 2025 04:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D3978E0013; Mon,  1 Sep 2025 04:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C29E8E0017; Mon,  1 Sep 2025 04:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 032D88E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:11:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B98551DEA2D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:11:21 +0000 (UTC)
X-FDA: 83839961562.05.FBF2933
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id D7FACA000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:11:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e4dNk5A5;
	spf=pass (imf25.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756714279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5AGi7XhHW8VnKM63g6aNYwYi47i9z0v6I4c1IVd4yQ=;
	b=yIjQYHtIQcDR7I6VjhtN/fNk4/B4pdv7NR55OOhAO1m1C5y06jOma06pRDr/bdqCrxHs7z
	kJGGfDR3z3teXdovWkzFmY0cxuUXgfSkGOZpU3WxbV9PhSP+Ls9Wz2vHroTEB/7xA4AB/t
	xeEJ2lYDwSZbqBFpz8iQds5NypSW11s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756714279; a=rsa-sha256;
	cv=none;
	b=NdGxEu0D6tvUQ/7VTeoT0alUYd20HTkliUvtC9//8zwmc7BDFgtZXfMoxo445+KCLo8CNc
	Pp60uIa4DSBctr0qYJNCn/sncECvgeL6xeX71mC0hIlg5DHFkWwEBq1vrtlS2q/4LkIBtc
	jVFlR7NYl1ECGE4m5hL8ZzQp8DckHjg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e4dNk5A5;
	spf=pass (imf25.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b471737b347so2629154a12.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756714279; x=1757319079; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q5AGi7XhHW8VnKM63g6aNYwYi47i9z0v6I4c1IVd4yQ=;
        b=e4dNk5A5FCzkrLJsYrgt/WqsLuKYuAWLRWVpE8ojAR5Oq8Ul1scPbOeuIS6WmGCRcG
         gL8VqDLpjYDs3wG1gg6kOCFUdSQ5uo7vc7RRqPuqRnCqYKLNWo17/dUme+4k47SqgyLD
         PcLR7nTTk7pfT3YqWjrONlJdKtRvItiXU3pxp2vtw2cQ9k43qREJtJGuPyHYtotmsJV1
         fANKGQSYZ08ZmIASVdWGEuZnL+3KcM8jhfu7Dbpy4qXuhUDlso+F4DnulVd8M+WO6JDZ
         cqCSjnrpjs8UfYXaT1UspnB7cQ4Jv319Figdm7BR5zwsya+4D7HKGuIRvmi05Zc8fc6H
         06bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756714279; x=1757319079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q5AGi7XhHW8VnKM63g6aNYwYi47i9z0v6I4c1IVd4yQ=;
        b=sHw2ED64lV+hr6JZOuWFPtjT/5CzaGWmi7nam9fJFEJcRK2PMhrPWnjIXBessDv3oB
         vIYfUMGX0YNDHaBhLi7Y6YjR/hLEuhEhicXJX+U1J2u+Qdq/0TkGdfMcw5yqEvkow5G+
         GyhKd3Zi5rUzFZSepyA7jkt3BNNSS8Pj7+CITAx5zy53Nn54rGlWeqjExsc0Nc1daMZq
         v0o3lrNvYON4q2Lpl8YnpKbnTPrKgx4aRe9FOK8hjtKDJX5wg8XCUPe3Yu5/z7Asdeuk
         MJcAgPavdtKywe8YnrwOsdBjhPVIyJmc40Jj/PNuYd38vH7zP51kn7G5E2sVFR9uj2xk
         7ZCg==
X-Forwarded-Encrypted: i=1; AJvYcCVNcrQgAWzv7l1vbsFqxWFUzR7EIflvtx75dipLUKNLNr+8FQOt42gFAot+9KbHABKKm5j2Ki9zAg==@kvack.org
X-Gm-Message-State: AOJu0YxWNiHAeatrgGFr3lEjtIx2CeymRWzzd9dPQmAoSjdPTuJrvQrO
	q1EzT5x361mKCmFMGe/zsk+LTND+6aLxGGbehzbXHIiZQjndu8RqIIPP
X-Gm-Gg: ASbGncvemcu0uUdwmMkLQDkDSyJM0xu3W5I7tvZbO9Sc4L0xEuAXM7eXvqB/IGk93Y3
	RICJuzwwJPhWzsNyJUvJwxKaw97JKCWOIZgY+gz9F95oTbpuU3oQMxE3dtJSlRiBjthCPlmSeQs
	d2mXP1tL50s81vqIByOL66tA6Nwgm3tFDAY578j1tnEOO4mVG2BPbpI1FvSX3yC2qbMlf8J+p6D
	Qbymz2QMGAYJvN+K1f6pTW4F+XRIkPcmBYwLyzBjMOhD2Fzatzm0BYGmZKU5LFXC50sUB8Xk43E
	F3p5VbYEzDaXbmHjaxiNSgBY6K1fqn8TtNwbzdPK4tEpk2fxcSlUkpqtNSi54PS1CuTf7NJdiMo
	GoyfYirSg/NiM+mb4aw1UsC4Qn7gcmbENtrj9d+y8aZpLzzHIhQLsLys=
X-Google-Smtp-Source: AGHT+IHcj/FAbK4A4O/d8fkw6kgGd+jXx4cMW2UIpuOeyQbupm50HFzGMJ0DQuzjVNTanV7t9zNREw==
X-Received: by 2002:a17:902:ce04:b0:24a:ad8a:81cf with SMTP id d9443c01a7336-24aad8a859dmr53063615ad.50.1756714278684;
        Mon, 01 Sep 2025 01:11:18 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:9ae:9b62:915a:9b08:d9c0:516d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-249063961desm97322825ad.103.2025.09.01.01.11.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 01 Sep 2025 01:11:18 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: david@redhat.com
Cc: akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	richard.weiyang@gmail.com,
	ziy@nvidia.com,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap corrupt data
Date: Mon,  1 Sep 2025 16:11:09 +0800
Message-Id: <20250901081109.52460-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
References: <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D7FACA000F
X-Stat-Signature: 7gfhqhowfxzbkf3qf3gemr9p4cp8b11o
X-HE-Tag: 1756714279-172608
X-HE-Meta: U2FsdGVkX1+xCRh28FmdVoXrIchKib+jSYidjkcMAvUKjTPQOoJbdTpnh98aTKQz3AIbyPXjw5x1S3blgQfBb08vxc8Py7HIufJgJQrrfqL+1kzbmMGFtrYp4KjKUYVja5QcZ+uDrv6vycLqF40DMzKfn0udlTuBLOGhQlpqJ1pxWUALMr8Oq6lMtwYc/fPNFPBrR/baT2XnZ+QY/ofNxn8kyUQhS79bTW7W165E6iI1fOZ8gC6fT1xnFp7iq2uPC7njnvt3M2E0IIs7l+57SiLt/n2oJSr6ydQ5FMdy41KKG5NoHu4YWgj9C0xsuUMUIHyUw5UKe9+2w4vpbGcDeuvs1mpcW2EX5sRVZErYp8LZ38cFRMfrgjzHXPqwtNVDyyBm4NtRUODoZ5oM60yyxr+v4CaHvBg9LE4Jn0D8jhUhLCCZJFgT+A+4Byx1w8NYosTCyYixDTxhZ3yjJGKeuGGO2cwAsjRj44BrIu5Fj5+ktGZYQQbXB5RmauBXYWuCozNjxpLTuD4QEkNo1G70dnSsxZJ1a6GTv9RrY53FrZA4YTNpzKzjiH3ZoX24ENqLcJll+6pM4tLw6MKgaZ7s72OY6FhhGNe9Oi6npvbIswXpix7bOK9trV4Hs0210diEaSAasb4t218mXISC3sdkJ+D6ZEd/f9kNR3fq0CXFz6fU53QOUNT0rKSGeehbdKghi5DgC/5r7U0L09jZgi/1K4MEyWKVAska87q5yHio31JFGQ6rJsSWXOC98Zaz7zDr+2SrLRSOSPZiCGmVAHGk0yYErRnTNxXRC1jSHaTzKIyCqLnurG5upBF51qxuodz7qCOmv655o9jz1WfAeMTUIlEB8Yd5sRp6S+NCB5oexfKlk/FTa7KqN2xOp57Ur1GRUUak36Yczn2GYOPZXKw9fdHkzD8TgbdGK2nAz78tGT1k4g/HENdv2isVcAmZoDZs82AgsetEaUXFc5NezPy
 0oPz3pHs
 Ft1+kr1V5wYLnnOwDsHulBIYqAHnX8w8/2wqdnefIUQ3rQkzyD3WGqKaFksVZK2TyCQzdrrX4S+4b0hC8fX1AZy9gxFRuxXZFFe4k+jUPXZ3u1m2EveceGpsT4F5J/kfE+bpv7ZZhURhgbsY4AnhSOLDKtJdg8XGy0EfpbVnkfkcfmKEqJeNXXGWTY441ZlQ+pxS0/Hu3DEm5DCAGSkQ7Eh0K8esGD49sby67uLisNgvy+e8ftlEpDNScwYUWpNrhoZynrsYZAEHLtqdcaorktKJeKZ+RQTDYwkb/OR+fSPQQKQsycsATt6Ab+jbJmjimQRplsp4rDLGCcSjTayax5ZLl+qfMbUp1fV+hPwgOwL1Das3l6pd79c58/T+LMq/YDJvFIgpq0bVltdY2fFFX+nLo7o+fH618Q4G9EN9hGsTvByYNtwHf7lq0Xcu9sQlcF8xaOl8L8GLkrnX087omNvk7j52fENoWwVhdunTQfQcsRNDVz+KzGPecmqSGsZEnOWCdXuYgV0z4+PRgr11dA+3WUQF10R5nxRlyn805aSqcCDqoOoAeVV92/DEW0C/ArsvD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>I'm confused, don't we have that exact check later in the function?

> Your v1 might have been better, unless I am missing something.

Hi David,

Perhaps you missed this in the v1 feedback:
https://lore.kernel.org/linux-mm/E0C570E7-C4CD-4E41-9590-DDB64757CA2C@nvidia.com/ ?

Best regards,
wang lian

