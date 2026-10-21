Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBAD1606A325
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 10:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AkHKS07S
Received: by kanga.kvack.org (Postfix)
	id 0A2206B06AB; Wed, 21 Oct 2026 06:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A316B06AC; Wed, 21 Oct 2026 06:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1B46B06AD; Wed, 21 Oct 2026 06:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCC476B06AB
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:34:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D247DA805B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:34:28 +0000 (UTC)
X-FDA: 85346274216.25.90556BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id BFE9D80005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:34:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AkHKS07S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792578866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y2v57bUWAG26s2bm1BoDK2qEh8HhgMjugrP4Ic/x+w0=;
	b=e8gaIORHH/oIZvlVH6L4wkRGcU2vMhl4WlYC1KmFmmxWpaCO5YNNAF90TMgRHK4wR1RbOk
	UHXrjdkfRMCme0siNGb9o4I6Q9255Bc3Onl6jvrdCh0Pu9Gtojw1I2zjefUt2YszjNoRYd
	y6370/5D+bwExZp7OXiIWXdoxHa4z5s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AkHKS07S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792578866;
	b=Rsl0HEUw4u1tbRt1hh6XiV/XhobVKwQXI+L30cztoLBhHGF0NIPv4rBTJbJjmccUdVWTt4
	T8y+PsstV9mHGcU4Wc4zvB5rm2GJEbxcnvirEvGQ6l+nuNb91zXgnfCvpflRMoziSs2PjH
	hnby5z+edd/ml8hkOWdLoW68nkpf/go=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5B9243A13;
	Wed, 21 Oct 2026 10:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BB21F000CB;
	Wed, 21 Oct 2026 10:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792578865;
	bh=y2v57bUWAG26s2bm1BoDK2qEh8HhgMjugrP4Ic/x+w0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AkHKS07SreEz44Ef4ECOlzOb5mnzP9iJk7YT0+qqP0xIFFHOlPZnphtCXRGztYfAq
	 qvuTG5kksnxWd6wmtukEXn3W4Bi1Z/sh4PcmQPLBmEBCqaI29KXc2F8HoAJfhwjANl
	 u9lO4OIKSlKv2Zb9hhS+4jUHOY/wMC8qsjnR1wfOGgLVrDs15QS+fUNc3RSGGwPk2E
	 mq68vp3vBAHIROeSLvcSEtnc+4N1kNMYrnaM1lcBkxK9+0F8yeFMXbWkcmwAkXyfoU
	 vh0PrK+yzlzEgHwlrQ9+RTsCdkQlgw5iW/i0abyKid8g8Wg/brLKmcQLcpenLi7OD4
	 5TexAVkROVpLg==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 91E29198003A;
	Wed, 21 Oct 2026 06:34:18 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 21 Oct 2026 06:34:22 -0400
X-ME-Sender: <xms:KZXYap-B1gdwwfApnDe96FzTIIISa4dxNma1SHwQYQt7uxZ-8Bm4zg>
    <xme:KZXYasM08_wpU5LkFYXYcHzCfKFMAJ7WQjGe1RwK56Fxo4os8ZSMEYTD9u5Rg-G88
    SUSAOl2YAaSd7hWMd7uA4AmvoElK-byuHUVADO6n7byjAqbdPAJMs_E>
