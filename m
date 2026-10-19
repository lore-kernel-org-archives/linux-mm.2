Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D31ADCCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B39CF6B00BE; Sun, 18 Oct 2026 21:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B109C6B00C0; Sun, 18 Oct 2026 21:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26D06B00C1; Sun, 18 Oct 2026 21:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69FC06B00BE
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:14:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DDEE31A0617
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:14:55 +0000 (UTC)
X-FDA: 85337606550.02.13C1932
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2A60DA0009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:14:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iddM2vu2;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792372494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cpnp3yMFelG0fvds3XdN1g7x4e9nS7OKWWPDPS530n8=;
	b=PEmIr8lPJdsVuAOpkMbPpzvU8P70Ye/o2wlsz6b5a6vEXak4Chg4kxdsOa23A4d7/97j/g
	IempDfl5kIH6RRisO14ymXQBDLzjR0dVQt33/mMTbNOzQH5B0e/b/zd5Wpk4deOPopkzCi
	MHzAlSODPNEnfbMw3hQwtadwOxX/62U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iddM2vu2;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792372494;
	b=lFIvcq1KH+xgznj5ncsFgFTo9Fv0u0kdyNXBF/vOJ9xBu9o4B1IMXFRmV7n+VPk1mj0UUN
	Q0nUNFA13rOuPqNoO38qZpNI4U5wG9ckBUHybP+RPI5F9WX5fuIhtCYMODZkMsq3WwAGHa
	rLAnF9pFCrrdhQGIztf00twMchLrT7k=
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-99071945aa7so1008056241.3
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792372493; x=1792977293; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Cpnp3yMFelG0fvds3XdN1g7x4e9nS7OKWWPDPS530n8=;
        b=iddM2vu2qAn4TOd49AeWBIa7k5w+vkSybs0rGRQ5T7xbzLK/HhOtr9B1GyC+lyB1Kq
         YUT8gk6fQnoeWnNPvRW30Lp1hhHgIYhoUoE/HjV+TiVTOGACyUDYIhaCPf1/QWoeWbTz
         NNWy6TvssltGP7IM0XsYmEV0DbCdtfiA1Kh6q3dTjY6K0tje0ECTm0hb7p1p2swMtTMR
         Hrdh8ubqWbcJyYsGDgtlZMZE/IGx8yDqtzGJUJYOB8RWcl7VbwzDsr42DejjwByKrZJM
         orQ83s5PFL5UKsGr4vBud74lSCIJuqziQ5mgz6hXL5QC7+ZayYTbAY9Aw4vKZLAha2JH
         oV9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372493; x=1792977293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Cpnp3yMFelG0fvds3XdN1g7x4e9nS7OKWWPDPS530n8=;
        b=0buy+SHHRh0HPSOpAUJyquuHmBC0rHgEqpPdnJMeXt8WEggJBHYyVpz+Yq5Qqr4NBi
         6IJwJvOGLjhD8cdeouReL1sdxhTxoyQGeWQyIzAlpFeZe9H9FocHNuUEERD+AJgvNh7q
         1/mlugIPLWVeCX4AGQZZ3q23U1ATw/B/2UWIuhTqVQd2ZfAM6u/6qGH8lZ8xYvInALiy
         ibp7K0h7iQWY70YzY11jJm4Wjf+gkfcSztfg0cvhmOOtaxOxKuORE4o5N+Uzn+pPNBqc
         5fX8byqqB5Hv4WaEZ11LJKM0BZMYCRDaFQeXujvzGq3JWJ6iaKNpK9S5P9YztQnrj/Eq
         3w8A==
X-Forwarded-Encrypted: i=1; AKwUvBxudCgpgQLvjjRuxiy0STy9Fh+O5MiMbXosatP5EyqmwquyHXfEttWkE98kyPKrTATwKbyg8KkflA==@kvack.org
X-Gm-Message-State: AFq9FYJt7MJFr9YDo/Ii2SeyDVwhGiE5fw8d4r35yL0ltSMQiTrcWumV
	AEG8R5t9jeaPdVAAmHJWAWcQ7oJA/u3VK8q/H+zfovDm1b5PwaLTRlAtrVlAZbvpRNU=
