Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E963F8E49B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 01:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B256B0088; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FC266B0089; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411AB6B008A; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 304966B0088
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4A7B1B8FA5
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:11:33 +0000 (UTC)
X-FDA: 84666270066.06.7F5AF73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D30AF40011
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:11:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=korg header.b=xIkx54yG;
	spf=pass (imf04.hostedemail.com: domain of alvin.sun@linux.dev designates 172.105.4.254 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776388291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=f+XV3HBVFqmddm0D20zmCWTkKU+KIutrkInxVbGBFbI=;
	b=O7wPasjyrEYjMn1JvdouvD0VEsqX0s+CpmTOi0bPXStqsqLEtLjocvsolDFGB7nOWr2HzR
	qiwmDa7ta8/SC51t18q0t1Q9efEViZP8824SjK52E2n09NQK2GILvxUy0XsvoQbvpJN5DI
	vat8rtgq5UttG2IyXQhxKtkKfFQxV00=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776388291; a=rsa-sha256;
	cv=none;
	b=lj/D7DdJOYZGmpYH8J24YwcPNPCPVMe1LgQobHxuouhWHPcHxUMenFnHuOTqcOj61lgSaZ
	LgpvJHafg/MAKu8CFVLB5tA/isTArJLZD3r4AhEALGdZ4J1TCo/5M49ux0+TWy8O4a+8k4
	sgixcwv3QrKpbWV3kHe6+zgtouK+FPE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=korg header.b=xIkx54yG;
	spf=pass (imf04.hostedemail.com: domain of alvin.sun@linux.dev designates 172.105.4.254 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BF5B6012B;
	Fri, 17 Apr 2026 01:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADFDAC2BCAF;
	Fri, 17 Apr 2026 01:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux.dev; s=korg;
	t=1776388290; bh=/Cf9gBkTGs0FZ5AznLGhdvS5YDnnQwX3P349kNzrw9s=;
	h=From:Subject:Date:To:Cc:From;
	b=xIkx54yG+l+fsrJO6vtLWeAtvaTYtSLjJiTh4SaFFREUkQgviAL7LUatHnVMRG7RZ
	 xfFqSStQ1F+zlOtOFmBhQHo8mDu0Nm09l3hfvDoWH6QwTyaXr0rUuIwIJ3o1bubtGk
	 zxZAApKznDWOfRu9ft97JD4F7ZboQqARVpSQcwto=
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF62F8E49C;
	Fri, 17 Apr 2026 01:11:30 +0000 (UTC)
From: Alvin Sun <alvin.sun@linux.dev>
Subject: [PATCH 0/4] rust: Add helper functions and constants for Tyr
 driver
Date: Fri, 17 Apr 2026 09:05:50 +0800
Message-Id: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAG6H4WkC/yXMSw6DIBSF4a0Yxr0GUNSYpuk+GgcUri2xggW1D
 +PeS3X4n+R8CwnoDQZSJwvxOJtgnI3BDglRd2lvCEbHJpzyguasgPHjwTg1PgJoHAJwUVGBqNs
 s4yS+Bo+teW/ipdnb43OK8LiPpMcQ5AbXyTG6glFasCKjPE9ZlZcZMHg5352dnbz7dtKmGufTH
 7/KgKBc35uxTuYypeCVIM26/gC2CSe8yAAAAA==
X-Change-ID: 20260416-tyr-ioctls-deps-25805eedf332
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Tamir Duberstein <tamird@kernel.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776388289; l=1591;
 i=alvin.sun@linux.dev; s=20260317; h=from:subject:message-id;
 bh=/Cf9gBkTGs0FZ5AznLGhdvS5YDnnQwX3P349kNzrw9s=;
 b=i4mDcseJKhSLM3Wmo9o5QqvFYc2hmQPNSFKc/Hhd8iVYttVa+fm9NC9L6xLaF8ihLeg6DcVOi
 +KGN4DjLo8ZDsRxgNHYvGPC4gGPODD9s7OEi1gcNG4F/w2qfUi/eLj+
X-Developer-Key: i=alvin.sun@linux.dev; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for alvin.sun@linux.dev/20260317 with
 auth_id=684
X-Stat-Signature: i1gcghar7sk39k8icifr819edzh574jh
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D30AF40011
X-Rspam-User: 
X-HE-Tag: 1776388291-215928
X-HE-Meta: U2FsdGVkX1/5avc6QO4QvmWsfI67+zXBRQN4WHKCg53E5zcFkkPDQMWB9g8cHQ0SOHKQ1lwDYt7IZcAzegc+QJuELDwE4V4qtDPhH5CLCKVNYbBa1pK0pW6eD3J7HFskn5auihmPd6mxVEiYLSeM2WZEvUSUmA+L5nBypAC5NrHURTVhM+hFY6EiYy9CLOIa5yxmVmO0y6007PVXQPJx3ph0kZGBC+OrnBFPusJPC8kPAsmvCaylHkb1foikWScNqYKbR8+Rnh0bcPAlLrmr9CwT47UpJpkM8PO/BNmf3MpHZ/JULy97uiJ2n18x5mBMypez1MynA67EMOPW802FYChkE3SSe6MxT4IUnNrkXKBJHR2kal63T+y/6wkjONBXMYHh17XQKljwpDg7vy2iAjBbKpS209TRv3Ov5bHal9m4xmHkgGU6iMXQ81eNuu3bfDO70LMXhbSRBnk2SmhEXIRjrOnVlJjVBug8E0yFAulpHS2Ar4gXmQK1uKbXkJw9Cykw35y3I0FDQxzhIsC8MKahw6UqqNgkfuL9MN6hFhvQeWTSkuonuEMdlW12ANfLwqNLeysz8L7Th5veVziqgJmWgG1NSD0VxgmcI1mcs1R0IO8frYRRqld8Gq2PhkD422RzVewD6Og4C9NlqNzspNP+zlz0o9X9w6NcW+9Ufhrdne7NFjZpNbHqZeOz8F4N9GWEM3BTzvtfdHY1PZftSc/83dPrbp3ZA6QSTjo2Mb6VAvrySnLRprNZAGGdayyewmZUB1tRpF0c5ouOzNss/J16W+6lDuGFBu7xGxT69mCGAhjtQ0rWspov0FVAm79N+9QpLbCMVl8eFB37y+B1SrABZK+ZeCbet3A6uHceNpXsYNg0IxPi9zbqxhifKW0eJnSEz52Y/12SBQ8ADmcIEaeRGmUBR9q4JvdYAhSf/zis/8mSX4B9ncnqcSNZRGibREc5hYfJ4/exrzwj9Xz
 kL15vyWh
 gDOtQd4rHRjVo+3eMXVqhbfJPdMkkV8uCloDA6B5Tm0IAHA26fTJc+A4H+7kAUIdSsxgS0P6r3npclamblVrCL1nmP/qcAYG430WRseedF7DbKukvjhfwtb/v7TVFI30295zFPZ89SOrPa4peP+AMspV/j+phjhzmei+8N0C5XQ5NgElA88vaKyD6SPcU0AyPflx6MiQ0SsmD4VJx7Ymfiz3UI4+wr/n0MiILin0dvzGLxKNGbSyrJX7RsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset provides helper functions and constants that will be used
by the Tyr driver's VM and BO related ioctl implementations.

These patches add:
- SZ_4G constant for VA layout calculations
- A task_size() method to Mm for determining process VA space size
- Updated StoreError comments for alloc() usage
- Guard::find() helper for finding the first present entry in XArray

This patchset depends on Onur's xa_alloc implementation [1].

The complete patchset, including the Tyr driver ioctl implementations
can be found at [2].

Link: https://lore.kernel.org/rust-for-linux/20251006163024.18473-1-work@onurozkan.dev/ [1]
Link: https://gitlab.freedesktop.org/panfrost/linux/-/merge_requests/64 [2]
Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
Alvin Sun (4):
      rust: sizes: add SZ_4G constant
      rust: mm: Add task_size() method to Mm
      rust: xarray: Update StoreError comments for alloc()
      rust: xarray: Add Guard::find() helper

 rust/kernel/mm.rs     |  7 +++++++
 rust/kernel/sizes.rs  |  2 ++
 rust/kernel/xarray.rs | 28 +++++++++++++++++++++++++---
 3 files changed, 34 insertions(+), 3 deletions(-)
---
base-commit: d1d81e9d1a4dd846aee9ae77ff9ecc2800d72148
change-id: 20260416-tyr-ioctls-deps-25805eedf332
prerequisite-message-id: <20251006163024.18473-1-work@onurozkan.dev>
prerequisite-patch-id: c472a9548969ac774d36fead73378961a0d0489c
prerequisite-patch-id: 63890b91e911cf96cb42308c056d639580ac0fa0
prerequisite-patch-id: 337eb93db35359c611abe9cba299e6ab0525a2b5

Best regards,
-- 
Alvin Sun <alvin.sun@linux.dev>



