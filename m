Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE1D1606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SEAmzCiQ
Received: by kanga.kvack.org (Postfix)
	id D9E066B05B4; Wed,  4 Nov 2026 13:06:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76216B05B6; Wed,  4 Nov 2026 13:06:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8B8E6B05B8; Wed,  4 Nov 2026 13:06:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A48F46B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:06:33 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2EE441C4160
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:06:33 +0000 (UTC)
X-FDA: 85398216666.10.7A071AC
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5CC8540005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:06:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SEAmzCiQ;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793815591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GRG5s9Ykm6gdotG16z6YfBmoncjsZwUpCfdfDleiz1Q=;
	b=lbvpJNNIWdvzVKKq5PV5uoWtPC9mGjquIXkyM/9W1Vpn4rZvATNOGep9dPQNHAvKhWrQ2e
	5jrwFFoV3/TO5eaAKZI0PFMoXLIXqTg01nisUM0sqiKcMEWITXJs+UV2l2KwumfZIy3gzx
	nnIiZKXx9YIKPe3QtCT8KFPlDBMSDgM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793815591;
	b=ltXQX9MKINmZDp/KVWH++PxpOwXzKQOl3Q9CjLx6Ii9BW/XvemY+cmTeKkKRnS3+QuoaEa
	EeEYhURy2Fkcvz25SjuTTddBOmp/+OECTzkjtOqnEb+n7uE8HykIcBnE0H6vU9nn7Na3AL
	dzL6YXTRzoMRJ3aWqK8CqR/o5PWdpWA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SEAmzCiQ;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cd6a7e1f4e4so472442a12.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 10:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793815590; x=1794420390; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GRG5s9Ykm6gdotG16z6YfBmoncjsZwUpCfdfDleiz1Q=;
        b=SEAmzCiQoIJogWZryyyoyrohrbYfslJDZ9TTqfjLI2e4m+h51stPuPpzq8bmeWpUlf
         IS6CjVGiI4DsWwiYE14g5y+BJnxLvAbZ+6guL6RobBze/zbsxv0DQRVDPiZGzOTZZuWR
         hAjG1YMX5qEol06YoNmxXbItaXr7K14UHW9Tutd40MkGw5WBQNplqPIOgLckxeATtzic
         e7MjsmbJXIF+UXjNRmvQNEwp4gvIaaiTaea/bt+PUeqgoU6xYVPNKXTpjgx6GnitlceC
         IYXApRmOFBbjQoDfIpsK34d5inIQeve7TNOAhEYHbRw1hEFy/elWxxEnvqGLNPucULcc
         OuUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793815590; x=1794420390;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GRG5s9Ykm6gdotG16z6YfBmoncjsZwUpCfdfDleiz1Q=;
        b=yujl4YAIToPkzDP3219pfQVXKykjEkzDldczZotbgYJIApWpcMmQckgObISVtX7nab
         734pHjt7VaqtCaRm+Z1tpqA5yQgVJ6BqfPHdt2wOOeMJllV8Hhndptam6VvDZGirVqPO
         fjDg7+I002hF5scdaQzljh/2hm8lzRknaJ1rHT9L4EexE5JzkKVdxS8ZhtuFJ8OHfL7k
         eTi/4Sl1HnVd3fqmzA9h/f1aUTMqO0UM/lwUt8NbnK0F+LblaZ88nvNT/zRl/aarxVje
         u0C0e5B8Fcj0j9eqwZsYNcEie+sk/srm1OnBn427hU4lpYN/7/4whwODS4+gaEXS/MAf
         qbUA==
X-Forwarded-Encrypted: i=1; AKwUvBwOLrGno3Kbj+MVSevO4UFRrlfygKhqCkRDBNT5HBQlYHkYCMtiDVLc0bidAZ6r+BLjd8JAcFD9Sw==@kvack.org
X-Gm-Message-State: APuU4Z+wztU75rKucsX94OsFCmyXD8daC5/w0N8OT+hFupQttQaq4Cwq
	NTM49Z5EXpjss6iq16uO1wPnU1LSeDPq7rPxg9mYrupkP6DoNPs50H+IqPKcAMCrmg==
