Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C34BC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 15:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DF146B082E; Mon, 17 Aug 2026 11:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6496B0830; Mon, 17 Aug 2026 11:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5AE6B0831; Mon, 17 Aug 2026 11:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D2F9B6B082E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:37:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44122C07DC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:37:10 +0000 (UTC)
X-FDA: 85111165020.10.2903584
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 34CF91A000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:37:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dDnIm5Jd;
	spf=pass (imf19.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786981028;
	b=Ynvs8jC0KPPIoajQasnRjv36NLaXtd1f4ZbMt+KxvLJZXzcDTgoLdH2Jw5LhdeXsEeaLkp
	1PuV8OJ+e4OrMSADWx05HMgZ5s500CUNxH3WUZjhGYd0XA1anIaRBy71ww+Ew8qbeXGTNY
	TblQWvZvZxyVaSedShOncvMw8gGUDC4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dDnIm5Jd;
	spf=pass (imf19.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786981028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uu+hEA6LpTICQTZ2Rl+lYaUZeI9j9QCxnG5iiqyr/Ec=;
	b=2mWpYPeRSuEn1ZThPhjcJuVvRGkt0QSAuk3zokpZnvar8gsmueCUDlAWoMX7GxOWcJQpU7
	Gvw0+zTQ16LfGSDTfuiJ9cE+WmEv0ucaLNbPPxCOOUQs5ueERoWH0XejlqBrqWIOminXXD
	pLGElgZVjkpjEnh16BJv4LagviJ5LbY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 297001688;
	Mon, 17 Aug 2026 08:37:03 -0700 (PDT)
Received: from [10.2.198.93] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E01183F673;
	Mon, 17 Aug 2026 08:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786981027; bh=Lq8S4KyCIQ2zIcu/qUjZ64Lwjmhb7UJ5gjGjbTMLsHE=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=dDnIm5JdpaOigqiWjHMFyPCLfIQKrdkFAkOAp0xg7bnE4VWgGnQi+bTRR08FU6Gsm
	 NiWWbiQ6k7VqAqUr78RjVlcEIMVFw1UL3XkFnchABg6+DnRtddDI3voFMliWalELVr
	 XXBTVm5O4umADdQWlHLumZwD50h0r/c9hURvdVhs=
Message-ID: <c8eda67d-34f1-4179-a1d7-ca2c28b2992e@arm.com>
Date: Mon, 17 Aug 2026 16:37:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-mm@kvack.org, shuah@kernel.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com, peterx@redhat.com,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] selftests/mm: emit TAP header in uffd-wp-mremap
To: Song Hu <husong@kylinos.cn>, akpm@linux-foundation.org, rppt@kernel.org,
 sarthak.sharma@arm.com
References: <20260815080716.3596514-1-husong@kylinos.cn>
 <20260815080716.3596514-2-husong@kylinos.cn>
Content-Language: en-US
From: Usama Anjum <usama.anjum@arm.com>
In-Reply-To: <20260815080716.3596514-2-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 34CF91A000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: u54exncepfhpcgwfpbmrfx6o79xpsbkg
X-HE-Tag: 1786981028-410291
X-HE-Meta: U2FsdGVkX18kJDsb6u3et1aiylGg3T7J1m+fbUWJXVjLyrtjl2116P+3wqKbacBs4EV4yfVDstz0xJl6P+/mONisw5ABw8lPEbVUVA21P9L6IiBQT1xxj8shkKG+uHnQQX7DuXBVlgzwt9Epctyc+QZqJHeT3SWSbzp3RxkZNOiGlCY6W9SKeydwSZrJZX1R7edjhcuyIiru3uHXB9bYEtzMYcASyuOjQayX13FkKxRWRe7Z4AsOM5Nol4huGsROovQa/9PnUEl0kWEyHZpeIGq8dCKdVOr+qOoQNATuWxMu9iIWnPAalHlrqKYSs8k/MKUiV4qHKrKyCgnTiu/RUGk+5w62KR11URRJQm9DPhFynOCTIOQXKVMMdcYGxKZQ3Vw3HCwatlMBAEaPYfYY6xzSLBcviqQ3dy2S7Mdf24zUK9TguMo8b6RBDQfOpwOAW4+NyTKbReeYZe68k3GmpB93ONF6ZKFGqKxBEIFZXeH/e9coyu0/kzienfC7qfdy+SI0YKp2rgEBbfVolYUfu9P59HLErmwVFjnlFgSNi3q9eyZqcQAO4woUiERmcFa7K/5DTo2onSbLiVP6v2/gle/dQXwnaf8HhMulIDPYhLBzEAtgvareCufbF54sJ28BU2psHbFmOzcH1rmEwrPMYgpWKHMPcLu56dgLmP6a63V8wytwhMS42+uomcp7ZggUJFwGaOnBE9BX/Hjax8TczmsYgmTz3ccDtzYBPmgcoc2GHs9nXkFJmClYMY3zoUof3mnFTWxNxBA9VcBWrSAFF8mmWb5xf8lYO4pAvPuEHlQPel78oJv7Pg6speZaWyLsPjidCycJV19dVrzjUR+EX3Y83r0TTAMASkmnTqmW3u/gbsIvmJBMK77LGLMHrn4+bCrk8h3EL32FG7P83cN29NeSHYYrM3QQS8UOXUG+nkeks3Vv+S+Cp3DmW3CARDi2QpnuSqqOZFN+C78ntpK
 Amu0C3b9
 hAZ8QDoCdxd/rSPwvIAayOgeMIANRQd2vyu/fGEkG6wSNF3yBCL8g6uamJMbi1trqtY9ZZNrr1byLsS80ydJI9zONLGUY471F8ypphWxw+rq8M8dYtnJQhuxPEPp+4oAsPoA5+S10z/KjohGOoI5kqt9c4nygFYbcMPzjJ1WIOdk38+RUCl0iFUR3XaK+fiddQvCupvTaMvHo4oE8ftJ/KGJSayZPCat8Y6L5fbX+QVPsaWMHhT4+Da9AyoL6/tMYfnuBG7klJUDcSyEkagjN4bBk5witk8CFtGWIpPAu98UhIVJ1284f4iYy7k7rQzVXUiW9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/08/2026 9:07 am, Song Hu wrote:
> uffd-wp-mremap calls ksft_set_plan() without ksft_print_header(), so its
> output is not valid KTAP.  Add the header, like the sibling uffd tests
> (uffd-stress, uffd-unit-tests).
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  tools/testing/selftests/mm/uffd-wp-mremap.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
> index c973d6722720..572c2516e874 100644
> --- a/tools/testing/selftests/mm/uffd-wp-mremap.c
> +++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
> @@ -347,6 +347,8 @@ int main(int argc, char **argv)
>  	struct thp_settings settings;
>  	int i, j, plan = 0;
>  
> +	ksft_print_header();
> +

Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>

>  	hugepage_save_settings(true, true);
>  
>  	check_uffd_wp_feature_supported();


