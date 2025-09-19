Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26B6ECAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 13:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870788E000E; Fri, 19 Sep 2025 09:06:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8217A8E0001; Fri, 19 Sep 2025 09:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E97E8E000E; Fri, 19 Sep 2025 09:06:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 585B88E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:06:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DE89140678
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:06:49 +0000 (UTC)
X-FDA: 83906024538.14.5C6F1DA
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3765A1C000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:06:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="UMx/vmHy";
	spf=pass (imf18.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758287207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5D2gBtzp3mLNn7VCJeOcGuzlcq9LYd+KGJxoAWDsv6A=;
	b=fXOpyUdpgaVzaGpmF5p53kjif8QeU+wsDNxReuLHoNjxQ8UFTFGyMr7hMSD8guzOmp/bhV
	hGvEsWbO3jpsTSHWXwtsMxwJCJ85nae94wxLW029n1jXBxeumH8MiLPDgBxLttD6VbmSFw
	UtOQygHtr+1d53pcUax7W1XRCJ92hlY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758287207; a=rsa-sha256;
	cv=none;
	b=VVVtIGurSBV5Rj+LNpP8qYu1iJTape5sV7vplHSOYZo1U++RQNO+PfGfQdFiVwuX5d01J8
	WEwhGUIIrlI1f6yw+Tuoq3Dp3zbQjX8O3S6HIBD9/JvM5BWvzX+du7CTTWSuy8yQiyeQmT
	xOWuR2iRobZ/uOKXF5BIQ1K/Yuu65Z8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="UMx/vmHy";
	spf=pass (imf18.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-244582738b5so17971095ad.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758287206; x=1758892006; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5D2gBtzp3mLNn7VCJeOcGuzlcq9LYd+KGJxoAWDsv6A=;
        b=UMx/vmHyhx5OJ1h4AWgG0suXv9jJ5bunZpGoaaJyLRZK/W4uVXiznDtdHzkWikXxqu
         mxxsAR+0okxGRfDamgPWCO6xEkhMtrqQvCYbJi/Lg5qQCthgsJH1byh07ZXoGbEoyhs2
         AN68piYkFGTYXXWilRt7Jx6qSMLOMqRDUP5FpmMpcSyCf+4XAMGicCVh3kRwAboPbqgW
         K0foFJ5b7msERmwy1GaqEf1C8EkWHmDp5E5sMVsSTwQllgYq8N65EQzTTegR4QSTLLWf
         z4glA1sUCRDhcosYt49e5WXduq0ysExvoIrHBR6pSa8bH+B95DLu6iKqGwczZz0zI5L9
         KjeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758287206; x=1758892006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5D2gBtzp3mLNn7VCJeOcGuzlcq9LYd+KGJxoAWDsv6A=;
        b=DV/uRlVpR0IShZhHlZb4J21+aJE1IelhT53Y5Ge3pXxFmsrI0kNPefMsm5upIljudb
         9bnQAyqVbK2rILfgYrY68F0082ZDcm4aAgQDBxt2BfYtXh0QGHKccPKV9ehjQkQayOBF
         cVpz16A1Hg8KOHiHQEk8qbSURd3ferS73lJeZ6bEJtuxDnRvAykE2OPTXAx2RweA7M5c
         gTtaHscfcjn755E3yPAuRf65N9FLVcp798jXKdPaEgilGyCqrbxRaro3VFZA3tSETq51
         5ts9bMkJUSVa1/xZ7ebRJRnbxCqGxwfb++2l9m+aYL3gsFpZyIHbutLFL2pK0kr0TptM
         K/lg==
X-Forwarded-Encrypted: i=1; AJvYcCXyY1eF5l+2/k9t5t+JaTxQ58zwKylDDenPIIwCOhKKYZVmAYaW4Ne84d1Uu6zw6wJcbgDB3WDbLQ==@kvack.org
X-Gm-Message-State: AOJu0YzZ203fKm/99jz6hHKIfHNXcy+vDAg4ofV5UApQMMycjNygiBSl
	kUqgwm4YI7w3UZ7sQUqQUFd+/Q4RrtFtkOHZ+J/Q3vPJJvO8w2FoWigi+zgHiFMRVu4=
X-Gm-Gg: ASbGncsWY7gO67rLSlQXQ6ku5bK+ztki/JG1ojB75jVLVKBqcCBO1LipgPQb1Ty6J/n
	q1LSt9BpoDjbIUMGu8nzOmorNRTq0NIPCIIPUvAKCpCVyhVTJ8w9WmX+qNOIQmTm01kkCX0psrR
	HHtRhRDLOuHzW4erBKUOt0JpbLORH0wB9qSQI/oDL49HRKONyJnfoQJJVutHcV5vUp7Lh13x9dv
	pH42J6LWZjitx6mdv9Pl19uRgTxZOs3gEdAa9VnQoswNZqfNHY/+j+36GmAQ+sUIa1eSICPZ46G
	5VhlgxSNXvrInrgqq6XIgPecFstfz29GlXVL1m2wIdl2aha/mBNC5ZE5sF1GhiaksNDWphrBT47
	7aJoy8fwNoD8BGxIsVxYrLLTnFKQrM5Oe1ukBKLUo6Nu/1y+ByiOVLPmmhQ==
X-Google-Smtp-Source: AGHT+IG7fMWI+kljj0ibuMWdDKEsXTDgf6PpZq6UXhyPEeUouJT4wes4hsUgSHy9QJ4Nl57jS05FAw==
X-Received: by 2002:a17:902:d2c8:b0:249:1f6b:3268 with SMTP id d9443c01a7336-269ba44c38emr56802445ad.18.1758287205777;
        Fri, 19 Sep 2025 06:06:45 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([2001:c10:ff04:0:1000::d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802e00b3sm54732065ad.90.2025.09.19.06.06.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Sep 2025 06:06:45 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	libo.gcs85@bytedance.com,
	Yongting Lin <linyongting@bytedance.com>
Subject: [PATCH V2 5/8] mshare: selftests: Add test case ioctl unmap
Date: Fri, 19 Sep 2025 21:06:17 +0800
Message-Id: <20250919130620.56518-5-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250919130620.56518-1-linyongting@bytedance.com>
References: <20250919130620.56518-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3765A1C000F
X-Stat-Signature: dcpzt8zwyhsa11rx897gc6mn9atqmap5
X-Rspam-User: 
X-HE-Tag: 1758287207-917964
X-HE-Meta: U2FsdGVkX18J+PN3cMYmx11vFKS0nsCvYK1mSSvm9rqLI8VWhJ2EXdotJhQ5iYvQhmM7hUx3Ias5LnQyB7tegBON2I9Y2JhRD7Cp+/888qChkjH6+omXJewyu5RASe2TEtbkXuHQrUD1zq1bCINOSOuweZ9a/HKZ+uxBdmb3VmDPG9VS2rTW1Anzi+WAe304EGtoMVrblwjPF9xnH7yj3xF5fuU+PZRKIz546zMHFUUqI/UqRXGhKXW4ux2mVzx5mIwr4RLM5Cj/Z3t9CL1H2qZpGdCh6CeIeOY8kYlj5R/sKwUALC+QPpnc9FLae7DzkpLXfCkGs6Qkb+4C1sOkaGhLgKAwOE0nBin1o5mxXJEArsqS1p+7AZfmtmzOlEjnANuI5L4AWfNTY2I8534B4d1H8h5JrsuP3b7qXKz1mmSibw0DPu7uFh3SNE/7tq+pbyIJ7g44fuZDwxIeX6odsxTkKnNOQrIISvKXIxZf/B/AETgSZE1XtbFkRheGtFRYrqsycB7/RuuHB/OQNXV/zgVsTCRCHoGkdcDA+tHORCB75A0oEwC2eE+sZlGZ1TIltDDCYhcUVuhG+Fs0+dYkeEOtgXv+4gcWWleWnMS4Z4xMylAxoL9Vc5QHlS6XDCTGLDSZesGEnv8zDjJZQ9IETkOI26iRL9vbVB4xwRaoAG7IDIUZvEOPfTV5jIXvtnqbhR7zpc8iOGAeXmg1CumzE/7tEXA8wweqKEcgLcX1ui7GrQln07+tSffuRTwIuYR7F2Yptk8JH7uZ4lMTbKl6LET2llSBLEmEFMVrc3+Pd8cW9/GNxUJHpJ2IbW0iz0QdlBgBKFNnmnkQhd+lcAvuhyeO4WWp3LUsCdFaCwK38pAhE1/k3SlvLlQM1lG2Vgj6po4b79225aienljo+M0irENGkD8PoyI1wRZTudNzf2xTY1Xk1vTHOu9sYdk+CDpCM+oR7rBjl/ipOITyCTg
 8TkAjq45
 4Lqnh6y8bzzqbUkLwKtq9l5eLOXno1xZKntxKMiqYL3X3bd+VVfWqgFCQO+bnONMlIaQcZ26rh99okOHxzQnSHszGgUaplh3YdmKxPWFuYBur7ynqs//kmYCzl8MpAxU6B5zE3K5cQPndnbSWps82jXrez9YLnQ2O5igVfcLn0LjlUi+AinGFHNq1Hk2LUN/5ppjdwRR1ZWxiinAzvjeyB3aj9fMlTurYay6gNev9BMSD52+E/NWRFRehhi7es4YwOAX/gvjn7tw8nGos6IEkh8gRn8mpaZwv+uZ2nBn97aAZhKoxQDoC1GHb0SnE2B/enI/e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This test case aims to verify whether the guest VMA will vanish
when corresponding VMA of host mm got ioctl unmap.

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/basic.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/mshare/basic.c b/tools/testing/selftests/mshare/basic.c
index 54a132a8116c..043d1f3e1e3e 100644
--- a/tools/testing/selftests/mshare/basic.c
+++ b/tools/testing/selftests/mshare/basic.c
@@ -86,4 +86,24 @@ TEST_F(basic, shared_mem)
 	ASSERT_EQ(memcmp(addr, STRING, sizeof(STRING)), 0);
 }
 
+TEST_F_SIGNAL(basic, ioctl_unmap, SIGSEGV)
+{
+	char *addr;
+	int fd;
+
+	fd = open(self->filename, O_RDWR, 0600);
+	addr = mmap(NULL, self->align_size, PROT_READ | PROT_WRITE,
+			MAP_SHARED, fd, 0);
+	ASSERT_NE(addr, MAP_FAILED);
+	addr[0] = 'M';
+
+	/* munmap vma for host mm */
+	mshare_ioctl_munmap(fd, variant->allocate_size);
+	/*
+	 * Will generate SIGSEGV signal as ioctl has already cleaned
+	 * shared page table
+	 */
+	addr[0] = 'D';
+}
+
 TEST_HARNESS_MAIN
-- 
2.20.1


