Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CE07CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 17:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98BB26B0093; Fri,  1 May 2026 13:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962486B0095; Fri,  1 May 2026 13:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 878166B0096; Fri,  1 May 2026 13:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7787A6B0093
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:31:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22E551201E3
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:31:38 +0000 (UTC)
X-FDA: 84719543076.08.31E8D30
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 396EC20003
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:31:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k4QaAtT2;
	spf=pass (imf13.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777656696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CXENGFI680//+XMLD9o6Yj9f9pS4CJGNcNi4QeEBC0=;
	b=MMVm4viuefzpq6X76dI2ITd8QR5wLBSL+0kS0nP+O/0WSRynkqX3yx3EiLs2O9aG0ey1kj
	wPwk+wet3+NkDSgLHsiJpsEcdK7h6N9GlL3+dr5wlNn4PNprAKoXXTamXZl/ta+mzTGop+
	NOYJqmyQAZ35urCh1ZmNdLasJmmnJlw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k4QaAtT2;
	spf=pass (imf13.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777656696; a=rsa-sha256;
	cv=none;
	b=L8e6Qnc8wX2WSxJ5r2N6h7hyTYjqBLVILuIBtOXY1vklklLauVFhuYpjZzFJSBHMTbaXRh
	UVAjh+srqEL+62cjuZIW90T/NU5rv/p1Xg/koI83U4xNSALewG6rr8nZmGUFzQA2nbPCLj
	ahsT5gastr2tYm5bl5mE7N7GYZtc9b8=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ad9516a653so10761355ad.0
        for <linux-mm@kvack.org>; Fri, 01 May 2026 10:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777656695; x=1778261495; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8CXENGFI680//+XMLD9o6Yj9f9pS4CJGNcNi4QeEBC0=;
        b=k4QaAtT24y3PJ9FdIAxsZXWXdJnO6Q1otkiURBCKzu9R7lC3sjf/SuzUj9uyK7p/JO
         kjmRUL6GN9IEf7AKuX5/KQRSmykwjM1SgnSKuAl3I6dPHOKHVBu+HP9Qki2t9r5SRMqX
         iC/p95Y8rNKhGkH5o3vI2LR4dSy5ccIVg3J20kwCj3AcQmZtxpiO2W6XfCYJjZH23CPu
         bzVC1xud8M6AEg4WitHKmAwTxIu36Q2DAXK79Gtbirt3joZ1zxWre55iFTfGUJFoLxW4
         Y9gid3gha/VBBV/UEwuXlhmLB8Ysp7448PoZ0YkK0JbXGcComhNNp/vF+Ctudw1lIPQ6
         y7Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777656695; x=1778261495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8CXENGFI680//+XMLD9o6Yj9f9pS4CJGNcNi4QeEBC0=;
        b=adBYRmT79M5Fyz6wIrF6JaLOLBQCYLNkHLadvQ11twGycEPAEjXE5HDTbkoOxQoFAN
         oMzeidbwfwDHLtpuGcEkrLHn5G8DtRk3htUs99A4SdAc467cKgzqylyiFPtrcYgxFqEn
         vzb4blqX5iEmhJEvWzdCCmDTwnW5SGPJ3jgU1fV5EB2rGVKcnF1HOBawVDNT87yB4LhE
         q6BJw98r2n1v9Oo6UVyXxylSJE+ihpsbOAfkwQW87DC7dn/+0G7HJKTWN7SraAbUE4fz
         F29mddmJsNeqALmgxo7nkfs5E8wR0MN3ATXF8gy+bD+r0HrwkixcH+h8sJRVDT6+6Wx9
         /4WQ==
X-Forwarded-Encrypted: i=1; AFNElJ9qnlxUSTl7G8ajwbPwYiwwlh08TM/06fSWiGINwu0uiX+ZTI9iaMKRouECI4EoE/bVZgRisgFweA==@kvack.org
X-Gm-Message-State: AOJu0YwUOwKVQ7QjeMNT4MIjzmN797uOpZ8/L9nIvhFqRY5kry0kUcXt
	of5Zz1xNi0d5ZgUeKhGdNpxPafLDog9kFNrZ21SPQpSlf2a65pWsD2IS
X-Gm-Gg: AeBDievYLuYUeD1PJnT9ThcEnuml6HatFYvnSAX1+y+DPLQBFG33VHbDA506Bq4oWmd
	1otxCzTOYE8FvWNADb68vjFGfV403M1Oh8iLu0KlMj/Uf4QcPZ2A4062EXqsHgNy0g9uLiM7y1c
	+kbAjntvM6l2238VN1sKulzEstxNYW271ATWRCM+UCvLNLtkN5LRaF0t/ld0wVqgbGJ7xjurVL0
	susTnEJ+fC+ngnF+DewANssSB0/wh1eFDAlqMiP98XYKUDBn28R7egFcArJOd/b/nCFjVcdn08m
	T7mEMQYcwf6sJ+TgjqNSj1qc+VFHjcdHsOG5ozoQ99wxAK+vAHiiNieMhf5HI2TA+IF0gQhHDne
	E1PfBnmh+1VXKBecWPRqYx0NCB7Abdefzx0Y0MSX0DpJ3UGpncQ6yhv3UB1F5MhYSLGrSJAm9k2
	N/C2bNV/k2WYiPh3ZPd3tBVms36b1Mbe8LKR4EzQ==
X-Received: by 2002:a17:903:380f:b0:2b2:9f9f:fe6b with SMTP id d9443c01a7336-2b9f2821038mr1393735ad.40.1777656695011;
        Fri, 01 May 2026 10:31:35 -0700 (PDT)
Received: from laptop ([2001:4455:8025:be00:15cc:43cd:8af9:5a8e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caad2459sm27094895ad.33.2026.05.01.10.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 10:31:34 -0700 (PDT)
From: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] liveupdate: validate restored LUO session metadata
Date: Sat,  2 May 2026 01:30:51 +0800
Message-ID: <20260501173053.73116-4-crisjacobmaamor@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501173053.73116-1-crisjacobmaamor@gmail.com>
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
 <20260501173053.73116-1-crisjacobmaamor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3wb36acr6h8tq39j6nn8ax3sn461r3c1
X-Rspamd-Queue-Id: 396EC20003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777656696-175110
X-HE-Meta: U2FsdGVkX19qM2PFzi7K3Sk2Zxl1fg6WcT0vt8MpIE/8OA1p2nAcxoDaT/nH4J5jZeu5npr6pXPpGcGV82TXw+ss3ZuIN9NO4OWQ8AKpmc1by1TdhMSA5CJ9Dal89cRSGtE4bcBXlIECxfeSDv0TBXhCO7Ila2mkVEgDahDz/NeKWZLOWyMYyf/mxE4if/q4CM9n8yp9NHYk//l/tE7B3lcFyA3pXVT3Rm1MfuZBllg4OAVvpoKV2eO32ARrrgldXribGjshIrg83aV8Hr4D3ApDR1Ja84xgU5ED7RHeVIKIKuG4QlmeQSbiOWvdPB6OO6dFVky5EHfr6/DfNuCNu1mxqXruXX6J01CFU3K8S/z30xgOQ/+8fEg0bof3CSwXd0jdqrKlwAq1vfb2uFQbSWn3LdYDS3SJHnkEFGS3Jw18LbQIm5G+JWPCaHNc27WPZwDLrvp8xBoTx0/DrDqAjWvhQr2BQJGJp9aUCntlno730WiXVQIiTiQWQr8xlHXs8qD51JcCKaSQyjOxKsNFnc0x/bRNZ8C0Niy97WgVZ9ZaRsjUlbgh9bes65+TEA3VevZKS7f1LYqdC0RAZlMDFU084oLLCajtvIL92KeXfl9wlYNdnYYpST+bX0bn7ND3WisKAo3/kLjSApg2z34eg/6Hkl4Pkhc9usayMmk2Sib51LpDdxU7i1HhP7o6ipVcstAp9GBWqSwKQPdXcYL1Cf4hFJWTN9zdM0lO8pXmoyrYyopTnlMzMahD0PfOXBJbtTwV8XH8/i0nX5pMCLG+DDYPASzy+Qf2O3EJHNCoi0ugP0l2ZYqivQ0ZhsyZ8k9cFz+IBnh+Zt8adCXnOaPN5UpMcAtkP49kRgnacA/uAgxEWRffLy7SAhwb3S4uT4wHZjg8Z1cEJNdr+PowTZaQaE9SVoZRq52peueYK0seF1zNBVyYwqOTctFjJ9HBBZIC8amwo6+G+JeLuUZlCHj
 EwCwHx5c
 RmTMqEULg2m0zie1Up66Sc3Uf49sNrTULRWohjCd+nmsX1VTteq5b3zXiwZervlNohHag4jvxsb4VPwq6QWUvlmG9w5jSGqbh0tm/ohaBZWf979GVUIvf2Nvxulo2WUWKNw18HgFPKz4TCJAkIEANkHCAhj/mlueOXte1+WAcSfSYc7hiXWx7YHerAjnIsUW03ihQym57PzOL+394GIoQTR4+MMSUeHuMH3LQwcMn/37tVaz2R5wmw30WhmnCk4yRYS6hcg8DoQWkisLafvBPtUqIzIO7kc9qzMHs9ZEFaf3420h+6O7sfQYPFQmLQYLMfzxy/TdhetzJdEZj5iGy3CpHSs12uNjgVuUBGXxCNhfeA5gN2aLcjHVgm+mmwn4twOrJgQDvLoweaAp0qcMIjxAzw+fw6Kc3ijRhx2b9fgGWzvv6CBpy0RJjF0WLIbbVMmWqZeezcKYyMLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The restored FDT contains the physical address of the LUO session header,
which LUO maps before reading session metadata. Check that physical range
against KHO-preserved memory before calling phys_to_virt(), and abort the
restore if the physical range is not covered.

The session header has a count that controls how far LUO walks the
serialized session array. Check that count against LUO_SESSION_MAX before
deserialization, and abort the restore if the value is out of range.

Signed-off-by: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
---
 kernel/liveupdate/luo_session.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index a3327a28fc1f..0244c071936d 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -501,7 +501,18 @@ int __init luo_session_setup_incoming(void *fdt_in)
 	}
 
 	header_ser_pa = get_unaligned((u64 *)ptr);
+	if (!kho_is_preserved(header_ser_pa, LUO_SESSION_PGCNT)) {
+		pr_err("Session header is not KHO preserved: %#llx\n",
+		       (unsigned long long)header_ser_pa);
+		return -EINVAL;
+	}
+
 	header_ser = phys_to_virt(header_ser_pa);
+	if (header_ser->count > LUO_SESSION_MAX) {
+		pr_err("Invalid session count: %llu\n",
+		       (unsigned long long)header_ser->count);
+		return -EINVAL;
+	}
 
 	luo_session_global.incoming.header_ser = header_ser;
 	luo_session_global.incoming.ser = (void *)(header_ser + 1);
@@ -515,6 +526,7 @@ int luo_session_deserialize(void)
 	struct luo_session_header *sh = &luo_session_global.incoming;
 	static bool is_deserialized;
 	static int err;
+	u64 count;
 
 	/* If has been deserialized, always return the same error code */
 	if (is_deserialized)
@@ -524,6 +536,13 @@ int luo_session_deserialize(void)
 	if (!sh->active)
 		return 0;
 
+	count = sh->header_ser->count;
+	if (count > LUO_SESSION_MAX) {
+		pr_err("Invalid session count: %llu\n",
+		       (unsigned long long)count);
+		return -EINVAL;
+	}
+
 	/*
 	 * Note on error handling:
 	 *
@@ -539,7 +558,7 @@ int luo_session_deserialize(void)
 	 * userspace to detect the failure and trigger a reboot, which will
 	 * reliably reset devices and reclaim memory.
 	 */
-	for (int i = 0; i < sh->header_ser->count; i++) {
+	for (u64 i = 0; i < count; i++) {
 		struct luo_session *session;
 
 		session = luo_session_alloc(sh->ser[i].name);
@@ -606,4 +625,3 @@ int luo_session_serialize(void)
 
 	return err;
 }
-
-- 
2.53.0


