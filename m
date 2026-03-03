Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D92F5EDEBEC
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 19:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5446B00A0; Tue,  3 Mar 2026 14:42:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49FB56B00A1; Tue,  3 Mar 2026 14:42:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2216B00A2; Tue,  3 Mar 2026 14:42:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 29FA96B00A0
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:42:06 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E19328ABDD
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:42:05 +0000 (UTC)
X-FDA: 84505772610.14.F13EE68
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0E8084000C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:42:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lKrtbPpa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772566924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ija5cl5iw/lXAYwYtLBqZs6EcpnK3FanNYd7fnqfYMs=;
	b=t6WD7b4ui5eajXoFLTH69a6TnhA5QpLmChfY/QDeD+jNsm2F5m+FyVwNCFpgHoS+lD989A
	QRwu1O+lOs/19sGPjFdkIgOKU8Zl711MQXULUE/M/9QFc8lA3uAPiUT6X2lXAzvjG1lgHz
	tZ0lPgCLqeSR9XokkTs/kWAbJdYUX+M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lKrtbPpa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772566924; a=rsa-sha256;
	cv=none;
	b=xvIlLRoMN+a7G3X5XYrtG/KbphCgVYFzsR2KYw2Hil7S7uKFTxFXV1ysY6KGaVZvZmFJ0K
	+k6660FK5IR4Z0C9o09Jzy0mMagBI8Tc8NGmXyiXLXWf00Z1ytRp9pObmej3x+cYajaf9y
	J33TF6NG5gFqH7reQ1Geo1jSqEkUXLU=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2bdfc4b191fso2413446eec.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772566923; x=1773171723; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ija5cl5iw/lXAYwYtLBqZs6EcpnK3FanNYd7fnqfYMs=;
        b=lKrtbPpaIomslqF0ykSkP2xVOOaP5taq4nnThQZ12IXNstraSHudit4MhRAdeC2LZ+
         T1DK6aBEFVm0DtIoZADArjfCdAHkiLbekWA8IJFW7lX/K3pv/baRGXzqOJbca7Ue177Z
         mNVYJAp/eDcEApIDLYMwgmGqM1V3dk9ruvqa5EM4xFiUSym5lfa5hbrDH6NkVN2ITONr
         xK7SzjUtSVHXYke0K1D3RmKjOGiyQ1AxUqb4YOaT6NVmW+f28sg65FYvsWKuG2RoWpEt
         J2qtADN9W6RMLJzX62WV776e/5CuYtS7ayddbTU+6eSEZSr4/J35FklJKEpIle3OCvwY
         JyXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566923; x=1773171723;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ija5cl5iw/lXAYwYtLBqZs6EcpnK3FanNYd7fnqfYMs=;
        b=TPKL/I15fpSLFTZMI1kOVn2JiUXaFqj+IsSnspDWIPH6oB0BoEO3Onux5m4W2B/1un
         4Ww6acqkmG5JEjspzkXd/z/evF6Kqi/Lo1pLjBrTsiJhaZ4MPOYEHzlmSPShoRnvSBuc
         IQSf4WN8ecjia340BcUS8q70qkjR8Wi0laeSwUh2hd58/hLvPJyCicROZWHvij/5yLwK
         orpqnu6iq9SeMoh9KvDpu9IWj+T/DvKB6MJBD6YumT4HfOh8ivmwHtPY5UXf2tS3YRbL
         QUi3SoOO/Ld0Pxg5cgobbjXnB0R+7OH7dlDLi2xjVBAFHHnVA+UDfJ8Y3xmNyrCTLwMX
         LepQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuY2v3rS7XUKOgT/LN2OroPXeFHg5tmHYWpua2WJwwd8AZMhlgPTwmci/SQTL44iCcv9D1BNMS/A==@kvack.org
X-Gm-Message-State: AOJu0YwkGlqyT4sZqZzds1eZGl/0q2dDGN7MhwJ46kuMuoK2mV/1P/w2
	5OeN0+m//dPByvCEIx0fphkoGRBic7LI2u4kI4jhJwt7Gca3VoQvyibz
