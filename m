Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8249C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 22:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EF846B007B; Tue,  4 Aug 2026 18:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0AF6B0088; Tue,  4 Aug 2026 18:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7736B008A; Tue,  4 Aug 2026 18:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 668536B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:47:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6F2BA1928
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:47:36 +0000 (UTC)
X-FDA: 85065075312.17.3109D40
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf18.hostedemail.com (Postfix) with ESMTP id 51CB51C0008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:47:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=W0VwktCK;
	spf=pass (imf18.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785883655;
	b=xcHXZYuiCpQ/ukk6OM8mYG22XkS8y6AgDYhf4dySnT6w7YtbrCFNeTmg0/Ptmm8nuJkQW7
	xZpPwRUuk0krcM8sz0yaIGeIOEK50X8S90FCOcVyN9TrX5TMUGkxQ35zgkInO0gQIngSy3
	hm4IUgN+w9cCRoBLcCdW7Ead9GJZRXY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=W0VwktCK;
	spf=pass (imf18.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785883655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I2YxfmSarHgpb5HO7sz/zNXl/cJmHFZ1E8d5kP4xEXI=;
	b=LrqNs43uGUJc71D3dXZNlr8HNSYyLfP0uFxtnTnm/QTiLF683eLAKNpeN2XfJ5xsdaoyt7
	6YSNJu0Hqpac5V9F4TO6Ep0SaGHJMjMaCgxKlP86eZqesmHfWwjjKAqH/IEYesuzJS6Il0
	kOhrmkRvwsoej7NVUA3GtVhXO1QPaWo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1785882922;
	bh=I2YxfmSarHgpb5HO7sz/zNXl/cJmHFZ1E8d5kP4xEXI=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=W0VwktCKoSSQVpgdNLkLAZweHK79azHkGFZRIN6itAo6aNsh+RGZl4Qu7HXWbFaFF
	 dz4CIbhIQ+BtHYOTTix2WBEzzrM4PggOvqMmlkZqu0IazIRpgcE08l/kX+mCF6Dvy4
	 yXiDy6MGeayqG0jAMD8mAQ8bY9zkobyNqzP7exW8=
Received: by gentwo.org (Postfix, from userid 1003)
	id E414840FCF; Tue, 04 Aug 2026 15:35:22 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id E2E4540287;
	Tue, 04 Aug 2026 15:35:22 -0700 (PDT)
Date: Tue, 4 Aug 2026 15:35:22 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
cc: Yang Shi <yang@os.amperecomputing.com>, 
    "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
    dennis@kernel.org, tj@kernel.org, urezki@gmail.com, 
    catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
    hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
    linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
    linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
In-Reply-To: <94c7988a-3ecf-4b26-b0a8-011bdc76283b@kernel.org>
Message-ID: <29edec61-8f11-b9b1-3df9-2a51815ee771@gentwo.org>
References: <20260715180455.515692-1-yang@os.amperecomputing.com> <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com> <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com> <amCPBrdltFSE_fEf@J2N7QTR9R3> <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer> <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com> <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org> <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
 <anIXr4Kbn59Ac31Y@lucifer> <69f4cd9c-bd6c-4e5d-b8d1-a7be8408a57a@os.amperecomputing.com> <94c7988a-3ecf-4b26-b0a8-011bdc76283b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 51CB51C0008
X-Stat-Signature: f4mqz4boust9x7haedq9iksck88xu8gz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785883655-229610
X-HE-Meta: U2FsdGVkX1+bh1+Dd9d/qTXG/eFrk4A0E4J9cQIpVRT/YeQq4XErGSS9evUymIL2XGRSO/9e3QBzqt3eMJ5XW2RISacMwVjAhK5IOt/XAk5p4vSFPMPIuxNvIPmDf2cZOY4DFoc0MQ87eCWLelarBNTChzpVcfjcwIeBiHEcvZo3Zz3GuxUTl4RDPC/BEuTznLbbFeQocNw8DgIBccm9KKlw1VllaMo3LwcOt5O9OPBQxw9U44SB4W4YJGe2Hg3Htl4pqqGdApXzzXI1iYynRZ3l4fS1XEVWY4AKr+SLTOnRRoccA6foDZbKChe5zmSKQJRxADmo7sYW2OxmfbAWkulOkZA02O2sNo/y6v5O/E/DpgbALr20hOEN7OOH/pKr5XxQK4jZ97DNABgaeBDj1z4FouGm5pFvOFYx5eHZthvOYXxuwnUtrjT3F2f7v5pluOalNigTY5VfCdO/IZSZ8cslkZx5UAyUB0abv1hKSF4XKbikLpsXcL2guuQexXEDzto+GMNE4NpWxtRsCp17BHj7Kyw8GQl5byYqU+JHPpRBy5vkMQtPCg8W43hYxWOBAw42pu2H4A6qRoet1gUhC3kCX5Rnl9+cg8kP4UQ20rAmkPuRIpuGnS/gC4AgcGsoZ2Tu9PCBoL/y4xD70TsJD+zbovoQJras5RY85BLHcDSbthQ8ToQYGQH00lyAS/qw3I6gzeYvd4rkBZY484YIb2N4PFPIBLNuqnGM/aBKgEMfkHgz8IWlvbfZbZjNPAhTFSDVsTOS8C6eCPOmr98pYwZTP2BgjvmPq6FOCkT79306+m/iI2UqfrigN2MpgPGhWX0zdos0j+jjL69Vxhtk5hInytSnH9G9+V/OmRO53OmzxbFjK3lgavtw6bg0SXzvOOXorT5jE2zlRDSdGn+HW9G3f+wvrU4kHlWe9QswfrqqyYIOxcWr8ZgT7+rTrpaVldrpFgBsOEM/LuflEdB
 WdxrFIQw
 OJfRBU+R6Z1D0JXxWAd7/pEhzvZah1kDjjrB2v/4tCn373RCfbDd2Ic8sxzUItWvdnMOaQ+zW1AhkuOpJH2nh6S59GZFizqCnztypFqRS0MTesUN3JGE+UuasSuEoG1q/wqLUBb7SXqOTNaxftnd34/YY4ff3Fnu1ieXGdIr5K3re1bjTX8eZUpWtIcQuCxZzadelRHfpDMLN83fmEn4SSqA375/Z51mbJ7eNVJKzm4y8mG9rvyy9MSVmKpaVkAPcDfUV38KXLeg6N6nJtt5gBIjTJBeyWpDE7+bN05kHALjUw38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> That's really all we are asking for. If there is a measurable performance
> difference, great. Share the results or point us at them if we missed them.

Scanning over the patchset: It seems that you are using a special
instruction that is unfamiliar to me. Which processors support that?

