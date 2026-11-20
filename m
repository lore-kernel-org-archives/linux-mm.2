Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA210606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=aB7dATD4
Received: by kanga.kvack.org (Postfix)
	id 1A9006B05B6; Fri, 20 Nov 2026 13:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15A276B05B7; Fri, 20 Nov 2026 13:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021E66B05B8; Fri, 20 Nov 2026 13:59:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD2A46B05B6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:59:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6ECF3160147
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:59:08 +0000 (UTC)
X-FDA: 85456409976.22.F7EC7C4
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8C00A40006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:59:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aB7dATD4;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795201146;
	b=yyun1pLiMar6ndT2oxD84/pHejI0IKlvnKMASfhs4mFR2u40wbVEgN0srkCCR0R7mRx6tn
	dNuQpxFf31lwikeBIInSyRzLRdSk8rOjsV4TO5X0eevVV5ILBhO8JdH0a/9GbP/8bBeLP8
	zZEQkhconL182r8QJguFZTG1K5Iz7Ro=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795201146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QpjWV7nVPK4jNL88HvKbtHJ/44FkOvQPFo/KHrxl1Aw=;
	b=JmntCT5soePzGr9aZ1BSsVJ62+WIRh8sOzbRcuXDdjjRHq8u1+NWg7Yrrui+PPfnmRM9Rr
	3dNmtlLF0aCMttKOGX1NGE78i+BpzK1CXXr9J2m7CIYB+vwX+WLyFowVfXMGRj7uRAZx/Y
	pYslQ35CGOvSguPctzLiD2o4DXlZrWI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aB7dATD4;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5365d26ccbdso15102611cf.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795201146; x=1795805946; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QpjWV7nVPK4jNL88HvKbtHJ/44FkOvQPFo/KHrxl1Aw=;
        b=aB7dATD4y2vkGBwRd4tRwWwe/SzDJ1YYnucfkLymczXYZ2imTSfEG6yDULKGWeo1nl
         0PMh6REo8lqLkTtDxavA9LOKKoK7f3SC9qCjXvLZR6uK7ZC7VBqTEGPtbgYSyMRoHLox
         TaECxuFxZhl2M78m7p6iz7cAdN/MMum0jg0VzNgG9BsimAUs77XNnZiYU1UnPlaF7K32
         TOSTjEG3/iSTVIob3tzxsWsUlum9tUgwoQ4MoPqh8z2hPKCuaGFybKHoSdw/kHy6L5u7
         kuhvsgS7nRv6lcgSNEHQC+I7bQKh1TwJtOG/HCBioJ8+yw+T+vVFbIY0z/wCPkSg7vyj
         bRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795201146; x=1795805946;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QpjWV7nVPK4jNL88HvKbtHJ/44FkOvQPFo/KHrxl1Aw=;
        b=nF0AYVnq9LJC5pDleVpyqwFd01Tgdf1GTOQgZ+JgT5wwTZXhGwBUXuJet3a6rcSF+h
         T6sxTpvLKTuiABNYqxdpTg1u1VW7FWPvJ1fMNpMouQq7UT5MIX5OobucesbgrXrsSYr3
         pym77sGd2g1sA6w6xW2JgXIiAxkCH9Iv45wPRioivoT9275L1+/DcdZl1+uFhlbnfS3O
         KnZsLXYOru09uGOjEIZ8EoSrzShgBjeQWuRcwxbJ+lfamdGfGEa7ICLdgITJCPNahxwm
         iLDddIpMj/JaOQT2+QRVb+jiYYh6PK8pj/zxgSgei2dDcpOYDG+EtoykzdFSlTDoSIB/
         oEBw==
