Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E16C9CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 02:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DB698E000E; Thu,  6 Nov 2025 21:08:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B3648E0002; Thu,  6 Nov 2025 21:08:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EFE08E000E; Thu,  6 Nov 2025 21:08:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D51E8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:08:17 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED4D058615
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:08:16 +0000 (UTC)
X-FDA: 84082176192.03.B521024
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4CA494000C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:08:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NCm/SkLf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762481295; a=rsa-sha256;
	cv=none;
	b=NftgB+0iVDQ1UtIkkCslJDf3uUrsRGDDK2KBadBH7aV8VnthaQN5K9Aw76qX9bIbgP0Ca9
	+v0R66goBEXkh+C2ENDQSZd+7em9KZW91hG65TqlJigsHfgAT3qK8AVocNkVKaG2KRuLvX
	TsI7lVFAwKNx3n0UnM7W567wGo/cLik=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NCm/SkLf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762481295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zAmsOjDrEdY1VcyfMzdxRSNuQZ2DYMUpTfTd1dza55M=;
	b=BBYGXjMZ0ydugdj2qm0gGhZBEJj10ergi3k5GIKFJMzsat1Oe3LXHvlc3xV3Z7xazolo+7
	JrsV9nf8hXuhZ/xNjBurMYmkbh5a0g8tAjHiKUi3y7MXBa3icXvP/2cXw5DTIUMKEbeGOK
	fR03NYatFgIsHVuODOYU8Ara4LZ1RP8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 34906406FE;
	Fri,  7 Nov 2025 02:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FB7C4CEFB;
	Fri,  7 Nov 2025 02:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762481294;
	bh=krN2HbEAPJ9LZ7iRNlMAlG+UbT7YoouhmyVRCR+YH4U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NCm/SkLf0sDAsmYdC0ji01eys0nbyjJVvHg3S7lgfslaEnD9BVkC/1GHvsGoJdtcD
	 6aFFfWl+eRdUa2P1IoiFv7Dm4LKqOdxkMEjcj0D7G9kE/QdBQjWl01CAqqMZlLk9gU
	 OEKganv0Zc9V1YeZc8eewaAHC8E6S3BmHqVXJEkNXfY4ZohJUOvegj8GstXxpWV+dS
	 bH8w8zRnLdd3MBCHEQhkcLSEgwh0QK8DGVApLdJqeFVKnO8+KZWlbOHbJo4Z8UCy0l
	 q3fLPgBC9KjsOaNAodtNomC/uutUVR/IkxCfXaDgb5L4m5cwdnNmIfHePUsmOlTYTk
	 t9ibqp7zouV1Q==
Date: Thu, 6 Nov 2025 18:08:10 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com,
 dtatulea@nvidia.com
Subject: Re: [RFC mm v5 1/2] page_pool: check nmdesc->pp to see its usage as
 page pool for net_iov not page-backed
Message-ID: <20251106180810.6b06f71a@kernel.org>
In-Reply-To: <20251107015902.GA3021@system.software.com>
References: <20251103075108.26437-1-byungchul@sk.com>
	<20251103075108.26437-2-byungchul@sk.com>
	<20251106173320.2f8e683a@kernel.org>
	<20251107015902.GA3021@system.software.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4CA494000C
