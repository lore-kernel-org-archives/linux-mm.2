Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AAA4108E1E6
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 10:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BA1A6B046C; Thu, 19 Mar 2026 06:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0907A6B046E; Thu, 19 Mar 2026 06:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8066B046F; Thu, 19 Mar 2026 06:56:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE5AF6B046C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:56:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A00CD14041E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:56:26 +0000 (UTC)
X-FDA: 84562508772.01.2870708
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 860E7160003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:56:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AgMJuzhS;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773917784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CosBUGM7bnn1m+m5cmQog0QmFGfGkJ3fugyrvWs52oE=;
	b=fqpgV9Kdamez4onfxtwZ1F/ZQq2ciNxbOo0tfRcQ2FU5p3MjdXVlsSWdHSraldS1FOOWCx
	fA440jz2Yx3o2HS9T73k5KJTuBEK4gp1Lc8lIA17DjrKNNILRfF6IFEui52OMrJu+CgR/l
	uS7NPyohOWMZO0n9e4Z1R2LxJ63iXW8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AgMJuzhS;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773917784; a=rsa-sha256;
	cv=none;
	b=OHIfsxv4VDJNY9HDkA62vhKfmI4h3lobwiD56VIt6uciUOGXnLGyddxowTxQSjQ/pRyy2S
	NMsRf5ofYuQIFj4+eWvlQ7Z6i1l5zEPdTM05Gaq5grSeVxNhIx4nIcz7LOP3pfu2/MbTrf
	vbt70FPUgIyTVWjcewadhmkHWMvtwxI=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-486fc3ac9fdso430525e9.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773917783; x=1774522583; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CosBUGM7bnn1m+m5cmQog0QmFGfGkJ3fugyrvWs52oE=;
        b=AgMJuzhSYr5GCgsG1QPnnf7Jh9p0PQ+XMJf2F7iWXmgCojl/mG/lfGt40wp4EuNZnh
         HZLNb0sqy/3bw8bZtpVtax4kzSYr8T/liw6oEFevHf2BxJAcR7HuxEfh29XJm8dhEHC1
         69bl8RLaWKNh/XvsdbMCwIrfDBkCylH0qR8qG52gQBmhvRLxvi1LNI2D30CZbUEbfbL1
         81ZI4+QyTdcAZfJ2rokK4K9DcHm4+TU3g3bKKBOHgqKZMHEutj2r8NG1mtfDFaMxZL+w
         OiVDv8xvWVdjZ1acED6Lc1Y2Covi2rSnvbFlLjoeGwHiXmDEJ7lpgudWnoyevJC781d4
         h0oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773917783; x=1774522583;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CosBUGM7bnn1m+m5cmQog0QmFGfGkJ3fugyrvWs52oE=;
        b=AVT8UN1Jh3BYjzps4PEJOX21YtQRHjVEse8IcjopbvLSxCDldr/o3t3dJaccARg3i7
         2Euj95L416/XreEpUVWGsB3pI/INWkoDgtRnzCwHcJ8hWJq0KdoypFiwxd0RmvPIUBDV
         VrsBkKWZUom8fwqcPEpoX2McrTNjstYsqZWjiRWhsGMWKBB1dyAropkxQaGtUZzqBxh+
         GHrY5MES3vFLCeJVECeYMPPr+JOYsivAwGomftPgMBbXzLgol8a+I0iHac94GJ6TlcEn
         +QU0TgVf2khrupCUUyz7xNsvL5j6j8SnSE67GhQ3jgKTuyq3oj1PyphPTSSYSNeX0OOw
         jCNg==
X-Forwarded-Encrypted: i=1; AJvYcCU1kVqpT60BJWhpmABzhWtszwlZ7CTn5BmU8Q/peqI28FyRPXsDb631qFSvrOw8QVsfItAi5C6Rxw==@kvack.org
X-Gm-Message-State: AOJu0Ywc8lPnsDbL2GjtUuPj9+c/5UZEzkpQso9YznY+MLjJWY75Odk7
	P2RJuX0Gb+OLjLM3uMQCJNOplcB2peD///wm2fhYaKrjC2WMn8zSj23VHCL4AXChuwM=