X-Forwarded-Encrypted: i=1; AL+hErFKFfyFJsU/H0Hyq26tg2h9JefuPgdVHsuK7kJozuEXmLoKgzqjpZxVC8+gAqGtVR96KL6ZsoeXlw==@kvack.org
X-Gm-Message-State: APuU4Z/IXnzIrCjibqsOr43zocvw7IyILembcPLCxEQnPGmjbCXa+xOm
	cTteVEzZWzzfcjwAEh4Tv8uwgvIs1VaeDHN6f2alEhFOJKZHdHgCEZiGIVb+j8ya3BM=
X-Gm-Gg: AYBFou274M1Qxll49WlSCMyad0ojQryS668zU7gUlanw1+pv1h+0Ehq3Thiqaa4BxQW
	zFI+ILJWoSFKYw60valHAcJZi9wrHf7xirS5YcPv4csWRLOMHfP2w57fp5EhpUssMZpdYdq9SXX
	XM6JdZ7VAL882iQATk8vNngZpjnpcn9jYm6lPf+uaG9bKQldt14aKb+7s2Tg+tQXti0VYun95Fn
	tDdE4kod3nrlfSTRXucbvg+IYcadxX594MPRYrTZ0IM0VVGCTvcfytgOQfGKE5FGiplCX3Q/4UR
	2wjeSbpUxXHqsTlYb1nFa1gJ03yJ4+JDX8RpcAupR/+9JXIffYLbZDS3aYBGYDUgl8+jfzbEgT9
	Hy96bJVX2FgXjl/1Tuqa1Tfh4n8n/8wADSoX9xvk3z6Um0VkXsLFcjL3jDqwS6UrGXGOGSCFpCV
	D5l0nrwMBUbGOzPm/+vXC+0Hd6SVBO6iJY4xMdgcK3Sz8K2B6J5jRKq6OiPb/2e1coTYXek9Uui
	hlxqVCGvpt7A/vhsKFUrpUwSQCpri9yZimT/0xTyeKqchwIeiLAuPzE1536xB6ypGFmJVFFg6Cc
	XGHs7PIehXlfQqdk+EOMdKYcL6Nmrm5Am4xnb0/7Sy1di7W29r493gzdB+bwl4c7l0sI2oreCfL
	CbUhoOXk=
