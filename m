Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED404CD98C5
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2B76B008A; Tue,  9 Jun 2026 11:35:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3076B008C; Tue,  9 Jun 2026 11:35:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 291816B0092; Tue,  9 Jun 2026 11:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 115BC6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:35:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7DA41C2E8C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:35:08 +0000 (UTC)
X-FDA: 84860772696.03.6E2E1EB
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0373B1A000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:35:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ki1houUI;
	spf=pass (imf19.hostedemail.com: domain of praan@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781019307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UyfvIUyYOvTVt/UpRIulwDCiz4s89QiTYmiwF1UuTbs=;
	b=FtTbkArEU4X5oLYqN0QHV1ShAzb7FLgL+0jf/xSTDUkx8B1OjfmsRg1GqyoZCufotyaVEz
	l0829DGJ09TmcsBDr4HpT6EypVa+FdD5K+9M7PpeUHK7aMlQs9k13yXcUrqSJsoAgjEJlB
	Dw0jE/w9IgO6KTuIEG6kZxa2XRWhayw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ki1houUI;
	spf=pass (imf19.hostedemail.com: domain of praan@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781019307;
	b=vMeZNkeA/2sMn8oZfeHCRtyNSb1nKeXr7szfLqj4etwSmyPvtJdnMjJF8hunneijyAQ+nt
	QiHiEZO3pXxf3MZz8ALDQ8m06QD7WMHgUUV/13jbGXVesWszN3bIgI8LxMAFcZK23D12zw
	iaRbBNlmMpe4jx/G6dhs5iQQpBqmyjE=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2bf2911f93cso448895ad.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 08:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781019306; x=1781624106; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UyfvIUyYOvTVt/UpRIulwDCiz4s89QiTYmiwF1UuTbs=;
        b=Ki1houUI1l6/BCEhu9FLuX2gdZoL1lLH4O5JPEIOUMTyLXzCEOn8k3IjXNbR3hRgBU
         tKZtUo1F/uMCmEk5JubmE04fUUheaPAgOnZ7NtsA4kgro8nauQPKwiiFW24PzFYo3um4
         2GktoK9QbKTPeZn+N5/FWFf47FXiJLavlWVc72voJ7xu7XweMngANZ4G+Iq2BsjSK8Yn
         mh54knw8NG1ksWC6ITgEUoyodB4K0aRjeAtwMJ23qUqGVR8Ws+kayiB+ujsFJRacV7ll
         wCaspQh4kKYFQF6JKrpQC2ieASylBkJB1iUo+cCySx4qukTEqWYzzenOz//OJCsr/jhF
         1u2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781019306; x=1781624106;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UyfvIUyYOvTVt/UpRIulwDCiz4s89QiTYmiwF1UuTbs=;
        b=Gm4wsp8WomvdIWdjtdE+FnVrvpajm7GzTjecd8PcuqM+QHET1w3oDOyrRm+2RiXy78
         f09of6+oTUtxBZgHfjRnfqp4GkDV620bMvUnLqtgGX+N2ThGE6elNizlfl2gW3/AEJvw
         1TVIL4pNeddbrhAmN+1A03Zs30PDHWWXgrFCyimzb9jJ4OhqBiiDJnAKjFBb5uZFgpyZ
         qDvSY/kstUtS8Cx7nFCO6SrGSB2srvqPfyl4o+vngCZfXr80EmUHEZHjT46uqQlcDuPk
         tpoMFNHUQL/57hFh/RcUoj8hbJWvKMarG8EIKxYpFHd+BGdYsG0BQRTO8Lx738xIksiQ
         xuYA==
X-Forwarded-Encrypted: i=1; AFNElJ+2IuX4mwk2cXmNZJWcBqyAxfGgoc7FkiwUe/3pLDycxay6kMMJ6ACNST0QjeRCbjs46Od3E9gLjQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3F8zSVc/TV0il/7J1u9UO3EkD7YnLd+dpNYC5vMRTrmiPC8/1
	9W4aAHTlQ2PC45AVFepbncHR9Yg4wOyKTyBgrXd/cPZpSbRJ+JpaMmGyfCJc2A4FPg==
X-Gm-Gg: Acq92OEytH+yfhYTLAgwxBCk4Gdkm+Sjz3+jI0dju92y+1/iY7klIoSkdOMSwrhLJ4w
	odViWh9O+N+071jaNil4us3ipwOZUM6pGofcxkC0troNaIUxjGCkjjdHEZT7ncUh/5msBGq83dz
	hiGzYdxqIuWgjyubu55ir+9Vgktbaf47TvULrpxMrk9rpO0IMrg2OxvwQb/bFNP/hjCswbPQQpU
	TidYVU4fADiKHtGE5LDG2l8SG+wM6xT5xC92F7vcvuwNlteBtv3MZ5BNP21wFuBkrr8XoYQ/O/V
	pidWuDCEm5tCOmm3Ow/j+x6R76jCgM683gTsPfeK9mbSBKLea4UEHjxQVcltx+9cJWeXMfiQmMN
	GHLCeDiketyiTg9nrgVKPriGFOssAAlYzmBCIqMIbcwOu311LwhPKu883VOvgyGuRRNFUTdx1RF
	7Kcfcdcn2KigUMCtBeyf+vYt4g9anX0pgOP8zKKVabIGb6oeBtw0Pd7e/50DfLVH6ACCoBUmmp+
	mbFDRrn5A==
X-Received: by 2002:a17:902:e885:b0:2bd:7e8e:ad56 with SMTP id d9443c01a7336-2c1eafba702mr7653595ad.6.1781019305283;
        Tue, 09 Jun 2026 08:35:05 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6bf827e6sm24737580a91.1.2026.06.09.08.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:35:04 -0700 (PDT)
Date: Tue, 9 Jun 2026 15:34:55 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 08/12] PCI: liveupdate: Inherit ACS flags in incoming
 preserved devices
Message-ID: <aigyn66-xQ_9JBW6@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-9-dmatlack@google.com>
 <aiXWmR-ettxin4LC@google.com>
 <aiaeOVomxQZhoM3K@google.com>
 <20260608181640.GO1962447@nvidia.com>
 <aigtS3UDdhUGp3m0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aigtS3UDdhUGp3m0@google.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0373B1A000A
X-Stat-Signature: ge6gs1rmsp79axgnh4miqawo7r7uhdhu
X-Rspam-User: 
X-HE-Tag: 1781019306-378381
X-HE-Meta: U2FsdGVkX18TKHx2S+GTNH6yqfiZ7MryG1AhGISUwRYbPyq4E77eSWqcmKVtJbYRJeQJUOYdEWjzMHW26UL8yICF4a4ona9GagPn+tcpGJhVh3SyMAkPHTeSBaaudJeY31Yzd/NhvIsd84aChSdTJC36ReU1OpMa4pj5uARD27HcuCieGsZL70RK6w1lN34qxsweOVIewb9eA9SsFrHpEvsdZhl9MPFbTgTAbmo1Mo4o2/QA86p9MTW3kJR66BNgCMzKSoPoYOJdsDrqeRV+nFfQR8sKbQSD6dUI/aLL82q0a3eAS2Rd1qJrturTYOyMGI7zM/FQ8kB+DfqnVXzE+qbPe8d34DSJ7C5j9KlCIcbj9OvpfzVTdrZGQAbmsQtZtiCc+3zjOkRc1/RxYpQ1W1dZ8A9nTla1AsjAMMsh+8BKFN3PSg3LrmyC9uHCocUA0+KTR8wmqRUt68TBn7F76ZRWK5kUyCsbZd9U8DdpWZ7tQIdqj7y6/z9FW0pIj6GtHFP+FyYcdwJ395tDkqvEAZ0fKoBDARYDELmSAh8NItGWGpd2/2RFvWu7Ek/h09wv6LjPfSr0uRvLpIhzLeWvv0pQnE+xlv1HcxZVFYnX30nn2JoPMyc0Xs5xpaHZqFnFYpWeAVQeUDUQPAUtf8trwneZ4fOMQVPG0eEyPDStNzZr9g4rVcmNjgNgsvDOAd8Z8cVzjBfzvFmIv43SlqeGVVcVC9lbjeaYCXCvly+WQ7hv9GMMSSuvV/G1Ycrfwg7Nf9jMKnomZPpva40F8VH9ymcfyW8Lc3QoL3RmGii4irCCoZXE8tlmYqWfhU8uNGClBONshP80EpcRaDP5js9WmR6EvkBM4pXI3jOe2RFLSv0YMOMS27d4k3VyzQtXeoZE0ew02AM8siMZoropZlFj/gjx+zaYmw5CFJlsUtuSRGx/MAv07dSajKcT2iqx9JuQ0bXRzxJY7yRPeO5hWkE
 pFQzjYXx
 7T3TLpIod1xwg5TOeWlKvqu5khL9NndoghOugLFEPghGMlquYqG0H83fhVMYDLLOFD69jMXybyCwDUxCzfe22iFvvImdopyzjYvdTv1d5S2wUOHS6PS4XrHSBUPuw98L/LFtbk0eOcKIFIzrAPgc2VRycs5ANZ+/SE+I3V2NcF/DNuXlYmOOZn6+n/P3p224I3qPtgyAw616p3KDzOKDTk+70tsEKduIIany2QFFJ9wsdiClGs0SFA2Diqi/NQ36kJcQuM26WFgV7dfaHbpptAtPVTo/rRtrQmDZJwTiSUeTfMdYhBSlPUfBwZTJIKGlA7kLx/CybTWy31Suod+Q06xPhVQQu8BMK7uzBEArjJS8TVCg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 03:12:11PM +0000, Pranjal Shrivastava wrote:
> On Mon, Jun 08, 2026 at 03:16:40PM -0300, Jason Gunthorpe wrote:
> > On Mon, Jun 08, 2026 at 10:49:29AM +0000, Pranjal Shrivastava wrote:
> > 
> > > My point was that a FW exploit can meddle with the bitfields of the
> > > ACS_CTRL to spoof and mis-report the ACS flags.
> > 
> > Devices can also ignore the ACS flags. I don't think this is an area
> > where we should be worrying about devices being actively hostile.
> 
> I'm wondering what happens if we preserve IOMMU groups across a kexec,
> but a switch's ACS capability is dropped or the ACS_RR bit gets cleared?
> The incoming kernel assumes that it's the same ACS cap from the old one
> 
> Now, the incoming kernel restores the groups assuming they're still 
> isolated, but the hardware no longer enforces it, silently allowing DMAs
> & breaking isolation? 

Again, to clarify, I'm aware that we aren't preserving IOMMU groups,
the incoming kernel has to rebuild the groups. My concern is that if the 
ACS_RR bit is cleared during the kexec window, the produced grouping would
be different than the old kernel. What happens if two devices on the
same bridge were assigned to 2 different VMs?

Thanks,
Praan

