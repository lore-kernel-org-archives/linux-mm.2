Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56390606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fGEzUaEr
Received: by kanga.kvack.org (Postfix)
	id 7746C6B05B2; Wed, 28 Oct 2026 09:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FDE86B05B4; Wed, 28 Oct 2026 09:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F286B05B5; Wed, 28 Oct 2026 09:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8ED6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:12:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA08B40CA2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:12:34 +0000 (UTC)
X-FDA: 85372074228.09.3E47252
Received: from mta0.migadu.com (out-20.mta0.migadu.com [91.218.175.20])
	by imf12.hostedemail.com (Postfix) with ESMTP id 235B540007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:12:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fGEzUaEr;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.20 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793193153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHGE9nXbxuB8GQ9t8LPv8LBGWevl1d8ukNIHXAQHhiw=;
	b=b7LNr4zqIQ/z/z0TQkynArWr2jgi0t37TJ99mq7lo0rV3rPzenlILWg/smFchuzKIhx6kx
	AQ+UudDmxgchjgpFfrJwF+QNQtEv8RymFZhEJYbjteRbBImeLL5qpdUokhlrAmGfTv3Kyk
	SD1UZB4BZQ0XXDhb0YYXF7xKHFyhuik=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fGEzUaEr;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.20 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793193153;
	b=8XiKBrihP8Uf4LmXPdFYiA7g55/gMnWBEIlN4pfE2fwBqyQJMBkt1588yBS+mDW/cvutjV
	3LvcRMfGLMMJEVkOlf3kt7RFhj2gR4ffpSfZWPJ3Q7piBxP85R8JnTmNoYEg9exzKJcEFt
	8IZp0hoQiMPtx+eyirBlLnrrd5PHYdc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mHGE9nXbxuB8GQ9t8LPv8LBGWevl1d8ukNIHXAQHhiw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793193149; v=1; x=1793797949;
 b=fGEzUaEr8w61+lFUJkekZQi4IchHFI1oGuTpYnywD4uq7NYgtMIB4KLVEQTX9tu3L0+pzd7X
 uJGPjUqkyRJ7/LGJdP9Yu5YYeiFDulf+ETYGKM/YTzW7aaDU7ISl7xwUjOV6DayGav6115xQZ23
 2+9Gu5zJq6L2EXkbbQRvZNpM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id db747fb4ed3da529;
	Wed, 28 Oct 2026 13:12:28 +0000
X-Mizu-Trace-ID: db747fb4ed3da529
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kees@kernel.org,
	peterz@infradead.org,
	jannh@google.com,
	pfalcato@suse.de,
	hughd@google.com,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	riel@surriel.com,
	harry@kernel.org,
	apopple@nvidia.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	osalvador@suse.de,
	minchan@kernel.org,
	muchun.song@linux.dev,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	youngjun.park@lge.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	jgg@ziepe.ca,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 11/46] mm/huge_memory: properly handle refcounted PUD mappings on fork
Date: Wed, 28 Oct 2026 21:12:21 +0800
Message-ID: <20261028131221.42261-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261027-fixes_core-v1-11-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-11-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 235B540007
X-Stat-Signature: ubucwymufkmznwyckx6m1hog8tiresz7
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793193150-650270
X-HE-Meta: U2FsdGVkX19LNzMoCJqLaA7EialEorGlYf2tZP0XzVGrU9H8zp+X5U/ZeqgNRF3zScrqF4KgK5hNYvMVZJGEwPFI0CDzMz4PK5MZPjjVCpZvuNtblq7FLlO0jeb2x8IvOo1GECgGpJfIT2Y4UbigqQn0IR6aCtOcvTmWiSo2Ig1U2nP9gQjsM1kr0DCmzhAFgfOfsiJvKvr3eAOPh+5o4OAhZ/6Vhyzz93IZYP0179jyUqsxSMiL3CAToIfZ6Kyf86Vj0jBZiSvdu56vEeYJlbCB+4yWaPhOeVe7qHtFyfc3nWBZsxzonmfwetniCcEgOV2W1aULi1v6I8vrwgzmc+Y5NtpZWwIXOzY5cK8HL5L7bvP/Kc10CFT6P6ZWEbfYtfLGHou27Mq2HybY4BX+l5IcRO2BIILvULbjKIoVu0Yxv7exjjSbspyoxpQ8sFPUyG4NOlxcQxkNqGj5y0kqaQDGilcRo6+/V7OW/pQRnnQEXPEzxhl3nlfBTtV3pkrjNRpPpzSsHpas0oPCV7SgSPmX9P6fUkEl5DNO7uohkJ8sGAZ9nib9BwVr7xVwx2wtQQyEZTti/dsH0x6DCw8xuYdPQENushpAgNaBcIujrxuRjuBPI76AeiLKhE2weRAyER17TOQ52TzhV1Z2PFzzcgEyBQMoH1QFKOMBwcyhn47Q40/PMmyjENI2V4ee+hxuE+R+KDeWtNK5oTWHoHKV9MDCxJSzuI1lbQk9MYFGrmqEaHFF/D46udOsz4cOiStPiem37adQvtqBjYfbWnwsc0vyAOL1YgCTLSQ62IV4q9PRDlBipamTeItKLJF/QbWJsY2a+RQhkw4ootneNPYbg53ntALYkPq2Ct/aVDd5uCEZyrAGm0WzYQnmHKMqRMceeoOXjoorGiMTw56auxe7wAAdE///fjvzB6W3b9g+FJTDhTD5Vi3erdf8dGOzfK7//WmeJVFftPNGIC6oVcX
 QJj7dsLb
 6RY49no5Ki5e+y4dsFw7SmxedHux6Xu/dEQ4L/lnS6q7bp1pvli+/ErQk/fR2WPWjXWOlTuzlrgDt88y5ELwbRsZ7Yq3tC95+vkkPoe3B1dQVKfdGj5tKsioNT5GhgCmFikM5AKJV/jYFt407zMquiyN3dz45+azKHGM6T5aYjDiaUQniDSDvDn+KX4UhMUzoDDW5S7VDSdjSk1eCiseYV3tYbiHgKnx9x1AZWejus4RIxliNGWjVundn4mtmRaaNKsCNJC9+jB6XwBSRM+zwqF3RPJzj+ssEBMPmWO5PHjzPJclmrw7V4GLX3vBgbdYOQG2M5c7TLrJjgRvEdZw3v8mw6SZnBUEXTJBhAuUkBitYp60Ht1eyziHm854Ufv0qPCyE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 27, 2026 at 12:17:31AM +0100, David Hildenbrand (Arm) wrote:
>copy_huge_pud() copies device-DAX entries without taking a folio reference
>or updating mapcounts and the child's RSS.
>
>For example, MADV_GUARD_INSTALL sets VM_MAYBE_GUARD on a device-DAX VMA,
>forcing copy_page_range() to traverse the whole VMA on fork. Any remaining
>huge PUDs are then copied without accounting for the new mappings.
>Unmapping them in the child decrements accounting that was never added.
>
>Use vm_normal_page_pud() to identify refcounted mappings. Take a folio
>reference and add the child's PUD rmap and RSS accounting before installing
>the copied entry. Pass src and dst VMAs consistently instead of src and
>dst MM. Move the TODO.
>
>Fixes: aed877c2b4257 ("device/dax: properly refcount device dax pages when mapping")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

