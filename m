Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A028D606D807
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 08:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hwgvHP45
Received: by kanga.kvack.org (Postfix)
	id B9E256B05B1; Fri,  6 Nov 2026 03:51:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28326B05B2; Fri,  6 Nov 2026 03:51:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CBBF6B05B3; Fri,  6 Nov 2026 03:51:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72A2B6B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:51:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E5F8A831D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:51:00 +0000 (UTC)
X-FDA: 85404074280.14.E1E0CE7
Received: from mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf07.hostedemail.com (Postfix) with ESMTP id 359EE40002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:50:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hwgvHP45;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793955058;
	b=E6vKhhnlm5YNoLM3hV5HOLbVw6gxK41scl9dpNMqScIjglxtnPqU2fWXolKjH+9yR/Thjw
	VEwr+f3y5aJ+lIWHEnbQsxQxIOISzTlqDx/kDKbisO5FqRzSxzcsnH/HReAsVYz8qzZ/DZ
	f71uxKOJ7ZEK3yFDRdqCtIxvyzkj3HU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hwgvHP45;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793955058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MaBpahE5on5Sl4GYtu75lY6Lms5s0cdDMV8oWkRKTUc=;
	b=fN5o3nT/DhxhZEs5TDQ4EYXMCZwcw3GuC2JPxkcVD4wG4b+Sw5oidAJ5PsUD0AAQRkmGOB
	DPEQtaUWxkw0clZWbf+TqohxgwnQ1HcQfqCtrHFP2bzK0kGW4M7yHveB10ztJAezxXxwDX
	P/VFgJvF2Ybn2DhQqgD/SfZ4UZ9x+o8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ws20T3ir/rSpZSbCcrdGuZ9EK9Lt6saLzdZjYEVOCZo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793955056; v=1; x=1794559856;
 b=hwgvHP454oznGGxqb9vavzgk5HJtDzCEynbqsPa5GrkJ4G9+K4zF4EmsHw3QDxrkNyU8kVwE
 b63VDpJ1Rj2HCyEJU3Ibum6MbwJo/sMDmg6B2OGG2N9xgeGzWmIeuenrhiqy7u68nhOmB4CkICW
 PmCcnc8rXGAd+gDNeV7Xq/ek=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 4b52ee87e83fa511;
	Fri, 06 Nov 2026 08:50:56 +0000
X-Mizu-Trace-ID: 4b52ee87e83fa511
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 12/12] mm: hugetlb_vmemmap: make vmemmap PTE conversion
 folio-oriented
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <auxL1Q4S9wllEn6B@localhost.localdomain>
Date: Fri, 6 Nov 2026 16:50:37 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <22FB374A-CC9F-4F9E-B510-88F71EF89119@linux.dev>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-13-songmuchun@bytedance.com>
 <auxL1Q4S9wllEn6B@localhost.localdomain>
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: 4y9dtiwhbc6qc99ze5gd9x5mxbuf8nwk
X-Rspamd-Queue-Id: 359EE40002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793955057-358164
X-HE-Meta: U2FsdGVkX1+ds+R9m/46eHFrmwR1OXJgnT3oq979BiyJPGCXnTF5bj6iHEiHtU2uy+7DbvfnF65/Rndg+iLpUbYZkPy8NAwrhU94AwD1Bq3/Dwv7BqIGLHOvq5tjAKuN8LH9CijhxnJ2BbrTSBwTHoovgacnddrsndk0BSODUk07DxzwsJPGW+8x4gdU8iO0HzNx9+WdDIjmwUSPc2vYvx7J0mDiTRdaOp6zKom5+WA/k4Sbg0eIqFp/7UotUsW7aguzhCnUZu1cn8rH1PPDX3na0990aW5/bJEbUoGHMWwrgWAL3pDqBALHaxVdPN+0m8LlzBOHlz6uSl4H7ZpZZhtzmgWpOYATxtBpMY4m4YfmqPJtQFCrp/hs2ZLxJgBUluClk7dAcFPCd56KRQb2CXIFSQjOlI/qMkUHqLihrg/J6npnfNrdGVLUmCMqfax3W50LQKsiewplM5czorBG3OUFmetAlutbwJUvyX260Rd6P+ckCAs9DTedo5gm/BtzUMpFzhBQEyGfxJT0DOpBFmEz9ka/2pqomWr+PBg6IaniW5Vw9jx5s/KfaKpEB86diuJrX+ucpIX956Uk37ens2JEPrP1eLRZnl4Uu2cq2HwOdD+hdaGFl2vHB+pf8X6NAaCUP3j1c3CNVqPZu00aa7WIDVdP8JT4YWI1ZQGOfQmD2P7Th0u5MdK3VPCmIx/n6dl3aWPD8F1RbQITUqERMRVD3J7yKAlor+A6noyMVD3E8Wr7FZ6KH7WHCqER/o239/MmqDdpcIWy5Mr2jaFcPzxnTGFq4sPoy8kkj4zOi+w3n6SPEz7iVLobt2w8sHDOOcMRJ+66IIe5rQwk431CDRO9r5TlK9sl/zk+p3Hz/iDJmfv/L+X7gnOUMu0SrJLKJyN79CCJipI+WRafp6WeIzMWvx6bFanhHahgzxwCTzbjSVn/2K/XDCjPhtHzq2ZZ/wFgAAl3QwqzCy7qx1/
 1gjoUh35
 Z8/Tg2mYE8fDndw6kSsOj9NuWNeHvRDGSfW76Er6Lzbt9lUe1L3O5DqT78iJAWn4jke7K6EkWvxUY7B+OQg7rn+13A4i1jqYPQ3UK9uLfT96pBgU8jCDC9A+aKrzvXvqVdC8xU8MYsKu5Yr7v0jp+LQlY1kv73DyfxJKSKIJWmGJZ3egswfYgzoghgaGHh8xOTWmEZW5vN4FemDS+/qkkXHIBSlC6yO+2kS5wtcpoEeietE/6//3sqJm60cMs1Z/DIV951GCsiv59hydJlUqB+auMSUMq9RCa0XOa6IOI8SffkAgBSXEZBV/jWpaLnpnC5hUFNXAilBWx1um/R8MTiXTauLY0uFlA9ipQ5rz+OPxjET4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 5, 2026, at 17:26, Oscar Salvador (SUSE) <osalvador@kernel.org> =
wrote:
>=20
> On Wed, Nov 04, 2026 at 10:35:10AM +0800, Muchun Song wrote:
>> Converting a folio's vmemmap mappings from PMDs to PTEs is a =
per-folio
>> operation, but the current interface exposes a raw address range and
>> hardcodes deferred TLB flushing.  This splits the common mechanism
>> across layers and couples it to the HugeTLB batching policy.
>>=20
>> Make the folio the unit of PTE conversion and let callers select the =
TLB
>> flush policy through the folio-oriented interface.  This keeps
>> HugeTLB-specific eligibility and batching outside the common =
operation.
>>=20
>> No functional change intended.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>=20
> Reviewed-by: Oscar Salvador <osalvador@suse.de>

Thanks for your review.

>=20
> But I have to say that I would put the vmemmap_optimizable_order() =
check
> upfront in the caller, so by the time we call vmemmap_pteify_folio()
> we now we can proceed.
>=20

Since I'll be sending an updated version anyway, I'll also remove
the eligibility check from vmemmap_pteify_folio().

Thanks,
Muchun

>=20
> --=20
> Oscar Salvador
> SUSE Labs



