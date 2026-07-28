Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0C7BC54F52
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF31E6B009E; Tue, 28 Jul 2026 08:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7B7D6B009F; Tue, 28 Jul 2026 08:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A2D6B00A0; Tue, 28 Jul 2026 08:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 95BB46B009E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:11:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00663120370
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:47 +0000 (UTC)
X-FDA: 85038071496.07.1C81D97
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4D4F61C000A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="lRsX/Tg/";
	spf=pass (imf20.hostedemail.com: domain of 3gJxoagkKCLUoVmpinVcpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3gJxoagkKCLUoVmpinVcpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MlhSbTxVjdyQy53nJTV53rS/2kuy2sPn8hGnbbTr+U4=;
	b=riPWAW0tV2yQQf9K9YQDlkyA1S88cU04qTl0yEXIeujrtC5rfR78TwKtP3T6E8ouDyLoOB
	NebFOtUaTST/wTAisjQViyi7GnqDJ8UcBHihA0Xot7d6qrjCH46F6NuTgI2iiApQydvBUU
	HIkYkL1b82dO9psVhmctsfnnVraHorM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240706;
	b=aDE1j1PrsZtVdp2rbOmQbqot3HSnBjHVu2gIEYrZ6CogRBsPFNeOwTndPOoKSt6yEmE70N
	YkXdR9ObNB2WNQFn6n2wOqg97onDWLkNw/xryF5vgAqRofP9u9RWXzLgvgCjugBFK1+Adb
	my1EyDLIkCut96cOicU0t0aeA7zTf5c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="lRsX/Tg/";
	spf=pass (imf20.hostedemail.com: domain of 3gJxoagkKCLUoVmpinVcpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3gJxoagkKCLUoVmpinVcpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c15ddb61f13so382916266b.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240705; x=1785845505; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MlhSbTxVjdyQy53nJTV53rS/2kuy2sPn8hGnbbTr+U4=;
        b=lRsX/Tg/HS+BuG51gtO9PqSngBLjIaVVOUYXe2bmbxDlXDtugMIf2F4fs7Jfos84A3
         +EPyUtgHPolbcoS80fnZ4ZtKmng7aCc2S4xyxBeQn1T0hoYDrXmfLzdwuB32ydKqHo1V
         lAB7T95CVikc6xuLiBToISyI86Hg55DAZol84qQPJqnU7YuwL44N79UBgbjAR8FgnY7k
         J/lv6uSB9NOLlOxYEwyOpx2Wi2JuBrI/VZBRyIInHuac2mdS7ksnt6HeH6a8uGII32c4
         i8EiRwYva7EgX/e/ty1UM64FaOkzO/G2yMrcI/B7ZSEyY8URoZDkfzLsca6JkwuZYnGi
         l9CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240705; x=1785845505;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MlhSbTxVjdyQy53nJTV53rS/2kuy2sPn8hGnbbTr+U4=;
        b=VGFVxl2HlYR9GSAD7qpC5NHvsbgx+/6Jmqsb1uy8LLOspEiPGNIHi9hyprpTbSD/IN
         izbz26NACxdWdiScAZu/FZdxTtsm+rScCYaYl2v/sl24k/CUNvVr6EftwL2kUnNBUanQ
         qSHs6jnlorvD8S6CIhaYzHqQzolkJhMLxUppNRKsNZ9BwVAB7CTxXEDjhIzEsRi+IQPg
         QhN5tOzZKZqpJasrYWBxzr4hDbE7J/r3Xf0vMccp6E5ImbbPjoMOtlIAG8irQODXKlUd
         miVlwOkMq3E14D4xW/iFHypovDkFCTJQjZHMv3NfHLivv4GlyoQvymt0IEEe7/LMtz6h
         flMg==
X-Forwarded-Encrypted: i=1; AHgh+RpVcSf1XoK7B6E7Acc+ckokFE1ifDJfMrJpcBcbfeJE4UrKYaAPen8eEC2KAhpJZ26p/pl6OvkRFw==@kvack.org
X-Gm-Message-State: AOJu0YwTBO2gO8AtLKYr25DYyqRAzXRFo5MGiiKRirCM4hAXJ3tFQJ3U
	etBBY4hs0V/uZ+UwGfFHzHq7AX8Xj2i375LNcwhuo8s0LFXXoIw+daWrzGiXo/fY2t477oMNxZj
	0xBVXG6m+NaVWcySS+A==
X-Received: from ejqm4.prod.google.com ([2002:a17:906:5804:b0:c12:3a41:5220])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1c0a:b0:c12:8b1c:454f with SMTP id a640c23a62f3a-c1f71cf9b88mr103366866b.2.1785240704443;
 Tue, 28 Jul 2026 05:11:44 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:30 +0000
In-Reply-To: <20260728121138.1103610-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-4-tarunsahu@google.com>
Subject: [PATCH v4 03/11] KVM: Export kvm_uevent_notify_vm_create()
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4D4F61C000A
X-Stat-Signature: tqdzwpy9zwoxf47g8khr5bb13nu3a1wu
X-Rspam-User: 
X-HE-Tag: 1785240706-220543
X-HE-Meta: U2FsdGVkX1+VLhQmPzWNh2wCrybE52nM54rHd4y5R4hV5pWHE1RgEfDL7JM6jEoPC5f1gFvr4wbUfSF6Uw2Pkvq9foIjEDXPotCY4JUfqZB5LgTzbvqCmNrwE4WB0utX/xzau36NsIU7RgNvWPwb7CwnTSXlJz3ysFsdlP5qBj01vXCNqNgMMjfB5kBywm5C8VZLCMGKs0vFC6odWCY449JGn6ShyZCfOGknW9d8i5pu8xvzC429+YtlzdgTF6eBLghavL3gI7IHmhbJOITLe84TxIN62wFuld7VdEeF+/G8weEHfKw2pejyQUT/zU9ove5qlEvXGdB2wSxKJ/XJGXWQs7xXOaZprjgnzKTsbppPkgkQEsMxU/jyJdkk1d5d8AHrBh4+4z/ZnaRAr3pDHqSv/Whcxpvt785e74tmITkOPZbVIYxlUIzJJozI0Ni8QpQc24RJ7syt+DvI21K07lHFsQP/AH3TZ2+nSa2WPaovLypDRr2SOFwJPluju1zGY217Bjry83lh216wFsYdQh+kEBCfwRf8WIzD7Y/PNLOBoRx8NTS+rjfD5VBCNiWFk2W1OoGuiL2gP6pb+5lyRt0npsUTkwrubw9L7UqLEQj6bNwKuS7kSs7nO6em+z6acE307kt7TLFTGYLVWB8CmVxyTjdkpBYXt/tdxoURgGJRtziFQjwIO66vBWDVrqVoObQkPir3Ca2lpsXZY5tUs/W3/TFAKKQQZeUTSa2k3SFZmOjwLNrONmh8llnm59IlA5+anTivKiPt9he6p2dMkouDws9o3MIGsGszCQ0FAbKSBTTAysdZgSSSKinW4MqkGN6qSFh2tpTKPS6EJj+8HdYBCbgCjS0D5UgBdESzBe9qjIXR8ZVb9Jv7KBqmhUClojZwpuYH9MRQQSVBOsb9Leier2GX9Lw12rFZduT369wKFmXltI41SCeWqtCwVNruhS8XLJeU5A8VkT5txx8
 PilaiFoA
 VxG4MZsSiCATS9ENVgDdgecDiNIeOgPELJzk2wLDCGQzF7d+weWRJjRhf1itZeylkTp88/htM1I335aynGOidDETxsrNrlefUEeZqFnb1IAuy/2h8qxbGo84LMzMVIrfFjSlP8M0irbAFaORQNU+zZGPwGaP+zWTV9wkSGgnOpwIbso7Fq0p5+BAqRu/uOiMHbd2zQZ8sAwoC68jKM8eZ3zK5litppxsyZaNntdCQ+kI58FTDYUJz8gWGA540VAND85P8nb7FAillwcdjxN0Wnp6I8T2fe6yRwasYoZvwnO1RJwXDMAvvtHqR2Qes25xVdXvs99Qy7N4AC9IA/hyxdmhfw7AaYsIIKhUj/CkKimsbfsL0U7tsAZRfXDR3jZsv3ZRHn0gWMt5uhEeKM6+F4obPvmnwMSSLstPStdPhddFp+b1Ew9W1imvUOFShhJJlSqI9TEHYRN7YBwT1/zSQcd+2s65ZeYqtO5JeU35n5SDsQ6YiBLVtCnUlkt/JOmJvtunzgVYn40Q3iIdtdqw18P4Z9zMI1AmWdJkaHNMuugE6TOw2+59X9Go5OlqeqeXuijuPGnTpyegZX6z9cvPdeoAK35hGDRPSXw8Fj7aTNQmtU2NW6sdzGVv2jG6PU/Iron1Ym9W/1XdltO/TTpqNynOcXq5x0kq57f0mvkeBL+f4ipQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

- Export kvm_uevent_notify_vm_create() to allow triggering KVM event
  notifications during VM creation.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 79b084887cdb..d9908c19e42f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1076,6 +1076,7 @@ void kvm_put_kvm(struct kvm *kvm);
 bool file_is_kvm(struct file *file);
 struct file *kvm_create_vm_file(unsigned long type, const char *fdname);
 void kvm_put_kvm_no_destroy(struct kvm *kvm);
+void kvm_uevent_notify_vm_create(struct kvm *kvm);
 
 static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3339b8fcd59f..701d4596a91c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6348,6 +6348,11 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 	kfree(env);
 }
 
+void kvm_uevent_notify_vm_create(struct kvm *kvm)
+{
+	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
+}
+
 static void kvm_init_debug(void)
 {
 	const struct file_operations *fops;
-- 
2.55.0.229.g6434b31f56-goog


