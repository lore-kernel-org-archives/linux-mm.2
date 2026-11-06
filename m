Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3B27606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LVdL5OTg
Received: by kanga.kvack.org (Postfix)
	id F2F1E6B05B0; Fri,  6 Nov 2026 09:06:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED85C6B05B1; Fri,  6 Nov 2026 09:06:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF4E6B05B2; Fri,  6 Nov 2026 09:06:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDFCB6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:06:03 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42925140D10
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:06:03 +0000 (UTC)
X-FDA: 85404868206.23.A08A494
Received: from mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
	by imf11.hostedemail.com (Postfix) with ESMTP id EC38440009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:06:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LVdL5OTg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.226 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793973961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PuZSxoPIfBuBWYT5kGfR/wiii4e+fymaeZzVU1jtsaI=;
	b=8MU/EurQuGLsjpkk7IVNZFHKDQHJD4i1z2El+r11Ba9JcO87QO0vWCf0/SEt1qMvAi8C5l
	XXZgU8Wjc7/3pPUCcnDqnnyGER+5zFPrCStzGSbYHf9r33GBheDG65HD6Q668pWSm3ULMN
	0KUX9O9KWOArmWHqi80j7g9kYqiFZjU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LVdL5OTg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.226 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793973961;
	b=T6POFc+LPR16jfqQ7yVicOZw2dEREja13vU2mMoFrs65Ef4LASsuG/BniTztqSAItfyuDO
	ZTY0ZryJ9MIztQYl38kM8WROdBlEWyW444Vuo6QWENY/9oMNHSYu8RESrV4VDInPK6Uxoi
	OK+ommOzR0wlvTTB2Yz30CbMT0Xf11s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KdFDOOwfZpllsNIG61lzpXhrUDjzYe3zHf7j2d/rM0w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793973959; v=1; x=1794578759;
 b=LVdL5OTgDLMIMrDfJNp3W6jbpvLzebf6/nHzDbVsgTI0/F2WoQhDR4vMHHY/shEStctNJS22
 dd7IxwlftsFazxu7/U6NZrUo2Y07ny27+rcGp8oRXvl5hSd/nIpV9I9I0S59iRX/LC+xgzdwdnv
 ibgHVLBtX3zy2134lTvrWdOs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 5b86ef43620373c7;
	Fri, 06 Nov 2026 14:05:59 +0000
X-Mizu-Trace-ID: 5b86ef43620373c7
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	jbohac@suse.cz,
	david@kernel.org,
	hbathini@linux.ibm.com,
	leitao@debian.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	linux-s390@vger.kernel.org,
	Bradley Morgan <brads@mainlining.org>
