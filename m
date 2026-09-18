Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26926C982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 02:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96666B0093; Thu, 17 Sep 2026 22:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6D0D6B0095; Thu, 17 Sep 2026 22:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAADA6B0096; Thu, 17 Sep 2026 22:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBD816B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:56:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4938040585
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:56:30 +0000 (UTC)
X-FDA: 85225369740.06.F195A62
Received: from mta0.migadu.com (out-97.mta0.migadu.com [91.218.175.97])
	by imf16.hostedemail.com (Postfix) with ESMTP id 09295180003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:56:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ghvlcicp;
	spf=pass (imf16.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789700188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qyd4Ov1S1ewbh+ZPypwCtIfRJvaTjd8rOo/4nJeK3og=;
	b=Prm6j4gD/ZW2K62ERHB0hlAD0lxHBNdLvmo390IAr3zJYlfiqEzCJiuchE82bwgSGCdcF7
	vpsjxtRmFeszSwdnW/iqJestGsvew6ub1Z8fOT4oGHTxhymaJSfvd10539vhDHp7HhPmmL
	sUue4Ab4ikaSr2ab1oC+P6gd+/qtP2A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789700188;
	b=GMj0OUFrAor1BO/k6Oe22uGzp2rBBGpOnWZ9wN6YHPi/PWZzYlbc1ociCktnDp92tfFUyt
	3qst/X7FNRqBGiGbsdfW7U/1GQr8joY2xOkqaXcpZOkibdFiB8R0/HJkF/UEGjMT+GJ3LN
	RpZ4JNC+5eAfaikOalibka7AbdzU9HY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ghvlcicp;
	spf=pass (imf16.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6olkN3MFF993IEc0YK161XKRjhyK4yyClEXXjugfK5U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789700186; v=1; x=1790304986;
 b=ghvlcicpnL0xK6UZMXLU+bpHh++qH/SG3QP7UX0sOAowfd/zilH1uNGyvCPi+rV8DZkKdkZA
 y5/wf+xDrwyf74CR0n3DqLWnjfqB69AmrJiykIryNfVuqB6d4xp/nu1V+JfGsnkvHvpG4FZnxZ6
 gCC6BcNy0/JgouMC3TP+uNsk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 97b504da42608a61;
	Fri, 18 Sep 2026 02:56:26 +0000
X-Mizu-Trace-ID: 97b504da42608a61
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Subject: [PATCH v2 0/2] mm/hugetlb_cgroup: move the per-node usage along
 with the folio
Date: Fri, 18 Sep 2026 10:56:09 +0800
Message-Id: <20260918-for-hugetlb-charge-v2-0-2b6d8c2bdc36@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22NwQ6CMBAFf4Xs2ZrSIKAn/8NwaMsWVklL2kIkh
 H+3YLx5nGTemxUCesIAt2wFjzMFcjaBOGWge2k7ZNQmBsFFya/5hRnnWT91GAfFkuGTIbSRray
 xLQqENBw9Gnofp4/my2FST9Rxf9qNnkJ0fjmqc757v0D5LzDnjLOKG1XxWgks5P21DGRdOGsLz
 bZtH90sTlnHAAAA
X-Change-ID: 20260915-for-hugetlb-charge-2cfada8ed44e
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, 
 Colin Ian King <colin.i.king@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, hongfu.li@linux.dev, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789700179; l=1456;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=6olkN3MFF993IEc0YK161XKRjhyK4yyClEXXjugfK5U=;
 b=jQlOWteG7im1UP87y0ch6aWT5/7TKFYwrPyD+MFHD+aPffzfHC8yMSAYwnJ4hpniRNVsUb3yO
 VD73DczGDh5B0oo1EvbsKypHa8PkjLPR7iMjM7nmjT0GMBLjPHoUESB
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Stat-Signature: fqmgabjb4m3iydwinzn493chauq5kn7k
X-Rspam-User: 
X-Rspamd-Queue-Id: 09295180003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789700187-133662
X-HE-Meta: U2FsdGVkX1+8O4+koWIuLrzxoaxND4n2e2krONEmPcYMYYD3YKzgoar058NGWTdzvIwlfyPGN+GQ/YfKaVrTUDcmmYYCsBchbHagJbm+8EsXE8jOmhok1lJaZ8OH2ihol4BpMAbryKNY55AMCkmoGyTAtMK45hgp9VqZphKk/+6xJrE4/004rRyY/H3hllaL1fay4PlCUQ+dKCSXJ32HMSHeNw/+XA7K8wGZMk6+pk7IONTs7TLJnARdWxNsgdz1aeBCEdi4HpQ2InI2co0JDd2tOfmgv+lCTB556RUAir7U7B1fsctPP778ewCpGgEPojY6bl+DgQ9KjcrZ+gj4YYhgKzNIh7OklYhgu1oJNZJkA/0HmpZh1yaD7kPr8HDv4jRsb+RGTVbfMCXdeGPQcr6sYn6Lx/28nrHZc7XNCXxipPjZZ51OPEq8/HbOntN8GYdY2JT4aEzZDdgEPkUJRH1nZseLjKiICbgvff4NuukIp5sadgmvI+gCXkyWoKdcyr2fba0yYJuy7Os6Xpe9KDL62++j0oGwu0ll0U0jvl2C5s2OG+D0VGmjD5tFD9cRWuBDvs0yVsvS+uoRFt1TyGYYH+uQQv13divvaGKNryj0Eg3O+Kt+MzPw+qKnS/Wz/C5naYtZRwoixePjNvI0cLl0Y0wHqs6yzUrk+QlJT1T7ohA1F/CwK0DkAP3Hum0eJCIVz4slOfo4klktCfK0lLGQlcNp/Wb+Z1k0c87nJsEqxbKWG1fscmIKLSEHwm5THIlGR3nKH4GD/8VW4B19XeEXKXITUfBMNrBTwQ7NnZyNAOIZU14kUYxLwvcTcO49Mf0qo1KYctOHa89MWXWyC/+BUl78bQX0M+lWxGIXLs2SYiSR94b0FQqkLlTdEfKXWAIsoAdrz9v69O5nYlUAgwEojhJqpWtIH/T7dJ5gHdlwcRaUw9fVjEHoOA4RvDleWeB6hlPq3QwT76ffyPJ
 8NdmcAxt
 TwRRz2ri4J5My1Uq3PwDBcjxSNQ7YmJqgwxSMyq04aGT4/Tjg0XIe6xTG4pjp6bBkh+g7IG5G0ylFGkwpyXyU3bIHDraKmODj2zhXQj0SKVVM3QJNw61IK6CCGGwIk/uIwgA4ga0+12Ec3SzwO3wWnyl6BTdfBC8coKQBuSfL1VzaPM5ssj3OCvhQD2cjC//9xwwYPl3/piGiPykBseGp/e3ITy+Yc+Ur3O8GnzLOUs5Cwj5pHm+PJE5n7opyGVqE7L4Aa1RzEpDti6b+YMBzXwlBgAwQve/dDjSayW0ca0w1PXw8uJ4rnlrIwDqCAMtmow1V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The per-node usage reported by hugetlb.<size>.numa_stat is accounted
against folio_nid() in __hugetlb_cgroup_commit_charge() and
__hugetlb_cgroup_uncharge_folio(), so it is only correct while a folio
stays charged on the same node and in the same hugetlb_cgroup.

Two paths move a folio which stays charged, and neither moves the usage
with it. hugetlb_cgroup_migrate() only moves the hugetlb_cgroup pointers
of a folio migrated to another node, and hugetlb_cgroup_move_parent()
only moves the page_counter charges and the hugetlb_cgroup pointer of
the folios of a dying cgroup. In both cases the node (or cgroup) which
was charged keeps a usage which never goes away, while the node
(or cgroup) which ends up uncharging the folio underflows as soon as
the folio is freed.

Patch 1/2 moves the usage along with the folio on cross node migration,
patch 2/2 does the same for the folios a dying cgroup reparents.

---
v2:
- Drop the unnecessary READ_ONCE() in hugetlb_cgroup_move_usage().
- Add Acked-by tag.

---
Hongfu Li (2):
      mm/hugetlb_cgroup: move per-node usage on cross node migration
      mm/hugetlb_cgroup: move per-node usage on cgroup reparenting

 mm/hugetlb_cgroup.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
---
base-commit: baa8de2f3448d1466a888a805c18d01c998fe052
change-id: 20260915-for-hugetlb-charge-2cfada8ed44e

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>


