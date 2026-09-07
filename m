Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE495C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:00:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B6F6B0096; Mon,  7 Sep 2026 17:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473186B0098; Mon,  7 Sep 2026 17:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362486B0099; Mon,  7 Sep 2026 17:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00EAE6B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:00:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 57414802E3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:00:36 +0000 (UTC)
X-FDA: 85188184872.08.B48C571
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4F5972000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:00:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZI7bvG5u;
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788814834;
	b=m63eDdJYhCJjzwe8oo/F0UhHS1SgL1zBrsLaaAW+4vGUidTyTr+2yoXGGLCmmWlVj4XXYZ
	lRbetB4v9oIRoNl1QD5mr2F0GY7P0NJH2jThjtrV7JbY2RWsW9Y/aUVgZoC6ZTP82WR+3j
	YhHS9OrEGKbQDNXuxDrsFZlirshL3ww=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZI7bvG5u;
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788814834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XRnXHx6VgGnMv74R9wDnVfN6U71gdwk07y3Ib4uyqeg=;
	b=jebllBNZWfVPrFjlXkdZ7bXcJgZqaCLPK0+rEFN1r3DwAiI5nvQikjV/rcHOzkzYB7QyMZ
	8f+nbqv/M2sXsHPqe9VitrjY33/MeIRqQPkO3wlUulARMHFrtsHdKV6dmjJlQDgi2bOVQW
	64uIH7XsKF5p2OKB3jUHSftaR5CQeho=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cda5e048fso87345e9.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 14:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788814833; x=1789419633; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XRnXHx6VgGnMv74R9wDnVfN6U71gdwk07y3Ib4uyqeg=;
        b=ZI7bvG5uk4K+JTw/s7ztBRIwO855XoeChbT8kKgYsD2TxyEFYruDUiEz7AteN8X9O1
         W9DvsPvLzZbHXI0CyZohqd+h0U0/4KNWTfmD+8Djejlz2nAZ8ZTjFyXXLNC6V946SR0L
         cKLZ2+BfSefAT56oc5mCndc8NyDlbBTEJErRvE43eSi1xj2jsuYhYKy9kp+1SPv6x6bw
         /Xrhmecf9T7kD9XcUhYw0CuUwH8CvE4J4LPqS0xJ1VKHQIAZubFunju/If0t6FQchdTn
         WBiwwWLUpTK4+OoCTTQv/6e42a/KldukGNmVCowE2pCm0Xgub0GXXrss8cHQnyeTvePA
         MxTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788814833; x=1789419633;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XRnXHx6VgGnMv74R9wDnVfN6U71gdwk07y3Ib4uyqeg=;
        b=TTzJOOq9KWbgaXGtwUeX9Fahz27PlWcBliH0d8k9hA6LSUf5LG2zPh6BbWsxqD8lGF
         IyR0x++Zka+lrfSzABC/vuv/T85kTsWr18sycb+mAWn6nkKkFICtMl+LN/9F7Tob2s+O
         FTP2mZ5APMWfasavOA/5tbI93JmOpLukbnq/STAuDKFrp8U2x1vPKgkIcLgG4BW8Bxji
         ZFTI+Z2erbdeBtUUblcea0kiLbWg3M/5wM60jCbqBDmBKm+naCUssGiYL0TmbJIAzYIK
         TbfmhMRcVg8Fv7jr7ATFStU9JsMUd3kyGvBBt3YCLrVvghRGONMhZg6O8OHgsjN8kYPw
         O3HA==
X-Forwarded-Encrypted: i=1; AKwUvBzWoHaCVpdlXbolWHYdNs26hvq731ZJILTcNQdH66iaSGMJKqfpU/Dy9DF7tC1KVovmXEKsR79i5w==@kvack.org
X-Gm-Message-State: AFuF++kyGMhI4pbXNNoo57qIZDGrDiXwhtqdiVLNT4e9+bhxm+VLGE8d
	y9AcMeGd1AkHDX9z4d5MzZmBLKa8fJYOlIe5l2jyYGygzFEujrncsMF3n++TUcBu+Q==
