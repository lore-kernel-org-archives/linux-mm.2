Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17042106FD62
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FF126B0005; Thu, 12 Mar 2026 20:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AC646B0088; Thu, 12 Mar 2026 20:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363CD6B008A; Thu, 12 Mar 2026 20:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2558F6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:34:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4ADC140504
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:34:07 +0000 (UTC)
X-FDA: 84539167734.12.925CFB5
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9E4FA160006
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:34:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GO6BtZt4;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnJL3Iw0wwI9nfGsL4UNGadpWjx4M7Li4XWaHu9e8Ms=;
	b=VIO7D8agwCr5smORmE47nri3j3JuZef2CY46oS9niRcea9RYwBdtA67FzRSxYwF+1uzPc1
	Dab3gvWJwzeaOoGYJ7zw8bp9lqpnYGaZnwxibt67SQ9N2i0ywfwXgWzE7Kpq9RlBq3LkC1
	1KeVXwyAAlDxYZu8iY0YXO9/akGIxf4=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GO6BtZt4;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773362045; a=rsa-sha256;
	cv=pass;
	b=ZyVLolK0xXBu8wl6Lr6oBX0MI3HPEnT4jHbi7yA3S3jNGeaRVvtovEt9zk2pn6fQn6t5pg
	gVsUF/d0Kyx2TTomfbpzmy0ZUHX6lHuz8ybvoID6gOuQ87BX9IzqTKTdRKA844T0DvNI4q
	O/dpsTkSuO7cnOM+q2Kpk7L9fAsj22M=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-662dc987dfdso2523248a12.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:34:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773362044; cv=none;
        d=google.com; s=arc-20240605;
        b=TpBrCUUoBNn1QSaSRys7SP9pxWnQWOh0ScX7c5+aPakBeS4doidzQ7Clq7aJtTRdSs
         EFjCKJa3ReWAArLUQk+mkJB1aqnwFbt30RFyCtmePmvkGVrllQoouDIgKmV5Dzq+rgDV
         b9Y2LR3T1XgNSgyY4T5khhrBd9U6jeGVF7piCLN5ZW1vCy2mykQ4knyIBqpDW3Iz1Y29
         RMEUqfRlgDMWe3w0L7ZbfyUYr1V9jVTG3Cn8rdG6rG61R6Hnv48Dz8+IA7Etnuh/Qp8i
         2LjhFFnCKYRzKiHGb96orC2tzP0p9dzNJ+ZqjnlOiYFObxZkgaknbeDib1f7BukZxp53
         0zeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pnJL3Iw0wwI9nfGsL4UNGadpWjx4M7Li4XWaHu9e8Ms=;
        fh=1H+gMM1tTb9F8q1IDRy91OC4arFynjmya6qpX4HpWtQ=;
        b=KhMqO0K4tBkHgiM8cIL1cQKxXdKtLw84fxwFnc4ItBEu3i3QunJ5Y4fgsp9ZRuw0y9
         1Yi49swvgg1AEgptmP1A4zjizB3WUBEyARaMUgwpGhA/3pDY+3l4Ysj8VfiJt2o2Cd40
         vyjrnfJPqMLxmg37wgvoFodzhIfqqobOS+uvB035sG1yLZGBKfEFPWMgmEqF/jeIhq5A
         Xuo170AYtrIht7F/791WXKEZvJQ2bYd695zLoRfcuovCebTf3EFtUQ8/iUmQqjivH9CI
         CtyIYhh6Ss8pzBjDSUt4M1zr+YXA7rwqbSX3/5crcO5JkbFh8UXfsvfERB8ehahEzXo3
         leMQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773362044; x=1773966844; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pnJL3Iw0wwI9nfGsL4UNGadpWjx4M7Li4XWaHu9e8Ms=;
        b=GO6BtZt4DmP+u2vZNbIOi3DKgtKeIpi0rsE5YG9fwtEXM6GOD0eJp8To8NqtI+UdB1
         RPWoNn7rN+ZcMry4gfXCWzjxL6T3SdGaeBLKqctE9lnMdUFCQ2ewqtMb2tL0JJHsEbaP
         f211FPDzl8Fa3pl9ssFPxn7muZ3lx1JFxuN4Z4DksNoFtDyGZpsKPYbeUEZSoEOOqhcO
         O+2bVFI+RKItdqsIoRtZwl3C+mkulmxSR1D7tcAqrMQvM7EeN86VxbPFl8UaHulSSibD
         yzp8jkVoVQGJdnKlx73wZcLDtTr/OJiePJQunNLRi6wpwxWQsgSzyoCrKDOB0zlIJPw+
         iiOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773362044; x=1773966844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pnJL3Iw0wwI9nfGsL4UNGadpWjx4M7Li4XWaHu9e8Ms=;
        b=g3CMxO+y+/ON2GOOShF+Hd+ve6zpVPVQwZMixS1Aw09QqSvr9KnGEnl9oKDikTlIih
         yp3P07LNhGnY51irHr4zT1vVy5eBSxgWgcI018Rbwy2HJckPVySl4V6ooNV5vShS9REC
         5BXYDDPEONySgs4EE8zuUXhGmr3EGYBt1VsM7f6kiziabRVl9iQ3yDFsGM5kaYZgxrLI
         u2anQuiojU2t8oxcU+BvjuIXtmpt2VZrRim99bgMXDv0gLNtHAj+GjJELX5ybUO0KFbC
         +09kbCIg2U34j2pM80HPpY9/P+bOy+/lSjVzbJMF/cgjB7JFaY8gT7N2T6jorG21ctKj
         RSVA==
