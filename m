Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5439AEB5946
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 01:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 525626B0005; Tue, 10 Feb 2026 20:24:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5067C6B0089; Tue, 10 Feb 2026 20:24:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432C36B008A; Tue, 10 Feb 2026 20:24:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 334EB6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:24:08 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD3F61A01E0
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:24:07 +0000 (UTC)
X-FDA: 84430429734.04.34A8ED0
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1EDBD100008
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:24:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="b86/g32+";
	spf=pass (imf14.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770773046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MnDmV5IQu/jnXX+pmPU4nJ4kwJNeE3fTXXAd2vIReY=;
	b=xIvEmroN+yptp61wojrdijw6U92Ipkh8wlMSCudPGRu4NFvXxoZerpJpTIIJv+VE31h5Ft
	DvOmQX9/3vt0qugMtGA8xsCDA5oZcH+ESpoUP0+k/eNJSaRgsBTCb25VDMLbb5ROXT80x7
	r36yMVpi091N9oVV+0MhUJA49X2/l0k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="b86/g32+";
	spf=pass (imf14.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770773046; a=rsa-sha256;
	cv=none;
	b=mGrCqyr2x+c4sZxGHlOLexarG1rWn2DeXenCYleC9etKMfvI6G0m39IF4VIyxjrj8yOifQ
	8HmMC1T/+/IDZFDaOjUS+ilS61E5P/pyMzZQdhkHTwZtDikjBP3tKrLQY2z2rV7fiGT3hj
	50y9WqZYcR7piZGrxXIb64kLr0UubUk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=+M
	nDmV5IQu/jnXX+pmPU4nJ4kwJNeE3fTXXAd2vIReY=; b=b86/g32+FT4tra5Zfh
	v4CunaMUZab3+RGQnBJb3CR5/vASUYw3wrGhdN0qoK7D2vF5R0A6MDTVxNYlug05
	XlObd8HIgY2u6o7KCIHbYwyeKPD0g5rFunf+hPlIDKU74f9KVBfFWmerb2yLH8gy
	cdIO0xn1JnPe0WP7LoitnFpMw=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wBHL1Yj2otp2VksLA--.37135S2;
	Wed, 11 Feb 2026 09:23:47 +0800 (CST)
From: ranxiaokai627@163.com
To: pratyush@kernel.org
Cc: akpm@linux-foundation.org,
	graf@amazon.com,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	pasha.tatashin@soleen.com,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com,
	rppt@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -next 1/2] kho: fix missing early_memunmap() call in kho_populate()
Date: Wed, 11 Feb 2026 01:23:46 +0000
Message-ID: <20260211012346.208225-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2vxzv7g4sof5.fsf@kernel.org>
References: <2vxzv7g4sof5.fsf@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHL1Yj2otp2VksLA--.37135S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7try3tr18Gw45uFy5GF15urg_yoW8tr4kpF
	WrGa1jkw48tayjqa12gF12934Fgw4ktw1fta4UAa4fJF1DZrnaq3yxGa40vFnrXr1S93WS
	yF4vqayfW3WkCrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUpVbDUUUUU=
X-Originating-IP: [117.176.243.201]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7gP7SGmL2iPjdwAA3R
X-Rspamd-Server: rspam11
X-Stat-Signature: py4iocch9hgsg9619xwy8fkfuxoo8qta
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EDBD100008
X-HE-Tag: 1770773044-356260
X-HE-Meta: U2FsdGVkX18WwNfSvZlUbLadq39DnccNMS3Mr8IQHcOGV1tjV4rwGDKdtxVnimWuIiWaJESrN3p/IWC0FtCmNSddsXtoE5nOhaNniUSrentYE3KERyZasKANvBedEFu9RkKTj1VMl3rOXMNpv6Whu1cMf0cWki1un1y753s+q6VMAVIHXpQNLusIn4ELjxEgTMN5fQh/jPM1Ov5+9sb+/uKI51ddM8Rw8mGsCroRey1T0nebin0uZOD6sZEJQSyx+DReWQ7h3U3eQv1vwyznzQZVaVx+qmzF8fjlPZ40hvIN/Ii4ssSSQovIpl4DsHLG66fVh+e4anWjy4zY98VU4UwIl1Gvg5OztTUjGIqmRanZDTfeGKBJXcxGr1kvDIphVwY7ulBph6igncsEXxupD2hy/SmSFcF6v2GVr3KQLTIsRwCX4ZmUgDTsCk+K/Qs2SNrsKCPgoGdUsmavxwI084zRJozy5vhMI0/CFJNRMy0hvD20Osp4fzIQeZKBGFNeAeKqEijIN2n80FanwufNxBHf8dTM1c0BLuzg5TjV9hfL+QaYNilTxpLC7m924F/Cg+p10JrX7yKwzOkqJSi+JhNsGhmOhZ4gmCZ75SHFam3JPx4anHzLXIZZMSnpXZgXBGsrE/pDj1qs1+Ic30ADP/GSqcHGtSOtUSMkUqkZRJU3oshUyMRztfiQSZhbV/0hSoJYDh796qnbNjRhrhsxAa/U+JfYJQQbDrFSp6drOqDh1cNEoM8/vzWunQxfNuMj1p75K9WEedZMrdMb9eW/ox9T9sjl1+412L6zp9sspPMZqi/S52k3yMesJpcD8chhi8Qx8mL6AzadIUyBrpbF4PZxlLMsXFTCQEZE5oGFpG6phMuTg+gehgPMM6WQqOW6EitfzoKhlo78J4Hsg7M9WFh2arrOlHJqJs8Y3yyImHd73+co/sFGEeF3syJQlpGrPW/v40p/CCIW4BoyqjP
 WVXOucha
 mfAJL4WuZ/f6N4d52/sNh5b01uoBt+sdri4v4wrb1vNOPA9hAr9XSe/jeGXW7B7tWtT4U052flYpwcHAX2tFz4AQwRmTE5PsIIOHfFLIv75sWTlXmCoPMj+iAJusWxwRfEr2fvXtRppRAGUysjIfhoLpfDknGYlhAL3uuWQxIZco9AxzOZt6miNuhzkbb4mjam+MjHm2C92Xj6T6yzILKDBSpAZ2OMlvm/PLNnyG126lKqMK6FL1Fql5BX7n4RwWC5z3ySnPw9MTX+0sdZvCn4dD1WITQ73SDTUa7EZWPgcgolm5m0LT1b7ML9YevcGXq6TOK6loMtoshIidfcUeGna1iBWB924BSSxkIBWTPZxNxe70X4XhLYmHth4/Tg5+gdLcqwovUkWTLgEbYRZDSLBziYJYEUVElsWUPCIftwQNAg/zoSbJnxGZS1wBdGaQ1rli1D6jaAQl7IKkW+jW5lPZohOfxQVQZJ1TrIcCIwGk+4fq5XlN+ReTuBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>Hi Ran,
>
>Thanks for the fix.
>
>On Fri, Feb 06 2026, ranxiaokai627@163.com wrote:
>
>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>>
>> kho_populate() returns without calling early_memunmap() on success
>> path, this will cause early ioremap virtual address space leak.
>>
>> Fixes: b50634c5e84a ("kho: cleanup error handling in kho_populate()")
>> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> ---
>>
>> b50634c5e84a ("kho: cleanup error handling in kho_populate()")
>> has not landed in upstream, so
>> Cc: <stable@vger.kernel.org> is unnecessary?
>>
>>  kernel/liveupdate/kexec_handover.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> index fb3a7b67676e..76b714db175d 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -1463,6 +1463,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>>  	struct kho_scratch *scratch = NULL;
>>  	phys_addr_t mem_map_phys;
>>  	void *fdt = NULL;
>> +	int populated = 0;
>
>Nit: Please use a bool and true/false. I think it reads much nicer.

yes.

>>  	int err;
>>  
>>  	/* Validate the input FDT */
>> @@ -1529,16 +1530,17 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>>  	kho_in.scratch_phys = scratch_phys;
>>  	kho_in.mem_map_phys = mem_map_phys;
>>  	kho_scratch_cnt = scratch_cnt;
>> -	pr_info("found kexec handover data.\n");
>>  
>> -	return;
>> +	populated = 1;
>> +	pr_info("found kexec handover data.\n");
>>  
>>  err_unmap_scratch:
>>  	early_memunmap(scratch, scratch_len);
>>  err_unmap_fdt:
>>  	early_memunmap(fdt, fdt_len);
>>  err_report:
>
>Nit: now that this code can be reached by non-error paths, we should
>re-name the labels. I think dropping the "err_" prefix should be enough.

Thanks for your review.
Very helpful suggestion. I will send a v2.

>With these fixed,
>
>Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
>
>> -	pr_warn("disabling KHO revival\n");
>> +	if (!populated)
>> +		pr_warn("disabling KHO revival\n");
>>  }
>>  
>>  /* Helper functions for kexec_file_load */


