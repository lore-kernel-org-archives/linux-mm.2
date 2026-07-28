Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE0A5C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 03:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CBF26B008C; Mon, 27 Jul 2026 23:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87BF66B0093; Mon, 27 Jul 2026 23:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793A26B0095; Mon, 27 Jul 2026 23:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB116B008C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:03:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96C951A0299
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:03:36 +0000 (UTC)
X-FDA: 85036690032.10.10FA796
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id D73391C0007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:03:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=U4C5hR7q;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785207814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Gfu3RDiGWIEKHkevZ+RloXDenOIdQzmWURT300Hc4w=;
	b=tuOsEZgyZX9QgCh6lwV5tl4iPHgMMLH1KWqYQB9Ikv+S4StLlEBjoWJxpcctCJGyZ1vIk9
	tEoTowHig9dXItan5cc5oUtYflUBCmj1cSKq6IWyEyaAtN1DjlRqJPmUH++2BusKrSVhDx
	oqqw1lG16R9y629n81Ix7r6IUUsywbg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785207814;
	b=QoHP6rE8zlLjqqOYNR4MIPmP6ETRki772o20i3vZ0MFWXYeFXvTZTaoxhvN65Kb0zqILNk
	GUfgHf53mENPH37IqY401IPp6xMeM/2Vcin0y9W8k673ENKrBTW9AfPk0ICP1yBctgCvek
	/wUp8oZL5utoXHiUXhTfM9CZbkyPhOY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=U4C5hR7q;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c05dcdf49so33740041cf.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785207814; x=1785812614; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0Gfu3RDiGWIEKHkevZ+RloXDenOIdQzmWURT300Hc4w=;
        b=U4C5hR7qfneOtU45IdoaDydWsDI72rY16TMTJhFs0xesjipvzeo/EvUfG1Jythpvty
         Hx5vdnX5wGXcufo8reqexzF//ln66yCMT/E2yxHHJezVxJleyKcdBV/EtU1ib3jQoKvs
         X5KbqzVqXa+EUgS9aomH3oQR1aMYfSzWZISO/a1geErq7eCW8cyBeHczdLHOPr7FX6DM
         W/H/Wzi7YWUHuHyXTMstdkLXzBS5UswfBIqb+xBg34RkW/0rvrtUoOQ6OVRZzpLwoMJS
         h9t5Wbu/oel7xWZvE3V4AVkwocD8Is3KCG+KpC3KgIx10/5lB3wjfuwiBKf89k3cb3Zp
         qC6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785207814; x=1785812614;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Gfu3RDiGWIEKHkevZ+RloXDenOIdQzmWURT300Hc4w=;
        b=SrqF4MDUsU0U+9MlGWmFvJBOnbmifY3FMAs0o8ZXVsC1SbVlS0y9joKJYdUcTaoA50
         XUQj+napLhiHc8kKJl1CNSATsQ68w43SAffi4fSpRobjrNwvSgtSLrxH+WQ3IfRh0RFz
         B+I/zFxjeO/Jgrrn6qIHJZ/zQhnKGHIcPgr1uEI0xlirHUz2HYxk2LrvgajUBa/Qh9Y5
         nZKan/vOzYn0MSs7bD8iLQ30mpona+SkASm/8a6rcXn+CRvGSZhF1/0hxOHeWNzf+9cV
         e4djfyqH1nVh9/JAH+zIh1xssZMXxJA74+abb/tmLY0mzQga9JiC4B5LbvR0LzA0U9W7
         Cx0g==
X-Forwarded-Encrypted: i=1; AHgh+RrW3TRsewbESkzvhMP2axxtoAw9TxWMebY5KA77Sd9qyTcUWQlWvFgiERlqlzyKRc4kJMwtqHXEGA==@kvack.org
X-Gm-Message-State: AOJu0Yw/L4RHY6ldPrMOPwx6lS5UGs7/nEnumBS6RoOlygBIJtDWsU4Y
	Lpqw6qZNeXeUJbQ3536cYJDXTKwHnI29RchNmsJqMJqGqQEX+YMEQa6c50y3BY3AgY4=
X-Gm-Gg: AR+sD10fAVqOvcgD/Fkxix3p94gEUgjW62O9PO1ul3WhJu3y4HEqoLEJgFQrnWYbeLM
	1+QwrvCtnZ2ziZIU4ppNmxWcqidJQvGriBfJMJwjKnkL2PYHbRkucbuSjdcP3SgE93ucpP30g86
	EM1AUih157n2g4Gw60zRxP/hKbh5jFHAsEO8bIJ4v5/Q1JX842H6q+Vick4od+OzEzbjB+Gzm/F
	E29ct1KvhqWe1IIMNJALfiNQWLX9/85167vg4/feS1veMEwl3iE3d2YTE65S+5XJho2+u9w+A2x
	bKUCr75FpcfbFU7TStAHzbTA7ctzIDbdpyKNXe2JFqX4C+FQNhWnbnVPoU16x3BJBS4i4CmYpB1
	7lNAToBNdU4UEu0eMYyyw4Zp6wTjSSQApL6JcieaGvknXNxmpCgc/pPLmaOiJRnJeycnwmd4umv
	nq74QzpZ34TGabeuSwfMCVEJPnHOgGV+BoNjKMehWfBoOSIVFdaAV1l3BJIw==
