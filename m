Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A58C6CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 15:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C1638E0014; Mon, 17 Nov 2025 10:40:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0991C8E0002; Mon, 17 Nov 2025 10:40:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0968E0014; Mon, 17 Nov 2025 10:40:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAFAE8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:40:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 846E01399B1
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:40:45 +0000 (UTC)
X-FDA: 84120511650.03.E942097
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id B779614000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:40:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SZQ0fiud;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763394043; a=rsa-sha256;
	cv=none;
	b=iiUCN7QG3KcZ383V+g+gVb8BwWdIG5QJk7H+9NcOUX3ueGjduW/UGtwO9thXN8t2K5TA0i
	ytYxZWgufJWb+Nh1FnIz4PsCFbUCqTGMUvcNA4LRQLAERjPqfJSttjdnlwiBlJ9fVvTjMk
	t5kraZ/Aeo/HUAXa+eM0sDAHEzQPuI4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SZQ0fiud;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763394043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VsdVFJLfCqjp7kPVWfOamCJg5ZBrJZ4jVC22PdP5X6U=;
	b=eV/CpEwEjG9NMYppG7PaSjKfL2RrsofmTh3ZjcgqeSpJj4Y0Jf4qp8mDcN46STjCzNC3ob
	1bePslPyUqG14apR2iq4LBYlq66qu9mJ6RNOgql58SL9cuGAxUeSluLFKL8qGoRQgd1Jdn
	4Pe+ikkDmzqX4bKeJ/nj5FgSDoUEsyM=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2981f9ce15cso56486755ad.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 07:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763394042; x=1763998842; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VsdVFJLfCqjp7kPVWfOamCJg5ZBrJZ4jVC22PdP5X6U=;
        b=SZQ0fiudNMIw6D92LcClUqXIqCaHT7yiDKEvuVxjzTs8e67jB4lYusBbx6oohaE+lP
         YQt88HBFTmv5MxF5EoK0zacbmOWspGXRNnUyjbZsaEPxs5fZryZhOC8b5zSWaFGMQtLt
         yw1vGDwtav/TbsQUPwotJVx/j3S0vatToVaezzEu+5TQeoxPs1Q+/fgRVs4B4SDlygFh
         FVCYUUN4nBu/MDBtbPi7lHRL4BBnG1POsyyZ0UnW7VRiTDKcsrCVtFUke4kAVZiE0sSc
         KgNYTSR3+xS9RJFowtLh6A/fLwR8t9lJQQbcka46GgUqQt0mWGvvjeKznDumObhUvPrC
         amwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763394042; x=1763998842;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VsdVFJLfCqjp7kPVWfOamCJg5ZBrJZ4jVC22PdP5X6U=;
        b=maMuVjjp2iob5M+/sTAeuxnhG1mEWfKq1TfSJ3VH3rIDA+UDzdcOMFjg2Vux0cdfR5
         3DtTKU6eP7+c8YzHZLtI1tsPUIqkB3gLoEYhhYtpX89l5vS+jnroDg2ZHB+3t3WRsAiU
         /v0eTth15wYUUWRnyOOtpzKc3r+R8lQ+4ZNH3C6BV1zGY6vvfXZ8tBaGEQZdi8bJ14jy
         10sL7zYYAx6E4hUx2rRhIV2TtRU+Slj4gdUmeXEdsihgfnSpspJkFH+uJe0cykoRj+t4
         3/Gb2INrQP2JPl/EE3pH8x2/mcd3gfnHoPPt7otOvG9IV8L3xw1S+3OGRfcjFUV+OBcA
         j0/Q==
X-Gm-Message-State: AOJu0YzZYyq6ucIubMoqXRshPn2iG/K3iCf33c9Di1kZ/j6UqSqR/laL
	XYwEtk/deUYbpELWCgeiKeVS2DwpDYPA5nvcNSnwlGf21iibwQas8ctRVq5xXsvF
