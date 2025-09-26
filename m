Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC69ECAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 06:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD138E0002; Fri, 26 Sep 2025 02:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3876D8E0001; Fri, 26 Sep 2025 02:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24F618E0002; Fri, 26 Sep 2025 02:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0CB328E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:55:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC00D598AA
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 06:55:55 +0000 (UTC)
X-FDA: 83930491470.11.033373D
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id CA6EB40006
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 06:55:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="dLul5m/r";
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758869754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFDpZWjJo+MAyxTSC4DRhbNn8DKisYpUFIU01KiJ2vI=;
	b=fx5xz9e/8kGyjKS6PBV4XNS2WGbKrvYho++RzfYdkWY/9+aM8cKPgAtx582UZCHXSBk6iQ
	hX2XAdY2VPzjaXrGxWIHlNYzCJLISncR3xGZZEtD5Q4Wu547NUBAWFZ8m4qJnG7AurMtkF
	ut8T+cMq0uUprRBlGVng9biXT18S1ZE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758869754; a=rsa-sha256;
	cv=none;
	b=2Oc2SBOgFXCbrv7POKx4Q7XSYzJ4ePnAgTlCNDdTNNM12x38zXQo6SDqyMRqQrfpBTQSML
	objebWdeqzHyP3LG+IAgJ2Ur3FUi0TLVJsHsA8S7EFLIBRPF43IYv15XeTmBguZG0hjJ24
	eupdyVosjrgobPFQMmpOgNR8stCn2hc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="dLul5m/r";
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-62fc14af3fbso965161a12.3
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758869752; x=1759474552; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yFDpZWjJo+MAyxTSC4DRhbNn8DKisYpUFIU01KiJ2vI=;
        b=dLul5m/rv7RMFtpaVfgsebtnoyNs2V9a40EDkMulAD0VrFskIiOMF4s1eC3q0li20j
         cIkvoqdj3d6/hrYNZJOLjY/EJ8sZ4Vnotkp6eQc3mXfu+q63xgP6ZenxEydB9wuzgclv
         zkxnUqut+f9iV5FGiUI2YnN4pqDbtcEXb0EJupn/D/TOlM2eXIORlji335GcqF7ctXO3
         C928Yr4dv7BONGBy5Us5vbnLoQg2+p8Sa0A+g+i/G2v2dm0JdUXp8S7Yqdy1HzzNXW7V
         2dpwreREbkAE/BfXhIaxekQubIVE56P1Z74ZC/RdCZfvBiLv/+3Q8IeQZgM4AwX8XXCI
         goWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758869752; x=1759474552;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yFDpZWjJo+MAyxTSC4DRhbNn8DKisYpUFIU01KiJ2vI=;
        b=lbh+wGIvORtmSKLS48pa9Z6uaRNZoT7bfXOzsbh/jKcmN4oJdKB/chZ4jB+dHewbHa
         /2H9iasrovmQKgmJiXEgrLPEQzqO03MgvWtP3biIW4cWV0lt5QcUaCX2zSGzCSEmPSv4
         KukVp5PF1irBbHPK5UVX5vMLcNoXdFvwza2ne6H+0UVtWkJNz7NuB/St/z7i2fI1J0Q6
         W7J3TPukAOoYS8WPa4n72Q7xZRi5MUCWmY4P+OH5apdxa+KwVM1dJqoNZpfYNGv4hcRh
         4dAQduOmSEgApI0dbj+uMECztIUfDfgsERoTTeD4tHul1liLRy9WenIDR4+syJw1IIrc
         0ZhA==
X-Forwarded-Encrypted: i=1; AJvYcCVUazkvyNr6duj/CAp8aEk0w5z3Gcc3ST1ctGzLXiRAyno+1I48tD6yZEY9wrGKhOBum+zCjDbfnQ==@kvack.org
X-Gm-Message-State: AOJu0YyO+P0Yj/X8igTyFEh6i2qosO2sfIaTgE2o9gU1xNolEX1Sw3uW
	qRIMn0rTUxdQm6OuayLUxx/QZVTk8Ot2x/wwnr+3de7JcdJqb+qBJj3iCh4GpsSmyxs=
X-Gm-Gg: ASbGncsvNifuiVOlW8qcw8siyRwxSr+OPVYD83lEFXnPNGJKjVKqQ+u1f3r+JNYVmyA
	/g4sFv+JzsyKnTng6090Q1vmpf9B+xEhbh+8VE8wzcqk9/vMT1kSOO8YUpyU3/TtOe4B+IPFgkT
	E8hroRcARLyXwZ54SUQq5tHW7aktxHv/n7qsZ73zuSYrxFKatEiFq3wVto8GAoJzosXPkhWqr6t
	hQSvhAQXkolUACCIuTQ9ONumF0xzYI82GlGldAg9RLBkPP8vtTe6Zj/OfeDMrVq+HnlDeHkTGup
	ib6/gA1L5vIAVfr9YCPYJRZJzUNTiFLKd8bUcb8L+XPtAc9heUmODDhYtBjS+6CP2Ga93E4vs0g
	GRKRKkhhxNGu0BoVQ7GqzUAe61aCMNReHftnO7boS+mbw
X-Google-Smtp-Source: AGHT+IHgyGHYORuYwlYRUngGDj0p7gh2gMef0eybT5e/qzeN9cCCuM8737g/O3hSnQVg25LntY5HQw==
X-Received: by 2002:a17:907:9447:b0:b2d:28fd:c6bd with SMTP id a640c23a62f3a-b34ba450e21mr629911366b.36.1758869751875;
        Thu, 25 Sep 2025 23:55:51 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b35446f758csm313713666b.53.2025.09.25.23.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 23:55:51 -0700 (PDT)
