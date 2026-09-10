Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19B26C88E4C
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BD786B00D4; Thu, 10 Sep 2026 19:55:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074536B00D5; Thu, 10 Sep 2026 19:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29456B00D6; Thu, 10 Sep 2026 19:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A390F6B00D4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B9DA4805F0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:55 +0000 (UTC)
X-FDA: 85199513070.18.D0E37EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AAD9F1C0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h2T9AwJQ;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084553;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uv7J8szl+MrBEWzMoP0ztb7CPB7RuvDTs6SVxEoNN0E=;
	b=5Rn/e3Nfmhi1wM5mWtcGViEKPbT0BZSwjZ7OEMQ1s3IfWfVPVZNn/s3D6m4JXnviSUyqqJ
	diDofpPDc2DRQKsuN0kHUoV+Jeyj74CCX13OsxrEOE3eKtmBY9yEM4hlZn+vjt57K4UIEa
	1TOXuSj+YDLNbnWVSTT4zH8Cs5OHrUc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084553;
	b=lxRocDuERUQbjqt5ScRWHRd26BAXoU7Mc1aiuvbxZKv6AY5HaRiVihSmfAP2UKho9VTfXG
	hR30Kr8LiviyhfbT9TDgwU2PRqPOYdyM/2vZW2F2CTgePmO/U8IlNCo8QjqBJ64RmArVDr
	WHhdVEsP/KCxvdrT5ADqRLgZ3OWkNHM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h2T9AwJQ;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B40124499F;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C1D8C2BD04;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084540;
	bh=NQ+m2Gp6DBcXXd5O+sEgVmXG2eWA72DV+yeLNCYqr7E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=h2T9AwJQhFo60X2vZP1almbLppH5PPFJf1tv2HbB4BTl/Ti/3EXAw+NTO9hLmex84
	 PIbnBJ5LC6t8RJHRYYd57rIK7DazBa+pkNzjL5OAzLpzXspxHrpgc5LTuAETGIRK3K
	 F/2czMLaiHVIoMc8JuRMROSXTDU6CP49T/OGM/xBiW26ov0ENG95Hz4HDP5WeXrvWX
	 kYf1VZEb6lY9xhtINXk0FdGQRVLN4abC/tIPkD17ToSDvjd3/xiUFe6u41ylUSafNi
	 ACUmhK02No4s8urbBOtAPggN++lk736x39WxTiuQcQFxbu+tidgN3/ioY4N2QiuCAc
	 oP4wbFuQ3F+vw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70AD3C88E41;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:56:04 -0700
Subject: [PATCH v13 38/44] KVM: selftests: Reset shared memory after
 hole-punching
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-38-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=2580;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=qgSSV+iztWlncds2pkMoO3mYfZ9NMVIVqTr/vN3QCpY=;
 b=oTD8dzGF0eTeqnTFELLylphUqFsvuDNQhEUUaeqL+Ct1dCms1Th/dK3+Vy9QGPTpOa+xmlRa3
 2RqXbEeLGoaCbEGFqawd7O1aQyzJrjsLVziOSsdgZqmt8VrTUVP4isQ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jps8459mi8zuawxrp9c4qb3zscwn6gbe
X-Rspamd-Queue-Id: AAD9F1C0002
X-HE-Tag: 1789084553-424204
X-HE-Meta: U2FsdGVkX1+PntVAXJkDAN7t6dJNKsvbmLm7xh/EZGmBRotGfcmB1yWgkkVXImh7HGQFoXz8x8J2rUAhz3dPTFIX91y1yV5bM52VeB8+V2qiRGQjty1VG3+Emx91uyt9CJSHB5PuIqjkYND6uEWXa+avwdfXylNNUI2D6GEIXqTehv+jIpLlnkM9Nm0pRKduQNdoPtHPAmNuvlPki6TW1RDQc4TDuvW2dNIIgvK/WjrxvlWsc1IH4MJnIZaWMKWu8sG0TfNB9ACI2UHBVm8Lx9rgNP6mY15h7uIFOp2oEVyVoWxVafdj7WXSkEZTl07ULlD+VCMiWPR6qOBN8f1LlM9JoA7ONQVJjFXFIR5rlhfa80dv6KBcJQpWd6m85pGK4dM1dgL+7lrR5/fmeonW3KZ/mbn+TePt3pix6HLeB/iv80o+8ars/agrDfbGPqOu8ZQ1pjN0RPmDBRvPqzs9eHVGsH82J8L/XTjfHSjM5xuqYN9nhh2rJQTcreulK1KMz+1BlfNctk7BJhnNAwJBNmN4VpT4f5cDnVNinc9nvPy5tFl5V287ujk41pRZm/ZRTqIO7K49DJVBMQ3kYM7zG04nE5QYYjLFDBzsT9k4/y5k9ylnoHFrNmEF6F0/GeXjcmg9NyRomkpS70e+xZIH6rLHgOq4qMwDj7ZyLK8Olv0zB7pLV9BUxLMAma/qMgLy0jtJFD5E4rxjAXxwWZDkpGkMJu8xSFk+33s/OXhOlaumCRff8hPXUzumYKxmmhREzN6Mja+Gy6OJ8tT6a0SmAplbZ71np0BpcjL+1mWBK5nQKWUiuJZ+O5m/panrhU4pCoTfBllgh+yqrt6wz8X2tbQearL/QQscO9rY72OquVdfbf4Kfkgf7uKFyEn2DT3wqyvJk36R1l0T7W7GgPRm7im9vQkKhZs9IA7qb+vFiGNiZI1BIpCne3aWw+F3cElZAo2WabK3HOqt6XXUqtt
 nnGfeqf0
 akaO0O+R95OXIBf6lO2Vue1EEzlm9bDyoT9UYef4X5IhF2C7gSi2VaSgsSOGanxcJIm+hDJlXHjMl7RU4Hxhm60Ee1F7S+pesU5jueAxysDUjDVuNAxroxCTHrpj+Ro1v1U9hj0ppXNhpgY0wcuTY4r83WLtJf18eZ/I1NMYDxLiesP/iwe2R87MVPG2TUIv7w5NNcBm3MHGczKWBcA7kFhUh7ZlC2po84/eL0Ut0ZxWvCt1Bg5EwOLTUkHRWOq4M6rh9W9I5PQGgBjy7cdYudAjYkPTMcVjsJ1suR0nD+/ftvofzrGKNek/kEijlzy5GHYoiDwQ6Nw7ig2QSF3s02q3XmsBTq917iIY9nK7u5gvnhI+I2Fr1Vfo9TuMFua0h+v8YWyoFb4H1N6XlmEvm69KGAuvlVkGX7B5K+OgRWImCxVAWbrvzZwLkr6zv6O6dK5MrYCEn4rpLxURCEXHOAofYiE/xt/8Z5P4R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

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
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/x86/private_mem_conversions_test.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index f3de2a4ab0551..cf50e9a332c5b 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -202,15 +202,18 @@ static void guest_test_explicit_conversion(u64 base_gpa, bool do_fallocate)
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
2.55.0.1007.g17ff1f9808-goog



