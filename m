Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAA6CC44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 10:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6140A6B007B; Wed, 22 Jul 2026 06:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4AD6B0088; Wed, 22 Jul 2026 06:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DA706B008A; Wed, 22 Jul 2026 06:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4E96B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:37:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E2E380125
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:37:43 +0000 (UTC)
X-FDA: 85016061606.06.5921B8D
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8B7C220005
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:37:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of chengfenglin@stu.xmu.edu.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=chengfenglin@stu.xmu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784716661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OpLSq6kMn+7e8Y64iijG0Abs08qWe44S0vppPIbTksI=;
	b=GSnI0FHVGhu98dxlAWndpaDmzj8zKgWEOXh0ES4NrF6bu8R45oY17ae9owlRSGKKnZh30v
	NjT2ReGk80od+pPhPLvPafHIe3OXpkyPTQyi59qvUt4ibhYQcs+LGoABFc7oTpXq9Ig6KQ
	4CFDjJ5+f6AtUlGYgeAVHRqt8HFAON4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of chengfenglin@stu.xmu.edu.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=chengfenglin@stu.xmu.edu.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784716661;
	b=hSuvCHwbJeadfzagJOJ9/mUDrQeZFn3uo8a+daOvHtXKCnohJUeYxi98XWw7QLnEyio4e8
	kZ0Fb3cy6EhJ0Ql5NtvxDnECQzSl+u1NevfLczY/mFES6+ksw5cCSG1Hij2xodKPRoG9sc
	9BJfbNzIJ1zyhGGPCmMqBBuCq+yMSw4=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-7 (Coremail) with UTF8SMTP id AQAAfwC3vFBrnWBq6+pIAQ--.2743S2;
	Wed, 22 Jul 2026 18:37:31 +0800 (CST)
Received: from chengfenglin$stu.xmu.edu.cn ( [23.249.17.30] ) by
 ajax-webmail-mail (Coremail) ; Wed, 22 Jul 2026 18:37:30 +0800 (GMT+08:00)
X-Originating-IP: [23.249.17.30]
Date: Wed, 22 Jul 2026 18:37:30 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Chengfeng Lin" <chengfenglin@stu.xmu.edu.cn>
To: "Dev Jain" <dev.jain@arm.com>
Cc: "Pedro Falcato" <pfalcato@suse.de>,
	"Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
	"Liam R. Howlett" <liam@infradead.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Jann Horn" <jannh@google.com>, linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] mm/mprotect: shared-dirty base-page toggle slower
 since v6.17
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2025.3-cmXT6 build
 20260202(ad063891) Copyright (c) 2002-2026 www.mailtech.cn OP_ICM_ICMVM
In-Reply-To: <dc402537-1527-4433-839e-960b6eb32bc4@arm.com>
References: <7c9eeb21.1c04f.19efaacbb2f.Coremail.chengfenglin@stu.xmu.edu.cn>
 <433d619a.1e8a6.19f1d4d1be6.Coremail.chengfenglin@stu.xmu.edu.cn>
 <6c8d9b6c.24a8b.19f84afccdd.Coremail.chengfenglin@stu.xmu.edu.cn>
 <dc402537-1527-4433-839e-960b6eb32bc4@arm.com>
X-CM-CTRLMSGS: =?B?WG2ENDiH6nJ5xwDR7hwMki1N8jM=
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4dceab6f.24e3b.19f8966e8ed.Coremail.chengfenglin@stu.xmu.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:AQAAfwAXMvNqnWBqIlPHAA--.15404W
X-CM-SenderInfo: astqjiysvrikiuszmqhvwxh5lpxovvfxof0/1tbiAQAQEGpf17YCF
	wACsC
X-Coremail-Antispam: 1Uk129KBjvJXoW7KFW7KFyxuw45Zr1UCr47CFg_yoW8ZFW8pF
	W3K3WSkr4DGwn7tasFya18CF4rGws7X3yqqr98KrWUZw45GF9FyFySyr40gw4xCrnYgw1I
	vr4Dtw4DJF4DZaDanT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Rspamd-Queue-Id: 8B7C220005
