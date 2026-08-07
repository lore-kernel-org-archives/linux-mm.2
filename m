Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8319C5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44BBC6B00C0; Fri,  7 Aug 2026 17:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422586B00C5; Fri,  7 Aug 2026 17:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3B46B00C6; Fri,  7 Aug 2026 17:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E145D6B00C0
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 80F5E1601ED
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:56 +0000 (UTC)
X-FDA: 85075823952.19.0628E29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9A5871C000A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gUAugGbu;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139574;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAHWmXQWScA4KoW9k2rj8GhwFi5eX4hW9749TTJfaq8=;
	b=swWwUsqv/pUxVlrwZWIG5mmQdz6mtB97whiod9Rn6njyQ0XzH4lgPmCS6pS9TeUvHXjDmc
	2tPCdjney2bxsRIyQqLGTVOMkwnHpKkj+EFs/H3gwOgVFDTytbeuQ3SvYdS8lSVdBlt7rh
	96tpQNy0urwzFHHlHO/5PrUEe3gV7oo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gUAugGbu;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139574;
	b=APTQ8+86O0deu5QVB5mjmLD+Xt3/miuYbq1F7PGkYJ64y3g4aRy1Of6l2Wd9pKLNNTfUdh
	SOO6gQjEFhMCIc9gngBs0pb9TYS9LsVOMuO6GjTjrNs8bCEAnf/ORLUki049PLdXdPxcQb
	I4fzMQ8nwpRUTBHG8gmJDqHduUhok74=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E1EA4513F;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1B1CC4AF1D;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139569;
	bh=vVlB90TkMEPlFOEarnxtlCTdvt+8JBrxx/lS7exZXfg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gUAugGbuPkp8W/LWiGAXRpzlNXQ33WRr6bDE5WalAitW0UDZ+6ib39LpnxspJWvme
	 CuxS92eb7WjwNcJY0NPjuCsATUGRpbfoZxMaAZLH2r+5MUvbDcB06bhbR+Jurz/QNU
	 +A7DGERCMSbbZ8L3ctwR9fZn6cPhxfEAHh1r98CW0F8xwkQKxcLsyItw6aGOv1nKHo
	 4BvKooLoNBNNze8CcIH4cryj1CDLlSw0jgy4c0re/6twB88C7j74lW6RzGsBPUnlUw
	 UYQdDuK2vX9QoV2pOnmcRyHZmyJpcr8Bwmr1gyFbbXfTA+ngy/oRMYu2lh/81EbduT
	 oV/mwyr2fIGng==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB54C5ACD8;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:52 -0700
