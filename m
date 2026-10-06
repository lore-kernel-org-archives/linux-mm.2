Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06DA8CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 22:14:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71A16B0088; Tue,  6 Oct 2026 18:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22E76B008C; Tue,  6 Oct 2026 18:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11036B0092; Tue,  6 Oct 2026 18:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8F86B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:14:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D79C616037B
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 22:14:50 +0000 (UTC)
X-FDA: 85293607140.16.031FAD8
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 29A4C40008
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 22:14:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b=HLXI+B9s;
	spf=pass (imf11.hostedemail.com: domain of kylebot@openai.com designates 209.85.161.42 as permitted sender) smtp.mailfrom=kylebot@openai.com;
	dmarc=pass (policy=reject) header.from=openai.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791324889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=asZCHctIeQVz0B1gy7RhxULncl4dgzZFWQT5KkoIqI8=;
	b=5wBAaDwAZ62xEvZ4H+nLinZyr9+QsjebGDEvsALJg/x8uPGlSq82CP79U69RNB5DxrK2j1
	6Go6duEEWR2SEYqHDk3xAwx4c8EssJ741e9OMhDcK1DkDsqLPoJnT7edas2zbte+J6yJVs
	dSLTmJy52wsw+B41lFD0T20MPm0/ng0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791324889;
	b=gQ/dNoqYuVEW7D0Kl3PWoYrZPc6y17qXJwK21Waek9V480Wo6R7VOzft4lVi043tDGmPuW
	/THSZ7SwA/XLvw71TN7u7ZTW/JHZqpflyiU+vG+QSwC5l6DbkGROTk8Zqv4HLdEc1g61op
	BCPJZbu2FNCBhOxNC0O9SiZq4RjE894=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b=HLXI+B9s;
	spf=pass (imf11.hostedemail.com: domain of kylebot@openai.com designates 209.85.161.42 as permitted sender) smtp.mailfrom=kylebot@openai.com;
	dmarc=pass (policy=reject) header.from=openai.com
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-6c1983dfaffso3012922eaf.2
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 15:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1791324888; x=1791929688; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=asZCHctIeQVz0B1gy7RhxULncl4dgzZFWQT5KkoIqI8=;
        b=HLXI+B9saD/Cs0hHHcTRpZxSZSI4j3/LesSNRqdDtCBoHwQCZqyB5W9AfOjpE4DKnM
         CNhvzH+FpD3DJQEV+VBOr7IkX86f4osR/fj3hzMfBDUZKh7V/sfgB/M1ZjYhvS9axspp
         QSvUBDesrGa1GE8c5M8ibJH/maMkgZ0zUZJ/o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791324888; x=1791929688;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=asZCHctIeQVz0B1gy7RhxULncl4dgzZFWQT5KkoIqI8=;
        b=UtqX33haaerovJnGEjEvjexoMKdVO4utyUBWBtmxKQSiz3DGjo12sPlXceo7b9h4cj
         3QoNjCNNGWKJ0d5uIqqxJ2gQn2OdnS5naBS52Kz4mYIQA6Pnj7PAFu4GphTnZX35h4oa
         /LDO7sEEDo+Qn1uatZarkHmI/jyOcDnDo+LKv3CYNuq/2JMjiZhZTeNQ5XH1ZQlIgb6h
         IBEG854S1I2pcVMnGQ69d55I9EH1Z7iqQeQLBn8TXGY75j+46ZX3IOhO45/hJBDINmrF
         Wdn2zlYNCJwjB6yNCF8rUQ8tT7hgKriYPq62Bp+s7HTMNqA6v19OYyjHxTRwoLs2b8y5
         v19Q==
X-Gm-Message-State: AFuF++na/NKxawypRBk4fDnvkGLwnLa5569Qui9r0L1RmQtHUK3WZDqF
	BkiK4C0W8Wouu7AeTVh+YmNYfDG3urEOrN2J0AInre9e2q+RWLataBOylw/2QvKjuycelp4dZd1
	y3rimkO8=
