Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D6AA606A337
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 02:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bCC6XhI+
Received: by kanga.kvack.org (Postfix)
	id 0D0636B05B9; Mon,  9 Nov 2026 21:33:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 059DF6B05BA; Mon,  9 Nov 2026 21:33:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E657A6B05BB; Mon,  9 Nov 2026 21:33:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDF066B05B9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 21:33:13 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5500D140630
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:33:13 +0000 (UTC)
X-FDA: 85417637466.16.857AF46
Received: from mta0.migadu.com (out-252.mta0.migadu.com [91.218.175.252])
	by imf26.hostedemail.com (Postfix) with ESMTP id E3C7D140007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:33:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bCC6XhI+;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794277990;
	b=n4XICSmQwNbNz0Xi/7b3c2Vvtgdmb3uU/O1tESnHHnCLWbQC1jrc86eYpDchNpeOgvZGVM
	bjyE+ZQlTOO+lXpXWPttk/9N8x2m7UKIL75b7HzdtaQ5gmpDHSXoVSGlPnwhN/LUakJ83q
	20K0aMU2YmBgA7x9fvxDAjaXzMnyNpE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bCC6XhI+;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794277990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXTpqnKMRF2UhXCAIWMIqEeS5u8oD4PTX7PXriEks2c=;
	b=mBEnxo7RkEICkEb9f2CgN/9xKcg4OcR5GMPo78ne15yNydoAwgsWSvQTM7G8h8C6qfizsn
	uCj7OqI1BctOd/FcaaznwskkfCpTvx6xhjN3eLQjvLQJJeuOh7ce1onhBKw2v46Ks+KDZM
	N/lRhQas5p6nUf6PphiwYn2lkcRSVnU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GXTpqnKMRF2UhXCAIWMIqEeS5u8oD4PTX7PXriEks2c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794277988; v=1; x=1794882788;
 b=bCC6XhI+ltgfCDsf/yk7F4CyGxAl/gCpe87iypya3QEAuULhSPaST+YpcdHmlKmUk0i/ULYe
 mGg/+3kuRKtpsDDiX5OsEJwj+AjIKaxzynS4Sdz5oLLaQIn74HmTmlsfqzaEA/70RGPZNbGQaES
 UgrteXZg6P2tnQHPlEsQt17Q=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 9b9f986477d9f7b2;
	Tue, 10 Nov 2026 02:33:07 +0000
X-Mizu-Trace-ID: 9b9f986477d9f7b2
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 2/2] MAINTAINERS: remove myself from MEMORY MANAGEMENT -
 RECLAIM
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261109-maintainers_mglru-v1-2-c25e6de60bcc@kernel.org>
Date: Tue, 10 Nov 2026 10:32:47 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 Ridong Chen <ridong.chen@linux.dev>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <105EC3D5-3A72-4617-A6AA-9E37EDD836DC@linux.dev>
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
 <20261109-maintainers_mglru-v1-2-c25e6de60bcc@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: k1djs5gkwrm9s8w9h8ezq8zzs4rc43db
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E3C7D140007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794277989-610054
X-HE-Meta: U2FsdGVkX1+EutHtclqVOK4n5GodwbB70HGhzbCG+kWU1XdjMvrf5bw4kuePCCqau7hHvhRDt7sVP1nLv/lZOTn73zPltzPwql7HeqJ/K15bDFEKjocD2FcWh2n3Szre85qmRCypSNL6qjHpqDqXkkPqyNMHm9+i2TsnAty/SjVNNWVAtW5rSGYmgU7TiiL4HlvYPuXDvYK/Ij0UUi7VYCTx+uJ8sh56NQMuzIf3QgJrdJuMo+ZmrXr9qmtAG5gBKrA54IVek4o+GEeE+S0hrQjroCYHFB78nL61NJv/lSkb8Rk5cilA9ZRH6FKh5lmNC/uyqwNDBJzOL1LLFCT49Q7bfje/N/+ye8M1HjaMHSXSQTCGTpKrz/OcviAamco0k7Mk+EJizKalWMazI7+PEp86m+AMcSxeD5vyHAEVDDLg80AFDDoxuih5wW0EICAcqsfur9bNCfNse/yJepmyYKkDBs6LiTLgXNHcP3cWqW2WtfWr2BirQGuu1n0KLNuHExAf0R0X2+ncci1GgWgGu4sdfg6xSiUV6NQ6aM8JT2pzyRZkPK498Xd0I8o+bl2l5Ge+qBVF5dYxiT95Eq70jpBq5Ss3uJGmxX8Iaeaypprc6anoMqGP9sJBe9uZZ0/XK6Eo82g3w1HNZR+2br6Smktcov6UTdyfloXzK2d3tyS+rp+WksgmVkjtddADrInAAW1jNJnNIheTvMtwbFdpEk04wzvdmDbRTTgWZdn2J1r9P/6X4YOlfSmVJyj/2YcJ3IJNW6+D7RJAQSIl68zW/+32vVb/gB0cMZMcjo8KaaqXk/Lmh+bbE9hxD49JS9K49yDbSfAMHtWM2twmn28++YCiaB2ehPZnDDErQoi12rbbkDXZy6mx12ixGGW3VdbaZJIKrOAMSqQXoRTHUP1C5rNZ/FdS3Nk1IyT2MzZ9vQPXEQAlzG9jP0zzHG4WeC72GIQYIwLE2EGiweCtbGg
 OOUfEtc4
 vV/QphXfmFulEpmQ6l/KPUWlQSGhfHnH+0SwfD2SC/8Ry4dPkphnwtFCc2ijI/g3Hi6FLdV2U+XlpHHXWr2gE2Hgx4EFbXyuth5Hn0UDPiAmI1s8/PC7iLR/x/S018fPsbA2NzsgsgYuHbzU7FQ6/AFYao8GIz9zbsSi2XnKt0SsAQppjgQFS1I04KWGH6cTqAUIKlERdgON0+N9Ifx4ezRe1gVA8qIvHs9ECSlYZNbuLD23lImvn2GUf3FzGBNYr7qFJFHvMFBXeszEni3H3w7hqHBnxv4LrRvB7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 10, 2026, at 02:31, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> I don't really get to look at most reclaim related stuff. For things
> that are actually relevant for me, I'm sure people will CC me.
>=20
> So remove myself from the MEMORY MANAGEMENT - RECLAIM section for now
> to have a bit less noise in my inbox.
>=20
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


