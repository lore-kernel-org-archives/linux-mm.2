Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C218606A829
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PpFvUw8I
Received: by kanga.kvack.org (Postfix)
	id A6CB66B05E4; Fri,  6 Nov 2026 19:37:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A445B6B05E7; Fri,  6 Nov 2026 19:37:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86ED96B05E5; Fri,  6 Nov 2026 19:37:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 531346B05E3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E40D114016A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:15 +0000 (UTC)
X-FDA: 85406458830.07.3D157B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DB6301A000D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PpFvUw8I;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011834;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TmrtUeRqg7PNOFUzBw0KGjO6eayo5TE17ZzIRnG1rFg=;
	b=hpqpfHM08vDlaAKHQhizWXR6gKkQjaszAaDUc3ilPQf/V45IWpN/CpYjK5IZ7IJcjHkXJY
	CsjNLySma8QTfZcwc6rOMFnUNZWWEzA7qsUzpH76B0IrZ+6YFU1qJGOk2brVMgAGFEGCiE
	6kzBmawXdLoasN+/o980l521MC04lVc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011834;
	b=S9HXzeJyxeBgMfRQH3LnoBZr0z3c8MnEGFsDwxRrVFTwsvvLfVstv0cV+HltD4AY+rQ3IC
	rlQWT/Ckdut244BrwoBfvDpBcmtjP3XhFiBnWgwVS30xyAx8YfFQTmlpd/duGD1xaab1l8
	pTiuzjSWhwWQjd44QXMlkW0jFoJ07CQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PpFvUw8I;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73A2F60D09;
	Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011833;
	b=pmBs4c4npqjzKE6M1rBYxQU9MJpNGg+HZ48YxljZxWO0ZU+xJT7J05zcxDRNK3pE3pAF
	 gO3KmkMYi+JmCF/b2FjFx2Y34vA/wdUDurBZJx95SHLaAel4HV7MMfxAPaNYXVSEjUiY/
	 TSbpp/Iz+j+Z+d3KXRIrmXMMEYqz0m0p59st4LzBOrbj0XlNCcrq04voYrQLtjC5eolVH
	 30WPulrhDX2h+c2xTLopF8TAzvHiPpQKYdVEWMP03ZhLhr5cU1bCg03b4+VIAvvqAQyuC
	 SNstjoxfldPs22KFnA9moiVBDKyGq9UZHEvMjEWVLo5OXvkjALskkR57u7jQTOHuQEQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011833;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=TmrtUeRqg7PNOFUzBw0KGjO6eayo5TE17ZzIRnG1rFg=;
	b=ojY1UX8j8Fan7G2I0aO9foYknP17k+NMntmMCiNldQIIRjpPVxf2Zq7ZQfwnwDHpPCjd
	 G1Y34YuTn4KyW+UI+tMFI11iZbiwfjqQ1qn6cjX8FWOoZ8k2T3TdVBmQBpM0Sa8bKDq/B
	 J27fal414xBhp7xnGXHe8iiBM3n7l37Azwh3fJ4lOBq0DeS3IzWIpjIZZWNFoEGqoBmeU
	 iYez0rbSAJM76Ba/YPGRJZm/UETyfrV3Af3wIxC7eq9xXFE4nQJIDYlFbn4+mmcLCc4Uk
	 wc+kmMn5I1CJY8ZaCEYHZdCASNNWynCLaUx82k3gmhH1erXGX0oFX8RGX4h1Ub29AlA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 04F2E1F008A1;
	Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011833;
	bh=TmrtUeRqg7PNOFUzBw0KGjO6eayo5TE17ZzIRnG1rFg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=PpFvUw8Ij2hlXN/rTJjtjG5HETyrJIxnsjAgb1z50jOmZ7IMyxVnv/CFZIUldh4+d
	 viGZpBtJRsvrQlIh9hdZxXcnIZRbf24fOtGY7Ixi7hHiPoV+UYGqZDthmb75yPM2Vr
	 b3cN/Qo6H54aLQDSF+6+lO3aZwHEozxGcQgGPcExNF6N6yRDRBxL+CQYSYmD0QvYA8
	 e7l+CnG0z0hYqZjdT3kYTTzH/ovTKUfcz76aYVmDDMFGZ2v3isF0jl2txCpAAC4y0a
	 8QlZ3+6GkmH0SdQWpUdFV+cDxqJQt1ufPJP3Od0iFUKgXgblSypma+5U0LIxNGnti9
	 agBYxqDCtRJlg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C59D24797F;
	Sat,  7 Nov 2026 00:36:54 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:01 -0800
