Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E552A10AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2E776B00D9; Thu, 26 Mar 2026 18:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADF336B00DB; Thu, 26 Mar 2026 18:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F48E6B00DC; Thu, 26 Mar 2026 18:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CA776B00D9
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A17F1A02EA
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:41 +0000 (UTC)
X-FDA: 84589647282.17.2584DD0
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6159910000D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bcTYl+Oh;
	spf=pass (imf14.hostedemail.com: domain of 3YbLFaQsKCDIOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3YbLFaQsKCDIOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2+twVU5Kq9cuyYv1c7sUjk5voAbaDSz+rxqzaEeBxI=;
	b=OWzUNxzxis08aspFgGossXwWFs5/NKfpxAej5D8TDjnCFUcl747dMITwg07fi8UTt/udp4
	f6epjnTqYvNZfpCGH5j0619CQT5BtQqp0GhCexhNNRypnmuN1MFEWdbzAsPqtS56OMkbcj
	lNPQ8VRVlJIm28OpnBi8MXBYvg2wMvM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563939; a=rsa-sha256;
	cv=none;
	b=uVy6hPedmbEwkkjp1VkU927YuIDKkC4Q1/s5zDhDcL5tCHNqmHS49eq1MJ2Z9Gn7KQ1Dc+
	eaCsHfnPvFPvkgXiL0s7Gf3VB/OHH5R+43JkylUUpiK4LVJY59h9/UJ9DPrlkYPOs14DcW
	XcgXPHoeyYDYFFFhhXToVh3T38MLr6A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bcTYl+Oh;
	spf=pass (imf14.hostedemail.com: domain of 3YbLFaQsKCDIOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3YbLFaQsKCDIOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b064884a7cso46412895ad.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563938; x=1775168738; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d2+twVU5Kq9cuyYv1c7sUjk5voAbaDSz+rxqzaEeBxI=;
        b=bcTYl+OhWFgQKN76f0GGqE5tTuH81rsgFlVU0UvKRUojyR2yb6zA5yE41mKFjIokBj
         I4U5qBGkULLzMcxaAmlNEaAVkxOS5eX0MKWYQb7BaE0JbXIQEpwhLoaacc9aDqBrcnez
         DB/ODUYqZZxlM6LV6cKkwr5i3yJkaBdT+y5jCLip6Mjh+dF+/+O5lP9Viyvxkh8gXZiO
         YJ70D6tZCzxH6BwA6Y+Cd7ad/RnA1wgnKOfdQTKUju80JJT77C6y+ZKA9m7Ioq37cbd4
         ybLO4zUAWC+qe5oZtBBczsAFHV2Iw6h1kmQFJjaJE5RVkkzKLzGoH7KtQcddHfvS1gSr
         6sXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563938; x=1775168738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d2+twVU5Kq9cuyYv1c7sUjk5voAbaDSz+rxqzaEeBxI=;
        b=llaLqBd4rgZGqrc/NcGB+XT3vHMtfKlcJhBPhN5lKD9UHlBQIPIgoEbWKmb9lfCQou
         VAf8MHqBqyp/q7VikG1fLkcZ2I2gTq4UKFpGvKTmqe7c7861dTTGjCUG9Eim6HjiTc3I
         uoNH/e7b1s15YV5G1C3+GlBW7xPY33d+X5qPziJ/ycWKXewLfs4y/DwXoEdXhSKV19n+
         rIFwsohhD7GtTpijhfMfiFXwhwQLE7k3x81fGyyzP7b0jdmoJJM59kFGKGgm180MSa16
         5QRSL6ydP+3wQpenZ0B3s3ACMBK0ChyiZopPKXHMn32AdHle/t20PX6+i1Q4NzJ8rADm
         2LDA==
X-Forwarded-Encrypted: i=1; AJvYcCWSzvRM1zWbKJzQvT8LzVMPHLNL1RjvQ5gBKWdsGDKAv+u5JnnUavrlCVXj/YG8ZVA3hk3yEpPqBg==@kvack.org
X-Gm-Message-State: AOJu0YwAd6dwT5tZOLmskqVQ4/22+lCPCAec4KzAisHZNtLagZpuurOr
	rIsMsS8JIC5Kzf+ajDnU8+iaYTVQPlCnIX9gm8hTi86C/Ufd0EiLrJQl377fCCJ0+NCRK8ZwL1F
	Dn3WYQyh5bLuO4r++OdYzPL+6Ng==
X-Received: from ploh10.prod.google.com ([2002:a17:902:f70a:b0:2ae:cc99:f449])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:fd44:b0:2b0:c106:a402 with SMTP id d9443c01a7336-2b0cdc041cfmr1807345ad.3.1774563937933;
 Thu, 26 Mar 2026 15:25:37 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:45 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=2497;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=rWCcSWsmhbugoQ/CrLBaDfQJULRa6k6zO+0SZDZQZEw=; b=pUQCq5SrWuGgz06BeAocUDvHqxQeLoxpdNN2qf+xv5H6xfMk48K1Oz6M3gJfWh5qm4+iuM/cB
 3ipj4RgmEYVCD2ax7x9bK4do0PRj5QXuzR0HkNjDUyGsG3ewhZB4IbG
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-36-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 36/44] KVM: selftests: Reset shared memory after hole-punching
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
X-Stat-Signature: k9kj5qhfhyjthsderfy17c7nza11qx3j
X-Rspamd-Queue-Id: 6159910000D
X-Rspam-User: 
X-HE-Tag: 1774563939-91277
X-HE-Meta: U2FsdGVkX1911hLFibG/5zgIY+ZxbwUl4kKY5wgWH9zTMukncPBI9gpGSF5XHAlXQOdGH89rfzjp2eKC01AoJIjdqx79QjoeFAhquXzbTbTqGeT4GpiSuoHsvtsoB/Pgyl71j2NEjxBFw4wMH7m0drNUyrG1eg7KQEEHKVpxT7gTfKPSnxznTp8XjIuvn+voMFbSM6CTbZTtER4IS3qBBauSzkWwc2oE3ZpyHwW/fNmH2jcch5Ka3xh+MytaaGQAp+t8CtyWAWN6cVsyBw1SKhMhS+QJARa7Z3HNFsLno7rdStBbIELmITKwuVZpO0J11lRKuS5Wqn7WiFNYsUWKtrbOkn0oHk47j2H1p1Y6zNyVPUHb498NaL0noLk0GdWRO9McrXqzfs0tQAULb9ElGaa5q+ykMbKwq2KthR7k0wYQzchv3rjdw/uhxNff82+MyUYW7TqqTXqZALxKdPI35rJYQ92x6cmpVzQ6/DeBcEkRIoFDl+C8BM1oDU+2f/Ls7zw5M4M+woPxFcpTbqu2XI2UuxhUJfeKkemsbZINBFvdxodl/ghkHNZwzOAAxd2DPlBiI7C9vqN0HglIF0ARniZz81eybqfbNCg0Yj+2bF5/XSTtQlrTHbb8WzBPxj31jB7DcLKFa7081iJ/6OOs2TIBOMum3HTf3msz/kBc+69zm6FGDN9IekByTs7+GVtDQliFxGeY+G65eJn0KG8fi5t53FTdJUHoqGFxPH5rbZUN5QtKEkw5kQMyxdrMmbFBB12GlNzzt7Y9qP30ZeTf3psBabZJnxCiP3A+SMlTjrO2KVN0KkIt/BY50VDE0CcUAbn1ZheHyIFxP49t1OghS5KBhQnf9X/BLQWA67sHIwnASvRUmuvGqT0MTwy7KuG1t1DBCpf31kmWmSWSGoK/QQta41ZySEuJCfkBuqX6ASta6uO/zHL9uXvAWEa6HNNMk7iMEgy/vCX6ir6NewM
 o4RZWG6t
 x/KGP4AjHZxc1w4ivwtpt7jE/29DREoRvm7xoV+4EUyhTfcwpj5XEJD0hCeodGMODg+vvgxtUnQlcBxV7PXd+aQQmjjdRAk3GJ5FyD3KReFfjf5esnRyX8G/UqDmHiu0hGXy9SIeS4uion/SiDyfRsoTvWum7fAAsIQQpcir6UvQRjF+TY3D6rma86gL2nGvSDs9OsR1oyekhesvhmenliO35AfoeCeJB0V4C7F0QJ2bMo6aPmF8MzKoRZ0UAiV02fseCI25HkjSIeq/8J37O8nHHa44pEI4zvg/U1bfXqhltlCtqB4+J+1Cq8VR65+YsYfPOcovt5s1OEYAth4hdtgNqlLvlNdMqsKUwlQG0EXriStoKUWL5lV5/w+6hkgHOnduIm/b56D7hYyYqvcRotr9uGjqXLh1usjVpkhPmp5AI3UVQlKlE1NCuB3Qj114Ww2HHW7Nh3jGdItPhjhkh4sxJ6QSddbq0L0ejS7cBj4wwXYHrTuF+6xDLhoLU2+p4MvBFaqs2qaDv5+QnTrtKwRH+SkSnsByKOCgqRtU2kh0srDZwlmQg/VfPyBLmENA0wNI1z1hrX8888iVUIIxdDEd2KLFXzAQuW3nr2dlRv/SF3M7jzgtWn5jsvGbT0N+vLKZqVIWkqi83vdEAjUKqCcRlc2og70ICw6mflh90JC49zz8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

private_mem_conversions_test used to reset the shared memory that was used
for the test to an initial pattern at the end of each test iteration. Then,
it would punch out the pages, which would zero memory.

Without in-place conversion, the resetting would write shared memory, and
hole-punching will zero private memory, hence resetting the test to the
state at the beginning of the for loop.

With in-place conversion, resetting writes memory as shared, and
hole-punching zeroes the same physical memory, hence undoing the reset
done before the hole punch.

Move the resetting after the hole-punching, and reset the entire
PER_CPU_DATA_SIZE instead of just the tested range.

With in-place conversion, this zeroes and then resets the same physical
memory. Without in-place conversion, the private memory is zeroed, and the
shared memory is reset to init_p.

This is sufficient since at each test stage, the memory is assumed to start
as shared, and private memory is always assumed to start zeroed. Conversion
zeroes memory, so the future test stages will work as expected.

Fixes: 43f623f350ce1 ("KVM: selftests: Add x86-only selftest for private memory conversions")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/x86/private_mem_conversions_test.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 41f6b38f04071..47f1eb9212591 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -202,15 +202,18 @@ static void guest_test_explicit_conversion(uint64_t base_gpa, bool do_fallocate)
 		guest_sync_shared(gpa, size, p3, p4);
 		memcmp_g(gpa, p4, size);
 
-		/* Reset the shared memory back to the initial pattern. */
-		memset((void *)gpa, init_p, size);
-
 		/*
 		 * Free (via PUNCH_HOLE) *all* private memory so that the next
 		 * iteration starts from a clean slate, e.g. with respect to
 		 * whether or not there are pages/folios in guest_mem.
 		 */
 		guest_map_shared(base_gpa, PER_CPU_DATA_SIZE, true);
+
+		/*
+		 * Hole-punching above zeroed private memory. Reset shared
+		 * memory in preparation for the next GUEST_STAGE.
+		 */
+		memset((void *)base_gpa, init_p, PER_CPU_DATA_SIZE);
 	}
 }
 

-- 
2.53.0.1018.g2bb0e51243-goog


