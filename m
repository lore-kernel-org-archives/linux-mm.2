Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A00BFCCFA0D
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 01:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DD738E0009; Wed,  5 Nov 2025 20:44:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E478E0002; Wed,  5 Nov 2025 20:44:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF528E0009; Wed,  5 Nov 2025 20:44:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D79168E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:44:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 77A0E4B400
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:44:48 +0000 (UTC)
X-FDA: 84078488256.30.D861621
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7FBBE100006
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:44:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B8Wwah+5;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762393486;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rEEJ+LqV/J689MN97nUNzHTLqbjLFvnlgtqVatgdXXs=;
	b=40kADe8XvMQvmlgseiW1C6S5ZsWNyBG/zANyfQppYs0fj4aEqdlurn0KNCl/E2uffK2ero
	2hGY7atzneOm6jUaK9ZzMjqZd6QYt2gj+n1TLQhwVSpOiVjswOAiEBzRm3iW2bvn7q76go
	75YlYqwHPRdVVVohfhY+XSbgjQ8lxv4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B8Wwah+5;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762393486; a=rsa-sha256;
	cv=none;
	b=8qa+AQ0efTE2p1jyGMl6QL4M/0ueZ9ZoSgxArbd6wvYqiYWnpPUNWN3pTLAo+pmv+uvjVR
	eEQRsZsekGK2CHKNE3sYelYoVcsWur+/jaCXY54bZZV7+oulduO1yXnXZm3nn6rOAWBK5S
	y3TtbvwIp3hJwFYZGqTQ5F0TJ5Myl38=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b7200568b13so77777366b.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 17:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762393485; x=1762998285; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rEEJ+LqV/J689MN97nUNzHTLqbjLFvnlgtqVatgdXXs=;
        b=B8Wwah+5RwAUPGwSGjohxcx+4LW1iycLHRfdNu76C1RXczsQYfxl4WcsOkyAFDsjy5
         airsndn6rjHSePlgMj85w+VMT9QFnWBg4rbo3/WGL5nrHo6W4RWk2P7O6gtuccQrvsNW
         QfccVXP1ORB/3OF7s5o536dKRnPj5n37mzi7O0UAz76BMpMkwvDxC/pF6Oei9G1IHW3i
         GWgCfu0X6BnGUFUL8z4eR23oAFjKS6kMEmuMo13zZZaohjMArxP2XjhguJo6xPDeBvd0
         YoXoIN6bqwMCWSPr6hr3pOC6WbvS9yXr7fuE4A2IpqG26wowW76jxDztbOmwd8qUdxIP
         gALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762393485; x=1762998285;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rEEJ+LqV/J689MN97nUNzHTLqbjLFvnlgtqVatgdXXs=;
        b=Y7WS8Szq+qsQPcMvUixztmMU67fV+hqeQtPYTRa3nOwzWckgufbOpAQw1eibQgVokj
         7/aD+wwVP914e9+gDSVnT+EEOv+A2yD5MuHEqMzTqyqvWWzk03eRGZmks39ltuB3Ax+j
         4GAk7DyhLe5ezgsFu5X+/sZAwBzUmHofvPy/n/OlrvPEd/VqhnL8mp3yMd1Jc77hcDDe
         CTPkZWsuJhmcjNqiKYR8lcStKjXcTZTAdT/UKoAK6iwEXCn7YUxuLRy6cQ2aUxQ9OA17
         M8XUlL3hTNKKMXSVlK/3RQShJasMt6W8trc1LKlz4PlSG97Gh7oCKuxPM1MnnZLxGmC4
         vaMg==
X-Forwarded-Encrypted: i=1; AJvYcCW0i3lfDWnsTlT3cibSNsTSFfdu9NXceP6ea5ZrQOdQK7abuj61lQHuN75d4sgQ/pRk1KMCc4lGDw==@kvack.org
X-Gm-Message-State: AOJu0YyGasIofFHfvIlEbPESSdF5F3JJ0czTK39Z9AEkPjqcI7Sjle4h
	fIliO+fkO/ZayExrff2WBuI6xyBMI8DSbBXqZXlDYt1fv9rKyacQp12P
X-Gm-Gg: ASbGnctE97P0sl8a9GK5HqctB2NHuZMO1QfjHKfx1XBQZ14Oyj5rzBvIjGs/4BTVBa2
	nbWWJ3EdpdWVrAd4yZbfG2Q4qL8VkQPmZs6bslAYltomnLL81kWRrYzD4ndSzRug263f2x67efH
	a6iNkjacn6VqAEhev6WLqKcJTfuGfVr2Bfc5LsdzjBhRMSG7Ph0Vky4YZ1skHDVuKE1OBMaDMAV
	zyJrUfyvxxodG/2WFIeHjF29rvkmvWaXNUOsjB4G8tPoAx9qZjPoD7FQmt+972TdL/QCx3/C54P
	hL3k11Q9puWvIzVzEeRit1b5BxRvSxNxdFvhhDXGsXox65c+mBa+uPLl/XBJszaNsLIPxiPzXHO
	l+CYAM+guEJYLe6hm/fgtblLLsBGoqPFG2W85k79IHwvoOQSZ1WX6a22Kc7uoIrhXvi4AJZ1oJg
	LXiIcUVqWeuQ==
X-Google-Smtp-Source: AGHT+IHJEYTNNMqTgGZ5Z19ASHC1/aHl2q87qeR2t0TYHvehAhnbl1q6Hr7yQiLOC3CnEXe8R0EkYA==
X-Received: by 2002:a17:907:7241:b0:b6d:5914:30c with SMTP id a640c23a62f3a-b7265588257mr472200766b.34.1762393484633;
        Wed, 05 Nov 2025 17:44:44 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72896c93b6sm94181466b.69.2025.11.05.17.44.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Nov 2025 17:44:44 -0800 (PST)
