Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77F5CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 20:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ED198E0012; Mon, 15 Sep 2025 16:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4A18E0001; Mon, 15 Sep 2025 16:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401F58E0012; Mon, 15 Sep 2025 16:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DBEF8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:13:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E2DD71A06EA
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:13:18 +0000 (UTC)
X-FDA: 83892584076.09.93EA17F
Received: from smtp120.iad3a.emailsrvr.com (smtp120.iad3a.emailsrvr.com [173.203.187.120])
	by imf06.hostedemail.com (Postfix) with ESMTP id 22884180006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:13:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.120 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757967197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=sWke0WYfMOzmLeihRcTfrvUOvNBn106JYf+T6Y6A/k8=;
	b=H+TZf6SamvUapCbKeRIA/4GcRP7NpNNDexzhS31TQ6NnKeN6/n6wcxlfK7nsJvaA9NhqJm
	54mOB0tTgddhlHPqH362qPVokKSDXJ2Jpse1OUYBiWUyJeSMoKiPtXJISQlaAh5/nDPWw0
	pgvOGwJ+dzkdGr8MP1ChSqBf5hf+8gI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757967197; a=rsa-sha256;
	cv=none;
	b=ThOSeTmLr4WY9jsEjK8NiO5Vp8vykhlG7ul6oU7W9+D7MoEn/wj4zB/2QoH2EL3LVAFzLC
	pHTdbACLUebR6Ju1fK6FIPLT+RNpSvC7CHhk4jQBkgIOBEI+1bcD2BHPEm0CzdCCH2bG8R
	YQ8xiwJJwqB1M/eA+42RUog9yJIjBC4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.120 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
Received: from app38.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp32.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 411265DA6;
	Mon, 15 Sep 2025 16:13:16 -0400 (EDT)
Received: from deepplum.com (localhost.localdomain [127.0.0.1])
	by app38.wa-webapps.iad3a (Postfix) with ESMTP id 25C5FE1C4F;
	Mon, 15 Sep 2025 16:13:16 -0400 (EDT)
Received: by apps.rackspace.com
    (Authenticated sender: dpreed@deepplum.com, from: dpreed@deepplum.com) 
    with HTTP; Mon, 15 Sep 2025 16:13:16 -0400 (EDT)
X-Auth-ID: dpreed@deepplum.com
Date: Mon, 15 Sep 2025 16:13:16 -0400 (EDT)
Subject: =?utf-8?Q?PROBLEM=3A_userfaultfd_REGISTER_minor_mode_on_MAP=5FPRIVATE__ra?=
 =?utf-8?Q?nge_fails?=
From: "David P. Reed" <dpreed@deepplum.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
X-Client-IP: 209.6.168.128
Message-ID: <1757967196.153116687@apps.rackspace.com>
X-Mailer: webmail/19.0.28-RC
X-Classification-ID: 97cd83d7-27d6-437a-ad6c-ec8a4ebaad97-1-1
X-Rspamd-Queue-Id: 22884180006
X-Stat-Signature: s17ik7qfo885djod69iqz9uaugcjx1rc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757967196-477395
X-HE-Meta: U2FsdGVkX19HJvqO+8F/wba1BgC3tAd4n2xnnLCsGxwBQf47RMejzqHuAYaRam5xWCNDmW7VsKtvj3xsilWvQ5r1fXF0ybQ87j3QoaCD5BXA5QqfKev+dE7zerBL+3uf3Soy1Zc70roL/KrefS70UonjHgGNHlUa27CtyJC+LXe5D/c+W/ILJAxvHVrPE5c6ByRsHdhZTuhgp9FYP5FYasIBjTgkYg4BGUmrC70hoS1V0IlfNyz+5heRQ0UJ0hiqsW4IXTF4A6vBhbr78c8wQFuBl5kizYHfi4LLtQWWuSYbz+TKCGa2Qi6RleGmM2FGUl8YvXzIE3/xqEE3PDjt9Baue1OtqB4at3NQRNtPzl6X7lH/mWqJGmTSXgEUruyGPXF4amrqQV7cey0I0wSSPCPQOacc4+o9cCn3VDfbVtuPmHWdRcwuP6gEVj60Gnwoafwt1/jtyO+Ux5xq7IXUaOZFfwQT5nKpzufaYggWdU6XqeABs6VSiB0wGBEdAdT+r8aDkdHuV/G3nrJuS940yokkPcrTrpgzxRR1QGgkcHOkRkyqUcGqvRpU3sP9DGVB8qA9UpSDEQ0lyqYPPwCHyXxuee7pY0/4Mk+5tUNf84K4fwqveNFR+SQj33HSO04UiRv6MQLp9FOyejx5KlmbIqR0BWFmpn+n6xUu3wSPHDIJ9/NM4SdgiumwebcPVgAhdNnYxG3ucD9CdIj+lj4znwVKiQLT8sb1L9nMsFiuzZSMwTIvsySlAYeyamq3zZbPvMWBw/xJdi5y2APcLLuIrxOZ9yLV9daf5Oi089VyNBY4pIkZZ/xo0H6xvVjqM8pqgAz0Pi+QF98+359NKy4glsNQzZcLoc8Tf4G8fV7DWBUiTU08cl5wkA8aK6k2ldg3JetsRIS52mnn2FkINuDUL9SFUITjvjgRs0GpRVGW9ZY9T9OS/FGDoByN+KpePNSYP5DQPyibdWLeAq7eIU+
 to4TWv3I
 XSlGDuqc5/lZQ35/c2efpKWz0+6UwuSLphxxTKm519bS2Fa+4BfXmIMZdrdAO5cxixUHDv/NSvfT0+zUBU0g9DoW5M5L+8B8SKlPUaz38TFvq1Kz/pJIMONLlQBXFx37difgce3ldbsON28Gaqw08sAwZLrqsZegXpyR+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=0A[1.] One line summary of the problem: userfaultfd REGISTER minor mode on=
 MAP_PRIVATE fails=0A[2.] Full description of the problem/report:=0AThe use=
rfaultfd man page and the kernel docs seem to indicate that an area mapped=
=0AMAP_PRIVATE|MAP_ANONYMOUS can be registered to handle MINOR page faults =
on regular pages.=0AHowever, testing showed that not to work. MAP_SHARED do=
es allow registration for MINOR=0Apage fault events, though.=0AEither the d=
ocumentation or the code should be fixed, IMO. Now reading the code that re=
jects=0Athis case in the kernel source, the test in vma_can_userfault() tha=
t rejects this is this=0Aline: =0A=09if ((vm_flags & VM_UFFD_MINOR) &&=0A=
=09    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))=0A=09=09return fal=
se;=0Awhich probably should include !vma_is_anonymous(vma).=0A=0AOr maybe t=
he COW that might happen if the program were forked is something that can't=
 be handled, which seems odd.=0A=0A=0A[3.] Keywords (i.e., modules, network=
ing, kernel): kernel, memory management=0A[4.] Kernel information=0A[4.1.] =
Kernel version (from /proc/version): Linux version 6.15.10-200.fc42.x86_64 =
(mockbuild@14a33d64645143cab3659d1335d9f80c) (gcc (GCC) 15.2.1 20250808 (Re=
d Hat 15.2.1-1), GNU ld version 2.44-6.fc42) #1 SMP PREEMPT_DYNAMIC Fri Aug=
 15 15:57:06 UTC 2025=0A=0A=0AI can construct a program that exhibits just =
this bug, if that will help. For now, though, I have just replaced MAP_PRIV=
ATE with MAP_SHARED on my anonymous pages, as a workaround. I don't fork, s=
o there's no need for COW.=0A


