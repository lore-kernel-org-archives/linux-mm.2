Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8095D606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=gzuXgMoA;
	dkim=temperror header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=zDpgAhPK
Received: by kanga.kvack.org (Postfix)
	id 9FE5A6B05B1; Mon, 23 Nov 2026 13:52:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D7166B05B2; Mon, 23 Nov 2026 13:52:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D366B05B3; Mon, 23 Nov 2026 13:52:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46D4E6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:52:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AB7812094B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:52:56 +0000 (UTC)
X-FDA: 85467280752.21.3993B7D
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id EC744A0007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:52:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=gzuXgMoA;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=zDpgAhPK;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf25.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795459974;
	b=hA86vv9JEGP0bynNnJu41hDnkAfVPE3OVG92eX1uKSdUBKiNg7Ssd+rbVXYnUwfRV4dKda
	diTtDPjmT6pz5m4fWmFAnu9PHvWFd4/7FlzwZN84qubD5Uc7bVDVoxQN+kAiNGCyJoOZxI
	n0/n9JZ3iUegrOOtvOTNNNGMxd7ddSs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795459974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6R0QSCNbNk1SukQBtyG2ylmuRMbEBKxpRVoIoiV3uQ=;
	b=WDXaIeAiF8BUtfnv7DR8iIWE2AVjmxkth+Sp0JUY4WRsnbCemAf3RajX9hSKys4r2IXcnB
	5CFJX3SXtts3mU0RtYwEs70UI+H7kbGX/BFheen0FrIcG70O5KhbxsjE9nwc7VW/3KGb3H
	4aQNqey0zvO+T6MzBOyAp49Pnbqc5YY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=gzuXgMoA;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=zDpgAhPK;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf25.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ANHY88S2074050
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:52:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=P6R0
	QSCNbNk1SukQBtyG2ylmuRMbEBKxpRVoIoiV3uQ=; b=gzuXgMoA+uckMmlPIc5p
	OHUQNFI2gJNlzZrc8oyiPkXdE2EiJ5o6d0vzLCVftfYXFPDrScbG7mSP1PZWXMku
	arTqF0eLNWJC7iW31YXiJukQwX3XY04g2sgpmnBwMLr+1UwItPUtZkgDKLOe7OTP
	ANkowItWbAYvWiZ/ON9u+XZkU2O0lqNtZaD+ea4p0vPJieNxB5L4kw3ruDkkyBzo
	GnPT32C5khvaFGQ0m+YLlByja7KJU9OHfst03i8b2yzgEVz7FaikMZTx3iQwxfgd
	s+yxwPXyflJ+bflynH1xsA5ab+QWEUQk91ZlJ+PliG4k5tzZAVzkicCHVSueY3X3
	Xg==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j4rgr1ug1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:52:52 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-53661e036a2so71045801cf.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795459971; x=1796064771; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P6R0QSCNbNk1SukQBtyG2ylmuRMbEBKxpRVoIoiV3uQ=;
        b=zDpgAhPKTmtVOWMWPnTM4QmmuQDCnSIwj0XC9b1ye9nxoSyXkpebWlMIeT27h+2yAX
         9b+kSGba6mf0oRn7qdbMrgJCiAadTrHwaNYgHQoP/6LOgtWwdTqLgIZTlUG/ywEDnQPe
         l+paom3baDq0Z9mRiB0kPGkGUqroXiYSpgRclQuxPliNIhE4oV9NIUjtz++xvt7PZtPr
         27rZNi3ArgO/IAgRk+3UJ/z4hkc7xzMhbpFax6YEBekbnMb9+ma70bQ4M1wpuxqOJSkC
         eMGyWOyQH+VGMp0crPXpfuTlZooLnOK8ot3DcQM+ZCrorwiOvtoyrT/aSJA1qAy2X6j/
         reOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795459971; x=1796064771;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P6R0QSCNbNk1SukQBtyG2ylmuRMbEBKxpRVoIoiV3uQ=;
        b=CQGEQtLuNlQ7JG7wQn+Wl+iSkfRmEnJdTpM1VDdLFpJvJYM1zLqHjuAnUB4Ap4a7QU
         XyP1VtwTP8P/zUCVqqtmiMoX3/At52UZs9HOc8Xjl3VU7yFY9qqw0FfZPLu+iQ3ywv/9
         XfdjVeUqf2iWY0wJPx7n9bK+UZI8YLVbshfE4Atb6vMHx5esLe3NaDiutYWMPH8yl/fz
         Vya+BKMEQn/p0t1N0Hy84HRSRQIRP20hRsnv3l5LssnodPCEf3/Lq//dV2hdUnufYTTX
         IdiDoNORuDkf4Tj9hzn4CEA8yB33lvEmHX53fW0CRfsn84qDScqtedT2f3+D8VkLyvtR
         uqZw==
