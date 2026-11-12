Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 917EE606A333
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zK+gql/M
Received: by kanga.kvack.org (Postfix)
	id BA1C06B05B8; Thu, 12 Nov 2026 11:18:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A6C6B05B9; Thu, 12 Nov 2026 11:18:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91126B05BA; Thu, 12 Nov 2026 11:18:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C42D6B05B8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:18:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D9CD80600
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:18:36 +0000 (UTC)
X-FDA: 85426975032.15.F51428D
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1C24E40008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:18:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="zK+gql/M";
	spf=pass (imf07.hostedemail.com: domain of aleszlucero@gmail.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=aleszlucero@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794500314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HBl3rmjqTJ1pLrzM666SXKTzJ5qZqJJlIpCM3zMhhDQ=;
	b=k6EpUu9LTQ5bXz2COrNyC1hE1ozYiDcE+Yu7siMgwxq6hyvwsay8KIVcz7VKOcrw8DfEjp
	EbZ4EELVTiQ7uOBJ1efKNbNUdakXz06N9R0EMeQ92VsUL8vlzKqSwzX5pNhocBeq4jtBgQ
	wMgv9CfE3It8Q9J6lhBLVaMXe0j2DuY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794500314;
	b=Pp7Fuzd5jx7lXV2Y7qzr9ANxEmF3BI2ED7EQAGucDYS+V4c3E3JGE009RugOErWU/tCPfS
	aX5BA8OOGAhuBZWDnjGQ3ZgYpJsnfGQGT0lg0KcznHdrGd/EfwqHjii/Le99XQYP9EQtnz
	iP8kM0gO/RjNP/l3ekwmUb3Jeg3wwSk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="zK+gql/M";
	spf=pass (imf07.hostedemail.com: domain of aleszlucero@gmail.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=aleszlucero@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5eac319a6c2so33623e0c.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794500313; x=1795105113; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HBl3rmjqTJ1pLrzM666SXKTzJ5qZqJJlIpCM3zMhhDQ=;
        b=zK+gql/MyluHr3ROcgeZmk24x+3AQv7vX9dUFAhHnBerid9kmqbL+lpx7Tgs2nQWG2
         VAleIv/jC1dQmyyUYAcXni1HfxKwat3jQr1ahCiY1IBhHUXIgr1tRjhEhZTQGH1djbIV
         lWE8H2fFFAUcnIQ7Zppk07st0JJILgxgvozxQN+s/skwffSqCzYFiRIhghH1mAKrk+7T
         uo2otLo8Scpr2RyexBcWZqfPWHvYkE5WWmy+XjOxokuefrXrT06k9ghf9ryEjYWQxP/g
         KEiVnJh/T7Cba/0hPIqayXTdhNfRB+nTYnvrXXO4UX8To7g7TsSAbebOxIhnPEwBexDd
         I8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794500313; x=1795105113;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=HBl3rmjqTJ1pLrzM666SXKTzJ5qZqJJlIpCM3zMhhDQ=;
        b=zbApaFU8EIIhvfyisnl3MRu07uZ7e61BvcrN2emETTaKMKTt5+g9FcE/ENOyTBFGAN
         +lbs2Kverm8ErCP2YfZzX1xSBVMftIJyksrBgJRigZF5XmPcJmfcR8v4AaMA/pgpuyAq
         iIaRZrhCLzXmvtVxQgaIUd4VRgvk+BdL7KkWnhqBfDD49QDVzpgMQkkfbRl55UdMfE0N
         l3cM5WZB/4y7SYNdUYumk6MmihbzQc8xM8NeeZnHa7PWzw85LnNhmxkvbD72T93MUlqd
         +G4ZkUlQhdaU+wvzARK5tggWHes3MscwrtmxvPjUdy3Lrk83yr23oLZeGkxlHBTExl1H
         LRwQ==
X-Gm-Message-State: APuU4Z+/3LsZIEuFMjDYY/GTBvTbVuE/u24fRsazpZH+D4we/o6cUME5
	jQeguBsDiW/g7mzX1PHJCY0/txAP/UkNzCX8ZLTTB+3qfBDcgPd71rqu
X-Gm-Gg: AYBFou0UFPj6S8KN6D5tG6SeqYU8gU1N7k0X8Pq/sX5yfHAd5nR3+eDH8h+eR4hFEFv
	wSSg1awdJ1FYgjQz9JIJ5Y3zqDI4MCya0ec3aRPDMHNb5Z+1M/4Kl28eaDOAKRO17sL3j75DN+P
	RSsVbVL8+arcn7KhP/0Q9g7Z9BMTyJ4NgI/2OaJPan/Qhiikc6XBJyYdzya5AYUDTggfN2Ojp9+
	hrTpxOPe1yAlODYr0r15pk7DUSQGaBLj3T8gANwMfFh/IW3OFTqfSWnpk1kN/mykGZ76F6Agx6T
	sh1qlpbaD4sgDXh2WGhq3xIEA2AjZHp5kFuH7+fJU5flbvAslCzZ1y4hpI3s1EGcRvqytOz1d2F
	lTrHDkCHjjDU/DMhdI3WuRezFxGp4WPlim1sAabzDCW9hvCak8Xw7BVLrZ8nSxZbQyUXPsVAYR1
	ckbp7/7NL9fjdaHwaVchuEk4zJie+DXmIjS5UXeCP/S7lBVlnN/fMLH2+PI4mCcU8uwkWlZfuHt
	kdseujzjDB+utOC2jzhhjWQOe6Uclbe63V61kND4UCb7OVjruo3d9aHEmlnuj8U5W2+8eUcsA/6
	dtnvrqgSv+DGtVan+UfPRb4lWhSixqrQ/xVuGw==
X-Received: by 2002:a05:6122:e170:b0:5ee:13ad:6c8e with SMTP id 71dfb90a1353d-5ee1c4674bemr2919303e0c.17.1794500313185;
        Thu, 12 Nov 2026 08:18:33 -0800 (PST)
Received: from [192.168.0.8] ([2a09:bac1:6b40:8::11:213])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee3243e30fsm229079e0c.9.2026.11.12.08.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 08:18:32 -0800 (PST)
From: =?utf-8?q?Oscar_Alejandro_S=C3=A1nchez_Lucero?= <aleszlucero@gmail.com>
Date: Thu, 12 Nov 2026 10:18:19 -0600
Subject: [PATCH] mm/page_reporting: document @order parameter in
 page_reporting_notify_free()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261112-page-reporting-doc-v1-1-593af69f3801@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MSwqAMAwFr1KyttCPCHoVcVHbqNm0JRURxLsbX
 M4b3jzQkAkbTOoBxosalSxgOwXxCHlHTUkYnHGDtdbpGmRjrIVPyrtOJWrvjdh+NcPoQY6VcaP
 7j87L+34ZdnPPZAAAAA==
X-Change-ID: 20261112-page-reporting-doc-3300264b0693
To: Vlastimil Babka <vbabka@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Oscar_Alejandro_S=C3=A1nchez_Lucero?= <aleszlucero@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794500311; l=934;
 i=aleszlucero@gmail.com; s=20261104; h=from:subject:message-id;
 bh=6pVvo1FtuWeaNndmTIHTk1UU3WZn4EgP4JaT3+y2FF0=;
 b=y0Ho9xggReuos+SOKw11KbTHPvmVrg7Lb2eMHGBJNPPyBfhX+APJLVm9Ia5mQJ0RIehQIJOzi
 7VTAE/JM8e8ALDHYxfNl6JVhqY9NGlFUsEhWjx8L4wcCaTKfWffc37L
X-Developer-Key: i=aleszlucero@gmail.com; a=ed25519;
 pk=zRzEBMID7l1FXqr2CjfnlIn++3m3N05FuNYb5zPA3cw=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1C24E40008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: xfquziwcbj844xnixqdp8ww9x3txz5qq
X-Rspam-User: 
X-HE-Tag: 1794500313-793679
X-HE-Meta: U2FsdGVkX192zTQmUAkh5HHfhwO9CypVzo1pTMOmbpnICEcvRGavQs/5r7mUx7tLleeOsz3cWerPfmaIK3qCNFAC8qGnTIRjUFzGH1J7ReJjJyjhkWfgwhUICAiy3hWCk36MClK38pU+qEXjdWdetcKWdqSLIg1xfE3k7J7/Dd5lr/pSimn+KI3HoavqYaiaewnj4ipUX6s+iNCV13eoEopgvpqNgt/EiqpsMJyg6YezPhW5+B28T61ycwl/wMOacipIrXp77cpgijdnp2HbLA2dquMww9+H1Y0ww8YbxPdoNDnUFEO9PgrwHQy5w3QGKJcBBkxnm1C+2U5LmU5k+4aku+YjHAOXeM/Bo0nuzg5k8p7CIhL0pAVkjcoB+Ppx7fl//r7kYLHTDXvyiBtNbGG4+NHGsTPnAsn5fMUutwCv7wb4i3LmRluhXzhXKOYUVvpUx21VRC90nPNdX4yCpNTOjM/Ui69WHEkuXQAv/xGCnJw+fVUDRoGoIAtRX/57ZZavwrMD8pAJKNRxbC81CiBIAWe0Mx8NhgP84ckgG3boUPsjjA8P7nOplqE43PJh4IDN1gvTc3FnQLukoqczMg4lxySZ3hJhN1hAtro88aKn4LL4Kf1oEwbD5yg9ZZPyk7s8XhQduqOpH0WmyDOBqXWRXQVI5y/iO6jtFjRjMqVXp0f184PgqMOjRRuvRtegBlMJbmVhS2L7hTT7gOhJYpJBFjMV5ixO3gCfPyVIPz8ysXrOyHeAjDBsVxRjN+QCMG6+LFM4KM2+ZlXRIjm4gcD88TQbcCOhMsKd1sbtbtZzqYaqkzxlbPda5HI3DkMxE7W1l1VLR+P2Ngjk2c6RyXt+kMr9ct964yrDQ91UfWLpGM2Iuf9XNK+OsF76PJnvGvh37cxiHxYKUomW11YSynyKQYnKo7rFuQ7m34KJbE61BhPc21teK+LbEZHYeRvfueNPoEoOWggnPkO50Mf
 /jQhf+OT
 5gkkowMUaiObeQz0GC5C3yb0rR9o/PTCd007eKfCbh5h9i9gVL3a7S++5QJ+B+G1jSZwyc7Uv+CPCewh7MvJqGMgQxjyFnWPECFSVen/BG+fp2/0BjYergB0q+GrJAcyvhkEpeg3P2Qhh15ASKdv3Ua8ux3zMM9mTg7SwZekfv/0r2IcTUldzJ0gBJhIHFrV8qZwNW9BzE51/00peqHE/tflG9GTjzJjj/i4VWTQTzfk8kniWt1YexWze9pM9C7MFZHgo4xQ+tkd+4ysoSrB9OFMC0FbmWyk8bdo3XbwoJ0EMQ7S4dcHFxCAFzV4F2gJxGoxk8CQLRM63r9rsk8F2inLzk1iLxF/WTiljtltkrR4densN4rzWF1m+RWrAk6PBn1oSMnkvv4Qwo+GErYrPlsDDgmojh4JC2i2G7QcNAtOxsWTbPlXxuS5DBJu2uzqjiqnbwYszmpS8VWQeqNZILvukAbLYkNAoFc/E5K27zr2+u90i9SLSwOphtmNLZYNoJZ5naZkm8z/PQdvitlHRGtthZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add missing kernel-doc description for @order to fix a kernel-doc warning.

Signed-off-by: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>
---
 mm/page_reporting.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_reporting.h b/mm/page_reporting.h
index c51dbc228b94..2dffdcf02658 100644
--- a/mm/page_reporting.h
+++ b/mm/page_reporting.h
@@ -23,6 +23,7 @@ static inline bool page_reported(struct page *page)
 
 /**
  * page_reporting_notify_free - Free page notification to start page processing
+ * @order: allocation order of the freed pages
  *
  * This function is meant to act as a screener for __page_reporting_notify
  * which will determine if a give zone has crossed over the high-water mark

---
base-commit: aaa2f954c21b205a0bcd0961e5b2be4e82e58455
change-id: 20261112-page-reporting-doc-3300264b0693

Best regards,
-- 
Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>


