Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C8E606A6C4
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 20:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=qNJ4/SuV
Received: by kanga.kvack.org (Postfix)
	id 137EC6B05B1; Fri, 20 Nov 2026 15:04:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E89E6B05B2; Fri, 20 Nov 2026 15:04:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F192B6B05B5; Fri, 20 Nov 2026 15:04:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE9546B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:04:00 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E305401BD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:04:00 +0000 (UTC)
X-FDA: 85456573440.09.DBBA260
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4182E40006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:03:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="qNJ4/SuV";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795205038;
	b=key1Zd0X2wMfyu50IJleaPXMwg+O47nGs5iF13QN5NuQJezmdaw/gFs54sryjRx1wDzvR6
	Dm/TkX1T4CFtguB4Y1JFOQv0W0IHkLdTWuS0vK/S5gOUelCpfe9lSaT5Ea95k/o3a3hxsO
	RuDHYUJEPbWiewTY7cMOmnSyYpi+gb4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795205038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJNN+wbVdYmGniuurEFfsOta20znKmxlY/TD8nCl7To=;
	b=U1/rGsK5FFXnvx4+Im9mteoo/EZanigRkqViceaOAKDO/IZNs6cz4vJWvlQn5r7Fw87efZ
	irZ0NZZNNi6sWW4EXskGwFfrfxo6k+w849MACFT/w+eg4vze1leKR1InwlPA65+tJuMIB5
	MPPz3wiaDPrSu8/nHVOl4CVfMB5dh7s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="qNJ4/SuV";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=skhawaja@google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2f048bc09d7so15415ad.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795205037; x=1795809837; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sJNN+wbVdYmGniuurEFfsOta20znKmxlY/TD8nCl7To=;
        b=qNJ4/SuVUPft1zzq0AhHN6ZCd6/+lKpwqktCtzPnL00HyDg3r53iL/BLxtRApQ/009
         50vPHEc8ECjFFAErBWMw4WNjh6T5ztAUnd7VmSsFQdnW1m5jYEko+wIUba673HauUhbP
         9VdH7+GziKO0qjNotN8CF1kiHuOt9KR0r4nDMZ2t7WpjAtMkrPqe4wPrDx6IcPiGyo69
         vgtEwmM74LgThIFnxfbanlZtp/6PzR5HFSIQjml7Zl/K5ewZBir9bh1FZE9UTwS/JPSU
         tp3IdtPzne9VY4r5R770rLwr7N8CIzHQ+WfS/B3k0a4XmxblDfSSeVS8dpWpDkByTo6u
         7G0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795205037; x=1795809837;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sJNN+wbVdYmGniuurEFfsOta20znKmxlY/TD8nCl7To=;
        b=DQOxSNMhJt0NNZek/KJWf03Tn1XoFf2Z4DZ8L58L4QFcgCK1yMX82dNVk0hfTNwTcu
         SiSuV6Xrq/rtNzw4og4HtAMcDpzu49uXuZplId4R6FNNhlYnCh0kJiJfMLIiKWo8S5Rp
         CGYRfpGvwuIf4pIrseFsgmVdmJaWQaR2NeNXbArHvkOgZcnqYH7IKW6N2B1g2Ul/Lfj5
         HaH3bmgmLEnQh8H9eXm/ZYfjCAo5rljHRSGGq1mFFM42K7hBVxTQeSB46tI308EKyEWG
         FBExUnIFvxVJmSOV70YmawW4rgLiTCKUOEfoHRl5VabuoRBjiA1TrDYG/C1TFNQJCzGb
         XxEw==
X-Forwarded-Encrypted: i=1; AL+hErFnGmOboZsFMeeA03+WlqxzaoFrzc9k4Ff24hGdrFYDzz4ZAsfEn5RshsHaf+dWd9qDEU9jM6qLzQ==@kvack.org
X-Gm-Message-State: APuU4Z/omTdxotGfmppsICJSaa4qxnX3B42sxp/J0MNJoE6PX1x9Uu/s
	+Y+/lSdz4A3nD7oGhO5NzryLcMEA3DCYiwsl46X5+OgphUog0TZOBtZAHEEzIMIVLA==
