Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD92BC61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98FF6B0096; Sat, 29 Aug 2026 03:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4A7C6B0098; Sat, 29 Aug 2026 03:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C389D6B0099; Sat, 29 Aug 2026 03:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D58B6B0096
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:47:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0AC82120663
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:47:01 +0000 (UTC)
X-FDA: 85153525842.25.6C0A7AB
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4F561180004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:46:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FYDaaJGt;
	spf=pass (imf06.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPBa7pHbP53WE2M6DUPslMFnjHFqwGfpa+1GCbbSTEE=;
	b=W0wW7AYePWeeVHMmh9DZpokW1NYEuzu8JYrzSLfvotx27+lGa/uld2VCdmp7o7Okr9Nq7Z
	FgBTg7P9pbovkaeSxDp0NAFFhZm2kH6fiJFeLt9AmfYLNAKO0Rhl0T1C1MAuznHUfZTi/8
	yIzMAem9lKYRR+C+2exmVe24BYs2UeI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FYDaaJGt;
	spf=pass (imf06.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989619;
	b=xVuOEltF8UvfiAAW7H0r/i8bpkSUbxKQPB0X3NJAj7K6dPxyzi1dUZC+d/0Giz5PJTZ4qq
	RTxB+UmBG6OUiikCSY7umSijPCyWMfnkTTzq8YSC2wIUzRYHI5LICx1SSqK753oL9ijqQO
	YQUI8Yayz+g6dCMzHIvMxsv42HkT2Cw=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84fa3b14ee1so1671869b3a.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989618; x=1788594418; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UPBa7pHbP53WE2M6DUPslMFnjHFqwGfpa+1GCbbSTEE=;
        b=FYDaaJGt6ihpEqWnfc+JgPNJTg0V+gr6iLipdiKP/I3GUeQYVFmxrcb957B+dOtAxM
         SxE5JG4Q6xfiED1Dh6aLz4aBv8QKKISpmwD+jdZXeSO1y3xIDUVgbGVPAd9hTrNhv7Uv
         1RWpgWErCuRfkIWksvEjM8FEvTtoriqtlWWSLLb9KQ+Slx1BsA9bWvME3lOQHpPcrN/Q
         aI+Ew+clRk/mIEJ1SK72J68+uYHITXcGEtJivwl4o1/9uCWark2mKNmhrwJH5qZjJ/KC
         miEwBFAHWhCh4sdeeDL6JO1jBF7GmLt35i+l5CIHU0bkARxxIn2Y44bAKdS4L2FbeSgz
         hjsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989618; x=1788594418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UPBa7pHbP53WE2M6DUPslMFnjHFqwGfpa+1GCbbSTEE=;
        b=T0q/B5dn/ZfsRyFQkBhX6T3rAZ/rNapfr64almMvGlc6TTvGtP+4YZ93uICq/YJQ7Y
         p9TMU9+p1VPWdSCw4ZslDWq0S9PnE2Pp6+aSuGUmBvg/p5YVvruHWcSOYZKjLqzJtu9G
         2A3JfGjhVaJe1U4k/Ri71r9e7TmidHqgmLWA4cKHLAeEKTPO5xcsEzF+ri29hDcBMSs3
         Ci1JNxJYmQhAMzVWvZ8DQhBsN5+jWtAOcsS1Ke9ZHvTy7ZqFyCaa+pQNcLNmuzHv1SQP
         gU0g4wjEKp2Nlzir4RcB1hNJhBsmzDYTYhlYH0bO+/lDxSk4JVwVC68YylALOyeK2Vq/
         0Tvw==
X-Gm-Message-State: AFuF++kNbTDeNbjVFE3+f1DvxA3wR1qmrjQaoAFWV0sW10TB9WP9xaCj
	IKXp0nd1UnEXfLR96GQ76yd9v+QrAT2TEn3Q1RBSzdzSpPsEpQ26m+n8+4zJkA==
X-Gm-Gg: AR+sD11QjZxsmjA1fbhARgOvamqt5PlG6/+cdbiYvk9yCPODcpuDolT16a5FQBzsKkt
	7aR6bDxPRgiIIw2xzaEHr0VAQOUS+Su70fxYDUWLKx+jqzJGDWUa5+rWYVveyxcdVhFK1RDiI/V
	0wtxm8kQ8bgdJ8F5xFLv+uUjKxJaWVQM8lgwtR5O6TprhI0SC5fmRjnE8LklJTbgsO2wVd+6AU3
	A8l8rJ4sKFrHDk9MUThLrHjGz2r96I8soeGHoHLESAjn5H/F192qglM+YK1eISOSW+jxnsXeog6
	xi/aJX2qvz23EcJvhtYK4Rg7caB/Winv2js/XEv7wYx8e+i124tB5UtOSM+kAT80oKkI6TSS50L
	hSrugkHLbrchHuoig79E7A/tQ43I8ZsqytTWjKmCYgW5jIkJAUfqNZT7j9KoFiiN4lotnel1z7y
	A6Nn1CPb2MtqSxWubqb6lkOkFl2Evdv8uFWHnHIL0VGZAJtjIN7TYW+uTpHP484H0i2R86WW5V+
	6GgFyzn1R8KxiunzcPgz0IUfS+3DpD/H/uewTk=
X-Received: by 2002:a05:6a00:7607:b0:857:72ba:ff12 with SMTP id d2e1a72fcca58-85772baffdfmr7291395b3a.26.1787989618074;
        Sat, 29 Aug 2026 00:46:58 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8569fa79d0asm1310439b3a.14.2026.08.29.00.46.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 00:46:57 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: [RESEND RFC PATCH v2 01/13] mm/swap: remove unused parameter for reading swap header
Date: Sat, 29 Aug 2026 15:46:49 +0800
Message-ID: <20260829-swap-pcp-priq-v2-resend-1-68d3d925578c@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ntqiz9uqp3rknbymx66t8gt63pohepcc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4F561180004
X-Rspam-User: 
X-HE-Tag: 1787989619-622787
X-HE-Meta: U2FsdGVkX1/Mqyd93yjVR8TYT7OeGBXX5OLMFAT/EJVNq136mUqwyTpEBvuFt/9coBrzyZ139BfMrgvYb+xC+6V827QZQXZYB9aQUaNqIjthb6AcYqSxOHuMjhPL6ep3bG/U2SCBFPst3TQa47LffjxQPB4Z6ScJ0uIUuacDBMKAh2JALyJ95AZIR6yNCEOR/F37VD1ldKu9OPt0zEby6DDIoNlcX0aVB5vLUYQvlH0T+cY6M37m20ptXSzbQbV1f6uAruvK1qlTsScCEy6QSrmx2H6eOEst14Zl4LA/ncd7FNvRysrbjsnsCTHT80Xc9aOKEQLunhNMq08b33sI0fuC+g8NcW6U8G0qrLeE0IHxXnlQG5wuZ9W1p7N59NSP2OBrG93lUCQOVWgq2ZgCfPc5nXKF9EOe2JZM0CSq1913kKy+Y908QrcmarQmyG+d9kd4sMf6C7Xtp0kxszfnfoeQJ+FPw4t11S53rAqHODWYMwe99zo6uAWYF/2k8si6sd5BL03Q0mXyG58o2Cem4sLKBi+qRJRHNESP1wiWK/8g9abq1sWMucR/iVSVu6MBTyLLbBdYDCS+1wL897k7Iao8qjqVNo+gRxH/4vnyJDaRV5CsVR0NncyDM+1U6sNnGOOeHUkbpENR84zwJi2FSFFyF6FJcaLKKrgwCEvVgZYqJKjTb3slxdrzh2hAUA6gcHMhuFI/WEs3fm4FuHGWqGFRiiengP0kl3z2u4sqQpY+mOeZJ5RdL9mJRsPLKBsu+skI1oVgjGm08FwJjbOukb4ZnaBPkAnaHB0bs8zId8KfA0gn+CoqDVYdNVpMlVelg8Fgh3UKB8bRGzCbCF4/OtptJUHnl1dvHv7Fr21WevlOkBJn8JOqMedYyvWebUcUajzD+BF00/zIA902D1ocLSNntVYl6LPv4H+yQJA4JyWkjgJxNDs9GJMKUEYkxyunMm/eD8gtO06RZ+Gd9jr
 Ne/9Q4xv
 Dap/41Qv7/me+dlPjEP84h1J8vSq1Jp9xM/PsuBJwfKQz07GIbgfMCAqv0dGPNtYkIIZNzRPpWdfNXFKFQmaMu7Ad2EhzeD2PuKaynyyY6FDPQtArLfDhrBJCmeZ86ICycn3j85pOS8ZUe2A8ZIKz04QzoxskOO/4USxSo3MzpWXL97j02H0ggKFqCHHAdeEmYxwtr/zkAofCxh8qX/61drUNd6V90iQ9FwXxGTkM9IsDxrE+owMHtfk0lHpoYghBM2OT4tXknNS/pfdjZcD7shjuHPw6v0NicNNZWj+O094KGdxOEf8+K8jTD24OyuoBBYJ0CHn+syGzIZKV/SBJM4RNOnTFQ2FqGUYSGpqawZr3s1WNgMFbrip6MFhrfxLN5sJi0gpImLzBFDIeIhNZ/nL259J2iR7U7E0ZK03sMb/pe10uQOard1RLPwMoId4IyiYrEPbKYS9xWawUO3kDNUv/5WH4PKpHqT/3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No feature change, just a minor cleanup.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Tested-by: Kunwu Chan <kunwu.chan@linux.dev>
---
 mm/swapfile.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 53bf01d5f7f1..0f962cdfa5c0 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3467,9 +3467,8 @@ __weak unsigned long arch_max_swapfile_size(void)
 	return generic_max_swapfile_size();
 }
 
-static unsigned long read_swap_header(struct swap_info_struct *si,
-					union swap_header *swap_header,
-					struct inode *inode)
+static unsigned long read_swap_header(union swap_header *swap_header,
+				      struct inode *inode)
 {
 	int i;
 	unsigned long maxpages;
@@ -3700,7 +3699,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	}
 	swap_header = kmap_local_folio(folio, 0);
 
-	maxpages = read_swap_header(si, swap_header, inode);
+	maxpages = read_swap_header(swap_header, inode);
 	if (unlikely(!maxpages)) {
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;

base-commit: aeddb4d52acfcc5ce5e988acd48f2906fe966ca3
-- 
2.55.0


