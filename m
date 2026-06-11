Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76FCECD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DC326B008C; Thu, 11 Jun 2026 08:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98CD66B0092; Thu, 11 Jun 2026 08:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A2A86B0093; Thu, 11 Jun 2026 08:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8D36B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:16:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 377021405CB
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:16:10 +0000 (UTC)
X-FDA: 84867528900.12.250E375
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id EFD2F8000F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:16:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P+DY3/BC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781180167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zlj3YkxcT4JL+4VXrSfCWKR7kiY48sRG6NdujY/94Qk=;
	b=cGDqjmErd8cPZn6cawLgXowAr6KFfikPK8QqR7fLT8Z4859mDJNgCMr/EDRFpFy3HcRdw7
	gvNdMmAUyLMx5G1T46+XxvQ84G7jUVuhzUUyokYrFCam/t1MHiH4g/CdPnIS09KptUp/ls
	yg5lbsTwDa51dax4jSsGj1TRxhiYUcA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P+DY3/BC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781180167;
	b=E0q5/YRkD134rxt3QTKAZ2UZ9jqQZs5g6HnggW7MDWkdO1kDL11v7XF6gg8aK2zOWk1aZ+
	i3+T6jBLerbPW9g9CrOEvT0IJ3Q0APfTtBSgnmIhkR6qns6TrrhOqN8erYhADz1fbFwZuM
	uDmsnMfawniM+GtqW0J25xzFBSrBf4Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E503C4404E;
	Thu, 11 Jun 2026 12:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313911F00893;
	Thu, 11 Jun 2026 12:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781180165;
	bh=zlj3YkxcT4JL+4VXrSfCWKR7kiY48sRG6NdujY/94Qk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P+DY3/BCEBZzRZtbE52GFIAtKo1zeDJvzp4GMY0SymOe6AJgpPQdfX5ktQepYtqgQ
	 07DhZVeFK3U0nNwY3kswiPXQ9KMRRiILoiweLuIltMRr3GgupHTG2MBlwHjuo4dyeA
	 uBI0De6byfQAVexGT4k206x4knGJ0YKPxRC5tFPO3TD3FZLwq/7hXRTQhfIF2PpwZX
	 RrxBv5x2xTEMP74xsFCjCeq2A67rGbhY6QGfjHT2iBGPres6PNrUbCme2WhDGqe1zZ
	 oVDvddpK+3yxpRcktB3tfmnPecjszPDWgBERs1WrIzmgMKruHciUeJm839zQ4kqouj
	 1jVs0Dh6475zg==
Date: Thu, 11 Jun 2026 13:15:58 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, hughd@google.com, 
	willy@infradead.org, ziy@nvidia.com, liam@infradead.org, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/11] add shmem mTHP collapse support
Message-ID: <aiqm1hK353jXmQgJ@lucifer>
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
 <aipSe9Snx5x0esQx@lucifer>
 <47f472ac-0b07-4ffa-a3d4-04fba621252f@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47f472ac-0b07-4ffa-a3d4-04fba621252f@linux.alibaba.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EFD2F8000F
