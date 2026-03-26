Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8300210AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366836B00DF; Thu, 26 Mar 2026 18:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33FA96B00E2; Thu, 26 Mar 2026 18:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202EF6B00DF; Thu, 26 Mar 2026 18:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F216F6B00DF
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1E74C4630
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:47 +0000 (UTC)
X-FDA: 84589647534.19.0BAB60D
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id D8D2012000D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JgZty2Xw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3aLLFaQsKCDkVXfZmgZtoibbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3aLLFaQsKCDkVXfZmgZtoibbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563945; a=rsa-sha256;
	cv=none;
	b=RRDLv8LSI1Ao2eyOsPqqkJFmxjFJ/hqDooAmGB6JzjplTm2YsMxSmo00ftgXd5TRi9h1zJ
	FIzAYJqR0CPLq8EqcuNiW1aTYnX8VGJIFZ7jYAmBQ1Q0RMSrP9DaovvDmQSGh89oJdP7gF
	QBUwsMLzw0jqurpea4Dx+eV7r34CG9s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JgZty2Xw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3aLLFaQsKCDkVXfZmgZtoibbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3aLLFaQsKCDkVXfZmgZtoibbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uu5GxkLk2ihC25vK1ewNFZZkf5k5QyN5WL/Cx64gQr4=;
	b=Khb/E2s0Ylun8GlHvog0z/L3/zxT40ZTpytsfop08XmSJfuz4kNCFbFSRVVWtzplvmRLAc
	ZTGBm7TpwIElCYA5vK2F1M3ficgvtJia/h9cc6V4Ef+2IBydvy3ElVxZlu++PdDJBUIE4O
	+W6ceWZGOmoL3Wj2uTyIk93dZ5Qzp9o=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c69a72aeaso931968b3a.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563945; x=1775168745; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uu5GxkLk2ihC25vK1ewNFZZkf5k5QyN5WL/Cx64gQr4=;
        b=JgZty2XwXfi+zSkOcoJZN6AemuecIl+g2O9AxIiGldXsN2LKxu2WU4cmOMw2ZRGbtT
         1Vgz1W91xW6gb8wZKyLdyMFi9kJJtOVSDaxTkAjP4dof9NCyUi9Gqv4eL55yVRpwJMlv
         UtUMwF+it67SgWbIeDttNPQfqh9ikj8eykJ/W+Lp9KmpJixMyqWtmJHg89peu1vkcAj5
         kGiuq4AAblBlQpdNEEue8o25AIpBCRtwVVT07rew/d9v/ypCky4a/RXUCCm5DajxSA47
         4jQeiUUji8x2OqK+h7X4QpOW/YbGcDbzNj1fmVoQyRaWQhr3Z9xyq4bPBONYA68/kju/
         K3Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563945; x=1775168745;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uu5GxkLk2ihC25vK1ewNFZZkf5k5QyN5WL/Cx64gQr4=;
        b=PGXwpbtawhrsVf27cQ09nXn6UD0uyRU+Z9AKvlcdZHFIigZoPFEMHLcduTRDA130rj
         yvAh0uoF8za2WihoEFWNBLxzD3NH5A5eLasHKIxSe/LGzfGWKnxHCEpN1U67hk8JxXGT
         6epqcV3hEa1Bb1DbVVz52PzYB7p5Dsfu77w44ZyV45e6k2RQAhwnCa9DbivbdbHPO8BD
         q31axWXvTar4dkRO2qw6Vgx7s54ZW3iDkJA6hhL4Nz+KVyOuvFt6gBSCQaPkEoITMM9k
         SFfO6C1LNI/UkZ2zt2bKsHQn+6p1yZfohZ65BvyfqWrktw5pofOuKrFeoVkh3tqU2SSC
         8wCA==
X-Forwarded-Encrypted: i=1; AJvYcCUPc/D4pF4vdIKHs4WalpvCcRHX2AqtoIK01+VVKZw2BaxnsKgVM9N4b1s8frYs0xIFr3TJ5iUavg==@kvack.org
X-Gm-Message-State: AOJu0YzyWpO9QpH75rHbMbdiXWctOM5Kxzij9X4wkBRuR3XXuAubUu6v
	DX70UinGIazuTKw/ES0kVty0yNZhkhm5W1lv8ueWwpC9wZUHEs4F/woVIW2INXTeRBKI0rvDqRo
	cC2j36txOQlaJRXTgX0zzQvzbOA==
