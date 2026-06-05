Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD086CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 14:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148AD6B0088; Fri,  5 Jun 2026 10:13:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2526B008A; Fri,  5 Jun 2026 10:13:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03E96B008C; Fri,  5 Jun 2026 10:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCC9B6B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:13:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 774B81C01DD
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:13:39 +0000 (UTC)
X-FDA: 84846052158.09.3820FA7
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf26.hostedemail.com (Postfix) with ESMTP id AF6DF140010
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:13:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780668817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4GRURVv6R9obKMonB72XWAagTi6XS5klgj5iwiT37U0=;
	b=t5CvUmkH5HBIKNhUIk0ZfdImlOcD/sUDfCHMt60AZyd/bgdTJ1F8KgSwHUcMJuog+1zVW8
	kyysNAugCbatfFm/6LUpo1Pe+qn+peIMLoJhnbfq8WOJNa1XG7syisgjgInKbvCrkhbsfp
	8oSf9tlda2fYnTt2+87fKxAweNV2JT8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780668817;
	b=A6YIYHt1yhaYqjqGq2cwPx/mpjG1cD1pFqyph1XsX/1GMwtHVSL0I/+Tmc1GlDRYthlH1C
	rNIoLiPgPLeNkjcrbaqNktOwDUVjNZCp5LNzGqN3bs8XjnZp1s1OUkf45X96/NKlw/Ijmx
	+v4s9V1qlIjKTh79v5eg4BlekWWbb5M=
Received: from omf16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0817A0142;
	Fri,  5 Jun 2026 14:13:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 42D172000E;
	Fri,  5 Jun 2026 14:13:33 +0000 (UTC)
Date: Fri, 05 Jun 2026 10:13:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
 "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
 "Luck, Tony" <tony.luck@intel.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "xieyuanbin1@huawei.com" <xieyuanbin1@huawei.com>,
 "Lai, Yi1" <yi1.lai@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: mm/memory-failure tracepoint change breaks userspace rasdaemon
