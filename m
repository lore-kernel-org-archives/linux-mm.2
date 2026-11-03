Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C8C606F609
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=N80RPvRy
Received: by kanga.kvack.org (Postfix)
	id BBD8D6B05C6; Tue,  3 Nov 2026 10:18:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71A46B05C7; Tue,  3 Nov 2026 10:18:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60F96B05C8; Tue,  3 Nov 2026 10:18:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82C0C6B05C6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:18:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 27798403F7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:18:30 +0000 (UTC)
X-FDA: 85394164380.21.C27184E
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 46FB120009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:18:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=N80RPvRy;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf13.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.170 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793719108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DEpA7EB35ETX+QEM+S0rPeRue+CXb/aqgZ9fcs/1WrA=;
	b=Vzpk19P0+VYFfnuI5igHxKgs22ogRtTb4XbqCCUoNx7blO6gA4WS6yE4OfM7mWG2GfXzDi
	AgXUR/L3fjfBkzXJEXzOp+YG2w882tXS+QksBNftcyoe+Q6Cj4DZegwZs00mK4JYKgvzB0
	7r0rtK1J+bYRRnsMB9tOt2aAjzc3WgU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793719108;
	b=7ZzIxYWWl5wN0xBPWpunuQAwZT4OEBDig2NQosOnjZaefBGGcrh6gdCx0zKhTVFTgXev2A
	iqCW3Cc59AJW2aaDB1J+e4vC3B9IHhPpz7mXZqTDTZstM1lh/slEBl5vei9cvlaIjt65tR
	ich4QJiM9WcZUqa2JBEItPEFzoH07wQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=N80RPvRy;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf13.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.170 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ea759cc9b6so17859865ad.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 07:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793719107; x=1794323907; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=DEpA7EB35ETX+QEM+S0rPeRue+CXb/aqgZ9fcs/1WrA=;
        b=N80RPvRyk3Pv/YTKJPasUQzQcdtuSAzWi3pbM5DReVyhrum2aIK5In3oaei9F1SSju
         djm0VTaUhV1Yrpo1kLqW+FvMUswXKRL9kvc9aJqNL/6dRvMVexxsmrX2Sp1tva4fOBxh
         bXq3i1NqP6GGHpBmfPogB4RfL/xjRTjlqKQa8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793719107; x=1794323907;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DEpA7EB35ETX+QEM+S0rPeRue+CXb/aqgZ9fcs/1WrA=;
        b=in8mSm6D3n+Dx92yXoBVsYCEgREs4b18LKpjkNOM032lvlpL5pabQAih1ujNiZ1ign
         zZ7/Vo2HE28DMaFJEzyAsj+EQvr8ZXhAO8vs5G0GiHbCxyaeHLtaW1fsMmWXvRpZhPBN
         34gl8gRbngOetUbkNJxYH0FspeXBQ6riqlDwc2e8IfweX+rVI0AMPTW4jVpuZcVX2NXK
         nQwkIdma3AH/IDb9AfUfIffizrMjiHrFm7Y+yYanns/F9bPpE/iahF41dXyPiKcbdicS
         i4BlmU1NJpXWWMUjtHglEtJSo7FTix0KO2xC30c2Q8ijZvIedwACT2p3ucaqqOVXfbRT
         ZLkQ==
X-Forwarded-Encrypted: i=1; AKwUvBy7KaB4R8T/D7XdxreaeBWLT8HkNtESF/CTpmBY/SVGdG1JdfRlz/KksUSMx88zPE/kXKlpRBxoXQ==@kvack.org
X-Gm-Message-State: APuU4Z/ZtSgf5ZG6yH7JMeHQZMOsxMzCSJg/OYM0JhaQGA/gFiE1njDs
	9oWKMbDeeu1YVgALrTd7gW63/VsxB0CH7Qml1XL8y87JXbcG5grBo9Vh9xCFf1vLrFA=
