Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22CA8C55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 16:18:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD436B008C; Thu, 30 Jul 2026 12:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE4B6B0092; Thu, 30 Jul 2026 12:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3F26B0093; Thu, 30 Jul 2026 12:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA0AD6B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:18:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D98E401F8
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:18:20 +0000 (UTC)
X-FDA: 85045950360.28.3EB0394
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf13.hostedemail.com (Postfix) with ESMTP id C6C1020016
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:18:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=H30XaJZQ;
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785428298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1Mc/92E8p+lO32h+qT72OZ7HfiwW0g4cTUB3qX11Fo=;
	b=rOKAVyOvoct6f9RaVX3Uw1QunO1HFpHT1l3jpAT+KhfvZxuykD8UL2++S42wRh2vp3CyE9
	L59hOM88lMuiiRLgu8dX+KRFxeMbZeJUGba/oqRLvsXWlpcqmQl+WYaulN0hnncZueHkiA
	j5IANRpf6siSzO4wQJerGxDGlDJBHVs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785428298;
	b=nc1pCl5H35MfyoKdLFn/QgT2RogVgL2027bwlrpJuMT1jnRjqHpPuilYsabXFv7uzjPdH8
	e5kFS7syTGJzCz9jytQvvvL9Z0ElNPywBlE5dj9f7Z3LzISQ9jonfWC+mGpchc0vW27ftY
	NMlzm1BZfZE6oagxFbUk65Jw+G4UbSs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=H30XaJZQ;
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w1Mc/92E8p+lO32h+qT72OZ7HfiwW0g4cTUB3qX11Fo=; b=H30XaJZQ7r7auy62y8eZtVmoVV
	G3l/41e0XdTegoohny+WA7lpvZpnLqqWgSSfj3UghOP2rLGuXgaSg+ZyfpuIRwgiktDQpjd+3saSp
	jp3hBS/EkFWKZMM+b7EempEwkf9zqNMhTW4hQU+6Baa8bJgwYrDLEZYX4gJCRbZ8GpS1dA7/dnuMx
	Epr/T7iZlu2URIwpixBO6Gm6IAjbRZdoId/JN8sOFhwmPGkpnOgq6kXOSH9kwwZQSxDLFvpg2Py6D
	ZnGtkfqjo7577UuywvqOr+ppHiYlH6oYRoll8Y8i3Df7bPv6jUn+fzRsJi+adm3g+jQ9bIMfh4mQv
	7+DCfA/Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wpTSQ-009MZJ-24;
	Thu, 30 Jul 2026 16:18:06 +0000
Date: Thu, 30 Jul 2026 09:18:00 -0700
From: Breno Leitao <leitao@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, rmikey@meta.com, riel@surriel.com, kernel-team@meta.com, 
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v2] kexec: keep the next kernel off hardware-poisoned
 pages
Message-ID: <amt4s9gKB7Dfpjjk@gmail.com>
References: <20260730-kexec_posioned-v2-1-f92d18551f64@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-kexec_posioned-v2-1-f92d18551f64@debian.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C6C1020016
X-Stat-Signature: t1oxop36nihj73s6hgx7ig9pbzoeco3i
X-HE-Tag: 1785428298-197552
X-HE-Meta: U2FsdGVkX1/IrK8Ymlixr0nbkJPsC1Qh9s6/OUaWNQXcnn+SexnOYzN9HJwThrNppZFO7psnVoiPRiqFsstG+3vM+rpE/i5r9ZbRkGG23i9Wkhf1zSP+tpRi1lFmkPK2eLHVJ1WsVFZ96ZLCg6DVYfSfFZ1BzMvh3ndAsf14qyEoqELi0F0Kv1PwB75L0WV7vmUXu2hNCMHnSSvJhlSjoWRU4cWLBtpYLxuTBOs4IpEF59j4/NDg+XLnWL93VK3ahY9IDV5UVatdXM2hQEAgiCRXADN9d3VPWFXe2LHUGq6beMxG3wXOLlMdarFDM8IFiGJXxdxPeHEXjpg9dgFYRbG8fogyC5lDSG1iP09smHcXuYLqbJuqS+9z4RXhbIzVPjtMaejiuRadb/ER6jVVfF4N7jfVLJsFMk8eKcvG4PVZDEVolhSCtbFwy7XW5Y5U0N8ezTsA1DlPLIZfxmHz8AweCvDp1//q2KwSclnsLrWX1hdx2ID6C0ebNU8kCqN5KjudKuk8rvXzH0prKecGSCuZHVltHM8HBb9/aSWSWzLWkU79VgkeCV1ysB2KSgLlxaKItLXrnr6VyGb4EBf/jkTHYIJSEfDNEvE8LMgJB+dDgxM+L24YymRg/sRYPndCYy8PDFCT1m8S/juo0SpkPXz+R+7LbHfr3xXPfd5NQ3V0e1ZLAkfocLkxfu0qJs1BddFpSK9yD91jNyTP3v4pcXPsufgIOq2jqBpJ5pDc1xkXSNovnpsgq4zjV3c5R00oUkKFPFP1P0QvTMLl18OIV8TGg5PbjkYHLpY0iqD9JxJfM3rrMH6lI55HhQI43DEQUaWjYrA9Ti7rFFVKNi7NGzxnsH9Qz1B8HCtMmPkmsm0tzhepIHPAmyT3MZyblw7Oik4HS2vZH27Nd3y5tmTpCnA/GyuG3Vz6Sy3jlwO7vu9hiXcXo4qhYnZ9xu/KAOUzLqOm7RAUbT82uKucSxH
 NHofij5/
 neHNXBcOJjufhacY1gLaEVJJsoolEMW5MCYJij+1ZPTlNG/vgGqU7jC+vrrCjWOkHOXPg5Tlasnq3g6b/U+N/wTfaTvlseOooFK2XtPAPQLLDo5ERQbbvcuAUAjOGoAaGqVsJbisYZeUZoiKS23xuBrdr+31Jfzh+vZEOT/voNLGXWr9Z54S3x65WTP9eM0FOrpCfPMSizUsxQxeV2USvovL7VzijmI1uUmCsaRtxEOF7E9/jPX0UJcnvFNL4gjUJsNN2lxarzIwCiHixBifUS+DzPlJXbp/NHaCRO5NZvEZCxd5HzyW2OuVmLftrhkg/oFvhlMwIautBwHJEXEK/9m6Dbw1tRgg99ZkEFwVFyt13sgwatOUSm7OmwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 08:55:50AM -0700, Breno Leitao wrote:
> Memory failures (such as unrecoverable ECCs errors) are getting more and
> more common. The kernel knows how to handle it while running, marking it
> as poisoned (and SIGBUS user tasks).
> 
> Poisoned memory is removed from the buddy allocator, but, not from
> other places. A current problem is that kexec will load new kernel
> on top of a bad/poisoned memory, which is undesirable.
> 
> If the next kernel's image, initrd or purgatory lands on poisoned frame,
> the relocation copy writes to the bad memory and the machine checks
> during the kexec.
> 
> Skip hardware-poisoned frames when placing segments: check them in the
> kexec_file hole finder so it lays the next kernel down on good memory,
> and reject a poisoned destination in sanity_check_segment_list() for
> the kexec_load path, which cannot relocate.
> 
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
> Changes in v2:
 - change from pfn_to_page() to pfn_to_online_page() (Miaohe Lin)
 - Return the poisioned address once we find a hit, to avoid O(n^2)
   chcek. (Sashiko)

