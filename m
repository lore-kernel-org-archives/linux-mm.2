Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E16DC606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=btqTQ2pf
Received: by kanga.kvack.org (Postfix)
	id 0CF086B05B4; Mon, 26 Oct 2026 07:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6EB6B05BC; Mon, 26 Oct 2026 07:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7A76B05BD; Mon, 26 Oct 2026 07:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4B796B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:27:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 489DF1A0700
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:27:41 +0000 (UTC)
X-FDA: 85364552322.13.FB49193
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 81054180002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:27:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=btqTQ2pf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793014059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pTjWS3+ZRB465NndO+clOkv+MUj94hyH9IhI9lFDqUc=;
	b=mkvnpX2bz2avHK+2VnSzNUy9muGcpRBxT1eVHiCrC3sMTCud9bbRyYe3SlTo8O8EUdn9Cv
	7fOiNOaCma0LGpLad0R7qaol97RCD2MNpws0kpwK3OQ02O7b1mkZj1R5pTFVnKMqwQLANr
	cHofHcnvhT9KULh11ap4RA054d5PLZM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=btqTQ2pf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793014059;
	b=Oh19I709Sl45nwJKB4PNpfKfQlGV0Nbj9A13elOFeo8x5vWxXMuVk4ZdDyxoiXvKRf6+wR
	fu1cQ62RnvxWR5cpHLnzagoRkO4wcrQPPqnfmSgCxjcfs3MLYLwxKPrwNtnFkDALMgN4T7
	bVfMRw6wWpZ3pguD7B1MaN5EM2P3zuE=
Received: by mail-pj2-f3.google.com with SMTP id 98e67ed59e1d1-3adc0ac3566so501499a91.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793014058; x=1793618858; darn=kvack.org;
        h=references:in-reply-to:message-id:date:content-transfer-encoding
         :content-type:mime-version:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pTjWS3+ZRB465NndO+clOkv+MUj94hyH9IhI9lFDqUc=;
        b=btqTQ2pfk5AuyLlUbQHUtWyJX3/WcgL6qxC/wTnSmsRBADRfFJIrHXsRlXSakfEsew
         xxASFn9MLaC1nTLTuzSNl6PHqhSue4z7KIEok2neMqNHhxKSjguxyCfodi5uVTWT55R0
         y4bohF45/aj+q3rDBElfUiIRsMnTHRk2nmAFc7YICqMP/hpexCU0x1RCz2JUrLBfn3Ni
         i/u0EEk5gh5v5Kj3FcVCxFuhtHrcppnwmgPkgAztl//sXjnynX+vKO7VU8FsTEa/ZHR/
         QD0m8mv1qTccC2McAslAr4xgSJraghAaxkjg7wUv9adQKoSyXDuUIgSa9dAECmP7adk6
         PhLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793014058; x=1793618858;
        h=references:in-reply-to:message-id:date:content-transfer-encoding
         :content-type:mime-version:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pTjWS3+ZRB465NndO+clOkv+MUj94hyH9IhI9lFDqUc=;
        b=ufHT3cwX/sqTdwkFwGTIQPwqXQvQSeBD0kBQcgbN8OS3DTONJE3lX2vSjNKnwjh2Jo
         2PCpfnwbLy/h8qypuaIMGlJDmQaYCsPgQIqK3DSd5wp4HoTXd6TvsfCgRGZsEKmP4idx
         fuw0Zg63HA5hZp1oldxCamIcezruLb9XLBLrLC84z2RVa986CWeLUsZzU08XuTr3zxhE
         aKkcX7HlWiDmnwwowm8pUXkqdUvXCclMV9+h4cEqjz/EXlKjqnpUMCusU1SGXvRhXuPx
         vTDeaSyUP9SxKnHa6dKq5m7nmkYT1LEaYg/fOe5QWgiJYfXnag/lpNf6TDWpONgDQswY
         kNwQ==
X-Forwarded-Encrypted: i=1; AKwUvBzHr6nLYOwKw5M7H3rwrJf+eyfJr2UhRoiHdPi0/hsmw15Z3XXs+Qn35zwXCHxH2MnUcATUXFqUdg==@kvack.org
X-Gm-Message-State: AFq9FYImwbXw2e7GNrdET9o2XdtueWbD6CEhv+t+bkgnCRd8upzO/del
	crcFLL9XuiNYAelcvyg+i1y6iBF9WFgpXGWEdEg1GL1TBQ3x3n84kg+EnyseValx+s3LXg==
