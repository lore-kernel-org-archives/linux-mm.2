Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F71D10390
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 09:14:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E70E6B000E; Wed, 26 Nov 2025 04:14:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BDC96B0010; Wed, 26 Nov 2025 04:14:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FAE36B0011; Wed, 26 Nov 2025 04:14:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DDB66B000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 04:14:53 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 002D81A042D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:14:52 +0000 (UTC)
X-FDA: 84152198466.13.A3C1053
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8AF9918000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:14:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=none (imf24.hostedemail.com: domain of wozizhi@huaweicloud.com has no SPF policy when checking 45.249.212.51) smtp.mailfrom=wozizhi@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764148490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=SYrF8vtHOzZA8g/R+xrV1eMlzbnF/Fjt++a/NVV0g2s=;
	b=Do8qdKN2eAd+aDol883+RtmiQAFmP/1VV+Foiv14XdMX4v0sa5uWfRI91A15xGWb1NjavX
	NJhfjSWMZ1dYlRxFbFo0jpogidjBX8fiVzTYQNGK8ljT1gCi5KPsrSM3l98J8yIezGPzaX
	mPd9AHNJ3h+pH/5lUfstAtcySru2GqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764148490; a=rsa-sha256;
	cv=none;
	b=xNtDKLzALN05ixwm48XRjRAlmZYWgBd0/zTeQhQKXc46nF5mj2AjdUeg1/kFdZNqZI/Q8w
	Yeh2SuAqKmBTzDPEACEF11i6yLxsI9MaFrk4jqRmuPMVNeh5wuQ21QmQRHKPDzVsXenWnw
	nibGqy5xsbUu0PnJzawcu9YMhheH2qM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=none (imf24.hostedemail.com: domain of wozizhi@huaweicloud.com has no SPF policy when checking 45.249.212.51) smtp.mailfrom=wozizhi@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dGYlN4878zYQvKy
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:13:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3CE651A1E71
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:14:44 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXQV4DxSZpUsJHCA--.59425S4;
	Wed, 26 Nov 2025 17:14:44 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: jack@suse.com,
	brauner@kernel.org,
	hch@lst.de,
	akpm@linux-foundation.org,
	linux@armlinux.org.uk
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	wozizhi@huawei.com,
	yangerkun@huawei.com,
	wangkefeng.wang@huawei.com,
	pangliyuan1@huawei.com,
	xieyuanbin1@huawei.com
Subject: [Bug report] hash_name() may cross page boundary and trigger sleep in RCU context
Date: Wed, 26 Nov 2025 17:05:05 +0800
Message-Id: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXQV4DxSZpUsJHCA--.59425S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tFW7Jr45Ww1xtF1rury5XFb_yoW5JFWrpr
	45CryYkrZxZryrZr10ka9IgFyYyayUGr43Grs2qryUua1agF1avF48ta4Y9r9Iqr1DWa9r
	Wrs09wn7uw1q9FUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvab4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4I
	kC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7Cj
	xVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2
	IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v2
	6r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2
	IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv
	67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyT
	uYvjxUoEfOUUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8AF9918000C
