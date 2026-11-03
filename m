Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38018606B265
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=EOr21nf2
Received: by kanga.kvack.org (Postfix)
	id 139376B05C2; Tue,  3 Nov 2026 10:18:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112F76B05C3; Tue,  3 Nov 2026 10:18:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027526B05C4; Tue,  3 Nov 2026 10:18:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB79B6B05C2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:18:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25E16C0477
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:18:13 +0000 (UTC)
X-FDA: 85394163666.19.627E586
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2488916000C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:18:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=EOr21nf2;
	spf=pass (imf08.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.174 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793719091;
	b=IRvgncLqlBbbqm1SG+1dOhaIJTq40pUQj4IORz+wIkDFui1NBxcqvK1c0yfutrMc1AZDhp
	efvqkDzACnzumhktrKzbzbR+6BNSb1t5ZGc7XbiYDWD0U4BDyBL0sloT5lc4IHRoadXW+A
	VI4Cqdbsyo4lmjA51BBGkdihA7GYJ/Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=EOr21nf2;
	spf=pass (imf08.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.174 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793719091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qMbUoE7myG/GAn/bAOasbXOTltQ3YhdGAnoaT+YPoYA=;
	b=tWko0u4U0PxaXZc3YXswK58vXojIzF5dTvHmG4TxH6rb7cebyc+wo3fSXKk3669dTF+VXW
	1XfAroJyQe6rmGNOZKswxV67Cr2FSxEFsTe97moDRERT7ZnfUHyQRjnPa+TLvBdARJTW9h
	ye67cbk4Qv9hxlVpbOoz5/PAC6nA9H4=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc147d86bebso600683a12.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 07:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793719090; x=1794323890; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=qMbUoE7myG/GAn/bAOasbXOTltQ3YhdGAnoaT+YPoYA=;
        b=EOr21nf2nF8RPAyAnQE0SPlAdu5/Ni6KlX3Yv2ZgFrdjCDTzW0grdVw60BTV71Mg/Y
         x2OpuBxynFnzoW0jhFchJNGEXJ1V5l+HAt8BNgcTauUJDXDMOQay+k9samJGF68F1oeW
         YaDdB3Thj0EVMygsV86chS/n8IuC51gl8lv0I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793719090; x=1794323890;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qMbUoE7myG/GAn/bAOasbXOTltQ3YhdGAnoaT+YPoYA=;
        b=fqKpSaH8V450SqfGSimuF4IVIjCxD/OOyr51tWYU245BQBMJDzKMAUNouqnXcKSnrg
         dtn49X3LrNQv+L3mBoGzme07IKQA6FdeVr21DXTFFYp8kJnD6A6v0l1i5uNfw5z221CE
         WikMBaOm1pHZ8h2gd/qEzgeEd3xyu6J2Bn/DYR74iJx4T2j8jZQxw6PCJbg1xr8PDRy7
         fcfFMgiGcjvI05431STcOeztDi52cNVj2798MndkmCPhRC3qSKjlr3fHtOcxkB3VOywJ
         WlN44iC8FXd3+oh7DujgW2QE9yp/+2rP070e1TsTfAOiOte9KrS5TlVxtb5mt1HB/dfh
         CyRQ==
X-Forwarded-Encrypted: i=1; AKwUvBwJQ85gkFPgP2nQXQCdjLog4Yz1hTqPYBKa7sDHCi1IyjhVxKh0POXh/fnfy3eYiQI0wbs2eK6dlw==@kvack.org
X-Gm-Message-State: APuU4Z+U/AQ6/zoy+LRJtZO8oBAxEtvV/kR/rhYEJSSc9ab2jVMrSUFK
	eiiLm8af1NPzm1InOj8EGc4BV4N+p4v5K3ns3iQzXeaVWMqiIOvLj3kfe4vxzdu0RIk=
X-Gm-Gg: AYBFou2YvYqhfByAT88ozi4oW908fvQqZ8t7BjnS3GMiOqHNyR8OmYnH2ypFwIV/QBz
	OrLbAGnybrUYhMEcfreqjVyhRGjwbNuKpzNjHWA4mo81V0cXW6ShY5cj6oIqLcpngWd+ZToFKq3
	NOeWoeKrSJcp9J/m2vD6w+5FCnsgmzW1mmvfOs0jDhTp+cpTuMeeclRiL4QVuphQm/5XbKv2vA0
	XElB6uOO1tX2bXOthQLLIaZ++A/2CY8I4IoMYRoZP5PUNO9DPIgT90nzO4cAW7a56I6U7oe/agd
	l9gr7gFMIJGFNTvPmQDEp8EsS85Cb77kIgT4TRY0OqH4qg0O2hxTeSORiDkjj5yQzjmlePiVinL
	uYXh1djRXom9k+axcH/q2Z/RFdpWhumqsgbTOaupGvTFjbotCsvWD11w06NVuljThG3OTep6sUx
	YMHXfS66DovJ6yMVSt0ZAGwxscmtdug/yq2pEsQm5Z9X00SgDoqBsaIXA7E4iPpiDKGavj7LHNd
	qgI5j1G3SCmka/vA8JxF79b/qxluLaSjIIGurlKWwFzJVZDjA238Valilba7HuGEcwMq9VStSlO
	T7TB2fowrKWYUm++YsYu7R4Z+5VCYUKWeiWiLJbt2wpyq0L6A/EwM/sUVP8wZzykXW7leN6+t5F
	47DpcUT96tR2JonzAbgQ51W4FyY0rjrhydz/AyOLFZhIyqGUbX3EX2iDbp2EYL1FSNq0nr1H1
X-Received: by 2002:a17:90b:3ec7:b0:3ac:7406:b49 with SMTP id 98e67ed59e1d1-3ae896d7a1cmr6969572a91.15.1793719089722;
        Tue, 03 Nov 2026 07:18:09 -0800 (PST)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c903d0dsm4842349a91.12.2026.11.03.07.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 07:18:07 -0800 (PST)
Date: Tue, 3 Nov 2026 23:18:04 +0800
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
Subject: [PATCH v2 2/8] selftests/mm: Skip sysmap_is_sealed when system
 mappings aren't sealed
Message-ID: <6b11e9f77d8ede7ef2f16fef173970a7fa1978e5.1793718940.git.chris@chrisdown.name>
References: <cover.1793718940.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793718940.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Stat-Signature: fgn9sd6sis81i7q17h3wft5b87ghh8fm
X-Rspamd-Queue-Id: 2488916000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793719090-603353
X-HE-Meta: U2FsdGVkX1+SqBova6uoV+FJaWy3N73/U+s+tAQg44I+raBU3fgIbHgiaaqO+Pp5/paS/xZUvBu5q76FsuPubo196N/bmDfpVzqkspigDpLaMRVvccmjES8UvT9aHsxvCRRAPsXPly1uIZSF9ZJNLyVHnqec5saivOtvAyq126YqdaW2xXIuIi5fJA4kC9nVPOrqY+sjYPgIjkhyX/IaU7xqCX2OfQa/Bx+twSE3io62UY6Ufx3QgGFyuZyVfvyvWxDaielcrSJ0YvwYwUQ8SncpaTpcrghmG+/RFhb4i4ieNooLxGowp/9Epi8BzZmYPxu9zPLxKogVJKlTRP88oaBQCGkW5wM6gW9Og4yNHhEZ0ZaASoLUMJs9H3gvIHQ2HMI7mCE+Yp+Uq8YqdWWxAjeUOVr8foLCK8DqvXuRiEmMrERF3ZvzPiFJ+AjAb0l7ipGVfwzq6nPGDsa9Hfz17Ve052qvAuUg6AgxI3T17KJ+wdvD2zVJfjZw2j1Z0N5lmgMJyfzYK5kvaSkQkl36dHxlVGSev8oh2hGEjUOSoiqCTHZhke3JA34T7JLzWg4WwZNrKwz7dvctWvs7OIlRAhGOncGJ/YCGLcE8opBfPg/1O7edA+gr75ZPaHBcQQhuVSIpbykuUqe1Pa3hMFp1Jkp/HnlsCtjik1oNHeb/rmQIMU1oPSR+yzCXZmnAbEWRVNSl9U2kws50hK3zEMVMtGfLGPen83TXCsG5VPugGEZAUXdrE3ACOGu1B7CBEGfGZEUuObobs6pv1hix7Q3sd4n6xx16IlwgRHTWLOQteDK1RP9SJeeDtUzTa/11ELBrr45s52i5sI3oVynlzLu24RoxGQnPGpzLL0TCcB3ttElBPZHlthx+dgcY3VJJEiK5ShmRt5TVvHEmNqgn4snvRqBKdSbjsjiQuiY/qnfNCPOPTYSLIPfR2g+lPQ4ojgDscE4j3KNidm75RRGqcwt
 Tmi3ovhE
 LL5dyMXB7RV/EM4cXHK2Myr/olPs8AM0Au/kurLbPVs5GAICllZvByhvyGovinYfxyJgRHGaW0E1QdwZNEIbpP9GV6oopfN/1BSEH46sAPz5CE68frljAaXBcMwRfgeK5QYVFfG5mTzPai9cArqr7qGp18XcTJ3nByVKWvlqa6T6+ZwLaIWMq6SrktPg0nlPowGdRH/iDf4d7gmsH5MSgSa2oT/ONFXl6cSSKzwCcxHD3+3gE3Ho8iXMy7sKlMaRq1xCVaDnqmeyccD1gmcNOlI2ctH5pi+j4RCTUmRdRs19wm4H1IfzMhuWEFJGL7lOzZZq2V8IltPSudZ9sojc3kNqcUwJxl+Jmu/jEVbNgGA2lx+XFUcsSPJxYMjIQv+FjhFDC4BEUAtSpTNVCoGRjsnZmn7kTGknc0n8qUtB3qUdbtJYELIAPtNjLskcYLsj6pSR8fqDHOEw5uQqVDfZLSKsARAMHYXMeme1apDbvo0XgwPBNfRWAg74dy2deCYPbastf3EZ4K099Gao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Now that sysmap_is_sealed runs with the other mm tests, it also runs on
kernels built without CONFIG_MSEAL_SYSTEM_MAPPINGS, where it fails.
Userspace can't tell whether the option is enabled, but a sealed [vdso]
in a new process means that it is.

So let's use [vdso] as the reference: skip if it isn't sealed, and
otherwise expect the other system mappings to be sealed too, and [stack]
not to be.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 tools/testing/selftests/mm/run_vmtests.sh     |  7 +++++-
 tools/testing/selftests/mm/sysmap_is_sealed.c | 22 +++++++++++++++++++
 tools/testing/selftests/mm/vm_util.c          |  5 +++++
 tools/testing/selftests/mm/vm_util.h          |  1 +
 4 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 573da5006268..1134a2e82610 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -307,7 +307,12 @@ fi
 
 CATEGORY="mmap" run_test ./map_populate
 CATEGORY="mmap" run_test ./droppable
-CATEGORY="mmap" run_test ./sysmap_is_sealed
+if gzip -dcfq /proc/config.gz "/boot/config-$(uname -r)" 2>/dev/null |
+		grep -q "^CONFIG_MSEAL_SYSTEM_MAPPINGS=y"; then
+	CATEGORY="mmap" run_test ./sysmap_is_sealed
+else
+	CATEGORY="mmap" run_test ./sysmap_is_sealed -T expect_sealed
+fi
 
 CATEGORY="mlock" run_test ./mlock-random-test
 
diff --git a/tools/testing/selftests/mm/sysmap_is_sealed.c b/tools/testing/selftests/mm/sysmap_is_sealed.c
index cb0ca6ed7ebe..d5ab2b0d8ca7 100644
--- a/tools/testing/selftests/mm/sysmap_is_sealed.c
+++ b/tools/testing/selftests/mm/sysmap_is_sealed.c
@@ -10,9 +10,11 @@
 #include <unistd.h>
 #include <string.h>
 #include <stdbool.h>
+#include <sys/auxv.h>
 
 #include "kselftest.h"
 #include "kselftest_harness.h"
+#include "vm_util.h"
 
 #define VMFLAGS "VmFlags:"
 #define MSEAL_FLAGS "sl"
@@ -46,6 +48,23 @@ bool mapping_is_sealed(char *name, FILE *maps)
 	return false;
 }
 
+static bool sysmaps_sealed(void)
+{
+	void *vdso = (void *)getauxval(AT_SYSINFO_EHDR);
+
+	return vdso && check_vmflag_sealed(vdso);
+}
+
+/*
+ * Kernels built without CONFIG_MSEAL_SYSTEM_MAPPINGS don't seal system
+ * mappings either, so check_sealed skips if they aren't sealed. This fails
+ * instead, so run_vmtests.sh only runs it when that's set.
+ */
+TEST(expect_sealed)
+{
+	EXPECT_TRUE(sysmaps_sealed());
+}
+
 FIXTURE(basic) {
 	FILE *maps;
 };
@@ -107,6 +126,9 @@ FIXTURE_VARIANT_ADD(basic, stack) {
 
 TEST_F(basic, check_sealed)
 {
+	if (!sysmaps_sealed())
+		SKIP(return, "system mappings are not sealed");
+
 	if (!has_mapping(variant->name, self->maps)) {
 		SKIP(return, "could not find the mapping, %s",
 			variant->name);
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 8ef226107d78..6732f76b7e61 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -785,6 +785,11 @@ bool check_vmflag_guard(void *addr)
 	return check_vmflag(addr, "gu");
 }
 
+bool check_vmflag_sealed(void *addr)
+{
+	return check_vmflag(addr, "sl");
+}
+
 bool softdirty_supported(void)
 {
 	char *addr;
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index d32cb79d9905..0e94793b0d21 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -117,6 +117,7 @@ int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 bool check_vmflag_io(void *addr);
 bool check_vmflag_pfnmap(void *addr);
 bool check_vmflag_guard(void *addr);
+bool check_vmflag_sealed(void *addr);
 int open_procmap(pid_t pid, struct procmap_fd *procmap_out);
 int query_procmap(struct procmap_fd *procmap);
 bool find_vma_procmap(struct procmap_fd *procmap, void *address);
-- 
2.54.0