X-Gm-Gg: AYBFou1hj2A4RO3vyzBtHRjCWT7+qQAeUGZR9KTrJf/Gx9ur/55y9sNSTFKivr+xf1/
	YO+kg5liehPzLjocywlKuU4306MYSgL6B+RFF6ff+yD0Vww2F7v4l16s513ACF9qVdvwr3YMGgs
	i6IBNCmmDziAOxtZGGTbsnV/nLiN4CFEy/EP5EnlumjrTvobJcPaR4zXCyz2J6F4eeS8Ub49YfX
	JyOcZofNhUe7rpPrYk6Ccas2WuG+2DyJ8qNpbINQsAbnlzUDTl6cpBwLItkS0voVfk9Ye/AgK65
	fDtzgSS6mN5C9Dgg270UUbxLyurK7ZE/Uq3bxYcxpGp6oFBvypxlQX8wmNTe6lQZM9DS5D8sHAp
	NFfyo9C9So5Z17HmEMgx0X49lfyEJR2fL8Acpdue8sw9edXCtXzcA8S28eG2Fk62hxg3KI8gcku
	4LbNVyD+vk/WRvE3WOMo/h2A6nolRM+E8f5XYr4Giv7Pb+LhzfSYsDvnkViZInjX00lxTUlsNPJ
	rckiNLqY05nwyQ1xM2hSco62UyKW+AVEWZfdiV3zw5TvPSW8WkYl3QoKafTO5Z6d226QlZLYik=
X-Received: by 2002:a4a:edcd:0:b0:6ca:4a52:798d with SMTP id 006d021491bc7-6e7a65da2e2mr541644eaf.28.1791324888130;
        Tue, 06 Oct 2026 15:14:48 -0700 (PDT)
Received: from com-75606.corp.openai.org ([199.47.143.7])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6e7947969bfsm660861eaf.13.2026.10.06.15.14.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 06 Oct 2026 15:14:47 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kees@kernel.org,
	outbounddisclosures@openai.com,
	Kyle Zeng <kylebot@openai.com>
Subject: [PATCH] exec: serialize argument stack bounds checks with relocation
Date: Tue,  6 Oct 2026 15:14:44 -0700
Message-ID: <20261006221444.35641-1-kylebot@openai.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 29A4C40008
X-Rspam-User: 
X-Stat-Signature: qnxwhw45rh9wr1ob47rtbzxfp4s4m3q4
X-HE-Tag: 1791324889-363994
X-HE-Meta: U2FsdGVkX195eiboFuiQv5q3+V1K62UMe12XXZqs8j3drwKukHpLy/SUNvWmNkys3evn9SvZ9ODh9AU0736sx2ZNmgcgE8hMSO3zUrIBSaEVc41KpxNpfa8MBS73EvlgH+0FllqYviOr9sIPcNco3Yqq7A4qpOl8z+gSB6YM2P0N+QX8sMXm7o2dqwYp6H9jmyRDnTDWofgUiLpVfXJS1pLYGO0/+33qVEU8wwp74zH91GD+bwiPm9rwTylX+WLQyxFC+mmW3M0kotFkbDsePdyW2FPmAhJC0gDPEX437k0fpcI1rqs4+d7TYbPIlCZOFp+wbT13RC3smAN46zu8su5A9T8HltSFQL7planalig7E4DY+PfOPP2DQAIqXLm6+SA64isHnLn5fxbFlC8l2F5DXlILNgtbKjZAppLZ+jw6TGn/MGAIViSTDHwedSOCDTy8yrUkyuM4NZPo4Y/TrbbMdG+1J+s71jR0cTeJ7EeUDrG4ktsCFPOHfqfsuO81YO6bTtiV3KqbaODyuvSW+pQwQWxH6La9rhCThZ3beN+TgcpQun5DYQ/dJoixRYGwnm7cUefZhP5KPlmZCMKmd99UwrITe6IKgsE76OL49lwIyNteWifYlj6uI9AYchG9NjwjwEprrn532q0h1Oz6SMn7iYLCcSqjFzBS8FUgPZSmxJ0e5yM0rmhRVIGMK+6+G2F8DBbo3rq+X2LyvGOwUvrKv9wXSCzsd6zi3fy9NTiRzSapxBRBGaj7aGVCS8zn5XHQ548EsU/oLNSKnd6jUxQ6X8TsI3pz2hKdjN2Dcs97258gmoG6LFWwAxc6rIgZlT9s21kV22oS0h3RglIxY5A3eZcSm4zzWivZNWAbwkcO9bNxYxfT+ATRIiMaV20XXNN18gZBJuqacFuqPrM4C+rR/3aft14BCwdrK5hmovs6Y2yVSh/wFfFTJUU1QWc35OgHirx6xqfgJ0Wi9S9
 eUy8Nfvo
 5bVYTNarYoy3GExN298Ai6rMwxqldPf7QB3FJvbugaAkr9n8KaAN/s+Yb9GGf0JGkB8iIT2+ardc3In2IOzsZarruUb+/A9QHE2px4neT8Bfzhwxpb700sDibl0ob51QvHlWjfRH9Iy8gEGvMUERc0fDi07AAf1RMlS9OJYyQ2cW8YvlTUFdpBeRQWsYNm7Z9AlZ9aE32tOi5kp/Pe5HNDBk58gFFcpFCIOg5z1T4H7brCD08OqIZsx5/IqptvUw92mGAKf4Z9k8XOk4ajyjFwE+2bhgwi+aC8ivTZ5X1frGwd2/E7LutGoXXFPeP0nq32GKC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

