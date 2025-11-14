Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12F66CE8D4F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CFDD8E0008; Fri, 14 Nov 2025 11:11:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F658E0005; Fri, 14 Nov 2025 11:11:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26DBD8E0008; Fri, 14 Nov 2025 11:11:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FC688E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:11:38 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C359513AF36
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:11:37 +0000 (UTC)
X-FDA: 84109703034.05.CBA2FD2
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 038FF4001A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:11:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GyNovPko;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763136696; a=rsa-sha256;
	cv=none;
	b=8TlZOX3P5MiE0TQvSaV43rzFuSlKDbUGucfCXNb9RVgE4wsiTt4gleBq0z01Rz1aNZ9e3/
	iJziBh+J4e1NqjP4lZixW7y4Nqvtzj5TV2MK1Eok8TzKD3JS0q1RNqSUsS7S3cyIDblXp6
	Lw+KZooOGzvajUaICsPKWrW6KABLs5w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GyNovPko;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763136696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sXxLeDqMnDfPoqZmJZs/OvhUlLPpJUJ3x7qA3NQ6GsU=;
	b=bb6sY6Bnbv/yL9pjDH0gDqItVla39LLJSppAUK7ThUPgVJuZkUIuxGDlLp4LdoMk8BXK4u
	hMVfOZ65JCjiY8mGsicRIaAdxfHcOMzpyoy29v0GRmGjSHWasPCtyucQmVa2URlIgMrKN1
	JazZWZ+OkkW8NgwtMkrfm6Q6mieKwQQ=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29845b06dd2so23436995ad.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763136695; x=1763741495; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sXxLeDqMnDfPoqZmJZs/OvhUlLPpJUJ3x7qA3NQ6GsU=;
        b=GyNovPko7x7WQghC7AU4SYXDbokWocpjXCHwgOZbWndaRjbceZfNXGBLKlZ1jlem0g
         RLnDXcxDLN0T7QpfhYr0e9ljs2d7PqFCePEVvCeHLF9YGpVKew4fD9JmeXDQP1GDNxM9
         fmV+x4MLZMyxP5nd+z7P1lqA/q3n7yAI1VDto3j2gDqZNOeGFrPoM6Roc66IVcrJHkaT
         a2mwukzZYr1ueNaIkBcN+VYIUj1FMrlVNs42EHnV447/k8sm64tGDNWQoh4Gn890RCPZ
         KuiIHensu7880VEkRSLkq+wY4pHUELeXIa7WnRTohw/94PjtNXJpMfOV0GAxroSpLlgB
         oOhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763136695; x=1763741495;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sXxLeDqMnDfPoqZmJZs/OvhUlLPpJUJ3x7qA3NQ6GsU=;
        b=Bz20ld72e3ABZn5ukorQ5NItnHIn4k0ow7TLb2nVINu3Gc9Pbg2M1mhJhPN9tZ5EDO
         j0ykzr312A3IgN7OT6ONPlIJG/3+kjnSpObJ+S6JRJOEyC9J5rLfjLdbJQtIXJ0iUxOq
         Eucxnp2L7UPnvP3x6FB4vg6AegXuDiF8jpdNgeaSqHRFPn0aL3na592/8jVoy4JRgftE
         W3Esi+Y9wyLFq7xf9R5KqEBmBxpofWQnukZslbSl/gMCW2eYM/PAb8tBsS8qm8u4YYIK
         0qR7DyLvcV6zEw25AlreT4xgwHCJrx7cRgaIiQufheFF5LCue7r/NCYHLxjHosyeckUc
         gylw==
X-Gm-Message-State: AOJu0YwesnfSu+XtmB8ILBPzwG4ut2PZFRK0IHUKjnO3HYMuoch7UOER
	BEU+fOx+XXW21boGMeSwx1koHJpsgZzm0h7jDFX0K5e4vvX8ZSbehvBz+KBDLLhEp0Q=
X-Gm-Gg: ASbGncuDc4/rrZASD5z7sMUXSeuoJFVArUE38cB9T8LoZm65H0JDU3rsmiiVFtBhmru
	cGhob0hiWwk4MMPhsuTfhgib8Lnlw9QbcOcEYnZhH+Ki5NOcI6YrUkcvnAqyWL5XkUt0lwHBAIv
	9OW8W+dgnKeO62pOoQTylyD3y++YIK4l09mKrSdiqpEFGXhWSXy6it/J0KNNxigZfZZ+rk8BXUp
	pSg+DU4O7OMSDMbd0Lb99lgDE13lIy8GlMd6K7gyD8cJq4OeA7DEsArJPicdGq2ekC7lfKQzQyq
	qtRvxmP3XkcW8yxzEg+MZ/mHO+4joipdqxFpmjT94KQ5ypgzqI12eCzvZwsstZHiPWv8MXQ2Sy5
	g182IoHhHFVvxmMlyMW/fVaB6VHee+K65BmWcU5ItnC4hIA/qLELIjO7mRyyQ2SHHym0jXv5fpR
	4=
