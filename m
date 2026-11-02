Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F32606D802
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 20:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=CAq6ZRQu;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=51tnYyCb
Received: by kanga.kvack.org (Postfix)
	id 179B06B05B1; Mon,  2 Nov 2026 15:24:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DCB26B05B2; Mon,  2 Nov 2026 15:24:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6186B05B3; Mon,  2 Nov 2026 15:24:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C18246B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:24:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 51A04120245
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:24:56 +0000 (UTC)
X-FDA: 85391307792.14.0E46D74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 86430C0009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:24:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=CAq6ZRQu;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=51tnYyCb;
	spf=pass (imf22.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793651093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pjN996BwASNbznAuXP1p4D7u6OJyM/x7QZnjkTw5jXQ=;
	b=qKt1lqE8vpVBpXnmGPPB4jjxeIy8lnmAzJqrxzl005ocifE/yxsoRVWfEHD60XyBjeUtAJ
	F3enJQLziGhq3zPWWztN1vKN17Gq/zG6yHNYLF3Z+MFUNb/Hd2rS762Gw96ecU18llP7Xb
	fERrh/GTEbOHmDQPH6h1dksDFoIFbOQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793651093;
	b=Ie0yf+d4GL88HGRhlAJ4CXr/f4mQloWUR5jmhSDIyXzjGmw+izAcnBg3flFqBQKIZGbQDd
	RhKcA4XvKeBCau2HUmSZTOpLPIi4DFf/dAOPa3qNzhXpzWI+mJRqYVTDQtlm+slXs1nWh/
	IS224ItUroT3nrykfv+g1SYza/sZl88=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=CAq6ZRQu;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=51tnYyCb;
	spf=pass (imf22.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2K2ukC3105945
	for <linux-mm@kvack.org>; Mon, 2 Nov 2026 15:24:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=pjN9
	96BwASNbznAuXP1p4D7u6OJyM/x7QZnjkTw5jXQ=; b=CAq6ZRQuUFo0zsh4mT/I
	kXvU0y3qR2UG9+MTAQ/cwGlvNgrwhTXqzfkTzKM5Ck9T7Mi+5ee3YL3NG/Ig/G7H
	0DqFbU+Wl0NKah5Fp3RQcyC7TJQCtKrglJCY0K0RgslTWk0NiBk/Jtpcj18rlBY2
	b533oHoAEEFNZlyqdTM7cyInrvE7p9cRK6BTOSPkfPD4C5txGSKteXpzy55kucRI
	OmMuyeAfnuUWH0QEcoQI6UOdlOVW7lBxKyaAD44JUGcJy07NgP5KRrOXvNM+hY+/
	P3nbhz0/vS6WEHu5hihdXVquScGiesCMD7Z4kjbC7FPy/Xhndn5PmPXHGqaQ54ma
	cg==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hpvuvk12u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Nov 2026 15:24:52 -0500 (EST)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91c861b562eso64575356d6.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 12:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793651091; x=1794255891; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pjN996BwASNbznAuXP1p4D7u6OJyM/x7QZnjkTw5jXQ=;
        b=51tnYyCbxsgKPiV0FBAn9SSuGw79vjlWSmcrMt8sd4npu7MwkLwW7yl7SLNMxKIKI4
         ocOrcbJffqbwy2TY6Pp6Zg5IcsMFNJhDjxWer9a1rpdOgxa+A4YY9yRQE/xrEA7e5axw
         0sI9K3lQcNLrZRk0ebiXQG5IFIlRbrmAa64KoaRxtcZpA1nPkkEvpY76KFvWWRN5WDAW
         LrN4cMRf7H6jxCVAaWJAOPMstILaUbLwlIPjqG6srVwwDI0DQf6MjHOZgsSjzqiUnjdH
         NQ81Ud6w2JiGsvl9ek0kZ/pR/7OpvKz5KHhMe9Jcy+iVJd0XCOX15w58r/Z37+ik0Geb
         QdJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793651091; x=1794255891;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pjN996BwASNbznAuXP1p4D7u6OJyM/x7QZnjkTw5jXQ=;
        b=LcTDAcmEn1RApfFddGRDBiRVoaqnqX5IG5GyTAQiQbobrkaY74t4aWXL4kJg6Ke+Wa
         mrAPu7MxL7ZjePgKFDLlY0Fhe4wgwZbc7rtmqxfLE8sPFB0UYR9Y5KzqcWqIwlgd68dX
         8JgtIhuxpTydmO/IVc+NtrBgIFUWDaqDIZhrY1KZpIi7/fANukXNGOFuvh+YDLeRMzsX
         qu/qkWY1n4kYyuMtv+reTcz1AwoiQIwkyusEsoehe/mCo08xY6nSY5gyZRpjGRRRS43v
         zv4FtaNUWgGvk4LnIgpdRALGmlMvQ16TDPwmPrFHvm3aQTt071dB89qENW3hF2ZLU7hh
         +dag==
X-Forwarded-Encrypted: i=1; AKwUvByTu9FpWyz6yTEhco4dvF1NKhfz41lW7LB/gMZSWbiR9bGIS9q6Q/A7wGWhaluRxaqjHysLsT+plw==@kvack.org
X-Gm-Message-State: APuU4Z+ok3vgC46QPTzME+VP3VFfyEOTFp/QoQMYJcJjbV5KsRLFG/5Y
	MtVl6h1UXZ0Mko/axOqQQ3qeIjxcSklK9cWSkzZ1xWK9+Epd9RYSChIcB6XbXEjD5MWYYGsWx5C
	9HtzWp8Qk/cBr39oNaQy0fbMNb0BI0jTgtp+2zrbDUma6DE40
X-Gm-Gg: AYBFou3jl8ABjUmvzLiLDXBVrHmqKEWkrYsExY7xPeL1GrQ4q8WGD5pNsXi7RfBqelc
	bJRFRgdrqg9dMjuESEaihQ8hAq5+psSzTv8v250tEvhJfUUIFZ2hE6C72PlR+htPpAH347Hmr48
	Ab0hyiLHCkEqiSX6VVfbKYykUosXAq0fZOb13907iEVgqACE80rr72xFMpTdSwCqlecEhJ1gHgS
	4iIZrrfd8H8g9OuZ6R9mPXl2fHJeOgQ0gPuQ7UK0pJtaQG5Z1zve5jQcmlFkncH8FG8u2BVrNey
	LVeJLpYsFfSU05N1SJgdhWjHhJ1GzdZBO9ZkGZNO8HHiLEFOZ2uxrfX0kOclYH0oTWovWGn+h9d
	4D2f94NUGiOZnJwhX3aewFQTh6as/8ak1gTGtrcUWuLGkvbS8rwLSA409UZZ53D0xWiUOosZzpP
	Hzj99ZKjf8RN0zr9d+ZcnL7Ln+ANQtluOVUimBMr/zgXX7mb/nSpOXdcmb+cyXRpoT7Si8r2cnk
	6maNEWkW5FhK/fFbphJ1wqvxGOfzFjOJSOhC0ocQ4ILIZWHC0IxLMXdJzmw6m6FZA==
X-Received: by 2002:a05:6214:194e:b0:91c:9db1:f640 with SMTP id 6a1803df08f44-91ca4ad2ec7mr190777906d6.18.1793651091253;
        Mon, 02 Nov 2026 12:24:51 -0800 (PST)
X-Received: by 2002:a05:6214:194e:b0:91c:9db1:f640 with SMTP id 6a1803df08f44-91ca4ad2ec7mr190777626d6.18.1793651090838;
        Mon, 02 Nov 2026 12:24:50 -0800 (PST)
Received: from [10.206.225.113] ([129.236.229.128])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca7f252ffsm100371496d6.14.2026.11.02.12.24.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 12:24:50 -0800 (PST)
Message-ID: <5b5dbd0e-6f29-4573-bbc4-1d07fbcbf1fd@columbia.edu>
Date: Mon, 2 Nov 2026 15:24:49 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: clear the hugetlb flag before leaking a
 hwpoisoned folio
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Matthew Wilcox <willy@infradead.org>, Jane Chu <jane.chu@oracle.com>,
        linux-mm@kvack.org, tz2294@columbia.edu, Zi Yan <ziy@nvidia.com>,
        kaitao.cheng@linux.dev, sashiko-reviews@lists.linux.dev,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20261028-hugetlb-hwpoison-leak-v1-1-77ce56002523@columbia.edu>
 <sashiko-outbox-189633@kernel.org>
 <0043912c-4225-4d2a-a8aa-d160c832e7eb@columbia.edu>
 <ae6058ae-3703-a1d5-d82f-4102b46f227b@huawei.com>
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <ae6058ae-3703-a1d5-d82f-4102b46f227b@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA4MSBTYWx0ZWRfX6uGLphXVRqKp
 GALHJZwFeX0tyDqaipmG0hztbNEhpCOjZ0z2bnB+XMxjOAG991/HyCL4Hakv0mjl3v40clD72Iv
 P8A5PepOFwaO2bSIZ8/0M7nqQeLFvsSvT90/tq07PDsoVnzJWgab4O6RZ2NlytfmVKXJGUOvcH2
 qSwuu4RUuT/WARq/h1oyvYIaF02NSCf6L03Q0BcKIRv/kEIP6054HjNsplb9dH5vj8fTAw0/Zax
 4ZEJhqSzxjyKzYUC+9csAzkzDGe5mQa5zCcpKiTJfSzNrZyk7skdll2P+oA3xAhUzQ8tQ6juRuF
 X3QZfQLe1sEeXdQ0MbZlqycmq+5fe6rQgnxrmVZvUgw1kIV8BMTxsELyIq+v4XMrCZyDAToNFLf
 qdNJ3zxG6KDw7CVWvcSe2YOi3Vbhne2jcBViA9Cylrw9ZsONJu2aPNMBkDkkocenLDxoukSOwEq
 Sr5R4U/CcUeQyNDMd6A==
X-Proofpoint-ORIG-GUID: 3Oh5UXv0nXL5k-AYjp2ue03MQXvwEvBa
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA4MSBTYWx0ZWRfX0xUz2M8lzIqP
 ZiWdAM+zgjEH/BGABOhOhh9QTBawwLSBU6/ziidliMsmqqA+DYCfJDahNnwKjYZ5CogEGPlQ24d
 3B8EbWfEfqVnmlwntpVcCqwswxmYgROXt0W4I57ZHWpSHMiAF3jO
X-Authority-Analysis: v=2.4 cv=R7eWitRX c=1 sm=1 tr=0 ts=6ae8f194 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=scx9rK10MffgfR8e+ftusg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=5XypEgDptGhv7p-PtYcA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-GUID: 3Oh5UXv0nXL5k-AYjp2ue03MQXvwEvBa
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11954
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 priorityscore=1501 spamscore=0 clxscore=1015 phishscore=0
 impostorscore=10 adultscore=0 malwarescore=0 lowpriorityscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611020081
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 86430C0009
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: fxhfssu1bcqeubx34dwiwzuoy4y4d5c5
X-Rspam-User: 
X-HE-Tag: 1793651093-904861
X-HE-Meta: U2FsdGVkX1+AtTYs60QDiIEo0I70vZNB1ukbKHeK9/IKWFBSn3lgsSx6ajTNtkynxUyZYNJ8j019ZULe0gACpigU/M+UBFNmJbBxmZ5yvITCS38z8nZCCtCpvaCGsnGGyYaoYr65Yb3GHZwQrPeyo4NUK73cwdVYbsXWtXznUTpyYf4WIbKN0XtCZKajI0+grRRQrXYGzX9Ebh+iny772lSkfTjlReIq8Lz1DcPMSsfTsARAnf2VCKL+zbbqowY6jjlGyoN2MHUxjb0nv9+FqgJhaWj1qjTvAztOUZl6MX19hMTHTIoDXz6jEwN2r6XQzOgyuWLSTnBenjYf68fWGfOybEv4VDmmPxDWfwVH94pwJ6nVCEz6IsDgUsqY7WG5F5Nw01lpg49/Fl08/ePbq2Rh+ct8Wecbzxg6XlAu46xpoEAAI5Mru+JLfIr6FLGminDWalP2MhkBErD5buLTZBzUyAU3YXbFLrjENF9R1Q3XRVx7nXqRvzT7sqbpvEZ/0oGv1bzrrgLNRbo8DABv9/mokGsAF5MZOWgEWzJCV80mBKEBNeo5rRfyL75yXXeY4ip84vUeqemTMMW8ERonfVpU4ZdlPi3BRcPT5mHa5w/sA/gwZJVg9jcRErVyzkYhj8Ixb6TSO2GH1Fn8M84PBdC/lVf48RjtIEKmhKpoRdX2+4IllA05vzSR1y8uPRbsO1Mhg/LHiY2dFN27KPXxpec5BnF0ay6zp9RFJ5mg8bAJKyiqqcIvzTrrqbA/ofbiCpGYF2YxzYaTcUEvzSvNgCMyAmN8Y1AzWZnMwOr9eqkdJ1Zp2Fva1KCNnSQd2PQCjkxV0l5knLqWwpWPF6dOarhk1T2aA0bYvAPL8cTsuBe+4Gw+hNmMR/ab24KCGUZ9ONY0G2CshPXIXBG4kvifdn5r7L4qNRKnOKQarzitXnmAkeYXXT8oov/Ne2LYg4TG9AqSPJn0y2dAbLdFOQB
 2Uq9CgTD
 Rpow0kUJYd59voG5ueovDP1HS7Hdjhgo8tWxFCEo0Vaiwg6CR7yqDTZvwrtzZMPFjvloRry1to9e1oaQA5ix9/5gOI2znfWbdxqYp6y0GcCsYriAD+nfXoMuJWtc3/40u6EqGE3jCMb5GLtFWh3k5ccfq05cu4VGFz9lLIkKdezXVdV1NSt0EF7GG9wS0wVjkLx+Mry/8sF54n45MwhrfJZXff/HqsHtcvymkkrfdFPxcUdZzwxAV/yY/duo+17Lzvw9XyDV2kTLOgd8WnPHxlbaSUD/m/4zQ2DrbIcnx0urCc2oA6KNCn8uzBVIZ9dBHsh41OuYRX3NNeXYO2JsHs2hCfqWttRrq9j1F/cIasL5q3iv6TDpmO17rCJLeF3fggTTKu1ISZdC2aCZ38nQAiSkKk9+sTDdwcDxRKg7v/QHAWF1CSxV3Rb9OE0re97GXscuup/VS72Pr8sPE//NDvgIkEjYoZ4he2LsQWp+QFF7eHEE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 4:17 AM, Miaohe Lin wrote:
> But it might still not be a good idea to add hwpoisoned hugetlb folio back to hugepage_freelists?
> 

Agreed, but that's already what happens to any hwpoisoned
folio when the vmemmap restore fails, both here and in
dissolve_free_hugetlb_folio(). dequeue_hugetlb_folio_node_exact() skips
hwpoisoned folios so it never gets handed out, and a later dissolve 
tries again.
This patch only lets unreliable folios take the same path.


> Also, with this patch applied, these raw_hwp_unreliable hugetlb folios can be successfully
> unpoisoned now? IIUC, after hugetlb flag is cleared, hugetlb specific information can not be seen
> in unpoison_memory, so they are wrongly treated as normal pages.
> 

Good catch, you're right. I'll make unpoison_memory()
avoid this in v2.

> One last thing, Can the problem described in the scenario below occur?
> memory_failure -- VmemmapOptimized hugetlb folio but hugetlb flag is cleared
>    try_memory_failure_hugetlb -- It's not considered as hugetlb now.
>    TestSetPageHWPoison -- For subpages of VmemmapOptimized hugetlb folio, this could lead to problem?
> 

I don't think so.  The hugetlb flag is cleared only after
hugetlb_vmemmap_restore_folio() succeeds, and if it fails the folio goes
back on the freelist still as hugetlb.  So a leaked folio always has its
full vmemmap, and TestSetPageHWPoison() on a subpage only touches that
page's own struct page.


Thanks for the review!

Mani


