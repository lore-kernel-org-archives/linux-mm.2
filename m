Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F2D606A331
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=leB23Xbq
Received: by kanga.kvack.org (Postfix)
	id D5CCE6B05CD; Sat, 14 Nov 2026 09:53:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D826B05CE; Sat, 14 Nov 2026 09:53:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFD086B05CF; Sat, 14 Nov 2026 09:53:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C7546B05CD
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:53:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39D9FA7F47
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:53:03 +0000 (UTC)
X-FDA: 85434017046.15.9FE77CF
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 76D2D100008
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:53:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=leB23Xbq;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7h3UUVVN+MbLxa2NoBAv3sszap7em80pqhV/AUuWc8=;
	b=CABu0v7gl59on0QdxsOvcHiciDge92mo2IAsutr36CVowX8wdy2PdDCCnbEYi7Eqs61asO
	sv2Xcd1YQ9fnZe6aQHa6z6zVW8M69dSwp8uVenvxavQyt7t7wH/BiS/1jjNX6AexBjN77A
	3fgn0IGEnFjzx7LW/HJlBux53G2ndSo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667981;
	b=mG8mgHPlvouAWo+AB7X0nKckWpyronosMr6AUe43LnjG4Ui6GyHx0009U2FH9wzgTi7oND
	zlxaNcEiAgBJUig1J+kjC9f9EiZ5e749/4Yq6pntrLUK8/aQCzFxLezYGloAkQNfmEsmKC
	U6ie7ysaERBIrjO0JsVNZ0Sc/6SxSfM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=leB23Xbq;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8a05b210703so865296b3a.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667980; x=1795272780; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o7h3UUVVN+MbLxa2NoBAv3sszap7em80pqhV/AUuWc8=;
        b=leB23XbqEkSD2iKBr0CmqIx8D+bkNOPpnN8S5uGSNnq5Gz39z+9AlydgI0/8BHC8k+
         5mfZB/SygrZ9OOpIMhhpfmVVH6Xrf9yzf1+lzjUytv4hYG9tFyUJWXz41T8FMv6yueiT
         lWnBZNBKEDHGaeYemBb/c8TfnpFKNNHDkp8DilhVHo8CyU08V7qMj8PQY2+MlvOa9pIN
         RGt39YBcRJePCLVuPUuOi0QOwvVj8ho/FyEUO9ElP7uEDTPU3BSPFju5X261ZbwINQEB
         WSdNW36HOYC+EeAAExOU0StKPdjxdqESeh9PmgChbX8PTDkQetL6bzbPw9lCDiq5OIhK
         eXdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667980; x=1795272780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o7h3UUVVN+MbLxa2NoBAv3sszap7em80pqhV/AUuWc8=;
        b=1T4rAKH/+QwiJefUeSerMevdFvUbkUz5SHWXJi9UMO5y4YqRmzQPOuTkc7652MY/d+
         xc67D9fauZVbHnte+BgEPfPbxxeBzwqvJHJ5TnOtIOy0NdL447ExIkfVCy5zX7oZWHcw
         U6jAwiOxjnzALfU5oe7GCh1EnDeWam5CADVoe+ddV07aLSOQq4SZrkPIHuC4lGp3iYuY
         J2kmzsYmCOnl3XTG6PqYNcH6U70oH6eFWE5cNF1MRvFD8qpgF09NrkH0uioQhffw1CF8
         KI6PTuaWZ4XB6azlNyVd1gh9ipn33B9aCnrmX9tQj2UfWio2pGfLcVej63Ry3f7eaojw
         f9Bw==
X-Gm-Message-State: APuU4Z+2u3sQIjFAPFjUn3jR02NqF4Q1PuEBlxqSov4XQD5xZo9ikxxd
	ASf4DkK1QeYTtDJMORD5cYWmAU4PdkwhoM3tASGP63sQP2W+wC48eA4iRrDU/Q==
X-Gm-Gg: AYBFou1fKG+tvpr7sDEfObAEvR5Xpw9dhEgLKGJHrzwGd8/slN9OraV5b0nW6Jq6FiT
	jSxTOH6FuwdYIl5FR5r9GYUwbW5JH1/K2tLe7IL9KycVE6ed4cr0iZAozK3h4j8AuQSNDKneMz4
	pBRAXbiBLqe1br+bGS1zhvhV0BIaHyq7pVFfgv0DyebeGZv25D9sdZkN5ycp17E/N1/Jn99El4+
	GD24i6mvoEYTm382EC9H0nMC9PkOKaipVlml6HKG+56zN8dVB/M0O3RQvWbguoS1bv7jyUsA1jV
	uHKl99K5Fm0L/sgRkKqmpoSmBrSMhYe65SNLb9YU7V9HS/2QeGHR0IDzVniyLhWMoDGOzt60ERs
	4gqI6TdAWEbmBnzcEM3Wl5w3ZWlRAR8fcDXRnkLtyN5gNKVSA60Veu4h5MEWTRP66lCi5GRmhL1
	YBCpWRxZtQjs13piFmleWBqvBAWkstsfAR6fp7XqDJNWlnfd9amN2Yr8DerdJ5ccziQK+TgTxiP
	zr8eVwFhKIH7k67dukUCgJfiIw1YuDS8UGSELtVx8S2DdaVBSUmkXnwupFck9THQmq9Mjkcg9U9
	OyH7Iiub+piJpSJCUlDGZfBOePhqq9WgGCejLTsA6o13BBBiVA+HqLsuHypX5XsTf3+O