Subject: [PATCH RFC v3 27/88] KVM: selftests: Test marking page ranges
 read-only
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-27-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=3249;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=XtGmSBvwOq6lpm/Qp7pMrqoe2YFfpDhrMdOnKzGerIY=;
 b=RXpFZ/blAE/3OlyVi7XMW2Xei66nvIUzHHFOSfE75D2vfh85PBi5IfkkJ+1wpMS4aYJ6CUKUq
 34KHhBOxIVrCRV7i1xAF5/fCYc/JXC3BQwLYdYffAjRGjZyv6UyUMx4
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: asmf7hxrw4ye4cd6qfwpw6cc5rbm66em
X-Rspamd-Queue-Id: DB6301A000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011833-389536
X-HE-Meta: U2FsdGVkX1+bbc5OvwJUJLjOGenvu+scEbLjpYH4ls8fqbkff7edlviQuL92j8BzUp+Zu5mXyHNjaB/D9aEz7DC8TxuBrI3Jc8fjAme9uTAurXOYclP28O/Isl4KdLDbhnBzgurJXbkqwoc5DBFpDqHUHjLXTNxR7jEAxfuG2//yQkdNeiUVg/UDAPAnjFyu+EIXEI/EtZsVKzBGODmrE6K5LISTh5Y1n+miYvwbup9N94ALbNIpcS7TEfJmjWuiaqY/kvfpi/dw6nkvD9Sa/Slv8Yn0yBG8u79BbpqaEGOOrV/Y40jrYwzPi16fdjx0+RoVY9Uj9uVD/fdADQipyajj5FQ9Qd2aqh1+Yruy3SvikWQSTlmAVRXL1CbcvyUCkwgzIXRWLb7lCYu051i72zGaLBQlizFG287BIszR4z9dvUugqQZUTdmnPqfAmClieBuTtJG2onj4iKpMxiqTNuVn3lM6JjfAg3ezZLnOP6OZZvFBms0lwq/xKyhM5D60unJBDbxNimTPPf07pvw+DJlgc3gS8ydDvcW4bt9v+LUUOaE7Rw0nPgiqCIBjoggtemrtW2zqm/rrJ8llRdyusaKRy800CCl9BhQkVgo1LxG5PS1cSZ/x7ErxTZMxtEak7dTEiGu7WUGg/gyvfPf8KJ0ZY2l0ggM8jptkV2BXxq9EJNYsoy+2zJbrj63PJ5SM0A6lVS1hgbdmPZEFW0jAkSVBadTRmLFb6D+bqVRkY1O5ithG8oKcGp0R5Y/8k5A15dMIlAMjlkDUYxKpht4xXNBPDswCM65+7V/nluwqfY7VMqTGMbPlM6p1gHFxdFwPE9vfi1QofZklwtTChnz7qX6i9ZPFAxnKrztkJ9I+ijc32rRLZD4WP2gMjaGtbYKYNXyRz/Ra0zlEuqaAKWwq2Qaolxc7wUWVDd/RLUBU7p94gcuokb17+ZpBftUuzjhZ0I9nppTc2u6TbYisOAF
 JDbkF/q4
 ANG52PtF+fjOJku017iRC5c1BfsHmbDQb/FlA3Ev0v9oTDAleyPa5XPq4tVUmQ16q/kh9v2gcg15KMl1hzF/LlieN/Sznd7HppnLcjriFCcPsGfEQ0Be3MPW6tDzTCWvZNlTVTtsa3M4KB+ElWC4HjpCSA+3PqN8YWnu/Qk1SSELdclCjbZI1//I6OhbEOkESfKkznOcVzEnkTLwqVsQ+1Y6+GCBjFKXzC41k/H1ZZU+thNWpjdEmvnnLk22LWbSJ0S2o12NUbKCwqhEOKA3MEnG8hpaEL2WHOt7404hr9mN8vmPm8M56YjODeUSjpAJLrRrShxXY/olOn2hpNtd+pb3cDkaBXn+AH5TdE872jUW/5TZV5RjmwFlSjdNmzDD922au1DFuIUKvC7j5Z+4ssqT4XyIYoHX3shoxN56HQTxKeP2sGhXw6cQrZFUjLUkVFGhDkeWH8fYKcz7WcsEJgv20gW9dSd2tkU6UGNzr6KSjMAGU2+GTM6UF5pZlFmXvEylinFERR+LJZvwzpXNyJd5emfbpC7nCXBrLLVPJ+XKIcuScUrQtD4gaRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Test dynamically marking page ranges read-only and writable via the
