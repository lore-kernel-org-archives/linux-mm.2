Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3894EC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3676B6B00AC; Tue, 25 Aug 2026 09:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F13E6B00AD; Tue, 25 Aug 2026 09:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9B26B00AE; Tue, 25 Aug 2026 09:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA5E66B00AC
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:18:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E353A03A0
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:18:52 +0000 (UTC)
X-FDA: 85139846904.03.14B026C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 96AF32000E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:18:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tosz2tLY;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787663930;
	b=OLE0YxonmJdycR/payBFmiHqa3FnrBu3c0dea016B7zNCa3DqHqiu0aa8kMIjeQPtT+XmG
	aO4ZK92gIg2bx/4RklX1G56QKX08xp7kCB6JFzlfutFJSXaP62qMw8gC4xQhbDjqNW1nrT
	rujjLMYM4FZ4qI0Na+WSiIaZAV+y+74=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tosz2tLY;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787663930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OsKqana+TRC3+50ZBf9a3d0NzXhzGqX/8AB52gbPxJI=;
	b=lgo4A2wN4wYSP3r88HfTiZbIX+qkx6+JGP9IIF3yz7E314Pt+UNlqo6Mq0TdKnuCX4tC8D
	SuTQd2bUaVqpTn23dbm1LVJcDM1uubqaguqyvDpNz0tWU/1MyaPLQAYJcgCMi28izErnkd
	3gRBCxk80lQL9fM43jAAQSsybQK6aCk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 903D81A9A;
	Tue, 25 Aug 2026 06:18:44 -0700 (PDT)
Received: from [10.164.19.33] (unknown [10.164.19.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 95FA03F66F;
	Tue, 25 Aug 2026 06:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787663928; bh=oqx4vw6gp8Mj0VrjxvBO3V7o0meDa+xwNBbns4qZeZM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tosz2tLY/eQrRQrkLmdgQFx72H66rn94BA/7jp2lmSTuv5n21hCcBicIY1XlxZRZr
	 nWmSFIQeYFGukbCsW+LW6qCipcPlNYPNqtQ+mk7baZJ0SPwQjs0KZ7y7n0rESswu5x
	 R9jFpFM33OYXwBO/AFl9VK63sZA4HwkmswLAO7fo=
Message-ID: <482ad8b2-680d-4682-80e4-baf4023bcef7@arm.com>
Date: Tue, 25 Aug 2026 18:48:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: khugepaged: remove str_dup() usage
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 96AF32000E
X-Stat-Signature: 4y9sigc753on4d4mbh9wb1qbcorxbdwp
X-HE-Tag: 1787663929-901270
X-HE-Meta: U2FsdGVkX19VLJ9UU2WOSfHi6LGCaf+1THil5IWmSVqM/enrpiqV5eDOICNCJ4h4ow3Xq5LQo7BbFXMvOY/L0WpPWO/270AOp7UG/OlXH3gJUUevTPkSI5ltc9AH8SViJnwbU8n09dXmwR/DoF0uvAeNG/HuxAr4GQzb21HEpgoInk+0qLPvJXhu2xjzdmMeZUrEBrXl05A6yah+8abAr4qma9CBADywLzz4MEo1cCS+YPuIwmdjgMYC1IcI50ZCxGKbpHgg/Jt2VoOJAsCmVW/ChxTCfNy6LW6qbcJ+gvxg7e31paIIXuH5lWcCiQSEJgU+YwQpSOYpz4UsFU5sV7ACK3bczlb+4aysrUOp0VgN4e5R1GLn0UUdI8e7AnsxifDW/DzJyMgcSmPs74rapEXmanEa7ZR4/X2WtbSuFKDH2/pdkc089SuGAhR0x4F51ugeR6JdeftB7vmUREV5c6WBpZO0v+Z+KpiedELtPluPGL3hLEhocMGVh9V8elNSO/i+fjV5eXA5DxBveTWY3UpgQ/VreLDXByACm5swKZ5i/7fU1pBIJMP5SDPwrI+uxkhD4rUlMBgqIkcV/3K+SyF5ducSc3+8PDe9FW3eJjWK2NLhivY8DRsgddHvixGdh/i4Km56cs0sxiGDLS2jGR9yh/JBVn4TmuTim/TRUUFirvpXk6h99w267nWPkYVLl0DZ0UrBQ7Jthta7PSp+nzgpqqvq/DrvLThL8/lWz+kHqOoxa0CuU0IkT61FsJar+3Pu7DCvB0rNXgCvkJSeV4HA07usCm5mP/IsdqTXz/RowyLgh8fe0f+BY264884XD0jq3hS5pR3td7A5oP4DxmDgDGyd7H0R4Eao0tJKw0izhHweiMmJiquPxbm5FMAGS1hoiCeUwEu1gsMAIERZMS2rRDbekIX6rZh4+9+vWJCzawXrt7iUIEvHAG6TKr7R4yi4cafOqvSd3PjTh+i
 BcAb7EEH
 CGk7Odu8mkbTYol6RYpU50KEhHSfcBecdSn/cETEL7tDY6A2graCQ5PW3jK3c5QoNzt0QjIFMtNIOCukxhU/qtcCRXtigd5p9AZFCGTT95vZ6eeUWPQfTnJovRHYskDs7jrwbUtsoUUUQU+Upr5auCSGrkFVK1DndrhmAibg6GxGSqX6uo0i8AV4ig1ulsxvidC26hgxIxExIvj3h1/ty+JXtGVoGvKWM2ao1ptdQ2EJLB72VOVlnl7d+i7oYQQW2Fo1ylqlD6OlZO5qLYQ2W8HTK4dyZUpSHvjwJD4n1Eq+AReLwnggMPchEixWd8J0FLiw2QtaGFLKhlttj3s20a+GHqKvpJ2NT96310k3p+QMsP5t7+zOUUYLsPtUwXU5+n/dVxzeiVkOHOWU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/08/26 4:50 pm, David Hildenbrand (Arm) wrote:
> We don't check str_dup() return value and never free it. While both
> things are irrelevant in practice, let's just clean it up by working on
> argv[0] directly and avoiding the str_dup().
> 
> Nobody after us needs these parts of the argv[0] string anyway.
> 
> This patch is inspired by previous work from Anshuman Tewari [1].
> 
> Link: https://lore.kernel.org/r/20260821114416.12255-1-anshumantewari123@gmail.com [1]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  tools/testing/selftests/mm/khugepaged.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 1d2d6bd72fd2a..83d27d069c413 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -1227,7 +1227,7 @@ static void parse_test_type(int argc, char **argv)
>  		return;
>  	}
>  
> -	buf = strdup(argv[0]);
> +	buf = argv[0];
>  	token = strsep(&buf, ":");
>  
>  	if (!strcmp(token, "all")) {
> 
> ---
> 
> base-commit: 169393fff5d1ec2690934067eeb95544ff5ebdd7
> 
> change-id: 20260825-remove_str_dup-bb089e93094f
> 
> --
> 
> Cheers,
> 
> David


