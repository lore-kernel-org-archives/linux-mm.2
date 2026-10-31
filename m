Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A6F9606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 15:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=8alias.com header.i=@8alias.com header.a=rsa-sha256 header.s=dkim header.b=emRaCHDG
Received: by kanga.kvack.org (Postfix)
	id 275206B05B1; Sat, 31 Oct 2026 11:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2266C6B05B2; Sat, 31 Oct 2026 11:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EE676B05B3; Sat, 31 Oct 2026 11:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3EA16B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 11:44:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B79B81A09CB
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:44:17 +0000 (UTC)
X-FDA: 85383342954.24.59A3620
Received: from mail-107169.simplelogin.co (mail-107169.simplelogin.co [79.135.107.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id E18D6160002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:44:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=8alias.com header.s=dkim header.b=emRaCHDG;
	spf=pass (imf08.hostedemail.com: domain of sl.lmysyibrg4ztkojxha3tsobmeazdknbrgeydixi.e774njbujgl6i@8alias.com designates 79.135.107.169 as permitted sender) smtp.mailfrom=sl.lmysyibrg4ztkojxha3tsobmeazdknbrgeydixi.e774njbujgl6i@8alias.com;
	dmarc=pass (policy=quarantine) header.from=8alias.com;
	arc=pass ("simplelogin.co:s=arc-20230626:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793461456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xalrLin20XWlk6bzYnzzbgaIXTRXr6SHiU+Ft8ewMUI=;
	b=2iiLxOlvXlBoEmwg5WPWJ2tRPC+T9i+/1UN+J0HspwudEpT5m2UUWfMWJYagBgE4iE+gNC
	TNat/2O23Pfo4zZLUJZP7Xjw+wJQ2iceG0ttdPYR9dddU0U4cNGC9P9sglzeJdv+AmdDmF
	OxbA26nVQiF6POmC6hBJEbhfiXTTkhI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793461456;
	b=bTfsbuu+l6u37C/BLZCrPR0EUdIiSwfH43M6a/+3H7+KfwCRV2py0XPOJtPPbqC7n8BDdp
	VeId90Lxg3Rs62X8u/iEnt/T8OwW3lBqXDmxEUUcVOVvRSNNJJpHy3rC8QWC0z58eMCHL1
	mQH0Un0uC6V5XtaPGSLZdbt+aIUA7y8=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=8alias.com header.s=dkim header.b=emRaCHDG;
	spf=pass (imf08.hostedemail.com: domain of sl.lmysyibrg4ztkojxha3tsobmeazdknbrgeydixi.e774njbujgl6i@8alias.com designates 79.135.107.169 as permitted sender) smtp.mailfrom=sl.lmysyibrg4ztkojxha3tsobmeazdknbrgeydixi.e774njbujgl6i@8alias.com;
	dmarc=pass (policy=quarantine) header.from=8alias.com;
	arc=pass ("simplelogin.co:s=arc-20230626:i=1")
ARC-Seal: i=1; a=rsa-sha256; d=simplelogin.co; s=arc-20230626; t=1793461454;
	cv=none; b=eHgZMjg3obvrEPzAV1P8Gj7k+MApPqnGB7YMMd4YH5JsTrBzjBcSF0owFFGYaSd30ZYkrIBWRXMGAdEQVujmzCIsD604cR8ooPZQP+PbEkZb6w3j2HIxHgssCir4bauU0GsLEurYuEQWaA00d9RM8zg94p/XEtSbJJh3Hwggoh52EEtvEzvaNKD5/GwQnep7ahqqLXqR/1zdSVQjlq85SVy6GoEG05+DNACa84/YSSHEwNj/KK8pHRxCdNyTmgW1GeQKGg8+BKriNHYk9ynZ11m3RgPsbbIWx7s+wUWqPBdgqxxUGjw4jHZSNyXEgmt2Be/WeqG3QMufmFW7iXH4eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=simplelogin.co; s=arc-20230626;
	t=1793461454; c=relaxed/simple;
	bh=AaZu+tZdoMwvlXleI2bXaZaMVRyFk7eBBWZBUTdqvVg=;
	h=Date:Subject:From:To:Cc; b=QTfBnWHkrLo12StNU6cxpxNy4N5din9LvWbIdPl+JEYjdFS+SrS/Dyz/ATlSCX+6vV/2jZwVUL7wA7VxJL3Q/ccWuiBS8Z+kBZksDw6joV9HfUJkBI5vfTf4Dh3Q5bARbp3LqqM2kPXKLKL0tIkR92TOp+z61JhnEBqJNKLILb4+avuF35H0D8rxt8yI3E5PdYnW77icqA8eUuFnzsRWQgrAzpyEY17f9KUK3tdlkuQVDNsdx/8u243hkdIo035ggSoU6bxlnNWlt3DOcQkYzW3WGpqw0xJCjhOnlB29orMj54jg4hh3Ukg9ukjdGAcW8G3//ICGN0hP9GXXVg6NOA==
ARC-Authentication-Results: i=1; mail.protonmail.ch
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=8alias.com; s=dkim;
	t=1793461454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xalrLin20XWlk6bzYnzzbgaIXTRXr6SHiU+Ft8ewMUI=;
	b=emRaCHDGkKXmZ9eBTodmX1a+rBynx/mefiKHQmKHNqnnOIFeWQRhWGCbAXOR1f8GmeaznN
	8VNAbAyWPMm5xGdB3y2eJzX7419NPn7Y7a/Jprlei1vyW3d2jRtpV5ykhUJL8uy8CHKEyS
	9+FyTswtXIJxw9WIiaY0D4PAa5WGksQ=
Date: Sat, 31 Oct 2026 15:44:03 +0000
Subject: [PATCH 6.12.y 0/2] Fix ioremap of addresses above 4 GiB on x86-32 PAE
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: =?utf-8?q?Radek_Marci=C5=88a?= <github.unusual340@8alias.com>
To: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@kernel.org>,Ingo Molnar <mingo@redhat.com>,Borislav
 Petkov <bp@alien8.de>,Dave Hansen
 <dave.hansen@linux.intel.com>,x86@kernel.org,Andrew Morton
 <akpm@linux-foundation.org>,David Hildenbrand
 <david@kernel.org>,linux-mm@kvack.org,Arnd Bergmann <arnd@arndb.de>,Michael
 Kelley <mhkelley58@gmail.com>,linux-kernel@vger.kernel.org
Message-ID: <179346145167.7.7861216093151225931.1735978772@8alias.com>
X-SimpleLogin-Type: Reply
X-SimpleLogin-EmailLog-ID: 1735978798
X-SimpleLogin-Want-Signing: yes
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E18D6160002
X-Stat-Signature: hrhbh65imag18daqf5rmewi57ahzuhxr
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793461455-906581
X-HE-Meta: U2FsdGVkX19L5bFW3mOxyk041UY17ArM7FwBGs8h5JsSwd7/yr8+xwkUzGcppk+qs344u/PP6Sa4OdGqFPyxO6p6fLeT/pfag6Pv+vL+VxzMUfzW1x175XG+QYuVJX8RDJuu03EvLKfXXyfMhu3hUr5FxEP62b7BzdHW8etUZxepPz9wQywJQ+SDYcyP198WM9bc2XCEKjM2lztIGzJfRPCAHlsG5M3ajfwf4AwjOqjW2vbgv9ZHNvrdov52axGl6Z6uRFmPwDo/hFse/bfaEH0ol4OnNSKHBfpFwCEhfzHgeHAnTg7LXG37Rrv4303lBDsxcgLf0sk6X9SBn2WaqO596TA3R4wvgsYlLzKaFXlj13UYbgR7YNeIq9FPVLlkd8mhF2XXXgmSX4IJlJIC4x6d9tApkzcrNOHLKTWzVWmcfNu4gFU8AbhlRddoIF1ZP7JF4G04ivsOni6zZP7A3GVqcwhIsbciNe/UzUnf0E/BKwvQ88ol2aeZTOCEJ0GztxNRyCjws9551Leiib8VpxAiJ14y/yNdMLGcix6RxfRLUjw5cuvD7gnrmpM935EsHZsXOiNKWrzkxZvKSoedLsCJ8ajpNRPZH5ovYvE9EYbn5yzg0IXneK3dbCFVNOLQODK05wiDhYkvZgVyCs6ftnbdr9b4pYGvPlBl8VI6jB5eAmANx/H1RWpAp6soiyfMJMo4grdyAlyiMP9rgPJCp3YoS7uFmJREMshMu+ik7AqVxc3d/JwTlPUObmQnjklchdcKHXExuzT9zwEF57gfiEhqlUPYxsxHVTIraJKAWyR9+9gFILfq7zBD/FV7D9a0usckH0vDCfpc8M2lJFhYBepYStFvaZ2ve8EzKueNeQHutv6tsRVA4kU0ioOCov1LVxaUQdW3aDW7F66+jhV4WVLI98FveLt6Edc/5l8UgZHuGQwdht2fJV0LhNLhCSF0FPm7ih2oVhPFidBf4+6
 u7IeHekC
 cOQkBNj0BC+NHCwQob+/g3ZKv6pwAdN5r2Ybn1Sw6yo/XxF7p7JY48rFB+5UWpZrT8BA8TfowC6RLfb6juvZ1gLpmma55/+Rtv+n6r5E/T2UwYZ/2xPZCr7jHROe2jXC/zb1a7kl3eDMt5+WSlOoCO0K306evT5HV3vHtDIEQpSfp9ouPC+Qu1GvpucdhD7HVNKZINbYX2Vly4NLGD1TjzqDxNZ0fKAtRDoHdNSO6c4at83FESPCIWzkYRVlBGEAS97nA7/+N7RTyRinfj1sFCqBlBN821B0iI5NKaY3ooUQdgCoPlVIY4IzFLZxLV6Klnkq58mdVK1YzVtYSEzFu0n7GxHSDPC3rYp615JOvr3/ArlsaAb+0vrZ6g/rWqp+mil0nIGk91LxDivp3yJM+5ZlLIzULP7QMiY1Gy63crLId5tODISqgxVESTS1lGAS+0C6UedahvOVhvsGY+UgJk3OKpySSpavgrtIGvuQqTJf8tCvhP4eTdlR8bFI6pnH4w2eu48EOgT9Y8uX0H5CWRxP2qBMe0h54ZDZiMM+/S6+YQI5MTm+9IZjroQompEHsxIX8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Radek Marci=C5=88a <github.unusual340@8alias.com>

Both patches are stable-only. In these trees the x86 PAGE_MASK is an
unsigned long, so "phys_addr &=3D PAGE_MASK" on a 64-bit physical address
clears bits 32-63. __ioremap_caller() and __early_ioremap() both do
this and map the low 32-bit alias of anything above 4 GiB.

Mainline is not affected since v6.13, where commit efe8419ae78d ("vdso:
Introduce vdso/page.h") and commit d4a65302dd84 ("vdso: Change
PAGE_MASK to signed on all 32-bit architectures") made PAGE_MASK signed
on 32-bit. Neither was marked for stable. They cannot go to 6.6.y and
older, which lack CONFIG_PAGE_SHIFT (added in v6.9). They do apply to
6.12.y, but together with the i915 build fix in commit 8fd236b00fc1
("drm: i915: Change fault type to unsigned long") they change PAGE_MASK
on every 32-bit architecture, the kind of change that caused the arm32
regression d4a65302dd84 itself fixes. So these patches cast at the two
affected sites instead.

Please apply to 6.12.y, 6.6.y, 6.1.y, 5.15.y and 5.10.y; the series
applies unchanged to all five. 6.18.y and later have the upstream
change.

Reproducer for 1/2: i386_defconfig plus CONFIG_HIGHMEM64G=3Dy,
CONFIG_VIRTIO_PCI=3Dy and CONFIG_HW_RANDOM_VIRTIO=3Dy, booted with

  qemu-system-x86_64 -M q35 -accel kvm -cpu host,host-phys-bits-limit=3D44 =
\
    -m 5G -object memory-backend-ram,id=3Dbig,size=3D4G,share=3Don \
    -device ivshmem-plain,memdev=3Dbig -device virtio-rng-pci \
    -nic none -nographic -no-reboot \
    -kernel arch/x86/boot/bzImage -append "console=3DttyS0 panic=3D-1"

The extra options get the virtio BARs above 4 GiB with SeaBIOS 1.16.2,
1.16.3 and 1.17.0. Since 1.16.3 SeaBIOS places 64-bit BARs high when
the guest has RAM above 4 GiB, which on q35 starts at -m 2816M; before
that only when the 32-bit window overflows, which the 4 GiB ivshmem BAR
forces. host-phys-bits-limit=3D44 keeps SeaBIOS 1.16.3 from placing them
beyond the 44 bits a PAE kernel can address.

On 6.12.115 the virtio BAR 4 at 0xe0100000000 gets mapped at physical
0x0-0x3fff (per /proc/vmallocinfo), the device ends up FAILED and the
log shows

  virtio_rng virtio0: probe with driver virtio_rng failed with error -2

With 1/2 applied the mapping is at 0xe0100000000, the device reaches
DRIVER_OK and /dev/hwrng returns data.

Nothing in a QEMU boot early-maps memory above 4 GiB on i386, so 2/2
was tested with a throwaway late_initcall that calls
early_memremap(0x100000123, 16) and prints slow_virt_to_phys() of the
result: 0x123 on 6.12.115, 0x100000123 with 2/2 applied.

Unmodified v7.3 in the same setup (CONFIG_X86_PAE=3Dy in place of
CONFIG_HIGHMEM64G=3Dy, which no longer exists) gets both mappings right.

Built with GCC 16.2.1, run on QEMU 11.1.2 with KVM.

Radek Marci=C5=88a (2):
  x86/ioremap: Sign-extend PAGE_MASK when aligning the physical address
  mm/early_ioremap: Sign-extend PAGE_MASK when aligning the physical
    address

 arch/x86/mm/ioremap.c | 2 +-
 mm/early_ioremap.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--=20
2.56.0




