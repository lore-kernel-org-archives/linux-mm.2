Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F543606A831
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bQdelZVy
Received: by kanga.kvack.org (Postfix)
	id 5D8C76B05D0; Fri,  6 Nov 2026 19:37:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6916B05D2; Fri,  6 Nov 2026 19:37:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 476C16B05D3; Fri,  6 Nov 2026 19:37:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 170AD6B05D2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:11 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3C4C14027B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:10 +0000 (UTC)
X-FDA: 85406458620.13.2EF8172
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9042E120006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bQdelZVy;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011828;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OqpfAUM6RL3PzGZLar4gOeRZzwpcSnfwgpXmVVFrLVI=;
	b=WlCfcxPlyodPxe3VHi81a7i+8Cn3mK67Vnn5uVbzqe8w9IF2ukF2s9KSkstgalmhY9FmKs
	8rBe8cD8zGedGKomCt9DHaHY2fUTpzNGTjl+U1Aq2Rv7hA4EZk2ENq1NJXl/zMjUv2wG9n
	g7xyPvdqIq0ellY5gJH0r6wG0o1vVeg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011828;
	b=ItvCUsfc6Cur5GGvv8PV1cBRmL4ndbvpA1Cdvkp/UtDpb+K2FVDHpe0wtSQ0WgTe1+xTPe
	I8/3MaP4Zl95uwHPl0IkuEA/h/hIGWsoS4rzDXNOeRZ2yZlbt34U+9p1Qebwu7xdr47op4
	Z0pDRJ+L1XQha0yiFMzIxd5W+7N/4+0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bQdelZVy;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A45A144095;
	Sat,  7 Nov 2026 00:37:07 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011827;
	b=WkxG3IA3IISjlhi0ComCYAO8s6CeWT9ZWCppuZF18hv1+K8NmvpTFD4pADpVPAnf509f
	 06aVK/g4mUG6p9xAQje3IA80lMQ2g2QEKOjRNHwe2WGlqh0TCIGSt5mo9YerLB1qAoYb/
	 JtU8vT+8PBdaPvVOq9SrESQau4tAkgB6KzvXSXjdT2bMCL8uW7c+O+yR/6l12ie1ujVbH
	 KtMStZa8+PNC+/c7VW79xpq1B9sY2rq+jl+X0CrbiFQ0D5IvxOFywHs0T8fzTKS4XU4jG
	 IcUxpNy4IJHDUN7EQ2tx+UQ2Rh0LRm9fQ+S3QZCanK2U+jDjOnsmizEt/dNevgmzH/A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011827;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=OqpfAUM6RL3PzGZLar4gOeRZzwpcSnfwgpXmVVFrLVI=;
	b=r7AoIT6+Z2WvlaE3VNXpVkjkkEuUA0pe5wlHBHKhzCh/YIzRkEe4PLhju9ZeG+F4sEug
	 /cUKCSicCSjgEa23B6CIR4eLZ9f5BZ51jClCpP97UqneuCiz1hCmeNfWCoxJpumIaFFGo
	 RzKERZqNeskkWFrSsJmV2jFFH87g4pPzlDrImFyFN01FJXaCibbS4oRjvWWjIsZZCuQkl
	 hfOUtigTJlqs5C6uLfr+bXnd85TTBxPafJMKNdGtPGrpB4BVxMnszni9IKINvld79z7Lz
	 Fb2w+QjHaSFM/0x3uE8Dp1xU/3pzD3gVhIGIREBhCwCKbCv2pKCYoCJgGWD0hDpWM2w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 780D01F00A06;
	Sat,  7 Nov 2026 00:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011827;
	bh=OqpfAUM6RL3PzGZLar4gOeRZzwpcSnfwgpXmVVFrLVI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=bQdelZVyvzyp0I9s6V40CthXVoMUSiMzwHxGzMwnNOBznLtjQvzWXksuo24o22ihX
	 c4bv2xr9a5IQZxeKi8cMiPD/nD6XbFgVtjhNTL083D9A3VfoRMFPUMSxLG/Dqdv88g
	 R6XWVqyOvR4ZMXEg3zT+TRidcazQ5QdsAadBAGNkgDJaTAb2IbLTBL07HqahiF4Xtp
	 CsfOs3VNi18WszhLERoXJaU5bD5Nu4UWJ5WVlcSvFyDQLdqX94yr9GYl9WZI78Y4oT
	 THA9RJOSDt/2kUwc65o9uPYoip3OYNdpIy0Nooxa06Yr4/DIY9NZoxpLkIA2whlJ/O
	 15BxURqzsFJug==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A9569479B1;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:14 -0800
