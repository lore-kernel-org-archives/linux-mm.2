Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896E8D39013
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 20:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980D96B0005; Wed, 14 Jan 2026 15:53:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E7E6B0089; Wed, 14 Jan 2026 15:53:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83A5C6B008A; Wed, 14 Jan 2026 15:53:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F8166B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:53:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6F4AC239E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:53:09 +0000 (UTC)
X-FDA: 84331769298.11.3A5EE62
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf14.hostedemail.com (Postfix) with ESMTP id 14134100008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:53:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lRGxO3oW;
	spf=pass (imf14.hostedemail.com: domain of 3MgJoaQgKCCkGNSLONFTLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--bingjiao.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3MgJoaQgKCCkGNSLONFTLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768423988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3bxOGWS6glvYwDy8bUAmdDe2eUabDyr0vbAJE9zJUk=;
	b=davR6daxKkqXxib7+VdIvhBs8MXrxQTkEIN1KKqzbVZtUTHppxQpP+aauaoUNq97ciI5Pu
	E8oGs14EaYyZ1DtzIrZUeD4RYtbfPLm5HlHCWO7NknKA78Nhl7uQpsFVsTbHqkKjwomt6L
	hxgvgC1Z9K4/1oOJwG99uALCBh3wwTQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lRGxO3oW;
	spf=pass (imf14.hostedemail.com: domain of 3MgJoaQgKCCkGNSLONFTLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--bingjiao.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3MgJoaQgKCCkGNSLONFTLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768423988; a=rsa-sha256;
	cv=none;
	b=vKqUtsDp5ea02PL9dVLXmsT34jMoEDY1rczAFKsNvYt5p/nXsD3aF6xIAOWNkSzVfXxVfi
	dP01lh4y0NEN2HTutbqRt3ftfZMtgshjNicUBPLBYmOrje+y3MjC9w2rz2MbrBvLJZaWxo
	Lls76KiY6gMjlac5dlsLIrohgaNRVtQ=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2b21d136010so434717eec.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768423987; x=1769028787; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s3bxOGWS6glvYwDy8bUAmdDe2eUabDyr0vbAJE9zJUk=;
        b=lRGxO3oWM4sIF9ppNzH8JbuQiCYWjZfpFaBoRnf1EXy/lQZe8eQD7aDxkFaexYFXS7
         CaQiFVQxv5G0pnEezEGd57rwoLxPvin5nWRnE8LmAi98uCPZ8V2S1TDhHnlyGgQMvG9G
         5YNZUsCm4+qPsR9Tl0H9Xz7NB5m6xwMKhP8rscPLDNl62VjpFN6Gkl7FRmJBj+dwZdDo
         cFX2McSBRIOmj3crkh/kYsshNt8tRxg9UVTlJxmrfs1XkioGfS4Le+PTTTGc18BUMGo/
         dB0O8cryyUiXwmdwzvAaZIMjdC7h3x2z4QCnAgk8spMNM8ll4ZJRasn6klzTpctr1VpA
         zwKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768423987; x=1769028787;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s3bxOGWS6glvYwDy8bUAmdDe2eUabDyr0vbAJE9zJUk=;
        b=bh/pGjGwTi23sogSMe21hZM4hwHGKZ4TfIu49wq7RWNyf+F361Xl2vQ17079ITsK7+
         yhTykXiMi+PCY020zU31qqtaoAY3xjmHaVlRAYKfmoIiksCTvYkTG+A08v7oZ8WkMOxq
         mQ4/GrPGa+7SI2u1Gs0GX/g1I+j9jnsnen53x5xDJWTU7T0UmyYL5JIIKb24m1HWJ7o9
         LxqsV8nLWcQ1i9ku/Z0EDTbU3FyEo/8L/nAa2NIivjt55BwdCIhQXlC+aKWfCJsQwhFJ
         NFLMBpZqiB5LPTgSnOqmuaNuDi4w0AiuEpnPKWeM/vJ333TOuySuXVFa4C+Ka+cDXqEj
         VNIw==
X-Forwarded-Encrypted: i=1; AJvYcCV7gl55g7gcowxC7JEy4ccA6ooppnU7YpPOxmOIGeblphMiygVog6r9eiLxIpsLNMOf9xGkZ8so9g==@kvack.org
X-Gm-Message-State: AOJu0YxpRsdN0WFb3nReKi2rIuefV2eS9dbQRzXIkRhVq1VMiBhHdJzy
	ocFNCSrJRGla2XzMdWtjIL0r2X7B0ewD7FqMVrV4O6aSvyp4ySp7pyDOy0jThitVOia8//UIUS4
	4nDpKTGVANYcTuA==
X-Received: from dlbcy2.prod.google.com ([2002:a05:7022:b82:b0:119:9f33:34a6])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:2206:b0:119:fb9c:4ebb with SMTP id a92af1059eb24-12336a67917mr2995405c88.30.1768423986476;
 Wed, 14 Jan 2026 12:53:06 -0800 (PST)
Date: Wed, 14 Jan 2026 20:53:01 +0000
In-Reply-To: <20260114070053.2446770-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260114070053.2446770-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260114205305.2869796-1-bingjiao@google.com>
Subject: [PATCH v9 0/2] mm/vmscan: fix demotion targets checks in reclaim/demotion
From: Bing Jiao <bingjiao@google.com>
To: bingjiao@google.com
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	tj@kernel.org, longman@redhat.com, chenridong@huaweicloud.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9wmhihsyiw9uwr48w19t63nq68j8kuc1
X-Rspamd-Queue-Id: 14134100008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768423987-416532
X-HE-Meta: U2FsdGVkX19XLw6Ct6j8gUevN0RaExo1+LoHot8HjScFsp6hioUDcjWeGRuoVEWSEplfmvwT7K5IeKZU5+QAUhC3OSqTGK8xxPJQ8J8ed5eZdnqaep51nrUx9i04KRmFYzshxzENcBntAG/C6pCLsyM6PDrqi7z88PlnG3FhElAbja8bsH1nPQOy1kgvkTfdDucELe5xnepwhE7FVA2ljySMOf2VmyQIzlJEh8LKmLMi4lF3NHo3QiqRKMtDiY8fZOq0RR162A8Ha4MesU+ivrubj18NH9wTA8mMtVAiWKbO15/CqLmhoQ4X/u74DTOXZ9r0d7SJwjYsJu/8IfjLoJnwHnWmaGhfEdcbgNB3yi/HBzcZn2aZFb1PlJrZ8r0VuvoYcKRIqvSwj+dLJC5qraJXBVAqPsmTGdFGolJbQZjhEYQQm5xXPNUtr8PhoMvAgNGiwHCmgnzL4YqdhS5vfPsNw/0kjIm4B3ISygmdxMsLUmZvSSMJow3eo6ZYnDbcvuHXz1kltCBBkPxE3eg+xJZie+zM0BPsiOF5bPHZePVDS6827PYGNuOoDneRo+Qv+1kydWdRpJoNxYovGv+TylXhvZTx5B5Brib5mSjcH3yTcTArxdzR5+RKVEjuYtheuI2dmPP4xAYLUd6dPbbhg3OtuMzzmBFD5F1MfQmKDnZjzgq2cX9/HqD48KbpMeb0k1lSXsX8+wOAr/kdKa9mE6nygbzNrSclYq7D86nE1VFEA95Fkg7z5mTxQEMtp8tjV5CI/sgkVOocmeoi4863iDSvPLdA6TMxusty6Z/LTkpev4Ax89O+qSPG2DuYNJWh3wlBU+GwIk8v3VmJaIz6TyrcPbQGFvHRqPIpl/sgvEPt4HdITuSAo+IX0AIBJvWwVKcDXFEtXR4L4VYpwqvyOQsR2/wpW8Gm7ZcbMDF8+sx7qg3ANWMfaRBpciqMAV0RsLoOicqyVKu7WsCobpd
 2Vtorq5J
 NT50S6Gmw74JNEA8VBnPgkCkVxYXNTkG7ir3sgz3BpJGAxf1wTFP9CQkiRf4wg2VH31zzA5JqPLERnINRr4FniyzsBqZzmfkCcncEAxeGhg7o75NsQZAxwloekBJFTABGm/yy0gvmNjTHxgNFK7DyX4jPSxJ+s3LQer7eGaqNnoc6+ZClJ42DJI9dtyTBYs5hMIDf05nruwRmClci1GsoZqbDE2mNTwpnFpJ0FilW/Y37DvRm0r/rcySwP6zD8+edGManLugHTyuOaVH43/0/NiHVkBfEopEVwLFRYt9Wc1eQOGcNS7BQKMIqlo7szvJ+Yygvtu4N/r+Q4oDY8ccuZRHYDbEE6HYyaE31Y6fWvNBXEnlqaIHZkWozUElp6O4viRJTuqLAW4K4YnsfkrfwV3cCt1HGMTlRg75EZOeB/QUTas8nT5yR9O/hXn1u4kL3BwCr7u+i87AZfMcWhvRBE+WKIJW6WjS3luZwGRGrMu28Jqu+3LX7Iw8+bBt1zEVvuzgPzTuH1yy8rI1vhZp3oZTBLoGuTKIua+iFTNM7VZrD2+lul4/YvzCyj6BRiczx5OqImYUeCxHIp4qtjcsVenNXavj6lIGHT0bWy+c2B9uNq15TSafQfJdXjnte+jlgblf/Eu6IzSkjR/o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series addresses two issues in demote_folio_list(),
can_demote(), and next_demotion_node() in reclaim/demotion.

1. demote_folio_list() and can_demote() do not correctly check demotion
   target against cpuset.mems_effective, which will cause (a) pages are
   demoted to not-allowed nodes and (b) pages are failed to demote even
   if the system still have allowed demotion nodes.

   Patch 1 fixes this bug by update cpuset_node_allowed() and
   mem_cgroup_node_allowed() to return effective_mems, allowing directly
   logic-and operation against demotion targets.

2. next_demotion_node() returns a preferred demotion target, but it does
   check the node against allowed nodes.

   Patch 2 ensures that next_demotion_node() filters against the allowed
   node mask and selects the closest demotion target to the source node.

=3D=3D=3D

Hi Andrew,

Sorry for the extra noise in your inbox.

I=E2=80=99m resubmitting the full refreshed patch series together this time=
.
I just realized it is better to include the unmodified patches alongside
the modified ones to ensure compatibility with upstream automated tools
and to simplify your review process.

The refreshed patch series replaces some commits in mm-untable,
including:

  - Commit 809cc3db1831 ("mm/vmscan: fix demotion targets checks in
    reclaim/demotion")
  - Commit fd8cb9a8cedc ("mm/vmscan: select the closest preferred node
    in demote_folio_list()")
  - Commit 127714c76c46 ("mm/vmscan: fix uninitialized variable in
    demote_folio_list()")

Thanks!

Best regards,
Bing

Bing Jiao (2):
  mm/vmscan: fix demotion targets checks in reclaim/demotion
  mm/vmscan: select the closest perferred node in demote_folio_list()

 include/linux/cpuset.h       |  6 ++--
 include/linux/memcontrol.h   |  6 ++--
 include/linux/memory-tiers.h |  6 ++--
 kernel/cgroup/cpuset.c       | 54 ++++++++++++++++++++++++------------
 mm/memcontrol.c              | 16 +++++++++--
 mm/memory-tiers.c            | 21 ++++++++++----
 mm/vmscan.c                  | 31 +++++++++++++--------
 7 files changed, 95 insertions(+), 45 deletions(-)

--
2.52.0.457.g6b5491de43-goog