X-Forwarded-Encrypted: i=1; AL+hErHqtobwRs5VHXe1szkMXgpiSzpT9DnpG7AeDRpAt6u/KPISQKXNC8zdH0msQfwqdmCT13JpPYEtYg==@kvack.org
X-Gm-Message-State: APuU4Z+rWrZ19fTZtMgf4eHulGoGL2jQrn+TKPjG1rde+uxdv4Ubb2zb
	xeNbzwEej1vf8BM7OooE8w2CSyCuj5GhyfgAilhq5tjKp2FbR0ZEIFgP+zKR6QKj9hfnT3thUfd
	lSa8/GPsDuYjuU3fxiEcAgQpXaxzRhO8uJ5vIau4qWqo4Eo0m
X-Gm-Gg: AZFdTZfVYKRawo+PjDZTkOl96L8UiplwAfJZyIuKYCQuTr0zs4NlSQtHqjO7CExIL2S
	H7/ulbLWEbnhki3XEny/NuQ2TQd9qR7Os5NrythUCAd+iHCDRtjycNc1c6nP9mHtTwGegtU0d14
	0hu87Kg4tjgftMWQFbOA/jTChoXSe6/C1v34qg+ZmtQl6nf5ufQm9y0IoPX/XRqssJ6PIClkT5O
	nBAFAiFRWri7xaSjgYFHLMR+1UbWwiPGctzyza0Kz9Sw43c1rkexIZddsGPhl6ga0v9mVEdF13t
	zY5lZ5Vtgger0HJSLBGZ4rtuD/L/pfZnER44Vik1rkdGKSMDA2Hjegf4fKTicuXWtv9I7b1v/du
	3XHdBkm34l1Qo3r23/1L5u9oLGzUx0bRLxrKuBrUI8/OALh0lqcU8RlrAk9ba09K9CMBoYHxaDy
	uKFh0Ble7kipfbA6LF8SvgjWvfo+VMGGOKkX4C0fy4veL/dIZtlJ1F9fKAX08NFC9pFng7CXHpf
	MqoSxMgK5bKTLPEwCRWCAhXWcYKHhx/MhBcnIbHZ/Hs3Q12o2e0wpuJlJyyDFA0tRc=
X-Received: by 2002:a05:622a:4d96:b0:535:232f:ca25 with SMTP id d75a77b69052e-55d7698efbemr222965721cf.7.1795459971439;
        Mon, 23 Nov 2026 10:52:51 -0800 (PST)
X-Received: by 2002:a05:622a:4d96:b0:535:232f:ca25 with SMTP id d75a77b69052e-55d7698efbemr222965501cf.7.1795459971100;
        Mon, 23 Nov 2026 10:52:51 -0800 (PST)
