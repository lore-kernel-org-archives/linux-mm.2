Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 601E9606A9E1
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=HKmRg+mG
Received: by kanga.kvack.org (Postfix)
	id 707BF6B06CD; Tue, 27 Oct 2026 07:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DEEA6B06CF; Tue, 27 Oct 2026 07:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4696B06D0; Tue, 27 Oct 2026 07:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A93C6B06CD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:43:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8CE3BA09A8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:43:32 +0000 (UTC)
X-FDA: 85368221064.02.12A028F
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id AE00C20006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:43:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=HKmRg+mG;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf13.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.169 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793101410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qRj5nmSVr8oaHYTfwp3nV+7muLaSPF1hwSVuKOsZ4eM=;
	b=rIPuEdfoyrhYa8jjXoR3FBTrA6LPSOtDus8y73iKM42ZsHaWVVrI+IzhLSxOSGbSmg6/Dh
	T361Vy3ql/OVKj/W/v7suC8bwqPl/nZ50nkuOVvQsaD5U1Qjq7GGqj4aHnab6jy9+u33We
	iPdnFv4UJotFVkKrxai+4PYKqPXm/+s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=HKmRg+mG;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf13.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.169 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793101410;
	b=yQGeSLAQeH5jYmOyGNTYbusiAbExnvJ8oa1GaOas05Zwt49izWPoPuzJBfRo3+mZ1qUsTr
	+uaJlfa/Q9rX462QxrMiJqahuLPuCB09fXOJdWLOPfzlm+SyzOurO1IqYmAhXesvn7z8J4
	v6EvxbZZoneSmRoCMAjXBLRyOG8QP7w=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cd61cef87f1so1361864a12.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793101409; x=1793706209; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=qRj5nmSVr8oaHYTfwp3nV+7muLaSPF1hwSVuKOsZ4eM=;
        b=HKmRg+mGrQin0TTtZolVU7Wn9zA8tbK1F+DYJaxeqiyHZMrqtxfURuAoTGq4pM4mlf
         fqI2qCQaTaKLzQLSfakfrzc1vFoyRMF8BXoKEn8rs4EkO31vc1qkYKW03t4Vh2cEs2s3
         oEBgIk1ta6kvIj+CWHXhbQPEokAj6uWzjjIDM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793101409; x=1793706209;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qRj5nmSVr8oaHYTfwp3nV+7muLaSPF1hwSVuKOsZ4eM=;
        b=S5UsH7iUo61xRpvvyjfIDQGq9mmxrXLt83FQksQ5jXZKm6oo4Ofv2T/zQUeQFv8nfp
         vtapHEfmMK/fzzPqgYtWca0zSH0RTX1i76L+5KtQAdRQfX0zixIQRtu/Kj6Fn9nJKJJp
         bTy3+ohFntdIS544mVRwcCoqrkifN14gmeidfREU6tNld8tOQXCTh+Y1OwuR2TqqsYZ4
         pLcG0OpOyZlI6owJH2qbnVc5rHZ+nVqkRE32ibBzXq9/tzayf1Tn+tjgGBj3tJN2j7RB
         tghzmx8NIT4LbtdK/u8Pv0CKtxCa9eNmenO+hBjut3grAtpMBPvnEeT19KBf7VsulP+q
         BMbw==
X-Forwarded-Encrypted: i=1; AKwUvBw9quPVrg/++tIdzdRgdB9zenj91V3p4plcsMNK5P7H/xPypiU6Yc3/dEMOY/5ByUjHQFN1Ej+lcQ==@kvack.org
X-Gm-Message-State: AFq9FYJSZI32SzRsX7DjB1gjnYKU3zqn8V/VkRzZr7OTjmXpv1QbGA9N
	hlNj+CTjtKlYYypkPdXjEDFXnP2w7kpQPMO1Wf5wmilUY6cREZlXkFOPQx7i6JCA4tA=
