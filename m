Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72ABEFD4F0F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 17:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79AD66B0098; Tue, 10 Mar 2026 13:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771F36B0099; Tue, 10 Mar 2026 13:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674096B009D; Tue, 10 Mar 2026 13:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 407266B0098
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:58:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D35361B7303
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:58:18 +0000 (UTC)
X-FDA: 84530912676.26.8BF323A
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id F2199120003
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:58:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="Fqx/FEUj"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773165497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=e43stWVIt/gV4fTuEkK6b3XE5CxzUgflCtEqccZEgaE=;
	b=o0QnOQpkWzikaH0D+kcOrYHnzOmFVE4Lwp4I0kfb2PihZ3dSfoxWcHCReDEsuOuyVE/1M1
	mLUO1wLTMG66h39l6L9+ebg7ozJzojSbe+3/Kv0bLuLgrJ8WJl7p1yDryM2eRAnbuIx/z7
	OffXY6MHbW/yhB/BAaOT1fG2XSqEntY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="Fqx/FEUj";
	spf=none (imf29.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773165497; a=rsa-sha256;
	cv=none;
	b=ny+QyHx5sZEECAb0cWE7xoUYdRVfJgOsXXXdu8Dd7PB4fAXHqLxh/MPeqdoVXhNJTz/5vC
	6VxwaQ7eRWgein965+1eU8nIMHa0J6PDy/wArfdDBumesV1QoIxOQVtl9Qan5nSumLG1Ku
	3DFu+wgoH7SpWcUhRAGvlAOIMb7aQdw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=e43stWVIt/gV4fTuEkK6b3XE5CxzUgflCtEqccZEgaE=; b=Fqx/FEUjI8yutWEVaYVi5bHwEk
	e7MYjVrMersnayKWHlhiVGRH/LBBFk2AX3zM4vNMwTMHCVUYOPhS9l7TF3geRkxzshCLAp5XfDp2s
	8a5D8vKogllCOGJXFrRDbwNzJr6mEQ0Dhas0LwWzKKnKtmoNelvFGpft6ii1nLo6eSmQdzquJm8xN
	JlSXv6sNqXsRwkH3ul1wU2dXDNoVWXfvnYJcLl+kPkDole75uGweOlYyRKigWXeeOKHV3pFWc1rgA
	iaSlWyFbFEeXgEaBVyCiJ+CnJwzh6ZbWUCzZJl7lGuVUqOsM4iYEWYCNxPyfmN5bqL7Ym+DzOqTvc
	VYlfeOFQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w01L7-003AZM-Jv; Tue, 10 Mar 2026 17:57:55 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v5 0/4] mm: thp: reduce unnecessary start_stop_khugepaged()
 calls
Date: Tue, 10 Mar 2026 10:57:06 -0700
Message-Id: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHNbsGkC/2XN0WrEIBCF4VeRuV7LxFFXc7XvUUrRaBJLSRZNQ
 8uSdy9uKbXs5cD5/rlBiTnFAj27QY57KmldoGfqxGCY3TJFngL0DAQKjYTEt/n6+r5OhaOyQXu
 Dow4aTgyuOY7p8556fvm5y4d/i8NWfV3MqWxr/rr/2ru6+83Kv+zeceTKIhnRGScUXUL0yS1Pa
 56gdnfRStVIwZFb7cmFs1XGygdJrTw3kjhyJ1UQgxlJG/UgZSttI2X9KbS3RiIaiv/kcRzfIeW
 Z7GEBAAA=
