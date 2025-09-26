Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07FC3CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FEF78E0003; Thu, 25 Sep 2025 23:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981D38E0001; Thu, 25 Sep 2025 23:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8707E8E0003; Thu, 25 Sep 2025 23:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70D9D8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:23:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E20B593E2
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:23:46 +0000 (UTC)
X-FDA: 83929956852.29.6459178
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id D6CE4C0002
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:23:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758857024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rYb54i7PDbLbzLJM1tsU6GCn88ZGRyzgNsJLLMeal7c=;
	b=xeTYQqNpe5uAO19JR5XHXVtPRUKWwzHud7hlGOyNJbO5jhAGfrSe2bk4xjTnBiYqrP6yWv
	I2T9WWlKoroQl+s/Imm/ScMqkEP+TMfmI0uQ3fKCdFOrWfBuEYC2rp9AQ9Gb4F5IXDN1vV
	MGtxEQWX29SgTb3H5OqxBgnbzY7lh48=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758857024; a=rsa-sha256;
	cv=none;
	b=SLsw96IYEfGb3hI3I6P+/ULmbQDU/NkCezE9dK03WuoidWaP6NPXTkVjWs11XDKR9qcXa6
	8J5hRuplebtfQrPyuHtAL8cSUXSZoMAWRKiLE2ytyRlsn91vFRZLKseTeHZ3IQNJxbQmbx
	/nWuAXvNXWCfTIILGsylvbLk0wnPyT0=
X-UUID: 30690d089a8811f08b9f7d2eb6caa7cf-20250926
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:754cb34b-de39-45ed-9ab9-959c42735704,IP:10,
	URL:0,TC:0,Content:8,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:3
X-CID-INFO: VERSION:1.1.45,REQID:754cb34b-de39-45ed-9ab9-959c42735704,IP:10,UR
	L:0,TC:0,Content:8,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:3
X-CID-META: VersionHash:6493067,CLOUDID:6cab5c0d6cdc09a038d9058c7d077e22,BulkI
	D:2509222101471ZTQKNV7,BulkQuantity:1,Recheck:0,SF:17|19|24|44|64|66|78|80
	|81|82|83|102|841|850,TC:nil,Content:4|50,EDM:-3,IP:-2,URL:99|1,File:nil,R
	T:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP
	:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,TF_CID_SPAM_ULS,TF_CID_SPAM_SNR,
	TF_CID_SPAM_FAS
X-UUID: 30690d089a8811f08b9f7d2eb6caa7cf-20250926
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 546424312; Fri, 26 Sep 2025 11:23:36 +0800
From: Enze Li <lienze@kylinos.cn>
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org,  damon@lists.linux.dev,  linux-mm@kvack.org,
  enze.li@gmx.com
Subject: Re: [RFC PATCH 0/2] DAMON: add priority-based scheme application
 control
In-Reply-To: <20250922130132.59955-1-sj@kernel.org> (SeongJae Park's message
	of "Mon, 22 Sep 2025 06:01:32 -0700")
