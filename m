Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D871CC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 00:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3B96B0088; Tue, 22 Sep 2026 20:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55066B008A; Tue, 22 Sep 2026 20:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96B376B0092; Tue, 22 Sep 2026 20:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 753486B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 20:33:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F26E1120678
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:33:24 +0000 (UTC)
X-FDA: 85243153128.10.2F99A18
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id CEB341A0004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:33:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oRgWkLcQ;
	spf=pass (imf19.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790123603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kls9Aeh3ft2h2p7XC+gtGs+6aohVBMrr1+4HHRXk/ks=;
	b=DRRqzlAWfrTrpB/ag0tLid/XfrxhCW620X0LC23b4/Xz2kJwf/oqufz5p4uwiu8hp7djgS
	Xo20I8Tzi8KK9iMcs4i2/TcQInGrsIOaWnAiQgA4gqfCfBDBg2HtvJBzUAo+lmcXrbeQcK
	9NJtH9dcCTzwaMR+0AjrZ5rwlR/zz5E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oRgWkLcQ;
	spf=pass (imf19.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790123603;
	b=kaovJ2mYIz9iH5+RzyrYwzDZXrVt//pU36TigYFvm+pGg75VADkB74GBNAOwky1dFc9a2V
	AONTyCBdOZeKTzoM9XQTuli1TaF/wzxsXAjvfh3k9UeVxI2EqWX5wWCzXglPTyxnaOiQIo
	W559t5daV1nNFmiG0keW2M9hNRm7nU4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 223E51576;
	Tue, 22 Sep 2026 17:33:18 -0700 (PDT)
Received: from [10.57.9.113] (unknown [10.57.9.113])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A2AE63F86C;
	Tue, 22 Sep 2026 17:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790123601; bh=77i3zYEPqhl4Ykq7WhP+J7mIM1DnI3AO6zla9d0ZiPw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oRgWkLcQ31WqXE0HZzy2oda8oXCF5KyAJJ1hOCVglmH0esN1QobUgRqjxsKQ0rnUF
	 HcEHi0aN57b3J02f+zBZVVZvI20ki3Y3HdxMh4KN/vl1I33mR4KWfrvwABIFz7re3G
	 vAjp9bLwL/VO4cIRYlc8jfWw+ejPv0v1LHN4Olh4=
Message-ID: <19c4acf0-bc5a-4856-96c7-bf19c2d989e7@arm.com>
Date: Wed, 23 Sep 2026 01:33:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Content-Language: en-GB
To: Jason Gunthorpe <jgg@ziepe.ca>, Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 christian.koenig@amd.com, Joerg Roedel <joro@8bytes.org>,
 Marc Zyngier <maz@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Steven Price <steven.price@arm.com>,
 Sumit Semwal <sumit.semwal@linaro.org>, Thomas Gleixner <tglx@kernel.org>,
 Will Deacon <will@kernel.org>, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org> <arKsFofudnTYpXj1@arm.com>
 <20260922165147.GD1540250@ziepe.ca>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260922165147.GD1540250@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CEB341A0004
X-Stat-Signature: pijx3jtdkjm7itrcj47o5qy9xzuwehra
X-Rspam-User: 
X-HE-Tag: 1790123602-358853
X-HE-Meta: U2FsdGVkX188Qlk/TC/DBPDBOUwA7VvLFCQst9Ll9VdoRz74gnN6dnx/4qMfwzV+kZtCoIUswmKGVFNpyvYp6o0d6ga4LaJGV2SYYUypzQdqKmo4dYbAXJPncoIFEvzkaFVcFm7M5M7nh3LmyMSVz6W/k43tsBrfYZoldFmjp1nMgnc9BW+oT/LtLX6YnKglA5j/uN19K6SeAx4j5tofQPIrUgKCDBlJbDQucwbQTD5aYZPwJ2V2+3VJOV+QfV+wSmuBVfR+9U3syBcypMvrJKyA94DXRv6krz4VVvWyWaevmo9LjErL/hJzeLXvOHAlwnO5gLrwljBoGIAsZfCm7NQfhFUB5HsvLRyt4G6w7GXG5HF6fwnFJstGZtiyKX2wYHXlXCPWOcdYb+titIwv/FYwURDONMb4cPzpZYS9LLYt6kF0y4EZh4rZB4+08VwD+78G8//Ewmh1VPWx2pMkNLgFXQpTNp5xWosuyX7Dl5CAF4ZFvUy0mBgYbDQRxt0E1+u9YDJDJujYIKq2LUf4/Hl0qVgcZLMIlWQ3DvSz8N0tMvNOWyVcIYs714tLm9IaQ4pWftFmWRGIGkIh3BwvvViM4MuXxm/rVA+ErE7INfyiTLzpSuzt84VoEMOnulxYkiNPxUvspipNmo7YCARiowPRAjDGR9lWzD3EnZOGhYTmK3+oDcmo1rSmmv9MRFTesZRrU0iPJKCVhNxTSUvLkUGEHV6pen+rju9/53RMzX5U0geNxrH0XqA5nwknTfiJf7hntyoojPYD55gbromyfkCKBoFf/Ex9kUG57GTxTyzGl+2of3xPTbnuPjk3FS5he9oJpvtg/d9mJ3SrJbSdUBczCnaUgEyijuEg5Tfn3f4pqdKH+TqHxKpEdRVmBMkBymHE6Kdu95oyCad2F/2m7Y2d7IleTTNvK49k2KzIWjoOq90JcO1IAV/4huETWe/LH8VOjs6KmmVuuOhnrCU
 e0GzKRi/
 e+g2xPzpWr2qBZ25bv5XptJqNH5TSRMujAOrHxIIbrdzdelNT7BDq1aacI3Qx4YB3bdNypo2iEb72qrtPE+/xeqSH7aDvyykUdRF5O0/8HjvsQdLFxogP8d3OKvAYXK01X7HdftnYeL9SB8vAkgU/Ll7KwY52VRoGQnDcGahnnLgtCgyq+acrReotn/f6s91RDKkZ5RVH9239BNI9zxA30GTJJ6vqByNhGyhzQy6ShDIb0oY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/09/2026 17:51, Jason Gunthorpe wrote:
> On Tue, Sep 22, 2026 at 05:25:58PM +0100, Catalin Marinas wrote:
>> Does the memset() post sharing logic work for pKVM as well? If nothing
>> clears it, we have a small window where guest data is leaked to the
>> host.
> 
> Same question for RMM? Or did they define that the RMM zeros on these
> transitions?

RMM doesn't "define" what exactly is written when a granule is 
transitioned to "DELEGATED" or "UNDELEGATED". But does guarantee that 
the contents are wiped after the transition. This may be:
  * RMM writing random bytes or 0s
  * Changing the MEC of the location.

See section A2.3.8 Granule wiping DEN0137 2.0-bet3

Cheers

Suzuki

