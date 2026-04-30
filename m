Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65150FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 17:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABBC26B0088; Thu, 30 Apr 2026 13:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6DA16B008A; Thu, 30 Apr 2026 13:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95BF26B008C; Thu, 30 Apr 2026 13:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 840616B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:32:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1BBB4C1767
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:32:20 +0000 (UTC)
X-FDA: 84715916040.15.B079D00
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id E963E160008
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:32:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="N/UUCVb2";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777570338; a=rsa-sha256;
	cv=none;
	b=m5AHj9HnyirFRY4/601EhGjEIASBPV2MoVtaOhVOjq2oRbJsKc4pge41vggH/dZjCZ+fGz
	tj2sm17BxEzVorr+57r0Kt8tQKBwV77yFICjZVikWMa2wQIfdA8Fz0M5bGX3IN5JkndLxW
	CDSKdmqBMbipcSN4gF+i2tqTHJwID7Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="N/UUCVb2";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777570338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EsoSAi6z9KmFSkS32vV+nxgnnZuvTLBZtnjA13t2Cbc=;
	b=gn0NhY1GBF0jI1ARnDTpEjARhrRmaUnBtzhYvv656C98zKwO77YnCNsdr4aezaBuYCNPL9
	QHaqzdD0hkHCrTkGg/rKRQPH825/HziztEWyzRr2AuZRRdqmHZuy7F/zVLtgaMam0ZYrQy
	ondHLdGdkORPmxr9zbqIEAr9b+VwUpU=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488ba840146so10081585e9.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777570336; x=1778175136; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EsoSAi6z9KmFSkS32vV+nxgnnZuvTLBZtnjA13t2Cbc=;
        b=N/UUCVb2M89RfZmbS2zJMzPUMzArGiRnbQkG1pGA9yOAqAj2kc+NvsHz8HO2j7+F6F
         yLCT4bQ90+fVJf3zqupzM0i6zZ08zyidREdhEUs1uO8cqb/spgeNxmIH+ZLlgp9SQfM/
         WEfjSmLKdfiDs/LN09B+as+6NOhoueH8Q7NSgrfP10gnW4l0WtOcUCUA7gaoBUC0H+WB
         /q39jROp3+WNZ31HzFWNx23+AyJnYwSiLW3+45huWO2XnsBtb+rqvK+w8v13NaR8TM8D
         9SwX2PwHKyrCm1ZgMAAYMKC7lfmsvD7RLw53LTsm0FIl0g/vaSFaUlof20ThKgtG5hxN
         T6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777570336; x=1778175136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EsoSAi6z9KmFSkS32vV+nxgnnZuvTLBZtnjA13t2Cbc=;
        b=F4PB7sbZERG4Bfd7hRPcl4D6o7vj2jQ0l8JdUIzMMg9Hws7z2n4LUr432+K5+mfax/
         dkOJ7fcIH57ovTcAOLY6r0GrZGAotH2q66UF6dezWQ0FTyJ6mKYCZa91r/NsD5YtX5Gm
         KwBP69MEle9oet5Hv0jTQD68R2M1Zyv9JVjJWo9LVH7xeDOzJ2mgtk6hXk9XkK33Zx9/
         O9nDr4X1eMNjnwB/Z/PjGxpwh93xfAG7byGmrBehs7Xu05vakYV8eJ0dhzdWF8Why852
         zqlbWC1qJPXpunyH4i6xKuaUI2M0OYhSM4pD8q6jRRkE+BVq9bLqPbDa5CpgAPcVaL1K
         MTeg==
X-Forwarded-Encrypted: i=1; AFNElJ9hnycSSs30BGC8naa7e19aGeDXFwc6i3+BsTzNQudEawhFMh/bpUT+IUX/riGlm0F34Fgvl0HJ3A==@kvack.org
X-Gm-Message-State: AOJu0Yyr5bfGdc6fYJWR0kWpkLN6jRORYqBJzjJXr2ePokk02CXdYXfy
	GBekoYhPUdfWecRYZp77JPpwzCP1OBm78ZMBScLqNjplMcm6oMV9FIKHC4bs0H+4YrA=