X-Received: by 2002:a05:622a:1a89:b0:55d:2c9a:3776 with SMTP id d75a77b69052e-55d76a811c8mr74428711cf.65.1795201145651;
        Fri, 20 Nov 2026 10:59:05 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d7884d01csm30305771cf.21.2026.11.20.10.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 10:59:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 00/60] Private NUMA nodes
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
Date: Fri, 20 Nov 2026 13:59:03 -0500
Message-Id: <179520114342.412063.6068641130948664600.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8C00A40006
X-Rspam-User:
X-Stat-Signature: rsz6theqie5kgenjsbin6c3bbp9qaezg
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795201146-696165
X-HE-Meta: U2FsdGVkX18URnLrOWCL6IHKTNwSyseJVMABzWW7qkFZSXyllu2RSNapd6tTOA+vmm810fmqwqz7nMPQ7S2F7zkWMQf362CQVFk9v/6mEKp5//ua8YCoab3E9Wvb0N974jxw4nKzzVpBZiityw4DUTrP6X8j7+DGSGtNgc+m/tYiCdg72Ir4P+aLC/R08EoGouuNtqQoPs6+W2/N3bs+2jlbCBlf1UnxxJAoiXuOFfUSSfFhGET/K0nfiuqrYdCxFpKzSAVo4iW6Vru3qyvfGwuOW5uVJgw173JdDj7REW+XlOi/74P3Ic2AXpVKkSiqgxLAaQ8IvWQclYXmRScvOaxtRJAeOw4f4R/bSw9V23Heu1wvtgsfaZjCBn6jfw/idzpL4HizRJdmRRZsuSQb4msbaYeolENYrS2v6sYfZDfe4Y9jQfYiCc/gkI8ZpZ90I5tjBxr9L3sUA8Xbr2Gli6SOnCqOTe+xLwrTPdGpxnf0W3tPtMyKSrXuXixbVKm6cK4MNJqlfFIFTEFKjyi6qxxNIjZVAXNIAq1T/i1DshranI3CVcipOr0N1d114pgaimLCglbgGd+OftlMSaiIvFMKFeX1KRjbUAD/PJ9NLLuqwVB6xSAGz9t3yrKl20YW8KGOrHUNzmhq2hiTAa6e0ei3L6WcR415meiTw2G4j36tjBObMVRaVhO4O8uNASAIUOphXQx1JxHqErVLO73kbi6DJT2jMdyueDysDKWDhbZZxgCedPKcBphGhpxonnEVv64QLsnTZ+QY+sL16FeC1TPDJOitwbK9WFJcKRJyFOmoS7C72BAyMeOi+IH6EhJjTjd7XeAvX45EscWirdKPhqnjvIbjOMRppRkSPZNCCFzDohnJ5zijC0uT9P2VyAnDY4bq+NSYe9dL4RXA9sukixi6tveM9TtvFvjOqFGikRsdMJRX/VMEVTPuykf45v4okvpNQ8Lh6uipKBKAAYo
 jOPK1SbC
 VAIw4xKLokCIQedhw0mmBQNf2ephtRKQLE1gvQbwlgUsmLAeETvfkKeYx2U26k7+yECYMvNmWacdolm8LXH5TRA81UmcJ3N2MYL6dbpTmOvYYTqa507mrSZndxq1bsYvLKawnwdgbxOGkPRcaBa3y/CS2ye4jHntpgKY4R2SNggwvx2vyAHC2zNOZor2huH+fd+fsYi2ousCkCI6Qmp2mB+z/Vg26+6WtFqRvpfCT/YFLzVW3dbj1NqzyrRn8M3S2VfrjUMreGTItSTubTskf4zpD/+bBh506Jk01n2+BJ1klYY9jNGnzJ2okUawvzwS9lzc+YaV/35B9dRkd2AwTZYg1QnFHV7eI0EGr1jAZZngY00BhGLJsZkX7BTiBY3BOES5s94LXpKOcu5QDzob999xXuz9A07jDuW0vq41ibzXWgbT2VnppEMl7eEwrR0D55DibyDTj+Ba2IwOWQ4eLIoO39nunTDB/3LGRdrvwtrc2+0dIfWLQwKI6koTpYn9IYYBzIUPYfJJLqmUVgczYybLPNVnUMKg38tYVEFT75exgqqEugYxW66v0k7Mk2L6rYqB1zY2ia0cPkofxV980ugEvHdY4BobWh05loKVQOfiBXM8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-20 13:08 -0500, Gregory Price (Meta) wrote:
> This is v6 of the Private NUMA node series. The series falls into four
> parts, each building on the one before:
> 
>    1-18  mm: introduce N_MEMORY_COMMON
>   19-26  restrict folio-walking MM services to common memory
>   27-44  N_MEMORY_PRIVATE, kept out of cpusets, mempolicy, accounting
>          and the page allocator's ordinary paths
>   45-61  private node features, memory hotplug of private memory,
>          dax/kmem private mode, selftests and documentation
> 
> Patches 1-26 change no behavior on any system and can be reviewed and
> merged on their own. Without private nodes, every path in patches 27-61
> behaves as before.
> 
> The full stack is also available at:
> https://github.com/gourryinverse/linux/tree/scratch/gourry/managed_nodes/private_nodes_v6
>

Apologies - my b4 prep dropped a commit from the stack because I made
the mistake of filtering on author (myself) and it stripped out this
commit:

https://lore.kernel.org/linux-mm/20260923211041.3127588-4-gourry@gourry.net/

The commit is one the branch listed above, and should be otherwise
indepedent of the series (can be pulled in ahead of everything else).

Sorry for the noise / compilation error, won't happen again.

-- 
~Gregory


