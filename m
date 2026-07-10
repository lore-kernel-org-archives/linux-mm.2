Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37BD1C4450A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 22:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 459D66B00D4; Fri, 10 Jul 2026 18:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431986B00D5; Fri, 10 Jul 2026 18:12:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E9D6B00D6; Fri, 10 Jul 2026 18:12:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1312D6B00D4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:12:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6C5CA05B9
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 22:12:37 +0000 (UTC)
X-FDA: 84974267154.06.A53BABE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0C97620002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 22:12:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AeTioDYW;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783721556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h9zolevYOr3IrqkJ/ylvovmm1VXhDuPtRxmyw6CyQR4=;
	b=H3avPUUDpaHl8uH4wvJJq0UwHnF3ABBtxPjUT/PhbCFcCeXwW7Bkq4jN3QbtGSJHhjXBpD
	SjcA1iogzQxFnFP7rPHXmx0PQZwU05DmGlLzdvFzm58e6ZeZ8e5ve5UffMVP/nkGfApOvb
	dt4xsziWDNESIIuVOBJx4yWXs01r2gQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AeTioDYW;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783721556;
	b=C2dJH0oEyhwEbq7bsXbLBa0TkCfR8RcqqOZ3YkerS7XdwI49Q0WfOZospwDiUm2rnTrvzJ
	ntr+xmS6IzFurXXILJJMJAmsRIcd4HcvbIPh8kTwDWLgbiZTGbUCPywgTcTgTxgA13vjnM
	2Nx1tLzvyvjf1qMYoiT/wre01KeYjVA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A68E86136F;
	Fri, 10 Jul 2026 22:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A1C1F0155D;
	Fri, 10 Jul 2026 22:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783721555;
	bh=h9zolevYOr3IrqkJ/ylvovmm1VXhDuPtRxmyw6CyQR4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AeTioDYWrCLtodpdLKC5SAj9nqcYsbMSqw9BPHz7Xp2PX5apYbRRe+siKb7EjWd0t
	 QIIb4EtviMqnln6uNXpWNIHF/AvpVC7rQIw6R6ljeF9y12krwGSjA/IkoF5qty/C3W
	 mx6Rw+J0PVzeRUM3qJZMk8JGx3kO2l6ngA985HRY=
Date: Fri, 10 Jul 2026 15:12:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
 dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 8/8] drm/gpusvm: Use
 hmm_range_fault_unlocked_timeout() for range faults
Message-Id: <20260710151233.4ac5ca774cae46dc725de505@linux-foundation.org>
In-Reply-To: <178371883977.900500.2198446134676328631.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<178371883977.900500.2198446134676328631.stgit@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kwroggd9zzx6uyr99z5xtopmfah4q5qu
X-Rspamd-Queue-Id: 0C97620002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783721555-310763
X-HE-Meta: U2FsdGVkX19fsjJvvTl+ItWULpxL52aZM+NdVoH54xAn+kwBqiS0rGeK2XEexbv0mmEOO36glw0pYqpnRVm8bFsVQ7LB3z/yLp8b4OKztCL4SU7sH9akOKpgsiar2Di2DkCn5tcAE0pJa7j332gA4eV4WG1G7oGlVUYIh2OCOIM8qb1VaJkKAvPkzbSDVnDx0/duhsxZew9/dVTtAJI/cdMqcSLcA8VsPkCjUY21Z0JPUVmFTxnW4UNHmfZspAVI7E6vAjO9AhOxYXVefgujMPcZ5Hw6PHFxLLfSA7qZKHZMZr77N0UmKR0U0YcNRJwdR4nd5dfrbqqZ6Wu3czklsZmZlCHNteDKzLEcBJoDQc3qpd2uDJrvdImCu/Z3UvAO6D8SloYVNmK1KPa1dhu8rYWu2hIHVipOMUBCB1GdQaFh7/bM3LF+uS3Ob2glmmtog8sLVfYGpGNt2nc17S1DeUP1IU8EPczEvX6QFFavp2+q0os/qrwDRtPiWzqlLz3ct5JRLRKzmNACOkCQpXhDa1nekVlt0DRhJi+bPz+bUKjeAoI5W/0rc7Ar6Txoqb4nccEm02HQnI5h6aTPivXXfdqdHlcFjJ/0engG2Ag7ypJ9ApCNc2fIlQAU5R8iwcGcCo7Ls0FeVPXGf7qdmOgTmBfCXMXQkh6JYEdTcx5YTg6I8/7gBFtAymkW4RSH0E6B1ZSyndshT/5MkdoKF7YAth7rUHPeOEe5cLFymbRl+8rtN5cPeOsNEfI/vTCFbDOus1KM7eRheyg67Woglce5qAgemdlduZe+e7Ru3d+E5Tcsf3e3bOhYOfFgfMH9OwnDi29cgKuoKsum4TCn+ZSiP3Jd+Jftziw1As3B35x1dtO4WMYxh6FNwKG2F8QitajXi01uS/MeYqXLN3wZOssSHLdsfPvxHOxtPQ8iAKhbpyq4jagD14UtBxxPZml0rkkFbMoKDllcw61gCJ4nOpr
 eD1klZ/9
 8wyi+/K7Ju99tXFNqchmqvKW3PDwx5BmihcHD0kQqyrpmNDrjhxMdmIDuh8vISs9WbcVM2FrYlEwGqu8LvxIkfGOCTmi+GJmHix+/dKoKsr3hZ5RSu1s/vfa6zUB4S91JiLztQPuE3NTCiC889n5ojv7x15iwNT7ixDV2R3fZvYY6CtL7Yt53stiM9uyNM0FBd+39VQDk7QKQMzj7cpoEZrCKwd8ft4a+aoA54n8C/TePI0uOXQNTYND7CQKL7HogS6hHL7LBFfbzeYx2QErHknZ7gVQ9m7cdsGmaj88uvLRkfIj5br//uBMYsUJ4nhIAu+gTcy2IPukGl4gIC4mN/EhmAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 14:27:19 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> +	err = hmm_range_fault_unlocked_timeout(&hmm_range,
> +					       max(timeout - jiffies, 1L));

1UL again?

