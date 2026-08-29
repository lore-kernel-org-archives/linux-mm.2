Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5FF1C61DD3
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 02:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15CC6B0088; Fri, 28 Aug 2026 22:50:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7276B008A; Fri, 28 Aug 2026 22:50:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5856B008C; Fri, 28 Aug 2026 22:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 954A56B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 22:50:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 766F640631
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 02:50:38 +0000 (UTC)
X-FDA: 85152778956.24.3B03FE2
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf13.hostedemail.com (Postfix) with ESMTP id B650620002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 02:50:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sCQXL1RP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3-0iSagoKCDIXhVciUVhcbUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jthoughton.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3-0iSagoKCDIXhVciUVhcbUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787971836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFZPhakOwxRZAFtn7md9lSxeY1Cg1zyr2h0Gca9vEbU=;
	b=lbaNrKvQPI5QeGtHGZHgtXW/FeoUAeuEOkzynZtQeHSFmCPG2ZN/p9XVK8XsFPhSEFuc0i
	V3Y+gux4idGd0EcYFi3pnRLWCD44Ubv1Fsj5d2riVbNmJck4W2Fb8GoVVP6PVkULZEXZAj
	cmhmdI6kfLnrQuGYGXR1aEdMttHJh/4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sCQXL1RP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3-0iSagoKCDIXhVciUVhcbUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jthoughton.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3-0iSagoKCDIXhVciUVhcbUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787971836;
	b=SkbSR9npD6mJPbFOBp/F7q3sR7SI7N844QT+yYmscfuqSB5jr1TtxcpM9Q3PEapp/TBM+j
	ksXaiPJJ4hd1LxbrJV2Z9lvVOSOpovJsoJEk89LhXR3J36V661xlURiRtpvuGYMg5H5QJH
	TMWsNsl2cdln2ClZlJvw/d4B8xDWW40=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc1c5810451so2350406a12.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787971835; x=1788576635; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vFZPhakOwxRZAFtn7md9lSxeY1Cg1zyr2h0Gca9vEbU=;
        b=sCQXL1RPMw9I0gxcZT1oD4lYYL+GVHtuu4WhFEi/qpqko2XKoyRbaoan0IGDd7I3if
         8CySdejeeJwS5/qr8QuPUGFyaIFz9MaogNerpmAw172rdH7ezGRUnKJltqtg5R8YZ2RH
         sTQjfxNq7qwDHEeBvZ/dPLWxiPhjqIBBa82OFyxdOK008VmBSPOfssFAWvrqydSCeoY9
         39d+sGWMypweG57g6Nfnx1SNeWOCkbGemPXfNU1CCWKCMWFsnZVcOFWsSxk2RooINGjV
         FNxqMyOumS41aUiSRj+lUBrxFmn0+fXBmfb6XutkIiZch6YK1Ut3veTGtgvDt17ATeMk
         XkeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787971835; x=1788576635;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vFZPhakOwxRZAFtn7md9lSxeY1Cg1zyr2h0Gca9vEbU=;
        b=bzw6KVSxNo+JdLEIYm1mWZtGaF5l3jitcPeRQZw6SfXZm/NX/0WsT79opiwH2+rPiE
         EelBY9Es3uT+NVglk4E1YgTAlSvkD+XAU0tBsdLslQlEjk7ixjbH5pMCctjAWRXMHaED
         kZz+TN9xZWArSlCbMxeGsWZFn7EIzOda7pZSAGd+mXJw2pJmyxN7du0WDuRYz2HHaL/V
         ml8rLXAeHV1TYXkKu3lFnTDlx4w2FB1fut4Z1w/99XR+EZIKLuibMiYo4NO48jGxCn4b
         BuRGKv9hjfU3gAcI+0H+SqUUnX+K8srPY4KYlwtkaRrLhZ70/SgmLn4EeQAw0+dsSE+9
         Qq3g==
