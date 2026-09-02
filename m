Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CDB5C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 571F36B008C; Wed,  2 Sep 2026 04:10:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546166B0092; Wed,  2 Sep 2026 04:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 483686B0096; Wed,  2 Sep 2026 04:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 214D36B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:10:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8521414010C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:10:23 +0000 (UTC)
X-FDA: 85168099926.06.48B1488
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id E23A8A000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:10:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hnjdeSs/";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788336621;
	b=eK2sDAH/UQfIhC7JVq1jfqKJAv7Fg4teuafKGOMbnsoA4exRQ7o/WRZKEUYNxJS7B5PZDT
	8TRzeJL7UaJ+JPCCGv78YWWB9ig7etfoFp0DcDeKihhmXjJlge+hA3sPBYqSIKmOfYzVdq
	jphC5QG23fWyq03u/8su8D6kiUbIpvY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hnjdeSs/";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788336621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KVRjFVx2THf+2ab6VEX/XQsEUUMQI8nKJ9zQDxApLGE=;
	b=jXtP3X9A7SHsXN6gzxiq1Kg/tcem2IlXA5BwYrfy6X+4iwJQHjOi2Ua9S43V9DVF9ly0m0
	AChYAXxN2gpH/m8V/7vIQ5d4KNJsYmAsF0hgfikrGMQHwsXcmM156LNLYdXbIoTQ3CTtDE
	r4HFVAq87yjUFrwjggRePTzJ9L87eFU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AED5600C8;
	Wed,  2 Sep 2026 08:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9961F000E9;
	Wed,  2 Sep 2026 08:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788336620;
	bh=KVRjFVx2THf+2ab6VEX/XQsEUUMQI8nKJ9zQDxApLGE=;
	h=From:Subject:Date:To:Cc;
	b=hnjdeSs/p4PWgxfb+1oVsPk4hv29rMGmEMQa1vgOsY7FgAN1zhG7T3q9tZvhSc7yY
	 kSfJHQFL7NDeYDjK1mADjQQF9wO85gLX3iKV4AalgnH7qx830JWnU/4p9ofbD9PjQq
	 n2NAbtjBlNzAo+Td4zTW/raE0/oK3t/YWkyjqitIz7sPHdXXoZOVLyRHPJM7KhVekt
	 DjQ8+RoTMJ0xStk+bA3SAKsUw1634VGU1rLWGNFwIuCkZ+nO4PbtlANHkvvcd/JFBm
	 96ujyMjiLUVPsY+oSq9y/hGY9KRpgVt7iQK51Zf8xeIJ1w2yBkYHPQXdf4Vt3nGLMB
	 OVjFGjhaDMI0g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 0/2] docs/core-api: memory-allocation: add
 k[mz]alloc_obj() and clarify kmalloc
Date: Wed, 02 Sep 2026 11:10:10 +0300
Message-Id: <20260902-docs-memalloc-guide-v2-0-218c1a4dcb80@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32Oyw6CMBBFf8V0bZXWysOV/2FY9DHCKLRmCkRD+
 Hcp7l2ee2dO7swiEEJkl93MCCaMGPwKcr9jttW+AY5uZSYzmWflSXAXbOQ99LrrguXNiA64s8q
 ZSjmnq5ytny+CO743663+cRzNA+yQVOnC6AjckPa2TVEgbNAfex0HoNS3GIdAn23WJJLn/4JJ8
 IyfVVGI0spCWXF9AnnoDoEaVi/L8gW04Dyu6QAAAA==
