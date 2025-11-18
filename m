Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D0BBCEE33B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 17:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0997E6B00A3; Tue, 18 Nov 2025 12:08:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049F06B00A4; Tue, 18 Nov 2025 12:08:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7B1E6B00A5; Tue, 18 Nov 2025 12:08:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2EB56B00A3
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:08:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6DC7C4B9A3
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:08:03 +0000 (UTC)
X-FDA: 84124360446.03.FA6B643
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 822A280009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:08:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E2uByqgT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763485681; a=rsa-sha256;
	cv=none;
	b=wbQ0Gd/5XWqWPctZ3s09B82DC8YExO1mSwDICFnUH4pBEET5sbWj/wJZsfBCBhM5+MbnlU
	uiNqQUTkrUjnORvPsNxmaTZaaVb4q0rzkngH0BsXGRb6n0obg09hCWBjaON7NzCQHZ5HeQ
	mu0JI5efnL/hf5g3ySEur/jiGQLNI2I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E2uByqgT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763485681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irwlmmJ0MMkznpqLMQ8QH3n1XaAIkdzPe81PjobofI4=;
	b=Zb/ojBpUyRelD9TE6X1BPkxms4pZdR00pY3Sh1q4cdC+nCc384h86Njs+yr/6/AFKw7erk
	prwBt0KS1eONpZxL9sX0SVIbGHbjVaaZsgX48cgEq5eiJMBaqD4REWXmmv8ONkmlyZl68O
	AqICPRuJDaATOrVPkvxn+986PjSVpuY=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b9a98b751eso4319442b3a.1
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763485680; x=1764090480; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=irwlmmJ0MMkznpqLMQ8QH3n1XaAIkdzPe81PjobofI4=;
        b=E2uByqgTLwwPg7n68qmofhhmvm+wrkzfGvtk8KdtikW0rjJ2eN+NfOLDpbqtPvp+oR
         jnv3CtEXpdu5+6A3UWhUVyCx5+l4r1byErhNIjufb79gK/l0YwzGErXOEI3s14/s8h2u
         HtQoIp4Ugjk+m9MTelSdHsuGcDDtwZ7fAN7wewd0wHewDsH3M6KSbc42Q0oLTXa2Llx3
         ot4F+gFluU5mzVWFwqwQoZwbma+wZl5f9LDccddPmiw81TkHHcBujjquju7ZO6ow7FmS
         XC54PceAApMkcGlEpU9cSXiNMPd++82vRD/MPEQY+xgrXXJVvcJNaC1Zfs/WbCUc3tvb
         YM0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763485680; x=1764090480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=irwlmmJ0MMkznpqLMQ8QH3n1XaAIkdzPe81PjobofI4=;
        b=b+i/ydWQlLXvf1DGP065TCiJkXBZCA3A7akA+j4EpIt0XV99tv1+mgM0UQiAVDjCf7
         gWgcIVGZ/1ckdQQ4T/jtKCGXT7j2WWhyV5X+Xp/bWy5veBG6Hs3KR3cVeF51q9Wr8NCi
         n3L02c++wbOIDVXGNIFNZ4uoKCi6njxR5sj24msHhxJX7xDB3+Du2igigoRNq2gmyGUo
         ePnbSb8/rQ6lMwHwgiA05itdngTXkfI0OjSNZHJNai2a3qFRS550w7SPYDjUjsmiTOVf
         do3MNncbUGBh24jgUrN9mAUFGslpC4MX1gSH2gG/wd4swQuICjN8XpuXX7zVjiih5eDT
         Nmwg==
X-Forwarded-Encrypted: i=1; AJvYcCXacZ4Kp3Ykf1MSRINAwBx47bvlI6PW8gQ6Y8H2H2jYKtZfxwsLp7JoPkfVKZgd1D3PNCaTs4hbQA==@kvack.org
X-Gm-Message-State: AOJu0YzHIRGh6UPdxikFKBGszy/GQPIAjn9xfxQDt5YgmlZAHCY6FtUi
	IJkH0K7jr8lrjzoSoRJhE57CxIOLTs0rd+LSTxeRRxZGio4oRwqEO2Nd
