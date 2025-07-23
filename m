Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E6EC83F25
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 07:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13FD96B008A; Wed, 23 Jul 2025 03:46:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F04B6B0093; Wed, 23 Jul 2025 03:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005FA6B0095; Wed, 23 Jul 2025 03:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4BA16B008A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:46:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B10559C91
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:46:45 +0000 (UTC)
X-FDA: 83694747570.25.7E7BD47
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf19.hostedemail.com (Postfix) with ESMTP id 86EBE1A0006
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:46:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=VIu3RiMc;
	spf=pass (imf19.hostedemail.com: domain of liuqiye2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=liuqiye2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753256803; a=rsa-sha256;
	cv=none;
	b=vQN8RURzoCChNZqc5dXEZ4F7Muy4sa18y736qcckZn/zJ01W6leQIOUOooqNql40ZLXR5F
	xPaAmY28ZvI7tTKnWweEClImJa/e+9JYVOQbhqJ/e3kRpvnbBAvn3pwrZK5MoxcpGwwD0U
	2cdu7Ew851WKaDUakDaOqm9qbHCDfWo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=VIu3RiMc;
	spf=pass (imf19.hostedemail.com: domain of liuqiye2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=liuqiye2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753256803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QdwtM+ZTobn78aFin1VxfehR87TJtajIWuTIlJuGaW4=;
	b=IwY1EVrVv9hccQdcp5EiYajKo83uRAnvwYKDg6msWr5D9YMl3L3YPWAErYuaaLAkgyKsz+
	enUcBxwE1XbOVOVaXkJW4siULtfPnnFi71HqTZISabSQM4Rw0iX5J+WYUlyuX0UDDHMXxp
	tacVNTDXrl06hgJeqT7kv/ky8//2o8I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=QdwtM+ZTobn78aFin1VxfehR87TJtajIWuTIlJuGaW4=;
	b=VIu3RiMc1TE02syEQwNuBjti6uiptRARgYNN0+LAri/La9G1cMGP9RPykKBftQ
	z9ILruiFz2VDheTiOQ4mf6oFMMwLNPKWMxMlsyi+HhRQio2xiJxYK0mndl/XLL+D
	w0ejlh1YcG4mU2C1m/EEfo0PdjrGVsoxhX6krUT+MDnMs=
Received: from [192.168.22.151] (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDHPKw3k4Bo1_HrGg--.1050S2;
	Wed, 23 Jul 2025 15:46:04 +0800 (CST)
Message-ID: <c7a32d87-efbd-47bd-9a18-9eb51e441a7f@163.com>
Date: Wed, 23 Jul 2025 15:45:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add stack trace when bad rss-counter state is
 detected
To: Kees Cook <kees@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250723072350.1742071-1-liuqiye2025@163.com>
 <202507230031.52B5C2B53@keescook>
Content-Language: en-US
From: Xuanye Liu <liuqiye2025@163.com>
In-Reply-To: <202507230031.52B5C2B53@keescook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHPKw3k4Bo1_HrGg--.1050S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww48uw4kJr48CryDXr4xJFb_yoW8GF45pF
	n3KF1DJFWkX342gasIva1qyry5tw4qqryag34kA3yfKr9xtF1FqF45Kr4UKF1qkryxK3WS
	9F4jgrnrAa90vFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jr2-nUUUUU=
X-Originating-IP: [223.70.160.239]
X-CM-SenderInfo: 5olx1xd1hsijqv6rljoofrz/1tbiMAGTUGiAiBfEtwABs3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 86EBE1A0006
X-Stat-Signature: jq3pshbscubwnn19xoae3y3mqk3awwf6
X-HE-Tag: 1753256800-879592
X-HE-Meta: U2FsdGVkX18EcTAkTdF+AWCLd+OwFRC7ktyBh4/R8fcvWbrDCPaMcD0/2sdyA0TDHeGzi3kbl7Z1HoUpXA5QABB8/AG3zsntCloUtZEUj5bLdcSH4MqodaOJfv6Fj1r4KCN0Bgf9ZEU+SCyI4VI/08//TB53poNaMz7DkUuYczBvgw4O3+X/we5w45eZ9UPi8pyhVvq2DoRm9cmkG0NTyH6sC6aFplW6kI0+EdGT7KoyEUPHvtuwAqu/anD/KKlsSUDJPfbT8Ck2DyPGWTWijKM8RWxiYJAKyIwmNs0IaK7QkN3OFDlCAuj+YIa5OwQgLiCphhuOn469kB80Xi4oPYj3GZ+RrP6MjVuEvsPzEkPd2hMh3aLoer8NcQ3xfPZtizT4YbTniZVP8V0FgtiG3qVWYQQSBRvkwWcvnFrcnhPDGwWFUPyyTknlWnyN/GC6FAI2h33KqfcF5l68Pa+STdXxkomAGOdrq6L9PKHemt7TkzfyAR3fRqpoAOlTupMnF1Iv4sgfwOie+pN8ai5Tab/PCPNuIBBa1dm4UCPxvjHCWCVg/VUNEtRMypgyLfLlMYPBXIwhagiLbzhRluVZbxkNzvRuZ1Iyc3aJg4FIo2Li70FrNPN9AgNcHVLnLmHjMVxeez7/7+1UYXeenraLovTBrdxPDrNcOIgWGY+YDK6inU9M68NoPxvOIlpIWOEICSYvwcYwIciI/4vpcXLq91UtTw3LoXDfYogZ0Nq7qoQdsvCh7FlvC3RKYADTpF+JgqyAnp0f8+5Mh8PJVzm9Rj/bL+qKtvmEsHxYwPDQfLsejsLZMM2oOHmgyDXbYKt7rWV24KbFgArWQccrAmTYJCbypI7FT+EQaWslCHT2zxGfU01oHZidJTOFOFBJeAKaWnnR9pwyGyu+0oIlZgI+sTRCBt0lz2+Hnt0e5iIPkFUfTRA5cV6EA0YeU+az4XlG5hRXNLaSw1zT+ra+isv
 7mqQ8yXY
 LGWBgIntDW5/7TAs4Fr5dXqKIY0T59QNj6qrIdI8+YjYkPbWguRYaY5mjr11koWr0exBV+KBw/uY84czjo0WEJ7xcJ6qC0s46HJVfVV1wObfTaHx8o0SWrgBqn4bR/pfDw4+OMEVO1k86JH71VymHVJJzzih2K5DAPj895YwG9S3RBoLn6zTrofMR72j4q54I9y4y9bA/bbbyUUX3YBBYs5nLQq9ro+Z8VTO4bZLov8/K5tb5IaEN/4CeGoxA4/P91rf6CVK40Q6bg5rGXlDRqovRMhwdsBge8jGe5ETXXCGtpVGqT7uIwcrd1Njj5xh3OlIOnTpK7BVY5tCchJH1TQMtDBVrmId4CClJYO2F1jyUv9OELrhS4xPqeGrljuKBT1G4VvjN5S8tN5KBz999EKXC7X3XaRUhlH1peZUlg641oop0CAXR1kjrqsf16/P6QVaYb1DFLIhMQHUutNmElK8olj+jaBhxB2dNSW7Wcsdai/ssrIwcbC6dWDWumiPIj9Zir5CxsU721o+1w23gytiM7d0Dr/PA3iEC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/7/23 15:31, Kees Cook 写道:
> On Wed, Jul 23, 2025 at 03:23:49PM +0800, Xuanye Liu wrote:
>> The check_mm() function verifies the correctness of rss counters in
>> struct mm_struct. Currently, it only prints an alert when a bad
>> rss-counter state is detected, but lacks sufficient context for
>> debugging.
>>
>> This patch adds a dump_stack() call to provide a stack trace when
>> the rss-counter state is invalid. This helps developers identify
>> where the corrupted mm_struct is being checked and trace the
>> underlying cause of the inconsistency.
> Why not just convert the pr_alert to a WARN?
Good idea! I'll gather more feedback from others and then update to v2.
>
> -Kees
>
>> Signed-off-by: Xuanye Liu <liuqiye2025@163.com>
>> ---
>>  kernel/fork.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index cfe2f1df5f27..d38f1c5270ea 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -584,9 +584,11 @@ static void check_mm(struct mm_struct *mm)
>>  	for (i = 0; i < NR_MM_COUNTERS; i++) {
>>  		long x = percpu_counter_sum(&mm->rss_stat[i]);
>>  
>> -		if (unlikely(x))
>> +		if (unlikely(x)) {
>>  			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld\n",
>>  				 mm, resident_page_types[i], x);
>> +			dump_stack();
>> +		}
>>  	}
>>  
>>  	if (mm_pgtables_bytes(mm))
>> -- 
>> 2.43.0
>>
-- 
Thanks,
Xuanye


