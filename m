Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 608E5C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 04:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A4D56B00C5; Fri,  3 Jul 2026 00:14:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27B546B00C6; Fri,  3 Jul 2026 00:14:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192A46B00C9; Fri,  3 Jul 2026 00:14:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0FD46B00C5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:14:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A3828DC46
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:24 +0000 (UTC)
X-FDA: 84946148448.28.9BDD67E
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 735BC40002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vb+j3Rlv;
	spf=pass (imf07.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783052062;
	b=O7OfAQVbAr0Um/W0UcqBiNLY6eie9hGnMAsRwpoGsHdhF9UVrqUS+b//Crcz7/hLkvK4nE
	K/tMzv+grvBCUEuUAjhUeqk9sE2FBJ0P2jisMk/+4GqNu5FAA4EN2PQZNBwtb0sxzyEGp8
	9NwuH4i2WQ3ktNjBWmwrZ6bZM6EaTsg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783052062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6EZL1NKnTgoPS6ISbktoUEUb6WMEmWM4FtznnYOJW0U=;
	b=1I9dIV/PmTecB6Z7iX5upu7vWb3rYOHjxEb4Z6B5SkihEOHakganUoCcjE5rncx1olnLub
	1a6mhic7mgT8PMnewRlMmmVhKm4+2XlCpb1n0pjMvj/ElRTwPyeJqfa54L14BdoR2pDPRM
	W1dCoSQFdoBlOYHMuMuOf/E6fDT9xqc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vb+j3Rlv;
	spf=pass (imf07.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84592b55832so92439b3a.3
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 21:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783052061; x=1783656861; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6EZL1NKnTgoPS6ISbktoUEUb6WMEmWM4FtznnYOJW0U=;
        b=Vb+j3RlvXHkPuDubIS7opi4t4NgzOX9aV880bIAbRypY/fhMtZ58c5NUcxxwo+Qh/f
         E82s37wB+BdxqWrixadAc2BXCG1NW50iNHwJwZCUeKYxNBfIBZYxCEvCu6YXkNZxXr1Y
         L64rVihcz51UMZ1jnsJ+unbnpaxswrUEdzP+TcA7y2AodsyCt5Qw5AnplAmlwQF4HKNy
         bO3yNug+wc+rGIHHLDTyf7ODEvF5FR7YgEcxiHT1x6BNXoDVyCEAWZANciBzG/OE0KZB
         bwA++SvBYWWZUsgc/glvbQxLQQLD4FolFbYypL0e+6wAhI97166J9gg9eWumJEEJ0Hyz
         wbzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783052061; x=1783656861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6EZL1NKnTgoPS6ISbktoUEUb6WMEmWM4FtznnYOJW0U=;
        b=OxEPEP6Lq/wBUYGsP6VS6mGmfq7/PPmhwKFredlEKGkEN9yfHOXXViRiyPEUk6MQOD
         Enc5XVpdCwlgtjhMCqZn619zvA/xZveuzq4ivHFhCBrVPCZPWOOfula6hEPeR3cuZpw4
         zvhi3B+ZL7d5M+DH+Z6LKDMK77Bw6gxgOxJBZarfHBPSh5UZfMZDtWaQLDveS98UDZmj
         1vNPdz33pu3Iayz/PjvBl6vybBwHJvsEbdoELQll3Da53i0rt6r3syQp2QFjeZ++k5zi
         Eb55y6mGjwN2PuF943qCsNJbVmyeFdz3yo4VEOutChu9wZNwvo5u2guLwNKe3uM1SDIT
         18aQ==
X-Gm-Message-State: AOJu0YzV8kVfWUnwat8inoQe+DeWROmrN5hGGnYT6JJWHkYTPZ2afJ8x
	XrUfmZqOlTYSgEhLUfCOXKwnc1ttDTvVk7Dk1NT9upQHB60hW9SyQtNx
X-Gm-Gg: AfdE7cm9B8M0CrcjAJcH7ggQ73Q8FO9LTyQ6G9OS29n/RlrSPx9M+t4RTXjjyw9BODS
	Y4DoMQlnWsxpGb5xB69zl4BnXIWfC5MX7/IPIbsmAhE9C40JvV7WRr/JXplBnIxV63AKNjBfM4A
	yOnjn8fBUew97DY1FlwPLcIBnRSyz/uP9ETkivMDRsEh3DwZ/f//uaWweWTQhk460wqCjInQgQp
	KRP7p3mKf/s/9r9Bpe+J98bp7gjzOXd044997AbqUTIAZcMZFTy54DsA/SlfBVUvRVHPuka5+Mv
	odpoyJGYNuFv3vD9x72h9ZNa0wnYlA9rFpXAQzmAuQZ4zSz3T0ksohfVJjK0SZOdhkAZ2x0kzm6
	ZIAs6VxSIF7pBm4ENmVkgU5YWCfSC2QCMF9CCFFELsgVXMV+8aoEvKCwtN7gvp6dFSr6XP5922N
	HbcxjS9T0=
X-Received: by 2002:a05:6a00:1302:b0:847:8ccc:d7cd with SMTP id d2e1a72fcca58-847c085b20emr8662798b3a.37.1783052061259;
        Thu, 02 Jul 2026 21:14:21 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb94bd7esm2207768b3a.38.2026.07.02.21.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 21:14:20 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	driver-core@lists.linux.dev,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH v2 5/9] arch_numa: remove redundant numa_nodes_parsed node_set()
Date: Fri,  3 Jul 2026 13:13:25 +0900
Message-ID: <20260703041329.2797584-6-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703041329.2797584-1-ekffu200098@gmail.com>
References: <20260703041329.2797584-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 735BC40002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: jk4o98nwpm1fiuyzuytb5utkbbo8mgtf
X-HE-Tag: 1783052062-97573
X-HE-Meta: U2FsdGVkX18eju2L9UpPe7HNCzGcUbarbLK4RojlJ67qGieMQgy4/VPZ1TK1VJCCKZHdUJO8rz0LkQhUjALFlNXR56PiZuIEwdEJjmEGRCXWD9/d6CG9tSQt18vECdeOOkk62o7DLn1jTLrNSKjUxv8H/Mdkkrka+/uSnSFaS86DmudSgk3gX9LJ15oMT6aoH/64ZbsW0yUXQAbwPjytUD8okzstXgTksEr59PbW5SXpskj0fhyBJBUflEt1rzn4lc9JXNb7aQ/gEa4uVwHnLrodOpEVd2JIsr5aSFk2NczZGRfCZdmGxAHaL005vUNRubqTwXK9F3H4yDvyO46n9Yaf+Rfoz9r8eygW09uPyY2e/eeyoRzjqUmazKrabehNrx45ipCIAvKe3Pz2waruS1NG/009Xpg06ESny9ehGieTBMB5Q+ZTlGURImV2DRhT1+K4McSiloKH2JMEsnc/EFBR79UmVBXluZ+mxLtSUZCgKx2o6UX+WFKtnS6nxoedOTfexBVpdBT6XTFFf1TMDCU8thc4X06nDRLlOeHxarbGs9QWMRtOC98Zy4yfRBGW0IoizgemHCQ+9NCQ0Rrl4IKPGxVc3kPNa6TM0lmekZiy3ZCYP2YyPghaCjfkil1uvZJEeHii8xH6o1BmvM9qN9tLkY9GGzbw/iA01KnWtiwuSO6PkHnKMkuFiErPcoslmKWUdo6kHYdWorAalAaz6CYL27vcDY0HXje1z/aAvtEe+JMJ3Oh+N9+FUJy+nTlgOlXLjPI0XfYlzUWm0V33SfiRjIR4tpX+ZyhxT9MzaQRbZm/N03TX3BRCnRnjEmorxVVSaTnvmDVOF7BcyrMg1JyEnbcY+Nape+wc9lm/mZAtUNFu6xpwUtK8Gmg/JoJF5R4/84ihxYXBUt3irWY6I9pjRSYDrzoWnulsP4/SHEhSAfHRKLEYVEBrY57nyqQXlwArpGwCMpZ+JI5gYVf
 b6DYRdVF
 qSTg1lm84SZXS3BGzOhSGEbJFoLYEuzehxU57k/7wwyUkjkSEbBXq6goQSiBNpq+1IrNQiBsc/9Ylki0VMgnqp08IP6vUBQtEBMwsLzXPizyz7YTo/UOLidUHjDRlAYUsXtrqSlNC8SY0V1dWQi7OQgWNj6rtzNr9lZEPzdr8lZI0ov4vFr1mcA8to/8Jf93TIlRKf6kCWAwhSX0UT/L/StacjYoIb6xrPKq5jX8Hv7AJVt+MtMCIObfr6mqzJjjImVcbnylg/Bnew92yaLrzZ7+BBd2XH8cuNPVPbiYBSXhLxn5n4wKdVsQHgkCMjAahUs2RjqTZTL4yHokoPZ/UDbHryo1VE4C0GG07eLzGVPbzC32XWeqFNPowCmweQmbx6Ysv2YFvo0EoxwC5yUwzOk+hOQsQj6wgrPDkGIlcg3cPE0uZIKoi+SHsEPwCYVkLLmFTYtGnt3Glwwc=
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
---
 drivers/base/arch_numa.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/base/arch_numa.c b/drivers/base/arch_numa.c
index 442ea239bba7..c7f63c4cf367 100644
--- a/drivers/base/arch_numa.c
+++ b/drivers/base/arch_numa.c
@@ -279,7 +279,6 @@ static int __init dummy_numa_init(void)
 		pr_err("NUMA init failed\n");
 		return ret;
 	}
-	node_set(0, numa_nodes_parsed);
 
 	numa_off = true;
 	return 0;
-- 
2.43.0


