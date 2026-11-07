Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CDA5606A32D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PVuFSelh
Received: by kanga.kvack.org (Postfix)
	id 9B66A6B0639; Fri,  6 Nov 2026 19:43:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93FC76B063A; Fri,  6 Nov 2026 19:43:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82DE46B063B; Fri,  6 Nov 2026 19:43:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB196B0639
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:43:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E58581A027A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:43:39 +0000 (UTC)
X-FDA: 85406474958.27.620C282
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BF4F040002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:43:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVuFSelh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794012217;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DaJbX9K47MPESvUexensq7JxY5C8QjJ+zVBZZpcUPTs=;
	b=dmZEMjekw1IyIkFDfrKQmjBa4s8qAbhE22NidrornuluOsX8Bwq9sPZsu/k2z59PGQJ3Jb
	wBwz1HQjVHKu/tCR2W4MHovNjX23vfgBTgVmDKJ6nTfONENEr2bDZF9MhE28jw0re97pcO
	0pm4+XAU3r2s53T92e/qqiAOtQ4DP5w=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVuFSelh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794012217;
	b=v4F1/rE9npQEYSoVA641IrXY0t+1jdKa+oZtVHUrdYEpOAN57lttMVfRwtDXqrQdwEj2AD
	ekeRiQL8GyBTfOTwptEMTCTftQYS+qk2Y9kj6jVG/u2hH8xjEt95rLP1LNE29v1Yfl8A62
	6uRjFmJEUMbZOe9bWs/h9/y8uz3HRGY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFD6944061;
	Sat,  7 Nov 2026 00:37:06 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011826;
	b=01mHq1atVZc0f0vWEi2r4ZRQzEE699AClKhM6BPeVp4OlSW9MsF1eYd4jlSLbkUSJa5q
	 30r4raq1LROomzfHxNcQ1WtvRykAn3Y1jRDLpUFJ3Zyq3cBQ8L7f6rIOvODTjDvnGkkPa
	 qkiILmwTR2m5tdlLyG/jCKse53F/czHPf7/RoHSOShukxU4uFadWdQiOroLxKACi6rsD3
	 w4oUigvARZNi8f+ma8Yk+KUkkan33ZM/OEDlJ1aW2L+bXe7Sg1WgfotHhZek7QZWc7sUc
	 jOodTigjFrxybsVZvd4tApMe3l70ky8fhBjlGyHH28IfIBpCDJzmX1+uc/CEjr9aWow==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011826;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DaJbX9K47MPESvUexensq7JxY5C8QjJ+zVBZZpcUPTs=;
	b=NSqxf44OICTCE99rKU24QRVrnUfVu50jG8+MFsAKuxmmJd6ifxompgEJtC2/RP2EOlbH
	 A1NjDMfvaZ0c1yEv0JIu9fdpQTEoI+leD3+Z0vmLaU5N7/qeRvceAAdxwk/dcyFlY3jC6
	 Rkdfds46ag7kT3lEiaO1COMVWGGWilS7vHETMxDVLFPR9OC3d2Kd5PkQgCRKHz8fgLIu7
	 QfwNRQAXz06UF+4bA6y9MZo+qB4YfqRBjp9Qg0I6Msgq+e6y65Cx3U9UgCUxr4jn5WkfZ
	 S+aUT8epuzYUyRcMd+pCuSuIXXEYcjbsCvUOCsfhgEa2QzxF+PBbSMC35iwZ4X2yCmg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AB5171F00930;
	Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011826;
	bh=DaJbX9K47MPESvUexensq7JxY5C8QjJ+zVBZZpcUPTs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=PVuFSelhrY8X2bDFgWb305cgCe+sfCI0wgiSp9B2Bv/jGanu75mGp4fJuwAW6M3NV
	 4+tkzRnQaBu4DlYkCetufjeglvMhauEyYmPNNOs7JVhzSOjDlOzZ7JHTY6nK3XNvj3
	 lKnbMTz3xn+dixlZxMCX2v0jFEB4XTJFFDSrMeHil8Ianq+37kCEQDpG9XU6JOWe0t
	 dlFxClvgSuKJKgk8qRT5agK12cfj1LCtfa7iuHqBD1P3zTfjgokEl3LV7Y6MmxN1UA
	 FSyS4fn/JIjLV0OBi/CKXQ+HIvUSqawsnfDyccI4Xkx//alyLJwJsGrJCmBe+m2Mf+
	 O89+wH/8jIcVw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 35CF247996;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:07 -0800
