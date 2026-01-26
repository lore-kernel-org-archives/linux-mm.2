Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8594C88E42
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 01:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1676B0088; Sun, 25 Jan 2026 20:54:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34B926B0089; Sun, 25 Jan 2026 20:54:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 278176B008A; Sun, 25 Jan 2026 20:54:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14E0B6B0088
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 20:54:30 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA7961B0610
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 01:54:29 +0000 (UTC)
X-FDA: 84372445458.26.E2F2940
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 428021C000A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 01:54:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lNTomWoT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769392468; a=rsa-sha256;
	cv=none;
	b=CpD68YMo1CS6f4dGU4DZStLwTDsFPfaWuRIwtYS0DYoG9BOGxxqv5DXzSxaf+S5Jx3ttc/
	uFird7qZml8XtbWxDNcaT3UR9BvTH4BmSXPniNBpmDBLWd2nmyrncFes7CDVOydB9mFKX5
	aU1I6Bptpj+c5qnVhXACKlzsNTDG9c0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lNTomWoT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769392468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nyu57uSYb5lGmRQqv2IuaFGLa8ntALrsc6QD6O349Fw=;
	b=7HOW9MWnEKt5s5hfhVM0EgAacxsW+hT8Wz10x+p+4HEflCLJLV09Yyq0TnEiNXoXI3IK4M
	7pqAxEX/8h8zoMfuiqlqjrTmJbvkBXNSwI0SQ1GXk0A5CsK4xwxNrHU0NhdqSpX7Ok4YMv
	aHNxxmotLMsksnL7E6GgYz/B4mx6OsY=
Message-ID: <35fb4fc8-8ca7-4ca1-9528-630ed4d1e782@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769392463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nyu57uSYb5lGmRQqv2IuaFGLa8ntALrsc6QD6O349Fw=;
	b=lNTomWoT2Ne//HsqXqvGPIBNj+Z5zT2ZjR8uJZR20bL+g77EPlFf828kyzEJ21+x3LmEG8
	P2lRdPazbVJFpigPaPzuvGn4juFyU5zSv9ub4ESdtm6aCilDzhTBdTCyzF6TtB+fQDowq8
	Uemnq5i0BxAaDfu1FDMEgBeffATSTd8=
Date: Mon, 26 Jan 2026 09:54:17 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [mm?] kernel BUG in hpage_collapse_scan_file (2)
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, willy@infradead.org
Cc: syzbot+bf6e6a6ca143afea5ca2@syzkaller.appspotmail.com,
 Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com, ziy@nvidia.com
References: <69757ea0.a00a0220.33ccc7.0017.GAE@google.com>
 <20260125121001.32733-1-lance.yang@linux.dev>
 <7bce9231-714c-424a-a4e3-dd42734fb767@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <7bce9231-714c-424a-a4e3-dd42734fb767@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 428021C000A
