Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308DE606A830
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gtHV2y36
Received: by kanga.kvack.org (Postfix)
	id D2CDF6B05F7; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06006B05F9; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB756B05F7; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86D9F6B05F7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F67D120263
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
X-FDA: 85406459082.28.AFE7116
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D3D020003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtHV2y36;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011839;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZOMQbbwROsg3RJmo5tNBpuYTJxKTJ2ke5j/Ex7a5iY=;
	b=ppg1EC7PXrw4GDWc4IfDkX0Brta7uooHjXrwSKJggCKHd545mnHhbVV9iAcLsr9/qBHrn7
	VIEozFShQedT/Lr6WHmSfoo8gwRdU6qQz4Z/VCdnoNEmnW6G+NNYklripjIy1WzTltcxeH
	Xcs9G1ImCcJn+r6Vfik8Q9fI1uEBodc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtHV2y36;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011839;
	b=cXmu0fYdBTmwhXNDxWjBNyiy17cD7RF7ofxmTBWkxvbQcV5FC5DyIegtf9GxPgERD9niaL
	1QhSX4JXCaTJJxFHwbpV7LeomVMhM6/Jrt3hAMRMjL3lfFqJJWiKPOF6HOW7DIchVGa2MG
	vUuVgZBPz2aarWYgmGgKNr9Hx2Vi9qE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F37A844615;
	Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011838;
	b=Q7CEpij3av3k2nbISTpV+xuRk/HBYUd2JJ9pV4+OeLltEqYt+Mf7AL9lKh7eqVvoP0zB
	 xdmN+htVTvft8NROTmnoHCyoLoEWYLwqKQRX/egY8GhyDfwdqn0rgJbB2F4n5ozxe6pwj
	 yALOykOlHVQTCYknG/J5G1cbpgvOknzosaYE6m/Te29ApU3BEdSVabBRf7xF8Ukk0Xh/u
	 j/WpOWZ5+ltkMDn2Gr8md4jZXL+kWn88p53JE5l2HpVGzdxIh7TbzdO8/KUmcfE82qX/E
	 OTJcShnJuuy0IHMhG089QQVsxBpOOVXPkixhssuHzA+5vvTtyDHkfDBczgjB7PxnzzA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011838;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=LZOMQbbwROsg3RJmo5tNBpuYTJxKTJ2ke5j/Ex7a5iY=;
	b=aYUncUAOF1z24CX+m25wIoBeOrC+feCAcMh5v0XeHTYGxjVrpxE8oNYPYrZV99P/Lg4i
	 zmCFUB4t8RvzYIAYbKp6uwYusu8Z6DuHTdqS+QVxxSuknrOB1S8V8kPaov2J0MM8ctSuO
	 mjlkJLCSErEsD87vl56J2FAenMM56NjTnujgHuOjjyUi8kArcxoKYxOFhxaA6DzD6SMzb
	 o+uPrk6M8UibVBbTN4tpUgbAEZgZdCHLv6lKBYdBiun8cdWRa0hl90er5NxBMAgpIQxc3
	 L10+ujEXTfaWWlvL22QGpL0JAjvVjJ8384HhyzOEziKpK0UVNiv+6UqD16cjtrZh9Yg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 84EFF1F00922;
	Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011838;
	bh=LZOMQbbwROsg3RJmo5tNBpuYTJxKTJ2ke5j/Ex7a5iY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=gtHV2y36PgAJHCS5NiPs0Ma8QHOH4Srr3v45JFj1jY/zag3RUsy8mG6y3f50gqCmr
	 auq/cLI2JWUZjFWx88XFLhSH5BqQMvvXKcyJ+gjSu6S2+CRdu4u+suleoP2zxsFt6j
	 IA57r3NRnu+/QDCY39IRfzWhcICBifOm62nSJN+EgGUwsfDY4gtUCT/rzqU4mUVjaY
	 gfsx8XSWqocv/pENT0zGunXFpJHtFPmjfPWTKcGF4a7/PZL723A7YWpondZ9/I+rNk
	 dRuO7YowuBZPOpbfTsDbSI/rGPf1+G+9KPmyXPYZ9dsS5MY3zowyoVnORpyARQfADn
	 mWqODlfLAj7ng==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 43F2547A4A;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:54 -0800
