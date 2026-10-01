Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2011CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 12:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035676B0088; Thu,  1 Oct 2026 08:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00FE6B008A; Thu,  1 Oct 2026 08:50:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF006B008C; Thu,  1 Oct 2026 08:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B10B66B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:50:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10D4F1A039E
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:50:15 +0000 (UTC)
X-FDA: 85274040390.25.78C0773
Received: from mail-yx2-f38.google.com (mail-yx2-f38.google.com [74.125.224.166])
	by imf24.hostedemail.com (Postfix) with ESMTP id E1FB218000A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:50:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bitbyteword.org header.s=google header.b=uBET301w;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of vineeth@bitbyteword.org designates 74.125.224.166 as permitted sender) smtp.mailfrom=vineeth@bitbyteword.org;
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790859013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7MmXu1MySFRvzo+Drdf+bzFzEcZgGkKpqjZcehScO0=;
	b=Ue+TYpTboR/s+GgfUXiGfCfsp9wGB2WUc5CmRnByDOyTOMLs/TTpI2cPtDd5qo2bqaK64j
	Jvk/jXXXzYBtuh1dC1wNLHHI4bbZTva1knIg5aLa62vuVbIhKl/0UOsJIh5hHVbUh6Rigc
	wTZhI/XZQsH0+fvcD8buTTV4UTO0wRc=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=bitbyteword.org header.s=google header.b=uBET301w;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of vineeth@bitbyteword.org designates 74.125.224.166 as permitted sender) smtp.mailfrom=vineeth@bitbyteword.org;
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790859013;
	b=5Glct6f9gITMdIUjT5oQGEpQMbfIkU47f4awDMSbTHwLIrBjv267Rernj5kOobRJuKKmIg
	xDMW2eZSaYJcm4zPw2xByNbNY79GfpIP1kbj5vEW3O6fR34e9bZzVBP7SuvWHnRMvaMukc
	OzG8UVQJRQ3AI7zBxc/kaRRM2jL7eKY=
Received: by mail-yx2-f38.google.com with SMTP id 00721157ae682-8ac47074e38so10295937b3.1
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 05:50:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790859012; cv=none;
        d=google.com; s=arc-20260327;
        b=jjSX9X/UBn19X3U5nJCS0/tGEkV06SDXNCPTaWpqEUGq4cQ7IzOQdov4ATCKrXpJ2V
         vdyBsTX5I8hmXA6clPgyVI3TurGgdmIBHcgC6LgO0RWA7H+JKbDvS7Jmgc/bkesDgDYk
         SD+hDhgBDTTC9n0M0/meJlnxDQA1uz/dez31NOR4I9NWfyw1LPwM6wvxOramzaovdkln
         FnhARwS6V9GWHF3oqJuOyBNs2StutwaQiqaj0wfBG3vaebUx7AuO169n+0LXHJ9B/o0J
         ykWAT2/+3kbVdgeBixU9zGelP9Gzjiz3itJCryGOHwIpbjtXuMw3AUFidmAaEqpXNqLG
         OCGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s7MmXu1MySFRvzo+Drdf+bzFzEcZgGkKpqjZcehScO0=;
        fh=7YjZvfbPNLxM+pha9mSAGwinXedxMmoPRzY42iK92i0=;
        b=GXf5Hk3WM1wolXcv+BZ1wTaEAvbR9BsYBo2MopdunWOrqld2WXfct9S3Fi/Gh2+W9H
         7ceNvaiZ6IUeLcsdOctt3NyPHBv0c6qnZRli1d4YIi5CH8hTOSlS4f4HUPPKLyId4ecy
         9YhYEf2G86r6JeznD3+jqdb4rQB8NvPi/qiJIr4FtrbdYZ8CKo8Y0UYsXrEB+t3OFh4g
         Ge3Wvd0Csko4rVkhtmb6I6Bow91xTn43+OhJ0L0xnYumI7W0rPljqYaeIZjwJpxaS4iC
         ceHrg5jXwTWrzl02hrz+05NnzU4Yg1X/saKi5rp+mKJwc/AB1Zoi/Om0oF9xOG8vLMVG
         vFsQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1790859012; x=1791463812; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s7MmXu1MySFRvzo+Drdf+bzFzEcZgGkKpqjZcehScO0=;
        b=uBET301wlAxqXm/e0G4EEEGgN0lFNKpMnitsgVv+ocXi6DQCiiWgcRO4FD9LjGuSmU
         h+uxfYWBv7bXbkhw8/7shFS5wd/jNnzAsnV4EYZlbc48o59ghAn4bwQBWJmZp4F/BMrp
         9KTbiulqVS4unatQO4+efJFz2SWihc4lSEqQNZNy2JIZ8i0i/QsL3p9OT0fmdKmKwEJB
         T0Gdk0xrhMSd/8T/C+Yx9u3Tk1si//NgSXWWMc9kK3I78ebQUl1P4LX8JMF03mS2tmAV
         bBRwdMhl8YWhgcj8LFyoVCV+O7v6PEXTX7rIufoVIotOlauPL2n7r5klrj78rrV+nKfp
         HLww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790859012; x=1791463812;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s7MmXu1MySFRvzo+Drdf+bzFzEcZgGkKpqjZcehScO0=;
        b=NOLa+Ba5AVExYAHgzAcKa0Q9ilDAJcUUvoxQFaxn4lPm01tsph5dezsmz1IrWJuXJ+
         ajEm4G3YOaSTySJT5DzxhpGPNcxrBp/URkoepmebt2H0kzJ07g9Eutr21dtCRuxHBSXh
         ZkaxxXk+hciRW/4sPuxPOupJpXZgC2lb+zcmO6irnghMcnXqK3V3H+U8KikhF+EHXGsO
         ttX4+9eoxEWMxNEKZHLs9quq5WKj50mBqH9agOk3pkRLK7N4DWh4fsDjI9NNvbmcwZxg
         e2/8jtIUeijH6EkOXIzh45zRi+UZaWRxQDHRqRfZq7SS5OP5o3kub7Mq7uHSq88dR+Ss
         cBnA==