Date: Fri, 26 Sep 2025 08:55:50 +0200
From: Michal Hocko <mhocko@suse.com>
To: Mauricio Faria de Oliveira <mfo@igalia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: Re: [PATCH 0/3] mm/page_owner: add options 'print_handle' and
 'print_stack' for 'show_stacks'
Message-ID: <aNY49sdoFVe03m_Y@tiehlicka>
References: <20250924174023.261125-1-mfo@igalia.com>
 <aNVpFn9W0jYYr9vs@tiehlicka>
 <4c2a467113efd085530eb055e4a4e1fe@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c2a467113efd085530eb055e4a4e1fe@igalia.com>
X-Rspamd-Queue-Id: CA6EB40006
X-Stat-Signature: i4gmm3pt5hks88wei1foazg65ymzwd84
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758869753-356841
X-HE-Meta: U2FsdGVkX1+UOUbKhYOLa1W/F3CbyIMJGoCe9RjZVmVq/rEdtMSJvHMGFf78jOY6+UZgt0Y6Op52wTyTKfNUswGLHbpviJE7PkHLr/R2WXmOlimzub992IKnkDhjltkJBpXp4OTYXXN4qiiClwGX4gaTFkiqsDOjrIB5zc02Jz0ksEpFQmm17DylZRtyYaK6SRxpReuItj1GFSlrab6TSsNG/Gdx+qACYagLb2Ry2xzxSUh0z5JOTnz4063G2A41K07RlexEDnPP/8Thap1MNiSjO2ojUDBa7AJ0JGTMPLVlXU4v25WwEU6Jvu8B7R6Ypx2DLw574fJa7x71PyqyROuItchr3S0S3bMT4cTCWJraKSgiFgBogQ042QZW8yP85cael1Zxwael3wQp8S/f9b8yjqCs6yZkFKeM68F7rOgWXoGyvJqgWMfIEi8BwZwltZZYNp3hFRD9EnuRjk/VfRg7D3NKQsdhK0+Oazmx205qUNErH78EPQsvHu0EPfWBi+kjHF9whOe4THz5nXcHXNSjAZVYGP7XB9xjW2A0JuUaw/O+w02xqf3mtD+x2QUUJcFokXPAoMolHYPSVcMeom4hbetPKN3YnS+1pRFq3qCTG7ycbek+VHKTTVewwcY6Nps2jd8JTTOQnNd8PR0mr3bieElWhKZZCxJ4vIdpppUV3jxgxr2HRN0MZ158hbPp3lP9BP6VtkalRwMk8+ckK+6GUqKaY3Z3AZVdqv2CYuQNFHj6rKSD8q8VcWCIyGVCgDOE+hK1USDB0x8ntyG+oaJCQWd6gBI0OCt8cCizWLLWrJEWdDQlTO76iUXH6XBljzmFIbFulytT+kzvRY5GLNXqufMujKhh4UwHIf1aQ+4a7PSbsB4SZokfnUmrYjvoZUy+5iQZHLcxHqxLthHnv5vRPhJ4jWOC6VETyAB6m3/GJItA25RlvuGjDDOp9dFge1tcmRVFjEjVefft3JW
 CyAvQ3KW
 tVWPeXrNAWx3DaEWzVyUcoSXtLh1G/7feUfLQVum2XT6G+ifaNfqnY8MBYFP2TKFAnIAzhPYkEqs0P6BcUEzD4EznHs/WQUlecDwuMXeq7DEhA07tjRwQkUz1I96rqVDD0EWRZBPhDELnqSG7mXpflYJRT8aNpPy8zMIGf+nIgQpQmVDT5b4Hc4RXCUA/mwTBqiCks2XgfaW9O6bIgifh9LLRufNuPlu7txzKPTGLhbmhsT5Lr3IpQOqoVeYJ05YZdE7BVxKURCTM0vE9ATG79UroLetHmTtkkAolFd8+ECK77obZeM8oqBCpz9cYAWaUNVFcnkxe7ewt+D8M0OWMfwkBPL5qYZM1TnG+wdZW3/oUlz4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 25-09-25 16:38:46, Mauricio Faria de Oliveira wrote:
> On 2025-09-25 13:08, Michal Hocko wrote:
[...]
> > Could you elaborate some more on why the performance really matters here?
> 
> Sure.
> 
> One reason is optimizing data processing.
> 
> Currently, the step to obtain the key of a strack trace (e.g., hashing)
> incurs
> a considerable work (done for all stack traces, on every sample) that
> actually
> is duplicated work (the same result for each stack trace, on every
> sample).

OK, that was not really clear to me but the above seems to suggest that
by hashing you really mean hashing in the userspace when trying to
create a key so that you can watch memory consumption trends per stack
trace (hash in this case) without post processing.

Stating that more explicitly in the changelog along with an example on
how you are using this would be really helpful. 

When the interface was originally introduced the primary usecase was to
examine biggest memory consumers - e.g. when memory counters do not add
up to counters that track most common users (e.g. userspace memory, slab
caches etc.). In those case you need to see those stack traces as those
are giving you the most valuable information.

I can see you are coming from a different direction and you want to
collect data repeatedly and watch for trends rather than analyzing a
particular situation. This seems like a useful usecase in itself.

My main question is whether this should squashed into the existing file
with a rather strange semantic of controling the file content depending
on a different file content. Instead, would it make more sense to add
two more files, one to display your requested key:value data and another
to resolve key -> stack trace?

-- 
Michal Hocko
SUSE Labs