sample memory provider interface.

Verify changing page write permissions and ensure that read-only page
counts in statistics reflect each change accurately.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/mem_provider_sample_test.c       | 65 ++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/kvm/mem_provider_sample_test.c b/tools/testing/selftests/kvm/mem_provider_sample_test.c
index 8fe634b0b4f2e..942c0519836de 100644
--- a/tools/testing/selftests/kvm/mem_provider_sample_test.c
+++ b/tools/testing/selftests/kvm/mem_provider_sample_test.c
@@ -136,6 +136,70 @@ static void test_set_present(int dev_fd)
 	close(fd);
 }
 
+static void test_set_readonly(int dev_fd)
+{
+	size_t page_size = getpagesize();
+	uint64_t nr_pages = 4;
+	uint64_t file_size = nr_pages * page_size;
+	struct mp_set_readonly sr;
+	struct mp_stats st;
+	int ret, fd;
+
+	fd = create_provider_file(dev_fd, file_size);
+
+	/* Initially all pages are writable */
+	TEST_ASSERT(!ioctl(fd, MP_GET_STATS, &st),
+		    "MP_GET_STATS failed: %d (%s)", errno, strerror(errno));
+	TEST_ASSERT(st.readonly_pages == 0,
+		    "Initial readonly_pages mismatch: expected 0, got %llu",
+		    st.readonly_pages);
+
+	/* Mark page 1 read-only */
+	memset(&sr, 0, sizeof(sr));
+	sr.value = 1;
+	sr.offset = page_size;
+	sr.len = page_size;
+	ret = ioctl(fd, MP_SET_READONLY, &sr);
+	TEST_ASSERT(!ret, "MP_SET_READONLY (read-only) failed: %d (%s)",
+		    errno, strerror(errno));
+
+	TEST_ASSERT(!ioctl(fd, MP_GET_STATS, &st),
+		    "MP_GET_STATS failed: %d (%s)", errno, strerror(errno));
+	TEST_ASSERT(st.size == file_size,
+		    "size changed unexpectedly: 0x%llx", st.size);
+	TEST_ASSERT(st.readonly_pages == 1,
+		    "readonly_pages mismatch after read-only: expected 1, got %llu",
+		    st.readonly_pages);
+
+	/* Mark page 1 back to writable */
+	sr.value = 0;
+	ret = ioctl(fd, MP_SET_READONLY, &sr);
+	TEST_ASSERT(!ret, "MP_SET_READONLY (writable) failed: %d (%s)",
+		    errno, strerror(errno));
+
+	TEST_ASSERT(!ioctl(fd, MP_GET_STATS, &st),
+		    "MP_GET_STATS failed: %d (%s)", errno, strerror(errno));
+	TEST_ASSERT(st.readonly_pages == 0,
+		    "readonly_pages mismatch after writable: expected 0, got %llu",
+		    st.readonly_pages);
+
+	/* Mark all pages read-only */
+	sr.value = 1;
+	sr.offset = 0;
+	sr.len = file_size;
+	ret = ioctl(fd, MP_SET_READONLY, &sr);
+	TEST_ASSERT(!ret, "MP_SET_READONLY (all read-only) failed: %d (%s)",
+		    errno, strerror(errno));
+
+	TEST_ASSERT(!ioctl(fd, MP_GET_STATS, &st),
+		    "MP_GET_STATS failed: %d (%s)", errno, strerror(errno));
+	TEST_ASSERT(st.readonly_pages == nr_pages,
+		    "readonly_pages mismatch after all read-only: expected %lu, got %llu",
+		    nr_pages, st.readonly_pages);
+
+	close(fd);
+}
+
 int main(int argc, char *argv[])
 {
 	int dev_fd;
@@ -144,6 +208,7 @@ int main(int argc, char *argv[])
 
 	test_lifecycle_and_creation(dev_fd);
 	test_set_present(dev_fd);
+	test_set_readonly(dev_fd);
 
 	close(dev_fd);
 	return 0;

-- 
2.56.0.455.g6c5a503b38-goog