X-Gm-Gg: AYBFou12/EqVSbifurEpimXnRMYnjM5fv7dGgddyGBQtCUIOLmRiriH1s7jFZZfdFcG
	UFpA2wUfUULH52v/U7FRKdr+mryVPLymM2NRrWkJOMp+XI5/Tl2/X/75vu+Poo2FE5dbd7IvsTv
	fdUg3XtyjXChffC7rUJ5EgM5ru+/t36DKSuxMxjg/C0SGeoYLdL74X0FqvcXNhRk7FizEdZq9Op
	SrI9N+SetIkQM/AOecZRjXY8G14HvDRsyspceN6dL1QAsQRXoq+RJjnKO0M7h37fMABqwJ8aZPI
	5u3xjABzTJOfA1LU3YqxHX+B1B/jsYtbQ70nLHFiMdfgKi62bs8onHrQBdxp5/syp4TpIEY+hFZ
	+7muDestI9TU370PmkH/2bIpazmFfUeGkAfdD3w9hsq4t6fwT6QYQTQDC1Y0H0QqRsfGlK4zWMv
	zQDsROPtkU6uljAOMdGtYgVIz9a4Ul19TQpnogV8nykV6RVLAyo4FDF4w+DCvRXxno3enhAlm1b
	MpyBpf5Iso6ihFK/1rdggmJOkuAQKe19uWgLSxVucNxSW6hWDUSAVuL5ubY65A2sg5VPIqmqNiG
	L0Rmwe7eLu9lE9dhThrOrAJurBVXoww38aCSNf9G7OiV8ozzf5lkNFlS8WEa27PEEyJMr9IF+zd
	74rT2rgrO9Xlpxz7SU+huSVY=
X-Received: by 2002:a17:90b:35c5:b0:3ac:9599:a689 with SMTP id 98e67ed59e1d1-3adeafb079amr6566975a91.34.1793101409391;
        Tue, 27 Oct 2026 04:43:29 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adf8f3f22csm7120822a91.3.2026.10.27.04.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 04:43:28 -0700 (PDT)
Date: Tue, 27 Oct 2026 19:43:25 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>, Andrey Vagin <avagin@gmail.com>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH 3/3] selftests/mseal_system_mappings: Test vdso unmap and
 remap
Message-ID: <621847973ba2ec49d0a58e0261da35a9f3a97eda.1793094611.git.chris@chrisdown.name>
References: <cover.1793094611.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793094611.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Queue-Id: AE00C20006
X-Stat-Signature: q39ixjcy4gcezbdnnodhkukkjtex3e6y
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793101410-818146
X-HE-Meta: U2FsdGVkX1+QiFF0SxOptxt3RCxjstLCjer2QNgNwZ/vL8lQdraroeuHqfq2kdJyRFLEavuPtHHVBLyH/9+iVI1LI79hmaHp12dqKhUwy/DYhtXei67kIzVZ46IZvazy7XgbA7LxY7wMzgRW6v+h0PzILPwEHwujHQZ3bkDi9E2RePhHIAdRqm0EJwG7hLsgFFEW78v+6TvXKVwEFUZ3+24PbYdg1n8SaE1Zoa9x7bLA/op6P5FN8rC+AOHalfFGRPspI7fQyaaZpXXtLQLISaSRzFGQY48MMrR+L4lf9BDEp1PA78pq4cYcBSclX8KCT6mL7WXFX6HQDKYxnQRZ7fyGuFmbxBsOmrkW1w1KnjY4fuPT1BGVew52b+O2WLi0O0pu+kTpgsIwBC3b4klvgH1mid7VQZlA5e5fbXNbJcjc9FMDa7wcW4sUsE4LcNzMiUAYk1fhgPy6dIL9FeV/ZZmCPTfUP/RLYVu5+xQ0PFkA8qNXrMt+PT+N0niy/MBNYBdA8FPmUpsEXuIURI76+ADCz1SSS89ZvQh3Sbvw2iAsSYdadHH4YCDqXWcZpwkFOCya+y0bVnIMa4gwF2/RYg/Lwm2g7fxyMB1xORmHaCMLmV4PPq486y1o+vqICGr4VrBIu18sIRoOHSYbNAOfnmBRzsjuwFnahA/Gs4+pLICZvtOygMxN/CXmZs5M9sg1zln8WZGhxg5yCjUTr24gma/GMenTMhwkTXuoz/azenLT27aOdW16qq34/HDUIN/1+ifqEpl186gIG8YoAOeZRLKbodh8DN/kzP2TmSrpekBhlOM8EmKwfIQr0RfPWIMdfbHNCgpi6k2Tm+2gDuh7XH31hee1N/L8cLzPfDOreGkXOdhMI7DGh07yT3q2ulDt/i/exjGhwdZ0rxQ5gcAKIftZsA8ztLItgoCV5VTNbAelgYCpkpi92l8gAYLVcWlpcuaDjzWZtN0M/doyhw8
 0EWUQ2Dr
 CxCkJznU/sdFhCIrYjzyJrsWXuRfAuu1p01jRgmwXQyJmMgLKpxmlS61+GGgvetz4q7HvwK8/CE2KV/9QoCyTxoPy1HT3YJ7HlDHPf+Nlud5nRDrQ63LUn0gcOb8ZMWRyXGgvpaSIsqTMN5eRccbEEnxP2zCV2yydqrdbHpMulSGK1ObksewhfDnRn/DZR0sCPAPSAIJ+qHdCxT7Q0b6PvRv66fMErmhllt5c7/t1cegjw/ZNPRSNr+0Yc1zR2W/SVD7InwtmZ1mS5gM0Gvg+uOL3O2X+V3hC4uXgDngdP3Wa7EZHgLgP1sk850P6D8n6p+JMrBCbKnUNL0jEvrPNYr5I7zVAgLP9C76e5mZnjY9HBFg14+UUNl05IBd10o0rBJoDfMvKprP1AT6x0Nd74pngQc8WH0nh/4ZWmCORhvgr3trJSkxHhsatv2BGMVKIgjRxZEL2r4ELcWr8STvKa36WzmbpgEOBxsycBc9TXestpzWaonp5vvNET1yWcin4mm7BkDMYEDs4W/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 .../mseal_system_mappings/sysmap_is_sealed.c  | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c b/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
