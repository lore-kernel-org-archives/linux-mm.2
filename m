Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72BB7CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 08:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B41F80022; Mon, 27 Oct 2025 04:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88ACD8000A; Mon, 27 Oct 2025 04:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A15480022; Mon, 27 Oct 2025 04:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 654E98000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 04:42:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78BEF5969D
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:42:32 +0000 (UTC)
X-FDA: 84043252944.30.2D8611A
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 84BCC14000D
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:42:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cISfo2OW;
	spf=pass (imf26.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761554550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iFlBtrits7DNlZ6h+mgbiMIVvWdiVqZSUXzsme0rVO8=;
	b=dre70oyXsBIhX2YSv0nIw740/nhBr48WPXE+Ow5ZdYyjzoo7cEtIKx2iOJjk8p5MNMb0QO
	S+zBP9Gl5EXQzJnIw6PRIP9mWTd3JDHVnM89Wobf1wizXewe6zmldHfTfufumP/cd62sAM
	wlGQSRR/ztXgTHR8eSCZT5mjykmfTug=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cISfo2OW;
	spf=pass (imf26.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761554550; a=rsa-sha256;
	cv=none;
	b=ZOVYs8ik3MJ6oYsn8AJpZzBHvtWQKbyJVyxqm5+KZHngQehBmXl2pth3v0CjgnNREo+hrZ
	tXIU4AACWoPGWOr/teF1ZJk/UiuVm236RF5JElxO9AecpIY6wAIGybn/76NEpvpw/UkJKb
	zAxmwNwAzia9d8yxcC8OEUVxeTUtGJU=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b3e9d633b78so994105666b.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 01:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761554549; x=1762159349; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iFlBtrits7DNlZ6h+mgbiMIVvWdiVqZSUXzsme0rVO8=;
        b=cISfo2OWGMQ/aDEIYm6tb3FcUa9CUujciEkWdEY1dJULq5BDgccDH7ZULLjQVdQRyu
         3SbuwuMf35b6UV4tEc5jscZOkG1gVNBmgP0WsffmC/f8c3EaE80mqsqQFt3zqgW3Aw0X
         nXwsTcW7gK0qE3zudDJNsTM6doU9ChXbRu8qvT/C6/ezhatWhzKwGU3P0Klt62Wh0tEB
         Y1ZJXPNaaqOzkkPx/OaXkN9+IbAQYbZK/7UFqZf+KJocpc5a82ZhiW/7aRmyDLxJrlPj
         YH3jwUsY+tgEW2qPqlVgnmhOyTxLnOOAnA1ONP4SopccJ4DueVn81iiCLpZEiLHB1fOt
         osDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761554549; x=1762159349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iFlBtrits7DNlZ6h+mgbiMIVvWdiVqZSUXzsme0rVO8=;
        b=dY4mypNXUkfbOn0JFKr6TDJ/X8V9i3ZtFgBtOZKOIkTNm18HmPflaDeDBiAF2bUNBv
         SO5RLJEKD/nKfScFyhLwTEOVSMSLwEn5HN5vIWRvIoRIxP5aXGho0k2Ko8bTm/xbucFU
         myv2u19kBydfGPuz1CThW+4i/lreikfS9oitvO1o/ilduJMLlYygtHw4R8phllr0SvsE
         3aME7y15Ezak1DBYNPm3Qkbbu5nR7oh+FhFk/MXf3EJ5ewuu/YoffNySrCzB1U+jqxEU
         wrwceEY2YjGUCOFNKy+otSSiaxWtSso3UUtT6gsaUcbQ+1wOHv69jn8PDC4SbP10iExA
         oe6A==
X-Forwarded-Encrypted: i=1; AJvYcCW4Z901l8JS2jmQOoZMh3UXROpj+nNqcAcqbpEUQFEuAEF19YT0D0zvs4Tfo9M2wzv5EGl0o0I5mQ==@kvack.org
X-Gm-Message-State: AOJu0YxaLQnCJoLb2Os7f3GOcxQtK0W7eFra2CqaXSaSz7clgKP9uTO3
	Z3/r5d7UcC2JWavdGULmGbNpT7ABqlxrQ4UG0MIxhxQawwPtAi7rvUPE
X-Gm-Gg: ASbGncuG1KhWeXD8xJF6Bu1pwAjfWSkQr8xSgC7Df1/iFYZmSEUCenT7miEedWMsOe2
	MxGr3rsFLv6ZBb9BxIDNHjFAQSk4LBioi0hgd7F5P4SJelMm8B8GsGafTNhjW55sr6eAe2mXtKY
	OFRzU2n+XN0SpGNjnkYMmSn27syNrweJB4QjMavJ8IPzo2ni7CQdBzjH1KXqJ0B4qNfhDEWdSaT
	fAf9+W7aLT2tbvOpLOEY3uIrj7TFZ7TJ3Grxe9qEMQ3H/0nkr+sYPzlXwqKzT1qe54AMj8fyjhl
	QlCXJrv9zIXiy3IuT82VxStI8jiMnzRjIdNLNWs9jOwv/cHO5vjP7B/3jTVH80mQLpDQmL/E+nw
	1ZrkLSMQp4F6awn2tnRUbEa/6XKGKPqyLDh/CilZGD7WaLiQLomwqMIt/crQbIFetiuow1Q9M9s
	FB
X-Google-Smtp-Source: AGHT+IHNDWdV6nOLEUPb8BsKdy1fTa79zHhvllKqWIEzW+JrO9Bj5NMu8vYte0D/T+VD4YYNH0vo+A==
X-Received: by 2002:a17:907:1c85:b0:b64:6cc7:6ac7 with SMTP id a640c23a62f3a-b6d6bb9083emr1215693866b.22.1761554548711;
        Mon, 27 Oct 2025 01:42:28 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b6d853696aesm704277666b.30.2025.10.27.01.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 01:42:28 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	milan@mazyland.cz,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH] pm-hibernate: flush block device cache when hibernating
Date: Mon, 27 Oct 2025 11:42:20 +0300
Message-ID: <20251027084220.2064289-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <03e58462-5045-e12f-9af6-be2aaf19f32c@redhat.com>
References: <03e58462-5045-e12f-9af6-be2aaf19f32c@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 84BCC14000D
X-Stat-Signature: 3b7duuugpfua37qwtndei66u5ztcrrut
X-Rspam-User: 
X-HE-Tag: 1761554550-765198
X-HE-Meta: U2FsdGVkX18lhAmnSGvyvPYhofS+vZSmHNJH97uXMeinKC64TXn28hVRu34GAlZmZSN2hgttykUapkE4sRrzP4CtxD+nGcKNXGl1HmccaezVxC6qpgl53ijxQzI6eX9qMCKDV+j2ynvxcopZvQjAWnYK8rRvHH36+mxHU09zlF5Fmw2Knur1k+3kcG2757+3xhNT6nxetAQsCHG8Qw6OlakWaS+nhhh2dDYazTlEFt0/XG2DxF4SBbLZgXcZkqQG0xK9YQeFXKwO4XCrzHUJDvmpdwoeVDKho+7LcPaJAYsU9+C166vaLiTo7Ojvcnsd2h7YBMrBXea9YO0ELZgRPTwgJ1ETpem6I7cyvDRmq+50BMcVSm2Ne76nwYZCzAJWiSy/bGTsV+pRb9SZg2EHEzL+KBAxRVCQ0xZs09c5yZ9OrYqRcPqsUCP3eXDF+0SD9rGcKzILzchmtkIq9Q+IHUKIUpkuOWdCYQhIoQ3o7i+CfSW0MBWtbGCNjXbUUzAJlgdU839Udl7C0prpDGE6BvvdWjxLQJ7TBnmMWAPWdAYYlZrmtg0VIUmpbDaM+zJ4i9AJjjIL39plHOeoj2AcCBfRugbKRGsBcjuuda2oXoMBjb70qd2SjkgMtbAy2UFzfdwRg/0qzlJL7vIWRbspvAecsQSHMu6QqvwIlnAO5CNFMfQJekgfbo4DPAIxEb6KYvusCmCv4HqOuNHp8f5Zt9ueCvIs7MPAY+q1Lbqo3EAUCXQ797gZLnURrAcYManEQozhMOetdc4njuL1YciVaPEyM9HNHsHs4T8xR9ULgXnhVP1X0hEU4//YnZakqCSxq9MAc/KyCcU8xHK1K+O5fL2TAM62l7l9ic4h046TsrFBRtqozbqHdHwBa7ZJzYwaJrnWCrNsrp6Nj6RBL7Ye5/lPDWhiPQofRtkqQ0QkNoIdfl9hKYhOAWOVxdyA2qqxh2oXc0q/2O3QdqkdKll
 u8JlvLdY
 b5Ps+MgC5KNoXyZK7Zz3hInC0n0S76llMjpLPWJyqrNe9XYxuz0RdySOdYPV0XGiB88q2TMKGfgposHXpfi0s/kSzp9mOm/B8WXPCpLllwu4dcSvhTD8uuOBO44Ao4iUCvLNo6naEsvXx0JBjaFsjeKZIycYAt8yznL0AfMRx7MXpjzDUZG0z+CEA9V96yV96pmNvSi1bvGF0sQAB+kByvvvOY0hfxtNyyXxkUKhr+oo2YpkXdKvXRrHvypBezEzE71iKlgWap/bPy5DHw9dfq9kFdTSkpDFD6PCITcnQJyTP6OO5L+wBYiiLG/ktmz22j09fk+t6ErR2uUVVIFZ86yUXHUpwkezLKlSQmCd+NRq+2jKJrzgqWP1+4trPxsp+BKFLV7g2/a/xjN+h4bQmUVDhyRMUeXo58zeg7vSo5iLeVoHnPy1+MXqM7EQrQvnP40fH0jlhGnB/CZ1ClcvR3gWQ9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mikulas Patocka <mpatocka@redhat.com>:
> Hi
> 
> Does this patch fix it?
> 
> Mikulas
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> There was reported failure that hibernation doesn't work with 
> dm-integrity. The reason for the failure is that the hibernation code 
> doesn't issue the FLUSH bio - the data still sits in the dm-integrity 
> cache and they are lost when poweroff happens.

I tested this patch in Qemu on current master (43e9ad0c55a3). Also I
applied Mario's patch
https://lore.kernel.org/linux-pm/20251026033115.436448-1-superm1@kernel.org/ .
It is needed, otherwise you get WARNING when you try to hibernate.

The patch doesn't work.

Here is script I used for reproduction:
https://zerobin.net/?66669be7d2404586#xWufhCq7zCoOk3LJcJCj7W4k3vYT3U4vhGutTN3p8m0= .
It is the same script as in previous letter. I just added some
"integritysetup status /dev/mapper/..." calls.

Here are results:
https://zerobin.net/?2331637d633d20c5#EmyhxiHLDmoZT1jBVbe/q9iJKhDEw4n+Bwr5mAcaOpM= .

File names mean the same as in previous letter, i. e.:

> "log-def-1" is output of first Qemu invocation (i. e. first boot) with
> default integritysetup options. "log-def-2" is second Qemu invocation
> (i. e. when we try to resume).
> 
> log-bit-{1,2} is same thing, but with "--integrity-bitmap-mode" added to
> "integritysetup format" and "integritysetup open".
> 
> log-no-{1,2} is same, but with "--integrity-no-journal".
> 
> log-nodm-{1,2} is same, but without dm-integrity at all, i. e. we create
> swap directly on partition.

Results are somewhat better than without the patch. Without the patch
we don't even try to resume in default mode. "blkid" simply reports
"swap" instead of "swsuspend". With patch "blkid" reports "swsuspend", and
so we try to resume. But then in the middle of resuming we get this:

[    1.008223] PM: Image loading progress:  70%
[    1.017478] PM: Image loading progress:  80%
[    1.027069] PM: Image loading progress:  90%
[    1.029653] PM: hibernation: Read 36196 kbytes in 0.49 seconds (73.86 MB/s)
[    1.030146] PM: Error -1 resuming
[    1.030322] PM: hibernation: Failed to load image, recovering.

(See link above for full logs.)

Very similar thing happens in "--integrity-no-journal" mode in the middle of
resuming:

[    0.531245] device-mapper: integrity: dm-0: Checksum failed at sector 0x6e70
[    0.531600] PM: Error -84 resuming
[    0.531799] PM: hibernation: Failed to load image, recovering.

The patch doesn't change anything in "--integrity-bitmap-mode" mode:
we still are able to resume, but then get integrity errors when we do
"cat /dev/mapper/swap > /dev/null".

-- 
Askar Safin