X-Forwarded-Encrypted: i=1; AHgh+Rp40hIaqZTP/bZc3ypOmU7S/wPvXNbmbdZfOkDbtX8cDf7cfiNDLfRi/FPXSXgEQysPGd2Q7NURWw==@kvack.org
X-Gm-Message-State: AFuF++koRC7vxu/Th+z4gLa3vPctm0tzI/GCys7l2wMPlRRgALzUr1Ai
	Q1pp7jJFPyUc8J3H2qwqg8ot1OnAAs9umWBuUYNlAlcAPSLes0j9KKa4KJ96xGUbT/mYKpfVtnY
	3GxFu7gSgQxHLAXR31pYC4w==
X-Received: from pgby8-n2.prod.google.com ([2002:a05:6a02:6508:20b0:cc1:c78b:a2fb])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:f94:b0:857:7317:cff4 with SMTP id d2e1a72fcca58-8577317d1bcmr6303601b3a.21.1787971835104;
 Fri, 28 Aug 2026 19:50:35 -0700 (PDT)
Date: Sat, 29 Aug 2026 02:50:33 +0000
In-Reply-To: <20260828183801.04fd2d2a6af837cb45b60e0f@linux-foundation.org>
Mime-Version: 1.0
References: <20260828183801.04fd2d2a6af837cb45b60e0f@linux-foundation.org>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260829025034.2500920-1-jthoughton@google.com>
Subject: Re: [PATCH v2] mm/khugepaged: Don't install PMDs in
 uffd-minor-registered VMAs
From: James Houghton <jthoughton@google.com>
To: akpm@linux-foundation.org
Cc: baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org, 
	dev.jain@arm.com, hughd@google.com, jthoughton@google.com, kas@kernel.org, 
	lance.yang@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, shy828301@gmail.com, stable@vger.kernel.org, 
	usama.arif@linux.dev, ziy@nvidia.com, zokeefe@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: siaho6eicox93wqmwejpxd9zwz7mn7e5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B650620002
