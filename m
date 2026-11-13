Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EA52606A338
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=F7rT//sb;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=m1OeUEVv
Received: by kanga.kvack.org (Postfix)
	id 6648D6B05C1; Fri, 13 Nov 2026 17:16:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD4B6B05C2; Fri, 13 Nov 2026 17:16:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477336B05C3; Fri, 13 Nov 2026 17:16:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D2F06B05C1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:16:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81A25802CA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:16:42 +0000 (UTC)
X-FDA: 85431506244.06.A9B3F5E
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id D0725C0009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:16:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="F7rT//sb";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=m1OeUEVv;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794608200;
	b=mtPQfB0r30RmWo3nBR/oc46WCYrQc02VE32gXKSJWhFVmqZmIihe5Y99nMBvMMzMQvY0go
	OaXAez1Pmmxl4GuKk+AaqIRc4mLKniMFDag4i11GszxeJuLNA/OOqH03Db9WzJr4/5TVnI
	7IapoQL2W8U7ZX6BkJvE+myb1udEz4A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="F7rT//sb";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=m1OeUEVv;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794608200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07ep7E3t/zTIZImeWja6Vo87wy8J7vuG0Sw0cdppt+o=;
	b=6E1LRRNPr3rk/pJtXoni4UGNMV2oHutvpfgwqjvEcceSuvP77Ou35meCoSV7CnXBuDvLux
	NiYP7S7XrVVP/9kMlrUqdxKn7UblGkkfTFb7dmJDCGTki2JcLWW/i9/mTzar6+6H9IwUrt
	vjwdfhZ6BaGUOhgq/lxPi4KJv7ecuFM=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ADLrwZl3418514
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:16:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=07ep
	7E3t/zTIZImeWja6Vo87wy8J7vuG0Sw0cdppt+o=; b=F7rT//sbLAORqUQMxmvB
	TBuGYuf+zUKrcS6K52tTE3r2XHyb0xxQwQhjqHHiIfZog4E9g7ZQl8gRVBLITHke
	AJuoWCYAKLFwmmsl6r2G0UOexNc5IMsTwMhQwRQpRYWnkouAgzBxOsMCRSgLJ0PH
	+I/o4OlJNXt264o2Y6Z+FE51htktnBsDGQ5JDmpgJvSbGzFj+7q0r9hVTl988kEd
	DdtigUo+10bJC85i/nXj3mPuKV6sGN1ORlboO4SZBhOFPb89FUGhIAnj9qTKcUua
	bYYCZccQFhTxhS058qTuLaKUTY46uh0yNXPSsw8/BGcjycKQjdLgJnxF+xNckdWx
	dA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hx8sj9emj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:16:38 -0500 (EST)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93cb7f9bb86so363789485a.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794608198; x=1795212998; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=07ep7E3t/zTIZImeWja6Vo87wy8J7vuG0Sw0cdppt+o=;
        b=m1OeUEVvOZpEm5DWCfA1YwfWPpvXhKNrZXDp7DL1gsaI8PBqjhtXJg9JDGOdhXUUZX
         pU7aBgc1VgTivhzS46ndZwSLeIlpbXaPmyIxAvZKD10CHtrtnBrVJqJcIt8zPoxpEw4D
         xU2vogtJLXueNi3aKxMC+QQQKARWyYuGSovhaOERQMtPmdjRTbwst6zPl0lHgBj94bav
         Ql/UPL71gsFxJhIfbaO4SyzA/tPBotmbQhZqpzQXQVb6sdZqqDEz1T/iJd4JtRIsnTE8
         NWnEZc8fNF/SlNonxp/6nOmt2m0fmdUP+IisOnx57Wvmvpkael0trZKjx1O6uGWBKssM
         CBUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794608198; x=1795212998;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=07ep7E3t/zTIZImeWja6Vo87wy8J7vuG0Sw0cdppt+o=;
        b=R74vVbWAdBZrk/XdGiwaQx5A6yGg7Fqd62y6ek/jid0lZmHpQYREjF6MKjw26H05u1
         HafsIN2Dr4lI0UFIGP68o+vHd8MKtS9ZYGjWC4nX43EzXUJygWv8WGY0vJCfJRyKhP6W
         FuRX5+QIXKyDiyV5r7wkeQT/ADBIgDUR71UFoYkEfxXF/BqAj+/kzMYutoQETPChshLK
         JzCxp0nklqu70RgTuXlKrXTPud6le1+LQaYcgJmlwuKOACoD7r34szBQgar0bKntvGca
         cxT94mdpkRUABarJ2mkOuZ1W1In8ANSrjXjLPVQhfEg03sECr0Bx0lz2F7dvU72DwRHo
         qfdw==
