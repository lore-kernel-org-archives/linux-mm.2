Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63A3F606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 18:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VA5I7E1G
Received: by kanga.kvack.org (Postfix)
	id 41F5F6B0AA0; Wed, 25 Nov 2026 13:59:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CFBE6B0AA1; Wed, 25 Nov 2026 13:59:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2986B6B0AA2; Wed, 25 Nov 2026 13:59:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC8746B0AA0
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:59:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D51D841095
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:59:32 +0000 (UTC)
X-FDA: 85474554984.23.5AAE557
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id E1C6340005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:59:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VA5I7E1G;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of zcliangcn@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=zcliangcn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795633171;
	b=CFGgAlmGkf7+tQj4S5je0x6yXiA6PpoXN9HNcqVQLAuD8aGku/RbNf+GnoHxKmALwHuMIE
	fpqVvZtn6lLWVYsVJWlJn/xrmYuRm7O7o0J4g3WR5yDP4yQw7D5UdaspfZenZ4xsmbRD9s
	4UalYVC44sEHJGzXoA0N2bYBQKsAMBA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795633171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+zx8F9i7Ddd71HeQ1FN4vj1dLIYYZqL1wTxgwGVmbw=;
	b=VUOCZmf/HtLo2bd2RCRqiQAr7JMX0vMKclREoGEVVfl3FEHqQhLu6AcHjHG1KIXat0HhIn
	A0edxPCpnYp0oN9gvNo1j1XJSkrhs4vM/5BXLyPwOzPM4gys3u5+0o2I5JFNlU85Dhfl1y
	xIlp7Bg93e/MdtNwNZ8Ob7aqcE9KyJU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VA5I7E1G;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of zcliangcn@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=zcliangcn@gmail.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-386c336eab8so2584313eec.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:59:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795633170; cv=none;
        d=google.com; s=arc-20260327;
        b=V792xiw9CCGDXf8PCaSHsjh7kHUZofpuWz08D7CFc9w4mtiuv3NQteKeLJ9ttS4JAj
         BF4e3hxatEa1QbwneXKONkiAW1WfHhksTK4Vvdjq4IQqE0rRDDlXA04/ZR6pWTEUFpet
         TXT3vNc5QishYoncorIXmqv6lieqM6LgnkF347LRVMWNfyFpkBbeHLzToksb+AdSDS0n
         l1V306MhNnqMfwnkK6rSqEgjsAoV+bJFibt3bY9OG4BYLtaDjHaNid0dU9nt0z3HlVPU
         +NN5ohrQXaSQ2Tah0gNRw65bZ+jj3yUmYA38nKqbBY7dB7SMDp/i0o/lKkTVNyxV9WnH
         yOig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1+zx8F9i7Ddd71HeQ1FN4vj1dLIYYZqL1wTxgwGVmbw=;
        fh=+k/nJYQhP0zl52+WUPhDFWMNPFdssd6ZkEaOwGQYGvc=;
        b=oNULK96J7X8hCgJofyRg6GLT1g56l7nRmwJMGD9TiP0hoAZFLDy+oyDA4iq4v0kV3s
         gZLWQDKFtPAxZRlF5cH1W2NxnX7ZeAQgIfQ/cEokFufm8jDRUPM4Ue87cQO3qCwaKzYY
         VLmz5XtLBUOSTTZZVU6NuHP5faRduKkHCQqy299rwsX+Eo6/5Jws1H3kbsfGLumwq5hj
         xXDC1qxSAMg5qsexIJM1RnASNt/EDbksYAIkZIUrsS3+PjEsPPDVCb18fvhTwHM6N6TT
         Xp6vf32wdeORyR01XQTgOSn0YBRaLjykhUumZeU4bC7YGgeA7cPp6C/0TpHyqb+aGUVR
         sCvQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795633170; x=1796237970; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1+zx8F9i7Ddd71HeQ1FN4vj1dLIYYZqL1wTxgwGVmbw=;
        b=VA5I7E1GVME3UlF8Obl0sT2r/IucrQaGtIo1dEFsh4OgAM41+3XMOD+0wOVFgYnZGv
         PUHWBNXvAn9tQbKnPm9ab840QOBfo3fcN2ChtqIhCV/KAhtMFavD0cR0TzhBQbmnthBH
         VGyg/Gp/0k73LSqrK3znOLl6661o8A3pc1GFmy2xcfrvTEtxHKoMLRxEQdaoY092QaY1
         N5J4jlGkrdC1H2y7j7pHd8MWy13agHTttUZRw2byB0zZvj8GKB0xm2rdacc7NNrudsSY
         zgsSXEIvaStUxgCN5d0dkAoW/C+59gnLRQQuh3U9++Pk3g77/0DO16JBL1zcNKpb2kOq
         Bufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795633170; x=1796237970;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1+zx8F9i7Ddd71HeQ1FN4vj1dLIYYZqL1wTxgwGVmbw=;
        b=gK+mYkuohUVYZ8RhxhmTc85fd7FWnyq3JTh0phBiKDQb4s+2jUzoZ1QbNB05O6yXM6
         6ssgoOaVjw3yDZMuS9kMAjUUeqXvW26SKP/0064uQzGjuS7lYAc8xPyk2Ez//6Wt6THc
         /px5wkhd1Wc/3+iAhpdZXqj3jWkHBXWo8qqYntdONqGQVs58BO/+PMFF0SaP8dl5iI/G
         SR7uPZ6lrngWrNbzO50qbqfnWV3lNDwctBNDTcDN49nhnMOZgh8NvVUvYZzshqWcjEGz
         l1UiFNPNm6kPzeQKorMyMh3zFt2/IBL44xWNP17SCB29+GnQkONvT71aWYzahyyPKJzg
         ahww==
