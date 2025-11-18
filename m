Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D558CEE340
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 17:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9118D6B009F; Tue, 18 Nov 2025 12:00:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0B26B00A1; Tue, 18 Nov 2025 12:00:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6BE6B00A2; Tue, 18 Nov 2025 12:00:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 677C66B009F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:00:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F21BEC012F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:00:12 +0000 (UTC)
X-FDA: 84124340664.06.1D08795
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0F8F614000A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:00:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pxj6QtNO;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763485211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCP+Nm+VN78F7FE2AXTwmv3ib8RdVnuK4F0NpU5lz6w=;
	b=Yuc+MgEfsQVQ8wt5wLO8YW8SzZ6uH51KiQZvzF4p+e6RNbni4oTm0tvEr5DgU/RYJRd1AG
	tMO1KAwdPrQ5VKlSTLqqrqhwE5AulSErWrJzG0NB0SXn+desh3mvMWKbIXbUYlxHv7B9PM
	xDP22Z7UZks0/TlsS7XKC17Jvue9KM8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pxj6QtNO;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763485211; a=rsa-sha256;
	cv=none;
	b=y2tXzABrOkuwO2l3KghjfBupbeMy3Mv7NXXm8L4VBgc3UOzDt8uTYnSgbtq/xziTSTCv+v
	X6qDDvhHWdAjpi+XUcldBw2wvw5Vd2XEXkfh3uBfCZHcDbVqv5MBUQDJLsjYCXtb3cKOMl
	LZmAaShYIsHj6wsV+zMRLC56F8m7SWM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DAC3543BFB;
	Tue, 18 Nov 2025 17:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE9FC19424;
	Tue, 18 Nov 2025 17:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763485209;
	bh=eMXOpfkuXTI5FaAfyJKcxCAwZ6WjiV/oaCzvYc/j75I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pxj6QtNOYAMx/LP/bsd6ZLjoFMAiSu3cMoeclI8QN8h51Z/aCGbVsS844mSwCQgX6
	 eCks3Im8X/62poQI7bC5h71kWRv9RawlfKjfS4oI8r5iuF8KyZkYFiZ43kJNWeAHvS
	 znT6fAM0dE7XGz6YupPbyd1mDxxGPziGFKFwwwb3R8TfDB51kbJrruGmmoxk9IuHbm
	 HWD7Ud/KF5tDDozkiCqkhW0gKMVMYIQWWlqpL0P1K9YV1A1ZYkI3J2cKdKTHz+7vCW
	 MzaTyUlm2PVQVVgyoc5A+0TmFKCpT5vL6Yh/MjFUlDDyYO0IEcjlpRK2jrLm4wbMfs
	 w+maVK3m4MQUg==
Message-ID: <671477a4-242a-4ad9-9724-8cf4eb39677b@kernel.org>
Date: Tue, 18 Nov 2025 18:00:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: Mark pagetable memory when allocated
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org
References: <20251113140448.1814860-1-willy@infradead.org>
 <20251113140448.1814860-4-willy@infradead.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251113140448.1814860-4-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0F8F614000A
X-Stat-Signature: aqho1o3yxigf5qmo7g1jox61tjp95byc
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763485210-313143
X-HE-Meta: U2FsdGVkX18B7IfeF3cAC0gzsORGMPY386ERdeJRr4w9zRUZcHqN6ACTl8+GACDViHhtE15DF7kEfsO1ctWLIwNPWl+/t+H89uY8ijcA7cmqvaO6O2Xwq2xEEjoecliFtuofvd5/a7zXRSRiG1P5q2aclSp9/OQu95Z7NXwtPKnYgc3qAgwdVYayZgZuaYe8/RU184e+ilLduSpdzMgdG9uAzZaQP3vtDTm008mb0t6F0uvSy3SKF9vEvkFP8+y6sPmDXoNEyPPsVBOMOc19ByPRCwpcouUyCeC74qPeCIHdU912VIhP5tB0Im6Oe63PYtVR4MnHi4DoE3GKLyX+zZhw3VuIbGslCnQISpbmOeHZn9/mAmtfpLHsMquomeoYkNjv/cqThkiaS1iGnsEBs7iXbne+81Eau3tZYmdZDSME2s1LQSMELwJ+YvP11InhbdFxNt0obwwR8tJ6ZzmPis8Y3BIsypIRGcRODL3XdCwbr5VfEWiR0of8DhWkUUS3l0akfmmzKoHl7wXs79nBwn3e1VS4fY9g83tKpbQW2C7ipwxWFuVGwdsQB/RCv4JdTRwk75LO3XwcksGeVcROFBcyu/cZQJBLQxoUWdk3Cao57/2YiKkOugHbyP7scOrp+us+J+4QCAWAR3imhlWxKLjaYBl2O9jqgWFEloRAOYSZqOxGD1zV7bwVvE1+FBbNG1nUqnFpKro2Z6GLhmlmmdR/SaYGFPWKlhPlJPIouivkUF+Sw3lgcgmkEZGcl3t49zKzk42aTZJXtFXaMFQ704DGrWTznIHvJmRFn7ypcLAt2ZwSWaXmm3nrzeSRh/1cHtbpHaCnT4zR3L/KnSorTR2kKi4JPvwJalnhcgbuoMH8+Bi5zjVy3MICDo+84pHZ9uOD4flw9PoCZuBk4h1WCG+0X5CzafZWuVHQ/yTCK5OZ23u4lfysS1MS+x4gBzg4qUUDo8cBi/2p1XS5cPL
 vavTLU9v
 ncySJUCJNkI8I5Y8apFliGe4iaV3eqzQ1vdItgiN/BVo1fOtIuKNi7LTxmdfXqIVyxH7KL45sp0+s7qMYztOC2UEnWUhovseGKqHktTSsGRlMnQ4YWcpcugDBA7Tu7f8Q2J/bV2cJSZzO5ausfvnRFqXU8oxQrCoyURyh6YX7fF+zYgGsMLHnoiTcuykxJ38E5N7QUyZrzX18QbTIz+pf1sbiuKo0+hfzo6VXrdp8buJ3Ax2Dk11w9PAEWksBR8CAZe8aonUZX68k2q59PdYLtxLYtY/uh5GlvPI1tmLxEclcPEK2RZ7vDb5mGXsQOrUIb+f9gCoAJcxOxYA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 15:04, Matthew Wilcox (Oracle) wrote:
> Move the page type setting from the constructor to the allocation site.
> Some of the architecture code is a little complex to reason about, but
> I think this is all correct. 

IIUC, __ClearPageTable(page) and __SetPageTable(page) already check that 
no other/the expected type is set.

SO I guess we'd find out rather soon whether we are missing something :)

Moving it to alloc+free makes perfect sense to me.

-- 
Cheers

David