X-Forwarded-Encrypted: i=1; AJvYcCUzW+V+JKuIgb7z79gZ9EEA8EZMzr1FgUE0zVUHfGD/BuJuc78KdVPBtnzne5UONmBt+dGIhgXcQw==@kvack.org
X-Gm-Message-State: AOJu0YzIrQzsX4u5ZvW+1iYKcDcgnHVkKcJz2yra8Rq90tvGHrRS4OX2
	Jx6YlxuMfvXz9x0UoPk7Jzz8XjGfrS3qwB/2oep6OBIhB1cA4INWj2hl/N5mnGeGBa2Pyvg47hy
	uZZBOKwwDjzhKTA44yGn5zbPNvsx+zaHLrSj2qeCxcg==
X-Gm-Gg: ATEYQzwEKbuMpZp0XI7UfAc0e1IA1iRe+wSgyHU9ZadUrMFiDe2ebMst233286Hp3sv
	Lg/+4gV7D423zeDyfQP0qKHPJQqbJ7i6QPfIkgW9repKZ0QhDXWlMfvZXS50Tk+yK/3z620Vj0v
	F/uvVbx4grzIcN03hfS3KnGk7nLVC9xFVDoeOd7t806WivsNzToS7iILhETBZMGSEVr4jdtK3ok
	Xc97i0WIM9prRkfpB9237UEkZQUKcqMU+OlMYbeXXlbZVSpbvZe+t7OZsmxX3WWZU7qjmkQeZGt
	lPA9zC2b4jD8kNLociEoTNqLqTKEC0dFqhNOxw==
X-Received: by 2002:a05:6402:3486:b0:662:e094:8dcd with SMTP id
 4fb4d7f45d1cf-663bb3d3be3mr643429a12.27.1773362043907; Thu, 12 Mar 2026
 17:34:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-8-dmatlack@google.com>
 <20260226160353.6f3371bc@shazbot.org> <20260303210733.GG972761@nvidia.com>
