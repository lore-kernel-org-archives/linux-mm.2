Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F9D0C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 156086B018B; Tue, 18 Aug 2026 09:00:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12E5E6B018C; Tue, 18 Aug 2026 09:00:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CF06B018D; Tue, 18 Aug 2026 09:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D00416B018B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:00:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A172A3867
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:00:03 +0000 (UTC)
X-FDA: 85114397886.11.F86FCE4
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7A66B4000D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:00:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=krBssoRt;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058001;
	b=ldEaGfj5OIFow80WltZcTv1nX627ky6Rrj1/RIm2jIkVIkxkRAIbWoLRBZ3GbM6Zp0iQgt
	BMb1U2Jq0wbBAiAjlR01DN9OlL5XG1AtLicTk8L2oaduxGniNSZjf+BJL58EkYXxwrhZiR
	21JdgQaV/g+i3CFO4w37cNHkbejQvLw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=krBssoRt;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmgOUbj8BHDXCzIhBSspWfV30kk7RcENm70SlJA8E7U=;
	b=aQpnVp537leqxJcJyh6MxtewoaXwsU7efUhnQ0Clxj1TN7Fie3Xkx3m+cQz9V9JnvTKY3d
	WDXAsJKH4xCcjWS9UDWNDa6xth8Bdtpsti0A/3aDlmNMMzkXryiaN2tkDoCmCVDGPre0QO
	bnkSJwjXqfBJWr0T4nbULFHztS2mIU8=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e7632b193so290421285a.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787058000; x=1787662800; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wmgOUbj8BHDXCzIhBSspWfV30kk7RcENm70SlJA8E7U=;
        b=krBssoRtbLuZzFRmyDOuMAcA66Bed8IEVLwEy19pd0d/kYcx7NWrbWigc7oewLio1y
         Rp7DVa3aTMG33o+ULSXhhL1LuDEdwOoZGyPhijh+k5UnWyan37B/sq5IKEUrjZ8TGFgL
         TNGvr9tEHqIafXTw8mZLER4LYr8rgQ7tPuqc/qf2hffts7aNg/wt8bGMYi1skpgz5kwl
         b9QZL7eh2sgC3CpoRxmJGJaebdyASSAiwI5Ks74uwD9cvKAE3wLIqvL2120i1L2yAl8M
         bepWf0+NHdBaq3DUN3ZBdpcNuxQSg1QUfdVL7FHQz6lVGZKnFy7Cx7kJYNTLOP/j7tit
         NBTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787058000; x=1787662800;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wmgOUbj8BHDXCzIhBSspWfV30kk7RcENm70SlJA8E7U=;
        b=Q+FTX2wXkWJoZfF+8CeFDVFUrFSw7F/VAquQ8HXxHVb4RRRKdEtKAK9xK1IfkamqPt
         boQ+pDf2+6DTNEu95v/zInsqmqVZ+wOhBo0qSG16KWz5YG/F7w8DC2+od5IAjlnSSjM8
         42GOrHpGqJIDpDnGAohmjCP7a3WWqx1jU+3ge7Nf6CLF4a4ERQasv6vSa1aJjRkHhHoL
         h2K3qfqzWFzumrv0e+CkLQQa8L5TxuRUgH1vyHFzW3mhzsd6memAzShmuDTCMgyf/uP+
         E/frCY9Upwdhe3Q23H6XfiD0NFGFlVauCjGva8Wt99C3UxmIEa2IAvR24RAurVJxPmmq
         qfCw==
X-Forwarded-Encrypted: i=1; AHgh+RqL3bYgvIdxN+J/hPTydhWbHJKLDiO6FPSHKIyE5/nXh22PaDmZCFqv1dGPGn73Qg7S4yJM/Cd5ZQ==@kvack.org
X-Gm-Message-State: AOJu0YwSn1HjrBB3nbcj+a6V8Nbc0BheSDSIzZa8gbP8vPf634D87mjy
	FjiHV9vCcYh+54YQLHD0bUdDftWsdg+LniQU534V3z+Ek1J8BWzD07Eb45aws7cQ4gQ=
X-Gm-Gg: AR+sD12qnnj/11l3vrV1gvjmOGLTZ/3MdR2fNl2Qh+opsTjZS27YWCGBPhIDCljUgAu
	1aSzPL7Up4AX1L+HO/TfGU+rXOuTBfUg0GR7tfUWAe4BMBXqHXEpo44c+hlhosqlOEq+RTqTglU
	71+KJN04TbMZQO4t1U8tI2pswQlVZayBtQjR+QX3vHG6QgLovQAdHag5pOwIiIwjWWdR76bukIs
	YUCK9xJO9IAm2pYOGhw1sZHmd7uGDrF8kXrDMToa0uh/YkAyuP536HMXtwPda+HZxbQEE1gsiPD
	hsE7OJc8o65jtwDfL3iLcU1ICJooICEP5kPCZpUYDVBFGSJSFVlj3vUzOyIxbjcPz5jQeNCyv1w
	EGSca6jbIcRloZG/sVhRQhqcs0ejOR/bL7aCCbQ3jd8+BVnrWcyxtybAaP8k+De0RBZxef07Pr1
	STrzfGavni57ygTMwfAy/+8M21XvTP+fu9FuKoxQ6zpTG5XfIDumw3xxTH/kq9QtaGv/YgUzRpt
	/tWHLq/tcX++mlcY1ovoLoLMDLg2vfxae7r8t+Vy2/JuC9sMRVpYXU=