X-Gm-Gg: ATEYQzyTAnrcJbCbx8XPduXTm0OB288k71z3IR+yp6atZFa/tE9PzfKNWiiHUWaen1U
	A8QQVo1+lyq8r4lPgXJb/OB987XXtvzwW6KtHB4fQRfmG1twfaQhJmO1NGFo6nYMD+oWYnHoTa3
	pYf7vsnmVUGWBylpEJMtKsADCFG59hLRiOHZ/crqA2by5RWgSdAtkmISLwMzpsRXj0nQy9yd5gc
	xSkJK6vzfcn3t7GPbLHC9ZBg/2wcvWHFAabeBMufLK2KXVL38ybhCKdW3SJYt0kLSQK78MaYhwE
	hWYU/bO3S4Nsl1iVT90SJYaxr6fVBI2KheyfHFVcmaL0GVRHPRVKAwPbr4Y9V6J9sRLs7qgouQa
	uJEQFpeEiN5tSow2Fj8GPPZMRdG5F3MQ8nmboHrpQhB481oWPEbR6uC3o20aN5ENYsQFrGzfKuT
	Gi04wC9IGLBZJ8avmDba7fHugEWy8xcmbzr88s5jFjoy4rRP/vCzeNPaOtOQ==
X-Received: by 2002:a05:600c:4f0b:b0:485:2af3:3f8b with SMTP id 5b1f17b1804b1-486f44385e1mr68098915e9.1.1773917782652;
        Thu, 19 Mar 2026 03:56:22 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f4b89d87sm81564425e9.6.2026.03.19.03.56.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2026 03:56:22 -0700 (PDT)
Message-ID: <5eaa234e-76e5-45ec-833d-64d76903d1bf@suse.com>
Date: Thu, 19 Mar 2026 11:56:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
Content-Language: en-US
To: Lance Yang <lance.yang@linux.dev>,
 syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>,
 david@kernel.org, ljs@kernel.org, willy@infradead.org,
 Mark Brown <broonie@kernel.org>
Cc: baolin.wang@linux.alibaba.com, npache@redhat.com, linux-mm@kvack.org,
 baohua@kernel.org, ryan.roberts@arm.com, syzkaller-bugs@googlegroups.com,
 dev.jain@arm.com, ziy@nvidia.com, linux-kernel@vger.kernel.org,
 Liam.Howlett@oracle.com, akpm@linux-foundation.org
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
 <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 860E7160003