X-Rspam-User: 
X-HE-Tag: 1787971836-261137
X-HE-Meta: U2FsdGVkX1/nfPbA8IjFPHdQ9mvuAzta7f7S9obB5ihCceFm9Dd6TD9rYrOufS0/JCCeNaQPJQr8NajfhrsScKSOKTKwxatTfE/cfJghi1Dz5u9FVvQK5Zbp+pB2E9N9hYliWp1zFG6tybagSMvfWW4v9iyEetXA77zpqJaGoWx4n1zSGX6xhtgJxFXOa5TNkaR/HkwuUao8nY4IZi7oQgaPn01wzQfJJaLzJpBHdzwgFWlXWoM79z6X5hzPPOas/y+y78Q/R91YiMEAFCmXqCVqgTfAc5xY1QgPSd5kxjnt8z7uFus4O9h1/osJ6o44r/Yk2L04T+KYIbSli19zt9e9/DxJe+Iej/7NTmeOFZ4DxBLZtRc0VetC/AOQxyvKEMXzCUqb/X5sTFssB9autDeLaFYhVW8Spr6PgLQv4sNmgtnfqnxiZbllp2jkoU7J8jpSD6HZNIEw17COTT6Np1zOzPIsNiI/w5jy+V1JKtv0/U3ueeX+4oFEdIGop+30Qn7OUXDza4EWb6uturwy7/419it5KwKrKStuIXWIyfWWTObFkYzolhUjk3IeiOiPxWnoOyCN5Q8Hy0N90z1OKIGrfY/jZYYExTBPN/86U9FC8AxWLHi8kvLdq8kWRPniwu5J0LTSWV2qSmaS9zGtdumiHdiXS6Awm6Kn8SEMbsvgQIVd9l1dpSTfGO/peddcaGtOj4F+X3Y7InKwhe0Wwg2atLVIPcFEwJhfWeZ2YHR2dOeoS/028ZFhB3NFx+ObxgqTcnOSvK8aB2nKeSfIFfTtTQQN2bI9UUqx5+8pszS4KgObL5qDld3G6vp7E6n+0GqIAnIK5dvu8ak3/hQ1CX91sb89RLilTuwom4eDEhY+eGoWL+nRJ0W/Avf0NRIaT+uPdzD8S6GqpSgLwJNcnmT29SOOGjvN+aBhWYabo+sMKPyFXnaLinWX0BL9HJEuIQvNvhY4V/I+H0/xtEA
 FE+ZVhFC
 EL4TIELp6XMhkzq5PvsC2bhRECbonu96fsCyc3AkbyNQjTKGm7tIJjV9K8sA0fzD7GC4279imn6PewCmC5vLVridBjDYhkgbwwpHsqaqEdxnP+LVMnomYv+QibyRuJs3dm/kbqeDRSA+2SSNIVlPd1VrOisu1HhLJ9dq88jKZBlukNdZs3u/IjxoHec9/YIdeyZEOhqL178leFZpj6A0MNQeSBE6XScvGOgmJ017igLxnfFZscs8iTOKbbLZbKm7VBb0E6SU8tuzca/+vnqZ+rDmZ0WjrhwTCIEhFzXB2UpM/c2hoAKlowxtu6kvsYH9bsjCHzcl9qklhYfJFARnW2+c8pgjk9CVa/Dv0YIgyOAmltcmzyxiNOZq8/ZUFtzFLgpn67XseeCH1532iJZZQ1dzpnqNXoPCg6zY9iYJE982ggdDUHTu9Ruv4xYHiyUsg43A3lA8dlufDAUuwS2nrXnZE4AmA0lk5Ouyt4rslvLCa4KL8J/7rnv4AMGEwyCpJHitjYE5NdjmdaBRcQiWJwlg7vuptZeAlizEbWaNcoR/3RRv1xdS5l3oibGtSwyg2wHK2pzsfb47xsspH/VvSDzQzk1kYbliPtda7h7hoYYe9HfRKVnVkbb/bxsppICT8b73WjH8OtirH0udiZ8abLAGl5D+1v/cGvPWUI9D6AwwF6K6FXkfLHvlVbSC7ikFmMqkf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 6:38=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 28 Aug 2026 18:18:11 -0700 James Houghton <jthoughton@google.com>=
 wrote:
> > Ah, just to be clear, I linked a repro on v1. Here[1] is that repro.
> > Sorry, slipped my mind to also include it in the notes for this v2.
> >
> > [1] https://gist.github.com/48ca/d399bf534158e80241fb4937ef1ff664
>
> Cool thanks, I'll slap this into the changelog.
>
> # ./a.out
> TAP version 13
> 1..1
> madvise(MADV_COLLAPSE) succeeded
> ioctl(UFFDIO_CONTINUE) failed: File exists (errno=3D17)
> not ok 1 - memfd userfaultfd MINOR continue test
>
>
> We do have a ton of uffd selftesting code in there.  Adding this case
> to uffd-unit-tests.c would presumably be pretty simple.  We don't
> really have a policy on adding a test-case after fixing something -
> it's common practice but why?  We already fixed it!

Good idea. The below patch should work; I'll send it properly on Monday.

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/s=
elftests/mm/uffd-unit-tests.c
index ef9b3956bdcf..227bcd6aef9d 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -518,19 +518,34 @@ static void uffd_wp_fork_pin_with_event_test(uffd_glo=
bal_test_opts_t *gopts, uff
 	uffd_wp_fork_pin_test_common(gopts, args, true);
 }