X-Forwarded-Encrypted: i=1; AL+hErGbpswg6lHZanX272TAaaDrcHpmoX6/x/ClN7EJh3ZTWxEnpo+ky4eyR9ZetKQLHQ++fumsVMMtKg==@kvack.org
X-Gm-Message-State: APuU4Z8/i+xetbA6DHDrToE51i7jg94shYY7pJ/Lfv6ZHKR6cnPxsFlF
	p7+EECq+Gl0jMv5WmkGN5HBqYyYNFpN+GBaCoZF1EhO6Gz/GPDoeyVuioYoSsV9kWHOYa5Z8Spg
	A7eb0hRCYOR/X+20EH7ezGFhUBXeiXnSTAnefMPSJfzAGMa3H
X-Gm-Gg: AYBFou2KTnq/BKzMmkg2FLxLjaVBovMvq8Gg82Wfzeh9kG+H7HJ/eeMoIC3spzJR2YU
	aB1kg8XbAhWxOlu0wdpDp6/bIzu4GcyJFTuDkdJk5EBSN5xOWJ9h6Ujui5EIQGTcad9XVA2UN5+
	FhWWrfPzGtoexHBTGO+6l8GfPocNLcdK5P8/fjKS5l+LZmEcUFE+fPX1RA1LmU0+hfSdtSTDj1u
	M4VDfy8ZOFW4pYZfSajFB0zJm5Q65ufJv48FsTNEr/Ot+Of0tyGlvRqWJ1JW0cp4ewXRPPpcuMn
	RzL+gSJycBrxO+zq0ojJHh4TctDTF5GtbXTUzI4aL7rhrWz1Ti0KpEVkz+gkpJWC78AjWLH1+/x
	IvIs9LqsA0tz2BVeK5Krl104Q2tLPrHSYupkXvLhljOZ1rOEVVY3TcjIdbfwOoEYFDFIT5+AX8+
	WWW0YdnCuwnfwPC81F0mUEvMyTUVk=
X-Received: by 2002:a05:620a:628f:b0:946:44bf:9169 with SMTP id af79cd13be357-9494ba7e00fmr662821485a.17.1794608198224;
        Fri, 13 Nov 2026 14:16:38 -0800 (PST)
X-Received: by 2002:a05:620a:628f:b0:946:44bf:9169 with SMTP id af79cd13be357-9494ba7e00fmr662808985a.17.1794608196819;
        Fri, 13 Nov 2026 14:16:36 -0800 (PST)
