Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08FF1CA5FB1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93546B009B; Mon, 28 Sep 2026 22:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6AA76B009E; Mon, 28 Sep 2026 22:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0B096B009B; Mon, 28 Sep 2026 22:15:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A04DA6B009D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:15:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 359911C2948
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:15:59 +0000 (UTC)
X-FDA: 85265184438.05.A7662AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 462E44000E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:15:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ersylhuz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790648157;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=D05NyOT6Ikkc3qhT4oVqZENWmFTZ8Fjql8Mxol92LfY=;
	b=kurayjBFjuA0fP85c7zrKz7s9ncpyH4nbQGET/f4yVTUU4JHB29dL0yasw8VLdee+vN3KC
	jdebpkTilkznl6cGz8+QTNxC6+E/KdhoHBPiMq66Nz5N+wWujWriFN7QHtzasj8oxGqaD+
	ARL7xn37UYqZj2HLuAONFECTi67+Q7M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ersylhuz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790648157;
	b=g2PQ6wYatjTq+/iEfQy/+UApXDNYN1jmxxgiVeiBq8w4SjRyveHZT37nI0WQoaY92eJR4x
	zu0P9v+E/Kp6XX1nVRQR8ruekD9beoyaHif4Hp76xbZjmfA7wdaT+YRZgLMJqvmqMS1WEa
	NyQ7oT4irLwSx9bSuNPVg4UkJ0oezkg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B37860008;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24AB7C2BCB3;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790648156;
	bh=ooYC+l4SrJN6bGPugVtyHBohZ+NNQhJkNOGOM/4tdY4=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=ersylhuzEEBuuSYNmcupQ+PcDDlh6wvZHS20K2kXFRIqCqTHZQOkTN7qNVcwG6jBD
	 fGJJ8WRYhxw1JOh6xP67tuJTGbfBoczWzbCB3JyM+eE5Z3H85cegaSJC0FCtJPkK4i
	 yFSd79JQYUF+B3OA2dIqG8yUR5ip9GuVBXWXkplFwZayub2Hwf4NKazDoWqGLEZBNk
	 GaXyI06KRyMFCRknbWb2zJAZTNK0U/Kv9TxqF+G7QkEt/COQ9ZEfaG5p9hUQjpMLOp
	 0J5lRz6L8zSqIzEkKGzYyDjRwWohtyg1pP9+m/bP+4KAPwRnT9YgI8a3Zyo6N9G5eK
	 1r8uQONK7zMFg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37DECA5FA5;
	Tue, 29 Sep 2026 02:15:55 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Subject: [PATCH v3 00/11] drm/tyr: add VM and BO ioctl support
