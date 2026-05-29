Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7269CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 04:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32A1A6B0088; Fri, 29 May 2026 00:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB706B008A; Fri, 29 May 2026 00:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1016B008C; Fri, 29 May 2026 00:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5F86B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 00:03:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B19A91C0B8C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:03:00 +0000 (UTC)
X-FDA: 84819111720.29.2297826
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9931580004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:02:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OOY3mvD2;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780027379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eaGfYqsccDWsJTN0WYM3ff7hRWxPyaL2TevoJQw06eY=;
	b=mjnn3hd8/2Ug0Gw1jlDXpdUzTSvz5CLqtTeLQ+NDcWKXSFfR9rvR8QEXKnpuMNn6t8K3OM
	+mmqrpWqJXBu8h5RlbtIHjyBsmxoCc1z02SDkbJ8N64it15ZiW5blqQmTo1gtLRgRYJcp7
	1lERa74Hob1r/wPnWdPMjQX83j3cuqU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OOY3mvD2;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780027379; a=rsa-sha256;
	cv=none;
	b=rAcokl04DzD5OlY9k5tDgIXxe7wQLnDCoO88AtXn4x+z69JqCLFMAjXw8tdY+XxVPLVD1q
	CHh5RwVKbHnkkdYgNp00KU4/itA8N9We4+v8mMbddIUXgs/MdzuU9vL7dq16D1XW31o4HE
	uS/Mf++lAOc/+FmA3q1h2Y1RGnLZ5zY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B0CC16A3;
	Thu, 28 May 2026 21:02:52 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 82F1E3F7B4;
	Thu, 28 May 2026 21:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780027377; bh=eDyqfPL3Tk2ANdqi4jSCbSbhgcCNem97wosvoWpsFcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OOY3mvD22sd6y3WIPIIBcAbQvrNOHJdbg8VSwgi08Y8G4+HVYqhi78mSOgyEElCPS
	 Ro423BqzSe1PsgPppGukcVfWG5BAtkTRz5nbljRvC3GK70b/CNF/WOmP+OAVY9L0p6
	 3RicJRMfamLoi/GNNA6iHWitua0Dnln1bXAOOp9Y=
Date: Fri, 29 May 2026 09:32:52 +0530
From: Linu Cherian <linu.cherian@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC V2 13/14] arm64/mm: Add an abstraction level for tlbi_op
Message-ID: <ahkP7IWLX-0QCoul@a079125.arm.com>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
 <20260513044547.4128549-14-anshuman.khandual@arm.com>
 <37917d56-ae26-4789-ac4c-15f8ee12398b@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37917d56-ae26-4789-ac4c-15f8ee12398b@arm.com>
X-Stat-Signature: 1zppc86qjdyn5dprgcp7cbejd9ayj64t
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9931580004
X-Rspam-User: 
X-HE-Tag: 1780027378-635644
X-HE-Meta: U2FsdGVkX1+WFLc7lgE7zB5pXfc7YW/pybbg/+zpqGd6vP15TE1G0hDJ0tzYK3yi/T0miWgwaY5fYO7tNM/kRh94ZDRlqe8tEY0neW4bSrZXVYTiJgrphMuw+2zWRa7YwDIByRcHrPtLhneqEMt2w7aJfkUennoQOfJJH0rSVMwlt9qNGctzCQ3+CnoZqoPWDQhN7y2ErIqz1ZpK+YIYlkaqOsM+7NDuuKf/tjmk57FOE2/eY4vl94FTq1cCiF2JOHRhiPb9KQZRng2m6Gezmmm3rmSiRf52l6B8Mm//P3ZOlsapvUf9xyzXI9mkx+LMnYdGhi79N8IgAgqg3H4JhXhdSSvBowmoSHTXV8eCo+JDiTMt8ON5ruKue54ac7aknak5bke5sVfZLnARnEnnME+LfMS6etoWaULFgHK42YcBTxvuPip8YhaoGr7AoHByihDslBlLzwSI9xHLQTP5t+ANJEho6PdqvC8QDzxDVMnXizK0IS7VpOnfUqMt2jxyn/AAtwbYK/NrQWrxeJ0PdoTlQg6PRbOJh324QhV3PppXh19PrBqpv9/x0pqsxBnotdTLCArbE3Llv/zqNnXhWuQdGJnrkIAZ4KfSA6HufUU7zqAJYilUai+erWgDk2VrljUStUS32TpQSYOGL/mQNXNr0tZblcp55beUHMbCpTscs+Br+GIgW9wRM6oLMvFddJf9Shmt6HQzyEwnu31E9ljD7g0DQvSzWixl9HFK/1PHlMh/3WO1otlUBJC7v9mCRhghZVppRmndctrsI3+sF7MGUGmIXaQnwPG4bytvVfPuCO4CfwY4qkawTDMuPwxxmil30IuzxSVY871KVac4y7EACzwwXeAwHtsx9T5pPY8Q17hMQu8CtmIrA29p9fv51+fbGhze9SQXcJ2zNHXu/deYiEtv91i/ro4Yooo73mv2nKCdj9NexlugjGCgIhZtOhXH/ec74RUeVgAtURE
 +cpEgPsG
 88WWNDEVHyokmDU+0TexeZWJf8k/euAReIKBNpq0BeXs9E4j6mbfykwZlx4/1As83hapD8+EX62dBisAU1wmLBb9qBaZqel/pDZfdwHpt1/IsV+8E0fihFK4XqrNzQVg39UMkdQ6sIop/eSktbRPQz8vYB9hz7bKKuWFrluc+4yj0yuE22b+OUewXjN7IFPFXP/uUk79h7iBXk5ZGi2bBkNdhwtKAU66VMwMheIwbnodbxEAu8OPWqCpAc5ZQDA6BDdy3d49taS5CANJjjYKYQKUve4LtZkxX7kNhphwnNI8Ro/ldkQXl+eAP4uG9H976vwAcgUYMRRYQOaZMQsieXiMlqrHAaR5SxWxqAfHB11nSS2o8dcV6T2Qc/9kYxig1eOX3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ryan,

On Wed, May 27, 2026 at 03:50:10PM +0100, Ryan Roberts wrote:
> On 13/05/2026 05:45, Anshuman Khandual wrote:
> > From: Linu Cherian <linu.cherian@arm.com>
> > 
> > With FEAT_D128, a new instruction aka TLBIP is being introduced for the TLB
> > range operations which has an argument size of 128 bit.
> 
> nit: TLB range operations -> TLBI-by-range operations ?

Ack.

> 
> > 
> > Add an abstraction level to void (*tlbi_op)(u64 arg) helpers to support the
> > D128 variations when applicable.
> > 
> > No functional changes are introduced with this patch.
> > 
> > Signed-off-by: Linu Cherian <linu.cherian@arm.com>
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> >  arch/arm64/include/asm/tlbflush.h | 70 ++++++++++++++++---------------
> >  1 file changed, 37 insertions(+), 33 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> > index c0bf5b398041..361d74ef8016 100644
> > --- a/arch/arm64/include/asm/tlbflush.h
> > +++ b/arch/arm64/include/asm/tlbflush.h
> > @@ -162,49 +162,53 @@ static inline void sme_dvmsync_batch(struct arch_tlbflush_unmap_batch *batch)
> >  
> >  #define TLBI_TTL_UNKNOWN	INT_MAX
> >  
> > -typedef void (*tlbi_op)(u64 arg);
> > +typedef u64 tlbi_args_t;
> 
> nit: tlbi_args_t -> tlbi_arg_t ?

Ack.


--
Thanks,
Linu Cherian.

