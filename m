Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 189CCC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 19:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CBE86B0856; Mon, 17 Aug 2026 15:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655FF6B0857; Mon, 17 Aug 2026 15:15:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56BA26B0859; Mon, 17 Aug 2026 15:15:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3090F6B0856
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8C261A08BD
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:40 +0000 (UTC)
X-FDA: 85111715640.29.6ED61BA
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id 42F19160005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lRg4L2ed;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=qkfU3DCr;
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786994138;
	b=wZR2EYbmTO+9UTwOkKVld5qg/N7KIyKPw5fiZkbB7itAgldewVgc59jPEshK/z06ljlOgo
	1teUjfnb9F5bOiPne+SaSPIZqa+yiHTZeUKrm/E7rOcBHfydatxmRjnx/UjAkxxBEOwN/I
	LkgCmRvQsZj5NyoOy0DdIFtoNWyoDS0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lRg4L2ed;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=qkfU3DCr;
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786994138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cv9x6z4kwz6bNvCwiXVm4zgaYEgf+1gg2Ey2bAsoUhc=;
	b=U0RC/DsbopRMK8nCrGcko8MnOIcYiBes47Sw+XZ8REyMQaSmSRXFrJ2PwUeP+3c0yEWycQ
	icuAExqFVe6bNaJwNUzGn9PVDkyetAkR8PLCF6f0uTWVn2ixL9Cke84Ou1ux55EVZWhl7H
	irx+E9nZrQKyrxA3vqQoF3iSHgIVJGk=
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HIw45n3692655
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=cv9x
	6z4kwz6bNvCwiXVm4zgaYEgf+1gg2Ey2bAsoUhc=; b=lRg4L2ed+Jsa2qHswH63
	KcodI3Hp8a4vPrVCD4k5YIU72t4hpEtRkrS4qasMfGjF3Mr4Sq0B7UE54JO9kkmS
	kAGoo3cloL+bXCOdDvpTRPS8BqjS4xLlI5o46K82KXQHVMk7yz/mkLZidYD1mqpl
	UxmIZQscOgNneKO6nlbvFMnTr3QpAEbABExwB6Pc87qYdC+VtKxYC7hUoDrSJLkd
	sXTg66q8bEllO8ycecl+3HJTG8o66q38vFjq60xj4k0l7/OFvfkiDOA6Kx4eQ1US
	6NqyJ0pzPdJgXiUEC4WwIiF8pqrxknFDhszQQI0zDGFiZo5tKCe0ZvGIq0zmZDYO
	Aw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4g481r85t6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:37 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-92e63df032bso27869185a.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1786994136; x=1787598936; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cv9x6z4kwz6bNvCwiXVm4zgaYEgf+1gg2Ey2bAsoUhc=;
        b=qkfU3DCrHenrx9cpob4b3z9uo9uruAVXFelBtaIQvtgU3wgTmeMCNm7jH49k7w+qPk
         9KzRIRITVXakCKEbLrS/kvMnfY7QvKmGYFqAKdVrlJu3pmKHifX/cfVY/cFInISQsIA4
         jwD1DHLlKg50nWXF1JaJAfzFJCGVK910aikmU55Eh4gDWddO2Va0MlWEv1MgFhEPKSWm
         rnlbqJSFPTETfKdc8Kbxp1o47FaBsm60WkxXG/XomeUX/nP/YX+JBk21l4sl8CuIFpNE
         bk1dnqVnPJWrRkGaeGa63DyRKE0yCjafx6mQOoKvF13gPH44LwHwRk5YdxQYGb/pYFm/
         WiOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786994136; x=1787598936;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cv9x6z4kwz6bNvCwiXVm4zgaYEgf+1gg2Ey2bAsoUhc=;
        b=oruexeuzc+Kf80ZsXwkHSAuQZLzaikXtB7jipQvrCFnt82fFlxwCBam5zS/+Bx39kx
         ZCpUBQoAAu26teV8XjXQMkVNiIthL0mEC1bG8udGKsdapDo4GeZ3GHUiTNo7EH/Cs7cc
         bHHiJSkn4Uqro9uZxRL4SGQc8SWZQiYq2F2lzLL3i6G/LsHezXktX3unyr0VXstvUMwf
         zBqY4c+y8f2udS3AyI6vwVxCynvzbfKJ8inHDHhn2ncVPcIVvusP8y1mqDX6N2VeREoZ
         OXQ9HUpdYXV8NOYH8RRFNavS6sAvLHU658xvGTRDN0mI4V5knNpntoXQaWg/MHtIdkLs
         ce+w==
