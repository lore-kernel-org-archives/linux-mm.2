Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB2C2C44506
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 04:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8208F6B0093; Sun, 12 Jul 2026 00:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AA566B0095; Sun, 12 Jul 2026 00:08:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671B46B0096; Sun, 12 Jul 2026 00:08:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4204B6B0093
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 00:08:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C5BDD1A087D
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:08:54 +0000 (UTC)
X-FDA: 84978793788.08.B2B58E6
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id EBB9740005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:08:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gnPl7OUx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783829332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1vSs3PpxD7fzzGCyEVeEQofuGfZwATqltGOSkAKOV+Y=;
	b=z4iu0Sth7QCg0IL3/VnsxJmp3isEFDdXPmfe4lhXeEefiq3TXurFxRm1mxW6p45nCMjFr3
	A8ddf2DND03LyfbFUQGidxGoW2IXnf9JGOT9diF487rtzTyy18vgcohejFuueU5LSIC1Ft
	fYIUh1NA8z9ocpLUFKfpuCECB7c3m/M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gnPl7OUx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783829332;
	b=BngyZVd8bu2jb+Q4F0aa8+UntkOgDwoLqVOB1LvJOhsxq0ZCSxqOSPJi/82rtXZ8UgTNth
	CmpeRfbgfvpYNNO7Ba054bTck4u4Zc0lpJrBur0XF0Esb14zubYm2D3hzEBWtwE/hRZ+vW
	9pDF5mCKtsiqbd+6aV5OMnGEhBGZwXw=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3811e59df58so1363772a91.1
        for <linux-mm@kvack.org>; Sat, 11 Jul 2026 21:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783829332; x=1784434132; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1vSs3PpxD7fzzGCyEVeEQofuGfZwATqltGOSkAKOV+Y=;
        b=gnPl7OUxSfKqb4mupkIg7J+x2WnyKEBE/nmLipCAfjnUkizGnEMyjw9DPF/jd/ppeW
         EhxrKnFQVflaYBkQnvEAWbEKFYngwP8otWZfdbTNiEtk6RQN/HC5FthnW+U3sHNmCqMX
         mlRhh6mOgnMVVKmpISxwoaKuNSf5Ih0lBWVlN3ysHl5zWsHKnISipltcZhwaG/jpjVt4
         dLuJCnqMyMl5haGaxDkPyaLKJn8NfnUCDE4LT2LuI5WDa/2yCceGL4Vgdk4JLWCwCzfq
         B3NQk65kz5c5ak3E1A/+jkK1zetkXjXnO93fJEWvfWGZ4svMJ1j8itQnzOtKI5SRd3o9
         K7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783829332; x=1784434132;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1vSs3PpxD7fzzGCyEVeEQofuGfZwATqltGOSkAKOV+Y=;
        b=JqlCLDPM7kkM9ahYBBhTmvz0JnsFGROaEnuJTSgsk17uYPD/E+Pra1lt7dUYS5kFDb
         7vdu5QEYW0TUWDaBeBhaCOmxJyfcZjMd/veoj8j+ugpqVVE2UNfkr3Sq5S3r3XmtARwE
         RODRETfTHcFnECKvQfNBfYWOvzNtm1tgIfFDuBt1SCAbyVA5SgzChLODBl2LgdIFP6bu
         mlp2WxEO2jO+/hxwB0jwzYB7zJuJ909MzI5xJa0KW0Zgrct1s0XL74lHNGBNaUvMQpaJ
         ldsXUat5bSVq1JiYgQTSPZxubEA/hxf6xiQ2XLrCx9xE1a7nyinYo+6KgDTACrqVx78t
         WF9g==
X-Forwarded-Encrypted: i=1; AHgh+RobRaWBrPfeZAE/kchlKwcd102saVwYZ6HEDVtJM9dN85G/eZiWrmqqa2ukrZvDtpLuMCbrgvxCLw==@kvack.org
X-Gm-Message-State: AOJu0YwG9Mj0DPyULqGFTN6VgGWE9JL7ScvRYknJpelIcwxlxSotFw5V
	CNw1paWW+pI85HHOWoNu+oJip66VgeaTCeonofWgdMgWKIURUSvOR2lw
