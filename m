Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79A05C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 19:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F3136B0858; Mon, 17 Aug 2026 15:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CA9D6B0857; Mon, 17 Aug 2026 15:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592A46B0858; Mon, 17 Aug 2026 15:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7A96B0856
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9BF8CA04B9
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:37 +0000 (UTC)
X-FDA: 85111715514.25.57941B6
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 21D27180002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=jULaqmw1;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="TVcv/C9w";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786994135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDdlk+dJjpkXdKVusIRsLy1rhBsPVt11GNFJest4++I=;
	b=Gol6+6BYgWItuWOBkmwq/+Kt9oRvXfSjgPhQ/j3/bOe7CGyPsImiltr0f4jWnEfRNjSs3S
	ICRrgitIDEva8LZh41eAU97NvrSTqqtujCz500s2FPYrDjcS3IUmz6pria4Ow6oJcwP0gx
	TXJyBW6R6AyPEvkCR2bqQMwfM5Fsvgk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=jULaqmw1;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="TVcv/C9w";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786994135;
	b=PEgyMKtgk9r9nR7zVFxid+tiyg+xa7H2oIA2wSn8+qDY/xP0okMPz/v7jtVpXVbYy/x43U
	JXTfteBD0DuyRi1JVsS+bWY8iG1uK/6cfptGBczAZcnmyhwh8alFEKzddiVJDcFUchWcRT
	34DjaHXVZ6T/S++eQ/0ngvE2IRBxMH4=
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HIZ1HG3664402
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=eDdl
	k+dJjpkXdKVusIRsLy1rhBsPVt11GNFJest4++I=; b=jULaqmw1ftBKn5QXmpnj
	YiVfI/c2EPl8LF/ilqtT5U4ebUDZoyQ9m/x6rkF0FswWW9VcKD0TJXKC9nYwbWe2
	w0YMjjCWXDzWrXdnVthu5P0/gFRsYGlJRw3tju0fhP1O5glAky/2XBdauZD+HjwJ
	ZEMH/ITPKocDa2EdtJMZM1x8mJCOTexiUP85TrpEBqPA8eeXhaiCMM61MovySs6n
	SUip99AOgKo+k0/joqaEqvSjDL4mFrjt6yFDQrjYVL8iCkqGQ97YxK3dg51fiNGZ
	rxe7mKbjlo1FbFkhEqFm7FGituAitLn05MAM7veQUmqwVk/8j9xHgCc6QXmpHa6p
	Qg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4g3mkfnqh8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:34 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-936a796a23aso325965585a.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1786994133; x=1787598933; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eDdlk+dJjpkXdKVusIRsLy1rhBsPVt11GNFJest4++I=;
        b=TVcv/C9wbvudZwBO7zHyVyugJXtREx9gUmjeIMNkPTDJhWQLzy+hzw0TYLBJ6yW8fj
         KkudSfqggE6A4MKqQ30QT4HgYVqtsphMeQhwl34ubejx1xE4hBL7faUSyF7KhDqwQy50
         gkmAXGynXTvus3N+7L588PfYBcmZ85lhFVc1rN3DpSGeoCCCfcbK3VfbpWz32m7BKvQG
         R74kwfMBul3xrXBiC6RwcJlVtrn6iIlD+DhK/RyrtrKPluzdNcP9D3gTfJ1CiuNhJ/AT
         kLqg4klbJG+biYpY3uhMnkVRpgveU6BFM9r/3rkNUYXMREJi7dfJ6GdK1IqkZN2oEUhd
         CY+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786994133; x=1787598933;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eDdlk+dJjpkXdKVusIRsLy1rhBsPVt11GNFJest4++I=;
        b=ixR07F8tHG6b9xEeQuaAuefkvUuq11os7+rm8G4BYEZ/DS/LvQflH1ongWB7D4PqZN
         sUZXJ5lbHnqqszHTUvPwuz4Dx6nfN/jU690eRSfSlNCIKfZ8P7slIJYxNOMBeVV6DabU
         x0BraY12eGvFIf77Eh8L9gPVUydcvhU5DNDurOWhS+/Ee39d6CC5xpYTgq/xzJbzMJYI
         zcJsHm+nJ/yUcQeKgyoQs+KYgBQrpMOLp3pjul/TjcbzHbjSDM4+2d17bsEzMAeVOUqa
         LuPAoaI71e+ITgUr7SbNP9zZ+06zdYyuKA9WSdu8UT1uLhP4cejrFNFk2/UoDeT2ElI5
         J5FQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr3EHIPRZg9YwpBbYKrkvtqNRhcA1a6AiNuVEylrOfCoUoMVLojsY7NQfZVI2CP7TfaVLlYKmUUzA==@kvack.org
