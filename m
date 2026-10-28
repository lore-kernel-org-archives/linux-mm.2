Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D3B606A337
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D9916B05B6; Wed, 28 Oct 2026 16:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88AC36B05B7; Wed, 28 Oct 2026 16:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751FF6B05B8; Wed, 28 Oct 2026 16:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 446306B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:37:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E6691601DE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:37:07 +0000 (UTC)
X-FDA: 85373194494.08.978E537
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7724840004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:37:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="D+2SeH/f";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793219825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZv2+1DVrAHl2B12BcEhNHlv73IMd9//+qYR6Uxe1CQ=;
	b=QfHQsau4TctoSQ0T3dvUrIKfrXQYt5cBualqPDYPF56yk1PZ+B1JUyyVDm2IZ9ngw5kpGf
	CsZh2ncL6+vmDudJ8yKnu4RR18cFzdysni660t/ycAj9MXlWs/2ZjE+fMpIm1b+W8b2J/r
	H54ghYHt5fr6ERcP4k+ohq4MY35citc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="D+2SeH/f";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793219825;
	b=Igfgx1Vlataey2tHVkJ/FYhD0qcl+GV4//i7P+dn93cb3dK6MKMly7hqfgYkgSsKAA+C6J
	ThPCV+WWJi5VYtSKi4fMPWUiegPHFfUXWWx/CaFHObfBIvTzhtZfk6x6QYcI1dax2YVMz0
	85a1nDRZ4odjmI7CVQQjJueYY6AArU4=
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-98301b325c4so460521241.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793219824; x=1793824624; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yZv2+1DVrAHl2B12BcEhNHlv73IMd9//+qYR6Uxe1CQ=;
        b=D+2SeH/fiqc9SvrCmYR5Ll1hlZPvTZoukZ5Ma2LYZnGFu/SCXNpR99kiAaiO3kPv2x
         A89ozruvlSzqyrQsRLPdd9u0StBro/CL8AzCTAHnI0B5nF/IACMJncSw2iAs7/GkXLo9
         OPGDiYeVqamDsYjaF2PK2qr19hC7oD6HPJUVDYG/NssFumkEjo+Fo7tSbC5BQamVHvv6
         yco1bO7LrwYq58oCxgixBrCdIDDOEnMgoVglrq3eJ49wQ84ISrOVwVyILUc6fgqZS+8q
         wpywJYizfipmecG3mnVutg4Wvx+F6Yepch0rqGhtlsj7myYyoLT16YHhxHM/vVkp+lD/
         s5/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793219824; x=1793824624;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yZv2+1DVrAHl2B12BcEhNHlv73IMd9//+qYR6Uxe1CQ=;
        b=FkNg4V5zRsOV4EWxhmuoJHZa6Yff45iXFwF98rmlBUpBOeOH152CL8tdYxIZtqz1kU
         F6oKzTqfy4J3+vqomyZv/vbbp4g67RPhmhEpyvDXvq+Pz4qRnkLdP41v9i5y7yU42d3b
         L2xalrbHtziEV2OrRq7cV9GDyUCLWCXsoSzZMbCG4lzZjFkriRaM5oGJjA2aR1u4tXTw
         NVfGNjl71cEAsLtLhnui6ie6zbqyA8tlMfLVt2rwl0WYKszxzWar0s3YNCdQLXIYrdBi
         /gsEa9RaySgKdHhI7UXzyrS73UtJudLY0fLUkqckntwlKIs+F7upv09EIc/XZa5QHpXW
         pltA==
X-Forwarded-Encrypted: i=1; AKwUvBwsY4UoY84hDP/MxIiYhc0GVYOATHBZWwADk8wNNe1DXHh1a6oIVazPj3jYe6lWFB+sQ+L8Dnzeqg==@kvack.org
X-Gm-Message-State: AFq9FYKbBJyEFZ4O2vHWlFsUxuIJmtmyaHpDP3cp6hrsYBnBKwAW2m62
	C6ApQ9iPdqI+Kl2p0lFBIu+FHvzXNDVd4+2n0xDethGgdomgnfBw2Y5QlGrU9shHImI=
