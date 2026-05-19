Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B1AECD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 21:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A0CE6B0005; Tue, 19 May 2026 17:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952066B0088; Tue, 19 May 2026 17:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867A06B008A; Tue, 19 May 2026 17:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75BD36B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:31:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFCB693355
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:31:55 +0000 (UTC)
X-FDA: 84785466990.11.E7FB4D8
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf30.hostedemail.com (Postfix) with ESMTP id 006D28000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:31:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=B+mskFBH;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf30.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779226313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDOxef5VgE9q6PGt+EcpRUMORdnQdt+aE9nFc7P/LG0=;
	b=RHY9Rz1U62irQGfJR1FTbhgPryPSirkkELcf6rBfSsHx6DMIKNXjxlRs+1A4Zpapyiy7sp
	ji885vmi5O52Sz8Eh4jGnAU8L9j67cQwMfnFHcJIRCQt5J5/a/lf+wlA3O4kWEOO60+b2v
	xV1CIQa3IfFlgsfhvkEulnW7klJGmS4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779226313; a=rsa-sha256;
	cv=pass;
	b=jRkUMLMcT0N4IIdTOS3qDPAWlnIwDHO3VRYdSvBl8B+eV9IOsA0WxgXd8LYCkIMOeCR3R1
	HuBTNoUdlXvGsevVYbK7fZEdPyBdSGc8ap34Uk21hL0UE+ljXN2cpyiokD7KsSxklGJnWT
	adEIVV9AIy884qnOWXNS2R9dh+Bp/ZY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=B+mskFBH;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf30.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1779226291; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=JhERJa62mqDZAPX1vFvgoY8FHQ5oKaw0e53T2C7lyNunQtLi0MPv0BdXC2E4HlXq/2V0VXu0/k/6sghSqiHYXOxBQO2/EOEvErpnTUS4mTUrnUKNDizUwdAkCu6EMdAz1tqB6FTyy1aDu7wkGmqsskCfMEVCBbWgfP7QVko2SqI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1779226291; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=KDOxef5VgE9q6PGt+EcpRUMORdnQdt+aE9nFc7P/LG0=; 
	b=abb32yCq3CAoLP9k1+eZaX4iaB/iQf1qFyqt2ODJWbfOV/Wb02AnThTaxQjj83b+lqzWhHe2njywowGWvOu7Ty+vuFOUy5Akbt2Lcn9wmDVKPTt2vt1fRY5YNyzSDwwOOmDTHzYIKFu2sj1xwR39yzqLBKygYJ2/sOsCYYfn2/U=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779226291;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=KDOxef5VgE9q6PGt+EcpRUMORdnQdt+aE9nFc7P/LG0=;
	b=B+mskFBH8OQWY+Q4Vtfyfifwn8XtiyQt28C2K82gt5ITY+enn/ZwEZq3Z1qU2rBB
	3LHFw7rw9bkozLTvTrbQ6OSx1+V1/oexzrrk4TBSp1qpZx2W3nm1C8uoNE3VpuHy9jk
	tJwwXsFAWzFEa8FXFan3kRPZ+AnlffWvpBbm+U1w=
Received: by mx.zoho.in with SMTPS id 1779226289056326.23080929201944;
	Wed, 20 May 2026 03:01:29 +0530 (IST)
Message-ID: <2462e6ab-3679-42c2-b553-afa44342b479@zohomail.in>
Date: Wed, 20 May 2026 03:01:28 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 0/5] mm/vmalloc: free unused pages on vrealloc()
 shrink
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in>
 <20260519110743.50a2ccd2489a05be6e056703@linux-foundation.org>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <20260519110743.50a2ccd2489a05be6e056703@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: 006D28000B