X-Gm-Gg: ASbGncvPckg6RvVpa06NBKP9zpbRRJzNBFPVmKB77ah6lAlwRcxOVyx1dDfxNYXy1eQ
	x6jGoYvCYdFV13R54I9XFnbZBM5yKRXWgDo3Ve8WH52/nT+5Cn3ud47PAi/5XrfnUvP4hRC/DfE
	lvgA/qmim09Rt2WPJk/jl4Pk7L+3HB1l5v10ZYavG3oWKZv0katiGHy/K5Lrbb2wdI+HVJNH9hm
	J/ID2FjTohVMLECf13Az8/uOnwNqtpPqC3S0lcWrOPADxACkGx+UmiUEt7jJCSkev77MhJH0o0o
	zFjro+jDS1CQh3PTNKNkq50035PGC8DNb2Zq11x1/Bx4JcfwQoWMsInNOx0KGNIH7+VCJCS5H+8
	CTHDes+Ujkj/UU5ZFT31NLLrLsQ58QS8VTu3GRFjjwj2YUCR7O2wDPW6rfrNsZD1cAPbf
X-Google-Smtp-Source: AGHT+IFPNgEbJ6B+3n4tiLjzMnfUNJLrtDcPSjekE1ddOjVG2ZTd3guzZRLo4qp9zp+ewSn9GFrwfA==
X-Received: by 2002:a17:903:384c:b0:298:68e:4057 with SMTP id d9443c01a7336-2986a759838mr162730605ad.59.1763394041776;
        Mon, 17 Nov 2025 07:40:41 -0800 (PST)
Received: from gmail.com ([117.147.72.154])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-299daf12fe9sm51167715ad.74.2025.11.17.07.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 07:40:41 -0800 (PST)
From: Peng Li <peng8420.li@gmail.com>
X-Google-Original-From: Peng Li
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: david@redhat.com,
	osalvador@suse.de,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	Peng Li <peng8420.li@gmail.com>,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH v3 1/2] selftests/mm: gup_test: stop testing FOLL_TOUCH
Date: Mon, 17 Nov 2025 23:40:11 +0800
Message-ID: <20251117154012.197499-1-peng8420.li@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B779614000A
X-Stat-Signature: 9mkb1r9sypwhej97rdhnuar34fmcbqu7
X-Rspam-User: 
X-HE-Tag: 1763394043-278379
X-HE-Meta: U2FsdGVkX19JtmS5qdchA5w+n60zqUUUc6wN/VJvuMZP7SLzJrl2EpMsTyGUQF+XFDVDs5fMpntq1CwN21UgsKy57xKnENmPCssELd1HCgkMsQ8+239fjIXtviyH2cZ6Z/oznMqmVm3Q/vHC5zxH2WkqNnttqevS3E0Q05ou52sCK7/IN0rKNy4brlvveHdYXJw96ReQOMLBZ9wT2+zWplhxythfLSJz7VrBEXUEsu4p/BlyBje7/1PEC4W4VZZmnvASwRgIml54p1ZlLzx20xBvU8YMWZR6Arf2lnBmjynHAl2HEp0m5snQOt5mWV415hxzs/NJeCgxBo2yQjIdrCb//fy+l1L2PGAv3SRse2RV9m1p+wrv6PdFgIJ4BV9Ot7GVj+yWF3oRGWgLmDuPaCMLwTUkCw8OFooDS4bG0JjqEeRAvJTAmDiEmcKrwqDGvkYcmchirHwbGlxWFGSL3WT4pKxr9+c9Dg1wvegGdSqHxGy7KRdDg4dOWGX3sSBaw+WKdawthmy0cPU5aFzHxWtZozdOLYVCDSkYzHKjREM6EpxWcfxh2M2ZdAPYh52lNEGKZh86iFADEP6LwAB3b4mTpg4MlSzKVlAz47ByFZN08hGIMh0lMpnW48AhrpW+O2b1uJHwW4iq0JKFkLTdpExQTBTSSgTff8anekFj/APKGCeRiGmOSErzvKxlS1CD/KkEUSCW5rPVrSuhDTFNGpyBo5YpRk1conGx56eqCXLizowzZ7BS6Wmg1czRV24XttDGMUxq8cJkYKcFjKv1FmEaGHMvmzqjzul2GdIm2SMMlCg3CG61lcYqnB3K5Z4gzQRurlRMYoW4Cmy375RBxOa89FIbu/TDNfWitoVpHFFHrZGTzGMFklrsAEAq2N62SYLA+MaHxUK828Gh3nUPNQAmgbOmrP07JeukkcTJAc7KwkUoskzKwJOMdV4xKOfHPJd4/AiaQHpAwsU2dt0
 uZVy4NZq
 sd1kK6MiPsmv6fx0Ts4q3jUHanj1I41L6RBrG1vLx3oMSrjHKEa8nwHpZxGGCOpDEbHAIVSxkHpilmaR+M0lnbXAKf7WD6trcUKQaChta8dDEzWOOqZSO+PGvIRsY0D0muDQEnOLgcAZWnoyFdb5dyBEAcoz0uKI1eTu3cflAabywetgF1lkAP8wWdd66HT5mCZP5UWFQdC3QY7L+JFaimcw/tzFzyy36LkUpDsqFlQwDpTpxr/2P4TPXwbBKkjqUz9eSA9x0A1t/z4DkkfruUaHna8Tcfku0U/oPP6g3WsOkgoVkwxWfSxrWsmk+TnR8ywgM+UGPGDhWy8FkkXqBpzk+hGUWRa+RlF38EAl9vEbeClj0KC4Hfk/9XptS3Lnan6ut5aC90/TUWTQaqRzLD2zN2PTdpPDXBRQ/zs+qYi8+yVzRG6YxwX6W2Bt1p0chKb/ynwYDk+k39trPyk//SdDtlLTY9RKgICyIHvBR0WYTeTj/AADIBnlQoDoxJXIcGWCnTL8kTu6ZOwglnJJt/9MDLhO71ElUkXAGuwFhsFR1hHm2wGAUOZJKa+flFSSeXSVP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Peng Li <peng8420.li@gmail.com>

