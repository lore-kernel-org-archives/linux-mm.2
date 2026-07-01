Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5E11C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 17:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5CE6B00A9; Wed,  1 Jul 2026 13:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D8E6B00AB; Wed,  1 Jul 2026 13:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3236B00AC; Wed,  1 Jul 2026 13:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15B8E6B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:19:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 701351C358A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:19:12 +0000 (UTC)
X-FDA: 84940868544.13.7AD25DF
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id AFF2A20005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:19:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BSf8gzFz;
	spf=pass (imf13.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782926350;
	b=ZmfgPKYOIYCujG/ehFsEy7fXC8pOr+XuiWQp15fmc9eqKqHzJ3ICEI7xchbcrNv1lW9jhJ
	0w/KLvOgXl+j4C6OvdC+r9H6R3SXlOO5vv/8vJjfWvHo/Q7EwM1Z3gd8yUgxZp4ZbDoUZL
	FBEcTGT23BoAFjdnh7hVvaNYosddevE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782926350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MDuqDP6jfkHa+poyWLUCQVCh41lLbreNnwDZhuoCFhY=;
	b=kmemfS6oXa74fphfYRaRDHufcyLUnm9xV4sCkyDu7qsyu6k1JxtM/OzAZDKCvH9wy2ejHu
	BM/cu/PHkUgshnnkIx3pxoZojROIA/VZyAoO9eXtT+65U6/7ytk1GFKF/XsB8DVjLXZ+7Y
	2CMIa6pYEgsV81V2Va2kzeN0fpynhl8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BSf8gzFz;
	spf=pass (imf13.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-845ea8924a2so473739b3a.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 10:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782926350; x=1783531150; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDuqDP6jfkHa+poyWLUCQVCh41lLbreNnwDZhuoCFhY=;
        b=BSf8gzFzCzdQ2RzBzNPVB63V4yjLyNPOLUnNCp5BGE0xr8kZoCSzpifNCsIpgnXYsE
         qOd/C6dyJ8UwBRa1rMISem/K3yDJH1kMloRufASu5zGVjniIrmCoMu8z2TddML0gXUU+
         xrvL8ilc4Vo+MGnob5ukXtvFY4T3MxgcIkf8wNrFYrbDCPUp059jWzr6u3R+wA6wiomt
         QY9kAbKDNrAWju1rom4i+H6xwnuV6s0bCvdn/b3p9UOhkZXtuTPjqiG4YXljEzXbkK7H
         /d+9xnmDndK16H3GfwATOTndJT8bmfaRSLTy6NfOzABII+ZUWKz165G3ZCzRj6V9gIbm
         FSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782926350; x=1783531150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MDuqDP6jfkHa+poyWLUCQVCh41lLbreNnwDZhuoCFhY=;
        b=dwBmacgqJMv8MF+gEEz1on/kq6qTWVJsrTG7ZNzj9O74RniNJK4vPokghEv6IdHzBj
         onkeaHSZlr7ryPZs8M/pkw19tE28ClwVbpaee/XZ0dnSW5EtUPgvk+xLPEVIOOKhMKO7
         /YKmup7xHMmUmkaE6HLriaIOd0n9tPNYU0il2ZCCRHuF0jOydMNYufVFOJYIhQ4KKTTe
         mlYiMqHXqSGKO5dI/ZHeBYi1fqAYvoT0wcsPmJguB6Wu4zhs3CX4msxPKnj38wrVFvgm
         h0mNCRDX7oqGAOrLIxFqgUZxbRRjLhsE/3tck0x8GmLeFcYvLWREqPRVWlxGipTPwj3C
         tAYQ==
X-Gm-Message-State: AOJu0Yxc5MgfUHXVkfnVaC0FB5dW3HUJcW4QwgiyxwsMYfh5a7RSoDJf
	Skq/t4h1FQm2oGotFb3IHbv+9m3xcffVhRS9+8jKEje7iwjiY5QwnPkg
X-Gm-Gg: AfdE7cm/Klr+3N8TKycdGdb84gT3SoHUcEPaDtGx0Z8nXESyV1ebHvtN3LCJi4gKkWg
	GLv1tNWQD5KKp2ebYvBdItXQyxqKM82HiTREN+l0qk4FCiykoPaHv+6JTR5V7XMz7lhNyiyVk8Q
	Kdo+hTWgiaJne+hQrEMrCfAgsCzSeIj4UWZFtx6uJ8cGy81yTuSK0vNAJUw4H/WxKsILwstUdCH
	Dg3MI/giD0lCKyzTAFVDRBh87yFX5ZM6Bxn12fqB63TMAKwCoEX/Pv1aec/t6Ji+qzLdDjX3RAE
	4HDtiiQHs07wowmVHQhMFUVA9TzSIu1v47mv1ELqnKIS/yrnrAqssgSCZfLYTGmT5GCwqLDWGgv
	yEgVJ4FaPuM57R6CfN0zWlUf9FExNQ0K2ob/vR2espS9qc0Kl6Ccydg5ELjpEo1GBprmyt9dr/J
	oaYzZ/2fQ=
X-Received: by 2002:a05:6a00:4b04:b0:845:e97d:447e with SMTP id d2e1a72fcca58-847c07449a7mr2509329b3a.26.1782926349508;
        Wed, 01 Jul 2026 10:19:09 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb94ab79sm105719b3a.31.2026.07.01.10.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 10:19:09 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	linux-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Rich Felker <dalias@libc.org>,
	sparclinux@vger.kernel.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 1/4] sparc64: set node_possible_map in bootmem_init_numa()
Date: Thu,  2 Jul 2026 02:18:48 +0900
Message-ID: <20260701171851.2447626-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260701171851.2447626-1-ekffu200098@gmail.com>
References: <20260701171851.2447626-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: stoyde8zgsbiqay5j34p5qi9h5nmogp3
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AFF2A20005
X-HE-Tag: 1782926350-83944
X-HE-Meta: U2FsdGVkX18399oB691x3fEU9aWReB93Vg6AJ9Fv7p7ORfXJ996Ara1IcCAzHNEbT1hl4u2apqezl5ZdNK/HTSsB1JtRifBtLGrMIA07cb7AQ3+m3MPRpoOJsIlvC/9Xi9YPUZujZxbkiY4Ydts7nGs98fg2PIUfqgL2zPRxnUmoVP5Qj5lthOUQNmaxuxdOzqJAlK5DYJI74XuZzn9lWSBvMBRzjOnyW3zYOiu79LEyO4hZntpTwIt57+kPHspdeKhsiGvl4N+N0A/7asJWF+wHlcd4qGi/V5NQ5bFjvP4soQuvJLfXWvtfJ1nYIKaJvIA/mTzD8rXMYf6Fk4sKfFvEREO4OXKjLzdUIkFUjA3iX+5Nhu8s6DEWubO1sj2S5ASIjFx8ZQRVb1N5HYYEoYr9Z7NRuOOXs2WDXGQ4lpN+z9FmWQOWT3oKM7zlHWHNb1l7joXUob46XXrWhdiuNaPHygHnXv3roglpIKJrWcdttnVu0Vj+BzD1W8YAUat/HnCWjS+Ah9CqwohqbFOMEXvUlXfX6acWRakqo4wEuExN5Z0PZ1QdFZKq2PEa0JjzbcJjtHmgvMNT+MHxBjiLfixORSSXaJzH+1WccByrKPUK2NI3oTD9lMmxiW0vMglShgJEuPVJ3kDcIt3YrNe7CEbgfnoRzGiAqvkJrYUNICLj2c10my/o8dlaq4N1kTv6/Wg+QTjpbzsWmqLPCam+xPlp+7gQPv1qBt4BffoxvSThKMFyj9Hmu8W3vgCH3b3MDJA8Rus7iPg4kH6x2bH+BxPHvGyhZvb7IO9R/xT738vytLPZAJ6RapH0THr7rGZtItGBGCa7qTagM6AJFSwnqwQc6krgqaWvZd+tGs7G5QIh2iY2/dOd7L5przlzRUbizggVzVNU0hBPO3bqVQPlx1v7Wdq6BjbiYujFSIzuaBE2R+9nq24UxpY3kpZ28wKYsiF/c1fxSslKUmPSF4j
 FSYcUWRp
 LhbIlmemioE9x7aPCKv0ZC+RdflXg7Xju56r22pAT6Z0Gcs0RiSjVmlRT4sKEUfWDHVDMqEH3CSMPeA/LwL1q+0Epvxd62/DgQmnsdxlXbSE9Uus1XdOnVYUTS0z8qWgWiTRa0SCj0XWOqSFPDi4l4bdj4kLi/jn45FyX2CaNBK7FNlNPteO2PmDp/BocF0TwM4cRxl0daKVYTB6hALJwvp6Czb2T52HFGvWv9RTRF2ffb5ZB32aHfivKuDVO20s0Hm52T6lS3ym/vufLpo2izLIA4QNox6VqBXb8B71C2CLWKKT0N3mMBvk+xdzbbrj3WF77q6/N/4V56ZIGKFbyZ+pkRCYBlaK4KLvcf/Kc3tT8EqMzzyc2uUatnyIZa8pzCJQiN0zmHB33z9UdZWMexm4VfVD/bvLf+zOtziVYiVG8KiMHXapgB6SU76OE2c07Rx3dzRay6MeRcxIXeuwLH/H+3owP06DLf20hbhV2w1TA2/P8c5C1nmCRTs2EoKN/8D9ZfxZEmAoQbp//GOUrPeN/GQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unlike other NUMA architectures, sparc64 never sets node_possible_map.
bootmem_init_numa() marks all nodes online and node_online_map does not
change afterwards, so set node_possible_map from node_online_map.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 arch/sparc/mm/init_64.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 103db4683b16..a749f63568b7 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1559,6 +1559,8 @@ static int __init bootmem_init_numa(void)
 		else
 			err = numa_parse_sun4u();
 	}
+	if (!err)
+		node_possible_map = node_online_map;
 	return err;
 }
 
-- 
2.43.0


