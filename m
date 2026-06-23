Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 373D9CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 01:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18786B008A; Mon, 22 Jun 2026 21:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCA6A6B008C; Mon, 22 Jun 2026 21:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBABB6B0092; Mon, 22 Jun 2026 21:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92E896B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:42:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 153E84033E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:37:21 +0000 (UTC)
X-FDA: 84909464682.03.9713D38
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4967A1C0003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:37:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rG2VGjBx;
	spf=pass (imf18.hostedemail.com: domain of 3TeM5agYKCFQE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3TeM5agYKCFQE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782178639;
	b=lPTiZseeC/awYtrvqapOmzF88L8pmQ0M7IIdbSDI3xLzey3TgXv6P4aSC99cUjksXR1N7K
	d8xOaxUKres/cpT03u1+Bsz4nOGob2H5V/iEHl/ZaogNSXG6Hhu4eBIrV9Dj2Ftj/x/Lfq
	RIqzEMB5K6qOfyN8oiMlDdAwjEvxlQI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782178639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AP9gehEakYRCrViEtM0iQf/Z+UhqMaziDYgqcj7Zu0I=;
	b=FBJqnwWCKD+x9djommvtS8OCCJA889QbYPUt8fM09E53bJWNPiPZA5ebHyKUkpsmSzzbnp
	uKnWaGUUKVVl23xQP3JqvrGy5Fo1ywkIb1FiDPIk2yRQKRj/Ym3ncVxvt/szW2KIeUiyD6
	uVx7hHXlB/jEj7kpZB2AWrd2CfjTdEc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rG2VGjBx;
	spf=pass (imf18.hostedemail.com: domain of 3TeM5agYKCFQE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3TeM5agYKCFQE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2c354050c34so41843545ad.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782178638; x=1782783438; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AP9gehEakYRCrViEtM0iQf/Z+UhqMaziDYgqcj7Zu0I=;
        b=rG2VGjBxdTVSSjIggAEOPCm0QPxX0KjlH0M9dtxKjcQzEnQlVqpovaDK1LrppGanZZ
         ufnEjbiWfYEAHq9Qtqfhr6ZyMFlIOllObYn7tA52LWsaW05lrmhmDKyMtsoJeJKQOKpD
         53coSSHClIyjz3Nr0IqLMjilyZPjDPDlcc1iItbbSMcnZdAJf/WvAbQkBSr+qi/h57Oe
         55ACUlfHhjTfFrxg1yVvDZbMOJLipIvh//x77qbghcn+31+rqHlNKFzycxf9JMxPP2As
         68yCixAGoyRO2pjuRzQLJFylwye34FGD+P4ZvmhLCfQp9h+axMjy1zZcvYuZKC0fjt2F
         OtgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782178638; x=1782783438;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AP9gehEakYRCrViEtM0iQf/Z+UhqMaziDYgqcj7Zu0I=;
        b=SboY88+8xSQXGi1fxR+ZBoGNDqRVrn9HCHCHl6duAgbafH3T2fXLaRRK+WnNIZxbQf
         HTH1LhluuuBCHe2NjaJQWC78D5St6o/U7uOR1FGxjmtZd+qLqZL7a9B2TsPE4ZCMOsCR
         xxBScxQXU8V4Dk5jOAgnaZuXzpyb1HOz7BeEUdBZtYx4p071JbSUTc1bMGXZ1N430ubb
         +XROSVbCSqVj3e4cwh30O5+2GzPUMJTFiROIG1Pl1rZUW2+kQY5omgCdcKo87rGmubSZ
         Yt2uIZ0uD4Yewje61zbePmxP5eZhEnaXLK1CoDygijWFc52J/WpSC52pUXPEJAwYYeof
         CPZg==
X-Forwarded-Encrypted: i=1; AHgh+RrWBLMt3pYMVPWYZkjYHDofLYsrqDAApYtItBWEYJzqpNSLz8POT9dnuym7cJx3JBDyfqWoUGEX6A==@kvack.org
X-Gm-Message-State: AOJu0YxjCF3LG01tt4zpBYXmZQIaN8o05wlxYB2HFgP/AutOAfV9/Z17
	wLjfAfbYDjBRGPCUpBRyoV76eJ162Q3x2xr7QqIRu/Wh7qWBR9vUlcH2Mv0QCWL6gSmI1Y/ENmP
	ahcK+wA==
X-Received: from plox10.prod.google.com ([2002:a17:902:8eca:b0:2bf:27ab:9cf4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a68:b0:2c7:9ba7:a39f
 with SMTP id d9443c01a7336-2c7c99de6e3mr2076175ad.17.1782178637132; Mon, 22
 Jun 2026 18:37:17 -0700 (PDT)
Date: Mon, 22 Jun 2026 18:37:16 -0700
In-Reply-To: <aceb07e1-77bc-49b6-a932-5fd9b5a21727@linux.intel.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-1-9d2959357853@google.com> <aceb07e1-77bc-49b6-a932-5fd9b5a21727@linux.intel.com>
Message-ID: <ajnjTJdQKD1Kz3tf@google.com>
Subject: Re: [PATCH v8 01/46] KVM: guest_memfd: Introduce per-gmem attributes,
 use to guard user mappings
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4967A1C0003
X-Stat-Signature: yqk69wxzuhirx53eir4deonyu785oi8f
X-HE-Tag: 1782178639-849560
X-HE-Meta: U2FsdGVkX1/K7xV1ooj4Kuf8dyT1RG0iohHQhUYUJDLyuwUCM/HeWdBGDS09MoYQqH0KXPHpt57dMTK6zspv6HLzMgm+sIoQT490tOrOqcpLm10MLcuAaAmI6zINOix3GbnyJzBaHBgtHwoD5sMDZLgtsjwsHJScDTc0jwSN4uOJZpSNY2mt4H7J3sO1+vroaAeU8Dz4hehZw91Ucm6Q9dIQVYpKYozzigtW+l9ipCdlUICVtTFdDEoWQ9lHpWVDa9gBHbr+0ELyTd2MPsvkAzYmkLree3102cf3776iYeUKmDhZsaxx4jYUE/cNZT8FnQJECAVcMfzWxbM2dOic8/TTk9MJwhFAswhfyC6L5JNEZohMm5zUre/Ak9VKJUmP9LbmmvRux/gbNIb4r5I4phKxMa3mZerjx10HkWw4HfqguZMF6Ys/H62uwAOhgCT3GM5he5ABztewKNDerNQ77+RnrHeb8NcB6JcbghT32QyP5WlbGGlGT1AuAAa6Ug4/8smwnNY/uuVRWFoPMZ7beJBZXDLjoV7Ti9fRelfMLh6RQBW5Rcfio04jW8RVSq4fdwfu9hpHBOm4YnVluv/b/p96vIWTVHA0TqTh2HRu2+eO28/uAfMqREL+Aq2tH3hm7NH0aBVDMbvOsaf6vhUn/6LTiTrxrr8RlXZrsFRUs/hVF7NDfRU9gub/QMZyF9uuXAst9scMOt5/XO0y2gxGS5GR6Uyma7EZxQAG4KD5q0aeeK/Z4bYbdQs3bmuRVUCq3J3fVGTGDMb+CJJMGTp1wUxvbFgKdENifWp7efWI63Vwr/TyAC369YlVPoZEjtH1PKEIT92CIWK+At4dGZAYEmSGagIaKnBP1ze8gkG518dEiWzmkW3TkHRdOU1JbvnAQDftB47/PsaUO0nJuzHsEgAX3xCd0bIPoFxrDq5XMPKsF5Qpn7uFIBa3qrtXiIHxbUd4g0pMTJ4VDJmJFnO
 Rd8eQLvT
 zM9Y9OaRtZGq+s6sgjd4VpthE5HIdl/lv8cOA51Uw5DDOOJNZphPEHiYMQUC33OrK/B3iyvd0WCEVCQAJVCAoWfGRPCxJ+Sf4ZMlr63suh2toxKMsAqstnNVDJnaFIh48stSQgo2BgxKBmmed5R1W2S+1T7HpvQDs4mxhIe+MVg+Rwxj7Pl9Rq8LOBWHaMVs+iY1jhdAARruB+rkXX2YVk2canTIs8zZg7uLPcxClXna3vMLHdRCJiG3YIjwtlS3ickTzkrB7otVtr9hcr/wH0tbss/nKMF1kA/XMZsngnftB5QQ5EfhavexKSWFfmU+LrtgliWKo6qTF6ZUotd1Qk/OzwwmagSst3uflnFEt3Gshg7n+c8in0Vn8h4/XRJzIoLrLixXu3ImZCs/hOI0N3Mm+VOW3oz813j8x417cZzfb9P9D0vUZYgMuGiqKDtc/Wk3/gBN8wNRHqLuOipZwecpM3KGV60KWsm6WOGvnu+xdXpe+FwGV+dF+P2Glpiix8B1Cc75GJlcGA3OP9B/zbH3NB0EStb7LtNhja4vk8ybGi92qwNzf8XMUK7IZ3D1CUJ1zOCU30k8N0s2TGUBdPy6myVSpDwl6+QP81brHoRgJ/pIHFSkHY2/JQxRuejVEKUv5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026, Binbin Wu wrote:
> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> 
> [...]
> 
> >  
> > +static u64 kvm_gmem_get_attributes(struct inode *inode, pgoff_t index)
> > +{
> > +	struct maple_tree *mt = &GMEM_I(inode)->attributes;
> > +	void *entry = mtree_load(mt, index);
> > +
> > +	return WARN_ON_ONCE(!entry) ? 0 : xa_to_value(entry);
> 
> If the entry is unexpectedly missing, returning 0 means the attribute would
> be treated as shared.  And then in kvm_gmem_fault_user_mapping(), it would
> allow the userspace to fault in the folio.
> 
> Should gmem deny such edge case?

After several bugs this year where a WARN_ON_ONCE() fired, but was entirely
insufficient to prevent true badness, I'm definitely senstive to making the "bad"
behavior as harmless as possible.

However, in this case I think we're just hosed.  If KVM treats the memory as
private, KVM will incorrectly do prepare(), incorrectly allow populate(), and
will caused missed invalidations (though I suppose __kvm_gmem_set_attributes()
"only" lies to userspace in that case).

That said, assuming SHARED is definitely odd for cases where guest_memfd *can't*
hold shared memory.  Ditto for assuming PRIVATE.  What if we instead fall back to
the "init" state, e.g.?

static u64 kvm_gmem_get_attributes(struct inode *inode, pgoff_t index)
{
	struct maple_tree *mt = &GMEM_I(inode)->attributes;
	void *entry = mtree_load(mt, index);

	if (WARN_ON_ONCE(!entry)) {
		bool shared = GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED;

		return shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
	}

	return xa_to_value(entry);
}