X-Received: by 2002:ac8:7e94:0:b0:528:a8c:a9fb with SMTP id d75a77b69052e-529d71a5fcamr4404971cf.87.1785207814003;
        Mon, 27 Jul 2026 20:03:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529a2a4bed2sm65297261cf.29.2026.07.27.20.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 20:03:33 -0700 (PDT)
Date: Mon, 27 Jul 2026 23:03:26 -0400
From: Gregory Price <gourry@gourry.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>, 
	Sean Christopherson <seanjc@google.com>, Ackerley Tng <ackerleytng@google.com>
Subject: Re: [PATCH v6 04/12] guest_memfd: Use folio_has_hwpoisoned_page()
Message-ID: <amgb8j0JUn9hAc6a@gourry-fedora-PF4VCD3F>
References: <20260727181310.2671972-1-willy@infradead.org>
 <20260727181310.2671972-5-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727181310.2671972-5-willy@infradead.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D73391C0007
X-Stat-Signature: 5wju8paxgr3xnfohz1pry8fot49szdx8
X-Rspam-User: 
X-HE-Tag: 1785207814-977896
X-HE-Meta: U2FsdGVkX19HMDGVf2mkmQXCAKhBwO8vtNA3iz3GZ0XxjsLqfnzVDgKeVUg28fdC4cJDI0AhhnH7m8EN9RDpjwa6gY8hxS0ojmUJ7aSnWmo7urI0tFzc1brUcbraJwYhD8Z8cBJloxU8urwupirnz4Rfxyp4SJLhuKHVaNpxEV55TU1x0giUtFjpT0jo9wh/GXoRdQBRCbjQP9nfTDNN04asY1lh6srfnIPeGeZUNE937RzzmDMxRpNhy6UGoxFKngrFdWRasi8EMFSk9O/QEq76XRuZkQxPWUNYBtejQhafs9WGHeOZtdUKX13iKTnlngl8NANFZctbFCeQYH1w8xo32OMN6Xg52mICFq91hCDO5EHpjs4nRpniXJrJLcGe5AbCg0eKtbQPfPdf2H+37R1Ku7dVgi3Yu/i+iDKdRMdVaWRG5TPzPVmDqRm8lVcNMk8WpNQfuGQrwltnTKXssWmc85g5f7xQDqDhfHaF4QtAnzgyLNmPjOZ1A0uG62IiV3mcLCMkM3ogqcesXG4j/MauTRqfaKg27cYoaQgDvU0GJYjDsvAB2yEBGREvXAa+KK3Pmdmzv8aWoxbOSRvXvdnwYeuwqnt1+IYAE0WbwaGO9BxKXki+6+YfC36CtkghdDc8khSColpkoKfjnaEir5rMDAammqH0lpTGYnIQtdXxR7gSJv0CfhHlydTz9eg3hfkJ08WehoFwc5zZmgBATye3PTHppe/sCRf0uKXjrlNkwwA3ncIzjUKafMVFlbi60mCbi10oJ+jDCON56r6LbN9qXV0pEWRw71/tnQkWzhpzYcfKm1CX/8ZXBkSeW6y+TOgpNHyhtzNMCnjqR0MAmqes74aXP5+Izj9sQFePK179oNryBNM0B04IlO5KdDfOTehnh1Ctoquq7j0y8Rzwo6oWUJrvzF0sWWn4RC+GzK2V45HrNXBCD2f71FSIS6+yseBsFGsrAKADdaSfYyb
 lDWjZhm7
 pl6eDdcrAMPvowDJPjfpQZ4R/h/eqwXseXJmx9kOu8KIMGtLHXaigQjTC0kSnOxADLctMQ3dsq1xE2/aGSZoSDbFIjwIgaCOeNzeeZoKNc0WaYNgoQ2Bjs8OcpvlrU99tZdrE46+hsvZN7hCt39klJLnLsFsxEvq8YAT9gL+lm7OTp3vXCkPs9uKYnQg1ifEQRrrOQTLKgvvzkpuAOyABtrMlDhMEItWTRv/ddL/TYZa9rLzUghpx5aH2Nt57XX2PZoES9TveWCXJH4nm6W5vhpeLAMyj11KhHL26OWYFVgOoO6p6Zj/nLbXQQbuvVgwggcTkY5FdvYdcbah5FIDyvHgPRy5jXr6ltsbZ3VwClWniTYU3Akk8ZgH3Dx0rVpp27PeXrw2mTpAPtzaZ0hN18mYhe/3BY9KZwSD3Hz6Tvofjf6oAjqx8FbrQy63FOQfGQ6/O3n3aj+12b1hA98uNB5d56ABXSFbcjVrbc7dP8kKzWlOA0FRvywLBhmKos9OK3SW40/mI2EeLJvcdlNrTP5k2JXb1r1ZU6TIK9BNcIByXAOTayLckpQ1TX72APPLaf3fg1hcYlkWG6Bmi7se3Icf9NQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 07:13:00PM +0100, Matthew Wilcox (Oracle) wrote:
> folio_test_hwpoison() only works on hugetlb folios today and will give
> the wrong answer for other large folios.  folio_has_hwpoisoned_page()
> works on both.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Gregory Price <gourry@gourry.net>

