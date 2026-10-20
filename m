Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8304F60A2635
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FupvrTXL
Received: by kanga.kvack.org (Postfix)
	id A83D66B0147; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5AEE6B014A; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EA026B0140; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5466B0146
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9845408ED
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:53 +0000 (UTC)
X-FDA: 85342321386.21.4435BC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id B85C41C000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FupvrTXL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf20.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484751;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=e+6nVyZLjebD5QCGUBHeGP+gzXckIy/LBOsLfc7yS0k=;
	b=wum+ER5dPzPd6eJGgGXwUKdNZZX359XacTIc4jVCuBHzOFyMQz4IbiWDcJOJQZiEtWAnNP
	DYB/O73PCWdgvYKbBGa48Rsu1XkPHD9+dqzpEi3KaZbEcrzrnNVWTg6eo5hvV3+XSmNrPs
	MBNBERu37c5/JzFi39XKYRuD5zSsK+k=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FupvrTXL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf20.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792484751;
	b=oDXq7GgrqnQ5sTbtF8Nj10XNJBva0oJQv6c2dAqqfaH2/tVNYoqbUUXMlfcY4APRn+rcV9
	jAQ3bupLHPZBARmTJ9kg+VFShAMzY3kO8fily96tGl3x9r1eol4nhDC/6wKBMcLY6mdVdc
	obtgNtOCiw5QTmycJ4HqQ/plbw2DBC8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B19AF4482F;
	Tue, 20 Oct 2026 08:25:50 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792484750;
	b=zWaNAvCmp5xdHjoFVqp/S2tloPsgzZO/3AUQQLGH6vRbHIQAIitTaf3p5sKbxWq0DoKF
	 WN56UFKdp4tNTSiRwtSIhoAv1JHDirBq1fP8FvCeL6AJyP27G0BYuzegVmPUq/zdGJvK7
	 1qHJVF6G72GF4Kt8HiBuqFsspsMW/ZiCjI7EbSkeHRxPLvMqSzFMtv+s1GBiBYhzJuSBK
	 ydQjDARS9RJG5IfgNEC7fdXqF+Trem4hejZvCt3WXf2bNIZNaVeq5V7wctm6TGUCykVxg
	 lNVgtRQzQwX91/xclFRFNYddKRv0QK9CRzKo97U5PcAHSOFGA/oHJGspLngg9V9kg2Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792484750;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=e+6nVyZLjebD5QCGUBHeGP+gzXckIy/LBOsLfc7yS0k=;
	b=pqlQPlQ7VIlPFmsp1K1e8pkIf3iIOOBtoagTpqL90lfUy5BsjEz3dGEsrY2UnJaduBwP
	 gJm/RBH/jpzrHiPsUPrRlsZoQYSsFYDYd96KlORE3saqTfHgquCl0YSIBAUe/rTgU1/lO
	 46mTxToN2A7FUqrPLhmr0iulRztQvRP8Rmqcolbi5kRHszVSF+Myp7XZ0AJbq4Xerrevn
	 Td/bdlUrIjEtyIZD50pyFsbAi6UsXr/5LiTclocerpBN2Y43TRIpsIbq3gUwc7XZLzkUD
	 1egnirFHAu7hRHraX6zdLvij9x9GVGml1Q4qpeiq4MPamaS/WL8QOQslOJtOZJgR54A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 44FC21F000C5;
	Tue, 20 Oct 2026 08:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484750;
	bh=e+6nVyZLjebD5QCGUBHeGP+gzXckIy/LBOsLfc7yS0k=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=FupvrTXLH0LyxcAiC5Xh4k52MGgHqL2LniyJyWZ3PTCjp8d3Rv9FXaQ+1BpKr2mwM
	 kQcOFNxiqR7+OMcHRCW8JXZvIcIEd0DQIdq3SVvFepgYZcJ06gREA9H4Y6frdJvra3
	 dBZN7IlJOLNY8Rqj6lLZbTRf2nBiD64foNGx20h02Ldl8q+MNiDd7SmpRTP3xvxL7s
	 cCt5lX/dnp4GzNJITqXbrRehsFezw5U1YVLruqNu5le80gesEpUUTwjqwqdXYdE4WI
	 fR/sb16vDxlokb+/uRFztXbJxX9yiRrmuVfWhjfH1zJsoowLXhYNsFadmxhckCSTxR
	 cXbPrNogiANuw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9371A430CE;
	Tue, 20 Oct 2026 08:25:45 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Subject: [PATCH v4 00/11] drm/tyr: add VM and BO ioctl support
