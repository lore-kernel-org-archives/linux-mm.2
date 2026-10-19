Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99733CCF2E3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2F156B00DD; Mon, 19 Oct 2026 08:48:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE0886B00E3; Mon, 19 Oct 2026 08:48:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1C646B00E7; Mon, 19 Oct 2026 08:48:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 838B56B00DD
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:48:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 26EBCA8222
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:48:34 +0000 (UTC)
X-FDA: 85339354548.30.96EE777
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf24.hostedemail.com (Postfix) with ESMTP id 19E4E180007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:48:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XL9jo5vg;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of chengzhihao1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=chengzhihao1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792414112;
	b=YHi8p2G2RrwRS2vDlkhhC03tdwtQexhGmxWJbHlyyAYh6Ez47vbRaua0w6iuP2+3w8pYZ4
	K6oywsgi94YWw7mRRm1z+xVtC9ExBL8OMA94wEpPPYy1cpQdqOQ1kTB6iH1Qv1G7i1OxEF
	UEutI37dYuWGHiYuENLMNq9ANqqKMyo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XL9jo5vg;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of chengzhihao1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=chengzhihao1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792414112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MV5RrEEMJXzqIcVuqwIGkxm5V8DKAxWOFj4ELstqf7c=;
	b=5CoaO5eQMyYV/oH12r7I3IPJaVQvQcAxajhbRC6KQybNwpGJVdY84EFhmIFpEhA4+YDg+B
	VqTrcFZqsoPgNPKXYMKGAvfmtW7ksQIj5eLXrJzYCc9v5E4KF9ckL+KfB68INILnUgDKO0
	6HOJR5grfRBSTH/mfW+Itbqs2Ne0Og8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=MV5RrEEMJXzqIcVuqwIGkxm5V8DKAxWOFj4ELstqf7c=;
	b=XL9jo5vgq0oiKOY98nWUyAExz+PImnG2MRncQY6TXVMBppLsZwnH2pLigVPxp/5fsm1z+nmyH
	KfDit8K3iBEFZNcvnCMB/L3u3YUr/u+KzZeJgwsv2fxN1tHrOz1OHXO3yGfH71qQKhaq6STl3ag
	eblAXEeawk8ldFmWgBuMhec=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4j7b1z47GSzmVXY;
	Mon, 19 Oct 2026 20:48:23 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id B96884055B;
	Mon, 19 Oct 2026 20:48:26 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 19 Oct 2026 20:48:25 +0800
Subject: Re: [PATCH] fs: rotate inodes whose page cache could not be dropped
To: Nick Karaolidis <nick@karaolidis.com>
CC: Christian Brauner <brauner@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Mateusz Guzik
	<mjguzik@gmail.com>, <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20261016102515.111285-1-nick@karaolidis.com>
 <5b74fceb-dc8d-21ad-d313-eba7a0009056@huawei.com>
 <qNyuimLVAkP0k7luIlbuqeg7Co3gXnyrzZ2fIuFjRZiKon2IaylrG1-_tkSRE_cWyOuq6eIzU6O12OvRg8J-ZszqHBaxE0XL2uYVhQ08MS8=@karaolidis.com>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <db764681-95cd-7c15-4b04-1372018fc93e@huawei.com>