X-Gm-Gg: AfdE7cmdlfL4eQriS32lc/mmMsY5WXaj+NHIzhRiocFMXUTqCPZ+eSJqjTy5Mnpsvuj
	u3fJed2cO5kJa+VjCJe964oxVujIoz3SRWVmtzh0V6WBy+7XpxDhzzL3ZmVMw0fLahs3cZMhEbb
	XZD0PziRJu0Vb1w/NPhvbOrTOT6IRLDGuT6eDaoAa8xLU09RCyWMTSnO6EvmdC2y0KnPr7xf4ap
	e+L5Fo+tNfx64CcA4Js64Je0fsG2fkmXGWnlH1OwFZ5AToyYAUzf5JvZiwsKRzdsQmTYhrme7Mx
	JQ2lj1sCnPIplKRjVYrWVz/ubihc5bLSyQqnVHiOtsVf0mFEDzXkZcIw0L2T2739zLGwmzLCho1
	x0crlKg3p5dSplxV2WgBAbZTL7Y2S9QrhYWwkrg7coR5zfGDcyh5kwV2Q42K3bqQvJXgM08W2fv
	hjfF0Upb53RLg9Gx5Y/Asl1o5Er2U=
X-Received: by 2002:a17:90a:e7c4:b0:38d:eaec:4396 with SMTP id 98e67ed59e1d1-38deaec5594mr631416a91.11.1783829331759;
        Sat, 11 Jul 2026 21:08:51 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174839f89sm56808928eec.10.2026.07.11.21.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 21:08:51 -0700 (PDT)
From: Farid Zakaria <farid.m.zakaria@gmail.com>
Date: Sat, 11 Jul 2026 21:08:14 -0700
Subject: [PATCH v2 1/5] exec: stash a bpf-selected interpreter in struct
 linux_binprm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-binfmt-misc-bpf-v2-v2-1-d6591ceaf207@gmail.com>
References: <20260711-binfmt-misc-bpf-v2-v2-0-d6591ceaf207@gmail.com>
In-Reply-To: <20260711-binfmt-misc-bpf-v2-v2-0-d6591ceaf207@gmail.com>
To: Christian Brauner <brauner@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Shuah Khan <shuah@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, Jann Horn <jannh@google.com>, 
 John Ericson <mail@johnericson.me>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EBB9740005
