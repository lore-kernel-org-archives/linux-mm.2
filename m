Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084A6606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 20:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jLwS+G4h
Received: by kanga.kvack.org (Postfix)
	id 8050C6B05B3; Mon, 23 Nov 2026 15:16:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6866B05B4; Mon, 23 Nov 2026 15:16:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5D16B05B5; Mon, 23 Nov 2026 15:16:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B93B6B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:16:00 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D37C809B9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:15:59 +0000 (UTC)
X-FDA: 85467490038.29.2FC5F37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6F5174000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:15:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jLwS+G4h;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+me.amir.fyi@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+me.amir.fyi@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795464957;
	b=fiTC1xwOoI76YoWL7u85pXI98IvOEJUR38de7jPqF7Lutep1Jpn8c0lU6LYVSOvZaLbdy1
	mG5z/d3XEAQhnDmKKLTJD/HQJL8QCvy4rtutCKr5g+FgcWp+0kKXa7oiPcahHNgspisvuz
	+ThgAnFjJoJah2Jjm8eErrxAljI5gsg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795464957;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=27MlAWo/OUwBzjsWXnjeRgbeMFRpk2w6dzujp5UqCY4=;
	b=WCMPAPY/u6EDIFPnu6eoNL6V59NC21xJaYwRMVJxUYQmnj7b5V44WkGq4Oa8Eiu2jTWPOO
	/ZyH/MzqDgEgRf6U+YO0r0T6z/iKB+YthlI+a7RR3f7DSMfievCNbzbyZZzJQVVsbgxzlD
	DDbNR3lmJW2kX3kS7T7v1j5WykJ9yWQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jLwS+G4h;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+me.amir.fyi@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+me.amir.fyi@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 273BC6189E;
	Mon, 23 Nov 2026 20:15:56 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795464955;
	b=LUSmTbpnnUIkHWVZDHwN2l3X/q07bQZhmuakB9azMsQHLc/AQ4BPegpZaeybqvA8z+IN
	 jUSs+u5yBUthV9JlZn2cM+iTTVd4piYyRKtnPOyt2KvFjoQLFCGIQ5PbyFW26o9n3J8b+
	 9sOZWxM4rZh+heSCkaxTjFU4FNRO8K4tdV6ntM43HKZYbQfEkyoE2uaPun00ZFUoZN4S4
	 nW0yVhWC3dFAPW5BEmLJx5wr1OumHx9CzciHY3+PX5yFLlH2SQY3Wk5/E0qoz558a2H8e
	 xCVsajUCLnd77zKQ+AWE0Bya8znxrKOtsW3thLH4qWDHFMKOh2TLjRMeKZck7uBYFHQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795464955;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=27MlAWo/OUwBzjsWXnjeRgbeMFRpk2w6dzujp5UqCY4=;
	b=k1EDxZSIWQ70f3HlKxLdgvol+bKPNW2QfM+9sugdTaNNUWiLJ/TICe5WKeI2zqB4Qky3
	 3iIKjNaoeMQZFLg5PJMaNq69GYPSZyKoWAV1iFNoVIp8fxCtyYMVFxIGpJFT6ebtJuvQG
	 PJLQF79ly3Z2g1YX+G1jxhbt/gyEmuKpsaliZWMmnO8bcGwBVuyfmEIzMKIH/jhZ5kU17
	 /IB4dd3pwxjbNwUrWoHtIKVd6h1yCcp4DawjVYKM9DVSH4Ngsoiun84qZ9oknzs0E+UKw
	 MPq7kM1CkKpriMgD2ochyflPKJ//VeC9vgg2jZml3wirdMMMVSchgFK0hd6VZ1t9zNw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id EF9641F000D2;
	Mon, 23 Nov 2026 20:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795464955;
	bh=27MlAWo/OUwBzjsWXnjeRgbeMFRpk2w6dzujp5UqCY4=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=jLwS+G4hs19SFe8V7LSddFOuxpB77Aysv8hGY9u+umSFKG40pabOWKrrBo0a82jrQ
	 q98qIlCIDgyZUtnSOlgsRq4eaaOgTkKZcoZRlyjggIAScje0rQ0lK9a6aKVm8mTGbl
	 rUXbwT4aLG4JvhL3Lb4vaWHAuUoqyJM5IIvy9QEI9liggQwbTUsOirMO88gSQh4nfG
	 a6DwWm5kT3QkY28ZUsFzkYZrQSnIGBK8Ddidy4lnsuVp5dz82p1ro7Kqn5+Owwb5RO
	 D9W35k1YEKOO12FYOctUolIjKD0EKUaDNoWEPMWG1vVVcurqnN5Z28HrgqJ8R8A7yd
	 b1lJHyACCfBqg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 82F4A4C6AD;
	Mon, 23 Nov 2026 20:15:51 +0000 (UTC)
