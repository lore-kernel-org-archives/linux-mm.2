Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE73C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:59:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF236B0098; Thu, 10 Sep 2026 06:59:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAF736B0099; Thu, 10 Sep 2026 06:59:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA88C6B009B; Thu, 10 Sep 2026 06:59:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 768B66B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:59:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B7DD8047F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:59:33 +0000 (UTC)
X-FDA: 85197556626.15.D9F2BC5
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	by imf03.hostedemail.com (Postfix) with ESMTP id 89E8A20009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:59:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="E oHYaXG";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Ja0/aFLs";
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789037971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BwfusbEF09le3lRy6VYoc5vvb8/UgBwJTc77fiy39Y=;
	b=zkAAwldyABK6IX8IH7a/WU2w6t6ndRdqite9YTV033m9n3xTO/v4EY3P/wzQFQiSDC2J01
	eQduPeGwdIN/ioUoK+2OVju8KFYsKVJFtZthls+maotkwe5ta8OQKy618K7YSf19YfE0zK
	yUKEIf+S0548CQMNEBgioSahVemEMMc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789037971;
	b=SmxlLSOQRftAOk26Vr/KtRS7HbzU6BUDCIvB6OD05FzhOpGgwDcqzps4U6hWkncotXnvY0
	dG6+Nxxc0ah45lZ6yorTw+rVCW1A+wcWmzLINMb4kuFST5DM0fleJPxU5MFOQtV7Flemc6
	F4f7ZWQSpVcKM0UxUuldpmWpNaoK7cM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="E oHYaXG";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Ja0/aFLs";
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 0707A1380361;
	Thu, 10 Sep 2026 06:59:31 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 10 Sep 2026 06:59:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789037971; x=
	1789045171; bh=3BwfusbEF09le3lRy6VYoc5vvb8/UgBwJTc77fiy39Y=; b=E
	oHYaXG2d6dnhrhlZPaw+buBZDZ/ZOK2YnKEt4PcmBcdz5tJ9IbfSf4UPrvUhgbqw
	/XMx0QP8N2fiMU1TW13nPJtYe0p5+Si6eaiMiz2Iko7W+2LkAlvXpwPrscMrT7om
	wlQC7EgKzUFPcVZ0GihfXZMpdxcUtxyQWrRLOsWSASvu63ddI7zLjGjkGH30yi+f
	JcnpRoVTp9Aewwmgb7PaYgdIPXPTtk+eDbzgeQ6ZmU4Am+7Ribf8HMHcUn1qXNmE
	ZwVKL+CCx8kzvJm0Ix3vqwLozSpFcymTJQ9LaI5NIUYM0f70nkbNKt7xiPZ8+0/S
	JdUpgREE6BnuJ/R3K63DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789037971; x=1789045171; bh=3BwfusbEF09le3lRy6VYoc5vvb8/UgBwJTc
	77fiy39Y=; b=Ja0/aFLsK7Q3t9RqL1iZ8DdLkI58V/wC//AmOKKX/7gsudbj4+G
	xtJ56ZTUa7nIixXwpt4BQ43rQQ7Zzo3fsLVebFzLMEBUAkdcPF2Q6/6HDKzOjrmY
	T37i1UKa37PRYZ7dsb/AaAm6KUSSbYexjaRKNM1DAOeEwoLvOyFwaVY1jtF3uyii
	OxjO2HnpTwPBcyWBcj7RkaO/BuYFUM7Tn1sUtokaQrRHlYgIdbff5ual2iOqQzPL
	ZyhTWt7uAMb3AQfzw7dA3W5L73sD5KUj8PQQ8rhl/qjMt4/f5+2fGDWX7jmC9gRV
	iTwdPlILGZNByZ8Ev1FYHkvLW5cz4lD1uiQ==
X-ME-Sender: <xms:ko2iattjalcwPWIL5UNscg0MIXiF6WmOWJlVElV_0LdpRy9806dh9Q>
    <xme:ko2ianKt3vTu5gQv9t0di3ONtO1WeMGB6drgjQDGZnfDqQSfdUCAX7Cc5y9tAq8uk
    xh0KAxNz6_ltNAjZPpXG6QnYiPI_vurirpQuFY7K6QsvUoG1yn9hzfgTw>