=20
-static void check_memory_contents(uffd_global_test_opts_t *gopts, char *p)
+static int __check_memory_contents(unsigned long offset,
+				   unsigned long nr_pages,
+				   uffd_global_test_opts_t *gopts,
+				   char *p)
 {
 	unsigned long i, j;
 	uint8_t expected_byte;
=20
-	for (i =3D 0; i < gopts->nr_pages; ++i) {
+	if (nr_pages + offset < nr_pages)
+		err("overflow in memory check");
+	if (nr_pages + offset > gopts->nr_pages)
+		err("out of bounds memory check");
+
+	for (i =3D offset; i < nr_pages; ++i) {
 		expected_byte =3D ~((uint8_t)(i % ((uint8_t)-1)));
 		for (j =3D 0; j < gopts->page_size; j++) {
 			uint8_t v =3D *(uint8_t *)(p + (i * gopts->page_size) + j);
 			if (v !=3D expected_byte)
-				err("unexpected page contents");
+				return 1;
 		}
 	}
+
+	return 0;
+}
+
+static int check_memory_contents(uffd_global_test_opts_t *gopts, char *p)
+{
+	return __check_memory_contents(0, gopts->nr_pages, gopts, p);
 }
=20
 static void uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool te=
st_collapse, bool test_wp)
@@ -539,6 +554,8 @@ static void uffd_minor_test_common(uffd_global_test_opt=
s_t *gopts, bool test_col
 	pthread_t uffd_mon;
 	char c =3D '\0';
 	struct uffd_args args =3D { 0 };
+	unsigned long checked =3D 0;
+	bool bad_contents;
 	args.gopts =3D gopts;
=20
 	/*
@@ -564,19 +581,51 @@ static void uffd_minor_test_common(uffd_global_test_o=
pts_t *gopts, bool test_col
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
=20
+	if (test_collapse) {
+		/*
+		 * Read just a single page and try collapsing. The collapse
+		 * should either be rejected or be a no-op.
+		 */
+		if (__check_memory_contents(0, 1, gopts, gopts->area_dst_alias))
+			err("unexpected memory contents before collapse");
+
+		madvise(gopts->area_dst_alias, gopts->nr_pages * gopts->page_size,
+			MADV_COLLAPSE);
+		/*
+		 * If the above collapse mapped pages that were not explicitly
+		 * CONTINUE'd, the below __check_memory_contents() will not
+		 * fault on some pages, resulting in incorrect contents. The
+		 * PTE for the first page may get retracted, so avoid checking
+		 * that page, as we might take a second fault, flipping the
+		 * contents a second time.
+		 */
+		checked =3D 1;
+	}
+
 	/*
 	 * Read each of the pages back using the UFFD-registered mapping. We
 	 * expect that the first time we touch a page, it will result in a minor
 	 * fault. uffd_poll_thread will resolve the fault by bit-flipping the
 	 * page's contents, and then issuing a CONTINUE ioctl.
 	 */
-	check_memory_contents(gopts, gopts->area_dst_alias);
+	bad_contents =3D !!__check_memory_contents(checked, gopts->nr_pages - che=
cked,
+						    gopts, gopts->area_dst_alias);
=20
 	if (write(gopts->pipefd[1], &c, sizeof(c)) !=3D sizeof(c))
 		err("pipe write");
 	if (pthread_join(uffd_mon, NULL))
 		err("join() failed");
=20
+	if (bad_contents && test_collapse) {
+		uffd_test_fail("unexpected memory contents after collapse");
+		return;
+	}
+
+	if (bad_contents) {
+		uffd_test_fail("unexpected memory contents");
+		return;
+	}
+
 	if (test_collapse) {
 		if (madvise(gopts->area_dst_alias, gopts->nr_pages * gopts->page_size,
 			    MADV_COLLAPSE)) {
@@ -593,7 +642,10 @@ static void uffd_minor_test_common(uffd_global_test_op=
ts_t *gopts, bool test_col
 		 * This won't cause uffd-fault - it purely just makes sure there
 		 * was no corruption.
 		 */
-		check_memory_contents(gopts, gopts->area_dst_alias);
+		if (check_memory_contents(gopts, gopts->area_dst_alias)) {
+			uffd_test_fail("unexpected memory contents");
+			return;
+		}
 	}
=20
 	if (args.missing_faults !=3D 0 || args.minor_faults !=3D gopts->nr_pages)

