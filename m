Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ED2CEC1430
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 12:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6256B01A0; Tue,  3 Mar 2026 07:03:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E0A6B01A1; Tue,  3 Mar 2026 07:03:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576386B01A2; Tue,  3 Mar 2026 07:03:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4668E6B01A0
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:03:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CEF761A0163
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:03:44 +0000 (UTC)
X-FDA: 84504617568.04.5138E2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0985416000F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:03:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MJ5h64pR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772539423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vV8wWwcsFCFxvniDVMzrJQesED5ML4ir9gUwCi/ewBU=;
	b=xow6ZWzTjxdz+duxPAP2LPKrehW8YDeWORvBq17OAhzkFxk12jd7a5d2arbR9guZchNJfo
	nMbZHY5vZW9GpiBj3t31HE2tpADf2exv+iUP5kfrNPWejdF+3o0H8KABumrAjwMQNCteIv
	Tb8ulwj10/00Nm29gP9V1NFUPB+MTYo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MJ5h64pR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772539423; a=rsa-sha256;
	cv=none;
	b=ctjF4oraDFeBITKhaTMSytCWs1wUBwYozChU7yP/Z44+XE6JVB9R1QMjh2XVpmRxmy7KM4
	ZR9E7MZQQRo4rVlL0HFX99Tti76Q3IWA+DDd/l42ykkv2MAH4e5PQQwRuC0y4WgxH5Jv5G
	qfghAWZrOexRppUN6/NDhEGbJbqrCL0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFCD64363C;
	Tue,  3 Mar 2026 12:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39160C116C6;
	Tue,  3 Mar 2026 12:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772539421;
	bh=FKgZyK3BHK2b7TxMxYTjWoMZ/Anv+R+QUIFrSIZF0a4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MJ5h64pRkNG7MTzmGfVUhEpIvCfLRPdDgZ+HBzr29YTlo8RuYyVEPMMwkfVPI7+tG
	 DY1ce4MaKdmhWCcIeatCWo8nvAPDXexyLB/zjS+E+887Bp66ZOG4+I0bWDVY1EZCgO
	 6r01gWnEeqNknfBJGzMn50z0Z+zcnOsY83IHmFxMNZIo2mrOd9wEL2j9z9YgoYSZQ3
	 UAMDbSi+dLK/RX/lvyeXRmMo3+cobEko0BPtYh5rm1n/kGZDM2I2g9/KtJvovKaXPz
	 Lce/xR+FgMd955QsHqTOEgDRroEfGcu5W7dZaVP4qGSpdn7vjiB+JFBo/So/MdMHDe
	 Jf9wjqOSdajWw==
Message-ID: <682380ba-c8f3-4023-928c-2152e934f8db@kernel.org>
Date: Tue, 3 Mar 2026 13:03:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush
 work
Content-Language: en-US
To: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Leonardo Bras <leobras.c@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>, Boqun Feun <boqun.feng@gmail.com>,
 Frederic Weisbecker <frederic@kernel.org>
References: <20260302154945.143996316@redhat.com>
 <20260302155105.214878062@redhat.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260302155105.214878062@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0985416000F
X-Stat-Signature: 8ykkpttp4bkfgs5m3k6hebfoxj8a3mt3
X-Rspam-User: 
X-HE-Tag: 1772539422-155983
X-HE-Meta: U2FsdGVkX1/F/XSZSDvMC9qM4mSDzkVVKLYjbQV/mFgTy6h7KGedW3U2vOHBgVLHrb+hp0oRn2n4yzd/utjcVEqRF/GhkjDgwNN4N5fyEjLXxOnRCmTCRxj3SKZIAf7sf8MXONcwXUD1bo0G9v0LdN/N+Vz4GX/dxpzT77Zm48Q0sMShHlzDnviy+rxsqEnl6yrp0oNehPn0OXtHE/d+ifcBsvJ0QrXcJCLlny9pxmfhEFD1h2FIfKyHWiXHC8y/pyRzIBHPYjOCQ4PXvm4ICPK2iT8O85TtzBZXN2CnCmBpdcJtZj8OrV0dwJElmehfUZ4poH1K3Q5Rmd3DG0cDB6deuy8f5H3bciyzkwuj806VkuGLbue8lC1Aue/8su+NGwHvHSltZHj52nffcw7hBZNknBLFaDR9unW7715A6wk/e2GCI40IXpzX14GfpYPR31eN4xIUC01O6RkpRU3kj3FDoR5mKyKjI5t4h2KtyM0wbTQ1lnRd+3GDja+JYHr3jIUuKPkSSnUTAn7OkxINK05n4Se08mP4AvXjDMH9cCzSc4Hh7nrdTNIx9X6np82pgp242GO3tKIvpz7Ct5A4mcNHLs+E5cXMxx1V5+zQZXEQfOqPd1szJBKMM9hk/Bo1vuJQgjlaSsarpQOvH2DMbm9fEnEDu6uPVJOnwmwWfSb/pgEhcw7f2ld5l4DEWs/O/2ax9QRHrNI3s/FodxdLXf5+CSPE89D4xkREmyD/wbcy3zDpCJfKINfW9mm/Hf1yxiDwY1hTbYEfOj03XIjUojbXJL54ORhnnXnvygCoVuBZd6xe/3oQq3T2isKtDqSNBrDEkhyurevxX4926b7edsgKTgI9iYoAL7KjrhgnU97IU80DoFE1dL4uY0ZnFX5jk1BNADP9cH8YLzvfdgRM3XPaMBOT62diQCBrt6pe1bn9TwOV5ztGoWNffQbpt2ux5zUybnnxkyKLU2xtF/D
 1DBWTicf
 xs13Q9c8hmHTVneTOMK+Wq1JdeaEJXg16PLGG5vb/89/89i1Bk8b8/ZPl1vb63gRCl8PnocXhUG0iRS2CveHOlhh6KopTz9n1fE1xNNDMCdLSgrWTLr0X4RaETS/bDA/V0ZZukg8maQcpE6+FLM2Nm8HlQ8ZLS67CLWnPPNMzYl3+jFkO68DdPogdm8qlpZh/t/yUMqtobKJx7p9Q61iXpliZb8vSNNxaGebnQZs177BdRIZB7JYhcpOqiowUXaaxuJwGA/BAuDd15KOKOElXaYAGYI/IDDt180gFtD1wEnzTDQcvyh8c4oQTBKxn+iVd5ZaFOyvx69AvuwvpI/cvQYPYj/vgRt1r2POwiY6waZqHer5UlSyPsjgCecKhJ3plIBbE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 16:49, Marcelo Tosatti wrote:
> +#define local_qpw_lock(lock)								\
> +	do {										\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
> +			migrate_disable();						\

Have you considered using migrate_disable() on PREEMPT_RT and
preempt_disable() on !PREEMPT_RT since it's cheaper? It's what the pcp
locking in mm/page_alloc.c does, for that reason. It should reduce the
overhead with qpw=1 on !PREEMPT_RT.

> +			spin_lock(this_cpu_ptr(lock.sl));				\
> +		} else									\
> +			local_lock(lock.ll);						\
> +	} while (0)
> +

