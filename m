Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0071CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 070BE8E0008; Fri, 29 Aug 2025 11:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021868E0001; Fri, 29 Aug 2025 11:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78CE8E0008; Fri, 29 Aug 2025 11:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D48058E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:29:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 833DF1A0726
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:29:21 +0000 (UTC)
X-FDA: 83830178922.05.8C353CD
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id A8BC4A000D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:29:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MJiR83zr;
	spf=pass (imf15.hostedemail.com: domain of ujwal.kundur@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ujwal.kundur@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756481359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlfJx14k7QlMvuUJz30QqkKUEpNc1n24HaeGoHG6X0s=;
	b=UXPvMDOPpOGEe62diytKtqIRozWfMcYMvBvSymIdW2DFtVUuI3Tpd5n80imcKMKJBuI9QC
	CwJdB9JSdPNaP7U7tmFCGRAtKS3HJTs4K6QwXcNUIiRchp33aDviozFVnk7RGEdMZgAdX9
	LO8EuqZq4IVV2AsftNmqI0P/KU/UbR8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MJiR83zr;
	spf=pass (imf15.hostedemail.com: domain of ujwal.kundur@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ujwal.kundur@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756481359; a=rsa-sha256;
	cv=none;
	b=lE9obKqT5vMaw6tFyAUPoOTEANHxt82h4Nbcke/31CTGpH1UpqLCxsdijpC0BKwj84WLjf
	teiNwzXJxLH4K+L42HrH9gb3Cdka40IC+/A34dIPE9c3IHMukXVhTVg2dI7HuPHdezqveg
	4sN99r7Hx/JB8F6Yy5ogDXcl7mRF7HQ=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6188b72b7caso2315972a12.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756481358; x=1757086158; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KlfJx14k7QlMvuUJz30QqkKUEpNc1n24HaeGoHG6X0s=;
        b=MJiR83zry6dSpaEbms3t13X31VMenTVDbXcTCNXLby9ExHKN/wSxn4v7nv3e6khxkS
         iHrNofXjvgZ6YRF68YeTu3b1+oq53zqaVjbqdeYdDo16MU1Glgdu0D98AjhC++NAvCkM
         U0Oi76T+BXybrOb0xbv0M7xkkjLptmAGvAInzbM89Veoo71VeI4I4QWcLjoj+wpFSdfx
         bPwp9UMPwT+0E9nKG5BNkU51nVZbqafEm5PkGc7ryxNNjD9I0RcW1Ct5RDCoWh0TS74z
         asd2wsKAOsKi+bm8eICMKrm9D1Ej0U3xAtYjVSyxzhYndu91tMqkuzFCOFWW0BIpfI57
         4gHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756481358; x=1757086158;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KlfJx14k7QlMvuUJz30QqkKUEpNc1n24HaeGoHG6X0s=;
        b=N3fzu4ugdPXvxVDzB+NlybG9re8+VP0Jbxx+hhiOyDylyb1094Zact/LRsdPExIbjd
         5Nd6SnOtobts8crSlhvz9r3BSKsxNLoXj+2bAhiAF5ltX0PQgV+6QEuDvjrunzPemi0N
         sEztf4c1cF4jXbMn6C/lVwIEfHogZsqkdhnE6tBR63JfUvPHfn8IRR/+t3tI8L8Pl/rb
         1BJpQJJnvBaRlwlyhQqpR8Au/QwKL7Yo2IXhEyKlR6+aEe52XH0AqlAboU5jyxQWwltr
         aXIMa3veJo1t1pwa/R4QwAn7zA88OBtUeQIkCVDZc/oyKtiXHrO4aYRUaqpHAvV+GgRa
         fHbg==
X-Forwarded-Encrypted: i=1; AJvYcCVDqpiJ1ZLRnNQ7/+bL2ejFynv6fTvc8tUQ8W4fRmLaRFjAsRFs60r4Jy8cDzTy1aqPqIPnF+4Npw==@kvack.org
X-Gm-Message-State: AOJu0Yy8lGy1n0e4GnaUtgMQ/unjjIpdKMzvq8pumHnvlZ8nWzkqznaG
	CRDwYiE/et36HfzDbtpwdNoV5U7NnrkqCLsEJMImwqutYI+gsKNItXUzImMoGb9P8ZkcPIvXFfQ
	7jWWthTCGG/qJksykGaB0QrbVIUzJzQ==
X-Gm-Gg: ASbGncs0/iW8XDqBfilHlyaUXblZ19GfjMcLXX2K14Pzan0ADwJjJOLTbubKIiQ7rm5
	abZG0KgsYDW5IL8yl1nW250PqAfupmMFTPKd0hT+Z4ZUGzeaDAvrm+6O9PQPTBJ6elOlO6fieLf
	CHirkh0p53THJoFDjyfSjquHivxfzrTgBHIvGO/M/DEqxLx19Xt+MVJ0qmDRwaWKIqFePXpMyS/
	mlK7JU325p4TQ3sBsA=
X-Google-Smtp-Source: AGHT+IHlHjhamRkb1CeBLH5wF8zysbU6WBxW0Ef3Z7tCNHy6zj5SYyx/5kZg7x6UB1gpfXZ3/DkrY2NuRSk1nOt3ZKY=
X-Received: by 2002:a05:6402:5208:b0:61c:9193:a4c with SMTP id
 4fb4d7f45d1cf-61c91931336mr10638815a12.1.1756481357704; Fri, 29 Aug 2025
 08:29:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250817065211.855-1-ujwal.kundur@gmail.com> <DCE2EJ3KWX3K.1Y198FHBV8UG7@google.com>
 <kd6uteyd4vzlnbdwzjydwd7hoqyxewc5fx24z5sq7svmtoa3oo@n57xyeu3vtyy>
 <20250828155412.2b1b2095125428af24896af5@linux-foundation.org> <DCERAA0PTPE2.1Y0KLQS6IO5O9@google.com>
In-Reply-To: <DCERAA0PTPE2.1Y0KLQS6IO5O9@google.com>
From: Ujwal Kundur <ujwal.kundur@gmail.com>
Date: Fri, 29 Aug 2025 20:59:05 +0530
X-Gm-Features: Ac12FXzVrwOupCSurf3cQGAZfJ2_KlEiScP3MFCFXTGKsdhk4k2-7zwHh-WJdT0
Message-ID: <CALkFLLJW+rt7Wefb_GXNHNT_Wos--qusNP3fbH9CQN5WqfD5dw@mail.gmail.com>
Subject: Re: [PATCH v7 1/1] selftests/mm/uffd: Refactor non-composite global
 vars into struct
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	peterx@redhat.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A8BC4A000D
X-Rspam-User: 
X-Stat-Signature: qq33pf9t9u7qdy5di1aqzus8rbtychhe
X-Rspamd-Server: rspam09
X-HE-Tag: 1756481359-870902
X-HE-Meta: U2FsdGVkX1+AkkkXi5GvJyg2E+YtpUx7bWJRnBUmasNSQUkRnokMnv2o69+wMQieCkoB/MhplrTnVSKDnZzjM/yE4S2a1CIMHwMwPRnSY6MUmK7TzglUrBJiQJXXrCSqILLZXlfKOGekmi1WlHhW2CGf+PxlJOHaoMjWs//+OOOywc49cR34pwt3RIcTfWTEYVe8FL1GCWJBib6B/MCxMGHkrhIbzCZtxlKm+5uUhXiTqw1RmbpCpNmjdbkxcKJCPxXYhdKlnQP71bAKS0dnvtiyukUbNT63SGsF9TawS/xiAW+YheUB5KojUNJ/FRxNeJv33VUQtNmfJLYvCdOzDc7yVtweayIvMPJ5gzRqkQ6FgM0wIMdTxqwFOCzWu8kNAGdSpECLkRKQrnxJkLVFUjqPjGmzk1Fke1p1lJW/Uh9djpj8qcbE222vvPcRu96EbenHq7t4vS1eU/m3Qjit6AmPFSiIlftkAbC3Xim1bvNmkjltAWnvT2vXCCGatUt3jPTiZmj48h4+eueePtawL29bOjqnXQRy3M1bOEdjWf87wnUsjZTc8c0yVFgr69GPSOzDpjyLgxVjDloqUNUcWQTyaSfPYTiGoCpfI46c5NjlUH8Ar7lz8lnuPw3rsz3oe7lazLbCFSuWmdRPF3SD4QjOaDKEjan+88TIccxevu6BS2qaHHgYuAkjTQx5Ffcwu4byDYctALQWbdmqKDa98D96dxeA3Z0Kc8sjVr8Wnx/aSZSk+t5FrlRUI+3CoUZgoylLdTiKsvZ4D1+7BURdkL0wVYGRKNIbL4sMy+ukd+WHnv7m8NGjSiY8c9ccf+8JIXC3T06XMqPHcMhm1PZ+mQPffSDP2G9Gt98Kq1x0JQ2eUYgdpPrPTm0yxKFBfzCB/s+BLwBhPVFc3TYzH2vouCARMtO52VpVQnX5N1weL9Uj1j/XDTt4VMZIlypdQxhk/B1rt7bbUBz90ri+tep
 OWADqPrQ
 3WAcjiMx9HQ0b0YtT3Svf7BqiCt2f70xJDNh5z94FjqlACtZ3raQbmR+2XLXwJ7rnx9YWP3WYCfM9wqeW8dzkWgiaLhk4CSquVkJkr/Xj+7jq8l+21wmADBfzcqQqC0J2SOFJjhCBHPOtpejei9wSRj2+q4ENDY8fggKmvLwcjLfSfSOfOoQtGQdQYJRH4oZFEEoFs25ZG4sX2r5ANwiRF7daGWcPO4i7qLYFjcGgDUuYs9UggsXYA5UkJ51uTL/MYn58Poc/ammMkEggVx7H8mtdxrSsvh0/2K8A1MQASNwTzigwuyw/Gk2wpTwC3Bozakmz7g/USzkM5b211PxRuRkxCvI754rTGjRGtwhJW+nCxn+U5gAI5g5HG+Fxlls/76T+efqiUfWUqx4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I see v6 (which did not rebase over the "unused" params) no longer
applies after e29ae64d65353472d4bdb965f256dae9181aba44 was added to
mm-new.
Will send out a v8 rebasing over mm-new's tip. Should be no functional
difference, therefore I'll carry-forward the Acked-by and Reviewed-by
tags, please let me know if that is not desirable.

Thanks,
Ujwal

