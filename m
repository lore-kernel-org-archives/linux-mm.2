Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2B68606A335
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=lucVsY7h;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=qWMn/rD9
Received: by kanga.kvack.org (Postfix)
	id D2E146B00EF; Thu, 12 Nov 2026 11:00:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D065B6B05B0; Thu, 12 Nov 2026 11:00:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF52B6B05B4; Thu, 12 Nov 2026 11:00:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D4196B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:00:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0AFD31C3E46
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:00:48 +0000 (UTC)
X-FDA: 85426930176.08.3E2757E
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 12E0F40010
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:00:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lucVsY7h;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="qWMn/rD9";
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794499245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLZ9NGqxukiZbjtfJg87qreFf42dg3znk3WBgpaqgLU=;
	b=eIaob1G92pl5GrDFQEY9PdvmJbe6rRRsGLgpsF8WEkCmrz0wMePrg4m84oBTY5MMoe60Tn
	TYW+hY2qHxVKA71Q7Ca4tjwsOink+tJxqhe78CKpQ7DpAxSOVzSDHg5TgakJoJgZXlfX1j
	xn5z7FBo+gd9R+Q0KjGKOmdCfXJOa1M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lucVsY7h;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="qWMn/rD9";
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794499245;
	b=JWIp+JcnIGaek1dx7nO5M4CCC3bn/mUxR7RjgE0xRBwM0ERUWgcORwTOoIrpPgspZM06u3
	CFvkwyouUMYTIn6q1L4rrEUm1xytMApO2a0U0SOykANBcEwstePkKZZICA5pn2k9w9y4mL
	bO5igfbiDnSmTAAWNadxF8rjKRwSvB0=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACFY0GJ3359163
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:00:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=cLZ9
	NGqxukiZbjtfJg87qreFf42dg3znk3WBgpaqgLU=; b=lucVsY7hsgWdz5JKvxiU
	PZzoe5xEJzhjzFPMM5mG6/o90SpVCVEphIQt8OU/DxoSZ2bXw0hwY1mG9qiotHoN
	VBzPqEyHg393aZJLDQ1muW02DcA9KBO3k2wUF/aIgSn58tYi6EqtKMq0JFxg518d
	VmC8/YJeo6Lfu/UuLt6njpmwsj6PCZJ7+5BTgC7LhvLQyvm7TkNdAQbd4VYqrzME
	rJdng5QnZ5vI1hZmKKVu8fneOnHcR6t2rY3703hfHIJycf67cdMn81REfnaByAmG
	fOPxuIp8sEpEa9/koFSZPUuoPi5ZTK1mRowmSPNmabKDHnjqWRvybzimrYXAqo0P
	Qw==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hwfv00h39-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:00:43 -0500 (EST)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-536720195ebso88683921cf.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794499243; x=1795104043; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cLZ9NGqxukiZbjtfJg87qreFf42dg3znk3WBgpaqgLU=;
        b=qWMn/rD9j5+8WwgUj3L3MQQblK83NH8rfRMHXK+WLv/vWUgeqtB6rXMlqywal4pxaf
         aOeiPxvuZxh9/Y7NvG4hQ3Kh24qHc5U/J6tfvVZr1M4330oCK+WdKg1H/XZus5VWy7Fh
         6WvPY9W89AOc0SPYq9zaJ8acid3EUNdrXixiFlQnX5VB4uBs8NeyVliFQeDs+5i6f23+
         l2EUCGkdgGq0p3nC44AqxizgW08odWCVn5AGbfhMlHQkbRdNQkAUbPbQp3suGOTRsPVQ
         dySNFB7Rvj9jzH/PsRN4Kwo+K5+XHIRrVxKqyXiOSqAYd8r/+3DJcvlrKsZ3+sS/hLDJ
         LqLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794499243; x=1795104043;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cLZ9NGqxukiZbjtfJg87qreFf42dg3znk3WBgpaqgLU=;
        b=OJw45uUFVHZuCTSCbYF+wXYK7LXYN1CMK+nW1m5vp+u7hJF4I6FK5T9S8aK3hkx7n9
         RNniVtajjWnYlHopGpi15gfYInxhQPJlX4205Mrgs7KTGlJ+ob7PRQtOBIZLLUB5dFh0
         Eerl7tCu3LlfAaeePBNxF9i4sTnGFBwZUZ0kvAspd0laqas7idQktmQG0T83soO8+TXk
         F7E5w77X+rqhB7GfP1hPjw2ZeubTJ3FrD+CjeyWJIFebOCF5ov71TQXdoSM5rbhMbc25
         gED+ivUmZA57aOiYll9+FJBAsHJAFm01i2T0mj9wZj0Cax5PQBFxSlONEYM+Pcjj6fLr
         +8SQ==