X-Rspam-User: 
X-Stat-Signature: 1i9cghw6ztf3kj16mo57bc9gkhodw398
X-Rspamd-Server: rspam04
X-HE-Tag: 1784716659-81482
X-HE-Meta: U2FsdGVkX1+vuB+BhucajUB7PgWamnOvugfQdzbrHAxKox310peTqRtpDDxCQlk2hjoPM0x86hEjkZnB9xCPf9NBSawhvMGOptKeXkmuIY6wGuLxxP04FKs46WlIqp3MzglMOL7/BKCs4BSZCn0cewT5EDz31/ySdBon0W0AYBYctRafwepEQ2qORcWNGuL7r+d56DyvIiikUmnxhc1SlLv492CvhN3TWEclsbRPp9J21i/wHk1kkp08Txu7PhfbkxTvfyU1RH7XdF30IvV7AV2gpESU3Yn+knjtxFJc4UhSebBqU/0y79cZCfXgsQBiC9zJ8Achx7w28pzg5sD0UuHGjX08F3mW30z6vAuNOe0yW2E21Y5hLQpwl/3YdHlMD+qHKsIjx7XC8kkhsQ49g1Y6iXK3q0HkxZjTxcBmUexJJ5C/Nk79t13yvJNKnTTBLXTzRzgcAIGyzXe8xT2odE7A9/g/rB+ZkPm5DxrmaTAS5ca5lRUj2nisRRV4ct94lm36fCXuCmEXJ27hJuQdiZUadcKIsmy2RzevZrRydzDI7A7wWY+jTWHnwi2PlnBn15Kvhti9qHSLOOPXAyV2wnWLRlxcwpr5+SRYg5WAM1Qieox51z7xV+Vds+ttwVoi+c6qkaFSpFCfRWrZ0547xxO41EGe4gJ3az4Adjx9Rn7hQzab/xkjQ3QKVE6e1+cD7wIlirkRe10Xc7g43yTexmKlV61PFe+nYpGmluGCVnopdHUw6tT+kew+sdY1AYU+AODWtVRhbQTdr67tSImVWtwyEFHtuDj2mnnnMOKU4E1Pn/ucwFtnZgjcqn+XbPHGM9SGUFoeKtAJNbLnKu0Bb/4B+oRfhIdl0SQXqFcwR6JDpTcz2+AEV1R7K0d4LCjHSsFhdJXMR+Ulgu3WTluowwAuG2b6XLJxkqxQca1XaX8ECxSEXWiCFe6rx9v8xk1AAZdS38T2A3UEBEcJuhp
 nJaaV81I
 XcY6KmDeDqHgPDStEAyUtu1pd3oa/LNiXFuOTYjyI5vQI5nLlSa49M8x4nvkYpdatprktm0wz8M2+tW+NTAboXUEJ+Bn+n0f0D+4PCDw45e4Bfzas+EsMtRasuzkY3SuLdH5zJnCAd5ADDL/IPKfP5A5ZJ3BVAUc6oWzZ1kRfpXzHBkUzM/ZrETYmUKliwZONo0LAyiImVWMaCVzF4XZkLMiKXb+hZJniSXx/3qgE7XMaWkYWhgzfhXHkQBkh5B+Cui1bMngMj9ybZdKJ8LNBDqy58DgA6DHzUgnoB+BlUTSxQ4xJoNN91q6Zpid3eXEdJotp3L7jCRLD6SQIp2JLQhNIhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGksCgpTb3JyeSB0aGF0IG15IGVhcmxpZXIgbWVzc2FnZSB3YXMgZGlmZmljdWx0IHRvIGZvbGxv