X-Stat-Signature: sig5t8r7o9k98crmwu9y3u9e3cs3817r
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773917784-61520
X-HE-Meta: U2FsdGVkX1/ptWmt5zbs+xm6fiG8OjZnwr7Wh0gGdlccLbJreXOX1MVY6ojN+vy+Uzw0HsV07gB79qIF/RGiec6AJbajcVzHoth1io7vnSUudeDBLD80y01ZzL8/AYcsNtHwRbs3ICzXR4Nmwq8o7mr6fpnvkc+uZoAldrbchhXQJ1rHrp2zE9eCOVSFphXln6q1PUQomVmFayPU1hKcl+hZnfRWyFIceJPXpUpm26arJ4m2nJt2pS4kq6SxABj7SQS+XXJAqqumsUNK/JahMTyNEHsXnYvov849ISdraAVYqir1Ue8nr8FeQDPuCZvRXtbykXo/4JnWIIC7LU6ipKzAX4xn9mNEBahFMXU663W+dxigv3uK/kS4Ttb4eDEwWxOSkuupy8MbuAmSXlh2xfXMeBGziAusqVFkPr1vuTwNN/oFZhpejGtyG/coRIzWWIw1YWflF6MM6jtCJA5Uk1/TcCrwB/6LCDAl9LwB2oyuqUc16yloQRpzF8SJvt5bccNyvaph5NS93oK2FFqm1oYXmXnMOc9cuYXTdYO+b6JUBBnYEvhYWRQO3VHwjh7+woUPsOVLlk7z8bwBphlIejM7lgx6KeEs+4PN4DcSjQj3D395KrPYMDfKmBe57Xb0TBIIf0AOSu83fO2aOr4f6GE4DXbLURETBvR+fPF1JkFbtC8xtWi/8rluuSYiQsB6XsNSWwWuK0EUv0ytBheuuJ57BfKou3ov29R4Uj7BEr0YD2Oy2cnlIbdgvkO/XYhafVC9m4DTYkX/lClZC+JoHdejZXKHQIcszxz0I4aNZrwXSYgMae5x6VgIIY+IydzcnyHzReC/+KDQg3MRwddZEoY76y4+sKJrLuJrIx49TO0Y7LhgBM3u/Jr3xehBUS0QxgONvLj5h8WtHeq8OryPZg8wKOZQYyCfyBPk4EviTGHlH1G8+8COU6QWG/U88JCbCIc7PXVT5hZf2JBGisu
 nmtm1/EN
 5RGdrn55FxCAt+mlg6Lx5aTQHD0s8yezxlV3ZdXsqBvQgk7Ath7nMnOIgud2qq12iQ/PgP5Ne68zl0IauJWdLVzAdnH9RjwlHQ3i0oYQZXghLs+DfGM6Wfs79rC6C/a92V3ohrgR5eOiySTctronOM3ZPuSyzZwWN3D+ETHKl8W4SVDwVXwIfCywG0UEprs4EQJBl583nCTvZZ8eTk7XBusDBdg445BWptHFNUgZ62aIACoIretTyqCxME2Eqq5Pu0MnqtZ8WBpcNUQUU6pnQ4V4gHMNE00u8IGBAUu0drj5teT562ZFkq6RLXAJ/UBUEYrSePLB3wHJ/mKX8zcdzEvB7EMmP27AN8Q0uhB20AfVKKisl4CwSAb6siy7bQCHouzKfQ3L7oJdUTIc2+W4nlaa0U9fffj+QvO60MBNvySlvu4QnLeCXar1g+rhbgGG1+7kU+PmII7Jb3nvbU8A/kYyEEKWZQe3rFcg1kCAlICSLKE2WSwITqpqoGR3O0Zu2VTy9ZgFYYd2Ud3PvuLtYfFylbTP6EwwBALdP2X8elkkdid01blcppTEPubV45rHRmq9ioAY9RN0cPasjQFhBzzLpkd29XB2222CMffonoi8aMcFYr0gnrm8R/12eNf/+0EBJ2RESaOFHI5ZPrDUYRILs2EWAVGAwQy3mQ+VUu0TZ8KdW/kyQ6vgjXPoqPDPV+Np/ys81TQaZexblt0HcNPRH/thvMjwAmRIsHG3KdcwB1Y6NCUCwLAXBI0kwST+fvLun2prOpNBJuJRIKm+2BunngtjMl5GHK98j5KQsbDkcmeUGo8/HF5FqvntAGekyi+HgrqMRQGvxcwn8ML1Tk42OcOADZyMVoGnxSDqT+2RizMZA5KT7SCptyyJw4R0BaOQMjC56XAyBZrghMFBm1eVqv+FQO+w2L1hN+ZsdjKkbwV9sceHK+UUsdjCKrAMqP8ledAUD+VHjmekvnmoeAhGmdrg+
 qrfCWS20
 TLI2dduBr8EkmmvpD1jaFe+mjrYjMQ/AEUrbQyj0OXn0gwzdCWAYjsuCJn64+xvymvhnX7q8gSw7s5jXlPX1w/qzZ2bWLEyF03xXWW+ySLT5H/1oezb4eSJvrsXsV71eoxTjY6jd70yNpj/RKwLo48IVSFazB/bbmQl6rLhhD4SZibxXf9ilILZXn5wyarp5rTs3VrouRLtPdtwSSlyeB5j6VFtRMJ3PvyJOWTud2foaAoyET7s1EhnN7Un7m7yMfbXjN8CM9OOWcC78i59dAoea+f+B3mnav39ACwwxd+Ktwndl29oGrsVIsGZ2isdjIs+Tl0a+jJ1vff33w25ILojbArZwueLkdvNypglQK69iF43+cr9W2gQ5OUNbM0nQo9Epx3XlHQtJxtxoHSSvXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 09:05, Lance Yang wrote:
> Ccing Willy
> 
> IIUC, this is a dup of the earlier report[1], which I looked into back
> in January. The root cause is the same: collapse_file() calls
> xas_lock_irq() without resetting the xas state first, tripping the
> XAS_INVALID() assertion:
> 
> #define xas_lock_irq(xas)	xa_lock_irq(XAS_INVALID(xas)->xa)
> 
> static inline struct xa_state *XAS_INVALID(struct xa_state *xas)
> {
> 	XA_NODE_BUG_ON(xas->xa_node, xas_valid(xas));
> 	return xas;
> }
> 
> Added by commit:
> 
> commit 43b00759f21b10142094d1ae5ff65cbb368953a3
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> Date:   Sun Dec 14 10:53:31 2025 -0500
> 
>      XArray: Add extra debugging check to xas_lock and friends
> 
>      While tracking down a recent bug, we discovered somewhere that had
>      forgotten to call xas_reset() before calling xas_lock().  Add a debug
>      check to be sure that doesn't happen in future and fix all the 
> places in
>      the test suite which were carelessly doing just this.
> 
>      Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
>      Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> I posted a HACK fix at the time[2], but David pointed out that Willy
> had mentioned it likely needs more thought[3].
> 
> [1] 
> https://lore.kernel.org/all/69757ea0.a00a0220.33ccc7.0017.GAE@google.com/
> [2] https://lore.kernel.org/all/20260125121001.32733-1-lance.yang@linux.dev/
> [3] 
> https://lore.kernel.org/all/7bce9231-714c-424a-a4e3-dd42734fb767@kernel.org/

That "needs more thought" was Jan 5. After 2.5 months later this is still
messing up linux-next testing due to a known unfixed problem. Completely
unnaceptable. Willy, you need to drop the new bug check until the known
problem is fixed.

Mark, please drop https://git.infradead.org/users/willy/xarray.git from
linux-next until it stops breaking linux-next. Thanks.

