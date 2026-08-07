Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97DE5C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71DF96B007B; Fri,  7 Aug 2026 07:21:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CDFE6B0088; Fri,  7 Aug 2026 07:21:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BCE76B008A; Fri,  7 Aug 2026 07:21:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 366996B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:21:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54DDCA02E4
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:21:01 +0000 (UTC)
X-FDA: 85074231522.27.78A3A68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9B95240004
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:20:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ck1IoYB7;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786101659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28qz/dUeEuMa/LegNdxWkBMpO+s+o8La8w1U9SPiDTY=;
	b=dPpBe75dg6Qu68w9s82E/YGY/fEhuptEEOYq1LUnv5Gc+cYZ168Zcu4zkyjlacyDEHCf2F
	ClTNRGe1wQjOrNBNmsE2Rsc10XmI6g9lnOtin4YMLOUcFELYuzco5X56O2f8UFohbhGW5v
	9l1G15yI30RBPQEheCyMdcduWGFmBhw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786101659;
	b=sIaVXQ5d7/KqgH7Ybcn7qRcnMz6yDQqiUQrppihZaNMQZ453dqPIF8E00HqXi9BctIRqT8
	hrgKf1sdOgxIFv37ksVeLw9e9s8AykXRaFipGO25kwO2bwzp3lWOCK080gUfUupP1bS3rt
	RttsedqqEnx5nQKmWSD3IlJ+vi8UiX8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ck1IoYB7;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AE7B60A64;
	Fri,  7 Aug 2026 11:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E76E1F000E9;
	Fri,  7 Aug 2026 11:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786101658;
	bh=28qz/dUeEuMa/LegNdxWkBMpO+s+o8La8w1U9SPiDTY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ck1IoYB71PYbDCcGhRP+9VSnjMyDX6NPy4PGhIz8HgI1w3MXCt4bUydo+tM4ha69S
	 hTohIh0tkJ8C2Ckqs2iYtOnLm7s03morxLToW2mIsbcYYEZsOhUqKCo0/8AUY2tJp5
	 1aanz+9KgvBtXBUytnQ5cbAgOrb1BPZrfBTX2OdqJ7/qQVqoeu+Os4rdecU3QzpYXJ
	 5FB34JIHJbvHjZpLWAk5okHhLrCFSN6AXm/BGVGUuWI+1VSLstbyF5zAHl0YXrEVs9
	 NBnXhE1xoqK/PD20t7Z8a0lsIYrGpYLmpNofpWS2WFYJuCm7x8GsiQNSSyBoqfHu+3
	 c4UnXQqxDEb/Q==
Message-ID: <e1cd34e3-4965-4617-bd28-7494c858bc20@kernel.org>
Date: Fri, 7 Aug 2026 13:20:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fork: reset pointer tag of vmapped thread stack before
 vfree
To: sparkhuang <huangshaobo3@xiaomi.com>
Cc: akpm@linux-foundation.org, bsegall@google.com, dietmar.eggemann@arm.com,
 juri.lelli@redhat.com, kees@kernel.org, kprateek.nayak@amd.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, mgorman@suse.de, mhocko@suse.com, mingo@redhat.com,
 peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org,
 ryabinin.a.a@gmail.com, stable@vger.kernel.org, surenb@google.com,
 vbabka@kernel.org, vincent.guittot@linaro.org, vschneid@redhat.com
References: <f5af86ba-e724-4b9f-acdb-2445e2ec4b1e@kernel.org>
 <20260807104153.94261-1-huangshaobo3@xiaomi.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260807104153.94261-1-huangshaobo3@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ktzbab539nh83rgh68tbdjwfj1q4fa8y
X-Rspamd-Queue-Id: 9B95240004
X-HE-Tag: 1786101659-869056
X-HE-Meta: U2FsdGVkX1+uqs7yDidh9qx7NYojux4Zwbnid0ukZ01/DsoZzFTHJHecwX5yWl49Uv3GN7CwTHBzU/CZaLh1mqyXt88rZioeCItkRMJjdnIZzDUYoLHJB5OTEqc/7682AGXJXA9GzQiHv/GRFZe46GsOmra6KxrUkqi8lTAuymrwCwPCvGOvY0YrS2KLp/XmUf1wjWre3VZL+h2NQjMzvpWPMTp1tTlHWtK5Mx1E3+8b80fP6prpoY5MnMDVBtdpkTIbwhTg+FY+IERSZB2FaAMq88PpV57yBKzpQdP3+h0tlyZFNpZ+S1jQFt61St138T6ysW/7aGO5GFz5yOnzEk3jMWAN0+E9M1YwLe8Pnzar+8s+0jqnImuWkfJZaCxYpiHewizKhSdr1HaImcZWPPk4XDR5llJJTVSO+tAojL8JD/+Sdtb6ANAOXE/cvb3mQ/Ui20Ll+c8p92zCppJ8wnEPOpcyiy8I+gjaLIDiZLFhZMr4t3D1WddNKBlxILLubqG3WQvyeEN32/Yon9j3kPCU2DgkMSmV1xdnFyZXjN153PefdW3HkLYFM8k5SlRuuRxRgjj4XE7WknvK530zCJHCP95s49zlnx4RpQpqor8DzXhOKCfL20fOkE9lYAqFNOoDuznqXxUq0MqvJV6BAamNKK8yQfreb17IK14d3x+stDOtsIZCVqT3dQfeLPu/amspkh+tszlK+Xw8Lwk2LkMOuWbnPdRuEChz8UfIjIdHypePCKurMg6Qv2nOSP4Ootd9vEkNKXT3XuwULgW+gCHTxi9TXpnPvTRljqBh77St2XqB/9JQouR4jjBCEkH29m2mZem0eyV3nGL+m6nkoi4cuALN9enJHH2YHuQluDB7B/6yGg0WcfZTk3lZjuo0KJzdfjWdzMv76NdKDyU1KsB2rBbtnTDxLYLREjQNMvbrJf1P0mih8UAtW7HJxzAAuJrfYvhnzMauYmoWEBd
 nEMJZV9v
 lVjKvYxeGlIkP9kqDFmryvXVKZ0GOAP6Lnw2JPzDIJx79ZDBQ2uWJbI1tYqwOXwnzJwVp5Rj47ruKbaIwo8rS+mM0mtKA5UbXFY3a4O3ITiNvgolT1ZGxDywR+WIZHYHtbnU5H0akJJXjiTkP7uSMy7B+7nLII/74AE/F+CoTYBeQ1o53IuQW94Uc7dVJeL5J5H90+NvO89/yEFrVXwmoVP2z8lWI3k7FYwHsNTAPT4P3hHxVN5KDDyR7WCtYwb22r6XSuB8OaNKPz51nIHk/Mwtr4iLbeCWnretz0CRlpjV43YZhJ4XGEzYxBSDsdRWZmz062x3GUYWqzE4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 12:41, sparkhuang wrote:
> On 2026-08-07  9:27 UTC, David wrote:
>> Were you able to reproduce this more than once?
> 
> Still trying to reproduce it. So far it has only occurred this once.

Oh, and if it is about CONFIG_KASAN_STACK, I think you need a very deep stack to
set all the tags -- IIUC. Maybe that's what would trigger it easier.

-- 
Cheers,

David

