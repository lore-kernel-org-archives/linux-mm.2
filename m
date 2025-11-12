Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF225CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 03:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8A068E0003; Tue, 11 Nov 2025 22:33:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D619E8E0002; Tue, 11 Nov 2025 22:33:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9DF38E0003; Tue, 11 Nov 2025 22:33:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA0D68E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 22:33:42 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CB281602DF
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 03:33:42 +0000 (UTC)
X-FDA: 84100535484.28.25F14D1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 37B3A4000E
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 03:33:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762918420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CJlA3LgO9hUm5R5dWin2fROL9hNtO7I3rnT2TCZbq2Y=;
	b=L7tTT/XJ0jkoAOTdnlfCiQt3cyBAF2SY6LNar9C4LTnhNO2zxJODE9sDeroPWQbRrppYpA
	+wxtYqsfCQ/j4nb+D+DFEivnbYOVL23/fLr7UzaEPplNALcucKZvV45fVvPXZZJny/yoaC
	smb7HULt9wEq9vBxOJZJfIOkUeLiZcI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762918420; a=rsa-sha256;
	cv=none;
	b=J94hBdkjj/vKr9L7HeAms6Nqr2BiayR5BL3v9jyKa3Za73NSGWMpCS+IatGun6B8ws9uGT
	prBKOzKQx7socUwcl1P+jgnegRjRSJRwhzJ/28nGutK3fHevvvFpv7Dl/GBFDJU14nwbSB
	++tiMXyS+OFt8LvXueo2cbLEAin8Xa4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D0501515;
	Tue, 11 Nov 2025 19:33:31 -0800 (PST)
Received: from [10.164.136.35] (unknown [10.164.136.35])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98AE63F63F;
	Tue, 11 Nov 2025 19:33:35 -0800 (PST)
Message-ID: <656cbdbf-7ebd-4a9e-95d6-bf251f1e45a0@arm.com>
Date: Wed, 12 Nov 2025 09:03:32 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: continue to collapse on SCAN_PMD_NONE
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251112020031.25350-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251112020031.25350-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 37B3A4000E
X-Stat-Signature: 8fuppsxf1eob4qrwyfz78m9wnd5odnmr
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762918420-520909
X-HE-Meta: U2FsdGVkX1+cDSwkKjyYUcuG32iQpOIwFcUZjnG+9TpfZXUPy+plX/fbhqJpSRC3CIHcyilP9StuK0Pr3YYbB5WNKhJf7YeNZFa/fdLsiEAm5pFKtM4g1nKAEjoiZU+MbMMBVUEgGDoJxlBmBBO/V/jGVoMxGKITsz60ReE5HaWJ+mscxPDfEA/7kSdMAmCHsvxqiR/KpesApDtYoFzU8mSu5anPDR8mJ1Gpo6gtL49Y+2kNX7c8c5Ebpzi2RsYU2D5WKWVpd+fYurMsoIrrZIBWaAQK3xOkbha/DctR/PEcWIBsKjgoUorWzgy9ZpO+kWWpqz33ikpsT5ACJ7sQ5frkBTOuLzEnmbhwDHZkkATspTzyTOE8iP7ofPZ0kjCgkuh6bAu4WODCECdPlGfIo69awWzkfqT9v48cfg2vtbgIJW/YyV5SZqCddek5KVKrZ9rm5RvvUXmiL3xBvI0O83rEKsHzaCc3a5tR9NhaACOWlxIe5hwyZODZwq3gmXcgnVztpteO/ktkLcvtOEK1KxKrIGm5byqONFC7EAVrjUVPQsRJIRcrD7HOu6Zt33EMWxMspv5E7FHQxfR9fmunHKxogJHgrNobpgv2DkP+nRARicUC7aLl1XGPwzhlt6BFAYCvmRQ3uL0tKHgkGqcCyDsLX0NBFBq0eg/3M/00UNSwqK2ziR3LOk3zZlnanAIFlqLKXKEK+wiLiDGkXcksBFv+/1+X+ch41xUD8k26kP7kWV2i0dN38ArJdVrafc9CtPSBDAnxTLimVqILfIwCHEX0/AdCdDtsChaH60hQGpKmZqyKPts2chT8goU6k2B7UJDnlJPFsw1rl/Y8mo3y3ArlLb6ApvAFlclMs+HWh7dyxr59PCPCbFhTvbKumyix3QcbV8o1gls7SRMdTsRn0MfB0cx8P6bpNIDlnnptGkqPsUe1IGIfAV0TwAApOQ8DMBghR+qZqRk+gtwzMDD
 Q6kxBhRS
 WDYtJjCbSFPKUJ6PjAmIjR+vGQK+YjxDIMYyTXeLJ9FJkvzj8HoTovY1qbZ+Ia7+9eeWxiS8D5xcftuRUfdKensP4/0AjU4AaiBoBKTikkvMcLSuNEIG35OkSh349FkNwoxB7woHrMCG7OsK5IskEZmPtdLF2whnINPlx84q0mJXY7h4wSXSvLBgelhdEv42tnkhDLsD/3hCGIH5iIoj00rEZDJ34+MXuDfAVX0gtEjNL0K7XB+oDwb+aQcG2Zja/dvgczb1oxhJDg9cGLQ/bEhh8UL56p9fmVnPuKhC3pItFfifhURGLx9JcyWyaX3Pk2/FpUkN2wbhPuwrk87va0MZLLVJXDKjgVjtg5tYQ/sVrnrsP5mPY5LScrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/11/25 7:30 am, Wei Yang wrote:
> SCAN_PMD_NONE means current pmd is empty, but we can still continue
> collapse next pmd range.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>   

LGTM

Reviewed-by: Dev Jain <dev.jain@arm.com>


