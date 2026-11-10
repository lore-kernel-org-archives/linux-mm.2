Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3E7C606A8B6
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=AMeWU9sD
Received: by kanga.kvack.org (Postfix)
	id E04D86B05DF; Tue, 10 Nov 2026 15:24:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDC256B05E0; Tue, 10 Nov 2026 15:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF2356B05E1; Tue, 10 Nov 2026 15:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B6B326B05DF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:24:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D82B40A55
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:24:31 +0000 (UTC)
X-FDA: 85420337142.25.8082184
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78163C0008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:24:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=AMeWU9sD;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.181 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNWkhMM9mRV69+bDPtzO7ZmhT8HSmB461wMg2BUz4JA=;
	b=5RKJ4FWk9VN8Vl0eujlHBcKgZo4JJTybJ5AdfjiLeinrSpnebFQvDM/kzjjjumjw/HCae5
	tatHzSLUzJhsgceW1mqLNHJeMmpWzeUkXCsZ7GvuLp88CYI6lfHy2yI6iIPTP/hF4vCDgC
	SabAo40TwCBv/Fc3Zg2UVEDBJZ4FhtQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=AMeWU9sD;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.181 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342269;
	b=Eew9A/QKoPs8duo1PEy6Oy9ss2rk2zDtJ3QkikXdajUiaGcdBVkNnvU5tIVFxVss5qBEIF
	re1m0KQSwZR5hH+G36pZQlRZyGn9CgocGiCLlGeEIMZ7XUCsitK/nN33ry6HRiWZ/jGL6Z
	N4O26p3NxLtK/6TsTmcxWikrSkk3G/Y=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36fc0a3fe93so4876641eec.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1794342268; x=1794947068; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NNWkhMM9mRV69+bDPtzO7ZmhT8HSmB461wMg2BUz4JA=;
        b=AMeWU9sDGVu7/7JyuwGHiQD3SVUxHQz5+B4Yh+Oo9ARFJtGQHpXUwKboW8AKjJF+Co
         GTMTuseYvbfc8ZBwYLC7xunpOzGkkwyQISRd10JO3/nR9JIYEmHyh8OvCyayqMOryny6
         9CA8exzK8xrrJ7Kz52C1eo2HPgwQGLsqUPe/jsSNv/24od8rIZ36i1NbXWTKjuf4/LoN
         aX1XaUb1XE86OguT6FhlvWIqRzL4OPL4lR1E2SPNYxtUKShfzXrwkNqHRWeo2V3F/G+f
         Z/O9nOK5puSA0ZjclH716t7PBXKTEOLBNs/2q1DYZwbQ9IHqS6wFE5pcVBJEgkKuB/dA
         Zvfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794342268; x=1794947068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NNWkhMM9mRV69+bDPtzO7ZmhT8HSmB461wMg2BUz4JA=;
        b=v/Wq8vpEwVSE561S3R8NbWiC3BMFsnXMpmihbxVJ/94tcIK7MTywXhyoXQmzGJUQnN
         tbxuntYS4h3iV1fCTfdWIdKjBgbEgVt3Hx4UhYt0w9Qu6qU8grC7fQdystGks7zxDjtI
         zkukAhDfvLb4ffWWPWjjYVfqiRNyoG+uN32Wxy1S7JaJ6c0cks2VDcvITQEd3x1/564r
         wieQrMZudUIohHYvbLFHlAkhWv5piPxfduRCFM2Ur0W/gxZI/tsbgwp1nTsieLnZ6t01
         wr5BroiKLTVlzk89xBZMeQJ0kCZgECa7o6dUlHYPpY7+prT0kfrHA5ExByu14cup/tvJ
         aalg==
X-Forwarded-Encrypted: i=1; AL+hErGywK3CXoHj/yi06qjw3DShbqqcvEnsC2qApL0R5A0hxwZZT9mgLjPtS+LwXXfEx93HT8I68GPUEg==@kvack.org
X-Gm-Message-State: APuU4Z+lhQlDqrfhhx+NX979082nuO6HqWEFJDPVqSo68ba+XZDYFZ99
	PjPPFaqbdKQEteYN1vdeSjuSqe7BPS9MNFqUqoM4GpTGfNui5dvOAZKuSFYamLE+42pz