X-Gm-Gg: AYBFou11vpdr8Oj50798a1xfWoerDuLhC2YwC7np8CTcU8S/oAorum4XzEHVpk1H3JT
	y2HDez1ab4XxqtzWy/F5XmpoRujiE8uij0s87HvXnaM2ppvt6YKdHqPQC/k0L6x9eJIyX38/OzQ
	CZMGevJpQL03oZ/6HUqdgaw0DL92+XL+iuFAMpp5qJdx3ePZqvZfMIIHvp5jqMZ0lo8LSMSZkWy
	gLj8soY4SqO+pUJTwmpYEspQCOJ5n9JMHFYciPR/EiQHg/XBBVK1QscZJ+vL+8k7xQPmk68CsLe
	Oc9vWPIgXP6TOs0kZV3okg+XU9773MsNaFwuesl24lc163yqbwMxSA8UV/s+AKbV6tifyEEEgd0
	G2m2EkgzOk+KNw0ZIARB1VZIlHS4wGcE+zTCPGyBtd3QAhkeOAyzb+IQ/ijdlVp2wcWnXf78qwy
	4dNMoyWay5Cu5J2PsN7D3KB/hgZOT1NV3UyvIs02lKVF/C/S0B30Mn7uNqzcqlePjTbroNb0mHz
	HHo9sdQHqjEjx3qhjUP/3HVtseyrPaousZH7qlZp43LiI1a
X-Received: by 2002:a05:600d:8495:10b0:48a:623c:8859 with SMTP id 5b1f17b1804b1-49d01dd5cbbmr1672455e9.7.1788814832694;
        Mon, 07 Sep 2026 14:00:32 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:437c:9ac6:4a41:e58b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce831af89sm296356215e9.1.2026.09.07.14.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 14:00:30 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Mon, 07 Sep 2026 23:00:18 +0200
Subject: [PATCH v3 3/3] selinux: require PROCESS__PTRACE for FOLL_FORCE
 introspection
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-selinux-pokemem-v3-3-0bafbaeafe50@google.com>
References: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
In-Reply-To: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
To: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Jeff Xu <jeffxu@google.com>, 
 =?utf-8?q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
 Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788814820; l=2962;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=ADyoAPi4kZgirNh4gOcfqdLiEnc1vIBxWHYLFCTisIA=;
 b=/+BkX6CIIRykdm9LzWh7SeoNJjuZpofKO51F7SP8VrCx38snRk5/Dg7OkyREfcDhgHAdymDNB
 IscJXoiNDc1BcIlIo+7EG1udczgI6vImnw5htcwkQTKyUUdVlbw2zSG
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspam-User: 
X-Stat-Signature: x63ay8jdfexwhtf9szjt8urco6woqoyi
X-Rspamd-Queue-Id: 4F5972000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1788814834-229674
X-HE-Meta: U2FsdGVkX1+5GEZ2ys6RHTtfa+R9PgRqjCqyD3ex6T7qLyXNSNt/dgrhVJ7vvTMTc4fHm5B8Pt1LmZWOWWmIBdrCdp7UVXvHb1xXSCsBdc5n9Sz6Gp4iGGOp/7jsjWBPQDkeLsx8yriyP/rae7bFJgJACuZIMZQoHVY/Y1IeeByIiK4ttbQDsODDTkXDJRu9mXpJi7HLCgxSU9LzX2U8xWwGovfaGhfIeSuFWq+4hfUk368XiQsNHA8SLfrgX8+j7acWfUejwY9oSi4zVPY87SV6MwTievDCBVBdeUXmwnhJgFv1I5VNkeEMUmEkPSjT0JYqc8znlnqv+Q937TUUJhNyN8gqBXPargp8YRCvJ/l9nrXCIIiafMRRPhdUY8PQTBJXBCuFOxpFPTiWlDdyidSuPkobrCCiS+o7hA5MF6qyOx4MEKUstZHb/gFgiCsi00v6NJhHriUxv4JSSTOpyU2Ri6/qK/RvaWQATWxqmZcECmlFdtFtC6xYVQ7lk/J+VMUDOU7OfqxMsMVgVkRZo8NRRnfUee27byQbCd3i8dpXTn2JAja5qhlISXjvMyGFS1rWh4rYDb8DvaRhJcdWEGTfXmE3f0/NMpCIaF9J3/LdBjGml6mzaugnnQBWlNFj+17AzQbuwRwzkkf8CBP9oO4YR9mDkYQzlaUbEkVw+3TjAGb29FNnbu//LbpFrnx2QhBB/sH7gfPKIj/Cy3zuimQjBDq8Z9YdvgAzjo1Hf3bBudZULe6/6kYjqN2Bb/JjSTkguqJky40I+khBkdpMRcC2NSKJjtRB3cdL/dnYGVANa1A9jPuTmgoq0Rqg5TzIkxAGianh9Db+HPanOgTXadp3KwlIMNdZ06srXDHSQcXaHOGi9ypOKKU5+kY5xVx+Tzb2C/FboOnayh/lpgzlW8ajxElM2Mn0jtBM5uFcDge+ZxdZzk1J0mUShhs6si3q1r47xuCGUo0Xxth/EhJ
 RTYutUJb
 V4/Jix94qb7UJlIX1DoAi+GvS0W083ba2C4Ehqnqh1AmqPqhj5KSZ15IpiQkbSgHbgwWCwkY1bCobPmfWacRaI6kv/lwW0T32sCCwNh3z3P7GR7wrJz1N4mnYhiNZZzVXb9yFnoJJty3VpCKCZM8y3+NzjrZEqQ8irTsDNvSmpXT9yoFOUQsx6oJtCdpn4VsZ5AA4lNmRTUDoNH8gzJ9wR4htmfvVFItbPS2e+QzAoJx2SKa62Q2AzZ8V7RcpF9RqwzGaGzpvjWP/cUbAU5bU37qKnhE5bqGlUttaUOAmvQ+ocEhA1iaaW9tsooTWG8rWuHvYdJ6gAWeCx8uaOErCqKq04z/kA9W2JR8Xs6X8kTDlDZl9zrMaIQUm2143exBwqz734bACY/mmNlv4i88mbddpx0Lu/4dRyG9oNMCDO8iO2JaD9atH/fZNynkHQC1oH8Y23hXaznyW/Ca+19IDAiwuE86YkflHedJrBa2QVPiXrC+Y6XShdrbgu/22wsZ16KdAVn0gUmx+EL+wuBWmxrpdlt5ufxvMZHgZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On systems configured with PROC_MEM_FORCE_ALWAYS, ensure that a process can
