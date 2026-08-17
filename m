Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20301C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286DD6B0812; Mon, 17 Aug 2026 09:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25ED56B0814; Mon, 17 Aug 2026 09:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175AE6B0815; Mon, 17 Aug 2026 09:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EAA1C6B0812
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:59:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F42A1206D2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:59:02 +0000 (UTC)
X-FDA: 85110917724.24.A2BB689
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2572820008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:58:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786975140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LDom/mBLisuznJwW3t+yEt5NXAw9HhuCxgKFwQok5NM=;
	b=jvmDeq/5yeyme+W85mv0Wh017VSXF0tcpj8iuEdiBvEINO4tvZ5IOkwNJLmcJ9XB9nJZ8/
	ZNyoIBzG7jF3zlr5A3C9Z/QoghyxviSspza1ezgqwraOuPUsvhJh2tgb/xw3rvxz+jzAbO
	Dh9mtIlAlEqA605Oxl7EHcrYe8R9qqA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786975140;
	b=r/bjebvZDvyM26FQISIee+H9iHl5mNNb8xxg3Lsx83QURYJplbAUeUEnm9+NnVq3vpN1j3
	Nrfx67ttyKr+lN4+yS/e8dObDP4XN2Gj6Zj/GNSSkAjs9E/wcifoxmhgnFTk5pNTy7xuJ4
	23Vwni49SkMeR2slp4J2ocgIBabEj2Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
X-UUID: c261060a9a4311f19a56ed5b684f684d-20260817
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_MAILER_MTBG
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:615dd124-44dd-40ac-983f-4f78e53b0429,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:8,RULE:Release_Ham,ACTION
	:release,TS:28
X-CID-INFO: VERSION:1.3.19,REQID:615dd124-44dd-40ac-983f-4f78e53b0429,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:8,RULE:Release_Ham,ACTION:r
	elease,TS:28
X-CID-META: VersionHash:7db8b62,CLOUDID:ec1081a26d84b2229a074b656afc1cbe,BulkI
	D:260817111225XMIBG1F7,BulkQuantity:10,SF:17|19|64|66|78|80|81|82|83|102|1
	27|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:40|20,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,B
	RR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_OBB,
	TF_CID_SPAM_FCD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c261060a9a4311f19a56ed5b684f684d-20260817
X-User: husong@kylinos.cn
Received: from [192.168.110.173] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1866070750; Mon, 17 Aug 2026 21:58:43 +0800
Message-ID: <eef3b61a-a8c2-4b2e-b560-c2dae129bb7a@kylinos.cn>
Date: Mon, 17 Aug 2026 21:58:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: husong@kylinos.cn, akpm@linux-foundation.org, audra@redhat.com,
 bingfangguo@tencent.com, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 zhuhui@kylinos.cn
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg
 offlining
To: Michal Hocko <mhocko@suse.com>
References: <aoLGzZHS8kj53-ey@tiehlicka>
 <20260817131221.44761-1-husong@kylinos.cn> <aoMMr6kEX7pW1dSF@tiehlicka>
