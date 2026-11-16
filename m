Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8EA4606A8AD
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=DYRjMOhX
Received: by kanga.kvack.org (Postfix)
	id BD7D96B05B7; Mon, 16 Nov 2026 13:22:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88F16B05B8; Mon, 16 Nov 2026 13:22:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51816B05B9; Mon, 16 Nov 2026 13:22:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7876B6B05B7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:22:44 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07BB51401F9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:22:41 +0000 (UTC)
X-FDA: 85441802922.23.C7410F9
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0B0BCA000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:22:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DYRjMOhX;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853359;
	b=deKsp+7OP34KBOxl2mQdgr6WYQ0qNZJEjvHlNtw97yjQdrfgLq0YZTkA0mEz0ON5Q1AO2y
	i+8q57ol/ziKVYFKukbiyNG4mj8zxgp7glVjb1KSeUBsyy4fsrRWao7twDL2EVDXmXG23S
	NFZyh03rqyR8PCJnpGLTw6uRWJWqOEo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DYRjMOhX;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MqhyZLQkkCy8/4ClTcekh7qpvqyyl6/PFl4tE1ESvso=;
	b=1Cs2kM0xMVM3qZvE5IaYoHJXe2usN3/ETDZosws0UN0wP9c4/YyTP61telTqeIqDxDo8gW
	9T5l0BCYu8OgS5yeVck/nbOLYdIC0BGHBM3/DGOh/JwTm53zucVRH4PqA3fqH/GyEwsV5C
	EcPFza0UOhCjwLagYwowD4SBJ2TkLmg=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91ea0c05c92so52767156d6.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794853358; x=1795458158; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MqhyZLQkkCy8/4ClTcekh7qpvqyyl6/PFl4tE1ESvso=;
        b=DYRjMOhXEbpop/nPCqqKq5Hr6m2ig9P1gKKdkEOvkZTN72Q44Vl9M57y6P+oMjTS6B
         /Qn4mMFUEziDYOgu4J69Xhts0tdmDjX8Wrw91w7cEi6MBx0OHT/wZAQ+NJFMHneDYgQ9
         Bnu2mi9M4SnJ6a1vcPuXo8QAblQbazV8oP9bK6ijL/YZE8GszTOqSxzkQD+z1m/JRmuV
         MIWQUndkKhc3JWxbvv67SSMZUfm9gUsT253fzlSnUXPla/JFwImhd+243nlCpc6URDsY
         0vRoHv1GBF43yl2AK5aS+k+Y8fRbRMnGUHf9CfJirjVO/MZvQZkAK3PJpeoFD9cueqKp
         WR9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794853358; x=1795458158;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MqhyZLQkkCy8/4ClTcekh7qpvqyyl6/PFl4tE1ESvso=;
        b=nTTviGFXJOaD2rUdhIibG/inC6hMhRTPNAn1bEst5U65llm7ts71sEEEClCt8Nn3Zs
         YCgNe5FQGBY7oQaBve+fWa3CpHmS1C9ODMjwwiKMHJPdIv8gCe635pw7Sql1Zijayt8H
         g46aUC3CABSwJxsJXNsQqjISEBouZoQ00Hi0kVzzmhRe5lw7rnqbFJ8Q4MIL7m803L+m
         yzKeqO23arZ7b3vjGGVDeyldWcA5SL8eM3WORpdmKqN6ZBFi8OoGPwpek/4BWWnL9uj5
         v6cEB2ffVxZzpMPNh2RR8M28UaH0wQ5FibOTMw5l7AmHcDRdHJUBy8QuMXXGLGNpS/2H
         Yx4w==
X-Forwarded-Encrypted: i=1; AL+hErF9L5av2tJz79AyUR8GiTZ2OCyVlWVT0b6lZapUhbWpVrRvBltxVH7YCw9UnRb4Hs3axiyD+edrUg==@kvack.org
X-Gm-Message-State: APuU4Z93oX5KpRBlMnGiZVnWBS4NIqhc2pYLfEnkeTXvJxuP5Q9w6KY+
	ssH8QjJjrw2+pSnSm3nU3I9nuPNnqqZKpjcVoe8qufFPUfmcx2pYb5alBXklNgYafAQ=
