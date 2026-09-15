Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6203CC88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 17:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4356B0096; Tue, 15 Sep 2026 13:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CFE6B0098; Tue, 15 Sep 2026 13:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CA756B0099; Tue, 15 Sep 2026 13:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 337576B0096
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:18:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BAEC4804E0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:18:26 +0000 (UTC)
X-FDA: 85216655412.12.0680271
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id E53B34000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:18:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZEW4tcYq;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 74.125.227.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789492705;
	b=JymcB+YhoxYJsh1YWMVAN+u9TiehdDqUhLxW/p6EOjwkPaOTNUdz+c7BcUMlCdMp2ZAVGP
	+9So8GVdRcPfGMPrFWNQIgs1T7l8n2+rSvetX7uhRjmSXzj4WYFMw9hDuUuXjbawfoHG+P
	3cgsy3pMnF4wirAmBb1I4baQPB6Xhio=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZEW4tcYq;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 74.125.227.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789492705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uS2ss2dRiKmKR68mKWZI7ZnqjRyXAQoUa35bmbT36M4=;
	b=hAnTT0qjA/kEOdPcxAS17eSjzXowys/xP+M8yhhgFLTr3fbsVfaRB3Qv4VtxmEvG3duhE2
	uQC15uIc7etIagpI5PkDyi5GhK4sCXG41lGMouWVh5AbykBkrbseFn4ZYA8hPJJl5lU1nN
	K1idhQhCV7z9PUYz8dmrodvNBuenIDk=
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2d90ba1d807so158825ad.3
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789492704; x=1790097504; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uS2ss2dRiKmKR68mKWZI7ZnqjRyXAQoUa35bmbT36M4=;
        b=ZEW4tcYqTzfVzmNPGa/afRmeyqmjD9OWWk1uPHw6N0ZP9R5B6Hso3lFlDI7369/GBw
         mvvVxXour1O/Te5B34Su4Sdh5+Pk9AQ59pCeZ0DbPgl0pTycC0dmZtEPVCuOK2X5xrtW
         RC6auWtYR839VInOkS+Vuu92UAi7wDXO3+cV8QrUzzMKHdcysvGmSewmjQWcOW35bZRD
         HVhYiobB3ScAdxon2Xv92JPPXcmTLWmplSl86LR8Q/F2qU6ifyrqv+jOiU2jiSxKCwGk
         3Ct661dRkhVl8GT5+Qk1KP6zJsQ2HCJr5dv/L/TzgxqQ/eu6ZnBusMBbwqOJvKE26uoP
         MR6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789492704; x=1790097504;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uS2ss2dRiKmKR68mKWZI7ZnqjRyXAQoUa35bmbT36M4=;
        b=cl1jQutaGBrZq9U2aSCcuXNdAaSV6G4o15/gbDB+tM8vzs57Fca2qJjt3+TiZYTRIK
         MspffeE6TAskpfZ6oFDRMQfZsZaYUeahHW0Rn4Ipwvy2PnDoy8qZt/XusJrqXnn8vD/o
         Y1nHtVSZSh/kGPYgL7Gp/jtp3ovsCNYqt0NVy4yuBQL6RjXOgvafujshcP73mutUX4Wc
         8U4k7iAjVdbTK7kzkmN/Ag+7FkuPd4r6RizPv0bF39v6fxYbSY4cbFNqvji4YQ0eztAu
         PvVtqzowZFUJ6kSP4Jsx8zDOOEDMIjbGnzKS+ESDnrAnCfE45jlBVj717+GErJdDikXc
         XvDA==
X-Gm-Message-State: AFuF++l/RqwX27SaXrW8eqQEF2Jv2opeGVBUZxRpLokEsISXTvIg0VnZ
	Bm+iRkoHzwcpw+fahAuWbwnx3PJbAEn2xHhXcMetndMOtfkZaLMA+Sr+9b5m5I71X1dzHknM+wv
	r6Rd5
X-Gm-Gg: AYBFou0nesiuQTGA8TDmV/MMRwB0yoz34v2MWHNL/B8Ko6MR9i+d4wP1zhxf1pPHuhB
	gb0CK0pQbgS8wwyB4TRnB7jqhN+wkbbeopFFKRq77JkEwuFECaauWChokdl0VUPpDzNLl1SecPE
	12ig7nSxsetfNdfHr4Tx5yGQXax/h6g8x0xkZduTL5hJZ+3COW+8tj3IexXx6kjffgKCy6Xf5pU
	JRD3g8/iCjNobfQADRcZ0aCfjDO5LbI+w5jdV5Vu75+aoqt7+IHpb84O9AafVQxV9h/1ePj9Rpp
	ru2ObA/PLdTW8q8llbGK7sofVdni2GGgHtnG7lCKKusZr0yHBTAPaAKNC5FBSrkbCMDPDgSYpjh
	0f7QEFbhbtinYcQHBRxcEgsA2kBWQ2WWAkG1+nTQKhIiKv8FW2/LoHNb/ULxEx+dxHBK7Y61Br0
	6w9oucTltbrEiMHIExRYAdXopuP/VdtZHq6BhAQ3KMLEk1inTdsx3EwVBK3/z3M+bSCEAQo9vdA
	oNIXZmCj12EBRo76mmsHWrBpZEXpxH1gE2UrK3PeN/96Ht/JL3kYpk=
