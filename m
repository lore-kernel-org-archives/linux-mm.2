Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35D40C982C4
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371176B009B; Wed, 16 Sep 2026 10:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349866B009D; Wed, 16 Sep 2026 10:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260186B009E; Wed, 16 Sep 2026 10:58:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E079D6B009B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:58:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69D958071F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:58:55 +0000 (UTC)
X-FDA: 85219932630.02.0882E66
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7BED5160004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:58:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KXluu9j8;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789570733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7B8AGM6usS6/DkOynGbVPS6pps2aTMeSLXoc/PLBLeU=;
	b=xhkn3m7rqAQQttaR1FCcatXNsfUCOOSOMxwAw4mKBOJ86ZhxcgXWEuC7Mq4UCA/pMfFko0
	2mLdDY/nBZ1l9lm/3XhKzwlXScEX6xnhjXEmCskePjQ9jJAbyvSWSZj2iZxF8G2gUz+BtQ
	RbW82FRVFwWj3TDhAn5+ToF0bf37y2w=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KXluu9j8;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789570733;
	b=12pm1DbEdd08PnJ4o42Hy4jVPC1rxhSudf8ktncBiga4DGxVJ48xZEA/HZGTjURvuiBcRM
	6mOjl5DLBNsFiSaV/r2SjNopoGYDNNgVh/lkvJhqk3FXrTZ08qeYhmJDDuwOte8dgqCgpm
	xkiWwnun6r4pkqQZlrypEvxHrBgq9j8=
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254fa4c24cso174507966b.2
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:58:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789570732; cv=none;
        d=google.com; s=arc-20260327;
        b=tAphUKywi92zAY1pHKX3MwkpAOhxLKwvnUUgChWbFN54rx+1Sd0kXIZxmBaHcZFldQ
         3lcMpolYn8VeNEYlOrPToIQrR/La1BeU0/CO2ZvE4Qwi9ZMmSwn+snHBw8wJmI3FhnPP
         ZBrswKaB7qKXAT3FT0WN1ukSjZBH2+HWEngN6fr6r0LGKkuNYK6XmwfHcxWwFqtiq5gK
         cfZKRj7KtPMywC/WmqjzCwhUreVHXhdqrn7Xps8KUQS6zVzz19bafpX/HWl4qhO3Beei
         QxjfggQCAuEt4EiNG5Zw/u46Lvts4i7MqLAWfgcj2NvEc8S1ZPmsBwcdlYzscM3frxou
         5lTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7B8AGM6usS6/DkOynGbVPS6pps2aTMeSLXoc/PLBLeU=;
        fh=59zzKI6+dJq+y9sAp7ElfeArojbOJoI3B8xNjvGvyxg=;
        b=owmoLK0zzdW57QVlWnHkuvZKjSIR+3hroBRx1NYde+bDF7H2kJ+XGSbrw3NMKrpAJT
         rrDFlIAAtxrS+JP272FLo/QnFlAbUIbAElF08Rc9JrWf+P2BLlaR4R6fCja5yiN5Ccd0
         vlVynGcdLGM5Z1oRc+Uk+rLH4SXrzqq3C2vZsTir5s7j1aHJujgEvA2DW/peo6s+4fRa
         TR6OZb1FxGckiO85iwjPuCIE/lMomzY/2I2brQQMrE6X+GeXviawiEQTPgWSs9YCDrHG
         /WryXumMG4gwvgT2vmRV8wJxI85iIQPupt0kyRp6+gJt68D4+dJdVGpPUunif8CPSs8s
         xLGg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789570732; x=1790175532; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7B8AGM6usS6/DkOynGbVPS6pps2aTMeSLXoc/PLBLeU=;
        b=KXluu9j8U8x15XwbtQ6wzdkwpgqjQtEZYB8E9S8wkgjPf0cQPxXphU91lURHcmx9+u
         IjGKRotxwwwaNVvCA5h8QWGfKTo4/H6huuB8kZBGjHNK7uAgC4s8pSWUnnIss2xXALXD
         leZQI8LJqwnwf+rHHu3VXJ+DXrAZI661cQDZdYDggL4InEf5HAN613LpbQFdc/EvUwyn
         zbpRIZUboQB9R5qUog834/6yRTuEZsuXMRqXGZITAeKVKbnFMAjAihgfq7J9Ci874FsW
         6lFYCRRlT1fUvUKi4OojwRJg/Fb5Vz0nm9zvzG5/1titogjvU9k3F14368n1tcbTra2b
         /mxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789570732; x=1790175532;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7B8AGM6usS6/DkOynGbVPS6pps2aTMeSLXoc/PLBLeU=;
        b=KCnYehNwXd2euSahsDt5C1PAtPxpHVcB4sfe3BzpRWsKPdopCMtSWrYvmVcBCoYc5p
         TS9dGmvGMLLaQvJabkE1Yu70ZWYKdO23dv26eUDGmcDwx/wz6vozDbePXjdX4RFgGAV4
         R7C/KISD+xjDRcMgRQaQsJL3niOF3A7kb/Ej3JT5IpGTR4jGqFNFGqFZFaxTCl33Bt8X
         /3Be6LQ58N94iHmiqEi/k4nDtyeiZ6V06IM8TFGrFrUkuMIrJjj7QjastNKXlaAFkvKy
         UOL/moiq9KGDgweZuU8sXnBvT/SV7/dWBzFzbbMYTg0iaAkWdFcbhiD4QyZz+bF47arM
         xvhw==
