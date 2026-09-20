Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE165C982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9BA46B00C0; Sun, 20 Sep 2026 15:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72FD6B00C1; Sun, 20 Sep 2026 15:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13FC6B00C2; Sun, 20 Sep 2026 15:39:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0D2E6B00C0
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:39:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D28C1804C3
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:39:12 +0000 (UTC)
X-FDA: 85235154144.05.2AA9AA7
Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1005A180006
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:39:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="WCKvW/FS";
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933151;
	b=63UQ1ha788M/jf9W2IUXe2e0f+Q2GlGRjuidOSLtn+di4zdqETQ7VOE31CA5VagBwVrr/j
	9nOAa8lnI/VwnW+zy3c/6z/Rtt9mCjIr3v2L73zK+ubI926/57ThA4+xPIlMe8SBKsve8n
	ku6up8y1wmIYxza63a5LgpB6vONkb9Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="WCKvW/FS";
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DswF+PpHLQLFXIsTsYB07zyWStQD5M14yzCJNkAmPg=;
	b=o0QnEdKxqKIQa7nlhX5gz8R2OvlXOjmSTNfDcQD+EfgKLuaV+H7jzDek0lrEW/vjw0k9/6
	gueEKTtaiiJb8Ur7/CTZEixFdsMiUuCBok1JFb3Up6HM1b1RwaMkdWMd9ME4bZi5/h4QFO
	88pr00MzT8u3eTUyYw0lWpJCZHrxwHY=
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-895353e9051so18822057b3.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933150; x=1790537950; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8DswF+PpHLQLFXIsTsYB07zyWStQD5M14yzCJNkAmPg=;
        b=WCKvW/FSOPez2E0h6HU/1lSnHx0PUNyCBxP7+ua5bh/53JuEcVlH4hsAnTqd2ZDxnC
         pIxGBES6kGlNkKFc3XifrLE5XGK7zMaiDa9YIITQYXcOz435kIgBntjlrXRu/Iep3QEW
         BgGK9L8Twr7cBnPGaW47g4Lapk3BW0VY2qQECKcxqNKDXAYb4HAKp5EWj/mp9Qwk4i9s
         EwlIutdbezb/X4/EgIXhNckNdVg42kzRajbVY3EiLh9uzifr4GEI+tiWKEAtgcStptUY
         U3I8Jwv8/vAcyXtBiV2X58yREIxiayw3g41MC6hsbBsFO1eDHAYyBw+H9hwrjTk6vknC
         RAew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933150; x=1790537950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8DswF+PpHLQLFXIsTsYB07zyWStQD5M14yzCJNkAmPg=;
        b=vuKw0irNdam0aXcnfPiTJoczCxDKoUFF/zZmM96TaQkiJzAC7AvCJnzaATbESCLgem
         BHr1M5cnw017SsrPTkfTiKNtPf1vjhux36QKnlFnyeOFZFi5T4GGPs0YeOuQlWjvN8tW
         Wd3+KwNNkc7FHd//9xAdA4xKEftw59cffGMCAiMvso2brKFtVULbhBIJInR587ISv4oX
         tpBTsOqLQB0NbRwheLSjDkYhGlUQlLp860qJD9dbdwc5cnWhuzhw1DhzjL1qAzihwbn+
         9Ne/1zZRO6P/+zjXNoCmR7mJmR4jhM+NMoicCArf4TjjdriwQflxod9FvFRdYqQBjXnU
         zYKA==
X-Forwarded-Encrypted: i=1; AKwUvBwSdznMe6vjYAb9g+vaVDnNiaTfM89DnR8TN3idVy0MhFVoLB2o/MCJHArF1N2F604LdIV1R8ohjw==@kvack.org
X-Gm-Message-State: AFuF++krdl73H6xY3/kEktJfcYBITSubvsizJ/ogLdi/bhvL+q5eE0OW
	mdJyNC/up7nxDjbjLUkQjlVXfTfE6f2OEWXLmmqk80JcohNMPz2fG5fKYXKRT6sA+Vw=
X-Gm-Gg: AYBFou3J5+f2karaD1Z8i1iYYEW9w+Spo7qCqn353gw3jnGdGjCFS6o6gNQuhrixjDm
	8g4UuNaoO7XCSQNCkDdO+HsGrofppnTR/yv0UEZzzoyaEuOUSh++S1jv2vwe7udlRYLKuz5QDtZ
	jxDruvil/1x+GS8VIua0t4wq693xBf9sjHDZjyNhRrN4g72LkizV06Uofhg8K9k/DozBIsTfxc5
	FD6rLXz5Xr+e8IP/A2OQckmXhHYul8ByjJY0rEcnK+yI+XwlToeUErBhTbqOHj29kkBhzA7ww0r
	dOWATIGSOISUghK4fSw1myxDsSZ7uJIl0c1Kuzq1GH+ZrbsyRew02Q79mFHYPhjy5u8m2d+uXPb
	9CgeaeQljOYgnpMFQ00uj4cJ0rLItcTlPUZ6zg8Phohm/Tv8r63SZyd6wM16kUmgTh5AbxtnqdV
	ETJSeyfukUk5I+PAgzy4+lWE5Btc/s1Ym4n/LC+Uo7/egVL9SVY/o5VOpIFRUnWGU4fQi7nr3/V
	B2H4PECb/rIk3iGlBXedBTn8ywYW88p8R5982riUuC8inqBLp4JkpbU/lWPYsk+KPCBm8WupyoH
	YZQ2OU0drMSUa1CvtVw=
X-Received: by 2002:a05:690c:39d:b0:89b:6b8c:8edf with SMTP id 00721157ae682-89b6b8c9360mr12390877b3.50.1789933150155;
        Sun, 20 Sep 2026 12:39:10 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a41521471sm19169577b3.6.2026.09.20.12.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:39:09 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 23/46] Documentation: liveupdate: Add physical CPU preservation documentation
