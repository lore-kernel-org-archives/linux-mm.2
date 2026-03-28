Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E3510BA434
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 00:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD7ED6B008C; Fri, 27 Mar 2026 20:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D891E6B0095; Fri, 27 Mar 2026 20:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9ECD6B0096; Fri, 27 Mar 2026 20:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BCE3B6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:14:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3479F14118D
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:14:09 +0000 (UTC)
X-FDA: 84593549418.01.CAB24C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7D471160007
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:14:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FPEMvVsU;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774656847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GBjK3/kGDvmDDMg0t2nMXpoEi1DJAHxzBjTtjx9hrDE=;
	b=d6+g+hbwnrtT8v3vgInpqXEmkqkmabNks8cSwe8X81cGI9EiLw9fW9+F88WpcAii9HQbn+
	0qGi5NfwfX2VZrTtpNQgs/v7BJjOZ6uDkh1nZiu9SfFIJx8Vbx3CtX9zhjFKwFqDIwFEU6
	7GecuEm/r0nojC5NFeRveGUwEX7Mzak=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FPEMvVsU;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774656847; a=rsa-sha256;
	cv=none;
	b=nmaQtrB36uhijB1i7BlF7E/gH5gmAAaoCOjYd9kPFgV78yRtrAypsUQpDeu7Yk9cggk13m
	5oP2JacJiRDbUz7+lWD+miB/+g9Qjl0rKIbRDVaGfWPF/CTthkfPa6imMC5bcq3+qufROF
	oW1GOoBJQB16FX5yDN7GThyv+ASxDQ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4328542A42;
	Sat, 28 Mar 2026 00:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09412C19423;
	Sat, 28 Mar 2026 00:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774656846;
	bh=6UHJ3gswMuWjAmgkFB4STXl2KbWhwJpWgDAWBYzUqpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPEMvVsUUP8GraCvy2ryJBS5ylEbMH/M7XaVX8UGrIaKl2HeAGB/MWdMhtgAz8uDW
	 hyWFw7JkBkZWNRMR2QhKIBt8bDe4pMDqhrl6Yt+Rin2/P2YnXNVoUkP2s0tNkG7eg4
	 HktkDZoko/ckd1GZswdk5voPkaxz7Ttc6qMcwEmpYsmjeu3O+G3AInHVoaAJZ0JWAg
	 g64NKzGQHL0RjVSsbg7zUUqPYzzWQrxxY13xfgtu8WfRXJ3AiNEJ0l2YUOlfoKLPha
	 HFb1UhTQe5cuA8qRnud7AAHPkn+VLfZa2CWbSFDz/wKGSgR4jZhrvGDM3F79Vc+HAN
	 EK1RUo0c1i3dw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Fri, 27 Mar 2026 17:14:04 -0700
Message-ID: <20260328001405.4253-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327145627.10419-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7D471160007
X-Stat-Signature: ht3u4ffy46qe7zgutfutjs49qextujhz
X-Rspam-User: 
X-HE-Tag: 1774656847-701018
X-HE-Meta: U2FsdGVkX1/Ng0XthoufJIvBjoXNuNPac3yR2ZHzBrouLdqA3TtJdxHFf0iOA/1YoCI6o1ljULcagpTB0rAh6oaHUoYuW8UOxBBH9mjCBetOvLWwM7GDaKWm6YnSZ2FrUsrRfJq2ytbo6YSffKdm+Hb8u504xujGxwUW+4AaLp3r8UU+QnDyGL7bDIKGGrwvuCP8dLVus1zvqJwTXuDByCphL1DOqxvb8EasalnwK07a5fVHFjQUR9yUpJ9VGM4x6mEMdPQMYsnd8/2xP+TmkN6CVFNGgxv4joQwiMhO98F5PFo7fuV9DyHpEa4/FvtAzXsinJ02JaBev/rAr4NplDu1FYqiiRETtb19AJWhYuhP4Ve+DU0rHGDIRaCXBSMuWRiyv2UxS2rxsKb2Tu2EhsHqPUdxebFnfj75oZtiNj/IIfm0U+zgiy+A6P0LmXC30VsRAPwpxVAue1388NZ73kA7tm0aJst3kNujMT/TJ8kpqPi1A/ClZW5SJW2KEpdtGegcGiqvi1eFTG5VnRbID0dUnjUgm2hyjvzWkSbZBgR1NL2MkdtIovKUjPbhOFkxxyfppPmnWFZSowXDBh5KmVM7CWynWrCzW/zKv3vJhmnn+cxheOITeiplgWD20uxih6aE2pGKp6u70gXgTdZ5uffugIe0pD26eux7T5NDgtIOHs6oCbddfj4fIOfKeosnvBjj1yYgLEfO0eqBlxfBczk1hWvMEPvRrsLp+6YN3RhCCuBVyvhdIH8G5cNY2pQL7CabTXTFucS8ZAoCWn3gSyVW1zPXbp24LDLxlXKRVLghmjtSWxiOJcCnLXuG8UpNhnpOwWtymxKzts0UA4mLnhoBfPDUp0BEZImOP6BP8ZRd4c8ir/Of3EaNXvQ1a5MFPEdUhSO8Jjdf4qcEITUNwCRFEzBb7O62X2AEZ2rHb0/LSlZUstR9Mkk7rn1usnZ4/X3P0JFyLZFnzT5SdNX
 DmXlyVRJ
 WuUoY3utfdilDMlm0fscfFXkhtfETSCd9aHWATnSBoNm2wg8Sash3qfmmU9oI2YutsdhXxsTSEuUrqoZrkcVZtkhxJLQwYzV9ffw5mOenc3tzMKiJXdOVOugVAuyzqdgA82tz8fV+dMUErqfGn43cZxl50mM7eZ992mM5xxET4gIvfHUbF23bWo3bWtM5hhFi+zpqQKiskuFbAp20tZPXyyvQmjh3Nav1Mb5HXq5IU23QkWEKRS/ZJxfS9l5fehRCsvYipj/t7ZVmwgS0BD8C0+rbEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 22:56:27 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> Thank you for the detailed explaination and for pointing out the
> 'PAGE_SIZE' limitation. You are right; and I should have accounted for
> that.
> 
> However, I performend further testing to address your confusion
> regarding kdamond's termination. My patch didn't fix anything.
> 
> Here is my reproduction:
> 
> # Log (Both with and without this patch):
> 
> 	# cd /sys/module/damon_lru_sort/parameters/
> 	# echo Y > enabled 
> 	# echo 3 > addr_unit 
> 	# ps aux | rg "[k]damond"
> 	root    71  0.0 0.0 0   0   ?   I   22:26   0:00 [kdamond.0]
> 	# echo Y > commit_inputs 
> 	bash: echo: write error: Invalid argument
> 	# cat kdamond_pid 
> 	71
> 	# ps aux | rg "[k]damond"
> 	# ... kdamond terminated
> 
> I am very sorry for the noise caused by my misunderstanding of the
> sashiko review.
> 
> The real question I am facing now is:
> Should kdamond terminate itself when damon_commit_ctx() fails due to
> invalid user inputs?

It would be better to not terminate.  But not a big deal.  Users could be wary
of the consequence, as long as it is well documented.

From my perspective, therefore, code maintenance is more important.  If we can
make DAMON not terminated by invalid user inputs caused damon_commit_ctx() but
it introduces a significant amount of code complexity, I don't think that's a
good deal.


Thanks,
SJ

[...]

