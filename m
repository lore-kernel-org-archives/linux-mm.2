Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5AC1CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 06:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F08D9000F8; Thu, 14 Aug 2025 02:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59FA3900088; Thu, 14 Aug 2025 02:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F849000F8; Thu, 14 Aug 2025 02:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 360F8900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:48:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB2FA160534
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:48:07 +0000 (UTC)
X-FDA: 83774433414.06.52AB065
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1AD1A40007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:48:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VgUTVY+5;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755154086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3Cfy9MkuTryrGPvIYV/gwml2MAD5wD8AXaGEu8eeiY=;
	b=jcTMFlcGQmtzqYr6URgye24WBxTkIjddoKRBK6mePvTDGLozq4CVqG0OhlNgBj2OVWr+cT
	ObwxaTwqpxczDkXuoH7Hp/AesadOAplDuMWaiK1L76Uu95YvOa5DLPzjxVbAX/Su0Hty3a
	ba62yqvRVzxUvz8NnYQKoch35Yxocjg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VgUTVY+5;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755154086; a=rsa-sha256;
	cv=none;
	b=fu6GiNJhRscx5/KMgcVQ3cFO7NfY3u2r/crU86Dh/NkMUaKuwpKxlKlAk1LChnDN+nfOz2
	LDmd/l0JhnKpKsKk1kihPr5L1KzxB0/AsUZANYlJXrnDMH3sKzhILNJwiTrYWzTbDV42g+
	ke/AAt+UDRnpKnX58peJ6tXG9hKIZl4=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b471746a879so326311a12.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 23:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755154085; x=1755758885; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l3Cfy9MkuTryrGPvIYV/gwml2MAD5wD8AXaGEu8eeiY=;
        b=VgUTVY+5WZTPWb6JQnZuCRzB4YJ2LHzTiGXP0naOcZkI/weO9ZWBf0Deo0NxJUhZYx
         gyZOzLUKXndZzkOjfsdWO1yJgfUAwNUAdG1sIkTsheXGJtzJfn+1KXC7DJa5IolwS6Fx
         T5tOd+B1L0kPBYWyLAcdE0zssCm/Xis2qHdkyW+Ed/+Zvzt6WlyGu9g9+l6PjVGMcUR9
         7g5KjZpriNJA6qCUAkBkAEDeL4jmZQLCBQpbiHSPeRZRj+UYMzA1LXTw2VEUtAXrNMqP
         u+r8fquG8BU2+qNFAF/2A5LRNtP7W599+Q4AcJhsG1fqL4v2c8LQpRamPXoOUyOnF/N1
         tF1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154085; x=1755758885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l3Cfy9MkuTryrGPvIYV/gwml2MAD5wD8AXaGEu8eeiY=;
        b=i0htsC1LuEJFLp1wjVxlY8l8vHFsF+lrlV/nrJ2T2U0bHcngWyWhoic4j1IZC/mzGm
         C1XTC7hj+kvRPBACo6gn3mZCwtctesqiL9IWYiyYA1Pe4cTqF3IelaFfl2C1M4R6hYP2
         xdn+jDCZmko5U7lCuJB5tT4mzpdjiXkQsqHE6eaadSIlYsHP9fBc2l8qeOJBaG5hhDli
         tinYPHWsOPF+5ioyCD2xkuqQY4fFEzFD7IyO5Jw55lCzAgE5j2ipjtxD0NMUKqdwOVY2
         E1LUhSMbzNf+cb4LFB9tE+rKERCchEiDmfr9MC5HEWGEsw6uhVAEVkJm2y4lvoX20SJe
         9A2g==
X-Forwarded-Encrypted: i=1; AJvYcCXV9RACP5kd+a0vsMKi2XAqNfHrZ6kbAJd9WRY5RdL3T450Htf5jWujISwobdqxptQlAgOUQOtmwg==@kvack.org
X-Gm-Message-State: AOJu0YzmnB4us6+DjK10Y27Fpgppol3Fu6U+UcdEASnU1AikOTorjKS9
	k6YTGcf8ddi0wGGOqacLAAItnwG8ik5MucdOE6DtOBokUwMp873wCjqIjJmhFA77glw=
X-Gm-Gg: ASbGncsXwlBECYZ5GS/g95/JNPtWK46eip8en9+n9VnoMtwhwkH7miSs+pl/PAc/FOf
	vL1jGg6uiu0nrT9H3JTPoSP7eP+3LuYsqYLTAu8tz6MZFvlo691hpZwIfF9HdhdKmU84J8wcRMl
	3hhdkX5PQNontR6KYAFcDDKvDR5aCeSfCkdRjGmhvJU5ohmyS8RIj9VpTh6mgLhHYfjtmE/jNbX
	Eq3L6DBaZnXwx9xfjcY9EabtVlmm/XF04B+4QqxKxqGEQO7P2QmfNyOQT6HTfFS4tKwEkYV+I7v
	ZXF7KnzzHq6+52EH7GAlgT1ubv4VpPT/6GTQUUk9EwGAMfqQnxWiGo5hSdA3OwLAiKnt0cQqXwL
	jqR1JeFCMGLYsPjiEwPGoDtXrUjx4bIx5DOI3i4she0k0BeMtMQ==
