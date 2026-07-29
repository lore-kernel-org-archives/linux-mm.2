Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00EAAC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8E9A6B00BD; Tue, 28 Jul 2026 20:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40076B00BE; Tue, 28 Jul 2026 20:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55C06B00BF; Tue, 28 Jul 2026 20:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 913CF6B00BD
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23442403E7
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:26 +0000 (UTC)
X-FDA: 85039945452.19.04B8168
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2E3D14000A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PG7GysUe;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285324;
	b=h3h1FfWqu+HO/NA8hAThrJ0wJ98S6wb/JxmIPh7PfGzecQhEcZBL7Dp90U4dSQ3WZtHlpw
	MMEsMyCwB6sLLfypyGTNradT+mX5f158knrxzrI2WkFTaGDx14TwdYJ7y7xtQv2j7EnnE5
	vh1sEY3PYeY00IPU5V0aOpul7Ks61fg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PG7GysUe;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285324;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHqYZiMqx+XxUXtTwi7iJvh0ijZ+oinETIQji/n0Qyk=;
	b=uub4IAGwM5ZhUHYCxfRZCiBHUeG492svkuWw9Gr5khf2vS/p/y4haEUMthI0cT9eCifkKT
	Ulu6p3HassokikKg7XdFxD8b0rlj++jaySRAydnFOSIz9IW1LzF6kdjA5ywR8OXHb7c9B0
	zo4O87xkq7DoDDA9t8mXyEB5sVSjl24=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D80845169;
	Wed, 29 Jul 2026 00:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE9E8C2BCC6;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285311;
	bh=dUxhahixXodKkkWOlBW+L0qW/rO39emKN5a+oGP3P4U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=PG7GysUeDVwcYpF80vAtc1osSrCx2keDW5CH8/KxgkSIv5+UiAZ/nuOFO/EY1MMNe
	 5JQgKpMmx1WIzRaVuQBcSJfKjoMrJG0FrccqD+N5/9BYjFoW7PMXpPZ2jCNN7MVTBc
	 3WJUZ6dhYzYtVu/195tE1DKMUUr3b73NHp0Xe5dubVKmVsu3gY9wuJKoKH8PZjhOdn
	 u8Scudtja3T+MpDQbWvVv9HX2/6Y96Z3811ViZVgRnqBhi/pv3+aoM0CHOSoG8544j
	 0ENdtMC/4cxWYqPYDtbhBjsTHobCvl0f6U91nif8MCJvjIKJCBwzlNoKD3Lq5KElGx
	 aDQqtnqG+oA4w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BBDC53219;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:35 -0700
Subject: [PATCH v9 36/41] KVM: selftests: Reset shared memory after
 hole-punching
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-36-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=2579;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=RaRWHqvIFGDNVf8kTFC5mcsFKgVELgo1O/MRar+r53A=;
 b=Mn8pKi2d/cuRy/0F7YrekY+4oomoVqJ8t3zan8caUMZuc1uIS3bZQpuwwbmmBDXKIyqbM7ewX
 o/j64fB4VnhB3qi6gJzsO+epzRGXgTCA2QoTPExvLHRjaVWIpGiTX+k
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2E3D14000A
X-Stat-Signature: aenp5or6wcirts4hc4um5c5k9nptq3f9
X-Rspam-User: 
X-HE-Tag: 1785285324-796488
X-HE-Meta: U2FsdGVkX1+FdaVcBuO32BQugIEfNmcIW5R//KnB59+8HtMOFbLhqAP+aabQRHUUFBD0TD4WtTs7eSIAQw8PtfuXV8o0aDmZxBwxIfjDL00UPWcyC5rrZpz+lItbE89znEzkPYmKxkGt77ibkzjYykn8ErVncPT5urjgYw6C4rEBUxvgCzxMsqUVae3clXPtslcbnyWKWaZouR8P3ffNC9MDdsSgRIQ1d+cJ1wcgAWl0N8PGsxiXBhJF8f93QQ45r15k1gx+CCFehqie87shdyQb3Ac8a5m0qOXvNviBuW4LzzOxf17w+vCnpQEspmfAb/skn08c1Tim1oqhrF5+LkDzaDD1PB+RJJAM2FNTzHMLTWGV2yoWOVBysLtGfzsTT59l74DYJvITxqCNYiAbvev6kxSJzy/sERIDljd3xQ/nIAivn64VlmIUFxvQWpGyLUXk6LrKbWpTYOGf8AdZlzA6araQdp0g8NNM9ij4csRPEfQ/J7U2Y3dd1wf+rwu54H6RTXV1quQfYo4YwtmM7zco5yKRiLSFnpnl3jXH5NyTMEofLkCmR6rohmB43REQ1/90ZAt9OK8+R00onNyUWoYVwpYxcx40iiBulBktaEoKhAgpmjE+SUB1phZAVZhoI3ttG1VAexo8jP3LrE+Cl5aUQfkMSwpBsqU8mhlMzLXKh0oJ/sDZwVbGcuS3aDHlubkW/TpPxGqRr2zBd9BoI0RCTlbberzDXb5cVzZZi39GJfehDVb8ISyiHv3ik8ZceZUr3e3aLsYB4bRACuVRSS2nPCOw9TTaCSinYmWl2NsVSZBtfjCWNGwVW5YYxQbrxuKywq+1ohwzpxiu3fhqEjMv8OCP74rcKuu8g+JHdnb43cTolBR/bkR+w4QiNqXFLbr9XMQ+NZwMgQUSda74PH2KpDV7wDelsEPshQ8PsALrE1TyammUMGyUf9+8Tzvo5hGZPS22HifcYOZafhU
 TSJqZ7LX
 vCSZU1Sa0FQWG/YrwFOKdTa0b01Kipyd+c23r3zIMCRbgmIfkhYj/ALKBgIXvyGo9G4zhwzOCWF6l665dUo4DqSpEpoAdXUHYzRmlGzHqnRYYT8YHLKtnCTJp9mvR509UisqxHpXuTJskxlQh9+ESpmO513jCWndcyorWYobcVojZxDqH3NivluGtyX6IH/1hATyYxfh68Losg/1VLzdpneXR1CrC7Ef6wqvcuIpHtlczseYGPxzkLtUObxoStyY1i+TDTwPiRAD+IhAkQVETRsjt+xHq0IS97zw6kb5LU8WH8KeIo/oJ5UxtV7+OQ5/IxjrcOqDr7QQ3nnw/hRH5sJNi5WtmC03f427XioZ0hjpKg2Gn7cv5c4YaHWdAf+jo1x7eDVlJCeKwuvBj9HcTBkYgSrTI797iT87envFdW+ByNjQtwgPv47yjfVN4SIteb+GgmaqDostL/9+EvflaqSwh9+13DTvi6bCNCsfKdKDzmrDeC7Jz0pgfRh8xzHHmFKckqoHCnNCYUxg=
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
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/x86/private_mem_conversions_test.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 861baff201e78..289ad10063fca 100644
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
2.55.0.508.g3f0d502094-goog