X-Rspamd-Server: rspam04
X-Stat-Signature: cx8wgsdnzdr8kgshis949dojdo9ieo64
X-HE-Tag: 1779226312-523778
X-HE-Meta: U2FsdGVkX1+HBVKEVqk4cH9UoTqIoYyuefgDLUOFXWzzovcQPmQBqBWj9E277iBQub4beuGTG6rihuOH664cCS3BJJEBHOZOInpvxja7A1s9JOviFumekiwF3zVvJ15W3cU3GpzgBhwTXrj2F+f9FJFFGVJ10ZXGhwLqpA7tqenQYCf6u2oboY1Dp2CZvjAtgOG+s0H3J7osAreuUIjziONQaMiuXR6KABDOBFevJrJkvx4tW1ahYzRyT7Mi8Fe/fEPFAtCiLTlNpTmfIV1RpTwapvaSgQ/uyvzx+0tzQs8xqgjzFkjKTrcaf5E6ZciqZbgbuzGfdWqRcxUleyv06xUTm8ecillhs0k+Mlx+M05jcIBMXHIAdIDsTPduLq6RHnSgZlqIaT1KXy375YgiWQ6lvfaRKYIn+Jm2MA4RhZzw0fR05/4W6eM+lGHMBt9wA2NdV3qy5HzBl0jj/wLYIYGkkFe+8EOFR9ge9eLzb/ucDE6nqvggmJEaWfmgt2lbyK+k23S9Sm3WFHF+DP/By4m+srGTbtMi/AudHHdhjzIC6MfKpWSuC6d8pe+8gT4V0VNy3p4Ub6afSfA70GBcwdTeAfuQJBak1r96SSpzc/xLTEJXqPJrXX0e9HhFr4SVqky5u0NLmAz3+qcyrA+cuH4ffMebxz+ZltkXnBAJ2gBK2xm3I3OQRbru6LrByFCT0ODOjCYIwIDVUWvL886BZf1wC/Vl+4Os4YyPQdCM53pZeevrqmXHEybsKfJLnlDdwvL6cOzkwOpRDgpY8yJsZwVSA6FVFb1YCEn1MhcaD1+3MC2O0BDcoj9ZbzlmBuGOcDoTz/zrQJyQ3RjgECchPDeq896B0k5y0jcQpt2Z6p0aXI1WDyieAx6X4LD0uj2eFJabOpS7t2rpnjBmDaBnlczGBRWe/g7aQwYEmWttpMdV68SIsj069qfTGKfbF6ou54WmNZBVtYYG5+Kqzjy
 0BGmpcsy
 hFFaPCXmKSYccGR4ycYWk2heeZAdIdN2PjmFEN5v76t5LKWJaxssteCBNX/WcXBqbTqWzN5Rls3pv1cfCctL24SMAZfye6tqgmgHLkWflcoWeZaO1QoSy276SQUOzXASh3FLmUEJPAclAjBxlMJIB5tZWTD6W+UzjBko7813ch+c2zGj897LrbQlWOjQsqnj5ArTCGuDcrOdxW/AIbQH75iURk1vTEpDZNNc486NjZyDDmTML1/wQnPEwbctqH0qjh+btczXg0Hag+j+Vi02i6x3RjE7c8CFVbiJnx2Ydk9RBsgU5QZlD9H+bUUyMFXvuYhQOeUxEN7Y+g9Uo6ltnxn4UuQUiVMGWZ9ct9smA/qpU7HnJcfD4yOztjF8DOzjMWFl3U9hksmYII6tJkgstbGB/FOorMrBJkb9rm9aZU659kOXzBkk9P8PjmSGM63+4/+cdAJv89NYL+XPAl1Pwctr4olmoCXuufVsj05AC2mW3xWVxj8YzWcbqRsrcbAuaV/GcsKhXA/xMlSg9+49Y+eak+3GN2NLiO1VN6kZG15ulLqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/05/26 23:37, Andrew Morton wrote:
> On Tue, 19 May 2026 17:42:13 +0530 Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org> wrote:
> 
>> This series implements the TODO in vrealloc() to unmap and free unused
>> pages when shrinking across a page boundary.
> 
> Thanks, I'll add this to mm.git's mm-new branch for testing.  A few
> days hence I'll hopefully move it into the mm-unstable branch for
> linux-next exposure.
> 
> Sashiko is still saying things.  Please double-check that it's all been
> dealt with and there's nothing new in there?
> 
> 	https://sashiko.dev/#/patchset/20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in
I've reviewed all five Sashiko findings:

- Issues 1+2 (32-bit shift overflow in nr_pages << PAGE_SHIFT):
  nr_pages is unsigned int; a pre-existing type choice in struct
  vm_struct. Uladzislau reviewed this and explicitly asked to
  drop the (size_t) cast in v11.

- Issue 3 (VM_ALLOC areas with nr_pages==0): Valid point.
  pcpu_get_vm_areas() creates VM_ALLOC areas but manages pages through
  its own path and never sets nr_pages. With patch 3, vread_iter would
  skip these areas instead of reading them; a minor /proc/kcore
  observability regression. I'll send a follow-up fix to fall back to
  get_vm_area_size() when nr_pages is 0.

- Issue 4 (kmemleak scanner race): __delete_object() clears
  OBJECT_ALLOCATED under object->lock, and
  scan_object() re-checks that flag under the same lock after
  cond_resched(). Additionally, kmemleak_free_part()
  is called before vunmap_range(), so pages are still mapped during
  any scan window.

- Issue 5 (__GFP_ZERO on grow-after-shrink): Not a regression per
  Sashiko's own assessment. The API doc already requires callers to
  consistently pass __GFP_ZERO for every call.


