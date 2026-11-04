Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 588B8607F2AB
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=KFTY6WS7
Received: by kanga.kvack.org (Postfix)
	id 6CFFF6B05E0; Wed,  4 Nov 2026 14:38:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6330B6B05E1; Wed,  4 Nov 2026 14:38:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5226D6B05EA; Wed,  4 Nov 2026 14:38:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 29DF26B05E0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:38:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBD65120807
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:38:03 +0000 (UTC)
X-FDA: 85398447246.07.475F48D
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id CD9BA180003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:38:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KFTY6WS7;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gHsVZIyLB4LY6jVwLQ9hDHHfJ9C6/ccEH9xuZg5C7+0=;
	b=2WSvDNj8i0ZD8JP6dF9FeXDxVt5fcyH70R2+BO6o6ZNsenX5rrTaPumfTZY9Hr47wttTf9
	60kTh4moh67ufa06uVzW2468evsxDCn+7u+oil6Mhj8wW3bd+H50DcXWjMYLoYW3VsONbr
	HNXSA1jitabMQTmO/b+a2h5x+Q7basM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821081;
	b=sMMktZD0YHxkknHlXtEKvGn+ROYCK6610lvV2f91+a7w1uilHDi9zp/vea422wssSMo+ET
	wp4yogP05n7jcApdPdrGTbIqti1H9SNPUInApMTMVpwfnCaPMd8yExiTEbHcVYRVTGe2pg
	FMta/7VNPZgafID1HnCd+4YaB2/4XZo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KFTY6WS7;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-98c7798ce74so336697241.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 11:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793821081; x=1794425881; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gHsVZIyLB4LY6jVwLQ9hDHHfJ9C6/ccEH9xuZg5C7+0=;
        b=KFTY6WS7u7EQyp/7gQsAaYzlmm4calQxLZxzjU5ldu/IusxtaJIQ6laNocgqnPYerG
         ujsaaomsqzAX9pBMKHUep8T0HMDqm6veLWNByhRv1YRCgll+uL7ZWdeHSEPcLnDsTxxB
         2edV4lPrxqGqffzrJMwhpoFHjwLnvsMNWx5W2NkZvH5pDSyi9dmGkKV2M54qrizq+n/i
         QeFvWiibj3foRSelqJUs6ovNby1n+xiO9wUEojX0lFbb/HzyF6qvKg3JBl9HrZ7SY37e
         7SIc8OeEtU3LNLoOi8pPmz6GaB2Mw2yuxk1K2B+AW8kP4I2ekrdQ6ZptvAV3sLdDBAw5
         selQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793821081; x=1794425881;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gHsVZIyLB4LY6jVwLQ9hDHHfJ9C6/ccEH9xuZg5C7+0=;
        b=hn+GIub7QBVdFlCXX624Nq1h3qzYHtmwopSxQrjG4gZ/d3v6SBBN76bznkqeIsZDLe
         NzMLBZGt2r4ReKqwbKtGYjuRBkkzrktrnoExx1ffm8Vu82AK7DmGviSS8r6qKyQOZtdu
         KGo6vje25/icgzDWGNU54ckoRWsgIR6hoOWw+RV9NcrimRDTII7oVPXARrqyNG5wRRuD
         wwAYWx4v5E2DMOUnWxVDwUq+7ju7ECUTQpRwCfJpSEOEkkqy1ZoOqGp/fLJv+HCJza8X
         vNQ9x3ZpwyAl2goLa6HR0uWfjpqXbxiXfznYQvXTHeIVC6wFVC2JUMhxTG4TS0nhVf89
         mI2g==
X-Forwarded-Encrypted: i=1; AKwUvBy769bJAkNkmzfjeFzLzh7j86Tqm+JzJUBJcwbzJQuUVR4oNt2CPuz9C0m/hiN6Ez13wsEDsQaH/A==@kvack.org
X-Gm-Message-State: APuU4Z8EDoyn6WW+QrifjTVntbI8+Uvq6ep7E1o6V8UNmNYGttEaeE5A
	DNyWrTEQgfpQr++kX8rneBdLWuS2Bj+nRTUpnQWSyik4I9rHiwNSpZa3ZTy/ex3Fa6w=
