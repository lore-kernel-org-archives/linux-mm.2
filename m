Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92D9EFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 19:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7AAD6B0088; Mon, 27 Apr 2026 15:41:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52216B008A; Mon, 27 Apr 2026 15:41:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68C36B008C; Mon, 27 Apr 2026 15:41:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B655B6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:41:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D0E08788A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 19:41:53 +0000 (UTC)
X-FDA: 84705356106.14.4D911BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A362D40011
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 19:41:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YJ2sQPBU;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777318911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfWloz2XC6CSxIMv7SC2/DE0S0iPXt3bkVqtfGx3NlM=;
	b=o+XCBa5l9KJbiod3PJSrO9sxWJ3Wry/3tzM0fYVF2Apr1xOK4IAcl/lBMK43+6VHb+pbMH
	jSDzzl7UbZvFCAEIZmhdi4LA9c7melG9Kfv5lybzXH869gs83yMX10MHf2/021fb9QE1kB
	wBxaRiUu1guSWBSarrdR9e2uphlWs6E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YJ2sQPBU;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777318911; a=rsa-sha256;
	cv=none;
	b=6Wb9Rhj52TD0MhzjnVPsEOBLar45zKtt48Yh0LxqnkFVko0HqdYoNB4s+ypaPGzctEOPO9
	egnN4MAbNB4VKXQR/0AJ0Hudi9eU5lUC6YzOj8w9wIcrqqFRMtw0KRWPpc9HZ4PNlH3zn0
	TmykVnSujpLIz0srItLJ+bLzgOdhqRE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77FA743BC9;
	Mon, 27 Apr 2026 19:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D844AC19425;
	Mon, 27 Apr 2026 19:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777318910;
	bh=jqHLqVhMq+si5t6zdmANYEG+sciG4MaJhOm7qVM3/XM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YJ2sQPBUIylRzAo3mxf6Nhm724kU65Z9v+W/MDzEsLK94GAuVoZhPwwWZCXj5Il90
	 ylbki6bnVxWgs89zBNMtLu6rhC0K0vCojZYgJd/+kyOP74CwyHwQX46D6ybpo0QAsy
	 oQCJGNTLEnyIrzPcfcN4gcLvxRKVqIE5E2NEV+lUm3Bcf2BRAVes0TDuq4IF/Ob/wq
	 dAQXlAYNZmAjK+1TRurBmgbmdfvRX160CR8pq/uzHTcTsgWMhZKAMruNFvOCuPw6/q
	 emV3S/kESWt7U6fOJogxNMJytyjLj7geapaYIZf4rvYKepFWg8R9Y3FuGNn6+hNAT7
	 j3h4J0KO+Hqsw==
Message-ID: <06c7e6a7-60af-480e-afd9-700e985ca2ba@kernel.org>
Date: Mon, 27 Apr 2026 21:41:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v16 02/13] mm/khugepaged: generalize
 alloc_charge_folio()
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260419185750.260784-1-npache@redhat.com>
 <20260419185750.260784-3-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260419185750.260784-3-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r7r9ym9norbpdsbzgfxqzwwi77yhwg1r
X-Rspamd-Queue-Id: A362D40011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777318911-977210
X-HE-Meta: U2FsdGVkX1+4IOiqJgiPgacRobg/VPUE1tiuw4qDNwelcF4gjnHZIFRFn17jcUvSDvVKOX6zxZpA89CuebFIRdxzanJ65pZAv+oEDvhAxqV/vZw8mMX0oJiSpbBEXHJnhGP7r6w/G6xf21pttl1InSWAtyg+1HzzzEDqiJNkldXfHspsym5OE9TjoPx4T/CMQm7LlwnWsNBlNAgbfgyj/YR9+RDOgRt6tk+ZihfcLLOPbod1Ta29NlFqvTRPShvfdxwFa15PP/PFyAtVdjLcPPo3ufbQ60vN4biVHih+KvNBRbwrEl700p88GiC/VYh1q0RqDgUQslmmWpXiKC/5hJXxxzuVNq32SwSSN5pxBiVGntAimL8UFNm3xHIBw9VqQs5muAaqgOBh2m7EueSuArTLWqdCfERSd8DUDGmcDJsNW5p6G95z+qN49jKp4vHag2d0hHXRN8u4SfslX6Lp43ozvw8sqe2Aos8BIcx24HsneEd3QXwfyo4BQOron7KE85s+saC8gJ924fo1394AfvVqX04KkvIZsvTTDxBER6T0t/krwiaNIwJm6L/VkwX7VStIh1Z/4MNEVBMIg8m0ebfI+6UC+wFTQ3giofxcF5F+HhBJws21bAA7FVWDSElj1zjC/kMqzJ4Rj4+4scaRJdr5FmlfBUNaAKNYV1sh6CGbAdxW5XWIpgZjnEj6CJDUD5sS0I6UsMbhsM8feWnAZUG5GebMMFFUe1o/grTzaeJBt+xAQvCB2WVrtPHQsZikaKbtZindmXlsFTxKpV66Rvi19FKgtiTSJq62Do6U3HL1/TqsqaRlcN23Mwk9TrMwp5YD1HBTJFNCyf9sRmlQFyeq/wBsFLf+BL3Ny2l/rkpTkwgcB6j8FRYWyRQBoPJyBs6volMNcNIW3cd8Yff/ygUoY6CwOzQJDc3RCXFBuDvPo2vYCNpOwXhGlpddBJIkPiXokWd6ho2KTYO57MP
 vyKqWzaC
 exMKIhxxVve4tFak+ZoYChGpk0jfDGjL7KEXzMTZobCnxit8FobaUpsm+78bpg4AxWTXkA5TP6nUPGEyT07jzPOJ1JA0PQDvQ9swepfhkey/TOEXkQmZ6l4dZAHY8d48sL1I1oYlLO1dinzLj8vxheBa/t/FvWL64d+Mioselnq71RmeRslYJUqKAyujmlUMu3tg6tBDJlVFOovVngwcFfeNS2DF2H5KJnhl9YZfeBGrZVCN+RbV0PhXAhtdGgR0Q3nFzLAKjxgotOXfifEydNA4A4/HrLAfPON0EZE7mnEN3Hwo5li7fVxBqnJ1dt3SEV5bRXJrxdzjFvWV9lnE7Bsgh4hlLKCN20q46tdumszE1SLUaLy87mD4Xkj95gt4IY3n3c9sIx8cWOdgG8/17hg3FcFJUAm11JU9iNBh9EWsXJfclzysZ7zZ9A/BJG9Mx5h02hV/D7j/u3YnmYKp7T40p6qNAaZIh989U6GEDdeuV8mfl7ry1U5r9xExhcpdUXcZiiJgrwXqg54Z2ViTGWUDcHToYauD4Y0KVHsYMm8neM88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/19/26 20:57, Nico Pache wrote:
> From: Dev Jain <dev.jain@arm.com>
> 
> Pass order to alloc_charge_folio() and update mTHP statistics.
> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Co-developed-by: Nico Pache <npache@redhat.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Your SOB should come last, the order represents the history of this patch:

Signed-off-by: Dev Jain <dev.jain@arm.com>
Co-developed-by: Nico Pache <npache@redhat.com>
Signed-off-by: Nico Pache <npache@redhat.com>

-- 
Cheers,

David

