Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E997DCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 16:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494938E0010; Fri,  3 Oct 2025 12:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443E08E0005; Fri,  3 Oct 2025 12:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333438E0010; Fri,  3 Oct 2025 12:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1DFB68E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:54:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE11C1A083B
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:54:09 +0000 (UTC)
X-FDA: 83957400618.17.DE5D1B2
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf23.hostedemail.com (Postfix) with ESMTP id B8FBE14000B
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:54:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="V rCAewW";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=HJbP2dU1;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759510447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UB3IKnHmzh/QmKgOFKGx8BLdmDHf57NxnecnD+p+sRM=;
	b=bEzAovo/9CehxqqDBgbDsAmVeVb+lHGm6s20YTY+A8sQerKXujTDX4OuEyHcAoBd4ucUnI
	YNpseZ68CCgtCL2HgaF6Ss4x+iTWSus1Ty04S3cvPI/WqvfAynnwO55VktELX+wc/aPGc0
	v583GYhfWcnfRfdmEwyVcGpTcCAzcfQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759510447; a=rsa-sha256;
	cv=none;
	b=qdM60oXaExvzJxcurQFtJkAogJz6EphcafOaY0O3+TvtSbzwXFcqA4ibA5bmtvOccbSG2D
	g3fYb4UABxjRtjTPZk6vqvJANv4p2fHBVOJbCLzlra4Pcf0DfUO6cVGv2xfQm+M39wCW6N
	BNvm9TNDjLy3RJM08iqorsdsUMUfDIk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="V rCAewW";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=HJbP2dU1;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 12A22EC0278;
	Fri,  3 Oct 2025 12:54:07 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 03 Oct 2025 12:54:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1759510447; x=
	1759596847; bh=UB3IKnHmzh/QmKgOFKGx8BLdmDHf57NxnecnD+p+sRM=; b=V
	rCAewWI7sbJvCIV/zpcnz6A0CPYZVWfFX0Dtm6UVGY6RT/28Zy15ntNNBSsAtIPl
	4AeS0Pk+Ho+rYuDaaB5Hw8Klh46ivi7sHEvbAweBb3JCb/miDh0XneQcuqst6+iP
	DHK0uh+ii8tWQ/XnmCSykrps7XG21DgZeTLz9ukgJ1iOPBrHGnVuXlbxVeSYLsbZ
	cL13AnQ6Yg47zxCMlkQh0NMH4W2OUmvwFnwM0klqG7+4HdB4gezArrTeuYAxGz7V
	ME2GJ/yA/ViRO3iBOMsBiX8P2RbCtCRrrX2Qx4yOchMwc9QS9uxG0tWIxDzVxn0Q
	O8zpttlCxiJljP2WsmAzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1759510447; x=1759596847; bh=UB3IKnHmzh/QmKgOFKGx8BLdmDHf57Nxnec
	nD+p+sRM=; b=HJbP2dU1gXqvJr5xZP81JrdPktlFylwZz2QyJKBRAemfB/Na89d
	4uMVsS2+JGsNIkxPYS3qPWpObEW7BZQXNk4si7jgrgb9bykcr+01O03QRuqBfSJk
	CKQ8zCWLG+5Y2L+/ZLXa7Le/UG2trAbGxDTUfJWUGjohNBewZmIkyf2BCHIxtdXh
	0ANiyZFPCCOwowLLBasMsHF8QE2PFo2kMVAU56I/zlJiufJMFrFy6TFIrjofQ7Ut
	6RU6mi1hsO08c8503/6rxQumSpu9sifWbOGYmYQkn1ixDCM91gcAXS8PGP13xoNz
	BqTB4K8OU8Q1vL3G52i84bNpPZ/X7E70A7Q==
X-ME-Sender: <xms:rv_faFkZNxLNHovlWnH8scAJa2PWTnxJ1De0JAA0q7L9aLqcfUCvYA>
    <xme:rv_faAtAKu-en65NOEO7BkuNQHdBMf6MQBzHZGG0KjclxEQVQMuT6VcOpAm_QwXFg
    Zx2rLQp6oXp7ScDUrxq6SM9lzxfjSCyn_CiVZDFn9KYh_0ZTmDuQPY>
X-ME-Received: <xmr:rv_faI8tg7UcRWHdUwZK2xxEpbyuHG-Aoi_-i5wT2AV8GfwOMyOIoUzLIigZ6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdekleegfecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:rv_faByXTQ1ZqOnit033VWk75CST6ABfR9loiaIoWbPuFpuXKuy8cA>
    <xmx:rv_faA9UJCxiG9y9w1PnGVOf5eT3OU6WtAlopeGsVXDnqtRL7jpSag>
    <xmx:rv_faGKKq0HBVamEfVeUQIwJnZ-ReAXqkZuIfxAYkacd9LeUusHHww>
    <xmx:rv_faF-zBsHiJgoOLgY1OhO2oG1y8aGMOmT1NLku6yIyYrzyoB4Qsw>
    <xmx:r__faD9bJJNmCWQHGcetociynY8R-hhTryjqnWWVIeTPovy_N6OmJ88c>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Oct 2025 12:54:05 -0400 (EDT)