X-ME-Received: <xmr:ko2ialQXjXZW9N5NZHRNckiuQE2KO-6QzYckf8mWVty2FfzfGlKuSb3bFR8>
X-ME-Proxy-Cause: dmFkZTExGDeRAc2ZQvQEVOZg05RC7pzdHKVkkxCU4OVzC6eJ1yiq+dkvuNpph491rCSg99
    ItVtML130B8ODTdy76InRXCLDNaNNaTXWNKl71VlGzapLT/PKpaq/yp6tPxANkNdjNuqob
    hUhC5q+z3VJokLVhtdnNzOHq8HB3Gu5Ki3O9wHHpqx6QnVCJ6Mwr6zY1sfs6ioIkhduQB2
    cjK46H5gyRhde+ukXeSmJg7XmiDbNE8++i8Ylsv0wnJwn5W1L9sKPmXxdBB0BYsnvUNs5B
    4qHkIOL9/2e667KRTruDA/HZANASE9ZIxHm48xWT6Jg9ai0h943Ghn3IVLvfn13XDvCjZZ
    AHaR9sdNGERstfSRz8Jbu+sZ0LYCoL5Z7DkxQFQZ/wGLvdwBejDf+fYHnCiL6KFc4W7Y2k
    Wf1EzYf+EDqW7tkNXyVs9IA1vdj2qTdXRleRBRBEa6wRZbtuY43Jb3Wgju5yQKbjkcI8L8
    /eLkf1wSSQhYaKwlRb0xXOyLFwjVAvsReMSx31i6VJK9APRimVscJHj+lHFyl5ceIBR7bT
    kZI3XOFLpsbaz6OYOiFQVizlu1JPaBWhWAOqydoiofLiU4ESgyl+gkR4NZ/egwkgFhifOX
    EaY1uhrPJpP4xyvdbP87nRnG9NJ7W0SNoN7NVd/aS+Q+4Fx98G3M8gWuB0Dw
X-ME-Proxy: <xmx:ko2iakvwyqhKy250k9J0RtVdTTIkYbA7vSC2kKlL5CuuPna6nzIlwQ>
    <xmx:ko2iaki9tMjClm9xKnmkPgfeHjMINXbSZkRvznOScD7766ssSXAePA>
    <xmx:ko2iat1rf7gWeDZlzLuBwlvHFUZhXHlJVQL1P5agEF4-rt5pd3s3vg>
    <xmx:ko2iaqq7LcXmxRJXqP4FeoI8N7Xuylh_b_QY5fTXBgeURRc0T667fQ>
    <xmx:k42iauO60ajg5omKOYksNnMDp6gk1alTZ_S78VJASSjv3m28xQmlRTT8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 06:59:30 -0400 (EDT)
Date: Thu, 10 Sep 2026 11:59:29 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev, nico.pache@linux.dev, 
	ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, ryan.roberts@arm.com, 
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org, agordeev@linux.ibm.com, 
	jgg@ziepe.ca, leon@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 06/19] selftests/mm: stop khugepaged during the
 MADV_COLLAPSE cases
Message-ID: <aqKNcw8-2H035xyc@thinkstation>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-7-kirill@shutemov.name>
 <4e064b9d-aea9-485a-8547-3830999cff01@linux.alibaba.com>
 <aqE3Vq8Go01c1icS@thinkstation>
 <ba2d7885-f017-4d4c-bb59-e45f8b9f1b63@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba2d7885-f017-4d4c-bb59-e45f8b9f1b63@linux.alibaba.com>
