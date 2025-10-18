Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38FF3CCD184
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 09:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84B348E0006; Sat, 18 Oct 2025 05:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822AB8E0002; Sat, 18 Oct 2025 05:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75FBA8E0006; Sat, 18 Oct 2025 05:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 631E78E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 05:30:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E9F0E58FB2
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 09:30:16 +0000 (UTC)
X-FDA: 84010714032.27.C1DBFC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5B82B18000C
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 09:30:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fIUpQKZ+;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760779815; a=rsa-sha256;
	cv=none;
	b=tT/blvY/lzPBIylcy7hvz1DiAsqs///n7PuuLvs8AMF/n73tLJVo4jjTeTIN/ZDLqoXAvE
	YBVrTNIGU/Cmu307pHuj2ZCfo8blos7h0crLfcrIBCmkNAAjuJ6PgrijfEugG1z8HsEFU8
	bpmqO2R2Blabvd8dO/4ErQy9UAXraQI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fIUpQKZ+;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760779815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imUHb8lw+Clybg9bXPaF1ucAzQWMmzseAcsj5KJ/Er4=;
	b=O9JQky69O2fmstYZjTlQE7QJopYYScSiiQPUIExu+yeYfQ0X6DLyYFahC7e7iajwoo04tz
	Z8rERg4W/v2spwTQVRAKkH34SSfbG2V0ZmIG6ys87QDFviRJ07017Bu7/VjoFFFqMZGru6
	irXAUPbEaXXVq9p4x0rfN2TPfcLWbUI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C5E6B60610;
	Sat, 18 Oct 2025 09:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC55C113D0;
	Sat, 18 Oct 2025 09:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760779814;
	bh=J3OM+/ebcqzP+G29UcHV2tXMIh+anZiIJ2e8hqXFf+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fIUpQKZ+gVg+pxmJGHGMNRmdb8PTrjQiMT7LfgM+OkY8IqJ5s57YwkFZfWomtaIAy
	 8Xw1h2oO33T+3ULNBPey1q0d60cjIptT6Tw9P4U+Ng70r3sBLr1XRk6bOwNUuhobva
	 JVGvyPBm+iSHqxC/OELlFAg6CPVsbXiFI8vsPVTTHJGjA+kwu3rf1mB7LH/1aSVF6z
	 RRYnGnIbPuhxyhOIg7KQjnNDZC23PLBt8UA6dBMU20T0+35sD9CuOgGhjiVIHQy05k
	 SNhNj7fyFQjnqPgSYsBdhNEPp7eydEWk2AfhxT7dt/WIWMWWWuUvbXs2NFvxZJ83Gw
	 LP1JKJ/dcpang==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] mm, vc_screen: move __free() handler that frees a page to a common header
Date: Sat, 18 Oct 2025 12:30:00 +0300
Message-ID: <20251018093002.3660549-2-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251018093002.3660549-1-rppt@kernel.org>
References: <20251018093002.3660549-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: chyr7kqbho986k3m4fxx7drfic6awwnh
X-Rspamd-Queue-Id: 5B82B18000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1760779815-56955
X-HE-Meta: U2FsdGVkX19Xf/LoiHVEjiEVtgG7hduZliIXNHDq5aSa6DUCPRQYR/BVcpkU0czq6Pv/JiH96ywHQQGzrSaFEr1+ite2jn7j5QDW/jmldhdHp9E3hW45c+L1Fp2XKFPz6xngwuSHKfDyL0AG6tBFYG+NW/1euO08XWt8Mh9DqovBpo2XppEU+bp25d6B51BqZQ19vJWgQGhVgLkXZBS6x3x6BkzONgJi9v68f+8Fb2SPq4sghnhcbZIM9jk0CYyDvK4SyDBRvApndG+C6W1/TV+jylzffJsAR/ENYpbvND4q3tpm2Hm86ooajhKO4RrKJg6XTn0vbfeQ8icUog7MSBBfQddaRBQXF7XdlQbmzBA+nU8nrV3QaxwXN5NDCWcsaCe4QRFlL9sfC5BPF9UDzFRH1m7J67Ej6whUVLmKfkS52KqFXCaTJUraCJeTLbwgvfoNI+Z13k4/IsgJOhxaHJtUnHWlUrILuV7pMvU0mDOz5bqDVKO31HERRuAWOFlkdZ3JcB0EBQrZD4DSw7Sp5cCqZpaXco3opaOnN+zma1/2/sR45NkrIirNG3qhd9whEKSHQQ/8L+isRJ8TyiPken7ljJFZVLKpLbU2QlGlcsmgfShHDZ4LtjI9y2WaaRBhOf3uk39k9Sk3SvdhKbzI8VpnV0f+g+KGh4A5fmNJjtbKZkMZAb+MQ5Vi8qMQNmiy8mJd78EiT2gTE/Y04TaLj2daq6V2BEa10GIsC/j3x3hnI5sco+gQaoj384jxxyXfs4SmRqatJZ8eCZhDlvVE3wubk+fvn3zk9gjLEb1m1lhMf9vFfJVIrsw0hnd1xvdL0c7bfLqWJe9QN82Bp8fcEzcVMIaaHqpSlVoJ7y83mIhGAg7iX/VVPV9r0Dg/TXrkPdDMVXf/QaepLl4y8EzpN1+gGPIVncMcgJOlwrvZdEVInGFdQgNO/MwhXXJlWpiBlF3odU+v+Bup73gNAMX
 oIrWLwlQ
 NHN0z5L2yDWBTYWcrKIlUGjbLabvEUAeobVOrxv9Hkmz3bjQinICE8Jxyd9L03jngc0EzJrg3jGBH5h715gVITAmse3XX7EN8H/hEZuveZYi4peM5LueupoJrHCjV9sCWDWY8SdT0byTZgiR7oN2eo4DIJVBIKpsFglTkB+2ZfvssB1LP9WEQyNm9rUyT4rKpnfi+UNWHqy4eSjSXovFVsRXVGM8WMP8YLtnd71jZuAp1kz4ut9CGmtnApWciD7dPrD9UQn24KZ8+W3eLPfX60cps4ojcEvdWkjrIsy/BNUuut89IDuld1EDmqXVILhLeqTRt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

vc_screen defines __free() handler that frees a page using free_page().
Move that definition to include/linux/gfp.h next to free_page() and
rename it from free_page_ptr to free_page.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/tty/vt/vc_screen.c | 6 ++----
 include/linux/gfp.h        | 2 ++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index c814644ef4ee..d2029f029de6 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -53,8 +53,6 @@
 #define HEADER_SIZE	4u
 #define CON_BUF_SIZE (IS_ENABLED(CONFIG_BASE_SMALL) ? 256 : PAGE_SIZE)
 
-DEFINE_FREE(free_page_ptr, void *, if (_T) free_page((unsigned long)_T));
-
 /*
  * Our minor space:
  *
@@ -371,7 +369,7 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	loff_t pos;
 	bool viewed, attr, uni_mode;
 
-	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
+	char *con_buf __free(free_page) = (char *)__get_free_page(GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
 
@@ -596,7 +594,7 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	if (use_unicode(inode))
 		return -EOPNOTSUPP;
 
-	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
+	char *con_buf __free(free_page) = (char *)__get_free_page(GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
 
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index f46b066c7661..ee3f27046667 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -385,6 +385,8 @@ extern void free_pages(unsigned long addr, unsigned int order);
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
 
+DEFINE_FREE(free_page, unsigned long, if (!IS_ERR_OR_NULL(_T)) free_page(_T));
+
 void page_alloc_init_cpuhp(void);
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
-- 
2.50.1


