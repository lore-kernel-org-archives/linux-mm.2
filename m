Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 306ACCD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 12:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AFFB6B0005; Sun, 17 May 2026 08:03:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487806B0088; Sun, 17 May 2026 08:03:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39D756B008C; Sun, 17 May 2026 08:03:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28D006B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 08:03:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9C0C402F4
	for <linux-mm@kvack.org>; Sun, 17 May 2026 12:03:51 +0000 (UTC)
X-FDA: 84776777862.09.D4B4F58
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id C4A6EC0006
	for <linux-mm@kvack.org>; Sun, 17 May 2026 12:03:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XayuKuYk;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779019430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uzAHTZq9a1jN0cBlc3SNJJ0CnrHRNLBC13c5Nsix0sU=;
	b=wbMszK+jVVDBQiubhlld3GOaOx6rDi0otbTfdivLdGsDzz+4sQst1gDXa0ypVt34FbFqWS
	LdpMHa3c7keFLmcAsQKXkBtKA2zm0V6etyHa2NffLRIirGUT4qPnSKDpNzr0MVPI1LXonY
	qal3xEvynUgcbowcpjy/A48xDYlGrNE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XayuKuYk;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779019430; a=rsa-sha256;
	cv=none;
	b=SSa2MpqnBTwNd+mER8RqB0zQPhb/ig+bvJzSmf0dOUi9cpQ4bLAVJwQn4ox0aix+kILa6C
	ZoBFW8tlFhD5slRgQdyB7b2Oh2qLd2AIObtzGTmWw2VvXSLYEw5YyVPFTzkppo3k902oqN
	cJljXAVHDwvYCuummK4AG+SNe0YjgMs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779019427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uzAHTZq9a1jN0cBlc3SNJJ0CnrHRNLBC13c5Nsix0sU=;
	b=XayuKuYkB18z5SlEgwurM6lOcrv/JPfJnlh1pVfuLc3lc0W7WAnCsugfqZ1qH4rEG3qso7
	UP26Cljvrr66pZICIUqzgrrZIxqBMF07YN0Uknwrzdn+S9CsKRLsf/105e+d6+wf6fiyB5
	FoTIArGY7IQ0lZwFUPg/51VboDuwLzk=
From: Lance Yang <lance.yang@linux.dev>
To: luizcap@redhat.com,
	david@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: Re: [PATCH v4 2/9] mm: introduce pgtable_has_pmd_leaves()
Date: Sun, 17 May 2026 20:03:28 +0800
Message-Id: <20260517120328.63143-1-lance.yang@linux.dev>
In-Reply-To: <8d365dfa-98e0-478b-ba6b-377c939865d4@redhat.com>
References: <8d365dfa-98e0-478b-ba6b-377c939865d4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: C4A6EC0006
X-Rspamd-Server: rspam06
X-Stat-Signature: iiqcbh9iowxfsuxuowrpdq899c4oqeuu
X-HE-Tag: 1779019429-219569
X-HE-Meta: U2FsdGVkX18kQfY73xQnqy7eTD4nM5xSG5pS01HRZNErUQ80NZgU9dCIvrTTl9uxPXj4Lq69AjOHEzy1bO758ddFpNEX2In05exI4ae++G4tbBEHkSTmxdooQQCRvJSUmib9tL6twwuzF3QDuEJ0eN+FcDALu6r4BvM78O4bBgKGYE15hhZUOlaN1CxflPgXaJoeMcIjowgeTrodROEWFrfKhzxweKtQaxmSF04DI4t6fzpU8U3oFzJF9tgRIVxSteEQg5iDsvSHS0czLQAPpA1iAFUqdGk2BcKbdCKyUNnpeABsOg1Hk8BJLYZE5YuG4JM/FZy05BkZV1BqolS17QHzJBQTXXwR1A+wpar6Vji3rputzfvnlgGljZnsbxjgpYnMqb195Tzis3FKmq9Mrj4Yc5Uw3JeddXFlUHBHAdVdl7XzhLO6gfN1VA3BTFYZnXluoiAg2VWRob62OTwx1X5CIwnCNxqhSs53qxuA6Ss5BY4MFbokVD8ecBjDqWE6jes89eKdvjBPqf1QhTJWXQ2DWsbU2YQwOKg3FnAYwszUj7eCgDTvgX7KGhaGuoZpAcTLOwb/Z+t4BYwgcEchF+A2tq0BRQucJU7/MGNTFYKGCdAHh08k1pwTxFQK2ofkdpXZNuLqwbhwgOShyXbXNNP6Jyfndn8VVBIaHzJKMquY3GCoPSjzl/109dbxMyyY82fzRaWatLDp6tWgwxZ/CDn+a1jK3a2f424O1vw+n4+fTKXvqgUwVwpsMZxgKxMoaxi/KH3E0GlcfAIBXzsF7mtG7oo42LrV64gOYIrGxA9Ou/vhklIszGmIxm60IvyzDQVWdiTqwxxjm+O3Dbu7+DnVbXvLEsXqT2LPUrwEV29wopI4G1B79cgWB5DwVlxSOUtdjUYV4yBPOHOIhgJPfSY49HaBYdN4xD9oCMbQ6sbxxPp4fnQ8TnpdOm6NJFVwm3Md6tOHXIrT/Snlrg7
 ZfNmBxr5
 n+jPIX1v9whCJgFB31KUjMdWdeFbFGH5+eAufvQD7hz87LHVn5zIGIRmoSIsvlEy4N5q0qVoC6aEbTepcUqmqzk/syXBKjZ7WNGr1xU/RRkIeBhBdalPBRSAnH/SaUL4/EqEyLnkdJ5h1RnqN/kZRKGs792TgP8h9XaecoYP7j/olGCuhAiW/5X9wVTkRnxXNjW/6zVt52FjbakioS6mmNj4mWglAxnPiPFynVpOar5EKL9JdvAydaj7SxChk9UvVRN8p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, May 13, 2026 at 09:52:05PM -0400, Luiz Capitulino wrote:
[...]
>>>   
>>>   #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
>>> diff --git a/init/main.c b/init/main.c
>>> index 96f93bb06c49..eea7c5bdddf7 100644
>>> --- a/init/main.c
>>> +++ b/init/main.c
>>> @@ -1053,6 +1053,7 @@ void start_kernel(void)
>>>   	print_kernel_cmdline(saved_command_line);
>>>   	/* parameters may set static keys */
>>>   	parse_early_param();
>>> +	init_arch_has_pmd_leaves();
>> 
>> Can't we do this a bit later from some mm code?
>> 
>> This feels like something that can just go somewhere into mm_core_init()?

Indeed. If nobody needs pgtable_has_pmd_leaves() that early, it is
cleaner to put it in MM init code :)

>Yes, this can be done. My intent in calling it as early as possible was
>to allow callers to use the API from __setup() handlers if needed, but
>since we don't have this case in the code today we can put it in
>mm_core_init() for now.
>
>> There, we should probably call this something like XXX_init(), and prepare it
>> from detecting support for PUD leaves as well.
>> 
>> Maybe just
>> 
>> pgtable_init() ?
>
>What about pgtable_api_init()? I'm afraid that pgtable_init() might be
>confused with code doing real page table initialization.

Or what about pgtable_leaf_support_init()? It says what this init is for,
setting up the cached leaf-support check. Today that only means PMD
leaves, but the name still works if we add PUD leaves later :)

Cheers, Lance

