Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30BF6CCD1BF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 23:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512398E001A; Thu, 23 Oct 2025 19:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3038E0002; Thu, 23 Oct 2025 19:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B1948E001A; Thu, 23 Oct 2025 19:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2666B8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 19:41:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8BD9140C64
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 23:41:03 +0000 (UTC)
X-FDA: 84031002006.06.8C60054
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf15.hostedemail.com (Postfix) with ESMTP id 14CF3A0008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 23:41:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=sEDgh8vq;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf15.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761262862; a=rsa-sha256;
	cv=none;
	b=4WRBw52xkburC43OzUN+zOxr4ogegEnDxvzuwFWT0hlE5ia70iFq7xS9swQJQW0RsLl4ll
	ovP0gKC9QcC40NqrnQDgC/+0ZSb0kmtfg3pBVlCR/61Nj4nwWO9FUB7Nsmvo9EC8efcD8j
	ErZ3DPesydurkyyrxHVEOXLDUHiS8Ug=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=sEDgh8vq;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf15.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761262862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Hmbcxity4PhshsOltHSzz/6Tb/BocULueIxa8Xvq1w=;
	b=b3lJHKLf3pj1iSp+QJfdNS6KtjSXlYMJiGU+WnBpY1TVGGjINpGDtjlGRksNJDYbTAKHwd
	YDIg/ZtuOLRbBdeT4bCMKbV3epw3SubxUJ6/lMjH4Bialo67Oq73qvKaawuVCnX4QL2Dp/
	gpJGd7Kn6yvjMcdU7pRtv/cSJn6c7fo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1761262860;
	bh=bHtJ+x1Z8wZll9mybHd9TUEV+VSvk7XSn7Bmu6rbHyc=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=sEDgh8vqGcl0yQfyyQSbz07amGDY2v5s/u1969YpR6kU6DoVLSDtkEc7SV7o6XTp/
	 R9ls0rYnuL8Dg2FllgRtdRk7hiwHtX63TWMRzlqyOJzA/UCsRU6/jVMjWd0OhDHlRW
	 jMwPoC0e9AbPjSqOWGutu3+6ytt2zLfMnUY7GQok=
Received: by gentwo.org (Postfix, from userid 1003)
	id BB5A1401DF; Thu, 23 Oct 2025 16:41:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id B757E40190;
	Thu, 23 Oct 2025 16:41:00 -0700 (PDT)
Date: Thu, 23 Oct 2025 16:41:00 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: David Hildenbrand <david@redhat.com>
cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org, 
    linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
    linux-doc@vger.kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
    lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
    dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
    mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, 
    baohua@kernel.org, willy@infradead.org, peterx@redhat.com, 
    wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com, 
    vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com, 
    yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com, 
    raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com, 
    tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, 
    jglisse@google.com, surenb@google.com, zokeefe@google.com, 
    hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com, 
    rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com, 
    lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com, 
    pfalcato@suse.de, Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH v12 mm-new 15/15] Documentation: mm: update the admin
 guide for mTHP collapse
