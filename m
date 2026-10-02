Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 175E1CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 17:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09C516B0088; Fri,  2 Oct 2026 13:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04CF36B008A; Fri,  2 Oct 2026 13:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7EBC6B008C; Fri,  2 Oct 2026 13:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE3416B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 13:57:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37FC4C0802
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:57:03 +0000 (UTC)
X-FDA: 85278442326.06.F14F544
Received: from mail-yx2-f38.google.com (mail-yx2-f38.google.com [74.125.224.166])
	by imf24.hostedemail.com (Postfix) with ESMTP id 251DB180007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:57:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=truenas.com header.s=google header.b=a5KSBSOA;
	spf=pass (imf24.hostedemail.com: domain of ameer.hamza@truenas.com designates 74.125.224.166 as permitted sender) smtp.mailfrom=ameer.hamza@truenas.com;
	dmarc=pass (policy=quarantine) header.from=truenas.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790963821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xxaI2OMOwwuqBrxKvOI44CslxEdzYP5+0cKedVWBK0M=;
	b=kZpWiLJkYs27kRqN/4JvegpU/F3Ix0e4g7PqjHt4NiuC1AKoF2tLxlrj31kC1boxD+MToE
	eKEGwtTtPGb62MS9M6qdYPwxp5PvAdJwALXAF3zfl9Yh6FeqPh6EjHA8JCeGcR4gCdDplg
	LtPGDaX8o3E2yIWjDz0RI0rAHQct0dA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790963821;
	b=UUmSgDof8ixol3H4/xgUtMzOnZg+J2QW9QSnWXbfWkcqhYPdUzyigHgIui+KXaix9mQ86n
	tJUFRkvvgMlEovNs2LlY3LwYjqtyEkkdjuIZN3+qk1oDfud6MTw0lXZjfwTyakXTZBQBJ3
	9molxLDJFkbIbJ1jy6pNzYpNxawZIQc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=truenas.com header.s=google header.b=a5KSBSOA;
	spf=pass (imf24.hostedemail.com: domain of ameer.hamza@truenas.com designates 74.125.224.166 as permitted sender) smtp.mailfrom=ameer.hamza@truenas.com;
	dmarc=pass (policy=quarantine) header.from=truenas.com
Received: by mail-yx2-f38.google.com with SMTP id 956f58d0204a3-67561cbafd0so270935d50.2
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 10:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truenas.com; s=google; t=1790963820; x=1791568620; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xxaI2OMOwwuqBrxKvOI44CslxEdzYP5+0cKedVWBK0M=;
        b=a5KSBSOAX0YVQb0Bz9PVVLIq25cSI7ui3UwwpOfQjkx2H8Be4mH+8hHGf8vrbd+MgU
         OBNG/bHgyFDd6ajZW5/VMQGsN9V5ZvD+8FFcM8B2U/lLmWH4fGJ0WZo4E5AHOXwIE12c
         6mGu5cBo4/uZa20x73/V1cMklsOCStLfX1UxhGJAsUnj896eTPjnuve1bzqJxDnu8CzF
         ora2RA59zo8FS7iFV6KkpG7EwBgqoduqx2lnVPQy1UvaoyMTgRcdX+LluioVHW+ysv6H
         WGPO2AovxaWvkKpua5IODacxUhgNq43zbVJsXQCNPw3Zo2rsG8YaKWWf3hUXFh7x+n5N
         XkGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790963820; x=1791568620;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xxaI2OMOwwuqBrxKvOI44CslxEdzYP5+0cKedVWBK0M=;
        b=EGC07rA/Kznlaq8r3pn738P6QKxX/0O3cq2CJD0IyOMz/6o6A9fml++zjn7zGG8vi5
         0S3+9DuI8/8laSwqgymwVGB5dZrjBb4kQAjcTSkcB6LJT9hqlr6DpvrAjur64gXk2cyt
         MPnSONTMIVVQLlQ0VdncQLwIJvGFSnSSq4APsUIQIQeY9l9qFDEgTDVjrfzIWCR6otmt
         eNQ8MQsNYAUV8F/lhyHqOI60tb4N7xZrnxCG7Q9qtJUbTUlu/ZbtQ6OqNvAPXB7ewAHi
         RrZVBnR3shObdddd3QMefh81TzFx8uMxJ/d8BtXymCIbU5tC3vDQOLBeRgynScsvuiLo
         KjhQ==