X-Gm-Message-State: AOJu0YzCTMnbfq+AiP9rovg9Fcwyrh6fUjCk7hBFmEmGplzKhF1H6r36
	LMLKImGB+U1M9sBhA4sJv+X16/0PUQGUmNxZQVW1xUN0zXQocovCv4FBico6Ji8tzDfUymtezm5
	FVz9oTlkMGomY6fDtxk/ZeSdKkpZ78YF6AiETYpqjh45xRRgj
X-Gm-Gg: AR+sD13ER0enXxU7ooCGaA7BkE+aw9Z5bgXLgI+EzDzpq5UodxuQBEip0xlsNWj5Ug1
	m/6v2hTBbEu1p+S6o0gNaQz2+OAczod6BQn0qQHHrUN1/lQG1NSiAqGGXZmBdWj/wd6u4IEyUEr
	sbZXVXEK1x8lHM2t4hm57wp2G4nAVKv08MX3C6moJ17PTmwifo9j+oHwWDB+wdYt21Rq3jkFd3/
	rRDcfkRM7RkCBng3mZaTC9VcxLAeuNhSf/fSRmX8CD0m8YYYlZ4Lth7F7ZxyUNPTGkjSQgowUTK
	76YbpAfnHZUtuwXmv+hNBIFHht04aNEhUTa6OuZE0xNn91AuZnrguTAT//UeDRCf3l+Ha7e1wOU
	MXp+QYmcH
X-Received: by 2002:a05:620a:5be8:b0:930:cb79:ee65 with SMTP id af79cd13be357-936d234d4f7mr2386076585a.30.1786994133407;
        Mon, 17 Aug 2026 12:15:33 -0700 (PDT)
X-Received: by 2002:a05:620a:5be8:b0:930:cb79:ee65 with SMTP id af79cd13be357-936d234d4f7mr2386069385a.30.1786994132905;
        Mon, 17 Aug 2026 12:15:32 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.67.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499961098cdsm194692085e9.6.2026.08.17.12.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 12:15:31 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 17 Aug 2026 14:55:21 -0400
Subject: [PATCH v4 05/10] ceph: convert get_writepages_data_length() to
 folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-remove-wait-on-page-writeback-v4-5-0e5e53d47eb0@columbia.edu>
References: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
In-Reply-To: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Christian Brauner <brauner@kernel.org>,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786992937; l=4666;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=CjGUfQGtk1hGuYgE8mlbsK87Dxg0IBB0DZ7ppRlE9ac=;
 b=KhVLTaoUXjCbc7TXQHxw+1ii0RoWMiuDhToT3bEe8ZCyATqgjx9FKeOWObd6DwkbPk0W2Em74
 xPeOjr5sfrPDCr4NF4569Y0rF3FJkVx0J1j1f5Nmpgg1Ql8RB3Ffztx
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfX3xiM//NnyS5/
 Am08ycEc6FWGaj7tqVcjAWrdtugJVs2a0kl9sug44+QJMzSuM9dYL7RiQi9q5GtqKJSG99VeCUw
 XKa4s/QPNryHjFt9bl0hY2kRSjPPka+68dKJxGehd200YYCh27tQ
X-Proofpoint-ORIG-GUID: 6bBNQbzAcLOC8MZ7GGFldz775k4ajPPO
X-Proofpoint-GUID: 6bBNQbzAcLOC8MZ7GGFldz775k4ajPPO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfXwiR6jM67vlZR
 1/bHmNq6OqotY7Kyg1UK1HR1rbeVgzsVAEIHOPVCiTt1kCqY+qJNFWUvVI11tkl00hlKDlFjH51
 8RUV/n8j/XNFUromYvJa9AgHdiq0xfkOeewcZ1bjrb55j8adTGUYySkmVcxcupf5o6G/dXFjrgf
 XMwzXnY51W1a1FIBbu4KzFzDH88kzKFsMdgF4QCMlKzJKj9sWQ/gMVNLcTEdDWedLAHlTV3YT9e
 W1T7vR9T35SDoQ1NKAf6yM4m+++8ARhlZHAf1egGTilbHGlAzeLUpfu/I+7VroSI2ob7m/Imeu6
 /aEroplq6LA8EEc0inQCZl/aE1ceroNMA/CSNbilEU5j4q8u+aprfDImnTKBdBn7T22R9t4FFKU
 WlVuLL8Yo2XZpy2/WNf4GFMzUrNIEGizpIDTIq/Im+HMVPh/mmm8YLGCJu3yXAWpbHaIqU5pw7+
 /O6H56YY9feqKmBtj3Q==
