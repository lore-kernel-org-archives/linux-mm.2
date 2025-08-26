Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6BB1CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BCB58E00AF; Tue, 26 Aug 2025 03:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06DDD8E00A8; Tue, 26 Aug 2025 03:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E528E00AF; Tue, 26 Aug 2025 03:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D65AC8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:20:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8BC8BA9A9
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:20:58 +0000 (UTC)
X-FDA: 83818061796.16.8EB2DC5
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id CCED920008
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:20:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N3NEXGYI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hFHLpr6FcX/Wx3J31OLqW186GX8K2s1j2kcuC3aNVeM=;
	b=M+L7Py52gV/IEC8WSRc0fc4+wNls4BxyJIavxIJm7PMrX5qTl+8OtcseMIR9UgjL7BZpT7
	pK6Epmpb9XphP+a0JYqdj2feQxXNlksCkaz9FkbLhBohJyCO8MfyeUEPlDEQ2/mrA52OeO
	GOJp+KuPjRDmHE4ZtiPnqNN8mMx0ilA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N3NEXGYI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192856; a=rsa-sha256;
	cv=none;
	b=d4/Zn6x7sX+Pm3OwlE4/lQEGGsCMYzDAtpi/UBDhdIN15JpKIssUH/vnY60G9+L8rvlRjI
	8muW+pzQOB9U7DzLl0klIYiPq+quM+ieBgswllipdjiGbGJLapsb1jb8zjYYMMVJMIcLUi
	ffQCARIWU611W6SvfOKtpLa8ZYjo3Is=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-771f90a45easo354030b3a.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756192856; x=1756797656; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hFHLpr6FcX/Wx3J31OLqW186GX8K2s1j2kcuC3aNVeM=;
        b=N3NEXGYIhIGMN4qzFLE8R5Pg8l5GpEZzKUvPcZYhifQNvPnmGxQ7WPPjgNWtGTkEcj
         qi5Hg2QSpeLe2I5glkOchokqUQu9zv4kPBacRT2xHx1sfbp4pp4DwCBNrmSMajHyOMtC
         Q0xQgFIv98TxJ17i8PiqGo4qyN+016/yuhWbLfhrgy4jqJDP+qJuaIOvLdZqO6teULJe
         ElFKjlxfK0HJGKQ9Eat/8eNgeiB7tsdne5H+5YvUOFxDWe9NdgICRQJuSBccRPgt2ctZ
         1ThMZj1tSnsP7mvir3Bmoh3tmElW/9RhK18+l0oMLYXHITGPlDaPGdPV663LzSnXs9qX
         tysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756192856; x=1756797656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hFHLpr6FcX/Wx3J31OLqW186GX8K2s1j2kcuC3aNVeM=;
        b=t+WunKlb1pQgxPv6uDAH9rfhafR8tr4w7kKrEyrnirpxgTftHE5kellfoXNr+Z8miX
         EVOXVGNlqcohVNBOAvXHHDJ9f0GK3uWPxjGtOS4AMweQ4jf4diq1UYpTehpam12HbUN2
         qXV4t0eJFQscneAnKPl7MOsu2WgZAJgNYFJ7NyuK0zSAv7ytq+/3EHMyAMZMm+p4aCTd
         UzSqhy0Fw4s6mMs2P/lsMX/og/AoQIrQukDcYq8xdAy5RPfZwUXZuuGZF0ZWrTwrmxUS
         xhUuBMCEs3LLMbZqfoSX8HQvLXLvuyxiwLjYEXaSXrNxNv0eNKVi4Q5o+C/akas3L+E4
         dvdA==
X-Forwarded-Encrypted: i=1; AJvYcCXdO7KB9geIUCvB1u+vifJ0dSP7CEZcRb0kBf7Cz5lc4oB9Jnq3Tuh4UfwiLJoK80w98MqhFYvluQ==@kvack.org
X-Gm-Message-State: AOJu0YyEowvqamEvPZ0G8VqTmgDLwDCKJECxKV+h1pU3nZLPQcLtIR4h
	T4Vr8mcjIPd8zf9wwrgrscE4tFkbX994jjl1Q/to+SAjGDQTmlhwvqH/
X-Gm-Gg: ASbGncsxkeGNk8QmXzQeCAr6CnDuNbBhjoHipc/7gIWqRiJ7v9nWido97lG2ExCpLDS
	db9fdJ+eyvmhFay1CNqRG0afXfmrZLoZpqUrJoWFr4XJbqMXtDQWGd9dKCMnj+ELXhpnNWUoEJS
	VloGZH2T+JAYvRgh5nq2VD6ISsmRoF9UdKxwgTCzaIA0mbtbs0V3oN71T00YMNaqmsvUD3z/Vw9
	6F538Faef7ar1xENZ4q6eXp/WMTdEKIfjg8p1IH4+KZlhRo+W8L2cC7Zow4yKywReiVP7EQ5KKk
	pQtd8jfBBTi1K4DU+jxhPF1C/415yVZec6DcRBG9W+8UuxYFZq/v9bBxSact0Opd+fmMuowUpCU
	bNZ2LACCkCn+imS+EqDd+oGq9ufvmB+J+YzFWhs1tbRYXq4fb3MhzNYBs+mtSsbkImKixKBvCfQ
	fFEsI=
X-Google-Smtp-Source: AGHT+IEmmZ+P2cW6+dn1oHu17l4+iy2IHTfCaLsUk4rpmP0+qhz3tPhrdJeYge0DcysCptQ8/nMPPw==
X-Received: by 2002:a05:6a20:160f:b0:243:6dd0:9bf with SMTP id adf61e73a8af0-2436dd02547mr9068214637.53.1756192855650;
        Tue, 26 Aug 2025 00:20:55 -0700 (PDT)