Date: Mon, 19 Oct 2026 20:48:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <qNyuimLVAkP0k7luIlbuqeg7Co3gXnyrzZ2fIuFjRZiKon2IaylrG1-_tkSRE_cWyOuq6eIzU6O12OvRg8J-ZszqHBaxE0XL2uYVhQ08MS8=@karaolidis.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.46]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemo200011.china.huawei.com (7.152.185.179)
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 19E4E180007
X-Stat-Signature: jrkf4ifxat4g7ookfos3hwcpg3zwti6b
X-HE-Tag: 1792414110-328504
X-HE-Meta: U2FsdGVkX1/bBxqY1cInIIl2w7XK3UtUZzUeBx8DdfWjyDWP477N5Egl30r8q8cgcOuJXV6ex6W+xNwL/fQUlLpsfgcIr/zNxh99GY34bhRmSQG3ASsiI//PAlayaQv3nTaYAmotGejOK0Jb1ypaIMkH7+dvygQiP47PwXlZ/xVTZ/1Y0ZBrB7M33eaK6ySz7zmZUQbsL0SW/CTQfnD6jDfrP47MWb1mvmQSxfzVDQlXmOX9NXYENElRKa2BDfzswoWSxaG1oesjQVD1GobGGGxQ+nACoTDK6N4wIGBDzUeY0WF21o7g91zkuOgosmYctDCmELPobcHvcstPidhk8M6UL/nwIlWQzyFEmmFv1btCqIYIVjvkT0SA2S1lkXS8Mzi8o3OJ64KEzNPN43QLS9IsiODnbX+vs2zMgmNKr+p9QzS4zjP9wRibu5RYNKjrkQwPuNVISaa/pG4LKWXMhZkR/KWwukfDGJ7dhBWW1HLsGuvEbKVZsz/mwHel+ls5QMmsXfc6bo2h6JNEst26VIjGgH/w5Xe1BQtImOBCIG8fHQZjQyHthvJ5deHGFzAjHZsVcokC271pBk1VfzesxkWRiHOSuHEHmkyswBtVS2Egj6XsgMB/6GtbTe5g+hNQepns/iOBPhIHeG8Tnuxw0o1c/wfGlseX7rX5e9lGHi0kjC2d/IX/xswQNG+1eHdBQRRYYsRmoriuLgRqgKVfYo0FDsi/SXqqbAAfV8FZXGIjjfa0RGtIml1ibaeyDPANf0jh38SgrprhIsJXfzdPAxXo39XAw+yTZuzbG3WgJbuyGX2o7/0CpGZJ4jb/TRFI90ObvHQaCoRJZMfPa5Ql8weFLx1xgj3aYb+beLN4QD/OTKNUCpVTFCRI58cvXnZsn4bEswt1AeklBHwdixzEDVszWX+Mv/tXEC+BYq6JYnl9WwXcXt0PaE2Bas4HSEkLulqEf5/pyRxUqKLYtFk
 RWAKjH0S
 Zy6CeGdxlNQtKg3SPNf5ZGW+UYa+nw0O7JUPs/2ZiVfel77wCSjnnBF3UedqvYabtH/DTEvT158yVYQNojyl1sUoqohAlpApz0E+X1Rmu+G0yCjdS1huXn/VjO7DUWQ6xqZ/GZoln5Oz5a41ZIfMQtSdd+NC7wgmTysMvXvhMlIrwywYRfjNwe0XMgECTi9wWubA+hVEp6EyM0NM3NP5UD3OOAagTi/HVMr91mIbI1eRwXV5L6cal9DS1teUEmKoAuXLrDZJqtfebHFA0IWi9nJ8o5CwWpccIVYySeBHzVTJEdpFY3GxMzdVVGWHG1KD3ia8sTLaGAeXLGcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/10/19 16:50, Nick Karaolidis 写道:
> On Saturday, October 17th, 2026 at 8:43 AM, Zhihao Cheng <chengzhihao1@huawei.com> wrote:
> 
>> Hi Nikolaos,
>> I find a possible BUG_ON if this patch applied, details shown as:
>>      P1                          P2
>> prune_icache_sb
>>    lock(lru->lock)
>>    inode_lru_isolate
>>     if (!mapping_empty(&inode->i_data))
>>      unlock(lru->lock)
>>      spin_lock(&inode->i_lock)
>>      inode_state_set(inode, I_REFERENCED)
>>      inode_unpin_lru_isolating
>>      spin_unlock(&inode->i_lock)
>>                            unlink
>>                             iget_locked // find_inode_fast gets the inode
>>                             iput
>>                              iput_final
>>                               drop = 1
>>                               evict
>>                                BUG_ON(inode_state_read_once(inode) !=
>> (I_FREEING | I_CLEAR))  // inode state with I_REFERENCED
>>
>> Could that be possible?
> 
> Hi Zhihao,
> 
> Thanks for looking at this. I don't think that BUG_ON can trigger.
> 
> - The patch sets I_REFERENCED in the same i_lock section that clears
>    I_LRU_ISOLATING, and evict() waits in inode_wait_for_lru_isolating()
>    before calling ->evict_inode(), so the walker can only set the flag
>    before the filesystem's eviction runs.
> 
> - clear_inode(), which every ->evict_inode() calls, sets i_state to
>    I_FREEING | I_CLEAR.
OK, I missunderstand the realization of 'inode_state_assign_raw(inode, 
I_FREEING | I_CLEAR)' in the clear_inode().
> 
> - Evicting an inode that has I_REFERENCED set already happens.
>    iput_final() sets it through __inode_lru_list_add(inode, true) when
>    the inode is already on the LRU.
> 
> Did I miss a path that checks i_state before clear_inode()?
> 
> Thanks,
> Nikolaos
> 
> .
> 


