Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 460DAC79FBB
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528816B00A2; Wed,  9 Sep 2026 10:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FFF36B00A3; Wed,  9 Sep 2026 10:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8FB6B00A4; Wed,  9 Sep 2026 10:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F06AE6B00A2
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:54:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F220A0265
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:54:27 +0000 (UTC)
X-FDA: 85194519774.20.0C6CBC7
Received: from mail-qk2-f5.google.com (mail-qk2-f5.google.com [74.125.230.197])
	by imf23.hostedemail.com (Postfix) with ESMTP id 862A4140012
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:54:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GQVjlF8+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.230.197 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788965665;
	b=STJBNoOqVx+SwTKOWYXq6yS0tYY6TaEkx1PG5b1UutdO2WhPeKSfqZb49RsBy66mNEFjJU
	KOO/+22saluNPbofg/hX5lHEIddnQ+rFUQkvwEK5ZhcwJNfJVC3V2GRhcXcW3ziU5okgbp
	ruRqPpOu8PyM3ccQg4kuIhcN1ZXH1rg=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GQVjlF8+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.230.197 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788965665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u+ctEZD06peNSR4eAdlrxlVUiCDE+dJnPzXeAForwRE=;
	b=OzhKaCK+8Q93b7WVeCHXPBO0vCWPVYW31lSgqRTwmoHlQeMOr69Kf3HRzcslaFOqqgajN6
	v/kgoBZPZIh3mNFYMyzJ0OmiVzv05N5LaU5zU/GLBSaltkJCaIp87EMogwxGogXDxjkgPp
	woXziZwaE7hZyZO81gAotOPubv94El8=
Received: by mail-qk2-f5.google.com with SMTP id d75a77b69052e-52ff498cf90so37857761cf.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 07:54:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788965665; cv=none;
        d=google.com; s=arc-20260327;
        b=M/c1VegN1zL/oJ1X0heojA8Pgv9gf82PYOHpnaM+OIOR9B7Psm+IoDJ0scOzrDtYPT
         byFhIGKsGBeNgP3oOctfYzFmiWi8YEa1smQ+q8ihGbVwVy1gYQD2dP8BSgxDtuTA6NUt
         Yw6daq4XRXSjfjY++B73dcirXPO2h7aD1x2r8hiM0tyS3naqpQ/+CE1hbIbzBmeO4+Y0
         MGY39WfwK5Di/nY82INlm4QRQQ+20z7YzlwAB197TIFjIn+o51Nc7bRhomroEa/DrPmC
         mopcSlaqAM6ikV80TfYH5pWqqyWkwPUT+5IS6py2uRN5xaM/2QJtM6PzVMsGhbixqBzp
         P+gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=u+ctEZD06peNSR4eAdlrxlVUiCDE+dJnPzXeAForwRE=;
        fh=H5LqK+i9mUx0MPcQrNYc18W4YgzUU1GitnJGoOZE2Bg=;
        b=eZo8lNgQW4UhR2C//WEMtmNeFfAxIGBqVUu8AU5kpzGPgRf/+HAftgvcP8lbTKPoFJ
         /sEV/LJVvQicVVYpRrdjM9I6ZSqu7Y76++88+2yB4bWsf93MW3kAJDUtbAF3GDlojgY/
         tug8AD/bxF5v4a+M6PoCPpqnYYdvHNyYiMKE4HX8mzw6JUzSSV7Uq26vtR4yo+r2MHt9
         0tv9OQCXAn9hTtze8AEzdrGV8ffIPClGJzWyuKIfNgbxaIPrQKtKnXj2WRz25L8SUj+5
         btJrK0kvoK0X/tssZC4qb5w0dFvY2ARmXPU1tJgPMp0xuTDPc1MrC3biu2wEaVQMXwjz
         TeIQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788965665; x=1789570465; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u+ctEZD06peNSR4eAdlrxlVUiCDE+dJnPzXeAForwRE=;
        b=GQVjlF8+UkgeB8NkWnssxBo8XOa9/9x0ZphS3EhslsVB6oHlEVXcTlv+Bx0LSMegT2
         sELTlYCcV1Hx5VzHmp2CAcLKyUsu7hgm9FPZIdhovlriJbGb7+xFU1JMCPAbdZgAVYFs
         OYDyJucNsfBkVfTI9bE4a6cMg9SsSB+uA+5nsT+guvKna7eKYGhoZMo+2XERtMfrp6cT
         YBYMOYlRJvwvhqNQRD3jCar/bjIwpGGtYNqptHkxhqj3xPV+Avwu6kwV5ER3CF/7sU+u
         Uu+XdkMnNShZVPNT5hxs9kz7Irsn6wUr8WsdB0yV63eoNXAZhCTQhCX1eYhUZH2fF1Q6
         kEPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788965665; x=1789570465;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u+ctEZD06peNSR4eAdlrxlVUiCDE+dJnPzXeAForwRE=;
        b=s4lx5LVaHbXnM2s34EDaHOWsZkymP3DQ3aFOHUs9paNOSx1iEUJkIiezaFk6CHyfOb
         JnkwjeHyEGR22POgy4fgoqDt8hMll8gBfYmUozkqR5i78nnjopyBslqu01cw9jOajVjw
         3zSQEAGd82uD6AxZnh3EG7CDUxJ6MlqJYT3eh2Xk9Hu9r5EfABtlZqoUjiLQYho/RJbO
         MlBuJ94ZTr6NstVsbF7snpxS7FxZoPeZwqzD2CrhGfJCF5BWGgYSXmlqZpCQwjb+ayd/
         tTNyeT3i/Sku6p9myfHIdlC0nPREINTW8fkwdJVtC3ieTrWn5L5f0W9HeTkLt8BNURY7
         aw/w==
