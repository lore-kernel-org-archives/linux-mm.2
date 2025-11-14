Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12D30CE8D60
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6688E001D; Fri, 14 Nov 2025 12:28:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ACE08E0010; Fri, 14 Nov 2025 12:28:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595868E001D; Fri, 14 Nov 2025 12:28:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4421A8E0010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:28:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F16E2B976C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:28:02 +0000 (UTC)
X-FDA: 84109895604.24.E5FE766
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5FC31C000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:28:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dn0ywYFX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763141281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jI5hPOPLIoKkXUKVIROmgZN8YwXJuNfqNLlBqLlPxr8=;
	b=jLMl7kq0I58tf1GovBC6Qjf7dUAILsEcEUw1qYDTE5AZTy5t5wsBGBR3vfk8ClSGzTjvp4
	tSAuXwDyywHPOUZyOiEyAoW8WjQ3T/dw3LL8KNLyT4BA0crfoc6vJT7EZadrJBh2asdnLa
	fqOSpDV1U4u0x8c3D3m2rNPBBwtfbtQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763141281; a=rsa-sha256;
	cv=none;
	b=1QgvIv1CaD6pEK91Y5lRlDYhTwZQG4wYU+nt6yi5wEm7SWGNBKX0MyHi0mjsO1/jwKyOi4
	3Q7eKzBNGStEuBEcepst4PTaByPjsSOXDSxU/cwZjXfJZsvMEu9p1nIjldvBbdrB3vyEKO
	KqNjSOLLIFD8aMdC0NhTIQQpWfJbkRg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dn0ywYFX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C367B601E4;
	Fri, 14 Nov 2025 17:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87609C4CEF1;
	Fri, 14 Nov 2025 17:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763141280;
	bh=ulTWAOAR8z9do9SIRmHIYkiPa4c1m881M13St87xoQA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=dn0ywYFX7u1pMRmBB6mt3qOI+RoqX+gUyW3hryzuEn23rmHGfuVLx34qn3gdb7I7H
	 sN+fIgiXgJzEL+gSz1mj0HFq7lITtHxpI+gru7gqIffawp8FYnhfrNEFVhx0Lin4wB
	 eSbKoeJGcCs3KiiT0WR18L/2xpurvlBBH4UL6IYLGIpdUXqSFN+zw75W6qftHLAM58
	 O7XfUeBAQ5Twwq1DGqjDqssc8MacW9QvEKVbhiEvGXv2Mg8tAAG8XFsl0RJzOuDNMm
	 sNEbe+OBiF4o72N5YbKBfYVEXjLYJK+UCR3yqYg4wmcVJCChemVNnocLYFm0BKFqha
	 GbFfyXYii0QeA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v1 09/13] kho: Update FDT dynamically for subtree
 addition/removal
In-Reply-To: <20251114155358.2884014-10-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 10:53:54 -0500")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-10-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 18:27:57 +0100
Message-ID: <mafs08qg87cde.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: cdibcxaegeousegdex3at4apg94znmg4
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FC31C000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1763141281-334708
X-HE-Meta: U2FsdGVkX1+voETEgZEONrP0NMB3vpL5yxdavCRB3UNLyur7tsUHyTArQFecXuNzrpjlMRZ40tarE39v9uUio/oX05H14Z7fiNY+ICWkCvvX+dq2RNm1XxrvGjvGxh8c5/n3xqZXnHXwczBkGw+//o+uDDXfiVEnyVyB1AZ3R/22IHvXgN7QDad6NAG6VxGIKdxj6Pf/3UQxU+dogu6sEBRlBrn8sHfFbj+gqAuSZve4sE8XX1zSDCY4ZEtMIkL6l3NKLbcx1RnS3BXq+dHUADHFjrVZ45pjbhvtkBwpM68uRzagRbBU7AFlGtf9cDpWx8QgLK1m1t+SidY7A1h7VG1O+YsmCzcSSPdwVnq7FvOM6wXFXrDBIyrWduMRYKAOfeIaIjVGbJyEpSiicKigD813yeTp37noiostGUmSWZg9EAxxwWS17IYLpjmBAc/XWVVMWWzwF72Kz6OvO+TstPF4BCKMrZlWXZz/hLXSGabTGkj9y473tgjHzAVpR4wVBUY86B/dx7O5oEhpJps3SogQGGptvHMEuuJ3IX0VsgaPaVj/MC4n+gWNaFVEwQtQAo0oYsAATmjr6syXQEdAsAmPzneHc/fzviRyA5HMU/dzONBrLrn4nH2p1Hr6h9Ds3AuDmtqtEddp5FaFeFXJ1Iqjgh5wO090oLkRUaBFEIPS/rbCipWqXfDbCSN3mmv6moOAyMBp9Trx7q7F0C/Rkv4Mlc+T8G4ty0NdpRJO/juA9nXkjFlajnBisDqQ96W/jQ71LtP8bqQFAPTq/CEKytAx/J6pcJZU3v9nD9oxa5/ouVlyiEmcan8kzjPjFkcYSTT6pdUnJlXCsZlhDavPABoQKlVifXsGri6rz5/SjUdrg4uiqWMfhjpKh3j2DE93r2iyNkn4zZQlrcvrzeVcEXCbU8fpyVmgRQnH6woeHBGQur/W8YV2Fi9uH+CmaSmBmN+eQGS8ck9eWffTM0U
 0G2if4d9
 YnEvgi//UGHrkyC4RjKiuAWAIO9u7zjarrW5NnFkeqyE9ED4/9Z/KmJrLn/MiG5p2ds9C3iCIi4RH8/QZiqV6G0CBTo5Kw1Fycdw/r+DddILTSsJD2ynaLaovVX/Huu3UyG+AQdfHMbg+6EX+N45E4HjQzDbz2VizEc6aHIa/e+HjAzV+CLbuusiwZPoFNmwUnSpU5GfRvuuyWztYwWgaVO6WxZROnSCi188MK7CEH50EbJdBYfEJu2nuypMlSlaT+67j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> Currently, sub-FDTs were tracked in a list (kho_out.sub_fdts) and the
> final FDT is constructed entirely from scratch during kho_finalize().
>
> We can maintain the FDT dynamically:
> 1. Initialize a valid, empty FDT in kho_init().
> 2. Use fdt_add_subnode and fdt_setprop in kho_add_subtree to
>    update the FDT immediately when a subsystem registers.
> 3. Use fdt_del_node in kho_remove_subtree to remove entries.
>
> This removes the need for the intermediate sub_fdts list and the
> reconstruction logic in kho_finalize(). kho_finalize() now
> only needs to trigger memory map serialization.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

