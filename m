Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33410606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KuPI9WfJ
Received: by kanga.kvack.org (Postfix)
	id DA7636B05B2; Thu, 26 Nov 2026 07:08:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7DD66B05B3; Thu, 26 Nov 2026 07:08:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94726B05B4; Thu, 26 Nov 2026 07:08:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A11246B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:08:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A120A8980
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:08:39 +0000 (UTC)
X-FDA: 85477148358.11.CBE045E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 12E4840003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:08:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KuPI9WfJ;
	spf=pass (imf11.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795694917;
	b=4xxc+EuuukhkRJZ5xFsRBD83G3nHId19Mj5JV+972PswGb3d1+TJR8QUqCsOekvDbX8uQe
	ZiJJZ9uSWrxkcpkP9e9/s5akqvtyuvE4A+bO7jkD5/GhEMdMBQcPfLIAP2WyKprpBglWhd
	ztiFP29yg+X6rsFHny6o3jDinBzlFh0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795694917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ydM9v3ognVMl4Z4wVqg+E/Lddv2TxXeHnk+2JZls54I=;
	b=KQaJ+PqG9fRyYoYc+qH+k9q/WJHxTty/n2oGjalk7n9x1kkI0CBXNQssMt1CAW9eGFaavH
	dcnTTrLphw3Tkns1rWDxxznUzD9q9fQ21RkeKpYBjiX4QM4rMINYFYsnTY6w+DBJASSSaQ
	Hh1+ANSv7HN2DE92JZ0iH08reCZKcJc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KuPI9WfJ;
	spf=pass (imf11.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4574241090;
	Thu, 26 Nov 2026 12:08:36 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795694916;
	b=iOtBExNAGKa/0aWWxFf0u137fi7wwWnKr/yJX8Vx3PaY33eqF1OATMe5aVuxlyULqBWJ
	 h8AhFs2T2ulsbuMlzWZ6s6UwJkSCc9OBh7YnfEItbGVwQYTaLXQEtQRRbBAbqZ6fnt9CW
	 qXzyG/JmylOLKfWrrx6ey8vPb0eUd2X0za9GAHde3SrOas+tYgSK+5hL9DvE7ZruNW0C9
	 x4mHPNHgQjqhLt3cbILnz0mZ+GSLP2dfKB8vcm/dTmwRhQ0Swi6cMu4u0Ysx7eLgNUQTU
	 IIOTiJADWDzvLEFIEFeYtNiUnW3PpzaAc0aiFZ35psXPRbG7/mVcgMqSc0xfDqLxJ6g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795694916;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received;
	bh=ydM9v3ognVMl4Z4wVqg+E/Lddv2TxXeHnk+2JZls54I=;
	b=0EhfpO7+3ATYQh5WLauUPtg9fSZYWfTqEx0llFaHe6S46yrgpQcXaNHwwOZOxGWGYOfv
	 z4ABMANs08CsoHEcagom3z5P8AfGPrfCjANcyenGHWoQBRAukq+MS92U3f6xKYw8umWTY
	 ELZlZMvunGkGchX3YUuOrYxSgHqCvf0a5JWRzQG84Ojs88COe8PZia9SXmJLvg462cyUD
	 Bq1nXydccywYd4N7eAtStQ98tyb24CUpoVbLL4KbTksElLcpO8XkBMvWMh3mhmqUnEGsy
	 LlMmI2GK6x578wFCmKiWOWulMAT5uGWIWz88/gCW7cdEQQ8LDY9giWWNemyHpDCKnLw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3B0B81F000C0;
	Thu, 26 Nov 2026 12:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795694916;
	bh=ydM9v3ognVMl4Z4wVqg+E/Lddv2TxXeHnk+2JZls54I=;
	h=From:Date:Subject:To:Cc;
	b=KuPI9WfJVjG4GktWf3Rp42XjlRrj4U4Q2l73y/bWmc9DWYb1QtsVHH8cToQ0h2SE0
	 G2DWU5zOKNVArECr9uRgsLf5stVxM3rOoaRrZfeXM+zjVKvQEuX9j7UbVwj99B6aF/
	 Q+zWUaBQdtkPpokCkILoQ3oO4L1kzSntzA5A4A9u7VE72BvkBI9Hj4Tf+HQmzoK58i
	 4SJvz7p135r5AsOZ+7zDDpz8mZFA1pq4Whd+UQnTQ2wZPK6T9c97QnWW067UaR0wbc
	 fYYiA8/eHA9+5ZztheVROiW8gvE2X6CNnmg7H2VQ/wdhue5fKqiB7equ3CbJ+dMXaN
	 SDKKguuLAGKQQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8C6234D491;
	Thu, 26 Nov 2026 12:08:32 +0000 (UTC)
From: Joel Granados <joel.granados@kernel.org>
Date: Thu, 26 Nov 2026 13:08:10 +0100
Subject: [PATCH] mm/page_alloc: drop staging copy in
 lowmem_reserve_ratio_sysctl_handler
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-lklm-sysctl-remvectmp-v1-1-602568b53c0b@kernel.org>
X-B4-Tracking: v=1; b=H4sIACkhCGsC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDSyMj3ZzsnFzd4sri5JIc3aLU3LLU5JLcAl1TQ5MkCwNzQ1PztEQloN6
 CotS0zAqwudGxtbUAFgPELWcAAAA=
X-Change-ID: 20260922-lklm-sysctl-remvectmp-514b807157fa
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Joel Granados <joel.granados@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1985;
 i=joel.granados@kernel.org; h=from:subject:message-id;
 bh=3iZebsEPxjDB2kT6KSg7TMzGxHwXEuJwadUR+Zkznm0=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGsIIT8ychip7xYNXtSZnDY+3UhHZ1IFIQV98
 oi/6l6RmFTonYkBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJrCCE/AAoJELqXzVK3
 lkFPz0YMAJZPPSibHZHi4iyHPD2l6UQ8oaD+Ysq5JXLnhI6vHCH3Ycqgy0zKCg+7t9L/A94P1iH
 /tdqmBWbaLROmVUyps1nrrw5kLFlOpJRbvw30QZuHp4jUEBwI4K3NTtbF/rIuBbl21rmGnuVNez
 LFY+/6/koB3poSCuVlOaLWuzL26FStZlT9CtmWwswBIsMaqwuCcVAYgEXTpRE6shAIVhf0LKWvu
 3r41qD7QiYnWOBqUoX6rTqpU8aJgFwdD5bFNvNfiw1/sICtzInFkOr2BexdhsWiWkLL82UE+Egi
 4G4OF6sY8w9Cs5Flh20/TOxLkw9M7+K5hctRjErKnYSioeNi3wXIGtHqjQAD8pHNEST/tYF0UfP
 F+tfx7ZqI6xdRrP2C6/I7bh4N6UprhPkk3Z63nilXgchmBaWPBJs6kxpf5AvjZcn3mt/TGh5Wdq
 TIUYgcPHnWVNC5bGARY71GYZ4QUotfJ57UFvkYOweCuBfwRe9VL29mziOW1sKhgWtq+wA0SYwY6
 tA=
X-Developer-Key: i=joel.granados@kernel.org; a=openpgp;
 fpr=F1F8E46D30F0F6C4A45FF4465895FAAC338C6E77
X-Endpoint-Received: by B4 Relay for joel.granados@kernel.org/default with
 auth_id=239
X-Rspam-User:
X-Rspamd-Queue-Id: 12E4840003
X-Stat-Signature: mnrrz447sw7ofyawt4gfam4cdoy1ka5j
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795694916-340001
X-HE-Meta: U2FsdGVkX1/2xtfUe+pVLdcAeRtlER5gGjAjrJb3LcrxKSAS6Ge16TDjgPAMzFPIoBTMrhxC9Yn4o/shwrUQQRHUDRmGlUYdQlmlWhbSDEquhrrL6gCjOsRD22yiBy++AmJVSl9DY/uMzasYsUSVUvXShZcUpeRgNFBS395pyJKTZTGUfyNTmb8vMNkdRDK1p5CE56j4nwDn1NwqVvtpjxKg5IVQHjZcjoNYtQJ9js7V6HgSoaN7ENz20s+vcbibOUsrM0BYLiCSrXO0I6hwBwNWYR9etORYQvPVddnEYqsKYRJauGtsZeh5yAsX/rf3x5ASXLqi9HpyYdnGe2i+jnqK9Ui3KY6wj5epfJA67mIa+fPzIkeanVsV5oPci0Km7Xb0l/o+x2kIJsPYmZJVXrtXSMGzSpKHBU2M/X2vSJYbqOBGnNklM8J3+2gGzN8aG/dwSYdcdXx1SCIEI7+dO7VjFl006dNS6r+VioKRcJumOVpjBYta7NqlVMpYRkSUjwgfejkSGMHV7wwEn8hOzEfhrj7vOqYAuu6vcRE/3svyaiDsKUTCZHYx6LGkZIev4Q18lRia41IN8HjC+rEsVqEvp8s9sDVeyBF7O8OCzJOCvzcFEhVDrAGCwgHT5tT2T1TnJuLYuG9BGvyLvTfAI0Ekum/39MW6zSkbMDFcc2w3JRWP4sTsa1qahGUhlghGDxdFW3FDedh6M+3fKeGqXN4DB7YFYwg8VYmkmdwvt9vbynV0LJdOFH+bsGR92fIcLiAWX8K5Xr+Fe2UZurjMa+KU6Ss01u27fKoLPKJzlnHdkMpRAtM0hCuUYSeSFRggStGnq/583wQkMOW65qweKiikeanQPmL2aR2LQ2iJXTW/FR6p5b3IhZpAuk1D1Eh0xt2uZ6UJZrTkizigSfdSWWo+2pwI8+l5B2Td/+kw2EagsNnvZsk1KqjqK6hQs88LjF5LaMQY9xm+Xuog2zL
 iKWx6rAc
 IiAN/LU2Cx7vJhiftv8YFBfL/yjwEy0x4qR1qy/zF3Qc9XJQrB1hgpVqNBc/iz9EUDjEGhl/qm7fhF/6E+yGSZRIX/+qSs1VeRZwHKMkIsjz6r+UU4h38zm19fu2tzPMCQOqYaRCiCcjKCFakgSshRZE/9RtZuOSOo5EUt31big9bqYPiB0PAoOG59GOYO7sIp6GvndyHvXIecUKdX1O49NMwu1KigNbKVYQGAfMeNAnlGLY/bCG+CSJcSV5ojoXQVmSEVpq4pSqsYiRxS2SjVCNIuANC3+ebxSMMnbqHwydb62bAA7am8D/sGk+tseGVg9ccsP3+xLwl9NORsEuFGLFvb0jcio75B0DmDb6ff2A2WJFVoZd6he17v6v10b98TbY4IjPAglCbJ8Qzkjx97tNyrSCwYFOJkQx37xoYxZGSJuptLjbVsS314SkVWVRkAZVQGltoQrHFCL9flkJKsX8tashLkypEEhnLQzQJLVKXKLXML9JKLulXrABotFwYbjCbJB9lzvshOmPS4F0dNmGImf0VR5DWkR9pJDNVnFeSr0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sysctl_lowmem_reserve_ratio[] can no longer be left partially updated as
sysctl now stages vector writes and commits after making sure that there
are no parse errors. Remove the local copy and let the staging happen
within sysctl.

Link: https://lore.kernel.org/20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org
Signed-off-by: Joel Granados <joel.granados@kernel.org>
---
Now that sysctl vectors cannot be left partially updated due to
formating errors, there is no longer a need to stage it in the caller.
---
 mm/page_alloc.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2fef4092c913c1c06d827a37e8af60641129b44e..54b93f5367df5b4fd00fec225611447a87917beb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6927,26 +6927,14 @@ static int sysctl_min_slab_ratio_sysctl_handler(const struct ctl_table *table, i
 static int lowmem_reserve_ratio_sysctl_handler(const struct ctl_table *table,
 		int write, void *buffer, size_t *length, loff_t *ppos)
 {
-	struct ctl_table tmp = *table;
-	int ratio[ARRAY_SIZE(sysctl_lowmem_reserve_ratio)];
 	int rc;
 
-	if (!write)
-		return proc_dointvec_minmax(table, write, buffer, length, ppos);
-
-	/*
-	 * proc_dointvec_max() works incrementally. Use a buffer and only set
-	 * the values if all of them parse cleanly.
-	 */
-	memcpy(ratio, sysctl_lowmem_reserve_ratio, sizeof(ratio));
-	tmp.data = ratio;
-
-	rc = proc_dointvec_minmax(&tmp, write, buffer, length, ppos);
+	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
 	if (rc)
 		return rc;
 
-	memcpy(sysctl_lowmem_reserve_ratio, ratio, sizeof(ratio));
-	setup_per_zone_lowmem_reserve();
+	if (write)
+		setup_per_zone_lowmem_reserve();
 
 	return 0;
 }

---
base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
change-id: 20260922-lklm-sysctl-remvectmp-514b807157fa

Best regards,
-- 
Joel Granados <joel.granados@kernel.org>



