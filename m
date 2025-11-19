Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 778B3CF6488
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 22:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D077B6B00B0; Wed, 19 Nov 2025 17:43:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB72A6B00B1; Wed, 19 Nov 2025 17:43:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F666B00B2; Wed, 19 Nov 2025 17:43:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A241F6B00B0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:43:09 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6C7389A6C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:43:07 +0000 (UTC)
X-FDA: 84128833614.29.9783F29
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	by imf29.hostedemail.com (Postfix) with ESMTP id 48FEC12000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:43:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector1 header.b="PsN5RG Y";
	spf=pass (imf29.hostedemail.com: domain of david.laight.linux_spam@runbox.com designates 185.226.149.37 as permitted sender) smtp.mailfrom=david.laight.linux_spam@runbox.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=gmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763592186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vH8FIvcSxGANwVWko1oGmXX5GS5gNWUC/JCXBzpAFv8=;
	b=sSt7XfeDhL5a/WV8LLViiZUDoBm4ycQGWdzKM56Faf/XcXZQFvp97/1v45eIpBzUz5PQsS
	X/G7MN8GzoZnMXQQ0zSbiuS0M2Um3vUGc+p6lkRrlt/g6FGp4HiFjTZldi50sUP4qSnsiG
	GbNoz5slm04n1bPdznhVdBR1SihhTQE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763592186; a=rsa-sha256;
	cv=none;
	b=ai7H86mgc3g2Q/DQA3klZGBCpvdvHGrLLzEj1gKac98bav6ip95jSaECzgCxjKsqlebuk/
	F0nfJHZXhIM48be3a0GTRMwb7mxckw38CtbDdggOYLJd9GPreKKDFhjCbhQEsS9Yd/HFdw
	CSmtxwoTnN84hOKIJiH4Scll/YHZ0iE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector1 header.b="PsN5RG Y";
	spf=pass (imf29.hostedemail.com: domain of david.laight.linux_spam@runbox.com designates 185.226.149.37 as permitted sender) smtp.mailfrom=david.laight.linux_spam@runbox.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=gmail.com (policy=none)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqsC-006yiG-CY; Wed, 19 Nov 2025 23:42:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=vH8FIvcSxGANwVWko1oGmXX5GS5gNWUC/JCXBzpAFv8=; b=PsN5RG
	Yw4adVp36kJvtQBzaOeT30b6SW8wtA5jYGrJdbMMMsYsvDj4CzgnWokM1Sou28r+uOGKmcLsCEfjF
	x7vRqk4x0ZUk5Q3m4pLyHeUUi+2iNW4NTnKESfxwnZdG/Am3FVwILrLSmsIUe5z7hIsRaqS00FKIb
	wpBgN3ajl01apzJtdlTrMHmSUaRE77jg78EefkqX+M/OVhBFzrdgCcdKMETn1d8vUsGL8F9h+RdA+
	wbd/Fhu7XqijCSkRTMRCMNALzN5ANR/Nkxu1LF1FZnjDAvEZUMlegQ7pY4fPBR4It4haMp7qd5v5s
	K6zPsakFUTM6CKZVixkuDzeoxeCg==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqs5-0007yi-PP; Wed, 19 Nov 2025 23:41:53 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vLqs1-00Fos6-6h; Wed, 19 Nov 2025 23:41:49 +0100
From: david.laight.linux@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexei Starovoitov <ast@kernel.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Lunn <andrew@lunn.ch>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	David Ahern <dsahern@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"David S. Miller" <davem@davemloft.net>,
	Dennis Zhou <dennis@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jens Axboe <axboe@kernel.dk>,
	Jiri Slaby <jirislaby@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Allen <john.allen@amd.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Juergen Gross <jgross@suse.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mika Westerberg <westeri@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Namhyung Kim <namhyung@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	nic_swsd@realtek.com,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Olivia Mackall <olivia@selenic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tejun Heo <tj@kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	x86@kernel.org,
	Yury Norov <yury.norov@gmail.com>,
	amd-gfx@lists.freedesktop.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	io-uring@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org,
	mptcp@lists.linux.dev,
	netdev@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH 00/44] Change a lot of min_t() that might mask high bits