Received: from localhost.localdomain ([101.82.213.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401ecc51sm9686052b3a.75.2025.08.26.00.20.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 Aug 2025 00:20:55 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v6 mm-new 04/10] bpf: mark vma->vm_mm as trusted
Date: Tue, 26 Aug 2025 15:19:42 +0800
Message-Id: <20250826071948.2618-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250826071948.2618-1-laoar.shao@gmail.com>
References: <20250826071948.2618-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CCED920008
X-Stat-Signature: 9bgbdqj6wft4s91ztmyqti45ubbsfe5f
X-Rspam-User: 
X-HE-Tag: 1756192856-650879
X-HE-Meta: U2FsdGVkX1+YwBja55G2Ljextxg3PRFuLf20Xeb3xN1fRBxwoy/NEVaTjpwrjIUGkHMAFW5owN18wZPaB1lFIdeCDXAsBArWW0d+u3b/5GUZDahOf0oIkfNXNj54qXqDcD6Wn2ygTHHOWJvfyWqM4xFwGkh7HsTSHlAQVrMiWUStrWfoary4zmfxNy1Lout8WXsTUisx6HR5ASKNB3hqjTZX2d6eaEL4a3pP7KGB9ODOnHCWHaD8aSGaTiRsy/sRQYj6zstpSfcRBMIQKodZCFBiahXiZZGeVvqvwTyOzqRreHUT8YL3mlYrdx3zjuVqx4J9IDhZwmOA73b8gdQfFU/uEhukECj43eSDwLmmia7wV00kG8pYNUV+MAWKmTr6m+QiyoxSP9acjzOXDW3g9TVSsCT+v2Ba15Wxwf5gvytGW6H4rAlhbBnYfNTrSbuThXk5E7s76OycgS3x/GfRJsWJ+syJDOLoSxKGB+ydhu+3mKwFcBvRLjTtL4xuq2CVEJoJOP+2wmuhz5QQHm61jla4iGABsCpBNR5hRXW+rcjksZBxZHqjvdCz1szYGxkxS2CIE/RruTmlMH4pf2ltIsmkjv1rLFCexfsyUJOVQTIGv1tW1XV9VFQnejpPLGh5ezWrVwK8IoweGEoso3pDMDSDnz3TBTbysTPKBWBCZTiN70o+zgEt94fAE6SS5eo4yQlDXlpfeD9za5AoYt5v9KEeWSm/YWkjLXnWw/vWnUlVkEZMYLncFbb1jE13twjtBzhEV5yJvwW7HAtSQmJxk4I6FoMKb8vuQD1hvStUWhJuqVPuteHuAVAJgA7RHcLHHTsgN+piK74il26TI/EDpMewFHZrc4Q5SchX1g/IzZKU5mQt09173rOq2tfWCB+yEeEuOwASbe0XsuEPUVtB6p4T2mwUSTrMMiNaWzGojbvY7Gp0W5zALynI9ldm2KW6uYrUJODJYyDiOIpGCRv
 bcrejqEa
 7q+o2IOREvtDuKo2moMNChYNIOGcwh/FL/BNMIa1G7NPalxYAOnNW2AnOuW+wk5wBzUaVCWtf72pF2aYUWpPvfKoXjaFqd88IlneyFxkUQvs/GcuRkwBthhz5w98l/vKZgtgJOlWADCwBsMrgK+GHSQsZo3pfbUS6CBFOMpydmsXdOXuoDbRO9wmGXEJHuyB1HJ4wRHYIZ4ojRXtIh7GkaSLnfYOyGc8zDRvtb8oIpJZuQuq95gszZqPVHpD9L1YuGThNBllizF3fIZqiL29tqHuzWZsd0qxkVWZnsnVHe/B7ifcJEEVbDBBDVbFev+zRrhnL1j9IfLhrvjcqddKjfBWPecge0F3ufOy04mT+lIML6KGkAdwEA8jF4Y945EXttQiO7i5XFZfIA1wJRezZYcpgvRZ9XNM7ZKHkMY2JtsA0CMP5nFACwAW+9WR93mIOccpIoR2CIsV5ENkT54vFvL447J5KdFTUgWzQm5QMyki1tHlweWp0oTmzRqNHK008yzZ1UFM71faghceNHCyKQ9dtAVzUjBkCJ3qQ/8pjd04XJ+23AhVrRC4JdJhy25WqflHVH8CuEdnc6+N1YYqmsBfNvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every VMA must have an associated mm_struct, and it is safe to access
outside of RCU. Thus, we can mark it as trusted. With this change, BPF
helpers can safely access vma->vm_mm to retrieve the associated task
from the VMA.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c4f69a9e9af6..984ffbca5cbe 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7154,6 +7154,10 @@ BTF_TYPE_SAFE_TRUSTED(struct file) {
 	struct inode *f_inode;
 };
 
+BTF_TYPE_SAFE_TRUSTED(struct vm_area_struct) {
+	struct mm_struct *vm_mm;
+};
+
 BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry) {
 	struct inode *d_inode;
 };
@@ -7193,6 +7197,7 @@ static bool type_is_trusted(struct bpf_verifier_env *env,
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct bpf_iter__task));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct linux_binprm));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct file));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct vm_area_struct));
 
 	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id, "__safe_trusted");
 }
-- 
2.47.3


