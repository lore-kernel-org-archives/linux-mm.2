Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 735CEC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 19:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11A96B0854; Mon, 17 Aug 2026 15:15:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8966B0855; Mon, 17 Aug 2026 15:15:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D84A6B0856; Mon, 17 Aug 2026 15:15:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1986B0854
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5340E4086B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:26 +0000 (UTC)
X-FDA: 85111715052.22.2BEE9ED
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id B597B1C0009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="Yq/lpFdX";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=orwtdyy5;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786994123;
	b=vZg+lRvxkT+mj9FzPHq7eXWg6Sgi3bUKlwacwNCS6f9BnybgQr3hS4wxytT3QsUPvNYzvT
	1wyvfDsPRyjmQczf59W8qWf8tM9+BZzCcxX72QOVep4WwJNsda5tSPHItfHu2d6dinYYRH
	2I+8xzBLrXyY8yKXyVPT8LW4L9U9KT8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="Yq/lpFdX";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=orwtdyy5;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786994123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uS52otnHr2tR2+z+5rHsosAozZEXrniXB9g7aN7M4kc=;
	b=D7RUk0j/w2XJQmm41fx7REbbRX7CG/mmmLHO3uKcj2mYESngbtbxRfV9z9BumlQCrStu04
	w2VLpqiIddEEbsZjrZSf8WRyKca/qsKlAieibngJCMN/v5B4+CUxA2G20qqVB/u/AnQYIf
	PBbdYxBxA2ll37kt8W4kN5ZthObOwZk=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HJ8uDM3771846
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=uS52
	otnHr2tR2+z+5rHsosAozZEXrniXB9g7aN7M4kc=; b=Yq/lpFdXqUaFQ55y/cvY
	twJMhBIiYbKbykI5gtEAqvJgymqbZgRI51csQSJmHKmq6f0Hm2tAuq3J3+CZhnr7
	YNGpEpY61YiVWnjhq7OXI4VuZDEDQdYw4+sTBqEgd/MeO3oX9QisFYZ0o87SQSrN
	UEmCGAiZGKIv5kSWOlY9k1Tk0yqApjzW4Oteetqj4li77Yp65tqtNR01hlnllYk8
	UEtk+H5+ZXqsam73z01OYNRFfXqmpaNDfwlAQ935bfMF9S7qnk1sMtHPSL2YCswc
	l/WKybsXR++Ol+b/w17QlS+o9wgmfJSnbq82uPFsirfcfB6E0V5KSW5kr2Rmfx1c
	nA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4g486y01kw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:22 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92e695a3b28so25522885a.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1786994122; x=1787598922; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uS52otnHr2tR2+z+5rHsosAozZEXrniXB9g7aN7M4kc=;
        b=orwtdyy59hh03mb6C+dYa8pG7zKAi7L3YVrMacY/lz6hQqBe+0/lfO7fcnRnJFAXxe
         uYsDcPIqlV+BCXhLCX20Pi5uuz0edvnXgY3d3plCYfjkk2MmdzdBdHZujxhuzSw0N/lE
         q6iVQH1MNKZNQIYG8dXuOVCnyTEPPd5FSqUcILI9JzNeeDPy6qgbd7UhuXO/nL8xMnby
         11Fr9chYU2JkDCzJT0itdZyn+zj+un+pCnnscdNf7gmq4qbzcKW0vhyCTcAd74Hg6XIL
         oWRTAXw9ojZ/P6QH/G7S++ZVLAx8txbtX4hiu7ZzTO+O8Tc/pQze5sgZlNaUPC+iLVnk
         qVfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786994122; x=1787598922;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uS52otnHr2tR2+z+5rHsosAozZEXrniXB9g7aN7M4kc=;
        b=qfhkh+Y1mqEvtYj45kbCk9TEQsGUSHSXzs6eeSeSUlb/ohsng8BJazqydICd1ecJsv
         v2jGd1y5WJgMnR+nWt5JsLigRgfRGfZqaE/mW6WbfxEDRC32v1h0GFRf6kiWlUWkVo37
         6h2NBzvCYubzFicTiAul13ggkut4vtmZj0Ajl1GCVDMzCmcuFASS3d1hizDAKI4MtPPu
         VkZQuZeoZEW9411O69JbXdtNp7Q0WiFkGAQ6LUxsc0s3ga93cX36M0v3lyQOVjqyJn7a
         +aj0RPaXgR/GsrD0rUOMN3E3dDADGxj2h9n0f1st3xVmjdbqscN9lt4quV56sQ+J1oA2
         j3pg==
