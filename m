Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAE7BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 02:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACCC36B008A; Wed,  8 Jul 2026 22:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6CE6B0092; Wed,  8 Jul 2026 22:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB8E6B0093; Wed,  8 Jul 2026 22:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72AC86B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:33:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 05A4D1C81D6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:33:47 +0000 (UTC)
X-FDA: 84967667694.25.4D08DD7
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1492CA0002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:33:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r7Q1Gay2;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783564425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUCzNBo2De+EFhwds+D3LViOOG1LNZhzLGOzUdX1xuI=;
	b=OF0jzccU0YKSys+0qAjqdd3i9XxouMT1dVHJsXvtkr7giB7keoInOSUB4+P9hSh/lt8rfu
	lu6e5ry2DCe9aAPI1JtvQPEaFpSnSACLCCjm0VBSWxFSKYJsGnLGoKYA44L0iXzz/ICXo/
	hpnLoiRr2UnKL1/2+1Li01dzJkaUkpM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r7Q1Gay2;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783564425;
	b=tXCiZOF55VzlKNUzqyceTU8qHUgS2f0gujpBOL806u69/RkQzbPfzoh6fPw5Ajwqa5nEnd
	RndRxa8ClZt7fGCOa/uhMpcQAE7YypM6Fo4zUVuBqou8Og01YVdCuhczU83smlwB6FZ/aL
	8gZ+NNjkICrsRYXmswhj/5mqLIGO//I=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783564422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rUCzNBo2De+EFhwds+D3LViOOG1LNZhzLGOzUdX1xuI=;
	b=r7Q1Gay2oSrwXoJ7iuGffU4EvlFvnQegMN9d4T+5AoK8K6sgF+4mGzBYKl3UE2JSFm73T0
	nD7oIrq/l0m1+Cwb69+VpKifvk6gBPY9qQtfiRjT7Zdc/WfGNfp/r5odSTR2WV5vHPkTxy
	6p2kuqkiRW5gtdYt9D3ws9ynXwO52eg=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 01/10] x86/mm: drop order parameter from free_pagetable()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260708-bootmem_info_part2-v1-1-156ce4986598@kernel.org>
Date: Thu, 9 Jul 2026 10:32:57 +0800
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 linux-s390@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <8ED0A21F-15DA-4B82-A326-88DDF7466CB6@linux.dev>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
 <20260708-bootmem_info_part2-v1-1-156ce4986598@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9q8pitrwpozm6fr5e1ufh31m3zcws6tp
X-Rspamd-Queue-Id: 1492CA0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783564424-366557
X-HE-Meta: U2FsdGVkX19ZtR4AKbNaTbwDR3BjPA/YgT/EhY6HV8oPSVL2zXUv9viM0wbb/MyyjaZ7tcMXhycwP99tdZHoWsul1wmJgHZqDsqX2VYu7dDyBPD9i78YbNXkYw+5/RNg0htEGQ08S12HaBCLvHpIYvGzQDgamDOexNyeEYEXTfTNkJJytQai4PigbPJ5kmn1+8wGBotoR/AK85NBASRK6sCVOTvSwVVkhG2nbO6FdYEAlrutt78T/j5WEAcVw1jMUEEP9h47UxWRSTdXKhmJL6tznkxH9aL/Ki6alIL4b6Tq0uC0vclT/ePDMxX/17MWftxpYW2Mwx/Dx2ISI9lWjAKl9JfivfoXESHdmdzVB68NXy7VfzzDu50zn3YDilPsqnFObhEzRfcYM106iO/1UfmKsmF9ICSNEzzqxPLUR8HIDy+tLkN92Xajm/WhOEh7VPwaolvmQTeqbpohtmZExAysOWjwdEh7cnrIxfWCsQEYd5ZFm4mB6KEsaYgvTr53sH/9t8Imj8AKVJS4Lr4eltT7cRwQhgdCYq8+K+DfT+6COUjGyeQRmY/aJnjchyasvqaK7zjbGnvnm9PwZvwxqauletfUdjBf5yIg7vp0UbPcWvwu38rhybKJlh24F1RkGkH2SNTQtLG+ImwpUBLdRSwnBTv3QFB61+MCowvJKzdYzFJgYk/tq+6BM7Cy5e1ThOWf8Yu6kpNqGP950nzJE7V8f0htymKFT2/N3/R6HBg2x0nMlZuO4klCgtNqEuvnSB78Beq8mDDN+jZszowGsiErDAKW3T/C3EqmwB0rnZ5UGiQ55Ghbz4fGrol95D1tD83HVYTzS2PGRKrVQvx40rJCzRaaUnhvjjxgz+MQSk6cbk9zhD5Q6EZX9/R0SKq+uSgbxzkflwWl6TdNnxCHLWacbMQvdkNVs4qLjPPIN9MPJQKfUTAVCLQomiWWfYotJJRBWqsCVMlK+gZkPrD
 Ck+792lV
 jGi6ce8NF07NLoS7520Wk7ZisVVUE9vYfAkHAeBDNYfS4T8K/36K4K4bWgrwLQCo+9vpnXjnvMgbOnDqGDDlXkneXRQh5Bq/Y7b/Y+zlk+i0B/mGwwf6EDLR3zeglPHR49K2Ctcfbo7DJTGZSJ+wLd5ycy4e9IKtKTJ2wIiu+T7i8piMd5x8LwJTnEJKUINLFnxBYxLJ9cWB+iswDHMRX+lEk3AoUT8Al7lqCINZMNs/TWRtT4f0DK7o2UQntk6T72b8jaf+v/2Zi88mx3zqnhD0o+uqdZW9XVskNlxiColr+aMOEgw12kbd/GnpjgjLe1BSyqlYz1vguyNr3Fhu6AIBGow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 8, 2026, at 22:10, David Hildenbrand (Arm) <david@kernel.org> wrote:
> 
> All callers pass 0, so let's drop the parameter.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