X-Gm-Gg: ASbGnctb0nsH5oYrzE9OQZnlvpoY+JZmp4PSDRD7JynLkkOvQoEXYogTKGN2me92uxc
	mkxFsFLNufWFEQjvGYw6IpcXzcY51GP4nTYC+gXd8IANp6Ws0pZ2iDpo8dFRKhSdP7nHKPFP+kg
	efXG0pxVaRBk0DwnxmSyErq1Kw5x5qwc7IxkwAgst48zKoOZ27lrkoUsPrk6+vsj31BsYes7cR7
	WVt8kAcqBw454EdgO7f/0vxmPitBUQwI7hlSc566i+0XlwSZe7NWA2zNRv8jQ2kEHbUWG6f1L17
	wwymlC+GKwXYjyca2PT/7G0dULKzxEew3Ws8ziXZbiuLZZiJPApTP6KmYZztiFBGBpozNyCuvvZ
	/DZ4d57kill28WFTT3ZRroFhIhDrfDhmOLhqjgI6Iow+rm4AQmFEyFhrmX7AB4q8Mx5t9NHISIB
	0hawbuXnJv4X354Kuli54BX/SRaPpLLisuQM1hYwoU5wIf5wmjWBJqhWgB14XDdiZ+
X-Google-Smtp-Source: AGHT+IFp7aKWRAnpg/nz3uAMMrTccHCEVazeBR6Eybowi+fOK2iM3BI0IvxR7anyhC7bwx7kDFbgOQ==
X-Received: by 2002:a05:7022:43aa:b0:119:e55a:9be4 with SMTP id a92af1059eb24-11b40b30ecamr9630301c88.0.1763485679910;
        Tue, 18 Nov 2025 09:07:59 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11b0608860fsm52235294c88.5.2025.11.18.09.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 09:07:59 -0800 (PST)
Date: Tue, 18 Nov 2025 09:07:56 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Biju Das <biju.das.jz@bp.renesas.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"urezki@gmail.com" <urezki@gmail.com>
Subject: Re: [PATCH v3 0/4] make vmalloc gfp flags usage more apparent
Message-ID: <aRyn7Ibaqa5rlHHx@fedora>
References: <TY3PR01MB11346E8536B69E11A9A9DAB0886D6A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TY3PR01MB11346E8536B69E11A9A9DAB0886D6A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
X-Rspamd-Queue-Id: 822A280009
X-Rspamd-Server: rspam07
X-Stat-Signature: ht4fn71wb3aaeeb3camgazwaax6jcgdr
X-Rspam-User: 
X-HE-Tag: 1763485681-849967
X-HE-Meta: U2FsdGVkX1+QRPRjdZpNtN+Az5ZYmkTnszqPBXoHwk9QG8rxdUC2yUhYuGHv3Xn3Tne3iY07nuf0CcAP6vFbE5MBtZaLJAPL6nux5bpRdHwNR2qM0RABmgA6a+9dK+l/SNkNN2wfYS0uo8VXT+x2CwkYanDcTuhrblUQyiSlI9XW7ECaha+OAN5WALpDhMwp58FLTZiduAvL2uDa5JgByCrYETRuiEvukOPtcaQWljAmk+ESIUQSWKgvaPB2FXCHzso89h1PGArfsx3ChRkwbV1rrvI3PHebSFmpt8hcyie4gAqeFC9mjCw4VvswC8UVbXYsBz2qs7nM3WsiE4ryNg+263SysTizJiNlxTw67+G8/dXD7PZOvXD03dQDVRt83Wf/V4IMiwyJooCuyNkHClhtRDtFP4JvEd+faJufzt0bDaKyggVOB7ZzZs4MRs3qMtSZe/xl0gxaPMe9urrj1LNbbdtznliV0+Z4k7NUahDTm5p6+WBoZVKIkN+msCaOBy+tUyo5sRet8OA9Y4VBMlLDs/nepW/X0IDa9E9SXI4Q4md7y/fjsxpb3HoJBUURChShJK4PJFzf6G5102gsKeUyYvrM1jtIKhxbVv4t0OHWyfSdXjUKTrLXzAwvu1GuoqlxdxSz5Mn8uKXlEDcz2mmVKSc6D3zvbtB03XkMQpWRfuUX0O0zxiqN3h2bK3PcxKmwE6ivl1dA6GdH8bYEE4KZUzVbYX5VRk5FzzXwukouNu0mEJ7LaMoBR7YASaw+bCpPNxiAGAK29PWG4ZDRhZRmF8h9G2+jIf/a1E+io64pliGgnDPqLZZhUyxObJo/98vK0CnFdq8QfENJlCMYojUhzBKIFpiQ9gpxgfs1HfRzLut35fGgDZWZY7PZcDUsmwggUGiVUumgEbFlco2F4W/CL+AvqPlqpcPI/z/5o/UDXRbL4NV5Gof0CH/1UQIFhvTxGtQ9kn4p9dhEJtQ
 U0nzoWbQ
 wCTDBx7RkV8z5WcLregC/OvaWUo4NNqUTuQ49mwM7dpPrVCYR+oRcvRCurpi4tQJTZLxu+D7q3K2M1aTByaRPZTLbLw8gpGeZQiZUGZVqYevsepxXgHvvnbGTXSQqyg9DppanfU0Mt62tw9V9KxncKQBEFlQaBEYSv1uLTLCKP6Whm0f42+wnNFNWrXZbhFafzwX/56wkP+dsgSFeDwYNupws8G3LWp6H5sS/zhvzMIXqbrnAwFyrg93q/uqu8wa+WgPlMH0wAPRk6VDvsOa4Y87JD4SgKppU5BTxkvRXwsNbow+6Pgrs87xYqeZ8GJIbbAsrkKHIcTEXqta8HYFTQ5/jruXTCETdqeR1RZZqaZctKBKBWu7HUPZ5R1UR/pCz4PW0DGvPiOCPNHEOV+LqE+sOV7HO/oKSlxviinJafkWgWYMwUbKfW+F9hPCcZAk25c4NfV5eDfNyYZTJoJqY0qHPSpjN49nJ/vmVQQL16IGXPK6RUNJSd2YV5lcTdo7KYK6n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 04:14:01PM +0000, Biju Das wrote:
> Hi All,
> 
> I get below warning with today's next. Can you please suggest how to fix this warning?

Thanks Biju. This has been fixed and will be in whenever Andrews tree
gets merged again.

> 
> [   13.122280] systemd[1]: File System Check on Root Device was skipped because of an unmet condition check (ConditionPathIsReadWrite=!/).
> [   13.142562] ------------[ cut here ]------------
> [   13.147308] Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0x100dc0 (GFP_USER|__GFP_ZERO). Fix your code!
> [   13.158526] WARNING: mm/vmalloc.c:3937 at vmalloc_fix_flags+0x9c/0xac, CPU#1: systemd/1
> [   13.166576] Modules linked in: backlight ipv6
> [   13.170983] CPU: 1 UID: 0 PID: 1 Comm: systemd Not tainted 6.18.0-rc6-next-20251118-gcc318393a5df #175 PREEMPT
> [   13.181082] Hardware name: Renesas SMARC EVK based on r9a07g054l2 (DT)
> [   13.187641] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   13.194675] pc : vmalloc_fix_flags+0x9c/0xac
> [   13.194705] lr : vmalloc_fix_flags+0x9c/0xac
> [   13.194715] sp : ffff8000828fbab0
> [   13.194719] x29: ffff8000828fbad0 x28: 0000000000000000 x27: 0000000000000000
> [   13.194734] x26: 0000000000000000 x25: 0000000000000000 x24: 000000000000000f
> [   13.194746] x23: 0000ffffcc595b58 x22: 0000000000001000 x21: 0000000000100cc0
> [   13.194757] x20: ffff8000801d7af0 x19: 0000000000001000 x18: 0000000000000006
> [   13.194768] x17: 0000000000000000 x16: 0000000000000000 x15: 006c326703000000
> [   13.194779] x14: 00000000000001da x13: 00000000000001da x12: 0000000000000000
> [   13.194790] x11: 00000000000000c0 x10: 0000000000000ac0 x9 : ffff8000828fb920
> [   13.194802] x8 : ffff00000aca8b20 x7 : 00000000021cb08a x6 : 0000000000000186
> [   13.194813] x5 : 000000009d17f2f7 x4 : ffff800037e00000 x3 : 0000000000000010
> [   13.194824] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff00000aca8000
> [   13.194836] Call trace:
> [   13.194842]  vmalloc_fix_flags+0x9c/0xac (P)
> [   13.194855]  __vmalloc_noprof+0x60/0x74
> [   13.194865]  bpf_prog_alloc_no_stats+0x44/0x218
> [   13.194879]  bpf_prog_alloc+0x28/0xec
> [   13.194888]  bpf_prog_load+0x168/0xcdc
> [   13.194899]  __sys_bpf+0x814/0x211c
> [   13.194907]  __arm64_sys_bpf+0x24/0x40
> [   13.194916]  invoke_syscall+0x48/0x104
> [   13.194927]  el0_svc_common.constprop.0+0x40/0xe0
> [   13.194935]  do_el0_svc+0x1c/0x28
> [   13.194943]  el0_svc+0x34/0x108
> [   13.194955]  el0t_64_sync_handler+0xa0/0xf0
> [   13.194964]  el0t_64_sync+0x198/0x19c
> [   13.194975] ---[ end trace 0000000000000000 ]---
> [   13.328233] fuse: init (API version 7.45)
> [   13.339395] systemd[1]: Starting Journal Service...
> 
> 
> Cheers,
> Biju