X-Authority-Analysis: v=2.4 cv=C+vZDwP+ c=1 sm=1 tr=0 ts=6a835dd6 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=+gpNN1aRt999K7yrv1sWlQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=4S3DF5rXG3rfafK4-1MA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11878
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=10 impostorscore=10
 priorityscore=1501 phishscore=0 bulkscore=10 clxscore=1015 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608170147
X-Rspam-User: 
X-Stat-Signature: s8ajbhnuw9bc37it9dp4emukydkayxxu
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 21D27180002
X-HE-Tag: 1786994134-551923
X-HE-Meta: U2FsdGVkX1+9lKwXrC7uZHbaiQbLzEyp41b34BkuQWZF0GFwi8P4EUF2ulXQtS4foCVAArGP7pluRqTr06WYq/rNqhC5xfR6+WLCRgCVmQpIpG20/lr3ZpTgi1cJ43Yukh/RWf+NMRdZnPZZQAKuZ789iHA/pXSGI2K5pJ1thNaZqJlETDHdFy1AyaZhfUx5xtrfBLTbhGDjkNVB7uG9RAN6vy2qe39HXDh3uZgH+xqZY9RK/FwalYMD1R6wNBv+3PIbpmBH7oMlP2WqMDtNftZVWJEiiZn/i7QeTO4K5QoZ/ChCvrNVVh73uuEEpBrvKfoJRYfHEgjI66Lpi17rg1Y97HBD0V0f6nIQYOj5ZDoN6yI4BMGzXaxAARofV35tCk4A48K7mQG0Qd6TssgJVH1rTs4C7vq1A2dXl9tV9fx4z9ImZvoHcz6Gydnc05J3C1Q6cEMEi0Aulz4fohR8BTtUX0nGwlJTg1F6NZlZDuCAO6unBhDqkab1ffyrq1ZsJz9ADP9XTHeXCxdMCCPCux/G+x2eP7QftKOn4HyyQY/sWpgQj2jADXcUmEmYpXwXE0sVU7lxRtrhHrHxtHlfZf5CLK2oQbU/XMbzEnHVBBhlSKAuZno8NyMHvR/QQkYFGahKqy6n8DzYTopXXXx+f/k/4tHEYTjWTziR6NtDN4atEFo0mi5ciIRl+k6R00ReWfjEzmluuxD/UlMs4fYq8gVprCPZoQC2vdMtgk55ELaYDEnkiCdRbPrkoqeEwMoxYuzBq40AIZuKbt/3X9OVcqQJQSaRJYg4B2SmoiKcFnZR6bNWl/sGrQDCnRcRKCQadyAaitKiXw76BZW+cU/UVGyVVU2xPjjavGd/tf4Xwmxlp6DNelr1RqgATXkvaoGReWyZLdMpgsvpJiM+cRkhIriwMPYqn3qFzpYYqanC1v/lTrHUNDIj0+hViUrA674M1k6e9PAFIerJkQqIzmF
 uqIKagmx
 P4ggnwgV7ugsx/f76WJBVDDpoZG+U2ftjbq0q/T7w9KDppgTp5wL4AB/lIr6FERJ+ucY6Ea0qsHxTqev2L1XLnXCVEiayaEe8D3SzaphP2s1SMTmQlIr+a18nnIUH2DpNnPoEGuH2AAOj7p5hpBUjeOefnnWVw+aasp68RLtOUY4M9CVsm+Cff8gbKrrAapfEMF0s6o4kDsyzrUi630noXseFywLwpeH1QRIOO4IeLkHcID+toKsejaAYRYLJwVHriJwr16mijYh5QoT+k35o6M9WcAu1r053y2lZ63Wme9X8Cuc4mOkfEYhEBzySzCA2OwM+xlwSpdtBcgg1SSj8YD6UqlqNlHCOZWLcJaA9BF6KCPqgPi9XkuBg6rYnVfwoZd5G8BGrQVcf/sVeq7U49MjiWIy7vb2W/DqI9pYfrI95jgMSlPAFhJtIAEgCJPBTQDbDt8cWmQ+c8KjwOgyk5WMJ/EL0ZAdv4kf0AvXO+dr93/2Fo5eFoi8bN0NTgEjIYgDlsELktSx/5Y0QpHaKswRhXU8zPjsyQC3jlqtigDUuvqmi1hP3fLIdBP5qm5huUB9OUh/wPk3fdTJuSPg4SFzsBs5XHPG1Q9+miRhxtarIpRo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce ceph_fscrypt_pagecache_folio() and ceph_fscrypt_folio_offset(),
folio equivalents of ceph_fscrypt_pagecache_page() and
ceph_fscrypt_page_offset(), and use them to convert
get_writepages_data_length() to folios.

