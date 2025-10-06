Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC37CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 19:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100918E0016; Mon,  6 Oct 2025 15:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8F58E0002; Mon,  6 Oct 2025 15:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 014DE8E0016; Mon,  6 Oct 2025 15:46:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E45648E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 15:46:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FD5311AAFF
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 19:46:50 +0000 (UTC)
X-FDA: 83968722180.03.F7AA02A
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 988E340005
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 19:46:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v2iW0tgg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759780009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b31nQZbUtdfeVLlEZHqw9h4YVK7okzSxH+R1dV5PTzE=;
	b=KjjLTaA01+2b0YblhbMb9ul9ZvoiCt0ixspix7oONeguqU2V9dv6PzEOGGstd2wMDikfL5
	4np8qjtPNu9tmb/EGqUoQYxQRw2uUG4DCOrc32iPNVDEc6Hl3Ruk5wOesARXjx4NPCdjiM
	3nibfnYlGeYt5bnYOMz05GIM2wHPNjo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759780009; a=rsa-sha256;
	cv=none;
	b=Qx150hgBQY8OBThC/LJYofXgqCq/dhTyzQ4OoazGvkuYZABYk5BcCh41+W0uAHRNERB1GX
	ub/TGzlaFvHrpmCznYLM5W+f/1OOAAJu9VWu764U2lHTTNqshuZj/O+Of7Co86gfNPnM7j
	AFurQfwovDmrzA7iLJwwdUNLQN3IsU0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v2iW0tgg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Mon, 6 Oct 2025 12:46:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759780006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b31nQZbUtdfeVLlEZHqw9h4YVK7okzSxH+R1dV5PTzE=;
	b=v2iW0tggbKQ2lCfDdpP3xPnahzcSNKqU7w3v0cFm6YxjzG+dpClpo46GY/MqByHzP0U2gl
	hX1wAXqeOpGX0j7hJ17kMv/IH4vUMkLPhRsSQ1LiBkYLcuimyitmDE232Nauw5YF6a4cHl
	FRhRNfGe0TADEKlju9vRRQCwtDrDDMc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Fushuai Wang <wangfushuai@baidu.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: Remove redundant __GFP_NOWARN
Message-ID: <yb2fxxr5fglwgl3i7zmwjze2a2w4bhrdwnu2dbchxh54xzthpe@lfxvhat67ws7>
References: <20251006014948.44695-1-wangfushuai@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251006014948.44695-1-wangfushuai@baidu.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: y4j86phhbd33xxjee3t6t6zemxftkeya
X-Rspam-User: 
X-Rspamd-Queue-Id: 988E340005
X-HE-Tag: 1759780008-26899
X-HE-Meta: U2FsdGVkX1+NJe8mrgA2Rs1n8I4HaOO42w4TNIgosU4vNawF8LX5p+lCP2cnaiuvVgKSuA9PmE3ADP2mtmUblbIdLt4Jwg2qU7drXX4IhLYLiNWUonRiEK2+tNl6aPojrtcsa+lCcussc4P/BdhsPnn6ZWsrTTOe0FW1ELnhC4LkRToyR5rn8JufsUIQ7a5OL1R2imMPCM3b0bXFtm/P0A3aCcKrNhJFtdgyEt64c8Ap5OejRNWId+uDT27yB1F1Vi2YMpX/uV+LZP0P7vCnE8pcEZlQqJqcuKw8P6Cj0imborenLbaJYgclO3czTazTqe5CT0WPnm0y+DMlJtPtqJ6y15ncEZumR0OQ1W53Jnm77HuxsMkvPuu3ygS53O/Hkbfu8UsX8jfsUMScbB7HmVWRk0cgSNsiWoY6Bivi1vRZNdA1DBf70ucDRpkimxIUfHgxOFVDHDXljT0P30sB8c3kB7GxGl8YWYbq+AGGmYVEj0eGmE3Ko7uDGQruvMwEo6FCaVTWeec+6O0YWceRBAHsxI3F3O2vkshpPZB/Z4C6GHHrbToedw81YR3D5XbzEFNHehJFvpGjkJ5aXku2xuYFjZG6p/eq8VCdDhgKtuHO+zLP2C9ggFtbGCUQGiqNqb5KTbvIv/wSbu4O3E+GpLZhT3ydaIvwWP8jbHPeJk38AoWBt5ed2Sv4r112YSIkRN9xKUNmpcG7DXRoF8wRv7Y2FOlQL+a8qzrHEYGyl4VgGULqj1c4zrPuVONejLNMfnfrTai+0Wz0z4YPSo0vhV6PjS2ypUSHwr+gJQGJvLvllOTKWYBHP9d4DK0rvpIkn3c75L3/5EeuivK1OtEsdDywppL3EuCnke3tl5AC3jB19Ur3CAubuG0596gWJ2fIPcIg0nMN6gMdyxwtexMT1B0uoKn6MaVCehw6U9M1lp8sh2JBlWkfkjpldvij+i6g3Rizj5leKY9LJrB1pcs
 rsdfbOCk
 T7fNcAxTUsUrsI2E1dZyCj+aBsOFlnXCt930fWP1CF5imOk0K++9rHupXPp2eH5MK8p1uvp10Je7c+HwX79qnlgEG5egBnVe9ez6Hf0FLCJcyLuX/oA3HlC2KIrvyH2hiwsQ6HmCc0318e9liLhvNDX0vSP5S32r9zQNst3yJvYJTtYLEUCYYC6oWRNoBDEwR5q8Ke5pNDlHA7xmI1jV00kvSfTfJXcvOkyZZDgxxvfR0NIUi2Z54YNYtJAxbiz7IBHU4bMnWvulCJEguzJ+glW0/OA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 09:49:48AM +0800, Fushuai Wang wrote:
> The __GFP_NOWARN flag was included in GFP_NOWAIT since commit
> 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT"). So
> remove the redundant __GFP_NOWARN flag.
> 
> Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

