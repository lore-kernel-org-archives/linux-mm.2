Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C0610AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FE1B6B00DC; Thu, 26 Mar 2026 18:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7766B00DD; Thu, 26 Mar 2026 18:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4771F6B00DE; Thu, 26 Mar 2026 18:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27B126B00DC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA2501B95A2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:43 +0000 (UTC)
X-FDA: 84589647366.12.2A8D5DD
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf14.hostedemail.com (Postfix) with ESMTP id E34E210000B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XEbd0Y1D;
	spf=pass (imf14.hostedemail.com: domain of 3ZLLFaQsKCDURTbVicVpkeXXffXcV.TfdcZelo-ddbmRTb.fiX@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3ZLLFaQsKCDURTbVicVpkeXXffXcV.TfdcZelo-ddbmRTb.fiX@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0kEUH0AVz9474H95ZJeKVlqpWC9wv6k4l4eJTTe5z0=;
	b=f0Tqa5iYACHXXhPQm4ENPQL7yRL1KxPV6t190jJyNKkUqIN3KfqBjQE991EZP/h3mBOxDi
	9oxkTdVW/TxCDcpgXr4qIBM0Va7IyqMqkWZvMNW8rHtvi+aCZn3n7ceV1+n956Ec4V3eUH
	mDSCdQmR7izIYVZeGlEatJ6KMbUCO0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563942; a=rsa-sha256;
	cv=none;
	b=XlmPXcbkNX0mpg51ruJtKyBWl7+TIc94PZ4CVl9fGDpHcuxKtDnxgVA1YhaLe+9r18jtl7
	NBTzoZMQ2WCnjIK+VJhyxSup6RvBX/HjqCnvXVvVBD8So3K269h2Yv+zeIBZNWbjeFcLX2
	F2/4esQ+Eq4vFUIeIttT1V3g0MQIw3U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XEbd0Y1D;
	spf=pass (imf14.hostedemail.com: domain of 3ZLLFaQsKCDURTbVicVpkeXXffXcV.TfdcZelo-ddbmRTb.fiX@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3ZLLFaQsKCDURTbVicVpkeXXffXcV.TfdcZelo-ddbmRTb.fiX@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c741c4cebf3so991820a12.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563941; x=1775168741; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T0kEUH0AVz9474H95ZJeKVlqpWC9wv6k4l4eJTTe5z0=;
        b=XEbd0Y1D7P4VEfxolUYUJOzoP6WiUzQQwqbgCztQSG2VtzUAVjKaYia4xmcD8gclKj
         tUDs0+paf5we0jZeVbZybpNctw6pqK4r1pAfXxh3sTf/yR+O7pMiJ6UGUWlg+45BaAJA
         CfmZAGCl+WpRU507XEKqH52w5r0d/Q5XiNvy7+mzywpPGAF0Zu0GP6Exky1KOoFi/yzN
         S0OJG4ccCy1rtYs2HfDWe0wLOTCvemfk8whrx+OnG/Qm9EaCVm2TNhX/Y7NYsOO3teZk
         G6RBt4qKAGcZbGiJ8txCeirJG618aCg2nr88sQzUsIg4XKDZiWMKiHEO9gipFeHXGZMW
         DXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563941; x=1775168741;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T0kEUH0AVz9474H95ZJeKVlqpWC9wv6k4l4eJTTe5z0=;
        b=WJdnBDoC+Tv3yg4CAQKxjCPZqNeJm8x4LBp7z6/NZGs5AfuWrryEcSgZOhCPTOEOhs
         odDMk+27jVLndb7+FIpFwNBd9WpjxB/f14YDoDgYGT4HXyJwwe5+ys/F1DG/uJaodvzw
         Tmx0e1rGGDHrfIUqSPW5V2FOfwQaXTdu/tX54qpoT5C7BmXPdm/CNlJD3Uoa++m6nifG
         lJzj6DpC817EleHYh30adoqSmo2D1U4xG8V13ET5QIMTwE/4ABAfmb778AypTo5h9IXq
         ido3cnq5jci4Qyezw6/KTyVLuZfLwLyg7CbBMiVFWZB4LRKpX6xmZD45hiMUhqxNmgzw
         3Ykg==
X-Forwarded-Encrypted: i=1; AJvYcCUSWGDeEH8lxg43RUUtoGgZhzgkFBLt0ltshFQ9YHTL4epgOZmmz6VQoWOzEgQblJJpoz7iBurhjw==@kvack.org
X-Gm-Message-State: AOJu0YyUSuMvqW07hmyquMNIViWQylya6n7+aGyCN8Us3UC84SV9SrOi
	3kMD5GoAYw/H+McufIt1CvoVnU9CYlImt56QSKoKHhXe59ksIlfZx2V1IU52WCKR9psUTMgmp+3
	+v8zfOgh9xPFLKJRr3TEFjtJpWg==
X-Received: from pfbbe3.prod.google.com ([2002:a05:6a00:1f03:b0:82c:70d1:f303])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:210c:b0:39c:cdb:5d81 with SMTP id adf61e73a8af0-39c87b616c8mr305023637.32.1774563940116;
 Thu, 26 Mar 2026 15:25:40 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:46 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=3936;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Iex+2GjcnFztYZs6o03UC8jgSSpVm69SQTPm4qzz0wo=; b=LFg1NDSfx+bum67XPaMfMmazQlzXZqxkRIG8TginmY6+F7SKNrf7qVkCww33oClPBp0A+AaN7
 OS52FCGGuuqC+V+eBWfg0ZX4o+q1AYjZII78BhV4qnGvy49q3S5we2t
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-37-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 37/44] KVM: selftests: Provide function to look up
 guest_memfd details from gpa
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
X-Rspamd-Server: rspam12
X-Stat-Signature: sh1ndg6sxkha6smrcygea9sne6sw8cto
X-Rspamd-Queue-Id: E34E210000B
X-Rspam-User: 
X-HE-Tag: 1774563941-514103
X-HE-Meta: U2FsdGVkX18dhKb9qZJUEdVv0bUpLbwmONbzeTAcd4aBLpgm18hhePpq13HtjEkTArhRuSTkEiOHTGoAGue1Nbm7mrUYCJ+ZpDoGCOeZ2e2jXAq+/nwcQJOw/N1uloGjBb+g3J0yGg6DSaqC6/7YRQPDw+5xotQ91JSFNif/ILFklU/00sonby06V0FT7FrVIRyDwJLod3n4pBtrCsZm8wlMY0bvW8PaB/WR4SPlagPaWYdAWpXWgxfIdBZBHtQ3akU4/m+/wTHPld3C6oGVUlKyaQPvAJIiucM0awKAbgxNskwyJzXqhXpPBBGuM5dlb5MGGU0aFOlwl+bFSrGRhCtCzLbPfBd3G1D7//Vhdf3eb6WTmadr+U2IiE3CCvPjFPpatGVVTh6Dtyyws0aCjUZ7C/zaZn389b3q6JZ34G00o3Jzcgf4w2PT6EXz/BldJuDdU3Visa3L9R7+NitBUAlNBMSg+VLRkUFdLpifoZPBozvakA9rLC9onRE1+azCEIHEitJfp8DQbmEXrB/OB9N6ekIk0+eg1EeBeGfep7CIyKJKix0xWGXmp0LW3mEiXRfANdnOIXHMN+P1NHxiZsY7QcvBa7CLG1Dc+2sajcsd63ggSzBC5GR9CYzasX31MRKGj6W2OzNf4RTmL3ew8OgDo+dz9TepVmCzhqpzEcDsZOzuT0I0MmqmuiQlTOh7K2FaDC25TEF6RP3Bx9AydHektLREjpN8jV1HeHOXiqzy3ls40oLcfjd/ilTOvYDueYuV/eNa6mvkliA0qlxItegjIzgE/u6Ov/n2aCItiIA0rlcrfe1uBOOe2Jlx1I5JcsgFFn/YovostjzsmhJJxJz5u4fkZii4dGYFMIdKIDegj/IiAU478V2sLLQWu5VnEvV+VsQlS7HFRA2wTsif+JgAoaWOfRC0BjGyyDdAX7oFX0iKhp72HxLvWLrIU4onsNoRNUGuIS3ZdpUn0XJ
 twQeKUXm
 Q8J1vH7IR8JRDHAlJBiQIA7h7yCOwaIQYTOJaXACTVU65zseOSF6n9ewZ6dpLfFmXQYLdPl22HER7z9mzaGM10Y5j+RRVT0OdwJaTZwV3+ssrwKe9VhjCX3udF8faMkc9gPGOqK9euyPumWtEKwxDwzMp03cgwB/M50PxoZ2xjbumP6934fh4KFq/O6YHopzqigJaMbAN7vJ/ZaEzQNKAUEts1T97IuEl9uYKxR5lEwwyhkb+yzaI2U6SaXW+3mkCFyZ6qEhL0l2XwhlN6U3PEQWIDtK3dzaH8YhKl7utSXo/+C06SO+76HXdMaU59oMFU1+ZEbuimRjb6xVH+/umAWaqwQ6wHok1maHPbotZSaBGBVfSfLeuUpre9sn293vfmIbuf2k3U8adEXpTweo6OOPlWc+Cf2iUqJcCfZXwO3ZFcn6gour3cqbHEw97ZATuSu89tKurRCez8pydfeufPV1jLaxNWCLZ6vibPJqqZsd5sFL3+KpjngZ0te4G64+zXaLEtQmwdNvhqeYH/Ws6A8Y7ZaOU758hX/+Vu6qoaTepdx6j8Tuue/pUVEdnmyHbtMpcaPSN19bGEI071521NlAKrMDghRLTZHGbNr0RDmkCn452tFt04af9Yz5H/ue/887XZ5ERfqOvAK4Hj3UdzrjYBjKmXSVCKd6suOtbEUe2zTh3QmxJ0ywssmf5mQ9tKLHMWMQvjnmY87cwvgLP0OXVICNw7PmE2aaCk0fqlUe1sMZrfteeSTqnjNky6XE8FYC8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new helper, kvm_gpa_to_guest_memfd(), to find the
guest_memfd-related details of a memory region that contains a given guest
physical address (GPA).

The function returns the file descriptor for the memfd, the offset into
the file that corresponds to the GPA, and the number of bytes remaining
in the region from that GPA.

kvm_gpa_to_guest_memfd() was factored out from vm_guest_mem_fallocate();
refactor vm_guest_mem_fallocate() to use the new helper.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h |  3 +++
 tools/testing/selftests/kvm/lib/kvm_util.c     | 34 ++++++++++++++++----------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a539a98f79e08..3434f3df028b0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -427,6 +427,9 @@ static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
 	vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
 }
 
