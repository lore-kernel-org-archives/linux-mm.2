Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA71EDF022
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 02:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626966B0005; Wed, 11 Feb 2026 21:39:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AA716B0089; Wed, 11 Feb 2026 21:39:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B5BE6B008A; Wed, 11 Feb 2026 21:39:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3983D6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:39:33 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD1CB1406F1
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:39:32 +0000 (UTC)
X-FDA: 84434248584.24.8F505EF
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf16.hostedemail.com (Postfix) with ESMTP id 583AD180005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:39:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=XG7a5huM;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf16.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770863971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lvn+uOB5MSzhQfC88CvOnl7GbTsv9utGmhB1j+EiHpk=;
	b=mVqeELTpocaqQJHqIglllCBpXE4f2EoiJIgcPHtBLlqE+igIt8yMjve1FjMHHsB0m1qPTp
	eavoT1N5GSi+DkhUV/JlgLuwu9CVD1HdZLF6Pa0jNzGZsAB6GSPHrpLpvyposuCDztVg4f
	zmMXGJPCD4XknpArMaP4m1zGRNpY3sM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770863971; a=rsa-sha256;
	cv=none;
	b=ldCHBm9bwjL+sIOq9DhowsXkErvs2rTvCrN3PiQj46MqxblEDutIybOTmlwoYicNpGIDaW
	oN0hC0HyDCLEpOFhBxHugzqkBdI7T20BgdM2ZDf6DnVR1lSWH2figOfJXgyFq1kdOBJvtD
	CgtS1cyjhrde9OSsWRkIABLCiFy/TKs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=XG7a5huM;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf16.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=lv
	n+uOB5MSzhQfC88CvOnl7GbTsv9utGmhB1j+EiHpk=; b=XG7a5huMj/vxPKDcXx
	lfroxUrLkRQLEUcFGZnjTeIpt9vzxystePlkfKBR7T3CfvJ7QVh2lyJuBrqrXDeD
	KRX4fmMj0ELP2UTwkY7jk561zmX3tO0c04LcQAicsWKqrzkx4gbh43eeHiw0U+3G
	bPlQL/EXCPLyv0HMCgXivG8Fs=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgCHgI6wPI1pT0+EOw--.855S2;
	Thu, 12 Feb 2026 10:36:36 +0800 (CST)
From: ranxiaokai627@163.com
To: pratyush@kernel.org
Cc: akpm@linux-foundation.org,
	kexec@lists.infradead.org,
	graf@amazon.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	pasha.tatashin@soleen.com,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com,
	rppt@kernel.org
Subject: Re: [PATCH v2 1/2] kho: fix missing early_memunmap() call in kho_populate()
Date: Thu, 12 Feb 2026 02:36:32 +0000
Message-ID: <20260212023632.209376-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2vxzy0kzr5ha.fsf@kernel.org>
References: <2vxzy0kzr5ha.fsf@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgCHgI6wPI1pT0+EOw--.855S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw13Xr43AFWUKF15XF1DKFg_yoW8Kr1Upr
	Z5G3W7Cw48tayjqa17ZF1ag34Ygw4ktw1fta4Uta4fJw1DZrn3XrWxJF1vkFnFvr9Ig3W8
	tF40qa93W3W8CrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUGoG9UUUUU=