X-Gm-Gg: AYBFou2F4sV0/g93FObllR1XsBl1wa94FlEonfIFAys33Ht22CB2GdRi1G5qh41Rou4
	+szpt6poR4fbwLV43eHm8b8GfWcEirfUIzV71mVhpxqoyo14gHppWrtBgoA9JCs0+O3RBbQ5QBQ
	wyHdiC9oVZfuh+2Lg3zYBKbj1F14Hsd5DnmSg2b0v75tnKGnRa2bzrJpzQ64E1WNAklV2IOCFkg
	zCTHvsH9PKO2OXvS9igtV2tTG1gg3iDrNhz+jynp4PsGJqCMJ3Aael0jrYpn+WbSO6UY3ERGtR4
	0WdE7IlIzUtOlliyUzws5LvMkFIeJjf+ucfjGKXVl7hj5jk/Mk4ocaTIURVTRuWGn9eUwvk1EIF
	K/Yg37Fjufk02yfC1ZhAPlglM++fIknAuV8J1n0k7gmHjb1sbRmiAkrrueJ/DdcqzyxyKw7V2oo
	mI6DWsr9CuO2XN3Lm2jEXBKgzr3Ibi9h/grHFPJoT0kPpO/fWzC59ERA0ifwKHV5OBAQ1is54Cp
	yY2rHBYjf4T+guyTCpqeKTTEj7L+V8TdkHj6nioJIaSq3P2gXXa7eUkHcNkjiWAvRpPAu2dZYU+
	p0vzQuXL9mbxgJD6ABA=
X-Received: by 2002:a05:6102:290d:b0:7c7:f976:ea9c with SMTP id ada2fe7eead31-7cc369118cfmr2079452137.13.1792372493221;
        Sun, 18 Oct 2026 18:14:53 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b474b2asm8039142e0c.4.2026.10.18.18.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:14:52 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kees@kernel.org,
	rppt@kernel.org,
	juri.lelli@redhat.com,
	nik.borisov@suse.com,
	tglx@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	vincent.guittot@linaro.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	cgroups@vger.kernel.org,
	tony.luck@intel.com,
	david@kernel.org,
	mingo@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	ljs@kernel.org,
	zhangguopeng@kylinos.cn,
	dietmar.eggemann@arm.com,
	mhocko@suse.com,
	vinicius.gomes@intel.com,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	peterz@infradead.org,
	surenb@google.com,
	hpa@zytor.com,
	x86@kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rostedt@goodmis.org,
	gmonaco@redhat.com,
	jgross@suse.com,
	mgorman@suse.de,
	graf@amazon.com,
	linux-edac@vger.kernel.org,
	liam@infradead.org,
	ridong.chen@linux.dev,
	blum@kernel.org,
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v2 1/8] x86/realmode: Remove unnecessary WBINVD from AP startup trampoline
Date: Sun, 18 Oct 2026 21:14:39 -0400
Message-ID: <20261019011446.834487-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2A60DA0009
X-Stat-Signature: 7zjyzy9zu8cw7pwjumdg9de9d7jaqih6
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792372494-741175
X-HE-Meta: U2FsdGVkX1+ugPsBPmNeEh2AE1K9UlABhNNXFO4B9VddcCHdQBN/H/G0WC+l4iN6vK2GpsMv6Dl6YKWJeEvulhJD69kdQkLjBjnDEm+baEynuSwQHRZEJQQkhlnMgDtDmYCucDi9z7jnCmISpuMlipnj0JgEiQG6jYmC+R8i4NHpmJ209DrUo7Vfgnf7xhpFjU2dLqwxNwR/i+cj7ECVqmAINKqwTbRs36IpSEo6e9I1Fwb+CYueU6YHyRK4efDu9B6iuN0R7NVxqJcSXpQ79JJt4H8a+z0vPFN1wFcq+Yj0jv3nU5ZptLZgnIkkrMuKHmshpodTpXwFXwXp94rZlmfA1prh6snQcqFt9IZYOdZ7Hy02ZrOt/2rVBFaZCth+4B47gMP/UU8u35zEWfcV9JQBW6Util4oTRHWDq6mFJK7Es/m/UXSO3PE7p8nbQc4mgerGqM2U0AlsuhS7oOSXzglFDlYIJSPkI+x4fxG4s5EQLxI30PF35hsOH82B5dk3lYOzcGvB95raw1MGSIyMYZEaBkeqkdqsmj//En14SY8Lv3W8Z8UZQXXvp4mCZ2YOLZLAfN7dlruuY2EpQxHw1g2/ltWszp55aYnMGQCHQ5hgXevcDpulLVlO/VGyKV5R2mpNrB252K/jY1VtTj5HYERxDSidpS5wVoFrv9pbzMMew1Hrm6PNkqFKZjo8oD33GSADUh9EdFL540mcst3Au7mhODcfjMYIs6ol1DhSCAbfBkaCJXdPVOJiGVbKQbmZuJWDzsMUPAOtF4TIdFcpDGLLJqM1wQC3lieLW9kUb6iyCa5iXq97CFzM3pXoI17NGkJTYesgMpyh5s5Q+t/Mbrk45Hf0Z/ltumPkiaxcaJzQakhqx/p/iFbr/MtAMfZOa8BH1JoM4++Too9VhiRAfV9gp1HXdGWDpUnXqV0GGt8chUjzRs/lrBgK9q5NG26x+RD1BgRn0wfM1eS503
 PpnvYIwE
 7y9w+n4lMZ02l9n5i7h7wcGgHrvF1DAhTiVLyAYlLFaQK/Ny+APms/bYKYtRCwfQpWgTfzZDQHC3e+S5QLK/gQaLbY4iIvbxH1eljngcfd6oSdj5xkJC+I+3ZWOD+uWSNd0YGnGgShotRYXYEOD+PVYqAaTarQc2iNYyhvJz2yUlaZVPpBnWGYgqOG3o2YpkLEK8bIxbTatRiHXuVZpBG3itOWiloFP6de+h/5JgWYiBeQ/hNRXWq+h6qvEE9B3mwp+9btcVc93C74nhnFHjOAQ/mBxgkN9kx8//pvXtDwzrPcXcEvVBk2T+7ROc2vlUlQsRvJbLTpgrSZdc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

