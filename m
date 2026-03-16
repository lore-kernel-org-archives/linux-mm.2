Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22893F53D7E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 18:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5096B0335; Mon, 16 Mar 2026 14:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A2CC6B0336; Mon, 16 Mar 2026 14:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07AB26B0337; Mon, 16 Mar 2026 14:11:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8EB36B0335
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:11:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84E0813AA8A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:11:55 +0000 (UTC)
X-FDA: 84552719790.28.F62C2AA
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 732864000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:11:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XKv5p08o;
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773684713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hacBXTanIx+HGRz6G551slI/wF3dk8INyCTw5fzLvmE=;
	b=CM0AlO3abBJE/24IYs5+p7Aol/kJkwcTKrVmzcKaaEG5M8Ry082Shw5Cc0IyuHRSRqCd54
	owM3+7mjnqLhL+H73r+WqfrNtaL5k0hFSNMNKUP38Jc5BW/zbdF6oWo9CetdiuIzbbBGa+
	pq3kNw+9HikmebV3xrwRqfVqBOX3D1k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773684713; a=rsa-sha256;
	cv=pass;
	b=8LQUNOYxyWaQsz2WYIXVVyaCBN06/iJz8uA9n7ff6B9ymv3G8L+FGYQaSK27xTEcETMroN
	zmwQAtRsbvhiwsDO41eTFKuraLzgRdJPsPQWYCiFCAcpFNJWtlD2a1SFO+O4o0Cl6ukPI6
	DQbRaCYaalgbpBDfnmqOhNQMeaa52Eo=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XKv5p08o;
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5a126b79512so4197565e87.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:11:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773684711; cv=none;
        d=google.com; s=arc-20240605;
        b=dVAO9GUSiI7C+R7LGPuczU7VbO8NyEXcCp5pIM7gwfS3MTDfiHrqcRjl39Qh0gXwBh
         yomFTvBy0JvjgUi2dhguaAEpdLJ4uhXBLNgmgcSJWZKMwjlNg9lD3TGPc9vrNNaws+9c
         Z/UYVsDSNOBJWp/iKCVrbVhiWn0rpj7Vc6kzOhqhzafoVu+hwj53o1LmKUnxIy0jGJr4
         VuGk1Chk8QTqnccUtTMTU4gGqrwTlsaxqzka1mtH3mJWgnPbStJ/C1UU22x8TkH2+PvZ
         bHtDhv3eVzbLVCV27dDAFM2+2hgVRvY0Lw4NB6HZr+c3bqrVbGHDMfZhcXyLAYRe1KKZ
         BpoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hacBXTanIx+HGRz6G551slI/wF3dk8INyCTw5fzLvmE=;
        fh=D/rbLqr0cq6gunrJ6RvTn9+2red96KtsRWdWFdIoJ8s=;
        b=DLX/vkmMnvJrNQObSMOPjNh4ejSC0cKH3yFuFsvELycqzFLvLKE0YgajPQAVO9ANSI
         W5WPHlnrEIf3VA64qP7xNvOnAXLpUnsSTemPcNHMb5Foev8RWpMk7WtFLu9m5LWSI2Fu
         rc8L9Tv5Cs7YVDIjGfKvQH9PCUroL2+4nKlebrzyd3lyUaCbNoc9g3JhissiABeoV/7h
         hzEvKbSoX7kCl0aqkE4gGCSNFbvmcPAmP5VfPHEGNe8/VVNv8jqiKHHcE/JgLoFKVSwa
         rTl59WuKBua8hjOOlSs0brocgo718T+o6R0Nk6PaQietOLRfXvmUMvykjYE9JlQTJh0h
         Dwmg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773684711; x=1774289511; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hacBXTanIx+HGRz6G551slI/wF3dk8INyCTw5fzLvmE=;
        b=XKv5p08ooXYDdH3SctPBTEItHpak4f7NyQ2d+zqTOeokD9zkbJF5SU/PI59zOpQWM8
         PQv49KmLwihmuIIXriDuVVvoxzgDAoTfoS9Hh9e7iG10ZmJ1sfm2ABraSwP/RnQVULjt
         FxclAFPzNErnYa3S5Bv9x7cu1fn4MNboM0cISVmjTMRd08E310TwsnafKxPaICDp3S8x
         1TvBRAXhugElqwFDhkoY6GjX49wdtuPQCQSuW9f7y1xvSC4nQay6MZrlW9cDoS5NEEz1
         Q1ZcsAsrJSEZtOdREryJcu/NFgtRmto0U5LCSmTk31cvOxsS78CjVxcDBWc2O0DKlt9+
         1DdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773684711; x=1774289511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hacBXTanIx+HGRz6G551slI/wF3dk8INyCTw5fzLvmE=;
        b=gseNL6JvqEBsGarhFR6Bg6WfXgA82wWBHe4LIuUyidI1t5Q3MNPsYpsc2KE0NYH2rV
         kycQSDm9fXsbtvtruShM8FxvAuqo6crmFHb7omd9xgP9xw3m6OMjpLCk+OR8He53WUl1
         yO0WiQnl5Ro6pB645C4Pr7MAt2+XQlMTtqilFfNtPC7sKQzGZeBZmxasy21EtBW1isyI
         Dl4dSZVqW+6lhQwCFU6rur0J2qpr/LFZQkiiUjmK/5Yq4zRrmIdETpx6CzJ1OVg/oE3V
         ZrX1QCTJEWrWt0LWKO/1vFUNrVPPpJ8oFENUc2O4kkfLRZLZLLybJpQWJKDsXLuNbO+b
         WBPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJ1rD2ZBmuu9D6Yj+lYSNh5EhXz3kkXTs4bx9O8IJJe1XH3KGsTmZ9e6WGzMI11Eq22aQR7oCW9Q==@kvack.org
