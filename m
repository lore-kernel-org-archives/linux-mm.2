Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA53CA0EDC
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 10:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D8448E003E; Sun, 17 Aug 2025 06:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AFD18E0035; Sun, 17 Aug 2025 06:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ECE48E003E; Sun, 17 Aug 2025 06:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC8F8E0035
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 06:20:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4E2C59D81
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 10:20:45 +0000 (UTC)
X-FDA: 83785855650.26.1E0E075
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf26.hostedemail.com (Postfix) with ESMTP id B0C7414000A
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 10:20:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755426044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KkE76ZE5cDsrpP4EYTf91cmjWEdVYbpa5p6b4Z0FOb4=;
	b=2eE6ip4fKLb1UENo2jDlcslwfE9aUxtqVQxX10ka8pA0DpOrbSK+NvSUx/+ObWTBJf6fUf
	Q0yeqFLGL1rAtGaJfMUttl1FNanRy51qf/JKYusu+i2cmuBS7gsfGbfOuhMlbd5TFSgMsa
	oWxfE57NmlkjsRpYp1RLExOkoX6+PkE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755426044; a=rsa-sha256;
	cv=none;
	b=GWvDHjyTHLSLsL8Vdva/wnngbG43BVQHpKo2B710FMjljwNOEnv9shLeVApiRm1JV1dfPP
	jH8I44Wz/8xCXy/Vo0tSPY6wHxJnIfKvA16io6djEekJCFoL0FTRieNgdjs5N5pwWdflW9
	FsXtxDfmhVPR8MoQFeRgLrarwgtOf5k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
X-UUID: d0a0082a7b5311f0b29709d653e92f7d-20250817
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:686dcfc2-a478-4d8e-9e7f-90bd4e72deb2,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.1.45,REQID:686dcfc2-a478-4d8e-9e7f-90bd4e72deb2,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:6493067,CLOUDID:46a523637ac374c5b6c75a7463417c09,BulkI
	D:25081600591436S1C0WD,BulkQuantity:1,Recheck:0,SF:17|19|23|43|64|66|74|78
	|80|81|82|83|102|841,TC:nil,Content:0|50,EDM:-3,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,B
	RR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-UUID: d0a0082a7b5311f0b29709d653e92f7d-20250817
X-User: lienze@kylinos.cn
Received: from suse [(111.193.138.233)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1885358352; Sun, 17 Aug 2025 18:20:36 +0800
From: Enze Li <lienze@kylinos.cn>
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org,  damon@lists.linux.dev,  linux-mm@kvack.org,
  enze.li@gmx.com
Subject: Re: [PATCH v2] mm/damon/Kconfig: make DAMON_STAT_ENABLED_DEFAULT
 depend on DAMON_STAT
In-Reply-To: <20250815165903.13330-1-sj@kernel.org> (SeongJae Park's message
	of "Fri, 15 Aug 2025 09:59:03 -0700")
References: <20250815165903.13330-1-sj@kernel.org>
Date: Sun, 17 Aug 2025 18:20:31 +0800
Message-ID: <bjoel05s.fsf@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B0C7414000A
X-Stat-Signature: badjy6hgsgcki3pid5xs5jkf8wb73xcb
X-Rspam-User: 
X-HE-Tag: 1755426042-931525
X-HE-Meta: U2FsdGVkX18AbeUvrk9I1vVMRsAk2WLETeMSXrCWqJ2kNShaWptdHVX2lVNIVnlLyua4YK3j9YiN2my4Iam/8RRiQCXGPcgt7+8FufA6n2ZZmk6cMYqmFOZN8lUbQwgs8ULmutQoFB9zFCTyCDvZr64YGaNZVh55wz4PMPnZhlItJBgac7uasC4L8n0XI++y/hZB77QLH/PO+gST+YvxCHn0yzlzv0rBij5ZgvFxmHwJxD9tc8IGHyzrN0c5u48uPuA/JufmWYDp576GGkV09uRlXJvT4MF72TVYTe7SbB9ldmnSXng3phIVNGo3hQJ9k0Ss9lKP+mBATRmsFfR+gCSvJ2VMAAc/EulGag2zHpqPoJOfUzAFnU1gEAbHh5XlTEytwHMz3vYGdINtWzYWEw1tFptQ8hOlXNtvTwNZlrxwR+FQAk1ReiNhgbX8SjyYiclnUpo9aBSRh7HTsVPUt9+y5VTR3at02E2yDZ9CRIhO+k7HShHHjx+xYm3OQ0spBxucCbz7qL+d9AbGKXh1NSomQ/P9AXv8ZKd0mIJ2hNByuy7bOPKCK3IpgpVyPPScCZgs7dtv2DOavMTsC0LISymk0p1Pboh7K2tNoOd4mRKTFk2oDCXdX3zwHV0bBfWa7Hip6OIghC6ivf9hGIEBsnn7RMSZAQw2JEJC25X4KbNgTec+Ow8Ab0Sur2F2pEZImJWcPRWjYGekbOWtt0hhsGLV7GnbQa0l0SoYF+UGHGp0Gd12xiUDFTT69/ttduJWztRqlq1ZLl9dKWC0zAEkIWwVifeyMCVtIgmQOxqEUSX/n3craiSOv0VpCqEDik6Hoqwp509Wn/v8dv7jYqBICCivLhaFgGOj+wYQzWfGo5lKhohbLlUkru4QSyUwn4LHxhdYihAp4HabSR0IlQ/MuKEbS/CZvULymDUgQ/LFq0GkmqezINBu75fvGHTA5d0PHebi9O1iDLvHEhPQo8q
 rbETS8ah
 pGmaQAtpgtbpnH+frjKapTavq0ssyKkfPDiMQriPaoDfdXIE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Fri, Aug 15 2025 at 09:59:03 AM -0700, SeongJae Park wrote:

> On Fri, 15 Aug 2025 17:21:10 +0800 Enze Li <lienze@kylinos.cn> wrote:
>
>> The DAMON_STAT_ENABLED_DEFAULT option is strongly tied to DAMON_STAT
>> option -- enabling it alone is meaningless.  This patch makes
>> DAMON_STAT_ENABLED_DEFAULT depend on DAMON_STAT, ensuring functional
>
> s/depend/depends/ ?

I'm not well-versed in grammar, but using 'depends on' here feels a bit
weird to me.  After consulting grammar references, it seems to me that
I've found the answer.

In *Collins COBUILD English Grammar 4th* (Section 3.210, titled
transitive verbs with an infinitive without _to_), it says:

> A few verbs are followed by an object and an infinitive without to,
> not an -ing participle or a to-infinitive.  They are let, make, and
> have in the sense of cause to happen or experience.

It's somewhat like what we often call 'make the machine *work*'.  This
is my understanding.  If I misunderstood or missed something, please let
me know, I would be happy to submit v3 of the patch to fix the typo.

Best Regards,
Enze

[...]

