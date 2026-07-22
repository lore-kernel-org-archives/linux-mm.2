Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 636E1C44533
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 08:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DBE56B007B; Wed, 22 Jul 2026 04:07:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08CC56B0088; Wed, 22 Jul 2026 04:07:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4476B008A; Wed, 22 Jul 2026 04:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAA5F6B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:07:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E4CA1603BF
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:07:58 +0000 (UTC)
X-FDA: 85015684236.19.0F0ED3E
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 72C0480003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:07:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YyYLa4G2;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784707676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QgXrRndMwv4SCCcQfojawc3oaNrHeDFGMLAKvOvBthE=;
	b=zZdHP3cKnTPbkyc8sbV7zrYh1Mm4oOwUyZn0POLPivqI3BWQLWglE7s2NX1kzrDuTLIHri
	Bgr6EzJ5a9rTRe0/Gl25XQjnW+E8C9SyhMRcAAS0N9Ef1SArbyeauC9unN+aCD0hFCMLfR
	ibLCx9r16X0TA8Lxtj5+/SpY8U4Fjm8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784707676;
	b=puddywYFWrswT68v3Uf2LYVVzgXKCTid892Y+u6TeoNXJTi/0Hw8mWtGp1AuIfKkjdXCgh
	4+1Nea/gIKE3UxdCHr5FD7iv+g995PMyBIALY5DQW48jStt+G8duEynLTLJHC9ieIJ8RGo
	CJDsvFogyWIcLApdB4AocHYVNpIyuSw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YyYLa4G2;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4798bea72f9so6451146f8f.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 01:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784707675; x=1785312475; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QgXrRndMwv4SCCcQfojawc3oaNrHeDFGMLAKvOvBthE=;
        b=YyYLa4G2wnjBHWUntKDg5627fA9qfdJAPvCFFc0BowCI5VZVdzPyF453cKtZQi7U9z
         Q/TWnSfYJZ9Cp5V5cegiXEFgioV1CDqwbnWGJ/bHbhqgcYHyOJCo+5ZblcTZKFxvwPfS
         6hDLFfPPtasJJRJ7FuElMLAV4DQR15zLA5l3yGn6SgW5MQaRq6Tp65mdfBP00YSjXFrQ
         1l23xmU1N4pDRJi0HygIOaMtvctEC+lTi82vjsp3Kuu/aC7XEsPRraAdTkBVVXj9w57/
         SF/PmJhiCfysY4gvcMKBWpz8dX2PP25gjXDpdWUsGdah6cUd3OppS3MuP2K4iOsdcxuT
         X+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784707675; x=1785312475;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QgXrRndMwv4SCCcQfojawc3oaNrHeDFGMLAKvOvBthE=;
        b=GLLVfYqqKc88SelusuX49yz97+xJ+juJVMpXCkaS/VWoY0YPyguB5lSf7RyznS/afy
         Zp2yGJfBm0q+Uq7eV1EEsEtuRfGb1PzM7Yoj3q5EIu3nZXEkIWfQisf8QA6d7g/7mspT
         MxoOQp6j+iv41zpkIVaIbKLSfAudZKX93us8m2jYccBCG4UR0BSevQPczhbRXSCXvi4O
         qEl0qx4JOYXuE70i0ZBo0jF+InPwYBieRwrcqbp+Zgb+XhTY4nuyA72aa0LAuOq1KU5o
         Zqs4qW0A9DdnTEZflXBBA/65cVK1LVNLWA8E9B6SsrsSvjD/7UFgxZJhUKa39WMT3mRF
         sr4Q==
X-Forwarded-Encrypted: i=1; AHgh+RoGsW7+XHa6DKJfk9VakvzAK7M2Kj6E1IbYKRLr7r1z+3g9duGkYpSXt7awIRLQF//bqIBKZWVIyw==@kvack.org
X-Gm-Message-State: AOJu0YxVlWYDuprvqoVfn+38Pytmkuw8XU7TK5S96/mc7VjxSkiH0Fu7
	KM2ZBHOqU6ixWuFP0vRA/0MWHG3A0FO4zVNlDFNzcws/BKwBdUfZd1AtzBxcXjx+5VQ=
X-Gm-Gg: AR+sD10wT2VXH838M2d+9F5VnQFr+gGO3Yr4Td0jJGkpkCZT10ZEX4VNMU1mcd6PnRf
	VVeai4Q3XSk9w1Uemt8qSZDUWoMbDCsPKPrfLP/OJsoI44J8Cck3nwSHlL/uOiWVffQoGBlCFsy
	WAa0+C//ZJ5p0N34xUKVOJlzCgyX5IrOf6oorV+jqlCi9hrBvCIwlohT6tjqComFotX6eL/v0L6
	V5yF2zmMC0b3S/gJGaFubN2e+/F2GdOiaWGF8726GHsmkmibAWKghCTmLXYc4s9YTMj6VpjSUrV
	QRHSh6rxxbsUxJcdG9tmZlJt+bu5HuF0yvxWYtS41FnE7ZEVUkEOtog3N05eXB0gKIyIQxsZbcX
	3P/p3T+0OZk+EXM06AqWGclce7rFTlTdPuAXcVSrOWBQaspc4uRsb4X7VPOo2brM/c2E4LRubOg
	ZAnQGGjuXTBfXBMoE7mKTpRKI=