X-Gm-Message-State: AOJu0YxCtpbKiD4Z0wxvcN16dcOxNLyxFW69h3PHoQHDmpUdsSh0jEbi
	uoGXlvBN/xnje1xetdY3LV2j45mjlxyzKMqt//8r7QoQXlRBIjMkxoUjYdg0aJtg5xweQJSFmmE
	EN3zCcs76+pyNvGrIUZFLmrGUWogwg6iqZquB/au5
X-Gm-Gg: ATEYQzx8Ms/ehSHVuYd8o8rBLjXb1xza+rUAgjsX8of2gkUGuQLZkWakqyl2U5yMN+U
	YeQVQi2UVaJ0YBO2vTDAsFx3OvhepnLz0wZWyYv0f575cUrswxVLWGJEOzrJbRJc7aS0axUrFm/
	68HBueIfQvxrprBKDJC3Vye+u9F3gFO6pENp11TBOR7bkAvap4OVJjv6Wsa3WvbsDDGiT/CtXjC
	qj8S4KhWIbN0E8OhonPGQ8EmCDT2w32VuNODviLO4VAZKg0zS/XE5KcKacBPDxiR2Bu7XWU/sHB
	WCqO8Tux
X-Received: by 2002:a05:6512:24db:b0:5a1:44d3:7601 with SMTP id
 2adb3069b0e04-5a162afb717mr3098120e87.20.1773684710999; Mon, 16 Mar 2026
 11:11:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-11-dmatlack@google.com>
 <20260226170030.5a938c74@shazbot.org> <aaDqhjdLyf1qSTSh@google.com>
 <20260227084658.3767d801@shazbot.org> <CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
 <20260227105720.522ca97f@shazbot.org> <CALzav=fjRPa_ZbXu7iFXyemcf_8Kq_dZTWT6c-A0bc6czF_Rdw@mail.gmail.com>
 <abNOwcOTXqxCxNzt@google.com> <20260313083918.00005731@linux.microsoft.com>