X-Gm-Gg: AYBFou1k9X5IPRPuAXXa9fI+IZhVRP5P7s5JDlqSfmvmHesY6MrhtPaG2yfN8aoQ5Bq
	c2BsElFMDNS5BsdG31aRk5i/EvlkUxEun53gaOhznw+XIN7qKodrwFyyjfWmOJwIDVBe6nCdICz
	Vurrt6bgZ3dCKx333MRDfqx15rTbh1eT32Jf33Jyz59UiWN1RrdRAUln01MLVeahegz8sA4Ev3s
	iMWy4YOehOFarlPe+6uvl9SPyBMu3b1HM3V5Xh/UnJ7rDBsPhbr5tEF7272hO0lQOJ4vU63/bxO
	DL8H9HuWOQL0pfJRdj3Lnn4rxXbL7WnbYNU1uFaLYJhCg9oCA/1QjNG8Sw8nGCxFunehG/BJDSA
	atCkdYQko3CMzq21lLyNxqq/9l8ipumRSIUNeUBysu3fOeV5Gsw7FFPxd1K51tC5VrN1dsBpahC
	1hOuKxbwX41T5gkYbw9varZthhokdDKDJF3DXfWmUH5He9RzAPe+hMch0DxYiw2Rhs6bV3rfZER
	cn5XSdIjsrMzfe0GqpC3Pwrmhj4ToP592LGmGTOfWzbYNjTn4Vs/gVbV0azhA1EixXjbKxHiDP1
	bZnqPKAEoVr6/OxKJfIZhBWFPvfL9eMLyE2n7zoGOLMqVIR9zyRN08kRUBwdpGQYZ6RUfcBHs3I
	ravzeVrVXYJQUCwEFuFtu7qBS94u3V8tL4Lmfn+QIWISQKCA2JFNx5Q==
X-Received: by 2002:a05:7301:488f:b0:376:2859:5b2f with SMTP id 5a478bee46e88-3768675d705mr516619eec.25.1794342268101;
        Tue, 10 Nov 2026 12:24:28 -0800 (PST)
