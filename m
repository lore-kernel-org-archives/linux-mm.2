Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C2E6C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BED7A6B00A5; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4B46B00A7; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF4B6B00A6; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3D66B00A9
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14461C078D
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:58 +0000 (UTC)
X-FDA: 85254083796.10.0C13B76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2729420004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ne5o860R;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383856;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XxcYs4oRky6q56rDTURnAVAnEpJ1g6XaPRDEKF8r0c=;
	b=GSTb/NMwLNI/ZAX4/EYnd6Aw0yCHzlWa9ijtTSYwDrgoSWHhP6e/uJ7aMTbcgLQ7iKvkPH
	8NyzIH9tF5DHAhCPmS7oI0WNlwYG6kTvzq1rjCQMrBO5BoArM4lR4bY8XJ3I8GuaRbY8+B
	imStV2MBLoUKG3vsfCGFUi65wXXHrDM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ne5o860R;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383856;
	b=TerBiP7LfI1FJV0+y9Ad2K5bLXEtNwVyQe5m3V0HHRke2LhvH6CE2mU9hY5e5vvrbEmdqy
	tTlROd5q2Nkk8O9VivXLX0ob+1sIhXBDTiV0/2pBPAZ6G3pVd1Q2+DLdNS3KPuiCj6QzBA
	lE8WvD9UpVGTMKMON/VVoLGnnd7GC2Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A79944819;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B592C2BD00;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383852;
	bh=CucdfZJ5/85W8a22Su/Z2GlUAjLT1OZjtxKxL9yuu3E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ne5o860RKYhFrnwbDUH++4v069HuXzs0E3w1k7y/IyEMOCV4Xi8QBpKUCkFlDd/xI
	 WlV3FIXeEI9cIM+ILxgEzL23nrSB65be6AWlCBrEeMKyfZ3m8XVFmZDQkuQgjmii6S
	 9YfENZj3n+jExUgPXaFeUWpuUjP+AYaFdMyj41qCny93zxMoNRq40ZMPfbQhDNDMZD
	 QyxUCoNlti6pGNYuyTkhOjEsWzsUz68xsDzZVy/42SMsYu2RtURk1mkS7V+dJQW2a/
	 LdlHd6DE8ZU4IbwrB62+eRmZlr+5IRsgbGGOr8nXpzWPakdgVuRnHiibn1XorTqLCb
	 RIgPKaN2rJ8YQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689E6C9830E;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:51:04 -0700
Subject: [PATCH RFC 17/17] KVM: selftests: Document testing TODOs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-17-d36159822d18@google.com>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
In-Reply-To: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>, 
 vannapurve@google.com, erdemaktas@google.com, jxgao@google.com, 
 rientjes@google.com, fvdl@google.com, jthoughton@google.com, 
 tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev, 
 Gregory Price <gourry@gourry.net>, David Woodhouse <dwmw2@infradead.org>, 
 yan.y.zhao@intel.com, michael.roth@amd.com, suzuki.poulose@arm.com, 
 Christian Brauner <brauner@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Nicolin Chen <nicolinc@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
 aik@amd.com, aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>
