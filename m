Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D43160843BE
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F75uEguT
Received: by kanga.kvack.org (Postfix)
	id 5B08D6B05CC; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562D46B05CD; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477D16B05CF; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1046B6B05CC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4CA0A7BF2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:09 +0000 (UTC)
X-FDA: 85406458578.30.EC38075
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8DDAE100009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F75uEguT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011827;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ReU0Kd+FdZN68/M0M8cDAR0IDKP7C8zpUFj1mjltVuQ=;
	b=gMyrMCevj2NbpVOfMiPKIguwKnho5r6sQ6tkUpDve/yI7ZACCODh+gJkG7hOQTJ9HT36b2
	dQz76DwmZjZdbUAMQV0s+HWhESKskcGsu7XhLkea+J52Q7vLimlvHjNVHrEoeu32/UQZGz
	XAw4g2em6n4FkHGJ4adlumQSh1ojiQo=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F75uEguT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011827;
	b=dDF4mqPXWEkHglbWDAC/3Xftycu/t99rIFCcndx70PwhFzglmZINGYcsrpEomXJY68kROa
	ojTUdiw7N0VMPEBRgvs5RxILFwgu0S/9QBOdcLu/A7hAjMQK/P6G/vzd6HXogw3iwhhOLJ
	BRKusWOrhdjvpHKpdzVUfr/T7TXwGbE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7CE0440B7;
	Sat,  7 Nov 2026 00:37:06 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011826;
	b=05hxEjhEqo6TvNbe5/8iJxieooxXKUZKhOzJBq23AsnOnI5tSbhzuZ+4sLMXis071Nni
	 fl/NT0mHeIJ1aw4ehxfOmw78CptWMnMEwcPCB1INRIL0SAWY9NxdBEHnyjhiPkxxkPEN3
	 UetotQ275OHDoU/+ncUEAm/ToGVLYHGLP5gjcmOiG/S1xHjgFTcBoJ/LErLm4wYJYD9AK
	 MHUAUKnPadsCWC6rbIlP6UTiafZoXoLFz34ZNygq+dXF2GpJctvTBbi1/6ePZQi+RGMc9
	 gcmaasssLjE6FWe/2Z05kFgIJyz9E43apeS7ZVZ8uqI/zlfEyyhm+MR8bWPi2z2ug/g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011826;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ReU0Kd+FdZN68/M0M8cDAR0IDKP7C8zpUFj1mjltVuQ=;
	b=zj+jbU7dzpnKmpF3CZ/l/SkqwmeK76jlYHq6Ubi8oIt9PhR8cSOxY5BUY3sfv0BUenhH
	 1jUOimltu+lTt0xnjbBnmxVR1/8xpX04iUzTQPVXJu+o7iYwmJjLjTY+MsmCRU6IkZxFy
	 xiXI6nruMMqWFDlPVBpImWcZnqsfCCaFslALf4C1/KD+XVQBgaIgUZqUtSZjGcKr3eQVZ
	 cSMC0p8dUbjnivJ5ufvDeD3SSICWL9hTlsSX35716viscDpBNkGSX4CcARCQpOt7UzcUi
	 YNctGat2XxQJPJ5Rc/+dE9MP6CzjmpK+QSwtIdFzeBbxhJmr391TcfBvXEECSEf8VqA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9D7861F008A6;
	Sat,  7 Nov 2026 00:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011826;
	bh=ReU0Kd+FdZN68/M0M8cDAR0IDKP7C8zpUFj1mjltVuQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=F75uEguTQqAJ03WhlACLIRO2diPsETAYhJCo12G2j3JlW1G606YrIicyLAfSJZt3U
	 Wl/AoXCSkF3oJFW+jlylucMvO1VE4eE7Lbqk9lS+6JZnvPIU8LDDic8rN6ByuDwt63
	 oSSgAdSuX0wGgFLuM39z7F5Y+myaYwLJ8kXb4MkwJ5VdzbqgYyLS3eq7ul8NXkX/uT
	 VbhWJwIHCp3hz0rkiDO56coeRdJKpKrT9hA6S3C2bm65TFC2kSgZxpnmUVuEjzPG0G
	 BOP3A3raKASJpxDQDkZIHrA12le/QgD4Jj9yKKAAW2aB2e7bZekyai/BV8nSYQWHVP
	 mFB8tKGBFRUBA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 66C09479A2;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:10 -0800
