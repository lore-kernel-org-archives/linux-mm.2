Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7564AC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 12:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 103B16B04DB; Thu, 13 Aug 2026 08:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08CD56B04D9; Thu, 13 Aug 2026 08:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2BA6B04DD; Thu, 13 Aug 2026 08:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A18306B04D9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:18:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2EE0D80146
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:18:54 +0000 (UTC)
X-FDA: 85096150188.20.0602386
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 577B8C0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:18:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ryh/evkH";
	spf=pass (imf10.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786623532;
	b=S5WqOMA9jVeSB5cWx6cqtLtk7o5GzAxLTBkkrOoL9Lunx7rFOgYMHguCC1nEwVVammGiKa
	0vuPsK1Lz+ApS6WCvVZY3r1J/usOoLulSBksm14eZ5DE8b6hOOwXvVIWin4+/Hcjm1PsYX
	VT2T/dQzGdfcH0pKTh2SwY+5CtgsTSc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ryh/evkH";
	spf=pass (imf10.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786623532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KwMcbJ8SAGn0kwUMVZkpCkdS9XE3CHxZbG/TPncTPgI=;
	b=iW+BnVQalSS1xv1X/3jhd5ofF63d72AexBZrIqwQUdIAPWUwF9MVixYbhRJY/y5mWaWqkx
	oe0GQMSgXm6LJMm74PdtlXwFUxDmORhUpryqZGz70A8Mky5W8TWTHaK4tty9UpmNPwOZLE
	ivnc/sDOF6jSDFb+jnVHSq8QOxN/L1U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E2564600E2;
	Thu, 13 Aug 2026 12:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82A97C2BCF7;
	Thu, 13 Aug 2026 12:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786623530;
	bh=yv5GjkliXQcT8cxSUVRpuQJjqp7Lbh33VFnF+Gh4c50=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ryh/evkH2yYzjBBuy21AYS+pDPgkDR7PtJFHkNohqaG/5I1IoUIUXENrzHuOiuUEs
	 CfoBa0BfJ787c6yAd6D2kOx3s0gJHibcViqsR4Uw5IMnwUJrn6oRYUNI4ReHu1D6Au
	 qC8JIVm+uGAtRanKedYNuTkPDaWsOQwxdCrIf01Yd7BcZhCBBffXteBKQSQx+bXoSL
	 mG3AEmzOG4hADhzy12tzS6T1jJfUAqhE0Dt1Vos5jn/GLDp74IICZ8oFj1likVT7lJ
	 09FWrQOABaK9+moLPDLw3p9cVVciLDEHY59vYgPXWrBP8S1qQMF3uuQEVpzxZnJ4bZ
	 dJRF81Vir284Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647F5C5DF66;
	Thu, 13 Aug 2026 12:18:50 +0000 (UTC)
From: Joel Granados <joel.granados@kernel.org>
Date: Thu, 13 Aug 2026 14:18:38 +0200
Subject: [PATCH 2/4] sysctl: Reject uint arrays before calling the general
 proc_vec
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-lklm-partial_ctlvec-v1-2-df9e51c13704@kernel.org>
References: <20260813-lklm-partial_ctlvec-v1-0-df9e51c13704@kernel.org>
In-Reply-To: <20260813-lklm-partial_ctlvec-v1-0-df9e51c13704@kernel.org>
To: Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 linux-mm@kvack.org
Cc: Jianlin Shi <shijianlin11@foxmail.com>, akpm@linux-foundation.org, 
 vbabka@kernel.org, hannes@cmpxchg.org, surenb@google.com, mhocko@suse.com, 
 jackmanb@google.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Joel Granados <joel.granados@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2851;
 i=joel.granados@kernel.org; h=from:subject:message-id;
 bh=yv5GjkliXQcT8cxSUVRpuQJjqp7Lbh33VFnF+Gh4c50=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGp9tievBOA8miXa3XTlhlLBnnybuWYQGNvc0
 nRW5nZVG3g0RYkBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJqfbYnAAoJELqXzVK3
 lkFPWHgL/3GOSaXYdmehuwFyZyAqE0pIMfSa1A0ISRSPCn80Dm1XIZm1UJz+XrXAaYqjqbSVbYW
 mDb1Ukt/LYEaKpoqJqu3I10CKPMQObYQrXuWZuSHYfZ6t/jSZhjC5gf9tfberLK2Secv7/3UrWA
 WH1/ot+xDko9X8ldQxC4xNjuJT9ItUriOdvmeWuvZ7LXTAxspY7kZLZkOD3B2RLKhnDBmsgWJeB
 h1gvq5wBnVS0BCAEMEIRAUy9WyGZ4aM0K7zygMTmucBsOvaeHGVIIeFwglgUImcxtbiGD2W5E4v
 QPDTxy9xLWi5OAMFFqUrSHZCsEX3ZsxBIZ2dL7tH5wQ6ccXfPGSYmTQXv+LassO+RUGJ9Zj6p1N
 gWsnm5FlrpPLimv6MDfpvvNYT8oR0gn9AeZ4iq2UayFCBGSBvNu+PhPDvNW1AuW8OdlqvK2dUx+
 eiUf2cUTD4IM3a2vyeTdhBaqE0N+s2Dh5xBXdVsteIc1eEmdJA3uP5mRyHlPCXbZrJRlcs+Su87
 Uo=
X-Developer-Key: i=joel.granados@kernel.org; a=openpgp;
 fpr=F1F8E46D30F0F6C4A45FF4465895FAAC338C6E77
X-Endpoint-Received: by B4 Relay for joel.granados@kernel.org/default with
 auth_id=239
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 577B8C0002
X-Stat-Signature: h38xkud113wtbdbzq3uirgwgsom887ix
X-HE-Tag: 1786623532-989592
X-HE-Meta: U2FsdGVkX1+eWA55q5WqI/QDRysWlWhSb+9FxFAdzoX6erzq79eYuyg9zoqGP7dSvFDqnskt/A1AWJnW8NGpuWhPcUkD2Yuf2TjLW3pwtktmiU5cuAQrEqLEOPZye6gqQDr4uw+STY6QxDI23XcspXJn5YybcxsV9Kpl8bvURIIp/A9Ig3p8YUT7g+MauhJklMn0LUZJBHMWOJlI1dXmqnghNtrAnY7NiW+JyDIrTbmPm0/ciYgdW2A/18p7mzSP4xF6v9PNAvzCBjFMIwmtfvyaCIGMIrVNEwH/XRfqUmvlsbs2YTujBMSbNnEkbB6JA3rCldmQ5SHTPnWyDu+BQQJvIAPm+hhT8arYYr+I+LGqlPuPwFXk3njle+6NMBYp12/9cF0ypEcBppL7/825op3j0DfT9qEMTwlU31uOzGauv04LP7Yu2DG7rIvIVOW1bi/Kef42ifr2nPgW6g90hvzNiZY7o7plQ/nBgkzqBq76Z3K7QnEBJGNUlukd3smZiquE0I4aY9rxfrLW/7ZTYzbjth02gR/uqkn389oCgA5ihH29E1uB62Ky1UqkGr5pkYPEbRCothoHHVah22K/1fOV+4SV3k15qCBnOFWa5mcNQMcUlxdBCOlkP2XM70A2UfQZg/1gJlwnR29o4dOwjUY4Wmb6oTLtVp9Tofzp2t2mh2u349x/PI96pB5l8/YxPe43eW7sG/P9xFtEg4xiLg8VpMb7FKcwfVi7DnEUED50j6oiTDX/StEAkGUVXa7IpaoOfyzvOG3iSem3SnWHvIAd0LkhVsxvMbpX4XcN2blD7Yc4eyzQdFX8/ZSqKGtDy21F2kHnGp2j9BdFTQangDsiYIHITb47TsS9KRuYQmhD6nzxD4kWJQt9yD1lmqtpUtTHzUeQyo7XR36l9Wa2OssQt76VwIGkExHTupR2u0uylSTxu0z+zDcH5mZzY/u/ww/ypjiim6NqwVIMXlc
 IkENDcp7
 NUEO4GePrkNKeDDOskLVOm5vAP7L3Y2BK9bsE9GkgwOOHWXSW9UxXDt/cP7f+UaESp5+eDYUSVu3sCRwah0ZvQBJOm+T3+DNimE++SQg0T6Bjvh8OvRJ4U/h9OTgOwwV9GRjrUIMTT2QaFU4RMkLqhL/tJrc0L3TIWd2z3UVQ5+PYRt9hIxrRdkkCkasTwXuf5M12mM7GidNgHMFQ2YHP/Xt0uo2goKfa0c5pdkhdFH1y6OF94QR2GgH+Vr8VIEdm+8YD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the UINT vector size check to proc_douintvec_conv; the function
that routes UINT types only. Route all the UINT calls (including
proc_dou8vec_minmax) through proc_douintvec_conv.

UINT proc handlers that incorrectly define maxlen will now return
-EINVAL instead of 0 in the cases where data is missing, lenp is 0 or
ppos is 0. Note that maxlen == 0 is not considered as miss-defined.

Signed-off-by: Joel Granados <joel.granados@kernel.org>
---
 kernel/sysctl.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ed0e5101949c2fa56e33d543c65175d0ab579fc7..c5fa916e626a336c004d596f4c74f829b1cdc5e1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -739,10 +739,6 @@ static int proc_vec(const struct ctl_table *table, int dir, void *buffer,
 		return 0;
 	}
 
-	/* uint arrays are not supported, *Do not* add support for them. */
-	if (type == PROC_VEC_UINT && (table->maxlen / data_size) != 1)
-		return -EINVAL;
-
 	if (SYSCTL_USER_TO_KERN(dir)) {
 		if (proc_first_pos_non_zero_ignore(ppos, table))
 			goto out;
@@ -788,6 +784,9 @@ int proc_douintvec_conv(const struct ctl_table *table, int dir, void *buffer,
 			int (*conv)(bool *negp, ulong *u_ptr, uint *k_ptr,
 				    int dir, const struct ctl_table *table))
 {
+	/* uint arrays are not supported, *Do not* add support for them. */
+	if (table->maxlen && (table->maxlen / sizeof(uint)) != 1)
+		return -EINVAL;
 
 	if (!conv)
 		conv = do_proc_uint_conv;
@@ -872,8 +871,7 @@ int proc_dointvec(const struct ctl_table *table, int dir, void *buffer,
 int proc_douintvec(const struct ctl_table *table, int dir, void *buffer,
 		size_t *lenp, loff_t *ppos)
 {
-	return proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_UINT,
-			(union proc_vec_conv){ .uint_conv = do_proc_uint_conv });
+	return proc_douintvec_conv(table, dir, buffer, lenp, ppos, do_proc_uint_conv);
 }
 
 /**
@@ -923,8 +921,8 @@ int proc_dointvec_minmax(const struct ctl_table *table, int dir,
 int proc_douintvec_minmax(const struct ctl_table *table, int dir,
 			  void *buffer, size_t *lenp, loff_t *ppos)
 {
-	return proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_UINT,
-			(union proc_vec_conv){ .uint_conv = do_proc_uint_conv_minmax });
+	return proc_douintvec_conv(table, dir, buffer, lenp, ppos,
+				   do_proc_uint_conv_minmax);
 }
 
 /**
@@ -967,8 +965,7 @@ int proc_dou8vec_minmax(const struct ctl_table *table, int dir,
 		tmp.extra2 = (unsigned int *) &max;
 
 	val = READ_ONCE(*data);
-	res = proc_vec(&tmp, dir, buffer, lenp, ppos, PROC_VEC_UINT,
-		       (union proc_vec_conv){ .uint_conv = do_proc_uint_conv_minmax });
+	res = proc_douintvec_minmax(&tmp, dir, buffer, lenp, ppos);
 	if (res)
 		return res;
 	if (SYSCTL_USER_TO_KERN(dir))

-- 
2.50.1



