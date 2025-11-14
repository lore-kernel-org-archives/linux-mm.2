Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75781CE7A8B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C04E08E000C; Fri, 14 Nov 2025 03:50:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDC1F8E0002; Fri, 14 Nov 2025 03:50:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF24C8E000C; Fri, 14 Nov 2025 03:50:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9ECA68E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:50:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4468F87662
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:50:46 +0000 (UTC)
X-FDA: 84108592092.16.F4D44FF
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 760CBC000B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:50:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l8+OEXZ0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763110244; a=rsa-sha256;
	cv=none;
	b=0+zQcyOMklG8SNxxavHqETZ4T8CdvPbbHcYM10qXPWgMQU5yEJupDFHiRrN6tGAo/Skbws
	nlgc47GgP6zqgVLJy7ERdSn/gcsGIrCp3PKKgBY24vrYgrpSWt3Yw0fqer0mZ1ND1qhhpe
	zDDvyzn0rijYwQdFHSqiuAIC486td+c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l8+OEXZ0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763110244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DbBO36ew8VvzcbHlpegzL83pZYmO4COvdyAP3ks49tc=;
	b=u8/uGgu1lWQXD/UAwBhUBNhjNFwXvdXba4O2Hwk08AH2odHvcK32n82Z1jusNLlE5KVrh0
	5z9OHEjoGvpSiRYDcSpgGpSw2E5XP/Jf5SZAxCpGW6CwMMmI8Sf3i1GR0/Q2WEhZOQ122P
	cY5gGLQbyf/k0TtfdOY9A8fMsD1babU=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7af603c06easo1934773b3a.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763110243; x=1763715043; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DbBO36ew8VvzcbHlpegzL83pZYmO4COvdyAP3ks49tc=;
        b=l8+OEXZ0Xn16D2mR9DwsCAMWU/XReEDNc8+kSGu9BkYhf3q40qcKRY6UR9rJ0ygt8b
         YuTrsNmQDKF2LhWH6DDT/8YSjUTdTTFYGb30nddu2vAnso5rKXRvK5N+OkOFh4gTf7WA
         5JjmND39P5r363RCeNOI5j1R2r1oP3JUIf7qWwp1yA6V/1qA0EAF2w2pnr5nau7lvgiI
         ya8RUcM9W0G+fYXvMmWvlsq/nw3n1u7rWLvDy4Y7XWU8P8SrcK2iJ/0cPFnyZOYyYf9f
         gYRH2GWsBE2y8RxZM1NXv7WJTUOEK96EruhS9+91jIzPQuJ90hgxaT+tu4kYCweBgUOL
         XhrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763110243; x=1763715043;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DbBO36ew8VvzcbHlpegzL83pZYmO4COvdyAP3ks49tc=;
        b=U3t/9NzpwmZHLc/eYmvcq+SfEetaoL4ng9AOnHksRxToc+eU+u3lW/UIsjVyE7aieR
         t3x5pyEIQJEJMp1QDHz1OJ/NLpAOR9FNNmSQjRscQpgs7BR4B9FKm2we5a2AedTdqX7D
         eHL33L9izYfq0gRmhQM+BquSaBZRk0Yh7jBC/1oPyL4pdIUZnnMXeuuru/AczT290+w4
         9FdqrNLjH2RBCh5jS6oilFTaxZ5mZf6kg/k0x0pwnZsjYGxTz4PLJLIUm21cz5hWf5W3
         dV1dCCT7eEWgKJi8hisiQJYMfY1QN1QRgAHwuYrE5uzPxIkSIqNh/4I8v0PyRmKTjKuI
         Bmiw==
X-Gm-Message-State: AOJu0Yxvni//gXU+nI4zp4xV6wEU+5xatPxBsAVY2LWUj5kgx48I87ia
	iVpx6FW1pjNdHavMSudG9MGRZpN7nn7LSsbwGYnu5sGgBOARd29ggqHEkfKMF4FMipyIkrg5