Received: from [10.207.116.169] (nat-128-59-178-153.net.columbia.edu. [128.59.178.153])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c836b60sm281564785a.17.2026.11.13.14.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 14:16:35 -0800 (PST)
Message-ID: <e4b60f0b-ccb4-4a7e-83e0-81fa1fd0c88d@columbia.edu>
Date: Fri, 13 Nov 2026 17:16:32 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/12] fs/proc/task_mmu: write-protect device-private THPs
 in PAGEMAP_SCAN
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport
 <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang
 <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>,
        Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-5-00713d368976@columbia.edu>
 <avYQteUm963AKJQ7@gremlin>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <avYQteUm963AKJQ7@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Y/JtIReN c=1 sm=1 tr=0 ts=6af78c46 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=Y+j3KQtDOE8TDC6EXH/Ajw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=jLqENXc96tZTD5fVGMQA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEzMDA4OCBTYWx0ZWRfX4LiV7rB22yoM
 aqJIFmOsW8hF/VATs4lXGC53E/9csStnW33WOgKu8J4HDZfRDjG/vBfvREq4ewCjG5e26Ghlfy3
 J5LeqnB1W62YN7/EImVCp5HHzcqywkAi9rerBNpJwb5CL0Y/FYm44+PYGeUu87PFqbCEmUCHNAi
 8HpSEKvo1ntxSDWetoS2m4yGZk4iVAf5VYz/e5mIef8DWS4RV+qD2tGi1Rl9BJ7uyhpNnYALYdu
 cEFm0OV+EiUuqjovRzySTY56HaYwd1C2+aSaYHQu7HMk0GBuL4R1Ha88+ODiZrvQzJg/R86uhGT
 dc8/DZ5kf/XS0I6rOU0z1g3HL35xzm1Bz7ILKT3N/eErLQ99vHC6s4b5GrEr20AA5obdRiazngx
 r+6NsC6b6rQ78iG+8GolYrpLCJnKOXWSWXrhLdyRJQxpzF/TlewDFCYG5wKPYC222Q8DQ48ELRb
 GWHBrzUJjNHONmMbdSw==
X-Proofpoint-GUID: ShccnN17F1E2IyZ2rLVU5BH5p9yXU5Cc
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEzMDA4OCBTYWx0ZWRfXyDQBJ7oCdAh3
 5echOCSDlTfOMhwaSiZ50kpNFKBESg0a5WCmIV07iKRvDHZWi60tohNx/46JLBgGKjLOO/+4LyU
 KtTIcwi/Xbq9gI/lSVXhxscr6oPAVAbaCAZFN8EJpz26XSV6Sig8
X-Proofpoint-ORIG-GUID: ShccnN17F1E2IyZ2rLVU5BH5p9yXU5Cc
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11965
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 impostorscore=10 malwarescore=0 spamscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611130088
X-Stat-Signature: rw1mun5zni16d4debw7ii5oq7n99bemb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D0725C0009
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794608199-70543
X-HE-Meta: U2FsdGVkX18upY1xlGj9XxT6V67FD8kEKlm1dzhxPh6LRi9hDIb0SoShjhXx+vCQMk48mqT4J0ALN+Jrw2P+NuIt2J5HkwUOcU1hdbJs896vA3xNBDrT/FXUmvCF/QGsalWyB1DZle/iKyoky/HVJA1LjbgYWuYnT3Up1zps5Ha7P4bfCK/dvH/qSXPCqypz//t15KtIdY/lzGUGzAG6BUDZzdvRsHqicxgh5A3OIf2tbJbsol0whOIP58aaboqWfLnG8ZR1ec1ogxJw9YAy9yIXSoGd9FMAl9gdPFDnGB3Jlg2EV+MnSXhIFz8GiFepO8mVWzFb5InHRW2FZ5rLsuCRMtU5yIpBYPsUYzUukBvlvQ4ErvWIMf7xhe1rqn+0mvVMQHyGOybxudenByYe1Q1UWG2GBQGgNKZctgNQMADr05VIPOFC5Vvbcjeyx++uw9dEUgAX+5MhSSm7zZ1ScCy8rLRbF/nYMdEakA28nEQgrCQVTFMgCuKgfdBDCLLwWQd/5lrCvXfGOcFTX+zHNisS8m8yeX2cSFZQ292ZMxIGVMbrrwVesEzsoCByDnfk4rL5hefhWqHZbl+PzwukGqeQ8Cj8pnMRdWFpSYGHlJZs2XQfPpzNFgLr68qFegGOpXbECYQvczKHgj4Dr3lVyteTi7+k5k1LZDuWhlbEuoxjz3G9t2/5CF1NEWRKYYvWzcop2sUp1WOrCrmk//Ow6vL3FSoPR4nl8ACyeDNvwLNGK80lUHgl2mr6p+5qUn3FOW4/fYjhTx2uzmQm2qpUQM0mL1QgHFWmHj14oFsl0yWBKnslE2ZNFHM1n5dq/b8lwjn7gmu8PDiHJb20x9o+fckNfhO7STHkodd2B/edWu8LRL+OQBnsQ1U+Vn9O/0x3z6Ytos9NQfhAuLKurSsMQ8DismrCuznD+PUu6noYBPY3Adbww0rem3QSXOy9fenvyKfsB9qBrsdXKyv8jHL
 pf84zSjr
 R5vfAolJeVlDWT7qICZmfXvMX9UwpHjvdwRH2YaMEbmb77IvrF7zvtBedjYtdiBOuIkmN9B7ZpzBzspH6MXdKOf34veq1tlB+BAwZw/XVU2d9T8E7VIk/dROtSknMJVMYNYdBnLyN8zEmdKSl7CeNbRg2MPKRlEv6hd0v6LOab1e4jBX/D3Uk7Hjd8IDBaOf9PP/kliRrcfCYRcsz8HEP3GHdqqDd4btr+PwDHCjSn5e9ZLsj1QbmZ4V/s/K2iuNLLIaM5JZo/0DseG5fN6b7PuDRD201L37yGJWmvkQJgM+1060/L2zOPsQBW+VpZfyQc4zt7r11LlgNsk2R9/mWqW4F1mEMZ11Kku0hCkQVA4zX29NCuZk11I1QeN5f6qecmUeQFUuvyR8ym+wkDjVGVJjl+hr+iHaPph/P7uy6QhmSkd9ud9hdRyq2R462Q502i5HxLJPRbNR4Ync0aInoKOp+eftxvVjJOR5dD7aMmKY86tgQyCxkSHGWrH5Alxipee1EBuxAm+D3w5ESuKnhpZh6lMsDe3ve3dZA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 2:34 PM, Lorenzo Stoakes (ARM) wrote:
> On Wed, Nov 11, 2026 at 12:55:13PM -0500, Tal Zussman wrote:
>> PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects a huge PMD through
>> make_uffd_wp_pmd(), which handles a present THP and a migration entry
> 
> It's crazy to me that we write-protect page tables through a procfs interface
> like this. But I guess we have to live with it now.
> 
> I suppose that answers my q about this on a previous commit...
> 
>> but does nothing for a device-private THP. The PMD never gets the uffd
>> bit.
> 
> Sigh yeah. Device-private feels like another 'just have to happen to know to
> update X million open-coded parts of the code'.
> 
> We really need to find a way to abstract this stuff.
> 
>>
>> pagemap_thp_category() reports a non-present PMD without the uffd bit as
>> written. A user tracking writes with async uffd-wp therefore sees every
>> page of a device-private THP as written on every scan, whether it was
>> written to or not. This requires a driver that migrates THPs to device
>> memory.
>>
>> A device-private PMD must be write-protected like any other huge PMD. To
>> fix it, pass it to set_uffd_wp_swp_pmd() as well, which downgrades a
>> writable entry and sets the uffd bit. When the THP migrates back,
>> set_pmd_migration_entry() carries the uffd bit over to the migration
>> entry, so the write protection is kept.
>>
>> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> ---
>>  fs/proc/task_mmu.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>> index 53780a454432..752f1b13d47a 100644
>> --- a/fs/proc/task_mmu.c
>> +++ b/fs/proc/task_mmu.c
>> @@ -2524,7 +2524,8 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
>>  		old = pmdp_invalidate_ad(vma, addr, pmdp);
>>  		pmd = pmd_mkuffd(old);
>>  		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
>> -	} else if (pmd_is_migration_entry(pmd)) {
>> +	} else if (pmd_is_migration_entry(pmd) ||
>> +		   pmd_is_device_private_entry(pmd)) {
> 
> Could this not just be !pmd_none() + cover all softleaf entries? Or is that not
> valid?
> 
> It seems completely insane to have to specifically spell out all the
> possibilities, open-coded, everywhere.
> 

So we actually have a helper for exactly this that I didn't notice before...
pmd_is_valid_softleaf() is equivalent. !pmd_none() should work but I think
the existing helper is better.

>>  		pmd = set_uffd_wp_swp_pmd(pmd);
>>  		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
>>  	}
>>
>> --
>> 2.39.5
>>
> 
> --
> Cheers, Lorenzo
> 