X-Gm-Gg: AYBFou06mBbEoT45SSKGm3O4BSJxiah/RGzeXAbQV5r5Scq2uzGNwk+N4otJEjKC70v
	7Dg4xCcktKuGH0o6UBW2BqstH0px/U9ZMBhYizmVV+PYfDPGl5SfVCdHV5YqXMw1m925HUaxrpB
	dBLSqPYfs3H1Ei9goLOqb5kz44GSGpxT0pwxNltJBCHa6ZfXxe0q2fd+GSM5jGG8Q1EJtdB3R9T
	Os8kNR91k5cDn3K4JIRQtlG3HvgK9ULWZltnC9fCZQij4tTL8fAatBTVXXgusXO2bMvkD2a/aWu
	RGGO4LEutqeFmRl39Q+1r/eNw7pyqGChPKMdLpfQnm1eu2k6o2VbyYvyqaTTopQ8AQ7+q8lokG+
	nC4cpiPCcaA3oIvXimXTKWab3R5GLfsDII9VaGdKzq6GW/k+M1PxXP8BA0kGV7+H0futOVtApFt
	I/th28vfdj9b1huJnQqvSL1C20vPB/ZitjSYjMVsAYwVposczGCdMhprZ+rw9ezPS24UKYqPafV
	1Win9P3I+FToJpiPvw8ca1RSUUNHw3fr2InkR0yE+rtg3UcB1I5/KG0Xd1L08lcb6rmGjRICJj5
	RLReUQzJGlKuLST99HOSfmMHS1lvLfrE0/dFXCnuiEbXjUSE6IPeDg==
X-Received: by 2002:a17:90b:2745:b0:3ab:c674:cad1 with SMTP id 98e67ed59e1d1-3adeafd682bmr5302506a91.50.1793014058211;
        Mon, 26 Oct 2026 04:27:38 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ccc20fe8sm1495402a12.5.2026.10.26.04.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:27:37 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Manuel Ebner <manuelebnerli@mailbox.org>,
 damon@lists.linux.dev,
 linux-mm@kvack.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] Docs/mm/damon/monitoring_intervals_tuning_example: fix grammar and typos
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 26 Oct 2026 22:14:40 +1100
Message-ID: <179301327249.2.2968995103662294177.damon-docs-grammar-8@gmail.com>
In-Reply-To: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
References: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
X-Rspamd-Queue-Id: 81054180002
X-Stat-Signature: rzqcfwy7yenm3r5bwda4comqpm5ffdxt
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793014059-944971
X-HE-Meta: U2FsdGVkX19JxatmGWbzfK4HHj+iy+VRFSQa1XTQcTlr5ZT7CRbaWnsgAJUDbrYbA5aYO6RYTelaw/gDAwzv2vqAxlIAgdW3BJtOofW2Qs87P82prU+qgs26WdJzARNh/6aM4Ql0BTSztwDd/CE1BDWs6Dvo1iYXFWTsPpnuGjCJSbh2s9YafoGE/KTGgHn1KShvrUjndHMzbc+8ESA/sEGoJ9amKWTgleq+o2qfAynEmDHSk9gDGCN7uca0M7hT68r6EVFd8ZUSMGGFN/LgTxB2gdBbfYALdIYn2swVd5lWIV61hBYt1mVomrXnNEAwKix0qOkPv56hTSWGZazgIO9CcHVYWp3uG9+a6b/Q2oNPRDjBj6goYdoMWSHZIoiFoHn4SV9ikVpWEOspukndOJuYQw1B8tCYAga8yWhjHGhHQ41Aw0yXhd+r0Kd+02idLfpMgPzXdykLdKc9MGmpAVlpUySU2IMqCPBHaa7HqOISnyyLPCbPPSwLdd+1qim+VK/1jZixTL6Pl2h3EpNtUi8/Z8JaBr7swoEGtG6UCmeuXeozcRKfdQG9UjqsqSxYWxuh3T/GhGArWxAI1My2baecckuHC60Ns1Zqrjv4u8fPQPyr58nTMcg1rfgsTAz4vGkto845C8qTN8w7yxCmlkdsJpC3BVuTqDUmq/Zdi8FpYwNn/juCfZF+tLlZ+qf7oNZMCiLC9+Iid+wOWwMX2PoyrYjp4eSyMWVY7uM5yRNm7Z6nCFWP2eenC5cjuw6/N2ZymUHf06w7GogR8qNf15Uy3U9ihIpRPuO9C0FlYJImuzZ/mJTNNSq3JFvgnXnWA+cSKKDkAbbzYcfA6pOl8UX+vCBZ/DuG8po+5mMVDVeibnvlcV7y+SthnT1FPyUF0IiZJ3QT2MXXOnmf2fuVH3TywBLczjbQkfe9WublDfQzWbs1aznw2UIW+65rIVqDC7DFoan3Qx4UhS9Ixzj
 143TqzGj
 ImhBVbAPC5HU74w0YA1xPI1WG3RsCZ4lt+k3LC1tpsqwEwObsZPBc7GXJbscldIA/FMMJ4DRTLARL+dWjzZUQsaOD//Epcgzg2ejBlGGtCX1Fklf/gKoexjiPTljKONxLRP0BCJMtVQJHbVlIFj8SUca08WRqqoaBuOQbRIHWw/savXlODplyW8Fm+dFPslyBxlgXRa9EgXTE9rlUH51/t6jtiabDQ1Kw/VIV7PPM++Ph0mPNudkt5nVzT564wWC6RQUStPu+QSuxAGsfMuiHEorVJ6VRTG5JMdAL/A9KGuw3hSYz2fKjC8nrymqTxHNSiLE2I35PewVWjOtjZVW4uopY5h/BAaoSETrjlR/l0CitkK5sz+/Qz85xR59oM5fJOPHGUAfJ/0ppb3WbP/30g0luPxVyVqpURyjOixxr2ump/xhWunh74VmuiKiUZx0VrLG2os4YBXjLcRiRGFF/LSwloEPzmW9G8IjWguEArp1SMK+fsIAlQokKxqXGgyEuWVaxV7Tsw/XoO6971ePr55vybFHy3j/tugETNnen8M047WYvE8rFkXHToW3V1IG32Gl0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fix a few typos, including "Moniting" in the title, and some grammar in
