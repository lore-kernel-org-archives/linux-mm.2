Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBDF9C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 21:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 998B66B008C; Tue,  8 Sep 2026 17:36:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948656B0092; Tue,  8 Sep 2026 17:36:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838066B0093; Tue,  8 Sep 2026 17:36:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 562CB6B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:36:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6F4D1207D9
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:36:33 +0000 (UTC)
X-FDA: 85191904266.02.73DAECE
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf09.hostedemail.com (Postfix) with ESMTP id A73D8140006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:36:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="K OpgUND";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=wV82FlUi;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788903391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rDbrLWkii0++pI81ymuGxKLFDP2vxoT7yk9xrVDS0G8=;
	b=Ilp9uppuq+Vs5vc22e/IWMPxE++vjBzl8Iy/oSf59nfTyuQz+eP5Yq6/WBVtJMrEo99CuP
	1dA15MO2ZReQ5y0IJedv8e94Ih5CMt8g67wRqLgVQzyJ2eGxM3Nvbbaqjjtsogl2CvhWH1
	ZJQvBj5Yr5MQR5In6MDffUJiVD18/mQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="K OpgUND";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=wV82FlUi;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788903391;
	b=xdxDMjKIjbU3ze+RjQ5RUVCZRmsfMFSY5etqyYscrKDv74NR6yoHBQZ7aiAdY/UAwVfygf
	ZnnIb3mKnqAeycWyBqSni7AR4fBV5PqemXReuQLlz90fVt1d3qe1aGN4jxsXg2f5t6VdXA
	suacB4nWCp1M51Kq6L69CYwb5GNjlJU=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 79B2B13003CB;
	Tue,  8 Sep 2026 17:36:29 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 08 Sep 2026 17:36:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788903389; x=
	1788910589; bh=rDbrLWkii0++pI81ymuGxKLFDP2vxoT7yk9xrVDS0G8=; b=K
	OpgUNDeyogjhDImLoLAtUdF/3ZssahsLG9WdiQRBBDzG66H3Vd+NGmuS/thCVNXf
	gbo1hHSzcAiwpU8y7Je/zwCgWqcr/LXvqg2S1bZecJGLFwmyZLyFFgl+oOIgbS2W
	5Pm9hRvDtTrSG5CM0GirpIN+1DKYrXQT9NfxDPXeTOBMzr5Tvt3wZfxtfWgBNryk
	jV2WIyAx+y9mG/weS4O5Pdg5eOO1Tvy19V1KiHFREYRk+1HYRqm0sgjRX2W1JqBa
	sj2CIVsaq08lbdu+jCGnmpyGqbuy1amZ8Ht9WVC1EDe4Ri2rL+qB6BrOo8NX7vJi
	27jmPQClIUADBHHG8Sw3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788903389; x=1788910589; bh=rDbrLWkii0++pI81ymuGxKLFDP2vxoT7yk9
	xrVDS0G8=; b=wV82FlUiMIWUPqYpEWiPj1Pt/M0c9MKTpOyV5DsKBZjtRsRTVOU
	zTsqJfex9GRIni8/Ew0eJRvEmmpBLPJwKScHCeaZpX1f5j5Ex/1fKcnAYuLFCvER
	EE5XCGPNEM7W7iIPyLdYFUV6naTszx3K7C6Y4llufj5AAUgxRMp9UvXAk6GaiYLs
	vXXjfHsTgKMvHfteuzFTG9kweuqdAEwJhgWVR5c4l/CvIN3ZJ3NoCr+MTHoQ5o8t
	7CKtbE6HzwH9/twNS1Q/Ma4TsQzfx+Sst/Qko3xiA5qeR70X9Qi2L4gKcwphGZR0
	2txJ8F4RC8Y0Kaa8zX47Y/z1LCrfjjP5SZw==
X-ME-Sender: <xms:3H-gat8C9LpFlc5fFz8jxLsSwp3qIpFezRk0P1TU8IUXFb2V1Mw2kg>
    <xme:3H-gaiafVcGgtw8kf2CSA-PpZFVLMpiUxtlttDgNq-KDqerUR7HznKwHq4DtyMtq6
    vplQqI26H-g5a44KCwR66blgk8lEzy9f8zoUKyyz5jYcaXAZQ7itsPs>
