Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92930606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QqEDY18u
Received: by kanga.kvack.org (Postfix)
	id 876D26B00EF; Wed, 11 Nov 2026 14:53:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84EAB6B05B4; Wed, 11 Nov 2026 14:53:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D4B6B05B6; Wed, 11 Nov 2026 14:53:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41E286B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:53:51 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9445C403F2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:53:50 +0000 (UTC)
X-FDA: 85423888620.03.EA78E71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9C19980004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:53:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QqEDY18u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794426828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+V3zwWP2ctAms80lrtSl8y9J0bEHrdTUBNayQYF8AY=;
	b=g77bOUqgETG68xRPV+skY7t3y0Wd66IBR5S+RvEJJXUGHyycZUhTjndu0loV2loj4NILZM
	9mtS7JTHpX7W6xbfQLuKEfuRMM2R+wR6EKsNMqj931tlsBR/5sIGO5kEfuQNyW46VTbW53
	3UI91C0c1X459ZAMpF9trz80A/tlfsE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794426828;
	b=mC+TCrBJfvJJLmAtkrVwutqKIghiV4sTXW6libKH+uhbJJRN7diwS2pL+xITzwsSo2afDk
	v6felNSuV08YPCYpgcXExCL9TG5v518OPGlyYb/ReMoT42Qq9yjQgy5fyWPfJO4vwzq6Dn
	fbgWsIhhBQqBULzaO9EBJEZgxF4aiks=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QqEDY18u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C81DF4148A;
	Wed, 11 Nov 2026 19:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3628F1F00A07;
	Wed, 11 Nov 2026 19:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794426827;
	bh=9+V3zwWP2ctAms80lrtSl8y9J0bEHrdTUBNayQYF8AY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QqEDY18unlA2o1SPFKzDefmcUelA+gy1zBm6nI24LQCxqs+C6LPu37Ssb87DTGkJ0
	 q5Aw+Pup6Uawag8qqvCaXC7NMZLUX1XwaHcgChPno545yuqxHPntPAZqOl1E/HyNRK
	 fBavzkMhg+5AaMpoSXyAJFGb15buwN5z+K0g5UZsI+FUgl0BTIDKerV9duJ2aqv3U1
	 T1RtbmQFZH2lbRln7uwWa4GP6WddzkzpIuq5UlsVQ9j7f+i6J5vBhEGaDIqGbL1U4Z
	 uBb6mQKPqTbOCIfkGT4Mxm2CQQs+h9ob4+aHuzEgwdmWjtXnnV3vSIdpYZADLr/uAD
	 ZpBAv7/MHfGFQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id C7AC4198003A;
	Wed, 11 Nov 2026 14:53:43 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 11 Nov 2026 14:53:45 -0500
X-ME-Sender: <xms:x8f0aiyCfeXVGyCi9ug4jnThpi5tqkKwpagbx-m6T_Edfi43Iy6pIQ>
    <xme:x8f0ajLoRKQchyVDbsD8uPBhWbxEh-HYBnhPBhsQfaQzZCirodgLnrsVNylHTWn8E
    iOn79CSJePGBhzPhQtUU2KYwwdEQFk7P9QDy6_VjSwomTtKjtO4Xi5F>
X-ME-Received: <xmr:x8f0ah7aN5zKrBuJq1SAHPC3gTk0Oh5VMy5gCOvjscNCIpNrmeJTL-sMhC4>
X-ME-Proxy-Cause: dmFkZTFk3L7XZlF5+7GH502WRsWRu7U+bYuq0I87emmDHqofs2C6Hcc8RGeJn/UwsU80aQ
    Oy5YxXNQD1BqRn8XJ/GTClKi2hastwCjkmd8COFgy1QD6KTMxDorZdMtO1IFTW2oWK3BBJ
    Ud6J7xk6J7MJa+AvKNYZq7fGtXh5bug13QkkC2bMXnBNPwAyDQLNhRrDDptQimi1nEzMvu
    9TRfS/AYmmmzrrSal/oeqggCJbce/BM6qn3UOoa/Yz8qXU1ssT2aJrhmaxkrlctMFW7YKN
    EQ5KIcWt1jqxB2qOtX0eZbldsKebou1BaF/6/y0uWBSjqp4ov2Z+/g/QHKX3gdUs4JZpIj
    g6gPfA+H5faF09ppkSkY+6L7Hdb/HYFEtGOIq3q3a2KuWgSZNxWsFbeKl3LAByY4oOiqhj
    B34d0BUoUpfreNUO3uAT+MGxdJHWl0K7sQVmYNnCTDeQVmPyoDUZVMiJQ6i4aWEPYcQn83
    4aoSnc69Gxs+HvTBiYEpSV9UWELqBN4R18h9XxAM42kUav2Yxvbjcw8r6oqxnigVcTSvKp
    iwe8mMLREybAHPyDO+qIM9AofTNL3GERFVtc/fdeMjFU8DeesspO1OiSjNOVK2ZOfVCcI7
    Ri1KC/anUqpFspDwXFE5oVAFNgi2wKvWPt3hCw62UxGNakgUKiPteSzR2MCA
