Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94A0DC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 15:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4F06B0104; Wed, 12 Aug 2026 11:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555FF6B02AC; Wed, 12 Aug 2026 11:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4482B6B02AD; Wed, 12 Aug 2026 11:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA406B0104
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:02:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B02E14044A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:02:42 +0000 (UTC)
X-FDA: 85092934164.09.980C99C
Received: from mta1.migadu.com (out-122.mta1.migadu.com [95.215.58.122])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1EA084000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:02:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tPg0ZtA7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.122 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786546960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yqoOlkl9ijjcZTxT1yRjq0uO8R56kWUfnpqXm/ZVlaA=;
	b=kA5cXmec/Ak1kZ4pHnOFSjYCEAnVtIaI0keOdhOA2ExLFLuwSXY65zpa6Jh53vCkjjmRto
	MadfJI26UNacOEY4hkdSl1ILbiMwmceMxNPeizjP03ldkCwSVhDM7GvegMZ+j4l2QZkO6X
	rCa/QDk2wWgrde+WcQLgrEvZIX/WGVs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tPg0ZtA7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.122 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786546960;
	b=pFv/Q5cJjPZ2wRyb5B3jMbBwmy2qjW/uj4pVaLtK5GBir+/0Yua1rtKsEhUU6TccswVQcI
	ltv6AYcW1rJ0m2XlbqEW4OHarz4nkFdo6h+5b0gFJDu8jBHFc3jURSkeewCp9Cfr8BR1OX
	kdc74ba84iXifGjZUzcxp9AhkMtNlEE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JKWLnlDFJd1uxYLyCitzdHvCvuNrwGxgCJboQQwEr0I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786546957; v=1; x=1787151757;
 b=tPg0ZtA7vfMucBEGVMj/kbusrB5CiB8ql5vLhyi9AbCuVeqzKtN2JI3tVk1yEJPnKBTqZGcj
 zPkLMzUB6n8Qc5bD0sXKckHuHmaImcFQuJEBszWr+JKnJR1g9cJ8PLVVxCG96YjH8cClm0U63yI
 LsN8EQUnNDJnZiNro04tZwtc=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2a03:83e0:1126:4:9d:a05e:5bd8:c200] (2620:10d:c092:500::4:f140)
	by smtp.migadu.com with ESMTPS id e66d9dbc13f52a81;
	Wed, 12 Aug 2026 15:02:26 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <8433cfb1-111b-4c66-b2b5-7ca7242623ea@linux.dev>
Date: Wed, 12 Aug 2026 16:02:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/18] selftests/mm: raise the khugepaged test-case cap
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com,
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, kas@kernel.org
References: <20260812132304.199287-1-kirill@shutemov.name>
 <20260812132304.199287-2-kirill@shutemov.name>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260812132304.199287-2-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rx8k7tkmkr453juowg7skix7miixm3np
X-Rspamd-Queue-Id: 1EA084000C
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786546959-680667
X-HE-Meta: U2FsdGVkX18armxSuwo+8X7coxYgkwXJjM0xQrmxoL1bAcyjPm1Rc0mQJABv71Bhjei2D30b0Ep7BoVbXmIbouix+daYsR4Mt/+JoUp6fBKeQS5hPCltUKXZcm3G2pXsu5i+eptK47MECe8fiLvLrIY/o+DJEM8KCSfbHdx0BCfNBYTc/19xjmKLive0THzkkPxNwZWcRIbi3QfRHgmUknAGWGdzYFottUGfGplyMCiJ/KASS0MUzar902kmIziJD60btJx2Ip4DHH9sOb5PTtOsxCTsYXJwN4EKDudWNuGF8jiMCCuJ6/EzHT4XXfOmHQGANHuFqoZ4UpaSg1mAAdqaiZKLR3mDoODZU9WKXugzL52l2AbRB84HGpBUzSgcd1ZC6ZlSJlnH38n2VplkUVEEyfVZaSoThfLYSu+pkGSlNO30CkFESXaYbO3B10ZTmO6qpKz8IILKfjBvr+T7lIOFvNKmieWC+lC890LJqpk3l1gLLxctjKXPlh8vDpF/W7AeqRJQlevnUveAx/2IKFwJF//UOpiKKhBXNHbxf147HPJV5hxI+W9NGKHSRH9Q+hV3vIGoC4N0qb0vxba/nU9mZEl4l+XH5sm8KUmvJp/8UydhgjgYg/T/qOYPDzT8DjInaLDZDb2aZYKtXTQf9q+vBoUJ0w/GztKU+QY3b+/iHZ/OAHuUQZULXaTLyMwYGK7UY6oBVBCV3KYFH2KHb/Yht1w3ThLacYBd+B7hgRVpAVGAN835Zl8MfOadZclbqxq7pP27Tv+XY5eCr+nTZKVLaHO865DCQCNsPJOo79cTJgJ0ewJTexcMlSlKAJIQQuqE79tK2txM8/XZRZrf7nzhSfCjSHjhpEjMtL97Bf4GzLIQXQ6gTdS6Ew1vONC1mEOSGsLAsg0RlKv+8EKuo6GE5qZv/MHGSZOTaen3GemgKak822XxW1yK49qR1GFTK8aQfvAzTJyepHko47H
 3ppwszjY
 u9+BBf6obJy2QXkMN8E06BzmX2GEAqkh11MHo08LdOXxR8wAnGFJSlp4EMSnQdr1zsmeNiw4TVbl+COSrbkEzK+kp3rqdMjADn+Fj9vOzBtwnTtygpXD3YCKLmbFBcVNPxlOM3xOQLmim3CKBhP23+8r9CTtlVPWbx+Def3DyB7SeTWFmeLRGWmDXhdtNW2c431rYaUVq3MII4jU8VAE1vrrEJounBWXoCE3TzotE4DnOQ8yLRzKRjt+EO072OHh1BQtygZtD2EbgusAI52uEXPhf9xlFNeF98zwB7xEILP75PRlZSv+oWQ/hpY8wrWtpSLbdl3t040v9/u8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/08/2026 14:22, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> TEST() ends the run with "MAX_TEST_CASES is too small" when the table
> fills, and the table holds 64.  A full invocation -- every context crossed
> with every memory type, which needs a directory for the file and shmem ones
> -- already registers 63, so the next case added anywhere aborts the whole
> suite before a single test runs.
> 
> Raise it to 256.  The table is a static array of small structs, so the room
> costs nothing worth counting, and the cases added after this have somewhere
> to go.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>