X-Google-Smtp-Source: AGHT+IF1ElFOKDrihllUTU0L6vNDsk/mc+c3pAUrsYHk9osHh8ET7eTJayTKBR+2Y0pyL5lQdTHUPg==
X-Received: by 2002:a17:902:f70c:b0:298:3e3a:ae6 with SMTP id d9443c01a7336-2986a7420f6mr41150315ad.48.1763136694526;
        Fri, 14 Nov 2025 08:11:34 -0800 (PST)
Received: from gmail.com ([117.147.72.154])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985ce19a20sm58384365ad.84.2025.11.14.08.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 08:11:34 -0800 (PST)
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
Subject: [PATCH v2 1/2] Remove the "FOLL_TOUCH" test code from gup_test.c.
Date: Sat, 15 Nov 2025 00:11:26 +0800
Message-ID: <20251114161127.193707-1-peng8420.li@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 038FF4001A
X-Rspamd-Server: rspam07
X-Stat-Signature: uttwgdpsbxoz5prs77ktrz9xjhmfsnxa
X-Rspam-User: 
X-HE-Tag: 1763136695-871171
X-HE-Meta: U2FsdGVkX1/8TfuW6Luvki8Tvhb38Bl9YvQLfEa+av3cv1tcA8iLHGufiYruckAyaAZk4YV5DC3TQbLRzbg464pSxCE3AdE6NwuiuQzc4RZm9tp1XCZNow/vYCv9AsjufUcO/D5LIYx22Cpc3YqtODQbZjrnv/v5kXmJIhlSbmNxagqYN6X9K3+Gmuia1WiL5F79SsRF/IsLin9HujK05aDe4ko8f5dSRZ9Yqm42Zz8KBtv8gIyYqmy0XsM5TYdr2R/EWeZxJhQ9bceWiOsm80a9YWxx4ehomllLdslPiHYkVktZtexjXf2IcZBkqB8U/Wsg+WpcI1CODnk+aORUqaZZ5rq5Vos2c6E2CSzEtDaY0W1c946IFviaGRUKruPgAByCBpzgO2b1fYYObxnUjiLKERAT1Cl4gqfAXj57xw8MatacuCCrtVkx7gSwuQHFrflAsilBdSc+h0H+SfZl4+hdxrlPy79UkVCKjW18rm7gWmuaBW8mr+aBMOx5hT1zNVbLoEYze55Xrkmm8nN64TU73cMd/rJ5zP4vqlQa+dVr3pYV8+1Ww6iXJtHZMfioqNZcaJmmneJ1zADwwaMMk2DTQRrY3B577rt+gXdTdEYHLm7FgHRuwJVQ0uFSsvTj2xwBNADeGUOrOlqZ06TPx3vKq4c8MfTPvGYZcVpMlXbQmWPu4LsMhfXtepbOMC4mgbAAUaQXxRwXkMd5kIATHRip34AdNo6QJdahVh9azjCTT9g4j+GYFlAr/tH+1VdYMmk1KGV5TgbwJhLNFZAzXmt3I9V9Ci9VEXuAquXJK2Wqjysfblb/XicjnzbdgNhB2ZtgkH5PZy0cYWFBXS1mH5vXhpVUuVJgzlfAKMoB+ykcV8XLOSrXt8/ILdoVrRcHklRZFngCbd+qRzfjdIOso8hVENnLpRtv0slACbvj3d8koZpVa8a5ActKfH5qTAXcVFu4mbsGFZQXC3GVwVa
 MPwFyQHi
 E+hL9PFqB3E4gxL+EPs31fEbV12Gh9SLa+8BfMuLuHl1s3h3iV3Ah7vN8RnIm/bTOrdxzWFguFTf8IC6F6/GhY/9BBosb9ip87xJv+grvknoyDHf8Qo/SundGJdN9lzbvRaXyF8J/gdup+S933mkML9aLf/afUBHTVFtzEBNvIYSE8pBLYKwZQO+PpdHJtmIxmUMUbMse+AqOBUEnc+IzxzbP+gXBGUjHWmRgMqVcSo7ktQVjgG0FqSWdY1Mv+QOEHcbZJshvfN1b6QlRk8khLRejlZ9lefNwcMhQnVnm0aEI+eQrHxuQcNURYXSbU3YgjXJZa/04ZodMnhAO1o+eO/trhYCntpQkCbbcYomTKtL07zk45yrS2L9xYM/0afciSn1fSoiR40/AHoU/s1zAfnepca/4vt0DfXIEESbBsF/r0UQTB8p75fG7XvcHf3cFTMA9XFvw8lDFTQklSDV+9+HoOmARnKDnPyaWkI5a7m6EPqSfKOIr1uiG1Vw4oCFlF8X/SbzLbfz8DJc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "peng8420.li" <peng8420.li@gmail.com>

Ever since commit 0f20bba1688b ("mm/gup: explicitly define and check
internal GUP flags, disallow FOLL_TOUCH") we marked FOLL_TOUCH as a GUP-internal flag.

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


