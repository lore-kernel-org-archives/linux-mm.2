Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8592BC5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 06:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 630A06B0342; Sat, 15 Aug 2026 02:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608C26B0343; Sat, 15 Aug 2026 02:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E9D6B0344; Sat, 15 Aug 2026 02:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DBFB6B0342
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:40:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5AF31402E0
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:40:36 +0000 (UTC)
X-FDA: 85102555272.19.D5FFB67
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id 90F9180002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:40:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786776034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ZnsFaRHSmzVXpdeu7e3vy1wVMiZdIGmWyt/zmvNHYY=;
	b=dee+yzKpqs4gFMSm/oxB964hqaL4taF1yieh1Bb3OyUXO2xG3LjL/HjYo8IkQYRxvLQDTC
	sYlCPX5szaSEjzZc/SXNOH++uUXHb/woCwfAyVsl4ydBECYy4mmCsO7VAtTwUClioy4Hxr
	Qj+RdSM6WYUWh3LNHi2gcde/JJ6J3NA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786776034;
	b=TEwWVta3LWjnL7UTA0zV0eEBcpxxJiIyeOUydxaxaewjAgqQr56hg9sOL0zG5ovGui1IvN
	T+QnRe906p1N0yJ/TC7b2Gx110B2gF3lvd/yB/O9XL9FNKPoE7mWMP5fQ80yz9UXbG771v
	xlyBFGlbmXURuJsPJZTkZvN1g8sOBqo=
X-UUID: 30ae70e2987411f19a56ed5b684f684d-20260815
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_MAILER_MTBG
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP
	SRC_LOWREP, DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	UD_TRUSTED, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:76122ef1-ab17-477f-92db-8a6a8fcbd9b3,IP:10,
	URL:25,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:76122ef1-ab17-477f-92db-8a6a8fcbd9b3,IP:10,UR
	L:25,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:dc9560921fa6f1c4877ccd567b6f0021,BulkI
	D:260813045119U2ONEQQI,BulkQuantity:1,SF:17|19|64|66|78|80|81|82|83|102|12
	7|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:93|82|11|1,File:nil,
	RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DK
	P:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 30ae70e2987411f19a56ed5b684f684d-20260815
X-User: husong@kylinos.cn
Received: from [192.168.1.116] [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1604418485; Sat, 15 Aug 2026 14:40:22 +0800
Message-ID: <cc4f98e2-43c3-49f3-82c3-b38b52286cc4@kylinos.cn>
Date: Sat, 15 Aug 2026 14:40:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: husong@kylinos.cn, linux-mm@kvack.org, shuah@kernel.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, peterx@redhat.com,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] selftests/mm: TAP output and global-state fixes
To: Andrew Morton <akpm@linux-foundation.org>
References: <20260812120821.523860-1-husong@kylinos.cn>
 <20260812135106.7709da03e92e0e7f5d8d9a5e@linux-foundation.org>
From: Song Hu <husong@kylinos.cn>
In-Reply-To: <20260812135106.7709da03e92e0e7f5d8d9a5e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: owxkfsrkpd3g5kwe13bb6wuou3pdo5du
X-Rspamd-Queue-Id: 90F9180002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786776030-58399
X-HE-Meta: U2FsdGVkX18jbjWTG5dQ5bfglAshcnd+9LCt+Gb5LchcRhaMl7K0YEg27433S3OgfpkKC8TClecOaNW0Ie9C3OkL8ze1Y8z+Tn9WMfxZWFq04DAgy9KbjP/HKCx1VyNzSIDJon/sSxZspvZeR61RL9XBigtuv/wFxesPBkKQPPzsgLnsA+TWqACRulhd3A7XclZu2fLXarZDK0MjwKLOPNX4LbNZJ+EN3d34GhV+E3ciT6jBnVsru1PmdUhqQA2sDv6QeucycNVGUee71BSJ5OadQkpVJT0As221/aUXz1U+cNImV/OtnSFs5uz1X13Yk8AcFZcFViumzS5JPM6/HpHnp6DzZ9Qhzr+RLHjkT6vREnXIzqmBKbZzSWhNC+mNvxdY4AfTj8c1hUL9dAr+ueDhX0HlokFWO+ET4AthQa7uiK1JGW9Q/MSWxExk8zcjg2z3xnmI3Yb2oz94Y5AwUOrTViK28NceTAj34LtNisd0CnCPs2oLKoiNxVXdqzVYjYonObslckBVzzZmsSgEGKJe6KkkW+JjbiQxCWQzFf9kreW1+kiQ36sWfJdgkgPRIiiHs5IwEzSnPc+4wJlDo7qh3kib4UydS710a1ih2ONPoBe2kDgSWstwujVkhDLuT369/SIURCtiDym/0FTC0aExfNAvUB6LeZToBHrgjFcKYjpzfTFE/8HH0Nc1C23gDorFAL8w6ZhXSmJ6fNwtsA6qtOXlJ25/diJ7t2YtkXMrQI0k52z9KrPf2o9V3q8QIUaaBwta8j47TuXErT6WND4HYi2Dvu6HCG1vs7R4BoRxJV2rg6S3rIiXVm1oayAoS30r/B+ynaeiH/NiZ6jLrRXsr1Zmcfocu98VY/0bSwvQB7nsnG4ujPNW6KZpYD5YYTa6phCeX6L8SXO7d/EtvFQZwYCDXa6JCUob5T1rzBzZjg1Uy1scQhJxsISI8putBdtvtkulEOgDqFG06nA
 8xMyc2Ji
 TIBgnQJ1qMns4HPFvl3m28lm6O55ppaL2YNhd0dzrc08YcfTVu2hCNfHjjoJb1liSo4Yxv2JpjEhOspJCTc9DxeO8/77mgDVyIKRTC2tDVX6alhxnJayRMioEUQPwlDgNfB1nCV1f/7RIMqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Andrew

在 2026/8/13 04:51, Andrew Morton 写道:
> On Wed, 12 Aug 2026 20:08:18 +0800 Song Hu <husong@kylinos.cn> wrote:
> 
>> uffd-wp-mremap and mremap_test never print the TAP header (and mremap_test
>> skips with a bare exit(KSFT_SKIP) rather than a KTAP skip), so their output
>> is not valid KTAP; hugetlb-soft-offline toggles enable_soft_offline during
>> the run and leaves it disabled afterwards.
> 
> Thanks.  AI review found a couple of minor error-path issues, both of
> which look legitimate to me.
> 	https://sashiko.dev/#/patchset/20260812120821.523860-1-husong@kylinos.cn

Agreed, both will be fixed in v2:

- hugetlb-soft-offline: restore via atexit() so it also runs on
  ksft_exit_fail_msg() exits, and use read_num()/write_num() per Mike's
  comment.

- mremap_test: save errno before fclose() in get_mmap_min_addr().

Thanks,
Song


