Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24BA3CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 01:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1A368E0005; Mon, 29 Sep 2025 21:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1D08E0002; Mon, 29 Sep 2025 21:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E074F8E0005; Mon, 29 Sep 2025 21:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CBCDF8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 21:49:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4AFC6140563
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:49:26 +0000 (UTC)
X-FDA: 83944234332.20.D7CE0FA
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 31CB3C000D
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:49:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="B8HOhXu/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759196964; a=rsa-sha256;
	cv=none;
	b=Qim7hGdoKPCVTySzK2LhY6APo/QSg7QT7ert0ITzJmpsjd8drDuigy8iu8D9MyXXe813Ee
	fV0N/+ldSOLGG6siW9MQ60u2e2s9a2d93gCvy35zUCNUZWLBZiAErXQJNf3Mjhfmt9NSsO
	m02cKbMPji7vNidF6XVqpz4QrupOJd0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="B8HOhXu/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759196964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cccOvLIDs0brVn19lKW2cu082nXZ924OZUgqQqLgWy4=;
	b=3zRZcPRaHhz2+9f0IL/tZF1iUkl5b76frbR2q8omQnIZ1sbOB0asp/UsmfD3d/DhM4OGHJ
	YPahZOx0eWitOGugM+sQIMZB5k8bYoRN0x0n2Xl3b+OpOCvGBNXaJP7QFe4Oca3Hqa0Vtj
	HMkoDQrrmGcveZuUnEdcB/qwAskE5Nk=
X-Forwarded-Encrypted: i=1; AJvYcCVrL1VhEqC2w6mXwOS2/CNjNQMjg36Ev8q2kaAvfRX5/qULO1J8Sfn/b3mcYCuUW82Qh97Dnsjm7A==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759196962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cccOvLIDs0brVn19lKW2cu082nXZ924OZUgqQqLgWy4=;
	b=B8HOhXu/G+ed4lo7yxhAgpmi3zaaTykcgbzs3nrrxTCbjs/cs27j0lfve3jiQipQwSp94H
	MJhGPsTHvlXMCOlMGDpXTG3INLhPA/yXs6H8SddxrzImQwvcjAaheyAqxNEGuh3sURZwOI
	lyIPWifHIkjjvQzPW5fSGc/ZGyhB9r0=
X-Gm-Message-State: AOJu0Yys0IQCUYF+8hLVxCQcVNt7Wq43XG96k16h1t8MoFq37Y8CoV7m
	Jvg9ZdvayJZKTRQQKozcH3gtDskAjyG65oWyLAA7ikq9dAK3c/NMhY+FAWVLAwvnyb0nrfhzPev
	giqCvCGavnJcem9YfDpifj1ZCW7/LNKQ=
X-Google-Smtp-Source: AGHT+IFyudbMtZdS0/36vaHAY+KBcRFGx23xtJVbc/IL05kWT/AjSm5jL8atDU+wwYaYSRh1LwVacl/v4+VesV0jJio=
X-Received: by 2002:ad4:5ce3:0:b0:863:5c7a:7289 with SMTP id
 6a1803df08f44-8635c89b87emr43694456d6.17.1759196952850; Mon, 29 Sep 2025
 18:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
 <CACw3F50ijQ20Vg8ycMROSCccf_XtjB_fFvLGxvQZ7eaNQoLwGQ@mail.gmail.com>
 <SA1PR11MB7130ABC25E060D2CC4749E45891BA@SA1PR11MB7130.namprd11.prod.outlook.com>
 <SJ1PR11MB608350E5169EE77F86A51E2FFC1BA@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <SA1PR11MB713082CA93E9B1C5F22CFBBE891BA@SA1PR11MB7130.namprd11.prod.outlook.com>
 <c1294b63-eeee-4d99-82b6-93eb3a6d0af9@redhat.com>
