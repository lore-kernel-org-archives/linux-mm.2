Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AEF6CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 18:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6585B8E004B; Fri, 10 Oct 2025 14:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F408E000A; Fri, 10 Oct 2025 14:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56D6D8E004B; Fri, 10 Oct 2025 14:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 482858E000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:19:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E6CCC1DFF4E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:19:48 +0000 (UTC)
X-FDA: 83983018056.20.FFA7340
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id AA43020010
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:19:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="WXn/uTHK";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760120386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JtYw9/1ZQ3uipp0Y0zIYoTLP1DMnXdji2DF/XWunzC4=;
	b=3KIVKeRaMybNkdjApEHZ3MrfsAzHgzC//oqN81n9srXEHtbf65qFLcs/DktX7cYGQxrSNW
	TAQEPRBo2ZfnZToUj2WX+jS0bf75ZEqjN4uiT59+49+wBRh6JdZOldR0ShcESSrNnc2tJT
	hKXpWcfwQZhZw3ngSwHwNhtAWr3qG10=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="WXn/uTHK";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760120386; a=rsa-sha256;
	cv=none;
	b=CIHjes9R1O0f4FD91QXkJO8tE/SrVOdMcqQl8d7kiqJqadj0ymLMnc+gBjSxDIbOn8t/th
	bNYt5XmRoebg+roUI/SfXdgRF0i9l76fTMdsvnfE6BIcx8BUecURt567YKrq//rH+i+4Vm
	3p+L/P2ji0DywUcqzVDS6LcUzRc/fd0=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-61cc281171cso4489393a12.0
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1760120385; x=1760725185; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JtYw9/1ZQ3uipp0Y0zIYoTLP1DMnXdji2DF/XWunzC4=;
        b=WXn/uTHK0n7/tRTmMwzv2bgT/W3RARUqpzCC+ki8bfsxclclug4lZFsuex2mBO8N+j
         fAYZ0DLF9Vb1Suf05dz3z/H+7ugYHdVbzD8c3rnGUMVZssf3+C+PYsDk8vqOGg4ItNFy
         AR9HFP36pFRZsL6l3doE25tAUeM2ELvE30aNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760120385; x=1760725185;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JtYw9/1ZQ3uipp0Y0zIYoTLP1DMnXdji2DF/XWunzC4=;
        b=mp57EP7Up6+sHQX+VMdifomqvMNVRj6+afzNmObqN9H8yIYF+eVHOFNjJHqIW/SH/1
         n6yCjBw8SMAzB3Y2ldoz/bcsjZoBYZ0t+2Djdc7+SPm+8xj3E+zuK7BXHiXGJ1VYkX0X
         a3hY4DINugvwptIftMdXl4f3zgLDE4yAcZ+RxKAmoE7n6JtVt34kA9mGI8TbC0U92ika
         THpBiFKKaAujp67/8NqSNUbrrcKQiHzIV3nCGuvE7OwL6m3PHnXuApQwd14uwXNPoQIe
         RDEj0JrwrKOM7Mz6DpOZdqQtd6t5biGQgzhxrF3fbcNlubnHSsOAyY1Rm0V9yVMkV6+4
         U/ew==
X-Forwarded-Encrypted: i=1; AJvYcCXTKvFa8O2FBlyLeRAABgGqOXukfy5zv7yGWiYGvHlywO9Lylf9FFiVRMyaEL1drTcZRr68rres7A==@kvack.org
X-Gm-Message-State: AOJu0YzannLoWij1jWlNXk1X8O6PJhzERtIvR8i7NCZ05qVpfz+IAx90
	8nJrmYI3QElGAnKEdEnMv7hNQ5mZdN4Hjp27SNRWYVG5C4pUEz+G/2pDjEw2VikJy0GKb1mEkQ8
	lM3UfcvQ=
X-Gm-Gg: ASbGncvbmDeWwiQ6iv6z2QUtYfGXL7EzJzVcVqRiIVCRiLYxQQMYCWoKGI/6XTHVOuu
	xVJ5PmtgDG5XdT3QABf5S9j0e8qZJvmtQ+5dKPA/t1ZtiGQhNx7U7S2wRClKicfS7VpZKsMzMEL
	WWqCWJd6hXTgCLwDZ/pqLQjqAZHAtc8E9/zRUxqEJJWZx04Hdxoe7/h1dOfH3GhqM/H2fUQA0W/
	9IbsppjF7IyjPujTmCG9wSq/C8zB6wTBp5Sh2YYnPs2IQzREK/DDcTXKNdYaKrG98BDPp9t4f2+
	C0fNRjdEtNtNgQsvAC7Y7kW5Ydhs/kSrO1WLqB9HCtec37fc0wRRTOCMJGqOBtzkUTsDeUv2NOG
	W31SsX0Jx7GXJbGbAPabouJOq1if8j03qqGHsruPkUWL/mloxkUSPcG7pb8N4/W0iXyloxN73B+
	3iDiZypxE9WOaW54M=
