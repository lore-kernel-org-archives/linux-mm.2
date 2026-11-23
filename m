Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E310D606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 06:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=aJErLLce;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=zZR0mSuA
Received: by kanga.kvack.org (Postfix)
	id 0B63F6B05B0; Mon, 23 Nov 2026 01:19:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066E56B05B1; Mon, 23 Nov 2026 01:19:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4ACB6B05B3; Mon, 23 Nov 2026 01:19:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B09C66B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:19:50 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5EA2C0652
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:19:48 +0000 (UTC)
X-FDA: 85465382856.06.185ACA5
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0C6F3100003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:19:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=aJErLLce;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=zZR0mSuA;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf05.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795414786;
	b=qBpSUyg72oyGCKtZT/U6/DaWOzJmsL3Y5sHT+P6TWlZX3RyXE3tAd9BO6EgCu8bL69pd6C
	MvpNMwVqEDKN0JiRglKASaJNukDUCYuqx+0KHIdjagj1mWdivN/TfiwKTzieQBhRLwZGSk
	2B8KUtDu+S1vVXG/kIJDOW+20ZIl04M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795414786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BF/0+ZUXITScNNxomDscQG5wnwCmvZaai5xQhO9sUeM=;
	b=DMpozvFV2WUxt9tby9pDrhUzpIwl+Z6QkQlcql6SbP6fkkS/gArh6VZAnvx10kyk5L522M
	QWgosr3XnOQo9shBoLE9Dhof8o3P+yvVTIYk0PHNuyiSLQu60PQdDxn038V5gUha1vrg+D
	2cOk2NjtGjMFRWY+FTMx6/O2IF+vYLU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=aJErLLce;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=zZR0mSuA;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf05.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AN6CqaY2762563
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:19:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=BF/0
	+ZUXITScNNxomDscQG5wnwCmvZaai5xQhO9sUeM=; b=aJErLLceONn0l2Dq54F8
	As1H9x/izFTp9OY57U5Faobi5tUkVGFaIiEJtK82FRCiYOLAr3g+rJ3/bb6KTriB
	kk1Wxv8CHIO3PWNtpJQ0ANxzXDaJPXZONLl7yBH+EE9lwHN91IwcRGTQQuZCk5Ni
	Ex6by1+1odkwG4CdEQpKg1sVk0z+dYMPxHFsdHMxBZBrO5RYl8duZVlfuBh6Uyd0
	E8edBG2cRGRi3laQXQdbtlOv6CKhgl3TKoTcbiLU791TjZoUkXugdK/8N/XTXhJM
	yIxZkpa4HUYNiBVb4zC7q+2hya++c5fbM8W+OHOlZpEBqeC4eKtUE9le/5N/WAU4
	AQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j3w5vvfph-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:19:44 -0500 (EST)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93f37c94ceeso692609785a.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795414783; x=1796019583; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BF/0+ZUXITScNNxomDscQG5wnwCmvZaai5xQhO9sUeM=;
        b=zZR0mSuAPhmxaltRG+kqQpyQOinVFObPIuoINfJQqzCwGQE/M0vdsSCKc1MYb7oxOQ
         7381th9uP/C0CUQmlhaWOu64Z3gKNkQMlZEcLiRhm+hsRlOoFvlzrnCO/KYaPtTQvnEC
         FobqQQylun/fMkj/AdkAXXRAHumXCqu5gU0qxXGa2s06gjR3mcwdDXex4A8SsR5FVZcG
         8iDStF0yMtFl1UeVGHP/el2pW5ns0e9OUH4Uc8tAvi7Ww/aXSEsZzz1gD54c8ufT44+Y
         2YYIc+1A7t6f2quXWkqH3NLJo3Xqa8UDxxitzptN0iWNmqYMeuE17773Lay2rxUbvcL6
         Jidg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795414783; x=1796019583;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BF/0+ZUXITScNNxomDscQG5wnwCmvZaai5xQhO9sUeM=;
        b=Cx7lXghpviFrXl3SJ6LjcBbJULjrfvsMGqxLs7nFZ1jQ7khQtO5I7uhfuPeHngjiaE
         q11hvoizpihv4eD/9rCnYRYDVfIdEmlgpfhrNxg+Y/4Oc9IHy+Ulu6aGDHI99UvM2Az9
         NO4GXXZVR2yhGu59k6rgnkj007GkSt5qmtGgm32fmPMfQL46kp/mgMCYIkiuEf7/rcDN
         pYvpi/89QEBG2TlhXkObxIqHRJ+N3wf4fn1zGgJJwJS3FpNTwzyb9u1MXlrCKJ4Ef7/g
         aoFq+j0zI5Y4dXjeDvM1ZxXhWknjRLt2XZ+WaoJHnnOI5xWzb3JTPCKl4cByysxlBfiD
         nOeA==
