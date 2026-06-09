Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E08CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 23:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E8B26B0088; Tue,  9 Jun 2026 19:57:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999E26B008A; Tue,  9 Jun 2026 19:57:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888996B008C; Tue,  9 Jun 2026 19:57:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7713A6B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:57:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1EEFF164F0E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 23:57:47 +0000 (UTC)
X-FDA: 84862039374.26.CD5E88B
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id AFC634000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 23:57:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=RpdwPLMO;
	spf=pass (imf12.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 74.125.224.52 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu;
	dmarc=pass (policy=reject) header.from=berkeley.edu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781049465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsLwA10csQX3mPa70cbCrNe5YAZmOcAQoD0WQz/1mlc=;
	b=U2ZyN4weJ8Th+ZVGjrIWhVczWq0assej2KBxkuqOTYtxxIbJ6lN3DF49CCjbb1/bTq3Jlc
	uInjNzBzR06Dae7xbl6H1ZlfvS9KatAcv+hEdACD3Y/lJSRa9BmrS1rMQazab4ca6XpY/l
	bJXXFSyGxccg09/CAocYsVylaA35nXo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781049465;
	b=ZXb1dXJqLuAdU+d8lSPAUSEt39+M1OigeZTT99S0MNxKpiW0YeW/iIWXSghjfjYPq5LpQk
	FvOYHEMDMcbrWbCpkWcDuxuONGPHp5IvneKOG+qlGMWZ4oX01r0TBUsAEI8F7ibjsu66Zg
	H+lxVGNdt7GVuVtyqze0WSo5FaF2nWk=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=RpdwPLMO;
	spf=pass (imf12.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 74.125.224.52 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu;
	dmarc=pass (policy=reject) header.from=berkeley.edu;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-66049669d78so5470798d50.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 16:57:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781049464; cv=none;
        d=google.com; s=arc-20240605;
        b=OTm+kSmBrdqtW70Vnpx+gI9ly5IjGfuBnEI2qEHTTrlGaqDS0qGU7pJL/OnLO/MQ1u
         DC+XC9qVUZ3xGjBXvZ7/JfNdTTN/irjUPzLa+fIObhPI0r/k7dG2dZc1wk+wZ6l2dMfh
         sI8Q0BGCt9ZBlvUwh6f9wpqRT74+8AdvL1KRMKPFxSUUTDYdkYONxfUipHFwW4dPj2NB
         HxWWB97sTPwt3pkXyJP+zPLtQsrGIUI2ObTRuv2bbDbjra+XFeop0VWwmATrgEe7eHva
         AWyyQRkHRg/atqd2Dl3krwmDHnF9Gk7ixVwTM95PvJ9auB3SIvwyVimi/Tb2/RB6zHIK
         3Efg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=JsLwA10csQX3mPa70cbCrNe5YAZmOcAQoD0WQz/1mlc=;
        fh=oXqW2Fv3fu6l2GSfUlNZzATx/JByeJUv5u6iLTRf418=;
        b=HIL4g2cqEqZ1+wgGF14gqn9t63w0ktZwtWW51L5b/DV4oMgltov0ifrlJO5nUEwXIb
         l73IV5+ah5p8yGO9EeRpmUYRywIQKkptRB1AmZu0y5u6aCHsxaR29JafCAzjCjC97ZHA
         XjMP+Esk46mwWpmuB73yBioIK++piVOiD9ngqn6seaFzDMDQEoh4FfjMcBUEc0Nu2ZeZ
         +c6yMXQes+EoWE9jMF4LDcRsGJwpFq6H1KEvX/4uiLDMY5Lgf77lW00rNcE6MLinta/O
         qGZZH1y8kpQKaX8e9mSHpYzGrXAfkm7djibHIj/alxO1vnsPo3yZ0yxONHQPVwfX1/s/
         RP0A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1781049464; x=1781654264; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=JsLwA10csQX3mPa70cbCrNe5YAZmOcAQoD0WQz/1mlc=;
        b=RpdwPLMOvrEty6/CzxMRbk/VY9aNinCI60IMnsBBbI5ZIq45DAP6O9yb5x3XafjthN
         ehTAb2xDZFxofltQ5AC5MfPpfelYKqdBB4RMdmlNRmWDZ8WfgURBUxYnWiXWt1MqXyQv
         PeRj2L4jvio6Tl7PXmZw+0KirrOE9RfWXEYWh57i/7EGtrfGrjzFc8NUWSm9VNh3qSgk
         2xvtdrajZgdOngIGTnRcM52Ha1Pfzp7ljkxMC0peQ8gNCu8cz2wQBAb+ARfYAYypgiMp
         P2n7m0EjytBlZrE+COPUI8WszU3asxgF9LsdSppPSTaI80M9N29EJ84OXS0iTExz1eAL
         EIHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781049464; x=1781654264;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JsLwA10csQX3mPa70cbCrNe5YAZmOcAQoD0WQz/1mlc=;
        b=JDWQt3CF8j9GptAOPEplz0GxLTL2GSgqVxHJl4pYfS5cGrwuRDd84X7si0MF58+O/3
         my+yYJY/up1x2zMJgv//RGO58hUlkwPyz5fOpxTI96xgqY1y+KrwUZgrRN3s61ewAsHw
         wF7H1SGZbyRz9TNVrkEjJdx/fYsEaVVdVDEfkWNFQj0zRx7J+WzFW1gutGEA9WGuQzq8
         0os+qybCWhtcUDtdP9tp8ZKjI03DmWoma041eWh894cWrfw6jH9fisreP39MB/h/5PIS
         DU+YWsA5sew/QHblmvTRvm0Ozs5ivSlLhmg7+GunHIgviBc3x45sjhArFJGE45EZ6DNu
         LFUQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Jzo2dYujRoxXIVJj06rzuEkMGpA//Gpjr+mqG7pXDmnFLz1xg8Oj6+dZ6EmaK2FfENPAIzF6MQw==@kvack.org
X-Gm-Message-State: AOJu0YwRWrtmmUqbqf9YCTGFZVzHUYcbbecbkJVDeHP57tBV3qP5MeB8
	qA4YbHM42bm/4R+n2a5DVsnPWe9Gm9QVkzDM3jJcTKfml6CrXw0VXQPovH2vQEb5TbWtYzZpVPc
	9extTfyRn6QxKoLjr6XaCXgvBknr/agYJ6k0B0iGO
X-Gm-Gg: Acq92OEfLUyjnIMZq5xXt5+Z9VR8kchD0uUFfB8G4O7hqhVOTcrcgREKP+5QldxBEx5
	EJHr47wMhPyadLSN16o1Y2lvhmxQNOdpo+nVqnVmq7hmkLSDLBN7xcH7vJIPh0WBc/j9nkslA9t
	wF6E9EoamJi1JN2eEG3t/Kq3588aoZeffGdg8Vq97hZQFmevpXz9I5DE/fZluIQrMuLBisKZsbs
	IktD4V6+6MjfskvPBNVJypWOXB9aLhN53jddjDwyBAX3TGx0CFVoOADAKSyWLArrphkhuyYxIIe
	2/gJeXTgdwBV8c1len0w
X-Received: by 2002:a05:690c:e3ca:b0:7bd:5c77:1aa9 with SMTP id
 00721157ae682-7ed09935207mr231089217b3.0.1781049462534; Tue, 09 Jun 2026
 16:57:42 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 9 Jun 2026 19:57:41 -0400
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 9 Jun 2026 19:57:41 -0400
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <25c4bc47-b65d-4c04-8a8f-18eef2b5566a@kernel.org>
References: <25c4bc47-b65d-4c04-8a8f-18eef2b5566a@kernel.org>
MIME-Version: 1.0
Date: Tue, 9 Jun 2026 19:57:41 -0400
X-Gm-Features: AVVi8CdwZwsROR8QvBcPRl0TTYKS3lybsjC7VZyFrbO3L3H_GqOslrHHbiWZhF0
Message-ID: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
Subject: [PATCH] cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Gregory Price <gourry@gourry.net>
Cc: Farhad Alemi <falemi@asu.edu>, Yury Norov <ynorov@nvidia.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Waiman Long <longman@redhat.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: AFC634000A
X-Rspam-User: 
X-Stat-Signature: u7xf3z89c64qhzr87b8ijfg17stjb1cz
X-Rspamd-Server: rspam08
X-HE-Tag: 1781049464-756525
X-HE-Meta: U2FsdGVkX18id8oLrtPp9KTpqU2X6sYYDHZ0imlRC4uR0hIUtzcGVW+CTpjMPkh4czK/C/vFSZu+81SPomEuBqyJDT+cnuOSE6QCDGOZN20XKPYwwBZ31YPsYKXAWuTk0FgoYBy2EIwgdYn1P0z811FdnoGV81MAaGBIVo39kQOKIPjN3eyAYEWzpVis9A4LjG+HIRP/UZ2OJ4V7z38I1+0bYjCuB4rmXT+WlICIU3jZBzjRZ2iDxbm9hfBviLhxAYSUmveOlfbohvHucKKPMYv5DWJ11xmOWgZ+k4mqqzXDqJNJXEPIHSOdFIXolTq43wyWcVK1bVZQKoSP/63Ibr2vwMl6iqxMbb/riMM2iegxtW5IIsDtmwjcH6BMYRrMvVHv4ECy7uIpZgV3E7EKglVg64sBX1QnKMpX1lIFbcoEnXf/oEkhubMgyRbuq3UQnXW6gEsHXr2s2VzNVrECNJgTWay/hoH829GjgfnEbovh91BUsPBa/AMk+PMTmnaut4rdSEd4x63kLGX0c+2A/ORm6fEP3EnRri/oB9BVOQeuzTunXRfb0L53s3/qL3GWE3SdDe6HmhRpuypQGg+8Mt4QniGl5pOV0XDhXSLSBka2WovZuek5M5yDnxJTEz8WC3WithL7uQQyO/zc9HaNDdXsIWKvCJnb5rs9QObwERb7VvqKAH+c+fvuBMjmjbkMU3jUTN4RclcO3n8IU+I7pgcmS+Xdo7Q7hXV9JqsQCxyUCSGB7003/R4NevV4KaV96RVnN1/fm38HGv5AZBEn6WhILkVmc/m8ArRJMFwxjSCixMrq/Nl2a/eHTVJ9DUWguxJFTG5PF8CFxRzRs/e2pRsFQW8E8Rb+3MdIHRziouUglL/gLhQn40tZLyoAo0nJ5WLhQysUDQa14boIdI16ZFaVVESpihTNgcUo3zrM+P88BoeKajlzqt9EKjGU6e5d7tx77AMFvDxQxpHHvEv
 cHB0Nhoo
 CmdurYNkuxcsJqJe9ib0TujcfKdH+xsstxmtFpAESwHegg8pDdJPQcRpoqbkEAKVjGFE49pplhnUdC+rj7mL1ce45FMCsMLehMSeml1RJ7nbq9jr4Xf8pbFfRH9gN+LdaFTwXxe8291qpWUCloDtRL8c9p6GospLG45XUoOKK74bFBaB3X7tdbe1aojHr0iIVJpnQKnYPW4y7QJTD4rKk9fYnFV6q6BwwYy6pOiNBtfe+ivUr8Qh68f7gUEEUy4s4RKhv037j6PaZNT2+tgmZhfgVXIFlGTIisa6eamDVHyuhlhgF/omYKzOEFBuWNJ0rro1Kh4k5BDC6BZ9b4mE/2MLHqmDw9fAnNfglN4wTm+AJ1MXTTBTOu1JK9oSc4UTTyW7ZIZM64uW+t4z8NaCofFXMbTvtJ6ErRxWzUbg21/+UYu10Ccaapxom8cdukPP4nFTvmGzBbssgtQHB7aY2d0qufV9vx1czNxX9z4BpT+6h7T6oBAbXYW5CuywFHdOaMRNTNfKrbucs69fbE8uL4nR5UInQx7W4j/LP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cpuset_update_tasks_nodemask() rebinds a task's own mempolicy to the
cpuset's effective, online mems (newmems, from guarantee_online_mems()),
but rebinds that task's VMA mempolicies to the *configured* mask instead:

	cpuset_change_task_nodemask(task, &newmems);
	...
	mpol_rebind_mm(mm, &cs->mems_allowed);

On the default (v2) hierarchy a cpuset that has never had cpuset.mems
written keeps mems_allowed empty while effective_mems is inherited
non-empty from the parent, and tasks may be attached to it (the
empty-mems attach check is v1-only).  A subsequent rebind -- e.g. from a
CPU hotplug event walking the cpuset -- then calls mpol_rebind_mm() with
an empty mask.  For a VMA policy created with MPOL_F_RELATIVE_NODES this
reaches mpol_relative_nodemask() ->
nodes_fold(..., nodes_weight(cs->mems_allowed) == 0) -> bitmap_fold(),
whose set_bit(oldbit % sz, dst) divides by zero:

  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:bitmap_fold+0x5e/0xb0
   mpol_rebind_nodemask
   mpol_rebind_mm
   cpuset_update_tasks_nodemask
   cpuset_handle_hotplug
   sched_cpu_deactivate
   cpuhp_thread_fun

cs->mems_allowed is the only nodemask in this function that is not the
effective set: the task-policy rebind, the page-migration target and
cs->old_mems_allowed all use newmems.  The sibling cpuset_attach() path
already rebinds VMA policies against the effective mems
(cpuset_attach_nodemask_to = cs->effective_mems) and explicitly notes
that mems_allowed can be empty under hotplug.  Rebind the VMA policies to
newmems too: it is guaranteed non-empty by guarantee_online_mems(), which
fixes the divide-by-zero, and it makes the VMA policies consistent with
the task policy and with the nodes the task is actually allowed to use.

Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
Suggested-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: stable@vger.kernel.org
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2649,7 +2649,7 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)

 		migrate = is_memory_migrate(cs);

-		mpol_rebind_mm(mm, &cs->mems_allowed);
+		mpol_rebind_mm(mm, &newmems);
 		if (migrate)
 			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
 		else
-- 
2.43.0

