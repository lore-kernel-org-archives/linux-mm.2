Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD8A606B1C8
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fjmpaVes
Received: by kanga.kvack.org (Postfix)
	id 3F81B6B0653; Mon,  2 Nov 2026 10:37:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380CF6B0654; Mon,  2 Nov 2026 10:37:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249286B0655; Mon,  2 Nov 2026 10:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDB286B0653
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:23 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E57780156
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:23 +0000 (UTC)
X-FDA: 85390583166.22.F59DBCA
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf03.hostedemail.com (Postfix) with ESMTP id BF5D62000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fjmpaVes;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3MK7oagcKCI0Cz6z49yx55x2v.t532z4BE-331Crt1.58x@flex--vipinsh.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3MK7oagcKCI0Cz6z49yx55x2v.t532z4BE-331Crt1.58x@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tylWbFCUgeCOXBn9trkYSMBYVlhA9mV6Qs1lbXsCOco=;
	b=0uOhL0T0Ve8eeV3tTANEJ12LilXF4C7qTEycB6wCUzBxun8xxl9TFVFedL4ki8qiJkiNYc
	OHoCFjEa3miVGAeNfUsz7fJcZVDeE8YS/ab1lrtMzxRkV2lL6qQeVVI76ZEnpZkxs8BK7V
	s9G53xRFAVju9jAizzC3aos4h0xtJks=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fjmpaVes;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3MK7oagcKCI0Cz6z49yx55x2v.t532z4BE-331Crt1.58x@flex--vipinsh.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3MK7oagcKCI0Cz6z49yx55x2v.t532z4BE-331Crt1.58x@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633841;
	b=o+KOzqcOAdvwRiGKSR31iSkJV25hq17HNK06N4XwBfM450SppZPmWIAz4kQxJRq/O1oA9w
	lxoH9BBCOchfQopgnArk+GbaQ3YzTN4JNG+TANNyQFNutsoqLgVMOI4snufATyOCr9+g5z
	XjlZteSEIBydcf0rWH5IHxIWf9Fx9D0=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e93e2f72bfso53693765ad.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633840; x=1794238640; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tylWbFCUgeCOXBn9trkYSMBYVlhA9mV6Qs1lbXsCOco=;
        b=fjmpaVes2lBfQkIvHpl3uuWb+EhqFiKSU+w81nZlEZqM/tK1jTOTsgzzQMt66YU4aI
         mh8LwAGz2gRIsYF7QNqvCWjYYKcpW534T/J7sAEa+2i7amUTR8n25mrbo8PIxl3qQuDD
         LE4S7Pf3xwiL3o2O8Zto/e4bMTKm2xNSvbC14++asUQ5I1E7OrJ7EG7w3bX31yia3UHM
         HQe6eKPa8tYwavlBPlhpMfeBD/ZeLqKOo4nnfnFVh0wfnX1fdMFeh96Zin66go3e3mpt
         AUK0Czikt4J36gcXZ00jIRgbgwhC7C0JGD2daL2kDx8nurYlNr2Buosv1XwZYIe1ZDCT
         12Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633840; x=1794238640;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tylWbFCUgeCOXBn9trkYSMBYVlhA9mV6Qs1lbXsCOco=;
        b=CjaFbMqrV4jhdn6Pbw0knysMCHDtiu7LGdtH3AHDJA8jjJHTcveQLwyx5m0o7c2Bhl
         EEHvgp9MQ/USCYtVF3pJ3WyjWBXPca5KhePJ5wgso6OerJdmN3vD3bvGtumcBm1U2epz
         YBH3FC5/Vr0M4Lsl7YOVN+uv6PRJAlrJafwGpMWB6oTcCLkqz2Nzm37pfiy7q4RvYZj7
         9m4NycrtdBlffgn7Nhqb2e6IkZ0vl5x1qzgnRfYE6Ta1pxoTeof4vOKR6FfRdYy5saOv
         wnSXrhUUZ8Kn+nrGwb+/zwp+9OK0irKTiad2yKdAuqk2GvBvQQJayu+Awq0anpqVi3Ew
         B4ww==
X-Forwarded-Encrypted: i=1; AKwUvBwrTn1YTlRVZLx6RB2T76mWc16xq8SbC8akGnMOj3lUEWX73qMTRe8XThMAFgGxdtnB5P8Rzgp0fw==@kvack.org
X-Gm-Message-State: APuU4Z8ilOietng+fzcebbIXkZOEJWaJePiO7lIXWpR7Ew/3JFSLL38x
	mAJwcgnv223L+JPrnS8ouqqRfk0uucros4ieslKV0gvyxorbVZTlACqDW8n1p7ofNmocUto5wiz
	8ES+RG0pOUg==
X-Received: from plbix15.prod.google.com ([2002:a17:902:f80f:b0:2ea:a5c1:240f])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:37c7:b0:2e8:b5b2:a9f9
 with SMTP id d9443c01a7336-2eb364e9f75mr92959155ad.37.1793633840266; Mon, 02
 Nov 2026 07:37:20 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:48 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-20-vipinsh@google.com>
