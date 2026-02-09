Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C288E81BCF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EADF6B00A7; Mon,  9 Feb 2026 09:39:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC206B00A9; Mon,  9 Feb 2026 09:39:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EBA26B00AA; Mon,  9 Feb 2026 09:39:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7266B00A7
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:39:44 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CC2C88168
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:44 +0000 (UTC)
X-FDA: 84425177088.07.097BA23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 54C434000B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i41dtz0x;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+fVcIweGod2CQMuqXxo+qtno3UMnNWk2sK4IfiqyMY=;
	b=lzPt3GP46bkD3Map/k9iaF3njmMSmZl9QsQCi9LDTxhm75VF9s7z240TNJqg3plaFqzGb9
	5bRrZx7+VZ7MOUNU/xCyYNzeARtPxlOCmijFbp0/1cCc3Do6IuTABGr4zU99F9skej2RZV
	w38pJ+4FuJ1e6YGQDFpIdNbM8tKxogA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i41dtz0x;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647982; a=rsa-sha256;
	cv=none;
	b=SVvl5weworMZYHv0UKonqTjxn9BA18josM99fKA+duEJTgNX9Bq9PnBCfJLzUEw4UIcBUr
	khXFe00X06spXPTB7Niy/LJ9DC9+wjmbR6rww5HLRYUeB/dxcw5l/itakb+OqlGwh7wZda
	72/Dp/M2lbRbH4bxXrdx0jjRiYEJc08=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D1B616011E;
	Mon,  9 Feb 2026 14:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDF3C19425;
	Mon,  9 Feb 2026 14:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770647981;
	bh=VslDN1mPgFIPh4fOyBZhDN58qjpQH9gwwiiN+krVdpc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=i41dtz0xskrUok+uzr6C0WdKfzIZ4fXVrLBlLxCOk6zIViA9IMUrZWbY4l1jTHyiH
	 8q39lKA1o3D7s+vHLG0Y0d55CSJg07xGLYt2EcioMSRA26dHW4F2IpGpyZF3YbfTJ4
	 IatdZL1SyBG9AcRmkDKbpQ4Vk1r5jImqLCmctbbD/RjqXMg/ZALLuDtp9oXJ+/ET8B
	 diWzf5VRTxiBdln3n3NORvW5jFAxjCw9DzAj5uhdNlAh8GPJ8VQ2TFstZ4QbYZ72LL
	 8n1pq7Sd4Tu4Ru6x8Lqf+X3j6sD6mG11ePNDnEAZAYar+jyK0vGujiBqYt/t9d4En0
	 77w3TEOXo83XQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 09 Feb 2026 15:38:16 +0100
Subject: [PATCH v3 11/12] xarray, radix-tree: enable sheaf support for
 kmem_cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260209-xarray-entry-send-v3-11-f777c65b8ae2@kernel.org>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
In-Reply-To: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1243; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=VslDN1mPgFIPh4fOyBZhDN58qjpQH9gwwiiN+krVdpc=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpifFex2+rby13jaJSZme2/vU05ZzvMRP5UT6SK
 VJQYMHYp8qJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYnxXgAKCRDhuBo+eShj
 d7xHD/48WEALFQfX+iMYXsiR/Mvn723D+YBjt2TOR/yfD7Sul4d8Iv02lIm3LGfCJsyUqsx0R/m
 Qk2ZkCueXt8bvCuSssHdX0jFMrBRDz9DFgMbk5SHMC2hLN/W0x/AY4rHDH4HxWqA/09V2h9kX9l
 by7veoXmADET0BEbdp15OIZLrP4+TbK6Md7Y98gcZZZZgKfyOgrWD9O+wZSe1jT4JSNrdw0pHhK
 WEiy/1R+bNnLAmMOP7AjVxTRKZ5SQafFzXZwe1+F6+mZe2saG8I5hrDR+VxNKisA7vQl9/z3gF1
 XuYWSv6bLte0vcgMNpzi5111T1Tky95jqKotdLtHq7sO+hUg0IAm1sGAzEr848kitJXmQWyyp8z
 RtkHcd0kwQ/15cx2EZjuMGm32TRs79hH6cCTfvmf4CweWaQmqV+mC5uohtBCP7piEWMy/RrA1lx
 Lk8TicZ76wcecqeZ8TeDdarQAI/oVX1NO6bP4HKm3wcdjn2HDq2AW5m3Ss2RyH1ZoffhLt7eyAY
 HG8F4YbEif5r2ab7bGc75ROxcp9b9NTzghH7dtSdy8YrkyjeZNU9Uc1uq1KyyHMibe/jKSjYmPP
 debQlj5Vy7aICDbaFtI+SvG1jp8hcOSvnmatndAdy79kxiL25JYhXQRUaqy4lc6Xcs8Um0+KbQA
 EVG3kWV3B6ysnbw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 54C434000B
