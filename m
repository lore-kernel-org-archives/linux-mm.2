Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C4A606A33D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 12:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iTuJgPLh
Received: by kanga.kvack.org (Postfix)
	id 9B2FF6B05B4; Wed,  4 Nov 2026 07:35:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93CE06B05B5; Wed,  4 Nov 2026 07:35:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81FBA6B05B6; Wed,  4 Nov 2026 07:35:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0066B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:35:41 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD0DF806E5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:35:40 +0000 (UTC)
X-FDA: 85397382840.20.CF87DBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 48AF7A0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:35:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iTuJgPLh;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793795739;
	b=Bwrt2dhZTFag9yaYbjanFv7VN8zGjfI8G5mGZtkKN7AE6r2gEuwnaMwXOzbRp8i7G4QOOH
	xeIfOwJSVrlQa1LdsPyRWj3SrQNKnTz7U+XJLDdpmBaRKhOhCKaKkU7Kr3j/CfLnwDceFH
	sgH3DwZ2p8Un0XfuGEv8xWu83AuhRFI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iTuJgPLh;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793795739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PFO6n7YvwMi4NU0WsSwg3JV5MxCZrjERTzdE+It3Nco=;
	b=yQM+eaQSwkYPkANo8aOayB+8FPfZxzyMJTn+JZJ2iJu3gIY1mSyV5BGI4LoaPvOg8zpjeN
	VYwxcKirdSbWWEwBubv5vt8UAiW2jF/vLvBLOjC759Wj79MV1ZhjvU8+kN1IYH1N7cpc4J
	lRcwG2BcnSzcjUNGwxWLIy9UGU+iGxE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF3FD60F3C;
	Wed,  4 Nov 2026 12:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204001F00919;
	Wed,  4 Nov 2026 12:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793795738;
	bh=PFO6n7YvwMi4NU0WsSwg3JV5MxCZrjERTzdE+It3Nco=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=iTuJgPLh5PToKdG49zOOVGH+CQ5Jys5z+yon0oacjCMpG3mh7Huv/U7eeplq8Y/4T
	 GDeSwjJNvN2jmjilE8nwtasTYSExBga0xXx/eUBVa64gQ9G+BQyFV+JQtMkZ45fKWn
	 vetmLgnio3ES0nDRWx1FQGPvJ2KDpxE62qLURkN+atkAyL+E1OCENc7QWMVsobG3Hg
	 IFvB1WyFF8tMfYZKgkfKSFe4/fR5XDUYh/NuVMDndBIdcyOv4fPkC450V+FDNyPGV1
	 wJvr4tyZ2wG2NiH8747tItOCsS1x6aqhw5LvR9qgZPbDqZS0w4w9pylKndJjVeyBl5
	 Jxl/jzq3Cgkuw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chen Pei <cp0613@linux.alibaba.com>
Cc: pratyush@kernel.org,  graf@amazon.com,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  pasha.tatashin@soleen.com,  rppt@kernel.org
Subject: Re: [PATCH] kho: Skip zero-sized bootmem areas
In-Reply-To: <20261027074028.13042-1-cp0613@linux.alibaba.com> (Chen Pei's
	message of "Tue, 27 Oct 2026 15:40:25 +0800")
References: <20261026131851.9942-1-cp0613@linux.alibaba.com>
	<2vxzld7kpmmi.fsf@kernel.org>
	<20261027074028.13042-1-cp0613@linux.alibaba.com>
Date: Wed, 04 Nov 2026 13:35:35 +0100
Message-ID: <2vxz8q38lqp4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: qgfha4f6wf1y9oztbkyn1yp85gktp4ou
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48AF7A0002
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793795739-592560
X-HE-Meta: U2FsdGVkX1/LnVdh4Kv3lF7mrcFlJvIvi/lSCLN6H9/4MV09fR6BjEKmv425i7QWli2BnGvATARHbX8I1l9Rf75QFn9xnTiVMRbH1+2X6OVQJ90/QnwOpKRBxL4v/+gZuDqAg5gBlaguP+DKd3/v7QUKeg+SMVUCyC3StOzXCWf94KsdSJkuCGPqhgFwDgBu2zaEn9P4VlnEfAGnnB4a5Ifi3XR+bY0lghIsIqG1XXv01BQEcEpfDQ+m+I3M6gb2yW207hsLhRg0dn27ZFv5jQiPh6qwwwSmsJAX6rp7OyaA3zSE/VrrNPfSjfxqfKGYA9zS/EZDyHEQg8I0ebrU6b2wns9SOk9nv6OeZ7pkdCl9MgVSEa13LfuGxgXrsrh9OLBkOtDuJ6waz3tmNy18xXnCZ53QG7U9EwMd9E6uhYELqsR7G4RbSXgb+K5GRe6K1pUvR7CI/HTe7gVjFGnv1snBuU3EDtDBKBNoI3HzKKYTwkM4k5IgxNRcKS1ew0LUZdvnFAicOfCVuPzSLARxhMh8lrrU99y8BqaeI2FVBMZKFDRqgW0QYR5UBpGmVYYAtFOma3LluwuCoL/qe6nxRkLPJOxCfKUq88k8YSfJBs4L2P1QIyFNHJqc0rL7L0wkdZnWwFeNbvc/W7BWAzwYYbUA+YNDoYvgBeIHyESEGPTEkC/32TohTWW7N0fjOoyb2pt57nqJk91k/j60l1qDxr2h4TuwvBRAvLzUXEFGETXFBkHDeoRDzk+bbK2Q7Gyx2yiICIKdM+zoZpm6pTnP9lNwCcUC01wtIKMvWqpdGNsSR/g5W/8j1B5wr/22XyANA94+3MNIP9qt3nZLoje1xSSJXFNRgUQsqEXt62SL7rvWxy9BrE4/KyhGbywtuqbPZzenb4L2jusJy9aNyaRz+2+XbADbCmdnVy8rg6vz2DeLbx3cIXBv9/muS1D+UFe6vWFv7oLDAeNyJOAjfc3
 5DIfSAZn
 mENFEgGWWl0WWlMYPjjNuUWD5V+yq1CRsWebHAnoFQCPRf43u9dc12Qn2k26nZlS6Je/cRLd/I2mDT2LcDuLaDrC+qyPdn6IGNebmBeNtJKUXHT/F+Qs35R7XvNXk5vZL4EAwV6y1NyUK4SYzuGr87BPvKzcC+mzr0djsMe9+ZhNw+mUST5KaTyX8LRPBOYxUZDXux9N/yeHs2INkP3YGdBoZNDomxzOfwmw40P9JVKJpi3Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Chen,

On Tue, Oct 27 2026, Chen Pei wrote:

>> Do you see zero sized lowmem or global scratch in practice? If yes,
>> how? What's your setup?
>
> Yes. Enabling KHO for riscv64 gave me three cases. They differ in which
> size ends up 0 and in what it costs, and all three are measured:
[...]
>
>> Note that I already fixed this for per-node areas since those do end
>> up with no allocations with movable_node set [0].
>
> That one covers the per-node loop only; lowmem and global are still
> unconditional in linux-next today, which is what cases 1, 2 and 3 above
> are about. Is there anything I have not considered here? Please point
> it out and I will follow up accordingly.

Mike sent out [0] recently which should fix this problem. Please take a
look at that, and see if it works for you.

[0] https://lore.kernel.org/kexec/20261103-kho-bootmem-sizing-v1-1-45aa74098f34@kernel.org/

-- 
Regards,
Pratyush Yadav

