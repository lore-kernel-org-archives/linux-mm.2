Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14058EE6B44
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A4B6B0005; Fri,  6 Feb 2026 12:48:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ED946B0093; Fri,  6 Feb 2026 12:48:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4170B6B0098; Fri,  6 Feb 2026 12:48:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C34C6B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:48:16 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D402CD598F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:48:15 +0000 (UTC)
X-FDA: 84414765750.03.A422D87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 57F0240018
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:48:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ibP2Gdyf;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770400094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dNKe4GeIZwLAsiEXos9BPWKKpoOagA7aZshZ4jhAHBw=;
	b=pjtWl38AwGzH+mWPj1ur07ypmFOXkpv+BWtknJXGnttO+mwaEtk/SJ4JBzUeV4XVnato6h
	tAZFwbELEsxRcNNYM0sRYHxwOoUbphzW7EZLbedAq1doHgs1//rM4UksnNby9zzxko+Yq+
	wUvIK8XysoGnGvYwNVLXzC3NxJTKsGk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ibP2Gdyf;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770400094; a=rsa-sha256;
	cv=none;
	b=l7B9MvKWK5vV5duyibJadzEiUMrpmQDzCe/J/4+hnUBvBMLON6zYnNmO9lJk4tLJ2lX2jQ
	0F0HL5feIb/omFxbeAVO9IcUF4VNDRa7dyfRag4xjHNN/2CWyqBQABq47a9rgHgUw6L0lz
	kPY09m9qarB/3/ORYJZixbbI6S+xEyE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A5249600CB;
	Fri,  6 Feb 2026 17:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64392C116C6;
	Fri,  6 Feb 2026 17:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770400093;
	bh=E9VSBnb8FGRC/30JfT6OdDNQsCCg2idmhSTmBJntEpE=;
	h=From:To:Cc:Subject:Date:From;
	b=ibP2GdyfxqfzpgDDjiQSdyNd5Dus9LZ2QzgfsM5+KBbDn1k/H+xUX08CbdlkRuTkI
	 UM4Dp25y438hTEwXk8mUPC55PILi1MMYXraHzZQRrC2m9T6RJG6qHpM/+RUL2mQvUr
	 9oprQifE4HVzBVOPNRQ2wmQ41CNrChMuQdKlzf9RquQmqAXu/Z4k6C+d7VkqcYDuBw
	 xjKw9Obr8qb8JCVVlttb69I4fLwtPlxtwtxvWBUTyrGs/+N8jt+ksaz1MTZmOevNnS
	 1SxVnccfZcXxzpk5fJ2LhwNH1q48swPQCjgEC06SG8H8wZGzYjqhALP5EanDaB1bjm
	 B5xXDl/AJyTmw==