X-Received: by 2002:a05:622a:8c0a:b0:531:d7d:64ea with SMTP id d75a77b69052e-5310d7d657fmr98074341cf.26.1789492325495;
        Tue, 15 Sep 2026 10:12:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530ce4ec298sm136165741cf.16.2026.09.15.10.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 10:12:05 -0700 (PDT)
Date: Tue, 15 Sep 2026 13:12:03 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, wangjiexun@tinylab.org, sashiko-bot <sashiko-bot@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aql65IhMobL5Al9B@gourry-fedora-PF4VCD3F>
References: <20260912110832.3203902-1-gourry@gourry.net>
 <aqloB0zm3RjJ47m1@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqloB0zm3RjJ47m1@gremlin>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E53B34000C
X-Rspam-User: 
X-Stat-Signature: uud351uutwocd3d6pcx3owjrmudpzo73
X-HE-Tag: 1789492704-710158
X-HE-Meta: U2FsdGVkX18UfpZov9327xSvkPaMDvFMLVs2V/I7JYgczi+2FP3svFWVJYHFMY1QeTeDa50w9aDOyDPz/Dk6ddhkg9k7DTGGZs3kGBUtrmh7slC8OMBGFd2LoLisUloHeNLjic3XXG4iNGG8p4cgEEerHbggiqMcfY17gczrRcGpsb5ononwdF5qvG6IkFnaJGRFWy7tfOhyUkaHJImDmm0g5+bdcCCXa1iK4cca5NDbQ1zCvl3GcevHMl3XbvQQtBgy+Lr0XOfnbrdK8AZaLj8c4caG9hMCdmsUbj8Guj0VYpor5X4l2Izp3odYohaHrb1FtgaSYW1wHEf7uTBU1ZT4+jsW0h+FPn27TTWwjpmvpTWhhHkQVcJw1v+AlOABuLC9Daz22X1jocqdcGLgPJmbTyk/zdjgFWXO7l9BF5Z2XwTtavXfzZbbsMEr7Nc1r+bQmEABAKi6WxsbU270QGOeQ8oby36JH+DG8IV3JydQDp1t1huJbom1Rg83RI8beaooXdnavHRRCsuOoGreJpcs0D6MkpJeSd8My5l34JWWdl9/nR6F5qCJGf3gVS6LqLWxAocUOEW3zimfaRJFAAxfmTLy57OWiBRDy9x/dm+WOVpXz493U1Wnkg0x10Nvcwguz9tEMtjgkGUVe5aWtX5IGGA3Iit8Chb53uiskG1iOvifDSLF46ioGMBqdjJttRjzztcHSZyOPK7NJn+w5rcB/MZsOFe2vA7F5g9wkoKG1ofr7w7yStw5k10xbyinDqfgf4nGfX/z1/8oSyqDOEJoNvQXRQGA4NAPThJ4wFF7zhVXc/mF3L/hMzuyH4B0glV34ot9yjVKSwIikYZ6Yij1dSax68n7/5AsKMdv8d+pr4srA2ixZPfJBJQmzMF2qor4T5fVp6GTtwAudiJr1KlDXXFkkmJxJPIO0Vm/dmw1MBpujeUuJmxb7bjRlWZPE3OWkwOOkbMXAvgnEfX
 avO1iJRT
 Hu+bu7oCeULOBUQCxzk8CzVJ53y7k7385xL8/2iLwoO3Y9eXdX9/iqkfEktwolBz5bf7209/LC1QUt9S2a9YCvPNiySI5tctJ1OWf5x++TxWjCk5PV+pQ1yecR7GlxZ0h6tr/4GFZrNMoj1Hsok1jpqpBEBen2n88p1JWxolPPMZ3YDgDO+un7Gi9/2RVWaQRQBz6TttpEytJIvmVCGwzKiTfAirDAEvbRGn/ugGsQbJxYu//yke4LTT7wvckZ0AZsGlovDKmMQQ5aqxf9UOMIEx5IkaMsZ2+/nUES2zGAOldqI06lpNfjvVTGRNPfl8UGdYAYWucGIV3pTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 04:55:47PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Sat, Sep 12, 2026 at 07:08:32AM -0400, Gregory Price wrote:
> > MADV_PAGEOUT collects isolated folios on a local list before reclaiming
> > them after the PTE walk.  The reschedule path drops the PTE lock and then
> > restarts the mapping with pte_offset_map_lock().
> 
> Is this reschedule path even necessary? It's pretty bloody sketchy.
> 
> I thought the modern approach (TM) was to not do cond_resched() and friends so
> can we actually look at removing this?
> 

Sorry - meant to reply to this.

Honestly there's so much jammed into this function i can't give you a
straight answer. I can take a short detour to figure out if we can
rework this as a whole.

~Gregory