X-Forwarded-Encrypted: i=1; AKwUvBxDN1/CxwljOnd08wTKUrGeJbIUspFiMjWBbXIsFt6oDdoKJPgZxXvS/G67iwMcElbNfX2uXL98eA==@kvack.org
X-Gm-Message-State: AFuF++kWr3ySLIChoVBuqm9ymSFP/MSCDk5zxqf58v25keDlxWfTajgN
	xdJ1Ed6AVVaM5JzA7qGPJ+28betB2W2pIS8tzt5VtDxDXVA6Ee8OWdpsUBeFKm0hzsXfsKcQi75
	q82NgdfMclyOLlBeXYa2lXUGXpr5MOVGBFOVTPq4H
X-Gm-Gg: AYBFou2qcGo4RkGJL8CGRvO0S70fc0bqs6fLzMeHpwvqi/uzfnwX1uQALdNCGV1C9B0
	HIa1OOC9NbQR4nHeDZOieBjfKYUpDqWz5CEWp9XSsa56QN5PStWIijvPPM1+sEl9S2ERroRUSh2
	hdShyoVUw5jQnuVeGtJyYLNB9LxN/5QNk/Y629bvp0EFQDy+tm0qFWXKxPIvvyQsakpW4XvsThZ
	JfclXk/qXd/XLHKiplBZ9L0j+k9cBbz2boaAS9+ZjDBa72g4I3z0ZLWyrMPCdNHKv+VbYbtyXT0
	tBqLOiCjQPhJ+GworecEu1N2NlHjUzTUHVst9fHgZGlxERUN8vnZhzw=
X-Received: by 2002:a17:907:c49a:b0:c28:fb3f:fe20 with SMTP id
 a640c23a62f3a-c29e52c71e0mr199279166b.30.1789570731516; Wed, 16 Sep 2026
 07:58:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com> <20260728221007.2098560-3-dmatlack@google.com>
 <9211b2b6-9fca-4ef7-a141-84636d56e67e@linux.dev>
