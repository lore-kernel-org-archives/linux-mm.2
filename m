Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93D7FC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 257796B00B0; Mon,  7 Sep 2026 12:53:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208DD6B00B1; Mon,  7 Sep 2026 12:53:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033DA6B00B2; Mon,  7 Sep 2026 12:53:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3E406B00B0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73AFA1A019A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:53:14 +0000 (UTC)
X-FDA: 85187561508.26.2E67372
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9EADE100009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:53:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cCfLfN/w";
	spf=pass (imf05.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799992;
	b=m4AX/jp07/7FnIy48WHsv9F9VXMX82Lgw6fy/WISVuLzZd/rybVw1qy+211bTxIcf1+vOr
	oCNIX1x7O+HSrij/XtQHVX9AX1RJzio1/vRTlz/USVz7eErFrR9DyB7c6LzgiynwmHV1DA
	u3cHzEQ+z+c96cGGktkaN4bPrY06Ik0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXEATw0LCoNw3+DI3xDTgsz8l5QDzPtCPOwXyA9u26Q=;
	b=PFUD/nKRt2tfioIgFZOru0dJtfg7d/zDbCGU/eIoTgIjjn2u9yBdGYA1TM6cfWtoQIHpod
	8DFZjiCNUT8MRvCotGEekPvEmPIyRsjLnQuBi+MUNnw8hnD1S4sqkajHLeZls+EiV4r9zL
	wMhUdVXQIx3xEpsAtjRDbgAADA8B0WQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cCfLfN/w";
	spf=pass (imf05.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-499b2981a7bso40196185e9.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 09:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788799991; x=1789404791; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OXEATw0LCoNw3+DI3xDTgsz8l5QDzPtCPOwXyA9u26Q=;
        b=cCfLfN/wMiqzZU8TBx16XiNrKqQUux6RyCxfH+WPTONDwtZZRY+x1eeJ3hAvKnGyBe
         XqvgxsO3Pp3N3p6NZhLZ71iDwZAWKgGDIpRjroGcCcTXuBJFVVC8gUGLdf4fxPXg/Owp
         cCVsub3N+CDK36vD0naPUg8bkfu/HfcD0naZY2H0zQKzOmHmVZKWI3ERmvbo8DDSPeDQ
         88vWvv2P6FiciyMzu3TMotdz4k4pKkp3V9dLuazNzxVefyVnVCI5P+WoWg87NR7FS0KI
         70MB20VjVENvzcGF4r6E0qltUZa9Wdw4hThNCf0IFKOQLJaBGkcu+oUf3RLpQrn5iUwh
         a04A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788799991; x=1789404791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OXEATw0LCoNw3+DI3xDTgsz8l5QDzPtCPOwXyA9u26Q=;
        b=F84H4BB9SDvMzUJXKgB4rU7jO+huBpHiXoj5DG3bWM49pYFxKbg3Tdq1cNDfs8Ozoc
         qLluRveBJUeccFWnu0y0IWf6swf2mtcfie6ewo22xqgycOr12WSWZfU26cBMzaIDeYsD
         A0IoT6gNCKNgtyPh0LDPiwLMAVgnVXqOWFQIuOT+2ha5W4wKNVpthkm3NLkOTMrmvAPw
         RrZfNWcXlqRJMLIeU9woCC6YD5qSXeUk/4Q+o0p59C/KK4ZZXsqpCj5hnbM4J4zIhUQV
         mYttWlRZKtfz8WnncSgWMgL9Vx1iVFY8g0ScVKuVGehKEVYj47AyvDpCokXyqjqtaYgI
         fRKA==
X-Forwarded-Encrypted: i=1; AKwUvBy5O3KKoZqMySJnjcXhoMJMIHlgxV37Gsn5vZZ4bkbHlp9YdWKZ8if/uDNrbG4/2jhs9gCAGE74QQ==@kvack.org
X-Gm-Message-State: AFuF++lIPwaoxcA47WBUqcMS/Y7nX8dDte2xXSoElDAoPrJIajWuWhKP
	AY4Y9xJ3IgvFUqnGkOs406iVye2ONgg0lopGCVYi3VUMEVt7icwcfR2v
X-Gm-Gg: AYBFou0ny+VxTEUBkdk9eScu2V7Ub0ArlsPWPK/61cCZd31tjI3Xxqgrd+brgxl/M7M
	3Ur98CBaPvNs59kM85FIu8JpYjzQmUIDU6XVGFLfgX100HzE9ape9fAxEZoxH0wvsXEUdGeSXlr
	z9DmhL8hcrOVS9g04DRfwdCe8cbzS8vfHrhd8fO766qLGQiN/pXV1wbJMVHY0+6Ur/Dimhv1ZKT
	APhipnFX/tEqb2CXCULvJtAphhbxOFMgYOYntxJYR43EEkd6/CgeaM0dnRxfZya2ltJhHrfivzG
	r2yDr2Ym79eAuXEfSTdzeMQ2F99FlguT91gC7Q6eEPDD7ppO4m6odtU4Ctf3GE7WWt6/crTKItP
	OmUnt9EfywBR2PlSpUpsNVfX2X6BKbO4ePP7npMq9mz9ccDjsogJQp7+qBldOVriy/nkRL7Wl8l
	avnMDTuSqOa8x7L4iCeoVs5vBfN/6MOSHke8oQnhk0CQhS7GrGQf9Czgu9Xz0y7VyG96jxcn+Lb
	A==
X-Received: by 2002:a05:600c:3485:b0:49c:cee0:e7c1 with SMTP id 5b1f17b1804b1-49cf825c119mr525133835e9.16.1788799991022;
        Mon, 07 Sep 2026 09:53:11 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d03543064sm233022415e9.13.2026.09.07.09.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 09:53:10 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	ljs@kernel.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: [PATCH bpf-next v5 6/7] bpf: Mark linux_binprm->mm as trusted-or-null
Date: Mon,  7 Sep 2026 19:52:19 +0300
Message-ID: <20260907165220.52431-7-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
References: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9EADE100009
X-Stat-Signature: rk8g44pnckgp576iq5e7wuoy8dio6iwt
X-HE-Tag: 1788799992-407291
X-HE-Meta: U2FsdGVkX19Dyri4v74dDPfavKuqWcvVPvFAdPa5i7geT9NM3M3U0Tm4SHv366HoojjPRos/hy/kS51LNLqeahsqGTyh8R5X7yQQ/4xf9As9XvVL78wvtyi6vMm7Q0mgNw60paZ3PgU2t6IgHiZhHuhyN0Vhajv6ij5+0ozPyRqqJBwwi44gMJgtXYGBw8lZiUMlA4+8wxW0W7bhkvlAGD2mmcxE5nuylMkSrGSyMfzChl9oek4TDQm6sHkUL6Md6ccaGPRspY0jNY5BiG2Exq6LmwA7hzVeqvwVhh2pnjFTFI9m0AqvNldouGLh0f5Bku+BP/GIpb1RmX+enqF7zeZhOMEAbNGPpONnIeflspbHmNRCTqXrigUQ4u/GqZn7kh2t52aKC2AoJzRbVl3OGGCTCY55afhMH6vi+9eXPjmtqV+fKB6+H1qCgaEOYDtmuUizckmNjOoyzozoGcYqZJxvU/fzyZToqzFjUzSq65dhwe9oNF7f/jc5RbWOUOG69xjM+DomwKVXJ5/zPp7YsuJu512ZdYSd7HkhfmVtJAlYATCpNEk4Ixvgs2IJEz/cty5AKQjYCKCUZsc55uF+qI8btoJt6PgYTruzmMNfGc1+8njV01M1t1dsnSLBX0TU8t5b6ff0tk4VtLxgaTDBluz6CTHsJnSTnF9RKCHsNKejtKNc09wsyIiXNLNEt+bkTnsK2zH4aE6nvDohnDWAZm8L2E1+25TMnlZ2SadS4iAgof13nnrpb7gEOD4aRw42KihjwLWL4LnZUr+3DRJxQvZJq4QXIY7B5GBmJ5/4XcmlxJUCahbM7nRj1nos03fTD1Rn0L5bZm2p4xuXvoyt+74z0zU5arsI30ru+JkW+cy+IDyXJTfTGmrbi2Bu72rlHaakCw4ZHFpwrWr1xErpI/gikmfTScOeVUNndnMnVoKRRzddnIcgCYFQZonT7xmQtY7FdGk1rv2wo2TZ+Dl
 dSngrBAR
 5uAwVLNkvWysfpAGK2bE+q170AeEz7twtq60hkFue3+T9ZQW7io+GNfmuDk4l8erLI6QoYBwdpmfALLlH7vEG3Xv84HH2p0WI/gh9aY5iG41uY5cQE4bFFljSveoH42kwgz2qWBWnNWZXyZHOpoqcwfSx2JYn9Map8XNHVJMPxmFr46tVcKE5AhXq68/irRhXXzPx6Qf7l0CZ5TiIuf8TSlpEqdZ/U6RBBsBMgoJjlPulbhJLDU48xO5Tv2NbZCnE/n7xWHoqa95xQ+wz51WNarkrXqUP59qWPepejBlu9/QQ1rTz8NAcHKotI1YKh3ZsNc4JoDGHW+f4hPRk91nxTCgMniMY+Qvv6wpbt4Oauk8AzmNV7VbXZEuvKwS1jBxDJVvgkspRZaHkVxbCENWuFhbOMbAcEd12lDjo6fEjWYeUAhh9Itk0kUltfR9U7MbK82BBxyyNsT/+Z1Z/7XcNGMBA87lA+5g5bHwM2tEg93MTWAfXqvvuhGHH9qA7Ze8dWkFTrbBrswoKbjuoP5DA30ck8Yc1it/rbCibHyv5yGb8Lpqds+nJ1v8Ao0BXxmDjHBup
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark linux_binprm->mm as a trusted-or-null nested pointer so BPF programs
can pass it to kfuncs after a NULL check.

The field is either NULL or points to a live mm_struct whenever BPF can
access a linux_binprm. On successful exec, exec_mmap() installs the new
address space before begin_new_exec() clears bprm->mm. The bprm_mm_init()
error path clears the field before mmdrop(), and free_bprm() clears it
before mmput(), as ensured by an earlier patch in this series.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b5186e664aea..6799d9e080fc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6004,6 +6004,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry) {
 	struct inode *d_inode;
 };
 
+BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm) {
+	struct mm_struct *mm;
+};
+
 BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket) {
 	struct sock *sk;
 };
@@ -6058,6 +6062,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
 {
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct));
 
 	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id,
-- 
2.55.0