Cc: kernel-team@android.com, kernel-team@meta.com, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=1099;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=zKFuTq3Amq3TlVl+Ae6LwDfBtexGkdVicUSVbrDs3Rw=;
 b=D5SgQu2KvK/CN8bmAnbeQJqiDr8hZKAUtYrBjvO7ze+1Wl1dU9raEmcyKScXL3hs51t3QYlt9
 k3mic0lnyeeA1v9aJ7kZuFyx/opXA3gFDc8InOKEYvCNEcaPlQDJKRu
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2729420004
X-Stat-Signature: o4dg4hke3op7xoq3czg7wkqmq8rcfzz1
X-Rspam-User: 
X-HE-Tag: 1790383856-111762
X-HE-Meta: U2FsdGVkX18BzRfSPkDAfucNEme7HZzCY6OKw6ern4TGpErGN1LP+H8c7wIDd3DNYgGsjgm2PNGTziet4zwtV13HzTHqaRVq86OZw7JZA7SEqe9ZkXOcA1WIqeJRzKb3BXvWRPP2kicbo+jBXWhfMljH/m9MzdBeGRw6ZuZEH2g0YAYvyTJ9HJaFqhYUSfsHSnEngb3hRILX1U4I+YkeVhRIZ3hzTxLsVMa45gJ1oYc4Kv9t2p47Aea1s+cPgwFQ5dSWKBs7gwhQaIhD8L/32szz4YvRqb29evGuLmkrY0JkYlFs/8KJJbY5nli4Ivz/MdHeYoB4R+nczv4b+WO4kn4unajLr4FOjoDE64hMST3Hr2NswyIyF6l0O5siPFkxInLW9/P6UFMTaqxk60/uu6Mblqfr6IL3ARUyQT0ZUPcUJX0XXzNyJ+XHKWZeggik+26kOX9NYXTTJz2vKvHVFVfNr2o00hVgc6wzLpU4895L7N0unciJ8QxF+yw4v1r8Qc4vlqiym85cTrZNDl2JrJ63bqPh8TyDVdiJZeV/hfh14bmHjBx7Nkoz8i8wnuIYwiw4aF/Ld+5aCoKtB0n4KSr64g1GZROMQsBF4YsCiBW0ukUp2ZkVhbmd/ENDUk1jb0pEVVjKAow44UNzGTw4Xnv1vOpV/WsWNq0ktWA6Bx0/DA+KQKZDkahCdlJNfs0oYQjgRWwvJGTwp6n9I+81ilUvxG5hYrCrZgT/ynXDaoSG4S46SEm5piaW8Z2W0QwnV2wDLwLfPQYylRk11r03N7F0gZb+bYaUUw2JQ25JsC56nTPUgxbc/PvCQdghTSPCYoGWkmNwNd+n9Ng6DMh94TQlHtU0CUfBMSquxgfHQJIH8WB/X9br3Gnu4ulZSRcCWOoUsiVM2Hm9Mhz/JTwFKSM1dho1K+0rUNKjEaDMzQvWInIJRuyYT75nPP5chasnwjI2ztn/QDIA1PUmhn7
 iRvgl0gT
 GYffwZ5p18TkFluk5AZNKrDUUup+OIttOrU1Fhp/OpdGMyk9zTcLDGcQZMZM1hFQr6JTSDr6FsPpFv8P3NcX5P4K0GuNVROtav6qOarhAjWvP7F3uSuFcgAMNgDZ5JTS3zgPeLm9if9rK00N4OLGMPPrLmAUTukEgTSZLajIIW2hGo0wpCxrsdpBCwdcExr3K1FRCHcuZ5cElr4EkPtxNT1LEuwNHijqnDDFkdxxqqy+eB/5Pr3LzBtyZAzXs5SCwzKvh+m/FHFVrrPQpk9qZqS/hD9wUEcdtVN8pLqgbV6E7zY9NGwDYUMST77PmXuNTnKpC8MPVNJwrCXZoK96KCM3ovIIqscJBtupxXZmBq7pDNoBNuzSgTAcXRsxeoJwfmS6YCZfMedP4y8y1OL4E3HmYP345clSw5oPal4DwnuTel/X/vG2CtNsJpBxrgQQ4wU3A6vvdwACeWOjkBjMRzT4ZW2inA42DPPnWphsOPNNyeJo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Remind myself about all the tests (A)I did not write.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index bf369874f2647..4e5d00df899a6 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -721,6 +721,16 @@ static void test_guest_memfd(unsigned long vm_type)
 
 	test_guest_memfd_flags(vm);
 
+	/*
+	 * TODO: Test that guest_memfd creation rejects a read-only tmpfs mount
+	 * (e.g. MOUNT_ATTR_RDONLY) with EROFS.
+	 *
+	 * TODO: Test that guest_memfd creation rejects an ID-mapped tmpfs mount
+	 * (e.g. MOUNT_ATTR_IDMAP) lacking write or execute/search permissions
+	 * with EACCES.
+	 *
+	 * TODO: Test mpol fallback to mount config.
+	 */
 	test_resource_fd_invalid(vm);
 	test_resource_fd_unsupported_fs(vm);
 	test_resource_fd_tmpfs_file(vm);

-- 
2.56.0.rc1.315.gc6ed9934b7-goog



