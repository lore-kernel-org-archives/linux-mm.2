Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2642A606ABE7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=gNOjmhQG
Received: by kanga.kvack.org (Postfix)
	id 089F46B05B4; Thu, 12 Nov 2026 00:36:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 013336B05BE; Thu, 12 Nov 2026 00:36:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6996B05BF; Thu, 12 Nov 2026 00:36:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B542A6B05BD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:36:31 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3A94C04EA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:36:30 +0000 (UTC)
X-FDA: 85425356940.15.94475CE
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id EE04FC0003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:36:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gNOjmhQG;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794461789;
	b=daOuyew7t9sf7Kdnm/38pXq2o7UCj+nwE+Wg/18orSOT0azMAr79524vV3dnJBvR7pqIjN
	Y3DAESdGpv9rX9A26FXtgyGq7xB8rHeXGeXpZlbBn+1qRmLWc9xp7n8xbhoiMeUUFq1AST
	MD5ky7bNQk4VcFw3k7pOFezbKBQyVWE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794461789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2soeXJ852281gC+OC2yZSX9G2s4v3lG9pbKt+VP0DM=;
	b=I6FbwLB/SiBtLQ8NyfHGjDf9wvVL8NKg1POJAMirBDgY3BybS9wJ5xpyZrOloOzqnm1BVP
	AyZP6Bv9fmh2mtNIAbRHxZtdDNmayfj1Y0n2LN4GZHzxYKhksSXAWfTdcCU5T+YqW5Ve7x
	jU2dJBZyJ1vhktLsgcurXEU3yXOAwh4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gNOjmhQG;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93e6eb77f0bso350311085a.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794461788; x=1795066588; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=e2soeXJ852281gC+OC2yZSX9G2s4v3lG9pbKt+VP0DM=;
        b=gNOjmhQGRh64pM34CBMJJWA7uz/toecgZj7qZKBClt6d6VKm+unfUOJuEHpy9GEQc7
         5TD0G4QtJ2zmdKLVkz5GD8UjKcPFiTv6HTt+Hy7U6mL8hTNR+OHTthMP0TMV1iwXULs9
         mUPLCFr+SED82wu+3W3BsKv+xpm6orQ1fGDUwFtO2lMpmDOtPS/wciyGf5nIAHgxkT4s
         DT2NZockI8TZgf4TpJIHnBn8xtwyjonDqTELwcySSyw+vvJe9GDemZ383nMn8BYGiuXu
         Fnr5cLF2+24vmIhfDqNaZkh+B55hGvkS4fnUM+P0Z2XjgntdzCcyh79rKKiGT2HSrPcb
         ovMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794461788; x=1795066588;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e2soeXJ852281gC+OC2yZSX9G2s4v3lG9pbKt+VP0DM=;
        b=kNV1vtNTRQCvDLm7ecZd7gf6oCrf8o5Q4r1VoEP5jQvnKtp2eyrPH5npr3RZqMxGzx
         s0R0d7dus37XeAX979sht8JcFytbw3uF8TErrroNRGGWPCP1Z/ZY/bzK2unun68cMysm
         Elus+j3EwTGom6FfMEKV6XM479uNR5CeTsm9IfPGsbdyOonKMN1Q8CFsU+QqPTm/KQHU
         IIitoCcZpQ3F+dEehInCfoJtm2FVzdbrWFEuA2X0IvvJfYW+q/29IyLVW2X3Z53WP64Q
         zjR1JKvoDudlSDZNiUT2jqnsZFKJl5CR7Zh1avBibHYbj9csqdoK8sRg7HCt/PWX16Cp
         nI0g==
X-Forwarded-Encrypted: i=1; AL+hErF6SIAxr7YV0oG3onlH2QwczpKcN975cYZLnRmKJLdMKtGhymMm8UabJ+8zXPwIqAWWMt/4p7sd5w==@kvack.org
X-Gm-Message-State: APuU4Z8e9ITKBmCNX693q1koPMlgvqeUwo9SRLRHOFYpdJwCEr0CwNX7
	WRVUnDFOYnhUA6oCEMLicU7nWQz/1jYsS6zq0J19sVmKV8dT52IF3kQxHyLEVDCoJmE=
X-Gm-Gg: AYBFou3NorCtYiSOw8FckzIOacCIAtzWUZWWnwNxgNQ4uzjYcPxt8mTPbZIG6Ozv73I
	5OsiB8/dUeXS8SBm9EeuMRSkQmaXqsVzf5h5DNI7NCXStkemCNkT6z3Fu4G9MI8U2fP9ENkwnrR
	xXH+60UdFbfQGrGcDJfwTLSwL2RYR/8esqF+kYJ33HybxUdgAsVkTs7trmiiuBqAY8RsJtex3NO
	37jJ5HeeLL8wqkdkeEQTSem8p9hI8L2sGxoGLgG/88U6q1Jwuxj6nvoktYCkHUF02K3OETrReqo
	9qosPgkHyzXXOT0rvxYq3tMA3ZcT/JJ1uxAOOIuHd2DeTonmOuEAeT+Elz/W/tmk+9cqBorrxfe
	DxzGWGxbCTlQjSCZLSNu6JrEQx6dyDvpqnNzkcIfJ7R5JU2C3tVB6HL/5PdnyiSvhOEQbte/k+0
	Up8/7iHWDIed/IHUHWKyEx2Zfi2bQwLdA9oksauUTsOXsnugL7V4I2S0N22QNT8x00+ys0FRND9
	OQRCY2qwtB+vSnRm8927WqT9QE5wo4MWBWZO77I0O0tHbOJCBsNTdreDbWLRqmbrSv+oqdOf19M
	4k/iWrd9FiJkbT/F0W0QMcHNdTa1nzIRZqmN6gGETfaLRFdI3TaxowAZ8N59vRrLhdrNgPElYjw
	QRPl2wN4=