X-Stat-Signature: 5jddpx9eyp7hymowsp6up8ca5byfayks
X-Rspam-User: 
X-HE-Tag: 1783829332-633929
X-HE-Meta: U2FsdGVkX18FxT0xr0KDtQpDJJk3FX8MCVCsMPlJ2tOukgKhdaa7LtrnKH9lg6V2zetIj0Smz3vqD852nGtZcjVn3ERtOoBhom/Y8AjCqK7Yn616M24N2W/1UUe1arjpQPrTjfSY2AzgvB5cPuLWu1IKOToU3UBgmk5b5aYnNzU5oa7patBtJVu+8jw55zl9vWHROXd15K7BAZrd63EfaBM/cgEZtExwaFpAV53qay+gclF1/jPElDIC6V19JFG2Y4w9NK3T3wsdY923JrvLoAzwDe9B2TzsGmqZ2AvNRQkqr9edd/CYVP5Q0FyNs9DPVDrNCnXGSc8XXoEwMWK/8wmxMDp0h7wGSqLQcLV2GmR+utipb6lLrcSQbgwl/JgwWcMX29sOavev1YSyvwF0m+Acq6qUCRoZ52DIjwCcHSp2vxjWOk6UBPqkMFYZSWrwXYocf+N/VVReMCOkFn4spn6TznYf1Ae1sqIykCce0E8hSnzViwGsOuZh9XtnDysWIXMG5tTnYeBiRk5GeueXcnSHDziLJEo6vZ0h9oxUzOyVtZ5TVo+5hda3D0qW4tcQywwj5eYVhiEWcplodkvwQNMCMEPQKq2M5R8rTu7ney6smr8UgWJ82KVz1UyVrtN3JtlONt3G7s8qlYpolvBN3ecQWaXOTCAqL2UzCpyKAKyK8aWvbkJd+NuVntHAL/+DDvHgdwZwQWWuE7Te+s/nV0IdarIGKR6iQwLVO4SK6d1rPZScIeAs+guTMbjm0DcD54GR5nDsEmUNQP60WciXR8GKWaft/XIIWPZ7G1DLO0Iqugu8mrGcdEuNcovoH0aOEPI0298QDyLXnAvVLr9NdhrIFx3yKwH3RE7mqqXEpK5ySPFl8d9hVPVW44/mm+/fxeNIwDuDZaya836tSwWhM05dr3qn/umxjjWLdgNiTgjbYupXSdga08wwHsbjyvdpf5inV+90mH9cZxlGPOG
 971TRTa8
 5NQaHl3YGo998T+uB9sVpivsUqb6UiPC8MejGPexC8wYRJ5UegpHmw4R9nTVGeJLNhbbBAhuDi2SY8/cN/WuQHrZ0q5nQixBUqvejjNR3Icm5/3EuOHIQCdvjFjWNODd8GRvgkDEgUxOV1NZOZ2GfbnvjrXU0x0hJKkQrPKrTl8fFxZjxN/zlGxi1S30HBOWDTzI/OxCm6mYeRNP4SM7LRk0eoWuXQnrPQve+pjKh0zoNmzAArdDhPKb7Az+xJFzaZ/qmqM22NFLkw8JX4xzOFQGECP71U6sl6+2lpXK9r5ra1H3HdcSt2KmmJD2T4rpay5FNa7drrXRwrVTJpy8sIqAAnnVyMhjDA4txMjNJr3gcBY73zLeiqe/tfdjdM1/ycdxBn9GhNxdl6bWHVF8uLy7fkmazykoVEnabZmd75ucf/AsnSAdoai02taeAsNdmXFt1J87T/LZujH8hRPd2+JaedUHlyHalkrq62QHdU3kN71iLWF33csJ0pbg1bBJ2Xkgh9NQOUlu6D5c+D855HqyT5BYY2gFSUOaHzKTdkxEs4Ds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Christian Brauner <brauner@kernel.org>

The upcoming bpf-backed binfmt_misc handlers select the interpreter for
a binary programmatically at exec time. The selection runs before
load_misc_binary() has copied the binary path from bprm->interp into
the argument vector, so the selecting program cannot go through
bprm_change_interp() directly without clobbering argv[1].

Stage the selected path in the bprm instead. The bprm is exclusively
owned by the task doing the exec so no synchronization is needed. The
consumer frees and clears the field once the exec attempt that set it
is finished; free_bprm() covers all error paths.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c               | 1 +
 include/linux/binfmts.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index b92fe7db1..7c9e28f54 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1418,6 +1418,7 @@ static void free_bprm(struct linux_binprm *bprm)
 	/* If a binfmt changed the interp, free it. */
 	if (bprm->interp != bprm->filename)
 		kfree(bprm->interp);
+	kfree(bprm->bpf_interp);
 	kfree(bprm->fdpath);
 	kfree(bprm);
 }
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 7e7333b7b..1dbec6905 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -65,6 +65,7 @@ struct linux_binprm {
 				   of the time same as filename, but could be
 				   different for binfmt_{misc,script} */
 	const char *fdpath;	/* generated filename for execveat */
+	const char *bpf_interp;	/* interpreter selected by a bpf handler */
 	unsigned interp_flags;
 	int execfd;		/* File descriptor of the executable */
 	unsigned long exec;

-- 
2.51.2