X-Originating-IP: [2409:8a62:14:e170:5054:ff:fe85:ffcf]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7hT5RmmNPLQ4JQAA30
X-Rspamd-Queue-Id: 583AD180005
X-Stat-Signature: g1jmp51s8xwb8cjj3rx3z84bf9fhwj5a
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770863969-398224
X-HE-Meta: U2FsdGVkX18AHP53S97RJu6kdfecRACmj97Z3J3xtZrgurlVIb6G5Bf4TCzUoRi2Om80mQNrQThZJ9Mmbb3z3uvLRc1TGP4y+gOXViK/HH+uyAfWydhDUUb2JRL7lnAFbDOsy8Y+E1PPbsPBonp1SSouN/nSAVmCjKItP+a2MHItmPhtrz3x/xgOj+4VyXQeLYtCL1UEz1QtVkWvqg73Mo7UHjtTHOCLvrQXNDjZkPjYGXlNX+vhEc+Pt/PPxKVLFKkg+XWeYsF+EKJrLvuGoEGPbjts0IhYwuof2gggbTbhjOpBn3QZV90iGsVxcf1twRePFrnDk5LcrgRPkO/vKAojwls5PF0STh3aC2/0/EqlV0So9DB550dD46AtJUXm/3IjQHLYICw5SRUFbtTV+9Hg9UaRxvtGnqzf7zoDhErpp/8aR/BWthsklPENQPME5OdRGg1UoX3+SgNdOSe97Iyk1JjAI6RskYGV5W+W+tyU9QaUYjQ0vT8y9b+BtLnIPg7u1GtwhjwD63afzwhOi3//4EQA07lJTZGb2r7NPGFY3ZoCx3jOV3eXoTJx+vN9aNDTVkd2z3kQR5qDis5oSJWZLa+C4FLFG2IktW0SHt4uJPWUwcgZHN4tu4NyYwTs3Ff5Yjukogk24T8OTHKbDCcu88ooKKTbCsktjLQqWn2VpK/Tu782IiAQfe4wzSW/8+eeZxgbAml0/LmBSlZTPPABs5nkIMxT4OZ3tzBRvp/2Zn31vYsH6KWs8RK7mD3HmXxIoGvcaw3/K+PWtTNUBFv/m+1bFDDmJR8N+wODoJaza04PmUvjanf4cmcn74RdpQJGwWp2w6SvXig/T2hDe6QqTtWm/kPp2NUGJ10sx6nQHuv9HOZ9abtsysp6jrPCVrVpPEberz/9s7k06z3burDM16GxY09YtAg0MGaOk77v6Fy4fylVriU/CJiA4bevEofAZrix1eySYjpCi0G
 hAqiNAJq
 NIYEtRvRMbeBaqG5aC1Q0Nfg0HfVnVbui9avnRS6dnS0bTjH9r2/0zGkmRYFoo9xMrwzL+xFa0i2nouLHiCY77ATUheQgQo7Qw2yTUQJ5Pv95yA+jwlahbzZVRav3N5J+ib7j5nf0GujGsr1lnQ5x1eQCHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>Hi Ran,
>
>On Wed, Feb 11 2026, ranxiaokai627@163.com wrote:
>
>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>>
>> kho_populate() returns without calling early_memunmap() on success
>> path, this will cause early ioremap virtual address space leak.
>>
>> Fixes: b50634c5e84a ("kho: cleanup error handling in kho_populate()")
>> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
>> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> ---
>>  kernel/liveupdate/kexec_handover.c | 12 +++++++-----
>>  1 file changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> index fb3a7b67676e..3c705b08a489 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -1463,13 +1463,14 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>>  	struct kho_scratch *scratch = NULL;
>>  	phys_addr_t mem_map_phys;
>>  	void *fdt = NULL;
>> +	bool populated = false;
>>  	int err;
>>  
>>  	/* Validate the input FDT */
>>  	fdt = early_memremap(fdt_phys, fdt_len);
>>  	if (!fdt) {
>>  		pr_warn("setup: failed to memremap FDT (0x%llx)\n", fdt_phys);
>> -		goto err_report;
>> +		goto report;
>>  	}
>>  	err = fdt_check_header(fdt);
>>  	if (err) {
>> @@ -1529,16 +1530,17 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>>  	kho_in.scratch_phys = scratch_phys;
>>  	kho_in.mem_map_phys = mem_map_phys;
>>  	kho_scratch_cnt = scratch_cnt;
>> -	pr_info("found kexec handover data.\n");
>>  
>> -	return;
>> +	populated = true;
>> +	pr_info("found kexec handover data.\n");
>>  
>>  err_unmap_scratch:
>>  	early_memunmap(scratch, scratch_len);
>>  err_unmap_fdt:
>>  	early_memunmap(fdt, fdt_len);
>
>I meant to say all these labels should be renamed, not just err_report.
>So "err_unmap_scratch" should be "unmap_scratch", and "err_unmap_fdt"
>should be "unmap_fdt".

Hi, Pratyush,

Thank you so much for your patient guidance and detailed help.
v2 did look a bit strange. I will update the code.

>> -err_report:
>> -	pr_warn("disabling KHO revival\n");
>> +report:
>> +	if (!populated)
>> +		pr_warn("disabling KHO revival\n");
>>  }
>>  
>>  /* Helper functions for kexec_file_load */
>
>-- 
>Regards,
>Pratyush Yadav


