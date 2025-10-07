Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B7BCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 00:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B1648E0006; Mon,  6 Oct 2025 20:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 561438E0002; Mon,  6 Oct 2025 20:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44FBF8E0006; Mon,  6 Oct 2025 20:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 330148E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:35:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACF5545A4F
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 00:35:43 +0000 (UTC)
X-FDA: 83969450166.30.CE02260
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id A69C416000F
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 00:35:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MwjjNKG+;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759797341;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmTEafLLz555+9PYYyX6aK2mRmjoUTzEwUNlTBIE748=;
	b=MDKGD5BB7nELoJHjz2qHFkyHng/oKS3xYVWJHQOIHddZ3OWO6L9Ja3P+b17MiYlXk7VnWJ
	5GApcVCPOa7g0w3fCx7IWkrsSjhYHDW/qm2s1XPx8aMX3HoyuW0g8/LgGkUX8pOMNyUFx4
	NXhg1MIYFt9QzhLgjyrVertw2T8Js3w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MwjjNKG+;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759797341; a=rsa-sha256;
	cv=none;
	b=idPMv2dXyZgJiQ0NOx49QCQ2P+uuVG0HRoO2s0p/AiB2vZIiWQA//SzQImv6v/dIsHXCaC
	2G9zP65EKgqw2KZUqKpk7j9ZB6XDxSRix2uxLoxObvIptqYd3DbZ9KMHYf8CBvRYNvB01n
	IpkcQVKGyEFVG66IVjVWpXzsPJ0nmZI=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6364eb29e74so10766297a12.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 17:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759797340; x=1760402140; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RmTEafLLz555+9PYYyX6aK2mRmjoUTzEwUNlTBIE748=;
        b=MwjjNKG+PLdulI0JG02/DFl93nrBLf04KTA995rZqVc3Gmx0G//EYNh9jcihdrdc/2
         yl+NfvH3Su3i4Rjq1mMURvwxvaoe+JjTa3BJyMdIt1Pbh92bMhzlFx1oKMajNgNUnfVV
         Mkkx7ylpV1t85xL7mmsogL3BJHagExWWNLHJCdHhhNH/U32nAKMIcXUOgZzpZTNI4Pu1
         haJdm5jUzcKZ/iGGUkTJmgXTq9OICIbOIyqfECA67gLS6islH0xr0YG+dN4poKL3Dym2
         +IuHfcpUudeX9EM0lmupd7YVOO5IbdsN1BwYm8DXHXAxbBgU+TIpMLQ3+KopxwWyaYhD
         z9yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759797340; x=1760402140;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RmTEafLLz555+9PYYyX6aK2mRmjoUTzEwUNlTBIE748=;
        b=rluN6BRvatrfqwlTFuZ2ymASGv2wQqDTtIQr/epgse7T05voxyrgVGI4fVe8bnfM2z
         P/6M3sBz9TtEIwfaFcDToMF0MeAfza1tYm8gCH62ZP2F3nxGWzKRm3+eN500V00a2kPY
         WDeZBCzeunkXj6kKqGtr2IYyk5tzOnEHnmpuzz/ZKekWV3LXSkbEmP/56Ge0rz7L9Htm
         k8TGL+uEbweDfjb8EeOPygJ3Wis5TWODKuaeqGcAdXSc4jMDmLfT4a8sZzxDBMHJiF50
         +WZrQmLrc64to3ZjkCQ/qWhfFVw5+lijk7LioERvyDxOp11nYLeqmNzPMQ0lYnqo3rf8
         WaSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWup8/J4hK+I/+xjOYobN4HjpVG6EdSZuJCewiyAL6oU7qb8hlxrMOfCEFCaasqf9W6HcEULvCF0w==@kvack.org
X-Gm-Message-State: AOJu0YwmARqG4nZy1dUFZ7dUr36AxAqQ0peBM7JHYi3t7xOr/7LFgNqI
	3Y8UvEab1pttZgUcgGmXhBfqHHyE+3jIxTXg3venvl6RfkyUJdXTQdNd