X-Gm-Gg: ASbGncvcrFT+pgmlQynFSobyKOkLRTUrXe1ebN1BJo+DDDe/ZjfNveq51/+R2p4YoVG
	4g5sgY+v2eaVwRgYsALoBrTg0Bcprp3OPrIBOasiLdmh1quxM7sqACO8mRQoNIEPO3hfOZw0l0w
	BBQ3NbxXiC5kglD+xWdxgrPIOqfwf6ua0np6pkIQWlrSOJq3nzohNkkEIqAHyspLooB9tCwepYy
	l0HhZChHKHQ5jDtt42VExtVPk1mbSlYFGUHz2IYqe1LAprn+zJWkJL3yoKPL6HqPbjVPPA37Lhb
	CNvYhbO36wkoxP3rDz1IRaZs6A/kb4UtuaZPaHrEj1IbARz26eWXcMN+JU10R705wfY7PSS2KER
	TCl6vMQeywIZJUii4zDknB8MofVZbRsigTsvgtCbetBUY5owzo+j8qi5mpPyymSbEOR8hAJvjc5
	39YqBkTyCTRwf9CKOzgYW4
X-Google-Smtp-Source: AGHT+IEpAf8mh4p6tc0bF2EPa6kquDi0o2K/C4+seZIZFBNIulWX3tLB8uFYJ43/Pckyb+HcJ+hTrA==
X-Received: by 2002:a05:6a00:94fc:b0:7aa:d1d4:bb7b with SMTP id d2e1a72fcca58-7ba3536b13cmr3366912b3a.16.1763110242963;
        Fri, 14 Nov 2025 00:50:42 -0800 (PST)
Received: from gmail.com ([117.147.72.154])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b924aedb73sm4459368b3a.12.2025.11.14.00.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 00:50:42 -0800 (PST)
From: peng8420.li@gmail.com
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: david@redhat.com,
	osalvador@suse.de,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	"peng8420.li" <peng8420.li@gmail.com>
Subject: [PATCH 1/2] Remove the "FOLL_TOUCH" test code from gup_test.c.
Date: Fri, 14 Nov 2025 16:50:37 +0800
Message-ID: <20251114085038.191031-1-peng8420.li@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 760CBC000B
X-Stat-Signature: 64bma4njexrd4mr34hmtmf7r5ke6579s
X-HE-Tag: 1763110244-390675
X-HE-Meta: U2FsdGVkX1+dWomZ0STr/Wl43wshodFHUAGL1bjg+Zoa0OP0rRk9epuZ1QVMdwCi9AbmPzpF17Ka9VEjTT5/OOOQEy8hjFzbxf+wknR8jjZxsqxhQFv+fqmVS1hVroeL0csN4CqlLyRt4jeS5MulQut9kY4DKk2dF0VCzeomo2EnQzRSyVFpiihoYZajChBlXwSUzWhzzH4QXle02tOU6oVfLp2x8zSeIAzA6tzNjUuQo1Mpi6oFGIJlHlRj2japH56xshQFVJ+6RBpyCpyyczD9of05SjTkwT2djChHodwf+9N8So4FFUpzBxqucLEnCYozNjFyRCptAPPcTpoiEwC4QxzqON9HBcGysVENLnYE3zWus0suR3oI0C4Bu6DWw+gJ2Q3gInPtuTzeVgliwpK5PxVzgcOjqbI8lpOsBc5gSBN7MYhnnfxgZMw7L3D1I0vlWwmOoIXNN1PMdz1m/BWqNScXB0O2Jc9wN+cnKYy+vtq6HAupH0Yhkz4r89zcuj/QNPNxR1UsFxMNOR3VXv6CwewjRl1poZtK3mcYvzoYo5U3WXAssomEMeHpV0002cDxOwjNIEH8WU50qnqLDW8pLzUNx1aqVrYbQvxQtn3fH1F6Avch2QlU1YVD5kzmSCkUotFvrxId1mr+A82pf0aNsgQSFdSwLcvBc21l2o0FW4x9bcpufhIyKIfKb9nlPNyEJXtIerAv1X1ffHYlHfmzcb9N/ewxB5dOaHUtkHJuFIYAY1Uu5pgKAxElt1wktXqc7Q/JAzyR7sft7zp2udAWPcNOk7p1BDTLjAcZV4CLGvFIpaPIwWL9luF8l8afrW4HR3NazIEx4/SMb3JyKpPLA9Fi7FKGmYKHA/3qaSxZbGcXvcl4YblWnxwF4KwDPWG9JVDaDb11FSDDJAqEgev1VAqxc73J4dP02H+jt/HtmQmcmwG7g1mElEHxC3wBQFMSMjSo9XCrdBvoiTT
 6JNiUxMc
 aifSXEOTiGT4/PDYy5//vZ6AEV32lEeBw2XWBHScq9ZF/9RsKdR0L5r5yDkk3EXGlMx9PDFDCopUPdNF8TA8nwO7wrf1JaS4tUPq0rv68V7GSDnq+o0diECnD3eq3vDf44+ekLFp/O4OPvkxJ3azefMpIx40YAXqDZu1HFRL6NiZE3r0asQn77QXROhW7kcoJ/0KCU4sIngFxun5ToDY98hX7hKM24VjVoSdXF9bOFdwpGLgG1ZpeBi0XcOQbPWbMsxhMXJBCvd/MVpdxIiSnmzyeTgwOwHdNT63Zciy9Vm0Z+PwPVqPoRdzmvjr0luokw8NJCE/gxGcTXAQGvD0D1y1062lKzHO3XDaRuaL7a/UNyqzcBYTSA6sPYy9i5elxipDcoDv6dRf1W5i3OB8JLTjU/CIZcFAtZUU2DrF5fYS7wa8xmD0wGh8RI4tlpD2RQD/FeAubw1OpBcAQ82slhMqOj66TPT8khyozuecarTTzjTii7q4Y0JueFB0ngaWMD6/lV/RGMvve8O0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "peng8420.li" <peng8420.li@gmail.com>