Date: Sun, 20 Sep 2026 15:36:27 -0400
Message-ID: <20260920193650.3373435-24-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1005A180006
X-Rspam-User: 
X-Stat-Signature: tqa844afixsp59ip46845cmgwx1dzxkq
X-HE-Tag: 1789933150-979316
X-HE-Meta: U2FsdGVkX1+xaRZuesutfwTclxqGzfNGl+evT/4VCaeW/Vl/YAbRv8edew61haK/2D78Noi5W2+nFpQFagoe4op/6H7zLw1QGjT7EqFVk6JzllKB5n/mpNd+/ivJN4rcwktnpCLBklymbP8p0hUlW8aNSrsSZrbV5HYitBPhQnkLzdywJtXegkPUBpCPytraH0rb8eOnMBqwiEY5NTO1LszRPSJEIH4seMgIoWt3+61cSZh2KbkKdwxBWFxsY1Ukwp9gOHP1VlTsoTRHVnOA+IalPE6/X+IJaSdd88TCNoZT9Ev+CMC5gzYVcRMRaADFYGSPYbtPntpXPQdBT5HOMp0l+ioiUaLy+BG8M9tUgiEPzfZdDFgqXSL1ORk2msOKwcLIHNKgAfyBXz7cehhVpjiYeLUumRu1pUMeh/WDilCI/HaYf3xmiAb4b4A0W5MxcnTZSR8au34fVW07w/4/1RLRPFq6G1PTkMj3ApsR7EvYB6b08M8vTUK8RlnvTnza11KgCezdMwJC4BMvsaS9f7yJmATRQI+6zIIvYGlPpk75eI5Cvgfv2c9fojidOPk0NhePCHxNhhO3+FFg8IUcy0xTrEp1ImOok8MKmF/MHWV1LwsCBrrny7y6pxIq+a9MG+hRD9Vq7HvYWj4zZkPbSO7vdFTlwrAQJIVYtCFUvuhaahQyZT9xutcpsGFU9eZRQC4QzZNUZNvs2ln4g3wK0uS1SQmgmjMalF1DhD3WbLrXG9Mpn6AtcI2kKfxUlFpK0b0pwhOYzdIyrHTNL6gx0G9ZPC4nJd3sLSYPTm2Wg8zSjzVkVnA7B/m4WzmXMg/M0uPEJK7kbAey3cj6c0urF+BVNZX1jDeam5cQYpIoAJ3iqNaam6eGot5EI9kd9696Onv0Q7hmKP3sMaVgkEmeVnaK2zsvrJZoQnmhN6Gg9idFVV1Sdtss5yJanVtO9qRY0E8H2dpC9luw3i9YRZf
 GoIloIiX
 32p9ZvwU8VE+dd6SOkS2lpHuurkNoHkaA3mMJj8n8/LSsUW/DkJlZ/z74PzbqjHPKrrybkyo23EJhoEWLdANNqI2HXze1EBBQX0TcSo42P7WkDcKKy7we7FmrBhOOKZcqsUsXwD7QS/v2jOmF4RpI4IS6XQcmWXey/+dNiyncALqNrrmVA7Nbt/UCKBVtMVnXMtWkYljGbknmElzRTuePSvMnx1n1Av1QLtPc1y6QZAE5PfJW0QTwzBdepWJ1Jhn0JVbX0anYNna0BCb/VK5W2iUy0OgIoWR2uWq53IU61LRMkEF822z+xQ7W+I8ZG7UwLd0U4ZajHVuWJu4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for physical CPU preservation subsystem, workload
attachment API, architecture backend hooks, and KHO serialization ABI.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/liveupdate/cpu_preservation.rst | 34 +++++++++++++++++++
 Documentation/liveupdate/index.rst            | 11 ++++++
 2 files changed, 45 insertions(+)
 create mode 100644 Documentation/liveupdate/cpu_preservation.rst
 create mode 100644 Documentation/liveupdate/index.rst

diff --git a/Documentation/liveupdate/cpu_preservation.rst b/Documentation/liveupdate/cpu_preservation.rst
new file mode 100644
index 000000000000..a7a534188685
--- /dev/null
+++ b/Documentation/liveupdate/cpu_preservation.rst
@@ -0,0 +1,34 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+=========================
+Physical CPU Preservation
+=========================
+
+.. kernel-doc:: kernel/liveupdate/cpu_preserve.c
+   :doc: Preserved CPU Subsystem
+
+CPU Preservation Workload API
+=============================
+
+.. kernel-doc:: kernel/liveupdate/cpu_preserve.c
+   :export:
+
+Architecture Backend Interface
+==============================
+
+.. kernel-doc:: include/linux/cpu_preserve.h
+
+CPU Preservation ABI
+====================
+
+.. kernel-doc:: include/linux/kho/abi/cpu.h
+   :doc: CPU Preservation Live Update ABI
+
+.. kernel-doc:: include/linux/kho/abi/cpu.h
+
+See Also
+========
+
+- :doc:`/core-api/liveupdate`
+- :doc:`/liveupdate/vmm`
+- :doc:`/mm/memfd_preservation`
diff --git a/Documentation/liveupdate/index.rst b/Documentation/liveupdate/index.rst
new file mode 100644
index 000000000000..415ac748c9f7
--- /dev/null
+++ b/Documentation/liveupdate/index.rst
@@ -0,0 +1,11 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========
+Live Update
+===========
+
+.. toctree::
+   :maxdepth: 1
+
+   vmm
+   cpu_preservation
-- 
2.55.0.1082.g2b9226bbc0-goog


