Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DBFBC624DA
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80FAF6B00DC; Wed,  2 Sep 2026 15:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E75F6B00DF; Wed,  2 Sep 2026 15:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FA8E6B00DC; Wed,  2 Sep 2026 15:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 366276B00DC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:47:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9608B4038B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:47:04 +0000 (UTC)
X-FDA: 85169855568.24.7D5BD87
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id BFF1D1C0005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:47:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UpFw5C4R;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788378422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kwKfYOaniBtFKBvRoVSK69Bg/ErimmVxxQRLm+ngzMY=;
	b=LI5mhyQgqQpBlW8c8kQA9L4t5sy1ZFAGBQLaskDYqGoMtPkm8m5e28gIUK6o5Z0GGXGK6K
	gb6vlcSdpT+8h7DRaPzpbgWOhGwEwyUgxBXdHS1dh+9jrVIPAy9ivzE3L0PpIEH7FGaIPp
	bx+Pn30StdRUHIf+oN4GcH3Q47TBNg0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UpFw5C4R;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788378422;
	b=2RVW4WmzLEEasTBswKzHKKNpoctpY2QNep4RC6YW50VLD5P6t6j/o1NVXLVmvRR75uiPy3
	avJPd9bGq74mfyoxoGPBy9JwfX7gXDGhv6rkWdZeg98AuQKsE5J3teX7HKlG+MmZfS4CQA
	53zbvHkb7/V5DMhht5zjMN8UNr7G28g=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-930c0f9c1b1so164237785a.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788378422; x=1788983222; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kwKfYOaniBtFKBvRoVSK69Bg/ErimmVxxQRLm+ngzMY=;
        b=UpFw5C4RTakVB/k5V8dS0CupoJLBXz9lRXIiZ3goKs80eXmSQ6Gj/jnzPIq2wEs4n7
         y0bBvUXzLlwkGK66efcD4I0uvx+EmK1gx9xomushYu3+cRDnYFa92JWuYWu8drYIJuTZ
         MTHDqJkUEWEF++b1j4zBWE49ecGXXoto+LoKai1GxHRQnWa6BBZMfscBoXJeedoj6961
         5Dj2xCo52p2yY+aMUL2JReXuT5lEly6y/1YJ/uFbh4jppce6lK7z4SueRpNoClh5IoL7
         gQmthVI2EKxOdq0z8hgqUW94S+Csr7vY5BXB68NPIwcCYbYNjRM6W0RvBYk8YveMRCJY
         AQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788378422; x=1788983222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kwKfYOaniBtFKBvRoVSK69Bg/ErimmVxxQRLm+ngzMY=;
        b=clg/vp0AZ2akBwQwHsqgnWAhbrkP9PiPE2ko2/nAsO2e/zqIrEUxuyz08mlGBQtN7S
         +3rcnFXTWfrfy4q63pngK53RteX8D5/oE0WjRMEmgVl/93N0OjndkldegkPEUPNo/eGX
         xZW1fQzwK/NXF7Q8yIphdKp6eg+VHDl4i2AoiJpNERcfay9lBopIbSwVb73Y/T0KfjDh
         oCxKnqm/uqqXBy4VTWyA5Xru0AoeK0PBYX12gdLb2ZPRZoxm9+T7vhTULvz1quCq/W2h
         WIJh1rekLTl0viu7XN1dIcjgy1sP9pKP6yyZzQ1HVMiNE2PZVBTznmzfaC7a14wWWYfL
         Gs/g==
X-Gm-Message-State: AFuF++meidWnIi8bpZS7Al1gQ9OkXAHfjqbZ42hlW9e312VK45tvSp1/
	RCdiU3ElLLm/631i74WoPcww1lcNfwQvw9bUtxo33nWFCSsn3Osl2qj7YjTXpLlS57usEapmvKt
	3adpYFXc=
