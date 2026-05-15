Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29974CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 06:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 677756B008C; Fri, 15 May 2026 02:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6288E6B0093; Fri, 15 May 2026 02:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565136B0096; Fri, 15 May 2026 02:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4632B6B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 02:05:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D045340817
	for <linux-mm@kvack.org>; Fri, 15 May 2026 06:05:12 +0000 (UTC)
X-FDA: 84768616464.21.8CF570D
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf01.hostedemail.com (Postfix) with ESMTP id 12DD440005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 06:05:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=iBe5KmEs;
	spf=pass (imf01.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778825111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cr5xFD2Q2YObhiNkxEd5S7e4B/+pO8b36J6OV5gxQ+c=;
	b=D0vQHq99D99eAhda/3vYMRj8/NdBVrSI+dr0ALorHG5caLC4AudGsMbamlqy13ZjoTdFjP
	NIJBIWjPOjBlWjqt6lfz/uPKLqI5Sy1RdOQRKaLz3UT//5VFVQtw8p9ZyOsmYjn0Mo4fXI
	h9qx3AhORe6LyZ9uL3atIjCKkpHDNFE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778825111; a=rsa-sha256;
	cv=none;
	b=hKWoF3LWVNskMUVloYGjWuU6hgbgB964YUHizfrlJgI5OW8aZiBrfzfkYkV5OJXcr5RA28
	c9QAo1h4vCLkNUU9OT1RDCvR+DIqTBPWVGAdf28NoMXS8G1LM4Vku6yjHbuUaLgc9x5ETW
	ffc+vKIIyYdyNxjsIkI8rrVoVWRX1x8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=iBe5KmEs;
	spf=pass (imf01.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Cr
	5xFD2Q2YObhiNkxEd5S7e4B/+pO8b36J6OV5gxQ+c=; b=iBe5KmEswL15eSRqaN
	kHIXtI/b3gVOd2GTNFkJKre0AuuW7MR95KVqbhCh8jhaCwQlUZPRMY5LJLjQUQ4g
	XH4sNSDjGR/8nTS6krEjQ/11E7WjZDlKUlRa5BUw+TrzV6rBkuAniD2Tj8DFQA2B
	K7/1X12WgW9VZgUmp3nw281fE=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wDnj_95twZqqP2yBQ--.56479S2;
	Fri, 15 May 2026 14:04:42 +0800 (CST)
From: ranxiaokai627@163.com
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	leitao@debian.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: Re: [PATCH v2 2/2] mm: huge_memory: refactor thpsize_shmem_enabled_show() with helper arrays
Date: Fri, 15 May 2026 06:04:41 +0000
Message-ID: <20260515060441.53094-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <agW3KFDoBqZI7-kp@lucifer>
References: <agW3KFDoBqZI7-kp@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnj_95twZqqP2yBQ--.56479S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZry3Kw1kZry8Kr1fuFW3Jrb_yoWrGFy7pF
	WrG3ZIkrW8JF97KayxXF48tryFvr4fJ3W5tr98JayFvwnYqrna9Fyvk34F9a47Z393Ww4S
	vr18WasrGryDtrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUpxR-UUUUU=
X-Originating-IP: [117.176.243.1]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxhoodGoGt3pGNQAA3S
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 12DD440005
X-Stat-Signature: xurda4jbt6ue7zcrp8rnz1z7b1sjftzo
X-Rspam-User: 
X-HE-Tag: 1778825109-689066
X-HE-Meta: U2FsdGVkX1+E5h60z9Aykia4HvRwXaHVj69UR4k/h9+qVqZKUT88A46YO41MTqTn04Td6Un1j9gscCgrs2gE8GRBJ2ibvoyy7vEN8qE6mCIC+ZtmeRWA6dodCqtkNTb3yTP6n4YTYrKvD7mpmgOjo7WfDzg6PeWz81zFNLej2zxvAyXjtVE62brvLROVlKeLJmqtuN/LRP+3HIYEEXwwSvWSDJh8XPzUTBCU9bcffhzYYTymwgqwETjOXULrApvQ5mw/XwQII9y42UA6VyHqWzDj17FlzUUtlg79y8frNBLNKwjdHjJvzFjkXDmxnqQBg/fPkowy3ibeOQIt2qlOU23QZojkKsiaV/ipB40mCzZKyhccYsQGpfOADTGzku4ATZetIbJ9x9DsiIFQQhb8qYs32GmXZwqOG7kKelDjM9wY+aG5FYw7AUrCp/sOvQHOyPTMgQQxVQg61/ddnXY5z8lhpM4mXKf0tfkH16Zgqido2q+DWvZZNpSe9PO8n5Bs3cPfvd0Z/Yk4d7pGWJ7RM4FjB9YZRUGh9RYbWpdD2Dm4soYVd1U2D4qUwmQ+t3HILdFGPB/scu+U8q6byNnjBmJo62fC1qBjNT9v3sSZEzovxrxgk0ibBBQfdd2WArJ5ChYcy6nIfZYyZy/AP4KP891Icz1gQvwHNA9eK6lTVHdO3LHY/PTXGRJRaEWl1sUv1Z5o65HLVyD/AKSls4roOZAovQQq+9d7UeUqjRfJUfORL1AXFOZGWXzjghKKMCKD8EoP8ELbESY190R9O2leQ54IDi8ESJIpgWXqUdOD2cFv2wt66Gxtm3ZnBFA7zSeE3AiUfSudg3kesk7Qcivu1iQUBjvkD+ttKp8/ZBEyRVrCKD08JY0rD+/nhf75ezqC9wzeLkLEEqXt6J3cZLX6ja1z77KFusaUK+wb2kQAhtoZPPVkGfCrNVDvcobeqlrmtlHHJaUUd+forcn+OHC
 5CzT5t4N
 b5ENSFn7pXIovs5Gwnt227uv6rirfsyYVQwrrUCO2J24ZoTenoCPt3U5/k6QI3+NjyfqMdcZfv2nRWwLdnDKCOeFYEyRD4+Rook9MOcPyFknxh3hZwUxEEOM7f0Y+bfCAp3gWJjEKTqhn06Efj7Zii4oD8ZeISHmzvC99H5VMraJpgXPOIUvg647HiN73zSs8Hn7dw4MzPcnhZobZ82DP6Lc59dKEcazlXZSpNBDMfFF9eUKsMUyxeU2QrEFB85N1c4b6dlM0EbJmh6wQaqx6v+IQ2e5szkBhClu8e5hnM1hfrgLXD8qIgvvux/DnZJY2vkFJXnv55t273AaVqbBcz8NvDQtsjrqkFzOn+PkQVxlwWQiBEweNOgzbnQu+gYWsstmEoVBuh5rcozfFBLArNimR1K+fsrTU+7OlVh5GZ2kCCNN/tFofQ/0cL1OypEns12mgpPJoOPDgcT7bURUpoMyyC2JxFAhcX+k4WjMPVSAWiYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>(As I said in the 1/2)
>
>Please don't send 2/2 in response to 1/2, and use a cover letter if you send
>more than 1 patch!

Thanks for the guidance.
I will do that in the next verison.

>On Wed, May 13, 2026 at 09:45:08AM +0000, ranxiaokai627@163.com wrote:
>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>>
>> Replace the hardcoded if/else chain of test_bit() calls and string
>> literals in thpsize_shmem_enabled_show() with a loop over
>> huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.
>>
>> This makes thpsize_shmem_enabled_show() consistent with
>> thpsize_shmem_enabled_store() and eliminates duplicated mode name strings.
>>
>> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
>The logic looks good, I wish we could de-duplicate. But for now maybe better to
>get this refactored first.
>
>So:
>
>Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>
>> ---
>>  mm/shmem.c | 36 +++++++++++++++++++++++-------------
>>  1 file changed, 23 insertions(+), 13 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 60cb10854f11..086762e6de71 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -5553,20 +5553,30 @@ static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
>>  					  struct kobj_attribute *attr, char *buf)
>>  {
>>  	int order = to_thpsize(kobj)->order;
>> -	const char *output;
>> -
>> -	if (test_bit(order, &huge_shmem_orders_always))
>> -		output = "[always] inherit within_size advise never";
>> -	else if (test_bit(order, &huge_shmem_orders_inherit))
>> -		output = "always [inherit] within_size advise never";
>> -	else if (test_bit(order, &huge_shmem_orders_within_size))
>> -		output = "always inherit [within_size] advise never";
>> -	else if (test_bit(order, &huge_shmem_orders_madvise))
>> -		output = "always inherit within_size [advise] never";
>> -	else
>> -		output = "always inherit within_size advise [never]";
>> +	int active = HUGE_SHMEM_ENABLED_NEVER;
>> +	int len = 0;
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(huge_shmem_orders_by_mode); i++) {
>> +		if (test_bit(order, huge_shmem_orders_by_mode[i])) {
>> +			active = i;
>> +			break;
>> +		}
>> +	}
>> +
>> +	for (i = 0; i < ARRAY_SIZE(huge_shmem_enabled_mode_strings); i++) {
>> +		if (i == active)
>> +			len += sysfs_emit_at(buf, len, "[%s] ",
>> +						huge_shmem_enabled_mode_strings[i]);
>> +		else
>> +			len += sysfs_emit_at(buf, len, "%s ",
>> +						huge_shmem_enabled_mode_strings[i]);
>> +	}
>> +
>> +	/* Replace trailing space with newline */
>> +	buf[len - 1] = '\n';
>>
>> -	return sysfs_emit(buf, "%s\n", output);
>> +	return len;
>>  }
>
>This is pretty mcuh a one-for-one copy/pasta of defrag_show(), I don't love that
>we have the exact same code duplicated across two files like that.
>
>You could write something like:
>
>static ssize_t thp_sysfs_enabled_show(struct kobject *kobj,
>	       struct kobj_attribute *attr, char *buf,
>	       const char *names, int names_len,
>	       const char *orders_by_mode, int orders_by_mode_len,
>	       int default_mode)
>{
>	...
>}
>
>To abstract it, but that's kind of a horrible signature isn't it? :)
>
>Could use a helper struct, but that feels a bit overkill for this hmm...
>
>Really I wonder if we shouldn't have this in huge_memory.c anyway, it's a bit of
>a weird thing to put it in mm/shmem.c, it's more huge pages than shmem imo.
>
>Anyway. The logic itself looks fine so LGTM!

Yes, after this patch is applied, the read/write handlers for the
shmem_enabled and enabled interfaces will have a lot of duplicated code.
I will continue to investigate whether we can abstract a more generic
function to handle both interfaces.
Introducing a helper struct as a parameter is a good inspiration.

>>
>>  static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
>> --
>> 2.25.1
>>
>>
>
>Cheers, Lorenzo