X-Google-Smtp-Source: AGHT+IH8PhH+kdbJo3TseIftuOS4YtVpdigzS/1u9iU7jJG3amFRXpK5xS1ruA8Xmy2+ygpXe+27pg==
X-Received: by 2002:a17:903:46cb:b0:243:11e3:a742 with SMTP id d9443c01a7336-244586eee45mr28699945ad.55.1755154084954;
        Wed, 13 Aug 2025 23:48:04 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6a8fsm340923605ad.23.2025.08.13.23.48.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Aug 2025 23:48:04 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	david@redhat.com,
	jgg@nvidia.com
Cc: torvalds@linux-foundation.org,
	kvm@vger.kernel.org,
	lizhe.67@bytedance.com,
	linux-mm@kvack.org,
	farman@linux.ibm.com
Subject: [PATCH v5 4/5] vfio/type1: introduce a new member has_rsvd for struct vfio_dma
Date: Thu, 14 Aug 2025 14:47:13 +0800
Message-ID: <20250814064714.56485-5-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250814064714.56485-1-lizhe.67@bytedance.com>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1AD1A40007
X-Stat-Signature: gzjsyhqxaa6dmhu1hsu96zowq3i3b51z
X-Rspam-User: 
X-HE-Tag: 1755154085-456247
X-HE-Meta: U2FsdGVkX1/gtfe5tEYL0ZaD7TRuhdckW3VEjYqcmn1+RrS2on1MmGSHf15jcE5grgQ8VhBHJMEBy8ludeZ4BNAASxMAeLPZ6tZGOlFte7mTmw1lbYDJieoh4UTaxnobl4/0oP6hPd43Lz89hW7KHgIaxIWt9EOe0yAZwh5vjnyMv3BTAxH/9ZI18vwysdxW2Rn7ojfjoEYiQmT9g6KC6b4/i2qOu2SQw0be74KIA+lHc/UqDEPoji3yDhY/jKk4UboACwrgbtpzte4DG9KnNM+t2fNFB++PskwruUzL2vlwEq5L7xg3ktBiK4a664ueeN9DDyzsspszoXOqC2SJcd3tgrtUF9xvEeqSLnOe68cnDIXUFdUyOrVS+G25YxTkyFRUdSWQpAJEv2AiOYZfMIVBwNgVM3PGtoixp6jzJ86X2527MmeinVoZKfJkYOSjiOIXSgdHG+RntEQV+6da2TLLjeMJpEs6Ey+M8ChOwFT/cFyaMEMpSLvF+COtdreNvF0JaTAmoANB2R5b66+onyzi30BrJrTMwvVCVk3sd67SxMJV4wqpGV0fkSyTRc5i252k3Z7aXuLOkFoQ8p6N52cqr41xxSm2Kz4vrX8E9sIX56aQXbsaFhL8Z1SP7kLKJ6OXGt/iTjkDEeSlFfmdekNabOI8USVg8ioPilOb1qy9Ep3nPzV8csqEWdVr/MJt7Y1N5csruHeo07hquvMSMDIM4mG1Uys8ehio6CNMtXPwgxh4mA6u+VmBc441n211onkbghy54xSs2DEkKnXHnrYdfkZQrmDD9F2+a/AUstR0ug64rM/5SzZ8L8KVzFjDJ0weCOWtgWUqelqb5Y/zyQN1FguQdyqIldiJ5kUrwONd+cOwkShIr38dEJm59Ooi6u2YiH5eueHSCujHE76FLiI7LkDefWkg4nOS2+Xm3i1mEukYq/AtaPZpPAMegEtkLAMbvTwHGqY2Wu9Na3j
 MtfPkJTq
 gcXbPNWsvRfQey6/krS1MTgPzgYsX+U4uA2lZfDos/VolHqIThrksX7NIHAoJTsCF9H1Ye5jsIvf/IoCMslfQCH5F1KafsmPxVx+AUWxaT2eyAgYGtvPz1Cy4ia2wpKO2CQfxLYIOGTJ6N08mV53GnlvpSMmHSyDNnrCLzhf5d8mCV3p2ZORC4oe0jvUFsStyxmEE9NuODcvhJIVmk1KOnnRJFxsw77DztwJRqiAlWg94KbmUOGOc7ZC9PQhy2nlmf0Qgbd2n58JAgFsegBGkgRdqmPGqGuSv0Mlmvl2gunbnrD34X754HJlfU1I99fo5/ZyfzNlqbKW02cnCrboqpcGCGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

Introduce a new member has_rsvd for struct vfio_dma. This member is
used to indicate whether there are any reserved or invalid pfns in
the region represented by this vfio_dma. If it is true, it indicates
that there is at least one pfn in this region that is either reserved
or invalid.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index dbacd852efae..30e1b54f6c25 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -93,6 +93,7 @@ struct vfio_dma {
 	bool			iommu_mapped;
 	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
 	bool			vaddr_invalid;
+	bool			has_rsvd;	/* has 1 or more rsvd pfns */
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
@@ -782,6 +783,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	}
 
 out:
+	dma->has_rsvd |= rsvd;
 	ret = vfio_lock_acct(dma, lock_acct, false);
 
 unpin_out:
-- 
2.20.1


