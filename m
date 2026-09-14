Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75DE2C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 06:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10B916B0088; Mon, 14 Sep 2026 02:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE146B008C; Mon, 14 Sep 2026 02:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EED506B0092; Mon, 14 Sep 2026 02:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C75946B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:27:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2FD7A16115B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:27:57 +0000 (UTC)
X-FDA: 85211387394.15.15FE804
Received: from mta0.migadu.com (out-156.mta0.migadu.com [91.218.175.156])
	by imf15.hostedemail.com (Postfix) with ESMTP id A7A44A0002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:27:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OwWlXJDt;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789367275;
	b=Zl8VdsrSaDCYD5/r9D0Nb8ngcO4JVv8O22NFoSihaKypZ/bcduX9e3Y2pKRkktLrEhdii+
	Tb5vnf0jmaD3YdEhkwgVlsqxMb9Wc1sC57D0HyR+yyrSN9QNnqax3AbtLdqYz7IDvVjqpb
	gBAs07AaKiu8n7VZswetaY7TZKWNlCQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OwWlXJDt;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789367275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZJIPhB2hFKIKKFc0hQTX/8fkaz+FMMu2g7R8NBGffE=;
	b=S1wiI24KCzS+RXeWNvCZEn235a8+GUVMnEcJy9OWrl1xa06tXo14sSBnshCrq9CIOIAUSn
	T0pVGwhQ9gIFgF7EmK0rGYJyJMELdsNOXQvtAUjOUye3QrfHqpnWo+A1eGWu5F3Ngay6cg
	bLP4tK0JCa7oNhV6WxTmlPFPDgjeGak=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=djNIl/KI66JahUpFMSuKlhJQe7ZFtgYzMuSNU7iNmpY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789367270; v=1; x=1789972070;
 b=OwWlXJDt7sfSLhJLsxHmFJEce+o+jumojbBilsHuNLqw8QX3jz0sPeP2uelItj1kNB7HVWsH
 Tc1eiXsXaAhLHDO03RCDr5yOGbSAxiK6t2Jo3fJvhwO/NZCHjSOjAILbif5e+cnsiZTckeV2bCP
 XW+F+bW4H6GtcfZf5ZkrfsSs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 9725185ab10d7887;
	Mon, 14 Sep 2026 06:27:40 +0000
X-Mizu-Trace-ID: 9725185ab10d7887
X-Migadu-Flow: FLOW_OUT
Date: Mon, 14 Sep 2026 14:27:28 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com, chrisl@kernel.org
Subject: Re: [PATCH] mm: zswap: return -ENOENT when the swap device is gone
Message-ID: <aqeT0FkVptyVLaDV@fedora>
References: <20260913063031.1689420-1-hebaoquan@kylinos.cn>
 <20260913004831.884d37afd92249d763b7f1da@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913004831.884d37afd92249d763b7f1da@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A7A44A0002