index ea75ad537620..83b4fadfbfe7 100644
--- a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
+++ b/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
@@ -10,6 +10,7 @@
 #include <unistd.h>
 #include <string.h>
 #include <stdbool.h>
+#include <sys/mman.h>
 #include <sys/utsname.h>
 #include <zlib.h>
 
@@ -232,4 +233,95 @@ TEST_F(basic, check_sealed)
 	EXPECT_EQ(expected, sealed);
 };
 
+static bool find_vdso(unsigned long *start, unsigned long *end)
+{
+	char line[MAX_LINE_LEN];
+	bool found = false;
+	FILE *maps;
+
+	maps = fopen("/proc/self/maps", "r");
+	if (!maps)
+		return false;
+
+	while (fgets(line, sizeof(line), maps)) {
+		if (strstr(line, "[vdso]") &&
+		    sscanf(line, "%lx-%lx", start, end) == 2) {
+			found = true;
+			break;
+		}
+	}
+
+	fclose(maps);
+	return found;
+}
+
+static int vdso_is_sealed(void)
+{
+	int sealed = -1;
+	FILE *maps;
+
+	maps = fopen("/proc/self/smaps", "r");
+	if (!maps)
+		return -1;
+	if (has_mapping("[vdso]", maps))
+		sealed = mapping_is_sealed(maps);
+	fclose(maps);
+	return sealed;
+}
+
+/*
+ * Unmapping or moving [vdso] must fail with EPERM when it is sealed. When it
+ * is not sealed, it succeeds and leaves glibc with a stale vdso pointer, which
+ * is fine because each test runs in its own forked child.
+ */
+TEST(vdso_munmap)
+{
+	int sealed;
+	unsigned long start, end;
+	int ret;
+
+	if (!find_vdso(&start, &end))
+		SKIP(return, "could not find the mapping, [vdso]");
+	sealed = vdso_is_sealed();
+	if (sealed < 0)
+		SKIP(return, "could not read the [vdso] sealing state");
+
+	ret = munmap((void *)start, end - start);
+	if (sealed) {
+		EXPECT_EQ(-1, ret);
+		EXPECT_EQ(EPERM, errno);
+	} else {
+		EXPECT_EQ(0, ret);
+	}
+	EXPECT_EQ(sealed, find_vdso(&start, &end));
+}
+
+TEST(vdso_mremap)
+{
+	int sealed;
+	unsigned long start, end, size, new_start;
+	void *dst, *ret;
+
+	if (!find_vdso(&start, &end))
+		SKIP(return, "could not find the mapping, [vdso]");
+	sealed = vdso_is_sealed();
+	if (sealed < 0)
+		SKIP(return, "could not read the [vdso] sealing state");
+	size = end - start;
+
+	dst = mmap(NULL, size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(MAP_FAILED, dst);
+
+	ret = mremap((void *)start, size, size, MREMAP_MAYMOVE | MREMAP_FIXED,
+		     dst);
+	if (sealed) {
+		EXPECT_EQ(MAP_FAILED, ret);
+		EXPECT_EQ(EPERM, errno);
+	} else {
+		EXPECT_EQ(dst, ret);
+	}
+	ASSERT_TRUE(find_vdso(&new_start, &end));
+	EXPECT_EQ(sealed ? start : (unsigned long)dst, new_start);
+}
+
 TEST_HARNESS_MAIN
-- 
2.54.0