X-Received: by 2002:a05:620a:4481:b0:93c:c2c2:40eb with SMTP id af79cd13be357-947b0046fb4mr764496385a.66.1794461787830;
        Wed, 11 Nov 2026 21:36:27 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e4fa312sm647786285a.0.2026.11.11.21.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 21:36:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 08/13] mm: convert miscellaneous VMA flag tests to use
 vma_flags_t
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, 
 SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
 David Rientjes <rientjes@google.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, damon@lists.linux.dev, 
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org
In-Reply-To: <20261105-late-2026-vma-flags-v1-8-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <20261105-late-2026-vma-flags-v1-8-0d3cd15ab75f@kernel.org>
Date: Thu, 12 Nov 2026 00:36:24 -0500
Message-Id: <179446178440.482102.12362401790016415292.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: EE04FC0003
X-Rspamd-Server: rspam12
X-Stat-Signature: r9nk3beaffedgujd5owrrk9tshs1a71e
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794461788-289631
X-HE-Meta: U2FsdGVkX1/5KAloQNxlnTm1S7PqNFNL0ohaBwOqJSBBS6YeCOvtx7PSgCOf83iG2XebRM/1k/2JVNwBO/cT8M0iJVfHuEibDa6DB4fAMvapz4dA6L9GUgHkNkxX7blSXwR9F7z9oICHAbOv0fDeZClj4HucH4+ElINAkVm55+NIVX2QrOl9ksTUv0W43vKzq1hCSUbFLtmnl0RO3+rHm3nqLMz3a1qlub9tRlcuavBO8biWSHfPEjQAoSUdCYScteJfyyuCYJbq5Vm2cna+UqZ8ehgxGeb1N14VGlkLZIKQfUO/4rskhgewL9ETiIyYLFvDT6cLPyG7PEQHgzQm6lCEhlua6cAZ1rLmLeRGBqh8PUdMINsaA/r8jW2lDnOtAbDVkaV6rOO06McbwiHIBJPMsM8Bdyz9Epf98ygZp4+ZUsWCqwqBB86lLHhnuCu+gdyNEuiNHvaSoYKkDf/MYrE04LJPO4AVNIAvaLf9uztSjbW6ZXTMBzRrXZRdWBjvZhsMpsTTDtXfL+85E6riaJgVoY+4kOQIF/xE1tBftZ3ngClOQ65Xm7p3/8w4dbF0OVE6DLNJyWitDLNTQCBtZn70c+q664NxRrvYItm+tvrhxAEuZ9fNTVtdFsC/2GYRwcbh18A7xPfiHTQdaRjnCFK8vjCFf3tAufaklqki+rXqiuWXLxVU3BAC1PozzwdV6bm4synuWJErQsrT+yWihkJsXAXbob0IIJ+bRUIjjnrkH/yt/LXVtdHzcwej1WItA4wR+n4+We0YGubWKP+DgkaGJMukBWvgQRbxNMRwQP6tcVEeKqZnTW1ijd1aK7KOnOgIQ/X9DFJ22I57I/agulj+KHFfrG+vgHcxyzpeNk8Lvcs3S+Uv/gXqW9fAk0V9AlYYlyUnGtvjFnxn83WmX0HsLbd0UPj8JzVIrmLtuEqbFYCA9olXYFgcKK8QABwEutGntprivsRSA3mXW3R
 zFXl8IBG
 k2Gp+9yhVGYeAz901AYFl+p59bnLX3j4v6uyTOtgCj1+rHGZPzYjn7xQvp1AsOpUgR+NuEdLpdC3QGNpkePqjdF2sD6pJO2mypWezEIef9FSVSIQ+cQMWDSvXyHi7ux6giNjSMzA7sZV8m9/no7t5CJLWEAv+d2HGy0dFeGVGmtEPQ5jE0ljQObhUcUe9xlD/i8x7LuzHwUHV4w22+sSDRU09VUFPP+6aLlDLhg/JCxcwT6yELA14gCNCDDtGVJPjmd3KtfEr4+O+sD0+5eA3pLFKcb0m2Mq5IHm3Y8rKQBxCs3yGuvmzW8+QL14IAyJxmKKT4aLReUopUL3sazGAs3ED46efLyNw+n4qmtq0GfY93iXBauGYP+MnczC1XChBXZCrR3a2WZK42wxgQfFZAQrPi7cyBhNAyXA9l1oq09nWG742MsMSoHVTfY3ozvy879ObQocDMO+SNCQhp/6h5ZyAiaW/izOBhGoNt/k8lQw2d6SBfvGM3LBHQfIuye+V0FPujIc3vV340QVjF4rsostS/Xr/gHgQ8Gv/EL+HiQi+YP5IG3oHteVB7hu8puvyCIg1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-05 21:30 +0000, Lorenzo Stoakes (ARM) wrote:
> Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
> remaining straightforward VMA flag tests scattered throughout core mm, HMM
> (and its test module), DAMON and the OOM reaper.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


