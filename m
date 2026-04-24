Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D07EFB44A4
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 04:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C9406B0005; Fri, 24 Apr 2026 00:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779AA6B008A; Fri, 24 Apr 2026 00:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68F796B008C; Fri, 24 Apr 2026 00:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 547E56B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:47:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0D94160B7B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:47:41 +0000 (UTC)
X-FDA: 84692216322.13.52D085D
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id BB8BF40005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:47:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cCeQohvZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777006060; a=rsa-sha256;
	cv=none;
	b=3UU1BRSO2IrpIWj5GD4c7dOYxCKl6aoQyPKuI/R1nkarjucx/o2o4pTgcEAFNoEq/YLaUe
	ayuOeFv/A09Zy0RAn6GhPyHuPcl3QG6eGr3DbJtncok8sgYW5xidMfUyoPtaFCA/6d3V3z
	3L/vO1eu0fPjfxYfC6jhU7DGA7HE0Nw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cCeQohvZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777006060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vh1Lqx2A3VmceNvId69+yEt8g9r8y7I/d6ws2ri6rLU=;
	b=Np/NZkNHn60p35ZhKOgGZjQQHL8M1ELCz1TC3+k0TtAjKDbjuI/AyfcukEhNlqzLwTA6l1
	DXO8U60BDII63g5KvToqGzt+jysVtDT1muQafmPa3nv+k9jLZ/Hmov2f1O6ZXcTA2s5ws4
	HyGzWK0b+Jpi6rT8unKCY9o62kXtdY4=
Date: Fri, 24 Apr 2026 12:47:28 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777006057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vh1Lqx2A3VmceNvId69+yEt8g9r8y7I/d6ws2ri6rLU=;
	b=cCeQohvZeVDF/JEcQf6yh1S/Tx1l1CVvHbnE7+b9EEz7p6czRPKsdhJBkbIzLYy/uZW9ph
	/5q7SdMnMY+aMvRMgjLNR37IoRRutTsGLLvZpzHZ5/0vMXzb/+Tf1MjCYRP2nOt6/wuFHj
	/oYRyvlcRCFEFqlYTfVVAn5RfXipXLI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, usama.arif@linux.dev,
	baohua@kernel.org, kasong@tencent.com, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <aer14NAJwkJ_ZCP5@MiWiFi-R3L-srv>
References: <20260417033951.1111038-1-baoquan.he@linux.dev>
 <20260417033951.1111038-3-baoquan.he@linux.dev>
 <CACePvbWZO-=Nwho9Hfk-2HpuggZyb+Yt306MdA4X_icAt6+Z9w@mail.gmail.com>
 <aego1T9d6PVudYqj@MiWiFi-R3L-srv>
 <CACePvbVHgry4oeXeouML1YNscpuMNSXSnBY9wd-McDUar4tG1Q@mail.gmail.com>
 <aemF6D3Do9FQYUOF@MiWiFi-R3L-srv>
 <CACePvbUih1E7cypNwPE13Xf8tMzYG5sjLoPO0+Yt7V0uL4qt+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbUih1E7cypNwPE13Xf8tMzYG5sjLoPO0+Yt7V0uL4qt+A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BB8BF40005