X-Gm-Gg: AZFdTZfVUuDQoV+/zl/KeIhipdnvLX26TkRoPnX/HQVv1Myg4g79jrkvK/oVpfHl957
	eRWt6nUNqDYNtiZq6JCZSBoN54GEspq/VTvyLmNPZFGzhBEcTi3/beItGndhPV4RGDQdnKeRrCd
	9GPfTQIRIlB7SjWQHnz0MYi/WhTF6EbXl+yRbbJXmeVlWAwLmxyQue/oUwoXLnTzzBOA4oe+tTY
	ssPc3mrWQMjU2rqjw/OkHoHt0VNDLbfyAJicLESWYftcqtjJfaCRYyBTSoQ/iABmJnCxcna3i5R
	JPcrYfhRPFJtY9UfSWGA8khh0cC+CsWgu7yfxKXP+Fsl00Ao7xUTUBMhOoT/Cq+LDWBZ85w8Lbr
	I6/u3x1S6pj6Y89Ga1q/aqJhQILRyXPFbY/fM3paxc8+UPSF/ewN7A/Xabn33Cf49QoTf5WLS6P
	Mj7L2C3f1FYwCW4Vvb5wnUeV0QW+bU3XL+VS2CSNah+6arsDggTVAgPGI60ntKDyx3JiYfHfZe5
	/Wqv3jPYDBn7agDCFof3TzmCvA8q/2RTN4v4HjmPtD/+aFe7KHEYEoFE+4cgRhJqanC90/4YNrT
	SLIkzBW0MEsvd6hJgQ8YXj/vDqqep0quF8D7QUZeaPzCNbWkdwRvvii1/dnV1RDMSWCL2pRsNJp
	CUIENi9aT22zGq1g7uS8bEg==
X-Received: by 2002:a17:902:f70e:b0:2eb:19f0:6e2a with SMTP id d9443c01a7336-2f06242bd5dmr601345ad.8.1795205036492;
        Fri, 20 Nov 2026 12:03:56 -0800 (PST)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d63728sm9122188a91.8.2026.11.20.12.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 12:03:54 -0800 (PST)
Date: Fri, 20 Nov 2026 20:03:51 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Jiahao Xu <xujiahao@cmss.chinamobile.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+7666ed2c3d42196bf7e3@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 1/2] mm/gup: add file_is_memfd_compatible() helper
Message-ID: <awCnnKfv64IyriEW@google.com>
References: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
X-Stat-Signature: in3prwmhw6pphr87n1s9bbbxq3tupq76
X-Rspam-User:
X-Rspamd-Queue-Id: 4182E40006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795205038-709891
X-HE-Meta: U2FsdGVkX18UYx1fTh6IJFzBeFe5qPf+O4gZbCZ+1i+tKwHIq9vWpFTsifzq8rQMuazaQLP2DnoThLQmYr6Y0/q0QtUT2PbI41H9ncvHB0EuMO0jkQDagvxiAqEDwsvBEP+3U0QgEFkYOggjgPy9T+xJtBJMjVBXTKEQmKM+m2oj77LiDIkAAA5LpeSxpbMqGB3N5XrQJSr3k5Kh+xQ/jASsf3dvD6E2Wu+M0iPT786KSe7+1Cls7kSdTmLx9qsHhPO1TzncB80jlI4wkBKjwMG8soBpb3ldaRldDGmtgKo1dKXMmAuq0AzP6Zj6nRf7EDQ9CM+ICHYA9NleBZU1hydomRNAmtcD7gcLX5kLydp3Czu6pmZOPYG+iH2AZXuH2FJ0+TH4SGGv0WFCn0WMsDTrviRXVSygQcE5E+6x4jAaoGmEwymMoojKOEi3dPUAnajjbYgJuVAgibj3d2/yq6SSqo1ZcuB12n11cr+zO3Ahog6PTjaGUN8j9mudLfJnk3KxaX9ADJUXC2EUn1C6YQ35k3PvbfylinXSUkxnqH5vsJ3hhIhwFUBdeAS3oXRdANNYP6CKD910F61EOtZgkm5UzbUBBbBpkJkXJ3DLd74H9tCQ46/AVda4IQP17PJCC2AueIElqQLFxfaOpb347zMr4UpETT3S4bJZk3nJxz1KRaTulklTe7I810UE9nduUiWEQwMAOdYLcHyjD8qhl9jZSvWOvg3F4BHgXayyR0CloSIq8dW+tf41WcdRLFrd/6KVLXp4m2TvjQviBG7HroPeOcoGSkCAW8B7YMh/Wu4BiVuAd3fC6b8W+5LXT/KQpLBnJhd8bGc9f+hR7MSp5DEK4ZduSyDKcSabiNZG0l6yu/Cipf02IdWPrTpjvJHV/UbnOU9Ks8/YdF3TTkWI34KEh1dqcGnsaZEgJ8sMJHi4F6U7nCIv2LrQg02Kvu8SEeS58I0GwzF+0RB21PI
 AqjvjeDF
 cwM+LkW39LsMdlW2wrrSniCR3fHPLHi7f28Cf82pwIpQnmDOvd5HTeDCU4XrYDiQvgVHFGcRZMbp/cvhr1U/kPW2vOPFMXlWH4X1TfDB5CxWho5vxSAvwZKKx1XqlPI1jkh2KfXHqsziiN2LcLnUNzv8O8U8STzGBXiGeG8TxZyGYH8b+FtgXiwo3KTg8Bvpx+RD6vngUOHEoznNkJJxtuJQ3yxeJvpXH6UnA41Ql9s1Lfxe8+Rkniw3ZWDD1ghkUXuNHrIkYQj5IAY9WwAR796wJA/hpOHSbLzmai1vbPRjphTjnPjwK0TAQ6iU4V9bra/ehTwwGuZAuPKx/+VK9fhJzS22fS0fARWfcp+eD6GpIZn7MRlosklgMsbaUPwFIwYg48+dn4biL29xrWFer5gpTgyVY3AIRPMrcyIvwU/P59gJI0bR2M8rZJlDwLl9FyPf28UXyGPoQzFhGpK0EZRTLEsN/+DsyjfYpTJIeZbzQzMrGhrIsFJJb+y/CqtzPu8xGU8/GYQF4l5XsjzzIJw3bqmp1b/oiPbxVyIIDfNFc/WjLksISqrq75IJqmF50fpxROz9UhuANmjKYN6BTL+TXer71n7m4jn+b+aWbHzvWMtWGftBGf9HDrNALIRvyCjWM3JdTRGo0WZshDuL1cUn5xFNzqSndDhbsA1Qwv57mzRLZcfY9Xkn93mg74MsUG4/GulLmQNVlPMjeQsQaP2fILhkyRvkAmR2qOTfNll8vHRiFxriOcFtBBYKnAxfMreX9WvywlC1Q4osz/9GU81PVooFKm7RZfWrJXnuMaekUbzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 04:35:31PM +0800, Jiahao Xu wrote:
>memfd_pin_folios() accepts only shmem and file-hugetlb files and enforces
>that inline with shmem_file() and is_file_hugepages().  A caller that has
>to know up front whether a file may be handed to memfd_pin_folios()
>cannot use those predicates: since d3710111839d ("mm/shmem: make
>shmem_file() check the file's inode") shmem_file() is an out-of-line
>function in mm/shmem.c which is not exported, so modules cannot call it,
>and is_file_hugepages() on its own is not the same question.
>
>Provide the check as an exported helper next to memfd_pin_folios() and
>use it inside memfd_pin_folios() itself, so that a single place decides
>which files may be pinned.
>
>Signed-off-by: Jiahao Xu <xujiahao@cmss.chinamobile.com>
>---
>v2:
> - Rename memfd_pin_folios_supported() to file_is_memfd_compatible(),
>   suggested by David Hildenbrand: the predicate asks about the file, not
>   about the memfd interface.
>v1: https://lore.kernel.org/all/20261119104417.312237-1-xujiahao@cmss.chinamobile.com/
>---
> include/linux/mm.h |  1 +
> mm/gup.c           | 23 ++++++++++++++++++++++-
> 2 files changed, 23 insertions(+), 1 deletion(-)
>
>diff --git a/include/linux/mm.h b/include/linux/mm.h
>index 040cff643..dffcc0b5a 100644
>--- a/include/linux/mm.h
>+++ b/include/linux/mm.h
>@@ -3600,6 +3600,7 @@ long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
> long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
> 		      struct folio **folios, unsigned int max_folios,
> 		      pgoff_t *offset);
>+bool file_is_memfd_compatible(struct file *file);
> int folio_add_pins(struct folio *folio, unsigned int pins);
>
> int get_user_pages_fast(unsigned long start, int nr_pages,
>diff --git a/mm/gup.c b/mm/gup.c
>index 7605da0e0..da8a2c29b 100644
>--- a/mm/gup.c
>+++ b/mm/gup.c
>@@ -3449,6 +3449,27 @@ long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
> }
> EXPORT_SYMBOL(pin_user_pages_unlocked);
>
>+/**
>+ * file_is_memfd_compatible() - check if a file may be used with
>+ *				memfd_pin_folios()
>+ * @file: the file to check
>+ *
>+ * memfd_pin_folios() only accepts files backed by shmem or by hugetlb.
>+ * This is wider than "is a memfd": every shmem file matches, not only the
>+ * unlinked ones memfd_create() produces, and file-hugetlb files are not
>+ * memfds at all.
>+ *
>+ * Callers that have to validate a file before pinning it, or before taking
>+ * a reference to it, can use this helper instead of duplicating the check.
>+ *
>+ * Return: true if @file may be passed to memfd_pin_folios().
>+ */
>+bool file_is_memfd_compatible(struct file *file)
>+{
>+	return shmem_file(file) || is_file_hugepages(file);
>+}
>+EXPORT_SYMBOL_GPL(file_is_memfd_compatible);
>+
> /**
>  * memfd_pin_folios() - pin folios associated with a memfd
>  * @memfd:      the memfd whose folios are to be pinned
>@@ -3493,7 +3514,7 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
> 	if (!memfd)
> 		return -EINVAL;
>
>-	if (!shmem_file(memfd) && !is_file_hugepages(memfd))
>+	if (!file_is_memfd_compatible(memfd))
> 		return -EINVAL;
>
> 	if (end >= i_size_read(file_inode(memfd)))
>-- 
>2.43.0
>
>
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

