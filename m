Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C83A606FCC7
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=jq3Sr2Hc
Received: by kanga.kvack.org (Postfix)
	id 4E2E96B05C8; Tue,  3 Nov 2026 10:18:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BBDC6B05C9; Tue,  3 Nov 2026 10:18:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1546B05CA; Tue,  3 Nov 2026 10:18:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4386B05C8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:18:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A34E2A043A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:18:41 +0000 (UTC)
X-FDA: 85394164842.17.ECD54C8
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id B127710000F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:18:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=jq3Sr2Hc;
	spf=pass (imf05.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.178 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793719119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wslCY1XSUoR3v4P9N4tk1erDlQSR29c2WrcvV4W33z8=;
	b=nMQQEqVik9TasAnjPxnJNsPomI35fBXbb/4jE3dA5tpMlm20E8jM0nV3eZMGny9Y/HSUTo
	qikCNu5z6tXn/Eq/+Nv+EnqHY1sMCN7ZJI2SkUr9Myt4p05IP2uCLWhVTQfhCsF7I9mKEE
	ZTEdIDq0nLCu+rpbN/ayug04ZM1SLiQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793719119;
	b=lo81iLbRro05XfTF6sIpvMFVhempJQSRZe+BYL7P4dLngnM28aduBxOt+VrXhonibjBDjd
	GRsnSgcP0nS5aoC6TaqXy4omPUjvYz9tYuGwLM9ZQUHlxsARJX28emun+gJQOP22IliLzb
	2/K2flF+4MQzZ/UhZ11xWNYRmry1f7c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=jq3Sr2Hc;
	spf=pass (imf05.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.178 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8a070781f63so1783682b3a.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 07:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793719118; x=1794323918; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=wslCY1XSUoR3v4P9N4tk1erDlQSR29c2WrcvV4W33z8=;
        b=jq3Sr2HclyNXlGvGRCzODP4h78vABcYgjniGLwEchEk4+MynPb92IbTVDPH+4AUid2
         XpbcU0Ssy0zBX5TTNtsU9M1vHxmSNTS+ErdCf9dhFTJmokc4+vn/AlRElyeeB2hK07Ca
         JFKl2t2x4UAI0yRHoR9Bf+OGT2mPJ006fAnek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793719118; x=1794323918;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wslCY1XSUoR3v4P9N4tk1erDlQSR29c2WrcvV4W33z8=;
        b=XisyOBJQ70xQkwHwbdxvJxT4jYPQLi0Toi0AUApvxEpUak7NPr5TRXIdgmX3jA3RyU
         9uyuyYH0DxW0MDlomNeDjqENlkSLQQ9N9JmXTxGJ5AaKWQaaHBthoqLrk03MZcCMB6hW
         V2oi5uGbwcYUz5q7sP4X5QioSIqQ/Lhb/WB7TcBkHXVQi689Afnu1fKFj9/6jOVpvUOS
         J+qLDONnLd6uJa/As4E/kJeNWQ5KDK74LcZsRFeZH5X5iRpZlvMapd9k8n6acpXVN7Ed
         v5LVeqVJZIHLuYL8Upd0GivhUQIC7JHRWZbIazo4uCAYwqy0DOYQgc3sOHOiSRWHzYbn
         fnwA==
X-Forwarded-Encrypted: i=1; AKwUvBzsKWKMtdfPTKYENjwuBT1i0JmCrJqLDxBMI+xSDaNIGUhRJUuN4jFYpQTlBSg8eotp8/47xUbtXw==@kvack.org
X-Gm-Message-State: APuU4Z+jtJpvK8/p3btVhj4bM1ZDpfJSBt6uC/mV5cUvHNDvDIHvKdEU
	DSHmmy/37HUqZEpFR50+rOhN2Kwewi1fkcyPJIvlBrD0NkrBMXrMM4lKsAYMmYr9HLc=
X-Gm-Gg: AYBFou0PHHZaSJ0ptatOADWDKcXjotpUYwiE2gxWM4dT3SF52VFQxjuKtUkox0L72QR
	WVo9fz87/91nNybuGp0mp9Ibffs2V9yLm8z6g5T7yqblwFyfy9aYuIWu/2yxH9eQP1luBVjSkn4
	9NrE8vW+n0lba5J1d8HQQ67K/kvaPRuWQWMgi3+zuMQwgVXV7tRpW2K8lxyUsnpMBv+h88lAVbD
	fAbGe9f/R5NM9eRWyj+G1jzyz6Ozex3/4MqwOscbYwYEI3bTmco1qXVyzx492nzjBOnw6M0KDSY
	+px3edQwE94cYegm3cEBez4vOrbRMIJkX5FDBGNgq5yNLuuWVTvkSmQrDX2CHuL6Ze3WiU+PTFj
	bFzo+DqcllM3W6OIS1JV/MTQnqE/atN0RiIwXXJPxKkwuq7mhnDZQm82cVd1Ru38d9QZxj9joHp
	rAz81sDPjuNYxcEpZdSToohDcwrYT+oqNDDEnqYg0c1eXDly7KoSJOYYTht7LTM7bvZ0fcrWYvI
	hpskwQwqaBMBRgrBqyt+M9QK/jCu0Otl+iRCpwNKpunWD59koZqbmUYbRDCRYewrJT7Wx2U1tNS
	o7Mj7raVuX4lljUQPZNnl23OXk1+EQcpChOQT/T8tTcUoWq2GKRr3z4nOTNxHo6q07rHIqJag4h
	OdNc+hK4tA6lAZBtvD/85Fp9eciz4E3sV53hOjIdaApV7AeV38xW8wLzdepkyMksQzQPaukQxNQ
	jxgmvrNpKIo3sbo5KK3w==
X-Received: by 2002:a05:6a20:914a:b0:3dd:a009:3182 with SMTP id adf61e73a8af0-3e928e2909amr12529216637.42.1793719118513;
        Tue, 03 Nov 2026 07:18:38 -0800 (PST)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb362ab313sm1592131a12.0.2026.11.03.07.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 07:18:35 -0800 (PST)
Date: Tue, 3 Nov 2026 23:18:33 +0800
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
Subject: [PATCH v2 5/8] uprobes/x86: Leave sealed trampolines in place on
 optimisation failure
Message-ID: <eafd3da2cd2c3e2c4d137a46f50351dc6290c5ea.1793718940.git.chris@chrisdown.name>
References: <cover.1793718940.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793718940.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Stat-Signature: dp4qx948xxcubrp4pc688mwd3jbgxyzg
X-Rspamd-Queue-Id: B127710000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793719119-418810
X-HE-Meta: U2FsdGVkX18w4UQP62tBhHTRdJK+ZprCbcZgfb7G+CiI5d97pKGgSolI0yC9H6qisC+zZPJUwv2L8ziPc7zIKHikgXxw+w22RDWR/aG3WWnIxjlDrox41fyCEwZvrB1x2Gs7yVODBGTxRWYM7dPnCzA3BTbpXkfL61qPeLo/yuIos9T7tHG8YOF2pFP7SJM6Ewby/C7veqxgMdF+7A6T6FjwnZjip/VEjdweSGlvGmCJy75h7UJXcU3vtmuTqj99MoukPu+TLRGR/o+v4u1nehkbqM2fwJrGmBqsCYVJr+iP/q/HsqYziYbzblMoOvtptCoocpb75i5AA3nXw3+qtv58g4IKMajJAN/8q2Nor+1lCzkI7wym/eHvtUgIJ6tp3EXeO717bI4xXorYi0P40y/8GCOu2AFg0YuYGxifMTstT+A608kbN+4/Hp7/UuPPGRfVOfBZ9Z3vrKKkB6G2YfTY3TNo/xO4eU5q1FuodrHqciDyQYiEjJ85uQxo9uL8JhQpNqNmxTyoVPZI03CFItIWnz/t9P9zvdWYjTuYMMq8L3oRoxEHedMfZnNvWK3b9Gvxw6tybBPj+0th7+GRcy/GBb1VY5fzUb8yc1rowrj0G/rkcEF7H54JMlrqYYIcID5JY3RrpQ1QIi1bo+LMX/YrSrlIw29/cdsOdyzT8lsEHHDqURia5h2eKOhz4m/Ixg4TbTOVU/9e8m1RCXUJgSIIuWd61Xyruz1cC10E5kFryCQ1mnGcGq8BAp1YFHsz3gTWCHrgPHfWe32wqLdbYaxbVcLFE0CYtOfpAA14akbemgQLO3nmgIz5vl+/IRXFZGKnHmRNA2RJFTqkKuaacsgvux1f4RLfkm78QGJiH+tTBqSrywza5D/PRxbbey1zSblS9KWKoHpGO40bYK8TzPsjtkILrMt7ZEhHky2kRKlovlZtQ4dvo8I1sEqncnI/vJ8OZEgdJcl7N4W/CmD
 LlUA+mb7
 iYdcvglsk7C5qngctmSmHd2itFwi4btf3R+3xugnzdZzLUgDzslaJqnknLDbYhpDEaMK0KeHvuDV2WzLIeYQIYeyr0fhWRYJ5x2Dh1y/2xwl05+2GGBviWMsm8JC1gmWU4HRBO+6I7gi8ezOnTtxGMK4h4LmaPl6lYz24sApD5en8fBY6U5nidcss/RZDTBAUwXdxSOZ0eQVB8qwpZGqRiINJPjhvMHKYaT9W0VrBaequ5ELQEbFPLttOu3XXwXMOoxA8ZYsxw1RFfYn9ZL+XZA8RZvxtsqzqJOvH3eo9mJxh8M32NWkkP5UCK23784IG93GLBrPg0vTiV4z8HbiGsu1jwsnYqv168m+vPexvpXKFG4/oGqxpMhcgOmI4IYSaRc1F2h8uhGPr7PvTKczMCSiB1AjPyr2QCgQd6ZstPtNECtLfmOo8ajn0bU1F9iXSGXT+4TZUbqyp5Dp0ejh6NEhtiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If swbp_optimize() fails, __arch_uprobe_optimize() unmaps the
trampoline it has just created. The next patch seals all special
mappings when CONFIG_MSEAL_SYSTEM_MAPPINGS is enabled, which includes
uprobe trampolines, and then this do_munmap() would fail with -EPERM
and warn a second time.

Nothing is really leaked if we leave the trampoline mapped in that
case, since get_uprobe_trampoline() reuses any existing trampoline
which is in reach of the probe. So let's just leave it in place when
it's sealed.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 arch/x86/kernel/uprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 0f60c0d076b6..fb895bfc09e0 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -1183,7 +1183,7 @@ static int __arch_uprobe_optimize(struct arch_uprobe *auprobe, struct mm_struct
 	if (IS_ERR(tramp))
 		return PTR_ERR(tramp);
 	ret = swbp_optimize(auprobe, vma, vaddr, tramp->vm_start);
-	if (WARN_ON_ONCE(ret) && new_mapping)
+	if (WARN_ON_ONCE(ret) && new_mapping && !vma_test(tramp, VMA_SEALED_BIT))
 		WARN_ON_ONCE(do_munmap(mm, tramp->vm_start, PAGE_SIZE, NULL));
 	return ret;
 }
-- 
2.54.0


