Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11834CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 13:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ABEB8E0006; Mon, 10 Nov 2025 08:38:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D068E0002; Mon, 10 Nov 2025 08:38:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199788E0006; Mon, 10 Nov 2025 08:38:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 087C48E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:38:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C91304A890
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:38:47 +0000 (UTC)
X-FDA: 84094802694.05.BA214C0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id E79B54000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:38:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PQWMWyeA;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762781926; a=rsa-sha256;
	cv=none;
	b=5rxn/C9MzpbBOE/fhr8xiWLUoWqXCqXyU4CLQI/83SjzPPADCC0uPQC/XrNwj8qEFNh9F+
	21VlWLhEsyDTGqSN3Fb0YMAAS6nwdwD8iNlZSReB+L9SknEqaaWn6JW6jNeBPz54gkpbD0
	Xdvp7vVMAto9oDu7SXBt1EUfAsiYakA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PQWMWyeA;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762781926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESpxzLjRIYApwkHxl6Vgj10zCasBSSNB54DbKubFwY4=;
	b=Gv94HWOuJwIxxyqwliDgX6oskuMc8BAYfJvGdEUD++WKXB4t6CRp1OWPojkxUXbWbE4ESk
	u43wzeOg224Qjq7HtrIs+dC7DpdmTxRbTn1uJ+MzjefVN4qjyYLc5yM2hLXl0ecZrclxrK
	IkFiIPg8B/m93l5mkMW9Vfv5IKtNApk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ESpxzLjRIYApwkHxl6Vgj10zCasBSSNB54DbKubFwY4=; b=PQWMWyeA36Wa+X7C9sAPrQru6l
	ZH8kPCH899xum93FMK/P+W/guoOk3C07s17/t3ZB+VfNQNbWUkeiKf/+3IQeKpYLj57WjgglQwMao
	0aRS3BqQ0uTgr7qUgdBA8IzRaaBLylqYTEDAW6Zu8uBlpsPJiMJiiQJ19KA531Yq+BHC7oUSrJLUi
	itNxRLsDV0rsi+jrw/0HkwcxzPuiQMOp5mkg5gZ5v7TJGHf4hw6MsHMhk0xWjUwAY5VWex6KVOs06
	1ZUGmNcLJ9x+1J/WmfxUDbQaGUtNh6vm5IoGxXpks9RjbdcAQZW+dOaQEglBAngDQ2sk5iCgt+4dE
	2+YEy7vw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIS6S-0000000GI3P-2js0;
	Mon, 10 Nov 2025 13:38:40 +0000
Date: Mon, 10 Nov 2025 13:38:40 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, vishal.moola@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/ptdesc: Derive from the compound head in page_ptdesc()
Message-ID: <aRHq4OdBCtC_V0eS@casper.infradead.org>
References: <20251110063725.3118037-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110063725.3118037-1-anshuman.khandual@arm.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E79B54000D
X-Stat-Signature: j6j6enna74j3oqokgurm1jdoensxu6m4
X-Rspam-User: 
X-HE-Tag: 1762781924-274137
X-HE-Meta: U2FsdGVkX1/f6ST7co5PxiuTp6kMkVr/J5oayNEZk9RJm0B54i09/MvpNcEr8eGbn/ftQ0HLkfIXOETxRzppTfHPl0PYS339qH4O7MlwO3QcIaGOxXmsEL1GBSukD4FiUKAedYN8fcFHVCayfRKwrmD0YsA0hR9XW0H2u7YOHNi5+1W8ph466R8G4yBcsB2g+SwGu8CNUk0wcXZ/iTKKDqOc6/Gd/2SqjkVVbNt5MycbYQPVrGL5Asc1WDx2vemiHDa10tpgU1LUN8e3bPnGgloJj6jFPOSuU6HlQtVwl1nqp68//v3hx4zhoMjRFHJOKA283eu7w1Cc+9o+/af+YtpoUU0NICTH3GwERdSVO33P+vwE60uTeuVRSZWVR/sxwTdD+jVphbztbvHFlyWC5CvWLouKacNTBu1CBwdNtLohvRBduvNOyW/se7F+ni0aUPX+cbSAloaRuBJYzoE6vRNLCNVW7RFoTa0BLeCkXv1p36leNzB7bocF7JTxW+ORooOgOel2tSP5pKnhcsRmGkq9U9psPRYykLCqtr+EXZ11uL74OGLqCskJC3jsuNni11Btlwx9QkOwVQZM2MadiuElusBD1L+GS3imVuYAoEXeoS0Mhmxe4Hya2Gql7kR88qtFvmKmfdxD0KeCSxoWyiZGDhtZoO/QdwgMGZj/fqr7G35kupUAUoLkT1UFhZI35INBPVVAfjpHLyT8gI+UUEmMfEZB35Yag2z3MtOciieI/+Tq/qhNcBEdR58Ik+2CeZqSBXhYFjVOjzLHqAhtTeU7yQXOZYWqZar0i0TBwvnUa0M4exg1ZuMfySHEMzXOcgbOPBvS2h94/mkFBmzwK6WKt/A7jnNsQm5BZbNPEFt+yv0dJUh2G9sz9AIIP+aqUxSi029Vnqi0uFmEen9NiOJmixcBv2IEPmGLYQWFY/z0E8HaqOMsI4kh5BFs2P9xsNwfjp0Hgc2w7K27CRD
 ABgnR248
 VZRwk6aED8NhaMgbid8WHcBlteuowXgJER8fAVgNJZ7xIsMUUf38wxt4uWUb2/OsJ5pHeSkL9pOOoKEvkFemW5MqdjMa/MIXpJambj9IgkS8IwoteoWUl8ipFW7E0HJITlSJzqhV3HSzQuULw+t09ez7TsFDLhbpVuEsAPOdsuYNUFAyxbTNb0BcC/583Y/CM40i4EEBgtFZ9VaYMaK+LjXI2pWbZ+kuSWZtfoLcYlErfXRgNHk8KeA1g17MRpUa0i5MQtYaUx4GCyxtaAhy1upaEfOmArmUTc+PASvg+HMorH9cKv1U9+g2bnO5iJm1e1BWBdxmJCR8v5eKLkz3x24qdzCKE27HxNUcCGs5W+KOCz7cbM76QAj8FJ5klAMGGi+79spAGvFd3YMVPiFD+01wcNu+60O8xEEeu4SIweDEQrrP6Fx509tt9hyLpsaDGU9sFYGT8NPbUicI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 06:37:25AM +0000, Anshuman Khandual wrote:
> struct ptdesc (including all relevant helpers) support multi order compound
> pages. But page_ptdesc() coverts given page into its own ptdesc rather than
> deriving from its compound head as would have been expected otherwise. Just
> change the macro to fetch the struct ptdesc from the compound head instead,
> so that the same struct ptdesc is reached from all tail pages.

Please review
https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/
instead.