dy4KClRoZSBwcmV2aW91cyBleGFjdCBwYXJlbnQvY2hpbGQgdGVzdCBzaG93ZWQgdGhhdCBjYWMx
ZGI4YzNhYWQgc2xvd2VkIHRoaXMKd29ya2xvYWQgYnkgMzkuNzclLiBUbyBhbnN3ZXIgeW91ciBx
dWVzdGlvbiBkaXJlY3RseTogbm8uIEluIGEgc2VwYXJhdGUKbWF0Y2hlZCB2Ny4xLjMgcGF0Y2gt
b24vcGF0Y2gtb2ZmIHRlc3QsIFBlZHJvJ3MgZnVsbCB2MyBzZXJpZXMgd2FzIDYuMjAlCnNsb3dl
ciB0aGFuIHRoZSBuby12MyBjb250cm9scywgc28gaXQgZGlkIG5vdCByZWR1Y2UgdGhlIHNsb3dk
b3duIGluIHRoaXMKd29ya2xvYWQuCgpJIGFsc28gY2hlY2tlZCBmb3IgYW4gdXBkYXRlLiBUaGUg
bGF0ZXN0IHB1YmxpYyByZXZpc2lvbiBJIGZvdW5kIGlzIHN0aWxsIHYzLAphbmQgaXQgaXMgYWxy
ZWFkeSBpbmNsdWRlZCBpbiBMaW51eCB2Ny4xLjMuCgpUbyBpc29sYXRlIHRoZSBzZXJpZXMsIEkg
dXNlZCB0aGUgc2FtZSB2Ny4xLjMgc291cmNlIGZvciBib3RoIGtlcm5lbHMuIFRoZQpuby12MyBr
ZXJuZWwgcmVwbGFjZXMgb25seSBtbS9tcHJvdGVjdC5jIHdpdGggdGhlIGV4YWN0IHByZS1zZXJp
ZXMgZmlsZSBhdAoxOTk5OWU0NzljMmEuIFRoZSBmdWxsLXYzIGtlcm5lbCBpcyB1bm1vZGlmaWVk
IHY3LjEuMyBhbmQgbWF0Y2hlcyB0aGUgc2VyaWVzCnRpcCBhdCA4OWU2MTNiYzBiMmQuIFRoZSBu
b3JtYWxpemVkIGNvbmZpZ3MgYW5kIGFsbCBvdGhlciBidWlsZCBjb25kaXRpb25zCndlcmUgdGhl
IHNhbWUuCgpJIHVzZWQgYSBmcmVzaCBib290IGZvciBldmVyeSBwb2ludDoKCiAgcG9pbnQgICAg
ICAgbWVhbiBucy9wYWdlCiAgbm8tdjMgQSAgICAgICAgICA1NS4zMzMKICBmdWxsIHYzICAgICAg
ICAgIDU4LjIwMAogIG5vLXYzIEIgICAgICAgICAgNTQuMjY3CgpUaGUgbm8tdjMgbWlkcG9pbnQg
d2FzIDU0LjgwMCBucy9wYWdlLiBGdWxsIHYzIHdhcyA2LjIwJSBzbG93ZXIgdGhhbiB0aGF0Cm1p
ZHBvaW50LiBUaGUgdHdvIGNvbnRyb2xzIGRyaWZ0ZWQgYnkgLTEuOTMlLiBEcm9wcGluZyB0aGUg
Zmlyc3QgbWVhc3VyZWQgcnVuCmZyb20gZXZlcnkgcG9pbnQgbGVmdCB0aGUgdjMgZGVsdGEgYXQg
KzYuMTglLgoKVGhpcyB3YXMgdGhlIHNhbWUgbmFycm93IHN0YW5kYWxvbmUgd29ya2xvYWQ6IGEg
NjQgTWlCIHNoYXJlZCBhbm9ueW1vdXMKbWFwcGluZywgZGlydHkgNCBLaUIgcGFnZXMsIGFuZCBy
ZXBlYXRlZCBmdWxsLXJhbmdlIHJlYWQtb25seSwgcmVzdG9yZSwgYW5kCndyaXRlLXRvdWNoIGN5
Y2xlcy4gRWFjaCBwb2ludCBoYWQgMyB3YXJtLXVwIHByb2Nlc3NlcyBhbmQgMTUgbWVhc3VyZWQK
cHJvY2Vzc2VzOyBlYWNoIG1lYXN1cmVkIHByb2Nlc3MgcmFuIDEsMDAwIGN5Y2xlcy4gVGhlIGJl
bmNobWFyayB3YXMgcGlubmVkIHRvCm9uZSBQLWNvcmUgd2l0aCBUdXJibyBkaXNhYmxlZCBhbmQg
cHJlZW1wdD1ub25lLgoKQWxsIDQ1IG1lYXN1cmVkIHByb2Nlc3NlcyBwYXNzZWQgdGhlIHJldHVy
bmVkLXZhbHVlIGNoZWNrcyBhbmQgc3RheWVkIG9uIDQgS2lCCnBhZ2VzIHdpdGggbm8gVEhQLiBU
aGUgcHJvdGVjdCBhbmQgcmVzdG9yZSBwaGFzZXMgd2VyZSBlYWNoIGFib3V0IDIzIG5zL3BhZ2UK
d2l0aCB2MyBhbmQgMjEgbnMvcGFnZSB3aXRob3V0IHYzLiBUaGUgbGF0ZXIgd3JpdGUtdG91Y2gg
cGhhc2Ugd2FzIHVuY2hhbmdlZC4KClNvLCBmb3IgdGhpcyBzcGVjaWZpYyBtaWNyb2JlbmNobWFy
ayBvbiB0aGlzIG1hY2hpbmUsIFBlZHJvIHYzIGRpZCBub3QgcmVkdWNlCnRoZSBzbG93ZG93bi4g
SXQgcHJvZHVjZWQgYSBzbWFsbCBzbG93ZG93biBpbnN0ZWFkLiBJIGFtIG5vdCBtYWtpbmcgYSBj
bGFpbQphYm91dCBvdGhlciBtcHJvdGVjdCBwYXR0ZXJucyBvciBhcHBsaWNhdGlvbi1sZXZlbCBw
ZXJmb3JtYW5jZS4gTXkgZWFybGllcgpRRU1VIHJlc3VsdCB0aGF0IHN1Z2dlc3RlZCBhIHBhcnRp
YWwgaW1wcm92ZW1lbnQgc2hvdWxkIG5vdCBiZSB1c2VkLgoKVGhhbmtzLApDaGVuZ2ZlbmcKCg==


