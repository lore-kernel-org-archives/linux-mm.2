Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02615E81A44
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 17:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EF626B0088; Mon, 16 Feb 2026 12:04:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3736D6B0089; Mon, 16 Feb 2026 12:04:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27EF76B008A; Mon, 16 Feb 2026 12:04:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 133806B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 12:04:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4C7B13C2FB
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:04:02 +0000 (UTC)
X-FDA: 84450942324.24.EB3F2EC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1CF5D18000F
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:04:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L9NsmQIP;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771261441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9QTRehhIk88nkFpqbBLeG3LnUhkOiXioBOK6h6OZvfg=;
	b=CC6/31MJ4c3obn4eEz6tA4ZeD4GpxgGdplb17M4yVAkMKUHrdijIV9kRni8Q5/OaCoLCEP
	vWwDYWZbn1gLzdDTLXCDbHMmpjQ/QAxJUSO/O4lyt1/hXaGUYJc8UfzYwqWbFqGRurwD3p
	fpOEH7iyxUakEgaEEguI3IZN6P6pvF0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L9NsmQIP;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771261441; a=rsa-sha256;
	cv=none;
	b=nJckiNzHoSjytAx4/qZdy9tfb9cGQWi9/HmYr3Boey3dUCVup0BJY/VnYP5y28BYVWzDde
	nG713omsl82bVBB0oBDXxoln7IlnR3oPdx4IObIWlczP4uO6inswL3/KaQWTkRYbYRI83h
	qnQoqWgckiAnZPN0Sb/qPprsbUEUwtM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9QTRehhIk88nkFpqbBLeG3LnUhkOiXioBOK6h6OZvfg=; b=L9NsmQIPrPCGWBUkd78r442qNZ
	xzognI1NwllgD57v1pcmxM8ZaZAnKYGIB9zMTUCG5PnGEt1ydy90m70pxVbSz4h64nYfDfV8MVpLn
	A4r0tFpgYbK+WxqB6d3aF1jL6LGKks7JxoDVyeeuULYfCCC7YPNAoDRpC7k9hZUq8AWrQXh+XsoF9
	ukwsObtNu7+zg76oSYJsALDOOsS75/eApMok1Ce+p3D/CZyzoz3lLwcXkV6NDsrZAFCF5NToHv62t
	z41FxGWscy5/miBL26JPJ9EbtqG0qEV64zYFJA6X+pHerdqnuSs0luGf6L6UgaEEW8FSDvuFMUMtx
	1auRD3NA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vs20s-00000002k3c-1EKW;
	Mon, 16 Feb 2026 17:03:58 +0000
Date: Mon, 16 Feb 2026 17:03:58 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
Message-ID: <aZNN_gdhEuqIOz10@casper.infradead.org>
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260214084514.2842745-1-haowenchao22@gmail.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: zd7znc394wqgd95db37ggkbz4phcuqrk
X-Rspam-User: 
X-Rspamd-Queue-Id: 1CF5D18000F
X-HE-Tag: 1771261440-67904
X-HE-Meta: U2FsdGVkX19jE5DdUptEshWT10cIrxqRncHuJymdnS4W6+RHpRkatqQJmAUO7XNHaEzOTFYu7r6Wp6PbRqOpmucryiV4bXCIpxijkoXhPgQ9LBkApKGc+Q3KSNKsd+jVVM7nrvEu+gqpPAWuzqzV0rPdii8haiTVqS4e0GHuVy05h6v9F/STamovvavITP2CEF+GAylv1OXV9iCMmi7Se54RqZnHPX+HK5vlUtvUaTnY/E2zXxKVHA0kLiZRI+fmf7T414QuyTbxR5E8FcqjXHD1whG8VGaPV75gmFT1pLT6nTJnC7gi0Ksxfk1CaASdC1bJ7gPFpGRtm/vl8ASZm26qKVXudolth3XK2pOP66pglNdbvAblzeX2EIFZxAhJaREXBKJMG3q9Z87/zVIXgBNM6SnXmUhB9CsCxqlS2qcM9xdbgl37aSa9vGZF535hnMoTtRZM75WeLQxFrgsfLbY7tpMIJEA0Ch6LsQQv91l6iZqFV+gkmF940MBWv1RrCor+GF4GKC8GSfH8jTm8OFjoAxE6JCkXhOy9Om+v78e0jcafn0EF0WEKtYOBLtyuaTjdW+Dh0NWamXRtcY1rgEfl+DNSJdyduk28NdGkD2K78kuyI477iS3ZUCZobKbScaUxU5AFDT7ATHltLqF2V05tXpshaXctuz8hISseAbG4aJbGtICoOVay3+plFLu/XD5cCMNRjp+n+ydq6znYQ0Vq9SJB8EgI3rORTFCVqs7t3Zix23dHyLFa3gf60WaoIE6/JwOkndkL4Y/nX9uACATIE/mqw7VdI/AUbJmjSEvqzPszvx94FBJmWgxWTLBbTyiCOMyMG5fUEw+lzcMBH9iyzDnymKcrm5Y6jkHSVXZf4UqfbD+K8ymRAlxAzmJiM4xkKl7wSex5FJs9mPIMugiHLAlq7nELPypgjU/VL3AObbWUqPdU2KAUgtGsBBYWC+17VRdQ4dFqPZQlkWG
 EaGsTjhx
 Ob7TEyloi4sHnnwbLMcwOTnjCvKkHGRejmMzaYZnAHX9oP+OIn0t3EDJvR+4KulSJS93aDeRHowIPAUSSA3ALXPBFpBOFI6aTxYAs4MdsHELcEedxo5dyGnBDVKFRAvXSjuDn0OK7kzuZOyzi675ZjRz3QhVSsmXdaG2x/Wi3ZnoFv+QluWSX/FMGs1SqQRXqD76xAkihSyTu7iQCPzb4B0VI6Kca7THY9BNPkE1CWGBXRkT03hkqLdKZNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 14, 2026 at 04:45:14PM +0800, Wenchao Hao wrote:
> +		if (count_zero_page && pages_identical(page, ZERO_PAGE(0)))

Pretty sure you want memchr_inv() here?