setup_new_exec() drops the exec locks before setup_arg_pages(). At that
point a ptrace-authorized task can reach the new mm through /proc/pid/mem
and expand its temporary stack.

setup_arg_pages() validates the size and computes stack_shift before
taking the mmap write lock. If remote stack expansion wins that lock in
between, relocate_vma_down() instead uses the enlarged VMA. On a
native-to-compat exec this can move the stack below mmap_min_addr,
including to address zero. A still larger expansion can also underflow
the new start and hit the relocation BUG_ON().

Acquire the mmap write lock before inspecting the VMA bounds in either
stack-growth direction. Keep the existing locked relocation and send
both size-check failures through out_unlock. The size check and the
range passed to relocation now describe the same VMA.

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
 fs/exec.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 819643408e6d..1ab09c5ebdda 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -617,6 +617,13 @@ int setup_arg_pages(struct linux_binprm *bprm,
 	struct mmu_gather tlb;
 	struct vma_iterator vmi;
 
+	/*
+	 * The temporary stack can be expanded by a remote memory access.
+	 * Hold the mmap_lock from the bounds checks through the relocation.
+	 */
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
+
 #ifdef CONFIG_STACK_GROWSUP
 	/* Limit stack size */
 	stack_base = bprm->rlim_stack.rlim_max;
@@ -628,8 +635,10 @@ int setup_arg_pages(struct linux_binprm *bprm,
 		stack_base += (STACK_RND_MASK << PAGE_SHIFT);
 
 	/* Make sure we didn't let the argument array grow too large. */
-	if (vma->vm_end - vma->vm_start > stack_base)
-		return -ENOMEM;
+	if (vma->vm_end - vma->vm_start > stack_base) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
 
 	stack_base = PAGE_ALIGN(stack_top - stack_base);
 
@@ -641,8 +650,10 @@ int setup_arg_pages(struct linux_binprm *bprm,
 	stack_top = PAGE_ALIGN(stack_top);
 
 	if (unlikely(stack_top < mmap_min_addr) ||
-	    unlikely(vma->vm_end - vma->vm_start >= stack_top - mmap_min_addr))
-		return -ENOMEM;
+	    unlikely(vma->vm_end - vma->vm_start >= stack_top - mmap_min_addr)) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
 
 	stack_shift = vma->vm_end - stack_top;
 
@@ -652,9 +663,6 @@ int setup_arg_pages(struct linux_binprm *bprm,
 
 	bprm->exec -= stack_shift;
 
-	if (mmap_write_lock_killable(mm))
-		return -EINTR;
-
 	vm_flags = VM_STACK_FLAGS;
 
 	/*

base-commit: fd179f8a05be3ccae366b9b96e176b51fbe54aab