X-Received: by 2002:a05:6a00:1ad3:b0:881:e266:c3c5 with SMTP id d2e1a72fcca58-8beb2e7dab4mr5713326b3a.2.1794667980260;
        Sat, 14 Nov 2026 06:53:00 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed2d0f473sm2113512b3a.53.2026.11.14.06.52.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:52:59 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
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
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v4 18/18] mm/swap: redistribute queue readers after membership changes
Date: Sat, 14 Nov 2026 22:52:48 +0800
Message-ID: <fbb87083afcc51fce533308d723edc55263bdf06.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: r8wmg3ftz7fff1khyd7ny8nbz8tb7ose
X-Rspamd-Queue-Id: 76D2D100008
X-Rspam-User: 
X-HE-Tag: 1794667981-989439
X-HE-Meta: U2FsdGVkX19cXr1ZxBVmm97OJM3hZ6blfpeAapBEmtkGKaw425nyYgCK0ZRg2nOEyX5NQ6+q7xwxn/cSywA4N/bSdTPlQomDAscfvB8ylfVSGFS9WWWjYBRrY3Vx9O0DSS7jPFGWsy6VTD3RtK09ejCpxhLY32MILbphhKeFPzv+CuMLYsZgmn+pFZScqFuj1sQvME02UAwXR31xOQws8CDn1Cj/AZI7RZrv9H2iBWJVgkf1IAHbvuokz4T/s5jxe5lvGTTNt608Avvkj2eLF76fmGpqRnLJG1UAj0v7Pyruy1bI1USa9GeAfjGkZkq6l78DtvwnlFg8JqQcXocGnv/rO4aNemHGHzr7JV97jXOxzzCelO6C8cbjrsJya1DKBQ+6XdFWCRY1RLBk2YlGlWrTG7xn4d0WzaFTVa1CVteBwNYSMB5FaJTiZd6vgvIDpU2tqQ8X4//zr/WCK5XR1AHkQdoCg99HvfT6q3Td7uG3QRk9Z5CCdrueY4oIBBToaEl/p6aflr5lov6bBCIm9Zovf12ovDxW1DYHP/ds7wpWYfzUC/Uk8JxgYnQCj7Mcp7YyT6L8Aca9fae5X9glMMSR0B9yE5Ynhw6Vag2OfuHZPgPRaCrdBwtNXv0jBTnddcO4BQLSni8+hw3erN0HsLyXP5/v0eTGLSzdEyLf7WU9BDk7jyPX/qvvhu0ojNFHEatKn3ddB/3mbed/0mK2izom6LfizypdMClPZtGNj7VsczjltJFZBHflzyYdyh0+ZGyj5RNNnt3hF4qhjUPedwhqRPXBJ7rVhQuac+P+IOD4sxlvDdxLCdKFfhLrju03jfTEFtvqV9eePPw4r0pU5Mar+GXx22/U0xpK5qWAavfHcTgUpOi7N3UaX/DZls3Ga37NRh0ei20Xl8vxDsyLp3VeZWc3eRsqa/xph0dZKFjTu8wg7EOULnqoec78loGTDYTQJxS9fju0hDCyvMI
 NQywFLj+
 m4224+7gFtNWeKp+lRLmQbxj+QiOQzxm0cUeo0WehjpHKTRe9lI2lV2NqN9lLCKF98gD/wHw8XDdDN6+pUbIvSF+bXiTC+RfcdbMWceBNqVlN2L56/RDJkIDmoqz53VSKdJ5nqKp4fGOa1M3dNzzIGbSMPEygqZE+i47MXgqCW/K0y+9FKZbaGZypjPhbDB7SNfI4cNivlJlKEoxaZzPwU21huDKnXGf5+K58GWCK8+uK8V3YfFZndbD3eUECsWxMLbuPL8YGYK+SC6wchIuE4wd3uv0AOypabAcH14/bYfRKAxTiw3pqdAvWgSnMcuWhnLEPKDu8rJwRTjGgk6VVltVNrl58+depvmp7vOVFuxWguz9oMye84gbZWrh4zyatdNEB0B2Cw3Mbk7grC3nh+gJKpLARk3KrGDC66GYNeqx8wB6WjWScSccn1rMYZuOcs6as
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Adding a device to an existing priority ring reuses the per-CPU reader
storage. A ring that previously contained one device can therefore keep
every CPU at the old common starting offset after peers are added.
Deleting devices or rings can likewise leave offsets and quotas that
describe the previous membership.

Reset the valid per-CPU ring offsets and quotas after peer insertion and
every nonempty deletion. Run the initialization helper under the topology
writer, which excludes allocation walks, without allocating new reader
storage or adding selector hot-path work.

Use cpu-id modulo placement for a fresh best-effort rotation across all
valid rings. This does not move existing slots or guarantee strict balance
for every active CPU subset. Mask and availability transitions do not
trigger the topology reset.

Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0c192844b121..eb2128132455 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -497,6 +497,7 @@ static int swap_queue_add(struct swap_info_struct *si,
 	spin_unlock(&swap_queue_update_lock);
 	memalloc_noreclaim_restore(noreclaim_flag);
 	kfree(old_ring);
+	swap_queue_reset_readers();
 	return 0;
 
 failed:
@@ -569,6 +570,8 @@ static void swap_queue_del(struct swap_info_struct *si)
 			swap_queue_install_readers(NULL, 0);
 	}
 	spin_unlock(&swap_queue_update_lock);
+	if (swap_queue_len)
+		swap_queue_reset_readers();
 
 	kfree(old_ring);
 	kfree(old_queue);

