Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3455C87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C556B009E; Wed,  6 Aug 2025 21:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23D116B009F; Wed,  6 Aug 2025 21:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8AA6B00A0; Wed,  6 Aug 2025 21:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EB30A6B009E
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B55901DD392
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:01 +0000 (UTC)
X-FDA: 83748268002.27.8CF8086
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1E9A5140004
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ptdb2lCd;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7G+m/ldx5Lte6prj7fLyPcxxJI86crKx906ZhMWQQk=;
	b=55Is5RN8rC9lX1vLEG4lxaRXqGJJSFyInUk8enapL5Dhwr11VG7wcMjlnQ3yTigwKC99V3
	+HthmyfMPnc96lXq6Atq2i060szvQuF2YNhFnOiHcz86RJ9c1wY4JG8L2z4W6svg3wzQwU
	91QuihQyoSMoDoUio53FZDkeHRJRKCM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531100; a=rsa-sha256;
	cv=none;
	b=sZ2A238jvVBjINJAl5lCR3AvFqZjLuhXpBeaxSbkX7bqhgTR7VD+00uRxsM0ikKhinWVxv
	7ri+GsWCU8n15xHADi+/KCZ0Jody+XBRQfuP0YwnVT+7MCvQhXiVQkJQ9redVS/nUVekNa
	fO1JANB1Fu9/m4Y7w/re712WBeYaaaY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ptdb2lCd;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-7074bad053aso5410276d6.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531099; x=1755135899; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t7G+m/ldx5Lte6prj7fLyPcxxJI86crKx906ZhMWQQk=;
        b=Ptdb2lCdgXn30Z1DUEYwr0Mc1t5gjDrEywSd7J6nPb7270NRqlHYN2mfF2t7XgzaHB
         T/r8YiLy9M1AGDK+154ad0821aeqTjyoHgrhIFPechge6o/PPIRFJU17vySgCYDCD+Rz
         TNp/G9vz15ViTjgqBH4pFtjCAaggU3Zfranvt5Ou3AqyHymhxxy9riJN7WoWR3o6j/6l
         lX9vLUf0pfnC68/+SI+f6j+9rE1tupg7GGTmnfm6fqy4+gVJ6IQr3SgCrL2OXfjFvIVi
         Xk1ygJ3KkclbCrK+3lLSJ3KHz99MT7Prw20huyvSTRc7NdG2dBuCtSXQYjcwQ3H3mxjX
         fR5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531099; x=1755135899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t7G+m/ldx5Lte6prj7fLyPcxxJI86crKx906ZhMWQQk=;
        b=BdAKxSiYHrRrLxVPNQHCwQJ9bjf68itFwKbZAGpuKw04HX5HKSt+hzeBHKnHmc1fa+
         4FKR9+PwTAB89Hr/O2RHFQqGzwOg7fxPADZMXnJyGwtEqB0bNrIJO9rKBL9d+bYhHNyb
         ZOg2WEtUupAj36lwZYCbxaXHqqs5PtH7sgWuZZA3tXLUMTmy/TzVGEHSJMmbPXAPU4uk
         mhkWAqujRSWwieNSgaKBiiF8tgy1ZJ1yXw7aP7Q7irPF/OrnLXltaLCkY83pVTARn8cq
         XJDZArFF9m2JcxzMWd4LEXAC/65HbQ6R7gscOTXc2mOboOQb3CXhdDvjYIwceVfdEnc3
         48Jw==
X-Forwarded-Encrypted: i=1; AJvYcCU7HBN8FDS83MLV60CyROSTZ3Kf44AmTENZAsj/xUSsGpPpmIPc21Ip0JynI4dgw8bkDeHt+hVwNA==@kvack.org
X-Gm-Message-State: AOJu0YyGn0tH01WazM1AGZru0MzrqZsj+HEKJ8CAgEc/SKCAch8vUOv7
	Kr4X1eZ3OSGYsE5MorEdnHAkKCnv0ZEB4JUqG/0wevs9AnqoVe4VsiQ8rOrjJxQCExQ=
X-Gm-Gg: ASbGncuGUB6V/a+IIjS361m+VlHt/Uo+inBN4MQXRKQlG32nNGMTfveLeEv/DuVH+KJ
	ufy+JJXfV2MdNV1mlZb63w0FjoH4fSk5H/O+dvOC+UP3nyDMv7YqBvC8XJGBpElMtuezzyAnS6j
	vvDWx5JHTtbZEzNL0jhzYcumRz5hPo9ccvnDmShNgf2y/zQICdyYjjw/jDYeRa7i7Q9WdrXfsay
	E9fqx+SvNmjo2AzGjGRmYeonqCMlN6TILhkV/InlNxCLQ2aAUS45zkDLDFHCKGthkP+qPhJCnIX
	gtOCxerYTJHVCHhHs2lvA5vi+rUvvGx84GqTM4kgNNOgGV0VLRdrACZbrSlaI3pyHFCzWFHT3OU
	YgYaDJyekSh+StxmFGSVwkkzQT0EZUeosgsjdoKxpiSbfyzLmqfgvWFF0rZWvkUKPsyBknhtkSI
	T3W2BRwiDGGRaW