X-Gm-Gg: AeBDiessCeNzDOYsfEMlnsQ+h1XqUI9D/8UhP7xpgUtdWqqO5vzWqE9RAE8zRSAbY/O
	KzYCHxpPt3thOtMwPdoDzHAwsObnU7a3MNwor4eQxT9FYBn0g7h68+en3ig21sgOYA4qnb4MpHh
	zeanpSyTFvgu/DR7iZVO0aPIv7jdaWUK3HyWPAIr/BrH1MAa57LYNfXQ7u0pwHGQ8uXvGM13c5g
	pn2Ys9/mEJz9NWZDPmwQzBKNhA/7RAe1oHbiOaB+Vur60kfFZypzvkU58srTCvZpcP0Da6OFUzW
	4isZF2Y3SijvfFK4kxiXVpYmb0hzuwbzKBxkWDVq9aS2ZCQ1PH1vtqI4WVASyDfdlka+Kb48n+1
	mxGOoKz4cBR0/TCdIGjPDW1LykmBYy3InUsiY8dsErJ+g80MYY+VOLHIN0KRoYTDmp9PERDESMY
	INmbvPHNQw2BLhANg9CLI0phECXGO69Pp7NVCJXzRvrA==
X-Received: by 2002:a05:600c:5254:b0:489:149a:f9e6 with SMTP id 5b1f17b1804b1-48a844640bdmr66440065e9.28.1777570335923;
        Thu, 30 Apr 2026 10:32:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::5:c95f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c32afb0sm45223615e9.35.2026.04.30.10.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 10:32:15 -0700 (PDT)
Date: Thu, 30 Apr 2026 18:32:13 +0100
From: Gregory Price <gourry@gourry.net>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	lsf-pc <lsf-pc@lists.linux-foundation.org>,
	Bharata B Rao <bharata@amd.com>, Donet Tom <donettom@linux.ibm.com>,
	Matthew Wilcox <willy@infradead.org>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [LSF/MM/BPF BoF Session] Numa-Aware Placement for Page Cache
 Pages
Message-ID: <afOSHX3U_0F5kKQY@gourry-fedora-PF4VCD3F>
References: <h5ossmwe.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h5ossmwe.ritesh.list@gmail.com>
X-Stat-Signature: b78tyj6ade48jh3qzdp8iy5cd8zscjqq
X-Rspam-User: 
X-Rspamd-Queue-Id: E963E160008
X-Rspamd-Server: rspam07
X-HE-Tag: 1777570337-62127
X-HE-Meta: U2FsdGVkX1/RA1wYyy4HnxjofX1UbZYviEuEmI1x5Z7wGD3pMXezmGsdZdMTOEnE0bE9Ptjg7GuD26+7QFEGA8qiHw6CMJlCpv7Bu8eFEKRTp5Mo7PA/h4V9C8RyDFobM5nxkuMtIPKE8ww8M4p3iRaqsy/lQ8FCwZ+gAtHavssrxEfUfi+xlq6/OD9cpr2cswqyu2qGxqaF7E2X/QBg2fpvXlT7+hcpqEB5kDMiK+uq+mnEcHgr6UIrATQixR4H2m8lGutuRNYcktcDBKePZ6HGWV6b1y+V1HZFz47azZxc4oV74r4dP6EHnCeFpdIqRXZv3pgmpO5wheKeLI6OqIsjYEFcXiT72Jfp8D0XsQLSndsQbgKAu8TDhOUHjQBJXFvSvcBkHS2y7D5J6QlgtiCEharXrX43b4WMjpqYNUoFPgI1LDsHeS3jBuWKp72vBAjbfA0uN8O5F0B8YdZuEtQxz4mzcVi2s4NRV7v0vvbGNkKTgO+KPwy8bvLjzRjjnPN0G12JFzel5LHqk+yo72L7tyamshhe794gTFsf4fuhl112xqdqRIbbRY+zA8DQ0SA0yxm0Osr3hP6Bb7WGydlu9z2H7Rx8nbV4FYmrMNFc4CUa02OidjN4za+tHhc6CtIV7uVqmcrW5Ypip3F/c0V/FyjoLPrkKoe78Oi8qkwWh286edzqgKYsut8rNp4WmWquI06h32z1XwegnuMxWe6MShTa3qjjv2YwuTKRXunYP8wOg/86ZQqpCo/J7ugXsinE9MLTLR+ZAHvH1C4dvFMHIbvRIiTaZ6z7vAvxskNZyv/mu23BDFfaEPUJkn5qZeusQBx8KgWtMV7CK0PUaXipGcqwJ5O+2e75sod/k3bDLX9YsgSJFnBono9itobZGFiYzgsUblfM9tzFaJ2HlEJNkWNCfwzVp0nuAi4sndGd4IxuA9tjaMUQLkOY02tKUIJAR9Q7H4KN83JPjcK
 43F5neK+
 1P7MiOvfF+Fgp5e+ez4lkNOd3213fXaK3OO7/bGVjSKXpV8XMCs+PFovxEBxEgjWl6+j52UhKORdtz/Rm84MD+cCrPQTEcWSe7KlwXRktJTwc2BpSf+Q/h626gPfHOqO/hPc3DfLbsMVHU2Y6N5tQTD0PRVPKqwTnN2Yz95e5NkCMqV+2oEFhc8FeES7aTRs0fKwSEoGTFLjz26cnyh+MwWmcA3AGPCzpV7fVXAlO8zQt4+fV41cjxH17qEFDskelpHOImra6RcQeGg88y+gzfNLyL72iOKjcNANCwALgK/U3+caH+ifk10pHp7WOa9VqYfrn9+SENq/dWqcenOoMcpFAbcL4xTvZU7WeEowLYCh2MTOEe39rIfPGQHgWz2aYEIXufTfIjm26HotkIwwLrE/RzUonzf0tAbF+nS0z26sED0NXptjWmdZfKPCyeHCuPQILCmQvLVB6NF/umtUY4jV6gIbWmFZxP1eF6KZf6Cxfcjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 05:03:37PM +0530, Ritesh Harjani (IBM) wrote:
