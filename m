Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E0C606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 22:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=esdAudvZ
Received: by kanga.kvack.org (Postfix)
	id 824AC6B0675; Thu, 19 Nov 2026 17:44:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D5E46B067D; Thu, 19 Nov 2026 17:44:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64F2C6B06FE; Thu, 19 Nov 2026 17:44:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 365826B0675
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:44:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A00031C46A4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:44:30 +0000 (UTC)
X-FDA: 85453349100.12.15982F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id F36E98000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:44:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=esdAudvZ;
	spf=pass (imf30.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795128269;
	b=3XuvhwCaGXW7hR6E01lsBJprZyJGJOGY2KvYYlLaiQgq2tuWF2m1wX7zyrXyxFUe/aBUsM
	8qDJmor9nSG19t5QuPCOOYye1OO/hxn40V0dFr4iGeC0GPNx6R/+1ynj41RufJ+/MQt1NX
	FLpI/p+b3KHUTYrs2skaRYAXyUJRUrg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795128269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nefIhKw4pk3hNRgKls2omID/HmfGP96iHh55NTs5Fc8=;
	b=aFjy/zqIEeyZxP3MQzbIezbvDaXyK4K0VRKVLLcb5GepqNzjXgUPk98zbeCTovfHEVaX0d
	17VO38lkQ5bMhJbJN2mBLGDjGfBu4dXQN1j1vkkNtsGApBxNSSUbdqwf3HUWRc2Che3eqm
	MY6K+QGBxKNu5Pk63+jIS0PGblLWqfQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=esdAudvZ;
	spf=pass (imf30.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 3D4DD41321;
	Thu, 19 Nov 2026 22:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 61A181F000CA;
	Thu, 19 Nov 2026 22:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795128268;
	bh=nefIhKw4pk3hNRgKls2omID/HmfGP96iHh55NTs5Fc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=esdAudvZa+WKWyffO/lrY+z7QYAZ6No+WEP53swromiY2438FAZcSNn0CJB3YH16X
	 zpRv0W0Tagm2qyMa2IRE9JZ4dwaENI5Jr512dORRagsTsAAYEpnIzuVY6BsxEGSq3L
	 7voWpSqv/CsOKdk3E+luW8/3/upHnv1ZDR4/emJbhTr6hEq3QwyLvWqXQBzQWgvbpG
	 P3Bg0DTBahtB++fEg+4uiF5/UXIvkLDlQSJtQZfxxel1aD44hGtow8FBnBGFCtjloO
	 2BLScF956dTTJuVxtqyw0Wy7W4qkjXm/aFVwwjtFqf90JnNA4O0IIR2Ur1CPNMAQyw
	 Jvw9xUkHK33Ng==
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
Subject: [RFC PATCH v4 14/14] MAINTAINERS: Add entry for ROOT NAMESPACE
Date: Fri, 20 Nov 2026 00:43:12 +0200
Message-ID: <20261119224312.1037966-15-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119224312.1037966-1-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F36E98000C
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: x9jwsedupagkdb35ny7gdwqktmcbgzwz
X-HE-Tag: 1795128268-240010
X-HE-Meta: U2FsdGVkX1+mjj9BoJZGxyquwm2YfZxAGkEsjQEd3uCWPooKM6ip179F2gBlpL6cLLDuKbr6TjheAxzd318u5ZvQHFoTllRv03Euvz0NGV5508fhVHHNgu3YOWKFQpKnV6C/US1yY3058SygWKCyYMDwITEJ+XVG0p9W3bClahodIJeujRg6ygvsTaxK3/p0pm4ohmDsygnfeZE9JxyOhlyk3wqp7qNKQ1fHdVYN8Z+MIEsVkbUC+GOy7oo4/UEmHdgQ9G0EoE+vVODhONlQDo5yZd2ACCYGbnkMlrT+lSna3fZU4y7mR9IoFlGoMxTncuzZhlhH99KV7fU4P7jvqii/EmMNZq8Z30gNLQeCPkFvBc2C8tzgUIRAIX849+28ICfpb9uBVdsc0gdniMUVPSx6I0ZUdlStlPnklHHaY0z6KBu4h7x2J3K8p3lawlnTudn9ywDh5vkycr0ot8vmanYlfvc7kg+UbrO0vCYWTmVb1mzRcbFCZ+grjAmT9ItP9B93wJteelZ21rmklXYMq6k6yWaaGQd8dD9XmyCH8f+RCGmp3H6OD5eunYMFa+C1yRbGQLT26XJzzZiGj9JgpbEuqn72ZhzUm1SQb7ZpPPMPcmG1HYBDNysXEl6HBa2yt5XwBo5wYv06UGoWFyzAAtespJpXFsriUN9APwbuAoN1hhhkiytOtw/YznhlDkr5BlaEG+l7Kh5rVErDK9sZbwc/LyA/X+J8Co2nlGxvkHT/zluQLFCn9MQy86F4qkhIUWck3b/jWsqj+yDlrmtgKm6I0GunXautQ/p5EYU5gMMDrSGjSgVNMuV9V5ky9FW2UkXIBA44w3cHkYwvLK0+2ehZvR+GuG63e3TYLyepmibQR4yWLidAtBjX9LPO/K3F3c5YsqInEG3WRBjcrvoNB5tl7cV3fDSYQSxfqbjL+vjQXYT1OsgJuCCUKOzOZ4EDTibeRTbSeiL1IQccrxG
 Keh056VA
 7qwjHfJORBNFH9N0PHP7nWRg+zkibynaJDIrFgTSz4NaJged4U0mAAZECXtB/lbHwGLFyRebn48cCYdxgHWsq6gWJTLDtCA7Hxmr4+Wxn/2M+SO+ceTw/MBfpaC2WLIyYwlBeVqUePOIFjvq+mBhUV7qfxRbLt+uvG5hVo4k+jiV0/Lp8OkjF8RU8hEd+HYR/2JQ1PkcG/pFggGmFsi0ja+iAahLuEdlLBptyNpnGGa5RaMRn+9s8Vl7Ogz7pYJeMESvae0gXxuj6UBj7ACQ75TSWHH5oG9xLnKtnM039VPrFAh2rRCSYEZ39YFUDINdYE8xVExBy4yvNW25Od+knw/GXwvcntvrg19jjWIto/PdRF2EE8EBXZGmmbCREM52buy5pxVjvv5E99LUrq9JtvYCNL7/J0XcP3+phqlVX1ywYuNxdCLo8orvnUuqnM2BdSd6nbFlol9zT22wXNsNdwzt6N4f3nD1doWyYB0h7+++bFwfZBJuPOvCfBV3TwBxBFMgNzwQQKfEsmcagO8yNoktANvuz1Ne/GWgY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Record maintainership and mailing list routing for the root namespace
subsystem across its uAPI headers, core implementation, documentation,
and selftests.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7cbce21ba45a..072be5ec7fd8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24533,6 +24533,17 @@ F:	include/linux/mfd/rohm-bd96802.h
 F:	include/linux/mfd/rohm-generic.h
 F:	include/linux/mfd/rohm-shared.h
 
+ROOT NAMESPACE
+M:	David Howells <dhowells@redhat.com>
+M:	Jarkko Sakkinen <jarkko@kernel.org>
+L:	linux-fsdevel@vger.kernel.org
+S:	Maintained
+F:	Documentation/userspace-api/rootns.rst
+F:	include/linux/rootns.h
+F:	include/uapi/linux/rootns.h
+F:	kernel/rootns.c
+F:	tools/testing/selftests/rootns/
+
 ROTATION DRIVER FOR ALLWINNER A83T
 M:	Jernej Skrabec <jernej.skrabec@gmail.com>
 L:	linux-media@vger.kernel.org
-- 
2.47.3


