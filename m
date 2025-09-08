Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D896CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 10:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0AA68E000E; Mon,  8 Sep 2025 06:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2338E0001; Mon,  8 Sep 2025 06:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB2E8E000E; Mon,  8 Sep 2025 06:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 898178E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:35:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D2CE1DF829
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:35:52 +0000 (UTC)
X-FDA: 83865727344.08.5237D63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id BB82540009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:35:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RIxrE/es";
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757327750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6qgDGmceY/oaPOGxDvJaE0QSmLhbdFfG6qh4SKtUo6k=;
	b=e+xGb8GrGUjkSacCFLacpSgJCI9k19OwxD7u3qKoV5kzFi0YXvHUhtO4oZ3PJbWbRw6Pkk
	b2iYtI2bLrHMzIRtpujXuSP33qzusec7dzZO8/6NaYgRro4AxKPbItEd82gr58Cl0atpUF
	uj0Ru7Re/kscsSq7MFEHdVTDsvjAVnw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RIxrE/es";
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757327750; a=rsa-sha256;
	cv=none;
	b=IATgQzoiQ8O5VRglN1TYZICpRFOUHLC4NjoDyNMt+K5jxkoNUWx4uK01Q1YqM0EsOnzzST
	UAUx6sB1AYJ7oMHqY5AHmiJ8h8UJghKrYrupOS+g8OOvRFPfFOhmsNUx1Kns/URIOJhV6n
	MKP6GYyVdE52GsZnGST3f5Td3go8gA8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 47CBA601D2;
	Mon,  8 Sep 2025 10:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD335C4CEFB;
	Mon,  8 Sep 2025 10:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757327750;
	bh=S6cq5Fd+Tt7edEdfLD7ze+ZKtAEEGtzWPj0q1zSXPO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIxrE/eskt77bpOXEdl42D00oFsZrNWJUk664XO5L1Kr7sUQ0lXCueV2Ef/Jbs9JF
	 sUjJxgWQXI5L4h6R8vpEcY5p32zOqHt7w+v7E9KKXxhbf9mT3fUXO9+UHrP9Cr1K0r
	 IRo6FohWiAdbvDiPfQT38MiVa96W3uwh6tGy5gbNzywrJZ6Etf3VUelji8jbVdCyGx
	 D64ZXEY+1Iv7fDNkaagUn0bp2o7JL9jBD6dpAtGxDfjhAGdJ50HmFZhUbC+FuAfWnP
	 uhYUfR/Og8yF77lezd0p8H/q56HI1BsIY/Gk7CL8i80H11vk5DCROb9Cqq5b/gNCwX
	 Y57R+xQY6FSSw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt
Date: Mon,  8 Sep 2025 13:35:28 +0300
Message-ID: <20250908103528.2179934-3-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250908103528.2179934-1-rppt@kernel.org>
References: <20250908103528.2179934-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d46annxn3ocns3rghtbfuhwzd8dpmcms
X-Rspam-User: 
X-Rspamd-Queue-Id: BB82540009
X-Rspamd-Server: rspam01
X-HE-Tag: 1757327750-179503
X-HE-Meta: U2FsdGVkX19UykQTYKrKeWK2EW353wn/la5EjIhEAgWC+GTYL5tcD2mcZJu598F2cjykN1pO7zO5aOlF2Bt/zSxwMqjjRoxfEPWxvppolNcFVS6jRdeIaj9ksmuGnJXcycAfGHDfZJ1MqzeJx0xNM8HnJQTAjiqXYy20v98VYdP9YUAiezjeLjGor8wgnyBIlhocmxzCe7JOz+VEsLPxuXNr3rWszJf4rLjWWk8IP67eOgL6EUYpSVwjXohUXCckfCpd6Fu0rOAol5aqVi/i0OZarFQ7x1A8orVdHVsaqQeW8bBWQijH9K1kXCdl2FEqEl+O5s+xrn6M8DSbqm82f4ptJLw7Ms5iiScp+eZCJPMVJS8+00xB+sdO0564lECwj0gewFTAlPoyfQhnAMa8huzhC3r5OD09cD+yCVZJXsNnrrezYe9zhieCQwK35TqEDXf6I3eY21oCNn9f7odFMEINPAK1OX5fVmrvk2yMOu8oITQHtOswcyEz+uZ+KvZk7HbYClyPfsTgls8/Fa2aCTOLgH0BbAqqnNQARWweBJ8ZGoq//Xvct1tQ5h/Y6kwpTe0ujFlsNslNkbPuXcxYuQE984WZ3EquiAgizYO9jdXbk+fNOkaKYoIy2f4V/XLUtGICMMP0vUCb/33thVLtKHJB81426YwSNO69WzUrPJaCMo0P+zKCpuKEoTowuaKpnc5UUcarNvmXtoq+JYySL5PDqeBsPaGGDELWwB6b1lVdj4XtlG1NicpES4nQWFffSjWnEcZGj+UdNWAcp51F81aL/HnqXe2RP6696pLa9/imyJ0MyRfe89dljuNeu9nyTn6+E27KzqnS9skvpanGzp2QLYN1h54g3QH6QfXHsGZVRoHkhYw+FkfiuNxO98iG+6TLmT4/oZu0y6S6m8wNDfni2zh1CJyOME+jTkpXvJKEDojdnFxsSlEvTyLW4+OtF86uwL0TpICvk9xQUHg
 6ynZjSJn
 wYvXGv/kYjnvQCjVKStluFgM3M0Bwi5n3ORysg7DYTp2y8/9/FiVgVsUG5/mGvpG+jxae1xOi0jAjN7+kz13qQfLB7pkoSrLoXNqP4dAC3h7onS0JVxiEWGGLeuTUF9PBQsokQ8XtDDjlKeSHeChXvF1uyUFZxmF2f9xfJNMIS1jOIvFXOuTGUf9y+0hAcgQLhRWFqjsx6N7Io4xrPv2eQLpZ3IkeUwyM8zg0GB5bzAoIedjEHW7UdGVl+yQGWGCq8qgMRQmoF6DFK6VBDZzqn+MITA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