X-Forwarded-Encrypted: i=1; AL+hErHYIgob78v6/Tb3to9tPxUr6xKZkBTylx/4ccwHLF3bBDHBBpxLvgMrdVIZCYW83WtAUZc6kiF1bg==@kvack.org
X-Gm-Message-State: APuU4Z//nhSpl2IgbJ4c1lwzV7PJGBmRjSHJ75kPtbTxcFgu5jxdVDWp
	wvrKD/f8JIcrP4KzONf5kRcKuP2wQYyGc7dK5K2Jt84E3eyN9X7nr82/S/28Lr5RPKz8P6kRPQE
	UUZtdz8cMYwpVj75WPzQEBf3arMTQ18fVhTtomKmy0AKRpx/j
X-Gm-Gg: AYBFou3CF2C0BytXYjYMtetTu7rwVT7KgDRg240lJo+6U771nCoJLgIie30w7wmC7L7
	5f/2vse0rvSABZ68OEvkxOHrUtVxdyxhe1xddYr2VCNffPfkXufbKUHqZUMYf8VxgMOuJeLRU9V
	L3nDR6v+NjT45mmh14ZPpGaX687b9Cf0vi+XzRHo/inET+c10v5xEQE6CvDRQwTKKjJZ1kTeyeb
	OzzhYkg6ytbmx0wFzNccx2U3eH30lgoZUfCxuYfpos6DSUITFSOSFGqk+4q/fGhM1CSxTO/Q00Y
	YvBmmrwtfBmP8sIddWrM6JITbrBdrt0x8p/V1oSdDGoG6fXXW62X6qzN458lSFsmb1gmlrnhc4s
	GLoTVv4NY2fhTe+UHiJHZgKKVSclvykyuApOsvb7SJ/5TROTmw/4paVybWxCejOy7+ooZaCkobE
	I6sOPgRnQBiz1VjMDgtIUQqQ==
X-Received: by 2002:ac8:5753:0:b0:536:5e83:589 with SMTP id d75a77b69052e-556c157d9a1mr97271161cf.71.1794499242811;
        Thu, 12 Nov 2026 08:00:42 -0800 (PST)
X-Received: by 2002:ac8:5753:0:b0:536:5e83:589 with SMTP id d75a77b69052e-556c157d9a1mr97268541cf.71.1794499241632;
        Thu, 12 Nov 2026 08:00:41 -0800 (PST)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef031a1e0sm74001026d6.2.2026.11.12.08.00.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 08:00:40 -0800 (PST)
Message-ID: <0fa7446c-e437-4d61-a185-07a9db23ee79@columbia.edu>
Date: Thu, 12 Nov 2026 11:00:39 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/12] mm/mremap: resolve uffd state when the context is
 dropped, not during the move
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
 <20261111-uffd-state-fixes-v1-7-00713d368976@columbia.edu>
 <avWmiBbDYmy8MKiu@gremlin>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <avWmiBbDYmy8MKiu@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=YfwodARf c=1 sm=1 tr=0 ts=6af5e2ab cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=VwQbUJbxAAAA:8 a=3l2Q2GrYxJSygdwfU5MA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA2MyBTYWx0ZWRfX8gs9kisTY1DM
 30BVYrpXlWKNEUc8crwh6wsURfiyVxjk6zMoOpLHvXONlyW9lMb6FYZ0k+FktDCQ9U09J7uRNPw
 /1LsZzgQ0q5lfeeBNutTgX6ixwm15RmbCUxsqS0dWUNOLmuPDnNy