In-Reply-To: <20260313083918.00005731@linux.microsoft.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 16 Mar 2026 11:11:20 -0700
X-Gm-Features: AaiRm52c977M5CVgCJmgqL9NIwQ1v_KtuafdRnOMJexlLUpZndu_UH9phsJ7tcA
Message-ID: <CALzav=eGLpo5nrsHq5L8bUTC=FWZ-SgrTE1FoScrWB4p+NDgnA@mail.gmail.com>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 732864000E
X-Stat-Signature: ecy5dmpzzesh83gx9krgsg7cm9zhcxtc
X-Rspam-User: 
X-HE-Tag: 1773684713-816110
X-HE-Meta: U2FsdGVkX18jf1ES9GthkEYmvlphSjYayCsoY0ykevuoNwDdGQcdGI4XtV72GsElLQaKsqhXZ2jCb2qydUi1fjbpbWMeXGFEguUAuava1FGsD1t0ni8nVMlNkRGWMNQhtwGcLGB7C8wRBsl4qfEugaQpGimR/9Pc9qWGIfUMExM2uObbpj/SAwisUU/btVZcjuj/+94GvQdGM4QaUJTuZEmphZ4Qysmz9zIMuUXbPaRr65fC+qhCy3afkpWBkVD67sdOF5fbmztDpS+njcyWTMbBs6dXfx0EDMubteht1p9Vy0RiKkTiAcJSobDe0v4JasXD7JWMrfTWcnpDS70vr1SUcFOm/o+/wKSm6L8E6yw0yDCwzZZVbBtoofV8DkH9a6AviZQsPSfpmBk8rg1/8S5WhKw+AVrIqRQ7YzzjzVqYaOyNZaC2C1or9yYngeoCl0j3RTNOAOshgJhCDf89lLsQalDL/ywrosWEeUaMBuCOn9+A2xPCw11pm6qGJg63K3SHZe60OcXF9t0iBpL3j9BsXMbUho1yNZrjX623DKp//HTMJ8PRAko0VD+fnu9kOA+gw4a7/tiNrIdE34GM253aCKXsNCm9hlxvInj5PM8dsk0ExYOGBpGYgmxkmWBa3Hxc1jVrpOaVKBfoDWlRXuWJbYnT/4JNfzbvsCQNPvrscJkbqlDf57LYuRKlqn5uShnW3GH1r128oHAIBPWDBteRw/DYFEkW+OWys2c6YB1zcHmHzDXr3//FRCLFoRzqlfmHWXChuy6Ua5JB3AUMHaURe0B+ZZSDkPoXpBSviIT0tg1WoJ6i9b5PeXdRlWVrWVCGN+CR8QENdDBLluofqIFSJVAkkJUsTY+VpkSVzyf9DymMnwOX30rZA1UC+apVz68DxGLsE0dBUFXyWA31pGmEs+vXKQLZiOVVRjVJPu/8u5wt2PrfMH8CYxro2JRV7rN9VBpcmtKSGIUC30s
 50cErNEp
 ydawgyfAgne72O2f8T3lFyGNVdPUsrGQLx7Jl4RO+Jln/2cHtvVREgvIUALuZOAzB8Qcf9U7ByWkC077nP99mTIOdUY+ToP/jt8VSXSWCJukghJKrsrR00NAkJzGUV/zztxxeHGvFwuotJ/gxsQldsxH5Ab0wScEIEFm3gswRTZUk1doQKl3gV/vS9B2GSdW9276GqxW08nFy/SWIa3Sb4m5H9aCxhd/GoEVm7vItTOY2nNlf8IfbccjE76uAZflaHxSf64cqxAGF1TBab+E+RKw0bxRuxuHqoqrzucIddy98Z7mCuzbDDBoJxhz3RpITOr1Im02XEKfityCf6iulVI5bge1RBOiHJl0JmTUnuKWzrdU7uJq6WAXppQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 8:39=E2=80=AFAM Jacob Pan <jacob.pan@linux.microsof=
t.com> wrote:
> On Thu, 12 Mar 2026 23:39:45 +0000
> David Matlack <dmatlack@google.com> wrote:

> > +config VFIO_PCI_LIVEUPDATE
> > +       bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
> > +       depends on LIVEUPDATE && VFIO_PCI
> > +       help
> > +         Support for preserving devices bound to vfio-pci across a
> > Live
> > +         Update. The eventual goal is that preserved devices can run
> > +         uninterrupted during a Live Update, including DMA to
> > preserved
> > +         memory buffers and P2P. However there are many steps still
> > needed to
> > +         achieve this, including:
> > +
> > +          - Preservation of iommufd files
> > +          - Preservation of IOMMU driver state
> In the interim, what do you think about moving forward with noiommu
> mode without preserving IOMMU driver state?

I haven't gotten a chance to look at your noiommu patches yet, but I
do think noiommu will probably be a good way to develop the VFIO and
PCI support for Live Update without blocking on IOMMU driver support.

> I=E2=80=99ve tested your
> vfio_pci_liveupdate_kexec_test with the noiommu cdev, and it works as
> expected.

Would you be able to send patches to add noiommu support to VFIO
selftests? That would be very helpful toward allowing us to develop
and test Live Update support with noiommu.