X-ME-Received: <xmr:KZXYah3QKPZaSBtpYFY5KUUNTd1z2Bw39JqeYr7iYE525tekLHR7lzTE4vw>
X-ME-Proxy-Cause: dmFkZTFQXCLhgM1j6Uol95BZ6fYJcKahMN2vJQx7GcVvkHkXemtg13fKccd2t/ueNjJM1R
    NZNDI4Gh+RldPGTb1bpmZejKabh2JDquyTm3SXJ/srOft1k+cpto6f5YKWNDAQFuIJ7ff+
    qQWH455eQHrQF1lsqcQvBmZn4xyB4v+poc3u9QnXsJ6qRNPfCIDd8yV7fbhTXFgHvUzpsG
    SKDwbvYu1qlrIXYGiSHoxu9xNNJCEKRtsPuXelRWYRCEtvWD3CgaRD2lyuw0MMIHgO5r9+
    QhijrY6ZhmtL9PQUWhLSIkqUi6Czh066+c2VSkDAhDkzsmqHcpvQWWqmoVAuBOSEen2IEG
    I8DRubFCdnteHWcaCg7+ep2GmCV6a1jAygX7y9kBDDwtZox33QjkNDf89pfnetl5BFphag
    esd6Iv+6E+XFUU5a7adlxlJKyfbeOFFX8yHu6SdKamKUNU0hZgDKHalndbHtyq3+LEb62x
    Y8+X5Z7xk48UcOEHntNXppBaLzSeoD1M5mm9z8M/gu8fpTer3OE62V2mnqdvYet/j4fOhA
    VzOL8tdmklPthIG33/HCqULQeuHbqhaerqtfo4myPpP3qcxdkvVfKyzASxaTnikmGpx311
    0eSuN4plxEUs3JjUKHKxQQBKybUwylz4/QGqFAXTXmK4Rg3qtoNFogtp1WfQ
X-ME-Proxy: <xmx:KZXYajo2jWD3StK13oUCJD-bGc_sbcHvNfCY5u_rCvtEr6pN-GzdKA>
    <xmx:KZXYaps7lW8jncdcwOVb7MM6OQebOJocgq2ri3h-HpT1YcojzLb_Ew>
    <xmx:KZXYamJdmolfEHZ4N9B2f3rCJtpC50qh_FSaAdT57208BdoilWH_-Q>
    <xmx:KZXYan3cSU_fMf1efCGtB0ld1kj8lPH2JDBXx9fkIFzQzBz41yU-gg>
    <xmx:KZXYatoOQIPIzFknbNSPFv0KFOSG5WppE3zZ9dp0DwcE0SJbICUTLnjA>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Oct 2026 06:34:16 -0400 (EDT)
Date: Wed, 21 Oct 2026 11:34:15 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Usama Arif <usama.arif@linux.dev>, 
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>, Zi Yan <ziy@nvidia.com>, Barry Song <baohua@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Michal Hocko <mhocko@suse.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, kernel-team@meta.com
Subject: Re: [PATCH v6 16/19] selftests/mm: add khugepaged race harness
Message-ID: <atiU94VjdEsWzdBr@thinkstation>
References: <20260919002451.496763-1-kirill@shutemov.name>
 <20260919002451.496763-17-kirill@shutemov.name>
 <85b3725a-6dde-4a57-b303-4ae2b53b60a5@linux.dev>
 <6e3c298f-9b93-43b2-840d-65c5ffa3bc36@arm.com>
 <248431ea-4bbf-4a48-a80e-72287ffbae22@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <248431ea-4bbf-4a48-a80e-72287ffbae22@linux.dev>