X-Received: by 2002:a05:6000:4710:b0:475:f0c2:5b01 with SMTP id ffacd0b85a97d-47f6233b3demr24401430f8f.55.1784707674921;
        Wed, 22 Jul 2026 01:07:54 -0700 (PDT)
Received: from localhost (109-81-80-79.rct.o2.cz. [109.81.80.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm3865344f8f.31.2026.07.22.01.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 01:07:54 -0700 (PDT)
Date: Wed, 22 Jul 2026 10:07:53 +0200
From: Michal Hocko <mhocko@suse.com>
To: deepakraog <gaikwad.dcg@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm: vmpressure: scale sampling window with machine
 size
Message-ID: <amB6WXIEKEeKudOh@tiehlicka>
References: <20260715143646.15828-1-gaikwad.dcg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715143646.15828-1-gaikwad.dcg@gmail.com>
X-Rspamd-Queue-Id: 72C0480003
X-Stat-Signature: fb9m844odhzhxgxeruz488gmci7ow63h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784707676-46360
X-HE-Meta: U2FsdGVkX1/G8Fm8Xa1Tg2pC1uJzvKTm6NXJKaTu1Z0dN5hwXWrftjjg8LOe43iARQisAJ7hEOsSDtNhSRhutLjNThHL0dxe/SN5QHa0a1BOdaIUvlbh+PKwI5kbjWinXxLRhR/JsTKsoW7PRMVlhcC+9nZMygZkQad+M+iqVMG7DTsyjmcDZWlG78kMb1lRAudy70sCLu/is27R9JOe8mvObgOdf9fiqCNgzr4+SupDV+Pxp/Og5i4C6YZ6ZdcSA6LOkgYkl1i/xTPYnrvlxYC9iFZzJGZZXr6jC1PQOWcX7x9O3jNeOBbkEJyKrJUrXLIWBJFdju4APUsyvqEBHgqM79GPDQYt95i2mX9OiaacEnmNQbbxxWoCcXylDHL4MaDS/4NGi4f+0/qwcRx9Xmmd+SEIZ76G4ypWA4l2fXy3Xu5Cn5pTSl87nr7GaZkLTMfX0g6vq+9PVvc4cgagg3yJ+DCIFYz/uqQwecYP29dID2+ZCk8izSFJERyIRegwiOaG8m17AF/to5oRT/vmvlh00pQIb651YLm2/390FUmaru+L6eCYnWcfv5SslfGxynCWAycAyOSQO+TQOQmbhQK/aAAKkhkjsA5xKR/pu1GkrkYO3+f8NS1nrocCbX9vVxk2/N6JHWLols6/ScEsg3v+BWEGZpOZSxm10dPZaYWgyCDQNAINzcqdETsYUnDfSYkVbMRLbvCmB6r4G0NVZV8X9J7aKu/esTO0EuJ5cZyUTnKSvFqZQY6F4gjHGmTqeW1cFp5UeBfKEtfY/s4XBgO7cqw/tBCo3SgosHg0Pm/YjhJcVHMSOqnSmw53zDBHDP0bz/Cs7oj10OqOW8VE3XI4tI0qruRLbYBrBIS+6u8BXDTxQKFLVwDZ9UMLWu8I/WSRZh5FZ7HxQfHcIitgyYU0abKOVOSyP+Uo3rvdLhm+Fu5xD4lSQKneJ05q6DrjEJyaTUOpmcofzVaMh0J
 LA7fi/Jv
 z96CjsbvQW2P+1xlrvOuB6ZJoOEM554GTrzLaZtFDyfVfZdZqPkRA1kJL7AZKczYnqApNP2qy2ziJ39VUCuNH6rDAxlyUNL9M+FP98QuxAWQV+BNr5p9d4us8J+IHFdfQPeD+ZWpQKkwlLX8r+UkkOU5w11x+X0508mDdU2XBzNmpaHch2tqz7ZQXHhU9LDhlONaBoyGK0LJgNfrzgjXB2//tkmMTAJqmdDXVh2JpqWCzA38whIArQqJHOniuYSbfEzGqXycwVTKVHx1uoVQvNnhIHIxJ+b1+zl3o83DCZpl96dMclGeOj2ljHDkKlhCekoSMwIXhF5fxRcRPiCnyAW7O+zLlccuwbXJcGpBoyp1h4xSape0IIHRbP+B5ffdggxbejGlTbIPfigVGLvWb/Z8gQPzlEZ4+NPiRUc7+1pfrUGYXwLXsbIEbMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 15-07-26 20:06:41, deepakraog wrote:
> The vmpressure window size was fixed at 512 pages (SWAP_CLUSTER_MAX * 16).
> Scale it at boot from total memory and CPU count using the same fls-based
> formula as vmstat per-zone thresholds, clamped between 128 and 2048 pages.

This is not giving us any rationale why this is needed or desirable.

-- 
Michal Hocko
SUSE Labs