X-Change-ID: 20260303-thp_logs-059d6b80f6d6
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=3252; i=leitao@debian.org;
 h=from:subject:message-id; bh=cT2sOaFtawOcE6NecJK4yZ2VuHWTUuS7G1H4o50g0w0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpsFuaZIVXuthS8XcxawntaC0RPXkIy1kPshiAk
 eub5UVwHnKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabBbmgAKCRA1o5Of/Hh3
 bf3tD/9Y43G7y1j1uPcbAWz8YhBtfnSlwNYDSpgbKSJ7ARsndZIZMGB/59uobQ5Q/aEWJ8thhdy
 FtrAjhpIfnNWUNLNnahOiPyv7AGcXQBs/YwLNjSG5cYVZi5/1PWh7VNqAStgI2gGwAyTUStCvfH
 GLkhFWiB/3u4RW0w73N3BRMzKWsiyCy/PI3eM4RDAuLFRh9fUgCDiEMeMC8zZ1sZ+fz/Ni/HiJM
 vc19puIW0Sx5k81Z37NGf5Eim0kMVDO1lyxbEoA//3x2wlNYVjHJ0ZG13f1fTiRiulPNAzI9k6M
 jY/QIlejJupuR84EH6SL5Sf9GG4cECjO4ID7pCHIzs0mHD2l2W+Lt5s8gk9J0VX6iPxkT9tBNs6
 Lf8ithbtn1etci9ZgJBnkW/ZveVOqWv44VfgKQBZ3sEazvwj/46o4KsxIDW4t80ezNxkpoCtDON
 Pxo5+vTqIjMipq1B5CqBUWlCmBH7n+M0KnlZYToH+/yKd4eQJrsbgvATo5kxgdsgXvSXhud3pl7
 v45mkZJHPPXheUsVFPqYLdN0fT+I77nzhUKjWfkimPTyiqN4FZjjdvN0MAVQNSDMILd0VP7JdDE
 hhWNh/XR4nTbyYSX06PPVX5XehBQd3pDRcSN+K+gWW0N46YnNfgec4+29bM2UAuHLrrvCEycdA3
 5uOJuV/2JSYIlbg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: F2199120003
X-Stat-Signature: ec5zy8bqxz3yw9eti68qicwtnmoxw73i
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773165496-251250
X-HE-Meta: U2FsdGVkX19DYsFRb2ee3oTeOsYxJkZAR3XJsSHbLwcPF2lwePSteMvm3xP+sncOsFjc72tlSfEC8H7k17O96Mc2sffkZM5YEVK//GgZlWPHgM1PXi32nBTVqBjYkm1NuorXVxlhBmSui6qIg0GyAX4CMt5UfK647xcAbobkHnRGC8UMBbJ8BfY8ix8Zk9Le0ctAf9G0rdY+6U6J5pDV6KKl7xV+X/T6IU/4P86PBLHNxjGSGcCkBlsAmyAYrq5zl16y2ZGJ3H35ybrIthpkL79Ab3lRKLcq5GI5qkUXBuBaV3rynGb3bM/67Oq5BxsRYf/fKvxLamcQQ95cA0Vs9cCEirfgsSOb8q9MxefFy+kzpoJWcbJao0OEsXL9vmSe+/LJy8S/4G1n5GeWIxug0AO7PYZe4TQAPEKJGa8sK6MhX/02jOsFeodz0xWuFdQpAWSgwwUuoyxGUsZ2yE3STpbVaPgnR9+LEtkDl8KaiLCaF47mNXcoJY/d8nLZ3QT+ajBiSfhdBAMwoR+CDQWdAXeDkSOGGoA5K56Ku/K4JJeeUyWirGeCYwk9QOSMsfF9WdCP2pA0Q/QzBT05j3jX2EOYXA1sdrMvEkRR6RjZ/xWErOC+8+nJqAWMpGy8+cYbfOQPgwv7ekBtdetcUmpyp+hHpiS5BluM+L1AF7kn+GRqrwqVCLnBzqybVvNKzqRxbnoNtu7a8jnmgcOXNo2mZbmqrJP6XtNt4SzGGiV1Ilp0LV7hZjepwa281rgiy3OkE88SfFjh6LfNUxlI4nqGHP7euSa9oBK63H7W3+07GXtkvEiW/+eSH6beBiM5NcuDamGoJFVXMSRK++fBC7Xq8R8v42z9nnt9sMwOEA9Z2vMaoILLhZN1AlrjmATyyyONRMZjH7yk5eFK51NGUyUuS/k85v0PKQcjMLNvcHe26pH4FADk+q2zKqRvHioF5XFoPHXIPM/vcN9g/om9Foz
 VKX7R2mN
 9hc3aa4Tf7CWxckSkShqOOHRAjt9CLESlvTYIAT5ijgPd0Gihvxv0MquRetQ+k+CELCpWw5ynlH7FTbv/QbFF5xZLtX7nj8GMx7zBWLaXPoD6ChUOPEsykxXkXdzAjtpQMJEG2hNfvY40T7nhHszHaxGal2muu2DLvgqQJgYLkcGNI/27/IcaUGJlx52CZpqwhfBEKKknUk9+LLaJqz1kEz+h1EBM4JrYl5WhYNCst11Bhq7xjtcfozaJPpVaoUkwayqXMsbyr9W8e/crJi84xMn3pfOwTCccseo3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Writing to /sys/kernel/mm/transparent_hugepage/enabled causes