X-Gm-Gg: AYBFou37IL5F80Hh/UwQX5t0EPjpwY+QpLMPIwmmkitgqelACqU3ypz8llzPC7dFS+a
	pD9yC1xGfx1GB5Fftr3mD7x9MlxwLw8Z1dF/ZsODo4MkIEaijwCngYXL2pKIIgbRTCzv0La0hHe
	Fe91bNu2WgAMF8Na7FBhCZH75ScFePqmotevKJ9RzkIXquwIJEVVyI2BIU+fcIK3Jhw7aEVQFMZ
	CwDPFHfVCTx8skHRg4IA3RbA8MRrLmgHJXgE1vprj5rD0c7YfYvcZ+Y9W+J/btQX24czHGLoSzr
	l0UBKhrF5rYBABv/bjCeQ56TeKem7EJmU7z1cbyWc+x9NdSAKkLD3qv3kPeXANMnYWSJM7KYUoR
	crBYOsV6eordptL524MFbCyXos29uJFuaKw/0SwKvRz4wyrWNc5EOtlwdnAft6W9YgADNzux+G4
	u+0pUIn5iOWZVz+i2zkVZ0Tz57SnGI/s50aEGLh/99/5mmIef2QKP2DS7aIiY+TCr1oXHD4D+Kd
	0NyA0uGui26p9ezIR2Eoeq44a8uT91dUikKGylyAbJiM+X+ZPHmMFrlM2QP6wJmkaP7mJJ1wgxB
	erjTI0pmmnmEkgzdhR1G0ShX5Poxst2QVqgkzE0lLnl4hXfD+vg/uv70hkkvDYNSSJS6ibY+Iqf
	bxcl3W2p3vxISDW948ca2qftWutFiB3YUohuBihmnovYq
X-Received: by 2002:a05:6102:1481:b0:7a2:7ccd:280d with SMTP id ada2fe7eead31-7d03a509f02mr1837249137.8.1793219824160;
        Wed, 28 Oct 2026 13:37:04 -0700 (PDT)
Received: from soleen.c.googlers.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec4f931911sm3001789e0c.10.2026.10.28.13.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 13:37:03 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 04/10] mm: Rename memfd_luo to shmem_luo
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-mm@kvack.org, Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
 Jonathan Corbet <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
In-Reply-To: <20261022225035.377445-5-dmatlack@google.com>
References: <20261022225035.377445-1-dmatlack@google.com>
 <20261022225035.377445-5-dmatlack@google.com>
Date: Wed, 28 Oct 2026 16:36:59 -0400
Message-Id: <179321981902.1894369.16748649132377328995.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=21956;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=TCoG4daDjEh6ttB7dNzeg+ZdrU8Af9V3YBrxlKC6GwI=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq4lztNNuKvavNdOg4Z9fVNqC/N3GWgzV+ZpQlt
 780fLoifUeJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCauJc7QAKCRC7dyhM23N6
 3r7qD/0RfrIfuwuqjMDdlSQnoUXkREOLopsa4Tn0/KvYEA0irH/bCith2PXcitPWNFDZxmr24i4
 xqdAqwyCibhP+p8FHyYz5ZiQlPa4BU076zf8My04nhoA82GC0OYsIejHwIlOZPyiHBp8NVhWq9M
 VPo/j5w6FXffxaGWZ2eXDvRRoDPOj0h59+v38jbJH5+jOA27z7wAXEflPAZy1DWpomE1iAx3vGz
 bE04Y18XmHHfKIvM/wJmyCpBLNPuw8wjx5/PjeJIOkhHIrKCyHmne/Kf0f9GQ6MXhokQhhuORSg
 UDALYEWoAbmKEwylxqPgRFLotJnFlNF0an1585b5MZuungbc8G2yQTTLDWmIJIOjg6An2ltGpwH
 Spfve0pkuto4DCeDYX5zZl53gpi6BaYQq+xzoCAT0RfcpnYKXbd3+1jF2orVYckjYviHpkKjIbw
 qzSDoOZqvH/0zxgr59MUTlyq0qCq1ka0tofNP37Q7c50NpfNjKqv8NlEY0wAkkVlj2AWvWmLtJ2
 L7m3yQALBdETIa6SAPiRFeVkA637KCiMWxuN/iJs8fc9A8+zDnr9zwj6ihpVq6XEP2/Qz4AFCFS
 kNebElqgNf1Ds0lctVnh0lbF3iAj6oDaoQFdNJ7dS+hTM5FgYMaZecivVOKIbgwbBk4F+xanA/p
 2/EzT0mYkdCpDZw==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Queue-Id: 7724840004