X-Google-Smtp-Source: AGHT+IFrm+HnX+DKqjrzyDEzZevUOzkckUB98RzWsO6EpAjPOvGPrTYO1ThdZbbOoF0JmkLR1SS4uA==
X-Received: by 2002:a05:6214:c62:b0:707:43a1:5b0d with SMTP id 6a1803df08f44-7097964cf4cmr68796306d6.41.1754531099046;
        Wed, 06 Aug 2025 18:44:59 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:44:58 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com
Subject: [PATCH v3 08/30] kho: don't unpreserve memory during abort
Date: Thu,  7 Aug 2025 01:44:14 +0000
Message-ID: <20250807014442.3829950-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1E9A5140004
X-Stat-Signature: piq58g1wgag38zmami7w348gz9gc7rqf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754531099-80861
X-HE-Meta: U2FsdGVkX1/TH8Yb/KSxJoYX1FSutekmpZLyvOt3ps8mwNvGcvW58Y3lvzrsqfU+KcNZ8BmWCgS6Q3W6T4h/Yon1VKza2B3VqwLBi0BY1Rrw0BgHiZIyTJGiufOjbdgAEhYGkrL8IVuGnsuIVpG/QM3dRyjlPooMJgLetQo9cbbVfz0Y++Lic4mQtMFCPSZ3yd9gYqZBTWgk22z10me7FYIY+FTu0voLOTkgf+yZ54zqQfpoA0EbylZI5bgDAtTh7SRzDHIGNs4zMWA+ybMtvr+j+DKbCL29DK9miB52qqvxnJixwWG2D4GUNkIdclyxFDoAPVHQ9xSZ5lWkPc59x3G6/tXuBBmkjy7PuucpzwsuTeIdc7E0phHw3MGTDHL2vDk7VtC+oKsPv7LZ6A9TAPScVzm3amkXzoWb3mkuiJDXqjh4xlHzAOOk3sXgKZrZJz9Ebofz7qCIRrcdqHKrH/fo2DliQQeEnBt/rh+3kmj+wmGE6C8vp+tUf49a0tV+nZYkIhI/DcUfspWJtrN8T1e2I9ERJ15rI7iG6VBsJ3KDL8LeFbLtU2qBFyv4fqTVq5kXfbWKIx7JVi+lt02sVHXQ8+TRiQwU5vDBDf3GiZIkLCPSOiAlpveCxD/puu4BS4hDfLCepzX8eJdse5ioTLIqkZmPzMDl8YLg/MLY6MaqooJMwvLNJwh4ZNTdGQbEs6so0svDVp4186j1CRmllqN2LFYUgm1TL5Sl6KjnQYkX98Jil0bBBuekPhCitdIM2v0YUE4tJTtGPzxnqdq/kFdwewxN8aMV1YqE8zcxiXfMeZJpCQQ0Rstzyu58X0DutbnAOYEBVICS9yzRGW8uqsZVRKGWHBF73GdmX16B/SObmXm4dvIdq3ehIqWC8mz1UzVzvVFXj3CAJZNLI26tPcex4TtJoAKtCvOKQsXWCXXXlRNURa7s08AA8LcNpkf1ClGfeyO/X4pkQzs80Q2
 IGkkIprO
 vFRh0O6H+W2revpuArJVg506taNLzho3iMXD7oEajDNL8/Za7JF8uba+4IQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KHO allows clients to preserve memory regions at any point before the
KHO state is finalized. The finalization process itself involves KHO
performing its own actions, such as serializing the overall
preserved memory map.

If this finalization process is aborted, the current implementation
destroys KHO's internal memory tracking structures
(`kho_out.ser.track.orders`). This behavior effectively unpreserves
all memory from KHO's perspective, regardless of whether those
preservations were made by clients before the finalization attempt
or by KHO itself during finalization.

This premature unpreservation is incorrect. An abort of the
finalization process should only undo actions taken by KHO as part of
that specific finalization attempt. Individual memory regions
preserved by clients prior to finalization should remain preserved,
as their lifecycle is managed by the clients themselves. These
clients might still need to call kho_unpreserve_folio() or
kho_unpreserve_phys() based on their own logic, even after a KHO
finalization attempt is aborted.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/kexec_handover.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index b2e99aefbb32..07755184f44b 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -778,31 +778,12 @@ EXPORT_SYMBOL_GPL(kho_unpreserve_phys);
 
 static int __kho_abort(void)
 {
-	int err = 0;
-	unsigned long order;
-	struct kho_mem_phys *physxa;
-
-	xa_for_each(&kho_out.track.orders, order, physxa) {
-		struct kho_mem_phys_bits *bits;
-		unsigned long phys;
-
-		xa_for_each(&physxa->phys_bits, phys, bits)
-			kfree(bits);
-
-		xa_destroy(&physxa->phys_bits);
-		kfree(physxa);
-	}
-	xa_destroy(&kho_out.track.orders);
-
 	if (kho_out.preserved_mem_map) {
 		kho_mem_ser_free(kho_out.preserved_mem_map);
 		kho_out.preserved_mem_map = NULL;
 	}
 
-	if (err)
-		pr_err("Failed to abort KHO finalization: %d\n", err);
-
-	return err;
+	return 0;
 }
 
 int kho_abort(void)
-- 
2.50.1.565.gc32cd1483b-goog