Date: Wed, 19 Nov 2025 22:40:56 +0000
Message-Id: <20251119224140.8616-1-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 48FEC12000B
X-Stat-Signature: 4q3auo5cgt5g5aa3fws6y8t5zmjbn45u
X-HE-Tag: 1763592186-236871
X-HE-Meta: U2FsdGVkX19LQX28DaumpEfmDdqsxIaL0PCVXuK5dzq8dcR/vIKumyCepQl+fdas+sqhrrnB2ZMITG9amthNTUtra2aK8zTaIAx1Bz25k/zVf2GkoXl1Yf3rJXsqIsPxtOmRIiyg6FOtv0kYpr6cpad4bkppuxgWQElVwx9w7seE/z6fGD5MLjjHDVh01Kii+VJ4DusYZj4F4jCx4dp897r5IqYyKuUeNRJGmyuArkg/vOCvbhxf2jYmVkiS9QM8zmVqv5J8q1TYFHcl4+qedSJeRr59jb7nl4Uq/YEoVCx9TrSCzvb7eVz0ehg7yfWpucxgTcNHA0nCcF2G3oJAtCdA7Vd6UC35Yms1rYx2FMJAqNpD7NGL9zVYTSNCELNiBroLF3gwPwunzzFpLWTrkGwpeLRtSKwUmgJoUisRL3qtxUNANGFhuXDVy0bPTw5X0SfvK8jeNUnmkWCQLlezEaGKPPyjCnPwcXtD4owHaiOJahFnk3V7ASHCbMNLs2YSqMxbubcd0zjH3X7uTRMv42Za9mgibLC+Dt4OTZSvrUa6HPvPqPDkA+/91IZTrBe12ch3oFM/BuGvZn6W6hqTdkQ7OTsAyaJhDxK/0TqNVgwCSPQcLpD/FuQ0U+N1zTXr07E+ObU28dr/sys/WF8lmhPpyodCqeZyqg8LOX3gkWV1Ia4kL+vA0Il7A2JzOPcWI/KZF03bC5iCNyY19RLMIEtzTdSsezimJKLMhnaFgTOuRk9VakGgotO5U2SVENLocaAD14suKwa4zrEfTQEOU3G7xPrceObV5pH2usxexLAsOVqgWyeyJewEUapp0nm39UI/mo4pmfLXZ9iyLXnko6R+wpiI6CqDWgBdM3i3YDEu0QA3JPJ84edHniBir/aUMGh+CY68VgaYhG/qKzs4C2tU/zrxdM6mntYp/i87CUCebjUUdvcb/ksOGPOQtrJgiMvE8UqvGwlWIaWjLTQ
 8bHriS3H
 WkNndfzp6HB+MkmvSx1zG9o2dZAnS/AyGNtBcjr0U0aBoi5VS9uSm+uW2WI2/2Adhf/JoxBn341XA3k0OCdgCjRYs85dVqKyMOwM6pU65+C1Q8bZNRLWcy8hVEEqp1nJ2oE3dHVEol2Y+ADJT+eQKu2n9eZH3wrTRM0tiLRdsk5iK5BV2M11KPA+ENKanhbLp9hzz2PPli1QXEMRFxCE9ea0kXmeDxn4nqwp56F7aSNaLluyIE8qnlxqHo4pLP3MT/33TiqPnlRqby3tjZ6pgEpxW3OcoXNwCq/4Ynhkwod5Hg4dzvHm52Sb252eWB2HxN1z2qBEDSAO9OwAbkwarroo0FdLI7UdWuGeOGcBWhOpQ7nlt4JR7XSjLDCEX+uh82j/Ucpu9YvM3DTwZ+j7lh6QBjjh0E9QGjfGm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <david.laight.linux@gmail.com>

It in not uncommon for code to use min_t(uint, a, b) when one of a or b
is 64bit and can have a value that is larger than 2^32;
This is particularly prevelant with:
	uint_var = min_t(uint, uint_var, uint64_expression);

Casts to u8 and u16 are very likely to discard significant bits.

