Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC44260A2608
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 22:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G84QBJ97
Received: by kanga.kvack.org (Postfix)
	id 5169E6B0711; Thu, 19 Nov 2026 17:44:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EE176B0712; Thu, 19 Nov 2026 17:44:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F396B0713; Thu, 19 Nov 2026 17:44:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1881B6B0711
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:44:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9EC4B160C93
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:44:21 +0000 (UTC)
X-FDA: 85453348722.22.1EDB7D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 11E8CA0005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:44:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G84QBJ97;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795128260;
	b=sndj0ENMiQpIT2VQaDKoqE8gYm/l1ZNYO0Xj/8m8Q9wTL/P0qRKq7JiXmFRk+Yd+FE6lwF
	7QNYjSdcXtvQavwVV2WJc+6kH0Hjwhz4v9O4W3p4Y44tqpwRy8Ce46TybKOKGFRRxIFcP6
	JhuDUOa9/MS6iZIPgrYvEAXHCnQRE1Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795128260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gr97ciCxGN41j4xZpW4DRbzsSgnRLt1+kw53dgKobww=;
	b=Ny+vcELke4XnPwT8+xpo4GGMAwK/sCHnK1AUGdFT2K2zb4SGdLcYXCjxxWKVKZx2SwVdSS
	Bv71bOSOaBoE0ScNv7R5BsoK6eAUSZdY7E3NpB9H2/YF9vDWY6xTp4CpLiH+HQxEJKXMIA
	LzfaMg1Rqs0d4ErcccBBanaxclLOcZg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G84QBJ97;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id AA9E4620C7;
	Thu, 19 Nov 2026 22:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A28D21F000D2;
	Thu, 19 Nov 2026 22:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795128259;
	bh=gr97ciCxGN41j4xZpW4DRbzsSgnRLt1+kw53dgKobww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G84QBJ97RNq95cEwOE00TXPDVbNAk4Gdl1J92hUsJ6o6u0RVu98a71A1AxcyvXO1l
	 RIe46SMocH7z89FQIuCWdGh35CxmGXGjYztOoBt8DpdfeyLAGWUZeKcbaaCNNve+oP
	 D1IP31/vfrRlyAqoMxovmgY3gDk9IENaueIRhZkJLbESvrYPR4ez530gdCGekEI5ee
	 36/qY52lPzVPvfLUVWK/9YZRR+UpsWxFFi0WvxKkGpne842aJ6XMjQUf4ACXkD0IfP
	 ZdzQfv6h7XWywcCLlh0ARazsooBunhow7Udy3nDtn7RTZiP4wSdK0W0KPTAIwYaXWG
	 MKTMCL9KrmQeA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Andy Lutomirski <luto@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Hallgrimur H. Gunnarsson" <halg@google.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Mel Gorman <mgorman@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Moore <paul@paul-moore.com>,
	Paul Walmsley <pjw@kernel.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Rich Felker <dalias@libc.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Serge Hallyn <sergeh@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v4 12/14] docs: Document root namespace uAPI
Date: Fri, 20 Nov 2026 00:43:10 +0200
Message-ID: <20261119224312.1037966-13-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119224312.1037966-1-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: n8cryd6f7ir8h54my1i91nbp3ok1kdb4
X-Rspam-User:
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 11E8CA0005
X-HE-Tag: 1795128259-509091
X-HE-Meta: U2FsdGVkX1/JQXMZiYq08ACeRj03DTfnTDPAJyOzssUXuIHwPCft68iLUmS/t1Dy9sChhgpT73sZcnM/4V2GBQosf34V3gZqiXOWsBdLzZnqj9jCW0jvudolXFdqKG0tTa4lALLqfQEFa9lKCpQVrPEWTsi/CjNrnxMGZKjczRGH4F4x/v9NM3lDnABcA9NmnmDs7d6473X8eh50fsT49u1RuFxWn8hioU6Oca4+yjxZYCwJb/RExUg0eUM7NLsQkZvdrm5ym0zCYErdGhRMpmxpGGDQpA5O/QjzjvV0oHREb5kz3M9WjldJ6zV3oBGd1ySfIjEigdHXCrTHdr3usULILgNrfmBawByNVG5FlkxunWEGw8tlMxonjn4ctAApEqCZOV/4PFBPH3GKp8aK9r9Do9CDFuN6IeyWg086y+wCqiRpW8loLOcxGcWrZsugzp1x6QsCdkhz6ODiX9Ha4nyvcntuPChOZcb24l8THRkcB4UqMaW5j3murtJozpa/hhMB0Ca7dh231m6YFS28x5HOiBGpEfgAqi6Jjm3DSkt8UQ618bkDo9JH+LYqvQo7bzciBlVkJZP1FVrYn2z0sUlCD4dYo8X5c+1s6ZjP6pictUGaEJTyZOhChLJQS4HOQmcRVyUydeDK9cnXWjgiBFAWe8Jtq8cMrl58Kq1maUGJCaPayM8slb/WkAYLubRbzVN4/2xQp9A3plqS396xLVIWaw+K7gFmBMXZTl2mH9TwpSUgFvpLUGioXHAf7OOLaH3UsJmTuFtlD2EDYz3KlR4gDEJJyDQDQEBSt8zAqx29Tj1hkTzpWZjU9beyFff0NyK2w/nZ9tCIevEVK72Wg/aXEYWmkoRta/xTKRjV/QLiJJyXFm/ScfXbvDzhN+wnDQqfjNPqCyf6KtVwz/aiPvK7jIiiRk/JI+lCNydoOg4Bhi3OBZmjpF94BgIQ8fgDQ6IC8qZV2MkCc5FvjIe
 z+XX2S/u
 o/Yk5LbFg/QE1CvgMEN2Zp+oHFwlnC3zTs5E9mYjbqNosS1VrniWxOLkpXz95be+KuWZdxjsTq58YIir/KmRxeBaASH2w76Qzq/4Vrfx6q/CgXQI3tXYMOvTN+O6jeqAEwjhwj5lxy2wMtWukwDEfYOEKB7/9+7hqFwxm+wz6h/5wi/uA+NivhkDksrqiAus0On8vK61Y4/QN4jOz91Ta/DI5dB4HLQL8TOAHycc8UWujy9vHmEPO6DAcPjOZuBDIkQCUlFFVEh8VWUT9wMHYs76KFXwa6/4v81rVwwE1FJYS/IeD/11WHk4dU/pT7cqol3/uZo+IQi7kbxgEZ1n8IhjLVS0H0jvhwkGpDRhkfGz5HV8eR9RULSLxXIkxBTYnWW8WHejWo1rmpcRMYAatgBI1buQV1dIfv6vCqWihDd8YoreZkpaWKoNmcRmcEQ13AaE8f5GVLayBZUP4cfyG7DUUKtKLI1c64CBHO5SHy+FoFKk9r1ylMqW5kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Userspace container managers need a clear specification of rootns state