From submission 0f20bba1688bdf3b32df0162511a67d4eda15790, we know that "FOLL_TOUCH" is only for internal scope use;

Therefore, remove the "FOLL_TOUCH" test code from gup_test.c;

Otherwise, executing the test command "./gup_test -L -r 100 -z" will report the following warning log:
TAP version 13
1..1
ENCHMARK: Time: [   39.363371] WARNING: CPU: 1 PID: 117 at mm/gup.c:2512 is_valid_gup_args+0x66/0x8c
get:2818 put:46 [   39.364043] Modules linked in:
us# , truncated [   39.364311] CPU: 1 UID: 0 PID: 117 Comm: gup_test Not tainted 6.18.0-rc5-00324-gd09eaf415c87 #29 NONE
(size: 0)#
[   39.364434] Hardware name: riscv-virtio,qemu (DT)
[   39.364546] epc : is_valid_gup_args+0x66/0x8c
[   39.364596]  ra : pin_user_pages+0x38/0x78
[   39.364630] epc : ffffffff802079e6 ra : ffffffff8020c214 sp : ff2000000041bd20
[   39.364650]  gp : ffffffff81a26068 tp : ff60000080b3b000 t0 : ff2000000041bdf8
[   39.364678]  t1 : 000000000000001e t2 : 0000000000000000 s0 : ff2000000041bd30
[   39.364697]  s1 : ff60000081300000 a0 : ff60000081300000 a1 : 0000000000000000
[   39.364714]  a2 : ff2000000041bd3c a3 : 0000000000080000 a4 : 0000000000000001
[   39.364731]  a5 : 0000000000010101 a6 : 0000000000000001 a7 : 0000000000000000
[   39.364747]  s2 : 00007fff7eeed000 s3 : 0000000000000001 s4 : 00007fff7eeee000
[   39.364761]  s5 : 00007fff7eeeb838 s6 : 0000000000000000 s7 : 00007fff7eeed000
[   39.364825]  s8 : ff60000081300000 s9 : 0000000000000000 s10: 0000000000000002
[   39.364842]  s11: 000000092869bfdc t3 : 2152ffffffffffc0 t4 : 00000000001fffff
[   39.364855]  t5 : ffffffffffffffff t6 : 0000000000000000
[   39.364867] status: 0000000200000120 badaddr: ffffffff802079e6 cause: 0000000000000003
[   39.364949] [<ffffffff802079e6>] is_valid_gup_args+0x66/0x8c
[   39.365036] [<ffffffff8020c214>] pin_user_pages+0x38/0x78
[   39.365049] [<ffffffff80278f78>] gup_test_ioctl+0x2b4/0xc08
[   39.365060] [<ffffffff80297da6>] __riscv_sys_ioctl+0xba/0xc4
[   39.365072] [<ffffffff80b93f96>] do_trap_ecall_u+0x296/0x370
[   39.365093] [<ffffffff80b9ef06>] handle_exception+0x146/0x152
[   39.365220] ---[ end trace 0000000000000000 ]---
ok 1 ioctl status 0

Signed-off-by: peng8420.li <peng8420.li@gmail.com>
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