From: Amir Hosseini via B4 Relay <devnull+me.amir.fyi@kernel.org>
Date: Mon, 23 Nov 2026 20:15:49 +0000
Subject: [PATCH] mm/mm_init: don't shrink large system hash tables below
 low_limit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261123-mm-hash-low-limit-v1-1-8a803aa8ac70@amir.fyi>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBBA0avIrB0wSTHgVcRFjFMzYrRktC2Id
 2+sy7f4/wChxCTQFAckerPwumSosgAf3DIS8pANutK1UtpgjBicBJzXD84ceUNjnXEP660fFOT
 ulejJ3/+z7W7L3k/kt2sE5/kDSiF5bXUAAAA=
X-Change-ID: 20261123-mm-hash-low-limit-37a3a47c7cd1
To: Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Eric Dumazet <edumazet@kernel.org>, "David S. Miller" <davem@davemloft.net>
Cc: linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
 netdev@vger.kernel.org, Amir Hosseini <me@amir.fyi>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795464951; l=4501;
 i=me@amir.fyi; s=archbox; h=from:subject:message-id;
 bh=WPCrCh616UcUkUJ0vkYRNurwFSh+B3LJalviBGxSKIY=;
 b=dDXYaITR/9+vETOai4ym8o/T+Iz7M6pTmCu5CpZPCow7sXOPhxBS5s8oXwcLtmoU6p46fwI7z
 YjAnvL44ac6CW5F+m6/Es8JyJhJtkMJGiBgn0mqyBgqXnUp5a1xuazL
X-Developer-Key: i=me@amir.fyi; a=ed25519;
 pk=YmuzvXl0k+J8pTqIG0kjwtCeJ1ggyIgBHm2jFmzNbeU=
