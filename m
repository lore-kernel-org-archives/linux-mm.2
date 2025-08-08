Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E41C87FCF
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 01:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 330556B00BE; Thu,  7 Aug 2025 21:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E1016B00BF; Thu,  7 Aug 2025 21:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F68F6B00C0; Thu,  7 Aug 2025 21:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1275E6B00BE
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 21:32:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AABBE1A1038
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 01:32:31 +0000 (UTC)
X-FDA: 83751865302.29.27A8483
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id C6B30180007
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 01:32:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kUec5szZ;
	spf=pass (imf06.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754616749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPzAYDBGZDP00V9twCb7bSKQGnBYbJwPmRh50bme4Ck=;
	b=Q1z9y7JBz1tolNse3zA6qIiVXl5yf3HCt/LftDyO03pQQ40y5W+Nf8xzs/sJzWcmk2UBI8
	nDA+TP4T+ubHanCLrcMZKN2j+GEphcdQfiTyFVxvNKxdr3po1NHGqGjgHRaUARNhWPt1DS
	yOU4SsOKQwg+2Ndy66r6iUnKRV+hH1I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754616749; a=rsa-sha256;
	cv=none;
	b=OhQCEK/COIsTlIswcN4NzN8i1361EctJIobOpAkz9mDrk8SCPxMkBoMd7qkSu67WULgyUO
	GFaKzXBR6Z1KesaNoSOg41XezdL8GZb+ymDh0GhUxAZXggkGe+1BZ0S6bJXOpG4HXeLo9S
	y1P/hI0csD5i/lFxXN4+N2Zq0cwSEoc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kUec5szZ;
	spf=pass (imf06.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b34a6d0c9a3so1896836a12.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 18:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754616748; x=1755221548; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CPzAYDBGZDP00V9twCb7bSKQGnBYbJwPmRh50bme4Ck=;
        b=kUec5szZlwnS1n7H5Oai6qP8qiStrYXKOg9nWLMjmdNKBIwGiidnJPnGRv1MQ3wtx9
         xHhaUUq1jYfihVI8TbxxsW94jHz1izGmYPhpbVU8M5SOB9fHCGW5gPl3rdqYy4dCdPbv
         bx5z/FOlYFgRDebHsAD55o7/eUgJIkrJST0vjMDhiGUs7QifRFM6Mu7+jbsI08h9Ipgh
         TjlUFLO2F2EBpI7O5gkWTWjXQLj04PXK4W91jLjxCr7/qUjCetNf6NOHhakOMflBqHuz
         gA9NwCabmIWAd6oaPBC236gboryHNdBeujWVW/I9Nf/hX1+uzHmLmRZhXSBhgQLp28cG
         HqXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754616748; x=1755221548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CPzAYDBGZDP00V9twCb7bSKQGnBYbJwPmRh50bme4Ck=;
        b=ltHGzvHdHDYCYhrX7HBcMHxjiUIjFVs75Qj2objQy3zVIdIrAfX8Tctb0a4PWaJRY3
         8lS0B0bSfC0Aqok2pVbQM8qMGrmhwf/1O/vgs1RGKkWVCMSoinIaNG3oA3rUmhoFDuM5
         djUyrDYvSrgx7h9pfZO1EhL0mw3y0/c0B3j1qSg0fwTWfjJW1/zaP6KlgBHa4ItddFdy
         SJoMhGdrp+8LvwlVkE5lfh1QLE8ZIXTcqSYFmKhd1cY9YgpK+owIVwI/YZmz3BjKMPKj
         12/K4ELRSYWLD2MwLAWa+MSdmTpte9etrkw/ye6A348UG09NeGydEve1EX4R9RWh2Mfo
         U+2g==
X-Forwarded-Encrypted: i=1; AJvYcCWKyZXHQGq16XYzgOjvgauOu/wlsTySjOC5mojieAoHF+OinpQ4iIpkZvpVRaliFVtuJMauGHlvkg==@kvack.org
X-Gm-Message-State: AOJu0Yy4QxpGIeX+8YgRDShg4S6SIV2uRnsuVqgybSJYbPBCX5JMD8Ev
	S1G8Cnjn6nR5tHBqFQVIo2P57JBcozHfephLD0SNXG6bUSXPg1Redfjt
X-Gm-Gg: ASbGncsmuKgh92v7oxg4orbtDxO5H4kAjPU3qTj8KlNuwRUQwBh+umst5K+vSF9kdeD
	/wtQqV9v52i2DynRU++Oq+vDbUG4lhW/FL0iWauJdsdeE9ortijBRjKmFh+IW4hKj9O7c2q8zV+
	dStSAFi5FT1Y14uC7qt75WQbF/JvjKXtZl6yKyLocNStK4i2a+HnnX3EMJuGsjVS2ZAlkG23cAu
	Cu/v0i3v2kDW7h7FxPnod9JDjDwbBkMOMFxHbW926ROR5WOOT89IKg8jyJXQVwScIHPpPm2nvS3
	JjkNipRC5c/UpeM8O0QsHrJI73vqaFD6zOc8pWhmCZ7it7KwZYlzc/t0VmwHR/76U0UOh2Y5mpt
	CkcwGWB8=
X-Google-Smtp-Source: AGHT+IE1EqgY5FJCV8+9U1Zp7rvdxKI5+gB9+M0weRjBYKkKGWvez3fPSY7SffW2iDCtvC4FWdW4/A==
X-Received: by 2002:a17:902:d543:b0:240:8c85:4299 with SMTP id d9443c01a7336-242c20aafd9mr17501615ad.17.1754616748511;
        Thu, 07 Aug 2025 18:32:28 -0700 (PDT)
Received: from localhost.localdomain ([223.104.40.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8975c89sm194543365ad.96.2025.08.07.18.32.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 07 Aug 2025 18:32:28 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: richard.weiyang@gmail.com
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	dev.jain@arm.com,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH] selftests/mm: do check_huge_anon() with a number been passed in
Date: Fri,  8 Aug 2025 09:30:56 +0800
Message-Id: <20250808013056.41546-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250807082707.30647-1-richard.weiyang@gmail.com>
References: <20250807082707.30647-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C6B30180007
X-Stat-Signature: u4ixa7uybiwhspumenpmugykf1mhxm1o
X-Rspam-User: 
X-HE-Tag: 1754616749-551831
X-HE-Meta: U2FsdGVkX19icfwkwlQQ8071sArDz5F2eAjLc2kmGe0OPutdCHy0WnEk7cpQYS6usyKAH37N7t+i8wlgBoXfbFjKRfziiZ3gzrfSnknXZxnRdX29ONlLrJd1A5bPmDX5UfH6u64+jbJVV3WTNG1l84QfrytzXLSUiV17y+dHHsOK7JA4yoVtlT8eUKXBCCS04usGTqSMbvoZaPaVqFRon4OtHMAym3/74Bk2rWNT+zKpNdKf/Dl2437H1/16Bdu+rCSgQNnP5ssu9pIThmXys354dK7yJhnIOGJesMWg+JdcGFlt4DWS5ihw+SsokTaDmeWNyTLuD9eMEy4DgkPyo50CDNmZ9WkIeBk/a6WYKLEkI5walemRb3GuD4PXBCcwzvPZ1RSewDSha4KGq5tYC33FyMA/saJvTP8hmM+Y0QV9jf4jqqG9UzQV67ZvFlXce3KuFWEjemGWqR+ZtvqqiqlOFMyJ0gUf5Lr3/hRLJpICln/dOokNBHSwzwlHW3YFERgQoeOPX/S0vcZtx7LQMPqd7/v51C3z/HL7FGlyAeLUquDbMaQhkKEGQBCn9JU4FpcozZhlTS8HAA/NQ81cfNn/UIndewMiHxFMBLDvhrrhYHG4H3BPrx1RjGXWGK1HM5uTDFdIA3eP/jw/k6jp1ZsutrA2uvJGeIqF+IsIaEk0orIGpIcAti7B7vdlDuLNml6rsF0Ogiyqvy7zI3qiU3PSQJyi77bRlYJIarjAfLlSqAdJfPtp15u3+MEKqH1xQ7Dj+s/7zSm+LHTaxXgMpiiZLBshJcVLLMtqNqD6M3a/+4bx3xDt5PMZusRWD0eYfbWWLZyaKik0FGxg01kdQQFmg57rcQU3tb3yLi1zqkkyXRRXxZQIy5IOtLKPY0gQHz5gp0rR7krhDHoAXN8HmTYfQ6bBFRostvP/pnDgu1/vnFYJxswpkNYyhU5AbrixCL3C5tHl5QswvQofOk+
 NsmQz6/J
 jqeJGI2r7sMBFrVnDQ2dRY0NhuEQLDI2Qs8oR6FiJlp+pnQBH+rZ+hkQCNcRZRIEUCH22T/9x57FgiQjH07uT1c1V+tlcsrJlSDTDMFiYH19NApPjh7gmAF0Xe2xb4Bi3eg+fB7IC/x1MhtbP90vofDcwSM6BA6RRLt8URS8lZvbLby2q9lcGHD5Y59tu59gAJib8U7LyYitLHdnUl0IIR0jSjxGxlRLDguHFOIgWL345q7PKkipVpONvRIJNQwIVgUkIDdstNXfJXgnSduQorDKKIb9JS0c3EQqrx76QRZS8vjCi/gs6KIP8sODvGmjycx4SLvvZe7odGTSvY9kOJ0I0OkQKkP51Bc45E7b13MCqYqT8yWuxqQecppSmXrv8ypgAGiEqSkptVrV0PmuC+yQ+GNbPJ2syJTjSfMDrI75aZYi5qql6om22MEbDJqTNVOlGlMjD+XSerdPWXboHhCCyON4Z1wOZJB6NxFp7oQ4NHohnAT3EBNXmYUTso6TvRnxXKY0saYnLZRJWmOyltrVSFT1NR61JiIWk6NGfEAm7hv6e9B/WPZmi6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.033719, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/8/8 09:27, Wei Yang wrote:
> Currently it hard coded the number of hugepage to check for
> check_huge_anon(), but we already have the number passed in.
> 
> Do the check based on the number of hugepage passed in is more
> reasonable.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---

Yes. LGTM.
Reviewed-by: wang lian <lianux.mm@gmail.com>

Best regards,
wang lian

