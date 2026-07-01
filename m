Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42361C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BA326B00A6; Wed,  1 Jul 2026 04:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36AFA6B00A8; Wed,  1 Jul 2026 04:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281736B00A9; Wed,  1 Jul 2026 04:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1CDE6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:14:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 51FF48CCC5
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:14:45 +0000 (UTC)
X-FDA: 84939496530.16.3EACB96
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf22.hostedemail.com (Postfix) with ESMTP id 14427C000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:14:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026062701 header.b=WwYb6t3M;
	spf=pass (imf22.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782893683;
	b=PfS+tO8q8yQOi80WAxem9SwzwQ1lcBOndJ2aQ+dMzBNNRL1qSV4NYOWH4NpdQvc2D5MbTt
	5pdVz0YicCh8W1kzUDzDpLqyQl79CbgIMMmxSdG3LirRODr/jLDqydyYF8ws7qZve6cO6S
	mjIUneO+WYjd2Rkt05WZw9TtxK8pgp8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782893683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svsw8bf09g8hVr5lTGfzTsOW2DVBVtdsm1cgrew8gy0=;
	b=JMevWAKV+8HqFEPeDZ/YSHpC18NrnPllEhbmJradt49jKgE4/1Bah/RpsUPpSJO47R72/I
	a6hnLRU+07wN+gd2cTG2Kr4dpAkqUsVHf4pxptARFFuBnoGEbpTFGIKVukbFDrRodcqup1
	2xpJZqRSBLOL2RT3P0egWYRYvy4iT5k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026062701 header.b=WwYb6t3M;
	spf=pass (imf22.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6617wJqg986666
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 1 Jul 2026 00:58:19 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6617wJqg986666
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026062701; t=1782892700;
	bh=svsw8bf09g8hVr5lTGfzTsOW2DVBVtdsm1cgrew8gy0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=WwYb6t3MOkJNASrSHK3PxMbAVLdL9nZ+N2HEetPR//ORAluvuOcgDHW0bq049woTd
	 PYwLvJZ9tEekKWQKgKe11KyOI/RTT0I6fOyzEa7T3nP7p616hJM8BpBlKrVhBryGOs
	 Y/AUVdrqJLlB0LdVD8tqhHXzp/7Go6Ha7etS+gpZmy6IsRx6/1gSjcqYwRTwFo9kj5
	 eJ4ABsfjsZbiFnaLj1lY/1gk5Kcy7ED/k7Ml6p9R6NBRKXt17lcDdODcQhbe7uwtz2
	 AWZxnXx1hr+7xuzrBdmOSvXET0xwgMnvk4ootLHSsvX5sJO36PDnQtHORLCqezF3tP
	 Bn5IqhCHAYzrA==
Date: Wed, 01 Jul 2026 00:58:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@intel.com>
CC: Xiang Mei <xmei5@asu.edu>, Kees Cook <kees@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-hardening@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>,
        Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>,
        Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>,
        Yan Shoshitaishvili <yans@asu.edu>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2=5D_mm/vmalloc=3A_widen_guard_?=
 =?US-ASCII?Q?region_to_defeat_ENTER-based_stack_pivot?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20260701074834.GI49529@noisy.programming.kicks-ass.net>
References: <20260629214712.1198680-1-xmei5@asu.edu> <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com> <20260701072747.GN48970@noisy.programming.kicks-ass.net> <20260701074834.GI49529@noisy.programming.kicks-ass.net>
Message-ID: <8730D74D-6395-4FF4-B9F9-06AFABBF8CDE@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: edw998d97qsygkprqor1iwm5thgwpdki
X-Rspamd-Queue-Id: 14427C000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1782893682-19396
X-HE-Meta: U2FsdGVkX1/HknOLHIS0D3ma8CJn4mRE0EBSVhHJtt6+xSBtbf6m40Ok+8c7/8patvn7+wcumrYyyluSCE/64j7zjBappYqIRrbtnKFcGLwY0CQmYxRHLMZVPNjvraBe6zUqyWQw5lrVfHMcyGZQTMPyde4tGicT81rOSz04jbrdE7Ibu/tD9rDXSSFSXrueXHiqilFheE21UcXDP21N09xrcT0tQngC8JUAUbjS6hxRdy5dUMDsF+naaqN226/0pbzMIdiCzWlEmfQHOtNYwhHBKfMTJoFURLZCHkAWrtR2yAg36CTGBacZlTy1wcvuO07DYEv5RJB08c/iu3zaPx7ZWNZ3g76J8JmJEpUR1xmsZtWjwBFTCDl1F5AewZQ3/b3jv3W+RYRtzcO8Xec5X28fQcDcATUkTN2p6mPD7TN7kr5A8RuPEClWwAOagWvY0PuHwTlgXzKoWlxn95xsXj/XR00DeLsDZiPWu9qVWa92oLNJBhRDTCAVyE0dgVSORYpgewJMOH/hvcB4CmGnIAWYzDANbN3a0hTaokQGOY9TNugPS/WFwgStNXndB9EjqXKQJUpT8bYHkP0RKYDdA4e8YVsV8H3HDA19yS2okaB7DsXkr3MQ5CrkYz+2kxkiFtwhtTzB4mRYgxtiptRCV9EtGxco5gOtbycFKckEO0vbJe9kSKGeKzUjnk1rSUyzE2eG8ll4lVqA4SKma2AVKW+oUWXD4lvyc25fOHA9LllDBgQsZ6ULFB8mVR3l4kIM/m7LNSXOebMlhjJEm7DXOwT90t9hcqwNo6Yk31NlkUw0BJ1HhStpRZwU0/1Cq3JYB7U59feLGHHSIwoZlKb80YCEi5csuPeGoXJb7oQCM/qK5T3hkbOI3zyxipaSwsYgdpHvQLft2C//058TKKm284TeIW5R0ygv6Gu2ZxJ9duJza5Dm58+W6P8Bq/frx7crsJ/U20fVNmX3BgTU41O
 6IYZt/Hq
 fEHZebnOFFV3TsnagTcK6e5NtRdS3HpJR0RLFwdsdyrPkmhU8DGU4I/iAETrKs1BoPFm6En1nRIZ6ePMLNduTniC1Wo/OSsgZd7PaQOT+TfG4WIMOd0aWknhsDVURwZDlauW/ySa6EsMXNJYwfoKU1HNqmzCIjjTQ818MMoS3o9UP45gXmDOLZp0skMh0bbe+vfj6finUYsyDzbb+/zG7m3pat2atzmd27qJ9cPmGctv/mG5WjZu5Cno2IPYMlxG9GVgzmSjAOH/KGpBmo5JWlN9GZGzQjrE4QBI+MCgmKJLWAJkS67RfytC0eNkeZrKM80YLa4jdGuyVl5W8Ol6qAsmOMrblY2m/6Hg8hUGJWfx/YmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On July 1, 2026 12:48:34 AM PDT, Peter Zijlstra <peterz@infradead=2Eorg> wr=
ote:
>On Wed, Jul 01, 2026 at 09:27:47AM +0200, Peter Zijlstra wrote:
>> On Mon, Jun 29, 2026 at 03:29:50PM -0700, Dave Hansen wrote:
>>=20
>> > But, really, if ENTER is so evil and nobody uses it, shouldn't we jus=
t
>> > have an MSR bit somewhere to tell the CPU to #UD for it rather than
>> > playing these stack games?
>>=20
>> For supervisor mode only, I suppose=2E We can't ever get rid of userspa=
ce
>> ENTER because legacy I suppose=2E But we can make sure the kernel is
>> clean=2E
>>=20
>> So yeah, having a knob to make supervisor-ENTER trap would be useful I
>> suppose=2E
>
>x86_64-defconfig builds clean with the below :-)
>
>
>diff --git a/tools/objtool/arch/x86/decode=2Ec b/tools/objtool/arch/x86/d=
ecode=2Ec
>index 1b387d5a195b=2E=2E9e53db863203 100644
>--- a/tools/objtool/arch/x86/decode=2Ec
>+++ b/tools/objtool/arch/x86/decode=2Ec
>@@ -642,6 +642,10 @@ int arch_decode_instruction(struct objtool_file *fil=
e, const struct section *sec
>=20
> 		break;
>=20
>+	case 0xc8:
>+		WARN("ENTER instruction at %s:%lx", sec->name, offset);
>+		break;
>+
> 	case 0xc9:
> 		/*
> 		 * leave

The problem is that it being a single byte long it can appear in the middl=
e of another instruction=2E=20

ENTER was primarily designed for languages with nested local scopes, for w=
hich it can do quite a bit of work=2E

