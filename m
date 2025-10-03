Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85674CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 16:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E346B8E0009; Fri,  3 Oct 2025 12:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C498E0005; Fri,  3 Oct 2025 12:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49518E0009; Fri,  3 Oct 2025 12:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C17188E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:01:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69B8787C8E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:01:02 +0000 (UTC)
X-FDA: 83957266764.24.93C84EC
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf19.hostedemail.com (Postfix) with ESMTP id 69F5D1A001C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:01:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="X vdg8Y9";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="cpZY+MJ/";
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759507260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nV/TvSgZMitb0mxDDmCIB9D+mWhQJM8naIFJGNjXnfw=;
	b=4Urq1hYTZwrUIS0OV4kgcTJyT0nzTIWtygYl8ypnlyEIN2jQa5IcfKLfKTQg2g3irHAO5J
	PsOntDAwhz6yUtM6+6s/fy17hAy8brKhCDVNqbF8eAwfBij4w/upsRDZ+lZD6oV5Gjn/Q2
	5wtXm+UENcKv996LRuUtbwM1EcZl7n0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="X vdg8Y9";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="cpZY+MJ/";
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759507260; a=rsa-sha256;
	cv=none;
	b=ixiTF8FGT+vSgUC1RvdMIrbNRsEGrZ1U8hjqbCynX+0ZgPt0lwGDBEiHj9kY84TvaFkD1b
	IlzVY13RdidNxXMESPewvJgIXtAylbup24cbpruM0hdYgW/3e6TwM7qUQ3+G5/ER9kagbg
	pHrhX7L/HAY68JKNAMa8KyeKbaFa3BU=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 93F7514001D6;
	Fri,  3 Oct 2025 12:00:59 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 03 Oct 2025 12:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1759507259; x=
	1759593659; bh=nV/TvSgZMitb0mxDDmCIB9D+mWhQJM8naIFJGNjXnfw=; b=X
	vdg8Y9wrz7KOgx02N4V6QTvP+I88EWKv4coweQ50qVLJ9L+plpwIbw8onRT2eqFC
	iUGBbOnmRxfEfWibOq8YsFiFMZuXeHIofOGo2V9DAWhjDbEqUOlcyw3sCx4kM2rU
	lA9PHa5z81ukytEI0Lg1g41W7K/kx8U+7ETKuQX0PJ00eE5fAI6xCMfiddYiGdHk
	+alcc7UoHhAn9DdJyM3ykEY15qDbY85E437XhTB//W6pypnas2IW4ch7KdYcY/T7
	s7BtlQS73sc3AtU3RjlfhBozqVuRvf7tVc4Jg1Wv9zEa4M5+svaqZa5o9Q+k8H2U
	MOGybciyN/5w+aXmgxl7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1759507259; x=1759593659; bh=nV/TvSgZMitb0mxDDmCIB9D+mWhQJM8naIF
	JGNjXnfw=; b=cpZY+MJ/jqAETe+7MKtZonnmhDfkmDbsw8N1aPNW3IMixUGRWfy
	Hf/N/9csiWZd6qNIok6pl05og0nWNWxoQmjWNMtnrumIfoa9iem/bJjbI/+99JsC
	JQfOaTXetu0Vsi15UKU0Kc55V5yKClOdLn5sWo8yHUtSmEvIUpmaQRCtYNm2V8ri
	9HudK9zrk8LBf3/tLlK93FOcb3T5VUBFOztnxUvW3q/+HINjkThrsSWpBid83N1r
	za7Fin4+xlvZb2ZURQAfMu8xmlcuV1pPIQwTrkjZ8vJMvaaOXEfV1QemOwuCgbCx
	nXobwVcDhZ5RMla2foxPKodK15JBbRHOCIQ==
X-ME-Sender: <xms:O_PfaHX5obhnsrVyh5zGRyKziZf6R1h3KfQ_kLEWhTy5V9ST8iJURA>
    <xme:O_PfaPfT1LECRTAR0AgIB5_N9-WkyfAM5WKHC6umyDkzOTpIAxiCqYZkWAAFr_8WH
    TZyUhLrQh4ldU_faJ3jtQPwNIXqPFG10Xl2v6MT45XSgWpVS44klO4>
X-ME-Received: <xmr:O_PfaAsxmt6SvE80d8tDx_-gUh8kbMAUBVEggXVGRi_ZKml-AAvot6hE-JJ_Kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdekleefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegfeehleevvdetffeluefftdffledvgfetheegieevtefgfefhieej
    heevkeeigeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhho
    vhdrnhgrmhgvpdhnsggprhgtphhtthhopedviedpmhhouggvpehsmhhtphhouhhtpdhrtg
    hpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhmpdhrtghpthhtoheprghk
    phhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvih
    gusehrvgguhhgrthdrtghomhdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghs
    sehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrg
    gtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhrtghpthht
    oheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhooh
    hglhgvrdgtohhmpdhrtghpthhtohepmhhhohgtkhhosehsuhhsvgdrtghomh
