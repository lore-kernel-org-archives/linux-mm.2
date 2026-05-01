Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85DD6CD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 09:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85EF36B0088; Fri,  1 May 2026 05:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80EEC6B008A; Fri,  1 May 2026 05:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FDCD6B008C; Fri,  1 May 2026 05:49:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF4D6B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:49:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF1D61C01BF
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:49:28 +0000 (UTC)
X-FDA: 84718378416.15.3C67C5F
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id F135A20002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:49:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HihHqxwG;
	spf=pass (imf03.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777628967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1tin0jspbQdn8mi23t+nODJtrr3QhSqiLRjH754JK3U=;
	b=F11iuaFQigAlvsj/GfU0JC1VWKRr0ACo7KVGQtoSt/mhzCS/ql2jDBAs9B8TUYgNtQoJim
	3HdSciVUEm+jcvGY+bV9Fe5mQ0+r+bwjp/wXkzYGVBcm3vOTcn0ccvIRupfN82z7qD4J7/
	YI1epFAdwYobRKswAdTAFmaUl5FP7Sc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777628967; a=rsa-sha256;
	cv=none;
	b=4Toj9NIKlD73wzIb9jzptoav0wTXKv35u+ASw+A/pObXpymxAM2/yVN/b+SvArmMMzmoLs
	8Jv/OsaIIyAfBR+OxLmJoqIJhLSp7l1Dig4P/oZr25PqMu3E9GD3ZS34KwGWK/TiE+WNDu
	Oza4+vvuzrOCGhm5FZBsJ9ziiKeRRZk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HihHqxwG;
	spf=pass (imf03.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-835066ef130so865623b3a.1
        for <linux-mm@kvack.org>; Fri, 01 May 2026 02:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777628966; x=1778233766; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1tin0jspbQdn8mi23t+nODJtrr3QhSqiLRjH754JK3U=;
        b=HihHqxwGE+aWkDKuYCVejDGWgFU4PSSehK9ATVhRYAKrwRfEEL+qVerjlHleqd0d1e
         qJowZBSYAOdkmyhpgTi9ELLR9whSCKTY8uy3qz2EFbVWqk9aqjt0BMkmku4drSjAiUJm
         cIQTli/jWDFm2vdT5JlWelbx/9L1Ieqe7AmTpAaU0n/LUWDRwFYxtIB5MdIh9hscRVQ0
         swVkm+NRVbmxiqlA/mN3D/gI3HKgpcy6JlfNkmZbkynwDecuYRrVVFZJgIjunzF704Ci
         WOOq/RdGd5AgHOmGA8f+LN43Hq+XUUCOp2dn3xYM13NNfvtmuV6bDDsgqxNxuNfhMs7M
         82Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777628966; x=1778233766;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1tin0jspbQdn8mi23t+nODJtrr3QhSqiLRjH754JK3U=;
        b=cf88lDkWI3wRWfOZLQCRKFwrJOiPvjTYEBz+R0qsXlz4vFf6GB5gfHN8U/+3JAouqj
         OAgWfLn+uiBtRFK5JE7C16tVAK0eRxxNdpAC5v6LRS6Fil3HdO7Rxfy51U0t+5LM7Beb
         hVWtUfdT/amSCMGGOuxgte7HSbtebkEPAyFBI2FMAzyJyI8pxSGST9BfngRC77BtciA3
         bvfnDic8MMZIoeaQnYALFJB/5aSwF9yCKF/8gGdgyU0DB5g/m97OB3pGdHZbcLsnBcNH
         kAUuxf+i8VklpcbcREAU4+QOL7JvncSA69JWPnoVI7HFAzIZcdAfqzdxCH604VDfrYE+
         jouQ==
X-Forwarded-Encrypted: i=1; AFNElJ/md1Fr7FFx+IK7Ta0qJs3O0sR6EL2lbtlZU6Xs3+hxbHb404Wxcl8AM6LfzLV5bJfUz79+msJyyw==@kvack.org
X-Gm-Message-State: AOJu0YxTvgvaokyUhJkAoo/MSr2qmoZuYLSGPwX7C1qGbjLxBNoxICYY
	vOOJu7jf90/98YJ4zy3mk+8oxKkeGFaBKUtLwaP0PRrpTyT/Q3aTYkor
X-Gm-Gg: AeBDiesMAEVbwtXQEHkWNEpto2POhac1XHImWvmEdlV8/ZwodXWRBzfUSVQ15IMB20a
	O0ELAE/dSCLwey3xEcLyiBQZF9il59PT8hvy+hyGs5jfeTQo0FpRYSVWVsIVrbWb9YsQw/cFhQ2
	SwSbvCHDb3gZD4Y7lmQeZeNF0MvQit1KtQP+1YIkr9aiWfw/3XDz+kN/0Rk+e4cxRIauspyNUHM
	4TikokQ0kacENxbp5D/4a0F1iWwmlxzl/yWfSd6UONuPPxYqxKM5d4VGTPwDRzgkVislevHUtct
	nPW903v1gPEik2QQOsc0ec6y/SbPmFpMRcsFFSBvxx1/OU7pjd/dDOovQK/i75sSc4y2Lt8ct/G
	WFtiSZ1x8jhNVrt3G5khNMTUsdm28Hb8gaLt8VKd4zzmxIf425H1PzCUxw7iwwGJ0SH8aggRL5M
	x86lpzFn1n4c5Oy91fh8ssoHC8uGrd674ZOXQLWg==
X-Received: by 2002:a05:6a00:8e01:b0:82f:9e98:1356 with SMTP id d2e1a72fcca58-8351a31126emr2478609b3a.20.1777628965625;
        Fri, 01 May 2026 02:49:25 -0700 (PDT)
Received: from laptop ([2001:4455:8025:be00:eebe:247e:613c:24d7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351582dd55sm2042729b3a.1.2026.05.01.02.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 02:49:25 -0700 (PDT)
From: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RFC 0/5] liveupdate: validate restored LUO metadata
Date: Fri,  1 May 2026 17:46:32 +0800
Message-ID: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F135A20002
X-Rspam-User: 
X-Stat-Signature: ss4ntzm5bs99n3cajg3dwqww5yxisr1p
X-HE-Tag: 1777628966-693992
X-HE-Meta: U2FsdGVkX1/6qhkZag9rfZH3b1tjQdniispFgTm3bOQ+TW8jvKsG0F5k1DqJcNzbNYH72DJSukXaS1WdG92k4eS3R6IkhHEXlBKzTsDObPlo7QyEtd8liiUktF/13fYkRzZwWkVMb3I3+oLMnUtH5tvjcUw6d0ngbfK9F4m7XsmFyuuLrtcZfv9yEThvnmty2Gg76yL5lzp/G7XWWQgDdWbxNwSzlx+B/ohpZeW+OW90tk9PDAAsPs27eMsDxhge7hch94Zdwyy2866I192xVct7NmDlY4Ja6wQMzKSOqTNyIHhVIIe98IGxrqo/3rYQDzIjSpSTou8kGYNkxsXhDyAhH+OriqoGsgR+m+8JAdbcC3uXCiS2YVx4ZqA43eZKg22ZeADsmvh00vrEAMUvEgaJaYBH6hHET5Wj2jcCUoYVw5JYAfRgOV7Qrp2dqqRvo0dgOg9u+1neRT0XLHpE61xPWup3AwK5GFtn72QabiACiXZvLYR6NX/au4Lpjn3Pf9ILwWklq6QSUdHbawLj3D6wz4mnrtmY6xnyVWfO+A14q7/+0S/FYg5oq/Y1o1/ySSo5K12wdUFdifaFyrEV3GPppWcU4iSbDtFVIFRig63kMpNqOX7iSmmuPX6NkrOgtSFoL7fOQ7dczM4e4qcH7SgS+sgFR+3bffudJmaJbEA0i3wua+OlOocsEDPaW2odyaK+YgH5VpbRW5c8VlD3DbU3aZeNlDja4ofSwJ2mxGnJzS/Frd60l82Prk7maaLU9B8QrhR3IGYqynLuLatDre7+BVPf7Znw41g9YFXVEaP7/uwQzNnoVAFsr0zJIK2+FJntJ9cH87lP6EvNX63zjXcyRvjIbvF/GqesxAvb6A083fUuCe8vpTpequyLvmusBAG55nGIXHxTufgl8qugeWF0p0vdFu1LXQC/IHMXauxAg3Uym5q1vUb2BPh2f1fmIjokL2Gc/Mwe0/ZE6PQ
 sB5/aDJw
 3oAvNwTNbxMm8oZHkdjlpCveXRaDS/hi7CDXWk5s9GMJLLknc7hmlUZZhBptp7+It2/zeemt1YtsR8qRBgTeChfM/ocmambfcBm6N+nIK66kIHGTFCegm/Wn7rw34w41Wb2clOG5mb69DsBBH71OS8/aH7STmA1vMRXQ0UaoXxxVsezFuGq2g7kDT5diB5JF6BW9Pk1iTsehiUUd+o3647zIC13HIrj4VJFb0tShQ16/j/IMjKj4FDs6Eznrk/Az28GBSQJDGbJN4kfezA+9QcuXG/ARl+DjgZ87XtHa4Hey7CyoV7SSNCt87YAXEvM0vISYP9U45SQo7cti5ChjA58pRau+Ah3227UXo8eygjTZMa7riI8fE7IqSZAgC06GoRh4zqvNJzZnbJjQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

LUO restores metadata from KHO/FDT during liveupdate. The restored
metadata contains physical addresses and count fields used to access and
walk preserved session, file-set, and FLB arrays.

This series adds a non-consuming KHO preserved-range check and uses it
before phys_to_virt() on restored metadata addresses. It also rejects
restored counts above LUO_SESSION_MAX, LUO_FILE_MAX, and LUO_FLB_MAX
before traversal.

As far as I can tell, this is root/admin-only; I do not have evidence
that a normal unprivileged user can trigger it directly.

I have not reproduced this in a VM yet, so I may be missing a KHO
invariant or a preferred restore helper pattern. Feedback on the helper
semantics is welcome.

Cris Jacob Maamor (5):
  kexec: handover: add helper to check preserved page ranges
  liveupdate: validate restored LUO FDT before use
  liveupdate: validate restored LUO session metadata
  liveupdate: validate restored LUO file-set metadata
  liveupdate: validate restored LUO FLB metadata

 include/linux/kexec_handover.h     |  6 +++++
 kernel/liveupdate/kexec_handover.c | 35 ++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_core.c       | 10 ++++++++-
 kernel/liveupdate/luo_file.c       | 14 ++++++++++--
 kernel/liveupdate/luo_flb.c        | 23 +++++++++++++++++++-
 kernel/liveupdate/luo_session.c    | 22 +++++++++++++++++--
 6 files changed, 104 insertions(+), 6 deletions(-)

-- 
2.53.0