X-Forwarded-Encrypted: i=1; AHgh+Rq4Acjo6C2hhOo7mAZyG3bnD6ydwlypZJEtaEJhk8yB+gRuA7G/QGdR5PniBBMLuQZ5DHnMzyzw7g==@kvack.org
X-Gm-Message-State: AOJu0YzC+t1oPxgwZY50Kix6yvIHwN5nJr7zmPZ83AsulgZ6RNSkcE6f
	b9JXN48SCZI5HAxxYnAgLMcogZD/enRczCiHcAVCFMlKmGF//rRMue1xbg4krqnUaMrYJb3WHVX
	eDqrOaBVpJvwK9Eg0C9mihedp0Z/ahUzQ8NkG1UDXgj5jEYxw
X-Gm-Gg: AR+sD11gc38y4psOlzaswnEpfXV/0RTSWZCJUw2ovDksqQ2iTWSrN609g9V+l0gH+vd
	/2WCkTUzcoYLC89DBL28sLpXzLWAnE94hTqASxQHVYP+y+YLuUl8eqayF9Wh8T4Nhj7fVHIZit6
	DgDewFJGx/aLeCP+x1oMoc+OeDCRzijTxjyVCQjdsr1/QlOhwdlKiQ8WYIgfMluMa4rDmRmNMEy
	wvQlH2utlNGf9PHG3zjE8GBST5By46fBMembhFDKpcWNLCBBwdQCP/VFUdpF8CLJKTkJpQmpwSj
	X+1v2KIMNGDMluZlLPQSixY96i858Nm2+a6j+bgjubaWYgmXf16vpx2qw99nVOaKMeyKgukY9jf
	t4Hesf7jb
X-Received: by 2002:a05:620a:990:b0:930:9cbc:7121 with SMTP id af79cd13be357-9370652b374mr113512885a.3.1786994122236;
        Mon, 17 Aug 2026 12:15:22 -0700 (PDT)
X-Received: by 2002:a05:620a:990:b0:930:9cbc:7121 with SMTP id af79cd13be357-9370652b374mr113506985a.3.1786994121673;
        Mon, 17 Aug 2026 12:15:21 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.67.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499961098cdsm194692085e9.6.2026.08.17.12.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 12:15:20 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 17 Aug 2026 14:55:18 -0400
Subject: [PATCH v4 02/10] ceph: wait for pending fscache write in
 write_folio_nounlock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-remove-wait-on-page-writeback-v4-2-0e5e53d47eb0@columbia.edu>
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
        Tal Zussman <tz2294@columbia.edu>, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786992937; l=2448;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=O9Tsg2DIkPFDuC4WYkkc9VidXQakooPjbM/qwj4bX2c=;
 b=5KjgFa4rHDDNlNqr+ukt0N/yZwdNnaIHVZ5dUE/zMfXBKfQved4VywnPj/KcWF7B96dD2zhN4
 DZ9pOPzoGwYAjgco9ug4gnjGQ+YsGH5kko0oyjpSRbqsGnH5dvb0sGf
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE0NiBTYWx0ZWRfX3SFdRtQKguIn
 YclGPlmsvm2D4DbABJkNChhXCY5zPfG4y+9vpPNSQjr8S/ONUxZffyrxF5hgUF6Zmqmf8VYdSwt
 nY5OtGRgdjy+APYGgeSrEhrDFI6Yg2jusPLXUC8tyD9HDahQSY0sUUSiwVBngc0kO3D0UN+WRdL
 nVsnuOh5vIifjSK4U0KlmyBZPCedMDLP0Yy6QTdBQvTL8ZWQwT0J/r2Gpj0MZfZClHZuhyoBbTe
 xWLVGloIGahRTAZGj17LUHzhH+yxXZiluehiiW8TDjW4ZAWvxwegYj5zv0LaU6bgaCaWTwt1jnG
 ttQSwEC/2IxNpE3yJKkVYB2isUONP+PnEEhw9H/uFs7BCkFyLN8Cucz5JGJPZ+uphRm6vE4Tjh3
 4vRjGfLRZp9JDfBgCpxquIo28c8zaJuEwyDRJ/03t2ZT4PegpZjCTU0aosUdFqvc9NifZZp6ynu
 4Gqt2WxE0XxPhv9rCJg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE0NiBTYWx0ZWRfXxNgcgEFb1jQm
 gz3hJFVQ4+0SilOD3PzxO1yYTkMWBi6bi6w/sz7cEBpjWoU0AviBs/oSWej6mVbSEra9pJAOa/9
 w1RWv5gXZ3I092oZSN94jHgRIxkSnqAf4xnJ05WlrVt6HUW6NHB4