X-Forwarded-Encrypted: i=1; AL+hErFqXlqLfcokOX+KF2JtjwX56q6z1S+M2Rovb2umwDaFpUkwqU+Z++BFSblqEkwBtvckD2azlqGNOg==@kvack.org
X-Gm-Message-State: APuU4Z9pK7D8CPxXGU/qVJ5v4TWdyJwi7MbqRipODA4Fw4FPWeJN4+Jj
	AhsQff9obQZtNe/lX3Su+mLTCg028MkjpkodDp3KiT7KG5vFcOlMUGNpBEsR3P7LPTz9cNxYPcN
	2nfJHwYdhUv7fX8dWpn18aIk9OtzOKIA=
X-Gm-Gg: AZFdTZdb3Na8wL2RRuTV977S7bPbwYLrPXLibTEFs5hsGydR6zhrCPhgZrjozlKrjLZ
	NXmFXoSfIFz+mAbI86gFhb8FgrKfzvM0GPWHvMt5MjVtnqGe91GLspsaqJgxQuf1VJHTxNAtpXT
	tJoSuOuThyCJKloDIdDhZdsdBXcGYzJ7tmJGSqdEmM2f6hoe+aHXkILSk5/yijkX663XemSqvrH
	b1/nKZ3uxZPCvX0QnYMeIoNZ7qCBVEBoDoB6kpBj6Lw6w5/xRKIv4aY2jHQ73eJr+Pynhvk6dFz
	CNqA6LrmbGmyNzvWZ2+g/izBu0RWcN4i+U23aSBmm4WoY+1JEr+kN2rnCsrG4AvTk3KP2y6UdtK
	wDwR3xBBvYQ+YNC+QkPJPn0xVpx7mt19/v2PeeC8=
X-Received: by 2002:a05:7301:182e:b0:386:1901:d994 with SMTP id
 5a478bee46e88-3861901db11mr17194026eec.5.1795633169382; Wed, 25 Nov 2026
 10:59:29 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <9a97a64f7e7aabc668499c426a2417a77d13a2f4.1795587203.git.zcliangcn@gmail.com>
 <4ffa6613-119b-4eae-abbf-26134bd60177@kernel.org>