X-Forwarded-Encrypted: i=1; AL+hErH+KkASH5OKsegU65bUQTN2pgxqQw2kRpCZ6eOnGeMbFP/ubAbMfCkK3GdMiwP3RlYDHS6nLCb6KA==@kvack.org
X-Gm-Message-State: APuU4Z9oUDCTmtxLBSL2FqIxEpLAcMKHRWHfxY/ciLHkVU+YhmMJAtq3
	w4pWipO5cJTYUIMm7XW5EhL8f86snkjobGFX9EjHPKXigZxxP5LwLEzwJbkUjOBzwRlSEjDoNhP
	0wDoA1x0Py5vqY6WUdLuJyBsahNqzxr82/0b+tgJnFyBBWvhn
X-Gm-Gg: AZFdTZcL+p8Ly9un/kBPH7JYgRqlGRtzRWHw1CQbHPw96AzjqAkrUfdGm+bGtPUM732
	+9o3Ky6+OzAvOTNeAum2Tu8RKTq9B/3MtCTnu+QPKlMxdDSk7kXMr71xqubgV+7v6QHamXsEILn
	V22B3/3Wl5y4HPnFwWm58HUlLnFJyELkGMhHatHm6YQr20850AFSFS+Pir/e3uTJU1PdzIntHrv
	1bNhJJOXM9tUZqoP25w/dsXq62TFk0MT6Nqqu9FF6RK01dtQQsQUY7l2xCPaRx2xuAFxHhiRery
	hTjoyMREXOMyAYNyeK2QB+Q4s+KkOvhFCux1FlAYL1c2sqtYEYE6Q9n1BUR7Z139PXCTVXIBCNa
	vskp5JDGe6sUIB6Kp7Ewmv5CF0ANOAijt617vTuqCv2Qv13hMgy4Js8ddNbvhIUTsQfPS8sHvhK
	gslATAD23ZPqfTLs/TeTxXHclSt+7eLHe/iR5Sa8abEiOajrrSQauFiZSuQU+66BcjbNZ9RXOlS
	32+4E5cKF+TNCqZzWYV+KNGlJfkbiYu6nuf6lolmvjHkU83loMrcZ4khXb8TLrg+dRDUgVZYHas
	5dwOBA8Uncskumq16kMUQpM=
X-Received: by 2002:a05:620a:3c8d:b0:949:b99e:1d6f with SMTP id af79cd13be357-949b99e22ffmr1153850185a.0.1795414783569;
        Sun, 22 Nov 2026 22:19:43 -0800 (PST)
X-Received: by 2002:a05:620a:3c8d:b0:949:b99e:1d6f with SMTP id af79cd13be357-949b99e22ffmr1153848885a.0.1795414783255;
        Sun, 22 Nov 2026 22:19:43 -0800 (PST)
