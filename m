Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5445D606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 05:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=a+cjQRoe
Received: by kanga.kvack.org (Postfix)
	id 6A1066B0619; Fri, 13 Nov 2026 00:10:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651716B0624; Fri, 13 Nov 2026 00:10:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518CF6B0627; Fri, 13 Nov 2026 00:10:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2758D6B0619
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:10:34 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 145F7120A0F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:10:33 +0000 (UTC)
X-FDA: 85428920346.16.DA4BE5E
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 28F7420004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:10:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=a+cjQRoe;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794546631;
	b=W8TIenhyiqwE6HHVfvOghCVvFd3bmOywAJRT1eH6faIpO69lBMBWH+8KThOCo3Vzpc1Ufh
	9hvD6XHxC9/ab2vM4F/LYdhnO87X19LLZ9QI9kFV8ur3uMRH8SopQ7LLqJkEN38XnbWvsW
	NnHM7+3pJR59qMpnXBtUsCVbIswV3GY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=a+cjQRoe;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794546631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mgkN7zfne8CxcStcMwaH53uuXOvKnVLzfMEVlic0so8=;
	b=O+lz80vuFZEjTvH2PcE30grBZeyxH5kA3UyqdJwA4AvgHoJv+9bFNEMJm/YwWZ6HcM8w8b
	r09nl07QJednqnZ9CUs0p7AKvO5zKWBt6C3TTwpAOf90jFLg8WWbm8uWhlHC7D5qVt5mji
	bHv+kpYfRkK83idVxFsKPN1pRX7B0To=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93f2b8cf037so85316085a.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794546630; x=1795151430; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mgkN7zfne8CxcStcMwaH53uuXOvKnVLzfMEVlic0so8=;
        b=a+cjQRoewwIwH91dNR/ctq9YiVou5//K8jp7IL+C1hS+E/5SIsnC9UQgOFpIM0AVTq
         HgZiLPcoMZhrI1hH6Eb0uAZsxDqJTfioHscRYF8iJOQ5g5aMorWCJLi8oGYme8eHgio3
         TPDJiNt6WHJL3kK6bOm2jw3XoEiNCIyaT8i0T2nuljfic+MlBaVX4HMiFNhPEXnmUSao
         LDJ2bGauvvpnI3sPO9paYxsSoToc51K+hhTxQH/McMYjJr3o+cRWxvvLyhgs33fGOBxr
         NZwbQ9ffwyjICCU9z/iRKmk5XHvvX2+Khe3peN/kID0h91Ebl2zYKIT2WVOQTs+g+PBr
         XxTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794546630; x=1795151430;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mgkN7zfne8CxcStcMwaH53uuXOvKnVLzfMEVlic0so8=;
        b=iqRnPD3awrBF4H7m9sKyCxs8l6pUVbUs32aRO71Nr7MC/PEnJ6JOpDq9WIx5A2bJdY
         a05FSGBiYZ38FfpY45jw9DG0bir831iJ/i4iCbsDhgSab0XbxPfuFEdFjMCwhnbgFVHP
         bId6VtZGF2Y4UVQmuNhpYAb+HzOgIMdu9aGagu5aPQ2R20q8CeoM1/Zd2EAPcznxpgLI
         KGBcWczsUNjA34wO6a0SxduBodYHgSW1+VHWfWp4FvAhZxXsQi0EfHEtH8gaHK3MGzpm
         +q3WWzu/2jHKtwFOvkOD6IY5DGz0J/6T8I+9HoPHU+MHkJJXVdxSjcLeeZll/znAgfMR
         GD3Q==
X-Forwarded-Encrypted: i=1; AL+hErEkQw8ZWVVQa+KNs+hB7BsMaJ2mNRVJPUJE9/eoZ2VjKN/L+Uku96kwUjdPXQQTXKc5U3MdOaBnWg==@kvack.org
X-Gm-Message-State: APuU4Z+7X0TAP6kNt/ts3Q1EF4K/SBeo5dIEjm7W6Nyd/YujeZrfcIqt
	Q/Cy9j48LLmwEKarYUgVVuskaGKgLy6W7WmqR4YNSdt6x6KzPEQWPaz8vuoBF5OniOQ=
X-Gm-Gg: AYBFou1TH8FOWJ9QYXYNO3L4X1Kxp3gkmV82tb4OwIxKrDNiUq73S/a0G/JbV1ghhZF
	MU/WiDlySc0Wf6BT6RmJoFG/GHAFwAQL+0b8HJTnjFh6u7DGfbtaSOfV6okwzpB3mPtpMwh1RF8
	KbNf1Ip2zoWJOiFCAn58iLgNvwqUp9zJ8XtXo38r9AWppxFUBMKlnOvYL+QTLWU2Jq2YA3R/05K
	ndYU9nGeq6ljjNQy/YBFSppF9RWtAQya+63GV5RfXkCC77QPEb+T6AAf0yPe1NOQiexJFGLZYE3
	8vho/0fSuNpHjznxZxXBoxB4B5MzD86O8mGkJ5awScHQLWh/d+iTV0y8qx+OuuKHUShlFcMjcNG
	B9L8MUX6fOjMjvyaLqKdyOD77W46rSJeYyB00w/TRt2y9Egjr7b9ZS3nyrUI0qLtHTmiv/7zV5V
	2lLOJ4bwj9xbbU1LJlCDD1yQgPCS9UOEkf9vnUdqkYsudXk/OrZ6EoE5fOMgFz27MdUJ0ijTDHu
	uHIqNoPoeR6WkDeHvZOJvt2IVdKVGvs+OMPhBQrGOaocYCYHChsuakqFnudUD5Et5HAx3yGpOX2
	p4wwSWMNf4VaQ+680vWY4V9hjqDTzbldeG00M+k3/LgjgHvwagpMkA7xcT613NvIygX5zvEsQGr
	WTSisj6Q=
