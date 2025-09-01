Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 893F4CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B373A8E002C; Mon,  1 Sep 2025 08:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7F88E0013; Mon,  1 Sep 2025 08:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AEE58E002C; Mon,  1 Sep 2025 08:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 846F58E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:30:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2549B1DEDA1
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:37 +0000 (UTC)
X-FDA: 83840614914.22.F1B1C3E
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id EAC6420004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ZsI5EsLV;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf13.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756729835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HrNbT6choDi3GgMhWeWNgFFS/EdlWGopjyFWK6pahow=;
	b=BZyKotBrDqmThcwgoDR+2LEnc/WFYCXAXRvlbmHJ8iAGsbJE8PxOWN9VZHvYHTM53oRi0o
	cHSAB9Q0W3ZwUZGoTCiqilEvewnyLYNUL3V2K1ArvbdJk3cM3L78lknZkOQXr2N+4J0Lat
	UyldRXrBgfWXGTyhSOCSQmw8kDp9sco=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ZsI5EsLV;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf13.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756729835; a=rsa-sha256;
	cv=none;
	b=CVXFAUurN5teGxfkusoFWCJ4DalAdnhtVxu2FM/AsdnzIspzkrYywMuK2m90XTSH+sfj/P
	uOnQ3VkGo66TT7wiAu3yQwuwlsDx4R2QQl5+HrtP7NTFWx1ny0T4+V1Ev51mlxVAc/dSzk
	+pe6yyxWy6eYEmYrMz81l0DFFYOAp6E=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-61ca9a5b41bso5593891a12.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756729833; x=1757334633; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=HrNbT6choDi3GgMhWeWNgFFS/EdlWGopjyFWK6pahow=;
        b=ZsI5EsLVeq4yUiSENSJ3dwDGQr7Tb36KZBsyJBHP8V4ren+WnxVZtCpKVlsjDlidfk
         YgiVOd/R3806Iy4NvQ585HKCuyiiqOQrtz9LfM8qd4wL+7dvTsWOol4pIkzJLCiiE44w
         b4zoMMj6cIkdKmTNPp4yfUx4jswge4Imgu+5p8pRKiY1vlGKFESBbXw5hrGZ2QTV/VoO
         2Jo8PlUEv138TfylWNVA/jzVOnPUBYMDc3vyheGpCbnXKFBNa1QjBAxwfxb0aFJTMvDG
         GWUWqlmDSl8Nt9BPMzPYp8ApmUHqytbSGxWELTAvVdGwRkkbxl69you2vvjm5Efc4vBu
         fLoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729833; x=1757334633;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HrNbT6choDi3GgMhWeWNgFFS/EdlWGopjyFWK6pahow=;
        b=p3cP3QBGlE5OkH9v89eVc4B2jdscmJ6Wl3M5Ty6JxJlBRYEHvVdFnfl4C92kGcO2Nl
         RsTN7C1Fs+akj4ZrBdLGIqg/LuWIutiecyCx2NI6jo27o9cJtwjX+ENoKL7IZTDTnSA9
         K1exYp9Kib9BMGUrgRLcQvJrZjRWHXJLXQOgsU5bWB8gYnNIHPpkQR+IZtZwmx3v9U4P
         xBOlKz5Lq0I0Bnue161EfxwYFrBOKqrcJlaDEgAtXJJLSUMt0tsapJCFtI7fM3zmr9r1
         zPUbKKAJK12jW5jq9IsosX2vzTUl2sQh8oCGBmNlkUW5A8FkbtgVAQ5uUdnsoiuICV8o
         FQWw==
X-Forwarded-Encrypted: i=1; AJvYcCWgqs+NPY7E1s7Opagvz8UKTGcuVsGvocZtEg1ZgyROAqKpTbyq/W1zFLiMN8TNQ9WqSFiBLUxWpA==@kvack.org
X-Gm-Message-State: AOJu0YwNi+sak7RGViS9w7VtMjONV3cOGgaJTgK1+tj6CUPmWOXMCGGL
	/FCQ7zSr1xVbZaxXRVqwZdxK0wuncVB/8VPmGTIf8h4duyQDKAejy2zYXUZ81V/6l5w=
X-Gm-Gg: ASbGncuDjHhEqBqYRTpAYzRtb9gqP5HLHpDxNi3nklHvZxxROrNpE7dhmmrtNSoOyvj
	X5YhrzDOrep9IJ3IKhp5YdqA/O6yQJWzwQbtyOP1ygZvmQQd0UwNv/l4dMlDqKQSBGszepwx/3K
	X5y3mfZQvfN5cQB7aGaU0llaV7T1mcvo1aIsOMsMljBr6ci0S3Qppo7P6f2v1cCS44VMRWzzI6A
	k/iUBuR6x1eZOP3TQh8eUN76ulhjU/FVuNXJdzhXilLb8MXMeltz87bqmzhGZ206ZK489A37T2B
	SoKPeF8peLC2DGV5hvKT5s2gHsBpUBoBlLVg+4MPRjR18amNQlZkvjjaE9IcEfxXMeXsc02iHFV
	LcH91vmYWdasQNlR+UlP6Iy/V4ctUyxk2cUxrf+0qUd4EtwituxSziqeOM7+eYMhx4qGsIWY9pl
	JYPbDmj+aj4JubuXigBJoq8Vu1NtTeRPly