X-Stat-Signature: sd5tigh1meygc46rg5iw3x9t84b9t9xk
X-Rspam-User: 
X-HE-Tag: 1770647982-51429
X-HE-Meta: U2FsdGVkX1+7oFBuBRK5Haxio1jtklWqSaUP4LE69FR6et2EywVE4mE3UmqhMpt56ifmJEBRWZz6A5iJQCV1w40xLb17uFL7+7PVU+18GAEJxbR9dKq4r0aizUk6fMAkdXVbSsJ3Os2IJ0wN4iI6lkkpGVJ9t+te1wZfNeT7SyQ6BCJF2cpOFdUeHvAqWhyMQ+I4QBddsfKRBt4x3wBtwOzhtOYGGSNC7U/5KI86t40bBzL4qecdUixGHNQuluZWpca9lJRrlvtmiEJOupn7CJSA/9RusWiPv9jq0G5ry0eaA+EMDiCFQQ4StpA9OfuccGfvf48nlBW+5t7yvMlQha7xqOJzfC0IQlJ17uJqAPf/RHosCCVXNhdEFDu8+KTr1Je1wxyu01ryHq5IMARZm8+RRf4GnyRvdY271lLaia4PhOXY3ohX2msh3JIvGIuY2dFC3CD0VHd0tePiQJaS8NuTtgt5WiHMnQqV7UbDc6fYjrUbhzhArM4TKtSjFBq8zyTFYv1C4iqvYs+XcK5uNxb4Sn6TF0hXyvr1tQhu4bK2/LFFIclN5JIikKiocfDXjx0TzwJgS+qxjY9T4flzR8TPdSeJCThwFQhN5O1FuYk+vU6o7nmKA/zrYwkN5KiGe5tK1ru4go25hdYku6Td/QFTgb8Y2isgfbzzOlPtkrEVaXpLPtSXuAiPacP5pYXXFdG6zWPr1BPswQbr2e5jGkV5gyFNmtYHnFemLitD8IS7EBU4HL1Cu8X4K2KI+4rTZScrAc7NBo438gtxsvOVdIW3pIQyfKIjgGytQG1hYZQNguqheQQz3Lbb8jId2+otxlKuJit7CkEWtTHWvz65aKgXQnFPBch5Q4C9D4iA16/givi1AJKCkPLkQrV1DOShIT9QU6DcKPKqQLLFzApXy5hj1YQx9wTbOdtXiyk0d96LyVsZQbweVJvexDif0fRHDEaEZ5T7+TShuVHGnTk
 T0diPc/o
 jNYSuM4UG/cq5SDesgqdW4q4k2qNOt+dZ245tRRTr3gRLP3qEvoaQfDZLht5NiIvqbTQRm/Pc46Wt32wgaTUL5Kh0qCqspuJCYfPEqDkhZFIj8JWhbYzA0IH/g9xsm+m/TwSPV52GfQAtWTYah4mHBk9RinuWShlGCmTMeVlezxdZN4Cr8Ob2ky1HUb+rbwin4olxv05Xl+qRSuaN0yF0FbmcGn/DCarh+cgNDG6ZDWs1/EipjDfx6VizCEvT6k/Ppme+wgfelH7qY1MqO141ZDYjUCItb/4LKw6Tpjq6fMxesZ2a46w2V5LF30OVODcAoZF0rDOtiSJ88BgOjd3xhh6yE3W7n1jBCwn+YbaXPsLSUqENQM90PkIaXc+oCseOvKqKUduvcTvHPh0Gzk60YHVttbF/dDCVCqjG8owE6pGMYWs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The rust null block driver plans to rely on preloading xarray nodes from
the radix_tree_node_cachep kmem_cache.

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 lib/radix-tree.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 976b9bd02a1b5..1cf0012b15ade 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1598,10 +1598,16 @@ void __init radix_tree_init(void)
 	BUILD_BUG_ON(RADIX_TREE_MAX_TAGS + __GFP_BITS_SHIFT > 32);
 	BUILD_BUG_ON(ROOT_IS_IDR & ~GFP_ZONEMASK);
 	BUILD_BUG_ON(XA_CHUNK_SIZE > 255);
-	radix_tree_node_cachep = kmem_cache_create("radix_tree_node",
-			sizeof(struct radix_tree_node), 0,
-			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT,
-			radix_tree_node_ctor);
+
+	struct kmem_cache_args args = {
+		.ctor = radix_tree_node_ctor,
+		.sheaf_capacity = 64,
+	};
+
+	radix_tree_node_cachep = kmem_cache_create(
+		"radix_tree_node", sizeof(struct radix_tree_node), &args,
+		SLAB_PANIC | SLAB_RECLAIM_ACCOUNT);
+
 	ret = cpuhp_setup_state_nocalls(CPUHP_RADIX_DEAD, "lib/radix:dead",
 					NULL, radix_tree_cpu_dead);
 	WARN_ON(ret < 0);

-- 
2.51.2