In-Reply-To: <c1294b63-eeee-4d99-82b6-93eb3a6d0af9@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Tue, 30 Sep 2025 09:48:34 +0800
X-Gmail-Original-Message-ID: <CABzRoya5wuXoMWuGb_+F0oBc0mCDVrjbXTZsoMwcfRT99Y5z7g@mail.gmail.com>
X-Gm-Features: AS18NWCEPx5gCS0R5WB1gxGkcM2qm8EcK_iKsr9vf6l6Pm-AjVLkn3oGjXPud8c
Message-ID: <CABzRoya5wuXoMWuGb_+F0oBc0mCDVrjbXTZsoMwcfRT99Y5z7g@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: prevent poison consumption when splitting THP
To: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, David Hildenbrand <david@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Jiaqi Yan <jiaqiyan@google.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"baohua@kernel.org" <baohua@kernel.org>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"Chen, Farrah" <farrah.chen@intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	Andrew Zaborowski <andrew.zaborowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 31CB3C000D
X-Stat-Signature: ma88q3kagfwqqjd7bych88phstiozyms
X-Rspam-User: 
X-HE-Tag: 1759196963-155124
X-HE-Meta: U2FsdGVkX19GphDwCxkjbpH9pSZlL8avezGKtg7NSpo1Ata/GXMD69OE/h4YX31mxENkF43/qo7SN94ul9Kuo53COc88EdwWA2onIly6A010VFuB77Zk8C04Y1swDBZPiLT+Ki+5XPIQ25Xxh9kY1hPvkaYJfg/FIEsQPGiI7wMunxFKn9zixUSswGhC+2OVr6BC0LFZ7fhZvvc95GocwaSr4x8+BKQwXdBi7ztCLYhXy4TiEq69yELcjnlskmJboBrIzPLNOFybwkwu9L4m9uCv4PqgjVv8S94I50iYkE3nWzLfdoNsaze5EpLMABKPZ8ddNPwIm8Vqi9RYZUTE/QoETQFQ5BumH8SqgZt6JOr8pvdqOSe7MyhR3/wNFVhUY1mUZ5g5CMe/Z0pqX7TLwusZYpdbr/7ATx88haP3cZFBN3nULDxqo+7moFML0V8hWS9b2DHr0xM0QUSsqQ+X82IyEfhVJY8jehcU40y/ZpQ9Dtw46ifJTSCQTrmqaMF21aywwnticf2b7ujIUNjC9Bpp6xjO355PMEllpUuf07Oz/3ojNgsTlpkPzwNNewmXhM1dwPg8ybAvmyBoNwikXjUxtuqhBHwYkCgkUiM8BoIH4R/se/dXTkIolL3TriZRECUPA8qbSTJ9jULe/rQvJR+H2+6uzSjt7kykxDA5iCqoWl/U8klJAtm+ZZX43C26LmJSEFhlRgpgTSF/p+Ba4EUvqCw7n/A3VGmLX68SAfUcl3XpoARAs8Q3lwFvYI74moXCxNcC4oMzF6YiM1VEQMbvXHbVCsPzQeTgdWZKDewao/jMWQGRToVGltxE8KciWjhAfBQKmmXmu9zVPAkSBpvoaqOUdPtH3D4gwFBj/qo/i+sqDJAKgDHvd7PY5jq+gB0mj5Iw5VeQ4VddyplLXrt8DWDL+y1DSej+e0JL98tkuqKyhpPCXkfrsloANzGrd7yiHZlD1mwuz7eryBs
 9ZGS3oqS
 0YEGvL8TRXtBSueyj0EWWIXusbiIW8l1865f1LxSWF/b457iOBUct6ANtgWkRDXREV+W/6WiTgop3Xrf6t8CDXgkaVhhjDlNPvE0Bq+D4jXGcBVuol/Uoyfg9cfEMjAfYo0GB/1uBosdv+9XHnugjdHBsy4o7rLsekWDZykjKSUFYHHL9tCTd0mHcqNrbw7jgDN1NZLwmnsIxWyROSde4urWbD0yoa1N1ZwEuR8lXw3UKCKla7X+U7vmQ58cOpoQo6bC0Ns5ItN83S+0gxzKorOrWk74AMiE+rc6hxHoAHfaqf0OGdPZMh4xsLLgq8pY95ZQzywuvf3R7qkE5yaDaN0grRulR+P50nyV3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 3:07=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 29.09.25 18:30, Zhuo, Qiuxu wrote:
> > Hi Tony,
> >
> >> From: Luck, Tony <tony.luck@intel.com>
> >> [...]
> >> Subject: RE: [PATCH 1/1] mm: prevent poison consumption when splitting=
 THP
> >>
> >>> Miaohe mentioned in another e-mail that there was an HWPoisoned flag
> >> for the raw error 4K page.
> >>> We could use that flag just to skip that raw error page and still use
> >>> the zeropage for other healthy sub-pages. I'll try that.
> >>
> >> That HWPoisoned flag is only set for raw pages where an error has been
> >> detected. Maybe Linux could implement an
> >> "is_this_page_all_zero_mc_safe()"[1] that would catch undetected poiso=
n
> >
> > This sounds like a great suggestion to me.
> > Let's see what others think about this and the name (though the name al=
ready LGTM =F0=9F=98=8A).
>
> The function name is just ... special. Not the good type of special IMHO.=
 :)
>
> Note that we'll be moving to pages_identical() in [1]. Maybe we would
> want a pages_identical_mc() or sth. like that as a follow up later.
>
>
> So in any case, make that a follow-up work on top of a simple fix.

Yeah. IIRC, as David suggested earlier, we can just check if a page is
poisoned using PageHWPoison().

Perhaps we should move this check into pages_identical()? This would make
it a central place to determine if pages are safe to access and merge ;)

BTW, could you please keep me in the loop for the next version?

Thanks,
Lance

>
> [1] https://lore.kernel.org/all/20250922021458.68123-1-lance.yang@linux.d=
ev/
>
> --
> Cheers
>
> David / dhildenb
>
>

