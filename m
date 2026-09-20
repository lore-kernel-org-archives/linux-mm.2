Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0336CC982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0C316B008A; Sun, 20 Sep 2026 15:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4706B008C; Sun, 20 Sep 2026 15:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3106B0092; Sun, 20 Sep 2026 15:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B89446B008A
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:37:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22B401404A9
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:05 +0000 (UTC)
X-FDA: 85235148810.09.89DE041
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3C586C0008
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WPILWOYR;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933022;
	b=v9m9XztJmEt6G3QkCmyymklFJEflxsvi+pholST+7hK+SW3vGY1WM5tjE1Vez9xSWsXnIo
	vrH3vIKqMCwJj1yAl/RfIyvJ5dhzWenApuLzLRyxFkQ5jJlwzyqnNqGNQ7/0CA/5y7LhZB
	uvTQwCrDHMDkVGrs5LTx4tYNL9k0qJo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WPILWOYR;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S731x7B1q5+LU0uMImlSdu51MYq8nznsZeZCtyZbDcY=;
	b=Q+r0qJU1+u+1MfiZS1yS7Qpk+JSFEr8IHdGlx5/5+EiqSX12FGseDLWL81mkaXOmFwB/5z
	yQXanMfzLhKAvJ18QtV9wxkVsh+bfnktymEFRVVNsRsBrnwreT9WYhCknQTCvucjYj3fAf
	q1azvNSIkTTvpMJ4gS+rQkp+nLl/5gE=
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4aae3147so1564219d50.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933021; x=1790537821; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=S731x7B1q5+LU0uMImlSdu51MYq8nznsZeZCtyZbDcY=;
        b=WPILWOYRIvpDZ2cpcYgf5psgjZ+lsVOBL99aCzJmzjapndyFr1Ts2Wo0QCUqWmBHq0
         s4umVMGIIt3MKjm1jyLUDoGEz/kIYSy30irVz0gekzxuZ9LysJHe+C3aDXbkR7QcWo7e
         0rxYRG8Nndd7l5AkPeSk45ryCOZoBJsHpS47OwUrKRvSS9q/dc+5vNFFlWhPQvTb9Pj5
         C388kkeC8LqK/qGdMwkt74ucfhmpzYHKu5uaffUfX2E+Ny5yXCMjs1LxC/sEDKKlUqlh
         s8kIwtNEMvdMAxLJBu983bVZr+YUwjzqo3YdzEIGp9MLVkhFcYfAJR5z6iCHkO4jGgon
         9eeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933021; x=1790537821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=S731x7B1q5+LU0uMImlSdu51MYq8nznsZeZCtyZbDcY=;
        b=m0FT8aMgBXpE2t1e+McOI467VtwoRFkLGRQy67inJOXDe3ksnpQYGsBFm/A/lW5tCA
         evwgQbfvMlyqeqWrHHdpXjI1jdePV0gHcyC/Gu9nCIDzFGrS2iuEmb6Eae/WPt15n5cX
         GizQJwl0O/T62ze5xlFRaztVFFPtNT7v4+8pooRmrPZmsZ/wywC0zKshzu63o4kvOyid
         /qVPU8yMy6ci01h/SXaXMR8KWyrOVySW3XsTznZ4NhB0YQcijL5d+SF5blqYOQpBXsnO
         hbmTGRgf+ECcQF5Pg0DNYP0OjhBUUCy/C2eaQOzhGbXClGPEo5ydGw22dB2TAteqLwFM
         VkTg==
X-Forwarded-Encrypted: i=1; AKwUvBxfWtarRB6o8lTpgz5TDvGP/yTJlnPkLLgclMQAZr5+GKobWF7IGbWP0AGxYzDEq+azA95EtUYQEQ==@kvack.org
X-Gm-Message-State: AFuF++mzPNQaN1iftUqNWDvKvUIdTKfHC0eSquPBtVj9idhJ/E6135Rb
	eF7CjMril6fKo1TpGKtPKUO7+t+ZlTPHAfsH9b1eJjK/12sVtw3UMC6GiSmCrWUKvsU=