Received: from [192.168.0.76] (dyn-160-39-51-212.dyn.columbia.edu. [160.39.51.212])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb41c105sm746775285a.39.2026.11.22.22.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 22:19:42 -0800 (PST)
Message-ID: <08b18b88-3ab4-4681-bec8-f4564fe9f1dc@columbia.edu>
Date: Mon, 23 Nov 2026 01:19:42 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory-failure: set PG_hwpoison of a non-hugetlb
 page under hugetlb_lock
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@kernel.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tz2294@columbia.edu,
        stable@vger.kernel.org, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20261106-hwpoison-hugetlb-ro-v3-1-c11186963647@columbia.edu>
 <42a60f57-5323-f981-8ef3-2e5d67623902@huawei.com>
 <a87cbd92-0e07-4f84-9a6f-8db0b1778fcf@columbia.edu>
 <b0f30561-aabf-2bf5-2204-20907c40ef43@huawei.com>
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <b0f30561-aabf-2bf5-2204-20907c40ef43@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Q9ZHcI2a c=1 sm=1 tr=0 ts=6b03db00 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=l9izRfKDRJJ6Wn/vzKnQSA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=ZeqcaTA9yHy8FKGpf-oA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIzMDAyNCBTYWx0ZWRfXwnsUrqtOhpiH
 oNJQ8MPH9kNVvi9MQOxJ5gOQc4ObuG/Y8TiShLAz7LDvepQIqYRa8XNjNxDKl+DkzCXK7nt/EfM
 3BiFX0a6sQsYfRphuSX/0NYKcNJJQzt7hE09V68l1HFbyiYeD1n0
X-Proofpoint-GUID: zd-0VXgIDDPnxLftUigDOrjUZXAx7oD4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIzMDAyNCBTYWx0ZWRfX6PWafxDUSOjf
 YSpHHIbtec16rrFaeKmVeIy4sK5kWe0qirszfnt8a1VxVenSmKeWZSsZLoqUTe5kKczHBnvVpGP
 ptAT0UWescGO+vG/5XlDpSjpEzZwSAmwO2/XJBESz5Hqlq+QPrE1PBLh+kOmddbKHEuCypqxUzf
 wSqnXwlPV6MTsp+zC6S5AoyYb8fX+Sj8Nq8gAb+2e/VsXXi3653eAKrYtq1W3HEWICGZzxj9N5m
 56TjiSV+gM/bv5xFllb4ptkcAGSAd5qGXJu+dn2RiLgYF7Nyye5HdmnLgZvvrvk6VO2pkRgFkow
 UmiEEUEtCp+DYsWQBFLOAwwoDsas25PDqaWB3eWrXuVL683yQ9hp24zA1h2bRctdorcee2fGlLi
 tgLWKAikTvG7goimvQj0+Jf78rrYrayMuFEcFWXer7mEHL+x4+pUyTebAD8e0jgJxwgE5rUlJm8
 7VuuSoV0rsk0iXgRkQg==