Subject: [PATCH v10 13/41] KVM: guest_memfd: Return early if range already
 has requested attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-13-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=1860;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=klJ2px6Wqls0hGacJ6oWy+P1esd5PU6yM+WgWOJIUsI=;
 b=0vcu/MCQmdtGPWXOU8t4S5wJStaSMSvivJsV/Xl5Og7DLO+sy8ItmzZsKMw2S/tvGBDd0R6fn
 kv9xs7ln6iLBrXgNjDz8oyAG22n3GxyCUR0wMu/iTJCQy9zQht3v4sP
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9A5871C000A
X-Stat-Signature: djhjqbherryt8rui6rkgicx4u7shk6ye
X-HE-Tag: 1786139574-569214
X-HE-Meta: U2FsdGVkX18b7O//axWM+BddledqbL5RhStdGt4WHCnjQUR4Ls7dr+zPFAAQLloeskBriBhYAJo05/obpmhUv73xwe+JIuHk4gwtLwLCURMG7Srh75/qH7NPsogoiVwSeHV+hzL1IwnaWQYInIU0w4vMFkNF/TgS6szzWNOaIqu6dxSKJhwcqfM/eQMEH3fmuhX3Rk/guzuC1pk4etDBm174g/O5+20klSWOonn9Hl/72/ucusigHArAXa3r6fVHQBaLJGh1E/ahQ6phb5FqOMXx5SxYtb36lcQzUvWKVLUsMmBPF2kOzHaUtAfLhyESudYi3GIl+a0+/o49G/1VGYySQHrErHijMaTvn83g+KJqMIPbwV5OTh5o2Acs5nIEmQME0b4t8AYoXfhdwb/reJJ1Y3yRO7VxJ3/iy6NAkg0E/PO9FYrIpg4lGY3NSc4ayqBVzx+26bjB3oDXQsOBf1vh8UN49bQ2T3TfxWJ1Czui1bwNr3TV68TfOrZk+KC2s18N3z74pp4t4DS/5JrOKf7lqAy11JvSk4sahkSAPfyaBuA6U8HRFM5m/vpij5pHWpoqXzmFhciunl98m1d21DS23htq01cdUlWvNjJ5llm+swB29r/RnpoYcgTEeQyfggrHf3z0u8rr70frDmPtNdN8r+YBscYsEh9GkefUsnS+bdr5TWApeuHS5RyeF5QOg4l7OBm6GAFFrX2IWIrDkaSBdw2QtpFuMWRx3D6L2sWRtid/IsqY5JIPB/uRzjJDUqltCFfzedkM9ZHQhGHtwCbTdAwk4R1IpJI/Pv1xfuAEfU8TKp5LxkkbUcf0yWBDdCV9191/rKZnSdx4GkNAV1IuWp2pcpxmcoirM98yOR8i/v5deBqj8CXYqRVjhPAMRK6/TMKBL9P/y2S1q0cd1jwElBS7oSE8TZ/0kWEruEU5J/+VrsgMddr9wDTWJtIluzuziyH7KwJdGK2MdhN
 8a0f3d/h
 XYDg2hfNr9CCkCw27tCukWGYVk+Da7aMTtYEELBQTMyO7rueqZWE9nYMKEeoZmPH/6ZOjvuZf0L7pRksTA+IYWxi/rZiUcBSmKIJk9pbyWGL0333T+NOuVu7gVIdAeLh9Rd/yw3X+OdXkuTaSSIUmPv/yzg95xXIqG7EEkCgtLfwDHC0qlTU4ifOrU7Z1NmuBXAB+y9yo20TBFHi76CaJ3MqqPHeJB0JMmnkD8ERyi8xQA5uoZYV7gVVBggX5ogPyrKUf+Eskvmm/0LIU0RCEaQRIFjq47fqBlPkgPQ/7GHYMpAIf8+wVxQZkqdYgiNAclegAczmpyZ6Xcr0Tshi5WkbKU5Lg6k7VH7s5bu1d6nlUxSOf9buenxuQBh7FxPMHLgCBW6KnRrYjnpWk1bmHAbgZRaGo5eZri8sa9/yS3svFm/T6dwItrBNwex8fNV8o/4yS0PDE4aFSqR/EY/ct857xE37IbGUgcz6+97/KO8xUrdDvflqPia0iAzu9EYKv9OhdF7asPXzNTh0uhH3EjxLgrWqvlYIEFchYDiZDgmrqJ5/X0mZhAE+pPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Provide function to check that a range has given attributes.

Optimize setting memory attributes by returning early if all pages in the
requested range already has the requested attributes.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index c9874bd85c5d8..896699afcad9d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -95,6 +95,24 @@ static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
 	return !kvm_gmem_is_private_mem(inode, index);
 }
 
+static bool kvm_gmem_range_has_attributes(struct inode *inode,
+					  pgoff_t index, size_t nr_pages,
+					  u64 attributes)
+{
+	struct maple_tree *mt = &GMEM_I(inode)->attributes;
+	pgoff_t end = index + nr_pages - 1;
+	void *entry;
+
+	lockdep_assert(mt_lock_is_held(mt));
+
+	mt_for_each(mt, entry, index, end) {
+		if (kvm_gmem_get_attributes(inode, entry) != attributes)
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -605,12 +623,15 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	pgoff_t end = start + nr_pages;
 	struct maple_tree *mt;
 	struct ma_state mas;
-	int r;
+	int r = 0;
 
 	mt = &gi->attributes;
 
 	filemap_invalidate_lock(mapping);
 
+	if (kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs))
+		goto out;
+
 	mas_init(&mas, mt, start);
 	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
 	if (r) {

-- 
2.55.0.654.g21b8a5bc05-goog



