Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EC45FB5EA6
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 02:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4116B0005; Mon, 16 Mar 2026 22:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB6C6B0088; Mon, 16 Mar 2026 22:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1F96B0089; Mon, 16 Mar 2026 22:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 147316B0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:10:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB0528B63F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:10:52 +0000 (UTC)
X-FDA: 84553926744.15.B8C5B96
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id D92A01C0002
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:10:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UE5RPQJo;
	spf=pass (imf20.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773713451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j4sbtWDw4DJ2JBJ+y1C7vQWjeEXxcelaEAyT7ptHthE=;
	b=KHZvXg9u5T6xOuVXzVYClc3rQk/96B7pY3C8itVqYx0EzhSUB1YkR4eCfXpMczwpIj3TO0
	pHzjW5uxRAxUfZP4RzMZdR/3/mnKQ6PX7kflau70zlMsQl/MkAfsnyAPvSR/HNXYmwBnn0
	dOQAbFMyFLyL1garO1GLnQxwVC9kQ8g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UE5RPQJo;
	spf=pass (imf20.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773713451; a=rsa-sha256;
	cv=none;
	b=5s5qe+idDaBRjV7CxZmbfK4wTDJnV8CBsa2lDuIeObVZswW9kvPLQF6TFBILlR6Wc8Ncmy
	QZSGk32Puyfe+EaJpaSX4Dgas3rEfGzNTZBO2VlOlCOnZgWrPBm00AJq4VWrlpidXOyu5Q
	S+LXjtNEpKo6Vmcg1sPCwajES7Igjuk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773713450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j4sbtWDw4DJ2JBJ+y1C7vQWjeEXxcelaEAyT7ptHthE=;
	b=UE5RPQJomup9qv/o0ixPU1NJEEYu2ANfhkR7nG17960EWYiYFNYWFSGULqJ3kUVZKdMG5F
	HirS7tG/bliMT0vtcM0R/gR31PvIdoJKwbheauiDQuAYxwDz3QliHEfI9RAiSxjkgJBSpD
	KIhwBUNKQbwddIKTWdemd081/7Wo7pQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-338-3Bd5hukVNg6_8EEIPcheoQ-1; Mon,
 16 Mar 2026 22:10:46 -0400
X-MC-Unique: 3Bd5hukVNg6_8EEIPcheoQ-1
X-Mimecast-MFC-AGG-ID: 3Bd5hukVNg6_8EEIPcheoQ_1773713443
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF4D218005B6;
	Tue, 17 Mar 2026 02:10:41 +0000 (UTC)
Received: from localhost (unknown [10.72.112.155])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B823C1955F19;
	Tue, 17 Mar 2026 02:10:38 +0000 (UTC)
Date: Tue, 17 Mar 2026 10:10:34 +0800
From: Baoquan He <bhe@redhat.com>
To: Sourabh Jain <sourabhjain@linux.ibm.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org, andreyknvl@gmail.com,
	ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
	linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	x86@kernel.org, chris@zankel.net, jcmvbkbc@gmail.com,
	linux-s390@vger.kernel.org, hca@linux.ibm.com
Subject: Re: [PATCH v5 09/15] arch/powerpc: don't initialize kasan if it's
 disabled
Message-ID: <abi4Gumt0Qr_h-3W@fedora>
References: <20260225081412.76502-1-bhe@redhat.com>
 <20260225081412.76502-10-bhe@redhat.com>
 <71921cca-b890-41c4-93e9-957d3f647ffa@linux.ibm.com>
 <0bc30137-3f1d-4a4a-8573-8f26866fcc26@kernel.org>
MIME-Version: 1.0
In-Reply-To: <0bc30137-3f1d-4a4a-8573-8f26866fcc26@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: nw5tGDeHuP58NYdx7rIyD_waSaOS2MN340KM-P-kYD4_1773713443
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D92A01C0002
X-Rspamd-Server: rspam08
X-Stat-Signature: z31ajatao4fhpz8efnykuzarbxbh1ahk
X-HE-Tag: 1773713450-727463
X-HE-Meta: U2FsdGVkX18jkOwhp4K1hRicQJ5Qy1CM8SPuWy94sO7XPCwML7rhQF6Frk0dzG6a//WS4F0Mu6D8l/xI93BMUu0Xkd83usvch82UsOuZuN6hVz3v35/R0HA1gP2s68TT/FLytPOUnypoHt0+/Twd6ku7A085Bd8wRBPzN6ivJe8ouyFON9hs04vM6JVeZfcop1iU9Fy9soqvirCZPW1zbvonRmBGv2yCf6mjmt4zlzQ4ZavZ4sCbryOAPehaUF8EHrw+c2RXwSfcc3cJn6gv/oqY30w1+5gw9kANGR90IJo0RndpIU6AVZ3MSFee2KMofYBUDCs0uo7UhkxSfbZv/n0FLSKuJ1NYMxMG9wP4em6+x+DIuTBvi5RwhEwm3yYJdInRB1Jp8klFZgGe0hX27a6lC4Rk+1cyJFXB5M+UXemOvj3JQsSNpL8LxG+8zHNq+UtX1OLtooEQuiet9d1YUJYYYCsJ/QsCihwnOx2J6vLKekrVscpA8bp941FnbQiGj1rcoe1/yIR8jYbk4aRIS0qHOmPT4yV+6W7TL/ojakhRU34ilgG3EsRd0l5GRDcC7JBCpXwKGZ9hqxf6FCMj6zDFURwxKFP/kl2cNCBPqb7ZgvbZFnjibbsiM6u3r1pKF1vuULMqgOKtkQ1KxOnLSg2Lv45thK+o2MCFER+2J5Bd4snpfbuCjALK1ks5ZY4S8CMwLjKTzcRTc+xvub6kaAt3gxMXtYM608DXwxql+sCifmO0/aAo1bFAD07bmXzxB6xYgZO4zHxj5AmLH9KxVqllfWzkCPmpPJuKVbyQBAm3z6cAy9rI87YbFazEZir1Hkog6RCcsO4J4atOrSft/htn7Z3kuoAQFINoDlG3fwoJ3BDKi3Q+t9IbYAaJxqI8aamnh8XFUdMdpfehRlxsQ7QjFT9+SfLIatxWILdAxG5DLAaQdBUd5h1XKA9vCo1X3Np2iMyJxd40wQi1v3n
 Zeri/HCE
 YI+0Z6kChx0Dcrb06LeTnJiYnGTZyjkbyYWHsvtWuMOa4jd8fH45IjKyoGplNBONTu8dpvSZao308Y94mMTEgnBW1lto8AyGSarXTuS7G7UC5E6X1uS2BmBtoSOjemNp9Ko1fDlQISSYrc1CSJog82ZTeQ54Q/M2NZkH5qGI2QyqS3TyT4GBG2zTcvpLDyh0bUf2WZ49FHhskwrdfH/iIxFNc+SlA5eBMqfXoDoFhkzSLHNJG4PNmp0nh8GODZNyoMLVF8dK6a63o34Ysh8BfoUK73dITkIpGdbSb5sJojPC8FD1aNy1JAB8LfRZ0RwE5eBnUEMgTbz1mkIUejQbNAaIC8DddUcRASyNG4etWz4w5Ok/iaf2E/c9x30ePY5jq9EF46tZtyJZ0FbBQx3wyIQ+y+lFHfddRN+/St9sfMuKUu+4RSUjkHcu/K6L4HKTyWB1cR8JEaxCopwN20N8SQv742WTPyYhiNbooHUKaYYN0b9l0Cci1RJ+G5Ia/DvEAz2PmmY0a8Fjc89/r0HIfoULY+CoNcVsK2aeu0kpIHeynHLMX5YSvjOD5Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/12/26 at 12:23pm, Christophe Leroy (CS GROUP) wrote:
> 
> 
> Le 12/03/2026 à 12:12, Sourabh Jain a écrit :
> > 
> > 
> > On 25/02/26 13:44, Baoquan He wrote:
> > > Here, kasan is disabled if specified 'kasan=off' in kernel cmdline.
> > > 
> > > This includes 32bit, book3s/64 and book3e/64.
> > > 
> > > Signed-off-by: Baoquan He <bhe@redhat.com>
> > > Cc: linuxppc-dev@lists.ozlabs.org
> > > ---
> > >   arch/powerpc/mm/kasan/init_32.c        | 6 +++++-
> > >   arch/powerpc/mm/kasan/init_book3e_64.c | 4 ++++
> > >   arch/powerpc/mm/kasan/init_book3s_64.c | 4 ++++
> > >   3 files changed, 13 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/powerpc/mm/kasan/init_32.c
> > > b/arch/powerpc/mm/kasan/ init_32.c
> > > index 1d083597464f..0ea2a636c992 100644
> > > --- a/arch/powerpc/mm/kasan/init_32.c
> > > +++ b/arch/powerpc/mm/kasan/init_32.c
> > > @@ -141,6 +141,10 @@ void __init kasan_init(void)
> > >       u64 i;
> > >       int ret;
> > > +    /* If KASAN is disabled via command line, don't initialize it. */
> > > +    if (kasan_arg_disabled)
> > > +        return;
> > > +
> > >       for_each_mem_range(i, &base, &end) {
> > >           phys_addr_t top = min(end, total_lowmem);
> > > @@ -170,7 +174,7 @@ void __init kasan_init(void)
> > >   void __init kasan_late_init(void)
> > >   {
> > > -    if (IS_ENABLED(CONFIG_KASAN_VMALLOC))
> > > +    if (IS_ENABLED(CONFIG_KASAN_VMALLOC) && kasan_enabled())
> > >           kasan_unmap_early_shadow_vmalloc();
> > >   }
> > > diff --git a/arch/powerpc/mm/kasan/init_book3e_64.c
> > > b/arch/powerpc/mm/ kasan/init_book3e_64.c
> > > index 0d3a73d6d4b0..fbe4c9a7e460 100644
> > > --- a/arch/powerpc/mm/kasan/init_book3e_64.c
> > > +++ b/arch/powerpc/mm/kasan/init_book3e_64.c
> > > @@ -111,6 +111,10 @@ void __init kasan_init(void)
> > >       u64 i;
> > >       pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page),
> > > PAGE_KERNEL_RO);
> > > +    /* If KASAN is disabled via command line, don't initialize it. */
> > > +    if (kasan_arg_disabled)
> > > +        return;
> > > +
> > >       for_each_mem_range(i, &start, &end)
> > >           kasan_init_phys_region(phys_to_virt(start), phys_to_virt(end));
> > > diff --git a/arch/powerpc/mm/kasan/init_book3s_64.c
> > > b/arch/powerpc/mm/ kasan/init_book3s_64.c
> > > index dcafa641804c..f7906f9ef9be 100644
> > > --- a/arch/powerpc/mm/kasan/init_book3s_64.c
> > > +++ b/arch/powerpc/mm/kasan/init_book3s_64.c
> > > @@ -54,6 +54,10 @@ void __init kasan_init(void)
> > >       u64 i;
> > >       pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page),
> > > PAGE_KERNEL);
> > > +    /* If KASAN is disabled via command line, don't initialize it. */
> > > +    if (kasan_arg_disabled)
> > > +        return;
> > > +
> > >       if (!early_radix_enabled()) {
> > >           pr_warn("KASAN not enabled as it requires radix!");
> > >           return;
> > 
> > Should we log in the kernel log buffer that KASAN is disabled?
> > 
> > Right now, I don't see the kernel advertising the same.
> 
> When KASAN is enabled it is advertised with:
> 
> 	pr_info("KernelAddressSanitizer initialized (generic)\n");
> 
> Isn't the absence of that message enough to understand KASAN is not there ?

Right, that's the way I took when I tested it.

> 
> > 
> > $ dmesg | grep -i kasan
> > [    0.000000] Kernel command line: BOOT_IMAGE=(ieee1275//vdevice/v-
> > scsi@30000070/disk@8100000000000000,msdos2)/vmlinuz-7.0.0-rc3+
> > crashkernel=2G kasan=off
> > 
> > Tested this series on powerpc Pseries platform.
> > So feel free to add:
> > Tested-by: Sourabh Jain <sourabhjain@linux.ibm.com>

Thanks for testing.


