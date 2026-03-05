Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0318F47CA9
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 18:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40E796B0005; Thu,  5 Mar 2026 13:35:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0406B0089; Thu,  5 Mar 2026 13:35:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319526B008A; Thu,  5 Mar 2026 13:35:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 208A56B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:35:05 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8FE28A655
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:35:04 +0000 (UTC)
X-FDA: 84512861328.01.F849502
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com [209.85.167.196])
	by imf05.hostedemail.com (Postfix) with ESMTP id EDC69100016
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:35:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=NbaabLfr;
	spf=pass (imf05.hostedemail.com: domain of carges@cloudflare.com designates 209.85.167.196 as permitted sender) smtp.mailfrom=carges@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772735703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rFhcK9Uem/LtMASOKzs4MxD6L+NtroLNk0fzDq8XxNI=;
	b=lZs8EjZlu9UyuqKzJf6Sb1Gvz01Dv/GLlgKjnJqNlNoZZoL0MXve7WwJgJ4J4wdX/tt6/V
	tHghVknHQZI+XPD7YPZQ7f78ArCYBV0cf9tIQJTG7dofHO2O4MyEnPgOWff1FMbqNNW3Ek
	b3a8dZzgby+5uaFUj9P3v2eBbaVY1dM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=NbaabLfr;
	spf=pass (imf05.hostedemail.com: domain of carges@cloudflare.com designates 209.85.167.196 as permitted sender) smtp.mailfrom=carges@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772735703; a=rsa-sha256;
	cv=none;
	b=zhApjeRcLjeli7i2bHiU4QYGEPuoB2TjHaEfwQ2UPeMF2SS2y+oXBsgzSczkU8o7FiZoeL
	os6GPMeJ3vaWrrTQVPMbOIqpWX9+QBx/LBCQcqZSwPDzJG3WJgCSf08CXKWpb/B9Mc2aQd
	c0Q871tTDkJuMCdE2hJg9DwE8QCkbTQ=
Received: by mail-oi1-f196.google.com with SMTP id 5614622812f47-4648448e387so5562008b6e.1
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 10:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1772735702; x=1773340502; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rFhcK9Uem/LtMASOKzs4MxD6L+NtroLNk0fzDq8XxNI=;
        b=NbaabLfrz3hqb/JTJV/QdRA/9frRIoGD3RIzjTef1P1zt4+y1tQsvFEkQxU8d3M4E2
         hw04djkzxfZno0liKNMm5G+wWhe2xArSDXhs4nm320JXMUJys/vEc59smYwHknE1qV8s
         XF3T0z7/TSOOfsWvN/Ax9Wqe6q3UxTiGorLKBWa0tq+WjpJHejF6xlWciPUoF2MoLc6E
         DnkKIJ1SbiytoLJIPQagGXwzJ99UopEQj2TazqoM6nfr26+1fAUMhoo9qfcRSldPmIpL
         4ccySqGyiYuTTu5lLvU9dtkjJbKEwAIm+S6byD/2jJUdI6Agc/LKOWpHKjxvHikhUw7m
         G6mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772735702; x=1773340502;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rFhcK9Uem/LtMASOKzs4MxD6L+NtroLNk0fzDq8XxNI=;
        b=FT/ZXV01KAmotKVGjxYpBhMNWs5gEz8QlTMtEsVGhfeTioYfVqHiIU+n4IJGv1fDWa
         eUc/w+1Zf4jEUuOaZKXP38opX9o6BZiCwPffaoKoYUPWzXvqgMJezjhSwElGHcw+d6/Q
         kg1Bap/56JxooDIWOGJikaDMyD84jsONClE187B9e0v7f3+zWkqU9SjNaTtmZs6vddRI
         7MZFvwh6YTzvU813WFn5PLF8ksU6jGfOcYimhoLZ51wPOxc1E5rqHJml5J4JAjE3noaU
         LpYOS5iLL7L6TEZs55kniS7eIh+sJNxz4aZgKEeEtuDblMNePrQWjaiYmOGuKH0gLv0m
         n3JA==
X-Forwarded-Encrypted: i=1; AJvYcCXWIgUkcd9ZSH0X7vvRK/4JFS9R1wvxW0x48WXABmYHxJQI6lIbeVKEE7RYtoWCL1mZkYtNSq5Tbg==@kvack.org
X-Gm-Message-State: AOJu0YwKgZZ/nL4raaVdN4QmRyNilZAJCc0IlClQXtl8h1eYLBeyKSH/
	xz0U+idrbb9UWyp5nn9H1iRx+YV08yuDIRFFO5l+jkRXBszU0EsH1493pN78M/J5hUU=