X-Forwarded-Encrypted: i=1; AKwUvBxq1a1JII5OtYh6fBWTiWvyhl1EdJVixQ4tFhl4tCKtUDabydjkkKg0AIhOuMhhiamhH6yeNmRMPg==@kvack.org
X-Gm-Message-State: AFq9FYJXzuw8SroGwDZWKkABXvWTUV4KiBcYVPMlqhdHwC4g2w+jtxWp
	tbzqj1R7NZMDiNvOIY0/hTw+6vTjcUAJUxulwKIEuyUJBfXTbNLtB/Jo/wiqJWScJzSY43ht3XO
	9bg1Wbfm/xeDV3b0ZoJoaWsMNev9k2ANkAZ159eU47Q==
X-Gm-Gg: AYBFou0HzZRrafuB9BJhFGE5WnwQ/ia0dCmfQCn/v1oZF7JuFUAfop46l6QRbTfBAxE
	EgrCsbHO6rmGlrw5YxWZ266RxgL2u8+ZxNfsGYNCcsGODiBMtvxU6Bs1Oji5O36wtLMea902Heg
	St1POFycZJXkWoLA44LM2HmVjEukbeEZfETR8lkivJ9hcE6qhLeBFXY7Eg+3PWus6s3UQbF56bh
	HwdinyAeSbP9jwXlULRDgNxo42UKNnq+hFRRHapjNmhYjOJEVV5uz+b/ZCvyvJeybRi1y9Ccqfu
	JUb6Pk74kni3Bv//F8q/5xEX4InimCT7Opf1ykIEPnCxxJRNIWPlxdM=
X-Received: by 2002:a05:690c:6f87:b0:8ac:bc90:292b with SMTP id
 00721157ae682-8acdaf52a9dmr11632467b3.13.1790859011960; Thu, 01 Oct 2026
 05:50:11 -0700 (PDT)
MIME-Version: 1.0
References: <ar2YlFYjYUZ49ZA5@chrisdown.name>
In-Reply-To: <ar2YlFYjYUZ49ZA5@chrisdown.name>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Thu, 1 Oct 2026 08:50:00 -0400
X-Gm-Features: AclHuK-_N3_qxjxd9bTnnN-oxG5y5bJDlBCdZoAzF98oOnG_2AToXeAApXLnGhw
Message-ID: <CAO7JXPjPoLLMg39ZTPSoSuAdPUX3VZmPg_J9bKZc2FHxhO3khA@mail.gmail.com>
Subject: Re: [PATCH] mm: Make swapoff interruptible when unusing mms/shmem
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Ying Huang <huang.ying.caritas@gmail.com>, 
	Kelley Nielsen <kelleynnn@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E1FB218000A