X-ME-Proxy: <xmx:O_PfaOh6i_eJnqpEN2Pf58TsNXEndkcU0QUQPe--q1jQo3Pc0bPcLw>
    <xmx:O_PfaOuZN2vNAsKA6420COVGK4wPZMQrCDoy2qLSN1gj1lN0pRKJPg>
    <xmx:O_PfaA7xc5zTB2CxT2zYMHWsKveYRVpoB99tY8lS9yitiGEFPS1fhw>
    <xmx:O_PfaJvyKEOo5zL5QHLKcH1E_Xv5GxHqgpQ3iEiTyvmbKa92zKkqRA>
    <xmx:O_PfaK9E3wnW4fmuttGGRZ4Ve7qL45DgMnv1YghJW1P1XgS9K9bitr1V>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Oct 2025 12:00:58 -0400 (EDT)
Date: Fri, 3 Oct 2025 17:00:56 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Amir Goldstein <amir73il@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] fsnotify: Pass correct offset to fsnotify_mmap_perm()
Message-ID: <nf7khbu44jzcmyx7wz3ala6ukc2iimf4vej7ffgnezpiosvxal@celav5yumfgw>
References: <20251003155238.2147410-1-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003155238.2147410-1-ryan.roberts@arm.com>
X-Rspamd-Queue-Id: 69F5D1A001C
X-Rspamd-Server: rspam05
X-Stat-Signature: s3f86mx781kxdx7brtbxbc38cgjn171t
X-Rspam-User: 
X-HE-Tag: 1759507260-86620
X-HE-Meta: U2FsdGVkX1/FF5PUm2ZEauGpKmkLNqHPjZ4d6qvUl7PSEYqYYcufYRxlKZFw+Dx5ga1JoHoU9NqH/Xf/RjOjynfF3vLPv+BGtjVieoNfMY+RlX8hNgZnwRBk0sSGgV7a+AidxiM67UZuHXE2yOAS6So0WBnoO3bL0Y0ShO3weN/fh1TTWoLet05rvPg0FRjBZTvRTAunmfuvRDGS0mI3ubaYF7/9WN19quujJh9NsKEbbhijJClmv/IyS5ZiszVZaFHZjm0CVtavUNfSqjeka7L0Hp0hm17M2wJxgLa7367+UAQ72io/BwONpvNNT1pJ+CBZWq/K19y5oqmSwXzvcQC6LgWOJEJgS82oat85YRhJQhjh1YS64btXIGXmcwgzlWxA9WOL7Fvp0z/KrPJf4WVjjNUQxmo245l+a0pAmH84TDrXGepEZNsw6CWacLiLJ3Y8QBPwDub3XAbqH2MwOF2tbhJ2Ntatsg4Auu2woCyERBebwBLh2y6mHr+uJqcFIu5mxOukd37KSEtV1+N6uLkUtywCvgbwoM9uKVZswp4+RYfJGnsXMinR7s20UDeOW6qL8gW6q0iuUWz9Kw2jinuC/UlAxbNQ6fezbwg7x02JMOR4MO8QsP++8BpxnYRz2dTy9+3McWv5brUhsytm65dyiI5dJXnERxeTKTb2acJeDQdqQnVCc8lKsh2StBFmBUZjF9l7qKlfkIrb70Nxci5MopIefh2bJtnVwIwqsYgoCWXbVYIP5Vcvp7nh6JCWMJw2VKiGaPeyUR60A/+7hl5/NRms4mi7SpjdJM1+TnlMWbWQdj1rKBMkSw89idNq3qljrVjGr5RylXdz9jTWnoSF6xpy7BMTFWHhBRRaG/lFwOkhZ82VHyLCDFZMOnCaOPbQmH7WfWRLrZLw6Tnsd7FNXkV12oRhhkSYOLYk66dhUKxa1+81lYHxvR7QTu/pUdf35D5+M9GnMVZxuAd
 dAX2aLpo
 Z9bDmcKh6ET5rpz+3ZvF6Sefw+BvFDxF5uVg0NRBJqyUIGgvRAXP7b7gpVWdYg4dECxmUkka19CRns1xCqz1tG/XkizQIO+ZCBJadqUR92w8H+SCzfnGtBtpcZRArjza9wJzZK746/2etZcSBJsMYWrsl4JQEspl/vRRh9mWvZbMhxrldIO2QNoUi7h+VFGNbRy33uSXU745t279ZF42gjaUC7taPN8bw5ePtohWeci5osm4IcMMs2oU2AZp0Jx5Joi8B7RekvEswfxnnWrX3F9HEh/t27+HIHPaQwTIvncicovPnGf2KiggHhJqcbanLcxpXnU5UoQVus27RfsxzCIxb2VkrcAEDuwYgt/2nPTfKHUvkaj+nrrIzqGDmYUeLSePo7jcfhB20fOJlQqq4JGC3F439DsNhBsc4cYn2kv0DChTL4+eKMGzHZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 04:52:36PM +0100, Ryan Roberts wrote:
> fsnotify_mmap_perm() requires a byte offset for the file about to be
> mmap'ed. But it is called from vm_mmap_pgoff(), which has a page offset.
> Previously the conversion was done incorrectly so let's fix it, being
> careful not to overflow on 32-bit platforms.
> 
> Discovered during code review.

Heh. Just submitted fix for the same issue:

https://lore.kernel.org/all/20251003155804.1571242-1-kirill@shutemov.name/T/#u

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

