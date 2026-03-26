Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 202C810AB82B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7C216B00A4; Thu, 26 Mar 2026 18:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05556B00A5; Thu, 26 Mar 2026 18:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD6D6B00A6; Thu, 26 Mar 2026 18:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EC446B00A4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B2FE1A0E44
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:58 +0000 (UTC)
X-FDA: 84589645476.02.D7EEAA2
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7EB3E4000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="bwoC/GAE";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3N7LFaQsKCAgiksmztm61voowwotm.kwutqv25-uus3iks.wzo@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3N7LFaQsKCAgiksmztm61voowwotm.kwutqv25-uus3iks.wzo@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563896; a=rsa-sha256;
	cv=none;
	b=q7b2i/AEfUYVi6+OTII5Qwy+BPmvbpWXAPw1fABz6Wwajo9Gde8gmAgvEtdybp+j9qMFep
	EGR74c5ujZFgJN/HQzUSms8fzhf3kvD81GD+0bMf0vBAFODyKCTRVf3o/hNSdVSK4WR0d3
	Vozq0+7KWrbc4zDmS7G9G+FgKoWsUmc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="bwoC/GAE";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3N7LFaQsKCAgiksmztm61voowwotm.kwutqv25-uus3iks.wzo@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3N7LFaQsKCAgiksmztm61voowwotm.kwutqv25-uus3iks.wzo@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5sAlrGE9K54t1wVa5MW/TMmXMtzYRZrp4A2ve/Zymo=;
	b=uHwkY6P8uaYIHc3j/m3dxkl4TgDu7GA5Gm6kx6eQgQxIo+nbHS/vkcsTONNeiDUTantcl8
	i9S87F5UN/Y7CmLWNxyRu+8skT0iImgDCbLc4cYpvMKikYpYbstXI+uJC9o+BqHBDyZ0Ra
	gcpSb7Bec3eF4Qd/rQb+snY+FHreX/E=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-829b7ed8964so1449505b3a.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563895; x=1775168695; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t5sAlrGE9K54t1wVa5MW/TMmXMtzYRZrp4A2ve/Zymo=;
        b=bwoC/GAEe82tAwmEkrrj81sowLm7EDnPUOf4UfRg9Hl2bXLvoHjYu3nlOEuygwtRLH
         jnPxyDLzn2f04hlkpw6xQtdbz6RUQCuCb01AvgGsTjHkNk6HxkOjExLHhyYMP2anq7jX
         PHdTAx/YFDhkODpJli6k63+Rvzy9eifGncu2yxDXRL+5C0umYXQcgAkKPP26g6+cXOaI
         k5RAQ/LWObGbdjPBfc7lQzsO776nbz+ZTGbGnonKDmS0Rm3nWbXkfa8Mdmbfhy+U+yvL
         Gub0pIotn5nBxwl8r0RtkOSCyq6ITqFmJIY1+RncVRHkCX5vzP/ogBKtCPfrvD/9HC65
         JxKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563895; x=1775168695;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t5sAlrGE9K54t1wVa5MW/TMmXMtzYRZrp4A2ve/Zymo=;
        b=WGeFGVzG88q0SXWoIr9EFV9dBksHXRMg3I7VCcT2U2gxPpfYUJc4U2sa8wCo5p3taN
         9iARKFZmeB6z1AemaUHWXh+LW1jf0tG18vfrR+Oy1mjUXYA+XGImrnjBKFBk+R7cWnUT
         tdOH88/+ayCzKyP/LndYVakpDH1qML8WmfXC2zlZj4AXVdMLFv9JGSSarA9FUNu0F2/Q
         Y8Art0UTNe9blx0RAF8dVZmwHSA+AgEgOK8GmI84UZnZtsInsI9I3CthS2GNMCw775jJ
         k4zw7uypn/xiG9zG+s3NbtcQMnofnLLRRYDM5IKIJhjiA5P3rIFycpBHq2cRQHhbA09s
         T8Bg==