KHO test stores physical addresses of the preserved folios directly in
fdt.
Use kho_preserve_vmalloc() instead of it and kho_restore_vmalloc() to
retrieve the addresses after kexec.

This makes the test more scalable from one side and adds tests coverage
for kho_preserve_vmalloc() from the other.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 lib/test_kho.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/lib/test_kho.c b/lib/test_kho.c
index fe8504e3407b..c46f577b6aee 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -32,6 +32,7 @@ module_param(max_mem, long, 0644);
 struct kho_test_state {
 	unsigned int nr_folios;
 	struct folio **folios;
+	phys_addr_t *folios_info;
 	struct folio *fdt;
 	__wsum csum;
 };
@@ -67,18 +68,15 @@ static struct notifier_block kho_test_nb = {
 
 static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 {
-	phys_addr_t *folios_info;
+	phys_addr_t *folios_info __free(kvfree) = NULL;
+	phys_addr_t folios_info_phys;
 	int err = 0;
 
-	err |= fdt_begin_node(fdt, "data");
-	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
-			    sizeof(state->nr_folios));
-	err |= fdt_property_placeholder(fdt, "folios_info",
-					state->nr_folios * sizeof(*folios_info),
-					(void **)&folios_info);
-	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
-	err |= fdt_end_node(fdt);
+	folios_info = vmalloc_array(state->nr_folios, sizeof(*folios_info));
+	if (!folios_info)
+		return -ENOMEM;
 
+	err = kho_preserve_vmalloc(folios_info, &folios_info_phys);
 	if (err)
 		return err;
 
@@ -93,6 +91,17 @@ static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 			break;
 	}
 
+	err |= fdt_begin_node(fdt, "data");
+	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
+			    sizeof(state->nr_folios));
+	err |= fdt_property(fdt, "folios_info", &folios_info_phys,
+			    sizeof(folios_info_phys));
+	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
+	err |= fdt_end_node(fdt);
+
+	if (!err)
+		state->folios_info = no_free_ptr(folios_info);
+
 	return err;
 }
 
@@ -210,7 +219,8 @@ static int kho_test_save(void)
 static int kho_test_restore_data(const void *fdt, int node)
 {
 	const unsigned int *nr_folios;
-	const phys_addr_t *folios_info;
+	const phys_addr_t *folios_info_phys;
+	phys_addr_t *folios_info;
 	const __wsum *old_csum;
 	__wsum csum = 0;
 	int len;
@@ -225,8 +235,12 @@ static int kho_test_restore_data(const void *fdt, int node)
 	if (!old_csum || len != sizeof(*old_csum))
 		return -EINVAL;
 
-	folios_info = fdt_getprop(fdt, node, "folios_info", &len);
-	if (!folios_info || len != sizeof(*folios_info) * *nr_folios)
+	folios_info_phys = fdt_getprop(fdt, node, "folios_info", &len);
+	if (!folios_info_phys || len != sizeof(*folios_info_phys))
+		return -EINVAL;
+
+	folios_info = kho_restore_vmalloc(*folios_info_phys);
+	if (!folios_info)
 		return -EINVAL;
 
 	for (int i = 0; i < *nr_folios; i++) {
@@ -246,6 +260,8 @@ static int kho_test_restore_data(const void *fdt, int node)
 		folio_put(folio);
 	}
 
+	vfree(folios_info);
+
 	if (csum != *old_csum)
 		return -EINVAL;
 
@@ -304,6 +320,7 @@ static void kho_test_cleanup(void)
 		folio_put(kho_test_state.folios[i]);
 
 	kvfree(kho_test_state.folios);
+	vfree(kho_test_state.folios_info);
 	folio_put(kho_test_state.fdt);
 }
 
-- 
2.50.1