X-Gm-Gg: AYBFou2dHMdjOrzMTYv4QivzocboZkRA4Uh2HQtHeVO3RklbxtPcxSQ+r5hrCRna5jJ
	ZRwAtMe8YYXlOb20Z601PqKG+L1EYquP0OjE/tlQuH55T9QbAJX06sxPyPC160BfXvRLznJ3CDX
	cKbXzdeWqfxqzE3ec4jPTnFKO/jbQsA2TXigfVGB/cdu89SVZKTdAinmylGC+Vz3AioLPiUblQL
	6nZBVny0hEPcls6Hvn5HerbOhte55H7zq1JuWfntY5nnlXO5Anj2TuMLIHe3tiP25sqESCZOgg+
	ruaEKJDh8MS9TqSYvQ0TylH3Z9S+ybnOVQ4DvAvkYslp53kNpp89ZMhw9ITCGYdpi+SRH5TbNac
	F91rj3cy8lo2WqV0rjTzXpBUofttC+UdrAfXaByBzGROhuLsU94qYrbV+FiwGh2eFTlUQQArd7a
	j1Ic/lklFR1Nw13pXA+I0tCf+NFCUGXbozzAdqgxYYo1MDB6ZN/ac8XX0jkAAJGTjEbRMeJsqNs
	DBDbdOSh/LPbM/9Qt3n5oBrQfM1pp1cfiDHGgcLl1OfmAYVmMCD067/nArn7sapBdhXx6bGjbcb
	ilARMwpxZ8Ks8ePyx5yOkH8tSIz/hBoAERY5dPZfGiLYcAaWRS6lvQewraD6DNciwNxkTqmnlOK
	XxSTvqyLjs1p/0nFVMpzjJkhFmEp+