X-Stat-Signature: 9dc4pn1938tcxiym3cwf95zkwebexs76
X-HE-Tag: 1764148489-713200
X-HE-Meta: U2FsdGVkX1/InxxZhqsTBMhfpPTbHMmgFZD7Dlnz1USXWzxlIJUrtSMhG1mNc12KefdgoLeMUwuMk2X0WugoiTNTENPVZEsCf/DpHl3Op1AWjuC7J0JVom4dbfxOnOs1Rl+egt77LYKhaNnk0hby9HHp2/fxBu3YtWk9DivEOtRMmcuIBgYPfmKmAL3sOSLq+IdUznAgWWbAjS2JCLqeOX6ZmQ9Ap79H0NQ33DwK3fNqbeZGsLwLE8a1X0yY47sPYf7sJF609cTWhZ1DqXoYNVfy8u7BNtSBiNuwiJCGzx9sw0pSZXBiLNtnKnW+ifpqSb0SrQ3fufjj099HONT9y7cJNNXEILYtLhwh/qQxotHP8Xiu0TzTFp24usFIYeREXIpo0vyrKtbmwc9VKf3WQzRxA8fay9EsyvbhV7SPJVOlYnzlHEijW9NBYw/zlbCxSZcokPi56WD0F52AU1ANrAig8eOhHmjVW7aEHV404GC2gIMviI1C1uEzJEjDj4fZTR/ht9KFR7CS+iXkJMornv7/UVBFeN+BgWQ5J6JA62ZkWZlstDdNPdaJKmWlQ0CTH1ki4qWbnYkOKouaqA7SdaFvlejAYTy7U7ishE7Gekbhe2fOOiWtXopnUEA/YNimUAOs8XOr+XFVL9NrvIHCT9jBRiQsPZYZM4/+H0psOr4Z90kk0jn2ah7VKiNYh9cHsYDsswJPpukCluTouaTjTCUUUnqtFD52IO1XAz5ixQaQT3IF10/uAmK6IeiiWewKJQcSAI55sI3YzwrntXK3yVvST3NC+8J5jTBALuX3N/K9JoffuUDZqI9ySzehLXVUMT6PZYl+Ew/3JxUxNeQjcmvmVHHTOd4ejDm108V6HZFGjTK/1rcNRXxTv6UO0iMcTjyMNbOR1XtTm3J8QMO4mbRG18kXCl0Dr2CtTN2qWgaz7KRa1zJ6Vlo1/igaaOmDrPWjxAi31zPPWamhPn3
 boCcX9Uv
 rvHj/Ku7EJXsKA1p4fKzxC48DeS3BmQCQsf244yhfDA/vj0vwCA2Y5hzNnWARuVwDwUd9b7ExiulB2R3K/rq+aMluGzxYTdYJtpzkjFos8HfKrsIKswvqKoc1Ra7jIoGP9JSeIMbrSaooIG5hyO5nhqbATngMY4gUVobJXKSP54PQ1Lhg8VzjWZ5Wqdkomx3BMTzUOKfHTh8ws85gHiLwvrwvng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We're running into the following issue on an ARM32 platform with the linux
5.10 kernel:

[<c0300b78>] (__dabt_svc) from [<c0529cb8>] (link_path_walk.part.7+0x108/0x45c)
[<c0529cb8>] (link_path_walk.part.7) from [<c052a948>] (path_openat+0xc4/0x10ec)
[<c052a948>] (path_openat) from [<c052cf90>] (do_filp_open+0x9c/0x114)
[<c052cf90>] (do_filp_open) from [<c0511e4c>] (do_sys_openat2+0x418/0x528)
[<c0511e4c>] (do_sys_openat2) from [<c0513d98>] (do_sys_open+0x88/0xe4)
[<c0513d98>] (do_sys_open) from [<c03000c0>] (ret_fast_syscall+0x0/0x58)
...
[<c0315e34>] (unwind_backtrace) from [<c030f2b0>] (show_stack+0x20/0x24)
[<c030f2b0>] (show_stack) from [<c14239f4>] (dump_stack+0xd8/0xf8)
[<c14239f4>] (dump_stack) from [<c038d188>] (___might_sleep+0x19c/0x1e4)
[<c038d188>] (___might_sleep) from [<c031b6fc>] (do_page_fault+0x2f8/0x51c)
[<c031b6fc>] (do_page_fault) from [<c031bb44>] (do_DataAbort+0x90/0x118)
[<c031bb44>] (do_DataAbort) from [<c0300b78>] (__dabt_svc+0x58/0x80)
...

During the execution of hash_name()->load_unaligned_zeropad(), a potential
memory access beyond the PAGE boundary may occur. For example, when the
filename length is near the PAGE_SIZE boundary. This triggers a page fault,
which leads to a call to do_page_fault()->mmap_read_trylock(). If we can't
acquire the lock, we have to fall back to the mmap_read_lock() path, which
calls might_sleep(). This breaks RCU semantics because path lookup occurs
under an RCU read-side critical section. In linux-mainline, arm/arm64
do_page_fault() still has this problem:

lock_mm_and_find_vma->get_mmap_lock_carefully->mmap_read_lock_killable.

And before commit bfcfaa77bdf0 ("vfs: use 'unsigned long' accesses for
dcache name comparison and hashing"), hash_name accessed the name byte by
byte.

To prevent load_unaligned_zeropad() from accessing beyond the valid memory
region, we would need to intercept such cases beforehand? But doing so
would require replicating the internal logic of load_unaligned_zeropad(),
including handling endianness and constructing the correct value manually.
Given that load_unaligned_zeropad() is used in many places across the
kernel, we currently haven't found a good solution to address this cleanly.

What would be the recommended way to handle this situation? Would
appreciate any feedback and guidance from the community. Thanks!