start_stop_khugepaged() called independent of any change.
start_stop_khugepaged() SPAMs the printk ring buffer overflow with the
exact same message, even when nothing changes.

For instance, if you have a custom vm.min_free_kbytes, just touching
/sys/kernel/mm/transparent_hugepage/enabled causes a printk message.
Example:

      # sysctl -w vm.min_free_kbytes=112382
      # for i in $(seq 100); do echo never > /sys/kernel/mm/transparent_hugepage/enabled ; done

and you have 100 WARN messages like the following, which is pretty dull:

      khugepaged: min_free_kbytes is not updated to 112381 because user defined value 112382 is preferred

A similar message shows up when setting thp to "always":

      # for i in $(seq 100); do
      #       echo 1024 > /proc/sys/vm/min_free_kbytes
      #       echo always > /sys/kernel/mm/transparent_hugepage/enabled
      # done

And then, we have 100 messages like:

      khugepaged: raising min_free_kbytes from 1024 to 67584 to help transparent hugepage allocations

This is more common when you have a configuration management system that
writes the THP configuration without an extra read, assuming that
nothing will happen if there is no change in the configuration, but it
prints these annoying messages.

For instance, at Meta's fleet, ~10K servers were producing 3.5M of
these messages per day.

Fix this by making the sysfs _store helpers easier to digest and
ratelimiting the message.

This version is heavily based on Lorenzo's suggestion on V1.

---
Changes in v5:
- Used the lockless __test_and_set_bit() primitives (David)
- Rename the functions and variables to match the code (David)
- Link to v4: https://patch.msgid.link/20260309-thp_logs-v4-0-926b9840083e@debian.org

Changes in v4:
- Use the enum instead of int in the new functions (akpm).
- Explicitly initialize the enum values (akpm).
- Link to v3: https://patch.msgid.link/20260307-thp_logs-v3-0-a45d2c8f3685@debian.org

Changes in v3:
- Extra ratelimit patch.
- Create two enums, one for anon and one for global. (Lorenzo)
- Remove the `extern` from set_recommended_min_free_kbytes (Lorenzo)
- Export set_recommended_min_free_kbytes() definition to mm/internal.h
  (Lorenzo)
- Link to v2: https://patch.msgid.link/20260305-thp_logs-v2-0-96b3ad795894@debian.org

Changes in v2:
- V2 is heavily based on Lorenzo and Kiryl feedback on v1.
- Link to v1: https://patch.msgid.link/20260304-thp_logs-v1-0-59038218a253@debian.org

---
Breno Leitao (4):
      mm: khugepaged: export set_recommended_min_free_kbytes()
      mm: huge_memory: refactor anon_enabled_store() with change_anon_orders()
      mm: huge_memory: refactor enabled_store() with change_enabled()
      mm: ratelimit min_free_kbytes adjustment messages

 mm/huge_memory.c | 147 +++++++++++++++++++++++++++++++++++++------------------
 mm/internal.h    |   5 ++
 mm/khugepaged.c  |   6 +--
 mm/page_alloc.c  |   4 +-
 4 files changed, 110 insertions(+), 52 deletions(-)
---
base-commit: 9dd5012f78d699f7a6051583dc53adeb401e28f0
change-id: 20260303-thp_logs-059d6b80f6d6

Best regards,
--  
Breno Leitao <leitao@debian.org>