X-Forwarded-Encrypted: i=1; AJvYcCUXm6vsCeL8cQruj3/EWmSIAQonXAETbGDquqIUkR4F+IsAoroNXGZl2IBRoeUmyiqeVIGtahvg8A==@kvack.org
X-Gm-Message-State: AOJu0YxrjrJdU7jLWGzMKw66wjGs2m/r5LIA11Zd3Ek/Q+TfZS80WU/B
	E3qei0iGz5skIB+YmeI+6qeN8Anv8187e/GkZ/kKhBK9RtW0+EqDMH9SUPjjS9XV5QKL/6gDrM0
	PoWQenHdlt5/Zqzt6aEgB/PaZfA==
X-Received: from pfbfb15.prod.google.com ([2002:a05:6a00:2d8f:b0:829:9082:12ca])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:bc81:b0:82a:81b6:d8a6 with SMTP id d2e1a72fcca58-82c95ed3b8amr136334b3a.25.1774563895023;
 Thu, 26 Mar 2026 15:24:55 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:24 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=2976;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=k0rIEhQmrf2G34ijeqLeCvTfDWOQ9le3qaLEQJYYHBc=; b=IWLi+POwxzAv6171snEkLJVWDYN28Uuep3Son7R0IlBi2Sc94mxhcktuxdQooqH4T04aDlDmq
 +h30zn8kj/LDlT1kMmeMRqgH+wx8i80pH8UDKHg1NuB4KJ+CpPgIlNh
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-15-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 15/44] KVM: Add CAP to enumerate supported
 SET_MEMORY_ATTRIBUTES2 flags
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 7EB3E4000E
X-Stat-Signature: qcwfkk881y9spq6uaehw5kqx3k8gmzbz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774563896-403982
X-HE-Meta: U2FsdGVkX1/BjuhWjrq6Rykx6LbhF8fmMUZhOk9ePb8j+k32ZrTS8yoC/Adl8A2Hp5kG7pRaCKm4WwZnm/Df88b0TSAN0mDsuKxtf11qXbFpbznVKwjtXAFPQIAy81cKCp9NFW/3C08QlX2fnsd4ruQ42gk2M2UPG1ZZ62YX4tqRZo/uxRLm7+tymM7wqqlA3MtL8eBszonIyByBZVl6lgV30755g7NbZGD7hOuLQZw3cyp4UZpO/IYAnpc98YbGtYXT3251s36X232RgDral5se2dqvNSX54JDlYVs8zoCle29DLIQ582qhJ2JvTMaKrM7LEV7ngSmGb2j+2bse9ML7SiE7WxMNyFS83gGcParbtDinAsanwdxKPrKecUZ4DabQ62LVPBlNYPSx+hg+lEsW/IUBWnr1jx3OkIwEZivntMZQBMUBSdenuKFKxxn/QRlTQeyrb/PgmVwSQ7IuSUDOdcLrJtlnkG9rR8dbh1CN12Uxo2iZ13XaSaTTPDgIxBijujfjcQGGT0Jh30R0Et8TdaqxkYRsM6hc6cGtUKBpOsAcjucWp8V9pFLXoNqAf82NQoOTsptACAOn8HyQ7Hi2eYsC2GbTw7WSfFZuPACU22NF3gqtSlOpKP8AE3cpFcF+qsghu6fgNa9xwt0JJCLXiajPxugY9DAzxI5ou/yszQxYAg97a7AOH8LTUcVfb5OBELKszxaCHY4wtuNxhqKcFW+YuFsJGBGbacSNorZZnNWHZ0j80yYJLua6/xZvGPvyI+LvLHxWirYO+7N67b3pk+t34D2XWrNV6dFkyXMsZGw3dwxACTBRYE27ZF/NPCcxWnY0BUsOlNJGf6TtaXRJNJsAsQvCxXYvjMKGtgQat+WblyigQsd3PC8ZBHOcvDmzu+NK21tjOr48VpMEo9UUHnkxyII80xBP3CI4dLDRIw3h5VRi3uNQ976d+/7SRmxgaps+pnE7h8GiLDa
 QGDkkG83
 eAPYKQI5Av9eR70SPHRIBYVAFZ393MvoO2OrCDFlNxs9w37ZgW0PzLY4KKSgDZv/wBWESTgUmNmi+nXxyJeHD08l4akr5xRUnT6rW4kgFXKeV4py62DfKNp2RY+eHbmKeHgUIvGa7AcmhZcor4t8gBILlz/sp+DoXvO2HP2xgwfNtYz+C2XICJGpnQ8yRsGJJr9bXax3GRVTNi3LuewDrFjP83ZNKXF+eAZv+R6xHPZP5T645eGp7FjN/N9zOWSiA6gULsK0Ir21xmwfojIbeqJHtA1tMcvNtMQ3PObqKOukM+/hjiN2iz2GL9es3q77fgS7sOaty6kW/sKEk5XNQ/IgubuExd2+dbLCkyR5+7jpJal6oZ1LVayrzgNHcSF+xEEFZiK8ydH7CPBOEvjwFDR5Z9sLDZgO7WA8hfQbfTuYKQIVL2Yca0bC6cOeq7R/11g/+f/JZ7oVkrinE0eD7XPusqnMD36gSgwg+VImj6PyU1eShXgSkSRUDhuhwjiAGdbWMcJuDKyTOWFdPxj/M0CRkAoc1F3trUGqGfwnQGptUtrKmBPjoeyMsRURypvf1/+M8Ni6ocMd1dRtDOHTuXoS2mH89SwuxyN3ESuaV0KrL2w35mR+O7ceIYLKnJHVHwAmZ0o+wSWmhLM+1BvULgz2fXitXq0N50zQErsJ0GvTHVDjjGiM6E766Xkdf9nhqwTXb51drlhjnnCZ84Bi7jabI9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add CAP to enumerate supported SET_MEMORY_ATTRIBUTES2 flags, so userspace