X-Google-Smtp-Source: AGHT+IHxBEzVrx9crKVTLaRC2XxecGRMxEjNF3N/fjgP7hn/9QZgl5siYnobz5v6ew+VGLYJc/SRMw==
X-Received: by 2002:a05:6402:210d:b0:639:e712:cd6c with SMTP id 4fb4d7f45d1cf-639e712dc48mr9614488a12.13.1760120384781;
        Fri, 10 Oct 2025 11:19:44 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63a5235dccfsm2871404a12.9.2025.10.10.11.19.43
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 11:19:43 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-62fc0b7bf62so3416679a12.2
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:19:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXsJLlK8vXcFY2e7+aJ3V19PH0yXfxBqSzfxFD3LkMjT//FexqH9O4RhbO78o1ybPMV9n3Kkxmmog==@kvack.org
X-Received: by 2002:a05:6402:254a:b0:627:f3b4:c01a with SMTP id
 4fb4d7f45d1cf-639d5c3eda9mr11420050a12.17.1760120383286; Fri, 10 Oct 2025
 11:19:43 -0700 (PDT)
MIME-Version: 1.0
References: <20251010151116.GA436967@pauld.westford.csb>
In-Reply-To: <20251010151116.GA436967@pauld.westford.csb>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Oct 2025 11:19:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg1xK+Br=FJ5QipVhzCvq7uQVPt5Prze6HDhQQ=QD_BcQ@mail.gmail.com>
X-Gm-Features: AS18NWCcawuE3ahEJ6Irfhp1eO5-4CLheHCfoCV_5jkFW9PMRtiY05LtiH4EJME
Message-ID: <CAHk-=wg1xK+Br=FJ5QipVhzCvq7uQVPt5Prze6HDhQQ=QD_BcQ@mail.gmail.com>
Subject: Re: Boot fails with 59faa4da7cd4 and 3accabda4da1
To: Phil Auld <pauld@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: AA43020010
X-Rspamd-Server: rspam03
X-Stat-Signature: rrkbxgdq44fxgbawy161igw4fdhmnfyq
X-HE-Tag: 1760120386-436737
X-HE-Meta: U2FsdGVkX19WG7biW3ri/VM0iTmOnshYGVcED6BpTnl/Bgv/svWSoY/DTQg34XgpCkFimR+gc5AxzARk0Kr9Xo3KHcmB/Lig+TAgGDc4L7pAUGzKroDCc6jLPUco/gyobBzFD1XL+nG4rEkAx9v2U3Nm2bDkLrSS2R/mK7T+V1rprZHppGU1iDb/B9zg8UFxdN7S2orapwufTFyeKoiKdV2zUHD9fpLA1Y3bnnIfrjyhTKzJKil4JEVGJ17cy3UWYa8q4HNRO/lwXadlWc6l/GGZKYLXmVS7Sp7DTxNyMeUkJmwEGAyLSjRTxa2LVgMbPEGkJEKD4PkBptxvVYHdSCormY+A4swXnnCl7jM/Uu9eGq0vG6uh6krxKyYFuBspsI9dPw4+neR80EnXYyR+hev/XUJtneJnnCP4PNdi6mREjWxxQlcAAfVaUKzDW2i5B8Bk6h9RIlZ1rZ4l/Tq44B/+RSvAhaGGbD7JsE2QwDlFAmvWad0Oe6/4Fu0mJywtdRB0rxXYcp9Ndyi/Yyn32425pjKz7bmpIg7EJrrDml6ySTEQKM3mRU8Ew2c2zRmfjGxfU7w0SPvJmB+mjzfHCzDaT1U6Gcv1KO3IzpWQWYZF8XVyEV3C4GBLpheNKWHBjQ1hRzs6brxAa0mnW7brVy77kgmL3wAk+LL2kzjl1voISgi/97poN9TBRA3Dv6Wv6CR3MbD/NPHmGKFN7kB/mRNx26nmZ3Med36VLAKdIh5VXOCNojEqtcOQG6l+vUbqlX+cIsCnfhYAb0hfxMZpU3c9PZ2JdvyjarcGghW10QWeYO62G1GYoFIltid4PbJpHamZnGOXWDvTfMoYP084oYeEkMGdcK42il+l/SKo2exdS9+bnTxbrqFT7Fak+Oh83UVwhffdC3cAtqL6nHTerZOc4LRyYJNV51x45D0fRNUNidfAdMd+6/V3/7ujwVNh3ZsiiRslbmyWfdgW8Ac
 +PP/G933
 fxnDdv4SwZQ27I3tY0+aW6dB4+u29PeuZXAtooI4OWaiatkBY1ZgEZZstw15ecHmK0b1oeSVs56VXRk7YlSC4Rl5lKTTZNPr2vxo1u8J3C29rW2PmaxAVHbzsLH5WN4xZoF/PE9TWfiDPOxzgredk0Vt8lU42N6Px1xj+gSssJNDSV1rpfetZ61DwkAvTSXRE08us2NgEn3d4UZJ7HyktdOXb7l3E8O9JFj8xrdahaCXnbHnm/TmKkDWUQEmvYFr8k+a4Dza8iSdxRYJG/25J7+SiEXYOmCr1tcvbee46Vw/Zl5bbNMsRQ0LsEY7Fc1J6gVwYq8bY+lyYZze+03CMeMviX+adh+aLjaZRyKaOnoWjSPJxdER9A/2MB+1Z+H9FfGhTaAB4qNUIpo/4cNVXLdlsGE93dd5kQ7qHF+W6DRxmyF2EtJETomWJOgk3gv6wqn0o3JCJiRnNqWVV22wK7HspzrbJj/4wceNMf/NIbR8yn5bXm7uIXBAH9n4HWBncc956cHZAUGz61PiKkkT8bExhhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Oct 2025 at 08:11, Phil Auld <pauld@redhat.com> wrote:
>
> After several days of failed boots I've gotten it down to these two
> commits.
>
> 59faa4da7cd4 maple_tree: use percpu sheaves for maple_node_cache
> 3accabda4da1 mm, vma: use percpu sheaves for vm_area_struct cache
>
> The first is such an early failure it's silent. With just 3acca I
> get :
>
> [    9.341152] BUG: kernel NULL pointer dereference, address: 0000000000000040
> [    9.348115] #PF: supervisor read access in kernel mode
> [    9.353264] #PF: error_code(0x0000) - not-present page
> [    9.358413] PGD 0 P4D 0
> [    9.360959] Oops: Oops: 0000 [#1] SMP NOPTI
> [    9.365154] CPU: 21 UID: 0 PID: 818 Comm: kworker/u398:0 Not tainted 6.17.0-rc3.slab+ #5 PREEMPT(voluntary)
> [    9.374982] Hardware name: Dell Inc. PowerEdge R7425/02MJ3T, BIOS 1.26.0 07/30/2025
> [    9.382641] RIP: 0010:__pcs_replace_empty_main+0x44/0x1d0
> [    9.388048] Code: ec 08 48 8b 46 10 48 8b 76 08 48 85 c0 74 0b 8b 48 18 85 c9 0f 85 e5 00 00 00 65 48 63 05 e4 ee 50 02 49 8b 84 c6 e0 00 00 00 <4c> 8b 68 40 4c 89 ef e8 b0 81 ff ff 48 89 c5 48 85 c0 74 1d 48 89

That decodes to

   0:           mov    0x10(%rsi),%rax
   4:           mov    0x8(%rsi),%rsi
   8:           test   %rax,%rax
   b:           je     0x18
   d:           mov    0x18(%rax),%ecx
  10:           test   %ecx,%ecx
  12:           jne    0xfd
  18:           movslq %gs:0x250eee4(%rip),%rax
  20:           mov    0xe0(%r14,%rax,8),%rax
  28:*          mov    0x40(%rax),%r13          <-- trapping instruction
  2c:           mov    %r13,%rdi
  2f:           call   0xffffffffffff81e4
  34:           mov    %rax,%rbp
  37:           test   %rax,%rax
  3a:           je     0x59

which is the code around that barn_replace_empty_sheaf() call.

In particular, the trapping instruction is from get_barn(), it's the "->barn" in

        return get_node(s, numa_mem_id())->barn;

so it looks like 'get_node()' is returning NULL here:

        return s->node[node];

That 0x250eee4(%rip) is from "get_node()" becoming

  18:           movslq  %gs:numa_node(%rip), %rax  # node
  20:           mov    0xe0(%r14,%rax,8),%rax # ->node[node]

instruction, and then that ->barn dereference is the trapping
instruction that tries to read node->barn:

  28:*          mov    0x40(%rax),%r13   # node->barn

but I did *not* look into why s->node[node] would be NULL.

Over to you Vlastimil,

            Linus