In-Reply-To: <9211b2b6-9fca-4ef7-a141-84636d56e67e@linux.dev>
From: David Matlack <dmatlack@google.com>
Date: Wed, 16 Sep 2026 07:58:23 -0700
X-Gm-Features: AcwNN1V694h9Klbei55CjXCXrLccfSPzJ9ZF9qWXraB-n35v9TC4KupB_2aeuGo
Message-ID: <CALzav=dJUiZe+Hxck9X+kKVXoRn-Ks2WxV7B5i0RHRFGy7-Mpw@mail.gmail.com>
Subject: Re: [PATCH v8 02/12] PCI: liveupdate: Track outgoing preserved PCI devices
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: xitk59ki4to7sn9dxcnbudnpxkr1zhy8
X-Rspamd-Queue-Id: 7BED5160004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789570733-715672
X-HE-Meta: U2FsdGVkX197o660WZ3oZ81UEK9nrJFyS16wUMOem6OglKdr9EeL2i6oG6PAb09DcSGoz9zk8qxULuNPlPTRUguuz7JKqLlDsswZgdB91noKkNsGH6uOxNwj87n5UlnL7qUZno5Yq7wjgsSHvrDThC8OJDeBUtNZBZfv4TOF5vFD/QaqQIVwOZJ+/GB9qF61cWVgwd4rRZH2LWg6KzFTlQz8LtFAe0QPlOR2KkvZibV56CZ1xHsLP5+An1pms98JYTsT1VHAyzBcNRSrL7oLSj261qAuoPCVA8scB8tvzP1l8yhVSa9SlJIxFo/TODaw67E3mRcfzS2LJsv5GiktoVmqZXCFtri5Mow2Sk5VWHO7DlhiEMkfESfDCOKI53NtmDeG7NrJlfQcbrr1ZZA9ZjykXSNM51S7AzaCnwBuknlQwjA4GXhTV9KQwDX/gtuRbliOvYalt0z8ztGBKE5p9hcpMrUVJyfA2+WpcL8dCY7u9vUdb6EPHd2x5aPuYgUrXBWGZ6WSyKgOcambKdI/alcWgAJroImK2FJobuiIkjLwpdCquqmRERl77hZg/85MfZ+8Qo7dAQQytIe266H4KNXytmi4reFLbNBbVhhY/eezTcmfbDp2TxixJKVf8IHZPwvy+h5FMyH2VhcAOjcr8JQ89s0LheuJV/ZI9IZe0NDBTtCS/1OKZjvgPgvAbVLv0RCldKHlLfCOUEJKI6S7QjYBBV51dTS/cGC4EPRNmMnPTRdHx3V/WZJzzx/1BVNWCDruQXDV/uWsuPI3Cav1oPW/UmVVcWtMZ48DATayTtRhShWotThIZuuz6YCl7Oc9/sNqIWyIV4KCUi3YWkArmDW+2DwbDWXa4JlFu+kFLeuWYP4/fKvZeyYKnQr0uZ6FdXJPvJrQCHNuEbOW+U1wIX3OfsDI5pBfXs3W/SwX0mtpCmnoWPWNHcYaVV3ZnKt21UsPwuB4DjL+6jDRaee
 /fsatmFU
 bGjxJWJH/dwvWC9di55C4mO2voKyU2xSAKOgNmH245+G9Po31Qp2QtgTCXrCI+KCt7ulWaDlE63GvFqGfSDiO6/NBN9PwJIniNo0ETvOW8KZPQjImOQZmquaSexCN1p89d+sBoVhWZCyFtS5GBrQqG9kLG1alq0eV9JUd6EF2ayMLhQxMHisiNoC7UCoR6frwty7NUkLqcxZFu9Q2tv/vMZjOfNGfoHwX2MRzRpWufXwIvls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 8:10=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.dev> w=
rote:
>
> =E5=9C=A8 2026/7/28 15:09, David Matlack =E5=86=99=E9=81=93:
> > Add APIs to allow drivers to notify the PCI core of which devices are
> > being preserved across a Live Update for the next kernel, i.e.
> > "outgoing" devices.
> >
> > Drivers must notify the PCI core when devices are preserved so that the
> > PCI core can update its FLB data (struct pci_ser) and track the list of
> > outgoing devices. pci_liveupdate_preserve() notifies the PCI core that =
a
> > device must be preserved across Live Update. pci_liveupdate_unpreserve(=
)
> > reverses this (cancels the preservation of the device).
>
> Hi David,
>
> I have a question about the pci_liveupdate_preserve() and
> pci_liveupdate_unpreserve() APIs.
>
> Is it supported to call these APIs multiple times for the same PCI
> device? For example, a driver could do:
>
> pci_liveupdate_preserve(pdev) -- > pci_liveupdate_unpreserve(pdev) -- >
> perform some operations -- > pci_liveupdate_preserve(pdev) again, before
> the actual Live Update starts.
>
>  From the implementation, it looks like an unpreserved pci_dev_ser entry
> can be reused, so I wanted to confirm whether this preserve -- >
> unpreserve -- > preserve sequence is an intended and supported usage.

Yes that is a completely supported use-case. A device can be preserved
and unpreserved any number of times up until pci_device_shutdown(),
where the preservation status of the device is frozen (see patch 10).

