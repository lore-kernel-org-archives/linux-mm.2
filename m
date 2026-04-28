Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61795FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C516B0107; Tue, 28 Apr 2026 19:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDA16B0109; Tue, 28 Apr 2026 19:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC586B010E; Tue, 28 Apr 2026 19:37:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 774436B0107
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:37:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A76F1BA301
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:33:33 +0000 (UTC)
X-FDA: 84709568706.09.65A43A5
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9CF901A000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:33:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="f/dFz9NZ";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3yUPxaQsKCGwKMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3yUPxaQsKCGwKMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777419211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JywkponAAlLbpKs0ZR4pdZDQ9JhpG3xml6Pp+KH2bc4=;
	b=E+senu+iY7dnlXAAQMnSJdqDOV9Dk5uj9p2m0b1tTQKT0rKjvS+WXG6KqoZtH6lRiOHNrb
	Kysap670MagCFclImGQN2C3PgcH1Ym/BTUlYMtLLUDnDSkHreIcuX2wwvLT03WRKB2GgBn
	URxY2bKoAXqWHfRdJhQtVWmKZ/vEp/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777419211; a=rsa-sha256;
	cv=none;
	b=oSU9IOAz1fkzk+CNHZ7VtvAk9N65ovFDie0Re8k2t4DZHEX0NKaEV24SuVWcdqRD1UpQOf
	aRjqIW5jJmDgyo57FNJ5QqHwPOe3kgSxDuZ4gH9soVEuFfFDgzEhtDBHA39q6gt47NPug0
	o6ol/rGSfesxhm8NdLvucptW/Qhfr0g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="f/dFz9NZ";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3yUPxaQsKCGwKMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3yUPxaQsKCGwKMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b630b4d8d52so7070680a12.3
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777419210; x=1778024010; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JywkponAAlLbpKs0ZR4pdZDQ9JhpG3xml6Pp+KH2bc4=;
        b=f/dFz9NZmE46nTudwaP8v7eRUZVcrpODp7UVgrvu/kffJkCNR0jZZAE0i+zdg7Jm1A
         Z21yr9rC2J4An5KvOtQxwUQQ6LKP+jNwmppIgR8eNaU/nRdr6Ar+yb7P1eVxcyftrT5Q
         qxLYJrGU1lydqdfy+yj+BScA4Q0Ei48hIh0AhWUDf4dN9aztV1Gm5wFk6651VU75y/y1
         vp3iHe1RWb7orfbq2V//I7a5ouTJr7veHbBdf+KLkZsWiTabT7RKOCaIbRFU1Ic/Ga3Y
         QGAw9sfRhIM1I2hLFc+ymo3B23cMsLfUjaitlb+/gHYR1q3PlCfQhAGOAlL1NFMTnH5V
         /rIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777419210; x=1778024010;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JywkponAAlLbpKs0ZR4pdZDQ9JhpG3xml6Pp+KH2bc4=;
        b=syiDecMRfsvose3KFJcPeE1btvCNKJaLMb8udnBE2nLxjxlZ3zRW0EE0rUz16vU1Rq
         5oJrnRCRitTMf0tITJMpuKYPovnbxniSYKyfh0wFK/4vAIjT3LmENmGON8ruWuXpnEUV
         BozQTMAbEmRaeUkqo+lCIdifKByosXet4DfiJLkxXKBp4OIGT0POBvabyyQU5+B+ueMG
         rmieGKDs9hq7yD9TipbnImJYri5p/C1Cc/BaKYiZZKQkAvWwrN6xqMU6vxGRKnuko9oA
         eNnfyiZ6Hxpf28hdrisQNLcIJ9DtQUzla7tFsubBWw5EUDQd1D0WwYfd5QgF+99DIiQQ
         Taig==
