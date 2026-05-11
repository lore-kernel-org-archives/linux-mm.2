Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 127A8CD37B6
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 03:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 396376B0088; Sun, 10 May 2026 23:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 346F26B008A; Sun, 10 May 2026 23:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283116B008C; Sun, 10 May 2026 23:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 176946B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 23:11:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC595A0553
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:11:38 +0000 (UTC)
X-FDA: 84753663876.17.BE1B611
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id C55F41C0007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:11:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tw0aVY8a;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778469097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cL0FELGoVYHYTfhfL2RHbUuOhJzysi3xHVnV5drpBKA=;
	b=3zqs4Y2y6UQs47jiCWbkFd/pr4iIJ+3rwl4S2i6OUl/3rqcAoZjzavN8GZlIQLQTBD5hPM
	1EpGy32fXwW9KPj3on0cq3JlyQH3leLuOcUYC08gwQV9EDRMW8Q4dEEsDUugR+tTX1jmX4
	v4Q6zU8hqemEkUX6SRZ7oAP5O2mKmek=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tw0aVY8a;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778469097; a=rsa-sha256;
	cv=none;
	b=wYuKqKyYZNAqUK6C66PTXOSAONhIQMJbqvnVbTu7vM6GLHbGfDcpbWwuOMYQcR6n8XTvTP
	rpHMZqt2Mq3CljbASv+DBX+sMbZGKmCTmosI46QQm3sUhraUrr5tF27z5ZzEqK+nVBO3NZ
	fTR7GB834h2X7Dw15CP3On44ySzEEL0=
Message-ID: <49787989-f05f-4e2c-bbad-bd8fa0e19dff@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778469094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cL0FELGoVYHYTfhfL2RHbUuOhJzysi3xHVnV5drpBKA=;
	b=tw0aVY8ay56GlUCDSCSYyOfeV/6Vr4TLp7y6hN9kIzYmg6dA3V/AjJnAKwjAXaHRciTwhp
	iiOup3nQKXgLjTE9CITs1ZorXI/i5bfzIuBJWNa3SSPT0VJfwJjcL4VULO1Nde1Ac1ykrP
	j6QidKjpP7t2u7k5sPCL+kYb8LLuhhE=
Date: Mon, 11 May 2026 11:11:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] mm/khugepaged: fix inconsistent MMF_VM_HUGEPAGE flag
 due to allocation failure order
To: Ye Liu <ye.liu@linux.dev>
Cc: Ye Liu <liuye@kylinos.cn>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Xin Hao <xhao@linux.alibaba.com>, Lorenzo Stoakes <ljs@kernel.org>,
 David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Andrew Morton <akpm@linux-foudation.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260511025408.54035-1-ye.liu@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260511025408.54035-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C55F41C0007
X-Stat-Signature: wchn7pq3guweonwhjipng3iu5ipmeiz6
X-HE-Tag: 1778469096-1033
X-HE-Meta: U2FsdGVkX1+2tOOrRz6ETfXfqxZ74KqsOKs13CnaroNfEiUTDifTNXR91B9EAOaw96pYKlAfnZrjyAGgcX5lkozsNvrLkZR719i0g/wHYz66ZhbWsGcupTzAAceWUMOZmaA3F81ak2Wtt4wL5wch8KF2zkT+Lvs4QuoCeuPvh4UDLfKTGa+ogLB2GL0GrAyA6FPHo/3KVbnHgRFZowpDs2mvcHEy3a8YrIWk1QDceSvPJ7/4vHs9JCLWfur/j5UCiPt81lxMpyknMu6sK/C0ZpWC1e8WAJ6ajNFCeYI86ZAxwGOTaURPGNHa+h4/X+Bw6J5U0eNN0wG/bG7p4lwZIdKCMgVrFb52+RRAA4G8kJYwCt5ooFwo8tYdDBs0zcJbwf41pN1ge0UUP+gVCio3cs+SDcAjN8bhPSIasb0Tu0N33bP2ZY3Ube0kONqxp0+bGtjKoRUkMnDKkD6MUEfyXjsIts63x6HcFaeT0BXJF/U2glIvGgW57QvIE17kALcbhTgNro5hM30LSUfU4Rn7uy2MVLDUdxEIfqVNcxgrTVPUfJkc499VGfOgnfVNodEQNDwFjlnDVTdBGB3V+lFYqEDdUA98vxdwqf+JMqVd0pffaPBFMUjIMWGNfXGd/HY/1Rts9k0bUmXS4XeA6TIf+kfFkLVAYELj7y0AZZ2Mq84mD+TCrkiAnWV2hFnaDtS6ck3LuJ6M27H2byoc70V6M5HPuzQIKFlF0AxVJJdiVgHytpoMNU7dRE5O8anQexpjSgNfwfuygXxAJ5vq0uwCAf/HUDHBvyR+aUuHzk7TEPdZdZRe0BM1/qAN3BbLxuQrTmqiCgDOkNYI5EaIKoWdBjyq+B3mj1zxnZHXeRgYVGptjNaiUIwFwVveXyef0En9n7XHNazYZsLSvP06GnVRG0Naomm+MJKnv+FqOdr2LtVUOzC6rqk/nAkunznKLKW1IQXGor/kIRKg/6Y3ytt
 bHSTmYi0
 o/XdSWTEShkrOBWvqGEb5RU9SQ+JI3PKHUZqTj4RMVIcEgrgxu0/DJcsB+3aTKGWn11rGeFlQaYeInHa1K/NTQNCaCobKKvMl8e6tkUaE+jtiADq/NXJ4dbsnqFn7UKTw/790HozWzdKRkJv5elr8hJKYwxI+In0JL8WSCLK4CPoCrlb3Mc2rCBcdSg8gP7tKpZFcId+FeGhpLzc2WA5+3F+4jpOke7drDWeT/R5DbU/Mhd/HgCw6Xemv3LjWN+Bu/1MjqL96lDmhRfst0Yqjh9QuyAxy3qXgaO63pct9UsrwkIoOnz59Qv4TCkCmmci2CnDFkOOfD7eAOQdeflyHnEg6wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/11 10:54, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> __khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
> corresponding mm_slot.  If mm_slot_alloc() fails, the function
> returns with the flag set but without inserting the mm into the
> khugepaged tracking structures, leaving the mm in an inconsistent
> state where future registration attempts are skipped.
> 
> Fix this by reordering: allocate the mm_slot first, then check and
> set the flag.  If the flag is already set, free the allocated slot
> and return.  This ensures the flag is only set when the mm is
> successfully registered in the khugepaged tracking structures.
> 
> Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for "struct mm_slot"")
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---

LGTM, thanks.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

