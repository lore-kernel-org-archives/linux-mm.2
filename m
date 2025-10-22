Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E7ACCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 822A78E000D; Wed, 22 Oct 2025 16:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2F58E0003; Wed, 22 Oct 2025 16:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1E88E000D; Wed, 22 Oct 2025 16:13:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59D2F8E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:13:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB0A513BF37
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:13:14 +0000 (UTC)
X-FDA: 84026849508.14.D52EAC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2952E40013
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:13:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mG1PfqRt;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761163993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxePB9i0jLDo9Q1fh5oDc8++po+nTYGNO9aZzoahoFc=;
	b=JKr9xsdcX7VjjHw5nH8lrq56E3M3XNT+rGD0l3wGJoBlhhaQWwLlqbOSLbVua2dfv5ETgh
	H4zeQLfEvdoUagTaNAHdVz/Lc1+7GevbPBv7N1UDqDFKZBHPN1PuLQ6HcJWLDwJU/OQKsM
	fKRXFTFzp2r0YT7F/hNcbvuBR55W2tA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mG1PfqRt;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761163993; a=rsa-sha256;
	cv=none;
	b=0JqRxYnEyd2p5fvRHPlrVARbPKbjhmZ75WOEFN93jds7rybDx7Bxczst6q+eknpag6XABF
	J2XTnfM4bGcqFLGAbaWASx9qGIXEkRkc6Kt7qC0Fgx4Ec9Fk0EtCExCBc/gBoEYYAmOdRh
	IW6n8no8SeBo88w5YvVhvfeHyAvYOmE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 402D3605A4;
	Wed, 22 Oct 2025 20:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206ADC4CEE7;
	Wed, 22 Oct 2025 20:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761163991;
	bh=CxePB9i0jLDo9Q1fh5oDc8++po+nTYGNO9aZzoahoFc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mG1PfqRt0ojegvhfHKA7qey5BJLEG3JKbI3DOCCJpkkQJgdeRsStBWej+dtuAJvfV
	 qZ0SCeMgJEfW/2LUOKPywokhagNy7ZYNCrUdDxz+RX++JyuEL0yWANpmP03Gmdn3Xg
	 gj7fOmq/TYsoymKBVx0U1Zsr5iKE31CGNV97hztY=
Date: Wed, 22 Oct 2025 13:13:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 00/15] khugepaged: mTHP support
Message-Id: <20251022131309.c70a2db410d7e82fbadb3d60@linux-foundation.org>
In-Reply-To: <20251022183717.70829-1-npache@redhat.com>
References: <20251022183717.70829-1-npache@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2952E40013
X-Rspamd-Server: rspam03
X-Stat-Signature: rucdguxhrx8xmwybi5apnidatyjixbbz
X-HE-Tag: 1761163993-91566
X-HE-Meta: U2FsdGVkX1+St2iKMp73VoItj7G5t+e1GJhk4KLwYaFNBWEhAsONSj1sF2eVEnhUQeADhQL5c3LSslIwQvEO1eMWo780Q0QEaUhy9lP5pyAit6XbhAj2s+u6LaD9HpsaOfCZgGEnVHS2sfmN+VJYVdip5U1VCM/jPPpR14oQi5aWsOd/VYT4Ixr2qDcIE5sne250qF/DBhIxkNK/QeE2mKTA9Yc4bE8J/JSYbCRStqN7C6uUknbdXd0g05BVgoWSXaTLHsTE4DVTyJvGnnQ739ZIY7jMASLnGJ59ZOeRl2SGTUW23pfED/J9YXkrbAGIlTdUYoNvI4msUqTYHp0AM+7njAOBxy3DCjQHwsEdaUHnx7c/c0bmnyd7SDOi5SdbcviowN6IcnjmnXaD2Yje7VL3n2+f80mHPyfyd0hP+p9b1e9I4rEUCudPXg/bv26XZAOyRQdJruFfa0s5WBCCXyXXmcXPK9LWDf4FZKVY411qNyFI0lPKn1QaamWFNlKpayIj+vxcu/V1DevWiIYYQy2Z7Wypn+Du+aA2gDqlp0TIKVdyXlTp2tVymF1rpA5B2tH+vQ/pn1SS4pCY6B8xPEOJi1tX47Pg9esGZMU2QhBlg0zTpDYsaAEJ8chSA4825uSfogtSMt69mYKuYomEOCqonmyCsoEtRxNLI+LjZHldwNs1PykqaarFJwaApXkB7hj7NuiOxEJUmA5d046E7qYV/JZgy6dcckyJKdjP/rNQvSzziEPZ8byBm6+RYRqgKtSEIMathn2oXnb1LR2oM3zzNxRjmFk1+TXrozQjdfUX2KO21FZRHzWk1FF+11cBZKWfXELUe8/j1H6fhqmvYs5UbKJNYcy1ZwzJ/56H5XzKK159Re1ID2a35VJLMRE+SbSeSQTpnslxNLsYaBU87Y3mHpWtzkaM81pzp/J3sMecHephTyfyOcjH2nkdjcmIWTm3MPrFQ6uHP8NtJk3
 tE32eqnI
 of1V5YC5oo4HcG4xmTUe5Zr/tOSR8PBfr/NP3Uel7qo7Gr3eT6/8TUgK6gRioQ1+rJdqRjghnKor5rl0BVfd3j+rHBH9v+gP6CFO4yOR09y8xp2231Cn2/g/T3SB5vTS5Zy70OPLyM4k7xzYuVkOL1VnRv8SMBssoUwzLvJbQ9H2WnxCCO4e4PMM3oiEQCpqfeGezDBxsum0I96Zbu9FuevUtw1r/P7sbhf2NLVb2dbLykG17UESncPFOg/OVv945RRpk1kDYlZMfYfj3h8JZSS7gx9L5Lmz/oVIV2kvFAbBnb1sePWVONQIGnSzV6L/BSdgBVQfp8H2hNx7WDHm7GqTJF+GYRH8TzB+lA/UJiAfKtPBEBBNiUL1uTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025 12:37:02 -0600 Nico Pache <npache@redhat.com> wrote:

> The following series provides khugepaged with the capability to collapse
> anonymous memory regions to mTHPs.

I added this to mm.git's mm-new branch, thanks.

I suppressed the 500 added-to-mm emails.