X-Gm-Gg: ATEYQzzfyzO4XpGDYtIPwjLGzokV908tfDLxq8cQypKdczSRX9kfVkNay8DJQyhC3ym
	cGo7TZi32Ex+IKwZ11bqrMPNdG73qO4iIeaGOVUs6ekHka4fTXdnXeZfNHXbmukLoaE4xs6Erxg
	CVi/mrZHE1spmyJOO+2fALANZdy3nH7iSjFrGl+g2teW04DYLVnrCXl4jnwS5AhgVPtE2BsM1F/
	AnzmeqarHrJDremE9D+znIuWT/T72jOHPrXf1bTOq3kwLJWhGC+D5l6+W47u3jenqsOQA9bP+7P
	yYFqooSPkeR+ik/aOuOfn1VZL4TFRyJ5f6KbQq7vlDg5bj2QOgI3W/+v3xWBJK0j2nQFIUBREwT
	NWFv6X3a1OhoyS2aJxQ9nbnm6YsBmQMJdBNsIap7sqDUxFSw0Aq55aBqS0TU753Jf7KBge0UkCw
	C60KEvGJgWmRARAOBBy+SbarBMVQlXpgFYDDI1/z2jUti9lVKEe5lxmwXd/eim9FNY+ZJll35sO
	xz9macZZYGDyM2r3jxTFYuIuQ==
X-Received: by 2002:a05:7300:aca8:b0:2ba:a4dc:5c06 with SMTP id 5a478bee46e88-2bde1d31e4bmr6528631eec.20.1772566922463;
        Tue, 03 Mar 2026 11:42:02 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2be1281ff70sm6373751eec.14.2026.03.03.11.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:42:01 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	Dave Hansen <dave.hansen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v7 3/4] x86/mm/pat: Convert populate_pgd() to use page table apis