Date: Tue, 29 Sep 2026 10:15:50 +0800
Message-Id: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFYfu2oC/x2NywqDQAwAf0VybiAqCO2vFA/7yNZAu5ZkFUX89
 649DsMwBxirsMGjOUB5FZM5V+hvDYTJ5RejxMrQUTfQnVosu6LMobwNU0ucKAaf3AA18M4Yvbo
 cpiuJ+kFdrGDmrVz+q5xk+8+e43n+AIzm6x18AAAA
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
 Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790648153; l=3204;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=ooYC+l4SrJN6bGPugVtyHBohZ+NNQhJkNOGOM/4tdY4=;
 b=vG8aN2wX4mjFn++VavBwQib+q2XRrZvaXLL2g4PG7RtZcyiIFBKfO2eDxKaRvjQzq+49q5D5x
 W20uRDli1WMDBWciO4UHODesw3H7R8PRE5v/6xseI7lpGx9E7dhoRnz
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Stat-Signature: x8xm95f5cab6n4dxspygtt7udbouzokx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 462E44000E
X-HE-Tag: 1790648157-158552
X-HE-Meta: U2FsdGVkX18cbLSGhwqSO6WlU1ssd6p+6nf1zSPvt4DiWgNiv1VSDUb/jgwEYVMXYb1VxT65x2xb/39FfJQmH40BcdTjlhk19kNkVZlGudpqLmqaC2wtS1PZvkW/2EfkU/LxMcmgK8NgDRdCOru4IsNSWPfoeH9nT9NUBV1hmiGSfYokJwnkKqIot4iUnQCkkornGVW7SzJmPhNcuB3p85nf9+pq9SHvrKqXeRjWX2fKWdSCwU9LANN4FfCRTbcuKqkdffCkpq8yuM++lzOn7WCX2q9v6yhO/MfCkhy5G/NN4AgMDmuIIch1EYdGlZkQa7BIlpB7j/zkFR561PpdjSgUBsv5U7AyS9LPjQ8sH888aAOiD34zA/LwKrjXQib0VIa0L+DyiFSuowv+Gr3LtwTUz82SQLaAv5Onz8lRZhaTNumBnvSuPAxdmXDlppkn4J2lAppKPk0B8Ba0nN0/U4iWRE20nlKoK2LCOSpq0A/nzgo+pBfvldWqHauVmXbaFuY1LTNM6RVeO7cBSoTsZcVz5hcdeMHBDVEh77bX+UhSJqzxN//Dtuizq3uFW1emWQ521KkkI8NYvOsry2Bje1meVbqhPhRddN9m0eG6q6iCnUFdQZNs+XLnaWPKI/h6AyakCIbjwk2f2lB0EvzZHNrz7/lCXO88t1i0FBh8DR7D0I36ANI2Whul3jYCetvw3a/O+ID4+j0YLLIfg1JcmKB+ELXAur07L48hdxwDj8FRM3IbhpVZ7tStaoHYXl6iJzYjV/1MifL/lAp4sDdBpRqnlt0yzxbrvAKi0WrzNhx745XPkIvenVvbSOBQx6d1NcqBhFUhuMQ5zonz3jCg2jNgDoIWLblYi5WMUAQwzzSMX9n30FPMM9rcIBizxRXBQkOBXVP1+kFq2RYC8Bteu4NNgaVERCoWyM68YROmm8pOM5sUGQRoDddynZCibORZ+7kfjTMsDP5ayEHitnk
 8XCDYGh+
 x1nwiGikgVI0Qa7X2dH2x+f6b2yAhW4G/MBSs/BQp/Z+boclvCi3Vbi65lVgQu73yaqOOak4dM98GY9CeREoqyFV+rs8asdOAXatss3Od5gVBPN3avKIedrGSXRYtocPWB2AT/ifhVLh7o65yTznTmqU4j9DtIJYMI0H7lx48NSQau8AoNd8hoCURKx/cNPKq666W8VZx/DN5GutNAuYd60WV29dhrqPcK4SAjxsi4Kee+f1fsQ7pOVe/qinT4sBBETGbuDDfbNZuWS3902EhZJmTSJQPaGa6vMXicRkL6F8wsgfhdBmNZiRgfigCIOwGXp+P9QO6xFydYX+QVaiDM0z8ueEJzM9mF0oYZrMiRX3lnWmrVKldo4hECAqxf8Z7rfkEWb8J/06DQjhCgA0Z/A5I/oPIpVYUdDYcgHly/soKsdE7CzSQLdrwaxRrxujH1mwNAa3tM2bOnf0xb4w1l9m4Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
- Report VA-split failures with dev_err! at the caller (Deborah).
- Link to v1: https://lore.kernel.org/r/20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn

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
      rust: device: expose dma_coherent()
      drm/tyr: gem: flush write-combine BOs from probe-time coherence
      drm/tyr: gem: map cached BOs for DRM_PANTHOR_BO_WB_MMAP

 drivers/gpu/drm/tyr/driver.rs   |  24 ++-
 drivers/gpu/drm/tyr/file.rs     | 405 +++++++++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/tyr/fw.rs       |  21 ++-
 drivers/gpu/drm/tyr/gem.rs      |  78 +++++++-
 drivers/gpu/drm/tyr/vm.rs       | 325 ++++++++++++++++++++++++++++++--
 rust/bindings/bindings_helper.h |   1 +
 rust/kernel/device.rs           |  16 ++
 rust/kernel/mm.rs               |   7 +
 rust/kernel/sizes.rs            |  12 ++
 rust/kernel/sync/arc.rs         |  12 +-
 10 files changed, 851 insertions(+), 50 deletions(-)
---
base-commit: 47cba9eeecd9a046ee5d211b86aae3e84d2e0b53
change-id: 20260901-tyr-ioctls-f10ef0dcbfa6

Best regards,
--  
Ke Sun <sunke@kylinos.cn>