X-Forwarded-Encrypted: i=1; AHgh+RrnEP/N+WTwIAs0QmTFmlxnE1gfBhISDBOHw7y0ia99JwW9Sqn8VHBOt3JxoEKn8CntYQ4iSG9KlA==@kvack.org
X-Gm-Message-State: AOJu0Ywp3cPJ2B216ET37LgPiTKbPK/Y7K14/4ZqcNCqC6YSTD6TUgB3
	DFjPsqwo0mIkujn1NTRBiR4UxEmcxJz2dhCiN/zBdy68JkGX97yI8+Cy/exdFrm3hSeKcw3zdyn
	OvZlM6wLr+afFtCXv80NhNZhdobqmeJWIb11qEf5RWN/tl2mx
X-Gm-Gg: AR+sD12pfFl7gbGDib4J4IdZZDJtwXWh6/qNGRC63V9ONNIkcajuyGzr1Yg5r9Aa8S7
	vgOW2F+JRO4eCmHjG/JuoKWejYgQp8MaXMaA6ojByxNWj/3MzobrvhnwC2PPV0p8z9mjBfGNSkf
	eAyfLNZa5nPfTqCqss3mlOgwSAmogQpcaS09V93Yvfq8fHMxEKlfnCiB/K4Hy6nc5+STKdZo2XW
	4qWSP1Qieo2sIsTmABe4lekG6DEh5QQ8ZvaqgD7Z5uYRSnrWL47BcmVCF25yIdQdCyeUOSU02Uq
	+YQBYiYMBQTPpZ77OpXIk3DATK/jwepRkWILJRq2k2LiYeAxy1v0mdIaySV925xY+diHQttkx6Y
	6zfGTZIln
X-Received: by 2002:a05:620a:2313:10b0:92b:6e09:b0d9 with SMTP id af79cd13be357-937066cb326mr126138985a.21.1786994136522;
        Mon, 17 Aug 2026 12:15:36 -0700 (PDT)
X-Received: by 2002:a05:620a:2313:10b0:92b:6e09:b0d9 with SMTP id af79cd13be357-937066cb326mr126132185a.21.1786994136084;
        Mon, 17 Aug 2026 12:15:36 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.67.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499961098cdsm194692085e9.6.2026.08.17.12.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 12:15:35 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 17 Aug 2026 14:55:22 -0400
Subject: [PATCH v4 06/10] ceph: convert ceph_submit_write() to folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-remove-wait-on-page-writeback-v4-6-0e5e53d47eb0@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786992937; l=4837;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=3Yr47TYe7cqBT8sK97KQzuLWu9tCzz5B2cD6geWhTi4=;
 b=HevgqnjCrhv7I6rtbygRfzOdftYjeffz3QrWztwIqA4nnzsdtsyhS4Vf1/OT/2/P9RAjsOas3
 +udOFxtguS3AMtcBhXi8TgPRbonGiMlS/BouQqru1fUXtT3VoqirO/5
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfX0MA+IJ/jFIGD
 J0hIqbLM4v8Yws7CJvn0C0RBXEmBFBVwGz42rnQ2ZkptgohUXFMgHYB4jjP6x7fA0Q1lqmB7nko
 CP/+lscy4Nz9v9M5hYIqRpM6q8Bh1sldtzUjGJyRJjCAExk3PK9y
X-Authority-Analysis: v=2.4 cv=MOpQXsZl c=1 sm=1 tr=0 ts=6a835dd9 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=+gpNN1aRt999K7yrv1sWlQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=RfODlEta0-z8xtihUo8A:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: yCHCwLLDC5x0ceCk7Vbjyp1TX6bJqsIr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfXwkly1bJUb2tj
 pLZkUWa+8UMqzMmhlyiDHvqnW5k//UIwSwnGYkeJVOSI+OQ9KUSY/b7A4LQOJfmqdjR2hJ+/iHw
 sjZEhjmUxajybASYdGRJazxYv+QG+9Vnhv1oNhamabeMoMKvLU/F2C1h4tgdy+3ZQXQhr2/v6xB
 vwTSQj+w+SiBe+HjYMpsGUWRVp6AOZJXH1pMSg69hQjBMdBnXNf9UJ59mACvt7P4m7AbJi0uVUS
 tImvlsytqVF3o3LZiPEXBq3audmaIdKn/8U/laAoScjyNfyhL1qj51i/Cd/qXcrOkwB6m1mqI7J
 Cj/AamO+0+hjZwB+P23LKsgKRHtHjre68A/IEEAVXxVCULyTNr/zzxFt3x52iOfaykiP7NAdhLm
 9zPeObXOzPikGu/OxN1XyOAdkWkw62dW9UXVxguepmhzbOFNVCLlIxVXaGc5PxeyH6b5RT0Ljll
 250/nvAduzCqiTP8K/w==
