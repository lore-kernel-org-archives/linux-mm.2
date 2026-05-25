Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48D5BCD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792906B008A; Mon, 25 May 2026 11:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76AB56B008C; Mon, 25 May 2026 11:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A75B6B0095; Mon, 25 May 2026 11:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5BFE16B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:18:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F110FC0162
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:18:12 +0000 (UTC)
X-FDA: 84806298024.22.31CFDC3
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf09.hostedemail.com (Postfix) with ESMTP id E9C0B140002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:18:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=ZgwucYs3;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="p e7X97J";
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779722291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNbeMvEzyPh7sPx47CH3WFhZNyDg4LG8isuSFxUw54Y=;
	b=433H0Wms8y5+zDabVBMBd+8UYnSIL4rSxYeolVXp4dStXXIYRnGVEwdsOJput1r0iFnGpD
	qoYh+OOm/7t1mX+JgpwJmvAw/D0PNAK/gFH0RV66aSj+8TKxAC4wwott7KBP/uWL3Htkh6
	jBVzr04pNR3jPQMpqr1a5PLu42lAiVA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=ZgwucYs3;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="p e7X97J";
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779722291; a=rsa-sha256;
	cv=none;
	b=rWSYP+Hs4xJ8fIZBB+YA/SD+Vi/j42trp3pRxqey83KSj25nPnubzTf+MJeZFkindRG5NB
	esR1JLT4ctj8NqL/NZsOQPm5AXqZscFkSxjk/JE7RT8aDEE33gY8RgnbN6l3+0dXM8tr0s
	g5dVReGMVoREdGVsS6v7kxVjB0vKe6Y=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id C4F2D130008E;
	Mon, 25 May 2026 11:18:08 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 25 May 2026 11:18:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779722288; x=1779729488; bh=XNbeMvEzyPh7sPx47CH3WFhZNyDg4LG8
	isuSFxUw54Y=; b=ZgwucYs3+R/6nBszPKkbyaaLOw1OxtR1O2hV7axbTFh568Sz
	yqsraJGeP9Mh55L1umBu45pVfGjtQ/yY2072ude/j+VUiLp0wKnBKnBzffmQTJjW
	/o6y8NhmakYY7QpVtA3+0UuERBM+v3/1jaJZBBFSMC1KzrWelj74dRlwGcnhe+2Q
	GN2vBFdJcoZAEObvxQ0cpPwUMtznPUF15RUOW6bBsvNRbXOw3NWrGeu1rUdtfPCP
	KRtZ7RMKVOisgrU2X5VinS6AX0Bw9rksA6Pq35tp4IqGtwAUEZ8SXNVzxRdItopa
	fE1xING4NpeXknYeXNIL73nPKFDhfUVaaBm1PA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779722288; x=
	1779729488; bh=XNbeMvEzyPh7sPx47CH3WFhZNyDg4LG8isuSFxUw54Y=; b=p
	e7X97JBh31Sh07ScqRqkEf2YOrHHOUgWC5br+p5O05641zAF/bw1oOiSl51scTkL
	TTBmGNhHqGdy1A4ZQphhKCWRfADUQ+t/4v2R/7gCyxE8VyFGZqB0BFfxYiMZECt5
	GrrCcw+pm3XCSta6tGdeiTs3s9gf3/hHzzWt+SNV6NpvKTfyuiGTduzK9uFAXt3U
	b4qeVuqbEhqzu1xePnxNMt8BNrrh90Z5XxK7fgL1BZ1WU0+Hni8lr9GeW3viOxc1
	33a5yXoApOcudml5GCuNo7lCtONMBZT5XBC8Ium0/KFoFE6btbuQ20GO+4kbrrMD
	ncG4YKOPipnNo3bmpJtjA==
X-ME-Sender: <xms:MGgUajFAUiJsfhbMD8cHUarZn4-DaghF1cg8HubDqerjMlMmmi53vA>
    <xme:MGgUaovjOjPg9H37IzVGtvI4xGytU93RUdUMWdKYS2mPACUQWau6wj9cV7-ZDTeZI
    AJkFJg2Yw9BVgjFiCOO2xbNDWiiCX9AFjI0jxlnxjn67DMoSi92tQ>