X-Endpoint-Received: by B4 Relay for me@amir.fyi/archbox with auth_id=1620
X-Original-From: Amir Hosseini <me@amir.fyi>
Reply-To: me@amir.fyi
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1kkbwd94b958hprfxs5p8hi655g5mxz9
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6F5174000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1795464957-796824
X-HE-Meta: U2FsdGVkX19hWZOYEwRa02/4m+2Hv8WNuqpF0Z493IDr4hiWAwjSYqbhIuR/G52b8tspxcIKmJfMQ/Q6FE1L3oLxBm+OFa2/wBT0Cr9M0YGaj5dHsz0KKBStk5RvTroIM0D33laLZiqXZStMly4bPvfY1W8J5kPudXuX1WPFL4rTZPDe9FZ1Ig0cy1Ow5sWCu+ARY3cN24840UIfb868A5fLveJJ2wtSFHGBmbq9Fp6F1o7AlWj0kaHxnyAz1fNmYZtTeviFHa5MOIBrIHJk4rICctW2bUBQHyrg28T29198Tymisnnw6FfBAqMlBeYfG5NAc9DzmmnrKRZKR8k5SGXe9y2ulH+2kwJO0EoGJVJU8UDntpj8keEt2nKub/mMmKuJwkuG7rWNdmzv9gBhpayzy8l+YR+W3epo0s3RPDA7JRp1rxszX/v5OEnLVvnEXrDoe8m/Xlt8aRdbz3dmSgGX27FVRjNjOvxhQBtavPYerjKbblt4uaLnt76h1xdCK7CpASp2Zmb1inqzXUexpHT1ycWrnloBk8d/vbei9hXuRQhKSn0Vyw9/J9zlHISL6RTmHlviNftQK4r3oJvDZayN5JKT8wG5HtYVv7nI3GEHvjk0p5pelA9j3ay3uFDlufOhtFy0CPU4J0HlQKRtWAmgysJmLpPTzb7wAFSq+Q9B9D9NFHakYoHYfv436NEZj27rSgUKjlHxroVBH2om2OO994mrXYb1J/wOrpvClbQc1ZZMs/ML3f6l8tqzrvjTj9Jd0Tw6h/3YFshczXBwbB0bkrmnxD5xDZLLZmY1jf0xc143iS8n+X5JB+mux/5TAgGr1VWufNLC0T4V3KK++lBLwNjJ8jP9Ui+pvn0y5eVaQ/8kxH4TDYiW1RbV9a1pGO6Gd597R+3/XNdHExaxSE++phZlkATh7Y6bnz6FyIev+PoZU+6qrzwgme/8u3gus7EimimX5r8TcqMqEZO
 u/JALCKa
 jR4e7qzCgXbRRcAwc3La5ets83XR5vwHlFE5Lj/HN2qzGXE6gAzlBpcNDMivWStpCBIzHs8P2q3h+9MvpE/uJnubTEvLVSs8wlJPoq9ukLFoZRDTx4fjsKSxcYOckheJPjM3RyHE7C7SfD10n7NtagwqNxL8Gy5vmtNU0Lj+PYittmqlLjs1VTUJXNwNwn+M0dI64Ubgna8H/J4zuH+hKhdWtdWGIhsQjIpBdR3YRJvi5OZ1GamGAUDNLAbmXNl/GYQqRE1rYBa/ukNdxyyC3aphFycD3KZ7rJVO7oGSGxSNKLXrAl+aX4CJuBmJnd2yXnmI/zeO4qYYkPGSbwmeIrEU6OXaJxrJB1ZIePqEwPd2+gWgdF+NGYJE0a4dMYxauQ1zG/UZzaSdCcCe1pgdefcgWwQpJgW1N+BsXwbCtMa6BRaA0W0K0/EDOUi42JTd7OQl9dTPQ0/pvGPb2OwbenaMfN7dSjGo920JADZOUE3pqcEVCC0IsaQnqj0DlomQAU9YDpvRiCPx2VfGLhnFufAu8tCQtGpsWIUCKVfuVW44wQ+sIqA70pehumeVBL3ZQYNGja25v0sUk6Irha3VrbwZkr2iuZ1miAyauujXFHvvkwoJ/YHulXT/p/Nviw1sk+xOcWyfjSfKeAmuv38gWiShi11f2z1GNB7WqllJP4+efsCWxxEa+NAQT1E+zf1Q2MGfT/CHv+Eql0ISvaEanvjhG/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Amir Hosseini <me@amir.fyi>