X-Proofpoint-GUID: yCHCwLLDC5x0ceCk7Vbjyp1TX6bJqsIr
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11878
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=10 adultscore=0 phishscore=0 lowpriorityscore=10
 impostorscore=10 suspectscore=0 malwarescore=0 priorityscore=1501
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608170147
X-Rspamd-Queue-Id: 42F19160005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: eftibxrs3mzb8k9zgua9zof64hiz4ar1
X-HE-Tag: 1786994138-383067
X-HE-Meta: U2FsdGVkX1/BAOBbZQlTg2VMkbDmbv/Dax9Km2bBlO4eRXGvqsDTnbX4O49Akutlcleg6FquAGYQUq1mtkKAyiN8MX9h5FmUbiGwu+A5e0R3xa6u3f/GGvXfpt8BGfsDIL5zDXYKTD0bK83GaapbTn6aQbgWr9a6o5RA5ODQ1MlbL/mE9an6sE67zPEholecj8FsGo7NFo6qOxAUczv8gNpbbi9LwQkmltDVZQKSwNn/JjmLomuzHfOvCVmhSSu2z157jhIYVd+RkfaQRrvbyUeW5JXzruknzJ8VYAgQSrdL4dUdPMcipZYzxMZ6fKyPU7pA5wVNawNF4e10M1FaafCMnN6PGc35dzD89GM0AEncAsNcgy8jcktNQjHUH4SpqpNa2ZlhurjHjpg/EBM/eYCJT0hNy7dbC7lvdppeWKbXZIG01ScrKrIGU6xKq8cLHDbIBdNofVomN6Ej1kBoiEpCuZwMoT7wT0w5qwtpuLLfmFaq95RheBdImpvYzDklf7ZzENzy7XWobrNS8lPCTopqt5LRc2XlajAi96BuwjjN2l7MYtORpuQsW4+iKq42hiSgqWN057JUnBItkPI6Udypdvu/nEkR2Y0UFScE7wUQJfKa3EFcLFbTQzap54XAwWQgXaAVTNJJgtqMKM+fBheHaqMU/2VpHPf83KS6jcHrHN2GI/x8tFxY2zwe5qTOBqP1ytktG/RdvnSTyE07gVSiV6676/2dILhozFnGCteLi4yk5a+nD6vQk6fvptnQA6FheQCSQBcFBZklIoLwfJYLusshjJixMuRZutPInAjojpKu54weJkCvbDkBqS5h/hsjykM2T2uLVpqFWuJLiMxN2GZ4bWDGkZUN9lsz1bB5Zuoe05cedPZ3BasyTpL5YkeMPXZ4fqSqIBnMKOuNxZsydwhw7G0wgRUG/EX+qUi3hrztktTL3J9IYkiKCzlsVYqmaeUUgXXbULO1xZW
 F6s6vGf7
 n4c3mCXYm4dWMtWjAMQ5t4qeluZdxAHUYxBfP0sFG7suivgyipVvYJSYAv/G6t8p5E3eQ9HH9TEDqAeakGpVrVT+PAWQFiiI413dpXz5XxtZMquHKKxr1zNu9g+AkbSCji1Zk+9p+xQCBwkW3YzEDlH0OUaT6zPSheciy1gjAymEjwfmfuWtZl4TCM+r0UT2UjURMoAA/QwgMI6IklG5/bwp511YdXmSjMP0t+h+w/SPMNfoWktbR+V3GUU6HQ9UOA/2PkSTjmslBKYLZbiBzoWbcrTsiYyuDciOzGH/MMJSSXKjqFILa7Yw9iMOb97YrQKs+Nz7rP44/ljYWG+i/fuyEnXKhLur52LHGmPllFKyXp2wbbhngufe/K504rYadf/iIR63I2xwpyhqKZMfWFzkmh1v/wOd1Hi3sfP68l545qvJ0bjX+SjEB9NzGgRbtwOdPZvzQIM2hd1P4n3lPzbWR0VDh/S5Y+j6kvQQYfo7Nw/iId52CSujXsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the request assembly loop and error path in ceph_submit_write()
to folios. This drops ceph's uses of the set_page_writeback(),
redirty_page_for_writepage(), and unlock_page() compatibility wrappers
in the writeback submission path.

Add ceph_folio_start_fscache(), a folio counterpart of
ceph_set_page_fscache(). The remaining caller of the latter in
write_folio_nounlock() will be converted separately.

In total, this removes eight calls to compound_head() hidden in the
page-based APIs and one explicit page_folio() call in
ceph_undo_wrbuffer_claim()'s caller, while adding four explicit
page_folio() calls.

