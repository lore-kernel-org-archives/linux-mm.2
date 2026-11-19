Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3195A606AF15
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=SckUuL3t
Received: by kanga.kvack.org (Postfix)
	id DDB456B05CB; Thu, 19 Nov 2026 03:40:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8BD06B05CC; Thu, 19 Nov 2026 03:40:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8866B05CD; Thu, 19 Nov 2026 03:40:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE8436B05CB
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:40:42 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38DB4A09D8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:40:42 +0000 (UTC)
X-FDA: 85451222724.08.718BBB1
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9A3E7C0003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:40:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=SckUuL3t;
	spf=pass (imf28.hostedemail.com: domain of xujiahao@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=xujiahao@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795077640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D16q10jNQz3j41y6OLUFp2rQtz+cs22n6LUDewWC+pU=;
	b=Sw7oAt1ET4Ucmo73KJhkLzKKJGBBs2ePlO666aoyPmxEX02TaKbnwX6MHMQwqHbOTeCyQ9
	CZXXt5Vq9V0xiBpcoxna7FYWe893jJda1Hn4CiB8iySj38MaOzXvcJ1eDMU5nUi9sXPzWJ
	2sFIUa93EiedwP5BETZQCg074F9V4ps=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=SckUuL3t;
	spf=pass (imf28.hostedemail.com: domain of xujiahao@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=xujiahao@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795077640;
	b=Xeybl1MXDexTPfQBGTzcozkkFWMFXxLmMe5qsRLYJpTrPbfXjH0sO3Rc1sFXGPD4BN0E4S
	V1YvwNjXzHZ5vyhnslt2Ks1NwuI7j04NPKjLoqZANEc15yPBv8HUyVhVgfWSyJPb4030gm
	5ccLDu/kqkQeMLwwdTO4LBLO82Qveo8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=SckUuL3tKGCRPUlDAH3wEBmIfDOUaValrh2REAngflboGe0eUgxrs0llPFZpwaRSSqrsEhphl0jte
	 PlhKh/bL5qIhnkZhz3J9s9bAgkycIVqT0FSDfoI8l95XiRb1BMqgQrMNqCYAI/ACWv8jPVjzeUseFq
	 sNfpl/pVE9UFdRuo=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee16afeb600797-f82cc;
	Thu, 19 Nov 2026 16:40:34 +0800 (CST)
X-RM-TRANSID:2ee16afeb600797-f82cc
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from [25.255.2.225] (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee86afeb600b5e-5f3a7;
	Thu, 19 Nov 2026 16:40:34 +0800 (CST)
X-RM-TRANSID:2ee86afeb600b5e-5f3a7
From: Jiahao Xu <xujiahao@cmss.chinamobile.com>
To: David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
	Jiahao Xu <xujiahao@cmss.chinamobile.com>
Subject: Re: [PATCH 1/2] mm/gup: add memfd_pin_folios_supported() helper
Date: Thu, 19 Nov 2026 16:35:33 +0800
Message-ID: <20261119163533.523210-1-xujiahao@cmss.chinamobile.com>
In-Reply-To: <8f2a0f78-6f76-4a5e-a6c9-b36638addc78@kernel.org>
References: <20261119104417.312237-1-xujiahao@cmss.chinamobile.com> <8f2a0f78-6f76-4a5e-a6c9-b36638addc78@kernel.org> <8f2a0f78-6f76-4a5e-a6c9-b36638addc78@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: epefu48ztpnu7w4fxmty9qkeys9qia4u
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9A3E7C0003
X-HE-Tag: 1795077637-27795
X-HE-Meta: U2FsdGVkX19x0HdZykxYUajMLdsv2KPYUGTHofKXgCAqR02zGBX7JnX+tTUaVMuqxPIxYb/mEDd+5DkZxEVCohldArESKrzxFAiYYNMkST7rLRRVyYJvlp4te25mHlr9UVgF7ULf3kRdjwXt+MqUpW1bUOdOYLN1JADxnDWWYYIm9QIf75VMeA8Mc20spuhp0ZRn2PqszKmO8aCdzlu6h6Ew0cpqJkomxLlEaG1hmyswARthjIVPFphFadlN79t0uAy4kBrnyCE/DIOJFKKV2Kpui2wFnQe9DPZiRSV7UCpXTTwUYDDlpd/qhkNat76x+gzZ0lfbgQGPEq2y+Usa8mxftlVH1zNhIfFdqZhtWRysJABFSXaP+XeebodipsBEHgqiNh1JRPn6EM53n8Meh2rpbvOmb8tkvj7c2VXFlOKMCU/Zn3Z1TFp370U/t+v0dhuG1R3EsXJ3Cn3NuFzWKOyFMHt+5nv33AHCMz7z3xRyv2jGMMMkVWP78NgW2qOHNYLz7bHIrNWJ0j0nK86cGpzjN+4j0mprtBrd3OYCfkmPfUe1eFXbyq9clh/ADEkyMrY/QaIfMrDsDK6TImZrQDQXaYq3EWTKLxHy3eNYM7Yw8r8s/ohqYdY83HDXpeMC0z7KxE6hTG3gxbDUs4lGUZIr22VpDUATSSRkFxEUzK7+Ztg58JvHR7f3kyoif87sSmER0vG+bZBsE38eKtflRXK+GARc7duxUxLMUFx2lqcl0a4lKB+9d3NawExZW8Y6CNJiwwObCqc4UPqX3v/diSWlpJLmFqh1wlhJHTewKoVTRy1yHh+r9o8kC+VCWM2ewhCDGegWNzziT+vAGmZiiEoQNMDCrDdldkmJIrFnVH/cGkmoOWQwascIWM2woXWIQvhexUW8qeUY8SRNu8ZZvBJij4qsXbnNZZMdtQgOgdVZKiv8IE2ZuCTmB8J7Oj3ySmyVRsVl7xWKJ94Ns7S
 oY2wmML6
 rNdtB7mcEqE8SbDqlMX/7qsNCvORbu/Y295gAFeCPAfoFThTlHFiurOm9Yqxkv+CxA61rMAEwMiYCwn3Qykc4gtcGVUju/rZY4dYMh+iKO05/qY/2MYc2dp4Ln7ftZ6v988CNBZJBXXB0PYrE9wfrgs/qumiUeLDMAEovs9zNNbLLz35fKAzUE8BVi8iKM0tfhC/xFSEaz842r1BE39MLdzdhFMw/L7Vvx3d5NSjiVeqBGfjtBE9ucNps309+Vmbwv69eDOzU+ZImBZp0iF2s/HeaHvk/34/Dk2gG3PWLVnq9oFjykd8Br8ZuDgxZfI6138Soosn7jUvC5pdYlMX3cuUv4Gqxu+fZAxXRo+VU21YwYPUeFCtmlw4lwH9wTQdn+ANPmBnFbd0ol20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 08:48, David Hildenbrand (Arm) wrote:
> It's odd that you would be asking an interface specific for "memfd" whether some
> random file would be supported. It's in the name: memfd.
[...]
> file_is_memfd_compatible ?
>
> Maybe there are better suggestions.

Adopted as file_is_memfd_compatible(), and I have no better suggestion:
the helper is handed a struct file, so the file should be the subject of
the question.

You are also right that "compatible" is the accurate word rather than
"is_memfd": shmem_file() matches every shmem file, not only the unlinked
ones memfd_create() produces, and file-hugetlb files are not memfds at
all.  I wrote that distinction into the kdoc so the next reader does not
have to rediscover it.

Both patches were resent as v2 with that name:

  <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>  [PATCH v2 1/2] mm/gup: add file_is_memfd_compatible() helper
  <20261119163531.315791-1-xujiahao@cmss.chinamobile.com>  [PATCH v2 2/2] iommufd: only hold references to files memfd_pin_folios() can pin

Thanks,
Jiahao



