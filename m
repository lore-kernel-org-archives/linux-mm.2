Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9590E606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=k1WbxU0l;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=DtX+D3/G
Received: by kanga.kvack.org (Postfix)
	id 5B4FB6B05B1; Mon, 16 Nov 2026 17:48:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 565736B05B4; Mon, 16 Nov 2026 17:48:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409356B05B5; Mon, 16 Nov 2026 17:48:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF1526B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:48:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C22AA0262
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:48:54 +0000 (UTC)
X-FDA: 85442473788.17.C16A369
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id BA7A540007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:48:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=k1WbxU0l;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="DtX+D3/G";
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794869332;
	b=VdbMF6lIMW6nvdP8g+1xKj3GM3baqwmOC/JHrX1iNFDZsnn3Qlnbp+om7DGo62RqpJmmOo
	FzTw+RPH7UXWoZgx4x+ZCZVVjZrRrS8zTU1QMO8hKIHR1AUiwu3xF5gn3eIXQC1pjIES+C
	4vRdUvQcaJw2k6lblz3BTDEdNAuyeDo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=k1WbxU0l;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="DtX+D3/G";
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794869331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60pDhYqz+P/R0qO3ME/ENMTcAYUA1szCxs7zb9TkRHQ=;
	b=GlowmJ+2941P1a0SUlHqjnVm30l49WWIc6HDoiHKYRAhNULcujXePHqTffTQuSyn8C1C48
	BOLux0GPGkLZ6+1ftVe7FWktjaqy62p6qA6Bx3G1HgKfb80NALZpC3lH1551F2GUrK6XLr
	Yi33zjK2ttAdnKabYfemiRt3EzIkH6M=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGLYuWs1763929
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:48:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=60pD
	hYqz+P/R0qO3ME/ENMTcAYUA1szCxs7zb9TkRHQ=; b=k1WbxU0lT18UNmrfrowr
	y8lYOCZNHg2XrgLX4thXOcJ3RlUAb8SxGwHDhC8PUYAt217320UMYud3I5p4Srfm
	6QU4bFrowB3M0GGpHY1i5fHPKf0r/2A/9nafA3zaQt4eIk332NNa8mXs7Bbdw50x
	GZfTUn8r8CbEoyvCeZsHbO1sHQ1MFAUp2W75qr4SM59U+9IXrFDIarJ25YOFlOs5
	KSCyZBiQBywR8GQ/XJWEMnvcwGuVYsylasbbZEMQF23euFbKRbjtpOxTwhgLeF+L
	abnUcCxQdOEPOXg7VbMNASQC3fjzwuBCdtIrhjHTxJ/l9hgbTjBWUHePsKCTXmaF
	AA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j059hkdvp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:48:49 -0500 (EST)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-94960131befso479131185a.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794869329; x=1795474129; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=60pDhYqz+P/R0qO3ME/ENMTcAYUA1szCxs7zb9TkRHQ=;
        b=DtX+D3/GFNBr1k5qefjYNayYXNryZj12y+erBQZaJNhPGsaXMj3Qut0k5EHWb764hM
         MRghPV+x+zUFtJbYXsS26r8fl8aCkNGeonDDGApaxPjdvLEHGjGlt5Lx+8WCIoUOfTLE
         w8Iz9KccH88CDCBE4/+ox3IVaqHvcUv9fxdyFTj906IssAfImp4sPXRPX1niwt3OdLW1
         NwSYEA9AlNJxburOlIuFuibhf2sYHtOzGg/BrnQlckyfy0yCpWsqq26jqBF5wxgIP3Gc
         CqmJpd1eWhSZ2fz/lYPSdm+vEzsEu5y7YXB/OivBeExxmGWqHddspDf8hJpC7H9oTSi9
         U3Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794869329; x=1795474129;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=60pDhYqz+P/R0qO3ME/ENMTcAYUA1szCxs7zb9TkRHQ=;
        b=V9Fr4jLU8smbxbb8o01JCNucprSoY9aXkW6DxxeCvNmOi1KWcTpPRy+f+z/teQqewH
         t581C+UhhNZqXcwPG3TsrB+bEpp8vNKtcH1+HKJphsMUDP+trT78AcG6ZssRv9py0Fgi
         /Z8dmwnESK4abzTqmBvjtrdMWKU6Bll/pgLUzSHyaFrpgaIjGxfu4RxERsoJBL7QWXO/
         W3ppVZghrlZsQ/b1w7UKf9D3viOP0Epv4BtqLQaadENtH2GJjhPYpyQQ0BI+R0NeZxrn
         mUtQQUNBHw5Q+Z2OFrWMXHQhiXCpgJZrWD5FgrphT/EjBNLSTLuJBN4+3fo5hCi5A10m
         Edmw==