> 
> Thanks,
> Lance
> 
> 
> On 2026/3/19 15:20, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    95c541ddfb08 Add linux-next specific files for 20260316
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=15ccc216580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=ed431987028345c6
>> dashboard link: https://syzkaller.appspot.com/bug?extid=8961cb270ae74b4129fb
>> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f778da580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12cc006a580000
>> 
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/c40f27ad73d8/disk-95c541dd.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/bd811888f684/vmlinux-95c541dd.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/3b72363d7dbd/bzImage-95c541dd.xz
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com
>> 
>> node ffff88805d558b00 offset 0 parent ffff88805d558840 shift 0 count 3 values 0 array ffff88807a8195c0 list ffff88805d558b18 ffff88805d558b18 marks 0 0 0
>> ------------[ cut here ]------------
>> kernel BUG at ./include/linux/xarray.h:1441!
>> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
>> CPU: 0 UID: 0 PID: 6001 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
>> RIP: 0010:XAS_INVALID include/linux/xarray.h:1441 [inline]
>> RIP: 0010:collapse_file mm/khugepaged.c:2055 [inline]
>> RIP: 0010:collapse_scan_file+0x4f98/0x5230 mm/khugepaged.c:2404
>> Code: ff 4c 89 e7 48 c7 c6 60 b2 dc 8b e8 82 62 f1 fe 90 0f 0b 48 85 db 0f 84 03 01 00 00 e8 71 e5 8f ff 48 89 df e8 a9 20 7b 09 90 <0f> 0b e8 61 e5 8f ff 48 89 df 48 c7 c6 60 b2 dc 8b e8 52 62 f1 fe
>> RSP: 0018:ffffc90003826e20 EFLAGS: 00010246
>> RAX: 0000000000000000 RBX: ffff88805d558b00 RCX: a13f20bd39c5a100
>> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
>> RBP: ffffc90003827130 R08: ffffc90003826ba7 R09: 1ffff92000704d74
>> R10: dffffc0000000000 R11: fffff52000704d75 R12: ffffea0001b678f0
>> R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc90003827010
>> FS:  000055557e3c2500(0000) GS:ffff888125437000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 000020000000b000 CR3: 000000007ac66000 CR4: 00000000003526f0
>> Call Trace:
>>   <TASK>
>>   collapse_single_pmd+0x22b/0x4510 mm/khugepaged.c:2437
>>   madvise_collapse+0x34c/0x820 mm/khugepaged.c:2859
>>   madvise_vma_behavior+0x1094/0x4460 mm/madvise.c:1362
>>   madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1711
>>   madvise_do_behavior+0x386/0x540 mm/madvise.c:1927
>>   do_madvise+0x1fa/0x2e0 mm/madvise.c:2020
>>   __do_sys_madvise mm/madvise.c:2029 [inline]
>>   __se_sys_madvise mm/madvise.c:2027 [inline]
>>   __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2027
>>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>   do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f90d419c799
>> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007ffd50711398 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
>> RAX: ffffffffffffffda RBX: 00007f90d4415fa0 RCX: 00007f90d419c799
>> RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000200000000000
>> RBP: 00007f90d4232c99 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007f90d4415fac R14: 00007f90d4415fa0 R15: 00007f90d4415fa0
>>   </TASK>
>> Modules linked in:
>> ---[ end trace 0000000000000000 ]---
>> RIP: 0010:XAS_INVALID include/linux/xarray.h:1441 [inline]
>> RIP: 0010:collapse_file mm/khugepaged.c:2055 [inline]
>> RIP: 0010:collapse_scan_file+0x4f98/0x5230 mm/khugepaged.c:2404
>> Code: ff 4c 89 e7 48 c7 c6 60 b2 dc 8b e8 82 62 f1 fe 90 0f 0b 48 85 db 0f 84 03 01 00 00 e8 71 e5 8f ff 48 89 df e8 a9 20 7b 09 90 <0f> 0b e8 61 e5 8f ff 48 89 df 48 c7 c6 60 b2 dc 8b e8 52 62 f1 fe
>> RSP: 0018:ffffc90003826e20 EFLAGS: 00010246
>> RAX: 0000000000000000 RBX: ffff88805d558b00 RCX: a13f20bd39c5a100
>> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
>> RBP: ffffc90003827130 R08: ffffc90003826ba7 R09: 1ffff92000704d74
>> R10: dffffc0000000000 R11: fffff52000704d75 R12: ffffea0001b678f0
>> R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc90003827010
>> FS:  000055557e3c2500(0000) GS:ffff888125537000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f8156602000 CR3: 000000007ac66000 CR4: 00000000003526f0
>> 
>> 
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>> 
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> 
>> If the report is already addressed, let syzbot know by replying with:
>> #syz fix: exact-commit-title
>> 
>> If you want syzbot to run the reproducer, reply with:
>> #syz test: git://repo/address.git branch-or-commit-hash
>> If you attach or paste a git patch, syzbot will apply it before testing.
>> 
>> If you want to overwrite report's subsystems, reply with:
>> #syz set subsystems: new-subsystem
>> (See the list of subsystem names on the web dashboard)
>> 
>> If the report is a duplicate of another one, reply with:
>> #syz dup: exact-subject-of-another-report
>> 
>> If you want to undo deduplication, reply with:
>> #syz undup
> 
> 


