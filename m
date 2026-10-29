Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B176B606A324
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ONM0cOgY
Received: by kanga.kvack.org (Postfix)
	id D97236B05B2; Thu, 29 Oct 2026 02:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47AF6B05B3; Thu, 29 Oct 2026 02:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12196B05B4; Thu, 29 Oct 2026 02:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE766B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:45:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90EF6C02E3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:45:23 +0000 (UTC)
X-FDA: 85374727326.19.F3DA2FE
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf14.hostedemail.com (Postfix) with ESMTP id B8920100008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:45:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ONM0cOgY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of trilith.zheng@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=trilith.zheng@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793256321;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PpZwiOLy+qBSQ8PQ3tlsCfW6m/0pXMByVlZ/42AmEx0=;
	b=VvNAT851bf9Zg4cxZVkhpKTvm04b8ssCWGCFHCF5Uj/CWbSaBgu6qdZG7NplEqrp+HPhxo
	303qeRdGwfYRBljh5OMIRLNLsmmPY2wwcvqc6bU/shXVRuhRozem+et9rWTIppNFDm/Rv2
	93hqAH1oViXyrOdHGtEoHhs0svepbNM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ONM0cOgY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of trilith.zheng@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=trilith.zheng@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793256321;
	b=hrFJTQLe5ctSgbYiUMXebTfIguVtJV1dnm/pFX8y6abRnG5aj0xGcEXPJCiTOPN18jlb8M
	aerzHsSOr7PuG3GPh7QjdLZkDMmoF8gfMyjMC2cdmNHpcUfjKvgKatPTruAhHRG9IQdG4M
	kjxYRp6FPOQwu2iwoPre6cpuKbQZuSg=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cdac6d19ddaso849410a12.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793256320; x=1793861120; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PpZwiOLy+qBSQ8PQ3tlsCfW6m/0pXMByVlZ/42AmEx0=;
        b=ONM0cOgYptKoFHw2aLSq0MdPI50ryP1F2gt9NkEUoZ+CLehehDcYu/O2F+QxSKsK17
         OrUqcUQEW0vmCg8hV0T1HY6MLoRBamFQkSOk3+YvLNyx7BCsayRozEoBHD5Lb1uVUWaV
         gmAZ4IUr+IjC2KVQ+moTLlQFDRDBYbMT8nzdieoDlCnb/diLdH/OC7t1ynBZiwsoYl8X
         QmvNxmTNCtPT9v4g5b5ynKf3AOhR9FoC5faqdMXA/KS9ZuYRiEyt/xhL6hI3a/wA8/cN
         EUbwdsF9pZdQ1dvOezzHVOjrqG6EGu93fMtba03V4j0pSO3OctWAWkXq+jrmAYncnrN/
         rL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793256320; x=1793861120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PpZwiOLy+qBSQ8PQ3tlsCfW6m/0pXMByVlZ/42AmEx0=;
        b=FyPRLYFWWhkOKSIYswYG5H5FPCmU7mW3FwFnYx/DuCRowG6Jq2Cgsp2MoiauC0e8Mk
         /+ctz4aMlz2ALKi1oJEvGUZAjt6it8fgb6bcckR9VrqD5f5ig8u2rRvfu8zNkRMXeOSe
         fSI/wnHuIVoL5bPBmkG3FM+KdRm7kL5NepB1wtOtEGC1Kat1XTomyyCrjXk/QSjHHITJ
         TgC3EYo/vd560sZJ/ciIOPhAnJHUqP2+0WCq/dAzQIHuIqxhhisiMuf5uqBYThRDOzx4
         iYQd6jtSS50AqV12ZH59e1sJxLaxiiq2bBz0vK2I4emFQ67KNxk//bqa1IMj5MDVPdO1
         xavQ==
X-Forwarded-Encrypted: i=1; AKwUvBwE3C+bHX5C9wSuQ1zJmBtFPu2UTDq3wbL5cFulymkyPq/RM2f/5hwWR7G1Vb0s1xTmq3Qi37IdVg==@kvack.org
X-Gm-Message-State: AFq9FYIuGxioTrupObB6qg6ARKq4lJxnoalgIyZ1F9kZSbYSPuVjrRBQ
	6ROABq5kC1Lx1hPkOwqT7FtWFXPBTziuRjYuFp0LDbymKr0Pd8eBxWAr
X-Gm-Gg: AYBFou0TQGbpce4BtY2mZdFGswbnd70ygG9UJ4jHorqf3lm3xWFO+Od2QCjekZWQ1Wq
	s0sxZKX68UhLkfhTHrliO4GOB1TeSwgFgvXvSRXb7LPGG++UaG9/PhecK3wnJ6q4xw+lIQuIgD0
	ELVAsaQa7BQooku7xTbr2M6uLuv0GlsTNM4HUiF40hPkEkiaf9XtFDJYJNcTBWYfNEV/O3gepCa
	FXzocBkE1ldsUJztzVFj/CKXH3FGJoz4dGAON8tR7yj0kqNLf91Ir0rwwzQVnbUIOLt/i5DqfBb
	KwALGpJJE6BxZgKYI3NmUSks9ynfxrbXi4kWCIv956C4j+l/eZujrDSH1Dc84FS+EKsbUjVqI5Q
	6vjRrJ3JF08PQgrOyh0YvycvYDMKZ65C2gkZe5DkrkzR217uV3heG+HL8Rv3S6hQaD9t0OU7SOa
	S+qfDEu7XjsTxpza3y7tQ98vV7zYQs61+rZIIwXc8FcZavYoVJsoM99RIkyRJgQOFdcaj1vr05m
	D2Ic/axzcCP9V1eqR7LpyzgEOPkfgHwstcunsEzmzz+pdVAI8OsDszin2voYRADYFbUSR4jRpXA
	1WcyCoeyJQ/9yvEbAHXNCmfTNcF8tnM4Ho6HVlz74phC+zQIG7rdTQ==