X-Gm-Gg: AYBFou2W6S8DMJVL/9hvRrzMRje0a0uEZi5dpXtWlX/D9zp1gDxtyB/hqn5YB5HdCVg
	sMJdZsGsksnI54EkYxIewxIH58y6CGzOmmXBoRdEj2R19dj7cwAIWgXvpkRcxaRPsgJ43KxH4/i
	A/OMloqZqal5wMtoXNyChxOItMfPGV0KYtdEjrrzE0fn3KEzNmLjFIvESqE4/vSOiUH7GoKV61b
	qGHI/j5ZXEYkaERf7TaOHvZqiK7f52oJfRLHAfCGuO27r36w+rIdRIXNH1ukE1bnPTAE4s6Rduh
	FiUPVBWH/cQmbyTLa/IZRhptzCoK0ww21aQMsd9JrTSImsI8OSBGWFxaYtY2zI/A/wNYMY0aSeq
	/Hct8xMAJ7c+KuNdPjM/tiFo9pKkzU9aXdUt2nnUYK2P5yZUTue7jwDysQD6xpdkfe2xgmUC7U0
	Lu2JIQFIB0JK1DnJOjWM0hXS3mrFCxOVtRlJW6nPSYYsOCSkFh6vYqoZS2hzZlDQXq6bVy0XHBW
	ZLP/o/RDKyJVct6q6sSa3C9hn7EQq2e5HcHwrso5I0rGorzkQ==
X-Received: by 2002:a05:620a:4586:b0:930:9585:e08e with SMTP id af79cd13be357-9396f83aa9cmr61071585a.10.1788378421813;
        Wed, 02 Sep 2026 12:47:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9395f18801asm299300585a.16.2026.09.02.12.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:47:01 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	shuah@kernel.org
Subject: [PATCH 1/5] mm/mempolicy: add mempolicy_create()
Date: Wed,  2 Sep 2026 15:46:53 -0400
Message-ID: <20260902194657.79075-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902194657.79075-1-gourry@gourry.net>
References: <20260902194657.79075-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ux17c7ybse55d9btbefoj8spjffx5oax
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BFF1D1C0005
X-Rspam-User: 
X-HE-Tag: 1788378422-477459
X-HE-Meta: U2FsdGVkX1/RXyLegu+hf4pqsDjjz4S6nG+u4x/l6ll6/FtT8zquiGHV0mTxxfjGC4s/8opMv2GTUEgODLr7zXWWAfoG/euALEXoYFWrVSWxBkiFv3X7TSQJZPWUyAYUFGyi2RiKGNOLW0OhqKCg+1/dwLQanvNk3b4/PegRAyYxHBqfLlvxbAd13EoMZgN/eA88umneVNkuy5smvHTcJm0TC+sGTbPuAalWm7dwPu6WWmY05Ee9WK7EIt8k1aPgPK3pcvSmsOMupemFJsa2AxlsAuvaQf0BtqUzY9Vzc8TpGa2t8+pqqvrpM479xFlR/yG/B82B3sAZddJVEl06jaBGdFA3fzjI3D79q9b42hHB83JXAi/re+GbDuHWfIWB47oWB8mciFObBvQxswowwzGcORNVINEcmDq4OmxZxA0/6uGuQxrJlKRtzj8sBY5/Q36WYou/xRXCfgjNmGsad48k8XjRT6OPb/4TUqeBnbcKNCHTTu9nD/DWAmaiyr3pr5yF6JZxJPLygLvbcEj+JtuEFBB5cobBpSSssH9Y7jkP6CWLNo2Oxo5qUYNAEIP1MVFrjFn5YGxk3lJHmQqP7ax2ig3+r/fH+po67xHd3SukNwtE4hu+j8OdBC7xTGslt88ne67iJMZuMBYe1E3HiOzxe0PPhq/8z90w6ROO5kXDLpQBs8DUkBk2SCI61mtYP2GtFxj8ZxGgSONh2nh6lXhVXugaMU7UTUxU6oGqPIpPN0cGNP0yzgD+hEz3x0wECuMzUl5Swhw1+i6EJoe+WF77NBzEzMibpazwCRRjWINZCMIaoB6JnPYcHGrMohj4N3iTCLoNVJGss3Znu+QS3oLm/MR2eEuxwKG3q5gb2UVVKZ9s0LsmzUN9n8CXwfevOHKYtW7FUkStPNfy27hgFTKFhus0iSHgEkOXvvu7q1nW3981PBMwxiCIvmZEDeIlI4bvaTeYFmbypf+Lvyc
 brzcUBO/
 J2dl8fkg7UgT9ilM0/QnbZGPtV/uBKd4+wsvf4r1s2P6HODNN1kXVsOtHlPEeymyafHy+Ss6JU5K5KWdMJXogAkbcpcjIUeOr15AK9oRXWZ3PfvEeLRJBzATKjEf7zA3HimCRXN2RecZhn6HtUQ27v4FZYHaI8joUakEmVTNCb2W0t6xgjoKR7tktIJBRsWzHhVdiHHVC2Bgg4dkkUIdXnS0zbpKW08Nwd0ohXrVt/hf1CHgt1muE9kQ0Na2kj5PLXTYbcedSsGic4nfN3vTqE+ZQ7HGIiEwVVCnYPRk4oHExmCCyR7OjXntYHERBZlRjSb31/C6DBE5K0VGbPV46GvIPA80VFrCB7txyj/bsUkiUe+ZdnXUH/ip1pTLcVYhr6R037RNUO2uDGK+iS/qIWVqyco6LbAGJIboGzMI7UDd4zgo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