X-Rspam-User: 
X-Stat-Signature: 7fj1ne3tf5kiimsbhf6xo5pb89ctbpai
X-HE-Tag: 1789367273-435187
X-HE-Meta: U2FsdGVkX19EHfX597HlEc/Kd4T0AQzeZWiRJ4plGyBkqahCWrOhvCxSo4ogeU6ymBM7kKIV83e6Vv8by2o5bNol/4nlNtdnvpAUhG0X+ovOOUx/z8jaOoyEq0OnHcMug1nY03CVXM+ONZqkt83Vqvt5+uHMKknk5PE6NoMG7QwVB/u3GzPY75z3Xwl+yLgnOnnlenjjbZ96p+xvqKbkTu16lMAcGo4XCMhWodHxnzGElZQsi1WSmS04opc6Utfddpg6rqfJkYInZarKs5UUN/4uyYQ83A/a3a7dyj/7CsW8SrSaqJuPTWvrHf7y/5VbUvEg5uoxR3O1qGmbS//wChVWMaB+a0KRwb7G1fcYaITjULqzEpkMMb0D96Wg9fidt6iVfPJkEBh4yQqSPvodSa5YS3MDdkJsaqNet0rH2A195cCOZEBEJc6e/D8zrpjokLu9AU8BHz2mk4w4MY+FDKgsTnqzXwS4WVHuYkmZwlnWvybkg2rmvYWw3GDQQbYNDfanjJlmyeeh2uf6qZ/l5F5gm7mNI9sYQkXi0xGVk1tSAXHUxjeNI1yuhyCUpkMSitvk538Wjj3QEtZSzumbGDzh4SmhqvBRXzRjoF4gHgTVxzLRdhoVid6jpGkv9sC3QXVH1b64QcUz0luf4LVemjYaRpXnrScJZtcJG1fc+NOl1qiUBdMLxY3NYmeCqZlAMhYfPLN+n+EGi/zfKT+qk73LdL8uyFXlHM96ssUninzR4jPNr7ulQNagh24rm0eqsHQFGkfLh6RTGR7r+sJYThwASKFxecm+FOjfdIhmZgoRUhkvIn2pH9Oa5psGC2aSlMMwPmHQ9pDmOZyAxUHiPaZWWTrVb8JCdGloYaeXATRP1lOaJhHS/o2XpDjfjsgxPuO7GZDmgNm7v4YxrIx7GGUJOh06/Sezlcn8I3dHC0hKINMqVSUOkondPHqGLv0aRq8jbATdNqL3dQrJ06J
 FCtrMqyk
 dRdsCg9vCOsYa/Tj68cezR4cQ1NSnQRoDSVZBMqqHHhoPgWrUNZnN63hDcIjEjG0zmPe9h7PHGx8n5mNjZxG0V3dTbeWAGbgZQGkaiis6ePO8QyyWRCFWBASZdnQpXqBwMyZSB+zkgobxGME+qw2lpSBj6TM2be3OMyAlEm4SjNC4CaMb7TOZ1GS+wucj1tdPJmM2fWonG9vCtCXaXpczpZL+TgCVKMIUSz3OTUJDf/EBaaB7KkBHm965yu32gyQnwkMS6mjt+TtADJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/13/26 at 12:48am, Andrew Morton wrote:
> On Sun, 13 Sep 2026 14:30:31 +0800 Baoquan He <hebaoquan@kylinos.cn> wrote:
> 
> > zswap_writeback_entry() returns -EEXIST when get_swap_device() finds no
> > device.  -EEXIST is the shrinker's "page already in swap cache" signal,
> > which makes zswap_shrinker_scan() stop shrinking entirely.  A NULL
> > get_swap_device() instead means the device is being swapped off, so the
> > entry is simply stale.
> > 
> > Return -ENOENT so the shrinker skips the stale entry and keeps scanning.
> > Independent of xswap; affects all swap devices.
> 
> I'm struggling to understand the userspace-visible runtime effects of this.
> 
> I see that reclaim will prematurely abort, but is this a once-off thing
> which will resolve on the next reclaim attempt, or will the reclaim
> failure persist for a significant period?

Not a one-off, and not permanent either: it lasts the whole swapoff.

Assume I have two swap disks. zswap is enabled. By default 20% of RAM is
the zswap upper limit. So now if I swapoff /dev/vdb, at the same time
reclaimer call shrinker to writeback, -EEXIST makes shrink_memcg_cb()
return LRU_STOP, which ends the shrink pass right there. get_swap_device()
returns NULL for an entry whose device is gone, so every such entry still
on the zswap LRU stops a pass where it stands. The pool gets almost nothing
written back for the length of the swapoff.

# swapon
NAME     TYPE      SIZE USED PRIO
/dev/vdb partition   4G   0B   -1
/dev/vdc partition   2G   0B   -1

The entry is rotated before writeback, so later passes get past it. It is
a throughput collapse, not a deadlock.

static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
                                       void *arg)
{
	......
	list_move_tail(item, &l->list);
	......
	writeback_result = zswap_writeback_entry(entry, swpentry);
	......
}

I can't reproduce it now. And I forget how I met this, just did too many
tiems of testing and code change. this probably comes from reading the
code. So this may be a logic bug that rarely happens rather than a easily
seen regression.

Thanks
Baoquan


