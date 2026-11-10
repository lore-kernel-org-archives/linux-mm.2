Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2AAA606A331
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mT6t1gPD
Received: by kanga.kvack.org (Postfix)
	id EBA9B6B05C2; Tue, 10 Nov 2026 07:12:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A5B6B05F0; Tue, 10 Nov 2026 07:12:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7BE6B05F1; Tue, 10 Nov 2026 07:12:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B45EA6B05C2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:12:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A48C140665
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:12:17 +0000 (UTC)
X-FDA: 85419096714.14.8FA192C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 956924000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:12:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mT6t1gPD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794312735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5z9aOghFimx59ky5KFeYfYZouP9AaiKbr2PbDrWMQBQ=;
	b=KPad3/QnlgeOybsoMBkprdZIKLb/lR8EV2MYSvuirYyiA+SiB1rrjhDIS3+p6noAtFC4rk
	SUGFptcwQkHttlfU/JKrSQ8Hl6A3LrPKss6jhN9H5UriCWQMkYa5nt2lYiOaVhVcLhR8tS
	dHvjx8WMjTcRTtTQc4rm6RKgRFKTH94=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mT6t1gPD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794312735;
	b=Z82Schs0fn4USRmD4VsqEPAH1QgrOQF8wGsaurUVyLV6ELnBOyjoSpa2e6X6q3IiPS4sLt
	cE7V7zGj4UBkLmDlMSYISDF4WzEI3GChXBf+TvrhAYvuyzupgrl9E47nElb96UQaO2BV8Y
	M8GlN0zNDcxzXg3aW4UI0hnGHJQNZ3Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D89664136C;
	Tue, 10 Nov 2026 12:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53CD1F0089F;
	Tue, 10 Nov 2026 12:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794312734;
	bh=5z9aOghFimx59ky5KFeYfYZouP9AaiKbr2PbDrWMQBQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mT6t1gPD1qyyo/vreYkCpkbSShJcWHVwYb5hbJwVrsj4EyKlNOtm6HnYl7xh+Yeul
	 d3RNaj6JMd+mOHeyHf01FEaVtYExDwn9zz7klXgvWrDhTYF2s7nPXhDkiN4GRdj2DK
	 NdL54gEejwlz7cszB1/xAzmadaBkpDdZZV0ZDONQsAawH24seEBbpfzC3WH7LjsJ/W
	 TlTSPiV4bQ98P7k98FUmVEN+XWPUEUdZq/qxNPyAVSuVELOiZ6CQikMYKlh5sNmMx9
	 aIjjzPV5rVbOqtmrF5997/WZPZcxlSIL6w/5NiAmcC4Llw9od+LnSJNUlfWgkANf93
	 MLfyRZ5UwV3IQ==
Date: Tue, 10 Nov 2026 12:12:10 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: n3rd <18670333770@163.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "security@kernel.org" <security@kernel.org>
Subject: Re: [SECURITY] mm: MADV_GUARD_INSTALL drops uffd-wp/rwp markers
 silently
Message-ID: <avMJ3Nid46Tag8Cc@gremlin>
References: <3f4b0d1b.bbf84.1a1c55cb666.Coremail.18670333770@163.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f4b0d1b.bbf84.1a1c55cb666.Coremail.18670333770@163.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 956924000A
X-Stat-Signature: dsx567pbwggg7oi7pr89jm6zzixxsrzi
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794312735-246839
X-HE-Meta: U2FsdGVkX1+5B7I5gmq8PMVxeSt5NKJ5Qe1UbeSdAgF9KOqldvAoRJDB7T9qtUukYl1jSbzCXp5YilGlSp89CTkGCZC8QdieDW7qP/Dvqfu7H9E3aJh397Fm2x5V33j1UzJ30Gjp8Vq0Ecmv2Jtwh0kSS5kOnQlHUn1YrmjXmfBGeG2h7JtRLtEPAyn0XLw33PxXUvdJOOvOgz/ufZGlRtOyL1MmkDFYKPF9IrAjRJ0yuXYY83HvADNriye3SPi0PtewYl5wXpDpAb/TJ1OvZaXopFBMNZ6cIjXme17romtDyTqJdPCiBFM8GOVI7ImSBsa9GpmalwmV0CiiXTKEBWgowGER7RpZwgxxeq9Vj7GFp5bAlLZhILGEVMekNxFekMaEAt0lsnVypFkxuC6hKqoJFqY8aXcpL+Tjivqnm1PCDTwJA70631XPzYKotYMIeXCSLCtBR27XacDvZkZRf2Nty68+7ahrl2wggC06RWsVpFuDJibWJAMv6VX4Dg9E5gKTsVKbE/s8+04rUubIGUBbL50BFEuHFx3t5VFG/ZM8BKC8UIOpGr67MsNwTVP5vMfzAzQTai81qhJgd6QeVfcbJ80FPUeWkp11DwoHCPeauWbHrs1NLIlSJftxLDJ9d6Qj+uU8Gi0zpybZ6gOTbFTtSIeXR2hAd/Sxi4eRqXEJ8Ors6TWHgoRAwvbzP5uOAfy/M62WYaaDrnzMxrqMEUg3f6/AYa0AbOA7n/0mLSkBPqFUAnQCsNCmDjhWankhfwKmhjeuoS7BwMeSs0tNUAGCjKfNTLYQli6z4p64PgpPSehdVNUI7BRlGDggMr9Rx+YlQnfc3qNAyMUAcQ4uE1zCPSppNX5qNJy7DSf7p1dsODCXuTg7lAdRV+BOfRrL0+olf4vYGsUHoMMe84FsiVhKwW+NQ454Sf1c+JaRqjqDrCS7DWgUpRSyJiZ+mU0ceVy3Se+hUIY4ufDUjP5
 3yZl9VIe
 M6sloDZWZ/pEpohAQrrKl042DHlw7AtNiqskMMLuHiZE5aWPn4dHDoErroPnIn2iTnBWRc6H77UDmbOU1VxLYfWlllftrlvJcmjA3SD5nnG1pRPhwB47U3pDdRRLgiyv7o01hor/O217NN5NmgkWhgdYkw1ydxz+IaqJOtVayHVBvlol++JEXGxytjk5KlIyJ4PypQCZaMkKbpbtrymBy/YHHFR94HtMrOmWYG5V3rupb9c5HAYZzlwJhDGTaOGkx7a2rGxIR+pShYgPyqEHkkd8xOjGM8i+8IghgIC2vjHybn2xZCmMNrM84dm+v+ueVpRY5VftnqvK9saHYsBuz2Z9ZyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

One more email like this and I put you on an ignore list and have my mail client
automatically delete everything you send.

I am not sure why I am even replying now... :)

--
Cheers, Lorenzo