In-Reply-To: <ed0887eb-6124-44ab-9d1f-1e87e9640e14@redhat.com>
Message-ID: <507a683f-f121-c2d2-5dd6-7bb2db79152c@gentwo.org>
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-16-npache@redhat.com> <bba40f08-1b87-6b57-0e10-6e96e4d7bde6@gentwo.org> <ed0887eb-6124-44ab-9d1f-1e87e9640e14@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: xk4ngogbwccyzyu9dm7xaqrtckju3gq8
X-Rspamd-Queue-Id: 14CF3A0008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761262861-632143
X-HE-Meta: U2FsdGVkX19fc0sm9K6vuIH313e7F0GZNjvm0xOeDaYFASoOY/Z9o6QbnYD6/KNHVLx49rY6V3L5/WL2MbroydcmfUXsVpAYijvwDorGYs8ZaxN0MM3USne9gMxQY1i6QoO69LCwJ8PKhv2//VY/93RiTE5IO0I2ONg15Gs/9jWhCfYRVX3+hP/ethOGLFF1PTKfptDcA5uQOqvx8QmJRhH22yVPDLQHcVgl2pzSl+M7syy9pguLAgiCgeWsOyNzuTVXBzWBTqqkMB6j1b4lr2Q0y3K1kTOFvBIko5ea4ys2nC9SdcEdhGAcMDBegA65HmZV5FG0Ctjgd1WMbfZXxLARhw1w/gVjmFmtTtzEif4HMtAUyVfelSIoVJ9GwbFBuSweBWZfApxSB+tfp0Z7ZaQ3i4seBrrX9GPEpM/o7Euni5GV4i+SJ34JxadKBdM6fmBVSpBhqKbMdmdl3VNFCLJlwIYnkmwEMpTOqEd3twFLmeFov9fucSLqpYP4kui++jtD47swp8PBeRHKczb5rqG8KBx/ENowUZHi6QxJZJKj6FjVfpWSBMoRl9NedLXdTm73qQyOf/vTtQs1IKVFQ4xCXaZLsSm9181fDcvB3t7XUKojo1RmCI+MKr7ce8VU8Dt1nn6MSQyjayMDr/tddq9gmetcZWCH1Q9ycDhPhunxhTquCd4p+vtWyl3BZ1TB6BwlMtQBP+VjSRYeArfNfyetBWZ+PxuJd1YYXisUwTQvo9sSaf08NL2xuR2IB4hZ41Kb5W+d3FI3FOqxgFojOLvNZ96ozZlPk7Aei1JWJ9LhpPNK/pU+SImAtkoNUZw1dNJygAnvI6embpMR2fEoQiPIhW5/O1sQKlcuwxkfMNDiZ2urLvVfjdESTcJJXcS8KQREU8nJ7vHlMAdEh96pNB2yHib8to1tgf1YCfPYeXH2Nimqm0Uxdxkk3EtdjrFoz2LIzmzMldQbjZ4SA2F
 +dWj5pgm
 iig7UbCQgJtgoAb93RkBKbZMaFDMpDJvdjzsvmVzL9Q0Vm2sSvCb73rsvTic9Er4Z51dm8Nuu0YcUhTolxVDF1rNPfcTx/XIO3gErcaZEL78edRwjZ/+ZJlqvWRweT9V23DYAKm4qO2wasYt9Ed3KEIejAf6x/nn2/H4GN1VHvV0qUTwmNhS1oSYNJCFBzxBMhWqDxQYXqPpYja/la9as3bcBrLxdN9m1pOI+qfQc7sHhJ62nfeaSAtuqY5XIqglzh2jIPRQGvoVE4Q6Z29/Hg/B3hhVTBoIUD1T6yEG1fdjSHGTqqN3a4cE97iZxox8VXqUo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025, David Hildenbrand wrote:

> The big question is still how user space can communicate the desired order,
> and how we can not break existing users.
>
> So I guess there will definitely be some support to trigger collapse to mTHP
> in the future, the big question is through which interface. So it will happen
> after this series.

Well we have a possibility of a memory policy for each VMA and we can set
memory policies for arbitrary memory ranges as well as per process through
the existing APIs from user space.

Extending the memory policies by a parameter to allow setting a preferred
order would allow us to use this mechanisms.

Memory policies can already be used to control numa balancing and
migration. The ability to specify page sizes is similar I think.

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 8fbbe613611a..429117bbd2f4 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -31,6 +31,7 @@ enum {
 #define MPOL_F_STATIC_NODES	(1 << 15)
 #define MPOL_F_RELATIVE_NODES	(1 << 14)
 #define MPOL_F_NUMA_BALANCING	(1 << 13) /* Optimize with NUMA balancing if possible */
+#define MPOL_F_PAGE_ORDER	(1 << 12)

 /*
  * MPOL_MODE_FLAGS is the union of all possible optional mode flags passed to
@@ -56,6 +57,9 @@ enum {
 			 MPOL_MF_MOVE     | 	\
 			 MPOL_MF_MOVE_ALL)

+#define MPOL_MF_PAGE_ORDER (1<<5)	/* Set preferred page order */
+
+
 /*
  * Internal flags that share the struct mempolicy flags word with
  * "mode flags".  These flags are allocated from bit 0 up, as they