X-Gm-Gg: ASbGncu3qzds48ZQBvlhxDiaAa0gdT4BDC55vklIIBhsEk5o1SC1O+ryiAUWFXrdzTV
	IKXLIcaTAol0ivvEAPgEviPOTegodpppXMUlXmScA4UV7EOSk937W0isLfNkg+pd94juPG9P4YH
	q6Elq3n4d4dF2fg5+I3o7oCmJizyvYoR6cN9xL1AFq4Oiz4CO7BxUGi8Mfy+WzrsWgFU6fhyCnq
	ntu9NMUdTmeMk+J7mBcQXuSDZRWo1cNB87hWD00admjiU2MSdEDMmtkhNAPIGAJMZ+BfAxnJ18Y
	scOdfvMmlVWUeHCeBF+VMbajHKwIQc0+jMU9xHprs8ynTeBe1acscrAfMul3u7qBD9rVEZedW5I
	WXH1Y5nsjXX/o1n43WFESesxQCaSX/lQRzEnp2OJwpjpzomYDSQ==
X-Google-Smtp-Source: AGHT+IGTr+zz0fZdhcPlWyAVEVhw1eLda7v8W50j43hQzJxysrhCRGQQh3TjjtHlO7I8gMpDi0dgVQ==
X-Received: by 2002:a17:907:9707:b0:b09:2331:f14d with SMTP id a640c23a62f3a-b49c429cf0dmr1613887466b.64.1759797339928;
        Mon, 06 Oct 2025 17:35:39 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b48652a9f11sm1254464566b.4.2025.10.06.17.35.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 Oct 2025 17:35:39 -0700 (PDT)
Date: Tue, 7 Oct 2025 00:35:39 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
	richard.weiyang@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH mm-new v2 2/3] mm/khugepaged: use VM_WARN_ON_FOLIO
 instead of VM_BUG_ON_FOLIO for non-anon folios
Message-ID: <20251007003539.evunghgqxysojtr2@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251006144338.96519-1-lance.yang@linux.dev>
 <20251006144338.96519-3-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251006144338.96519-3-lance.yang@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: zwjqdrpi6xmy3yomdnftg84j1eksd3uf