X-Received: by 2002:a05:620a:4111:b0:93f:cbd:8e20 with SMTP id af79cd13be357-9494bbeb2cdmr1788283985a.73.1794853358208;
        Mon, 16 Nov 2026 10:22:38 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c836f6dsm902791285a.22.2026.11.16.10.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 10:22:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/3] mm/huge_memory: only compare PFNs of huge entries
 on huge fault insert
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
 Roman Kisel <romank@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>, 
 Naman Jain <namjain@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Eliav Farber <farbere@amazon.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261115-huge-pfnmap-fault-races-v1-3-537605643f6f@kernel.org>
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-3-537605643f6f@kernel.org>
Date: Mon, 16 Nov 2026 13:22:36 -0500
Message-Id: <179485335600.482102.464304486749600271.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B0BCA000A
X-Stat-Signature: 1fx7d4prokctcu6gjnmqiw75p5jo8omx
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794853358-862473
X-HE-Meta: U2FsdGVkX18Ur/P4mvpG76PtGXmvLxtrMDe4Ib93FycXmwV8sPgWfmbmbyWxE7FUBhroPwnNVw/ceUk4v6iEyh+T6ZWGwUIW3A+EX0VyWZOoqKSno/VAcDRaXDaIlwF1SLA+ZOLAKLVanuOe4HIgC5jEeACBE4k6k/UzO0KdazXnZke1jPpW/t9CH1IiSFKmY0XB9dCM5cEVjyTFpccIF0LBx+mWtRb+Q9vups/X4BSBczmPPV98+hbfbCpDhK2sKiqtfyGEs3OWFPC6VfRl2MYW2YkUkiJW5hieq3PdsPpputs59RnAXKZ+P+S8DMAzRAKwlkJugrV8vi1HHf4v34K49W5FlsowLT69GtqBaKdZpUZDbzYq357B6iM6ijmSqpye1dYeEE9iFTUA1lcHzJj2TspFUIT7PO1x2qM3tBNCEYA78YmVVID03ZUr2dXfWpvQboylk49qqkw51VRveyAIBxXuGUlJNp0RgOqLDTtyrToOtiuQEZ2CuOMtshItHVRWE4GiYmtUFvYlSfOUuwTARDJYwOIY3+4XiZ9kSgnp/yQXJNz3KTgpoIGa+YVKrs2+I7bb2p2lSYvDihfap4j4EI/kJs1V9O6O5aEc5S1ANcJnJDBvN/8a4ecncldqBTl6OXsFlMKsRxEUfbo3o/MrbAGJ9JOi4ABiUDPSSGASxltZV+5EOdCjAhOVhRE+S2R/dd7ms6ReDghJ/LHHZpGykUhMfeWdolnwWSy50fdu5yo4CLFvVS+a+E3BFfRG9mB5rScWm3kNvoS0lMjFIWgYid8EJb971zI3/2HUXOPMIRv4d041iWpJZ6ek1COzJcvC2InySK6rwS3iV+yyjhCC0m7dErNUI3eXX4FxI2lrqAqiC1vBhmcUFEDBdFJXsqmXCAb5cIMQolm/R5uePbJBJcbmAMlwFdnVLjYcbNLldSNsZ3jpBb5iHgMreyJQL0fB+vDOd64X0yJeGt6
 jEIS6aKW
 ZtVPaA6NHbxZTuK3Awsp9+jVfASpWljR3EV84q8szCZdHp92YEnYJA/NgKBiTlq83U1fIC9cZ7pEd7oulpFq4BKp1bLF2/FuvxWdaiZWgsE426XjvDDF7hhmZ/U7y9Dybcpps0wunjy8QrfIyOZRPD+QNB++KJfBMSDPi5AbkBlAboretuyvg+pHnrrNif3XfXFUe80ib3ehd3nlvMVs9D2h0oTqip5jL1PxzI8JkW4SKkD6oQ8v5O30Mq7CTWZ8H2WX3A1EucP6xcSFkGAkY1oGufrSMcu1ZzWZhg9ye+8/B4s0Yc/Gtmb0L4mRsyWqZkJQqRTlsSW7tJKP2TMSoq2ep1wt4nLUNS2exJKFJ3cpf9iziQJ8FAXwZFwRuiqnzdofp5Wiurt9Y+oWI6HqX2sPwMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-15 20:58 +0000, Lorenzo Stoakes (ARM) wrote:
> A driver that implements both ->fault and ->huge_fault must anticipate
> concurrent use of both.
> 
> This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
> concurrent with faulting, as that only holds the mmap write lock and thus
> does not exclude faulting threads stabilised by VMA lock.
> 
> insert_pmd() and insert_pud() have issues with this as they both assume
> that, if the page table entry being populated is not empty, it must a
> present huge entry.
> 
> This is problematic as if it is a write fault, it compares its PFN against
> the one being inserted, warning if they differ, on the assumption that the
> entry is a huge leaf.
> 
> Since the entry may be a page table, this is invalid and can result in
> spurious warnings.
> 
> Equally, the entry might be non-present. Nothing can install such an entry
> in the VMAs that reach this code today, but there is no reason to rely upon
> that.
> 
> Therefore only examine the PFN if the entry is both present and huge, and
> otherwise simply return VM_FAULT_NOPAGE so the fault is retried and handled
> at the appropriate level.
> 
> This is what already happens for a read fault, for which the existing entry
> is not examined at all.
> 
> Target the commit which introduced the first driver which both mixes fault
> orders and passes the write flag for the fix (since this commit, both
> drm_gem_shmem and panthor are prey to this issue).
> 
> Reported-by: Eliav Farber <farbere@amazon.com>
> Closes: https://lore.kernel.org/all/20261112051440.16140-4-farbere@amazon.com/
> Fixes: 7bfe3b8ea6e3 ("Drivers: hv: Introduce mshv_vtl driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>


Tested with a similar test to patch 1, but used QEMU's virtio-gpu device
to generate the bad condition.

With just patch 1 applied we generate a bunch of warnings, while this
resolves those warnings.

Rethinking whether any of these should be squashed, and maybe not.
Really i guess patch 1 just mask's the bugs, and patches 2/3 fix them.

Either way, change looks straightforward to me.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