X-Stat-Signature: o45rz78my7wy9ronoss6cop4oz1pbb46
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793219825-108554
X-HE-Meta: U2FsdGVkX19jpSf7G33eQ+UdEMobTGj2xUfdkdATnVnmyNhEpMcpQLX9VNuJy8v6ANTO8O83NEvCIAVZ0LyGF2RpHTbXMBrDSPssWaYMK3sFVFZHbR1g9d5cMpyFa+/gb9DFsbutoffLT3mdiEFkLUlr0qgjT2UPKsccO0Ir0wLqEQ6Jc+4mtfLUKJJneTU4S+y/W/mHDpZx1xCTFi5vZT54O+oIM5e5rVKaUHrhs7wVMLy9wjGizgOm2ANKvWU2daks47yhvFpsxA0c3tqSpWGtohUQ+WuNFDIQw5MzCEhpL0ZQRv3AOhomuTuhvEZ7H0o7HurumXgdv/volXy1PoHAmm5JsI9fFfXe+QG4HQfz8ybukqVFmbW8qxtZC0wwXvKyi/aTV2/GE/xXQCcUmeu5+QjeDBzdQblYBrnA0VzzbBhtYYfIJwQeEVdbRwmTlZ1WjYpN7UsOc4W26o3soIZ7yCI/qOGUXJllmuYCnwgldGplT1dwgHlWWhh4/tp8oAGt8LMe/N3jcrkWoCNdcc56g4GlhVH65OJPEIaiHUDobRqFCGQmgWlqhR0CJFf/Yw9zA4AmJapiJ1WgbFJRNrn/UO6OfcbtG2r4B3do5NAZ9hLlGtM5YvtMpQpxhrpO7B9rMdvDR55B2yUguBG+bxERSvuDJnRrEaHbVCiLVFUJo6cczmHCuDjlgHuZVM2ctvycI+8xQfvjKUVaztM/DLMTSaT8U+HpFhWmH23dTJnDVo03ukHBqUSMJLNMNb7WH4vJ0IQdWTY0DSeMuurELQ3PtXuMwY60Z2I5QIfSPAGNz8t61dwEeBDbSiAfcpOcXu2LFPI0+wc4sazaVdQjG+79Ne3Zp1u1MsA/Ndv4WOLgx1qnHY6NDcT/oQYQpaFQ1cI2bu6LHJrfI1h7e0QnP0uQEUwwZm3UYiVfDl/kfKYu5okTt73/wphDL3TfDxa2hwYvrmO1Du/cT1xA96O
 Z6TMNwmn
 ZlYzChYuTnwSd8vIH5mM0GuAS9Lkc/WSXpkBT/JXCpblQm+CDT7x0qMPXNPn7pc+3vOPJv1QJzb0LwA+pBAMvRhz8Ut1pwBK4fKyGUZroI1DkuKihUNWian02aaCCzw90KTp8bnu/85CliKaO9Pr3wjPFGrOHEV8dtttnxcGNLPVb0ChYTyeh1f2k0ugjI6+coQ/Acj7UK8lGh/Laq1PKeBsWEDZtl9TFvW1ePe6CVVgBPs0cRwLoLpjuGW1KcFKB7TsnomVNuE/g6XGt/EU50l9O7n5wWIHy95lYIrjFfYfs3/x2lv6sj8o7uU5yArLM5UxCd1MoMW2kKEQwc1DPCuBb5IzKSNO9jlbKz36IuWkooZxvau04nX7vii3JL3YTIVDNnHvbcMyOFVO/Otpll3S8iGxv2CKcXjoG9IuqUZpgaaiu91RofOAod1C9waverYrfDmt1FnrFOaOX683Jn17r9NqqMFtcy+IPm9pfWFJPrrAxc00Q3z/ECJ7wpf0wOS+MXuFToH29tcs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Rename the memfd Live Update file handler from memfd_luo to shmem_luo,
> including the source file, its KHO ABI header, its documentation and its
> Kconfig option (CONFIG_LIVEUPDATE_MEMFD to CONFIG_LIVEUPDATE_SHMEM).
> 
> The handler preserves shmem files. Today those are memfds, but following
> commits extend it to other files on tmpfs mounts, for which the memfd
> name is confusing. Preserving memfds created with MFD_HUGETLB, which are
> hugetlbfs files, will need a separate handler, so naming the handler
> after the filesystem that backs the files also avoids having to rename
> it again then.
> 
> Don't change the compatible string of the handler, "memfd-v2". It is
> matched against the preserved state from the previous kernel, so
> changing it would break live updates from kernels that use the old
> name. The serialized format doesn't change either.
> 
> Also clarify in the documentation that memfd means a memfd created
> without MFD_HUGETLB, and name the ABI documentation after the handler.
> 
> No functional change intended.
> 
> Assisted-by: LLM

Nit: This can be removed (in all patches in this series).

