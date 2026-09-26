Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE206C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 06:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037786B008A; Sat, 26 Sep 2026 02:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29B96B008C; Sat, 26 Sep 2026 02:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E19BD6B0093; Sat, 26 Sep 2026 02:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C733F6B008A
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 02:08:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B172140841
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:08:10 +0000 (UTC)
X-FDA: 85254883140.20.F6691E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7301840002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:08:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mnlznwik;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790402888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0e6tVO+MRkbZ8ZY9CxiKyu4lnjfzpRHKXdU6fEeSY7g=;
	b=lR7BZ77n4S+FRQTs7EUykIebXtzEv0yX2gejOvygF2OyOTOQQ7t/FJ5TxPNooj7MVCGYvH
	YxS+Ft46o/yUVmcqrviuqYumOHvmEiunSrqM/evVCPws5dvKw7ySalUTjvvGwyJYiE+OhZ
	riRVpE9iSotUad0udoAzotQAakgjKUs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mnlznwik;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790402888;
	b=Eumr/aDS6dJ1aABWQ5iAp6u9NmhTasd9spY/vAFhjkNGzDEQD36cs0HXGWStVjflXfuo8P
	FU4sGclCr/qtioZEOMJ9k/ixxkrpny1J8zMAXqhaUmsGHDUV9Whc6JbrWCrdgFodW3Vqwz
	NxEuJVUq7MTZfk1P2K5gKWHbBsMGoV0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8A96403E5;
	Sat, 26 Sep 2026 06:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6108B1F000FF;
	Sat, 26 Sep 2026 06:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790402886;
	bh=0e6tVO+MRkbZ8ZY9CxiKyu4lnjfzpRHKXdU6fEeSY7g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mnlznwikUN92d+Aeks2ykZCcs/fimoxLT4LyBBmI3/7pEWogkMVUmsdRMOqZhSu/D
	 I+hAknFAbcjkrymv3NgOpM+vVoHqYhWBnIC+9YU8i0C1SssnialK7d8kER5gRSL4TI
	 qu1MdFcMH3rgaySVPJ/5j3NrZmNp7UXcXDxoEMHk=
Date: Fri, 25 Sep 2026 23:08:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 mike.kravetz@oracle.com, yuzhao@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
Subject: Re: [PATCH v2 0/2] mm/hugetlb: fix surplus accounting and
 availability checks during demotion
Message-Id: <20260925230805.8e763371bf9c6a54fa02fc28@linux-foundation.org>
In-Reply-To: <20260831133519.2505020-1-xialonglong2025@163.com>
References: <20260831133519.2505020-1-xialonglong2025@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: zgj7jgbc7xfsn4cb7bjha5bdjx48zhas
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7301840002
X-HE-Tag: 1790402888-368638
X-HE-Meta: U2FsdGVkX19wg81VEnhM66qljSG2RQ6xZzZwcH8JVzpR83teUwAdz8J/aNdvliM7VNU4Ld77O2NAGcG/a9yaSTVeAG+ckZXCrSX0azpJnw/I/S2Y9UhvhxqqLbiAGzZ8gbnizk6iVod6p3B2xHaJxbYrKeXlcXx+SzYVuPEZ6/Y3THWQfTjCnm8pZ0OxNpdkI+w5dzeyYwx5kklL8CHkE9dE6UlO3mAKYZ28vOugvJ8cwzhU8vl7pJHeW8jh49Ugg2/QpOtOQNg5R8z5FUj0lh1jjLSt2kwSxBP+gJvvWta67gUlwbtIztwSG7x+AjC+sMWnfviQJeGuIGB5TRsxB3ksLxBul1Ku45zeRKyLF5kfonzcYsAsheTIfR7UnFmTtk8AGW7TFjOEa8t292TIePTeDjTG1Z9xcRTm8Bru1Gzn0nCPbLDhQZSz35NACx4oBL9MGs2UteuQ+KV0+mjZK8SmzYVufA3DIRHcFJcKDkJG5vrsVn8S3Z7F1xTDe7Hprth9PidEKAr/CJXZb7/+cNJnFYQe/9WGhRp/YNgjfgcxYD51sFVuDQNdTKSyTp/5QWCvkQ5cn57GFrvze/kKqmDa/3TinWH1Te2uUM5/9TEal4LpAs7G7pBnW8o1nWlZEYcSNQ70CqIwo1VkuCKUhghHwDcTV2/HTUuzFAodQv8TJX5OqcEJIRMgbU02cZtTN1YaCpL67NWyzMkXW2Ygu4AXQoRnrqphu9gSynbFTR/69y/P/QFTIN8iEHjQZ5HHO2hqjntbCvquLMif/y4Jh5UGu380eZLQ7HIUmakT/iFPxsAkq0zeQ/fQb8CVuLbmwDVGiCOeVRxVL+J7loF/S3biLodMDVSJIAqRUjF7XXPkgsu7QiZ7zEVHc19cLZz0fhR7qMzq+/rG2xS7o9iiPOABLR4VdXww0KGUK+/IYXpgYOiB9sDXuGyC/Pc6yri7FiHAXZlqHt9Is/qcGaP
 qunkh+7t
 mNF/MbBuuttky6FgoMPY3JkY62lbZnszeipAPvDCJmmfQtScpm5ir4oiF1bxeDuisLyAaqZ8/nVHEP02abg0md+C58LoUIcan6TjzfrWDBYBalk4OGB9b0zGxkTNWdTYW1/SPbCKV38WlYZS0D0yBf8ovIU+XIeRZ5AD8v0TXtpxcyrO/LGfqOc2asNHqGsFE3smsZbsnAPzb6fqDEICar2FNgjuCsY9lhEC/Y6CwkHGqAPeqIRI3uLUX8e1RiPWvvLpxcqg6ZlNs6kEc7S5OXmA07prct86LE+F831/ZiMOHHCjInn+j7x+BMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 21:35:17 +0800 Longlong Xia <xialonglong2025@163.com> wrote:

> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> This is v2 of the two-patch series fixing surplus accounting and
> availability checks in the hugetlb demote path.
> 

Could we please get some review of these two fixes?

Thanks.