X-Stat-Signature: e6dgiudi3jd4m634rcr5i35m1y83tpzs
X-Rspam-User: 
X-Rspamd-Queue-Id: 89E8A20009
X-Rspamd-Server: rspam03
X-HE-Tag: 1789037971-692158
X-HE-Meta: U2FsdGVkX1/uP5hOnvvrS2K2daTN/BrUpgNoZz8IhLE2PtYXjN0ahEVltUW+jqAc/bjhW3CtEThlT3fyHItx9Yx3CnOrgIQWdPdnz53yJ/TVC2Oi+MHwL1fxe9DRQDRAAemNbGGVFFF1qmJ3jZBjpSSdlqSw/7MMpO/7FeSi4fVTsDCQE/DrMqp0jk2TsbdzFEuNf47GifvdT0U0D9DYZXLo7O2GznLn02A6tkGSLw986q/B+PsULWNJAUB31veezmnrOfdaWnaKmQw31m8BA46styxYY15zu3P3DAPYbHRwDWAhdPpsxdhedcWHqNQYeFF4Phdl8mT9aOhgwxbbuGnC8vrtWxK1V8xPmGKcxo1IUFDAdG5k0lRTOLFlfN3m1FQoCXhN2AUAdUvPzees57BCtRnJipRao+LIrFMwNa62+upSpjj+eic9klsFsud18NFU2UHA8MHv0EbtsxrvAjO9P6Z38Xjy6XrWUtxzaWVChKYIW8ZQPqm9kZWvWIw9vO1jFH0rIhESGXwWX2DADZdh+76ZlAvxxT7D35NRvTelbX1QX3XR9x5YDierfD4HQRLtkK+mxtsdmhtCOf1ydJSQKTzCaCB8sz4fP8PksuPi2IaG3bBsRtSu8giXduYpaZDXXIBaEfrkU8YRbGZVU2r31PNiZxuvKFuSdPp7YTRW3zJyBuxv+rK7wSXcXDsjKm4DQ7JmpwPaBh+si9/cnXwubO3XpXuF/TPJWNiqmXeXfPi7Ih6JETkEHpPD0vpJFUhCPDIDUwXpyi+wI7hn+f6UXY/CqH+ZQx7Elm/WAuWe6SQ0xBVobVsTQh4i8239q6lM/hz23wp/u9VmxgRmU3Y6iF8OsQsP5tjmTznF/V7aEQhHkQlu2XHU3xuj0IOOO5JJWRPKILgh2xTPZqr+bA3ORpA2QO8TN+iYRFrpLD/CODov8VgivHfq6KUiKJfahoUby7yhAW/twtfvFJu
 hG5drZJr
 gd+KrwScLAGnY+GQZWl7mGlReFa5inU8U/PDJExPuV4wdL2ajZzp+Wnl7JMwy8+lLL2+VpnHkrsr+4ukK1NW+WawsFnXIbFRzKAIZuV9WiPPNK/F2G6kw0ZnvgIuaWWIeIZtyDCgIQBWFSCLVFBkgM+OMb7ZTk/Cm8vR8gc8oG+n8Y63IxPkj8dXr+MPvQ55D/QVpGGDfCs0fPGSzLX3HMZ2XSBCMMVUFVbwOpclQul4RQwjleUn97BOh52LJ8CVyUfp1qtfPN4keiah2TCs3r9TDUmqgXbiYd0oxb/Mdlk8SfXg0X5mBQsTYlu5HVRvB+t7UqPbNKGh5vOssFCz+Ma9QdQR6eKFBZD5J/Jt6ip/EqPu1XIZryhJN89Gm2qtBpcoWCzTt5bp7QSelDvInGvlzvd4K6vvZzocV0i/0pkNnzO/+d7rSkzYnO/Aefu+NByK3+GOiO4GNq2+TI8pFj0oBnTFGA0ZiNqnOIOdvWj/Gor85mNTsGU9NS7v3364It0SpLIsDuavnJ0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 02:27:28PM +0800, Baolin Wang wrote:
> 
> 
> On 9/9/26 6:41 PM, Kiryl Shutsemau wrote:
> > On Wed, Sep 09, 2026 at 05:55:01PM +0800, Baolin Wang wrote:
> > > 
> > > 
> > > On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> > > > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > > > 
> > > > __madvise_collapse() turns THP off before each MADV_COLLAPSE, both to keep
> > > > khugepaged out of the range and to prove MADV_COLLAPSE ignores the setting.
> > > > It clears the global controls only, which is no longer enough.  A per-order
> > > > control overrides them, and -s, which makes the cases fault in folios of
> > > > one order, leaves that order's control at "always".  khugepaged then
> > > > collapses the very range the case is working on, and the case fails on a
> > > > collapse that was interfered with rather than refused.
> > > 
> > > Right. So I think the correct fix tag is b7f16963efe7 ("mm/khugepaged: run
> > > khugepaged for all orders"), because before this commit, khugepaged would
> > > not try to collapse this range since it only checked whether the PMD order
> > > was suitable for collapse.
> > 
> > Agreed.  The series is in mm-new already; if a respin is needed I will use
> > that tag.
> > 
> > > > @@ -547,9 +547,16 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
> > > >    	/*
> > > >    	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
> > > >    	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
> > > > +	 *
> > > > +	 * "inherit" rather than "never" so that MADV_COLLAPSE on shmem still
> > > > +	 * finds an order to build.
> > > >    	 */
> > > >    	settings.thp_enabled = THP_NEVER;
> > > >    	settings.shmem_enabled = SHMEM_NEVER;
> > > > +	for (i = 0; i < NR_ORDERS; i++) {
> > > > +		settings.hugepages[i].enabled = THP_INHERIT;
> > > > +		settings.shmem_hugepages[i].enabled = SHMEM_INHERIT;
> > > > +	}
> > > 
> > > This looks like a workaround to me. Shouldn't we fix this in shmem instead?
> > 
> > Good point.
> > 
> > It can be a follow-up patch.  Do you want to make a proper shmem.c fix
> > and update the selftest along with it?
> 
> Either way works for me.

Please, do it as a standlone shmem fix, plus selftest update to reflect
the change.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