X-Forwarded-Encrypted: i=1; AFNElJ8xw3BWrexr0rfzF4f8K5E3w04bg9v6am7LScuVKv8riZBFCLQBZlKHhlBaFnAMy6DLYEVpZcobMg==@kvack.org
X-Gm-Message-State: AOJu0YzRHjhzfKI05kM0x+QpG8JSm2s8DM/JuOm1FZduia+Ue8dOMWGh
	1O2c1IGau31EfqTV+iKw/m5C9wkw+547u+hpApsWocWd63lzcHraEc6iJunz0agb8nyR4dWaLoT
	bZLy0A2Dr4nkwZH1ksDNcgW+vQA==
X-Received: from pgbcr2.prod.google.com ([2002:a05:6a02:4102:b0:c76:1d9:8c20])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6a20:b0:398:8546:c3fc with SMTP id adf61e73a8af0-3a39bffeb82mr6084413637.7.1777419209934;
 Tue, 28 Apr 2026 16:33:29 -0700 (PDT)
Date: Tue, 28 Apr 2026 16:33:20 -0700
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
Mime-Version: 1.0
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <cover.1777418884.git.ackerleytng@google.com>
Subject: [POC PATCH 0/6] guest_memfd in-place conversion selftests for SNP
From: Ackerley Tng <ackerleytng@google.com>
To: devnull+ackerleytng.google.com@kernel.org
Cc: ackerleytng@google.com, aik@amd.com, akpm@linux-foundation.org, 
	andrew.jones@linux.dev, aneesh.kumar@kernel.org, axelrasmussen@google.com, 
	baohua@kernel.org, bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, chrisl@kernel.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	forkloop@google.com, hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, 
	jmattson@google.com, jthoughton@google.com, kas@kernel.org, 
	kasong@tencent.com, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com, 
	mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qi.zheng@linux.dev, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, shivankg@amd.com, shuah@kernel.org, 
	skhan@linuxfoundation.org, steven.price@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vannapurve@google.com, vbabka@kernel.org, 
	weixugc@google.com, willy@infradead.org, wyihan@google.com, x86@kernel.org, 
	yan.y.zhao@intel.com, youngjun.park@lge.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9CF901A000C