the interval tuning example.

"starts looking degrading" should be "start looking degraded for", as I
think the sentence means the cold region detection starts to look worse.
Rewrap where the lines got too long.

Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
 .../monitoring_intervals_tuning_example.rst   | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/mm/damon/monitoring_intervals_tuning_example.rst b/Documentation/mm/damon/monitoring_intervals_tuning_example.rst
index 7207cbed591f..367b031ce55a 100644
--- a/Documentation/mm/damon/monitoring_intervals_tuning_example.rst
+++ b/Documentation/mm/damon/monitoring_intervals_tuning_example.rst
@@ -1,8 +1,8 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-=================================================
-DAMON Moniting Interval Parameters Tuning Example
-=================================================
+===================================================
+DAMON Monitoring Interval Parameters Tuning Example
+===================================================
 
 DAMON's monitoring parameters need tuning based on given workload and the
 monitoring purpose.  There is a :ref:`tuning guide
@@ -38,7 +38,7 @@ access-hotness of a region.  It is calculated as a weighted sum of the access
 frequency and the age of the region.  If the access frequency is 0 %, the
 temperature is multiplied by minus one.  That is, if a region is not accessed,
 it gets minus temperature and it gets lower as not accessed for longer time.
-The sorting is in temperature-ascendint order, so the region at the top of the
+The sorting is in temperature-ascending order, so the region at the top of the
 list is the coldest, and the one at the bottom is the hottest one. ::
 
     # damo report access --sort_regions_by temperature
@@ -56,7 +56,7 @@ list is the coldest, and the one at the bottom is the hottest one. ::
     total size: 62.000 GiB
 
 The list shows not seemingly hot regions, and only minimum access pattern
-diversity.  Every region has zero access frequency.  The number of region is
+diversity.  Every region has zero access frequency.  The number of regions is
 10, which is the default ``min_nr_regions value``.  Size of each region is also
 nearly identical.  We can suspect this is because “adaptive regions adjustment”
 mechanism was not well working.  As the guide suggested, we can get relative
@@ -91,7 +91,7 @@ aggregation interval.
 100ms/2s intervals: Starts Showing Small Hot Regions
 ====================================================
 
-Following the guide, increase the interval 20 times (100 milliseocnds and 2
+Following the guide, increase the interval 20 times (100 milliseconds and 2
 seconds for sampling and aggregation intervals, respectively). ::
 
     # damo start -s 100ms -a 2s
@@ -129,17 +129,17 @@ seconds for sampling and aggregation intervals, respectively). ::
     [50,400,010,000, 59,720,011,000)   4.000 KiB  |*                   |
     total size: 62.000 GiB
 
-DAMON found two distinct 4 KiB regions that pretty hot.  The regions are also
-well aged.  The hottest 4 KiB region was keeping the access frequency for about
-8 minutes, and the coldest region was keeping no access for about 7 minutes.
-The distribution on the histogram also looks like having a pattern.
+DAMON found two distinct 4 KiB regions that are pretty hot.  The regions are
+also well aged.  The hottest 4 KiB region was keeping the access frequency for
+about 8 minutes, and the coldest region was keeping no access for about 7
+minutes.  The distribution on the histogram also looks like having a pattern.
 
 Especially, the finding of the 4 KiB regions among the 62 GiB total memory
 shows DAMON’s adaptive regions adjustment is working as designed.
 
 Still the number of regions is close to the ``min_nr_regions``, and sizes of
 cold regions are similar, though.  Apparently it is improved, but it still has
-rooms to improve.
+room to improve.
 
 400ms/8s intervals: Pretty Improved Results
 ===========================================
@@ -196,8 +196,8 @@ good enough to make some meaningful memory management efficiency changes.
 =================================
 
 Further double the intervals (800 milliseconds and 16 seconds for sampling
-and aggregation intervals, respectively).  The results is more improved for the
-hot regions detection, but starts looking degrading cold regions detection. ::
+and aggregation intervals, respectively).  The results are more improved for the
+hot regions detection, but start looking degraded for cold regions detection. ::
 
     # damo start -s 800ms -a 16s
     # sleep 600
@@ -243,5 +243,5 @@ Conclusion
 ==========
 
 With the above experimental tuning results, we can conclude the theory and the
-guide makes sense to at least this workload, and could be applied to similar
+guide make sense to at least this workload, and could be applied to similar
 cases.

