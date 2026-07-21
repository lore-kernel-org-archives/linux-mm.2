Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21862C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 06:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C392F6B007B; Tue, 21 Jul 2026 02:33:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA626B008A; Tue, 21 Jul 2026 02:33:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00E76B008C; Tue, 21 Jul 2026 02:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89EC46B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:33:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BB2A803F1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:33:36 +0000 (UTC)
X-FDA: 85011817632.02.FEB37ED
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1FC0940003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:33:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784615614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HkKRCPSXJA1sB+va5JOmVEtBFUahj8esELgNBveW5pk=;
	b=5RsrUHtOnh9ht/WrvhBbMCkq3pWuV1WIIgzrcyNPI2q40TKIMRNNtJxkeFwwXRXf2lp2QN
	PrbF3wo8Le7EJukD/+8+mHev5jDbduQIuyIiufyq04Vdn8yc95aX1bf7vZ0ETleGDk3991
	pP5lEGmy1bln5HUBxl1wnv+XtZcvayM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784615614;
	b=K5m5EJat1mx6ljC4dqH6LTrFUfHnVUduHm9Lo5aWy3ACP42n0DNTJajQCLSpd3QxJLj4j4
	Wssx5AFgSm1wQQ03RVgt0VIdoqgUUeYzB+f0DTGCN3x9l6mYozKiBpJdn2veFpXUr5/kaT
	wi/vCasG1X3Iy+KvcIurRiB1kFAupsQ=
X-UUID: 147b4d3284ce11f1aa26b74ffac11d73-20260721
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:5fa9bac4-0e4a-46ce-88b0-19b306f5f5ad,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:5fa9bac4-0e4a-46ce-88b0-19b306f5f5ad,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:c71eda32d66573de90340bbe7ea22ca4,BulkI
	D:260721092816JFTOF5G1,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil
	,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 147b4d3284ce11f1aa26b74ffac11d73-20260721
X-User: lienze@kylinos.cn
Received: from [192.168.111.172] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 399262998; Tue, 21 Jul 2026 14:33:26 +0800
Message-ID: <04c66a8e-a342-427d-afa5-aede30a4df2c@kylinos.cn>
Date: Tue, 21 Jul 2026 14:33:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] samples/damon/mtier: use damon_addr_range consistently
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 enze.li@gmx.com
References: <20260721012801.94223-1-sj@kernel.org>
Content-Language: en-US
From: Enze Li <lienze@kylinos.cn>
In-Reply-To: <20260721012801.94223-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FC0940003
X-Rspamd-Server: rspam01
X-Stat-Signature: b8aund7t3rmzh916chww7k8eadyuqa95
X-HE-Tag: 1784615611-878307
X-HE-Meta: U2FsdGVkX1+R8Q6yub517ZNoPbUPwWtV0XSmBZQ0mWYOEREzf6Xojbc73yenP5Rzxjhr3+nqK8DnKG96T5EUC8oGHTBNZwy48m68tWfUuuDAemYFsc0aVsIlnSeWnSKSI28HtaMj9XxkRC8krpBjrwsJbIfGZG2HOkYlNHsppumzr3p6Q4hf2KKC2zLwpZXq869tSg9eObG0R4GyPU06o0o0e9jm0FyaVstX8Dc/qHLY+br4a72vuR35nriFaCOUCvK2qUCX/KRFZzv9DMQHcsXzh1SBNUio7/Yvi9pfyhproSMECSoEixBabzspSTfVmnGnYH9++tJ89DmXAc2gvoOtkVwkdP9sxbpxzZFikD4wC23VZaGwDHxMUiqWMRFPZ5KRo/gX8G9IrNlDQYjvB/J9HtujCoV0rJrjaujwaI9wH5+bVPVr1PAlKzE6ug5eu4WIxvWJturk8dH7mDP77z7eOrs3pWR+A/1cPWuwP+jCFprP+2M7P9xW2yz3EaNFi5daJnIC3U5AUud13jm7XTz3A20ET5zRmkrxooVmjpwArvrOu/wWjqtX/e+Az4yMJxWtgZMGSSO2OAZiKi41rB/XqowlwdbcE/EkZ4Spe5QDmlCGnfo5ahv/fc/myZfIO2MmmSLd5W7tcXQ4kR97f4TTIk7YqgkVIPwQRVNX9QxqoSxQcKjCxCm9uXEwLUatssssc/QsyNzk3VK1VvRxwzw8mfovYBbxlEIiKOAPpZIhEXMGbvDazXc16v16V0SWcgr6JTn8jimsiaXXHbtg9ioQpZNz7X9pTavYF1w4ii8LcKe0mMW8HDYVUBowZ5YpI+pTspu3zX3N28Mtd6UlUjtnUHh7CM9aAIrgptZkqupKUZDuL9EqJ4tAHFVs/DLVrtyoLMElxF5sFKyrPO1igiHBaV2LfKdNyc+flwLEvsaeZuYfPITcg3+cKtVKWIdRxTJIn/QkUPkzcrZeiht
 73MxG0L3
 jtPtOyao6qcoDZaNEwOgQ8hQeM1zEbJ8p5otYohJGSvl4oj9niwWQmVOQ03Mce/GWNNxnC3+lOLJ+w5ETY1KCCHXITQKtPOGq7NBa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 7/21/26 9:28 AM, SJ Park wrote:
> Hello Enze,
> 
> On Mon, 20 Jul 2026 21:06:42 +0800 Enze Li <lienze@kylinos.cn> wrote:
> 
>> The DAMON provides struct damon_addr_range for unified address range
>> management.  However, the mtier sample still defines a local struct
>> region_range and mixes its usage with struct damon_addr_range in
>> damon_sample_mtier_build_ctx().
> 
> damon_addr_range is for DAMON core layer address system that uses 'unsigned
> long' as the address type.  Because 'mtier' is dealing directly with physical
> address, we use a dedicated struct for that purpose.  On 32bit systems having
> more than 4 GiB memory, this may be necessary.
> 
> 'mtier' doesn't really take care of the >4GiB 32bit system since it is simply
> casting the 'phys_addr_t' addresses into 'unsigned long' addresses.  But it
> might support it better in future, using the addr_unit parameter.
> 
>>
>> This patch removes the local struct region_range and changes the
>> parameter type of nid_to_phys() to struct damon_addr_range.  It also
>> gets rid of the now-redundant local variable and pass the address range
>> directly to damon_set_regions().
> 
> So, I don't think this change is required as-is.  I don't really want to add
> addr_unit support for >4GiB 32bit system, either, unless it turns out to be
> really needed.  I'd like to keep sample modules as simple as possible.  If the
> code was confusing you because it is anyway casting the types, adding a comment
> explaining the rationale might be a better change, in my opinion.

Thanks for the explanation and the feedback -- I agree that keeping
struct region_range is the right call.  Per your suggestion, I've
prepared a new patch that simply adds a comment to clarify the rationale.

Best Regards,
Enze

<...>


