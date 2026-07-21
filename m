Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2951DC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 23:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3DB6B007B; Tue, 21 Jul 2026 19:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84906B008A; Tue, 21 Jul 2026 19:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75E36B008C; Tue, 21 Jul 2026 19:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76E456B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:03:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 024131C0359
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:02:59 +0000 (UTC)
X-FDA: 85014310920.06.C9F9C56
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1BA4A140012
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:02:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l5ZWZK0a;
	spf=pass (imf26.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784674978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kK8bQTGCWBVYNgO28KRycMBgomSj7cEEqhXHP2aOvCg=;
	b=hRxyNcVNrwHMZ1jJqD1NNAaGrzUo4HvsDY0vyi4wAp3+Wa6V5UFze/N+x7W7pHEdJugN9Q
	l5LFrO0WTLrzPItNbtFrn+ZUfL+ilTpIPABX9gFDf43Hl7w27+T2JwpB1Y1sBokOeldr1R
	4u8DJ0IG6XMa5iWvwFfO4RcQ86s/97I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l5ZWZK0a;
	spf=pass (imf26.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784674978;
	b=GTOugB1U7eNAYIRA03i27LHyNbs3YdPgg21lzGu+KASkSL0d9VFZO9UUjcMXV13JNTQK5N
	7Sb09q+hecs9Qr6aig6WugjZ3yQwnTjLFHjrw5MpkYw/Pi//md8NrbB4ycvN038YmTKhDj
	04ZsfNAMcNEK29ED8ZkQg/2vm8MB1N4=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ccdf36f63dso604495ad.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784674977; x=1785279777; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kK8bQTGCWBVYNgO28KRycMBgomSj7cEEqhXHP2aOvCg=;
        b=l5ZWZK0aZZpzhyqff0tHxfF1BLjNzuvcX7l0dbI3AGfNEn+Fj/sjIGKAqoWdDs7OPL
         cb9xSKAocS6zPqUuCiGh9idY06MbU35u1JfxvX0yeGmRCnweraEUmi/JMmhQTDEtb95x
         GiQo3QJNz8gxgAXtJcv1Iq61UFp4Rit0iGRMRpgT/L5ikAuhNC2VptOXtlAf0Bp7aQDE
         sBEogKeO6Txfb3E+YtlEP6p+JGt8Fr/ltNKipYTIb879ddrB4kXZKBmWkP3MRpPApgCD
         QZnq4LzHztPDwV4BDDlt9lxFcsrbTUZKCm3Z1RsSrHX4WZy4iQRBQYjdo7vgWWsTSv49
         0UZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784674977; x=1785279777;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kK8bQTGCWBVYNgO28KRycMBgomSj7cEEqhXHP2aOvCg=;
        b=KGWj4qurgOcW39AfBQl6WgATEGZWfPyB+EOLusS9fijxXWfjH5/DFuEWpRnY9b5r7o
         VW90SN6DQ5wIrZqmOINT2HQr0K6G6x4TTTVaWq7/qUmjP+MJE3mWAfQY1BHvIw5f9MGE
         YGT+8PeGKPVJEF0GO+C+cbhl9fridwrbB3M5L/7jPFvs+LYsJJvmu/vj1iFsGZCu8LnU
         3r0jhh41Kp7TcKNQYq0DQPCJJ/ZE/Hj9htXIj97Nrz6gHj0Nv0VitqFK9wX4hQVP5kio
         FNRcPI0lBdeKcLv0ZWzhURftUdydDBWVIcqaalQg0sOmG/q3COhIgFeATdzbaJzGKfyj
         vBYg==
X-Forwarded-Encrypted: i=1; AHgh+Rqz69O1N3nm2/nJeGuZ8bmXokHBoqlhLa7UPRfKfnzM1+PEfA/7MswESAik6ShKx++fbwq3OWKBag==@kvack.org
X-Gm-Message-State: AOJu0YxG+n+YQZy8a9mZQP/a4ELx9YEdsPiAZc/kjFrcPz7x4Lqd+UAy
	ICovdhnn5WT5RNZIEyyMgLYOG8z9iNIzIgUoT3mB4x1HZ9O+VhE6dGUmwTGRauJ68w==
X-Gm-Gg: AR+sD10+qXjn0vPcZvv6HLFbs3BddbyeTVEo9pDmganOl/5Yf+L61ZQJrjpyzKBoPND
	mtH1fcbmX0KvkRkdAATNyLGzWWkYGKdauCnq/Y7Fp+Q2v6u+/gtz4qYa0PNvaGXSrGF/kCD64n3
	B0WqLgGH0QL4ksYit1LFn/ZmPYNRjOWdBuLZPx67dsxeccunyCqgJGaCi1HCnDt/NARWlrWdqhy
	mtlSwbJP692UvIfucktokAhBPQtRm+tyZc1hdutTKpNjLNh0NJhPoD8wVW7AxuQVwtzJBBPaMru
	ocVPmH4+mORVYzPJoYD/U2e0lB/OPEQgNwnl2fWPdTAO0C3eXXni+/Z//SpCPB01bqS5O586cH0
	2NVnsr1s/3nPxHNf6eW9vHXHv5iOjKjThy7aVd16z05V+U+N8inWAIYTXIvvqQ8ILe3fj1TElM2
	na2fEEtS2UvAeIwt0Hmyn3y6VSToY8givMi8PJaLwlQtyTCcuvfq40QWU3UoVS+63cMOiJgy4c
X-Received: by 2002:a17:903:2409:b0:2c7:9e6a:1a8d with SMTP id d9443c01a7336-2cf8f3c3e69mr1002465ad.12.1784674976345;
        Tue, 21 Jul 2026 16:02:56 -0700 (PDT)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f18bb8dsm207669a12.19.2026.07.21.16.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 16:02:55 -0700 (PDT)
Date: Tue, 21 Jul 2026 23:02:52 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v7 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
Message-ID: <al_3nOssZoa6RoCq@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-4-dmatlack@google.com>
 <178432481253.189683.3297727348836286619.b4-review@b4>
 <CALzav=e1Gcu-9TD7F--41cYqKBrStKOE4VqQ4K3PKdNuYnNmcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=e1Gcu-9TD7F--41cYqKBrStKOE4VqQ4K3PKdNuYnNmcQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1BA4A140012
X-Stat-Signature: jxh46d4hjh9xnaduitkbrnkciggs541k
X-HE-Tag: 1784674977-732633
X-HE-Meta: U2FsdGVkX18wyJM/UMbf+hjAROstPt0oPuaoiE2M5wUeOfcyfpmI1/O28ubJwVb/GkgklV6wgm9CABCuCbeJ+mhEkxAT2baFr+76dNLsbPN3i1r3HYTgO/3UOGLPWkZSD3zE4bgt/RfEuCa6DGa+NeVqxleyF5OIpE7GHsZgjwDH2g+lymyhiz1J21LD12MNl3HkvLTGbhYM9PJJdCrzmkwe1kI0fKQEzYE8bQS3/m3s3Oxcs5pbrn8/KcvJDZHDPWgo5V+MOJdkISyXIoaWwfoc373V0dmVlQnb2ZwtSQhJ+YMZViB6IgvjXg/i2fy5Ab3CTiSOICCnL1Ta3CZ8QiCu+DVa1FeKIXc1oltRlRerc0XV0lMSF28m1Zl8eLPaEZEOMrHWpdhAE4PH75A6hFXLXSV4tzjnG++jx3ab8r8oSRqcLdKXG5UMvpYqjdrJB1U4cSSCjclgpqv4Zy6ybM2AuR7g0cJM2jOPdkmxUAXy68gPZ7mpmKlpKRUFMbtRY71fXZ+rsCjm0Y8y18yGBf6cHR/5RsYZYDOuI6QkDGYnrpwi49nRxRwpwdW61yLKPB8EtPb9wm3XGvor0hq6OpM/h6ZQac1Gy9ce010usmCJAlI9C8wivelzAQI/LO458n+ZwTAu6AQ74lKQJn9RTgdGTgia14Eexvl6famhG2WWz9gVi8OxXUQcBzEAZ5P46QTU13ynUxje3hDEgxmAPHD8AM95SRkrQ1Unjax9DQZK+gGxLJYyrwFawBtU++fxoKJt/SXcLa+Niu/wTHSkLzw2dKDiedYHCzGzuk/qmICXH7wffTRTLwxL70MLNK1Vd11jllWoMz4TrOull99B6BTskXT6h/vb8wwQlsEQMarFqV8pFh33NA5unvyGx2KXPoKw85BqLFSDunyO8o4ixY74HPbDipAI+/94TeXKgT80LgsBTl/L+b9BJDaeArTU4XCQ04/FoOMNb+0+Ooz
 EVZAIdD8
 ydEvznYQEN27VJJw8xUIZwA4O73q2vRFBrXN+rmmMOmyGsf3yxttGtYNSbocZ6GTwfN9AD+cl/2JKYmufV+151tDEvFpY13HI9kfllf6rBEiY2lDNa1jjsDbGHyr5pGrFocWfGweuIZLWyXlZ1q8PRcsNob8BimtuxfSz3qdxzm3Wtl3KP8XO2BNbdbxH5QoXvAk1ziD+bfAc7kC92xbMYm5DL4TxYwouzc4gcksAue3OBdWI7UK1UlkWn5K/UOmiR6P4WPMCCOsFR7dwkjnD1NqYoc0l36Rf18Uq+8N3xqE/WB9EkcA/MupPBQbMl3fhdAdMB3hhJv+F0JiJhjSWUqcY+Jr5nxbDwU7fTyeCuCbc+fehlthJsCPH1YAbXObKWukktNe8K7QcDf8T6iELxZ1AVa84HlKdjGFyHnAiEPqcHhu/zSUfA29UWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 02:54:51PM -0700, David Matlack wrote:
>On Fri, Jul 17, 2026 at 2:47 PM Pasha Tatashin
><pasha.tatashin@soleen.com> wrote:
>>
>> On Fri, 10 Jul 2026 21:26:06 +0000, David Matlack <dmatlack@google.com> wrote:
>> > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
>> > index 03075ce06ac9..df6a02240aa4 100644
>> > --- a/drivers/pci/liveupdate.c
>> > +++ b/drivers/pci/liveupdate.c
>> > @@ -298,6 +377,87 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
>> > [ ... skip 76 lines ... ]
>> > +     /*
>> > +      * Hold the ref on the incoming FLB until pci_liveupdate_finish() so
>> > +      * that dev->liveupdate.incoming cannot get freed while the PCI core
>> > +      * has a pointer to it. It's better to leak the incoming FLB than do a
>> > +      * use-after-free if driver does not call pci_liveupdate_finish().
>> > +      */
>>
>> I am confused by this. Each preserved PCI device must have an associated
>> FD preserved with it via LUO. I.e., vfiofd would need to be preserved. If
>> the vfiofd was not reclaimed, and finish is not possible, that vfiofd
>> would still be owned by LUO, and therefore PCI FLB refcount would stay
>> positive.
>>
>> However, if finish is possible, and this is the last vfiofd that is
>> finished, FLB will be freed as soon as the reference count reaches zero,
>> which I would think is the expected behavior.
>>
>> What is the point of holding a reference here, instead of only for the
>> duration of FLB access, i.e. to make sure we are accessing a valid data?
>
>The duration of the access is from here until pci_liveupdate_finish()
>because that it when the pointer (dev->liveupdate.incoming) is
>cleared. So that is why the PCI core holds the reference from here
>until pci_liveupdate_finish().

I think LUO gives you guarantee that this pointer remains valid until
the FLB finish(), because all the vfiofd that were preserved have not
finished. And when all vfiofd have finished, LUO lets you know that the
pointer is becoming invalid so you can unset these in the finish()
callback from LUO?

If I understand this correctly, I think by keeping long references until
finish you are replicating the vfiofd bound lifecycle that LUO already
gives you.
>
>We could avoid this by deleteing dev->liveupdate.incoming and,
>instead, fetching the incoming FLB and doing the xarray lookup every
>atime the PCI core needs to access the device's incoming ser struct,
>but that would be inefficient.

Sami