X-Gm-Gg: AYBFou1k4Jtxd1eYaRrXJyXUcqM7ll1b2lFMZQQQuXuzt4+OapfIQ12vkzHvtMtFdzV
	4hPPZfRzWvqRbJnBEwUbtz8mp/4fE1GjGFngd+GCUNxznGrKwf1eKRLSW2TPckv9a6J+XgTZJb1
	OEvFj2MeRn91RNyvvnzNZAiisg2hhLw+P/Bm/hF8cEc56IyO5OkYv4zWZV8coo+xT3Uk5ZXfcNn
	LwCqu/TpAwzLYw+z0k/xqiUg8fKjnilZI4RAfQfwKGo8yp5BabCTWnu8HmmAFaEu//KkXimUzJ6
	BTz0bFTINx0LTrQSQer3t/nXzemdQm9v3xCpvbjXnSn3ECXdcLL3e739vEdksX/ompy+PBgM8Bt
	XaOqSiSRJ/OWtpT4ER0ghb4cahAnbNd5aHYLPBWUXsFB1AlzX76pR++1vZXepUzQx1EldTGccBK
	bOMCPJXDX4ilrRg5fsmYhsnlK6BWPhx8S3jRalM8wNHCb4JfetlAlkv8diKatGq1Ys9RT3839Ng
	XD7bMoN67R1VA/S7hlVYf40JO1RKAMNxu7kCL9upSrT+QBHWAedkmRgdZdk2jfnDSUXR/ZUzHGR
	NvtqwN95VJk7iM0vSlKbvch8ImNXHcUbvuXyNWxA9B/DjRQPc4HHBKwZEoJWr9+iZJ+m0obuCxX
	g5eEP/FTUaldk22nII7oVLCCBBVMbau4XRDSKFO/6utPZ8S97Qt8DTIe6ddzqfnGk4VSpGvHj2/
	O9sWJMX22LjM8ritPBC3Y=
X-Received: by 2002:a17:903:1aef:b0:2e2:f2f9:b1ef with SMTP id d9443c01a7336-2eb364bc076mr131151785ad.39.1793719107092;
        Tue, 03 Nov 2026 07:18:27 -0800 (PST)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb392613bbsm43426035ad.37.2026.11.03.07.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 07:18:25 -0800 (PST)
Date: Tue, 3 Nov 2026 23:18:23 +0800
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
Subject: [PATCH v2 4/8] mm/mseal: Move MSEAL_SYSTEM_MAPPINGS to mm/Kconfig
Message-ID: <6d72b96fdd36c8870393d8d6e67a811a9bce9e4f.1793718940.git.chris@chrisdown.name>
References: <cover.1793718940.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793718940.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Stat-Signature: o9f16pmqxyx5pg1saow4x1mmnz6t3rm7
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 46FB120009
X-HE-Tag: 1793719108-266545
X-HE-Meta: U2FsdGVkX1+JVEPofwFc9nK4usq7eCLK/93LGhZqAbqPPMuTxz7lfl8Idx96yKTHT71iwDw7GIoku1jJ6qpk1ILDa1Lt7XP9O8gb1BcMV58OxXBteoQxrikeyMURRYufs67MAW5IPCpqFbk5IjaJkfmncq1H579nyCQswtVBYmu24OJMAFOzGB1FtcSQU3oQ8THDSzvhwpd2wXRlvODe3lj/+nSqaJZvJn1XVeRrdMemKa0V4IYi5//wvPwGSxLeUKNvvi1T5UdI694N4UmtMeCkJXm2IDUp9NOJhLhDGNBqUvd/4Qlq0h8pA7WxEVdBhu921irnW/hVSSFLq7S5QHK0BpNrIRRbBalq+jSzxmYNWoGdcVA+9RwzZldQAB0xA5KJHAuxZ39n+YWUweduGx6eiAeC0D74rNKbRW5sYPd43/Kdi30eCL3fprQparx8joqiNWGNGau52yD6LsYkXJk6prBT//jP0BVpWKNpLonpq2AfzOAQNbwCFYoUMLnjsPimsYOBQo80z9qYmYAPDFcM41WkmkUrWjuuVbT5ZPcbG05+jMvdKkshNv4wE3fJcuFWeJ8vVt7gOux9BnKF3K/MLzjIYuAUOYBH8Lgr5Icb1knKA2iyxWzmu5FlQsFcXKcLE4ML7RzjvARDgGZkoQ0a8a7D3ka1/skGidXabdouJf22ESRbaoVr4Xn8HmaB0CJVedZx2oqDLCBncaVMjEJ9kkYsAObaWDGgMzMyUunHC6lZISpGqgoW9qQb8dAWnmMs8DnSTg9dnkVW4NRsw0F8bfndE+r4r4iJx7jZh4RkrKGtdQkP3YtBq2ogXU1pYPHlGiQsogDr/TASFF9w+I7D0ceXOFC/MRH+1e6DiIPEvdbFsUt9j7K2A5w290Ny83YiZM9iINucOh+8yU9LFWuXCEJSDCRpOOmbXsHIjW5v0mml66vVMxU+wyl0xfJwAuL8ou4UsVcOE7DRODJ
 HW1wqV0v
 rEBTWfttsw4A2xAWfgUKI7lEjRlsjePWP8SHDk63CyM6eWN/cH7mI4PCKS8Xi6jvpFx/rcbd8eVzBSqmVBpOg1RgZstD0OIlQJbL+vPyixDNYe9lYXOrw6QZppdWOJWwHLcJRe88Xp0ypvOIUEHbtnNSeLyN11LykVHaE2EJO+OxWUcUEfjTEjsA+YwH7oyv7CkvdDmojmMMpHmg7lxVlTgPoTPUljitV2RNowcguvKHNIBxNafdBeD3SRb0C3WQUpGd3uWBLU5Do3AMWOryu8Rmx06MGyhoAJyHRUX9Yc/TNBQmm3mMDq9bff5ivM6aopRNSpzvP5WtUxC+eIy/x3a9HRc/u7ybEu8FA98tnpJ08Al1QrECNxvcbTHB8HlpsRSuMGZCrC/DigBqUcH+Tv7bM+yXiLc2JP6tjJ/hQWbo/L7vhxRAJOk76LVSq243X8zIU4UVB3ZM8lRLJvjAjvsV656kbdWH4f2YnZSoHiQ4siyb3e775/7s1TOCt9kDb3D5OzOJCWW7h/e2yNQLjSeWyOLQ6CTlkE+P/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MSEAL_SYSTEM_MAPPINGS is in security/Kconfig, but it's an mm feature,