User-Agent: K-9 Mail for Android
In-Reply-To: <39cbb38f-ed3b-4f17-b9b7-ed466957ee99@kernel.org>
References: <CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com> <b930678d-a1ae-458c-8705-7ca9680d4cb6@kernel.org> <20260603121707.7eccb9fb@gandalf.local.home> <20260603161947.GBaiBUI7C8WWPwD84S@fat_crate.local> <0c16bf3d-7c6d-4e28-b200-03b7d0ef714a@kernel.org> <20260603130006.7d2c4a62@gandalf.local.home> <b637ede2-73da-49f0-a7eb-70ec79e79624@kernel.org> <20260603153115.775a2e81@fedora> <39cbb38f-ed3b-4f17-b9b7-ed466957ee99@kernel.org>
Message-ID: <BF17A4D3-D408-43B6-A440-A49B94C7BB62@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/62rHCtMuTCz6iX+3NT56GhQE8IV4VS4s=
X-HE-Meta: U2FsdGVkX1/PBkQrb/Jvh0066tdGux5w33fpB9sqGI7EaNk0BPMC/PFfoJmWddVH0E58lf5PW+o+Bwu9NZZAw+13Qa8el9ieLTZTrtp+Aq/BWP8EX8uiLqqtn8+BHfHnNtAg3Voe5W9IgUOCcIQoGqfof9mdVZeOd0UkeUv0CwbdXtTcIEWT/c3PGfcjT3z9O6CA9MaRx3KqMvbA8+gvTPvIBlSIYlhA6NNvghAMXrInx84xI+MMmylkeqjsn/o4DZAiKD1E0Y/8cPVHNzAGUBfIL/9ZAHEFOnMapjaQjm7/cn4Fg9b/NoixMHoCY9kQJjr0+U+FAjbpVtYST5Un7Gsd7BYt4XP6
X-Rspam-User: 
X-HE-Tag-Orig: 1780668813-492527
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AF6DF140010
X-Stat-Signature: f9eru196epccb1qp4uzhaestm7s7js1k
X-HE-Tag: 1780668817-606182
X-HE-Meta: U2FsdGVkX191cO8tapzSdMBp9nqbqmHlvhiDlHnL2ypUqjtuim0FhHxHak55rENGGaEw4kBZ0NBM4cg2rfCPd3OU8p7gCe5IAfCAioZgUN+EYa8EMd+su5ciD6vRFyi7WSFkFIjJx572HNBxa9evWLe2MLs5sJ2dKQDFzWk9W5jXxtNmtj3ET+FahbCzLTTfgov+gNU4z+mLf7BV3RvKjubFHVztTxDyDajFT67WIluuNay7tSQ8tAhZ0CG/C9GL9+Wxiiym0CwyqZbWtWC8LdODZeQ6LXSZtxFGGXuEdRacKFaAFkw1q/44SLW6f0PJhrb3L7jp8HZZ7g2V/a1WUQA+ISmJlPL4+2kbahnC4yiGc7F8Rn64+YK09XScqlXec9KImBPUqDTTfzVl85vMrXTWCbVwvZgYmyxi99CA4MYFVdAly4u1WHHA3xqVU20wnwgiVc7m2DgRI1X+XGZQa3JSrEAOt9FhKkjAyoTYJRP0iA3bEYAOpzAjWcWwEMLjDRbAAf+jtIQCE3Fgw/q4Ub6ZFBtQKImcWeFK9z2HMuehZHidQuCraoUl/KzIzNFaarHGKzcc5KSXlNO893QPvUQXqjPRAme3Yo0cXfvi+ZCfo9kYatcGDWsgVGVIN5wzI3ZwpwdIYp071dOJHArOH5VVDw/JJoZRCTCUOARSefthbtn3itpDpAmF+JPxnObVXHgDeM074t8MlE8WSLSwxlA8B/Wzj9PfmYFAkjERk82ZCS8SCKrP4TOY5zzmNTDmemZ/KpqaZljmeTI7Z4oiGINXJpKhn7+fuBlc7rQbvMaXbT+ZOP3mwtv9+L/Hu8JM0Pxu2RvgPhX1yfKncwBJq8BiHI3HYldDMCGAc5/mSee82vEkFfWVNBcaOuUSn95F/JMrKJrKH+jzdYhaxQoTyyYFBsIu4Q8T1L90R9spXwld3rmeL/837eFdmZnGy/AyRagM7h5vVv+NH8ufKjF
 5Kxf5TqH
 7OPVnFlp7E9h3Wys2Y8aQFPWn2rHw3fF5EIiplBfVCkgP5xXjCTUn4Qzzssqv2lD5scGDrPevgF4no7rS+2O3cIfe4DFdkFFbjqD5eHeiXkNUIee8wUvAuqeYNSf546pVk1tou7QtIWg7j2BMaGujYHKCtTZofUSsi0nKb3q8ZdswGBbN5EUKwzS58DvhMcn3S/iA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On June 5, 2026 4:52:28 AM EDT, "David Hildenbrand (Arm)" <david@kernel=2E=
org> wrote:
>On 6/3/26 21:31, Steven Rostedt wrote:
>> On Wed, 3 Jun 2026 21:13:30 +0200
>> "David Hildenbrand (Arm)" <david@kernel=2Eorg> wrote:
>>=20
>>> Thanks, that makes sense!
>>>
>>> So, would it be fair to say that, in general, what's exposed through
>>>
>>> 	/sys/kernel/tracing/events/
>>>
>>> is stable ABI?
>>=20
>> It's only stable if something depends on it=2E It changes all the time=
=2E
>> It's only when someone complains about it that it becomes "stable"!
>
>Heh, so we only know that it's stable when we break it =2E=2E=2E
>
>Let me figure out how to document that=2E
>

Yep=2E That's basically Linus's rule=2E He even said we break user space A=
PI all the time=2E What we don't allow is to break actual user space=2E The=
 problem is that you can break user space by fixing an API without knowing =
something depended on the bug=2E

