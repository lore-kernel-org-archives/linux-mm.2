Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 978D0D6ACD7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDC896B0088; Thu, 18 Dec 2025 04:33:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86576B0089; Thu, 18 Dec 2025 04:33:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7F336B008A; Thu, 18 Dec 2025 04:33:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3DE96B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:33:23 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 868B85D313
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:33:23 +0000 (UTC)
X-FDA: 84232078686.25.1EB1A72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C20E04000A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:33:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oE3IuCqK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766050401; a=rsa-sha256;
	cv=none;
	b=GYOjYP61VAr05WQaZys1D26qG4F5RxUYBLqbah0na2Yqs+4lHF5o2iJ9DHykz+je8e3IxF
	SqjjPRJY+7jCBLNpk3N0wGMF0J56a8Hw+3zI/tTWnHcE26vrrNfT5oqEdFx7oSvBqndZjE
	P/uN95Dbgj2Wt2xMpXOzyu1zHBSmwQ0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oE3IuCqK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766050401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EYqyAQcZ0t28RV2WAum3yEvgrupZCWma+9Qd1WBqQTk=;
	b=7wY2tF4kxZveKBhxX1r/45QKwaHBX43vJjsvixD86Ld3xeAGhSpJVCQoYZZ/O/mhZoEB7K
	a1NkbY2e6ViFrOy4xtjpAum+D7o3xMGblW9tyzw5+k+849ASjJNm+QdKLRE1WuF06Xsrpo
	bVMV6mnpuewtDTG7uh9DsYupig5TWws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4B94404E6;
	Thu, 18 Dec 2025 09:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E183C4CEFB;
	Thu, 18 Dec 2025 09:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766050400;
	bh=L8BJRVo1tLN2SwwHEUQ2duZ+GDJlKDOk1B9Tn8CK80Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oE3IuCqKlINhrjN+LbsSoFCb4Fk6JTMP3JgEpmraKrWva7NphDNjskczSajTGp3Ap
	 rgKU9CRcmqVwfBciC5u4L6LMEnsq0Q4CnnpLBzevTJomAG945kJUkP4jRys9399GqT
	 WYYPmW/UKoK5iz4E7ahj0eHx19NmMXjsQTZqzR1QdZYy8eQJnQSoMvaqnIQ04R5wrd
	 TG+m4InTLhOtUn0l06CWiBCGiHp+7h6VHjmeV5CY65sR4eXAYoMtcYFhe9feK8KiXB
	 LEK3QkwBRwCHyE/LcnOc7IVhPLpXSn1sUAaqS64+xfc+dqh1iMc+SIXEMYau8fup3j
	 myWaBWCkb1sLQ==
Message-ID: <11025f1c-88d3-41a9-8290-21a9565e9bc3@kernel.org>
Date: Thu, 18 Dec 2025 10:33:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: khugepaged: set to next mm direct when mm has
 MMF_DISABLE_THP_COMPLETELY
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, npache@redhat.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-5-yanglincheng@kylinos.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251215090419.174418-5-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C20E04000A
X-Rspamd-Server: rspam03
X-Stat-Signature: mk7mnaz6uimzfyt86176im533zbfyzpa
X-Rspam-User: 
X-HE-Tag: 1766050401-103012
X-HE-Meta: U2FsdGVkX180lehcK26HiqFGWuGT9MQOHeFnm/vSe45xMyQYNmYlZFopnqzSQ4MkKbBUuF505bFg1a3CjposYkRMHzkK7vkfWtHVdhvu17+dpQayPxdSHx8f2LCq+VowqlsRF0UVMTyWVtgbVdUL1S98UGsHZAuqAFaJmWQRhCH2+BA0zvgE+cY19wIlB//yc8SdK1MUPWf6Pv1L3N/+f8LpW+x5FWQoguUAD/DwwfBhcA5WLoBQvxyTOU8YNWk4m/dWVIkS4G/qKEBBZ/o2CzEc6ZYZT882/VD+uswGAi/vZO3kabyel/umWclmXLkIqKhjK8HFIvsVtv1/Fpnnf+85RDZTWjTYsboAXZu31PUrvyy5UQsnK2TvnHv4HZRh+vBvQAOta+GRjX0DsB05NZTGlziQQzDp6GKkU5vA9d5vFcaUzBE1izIHO0LCfM906jVw81ZRH8P10D+5sUl9W6VlqXTUTFbTyv8X5SCLXYUy7g3enhea7L3+87VQGbN9DnxGN6pfNZJilarO/0pMWwNxwmluos3t++tIIzT/OX7oetkS20QmJaKgcRYODQ63B9umHGozPn0nZEKGKTWW5MJcoeL/JVHkKWsVwehBAU6F46nxMWHHqt8SgQtv61Qe2c45NFq4O2scab1KKEewx/ufGLHMj4H87N7m+VMNJgkIkKKxdXXTAA8CusDSUVUxy2cuFMy0saCeP+owtVLbXGYqJrJEtQH5OWjraHL0pnYUc+pO0APMisqJyUaU3Q345hQMh/4ERqhB7XMg6iBZ93nHykAizSWIn/8ktjwmcDoU+M6B6MnOWZgYGZO45isUZAsqJqopBZRMzvaJvEi5obzb0UVBMzFcmDqKoEwqbGt5oRh+IKfRIHV0rb1VVf1qYILTcifR8vDgZUTTV4Br5B24J0QJgKNDV4Uu+I7wpqr+oBYM7RvXzGAtD6D44tR5vdXAqQad8z38AtflB40
 Fd5zJD7g
 Xw23cTlRIG72WimR6VrHFgt+lxQ4UG5b6a+d//YXIj7vjmYEFp3CpId1AuvBWheoP9ykn/jWhikSdkCK7FLDnX7nNM6ibpeSdjgmxNJRbnbXRqrqn1ALS/wHMTi2XPgseFR92c3WvOEI93QzSbfACEkzR7Yd9HQT3D+KXStZHhmhgoC09nVaSsl8SMaYpOT0KZAsF2HgnpdRf1s4ryODyg9TS2b72KELL5db1S1y+xLw+57yBgn6iBlDKSbeqlwNc/GDrI+oTKHIBtfTGpWivFdTjXSKmOJoMx0ssYs1Xoms8g4najtznCfVp8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 10:04, Vernon Yang wrote:
> When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
> scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
> reduce redundant operation.

That conceptually makes sense to me. How much does that safe in 
practice? Do you have some performance numbers for processes with rather 
large number of VMAs?

-- 
Cheers

David

