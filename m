Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84367C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 04:14:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67AB6B00BC; Fri,  3 Jul 2026 00:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C17FC6B00C0; Fri,  3 Jul 2026 00:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E026B00C1; Fri,  3 Jul 2026 00:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 89BB26B00BC
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:14:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6EA21202D1
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:12 +0000 (UTC)
X-FDA: 84946147944.21.4FB4A10
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3467F100003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BGeqRDbm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783052051;
	b=h7vI5XaXdwCvx0nnekzuuo/gp6Myzu4oMvK+dIi9/DiiDnR5V92UedH/7iqVvDbm/xcifA
	vcSfAq4oL86ugtzFPR9rMo7P4/FUuqgPEKjUQoH/m09xe23dtYhkK3dAtZ4XJc1NFiq7eK
	tr62BcalRXWxThxPH8gkkeRVaHZSwrs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783052051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRhdKC6J3CGktR8i9gPIvTyx5V3X0kO6yzDSERAhYeg=;
	b=EOcbFub3RwXf0z9YsZvrLA9wE8o7UCP0gVPN0KfXRTlkBmmB4U8oT74sfIQ6su2f7bOuV9
	G2GolG6Ld/gPk+lfNJ3VDa3dc7P+aZliZTrUqeG1K0ehECXI7m425rVbgdyerSwQhJFpnM
	Sw9itNUdR/PVyFNlakWOKPU1sNs8Es0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BGeqRDbm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-847a69ba83dso94871b3a.2
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 21:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783052050; x=1783656850; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CRhdKC6J3CGktR8i9gPIvTyx5V3X0kO6yzDSERAhYeg=;
        b=BGeqRDbmZeLJoVs/maVfcDcku8dAh9n6ksrD1Wq5fmpyqnJpssHKwJU7oB78ApMQW2
         OW5lnu+BBIZLSFRty2DSL05thJ5YQE5Lzd2H03NzWS/JcyJ0cop3uTfI6SUBl5RMyqrM
         HIRDmT8m35YAil8pOQtPV1ojcOcEg/rNMJbhOmQrJG/yCVKmk2EJft6OnrB1/dNx+ig2
         c30HLK0obDV9lA8HwwJU/nn4XJ8nJNDSCk04GiSHruoI2dz0nGAAfWJgWal8yVhnxqmA
         c8A8iX/9t1aYyRP2ioRnN9/r9PdN8Vyc0Ka0NC1ZJ8F3jByJLRGMwKpfX4AxsGC13IUS
         f94A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783052050; x=1783656850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CRhdKC6J3CGktR8i9gPIvTyx5V3X0kO6yzDSERAhYeg=;
        b=I5GY9tenRvpbTD/iLxLJHP+YBb56+jii/v1LHabJqb8b0ja/VLefIgdPuerTM8LyRl
         3Hgbi6OYDXg0d7BtSMsk4MS4GdZeVzCdNa8WozUfFgQyHBp9GEl7b9cvgOW/E9AU9qw6
         MhBizFTro26o17UyyK2i6kOrcmT/dHG3I258Fai6N4y0kcVP6kuz2W6nreD1up2CRZhN
         +x5HD4YQ79L7xl41XvJp3UddNHSVimr+VsAN/P/FfSrCn9mWQd68dqN/HBIxBpgeoFYo
         OLkZuzyt6sH0vIwArBPvAMUxoFEc9kkaLPIKjjT344Y7c+B6qEiwN2YAFXIVmdq9WGEh
         +DNw==
X-Gm-Message-State: AOJu0YxmfCqr0lAcZVhLP0cFUggaPHWZUU70/UftG1ycNHSjW134qU3n
	qhB+HJktQMQ8KOBGrmNpP511Ltnw4T/4VZJ//LH1qccfzhz7pQatXxnb
X-Gm-Gg: AfdE7clDgIdCkGB8aPMoS1MUAQFqtyj9zoCafZpmBDG2NCQXVD5eAgTKzGqqwXPkCaK
	AoTxaW3oFhIHRYAbMDN0y83LHPGgM5MNW/u4XEdH7Yx4WCxObfo5Uu10Pc9RiRctLFQwbDJp3XZ
	Yf13GBeoMHQ/mkNV0GNS+Ca2AKEVo5Wo+Qd7UOtyzeLOeXkN19MN9yJi1U2S4y1fx9p3U7/avHB
	szalJU/1uaft8DKbXHlynLxAf6kR8295lgq40sTKbgM9xSGHcahPpD/I0kN48864O4T5OY/qkY5
	ZvbJL6cBF6jApPzSiGRrLjnsSNuJxjHIU2boyclIEKMxoHcGLbT0CIvdtI0ZB18lwMV+grIKEqR
	gpLQzboPVkiPgTOASYiuNdRAkuOhlR5Tsxgs7OHaCuD3ZgkJzwmzp1Ztjh/24rva+B2A3eZVeh2
	sjtdb2yB0=
