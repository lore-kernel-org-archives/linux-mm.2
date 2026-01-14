Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4AF8D31A0F
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 05:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384A76B0089; Wed, 14 Jan 2026 00:25:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35EBA6B008C; Wed, 14 Jan 2026 00:25:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B946B0092; Wed, 14 Jan 2026 00:25:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 161D86B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:25:49 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1EBA14038D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:25:48 +0000 (UTC)
X-FDA: 84329432376.17.92BEA1F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id CC6CA1C0007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:25:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768368346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OGlyYUgVaB1W0/kFNT3vjDdvP8F6UKqrq6cvtNfqGuA=;
	b=qhnhORBuXAlNOF/5EIMNGPc2FuWyyCaaR9ps2S5x1Rey4XlMWfJME9skjEJwJGwBzK03uf
	6nItvfuEoeapfqtNLv6nl7xjlUYPV1OJnST2wd2Mh+oK0JOCtpM30VjKmsGViSIzFzJaBz
	uwicBMhZsqln7QZWZ9fMiG+RH72kV9k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768368346; a=rsa-sha256;
	cv=none;
	b=kf7rP4SuTrS9EScy7haKM5wJ76QbQ5SXmbB/tcoVRzZRxRRk/GNmHxqKOqD++Spoo1X6n4
	ixWiWkuSFeIPx3Uu93kWfBonAeylirXLw22DSSIriRgXLGs1oVEBzr14xoR4pEDfUMsg+R
	6oYqrPpcSvuG2T6hatIvcCtU7Vc6hXc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 345FA497;
	Tue, 13 Jan 2026 21:25:39 -0800 (PST)
Received: from [10.163.161.65] (unknown [10.163.161.65])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 323C33F694;
	Tue, 13 Jan 2026 21:25:43 -0800 (PST)
Message-ID: <0e57c78a-d3e5-44bf-9930-8842e4f791b5@arm.com>
Date: Wed, 14 Jan 2026 10:55:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: numa,memblock: include <asm/numa.h> for
 'numa_nodes_parsed'
To: Ben Dooks <ben.dooks@codethink.co.uk>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.or, linux-mm@kvack.org
Cc: rppt@kernel.org
References: <20260108101539.229192-1-ben.dooks@codethink.co.uk>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260108101539.229192-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1frh1sukx8urqxmh8e9maxpfzicey1no
X-Rspamd-Queue-Id: CC6CA1C0007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768368346-166211
X-HE-Meta: U2FsdGVkX194KfV81B6n+FJ9QyHNUdwME6arm34f5HkwR9X9GgUFQHAxMvOP+U/NyVI77hT7Zwfr8JOxXyauvOwNp49N2B5JVIJGOVB31vVwCpto41aNSCqYt6UMxi5fgcqGyqgH8CCh6fVfj64AuL7QfHWGFnR+FCMaGkBCAteIoF63zQtIZR/4gkLVcPZ1IAXI2fQsUHEmXR3H0jCQHGNw7k1RJtWcpXAXoOMBhVBBB7TbkWL+3Jlv4krnf7nVJ03XiXJdlyubgkqTQNQd+Z6jpjzfECKyl8AoeZh+E/t1nIPA3sHHt7OcvSlfx14T6HpY3Rrm/ZyWOEHE87JlicbDYZIX0AcOzTiTTyiKB3+xre5rsdFh44DFKMMcMCBw9ELJBzxQxTsA+XTQhsWojdOP2ckoMNpIM7p6MMchVVjI+fRbW186LlhOmgPZJuIgD4D2PIhD0i/AvahXRu74lEkX4E9GEl+rFs6VG7k6yI6iXA0NEXYLbWVUf902dF+7+/+cj2LxYUUUzFG4V/8g9n/SxeGd72vpzRpG0HYa6bILJgoqXS6zXir4k1fT2trRlmtgQAl6p55k78/9fOxViN7ysivjr8BQohaIZCD0/VDDLo+eYwPbZ1/3MfJ/74c18tEVLmvXORYms7wE9J3pFhj39QN4YNvFh40PuxXZoFXLWOF1OuNS2TZlQ5jF9ZJ48gi5rgEa9DItqxVoJ50OtgGEl9r97o33+p5wcej9G3FibK6yxKHKb7NiNFAXzSEsMgDBtxXGCMgOsWkNlKChiCCNHHTFI3X0CcuXdRshcfPPAeT5vorca/NMRIKGQQOII0vRsjy1DcnteTxzsJXkK9WNkTOSH86ce+a2vki42knO0UgzGlCc/K0buOY5650q9Vpgq+PhmWg8xiF/U+kmWH6vDG0DvZvspC1o5Ea6DgSw8NEg08wRv+TbjrNH0LItalSCzZrjv++eDHgmyMr
 VZOaebIW
 eiB/t8oRmNrvp/xW9ccD65fXAFvMFOnalyTwz+rrG1jCdyum67z+4VQr0U6l1OfkKtpY0HuMRwvbHRzsFWHw7mdCZS/oL9i+nk9SSuJoTNHVpENOjNrijq4+L5UIxdysbs5Wwt71Po75KVrsJtBsjXD1o4Ofp3j5/AOnpUv/02IAeM/sQ5esQtK65ffN5fZWnlWReiz9SHb5+N/lgGXKFpaZ1+yOg3CezUQh4pnJdIYKF1mV0pwIOc+Fy2c5YqdlMPGzdlSWEk+Bnl0vkp4TcuXnqKRtUyKbpH+NcaCcps5gASGXmXZajKwfLPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/01/26 3:45 PM, Ben Dooks wrote:
> The 'numa_nodes_parsed' is defined in <asm/numa.h> but this file
> is not included in mm/numa_memblks.c (build x86_64) so add this
> to the incldues to fix the following sparse warning:
> 
> mm/numa_memblks.c:13:12: warning: symbol 'numa_nodes_parsed' was not declared. Should it be static?
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  mm/numa_memblks.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> index 5b009a9cd8b4..8f5735fda0a2 100644
> --- a/mm/numa_memblks.c
> +++ b/mm/numa_memblks.c
> @@ -7,6 +7,8 @@
>  #include <linux/numa.h>
>  #include <linux/numa_memblks.h>
>  
> +#include <asm/numa.h>
> +
>  int numa_distance_cnt;
>  static u8 *numa_distance;
>  

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