X-Forwarded-Encrypted: i=1; AKwUvByuqhL3NULYPe8T/ZcM+r+QoPARNk76BvaDt9buN2xi2Vwzfve7xnUlW4Ntp53oQ5WjIMDQcwluFg==@kvack.org
X-Gm-Message-State: AFuF++nvsFE0vRKIhVL/oxncrfVmUZ38+aAkdgfnuKaUxUVVDpDXlFmE
	ze/cYwpG3sPxwJ2o4b1F/nYgvGeBZLk/tvpm9D6qNq7AJp/BWGHS9WIZULozZBzZSfVKpkB4AtB
	fKhFX3tIvoxBCK5y7U7xaAdvR/9NhRvw=
X-Gm-Gg: AYBFou2zsPv7Ua1K6lUH552z35t60N2S3Ni/VKZbifVjR6IirKjkgaguGx2X07AUlGk
	U5C033byVUWaD4od8kAUJMT6Yd8f9A2Cz2uCegk2JID4d5g9ipL9YZL+cVaZtGqaqobnstjpx8l
	7NXZpiEmjux914EHrraA7ZNoh1QTuHDgSU5dBaIMQCp3cgTyUEJt5jDxvO5UthheAQLjEUA2Sdg
	C6S3tUJTqFmtL4mEiK2lm6pCihhz+0yIuuOcn1WV+InyU40FuZC7n4puQp05UBwXl5jD+UTcHWm
	7UDuRK29YONkWUoP4u5wW5Gp4HF3sMUedooou9dpgHNFsALYUsOuBA==
X-Received: by 2002:a05:6214:4a05:b0:910:4874:66e5 with SMTP id
 6a1803df08f44-910d104bebfmr25031596d6.21.1788965659974; Wed, 09 Sep 2026
 07:54:19 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 07:54:19 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 07:54:19 -0700
MIME-Version: 1.0
From: Tianyi Chen <diannaaav@gmail.com>
In-Reply-To: <CACGbirSdR30=YTPQGN-=202jZqiF8gBSewhq+K_fTSNpq=DMhQ@mail.gmail.com>
References: <CACGbirSdR30=YTPQGN-=202jZqiF8gBSewhq+K_fTSNpq=DMhQ@mail.gmail.com>
Date: Wed, 9 Sep 2026 07:54:19 -0700
X-Gm-Features: AcwNN1UNxzL5WjMgcuf3-e2gvm86CJeujKJF0gUL8RZhHjcliTNAwngLs5rsPew
Message-ID: <CACGbirR9PNt4uhqJFATsOWnwmsNb-v8zau-Rb+9Q5SZmY-=Vug@mail.gmail.com>
Subject: [PATCH v3 RESEND 1/2] selftests/mm: Reject invalid test selections
 before running tests
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Joel Savitz <jsavitz@redhat.com>, 
	Tianyi Chen <diannaaav@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 862A4140012