These can be detected at compile time by changing min_t(), for example:
#define CHECK_SIZE(fn, type, val) \
	BUILD_BUG_ON_MSG(sizeof (val) > sizeof (type) && \
		!statically_true(((val) >> 8 * (sizeof (type) - 1)) < 256), \
		fn "() significant bits of '" #val "' may be discarded")

#define min_t(type, x, y) ({ \
	CHECK_SIZE("min_t", type, x); \
	CHECK_SIZE("min_t", type, y); \
	__cmp_once(min, type, x, y); })

(and similar changes to max_t() and clamp_t().)

This shows up some real bugs, some unlikely bugs and some false positives.
In most cases both arguments are unsigned type (just different ones)
and min_t() can just be replaced by min().

The patches are all independant and are most of the ones needed to
get the x86-64 kernel I build to compile.
I've not tried building an allyesconfig or allmodconfig kernel.
I've also not included the patch to minmax.h itself.

I've tried to put the patches that actually fix things first.
The last one is 0009.

I gave up on fixing sched/fair.c - it is too broken for a single patch!
The patch for net/ipv4/tcp.c is also absent because do_tcp_getsockopt()
needs multiple/larger changes to make it 'sane'.

I've had to trim the 124 maintainers/lists that get_maintainer.pl finds
from 124 to under 100 to be able to send the cover letter.
The individual patches only go to the addresses found for the associated files.
That reduces the number of emails to a less unsane number.