X-Received: from pfbln8.prod.google.com ([2002:a05:6a00:3cc8:b0:7b9:1e6:e516])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1f03:b0:82a:6166:3a9c with SMTP id d2e1a72fcca58-82c9602597fmr137178b3a.29.1774563944430;
 Thu, 26 Mar 2026 15:25:44 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:48 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=1297;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=lEdbMLRc9XzFP+/DjPRFPv8Oj2L73VX0SttQ1H+9ibg=; b=Lzqqurlvp5Ti9M3NDoksM02NMKtbbW2WTjtthOuBwY9jkE+E3i27WA/wipcC/9QRLsA8QLCRD
 lkWb3PDIcJtD/RB2l596NV5A74CNdl8PajbjHY1/QAqCHxi6RcLc2od
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-39-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 39/44] KVM: selftests: Check fd/flags provided to
 mmap() when setting up memslot
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
X-Stat-Signature: prkgjbgczqwdq5chp1ji6dkig5dptgps
X-Rspamd-Queue-Id: D8D2012000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774563945-994305
X-HE-Meta: U2FsdGVkX187erIJHczRTmwnmW0X2yvFSS/ftMb+OMVhJCuDo5Nu3bH96pQrSxUfIivorWnKj52YwHFdiazqk7xKAESn9zxgHeF3u8Hq54hLeGT76vjSFNNfiYOcYlPJlZFjHQkmc++byItqMZAsw6eDzdYhjgkL/u/EbMjutnUZvFOekVRaB77d1eWGena4HfwJvUUgjeEKd8qpD0wTOFDJ/UYfxKpxwu98VFsGpxHJMhD3BpBHx0744QNmYKx1SfwsJvpZELvEo4k12QOB0QOq6NgwlI/rZXeBmpwS8TR4Vvb28Kfrim+Ly5oZ81Ooofpa9ZIS/h6/mHyz5Ybjvl1rf9LmWftfvw7NbyaYUuz52MT0fpI6mWHHAJXtNc8vtJIFhQNqVsxsIDeYfc261qSWm07Uak6pQDdaNNuzjSTWPlnTeTQcchD0xY5GvZGBlAvn900c62AHtFGHWpgPIr7ksdlcI4xvBJkDefkLOPq5Cm88k5IOR2MifdXbZgl/pjNCTFvJcIgByDXlTwkAH15mlgR0fuWbHZZosYVUdaACtZ+LFA3X1M2RDf0gufMVTAddRQAMsF/Dc4XhpTOu8MdBZW4znQnNMMQE6qvWVJZ0zvKtSCQulUaSLnxBWhkPsw7raagnvRv+tV4w5oOWxwSZsmEe39xMwv+n26ZpdCqKOvV8MLVpz4XN6ji3T4uW1/6X2lr4dYYKaURoCgJJhqmwnuxdq9ofKWpzHqnYzBaE/RglFZf4j41fbaE0qUAIWrRbmtOotCQRdr+4/PLxJAw/Sv4kj1zywGPP8iGBCSKquh7QVUY1R/UWA351w1WpE/4eb+9YtcfIzT6u9SNdQZY41E9usgYebtayyxcYOw3YObhAqAcWmRYolLU/FDcx2k8Wst0YRwzwujFYxJrd6ZgsNYqQPc1aAa82bmxgMWWbXzAjDP53JFC6X6ymRi0XFiNoA1hE0748pGYDAMQ
 WKKcufzc
 miY35P99eyhASmkRmQAv0A7goW47NUdC3wd+RY1H1Hle+cXFJK+Jc3gBuB8TYCHvSNF5sbkTxNsJhqi/0C1Sd3c8xn825efqnITfv5FJNmXhYCb170aAddF7Mpudww+wKo6cnXEPkFHP/+ckcK6WuAET3RKC2bpchSZW41xQat9V4HzKr6MrGs6DV8craT8uR/W33/b3JMRytqsRXytWmDGQw/A3ztxmUWxUck+L8AEc5rEZ/q6SwNUCyRNUU8RKh+5wHA0/hpdX3hegocRlv86UKcokh7BpqOFTPfU8o7Kq+jnIudN6g9oZAvxBxbJp80BMk1QsvYG43EtUzzys6ZTE4UMbf1QkdkjXn9O4TaXriqPt8WKZaNTLSOoo6b1LmolGgEBjclCrfuNbNfEBCd3nqNGSLYqGltz8iOxrPvFIROyTket8MOVwQs5+USrJkxai6t3ZlhqxF9EHud89/TSQyLbemlTB91kQ0YLqpfl3gyaucu6Z/yAbVtSSd+g+o1aDekovlgf71xCcFidt8kViOyTS7n8Ee98Flpjp5byxxaBB0EnSLXHxSVZkzwVfzuckHdx+GsbEEsxOMkji7aDDm0T5ZiBojhp/ddyP3wBRwY6t65WSdgwZAI9Va3Ra6N8U9hP/9brcMqFcUoIG/sIkPDCzAPJ5Ihjfpo8kvCAoHIE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Check that a valid fd provided to mmap() must be accompanied by MAP_SHARED.

With an invalid fd (usually used for anonymous mappings), there are no
constraints on mmap() flags.

Add this check to make sure that when a guest_memfd is used as region->fd,
the flag provided to mmap() will include MAP_SHARED.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[Rephrase assertion message.]
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6deb6b333a066..6f7d3adb25d0a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1095,6 +1095,9 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
 	}
 
+	TEST_ASSERT(region->fd == -1 || backing_src_is_shared(src_type),
+		    "A valid fd provided to mmap() must be accompanied by MAP_SHARED.");
+
 	region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
 					vm_mem_backing_src_alias(src_type)->flag,
 					region->fd, mmap_offset);

-- 
2.53.0.1018.g2bb0e51243-goog


