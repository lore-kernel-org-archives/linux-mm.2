Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EEC9CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 16:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AB768E0046; Wed,  8 Oct 2025 12:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BFC8E0002; Wed,  8 Oct 2025 12:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771938E0046; Wed,  8 Oct 2025 12:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 668A58E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:40:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03492B9DCE
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:40:04 +0000 (UTC)
X-FDA: 83975509170.23.8C59701
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 01E9210000C
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:40:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JPfXaRK8;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759941603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qokGyOQhDE9qT4JkWLoh//AKI3V2AMxtyx3IuSqkUsE=;
	b=xB6dYlOZspAf8CU8w3UMHssnJHzWvb9rbNGuJeZUrilkQcSSFjpWmml5SYAvJY8lgaipAX
	woD3+M1skEHI2j03EclprbzfaNh2LDQ0suQC8jsuj3/4BMh16dNp7t/nuTivdhhPl+9pa1
	rPCJgogi4Mh3bxeLiggEwP+OlKIf2Lg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JPfXaRK8;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759941603; a=rsa-sha256;
	cv=none;
	b=3a1AMRIf+o/e/092nwSnv3wP0fInV3CT0nFA+NOEFw8cvfkz/omx4GrcakgyI52qd8AyZ+
	OSZ1Flc2tVz1wXNHexPY4vb3AljDrWqsn+bgTzmf3hzirYA9vbetzsvCiXI37S7v9f6DDu
	Y9DVcrBVED5dtEUanMSUIFLHN+rc9eQ=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-854fcb187b2so1471985a.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 09:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1759941602; x=1760546402; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qokGyOQhDE9qT4JkWLoh//AKI3V2AMxtyx3IuSqkUsE=;
        b=JPfXaRK8Tzm4SEkZzAsQWApucb7PhUW4QZ7anVCyMWhReFTtDqFIOjNByntHe7/8qQ
         TETBBCJ8wHHuIl81qGlbfPwB6Sr/nVm9t4MgMiYEE9QcS/hCOnAabRzCw4z5KvpdqvXD
         XgdACQdFv0jQaMl3Vy16TJ1QDd4RmK8IkiTY7f4gaUBP3Z8S0H+PssIdxZQnP4epDCLS
         t0WCQksr+lFK7xpcrKInO5z+iEuNdj5jJtQcEyn11PiPM4QImgvN32WJ+CwX4SRTUx9k
         O0Wrqj/TB4bjX27ULz7DztqUWXrmcywpccrpFjammbKPQYNn4pojP+i71iVcTwMOTTOM
         1k1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759941602; x=1760546402;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qokGyOQhDE9qT4JkWLoh//AKI3V2AMxtyx3IuSqkUsE=;
        b=rlJV6MH0BDNgfDsfnoizBsDmN5r0nhug8pdRWQeunvOtKXdNU9G50q00D4X0ksmNqT
         lwaOCohFsl0ZSVnyKh/Gds45rTjj/6WpLT+b3tr+R1qduLleK+jdgizizq19PobhWUzy
         txaZ3S0xHgs3Aq0CVKwQUlYa3vctYUSpYVb3sc+dDdDkBilna/20T+9tumlb7XkPnpTn
         YFa90ZGQ08CujYS0UJndEObe8hQrSNyIbsbJ1Q6CNez0SPLoIUZYbskFzglw/PR6QYWv
         bw1hTo4MUQjKzb3Lg1BpbBappBxfWGudPOvbQHs0IncRFgSjKWn4y6HvDAcuelP5s86N
         2sog==
X-Forwarded-Encrypted: i=1; AJvYcCWAwFeny3wHv4mUhnjM6bX3bekth6cvG3+ee7LPrePnQR9ncgluHKAGb9d+ySB4ZX+K5JNGD6P1SQ==@kvack.org
X-Gm-Message-State: AOJu0YwDTZ6Rgnuc89Qk5HthgtdRzBSThn7+zEIdE4toqa7bCqJ9fMfU
	vADK7Prn6+TqFU2aiQIdGJSZJaqRAVNWylF0qoEAcj5HIp6NMci/8aNkzTxi3AtEHN0=
X-Gm-Gg: ASbGncuUGP5KU0UHUkDhB5rk93vDT98QrBhg6WE1HwgNshXcTsx+mvAjnO4kdLWPyZK
	+0bfSaXlB7wjJuCHaxTb2xx0B8sfRN1/o80yoevEkcaGl4SVxxDA4H6aKKc3cGRRCeQHBfmgjSy
	+Hc28o9/fVo3hD1xP4y4zTuLll2pCgFVeplhkLlv/kpk5FbcHfuCwBeh7Ng6CaUC0nHnJHMs/hg
	iN0sGPp/fDEp+WmK8XUQMH7VMZmJHBPU/0FdU4jgwhgQpJbwVYvlZZZHcRRwAMVAUU5KO/y93/p
	R8+LHnXmt2/ZIjxtM6942mnARyMP0RZGPk9WENXMQZaMRWvgqwwaYqtdTpuzZeUazKNxI2d19EE
	li4h5C8PBn5OBKaLsJDnEr7eH3Rmg588BGX/Ro+lvbQZc9Gp+K3OTyK54faVy+Ef+c82frhlZ6p
	s6yMjknAXMKlHHReKTDnFEVExQZktIUT3kiftQC0e3
X-Google-Smtp-Source: AGHT+IEnjaSA0DLEcAz0iokulc3JVOgeDM2v5egdeJRtc3xhBAqOkFJ7eetlh7hu/Y5ZOJpn0osvnA==
X-Received: by 2002:a05:620a:28cc:b0:861:27a4:5bd3 with SMTP id af79cd13be357-88353b2a879mr647338285a.64.1759941601884;
        Wed, 08 Oct 2025 09:40:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-884a1ca39dasm18736285a.30.2025.10.08.09.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 09:40:01 -0700 (PDT)