Subject: [PATCH RFC v3 33/88] KVM: guest_memfd: Skip checking outstanding
 references in PFN mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-33-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=1241;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=SnLBT6Q6uhpsf6Q3iw5E3T1UAAmiNXk2AxpRgy0J7g8=;
 b=m9e+oS/Q1dzTtHUoLjbiCU3McBzID8fswXgaOQ6OOb/+PCv1AALy1hietTiTiQekA2K0+q5jS
 PfF/iF2VW0uDRQyYKZTqF9IoXUfn0S6L2V5tqYieTA37ALBQJUJWn8L
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BF4F040002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 9gkgfs5hthe8qdd8js5qkq635cstqfy7
X-HE-Tag: 1794012217-202630
X-HE-Meta: U2FsdGVkX19LypEP5ogYOOIHp50MEfZX5slUZAiDjI4lT8ObxMXdvYJvdZJSnUCoctlRXs5H5jwxAsCtv6iXFJw99FXMwjD3P2CXu5erAqOgRKhaVWXoovvXSfXkN31R+UOKXmY70+Wh4QhdwvhfAihE/cdLIQWA2jnpGBOKEkuiQlMhjiHp+paHAeM3mxxj7gDp8i3vyVozBzamr67P8oagrgv57gEmYds7CK7A5gy9fpC2y5M8MHQ/8ogw6WoqKjlxAB/WlF/eqaFHMrdq7PaBOLa5lzdCmN6MCMIAElPCa0OrctwAu1Sme9VyVDTTTYfFrpDS+wgd2MxQvkyJsxNhatY8gv+fyN9vjQLc4SBQrGPlHFkVt7TbYrSFQiTKtLqG37KuFEssp0M1SvHBkVhdecGETVHvZMypy8Uhkar1TOvyLR04LXsX69KpUtQbf78KhKkO2eCLDeeE2fp8qF5PVilZUJxef7/Mhf+FzwaY5pkZDz5Ib4jcxQleObQ6BwvLDe17W4GksMX44640JFyrwmYv7CMdTJwY043/SkdFuzC20QJhCgEX7ZqQDc2JrEH4z7Aue0RCvGwZBof12bhuBSOrANnYIFYZoY8W7PcORauMHhHcdshcOjSSFnxcb8weDoawBtK/FqLxFAaE0XPoNd/OZiokixo9Hik7MepsQfRENcD+fpDcmB81IGu7x5HQnz8IoRCHq055E/AhIGGekonzeiAPlirXzcpMLkqbByDqGZXeoXTERf9ng/RJ0caWGcVOgkLgDU0/tOEXUY5LE4cN4iB+n9SivJhIBsaNm8APdPXH/+3uSggmZgi9jC5rlcJeYuV2e0n/MC1cxWc+WCX+TvGSM5386eGrbiuHPS4CSsmmEcXv3QDMhZR7bDpXz4IJVwK6GlZ7XyvVArgoujFleSUVSZvR49S3qMdYdCPVUbw/ELJ6jG+W5UXreVAqGqYii8xGozTXz5M
 jSUV38FI
 LbqIRqF5rJxuADOf0eRTbo67BaZ7K5CsyJtOzsx7znV+5or6wVMrlG+rh9os74wT5FqjgNBfdQRKX+iCKf53/+9aY5LZT2bGyXERM9fajniMLBVSTTHxpoxkCBiZQ7M0Jg67otJIdEGV+7FW9rGPCX+s4/Gj/eVq5dZOrvUCwS2qznTcYhauWOizN+0wl4TP30TUaUV2XrxvNvq8+E6EH2e38qq3Eo4vOGodQmNg3V2vFpXJiUW7hiJ0yQvlRUV0xp+kMG5hfmRwNVfoWVjcYSwsfyk1n66Blmx1Ha0yjqbClZm6+OhUTw7Dt4noLZAKPqUxGid/Xjs1QmLIQQRRE4UZKmuj/70mFbIgp5AzoJCplKQ9BE/CTN30uIemSlMdHt+HcaWz1WogUN020CxqiGrRUb+8ZfwlEzjnfIub917ZM/UFNHG3YG56a8Djvd7ZZyqLASelIsZgcXW5b30Fp+QvQcS89tzghm9Jn9dVwCU5HpTi7EEeCfsW6uCFFzkfnF/XP8j5oOPISyqZjETR0703OArbXc2X+t+jJuU3VF5cUd8J8VdOV9tiXwfpPUZ0CblERUyxpihyn2gLqqR/oVvTOvurQudIGGpy1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When converting memory attributes to private, guest_memfd verifies that
there are no outstanding references to folios in the page cache.

For PFN mode, retain the part where memory is unmapped from userspace,
since userspace should not be able to map private memory.

Since memory was not mapped into userspace using pages, there will not be
any other users that had GUP-ed the memory and there is no need to check
for outstanding references (that indicate other users of the memory).

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index e94f2359b7c9a..ceef61cb63a0d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -901,7 +901,8 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 		 */
 		unmap_mapping_pages(mapping, start, nr_pages, false);
 
-		if (kvm_gmem_has_outstanding_references(inode, start, nr_pages,
+		if (!kvm_gmem_is_pfn_mode(gi) &&
+		    kvm_gmem_has_outstanding_references(inode, start, nr_pages,
 							err_index)) {
 			mas_destroy(&mas);
 			r = -EAGAIN;

-- 
2.56.0.455.g6c5a503b38-goog