X-Proofpoint-ORIG-GUID: zd-0VXgIDDPnxLftUigDOrjUZXAx7oD4
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11974
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=10 bulkscore=10 malwarescore=0
 clxscore=1015 phishscore=0 priorityscore=1501 spamscore=0 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611230024
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0C6F3100003
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: yi5tmoexrwtokfz5n1rxs55hmhxiej76
X-HE-Tag: 1795414785-973222
X-HE-Meta: U2FsdGVkX1/8TlSFPj/PpstS/09B2+Z/DhHbICqrKOFJZJhTmObU/SELtOpvjTabD877ad+2PR6/Urn7CAh8XexpWWhRcXqAe+3wVV0zKIm/jKA1aGlDoEsN4JRU4DfV4bDfZNXVuuXy/ksY27WzTOCyhUPj4Uv3kV0Qnv+DeTLcWBUHOJwmpENguz8C/HehFjKblskaTMlwwjZUOMM2Vj+4v1oOgYAbzb/6dH0ow/fhz59E6SnlmMyvcMs7VqprcX3ALx5YfJlmGxyT4Fsue7WFIgP4SmmG6sOPur03ffVuSu1ER3b6D70ZcwjcyPQQ/Xi49+lk6+eHZ/HBwl/5Pic3DcBIQ1jRfpiyRibka9YtZEtt4OgtnWeP/BnjTtmTGeYDZaI+q8k9Ot7y4sHwJRGIJl8P9Zh/Nxsu2e0J5nkvpXC9nfzvmhwFmaValOsLtfsXMZhU7bv4XGyc8J5fDTBFON/SVXsbyvGURL75ZlQPVaQFAv5a7x56eqpDsnp6mLBaIWCW5UEpe6/UK0M3a29gTHR74Vy/LLbkpsK9mcYKy0NwXaks73MILwWk3aGQseTCWf3B4jOP8WYN0dTCQ+v6Jlu1QOwygxgGjuqmyuwbryFpi/LzZz4f7kGvDyE0PkEJVw7Vm2iNPibIAmiqqbuNxeYoM+Z/o8g0fyqk4eSXIKH5DHSGmNxRCnFyrfw3w5l2XKwPo705fCVJ0CdEp6iUAIo2LSv/Gp4WgDZve7UEkuqEM9g4geYjXz3tSiDliRnK1g+UPciGwlBsnP7vrS3rrLaEgd2Xp1SFOgxsj8kLWwyIRkX2l5jJUcx1F5W75/kZ3uKyHv++1ru8peuS7kgsfrATqmjiZd1DTr9FFwxDD6CYlK6gKNPQ2X39RoRDWYLfaTCpvvQSnvDyIkibalfjYXDAZNybyNf188+sz4AX7nJnpIXmZHxkx0kjIeYJfdLzvbU4CwljIWQ3tNH
 2GDLwo46
 Y+/XrG+NdeM5hQFidoL8m6f0WzhC2Qfis2t/9t9egdQVNUGoxgUZ/FYskvdUC+qgkUZ/hAMDtzbOiX6BRoxA0iWRup847pwI/RPWPyIP0JDI3RAeEotxhW2ooE8RwHDCdEfLAkPIyfoQW/Z+ST9Zj1gbiFIMcW59JdyVpDtU26zdcqP7YhVU/z/njY1FF4arexYPMsLx5Zk+KKzN3d8MuZY5N7ZSvMfvsBNa5IUYET1k3U7Roydf0Dg7mDgvYPMoDZfcKBXHgjKWtpl8eQ1rsmkOh+0FJPUz21NLw56FOxSgEROjAEIQkTcehuA34Dq5my1y1yhBumSCrhaCM/CZ1WFFKIy8wkWDL+UqzhNDFNucdybbLhP2TKnHpwetqrP0rPIVz3SsguqzSbVZVjenApyT/vV3tE5iNE3sYcT1nAZwvw5UvmYkqorZIBgazkp50EyEJpBf7iU6A9Lc827zQBOzyQUt4tm+JeLARIj3qkq/oAqN8dTdZBC6f3SMov0SBBHGR8qyp+5Wo1Il9D00pPOB9Rt/lh9tcaHmsXmMOIOoX4zq1jUGe/7No7VLTDn+Orhvjc8Vz7BsdV/pk5996ng5CvAzyG/BMZluEdc7PP6iKZZxAD9/bXGY1XZIMIE4DBRmYki4pkqBcxhxBAQ4HH/uNdv1aT8tXKZKWoRfkNEnbizFRvDH7hTXTMCpTKPCxkIr7NFHFkiLgz2IYI5ADGWGFkFUnoKvCKBfj9cnCEyP0g1pephzMfzx6seWC837jRqrt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/17/26 2:01 AM, Miaohe Lin wrote:
> In both cases, will the hwpoison flag be lost? If so, would TestClearPageHWPoison work?

Only if P's struct page is past the first vmemmap page, since HVO frees
that one. In the first page it's copied, so the flag stays. And
TestClearPageHWPoison() is still an atomic write, so it'd fault on the
read-only tail (e.g., 6.6) the same way.


> If the page becomes hugetlb, should we skip the retry path? try_memory_failure_hugetlb
> can't handle this case?
> 


It can, the only problem is the stale flag from the first round. With 
it, hugetlb_update_hwpoison() thinks the folio is already poisoned if
P is the head, and unpoison_memory() drops the folio ref twice if
P is a tail.

Now that Muchun's vmemmap_remap_rwsem is in mm-new though, I think we 
can just clear the flag under it (unless HVO already moved P's struct 
page to the shared tail, where it's gone anyway) and always retry. 
That'd also let us drop the hugetlb.c part. WDYT?

Mani

