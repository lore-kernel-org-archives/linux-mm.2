Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 956A8C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 10:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F21E6B0088; Fri, 31 Jul 2026 06:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A35E6B008A; Fri, 31 Jul 2026 06:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9586B008C; Fri, 31 Jul 2026 06:13:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AD0B6B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 06:13:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B478D14039C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:13:47 +0000 (UTC)
X-FDA: 85048660494.14.3439EB4
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id EB20A1A000C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:13:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=u59+EVoG;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785492826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LK1SF//t3va2bThbeH1OWK77lJlFXbCBS1qpFyGJdU=;
	b=f7K0o+HZgzBNg0XnVd9cI36Tiia3t8wmiCT0MI5W6Pj4b9zeH3kqtCFHLL/AObYUrWdpEj
	Z3AmassOG9p00jV5GQshamJ6VniRsLyiDAUmg2nW/NvpSUrlPqVPO9Gd1a7OQsUY3MS4wT
	iGPE8fwDSMZUSCFfivWmlaw+rTBnFrM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=u59+EVoG;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785492826;
	b=bFCCsBDyjdfJy1Q7+wspXG3pSAxFbp0bZxAvX+GWaGrNPPr7kC8wiR/L6raNXKw4VctGLg
	skdgatfllBbh2J6u/t84uOEYpvy1AhrYXWZyQ/PLYXVe33Xez2HK/L/CHGDh4Qm2usc2yh
	0vrSDU34ABbWb0yXlOjRab0IhUHyee8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=8LK1SF//t3va2bThbeH1OWK77lJlFXbCBS1qpFyGJdU=; b=u59+EVoGC98m2JEO8LFmuFQs7B
	Y02NU7GEnkp3ZquWsk1yC8BpCD5AuwZhSzGdonKvi3ahW/ninNrLBONNa6FG8XQpSpbM+wocf8QWq
	Fjxh7MVNmvPxZq5fg1YPykGNfHtcDlf7yyCz4iyZX/a35i3m4AeKLu8Oy5lrODICFpXQtqmK6FPsO
	jRsh8T409Wr5ZJWVFD0Vk1G4kY5E7ijUsKZVaFIyl8OU5fOB3fGUyZ1qwNQHUSqIXVTVVD5rt1mqF
	HKi34LuInZ2UD/YYZD9JO7d7ZOs8PTQWSkcuityzhDigolK1ICf1mt+d5mTokX9aQCm8ZzPO2rE08
	eilgjXmg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wpkF9-009wAv-1O;
	Fri, 31 Jul 2026 10:13:31 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 31 Jul 2026 03:13:04 -0700
Subject: [PATCH v2 1/3] mm: kmemleak: default min_unref_scans to 2 for
 verbose auto-scan
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-kmemleak_hardened-v2-1-7b9689ac77cb@debian.org>
References: <20260731-kmemleak_hardened-v2-0-7b9689ac77cb@debian.org>
In-Reply-To: <20260731-kmemleak_hardened-v2-0-7b9689ac77cb@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, workflows@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=1646; i=leitao@debian.org;
 h=from:subject:message-id; bh=DaAs9v2s48e9JMFkP+I5JIQ1sntx0U1Ktp2zFL4yLtE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqbHVAsT97IECXFQK2T5y0rTmoAdJIv7jKa0scr
 gqh/l+QROyJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCamx1QAAKCRA1o5Of/Hh3
 bR2MD/96NkIxUrTkZVumh95rB23L+q8p7ZqHB7FrhzGUp9KmBdL9RzmuB6fzjDt4Zwxi7z4cSLb
 hD3eJUmI8k/xCJW7LAV1nvEieJq/GrowJ1YCvvbFyAVXq3xT3CX61ppzdrpTgZt8/rgfqApHikg
 OwPaN1FJ9rBWIDqddC+tQGi0V6Ra1w6fsnyEv1GfWXjEXiyXuzEyp4/DRdOrh5feJH/M6l9oUqk
 RpEKaMNlV8C5gGF3AXJSpaq9pRgGGW9+3Z8hpWROdbd1r7j5M/UpVWzoW8wmuSv4RcUmcPduQF5
 gtzK0DOCHNQlBTLjLm3foQBGw0Z+Gs5cQEEKB4xCFLir4I0/bmEE3zLeGcgN9nlX86yRC31GMHe
 OBFDJo+oM2MX5cnozIEfpyxQ+iy22Wm0lxMpSzHmwMqjk+RgBMySL2Sr06+u3StGLSNcS9T1VI8
 cRn0gbnACMoT8TfNkMnDsbA+tGm2FLg4Z/79ATyxCl2PgxRW+R6Ah0P9uXMZhDUQxPNbFzWBCh0
 pEJv98e5oFLqKiX7DYNq5oe8yR60A0VxG0Tpqz4hmZf767Afdq3RwjKaWqPMvsZe+X0KZaEyH7O
 hIc/yiosrztgTH6toi/L96B3EeYq9hBeW6wUjDaBf6QUiDN6ePrYuc9LkNknlDOKKbxRboYRLRE
 5W+Cz3RXAYaVEyw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: EB20A1A000C