In-Reply-To: <4ffa6613-119b-4eae-abbf-26134bd60177@kernel.org>
From: Zhengchuan Liang <zcliangcn@gmail.com>
Date: Wed, 25 Nov 2026 10:59:18 -0800
X-Gm-Features: Aa3M54pzbYFgnke0SAVivzQ8DqG6uemznWha_SeQH4FCp0m7Qoj90E5d4jnuXgo
Message-ID: <CAOny8psx408zqVv1xt7DHN8yYkQksjKZFDQCJ+AGFB-CDN9SmA@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: stop hashing address_space pointers for fault mutexes
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Davidlohr Bueso <davidlohr@hp.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E1C6340005
X-Stat-Signature: 5f3gbshsxxssgcf7imfkeupgctodrrpy
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795633170-693882
X-HE-Meta: U2FsdGVkX1+VoouGelLOmOk4WfHjFJ15+wB8Y7HQ+rQE/1C59mPFhAK60nsZ1ZzrCST12NkYiCPgoka2fF1yEMkmpe+A4yoGxDcNchXAUfKmOZez/1VC51B5fd1FOua/70OtO39k1oABsUCjbQjWY/bP/C/8+oh6s0QKJmQAXs7MFPv+oplqGR2pryled89BgFucOPs7UQC3+JtVoFFJG6eSj/W7AAFNsNMMd0NFo8oDH4FOhWURu0uRtT71sfJ3qvgTB5jNv+J1ZD7IS1lMbayMP4K+fnhOw6a+ZK4ARdBL4tKD3XuUub4akErk6ZUHf2VN+DCOc6H+C3HkJHP8cIY3p5OYqk9E4BuEJw7Qjp9gcgBfNNN2BS/WIOFsyHGdcxODMzyxWY6f71W+Pbi9EerzsNdRKi3RzLX0+sKPBePLFjO6gYwNJNIYuk5voGzWrvuUoXoyGEIa1dJy9pkQq2eX8Z2VsxD5XBgDyemT4JZZNK+f2WWdrJAeUHnwik1VBwq8QAJj1zQywo3f2FHkSNxiaOqgX4Fu5mMqEz+z0kbwmIgbd1AQPH90fESKCw8e5cHNo667gVUD/plEHxNiKCSW6TJU0SECxRLaxuZNpHqLEYeUQTMXYiyMyf7a45ihx0Ep+Eo98MvoIPI/v4HtYdZCu/0pu+rkgfmb4I9zwhKk7UV0djPMd7JnYYlq1d12rYKLtL/Nef4p/cL/yT2wcHjf7JawRvumdr6D6J21zK9Wg9ITCNHFybIAj0Flmgim1gC0BNvRXvSAYehOQ81h/V5PiEjAQnRED4BtSsT68dTehIMk4bkqjCfWXruQzcVLAujVo5fFZ+qvYq7XeMZrxcmB543GmpPlPuCTIVndukY2V0/F22upBRGXluDLIURvDfLMOCHd93joRbLyAod4tBvXcTeuzW4Fen/RCbaze808N05mEjVBZbGjDDl88+dxVdTh1ZJRWIFN2DkiJos
 1afccFIx
 RMXzmS0KhIbOyauk51njeMW3iXv0ulDiCQ63Yz9J2OCITKSqegYt2MhGRAL5dhT05s7uUMPRikIyaTUorzDUDzaExynbIun1cUIdRgCcjPMcfUwYVzlDRWd/DO9+EJRVF2HRe1QQgDBBaCo3gJT41/7MhDld61JoYuDm4yj3Cf/TNW4Lf0yjQUuG+t+4EkiD1CF/MCBOzSdDNKz1fHmuWbxhUTh+VgjHazrbyUjncdy7CdCCRphaqYzhcYEEaYzUzsv4Z1fi9lXp7mE/WwfpZXh9V6twPSUcofbRb0grKkANd18WTQwFN7Id/pSYM2zZyxIEQd+cViDTreDf41LbrRn4/vypx53DUgb8ew9yXIwNs1ROC4HavWPW5VAe9e9nOBEJy2vAeLPfDxV4yxIITlWBZK3clTJTVH1f3MKJD/nWYPzdhi+/WIEvtfAAA7SrwdHd/Q4s9JH7fe32RMtO9PS17dPDx0JatgUvvJxt3NwvC4iT4j/x1VkDjKsC91F/5hQUYBItlhIIGt2V2knCdg+I9c1fQ9eMghqhZe5zeELm8sUds4Jvk4JEii2kAPI6ElbVdwD0646J5+pH85RviuRCS+m3m/3SuN+O725pshWgWFooCHRUhy0bB8L+yyMj9fXkqbjFZw4o+pBdrT0KRSSP1Jasz1z3TK/gW7/5mLL3jN/lN1WgOpo0RHgVVDR/kZ5hxcqD6FtqXf3kxWrex/gPZxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> I'm not sure we care about this problem. I'll let other speak up.
>
> Attacking hugetlb users is stupid. This doesn't matter in practice.

Thanks. To clarify the threat model, this is an exact kernel heap
address leak. The attack does not target another HugeTLB user or their
mapping. An unprivileged process creates and operates only on its own
no-reserve HugeTLB memfd, even with an empty huge-page pool, and recovers
the exact address of its embedded address_space. Since that object has a
fixed offset within struct hugetlbfs_inode_info, this also gives the
exact address of the hugetlbfs_inode_cache allocation.

KernelSnitch (NDSS 2025) demonstrated why the address of an
attacker-created object can be useful. It recovered an mm_struct address,
freed all objects in the corresponding slab, reclaimed the slab pages
with msg_msg objects, and thereby learned the addresses of those
replacement objects. Here an attacker can similarly allocate and release
hugetlbfs_inode_cache objects by creating and closing HugeTLB memfds. I
have not demonstrated full-slab reclamation or cross-cache reuse for this
case.

https://www.ndss-symposium.org/ndss-paper/kernelsnitch-side-channel-attacks-on-kernel-data-structures/

> Can't we still end up with the same problem, just slightly different,
> afterwards?

Yes, the timing channel may allow the per-inode seed to be recovered as
well. That does not recreate the address disclosure: the seed is neither
derived from a kernel address nor used anywhere else, so recovering it
reveals only this inode's bucket distribution.

A simpler fix would be to replace the mapping pointer in the existing key
with mapping->host->i_ino. The inode number is stable for the inode's
lifetime and is already exposed through fstat(). This would preserve
separate per-inode distributions without adding a new field.

I understand if this particular address disclosure is not considered
worth fixing.

Best,
Zhengchuan

