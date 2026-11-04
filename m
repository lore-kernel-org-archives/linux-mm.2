Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43DC3606D833
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qfyRP633
Received: by kanga.kvack.org (Postfix)
	id A84256B05B8; Wed,  4 Nov 2026 14:02:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5B826B05B9; Wed,  4 Nov 2026 14:02:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94B306B05BA; Wed,  4 Nov 2026 14:02:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCD36B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:02:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D69734083C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:02:13 +0000 (UTC)
X-FDA: 85398356946.30.4461093
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id E8695A000F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:02:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qfyRP633;
	spf=pass (imf15.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793818931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4EYm736r+cZjS/uMo0fJRYSotCwLKibNfByv7v/nf/0=;
	b=ACbeLlfQPhEPC11457MVzp7etRRxvdM1Hz4z8dju1Yv0aGESWhlYmoQ7uwl/bVsRFHldNZ
	/G6CvDrPCfKEMY3iuyENPpr5DN4CfByL2Rq/9U1f/tdVI8THWEO9wlNgHecA8XCflzuKTG
	r4kZtPF4bwpKr6duGzSO17w4RrWrhc4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793818931;
	b=nP7qkkUW/xNaVtVu0q8Ibtddly3XqFa9fU0NGl0I2M527DrtNF8inFRgqDRQbGX7QCrDcY
	/5rcQQzrKgtOKJa0oE1HUHtgNRdLmoEeqxuN/GrduJIXf0u4jJHF6Tk+v3fHirHHCYTnvC
	ZbjV9bxKUb+u8PnWpTPFrUOYXgNre8U=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qfyRP633;
	spf=pass (imf15.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cd67cc518a6so708801a12.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 11:02:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793818931; cv=none;
        d=google.com; s=arc-20260327;
        b=HNLOVDiyFiCFql4p0LH3WzlL+WhRQU9q2XM7PtW3y9S7s9OWnDvbPWLY566aK6n4Et
         imwYwtbRXAAUqbnQ/u5RU6xQUVAAoo1CJTQeugie2N1439C1nEcvix2AymSnOrinA/eT
         fDBncUHHtOyjhnDG2VbZc+MVaNpyWH29LGrY9kHC49SjJfSKB2Vcxu0OIf1WL3Uu8dIE
         gZYRZM778Y5vmvuSTJbzMNKtAEbUYqwiuoH7Sera8mRydXx+bIpJVD/clOnl0OhwA8Lj
         KEm/M/Xt4NhDmztRfvxkNiIs/mrCmNmoooBAM1HBrunemUlBoIPJ2L7oyovJLkpc8PKj
         kp1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=4EYm736r+cZjS/uMo0fJRYSotCwLKibNfByv7v/nf/0=;
        fh=YxaQX7GTjfBsN7A2Jl+A9yP6mmGOQanoqU6QROKhVaA=;
        b=DicRnlnLhBsG1y495130usR9/63yb+v2krMu+apNn9Tw06QkGRj46Yr4FUU4KVjt8u
         3n5CRZjOMzqa8j3AmhBYt4/rWeXXkOisz5oGGU6+tJc5yoEI6oIogdia8IpulaSLJtTI
         59jhcxb1PX9yHhFIcn16G5kapgv4kTa02/sFL6RhDXdkhYFlFw+8PpZ9qwEeDzn0a8d3
         QE4NhMvu4zBF4509tN4fgfVe/c63PUKQ9qnE6w45DWsyKBmP03GmKxSzG4L/q6SH8kyK
         uJytMsqz+kauWY3RaeU+Gqi4B5TaYiX2rMXqQG+BKiZsJgsDe1iBUnjjp+Jvl3NNhoVg
         2eAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793818931; x=1794423731; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4EYm736r+cZjS/uMo0fJRYSotCwLKibNfByv7v/nf/0=;
        b=qfyRP633rOWhladMyWNiz3/Yqr1eyQ875rCViAKRdwDBZPSKEsTQaF4IVigb7DSgSt
         AyYkWO287A3VarBWlewGT23oBmextbb65pNC7Aem3D4lj1ccCWiPrbx1Jqo1YlPM5Aut
         KmPYdtH9EK8JwdK7RBDOh/j/C2n8BdJK9HAKcTFaYw0YKY7RzjKe1cBJLuhYHA54VYz7
         Lvwu3D35CoTbfCvYcNuzC4pYR/DXxoahHG/aM4m05QN+3Kca4PJn8eOVSkb6huPRTxQt
         evb6xatHWQ5bkJTIjL6AxMDCzwMVqwrAWgs3NXYoPnUe75D+Zh2oz1Balkp8H3AiLmnZ
         2afQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818931; x=1794423731;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4EYm736r+cZjS/uMo0fJRYSotCwLKibNfByv7v/nf/0=;
        b=2QpBdQNtvQQknwOLkW03t/EHDzax9UraHb4J6OpGQrvjmNfHokJvI7kMjpGQuyAIOb
         cANTY2cuy5h5ORCIMXWSTov2f2xIMrGq500DVaJbBWnAOIljCMJT5wZfhn7T56lssENL
         oSkSKRsflKaA65qPhICkg00G5Ft2VPBXTKJSS0grsaf9FcWY2vxeN8zoTEvlImGy8EAj
         4rH3ZPNWJ0zcNHUtGx5E1nXCRtdqWQ6/Jw8VgaW05aFuV2+/lmEqsOfglFvKRLL0Y8fK
         AUaT0D6VmB6YvNk6jWIDAMlesHssGI0lczmq6jpXHChwq1VqrSbWBOC3jJ5UvvuXatJI
         bO6Q==
X-Gm-Message-State: APuU4Z9/sZJNdoWKBdJpsha4Nn+B3sc6bwVcSLil0x4e3mysyWQAWUj5
	DpgSM9GJEWbhqbRi9X8MqGcHauyoGEXj+O2/ARZqO4xPA2QnRpbOLEKL7oWncpsy52Bg52hwFaA
	u/xKFxALM2iefkkOLoR4oQSa4xOBXkXgLO4Mv
X-Gm-Gg: AYBFou3L0SA7FT+cHJ2FCMneKV/M6hl+5TTVzziVpW006hC61dWHSB2trNGEFd/2isI
	TMxXcLdGfnYIZiJF9TGbIl+YeQEqydKhvDJh9llimGIjRxUm6J2Pis9XThDxUaEIZs4L51/NLpV
	CG9k+2fmXgO1Dklxavy9AsE4tSsvTwlWqSHJ05lRDrOHJPgwgIvC3CjA4NFDIrLnGluMR5DWYgz
	s9Ycn5FU5qsl3J87BWHPE7wJ8OmT6YQtNyrKgHPWEbpSI/0MMOE89s2h3vIj10HGoFX0SzYhrFD
	ftLOFosjV+qFHNFT3aO1Rou9KVpSWX+vOCzqIFuijleozU/JxliBbgRRF8ua5ZEJEpVG92cOj7o
	XRvQjvylzEsgGUwtXTXksw9OCBcL6fLqe3lwBDLbSphH2PF32bnqmL/+DPFcHlSs3TKM=
X-Received: by 2002:a17:90a:d887:b0:3a8:6045:5a19 with SMTP id
 98e67ed59e1d1-3ae89777139mr15621477a91.37.1793818930670; Wed, 04 Nov 2026
 11:02:10 -0800 (PST)
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 11:02:09 -0800
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 11:02:09 -0800
From: Henrique Godoy <2dgodoy01227@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 4 Nov 2026 11:02:09 -0800
X-Gm-Features: AclHuK9dvjndj19qJaKgS5zpxYZrJsHXRwZ30MwEI0RDNBGZUI0hkPo86QxSkJw
Message-ID: <CAL1HEBCp9VnGJRiuJ2xkFk7jgjeJpaicS8ZkxR=577U7hKt58Q@mail.gmail.com>
Subject: [PATCH 2/3] tools/mm: do not mistake a full buffer for the end of the file
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E8695A000F
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: qhjxie6jnrohydgjfg5uuxnod9rbd8fx
X-Rspam-User: 
X-HE-Tag: 1793818931-819515
X-HE-Meta: U2FsdGVkX1+L5IsDq1dPiKedbCcnqM+DMlcsv4hyZlUYKUghxLeyENyFr3Yw4XK0Nu5s9Et6gvBtKIlvBqzwABSvP9yyTImRUMvDBdB0h3/JSrQk9OWVOKxftPV6w6BTy4ZWU349qC6Qtb4FlAbsDBaGT2epvsOIsMcxLFJwBOPbiNPnj5hhSJIUUC5E7Z0soUEc0i0+mhjwtu/lWaJYsbLpB6VcEkF7+VYNJu2GyEEsKbUQmx+k0/nH7F34gPDUlbg1+N2EAuNmvt2z/yBfpBAtxC1aFuBPXvj8vr6E1fSgzfA5PN+ptV4Ce9pMvOWPO1aOWmkPlj2okt/kvs1XgrEpwVOEfZBf3XzL36ArlVSDCU5r6HRbBnOuAJkaqh2xnsErxTT/qLeLXc8uCqGL7ww22EQLDBppaNGj/tgFe0Uic+3MsoqR4eSdVlv+xSkI01xBr0iPqIro5AxZ0KWpDQThtt5drLP3sWTTUN+HSK05XmeGt5tbAN1QtmcdJmclWk6KJp0dLziDxu1/YleRiqpSg0KFE7irXvm1BPO+qnIGz6cLCsNmB3vQF6IOCX2aowa3eIvi44G7kslBLlSYxDFeOtESO0gKlwfCR4zqL8T2xa/AUM473qUHIqOKB/vw/cMBAh9Axr9+w31L3frhzqfBdbQsTh8XaNX3Xphdqr3/T4l5cq6IDSwSQXhKEOX9YgGZhuY2BNaIdBbmxEtl8TibrW3GQV966Px0X5rEQo1tIqcBXPCj4CC7YEZrPJaiwovj36oM6CsPxwNsu4piE7JidnRkbnThS2mwyhbc3zdW8FW7jmmWa2KH4YcpaAeTopji6f5YnTMPQcrrpMytkkGeAiSiQDviqanJ/tUUGRX9uofzEaDqyLnqONtnWd9x1TN1pVSihoQ3in2XlBLiaBAxp6mPU4NFiELLENX6WtNPpe1jC2v0eko7L+iHRiJoEkyx51soGYeZhOETdPL
 5ces8wSM
 JxBYvvn7oubOQoGwNrJZ549ixeeu6XrHom/Zz89FcEN/QNZfLCskxA3Y7pLFo4T4pfH7nfgXc74SHsxdqRz79moAcSFJGgcwNGjnRO31nHAT+TmwCRUeyVy8mIZSKLDlZiWUoDtfc5R06Msd1zZEZ5Pq52TV4eQZDp7Q8d0HgzyZTBVpypNCVO2AUVAxjyd3iHpGLtHEFE2I9bdDrnoxXSqL9pfqmCLNu4StPr/ffTkTvFHuy7X8ryiEIKEokh2qS8ctVTiA9LT3l0Je1sqkzPsfshh21zFnpAJ592qtb0PL3K3NaU7IqVCC33efgkl/80Klr7u+mUUfmjS/ozFdRGxDLYp2EmF4MrwC4sNLqioiDsOi0D8zw70wRa3g4NVGTpyeKg1+oR9XsPwcX3OnFaQBwEbxr18IEIanOEq9oNEfnwu5rGTfsPlJgs1sdzFdGRlQPY4mtDjdKQEz8YKZNmXpaz7mECZ3NakJCIX2UQG3L86c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

read_block() returns -1 both at the end of the file and when a single
record does not fit in BUF_SIZE.  main() reads the second case as "no more
records", so a dump carrying a long record is sorted as if the file ended
there and the result is empty:

  $ ./page_owner_sort dump.txt out.txt
  loaded 0

Tell the two cases apart and report the record that does not fit, with the
name of the file, instead of silently returning an empty result.

Co-developed-by: Pierre <pierre@cloudwalk.io>
Signed-off-by: Pierre <pierre@cloudwalk.io>
Signed-off-by: Henrique Godoy <henrique.godoy@cloudwalk.io>
---
 tools/mm/page_owner_sort.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 4c2a4e4..a042bf1 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -140,7 +140,7 @@ int read_block(char *buf, char *ext_buf, int
buf_size, FILE *fin)
 		return -1;
 	}

-	return -1; /* no space left in buf. */
+	return -2; /* no space left in buf */
 }

 static int compare_txt(const void *p1, const void *p2)
@@ -794,7 +794,7 @@ int main(int argc, char **argv)
 {
 	FILE *fin, *fout;
 	char *buf, *ext_buf;
-	int i, count, compare_flag;
+	int i, count, compare_flag, ret = 0;
 	struct stat st;
 	int opt;
 	struct option longopts[] = {
@@ -965,6 +965,12 @@ int main(int argc, char **argv)
 	for ( ; ; ) {
 		int buf_len = read_block(buf, ext_buf, BUF_SIZE, fin);

+		if (buf_len < -1) {
+			fprintf(stderr, "record longer than %d bytes in %s\n",
+				BUF_SIZE, argv[optind]);
+			ret = 1;
+			goto out_free;
+		}
 		if (buf_len < 0)
 			break;
 		if (!add_list(buf, buf_len, ext_buf))
@@ -1050,5 +1056,5 @@ out_pid:
 out_order:
 	regfree(&order_pattern);

-	return 0;
+	return ret;
 }
-- 
2.39.5