X-Received: by 2002:a05:620a:22e9:b0:92e:6637:d98 with SMTP id af79cd13be357-936d2286961mr2640903285a.18.1787058000487;
        Tue, 18 Aug 2026 06:00:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93703432242sm286024285a.46.2026.08.18.05.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 06:00:00 -0700 (PDT)
Date: Tue, 18 Aug 2026 08:59:58 -0400
From: Gregory Price <gourry@gourry.net>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Saravana Kannan <saravanak@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Baoquan He <baoquan.he@linux.dev>, 
	x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/4] kho: rename "scratch" to "bootmem"
Message-ID: <aoRV7vF3v8DqGoyv@gourry-fedora-PF4VCD3F>
References: <20260811162642.3504565-1-pratyush@kernel.org>
 <aoMdJ7hpr1GonLz8@gourry-fedora-PF4VCD3F>
 <20260817145231.GA579285-robh@kernel.org>
 <2vxz4igr1yq8.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz4igr1yq8.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7A66B4000D
X-Stat-Signature: 1aioshtfu5ouextutx6t3pwzkgwdhb7u
X-HE-Tag: 1787058001-673996
X-HE-Meta: U2FsdGVkX1/IKDMoBDz/wF/K4vBjjeD8knKV0wSQTb7DlW+BKDRxrLBeA5WdhWAdvAJTwZO1wBfKHtzXLRSGPFdEPEWlvlaWw3je9cLc3zHKg3xBj1v7a2+Lx4gzf/xBTmDMw3ahrhLkFUax/1z+3ItxyIxFwe6mr2+EAsD7SC51GnGNXK+EyVHOQ21tY8TOBU2iXCxxP8qYqM0PFkRooznOUEKMagVbP8l6T/JMa4I4kjdjxEjsiAWQy3Tqm55fFbhsTV3l31/ztltshuUlIQivS2hIF3KYi6tt+FPkup/ZlKdW5R4WfJmsMrtnDrqda6d1gFydMAmFIB3BHfSzaB9xkPAvmUGq5xzk3LpMy2c3h70zEC2VhBRSoaOBLANdO3HBH1jmv0hALTA8Mc/wDv42mt//FveU9vGL4dxLTjfIj1N2M4cuWHjrlnrzyufAMWS+pW51+Ad6m2qAW7zIEUk2bk1/ITATtK1dnaj75+HeZ/0YtDFUyylf8nr2P7fJulgTgsOyGbEhDkycEUlVjz5neHq39W8ihCkLMTewQco0rIn0qy72sEBEBunPMhubPd6vmjtO9SXAKEd9+69k4T5Is9gn6jzSj35BV+kwg6kGLiLD2VAqGRv5aDfgWctC1EQRjnVW2dboY1G364GKjNL5XOucgLFO98cXlYC82CbYTHbbx6FKBNU8lsTGRumL74uQWxAzCj63bB1ZBzfIVx3+h/StrCHaRtazhzH5ejEZtwdiLqdWw+vAaTfnMcgolfcM7shZBMY6Y1Y3e5sn0AJ8vHg7R6KAaftEnnlS+JIB7byu3KmGs3yy5enB6kWFWQcb75kv8u/JWd+vGLPjwsHU2/ZekO/SEIrLdVx2tIgjrFytV7LPx1N66MhlRQuF4xLl+p5vKrYSPQ0TJSWKxEP0XGGrJv4AnkiC3vR7dv+pqprvD3jJwwBeXy6f3JlAcS8b4NzLiT7WL0+jGcR
 Jo06QmMG
 TZBHYwmVbhs8JCKbFwDLwZuMT4/7wHsT6dYIQrWVf7DkmxnsRmSB0V4cTk5H7lENPNnzQoPbnZXAD6LrebfDlo2FVQygnmdyPqmyHyzvXQEOIrrRkqAkYG3RmgpUfCVNmgnEuXcrA1QAILY4lmPZ6AsYD1wbAuNpZMjEWRZSVD88pImO9JoQ7utlFuTIEmfzqfw0RMyi+fmacpm6BVApvLbw8ba/xMlzkqh40+SPmHt4sPazg3ZM+K2L8damy+wENRR+d0Cnu81fZWZJ8Gv/CWxWjkgH4AKPsjtj9xhzoTrKF9xb9v80R5My0woq+CUj491saOOnXk99Fx9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 12:58:55PM +0200, Pratyush Yadav wrote:
> On Mon, Aug 17 2026, Rob Herring wrote:
> 
> For patch 3, I am honestly surprised at how large it ended up being. But
> I am in principle opposed to the idea that we should not do any
> housekeeping because it might cause "churn". So I think if the end
> result is better then churn shouldn't stop us.
>

Not really concerned about churn itself, just that I didn't fully see
the value in moving from Scratch to NoPreserve - these things sort of
read the same to me.  The additional context you've provided is
reasonable, thank you for helping me understand better.

> 
> I renamed the commandline option because similar things have been done
> in the past for other options too.
> 
> See commit c5bfece2d612 ("nohz: Switch from "extended nohz" to "full
> nohz" based naming") for example. It renamed "nohz_extended" to
> "nohz_full" because it is "a bit opaque and vague".
>

Also not opposed to the rename, just worth the question since it will
break existing users. I know boot args don't have ABI guarantees, but
some are used more than others :].

>
> That said, I am not opposed to keeping backwards compatibility if
> someone _does_ complain.
> 

I think you've made the case well enough here, I appreciate the help in
understanding.

~Gregory