Date: Tue, 20 Oct 2026 16:25:17 +0800
Message-Id: <20261020-tyr-ioctls-v4-0-704de77da223@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAG0l12oC/02Nyw6CMBBFf4V07Zi2CAmu/A/Doo+pNGJrppVAC
 P9uIS5cnntzclaWkDwmdq1WRjj55GMocDlVzAwqPBC8Lcwkly3vuIC8EPho8pjACY6OW6Odalk
 RtEoImlQww65YegF9UoaAc97/N6Hz8xG794UHn3Kk5WhP9b7+MrL7z0w1cJBt1zROCyFsc3suo
 w8xnU1g/bZtX1s/RDLFAAAA
X-Change-ID: 20260901-tyr-ioctls-f10ef0dcbfa6
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lyude Paul <lyude@redhat.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
 driver-core@lists.linux.dev, Ke Sun <sunke@kylinos.cn>, 
 linux-kernel@vger.kernel.org, Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792484721; l=4895;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=0W/Zzd3YJxNeZ/dKwlzvsYXdPOz5NCl/hBwAO8KxQJc=;
 b=ZCt+HemY9ZaAgV5qL4JXMw4PoShS3j9pE/9zTZikxUtm+7rqPO/xfi9uboxExmsU0kTCg74MU
 gOX+ht0Cji7BgDZkLM5fZzFZylhpPfO6T9gA38oJuHNgYfFVa4c2MgP
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Queue-Id: B85C41C000B
X-Rspam-User: 
X-Stat-Signature: qaz154zeboj3chwzcrp9p1bu4x1rfsxm
X-Spam-Status: No, score=-24.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792484751-44679
X-HE-Meta: U2FsdGVkX1+NFjegywwMKQ2Kaq7+eftuqnw6ZUntjP5BCkTVHR8t0ui8F0oeFHhgss5wEUwwiCILQ42wrzAANV/zmY/six/ELB5y4gONZVfHdjHXqyW4A7uMK44LhX+Jod7HmX+pAHB5FoYQbBBTm2dQalDBRuMhp37HIL02Bx2DF+lt44sWnc4Lj12bpHdZZBScGSGGMRXqUM4x3cHqxy3tsJVWl+CU/1EP82QO9Ycsu20xHmhoLy24GBJ9k3yOJqBx0cl2nQZggWOCXqYgCbQgL9rrH/M/YqZcZXK6dlr91W92wYk1kqa+k6+Z4EFqFiXgtcTFy0ajn0TreEgk8VKREbRHHEJ28FJCH16Sp3jYZ5aagLagSJ383cW6C9ZXvvG4L8mNxn8J4++YKgpePFBfkbL1a/R/Ew97GQI3OxLLChhUocnfImMUPtkrj7PasDkHwK9ZKOANauXH/zR5ZET4H7dwkpeJy7nYoG/AzykE8bpLHwHqT9/Dbt9wmLhfz16bMmFgbty6qUbzH1d9l2TYBNpYLPP/iaSm2Z147ryACeFNKh4HfZgMazXqkmq5C0jTgJF/eEgPE0/qtgzTwwDWqo6NSyXaKd7db4Nn3Kmmzfm8ouamGrhU0iDEz0dlvO0G3bk7S+10JQhOeX72GZSsmvGzuzL1vXIF8fQs9I7Z7P+MO3Iazmbb0V7VU33d7IMme25ubLRw1I4JH99NeM8LZD+cZBcUoraVRrZYumfbayNm6OFwryNwu72YiViGHrqtlxKd3WFO9IRkwG8nFdCQ6AIjqh5JQ6iGd+ZwZ2qd6IYMMkW7DH1yKkMBiIQKiWHxvv79cAse9TAUhtFsuBSp9F9fcVJWWYxr4FY+Ma94AVcNrMV7uIg/sC09Wbk1+wrsV6i00aNWq9hQoJDVkUkOHFG5ATsct4gqs7l7CrS2SgFuRwRCA/A/DR0GQf51XwPUjLNZOpIQ90ZArSZ
 WJ3Jtqet
 gnUiX8w6iLFnrt81iH4FYAQMVeFuLDdPgwEvZT/rCiS7hLBar6IrdOHxEn/mNzFf8I9Icpb76gdxMsuqah328udEl8jdR7U5xfWl7yk3HEcrc8LIpIKdEID4Aek0J59k+yOtkqJGF6OO2JrrgbVqmuDg4PuC+AidUgosC4GKPO0IyP0D9brpK0YPC/PCh1S0XOTz7iw8gmKVxAPkyVfjfBBAtw4kVXxQDvpK05V11Re8sXOwv0AtDbIkh2Vjbwr7pzqDt/yPbOYaZQ92geNcaPMNAWBO1BJJ74ZJ++2OfgnDAgwWMVynr6hFnXhevQnPT2NzBpEhFxP3WC0b678TnMB/2DSN9IB28znSYYRHerI0ouA7WrLejHMty5y44VT4EqP5apCfe8JHaTDZSQkliI8TBeZvB4l0re//kmlRvnJs7pW1VW17l5jQkC4p6y9osUz4efx51ljel9H28B+yTj0z2mOHJ9aQFky/3d6q0QNj9ismeZcmRZjBkl0AT2Lt5dxRUhNi5CNpDXFULvExCZ6qZXg4XlzcvYO2WSBzHzV2EuGXgYhZHV8To6txqB0kYPlsNTLSnuzzlIv/UQKAarkErP8vVfzQ5kGuwaWTsu+u4VGNeDSlbnTpUwaY2F6Bt3zEGnpefawt5SQJ3dUNmLNbEf/pDKIqshV49c2zfoe4oNeh/YEKVoZZiuVxw4EoYBzmXqfhiYM7aMeSZUm2zonYW8rmll9RZpGFYlZGk9tuGwFsh/tFD4MXFFQTJxVqsjjz08HHmyGX3WSNKJI8jOl6vMX71+H3XIRhbXGa4crNyHZ0FLH3RbOIMko8frZxYyRvINa/msRI2YI+230wpB3GFLBlQRaf4W9+Swe/bBaJYcpl141CZ59quxru0HkDROKSduRC8Q8ULBB1jfILCnmQ1xOAUYLtEI+c+zJyXoD6EiDcldEUypNXzisW4jM4SZV7mrM3VHEXV+kz0pa7Dxe+kMx4P
 xIfdNFZ8
 6bCIQexO+GQe9LOW423ekZanYs4VAxjHrX7mHWijnJp48iEFJmdUU6r2RheISMihFoTNEhN7zlOeRBsdySv9tRhGjGslwoHyPA1jm4nVsBY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add the VM and BO ioctls to the Tyr driver, aligning its userspace
