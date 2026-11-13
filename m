Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95DE2606E37B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DgyC/4NN
Received: by kanga.kvack.org (Postfix)
	id 8B45A6B05D3; Fri, 13 Nov 2026 13:57:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862146B05D4; Fri, 13 Nov 2026 13:57:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72CAA6B05D5; Fri, 13 Nov 2026 13:57:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 500706B05D3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:12 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C60E340129
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:11 +0000 (UTC)
X-FDA: 85431003462.19.B7CFC7C
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf31.hostedemail.com (Postfix) with ESMTP id E245620003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b="DgyC/4NN"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8lSiLXtXZ1pZqJZBadUPNSQr+zfDoCDjw/Y8Qu2swI=;
	b=JYmLUErflCYtzXEFr4xKN8nXl0hRzhqppwL3tCLywlnWYaZvDAofnX8Z/ePr55C4cwpORX
	v26exojLwPQC/0+JNnbZNJY+TN0ZagwrsA4tf5v0+64w4j8pPkQy3Oz0QnhKcUQLom411f
	ceETam+Z2tuc4e/dTjVQuzRb1l9X/Ho=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596230;
	b=p5tTsRsqM540W7FxJbR7G1HGVBiScQvFs/UNZDIQOHwtjwe9QaaoPKS+jJV0VII2rg26G5
	jFR+5v3KgGSz545HNL6k2QaXf28xnu2W++sWsorVjcWyyJ6EErqe0XLn7FfHHV1r706B1+
	P3yobrFNz6sWXpy1aqgqYQlm5/jHgEs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b="DgyC/4NN";
	spf=none (imf31.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.51) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4919a880834so647172f8f.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1794596228; x=1795201028; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h8lSiLXtXZ1pZqJZBadUPNSQr+zfDoCDjw/Y8Qu2swI=;
        b=DgyC/4NNSq/fRK4qwoD1EpMUvJGcX2xwZi6aZXjCa0d2bHIvBXTeGddNzlLytYYfOC
         3RItzHH6622uvTYuUK4e6un1FFwuas8yuDeFfa6dvF9vSnGwkH/sHoWpx2fIkPTsLr4Q
         miLf9oav+TPct9qvF2FnFH/rzjh3BX7cQCAd1qrz5WDYm3WcSZCfMTun6mIAgbNXRIxJ
         Ue2m/Jq4I7CfLIL1ojm6pmd1zmwEwHE8R4t2ItJH6lne07NyXEpmaMZnMPbMoG/YyFL/
         VzVoNbBtdbl/s+eDm8EYpqnj/RPSkcVAEYHesD56+5QvlWTkeN2gcsseuEs5IjgJWwXp
         OHEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794596228; x=1795201028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=h8lSiLXtXZ1pZqJZBadUPNSQr+zfDoCDjw/Y8Qu2swI=;
        b=EBpQmnmfyE9KYtNVmdeSZHjypJL/HpGZYf+BfHQAQlH1bQ3b4nNL6aD22iNUwfqw5b
         54da2Bb7CqyhGi4C62w6DDgzWb0nzllNvlsdss68K2vmYdb7hEoogPTMvPAdVt179i3C
         /HbZn11r+oS3R1s8b4DLoFgsSE99HDcL3EqoGQ5Gk9/uizNOfIX8dNqCCMKcZSCcGZkB
         vmtyVP2b5oONZ2uhCXnXg/JVRov6XiZKXjSO1L2jICVqC+OZ0PlbYRGJCzqYcQ6ts+2w
         ozY5aO6+ucSBMSysfX62LjXdglJEffU6l87H7Y9hioCHtVoskHQ4F51e2wvolMuata7O
         EzDA==
X-Forwarded-Encrypted: i=1; AL+hErGugYJNDPonrN+mW+0XHzTQ41dGQBHWix87aAs2l9+MHYOCKSPM1gWCwxNl8JEoyieqoG761wwc3A==@kvack.org
X-Gm-Message-State: APuU4Z+WDz2cHWzjOxOYHhdzS8Be4h1Ywm3xwvr8QHtperQfZaPJa7s3
	spXQihsb3m86hduMfivDlgB53/f8nH9DBUpv03m5teZspBkewZ+Fpv17y8hlNVBBa7vMM0vchVY
	y9iEgW14=
X-Gm-Gg: AYBFou13fPsBGgulIg1mFTlk4Us9rm6J+XO84llbHdayv8PJ7pFs9Q27qhAipWtACnD
	oLZMf3g2M4Mi8Fh20UMEj6GKasipr21P+5Rlh7+sc1F0vMI8Ds48VuCF/kal1awlZljaks6PQ9G
	liVWxVKcY3f7zjry88aIW9HbIjQ9A01dCqXjkZpGOLu0XePPZzEwrWgxbBkm1xs5BXUOrCSCGP8
	VsyToyHlysS06XcOSz8ppEe7y7sWNOZDXOjTCkK+/uiMF0VGm6jgK/MGegUZ93n0ywHfQxfpBk7
	QtoLaPrJ+4Ogdyh7tvVr6fyl8Tz6Ok2v8/0z9vE7eeWGhQQ4RH4Dbk7+aXXJSJZOZK5M+s4bhdD
	hIuxynUt5Hhz1T4SY7Etfpym0XpzMALH1MWyXR3gLHBG9G2F2uTcUpkz04yxc6T1wDcsI+Cu3zb
	wZzz2CFAwPgbXjyRVh2bQObosdTRlSRUTfRJizznunYkgKgQyBwRfmj13H44tYYJZyktHSt+lG4
	gBY3FpbUG10dpxAJpwYgH0sL+NUFOmeFp4kQQkVTeZ3tT72UNL4fqn92IDamnLnXoGHUVGUO4RW
	kgwm4XNbq3jjXErwHkm0zZorowfv39GlCKimVt0zeePIjrw3Ayk=