Received: from localhost.localdomain ([2409:40f4:147:2742:6545:702a:2431:7dca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520cfe29fsm10076615eec.21.2026.11.10.12.24.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 12:24:27 -0800 (PST)
From: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>
To: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul@paul-moore.com>,
	Kees Cook <kees@kernel.org>,
	James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mel Gorman <mgorman@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Ketan Bhardwaj <ketan@armoriq.io>,
	bpf@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	"HARIHARA SUDHAN . R" <harisudhan@armoriq.io>
Subject: [RFC PATCH v3 6/6] MAINTAINERS: add an entry for the Kernel Assurance Plane
Date: Wed, 11 Nov 2026 01:52:46 +0530
Message-ID: <20261110202246.274-7-harisudhan@armoriq.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110202246.274-1-harisudhan@armoriq.io>
References: <20261110202246.274-1-harisudhan@armoriq.io>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 78163C0008
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zk9m4iokmjybcpnm78pc54rsqb6fnn5a
X-HE-Tag: 1794342269-776939
X-HE-Meta: U2FsdGVkX1/W8ECXLEhEtwCXXoElG47CFmBLautZdMAnDkNpetgfxxfv4jf69/tXAACfbPr4YGDTlj0rpHWNV+EWtz+fNPUZrnxjTCsvm4s4yJd2FhPr4FFTgVunKx1wEC81OvzvR4obgxubG6C9CyPBFodU5VNVjFNURAnJzt98HdnPrJvu3lzN1k9qu46SqUjohblUC+LqefMZCSTjscJbGCsdZpq4+Yvdb7R2oLvBPJ6QM97kR+h+NEYpWFmtCpSs5h6Kg6sSFeqBgVgwa+8TSfIQ9IZO9vs5JKAB7/Eylm5PhbYYekuji8oBuVQwaRFgpyUKsQn93GJhDgDSN9ghJYe5hao5p2df+FlQSxqcs58PwhsStvD5KHcqnW/P/SYchXImb8r6FK5OUBwLclmQFglkegOU3gaFEkU98/1ushGJvaXUQ5swTUtMDcZK4RhPWeamb/dhhx8GNrVnNcMUfNExrSPWgRmitUXIDOTXAHCNNLne8FCrpH0QMqdJNYVLHAW83kkf3cRH+/YqdO2GV91vhCqSiRTU2D+SquJF/Xeo2iuL8u2TtJADRQkTb8cUgnJXzJwEjHUi9VrZfVdkMpgyhv4it6e8aq4DsqJvSiYkoXCT2aYWwPAqQklxSpC4OwtgkytVB4r6K3Ct2pPbtahGsqfZ41AQyooUXcs9k7jH3NAGz09dkEXz2cod3ncgIG8dN97GMnSEUjePUkDeQ7a54n2oPJcnj8s2k4JJnl26VP7Vq5LHm7S0SwBjVGb4sKXZrYtAQ2wUsqT+jUYh/lxenTIXyfl8oqU5AYKG7lMvLuX6Y8x1uQ5hXd5S5v47fQrOtlQA5v24BBzVMiMDTHgU+vvfODmwAcGfPGIZSUaHWq4wNy4pjlPRKXqTfFnXlpaaXjgrAtsuhyalCLEFipZYVAk/jquCcy+P7YjBaudhMTTZsKVaplFfBaI6+GeBq11Nh6pzwubbQVj
 Lmwg1tsf
 eHvh3lkAQhR4ddv7phVpNbuLEuMY0v9h3KfVZ/daUz0RauPYCtYgH1sxJrXUN/zsXSPRrEnRT2gvkxU63nJSkoPj4/JHtrmtGf9HmFg3JoAKBpiFUuyPeOAEnZRsZaR7ckPvcjUeCDjto8AuBQ3PEjxQLPpe9ugS0uJ2uCtD5epXCzpUWOkE8GT54LcO2GHnyOxr6jkRKeQ2igO99CvVnfRCV/AdDfN3gg9B4gLEhrli+0U35ajYICEmD//5Ermn/W6rozLSJYWCLOhG3hKqeO/jP9b9+iUkFFSXUyr+EX7hkMgAbjdHzas17cpWSXb7hm7t8HktdiA8hwbIA7aKW2eCzD5jZq6pSsmjoy9y7SU8fDUUbvyIKxi9Ao9OGdfzkK7t/ZN36wTiZsGzYYvPfPCPNJICb8qKg6eBzTRAJdfn5bI2G9p3mAQlBtr+YO4ds0+nujxbW0uORqDJv4t6fCSK9VJ617PKSpyIkYKXvR37xlWBZe/xL53FsjrBOop1qi9+J2gJVdLKC+FnlLaUzcJ2D36OdDMduUanIP9MUl8rpMG3Hzb2gR8iN7ezavVnX//EE/Vi97L7q4USZlEC4OujrDAIRndDC1UW34K8+eUlr0BU1LoUDnD84lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add the KAP maintainers and the files they look after.

Assisted-by: Claude
Co-developed-by: Ketan Bhardwaj <ketan@armoriq.io>
Signed-off-by: Ketan Bhardwaj <ketan@armoriq.io>
Signed-off-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f53047a..0946d15 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14118,6 +14118,16 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media.git
 F:	drivers/media/radio/radio-keene*
 
+KERNEL ASSURANCE PLANE (KAP)
+M:	Ketan Bhardwaj <ketan@armoriq.io>
+M:	HARIHARA SUDHAN. R <harisudhan@armoriq.io>
+L:	linux-security-module@vger.kernel.org
+S:	Supported
+F:	Documentation/ABI/testing/securityfs-kap
+F:	Documentation/security/kap.rst
+F:	include/linux/kap.h
+F:	security/kap/
+
 KERNEL AUTOMOUNTER
 M:	Ian Kent <raven@themaw.net>
 L:	autofs@vger.kernel.org
-- 
2.53.0