X-ME-Received: <xmr:3H-gamFOcBhdWruI9XsUGG0NhzeeENajnqvFrWXo3bh0idqPaw7Tl-KF8iU>
X-ME-Proxy-Cause: dmFkZTEs2RLI7ynlmKvNumBP+mhPrub9YUQB2IUepwl0zaqL6vmAlAHuu9hDfPkzsmvSt0
    PXpI86qqrGdR+aos/9lYymlU9wbS9cEQVhvdsgaJyrJN8FURhOEtfp0GyCkiY7PCo/owg/
    +QdaAAFc5pvs0UzgDJkFJyziwO9UuT7TsvqlYGGCeBlqnSa2xNtoakQoelpLZeo0k25PAM
    m0GIcEhMVaf7ZVzu05/A9InZTCoLxYYIIy/gKTx6gBZtYrh2KdMJZJ521rbzuniB4KXnfk
    8Ivqq6+j7+MI0IGymvJ4rVru4BV8d7yWehuOy2Q2f4zvCiPF0FRhTMrKTHvFQ4MhRk1Lfi
    0YKx0KpxECVDHveerVIXmYguOP/shMUKufCJVheMoGqPSPsMBz3KHvZB5Im4zbOgD/NJtu
    zdOZ4KFWnLbzMAqVMaBeADXSdsJ0GpoL1/dlOKzaXExTDDlUqNpi5mEjVS36Vdkig0XNI8
    oxJevTtioI/63+2wzhUVsahMTEI2c0TSYso2Sx6//pXswgzPbg8e9/WZ3SYRuYHMYpfQkw
    77/rb0YixJC4CxbxclVc8eYVzafwqZhhiHmOKs4FNGGRfqWtgakrXZqXFY+X3E+TeKbepA
    IXl7oWkfIynnTKYXBonpxkLzeBN6WpzlTF+/KZeqTXIRSN3d38M+zQJ08WPQ
X-ME-Proxy: <xmx:3H-gahdXeRDgSN9GSnAaAAwCTt4zYJdsrT38jrsSUyRuDV3EzNx1qA>
    <xmx:3H-galJIb1WDBYBz-49_D7TleVc4vTGV5IgQYabhHyiuYiRi6qPYgQ>
    <xmx:3H-gakOCOCpgOI0HfHvAboOfkDa8U_pgqehjmVm_u0ODg5a2KKVEbg>
    <xmx:3H-garzM9-HkEVxYbQtJvNwUDfzy4nz6YPW_xDyBe150adtIGxB_sw>
    <xmx:3X-gauveQnzy2RkHRocek98vCKLfIMYzjtZin8LINZnNozRi46lKEkkq>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 17:36:27 -0400 (EDT)
Date: Tue, 8 Sep 2026 22:36:26 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, rppt@kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, usama.anjum@arm.com, 
	usama.arif@linux.dev, baolin.wang@linux.alibaba.com, nico.pache@linux.dev, 
	ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, ryan.roberts@arm.com, 
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org, agordeev@linux.ibm.com, 
	jgg@ziepe.ca, leon@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 00/19] selftests/mm: improve khugepaged coverage
