Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20AD3EDB7DC
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 09:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69FCF6B0088; Tue,  7 Apr 2026 05:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64FC06B0089; Tue,  7 Apr 2026 05:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565F76B008A; Tue,  7 Apr 2026 05:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 481EC6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:39:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5FB9C1AD0
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:39:53 +0000 (UTC)
X-FDA: 84631263066.15.E10B0FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 167F3C0005
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:39:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j72U/l2j";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775554792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4uMxWXLCSmOPy4bwOD8UvwxXR94ZCN4w9xt2xR1q1k=;
	b=8mJJ/tomeGcA4Zhiyi8eyxvzE+QzTXtEqDEsKW9NpNHkc6cO7F61q8eGnvd7R70/SFX3ys
	Kw+pQRgIYQ5teK+p9qY5ZqZkPkRRCS1rEhLkibCeHCWyDFRGx78dxZm7tA/n/d6GG82dS3
	JmGtt124/AYEZsxgqdTK3X/wGDFBtRo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775554792; a=rsa-sha256;
	cv=none;
	b=rbduaf7liEbRxwjzIgoblIZYc38tXpKOTMYMiTFnNWAVW/aOducch7FAMxUbRqqJD7p0Cx
	gEaMyqvdv9xX6eTMGsP+LDAXwHC+7QmxUp/U0MM3upq+AxmgWHC2B4+uNNznTetn3CMrNn
	lLvFpKTn322ucJFhis+VvZnHmrbyy7k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j72U/l2j";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A37860120;
	Tue,  7 Apr 2026 09:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D637C116C6;
	Tue,  7 Apr 2026 09:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775554790;
	bh=odGMnIpFBMdOZdkEpcy186hS4VP32vzK5H0CJz+s7PE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j72U/l2jUmzGvpg2idJuL4PbKxM4+5Q9aym2tM9e3zmPkOLSPu3JVlRSixrkmfzff
	 n3Rv8L9ZwpxZHY1d6JYbazSRbYaY4ABQabk07Ljj9a4G4/7BdT+8pm/OxVPIRAi8xe
	 04dpg+T2rm/fQzaUXZ5FuCbNL9AhfNQQXLwXJEFbvkXLjWEv0HvPHn2YYg8KFNr9pg
	 q2TyE3FtFQmGfO3K4HNFMlCweRvASR/QrmaMHIqcMAQRaA/maajCJOKtphFiAzWbJ2
	 tObNaW9JH77bk4FsSaCIizJ24kQ6SgPoBa6MUc+z6dlOyR6Ni5OM9h0Kud0IAC2OFF
	 AVJumIve+vHBw==
Date: Tue, 7 Apr 2026 10:39:46 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: xu.xin16@zte.com.cn, akpm@linux-foundation.org, david@kernel.org, 
	chengming.zhou@linux.dev, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, 
	Michel Lespinasse <michel@lespinasse.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
Message-ID: <adTQH4WdAqGQPvXl@lucifer>
References: <20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn>
 <02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com>
