Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD8F0CA5FAC
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 12:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075CD6B0093; Wed, 30 Sep 2026 08:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D256B0095; Wed, 30 Sep 2026 08:03:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECC7E6B0096; Wed, 30 Sep 2026 08:03:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C79B46B0093
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:03:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66501A0762
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:03:58 +0000 (UTC)
X-FDA: 85270294956.28.5208C35
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7520A180014
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:03:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=R8vPWpZ2;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.141 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790769836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wdi3drddBXh2MbeE/kE5oeEb6Dfood/saqLoKtI29Z8=;
	b=kZmFIiOHfYvOYvnLjsLYQB15Oy3FNjSNnOS/tUyYWpPAFw6Ad+X642wikmSQ8CmTWmyduy
	MpmFG0J/TTYsPxxEtbvgnrAslXBIAwibte8EUzMsVYvrHbwFESelO/bxjDs5nMjKs0GH6S
	OdObIESFXIMW1lkf6JbfW48Qc8acM8g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=R8vPWpZ2;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.141 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790769836;
	b=5N1z/PxzNl0eVMyLIf57jwOhYeXRPaDWSN6P2/YvCyaEIgyEWohE5U3Tls8ZjPIWuhzg8D
	U/4EaAA31zLfFUx1fLNDeTZ3bac4ZMLv+ToRv1H4cpjBMHfqoqLqJFy+a6jozfKdBLjbeJ
	/nevoQL3yunuXr6yuabFjEZKSgmUxno=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49fe8bf173aso27888495e9.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790769835; x=1791374635; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wdi3drddBXh2MbeE/kE5oeEb6Dfood/saqLoKtI29Z8=;
        b=R8vPWpZ2+OJZFBMi7HBlhF9ohalp8i8qlPbXXICBLQapuSoYcaSqhZ8cTUjwY84+Eg
         h4WmUYEETSQiLBZdww2SLKnmGbvimhrsqOyiWPc6CSmBb8+HAVO//7Umu0uKpEdg25p4
         wpTvimQk+TYvO2xztQYctzppSyijp/u459IVrlwkbSq1RZdqBKjaxfb6H3kYTDQPPW42
         gfoTdX5d6cV3gowk9gzrsIMlxTlsa3TIBOmyGT9o05QyIxHFfuG3yk4ADy3mVJV+iMbu
         COcc5hnSQEBlTqtB/W3yXZRkKaPFdDsFp01dlG76URJzkLBWXQQrDwd2C0S/V1kjQ277
         sreQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790769835; x=1791374635;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wdi3drddBXh2MbeE/kE5oeEb6Dfood/saqLoKtI29Z8=;
        b=hiF/nvKwmXvDeSZLpKMLD2BbJokNCTDZj15P7ylAsjWKKutQv+/5+TcBpJUXafsddU
         YW+N8XOnuLNEdGYSz4unFxUyd1A0AA04opyfAu/yyGq2EaX+43cDufqgslyxOfHONbLs
         qbbr+jJuvjTmooBINgOzPw+Yf/FijEmi45uJz0pU2bWByalpyTr7hXzlHy8qYXTqWxk2
         Umiurk3xQKsEsxgfFR8cK72x/MEIXe8UnGA9wcpejOLzJqK0iWTr0g3AsHJsBH4yNqNN
         QN/Wq3Il3Jxb3ZNKfBofxmY2FQz2Z0ML9lULegzrt1co/D8O5nY7pzLA1GSX/IJXZTs0
         Qdiw==
X-Forwarded-Encrypted: i=1; AKwUvBz12mYWb33BRyguPtK97Jn+fxbTJf6VRPsIEIWzqDr+yKdG5aM4yJro7Xz2ygfDrjbTG/fiGc5RGQ==@kvack.org
X-Gm-Message-State: AFuF++kpqYdLPnx/286yLmc7BXvz2U/sgoD9BSXR7dpMSpTs+etXgrED
	yBwdijXM2XmTCf9yTsmYe9LeknvOF2jPc9WDArxrK8JsOQ1qLj6+bLhUQzJuXUjz1mc=
X-Gm-Gg: AYBFou30vxYLw6DWBIq7p1mrgOXxXIblWWWWye8C9SbjcDCQuIf1HgDcWgzDySeWPSS
	GjJhMib9mdJ7BybcZUjP/RxrHIvCEca4yxJmXVUQ91u3zUprjQEXI8/59CXfY+lL7wENcQQC/Cs
	ByMmG97uFy/YTAdgZpGcs3ALSNp74mP16h2AvkXRiUbBZJTddQvKVrnOkAavzoDd1CLv6EqdeGy
	wvB0ZCQFGdXupJm6Q1V90bsNwq2exGX56EZNhowzPwoPHpclU0PHLMdVhIj+74tiQf/Hh0kPIas
	y6F+6iZdi3qSmE9DEvFxruExFI0LNqu901UeGT42k++d3sDbhNhuC1DeTl7VqQ306okzqkAjxgz
	MRPDcvNXwO9FTeZ384pzbj7zZ1rvrgYOkfRAjCh0toV1LHP1Pd7Sakj3r6geyA+K5falAHSwVQw
	AFb8eXPUcVxr1B/JGphv8Tkl62+Zf6+226cAC5VrFmQSQ/qRfnpYr8GFzICT/Eh3ORi3Y=
X-Received: by 2002:a05:600c:8a16:10b0:4a0:b9:21b5 with SMTP id 5b1f17b1804b1-4a01b12cbcemr15861675e9.30.1790769835112;
        Wed, 30 Sep 2026 05:03:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::6:13b8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a017468b10sm66347925e9.0.2026.09.30.05.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 05:03:54 -0700 (PDT)