X-Forwarded-Encrypted: i=1; AKwUvBzehLXoTNgh1Ew5UEjTSq+bWKVNIqYHzEZ7gtaODcP3qzKgIlfc8Izpb3wjT9wrumgw7aLCTaMDjw==@kvack.org
X-Gm-Message-State: AFq9FYIX27lQOslRtJkHIDh3OWHgnR7c8bF357rkMVEHx84GyPRaxRRk
	93/sYekuVU19tphCfyPzDqRGer1Gw00S0wXi6VwZJWklJTsBbv3uyn0X3wqCWvsljQ==
X-Gm-Gg: AYBFou3VENbp++06WBdGPVM/MklsfGOCIHXaD7OqVxpxX/lhZVPU9JT15EsK/PDELbM
	dDNe4qAGAJiHoeoZjsPmQGRHRKAlHarfYCFz0oKM0S2PPdNB40KFzc5Q1iq10LxDLLW0rhMq22a
	RQBJL5qbnr+Z1VVY0+HE6UCleAp4UBUq14NBWMSrBiPJf+pdP1YwK7SrnWuAKbx6gZ4SrFO/1VY
	DNdRHV8ut3qS4GpLIajJaMnd9HyZJmZaWNR9J3zQttE0tUay8VYotaXhYBdofKp2y/xjMnFHPTo
	xGFEtBk//e5VpPn3CsxD46V03CiPBxJ+aXCK6yepzqnCRadxUvTjujq1f+gwSkadKaSztp0RTTL
	yZB1ClYNE1ms7XKSuvDcE8nK9CkMfqvMNPzhjCZ54ZOWAODRl29zF7gOtx/2HB+ITtMWbarlqWU
	/oEvAqnBgl65HbW++SJLznEHYYzq7UWrgR3PCl3WTdxKQ4PMdx6SUgjTKhRuWc+gwwMWxSoA==
X-Received: by 2002:a05:690e:4291:10b0:676:8641:27d2 with SMTP id 956f58d0204a3-677ac0944c5mr1330447d50.40.1790963819897;
        Fri, 02 Oct 2026 10:56:59 -0700 (PDT)
Received: from hamza-PC ([124.29.197.38])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-677ac63acc0sm1368439d50.20.2026.10.02.10.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 10:56:59 -0700 (PDT)
From: Ameer Hamza <ameer.hamza@truenas.com>
To: ljs@kernel.org,
	rppt@kernel.org,
	peterz@infradead.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev,
	stable@vger.kernel.org,
	4ncienth@gmail.com,
	sashal@kernel.org,
	alexander.motin@truenas.com,
	caleb.stjohn@truenas.com,
	ameer.hamza@truenas.com
