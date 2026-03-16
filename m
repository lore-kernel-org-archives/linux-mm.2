Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 759D4F506D6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFC436B029D; Mon, 16 Mar 2026 10:02:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD266B029E; Mon, 16 Mar 2026 10:02:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBFB96B029F; Mon, 16 Mar 2026 10:02:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB89C6B029D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:02:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 84D5086984
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:02:01 +0000 (UTC)
X-FDA: 84552090042.22.AA0E345
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6DEB62000F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:01:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LUUTdvOA;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.210.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773669719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MtZYwSZiRvxHQC40LhvHohiVgnWOPcD9n8S8sVX1biU=;
	b=6oEXj+rxmi2AVg3BGikJnaGls57T8ChsUAtAbROmlYuuJpQLEwXmGfx6h7Hjno15Vu9PAW
	jK6QgBaCXulPhdh2zOIUdGLwFLraoM/G7Hr+EiLc/qwgZEd7iRuTLquQMSCTrVNoLqlQYX
	+OtSzzEgGgczejwulBJxzHjzFbjWHRo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LUUTdvOA;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.210.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773669719; a=rsa-sha256;
	cv=none;
	b=YvEERsP91M/GjpoYWe1q5XI8k6TQr8s0921/FY3PZLJ4fwhRfxSz80adgbGzmX4MiyzvGz
	7+99zmZunfga0KbRT8xOVIdFY1NVdei1zYmPW+M84s3GrbEj1mmXeNM0Rx7eXvNiQntlcr
	15/MWDU2hFXyqiMMrNlP6tpxhV5wvDA=
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7d750eeaec3so1576109a34.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1773669718; x=1774274518; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MtZYwSZiRvxHQC40LhvHohiVgnWOPcD9n8S8sVX1biU=;
        b=LUUTdvOAfvPjsPQ6cEOJrrv3BljTzn5WRugrtH9Gej0urWAl65RqzeeFD62UfB5nSC
         u8Nw2sztzEp4MfXdPBv8Qzslhs3ih/9tiwDQC6v3crV9eAV7FgQGhmLwtCCP5RQHHoQP
         /jU73njBs513EsLm9G62of/mCI5SgOzZ8oH6aWf2XsiBhIPTeRHAnM2MH/kLEnneYNUM
         SOko3NUp/T3iZM9L82JLcRy2fhk9GAp5fHGTWulwko9IyiKWxmgsaxbuStuNWbZDaYgL
         oMZz2GygCmDfzaKDEwBdkKRWFfwbRL6trjcfU9vdKjvYTfsnDeT7FBD7g3pd2AFnbpp1
         G4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773669718; x=1774274518;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MtZYwSZiRvxHQC40LhvHohiVgnWOPcD9n8S8sVX1biU=;
        b=W/Qkv8YF5ZWMjoGyI2+rStwzEYzSNQF7ZdKo10Vw1DVg2twJrZfmN27VOmEhOkOYGT
         F1OIWUWjX/50uV1/qhDH2HEda92SbMauV7ZzOKcG2RXenWYrtMm2fP9pMik0d1IBYOi+
         VZjY4s7gBH/ycKcH5z/CD53BhDp8tLS0XNE0QllePTe1Bgrz1jtAq+L2wvhIvlaE6tHs
         vLm53MlfedH+kxw18eaWaJYcMG17mfmpMtOoRuqFovqs0CydP4vhjyKIdrXPuFPpO+HA
         csKe3wWpiVL60vf43rFTsj4LJgjxyY+7+LjbB3vs4ynuwVydFn4vcEiZ0XcWu2GMoo8B
         hYhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcoMIHfZ0W3Ls+hulvdptVhx9nW5dkGhcwBPGm27C1a8Jh8b+xpiGoI05bWCysEFxNYTnZNyAXjg==@kvack.org
X-Gm-Message-State: AOJu0YwseU/miKhp3dlRQBXYg1LP4cybAqrUVm0JtR73ytTVEbthXH76
	1G8kugqBA/TNo8M0qK4oeJtk2mjqPhI0FhFgf+25qoFd7nkMwOt8Lp+utTgcUHC6Bpk=
X-Gm-Gg: ATEYQzxeLWr0a72A5Z9Lz+4sERMqKCD/UturH4JwMe9NCas/dizkeySBgJs9kqpeo0Y
	h6uprRcz+L9uwV0fPGXMbZ0tVl3B/3wvppWlDy4a4nND1TUyGFwNEjEW461SdcOoWy5Bc6zlYCz
	MRRc2OHpoNBlDRQZ0LwrFl8Rcu6qeAQTPbQ2jbdBhJtUVq3FzL2UMZLPePKPJ63DXtzy62R08p3
	7zW7Q2qeZcJE1uGTzdwPDZSS+AAmPdjUWUsrMpHCcEicOzTnhOBy+Mi7wUJnGgMOIzBcPfkwCQk
	Q2Vs6V8f3jUACLNBHw14WrNHriHajXTZiDYmgj7i6WThY/e8wyfC0nX8dTNNxr+PCrxto/JNjyM
	ttYcoU8AyZTIYoUXUxsyJCVQ4eUaXGM6OCmXW57j0izP/W9AWGGRmwrkuLQz5TzjEfb1UcX+WJe
	Y8QQs6/seW8QQBVUSOQWno+J1w4jB8UcNq9R+S4chskyBRUN5ZiUIB6nI2HAodxs62/c1f+14bb
	OVC706ucQ==