X-Received: by 2002:a05:6a00:c92:b0:845:4126:222b with SMTP id d2e1a72fcca58-847c0847e56mr9523742b3a.28.1783052050061;
        Thu, 02 Jul 2026 21:14:10 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb94bd7esm2207768b3a.38.2026.07.02.21.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 21:14:09 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	devicetree@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH v2 3/9] of/numa: remove redundant numa_nodes_parsed node_set()
Date: Fri,  3 Jul 2026 13:13:23 +0900
Message-ID: <20260703041329.2797584-4-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703041329.2797584-1-ekffu200098@gmail.com>
References: <20260703041329.2797584-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3467F100003
X-Stat-Signature: hj5atzwunnuw71sbo85iesr97do31wke
X-Rspam-User: 
X-HE-Tag: 1783052051-909013
X-HE-Meta: U2FsdGVkX1+NAVKYIpW2U88QcuTxDCDgsP0XzmrN6QM/fLKr88+cNH7C8HZZ8MNMLreMqi+pmaSlgUyAzXDKo7VX+aMgDO6DDUlSZuTMMN/JRLcd9BKBaMhKvPD+pdCJiY8jvg9PgEnAuC+paPO0Zku3ecp6derSE9daLXwTikmm0134gh7RWJFcVEaNj+/GMoPEUZQksP8oIWkmxvHc7jts5gfc05PyuRIwZ+XbYLzLKhvpgCpcVPNvmwuTILhHJ3faN9sJ982WYxmK5UCNSCjDytYt+BhP37q83E1/R7t81IFSUeR04ZeCrQPWS5Y0aqsF0ZhB99q/fq6FhFZckkNp0Y5BAcd3v2le+aUx3Tyxpa/MrJ5KVsDR+ZqozqisDTTBgaFSETZXxCYC/y8KKjYVvMh0H3jK8++MuAL7JAExFvVop1uv/N06W7mfU5dJJpq2xX813JgT1ymfNNYp+HPRu+fb5VMLDoBs8oE2Qw+8nO0I53FO9hfC7IeNrnadLUZUsDgOo9ZhUxV24RvMY0obKubMlCdlvvxiMMGU5fER2S1qDA2uWfbXzb/1wPTZ9vP4kzIpOB0XAk9DGG2123eLV8FO2mmI1ntsguhiJKyp5D6vWmxmSts+ALo8qzfDD9r3xx5QS7v2YdGrkaZZvDrB/7VDPwoiRxeaZp4fP73hJKOkU2fwbGVCRwUAr5t/HujUbUpE5GZU3EoGGD6GFzsv+SbeT06LZ8xheg1NgDIqaLRoDii+1/gm6LvfhWkz+MxEtmqk0mEUvPEkfc3OhGbdpUA7N9JREOJlm8GJcXaPCiAkk7Fj3A8fN8Gj10J2HGNyCSFUfP0WKygEEuS06cRvWokStyr8akGHRtFXOfPZvb9+5Yu1jxm0e2VFyAAgXviN9KOMlYsQjErcX2rL1G7+60CsBKQvtP9YZZ73xdQ9vllQLT1ak/oyvrplxxY8JNkFTQpWgLdXdr61C5m
 fCX1oXLV
 iu/PzEeU1VHEmea33BH1vbr0SNwR1MkVoyrp8IxUll+mBnVQ7uK/6zWQIY2qefDLZNgpsb1Ddr8cyfS+p9OSmEvizsIoRSoa6ycAYFAay+UBx116TeWKCaukOiwRloxBQwI0GKquR6RoaszRPZfQp4KsaitcelDs6jPfsoX7+nHsN6h7GPISbRo7KABzJn2kDDcW2JGLO+JexBzulMQN7V63Tewp6FXQ5wT+nDtHKSC2fmucJuIPzOw7fMql4hzpp7f9F6uAi5q9aqswjuhKMYc2qmfTDgt/neaqFBL5dvr1nCXm1C+hx2ElrhYTffQVFs4yPKpHP9FDglqghy371lID7CbOUbjTck8Ov7qnM5lVBCQ5RTut2PwHQpxQQjJJmoTbkyBTJpdwhhFBxnThEj+MHDWws470y0t0p6wX4Nm6bJ+IOTOBhm9Ek72WvMKVSLKNFcFo64cEbdOnZBo8ZHh6Flv33ej8xN+cnEaeWFF9gdHI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

numa_add_memblk() now sets the node in numa_nodes_parsed itself, so the
caller's own node_set() is redundant.  Remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
---
 drivers/of/of_numa.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/of/of_numa.c b/drivers/of/of_numa.c
index cd2dc8e825c9..230d5f628c1b 100644
--- a/drivers/of/of_numa.c
+++ b/drivers/of/of_numa.c
@@ -59,11 +59,8 @@ static int __init of_numa_parse_memory_nodes(void)
 			r = -EINVAL;
 		}
 
-		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++) {
+		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++)
 			r = numa_add_memblk(nid, rsrc.start, rsrc.end + 1);
-			if (!r)
-				node_set(nid, numa_nodes_parsed);
-		}
 
 		if (!i || r) {
 			of_node_put(np);
-- 
2.43.0


