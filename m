Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94815C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 597716B00A8; Tue, 30 Jun 2026 15:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547C16B00AB; Tue, 30 Jun 2026 15:42:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439346B00AF; Tue, 30 Jun 2026 15:42:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3F16B00A8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:42:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5A831683A7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:42:01 +0000 (UTC)
X-FDA: 84937599642.24.F7476EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9AB5E180004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:41:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ONzg81oF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782848519;
	b=eYcgH4AhpKAAjqYDppB++LehvGeGkkxq4+I6nlm9bvhh9Nfk2w6hrTLmvK/h+bY954OZVc
	BCo2XtpyW9AQdbprDech2nSMYoA4XLmPjt43L1vC+2OqhGuMLopc1hztkajQvcYUl+IB9b
	4w19uyYRa4pVMDDcfSSZUKIFJ7RzXEs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782848519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m1Hu7A4UhmYRhe1m1e8rBZ7Nl7tQc2Vk+DTc471ehKc=;
	b=fMAhpAGc3B3ssx8WOuazMCwp/DKRcbSaJ46MpT5paCAyW/sk1uVNzgKnnqF/hvZWcWWCe0
	65iHccGgVYctaaJW9V5cOu6ABlJZu6P4r123V5V+x2q58lWjnuZjV5vguHlFprPPUCY9Gm
	mosm+H7Pr0ROnqxaKSYCinYhxbk+/wQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ONzg81oF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F23B7600DA;
	Tue, 30 Jun 2026 19:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584301F000E9;
	Tue, 30 Jun 2026 19:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782848518;
	bh=m1Hu7A4UhmYRhe1m1e8rBZ7Nl7tQc2Vk+DTc471ehKc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=ONzg81oFk/PDWeX6IROp4+f0i7JoVDhUBuurseMfTapXHzDzE4scvfjRmBR1Mh/bc
	 JPRHWvBjPQLNz2zyKN2zBhSO7L+ofXep5snit5Ar5o2i9tzWGyyReUHPZ8Ab3SUTy5
	 kEc+FnQK46TIjTJOFW+lpGFVyH0UXfF6txN9b9KZP77d671ndnh1Nlrsy9NbGhcM3K
	 Ac108C2qM56ZZ0EAAxNQm/YCH1JTgX46p87ZaXmG7IjOA3QFct9v8Fl3OQxvtLSUYN
	 03YoYhar2ZLdz4v0dQQTz4e6gwuy0ws8PavxEteU9ssdm9Oj3TdF2qj5AsLtGqa5OB
	 oXGb0PC+wyEyw==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6609AF40068;
	Tue, 30 Jun 2026 15:41:57 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Tue, 30 Jun 2026 15:41:57 -0400
X-ME-Sender: <xms:BRxEahnk9vAGQsgIN0gDfzCM97VSaT9mhUyb6U-9dW0FIR3kdsVOBw>
    <xme:BRxEanpoqDpP1mOnnLuauLX03594Zsk0oNWAmvfBvkMM-AbdqzvSWxXzE-kgXFfvU
    S24raSm0Zg4Ufpk__-yNvzJBYmYlDCAPOPPpx5qL6w1odn1OPfHZZU>
X-ME-Proxy-Cause: dmFkZTFAPBwvbmhzGjVyCOgmT565eqnNKdGTHLZLtgQb+uinOgWLIybyc7yG3a/6L7j8v4
    GFcIM16Ly/rGLMH5WPvNN9UKC9df2+sY3hLbgqnac1dARd6Sc/VyiD2xvBDcJqw916u70o
    HGfaclnUk5OTTXYTAyRmx9XHI/tgsTHQwBzU5XZQrus2ULNbpSCd450sGKeI9ZHQrLMLEv
    x1SjodKGAGhTIiWLLi8PBMDI3d8e+kjbYMsYr8X2J8BXF1Ti2LMX70Cztn6MvMOUMYOgLA
    DmbQt5fS4p+YHTZoKlGDQwrKsYZTN8jSXgbL3eW2Gyi7GISmx70rtLem2O5s7BXYTYlOU7
    IPpIWfD978FhT7x73O15cs2u/X1u7UKiW65oJIM8HP8Ot/i3SRGJmTbZOoXaUpDbdktwFw
    apwjx2WOYYOBFKI10a+s4OHFqbFNWMQ+UZFHt+LrmlHnusJOpVZLzqwrXOP++Gx6x5WVg9
    8SY6p1s3rzWgVLkBZy3bvSK6Az5fuhyqMupL3r3teU3woKULQWedunCkcBC5h4o/OdL5Jc
    y2G4TIfEoRZRjgIjJzFJZo2aDsp2Yv0hSTIoXi2DAPFeNJwWmqh3DYzlDqbBXOl1R5vGXa
    Yvx4iLz2sThtMsoZAb0ajHcJSxew7+AeH285WR9ExaD0DS3gA6WX+SaxMeiQ
X-ME-Proxy: <xmx:BRxEakFDL5TGk6MfQRMEWcAKCP47ahS2OOaufklRbrkKhj2LS_jEvQ>
    <xmx:BRxEaoQnqHuyUuHfAuM0YwFIV3Gj8JN-DYlOdzIGK3DRfmhX7_cZCw>
    <xmx:BRxEatLh0a1lU2Jb20W6lBHPBiwnLvW3TojXYmRIlxWjWMqh4CugXQ>
    <xmx:BRxEarbWpdvfZgG-OO_bPxsB1lsp7AI7F5ip2G0ixC0WDqD8axR57Q>
    <xmx:BRxEan_LjzMStriHNNNZcN8u1KmPoCbD6ABudxejmBSXa8823mXxdCMW>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 42B24780AB5; Tue, 30 Jun 2026 15:41:57 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A9AULPwk-68B
