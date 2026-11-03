Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23220606D808
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=lGI3NziK
Received: by kanga.kvack.org (Postfix)
	id 3FAF46B05CE; Tue,  3 Nov 2026 10:19:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D19D6B05CF; Tue,  3 Nov 2026 10:19:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E88F6B05D0; Tue,  3 Nov 2026 10:19:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6776B05CE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:19:18 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A70991A0493
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:19:17 +0000 (UTC)
X-FDA: 85394166354.01.02E5A88
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id C569620005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:19:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=lGI3NziK;
	spf=pass (imf03.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793719155;
	b=mDayuQWYwzC8HqKyXAkKwvmtM6USVWtTKYDG47Zy+joscTGeyUT6PqijqH9KOOLWw6OSir
	Fo4ACsrBqL+31k+b4GGKCwktAz17bT3bZ6UvfAsT6UXdIhtODZvzJ+lZe0J30ebrGZk7yD
	nsjFtYKDzK1gcaFoWYzvE8CNr4sxpdQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=lGI3NziK;
	spf=pass (imf03.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793719155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nFMfg3/nt4kJ6ByBxDP0S88zpskLBtu8XVaP0ySPO4M=;
	b=TQTPTQc9RId0wFJg9ezoHATWQpdfNe/QWdeZieQXAzitKrEahqkKlgezcKW/P7Hz113/4h
	+2Bgj0SqO6my8EgDH10rZWrNXUN7/u3PwHFe4XNCqK1uebVIglCL/GkPgyQDSXZItB4OU3
	mbH8JNU3JNR+of75vYjUBA10IMj1lCw=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e5fb79ce82so28379855ad.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 07:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793719154; x=1794323954; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=nFMfg3/nt4kJ6ByBxDP0S88zpskLBtu8XVaP0ySPO4M=;
        b=lGI3NziKVYy6aMSFPa2qHvjyqV32FLVqzmc2t131N5VRfFxeP05ZbDpu7Zn1gjH3tJ
         SGyF+YxG4F1R9H1SpYBl1FXM3O1pUeaPpG++AVqjnOx2b9mFfnLQDfVBuV04q/AVryUv
         TanLKspuNhinQ8avqrKdCp4CW4pHUmLmLMCj4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793719154; x=1794323954;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nFMfg3/nt4kJ6ByBxDP0S88zpskLBtu8XVaP0ySPO4M=;
        b=jg+9Q5axH7oxoAKQozOWUhxfNa4TAMdgGKoXknrmnMuQGoX46enmD3MY8EmXqGUZ8L
         5rrHL37cAraMprAAlLkV3uONgbpVM1q8n8PMVXsBFNjECf2Xb3Cwzab8bx+cqNwxwTjJ
         m7HS8+Ht9Oc6NQgs0aMJ14EqKVaUj17B9vijCzcwJ1j08LjPnJW/Av5kyVvpeO5T5DTw
         Eg37NRgg1t1IWgBqRTS28/ffezsFxRXT1vFbDMYpOwUeaMzvlPHUoruyTUsJenqd1VAh
         JhDzVCcXgxbequ0BMY4jwQ3Xuq/zpXxstDHzAgNL20Z7lKxnXo9xnyZ4yZVr6VJHM1W5
         hRCA==
X-Forwarded-Encrypted: i=1; AKwUvBxR4pn+WpVLM+M9b52UbZV7kHKmalrL0Q4x2vT0jUc89G3wD9y3VhTmWgVaFuirdh4pN2NLO7GFsA==@kvack.org
X-Gm-Message-State: APuU4Z+mrhfkix7EOA3J9qJaoHLzyAEMYFjjIL5COVy4vwBWESB/q88s
	q8uCDlYhf8b7SE7fV7zRCwThBU6asnKwcaXYH16pQV8JkAzmaGSarNjjbS1h0PTwdiM=
X-Gm-Gg: AYBFou2u4CT1tbGJO2GRe0Ss43dHXzKeOdBTkqUJH2PSiIJ2hVA9o5kz1Rg4+rWfMya
	03vnnOy4gLIQUie8UBMXSBN998yt6QkFT/L3V8ZQc/TZ46VIBr0NsH1EmBpLWCAva9qoywqayoo
	U4ASVIKVKXzZxq6/SuYpYiaAZPNoOIWd6KS8b+igOj/Ug+2wvkeELkOWInBDvan3LToBoe0ar7H
	mFdeQ0+8J3ukl2LVm6N5u6h3lleOcU9bg9L6+FcFCoJcBgEIxmrCi3ozffdhmvNFzGqJTu8OmJm
	sib99jMKjek6HM08NwL+NdPzYfPXutz61Rd+LvzlC1edgTGR++dWq9FcS7dAYwYOaaMAkKx6Q0I
	o79A5URMX/nZeecvQWX/r0Y7fi7wLWZWARhoZL7tbtSOYzW05Kf7SyyV0/suRmaDWU6O9QxG7YM
	9/Q6XA6rHAJ0ZDrhh2HDJuHWn9wOgOzROroPx1xVkMCFwvlLWkzkLkDuHebo11i11uLWaA1O3AU
	BHz82Ox8dnw8/161RYBCm6WNu5woQLf86YOTng7/s7QJ830eZjXEMxGUaePkHBcNUBl17OpEkNl
	9GygQka6soBmP0RUerXo44MSa4OvUiF7yYBID1SnUSi1TDZerlWNYOQhTaiGbsFl8/Xdi2w68BS
	1GomuA+RCtLiirJ9jFT/Ly2Tev65PUxmmJcoqp3DQNsllGuJuCE5nA16lO0AcilcCv00n3hDJ
X-Received: by 2002:a17:903:1b2d:b0:2d6:f6ba:263d with SMTP id d9443c01a7336-2eb36414d03mr125058495ad.7.1793719154563;
        Tue, 03 Nov 2026 07:19:14 -0800 (PST)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb392492fbsm42885535ad.32.2026.11.03.07.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 07:19:13 -0800 (PST)
Date: Tue, 3 Nov 2026 23:19:10 +0800
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
Subject: [PATCH v2 8/8] selftests/mm: Check that no_mseal_sys_mappings
 unseals system mappings
Message-ID: <053ef1ff0a6a7e5b37109d59a064a7665e087cb0.1793718940.git.chris@chrisdown.name>
References: <cover.1793718940.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793718940.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Stat-Signature: ys1zzddoxnzuucemwr9kgptpj6gd5hgc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C569620005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793719155-549663
X-HE-Meta: U2FsdGVkX1/Vw0fE/TUxjlc+nTBn4VuyLB8zi7Uwauav8IEEZZLCYOp0X5r82wdbpAMBsYgcHL3ZidxCt8to8rVWfwyHKGlwED90iR5idowHPDZ9iRewBZuQ0IKW3JOOZviGdWQY3WK757XFFp8Pw2dyjXCTcvSfbD86YORktm289GWXNRZihyZvwkl86BNgPc1aT4dAdX9VPTonP8H6I42z7mFqxc8aZw5L7PXSrfy2ltSZ+M7RsrCfBr17NKgmOEGJLqGV7779C+0uScgZsVLA2yYCDJGJPwonMKzl0iFrXOlb2/6XcwtSeLlxrkb5am+ywZyyu1PC1DUtJRRHApP0bFM5QR7x9721e2IPkA149WBKCLwqxPakrlK08HfqMPttJhCdZeCBIHw/GSMoUS2NPWCcVbEhfxkX6+DOf1FkXQd4qMAXqjYX+X6T9IvXTbaKxyO8PjEZtxq+cxi7Us1J9xTDHhyqUKkJ/5kYUadBhtDQxqBecuX5l0r4HqIZQCCU/ZI8Q+XrlwPn+mW93vRzL5VNXSNRQ97ILILARJ+heYzOWJS4g6BLGLJT8vbQl1d+005xCgQyr/7LvLNHM/6qtVD1cvEqCeUuImAPPWjYimwFNkO+/KIY/GZmfj2RgMCPI7UZmON/T2lujbrYzeAlrv3tTZCrHx0hhpgEmwbxGCw6Lszdeb1xLZs3PgAOp2idjsY9qucsGdsFRVQEcSntRgGMpJ/O/6y01UvSDXygt8cncisG9hx1fUqo1BsxZ9/Gqt2P6GjNfz0Ny2e7IBbfkI4VQfH969rJdqQfU1BRYanmYBFpn1V+5p41s8gAMy7nNzF/rRr++z++rXiz4c1PsFML+gwS0VW42GeMCrtaaxd7oTqw/JmhirzXL75QMD4ax1JuU5j98Va1/pHxc3CqYzz0Yjtz0YmvgEX12aQHpGNQo+27DSBj1yfi6WH0NedU1Noh+ztveN0tINN
 5ERv38G/
 lSK6sujhWv6cGlHWud3KUpuJL/TMZPTv9ampDDVaMRN4wSply89znkL+7y437/36oqr9fs/A5dfURSfboq9VhlD4nBH5H1A2QQiRFIYzbiKrcIyB+QYdFKaRPs71taYtBHsthMJdhhNJCzStnDc7XB4R6lcvnjCx9LPaHqhtoSob9skHChRxeCaO02EL9/nfon5pz3XDGMdHihvSZ1hGXnkV+E3jPfi5osOxo/5rAiSnZbd4GJ15uXLNXERlb96tTsCdKR73AUqB77qenrBpvCihIRhpOKiDwrXTmhjIfK8SZqMf/Jf0pnMKZ98PIrtQbUTP2SJTjPuUogkz9BiLiCDb58YORDsoEu3rUVttm7V7pvX4bFS6uZ/5YoKYCLnaALPewQ35jdrOFHWroYR4HmIpyC02CEvzUv0jPTioy8njqtPvo6PPbHfhLfKJ5mhh6fWR6NC1+emTS00CbuJwJnbPEzaQeXDosh+1NDT278UmT6lQ/aMdNcYYdD1ctDy/yXN1HvYUQ+k4721aE3+NJvu67JVsiLCIhTUSj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Booting with no_mseal_sys_mappings currently makes check_sealed skip and
expect_sealed fail, so nothing checks that the parameter actually turns
sealing off.

So let's check /proc/cmdline for it, and when it's there, expect [vdso]
and the other system mappings to be unsealed rather than skipping or
failing. The vdso tests already expect munmap(), mremap() and mprotect()
to succeed when [vdso] isn't sealed, so that covers what the parameter
allows as well.

Suggested-by: Jeff Xu <jeffxu@google.com>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 tools/testing/selftests/mm/sysmap_is_sealed.c | 25 ++++++++++++++++---
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/sysmap_is_sealed.c b/tools/testing/selftests/mm/sysmap_is_sealed.c
index bfa140e01d8a..158e116ca3b4 100644
--- a/tools/testing/selftests/mm/sysmap_is_sealed.c
+++ b/tools/testing/selftests/mm/sysmap_is_sealed.c
@@ -56,6 +56,21 @@ static bool sysmaps_sealed(void)
 	return vdso && check_vmflag_sealed(vdso);
 }
 
+static bool sysmaps_disabled(void)
+{
+	char cmdline[4096];
+	bool disabled = false;
+	FILE *f;
+
+	f = fopen("/proc/cmdline", "r");
+	if (!f)
+		return false;
+	if (fgets(cmdline, sizeof(cmdline), f))
+		disabled = strstr(cmdline, "no_mseal_sys_mappings");
+	fclose(f);
+	return disabled;
+}
+
 /*
  * Kernels built without CONFIG_MSEAL_SYSTEM_MAPPINGS don't seal system
  * mappings either, so check_sealed skips if they aren't sealed. This fails
@@ -63,7 +78,7 @@ static bool sysmaps_sealed(void)
  */
 TEST(expect_sealed)
 {
-	EXPECT_TRUE(sysmaps_sealed());
+	EXPECT_EQ(!sysmaps_disabled(), sysmaps_sealed());
 }
 
 FIXTURE(basic) {
@@ -127,7 +142,9 @@ FIXTURE_VARIANT_ADD(basic, stack) {
 
 TEST_F(basic, check_sealed)
 {
-	if (!sysmaps_sealed())
+	bool disabled = sysmaps_disabled();
+
+	if (!disabled && !sysmaps_sealed())
 		SKIP(return, "system mappings are not sealed");
 
 	if (!has_mapping(variant->name, self->maps)) {
@@ -135,8 +152,8 @@ TEST_F(basic, check_sealed)
 			variant->name);
 	}
 
-	EXPECT_EQ(variant->sealed,
-		mapping_is_sealed(variant->name, self->maps));
+	EXPECT_EQ(variant->sealed && !disabled,
+		  mapping_is_sealed(variant->name, self->maps));
 };
 
 static void *find_vdso(struct procmap_fd *procmap, size_t *size)
-- 
2.54.0


