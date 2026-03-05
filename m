Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DF9AEEF31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 08:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B233B6B0088; Thu,  5 Mar 2026 03:26:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1216B0089; Thu,  5 Mar 2026 03:26:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF6F6B008A; Thu,  5 Mar 2026 03:26:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 88C036B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 03:26:45 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30CABC2BE2
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:26:45 +0000 (UTC)
X-FDA: 84511328370.08.A3A34FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6E25EC0007
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:26:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fjh0it27;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772699203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HJYJRu0YWcxpuRI7zoCXIGjHvV7ow2TV1x281dJOiMo=;
	b=NxQuZ0pKIfCcqAi5kdFfBDBU29UJW2Cso8UZO3zXk0v90EJy2VUSwDPsLXVxv85jsONCeY
	oUqfFOAEac0uhf4JQGLagGk0c45nbFruzsUJQZiKvMyrLFYY0fzz9/9rDZXfTfMIn2ZUyN
	2+FV9lNt0AdNE+uh9COfR9xdMhY6FDs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fjh0it27;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772699203; a=rsa-sha256;
	cv=none;
	b=4EojIZxskE/6kEM+9XrcBoxO7lhtFtIAdmGNx87UN9AadMryahQ+uoK+17XHpJ2tjrr6km
	3O5dwytEgqZGRrVxo5dZBl4K3WtkfUppvmCghmwuep13MTty17kXN4BFLuZ+6RfBZFsF6q
	iWFuIKVFleZQGhMHx6QLHWRkU3voOQQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B17BD61339;
	Thu,  5 Mar 2026 08:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE5FC116C6;
	Thu,  5 Mar 2026 08:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772699202;
	bh=appJNxvXAZ1qTdkOzxd46DdOguQx/fhK1KOjR5cyeAg=;
	h=From:Date:Subject:To:Cc:From;
	b=fjh0it27PmUSmTEUDUWvLxr9P9Lmes/GnCQr/9QUTXPIePz+QiN06l+r7Ofg5i/7g
	 dK0nOJSNw3t/kM53iZkxCVI2lJgGFS4hVw3pnHBpBN47xP0SyEKdAgmNbSZEtye47r
	 U94bv/Y+HtmuZ8F499L+i2CuGlSXygsvyx5b5Xmer5nB2msqVipqPqjOv9Xe+AO2PF
	 BNCMtsvXT+PcJJsl5SH6Tw5TBNdZtXaUWirr34goX0Y+4kmVT+GEcWNbQ9Wq25EAz0
	 emh1vW/x7r6vC/Sgt96OflQGdqZY4vZ6kVK4eoMyb/qmb/HJ0msggwOtL45+XzjcP1
	 3zqiF2rb6vRyg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 05 Mar 2026 09:26:29 +0100
Subject: [PATCH] MAINTAINERS: add mm-related procfs files to MM sections
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260305-maintainers-proc-v1-1-d6d09b3db3b6@kernel.org>
X-B4-Tracking: v=1; b=H4sIADQ+qWkC/x2MQQqAIBAAvyJ7TrDUoL4SHcS22kMqa0Qg/j3pM
 Ic5zBTIyIQZZlGA8aFMMTTpOwH+dOFASVtzGNQwKq2svByFu4GcZeLopVZorHcTGm2gZYlxp/d
 fLmutH4jz4QNiAAAA
