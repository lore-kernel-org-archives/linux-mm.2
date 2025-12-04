Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2333D206A7
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A674E6B0096; Thu,  4 Dec 2025 09:13:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CAF86B0098; Thu,  4 Dec 2025 09:13:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DF7C6B0099; Thu,  4 Dec 2025 09:13:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7CAF46B0096
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:13:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42D145668F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:10 +0000 (UTC)
X-FDA: 84181980540.16.E60D0DF
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 293611C000E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kt34g1Cb;
	spf=pass (imf21.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764857588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=isyNyNcz2cmNMZXUIhi196/Z7TRsBZBkmSpv3VPEYmw=;
	b=k2pzUU7PvfIU/EK4jV63Kyv1z+D0ktWCZznox4MAvul7DRwF5X/N67XbVMt5up0LgrpKkI
	p3I16OGoQUxsuaw5fokk3kMGVK8eBlNmnavjJYTvGa/sXGQmZdTqfjHjoC/hprOdhlrt87
	5V8y/LrWO1rL76FLqjpOkumaGg0kJso=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764857588; a=rsa-sha256;
	cv=none;
	b=KeofIRaIQAJS6MXOmmE3x/WyXi4n/DmgQG/5B1nkNVmyKj4fPs2jWqGY0Vt/a5Bg8gMtwQ
	ScWeNAeiuDfqootFMv26H7fciJMifubJfmnYUOrRpm+1xtPyslK7fEGWIbFFALyDiP32Si
	DQT9ksjj2MjoW5/0w1MAyHmd4r/EPJY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kt34g1Cb;
	spf=pass (imf21.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42b32ff5d10so1398677f8f.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 06:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857587; x=1765462387; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=isyNyNcz2cmNMZXUIhi196/Z7TRsBZBkmSpv3VPEYmw=;
        b=kt34g1Cb1rx0I0eU2DdQtB1sUcL0JV2iK/nEHISddQIuBUvq7oOsuyQyqlBmBw5zvU
         0HzPg5PuVqGdRqenpJ3Hdsh8cRj2PGnhx/bq6LqINojsil1kXYRf0hiBEMszZSwIkc4/
         BmXkkUT99ocg65V8qvbveBB6YuDD592W5mmHo0k5dBKj8oFmEC3JRnY3V14xFcFhhy6P
         zEDTrOPFH007iuuSRRjTHB8u98oiqKnYxeucTHcGvSEN7/wyvrYnGYl/uFfW7Y3hm15C
         Ii2hHHQpEXsxRvaNFkFCB30BM1gADvjhmnARMJvHvOTNIfm8vtYKP7XdlAa+M9UADLhe
         C5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857587; x=1765462387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=isyNyNcz2cmNMZXUIhi196/Z7TRsBZBkmSpv3VPEYmw=;
        b=er8Xxg64W9Jxhe2ZGN4Ji7jmCoIEDz5cFchcog4OYMQa7sE66HL1qMsvVzN2NQKYUV
         vF2bpgRd39rgQJhyf4MSy1lO4CVwJVrXvzH/ggyXRbmqvRP64jw7O1l925VVAajK6nxO
         7ct2g+JfvwHgvEcd9gIMoEdDnb/E43vtmP6wWlUFZBRXNuaZF5CP/SJMzFk0aSjJ7uU7
         ptfyCnDBcUrmImj3niP3ECV19dujk9yJ/e8MkbntwtxHR4vp87vsWXDa68vfgb/HVxDM
         HvVCUhyZruKcyqZpsqZvyQz3bp8rz40XbpVuA/hn9BGV/ukson8FW/ZfZiVWrs2b2m/w
         flCA==
X-Forwarded-Encrypted: i=1; AJvYcCXiCgK32/ehA091dqVf4LAkbH8rEkCNIUUgu26UPbDHAiFlS+M3MHnmXcwEeIc/L1iMoPVl6SICpQ==@kvack.org
X-Gm-Message-State: AOJu0YxRccA+AVXj6iI1Rh0+GKTCeN+OgCBwTPk2sGTiMlb3GaYcmnjn
	fZG8rjprxzcWJlX4h87S8jci5m5qmkHC+PepRrGtFg/LGeDPY9t2DFOC
X-Gm-Gg: ASbGncu7ZPbxg+QP1Fa+RdBaYgzmjkd7O3DcOUUzNKnh+BLpIdzjU/ZYaIVi0JPHD3p
	mphMdIcbGLffisv7TUneuGI8mCins3ZEFLTzvQeBLyw29dLhkAybMbfOvvnfKEgD9XaBZ7sAA7s
	0Ld2bxqoUf2GTNnV514r04Dc30I/Gwhh1KnZEHta6kfT8r2IgEu4AzMNEq0Z06aryRI6bw5LrK/
	eTo65RDZviRlK2fDe4IQsd0+Js3a03u/STCVAFZP7jFEn908H8+aMQRSSDPhhObbwHTqrsRrzov
	yXIKpaqKAo0OiVLNu2A27DJKGxeP7xt011J/U5Kw6LD72Jm3CBXTyk/YdKwHNI8zXCLJDZ9yG5S
	XUSCNTEv409p7KJpgXfFAs95aFkaI+e+sQdd24Np/SA8XXNFY1V3FHva6E2+0mro6A6qFRHyxDZ
	zolcAzeYAptTEZyYH3Z2P2MCtLtjm2QC3KO7nIA+THIYhdt51Dh4gALGx7kBDuyxkvzw==
X-Google-Smtp-Source: AGHT+IHzNmWdyGZHlpy0d/ld4zER7YnP7X7/VxSK89F6ur9TtLx9dRwcFdqJB8Vqqm6xuvTuLO1sQw==
X-Received: by 2002:a05:6000:290c:b0:42b:3661:304e with SMTP id ffacd0b85a97d-42f78874e61mr3830533f8f.16.1764857586521;
        Thu, 04 Dec 2025 06:13:06 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:06 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	tarasmadan@google.com
Subject: [PATCH 03/10] kfuzztest: introduce the FUZZ_TEST_SIMPLE macro
Date: Thu,  4 Dec 2025 15:12:42 +0100
Message-ID: <20251204141250.21114-4-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 293611C000E
X-Stat-Signature: hz9dckhxso5e353q3cgzyy8b7asqywxi
X-Rspam-User: 
X-HE-Tag: 1764857587-59927
X-HE-Meta: U2FsdGVkX1/D8RfYsp3gzd93MP/MfKYJwfTyhbNH3tGEAzpgF+4ijjp8m58x4ADBWKRaMxQ/vrC5xl/0pZCX8sBt2ru5ghYccyW13vCjGuZK+B4ZYxBwyc702ybF5g0r7JJKsrln2G6VRHkt9sM6E8cIR17Bw84i7xizPJhxKwe33/gI2q35/WVvfTRfMAnCm2cQm0xK0fOAO4/FrRr+SaJyt5IDlcWiEYw5LnhM0oRs0qJf9kZ0Mngpnn5n8rGBGR7HscE28GKjpeKjGeuNFgvU27idAnSvNLIH1o9a9LIS7N7bwiyrt71g//GVj5Otk4l9w9J4UHZkIxW5IBLEM2qZINHPp4QYcjlG94YC/TbujN/gumjh3wWwxnNpjy1wYyZxWL6jtCbBgWKY7EnH9dZbJwHvekpKap8qDd/6n7hdvYP5GxnV7a50wxHxELtZ3tLzJjaRR328/8mSew94+rZR3VbgbLgx8HxucspYT7M3Xaa1OcmcnuWzWuJcBuFSp9ZP1AYbkE70FhBXXYxCnMimWpn3uRResxztADtZY+sZaO95faVyZGdhI4dl9JsBCiFdCkxXQo5y2oAVcE9udli02/Ivncde/cFBZtur2AAB3npaphxo8qg0Ajs8WymqMkg0brC3aZz8dhmXES6Dyeo48txeX9Cd1Npws+fqcrwL9LaS5yCYXNeRXdJkpjyhyHvfPqJNnqT5/ml2gHxYQDvYZqu5PG5nFotoF8lvzCFR58+/LFs9o1ACGnWgycfWuxlwofiVL3NUDM9aWh/6xamroqmGUUKj9b6Dfx3Sc0BkWtYsLSTodE7NFHGbciTBRxOFdnqkKoqyZ1geIzaytOAMEPFybtBx5uPHCmgZ91VohW5il7o3nPGVv39EaKlYHs8TP259ek397OONPM9C9KjuldwTc/oDAWM1Hn/vBW+k8mHIEHgAxmuFIu5bEAp8BsG9QE4qOzx6koxVjeD
 T0K1rZ6N
 oiQv4juwrwz74/Cco6VENUrdS0F0Tp37plww53bYvVuorGGI3Vw/IfMDZqOj9RVk9K/8WxCP/HMHlW1AuSbB7UrKz6iE2N3/IJa6e2/ltb06Gt+RNk6D649rL5oyTHhcOO3bHqfjSgnD5batHufdLFTWt2vd/fwGjSe7dnu/AV/VxzreqiD3NmHcM1BH6WQ0ufGz4QB5aS9vEk9U9TC75B3JV9Cp6MhmgV6sSyRuqC9j/k6qy2nzwuFeZ4oFXFdFE+dxXHneEZCic8kdmN4HSUIu7CzyrX6xaKN/taLsqYYkeProna197yTnsN8FuTHZCgLZkr2x1/+6QDKItNFiY6BhcydoQAi7/fxDyYVBOpkGckMh00mHRK6ioBl1SnvPBQr6NBzey4SXJDTgDW1+BHaZreEfi+iPwBn8QFF3K7wKnnXgVJeCg97am0fY3P5AekIO3BMwFdN3IthzUIWgV+IvwN3LkD5dfsQqVdahY/NsLvknKLt3hus85pNg35EJNxED+k9l4S8ckpsPBzDEGlarSfFUpjbo4Swq8b1ubyTQdqqHr6m4TmXq+8CXkDEEqza9P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The serialization format required by a KFuzzTest target defined with the
FUZZ_TEST macro is overkill for simpler cases, in particular the very
common pattern of kernel interfaces taking a (data, datalen) pair.

Introduce the FUZZ_TEST_SIMPLE for defining simple targets that accept
a simpler binary interface without any required serialization. The aim
is to make simple targets compatible with a wide variety of userspace
fuzzing engines out of the box.

A FUZZ_TEST_SIMPLE target also defines an equivalent FUZZ_TEST macro in
its expansion maintaining compatibility with the default KFuzzTest
interface, using a shared `struct kfuzztest_simple_arg` as input type.
In essence, the following equivalence holds:

FUZZ_TEST_SIMPLE(test) === FUZZ_TEST(test, struct kfuzztest_simple_arg)

Constraints and annotation metadata for `struct kfuzztest_simple_arg` is
defined statically in the header file to avoid duplicate definitions in
the compiled vmlinux image.

Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
---
 include/asm-generic/vmlinux.lds.h |  4 ++
 include/linux/kfuzztest.h         | 87 +++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 9afe569d013b..2736dd41fba0 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -974,6 +974,10 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 	KEEP(*(.kfuzztest_target));					\
 	__kfuzztest_targets_end = .;					\
 	. = ALIGN(PAGE_SIZE);						\
+	__kfuzztest_simple_targets_start = .;				\
+	KEEP(*(.kfuzztest_simple_target));				\
+	__kfuzztest_simple_targets_end = .;				\
+	. = ALIGN(PAGE_SIZE);						\
 	__kfuzztest_constraints_start = .;				\
 	KEEP(*(.kfuzztest_constraint));					\
 	__kfuzztest_constraints_end = .;				\
diff --git a/include/linux/kfuzztest.h b/include/linux/kfuzztest.h
index 1839fcfeabf5..284142fa4300 100644
--- a/include/linux/kfuzztest.h
+++ b/include/linux/kfuzztest.h
@@ -483,4 +483,91 @@ fail_early:													\
 	}													\
 	static void kfuzztest_logic_##test_name(test_arg_type *arg)
 
+struct kfuzztest_simple_target {
+	const char *name;
+	ssize_t (*write_input_cb)(struct file *filp, const char __user *buf, size_t len, loff_t *off);
+} __aligned(32);
+
+struct kfuzztest_simple_arg {
+	char *data;
+	size_t datalen;
+};
+
+/* Define constraint and annotation metadata for reused kfuzztest_simple_arg. */
+__KFUZZTEST_CONSTRAINT(kfuzztest_simple_arg, data, NULL, 0x0, EXPECT_NE);
+__KFUZZTEST_ANNOTATE(kfuzztest_simple_arg, data, NULL, ATTRIBUTE_ARRAY);
+__KFUZZTEST_ANNOTATE(kfuzztest_simple_arg, datalen, data, ATTRIBUTE_LEN);
+
+/**
+ * FUZZ_TEST_SIMPLE - defines a simple KFuzzTest target
+ *
+ * @test_name: the unique identifier for the fuzz test, which is used to name
+ *	the debugfs entry.
+ *
+ * This macro function nearly identically to the standard FUZZ_TEST target, the
+ * key difference being that a simple fuzz target is constrained to inputs of
+ * the form `(char *data, size_t datalen)` - a common pattern in kernel APIs.
+ *
+ * The FUZZ_TEST_SIMPLE macro expands to define an equivalent FUZZ_TEST,
+ * effectively creating two debugfs input files for the fuzz target. In essence,
+ * on top of creating an input file under kfuzztest/@test_name/input, a new
+ * simple input file is created under kfuzztest/@test_name/input_simple. This
+ * debugfs file takes raw byte buffers as input and doesn't require any special
+ * serialization.
+ *
+ * User-provided Logic:
+ * The developer must provide the body of the fuzz test logic within the curly
+ * braces following the macro invocation. Within this scope, the framework
+ * provides the `data` and `datalen` variables, where `datalen == len(data)`.
+ *
+ * Example Usage:
+ *
+ * // 1. The kernel function that we wnat to fuzz.
+ * int process_data(const char *data, size_t datalen);
+ *
+ * // 2. Define a fuzz target using the FUZZ_TEST_SIMPLE macro.
+ * FUZZ_TEST_SIMPLE(test_process_data)
+ * {
+ *	// Call the function under test using the `data` and `datalen`
+ *	// variables.
+ *	process_data(data, datalen);
+ * }
+ *
+ */
+#define FUZZ_TEST_SIMPLE(test_name)											\
+	static ssize_t kfuzztest_simple_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len,	\
+							     loff_t *off);						\
+	static void kfuzztest_simple_logic_##test_name(char *data, size_t datalen);					\
+	static const struct kfuzztest_simple_target __fuzz_test_simple__##test_name __section(				\
+		".kfuzztest_simple_target") __used = {									\
+		.name = #test_name,											\
+		.write_input_cb = kfuzztest_simple_write_cb_##test_name,						\
+	};														\
+	FUZZ_TEST(test_name, struct kfuzztest_simple_arg)								\
+	{														\
+		/* We don't use the KFUZZTEST_EXPECT macro to define the
+		 * non-null constraint on `arg->data` as we only want metadata
+		 * to be emitted once, so we enforce it here manually. */						\
+		if (arg->data == NULL)											\
+			return;												\
+		kfuzztest_simple_logic_##test_name(arg->data, arg->datalen);						\
+	}														\
+	static ssize_t kfuzztest_simple_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len,	\
+							     loff_t *off)						\
+	{														\
+		void *buffer;												\
+		int ret;												\
+															\
+		ret = kfuzztest_write_cb_common(filp, buf, len, off, &buffer);						\
+		if (ret < 0)												\
+			goto out;											\
+		kfuzztest_simple_logic_##test_name(buffer, len);							\
+		record_invocation();											\
+		ret = len;												\
+		kfree(buffer);												\
+out:															\
+		return ret;												\
+	}														\
+	static void kfuzztest_simple_logic_##test_name(char *data, size_t datalen)
+
 #endif /* KFUZZTEST_H */
-- 
2.51.0


