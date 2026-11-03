Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB4E6606A331
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=DbHwobQx
Received: by kanga.kvack.org (Postfix)
	id AD4E36B05BF; Tue,  3 Nov 2026 10:17:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85F66B05C0; Tue,  3 Nov 2026 10:17:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975E76B05C1; Tue,  3 Nov 2026 10:17:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64BDD6B05BF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:17:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5BF0A049E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:17:51 +0000 (UTC)
X-FDA: 85394162742.02.0566AB2
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id E85C74000B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:17:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=DbHwobQx;
	spf=pass (imf17.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793719070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Kv57rrW9AR5Uyx8+S36d+hVUEIxbqmnbUnmaj9pRDPc=;
	b=MUnX87fMbOa1KCgRyRF17FvgZMCdhTAmRbypf44iEl2U43xu3hC+ria6tQA9fLyZ42EWMa
	2628LtqwdoOOX5XVnkxanvhOQoqqlJsO2HI+6WEQPLFhJuiCZQwK9r8KuQoznZzSBporHX
	z7IrXB0djLyep9iPMitSD8C1GpoIwhE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793719070;
	b=O58znkbM6IdckmLAjvfK/nNbSwzxPqnSdt3N3DR6XomQCsrGeH+ou4/QTXP8+82Et6/j+b
	Z5T+J7TkrGf0/WfmeQYr4+A36yGXGFDFPRjOHF8zIzD/9ZIyfRWaMuziI6ORQwnqvHZNnf
	aazUEVq6Ws3im9jucO7qb+AkRoRkAto=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=DbHwobQx;
	spf=pass (imf17.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ad787e0593so2068632a91.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 07:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793719069; x=1794323869; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kv57rrW9AR5Uyx8+S36d+hVUEIxbqmnbUnmaj9pRDPc=;
        b=DbHwobQx0mfgspX4Zps0CnLz5eYgeSvCY/It5sNS2fXNeG7Ix5Z8CPsn0bELAUy2vr
         eFXHbITOcMTj5xMOgVHIX3zhKMEavvCa80a3JtbDIZejl1XRZSfTEuYCwuP+nc+9sxQr
         UILPyzmHf7NVjVvjTy+FoNE+8LMjF0GdKKC0U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793719069; x=1794323869;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Kv57rrW9AR5Uyx8+S36d+hVUEIxbqmnbUnmaj9pRDPc=;
        b=J4rQuc/Rnz1Vzlsn1MYRne8CnftYXdaYXpEjp90ufRn/6oZeH70NPR0hcyFnz/rlXX
         xi+YCf7QSky80sG2cJ56eIfJbfLfl5+NeaVW9UeY1gjNiq7C/Ixq46y3Kp8yH7QQsIED
         4sgML9RtHGnMFzPwEvU43NmCGJUgVO7kom5rwn8YsTNynNRArpjb4psPInqFFj/w/lXy
         TwpVPXTev/lVYB8ZB2bFXauDYBVitlt2fxIuv8AL+lPqsn7iTvwVuBchFejqrVjSye0f
         re8lzp5iDCyhfiUNhvt0YZaI+R1r7D9qKflKefFIhCTuCPm2ZzjCUrNGBMAXXlqu1Shh
         iifQ==
X-Forwarded-Encrypted: i=1; AKwUvBwk9RaMC/Cop+nd/AonIW0KBSf7iNWDgWGC2iaSZ+ZOe+NavOSp0wDEpl7e/oSlif4PIvzzoVKfGg==@kvack.org
X-Gm-Message-State: APuU4Z9FyeIj4AgbYQgljkTZGHHljREhZ/c5XjXOvOAT6gi2Q4dd/9mt
	qkMuAUNdATJ7XvO6+b4UdQVuQoSKVVCQAg7zfAAueZJzMcXpZ+cZBkdJ6VxfFiW7EfA=
X-Gm-Gg: AYBFou3pqgJ4JBK1d6Tqk0BrO1XtgJO0oD3sT9aU2/58mdp+t8nwMcK6GrZlu2dPSCZ
	E2w7EJd6gZc/3r08gZ+pqSU65Xpr6+Gz9bMvIdPIM4gA0czPWLM6pgWGXTPOpN/y4lSkh37oMcI
	GR72Ry1slUqM1Tb8azj8fSR/A+FdiCDq+bbe8yis1BcAgHl7kWc+oDbvCemD6sz2NSrkHWapzs2
	MLMw20U5gZO5j4pYxJoAVKe+OYqZKPx/nw8a9gwYwHLru4kxj05JviDssdVc9KLOncOvSX2CYO2
	QynKKW/O6YvnYgBVORCBwJLahe9hOjCo+KCZ9HBUYzpevgO7/NNzI5mrFOpYuCrwhf1WDQYZ19U
	i0m88yeTaKuU/vjto3su8HjYXCDmajFpd/Pmo/KYV+ZhFX87cdDi4SSplyTTZl+79XWn4F6c0Mj
	JbTf7AuwXfUSzCdPl5RVJW7PgUshI5DNrYadYcxvRiynLb292aLIJhcFk7kf3lmuYiU7v1rvWTs
	JSQKn8xaREZB4NPsqOv7DK5Ta07AiEATVm0p5Y/um94OxsC+8tcUTgV0g5w0FUsqdacKW73EbpL
	wZNqGvjVD6/nAvEo9P1YcpCkWtVnv28cK18xOw9cW/8EnljJsoh+kue9ekWs6LWpYSkV3Lvusqj
	RyemNGASi/BlvZRl67y+4Gc22Wj4x+wqVT5yWvhY1Ie+xs0wJmhpRShP7uGBXC9YB3Tahno0/q5
	jUe76Fl2KIpHWRanlW6w==
X-Received: by 2002:a17:90b:3f84:b0:3ab:b39f:41da with SMTP id 98e67ed59e1d1-3ae89776af6mr10813768a91.11.1793719068633;
        Tue, 03 Nov 2026 07:17:48 -0800 (PST)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c62984bsm4849760a91.9.2026.11.03.07.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 07:17:47 -0800 (PST)
Date: Tue, 3 Nov 2026 23:17:43 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Jeff Xu <jeffxu@google.com>, David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Andrey Vagin <avagin@gmail.com>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Shuah Khan <shuah@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v2 0/8] mseal sysmap: Choose system mapping sealing at boot
Message-ID: <cover.1793718940.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: n1cowchrs73hpedypyncpc9ytc8ww9f5
X-Rspamd-Queue-Id: E85C74000B
X-Rspam-User: 
X-HE-Tag: 1793719069-393259
X-HE-Meta: U2FsdGVkX1+uH232WTMGpamuKyTTOdLz8vXGhmKLUhk4LjgZ84n0T4GBOh5rYV2zR1SVOjLPeZJfvPCPC2gJZCU06sCEEDSZiPaLBZqV+LuKWF1UsCJrCeGCL2BzZ2dp9VQXBVttINjp3xr9OhjGyKP7kbpLBOvZcYdXTprrQEMoTqWkj/EtvwfE9MxvNmAl0+Wc9fTYUUFiZPZsmvlTALk4Ci+MdFaM2Vn+Gck6d3IazxH4m3MgT17qpCgMvtq/S0pSAT8rXxHItI4B7i75ZH1eHUQDcK0ZpFV7+eP8wMOD/2VDR0BVCkclElwJKFt+wZM2JfhoLqVrGg29Bm/rdqtBDjVrxZY4lGz80UXPFCv+NhHe1h/VDaTATYsemxO8qEMTQsSe+bAUa5k0vDJSuJLFZvi0hgTT85WOGH6fyaSNZmtjXoD8qAoDaU63H1aDUlIJf0+Df2trm216gLPc0Ypf8jAoQz+WDnhVuCj+LujZO/L6zhBwtAXlpeMPvK6XNN0J7J2OgdQZ/dH2N1/rHI2dc1HIX0jXY9TcfrH57bPah7T3o33TTr1slVMyl+R1yeCieZS1aSrQmabvyFgFCDkr+GbIW9HIOojr4yOcpbyVqc00plTV0G3RE5CdANr3cjNf9MYS9SgGaf2y9kA9J4mzuWZC4tn47GvTuL7x7Z5XJlk5LhMX+6YxAV1ZAvNb1XKFkWlgWG7eMirKM4OhxseD95oSACAEJ6IFyRiAN2rlwZtmyNJx5AImqZLEpU1t3H/TUdLzFSRBr3lgao+ToiBFT9D7Yt3ZxET2gohkEF/Z8r4hOpLKPRWzrm1Ugvv8RygP1+F5shrRzfhcaUrF4zoZ3TWz5P0oLVOtmV+xsngdOWaOXgHfvCauAqDhA9abTXi9Imq7YQhfIV/rVshLcun72el2bRuY1rkBCL7laKIxZWgzERCbpJsaksvUcJDL8g7kGV1OJ58d1FKyNZR
 mApDL2JM
 of2x9vL6fYjTUdkEWVgAJcZpfOHHMAPxMzsJCM9gZyFsuae94ZnoSg+BP7GLo07NMQQWY0MtNj23m9G5GVTwbXMUHRejIz+9Xrs+Iy6R9+mBRlGYaprnbVkBfhcOdG9i3/02YUl9WHtzzNZIrcsMSM7CNJ8Qutn1SHiUBccim49YTV2jiPD7IjacHHorJR2woXj07jnTIEZP5U+0fJt/2mocN8EgZHTSdO69kQUzx+o6rFAKiCBbWBEG8CS8pTNK1lB0R7BGLXpwHKFg61XTOmKUtesgz8bd11XzRDbOKvALwcp3v7TMsOTN1OPRhhoKAbkybqMA0OJ6em9oE8NW4x2TKFvwyrgFqIZNorPEWdUTo4wUnz2onV4IGl3Y3Yo+0saBh0xoX0D3Jc9k3gdGu5VV9IEKEpxVNfHVLDzYHrJPCQl2MHPpxa21NXySZ0nUWozyf326IFPPe/mLnVmO8NWBPYr6Hb7aSJQYEk+FfvDNZCWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

System mapping sealing is currently a build time choice. Hosts which
want it and hosts which need to move or unmap these mappings therefore
need separate kernels, which is not ideal. Let's allow the administrator
to choose at boot time.

v2:

- Skip destructive vDSO tests on unsealed 32-bit x86 mappings
- Move the sysmap tests into selftests/mm (Lorenzo)
- Use shared vm_util helpers in the sysmap tests (Lorenzo)
- Use PROCMAP_QUERY for the vDSO lookup (Lorenzo)
- Keep test changes in separate patches (Lorenzo)
- Put the enforcement tests before the kernel changes (Lorenzo)
- Move MSEAL_SYSTEM_MAPPINGS to mm/Kconfig (Lorenzo)
- Remove VM_SEALED_SYSMAP (Lorenzo)
- Seal mappings in __install_special_mapping() (Lorenzo)
- Leave a sealed uprobe trampoline mapped if optimisation fails
- Replace the boolean parameter with no_mseal_sys_mappings (Lorenzo)
- Drop MSEAL_SYSTEM_MAPPINGS_DEFAULT_ON (Lorenzo)
- Drop the CHECKPOINT_RESTORE dependency (Lorenzo)
- Document the software which sealing breaks (Lorenzo)
- Keep Kconfig default-n regardless of CHECKPOINT_RESTORE (Andrei)
- Retain sealing by default when built in, with no_mseal_sys_mappings as
  the boot-time opt-out (Lorenzo)
- Explain the security rationale (Lorenzo)
- Describe the Meta/Reverie use case (Lorenzo)
- Skip general checks on unsealed kernels (Lorenzo)
- Add expect_sealed for strict CI checks (Jeff)
- Use the existing -T filter to exclude strict checks when needed (Jeff)
- Test that no_mseal_sys_mappings leaves mappings unsealed (Jeff)
- Add the vDSO mprotect() enforcement test (Jeff)

v1: https://lore.kernel.org/r/cover.1793094611.git.chris@chrisdown.name

Chris Down (8):
  selftests/mm: Move sysmap_is_sealed into mm
  selftests/mm: Skip sysmap_is_sealed when system mappings aren't sealed
  selftests/mm: Test that the seal on system mappings is enforced
  mm/mseal: Move MSEAL_SYSTEM_MAPPINGS to mm/Kconfig
  uprobes/x86: Leave sealed trampolines in place on optimisation failure
  mm/mseal: Seal system mappings in __install_special_mapping()
  mm/mseal: Add no_mseal_sys_mappings boot parameter
  selftests/mm: Check that no_mseal_sys_mappings unseals system mappings

 .../admin-guide/kernel-parameters.txt         |   7 +
 Documentation/userspace-api/mseal.rst         |  12 +-
 arch/arm64/kernel/vdso.c                      |   9 +-
 arch/loongarch/kernel/vdso.c                  |   3 +-
 arch/riscv/kernel/vdso.c                      |   2 +-
 arch/s390/kernel/vdso.c                       |   2 +-
 arch/x86/entry/vdso/vma.c                     |   5 +-
 arch/x86/kernel/uprobes.c                     |   2 +-
 include/linux/mm.h                            |   6 -
 init/Kconfig                                  |   5 +-
 kernel/events/uprobes.c                       |   2 +-
 lib/vdso/datastore.c                          |   2 +-
 mm/Kconfig                                    |  23 ++
 mm/mseal.c                                    |  12 +
 mm/vma.c                                      |   2 +
 mm/vma.h                                      |   8 +
 security/Kconfig                              |  21 --
 tools/testing/selftests/Makefile              |   1 -
 tools/testing/selftests/mm/Makefile           |   1 +
 tools/testing/selftests/mm/config             |   1 +
 tools/testing/selftests/mm/run_vmtests.sh     |   6 +
 tools/testing/selftests/mm/sysmap_is_sealed.c | 259 ++++++++++++++++++
 tools/testing/selftests/mm/vm_util.c          |   5 +
 tools/testing/selftests/mm/vm_util.h          |   1 +
 .../mseal_system_mappings/.gitignore          |   2 -
 .../selftests/mseal_system_mappings/Makefile  |   6 -
 .../selftests/mseal_system_mappings/config    |   1 -
 .../mseal_system_mappings/sysmap_is_sealed.c  | 119 --------
 28 files changed, 345 insertions(+), 180 deletions(-)
 create mode 100644 tools/testing/selftests/mm/sysmap_is_sealed.c
 delete mode 100644 tools/testing/selftests/mseal_system_mappings/.gitignore
 delete mode 100644 tools/testing/selftests/mseal_system_mappings/Makefile
 delete mode 100644 tools/testing/selftests/mseal_system_mappings/config
 delete mode 100644 tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c


base-commit: 734a9da61a5bc5d82b496a86bacc097d11dc6871
-- 
2.54.0


