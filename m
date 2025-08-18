Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D3ACA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 16:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEF7F8E004B; Mon, 18 Aug 2025 12:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC76B8E0048; Mon, 18 Aug 2025 12:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDD698E004B; Mon, 18 Aug 2025 12:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8D798E0048
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:40:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 734521608DF
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:40:12 +0000 (UTC)
X-FDA: 83790440664.08.FD69568
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id A740720013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:40:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GM6cE496;
	spf=pass (imf13.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755535210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nsCNc94UgjJg7jVl1vaKpXsd8gSEo/4al1GvsJSlrTA=;
	b=KtDIEeEchR2rjk8lPZgyg/XzLzjLDGHiPmDeaZq2Yyhm/zJMursqkrIt6kwVGFWjqFbhWt
	OWWMP/ibjmkwUnqeCQ3YjIJjCgEQTg7QEnG6YPzaxX/9JQWVYvvntu7PCh7i5Ud2tvHV46
	j5OHQFoT8SwPObnMyPXT1Q+Jl5NigVM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GM6cE496;
	spf=pass (imf13.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755535210; a=rsa-sha256;
	cv=none;
	b=TSKM1jJfuGE6dzbtfrQjyA/z2lL93qr0kequVHXoyVbxiGSHKPKE8jNK+KEE0Fqt2WVvP0
	IPwvK8OctmQYViAiaTb8fYvgTbVXG7xN6MdkQSr3LCk7c6gzpvK0o/yCM0chDPBBvbHqxv
	Cn67f7EHqi7FtvHQf/gVqr/zonulFcU=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-242d3be6484so270515ad.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755535209; x=1756140009; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nsCNc94UgjJg7jVl1vaKpXsd8gSEo/4al1GvsJSlrTA=;
        b=GM6cE496K0jJPuAoaGYMfEjBf9501pC5ZPVn8XtTvIFf+eO0m0ZNqRSv+cEMcygv36
         GQ1I+C8HmPU3QfbNPXTNk3oJqWBd66LHNsKNzzSlb4+p8YelPGh0hUCT7zIRT7koz+AH
         rH6XiuKi2OYgVl+GbuC8619u1XODVVsO6LZIHUGIaEJO4gOcvdTrclSdqmXazBFokJfJ
         /Evbsn65/IuXpMhTtxiCouz3kRZE4ezHhIRwNgeeEPAAXM0RP9MLkIeihvHC9WHHg6Z7
         FKcn1urmkT04YAAQB7+lB2Bvu+LU8nc2HvkYcw43vg9ztK9m2RvqB4L/9UO1G+j5jTLZ
         jZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755535209; x=1756140009;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nsCNc94UgjJg7jVl1vaKpXsd8gSEo/4al1GvsJSlrTA=;
        b=FZStC5PCU63QSKjrVlaTLsIT7YbKkZRA9ocP3wIUBbSdzWi2tdDl7KJ8Z0hs8Miwbx
         cWc5pKOs0ZfJwoTdNxhomdO93PPJQ8xFZUE5rs0EYVI3hqG0igmh4itK/RhfsgSSyf0+
         rnDEjIwKQwahSVPubzOywQJ3qNdh6xjpFDcvymLKIf/zzgNNxouSYqSh8Tze1wVg6+dP
         GrqDS57/epvJJbaX/y3/yyEJe9UThOH5S8ON3aG5i6lOZyZX59wLLbxT7zdbCy4NiuP7
         lAYrvSkjWfirfOAjedhkJMg5neEJr9auLkLwIx7DkEVSJPrkS53AJBT+kqcdWgQ3J3U3
         0OKg==
X-Gm-Message-State: AOJu0YzonTVm4q3CTqrZMUPD+1LjFqeMJQfNtSGlYOHFpmFbnvNWS8dn
	PZhu0UpoB35pe5SL0sKKtd7KYSWm0hQQUZGUt9nHFnM/j8XAvNsWh6DL0M+hbXQeOQ==
X-Gm-Gg: ASbGncsZGEOrfq8ZxemknCXfv6OkOYSnFX0HrYzLHXVyrqBl3rBgfENlGEkfTc6oB9e
	AnBO0S6vciFyYtvKNtlkdXQZPezwlOkfnEMbtj5CqFpUWs32nZhFQhFHW4ilkCKZrUay4cl+wLS
	KecbHO0HFBJxhX/0bAm8No9xVDh7VwCWSFdspKzkyNkyVIev7iUh9Ws1/kFlcWnkrKBQZ3K5hut
	PyZAo7cTkbxvmfO0FWutPUBQNvK0E80ljKrlknCvkPaWJAvERIZb8rBgvTe/Tn9Oty62MNz4uIs
	dqQ44CP6hrWSvCInsLgSWz2bZPwF0lmdLyMcsnXsgXFpZ2c5hJVV1qevmgJqZMG73iw7ARuQx+l
	0aUR+w9VR0isUfKB7vDSTqMPled51vZgeRCXbPwhbnLpJWnnRzoQJjYumFoMaIlneszigIoBo4R
	0Ys4vnuxvkNL2jOO1DD6R7vWmsVDU=
X-Google-Smtp-Source: AGHT+IFJMTXh76cxYP+zXDebQQvzDoMsJ6wPvyk5fQ5JdUXKXNsWSaTcj84sVwS2yzlY96E+mcZP2g==
X-Received: by 2002:a17:902:ecd2:b0:240:2bd5:7c98 with SMTP id d9443c01a7336-2447a771ecfmr6610295ad.11.1755535209029;
        Mon, 18 Aug 2025 09:40:09 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:76fc:13b2:d4bc:b3ff] ([2a00:79e0:2eb0:8:76fc:13b2:d4bc:b3ff])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d50faf2sm84863195ad.81.2025.08.18.09.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 09:40:08 -0700 (PDT)
Date: Mon, 18 Aug 2025 09:40:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Amit Shah <amit@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
    Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>, 
    Christoph Lameter <cl@linux.com>, Dave Hansen <dave.hansen@intel.com>, 
    David Hildenbrand <david@redhat.com>, Davidlohr Bueso <dave@stgolabs.net>, 
    Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
    John Hubbard <jhubbard@nvidia.com>, Kirill Shutemov <k.shutemov@gmail.com>, 
    Matthew Wilcox <willy@infradead.org>, Mel Gorman <mel.gorman@gmail.com>, 
    Michal Hocko <mhocko@suse.com>, Mike Rapoport <mike.rapoport@gmail.com>, 
    Pasha Tatashin <tatashin@google.com>, Peter Xu <peterx@redhat.com>, 
    Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Shakeel Butt <shakeel.butt@linux.dev>, Shivank Garg <shivankg@amd.com>, 
    Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
    Vlastimil Babka <vbabka@suse.cz>, Yang Shi <shy828301@gmail.com>, 
    Zi Yan <ziy@nvidia.com>, Ackerley Tng <ackerleytng@google.com>, 
    Frank van der Linden <fvdl@google.com>, 
    Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>
cc: linux-mm@kvack.org
Subject: [Invitation] Linux MM Alignment Session on guest_memfd for software
 protected VMs on Wednesday
Message-ID: <d24451c1-6ea8-4904-0661-0769bc113473@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: e17sea8sf5rddt6u5oxfs5nfp8dpntag
X-Rspam-User: 
X-Rspamd-Queue-Id: A740720013
X-Rspamd-Server: rspam01
X-HE-Tag: 1755535210-874013
X-HE-Meta: U2FsdGVkX18zGRmVjAZj27oEnzGWuKUoLXwhY0hWNsOscylGOIoh77haMVTaCvW7wBUiiE4fyr24lW/VLyXuYwegAkFhNW9uRdqorj+evKJ70GFuyewoFvo9JVgwxErwPH4KptlZtHwg8MSZD0y6GGBXMT6Rcj6urIvugsBXtHRe6dOVs/vANcL5h6enFAvosFuRxWRHSzhyms90zRZvhcC3NA5vTxxmTve0I9TW1idqnbMdCQ7gvwK0Z1wGsd+p9n0k5bBpjgFFl+6Um1MorgBraKWuGKKt8BORq1TZCZdNr7fGTk1TIKPopFWkI6DMqihH6gZ/dWY0qsM7gYbUC6d851aoAUnbSbkthLgP4ArNrFiVttUWV4tmmF/QCJQ6DvfetrOIWVPWgzvgYKYi6n8ZEvu0/4wtcVQCQLK/XsrvQ9mFPGP+BFDzcJrFg7TlZW1RJyAw/H/eIzH2tp8EVSRWHhUYnQI2JpMjPQ6CGZo5iC2OltqNqJ1muU3V69OgYvXz2iSWgCjlh7PaGVjijlIVTsADse/iildEk2wfqQ4bDbVHXFt3WYoLn0tMjyyoKf/j1alVw9p2zUpTbp/ke94YTNgjHfSYmGLlh0KKSg9EdaMwUgkRUp3/NdJvXXl/C0Mss/fXDU92O8FsLVmCCvWIamceZlNnGUYy6+DSfoLwH39/F+dzkaeFdO9oy8ulITeF3tCp40tUHyNNXyKyLx6rcaXCdlURK7ULkE+26yCb3DKZfvESb/wculLiLNv7HokbXnDL9fOxO9vLKJ3Id8HImotrHEb2OnR7l1ygu4TBJ7yXeyOcpNY+zFZW4GdiesifJnJRLooGfBxne39rlZAxUk9wEJjflniKeuYxL8e+3k1TOhFOOCOhpuaPUv8Xhw7CUa0c1UBAWyLSxN+h2xgrh6KOl3IQzBYdlzetnMxEEDbvQeVMkqFqu+v4rLXGr9YX8kwAN6c50VVUzuS
 rMxGjvrP
 6yguUQY4pRCmaCYm1/GaUs3WwcEd6UZDW4azos4tMeGW88ac66W8VLnfcdc1MjjzsSnZUw+C5TSU1s5HivzPskW3hIsTfvImMe0cxvu+OisBW8hpQZStruc+Gfn8rvuAiJIgI2bE9oujNIckT9m/uoC1Kja3VMAX5bw3iIIdoPIu0VcafMGmzCorhcttQWgIQczncjgxsCqzwUs3z44f6UsjGsGJn6MU/mGjgeMiCzumKY0qDdCEctqMgyC2gI8TtqV3d2r0NyjzxGdc06OPqKq4CMR49+0kgjK684W2v90gRWCXcG2n+B0J+g++z1Fw4Ox1x0Ga0KAcEQ57rPpe29I61aMJUxdHIZo1pcZKcViwCGW29G36tIDxdMR7IkxXSEk8NMekmf7Sp+UyDJjakJb2Wu8sKTgzzhVCi7KMB/iI4UGYSTlfi5DXD/6el6G5WDKQDBC/DD1a6jLaI2XT+gDgHNPFVsLTNWhTZBEBSUBspkReqkEVW+1oZ/E2IpduxzWa/MevjAl20MLH59fWKI+pSkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

We host a biweekly series, the Linux MM Alignment Session, on Wednesdays.
We'd like to invite MM developers to attend and will announce the topic
for the next instance on the Monday prior to the next meeting.

Our next Linux MM Alignment Session is scheduled for Wednesday.  The
details:

Wednesday, August 20 * 9:00 - 10:00am PDT (UTC-7)
https://meet.google.com/csb-wcds-xya
backup: https://tel.meet/csb-wcds-xya?pin=1301132214803

This week's topic will be mapping guest_memfd backed memory at the host 
for software protected VMs led by Fuad Tabba.

If anybody has ideas for future topics, please let me know and I'll try to 
organize them.  We'd love to have volunteers to lead future topics as well 
as requests for MM topics to be presented.

Looking forward to seeing all of you on Wednesday!

Time zones

PDT (UTC-7)		9:00am
MDT (UTC-6)		10:00am
CDT (UTC-5)		11:00am
EDT (UTC-4)		12:00pm
Rio de Janeiro (UTC-3)	1:00pm
London (UTC+1)		5:00pm
Berlin (UTC+2)		6:00pm
Jerusalem (UTC+3)	7:00pm
Moscow (UTC+3)		7:00pm
Dubai (UTC+4)		8:00pm
Mumbai (UTC+5:30)	9:30pm
Singapore (UTC+8)	12:00am Thursday
Beijing (UTC+8)		12:00am Thursday
Tokyo (UTC+9)		1:00am Thursday
Sydney (UTC+10)		2:00am Thursday
Auckland (UTC+12)	4:00am Thursday

