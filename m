Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42488CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A2778E0009; Thu,  4 Sep 2025 02:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C728E0002; Thu,  4 Sep 2025 02:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742388E0009; Thu,  4 Sep 2025 02:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CFBB8E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:13:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0B7313BCD3
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:13:03 +0000 (UTC)
X-FDA: 83850549846.02.B831845
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id AA5E1140003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:13:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="t/voUSzS";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756966382; a=rsa-sha256;
	cv=none;
	b=IHNe75PpBErgqVjuYdcFxdr+ruJK8tY+gXaflIpERonAkeGWQUSMzIk15xacT5iFY9qlGR
	Mfw1PGbEi8qtuB/a1N6woPIINITeO6VrnhS1NfI7aqfHCsyM5S4sqZ+cMSIFPUbGeCBWHe
	R4yeS6mf5JuK5+aIGlgeolXV3GKBClQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="t/voUSzS";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756966382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sl+7sZlPHAR/h3IM776vMLfUaeHGIeBuokgV+a09Z8I=;
	b=ZNNC0nL5xNXQXOxcoVcKaBld6/Jy+9uhxwZrPClTUCVuKzDchR+mYAYN3BM4FaLgh/1dSR
	ypBmTOOQ6YaH/Igs6nOQF06hJr2q4zmgU+XHjjiHCw/XYLcOL+mtUOLXdGpiS3HZ/d32aX
	VBNTMjfusX1Op7OCrZyAdx7MFu+n1Ck=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756966379; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=sl+7sZlPHAR/h3IM776vMLfUaeHGIeBuokgV+a09Z8I=;
	b=t/voUSzS6y1GV4BwqlZ9czLyQTrOI6vvtZGGECwuI2md6Hcbyg77rWdA5M39IFkoouszcwvwSIUPF7dSslhtwGp/aj6j2V6FsadilFNIOzkzb5B7XZb7zvcqW2DIUSOAfrOU4DftzEac9NdquFageM2Hai7UHU9Ni/Y6vhIo3gQ=
Received: from 30.74.144.113(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnEblbM_1756966376 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 04 Sep 2025 14:12:57 +0800
Message-ID: <28381bf8-f278-4b4e-b7eb-b3525e98f050@linux.alibaba.com>
Date: Thu, 4 Sep 2025 14:12:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: Drop all references of writable and SCAN_PAGE_RO
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@redhat.com,
 kas@kernel.org, willy@infradead.org, hughd@google.com
Cc: ziy@nvidia.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250903054635.19949-1-dev.jain@arm.com>
 <20250903054635.19949-2-dev.jain@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250903054635.19949-2-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: AA5E1140003
X-Stat-Signature: 5fi3sk6jewmyxmzgy38ndn9ncnxtxjrm
X-HE-Tag: 1756966381-176013
X-HE-Meta: U2FsdGVkX18zwEyae2uYtnxVOVfxUsJeeuOvvL/eoM/Wgnm19fIZIPULXiqhixeE7nNOn07esLqUh1I94/xi0PgNp6wzajQOfDdB1kL3qmaYa4z61haw4873UXLtoHmApRRslH3xX605cUFgBj7EPpSIpJG7AnZdHdqZgmPT5yD/KO/WhBbYmSN2sIQAQ+NTCbCi0d7E56LKW5yBfUllMcjscMMVhDs4kODALOuAv3A6PeZ+ZHMESZ8iD0V8OaEcoa+njwzPFqClAdQzUg0D2SMO1OyWlGwluV20XHFM/I0aOrxDLuVIoKuLoP9cbdLBELDurRjl8O3DOlONO3czX22ep9hz5AJW3AmsvfOWgFqBLRUHh9EB6B9PkzaFEnIQCMOsi90mFRoGjuHSnpY2Ww0Vvt3BBKvdHXwvD36jpnYo+n+XpckCdq+lqSfmh51Yt/hSap19mCoNOKW8rnJexnuexx1VZLA2aVQiQL+vO/FrFapDlk66lPkMNGGkXeED3J1pyHGU+VBexm0g/8lsTPvHX0yZk1gxhk7MucIXFWzoCCKYaGSKo64u+Z87bSqSV2B1vFvgfi8BsfvnRpu1mrTNXlM/L5cpGbyqKuX+ESAk7gE9WDLnfUe/oqU9iZLVU1SqGvzJi9k2/rwLx8eFNTRx+E7IjdY8oNcWxhr0nNHXmTfR8f0Kou2W7zB6BVQ+sBmEdI2ViZ3tytCaAAk8fjkJAKdEVmsePUWiizl6Iwg61sN6PHRqYW9tKmGCRJbBnWj2JEb84BaaFd4dKDA8Dsm4PWkCOurGudM/VBou+RkwoGdwTBRM/0pFGipKNv3uTVlP75z0M+l5qGJIEU4WqFbuUEJzNGZClhBo2XvJIqL99ubBMnjl69K8ffg1LPVfwEKEjJB4a5kFGFk0LZAMAyk7TspRpHU41CP8JnSAZOh5nV9thkeXMdo67IURAx0V32jbBb1PUY2zIhlfAnD
 oHrJIErt
 +kKjS8SIMD0F8EbTSS7G6fag3ujtyDbu8VO+PkDC7EPNpJszH0radrZlnQVOVYPRYLmZGrDRBbLZpysGIzgwaMFrbm4S7bdzAeHDZpkyAScll7JsYaqw0b+kHx8JLf0b72ZEhRfr1w3D2sKGIfebZ73kL51MRXY3v4/O8fjDEMmPRKdO5CL219remlNIyZIuN2vf5Em7GShMq6lnCJblSZ4Vekx2hc15IyHwebuNp5vVP1DbP3kA/XUry9L29XHRlZ60MlFubFsXvkr/TTlXdGAb6prRH5Tu02I7e28IByzkXVAWM8VBQLDV6ryUajhHX49JT6K1y17kGKLqk+0eFWt0gpzLxCG4k4n6zuwzRn7JlvAgHQIROIQFHKfRivY23D4EPT+RDs31iCu6PSPixHYtJ8ULUOabnP4O+ZcvZZYb1+kN0cQFmNijQAmD221mhggJyEOV138Ruft8E4m+6sC1bvBHI72SCyDV7/AQXJO39//UfWmDtvmMmxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/3 13:46, Dev Jain wrote:
> Now that all actionable outcomes from checking pte_write() are gone,
> drop the related references.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