X-Stat-Signature: 795t1swfskc8t9tkdx14uf7ty3jpqcqu
X-Rspam-User: 
X-HE-Tag: 1788965665-449972
X-HE-Meta: U2FsdGVkX18D7HxB/v2xizy5wmiJWg6mmy0Y0XV67OzpnSwcqdGxfqPyzkk12DJfaTXCxoFnGH02TTB7JxgUkaQ0JCYWwqSXaGOu+S6Qg2MLt8p1n7pObxlxxmoyVh+9s+Fkc3lQXSqsbrJO1OUThmCv8Fx9LPpNPGGdPDjd4THvuysfe26z16XbQ84dpmLM44kYWrpVL2tdsm9QqhqLd8F8WKKF4BNCr6NMkWFJAVW0EtFDSY9MUy8Xp2gssp4bxCWqLWl1vtLabyXvzKKMHsQBa4s02iWNdKj9sP2mUW60TotwIAdZ42RsJqOV0JuDEqlkmumQpcIzOBvsqH2rVv1YIQm1aT9H3Cz9b7hTIkaPusdEqIQIE/Qiv3/szd4PXjGWHmjOBYmyeTx0Fl6blKQ9SiVyChkVyVErCjBzWv0GtvY85TFqqC863MoFMfcgx6P6OjAkLyPMA7cGFywnDihaYELlENGy+cZTnykYyBppyDKFaqLKBjrp5c0AWtrDZ2C7VkCQEjrn97apWeoE6FGgF10ZauvRnusKUEeHtRfY+cDnTxgXscO9dglZpkDqtFdJZtuOEw9sAprN9kANIP2S1qzGka24+5BPx/bRdbcTqwrOjh/b5l3NZPk+C1fOBFrO4UnQ2EV6AzRQ7gVwHHj+9FpqAgLaNd7gSwEuJsWJFJW8UIVjrUqliDVKNZedOE2qXCIuQnREcfYfeqaQPllVAzLWL1SFcDLwPTxgSHGUAYYO8WXy76AwJhN49DefYEumr96QEfudFLce3T1Lx2HL3sdFVrMpzL7hfH/GfS+mzK0gk8fxPCuPLzuC1GVORaseAjalWHUHUJS7eQDUt4iby1q80l+7MMS/lVPrRMVPfgQqubQQJdcnzWh/i+4L1alIPzG33pj0BVDjWFUG3y3adAftyrTDTbVrczsiOJ5vwNhDXrl7XoXMzHj2KXbDh4me0eVGENYwrIDbWAM
 vekLPCck
 c2NmLeijdeulxhR45kXNwtbHJXYTDG+fxuiE85kU50Y14LT4iN7vm6q86hXfrWi/MWQ/vWlG6PPZDYjv/WoVZTjK6YBTWkOhbOoivwYZYLI3pJvVgWs/zHRwcnhuPU07LcZssoQQF2eXBk1KDRk+jy+szY992Lkr5qmSS1Ke402EbqWMXqkdC5w9bzykOCvAyqnWG2RJ8clEGb+9CI1jxTNrq4J3JEz54E56ddpP7zLsq6WL9vTvd57JBdy5vGo7shICO3PLwWD9+NfBwe9YkyzButyzpDBf1tus2ms35rAI5Et9d2ijpg4JAmQGFW0Tj1CDezbIj0HH66OvSClVlPjNF00nY3acrLhU9KsSVfModfOZAwIQyECoPuq58Mev57HPBOroIMRLk64AdhqfwBXTTZAR6yj4TrlsgRVJXXrKoYS+mZA85VW7rAur0o2xxGspizRoZaCCV0Ss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tianyi Chen <hi@tychen.cc>
Date: Tue, 08 Sep 2026 11:21:21 +0800

getopts reports unknown options and missing arguments, but run_vmtests.sh
ignores its error result and continues with test setup. An empty -t
argument also falls back to the default selection, while unknown category
names can silently select no tests and still reach setup code.

Exit on getopts errors and validate category names against the existing
list in usage() before any test setup. Reject empty and whitespace-only
selections, and normalize category separators so validation and execution
agree. Initialize the default selection before parsing options so only -t
changes the selection.

Fixes: 85463321e726 ("selftests/vm: enable running select groups of tests")
Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/selftests/mm/run_vmtests.sh | 26 +++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh
b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384e..9e62ab4c6775 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -96,26 +96,44 @@ separated by spaces:

 example: ./run_vmtests.sh -t "hmm mmap ksm"
 EOF
-	exit 0
 }

 RUN_ALL=false
 RUN_DESTRUCTIVE=false
 TAP_PREFIX="# "

+VM_SELFTEST_ITEMS="default"
+
 while getopts "aht:nd" OPT; do
 	case ${OPT} in
 		"a") RUN_ALL=true ;;
-		"h") usage ;;
+		"h") usage; exit 0 ;;
 		"t") VM_SELFTEST_ITEMS=${OPTARG} ;;
 		"n") TAP_PREFIX= ;;
 		"d") RUN_DESTRUCTIVE=true ;;
+		"?") exit 1 ;;
 	esac
 done
 shift $((OPTIND -1))

-# default behavior: run all tests
-VM_SELFTEST_ITEMS=${VM_SELFTEST_ITEMS:-default}
+# Normalize whitespace so validation and test_selected() use the same names.
+read -r -a selected_categories <<< "${VM_SELFTEST_ITEMS//$'\n'/ }"
+VM_SELFTEST_ITEMS="${selected_categories[*]}"
+if [ -z "$VM_SELFTEST_ITEMS" ]; then
+	echo "No test categories specified" >&2
+	exit 1
+fi
+
+if [ "$VM_SELFTEST_ITEMS" != "default" ]; then
+	# Keep the documented category list as the source of valid names.
+	valid_categories=$(usage | sed -n 's/^- //p')
+	for category in "${selected_categories[@]}"; do
+		if ! grep -Fxq -- "$category" <<< "$valid_categories"; then
+			echo "Unknown test category: $category" >&2
+			exit 1
+		fi
+	done
+fi

 test_selected() {
 	if [ "$VM_SELFTEST_ITEMS" == "default" ]; then