Subject: Re: [PATCH] crash: keep crashkernel CMA pages reserved if activation fails
Date: Fri,  6 Nov 2026 06:05:54 -0800
Message-ID: <20261106140556.1667159-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <0a3c64d1-2b8f-4e0b-87ca-5397d1aaa3ee@linux.ibm.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EC38440009
X-Stat-Signature: wqhxgggegtjc8pyzktic6poqj97go6s3
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793973960-29892
X-HE-Meta: U2FsdGVkX1+bbOILmLfOlERBVnNroWLMLf9/etnfUgjVjtwzVzfLmSzhblKzQzZVtuYggGDKxOoh8WhDmlnccEahWtL9I++lzLRDJeoJ/ddHA8TWqzPi9OcEJWv03r3jWfsL7g3s49Nwly3rx4ngtBiWDBXLX+B4idNOx2iIj2wQptLAXebdSoizwqDQYrGpJPfAbNnevEuEPVko+YkKbKd6WoV94bYL+mYpMgsMkTLDp8/jjlB18lTdtevGqytXsPzYPHpX+6QouWwbLAEozauXHlmGi/GhzMH+8KzwC8ChUnw7Pa8ZD48M2YK+CNE5c09mLSh2W0EaxXkp26mxmcsmbG+Mt/tTzDKghnvi2U3fLxA/8+14TQ2oaWB9v5UUykGvvQEUoUIs+9jXLjLXRpaaZyfbKpeVaqFIC15YW1Lmog/y7YtPPk/+XrkdKuIZ2zJ5qVvgJrpphTB2CfjL6YMHdd9pwHG4tJ+BkPB8nbx0v9zFAsyHLlXEWjgbFCVLilx1xurzm2LwqenltQy6xbSCpeVl668NQY8222En4OtlLIdZXTePbKPJj5UpUNZ9Rxahq0POy42o4IJtC1lPb49FKi+Wy2Ljm2+EnPZdZBmGuAwtCuOoG4C2PGSJLWRVw76Hp/CNpqkQMIJMdnF9FGSx4vt8QUGpHcgjTSWF25LOLFg6EolohEmfoapMJTDLds2kSMn06DYfnBiVwG9JP43teAPIAyEVqF/jrks4QU0YZazyMd73rwzEwKwpkDAtyDDWBiZyQFTlv/N7/S/Az9x40gYByk3NFI+ZKUS0UF4fOqntPz0A2FEuHm8XTe+dYlIzbHxYSr9jT+ijG4k+r4adj9Y0hueRMVuCLjheAmHKXix2xQ8pEA+Js290JxtnPrMeI1aRhjL1TTQUG1B/lCNDAlL5C6LrcxfXyqxLIT8LS2PA+hKlRZ3iqQcSV+lYV6I0k2UstQ2hmWYPtaX
 d2uBCydC
 BLXohIie6DO9l/BhI82FWk5RdEyLoPc2nabp+QrfVjiuue7MUcLl5wPrzrAqsiwnGpTn9YralQ8qA9xTIn4JDKRPwwI+WTLO3IV7lLXYrW8OBxPBvwMosumykDPiRjvwapzxqGJt4G+U2z+20TJp+BaLJlfmvmf6/NUBzq+hslWWP2OjacxzhcybeZc5uKvPMvb70M30Fy9HWnDE6hFyRs6lGzmPsRrxv7vQrJSX+34tVBJxagQNPZX5FLh3afdTOs7/BZCegDkxozWW4y48ntvgsow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 6 Nov 2026 12:21:12 +0100 Mikhail Zaslonko <zaslonko@linux.ibm.com> wrote:

> 
> 
> On 04-Nov-26 15:56, Usama Arif wrote:
> > reserve_crashkernel_cma() adds each crashkernel CMA area to
> > crashk_cma_ranges[] as soon as it is declared. If the area later fails
> > activation, e.g. because movablecore= put the ZONE_MOVABLE boundary
> > inside it, cma_activate_area() releases the pages to the buddy allocator
> > as ordinary memory. The range is still handed to the crash kernel and
> > excluded from the vmcore, so kernel data that lands there is overwritten
> > by the crash kernel and missing from the dump.
> > 
> > Mark the areas with cma_reserve_pages_on_error(), so that a failed
> > activation leaves the pages reserved: lost to the first kernel, but safe
> > for the crash kernel to use.
> > 
> > Fixes: ab475510e042 ("kdump: implement reserve_crashkernel_cma")
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > ---
> s390 hits this without movablecore= (adding the s390 maintainers and
> linux-s390) since ZONE_DMA ends at 2G here.
> CMA tries to reserve areas above 4G first, but falls back to lower
> memory when it doesn't fit, so a cma area can end up across the 2G boundary.
> I ran into this while adding crashkernel=,cma support for s390, which I
> will post soon, and came up with the same fix.
> 
> About dropping the range instead, as you offered for v2: I'd keep this
> version. With the range dropped, the kdump kernel gets less memory than
> configured, and that only shows at crash time. With this patch, the
> the first kernel 'loses' the memory as with a regular crashkernel= reservation
> of the same size.

Yes, I do agree with this. Losing memory in first kernel is preferrable
and it will then force someone to fix whatever is broken rather than
finding out when their kernel crashes.

> 
> There is a second problem in the same loop: all areas are named
> "crashkernel", which breaks the CMA sysfs and debugfs entries when
> there are several. I've sent a separate fix for that:
> 
> https://lore.kernel.org/r/20261106104309.3669583-1-zaslonko@linux.ibm.com
> 

Thanks! I reviewed this now.

> Reviewed-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> Tested-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> 

Thanks for testing and reviewing!

Usama

