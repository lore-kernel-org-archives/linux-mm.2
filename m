Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D3FF54ACF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58E996B008A; Tue, 24 Mar 2026 11:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F646B0092; Tue, 24 Mar 2026 11:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455696B0093; Tue, 24 Mar 2026 11:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 35C876B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:24:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CFDEEC0E36
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:24:03 +0000 (UTC)
X-FDA: 84581327166.29.719F8FA
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf26.hostedemail.com (Postfix) with ESMTP id 95DD7140010
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:24:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=KolOZT9B;
	spf=pass (imf26.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=KolOZT9B;
	spf=pass (imf26.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774365842; a=rsa-sha256;
	cv=pass;
	b=bdu8xjD+jh9rfiKOqdsjnEbfUShWGRrVChfiivn6J513qUnCqHd3Ygpvxld3TqBpP8+MVu
	XxMaPrQL9j4DcMxI9c6mflZbPWZQQ0BMLEHSDbs6rCn3843w62z1AJtUV2QAtlgsZEH2QN
	mO/o+3/yNfBssax22jJ30ksxqsM/+cE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774365842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rQNo5gRq0ttu6AMLBxnpSMS80bStRyQxiFciq1sROUE=;
	b=44GEsNFgfDgfsWni7BBD1LKd8ekvXMUZD43PQYxdgIKTp+42dRbRhbt0ltoBb/Hq8bRTM0
	/qW/1PzyBoRTNZaRFKpIcSbcJGYdai1/cQyQ6QD5kidQdZUIF/rLC9o4IR+KlYkG85nmot
	mCTjDMK9nJyXFmHzqHV/ymUUrIgoXZ4=
ARC-Seal: i=1; a=rsa-sha256; t=1774365816; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=LXnBElSlmUVOrfZCAPwDY2tQIouurVoPwZUIhJLFLvx2B3n/wAomA5p66z4W5YhRuPPZVlHz1b2xm8/BylsHNnbizEmjsXmqTJQZ77bZhjqQVxk1McAwqWbcmcbQOKhZKVw7V1Qynpczh5krRlc2nHn6CTwSn2cMy7BFusVznAI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774365816; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=rQNo5gRq0ttu6AMLBxnpSMS80bStRyQxiFciq1sROUE=; 
	b=TfZLL0eSC2/ECusdMMCaLHdOD4bcdbxvqD6XIXLloSN3zp9hBkOKTMHLbqRoP4eiOXzk6rTNnIbp8Fe5pvZx2zVZopGgDzXfVHw4c8Z4rQFKKJ5/kJ3nbvMd+JNYQHhNZ/pUbcgh4zICHdG38UszPTyT2bnBFOVYu6TuhJRFaug=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774365816;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=rQNo5gRq0ttu6AMLBxnpSMS80bStRyQxiFciq1sROUE=;
	b=KolOZT9BTJENIDtAt4aXF1Erxgz3JzZtMBddJDw2jJpN1qq+rA0c4ZZOb8pDyW03
	H5pUyxGV/5kEJHj0/pqe/E3bASlrrql7JRLOLl5J+3UPGNoel2NchA5WH9yUKPdNffU
	Jvtex75qYDkDYeqmV78FOhvrIGNnBQRrZRjh0yfc=
Received: by mx.zoho.eu with SMTPS id 1774365814980617.8320820549221;
	Tue, 24 Mar 2026 16:23:34 +0100 (CET)
Date: Tue, 24 Mar 2026 15:23:32 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: Markus Elfring <Markus.Elfring@web.de>, damon@lists.linux.dev,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5Bv3_1/3=5D_mm/damon/sysfs=3A_fix_param=5Fctx?=
 =?US-ASCII?Q?_leak_on_damon=5Fsysfs=5Fnew=5Ftest=5Fctx=28=29_failure?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260324141537.91434-1-sj@kernel.org>
References:  <20260324141537.91434-1-sj@kernel.org>
Message-ID: <7C2341EE-3CBE-42E4-8D2F-341137CC6234@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 95DD7140010
X-Stat-Signature: pjft65aabqzer4yw1fmm485nojbw8m6s
X-Rspam-User: 
X-HE-Tag: 1774365841-464457
X-HE-Meta: U2FsdGVkX1/oQzvUt/8MTem2vdKdBUt5PyeUxfSA3PmkW9mKAKdWf1qprsNa0g9QWy4n9pxy/zwDOu8IGd1Af6ImDHeoV5bWdZkdVTH+nwDFv11/xF8JBisr0EKyFESf91zMy3lvEacQKkvXUxPm+bKH4NJWsXeEwqTG+hCQpZQnrGslGRzqd36W7X6aW00desuDmgMgGlQ6TeYxgT8NflqyOgWCcZGZrq58UNmqD57o/uZ/4GlV78VGTrAtcdK8iOYAUdS07z9vxphf2QRVBd79QfOk24n9azRQtY1sT185KxjsV/KZ82wTwGT9A/s7HD2k9+ut2i3X9ZTh4LtrcrxpAg8mQUCRwNW0hgzHw8GOJ0bp5h5766ALPR/BAqyUDgbm+HRFmqAebJPcPCzO3bu29WoaGy7htncZ5RWLOwanwkcpZAtyUbpoTYgywzH46m2hWG3iafjahTRj+XTbK1SIXUCaA8rDmAct/XVXr1j/zge67g8KpEAMnHl7F39/9usykobE8T9OIwczM0m38E6di7X/Loq7QBHu0sYLpHgGa4QG+UWWD8U8iinwgECkHy5uTnaqLl7js8IRiy8snyAbMaMMwRNeppGUn5Rtsc5mlkztJo0A1Z36V6UBx2MvlgXh43P3Rae51CI3m+bztjcA9Gv0Wxu1c7t76pJQjUzzpWjS6FzImPrxCJ34j2V5bUs+SjhYdxyUqJMiYQ4BX9DjVlqvmXPWbrOI5tIZbWAMCrxaM93mEzABIWJZQTD2e9PAQpZZPdpyWzhOURhVR2foOT8hqALD30fG4+HrjCjCN3lez0IkbWVx8MPuUA7qGUWheNXIVy8+lNiXZREIuc9R0EeoiQ2GG2fRCJrbDIgU5vVd26Vasb/M0nZxAgk8cI1qHcI4yTjzfjw0DIeT5O5ouG3m/rAK5i+cgsqS+QBVCm0AXteduz1VYRxhquPkP4P812n+xxS7zsDVqa7
 tYstLUWs
 nM7o6sNdLRiFppZHe5I85AqoPdOHwbeMqth6TIGTPxlhsjUf4QUaVFZxLQUjS/4qWNkEEVy2u8KNkFl1yIB7F8C/P3Vi+2gdlrFcCXvfRdp489mxVF88dGYQaXy5H4CIeMt1UP2pn1FAa9BUOdbLl7f32zCd0TYkl1rNhroGzdEguIB7HU5ETNoXcMktj+l/CmUwQ3P6aFUfOADrl52Z0uwpCGLvscqdwwdVGwxF+/C9TkJPBTq+s4LLBCr/Fa+os3ZdaQVkFCFLxvZ3uQL6Xll0PjvzRd2xNGLE9jk4JHfELE1aH7BE/8QGlkp7DLLsb30q1NWPaKENG7ndJ8QoQxPp41PtvAxMMoOzQCWuTvnbTJ9tXY+KSpSnS2DARGYHpDJEi/5UX7F7Y7mUBkWihvHStZpt9iuxsldutd4PfP7pQn2dkhDyxXbyNvk70iMPjIkTzilSJxtWeGJKE7TR5pR/gAlgU2BHM40SaKNbWKtcERKPXj0dtfyfQO3hUHpshiiVaU0AEwTQCaUQbaRJ0/vpyvzl5h+vbRGHYUvT36dCaCPhxSzDj9b5Vn8UnzSCZOD6UtAhegMhJJR86gfmVdQN6xCcQ72DJ9jZiYfH9cSWAR/AUl619YytpqrHLDRqK8W1+AKmqzHBP9dEmPUHqpGCWSqsEpCZ4z1v32aUN7oBPZ4EvggqJA16eMkU7qup/dpBVYO1w0eGCGFVsrxXj/UZ5845VcmjIDg3NMLsSfNXni67boJjfz7iuZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24 March 2026 14:15:37 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>On Tue, 24 Mar 2026 07:06:25 +0000 Josh Law <objecting@objecting=2Eorg> w=
rote:
>
>>=20
>>=20
>> On 24 March 2026 00:14:59 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>> >On Mon, 23 Mar 2026 16:48:19 +0000 Josh Law <objecting@objecting=2Eorg=
> wrote:
>> >[=2E=2E=2E]
>> >> Also, unconnected to our topic!
>> >>=20
>> >>=20
>> >> I've tried to backport Damon to 4=2E19 (for a personal android thing=
, and failed! Of course)
>> >>=20
>> >> Can I have a bit of help if that's fine with you? The tree is based =
on GitHub a bit
>> >
>> >Sure, I will be happy to help as much as I can without burning myself =
;)
>> >
>> >Seems [1] Alma Linux has backported DAMON on their 4=2E18 kernel=2E  M=
aybe you can
>> >try their port first?
>> >
>> >Also, what is the oldest kernel that you have to use?  As newer it is,=
 the
>> >backporting will be easier=2E  When I was in AWS, I backported DAMON o=
f v6=2E7 on
>> >the v5=2E10 based Amazon Linux kernel, and the source is available on =
GitHub=2E  So
>> >if you can use 5=2E10 based kernel, using that could also be a good op=
tion=2E
>> >
>> >[1] https://oracle=2Egithub=2Eio/kconfigs/?config=3DUTS_RELEASE&config=
=3DDAMON
>> >
>> >
>> >Thanks,
>> >SJ
>> >
>> >[=2E=2E=2E]
>>=20
>>=20
>>=20
>> well android likes using old kernels for some reasons, especially LTS, =
so 4=2E19=2E=2E
>
>Well, but the long term support of 4=2E19 has dead a few years ago=2E  Th=
e oldest
>LTS kernel of today is 5=2E10 [1]=2E  I understand some vendors might sti=
ll use
>4=2E19 kernel, though=2E  Anyway, let me know if there is anything that I=
 can help=2E
>I will try to help=2E
>
>[1] https://www=2Ekernel=2Eorg/category/releases=2Ehtml
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]


The device itself is unsupported (Galaxy S20 FE)

I've been working on a kernel for this device for quite a long time=20

V/R

Josh Law