X-ME-Received: <xmr:MGgUavYJ3acQQt61YkqqwotH0qSNFWkOLpKjD2k7SjiKN9gyPnPRBQWuhJJJoA>
X-ME-Proxy-Cause: dmFkZTEQSsA+CxVWFlgQbg+iDCxnTUddRJf1SNUTKP4UbEAr+U7uFdm1L5+NkcBqlGZsgL
    pWKCoEhxBJTNaYSbHSylQV/0lm3jZelxuBNryUEz7SwVEtnBFzslpWQY8GJQqg2vsw0Zz0
    QbZjSZzpKFySn6GqmOLPPlHhCcbMIJ4g8t5wjZhUIw3xERy2MPRsEDG+tKN/NHyTPLO7qG
    MNuhuxsRfncOHiTNXvffzzZm0c3vhnS8L84qdlFXa8gN4MF4U+SuBZ8q2TZuKc3/FG/FpB
    PVSHHPoh/Er5NdABQbI2y8OVtNjciY+F6ctFbe2E3mJ1Jli9xJbNK2RTsh9eF1N7wmLMer
    +EdWIphgvjcbs5d2AJ59P1kblBevKKM+MdC/ufRfH/YKB+uf3079AfvZnMPv9gPK+9Ntfn
    PpICwq40BKLb/d8mAa73XLYvg6gtbWHshle5RMxYTC8df9j0imwSTBIiiZNqtI+TjNBtKT
    ZQIQqfOSRANa7gCD8G8tiOC6+LZ7tar2QHfd/1bAJDIQ5U/MJrqJP2t9drRITdX5TOGnp0
    moO9d+bPUiX8QPtzfu+FHjuFZlLwUePpENrh+Up+d4tRLtnf7kdtSthSxLCCd1z+swEhAZ
    ZOGkGRExuVavjoQAIPsmxZtMQE+r1r2JvHWnywL01pE1anfn209CZp5q3vKw
X-ME-Proxy: <xmx:MGgUalpLt6qUWtQKAom-JJcSBYEe2hkrM3mIBsKUp29hEwzNSK0J6A>
    <xmx:MGgUampwvba2qMEc1z2qQ2iA9ZydNO8pumW3dVf9aCb-ZN0PGE_usw>
    <xmx:MGgUaiX5uzhzrMtUHH5JFosvi4v9Lml4r-i00G28693pIcTmAs2S-g>
    <xmx:MGgUajQ6izxbSlGL9PDntG4Qj4XsHDLOT-cm5F5mV6PSR5rDB5YKig>
    <xmx:MGgUamW0W6QRvvpVR2BPEw06UwSETR2oy1kuoY2zLWaGSnhCceUiuVyP>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 11:18:07 -0400 (EDT)
Date: Mon, 25 May 2026 16:18:06 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 07/14] mm: handle VM_UFFD_RWP in khugepaged, rmap, and
 GUP
Message-ID: <ahRmty2nebDOvgpt@thinkstation>
References: <20260525113737.1942478-8-kas@kernel.org>
 <20260525131923.11A1B1F000E9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260525131923.11A1B1F000E9@smtp.kernel.org>