X-Rspamd-Server: rspam12
X-Stat-Signature: jx1n35bfehh4itmyojny5fhukbsimkj8
X-Rspam-User: 
X-HE-Tag: 1777006059-357457
X-HE-Meta: U2FsdGVkX19ptJsVLMMYMgGnNRI6w6Z4plpQNx/8hoIFuCyDjiChQYn2/EHnAYGp+OpABi8OFqWYv2qUipGF8+1g/e+Do30ZO/9PvEKqn6gUYL79ZVt9dnJnlgbA+yhvqh9juqcrkMQafJJg9wUVMXdlayp/SyWpHuD2i+6bSNC3l+EGGjfq6+K6CpOdne1qB1Gr4ZQjaW3XerCyBgxgo5fpSV2+r6ttlnZOk9kFvLg13KIn3AhucuyMMsGiUdHSMs/A8oniGiWkIugxcmcY7uC2Q6UCGrzbdNfAJD/RICdEg5Uq9mCFCTg0uJq5vAPAOYU9F9f8ZjL+qRUKOvhxxMYoIwsB5IuwfW6zk36Jr1bqa6Lv9q4tm2SyuEgDokrdHGa8t2Ps2H80EOfTyuL7FIEBH77DTxZ7mmJQNujci3VG7vZeU/1NPwyoo2YlgLs7WrpcK3v1Ec2bow1GQAjnTfOuQFOyc5y7Tq27wKRQR6BDhAh6WVu4bbprki7EsUc69iEXlcthznGkr8AwgbN+r4S6EXxbIakf/0aF/Q18eH0y+4iuXTp/l4yTQ/x+brNoeOTRRbVOecPSHTx3MdKQV6zkRqiO6irWCFJY4qsWM4AwfjZXcWat+Nj2f1GOsuDnMflTtTjP4PhpaFIDoJTQ4gJn1fberlVepStBydbwfc8RLsmckBwegvNyvgWfBSG8rxfPZkG8ZXGDPGd0BrTrJDmnYebJlRMC7OJHw4jS8L//vsMAybZD4Run69mBsbwRapsTQK0gnBfhPSD8WIJsgDUTzkvbJjUSLbTSTBL3o+axs6Xpdn0ymklpfME4rio9w2vBsd8IQxV8xWypHERWYPOuqpAPaV/zV2jD8RrNJpAGTwfSrzt1X9HdhcYfhw9FPmFwFPQMLNwlOWnHC4WhOeDQrfvabqP8+vTAYlSDkG1dVyx1B5zGY8G9js72U6Bd4GcG+/ss9z/LL0WHdF6
 iLNhr3EE
 HWq5yAb38BFfpr7/wiOlqWC2MEgoxmtd4JykTk9sdi8Xjqb4XMdInYYPiJHk5k3ldRUPYdIjXZ+GD9aR2ujZszi3Nrsg+ODdt1f4o/7oP0aOtaLvSzlhWDu0e1kVS3qtAm+Wl6LkHgUcSO4Z0L7o9fQ4takGIZINDJK3audcODwFZCCw8yvwP3g1n7/REy355p0+H7VPH7hxAVsPX9ZkKZf0zi6WOLbyzMxRB/J0aenzI8zRKtyDJkbcJL1JqszfLmPzJtU4mxG2/5GrJZgR7mGLSRUxtmKbfn9uNyz6jPRnzNYJPpeUTDvMMOYWTfyQdZVKZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/23/26 at 02:48pm, Chris Li wrote:
> The incremental change code logic looks fine.
> 
> On Wed, Apr 22, 2026 at 7:37 PM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index af81fa212f1e..7644049a0919 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -3518,10 +3518,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
> >                 goto bad_swap_unlock_inode;
> >         }
> >
> > -       if (init_swap_ops(si)) {
> > -               error = -EINVAL;
> > +       if (error = init_swap_ops(si))
> 
> Some more nitpicks:
> 
> I think some compiler option might warn about assigning a variable
> inside an if condition. I suggest moving the assignment outside of the
> if condition expression. As it is, it looks very close to "error ==
> init_swap_ops(si))", Some compiler might warn, "Is that what you mean
> instead?"

I personally prefer the one doing assignment inside if condition
expression because it is a ittle neater with one less line. While
it doesn't matter much.

Here comes the new version of the incremental update. Thanks.

diff --git a/mm/swap_io.c b/mm/swap_io.c
index 77aa8373c087..e2710d5fb44e 100644
--- a/mm/swap_io.c
+++ b/mm/swap_io.c
@@ -625,7 +625,7 @@ int init_swap_ops(struct swap_info_struct *sis)
 		sis->ops = &bdev_async_swap_ops;
 
 	if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_folio)
-		return -1;
+		return -EINVAL;
 
 	return 0;
 }
diff --git a/mm/swapfile.c b/mm/swapfile.c
index af81fa212f1e..82d2c9b35b11 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3518,10 +3518,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 
-	if (init_swap_ops(si)) {
-		error = -EINVAL;
+	error = init_swap_ops(si);
+	if (error)
 		goto bad_swap_unlock_inode;
-	}
 
 	si->max = maxpages;
 	si->pages = maxpages - 1;

