Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8BE60A382F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h1s+5KSD
Received: by kanga.kvack.org (Postfix)
	id EE6576B06E6; Wed, 21 Oct 2026 07:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E977C6B06E7; Wed, 21 Oct 2026 07:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D383C6B06E8; Wed, 21 Oct 2026 07:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A762E6B06E6
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:48:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 424A7403F0
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:48:08 +0000 (UTC)
X-FDA: 85346459856.20.ED367E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A7548100008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:48:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h1s+5KSD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5DIL4uZz39TVq6ZW2xMCikSAQz9J2d8P4Q3iHPEMlU=;
	b=ys5IVfF8RPG5Uq7KMK23Eaf8gj6nJqaNeSaUiOfmgJaaJd8p8kYaFVCqeJ8nJ+q7mvdBq8
	emS6Z/Q99FJ0jfOvo7BfgVGJE0uSdvRQOiltLujSawdW94aQAb+IDF38lAFK5ZnGwrQTBd
	DTr4NYi226941QL08RjjHoDQf5c8s1I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h1s+5KSD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583286;
	b=hXy0OVzS/PrDHWCgCOvtDPUBpXz3k6bP32usa/OQWFqNRdZR/T0TQEoLkNwEtPYjX77Ow2
	Y4BfvgYcp5tEq2UpUxPJ6xws6NzG0gARP6bYzvlhC09LeX03w8RG3OjMRarK52OmaNDLwL
	1rIdAFx7/qD5X8u1xION4rnHBT1iGHk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C18460A8C;
	Wed, 21 Oct 2026 11:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43461F000C4;
	Wed, 21 Oct 2026 11:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583286;
	bh=a5DIL4uZz39TVq6ZW2xMCikSAQz9J2d8P4Q3iHPEMlU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h1s+5KSD/LYCP7ujuSgohzesMNYwc10Y5bulYUJ3+UGxRRMiXU8KIh/FMzTSkkOgg
	 Ufb1lNPdWnAwJkPD+5pPsMl00dCLEJtYEcZ5dgk7xvWvNFSf9NF8tAw9fLrL92Udtq
	 rkCwSaHww/7ShJR8WNBFhX3BEmczD6eiIqmEqfE4h3ZQBj5hEBCMdieZXz6KXZnfnY
	 vL0H90KeuQ3mq8ysW2MgvMESaxPP6RG8H6YO3dQrER98Wb/RMRvOKwoYW9WDddVBrr
	 8Au2xU06dRcOWEMBVFD5KjcFr8UPYLCSePft0eZSLwI+ytPIPqJxEKwulLs/dyKvz8
	 nqlTDpL98W6NA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 21 Oct 2026 12:46:52 +0100
Subject: [PATCH slab/for-next 11/14] smack: specify SLAB_MAY_ACCOUNT for
 smack_rule cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-11-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, 
 Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 linux-security-module@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A7548100008
X-Stat-Signature: f85n7bft4nh3xgc7hskwg7wf6x65zukn
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792583286-418703
X-HE-Meta: U2FsdGVkX1+2VGC8EWvlDEAg0pvESuqM8ga5plnR8HPrvc9Dm0xh8+OZhcWDOJ7pXZeWIZID/nhcGYIqBh8Xf4NriJld57aGhsbwbAfCoatBcLmUJhxiXWYBFWx6ToPwCUZXQ85Pr1Sp352D0WH3C5GIhzf6YWc75UupU8HotjyGojVL4Ur7YCCEE3ReJocCijzmtl4+WRF6SqHdlXsZBIwWrOKd9BmkGH9R7RikzxXRhKVV/lCh5BRk9yh7TOcSSCqT7+/smjh8eIF6b9ucb93JS8mHbKRzbI2SAhalqEG+wL9JzdINtVPHKViecygv1+8vaxHbBwGesRvB1r0fg5b7QOH5RDnTfgBcOyYrU7SIeBhVLF120D0mQnc3WmSApihxDjzfq18J1YHW9hVpfzA54YonbU6XNjyBrgTpqgq9ioci8IHYV3UCFSDLkVm9XgBB9ExQnP89PilhBzxVCFGUdv94cVTOfFZVGHGjwE6gNGuTB8lHgXK3La8l423mebhyftIuq6Gdj69ohiKUAz9gmHNLwnFIa4xSzURRJ1r/CkNKvcuMAI1FzAmWU9leewZ+2RJjSvSZD3YNGvH4qD21EYM49TOBZoLBL7OvxMziDdD6l1t70L31920Zde/011QYcMI7+Mb8IA4uHuPXPmRHIDfgHWFQl20x31495+dDGLrlt0WcwWiyqValyScNxKk3oXmxWIpirBt/1K0S9VeluV6cwlbgS2X5jBeI0TRgwIukQI1PiBv5LFBUFY4HKyhdtQxp7PgP1XgJAdpFwQ7JBeI2Vzx/yCmf2l2MSAxfNah9OrJV5SDAvjm7tUbOck4uaCDC4bi3mXdNCoMKBpphsfCwFNkwuezODwwbcteBR+3c14dfkUrFbfHvj6bSNBFQMOfxRpk3gnWTMAhC4xnQSGLvLvZm7iLDNkdRs9rF5eX+YORoVuihnc2ymxBXeQ7IBE2YhXUZYg5pbNh
 fID206B7
 B/+yLGunEbejLcNyqebMSFkq0bJ33ABxIf1R0InFhPRbPn7UrONFq3Z4PrsB5Wn3PxNpA7PWYxYVyi3d1D/nIf2DZZnJqX1C0xv316FuPYHekadiGAg928d/im96NER2n7m9KGj2Y+E53AGGRToOFA+0iZADD46b3x/kP1Iszlj8pfseo5837LxtX1YRQ4TK6dPUKdQVU1lkE39q4yJqjlLq+wOG6KQwH32SiQ+IVGOP+Hh/EeAf3SZ7fCF8N17J6yMYJKf3I64mGi3DImppX2sP8VAmGHeTs3uOd6KlS1P1vneGykXLmBsEgDrAXFrpXpSbrh5wVEwB6EpiyCpRXLTVLmeEQw3DbCCOp8BRNJyrA7pc+eNIPhmFjRrJ6GsWZ4lPdTBo4R6ptNIB/Zuo5djVzbEie+/Y/qV08wKHb8gHGXNO0ipqlBWJ6j/6mXintfm4Sh8tGzZr/cX7ohjKzX4BoF/9O7PuAEdjumA9gX0CGRFe90gc0wkmr+lVUQH9VR3T6iNIvR7OqNEv1Xpy1P1cMeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

smk_copy_rules() allocates rules with the gfp passed from
security_prepare_creds(), which is GFP_KERNEL_ACCOUNT. Specify
SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
__GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Path: fork() -> copy_creds() -> prepare_creds()
  -> security_prepare_creds(GFP_KERNEL_ACCOUNT) -> smack_cred_prepare()
  -> smk_copy_rules() -> kmem_cache_zalloc(smack_rule_cache)

Assisted-by: LLM
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 security/smack/smack_lsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 8e88ac65fd7f..8a802578ac29 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -5352,7 +5352,7 @@ static __init int smack_init(void)
 	struct cred *cred = (struct cred *) current->cred;
 	struct task_smack *tsp;
 
-	smack_rule_cache = KMEM_CACHE(smack_rule, 0);
+	smack_rule_cache = KMEM_CACHE(smack_rule, SLAB_MAY_ACCOUNT);
 	if (!smack_rule_cache)
 		return -ENOMEM;
 

-- 
2.54.0