X-Stat-Signature: h74mg77bt9fph68hf9kda4tj6b4toh3j
X-HE-Tag: 1769392466-112541
X-HE-Meta: U2FsdGVkX1+EQxESi5wC0c/jKcelJFL8UBizihGdQMnePnpkbGP+uvX/GSegxrE3ogMNX8CRaWYmkOF/McCLsrPNiTZ/DFSRnPJfbhQky2FrZB4nKpcBijj/rN1ORqMw7EUSZ57SDZ2AQZyH155fnX+Vykkl8RJuouvJh3pF9zd33C+desD+dxXGoLnUy0vX2yiwaT+bkvDZHl9yUxpDeyCpOOhqtBtzwNUiP2HIHXUpbpCQC97L8ew1UnBY1t48IsvMrDBGzeHbxb7mGnZ4pHhrs8X3Ryyob3qgiI/3r5s8FzVbgw4mlJQ4CnwVaPolPQjLdgQAETKrriVgbivATJ3KC1myiahs/rHw7wNJ1G0Rfo0txGf4CBzkyropuvitqTEC5f5uG949neiDq3kZVPrKe8C0TQcvf0umE5rpBHam0hQAZMBAkALyBcw9CUAYQDjsXnvd86bIid2dw+ilPpWSsqQwFRxxjxh96LvF+4eJUqH5M+Hd6MjYAxP1cr0B2M+dEzJivVWnSh0UVxH/XKatJtU4notjHiAQK1+7cSuE5Z+XeJSGW5GT5XfQrltDrXTkD8NUWCHiDVAODhLjLvWG5rMXOmig5zmGc7qlPmNT1e/C0RHT7xvwJAsFksblouA+vV/k4hfsimcm9+Bc1kmbH4eQBBeTQVNTO+4jJ97/zZISTZARDwOlr+FiIOoEJa7NPJQKIgObiEeQDnycxOPpq9jvBDbbx1uw4E3zQjObk8JlNsAzWksw/2CQeL1eZUGuh71Q5vm3mHngOhoXbDoi+OcKVMenQ2IBQgsmXM4yGXVkt0C0nq0WffnnLltvLs9csSpmX9iwEUIqBPHhSIygQZKAfyp8iDZkeQweWL8j5DPq4HRt/zGzhe4GjjGc3fAcMWYMuP4Sc8qCugq7KAMI5QdrP/C/hi8Kcd7t9TXjVbapoXS2xiLwZev6+IjW3E2EiBOWKIdFJNCRxIH
 JOazV6+2
 cAUX6byGLke5r1e1kGh6oPsDEUw6Yhz8nYUyusE2LMayBIKYiWIz5waJ3R3c0Y+nZf1V0YUjgchVfVx2cEwn20M/b1KC64BH2rZlkZspVW/QRKRL7XytIenZ+sX74xSCMqN2mwLFgjCcfhxOCQttUSS41JVYcgRGC3xy2tuescpBSCJfwrye/IZiFDFMKK9WdUuPwShHKL1yZmLCC8BC3G+JnStmOtNnUVXZPC/rGN74L8QGjyMdVr/Sq76MJu433dJACQUu73rQs/hw/+qjHFCeXdSFBGonraKGVydOcayHnbECwHxwVMp100QFOp/3RaWr0Im8odcmcp+QZOo5roGffsO4PUFctkO4kkpXL9q8/G9zJPg6kM14ttHOVlUVxC+fy/qzldwCbSRJTIwFUzRP0i3v/fl6Wi/dbBfg8/cEgip+eQydKHU5q1hPRk1dl3v/ch0cTa49mHo1egZrqFPm8eCmuY30ynMvXef+7vOKseFK4R6H6LMlMCn+TG4d0cncZWkPTB/dI72WJcG1sCWdrXx0UPrdcdqPu7jOch9bCZp2A4kMvXheQXDLyJEXDLMkojl/t4buZdsv9/kRX8dlkC+tzps/Zzcs8IN1W4NwgfSfCh+2d4sfHbN6eHKron2mPFVTYiNyT5So9OP2gfysAI1vmpJ2q+So48tmvdztUsrIdORQEkWzj/W7AwNsDYwoaw3OCeLNRj+ACqGfs39RbupuR3wNAm7fWEsTW1vdlSMdupfhGADSESCf/0BjoszXITmXsnQGZ94NWi0G7BpMKi92rsYLYHLy7QAfDcj6U7S0z3nT5VxVxkP4z3KOhFco4kTOSMZIu2k8WD7EyY5BcEUcc26InSlEHrych+Y0zlJrY+V1BkRqOpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/26 02:13, David Hildenbrand (Red Hat) wrote:
> On 1/25/26 13:10, Lance Yang wrote:
>> Ccing Willy.
>>
>> On Sat, 24 Jan 2026 18:23:28 -0800, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    ca3a02fda4da Add linux-next specific files for 20260123
>>> git tree:       linux-next
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=10c42452580000
>>> kernel config:  https://syzkaller.appspot.com/x/.config? 
>>> x=10f2b64f8f12b9a4
>>> dashboard link: https://syzkaller.appspot.com/bug? 
>>> extid=bf6e6a6ca143afea5ca2
>>> compiler:       Debian clang version 21.1.8 (+ 
>>> +20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 
>>> 21.1.8
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz? 
>>> x=17f7cbfa580000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112d405a580000
>>>
>>> Downloadable assets:
>>> disk image: https://storage.googleapis.com/syzbot- 
>>> assets/291ebca63a31/disk-ca3a02fd.raw.xz
>>> vmlinux: https://storage.googleapis.com/syzbot-assets/b2112a214b54/ 
>>> vmlinux-ca3a02fd.xz
>>> kernel image: https://storage.googleapis.com/syzbot- 
>>> assets/77d1ae437e07/bzImage-ca3a02fd.xz
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the 
>>> commit:
>>> Reported-by: syzbot+bf6e6a6ca143afea5ca2@syzkaller.appspotmail.com
>>>
>>> node ffff888148816ec0 offset 0 parent ffff888148817700 shift 0 count 
>>> 64 values 0 array ffff88807be6b0f0 list ffff888148816ed8 
>>> ffff888148816ed8 marks 0 0 0
>>> ------------[ cut here ]------------
>>> kernel BUG at ./include/linux/xarray.h:1441!
>>> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
>>> CPU: 0 UID: 0 PID: 6017 Comm: syz.0.17 Not tainted syzkaller #0 
>>> PREEMPT(full)
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, 
>>> BIOS Google 01/13/2026
>>> RIP: 0010:XAS_INVALID include/linux/xarray.h:1441 [inline]
>>
>> Seems like that is:
>>
>> ```
>> static inline struct xa_state *XAS_INVALID(struct xa_state *xas)
>> {
>>     XA_NODE_BUG_ON(xas->xa_node, xas_valid(xas));
>>     return xas;
>> }
>> ```
> 
> I think there was recently already a discussion about this.
> 
> See
> 
> https://lore.kernel.org/linux-mm/aVvz3tYdu49TGkjI@mozart.vkv.me/
> 
> 
> And where Willy said that likely it needs more thought:
> 
> https://lore.kernel.org/linux-mm/aVwm3MQ_ZDa_kU8c@casper.infradead.org/

Ah, I see. Thanks for the pointer!