X-Google-Smtp-Source: AGHT+IEIvcwSPmSxXCSKH0hPzJ7k/4E5ApIsDuAgvra/l5zTme80rYXYzWHYoZRuIErlfCsG0v7L6A==
X-Received: by 2002:a05:6402:270e:b0:617:b28c:e134 with SMTP id 4fb4d7f45d1cf-61d260cc308mr7198111a12.0.1756729833131;
        Mon, 01 Sep 2025 05:30:33 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61eaf5883b6sm255566a12.20.2025.09.01.05.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:30:32 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 00/12] mm: establish const-correctness for pointer parameters
Date: Mon,  1 Sep 2025 14:30:16 +0200
Message-ID: <20250901123028.3383461-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EAC6420004
X-Stat-Signature: m6rhggdids9c5ipwb5nohdki8jzxj43k
X-Rspam-User: 
X-HE-Tag: 1756729834-638730
X-HE-Meta: U2FsdGVkX19Gpck+Z5toggfJSk3M8gtBAilrlR9mF731sd2a+ECYqwp7eAJ2qDzoSqnWVTrpviwcqhHwjs0ce1JHy+In1zpE781i+dB1uJl28fams9gxG5QT/3EDbLXVGp0bujA5FzdQa9bMX8SLSJs1EMwVCjZFUAtnFuTntVeHVAXgKz1x9X56mI/t1K3qbKSiW74+2At3WmDvud8uJMdOUQwoauVI+6d+1C0TmbLr6XHYPueMMqsuFZN/v7krD2e5FDhz/LD2eDB4sqm0vlQON89GGAFJO9livkkl2SsAuh8ePgNz83DkPYshJxSb/szlLqYHj86x2yn7QY4xH1PdpRTHTqJFTTCXai4EB7N/PvEUzhUmvir16xcNi9MIPVtxybDwrLlykTI7CakHV8UdAEMUjHJE95UmD2wEw/XzIWsaQfQv606s4H1SIwh5JQCSvUXv9dKD7l33j7StWD5AYIw+NzeP302ESGMOnvtu4RxYVn05A63ndfaDxckFGDpj3qtlEmoZT3B75EP6fIkxIxTkLVNvejIWk496oL7TzKXk8B75MyO7CpEHQ+CKCRhSF458cTvYOTH1f8gQr+mv8Is1YvCrToxvdsrjyVUxYmHv69EnwcSQ0OopnO8YOeVzeRLkJXHorJ6gX4GvULrNSYxteB8LoeRdzLShtHre64twXQgxK1h2bPJYGIIklbL0LoK08yBvouCM/MUu0MyObr8TDemqRuXoBOcg7sAd0YjqKny7Ocwh+2S8e2T/LmZqPoYsI9GzgpmXIgb9dIAinTVsS2STVx2FRehi56oo1E5GZgZB8beJVzUom7e5Dd5TLYw6xlFHfg+2TdN5WTzM/lk29a0MbkBtnLInGmy1KZQQSINrNfGuZJO2pCeFqwPnTvilVpk4XN/f7PhfkcW3tmBAeLKrxanvGX0QDavBqnCWD7ZFESALvg3OBthmYD2TSiK2PC9FQ2HX6xm
 G4AEugFB
 U9Z4O204yLWCsTU0/s8R0O+2XEmFg3rPWavDuWeITcWWbD4P6df+VgD6M95zUc1i6wezOefP3RScgR37KxnWPmLHyWQVMBUHQy3JIa+QRTLyfgAaaSuFf2Je10xJTqBdAnPNvqCgBDpZjn0VFzu3rDGhOiGAlfxQbM0ncYw5B0IOTUlww+9uxXA010Ls4AHBYR5HadQstzmUq2kx2VWifPQragWKRSknRqbaJ51HfwQjVvFcWgo875gxmHurVDj0yR3nh04fVoisYEaz7So0MM69wtkZuYJa0qMyclTAuJbALxlpmezpxJICm3zdI79WWR43FyS9qHa4qGLZLpHWD/U5vQTV1Udb1hWjDHFcKVzcqKqBfwf65z1klnNyF7LkiZ3bb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

This patch series systematically adds const qualifiers to pointer
parameters throughout the memory management subsystem, establishing a
foundation for improved const-correctness across the entire Linux
kernel.

Const-correctness provides multiple benefits:

1. Type Safety: The compiler enforces that functions marked as taking
   const parameters cannot accidentally modify the data, catching
   potential bugs at compile time rather than runtime.

2. Compiler Optimizations: When the compiler knows data won't be
   modified, it can generate more efficient code through better
   register allocation, code motion, and aliasing analysis.

3. API Documentation: Const qualifiers serve as self-documenting code,
   making it immediately clear to developers which functions are
   read-only operations versus those that modify state.

4. Maintenance Safety: Future modifications to const-correct code are
   less likely to introduce subtle bugs, as the compiler will reject
   attempts to modify data that should remain unchanged.

The memory management subsystem is a fundamental building block of the
kernel.  Most higher-level kernel subsystems (filesystems, drivers,
networking) depend on mm interfaces.  By establishing
const-correctness at this foundational level:

1. Enables Propagation: Higher-level subsystems can adopt
   const-correctness in their own interfaces.  Without const-correct
   mm functions, filesystems cannot mark their own parameters const
   when they need to call mm functions.

2. Maximum Impact: Changes to core mm APIs benefit the entire kernel, as
   these functions are called from virtually every subsystem.

3. Prevents Impedance Mismatch: Without const-correctness in mm, other
   subsystems must either cast away const (dangerous) or avoid using
   const altogether (missing optimization opportunities).

Each patch focuses on a specific header or subsystem component to ease review
and bisection.

This work was initially posted as a single large patch:
 https://lore.kernel.org/lkml/20250827192233.447920-1-max.kellermann@ionos.com/

Following feedback from Lorenzo Stoakes and David Hildenbrand, it has been
split into focused, reviewable chunks. The approach was validated with a
smaller patch that received agreement:
 https://lore.kernel.org/lkml/20250828130311.772993-1-max.kellermann@ionos.com/

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
v1 -> v2:
- made several parameter values const (i.e. the pointer address, not
  just the pointed-to memory), as suggested by Andrew Morton and
  Yuanchu Xie
- drop existing+obsolete "extern" keywords on lines modified by these
  patches (suggested by Vishal Moola)
- add missing parameter names on lines modified by these patches
  (suggested by Vishal Moola)
- more "const" pointers (e.g. the task_struct passed to
  process_shares_mm())
- add missing "const" to s390, fixing s390 build failure
- moved the mmap_is_legacy() change in arch/s390/mm/mmap.c from 08/12
  to 06/12 (suggested by Vishal Moola)

v2 -> v3:
- remove garbage from 06/12
- changed tags on subject line (suggested by Matthew Wilcox)

v3 -> v4:
- more verbose commit messages including a listing of function names
  (suggested by David Hildenbrand and Lorenzo Stoakes)

v4 -> v5:
- back to shorter commit messages after an agreement between David
  Hildenbrand and Lorenzo Stoakes was found

Max Kellermann (12):
  mm: constify shmem related test functions for improved
    const-correctness
  mm: constify pagemap related test functions for improved
    const-correctness
  mm: constify zone related test functions for improved
    const-correctness
  fs: constify mapping related test functions for improved
    const-correctness
  mm: constify process_shares_mm() for improved const-correctness
  mm, s390: constify mapping related test functions for improved
    const-correctness
  parisc: constify mmap_upper_limit() parameter for improved
    const-correctness
  mm: constify arch_pick_mmap_layout() for improved const-correctness
  mm: constify ptdesc_pmd_pts_count() and folio_get_private()
  mm: constify various inline test functions for improved
    const-correctness
  mm: constify assert/test functions in mm.h
  mm: constify highmem related functions for improved const-correctness

 arch/arm/include/asm/highmem.h      |  6 +--
 arch/parisc/include/asm/processor.h |  2 +-
 arch/parisc/kernel/sys_parisc.c     |  2 +-
 arch/s390/mm/mmap.c                 |  7 ++--
 arch/sparc/kernel/sys_sparc_64.c    |  3 +-
 arch/x86/mm/mmap.c                  |  7 ++--
 arch/xtensa/include/asm/highmem.h   |  2 +-
 include/linux/fs.h                  |  7 ++--
 include/linux/highmem-internal.h    | 44 +++++++++++----------
 include/linux/highmem.h             |  8 ++--
 include/linux/mm.h                  | 56 +++++++++++++--------------
 include/linux/mm_inline.h           | 26 +++++++------
 include/linux/mm_types.h            |  4 +-
 include/linux/mmzone.h              | 42 ++++++++++----------
 include/linux/pagemap.h             | 59 +++++++++++++++--------------
 include/linux/sched/mm.h            |  4 +-
 include/linux/shmem_fs.h            |  4 +-
 mm/highmem.c                        | 10 ++---
 mm/oom_kill.c                       |  7 ++--
 mm/shmem.c                          |  6 +--
 mm/util.c                           | 20 ++++++----
 21 files changed, 171 insertions(+), 155 deletions(-)

-- 
2.47.2


