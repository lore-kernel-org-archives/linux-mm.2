Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87BD060773F3
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iK3vWSYI
Received: by kanga.kvack.org (Postfix)
	id 011F46B05BE; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A746B05BD; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D297E6B05B6; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CB8F6B05BA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A0898025D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:01 +0000 (UTC)
X-FDA: 85406458242.08.7F56CB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 218D6180008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iK3vWSYI;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011819;
	b=CgUH/fp9h7xkIhH+nymM8qCIalkMLmi3d3PQfogmj7s+1fPIVtaALQ5/QJXCsTQEMfCO1+
	ZR9Tg/NBj21iQHj24Tffhi8dfPNnqHDY6tE51nA0/dZw2KeJH9YEWci8vAhTtO7ZUUt2zE
	3dlWMdXIIQ6YTPSVrmASdXbNPN+Qt3g=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iK3vWSYI;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011819;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xU/UQNiUIyt+pklbBhbiTSxK7mseKJX4CEa0PS9WIcU=;
	b=cJjVownU9guabzAkkgj6/Lzn5Um0fP7MAK60D7H5kX5EuUA3Bt+9hWN58f0kGOTdPVQYG6
	lccXlFWuer3phxhQDEw04LvNmtArN4rIhjehfV8ttlJUHtrp80P1GLlCPym1xhALN6DthL
	6SwuFM9YwEn2oV4wmJeRUuyxB0WL4Nw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BBA84195E;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011818;
	b=yv/918BhOVQk+kI8AB/Ddix2jqNhc1Acbv0k2fKCRCKwtR9L7NUKpCsz+hTBjJ2bhGm2
	 t7POReBD8udftzZLtp4BrPN9Znba4m4jxOkYPT7g3qXFx/kNmIhNzy9Wbu/fgDa0Doe2V
	 Vnk2uEbOHmdFixXXlavQwiCk9V8/xn0nHkBtE3et0PYoolGAc/1DF7GebvlJswqe0cyum
	 pld0XkVWrtE9uzml/I+TgCgwB7z6lEbByFg5EhGVgjBzsbXey5RJpz8re6lg0hLxhPINE
	 5yYJX8Qxl+BzazyI5qZ0s2JOyxEIW3hK9q6kbcMgfS3mzAa+b5RDK1E1+oT+wx/YFqw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011818;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=xU/UQNiUIyt+pklbBhbiTSxK7mseKJX4CEa0PS9WIcU=;
	b=IBJtIAqnZVM/izkS6tPzOKTgdpC+V6sjLbm3d5/IifQqBWLyUNd3dpNGOip5JCKqc6xu
	 ED25ptjOGR0jc5mAnAWdnIJ9jOJF+tqJEHsos4baXYCUzyX4cQ9kpreFTd5E+XlchtyUw
	 aoE7qJh1BsBeQmR+vIrEHx3Tohbe99ZXnMWGZtvDIvE9uAGL0bd34cU9evIlYikfOx8EJ
	 QB81s2+nvlJEduMRC1IzHHGvFlqb63Nn1telsR3x6xzT8FEke3xg+s4N4iZIYEYpeRrGn
	 PEbwxAzlde1SHc+c4na2nLiz0ZANS4o6e9FHK7QxFmudpgm18bXGP5kDJfC9sbrEqeA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C1A951F008AB;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011818;
	bh=xU/UQNiUIyt+pklbBhbiTSxK7mseKJX4CEa0PS9WIcU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=iK3vWSYIA+CDNzUHbtXWQhDoOlRPy0O/UK5/+2gSox7ItgB1Mv10ljtL9ZFEr0Usx
	 9NVZHbK4f6vRZy5F+hFh9vRP+/J4L/u3ilgfP5IhQMVDyxAltA4pP2Lziqu8gkbLu+
	 ZwN5ON1VW7+yw1y89RO39Ionub0Q9ZmYtpHdELiRIrXIrvx6jLXObkY27uF/gbxASp
	 V4Z/pDseTxa/Mi3PFseR2hd0Jbj93N+H7ykmgRYcuKZ6lWeTmsTX81sm04Vdx1qmx1
	 DEdtiVgCc9AWMno1cKDOaZiKKmWQFfptXUjKDllAaw7sugX14mie1lmxh7r8XizALS
	 fiXLRQFMS9EQw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7FA1D47938;
	Sat,  7 Nov 2026 00:36:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:43 -0800
