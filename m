Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ED05C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7438C6B0096; Mon,  7 Sep 2026 09:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71B706B0099; Mon,  7 Sep 2026 09:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6319D6B009B; Mon,  7 Sep 2026 09:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4963C6B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:09:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDCF81C037B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:09:14 +0000 (UTC)
X-FDA: 85186997028.03.BC42524
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf04.hostedemail.com (Postfix) with ESMTP id 183B840008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:09:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mWE4FaVh;
	spf=pass (imf04.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788786553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9aIgFDMgD3gep474UQZVVvhqGHf5S2g87xXTFr6YcCs=;
	b=YKWnaGFbAawu0kQBz6OfX1VZ4KDsMO3edMSCUF2DagyJFAK07B5csIbkro+gmU2rVCr4T9
	plq0yTLB1WXg2Hyz03dqhJz1EeAtkA888NMFrTdzYmBu3Tb1PPVzGl0XuYx2Hxk/tswvWl
	PYjFulZryPLHTcC4kU92Lgfy7//u/vU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788786553;
	b=fAL9Qgxld0AG9sQVs5aIC60wd5f3+aCRdz7W9oA62Id9ScDCBfzQQ0L50JVU7kenKFpmYO
	r7ZcwM2UBar27qcs7/TH7rq6noR6lc/oMH6NyuexKOcaHtR0TN9gAIuZWPwLF9PjEqp2DD
	jgLZbdhtjhHqe5HBPZ2ca2JFeeMdmnQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mWE4FaVh;
	spf=pass (imf04.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=9a
	IgFDMgD3gep474UQZVVvhqGHf5S2g87xXTFr6YcCs=; b=mWE4FaVhya/+AfIoIg
	8AjO1f5kmpedNSnEw2E+YBPTLVmjEP+a+8x3OJM1pkRvAyPUxKk2XlrKKYORLoRZ
	14GWXiGkc8n+nqSlePJvnZ+XaSYAoqXin4OOny8BCpzDvqaBc1yyVNglBjf8F89+
	2qtzh336QXn4h+/4TnxPjfO90=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD310Zdt55qUKzsBA--.63999S2;
	Mon, 07 Sep 2026 21:08:46 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com
Cc: chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH 1/1] mm/zswap: publish the initial pool with list_add_rcu()
Date: Mon,  7 Sep 2026 21:08:21 +0800
Message-ID: <20260907130821.1726595-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD310Zdt55qUKzsBA--.63999S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uFykuFWUCFy7JFWDtryfCrg_yoW8WrykpF
	WSgr9xKFWUXrn7trW7Ja48urn8J34UtF4rKr1UWF4xZwn5Ar1ay34xtr95tasav3ykC3y7
	WrW8A347Jr1Ykr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jbNVgUUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9x9HQGqet1-L0wAA3r
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 183B840008
X-Stat-Signature: 6wowyckdj5ghebzucmfb7t3wg3rrgysn
X-HE-Tag: 1788786551-114131
X-HE-Meta: U2FsdGVkX18ROQfV5Jb+E9v8wIOUL8ASL32qsS1G6krEBC08i0212Ecwu+iQ/hHmv+pmWZfyoX7HG3F+kdvqPiilQj0ijuvxQM4QGaIbFGLqy9J9ZObetfJGr61jj/g7EIGAuMU+/LnubnfxDiY2lwkT7lOk76mhGqU3ORCgojZzsoU0UKNPZHABFVOdhAIQXh1h/Su/w1teddz/1FCeEx7FAgF9S+YKz/qXpu/IcD0ir5XBqZvi78kjKFTSKCP23C6t53+zG7lP6SrC5YcKYMyi/eP9/MGvWIZA6daera66OWm141Bd5SbLNlDFW0GqfiIGnZjEiFb1hsWPPBytJkB9kNDGwNnSPwE/P0AZro+547fQjMtOHq6b5sVhsjKXYRNX+z37SEhwt5xMKYKCjXnQKvpASv+X+PS8oIM4I9EOIqFyWB9tx7L82rWgnCvpAXwZY033PHevX8CYg9//y8VBa4qKjsg/LNKNWOCUh/OP0Kw9JoFXAl6fC6g9xaeWA/R+Yuqij6MLQG5zuiUkkwNfdTm1OQboCADwWV06fDQHXrlbQhk0KAxi4zjPpzTYPz1OYCtQQzdzjQW90YzoD3MvZiyjn5hKVDc28jUPbQZBB/aX4V990fT8UbKuip2I+EKHoPdgyFsaCma8rtIh8+sl7ZmxwxZSmr2cnQmaJ1iblaQ2uTHVL0qsagxxeR70KjUmd42bqz9X681Iwms7ribmLle5LAN4ba0OtNVuZf8x+hHTWr/EW6otrI60YqcrLpQ4iXNAHCCyP3xIHT3QeVBPgLIVlk5t8fZjoUxr1CEwDzVk5Jbk3CAxwa20zV8x8KIJ1bTBWFWgjxorJKJ4SnEvHpOJhZ2DK95s5NddE98YaDEgNnjMsxeyWoJffV3dzXw2zq8DJu4oUdIPdx1WNjtMwy8QPv0sDDc+n0o9o2bNnRN1v1qPaqu3IYs1gNnsZENRpd59WogPgEHLKVK
 6t+MADrH
 mcupIfHgiwUXk+ppzSCzNAeGFSYfMQTKOEWp3Bj2UfPuhJpBbIq7Zn44uik78ApykbBgtu/8Q3y1h69ugH8ja2aSmxcbUpmzf2cln1WIZYaLDA49CscKLdqchlryxGFAwvMGvWibEeTkoCzMYcgOTE/wCf2EQpV9/n9T0wN9N5G64xR6vcYTP9tvv9snOM4p+Js5UJKSjQpgsKdKdii4iwHTEx1wQWWj4KAll9qxbtf5jwmVkU0pvb2WjweJpXOjBGvW2gVarUTj9HNNiZa6XV/P+CjoK4Ay9gZ0YRv4B/RuCxPwcm/Z6uS99Y4N8FSzFGrcdvkqIr7b48pCdIfuG2AO592V1fr6hucnYk1YQN9YGQNV/hckVX5MiyR/81zEe8fps8vu9eUn65HEhuCPRhVtoSGvM0kBRjU8Oe1+UPXRCfQyVyqmf5V190ui7cXwoWsqpH7OgseGpdmqcyOuTNzt1iXtL4tFqzenh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

zswap_setup() publishes the pool on the zswap_pools list with a
plain list_add(), but the list is walked by concurrent RCU readers
holding nothing but rcu_read_lock() through zswap_total_pages(), e.g.
/proc/meminfo and the shrinker count path.

    CPU 0 (writer)                          CPU 1 (reader)
    --------------                          --------------
    zswap_pool_create():
      pool->zs_pool = zs_create_pool(); (1)
    list_add() -> __list_add():
      WRITE_ONCE(zswap_pools.next,
          &pool->list);                (2)   zswap_total_pages():
                                                pool = READ_ONCE(     (a)
                                                    zswap_pools.next);
                                                zs_get_total_pages(   (b)
                                                    pool->zs_pool);

If (2) becomes visible to CPU 1 before (1), CPU 1 finds the pool at
(a) but dereferences a wild pointer at (b). Publish the node with
list_add_rcu().

Fixes: 91cdcd8d624bf ("mm: zswap: optimize zswap pool size tracking")
Cc: stable@vger.kernel.org
Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
Link: https://sashiko.dev/#/patchset/20260906133601.3563324-1-xialonglong2025%40163.com

 mm/zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e..cb5a0855fd2a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1803,7 +1803,7 @@ static int zswap_setup(void)
 	pool = __zswap_pool_create_fallback();
 	if (pool) {
 		pr_info("loaded using pool %s\n", pool->tfm_name);
-		list_add(&pool->list, &zswap_pools);
+		list_add_rcu(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
 		static_branch_enable(&zswap_ever_enabled);
 	} else {
-- 
2.43.0