only create anonymous executable memory via /proc/self/mem if it has
PROCESS__PTRACE (like when using /proc/$pid/mem of another process).

This closes a hole in code integrity enforcement that Project Zero has used
in a remote Android exploit chain:
It was possible to use a memory corruption bug in a service without
EXECMEM/EXECMOD/PTRACE permission to overwrite executable code via
/proc/self/mem, which made it possible to load and run shellcode containing
a kernel exploit.

Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Jann Horn <jannh@google.com>
---
 security/selinux/hooks.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 18dd28b2bb13..45ead18c8f01 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2157,6 +2157,36 @@ static int selinux_ptrace_traceme(struct task_struct *parent)
 			    SECCLASS_PROCESS, PROCESS__PTRACE, NULL);
 }
 
+/**
+ * selinux_mem_foll_force() - Determine whether /proc/$pid/mem can use FOLL_FORCE
+ * @subject: credentials using which /proc/$pid/mem was opened
+ * @opened_by_owner: whether checks on open() were bypassed because the opener
+ *                   has the same MM as the target
+ *
+ * Decide whether it should be possible to read non-readable VMAs and write
+ * non-writable VMAs via /proc/self/mem.
+ * The @opened_by_owner case only applies to systems configured with
+ * PROC_MEM_FORCE_ALWAYS, and only happens on accesses that are not visible to
+ * selinux_ptrace_access_check() because of the introspection exceptions in
+ * may_access_mm() and __ptrace_may_access().
+ *
+ * This allows a process to overwrite read-only code in its own address space.
+ *
+ * Creating an audit record on denial doesn't make sense here, since we can't
+ * tell whether FOLL_FORCE matters for the accessed VMAs.
+ */
+static int selinux_mem_foll_force(const struct cred *subject, bool opened_by_owner)
+{
+	struct av_decision avd;
+	u32 sid;
+
+	if (!opened_by_owner)
+		return 0;
+	sid = cred_sid(subject);
+
+	return avc_has_perm_noaudit(sid, sid, SECCLASS_PROCESS, PROCESS__PTRACE, 0, &avd);
+}
+
 static int selinux_capget(const struct task_struct *target, kernel_cap_t *effective,
 			  kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
@@ -7558,6 +7588,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 
 	LSM_HOOK_INIT(ptrace_access_check, selinux_ptrace_access_check),
 	LSM_HOOK_INIT(ptrace_traceme, selinux_ptrace_traceme),
+	LSM_HOOK_INIT(mem_foll_force, selinux_mem_foll_force),
 	LSM_HOOK_INIT(capget, selinux_capget),
 	LSM_HOOK_INIT(capset, selinux_capset),
 	LSM_HOOK_INIT(capable, selinux_capable),

-- 
2.55.0.1003.g10538fe699-goog


