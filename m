Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D71CC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 17:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128536B0095; Thu, 15 Oct 2026 13:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FFF56B0096; Thu, 15 Oct 2026 13:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015BA6B0098; Thu, 15 Oct 2026 13:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D19686B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:12:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A9A3A7AB5
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:12:59 +0000 (UTC)
X-FDA: 85325505678.20.E7EF378
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C379D120007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:12:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F5kYrja8;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792084377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wfze5VWXLXgXs5xl8MP5DoIEk350uqQ1C5W3otbekT8=;
	b=0Vb9xE55d0JTOypqbyGRY+V/c3MGNzhuCsE1A5u5Q3Jb1aLQpS4kO+8ezI7jTAn+SMsKA1
	DGsDe2ReRLkTXYYDH00KPQETS9eURGvuCJdKBjW2/Ipy80v/L1JuCN1/disEdjLmjFuV8V
	mt8vOnP827g0vyi0AC5z2fDyz2FELU0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792084377;
	b=QYvu03V9/NdGSQ51p2Hk5fHLgMwWByeuV5rG4zCOAnvjreMXrTN1UW6yG3xiL0IZ/McXqt
	xxfAfpcUCZtfg5NoydmzZEY3etO3modnb6rUvVlEbRN2tLavazN9shP+HPKg597nSx5w1S
	5SaJLdZ2LCVujJZYJr+9uGTykKEX840=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F5kYrja8;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 293B760232;
	Thu, 15 Oct 2026 17:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8B51F000C4;
	Thu, 15 Oct 2026 17:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792084376;
	bh=Wfze5VWXLXgXs5xl8MP5DoIEk350uqQ1C5W3otbekT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F5kYrja8SaPmmRd62CvpHSgl1CLCslMmBa0Ztex3scwmK9Sj8LW7qAVxkN9sLZjCs
	 a25EZoHTvkMeCa0xTnFnCYxg/i/qE6Llw/idu5W/ceYEhkutc7PF5/y544pqTYxuo7
	 /maVXBQpmvQUvLiHhazAzVu8wifbv+13tDJP+Emsw5ik00VegEaHaVvJ71154pIh9w
	 2ecs9xQ5XVk0nxcl/YYA+rx1u7QqSk3wNm5nKcjybXH0GeHesbVdxnSHZ+M07j0Z4I
	 J7dkNupsuX1pETtzK9C11p/TKb9Pt/bA+XpNJSZDp03RCsJ99x0KoqKON5TJ3dHehm
	 QnYQsjv09WVRQ==
Date: Thu, 15 Oct 2026 20:12:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, damon@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: exclude DAMON docs from MEMORY MANAGEMENT -
 MISC
Message-ID: <atEJkcKqcfOg-Q8g@kernel.org>
References: <20261015-maint-mm-core-x-doc-damon-v1-1-226decb5cd0d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-maint-mm-core-x-doc-damon-v1-1-226decb5cd0d@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C379D120007
X-Rspam-User: 
X-Stat-Signature: bmmp7msdjzcwyjp6dtczxc3sy4emxhth
X-HE-Tag: 1792084377-718027
X-HE-Meta: U2FsdGVkX1+mo+nSuLTGCBJ7MjOJO3J+5cRHNIeaTrFVpG30qqCgc9kVQN/4jZOCs9li8OcSXagrRHDdzW/UheikyZHfgzlOaLY42/L322W48Zm/G1e4jKZnYV0gxx7ZYtirutQl4W/XXhhHntpDxYFjfYZ4w2qs92/7KmEyF2EJH8e8usTpdoNnbE4yhPhMGh7gzYP+jtgmzkCteobgWZ5nbPx1U8HkIq/ppp77hzdl/KdiWGYpF7qs+8uVPtuX0lTauyJSu6WQsPpa5HpISvAij4r4zdb03EpR4uRAQf4/2Cosnh0EwGsFMW4SJWzKjsh2YQBgsp6RsUBGuLpR1jyufOgWypHnnDe/zbLZMlmv7jtCI7D2OqUr0jjCGhWiV3kPe+wtrB314SI6zmNfdr+XU1I/bxX/9JsatG1qEOVaw53JhlsCxD6NjE+8QA6z8o8e0/0d9kOsgKGJjtObPn8GM2CFlYzspiYK/dyrtbUhEkr7kPrzNmx4owGccuXaV5JqSfdB19snOdjDblOU8ycjEU/GH29WFXzBGAdJSgteUJ5vB7oJpWowjsOELsFDVaRmzAYV8RG4nmR3y2NTQPZZMDc9+uB/6LdWP6v0Qo5e8+5DnQv+qLLwzN7KH5Tjt6AZl3lpCJF704uc7vQK3kSEKQK4dM28EKxeQOdnfnvgtwtVOx8hpmrPI2BUyV1zt39eBFe+gEmlz8jaUqKe3P2/HU1VeVOkOFySHXmKxEEsQeeupQMK7VX7jj3ELpTF2CKREa2OyfyAwm49KmPS3NDgMwWI03xGG2w3JVwclchoi8DQRAlKpn02QzyUhvix6aATzu3KY9cPCw8Xly6zWXxA7Qjg0wi3cYMs8ijyBzBz9LWYPJFin9esP4xg6z7nAynFFcU2Dowis9Sfe8cUX8FTncwHK+vIySS7RGgpOuziIXEJrnugupd4ahfYDQUNAi/nxwx5laUG9dREfP9
 BR1ZCmAG
 DNJnypxaM2VNuczO7TNuzceFybi0QlcnUImCE9YybVoXaLc/I7FUZQAnmosxcAIjMrNGYzc1RhWLJ+pFkXfvHh78ET7hEprtZAwQHd8FITUp5HTJWg/q/VF2RA65Nvc12+jkMQDpOlgr1cqt8CbY8GOxfYqY1PIgB5WN/vr/mF5jaiX/GxnuhY8imcE3/z+jqy41su4roEofap4VHR8oKPQiwdP6FGsmC1r+DYul8BRfX08kmDeXU3NlQbwDjzeN1mho2LVjd48GAkNjxPavwiT9u6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 06:31:46PM +0200, Vlastimil Babka (SUSE) wrote:
> MEMORY MANAGEMENT - MISC is a list of misc mm sources and also acts as
> catch-all for the mm Documentation subdirectories. Documentation for
> DAMON is well maintained within its own subsystem and also actively
> updated, so there's no need to Cc all MISC maintainers for them as well.
> Thus add exclusion entries for them.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> I'd love to have the time to check the DAMON documentation changes, but
> it's simply not happening, so this will save some mail traffic for me,
> if others agree.
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f53047aa8d3c..cbe565b353d1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17269,6 +17269,8 @@ F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
>  F:	Documentation/admin-guide/mm/
>  F:	Documentation/mm/
> +X:	Documentation/admin-guide/mm/damon/
> +X:	Documentation/mm/damon/
>  F:	drivers/char/mem.c
>  F:	include/linux/cma.h
>  F:	include/linux/dmapool.h
> 
> ---
> base-commit: d6d3455d8751854e0d1820f14184682e23ac4475
> change-id: 20261015-maint-mm-core-x-doc-damon-d2da56de5ee8
> 

-- 
Sincerely yours,
Mike.