Subject: [PATCH RFC v3 40/88] KVM: guest_memfd: Add TODO for memory failure
 handling in PFN mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-40-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=995;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=RMoXxdr7unZnobL7R1i/MK8zqw1q/jitBNuF2OvUGw8=;
 b=hjk6HdU81k97DczNhIQxswAsxYsu4tIqPkDlpmZd+T6wio0f6skkcsf8gsFCP0CMvMeZH6Uiq
 yEe+MejhQ7bCc8jLcDgoJYyK2pebq3F6/hjkDqs/RM2tzA/djMSle1h
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: q11h6bdqyu5s8fgwkrgmydk6u83xktjd
X-Rspamd-Queue-Id: 9042E120006
X-Rspam-User: 
X-HE-Tag: 1794011828-819330
X-HE-Meta: U2FsdGVkX1/ednQLIwVa1O8QC06KQKP+jljxMdmg0XEky5UvabZb30ojed18wyJw7K38+4tmPwL4tjNRHvrupeTOO2lgTwGXxlfSYy5BmZiwyF0kwglYS/8lOFgfCwoB0AP2UmZyVee4B+/FZZw3NwCQWch12Sb9jYuL/89sLqq84i4AM8jgkaY520QMNolXo4uxFY/QKhvECqCTJa8+f5l2Apr5q1I4Ld6FzS228B4BRYcOm4n2Ilf6fifqkxEqokOK1gcbyBItJ/CxRZDxcOwSa4vmZDgAENExpG2kr6mGLHaK8lEpbmAiCRVdiYPdHmgRz6I0+IQYlp02f3Reg89tEhJ9uKnvHIW0SW7ZSVOJJT4hCNBvdnszoq2uIiw9YwAAEetaGazpBk9t4BpLrQTTJHW9sjKvrg8Wd+GNR4oHFv0MtMusacIrATPSG6pUofGgAzZwKcJy6FfTIb2LgTVj+Xhal8PdXLaC8LIAJFozjdPni2138gjDLI+lTBgZjQUCzNIvXmuXtzVm2xtL1GTNa361IzMFUnYJ3DFZ0D+ApoDMP/jrQ55/TLALcl8NkWRw+svxyR7G9JdJ4EkWegIT4A1hOeVMR87QPXf5gvIL/o58+voYv5YPjvihkkB/tedK5sLNZOburxyfVmwU2VngsT9zyFFtzCrQxrkULxjNVZSrekP2dMcakY4NYJzuV8ZSDEl7RUWMbxFwyxRaDs20MO/WnaKg7NOcrdoZWav1i3AVeVg8fdjzFT+kFX73SA03xbRK6GndE+zIOe6R0PV7t/mhftVqPFhgrPlnp1ere82q+vZcDRr7P8TyHXJpEgKbmHiOF5Kiy91AjA4lHKdETijxDE5Cn8qw24/Y22/BltrOanRVqtCPXEtWzg4ypWPFhPg7117uF1vWIhTEXRaqpU9Dci+ZBeVtl4HdRoB+dZYZ7ruBJ4s/lBmfU8V4QvlGc0OcT7Lw6x91r0Z
 jVC7yRYt
 CegcMItHohfUZf4hSnVwSkuQ8gmE+ahtxEpOoZUu/JleIrPzO0FlBLQ8xkKOUDYYp2mxy1G+4fqpRoRc548xROjo2K3DwYEAK5/66UIiwvoJ2E84M0ML6S0a1eQbXmZ5bPGP0yQ6LIG2AlJ9Go++rIQvFVvjscw3o99Lm3zzrZoUN/Y9lXz8yV7AyfxMD0OLV+8w4UKXi7GFb5n7VfDNlFv4ES5V18oyCk/4Qs7WvW66tKdwnxzKCQ44bweT4Gh+xLvVZ0P28xQvkprmkIAyX+YAgVnSvmArMMbP1no4LUFLfYVt48PBcrzwnWlO3FUmy+GdZqK3YblGoDIN+o4YkwfZXu5HY7px58DnzsnyYQJRS5LSYdotxoRmByyp5b2jVhA2MKVP2SakDNjPdCwiEAAxtGg+OVMPVwpLXZE1iVMWWtaAplDnEJqBv599eGJl4skBOPv48OlhsouZ0ePhNXNuwb104l62IjjGnmAAeRYQkn7m9E6BTrTWW57VRv2Mc9er4bKMSzZlgP8hWlho1lA0Gm6yMLIGMPm76YVPERHKLn/ciYWb/Oahs3d6zJBcwZ67MEnRz/ZhrMaqYxh4DlloAuSDRdqv5es0C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a TODO comment noting that PFN mode does not use page-cache folios, so
->error_remove_folio() will not be called by the core memory failure
infrastructure when physical memory errors occur.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 501c3e250fc98..ffe1508985d61 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1127,6 +1127,11 @@ static int kvm_gmem_migrate_folio(struct address_space *mapping,
 	return -EINVAL;
 }
 
+/*
+ * TODO: Support memory failure notification for PFN mode. In PFN mode, memory
+ * is not backed by page cache folios, so ->error_remove_folio() will not be
+ * invoked by the core memory failure handler.
+ */
 static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *folio)
 {
 	struct inode *inode = mapping->host;

-- 
2.56.0.455.g6c5a503b38-goog



