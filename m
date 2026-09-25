Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8902CC98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 15:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563236B0088; Fri, 25 Sep 2026 11:10:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5146F6B008A; Fri, 25 Sep 2026 11:10:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402DE6B008C; Fri, 25 Sep 2026 11:10:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17E5E6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:10:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9DE25C0659
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:10:04 +0000 (UTC)
X-FDA: 85252619928.03.B38A9CF
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id B8F864000D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:10:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hobvotZH;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790349002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8ZsRdp36EZWb0DJkYc8BpcrrbAf/mTTeVBAJoAH0lws=;
	b=XBda5ircuSr4jWRH8KBXed/Ul+tEx6YVOcTE76zuQ7PIBGB0H6N3Xby2JSBdxwu3ETJCCp
	jnspPivf88coeNPNUNmxEgTzwWsDnFtGHn7+CdSJXuVDSDFvMNw3RvRIHvWr/P38GmzSIK
	yDC8aAOe4viJCqAYYPuc8xtH3QHN8vQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hobvotZH;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790349002;
	b=dXOBv+lr+G9gU34P8RRqZboq6q7JlFhFxZVnGabJkmDvXs9KyEExtPtlmfgGnj81g63pVA
	yaJ2ZMYZarbPRy8lFOj39nSK9d/0qUTjD2yPor+WMaZTcnVjQcILltZUkLMc4C17xnQ653
	qTCQfHrol8Z12y3D/1ddfmEcnGaBQww=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=8ZsRdp36EZWb0DJkYc8BpcrrbAf/mTTeVBAJoAH0lws=; b=hobvotZHAGf8k17uWJCa0M633j
	Xgu23JcquGP8lXWipCmZh/G5kobCcsQQgbPcHmuGoMq96+PQL+Jad5Ov52BpZ7TFaGP0d0jOSmGWj
	6kiqbW57/z7+9gDCZlJxAb5O4dOE/JVX2ZKWKt8xx3MWpWEum2UudXPmjoR32fXhHqY5ifLUsQOTb
	sUBNeBh8euK5zvvxWA405zJ5cIHTdHnqODY/WrLKnjJnYtN9o3DyO6Kav1EFwCUs9a2/93UMT5QLu
	6tIiG1WpkOTSbEA+Gd7Nk9H0+EuCUZuNf3rAtEHNd2MvyT9Tj6pmN4LpdWSlSaaJkQ+67idAKuFMp
	dpCZQ1NQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xA7Y7-005OBd-3C;
	Fri, 25 Sep 2026 15:09:20 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 25 Sep 2026 08:09:11 -0700
Subject: [PATCH] ACPI: APEI: accumulate the queued flag across error
 sections
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-ghes-queued-accumulate-v1-1-df50553957d4@debian.org>
X-B4-Tracking: v=1; b=H4sIAJaOtmoC/yXMQQ6CMBBG4auQWTsJlEDEqxgXZfoDYxS1Q4kJ4
 e5WXX6L9zYyRIXRqdgoYlXTx5xRHQqSyc8jWEM2udK1ZecaHicYvxISAnuRdE83v4CbrpKjl7q
 vXaAcPyMGff/G58vflvorZPneaN8/uRej5noAAAA=
X-Change-ID: 20260925-ghes-queued-accumulate-591c8ac3b32d
To: "Rafael J. Wysocki" <rafael@kernel.org>, 
 Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, 
 Hanjun Guo <guohanjun@huawei.com>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, 
 Shuai Xue <xueshuai@linux.alibaba.com>, Len Brown <lenb@kernel.org>, 
 James Morse <james.morse@arm.com>, Xiaofei Tan <tanxiaofei@huawei.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
 linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, kernel-team@meta.com, stable@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=2558; i=leitao@debian.org;
 h=from:subject:message-id; bh=VW/XrB+qV68/FcIQ5eMC74++xgOoT9nZOvKItukui0g=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqto6cfmYO00v2L5iB3D85pOjejWCOxbWqEF6kF
 qwUy4rKhbuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaraOnAAKCRA1o5Of/Hh3
 bWocEACQACuoZbczHAR3Rz/S8hB7WnO0Vizvw1vb4qil7D1UuTHVGfBa5Yq/CEMt0OpJ/5hTy8D
 wkUu/gKIGVue2gswaJh5dy1CkheOC0xhz1sWpOaBV7ppyuIJ794lQEBhfyknXQslfc5FwHdEGVV
 ssJHzJANQ0WPGcvnJYgm9p+oK46hGKpURxGvDDRET0+YJuqa9simwd0l3IHB5jgILRn7OC6F3PP
 0NTjURh1DrHb02TzaoCFNc9obI1TavcnYT6VY9NFBWFVsTKB5sRxbACa74lwHKh9eyeGOP7VaDZ
 2R/B/WJI6ztT4r+OUBKcc0TeTO0MaAtLFgcJRlH0SG1uKrNx4S5YqM/4WGEdsu91HTVXBIKL0YJ
 jBiHe5BJRu0rT3+6gVO0Maax1MVE4FHFvcIU+8ZE9y9zc7fMZ0W4Gnd4XEbQK4SlQABU6qJndEl
 6/ytsZNye/i3lNsWC7OrGYguBBqlt0DxKL1W6+vOZhm4PFlGKeZlTLbBu79BeAfoPcY5ebJ674t
 nHVRmSgk+4LVl6GM6YtyxKsN1jyYc1kAnE0vMyEDV04Wq8U6UmBHoMyYTnRKEuzUddfKZJLGb78
 j5I9HMLf221Of0Rp/rI+40pxpvJDkxoDiwcYY/txMHa1Dys3Sbi8moPMPz2K/rwQ6Lx/HCBee5l
 AuiUvgm0Z2A0+2w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B8F864000D
