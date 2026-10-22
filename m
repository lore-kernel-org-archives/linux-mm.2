Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D408760A5BEA
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gATrDrbx
Received: by kanga.kvack.org (Postfix)
	id D37106B0A33; Thu, 22 Oct 2026 19:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D886B0A34; Thu, 22 Oct 2026 19:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAEC56B0A35; Thu, 22 Oct 2026 19:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6996B0A33
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 122491C3694
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:04 +0000 (UTC)
X-FDA: 85351852488.21.13FB264
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E3D1EC0004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gATrDrbx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711682;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oLGRAzrHTlyKv2ey9Nfz52vPbyYUhc+dQ/5AY3SAy8Q=;
	b=aeDGFXDyfGcxidVTjjRZByKZH2YPXw6+xPMHcr1o9Vy6tTfdL3siwh7pbQ2jcm7sYrnchf
	FnwkHYqGtVZU7xptcEBzHqtqJ3rMJ5CaTxGTudiIkmrddN1IgTjjHXiREZR13lsvvzRC6n
	3E77T8S5s9tG6FwWFWNnWIOh5+Ic6ac=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gATrDrbx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711682;
	b=WKpdlsOiGQY1sEfIZ2nuHjdrBRpt8sy9hRqZxD5Bd2PO7N3Aa3Q2yPsNxIPmUuS+nRitii
	syAvMVF+x6/Hy/yurINCyoGDVaNcKfeXLVq40imYLlVAQfOKxIdUBV7pukiur/gA5cPq7L
	sHFsiQmCD3wB+heXRqXLfCJgkn22OZg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 56FFB41987;
	Thu, 22 Oct 2026 23:28:00 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711680;
	b=gx3Xw9cnubfNhhVAZQmycKo9LpSSob6sgZFDGJgScbgsaxc0vA+QDvhsoMLBcIELQRiG
	 mdn3OSXxWXgxMLzcDA7dDzKs8g+HHI1yEEZlIYWkh2Md5FCHRZOBV2hw/aktbgn6SxQSh
	 1m28Hmxac7XtkPxAXiduA6l8eI7cNqUVoMQ4vy9QKdNZ1rmI9FMwKV0Q7JhUMWwpB4rGB
	 eZbPdF0bDj5Dvr7Zx4hgUUW1Wc9mObuwph3tAhE+Sr2F1F+UxIsNKefAC10LA/Ia2U9qA
	 NIiW155Rc+fJAJHH7CVHaYMh+m19M8jyoWjV7Cb06CMkVf3dPvWGft8pDXL/LtV5caQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711680;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=oLGRAzrHTlyKv2ey9Nfz52vPbyYUhc+dQ/5AY3SAy8Q=;
	b=AAgLRMk5wf9YVF9Cll+gQ82uDHLguoYPt3SGNBm/fV5qr1i1/ghPEJJCF/JHSTIlQxEg
	 Q9uABIrHYFMPFCkbDaVhYIVIZxLaC4C88HVJXqe31/uAal84GCopM5rhPGMDQtGzCPMH3
	 9z1KMTl+7b+8CGbsaFm7D8EJTG4GJAJusXYT0oaojKAt1MmS2XVBGLszOTXlF7l25ffwv
	 esqI54RzExOgP9KqxMPXgSBwFH8NiAra8p3eyzJXh9Uvmq/z9FvtSxqgdognp0NBfFm4V
	 5gl8bToBoVWNPu/fM1YQ8D0g91qIHd5uIoSaXzx4u4q8egEg4KB4xkaBXcw2lXs8LbA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 387E51F011A8;
	Thu, 22 Oct 2026 23:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711680;
	bh=oLGRAzrHTlyKv2ey9Nfz52vPbyYUhc+dQ/5AY3SAy8Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=gATrDrbxb/Sc264gZPlQgNJvh2c/BiVODXHQDZjRMlkbiXisC34us8w6N2XjGppz6
	 o8a7DSeXvo1I0jtnKF7sHEANSqBMFX+P6X6oi6Fqygh3BdRTovnz4dPLseT8/UY4Pv
	 63BG5ts2BmrTnHHh0JvA4w9N56vvBVx5fVRE/lXBedOLo2IofZ8ystwNbcc9iCZ2Um
	 1WvmoJgYelUjvkERAXpibUtoR3S6F5Ft8ptGP7q7CNj5dC/OjYiuabObRWYRHB4GQ7
	 NOMlVbnEXu/AjNwNb9BR1Dsdi/37XdSk769Z6DO3UGFauRTKg9An6AprBCvaCFDm+L
	 JThEomNtkvAhw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 20C8E4208B;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:50 -0700