Received: from [10.206.149.246] ([129.236.230.139])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d788116c9sm106773881cf.4.2026.11.23.10.52.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 10:52:50 -0800 (PST)
Message-ID: <56de516a-c895-44a0-94f5-ea7bc5bd3ef9@columbia.edu>
Date: Mon, 23 Nov 2026 13:52:50 -0500
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
 <08b18b88-3ab4-4681-bec8-f4564fe9f1dc@columbia.edu>
 <77680005-7178-cb1d-6e20-e23519839222@huawei.com>
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <77680005-7178-cb1d-6e20-e23519839222@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: SYweowlNVfk_tS0iENwlXdLqHSqW5okW
X-Authority-Analysis: v=2.4 cv=DpzDa2/+ c=1 sm=1 tr=0 ts=6b048b84 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=0AiHgshebfoioin7TVvpCA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=_vlgSMKLg18XzmzXuwUA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIzMDA3NSBTYWx0ZWRfX3jwhSqSZnCLJ
 Gp4TNg15MFJN8ZKlQsg9Mc1R1k9v3MPlTtGULXro2bi8lfoS7GXkFi/WPH4d7U6AlJ86NpGG1Ac
 koOTrgD8Lbl6tt8ybtTkd29OijtsF/0cUztfX1lSv9LBvYEMbTkl
X-Proofpoint-ORIG-GUID: SYweowlNVfk_tS0iENwlXdLqHSqW5okW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIzMDA3NSBTYWx0ZWRfX5lQ25nnnTSd+
 i0R9SaEaPK+4fiScZ+BJv3nLHjQLJBMppHRtpMyMH3xWQrq3Mwb3HdmmVL7IqWbn1JyeVkhQM04
 58yRYtFmwf0WNSQuswdcTp9AAf+xS70TIyrAs6ijXAhgY/C9AhdIynS5BRnHXjj3jHamQxiUCBA
 pkxKj7fN6QL1SY/DZzdCnPe5eA0FBm4r0ZKhdGIv/dMzZODwFYL/cDEFCYtvERfHEiB7AM+CoLR
 Jl8JyD232S5HRBW69a6YU6Mwz1LufsXxhS/QqYTKhD9AE7QmbQY4n+J+lwrF31QFikyfX+ErKh3
 o1xYfHuolpZp6xrHDS76efXWOlh0zJVAdyk2xwZztixFFPQtbNoKkK3SyCg2Mxo3cOkq7XSGtPO
 6xkEwPapeXrLYCIC7CTtMol6war9cMbeeN9KmuXwbD1RZJd61CF7UhmvQlpgVd045JYWiPF7U6p
 pUtVPbsFJ3gwl/hV7fg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11975
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 spamscore=0 impostorscore=10 malwarescore=0 clxscore=1015
 lowpriorityscore=10 adultscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611230075