In-Reply-To: <20260303210733.GG972761@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 12 Mar 2026 20:33:27 -0400
X-Gm-Features: AaiRm50W9P4A7h3ayFJS5r_ZVIe8OM2EYEDEiGqBav5AUONhmByKJOVge3skGH0
Message-ID: <CA+CK2bDADhFcMVGoJew9RoJ-DsVhYhiZJGJVwfzTBZdGX++8Ng@mail.gmail.com>
Subject: Re: [PATCH v2 07/22] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, David Matlack <dmatlack@google.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9E4FA160006
X-Stat-Signature: iowpwzj8re6qiu6ikjws5yxznsdxhikc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773362045-691551
X-HE-Meta: U2FsdGVkX1+rnG8g9ArXwFYUdFqM2N2M9Bq/QUKZdMLLutmLpwogRbSLv3s7Ir43as5+i7h/R+/bsmfqcoM0hA4c8ERpqqNp6SAgdIn4a7riHx7qY0SU0MGGXpb7o8zP+wnFdIpeSg4u4Us92Uiu7FvlRHBayp6F/NJe6EvjxF7uvcZ7gGk4CHS1/M1UZM2VX45zbioVjH1KJYEMu3XgR6n0vkrJ63o3f6t6cbqhW3oyGtkDjuljkzbJhai77EGezKG7pmXtzNwSgJNkOy5A/z+qPLmAeW7f5ct833JCTffxXkKsZYRclNOlu9Rpi8slRzp7yk6XaPANA6+2zY8i8DR/jHsdF+3K6y3JyI7ajU+uizV7RXosTasuo2TRISqMqZWqkJ96oBB3JrfLt3z5YLkouT1J7lZAV84+5teK2raGRR6hAlF1I/D5g5uyYeIQNnSwgtN2LFxHbBGxRnkglVcooLsp5f9Jf6z/0VN4lTI1lSOvOKj3kNpyeKWJiRlpdn3+m9jBdNSM/DWXpe/hpdB+J+fwDyxUmIG8JYSldzdVHsolR2BHvLozSmh+hrVTLGmDr5V1mwy/o0njhu0wr0R9vj3SuJX7bQyRcVY1e8CJRxgCkr60aVTAPo3DicAA/ltxA8LIrUnkilVK5gmzIbPxAg5bp3vwu8SIhrfyOFQY14vX3+ZUak6NbPkogVmvWQTLQk73YVYizv05ORXBauxts08B3v2j5aAPMFv7UjFJ33YfBysb1hN4t5d8kg6gFY9FM7s4waz5imI+6RvvXUFewO24BA88Hy1XGhOQd83le1WKcAl7wZC8T2O4ube14xRCSAmXTlZU5dYtnykOQvp0W/hlic76Aw19/ZNEfcQ2Pk2YyER4qK23khASOtAJFVwIvRie+QOQ6vbUzH/ucw2s+y1mFkHQVlsbSLnfcXCI018OjcX8+Q/Rtf2vaCHFyEGl7e6wDOL8iCj6eHz
 raVTrpjd
 hBntFjhp0fPRV/P6SezQooqpeexcK43p8qq2VIaRW7eBi+tvi9bEmHbhkQWPC+NV3bu7F1hmECGcbk+LC8qg99+za7fSzlg1U1xILpxT2ctJO/DjM/i9j1nYfG/7I8hRwH56rJN3O8+MRRjCzyZGOUVBMd15cgF0BJSE+ZmoH+MBo975yrtMfjIVyU6v1hg3ChEpcRq4QwsnNDY5lYU+rQX6zUzKlHO9s2VzSSWb9DmgGeJP8iY9/sXFswAdXtZVsGQDV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 4:07=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> On Thu, Feb 26, 2026 at 04:03:53PM -0700, Alex Williamson wrote:
> > > @@ -203,5 +225,6 @@ void vfio_pci_liveupdate_cleanup(void)
> > >     if (!liveupdate_enabled())
> > >             return;
> > >
> > > +   WARN_ON_ONCE(pci_liveupdate_unregister_fh(&vfio_pci_liveupdate_fh=
));
> >
> > This is propagation of a poor API choice in liveupdate, the unregister
> > should return void, it shouldn't be allowed to fail, IMO.  Thanks,
>
> +1
>
> "destroy" functions that fail are evil. :)

Generally, I agree that unregister, free, or destroy functions
shouldn't return errors. However, this situation is tricky because the
state is controlled by user space. The only relavent scenario where
this function fails is:

"-EBUSY if the live update session is active and cannot be quiesced."

If there are active sessions (incoming or outgoing) with preserved
data, how can we safely unregister while they are in-flight? It is a
rare condition, but since the user can cause it, they need to be
notified that unloading the module right now is not a good idea.

Pasha

>
> Jason