it's implemented in mm, and changes to it need to go past mm.

Let's move it to mm/Kconfig, next to the other VMA features. No
functional change.

Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 mm/Kconfig       | 21 +++++++++++++++++++++
 security/Kconfig | 21 ---------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index afff1b25b543..40172787dfa7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1355,6 +1355,27 @@ config ANON_VMA_NAME
 	  area from being merged with adjacent virtual memory areas due to the
 	  difference in their name.
 
+config MSEAL_SYSTEM_MAPPINGS
+	bool "mseal system mappings"
+	depends on 64BIT
+	depends on ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
+	depends on !CHECKPOINT_RESTORE
+	help
+	  Apply mseal on system mappings.
+	  The system mappings includes vdso, vvar, vvar_vclock,
+	  vectors (arm compat-mode), sigpage (arm compat-mode), uprobes.
+
+	  A 64-bit kernel is required for the memory sealing feature.
+	  No specific hardware features from the CPU are needed.
+
+	  WARNING: This feature breaks programs which rely on relocating
+	  or unmapping system mappings. Known broken software at the time
+	  of writing includes CHECKPOINT_RESTORE, UML, gVisor, rr. Therefore
+	  this config can't be enabled universally.
+
+	  For complete descriptions of memory sealing, please see
+	  Documentation/userspace-api/mseal.rst
+
 config HAVE_ARCH_USERFAULTFD_WP
 	bool
 	help
diff --git a/security/Kconfig b/security/Kconfig
index f7bf6cdc6229..1679e8d009c3 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -49,27 +49,6 @@ config PROC_MEM_NO_FORCE
 
 endchoice
 
-config MSEAL_SYSTEM_MAPPINGS
-	bool "mseal system mappings"
-	depends on 64BIT
-	depends on ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
-	depends on !CHECKPOINT_RESTORE
-	help
-	  Apply mseal on system mappings.
-	  The system mappings includes vdso, vvar, vvar_vclock,
-	  vectors (arm compat-mode), sigpage (arm compat-mode), uprobes.
-
-	  A 64-bit kernel is required for the memory sealing feature.
-	  No specific hardware features from the CPU are needed.
-
-	  WARNING: This feature breaks programs which rely on relocating
-	  or unmapping system mappings. Known broken software at the time
-	  of writing includes CHECKPOINT_RESTORE, UML, gVisor, rr. Therefore
-	  this config can't be enabled universally.
-
-	  For complete descriptions of memory sealing, please see
-	  Documentation/userspace-api/mseal.rst
-
 config SECURITY
 	bool "Enable different security models"
 	depends on SYSFS
-- 
2.54.0


