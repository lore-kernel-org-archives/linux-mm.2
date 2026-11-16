Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D75A606A886
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=oTB5isp6;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=RDgpNzZh
Received: by kanga.kvack.org (Postfix)
	id D335D6B05C0; Mon, 16 Nov 2026 15:04:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0AF46B05C1; Mon, 16 Nov 2026 15:04:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAC0C6B05C2; Mon, 16 Nov 2026 15:04:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 950B96B05C0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 267908021C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:45 +0000 (UTC)
X-FDA: 85442060130.26.C4C7951
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id DC0F2140007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEJDNGjl/zFe/mV3ACxBqyEokV4hfSJvrPhzPRkWx7Y=;
	b=ZuEg3dzSAI/Rz99Qs38awqKkGQFA0nABepp8zITI46QfavJAHp9BzQsPcH2FWob0dHuwJr
	DCnr7vCITAX2ytIawUXjx8M+xKra6bN2vyEyKAQAVNBptNeZuIhmT5hhiRPSZ709yE6ucN
	aiZR/fdKnBUqmDttQ9jjK+MHRAn5ImI=
ARC-Authentication-Results: i=3;
	imf26.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794859482;
	b=zQWrdEByvOQ3zGw35o8JRXlpOqseZozVdzUkSqLSHkiVcAH5OcTMFqIo8fDK5EVrFhyjtD
	pjkfAIpDD6MqJ7kxQs5Iz53pe02Sy9QuCle+4qJ2EFw/u0ORAZ9msIRFyXMcXjWOPOP46R
	2D1iEuM+cKrQbwtyipCku5S12+RRkkY=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70F44C0200
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:41 +0000 (UTC)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 42F861A0221
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:41 +0000 (UTC)
X-FDA: 85442059962.08.71D27E6
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6A86C12000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:38 +0000 (UTC)
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEJDNGjl/zFe/mV3ACxBqyEokV4hfSJvrPhzPRkWx7Y=;
	b=FIZFIH5yl9jBiE1B+69uM2wqoMGmD6CSiNTdDrves4rV1Rh9RBrASpAdqvsSPH6XyxrKc4
	g5UnJpfW40RR/lMZ1ly9iEBnvKwmfbp3GSqGuAK4m8AaLw678FIsHsv3i054CMEv1u8Hrj
	MouMcej0m+8gYVprFR8rGM/iBFK7nI0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794859478;
	b=8en4BtOL4XOp96ZdA68zO71zxQEB/CyLx3qnM1VFGZ3ImayE14WzhGhiFy5iau5H3sh+NH
	vZu0mXHZBsv694fMunTDcpfD1TlKiShuFo6P5mggYFL0K06COfsvEW2Z6dY+keabr9dKFV
	D+SjtD2hMIYJNCf5n8aVqTa+S+ZapIA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 01F0E40136
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:37 +0000 (UTC)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8C46401FB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:37 +0000 (UTC)
X-FDA: 85442059794.13.9C20BB3
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 528C24000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:35 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794859475;
	b=brqfDsWvEEan+mfYDbGleX+gQck7j25KBNVVAu6N43Oz8W5gxLc2SyvoumhlTJ49UV3Egl
	Ae88eNY7F/WqeXOrH+5xhEZfmoTJoEeuvmkAbbmyBmmiMB2II3gmgTA4Kwu9IQ/Lmsx3A9
	gLV1ZMCDo0MXYDMoBAVpC+6kAwpNz40=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=oTB5isp6;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=RDgpNzZh;
	spf=pass (imf17.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEJDNGjl/zFe/mV3ACxBqyEokV4hfSJvrPhzPRkWx7Y=;
	b=7JSG48Jnt+T8TuhJVy790KvMzxk0U0IEUf39i3SWPYB8wT03fwKVL8liA7bd9YqX60T76O
	2QeS7U7H2Rk87U5xYGPeu6FEIqvDWc2IjjlzyajYYcwbz/BtVlwE3/fkuF1zxGCWVRLhAh
	8WXK5fzAR+uEjFxMYLVmRAGT6CsACFA=
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGJXMwI3802155
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=cEJD
	NGjl/zFe/mV3ACxBqyEokV4hfSJvrPhzPRkWx7Y=; b=oTB5isp6rOQgN5HupD1s
	y4BGu3nwZm5mRAnn10ePdNKEIN3gYVx3MONUfXy6JhoiZr1vCG/+ODN5U0Uo5IFV
	5Y5ybunkPuXxdJv+Z4liVtAy9DqMHVxbF/ABrqCeJR8zngbtp7W/W1p7YwGxVZ+z
	F+CrSXjOcPsAsByfzHsmKk3tDLZnVf/+4u53PZW0EpqD5ldF9jkcl1kZ7nlir9ij
	EbSWPhOEJ2VuWMY5z97JXKHztBOEDiS6JPFvm4/fJWt4Byi36tHSjpsN/i+E2urL
	MMgLH+tQHdFdClRnByM0uoNLgYIDO21moyfeB4PhIybFvs4I8Fkq9BEQOgtU0oap
	/Q==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j0598t3f9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:33 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5363763b556so74559621cf.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794859473; x=1795464273; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cEJDNGjl/zFe/mV3ACxBqyEokV4hfSJvrPhzPRkWx7Y=;
        b=RDgpNzZhUxD9+AwOGbDcuc4Ci7+ppFMU8I/W3uQtSYOnlIfMzUyQeeRwYwV/S8WYP4
         8mcPZFWcZQNkqAKJd/E4NbO3dDJhqavrvJA7e4QeH3WsGbDfyTUOZZuDj5t3eJh8dpzZ
         lUuHsqOactPEQncWqJJKewKTVjOzaA+01iGd9MH9xpj6QtjItRRd/MJ7drfRco+GFrWw
         BFV88h+ca2A0DExLVAtIif0Ob7+ZFJjMXRhh5WhWBvNT23+zvxBoNHJEBOrmaFyWkKVJ
         XVqIQ7byEIEdEarqWQC5WJOQIZytpqwiJRLied5Rtc5vOZGYR8IQflTQk1DWQxU1kYau
         D4EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859473; x=1795464273;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cEJDNGjl/zFe/mV3ACxBqyEokV4hfSJvrPhzPRkWx7Y=;
        b=diO/2wJBdENxDPNdqNGSSA+JxBJH6UNe3AXsPJHQqLsVFmWpSmatdl6wf24JEZFwDH
         RrvoCxXll1YkmX3glS7g1U+X5IT5NFJLus7CJovmspy+BwvJrgea3WKJ7hCISRLhSe63
         s7EvaGFc+SktaW1iKk8YRaew3GF/Pow0d5XNFsMVIp35mbFYpI4XZVH9K4xvJ7eRFlcf
         ZTooHM8xJv07GKEhloppODwIQcdrI6yVBHEhjlq8XMoNqqT3yA4znlRDrvY0+VvzP2tY
         mXRjJFWy9xOjeTkgpcZshjl9L8Xcwn7cy6GVv8HR9j0ZtvEWrwODyoiH3JwwTi2LpInO
         rm3Q==
X-Gm-Message-State: APuU4Z9xlhf7dN5MDrBgXTcmucVvKP0BCX5uhpkrAbU3ZRUjdLiPgjsP
	0tQlqV5Cs65d1lVor/L4O17IK9VO5FWjueC9Co6dKaOVkjpKXoCDeFD7MVFaG9uBF+M4R/Aawol
	WBMr3gl3h6bsLd3auCpWTrq2IhIxtsUNcJvJ+d4gFL1fNXtyG
X-Gm-Gg: AYBFou3KyZHXp6pu80U+0lxdge/YiwnvmEjSTf9J5rJdA0ZC87Ke5eQYGyXEF/uU0rv
	86nYMFOXkYPWG1v6Ex4GSrkqSfWwNf2R1h9p5kMEQRWjA2d1IC/R2ROU5qBiTGL08nu2cbNhk2r
	iXBKO6eZaJ0fNna3rcfnz88JL42xOCclZFvjI53VkiBCobHXDRGnjFCMB3P+oiHhk3H+rZV7JMo
	P/6wzZfr58ttADBvdIyxPhAXIWvgbihBEGLuESazvPnQtESAWNpkirMaSWBNEVRlhfr2HUpfHzK
	1MZ4fk1pZmQsjn9M/kT9QZlxnMnREZB9UYpYa7X49mwvfy9VHIqVKYQM3O2EIiDhnHskZUYz4AG
	gr7pLZYMZYM0Ca3fJtsfunCTD7lmrEOK05436jnnfXG5gwu+jeHkGmO3g7GRWoApNT5oE0kywqj
	izn3gYfTR3VvTFW3AuPhQn
X-Received: by 2002:a05:622a:4c13:b0:55d:33e9:59c with SMTP id d75a77b69052e-55d33e907efmr87730721cf.15.1794859472580;
        Mon, 16 Nov 2026 12:04:32 -0800 (PST)
X-Received: by 2002:a05:622a:4c13:b0:55d:33e9:59c with SMTP id d75a77b69052e-55d33e907efmr87730001cf.15.1794859472014;
        Mon, 16 Nov 2026 12:04:32 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23efa2edsm93065426d6.15.2026.11.16.12.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 12:04:31 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 16 Nov 2026 15:02:48 -0500
Subject: [PATCH v2 6/9] mm/huge_memory: build the moved huge zero PMD from
 the destination VMA
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-uffd-state-fixes-v2-6-4397a0196479@columbia.edu>
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
In-Reply-To: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
        Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@suse.com>,
        =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794859460; l=2165;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Mw0PGqcdwi9MrYnN+IL/vE+jWvAOLk08il/P1XOxvA0=;
 b=ZziwTlLGLXjJcZArbTKseqAMiRMaN6WrcRvEULuLwzlevKpQUgbaDRMcTir85gnBILUj3uHSp
 YwvXpPYhyURDOGJtHeuhtt3mq6thHBtLeXk+Ex6SOWTGGj2RGQxXsJN
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: azKupA2NEgMDPRscJGJQepx5Fs3PX5Pa
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfX/c89cvE4MGVo
 /u04ITf2naxySpjqb8XUqn5EEkc/kBS7ZwufoCdw4MLuVhuiZbm0mFKURpQI+rdEk4di3pykSQF
 GdHdzua3Ghk1QgVH0m//DojrvxMrOwlwkJgje65kdBrpmlzWRASh
X-Proofpoint-GUID: azKupA2NEgMDPRscJGJQepx5Fs3PX5Pa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfX0mqmjjk3FmYz
 +2+Vd+IFrTLSe1zDc034CssYzfSMMPd9rnTeJT+KLBdhWa5Evpyg9jrfaD14W8x8i1dMOQEhYOL
 6QTwvl238dmIjy/WAhGv8CkYEi1s0s4ZRkm1zbnIlv7eAYFJaKhx6Y7q7y2B9iLJMAkQsIr5/at
 DCsi1KrKfWAWIDs9bhOSTpdnpvWPNGpi64kfxqGkslJ+o8JB46bjsaICeqAcd7wSBh7kP1UJ8am
 BYOjOaJPzH1Uy635DJKlsLm+P1rjKBfa7YhDLFHdNMHmaiB/xBkp3haANaZDvqKogNyQjZHrFTs
 EuU6RO4taVI5vDplPW1xXoQuHJyXDVuDBDXHRNlQk+HyJ7Qu3fEW7Es42iyDOUmj+XlX8UI+48B
 ltHfxfiLYLb25pCSXUF+BEpHd5mGTdEq9sPtQ4RZWr5Z2ILhg3cNhEntjIsvaDGFVSJBSkupdGw
 giu6pLeMGJg0g/ouL0g==
X-Authority-Analysis: v=2.4 cv=ZOpCCn7b c=1 sm=1 tr=0 ts=6afb61d1 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=VwQbUJbxAAAA:8 a=tHa68p0SAAAA:8 a=t9wnRcJLD9wLKarOqGUA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=10 bulkscore=10 impostorscore=10 spamscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160080
X-HE-Meta: U2FsdGVkX19IxuTrs908CNWzKyOLcnhoW4cTi6AXlymze6aYPJUzvQgiJxpkBiqZgjlsCqe19QhFC3DW34zTxc/8kKqm5Sh0YO4znmxMSHkHyeIrePid57aa6kWpmsR/wE3du7UnUd6gjd+scOhuvxXZ29fiAl1f6Ii/ZtA/4uL3T5PpOBJKrWsBC2OtvPUCsrnEyu3++pHH99DbEaIhyUDoRLOfB73ftM7KPmbzztqEoAmuxeFUF5RWUPwv0ljP1c1KqLYuIzsNuwKrcIHCnF1HOt3WFSbavoWIzh0AAtTJhYhQBmu47i3C0Or00gRV725vLP0GIgqNNuodLCGQiyQH69FEL84LsqiIoSS9akf4AhVpF1HT/xFALot1VPoTyDpcuN3RhAUQKor//xOQ1x/RiUKkqbjsNjf9jVxoZ3Inp/ynxNnlcO6kvni64MW3m4QbnVfjpVc2TJHplao6b4cE7bnTd0XTBHpYl2+YxI6UgsAP1nNpHe/LWPDPElwG/RghgpTZA9xkeTeXyVdqNv0lBaZqJZhIp+PIKX6TTGnY+fjwwQAyw8SL3ZvO1BROjgQzn2/r/XrdVsgr27BRAknpt+5vUXw28mpeEbC4UxY7wBqfu74HvwKDx2IXK51HapT+9crnQvgBNeof85V7LId5X4NfwAOTI+3fikPyznUMPrp1Juwief3i3yHXqvS9AATW2sfqZfTBZBiUuNK39/rB+zwFh69BjSCc12lU7PMDBnlgU6tppnqDKOQKslAf3EYaP8lnklZtFC5YSC4hJGczC/YYQ0Yl/JVYNZxv/up+Wxn5C5OnDo6yMmaGaJPACX9YSORQBVNNVYtPlMINaOp1mCgNyNF8GudooSbYkIE52G5tvSyTGmGJnjSk/FpHlhodqF9h2IAtvU9kBtojplCtUKnqNVbCvUkyvceTZuPsQ3aHbRfQmy0zvbRVdZZ7kAoAfAds20K6hqa5XT2
 8BAgncr1
 yqooTiWDpPZPg+ledGL0w1W0E3I8H75GXcFQZusxZUiiYFkc0R5fTyVQhEsOwokzrQio3p72BlFlBagvF+M4bw6eGNWaH2oHEN6ttaPXbjj8LJq1V3Rse6+b2ixmDwARGiFqV2pfEAD916ZgkFrCMDX6RY6pUEZwLX8VlB5FlPeNkoeqFcOhcwhHDpkJwbLyp1MxRIlKVJpUXILIYJbq1rYRWYkCMbr+xhYhaVBKNnCQBJ1wBJA+Qnzudvqctqx2Ks4zCcF309x96Rgu9wGQnySCGR07GPrrv1mjTUhhGx2UxkH1rIyz+fFcrHudqaHWhWo6UOnR/pQji3kihslqys6B3htNijZOpfUyoCURNlJx4jZG7Cob3lYawyjQwq/3304oxahku9YOorSE4LBWpHWtmXeSekcbPKocRPA/ULj4F384LsKYdPFLszvkKZK8DZiQo1zPPHB1pWSA0NPxec/81PPyAdUXwsahowF6xnoVKAt/U8Gvzq+U/e8Z4KtP+0qwbcn2/kraR2BOH1qcKSNfQ14z49+rkuZeaK7+r+o/RYbW++Y+ZVVA+YrcwyfKAm0mlSQ2ib0C1zeI=
X-HE-Tag-Orig: 1794859475-632792
X-HE-Meta: U2FsdGVkX1/LiRszVsBlPFMgr3otedjBBCh+Yrnl0ycRDumSdgcZ762SsVILC4zdeUbZrclYe8on1UIZXoLmF/l+ALLOl/5clyClxJ6f1AQaAdFy9Mz4Q7/UxTmcn7csvwPhy1Z1zxDdxwd0PFIP/mmgFpAGGq0VRnPaf67uwtf5qMNGv77aFfAkRlYz+HvX3Oew53eLq/jka0kXhjpgJl/VU//oLclziLeNiL7rGZqhKHbwzkxe8BcPNfb80aCwiLc9AUVn7SiWce9FEyAzf2Kz27eRob/bXERyeNwSrhSGEJrF9oe0L2tX9eIpXxYbKJZfDakUiJpN7Rrs66KtpiiyigImjkM7DTaMFV0RFJE4LFZWUQzeSi8wBJ2bs4wNCqj2szHsoD+zu9yr3/oM5y51gDhx5TE2HKqMxMxN5G3VN14+YPyLoaQ7mcZzHCM8msxThwAir3KP8BqVZXTbMWFnrhF+fdX3EzyVYO0AXFBfe7Gxs4nKbNlwxB69ZdLX92omSQ/88D2ScxsD+eZfdjwwW8jlak3kqZ3Bkj7+AcpVjKQiHbYJXPlwmKT2vrS3CcXc5QXXs4T3XevfjY/3M69kdIeUH/8+pBsTna0p18+KiZLZsHrFTml+l8Ef7p4vqEUPDnbTBtoMCaOl53ObuWjfaCM2mz08v5YmAC+jhAe65kBtXl/MmBU4xjX0D2QkahUX2X95st4HWJhByOjhEjNFjp+kLeinTVEb5K6j1SEB/u58LMh+O9/ZXHkQuZctL6Ty5vLnAGdRVwtQUuF5JyXnu9koYbVqhrRXlztQDqz9Oi1PV3TQhrJyDQPiHFWXECvl8N3cX4hdLODrOA2E0bIlMthKz5etBvk/PJhdZAxvVmuMcSElg6BKDXr9Za9AzK95za10rqMlOFtWd4R0yLhmW+MTkXcrVqbrocf6tvz+ua8XdlNZMHc8HSjHzWrBKGPGfT3tgfrpCZxrafm
 qn484hN0
 uOehIT89kYtwed46RfQe3fppXPTI7E7bqX1gACmOf/rJ4uxTdv+z2EOFUBC3jnQOCBPv+TcN2eTbrb9zXe7fRUF31qqnI7jrS7nZ3+yoYhUZTbqdhnqnHPZ6SDMyKPj91h4WeQVeEsfZeSk72ipTDuJczJsTSH6RGLPdtnDDlb9RLObnHnLZqEZCNxOTMEUTbh1h40U59nURc8ItMZGz+KB0zYFY42JL0legyvEUIofMQNfcHG1jazTzKHxtPRKLEKttujaIRiNsk8nqKij5bjCZUEhDAcYpffBMHrbWzXt3cfGJ8rQW9ysAwZzGlrEeQoNP2Mt9HOVHhZwoRNHQkRhU9oC6r/9g6PDM0rX0843e0SPIG1BuYsxaWlTbvbC3/H2udqMFqOhU0w2rrg2S+p+scQCarMUSiNRShSe+8rzREk6oPGPh11lCfUTQacMy9T11HuGF62J0dkQM/bt92WvxBQxfYYLqQZu6rYN7Vdnme8sSlbi4fzCAp61x4ULrcspD6XuiLyQCK9Cw=
X-HE-Tag-Orig: 1794859478-43508
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DC0F2140007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: s4zkx9wz8uzwekxzso98o85fsbfsa8sq
X-HE-Tag: 1794859481-859004
X-HE-Meta: U2FsdGVkX19lWpKHlJnAcpeJC74h6imMpF0FNJOzNYiQqp0K8v1G3DbZU+C0j+gLMDTTVNoYZRfJU3WG11oKvcnPMGTSq4JdzwQ9KldltKexkwbIC5N2JeZ1ULByDoI7vtiDAS+Pf3lK6XQx6/5okPMzlEwvFpDUOJaHegPOJM0eQ6wHKOFqy92xzZtOGM3OTiC1UQMXgnEPfUK0L1SA+NCPZxJA7OWSCvykcEkVIi/fWIdSWnZ985aXnjpxx8cACNYnTP9JoIoIx1uMabsDZCC1RCg0UOXSN+wqcTqSGM7hG0XGI8hCEKvJhv7QjvrqQQ9Y6lYLLbtbXu+V93MkGfzVoam5MDp2sS+bIfGKvfARjXCetWQMZYbEc+g7w35OOWsgR3JlhdIYdBzUKziyfSTzkPVzVa1+PB2uT3FBCHnfZLucGjCzCd9Qpn5quigE8eJcHDzjSmbTIQpbtvd5tbPR/ENhdJHVSHxO80v8s9cYUiDZmcLkWllGhBEkEgBKoJ+yWbUa4+SBhGeVlv8+gIerUDGMBcaa6dHmg2tA8BqJD6xNNZfs/lMx05EX12bqM+jhXFs/M0K5vYI1K9cAD70QAJbHd7VC+f+rvXekW4YYTkTK6R+558YWPlbC9KZWXFhRNRzCMX0MrWbv6EwipWFJP2nJ7Ppi9NDB453YdW32uGb6npstORDqyESStEQBTeEQTk4AmPe0xP0tEGr3tkYvqgKHM/6NmoftRAnchKGiGs8gq7IlGybMug/xKcS5QKgIfEe6k76CFmoD+8al5m4CDH4QZjbxI3Je04Q8SvwBYdek5PM3HO+802VFaLvA7MWKNLLq6X6EZ0Xunnm5e4sKTvXxteJKzr/5tek6pGKcxcb+Kb2JFsgOSDOGTVv8cHPTx+EtfIdSWYa33ziynCNJZiUhx4CARndO180AjKRjxKd8CuVsfwOUT/XQWeEjfiDEpAxJnjYtkCHRnC+
 RShRw7/5
 +U4yH58ZodRKZPx1bF+Kp+C9KvoqKavjJg+/SUIr0SCACPVxRdW1C6bLSBKVPjOAUH3PKh0j6vhFY82JAtfIkhBHipmTV6nqCQyUxBrjhBr7vM76e8sCB1O5pYFUARKfUIc892jalACmo2OzYeQW5hYvjKA3YaY7n4+o15YWHmsaPKMzfBCOLqLelGcxH1zNXxTVOVMx6H9PwhZYJt+PbctaWKBAUWp5tc1bzaaiYCFHOHET8tuE5/5imwlmJCQyAdrfBZFb6/6vXXqEVJ1en7QVBYk7ZWpGuD85BG3wmPRsgGfasNo9sFpEzsKmj8vDC7uRhvz21Pk6Wa8Pd5Yn+uTRmTqrdUs25R9JLMhRjMod8CTCs/LoVXCtfm6hlnhzk0QlB3rsUpXQLCDcZzmT6NcgZrbt51FgMy95fJCVit7VCyvy8hS71WkzKg1xVAhShNznSQREhC9f/75US4zNzHlxRFmJT+D3BvfICkCk9UK7Gsoktz5tLYyiilkU6D/eh6tpM3U9U1N5ePjU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_pages_huge_pmd() builds the destination PMD for the huge zero page
by copying the source PMD and clearing its uffd bit, so the destination
keeps the protection of the source.

A source VMA registered for RWP can map the huge zero page with a
PAGE_NONE PMD, and UFFDIO_MOVE does not check how the source is
registered. The destination then gets a PAGE_NONE PMD without the uffd
bit, although nothing asked for that in the destination VMA.

The next access fixes it up through the NUMA hinting fault path. Until
then, the first access to the destination takes a spurious fault and GUP
has to take the fault path. The impact on userspace is small.

The moved entry must have the protection of the destination VMA. To fix
it, build the entry from the vm_page_prot of the destination VMA, as
move_zeropage_pte() does for the small zero page, and keep marking it
soft-dirty. A destination VMA registered for RWP still gets its PMD
re-armed afterwards.

Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/huge_memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5e2629602221..a2b1ac11e7dd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3003,9 +3003,9 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 		/* Follow mremap() behavior and treat the entry dirty after the move */
 		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
 	} else {
-		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
-		_dst_pmd = move_soft_dirty_pmd(src_pmdval);
-		_dst_pmd = clear_uffd_wp_pmd(_dst_pmd);
+		pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
+		_dst_pmd = folio_mk_pmd(huge_zero_folio, dst_vma->vm_page_prot);
+		_dst_pmd = move_soft_dirty_pmd(pmd_mkspecial(_dst_pmd));
 	}
 
 	/* Re-arm RWP on the moved PMD if dst_vma is RWP-registered. */

-- 
2.39.5