X-Change-ID: 20260305-maintainers-proc-30e45ca9e434
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1123; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=appJNxvXAZ1qTdkOzxd46DdOguQx/fhK1KOjR5cyeAg=;
 b=owEBiQF2/pANAwAIAbvgsHXSRYiaAcsmYgBpqT487tTwKDeClkZYrSim5P35ohDOl7AcH5w1p
 gAtpeZQHGuJAU8EAAEIADkWIQR7u8hBFZkjSJZITfG74LB10kWImgUCaak+PBsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQu+CwddJFiJpuLQf/fyyHRPgCXChezTV/ThaiDBewq8NjreX
 +rSI2RI8++6bgVApk8n7+BYKzyOzfw6XvvHZhVbHqp76krpGllyKEOZla91MP9W1RvuFApRLdW2
 eF31zssrll1QE8AGFWN7cmoiGeS/i4qzstWRxegUQvH0F7lNa7co1yocj0/a77uSnyOPXxbnyEa
 +g3nt0j5MJk3KJn/M51c922knWRrLMId2V1GaJPI+pC23/ae9Juj6QTQUH3XyfS15BnJlIMQ20n
 n8xCTnee8flnzG6tL1LTz/mD6UpijjTgoZAF3Vbv0MvNVrjw2oqlH6JRRKdkfHA32G1Yzps/uyZ
 pTHU5XfP8sg==
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6E25EC0007
X-Stat-Signature: j1qti511nn6cb9ib346pyoamne63yop8
X-Rspam-User: 
X-HE-Tag: 1772699203-702662
X-HE-Meta: U2FsdGVkX1+x97deLWODesrl2Hcyqw8SSOOAkyFYaX2LREcG98mYAdd/78o94oCd3dR4q29S0nPJsFmGDqP6rlMR7A7CFaXMW6IeSqz/qc2A33w+mmiOcx8JqhipYds4PX7sABN6/amJXmgCkdTUT/Fjds7ppD8IpTnKWaFTo1D8Vx1QmpDYlQCnJ7oW8a19/l+ceJ6KAAI9MtMH7IlnncHL5DXdYeHtm6IxvtMiedoxYJeTyTGc/3nA6ofMMyLLpgEAT2sGj4Sa5paj/4Vy9nrLcpzRIwGqZE2mow4haEcOouIINZ8iuH4XJLMyxBJm73X5rRD31AhJGgf8Mz8VXE4+eSyIvMshF33vunYZr4ZlSyKeXdzkAC0cWGH4jKHHtC0G3meCORTOSwaf3zvAn0FtyJPd5gmVww4fgvQjwKWpdM4VEHD6xR5mw79XJ3kIhwpkz4H0IpSwPX4rmQJbxVHdxbWrirv9QZQsGD3RL4kzsRrodjt7q/Wa1pjdlZq6tmKCBseDQjLqAOdPnGwwr2aSv+CJNrIeCbM5h3RVzrYd126Wo0uxO4rnhBRCbb3FHZ8PnQ539e0PobLtIfYucgPyeWDeutwIMY1rpenumWo75lKcBEiWGsWzmdLj6cpPiz9XFhw+yXIr2lfWmrUZfM/olzPWZ6DQsvWB5H3jlJ5O4TAZQXVgbTZm6DSDqtMPVxMVt+yCjn6EAwh2L82yNw36IPZA/AqTbxknYcSwoA+jiyeQ+NUoIHHxkJFUpzY8KoHKGCh3ncXjWc+5/qIqCsUu/Q2sBGH0ugDg/T6NfWywSfpHlhuD8yV6vuX1uXnnj9OWGNmqKnqgWFQuN6fGvaBo5OxPD6Exp8OlVU2esuVqbGRUGYW5qaWf8pSVOng/siFfAmqOx8xcoDJdTdkdZq9kV1CI0RBke13qLfzYi9V1L4hqj9cRlov/HOuQSrB0HaVxWJnbz+EJRDwlW+7
 8ZsRS7AN
 goL3aLbyYBZFlC7lLWbthIyxKSc0i4WmjZAaeF/C98da1l/R3iw0S0EVFmO9nuinfksb7qrzGnOAmiLFhRhIAJafBY8g3a9xmSn5gaPufMc0wQ5U/HQkqdyCuEj79q8EXYESZjGqi5BlqR4lxzp3+luge1E9vkd7ly9aazYZSEGNEmq6zbzWgo3QNSQDDVyew753hPc0I7L2cDbo7EyVtCAayVSXoCY3nPo/smF6DsPGuQhSlXGdPx6DsH92ec9dAXzb/OQGzidP+mg3tForgpNFwrRd6EaYMj8uhU+zLz+mzMV6IdGgm5mfC7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some procfs files are very much related to memory management so let's
have MAINTAINERS reflect that.

Add fs/proc/meminfo.c to MEMORY MANAGEMENT - CORE.

Add fs/proc/task_[no]mmu.c to MEMORY MAPPING.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3553554019e8..39987895bcfc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16683,6 +16683,7 @@ F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
 F:	include/trace/events/zone_lock.h
+F:	fs/proc/meminfo.c
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
@@ -16998,6 +16999,8 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/trace/events/mmap.h
+F:	fs/proc/task_mmu.c
+F:	fs/proc/task_nommu.c
 F:	mm/interval_tree.c
 F:	mm/mincore.c
 F:	mm/mlock.c

---
base-commit: 7fcd8889fbf318409163ff5033fe161dd2a73243
change-id: 20260305-maintainers-proc-30e45ca9e434

Best regards,
-- 
Vlastimil Babka (SUSE) <vbabka@kernel.org>