X-Gm-Gg: AYBFou3sH9gOOh4Ak6W1h+b1aAxtwgSpAntR8AKqltIVzOYjWQwS1W/biW3F/O3xpru
	Y+sg8zJBaWWYGEBfyehNf8u2PWZ13KA+jLf3iSCLfcJTSck18vyn05KN7zNSPJEk8b5FAN6pivM
	mvaCyT5yiQ/BqtXxtiLeil6+gPJw4TjO6qIH/ajkh2941+cyaPwoht42UnkfOsLoMOMUgUnpTRa
	GXZB+EB8yPXwYQKcn45omps6y+C9piKUszV5+8lEiKOWXX3jdcXwlYkiZZuYP/FoixPRqv0lRGb
	df4o4JSIm4/2xBnfgR4BPX/7MqEBsQJVVz0oErFUpgTLCs9ujmxhSMtmdrSYYIzGoJh5xbPOsuj
	y5G64r221jzvE+Zww37RpSOaXQFtKSqTYB9Swemy32MNdNapKPW89Z9ZsvPfPJ+FHndTIQTU7gC
	GEBA3GiV6dTc+HybpKKjn4/lCcRQgkR4CBfCfAqhXDLmJbStGIHhGlin1UqiYYwX5hMfojkBCUu
	0PZIrePBFIkIiCsj0qkz9BUDIlbwwu7T7WDUvE4PXXzQ0DHEBD6MR2G0u2QGkRVL404p0g8HHFa
	oqwC1PXR1JsWAxRmivw=
X-Received: by 2002:a05:690e:11c7:b0:672:a2ee:6155 with SMTP id 956f58d0204a3-672a2ee6b7cmr1008959d50.45.1789933021253;
        Sun, 20 Sep 2026 12:37:01 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67299146eb0sm2607555d50.21.2026.09.20.12.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:00 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 01/46] KVM: luo: Delegate VM creation type to kvm_arch_vm_luo_preserve
Date: Sun, 20 Sep 2026 15:36:05 -0400
Message-ID: <20260920193650.3373435-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3C586C0008
X-Rspam-User: 
X-Stat-Signature: jofggicoz5my4oita3t7r3q1brtm58ab
X-HE-Tag: 1789933022-849816
X-HE-Meta: U2FsdGVkX18tN7z+fwWeMZTdOss8Xqshgt5zzZxdOVYaTpEvcOWy07lAuFpgvhskCosyTmTaWtvodsy3CTc1qYZ8xBwEtiPcN8STW6AZmCkd4Ir5DVAc8xtLF1wZldfZVVv24Sqw5x4pAuFXqdUtELVbGz/VEk1ZYlH30XvdJ7BmliWladd//mRNUZ9tFC0/CXM45GEEk7YaIHQ7gkb0Fj9ItzLd3J84yF83YgGT3wISO84beI+GaJkjiZNKavRhX/4F7X/HS9TCjhUHfntCcbokTDnw8W0j8vmfoG7hB0q4sDuE3fw4CHyqxszOMlSWvjAqmgPMiZFUaIMBq/4QAmpOcd4Na7PJt/TlJ94DFhFa+huT0Y/OG5YDbk335aQkvW2lB4s1AIGgaMrwIEGgl9JlpVwBxmRsGcVpWXtz7tZXw9i+op/wZRXMwoje8nPr8Z7sVbwuTH/HyW/ORAMyvvIdLrvAItSYOwCMRB/jNyF5Sqzm3WwUM/i7GrEM938PGy1JteP/glXtRZCp573Ge3T15YsxgKB/MIms5f6vc9cm4WYM1PH24VuBRLbWRkleXi7ogaEkkrnXySlOfd6P/fvHHfRyTFYn2ovayprYphKeT2yphNYYK6ahToD1g73hJyEDtZAXakSyYEGHZb6yuCqmpeqYt4nfSPeN+WftaTRQSQdn05iki2evW5U3X0hJ7v1zqFMBDAQNoX9Eby6+cBu3rT8zkrAS0jytk+ejalfK11W04Co3O3wU9qn6pDxKGRGH1XXCsfRiBgH659Bf3ELK0eoopetZOa/IZB6hajEDQOn4xVxT+3EZj3GAoKjKYCNQ2SwfPjyUtKruL3PwbeRu8UkIZBMGlp4mGKFUl7f8L4gR0bP+JfEmJ89LJSWwGuHz6wKBFlENKkVt58TMqFBFifTOoqfQAoPez/9iC6OyD0dxny2VqaU191PSkVgaoLs4RLWWGaC1FCpiyAV
 wZvv9d8d
 TxmzEJhtO8kYe3ZPfKfdDwl3Qlptcg3QjDF8sjUvEaxlQN6W5EExkQXH46bOQHtFDZes2X0w+7ojHoOE/MmLcR4C0lFekEtOT8wKzXc7gBrN5z/PhGm6eO8zcSeElxP73ganSXNLQOymcOtAEmZlFlbT4GAdobMVR0gF8XC725d3832c8bCF4b2XYNCsV9cYQw9Qgw8qB+nwF+TC/jwfiM3SkOwt0fovpKKzbM143sjzRdv4gGR/SerfktvX7oDGlvhqSYv6gUaN1tEvYt8kIq+tPZywiTMZiW7/ALu+ZGVPxvDKFNylggk61RHnKnraP0C5LPgfDMj4tYNHOGsTbfTu1SBC5BY8bk+0mN1wvqnMv1Y6TxWlokvDFvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the architecture-specific #ifdef ladder setting ser->type in