can find out which flags are supported when sending the
KVM_SET_MEMORY_ATTRIBUTES2 ioctl to a guest_memfd.

These flags are only supported by guest_memfd, hence, if
vm_memory_attributes is enabled, return 0 - no flags are supported when
KVM_SET_MEMORY_ATTRIBUTES2 is sent to a VM fd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst |  3 +++
 include/linux/kvm_host.h       | 12 ++++++++++++
 include/uapi/linux/kvm.h       |  1 +
 virt/kvm/kvm_main.c            |  5 +++++
 4 files changed, 21 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 90587a9c09d3f..73101d6e649b7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6680,6 +6680,9 @@ guarantees are made on offset ranges that do not have memory allocated
 and range [0x0000, 0x3000) was set to shared, the content mode would
 apply to only to offset ranges [0x0000, 0x1000) and [0x2000, 0x3000).
 
+The supported content modes can be queried using
+``KVM_CAP_MEMORY_ATTRIBUTES2_FLAGS``.
+
 See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
 
 .. _kvm_run:
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4ba3c4b303f4a..d671c9795dfce 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2536,6 +2536,18 @@ static inline u64 kvm_supported_mem_attributes(struct kvm *kvm)
 	return 0;
 }
 
+static inline u64 kvm_supported_set_mem_attributes2_flags(struct kvm *kvm)
+{
+	if (!IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
+		return 0;
+
+	if (!kvm)
+		return KVM_SET_MEMORY_ATTRIBUTES2_ZERO |
+		       KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE;
+
+	return kvm_arch_gmem_supported_content_modes(kvm);
+}
+
 typedef unsigned long (kvm_get_memory_attributes_t)(struct kvm *kvm, gfn_t gfn);
 DECLARE_STATIC_CALL(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0fc9ad4ea0d93..4d1e09d022c48 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -991,6 +991,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_KEYOP 247
 #define KVM_CAP_MEMORY_ATTRIBUTES2 248
 #define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 249
+#define KVM_CAP_MEMORY_ATTRIBUTES2_FLAGS 250
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 85c14197587d4..6607127eaaeed 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4980,6 +4980,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 			return 0;
 
 		return kvm_supported_mem_attributes(kvm);
+	case KVM_CAP_MEMORY_ATTRIBUTES2_FLAGS:
+		if (vm_memory_attributes)
+			return 0;
+
+		return kvm_supported_set_mem_attributes2_flags(kvm);
 #endif
 	default:
 		break;

-- 
2.53.0.1018.g2bb0e51243-goog