When an allocation fails, alloc_large_system_hash() halves the table and
retries until it is down to a single page.  It does not stop at
low_limit, although commit 31fe62b95866 ("mm: add a low limit to
alloc_large_system_hash") added low_limit precisely so that callers need
not check the size they get back.

The TCP source port perturbation table depends on that.  It passes
low_limit == high_limit == INET_TABLE_PERTURB_SIZE and neither
_hash_shift nor _hash_mask, so it cannot learn the real size, and
__inet_hash_connect() fills and indexes INET_TABLE_PERTURB_SIZE entries.
On a single node system hashdist is off and the table needs one order-6
GFP_ATOMIC allocation.  If that fails, e.g. because most memory was
reserved for HugeTLB at boot, the situation commit e67b72b90b7e ("tcp:
use alloc_large_system_hash() to allocate table_perturb") was meant to
handle, the table is silently halved and the first connect() writes up
to 240 KiB of random bytes past its end, typically into the TCP
established hash table:

  Table-perturb hash table entries: 32768 (order: 5, 131072 bytes, linear)
  ...
  Oops: general protection fault, probably for non-canonical address 0xe480dbf6b420b3d9: 0000 [#1] SMP KASAN
  RIP: 0010:__inet_lookup_established+0x168/0x5d0
  Call Trace:
   <IRQ>
   tcp_v4_rcv
   ip_protocol_deliver_rcu
   ip_local_deliver

Stop halving at low_limit.  If the linear allocation still fails, retry
the same size with vmalloc_huge(), which this function already uses for
tables that are too large for the page allocator or when hashdist is
set, and which does not need physically contiguous memory.  If that
fails too, panic as before.

Reproduced on v7.4-rc4 in an x86_64 QEMU guest (virtme-ng, 1 node,
KASAN) by failing just that allocation with CONFIG_FAIL_PAGE_ALLOC and
fail_page_alloc=1,100,<space>,1, where <space> was measured with the
kmem:mm_page_alloc tracepoint so that the one injected failure hits the
Table-perturb allocation.  Without this patch the table is halved and
the kernel crashes as above on the first connect(); with it the table
keeps 65536 entries (vmalloc) and the system works normally.

The reproducer and fix were developed with the help of Claude Code.

Fixes: 31fe62b95866 ("mm: add a low limit to alloc_large_system_hash")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Hosseini <me@amir.fyi>
---
 mm/mm_init.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index d99af80ec752..418068bad006 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2359,6 +2359,7 @@ void __init page_alloc_init_late(void)
  * - it is assumed that the hash table must contain an exact power-of-2
  *   quantity of entries
  * - limit is the number of hash buckets, not the total allocation size
+ * - the table has at least low_limit entries, callers may rely on that
  */
 void *__init alloc_large_system_hash(const char *tablename,
 				     unsigned long bucketsize,
@@ -2371,7 +2372,7 @@ void *__init alloc_large_system_hash(const char *tablename,
 				     unsigned long high_limit)
 {
 	unsigned long long max = high_limit;
-	unsigned long log2qty, size;
+	unsigned long log2qty, min_log2qty, size;
 	void *table;
 	gfp_t gfp_flags;
 	bool virt;
@@ -2420,6 +2421,7 @@ void *__init alloc_large_system_hash(const char *tablename,
 		numentries = max;
 
 	log2qty = ilog2(numentries);
+	min_log2qty = max(order_base_2(low_limit), 1);
 
 	gfp_flags = (flags & HASH_ZERO) ? GFP_ATOMIC | __GFP_ZERO : GFP_ATOMIC;
 	do {
@@ -2445,7 +2447,19 @@ void *__init alloc_large_system_hash(const char *tablename,
 			table = alloc_pages_exact(size, gfp_flags);
 			kmemleak_alloc(table, size, 1, gfp_flags);
 		}
-	} while (!table && size > PAGE_SIZE && --log2qty);
+	} while (!table && size > PAGE_SIZE && log2qty > min_log2qty &&
+		 --log2qty);
+
+	/*
+	 * Shrinking below low_limit would break callers that size other data
+	 * from it, so fall back to vmalloc, which needs no contiguous memory.
+	 */
+	if (!table && !virt && !(flags & HASH_EARLY)) {
+		table = vmalloc_huge(size, gfp_flags);
+		virt = true;
+		if (table)
+			huge = is_vm_area_hugepages(table);
+	}
 
 	if (!table)
 		panic("Failed to allocate %s hash table\n", tablename);

---
base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
change-id: 20261123-mm-hash-low-limit-37a3a47c7cd1

Best regards,
--  
Amir Hosseini <me@amir.fyi>



