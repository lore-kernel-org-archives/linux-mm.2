Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78571CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 14:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965536B0005; Fri,  1 May 2026 10:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9166F6B008A; Fri,  1 May 2026 10:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82CB26B008C; Fri,  1 May 2026 10:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 739E96B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:54:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 282EC1C012A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:54:42 +0000 (UTC)
X-FDA: 84719147604.03.86DEFAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6A4871C0004
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:54:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FQhVAhSv;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777647280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=j445szeXnKmSX/mpPA7u5W8w8TekkaoBxIQ2BK8wRMM=;
	b=mqNhz5GuI7c9h5dDwjXKiGUm+gl91E5PWjuaQg08N7Q13y/9gPr5558s+E2s3sYWRC/gIg
	HsZqfxtWLdbK76D98NuRrZ+SzU4C9Mr3ED7y5WdgEXX7dPxBZT+W3Xl4Dj1BqNqGFnr4kq
	z+/Ywb8Sj/w4L+WFml09UOYe8IkY0gE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FQhVAhSv;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777647280; a=rsa-sha256;
	cv=none;
	b=EqjtKOQlGse0OkAeD/PtoYQp31nin24vFAZ4p8TWUl+P1yNYbpFtNL+VY4LNIVhk68KphT
	JjFAoydZRZoK/cxaUm3QTyjAuCq+l+u0sE8/8hbT9kFiyO1XqEZzLU+zaFPC7j3iFduy12
	w3iht2jzbuoiwvZJnZPUp6pL2RZx924=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 891C6600AE;
	Fri,  1 May 2026 14:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B866DC2BCB9;
	Fri,  1 May 2026 14:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777647279;
	bh=q0c91woVsg3J+mEvem4ByLKRY6SAAHiSu7FvlL1Tgt8=;
	h=From:To:Cc:Subject:Date:From;
	b=FQhVAhSvPoU/8cnjtJ3Tqrr/2ta5/7WaC9QbRWCmfKv1N/HZOOtV/quw21za3lZjM
	 ja+DGAgn/jpzIF2FPzjiXw9HwLJR03N3re4aNIo9LhAK1tP7F4GR1uuOaatYg3HO4A
	 02P0cWs/G5yGdbJpmXyt9zove9C4cU/ZEcMFt02Tfz6ClUiL9kcJMnhM4BNNjKEuns
	 r1XnC2Vo0ObO94uN5hEkmBpwuQSu/vIv7VAjYH9TEkhb8Z+KUY6HaA/LsaapSLBaCL
	 ZLpNzxaIWVhVpDVRA3Qk6nohjQTh3Ra5g6qY4yVM4qvggGLhPEABu8PyhBoEOcrNWs
	 xThaAdGKuxoDw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/3] userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
Date: Fri,  1 May 2026 17:54:30 +0300
Message-ID: <20260501145433.156211-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: snbd6hode3en8i5igbsnftbmugdcpcdg
X-Rspamd-Queue-Id: 6A4871C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777647280-620116
X-HE-Meta: U2FsdGVkX1+XeRWny2b07aDQ7tbBxtT106gp4n1FFa1oHo14B7cesle6O2NA4tl8aJrKGYRkB8AExbPNnKZjd2yZX3CQiWgUG3527fbQUXmUGo21kh/obW+j18BXggJYZ/XNVyySc/54M6plA5G6ojEBg4JgQ1ZjPb/Dsf0T1oZUnacdO76gxSUaxiJgTb93rDwdRJcDU0Uy/0nqWJ5oUxOyR5BgaZDWwt6UiBYcG49jAm9uDuNTBOXl2iJLeT+uTuJubf8ljL3TwQl08SyPgS9MZrY2KSyaLGM4K0TOJHngMekhgZZ4ZMI417kPVJCVWaZE2GW+qXWLk26kwyCaYfEyG6EJmriaeg9VUvk45qcr/Z1iS5EWuc8kUNJUAWxn3q1kTuBwPgOPVWl6lD1hjp4YrMxS4ss8G4z0QpFEBywB/de67KqK/K0WkMQYf6BFqzSPhr3ENdGkLLZ5ItXbzowF4wdb9Si9ouZP4R7+6y/qkb8GxT8v23E0q1wvVK2y3qY7CrP1rTeNU31p9UXtbAhtshkjjiPlsb+3v/6/TYLEBn0FlGpKVXMPOO+XD1NyjEIlSxRSYykZAcrsop6L3MX/DQG8SxKaASieoikUJGVl6g0RZ1KzVI8zbfLsMT7AliMjxvlEfbEyUoowEtKP9ZcmgzCliKAVmgTEba2GXdPJEyRUlcJr2fvMyNJ+UzSZ2ftvsZF0ELdiwOClcV7WP1zDWmlh5+19bfkqw+64oo82ZJZV6Hgt4gdrpiKv3sPcKGJpDx7MiswdGCw8YqAImrA7Meb/uL/bqXbC6vfTNeTRL6s0jCAXep8knM9Af47hBkVmS6wBETDB2HhmwB3PhKNziEiVdfIPwCO1kYxKkBty8anGff7FynAwma9MlzllYsQc6vdnKlctroyX2/NPRYjP1v+t0Y/4KTWUsFLNRuUE75aQljsBAYFi0JXB08Qo5jWJxWEak+j4QAoNKwT
 aTwTEe9r
 QUfBj/zngmhhdLCNkhDXQzIkN7KpnX1zFAGx14w21U7fhnjlWVIyCFosrvnEUpuPaq6LXabz9ANzilAy3hmKjwzc25/57xNfvsfbDRG+dZDN40fyFgDuHDuP9LYahMlfjePy4AHNFlomXHU9uFDxoG0fHOWHysH4xmyHvI2MmH5IcS+YPXf4Y/fr4TaJsxk4LuQHIiatNDphiw2+fZoAQf56cHE3rZAMP4Kp9Th14uLiDDZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

These patches merge fs/userfaultfd.c into mm/userfaultfd.c and make
functions used only inside mm/userfaultfd.c static.

v2 changes:
* add a fix for pre-existing bug found by sashiko as a separate patch

v1: https://lore.kernel.org/all/20260430113512.115938-1-rppt@kernel.org

Mike Rapoport (Microsoft) (3):
  userfaultfd: ensure mremap_userfaultfd_fail() releases mmap_changing
  userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
  userfaultfd: make functions that are not used outside uffd static

 MAINTAINERS                   |    1 -
 fs/Makefile                   |    1 -
 fs/userfaultfd.c              | 2231 --------------------------------
 include/linux/userfaultfd_k.h |   36 -
 mm/userfaultfd.c              | 2239 ++++++++++++++++++++++++++++++++-
 5 files changed, 2227 insertions(+), 2281 deletions(-)
 delete mode 100644 fs/userfaultfd.c


base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.53.0