X-Rspam-User: 
X-Stat-Signature: yw4y7dszj81e8gxr35578wro1x7dt6rx
X-Rspamd-Server: rspam04
X-HE-Tag: 1785492825-202457
X-HE-Meta: U2FsdGVkX1/2hPjS8cV9e7eoj1RrZxXFvXYYgJ7G9KnuvUSOurI/4oewgkTVdldp5Z9AHkdSMXCqlqNPSlqrTPhyEKFbeW8wZIalECZRTZOdwKD4mUKNHkfQqYr9GkyYBbatlfgHwpODm2LGSYlsmFQYFMeEOlUBrCfdlplRMgS9l61DFzbMVGXaE1cVrd1TFBr/n/27xGNMBpDwCW5ikHoAgw1gJfllaTkBeXpDKWwhU5PjdnS/nETMinoShKLAZ791FTEOea5JKuacb6E6YTSxcu7DCXctFmuzKiFV6I7abKD07td5RzpsldFUaX454epAkTKcJ6Yr/5mI6lZgMyqoxccdh9xlyRu6WByrOeqj5eP1ZRU+SAKNcRUEEIcV9620HDZeUZ8pPyHyyqmzNJZfXNiWxTOETJiGBS5+4WwOiTzmKlMhXmLt7qEdiYvIb+IP/WHKsY76moXMYLbH1ogv/8GPsN2K2FNuSseC/GOxPhZMKLOPvHcsuq6sm+vwzIFRD8a8DrvzO5yic4MdqQ7Du9LnTwgAL3lvhSvHLdofKW3SKmxH34cgRc/CQ1OEloriJ0Alg07NByWTHNPV6Vmbako62ssu/w4VtaOqk50uyAryBxPFJXQk6xNmgZWhZmkMRO5qetENaFg9Rv6v9XOHqjCk2Cek2lbX3m9vaonnq3hKNMKOwvRi3xnGrgfFhT0faTJuF8twhwISrmxKMscbTYwwUHTZR1GmfKk97rBMCKNJ4n/WrtbzKXrs8XF+IZkzFpCZo457dOUzGgf9clfAblfzNOLxZP3JdH1vvROOxwIDpxZfdLqLmwfKMVUORtq3xI2dJc/VQvOrM+melwkEC2A4uhmmECgNgD2iT+nit5u5gWIg7Cs7nhjgnPRdEbMgL+fUbILDpp9kLDp7wUnS9N5Ez2B2G1EEbmITLQLrhSm5IXt3Ffh/aF85asR8SIf5aBxywCYeC+9fFDd
 NeQ36yoJ
 2ycimRhKPxm6MMyaOcAhjdDMEBZjuCijhx/MRLlL8HGdsY+kk0LiBZ/aXAW1fTMqaSuM6f0iXbsAIQ1/HRLJF+stvBKpACcsNyb1sbutDpauI3tepyYrFxir39Wxx4pqKXCoB9F+WvfsEhrxoRZhppEGXWth20Ct8o+rtT6MTnhR2PBBmvvullM3xYm6z0QLtksGaiJ2vEEqpt+PsBLope/tDn6jtklFLnrT/+2bh8EBIxQfYVl+r9SLXH0UI0Zw13x6MUthC/ebYmKTIVKEy3n+V4mF3/HQSe35SgaaJvVwIsDZyjQR60wzt1lYxEfB3iWjtd1xTU6vvomk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

min_unref_scans defers reporting an object as leaked until it has stayed
unreferenced for that many consecutive scans, filtering out objects that
are only transiently unreferenced during a scan.

It defaults to 1, which reports on the first unreferenced scan.

CONFIG_DEBUG_KMEMLEAK_VERBOSE depends on CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN,
so a kernel built with it runs the scan thread periodically and the user
has opted into detailed leak reporting. A second confirming scan then
happens on its own.

Default min_unref_scans to 2 there to suppress transient false positives,
and keep it at 1 otherwise, where a manually triggered scan is expected to
report immediately. The value stays writable through the module parameter.

CONFIG_DEBUG_KMEMLEAK_VERBOSE defaults to n, so this does not change the
default for kernels that do not opt in.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/kmemleak.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index f63dfacee7ca1..8fa409a4f9fb2 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -237,7 +237,8 @@ static struct task_struct *scan_thread;
 /* used to avoid reporting of recently allocated objects */
 static unsigned long jiffies_min_age;
 /* consecutive scans an object must stay unreferenced before reporting */
-static unsigned int min_unref_scans = 1;
+static unsigned int min_unref_scans =
+	IS_ENABLED(CONFIG_DEBUG_KMEMLEAK_VERBOSE) ? 2 : 1;
 module_param(min_unref_scans, uint, 0644);
 static unsigned long jiffies_last_scan;
 /* delay between automatic memory scannings */

-- 
2.53.0-Meta


