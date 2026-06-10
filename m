Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EED6CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 22:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B5D06B0005; Wed, 10 Jun 2026 18:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240076B0088; Wed, 10 Jun 2026 18:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109096B008C; Wed, 10 Jun 2026 18:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEFDF6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:00:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 995B2120192
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:00:13 +0000 (UTC)
X-FDA: 84865371906.19.12ED278
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8D395160013
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:00:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uk+akrjU;
	spf=pass (imf08.hostedemail.com: domain of elver@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781128811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4aXC5fY4yg+OQHnUSe8aIXKwQ9lP7hn20bvK5ZGXMYk=;
	b=FF109pIbkrcea8ecMUbYmiWloEvQcj6NjYi8C5gcP/VwMavX6lDySV7Dp/+CuvidK86iGS
	ugiuqE3DxgeL68IREz3e0TUf7Ly7pgs3MTCyL9YWlDyD/VFYGSVYeDqbLtbPv1Xz9Ka9vm
	JjcorguWezUe4fw1TBP/a1UJ3wB7+Yg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uk+akrjU;
	spf=pass (imf08.hostedemail.com: domain of elver@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781128811;
	b=x54r0CBrfcByUaLVUjjxByAKMzo9w9CePx5/GtCjfq+BpXimYFVGGfnoA1gsKppiOc8uff
	HBCtkBQ4GVhrnahJJzCaknfDEpOcnT6oRSfk8YjO2o6v7h4pFP4tyaKf8g2S5kDI4oyd3u
	Yfp5iSn2xSl0slIWRI9JcUkbK91CM60=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-13817614cd3so3123695c88.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:00:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781128810; cv=none;
        d=google.com; s=arc-20240605;
        b=I4YvWW3b7iHTvpM6negkd1+kTkgT1d9dDYQjglzMBUOVVr3/kXIV3mGtvYqqZlL9Gt
         2oWlvEcecba5PfPoMmVGg7sXJxma7g8IpFWg1E8AAfzEu2mfv/XOubwx/KFl2wNEukor
         xfoXTUQbM3XGvbz9rSsuScv3QsQ8LHaY/VaqjQpMJPRr3WuP/MWUbkyzH5ejcQtAKCCC
         mfr09mZFHcg9WL2x+RFDX4aKpYneFN+cnF5Rkytd+FYLI92K72kI+U2Z+JwSJ1uorauB
         wsiofIh/hf+jcj739T9znHJ/yJeU6xynUH1dDOiCz4sx4aGdlNqYRPm9KvK0uXm/x0tb
         WKKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4aXC5fY4yg+OQHnUSe8aIXKwQ9lP7hn20bvK5ZGXMYk=;
        fh=iwVoqGO31tZ/ImhWW0nEzZi22sXYrhGjkRiPbXBWplk=;
        b=NioRqMnQgSf4hR49UzQBEuu1cmarsr6RlEFIPorpQONvLyT5+Rla6Uj5JzaFSIxRJU
         3cthxlcAaAkNLiCXdqA6ZylAazy6IMCog7+uk2n3Xllt0h1BlDXazJJimDEAmDZVcqBl
         H/ZvSyQ0gAVcPQs9BDZDLvv5mG3jtB4n29TPPSH/F9Sm/Z71r28hQ13VElL+kaekcWSx
         l6qdHU5tmVr59eT2EVdayQ53WJ4+3kY5T+9W2cZFWF4bvAhWvrSg6lSU+I2GW6eYYNpo
         gU98wKm+ksNUcIYLdLsZPlVKBB8TF2uIWVu4Lp73NV3lDoTpKlNLB/00ZeJDxHBX5MQ3
         6eyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781128810; x=1781733610; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4aXC5fY4yg+OQHnUSe8aIXKwQ9lP7hn20bvK5ZGXMYk=;
        b=uk+akrjUtwiLm2ReLD/SEm7FhBwTxjmUQ8ZavlvTfnZg6Tg2xJMjBT8XDoZU4t9P7R
         +LGVokHTdbCzV5fcdXDYYnCTMPl1bwuD1dlQuRhO5zoSKgFl5vU01kZGgt67qVvC4GUQ
         jVWQfUnIJi90Y2JQI4O/eWroyuZF9rqaloK7tTykOSpvHrE8zlY1BkMRscecPO3iFqku
         HnYwRpBEpWZ8pNKH2njgmMGUchChJFpLVz5AUotRn1yEMdezyE6w7sCR9/S/VBUskQh4
         U4v7sY2lWzXaBOeEMAOL2C0RurLWD040C+ok2LDAd2dysJ4d/KY7wwvVMxLzewxpYx7w
         voXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781128810; x=1781733610;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4aXC5fY4yg+OQHnUSe8aIXKwQ9lP7hn20bvK5ZGXMYk=;
        b=Ml/Iew3UQjbh2dp3RdGI3cYvEHohCA0cQq6pIrtypXjS112/ghZtqs0GuaogUEVawP
         TJqX8sIj4xQCe/QYbMRFxJ65A/TEGbNurbKoyy+2I+xH1S65kYh28ZnG9S81evWRv8tp
         oPPTVTM/995dBTqropCkjn6zhO4ZIvy475C25pXvvoEgXCl70O012qNaJRyLpfBIzPHJ
         EI9RWrH6ilpBej6lkU+HmFaXyE5VJ26PA9dyefh3eACtjFUv5/vtQDEFGmSnrKyMwpaU
         ZxkVoL6Nr7tn0nk6ugx0zuNwdaALIUPyEldbZ/rYOLRWP70EMU2MDcaIHRh8jIFjgs7T
         2DPg==
X-Forwarded-Encrypted: i=1; AFNElJ+3nNpJCMUEE7GZ35jHDxG5HlDyFEVbq7fdUAvY05Pg8EF81nNdBSTphPDmRXQ18GvWv3awMSeEvg==@kvack.org
X-Gm-Message-State: AOJu0YwhDUtdXYZZfut9emmUZoIf0zWCAfedX1mKTS8PJT0CqfKIOgfT
	70AGB7OSDkhipv9+ZUaUEfnNZL69J+tsRnBe3wRr6g7kyDUmrZ0u5O/M+ucHJFwLy0ltIIvapT7
	AkbyO6qzySB+9D0WCLvP1QF0ldRT8rK1ri59neXfO
X-Gm-Gg: Acq92OHeUHxBajM3OMD89X6B4p4wCp6XA6FbTg2DIF4eXiPeByEUxHkh+1f3YvFuhCm
	klp7auPo9VL4kruuR1ufxzq7+Uqok0XkdrviUdDwh+SWQQbDifVHuA4WZBh3SmZ/3SoyoodjSzM
	nIaRggvyYN0vWiW40A14RSewW+aAGGSu2CFVUCYPxt4ArBW1oij8U3dES50pwxU4bmXrhgXgjAw
	tS3C81Aqrp46M/Fx/skFQIMcXEwl9bPT7GB6hr7aOI2SCjlqLeZj7FauEQ5Uyc5wNoWIex87XMa
	lIiCF76OdNZbGDmf9NxvxsNZatMrsrEYhQrXWu8fc1RKics=
X-Received: by 2002:a05:7022:603:b0:11b:f056:a19b with SMTP id
 a92af1059eb24-138066e1d35mr17149337c88.18.1781128804838; Wed, 10 Jun 2026
 15:00:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260423093420.038ce8c6ffb45279d0a809a0@linux-foundation.org> <20260610212111.561726-1-jkrshnmenon@gmail.com>
In-Reply-To: <20260610212111.561726-1-jkrshnmenon@gmail.com>
From: Marco Elver <elver@google.com>
Date: Wed, 10 Jun 2026 23:59:28 +0200
X-Gm-Features: AVVi8CcDTxjL3_blywDrNvb1KV19KMan71BbwA0t5VUY2rzsqCjQQaaiGCpfUOY
Message-ID: <CANpmjNMRpc33npsBbAqmgn9vfm+HtkAhDOEcM5Aro9Ej8y78+w@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KCSAN: data-race in mas_wr_slot_store / mtree_range_walk
To: Jay Vadayath <jkrshnmenon@gmail.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	pfalcato@suse.de, syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8D395160013
X-Stat-Signature: mc59h954micqnkhoexwgrboxgjpezgka
X-Rspam-User: 
X-HE-Tag: 1781128811-34324
X-HE-Meta: U2FsdGVkX18lg1pzcto2Je9MB8JUiRirb/fmZ5gjuIZ+JiZxBjieRqQjqP6AoBXc8ca8ap1Rpa67IhZb+eTprC+1lALacANAWgsK2oo7UzNf9LC6qMN57rjREvOo2cN40Xf95xNyUOeEIACIP6ncVBsj++jz/LbRanbdrzF7RXy7bNlgVTN16SUB1lvzgR0/qdeoxrkbWcjbpkiHuZuEPFghSYdZ8OSTwdB36+c+oIgQarwGmQFPCIH5pCtf1zoLXg2df3ipqL+N0gIFU1UqHrj8S4PF3OpgjnFfC7R6tu1VRUsq7YpX29kVRymajOgGwG3LRr1pRCK13JrLKvaC8ZNIJe6zxzZapXQar4TRx2aM/2Swo9RZGpCNIMknfjqAW+WqyURv9QEWhQBMfRWoUcZoXPY4F240BB/l08SvBj5MeMco9r5L1/tlzqSVnS/lYy9WxWvNhhq/LK2QGRSV5mELaMjHljoe9EjS6nmF0Kfu9TzQuz8tJN4Sd6XkkZ8NUs+NgTYpBSkuWXsAtj3qZKTvORz2B8V3MYV28q7M4XONHMBXMri2t8j5vV0/FofP+2hG/7yvhoF3wy/2Yj1Kg7D7YgTs/fx0tKQmrN/AMp0OPLvSa4Ppm4zVgWe/GTVhDKlh33scPCo0Ylj7eTZVj7piA5AhaAMjly/orkM3ojgfIykhGQlRHXb+LqLxp1mWOTuj4a+XptxNU4NuphmTB2us5EEbGzKZMml6JvUIEDBQPUiKECvQ4lFkIeLDWqPk9WLmeKjv6GLqBnOp2PALHczskvMZnj2B/EjhilGChHP82tKVNnZ0H5xzObECt1b3fgS29yc8PzK9OVx6sofTiTKeXYxL4F4GLzYiVA5Z0QDyoNLez46793U+kSPzJgaKxYwVGoT9ghF0Jss1UyjrFjvHM9lDuUFiOrUD6INgg+LzHf2mYEdX90YoU5oSnZUGaWgzoJiBiizAhFkggJ9
 Shdr5DZu
 lPO0BwAy3pinXDutjcaWiH80owkveksFuwHVM5L1X4CZi7XEA7QPLJEZtT/SNIIDGrte3gd7uGsMZqpvBrHAYgGbsAKR7Rucyl63mvIxXLZ5NpwcTAjJzuqlgLBpOIJKqpUaTC2wA9Msz3ZpEfGLPmOVqnA1OCHxI8KETrKn3kG6nbopabLTjdsZuuMlcZ9ESOCbmLDGFmkpTiSFv4Vi9CVl1vW6B2R8I7zbsv4mS/lzV5zP5QwskY0KowQUJiIAEvK8xqx04syrZ3QPf5OEwZ8KSjOGDXw/0/fjuar6orq50zTwiG0euF8xQT3jZurJxNOBM1ygsOUu0eU8lPLWo5etqOluCNCZXNtF9F6SXbhB9Ndr0F5FS/xSt+NWwlaRCLqIDYtp2H0xKFHQck0kzAUHcubQL4O5O5TZbZSJuoJDp0zqIIoN+uB5xz4DH2lPOqMpH2cbGSnb1+Ym22XWM7z7SJ+G6frlOnW/laCV+ozD1OVMISqQXb7kP/h8aXs151hGX8dWmI+bnmCD91FwWBXXErAKVaeTrw0Z8hhNDBUYTqvogc2UunWT2xv7lzhBakUPleh6ow4IIEhlDqcJk5XGX5mcbHWjyzhnZRPIRnHm6cJLBZ2EgSNLJcQV+oDT70/mQhxTQvGsaYkI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Jun 2026 at 23:21, Jay Vadayath <jkrshnmenon@gmail.com> wrote:
>
> Hello,
>
> I am a security researcher and was able to independently reproduce this
> data race on an x86-64 host using a KCSAN-enabled build of the affected
> kernel version (3cd8b194bf3428dfa53120fee47e827a7c495815).
> The crash can be reliably triggered using the provided PoC.

It's not a crash, it's a data-race report. Data races are more subtle,
while technically UB, they are tolerated in some cases in the kernel;
please see: https://lwn.net/Articles/816850/

> However, I am not aware of a method that can take advantage of this bug
> to achieve a practical exploit.

An analysis of its severity would be appreciated (e.g. corrupts data, etc.).

We've been trying to do this with syzbot. This report was also caught
by syzbot, and we have some AI-based workflows that attempt to analyze
benign'ness/harmfulness (take it with a bucket of salt):

> An unprivileged user can easily trigger this data race by performing concurrent
> `mmap()` operations and memory accesses (page faults). However, the race only
> results in a spurious fallback to the slow path of the page fault handler. It
> cannot lead to memory corruption, privilege escalation, or denial of service.

Sounds plausible. Source:
https://syzbot.org/bug?id=3ce3ffd8320398fb3336831c3cb1e7b3ba60d64a

Either way, marking the accesses appropriately is typically encouraged
so that optimizing compilers don't become too clever and break the
code in future:
https://docs.kernel.org/dev-tools/lkmm/docs/access-marking.html