From: Song Hu <husong@kylinos.cn>
In-Reply-To: <aoMMr6kEX7pW1dSF@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1384z79gikbcgaj7wyk4nycgar53jxkc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2572820008
X-HE-Tag: 1786975136-618574
X-HE-Meta: U2FsdGVkX19Hh+ykGhz0HnNaGwDocB7yGF5OBOagoCjOU7OM7uDkBKhX9dorz47C5uvtGoytKzWo9bKmnWtSMhdlmU5QBzgrUe/0yxvnmm4HqRh2bUN9mY8tqHJ82GyQuEIuT1dOnL2ZuZDx+F2m8Z1cpybE+udRjuA3KqyZ/tIYaranPkJXSTy90Sz7KhDXCSk3NAAQUanqxiH1+UTE+V8ehKmFVHikNHYK5orJtVpSJ+LFw2fIRDiQXBayYWfUEdM+B59R8ZtpxWB5j91AyDYPLvk5BAt2wUHlDVyzTD4hBysb96+GOBMwIsYt4CeyUg6dChyx38gMZP553+3mJBipnZ2UsPQwKO0+WFDa+4n4W7I7AOBtH8/kT4X0RCDtFNxQPCqwbRTioDWKCOAyunDdQ5KckL/AViIfYIBGsNN7NCl3/U8aSgbIcp9rWdLrfjLwvw4XnJx7ua3VZwIwAIH2ov/Haf8kdNxbsvwiYx3VzhZuGri1izIyYcCNDV0ArqPJRZ39p1vnHWvzQREt1UMRlZhW1I+ew/zBjEiMAskY4Fg1W8LxOy38Ot2C/Y7ByO3g5tYGktQ5ymIwgUefenIFh5d6k9FxdtUaNLgIqWzrMAUPQcp1PZo4Sp9HEGrAB38QwZMYAP+lllSbmyCiVh6AnM3QZaT9IJdqznXaQylrK1yuooCbpdstcmGg+LBJ0ykfbTzaMXkSIPOvTJJ1mc5SwcrKWWFzOxX7peBy8C9Yc/jUWUQEzn+PMA/IAGPWc2wLsu5O6flb1rmj4RwnAvGreEP+fIqT+y8c9nNdfS4SelD1zW82OB40tqEuUJe4CWyXIK5c1ZiMXhCxF9rDgG5M0Or93zaSiRjf8q0o9AVHxXWgGMG29Xg9tB69z0kqWEwgxtS5x5yMVgT6Nqwzj4xitrqZu+VnBEVqmZ063NuHUoprl1+siYDpL3cEGHqOavIOz7P4tRR+D8A9GqO
 wf7I+/i/
 EWx8x4aDKCEp449CcGQ0HPt4ud3BaRXLdXpawsQBUIlVY++vxnu8p33Xd4dYv//fxVCUabqLVc3oQim0d1N+wBOen5bF6JTdh3xpmflQhjTVU6812ZtbIB6Dj/JdTogZ6X40Q2bOVML4jW3aMpdZqJJi0sA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,Michal

在 2026/8/17 21:29, Michal Hocko 写道:
> On Mon 17-08-26 21:12:21, Song Hu wrote:
>> On Mon 17-08-26, Michal Hocko wrote:
>>> Is there any specific reason why the memcg stays in the cache slot
>>> without any pages?
>>
>> consume_stock() doesn't release the slot when nr_pages hits zero.  It
>> is kept for the next charge of the same task and only gets displaced
>> by a charge under a different memcg or by CPU hotplug.  The problem is
>> that the offlining drain skips empty slots, so the css reference they
>> hold is never dropped unless something unrelated displaces them.
> 
> This doesn't answer my question, really, does it? Is there any good
> reason for this implementation? Why do we need to drop references
> remotely when we can do so when the last cached charge is consumed?
> 

Fair enough.  There is no strong reason.  Keeping the slot
populated after the last page is consumed only saves a
css_get()/css_put() pair when the same memcg charges again on that
CPU - a micro-optimization from the original single-slot
implementation.

Dropping the reference in consume_stock() when the slot empties is
the better place.  Empty slots stop existing, so the offlining drain
has nothing left to miss and is_memcg_drain_needed() stays as it
is.  This also makes Joshua's concern about the full-stock drain go
away entirely.  The cost is one refcount pair per emptied slot, at
most once per MEMCG_CHARGE_BATCH pages.

Joshua, this supersedes the css_is_dying gating you suggested and
that I said I would do - with no empty slots left, the check would
never fire, and the kill_css_sync() ordering argument becomes moot
as well.  Since you are reworking this code, I'd appreciate a
sanity check on releasing from consume_stock().

If this direction works for you both, I'll rework the patch
accordingly.

Thanks,
Song