X-Stat-Signature: zg9f73gmof4fegh38it5ag4ph7f8j8db
X-Rspam-User: 
X-HE-Tag: 1790859012-259083
X-HE-Meta: U2FsdGVkX18QwwgYs1JBbuxI5RX3+LA4nJhqrlrP3HUAxoq7Zp4rE1Ib9ohzw9p9vnJQJEc1Dwug3rYlP5U+QzUZuejMNsgvhmtdR58cnXq9pM9FUvbnswTHfKwWxDOGuQvPQ5FCsBFb7i58x12qrRNGGCw/liX4huaLKpSq2eJYXZ/TS97YvVUCv/MTz95mJTtC45bwsW8YE568DAAzcV16CGYDdMdMnG3F0rq1as9ruKNB9001EBaHiqOgnhdGH2wdqZIpM8lPkapWqKNAlBOrXYfUinSlM9u9Oq/rU000+a3UiXNV09zTFcdFyUXWXg0HcGk9lVknZV/tN6xNeSSwqPqQT8xo1Us3/GtC5+sMA4zkw9psOTM1Xpvw3PoxSc0IyO4SC8mra3zXPVZNSkpjhsNPHdZdvio/f9yPqj5gQ35d/xez+4cCmy7n0xh5DHn5BdNF+K/UZJZCyvuFdUa1kO47nKOzXj9xjO3yZZ44gTm5Eo8CfSMB9lPy0I67oDl+hmHBQATHRyIveeSV5/tFq+jH6HWg41+Kjd9fC+8jZImcJWumV02yYzatrtKe9bknnrgG8PNyG0x+M38KbdkAACyKA8ruLsLKU0u++adqrX3EEPLJk9gvKKN52DLR8b/h+u6tO/DF6bFH+Xm3UcaqHKszr6e85OvMrMj+ownJYrweQKimOE15cQAXbvX25JYTsCAzcgPoo48POciji340y6av/saai2sP8cHiDEZ/pS/6DRVCkNjDmBcM9h4rIqE9Q5REPuFrD0qHvATd5aRMZXNohbfCU4IIXDEAE5XmRVWBCWMH7f5jXGuCmYHgdtLcFsmb7tvr6P1dcdrVG36mkHtqigmCC7NhLQKOJ+dq1bQTXHb5I05TNReKh6trWrt+QAhcUxWxEIZs6lbcKwk+h1pbDExvF/bMeAWNj0S8MTjkPDwyKrOycvzC0oj+MwGn2laWzjBM5CovYD/
 Xric8rba
 N7VxaBjA+MIyv9CP2iUCjl1a8Awy7GDYs3ipzaFEilluSpmOHgnj8sjGxaSVLIwVCAuDZgyDzjsTUUnGHUgDOZ4GHDrHtS8GMRXtQQMityi9hFUKytd/OJ+KL2SntjA4lex2em99B9CULS+wW8E4d9vBz5GQKFHx1oAKDRw0lyl8C/v0Yp6RYTPbIhvpcLujWwj/yb54jp/SLTDkSLqkUdLDBsz57z1JLQCnzEbytcH/myOC+jaZLZJFFMQBR4MC2CY00Ndk+9SrXGUi+YI7xM6l+VP8YToHbe8b+4GHUrj/Hwi8ML1dZ5NxPbt0320Gyy/ItBbRVhJCbPSMKGlGkPPWtB9t67UlzKX5IhTt6uar/YPQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 7:17=E2=80=AFPM Chris Down <chris@chrisdown.name> w=
rote:
>
> try_to_unuse() only checks for a pending signal between mms, and
> shmem_unuse() doesn't check at all. That means that once swapoff gets to
> a process or a shmem file with a lot swapped out, nothing can interrupt
> it until every last page of it has been read back in.
>
> Just as one example of where this can concretely show up, freezing tasks
> for suspend or hibernation has to wait for swapoff to notice the
> freezer's fake signal, and gives up after freeze_timeout_msecs (20
> seconds by default).
>
> Here's a facetious example where one swaps out 2GiB of one process to a
> swap file on ext4, starts swapoff, and half a second later tries to
> freeze with pm_test=3Dfreezer. Writing to /sys/power/state then fails wit=
h
> EBUSY and this in dmesg:
>
>     Freezing user space processes failed after 20.003 seconds (1 tasks re=
fusing to freeze, wq_busy=3D0):
>     task:swapoff         state:D stack:0     pid:3175  tgid:3175  ppid:29=
55   task_flags:0x400100 flags:0x00000419
>     Call trace:
>      [...]
>      io_schedule+0x44/0x70
>      folio_wait_bit_common+0x1ec/0x3d0
>      __folio_lock+0x24/0x40
>      unuse_pte_range+0x2d0/0x348
>      unuse_vma+0x158/0x248
>      unuse_mm+0xfc/0x150
>      try_to_unuse+0x104/0x3f8
>      __do_sys_swapoff+0x220/0x5d8
>      [...]
>
> The same goes for anything else that wants swapoff to stop, like an
> admin hitting ^C in a panic, of course.
>
> Prior to commit b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
> try_to_unuse() was driven by find_next_to_unuse() which checks for a
> signal before every entry, so let's restore that behaviour.
>
Nice find, thanks for tracking this down and fixing it. The fix looks
good to me.

Acked-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>

Thanks,
Vineeth