Date: Tue,  3 Mar 2026 11:41:50 -0800
Message-ID: <20260303194150.1406433-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0E8084000C
X-Stat-Signature: rpq1hxp1zkdycepyf63jrwc6s16g44xr
X-Rspam-User: 
X-HE-Tag: 1772566923-296594
X-HE-Meta: U2FsdGVkX1/9sdps6vs0lWgdUS0BXL2w8718oaslBYW+NxtB8C341dVemfghWxQYiO2y+/VKyOWDDpwqeAEvH6anyzpDRVAY6qIS75snHTvu0IGXpVh3EbPIIIPeffZngaD5VWBAtcpKe6ZmLyJkxNdWNLl6hNqLp8CZKEe7jNeQH7/D7I97KlCOq0WVI3P8EOKbZR5jPzeHsXbhAUXhz+L5dUlfpMB5w5Df2a7aubmpRObbcK2f6dv9ic+PxHSEpF7PjSgy2raHgSk+IRN8YhOM+lTGJZ2z3NaMMokslELWpTUzVNkBm4nU6maV0dKdj4cbiJm7RZ7i6hKjmMCCPyQahz/WYaTuLXTrUztKu6TX63w9Vy7H1qZDiJpcq7R00SBaGQE6UnEMYP8Ymsp+wMopUwnUfbXyTjSxcvMu6VM48CBhE4t7bH8eD1Ce9Cu1DA3EBMDlcSok+A6D9jQVwyj9xiPQFzAx5HwDKYyAcchEGFtfXJytURL45JpQL6I4B0lRN9yKkhEOgIi5FyKY617zVn3rCJs+LkNvaQC9GJIbxc3FxGivQ3yHjo0ofS/rnoKRIZ4jPpNKxliPiswG0ErH5J6qyr+JPfoiwD9d/AdUQS1lbyJmfSIuTfKlJekDHbF/dZL61ilXlq1EOnGUrPd4ZRURzdWS5jDj+XfYquf8ov5SivUT2wxtlB/GXf/Lc72ZmLycJ4zGd/VHKVywlOqQX4apmw6QivmLYnaXVdaaOYAvIqf1JElxK3AjUzHDwFn7DlLux8D5lG5vy9xUVBLEYUGwr4dYMBGcn6zWM/HCKlAOWme8iCMCHha3lWO5ywHmxeQBbraQBs/6t7GkI0ZiRlo4oYRh+2XjsCTYvJ04spjLOjWqRiW3S+Va1ESVb59tiAXPFxkZvG7rI/8tsxw+lTGtyPZHivsJxeHbnc+cRJ3rES+502GZm6WK6W+llqdR/mbjS4ZuixvzCfm
 xeZpsWdI
 Nh1Q+7Nu5nbyJgHTY2oyksdqI0AubsVaY5GJwi62MYyptg4ZiwQh2Gg7qDjcWevPjY7DHcpSw/RVJT8ulKKxqStUW0BQSomm52SoVUqtBF61W/p6OeOKv1raObqV19X6sg9mgehirc9xzecLSvqd6WsK0l63+BONNjzDgkRKU8eXggMMVvhH0Pqvt+9wzgAFkH0BRH+oL8ixVBrQNdamdc1lUzdZM+NTRHg7AZE9dcYSCylYCn+RfzOaM8F2G6k8Yn2JMLqMgzhmlg9qGkWHKnpa6rSBqHqczXX1OPEOKnwrt2XHOnR4e9Hs5ws7KNOVEvH8UXqyi6sl98Ev8lz4vMcggbHiTQJrfHG2PKB/WjhaPZKrAxPsoiuhmGDI2I6TDn8ru6nFQGBESdflqb3H5wuQsA0h+jYvtBOPLNm2GV2514Jnfd8rqKqh2hI8K8W4u3eQeikzgAp3+85zoOMtkI76XqWw5Gc6kTUEMd39GnMpOrExXgezAJNCxf8iub7AO/sMd2FaFItfPMUcOlm3Vkxb0Qjk1E96feGJvVkfLA0ymOn0k0zJKNjzKLoERFbetaR6ivGisqU1ZBI9iAniGv1yOzaohJ4RgF6Bj/jSFSipEBqdiL7mGvKRB4m//fMAgLuiJUfCJ6S6KSua8ap7wJE8Tbak4zTm8PN6dTI3aasi69G4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the ptdesc APIs for all page table allocation and free sites to allow
their separate allocation from struct page in the future. Convert the
remaining get_zeroed_page() calls to the generic page table APIs, as they
already use ptdescs.

Pass through init_mm since these are kernel page tables, as
both functions require it to identify kernel page tables. Because the
generic implementations do not use the second argument, pass a
placeholder to avoid reimplementing them or risking breakage on other
architectures.

It is not obvious whether these pages are freed. Regardless, convert the
remaining free paths as needed, noting that the only other possible free
paths have already been converted and that a frozen page table test
kernel has not reported any issues.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 72a260007996..17c1c28e3491 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1747,7 +1747,11 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	pgd_entry = cpa->pgd + pgd_index(addr);
 
 	if (pgd_none(*pgd_entry)) {
-		p4d = (p4d_t *)get_zeroed_page(GFP_KERNEL);
+		/*
+		 * Pass 0 as a placeholder for the second argument, since the
+		 * generic implementation of p4d_alloc_one() does not use it.
+		 */
+		p4d = p4d_alloc_one(&init_mm, 0);
 		if (!p4d)
 			return -1;
 
@@ -1759,7 +1763,11 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	 */
 	p4d = p4d_offset(pgd_entry, addr);
 	if (p4d_none(*p4d)) {
-		pud = (pud_t *)get_zeroed_page(GFP_KERNEL);
+		/*
+		 * Pass 0 as a placeholder for the second argument, since the
+		 * generic implementation of pud_alloc_one() does not use it.
+		 */
+		pud = pud_alloc_one(&init_mm, 0);
 		if (!pud)
 			return -1;
 
-- 
2.53.0


