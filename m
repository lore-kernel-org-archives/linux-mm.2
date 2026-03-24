Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4759AFEC119
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 21:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 875F66B0005; Tue, 24 Mar 2026 17:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8270E6B0088; Tue, 24 Mar 2026 17:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706B46B008A; Tue, 24 Mar 2026 17:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B42C6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:29:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9F45140452
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:29:29 +0000 (UTC)
X-FDA: 84582248058.03.3598477
Received: from hillsboro-edge.smtp.mymangomail.com (hillsboro-edge.smtp.mymangomail.com [5.78.130.219])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9A883100005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:29:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=c4hrJpkF;
	spf=pass (imf14.hostedemail.com: domain of oskar@gerlicz.space designates 5.78.130.219 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774387768; a=rsa-sha256;
	cv=none;
	b=GG7lD2Kfm+iWjhZ3FucqNdVF/aFbqXSNU/6LuS4+tOLmwEp1LNhLGiLxPLKQT7L/x+TFuP
	UTnoiApqOei8VG3g4aLYZj1LFqs6HmHTwYsmGZPnCJxmp9cT/tS2YXmpZ4HmldFScj4PmI
	0XAuygU0iuNhnycaLO+fhMzIWP4s9sI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774387768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1oCpYm0KzSTu0Ip3vGkBopZtx8t/TNQY1UTxcF3u410=;
	b=09VB6E6hk0/YZ/6wYQtscEO2hW+g1Ytbz6doue7o1SNjk8HZIWWZwQ7q8TsdNFIOYI1zmf
	XxCOrY+4H3EJXpcYA06kLqKJ5dDdMVbpnxlfaYO6iqBw4B+gxFhKn+0PQ4lCmE1IhWz0dt
	4MhDqmFVBtFMF0JpHFQw/TcqzLOGe9k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=c4hrJpkF;
	spf=pass (imf14.hostedemail.com: domain of oskar@gerlicz.space designates 5.78.130.219 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
Received: from [127.0.1.1] (localhost [127.0.0.1])
	by las-vegas.smtp.mymangomail.com (Mango Mail) with ESMTP id BE441418CA;
	Tue, 24 Mar 2026 17:28:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774387733;
	bh=U3g2cJ4i0kfU7fAPqpRnGVtuJyqHXzzYfGdEhgmkup8=;
	h=From:To:Cc:Subject:Date:From;
	b=c4hrJpkFB8lQJsNFKNROacA0nVLwxVgniVWlIQsJb8Wld5lCwcvt5xGlCqc4DKYkZ
	 NfujZ/Rz+GIGS/5fdF8afxfDWbtWAc2q1mTRl7WQnmmucn/qy+P09LaJG/AduDKiq1
	 pjKOnrI7O70gNdDXDQTZeydb9+xQQN9PvmpFnlmg=
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
Received: from authenticated-user (smtp.mymangomail.com [205.185.121.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits)
 server-digest SHA256)
	(No client certificate requested)
	by las-vegas.smtp.mymangomail.com (Mango Mail) with ESMTPSA id 7FFAC41694;
	Tue, 24 Mar 2026 17:27:36 -0400 (EDT)
From: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Baoquan He <bhe@redhat.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Subject: [PATCH v4 0/5] liveupdate: tighten handover cleanup and session
 lifetime
Date: Tue, 24 Mar 2026 22:27:25 +0100
Message-ID: <20260324212730.65290-1-oskar@gerlicz.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9A883100005
X-Stat-Signature: 8pryk1u6o3w84yx6ezykg199rxa8jr63
X-HE-Tag: 1774387767-9879
X-HE-Meta: U2FsdGVkX19dlOGyFsgH/Yk58NFzxz4b0SJ1APmQNhBy6Vt4rQ98eI3HM3xv9Qmz4qapMhSgJojJ538RhOy5Ztof47kekrSyrndAYpI+5lENe4bXFkgBeYhzQ9/nhnFq+smM27jYVDFUMmXKwUqhxqis9qGjvvOyOCgKCj+OBnVyHc+965KStU+2e5h4+8ceG7ED21vvQtdM3ifGDpDvETidW98pt1esulyLA+PlLseK+o74R+Lg7Jj5atDgZsZY/qgBHK5TkGPJUbhOW2g2iZQ7Zdy1Wk2GXzrvT6uEOyL0NIRU2YRRRSO2dK+9auy0XkbQs0oy/jDZ3frRDL6l6lJfCgapz1ECJ6IxjrrtHRfYuFto0PtH//s5eY9ueu/BxIz0EvsrQCU1OOdrGAHNw/pPNucrUg1YMcXDeSDeWm6fST1Rwt1oOk7ldWzzh/BGSycVXb8MSGDcJpP24SWqXyJhH+bd5m7dKrFEE4x6oSxbrEjYyNOoQVrLhZROkwkgAXUGrVs+P4l94HoP88BA2ITGwSmJRz2n1XJDIfYflTbaUGPDtu2nW/B36cAOB6n06h4/tO7xbCinU1SLp4k6wa5ICEJRF/rhZjuSEJ/8F6VL4gPlcoako4hBl8fi0Dcp5luL71AmcTlA2oh59uRVdAGkGGEBeCphR0FpCaNcLKQNwTgvkVytFNUBS2IQfrnQBUJhc1QWI5h1nxDsFJHy7KFD6VCJlIVBCm9tpuOR3zru2L6MTE7/kWLBn35c7BbUPnbXPeWFyKfw6wSoTjmIxJypllKYvKA37g3/qyJ3JYCjbHeHlB9FSTaE9Fca9s2j4YvnfgtkyfX4S/AcG5B6GPAJq/U5X1Y2dQ+cmRSeTiHkK9IEp/d7XeV8YuSGSfNAhv6glJVP+V+Iw0GC/Dbrb3S1ks7HOPRa2dcSDR8YQ3ZBuWaNzJIuaeEH5Rtz70BSMFbrIQ6KoCYDnIenmEZ
 kBWXpgHO
 7SwtDUju6My0nBlzQV3NuKhRn0t8MWgk8dNkMvg1+kvTZQ8X4xzSOwf7v8wC03Br1EhSH2xc+X9NcwBEympGWmMcg1yVOQOucy4x9Kk3FiPfKxTHWShUC44wdsT4Ca1lIaz28dFbliqhB922txJ502JiIiYeyDT0GaF/7STGxyv2AsHQUee5yeuFuhiSSakChy/hUf8h85XYz9XuTyjBHMsTfILPjev9Z8n02NF5uOi2RSL+1M5iJq1nQXm90dcoeYZ1jzlBANH0rz1Y/w5pWIihIsEAAZ27IieeQlW7jAf2zak+KTkaNXeXOz+AHUoZWNRV7j8CZYO59Z47ONCtjSCQS1JbDEKndGFu4+xX2Ei3AJ+vKyKzxcnwDOfMmEw3ww62E143tnx3+6Ts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

this v4 keeps the simpler direction from your mail: outgoing handover is
still driven by a boolean rebooting gate, refcount pinning of outgoing
sessions during serialization, and session->mutex as the serialization
point for in-flight mutations. There is no return to the earlier closing
counter or a larger session state machine.

The main changes in this respin are:

- reshape the series into five commits, each building and standing on its
  own
- keep incoming session origin immutable and use retrieved only as the
  checked-out bit
- make FINISH and implicit close consume incoming sessions without
  reopening races through retrieve-by-name
- route deserialize failures through explicit rollback paths for
  sessions, files, and serialized memfd state
- validate KHO-preserved extents before walking serialized metadata
- harden incoming FLB lifetime and remaining teardown paths

Patches 1-4 keep the core session, kexec, deserialize and validation work
separate. Patch 5 carries the remaining FLB and teardown fixes needed to
match the final tree.

Oskar Gerlicz Kowalczuk (5):
  liveupdate: block outgoing session updates during reboot
  kexec: abort liveupdate handover on kernel_kexec() unwind
  liveupdate: fail session restore on file deserialization errors
  liveupdate: validate handover metadata before using it
  liveupdate: harden FLB lifetime and remaining teardown paths

 include/linux/kexec_handover.h     |  13 +
 include/linux/liveupdate.h         |  17 +-
 kernel/kexec_core.c                |   4 +
 kernel/liveupdate/kexec_handover.c |  22 ++
 kernel/liveupdate/luo_core.c       |  16 +-
 kernel/liveupdate/luo_file.c       | 237 ++++++++++++--
 kernel/liveupdate/luo_flb.c        | 116 +++++--
 kernel/liveupdate/luo_internal.h   |  14 +-
 kernel/liveupdate/luo_session.c    | 500 ++++++++++++++++++++++++-----
 lib/tests/liveupdate.c             |   2 +
 mm/memfd_luo.c                     | 160 +++++++--
 11 files changed, 934 insertions(+), 167 deletions(-)

-- 
2.53.0