Subject: [PATCH v6 19/27] vfio: selftests: Add Makefile support for TEST_GEN_PROGS_EXTENDED
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: BF5D62000C
X-Stat-Signature: 9cwe4c4ss3wizjhhijyhndaz3ejbnsyg
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633841-358809
X-HE-Meta: U2FsdGVkX18b7Ce8vZVFOUAMZo3QoX5uV2ye9Gkqv3eKLaKM/YmkG52Ol5WgDYyUJ8/DL+v9Qa5sUTda9rZpXUca9laXMQmXX4KqcCKS5qW6rAQYLvES4WhgJcrU7ubtWwQbpi7VMsowINeYc+nseuoF9g/XXemfODT20HZUFzPL2VWUKFuE8vE0i5uzZsBJqaDwz74eLO/nSO80XYg5E2hgfg6FkuR2BdZcTJ0J5cuClJA2X+KdIRkC+Y4m+G+q92HC4orVUm0aUV5PrB2eQuCZfeYm2DI9J17PtQRJXZaJ+0NjyVvwXwPEjSeB+4vG4iBkFOWfJXsNX1wAqS1FiXZf0FXwSIsjl6QwFJSU2NzBK4T5tUdiixUBjaq42/Cxlu553SB9KOTBnMvw7ZOoFZ1nBSmzamsNRxrqfsnmBkTNL5GxTAVKN61Xq+lSgqbIVTuwEZfZ8RZZJkPspB8aazQ6K2j99RMcWKXkdDKNumCjqTAug4lns9DzSB92+UlztG91yZOhsYDL9RU9uwKZQQxhjXh75pZtkPjvgVxOoAMNs5A6kFET8XKfT/93op9JSXJsJR81UK+kBvJokTe6kART8HVJDQIBWnwMZfkrVOolydGnRa3lJB409xJr88u7yPsJzAWm+rSWxjXRl61Eg1FNcIfAvjk/FnjFSjjMYvclzk+Xh6q2sXP++4Gy3/EDi0Pktpg4iMl5ZNd/iSbDl10qpH/1V8LhMCR71HfrQpdYFBkGi9uE+EHujP/9nnOsHN4JhBktZd10HBvySD5EViLCVUjNNUH98AN1+79x7f0cYfFtZnF+/ztb+HWs6MCZNtOkwzY8Vln297/mzpVdNJj5teec4dgRcDjwLl96s3cjUyevZX9EgAUo+qo0Sdsx5sRyHJEqNxopDfAorxceuivYUEeh6izqvkTkfXrYoe3SG6lJq8dNHCqk6o2oet1MTQ4PlqEsZZopU4EMNTj
 Komqnryz
 xE0kxSDdZZqyk1+ykbcZ1NpJtdoFC6Qr9qpfoYI9n0qaj1DHVfcfE9WKdCWxFHTDZNksJ5sq8GKNIKSNeSqw+i3vf87+k1HnTWim+1H/ItBNu3QClpkwmrDcf7n4AUFQuzWYohEwcYlB1dgLAkkaLEedygFv7saK1CXJsAuD7PNqNaaFujRHeDVxz0SDzB9CjXUIk/ptbvw9P7mDzRNc2GJcyVf7odvoljHtQQs2zq2ax+rW65jxtfHeIGr257dcJoBR/qoG+Glwnq+4p/iqsRGLAElZAzRcETU10thGQbPmjdywN7fFwXcxX/9+qgKD51/CeqCDZI/FVZL9tE1hILto/aXDm8Aey7vd4fZ2Hn03Vl0GTXbreqrRTmHYjVKfSn81N7Q7UqDV0mLpw930y8R7Rqbgb/C/ok+a4DVcQdIkarBkfMFMzO5dRtv22zTXBvb3kOLos9cYdHECpUmBc27gT8zZM71ntq/OV7SQxtJXEee8MLzhTg83qNbRrnvAKbbMokEQu20k+yPUo6fLHC0cXOJ4vypuVuNMkVW6M+FUnVZxfQXPiGJu5xCeOHwEIaHQ7QJfh4kHp2LFoHj1BYwaz4FirQ+Fikn3GPjuAaR3yaNQuquSEd1Gvfy5vxXtYTU8i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: David Matlack <dmatlack@google.com>

Add Makefile support for TEST_GEN_PROGS_EXTENDED targets. These tests
are not run by default.

TEST_GEN_PROGS_EXTENDED will be used for Live Update selftests in
subsequent commits. These selftests must be run manually because they
require the user/runner to perform additional actions, such as kexec,
during the test.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/vfio/Makefile | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index c2764fcef31d..ece2a3618f2b 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -34,16 +34,18 @@ LDFLAGS += -pthread
 LIBS_O := $(LIBVFIO_O)
 LIBS_O += $(LIBLIVEUPDATE_O)
 
-$(TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(LIBS_O)
+$(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/%: $(OUTPUT)/%.o $(LIBS_O)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBS_O) $(LDLIBS) -o $@
 
-TEST_GEN_PROGS_O = $(patsubst %, %.o, $(TEST_GEN_PROGS))
-$(TEST_GEN_PROGS_O): $(OUTPUT)/%.o: %.c
+TESTS_O := $(patsubst %, %.o, $(TEST_GEN_PROGS))
+TESTS_O += $(patsubst %, %.o, $(TEST_GEN_PROGS_EXTENDED))
+
+$(TESTS_O): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBS_O))
+TEST_DEP_FILES = $(patsubst %.o, %.d, $(TESTS_O) $(LIBS_O))
 -include $(TEST_DEP_FILES)
 
-EXTRA_CLEAN += $(TEST_GEN_PROGS_O) $(TEST_DEP_FILES)
+EXTRA_CLEAN += $(TESTS_O) $(TEST_DEP_FILES)
 
 endif
-- 
2.56.0.317.g454f8302e1-goog