X-Gm-Gg: AYBFou3KBpljt/WbIZ0O2iLrwH1+hGm1UVIsOaP7EeSbtpAYZyWfUJdMCuctPoj+M/a
	1rgqpTYhlPrW0e+Dc3bOZ0AfM6G1DMx2xbO4z4dRXM0QbJFy6sTUw/XS+IlFlJ8qwfly8ZSbEk2
	c/XUJOs8YYSRS55LWNNaEbPUID8JwXdYixY1Y9nhjSJ5Rpn5hFhzO7r5yHavuP6BcGZOBhtY9ZT
	LOBGltNKadPLFvuhHmDj04nJlLOnqPTFhU9UrlBeK3isderUsl5hQrwWXVUEcDbBV79Z0oZKPZk
	vuBA+7757mr0AtlB6F7Jk9laBegPsWK+sWAtu7W5fDlmJhrk6E74ccgDu/Irxj6pASeYSPxIPZp
	jphfRVlY0/ijTuuj3lWsewXoE/CWwR2+wJJ2+Aa122mp3t+zimQ9CBgBDQ5szuXzcCCdrn2i7II
	MiTuybNt0kh5Gqf4zQCosFrEfyr3PYID0jroOFY/kFnL/NfVMEn/7P3MHWMXJTTClUsyUM6BgaF
	ApS9CyRYzGx96B6ZvpyeGR+8e25z49TA2BmbGruFRwCzKBFuWJgK9X7FDYxYT4ZaPDferMOx4ys
	KrO9bTQnxARqzDQkB+r0aNq2cTG0Tt4a64tEKY7TqsMUuX1WEIABgam2OmxHyjmcw74g8GZBLAu
	847nY/StyxxR2ahPQ9plL56FM08KAekwoCLxoXnhE5WPDmO84vA==
X-Received: by 2002:a05:6102:6b0b:b0:7d0:3ed0:c61c with SMTP id ada2fe7eead31-7d0726a9cd7mr6446000137.16.1793821080773;
        Wed, 04 Nov 2026 11:38:00 -0800 (PST)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-998d91d2a3asm2569956241.8.2026.11.04.11.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 11:38:00 -0800 (PST)
Date: Wed, 4 Nov 2026 14:37:59 -0500
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 10/10] selftests/liveupdate: Add a test for preserving
 tmpfs files
Message-ID: <auuJM8c-bE43NP54@google.com>
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261103010216.3447716-11-dmatlack@google.com>
 <2vxz1p90jzx4.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz1p90jzx4.fsf@kernel.org>
X-Stat-Signature: 83ztox1uphtcxif9rtpho5jouhir87sg
X-Rspamd-Queue-Id: CD9BA180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793821081-699489
X-HE-Meta: U2FsdGVkX19Khys3mVClnPGjlJRBv437nPhXOoGs30+Dy7Ni1PtCOTUOZ/GrNODR/6XrOqG/EIZ6UKrFAEiMUkDor33W/l/pGG74qWB6Evvn8EzOMK5+SYhe0x4bPwgAKCS5jkSAZAvQW+fBl4kM80znYrQDgd65STHsMvlMXqZ+6xIsA8h5iG+RhQNXjipZCE1iSZw6A859VjQb9fLR6CMj94qi5k+M3Z3n0gq/rMDOf46VxOptcgRzKDfmTLqyiTTPQY6XgzSf1CAbXDCEV/w+Kxcb8o8fS1HV9xR8bShluWI9WYED5EpoyBP459I7R9yKtQGzvT6hALykkEF863TOTjB9CeXE4Nrz0r8ZRxthO+nipXzUrAjXDoFiyj8xYpbVZQ4VEbGSMNrtGikARhCT0wD6GrxO4MdU9qtbI5jOHzKs2XCnHsx9YTVYrHmSmbJSs9H6C+BnuNXMGwGhD6sGvPtkrcPfTo22Cax/87UnvYtwkiaPy4Ma7Lizl508Q6TdUcr/HyKD+IOLV0qYtE8smPRYL+1wvbbCMqqGcMTzwn5j7nEr8TJFp/RTVmk2UH1nX8OivDZBphsTXansMhd+auZh/NMSuH1A83cwfEYVjME6t9DYln8PyPWGML9PDG+ou0lTKjUxYoqNU2r1JFBYEJ8xFDdgILJRgKKSHPQSuTCiNRBjK6GH3o0advWfT4W9ZalrN7/4NBVs/DW22AZ8pgBbEHEXMuaNrIWjQzFrFD4Qks1trLhnCYeZ5BZQKLnJmsnfaPe4c1z8Ko16hay8P/1jTtQqMhxBVtsREzEsZkxJbNCUx+159CSOeLemekcIER8mMMxVprpyJCwVf8rYMJRq+VQJzCHcGcAqbCgDdu8rhBVgmRogWwgQMxYyBjWlIXkUABZv/zqe/koOGtFgrLOuJs+UHZeIp8Fa9Hh6cprTOO+e00p5XZMcNxuryrwMcoEHy1ZEwGAAnrq
 UO3B+Kjq
 7rrmOA65A4pv20JwxuNBQU2B8SAZJymQe+ZQedkTLS7Tx5JhxmLIIsLYxX5lB2taZI76tozCVMZjaVc7K77GHCE/gHlOkePJCpvQKY32Pwfr1g9P9jcqa6NIBH8HhAtAZmeTPdkOpbuC0NBj8cEcAV8PcPv68YY6/I7lf3yY/KWdNHFqWPqI6DQT+7inwDwwSeDY9vgA7AYazIqyxpP44c8QeSElZT6HjkFEmgXbIbk8PspI18oPtdVx/Y+b/SgHOOaIHEWmfiWlGs43FouosNbt8qT92Wdd4pEBgudtmw4BGQqTJtOsyIIaDKcLfXHMsU6zcdhCVadNELeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11-04 17:59, Pratyush Yadav wrote:
> On Tue, Nov 03 2026, David Matlack wrote:
> 
> > Add luo_tmpfs, a kexec test for preserving tmpfs files and memfds, and
> > for retrieving tmpfs files onto a tmpfs mount with struct
> > liveupdate_shmem_retrieve_arg.
> >
> > Stage 1 preserves the source files of each test case. Stage 2 runs
> > each test case in its own directory, with its own tmpfs mounts, so that
> > block usage can be checked exactly with statfs() and st_blocks. The test
> > cases cover:
> >
> >  - The restored file: contents, size, position, seals and holes, for
> >    linked and unlinked source files.
> >
> >  - Creating the file: it is created like with open(O_TMPFILE), with the
> >    requested mode minus the umask, owned by the caller, and not linked
> >    until userspace links it, unless it asked for O_EXCL. Also O_RDONLY
> >    and O_WRONLY files, other open() flags such as O_APPEND, O_NONBLOCK
> >    and O_CLOEXEC, read-only mounts, and directories that the caller
> >    can't write to.
> >
> >  - Preserving files that can't be written to: a binary while it is
> >    executed, through a read-only fd, files on read-only mounts and
> >    superblocks, and immutable files, including sparse ones, whose holes
> >    are filled. Preserving someone else's file that the caller can't
> >    write to fails, and so does preserving a file through a write-only
> >    fd or an append-only file.
> >
> >  - Executing restored binaries: a restored binary can be executed
> >    before the session is finished if it was retrieved with O_RDONLY, but
> >    not if it was retrieved for writing, since LUO keeps the file open
> >    until then. These test cases execute copies of the test binary.
> >
> >  - Block accounting: the file fits a mount of exactly its size, and a
> >    large folio that extends past the end of the file is charged in full.
> >    Running out of space, or hitting the memcg limit, fails permanently,
> >    and leaves nothing charged to the mount or the memcg. The session can
> >    still be finished.
> >
> >  - memfds: they are only retrieved as memfds, with their seals, and
> >    files from tmpfs mounts only onto a tmpfs mount.
> >
> >  - Interactions with LUO: invalid arguments, which can be retried,
> >    retrieving a token twice, and outgoing sessions.
> >
> > Also check that the size of a preserved file is frozen, and that the
> > test doesn't trigger kernel warnings.
> >
> > Enable CONFIG_TRANSPARENT_HUGEPAGE for the large folio test cases,
> > CONFIG_MEMCG for the memcg test case and CONFIG_TMPFS_XATTR for
> > FS_IOC_SETFLAGS. Those test cases are skipped without them.
> >
> > tmpfs quotas are not tested, since the test runs as root, which is not
> > subject to quota limits.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  tools/testing/selftests/liveupdate/Makefile   |    1 +
> >  tools/testing/selftests/liveupdate/config     |    4 +
> >  .../testing/selftests/liveupdate/luo_tmpfs.c  | 2055 +++++++++++++++++
> 
> Umm, no way I am reading all this...
> 
> LLMs are great at generating tests, and I'm not saying there is no value
> in this. It is just that this massive code dump is unreviewable by
> humans. It is also unfair to the human reviewer because it took many
> orders of magnitude less effort to _write_ them with an LLM.
> 
> What do you all reckon we should do about this? Trust the LLM to get the
> testing right? Do we give up human maintenance of tests entirely? Do we
> do fault injection to test the tests themselves?
> 
> Or do we make the tests smaller and more human reviewable?

We need good test coverage, but I believe we can break this patch down 
into smaller changes where tested features are incrementally added.

> 
> >  .../selftests/liveupdate/run-vmtests.sh       |    1 +
> >  4 files changed, 2061 insertions(+)
> >  create mode 100644 tools/testing/selftests/liveupdate/luo_tmpfs.c
> >
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Pasha