Subject: [REGRESSION] secretmem: SIGBUS on memfd_secret() pages while perf record runs
Date: Fri,  2 Oct 2026 22:56:51 +0500
Message-ID: <20261002175651.811343-1-ameer.hamza@truenas.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 86r8k78g1htarzk19datgq91psbz9hsm
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 251DB180007
X-HE-Tag: 1790963820-81910
X-HE-Meta: U2FsdGVkX190JEW99nxoDztlKn2Re0UyqeG/7k0ECuIdvHjkkGKXUUL7JzoDFqHQmT9dyB/ZPNa6V3iEPQ4VhxnUwKLu8ccf8gCFgQtRJiNvKIIfe5OlByhVIyn+s6vbZiOT4JX3ZDHX+YqcQQRZlCXeaSEqcKPysltI0qejHcRrGv6mX5s8zHNCoJphexjQugaIJIoPu3kPcvpKLjQ7ZOcmCRKFn0CncRxG389XTw+0WO11wnsG7UCJq6U1GzUXpY6CXyxBZoX9LHUkOwH0Ty8n/JejBWRsJeYvRfFq/n+x4mZBP8T3KDgZjuWLGTxW8oWVqRvH/mvb0xId+gVhabdXEIVMaOiJ/m75Ly/EoUEKpj+wCbdq1YHPReNWZdAMAuCDt3lRyz5vMXRPsSo109rmg607mKmRhx+7rnaGTXMYsAPtEd+mNZf9RQO9NTMHkW8PFHtmcMpuMaNbaCMafuqVs9xZ9sC0eYKFejflHYL1pHaWmBJEbF9tnLh3tGk8j+H9CDR+GLmVwM0cXsAp7s6ZxHr5rP0CGSzcjESwWb+pFHDZ1p92AwMscEYQg9SptdPgLGOmzuxcM6XEq5n1G2NOZProQq0Lcvi69c2k8asdeehCtjrXdqIrqCmcJCsIEMkx8sY4eTf74fNg1FzmDdlqaS+bP4mpt97YuMorqkDvXRcOkWRxPwZgRbiMEkUKs6zER/BPc/mp5GA22vAOyh3oHS68lMgBTwZ9QGOXQ70eXYdFzIhmPDWPrrcOVBLATbvWeQXXkCubM8/ftEFMh2a2j29lv1fduObN//WxFZ11/vswPXipN2FgdIvAKmZrblqGNQIloHrL92DIgY/5npoGAyP9r4XYM/hJN3bfb1yZfRHu+0JWDncD5fjcDyXccxnRkpv1U1OIMPGRNu9SxseT6Bg5oPnHAHjjYfmZUriVXcZlxz+Z8OFklXd0hY8XQlXtH25EiWpxB1Yl7XI
 brfAquqF
 4wg66TUQ3DFKNkKhrfoGGjToLEysxboW6i1BfaPKiRYwULox6sf8nJScBqng2ySCSnQLKS3Uqw1MdF7A6ZnrB/sd2hWkY6wYFkAtWyco9IML6uyRzGV0qTgLWJ8sphNNpkROuxyjcUdgDiaEDdEFM12traXUHAtwyQFWZbVePl0saSCHUyzwEHSOVHRGphA+BACwu8hM/Laoz4PyOswzgCuZS1LuKh8M8MDfmtBZdc/YXOuSZdBab58AFQG09MUeg8dpgsSARgzyhv6ZqzJQRWAhX/829Z7Rf2E/g5W+2gZFCMCYmRX1oKqMaN6RGSd+pkJra
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Since commit 97d34aa65c29 ("mm/secretmem: properly account locked
pages"), in v7.3-rc2 and the 6.18.52 and 7.2.5 backports, touching a
memfd_secret() page for the first time fails with SIGBUS while the
same user is running perf record, and read() into such a page fails
with EFAULT. This happens for root as well as for an unprivileged
user running its own perf record. It reproduces on v7.3-rc4 and
6.18.52, and the same test passes without the recording or with the
commit reverted.

The commit charges secretmem pages to the per-user user->locked_vm
and checks that counter against RLIMIT_MEMLOCK, with no CAP_IPC_LOCK
exemption because the fd can be passed to other processes. perf has
charged its ring buffers to the same counter since 2009, up to
perf_event_mlock_kb per online CPU, and only what exceeds that
allowance is checked against RLIMIT_MEMLOCK. sysctl/kernel.rst
describes the allowance as not counted against the mlock limit, yet
it sits in the counter that secretmem now enforces. perf record sizes
its buffers to the allowance by default, 516 KiB per CPU, so on 16 or
more CPUs one recording uses up the default 8 MiB limit on its own,
and on fewer CPUs it leaves correspondingly less for secretmem.

Reproducer, as root on a 16 vCPU x86_64 guest with the default
ulimit -l 8192, while "perf record -o /tmp/p.data -- sleep 300" runs
in another shell:

  fd = syscall(SYS_memfd_secret, 0);
  ftruncate(fd, 4096);
  p = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  read(open("/dev/zero", O_RDONLY), p, 4096);   /* EFAULT */
  p[0] = 1;                                     /* SIGBUS */

The commit closes a real hole, unbounded pinning of unevictable memory
by unprivileged users. The question is whether the perf_event_mlock_kb
allowance is meant to count against the RLIMIT_MEMLOCK budget that
secretmem and the other subsystems accounting to user->locked_vm
enforce, or whether perf should keep it in a counter of its own, which
would leave the hole closed and secretmem usable during a recording.

#regzbot introduced: 97d34aa65c29

Thanks,
Ameer Hamza