kvm_luo_preserve(). Leaving ser->type zero by default allows
kvm_arch_vm_luo_preserve() to populate the architecture-defined VM
creation flags without referencing unexported architecture symbols in
generic KVM code.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 virt/kvm/kvm_luo.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/kvm_luo.c b/virt/kvm/kvm_luo.c
index 025b53151b6a..b3bd9bebe17a 100644
--- a/virt/kvm/kvm_luo.c
+++ b/virt/kvm/kvm_luo.c
@@ -73,16 +73,13 @@ static int kvm_luo_preserve(struct liveupdate_file_op_args *args)
 	if (IS_ERR(ser))
 		return PTR_ERR(ser);
 
-#if defined(CONFIG_X86)
-	ser->type = kvm->arch.vm_type;
-#elif defined(CONFIG_ARM64)
-	ser->type = kvm_phys_shift(&kvm->arch.mmu);
-	if (kvm_vm_is_protected(kvm))
-		ser->type |= KVM_VM_TYPE_ARM_PROTECTED;
-
-#else
+	/*
+	 * @type is the argument the new kernel will pass to KVM_CREATE_VM, and
+	 * only the architecture knows how to spell it.  kvm_arch_vm_luo_preserve()
+	 * fills it in; leaving it zero here is the right answer for an
+	 * architecture that does not implement the hook.
+	 */
 	ser->type = 0;
-#endif
 
 	args->serialized_data = virt_to_phys(ser);
 	return 0;
@@ -115,7 +112,6 @@ static int kvm_luo_retrieve(struct liveupdate_file_op_args *args)
 	kvm = file->private_data;
 
 	args->file = file;
-	kho_restore_free(ser);
 
 	kvm_uevent_notify_vm_create(kvm);
 	return 0;
@@ -147,11 +143,7 @@ static void kvm_luo_finish(struct liveupdate_file_op_args *args)
 {
 	struct kvm_luo_ser *ser;
 
-	/*
-	 * If retrieve_status is true or set to error, nothing to do here.
-	 * Already cleaned up in kvm_luo_retrieve().
-	 */
-	if (args->retrieve_status)
+	if (args->retrieve_status < 0)
 		return;
 
 	if (!args->serialized_data)
-- 
2.55.0.1082.g2b9226bbc0-goog