X-Change-ID: 20260831-docs-memalloc-guide-dc4db94dda96
To: Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 SJ Park <sj@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E23A8A000A
X-Stat-Signature: 99okgedbwnkae4e7z6wo7c8whubn4hua
X-HE-Tag: 1788336621-954896
X-HE-Meta: U2FsdGVkX19gGC9MSDFTk37vF6b8yq/j+IbCPYJbbAiWHIWSQMdzW0bczkVO7A1F40GoPloQ2nLyzkuDOwHlTGodECVMqtonMcbgxHvJIv5R4acafO9eGW/S9auEiiyPR0007xwINzBikgL7bqqojF0hAsOiw/kdq7blvxlBgKMHPC9AwEgETGgn8XQL0cnCrHuaz2wLyphUegX/eKNDKbMCGSwtBaQNssEx3eRomscgCA1ExCepT4iTm/Y37rSUGqqrO27eVfPdPWSM7aLEN5sFbQiaDjMua6LgUMrfLFmnCJbgh5ioKiMfxbMHPQaYwoOGNKNukaAALvJyxokXb9VQ5q/cL042Tw5jL17O+JrpkIwbY9g4BZRnSEcUVdTsh0LUg00VzHXCgf7MSTxqYHAGj3aV/05PPp9dvQPix2u8T1/xmATg/PwbcicQ87DFbRJ1Xem4Yi5GTkNPIKIfgbdxTKF5c9wlsmehf4Ik05pXnUXKuQmdpql0KDM0fbhfsNtSdxgjgxWL53+kEiCeOKjgjdNCjTvkFG8W+eJIv1RxhAAHvJiFZWtN/AG3dSKS4RliBpEVDb51r18Bgz99wcmQ43Gq89wWXH35YJFErl/24lQqhGPgMUvN3IJOsHYVJYLdRg5brM36lQSXvQL9fQb/WNQGxwUAY1VlRhfcv0uQ9lD7UPIW1dFhwfJKqP8vuVpARJtQ0uKn6gQCBJx77/N2TTGfwTdZOwlOIcfNFs11D2n29WoY3C5MQGmXnuVPP5FArx2NLXwuQZbNy/2A/HHYH/IG5AbDLoku430Q2jFA+KSk76n3rzZ13v9DjLxng9Re7QsRTgUQc13d9NlbowU7Wf+OKwYjk6/RgzB0hmg6v79pQKqbWMJj103IpXNI9J/fAG4SS7QK2YvDVzniWBnLOcMNfas//c3D694GT0/DsgUxYxJN9XiFYqPvs1uo+ZiwAx/HgSyCzEF1UbW
 CNdaMme5
 981Jk01l06US+1zuWIS2pdo/S6WRQEr8aG1ADnem3KfSWnPjCw+WU/4Mw1HREbvMspUf1hZzqv4jkW/RqNIAl87z6sz5Bs9tOwLU+hy4HVPqelAPZlrUFM3k5BTak+K8JhYD/m9ejrw0Mgl8KJKrncIRz9ysDCX6Ky/a9FSsoYobxlynaJRH8E/kFsiB09Ht13wnDedgpgGXLLy/5B61p/5DHWvbXDEP9Yrzq2Ueou+a0di4/ed+6GBossj73wcMEg/kD9XcnMYTHjz6266Ju2sVzoAMUIEiD2/qJ3gthnjulZAfGfmuCTPUEx/ykEHKDm8LJhvNW/qnohrwSAd9TwkrrM6IFQ6jxZvU2jTFkaeN2TNqqFtJF1IeZEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update hte memory-allocation guide to describe k[mz]alloc_obj() and
clarify description of kmalloc() size limitations.

And when I realized that get_maintainers.pl does not list any of mm
people for that patch I added the MAINTAINERS update as well :)

---
v2 changes:
* update kmalloc limit phrasing as Vlastimil suggested
* make sure changelog matches the changes for MAINTAINERS update
* fix grammar and spelling
* add tags, thanks everyone!

v1: https://patch.msgid.link/20260831-docs-memalloc-guide-v1-0-547718c274c1@kernel.org

---
Mike Rapoport (Microsoft) (2):
      docs/core-api: memory-allocation: add k[mz]alloc_obj() and clarify kmalloc
      MAINTAINERS: add memory related docs in core-mm/ to MM - MISC section

 Documentation/core-api/memory-allocation.rst | 30 +++++++++++++++++++++-------
 MAINTAINERS                                  |  2 ++
 2 files changed, 25 insertions(+), 7 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260831-docs-memalloc-guide-dc4db94dda96

--
Sincerely yours,
Mike.


