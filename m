Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79B1DC61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9B96B0095; Sun, 30 Aug 2026 20:25:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E382D6B009D; Sun, 30 Aug 2026 20:25:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3326B0099; Sun, 30 Aug 2026 20:25:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9666C6B0098
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 899A01C1DC2
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
X-FDA: 85159670526.15.349DDDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9201040002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mcwrx3xV;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135921;
	b=cH6tzUeziivrkQdrTtpBI0c0q3qSMTTFxMkbh5HtGfwtdsfUKwhSBIC5R0eaCMH3EQS3Vy
	OTd4qMILkkdbN0Yn2cit7Pa90h53G2NQ4FyavZTrrKWpMRLxI8cgT3OpkYOhocgB7GQTfQ
	lYOenemT6/FTTxWvNWiLa87n0ncZsJQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135921;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9+m4TCJ1I+fTDMCzygRLJuvvPZsywUR8jrVLVsyilo=;
	b=Gezm5lUQuW89niKlEtO/Pnbjj2pJE7IieYeaFs6+3x6m/wEGD8Hr5tHbsjIAmOc4lxT2f1
	X3xjr/yJuv0enZQa8PsUmVAG9wPgbvkw/2ERlAEnpJkPOnsA0sLAoZpx5BkYlgl80OVtV7
	5ImYjyaxjD1LhjQUMl7oEShLQ5U6LvI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mcwrx3xV;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0221943F87;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3CD2C4AF10;
	Mon, 31 Aug 2026 00:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135919;
	bh=yiocxA49550KUCzo+T/5GJg/8zdJWfhnYG1cFdaaNSU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Mcwrx3xVKrw7T1MSZ2sW1ftA1mFi8bY/BSWRzLgPsqEPrbTFpHguRcFKPiZJdqLh3
	 +uMrgEzTGPEViQTFLuXMKyEJB9fdZoO5+0xGd9BGKNa4KI1gWRcAv6bFweeCqyFSrS
	 bSvXhYUPEAWJu51b1eSpkQCMt8i3sgt0d//1XhxYni6GyF9dBWQwumlE2lNbvJVAeo
	 CVDqOKpdsolJOeE+bunKAJYHgWIkKk9CmbiyQDvSUWYLXMjBfOcFhoAcbZKzmIiw+D
	 KyzKr4IZ3IG+301E/VYad8pZz+LWpn4IvRJhVnG3/0bVHCvoOQM4mudvUpHPtEBzFb
	 eATcDh+aftF7w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F9AC61DF1;
	Mon, 31 Aug 2026 00:25:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:03 -0700
Subject: [PATCH v12 02/45] KVM: guest_memfd: Use kvm_mem_is_private() when
 populating guest_memfd memory
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-2-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=1236;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=J603Sitd2IbIuBFVZAUo4Wjqwpu3VfTvCGGSI7vmMZw=;
 b=z1YCMYJwV4u7T1sNVHAC3h7gI3Q7k56jpxSLyvJRX3D5GfhJNIFP05gy8Y0FpE9NEMLL/4MSl
 1WCUEPt1h8tAH7mYqnxVUByUNSnEvOicaThuXDmg0bin61FAkF+2Srv
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9201040002
X-Stat-Signature: n8mebu34i1ystm79wmyzapk56rooaii1
X-HE-Tag: 1788135921-526455
X-HE-Meta: U2FsdGVkX1+4rBbaML07Y9A07jadCM1vx8x3SdCFQOJR4owS59st/oP8NrIOjG/TNlwJQBYuOvtiHdb/31fJZKjNgs2J2gjZg4ZRRnDq6TrMN2tr/hWfhvbgcV0aLD3ctdT4jbSUiS9JvwwWnzK8jOz6XnjEsViwbCERq4/k7qelpgIKifW6bAuRGwf7vwOvIiA19dhDnRX3LPBH5hsLxBrA0w13Kni0L31Ll/nnVl596SxTuMNSmOdNykF37EfrZzLacQtgUSGaa69Az7gZLAQcvqfDzGX418JqrWTlMmmAes3jUBW8+094nWCuOjFfilX+zm+M22PFGmTHAAOu+OCzhlSpnu7hKCIQl2XS6IcAJhuSKjWm9TMu9zZHtWLZRuHiWQUNYwX3tcL7ZsaEHbDzm0Vk74HHO+XfaQt1oV83BIcnMwS/A5THSDVmPS6u2ZAd3kDNcmNgEr/F6IWRYIhcjwJLQN7QYcavRd4ORbzJfIvocodALoI36eYU8v9Pro8bTbl12vqp040svpYylFHivIejcBZL/Bz6toVT6VxnAuv6J9VRp7L7+dvXBma2Mz7Z5cGrkDsyldpK7ptFrka5ktbRM5IMSfbB7M8WK2NWE3tSe42u8Y1uLvLg+cyzkoJva5Id6c6t73G2gReCvP3Uj/f2XTQdAQc6Ga4vblj32WGtG+0fLvKYdH9e3LgZBvn5TsGqXH5/UuG5ffbirJDUwoW4io7AhrV0C08aCEYYHU9K+FfeaxSJq99W0iL9xeVut+3WmWvrcKKLyMEVivYSYDvV3fdKq3HkECvCeBK4sjzdWfo2yQme6c9oMNDG9wA//IaUFA+f+GQYhnx2TWVQ6W0zS4CtMdfmM5FmtgFGskdvVGh+JXRtJRErgFztuagqyJ22qrvuOG3LERlfjxvEtrMEPOAiNJw55af2lHKaVymLnrzmqbV7RNSf+WSK6kfVLr2SI6Uh6HQt6vS
 KgiwXIZZ
 b2XESKjKmuP6sSb63sq7ZHaXHLT1XEOJhSKwjGoImM0s/OOA0umq2uup0qAHkYDHnP/GcsUgj4FwNG/tJ+izcSUEPI9a5gxKJIwAbIQbxpC9tMRorWLbVZvksUjAH9lN7j2etbmsIsw0vgG7CU/a39xtBEXMeaxBG4RGk5Lk2DO374+Dtu5FS3oY5TKMPnpaW0knaABZwY+AFcB0uPvCtZP6Q7qCZU3voS/q4qmdkn0GJJH2V7zC0WFRn6mayb/ya52PqVbBU5FImwliR5VULckeyFW9g3qhN3F1OurzQCUff5CEAEkAUYjQUOo49QayK2xxHr54bhqCJIcQadNS/5FIWagKKXSbYhhhMRwfr2BnytlIzM3Y4j1JaHSPG3iQwzmLEGIpR5K/bjZGZqq8lP1QQh/J+9szewDyr+staYvOUrtTF2KJxO2SNI7UsH3V3s4pggCQ5TYbYsj0EGd9owygPXH8M81EsC6FgLbnA2WU5hYPraVpUofvgSxrCT4Xe8iSYuo0bTrV8YZiPnBHeWwvKbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Use kvm_mem_is_private() when populating guest_memfd instead of using an
open coded equivalent.  In addition to simplifying the populate code *now*,
this avoids the need to provide a range-based gmem lookup API in the future
as well.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2190e4d6b6bea..69612bf146be1 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -805,9 +805,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	folio_unlock(folio);
 
-	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+	if (!kvm_mem_is_private(kvm, gfn)) {
 		ret = -EINVAL;
 		goto out_put_folio;
 	}

-- 
2.55.0.897.gb25b4bd76c-goog



