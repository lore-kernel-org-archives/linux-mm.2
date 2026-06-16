Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E933CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5736B00A9; Tue, 16 Jun 2026 16:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64F56B00AB; Tue, 16 Jun 2026 16:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57036B00B2; Tue, 16 Jun 2026 16:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 254BC6B00AB
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:48:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D6221201F1
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:48:08 +0000 (UTC)
X-FDA: 84886963056.28.52927AA
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id D24BD10000C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:48:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c0guQYbG;
	spf=pass (imf05.hostedemail.com: domain of 3aU4xagkKCCQTARUNSAHUGOOGLE.COMLINUX-MMKVACK.ORG@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3aU4xagkKCCQTARUNSAHUGOOGLE.COMLINUX-MMKVACK.ORG@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781642886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bZH1+Yyqz6xQZNsOX4wfP6dQl35j3VE/PV0SUnY68BY=;
	b=KC6R4m88jXWVIIQ1O6RoUrBmJObZC7STsW6qx1kyUvDYLJLVpkQ4cwinMCmZd3AePtXrCb
	qjNDgP4xmyW9M/KvN0xmPQ1jA52kjToZOAUJ/F8OY2zfnyaQQnPot/vAHF6MJjSn1JY/Mi
	ks6sGR+AIu7/f+6CXzGDbEa0JCbKFM8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781642886;
	b=H1ZCfLs12HtxLv0MpJQBkEtY/gzBERkdk+lYdId6qZ77ny/3EHxLffhC4HV55eFjndnIpC
	vgP5GyOVDBttB388y92QsM2Pv1rx6L9aZ0iOf8//jIPmYt5+RSOsORoFtcvorplzYVuToT
	OHF91OtzsiUIGqYdc/c+4VRKnXUVdxE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c0guQYbG;
	spf=pass (imf05.hostedemail.com: domain of 3aU4xagkKCCQTARUNSAHUGOOGLE.COMLINUX-MMKVACK.ORG@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3aU4xagkKCCQTARUNSAHUGOOGLE.COMLINUX-MMKVACK.ORG@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-bed2dca324fso435015666b.3
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781642885; x=1782247685; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bZH1+Yyqz6xQZNsOX4wfP6dQl35j3VE/PV0SUnY68BY=;
        b=c0guQYbGeumv6VATyerwV3W1kVeiZ/gTUMtOjkwAMORDcr5+uhXxcZFbZVQ/qUE5V0
         eGBdLGhL/uGT+0O/vIeMvP+ofOCP/+txo9m7yHgn1p1ndva7vKxXkLtLsh9IwSdVSXjs
         jNtweGWtHWx07ETFM1ukodXKUIspApiyF8WIQMPensv2jZkmy7juqXw53Ee3CAX+jgP7
         3y7wjqneoy7XeGNF7Xke3pQowre9bJ0lR9d0JeIADSG2JkcMh5NaU3WhPiGAIWyVF51U
         ksXqU5JdEp7z+vUiTEYK2SK+JvVZsb/dy1b9furRLppeNspwwJDNHGk0FwJUlzSDKOHS
         KCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781642885; x=1782247685;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bZH1+Yyqz6xQZNsOX4wfP6dQl35j3VE/PV0SUnY68BY=;
        b=mHPXpxvAr0m78uBzZKFHO0XNpR7JbMN6EyQgz+EKgl4L+1j0Joe1xZ78uqIi22j/f5
         5Rmk5N8wcBbwMhEWzGt4kysjdtcH0+cVbaDWUwwqMrC7FXOjBF6POJeEDnhzLMgVOzsH
         QO+jK0vrKvFqx7BgiCfD8+IW0JwT2bCAGeCmESNHnaPWh3GnktDInscaFY8DfRXMl2HT
         VlIS0T41HyOzu1wCprztq4l970vznqykFKr8hbpPc2OInxPqAiVuTtc7xrQ2vZ815Ov3
         V+RPI7BdkxjdU6Y975ua9+f/YQfPsFOKtCo7zmLEu++6liVb8d+WpBoARrrtyQhHYoEi
         i1kw==
X-Forwarded-Encrypted: i=1; AFNElJ8RvGYeVASN2W1wO5xAZ41smSr2jEexToJsCPFjgpvBaOnGyaS5YnoFZOTQ3Sa40graGl1V/2lgeA==@kvack.org
X-Gm-Message-State: AOJu0YzaHfnedNXNMaV75WOFFR8OC3EdjFKaGBpW2THk13vbLj2L64q8
	f9Gt1caMhZ+fD+TDtG4reLEalc/BMFokbk1l1kZhP5qrjCD1GSoZsyhkjEDML8M7UR5apRGbT0e
	CeHdTI5arOAW6P0xeWA==
X-Received: from wrcl8.prod.google.com ([2002:a5d:5268:0:b0:460:18c0:dfeb])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2584:b0:460:1967:abed with SMTP id ffacd0b85a97d-4607eaf7cfemr19334284f8f.39.1781616233699;
 Tue, 16 Jun 2026 06:23:53 -0700 (PDT)
Date: Tue, 16 Jun 2026 13:23:49 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <cover.1781615759.git.tarunsahu@google.com>
Subject: [PATCH v2 0/2] luo: migrate serialized_data to type-safe KHO pointers
From: Tarun Sahu <tarunsahu@google.com>
To: Alexander Graf <graf@amazon.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kexec@lists.infradead.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D24BD10000C
X-Stat-Signature: gxehozagwqxddccuf77s5ceuzkom566m
X-HE-Tag: 1781642886-188769
X-HE-Meta: U2FsdGVkX1/F4IPLAfDZe9MHXV4Df7GXQ9W9OhwPW7M4kdhQl7TUernOj6mYb3QTEsWo8SIAEVBBSwyuktt4W8vUAN2g4qdOH21ixYvLHaf98lpb6z/smdl9g/UAX9lPI3piHWSV2CoYItz9tLzBDw9zALrtuow9ImVdu5rzztekXZJhZ0rydIltVOg3xQXqI5btKCby5hR/dvWzLM4HMBl6RDeIFuM/KBMFt1ye3IqTaKGP53S0mDeGcYchWbuC6msEXMB+3egsqUMH+1h/AoopH7mrSTBbKJesOBk9wulNF9EFmzvJfv3MIhocljLlltOZUko783rJ610IQer3EyFruW56+ENf/vRGcJZ9cXpxq4S1r+BaCa4CpOACRkal0a392IdTLCr0DvNjTbckHgem6TA6KKwxMvLBanrT5FuSLDwvJcHFvOyssB/mkfO65ojgw4N66HKIWp+FLcLJa2BwTaMqVnv3fH6kNfU1eWFV38Uw6P1Fc5D9yTRuNEfXoSPct1xpKrssPcExd7DoHKU95n+1eoFSiqZoTIIUMbe+aOV8OTClw9SM9tqTnLnvytSAm2FcbmBqwWPhpYg4WBq8xuZGA2Uw8iGCXjlek3sFDh82BJmlVh5dsG/ADkZvnp7b7z91FuL/VNHoGBtggHXhicdlpfKC9vTRRT6SPgWFmXNv5r9RXXTEmWH5bo+jK7bIYjMnDCooHmhB4kX9BaknLCpQZDNs+8YKEt9c/mfjNl5FHyfnE9ieLrACkIKVx8Ed8/ezLPAJg63fyfun1cLcxEZk6NAKzDkiP1ViYtNzrPDrHTN2YPbGs2DG0sSgQCgcV1I+Pty0/W0ZPs9pudE4FQP5yWWFWQvNxvHv1hLXtCW65PpgTfsoSTLIU5G+b48bTguLHW1GOBTfuULRgxqPfWWuKCgAbqAObz35ZgUI6owgpfqdrvJOoMmHuzLWOGIOI9L76nIy/CeH+ea
 XxPiu+n/
 9MX/gTl9F2i4E1RVBN8ExPAV7c0oc3ljJoObXy9cvkGQQDflx/4HatB7J73Q/4m5R+sfCwP4sboTes4vNJq+mvXM9ovL3aeIJ6o7CmnvZ+rOKnQqHulRza/3PnIrn+xSXjiAcuXXyL3BiUZWSWwCzE56AoHlKlE0UtS2ekqWcE6Y2Oi90p9mL1/TnWZfnBg/qksYc+P5TuQNXkQYfoIczWGUNQ7+cMzqQDqgSh+3s3tNdr4oDtCWz2+9bubsCU0mHmi0wtUNbfvSX9gEJvosqZ1hdWPog0R7t2X2E0/xCRYg4WID8ftrPooo1gmu7dK4+zZpvO/bnDvcPV24OZfyEQfAN0TEQWgpMyOzIfHy6/VlfjmxfkJKr8N9Me3zabRI0v6Tangj9Snw+DmbsbUn9A2W8d+skEgDaq7wpcq2VfPH/MeVcbEtUFuNpN+XPDkP9VjNx+45/ue9Pi5WkT6X8dSYDsKo6xr4m/1+kvFVJPg0W/fTy6rQS243J4FYcpp+dEtJdgK6eQYrGaB4pySgn0nRaqNhKPbuB4epw9BMuE18AsJqglsQ5yPF8zG4gvW09whOb4vvvn/VOyFL5dgt2NZmFWbIKc4pF4PQY/CYPf3sQB1S4U1ci9VFY4NSl6rOKrtwLJWVHGy61yUHbM3i8UfZQ2yc/M/GzIZGE+Lk8PmTH0qfYTDz6JkCPphU7LIUJb1dZ40twmm0V39N0AgIxSOvTka8IDPD0HBfpJE8fQcxKCFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Covvert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
This series also takes care of resolving the bug with memfd of using
phys_to_virt before checking the args->serialized_data value.

Tarun Sahu (2):
  kho: add KHOSER_COPY_TYPE(UN)SAFE for phys copy
  luo: Update serialized data to serializeable pointer

 include/linux/kho/abi/kexec_handover.h | 12 ++++++++++++
 include/linux/kho/abi/luo.h            |  6 ++++--
 include/linux/liveupdate.h             |  4 ++--
 kernel/liveupdate/luo_file.c           | 24 ++++++++++++------------
 mm/memfd_luo.c                         | 18 +++++++++---------
 5 files changed, 39 insertions(+), 25 deletions(-)


base-commit: 0e0611827f3349d0a2ac121c023a6d3260dcecdb
-- 
2.54.0.1136.gdb2ca164c4-goog