X-Proofpoint-ORIG-GUID: 4a1QN-IFnRlxMGn-TxaeLhaZg0oInTyT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA2MyBTYWx0ZWRfX1z5kR+fv3ryV
 bgiIbD9FKpCcf+3CsBnOwlgC9/U5kYzX395t6qiEn+rtZB3eO0BcahH3u5Td63BP7SpwFQ8S4ld
 90oAhFRATw0W3jItPYTta6K1dEyQOzJO5vd7RzeTGtvd9c7cfzKqx8E/bOhmaacumtIM5tOu602
 dQlp3IIFpnRXvjYaNRBwYALEAc7RljPO6SU4KHHMWtF0hzXd6kxpOWb1f1y1rnbxKwulqbG2m71
 9IFLChXyvxDRQJsfesUURxetc4QUD6xOZRYsKoIvguOS3JC8po5dK3J2jeHfW4ibrEifFJb4TIM
 hMWsOj1oYscpCk6DPb3IAZtP5tBe/JesZDtrrfBPEv4PWPb6H4c6roAbXb94M90ZgN9K7cDTAr7
 mG1fRtaSC4ZQMCujS/NApdckHxD6TLLC2/cZ/wQfmif9bstN69+xdphmy3ib6mq0hWRKxcTMnHv
 o4dt+w6MF9PKYJm61WQ==
X-Proofpoint-GUID: 4a1QN-IFnRlxMGn-TxaeLhaZg0oInTyT
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11964
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 phishscore=0 adultscore=0 bulkscore=10
 priorityscore=1501 impostorscore=10 spamscore=0 lowpriorityscore=10
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611120063
X-Stat-Signature: m8bxfsagm81gc9bmrp4w6xxsf7qy6ca9
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 12E0F40010
X-HE-Tag: 1794499244-442086
X-HE-Meta: U2FsdGVkX18BXpGz/MdWcBvQ+9PJK1f/XKtzF+YY8tUiNTbww7uDTuuvOjzkV6Wyy94BOHH+/wmO6QFikTxEvKFFKuiO04CUI8ZvbBxSSDj3dsw7iESNYDu1jLqo140ErHVmT+7LQ4xlsxOgDMraTi/ndrVR1NcFEU4DB/S7NGdNKLPf6btmyqD626kQPXrBLKlSnF0rALboVV6MFGKLs7+d+7sOt104bMTUlxUw3qI8n5PzbYonGCyvoelCdoxweb6jBYY9QY4H5ZU53XQ4d2X2rQgNGbbgTGBFocx8jhfXWyeJ8/TaG7hJlb+P33NE/7gzwS9GjlIv+oYkRabkD1det9zGYcEOHszT2nIuN38XT8cOHc/VmoLP0SVfmsjvCPJri2GepGgnsuiczgKruFLZksBVd9VmJgv0Hi94EBZrDKBnClu5Liz1l+i05j8ijSZVAius3DvpE8lwdceX23h/RWxw5xnMPsSe60wHZ/l2xei+0uZqXiQhfckejp6vEhQ37U4j6fNxXt1DMXnME57r3edmAJEizAQRO1gKh7g0NjPRQYPV3CEAHnlPKzQiO8RaIXUy+aPzdGaybweiT9AOkfUNczZWUlzgg2RzG69Zjmm13FVniFh5ExeuDWpULUnRYlrqqUSTfNDEuNIvhymWfS/C5MsSo8EvFXm1le794hyybSBGPnpdrsj5Emu3nPJV0AYYwRT9CR1+T2xgK1lNs6zZbvMNPgE+ilbp/SgqGx72CA36su984S3w/TSC8z124MImhxo7zuWWj+5+U8z8fHDWiO8l9lHFvmGp/nDmuccr2w3V4lWcz9v48d5U3ijyN5iX9LwiHZz/8p7hsU+82VP50acfqHD7aNPEYOZgt4qAipds9ukzdXNWX2FeHHIZoMSXnqTIoyb3ByEgVooZ/ykE0aW+od1jCuDMBDVr11wOcjZ+AEtWN6Bc2BdN5rb087/9iJSPzsfcz1f
 jY+6lQfV
 8kRZcsBdJ7gEotiTtNb7FL3KHMm4kERq+puQd5XAzC3w/OzfyIzuGWlfph6WobUtkqpUtUEnpKMG4JWRTPclkKo2sRBuarYolbJXlxxbNxf+Ru3w6ie+yY+WFvSmNCUfhDNp8uz/2En6Yz0WwSCftvx2hF/2AVukH+swjzO2ecFquNum8AFxeFL1nGfRiIAelVTnP6Olna3Igemq6/9LcdXQ0pJ4GCG1n96wbXb4SmTPV4KML/ivYEjrfQ110dAzKXcD/vBdO6pXMCrxlguyev2xQUEJqR/VTIBPWkzgOum0+cwfqpPTeLhFDSQTYj/GSZ6PYIiUUip5u7ZTAMSpg8KVb1LtH3Xoo/G4IFUEMG+/Pbx9CNq8qP3Cr0QiYbOYwwyG/zv3EEMY7xZsJtgRk2INqLbFfZ/MR3wzzsHkigD92QsUAXWA4LvJFfJMTlT8hevtok3wJI3y00/PMC7MbjU3iDVqCNSItTuz6vR/ZwdrP+9tqLwf2NgmO+7SOlytRWwLr1wKflPjtBOM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 6:44 AM, Lorenzo Stoakes (ARM) wrote:
> On Wed, Nov 11, 2026 at 12:55:15PM -0500, Tal Zussman wrote:
>> Without UFFD_FEATURE_EVENT_REMAP, the new VMA of an mremap() is not
>> registered with userfaultfd: mremap_userfaultfd_prep() drops the context
>> from it once the move succeeded. The uffd-wp bits, uffd-wp markers, and
>> RWP PAGE_NONE entries in the new VMA must be cleared as well.
>>
>> However, move_ptes(), move_huge_pmd(), and move_huge_pte() clear them
>> from each entry while moving it, before we know whether the move will
>> succeed. If a page table allocation fails halfway through, mremap()
>> moves the entries back into the old VMA, which is still registered,
>> without their uffd state.
>>
>> Writes to a WP range are then no longer reported, and an RWP range
>> becomes accessible without a fault. Nothing restores the protection
>> afterwards. This requires a page table allocation to fail in the middle
>> of mremap(), so it is rare.
>>
>> The uffd state must only be cleared once the move can no longer fail. To
>> fix it, leave the entries alone during the move and clear the uffd state
>> of the new VMA in mremap_userfaultfd_prep(), right before dropping the
>> context, using userfaultfd_clear_ptes() like unregistering does. A
>> failed move then puts the entries back as they were.
>>
>> This adds a second walk over the page tables of the new VMA, for VMAs
>> registered for WP or RWP without UFFD_FEATURE_EVENT_REMAP.
>>
>> Like unregistering, userfaultfd_clear_ptes() also asks for the PTEs to
>> be made writable again where that is safe (MM_CP_TRY_CHANGE_WRITABLE).
>> The old code only cleared the uffd bit and left the PTE read-only. For
>> private anonymous memory this saves the minor fault on the first write
>> to each page that was protected.
>>
>> However, this adds spurious minor faults on shmem and hugetlb. When
>> resolving, change_protection() rewrites every present entry in the range
>> with vma->vm_page_prot, so a page that was writable and not protected is
>> made read-only, and its first write after mremap() faults.
>> UFFDIO_UNREGISTER and UFFDIO_WRITEPROTECT already behave this way and
>> lead to the same spurious faults. This needs to be fixed in
>> change_protection() and will be done in a separate change.
>>
>> The entries no longer need per-entry handling during the move, so drop
>> uffd_supports_page_table_move(). Where the old and new addresses are
>> suitably aligned, move_normal_pmd() and move_normal_pud() can move whole
>> page tables of these VMAs again.
>>
>> clear_uffd_wp_pmd() has no users left, so remove it.
> 
> This reads a little schloppy, I wonder if it coudl be cut down a bit?
> 

I'll trim it a little. I was trying to be precise about all the side
effects, and the spurious fault issue popped up along the way and it got
kind of long...

>>
>> Fixes: 0cef0bb836e3 ("mm: clear uffd-wp PTE/PMD state on mremap()")
>> Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> This LGTM and is secretly a cleanup which I love :) So:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