X-Rspamd-Queue-Id: EC744A0007
X-Stat-Signature: mcqqgjqihr8c4joe6hip74a75h965cd9
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795459973-954131
X-HE-Meta: U2FsdGVkX19/abrJa7PwtygzYiJGfAm0E3pBJnwm/DmXn2VGcfy4tRB/o/XA3jNP+WIUQ+Iq+JFnvHJUqN2Hz4DDNhfW9xJf9KhbvUHbY+Xo1XNvglRJRzOtkRZ7swZyuBONNNF7ogZh6sbwD5A0hnyC5WBmg4qFOGxK0OhKnt2lK0C1yHibcY95QxziC0GRsR59qZprbIj4okiqmvoGFQA+akGiFO+dSS+m1qJzLEdQozYhQYUpt6brRrFuTkF9nL0fHTSf16w1G5f16uyUIsm66FeNVcd3zf+z0QXcsXgepSxdLhUT915e0xyg639meZ9OKns+JlVNVGo/0sA9SSnmvHyU3pzRWQKdgWfF+GWfzrLY/Ib2qTJk2XVhE9hPJcwSnW/PDcCQlJqriGhU56jU/yREfZ5wxq3c0/jBM2zjRu+DIb+Cu1V6CNLEPYSUCBuV9BULjgDcUHnOex7/3pI2Qmk5TnXJ7z5X6sUlb0Gz79UBFEJM1iLU0dagjAz7ti88ZniIR9ixmys5+RVqoCQ9AhPXYIzDGlnD0Qzu+m6nejsAfnmOM/7/tCyZO4+Yed/yrETJn9CyrUs6GTWZDhZf+g6PPZqG17tJvMJouh6HYhqedPRLl4lalGs0lFpZYsXavFIXBAKuq8EPFhN1GKQ642vY/aXwplLrICLUUbDsFoGoF77C9/J326pVzqAcAxFn4KFEBeJZIUgKBAv9OnqtN4ozLUvTrhq4GdTkxR78Kox5H/yiHdsu32kmR7u3xQWcHquICAmFCmJXErC3oNRl/ez74fr4hBnG1GiYacyJSafWS+YfaKZy+8eoUS4ytixwFxWbjBPvuDYZAVj3ZCI51jpll+l+EEwuvRfwfcAAfIjjF93NIzmmnmrtDQ9ykQZ35rICssOVcC5AND/3UbL6tEwCoUQ/TH6xOnqTC4P/7Ki48o2Gbco9HUB9slkjh9pAYwzj+OONQUMgO/b
 VqlVQ3JF
 uIER4zpuau+SIOVrRXElvLUwmLioJ3vWKrIP1N2ZtqjAJM2UfD/b9bIdg0Vu1jx9xHZkz8Pt+JHh0nfmHVaSb4uOLzCKYTOViaCnJ5byvICVqgLWLbUGXP0DOyeb1hkjm2QrBozZSHKBUUYNRc+jnocUdXIVA5BrVfLNsGa80I/8AHFkksStA5lXRkyDdbRFyP33l7sxobgKK6C/+ALd28P64YxeywskCPL0SfONElc1B+nIjQFMJMsmDoCJz0R8qp4eo4HopUn+1Yx8Vknej56/yHf9zZWzuXGDRyo4q2/VOHokqKo2/Jk4FFB0gjLEGcIhoujOePX+Hw7Qx5/oa7YhXCM4hBt+danCXfszHkwhRZ3x4pECi/EtcNyxODL+waBLBtegEaJPfehSe+Upd0InbWHlj/GttMDKAuQ2JFg/5I43SEqVMu8gD2tUUiUS0KSv8HjEXe4wM7YJZP6+QjPfgz4Iou6BbX55PZVRdNzcxeNzovh+8enFkdsB8jvAW3hpczs1IEmb8n29EvSp8620IT1zbtRR0cBnNwcr6I4XN8PK4KEp69kYdgqjDYmocjtiaWC4Zrx/TRqAjFsthUctA96VFeKPfivk5IZFy80vrwq3EVBHjE22O9MuhsWYeZabxK2lCuSr6QKhKkH1OXCGN4cXf2ek+k8vCS6bF3wxk9EbQaQLi9oQvAqT3K/T+nF5BWFwEFI3JgWpgfWQClOWB/SrkKwYRhQYNDJBZOL9L8YLezyE4EpXfBQk90/pisWxh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 2:26 AM, Miaohe Lin wrote:
> If P's struct page is past the first vmemmap page, the hwpoison flag is lost. In this case,
> do we need to do something? Now that hwpoison flag is already lost, I don't think so. And
> TestClearPageHWPoison won't do anything in this case. Or do you mean TestClearPageHWPoison
> will always write even if hwpoison flag is not set? If so, can test + clear do the work?


Yup, that's what I meant. And good call, test + clear works too.

> I think we can correctly clear the stale flag from the first round.


Yes actually, so just this under Muchun's rwsem:
if (PageHWPoison(p))
   ClearPageHWPoison(p);

should be enough? I can do this for v5; sounds good?

Thanks,
Mani