Subject: [PATCH RFC v3 80/88] KVM: selftests: Verify host VMA flags for
 VFIO BAR
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-80-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2687;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=UlabEjEO5/7bc1Xc7qMAcF1rv+8kEYtRG7NVYEhErUE=;
 b=AYnUVtyYbnET239Be/q7ZKR7z0MuG0D/wBLiSNROBy6M+iTcydm/LLxQnKZUtCpZwDkUgkWWx
 NLfenWKq+rzDHvtjBPQsocyULycu+dcV6xLglIVZfDmfMBDwHdFzAaM
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cw1rqnhssaymy7g496fz8fbfnee8pt5b
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2D3D020003
X-HE-Tag: 1794011839-815579
X-HE-Meta: U2FsdGVkX19OSkXq82L9czJWvaeElK3Ob/GRz487sXQ+jRs7vYfRCllnLN5bb5b667LdTKXqrQJiuXg1dcKSbmRFb/Uv/qDgLdkNtnDC+ro5gPJK3xG2MugkOV7YUDIo0FaRSxVFCB0W/JxDrUXLBUsBjw6T7aXxC4ZtmcOZXrYZ6SyFugNkU5fCkossSd6OAKipJu66Ww15B0+xYUR1BHh7KIW3u6qrogqB1L8aHiv7KLDxwStcHKqBnMMLcJwyKIaz+mq7Ytwd37U+6GrUfGkQ3z8pqerJ9YgfGOzOMWEm4ZKMSNfEOX+BJD/0y0Wl7NOI5hnc7YXh88FuSGigXzht7rkN4ZGZFG+04ng5NgzgEYfe+F0k/aHBaYAz/yRKEU7VxZmT3vygx7GO8jCLA5Vys3aydQI+8RaXlKwGmgg1Y5Luv4Uk2tg/WTqOrOKPs37caYjS0kkuoP21M5jpmaFOocecaBR9Zhr6HNRkdFXFs0/QY+nQllOY82jfobgG0IxQv967fwj3rqXMoaslGTCbj8LZ9rRauyiobtkz3X6c+Vzo0TjGsH0/PEDXMk8juB7zym8hYfT/0dIB9wl+Whm/U1pm1ll/PMkK28IwY8Tqz+VdHfVUy+IBEYcptyg6kNorxNWolWJHaNLAsTMQkpOKKdZYTwokCWY/eWPbnJzDy1xaMIgt3dTv3t/0D8vACxi/aPTGIMg98jFPMrVXHHfDVNcQ3nMvb4pt1vIrvd7uF39dFg5MUA+ZRZjwCMDMnlBnsn+TVE12JErK8m9fRJ6D772BnauXCeRY3K7TUaFSgRKl2zPxe7WFSDzmnBGyRpfW4gf8UOsijv5I8JcQKqqXEtOK7m4vfhpqQA27H0ObugzQ6RO7UPzZB3aqsn8EABfTvTM9Ygl6MwSFAYYYSFx6Ydkyo2XoCBZ5fUSqz5rRZw7mdt2hInSylqrHnu4qVAIsIz7yaTGAKqKUvkC
 YWOPvkHF
 3CdeFDTqrfzBTG6X46ivZ5+NWhVwBVWf3eK/rDNy2lNEzJCEkP/v2dNTh3rwiQ7w0XblquKPkUygrefLpdduEh086d8eM9dY3xZ335BNoV3DGL3BcwmKpKPnMQ2BP9QAlmeWH3e1YU8zmJ4vb5pZmDLQLpzdw6Knxfoed6yzVWCofLd2x5HOFxL23OCKXm+MP3eUg1MXzRl5GxvnqJgqkSlLfpRw5yD7Zl5bxs4gCNidFVjZE9vZ4hxrAzb8o15UWQ7Cz4+RlHSqoRQMKH8Om2cBu2/+dAz7ew1LLurKxBMLcdYN59rlqADxyb6bgO0Da6RvY6TYnhbUhffwGCKmg4EGkmoQ0mey+GMziZAO7gqc2srUJT1JypkcmtdohEeTHlIENLzkGmLcxTdbsmTstO8rYGNO8CYHJIQu7mHl1PFL4Jy1qyhp2bfC/ZI9xOQNp0zJys11DoMj6MonDsl37BVRGfBXS3sH57iB+zqvwcsHucQxcUAUWqXAZHzfXzA0CKKSL3TyyQyaCgqOHbp3GCityycPA1zjD/0C/UNBufndeyO5Am8dYmbeq0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a test verifying host userspace memory mapping characteristics
