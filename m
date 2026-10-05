Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 128BACA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 06:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C436B008C; Mon,  5 Oct 2026 02:53:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0F326B0092; Mon,  5 Oct 2026 02:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFD036B0093; Mon,  5 Oct 2026 02:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B72106B008C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:53:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 428F040160
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:53:02 +0000 (UTC)
X-FDA: 85287655404.11.DAFA279
Received: from mail-wr2-f33.google.com (mail-wr2-f33.google.com [74.125.225.97])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8CF6C160004
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:53:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XqnjsUg3;
	spf=pass (imf08.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.97 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791183180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=R+cel1ot2Kfg8JeSO82W7kcsnYWCLr8nwIFUtN9mXDk=;
	b=JvS6VYbcpKhliOsFIZYq25AqUtkA0+wEAfVPG+llgC3YcM0LWz4ie2vIDObFnEZeYhDV7k
	GGHj0VQ9pb5EKi5cNq0mmjJF6w0SUvm4ROcc0gzHahneQWCif9A3Fv9dNeMYl3SuVQO8PU
	WsuWQ+9VvDQAM6anzkoUDsmJzZ5sQWQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791183180;
	b=F1oS+CnK1OeyP2C7Pn175OvymCTKca0lW+VI0nDWxAaI5qyqelk0yuCIzsdZjJ5NId593R
	nbleElWnU0YlGEnCG0sqQFRjke1AWCF2YzQz1JV3ezacyhw8zi/N8aZTn1B4sfsA/ILOn/
	3uex3Xy/gAFyiwRZ4cbg6Ax9hC4pA3Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XqnjsUg3;
	spf=pass (imf08.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.97 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f33.google.com with SMTP id ffacd0b85a97d-48c54d65743so687213f8f.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 23:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791183179; x=1791787979; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=R+cel1ot2Kfg8JeSO82W7kcsnYWCLr8nwIFUtN9mXDk=;
        b=XqnjsUg3O1zHfMoBKWK9R6imoQlh8K64kh1t87Pz6ZV1NaBSLh5CAOjr/n0UxKuMy2
         yCIhKDwy8G0hOOYLmA+kf6eoniRQjWGS0U0Xh5cG9N98ZE2glZTLDaM+moSj/P+pfRtP
         T6WOwSr7XGsX30zLXpWooXn+iVtIG/Li4uui5Mq+L7M5xMEXSdeUtpwEQeJPQg5psqPa
         0575wxL3vttr0n7lnQ1p4dJbUZUfcikkwRRKYO6Ibhqf565Hr93Q9xgr1kFVjTMNGRw1
         n1H27SZSj8myqhJxFGtEf4h3t7UnP3h8jPlw9IBGaQtsrvQq2mHiN2CskoW//58vxKNG
         e1xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791183179; x=1791787979;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R+cel1ot2Kfg8JeSO82W7kcsnYWCLr8nwIFUtN9mXDk=;
        b=zjqvfaT6Puk5Peyjc06Lz0tGs6GoS6DAI+FRDrtDz4fJ7kfAxgXoQrcK48ODeV7y/q
         CqEp8OD5ne7936+nWR2CA8UfRPuY0tWN+d2GpbpI57aBbESuA2e0bXy1lDaX8v5nWvGH
         RGGQtBaaocSG03sPxn1uOuSdugNL/vuUVyfhzUdxcjan7h+nv1SST0IdDOXE4FBrMXMB
         Q8dfwJyLy4tzMgVXv75Qdd2rDxkqYKEEh/r0IvFZM/EpbyNLDgSSZkpIA2/PlSyAhqJg
         lQoMbOuSjbgroeVmexARA9VWXOxmQysHhvOx2a+de89fqw3gNkEyWEf/J06dXALUS+Ah
         G2eg==
X-Forwarded-Encrypted: i=1; AKwUvBxjrHC1OWfewCbUPi3JR2zhzx2GoYh0vyJDG/FlPzIIOq0nFJZJ2IyJjgJ7jEP1TgIc/CSfG+w3zw==@kvack.org
X-Gm-Message-State: AFq9FYL8qw4a/ZBLZdwuKkT74iNKghMLCKH1Dw0kGUsCV1yBq/4D/hpr
	N/SFphoWLCKObygjSNuEvXupJEm/5FJ+reoJ8PdJwvTaOi+YJovyIp5G
X-Gm-Gg: AYBFou0InwDYjkVJrR82eACO5wc1ev/R3Y5BqPKGCcTYm6djpQypP7ep3KSkvQpww/r
	EIT+rtp7/29ykMvuy0cWDyixkDSk9FevnvuzvLPSz10zIx0fBoCwU5iBrkZJ/CHwP15PbG6GEqW
	0uInsqjh6h4hc5IHM86mOIn3vCjxMywy3NtCH0byB/5+2Kdp/ZYakn73R/qsJ5uL4sSuQv23S8w
	KUpZCoFv+hRrfOSe53rdWW2HVvRzg0EXS/cO9avlWas/CYgF5EfC9BPsjm2VTJUcFvkrlWi64A1
	q0SZ1x/X/nVrXIp7pKj4ktZox18HTffQ3cbHAbGwC8EaTa0QSa5EE8S1Xzgj2HnJZfob/Lc+/xV
	Z80qh9o781C0zlxUtUqPiy+K9lMPI1ctyO6Xh0X/VPPFLCed16vP4HV/+iuJ382JXBC54RE7uyR
	2q4H7WoU7FYTm6M2n3BVvOu1h5Qx7b030SjehgYpyEBbtVctZ39nhsXhLTYgN25kXiSA==
X-Received: by 2002:a5d:6f0f:0:b0:488:79a2:3232 with SMTP id ffacd0b85a97d-48b12718166mr18760857f8f.31.1791183178947;
        Sun, 04 Oct 2026 23:52:58 -0700 (PDT)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c6308481dsm1247436f8f.3.2026.10.04.23.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 23:52:58 -0700 (PDT)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH 0/3] mm/mlock: make zero length requests a no-op and reject wrapping ranges
Date: Mon,  5 Oct 2026 08:46:28 +0200
Message-ID: <20261005065244.6935-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8CF6C160004
X-Stat-Signature: eawsasnbhtttjwk3nhkbxndyyrwz3d46
X-HE-Tag: 1791183180-593831
X-HE-Meta: U2FsdGVkX1/WwbhB4s419wav57A0Wyp/+sETfAeRZnTm+Tmon3SAzZJyAiM48kS/+JI2GPd1T7JE17Vz/OFCSGjcM24WBq8OHDInIa4WpuDD/91REtjCi1PCfZMW+MdR8tcaaHLMcikz2I+KU3nnkZr5X40P97m2BN60+oDrkuaC2UjGdUQ889AssD9idQi0x94NM4h3nKOqVlpy5KVp9hf6qqmlUOqTY+02xspzriwgLVQ2fcbzG9JCaVIcHtiTkEVTWNysD9mxNHGlBIkln5N7b4hLpNLLNCt8r/4VQgaaPSYpb1H1WZY7GZ5hksOkqljhwDf1nd/+UE5bXFfADTENpaQdGWg28DXWSZmjyOWzHxX78oP7xCwl41wKJCr7CN+nBPqZLCfXoBBDltY2vk3IAaFwMn1x1cFay+Ti9fXuuxAcSoCl4on0pDsSGjKQtfPk37NZCY+CyBPCRcM6xx3g2RkQXUi6tkO7BwM5mqm/UCCHx283Ni8rQ45nZL4Y1kwwmkrkwLqdv2pcben+2EV3/O9MOFTQ78YNyx7WZPRN56rJEoinCtm7nubTll/Co1v1h/uBYPYIBfQhZvaL2HZFSiV6vYxi3pshpLsZSJuGWkLkDaSajGJkPaJesGpjuMtObjjVQXI/Op+MibjWioWE1nmqm7rjCcaA3fwIsADqEtDxSHtVo62HUzA7IwoAwEj4OGwsRh1kehx9n0k2pIIVNXs1hzvOMe+/DUpWPoXkSw73dcFJeQX7kfsCRYPc2RoRw8cI4UJpKVTK6QMOpfXxe1fGpCPOy9Wb7gMNEUymmIfM1Zw5ULIPHBeUjHML1tQviCEKZeOR6wE4tDlatpIb+r6m7xHypSWt9gW0BhxxNjoY0uLjZALy72CRMU5RUpAB9qQ/URcPKs4PT0m6/Zw2MMeprCxDl3T+yAb4eFspG4M7T/b4mG97vHZJ+383UEdxTwdO6+GUZ9S47UV
 oHkRdb7U
 rbEVCvdZNvoIvuIK8WudeJWxJmvq8zWRrmQ5kAeKL0hlvoTfZfMGTbEwnH/AoQ2dW6YVkLu/JAlntNoiPUPPZTUdoHE3dj6eR4rvjniFKV6D6y3qVY+wZxsxHEcYGZ/3lRpBLPwV//FvhlC3k9ClHU3BAWuINS4x9xPvIA8iOkraB/0Vq64/5tSHgNkSwrmehqDa61yYG1/31aqCb+Bx1j/pS+TmmgfDzk11et659afcITuQjzhtzdODEf1oIXU5zCAI62y0XHT4thH/q8KN402bRq3Gwl+DoiwNvhX9RW8tHvRN0FlnKjKXChzL30JRpKhZaLzzZjcPLkwfF2H7nvbh1PpKgNcwL8ni8DZoMiMOwcpQu73S4WjDkG27/xFCECjQlfwSgGYFl1LqOPfmUi9eLJw6Lo20hBdAf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Follow-up to Park Tae-sun's patch [1], which was dropped. David asked
which of the cases it raised can actually be triggered, and for selftests
that show them. Two can.

Patch 1 makes a zero length mlock()/munlock() a no-op before the address
is rounded. Today mlock(addr + 5, 0) locks a page and munlock(addr + 5, 0)
unlocks one.

Patch 2 rejects ranges where start + len overflows, or where the end
overflows when rounded to a page. Today these get a silent success, act
on a single page, or get -ENOMEM/-EINVAL depending on CAP_IPC_LOCK.

Patch 3 adds both cases to mlock2-tests.

I could not find the commit that introduced either behaviour in the git
history. Both are already present in the earliest history I could find,
so they may predate the imported git history. There is therefore no
commit to use for a Fixes tag. I have not added Cc: stable since these
changes intentionally alter UAPI-visible behaviour. A man-pages patch
for the zero length case will follow.

The mlock-random-test failure CI reported on [1] came from that patch,
not the test: it assigned 0 to do_mlock()'s error, which has to stay
-ENOMEM for the over-limit case, so mlock() over RLIMIT_MEMLOCK without
CAP_IPC_LOCK returned 0 without locking anything. With [1] applied the
test fails 40 runs out of 40; with error set back to -ENOMEM after the
check_mlock_range() call it passes all 40, as it does with this series.

Tested on x86_64 (KASAN, lockdep) in QEMU: mlock2-tests 31/31 as root and
as nobody, 24/31 and 23/31 on mm-unstable; mlock-random-test and
on-fault-limit pass.

[1] https://lore.kernel.org/all/179066531783.50175.13377521828379196177@dgu.ac.kr/

Jose A. Perez de Azpillaga (3):
  mm/mlock: make a zero length request a no-op whatever the alignment
  mm/mlock: reject ranges that cannot be represented
  selftests/mm: test mlock() and munlock() range normalisation

 mm/mlock.c                                |  29 +++-
 tools/testing/selftests/mm/mlock2-tests.c | 191 +++++++++++++++++++++-
 2 files changed, 215 insertions(+), 5 deletions(-)


base-commit: 33eb75fed9eef7a57e3f77c37c160d3e9ec55f2e
--
2.55.0