Date: Tue, 30 Jun 2026 15:41:37 -0400
From: "Chuck Lever" <cel@kernel.org>
To: "Liam R. Howlett (Oracle)" <liam@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 maple-tree@lists.infradead.org, "Chris Mason" <clm@meta.com>
Message-Id: <a1500111-40fa-4845-8d79-0473e19bbf45@app.fastmail.com>
In-Reply-To: <20260630190843.3563858-13-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
 <20260630190843.3563858-13-liam@infradead.org>
Subject: Re: [PATCH v2 12/19] maple_tree: Catch race in mas_alloc_cyclic()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9AB5E180004
X-Stat-Signature: dcfssjg9ha86tdt1gan5tk4mnbq71jm5
X-HE-Tag: 1782848519-269752
X-HE-Meta: U2FsdGVkX1/d+6hPab0ePnNBI43CuKuLxMs9ObR4jJHIdx7F8+QepQ5OLsobzkZxn5tO/rDBqyXE01a7ZWocAcGs7gzXqlfJHB/wb4dyMTzAC3YM6jeOqRfYe67g89RtNLLdcgrhg1BrDbfQlVQ6q2whG75E7xsFGc8cJiAXtAv32eteJV/MNKKMSTpC9U580072gHgA9Pi6o7+cakjUmmfN7sCok5AMGU/DwN7saVfQDLSPMpWsgkVbWMKAQM9QaFJYNQeIaYHvoM3y1rTMM+t1Cwmc5++diOw1nYqtjWmGLs2JjDR2MMPezLq8lt+4CHpwUHjYwy3kuM+bZE/rAvhzZnr77fUSFDoTmlR+u6w1BzwCqclfinLUXat0UGgZ328fXDkGcS+ITVCyzZolA9cf7uR3Vp5vKSKg1ASV6WMhnKe81Zo9rN9xRTqNYJUzAPWSBhJl6zUnrdLjtXdrpvvvgzGE76iUs/j11SP7WVGJqsej4Pdw3Qu2a8PG8K4IbaKJiEVZ0g7HwT983NuenDpT7BeMnOOgpe4jHQSFzCQLatwaJSG1x7CVye+7vjDYjpbe0uYlWi0DAKs1SySYZ5CALTVcV1j+BwfCk+COv+TehNJtGCoYr+zInaZctRMI/AloC+oDEVju1TXo3JYKXEc6Ky0juOcIxSCyAnamR/nAq0DRJW1e1YpPK4tv+a2Sznffzu98soXIMyfgHzKr1LL/mk6UnsFwSVIjL366f98wZBVsbbU5b9Tjh/36O4oeNJGXm7rcCBWu18HOxICOvM7mdrYromwiY7uyfAC0HXgSIGjyEkdZIKsgR/+Ux4vsyrzGCf1GqzPiRaFWT5CPiTeHTqwtlQG5aa+a8lmwgDm1b+pT4Y5KSgwB3c/Mtjnr6MqY/IohjlaNtOz4dN1lfV70eQx1vD26CjIM+4bmXQMReMS0hg8Tsh4Cz4ZGQrpVjfjdeoopEc/k3AEDwZb
 30c/Euq9
 hzOZiEebC8etKDwGDzIFJak4Z2n3bH5SoV0mOK+U643lGIb7il8mtEoA870RFqzE4vnNI6oqXh4H3u11kWVqM6QFavz8ekEwYno5+7HoJNT/zk1gWQj7HWKJx5QGc9WSCbkOL+dRz18fSBYEItqhGuYd/aD5YnpGxAOn8dQzWO76qvU3XaKBgUviatZuP/vTOjurhsRzDipyENVnDOsuGOHES0Tv+gk9K0IpAfgBMOaTgQWA7LH8nZyQ9knymOPHJk7X8JpvK6Hr1t8psoeeM9LnvxqXZesq3kcMWZwjSP+5Gcyx9XUDZi2BJy+y2bFQmYV0lbdfX5bjNmMG55hVlLTXZileOfVz/sIupnPvOlggSB+AFlT+x1t32siao4MmmQ6QC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 30, 2026, at 3:08 PM, Liam R. Howlett (Oracle) wrote:
> If mas_alloc_cyclic() is called during a low memory situation, it is
> possible the lock may be dropped so reclaim can occur.  There is a
> window where some other task may allocate the same id and cause the
> mas_insert() to fail with -EEXIST.  In this scenario the function will
> return -EEXIST, which is not expected.
>
> Modifying the retry on mas_nomem() to re-search for a slot means that
> any race with other writes will not matter as the lock will be held
> between finding the index and writing the index.
>
> Moving the flag logic avoids cases where the flag is modified on drop
> lock/reacquire or when the write fails after clearing the flag.
>
> No existing users are exposed to this issue.
>
> Fixes: 9b6713cc75229 ("maple_tree: Add mtree_alloc_cyclic()")
> Reported-by: Chris Mason <clm@meta.com>
> Cc: Chuck Lever <cel@kernel.org>
> Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>

Reviewed-by: Chuck Lever <cel@kernel.org>

-- 
Chuck Lever

