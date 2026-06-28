Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BA1DC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 06:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 013276B0005; Sun, 28 Jun 2026 02:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7BB6B0088; Sun, 28 Jun 2026 02:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58CE6B008A; Sun, 28 Jun 2026 02:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91FE46B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 02:15:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30736A034A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 06:15:13 +0000 (UTC)
X-FDA: 84928308906.01.8AF6EF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 516611C000D
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 06:15:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1vMfiFGz;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782627311;
	b=PsbGooNrITDovZDNWsdnuCeXe527RYQIGtu7LZrkb6+IuzYbysTfzh/0JAJOxCm1Bav785
	xD/ZB6nYRDLoBYH76lX2j/TZYYyyyFcynaLOkv0/lbouBjRFx2Qei79UbnvUlusvGoyw6z
	4pUeVwUDXUky019QZfpkYT44SYid5cQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782627311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkkL8K8aCSzDTAg0nFKvhBKMX/LzxqzMm81D3QZBmr4=;
	b=hYPp276UeFHk+VKUUmq4nAOTFim4RCDCBAJQHSxwJ6UvtDRKG+l1IN0MXbiAOhp4iPgUys
	0NZWvddlKWbFuan7cZdmHEKoYAREKDC0qpjyEyHh8cbcsJZ+B+SPCWAiQSzJWQ/3PSswfV
	LvCd91yxnVcyKKzsE0bvzsgQUzboBto=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1vMfiFGz;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E2919405C5;
	Sun, 28 Jun 2026 06:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218AA1F00A3A;
	Sun, 28 Jun 2026 06:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782627309;
	bh=VkkL8K8aCSzDTAg0nFKvhBKMX/LzxqzMm81D3QZBmr4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1vMfiFGzpFlK50ISLwhCIpnGS9/F4F53x4sETU7muK/IHh6I3XuS+U4DyKjnWFoWw
	 G5L9rq2Od82BJBKBztldCEdnToq6i7OQUPtbk2bm13prYOTs8FY0RjChRuso6mLVol
	 Tb25ONWZT0A7AxNY5UINAxc0zd+bXLCqvWtk9MM8=
Date: Sat, 27 Jun 2026 23:15:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Waiman Long <longman@redhat.com>, Farhad Alemi <falemi@asu.edu>, David
 Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>, Yury
 Norov <ynorov@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Zi Yan
 <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 stable@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup/cpuset: rebind mm mempolicy to
 effective_mems, not mems_allowed
Message-Id: <20260627231508.74201ca47c883507be97d8c2@linux-foundation.org>
In-Reply-To: <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
References: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
	<CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 516611C000D
X-Rspam-User: 
X-Stat-Signature: o8884bx1bmqg3ttoidmfs7f19sjsjudr
X-HE-Tag: 1782627311-172418
X-HE-Meta: U2FsdGVkX1+3WoppkrQ9XukpOj+YLTgY91X9loPsIvzp/SLwnFbwBhUvPrvdBF6ihO8MKIyGJEr3tLkwqO0NIuKNZn+wFsXYIKo3WjPjb5pSa2+zEL/z8LaOiJETI/m/3mCl7NXBSg3RsqtVTSedWX1uS/2PLyXkBNGdyMcTVL64i54WanSKD1RbQTAIpcX0V5/3dVEk5pa8yIH8yvR8gu/9e1zNvO0PKVP9KgzVDH+dIkHV03aLCcxzcZycrkfeVGW9ywig/wpOfQVOqQ+6UZooKA8kcLuM5aO/rlhBFHdPgJyX84rbT47GDoNdCmyfT0DdXGBDJoygrj0ZKp9UGmrASrI8INVkbxDlhdSTe7t/KbWnMPhQdfRTwtxtK5IKjaPa/jsDEfwfN94ziOFTf4aUVXMlEWzTOuss9DkcvugfytfJb4QKsqzcdCs18/WpIBo90R9o7DlBfUqMiJqJRCtyLU1UBLdvZkeKPAEAlVO6aYO+9P0VgyRHi/z3VWGoGFB0M3rDDu//tbSfe2S1xlJtTKcMSBtM1JNLmabC9d+fF0kQGx1UHVUUqHQN4+01IGZ6RexJKDJzuzXZg2EEC2y5hdIHI+qD828gHgMAyT2N2trP/EfUo26vUx3jhY1LVt4gUgx6BMH7KDuAGRQwGiQ1iTMVhb3OpeHl6kb2R9fE+nUJgZgXUN+RuFRVhqUQYsq4h93vCWfYZTLDWLzYYvbHmngPFYeJKScQucizvK8XA2KgzX09wNt+2Uj8Vo27TJTdp3KNPXNLU+/Z8N/eTrKRfSvWzWWzl1P2JplEj++fN3d9f1fhmJnUfOE1smQ4pnouYFzE2qYd0IQV2MCqNMhVonPauLzZtE5Ku3mFmVTvwGvDudMOxTElKjG0nyFTALbd4MinLi537mdCi6zPMdcHo2FPvd7wXFmmvHXbJ5X3GH5W0fpi9GGaNNXAwSoGRuMwdil3vFUQbueODWf
 K7cKTtzV
 XKrJ9marydKNQC0rTtniOLzeqQ2fBwI6s1qWVBCMmo3+PbUs++hv1ereZAspoq13mNUjYi3uCAbzCwkfsC71hfmZuXZCPABIVLZD75nW7LkcKZBsdorj7kqqEXHLGGwBgBOnnkhFxSynDugk5AwB/Ks2iuQ8T++nwUGOR/eC3J4AUq5Z/C03tyhGxEn/cAU9tDhG8uRatzTd3l7qDNMw1ycHG+0fglcp+sdR0hP8OoeOyr4Zh1KmKy234xQini67XY8K2yrgQkNpgtgJqTwN/1HVVCLYZM0cs6k8O7qkQEETmvN+v4SeybciSCWPPGok7CPolsRFvjgcd53Ibx2zYKGq8OExBAqjz/+qzIndtsEEPs+R0h1IPqAPYkHheldz23rvMHu3UPQi6rQzjGd/M8uGOStdCKjmkj+eWVjVKaTLYfKzK0qb4aHF1nQ0ZPER7PXNylHovnWKU95GGfP8MQb+YqZgeTNQonTT6lLavXJgeT+SKisgF1sFpL0/9BJRAD9ifGgFDIj/x1Bo0byvAoS+BfcbmU7uB1Q0d5jUoWJAwtlHCy1SseppX2gapaOL7fcRVnYGP0DOEWJbUzR3G6h+wQFvKV6hCTLUzz0NnJsg5m2xFKhcDeuuDQPaHYqyrVPBXKMGjm4kBMHsrAB0+m1K31Jxcu3pEeWF8wP4s9iY6OLYp3MvKlHpiUBpyAaK6761yNCLeoOo66RvtWjTVLFocqqIJ6KUb1X/dHAs4KeHGzACOB2zTJC2Atg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 14 Jun 2026 06:25:55 -0700 Farhad Alemi <farhad.alemi@berkeley.edu> wrote:

> Creating a child cpuset where cpuset.mems is never set leads to a div/0
> when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds in response to a
> CPU hotplug event.
> 
> Reproduction steps:
>  1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
>  2) Move the task into the child cpuset
>  3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
>  4) unplug and hotplug a cpu
>       echo 0 > /sys/devices/system/cpu/cpu1/online
>       echo 1 > /sys/devices/system/cpu/cpu1/online
>  5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
>     call to __nodes_fold()

Oops.

> The cpuset code passes (cs->mems_allowed) which is not guaranteed to have
> nodes to the rebind routine.  Use cs->effective_mems instead, which is
> guaranteed to have a non-empty nodemask.

Well gee, what happened with this patch.

I apologize for misfiling a cc:stable bugfix into my post-rc1 backlog
pile, but I got there in the end.

I guess this is an MM patch, even though it's against
kernel/cgroup/cpuset.c.

Nobody cc'ed Tejun.  Fixed.

David acked v1 but is being coy about the v2 patch?

Sashiko AI review suggests that there's a similar bug in
sys_set_mempolicy():

	https://sashiko.dev/#/patchset/CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com


Anyway, I'll queue the v2 patch as an mm.git hotfix, but not with a lot
of confidence at this time.  Can people please refocus on this and help
recommend a way forward?


From: Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
Date: Sun, 14 Jun 2026 06:25:55 -0700

Creating a child cpuset where cpuset.mems is never set leads to a div/0
when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds in response to a
CPU hotplug event.

Reproduction steps:
 1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
 2) Move the task into the child cpuset
 3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
 4) unplug and hotplug a cpu
      echo 0 > /sys/devices/system/cpu/cpu1/online
      echo 1 > /sys/devices/system/cpu/cpu1/online
 5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
    call to __nodes_fold()

The cpuset code passes (cs->mems_allowed) which is not guaranteed to have
nodes to the rebind routine.  Use cs->effective_mems instead, which is
guaranteed to have a non-empty nodemask.

Link: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
Link: https://lore.kernel.org/all/CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com/
Link: https://lore.kernel.org/CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com
Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Suggested-by: Gregory Price <gourry@gourry.net>
Suggested-by: Waiman Long <longman@redhat.com>
Closes: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
Acked-by: Waiman Long <longman@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cgroup/cpuset.c~cgroup-cpuset-rebind-mm-mempolicy-to-effective_mems-not-mems_allowed
+++ a/kernel/cgroup/cpuset.c
@@ -2653,7 +2653,7 @@ void cpuset_update_tasks_nodemask(struct
 
 		migrate = is_memory_migrate(cs);
 
-		mpol_rebind_mm(mm, &cs->mems_allowed);
+		mpol_rebind_mm(mm, &cs->effective_mems);
 		if (migrate)
 			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
 		else
_


