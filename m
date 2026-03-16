Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7BB3F53D8C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D5366B0362; Mon, 16 Mar 2026 15:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369346B0364; Mon, 16 Mar 2026 15:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0866B0365; Mon, 16 Mar 2026 15:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 199616B0362
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:17:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB25B1A0450
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:17:30 +0000 (UTC)
X-FDA: 84552885060.28.CACDF8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2693A1C000B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:17:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gGNOiEke;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773688649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TraS5GAiMSM/RCtun2dW6fsNdsO7KsSfqkHVJVYwjgg=;
	b=bUtdebrmyNpP1769sS3/EcV/1F8qRbrtG9MQ6vCj9GEFdUhS4bVZwZ9myKb6vdGnI+YC2Z
	KXdjpBDxK/f9eIVWzGb9u0vd8Q70O/DFw7hyU65yMCWuNp8x5ZCxCoZsg5KV68jnm4eiIy
	WJAQYBSzy0waVlkykg93VcKtnFl5EoI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773688649; a=rsa-sha256;
	cv=none;
	b=0FfzchlBiya/JQaL0eiKUq7bBUr98CXmBXyqMTdTmrP/TaiTIV/vJlHVE3M4HKsuOK+4Lc
	Rvmvzx9vYhmPJ+n+cWzXIAsRLnIuMlkgeu0YAstre8cO/7b7jV7X6fyhMuODf44V0vmm4d
	Rz1gZe8nTKNHxCxERlpxvVTblhSnod8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gGNOiEke;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A47FC60097;
	Mon, 16 Mar 2026 19:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3950AC19421;
	Mon, 16 Mar 2026 19:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773688648;
	bh=Mcl7mrfaevdnL+TnJ+uRqetMxeqPaZ97LeaI3YnhJsA=;
	h=Date:From:To:Cc:Subject:From;
	b=gGNOiEkeJkDyjYOrxgQw3qo+ZNF2CX4D4ZuiSivjHU065nWXNtEIO9J1aqia5Qpea
	 V5fGXfk3lc0jdgtH2HTAce+HHHZyOQPKjdAcNspncbwbBOlRbF+B9MRbDVw8VGWb8Q
	 aSeoDv91blV37x+jiEFWL6zsnVPcViJosmTQ+cMc=
Date: Mon, 16 Mar 2026 12:17:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.0-rc5
Message-Id: <20260316121727.54468f0e01ca280c17f2b735@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2693A1C000B
X-Stat-Signature: gj3wgnemfa4fyy7i164qi3ojc9jpqjqk
X-Rspam-User: 
X-HE-Tag: 1773688649-167790
X-HE-Meta: U2FsdGVkX1+HjN48atKLYTuIIOM2XrqdMu7zoQYNJ7HV+xwcxpsCsntUoUqccVr+NyJ7TDxhkgK6S5GvuFylojvqP5TdpD0KwTHEf4M0kZQLdtTYwAUpU07XshrCdbtfwkSh+g6fsKAgGvRyERubI4tU+MLqJVSkiY1JaB7bp4znfIeI/zoepWozDdWGBkrALPvQTLLzdafirT0b+pZlp1dJmlDcwatNUtpk28RrYr4bq0RzmNL454PoNcqJRvM0K1aheMCyeQiKvXIjT8O4vPWyL5GXUtdYTLUT+rzWzVZ+EDza7HRstFwjlqwFi/fn8MO97PEv8x0ooDmAN2BjS+2f0WQb8XTktctcmokN8WSXF28Cn+IChdznU58IYuK/0r3fBbjkOX995BiEhk3SCFOrgbUJgjg4JoBqo9ddHLMP1bIO9hK0jWR5JC6QeJ5OGSkKjcdMeWvBhyMfZk5JQ0cyxzIhnPmk9NwKj1gKJ8cVqq0Vy33gI3ldU1VtpX1O8sQ9xL5jVLb3EMRXLdMMMI05aq+h54igCAV15bD+dIsL0SDsjoy/avC2t4twC1KYNY/on/XcDkI1gY0Z4pMorFxpRVWJFtN8/dikIwVrjwcrsLbh2JDRfZ4UlKjfXMHzXrW/pz/VqxI/NFIgrSMuz1D24gwov3BEbEJTa7sVk1PT35ZriknpIWuPXVm0LXg0SCMXCT6ne8Nhtl6+Hv16VDpRsjJZO+9cVytib0fYMsBEHTxMm8AfRVm4BVKU80G632ePvsz1Ni+ElW/2UGdyiz1mJWLOzAScEIcKMJ2OPiBQ0/91fkWrsXvZOsArfRnUWDOOQVN/MJn1hx961aelMdZ4PDusMqNK+RcdtWMCk05MB2ZHxoV98FJp292NogZF+OgwlLE5FBH2i7lgkIN9RkPQS84BpcxgYcsiawaWSclz/kv2gtfKsvwHE3ArIKQpe6i0fIYBEMBfeQkA6sb
 Dd39zwz1
 Hf/VJor88zSRJcDc0Cpm2SJUafNxZzBYrAnAjiCmEoDQVzQLI+DvYPkz3BbIAF6flUDy+mav5AXKSAwc4GBoEKvOmTiv7THzpDHNpWBF4J3QBan2aqC1c4ACxi5/e1KeE2XCN8IdL52Vzq3BES+mATIa5clfHK0KHUvJ0B0wRWzCExFwnAZhyZj5MklUBL3s6FwvMVYiDZbI4q0fnzCOY0+SMFHurl/O3ZMbgqj5u9UuBkQ/MKK62Cl4JCz14hzvVAL5byHXAC+A1Cqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit b4f0dd314b39ea154f62f3bd3115ed0470f9f71e:

  Merge tag 'mm-hotfixes-stable-2026-03-09-16-36' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2026-03-10 12:47:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-16-12-15

for you to fetch changes up to 182b9b3d8d1d36500f58e4f3dc82b144d6487bdf:

  MAINTAINERS: update email address for Ignat Korchagin (2026-03-10 16:01:49 -0700)

----------------------------------------------------------------
6 hotfixes.  4 are cc:stable.  3 are for MM.

All are singletons - please see the changelogs for details.

----------------------------------------------------------------
Chris Down (1):
      mm/huge_memory: fix use of NULL folio in move_pages_huge_pmd()

Dev Jain (1):
      mm/rmap: fix incorrect pte restoration for lazyfree folios

Ignat Korchagin (1):
      MAINTAINERS: update email address for Ignat Korchagin

Randy Dunlap (1):
      build_bug.h: correct function parameters names in kernel-doc

Thorsten Blum (1):
      crash_dump: don't log dm-crypt key bytes in read_key_from_user_keying

Wei Yang (1):
      mm/huge_memory: fix early failure try_to_migrate() when split huge pmd for shared THP

 .mailmap                     |  1 +
 MAINTAINERS                  |  8 ++++----
 include/linux/build_bug.h    |  4 +++-
 kernel/crash_dump_dm_crypt.c |  4 ++--
 mm/huge_memory.c             |  3 ++-
 mm/rmap.c                    | 21 +++++++++++++++++----
 6 files changed, 29 insertions(+), 12 deletions(-)