From: Pratyush Yadav <pratyush@kernel.org>
To: linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Rientjes <rientjes@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [LSF/MM/BPF TOPIC] HugeTLB file preservation across live update
Date: Fri, 06 Feb 2026 18:48:09 +0100
Message-ID: <2vxz1pixvk4m.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Stat-Signature: eka6xhdch9cw71gura1mmq7su6q8us11
X-Rspamd-Queue-Id: 57F0240018
X-Rspam-User: 
X-HE-Tag: 1770400094-736461
X-HE-Meta: U2FsdGVkX192b2ISy+jL+XfYGN0xkjL2TQG1N6gS7t9iNKAobvLBbXy3giHC3bbvSOGJ0Sz2bi5b7+hoNrUgIFkAeyALvjKKEvHsAXPmTVLFH9iQlhEsj19ISpLR9zDHdhSATDhyY9AV0nKWHZkcMJY0unForlwx/wtzlc+6ZGgiwj0hOVRZ2h2RyPJXoou1H10T225FJeKyPtaFoySpMNAhVvTdMEIFDw13ubRu2+7tHPvwlw+bi+2Iw2/Lf8cib52LcGL8zO1szUAZGm+aP32eg8xAklBCZJRY1BMW1JNaGRZmJl8K2p6r7fip7TdTHHAw3qxa9mz3E+GqWVsCjySlrIu+A0ydhEd6qg9qnsXCyUxTDut8QNBGdRa5AXnsfLqW7PIjp2GhiE04anCAejqhuZcI83iFUnnXCyznpV9cPh/17DKnWml38wqHOX/1eLoZbf3+JxlyPfHKZAugqEo31DovGNrEkZEFcRQHfLCVKVEMwcT+HMIfFmQt397wgvbQI+wiIZe7GMmjDXTU2KZZessXoA9ovEjutqNqV00xZ0Mrzi+eEL7bUHGnhkD+S8NNnUdGm46ts8Ky3UWGBn+03xwWlE2cGz6XcFm+N3pH7dCGsPfV/JDibQReDuQNNsSOY4yyje+7ZbPQkW+Z4iLyoI6ut9IntkLAxtkLzNrm/Zhb78C1HhK7ZfjYG9qUHgSCptYgDMze2WyeI4p74McL0xf2+SS8na+YZJ5TgZZHf0tEPyvYS4BgBSP0yu/3avdAS2FHPzylBmxhXZ6ef/TgD6Ry1koxQMd50Ilu3ISuwMgNFz6K44XnB4Gij/S0pmnDCjRhG/AdL+PI/TXPd8rDjbKDheCB5IE2DNNKDNncw2IRIh0fZq43RZcOyolrrWZ1l2qpt+kB+YlkvjcY07Qv2q+iB2OCF0VjQQoiuwc3BU8tVKssPLq7+A7WTH09W1gT3Zo6DWz0FMo44Jb
 oIo6H+57
 UzeQPfxsq3wBB84kgfWNyrGqId5CeKwE54ysVPXjWtNYAe80Aml89D227tpIDWaC+x1+xfWbJ2dsQpwU5BkHhHgY0Tkc1cYSPxHiZETLjuvactVCLTpJzQ3QrOGuWfeZW20sFaI9hOEpVdwP/ksDJX6m7HU7NGVfURDflc94FnACmkwNg45MbqzzxeP5YVjPI9A4iQxaLRI+UMoIxkM5NekbKbbhP0mJXrqPiQdjHmcuTf+D+KFEnBA5Xv9QnBI5Wyo/7v9AGKPV6Yik9pzubEwV35ult5w9OjV91o6r9nGLgh/S1ZlV44bqR50m//JMV7AH6LFOdO9/1AM5dF96ikcoD4N1WwBbAQO5JT5K/ls7WflQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

I would like to propose the topic of HugeTLB file preservation across
live update for discussion at the upcoming LSF/MM/BPF summit.

Background
==========

Support for performing a live update was recently added to the kernel
via the Live Update Orchestrator (LUO) subsystem [0]. Live update allows
a full kernel update over kexec without terminating running workloads.
The main target is live updating the hypervisor without terminating VMs.

For more information on live update and LUO, see its kernel
documentation [1], the LUO patchset [0], or this LPC 2025 presentation
[2].

MEMFD preservation
==================

MEMFD is the first file type that added support for live update. This
support was merged with the LUO series. The memfd preservation code can
be found in mm/memfd_luo.c [3].

MEMFD can use pages backed by shmem or HugeTLB. The live update support
in mainline currently only works with shmem-backed MEMFDs.

HugeTLB preservation
====================

While shmem support for live update is useful for many things, using it
for VM memory (and other memory-intensive workloads) is inefficient. The
next step for MEMFD support for live update is to allow preserving
HugeTLB-backed files.

Note that we do not attempt to preserve the whole HugeTLB file system.
We only preserve the memory pages for the files specified by userspace.
The HugeTLB file is re-created fresh on the next kernel and the pages
are inserted back in. This lets us keep the maintenance footprint
smaller.

Current status
--------------

This support was sent out on the list as an RFC [4] in December 2025,
and was also presented at LPC 2025 [5] in the Live Update
microconference.

While the patchset has got some initial reviews from live update
maintainers, it has not yet had any review from HugeTLB developers or
maintainers.

Goals of the discussion
-----------------------

This session will aim to present the topic, explain why it is needed,
show how the support works, and most importantly, collect feedback on
how to proceed with this work.

PS: if any HugeTLB developers or maintainers are reading this, it would
be great to have your initial thoughts on the RFC [4] so I can present a
more polished patchset at the conference and make the most of the
discussion.

Key attendees
=============

Live update:
  - Alexander Graf
  - David Matlack
  - Jason Gunthorpe
  - Mike Rapoport
  - Pasha Tatashin

HugeTLB:
  - David Hildenbrand
  - Muchun Song
  - Oscar Salvador

References
==========

[0] https://lore.kernel.org/linux-mm/20251125165850.3389713-1-pasha.tatashin@soleen.com/T/#u
[1] https://docs.kernel.org/core-api/liveupdate.html
[2] https://lpc.events/event/19/contributions/2052/
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/memfd_luo.c
[4] https://lore.kernel.org/linux-mm/20251206230222.853493-1-pratyush@kernel.org/T/#u
[5] https://lpc.events/event/19/contributions/2044/

-- 
Regards,
Pratyush Yadav