X-ME-Proxy: <xmx:x8f0aqmiCdZsxSv--RgHZ2FV6V3kBhg7iVxeEM_XLzdNVot4Pjilgw>
    <xmx:x8f0ajJxUuhB86g3eESVIXZRafN9Ymn-2-BOOKLHI76XRxHDAsOMew>
    <xmx:x8f0arFlD4FqF_vAN_45ugEIfFa7VxHG5tGvFamumUjHZeC7C1PTWw>
    <xmx:x8f0akOS1E5dLyR--vH9rDZ-YRqQN9CG0p5M_bTGLNgD4WBjsSW_iw>
    <xmx:x8f0al-Jiu0Nr7VSnOBMnuyCfJRr4MLTsSY2cQT7qtLl-FcrooCeQXL_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 14:53:42 -0500 (EST)
Date: Wed, 11 Nov 2026 19:53:41 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Tal Zussman <tz2294@columbia.edu>, n3rd <18670333770@163.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "ljs@kernel.org" <ljs@kernel.org>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
	"peterx@redhat.com" <peterx@redhat.com>, "security@kernel.org" <security@kernel.org>
Subject: Re: [SECURITY] mm: khugepaged collapse_file() drops RWP PTE markers
Message-ID: <avTHmQXzWQagnsh5@thinkstation>
References: <606cae9e.bbec5.1a1c54f4f9f.Coremail.18670333770@163.com>
 <60541e98-b1f0-4f92-a155-8a29c0bb17dc@kernel.org>
 <44abb8ef-7711-4ad0-be9f-ca47206892a3@columbia.edu>
 <856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org>
 <60029f5a-091a-4022-ae48-8fb9a00d922c@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60029f5a-091a-4022-ae48-8fb9a00d922c@gmail.com>