X-Rspamd-Queue-Id: 167F3C0005
X-Stat-Signature: t7fbxoydjszymqaz93kx6j1txdk1e6d4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775554791-786208
X-HE-Meta: U2FsdGVkX1/U/gLN60NwXo8dNuKMXVvW/sS+uob0beEpE6yNRjMTmUWxJjnja/J74fRUwsRo12rT4QgEZaFYYY5nnTI7JaM3rVlSWFM0K+4ascItfUw0mer4gTvJ5DaMFDYmNM/X8P2N3fHRtAX5Jy16dI9jen4d44+Ld2rxzdFJVCsQWzDy9peazHlZSSAXK45fnAEcwXW5erNrYwk8+SLsDG5052RwztzWSrrG2xmJZGwsTPyc33ZuvNgvs/TnqcU3ruw4TK77Lp40LkopST6Aq6nAsI9s6UUl4topwLa67bv4Cx23VTY3RdIc+CSTjqlGdbZKCaIE1kr3cJstKFs6AXiVZ+9sQ3U1ZeMgERStbFOc4blgjD36kvK9PNxPuEi/9Y7rwKwwRl+NNSLLwAwDgvWY/9BIJ0BVem1kc9YCANxHswpqZfu1YR9ujAVCVElg5jlDILbNWaJbPw5T4YLwcLO6d41BCTame1kQrOiqgK9PTs1rnpssXlDJ5oPrt/MzioHhHTdXw2vDFl7XadtfMsiA4Pi62/DaQd2IPUSzRIc1PSn5CxnlKbMlPcA93Gu9hA9oILun3knkrifEMzHVLo2l3Bnd/WSZNFGOm3PcSbdjK8Fje7BKv7un9cVj/8vPr2U5gUARamF9Zn0AYJVMRpyC0FQH9+p7NktCrXuMtEYKvfIPp9+Lg9VZmLIPtmop7rvXISAuIgPDV8q04OMfiGK2F0CnnXc1hS/1ZNTXSJqDGcuhpSOxZEE5x7DZdmiCmPkvFlBebJsQBZw9EdALmFKgOp5gMOw1I4B86k04wy+MyP+3OQEnIKNo/2/H0MlGh9MHUe5GsN1R6a6Cq2yAwtujcWIqDbXyG1ZKpyxxMlv8Pb7AtJDYapakDqy0SXVPrPksfDXbml1biwMseDSTy5+ddTmpWOdA7m0O+bTl8y5johDF/z5gvEgnyZuNfXjTnEP0IQLavPzjnan
 +O+CGOND
 MWrTlBAHZbRjmWMoS4YkxWDTJdgMVFuO6KIAruCcQDwmA0klR8hgWb1gc6wonkfX8B/6jIKRIuSoSZxnkfijQtxF2RAtsUI7IZtR6vs4oqJESXqzgP1RQIJdKOD6dTMLRvXmEFnal5Wf5NbGplRxm0/IudO7iA6P9wqkDwO0L19fFbKA+gU8l36O2ICPTx7LoUyoNo7S87uC4uO0vU41v2vaDtx2vlzub0DrSWYpoH6JDSZuoMerKEjFis3XFDnC1O8TbKJnjGiO6+1OVk/r/qso9Bh0//K7kK7DpNzB1NAHIi34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 04, 2026 at 09:44:14PM -0700, Hugh Dickins wrote:
> Perhaps there is, or could be, a cleverer way for KSM to walk the anon_vma
> interval tree, which can handle the mremap-moved pgoffs appropriately.
> Cc'ing Michel, whose bf181b9f9d8d ("mm anon rmap: replace same_anon_vma
> linked list with an interval tree.") specifically chose the 0, ULONG_MAX
> which you are replacing.

No, I don't think there could be, and I wouldn't want anybody to try to
implement any kind of remap-tracking that might clash with my future work, not
that I think there's a hugely sensible way of doing that with the current
anon_vma implementation.

>
> Cc'ing Lorenzo, who is currently considering replacing anon_vma by
> something more like my anonmm, which preceded Andrea's anon_vma in 2.6.7;
> but Lorenzo supplementing it with the mremap tracking which defeated me.
> This rmap_walk_ksm() might well benefit from his approach.  (I'm not
> actually expecting any input from Lorenzo here, or Michel: more FYIs.)

Thanks :)

Maybe I should go read your anonmm implementation... the mremap-tracking is
tricky but I have it working (modulo, KSM, yeah this whole thing was a good hint
that I need to look at that, too [+ whatever else I've missed so far]).

Bandwith is low for foreseeable future so expectations of not-reply are probably
fairly valid atm (and yet here I am, replying :)

>
> But more realistic in the short term, might be for you to keep your
> optimization, but fix the lookup, by keeping a count of PTEs found,
> and when that falls short, take a second pass with 0, ULONG_MAX.
> Somewhat ugly, certainly imperfect, but good enough for now.

Yeah that could work, it's not likely that many of these would be mremap()'d
right?

Yes ugly, but anon_vma is (very) ugly.

Cheers, Lorenzo

