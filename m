Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 716EFCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 13:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BC4B6B0005; Sat, 23 Aug 2025 09:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494356B0008; Sat, 23 Aug 2025 09:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9FE6B000A; Sat, 23 Aug 2025 09:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25BC46B0005
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 09:04:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C5B5D8028C
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 13:04:35 +0000 (UTC)
X-FDA: 83808041310.10.262044C
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7662F180016
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 13:04:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=lGMhyRDX;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=t+yANq42
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755954274; a=rsa-sha256;
	cv=none;
	b=QA5zdPQX34bkzcd1gpc9aZ3F2u9Tdl/i/RWEdgQ/2daW/LL2gaEoPsmXJz9ljbY6DSNidj
	8WMso2M3WFI0FvUMns8ZiHQRJYoUpIn7Dwg78J3Gcsap+YVBVq/3T8b0rJyMo9bC/k6EI7
	16sBtQyp5Erz/H4mzRW8RXRYjr7Nb70=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=lGMhyRDX;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=t+yANq42;
	dmarc=none;
	spf=none (imf24.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755954274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=USLZVbG5IB2ruAXTCfXR91VY562JG1KkktDhm6jAPu4=;
	b=r6qKB6E0h5Uxxt9lo0KBmo3PhdNdv1hxQWwP1/ZMQ0yuHMN2c/FThJO0hFmej7Dgb0J1Yh
	eX9QMVA5ywi9Rq4d7jYDdBiVt9CIk7xkozNjW3ItgP0WLJEF0D7LxAbaJdQ0ygqG1QSvP3
	Gf1vx2Dh4KStU/b5Cfap8ZFxmksG0zw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1755954270; x=1756559070;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=USLZVbG5IB2ruAXTCfXR91VY562JG1KkktDhm6jAPu4=;
	b=lGMhyRDXZcbkzhv7bOss7ttLInYqwFQtl+bu14RU1WC1NdRNulcGD2uNNgUNBjW3NjE/cmhHFT39W
	 16rTY4TYjRDjgmZqfH2wPxdcCo4PRRnuBf7jLAN7BXeB7t7uc/dOkVb+4XwR6wbbr9FWR8rgjnngqh
	 DYIMLL9r3PS7RNHAK96dSn55xG0TdZBy/vlHD7rm1fcyDOBjhPuarEb6ZOK3Y36N9l0NqmnW6ND9fZ
	 ds9NoEH7ts+fMbz2fijc6swe1AkR+qKY7g2LLlfWO8V5oQWqG7qqSZPanF/83T3iZXD3jyTjzzG78W
	 qxVMMkvfee5sX8xObYy+9EuIlH6huow==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1755954270; x=1756559070;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=USLZVbG5IB2ruAXTCfXR91VY562JG1KkktDhm6jAPu4=;
	b=t+yANq42VD8WcO2xMfB8ffxj2wGRZHsFaFAkZHVrzpGvnIKvr14YU6LCeQImb9MysuGZ9R+/vUhlE
	 Cfeuh90BQ==
X-HalOne-ID: b4200260-8021-11f0-adc8-fb5fec76084d
Received: from localhost.localdomain (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay3.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id b4200260-8021-11f0-adc8-fb5fec76084d;
	Sat, 23 Aug 2025 13:04:30 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	Bjorn Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	linux-mm@kvack.org,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: [PATCH v4 0/2] rust: zpool: add abstraction for zpool drivers
Date: Sat, 23 Aug 2025 15:04:19 +0200
Message-Id: <20250823130420.867133-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7662F180016
X-Stat-Signature: 9xeyruhxhrczt79wefframwepo5okjim
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755954273-767275
X-HE-Meta: U2FsdGVkX19T9/6Ze5lPavD5MOZxPxjzJ1DW1FZJhCgJt+Okvl7WDL5kgHwc4F+0kfulN+x3nA4GJfPiiZZQIbutGEGjTTc44nldMhwcSngwWkeM+Fn5O4GbC++tRuALYQaUHYgRuiqS6TZ+IemRuoH1rIAYnaCLqyFct9ZOJHs0fwuaFiSvAIsNWULhLnmC80f1zv4dZc+ykRiEcBuFpRRppIM8H7sG6QIuEv1CP8jUXf1wTCAmxMGudSiumXk3XWxo3sY+C6o+BBiyeNAsWiaTaFWIOESOrZdozskgN0Q9jrMxtQVZU0WImdxassqUBuZcsMfKjo7xAtnbobzqldaVGInhsXNgA6eQAUVr2+hqiMQ8aIQiFyHAb6fPBTRpcOEci7/gGFdVjSxyB/O464eHldzq4gl2ulcHSw/HyEruYuB/WxHbLkVPE4vM1l1lYwyTTMp6i/nad+6xzkbeVDvBJgGJ/FaddcHpaseDMQYaJ+iZpc5ib2LwegTEmz8UdGVyMOs8slzH3PColzo9bSQKqaLYT5jgfuAKTRx8FeY2OJa8QGdQym6q+rxLrR6uCgtxEyUQoP4+Rjng8K7J0UY+YOGtMsnf4uO8WliF4fwnnw38Irs/JuJ3VaSJJSSDlDhtZr/rMy+GEmhPJvpFZmd72DgaKHXuOIVbk4rPc8K+TdYbyT21BcRwWDbKEKWSDl0R40lNy7l2eKimbhR2lHg1pni5RC3gdan8KHAkehHhsRJBX/+GaOnqDDtW+B/1DEtDxUTEijJsJZs18e7NjtFYZnEr2Yd+JlbT0RcMl/dLDi5V3z+ENgfLZ+bSuF9/+LYrARLXd2Qg9pG5cXxX+u5aLa3cxvsEWj+shwkwP86J6Mb6GTLDZJ4xfFPTd8DRDqEDmHzhgjFOXSwad55+BUuGGAKyYZ3PY4dv4/F5VOfETq3JQLlAsewgw1CqfzA+Jznm6GkgdPwP6dX0lJs
 FQInA5uB
 Y/o/xUAzle3VTUHHtjMyvYR2QnZir05j+mPz0G/RsmDkM81E/eaV8wQ6Pm0FqQLZ6wSvk0Hl5BzTZrovVo2zparuAArravvYNtYG5r6Gg7BNkLZIAbara6j4QIRVSEyI4SVeYwmHdYBAU72+LRU7kzR/Bqp9Mf9saQviZKbsCRcP7aYLxm5Vl41rPHLA8H+xtbU69Cy5phmIGPDKIMdXLlEb9CG2g7wNeQbOt2ynlLuu843Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zpool is a common frontend for memory storage pool implementations.
These pools are typically used to store compressed memory objects,
e. g. for Zswap, the lightweight compressed cache for swap pages.

This patch provides the interface to use Zpool in Rust kernel code,
thus enabling Rust implementations of Zpool allocators for Zswap.

Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
---
Changelog:
v1 -> v2:
* reworked to stick to the existing Rust driver infrastructure
* removed raw pointers from the Rust API
v2 -> v3:
* detailed safety requirements for unsafe API functions
* removed unwrap()
* some typo corrections
v3 -> v4:
* added a working example of zpool Rust API usage in the
  documentation part
* change to Flags arranged as a separate patch
* improved safety requirements for ZpoolDriver trait
---
 bindings/bindings_helper.h |    1 
 helpers/helpers.c          |    1 
 helpers/zpool.c            |    6 +
 kernel/alloc.rs            |    5 
 kernel/lib.rs              |    2 
 kernel/zpool.rs            |  338 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 353 insertions(+)