trampoline_start executes WBINVD in 16-bit real mode before switching to
protected mode. This WBINVD was originally added in the 1990s for
Sequent NUMA-Q hardware (as noted by the comment in trampoline_32.S:
"Needed for NUMA-Q should be harmless for others"), whose cross-quad
caches came up non-coherent prior to OS initialization. Sequent NUMA-Q
support (CONFIG_X86_NUMAQ) was removed in commit b5660ba76b41
("x86, platforms: Remove NUMAQ").

Per the Intel SDM (Vol. 3A, Table 10-1, note 2) and AMD APM, the INIT
IPI used to wake secondary CPUs preserves cache contents and leaves
CR0.CD and CR0.NW unchanged (0, as already enabled by firmware or the
kernel). Neither sev_es_trampoline_start nor trampoline_start64
executes WBINVD.

On modern multi-core processors with large shared last-level caches
(such as 504 MB shared L3 per socket on Intel Xeon 6985P-C), WBINVD is
not harmless: each execution flushes and invalidates the entire
coherence domain's caches and takes ~85-115 ms per CPU while disturbing
active workloads on online CPUs.

Remove the obsolete WBINVD from trampoline_start.

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:  40.40 s -> 40.46 s
  Online:   65.83 s -> 11.14 s (-83.1%)
  Total:   106.23 s -> 51.60 s (-51.4%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/realmode/rm/trampoline_32.S | 2 --
 arch/x86/realmode/rm/trampoline_64.S | 1 -
 2 files changed, 3 deletions(-)

diff --git a/arch/x86/realmode/rm/trampoline_32.S b/arch/x86/realmode/rm/trampoline_32.S
index 3fad907a179f..14e56ea95416 100644
--- a/arch/x86/realmode/rm/trampoline_32.S
+++ b/arch/x86/realmode/rm/trampoline_32.S
@@ -30,8 +30,6 @@
 
 	.balign	PAGE_SIZE
 SYM_CODE_START(trampoline_start)
-	wbinvd			# Needed for NUMA-Q should be harmless for others
-
 	LJMPW_RM(1f)
 1:
 	mov	%cs, %ax	# Code and data in the same place
diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
index 14d9c7daf90f..e5a3f03d6221 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -60,7 +60,6 @@
 	.balign	PAGE_SIZE
 SYM_CODE_START(trampoline_start)
 	cli			# We should be safe anyway
-	wbinvd
 
 	LJMPW_RM(1f)
 1:
-- 
2.56.0.176.g3575e65682-goog