Date: Wed, 30 Sep 2026 08:03:52 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org, 
	ljs@kernel.org, liam@infradead.org, rppt@kernel.org, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, ziy@nvidia.com, 
	joshua.hahnjy@gmail.com, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference
 with MPOL_WEIGHTED_INTERLEAVE policy
Message-ID: <arz56nVu8TzSjqlg@gourry-fedora-PF4VCD3F>
References: <20260930072617.64665-1-lizhe.67@bytedance.com>
 <cfdcaaa3-a9e7-4352-ab01-4922ebb8e0c9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfdcaaa3-a9e7-4352-ab01-4922ebb8e0c9@kernel.org>
X-Rspamd-Queue-Id: 7520A180014
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: rz15kgjfn15x78zuyzfo1atpnugyfd7g
X-HE-Tag: 1790769836-964988
X-HE-Meta: U2FsdGVkX1/FYMFj7I9mylkxY5NC15j/31WNhn3Hqu7+4DH1D5koIfSCPfYHadJDnj78pMU48LO0sZVdmIOIzr3ZP0//gROSnrqdGSOynpdg1RyeP8MQSdGPg7Qpze6TYqwvZe7EZ4Bb+PDVi2Z0dVV4c0xQ3tptMORMgztR2+WLDEHoBz4DIJVLOdITitarznCmCUVyp+LuFYH5rIU2GIb4hGg90ae3rjLEMaqOsbhCnIgmR32Apo//G2BrbD1mG8+hNgh/eYKj5d0I4RPZWsL34+EelAQnsLOl/HMgq09TQ70dcdC7YLDy+J2AS+vvxMvPd09veRYtMxzG1aVoIRqkh8w/KjppImi+ROaf+xqee25XW5SBJvp6k5l4ltfp/ahXuAqTDIMoA6FyHA9FSdZsbAZFE1B1uX6FEu2L7ZvuHubLjwEns4Bs12ImDH9Ehr3sbhiHmgRhjIHsXQmjINmOhoVCvIiS4qIRnQlSeRefecfqxCaqVZ0ioQP8PemADtHx0iMcARw8+L0Ux7WJe6nRXKVLZn2DZRRFQQBrqlhhvkrkzIhrNSbWMeS9iE6N5bzPlZWIthIryYkQ/MN/+yLdoSMOmlT0VMb7eTCUYh4e339U+tmQSxsUlgdEYUvz6pYdBSBT6cVwdFgH7Px+xSFUb/9T7hBTTFCK+ZK5aDCN8ZIjc/S/8Lc7kwQSAju61nNQNUlcOk5FzNFzT3TUia2Yx3v5IVhEPAi4N8v4AlhTJuehGvQQc5CCa9kmRk96YbgLI68bn8gJHWRnH/JmpCsRb2zB6XrIGe6hMM6Yt7TnGVgw1xs5vgMEY1KCEkFheCh8VJC8GLka3cW6K0e1wCdhuBzFMSBNtWOK288Q5QfhIDuhllhfM4j3EF+mYb3P1en1Zba3UeslzmvHn23GUgt1kJlt44rbsyv7IFHhJU0otkjao4DrPDUWDhlgESjG4OZNeKf03eRJXp6lQM1
 92GVBFX0
 V+kSY40ENO1bIBWpAQkWQdStBiZ3SrT8H3PMfGqydeTRO/m4pP+GeQsvFReSQs4igTu2RRrIwhMT2y1ghjQZVAV6P/9hM2Kma4RTMhfmHlVICAkKZQkW7rVzedhs9UZEG9wkqs723bFkJL7rU85e8WDbjN/q4mrkpLbCgaKt9lVW5vsxKjz13ralVoEpVOV7vtDOP9/BIt7vXXmVXEOnqnGURPW3vStQckwRdwkou4QlV4S8x4tBPwHuD5kImV8PmhsBuGXKjOMExgU5o2+Gd97lZ3OqldAdHZgVXxO1DIUctto7YR1U/4nj4l2Kv9ft1igFT+lmWHm9P8VgybD/ZD0HrllbagoQlh6i9dhYkEraU6bYgmmf+rRgEdVhYecP8NqI/BQKjaRhrYGDTDWZRnj4J6kBzKZ2/MbIkRpfaFm9Yg3HCi+TJAkHHbXMwqhLbDh6g/UK89CEI9YXrwJMFQkl9cXP5YcF0wXrjvzZW6whogSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 01:26:17PM +0200, David Hildenbrand (Arm) wrote:
> > 
> > Initial placement is only a starting point.  Pages initially allocated on
> > fast memory are not necessarily the long-term hot pages, and pages
> > initially allocated on slower memory may become hot as the workload's hot
> > set changes.  The policy therefore needs to be able to combine weighted
> > initial placement with memory tiering's NUMA fault based hot-page
> > promotion.
> 
> Ok, so memory allocation will respect the weights but balancing will ignore
> them? That really sounds rather odd to me.
> 
> And I assume that was the reason why we might have disallowed the combination:
> it turns a weighted mechanism into an unweighted mechanism.
> 
> So are we really sure these semantics that you would essentially set in stone
> here are the semantics we want? (ignoring weights)
>

Right, but you're requesting this configuration.  If you didn't set
F_NUMA_BALANCING then you get the existing semantics.

In the existing semantics, if we're INTERLEAVE and WEIGHTED_INTERLEAVE
we just always say "no tiering for you".

But as an opt-in option?  I don't quite see the argument for saying
interleaved regions (or tasks) to be opted-out if the user asks for it -
that just seems like an arbitrary limitation.

~Gregory

