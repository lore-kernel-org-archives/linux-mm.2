Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D794EC54F52
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10FA06B009F; Tue, 28 Jul 2026 08:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C01C6B00A0; Tue, 28 Jul 2026 08:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3386B00A1; Tue, 28 Jul 2026 08:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B30FF6B009F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:11:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25F9DA14D5
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:49 +0000 (UTC)
X-FDA: 85038071538.17.35DF99C
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf10.hostedemail.com (Postfix) with ESMTP id 68DF8C0002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JM0mOlqH;
	spf=pass (imf10.hostedemail.com: domain of 3gZxoagkKCLYpWnqjoWdqckkcha.Ykihejqt-iigrWYg.knc@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3gZxoagkKCLYpWnqjoWdqckkcha.Ykihejqt-iigrWYg.knc@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9QAs69nEaOS4rmhD2Q9ekgaAb43dU/I2zqcKzZYHR6c=;
	b=v055D71SLwpPzigICE2DMnzwJcR5FfqGP25p/yawIfzxRrhhNEmdycpjvAqtjvz6XeNBFm
	jQO+Yse6lmdrWy1AUAH5tXaEmsnhiQsBe0VNri8mkURT7onrY3i2FvibvfxD3qTpcqwlU5
	KaH2t6iq2v0aLTHvi6Rc7D5ZiqCE5Pc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240707;
	b=E/+U6Fev43/AKSkXCNih7CoXhebk9QCP/CeA03sdk+DJKh6eYtWRbEvnjNHU5CNoGaNf9v
	oveTQvDsst0AwqEYIUX2EmQRH4wTJMuueTTZtNq2xe5i4l41pp4eyh+HAr99JolbuSogkH
	C28QdWxb2zoV8uqPY9F7ykH4WZgCApQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JM0mOlqH;
	spf=pass (imf10.hostedemail.com: domain of 3gZxoagkKCLYpWnqjoWdqckkcha.Ykihejqt-iigrWYg.knc@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3gZxoagkKCLYpWnqjoWdqckkcha.Ykihejqt-iigrWYg.knc@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c15f4732dfaso424233466b.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240706; x=1785845506; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9QAs69nEaOS4rmhD2Q9ekgaAb43dU/I2zqcKzZYHR6c=;
        b=JM0mOlqHKS+6HbJS10HQs5CK5V1PBJfFvQbymBniEZx1DbgUV3/Qb4O2AK/psXR9k8
         V4hg6sW/fBRfvd9rG86T9sBzil6nBP9BywP+XE/R6WEW9JI4IZpRetUlkYkFmPiHCDsz
         FX41UterPYcoWlIqb0z3Xtg0l4NKHd0GXDg2dxYX7dhjfrb7Y+yNN/7Xm/xdb5JXY07S
         jVvnV19wgX2eV8hE5F6zq0zV3kRNfeUqNilhtcrXrbGLGNa8BwjisCE4/2xYzirfPcmc
         PMVEMQBOe8lZypiAuuV0Hh04RzJiRB1lShLmW4lwNuRIpol8fO6yd+oj5p9epvqMPZSZ
         gUTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240706; x=1785845506;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9QAs69nEaOS4rmhD2Q9ekgaAb43dU/I2zqcKzZYHR6c=;
        b=lCSaPI0+gwkIycyUIm99sNlkJJoBpylup3o0VGQiXEwHMBaRIvq3MRsTNSerFv3fRL
         P4LxNAvDlNfJiRNm9vVjpS3Fbkaegli7dcYYNZbaXCPE25TFRZ1wBFXpTu3VFzE9Sw4l
         AvMYIRywBtUpXpeVir71UFqpg2IVc1HfT+s5XkH4+b1+Viyn51qeZYXWTbEPDuyEwPPw
         IIUgmxHGdKPbOAkx+CDoyeLI2COA6m1rKdainp593zhIFo4uljv60RO0bMX35EZ0c5rk
         8M0uam4bLCD4OcCJYM1UvK9KEA8+Bn0JRM6EqlPzskpnrL4ZHEk5EynBoVDk7poubxsC
         ds0Q==
X-Forwarded-Encrypted: i=1; AHgh+RrJ6uUTmIGDNf0ae4fccCZV/tGuhy3tOMmXDv2JBl7XYu4wny4af5GMvODJ9DMpLbrRudprw+2Y3g==@kvack.org
X-Gm-Message-State: AOJu0YwlB3LQwV+z7me2M71odtqzqywEdCk2ZOWMt8GBi+UI0MbPy2Sn
	Mh/2GKMBRG0Xv6eyG0I4Wq43dulXZ0OSnJQCKGw7n/HGTgfaj2FUjsLQwqJ/LXK0Ld7v3qHGKHL
	CAQhgfrOP9ToIlRN8Fg==
X-Received: from ejit16.prod.google.com ([2002:a17:906:3e50:b0:c15:8b2e:2c2a])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3f96:b0:c12:96af:acf7 with SMTP id a640c23a62f3a-c1f7215156cmr114258866b.43.1785240705336;
 Tue, 28 Jul 2026 05:11:45 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:31 +0000
In-Reply-To: <20260728121138.1103610-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-5-tarunsahu@google.com>
Subject: [PATCH v4 04/11] KVM: Track weak reference to vm_file in struct kvm
From: Tarun Sahu <tarunsahu@google.com>
To: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 68DF8C0002
X-Stat-Signature: xpzzzqz7j6dwwnj1795q6bawxkxiraqt
X-Rspam-User: 
X-HE-Tag: 1785240707-411930
X-HE-Meta: U2FsdGVkX18+khwqzU0xIRHdaEUnjBgAPP84/krRjeBHd8EZu1O432Vnl4KkkdszPVAuQkvRs4MH1MtApC30nqgsXiSjNKeZ24sbDHQ75neyjOmltyljvwDf+SoaD7oacu2iIrZauK21saBQYrCZX/Mwt+l+XfDJP8ISzjf977z9PP6znPEnqhz913ofW0rXWvzLA+8M1kY1BbwN6jdwDfODscjKo70W/nCuQgWu1WDwqS3wrxgqJNnlZCcSSytQSIFMDhKeX+49Fe2So9Fhxn30JM1ou9FAj6dhxYBjUpTPLSTbwMhthb3Ee8VBhI+fEwJDQxXf3z9Zx5lqc05CmUJuP9b5qSsdpS5QmUKpPO1IozsadBkYaGefujFizrSQHyygb3dQDkDoU2k9kvDKgc2kh9p8V0PsgfXY3i0lbq+G0M9nkhOvcYkwYTBGfWPTtd3/t+j+v4pC8x40GBkpxr7EGnABpSOgESjWkZUQbeNHzvoP1MYD3MGAtfiHYEbaFBjHgXzwHJzE2TtBdbDZl31ZAuPuLKxfE4JkipXTfafYbTQ2f1K9XVaGsUXNw2MrchsE/Xqy0oxY5aI3Npi/Swz6vFVblcwNVpTCuTBFhJGhXJNjWvgsjyzwrF6CeUjrHa17qq71Rh8BuBP+/vgCb9hXaBhqNrJ2kHgmEFtr7vNvSiKBzc4hkahfVD1f6Tg3CD1DgcNHav0HjfSVzHRFSQJmAAXmmBOdDaXLRAY3OtHuNdoQr/0FDeUlmUKA6HPBZleNF1dii7XVictAr5oKQb7V55vRf5ZDSd/bktqcv7DZD429d3GdGouhOZp7YKmSxtIqph0QTVoEaFpfyylIezC8irmgL5/8W01K+cVWiIZhviCQelX3ytzZaogPidUGNmsm1BYAsQ6Mr4EIWa7/nsvWpNMwP/HCFFdWLSnwW+5X0KCpxxI843arEE5cgE16EN4VHNCDJptA8Ze/BT5
 FoYb9TNR
 wvHpAnRd8Jmc6VQtkN1H587aYQHDbsDNSozfM+DkccXD2GytzQLPIEcRGz+PpBNXJ4vqwj2A30NNIO9bSx/irkDUA96soF6d3HBPUXxs6HREQ95L3E6mVW0S2kzXxECp7ZXwAvuDQBojtzbe6U8brsPUT6p1YiVASwWfFaMq7GZo2f89dBEROI7ao5GO9zHjCb7q5BvNDeK0FkYJutkV0HnUQLWz73/x0QUkVJ/j+mNzZWm9bqRtAn/nAN/RC7z/9/TkNjZsmfHYKCAw1WGwPi7K9SYEgMiCnn1KXI/7vUttGAh/1AaTiaU18QXAehm/e0/eG1qwH7piXCQsL9kLdfWcw4dtO5EpR2iooS48adfHkGEdibuaw/eN8eu3hD1xUy//G4b2sfH+GL0T8QKk4MZJIw4Gl8d9Tc6fG8R45wjtLqCTRpqoSrN3XnJ6qiyPrfAKeG2Edbal4a64dpumIesstF2cfqmARLNMVphRhdfaEu/LJQ3sGtW2XZKDnzZ969sl1iVACMOcIvD1zy0bP10v2FKewbjREdSEpfXKL2px3bptegaPWv9HfBLKucyGZ8lcFDlSLoVVeUumtJUWv9P+hCgblOMBc4mvbgT/Xx4ZEwXiXXLp9l2+k3iN9cXf9/kMrg1SjB8kufwsWouHZfMqprg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

- Add a weak reference 'vm_file' in struct kvm under
  CONFIG_LIVEUPDATE_GUEST_MEMFD to enable reverse file resolution
  without circular lifetime dependencies.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kvm_host.h | 12 ++++++++++++
 virt/kvm/kvm_main.c      | 26 ++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d9908c19e42f..8da9589425ee 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -874,6 +874,18 @@ struct kvm {
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
+#endif
+#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
+	/*
+	 * Weak reference to the VFS file backing this KVM instance. Stored
+	 * without incrementing the file refcount to prevent a circular lifetime
+	 * dependency (since file->private_data already pins this struct kvm).
+	 * Used exclusively to resolve the file pointer back from struct kvm.
+	 *
+	 * Written/cleared via rcu_assign_pointer() and read locklessly under
+	 * RCU (e.g. via get_file_active() to prevent ABA races).
+	 */
+	struct file __rcu *vm_file;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
 };
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 701d4596a91c..14c32541ae34 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1346,6 +1346,19 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 {
 	struct kvm *kvm = filp->private_data;
 
+#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
+	/*
+	 * Clear the weak reference of the vm file.
+	 * In case vm file is closed by userspace, but kvm still has
+	 * other users like vCPUs, clearing this pointer ensures
+	 * that we don't have a dangling pointer to a closed file.
+	 *
+	 * Cleared via rcu_assign_pointer() to ensure proper memory visibility
+	 * for concurrent lockless readers under RCU.
+	 */
+	rcu_assign_pointer(kvm->vm_file, NULL);
+#endif
+
 	kvm_irqfd_release(kvm);
 
 	kvm_put_kvm(kvm);
@@ -5488,6 +5501,19 @@ struct file *kvm_create_vm_file(unsigned long type, const char *fdname)
 		return file;
 	}
 
+#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
+	/*
+	 * Weak reference to the file (without get_file()) to prevent a circular
+	 * dependency. Safe because the file's release path clears this pointer
+	 * and drops its reference to the VM.
+	 *
+	 * Written via rcu_assign_pointer() because the pointer can be read
+	 * locklessly under RCU (e.g., in kvm_gmem_luo_preserve() via
+	 * get_file_active() to prevent lockless ABA races).
+	 */
+	rcu_assign_pointer(kvm->vm_file, file);
+#endif
+
 	/*
 	 * Don't call kvm_put_kvm anymore at this point; file->f_op is
 	 * already set, with ->release() being kvm_vm_release().  In error
-- 
2.55.0.229.g6434b31f56-goog


