Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F40CD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 09:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828F16B0093; Fri, 22 May 2026 05:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9BA6B0095; Fri, 22 May 2026 05:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70FD86B0096; Fri, 22 May 2026 05:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5E26B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:53:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8DFB161741
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:53:45 +0000 (UTC)
X-FDA: 84794594010.17.DD44471
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2372CA0009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:53:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BAtzn8ja;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779443624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MQhkaq44nspK6qbFL06Y57aIn4u6adveaDt9H6eoC18=;
	b=JkvCdsmt5JckrN77aEajQ5fat/zMkyLxnXeIIOn06rE6dbH6EuyYmlHzug09Hvvm90UhmB
	L4RNB0PJK3/42YvD9il2em7ntPPGVS2A8kG/Z8l+dw8VNKsnefL4dkQ7kJQzx7ECbC8LmN
	Ogp+cS3PGE9hOsOqUI1CqulyLqT3bHY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BAtzn8ja;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779443624; a=rsa-sha256;
	cv=none;
	b=PrixuAYvtMKDGuz/fQYhvxVHT500jSwMSuR8hiw2FXSODgFUfA4dknOW72ESEgZTA4Gj8P
	bAtj1cUf/AWnkVqvmV2B/9KGxpXHqX4qXtT6qPFwnz3lYr77wTV+6IUsZLihuXAaEmZDoc
	OJv6Q3KIj71XmZtIdJ/2mh9NoGQrEyY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2520F402AF;
	Fri, 22 May 2026 09:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BF81F000E9;
	Fri, 22 May 2026 09:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779443623;
	bh=MQhkaq44nspK6qbFL06Y57aIn4u6adveaDt9H6eoC18=;
	h=Date:From:Subject:To:Cc;
	b=BAtzn8javTleunWYj66pYUvbNs8KGlz0ppiyo7hRCRHKga1chjsGHlZTs2Q7oDJ4I
	 yrxl69dCErmU4FHSFvU1bAaCl6pB6iXgt31TrksH2krD1DuqhbV37JmD6e14MbydYL
	 F0MxECf69ayyWQxuqKQGOsWSleS7fsZQ70XSamMkTmzOB8cBK7rz4Rf4KI9sSPyZqB
	 EdUsB+BlDco5mS9DwcIh8D3onoRNB6jyJ/jJ6cSM9T6NuDKZqR6q42yej6Pafo4ZnJ
	 DSL3tdiS+gJMxhgr6mHn9edI//merBgv05MhSPXrt/+envtmQ1n/FxnFPlXaWm0dzz
	 kLyAa01WcONdw==
Message-ID: <56e3c93e-2840-43d2-8f41-b2e435e0fc29@kernel.org>
Date: Fri, 22 May 2026 11:53:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [GIT PULL] slab fix for 7.1-rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2372CA0009
X-Stat-Signature: n64cootbi6jrw4gjpmfnpb84zan9541n
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779443623-48743
X-HE-Meta: U2FsdGVkX1/fqWDfw9kAPUkI02+L18hvhB+U8XPw6iuwr9WVkI3iWjfkiyGUzGL2KRsMKB+2YvaVvgwvavAZc3J672KqHGls//MMDRZGAeJxlyNPxQ1xt+sDo8tQYJH4iPiDMx1TLgImgQcWghlqpyqNKc4KWQA79DQR/nD8DWNPBFrJoD5sf+jjEI78VdY5S5BGr1JcdPZk5xBQD+hQuPMUIGPGY6SRz0JDRaf8dDzVoNcMSKhkzJSWx7jtZsV/MZuwgtOZUfltyR7LzHtklOTHCluFGSKXV5zYUdroCHLmV9jm4tJA/Ieh2mswKgelgF5uwmaGwd7DMnSaRw9EdQvfUMppaaIj4v3JqeCfSQn83sTNqhLl+LBEPdCX2h11hx7e5UPwozRul6/nXBN1wyKQ/Av/laJJbJ0hcwz92vc91MLs8m6fCOADlir2D1qMtpJARsZ+F3UtpdLo2+GLRQXV6PlPnYq/VY8tBQjzKhkurBMSRbSVKENubArhrnukGsgf8SMXh5E6gvJ4Wf/pXOtu604gA9sF0HxQgnc2Bq+mdj3Jt+iL20niXcOsmylcNDCV/0FXhksn8Q6IkagBYPYloJBR0KNHYU2kMowTorMFt2zFob7VmP3poZCohlr0G6VZcXxJ/8Ql76KZNXnyjz19PHwbbDAIhgEbSNUe8/lSYRUopofsZp2ySiXmdE37/i5NEwDnTGaNXHHs6bHc5F0/mVefjerv+fZ6To/A3UEOfM3i3im536r3xIejQvVzPnibW6iStB3C7i8jPy9H32i5XT3MpgH7SmLWrey5Y4Uka9RcySPtHhE4He4gVDqrEh8YBZR35tOJ2Y561ehkuFgPBHLQR3ESmP4Tl0SmRI0aGh6c/qPpO9/y2kqJ6SbxHf7GXdhILVDCTzu2FoIgTDhzLYOrHtEMH0+l7lmAs5vtOpJryhaTUX/EystkzOH3N2q2Zu1pPgHwgA7JB7V
 SNv8Ba42
 BEvUmx24DteaiL54Bq+C66IldBck2L+iNf3xKW4cNnXesDbsjFX9DllEpNiXIa1E6tVMTLbX/Aj++Q0XMEvjgLMw4g6sXmgLGZmzbsigpqwwdvl6DvuFnzd/IidhSFEEG3FfVPhIKW2w0WVokUO8nRTgjaJm6/pmq6A6UG+7EAhQSANK2XEiQvC4rBl8N+SOjozam+xW8YxJ1GTI40rzplm3dje7wfZTXpQkNN2cMqt0sq5afqwVz9qcj0s+q0tEtT9PBG9uy2+MwCv6JpkyV6dDykeMnphpHbBteIs0xeNdh50SzqmgYIw3uKSpB9yjllCnq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab fix from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.1-rc4

Thanks,
Vlastimil

======================================

- Stable fix for a missing cpus_read_lock in one of the cpu sheaves flushing
  paths. (Qing Wang)

----------------------------------------------------------------
The following changes since commit 5b31044e649e3e54c2caef135c09b371c2fbcd08:

  mm/slab: return NULL early from kmalloc_nolock() in NMI on UP (2026-04-27 09:14:36 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.1-rc4

for you to fetch changes up to 67ea9d353d0ba12bdbc9183ff568dead9e949b80:

  mm/slub: hold cpus_read_lock around flush_rcu_sheaves_on_cache() (2026-05-14 14:56:58 +0200)

----------------------------------------------------------------
slab fixes for 7.1-rc4

----------------------------------------------------------------
Qing Wang (1):
      mm/slub: hold cpus_read_lock around flush_rcu_sheaves_on_cache()

 mm/slab_common.c | 2 ++
 mm/slub.c        | 1 +
 2 files changed, 3 insertions(+)