> 
> Linux already supports memory tiers

Allegedly. (TM)

In practice, and in working with such support, the support is incredibly
nascent and in fact causes LRU inversions by design, is missing unmapped
page cache support (as you note here), and just overall does not work
well out of the box for any reasonably complicated system.

> and there are ongoing discussions around
> promotion of unmapped page cache pages, which lets kernel do the right thing
> for userspace page cache pages on a tiered system.
> 

I like to think of this more accurately as:

"Lets the kernel nudge the trajectory of the distribution in the right
direction".

There is no objectively "right thing" here, and chasing that is a dead
end.

> Userspace, sometimes is in a better position than the kernel to know the
> workload's access pattern and whether it makes sense to drop page cache pages
> once the I/O is done.
> 

At the expense of an increasingly complex maintenance burden on the kernel.

> So the question is:
> Do we need a userspace interface for the placement policy of page cache pages on a per file basis?
>

To the extent that you get something like:

MADV/FADV_HOT (promote and read-ahead)

as an extension that mirrors MADV_WILLNEED (read-ahead)

... maybe.

> 1. Is there a need for an interface that allows userspace to do per-fd page
>    placement and maybe per-fd page migration?

Maybe as MADV/FADV hints, but beyond this - no.  I agree with Willy that
the kernel should simply get placement right.

Building the assumption that userland will do X and *then* the kernel
will get it right is just a road to building a bunch of random
interfaces that eventually get deprecated when the kernel does it
correctly.  We should just do it correctly or not ship it.

> 3. Even if applications may not need this today, should kernel developers start
>    thinking about it now, before users start abusing some not-well-defined
>    existing interface. e.g. the story of echo 1 > /proc/sys/vm/drop_caches,
>    which became a production workload tool despite never being intended as
>    one?

We have a public meeting every 2 weeks on tiering topics

https://lore.kernel.org/all/8a622c4f-0774-96a5-2d2a-2151e0bc2367@google.com/

> 
> Let me know if people think that this discussion qualifies for a BoF discussion at LSFMM?
> Or do you think it's a bad idea altogether, if that is the case - Then
> please help me understand, why so?
> Before starting to jump on the implemention of any of this - I would
> like to gather feedback on what do others think?
> 

Always happy to discuss.  Just need to figure out timing.

~Gregory