X-Received: by 2002:a05:6000:4712:b0:48e:3767:d885 with SMTP id ffacd0b85a97d-49c73164e84mr7259326f8f.53.1794596228619;
        Fri, 13 Nov 2026 10:57:08 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:ec8::179:1b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f5972a7sm6417589f8f.21.2026.11.13.10.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 10:57:08 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <ckan@cloudflare.com>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v3 02/10] mm/kmemleak: use stack_depot_fetch_into() for leak reports
Date: Fri, 13 Nov 2026 18:56:54 +0000
Message-ID: <20261113185702.1332171-3-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113185702.1332171-1-matt@readmodwrite.com>
References: <20261113185702.1332171-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ka4p3b8iddk4fkn5asz8u3xpbgaxdku9
X-Rspamd-Queue-Id: E245620003
X-Rspam-User: 
X-HE-Tag: 1794596229-6081
X-HE-Meta: U2FsdGVkX1+EfGH8QU+EsJwzc9ExfCQPkykU7ibiDqt66POid+Ps3p3T5cyd12lyemsTLQ1nA1UU+72+nqKPXwFSRDCHeqwjS0bWJoRKjMYNt3azGleb1euPKA+WhZ1RAJ1LcW6arvBfHEcexlbN29W5OJo80NKRGw00jbUyHlvAPZD/ZvoEDOZ+ZVB3YzaBDuGEZiXZgKypEpnCFilYa6A3qsM7nSA95E0I43Fu6iDvycrc0AIAa5iVnH2K6ORcIA/h8OXHFixagB/BG5HV0Wcr85/b5KW9+sN+Cf3nkxMk31iHhxXPhifqM44aASfOs6mKOXVZXiOSfWJ/r83+9pFhPb4A9pqC6D9U+sJEt+SMSVTaf39m68JMHPXg0U9msYIUIPrBDdml+KxTkNb768L7SgrVq6woRJKCtUcvnbM1i3J+939JfAMmRFpaXVhx9Gkl52ge1niDpm2jVg5cv0UsJQbXhcSR6tOdCXtr9ExbRSeFGQPrYDOhYGMT5vW6h0fJrp2sUHtN/5bK5degrkWcdWv/WG0zte+mYtJBG4zwTr7EVoKLVgEDQhCpayQMy6UzEfBCpWn5znQL7wAG5kgt3rjyRaUlUxqQuZ/cxBuBTAjKuo51yUYVymPLrik8nvOwAoETLyPnfajSDdIZNy3plUzzP4hX11HXD9xZkvF5/Z4SqA5ctTCpZU/pEA6GEnSgTKmfqZv8yEFfdrpRxSaysL+FWufVs+a+Zp6qYa80Ywhg6S/OkKyMMnDfui1Bx0iWRGkbVrQ2Fl7nvKZg16ZUNiIeTZz0LzZgqkZEMejozRYINwVVhw6xwlI+98AkwAach+EZ0udAl9SMxtt70qYxwPA+lcEzWcN7jnyskz/8RqrqNkDgr+8iNnR1hl0ltm/mdtd7YXjKLrsQbd9pxT0RAHVJFGSe/MI4TtSgUWv5K6mPiwZS7lk6SWd8StFxMKj30Hjl850WLn0Q8B/
 dSRM2wxl
 ICaCIoMAUC6Pva6KSr9rA1qalNG+ezyk4qj4LwKD493cbEnMiX25c68ZpM7UV1/qrQuXY08KkKg0Bt+4J1qPJCsS58pDK3zESGq2Qkmv8n56O41O/yib3w1n3trAzW02doSZtktBG9O9C+QZDTdVl85eL4sE1MS7+oBumSViadPvYRaJ8xs5ypJVnugSEgClGYFODZPYOyHeB0eCez5gbPQF7qW6uSDNc21puzCJhPL8xt+p3Vs7p3dIs+EAmiUsx4L977v1cTIXWfLdQbonbxn9nBc2sUahibp8y8AhO6RS6dYB7X7sC+XkGTof2WNNog06RRtU6eoT+nkw3vvYkv1R2QptucZZUqS/zttiutIOA5+cMnXb20UqIuvQ+6lvz/nSy6zEZEoiJglkiJ4HZsBpHsXeGRIOnP4u7B0dv9e56CsKEuRBPSpW+e/jnfw0+okLV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caleb Kan <ckan@cloudflare.com>

kmemleak stores allocation backtraces as persistent stack depot handles.
With compressed frames, stack_depot_fetch() cannot return a pointer
to unsigned long stack-record entries, so leak reports would omit the
saved backtrace.

Use stack_depot_fetch_into() with a MAX_TRACE-sized local array before
formatting the report. MAX_TRACE matches the save-side limit, so every
valid kmemleak trace fits without truncation. Preserve frame order and the
existing report format.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
[mfleming: reworded for compressed frames]
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 mm/kmemleak.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 20c0eb41c873..61ff4a10ce11 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -378,10 +378,10 @@ static void __print_unreferenced(struct seq_file *seq,
 				 bool hex_dump)
 {
 	int i;
-	unsigned long *entries;
+	unsigned long entries[MAX_TRACE];
 	unsigned int nr_entries;
 
-	nr_entries = stack_depot_fetch(object->trace_handle, &entries);
+	nr_entries = stack_depot_fetch_into(object->trace_handle, entries, ARRAY_SIZE(entries));
 	warn_or_seq_printf(seq, "unreferenced object%s 0x%08lx (size %zu):\n",
 			   __object_type_str(object),
 			   object->pointer, object->size);
-- 
2.43.0


