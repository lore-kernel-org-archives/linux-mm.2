Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2DBA109C033
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60C46B008C; Wed, 25 Mar 2026 12:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA206B0096; Wed, 25 Mar 2026 12:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9976B0098; Wed, 25 Mar 2026 12:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDF4C6B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:28:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 62DF28C679
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:28:28 +0000 (UTC)
X-FDA: 84585118296.13.2C96CB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B4B014000E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:28:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N32Bb1k/";
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774456106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCxMkEB/o5gdbYZE0+iRtn9u5fm4j3732mUXLl/5g9E=;
	b=yMN9foIhbg48DGnMidTUqklYOuWdsq3CdauOviM51+y3TuHoudN1g45B7iLMRDWEGIEg8K
	Kj1xvnp4UaGEZEHO+MM/Yp8nhe4WWl0/C1f0r0lenJYdZBEPXYykTfdYEbrBer+Jwj8oiN
	JHhrOOVooi0XvsZ6iLD07FTXxPrf71Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N32Bb1k/";
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774456106; a=rsa-sha256;
	cv=none;
	b=yJrnERWtCI6FffshT/IDPc4x3Z1BSeXAs62Abh46QvLbzNoatZ254/VzmhQ3YfoEjQqjgE
	QpY9wBhc6uyvF+mEhgxoZqYH1mCyK7+pzDe6s/3M0rzSNmYnziebSLGMVjGiGwnjAFfsNS
	tAwk20vb7iQ7RispiVtWH7eFP0wwxmI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C909E43584;
	Wed, 25 Mar 2026 16:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17366C4CEF7;
	Wed, 25 Mar 2026 16:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774456105;
	bh=lCxMkEB/o5gdbYZE0+iRtn9u5fm4j3732mUXLl/5g9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N32Bb1k/zv2p6lSyAKgweBz/FAtOjmZBtVW7MG+v3QXiDq7LNKJchljdP6UAQEZ3g
	 rvtbrZRLnhhizq+qGX3zN0PD54Jjw0zDQdLquyFZT1pbrYt7QJTxspoX8jxvuB67fO
	 wLb4+hbxN2SSZXdilZv4LfP/1S8fGkYdx8lQSQtSTIMconDLEBcKxyYSbZ8RsC/Xxz
	 CTTOdgOrdR53YgHKzzb7mdROLm6cnrCngh95uOL2d79FnG16ulc8xgFAm4awUiqoTZ
	 AbaJQcE+DfMXynzehSgecv9vU4BvjFkYgrJ7e+GjVT2k7I5K6t2XyxiOspx8IBjMkW
	 tSu3aiuY1mjAw==
Date: Wed, 25 Mar 2026 16:28:18 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <21cnbao@gmail.com>, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the
 references for large folios
Message-ID: <7820cffe-60bf-4ff6-af10-89c774f0fe0c@lucifer.local>
References: <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
 <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
 <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
 <86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
 <e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local>
 <e3e374cc-ddf2-4112-b063-6cb1839ea566@kernel.org>
 <e227a7f7-0186-4d10-b7b4-c84ca8424bdd@lucifer.local>
 <20260325083016.a32095bea3f04488a7c9005a@linux-foundation.org>
 <af9d8a6a-074c-412c-ac5e-3f0dadde3e7d@lucifer.local>
 <20260325092300.9008e605ed5550ce4935638f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325092300.9008e605ed5550ce4935638f@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: kzdox1paq6pwzurm3pdidgwhbshpkfmu
X-Rspamd-Queue-Id: B4B014000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1774456106-968750
X-HE-Meta: U2FsdGVkX1+7VEK99sYyr83D89a/FwvIbp1XoqFJQcdfDEdr0lwvYH6+CT2a61ZXGon3mSOINmVgM7XmQSMWYP6iMvpzEgDh3y2LPbXtALOtsmu3Cg0FwrISISu+AriouG5dmtyoKKgw7/x3oBXiZxVoPntpSqX/wMCNmuj1e5iyCZS+ImNtzYd4zN+d98Kx11tDKbfj0VYgonUNEDJ/IR/Qa301rEDozjrtV5J+SzKvD2tjp4wo4MxmIyT7yZ5bjlhg49S+G+5yxvoP+7NFXISWZEvoZQczpHgO1GNrX4fz4H11A4q3cSSjvRfscyncpR9Vz6HbPXllQnwvHlipUjVdAkAdqqBkbJrNjc+6s5kp4LxqWQ7bBZg4MdtLcc2S9CjBR8AkPpk2msdDz+HmNhXzSeBfc+cX0E+9inntbXROo7iCJg2IzHlrkSoS+u0jDPrYmfBqRCcJ9sDiOAEP0EdL4NgZ7SyIao94rxob22VI/ei3lkUuixBo5avYYNNgddjB04Xh3GgPS0oelpHN25l1IrNJgjmLLJ3t+6BjUUQRI/MtniV5AuBYOe9pd7rVdvC4M4tBlY9+DLM1AFx66vISXXtoR4vtvPVvpT1wHO9fTcZeIyzpsPv3za991JpMEIbZdgKcJoXU9CIbrFVbGVp6uTE5OsJJMrgFAuf+PJGElJNePjwo8QwGknvrwaLVvsjFI+NSHr4adKl3tP9LvOkRynLIcozLESnkDfGBNTshXTLRLfERH8+ni2qYG9xpSztnH70bH1HwziTV86+hQ5LiumqpMjXOmdngt1IPGmqdo4u2ucku68SGpG8ULMvM9+96mwjWDeCOHD0aR/lWBtKKJ1vBRRS4eCu22zOrw8DtRvmPR5mVgwdGx3mUPtRaMV++lRux96N3Ve5DNtXB9OrRyiRVwNVuZ8/Ug9THcwMWpvjaKoPttOGgGM/ia9Pr/jEcEnr74eeiD2UHX+W
 2SZOLN4o
 eQRSUO1RgJe3+XwEcURTLkPK7nd2LiiGqlkt7tkv8a/+Keu5l7LvTHl52k67vjQI35AhyrJ2SUzflxJhck0L6IWlvcNOz0lEN7iCWngQidjGPvvBNZDrjI8PLaB4+jxF5OM20Ov+MOYOxoVjmZM7TG20OWDXJ6biJ1CfMrp9uSIn8uctQysDrRJzt4aNJpTpjjgFMajWYGr38My5rQkt4l89X78GGpmejHjgSsR9gBLiTa0WtObcRAagV0UqKEQdUJXd5PJ4Nf9snpf6VH7kr2zwI58odjW9Qgch+i6Gbz8RLF9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 09:23:00AM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 15:32:50 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > Really I guess I'd like to know the timing of when mm-stable is taken so I can
> > know the deadline for stuff like this.
>
> Yeah, as mentioned elsewhere I'll add some words into the series file to
> try to describe this.
>
> But the start of the migration is quite variable (-rc4 through -rc6) so
> I'll aim to keep people updated in the weekly "mm.git review status"
> emails.
>

Thanks. Wasn't aware that was a thing actually, but I see
https://lore.kernel.org/linux-mm/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org/
now.

