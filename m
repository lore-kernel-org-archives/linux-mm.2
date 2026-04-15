Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01E4DF41998
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 12:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675516B0092; Wed, 15 Apr 2026 08:56:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64DC46B0093; Wed, 15 Apr 2026 08:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58A986B0095; Wed, 15 Apr 2026 08:56:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 472A86B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:56:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01E05B75F3
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:56:00 +0000 (UTC)
X-FDA: 84660787722.30.5AD6EDB
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0038120019
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:55:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ASpGYU5v
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776257759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=riFflWboHrZlyZ/i6D5M814hAUkl2Z5dRR5vqmlgkzI=;
	b=5czVPdUxJ5XD5keJ+WrbKqJJx8o0WQZr6TDOrhsRVerIJfXD/aW9nauMiJx3xZ+HGkZOth
	2jM30P9/ijnoAUqQTzJeTP5VMJJ3Ytbsr9cRVAZ/ufWSfzzFwa1ouPuSGRtGkucKAnREUo
	MxY6lONoqZIHNFI/2ChGr5Tc7dKYOyQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ASpGYU5v;
	spf=none (imf13.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776257759; a=rsa-sha256;
	cv=none;
	b=IKG8zKaLXbLEerFaQjLZm2rkq57U9C9tOEyybdxk60lkmVaWNSuOFpG3Gv8KE+/+PDsgS7
	jiGROssvjxPkIihwZh97Z0XqCiAL39NJWW+gVYifqCZTr7oZJZAXgkzwRjZjGQWfFWZyR7
	ovvW27r3H6eC+CSYH/whwdeZo7wUI9E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=riFflWboHrZlyZ/i6D5M814hAUkl2Z5dRR5vqmlgkzI=; b=ASpGYU5vczZTHN/XsxD/FLQAyQ
	6SzORlkS8+LQdWaLAGjWoTcV7U7EYjKzXHAq7//tS6tYSTXZtc/JKbx6UDiELBiTw8J/KuM5tLOOB
	X0flixUOnVJlzq8BhnGjqvFK1p4HqRaWOQmjtn/WSv60pvdqlVuHYewUqjczEUZ3VtuTE3IClQkUJ
	3vK2CYHy6gkAoYfCq26Z7rO4tpe+64ickRryFncWPb45uk6KSDcTx+VrN0CDecnJIOdTFafFVcbjM
	b0WQf668NkUFjkp/OgnC7+koOfWTN+K1mDC1pA316ZO+R+XfvyaShK/gHr96w7sJ/1usqlmgZz5De
	WmC/jvgw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wCzmc-00DqpN-1v;
	Wed, 15 Apr 2026 12:55:54 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 15 Apr 2026 05:55:02 -0700
Subject: [PATCH v4 3/3] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260415-ecc_panic-v4-3-2d0277f8f601@debian.org>
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
In-Reply-To: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=2686; i=leitao@debian.org;
 h=from:subject:message-id; bh=EXsbl4LOvo0JX/uD060vsfFhdmmxwiFz5i7QxlbIQHA=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp34rHzbvgLtr3TTAmdP5mLG1e79OdmgxxC1fR1
 +wKbsrHi8GJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCad+KxwAKCRA1o5Of/Hh3
 bQ3gEACX1lxfvKvTxghRqJBwM6TajM+mlcfN8zoA9KsIMsIKnBuPbfHEWv1T8GFlR5n8AymDJBe
 x0r3lgTeAsJPVMBrRcFNRhonefmub4FF5hk5wbBOC+Q+7yAIumTYPAE5+l6lqJksMYHikqo6VDW
 2KvRnkyZMRFcIMgvbGX5KW2LOUI1kZKDhPW/2/LJf30R2P/tLBuAhhDgNU7ZG0qFdrSUZ6qX5Qm
 MZtUxf6SwvbyI7JlJXcJI1xnyvvedDMlnDdx8J/18XW41zgn+cwIyEkpsuGXKkGsM1l2MoV8Wda
 NLByRpDUNOLjJVjcOCr3+OhplbQi3mR4Ph1qBjlWUY81StlgklIkJ/gsX39nSWWwuhAs0nXr3a1
 wmY+10z+S/bTxsrSCBgLoOZ6vHptxax4m5lVZq+m1sO3Ked87jFkI2ke9mKKglZj/uZoMEJ7bKn
 RTXRZRH/BpW3tekyeeExVphRlRqExfEDJf6ueFYoDlShqS337Ozom6VffC2JB0CIdmlmDKO2uCy
 JNgSA4rGDzUtYBGuJFMPJpkS1fWgYjOJCvcVrRSqbfBEk/HQuo0Y0fz1motiv6ZpOFnavArDR14
 B2tCROnjtxyr3R/NIPgC5E28Xe1Zleqo81haT8UE8WgWbEGcrzBcW0OluJ6W05YD9OGLw3VHRUe
 ayxkxb2pnDUn9hA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: y4g4wqzjq84ry8qyqzk1tyftszcgbjo9
X-Rspamd-Queue-Id: 0038120019
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1776257758-84359
X-HE-Meta: U2FsdGVkX19YKu3P4ckaafJPePu06c9e+OQbuNcfeaQdLRA3v+wHx9Ta59ar4zZZ9ZynnHShJ1GVDzOTmegk0uqOcydy1l+P/fueMAcAGRP5IcOxyS3XifiSPLRUurfRhi76U9W1EHfSlX/qZ6gexlGfQGLzSysl6pcuLzw3/+i3I3q4p/6v/PPLXnFKxVfXzDfhR3joO+/BvbBOsGxB4tovscCDUyRXGLL/Tcqq6ATv/nJpmXvmddaQ264ZXBC3jE2mvG8T2YJc08Ct+Cc9Rd0VY52yAvc72cfFX0O8Th0kzPcC9IHk/A7A2n0cPZXbH68BDHhOUjvIvCiPn05u+gulMYorbaL8OBE78ptjVRilnLW+PD+7qGNQWykJudQOGktFBeaSmViIoxLNiILhRCWBi4/TYUODgMsv8PxgFYdItlxFJ9HQ27dvH8tNIueTQb8TV4p5RpWcY9fxhtmoHf4H8+da2dr9CFydks4GofWiylDBgntS8Wm7IGi3OPiBclhfNgbtuBcSHPVQeGPtTVGeM+UrzandypA/2RwZnKSsvNsgTIQaWU++cS5MFhZ+Q/GBunre5vrJdAp80eRnyo6I5sVThRar/huKXe0nVx2zVI+iWTfQNFSDvzdBgR/Esx+iNTQI+ma94c3bMfGvMaFaHYCNIu7xmDHg8lpFb2P09pgI1eAeooLQzq9GtHW0z1O8PYk86fqlM6sBVCEc8SuFS61s2Zirgz3LRABG8q/txd9nM20jp/4JsDGsTTBtKbAZY3x/XFzfdz7pKstOg5R1FUV+FNQsXK81mEJ1VfFOPzUeIqafLEU8a1BxA1N6KglPraHgZAJ9TbPyQjumdscuA9prDEDYaWGG/z3BLnRUg/I5SpOXL3XyRkMzTwOy+FbYgyhfGJakaEIutEb7mTCMzHuG1F2yCLsSbg5ccag39Ff1gHnnrhNhzdaXVv4bHyejeH2cQRsMCyZOWt5
 WmAuZIE+
 duoRzjnU8KpMfI3zOl3UhsD1d3BjIP5NUdmPrB3k/LMjlcEiMZaENP5GAcbGrvvqT8kn3oBZT+q2j+0WTI4xBCRKlMWaXIirBjfeactaJjfs1l82ndAhard1vLfJnrnPC0AU9ue68EXXMg+aOrpd6Q+g5qN23ueQwAGL/sMHVC4uCHcRX/HcKNZr7tTbcV+1SiNuxCcDK/ne6ftmmv13+pVWt09p7nc8Hsj5ikzToIxVECuLPHVrncC1+nofz8Y4MPRUWNbLqCTwYouFzSUsocEpF/i+xEEj6kxxNF119Hz7/4Yg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for the new vm.panic_on_unrecoverable_memory_failure
sysctl, describing the three categories of failures that trigger a
panic and noting which kernel page types are not yet covered.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/admin-guide/sysctl/vm.rst | 37 +++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 97e12359775c9..592ce9ec38c4b 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -67,6 +67,7 @@ Currently, these files are in /proc/sys/vm:
 - page-cluster
 - page_lock_unfairness
 - panic_on_oom
+- panic_on_unrecoverable_memory_failure
 - percpu_pagelist_high_fraction
 - stat_interval
 - stat_refresh
@@ -925,6 +926,42 @@ panic_on_oom=2+kdump gives you very strong tool to investigate
 why oom happens. You can get snapshot.
 
 
+panic_on_unrecoverable_memory_failure
+======================================
+
+When a hardware memory error (e.g. multi-bit ECC) hits a kernel page
+that cannot be recovered by the memory failure handler, the default
+behaviour is to ignore the error and continue operation.  This is
+dangerous because the corrupted data remains accessible to the kernel,
+risking silent data corruption or a delayed crash when the poisoned
+memory is next accessed.
+
+When enabled, this sysctl triggers a panic on three categories of
+unrecoverable failures: reserved kernel pages, non-buddy kernel pages
+with zero refcount (e.g. tail pages of high-order allocations), and
+pages whose state cannot be classified as recoverable.
+
+Note that some kernel page types — such as slab objects, vmalloc
+allocations, kernel stacks, and page tables — share a failure path
+with transient refcount races and are not currently covered by this
+option. I.e, do not panic when not confident of the page status.
+
+For many environments it is preferable to panic immediately with a clean
+crash dump that captures the original error context, rather than to
+continue and face a random crash later whose cause is difficult to
+diagnose.
+
+= =====================================================================
+0 Try to continue operation (default).
+1 Panic immediately.  If the ``panic`` sysctl is also non-zero then the
+  machine will be rebooted.
+= =====================================================================
+
+Example::
+
+     echo 1 > /proc/sys/vm/panic_on_unrecoverable_memory_failure
+
+
 percpu_pagelist_high_fraction
 =============================
 

-- 
2.52.0