Thanks!

>> ---
>>  mm/huge_memory.c | 25 -------------------------
>>  mm/hugetlb.c     | 27 +--------------------------
>>  mm/mremap.c      | 46 +---------------------------------------------
>>  mm/userfaultfd.c |  1 +
>>  4 files changed, 3 insertions(+), 96 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 09176b290f76..468a49041b95 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2616,18 +2616,6 @@ static pmd_t move_soft_dirty_pmd(pmd_t pmd)
>>  	return pmd;
>>  }
>>
>> -static pmd_t clear_uffd_wp_pmd(pmd_t pmd)
>> -{
>> -	if (pmd_none(pmd))
>> -		return pmd;
>> -	if (pmd_present(pmd))
>> -		pmd = pmd_clear_uffd(pmd);
>> -	else
>> -		pmd = pmd_swp_clear_uffd(pmd);
>> -
>> -	return pmd;
>> -}
>> -
>>  bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
>>  		  unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd)
>>  {
>> @@ -2663,19 +2651,6 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
>>  			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
>>  		}
>>  		pmd = move_soft_dirty_pmd(pmd);
>> -		if (vma_has_uffd_without_event_remap(vma)) {
>> -			/*
>> -			 * See __copy_present_ptes(): normalise the RWP marker
>> -			 * so the destination starts accessible instead of
>> -			 * taking a numa-hinting fault on first access. Only the
>> -			 * marker (protnone + uffd) needs it; leave other present
>> -			 * PMDs in the VMA untouched.
>> -			 */
>> -			if (pmd_present(pmd) && userfaultfd_rwp(vma) &&
>> -			    pmd_uffd(pmd))
>> -				pmd = pmd_modify(pmd, vma->vm_page_prot);
>> -			pmd = clear_uffd_wp_pmd(pmd);
>> -		}
>>  		set_pmd_at(mm, new_addr, new_pmd, pmd);
>>  		if (force_flush)
>>  			flush_pmd_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index cb2de24affdc..97bd29925476 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -5168,7 +5168,6 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
>>  			  unsigned long new_addr, pte_t *src_pte, pte_t *dst_pte,
>>  			  unsigned long sz)
>>  {
>> -	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
>>  	struct hstate *h = hstate_vma(vma);
>>  	struct mm_struct *mm = vma->vm_mm;
>>  	spinlock_t *src_ptl, *dst_ptl;
>> @@ -5179,31 +5178,7 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
>>  	double_pt_lock(dst_ptl, src_ptl);
>>
>>  	pte = huge_ptep_get_and_clear(mm, old_addr, src_pte, sz);
>> -
>> -	if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte)) {
>> -		huge_pte_clear(mm, new_addr, dst_pte, sz);
>> -	} else {
>> -		if (need_clear_uffd_wp) {
>> -			if (pte_present(pte)) {
>> -				/*
>> -				 * See __copy_present_ptes(): normalise the RWP
>> -				 * marker so the destination starts accessible
>> -				 * instead of taking a numa-hinting fault on
>> -				 * first access. Only the marker (protnone + uffd)
>> -				 * needs it; leave other present PTEs untouched.
>> -				 */
>> -				if (userfaultfd_rwp(vma) && huge_pte_uffd(pte)) {
>> -					pte = huge_pte_modify(pte, vma->vm_page_prot);
>> -					pte = arch_make_huge_pte(pte, huge_page_shift(h),
>> -								 vma->vm_flags);
>> -				}
>> -				pte = huge_pte_clear_uffd(pte);
>> -			} else {
>> -				pte = pte_swp_clear_uffd(pte);
>> -			}
>> -		}
>> -		set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
>> -	}
>> +	set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
>>
>>  	double_pt_unlock(dst_ptl, src_ptl);
>>  }
>> diff --git a/mm/mremap.c b/mm/mremap.c
>> index fff0465f5e06..4564416a6994 100644
>> --- a/mm/mremap.c
>> +++ b/mm/mremap.c
>> @@ -198,7 +198,6 @@ static int move_ptes(struct pagetable_move_control *pmc,
>>  		unsigned long extent, pmd_t *old_pmd, pmd_t *new_pmd)
>>  {
>>  	struct vm_area_struct *vma = pmc->old;
>> -	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
>>  	struct mm_struct *mm = vma->vm_mm;
>>  	pte_t *old_ptep, *new_ptep;
>>  	pte_t old_pte, pte;
>> @@ -290,27 +289,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
>>  		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
>>  		pte = move_pte(pte, old_addr, new_addr);
>>  		pte = move_soft_dirty_pte(pte);
>> -
>> -		if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte))
>> -			pte_clear(mm, new_addr, new_ptep);
>> -		else {
>> -			if (need_clear_uffd_wp) {
>> -				if (pte_present(pte)) {
>> -					/*
>> -					 * See __copy_present_ptes(): normalise
>> -					 * RWP PTEs so the destination starts
>> -					 * accessible instead of taking a
>> -					 * numa-hinting fault on first access.
>> -					 */
>> -					if (userfaultfd_rwp(vma) && pte_uffd(pte))
>> -						pte = pte_modify(pte, vma->vm_page_prot);
>> -					pte = pte_clear_uffd(pte);
>> -				} else {
>> -					pte = pte_swp_clear_uffd(pte);
>> -				}
>> -			}
>> -			set_ptes(mm, new_addr, new_ptep, pte, nr_ptes);
>> -		}
>> +		set_ptes(mm, new_addr, new_ptep, pte, nr_ptes);
>>  	}
>>
>>  	lazy_mmu_mode_disable();
>> @@ -334,25 +313,6 @@ static inline bool arch_supports_page_table_move(void)
>>  }
>>  #endif
>>
>> -static inline bool uffd_supports_page_table_move(struct pagetable_move_control *pmc)
>> -{
>> -	/*
>> -	 * If we are moving a VMA that has uffd-wp registered but with
>> -	 * remap events disabled (new VMA will not be registered with uffd), we
>> -	 * need to ensure that the uffd-wp state is cleared from all pgtables.
>> -	 * This means recursing into lower page tables in move_page_tables().
>> -	 *
>> -	 * We might get called with VMAs reversed when recovering from a
>> -	 * failed page table move. In that case, the
>> -	 * "old"-but-actually-"originally new" VMA during recovery will not have
>> -	 * a uffd context. Recursing into lower page tables during the original
>> -	 * move but not during the recovery move will cause trouble, because we
>> -	 * run into already-existing page tables. So check both VMAs.
>> -	 */
>> -	return !vma_has_uffd_without_event_remap(pmc->old) &&
>> -	       !vma_has_uffd_without_event_remap(pmc->new);
>> -}
>> -
>>  #ifdef CONFIG_HAVE_MOVE_PMD
>>  static bool move_normal_pmd(struct pagetable_move_control *pmc,
>>  			pmd_t *old_pmd, pmd_t *new_pmd)
>> @@ -365,8 +325,6 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
>>
>>  	if (!arch_supports_page_table_move())
>>  		return false;
>> -	if (!uffd_supports_page_table_move(pmc))
>> -		return false;
>>  	/*
>>  	 * The destination pmd shouldn't be established, free_pgtables()
>>  	 * should have released it.
>> @@ -434,8 +392,6 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
>>
>>  	if (!arch_supports_page_table_move())
>>  		return false;
>> -	if (!uffd_supports_page_table_move(pmc))
>> -		return false;
>>  	/*
>>  	 * The destination pud shouldn't be established, free_pgtables()
>>  	 * should have released it.
>> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
>> index ad9d243dc64b..bf42fabb5afd 100644
>> --- a/mm/userfaultfd.c
>> +++ b/mm/userfaultfd.c
>> @@ -3161,6 +3161,7 @@ void mremap_userfaultfd_prep(struct vm_area_struct *vma,
>>  		up_write(&ctx->map_changing_lock);
>>  	} else {
>>  		/* Drop uffd context if remap feature not enabled */
>> +		userfaultfd_clear_ptes(vma, vma->vm_start, vma->vm_end);
>>  		userfaultfd_reset_ctx(vma);
>>  	}
>>  }
>>
>> --
>> 2.39.5
>>
> 
> --
> Cheers, Lorenzo
> 