Date: Fri, 3 Oct 2025 17:54:03 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Amir Goldstein <amir73il@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] fsnotify: Pass correct offset to fsnotify_mmap_perm()
Message-ID: <uqijoyhj6m33aslecgbovhujpjgql2zllw4ahfpm5jfqkcsjut@yemuevv2pjrm>
References: <20251003155238.2147410-1-ryan.roberts@arm.com>
 <nf7khbu44jzcmyx7wz3ala6ukc2iimf4vej7ffgnezpiosvxal@celav5yumfgw>
 <76cd6212-c85f-4337-99cf-67824c3abee7@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76cd6212-c85f-4337-99cf-67824c3abee7@arm.com>
X-Stat-Signature: 3q9o1gd9ss6fnk9ysurojfeygxyrudia
X-Rspamd-Queue-Id: B8FBE14000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759510447-269891
X-HE-Meta: U2FsdGVkX1+jpxflOzLj5Jv5wQHp3wRquNMYzdVmlEJdmHa2POswAdjl6wB8GIonbniwbvppiN6t/68L8WHNpDd795ZWKO0hM0zTK0i15AlekXikKX+zefF5c0eQ4aRzjJXnmpDYYzRfTGrv2py4o2YiVRBtBLaq2VgTE4BWiECq3s8hLOhhFHO4vq7dkVCGF0hnzHhixTTebXZW6qk+bacnopJ00/l5tQjefT0DuivvJA1BmBPx/aoCPfsn9dy56hMV4VJKncVTBpJwwchiFYxXxSupUTv0oP8QEECh5IxbWXkLKCLlwXLAQp/MY6tqWuGT7qclBeTfVcntlTPqubzi4e/E+LR0wicNQiqRj08cx+zai1nZvDq8TXmWWjmMZwE6/Ep3mRU7Qqmd8xu6RtEqNr8WrgpW0eYPWx2E3Wg4pdZMk+n28zKXD68+MAM7xlElVuiRqLnoQO9/Oz9HmZR0sY4lhUu+qWYg9U8q6ro7qvpa9TtxgpqgJaptjyKV/fDVg/v/6htRkE919qn4sJASzt8BnnfwLN8heoddvNfyK23mQZhLinPKmplqTAcCMwOpIPHyZeLUvDc9yDkQbOfDNcl3cgRNGaJmWJXJdR4HD12kgw640geOnjV6VjS92FrhGQa1aElXhRsi6mHoNKuYJIRTs8/EgKP+WkOOqkfQaM5db9CUtl21RG+pxFQ730e2GAbSlvI/o8GPv2/bWzlflDMvENQ6hWWXuDPGZth9nNTI5YUvmRAPW6kv9Fb8l8d6I+WhhGQ0gTp89q7GkgCdZta7Qog8ctd8gKY4tO41IZ1mSGd9nnIGnESCa+di5Zv+mz15gKLR7Hc3H20Ue5rYIo72QtUQetWosNnD6dC9ZCN2hNR+H4Fc9XuEXxc70U/sZOFHdqU/nk4NXfTBWSUdeNLKL1wm3tIU1kH1D2gsXvx/nDpnTwne1y4eHufid0YMQC1uxCCO1wl7Mce
 LFLsMH/z
 dfqSmPzQCc0qdbk2TYkATTvY2tGNrelALMr6UD/6BgEbRBRBvxBH+MJc4IGhtJuqKfQyyOaf4htzZ85QIkstUXoVb73NaLwuDo2Yq5Ie5Kjlzch+APWt65+RRGbYR6EPboY5OhO6fgdkQRGGu19+d4jA87YgqmF1T64/yw3cJ0oUkNIvb0gclnYS4YlMed4mPPcksK8ECLe/ECavCCQLXk3spr+HUEYBxzgfitylRB/RgMUENSkqXMGfii6AuieNleCPWdG3EZ9vcG/h+fJ8jG2RK41JdDmhLBJ4x0omK4iHS1MPbzTRplkjmVWhkmkoj+npvIpzXsQzfE4fyFEiYgDi4kRxYHY6B5731NkmwtTki/v169N7SgUHe+iSS1LmvsVdRQ0hfJxkwH8qSkiuKTcksgjWD+Z/05LnsrrncS8V7hUF26QsqUYUMyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 05:36:23PM +0100, Ryan Roberts wrote:
> On 03/10/2025 17:00, Kiryl Shutsemau wrote:
> > On Fri, Oct 03, 2025 at 04:52:36PM +0100, Ryan Roberts wrote:
> >> fsnotify_mmap_perm() requires a byte offset for the file about to be
> >> mmap'ed. But it is called from vm_mmap_pgoff(), which has a page offset.
> >> Previously the conversion was done incorrectly so let's fix it, being
> >> careful not to overflow on 32-bit platforms.
> >>
> >> Discovered during code review.
> > 
> > Heh. Just submitted fix for the same issue:
> > 
> > https://lore.kernel.org/all/20251003155804.1571242-1-kirill@shutemov.name/T/#u
> > 
> 
> Ha... great minds...
> 
> I notice that for your version you're just doing "pgoff << PAGE_SHIFT" without
> casting pgoff.
> 
> I'm not sure if that is safe?
> 
> pgoff is unsigned long (so 32 bits on 32 bit systems). loff_t is unsigned long
> long (so always 64 bits). So is it possible that you shift off the end of 32
> bits and lose those bits without a cast to loff_t first?
> 
> TBH my knowledge of the exact rules is shaky...

I think you are right. Missing cast in my patch might be problematic on
32-bit machines.

Reviewed-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