X-Received: by 2002:a17:90b:2543:b0:3a0:e1f7:9b04 with SMTP id 98e67ed59e1d1-3ae58172e4emr3338233a91.12.1793256320522;
        Wed, 28 Oct 2026 23:45:20 -0700 (PDT)
Received: from localhost.localdomain ([101.44.96.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e8401casm2729502a91.11.2026.10.28.23.45.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 23:45:20 -0700 (PDT)
From: Yilei Zheng <trilith.zheng@gmail.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ira Weiny <iweiny@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
Date: Thu, 29 Oct 2026 14:45:10 +0800
Message-Id: <20261029064510.17667-1-trilith.zheng@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <2E5C10CF-F3E0-4694-965C-B0E432A1A962@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com> <20260903122128.12264-4-songmuchun@bytedance.com> <20261027065723.66564-1-trilith.zheng@gmail.com> <4c9741cf-ac62-41d4-9c7a-7d5ceea4a8e1@linux.dev> <20261029030511.12004-1-trilith.zheng@gmail.com> <2E5C10CF-F3E0-4694-965C-B0E432A1A962@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B8920100008
X-Stat-Signature: oc936aysq839kwzkhbij9jkxiukbat3i
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793256321-894065
X-HE-Meta: U2FsdGVkX19AYxc551bsolZBy9opxfBKL/wUi66l8vbXkisU1U6rDNRvKdS+MWMNLEzFvA8BNCdiT9LE15JmuHWShnCJ8Oev93BDIJWtFUld0ALVBre3NsDAO3l2RHTE6Culk4yEdYS2UeIr4usaDD1FnBZcGovJc7EQWuc178L69JB7Z67pAOAml/pG21RSyArsiD3ruHFgoxRuNUKx4NFUZ8u0ZvrcfNWpPFLRuFl+7xbFxi/eCbTgKoI62HpyoyBO676bbW2cOPfLmDOXMgNVpxAnj2M/sgovYhgcIRH1sXJDZo14hGL1LX/HLyAqF/VXgdRMcEN+54tfE2HBI8FdWme62CNoLhbOLN+kraW99jNmu+niUmGYgxAvgqKAH4gL2h9GPqxdnmOK/IHX7FECmOFSxuW4m1Qab837XW0CtGlCeUcjBQPdS9XLLH0gUfsOybEfw98kxP9teOqq0eJ++qTd9PAVMMw0BUzZxSQ1YyH/CZrBmkMQ7M8T/Ixn6o2+gFSU8iUwhZXa+jGvNSlwC53eVdGsJJNK2uzM+Ob5p9svsx11MKdgEgBfUYcYmiYQokFtQa49F6LD+3USMR2eGbZ2g2Z8IsuXall8jZCdNeKzPOQSSzzXSM+bp2T2UAnVnXGY0CPPXk6r6103vZXpcZRLBEaKlr3Bl1DVwfyrNAkCakmarc/VxqgBxj3HIYnYYgY7obhKPe6wIgoCRG+Vy4x2sGc/5y1d4/iC1fFzZmHFGFSSGmJLkKMwi6AF0VCAkGl/M+mWHGnD85W+g27NZpJTxqyCE0JAo+b7gN8rJCmXxT8f9erxMxkiTNYtY+heOOPbpa+WEX4nE9p0oOe8i7pud3B5YNnehMTBCdjbnmZOgafCBzeEbrKH3Y+P0hjkCFAxdtJ2hZajU8FsP2ogNTen33WrKAZusOA5aJlgYhUjl7jXjzTaz/jlsZ5FxTgCK9V2wdlHpeQkcjJ
 4bIDGraX
 8hVAQ10Ba3h1YX3UUGbh00YTDD1Xsq2hf8PUPCgTfp83464+u1boTZrRzHKxd/9NCuVruHeuxIeDB7IiBtL3UEy2hyXr3TPSD90i+UqRHVimimk/Zfi8I7Ue7knU3VlKiDWqYXGWEw/3t0Ovv3uOWTWH872JhFgwaBRFZ+rPsiMyX/VkR0M5yzuJWOzMyFVmVPJ9XS0tyuKg/kW3Snrqpide1C8jx6yC+eMIFXxFOPo5SBzLMzbV5bdCJtfIfMd2E+9Mt3y2a/s9/6Mq2Vy5PUwlp4aTk0fAXVWJ8wblTjtxW3sTSGx/2mKck9QQwbrJ4E5hU3Bn+iF6q4C8E5CWH2IEzRAgX1Yf4bGkUJ6LGsZR6yTy6cpnX6DkN8BDLRNbnVOHyyhqFWWPhCMgxHdffbXP6vClEfDdhYVMTlZmHuDKIGiM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> What's the size of the roots image? And I just want to know how much
> memory this series could save in your workload.

In our setup, the rootfs is an EROFS image exported from the OCI
container image, so the pmem device size follows the image size.

Most of our workloads are simple today, with images around 1 to 2 GiB,
which means 16 to 32 MiB of vmemmap overhead per guest. And we expect
the average image size to reach about 5 GiB as we add heavier desktop
and agentic RL environments. That would save roughly 80 MiB per guest.

At our target density of about 200 sandboxes per node, this adds up
to around 16 GiB of guest RAM saved per node. Memory is what caps
density here, so this saving helps a lot.

