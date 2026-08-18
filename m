Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD53BC5DF85
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 19:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA466B06A9; Tue, 18 Aug 2026 15:51:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AB556B06AA; Tue, 18 Aug 2026 15:51:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C6D6B06AE; Tue, 18 Aug 2026 15:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6686B06A9
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:51:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF8FF140287
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:51:42 +0000 (UTC)
X-FDA: 85115435244.05.7B69981
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id C5607C0002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:51:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qORZbtSq;
	spf=pass (imf10.hostedemail.com: domain of jannh@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787082700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=drSOm1ixDHQGlI3smzn5LxemApeC9uWCJGzFJcvqnEk=;
	b=JRDGlvj4GVfCpF7dxy7932qIuvsuP/1K/pkPs2+h8sIHpZQGLpyQinCOJWU0F5AydhfxsY
	WvYzj/BJcLJseILstaYw/ZOjwOEdRB/RqcSsp3ONs2tYd1bjsfP6BGuIZ8UBWpys7vsJxD
	Mh7sCP1XjRrFaV7wyjDvz0dJ/aKftTk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787082700;
	b=pW5bI2NygjCArxNMmaMVkJr0gxIPSFh669AFAvPX7opeoNdoPrWzUUPPzV7pGdHIHnM+OH
	7GbS2QE9neXkM51HdHVDXooFgmr12bNilP9sPPSSJei7J5ZYk5Bi4R4Gf4wpbXXVaQcvUg
	zRbhoee9AawLmE9TlDLo7QQbloooNVM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qORZbtSq;
	spf=pass (imf10.hostedemail.com: domain of jannh@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4994d67d260so1885e9.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787082699; x=1787687499; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=drSOm1ixDHQGlI3smzn5LxemApeC9uWCJGzFJcvqnEk=;
        b=qORZbtSq7UFLRl/VNA6K+XoL6f0bvyV/Aut69kIpquzA3c4o/fsvV7dFfS3hIB86DW
         QwvRPuHqPnr86C6xE7vOrx8wRCMwXhQppwq6GVcBz1akxB3qaqsym+j6DIbLXhfeXgyv
         RF/zkdj3mzd1eMa8IyA5JqcyJFB3TLzBzlf5W9qxzdXgPOcjXI6oyJbSyLKMCKF5bze6
         2/6aL/riw/A1C1oO+A7rRP1NGh2jWk+gF0VCDl3zGQdqxfOJsNQSggKNXtkEBCrcfUVC
         im0UMfCCRIW/oENlYp61+UvNyi+jnpwl6jApWJv/G29jUk3lRqSggwPYX5LWTBot3s9T
         lwww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787082699; x=1787687499;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=drSOm1ixDHQGlI3smzn5LxemApeC9uWCJGzFJcvqnEk=;
        b=eFPkkdOajxcPLDVTpWvAPtr23cuWtvw8+fKS9ERRblXnladx0d5UD8Rr/mA4KTKS+q
         MLkO3rLtVPSvj82g/iZJMlUfTkr4a9MDB4zhYT9D+1mwxbOtBxyawcWoWynRLsgh1Ql0
         H/PHOFg6E1krVxYxLa0dSTSbusHXElNaFI3v0SHpXlU9Wb5Al1b2RTL+dya34ixtB4tz
         Byd1cY/nBjS55hGyDlXJHUZjR3WbMide6JKvYMqBynCQ4yRrBOh9KXAxpSOd8hps9oFh
         gBdGmr9GyFcE1IIAZouNXYg/oz5qTGNxRXPKunUdq2/xoaEKMiZHeu/WjWHSHqVqHEaC
         bIFQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq4WTPYlLz1M1YmMSJwWZmTS+OA1/g8Jc6+LfZ/C4RaMbTHhlCznzkwmEIPxd2yOLnfgT1kRCUn/w==@kvack.org
X-Gm-Message-State: AOJu0YxtQ+JzQVELHsG6Kj56y2ZNf35mkSAhLG8NhGnjMi/4/r1HEqcO
	jbLz4SbACwM1yiiTIohlu3XqiHlt5MsWh+r41CKbB8yxgSKUW0h9parQnMDW1xKhqQ==
X-Gm-Gg: AR+sD10bxMR7hediKNsWwr/TjmH6RpGHkqyI0C7EMW8zbuJJBG7voY8RO8PGfkpPz8S
	h4ClcwL1s9/52/9DtglwL/wuNiGnzLfR8I4aagrl/PMqpBTyylXpj0B55lXyQEzXSaNa8HQUjeM
	nxmjxghO575ZyeltmoiJIesbv0sJ21wYwuJJTdvfaIq9iuRD/VN9E4chFMUbfcTmWG8kZp0/fLd
	RRphDSocHWEgudev4Tlsivmv4S43rLIBX7PO3O0I3gHEZbI8rkJ2F0i2nGZc40O69mb9DhryHRO
	EUxqdRvAdwxaPn/MDQhCqNultFwlc83y+V8RddkqOFeBKkJhALhA8B3FtsEze0fiQRgTmSTticP
	eMlQToNTqg0iHbIFaiDl5rMqCND+3MW/U1q6lEe1EZg40Hqe2KynysEFK/JSsU7uDBUEh9g8Z4Z
	vZaX6gjSo//MWxUHMounL6ZCttJzn60jRyRDXtB/Rp6gi9ozpy3hf3AQh16cijNG+n1+T3SSwYh
	L9toyf5y7Em/oEJirYPlBiBcypqNZCiEZSRs+Nb3izOxIJmTVUTSg==
X-Received: by 2002:a05:600c:254:b0:499:7da3:dd0c with SMTP id 5b1f17b1804b1-499a94ed422mr57545e9.0.1787082698942;
        Tue, 18 Aug 2026 12:51:38 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:f466:5a15:1301:318d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999d0fb85csm210096385e9.11.2026.08.18.12.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 12:51:37 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Subject: [PATCH 0/3] proc,security,selinux: let SELinux block FOLL_FORCE
 for /proc/self/mem
Date: Tue, 18 Aug 2026 21:51:04 +0200
Message-Id: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKi3hGoC/yXMQQ6CMBBG4auQWdsEmikQr2JcYPmFASmkA4aEc
 HerLr/FewcpokDpmh0U8RaVOSQUl4x834QORtpksrkt87pgo3hJ2HazzCMmTIa5tM65ynPLlKo
 l4in773i7/63bY4Bfvxs6zw9radgVcwAAAA==
X-Change-ID: 20260814-selinux-pokemem-44625557c4d4
To: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Jeff Xu <jeffxu@google.com>, 
 =?utf-8?q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
 Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787082693; l=1964;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=tzzbnGcfHutO0vdB1fh0UMZvNK7uVy3ulgec3GLoLDg=;
 b=HhNdXV2fub0RF+OgbExoBb2DXb+eAiN7VBv2jprX6UnhpvnrUS2oTrBxlzDBG1Smiw3tvds7u
 /RA3CIJ29a5DZBSqk1r0aeUsB+aTrR6g2NeP2huXaOBXrPr7EzT7TP2
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspam-User: 
X-Stat-Signature: 1hceit67zafyd74fd3f74ob5i99g41q7
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C5607C0002
X-HE-Tag: 1787082700-776202
X-HE-Meta: U2FsdGVkX18E0VZO90mKDHS2+ihy64EZc8naSwQ0Sqgh8ewbmt9IAXo75EbC+iMLNtMiH8vlkzaz46Rdj12+hW+TDRn9OztM8mdrpq3NF4HShFIDqL6cfov1HbScmlMFO9JnrNuPXO/mnJG8Xn3e5NYOg5/ir4uA6OI1BogpOa5VA19VRJwF0lCqBXWXCJDjOTOzClwiLHPAEC07zFbqtmGKckTRbDayhjj7p2yAuYgJNVmwT1eHVR1J1X+LxBMOARWqiKYxJ/wVff6t0mQ150vlSghUJYsuWuKVpA2caM0w5MJWIN8iatOKhLEROB6/0N4ImGB9vA4uujW17PWBYcgbfRdbYUD9R/PXz+gnPz8SC8+AAoROsN1IhsvZa9MbV4TofgRVYcUYwTJ/wTLKScoS0HRfpzyupPFFlD5enZGmH5myursNYa0sO3aAwG+P6TuU0jCmsxMV6HBPIqEbKYYxxuE+uJczt5TH68NHo07pHit16qRqNqgC9kIyzbxoIwKh5Mdi8HaODguceeWF3WQTy7Ajm14EAAfLdjbM/NjgoG6aZCzsFdBe23XxVCyK9UWz5sobDitfEiWs/tE+1k2MJUQAQiOP1ZgPxpPHmTo6r24K3Tg5DqRMQYaBPwLEtBOZLgpsfA9iD/FLTyOvnOmbQ91e/SlFNpZeXg7xLczL4hJxs8YhYgQyGvNWKy78J5va1YJbKCDOTGijkPFQo5UUESs1qrN+p1FkEL1z+Veo04HqKwnbfRkvc7bpd3DWn8N7HWPvN8oE0yCn5a/hYq3Aug07D7i6u90OZoVBKStsk+XMlmzo+dx/1myad4MEi5O9rBuUS6NAacNZGIjOIx316sbVKL7e3HsrXhVG5D/DFv0AsicOx6fJ5ZdX914c4Ro3ck+1Vlo2xXJ9L0J+T+ywshSC1GBX5Epn1VRXv8tDgM0OHWJla3KH1GvrSQ1S6Wqpp8fVDfGg2hpZcXT
 C1/wwpom
 v540g/xtJaYstCtGrsHgpMnjWiuQXvnX4ebRQFUg4YSuHTAmKD+1wW2Lr+n69oGmCgdngWWe2avcp3g+Qark7OxWFPeYHS0wrOPkn/5/DZHjpiZNbkB9IHaXw/W3GOo/1f3PcU8Coj0dmqQdhVhXmUc8lqO9cvdWuzoaJrFTveMg1eEf5BjSK2ox6ICsY+XUU0SorQkUzSmbIng+/dKoRuhUqaGH9yoS8U4QZckFAJ0FU+qGLFCaUwdWGmgA+28Igdy6j2x/g6XTarCz7cJsqq0kxz4ZJH8Kk2sZm0BBGCTi3YT8W8y2KMv+kyfxEOP2ghILqHuZyle/nHPp/UXzRNXALtLwKlrKeJCNrT0JqEAcNIeTXcYRI9rsA2D/+QJ7hvNamrICzMio/I1PLgvGGQOVTYDaIug5yF3EKYtWL7rBHa7NXeZPewDQIl5qMfaDmOF/+nfNCfO1rL4HzDb2QdOPnzTXXAeA0sdHzX+0C4axPYL3C9EildA0M6Kg697tr6W9vUvRTfcPiuthcPV8/bbspjaDklPefpf7PwHuLcpfOSM073+R2e3mQtepZvedwf3Gwrjs7OmxRqns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The goal of this series is to let SELinux prevent the use of FOLL_FORCE
when a process writes into /proc/self/mem and the system is configured
with PROC_MEM_FORCE_ALWAYS (which used to be the default behavior, and
is still used by current Android devices).

Android has SELinux policy that attempts to ensure that only trusted
code can be mapped as executable in several system processes, but this
protection can currently be bypassed by writing into /proc/self/mem.

I wrote this series after discussion with Android security folks about
the state of proc_mem_foll_force() restrictions on Android.

I'm sending this to:

 - maintainers for LSM hooks
 - maintainers for SELinux
 - maintainers for VFS (because I think they generally own procfs?)
 - some MM folks just as FYI since this touches GUP usage
 - the Android folks I talked to about this

I think this should probably go through either the VFS tree or the
LSM tree.

The motivation for this series is that Project Zero managed to write a
remote exploit for Google Pixel partly because of /proc/self/mem, see
<https://projectzero.google/2026/01/pixel-0-click-part-1.html#whats-the-plan-seth-and-jann>.

Signed-off-by: Jann Horn <jannh@google.com>
---
Jann Horn (3):
      proc: refactor /proc/$pid/mem to use struct as private_data
      proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
      selinux: require EXECMEM or PTRACE for FOLL_FORCE introspection

 fs/proc/base.c                | 35 ++++++++++++++++++++++++++++++++---
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  6 ++++++
 security/security.c           | 15 +++++++++++++++
 security/selinux/hooks.c      | 27 +++++++++++++++++++++++++++
 5 files changed, 81 insertions(+), 3 deletions(-)
---
base-commit: 2f1baf1fc8929e6c48370be543ad028ac7ad4131
change-id: 20260814-selinux-pokemem-44625557c4d4

Best regards,
--  
Jann Horn <jannh@google.com>


