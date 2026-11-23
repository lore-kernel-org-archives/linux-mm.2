Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C7A606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=k9yfWnte
Received: by kanga.kvack.org (Postfix)
	id 167386B05C0; Mon, 23 Nov 2026 06:45:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13F746B05C1; Mon, 23 Nov 2026 06:45:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054FA6B05C2; Mon, 23 Nov 2026 06:45:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1DEC6B05C0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:45:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62777A089F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:45:08 +0000 (UTC)
X-FDA: 85466202696.02.1A3499D
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 96EAD40004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:45:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=k9yfWnte;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.169 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434306;
	b=q6Hm4qsM836+Dr5ixtDMYlggVIj3G3AObilyiivnm1FTo4qGZXyRdDkIaMHIosuqqxH598
	12NxwSghl/mBORDwjoewSGoVF5r0fX5RsOISdK1NnO6D8pJJp+MEdqE+7WsqL1jXGMCUoM
	pTRukZt+mHMNif5sJYFJxrJfcDSiFJQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pVqS5lS0RoTOTBL4CoDpn/qs9ZBbwa0oy02KVDKJZu4=;
	b=z9x8tIThdnvpP1n5PO2k+PyRWfqQc0U3CZox4NF4zifXi5Alz9+3rDk8XjM0G/a0F2X/H/
	Qhbh1q8BIFzkv1OgIvm41JTITjpNwc9mSpcA0HzCaj/Zpi6xoMFGvqM8QawgbJCkejSLu7
	blHKNPraoRfNVlFlImp5t+3QtgYEcU0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=k9yfWnte;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.169 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-3869f03af6aso2269727eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1795434305; x=1796039105; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pVqS5lS0RoTOTBL4CoDpn/qs9ZBbwa0oy02KVDKJZu4=;
        b=k9yfWnte5qHP3Zx7Ce7k9KM+fSG+xeYYGN3/ZwHlGwKkeWY3SGCn2cwskCjNwNAUiX
         O8wXpK+qXvKvgq2XxrDBUCKTZ2cRLbRfit86k99DUlrNntIeMmXRgoJW1NgUzjHwDE5P
         Z8Kry9u+41Ahc4zZJ7kX4g6HZxRHGaQscC1U/v3MWItEE555cWSCF5GecgYIxYKCSSOr
         AuqNcIjEHmwW6oGRkL4qgtYCcSfOd9O5LZD+dKyLBAHqiR4AWeOUBOhDzYfG8n3wmdWc
         YELjEg6hMyd51sW7wNfMAFtu2TSYZV7ArK0Fx9vspMQSiuLYc1SsKy6LyQZowD8kxL/w
         of4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434305; x=1796039105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pVqS5lS0RoTOTBL4CoDpn/qs9ZBbwa0oy02KVDKJZu4=;
        b=xh1RWAoE1Sy61EU29wy6htMBlIUfduCp3GR4YdhcfZ9XR1+SPN62SwGzUoDqmItYd4
         XXf03i23kOvjUgTlEEglacPgY5kROnhvXMcHCSCVblJsfDTOko+ujFN7/kStZkufKeV+
         bI8o9ZBjTmn1vZH9m2FcqaDNOaajOSH3b6IY6+79ntH8OjYHfOwm8X+8FEr6Yt2ZSgQy
         C78rjmWnapjQKLTND51OB4SCVmeR2QUBo6J4cfTyMLGNlf/gvcvviC9jp8V7v8OZvnf3
         Qz+6VonHQ/qtGO9YPB04gQ2X40d4G9B88U40KowcI71p8GdpQjSBWG6m2X52IeKVnrLb
         xFpQ==
X-Forwarded-Encrypted: i=1; AL+hErHD9jtTOhv/O9C69WeH+lTW23p4+Xqbw2+yV+Y26CJnoZx5f2mUXAS227FRCW72SJyy5I64QmaBPA==@kvack.org
X-Gm-Message-State: APuU4Z/XjnbZLGULzLTxQkLUZyILlkw/KhtS9FFN/BEk0dLNjBeXVw8Q
	Orpslz42NCs9+iMmUhZFFRzGGG+h2KpD16G6FF17SeShoi3Dxi3W9SHdEQvk7RsJiPRB
X-Gm-Gg: AZFdTZf9yqseImOTIwd1ohJ0W5K1/a8swJo4I2xTh+jEgD0iimHVu2YilPxjM6kuD4D
	Hmc90syH7qIiSGgq657h3evIBJ8Pd/NArxIzbUpULCV1LnUbh76R02CA8Mv1SV+D9XoRmhp6BKX
	2wuzd+6HsMExxD4hnIuZg4kHIEPAXhf+HIW4WSQkV/9MQo0VuXqhaehaFJUeF45BjDzOkyuB/9q
	pVEii9C4q0959ndHwaPHXb9pIN24/VhidEYlrVxsOZcBwtGfXSTnNJ/PFnfVFd3uwbFwCI91aZR
	b6ZKxp9GEDS2IF+3qNdvyZi3tCP+9bMCEKnJ2NCBcXdg6JfMcV0cr5nIHaSINMnzVX2lWNZ31N2
	Z2XNOn65eF7pADxMyW0b6ngOGgLjpud06malJPU/sxFV6FU8BPUidzLoE74kbdQUm/avNZIiMdL
	kNJ5VVECV+KOzGN88tPzDZcl0jLK6hZpmdCW7rpz+II2uK8TCOJ0nEtJIoBBI/Y/9Q1lS3wg5XQ
	Okx1Xo8OY9BEzjFusJM5pd1qiG6In5XRUUBACEZdjy+pX8GHTlAndPP2IUIj+PsaKW6u6WLzW51
	TtbN58dgnLuV0IPpr0wj4TV4FizpIdjf1Hz/1YvYB2giCprc2ts+MVyW1+rmEE2oV5bO8m3R3/+
	5wFlw+oBdZLfx4v9WXuxQucUDKTWAw1Kg7RrKZsAfsI3PkcfJpCTCcA==