Date: Thu, 6 Nov 2025 01:44:43 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix folio split check for anon folios in
 swapcache.
Message-ID: <20251106014443.wkurq6p7ofhsffkn@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251105162910.752266-1-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105162910.752266-1-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7FBBE100006
X-Stat-Signature: 6m7ooxsiu8i4rzkycji3qpwqr79akwpr
X-Rspam-User: 
X-HE-Tag: 1762393486-351200
X-HE-Meta: U2FsdGVkX1/NsnN0E3X3h4ubt4yHKafJKbTIwFOmS0weCXQyXJy5nszNiCg6lUsjAEDKZln3hw/MVerzqcYu9g2ulnKPudYgyZdjRqzqRIYJTy3+1Ex/sjz8KYxDeAnyTHTlEMOh9OSnS24inhp25yzNPnrTXiARz+2TOSe16Xeys7VTtzuVtFhCm/ipLq9+E2PnOXO4dOe99EvtRYf2314MYDuhC2cEtYqHmpR3cOjA0R1S2TGr2Ehjf653BmYGNrt74rGggFf/eY8B1Kiqww9W4htGDTkuMPl7mov6Z874dQsTevIBs33sdohaIJxY1ck3C+HteA4gp7aBcI3AQY6efJR8xSRuNYOre0qTXlR7Ph+xghAMcNowQwEqpi3B4h0V2vP6MocVfzz9RdSgsx5jKqvqGw0Q45PrR5vmjxYtZiFTMIOtpPqyqBoyr2cuQ2f4JW5gaBRakaaIIWa6rJhp1WBgwPtovltUJ30U0xbcpQ8E21t1AOhNmnXffR4DAhmMe4XCCwzMsJkA5vH1iEHaL45zheBV56DThRbn2R7oo0iJ3OWtjx9H1kLc6lHiHbK44fn4oTnm2dYHpaK/b2+jMwdqFsWEMhI/B+IadrVcUCoDLQkrdTZP1iVAA2VpgfE5NAhqkBi3iDFKn05qYWi1qG5dHc2CJ03XBICMTX/zgTbbvIzepx0Zxi7hSnUwXNWc1UYF2XlPf4q9gUeSg7tdU+tHNCobEAz63YhV7WZPFN9f0tFSBOLadeFy9nXj1z5g6U5bdhRd80DpHORBz1oq5Zu5iVrGHyP19mU0tDxFZRIYV2v34f53sEKf9DAtSIbCpwC/oMFRQVZ7Q4C06BHi7P2ggByHh0TtcSexOPpPTl1Wd/AWz5bU2FwGzdxgwHXpjFFyAsrCWxKPtDd4VwUkP0tTMMNNPzxMAxxcuJDvtErppR+SiBXJd3R+Trfn8qdE7fPgAGpHtu5d9mb
 RdFWqFB+
 z798gWdnc6PcJ41TTE2CuXV+pZwmNCGJ2hC0OrQpZaNxR8oIh8ig/+8t0ldrEiDA5ycgLHyNfPO2q5EkYHnsFURAzNVMgCm+8qlvP2Qfw2bhWSzFSoAq7g3Ujx2wuwX72zRbIo9m1WCmzwXiwmbr+U6wfYNrX3QiFfsPTltbrJICgKu1a+Mfx+EbaUbVTRZ3FJcgczxRBMklwWDXnWF33jWPAxC+qf76mD45dkF2FO39ph6rzN71qgTg9dp+Gu+zkyY3dc3feNmjW0MSjbs6VjWV0mrCEeXouvCpbXpW9OEeShD9nNhxaMZ+1KxrjulDXcnXIn7SG+DEOeoeOGIeVNqhSGlWcP48e4jVF0Mz5c8RogqaCyrEB1Oct1c6b13KtYru7hnItY+bul+bxCF7kigZ2F0nFIiVwOrGfwHZ+BLcGyJ5wQbFTUTpY2cJfi0Dkb8fDwliX2d4Czxm0eHSXFiOgVvAHwF3C2ohI1Lj92vCy1TXvi8ZWGp4nR5AkjHR6Q+sgyfrlL2x9TuTrUGly3sh9+rgPx3YjJzv9Ydeb4V5djWCrAoCgWxGjb1bf5BFfGXhiVrVfBIkdG5vnireohfGkEEYaJHtJw4cryJLBgzmZVnUDlr47JpIKttqAJ39ojU8SAQnprx6dO0lR/3hhoK9xfv4uP5cdm9+1ePzm+GPVO1R65rCTcE3DN4LZ23rrT8+YFmzXwEbzHrxO0Gpzky4N6TcCu3WGUMwicfYCfoHPDyiGquDyX/edv8bZoRO2Z+sJ9PKeli+NJe32bzPZmD59aNnij7HZbVlP4ooMu0n7pU6YTLJ1JimFvQksWYHYru1J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 11:29:10AM -0500, Zi Yan wrote:
>Both uniform and non uniform split check missed the check to prevent
>splitting anon folios in swapcache to non-zero order. Fix the check.
>
>Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-uniform) folio_split()")
>Reported-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
>Closes: https://lore.kernel.org/all/dc0ecc2c-4089-484f-917f-920fdca4c898@kernel.org/
>Cc: stable@vger.kernel.org
>Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