Subject: [PATCH RFC v3 36/88] KVM: guest_memfd: Clamp hole punch range to
 inode size
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-36-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=1715;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=T1L8Nqi+JAoaUb9Yx5e8qDpkaF/OKb1FzBs+jwYeM/M=;
 b=4gV4aRNMilBvg0nqyt8Kg4QHKxmtpIyDoHFAB46oLSBIQhuWagSSLMn6nq9UF/ZLeSvyJZ1eW
 jOa0E0XXB1iAfvQ6IfaTdKRmpQRRW0WZutOkaFwv0I1tgcjtp4U/5YM
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8DDAE100009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xhc7nw7emdxnge64mi4eqh6sex4atata
X-HE-Tag: 1794011827-628663
X-HE-Meta: U2FsdGVkX19c5tw4+fBjAyUd9LdQ4BAyS3+WKxQ7OHeWpkC6XEl9HWbF2wdOyXYsh5kkeYOUQ8cAtA1ZvbnQhu01S0Gq2ERg6EwtLejaLrImgg+yhc8TKonfJS7uJRXuC0FjpzJuhzv/hk+fNuuMaAvIZzJFRnuYe3BQe5IPTHq8brT9OdJp9QgqH7ohcu8zw4DaJlfIJIf1vOqTTViVm6XlGE5qR2bE2Rf5Rl32a9oYs/pdR6iXC3uWrv/8Z5SpcXHsk+RtC+p6zZXIQEzJT/t3YW4WPifY85IBp7AXgbKrc12BvY8b6V8WnVd9cuE9UhtzozWZgLXkzlvqISQVXMNgc+NDt0fTAG90MU3hdORpgJRKOEfu5BdiMX2aET8sIOh3LAmnC7aGEnxnU2Kfi7wbwtDxl7kMUikFV9q1RozGbgC8eoMIFoRtq7jUXE1P8J5FmwIYGAsJNML4X6f3q616C5k6FiNVjZRMRdCjac9HdUvk4PfRLnlNHwbYtazqXhGvd7YB/9yFEgnLn5ROUEWn1xRnK/0Yo7HB93HaiXm27gGqn4kP6ToObuA98ftdqS56JgjA5WpVrC1QBl9AvZBJCdoeP1Qcg9iPGYkfU6aYL0mUBS1U0ruVXMW9oH04FZEFHvS+2/Z8TnoDp/DwNzVcMUVd2Bmg37GRQKyxg6h2TM/2nOqflgUAXRSvHp/907GGWpkx/rWN1kg48wABfDDOGVWv9uBxie/Mkm59fOyiGAi78f4jXTl/LCdwzweA3gxVUErbQ0qMw7IiT7we4BW6ekin05RBMBKDJnF2BHWSBhrqMPGF1paPabrh6BvHdTW4tCekCkz8P7T1qDfcRdN3kUnx96M/fv5PpFro/oglNth5qQJOuSXICgycZvglxoiPmcNCq0N0mPKApY48zrDkZoPZui1lw1/AoQFc5V9J6M51H0q/jkTyeHPvLxXqH74F2niOsCF3zPq8w5b
 b5ATFu3m
 3D7KWS5b9ztkWJJ0PKHMOSAWLgmFRiAGpMumwdowy3OtsO5S/CS7CikNJmPcfDII/E/OdcKNSe0Pd5L2c3Ko80lbMPzYeNjl/L+OsraUC3R0YhyjnKF6n1VOg3F1hW/hK1o3vRLbnDQrTXDJBjH0L6kMZYA0GrSZDc13eMbWguXWjaQIDIS1Krieet+9fZrxELQGGkzNkRGMwdnsurrUBR8WPn7Fxf6qAuIH/34CQ1HAzdBCJJflJSALigdCowiTF+1i+vPYB2ON821jwhIb2HwiudAX4pfLATJB9YvHQwDYpaLD9vWxVb9QFkUVlJHdl5+8Otnl7ZCo1LfDWQgYJk5FWNs+dcdPNoBapEv3rPxE1pTDGiTHuk3iWt4XInNzU17sCP1sKvDONFK/UmztvDH3RJp5ACbCGTS+9v28LlEUVpqOaBaIlSBMfCKfQYoAm38pzqY/j6ZYgtcNX5M80BH8cIWjwY8yYBAVtKuYxyGlLR86s+K5S9C/nX9Vg8qeH92AVdltW7FOqRI97yEpNuw3FsBrY3wT29YAftOFtYq3qSCNOgT+vNcrkqh0eYp7N6ymonMnAwbkAKybkn4TjuTn4+6aiuo06MMcWfoqZGP+pAr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When userspace punches a hole via fallocate, the VFS only validates that
the offset and length do not overflow the superblock maximum file size,
allowing ranges that extend past the end of the guest_memfd inode.

In folio mode, truncating page cache folios past the end of the inode is a
fast no-op because the page cache xarray has no entries beyond the inode
size.

Prepare for PFN mode by clamping the hole punch range to the inode size and
returning early if the starting offset is at or beyond the end of the file.

This avoids, in PFN mode, iterating across a potentially huge punched range
where the provider isn't even providing that memory to guest_memfd.

For folios, no functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index c62e15e05a249..9e8204f5c2588 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -388,8 +388,15 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	enum kvm_gfn_range_filter filter = kvm_gmem_get_all_gfns_filter(inode);
-	pgoff_t start = offset >> PAGE_SHIFT;
-	pgoff_t end = (offset + len) >> PAGE_SHIFT;
+	loff_t size = i_size_read(inode);
+	pgoff_t start, end;
+
+	if (offset >= size)
+		return 0;
+
+	len = min(len, size - offset);
+	start = offset >> PAGE_SHIFT;
+	end = (offset + len) >> PAGE_SHIFT;
 
 	/*
 	 * Bindings must be stable across invalidation to ensure the start+end

-- 
2.56.0.455.g6c5a503b38-goog



