Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78D31C5DF67
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 06:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78D836B0795; Sat, 15 Aug 2026 02:39:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765AA6B0797; Sat, 15 Aug 2026 02:39:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A40C6B0798; Sat, 15 Aug 2026 02:39:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 414F16B0795
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:39:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB093A2933
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:39:06 +0000 (UTC)
X-FDA: 85102551492.16.B751F5A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf05.hostedemail.com (Postfix) with ESMTP id BC437100005
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:39:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786775944;
	b=e1Eia/Y65nC5Ji5PaVJTcYtAO+3KUzthJpQ6zJu0zIEovyOk7EwdVB0hO1KdgT1vk+7CcR
	+q6rtpV1QMwZYX1Y2tFG/e/26M5mslGf6LbNOhYuGgIsxXRPRixer1HvuOsr54/3ob5srr
	0FLh8ETa7q+RHDJEaEGH5rXBksoCiFM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786775944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9aF1146BapclB+XojwyawJjVJstCZN/0E4IV7mxG4Tw=;
	b=12jI4GDi1tRrPB6oht34ePOOhLAT/NsUoLvbKfKnNf9isla562MW/LYqoiZ0dDSdKoyEV1
	kP9a0TCA3cst8AowCeWwKw+5UgNKikpZWfNLMMvOUD5ZFYoPcmSlsejyA7P609hIhYs6v8
	cFKZtmFKfjUxsUtS96+fZQVYDCX+hg0=
X-UUID: fa0409c6987311f19a56ed5b684f684d-20260815
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_MAILER_MTBG
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NAME, HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED
	IP_LOWREP, SRC_LOWREP, DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:fb178eca-0891-4843-ace8-81d671212b4a,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:fb178eca-0891-4843-ace8-81d671212b4a,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:aa11ef74c60a00cac4d399fe696f8f7a,BulkI
	D:260812214313OFOE5GCE,BulkQuantity:1,SF:17|19|38|64|66|78|80|81|82|83|102
	|127|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil,RT:nil
	,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fa0409c6987311f19a56ed5b684f684d-20260815
X-User: husong@kylinos.cn
Received: from [192.168.1.116] [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 702260678; Sat, 15 Aug 2026 14:38:50 +0800
Message-ID: <51e562a7-661e-4581-9e02-ae56b20b9728@kylinos.cn>
Date: Sat, 15 Aug 2026 14:38:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: husong@kylinos.cn, shuah@kernel.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, peterx@redhat.com, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] selftests/mm: emit TAP header and use TAP skip in
 mremap_test
To: Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
References: <20260812120821.523860-1-husong@kylinos.cn>
 <20260812120821.523860-3-husong@kylinos.cn>
 <83c5375c-a374-4c51-b564-0b7ca4f4502d@arm.com>
From: Song Hu <husong@kylinos.cn>
In-Reply-To: <83c5375c-a374-4c51-b564-0b7ca4f4502d@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BC437100005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ph3bwkjtcbmc9t4y7zunohpzj59bxxtm
X-HE-Tag: 1786775942-983076
X-HE-Meta: U2FsdGVkX1+ebMPBn4vyXAlcnRWTg7LfPzrCcR6KolvlNCJb32KCBJOqhiJOREbhZJWIY5I0kl76Np7MZsnNZ9nLAG9JNaXZr0Q2cUQMLMjjv6EQmHIbL10Ns//43HTCSlOQ2pjUQ7nB849YUN5ZMgYrUpe0Et9eMk+Xgj+fPCyUbkFcu7JaxzKZC/RZLtyK0Uy772ey1BQSrLZ5fHjc1rN6/mDrhXYqUvKOMhMNK8yvrIHYLneW1G7BYnGLdp49KBMxFu0D3UgqRtlZLkOL3CuYbLWuJefT5FRjImNqNYxayP2AtV2RrJz4Ln2wtild6JUK64cs2wz5xcIL5B6n1k9c9Nw0LgMENA/7bIO3wUsc9cfzqrRxYtAn2YSem4UKWzpk1C05xwDIG7gZVhr/eksWQp6JINEykc2t1Dh243FIuHym213uyZuixoh2nQWyhwJJ+yv2dQDTSX/d9Nk38Ikz+lkJj9Zah9Ynx9KjBmfCFFZ3EVqs58ByzqEmpyDgIxBt+8O9Lli8Z4EY0bL7MUBsF7KtW21hv91DZjIl/DYrj6SN4LlPTxb6963CPiX8Lk9p4RJZKasht4xUJ4B1qTL1+yprFC5x9XpPfEpJ41j08clAoBthzMbCJfQmkG37sWw925+ILBohrX8TNwhf6KSdSEEuSaCoEfUdBJB5OZeXdl2V5DYJI7+ABOwPCD5Yrm7hKG50L66Y4E50qpB6zr0NVOPl9/XSuxp7WLbM3SrogDB4lYNLJ9HjYIqCIlw/R/3Y554atsPYFFGviMaqsLKX+1889XzPW4fsbzXyw+xYQ8S7CR67friAbwLGe4LXujq/o26DgnYM3IwH7y0OqXW/zSB/dqo9WFCXOmNzZL550L5nJNjdrlvmRKr4jc8RYc+viMxBOdrSOhBZgZpZMNWfIBePlXeHqT17ZbK6ehJLGK/0wVfl7303wUHyyFanlCNaKq7sLE14GP9Zu7K
 9gj3fIlA
 guW81TiCVqOIKGDWL7LGUcPzwcND2/5Dtt6AD2TWTxly7KLW3j4RojZUAqq/TUlau4ittoIfQfUqCTQnRpjVlgvXCYdWtKeN8Qz3fQ2HBUcqeMbzSaq4LWS3Wa15yyjf6Foox1x5MM7f9nbIuHG9zAe0lC8TqLlxMrqUMIdTAfiE7xMszf67+/Abb5cIZJ9jSttt8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi, Sarthak
在 2026/8/14 14:30, Sarthak Sharma 写道:
> Hi Song Hu!
> 
> On 8/12/26 5:38 PM, Song Hu wrote:
>> mremap_test calls ksft_set_plan() without ksft_print_header(), and its
>> get_mmap_min_addr() skip path uses a bare exit(KSFT_SKIP) that prints no
>> TAP line, so its output is not valid KTAP.  Add the header and switch the
>> skip to ksft_exit_skip().
>>
>> Signed-off-by: Song Hu <husong@kylinos.cn>
>> ---
> 
> While running the test, I saw that still some diagnostic lines are being
> printed without being prefixed with a #. This is because of some prints
> in the code of the format:
> 
> ksft_*("...\n\t...")
> 
> which is causing the part after the \n to not be prefixed with a #. If
> you are planning for a respin, maybe you can include this in the same
> patch so that the whole output becomes KTAP compliant :).
> 
Thanks for your review!
Will fix those three call sites in v2.
The fclose()/errno one will also be addressed in v2.
> Rest of your changes look good. Once Sashiko's point on this patch has
> been addressed, feel free to add
> > Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Sure.

Thanks,
Song