This removes the last caller of page_snap_context(), so remove it as
well. This also removes a use of page->private and a call to
fscrypt_is_bounce_page().

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c   | 25 +++++++++----------------
 fs/ceph/crypto.h | 15 +++++++++++++++
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 5efc8c7c91df..a34849374f65 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -29,9 +29,9 @@
  *
  * There are a few funny things going on here.
  *
- * The page->private field is used to reference a struct
- * ceph_snap_context for _every_ dirty page.  This indicates which
- * snapshot the page was logically dirtied in, and thus which snap
+ * The folio->private field is used to reference a struct
+ * ceph_snap_context for _every_ dirty folio.  This indicates which
+ * snapshot the folio was logically dirtied in, and thus which snap
  * context needs to be associated with the osd write during writeback.
  *
  * Similarly, struct ceph_inode_info maintains a set of counters to
@@ -68,13 +68,6 @@
 static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned int len,
 					struct folio **foliop, void **_fsdata);
 
-static inline struct ceph_snap_context *page_snap_context(struct page *page)
-{
-	if (PagePrivate(page))
-		return (void *)page->private;
-	return NULL;
-}
-
 static inline
 struct ceph_snap_context *ceph_folio_snap_context(const struct folio *folio)
 {
@@ -701,7 +694,7 @@ get_oldest_context(struct inode *inode, struct ceph_writeback_ctl *ctl,
 }
 
 static u64 get_writepages_data_length(struct inode *inode,
-				      struct page *page, u64 start)
+				      struct folio *folio, u64 start)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_snap_context *snapc;
@@ -709,7 +702,7 @@ static u64 get_writepages_data_length(struct inode *inode,
 	u64 end = i_size_read(inode);
 	u64 ret;
 
-	snapc = page_snap_context(ceph_fscrypt_pagecache_page(page));
+	snapc = ceph_folio_snap_context(ceph_fscrypt_pagecache_folio(folio));
 	if (snapc != ci->i_head_snapc) {
 		bool found = false;
 		spin_lock(&ci->i_ceph_lock);
@@ -724,10 +717,10 @@ static u64 get_writepages_data_length(struct inode *inode,
 		spin_unlock(&ci->i_ceph_lock);
 		WARN_ON(!found);
 	}
-	if (end > ceph_fscrypt_page_offset(page) + thp_size(page))
-		end = ceph_fscrypt_page_offset(page) + thp_size(page);
+	if (end > ceph_fscrypt_folio_offset(folio) + folio_size(folio))
+		end = ceph_fscrypt_folio_offset(folio) + folio_size(folio);
 	ret = end > start ? end - start : 0;
-	if (ret && fscrypt_is_bounce_page(page))
+	if (ret && fscrypt_is_bounce_folio(folio))
 		ret = round_up(ret, CEPH_FSCRYPT_BLOCK_SIZE);
 	return ret;
 }
@@ -1589,7 +1582,7 @@ int ceph_submit_write(struct address_space *mapping,
 		 * data length covers all locked pages */
 		u64 min_len = len + 1 - thp_size(page);
 		len = get_writepages_data_length(inode,
-						 ceph_wbc->pages[i - 1],
+						 page_folio(ceph_wbc->pages[i - 1]),
 						 offset);
 		len = max(len, min_len);
 	}
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 79cb563fd887..948c8b5dca06 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -162,6 +162,11 @@ static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
 	return fscrypt_is_bounce_page(page) ? fscrypt_pagecache_page(page) : page;
 }
 
+static inline struct folio *ceph_fscrypt_pagecache_folio(struct folio *folio)
+{
+	return fscrypt_is_bounce_folio(folio) ? fscrypt_pagecache_folio(folio) : folio;
+}
+
 #else /* CONFIG_FS_ENCRYPTION */
 
 static inline void ceph_fscrypt_set_ops(struct super_block *sb)
@@ -262,6 +267,11 @@ static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
 {
 	return page;
 }
+
+static inline struct folio *ceph_fscrypt_pagecache_folio(struct folio *folio)
+{
+	return folio;
+}
 #endif /* CONFIG_FS_ENCRYPTION */
 
 static inline loff_t ceph_fscrypt_page_offset(struct page *page)
@@ -269,4 +279,9 @@ static inline loff_t ceph_fscrypt_page_offset(struct page *page)
 	return page_offset(ceph_fscrypt_pagecache_page(page));
 }
 
+static inline loff_t ceph_fscrypt_folio_offset(struct folio *folio)
+{
+	return folio_pos(ceph_fscrypt_pagecache_folio(folio));
+}
+
 #endif /* _CEPH_CRYPTO_H */

-- 
2.39.5