X-Stat-Signature: bo83tf1aujk9138hqmr8jb63piahgudd
X-Rspam-User: 
X-HE-Tag: 1781180166-483914
X-HE-Meta: U2FsdGVkX1/VpUdryRpgmJJGy63vEYs8AGj0eCD0fNfDX5iPgO4qAZaVrx+P10gmc3WF9Uwuv7CinEGr5V7JXF6khKx3CYR909MmB3LPUUJC4cQCb666POORWhku9IHTWhxrDkqCVxhHlkptrqkJB5De3lrEGVNf/McpK/fc+IJ0dDb4GDF0x96njpw6lBksnSJotTlmk8jIJdf9uem6vK2GQfTGspkd2YQTWMsivbkKYIunbl7qK/PjJOuguOgU/gDW9GD7XcrHidAnVlV8bObhAY4lId9kNHVK03rP6HuLTwmkxYbUQBaiI8hBQ15VtZi8lydQacM2IiBjhMPk0wgQ1E6vSFlzgVmt0hEXiwucCYOiI5ASvOBgeHtT9rkfSebYcFQ0ktXXjXGT4/rZGAtmg4lma+3DMMSxWT0s3upHyrBgw7vnujNU7Fu4pKIZhXYeCKUrokMtxvEVSf5bpvfe58x1j7cEAcWEGqDHnORSHezNy1glWfL88lg18CTdOqONgo9EBfirhhKHWaNYvItAP82U1YjnNp7VTmmllFVOiuZ5YxT/WURF/B5/H6y/RVA9jcEmb8wy5OHBCOZOavdNqukJL+vpM7hKUfMdkAvGrluQD+8dwuaYX64X5LJrZweNk8UFFy5h5QzEfvAzaSAcuDT5bAbD4TVN6O1iqqzLgqW+5SMT+/CfsMTuNAv3gYn+WB5Fzjzv4x7APwN23lzxt+huK5Z7L6OLv58M6egMTcAe3dTn3WK+emjgjinU2PBaaVvPbpDFJw1cETlbloxRMZmuMIiU+DezcoqUFEr1e9dMSOMq9Dcy4GQGcT8OoSW0C+r4VvkzTbXk5Qo4elH5NHhl7yH+B4Kv38A+U5SgMwhDhFF418gybtBWwrLqhH2NZD56KZgO2Ppcb1PenJTkpe/jXBvm4g8Re/15udtcPMeJSL6XRdKrKiFjJw4kadQ8ESb3VMIEJDykfXd
 cdv2vZAg
 tBftOmJEHtZm6VXdamNHc/sj5U5b/pFl5B6EswPNpmagIzeD+bFuVUgc1QKlU+zc3rX2LCpeR1fhA8AQMaxv/sGdAkTj4kHVfOml7XRGa88n/Qitb0Gb3JT4qGkGh3qB5PQr/0HhTvA02gF6JFG3gJ8hKM5Nt5ZFwIB342oyoFZsuafPhRgc2nrpURLSdJGAjp+AW9D56FjbStx5AozYk3DGSZ7V3aXPznpq0xgZTLDaWW0ybNeQ0dYvWcIBZVbnV8XBVXkM+b0HX6Yda/KCsGsP4tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 07:46:55PM +0800, Baolin Wang wrote:
> Hi Lorenzo,
>
> On 6/11/26 2:18 PM, Lorenzo Stoakes wrote:
> > On Wed, Jun 10, 2026 at 06:29:08PM +0800, Baolin Wang wrote:
> > > (Note: this patchset is not targeting v7.2, but posted for early feedback.)
> >
> > Hi Baolin,
> >
> > Speaking broadly, and to repeat what I said to Nico - I'd like to
> > re-emphasise my _strong_ desire for us to pay down technical debt in THP
> > code before adding any further major features.
> >
> > Really I'd have liked to see us do this _before_ khugepaged mTHP, but I
> > didn't want to put Nico through more than he already endured with that
> > series :)
> >
> > So I'd really like to see some action on that before we embark on any
> > further significant changes.
> >
> > This is no comment on your changes, just something that we really need to
> > address in THP generally.
> >
> > Will try to give some detailed commentary on the actual changes when I have
> > time also :)
>
> I fully understand the current state of THP maintenance, which is why this
> is an RFC. I’m not expecting it to be merged into mainline quickly (but
> thanks to Lance for the comments).

Ack, well maybe you'd be surprised if I didn't mention it ;)

And I will try to have a look through on basis of the technical changes!

>
> Also, as Nico noted, it might be worth reviewing the mTHP collapse selftests
> in this series firstly? as they can help validate the anonymous mTHP
> collapse path for future changes.

Yeah that sounds like a plan and thank you for writing them :) more testing is
welcome and very much appreciated.

Cheers, Lorenzo