X-Received: by 2002:a05:7301:4283:b0:386:96fb:28c with SMTP id 5a478bee46e88-38696fb2022mr9810486eec.18.1795434305311;
        Mon, 23 Nov 2026 03:45:05 -0800 (PST)
Received: from localhost.localdomain ([2409:40f4:14e:94e0:654e:d7ff:13d2:447d])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38566cd40c5sm41943583eec.10.2026.11.23.03.44.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:45:05 -0800 (PST)
From: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>
To: bpf@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org
Cc: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	David Hildenbrand <david@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Morris <jmorris@namei.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>,
	Ketan Bhardwaj <ketan@armoriq.io>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH v4 6/6] MAINTAINERS: add an entry for the Kernel Assurance Plane
Date: Mon, 23 Nov 2026 17:13:08 +0530
Message-ID: <20261123114308.8103-7-harisudhan@armoriq.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261123114308.8103-1-harisudhan@armoriq.io>
References: <20261123114308.8103-1-harisudhan@armoriq.io>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 96EAD40004
X-Stat-Signature: mmuqnsm1srcbj5j6w4sqeqkozjjcsqs7
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795434306-360523
X-HE-Meta: U2FsdGVkX18jOB8Qfe5nNseaXA9MHggT5hMFSBDlxhxuvpi6yurI93yuGzWwNS3ZnHQwEVVSoYy6ByklN8nKKoDuMf6e3QZ4lxix8ilvhr98gBXj7x9fwTE57FsLNPFS5c35Z+E/aOYcsm2NefoQFS/wTnCPJpfb0fK8IPIPjshG6CtXDs9VzxUucBwN6x4mBQVoEAEivqTAF+knwOKFD6ToZ766vokwJ3sl3va8SBr7s9Inx0nNNkgExuIzoHjMjyoCW0BcTP9XVClnKJldF/knUo+SolRChTobYFuhi87HPylfrfcP3Eq72QPg8gpUTeMYMNeSPTB5ai9usRRf5bmuIZQtEICQfzEbP1fmhGwFCgoeI3Wx/LcpgbB3U6e2iyom+yKQ02B8DG1yxMFpkjdAMWObM+XPqd46zvFuWElbOTP0yWQmom3p5XICHx01PS2ruP4CDj12zaKDC65hfNOw4cMjposH5qBVAv05+8TQpsuEunlyPONtoU30s1Zm/JSBfh4JqN7Fx8QojMFzzBhHiyivNT9EJZDmN/W73+FEPVy0c70jiYq8vkH2RFG30TOZ9Z2tzb55gUrieYYQkFlyZqTDG8/cx7dQfNPEyZCIUxWKr3HeJUr9n57db5rIoYpCUZZkPEMKZ/Gwhr4hrf7au8LbGyz3WrhAMOAuPAAg3/YPTLmDPC9QdZqwkwz1nqiWy8I6bCczR6pRJVF3qWQ6MkSJADU1UZQe9438J4436O5V4i/frDEDKvZ0hKGXoynOaS5bAqvrLTgIBQ0tbz2tHpCk+jsXmCQfrE6yrzxATigWu00SWXZzvamDbDEymEKcoVFPfa9kUvOqFJxRbcMPZsqq56AoRFZL8UaJgGsfvCGzYqmruzV0U2UvzMH2/VZJ+CAX27ZSHKidEYVveff2SsuCMB4jjuGkY4aqsJfpi0YNcW+TspdD7fodG4EXpsngqWdolgfnjPLS2Jm
 LWEkLjl+
 yYXKULP51J7uko2nx3tJi6eAa1vPez/FkU8ac1JuaNdfis6Cp0J6MsTEP/ycKT2lHiTJ37/6gWxHQw+jK9k43oeZIjwlEhLttZ71/25SKoTjxXA+xMSy0qIRM9r2EMMq/Bda7I+5nkYkgZ6cv6A+6WM50h5beXhvw6Gf3InZV+oy1/xo2g7UdaYDMWmHpr91UXv7dF5gCGuWy0ZbzZon8UkrZcHx0e09TZrxeXia24ZqgHFFiBMp/t42mC6Xg4g8AWla7PYepJJiovpLxPzhvjUheewnlYPRQrV8f6fT64+Ql/CTX7plsXDp52kahOeKWGYSjseUYRdVeR4CSEf+0iHNBT1s7FjKs1XPd0Mxf4j52wgfkm19MznBJuqkqmgRqpNdo7/JEsdEOllXz0NnHHmtlNa+xJ/bOpwZny53krTgWYryTQUkLNMs4OWsbmFMnP7dOEs9ab8vV4rs4VIzU5D25FXM4IwlMrxg4iW2+170MdWrjdznJMxGwv2EK9lFBT0ZEhloEeQS+H1qUz+aLuCfccsLmc6bryKvepJCgiqvMIcx9ZJuHtG5uc5BgDf+qOuD/nrU44BK3HDUri4yKMB1nbXGLV0VsOgu7kp/XrfLXUXoparv06kBy9u3h8NWhokfKeklcX4XLfrAYTjbCnjB3FjsK3pHxZc0whKzK1aWMToYcTFbNtTqHIEDnPmULgF8E6aK/BRhORElnmzo3wjn5c3Mgx8MIAw+VNCT/AcPl7v4AW+v20jE+S6hqfDsUfOID
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
index f53047aa8..0946d151e 100644
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
2.43.0