X-Rspam-User: 
X-Stat-Signature: p6r35i35ppdza1kohyz3nxipbmz5upur
X-HE-Tag: 1790349002-353350
X-HE-Meta: U2FsdGVkX1+Qj8I95RqnRKQxy/QjuqSeYOLrSJGFcDznBhVOm4FDZKrOzl6NojcZYzJo39E+t/efzQctZhoYPFa8w0sg6PosbDHfpZEb+daf0Ldk+TfJa4o36aEYZWTiK5qAyx0KOzlTNOgjuGffBQeRdD+Tkx2VdAsc/5r5j1mAVzbMNuqk8fgK2H0RMkDhxq/x6VPgNL8BigAvvBTZ4k9TG01ghW+L067wXzu0gnoLZzUm0nnRIBxGYTAOmOY5ztM2W+jZsDxkEjv34T33LvXLyIRmYbn4UiQLJvyKyUH5qrwTqirL37bkYFnDsQT0F1OY5vvBnsw7SqhGftjVxuD/ura9XJmbnfV2UsMRvNkzyOk0CwK35UnI+0lcs5XQM0ZDdQtf51VLtTK2FT0C/jYT5uNG8gbOQ8znl5VsyzXlrTpFPswb8yjbxwhT5Nd8ok74f0pwb9apR65iymV4eVAk/74UeMFmKR5dHx4KEGxBa0R/X8m8D86LM561/wueq0X1jGzAkreUcN0v2kOBfphv43/At1gEjoPfepViBU8yA6tdZECkpLBLNxWnyDL7lpviEO6tttMGGT78SzFRRE+zK47TjBK5RatC1Ju+ElzNLAgDPQNtsPzClrrepwEtnPDXsJgFkTgd4DEC4bro1Y7Tjw9L2OjeWAvtk4yWXQrYRez17+oEPnnPb2DUyLUg0h9eKC0c/1BIwvJ0nU2+boFnb05xUjSEE8qam1uJMTniH0lLYoPECp+YoY5sY/9I0QO22qojY719+BcaozepNrLdlaf65OCH2IPhghsLjkvatQfDQJG7Shg+8N+7jRmvTOVB6be1j/82lWmyz6wyEeRlYJ+Qjzeu+fdWJYLR7bjY6ESSVunMm+1cixBzwCoVKBWmMRafrOhZn6bUb4O+k/77P+6sB/cAQ92PqO/BRBIhwtLHE3dgvNGXa+AWjzeDSLZYNVDKkeTC64jGdr1
 KBcOilDH
 hlkHRcMZmyCvpfQ3QiJ/rQNpxjaDJscguvg9te1PYarPRL7KRfKrnfpEfk/Eu9y/XyuIW5zckOwBejCbUY6sOjqBbVxwa7OtmnBIpIltnE0zplhcmlkMyjytR2SgNMoXqEeFT5ORKauJJNB1cB8Cedq/xbwcUksS42Sk3N22A3Hi0UEN8n1V5nrCB2nfDT1Hx3s1GbqmZY+5I+KMpitRw1j7LAiPPjvG0pOYtlGXNtCuGZqIzKzlR8zg2k6CUELK0LJP/xeTU0mZEPOpqXdARapSIt0Qi4L8L8lBMEPe97OaoHuxqZWpgU4SZUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ghes_do_proc() walks every error section of a CPER record, and
ghes_handle_arm_hw_error() walks every error-info entry of an ARM
processor section.  Both assign to "queued" instead of OR-ing into it,
so only the last iteration counts: a later section or entry that queues
no memory-failure work clears the flag an earlier one set.

Instead of reassigning the variable at every time, just do an `OR`, so,
if there was a single match, it will return "queued" as set.

The comment above the check says "If no memory failure
work is queued", which is the semantics this patch implements. I.e, only
SIGBUS if there are queue was not handled at all. If we want to SIGBUS
if any event was not handled/queued at all, we will need something more
sophisticated.

Fixes: 7f17b4a121d0 ("ACPI: APEI: Kick the memory_failure() queue for synchronous errors")
Fixes: ccb5ecdc2dde ("ACPI: APEI: fix synchronous external aborts in user-mode")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/acpi/apei/ghes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index fe10ab0e02f68..ec2d5ca51db02 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -603,7 +603,7 @@ static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
 		 * and don't filter out 'corrected' error here.
 		 */
 		if (is_cache && has_pa) {
-			queued = ghes_do_memory_failure(err_info->physical_fault_addr, flags);
+			queued |= ghes_do_memory_failure(err_info->physical_fault_addr, flags);
 			p += err_info->length;
 			continue;
 		}
@@ -951,11 +951,11 @@ static void ghes_do_proc(struct ghes *ghes,
 			atomic_notifier_call_chain(&ghes_report_chain, sev, mem_err);
 
 			arch_apei_report_mem_error(sev, mem_err);
-			queued = ghes_handle_memory_failure(gdata, sev, sync);
+			queued |= ghes_handle_memory_failure(gdata, sev, sync);
 		} else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
 			ghes_handle_aer(gdata);
 		} else if (guid_equal(sec_type, &CPER_SEC_PROC_ARM)) {
-			queued = ghes_handle_arm_hw_error(gdata, sev, sync);
+			queued |= ghes_handle_arm_hw_error(gdata, sev, sync);
 		} else if (guid_equal(sec_type, &CPER_SEC_CXL_PROT_ERR)) {
 			struct cxl_cper_sec_prot_err *prot_err = acpi_hest_get_payload(gdata);
 

---
base-commit: 587858367581b9c55c3690f4e63382ad622719d4
change-id: 20260925-ghes-queued-accumulate-591c8ac3b32d

Best regards,
--  
Breno Leitao <leitao@debian.org>