David Laight (44):
  x86/asm/bitops: Change the return type of variable__ffs() to unsigned
    int
  ext4: Fix saturation of 64bit inode times for old filesystems
  perf: Fix branch stack callchain limit
  io_uring/net: Change some dubious min_t()
  ipc/msg: Fix saturation of percpu counts in msgctl_info()
  bpf: Verifier, remove some unusual uses of min_t() and max_t()
  net/core/flow_dissector: Fix cap of __skb_flow_dissect() return value.
  net: ethtool: Use min3() instead of nested min_t(u16,...)
  ipv6: __ip6_append_data() don't abuse max_t() casts
  x86/crypto: ctr_crypt() use min() instead of min_t()
  arch/x96/kvm: use min() instead of min_t()
  block: use min() instead of min_t()
  drivers/acpi: use min() instead of min_t()
  drivers/char/hw_random: use min3() instead of nested min_t()
  drivers/char/tpm: use min() instead of min_t()
  drivers/crypto/ccp: use min() instead of min_t()
  drivers/cxl: use min() instead of min_t()
  drivers/gpio: use min() instead of min_t()
  drivers/gpu/drm/amd: use min() instead of min_t()
  drivers/i2c/busses: use min() instead of min_t()
  drivers/net/ethernet/realtek: use min() instead of min_t()
  drivers/nvme: use min() instead of min_t()
  arch/x86/mm: use min() instead of min_t()
  drivers/nvmem: use min() instead of min_t()
  drivers/pci: use min() instead of min_t()
  drivers/scsi: use min() instead of min_t()
  drivers/tty/vt: use umin() instead of min_t(u16, ...) for row/col
    limits
  drivers/usb/storage: use min() instead of min_t()
  drivers/xen: use min() instead of min_t()
  fs: use min() or umin() instead of min_t()
  block: bvec.h: use min() instead of min_t()
  nodemask: use min() instead of min_t()
  ipc: use min() instead of min_t()
  bpf: use min() instead of min_t()
  bpf_trace: use min() instead of min_t()
  lib/bucket_locks: use min() instead of min_t()
  lib/crypto/mpi: use min() instead of min_t()
  lib/dynamic_queue_limits: use max() instead of max_t()
  mm: use min() instead of min_t()
  net: Don't pass bitfields to max_t()
  net/core: Change loop conditions so min() can be used
  net: use min() instead of min_t()
  net/netlink: Use umin() to avoid min_t(int, ...) discarding high bits
  net/mptcp: Change some dubious min_t(int, ...) to min()

 arch/x86/crypto/aesni-intel_glue.c            |  3 +-
 arch/x86/include/asm/bitops.h                 | 18 +++++-------
 arch/x86/kvm/emulate.c                        |  3 +-
 arch/x86/kvm/lapic.c                          |  2 +-
 arch/x86/kvm/mmu/mmu.c                        |  2 +-
 arch/x86/mm/pat/set_memory.c                  | 12 ++++----
 block/blk-iocost.c                            |  6 ++--
 block/blk-settings.c                          |  2 +-
 block/partitions/efi.c                        |  3 +-
 drivers/acpi/property.c                       |  2 +-
 drivers/char/hw_random/core.c                 |  2 +-
 drivers/char/tpm/tpm1-cmd.c                   |  2 +-
 drivers/char/tpm/tpm_tis_core.c               |  4 +--
 drivers/crypto/ccp/ccp-dev.c                  |  2 +-
 drivers/cxl/core/mbox.c                       |  2 +-
 drivers/gpio/gpiolib-acpi-core.c              |  2 +-
 .../gpu/drm/amd/amdgpu/amdgpu_doorbell_mgr.c  |  4 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c        |  2 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  2 +-
 drivers/i2c/busses/i2c-designware-master.c    |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  3 +-
 drivers/nvme/host/pci.c                       |  3 +-
 drivers/nvme/host/zns.c                       |  3 +-
 drivers/nvmem/core.c                          |  2 +-
 drivers/pci/probe.c                           |  3 +-
 drivers/scsi/hosts.c                          |  2 +-
 drivers/tty/vt/selection.c                    |  9 +++---
 drivers/usb/storage/protocol.c                |  3 +-
 drivers/xen/grant-table.c                     |  2 +-
 fs/buffer.c                                   |  2 +-
 fs/exec.c                                     |  2 +-
 fs/ext4/ext4.h                                |  2 +-
 fs/ext4/mballoc.c                             |  3 +-
 fs/ext4/resize.c                              |  2 +-
 fs/ext4/super.c                               |  2 +-
 fs/fat/dir.c                                  |  4 +--
 fs/fat/file.c                                 |  3 +-
 fs/fuse/dev.c                                 |  2 +-
 fs/fuse/file.c                                |  8 ++---
 fs/splice.c                                   |  2 +-
 include/linux/bvec.h                          |  3 +-
 include/linux/nodemask.h                      |  9 +++---
 include/linux/perf_event.h                    |  2 +-
 include/net/tcp_ecn.h                         |  5 ++--
 io_uring/net.c                                |  6 ++--
 ipc/mqueue.c                                  |  4 +--
 ipc/msg.c                                     |  6 ++--
 kernel/bpf/core.c                             |  4 +--
 kernel/bpf/log.c                              |  2 +-
 kernel/bpf/verifier.c                         | 29 +++++++------------
 kernel/trace/bpf_trace.c                      |  2 +-
 lib/bucket_locks.c                            |  2 +-
 lib/crypto/mpi/mpicoder.c                     |  2 +-
 lib/dynamic_queue_limits.c                    |  2 +-
 mm/gup.c                                      |  4 +--
 mm/memblock.c                                 |  2 +-
 mm/memory.c                                   |  2 +-
 mm/percpu.c                                   |  2 +-
 mm/truncate.c                                 |  3 +-
 mm/vmscan.c                                   |  2 +-
 net/core/datagram.c                           |  6 ++--
 net/core/flow_dissector.c                     |  7 ++---
 net/core/net-sysfs.c                          |  3 +-
 net/core/skmsg.c                              |  4 +--
 net/ethtool/cmis_cdb.c                        |  7 ++---
 net/ipv4/fib_trie.c                           |  2 +-
 net/ipv4/tcp_input.c                          |  4 +--
 net/ipv4/tcp_output.c                         |  5 ++--
 net/ipv4/tcp_timer.c                          |  4 +--
 net/ipv6/addrconf.c                           |  8 ++---
 net/ipv6/ip6_output.c                         |  7 +++--
 net/ipv6/ndisc.c                              |  5 ++--
 net/mptcp/protocol.c                          |  8 ++---
 net/netlink/genetlink.c                       |  9 +++---
 net/packet/af_packet.c                        |  2 +-
 net/unix/af_unix.c                            |  4 +--
 76 files changed, 141 insertions(+), 176 deletions(-)

-- 
2.39.5