X-Gm-Gg: ATEYQzxxMoRkh9yitRgd6VfHxjdQ6eJUx9qInDJwTdljHlgr6E6IaU69BZ5fY00GB2K
	wjipNpCPpWbbY5IGj0s1FesRzEmXhDoSRSTJBkjwfo11P1BxjZXwvbcpZcFmuYvbsT8L85ZOfVF
	/oYtSVmjRQ8AgKry1hp3S6nHzgTCUjoCtnXtn648YrQqzap48zu/Y5wmJuYyusn6I/ds4scUr1n
	faPu6YoSuuOjVYxTik76VK80rha4AB2OnyTyetBq8j/B2QhXJR3xBVBI9w1psFh5y557gjbsjs6
	njGu8y2gl7zr0inR4nMR9mGo9NMYRWbwuT8D4ENdsnySg2fFhhlxnqRpr3Kh8Xs1zSGpGAbkSdC
	vsMRuAwcaRq3aAnVjEQcXT8DlmijSI0CLuQkKeCWTPfpRGvXv9dXotEdxjrLETYA/4IsxNIAZrQ
	bZD+E3atB7
X-Received: by 2002:a05:6808:30a9:b0:450:d693:4d1b with SMTP id 5614622812f47-4651abd6437mr3134495b6e.26.1772735701838;
        Thu, 05 Mar 2026 10:35:01 -0800 (PST)
Received: from 20HS2G4.. ([2a09:bac1:76c0:540::3ce:23])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb59b66fsm13913851b6e.10.2026.03.05.10.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 10:35:01 -0800 (PST)
From: Chris J Arges <carges@cloudflare.com>
To: willy@infradead.org,
	akpm@linux-foundation.org,
	william.kucharski@oracle.com
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@cloudflare.com,
	Chris J Arges <carges@cloudflare.com>
Subject: [PATCH RFC 0/1] fix for large folio split race in page cache
Date: Thu,  5 Mar 2026 12:34:32 -0600
Message-ID: <20260305183438.1062312-1-carges@cloudflare.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EDC69100016
X-Rspamd-Server: rspam08
X-Stat-Signature: j69iohfwaq3rkaqxabuc1m4syqq7ftbr
X-HE-Tag: 1772735702-895018
X-HE-Meta: U2FsdGVkX1/hpaJs/5pSScvoNiIXqq0bN+HIURZhislldRqaFvsdANn0opKYxXPRCfNcUzPu9gQVGAaFiyygYAi3Pr/W4RYi73OMT+SHnVsWjvbAgzgofVqDjVbHk+PYsE4poBlIn4yQ+pJP4ubTXtr/+7aKftt5TlmHnnsFl+9AlTtw88ZYbERhABbd4mJEveIB5MbDRRNrdmH/Ce828n1MsLwDi9aXnBvzmpSb8Iew1yh8QpKzQBmnmrGNsI3eYqggdsQpKtZcFNB3MOXfopgEPxp1kp9C5w5euL62rb/sx6pRggn2FrqiemXyhCZyly3Z0FEqkNLz5EvP8zro+Jy5JeOrvrGlTDthlyq74mImyIzFZp3X5LXw/Z20CCIJEPHHUfpopgmnsfKRivbnitkGRaIkaq0TwrDJmPwrq1b+fLgkbNTobB+AaJofeXvRokL0SX42aPW4OWnz/4HiVcHS1E3Igbz5kQE15Xt2G/FGjoynD0nxczw9XgDivv+Gz13GVamcu/rhKGgxgXF6lNXfTwsVeIVrO/+fVtws06Xuf1gaI+mA4E4nvuM/MmuAXeHwX+AhUoXMdI8OK3VGDIzlUjznM/D0XL2M4mgAgC5n3UH9pue+lAEXsqgn/nfGKHX/9nN4K3Ezue0i4G/zl8q/L6FPrn2cYOB55qmMltx8ZrZs/NXS9AeCD2kvWrWdgrOfV7RZcf/Mmit0wUiToumxbFAvktY3fss6dBwml8avy1q6BEaQFJ0Ue6QV5GAog8gCMUd34L9CY0CLnIkqbad77nzFQKMADsDgcI/Z9VYG2G4oGjR3fvIAUNmLjhVS2dLuKVVkuhyOShtwTqKXGolf8AxHhfYfOxuTlMrc/KWGCN9iei1mnwMmmiiYMc42i7hgGopulIazuvdVU1H7TIBWVEAjg6q91uUPs8mYW7CvFZwLEZusRQg1yjXLaLr6EhY4rmYqHhIXYO1wBUq
 +dmT9mFg
 0lo3l8IKHMarJ0jV8VjAfF1x3Zbg71XNJVD5sl8CGRsSOrl9gPZ2AFQJhYsYxhxQ06ap9wis5TfyFiQd3JivzwwPQMBpKx+yciy4SxrBCx3YEeD0swBsMqLONyOwh3zUwuaLQVidUt/ngAzJRumYyyUXAWOkVKBBungfbIiZB9AR5ipRglvjnbif1A8u6VfngEvrv+lPC8eK4kq75SgwHdETuP+DOeYHosXENFwGxy5Iv8zlIN6VqVyQsvUtLT+mfksVu5ix0F+iX3EFzTMOKrnzc9cEHz/502TWSUrpcGDsezXm8sGbW9PNe0JOhqJoEO1UltzkgmwcVog33QNslV6O3MDGEzAQWjLh/o8/sOPf1suYIpowOQOnJtRR84cp+TRo7RcEkqYnzwDQ/9aHCFXgXMOh7WnKsTQVMt+ZhJdrRxqRbhEUPmndtZG283FARzxyk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In production we've seen crashes on 6.18.7+ with the following
