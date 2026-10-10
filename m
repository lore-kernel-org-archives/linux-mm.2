Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4774ACA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 03:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17FC96B0096; Fri,  9 Oct 2026 23:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131556B0098; Fri,  9 Oct 2026 23:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 046066B009B; Fri,  9 Oct 2026 23:17:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA4226B0096
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 23:17:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3666816072F
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:17:57 +0000 (UTC)
X-FDA: 85305257394.11.CFC1625
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2C7E2180003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:17:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gY0VFKM3;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of chengzhihao1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=chengzhihao1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791602275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/Ss9u7ffm+Ms/aS7WwUlqIogB4GvdVPTjeht4umbEc=;
	b=E8kL4aR/JzwHya/VOW8Q16Q9GYFEM5DHvs8n/5XXJ39i3WjyrFgmhthPO6yRHpabar8LvQ
	Zux+b+Nch3pQCemiklYmIomJ3aGH5yQ9cBVd88rPYh6s+mlom3NdtgGVXJ+8uIH2lj2KCC
	McAWtR8358vmzbx7PR7ObJKDOp1H5No=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gY0VFKM3;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of chengzhihao1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=chengzhihao1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791602275;
	b=LaEfR4geLJSm8SYKMO2jYhZYiBsJgkL5M0Weh/VEbxapzhfVvhvfQR8zxpRGJESjYCwtYl
	eICn2dh755hhiqjg9dkCRw3k4/YH2VnAL7CuyY2RPq44M8Ao8sWdqUlfrQqNSVCf3H574e
	kEPhIPqF/5JMv/Q3xmzfooq3kEvdpTE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=f/Ss9u7ffm+Ms/aS7WwUlqIogB4GvdVPTjeht4umbEc=;
	b=gY0VFKM3coh0tcV+ulsYg4AicFqE9u5p5h83kZbsVbIQMpVvThTXxGRqPkrfbpLjyb5R3tVTG
	gAxAOmcQOhwcbRfhcqGuaqVmK1bHYGjIsh+C3jes7E+BycvsGkvxHF7xzeo5ASH9TcE+NSejIbX
	rlMQUkeOVbLxP83KDhQamYU=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4j1pWb6xDTz1prN4;
	Sat, 10 Oct 2026 11:05:31 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 20AA84057F;
	Sat, 10 Oct 2026 11:17:49 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 10 Oct 2026 11:17:47 +0800
Subject: Re: [PATCH] fs: don't lose inodes that another LRU walker is
 isolating
To: Nikolaos Karaolidis <nick@karaolidis.com>, Christian Brauner
	<brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
CC: Jan Kara <jack@suse.cz>, Mateusz Guzik <mjguzik@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20261009142431.713875-1-nick@karaolidis.com>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <a2f5f4f7-b1ec-bf23-d990-aebbdf6de177@huawei.com>
Date: Sat, 10 Oct 2026 11:17:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20261009142431.713875-1-nick@karaolidis.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.46]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemo200011.china.huawei.com (7.152.185.179)
X-Rspamd-Queue-Id: 2C7E2180003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: d9sfo5344kprxhn7h8n7uk51zt5xsr6t
X-HE-Tag: 1791602272-960493
X-HE-Meta: U2FsdGVkX191XQ3bmMQr1eTpK/GYp8wj1jMpmSs6RXDoWQX7PI3sUGiDe2ratqtApOFrwuZpWY+iV1tYkQaPXENDUVPVN5veYdkzEi077DLhclZXO0/SfeZLW7cUHWPxo8AQR1DypnTf64vGcyoYnaOUggy5Tmm/0SHBlwDNbtIHOh2NUhG0jpSl+cwVoO3fybMDyummURE5304u88URzyZX7yGIofE59ICfgCE38EUml7DBZ1ZMr39Oet1xxrg7m9ruy3tvL2qwVNJCgxQerpRHRuC1Cbwdqn3sGHX4QlGo00TCCiOqUtaj1s4mNfTPipBFEi6CgjRZeBUFHZuZs+EWEl2ok19dK6rwtjcctNDRqx2Wi7SLE3R+bnTLNosVZqquz1y0H3ayu35OBIt3+/WXNYz8eLPit54qY5+yzkKFKZSSCSkSfTR/nDC8aO7VzU35YrIuzKZWhV2Cw2NwSfTKUOaINlOefgtT5XqrYC/+9pKtv+nmgYhWPUOv1cmMuP77j9jR2fi47bPoX73V+D47zTnnZ0yPzkeUYyCr4FfdRcEXgwIz0RMYhuuTgur3zMrsbhgy+peJKuM6YJv+MbLqFdcKF/OmC+Z4y7cMEU6bVgBpmehmelFcSVenenjFny7MRX9RE5Sh5cC0cyjunnbHzlKsoZq8Hcw3E2imDsYi70QasHIF0aKo0DsTCMpGo9zTHo5DAIQUpjn7/oaM2u6dUq0aqdONBLdHvmoJXkSqMVE0HfvyOkUyhZnH4P2C3g7t1AkYuzMdKDwzrJS/j5zCGtHvetebtRjluh+FC5v+gouGVPg5YDEN7jYtzs+jYOPKf7enepQ23yV8lIeG8xncHXhc0mprObm8ZmzBfer5Z4t6JA8fpmXKfq1aRW+nYqNYYydW4NhqerfVbtCoRuael7CcHjTKhTnmsTGRt4sTMMYiIJKu6hHbLk++9q/1bbc2QxXDY3EJkDbNHNn
 z4HphNC5
 zQjvgicrrFvDYzTGbVWytM/Mpf2wpxQP/60Dy6rhJ4KPatkWme92CrvTyI0HnkUmVCYI/QXvDXEeVb+ks3i/yInlxlBfbRPlk0ofHrIGSAjv73YPcgPStjaaKCtDQKO8rCTzYQb0QjfUOhmFjIt5noBSRoDcqy18Ay+B9PlWPhajdeF9+8W297IV3EiS7Kadf1/vPNCT5WH35SlFOTbyGhCUKQFjfe5BYIvGik+D7uRaS7Bw9wRBoFUZ+ABDrSDSE+O5jENmKfeStnEa/fPh0OnJJ9GszLRBbu4p+2rPvpezBDxjFAmfGhDS+vl4lMND9teYQGEvNJYGYBAqxMJAfoKbxu+6Hi/nmi6zeAIyXqytWs1xt3kFnP2dnwlnzq6n16EmNoZm6vrbkdeFiP2eCIOhnCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ÔÚ 2026/10/9 22:24, Nikolaos Karaolidis Ð´µÀ:
> When inode_lru_isolate() finds an unused inode that still has page
> cache, it sets I_LRU_ISOLATING, drops i_lock and the list_lru lock,
> invalidates the page cache, clears the flag again and returns
> LRU_RETRY so that the restarted walk can free the inode.
> 
> Another walker of the same list can reach the inode in that window.
> It sees a non-zero i_state and takes the inode off the LRU, as it
> would an inode that is in use. Page cache deletion requeues the inode
> once the mapping is shrinkable, so this is harmless if it happens
> before the last deletion. If it happens after, nothing puts the inode
> back: it stays in memory, unused, clean and without page cache, out
> of reach of the shrinker and of drop_caches, until it is looked up
> again or the filesystem is unmounted.
> 
> Before commit 2a0629834cd8 ("vfs: Don't evict inode under the inode
> lru traversing context") the pin was an i_count reference, and the
> final iput() put the inode back on the LRU.
> 
> Skip inodes that are being isolated and leave them to the walker that
> pinned them, which restarts its walk once it has unpinned them.
> 
> The window is reached by any unused inode with page cache on
> CONFIG_HIGHMEM kernels, and otherwise by inodes whose page cache is a
> single shadow entry at index 0. On an i386 HIGHMEM guest, eight
> concurrent "echo 2 > /proc/sys/vm/drop_caches" over 2000 freshly read
> one-page ext4 files leave roughly 400 of the inodes off the LRU per
> round; on x86_64, with the files' pages first evicted through
> memory.reclaim, 3 to 4 per round. With this patch, none in either case.
> 
> Fixes: 2a0629834cd8 ("vfs: Don't evict inode under the inode lru traversing context")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>
> ---
> 
> Found while working on reclaim of inodes pinned by page cache in
> ZONE_MOVABLE.
> 
> Tested on master af32da41b032 (v7.3-rc6-232) in QEMU/KVM with a small
> stress program: mount an ext4 image, read 2000 one-page files, run 8
> concurrent "echo 2 > /proc/sys/vm/drop_caches", drop caches again
> single-threaded (2, then 1, then 2), and count the filesystem's inodes
> still in memory via how many the umount frees:
> 
>    i386 HIGHMEM:      ~390 of 2000 lost per round without the patch
>                       (3 runs x 20 rounds), 0 with it
>    x86_64, pages evicted through memory.reclaim first (single shadow
>    entry left):       ~4 per round without, 0 with
>    x86_64 with KASAN, PROVE_LOCKING, DEBUG_VM, DEBUG_LIST:
>                       6109 lost in 50 rounds without, 0 with, no splats
> 
> The reproducer is a single C file run as init; I can post it if useful.
> 
> I went with skipping the inode rather than requeueing it on unpin
> (which would be closer to what the final iput() did before
> 2a0629834cd8) because it avoids the remove/re-add and leaves the inode
> where the pinning walker finds it again. Happy to switch if preferred.
> 
> Jan, this applies cleanly before or after "fs: Basic infrastructure for
> offloading inode reclaim" (v2 3/5); happy to rebase onto that series if
> you'd rather take it there.
> 
> For stable: 6.18 and older need inode->i_state instead of
> inode_state_read(). I have only tested master.
> 
> An LLM was used to check the analysis against the code, write the
> reproducer and draft the changelog; I have reviewed all of it.
> 
>   fs/inode.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
Good catch.

Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
> diff --git a/fs/inode.c b/fs/inode.c
> index a9d37be390a1..74dfc379b377 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -942,6 +942,12 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
>   	if (!spin_trylock(&inode->i_lock))
>   		return LRU_SKIP;
> 
> +	/* Another walker is dropping its page cache, leave it to that one */
> +	if (inode_state_read(inode) & I_LRU_ISOLATING) {
> +		spin_unlock(&inode->i_lock);
> +		return LRU_SKIP;
> +	}
> +
>   	/*
>   	 * Inodes can get referenced, redirtied, or repopulated while
>   	 * they're already on the LRU, and this can make them
> 
> base-commit: af32da41b0327b9c6a37856ba82b6760d6c8d10e
> --
> 2.55.0
> .
> 