+int kvm_gpa_to_guest_memfd(struct kvm_vm *vm, vm_paddr_t gpa, off_t *fd_offset,
+			   uint64_t *nr_bytes);
+
 /*
  * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These flows need
  * significant enhancements to support multiple attributes.
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 404efb5318f09..6deb6b333a066 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1291,27 +1291,19 @@ void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t base, uint64_t size,
 			    bool punch_hole)
 {
 	const int mode = FALLOC_FL_KEEP_SIZE | (punch_hole ? FALLOC_FL_PUNCH_HOLE : 0);
-	struct userspace_mem_region *region;
 	uint64_t end = base + size;
 	uint64_t gpa, len;
 	off_t fd_offset;
-	int ret;
+	int fd, ret;
 
 	for (gpa = base; gpa < end; gpa += len) {
-		uint64_t offset;
-
-		region = userspace_mem_region_find(vm, gpa, gpa);
-		TEST_ASSERT(region && region->region.flags & KVM_MEM_GUEST_MEMFD,
-			    "Private memory region not found for GPA 0x%lx", gpa);
+		fd = kvm_gpa_to_guest_memfd(vm, gpa, &fd_offset, &len);
+		len = min(end - gpa, len);
 
-		offset = gpa - region->region.guest_phys_addr;
-		fd_offset = region->region.guest_memfd_offset + offset;
-		len = min_t(uint64_t, end - gpa, region->region.memory_size - offset);
-
-		ret = fallocate(region->region.guest_memfd, mode, fd_offset, len);
+		ret = fallocate(fd, mode, fd_offset, len);
 		TEST_ASSERT(!ret, "fallocate() failed to %s at %lx (len = %lu), fd = %d, mode = %x, offset = %lx",
 			    punch_hole ? "punch hole" : "allocate", gpa, len,
-			    region->region.guest_memfd, mode, fd_offset);
+			    fd, mode, fd_offset);
 	}
 }
 
@@ -1717,6 +1709,22 @@ void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa)
 	return (void *) ((uintptr_t) region->host_alias + offset);
 }
 
+int kvm_gpa_to_guest_memfd(struct kvm_vm *vm, vm_paddr_t gpa, off_t *fd_offset,
+			   uint64_t *nr_bytes)
+{
+	struct userspace_mem_region *region;
+	vm_paddr_t gpa_offset;
+
+	region = userspace_mem_region_find(vm, gpa, gpa);
+	TEST_ASSERT(region && region->region.flags & KVM_MEM_GUEST_MEMFD,
+		    "guest_memfd memory region not found for GPA 0x%lx", gpa);
+
+	gpa_offset = gpa - region->region.guest_phys_addr;
+	*fd_offset = region->region.guest_memfd_offset + gpa_offset;
+	*nr_bytes = region->region.memory_size - gpa_offset;
+	return region->region.guest_memfd;
+}
+
 /* Create an interrupt controller chip for the specified VM. */
 void vm_create_irqchip(struct kvm_vm *vm)
 {

-- 
2.53.0.1018.g2bb0e51243-goog


