Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E61EDF173
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 15:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 557C46B0005; Fri, 13 Feb 2026 10:17:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DB8A6B0088; Fri, 13 Feb 2026 10:17:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7D36B008A; Fri, 13 Feb 2026 10:17:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA6C6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:17:21 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD756C209C
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:17:20 +0000 (UTC)
X-FDA: 84439787040.13.84746F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0A80916000E
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:17:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VcHXH+lN;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770995839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sOMCQknO8ZTIdHj7BJgF7bKzo3t60h7IFgkSUMPG8gQ=;
	b=1aTu/WOedI83wIo4AnFqi5yvxEV7SZSllX7GWuEdg5PogGl2LVrqXOoT8ygouRoNbDg0eU
	eVkDbFhoLNe9hzS85IE3yjw2X22yNGZ1Eycn2FDPXx50YHSiJKwVAO74cPNyBV35b5W4uX
	dAx4qRra+N91kspmcwn7CxczgO5l9Ik=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VcHXH+lN;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770995839; a=rsa-sha256;
	cv=none;
	b=Y3FcwkFEPS+CuydgV+++poFe6Gh4LjwbS4RWgBiAUP9Un/Z39WzDjuYT8DbEJH1IV+tE2w
	H5WwBvLdx4X1aVzDgd++MoFHZtbczWIcDt6usD9eAW80Yp12O/oJejxzbCpg5jS8Uisixz
	TLjAJkKm8LW5N1s+S3VtyHaH2FKcGMk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B289443FB;
	Fri, 13 Feb 2026 15:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF69C116C6;
	Fri, 13 Feb 2026 15:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770995838;
	bh=oDfGuQh7pNJ7KGhH8va5HzkkrySOSNEsTzNlJTele74=;
	h=Date:From:To:Cc:Subject:From;
	b=VcHXH+lNC0FO2m9miUA+DC+R8RUBYTHy8B9wgjixzEfTZfRPlpa8f1kzeg5CbXUmt
	 IMD3qenvjSswub+pGI3l5GzL5iBHL5lsVKAdeHoGn3XFZHX1LjlTVRTvW6SSwjpf1+
	 G2y8Iz0EUzikpthXkoj0EJ4IN4GP/v2HvVJ702Mg=
Date: Fri, 13 Feb 2026 07:17:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.0-rc1
Message-Id: <20260213071717.77ff0bf809865bfb7901453a@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0A80916000E
X-Stat-Signature: hwcp9bj7axiqtdwyygax78agwexp88g1
X-Rspam-User: 
X-HE-Tag: 1770995838-794579
X-HE-Meta: U2FsdGVkX19Rf5j4nTYuE0i26PG+YZtD0L+MxD7VJAdgty+3OgoOIR8DrBGa+n33AqVaL7oeLbK2Ic64YaMQAze2ZvDkk1jpuPMTq9eCwv/Z8xcNNjFYvfU8VjSVd4gL7UEHVC0TujbM2+zIAqTX2WalgyR7NW/HkS6AQbH/RD2YE94IWb0/a7zcodI/ZuujJ/LWBD4yi0t29qtQcr4viaPYMtklNHNW1i/uF545J34kMzr4QJpRBdyvDdL25e/IkVS/+53Q9FqaJhLk86Q7lFxv0bOYUdYZF4DmlEUUptysKvEO0aeILiX8VaQaQ7pY9bfwL7ETw/HN7bn1Nf3Z4fNdglpEGOC+NeEyJs/edLgIbqyb6Xczod0S2HoHotB2PuIofeWz7u2S+6vc+gb2/WKA1MxdyppcOdHMQqcy2BMFbs8Dj8GaaqCxym81ZtSt3kiryfzchqiKRKEWXAg8QPZXD4Kdi91hHAsY6Zw+pxyH353T4V1RUJ3asZ3wt8S0GUZ+RGpPygXmquwuqzBPUWIX+cMqw580aCcJDuc962lc/8w+11XArby9fZdWFMwDk/u6Tr8+IhFZXRxu3ufxD8q/UG13dsKe3PH1bvaGQc030nin0EetobhIYHg9o0YgPsTqiaj8JAXjbVtVq4+To8gg8rW/jUQwChQJuVmKT6mFELAFFr+WkCN29tLdZ5IpysPmAnbGPsUuJlwgYCNQOM7n8z9yXxrgEg88vQGtiO0yl4Km4X2SurOWSiUyyLdox7VZXHi+e8gSi3ui5BqIShmAM6/z4OqmP8gTft3JlKOySkvlGWNJ6qtuEs0UqrKKa7Y1lpkNcYMiY1L+5hhBAWrnYGMYHYZwTZydnjtkaTug3i6U61srvI8lTAaW0/kog2GDZtfCLB4b2q6NF2YSHC4soFXmmZxkhX2bTJQ34IsJo+klrV9CM5h09q1T1khQYerSHVYmLfennbTqBNI
 qdf7g4Oo
 gbwl5GRl2rL//BXL3wHD7Bsx2YUdSJhjlV2t4PJVQi5gVeL5c9z2EnVi69CA0paU46It59qqU4/ZU7ekcYlbcbgCPawitqGLzslv/Q00lnzvj/D4CsTTDaCFWwB6+LYQCaOyhSwQWsYWyw3V67KuyikA7osA8lLsOsK5NeDmOQ01m0PUXgYFCkpQY0wnDF/U7KN54V2VYCQDaMpXkC3oAjmUT4oB3+GM1CLBsSNlfEGK8MssdTgeRJgmItKvA0SSNvDJ4YO7SpR2W2xVHK1mpLVuqVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this small batch of hotfixes, thanks.


The following changes since commit ae9fd76c111bb4a5293c2831a1ad373605251dd6:

  mm/memory-failure: reject unsupported non-folio compound page (2026-02-05 14:10:00 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-13-07-14

for you to fetch changes up to 61dc9f776705d6db6847c101b98fa4f0e9eb6fa3:

  procfs: fix possible double mmput() in do_procmap_query() (2026-02-12 15:40:16 -0800)

----------------------------------------------------------------
Three MM hotfixes, all three are cc:stable.

----------------------------------------------------------------
Andrii Nakryiko (1):
      procfs: fix possible double mmput() in do_procmap_query()

Harry Yoo (1):
      mm/page_alloc: skip debug_check_no_{obj,locks}_freed with FPI_TRYLOCK

Joshua Hahn (1):
      mm/hugetlb: restore failed global reservations to subpool

 fs/proc/task_mmu.c |  3 ++-
 mm/hugetlb.c       |  9 +++++++++
 mm/page_alloc.c    | 17 +++++++++++------
 3 files changed, 22 insertions(+), 7 deletions(-)