X-Proofpoint-ORIG-GUID: Qm2zD6z_7O66S5dr42kJ3aJMx51rLLmE
X-Proofpoint-GUID: Qm2zD6z_7O66S5dr42kJ3aJMx51rLLmE
X-Authority-Analysis: v=2.4 cv=AI0CnPLt c=1 sm=1 tr=0 ts=6a835dca cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=+gpNN1aRt999K7yrv1sWlQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=c92rfblmAAAA:8 a=VwQbUJbxAAAA:8 a=zYp62tllrndxtlEyWVMA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11878
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 spamscore=0 impostorscore=10 bulkscore=10 phishscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170146
X-Rspamd-Queue-Id: B597B1C0009
X-Rspam-User: 
X-Stat-Signature: b3bzkj4y4zyce6ta3y4esxxtkn344k6w
X-Rspamd-Server: rspam06
X-HE-Tag: 1786994123-463878
X-HE-Meta: U2FsdGVkX19J2jJ9AB1DBhG3RZR0AXW7KrrOVF2OGZE/mamwrf81YzveqMcCMjSrfa9Ws5CA+qbLCiJoTqoEWC7zOiwVbOKmsE95w7mQ+MzUJaDYM6Dy+iKcnveJXpJ+biwj2SFymQJIyBVYAIbF6GqK/QXAxWt2uGDjRwUJDH5DlN+rRMdjuuRjWK4MTLhrk6GjmTMXU2HHJvXuXdKe05S+Ku6KpeBlu5+hOcIBdgUm0Y9xpSv2qsr4saYXJxfcsoaSAZY62qfjIdravhn/AFKM8G3A3nG/eEzialACm3jxUynxSZiQ92gtscUJ3wkhn50mrUBi85ww3R2RbqTAlMsU0yI4L04OnVCZZDWVdDS1c6I/bu2BaCryCHn7iWSHEBkmIl9tImzREAloaTPu7KSH227Cotf5y47ukjkg5+hATALGG8ud33zl6eNEkDye8bNSseNoohAbB95bWYPHFhE5ccognM71flQ+pyia3I6a7H0loNuc7KgBScH//wnw+p8LiVYTJWmTbFrvQ7/uDELLBxuHueLW/w0hMZa7UCleEZIV3HdHgrZDXZ3oFTwKcpqUNXxhpE6OI7uXuga1OTO6F30BAK6wePwBGL3UaBXMwPcbcnHWEsfp85QliOOSHNk+4+dpYJ9/J1r0dw96Y0qB8833YR4CRpSGriSwCB9EFsmr/bIJumED/dJjcdSKb6Fcb5m2DvwIvSKEbtRcyConYeb6A845xSutXB/0GtTswpnXBtVzZFzzXSTM4VEsKlRRaQ0qZptIw2qGugAcFHOV4YqB3/dUzbPv8yCPCQpdb4VPsZGlHU/tQrZVi5jzSgFaxkFiHe+mVin3beL5EXxiQ9WKceDDmymnfMpteJ+mNaweNqCjZm8CNI2Dk96LqfEMXP4GpXYUHdCrDPliuGI3e1ILhYW4wRKQo5mu8GRFeWyv0nwcNcy/I2ePZg1dChiOEcqrZIJpyNCyJ4K
 wY5Ms7za
 m3TDPanB31dinvIw6nNF53Zv9kxOUYL0xtTj3jkajCZpmpE9nTdtt/oO+Mh1njdtOeNjr4ZWKrGVON1EE54hj5Cv90R9NYMvblce1ArUNFy34dar5isXPLU+EVmO25D0QPnIdxrZff66gE38SoYWd2fmTrlkOhZdYvpS/PAx4CZinZpEOZx13Z4twmDdbfVGPbfYgszhuPPKp+jSIKZaf3ukRywJQv3bTbDGHZ60kZIYzdDD4SCUSMx5I0qxr279CJfZMD++rHnbTO66QC530c/RSyb+v2o8DJuIikctLxtc2NIIZ3V9biLVAym9iLLbPCVtLbULOd7lTzvnWNWuyiV7xMZVvLOPKhegcb0lyjumh7MulxBiFWpRx/QgYrEXye8sGWdyFmC1K/6RegSzlBhTagHrV0Z9uROQRDrNfnGBY4HihFtmQxvDvHvdOpIEOl6SGxfEJWkfnDE/g4FZXzYejqNWKp0NaCKrWLq9QrGSOA+g7sDP6pTtdCy5tWo5YTvlkYOEGMt+h3vA0C2X4jfbcEMzo+toIYqFewaT/kbPzSAU2o6/cfxWW0NMBzg2hDpJ4l1qDqZa89LQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

