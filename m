Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 949D6CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 13:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014A68E000C; Tue, 16 Sep 2025 09:21:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2E488E0001; Tue, 16 Sep 2025 09:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6BC68E000C; Tue, 16 Sep 2025 09:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D54478E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:21:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8B581B659E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:21:43 +0000 (UTC)
X-FDA: 83895175686.26.0EA0AA9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0664A40006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:21:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ot8VUQUm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758028902; a=rsa-sha256;
	cv=none;
	b=u6VFsdtCadPdBmUrcGrRRl3SZtqChpp+u4r9ZETIhS3w1U6niimosKiP3xXiusnl1AhzYC
	MnUqCIOu6GfWhUxUYtc/nmwSjyd8UD/vB3bJ/zHR5kBtI8alYe18g0Dx9+F25Psis7fBo7
	fu92TsoZ7Q290sYP+n/or3jfzG1rwVc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ot8VUQUm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758028902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDn0rh7zU8d+rzGbtxh1PQkeYWg/ygdRtn2ehDK3iw4=;
	b=jrLepsr4D8mBGLnKyC7OGI72imocDrbe9GQtktx0VSSVMEmUSPSJs8lcMUo3nSNCk/yL7P
	of6bPfQ9pmnh59Oh2R23Gea3mRmLsGIoZ2/BySIaW6swMnatvjnGwFBIuxWvyejbreveYm
	FKSuBvHdGHVFwv5HpKYQ2tTtcp0mJos=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CE67601A3;
	Tue, 16 Sep 2025 13:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1C8C4CEEB;
	Tue, 16 Sep 2025 13:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758028901;
	bh=rAvqEfhmGxEnvdZNyv3LFHPZmEftR6dOMSWOd/EB0bg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Ot8VUQUm11Wn2fQsIQd89sBxvXfdHgw1OvkeKD97GN6OOkDmDuOVVGqb6eYdxZcsp
	 XnstJ8uG7ADE2sOM49qgDDarHlUWPbC/wVZieuRlDc1Ob2fxjNmPAtRM41vz6lvuOa
	 hG8a7QgYiScra6ptd4v+NK3BHnst6WXvIBMNNOwbwPWaj+9xFPFjRfPWLdNX/iHsjl
	 seKtbnOBm5FiAXJBR1WBcDvVU7ipceTXOVzyNXnd3AQTNn26gJhMZZhj68mvre2oCY
	 4844jDl91bxcTMG3pzI8j9cBomn3J7lvMB0nNfaN4MzOBf/uLmrdMnxe1IM/8up3Dc
	 YUJGpNEM8vxWw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>,  Pratyush Yadav <me@yadavpratyush.com>,
  Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Alexander Graf <graf@amazon.com>,  Baoquan
 He <bhe@redhat.com>,  Changyuan Lyu <changyuanl@google.com>,  Chris Li
 <chrisl@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kho: add support for preserving vmalloc allocations
In-Reply-To: <20250916130516.GB1086830@nvidia.com>
References: <20250908103528.2179934-1-rppt@kernel.org>
	<20250908103528.2179934-2-rppt@kernel.org> <mafs0ldmon784.fsf@kernel.org>
	<mafs0ldmnlmq0.fsf@yadavpratyush.com> <aMgey9qEC_XUejXm@kernel.org>
	<20250915144335.GL1024672@nvidia.com> <aMhAiR6qnXMA-c8r@kernel.org>
	<20250916130516.GB1086830@nvidia.com>
Date: Tue, 16 Sep 2025 15:21:37 +0200
Message-ID: <mafs0v7lih6se.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0664A40006
X-Stat-Signature: 6pwt3g1ein5osb8r14u9qdptn9bd6gog
X-Rspam-User: 
X-HE-Tag: 1758028901-577915
X-HE-Meta: U2FsdGVkX19rmjR7wwToAT3BbtQtqDjpy57iXlgejqUfA3YQCOZaF/iORZakW4kpb2Li1CGaU9HLZ34dKhBbkwYg6V8yxWLifQ04xM2BK8gqUhue8axhJ6gwkzQlNUkNc8ohNPPctz7Ddpj4Olq1RXekT+us2Bt58+5kGEx5B5kgbpZu71xvsCGlLs9R3T7VkomVjTwUREgNZzfuL3gCiAtQUK9oitOwaHNDvP/p938M3HiBDtZromFhHP4mZXvKQzRWpApmMfDIIdjsB3bZZibCyzLWuVd0psHjGYyLg2GQZ/rOFLmEFE0iaBXf9YiTblxw/IyUYhQ1IM9LTkAjy/Xq5NQK7Jq7Lld0OnookKlKEmr5+VrDPDGCtEGIhP8nzU77sn2U9ae7EgWO8PmZS0m514okaS9UH/ZEoAXTKuThTLuA3pwpY5jr8LgXeZGQs+FBfA/J3HKQfGqdEEj7tgLQI8zNHwpvC7AvhAeYw0CH5I7HtuSWlhW8LyCjUypR1WFXuvzQZ6/6fMxTnJZbG156oE0AuG419rMCKuCB2MNBODqNQggUiP7Sk2V20MwfJWgTavon8yCXIeN+kNU5p4uxfR70Jk8iik0CgipCJOo1/5FCHs0XZ1i3dGIZ084Eoc7Utlc30lOT8SF9ayJ+6TtKaSceD7dnV/v0HlG18mspfHddBdiTHJV1UphckyigG/q36Oo0GNIGb2WgZi2P+oI2ERcug7KDyS04f0jst7ccWHjGjS+zbOX75iH1doQP0NQJWYkmG+8/7cy1qVhDyhGssT1T4dt2qrVvlOVnl7a3khS0ilkB7e51gSHuYixKWUtopGnV/Aa1VtvUO8UZTWeHMgNWLfI7/EoE2JBaSwz3HfhMenO9/8P+kyTB5bLdz13GDiPDa970o8S9A0LujecNl7BY0OvSF4fhmkOOaVaRRn5pSWbETJBn3UGEcQbMQIqNH/ry4WPye/lZA2a
 nQX8biAY
 p2BgjMRqwzZkhq4zSQKNS5EoqvDO8HEc3JEUdmdVK22VXA3s82IFKw+Wg9ocY4Mxj4bezPDXldGufqFu7T5ftUg1sdWxKrG/Xr+eymV2fKYjbNoWyHoRNmx9p4J9+2Rl2auyOuL4f8pJAQyTqVhL1B1RLP6/uvPgohSl359eDJITf8naoNaKD79pBQ4CBR9JSlTPc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16 2025, Jason Gunthorpe wrote:

> On Mon, Sep 15, 2025 at 07:36:25PM +0300, Mike Rapoport wrote:
>> > Under the covers it all uses the generic folio based code we already
>> > have, but we should have appropriate wrappers around that code that
>> > make clear these patterns.
>> 
>> Right, but that does not mean that vmalloc preserve/restore should use the
>> public KHO APIs and avoid using internal methods.
>
> I think it does, the same way vmalloc is layered on top of the buddy
> allocator. Why wouldn't you build things in clean understandable
> layers like this?

+1

-- 
Regards,
Pratyush Yadav