X-Stat-Signature: p4wr5k4t3nm9t698f5sgsjn1y8gnwg6t
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E9C0B140002
X-HE-Tag: 1779722290-540069
X-HE-Meta: U2FsdGVkX1+OkCrlji+tc8ZBIe4DLvj0+WtFvoFv264SglUbuPHrZC+1kbjtUY7qc0mfeZi5sBpC+/cJBG14Ux4wDBj9M01v9KGFK78k224mRp2fQn6MpBCR0VS5kKii/U42fbnmU14qL0iCOyeVaoUSdryKO9cUJi8ZR9oT8e0FIq2qf376tuUjCRB6MRUf5bzQNO9ZYT43HN6jAcMR7kWrBwMyIegYngDM1/Kc5JaO932MVFR01ShcwskQSSWP1ivrQbx51Lk+dR08Mfq8N5npqfCPQtAtysw4Jih2fMpyfQLJVY8iSVOAyVXRYCrUXU+rWlJ5XpKjmW9cze5bSEDaAAuBZza/jydIxxyrR7Zxn5lV+f0f30Ot/gVsM07aKTAHXzBNxRrrmneL42IB2q6L5o2IEha2Z4UUBLsnsAz4VtNMqqu3BAszSzzYkp4iHjwOmnIll58hYLHzcLJAhiFOSFyvfZlhn9K7X7JbdvmG2TQ5fIRmvpFzNDA+fiPZ0fM/mTe9PmkajewFs9+pREDX1tPWpP2Fy4u+0NkFDycupMWu7YlwKLfPZFLQxlIgtS0oma25enJfRLhq7wNBGgm00j7E5ncVK+fQe7AVk/sT6+A+EFkBc2OrpGFkuvI6pvRAOFFM/6/DN6pQpftNHgQxmiA0YbqqbFmwo43mRdBYXA5ScjgZhdP0Ez0KVLmu90+T5TCZ0kPKlYb8o9EhjxZD9kKbNWxYd7X6+ph4KfaxcCjME8xA8/TbjWzgy0/CoFdWW397LT+JqXTDiPPYQeB0cdYD7x+RGya9uVfizfYqbPKNT7/352Bnrp1EuVcM9EFqmQi+EiLXnVSvsPgszjKplo9N9cfN9owgf4LQH5zcBQLY+WHUX6VMWswvkqM5nVl4yk666OChD6hGQ1yVnsTVFSw990lr9M6oSOQ1it++wy8t8I9XGaRmuyNZzSO4JVrEzywFYA9+/D+ARTo
 AKmsc+I2
 q/Ny5teYjX+5N2433KRzav6gxtJPFhetl7Z97zQc99mPzFUrHu4gaG50x13Vp6ZHwEHoOCmsTyofp7OrMEg0plRi+XBKfxrjAQBk374z3nEUfrDfXYLkRGSco0+VMW0BjNg6P/jp6TjoQDRc1LQ0bmGcqcXlzAS82QeQz/5NnjOkw/YxtTry9CJ8jcsdkTY5G5wgE3Fbx4KmdGPcyjDc6oMAMBoNUN9rGLMK260EYUEwSVu9ZM4ZhakLfhqkqxVGkQlXNNOdP6ekl+sYDAmMfgVJdoY0Ncot7j0gF0jMjRkrAodbc2fkUwOtl5poLf5GUxtCm5o6rQqtXmONPhc+aG/TNLPzM6C8r07JnDkypjx//wrMAZQjGEn6fk5cVAcV5S0JwXFDFndBmz+Eb9Pqa/eakwY7URvp3Bcp33b+2wB95EnLtBE1emlrkAIw1oV9kl04gz1PIA3iq+FG7Y9oCXaXe3HqsZQ28pVc2+3m4iCFk3wKK3DLC5ZC2tX/D7yXfku6gCFXY84ayxisSDAQJAkUwPAKgPNfsnroew4PTnfWJXYucD1aLz5ZKK2l0ZywxBJYsWksXNpe9KV1X7b8KEUSKcr4jSzDoiCWt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 01:19:22PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] GUP enters an infinite loop when using FOLL_FORCE on an
> inaccessible (PROT_NONE) VMA that has VM_UFFD_RWP enabled.

Confirmed. RWP resolution restores vm_page_prot, which is PAGE_NONE on
a PROT_NONE VMA -- the page never becomes accessible and FOLL_FORCE
loops. Will fix in v5 by rejecting the registration up front in
vma_can_userfault():

      +       if ((vm_flags & VM_UFFD_RWP) && !vma_is_accessible(vma))
      +               return false;

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260525113737.1942478-1-kas@kernel.org?part=7

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