X-Rspamd-Server: rspam07
X-Stat-Signature: u5hxd8jw9xcsup1r9rsu1fe5t3hsnwob
X-Rspam-User: 
X-HE-Tag: 1762481295-693311
X-HE-Meta: U2FsdGVkX1/BevOzOk8WRkoQ255YsW7JyzzOS0Y1zSuslcpVWNTEIZX4Y7faI87KvgEO+nb6M2CTqlyS+lMQZqcsUWcwlMOgJ0E7E8DcL1sPqPEc24cMhtEvpJ0UNu/q6ypUFbKkyb0Z8hTEWLU3pKAH2y/vsQw4oS+ToCcKSk7da7n9Y/y/KhOkiuyFaWCXy4DcDvh6YmpWmX93kexNsl8jeR4/MFsfMuSLfaC4b5ELBmbFpSMpVAMwPNwn4zLCYo6fW2RfmgNRY8dSld31mJ2nCb/rpSRrQiLqFV4NhjE2mXjhSQ+nejDrGTUDYWGhsY8c23nm2o4C+1tM+7TZPSsjGejxJkzTTmz76OG2cA0fr04UxI4rtF69xSoI/Ityr12yKRbTjRUO32wRvotJQwm/EDhtyMPcu8tnHEfCiZFC/xvc4EbqNTfpsQxmNg1pIEJpkwMfHiyFAegg37s/nQx1Yv2FC3X3qenMeQ7Ny1Jf9eGjgH3UYvgszbKMYDWmaBFun1dkCvSNE4mht4e6Yn9uTm+IVNDzUM+N3YSSvPcUujMamJSmPy3lT+t4prty6eNDB45d0IukMuSXmxhN9KnmDx9eYi0Bqvg9KUT3/VJuUmzwiQ1L9OJ+cB0Zq8gzQb7XtLWean1T7QLg9zzdirtsxe9KD9kTI6YkVzrs/uImxcQd2n7KC7Y1E4707I4mhZ4zVx5wp54pnCUQVaxhjg8RfAjq7GNBQ2qKZU1EBPDSO66j0kKqBATzmdsz/T2qsjJa7jUN+50d0GtxpMffrD7i7Jys8e4qYq/hmsXDReo4BUPsgpgme3BcaRmB+iRwFnvEhoJUckOcGvYjSDJJOH41PSHheK6+t2jpX8kFyjo5yuPuDYGLUBv/0MfoOKmf4QUXN1ECl87x8PFuLaSysNP4IZO6mW9SGtCaEI++nUm2H0WMA9JG66yAr3UrEoP3jFw68D8kJ7aP2TKAHsj
 6Aem7IEE
 797VExKAu/P8oujzk/ABEQHxyk5mGLQK8sdHDFisxpcPeph4wGhKI0yM1kiUH3C8NuKlSwtmx/Y1VNKgo/pjjQBnl5kEpNOj0HnpM6TFvPvTLJAMqZ/ZFlK7Ll3TDB9+9Gp3gAhZtNgjFEw8gleaA45ePW8CRKCiSek+B4Hp8HFJDcHZruzksYvXEVJMgcGEphcE4h4bGID9KSswVmWfCZ0/0COXcXsUlcRd65XEjS9C3DfOmVgsi7SqMMAGf0LXMmHR/3yTm3babTvLuCFEcxLDUAX49niXqv99VBh3s2imekH8BHG9ki+5nDBrdNdBdMIJ1zXtWcB0+682sAWQr+96FmRp5AoKTFfBv2f99loccDqqT2OrmWn3HtIcnGagORgDA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 7 Nov 2025 10:59:02 +0900 Byungchul Park wrote:
> > > page-backed, the identification cannot be based on the page_type.
> > > Instead, nmdesc->pp can be used to see if it belongs to a page pool, by
> > > making sure nmdesc->pp is NULL otherwise.  
> > 
> > Please explain why. Isn't the type just a value in a field?
> > Which net_iov could also set accordingly.. ?  
> 
> page_type field is in 'struct page', so 'struct page' can check the type.
> 
> However, the field is not in 'struct net_iov', so 'struct net_iov' that
> is not backed by page, cannot use the type checking to see if it's page
> pool'ed instance.
> 
> I'm afraid I didn't get your questions.  I will try to explain again
> properly if you give me more detail and example about your questions or
> requirement.

net_iov has members in the same place as page. page_type is just 
a field right now.

static __always_inline int Page##uname(const struct page *page)		\
{									\
	return data_race(page->page_type >> 24) == PGTY_##lname;	\
}									\

The whole thing works right now by overlaying one struct on top of
another, and shared members being in the same places.

Is this clear enough?

