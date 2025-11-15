Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE405CE8D7A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 01:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BBBC8E0023; Fri, 14 Nov 2025 20:23:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26C308E0005; Fri, 14 Nov 2025 20:23:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15AF88E0023; Fri, 14 Nov 2025 20:23:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F33728E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 20:23:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9CB7312E546
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 01:23:24 +0000 (UTC)
X-FDA: 84111093528.07.AD6EF7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id F12C240008
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 01:23:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cnmqR+MX;
	spf=pass (imf07.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763169803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+czCq/Sk2qqcGQ4I9K7TLRoBcOC5SDgdFWviu/US8w0=;
	b=ahyIXgFTIj78W+m3iRSagFROQ2NELpyJj8uvT+Q6aMnXaT9i2DIk2n0fkrqbrVXqoP101a
	fxMQlCjYbo4nnenwJnMdKxv5eumluAXbo3+vWroDe7HonjHirTUycn7R1qZLvXCejZVWg5
	lm0urt82uSSjCjV4EFUKNazEH1IcfbI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cnmqR+MX;
	spf=pass (imf07.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763169803; a=rsa-sha256;
	cv=none;
	b=Qz5xmRrRs0BpgT882IxewL/FbkZgzc0I7yEH2q2BrGP/zt6y3PI/NkizRn0RaH9HbjvAgE
	usxpRiiBx/MC3qnu8csNKZMazDkTnxN74BCVxrxnVFPcHGw62HxEpk+yKXdDfY1VTg4ocD
	S3JpFlXsE9S20QkgdG6ifhQe94pL/6A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 24F1F41B26;
	Sat, 15 Nov 2025 01:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E79C4CEFB;
	Sat, 15 Nov 2025 01:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763169802;
	bh=EMdA7LgelkVDzq5X2oeGm8KBPNNOdtKtMm09LzMfpWM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cnmqR+MXWNIY93IIWSP5PhZy9V4XdM6Dc+i9FY0vBFDrhSK5jE8iX2DRe+Lue/pJq
	 6MK4oSSxyA6KlLgW/0m5Q80afT4rMM/AjjjY82icXhJnVwAGIRQhcQbdZp5tw+Lmrx
	 RAlrrdU2XUYrHxZ0T6HpLqvYHxnM6sSsaWcVd6H2cLj7y1L5zgzNUzJQ7H0l75U6RG
	 BZ+H0Wt0NbxG2fpoaIQvMLDKJ5HDrFFaH3sSu36ucYzG149L4lQKqlMZH2BN8mNhbh
	 y841A3LmAnj+v2jGzdh0sPabpuo0KcgpvH9KREtLMXk496/V+w3iuIdZXzsJPA1pJV
	 7JLrVOnubpMkA==
Date: Fri, 14 Nov 2025 17:23:18 -0800
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
Message-ID: <20251114172318.3aafc438@kernel.org>
In-Reply-To: <20251112074118.GA31149@system.software.com>
References: <20251103075108.26437-1-byungchul@sk.com>
	<20251103075108.26437-2-byungchul@sk.com>
	<20251106173320.2f8e683a@kernel.org>
	<20251107015902.GA3021@system.software.com>
	<20251106180810.6b06f71a@kernel.org>
	<20251107044708.GA54407@system.software.com>
	<20251107174129.62a3f39c@kernel.org>
	<20251112074118.GA31149@system.software.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F12C240008
X-Stat-Signature: wqu71jhmd1ejqzb9xi9c8uh1f8qsusdc
X-Rspam-User: 
X-HE-Tag: 1763169802-310640
X-HE-Meta: U2FsdGVkX1+2wwzfpayGlCyou812/5xSaslCnAbNt03hUtk3D+NFm5SbxjYQYEqNwlLusWQztuDHZA6vYuvQs4mf7kGYHUZkcD95LjMZ1OZQcPhG3bfPy7VOiW4K2hMLSDUg+D/YuajSu8N5yJfzZLJ6bnnLu97vdmXN4gpYmjpfewnkv04y3kOpJC3N8emo8vpPv4eWGOLmkxk4useBEGWk+E85gEnIq9TNtuF/IdNOfQsvKbhFjLhtAUOWd7JaWG+8BsS/LHfQhggdxY/qf2oxXzwaZwW/9KtGsmBrUwi4FYfs/2b568hgEwyeAzXNem/I31I2btPP19k4LX1EgMrZU6yo7e2bSexE1JrJhWeaZxVTCI2a01MUaNUGKlVLSBuSFuCbCcHsFAZ++OObc03V11USohcbLbG+78sl4KimHqyBCykkMyrI6i5mz+p6Y5S9SPteG5duPD6qXdsWfjE4hVEqDLSxys7fcP4OFKObpV/gq8Y7f6f4j/mzQ8FRqC8dTkGsvnwrfJoj84k0a5aWXoSCcIJ6jxHZ3/xvi13Ip6fPJeh8w5Msn8+6L6sKOTGkbsISYkl0V2OqIs2EWWX2ll16NuwIyzBgzwKd/9X16nIyulQpqJ3gyI6wdLDHHrQXYkOWt3fS11PAq00vMPjQAEnsroMpoGL06/kM07zJzYJqqdB17MuevXNoff3BGzgRwJ0ITGxTR3uRAIUJp56RRIB/xOo9+tynzU4KEAgIJ7ggN8RwCng5JsDA/e1WC0MmDqxWy/seAxGS8lI/8tUYGoKxVlspQrbjD0CXQ3sYzHV0Jhu4JVHMz2DCJYUwnqs0raPOF6WfEDVgdUm9/Ctut1+qjpNFqcC15LefjxycqbgkBS4nHSs+i1V5wK2fW5hokwi4MHfKw+97jzUnKhNPWDTTLgQXqehwy609GkcA/gQjEqH/WPZKjyKb/UEVXXrv9reux22FQm22Vjh
 XFH+m71o
 wr97r5S0SHUYywHZHC50+DQ+4/l31f/SiWMvABb0QgPVnkExJYfwTctd5EPxfUpGbzMLBxBFT60ddVT+OsQUm1iqc5/ZdsUuW68Nr5/AadBz7ZgIQjR3o3cc8ke4tAUi7qHv3AK7tSvlUeWJuCItWY6b5I4dsYzpofksup3f6Z0j6ZH9iFRjnZVto6NqKTI1wi7ZfqeIkeqO5voKN7luZS7uYylDfW09SbTaVojLc9m4pD56LwtaAlgWZ45CjHYF7SrFnDOQ/dzF0F1xMYRtCWqDQal/StI7xnEw1oquuCMyGigVG1rm9bXHFFPRvW4fxwt9zeNBgkKaYaDs6q2zNYKcn8qsB+KVZ3pdB1e5rsBBoHciqbA17WEgCf0bEhWbvAO7/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Nov 2025 16:41:18 +0900 Byungchul Park wrote:
> diff --git a/include/net/netmem.h b/include/net/netmem.h
> index 651e2c62d1dd..b42d75ecd411 100644
> --- a/include/net/netmem.h
> +++ b/include/net/netmem.h
> @@ -114,10 +114,21 @@ struct net_iov {
>  			atomic_long_t pp_ref_count;
>  		};
>  	};
> +
> +	unsigned int page_type;
>  	struct net_iov_area *owner;
>  	enum net_iov_type type;

type is 4B already in net-next, so you may want to reorder @type 
with @owner to avoid a hole and increasing the struct size. 
Other than that LGTM!

struct net_iov {
	union {
		struct netmem_desc desc;                 /*     0    48 */
		struct {
			long unsigned int _flags;        /*     0     8 */
			long unsigned int pp_magic;      /*     8     8 */
			struct page_pool * pp;           /*    16     8 */
			long unsigned int _pp_mapping_pad; /*    24     8 */
			long unsigned int dma_addr;      /*    32     8 */
			atomic_long_t pp_ref_count;      /*    40     8 */
		};                                       /*     0    48 */
	};                                               /*     0    48 */
	struct net_iov_area *      owner;                /*    48     8 */
	enum net_iov_type          type;                 /*    56     4 */

	/* size: 64, cachelines: 1, members: 3 */
	/* padding: 4 */
};