commit 0f20bba1688b ("mm/gup: explicitly define and check internal GUP
flags, disallow FOLL_TOUCH") marked FOLL_TOUCH as a GUP-internal flag.

This causes a warning to fire when running gup_test, for example:

    $ ./gup_test -L -r 100 -z

dmesg:
    WARNING: CPU: 1 PID: 117 at mm/gup.c:2512 is_valid_gup_args+0x66/0x8c

Therefore, remove the "FOLL_TOUCH" test code from gup_test.c.

Signed-off-by: Peng Li <peng8420.li@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 tools/testing/selftests/mm/gup_test.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index 8900b840c17a..75f7134d529d 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -19,7 +19,6 @@
 
 /* Just the flags we need, copied from mm.h: */
 #define FOLL_WRITE	0x01	/* check pte is writable */
-#define FOLL_TOUCH	0x02	/* mark page accessed */
 
 #define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
 
@@ -93,7 +92,7 @@ int main(int argc, char **argv)
 {
 	struct gup_test gup = { 0 };
 	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
-	int flags = MAP_PRIVATE, touch = 0;
+	int flags = MAP_PRIVATE;
 	char *file = "/dev/zero";
 	pthread_t *tid;
 	char *p;
@@ -170,10 +169,6 @@ int main(int argc, char **argv)
 		case 'H':
 			flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
 			break;
-		case 'z':
-			/* fault pages in gup, do not fault in userland */
-			touch = 1;
-			break;
 		default:
 			ksft_exit_fail_msg("Wrong argument\n");
 		}
@@ -244,18 +239,9 @@ int main(int argc, char **argv)
 	else if (thp == 0)
 		madvise(p, size, MADV_NOHUGEPAGE);
 
-	/*
-	 * FOLL_TOUCH, in gup_test, is used as an either/or case: either
-	 * fault pages in from the kernel via FOLL_TOUCH, or fault them
-	 * in here, from user space. This allows comparison of performance
-	 * between those two cases.
-	 */
-	if (touch) {
-		gup.gup_flags |= FOLL_TOUCH;
-	} else {
-		for (; (unsigned long)p < gup.addr + size; p += psize())
-			p[0] = 0;
-	}
+	/* Fault them in here, from user space. */
+	for (; (unsigned long)p < gup.addr + size; p += psize())
+		p[0] = 0;
 
 	tid = malloc(sizeof(pthread_t) * nthreads);
 	assert(tid);
-- 
2.43.0