X-Received: by 2002:a05:620a:684a:b0:945:f6b0:db0 with SMTP id af79cd13be357-9494bb3103bmr245366785a.30.1794546630191;
        Thu, 12 Nov 2026 21:10:30 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c836079sm103580385a.18.2026.11.12.21.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 21:10:29 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 05/12] fs/proc/task_mmu: write-protect device-private
 THPs in PAGEMAP_SCAN
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
 James Houghton <jthoughton@google.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Andrei Vagin <avagin@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, 
 Arnd Bergmann <arnd@arndb.de>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>, 
 Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
In-Reply-To: <20261111-uffd-state-fixes-v1-5-00713d368976@columbia.edu>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-5-00713d368976@columbia.edu>
Date: Fri, 13 Nov 2026 00:10:28 -0500
Message-Id: <179454662851.482102.356362894816988437.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: sfr67f5fodf3x98zsw43kn6dgy4g6w6x
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 28F7420004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794546631-939992
X-HE-Meta: U2FsdGVkX18ScE6I35d2B8IHirCWkTR10CrRYmcjVIdi7iSyBW6j8/QXQ6NtMgPsWZiH59CKwUF2Dd4aJyifMtOf26ZmbS6apJJ8ItqR6ACuHNNjNPLir5ZBCay19ZpyCtQRe+YjBYK45fB7V5pssurSE5yIF7mSZReB9dnFHAAnxwAddR8kn71pcXVCHORTFqrhkDDfE1olJ0ADqhb+2APBTjF1MN7ZUWAWntnZ2EBWVobcH0InXUuh3tMdzleaJ/4UqJOxNysSE6NLkMoP80f3xWx3+Z15aGC8lk8k8nWr+P+QqgaeBpkoTqqxz23XZ/XhtE7Y0jPcsUsObK4wHZNZ0rcGiCnLGHqq7BmCfg/VbetWFll3bzITm4dnJmrUF7OtcdD/SsntwECamTeszWd4IHf3hOrbpjYVJZfENkVqgzXpGSs2Z34ARSmYCkTV817022hTjQ7I0mdPdhFMTf483nOTavt+LkbYNhkfNuJ8SCUCpvx7OIOcE6Mgvx5etpv7mldDsvcqfZ27uWPGFKgTpA5Cq2h/crxuqkoYil5oegJbPoP1fLIXwl5Qp+FvsmaIrNGPM3LlVV4M0xO9jJ/kq3UbmAz1XyTq2kYquBVE3zldgQeV6Ax15T2n3oXbC1d/gyyN4JGCU0/HW6npI96alWoYHSSjpHQiVnpesDrom/y0cOzFAcu0L4X2NvgVzLCSzuWjsX4ol57LITDkloYC+5x0e0NrikSHC6muOt9Kazb1fqLrgKw78Hv4O2TiRvdf4csmoitTtg0M2TXIRPBgsIqxOBAP+Fu2Ok4AQ6I8E7SMYz/HNZp6toxv6sUDYkSNt9MjJp7+ZeX18NnUx0vmFhv50wghnCIHaT0DqlrM4XvZ+jTdD9J28KtELH3HYNILm7+9xZam/zbfrQMhb9d4gigIayzEbbnLx5MICjDgoHOjQcckI7J4v7uGZxGb+4tnLrJZqIxr9kw9cJo
 28tvja9C
 7q7IzxuOPwAF0cdZlPRjL1buUXxpT7/fS7I6/JmLvEkZAjOm2xvwPkQESuVx9U0JjrYkvc6FDo7WgE9CVGDi1vigsOQ2GI3K7F6kfM5U3L85CSmfo/rgVyEAiFpd4IskraUK3NWJvdv96754csXCssv77wxOjviLGWUDKJrnvF7lt4wLqly1Nj3ceoHN95R5zdqBjBuXk3aopUidpqZUu/RfVR2mhsiQ1IQ+7EejHKpkQfgg0fsVcrwfbx6J4obd6NcforQIsEKmDnj3gTJnrWaKr7cxm2rJbPQCveuvpqwiSZjTlgWVFBgavdSISFZwqGeB3wgPCBFRKWLtBiV0PNX8CSGoZYT+Lo5WerHPZtSdkFTskfPjuQ46Y2A7G82UrR+vAYmhIoqAbXOcAjOKAc3qnenBvkLYKh+Bc4q+8DPiIZfe+Kq+TRNMZhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 12:55 -0500, Tal Zussman wrote:
> PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects a huge PMD through
> make_uffd_wp_pmd(), which handles a present THP and a migration entry
> but does nothing for a device-private THP. The PMD never gets the uffd
> bit.
> 
> pagemap_thp_category() reports a non-present PMD without the uffd bit as
> written. A user tracking writes with async uffd-wp therefore sees every
> page of a device-private THP as written on every scan, whether it was
> written to or not. This requires a driver that migrates THPs to device
> memory.
> 
> A device-private PMD must be write-protected like any other huge PMD. To
> fix it, pass it to set_uffd_wp_swp_pmd() as well, which downgrades a
> writable entry and sets the uffd bit. When the THP migrates back,
> set_pmd_migration_entry() carries the uffd bit over to the migration
> entry, so the write protection is kept.
> 
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

reproduced the issue by observing we fail to carry back the write
protect bit after migration.

Implementation details i'll leave to Lorenzo's feedback, i don't feel
strongly about it, it's gonna look bad either way i think :\

Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