over a VFIO device BAR.

Map BAR0 of the bound VFIO device into host userspace and parse
/proc/self/smaps to verify that the kernel configured the expected
hardware MMIO VMA flags (io, pf, de).

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 65 ++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
index cf2d46a365504..79a0001ca1733 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -529,4 +529,69 @@ TEST_F(guest_memfd_vfio, low_power_bar_revocation)
 	ASSERT_EQ(0, munmap(bar0, bar0_info.size));
 }
 
+
+static void verify_smaps_vm_flags(struct __test_metadata *_metadata,
+				  void *addr, const char *flag_substr)
+{
+	unsigned long vma_start, vma_end;
+	bool found_flag = false;
+	bool in_vma = false;
+	char *line = NULL;
+	size_t size = 0;
+	FILE *file;
+
+	file = fopen("/proc/self/smaps", "r");
+	ASSERT_NE(NULL, file);
+
+	while (getline(&line, &size, file) > 0) {
+		if (sscanf(line, "%lx-%lx", &vma_start, &vma_end) == 2) {
+			if ((unsigned long)addr >= vma_start &&
+			    (unsigned long)addr < vma_end)
+				in_vma = true;
+			else
+				in_vma = false;
+			continue;
+		}
+
+		if (in_vma && !strncmp(line, "VmFlags:", 8)) {
+			if (strstr(line, flag_substr))
+				found_flag = true;
+			break;
+		}
+	}
+
+	free(line);
+	fclose(file);
+
+	ASSERT_TRUE(found_flag);
+}
+
+TEST_F(guest_memfd_vfio, host_vma_flags)
+{
+	struct vfio_region_info bar0_info = {};
+	void *bar0_mmap;
+	int ret;
+
+	bar0_info.argsz = sizeof(bar0_info);
+	bar0_info.index = VFIO_PCI_BAR0_REGION_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &bar0_info);
+	ASSERT_EQ(0, ret);
+	ASSERT_TRUE(bar0_info.flags & VFIO_REGION_INFO_FLAG_MMAP);
+
+	/* mmap the VFIO BAR directly into host userspace */
+	bar0_mmap = mmap(NULL, bar0_info.size, PROT_READ | PROT_WRITE,
+			 MAP_SHARED, self->bar_fd, bar0_info.offset);
+	ASSERT_NE(MAP_FAILED, bar0_mmap);
+
+	/*
+	 * Verify host VMA configuration in /proc/self/smaps:
+	 * VFIO MMIO mappings must have io, pf, and de flags set.
+	 */
+	verify_smaps_vm_flags(_metadata, bar0_mmap, "io");
+	verify_smaps_vm_flags(_metadata, bar0_mmap, "pf");
+	verify_smaps_vm_flags(_metadata, bar0_mmap, "de");
+
+	ASSERT_EQ(0, munmap(bar0_mmap, bar0_info.size));
+}
+
 TEST_HARNESS_MAIN

-- 
2.56.0.455.g6c5a503b38-goog