transitions, control ioctls, mount-tree construction, credential rules,
and process creation semantics.

Add Documentation/userspace-api/rootns.rst to include the kernel-doc
sections, ioctl descriptions, and system call reference from
kernel/rootns.c, include/uapi/linux/rootns.h, fs/fsopen.c, and
fs/namespace.c, and register the rootns ioctl magic in ioctl-number.rst.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 Documentation/userspace-api/index.rst         |  1 +
 .../userspace-api/ioctl/ioctl-number.rst      |  1 +
 Documentation/userspace-api/rootns.rst        | 56 +++++++++++++++++++
 3 files changed, 58 insertions(+)
 create mode 100644 Documentation/userspace-api/rootns.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index a68b1bea57a8..56d0ac4eb087 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -17,6 +17,7 @@ System calls
    :maxdepth: 1
 
    unshare
+   rootns
    futex2
    ebpf/index
    ioctl/index
diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index dbe462040999..d8dc926ea283 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -385,6 +385,7 @@ Code  Seq#    Include File                                             Comments
 0xB8  01-02  uapi/misc/mrvl_cn10k_dpi.h                                Marvell CN10K DPI driver
 0xB8  all    uapi/linux/mshv.h                                         Microsoft Hyper-V /dev/mshv driver
                                                                        <mailto:linux-hyperv@vger.kernel.org>
+0xB9  00-0F  uapi/linux/rootns.h                                       Root namespace uAPI
 0xBA  00-0F  uapi/linux/liveupdate.h                                   Pasha Tatashin
                                                                        <mailto:pasha.tatashin@soleen.com>
 0xC0  00-0F  linux/usb/iowarrior.h
diff --git a/Documentation/userspace-api/rootns.rst b/Documentation/userspace-api/rootns.rst
new file mode 100644
index 000000000000..5326fd2eeb21
--- /dev/null
+++ b/Documentation/userspace-api/rootns.rst
@@ -0,0 +1,56 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================
+Root namespace uAPI
+===================
+
+Overview
+========
+
+.. kernel-doc:: kernel/rootns.c
+   :doc: Overview
+
+Flags
+=====
+
+.. kernel-doc:: include/uapi/linux/rootns.h
+   :identifiers: rootns_flags
+
+Ioctls
+======
+
+.. kernel-doc:: include/uapi/linux/rootns.h
+   :doc: ROOTNS_GET_NSFD
+
+.. kernel-doc:: include/uapi/linux/rootns.h
+   :identifiers: rootns_wait_args
+
+.. kernel-doc:: include/uapi/linux/rootns.h
+   :doc: ROOTNS_WAIT
+
+.. kernel-doc:: include/uapi/linux/rootns.h
+   :doc: ROOTNS_KILL
+
+System calls
+============
+
+.. kernel-doc:: kernel/rootns.c
+   :identifiers: sys_rootns
+
+Process creation
+================
+
+.. kernel-doc:: kernel/rootns.c
+   :doc: CLONE_INTO_ROOTNS
+
+Filesystem configuration
+========================
+
+.. kernel-doc:: fs/fsopen.c
+   :doc: FSCONFIG_SET_ROOTNS
+
+Mount tree installation
+=======================
+
+.. kernel-doc:: fs/namespace.c
+   :doc: MOVE_MOUNT_T_MNTNS
-- 
2.47.3