X-Rspamd-Queue-Id: BFE9D80005
X-Stat-Signature: 461tdwxg6fu5kzzbmn1sopd6sqeiuu57
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792578866-970758
X-HE-Meta: U2FsdGVkX1/xq/pprU3wR78d6C4y/ikjLldrWv1eIVOuIKhQAKdEKM2q/z1vSANZeWMZhTt/vSDUNnjJaaoCsxN/JtQjpbm4tQnu8ujOwsJ63sGmeauz2CKlMdMpUnEi53GC0YxhjrOstVWZi55bjjPblYfe+qXzQr7PoIuv5xuEEPAOwv1zBgpzSv4bx+yTcFgq+S230JhN3y+y9LxAoue3jkRZziJhY4G5kry+jFyELDANVlUZ3mmMWwpST7v3PInUUkYZsKLKYc1wE8sXQGwqHC3fjxLXrF0ixDBQu6xUDmDq3mnCgEAnJAZWpO7l9IsuimElxRuknl7QjWYd1y1C5F0wYZpPyt4ffhpoAd6/IzmeHRSpfQIBgNhn00ab7Y/E9O4IzOZ/IXJOiXgrfv5gtB/xk1ghTm1LbRmX9gLC0uVW/EXo7/IVlaWyLNJUWbiLhIM+FLS2pL7HFP6C81KdpOMoh68QOSVGjqEoMLcKi2QX63W9D4Zn+w+Ug6wp0oDQlcqKCjv3RgJ2K15C56hR+LX6aqdYTUgj9vygVACQ+65ja4x3XXA1uE4IAwyj1/on/EjqLh9lfFdC23I2IfL+kiL9MznbJgy7aY28dMw93qCuJOHzY+qRPZwLhJG9N5B5I49cyI0pHyw3UnmmsbTd9DeIDL1cwc2rR5e5skfRvVQN0KiRG+p/ALDzZjW36zWkKJsvBG7EnMC5slzyzjPYCPmLwLQnncjScLMs8VAENvGfx5UTn1+awo6G6otwgUzAQH4WFYzzRzUzLf7PzTjDXw24gj9IpmdgZjBmGCT1NfzwOJvGuzrZTY+c52Wy06zjYqn06nDEkIfC+coFKdZNoQqh3GqHEt0DBpyMCal26dKznGO7xQR8gsPa+3MeGhcRRULhAKMGRXFZuHSxHT2hYq8nkD8ALUs5MfZyrbxOKyRkdre35y2liskNEKfBZWZGUUPBN/9UI+vYRKZ
 HsuZn0ui
 rYK9R1a0atWZ3Qvj7i/6M3D1cdBlVIZb739MHQTHb8senIAXbvpc/5f1FLVsnOISBy7rjsfDvSG2vzUvYdsiVK5ngcFPyhZ4auofyzVYeXxCvmzJz0aXUn5O/5L+J7zeOB9hKTwE82pWHfys3z0dddoE6Ow6qmxkacaIlPrLoIP2DVZqz6pCuVHlJDTRJr1+JDWkWh2PSPaDmz0gA7FKir7DqIgxYRhlZOb0e3oAbJ7BhOK1Dq7jvWnmMrVpQhM6RhJbXvBe7krqXbF4QZKQuJbB5G6nOEOmNBGrMG8UW/jzf4T4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 08, 2026 at 10:23:22PM +0800, Zenghui Yu wrote:
> On 10/8/26 4:18 PM, Muhammad Usama Anjum wrote:
> 
> > On 08/10/2026 8:30 am, Zenghui Yu wrote:
> > > On 9/19/26 8:24 AM, Kiryl Shutsemau wrote:
> > >
> > > > +		} else {	/* madvise */
> > > > +			while (now_ms() < end_ms && !corrupted) {
> > > > +				for (i = 0; i < nr_shared_areas; i++) {
> > > > +					madvise(region + i * hpage_pmd_size,
> > > > +						hpage_pmd_size, MADV_COLLAPSE);
> > >
> > > I got the following error when compiling it:
> > >
> > > khugepaged_race.c: In function ‘main’:
> > > khugepaged_race.c:506:23: error: ‘MADV_COLLAPSE’ undeclared (first use in this function); did you mean ‘MADV_COLD’?
> > >   506 |       hpage_pmd_size, MADV_COLLAPSE);
> > >       |                       ^~~~~~~~~~~~~
> > >       |                       MADV_COLD
> > > khugepaged_race.c:506:23: note: each undeclared identifier is reported only once for each function it appears in
> > > make: *** [../lib.mk:225: /data/code/mm/tools/testing/selftests/mm/khugepaged_race] Error 1
> > 
> > I've just tested with and without make headers on linux-next
> > which has this patch and I've not received such error.
> > 
> > If your system headers are old, running make headers can help.
> 
> I forgot to mention that this can be fixed like fd5295afae91.

Right. Would you like to send the fix?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

