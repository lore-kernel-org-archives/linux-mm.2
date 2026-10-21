Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29602606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 09:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EYe94fM1
Received: by kanga.kvack.org (Postfix)
	id 38EC56B068F; Wed, 21 Oct 2026 05:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3402B6B0690; Wed, 21 Oct 2026 05:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27D5E6B0691; Wed, 21 Oct 2026 05:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 032756B068F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:33:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 769EEA8029
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:33:51 +0000 (UTC)
X-FDA: 85346121462.12.95B03B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6F262100003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:33:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EYe94fM1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792575229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYJqufCjo1bLqz+aK1iPVMBINWSRhQ37F570JEgy46s=;
	b=zxbjcsu3maDJPnqdhoi8V5sOjVTuJXE+mlOKhPxaH5/Sxmq2D7bmqzVfgErNCvK+idyzu1
	Sd+BpXfJ8CJx6rQye5u/GOW9ikIFRzsDZFKWmHT04RDK7mYqvaTQUILyuSvHHUyPSyvawG
	Tq0pXO34Y4ffe5EQSelX02Oigj/BFqo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EYe94fM1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792575229;
	b=423nvRqtlAuXHijjl6p0p5C3EmstzLOzpgoMnKyxHx/7biAC7vxCz7Sp1yqOf5I3cNqMrp
	guo2x4z/SuZ3JpWDDxRxajVRI37uMgcT/YUetWpldWRWQnTRFLUxpeCiwfrZG/63wYIszA
	ntqxp7NTUqIS61P0+BEu5j5WmDMdJ1g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D0EC43DA3;
	Wed, 21 Oct 2026 09:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59ABA1F000D0;
	Wed, 21 Oct 2026 09:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792575228;
	bh=tYJqufCjo1bLqz+aK1iPVMBINWSRhQ37F570JEgy46s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EYe94fM10VflfuiWyh0fRtTXRF2etpia2o7owGtaW17OQngPYqf1FFbWQ4TdxFWaX
	 kN58+4Oa0liAqIjhZdUaZkOXeta4+s/9qKfZ63oTaElOeMcWMGeh6kh0K/q+1C7Rx+
	 23SiepofIqcdKEsQHPWFWpRLt0agroNAM/Skvm+zJcudIM31ZVyLkskIR2iEAC/ife
	 N//ZWi1taX/maHkbkqoDlrgpBg8h0WF1QwpeBt6zQ7X2MfiUjwKYC1s3N7bHWuZTKk
	 7cE6pd7Bqct88tSYWJcnea00bJNlxdxR7g1Be1Dj6nqiOPYIyeh85q3KAgY/YY0pSS
	 nEEySMChLuu1Q==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 788A5198003A;
	Wed, 21 Oct 2026 05:33:43 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 21 Oct 2026 05:33:46 -0400
X-ME-Sender: <xms:9obYaohboYwN-Oyv_9N85Kp-o0wdjPGLYi9U4Jweczwc1LELqDzlsg>
    <xme:9obYaqsL3QdoxJkBeG6XFyL3PEzUY94bWbp4Gpd0xmQ8yNumUr0spy20mE6rqHU5D
    CaSmdSwmV2uU5iL8Z2nh0ioNc4B61i49ddYwhMUfEKodpbjdF3zmRKr>
X-ME-Received: <xmr:9obYavbanvw097VxBxIs0S__UPCi9uhLpbUPxgBBgW2JjK7WULFQT-PkxCI>
X-ME-Proxy-Cause: dmFkZTELFEvu1GI3tSCWgCF102QEycz4DGBObmJl25RALQ3Cxk5ofZC3Gvf8s8pkKw8wfz
    MIDDiGFmvC5la4lnge1OoLPCYhSCbSER0N9ED4GpBoKpGz7WEndh4bv7BOgeiOvwUVRCR/
    t+t6Bbg5wofZxXfbuPq+27rXWuoMcBAKqnai+8s/ItcqZLefslz5xWPGlFZXk9w59ddRfS
    lfla69TNWQ8VJYTH+j9csyZ0v2bEnyxjaqHX/CyzEBaJaC2HJfTOTkjb4+agGeZXo5NIVl
    TIN6DNXr9+W/INW0ot2rVh3w3hzXZV2mOfffcl2i7Tr7XmV+OjdpS774umu35PGGHrbZrF
    f4LwHHV/pKAcpG1KnWk3qLd7hqAx4vW75ZaXvZxVEBRufae1pBEOqAaSZgy2wbxGORAhS+
    X1PisJTloFMAcI7O9VKA6/t1XFAG6lwYxSPEX5nNO8/+GlK3YSYDey4u2N4AsaYyocknWW
    yILBQAjv5VcxIUBFet4ZgztQJS4vqcYs2jEsgXvxUKoCtQuCz2iJc5A2tQPwqUhEdl64o/
    0T/bGgLxVs6savQTGo6exNpRdRYHMBOQC7Z96jH53GoGZo1Ap6aUhj8Z7HjVAW8EJe528U
    hQJ3cUj7LN/oY3crn+ERq9HfcQ06H/Bg8lhmGGeFBENRa7ZWccPKlM6QKLqA
X-ME-Proxy: <xmx:9obYahVdJYdFMpM6Y-l81MVaMHtBXOMCEgdlryQyenvztAo2tZjbGg>
    <xmx:9obYaqLUrX4KnopubSD9CBagf4buRpH7l4LAiqSzp6KNHrLApBJQEg>
    <xmx:9obYake5XjujuGVgvp3pwHdY2Mu3jYbbQr3hLKlWWJPtfkpXyy0ZHQ>
    <xmx:9obYapYKEt7BVNoigejcPFVE1CX39IS8AeNMhJJJ2G6N-URof92d2w>
    <xmx:94bYasVbphJ8-7lIuQ7cRPykn1m_tE8OKmgcEDjojqMY2NsWAww3TIbQ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Oct 2026 05:33:42 -0400 (EDT)