do_set_mempolicy() builds a validated policy and installs it into
the current running task.

An in-kernel user that wants to construct a mempolicy wants the same
validation without the install step.

Add mempolicy_create(mode, flags, nodes): it allocates the policy and
contextualises it against the calling task's cpuset, and returns the
mempolicy to the caller (or ERR_PTR on error).

do_set_mempolicy() is deliberately left alone rather than reimplemented
on top of it.  For syscall users, mpol_set_nodemask() and the current
task policy swap must run under the task_lock(current) acquisition.

Export the symbol to kvm for use in guest_memfd integration.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/mempolicy.h |  3 +++
 mm/mempolicy.c            | 40 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 65c732d440d2f..aef018ad92317 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -128,6 +128,9 @@ void mpol_free_shared_policy(struct shared_policy *sp);
 struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 					    pgoff_t idx);
 
+struct mempolicy *mempolicy_create(unsigned short mode, unsigned short flags,
+				   nodemask_t *nodes);
+
 struct mempolicy *get_task_policy(struct task_struct *p);
 struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
 		unsigned long addr, pgoff_t *ilx);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2ad0a5f18280a..da133ffe0b1c8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1085,7 +1085,45 @@ static int mbind_range(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	return vma_replace_policy(vma, new_pol);
 }
 
-/* Set the process memory policy */
+/**
+ * mempolicy_create - build a validated, cpuset-contextualised mempolicy
+ * @mode: MPOL_* mode
+ * @flags: MPOL_F_* flags
+ * @nodes: target nodemask, or NULL (interpreted per @mode; see mpol_new())
+ *
+ * Creates a new policy and constrains it to the task's cpuset.
+ *
+ * The caller owns the returned reference and frees it with mpol_put().
+ *
+ * Return: the policy (NULL for a default policy), or an ERR_PTR on failure.
+ */
+struct mempolicy *mempolicy_create(unsigned short mode, unsigned short flags,
+		nodemask_t *nodes)
+{
+	struct mempolicy *pol;
+	NODEMASK_SCRATCH(scratch);
+	int err;
+
+	if (!scratch)
+		return ERR_PTR(-ENOMEM);
+
+	pol = mpol_new(mode, flags, nodes);
+	if (IS_ERR(pol))
+		goto out;
+
+	task_lock(current);
+	err = mpol_set_nodemask(pol, nodes, scratch);
+	task_unlock(current);
+	if (err) {
+		mpol_put(pol);
+		pol = ERR_PTR(err);
+	}
+out:
+	NODEMASK_SCRATCH_FREE(scratch);
+	return pol;
+}
+EXPORT_SYMBOL_FOR_MODULES(mempolicy_create, "kvm");
+
 static long do_set_mempolicy(unsigned short mode, unsigned short flags,
 			     nodemask_t *nodes)
 {
-- 
2.53.0-Meta


