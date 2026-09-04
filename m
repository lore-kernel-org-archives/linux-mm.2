Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EB49C624DB
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 02:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E13986B0088; Thu,  3 Sep 2026 22:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC61B6B008A; Thu,  3 Sep 2026 22:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA466B008C; Thu,  3 Sep 2026 22:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3F6B6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:27:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55E8AA47D0
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:27:19 +0000 (UTC)
X-FDA: 85174492998.01.725BCD4
Received: from mta1.migadu.com (out-218.mta1.migadu.com [95.215.58.218])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2CA7C180004
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:27:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jU3zEbOz;
	spf=pass (imf24.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788488837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKfmSm+6vsRmrKlq8nsP26C/BYgoVR6DMMkam4MtIMg=;
	b=IaYlI7niEfRW3Shm0fXjsWCfkRQ6L6tyf2Yuv6/DdgijbbLhqUJ5mXDNIumzlFAx2xTce6
	pEbwvhLOe6M30YetRwTdAOl9uTDXr/rOqoci1XHTW7H+g6RWXyd25FhvhE2Lt5T+e0HlzZ
	CgUHhV8+eVHfSCUnt0ZL01aWZ1/NMCQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788488837;
	b=jqRDz6ZHXZfr7YVP/TKuMsARKhgI1sQPzl5i1e6ZVxDsfgHxj2c3uw0dDya6+xvxpHI5Ne
	0Im5RIE/IzSNSlRcK+a1xAkU/r+fHwoafsUOtmTuL1HpgC6+ZqGUlKr1i99CbSPgy7kVeo
	JzehTMlrqYItWV7BhVny94p+gstzufY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jU3zEbOz;
	spf=pass (imf24.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ReFqBqr6par/UGlKlh7klHni6a0vGR+ynsPeX9dR/mo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788488834; v=1; x=1789093634;
 b=jU3zEbOzpsmCx6wQz6XLHMz86d8KSN9yymBct+A4V8QQuSpsbLjQEjcGoFo5rkoVQbQOXr7M
 0Brj48HDbfH8Tdfx6G+kJhBrBDpQbFnQ0lUmRnEWsmDfCoRh5DOlMUO3dxuvZnh9LvxG8NPOd6O
 5R/8yTJx7gDkkGhZg9m+unSE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b3ab1c27f19562f0;
	Fri, 04 Sep 2026 02:27:13 +0000
X-Mizu-Trace-ID: b3ab1c27f19562f0
X-Migadu-Flow: FLOW_OUT
Message-ID: <bf3f945f-207f-4416-b8c2-8d23ffcb8e62@linux.dev>
Date: Fri, 4 Sep 2026 10:27:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: charge folios to the target mm's memcg
To: Jinmeng Zhou <jinmengzhou22@gmail.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Jinmeng Zhou <zhoujinmeng@bytedance.com>,
 stable@vger.kernel.org, hongfu.li@linux.dev
References: <20260903075048.3316-1-zhoujinmeng@bytedance.com>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <20260903075048.3316-1-zhoujinmeng@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2CA7C180004
X-Stat-Signature: 9n41f7n3yc75365bsmtzzwjzsn6itgm4
X-HE-Tag: 1788488836-703273
X-HE-Meta: U2FsdGVkX187luu8bWtANxxKJHP+jcof23bm7h1Eh2/kcT43WH57aFa5+rFH0vA0Lr3n4AUSfCNeK+Rzhq+n8TdKhDMBmbhUk7pXa3qQhsBrykK1qaTlXCYCrLP/IzW2gL81tUl2nUlGZMmF3oelfoCBsN41D2UIffVs4oEbAmAbw0fvbVHWhj55u9NmZp0cJm9HNPY4kW8OanpX7cmUsD7zgAN9JXQO9ZUPnvygAXy27q+BcoxeDGDgHIxeOd8iomBtRgFFJJ8cpI4QRUzno3JFFOIp66zttmO+/zUDwn9JsqDLEPoQkqYh22Csm54K7UvSAGoYgZVdcEgUEu6RcbzixT7AjQ/9b+uA4P/wJBfQaTDZhgB4DJbo6sOUpt1xkB3Y7kq98r61Zvzt+yuwaSBiniLA7NQUuQidbmp3mm87l1NIgHaF3qfqFANOzuczM1cl7BYf7HpIVJ0ZP8k/eO/+ia4JbeYrZ+QZb2oJ+0+JFuTbku7hbiMIUEvGQ5LcX4noCYGGhRsH0+RrBdzBcZdibUqlVRsuhUqypXy0FoKqRQLxkqIqrpPhcub4VJBqw/MPUmoTWgcsu1zFCVKfJp/vMyTFVjSqr4Jhgk0tsim2Jdlu9VsGL+A2YhWvsHeoTbGXM8JJUQDK7ctgxGK79SCNh3usjo3XZ3zIlKaOkAVsZPKtZto1c5TpBB4Zw0eFibwW1O8f6L6WbXkUCNNdkVTlFPZ6FseK2fdO1HjJCiTumo1AstL1jXFNzryCaW+N9AIufFstRiMlxeXkkCoTqeAxS3FT+HNNtwQzjNxPEF/pLa8vVX5JsWrajULhSMug8Eh/UCAhH+LHnKS+R2tjqeOybkIYmTgCmLN5gcRu48IGLAZeAJ7cixrVniwvz8q/30lA/NoqbI4jxPzd/ZYQ+evOuSjZrlh/t9PIKU0zjqBNIvXqJ0/Cn14PTeBXKXRnbkG7hi3ROneRsFZtj0g
 XdIm+mnX
 oFpWevALlJP1H2lQoY2KRFCALg1ajtZaxmFeYXhAdnpbg7romSRs+8yAyP1suFpKQWyyzIx+nH7AOI3XMaji85j+hJp6qgO9kwJYCVddk6A+sSzIcTdzHAy+09+zxwthA34jKLbC4s7ht+7TZqVZxLyx1kImrjwpzZs8eKAXsRXOoACSc//Tb5QuaPDXXLn7yh9eZHPLJgWoVyIAptwC97noDPDQwQ6UZdy75YUmv9seSTdhcLeNsLK8Kq1u1cezlgj0isHnJhhgc5IQ4GWk9RTFrOf3RupjltjEA0l11OVTFLjqfi3uM8ZXp0q0u0VillEkb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/3/26 3:50 PM, Jinmeng Zhou wrote:
> HugeTLB folios are currently charged to the memcg of the allocating
> task.  This gives the wrong result when a userfaultfd handler populates a
> HugeTLB VMA that belongs to another process.  The UFFDIO_COPY ioctl
> operates on the userfaultfd context's mm, but get_mem_cgroup_from_current()
> charges the folio to the handler's memcg instead.
>
> This can be reproduced by placing the faulting process and its userfaultfd
> handler in different memory cgroups.  Have the target process register a
> HugeTLB mapping with userfaultfd, trigger a missing fault, and let the
> handler resolve it with UFFDIO_COPY.  The hugepage usage is then reported
> in the handler's memory.current instead of the target's.
>
> The generic userfaultfd population path avoids this problem by charging
> folios to dst_vma->vm_mm.
>
> Pass the target mm through hugetlb_alloc_folio() and charge the folio by
> using get_mem_cgroup_from_mm().  This preserves the existing charge timing
> and error handling while making HugeTLB userfaultfd population consistent
> with the generic path.
>
> Fixes: 8cba9576df60 ("hugetlb: memcg: account hugetlb-backed memory in memory controller")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jinmeng Zhou <zhoujinmeng@bytedance.com>

Reviewed-by: Hongfu Li <lihongfu@kylinos.cn>

-- 
Best regards,
Hongfu