signature below. These machines have high memory pressure, were using
xfs file-systems, and generally journalctl was the comm when we oops.

After some crash-dump analysis we determined that this was a race
condition. We tried to create a more self-contained reproducer for this
issue, but unfortunately were unable to do so. This patch will be
applied internally as a mitigation for the issue, but will take time
to validate fully (ensuring we don't see crashes over a longer time). We
are looking for feedback to see if this could be a valid fix or if there
are other approaches that we should look into.

An earlier email I posted with some analysis is here
https://lore.kernel.org/lkml/aYN3JC_Kdgw5G2Ik@861G6M3/T/#u

Thanks,
--chris

Call Trace:
```
aops:xfs_address_space_operations ino:5000126 dentry name(?):"system@d737aaecce5449038a638f9e18bbf5f5-0000000004e06fa7-00064"
flags: 0xeffff8000001ad(locked|waiters|referenced|uptodate|lru|active|node=3|zone=2|lastcpupid=0x1ffff)
raw: 00effff8000001ad ffaa3c6b85b73ec8 ffaa3c6b85b73e08 ff4e378b0e95dea8
raw: 000000000000737a 0000000000000000 00000002ffffffff ff4e379527691b00
page dumped because: VM_BUG_ON_FOLIO(!folio_contains(folio, index))
------------[ cut here ]------------
kernel BUG at mm/filemap.c:3519!
Oops: invalid opcode: 0000 [#1] SMP NOPTI
CPU: 0 UID: 0 PID: 49159 Comm: journalctl Kdump: loaded Tainted: G        W  O        6.18.7-cloudflare-2026.1.15 #1 PREEMPT(voluntary)
Tainted: [W]=WARN, [O]=OOT_MODULE
Hardware name: MiTAC TC55-B8051-G12/S8051GM, BIOS V1.08 09/16/2025
RIP: 0010:filemap_fault+0xa61/0x1410
Code: 48 8b 4c 24 10 4c 8b 44 24 08 48 85 c9 0f 84 82 fa ff ff 49 89 cd e9 bc f9 ff ff 48 c7 c6 20 44 d0 86 4c 89 c7 e8 3f 1c 04 00 <0f> 0b 48 8d 7b 18 4c 89 44 24 08 4c 89 1c 24 e8 0b 97 e3 ff 4c 8b
RSP: 0000:ff6fd043bed0fcb0 EFLAGS: 00010246
RAX: 0000000000000043 RBX: ff4e378b0e95dea8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ff4e375cef81c4c0
RBP: 000000000000737b R08: 0000000000000000 R09: ff6fd043bed0fb48
R10: ff4e37b4ecc3ffa8 R11: 0000000000000003 R12: 0000000000000000
R13: ff4e375c4fa17680 R14: ff4e378b0e95dd38 R15: ff6fd043bed0fde8
FS:  00007f6c5b8b4980(0000) GS:ff4e375d67864000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6c48b7b050 CR3: 0000005065d34006 CR4: 0000000000771ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? mod_memcg_state+0x80/0x1c0
 __do_fault+0x31/0xd0
 do_fault+0x2e6/0x710
 __handle_mm_fault+0x7b3/0xe50
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? anon_pipe_write+0x27e/0x670
 handle_mm_fault+0xaa/0x2a0
 do_user_addr_fault+0x208/0x660
 exc_page_fault+0x77/0x170
 asm_exc_page_fault+0x26/0x30
RIP: 0033:0x7f6c5b67c3dc
Code: e2 ff 66 66 2e 0f 1f 84 00 00 00 00 00 90 41 55 41 54 55 53 48 83 ec 18 48 85 ff 0f 84 bd 01 00 00 48 85 f6 0f 84 d4 01 00 00 <48> 8b 5e 08 48 89 cd 48 85 db 74 60 48 83 fb 0f 0f 86 86 00 00 00
RSP: 002b:00007ffe78c072e0 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 000000000737b048 RCX: 000000000737b048
RDX: 0000000000000003 RSI: 00007f6c48b7b048 RDI: 000055bc3b28dee0
RBP: 000055bc3b28dee0 R08: 0000000000000010 R09: 000055bc3b28df18
R10: 0000000000000001 R11: 00007f6c5b679fa0 R12: 0000000000000003
R13: 00007ffe78c07450 R14: 00007ffe78c07450 R15: 00007f6c48b7b048
 </TASK>
```

Chris J Arges (1):
  mm/filemap: handle large folio split race in page cache lookups

 mm/filemap.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--
2.43.0