> Signed-off-by: David Matlack <dmatlack@google.com>
> Link: https://patch.msgid.link/20261022225035.377445-5-dmatlack@google.com
>
> diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
> index 2bce2644eba2..669722002440 100644
> --- a/Documentation/core-api/liveupdate.rst
> +++ b/Documentation/core-api/liveupdate.rst
> @@ -37,7 +37,7 @@ The following types of file descriptors can be preserved
>  .. toctree::
>     :maxdepth: 1
>  
> -   ../mm/memfd_preservation
> +   ../mm/shmem_preservation
>  
>  Public API
>  ==========
> diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
> index 13a79f5d092c..b8ab2f89002d 100644
> --- a/Documentation/mm/index.rst
> +++ b/Documentation/mm/index.rst
> @@ -61,7 +61,7 @@ documentation, or deleted if it has served its purpose.
>     hugetlbfs_reserv
>     ksm
>     memory-model
> -   memfd_preservation
> +   shmem_preservation
>     mmu_notifier
>     multigen_lru
>     numa
> diff --git a/Documentation/mm/memfd_preservation.rst b/Documentation/mm/shmem_preservation.rst
> similarity index 66%
> rename from Documentation/mm/memfd_preservation.rst
> rename to Documentation/mm/shmem_preservation.rst
> index c908a12dffa7..e79bf8afaa9e 100644
> --- a/Documentation/mm/memfd_preservation.rst
> +++ b/Documentation/mm/shmem_preservation.rst
> @@ -4,16 +4,16 @@
>  Memfd Preservation via LUO
>  ==========================
>  
> -.. kernel-doc:: mm/memfd_luo.c
> +.. kernel-doc:: mm/shmem_luo.c
>     :doc: Memfd Preservation via LUO
>  
>  Memfd Preservation ABI
>  ======================
>  
> -.. kernel-doc:: include/linux/kho/abi/memfd.h
> -   :doc: memfd Live Update ABI
> +.. kernel-doc:: include/linux/kho/abi/shmem.h
> +   :doc: shmem Live Update ABI
>  
> -.. kernel-doc:: include/linux/kho/abi/memfd.h
> +.. kernel-doc:: include/linux/kho/abi/shmem.h
>     :internal:
>  
>  See Also
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5d1b58271989..742cdce14cf9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15184,14 +15184,14 @@ L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
>  F:	Documentation/core-api/liveupdate.rst
> -F:	Documentation/mm/memfd_preservation.rst
> +F:	Documentation/mm/shmem_preservation.rst
>  F:	Documentation/userspace-api/liveupdate.rst
>  F:	include/linux/kho/abi/
>  F:	include/linux/liveupdate.h
>  F:	include/uapi/linux/liveupdate.h
>  F:	kernel/liveupdate/
>  F:	lib/tests/liveupdate.c
> -F:	mm/memfd_luo.c
> +F:	mm/shmem_luo.c
>  F:	tools/testing/selftests/liveupdate/
>  
>  LLC (802.2)
> diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/shmem.h
> similarity index 65%
> rename from include/linux/kho/abi/memfd.h
> rename to include/linux/kho/abi/shmem.h
> index 08b10fea2afc..b61687e358a2 100644
> --- a/include/linux/kho/abi/memfd.h
> +++ b/include/linux/kho/abi/shmem.h
> @@ -8,49 +8,50 @@
>   * Pratyush Yadav <ptyadav@amazon.de>
>   */
>  
> -#ifndef _LINUX_KHO_ABI_MEMFD_H
> -#define _LINUX_KHO_ABI_MEMFD_H
> +#ifndef _LINUX_KHO_ABI_SHMEM_H
> +#define _LINUX_KHO_ABI_SHMEM_H
>  
>  #include <linux/types.h>
>  #include <linux/kho/abi/kexec_handover.h>
>  
>  /**
> - * DOC: memfd Live Update ABI
> + * DOC: shmem Live Update ABI
>   *
> - * memfd uses the ABI defined below for preserving its state across a kexec
> - * reboot using the LUO.
> + * The shmem file handler, which preserves memfds created without
> + * ``MFD_HUGETLB``, uses the ABI defined below for preserving their state across
> + * a kexec reboot using the LUO.
>   *
> - * The state is serialized into a packed structure `struct memfd_luo_ser`
> + * The state is serialized into a packed structure `struct shmem_luo_ser`
>   * which is handed over to the next kernel via the KHO mechanism.
>   *
>   * This interface is a contract. Any modification to the structure layout
>   * constitutes a breaking change. Such changes require incrementing the
> - * version number in the MEMFD_LUO_FH_COMPATIBLE string.
> + * version number in the SHMEM_LUO_FH_COMPATIBLE string.
>   */
>  
>  /**
> - * MEMFD_LUO_FOLIO_DIRTY - The folio is dirty.
> + * SHMEM_LUO_FOLIO_DIRTY - The folio is dirty.
>   *
>   * This flag indicates the folio contains data from user. A non-dirty folio is
>   * one that was allocated (say using fallocate(2)) but not written to.
>   */
> -#define MEMFD_LUO_FOLIO_DIRTY		BIT(0)
> +#define SHMEM_LUO_FOLIO_DIRTY		BIT(0)
>  
>  /**
> - * MEMFD_LUO_FOLIO_UPTODATE - The folio is up-to-date.
> + * SHMEM_LUO_FOLIO_UPTODATE - The folio is up-to-date.
>   *
>   * An up-to-date folio has been zeroed out. shmem zeroes out folios on first
>   * use. This flag tracks which folios need zeroing.
>   */
> -#define MEMFD_LUO_FOLIO_UPTODATE	BIT(1)
> +#define SHMEM_LUO_FOLIO_UPTODATE	BIT(1)
>  
>  /**
> - * struct memfd_luo_folio_ser - Serialized state of a single folio.
> + * struct shmem_luo_folio_ser - Serialized state of a single folio.
>   * @pfn:       The page frame number of the folio.
>   * @flags:     Flags to describe the state of the folio.
>   * @index:     The page offset (pgoff_t) of the folio within the original file.
>   */
> -struct memfd_luo_folio_ser {
> +struct shmem_luo_folio_ser {
>  	u64 pfn:52;
>  	u64 flags:12;
>  	u64 index;
> @@ -60,7 +61,7 @@ struct memfd_luo_folio_ser {
>   * The set of seals this version supports preserving. If support for any new
>   * seals is needed, add it here and bump version.
>   */
> -#define MEMFD_LUO_ALL_SEALS (F_SEAL_SEAL | \
> +#define SHMEM_LUO_ALL_SEALS (F_SEAL_SEAL | \
>  			     F_SEAL_SHRINK | \
>  			     F_SEAL_GROW | \
>  			     F_SEAL_WRITE | \
> @@ -68,7 +69,7 @@ struct memfd_luo_folio_ser {
>  			     F_SEAL_EXEC)
>  
>  /**
> - * struct memfd_luo_ser - Main serialization structure for a memfd.
> + * struct shmem_luo_ser - Main serialization structure for a memfd.
>   * @pos:       The file's current position (f_pos).
>   * @size:      The total size of the file in bytes (i_size).
>   * @seals:     The seals present on the memfd. The seals are uABI so it is safe
> @@ -76,9 +77,9 @@ struct memfd_luo_folio_ser {
>   * @flags:     Flags for the file. Unused flag bits must be set to 0.
>   * @nr_folios: Number of folios in the folios array.
>   * @folios:    KHO vmalloc descriptor pointing to the array of
> - *             struct memfd_luo_folio_ser.
> + *             struct shmem_luo_folio_ser.
>   */
> -struct memfd_luo_ser {
> +struct shmem_luo_ser {
>  	u64 pos;
>  	u64 size;
>  	u32 seals;
> @@ -87,7 +88,7 @@ struct memfd_luo_ser {
>  	struct kho_vmalloc folios;
>  } __packed;
>  
> -/* The compatibility string for memfd file handler */
> -#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
> +/* The compatibility string for the shmem file handler */
> +#define SHMEM_LUO_FH_COMPATIBLE	"memfd-v2"
>  
> -#endif /* _LINUX_KHO_ABI_MEMFD_H */
> +#endif /* _LINUX_KHO_ABI_SHMEM_H */
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index f50daee8eff0..9a1c49e2e0c4 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -69,7 +69,7 @@ config LIVEUPDATE
>  
>  	  If unsure, say N.
>  
> -config LIVEUPDATE_MEMFD
> +config LIVEUPDATE_SHMEM
>  	bool "Live update support for memfd"
>  	depends on LIVEUPDATE
>  	depends on MEMFD_CREATE
> diff --git a/mm/Makefile b/mm/Makefile
> index e7245cb88c66..cbdcc2c6b296 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -100,7 +100,7 @@ obj-$(CONFIG_NUMA) += memory-tiers.o
>  obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
>  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
>  obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
> -obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
> +obj-$(CONFIG_LIVEUPDATE_SHMEM) += shmem_luo.o
>  obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
>  obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
>  ifdef CONFIG_BPF_SYSCALL
> diff --git a/mm/memfd_luo.c b/mm/shmem_luo.c
> similarity index 81%
> rename from mm/memfd_luo.c
> rename to mm/shmem_luo.c
> index 6b68220275eb..b8d86055912d 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/shmem_luo.c
> @@ -18,6 +18,11 @@
>   * Update Orchestrator (LUO) file preservation. This allows userspace to
>   * transfer its memory contents to the next kernel after a kexec.
>   *
> + * Here, a memfd is a memfd created without ``MFD_HUGETLB``, which is a shmem
> + * file on the kernel's internal shmem mount. Memfds created with
> + * ``MFD_HUGETLB`` are hugetlbfs files, which this file handler doesn't
> + * preserve. Preserving them fails with ``-ENOENT``.
> + *
>   * The preservation is not intended to be transparent. Only select properties of
>   * the file are preserved. All others are reset to default. The preserved
>   * properties are described below.
> @@ -26,10 +31,6 @@
>   *    The LUO API is not stabilized yet, so the preserved properties of a memfd
>   *    are also not stable and are subject to backwards incompatible changes.
>   *
> - * .. note::
> - *    Currently a memfd backed by Hugetlb is not supported. Memfds created
> - *    with ``MFD_HUGETLB`` will be rejected.
> - *
>   * Preserved Properties
>   * ====================
>   *
> @@ -52,7 +53,7 @@
>   *
>   * Seals
>   *   File seals set on the memfd are preserved and re-applied on restore.
> - *   Only seals known to this LUO version (see ``MEMFD_LUO_ALL_SEALS``) may
> + *   Only seals known to this LUO version (see ``SHMEM_LUO_ALL_SEALS``) may
>   *   be present; preservation fails with ``-EOPNOTSUPP`` otherwise.
>   *
>   * Non-Preserved Properties
> @@ -75,7 +76,7 @@
>  #include <linux/file.h>
>  #include <linux/io.h>
>  #include <linux/kexec_handover.h>
> -#include <linux/kho/abi/memfd.h>
> +#include <linux/kho/abi/shmem.h>
>  #include <linux/liveupdate.h>
>  #include <linux/shmem_fs.h>
>  #include <linux/vmalloc.h>
> @@ -84,13 +85,13 @@
>  
>  #include "internal.h"
>  
> -static int memfd_luo_preserve_folios(struct file *file,
> +static int shmem_luo_preserve_folios(struct file *file,
>  				     struct kho_vmalloc *kho_vmalloc,
> -				     struct memfd_luo_folio_ser **out_folios_ser,
> +				     struct shmem_luo_folio_ser **out_folios_ser,
>  				     u64 *nr_foliosp)
>  {
>  	struct inode *inode = file_inode(file);
> -	struct memfd_luo_folio_ser *folios_ser;
> +	struct shmem_luo_folio_ser *folios_ser;
>  	unsigned int max_folios;
>  	long i, size, nr_pinned;
>  	struct folio **folios;
> @@ -145,7 +146,7 @@ static int memfd_luo_preserve_folios(struct file *file,
>  	}
>  
>  	for (i = 0; i < nr_folios; i++) {
> -		struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
> +		struct shmem_luo_folio_ser *pfolio = &folios_ser[i];
>  		struct folio *folio = folios[i];
>  
>  		err = kho_preserve_folio(folio);
> @@ -196,7 +197,7 @@ static int memfd_luo_preserve_folios(struct file *file,
>  		folio_unlock(folio);
>  
>  		pfolio->pfn = folio_pfn(folio);
> -		pfolio->flags = MEMFD_LUO_FOLIO_DIRTY | MEMFD_LUO_FOLIO_UPTODATE;
> +		pfolio->flags = SHMEM_LUO_FOLIO_DIRTY | SHMEM_LUO_FOLIO_UPTODATE;
>  		pfolio->index = folio->index;
>  	}
>  
> @@ -227,8 +228,8 @@ static int memfd_luo_preserve_folios(struct file *file,
>  	return err;
>  }
>  
> -static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
> -					struct memfd_luo_folio_ser *folios_ser,
> +static void shmem_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
> +					struct shmem_luo_folio_ser *folios_ser,
>  					u64 nr_folios)
>  {
>  	long i;
> @@ -239,7 +240,7 @@ static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
>  	kho_unpreserve_vmalloc(kho_vmalloc);
>  
>  	for (i = 0; i < nr_folios; i++) {
> -		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
> +		const struct shmem_luo_folio_ser *pfolio = &folios_ser[i];
>  		struct folio *folio;
>  
>  		if (!pfolio->pfn)
> @@ -254,11 +255,11 @@ static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
>  	vfree(folios_ser);
>  }
>  
> -static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
> +static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
>  {
>  	struct inode *inode = file_inode(args->file);
> -	struct memfd_luo_folio_ser *folios_ser;
> -	struct memfd_luo_ser *ser;
> +	struct shmem_luo_folio_ser *folios_ser;
> +	struct shmem_luo_ser *ser;
>  	u64 nr_folios, inode_size;
>  	int err = 0, seals;
>  
> @@ -279,7 +280,7 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
>  	}
>  
>  	/* Make sure the file only has the seals supported by this version. */
> -	if (seals & ~MEMFD_LUO_ALL_SEALS) {
> +	if (seals & ~SHMEM_LUO_ALL_SEALS) {
>  		err = -EOPNOTSUPP;
>  		goto err_free_ser;
>  	}
> @@ -299,7 +300,7 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
>  	ser->size = inode_size;
>  	ser->seals = seals;
>  
> -	err = memfd_luo_preserve_folios(args->file, &ser->folios,
> +	err = shmem_luo_preserve_folios(args->file, &ser->folios,
>  					&folios_ser, &nr_folios);
>  	if (err)
>  		goto err_free_ser;
> @@ -320,9 +321,9 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
>  	return err;
>  }
>  
> -static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
> +static int shmem_luo_freeze(struct liveupdate_file_op_args *args)
>  {
> -	struct memfd_luo_ser *ser;
> +	struct shmem_luo_ser *ser;
>  
>  	if (WARN_ON_ONCE(!args->serialized_data))
>  		return -EINVAL;
> @@ -338,10 +339,10 @@ static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
>  	return 0;
>  }
>  
> -static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
> +static void shmem_luo_unpreserve(struct liveupdate_file_op_args *args)
>  {
>  	struct inode *inode = file_inode(args->file);
> -	struct memfd_luo_ser *ser;
> +	struct shmem_luo_ser *ser;
>  
>  	if (WARN_ON_ONCE(!args->serialized_data))
>  		return;
> @@ -351,20 +352,20 @@ static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
>  
>  	ser = phys_to_virt(args->serialized_data);
>  
> -	memfd_luo_unpreserve_folios(&ser->folios, args->private_data,
> +	shmem_luo_unpreserve_folios(&ser->folios, args->private_data,
>  				    ser->nr_folios);
>  
>  	kho_unpreserve_free(ser);
>  	inode_unlock(inode);
>  }
>  
> -static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *folios_ser,
> +static void shmem_luo_discard_folios(const struct shmem_luo_folio_ser *folios_ser,
>  				     u64 nr_folios)
>  {
>  	u64 i;
>  
>  	for (i = 0; i < nr_folios; i++) {
> -		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
> +		const struct shmem_luo_folio_ser *pfolio = &folios_ser[i];
>  		struct folio *folio;
>  		phys_addr_t phys;
>  
> @@ -383,10 +384,10 @@ static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *folios_se
>  	}
>  }
>  
> -static void memfd_luo_finish(struct liveupdate_file_op_args *args)
> +static void shmem_luo_finish(struct liveupdate_file_op_args *args)
>  {
> -	struct memfd_luo_folio_ser *folios_ser;
> -	struct memfd_luo_ser *ser;
> +	struct shmem_luo_folio_ser *folios_ser;
> +	struct shmem_luo_ser *ser;
>  
>  	/*
>  	 * If retrieve was successful, nothing to do. If it failed, retrieve()
> @@ -405,7 +406,7 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
>  		if (!folios_ser)
>  			goto out;
>  
> -		memfd_luo_discard_folios(folios_ser, ser->nr_folios);
> +		shmem_luo_discard_folios(folios_ser, ser->nr_folios);
>  		vfree(folios_ser);
>  	}
>  
> @@ -413,8 +414,8 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
>  	kho_restore_free(ser);
>  }
>  
> -static int memfd_luo_retrieve_folios(struct file *file,
> -				     struct memfd_luo_folio_ser *folios_ser,
> +static int shmem_luo_retrieve_folios(struct file *file,
> +				     struct shmem_luo_folio_ser *folios_ser,
>  				     u64 nr_folios)
>  {
>  	struct inode *inode = file_inode(file);
> @@ -425,7 +426,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
>  	long i;
>  
>  	for (i = 0; i < nr_folios; i++) {
> -		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
> +		const struct shmem_luo_folio_ser *pfolio = &folios_ser[i];
>  		phys_addr_t phys;
>  		u64 index;
>  		int flags;
> @@ -463,9 +464,9 @@ static int memfd_luo_retrieve_folios(struct file *file,
>  			goto unlock_folio;
>  		}
>  
> -		if (flags & MEMFD_LUO_FOLIO_UPTODATE)
> +		if (flags & SHMEM_LUO_FOLIO_UPTODATE)
>  			folio_mark_uptodate(folio);
> -		if (flags & MEMFD_LUO_FOLIO_DIRTY)
> +		if (flags & SHMEM_LUO_FOLIO_DIRTY)
>  			folio_mark_dirty(folio);
>  
>  		npages = folio_nr_pages(folio);
> @@ -497,7 +498,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
>  	 * freed when the file is freed. Free the ones not added yet here.
>  	 */
>  	for (long j = i + 1; j < nr_folios; j++) {
> -		const struct memfd_luo_folio_ser *pfolio = &folios_ser[j];
> +		const struct shmem_luo_folio_ser *pfolio = &folios_ser[j];
>  		phys_addr_t phys;
>  
>  		if (!pfolio->pfn)
> @@ -514,10 +515,10 @@ static int memfd_luo_retrieve_folios(struct file *file,
>  	return err;
>  }
>  
> -static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
> +static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
>  {
> -	struct memfd_luo_folio_ser *folios_ser;
> -	struct memfd_luo_ser *ser;
> +	struct shmem_luo_folio_ser *folios_ser;
> +	struct shmem_luo_ser *ser;
>  	struct file *file;
>  	int err;
>  
> @@ -526,7 +527,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
>  		return -EINVAL;
>  
>  	/* Make sure the file only has seals supported by this version. */
> -	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
> +	if (ser->seals & ~SHMEM_LUO_ALL_SEALS) {
>  		err = -EOPNOTSUPP;
>  		goto free_ser;
>  	}
> @@ -558,7 +559,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
>  			goto put_file;
>  		}
>  
> -		err = memfd_luo_retrieve_folios(file, folios_ser, ser->nr_folios);
> +		err = shmem_luo_retrieve_folios(file, folios_ser, ser->nr_folios);
>  		vfree(folios_ser);
>  		if (err)
>  			goto put_file;
> @@ -576,7 +577,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
>  	return err;
>  }
>  
> -static bool memfd_luo_can_preserve(struct liveupdate_file_handler *handler,
> +static bool shmem_luo_can_preserve(struct liveupdate_file_handler *handler,
>  				   struct file *file)
>  {
>  	struct inode *inode = file_inode(file);
> @@ -584,30 +585,30 @@ static bool memfd_luo_can_preserve(struct liveupdate_file_handler *handler,
>  	return shmem_file(file) && !inode->i_nlink;
>  }
>  
> -static unsigned long memfd_luo_get_id(struct file *file)
> +static unsigned long shmem_luo_get_id(struct file *file)
>  {
>  	return (unsigned long)file_inode(file);
>  }
>  
> -static const struct liveupdate_file_ops memfd_luo_file_ops = {
> -	.freeze = memfd_luo_freeze,
> -	.finish = memfd_luo_finish,
> -	.retrieve = memfd_luo_retrieve,
> -	.preserve = memfd_luo_preserve,
> -	.unpreserve = memfd_luo_unpreserve,
> -	.can_preserve = memfd_luo_can_preserve,
> -	.get_id = memfd_luo_get_id,
> +static const struct liveupdate_file_ops shmem_luo_file_ops = {
> +	.freeze = shmem_luo_freeze,
> +	.finish = shmem_luo_finish,
> +	.retrieve = shmem_luo_retrieve,
> +	.preserve = shmem_luo_preserve,
> +	.unpreserve = shmem_luo_unpreserve,
> +	.can_preserve = shmem_luo_can_preserve,
> +	.get_id = shmem_luo_get_id,
>  	.owner = THIS_MODULE,
>  };
>  
> -static struct liveupdate_file_handler memfd_luo_handler = {
> -	.ops = &memfd_luo_file_ops,
> -	.compatible = MEMFD_LUO_FH_COMPATIBLE,
> +static struct liveupdate_file_handler shmem_luo_handler = {
> +	.ops = &shmem_luo_file_ops,
> +	.compatible = SHMEM_LUO_FH_COMPATIBLE,
>  };
>  
> -static int __init memfd_luo_init(void)
> +static int __init shmem_luo_init(void)
>  {
> -	int err = liveupdate_register_file_handler(&memfd_luo_handler);
> +	int err = liveupdate_register_file_handler(&shmem_luo_handler);
>  
>  	if (err && err != -EOPNOTSUPP) {
>  		pr_err("Could not register luo filesystem handler: %pe\n",
> @@ -618,4 +619,4 @@ static int __init memfd_luo_init(void)
>  
>  	return 0;
>  }
> -late_initcall(memfd_luo_init);
> +late_initcall(shmem_luo_init);

Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