Date: Wed, 8 Oct 2025 12:39:59 -0400
From: Gregory Price <gourry@gourry.net>
To: Frank van der Linden <fvdl@google.com>
Cc: Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org, corbet@lwn.net, muchun.song@linux.dev,
	osalvador@suse.de, akpm@linux-foundation.org, hannes@cmpxchg.org,
	laoar.shao@gmail.com, brauner@kernel.org, mclapinski@google.com,
	joel.granados@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
Message-ID: <aOaT34_LGs65VYMG@gourry-fedora-PF4VCD3F>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZ8PPWMchRN_t5-@tiehlicka>
 <CAPTztWaH7mJ3ACfqqYr1CFCDycw6Zm727t7wAa4n9Th22bn-yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPTztWaH7mJ3ACfqqYr1CFCDycw6Zm727t7wAa4n9Th22bn-yQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 01E9210000C
X-Rspamd-Server: rspam03
X-Stat-Signature: q8n6aw14yghtpbcyxutc1qs7h7n1wzf1
X-HE-Tag: 1759941602-938253
X-HE-Meta: U2FsdGVkX1++ST3xRNHEN5hlYQ81eHteF6qmQIv5uXVsVRHdfBK5noh6d2QbGs58dNn4nvSpDm+IzemHN4Dkb+Tsv9u0vWU+UuWzWaf5poSDt9aGhgT8k6L37bgAtvIQ7OS9WOOEftsLWLNAZx3NnckzV7EUxtBaJh0E9NwOOEg5IAuvQWTyeWzTBzA6Q6S0v5yvgiemuYzzWxygIefG0XFPptptE+q2lLWrbow62/63b6pTXReUW9KMFJOBPzl67Lu1NnvPB1IIGwBRmVJc2a74TNlrjFgLgcW8hwro0b3X+NLlmNIoPAkuy4Nka3b2QgWfBJWiJKJ6OGlNIB5vGWwjMMAMYuiapEX1DfPrCNne8FAX4atl+UiP5DgdXnP+vTCa3VjcTvvRk735UtzhYsf+pN1x6TVxEP4siWO2vG3bKj3egN4FcdQoGaRFJ4lCZ3aPW9PK8Wk3I23hyH1xWEW6dMya1QacxgZK4f+fgfanf+5j6trvH8uyXOwK68xJB6nFvFPbZ3FZMBhBAuj1QebKfP2o26nk2huKqdrQlvm4ngDHA1fvfiYYcyi48iSCGlLNLCqZGq4Jmy12h51Y1oCSsmaMg1Oc73oP6/QiNophuaLVs5ATJ7zHZo87KAumKZHOXL7WNl7WGFKtyaV2T1OuCpnqYs98/QXbdGUpdW+I4gkPlqZCsw/hiSPAZLbmemysYAXQnzjJRhHPlrT/6cP56SPnPA89JxsNelcVdxdMWaVO+hRs66RYZjNGuS62JfsGUzi5WJFJkCwV+u9TKx5xBsmLqvPQK44Vd8ZBa9dDm+8zACqxE+nY+bjXSWDM1RY6QQpqHNXkBcYGY5en+nl1s7/UZQmAkxuLbnLRjT13ihKogL4O1oO74RrgqbVGmeC/FIRL4CqA3NtT/iWckJq61ulSD2T2N2jvDnXdHnsEtoAfQCBJ/RQaiRqXl+iZEmRXnmFEyZjZaZkQFla
 aP2iNzrk
 I3Ye09gY4N+hD3tUqyBghs4bpCmwVtFUXFBtA85pw9/4VdIrlO2Bx1xShVPyrQhKo9CTlSq+jEWR+SZUVND9dNDeVHQdpomwdB9/JwhZU/RPo6f/UIRrlhfljasr7Yr2nWnASXBPjZOphN5qojXYctR6rBCLIf/9l4xdTM0pNlD7lH2IcuTskkKjN2j8W6g9UqccUqdw5VB6FWz0ymqnU8rOfbIZVV4t34qWb4m/CFX9A0mKNRqugsZJDsf9k04TzvkDif38tn5/pL4UhaCdux4ZWGIGLMXORbqXJdSB9XkOVy/8RD/fSUaBPw1ByPozIvTFtvAjofiHPl0z4mUzcvEXEhYHDZD+fJGkIHUqQyOh6850VNKA6KdUnB/+jEVj2BkMuGxqhw8UPKKz4QP7W4ws3wPwXcol120ZDBu12mx6dPlpqPvQkZFOlApYbj1khm9MAfwPbKlkCFaNThUTHh1mCvxzDwCWXxjBKKjIxtGIruhGGDYoZqImCUWHPIxOIc5/uhN7rAaybuD2+eXfqTprXZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 09:08:01AM -0700, Frank van der Linden wrote:
> On Wed, Oct 8, 2025 at 7:59 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > Maybe what we really want is to have a configurable zone rather than a
> > very specific consumer of it instead. What do I mean by that? We clearly
> > have physically (DMA, DMA32) and usability (NORMAL, MOVABLE) constrained
> > zones. So rather than having a MOVABLE zone we can have a single zone
> > $FOO_NAME zone with configurable attributes - like allocation
> > constrains (kernel, user, movable, etc).
...
> 
> I agree that having mutiple zone properties is probably the way to go.
> 

This I imagine would need to be a build-time configuration, as you'd run
into issues flipping these bits if the memory is already in use.

This of course begs the question - if one configurable zone, why not N
configuable zones?

~Gregory

