Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44BD6C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425886B00BF; Tue, 14 Jul 2026 13:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC0A6B00C0; Tue, 14 Jul 2026 13:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EC4D6B00C2; Tue, 14 Jul 2026 13:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F247F6B00BF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:59:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 85FB140479
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:59:13 +0000 (UTC)
X-FDA: 84988143786.28.A4A2C4D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8066040003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:59:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Sy24kfg6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784051952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OMaOFnawbeocMTVoN6n+8zspIOLBVJUKG0JkLomaTEM=;
	b=UOqoZdo+2wMfnfkytdIHxXZk9ELmvYJ5qJQ7BmzfOAeMz6sJWhCvf1zKMyrB7GPQfoge1V
	XX/BPYw//Gch4Zxu87fdyPAwMZ5HWeFgPMUypu/qDiShKkKG26thV//m7pX1rXNxNGT8E1
	g7d0jRmTsAW1D+7W46MfcPZvUqzLKRk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Sy24kfg6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784051952;
	b=B8zTsl8KPxiyWOwFW3yP/GehuhIm1P1tPUknla3wDz7xBiG4uxi2VMfK4iUafGtN0Klzll
	jQt6MmgBiVOSspcoQ+5DpQrYBvswfyL2jRcrX7pBiwPdQmFNtWcslwggAt1UMvJFCxCGf0
	bPAQDmwispWlj6DxR3SRhwCsxwAfmnE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27E89339;
	Tue, 14 Jul 2026 10:59:06 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 13F4F3F915;
	Tue, 14 Jul 2026 10:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784051950; bh=YLSO3cj4uznp59HTo6K3Y3qLIJ+ISsuvzTFqOw8DO8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sy24kfg6zd8pNJNRop/ip6vK3z44QuvSe+ei7yBDMgOJ+AmuCVqSqQsYm6AbuGoqC
	 lZJ+hB5IynonlF0Xd5xFhRT6j05I3fGK7eqV9iwp4S7UfNaW857WlXcvL4lT3vU6jA
	 Qslx6H13Q5aAiK/4ThVrFPZNAc560M7EpnY0APes=
Date: Tue, 14 Jul 2026 18:58:57 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Dave Hansen <dave.hansen@intel.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
	kasan-dev@googlegroups.com, linux-csky@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
	linux@armlinux.org.uk, akpm@linux-foundation.org,
	ankur.a.arora@oracle.com, rppt@kernel.org, linmag7@gmail.com,
	chleroy@kernel.org, klarasmodin@gmail.com, chenhuacai@kernel.org,
	kernel@xen0n.name, kas@kernel.org, zhangtianyang@loongson.cn,
	wangyuli@aosc.io, tsbogend@alpha.franken.de, ljs@kernel.org,
	jgg@ziepe.ca, catalin.marinas@arm.com, will@kernel.org,
	arnd@arndb.de, ryan.roberts@arm.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, baolin.wang@linux.alibaba.com, tj@kernel.org,
	kevin.brodsky@arm.com, anup@brainfault.org, atish.patra@linux.dev,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.fr, dave.hansen@linux.intel.com, luto@kernel.org,
	peterz@infradead.org, tglx@kernel.org, mingo@redhat.com,
	bp@alien8.de, hpa@zytor.com, hannes@cmpxchg.org, mhocko@kernel.org,
	qi.zheng@linux.dev, shakeel.butt@linux.dev, kasong@tencent.com,
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, ryabinin.a.a@gmail.com, glider@google.com,
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	anshuman.khandual@arm.com, yang@os.amperecomputing.com,
	chaitanyas.prakash@arm.com, ardb@kernel.org, guoren@kernel.org,
	yang.li85200@gmail.com, viro@zeniv.linux.org.uk,
	dinguyen@kernel.org, schuster.simon@siemens-energy.com,
	wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech,
	muchun.song@linux.dev, vishal.moola@gmail.com, namcao@linutronix.de,
	pavel@kernel.org, djbw@kernel.org, yu-cheng.yu@intel.com,
	baolu.lu@linux.intel.com, Jonathan.Cameron@huawei.com,
	coxu@redhat.com, andreas@gaisler.com, liam@infradead.org,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
	geert@linux-m68k.org, shorne@gmail.com, jonas@southpole.se,
	stefan.kristiansson@saunalahti.fi
Subject: Re: [RFC PATCH 10/34] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
Message-ID: <alZ44XdgTEVFX6jU@e129823.arm.com>
References: <3ea30f8a-bb29-4bf5-8400-1c4840d46a88@kernel.org>
 <7e84b200-25eb-43a6-b5e2-5f27f2d82a77@intel.com>
 <31988089-095a-4eed-b5e2-c677c70f79f6@kernel.org>
 <14e250db-1641-4085-8d13-02f819657d5f@intel.com>
 <d83c76b3-ea4d-4c41-b4c5-f5ae558ace55@kernel.org>
 <alYgMxKqRnF6_X0A@e129823.arm.com>
 <6df814c9-405c-48d8-96ea-929c4b28949b@intel.com>
 <alZe-Cu7yQw9qRXU@e129823.arm.com>
 <alZo9feSrSB_StfO@e129823.arm.com>
 <7cff02d6-d3ce-4315-b667-34911fc6f321@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cff02d6-d3ce-4315-b667-34911fc6f321@kernel.org>