Note that get_writepages_data_length() must still be passed the
possibly-bounce folio, not the unwrapped pagecache folio, as it checks
fscrypt_is_bounce_folio() to round encrypted lengths up to the fscrypt
block size.

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index a34849374f65..2d89d3d51bf1 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -553,6 +553,11 @@ const struct netfs_request_ops ceph_netfs_ops = {
 };
 
 #ifdef CONFIG_CEPH_FSCACHE
+static void ceph_folio_start_fscache(struct folio *folio)
+{
+	folio_start_private_2(folio); /* [DEPRECATED] */
+}
+
 static void ceph_set_page_fscache(struct page *page)
 {
 	folio_start_private_2(page_folio(page)); /* [DEPRECATED] */
@@ -580,6 +585,10 @@ static void ceph_fscache_write_to_cache(struct inode *inode, u64 off, u64 len, b
 			       ceph_fscache_write_terminated, inode, true, caching);
 }
 #else
+static inline void ceph_folio_start_fscache(struct folio *folio)
+{
+}
+
 static inline void ceph_set_page_fscache(struct page *page)
 {
 }
@@ -1458,14 +1467,14 @@ int ceph_submit_write(struct address_space *mapping,
 	struct ceph_client *cl = fsc->client;
 	struct ceph_vino vino = ceph_vino(inode);
 	struct ceph_osd_request *req = NULL;
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	bool caching = ceph_is_cache_enabled(inode);
 	u64 offset;
 	u64 len;
 	unsigned i;
 
 new_request:
-	offset = ceph_fscrypt_page_offset(ceph_wbc->pages[0]);
+	offset = ceph_fscrypt_folio_offset(page_folio(ceph_wbc->pages[0]));
 	len = ceph_wbc->wsize;
 
 	req = ceph_osdc_new_request(&fsc->client->osdc,
@@ -1489,22 +1498,22 @@ int ceph_submit_write(struct address_space *mapping,
 		BUG_ON(IS_ERR(req));
 	}
 
-	page = ceph_wbc->pages[ceph_wbc->locked_pages - 1];
-	BUG_ON(len < ceph_fscrypt_page_offset(page) + thp_size(page) - offset);
+	folio = page_folio(ceph_wbc->pages[ceph_wbc->locked_pages - 1]);
+	BUG_ON(len < ceph_fscrypt_folio_offset(folio) + folio_size(folio) - offset);
 
 	if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
 		for (i = 0; i < ceph_wbc->locked_pages; i++) {
 			fscrypt_finalize_bounce_page(&ceph_wbc->pages[i]);
-			page = ceph_wbc->pages[i];
+			folio = page_folio(ceph_wbc->pages[i]);
 
 			if (atomic_long_dec_return(&fsc->writeback_count) <
 			    CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
 				fsc->write_congested = false;
 
-			ceph_undo_wrbuffer_claim(inode, page_folio(page));
-			redirty_page_for_writepage(wbc, page);
-			unlock_page(page);
-			put_page(page);
+			ceph_undo_wrbuffer_claim(inode, folio);
+			folio_redirty_for_writepage(wbc, folio);
+			folio_unlock(folio);
+			folio_put(folio);
 		}
 
 		if (ceph_wbc->from_pool) {
@@ -1530,8 +1539,8 @@ int ceph_submit_write(struct address_space *mapping,
 	for (i = 0; i < ceph_wbc->locked_pages; i++) {
 		u64 cur_offset;
 
-		page = ceph_fscrypt_pagecache_page(ceph_wbc->pages[i]);
-		cur_offset = page_offset(page);
+		folio = ceph_fscrypt_pagecache_folio(page_folio(ceph_wbc->pages[i]));
+		cur_offset = folio_pos(folio);
 
 		/*
 		 * Discontinuity in page range? Ceph can handle that by just passing
@@ -1564,12 +1573,12 @@ int ceph_submit_write(struct address_space *mapping,
 			ceph_wbc->op_idx++;
 		}
 
-		set_page_writeback(page);
+		folio_start_writeback(folio);
 
 		if (caching)
-			ceph_set_page_fscache(page);
+			ceph_folio_start_fscache(folio);
 
-		len += thp_size(page);
+		len += folio_size(folio);
 	}
 
 	ceph_fscache_write_to_cache(inode, offset, len, caching);
@@ -1580,7 +1589,7 @@ int ceph_submit_write(struct address_space *mapping,
 		/* writepages_finish() clears writeback pages
 		 * according to the data length, so make sure
 		 * data length covers all locked pages */
-		u64 min_len = len + 1 - thp_size(page);
+		u64 min_len = len + 1 - folio_size(folio);
 		len = get_writepages_data_length(inode,
 						 page_folio(ceph_wbc->pages[i - 1]),
 						 offset);

-- 
2.39.5