X-Gm-Gg: AYBFou1XkltG+vVCVRaxG1A7YjLri756l6BadDTQphRd1JCxyJdMuJAIS5xCOSNiR7R
	pj/2YHSVBdplX0aBi14wv3B4fBScqR4ufT+mKKL3LGRJGdQ9RBS2njACBW8gozE41Lbs14ONL+d
	oaFouznWqQsTQW420lgmCY5loQkx2H9pfiIBTssWvgapPET6KV5lOIBSI5M/1FlDpHwR1S+vE9k
	ff4pZKCzIQVnEsfyT9Qx7AfiubvdVsAEtgo01/4wvZWGqFBpRvomxvrA6ztscvm71dyS1apYq1a
	t5KJhnxUp0ApCEj7V65bW+PZba9/0PMCuI32w+xophH9bx8lfyYfmJHyGv6bjjDTpv5HDzIMD91
	xjkmBtVjSJ7uX4fPmwWizfBPoUrIeElOnKz12uOkjZ9m2rKdix+C7bp+tdgi3rIIhM3ZpcyjWT3
	4JpJ+pbrC/W1F9d6GX7QpY4XgWB9vO7PM0m1oCG6Bg5p1uAiK1LVhss3AntP3iAeJyd+ODr4cc5
	CHvdmzJ0Ow8gqg8yebYGtPRXBZuDDtwhn2pikk3yjiCVBrt8mtFZjNlD3oauLkbZRzlLSfJQg7h
	vq921CgOursLu/E4FJVMDYLzej89MFRv5fuW6pS2uav6PoyZZB/09WwnPbrX8NaE
X-Received: by 2002:a17:90b:180d:b0:3a4:8c41:fab6 with SMTP id 98e67ed59e1d1-3ae8983f058mr13975312a91.46.1793815589132;
        Wed, 04 Nov 2026 10:06:29 -0800 (PST)
Received: from google.com (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb4694a0e0sm1481545a12.20.2026.11.04.10.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:06:27 -0800 (PST)
Date: Wed, 4 Nov 2026 18:06:23 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v10 00/13] PCI: liveupdate: PCI core support for Live
 Update
Message-ID: <aut0H65XKAHUqPR9@google.com>
References: <20261013162529.1928093-1-dmatlack@google.com>
 <autxCZPJ9yiE2ucq@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <autxCZPJ9yiE2ucq@google.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5CC8540005
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 9tuz1h3ekich7mu7jtrboibfato1ir3j
X-Rspam-User: 
X-HE-Tag: 1793815591-897616
X-HE-Meta: U2FsdGVkX19eAVx6F60rhngnMfbP6Zz84PLWnNg01EWH7oUHBl17F4FI7kGj3LeIUztCM3ajycBo5VeBhI5vh6Ag8xI3uzjQZxsAVxhN1ec9PAlhf0nFksx7BkIJy+QYScvkMrs9OQSeulfNsKKyCeTpaSACES07pIVCg+pMxgklCM9rIAgujROHKb1tUOC4eVob5Qb+t09YIFOeKct1aDiEA0h64EoJypf1JWHRcQ2ObkPmnRFQLzv4cggENP4EsXwkqKQ3sykUurZOny+Zhn20Hq1Qe0RyvR8MkuCFIZgDnjYIJOl6zaHSHmaee7ZGWUzMu8ak8ND+ZUYp1FVMbifwddojM1ufJdMVDrnc8h6P4zWD+LeKOH8/u4YPBi28ea9VE4R9WN+LsFDCltqNJhfgEuGN+tOpIC+PWolTwhgElP1SU7MbjP7uD0Bc+rTIiw3S7qWMW9YAyCymCKoA4ivLz+V5JHSZ7Az/DLChkb8gf5CNicNNpWnsCWPqYqk+KczBx9Eo56UrD2EezfQCNVEjBpIDMGl259nHRJnlkX1c1UbjMfSwGF5JpiNqEqJO/DSdeIDRG+3RiRxerIn44jMpH86Tx+D11XOQv3i2L3UMpAyvraqGr2ujeyjtzwZdmd+nV1URPiG3H6Ratt1QWrDW4NNR6Lo+7A/D8z+rIYtFiZmlBTeXLyTYa9R6YN03Qd8iJ3K3iBw1Ku7/0IYJtR3ZcPaVBKmUeX9Zfxbn47SCE8zeZvpTziokM1nPJdzzYFfurQYJUgiX5Rt/YTIfKCoA3Uwn9TmaMONRyIK0jDcef/INosRMtWZJjo4+h7qE3nWgqBcfJkK7WTOP2ApM4kRwUfRn2SzB8Y/Y1Ajkm3oBp9tbI96tusAwgBUEUFUBZ8ldIB9DuGMd8y4qo1x2pKWkQErW8GqKiwuwFBG900SYeSK1/bHegZMs5m0OgMG1SKoIWYjb12NcT+jp04b
 jZQbew++
 1G3WkiZfJOVnxcanGk9ritj/mci0G8gJrrJmp9w8/lu15kZNMaA2pxE2KCKcFpLuK3Tdy97IHWQ2loAPoVF+tvjx3+KEU9UenYcFhBG0ph7x5upRitk/+EWVqOS8jyE9WHd3V4GXWtzpjsE0IH+taNem5IfI20Ml2yL5wctQIcc+ZzLecFPvMkGkLdbRyhqUdeTsI1nsQe9AUcwiQ/MS3A6dl0gHBQpdH2KVKMJ2DA9NttZmF7i1knatrawuLciTKavZ21bpjb2Q1GKLi51t2ubOeGOtsRaEPoCOLZkWWk9i8zQhPU2ZDqimhka4oc8/O2fBLETXGbr9VsFm4hNzK5QHh7g5TpNAZkwnAt2bed91VEj+6NxpxHlaVKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-04 01:00 PM, Pasha Tatashin wrote:
> On 10-13 16:25, David Matlack wrote:
> > v10:
> >  - Save and restore the ACS Egress Control Vector along with the ACS
> >    Control register, sizing the save buffer from the HwInit Egress
> >    Control Vector Size field (Alex) and drop Bjorn's R-b tag
> >  - Make CONFIG_PCI_LIVEUPDATE depend on 64BIT from the first patch
> >    rather than adding the dependency later in the series (Pratyush,
> >    Mike)
> >  - Reword kernel-doc comments to read better in the HTML docs and
> >    spell out "reference count" (Mike)
> >  - Replace the version number at the start of struct pci_ser with
> >    required_flags and optional_flags, and record the size of struct
> >    pci_dev_ser, so that the PCI FLB ABI can be extended (LPC BoF)
> 
> Hi Bjorn,
> 
> I am planning to target this series for the 7.5 merge window through the 
> liveupdate tree, as we previously agreed. However, there are still 6 
> patches that lack an Acked-by from you. I believe you might have 
> reviewed some of them before, but the tags were lost during subsequent 
> refactoring. Could you please take another look at the following to make 
> sure everything is in order for us to merge the series:
> 
> PCI: liveupdate: Set up FLB handler for the PCI core
> PCI: liveupdate: Track incoming preserved PCI devices
> PCI: liveupdate: Document driver binding responsibilities
> PCI: liveupdate: Auto-preserve upstream bridges across Live Update
> PCI: Save and restore the ACS Control register and Egress Control Vector
> PCI: liveupdate: Adopt ACS controls in incoming preserved devices

Thanks Pasha. One more for Bjorn's list:

  [06/13] PCI: liveupdate: Preserve bus numbers during Live Update
          https://lore.kernel.org/linux-pci/20261013162529.1928093-7-dmatlack@google.com/

Bjorn's Reviewed-by on it was dropped in v9 when it changed materially
(albeit based on his feedback).

Alex, could you also take a look at the two ACS patches? 08 includes the
Egress Control Vector save/restore you asked for in v9.

  [08/13] PCI: Save and restore the ACS Control register and Egress Control Vector
          https://lore.kernel.org/linux-pci/20261013162529.1928093-9-dmatlack@google.com/
  [09/13] PCI: liveupdate: Adopt ACS controls in incoming preserved devices
          https://lore.kernel.org/linux-pci/20261013162529.1928093-10-dmatlack@google.com/