X-Rspamd-Queue-Id: 8066040003
X-Stat-Signature: 4xcufpbkg749h6384taag3rbe53f3wrc
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784051951-296178
X-HE-Meta: U2FsdGVkX19SRZ5WuksIeZK83Hw42G82+xZkiWrueaZ7v0G1O0OG5kQrcwzOBjJ/Z+lG66h4jyBSwNHnr4IgDiyjglxBOfZ/ciPH3ONV5jhrkgkkgQYwrJRXU85ZcMzRmJxibmldFQVBK8j3DLHhpkenGNoE/3dTmnsIv26MYy76Sr/vNwwHsbfVzqJXRs6lyfhpeEGzSzzDr1cGVXxRd+XjIyJlznLIOawPjf4siqHbkleqzbEmhl6GxS3tCWbDHeWvBRvsAFr8N/98yvs7zyxLnWjCKd+Du2THUjaNFAFJMFw20jkeRLdKLxLFb0lu7f8EBvhjnfwgGVfLw0szePQhYOG4lWhShm9jT/PrlpzfnK0aiCU2tYIvNF8Liw8I8wZ9nq/mHgFpAlkXkuKT4DHmCoq+SPeix4yz5m73CCpI9Fm6Yro16cwvPLw0ZSBLFeQA8W7WHrUR9emc9GjWGNFqUI0hJG8bf5NZuqOkWgg06tQFHKe8QupgOMa+Kk/xnfBsQ1umQP+gfaQwHCLrMNDtKBSVWa5V4tfGAUZQD0oFDpe0gXMeUPxa5DIco1L9A9woUwHamCZ+16oauEkCacqaXApznAPMldCITVQH5Py3lOIy5qU9YnAhZmnO8hy4U1tdsgS5wi/3muBtXAkXXolqe/PC8GGWIoYW4SMNcbUKyIse22lT8Jk55IW2HrLXD9L6OJ+ZRFJ4cfrAbKZ3Y/alPxNjRH3uIorSQbKprZnn0PMquvCcK9kjZmmFUMuZqacUqdpsTSdTPuOVrf5e+X6ldy/IWAI2DjBznv+6JLYaUR+NH4WX68qcDlEaco9gMCHUNxWMajhQOfAz246trC4N7q7UIxH7XL20rZlvCzq8UBEbFXIslKkLJrEefK2/BGRxkTPsVFmeq7TdbqVOnok1bqWXha2GS38rsV0KqPi+ZXTMzpg7Eui2LpzLmZqRQf00XhvXQEOm4SnUdcE
 iGXS2mYU
 N/M0SlN6FKEftQ4DAr2pLTFo5TER3EzlpF5+Dt+3xuctfKjD6nToJ/fOdd5aIZnIsiymMxCq1Ui+CNJfUtmw7UEC0dtQ3Chbna3H2EFAA1Gud3abiba6bR1gHgdCqRvMtfkZT29Q+7tJCbLrS0NiQkZ7ibw+VdNMrRWzVIMWdp/ig8TWlRbXxsZIil2EwFm6mq75YK1ctxOwUg3rr7WBrJZujQOpm/jex45FK+2FQrkRF7YMKIy+N8Lp5kbH1B/pt1AT4YoelD0WYfTPaAl1mn/FsuDAB6+wkbHgGxV87NO+kXFXGn8xfY9bHD042QYrnTtrio7uphFqiOU6xbaFWL4ibAXnbEV/YT9N9u+2dY6X2S1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 07:29:38PM +0200, David Hildenbrand (Arm) wrote:
> On 7/14/26 18:51, Yeoreum Yun wrote:
> > On Tue, Jul 14, 2026 at 05:08:24PM +0100, Yeoreum Yun wrote:
> >> On Tue, Jul 14, 2026 at 07:35:19AM -0700, Dave Hansen wrote:
> >>>
> >>> This is indeed an improvement and a step in the right direction! Thanks
> >>> for looking at this.
> >>>
> >>> But one of my test for whether it's good x86 code is whether there's any
> >>> actually x86-specific logic in it. Isn't this basically a translation
> >>> between the integer level number and whether it is folded?
> >>>
> >>> That seems like a common helper that more than one arch could use. Could
> >>> this be stuck in a helper so that all arch/x86 has to do is:
> >>>
> >>> 	if (mm_pt_level_folded(mm, level))
> >>> 		return;
> >>
> >> Yes. at least the level semantic in ptdump (pgd is level 0,
> >> p4d is level 1, ...) is same to all archs where use ptdump.
> >> So It seems reasonable to add this common helper in ptdump.c
> >>
> > 
> > Furthermore, the effective_prot() need to require to identify whether
> > it's the first pgtable to prevent the inheriting from dummy value.
> > So I think it seems to make a ptdump_pt_level_first() like:
> > 
> > diff --git a/mm/ptdump.c b/mm/ptdump.c
> > index 973020000096c..2ec5700e4be5e 100644
> > --- a/mm/ptdump.c
> > +++ b/mm/ptdump.c
> > @@ -190,6 +190,23 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
> >         st->note_page_flush(st);
> >  }
> > 
> > +bool pdtump_pt_level_first(struct mm_struct *mm, int level)
> > +{
> > +       if (!mm || level > CONFIG_PGTABLE_LEVELS)
> > +               return false;
> 
> Do we actually ever get !mm ?

Yes. for the case of s390 use mm anyway for folded check.
> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely,
Yeoreum Yun