X-Gm-Message-State: APuU4Z/V2PLPE4Qf5rh0EYNKZO3Tc0YOQLFZ9GFDaKGbvCjoE8JHCwpc
	cJ2VoogaQfbrNm8qvaysS/Yv5xeoJYG4WzU2Lmo9HGfeJloYwbtdJN34Fh3XFQOw6kdU3PKtCkt
	CoYmWN6qKjRZh9s77DAvDjhLX19BAtBLO1ZlFD8W2qIH7GxF9
X-Gm-Gg: AYBFou0lUxDlrHnkXAnZ8QL0ysRG92ZH48z15dIaqxR3xKShOzTJtSZQTUWLTBQtgOQ
	xefh/fhzwFKvVtzJyCxP9tIRDlkZRAk2Qmo4Z4VYnDT+jBpnlgG+cC5TmE9lCs+OMascCIZ9Ip2
	FBKueHtHs59K8ifj8JLnsPqRsTOPuIk3aWe05LE94WIOX9qinItFYq8lO+fOy4RusuGTcY4y+Hb
	du1ud67PR7qHVoJZXjyrVuxnOFne0n9+slxR9V6hmiGTpQkPK1d1+twGZsrWd5nCkzrAr9xt9b9
	Ea2iu84iKWrPSGB5FiEnv3TSiORPf8KfIps51ZMAiQf77aXLZfTzH75Mlht3f0okPGsvwEhfj7m
	4dCmmauVsob/0n4afnvs4z5X/57G99+iTKNsgr4jrgiwjEZZvoIP7zluSBs+PFtbgwIodx1AcU6
	CTnDD0+dVWRoiAA+ryYBjR3mRs
X-Received: by 2002:a05:620a:2b89:b0:949:7781:6a31 with SMTP id af79cd13be357-94977816f98mr830657285a.76.1794869328823;
        Mon, 16 Nov 2026 14:48:48 -0800 (PST)
X-Received: by 2002:a05:620a:2b89:b0:949:7781:6a31 with SMTP id af79cd13be357-94977816f98mr830652185a.76.1794869328428;
        Mon, 16 Nov 2026 14:48:48 -0800 (PST)
Received: from [10.207.2.125] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c804f9esm954860185a.11.2026.11.16.14.48.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:48:48 -0800 (PST)
Message-ID: <cc8daec0-c3e5-45be-9af0-d58719a43953@columbia.edu>
Date: Mon, 16 Nov 2026 17:48:46 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/9] fs/proc/task_mmu: write-protect device-private
 THPs in PAGEMAP_SCAN
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang
 <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-5-4397a0196479@columbia.edu>
 <38750bd8-6bb3-40f9-901c-44cef40a9de7@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <38750bd8-6bb3-40f9-901c-44cef40a9de7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: sO6aBwh4ahu_UZ1HO01Hp1xoocb9LgUY
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA5MCBTYWx0ZWRfXzq8FiE8KJnwL
 Fs1nMEKtubbPS9OyR3p3Oj9socHcfRQNw/ShSUgzjugR2+EC/scQFe68i0gGSo5Oyo4m+kgjqGn
 3HBNhIqLxbs8KiuI67QTqA+ucoTQL1GqFBx3rd+TWkHMT497ZNj3