interface with panthor.

The series is based on Danilo's `drm-file` series on
`drm-rust-next`. It also carries Sami Tolvanen's buffer
cache-management patches from
https://gitlab.freedesktop.org/panfrost/linux sami/tyr/7.3/dev.

The panthor IGT tests pass on an RK3588S device.

A branch with the full series and all prerequisites applied is
available at:
https://gitlab.freedesktop.org/alvinsun039/linux.git tyr-ioctls

Link: https://gitlab.freedesktop.org/panfrost/linux/-/merge_requests/64
Signed-off-by: Ke Sun <sunke@kylinos.cn>
---
Changes in v4:
- Rework VmPool teardown: add() returns an AddError the caller owns,
  a conflicting stored VM is killed with EBUSY, and remove() kills
  before the ID is reused (Daniel, Deborah).
- Wrap dev_dma_attr in a DmaAttr type with dma_attr()/is_coherent()
  and rename the patch accordingly (Danilo).
- Fetch the sg_table unconditionally in new_object() and drop the
  conditional flush call (Daniel).
- Use dev_dbg!() instead of dev_err!() for user-input validation and
  EOPNOTSUPP for the async VM_BIND path (Daniel).
- Drop the pr_err!() calls from the VM specification patch (Daniel).
- Link to v3: https://patch.msgid.link/20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn

Changes in v3:
- Drop the VmOwner wrapper and kill VMs explicitly on destroy and
  file close (Deborah).
- Add Sami Tolvanen's buffer cache-management patches: coherent
  devices map buffers cached, write-combine buffers flush at
  creation, and BO_CREATE accepts WB_MMAP.
- Drop the new_dummy_object refactor; the dummy object stays a direct
  Bo::new since new_object now fetches the sgtable for write-combine
  buffers.
- Document the LargeSizeConstants trait in the sizes patch (Miguel).
- Misc commit message and comment cleanups.
- Link to v2: https://lore.kernel.org/r/20260908-tyr-ioctls-v2-0-88bea777df67@kylinos.cn

Changes in v2:
- Fold the VM pool into vm.rs and cap it at 32 VMs per file (Deborah).
- Add VmOwner so a VM is killed exactly once on drop, regardless of
  remaining references (Daniel).
- Replace the VmSpec enum with new_for_fw()/new_for_user()
  constructors (Daniel).
- Parse VM_BIND op types via VmBindOpType and use the kernel
  Atomic<bool> for the unusable flag (Daniel).
- Use PAGE_SIZE for the dummy object size (Daniel).
- Rename BoData::create_flags() to flags() (Daniel).
- Report VA-split failures with dev_err! at the caller.
- Link to v1: https://lore.kernel.org/r/20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn

To: Miguel Ojeda <ojeda@kernel.org>
To: Boqun Feng <boqun@kernel.org>
To: Gary Guo <gary@garyguo.net>
To: Björn Roy Baron <bjorn3_gh@protonmail.com>
To: Benno Lossin <lossin@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
To: Trevor Gross <tmgross@umich.edu>
To: Danilo Krummrich <dakr@kernel.org>
To: Daniel Almeida <daniel.almeida@collabora.com>
To: Tamir Duberstein <tamird@kernel.org>
To: Alexandre Courbot <acourbot@nvidia.com>
To: Onur Özkan <work@onurozkan.dev>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Lyude Paul <lyude@redhat.com>
To: David Airlie <airlied@gmail.com>
To: Simona Vetter <simona@ffwll.ch>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org
Cc: driver-core@lists.linux.dev

---
Alvin Sun (8):
      rust: sizes: add SZ_4G constant
      rust: mm: add `task_size` helper
      rust: sync: arc: relax `ForeignOwnable` for `Arc<T>`
      drm/tyr: add per-file VM pool
      drm/tyr: add user and MCU VM specifications
      drm/tyr: add BO creation and lookup helpers
      drm/tyr: add VM-related ioctls
      drm/tyr: add BO-related ioctls

Sami Tolvanen (3):
      rust: device: expose the device DMA attribute
      drm/tyr: gem: flush write-combine BOs from probe-time coherence
      drm/tyr: gem: map cached BOs for DRM_PANTHOR_BO_WB_MMAP

 drivers/gpu/drm/tyr/driver.rs   |  24 ++-
 drivers/gpu/drm/tyr/file.rs     | 407 +++++++++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/tyr/fw.rs       |  21 ++-
 drivers/gpu/drm/tyr/gem.rs      |  76 +++++++-
 drivers/gpu/drm/tyr/vm.rs       | 357 +++++++++++++++++++++++++++++++++--
 rust/bindings/bindings_helper.h |   1 +
 rust/kernel/device.rs           |  24 +++
 rust/kernel/mm.rs               |   7 +
 rust/kernel/sizes.rs            |  12 ++
 rust/kernel/sync/arc.rs         |  12 +-
 10 files changed, 891 insertions(+), 50 deletions(-)
---
base-commit: 015bdd5eb1e4a1a35673727f294a88fb0969c77c
change-id: 20260901-tyr-ioctls-f10ef0dcbfa6

Best regards,
--  
Ke Sun <sunke@kylinos.cn>