X-Received: by 2002:a05:6830:6503:b0:7d7:4b65:e8d2 with SMTP id 46e09a7af769-7d78243bcc4mr8723153a34.1.1773669712512;
        Mon, 16 Mar 2026 07:01:52 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65beeb7dsm134438116d6.19.2026.03.16.07.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 07:01:50 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:01:48 -0400
From: Gregory Price <gourry@gourry.net>
To: Rakie Kim <rakie.kim@sk.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com,
	kernel_team@skhynix.com, honggyu.kim@sk.com, yunjeong.mun@sk.com
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce
 socket-aware weighted interleave
Message-ID: <abgNTMDM5xhRsWFU@gourry-fedora-PF4VCD3F>
References: <20260316051258.246-1-rakie.kim@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316051258.246-1-rakie.kim@sk.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6DEB62000F
X-Stat-Signature: wex7r81435uabd6cpntkehe35yyg8hdm
X-Rspam-User: 
X-HE-Tag: 1773669719-37770
X-HE-Meta: U2FsdGVkX18lQ3FQ9NuCH60LtEBMoxR2GntVTEDZxd0OtxJ9vQqWzIXByrUX8oNX+e9halESvvb7lMd8UaNrFrdj/ZvRFNwNRUbAVXkTJ6O41KDlQaDJs25DDuMznF1I9I1xo1afHcDWaDYogvDMsWCiEJN3rnxtzXoWsP/opaKrM2Yvw31EUxlkSHwoiwTw9Qy2vnNGnXUs6zhZFhbnlmucqP70ezW8CYhhW2GKTd6m3+seDJMmlbL2q3mRD5c0WnRG5m6vIT9CYiOFURm/fEmamAYsZanDbiu+voKPSqDsRXF7FpEkE7QA95/G+q/qIqz20TWIKiVy4xD1TapenJACTo2a+9WN535CJbBhfUjNDayPmShGGR4zvRb46T/s5SAywXIRFGQ0DSgcoa4uViiR2aefw+/06SA+IXQY+eiRxEf8GSTPXfbaOfgJto/ecVkRjMv1qlOIlae0sX+RlwFrtskdAtoCj2GSd50ShGgZ77vB8FSUSrqidIUIDtP8cp8bw4WKJts1Ri9vHE/Lk9Z+9mPoJS7VBrTOS5bX+9+OAiEsKLUX8AhgFG3aZqCyl14/pFDZIAkC+sz+r3bthK5R6WwQ5ifXMWWfqyD5WrtHs9kmBQgsoD2N8vHXkkWxuqRpegUPwHJPrI7MiMRlnsKgTOXgsEXePNLjf7wAr/vZItDK5bvUmA6j/IFq6GMSY6wqYREGA2nwjMwM2g37no4C/Qb/IIGlsaMq0yKOMr8UkHxdYgpE60ULE/5Dmb6TCmA+O/detD4Db+mxtcDgXh0oEKjz+gM1JEp1hN2DACjfNbMgDNSWRJ3va+5cTxE19jp5IWq04LKV1VKcij/s4mZFDiwEhLEkGqEm+SWdFsFZ16XUxttQa6yTNXHtAVgTherMGvoAvFBGrKu5cwG/K1R/L/KQxlg8lYW9+TC4/8q91IzsOeXUiGmHNDmkQzQSR10Tae1tkAbGJGjO8Tx
 EqQhVYxQ
 NRSe6vRf4vMDJdYsr/09cn5FTcOuZ4iDXzfrnuSGh3b9sTORGk3Uq3OZD8WynLmtUV4G7nV8bkTh64KZVSWg36v+DNCZP/Dxwfe9Tt47h/6Pn2VIRue96ctGTVTiYW7LngII1qkSRbUiwP5boMZG/+GYA2KypePEO0LL7poEXqD4lGt/xjMD1MDW456OpxfaQiMM9G7yOlugxodmA3r5tukBk2KHhTisqB+o1dm65rQDBjU2C4YpxeJBIr2whQ+w7U2Jt6MDi/ENYy9yDCid9+QNf3uLcwJjTCfPMCJEoGRhvFLNLTva68k6934aEsA2oqbno368aPjfyE/iy441XrGpNUfK75WUYxL1Xb+4E/Bo9+Hk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 02:12:48PM +0900, Rakie Kim wrote:
> This patch series is an RFC to propose and discuss the overall design
> and concept of a socket-aware weighted interleave mechanism. As there
> are areas requiring further refinement, the primary goal at this stage
> is to gather feedback on the architectural approach rather than focusing
> on fine-grained implementation details.
> 

I gave this a brief browse this morning, and I rather like this
approach, more-so than the original proposals for socket-awareness
that encoded the weights in a 2-dimensional array.

I think this would be a great discussion at LSF, and I wonder if
something like memory-package could be used for more purposes than just
weighted interleave.

~Gregory