X-Stat-Signature: h9at8wzcowhhdamgda6qmh3z1toh9jsf
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9C19980004
X-HE-Tag: 1794426828-791721
X-HE-Meta: U2FsdGVkX1/bfi/Llk5iwoHphrCWMllmTaNIm7+bDc0Qx/mtL6T21wL1qppwRHDCkzd6rUdVGbxMFNSHf/gsX29hciFqjdvHCCt+E52ErcdYC8s1dktXdhyA0+MweJaobEFNn+NIT7My3dsQoOkjKUo7eOwU3utzl+nXkTJh+AYj3gjymz2YQagf0IelvViLPZ51aONE1/XDRrfBonTUxEm8J5uPM2NCL9TkjB2qeWxd68KMOG/CAIfEofpoct3kJxz2SsMZAoc8r9076ZXASMPUatkVU0Kkifef9jzFgo1ACtNQCVa6cdQGYda3wR0wkKtMgLYGWIN46KOUqeVEQwueYNNGA97hp9HmwhGLAoRJpXsUXBMo/uum7AnOih/ZJQ7fX1Qyx6k/DKJmtSIX+Yl6Zf62zfSmTNBg7Lg4S8SqVxYfSihbQgU2MWRVxadH8PGLSsQVM9GCuEJ40y/5TlDCfRGlFxNmfjZCFXpjFn7Enq46XdSWaoiZo5pmE0aKLz1rI81Py5vKURqN1B7fXTDrw02vfzctWLnlArSFsVyzoNi9c9FvdYldkS6HEoR3aRum6wwdFuns9AJ29Xc0jc9AFQph5XzhfFJMuvspP8PlIOrfRK22YD7DvcKPZTR2RpI2jHD1Mjk/Bo+rp25sFCNQFI4QR91oATI1HModxBPZKTXh+CUCYhikufgEpK1I3uit67N03iqLv1QAkq9sXvr0C6g3J0YOT62WI+qnzFJstVy4kfopZfWPHNwDjE6/1hPEw799TyyPESNqMc8345+Ad8JmzaOjF9GG9osyxcrfFeXjNy8A4S0KEX6VzFAh6CXpe1j6IHMgZlOlLVR5TFV3MIZ84sJxKUibxacreitWYxCIriz75TfcYgMqRLyJ3hQlL0ZklMiK4KSmUEUzUZ9gR747FtlO8Zjn809r/6drD7UjPQeOqVUEo9gbejJJsEE7L0W8lKpmEPmEPYI
 2y97DcJ8
 bvDIcMqnpFzhIi4sEj9LcwmCcIfeYv+fj9UKA5QTdwJMkm1s3bY2srnAiT8C42kx/M8ULGD6heH8Unwr+/J3c8bGv0g/yH9lghN/tNuUPwD/je8TFJK+z76VLN0xBMQ/FOaf9py15oKfLNPDQbptP2yZoIO+RSjHQ9cyAKgi9RgjMP/epNAnPJJUcgxOzPXVR9Dcvid9cA2ncEhliCK/67sdp+CXfcCXT10pkc29650zc06M7MIAEkKYLJRuvU1/qsrzH2vlSwoisTsVWDFNr9j+6WWXxRJo2M3ghv4BsT2pem+8bBE12+iLkrAD7Fyu24zEiFu/5lNn0lkq+9ltNvh0w99ez2qg2HbeQLg0djAyHTwYeCRdgm1I5LHY9juoiASWF017I3oSDyvogNO+4FJi1/peMTKgTPA6ZQp46fzwx2XNd12FpkEQpq2vWlFdLv+5AejYeBRfoc+7Z8olnzAmt7Pfx1b1BMdbU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 08:43:47PM +0100, Jose A. Perez de Azpillaga wrote:
> On 11/11/26 8:29 AM, David Hildenbrand (Arm) wrote:
> > On 11/11/26 04:19, Tal Zussman wrote:
> > > On 11/10/26 6:55 AM, David Hildenbrand (Arm) wrote:
> > > > On 11/10/26 12:54, n3rd wrote:
> > > > > 
> > > > > Hello,
> > > > > 
> > > > > I am reporting a security bug in the Linux kernel.
> > > > 
> > > > Stop sending uffd problems as security bugs. STOP IT NOW.
> > > > 
> > > > Tal has a long list of uffd-related fixes he is about to send out. CCing him.
> > > > 
> > > So this issue was originally on my list and I had a fix for it... but it was
> > > REALLY ugly and a band-aid, so I dropped it.
> > 
> > Yeah, RWP is a mess.
> > 
> > > 
> > > I think the real solution is to just add actual markers for RWP and solve
> > > all of these issues at once... but that should be a separate series from my
> > > batch of fixes (which I'll be sending shortly). Is there a reason RWP
> > > markers weren't done in the first place that I'm missing?
> > 
> > Let's ask kiryl: why is it ok to drop RWP PTE bits during swapout, zap, collapse
> > etc?
> > 
> > https://kernel.org/doc/html/latest/admin-guide/mm/userfaultfd.html?utm_source=chatgpt.com
> > 
> > states "Unlike WP (which persists via PTE_MARKER_UFFD_WP), there is no
> > persistent RWP marker today. The user needs to re-arm the range with
> > UFFDIO_RWPROTECT after any operation that explicitly frees PTEs."
> > 
> > But requiring the user to re-arm is rather questionable design if the kernel can
> > just zap these page table entries.
> > 
> > @Jose, maybe you want to look into marker support for RWP to make RWP a bit less
> > horrible?
> 
> oops. I overlooked the thread because of the AI report...
> 
> IMHO (and after reading Kiryl's email), I'd fix the doc instead. "Scope of
> protection" doesn't mention collapse or shmem reclaim, and it still tells
> the user to re-arm.
> 
> I could work on that patch :)

Thanks for volunteering :)

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