write_folio_nounlock() marks the folio with PG_private_2 via
ceph_set_page_fscache() and starts an async write to the cache via
ceph_fscache_write_to_cache(). PG_private_2 is only cleared once that
write completes.

If the OSD write fails, the error paths return without waiting for the
cache write. On retry, ceph_find_incompatible() would wait for
writeback, but not for PG_private_2, before calling
write_folio_nounlock() again, which would trip the VM_BUG_ON_FOLIO() in
folio_start_private_2().

Wait for any pending cache write before starting writeback on the
folio. Do so before bumping the writeback congestion count and
allocating the possibly mempool-backed OSD request, so that a thread
sleeping on the cache I/O does not hold either while it waits.
Add ceph_folio_wait_fscache(), a wrapper for folio_wait_private_2(), and
use it.

Fixes: 1702e7973410 ("ceph: add fscache writeback support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284%40columbia.edu?part=7
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index d5a349daf4d0..f1f4caa8f9df 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -559,6 +559,11 @@ static void ceph_set_page_fscache(struct page *page)
 	folio_start_private_2(page_folio(page)); /* [DEPRECATED] */
 }
 
+static void ceph_folio_wait_fscache(struct folio *folio)
+{
+	folio_wait_private_2(folio); /* [DEPRECATED] */
+}
+
 static void ceph_fscache_write_terminated(void *priv, ssize_t error)
 {
 	struct inode *inode = priv;
@@ -580,6 +585,10 @@ static inline void ceph_set_page_fscache(struct page *page)
 {
 }
 
+static inline void ceph_folio_wait_fscache(struct folio *folio)
+{
+}
+
 static inline void ceph_fscache_write_to_cache(struct inode *inode, u64 off, u64 len, bool caching)
 {
 }
@@ -783,6 +792,9 @@ static int write_folio_nounlock(struct folio *folio,
 	      ceph_vinop(inode), folio, folio->index, page_off, wlen, snapc,
 	      snapc->seq);
 
+	/* wait for a cache write left pending by a previously failed attempt */
+	ceph_folio_wait_fscache(folio);
+
 	if (atomic_long_inc_return(&fsc->writeback_count) >
 	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
 		fsc->write_congested = true;

-- 
2.39.5


