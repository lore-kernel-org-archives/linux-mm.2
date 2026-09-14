Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18DA6C88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:43:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19A766B0088; Sun, 13 Sep 2026 22:43:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125B06B008C; Sun, 13 Sep 2026 22:43:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0130B6B0093; Sun, 13 Sep 2026 22:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CCB426B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:43:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BFF3C0D62
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:43:31 +0000 (UTC)
X-FDA: 85210821822.05.B1EF328
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 530F640005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:43:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mZGrVUx3;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789353809;
	b=S6tAJn7SH+nYmKLFnDa0MFBWsGzZgVHnOK75ergF/EVVhdbJeqLs9E/0nJf49vV7+hVmLD
	8dKtE2W2NibxcvhvEDWSTlrblc7QNyFmRVSx4jKCBBG1BnjeseKvp+M8HXQ9z7KUhsSVlR
	Dpw/R5B4VCx2Xc/Ujd8OKkbnJaOSDRU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mZGrVUx3;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789353809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GPlyuX4J8yVFynRki86eS8wk2g+3emdQ6rxuxVS462s=;
	b=ZqnijPLPkgMMjJt4AEccf7Z00vuZ24MXCPkVt0BwrUdVyAzxjv+cDxM2SbRicgT+dvp2x4
	JN0olRavlaIOEG8HKRanIve3ms3tVdv+PaDgVTOy5ujjOVbnPQfww5K7dYbbo8YdkJXnCu
	b5MdyHF7CewVagNUDksWZyW3GtPiqgA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 937A46109E;
	Mon, 14 Sep 2026 02:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CCA1F000FF;
	Mon, 14 Sep 2026 02:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789353808;
	bh=GPlyuX4J8yVFynRki86eS8wk2g+3emdQ6rxuxVS462s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mZGrVUx3DEBnxNLMA2Y+MW04SIp2tP/blTyUA/uLcUt4gRgO2HXiwHIwtT7CAV1wd
	 JcNAjtANaSLbKoycdA2J/acacoXg0TXN8MxrqEgjdbq86A+KsrIW3YxOgJUxADMdXz
	 08Ssf3Vulb9ZpmV5GeHKclrnsPhxNGuiSs8Qqr6A=
Date: Sun, 13 Sep 2026 19:43:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: hughd@google.com, david@kernel.org, ziy@nvidia.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: shmem: ignore sysfs configs for shmem forced
 collapse
Message-Id: <20260913194327.019b3db96ea9b0719fc147f7@linux-foundation.org>
In-Reply-To: <063f655b4d6c4234f3aa27ed6ecab10283ecb880.1789351825.git.baolin.wang@linux.alibaba.com>
References: <063f655b4d6c4234f3aa27ed6ecab10283ecb880.1789351825.git.baolin.wang@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 530F640005
X-Stat-Signature: qijudubizsj51bor49h3q4zqrtsn9qjc
X-HE-Tag: 1789353809-321696
X-HE-Meta: U2FsdGVkX18kbUoISu7sR//1KNBlrXKlyDBveQjem6/04VsXmnmcVKV7Ht+TiqucM4ka0cj+CY9cLVaDYCwd1sm8+K7h2ee5QR9SLsFi0kiUU9Z/Hou1aSftGV+b8ToJu0YqVOkqh3i0/Q9eqv/tSG+4JdnHTShZDJ6Fux953wxLJY4PsItU4Evkgzws/DJgxJTdXUaqHhsGF/hf68C3RnMRWIUz2Jqk6tBIsptWU9F6fXOgRxRmrlMisBFT2mrcU+P0WRUleRuRD0MRWvAMyylZfdJvoLu0wWQckCUzB2gl3iiEDGCvEO4JMz/5IdhXv57SDLPRGwe7JrrUYj8kzTjfrbP2ZVbGgnGCOTnQOPxkpE3zjht+8Sbn7IIvZscbOHWt9AutDV9Ebe77RlzyHfJIGny5avfy+hMnWckMN9Y2uexGi2o9ORBMxmwEXeyveaQ5Rs1ecdFEchqS4y/Dq5AhvrzYcXmPdeUMf+2lE9rXHkEiNGP1p/L+5c9YA/jVgDWLSXUFbwpvwLl6eXo4s27Cu5Cmf2yZ6z+QHzrw8n1+NBae8a9Q69G6JPYZ3cdHpXVQGKJ77k3PSZrbdWdUiN/v+ubJnZze8LxSLraNL0CIQmd517Lc6tz6t8PINHdUQ+SM9+7/xuFRnr/FoxnKSxm1JiJtAZcpwwWcoHHJD0suHWsXCo8q+IQPSbMwDWje16qpmZAvigONz079i8TKJLJdxrYM18a/KmgiOpaHZfUMuDFYaWyAdK8o6eErdHQsbOMChYS8tdtTAd/6AOcTUHAAqPXNkPLVf7w9x/a5Z1yyxtk5V/X2PwdJBPACFFLiYo2fhkmJbjs8uDV4AZwRlJqJqTFBPiakUfLPvn+SqPcSyX58fOFnFyY24YikG8kDHc54u98RbcLgm19k3UeipWMijCH/jRnM56xrS8JAZeIlmwH81V3qTLuCN3gA65EdKxIN3v7rQGWMk5CnAYT
 YJVZL5hh
 mKFjoW18MWV6NSvpCKxrbewoxYs0qQVxdp+7V7wrEvNCkks8gDUs+7FD0YNN22Uxoaqt4KdPfJ3aPm8IXGppb3RJbJ3KeUFx3wxdY7zEHwb792jemWBF3ojtQK5xbUw9av5T1zp9g8m78uOR7PMz+I+Y/CyLkDc9tjSHDYT5FM8Jv4MJRHxlM+36NI0bGQzijxxYi2Hne4knjW28ttM1VunjTsiV7lsHi7kgu5Id71Ug7mHazun8gD8oNXHa2cPlytVS/H2lm4+AJ6bNVtx8Xe+doPsAxwy4lymZn8GtGtOtvyZk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 10:12:41 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:

> According to Documentation/mm/transhuge.rst, MADV_COLLAPSE is expected to
> ignore any THP or mTHP interface settings.
> 
> However, after commit 26c7d8413aaf ("mm: thp: support "THPeligible" semantics
> for mTHP with anonymous shmem"), performing MADV_COLLAPSE on shmem will
> depend on /sys/.../hugepages-2048kB/shmem_enabled being set to "inherit"
> (although that is the default), which can cause MADV_COLLAPSE to fail
> unexpectedly.

Userspace-visible runtime regression?

> Fix this by returning the result of shmem_huge_global_enabled() directly
> when MADV_COLLAPSE is requested, allowing PMD-order collapse while ignoring
> shmem THP/mTHP settings.
> 
> Fixes: 26c7d8413aaf ("mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem")

Should we backport?