Message-ID: <aqB_XMEUElzeCc_H@thinkstation>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908124102.4c874a8a63e50a1cc90e4bfc@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908124102.4c874a8a63e50a1cc90e4bfc@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A73D8140006
X-Stat-Signature: 1t9hqsx3t1ow5fa65in4cz739dszni3r
X-Rspam-User: 
X-HE-Tag: 1788903391-808329
X-HE-Meta: U2FsdGVkX19AzQa9oFhDd4IKStdlCH1kXQNhE8Ib/jevBAR/q1xQB4gfvv61cj/VYVAS2QO/2jixHYqri6fRgWA8NHF3xl7hdXhpkUhfW5Eny34X4bh3li5I/8JyHQg8T+nCyjuK7gVm5v7xCXrMadDcQWxSEVLDB1NiMbjK/IPU8v8quu+t/cnUGzuZWrerEyzdEKy9LGeP3aGvnpRGAgew4Zf6PIg/bAUkM3CR2YVn1DSWjFXlw8aFsch9GJ5d90sTSihY7LyJMOpWdGe1QE8gV6WqCqQ0GsBoAoip6ApvVkQFc9yAreHkaIX4pHpqQl1SWOVmblu5+ZhWEWkUQi1Me+70ttECwgtXy/6Rh59OJL2zfzY7gnOpJ4TDZfQSqExZe96Q0sDvgK6daNroq3ONMgjZkxFna83o+Uo37K5K5T/HOVRTF7vGXwBiPcCxB0tj6+4GT9CZ9Er8Z9I6IuNwqvXjUmtrMN6qE+IqWc/IVwIXLy9Fs7FEwMBLINU0w2wW6q1+W7myH6LcmZi/ORZsQLfWt2RLXXA1uhdhcoRvAi4C1vvzfWLGMIquW/9FPVkIak8DHuFQcn2LdW5M8vRqggLVnu50z4Sqx5LbQwEdg7TNdfWYnFh2Row0m6dt1BbCBCkTja4T+J8Its4vxh0tviDcbo8v22CNmV+KS2zsf5sfyPSWnSYsQNHSdmvdzUygA+0RnCAVD6r8jGoMW+aiMGyyqkcufgphgrEhHnXEzUg0B7SwnNV67z8gR/xMSYH3PqvAuujc5MItHN0YLPfZlnMUsapYiclyKCSQvtrW4eEZSgEL3+Y5XxNQw3Z83qzj6KFjM8t1mj8/3LSJ0DnvKgBdUBcsw4coCMD+ig13CZNRxopGutD+U44zH2ulooEMI5K8/aVizDBGlxucyB4R3Yi8ix08GxKKKXbZ/Hga5pBf0lIaZxgPNMaha2c7PHMrNi9rq4J6BOQLb7Z
 IYlSrm+B
 rLVbUHEkdEgUylgwBi6BDBHIVvDHjG7VFBEnyf/4+oSjPFPV17W3AP3XKUn6vmI+8VczWbFcdiEZcaE9MOgijsbKASNuvoTde6MvXfxy4KBvkPzsCsK0qWj9dqyG9JcPcxocOpbs14qQERtYiJYP2QQS/Zi+C6f4EeT9QMkaUlSczJ/rOjHXuKa/ir7YHlh4X5/IIAq2rwZvOKSrM4rJvX06Ju7FMHme3lTC7m8eJP0Wxw8bH0q/c5pYyyTwK9T/YnZK7Vc96/7gDKXwmi9ljOKDpvUzxClLqj2eCPM3D+ddB+4U46lv2zT+EoSQxBPWYIarwR5jqXVSNNhUBNrXhu9J6gVUo69+3YgMEIrZPkuyRzziy9QnOM6/NCOnWm4TrxZePWEZeE5dE/TS96uXoVJxmGPBSNN2MmUt2GehvMP9u5yHdJz0HFbZsSX28DlX42DaRsO1KnVlsRJFOESQooubCoFHkhnW/EglWMXj3KLivNHVmY9OEPr47fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 12:41:02PM -0700, Andrew Morton wrote:
> On Tue,  8 Sep 2026 13:50:46 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> 
> > khugepaged collapses to mTHP orders since 7.2, and 7.3 added three
> > selftest cases for it: the generic collapse cases run at one order named
> > by -c, with the result detected by counting folios of that order.
> > 
> > That leaves the collapse path largely untested.  The suite does not run
> > where a PMD is 512M.  A folio count cannot say where a collapse landed.
> > Fixed sleeps cannot tell "not collapsed" from "not scanned yet".  And
> > nothing exercises collapse under contention.
> > 
> > Close those gaps in order:
> 
> Added to mm-new, thanks.

Thanks!

> Sashiko asked a few things:
> 
> 	https://sashiko.dev/#/patchset/20260908125105.1510704-1-kirill@shutemov.name

I've replied with fixups to the affected patches.

Let me know if you would like a respin or the fixes in any other form.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