X-Proofpoint-GUID: sO6aBwh4ahu_UZ1HO01Hp1xoocb9LgUY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA5MCBTYWx0ZWRfXx4LBaRKDPnGt
 M5EwqTtEqcGU9y/X/baG7J4Gh2D1G2pUROP+xnDvaGoEx870LIgTmMQec+w24f6O6t2fzAwrHBR
 CKjWu6z9zeR20jNw08gf/0J4PG0o5djXlZyN5l82Y6Fei1wqNJqPFitiAizQGVagXeDZIFBtSX7
 0B+BS2jdhec+a4e7vPOK15UQLAjxi3FDLr6B0fi8tPQSwr51ipmlfbddpihHGBOH/SBxuCbbYPp
 DT7+iTJskxizQd9J3krwlFJUKSoTrNB6doIX9LxUZjRPVP0EWRKsbvY6jKTcnRFYMW/4RUww7bn
 axXmpqL50qB3ONPFktoeDj9hs+UCcg1INSaRlzx+OM7+P9aLXoElFq3HOybPDzjceQxeo1A/t7O
 YKkozLP4AabfjowaN7Pyc4vAXPVYZ/XknVvq86Hscm1o6MNHs/lu56w1ou4pKxn1+FcSwxUorqc
 QTZ5X8h32QkGnC3UiTw==
X-Authority-Analysis: v=2.4 cv=NLlAaE6g c=1 sm=1 tr=0 ts=6afb8851 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=tHa68p0SAAAA:8 a=qGNAzR1j6OtaQhhBgNgA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 impostorscore=10 clxscore=1015 spamscore=0
 suspectscore=0 bulkscore=10 lowpriorityscore=10 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160090
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA7A540007
X-Stat-Signature: sdbmeqjdfrfytqt19zhbpuxkzw1m4e3y
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794869331-531786
X-HE-Meta: U2FsdGVkX18wx43FRGq9nTLCTmznih1lDuA4mmBycxhgygeWIBK3kLhqWEw7lrCytnsrZbldaYPg9nUUk1+lwzvZqmnenJUrqmwXsWjhhdVFfOKG6Lak1ZvXGAdiLzQMiKRl+zbTqucTodXIKPuwd0roVZ+T8VBAo3FIb+JuKa/IvjE1wgKxquXRLugGuTSdx3qXB5HiIsRQRzHCmtRw5r+AnJSchvpJqn+dkyI94o/lGX28IfUg1ypK19+GNgztYkEBxPeb4B3EPbiTJShZ97WzWkgnGUSMWx2rJjM5YebWR9xJn/OewwlhIzMPTwuWmNm9E762RBag6KEn8uINxIXj4d8AZ1lNoRsAVN1FEwf/lGXG36fLzfCIIv6ZKGIUazS6m3SXfoTS+AGoC3/EQ+Cjh7UdfUv5/lDEhELMWo9MtC6AzjNkXA587ktSya8p0Zkz4vslpLMYBgw36UB8YYdFZlZeIBhWHHXevVcavmwuJwo5LD9dheBsi6X0XSjJ0H6Rqjs7B2mxb6SyT06S/TA2EsrgJClkjydGu2W9Hmurl5O4iEv2vL8550sC8f5KH/iZlQKsAeKEAPaQpcnbdzJ01rjppMnuwffWwXIz99GVjMmZmzSoNZEc16C/Rnzwg2xlgFp2LvabuVhg74wPAV+aXamZN6vpCfflpeTU66OlxQgdKzRla3WDjQOoRmukleyXcwss6Zqb8q2ly9PXk9yMaUfq4VDTOKrQ+L76Dgxa3Q2NoQOphx1/OSa8F1MZWb2/j3W72oRXdj4ZN9PPD/cJmjrPs81WJBSjOObFBPpVFVDuyEbjZUdUk/ZX0KA0NtOYxN4OTDrcsW2KCUEZxo8RVoF/AVehe3CYrN9/x3YhTJkn8r05gDHj2Ku6qmydO+mO+cR9rO9R2QXP0PKQFs7OT9qjjxmLX+dGSvIjBpW1INFE7tMtsqM/AYh2RpLPRbA3i5b9efSCc49VKBf
 juSEgSXB
 KpSHXNNWlFtFJ4ONGku4mYqv2sc8yO396nYhlM01FLJ8PK/bapLjb5HhlO3HAjlJ8CGUn8D6RkttlRC0fSNf4C8tfYFbQbpDrqn1iGe9BBNy7wurP3fcDdvTmBnmjq4h0Ciqq3GnHNa/kEry5hOchDho2gnft6KMWU1aQpy+m/l300AxlZI6uj2ptTXxN4tDZh7pgT0tx/6bSwKpcBfRmEnN+vwTKoLiO+rLnMx/KsKq1Y2lL54L2XjNlNUFZipEtD/BMeicrg8BxwrkXaOh38B/lV/2aCQyw80bn7TITUrVMwMNh70u4+jJ0j3GwiPxHxIhKMsRbGG8xcbGHDqDZNQ0ZUQJ0n9skAEk52fDsotZti7lJeSSI2cIkFLW68T6EbVgsTa+16ued63ATRgVFpGUjujHl3D5ELM4k82/fvRwsVsrfegaGAsfvj5eRpsrX39atKVw9q9+iD6Vcg690y+v3+YFCyWIiXMmvlI5a8ENn/1gixvknpQ4JehuPmv4ccx50Q9m75iq1ciIzyyb+qTvvLp3b2U+JPIVlLlznYTM5zfOqmzsvGDERskVAAly3Sg3/512QsRSNY8fy90LaJEW+HH31UFC/xePv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 3:26 PM, David Hildenbrand (Arm) wrote:
> On 11/16/26 21:02, Tal Zussman wrote:
>> PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects a huge PMD through
>> make_uffd_wp_pmd(), which handles a present THP and a migration entry
>> but does nothing for a device-private THP. The PMD never gets the uffd
>> bit.
>> 
>> pagemap_thp_category() reports a non-present PMD without the uffd bit as
>> written. A user tracking writes with async uffd-wp therefore sees every
>> page of a device-private THP as written on every scan, whether it was
>> written to or not. This requires a driver that migrates THPs to device
>> memory.
>> 
>> A device-private PMD must be write-protected like any other huge PMD. To
>> fix it, pass any valid PMD softleaf entry to set_uffd_wp_softleaf_pmd(),
>> not only a migration entry. It downgrades a writable entry and sets the
>> uffd bit. When the THP migrates back, set_pmd_migration_entry() carries
>> the uffd bit over to the migration entry, so the write protection is
>> kept.
>> 
>> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
>> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> ---
>>  fs/proc/task_mmu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>> index ee7f509d376e..013eeea7d1a3 100644
>> --- a/fs/proc/task_mmu.c
>> +++ b/fs/proc/task_mmu.c
>> @@ -2520,7 +2520,7 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
>>  		old = pmdp_invalidate_ad(vma, addr, pmdp);
>>  		pmd = pmd_mkuffd(old);
>>  		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
>> -	} else if (pmd_is_migration_entry(pmd)) {
>> +	} else if (pmd_is_valid_softleaf(pmd)) {
>>  		pmd = set_uffd_wp_softleaf_pmd(pmd);
>>  		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
>>  	}
>> 
> 
> This really should be squashed int #3 I think. Or what's the reason for keeping
> this separate?
> 

I viewed them as separate bugs with different Fixes: targets, one from v6.7 and
one from v6.19, so it seemed reasonable to keep them separate. But patch 3 handles
device private entries already anyways, so I can squash this in.