Subject: [PATCH RFC v3 09/88] KVM: selftests: Test rejection of memfd for
 resource_fd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-9-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=1909;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=jiwqzVYGQdXa1AlyMlZiDSlQ5Amwfala9fk+uK/j2tc=;
 b=PszqvFys8SqnJc1HxGZEKNlvVEFwz7sIeHsPskHnWi4bT6RpLtog7UsESKEfmxvHt5TZCim82
 VpkdFcaoV62BbYTF3YA+BLAEU556e8Oz+fbgR9PXpvhp9j2rNyMPT9f
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zyqxuiq335fgupdd7d8pxdaaj1j681ag
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 218D6180008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011818-455315
X-HE-Meta: U2FsdGVkX1/zwcDgF5UaeqxSg98EgSleeAQmnMENWTz8BbL4KshxR8EEjBzIW4a473FxiOO5vlFcd2ZQrpwLHghfFxpDvqP/6ziA6gMkc9VZ0XOIL5XIasiT4ss/LXktY42SX+nk8hXRA8Q5hWOBC6pLV7xKeJ2qFXKMlylfZ/VyaT9LtXIDD/SDCp+5r8sM+BP8mC8vrPJM8BNbhBAtUhR3GedKovtddAOFAtS4FfiOp2upsNuoOMZnsChZ5p9rOBfXyb5tOJ8/+ffTZiYZ0N0ZZnYdLiqtY1ZgxPsumbN/z5w3tKYEdHt9K+ZKvGGubnDDrcdNXQAenM2Hjb2KAH4WIdZ8Wf1YB7FDnfU5rBsp39ROxd3RlP1ZBKms1UHrcM6RW1XhmEstS5lAAt1h/0ohsZ9aLwu6e7/o81bgLFizzxpCiXZPawxIxdZjIetrfrRbzK/HKw7mhoS2JS66EFtLSK5UPHD3l03ihHAyUWRoRB7os9FA6cwAWgOFZ/589ie5knS4xn5O7e1it7BrF5kcQRckvy/KhCPMgZoZwGqvT0gILGlXRsiFXbyocrV7v0PkeZC5FkFju+4K9v4deK2ZDIt9MII5n5DKSpGjxZxlBi0t+/fXy8EJEHByuIAdkFcBBGeTMR5SKxqE7HWGKrB98DAG4syuGcL+7mLtnhjFR905E1ewnxmNgQXXwFoAALejfbMSYnDBROpqUzZosL5KLVv/M+bcEGw74+U+REMSzTheCXS/RsBxSHFcZKUJ33DPIcv24xdzlEY8N/VpmLCQ8GQV7qhimx7SS2moFp9cgsOH4AFbRpLIvwGkuh6CXLXVClOGcVEUu0ZTassHt4w62vxpFAZWh4GEKlyFMvdi/aedGd+5H2sXW8zrNJx7YRwkVDy0GIWsfZAPvx+DO363HcDeqALSqCb3AToO4OFZBkreG98/JECupAJ29cY+LZW2+oYTpl14MO5WpQP
 0LnZenOU
 zDn5HX4NRx8kDH5aNYEvnFomBzg/CqY9DvjLEgVmJg1XW5z45HY0MVyZF+8Y7hF8PxgEvm6zQs2N9juYdxTYh7UtZEZAPP5zkCHhsIkHRYWNSXsm7kS2fH2mQ2fPwp5L3fjAjye7H8XvpXgBOhcXBjvRE4tQbJzZUWF28iV3FM9oehthb7R1onu1pySKp+Ivp90ASBdDHSBwFsqcSXRplu+pIB/xGeIKoIdsxFRAwvu9ggLEuol/ZoARHiYpQB/5eKNgV6XECl+Ett/8gc6hb9SmSQnk0lhsnZYyS6qJ+xBrOSALI1DHJEhkPpfcnjo4KyYHKoSEUCQcJJT4G1Ee4+n85w5H/LxQ5s/K24GD9o8Yv5sWWFe7fw0Y74c2oSZT/jbUDaAdk6k6YYqX6ROxjibbRewDKTHdQxK0u/6nGY8zLtIEqc7mz3HQM7icZomPkIweCoWOA2F4T17p7zqM93j/avb1/gWoFCc6ev5MIDn0qPq6JZni16sNQrne56GPGH8SAvuCmWWy3WqhBFGBHE/C7D2avvaOIAKcsP1i+UNPueC58DRWLubVP4AIm7HRa9Asb7t9vWX9sRz3JGmTwE4FCKgQElEqTxjkd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add test coverage verifying that passing an fd created via memfd_create
as a resource file fails with EOPNOTSUPP, because regular files do not
implement gmem_provider_ops. Only directory file descriptors representing
the mount root are supported as resource pools.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 445396860d819..d62ae23256083 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -457,6 +457,27 @@ static void test_resource_fd_unsupported_fs(struct kvm_vm *vm)
 	close(file_fd);
 }
 
+static void test_resource_fd_memfd(struct kvm_vm *vm)
+{
+	int fd, file_fd;
+
+	/*
+	 * Passing an fd returned by memfd_create is rejected with EOPNOTSUPP
+	 * because regular files do not have gmem_provider_ops defined on their
+	 * f_op. Only directory FDs representing the mount root are supported
+	 * resource pools.
+	 */
+	file_fd = memfd_create("test_memfd", 0);
+	TEST_ASSERT(file_fd >= 0, "memfd_create failed");
+
+	fd = __vm_create_guest_memfd_resource(vm, page_size,
+					      GUEST_MEMFD_FLAG_USE_RESOURCE,
+					      file_fd);
+	TEST_ASSERT(fd < 0, "guest_memfd with memfd should fail");
+	TEST_ASSERT_EQ(errno, EOPNOTSUPP);
+	close(file_fd);
+}
+
 #define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)	\
 do {									\
 	int fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
@@ -517,6 +538,7 @@ static void test_guest_memfd(unsigned long vm_type)
 
 	test_resource_fd_invalid(vm);
 	test_resource_fd_unsupported_fs(vm);
+	test_resource_fd_memfd(vm);
 
 	__test_guest_memfd(vm, 0);
 

-- 
2.56.0.455.g6c5a503b38-goog



