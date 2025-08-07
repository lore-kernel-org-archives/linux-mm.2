Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97056C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 09:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5858E0006; Thu,  7 Aug 2025 05:27:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E669D8E0002; Thu,  7 Aug 2025 05:27:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7D348E0006; Thu,  7 Aug 2025 05:27:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C14468E0002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:27:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 667AB136AF6
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 09:27:07 +0000 (UTC)
X-FDA: 83749432494.08.7205F2D
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7E47D40007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 09:27:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="caq/Xb1V";
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754558825; a=rsa-sha256;
	cv=none;
	b=vdy5/Q5NW5XygRaUkJO4PCSgvD1bqu1y1WbaYU6/hImpTHsnQJFhf8p2ltzkJ3lDwwa9U8
	3RoXFtpo4TzCA+/KW60uw9SwfRoptRhp7KmqTOq8+brk92Kz/ftO2j0omwCfVHG0d21csi
	Sy/sfgdJBZjFlED/krx3J3oVNlOsLhA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="caq/Xb1V";
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754558825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxgz8RoatRrFV2R2BwY+A1zvAnqo3di4K/3GatoR9Eg=;
	b=cK8UJD9GcvwtWm65HpO8KStMnengfXtinW31Ntu8qqJev/CYpxaIm806GueACkKAdWxYPK
	AZz/hS/5nDJeqtjAnK2cGDVzI/zp6RSJ2fZbyYDkNTwalP+pGdoxIEcUDrfYQqgqbDfWZC
	VO41eEUEj5pm8rCvX+/lzz/Bw9VCHbs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754558821; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nxgz8RoatRrFV2R2BwY+A1zvAnqo3di4K/3GatoR9Eg=;
	b=caq/Xb1VZPPoQWD58K1LGgO8Q6eOWhoFdo0hKAhxYIFCs2rR1Oz6K7tBJZLx9sH/g0t4iFCC67tjVqxDsh+VaRAyX/J3PiBmyj9d/VueNbZnUUdo7EoXh0GI+Olfhtip8JMFEcp4lfUGQBEGBzdBU3q3oovo7ZaRBnmnu8E5kmQ=
Received: from 30.74.144.111(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WlDoMn3_1754558819 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 07 Aug 2025 17:26:59 +0800
Message-ID: <face9324-e4c3-45d6-9fa4-a2e8244379df@linux.alibaba.com>
Date: Thu, 7 Aug 2025 17:26:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: do check_huge_anon() with a number been
 passed in
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 dev.jain@arm.com
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250807082707.30647-1-richard.weiyang@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250807082707.30647-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7E47D40007
X-Stat-Signature: snukd45cxqixiti7hnn5a7h5kcojnxam
X-HE-Tag: 1754558824-275949
X-HE-Meta: U2FsdGVkX18xzkdlVuMpBZZrYA0H9vOlXvjfckC7WBqO+/L+9nP96LPqjvPBiHNqM5UrR5K6r/5XMwy5z+UFKI3binbzmAvb/Um/HbsiCN2SO4aIF87pduYifme7CMltGSUgSgg2QqgGdAAoxpzPwywOoxPWNfYtX7kQaQl+JVWZnpKfxwg7aoWAmo+0uAD1Fnr7uW8/3C8elMWj/EMDTrKJoDzPjSw7zxVwfK4vLaZ243gtaqh7FkTXAZpkaAHJGGggh2atI9rQoCxvxcsfehBfEOv5HMY6H+HhzwnVdjx31Lm3bs+Q9HxVIcsINj7bADXZBt4hyRrATkt3g//6zrgUShGX/0v0CSc05OrJ/b9wg2FP0QVKkVE9zFioEPiYqOT+WOCYJBvJHUUTGTLMLbu94yQtEdJ34395iEo1E6sg5zYvCRsRzGMioXEpEqS5r+N9u5lmIoITL/s/RcB++9kJVlL0E2O6T3KvZKwypMXy7tj0QR5kCkIpS7btnTXTve9MLMKGnHcBtZrR80GqLVpq5wCrh+IuaTK/IFj7Lv/ym5heORgcfR6Z9ZIc+8DZPEzStQZFL/GDzXRrsrWRBtrpfk917b0XTo1kWSj5cVGbsmFa0+CrPTkABEqx8MUQg2P5dSTYxQUKyo2yAuoXGWRfa+0PdBcnfAgQ6CLfvlKQHRkiVi1Sy6acCaSt6+rijNbzVvBvPsm0c1Zn+vYEeYiQVNP0CBUj8geHDQ2oe1DNPOJ0/L1D7PYjLjJ2jeSHXFkqH38oW8hy258W199knmO/4ZrrQ4aOvAyn2nRKwa6E8+BNKSYHLuxjJ+kqeC5g3mtiH3Y/johlNRdK1B3ubQV20/b+ithM3tdJwaAyLWjAZBfO1EQ79qe5RMkmvYs/Wbir3wC0dtfUft6SuhhhScihhjIT+LhXTc368ZVUZ+NQeju3ienADL+NL9edOzmFgZGh15ZNnx9n6au+RU+
 7VeycH33
 wlgQOZ5pFy7qZdLEvzXfOUPpqoWtQsaAAEZntuOOAu5DubkKpXV6qVcnJQNIy1RX/H8ahSB6q2WNOnljRIiq8QWU8mjzoTrUYoBC1dKxly9H9P4xor7Ld/EIUyUWOBYrO9Ddn21FAdl2dU7w5r6K+E/axT/FY/z+CtR9VDwo4Bzze67BtJqkRp5+IFs4FdretoUk7yzDqPm6vwKFOo4/Unj8AOKORR6k7d8xUEiqsa34IoMtH85fevEJg97owoSkeIB1tirR26tS8abmbSGx+FfGBgrIqkRuW69qnBix47FkCme9lbf/nZT+ZE2bqs6KLMbxRfPHZt3So/dAK67qnV9I+cT+lxS59hkZsIg8DVs8sYAjoNxFdPUYKGxB6/JUICZb7LDGS+OyXBLe6mCGCrCUYnxK0HgCu8wVSZkKHOArsuMiYUjSAO7vA8qmZGCZ6aCGN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/7 16:27, Wei Yang wrote:
> Currently it hard coded the number of hugepage to check for
> check_huge_anon(), but we already have the number passed in.
> 
> Do the check based on the number of hugepage passed in is more
> reasonable.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---

Yes. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   tools/testing/selftests/mm/split_huge_page_test.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 44a3f8a58806..bf40e6b121ab 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -111,7 +111,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
>   	unsigned long rss_anon_before, rss_anon_after;
>   	size_t i;
>   
> -	if (!check_huge_anon(one_page, 4, pmd_pagesize))
> +	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
>   		ksft_exit_fail_msg("No THP is allocated\n");
>   
>   	rss_anon_before = rss_anon();