References: <20250922130132.59955-1-sj@kernel.org>
Date: Fri, 26 Sep 2025 11:23:33 +0800
Message-ID: <87bjmxvqve.fsf@>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D6CE4C0002
X-Stat-Signature: znsettosbkcbejxce3p4o6zgg5y9zm3m
X-HE-Tag: 1758857022-576837
X-HE-Meta: U2FsdGVkX18fBxqUmQ79Z/CXFBJgfEYFvlMajc6o702L2YIcOoXSOYTbUX2K9/gSRatMaxY6SPjo4bhLpGvNmhKJh9DSqqOgKu02XFJ4aniaokkKQcmaaR4m3DkzMyzlVzelQxBwy6r7CPP0/RhuT1pVbGk+UJ3EgrVOK4Vy1Dmbld3szE5I/kU4qJUImzixh/45nj/99uj0lCK4uByhNSMvfbrHT8Jgn5nuv1Y9pa4FlQ2tGVRIB1AimITSqlAo3wQfgdcTCinbYRh0tnatPdN5rgzS7A8ZBpYDCGH3VTkeiQO/ZYdbULEh9yf6BlkSSgs3m2CFFmteQGF18I1j9ZbHAHU2RUC/9fK/HVAjhtfIptYx+HP3cO7d/sBmEwh4Ru4RSkluSd2Cn9BLBczZsHFGISHxZCA7ErUf6L3VqkZK9+uWPqZ1wSEuRVd13mshZqefgSpEsIe2fA3aTLwbg+zGRRspNVWLu8dCsMJWsfsVCfI7QzR41QKL+HLiELc/N03Y8PnbChFCZZ6AhcQYc3yhxlHMmZQ8HnKGK7fqiMghE9DMNwLqSSgJHvP4aV4+9dnxiHUYQW81ILenMQRraN6wQKcpR5Tlz4cq23Pig7Z/XcnUatKV1YRr3z0SwlmuwSNxV2UgwzZcKB+cfqupizJj7uBfrSf5hZzVs+vaJJAX1PUD6qQAT89OWp8tBpTM6aCYw7cd57tftRmRfy/Sk2RYZWI8N8tYx/A2CfnnVWNBJAc9aJLGAM+T7dWvy+XCtigW4PxpXZyQ4bV0f0ij7WhGr4YBj3B8dOp8JHoViAxWTKj//vfh5Ssk+oeiiIxPAZzphLOWSr5kud0q+dgg9OE+WQWVLuS8RX6OTKuFJRghvE+js4TMlfu1gsNMgYbVANXtkyZuWmqUO5cHv/oT1jINIPsmTqjt9SKLocx/LBRj1yDuk6b3rXf/dfUcIq1Le+tDXljinqBFt7l6U9h
 QHoQQ7K2
 nDnHFV2bLUhvTa49dLyOuvFrSA24wF34k7MCRUWLZQ2qEfoQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello SJ,

On Mon, Sep 22 2025 at 06:01:32 AM -0700, SeongJae Park wrote:

> Hello Enze,
>
> On Mon, 22 Sep 2025 18:10:20 +0800 Enze Li <lienze@kylinos.cn> wrote:
>
>> This patchset introduces a priority mechanism for DAMON's scheme
>> application, allowing users to specify the relative importance of
>> monitored processes.  The changes ensure that higher-priority targets
>> receive more frequent memory management operations while maintaining
>> fairness across all monitored processes.
>
> Thank you for this patchset.
>
> There are features for monitoring target-based DAMOS filtering
> (DAMOS_FILTER_TYPE_TARGET) and per-scheme applying time interval
> (apply_interval_us).  Couldn't those be used for your purpose?
>

Sorry for the delay.  I've been testing it for the past few days.

The combination of schemes and filters does indeed emulate a
priority-like mechanism quite effectively.  This is a fantastic feature!
It's exactly what I needed for managing my workload's priorities.

>> 
>> The first patch modifies kdamond_apply_schemes to implement
>> priority-based scheduling, where targets are processed in proportion to
>> their assigned priority values.  For example, a target with priority 50
>> will be serviced 50 times for every 30 times a target with priority 30
>> is processed.
>> 
>> The second patch adds a sysfs interface (priority under each target's
>> directory) to dynamically configure these priorities at runtime. This
>> enables fine-grained control over DAMON's behavior, making it more
>> adaptable to performance-sensitive workloads.
>> 
>> Together, these changes provide better flexibility for users who need
>> differentiated memory management policies across different processes
>> while maintaining backward compatibility with existing setups.
>> 
>> You may want to verify this feature using the following testing
>> procedure:
>> 
>>  # git clone -b v2 https://github.com/lienze/damo.git
>>  # cd damo
>>  # ./damo start --target_pid $(pidof <target1>) --priority 50 \
>>  --target_pid $(pidof <target2>) --priority 30 --damos_action \
>>  pageout --damos_age 5s 5s
>
> So I'm wondering a command like below could be used instead.
>
> $ sudo ./damo args damon \
> 	--target_pid 123 \
> 		--damos_action pageout --damos_age 5s 5s \
> 		--damos_filter allow target 0 --damos_apply_interval 3s \
> 	--target_pid 456 \
> 		--damos_action pageout --damos_age 5s 5s \
> 		--damos_filter allow target 1 --damos_apply_interval 5s \
> 	--damos_nr_filters 1 1
>
>

I've been wondering, though -- for users seeking a simpler interface,
could we allow them to define a basic priority value and let the kernel
handle the resource distribution automatically?  This would require the
DAMON system to intelligently translate a user-defined priority value
into appropriate internal operations based on current system resources.
WDYT?

Best Regards,
Enze

<...>