Subject: [PATCH RFC v2 18/50] KVM: selftests: Document testing TODOs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-18-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
In-Reply-To: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
To: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Alexey Kardashevskiy <aik@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Ashish Kalra <ashish.kalra@amd.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Brauner <brauner@kernel.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Connor Williamson <connordw@amazon.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
 David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
 Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, Fred Griffoul <griffoul@gmail.com>, 
 Gregory Price <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, 
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, 
 James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jianxiong Gao <jxgao@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
 John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
 Justin Stitt <justinstitt@google.com>, Kevin Tian <kevin.tian@intel.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Robin Murphy <robin.murphy@arm.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
 Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
 Vishal Annapurve <vannapurve@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
 Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=1090;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=godniHxo7p4sYODKlWAWDg9KeRfwB6fIAgZfycigz1Q=;
 b=R/i8dl0tqQod9u3IUnuGkBBKRl2LJ9IKnGENBg55uwgkzUZW5KjiPzoLy20NMDOZmJNRCJmxC
 qpTDu1tB11kDJPvQLZ9ngBvCkOGGIMqds0dr+HS7ETGioatdbrFK0Wy
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E3D1EC0004
X-Stat-Signature: 81m9migaqb7abaiu1gyiuhzcu5hs1mf5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711681-589035
X-HE-Meta: U2FsdGVkX1+NhyyOzKEP7Uo8Uk8PaJ/NqoTpnLnOzgDa99xIT4lOelU/kDRDsRStKp9F97v3rbbVc7X9bIr3bV6GIZ3bbDCFphAu1DjRQD/U8Mc2nS5SXj5z1j6oSeoCIqq3zrKpG9ASPnyvoJlo+ap0V4JK8nPH7jvtG61DAQX7fvunaHM1OwptqOY3CByqjgLuOm8EN2OoUjOHUKkXzmEYDmVyKNH6LHZYCQRs1/zLfb1LUGWK5cohHOu5agisgnIBS6+nTFldWVbCPn7yTCoB2AoGwYqB8Hpfm46X7eZWlYL9dM+zXGc2MqkwNv4RvjhcgDWD1GDlxTBvpDKPgnWQvg7hF74Ohexwn3NViVF8lTZPBriZ6REg8zOzSd1bXWWLR3Zt1cC8f8vCK4O5vy0F81eEn183itbuuIDc0gmp3tZXmpHTZW/f+GQsC6vJ8Nz7r56NFOAvXaLZu3W3fD8cQzWpoYum9of1nJq+EyD8s/zWFKBBaIYEij8BBnIiI8rD7ja5RHAU3LuQS03NSfAilpFWTQLLwaVoJP8WLqmlOXuVvVnHjGklvgjNZZRm3LMAKg0+2ALPgwn6/n+14kqUlHeMdBsOid9BLXx1HZ+o4BMoV45qlM2t9/HlrDWwD/Ms6pMnaOaSgi5a/kok+7/Nk5bY8VnJhxTIBvP9f/Ziqey/WJ+CVUQ0V81O7hy2WEw66jGoWpKX6vG6VTglgKDriIzxH9XtmFLOA443u96p1a0qOVv1pvq4hOYYWVFL2k4n8083D6hg8wSr6HhjPoESKC+e1+3Ued/lTD56ICB4JFI5Q4oBXcoqv3QOIWiEkrxbCIHP7rhi3/6Iku4t0HZpygp2zPF7TYjrOk3vd3/eUZex9pZX0bbWTeJyNVW3VRocno0zs+dzRmN9NxKdP0uKsvOT/ggraCtTrpab24dZo5YG7DwrzTa6ePtB6+R33at+43WGkR+Y/8AQsmN
 ResZK3k7
 x/7/88pb2jm/QAbbDg7+a4WFzeutwS8W40hnCoKw1LW6ZNNh5vc7K3+lycHUq58Twtbo157rsuNDAAyTHk9xO01+04uEBZHCrwKUvlgBuh+/o+AfddJkND7itNWwOuLdwDWKkyAeUq5WSM+nWXCvnmnZKK+cwyymVxp+mlzsk/q60B0RqnwV+ISPG4V/dhnmxYdMBE24AvD+9MKZkFmtuTAz4CU0E9jMh3kJTHFVYDzOtafJak5rUfxWgmJSfgkjB1VAzhlPhSGJhg5Wai1vMVxfuZ49cAaEKUTPx8lv6ssE92aJm/pMcVpuMlWxbGtrpXGCXz4cFu/LOoboJjrPBYKys+xhO5alFg6Yo3YASGqXsQWbLCfbY6/LSHHheCorhEFmZolNYfNybjlhw1MLhkK65ouHDQG3+igTuPQedN3pMFBDk0DCxBsH1Wmz3/N09IOYnpR9ooFiipYR0oHOcX+9VlKpptK5JRrPST0RKTik2USblftxeM4P9uClUa1IPqxXYTVJyVfTdctwmuFov68JcC4rH3D5lKoQIAfap9msihFElElw5fmyH8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Remind myself about all the tests (A)I did not write.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 8e9261db23354..fd249445ce3cc 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -701,6 +701,16 @@ static void test_guest_memfd(unsigned long vm_type)
 
 	test_guest_memfd_flags(vm);
 
+	/*
+	 * TODO: Test that guest_memfd creation rejects a read-only tmpfs mount
+	 * (e.g. MOUNT_ATTR_RDONLY) with EROFS.
+	 *
+	 * TODO: Test that guest_memfd creation rejects an ID-mapped tmpfs mount
+	 * (e.g. MOUNT_ATTR_IDMAP) lacking write or execute/search permissions
+	 * with EACCES.
+	 *
+	 * TODO: Test mpol fallback to mount config.
+	 */
 	test_resource_fd_invalid(vm);
 	test_resource_fd_unsupported_fs(vm);
 	test_resource_fd_memfd(vm);

-- 
2.56.0.257.gf7497c7d27-goog