X-Stat-Signature: xiue97bqnafi75qtp5rrnshq4auzyfm8
X-Rspam-User: 
X-HE-Tag: 1777419211-329310
X-HE-Meta: U2FsdGVkX1/7KmtWEX4ScOK9++XnZMniyeBZAnqP2JJC6KESk7RdK1NMOnbj3JXm06i2TcxHiFlNnfIirExveAf6eGIBac1kSh1UfbyswvFRFmXXNzfgPhyrTR1iVbp+KOgNweFX7lhw2muUo3oQGVB69QtS05yEHpd/BVtWf76srqvG/zPQsltCwp2p/EPIQ6eJnKpjlyuAdZRSv+uw+L9kPO8u73YV7RUJDR62Y//nGMCxpWgztcLt+i0f1BhhnlDAlFAjNFIkW1eqdrJVXN9n4YFbfsvmGWuqgywZsakBow4IfB7/c1/AF4SvrNJE4t+HgLMHSdRTtD1s4ZijKmGRM9a/o9WB3VR7B3AD/MoVlYRoSMtwsmQQK8dKIpU103k/pff1hhGgk+rRLbKknycPcwuWUS38n6rkmdmCNO8y9xNZp8tc3lusGPxxWUP59sEjUSmG3f6r/HJIzYJ43V05A2dqIYdNOfDy2XrAeqrJsHMjIMleiKe4wtpx7OUkp0G1dmreN9QshDRliPM6UW5JIuIqGguHleqqaCyvaegjvTfE4fzVtTCmvLWyUSJhHhR4HzHtTJ24EL3ip7U2X+mhl7vbT1C5N94ss6gHOXpiQ1Py0Yip1IR4bmPtFSBfmP0l15ryL3vwPfC2IgmCjxCKUn5ua6c0VAsv1ku88lI0WAaAywwFjbgL0z3FQqVuz3m4EYxqjCx8r8Mm9omJ6LNZmCcWwyC0L7trF6qm1dKpCFBbPivQ6XBvZHLVReaTPktDuuQdh2XCqFAx91FbRwv1PLaN3X/8vPSOhl6De9sxAReZH6X8/bEbjd2hj/8FH4D9mSmGyA1aJHa2rov1IUBt9MD/TS/F3JMhuYQBDWcFlmUMrn5JVkAPzURGZpdcBSj6znDPGUZYW+WfbephfgBziUAnbQiS1lBRCtSJRJlIJcwLfLyZ7IRobh/eYWPvrcRWhRvGgbiCifq485b
 /R0oqtFI
 m6MWdi2YJX7YZthpvy8Ir4rV4bnfQBTzjOGqaX2W3l7dWk7jsS1iCwLxsGxUFORxdMtnNmtugy2/T0L07zjZYJjGGePmX9sRdndQA1gn63/smcx1bvJ5WUP3IfmuCp2xfzaJ9EWPW4x+Sw1LYHQJlvFocdGvHGaEJEVz4ktgEZ2IUS3hZaVc4WaFhxcUv4LvQcrsnBASKFpzIPoZEmd9z57HH623E0/Y4kbtPhwKagp6ix5VreS8QeES/248pZFI8uFoIw45bIVL9hxWAKP+Vf2H7oWg10KnOlnGrcJQzghNxD3N+zXR33vND1jjrjkzGM/ZFHeTFdgLsAY7+UldOMQhV7R8QPuEOPVqVxt5LEuhCnpTF9R8I3I8G6myyVjEfBQQpRjx2TUAyRs8h9mQGAkQC/icMPsOV3Agbax9m+jd1YfFzuqRhrs+Wa/5/Y5f8wlxghDhO/WxBDNwvaxUbsKOaVEZI81+7OJl4U+dXoeR5odgzZrhvTTer0epX01kDuddbZEktZnlhmLOENX9vyDKDkc0ZSPFlDhInMCFs/MZYTAHrYqCObcSYwSnZFWfO2ajftyZ/n4lwMXqoR4zvthqS9nG71WCJBWh+xCVWWla71AZ6x5/YLBZeoMXNGb78vo28JmrR+/WgKN6JBeqTUSr2RZit1FbGSaCNrv2+4Q8kklURC8DUyG1rbql9vyfLN7kAFoEZ7+NfWClyOB6DnyD6oRnCmhwrSZhd7oocDUpF9ecvwBPMbcH3mFrTZvdOK95u0iMNjlCzkodSweJ4MYmYpBHfd1oQWEk3imwKiKNig3RP86rC6TMdQtVAREicSE9QJ9DKs+Kt+/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With these POC patches, I was able to test the set memory
attributes/conversion ioctls with SNP.

The content policies work, and PRESERVE can be used before the SNP VM
is finalized. SNP_LAUNCH_UPDATE can accept 0 for source address and
the SNP VM runs fine. :)

Ackerley Tng (6):
  KVM: selftests: Initialize guest_memfd with INIT_SHARED
  KVM: selftests: Use guest_memfd memory contents in-place for SNP
    launch update
  KVM: selftests: Make guest_code_xsave more friendly
  KVM: selftests: Allow specifying CoCo-privateness while mapping a page
  KVM: selftests: Test conversions for SNP
  KVM: selftests: Test content modes ZERO and PRESERVE for SNP

 .../selftests/kvm/include/x86/processor.h     |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  12 +-
 .../testing/selftests/kvm/lib/x86/processor.c |  13 +-
 tools/testing/selftests/kvm/lib/x86/sev.c     |   9 +-
 .../selftests/kvm/x86/sev_smoke_test.c        | 255 +++++++++++++++++-
 5 files changed, 271 insertions(+), 20 deletions(-)

--
2.54.0.545.g6539524ca2-goog

