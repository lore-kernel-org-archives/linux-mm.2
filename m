Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F99ACD4F25
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 06:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592B76B0088; Sat, 16 May 2026 02:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51C5C6B008A; Sat, 16 May 2026 02:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BF3D6B008C; Sat, 16 May 2026 02:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 270346B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 02:29:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDD5C1606F2
	for <linux-mm@kvack.org>; Sat, 16 May 2026 06:29:20 +0000 (UTC)
X-FDA: 84772306080.16.79EDCA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3F7C3180002
	for <linux-mm@kvack.org>; Sat, 16 May 2026 06:29:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qwi8CWz1;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778912959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMWN5x9HDweBHTWqub8cOMnSL0hVe7z+jiQtlb1v9fs=;
	b=RRT6poieMiX8eaG2mB6jvm7aSMZcAydsxABbyG/21CfjoTiVOplO8ZchOuA7AEHNz6u/HA
	egUpIGoyybB5wFgrKDmtRowSKDZDrA4/UZrS5rD9BcvDdNWz8QUIym85NtPkYJhynuH5zV
	pGUmp+I74yHx0TQgq7fHx2YwzjsjVIQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qwi8CWz1;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778912959; a=rsa-sha256;
	cv=none;
	b=liQoryrD+utU4hZX7wKuOeYBPITqDa4JM3dFOj8XSFZfL6Loeahb4UtAcM9WUnPYyDCrKx
	7Q/hd0/SKwH3YcWDH6VA/LaKeC62+/k/gZH9o8qRMAEJIVhPemzAIl87Eq+RKAbHtSGeJM
	7Hdpa+07pLo0hD7q+hFiAekS93u/JMo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9883560138;
	Sat, 16 May 2026 06:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A321AC19425;
	Sat, 16 May 2026 06:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778912958;
	bh=ZR5pqbdOhcWFPqqwmv82cPJPye/uvugLSCbv0N6QbM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qwi8CWz1w5ulb9PLUPbHTEbs7y/Vl34wzfo8Pk5rUkyASU1oH1tNbT4rLipp1CFD+
	 TiRaqXn6F7l932ffIUus35HrPUrYo46R4gXuactMgmhQFXLmmdFpfCp8QGB1Fa4S4/
	 /Rhb5r7+d5erAUBioXwR1gmQ8n4UX8fLxqLWxWI8bZcBglSQsMqpPesGE8NuJ4K/I8
	 sHZ69prfFbUPzBHJ2huJxsbU3Qvhl+U+kA1Lbq+Y89xOmI0YgZ0fQpywauBhpOZ52M
	 KTBmFV7gwhlJsR43/4aadxCi6KUWs6ypjY9J7+Jc94r/Y9zO6JvA4N782iX0r3SQrX
	 lf0KanB+MQDHA==
Date: Sat, 16 May 2026 09:29:10 +0300
From: Mike Rapoport <rppt@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: pratyush@kernel.org, akpm@linux-foundation.org, graf@amazon.com,
	guodongtai@kylinos.cn, jasonmiu@google.com,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, liukexin@kylinos.cn, pasha.tatashin@soleen.com,
	ran.xiaokai@zte.com.cn
Subject: Re: [PATCH 1/1] kho: fix KHO_TREE_MAX_DEPTH for non-4KB page sizes
Message-ID: <aggOtl4HUcph3VSF@kernel.org>
References: <2vxzcxz2dybi.fsf@kernel.org>
 <20260513150718.182224-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513150718.182224-1-dongtai.guo@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F7C3180002
X-Rspamd-Server: rspam06
X-Stat-Signature: y44ikgfzd6dompxuun8k3jtpnh1pmy3x
X-HE-Tag: 1778912959-54481
X-HE-Meta: U2FsdGVkX1+b6mZ62FlAIwwnqd0fA8grdKzTVFtgSK2BawrosLaCxWqg3OpqHoyhpUTO1RHQ8vdTt1NKos6wcdCpI2NhpItr+TIDmthYS+odXLN2MVph+MjlE3LG/F+y/kwFg3NpMpC9kFXuGpqn6wNgs0ssFkd6g4fOVR45LQjzSxlaPoA7dsSn4060feKjJiZG+dOYOedhJZIs6Dk3097rfFmjq5HFEjkm36xmF74OLnppkHg+dg2w7MusDummVHAAT7ybXVqCk9KqnFusM0rsy5wsHHkWOvSW0t+5F/amttQi4Aw8snP1h5zvYSXHz/fuGQeMJeZQcXKFR4cDp4QR52+WT1XU4FazqXNVC61ANtyD+pAsXsUItYGt70/rkSux1UW2wJfrWhDsKa0Rbv3M/GvmlB46IvBvh91i/uffH+cbg4bO391wjmBxlOMP6U99JDNejc5g8fQwK8zCAaRjNDYSLeZcqj3cfLlnlvjbwXJPz+0ZtuV2OpxCLQHZXkmY27d5xdFfAFK9Vc6CS6OHU7JGDHKK6dQLaO52etLeaCX9fs0Hkk7ylJQtYSx3D//2l4kH1CP4ljwgtsR7Yrkcw7KN5LlGvAHkkrSElL3y1eETmF6CMbc9BnGHkWrHlig9sjTXoecAnHM7TxGbn5msgg3ADu3KDGNB+Y/Z0ndNhiVfUCRysQIjPTqr1zQzbrrvyof1frWoDWpy093R1J6jm+y75WP13V13/sACjFhBl/yKGzBDLkcrDo8orYE2/F+UuwMrnwXsA79V2O1DVHlg6KeDflahEQZBkT1qr4Fvcd/QTWTylzmwT4WWoTRHaszBbV67i7+u3KQfMNp5+pYCsbtvi/zlQIbGSbtHsZxTzNgVlS3/tlqdCuiGhTqe7SxCCFlRb4gHJ8aeyuOWtWFjuz+NaG9farNvxVXbpnegS5/ptCwDvwdU/+0HFVo0XNEdV9QqWe+7dUCEqTE
 DclEWIhO
 EgW0H74R2H4+wJleTYrC7EGRJ4MLuz+GF0hCGsbIhfZF06YGh5dXLq/A8o6s5pjSuNeIPt/NZSB2RwUv2qcPakZtOwpqCaMGQ9YG+vxOVO11IzBxhceryRmVhZI18RkTui/gwjqDLwqnSFHQ/dI31KcstQUfv+DpTPyfs5NPHGCa+VN6EBtVgDCt3SuSGccpvYqIAhn8Exwco03cq8fTW6m8rIh+XbNJpRwu1Vz6tGJ64UyfvnXsNbgOH7uTWMT3aUbZyhu4ANoUcRHiMv9oDcgvM6tY0ohnMXID1UB778GQQTTTGM1ze8Ek1plR6qX5F+HuW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 11:07:18PM +0800, George Guo wrote:
> Sorry for the late reply.
> 
> On Mon, May 11 2026, Pratyush Yadav wrote:
> 
> > As of now, we only support KHO on x86 and arm64. Are you working on
> > supporting it for LoongArch? What is your use case?
> 
> Yes, we are adding KHO support for LoongArch (16KB page size). The
> LoongArch patches are being prepared separately. This fix is a
> prerequisite.

I massaged the changelog and reapplied this to the liveupdate tree:

https://git.kernel.org/liveupdate/c/d13dfb48dfa3

-- 
Sincerely yours,
Mike.