Date: Wed, 21 Oct 2026 10:33:41 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <atiCG2iPrHwDznSZ@thinkstation>
References: <20261009125503.126202-1-kas@kernel.org>
 <15a9e03e-c748-4e51-b8cc-583a3610c897@kernel.org>
 <20261012192834.6934ef85444dee4a60d6d876@linux-foundation.org>
 <as5q14OsbK2CmOrh@thinkstation>
 <20261014202936.GC371161@cmpxchg.org>
 <78238103-3a7f-432c-b1df-bd14d7cf4bb1@kernel.org>
 <atDMN5MoGrwJNpAj@thinkstation>
 <4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com>
X-Rspamd-Queue-Id: 6F262100003
X-Stat-Signature: 1s54pq1i7684obazyz9t889dkk7s7jzj
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792575229-453430
X-HE-Meta: U2FsdGVkX1+dfXkNHUCr+gFsM83Wa8Na/hFS1dVOFWuY+ZpYMSNlgKhElkxZdtYi5SK66HbIaai1H9beLh771X5ju11CeMgAZSS221xQBZaeghudqn4+X1cX3fY1hOGJbVAoOaaWLWYuobCBcrrdNfC7aO8Pj4jvNW8Qa9ZZNmxGLeCxqSwrKAGN2mmxNbp2qKiBd5Vg+/DzUpZowelZH81z/g7tP9zEk3Q/uvFa0vDuVFBgnb8oQadMm8Cuy2Rn558Bhnfm65pA4meKPBuRSHnlE+rAb17LALzAQSZ6Nk3oFooqX7vofPNXbD8LnmR7a4M+rj2t+rN1MkDz1T7tfg26iBY7ZWUxU9RdIQZUaHdu4TTEwaEWU9rqGSacMa2tJ4STetDrVhOYKiCjnTZJFIzMX0YPq6RBjy65mtBm943dMIFkO1wsK0KAlRGukt88n0a0xTAzBmVu1Ob1AVAyA4KW0w9bpsMDaCpLIjxz53Mbw0nNVrNgljibr783fWD1gzWvYmToZp7wFycw8/bR7SFmGL6YA4QZxxHrFHhfGw68f2KHQZJWjOGaklEaaUMaCWPwdLUJnjhujEzRX03sbGy4xxWd0NFBvDuzCrmD8SAqyqHXfAnWuKJT2N4+BpHsQBanT+PEWQ0O4rPkyOKSE8PxR9HHC2JtlGJPIjnnz+DPSEYi1v68l9apdgAfzDIdEepr85TqabuNw9tcIXxMeIbke+pb6cJudRcEhoCC9Sj2NSJBE4xmQ7aqUlCUKVDHRW7cne0yVefCMGVUMkun0wiDXjoakSp4Eqcowq33Opspj0Gomt+MuBP7OSoABHHyMBlEL1G/H8py55oXDGikDC9c93InH0k7YQQP3m+rkGgoY+NxgWdSuTPQZW8CpU0zleeaeUQzSB6kvGHpbGSzk7jdhRByW8L9xCNjI3vCTOGXUtF6hDhvn4VdxEj2LXoKBgAxoaU/btCW0hdTzX1
 w/P7oSC9
 NKqDuqC0xmZyDU914g1FIib//wUOmX0OniKsBLE96uWLuGB6rJGBLIiujDkyZJUHvsL3QAqoNICo4+EzVFySj0YUTa7paFHxRXlMO9BooCdrImdrMJm2VgpM5grEQohD6iyroqKuPE/SQ3BBY3DxgFerQGKaC6fUEKsXbt/6UGXs1FxQw96eSTqsAwv2ucMaADFFqmg5qaBVLpucqiDJpjgCNMWhrZPMtRPi/HZ4CFMF0+XrSnFP0ccFJP7EPW3Su1QXKexwBV9EZf0qtwfBl0LB9Dn6auvz5QAVyHIpTIafh/ry+9pyOOSOEHLyOKKePIa7GiXKE6hmnu4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 12:28:40PM +0530, Dev Jain wrote:
> 
> 
> On 15/10/26 6:25 pm, Kiryl Shutsemau wrote:
> > On Thu, Oct 15, 2026 at 09:16:36AM +0200, Vlastimil Babka (SUSE) wrote:
> >>> And agree 7.4-rc1 with CC stable is fine. Sadly, not sure if anyone
> >>> but Meta is using the feature right now.
> >>
> >> I thought it was there for a long time but it was only added in 2025 :) At
> >> least the enterprise world is slow to adopt things, AFAICS.
> > 
> > I was thinking to propose a patch after merge window to make defrag_mode
> > default. Do you think it is too early? I don't think it is ever going
> > to be truly stabilized without wider exposure.
> 
> AFAIU defrag mode is not going to improve mTHP allocation success.
> 
> I ran a synthetic benchmark faulting in lots of 64k mTHP with swap enabled,
> defrag mode caused me to enter a warn_alloc (and 8 times more compact_stalls),
> which didn't happen without defrag.

Could you share the benchmark? I would like to play with it.

Which THP defrag setting, and was the range MADV_HUGEPAGE?

With the default "madvise" and no MADV_HUGEPAGE, a 64k fault cannot
reclaim and does not wake kswapd.

How is your system setup?

> So perhaps bundle the default with pageblock_order eagerness etc.

What do you mean by pageblock_order eagerness?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