X-Rspamd-Queue-Id: A69C416000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759797341-793295
X-HE-Meta: U2FsdGVkX1+TAaa7CVTkXXhml6rlMSauDYeAbp02U7San/92vlzIsaokhtI8QbaYoGl/ZyXKtM1dARyMzrDn5aUBsBI9pnkfOCvT91VethJAljXRAAu+zdUuW5cK7rzygySJtDxNr7kcBv+m58OdPv0Q9SaivYhlByz7hbCDPu7JBedubMIoYek+pdFdLrI9UNqOYKEz9J31iYhtPkiSxER2/TMzvT+fxEJFo013cf+CkrKt4XFIroDUNQMEHd7FFW4jdGDJaRuuXSSU2vMLTiECa5G5UGiH2vY1xPbwN+TflnW8J4rNRQDDjm1iow9v0fa7mykpxVLbH33LRlcr/qA8fjhEUh83FpJ/FvBpfMydKiRcyvtGXtrhe80CQU8rNI4G1tM+FEQ0gX+F2h9JMibsdGdT4JXwQmL7qKHsmjKHdzI7fqybNfUozrPHOkauR9v8BPERQL4GjEiLunVhezZvcIOqS/4prAOxQ/mOu3MLhrBEsAUhWw0Aw01u3C7T2SxABQh/aBp0JptZkt0/b+0zolJB5NQG0TPUx9t7OhBdf1y2gzwtEO15oQbX/g2qB3J1j1SvhKbmE9XsHMnqp+wfiJf1pqxMGmZn5rukTNatcHBUlOVMdcFeJl2KJUddYYq+mYHekP3hBQaRCyVFKESz9WNkMUoKZBKUk93/iML8kcHNXi7K1tfyf1YWqIoyciLDSOsdG7DR4dNKZxW6abHszNBHSvIwBpGWMBaAaRbUkXqpco7dRmctz+DgdXYLAPVvP/EzSmVxFQOOJlga9hGoqArr738CAhWrbx8yoZ66bvG3mfZmjvzg5FwOvb1Jg+e4XedSAV1877tz8Nd6aTFksZmQT71olt6t44nBOiCp+va+VxBh4Bl7UXtA9HlbuwWi7lDhU4sN7G5qW2gXDteVpjyro2+jIa6GWTZp0+LubColGCcbAYbi/nIdLkgVupendS1DrGXCnTLP5V7
 6s0msb3s
 IK4Bf2KpKc7VIyducNjdsNt5plOZx8urxsvh4tgmcR6XTOpxb0vzr2Gtotw8kkOhzO/jvslGRwHjQZZ7eJSelNXEA361t2eUUseNBDVAJfgmv4NXZH5DbE3FHE7vckg3M1PdQJ0CwPgEQeeCwZFSkNVwabM7t9qVjiDbc9RYGfeB6zMvxyWxAARx81Ox7gvpzQf0RxexZ+4hULWkoViIarKU/KcP2SGCVhXl/AF8jFbFyrjL0XP9Pqyx0U3FDtSEM0HRBrGCBJi3BqF9A9dH0CacNYCoIfR7EnwBPaHAXLe+qAHDwHt9Uf90Fe+L4eT0alnCdlh8MTwaOGShqPW2eGYMtC/H2eujBz2nJjMI0r8Imlg2mcPHiPoFgaWyhI2kroPzbJl15GKxLIiXtyZolj3iQ5L351l5413XgRcKmLUP7P2pnv5kTpjFTELB5lBCTHFPk5hKc8wOnndCFDPHG6aj4lbqpXt2+0Eum4ESdiDXUBKNV7AGyO4okkheaJ9JMUmKL0HG0ecYlvRzOIXp3i0hPuxZJULLIodG3oDk7vuhJIy29VM2NA9Nl7ofeAeJO1bS0xFhbwUrI0Ui12woTdlEjIxYSa6nk3bsjwmmUUD5C2goJEddeOXLcOZL7WPx853/lxuEpTLUPRKzKK1osIe6qA0/FfbxJblLRnsqT4AFYRhayw1OWZeADFeq42T9KoMw2c/Vu9YGKJv0sAUEniD58HFyeap8mbhn2D6G9dk5haklK/+brhXzYW8NrVYqftA/DKMvGU7rVwkzQa6mprwmf9lbn2m8rGbC77ReGq3TPZV3XUQXWwvdGi1T5y6HugsxXIN9c5MdbLmF+HNEFPz1M8liyfzSyB9clfZcjvXInPYJ7yfb8pBdmKRTAdEIob8Fw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 10:43:37PM +0800, Lance Yang wrote:
>From: Lance Yang <lance.yang@linux.dev>
>
>As Zi pointed out, we should avoid crashing the kernel for conditions
>that can be handled gracefully. Encountering a non-anonymous folio in an
>anonymous VMA is a bug, but a warning is sufficient.
>
>This patch changes the VM_BUG_ON_FOLIO(!folio_test_anon(folio)) to a
>VM_WARN_ON_FOLIO() in both __collapse_huge_page_isolate() and
>hpage_collapse_scan_pmd(), and then aborts the scan with SCAN_PAGE_ANON.
>
>Making more of the scanning logic common between hpage_collapse_scan_pmd()
>and __collapse_huge_page_isolate(), as suggested by Dev.
>
>Suggested-by: Dev Jain <dev.jain@arm.com>
>Suggested-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: Lance Yang <lance.yang@linux.dev>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

