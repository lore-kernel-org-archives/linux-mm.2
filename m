Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BEA9606A326
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 15:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=fiXWWpqr;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=cdY5GXnQ
Received: by kanga.kvack.org (Postfix)
	id 831E86B00EF; Sun,  1 Nov 2026 10:46:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2106B05B1; Sun,  1 Nov 2026 10:46:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9CF6B05B2; Sun,  1 Nov 2026 10:46:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8F06B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 10:46:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90889A82C1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 15:46:18 +0000 (UTC)
X-FDA: 85386976836.09.85A2667
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 706A12000B
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 15:46:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=fiXWWpqr;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=cdY5GXnQ;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf03.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793547976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zh/eyo6M2RHjRsF25F61w93yrzGMZmR6HtXDWGgj+0M=;
	b=szQc0y+yywlnuhZJT1524TM7vd9r2rFjxqhIEjpeEzZU4aeffhNQxEn0o1JMN5kfPL0PQj
	S2vNx5U21XJo97JDDJmJlyjd+HKpDejnikAgKjlvTPgpv+9k6//6BHsVoKnAAyevQQ4ga3
	x2sYckp6EFY8MbJrH+IlT+LrNYdAW+0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=fiXWWpqr;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=cdY5GXnQ;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf03.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793547976;
	b=ReBnchlRWJyxkK4N+O+nqbQxvpNKlJ0FBsslsy2qjeAkW9FzNp0BviLpGswON7zxM7S3p7
	G4a89C5YuYLz0/Tu3b1/Q6EDVlNo990KNkOP43hDANCQM5abO6P3S1a2qEw4moys5mg16J
	DUnFmH1ZPsqND6ODcqJJc19iEXFKvYE=
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A1DSfb42915250
	for <linux-mm@kvack.org>; Sun, 1 Nov 2026 10:46:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Zh/e
	yo6M2RHjRsF25F61w93yrzGMZmR6HtXDWGgj+0M=; b=fiXWWpqrhEKnabq+O8Qe
	4p7MYiwp1IDmw2sq8ufILH2S//wrTtB8haPB1cgQBujDVeOIXG6VJunRZXdBf6zs
	7JHGnMMl6Xcq3vIedZbeSkWZqstfxnhl7FFsHW9d1qxFfTlUvuTddjf52ub4yYMG
	uibGhVgGx2ub5WlBiT7fHWrJv/R3ffdUvtCyGjOH4JO9aGJj++jnAT0v6cD1SHfy
	UqtIlJTuhjlLAc3I0MR70WOxpSMHZfwix/P6cZKvsy0B8x+LOj+UUSGvjUpWVXGc
	guF9bJR/lpXWy+vHTco3ETjGKkDw9LZ7Lsp56Q4vFEYFLrMl+31gFdOCDKGb5+2o
	Lw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hnwtt266t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 01 Nov 2026 10:46:14 -0500 (EST)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5364605e74bso65938811cf.3
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 07:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793547973; x=1794152773; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zh/eyo6M2RHjRsF25F61w93yrzGMZmR6HtXDWGgj+0M=;
        b=cdY5GXnQcr+cCJUGSC5dRyM+NlbClZ4DgNvYJU9Gri7Guv2XBGoUKgCDRU4ROWO23Y
         mZUPZNIfyWPFP4tn/lVVsaQWDy5lNPE//WwsI9xm1zfmuHZnA4oH+ufei5rxwRHur+pC
         /xPbdBVbk8+9apQRgMCa/K80C6jLAEEq5o+aRGcp+7chpvzyn8eIkksDcmVL7AfO2ed6
         Yp0gAJFOpKJjVEIMjaYwqmAHSb+IlUdEeFzxolGjBkGiTwjgONdA4sQCEHr5kp9IqCHN
         AHs5eWnBLPY+dVnoaJkDo0+x5EWq78qWIEYo/qGBGDidwJnNv/VKlS/mRBgBa+x9fWQ9
         paBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793547973; x=1794152773;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zh/eyo6M2RHjRsF25F61w93yrzGMZmR6HtXDWGgj+0M=;
        b=PBoj6UGoU6fa7DWbEzupP01tUZYXUxRV8UsLkjqvXYbbuZp0gRe4UiWW/6HPmOVh3j
         LPnULufz5fUcMlcG5FZcpb0V/kp9JepLn9umZ6jJVbsC/RSWlAt+vbQ7UUnsiY2+y/6E
         RUzGJ4FcRdLyZ0g37C25FOl1W+fvjNNrIHBlSyWltZ7yZmBvjSCccOGmaxj2zj6cyHDQ
         h1fYfuO3jzwRuqqKpweolSz3O1f30n6Hh16MJDBYW0F8Ra1APQLisBwdEtXToBeG1TgH
         JAp6KG/HDhlBtU+oJhlzr69JMokWo7d2Qv7yvAsBAHsm0C0KB54bDsde1lK3QVbbZr3S
         I0nQ==
X-Forwarded-Encrypted: i=1; AKwUvByTuq80lW5rHvI+y2Gfp24+95atgYjrLvzxC3JO+YfQ4JOKsoXjsh4lOslSCgZj+05rMmdoACTOlA==@kvack.org
X-Gm-Message-State: AFq9FYIeK/4usu8LA9S7NT/qGRPrTGEDIQKxbgaM5sybFg33xfg+i8/2
	V0CwM/lfoBLNAXjZjaujqFulHBO8wgJ0vP5r9N1lcK6V8djTmWqHg4q2HkPRXen+yuUl2nMGUJY
	24BoZdKTpKq+vbVo2On1uf78r5kJHSzjwERIhBDuQVoeXJsbS
X-Gm-Gg: AYBFou2GkLf4zDmVyciRVHKvG+Q/5Qrl1D5eByrE/a6ApEdBHNGJ3j7QZM7tDrS1gHW
	5EcdvXhngiozUqRNmwK2OoZr/MgFnppC7IavL0em18Kco0L5KewtF80qFJUDT6U8aV65oROtvrY
	DnyQ1kuFgN5RW/+Kv1WFD2ApbQXQpjZTvAciDDTKN4w6EOc0lMArBEDrMI78hKJ4ciU4ninZDPg
	LVvvscdBTEFS1o/Y2ciYaybBWIfloNJxMckqFwdjEELIrdXoBsnLUuGyMci7hssET2Z8UUz1MKV
	2FlvbqdFAPTvUXJYQJIVnC8JUFaZ3cSjavGoIPviy81QAU/4yv3gsFLrwGBdQws0iB1Ys1SeuNn
	3YUopo8BoiR/FVtVw+sbZJPVhr7cmfJFDe7rLuzQhXAFJlna1De7XGHux5o9LYekcXJYOzTlqHl
	ocKlpvfnMyEk0J5wkbgjL1YQj3RY3OkR7vlNZn+yT4vZL8VTzk4k04b45hkgKpbbp4sBzfQLct0
	gxjz/lT9x8NFDHSOM+2EczBaI/rS9s078VH9VFixX5bf/t8S4774NcoAWiKboo3CMzLRr+r96/A
	HavNcQqZ5Zs5SV17w50=
X-Received: by 2002:a05:622a:2445:b0:536:6c22:e346 with SMTP id d75a77b69052e-542b7ef7ee4mr131486141cf.68.1793547973583;
        Sun, 01 Nov 2026 07:46:13 -0800 (PST)
X-Received: by 2002:a05:622a:2445:b0:536:6c22:e346 with SMTP id d75a77b69052e-542b7ef7ee4mr131485721cf.68.1793547973169;
        Sun, 01 Nov 2026 07:46:13 -0800 (PST)
Received: from [192.168.1.187] (ool-18e492e0.dyn.optonline.net. [24.228.146.224])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca7e23441sm68905836d6.4.2026.11.01.07.46.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 07:46:12 -0800 (PST)
Message-ID: <930e2b99-df87-4aeb-88d0-d12d012edbf1@columbia.edu>
Date: Sun, 1 Nov 2026 10:46:11 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/swapfile: drop a large unmapped swap-in folio in
 unuse_pte()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tz2294@columbia.edu,
        stable@vger.kernel.org
References: <20261030-swapin-large-unmapped-v1-1-41e4ae378e6c@columbia.edu>
 <04ad7001-bdd4-47e1-9a80-5b2464da1044@kernel.org>
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <04ad7001-bdd4-47e1-9a80-5b2464da1044@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: pdh8y7TMfkv-KwXxhO2zdgjJAlK7AthY
X-Proofpoint-ORIG-GUID: pdh8y7TMfkv-KwXxhO2zdgjJAlK7AthY
X-Authority-Analysis: v=2.4 cv=RsRQvymK c=1 sm=1 tr=0 ts=6ae75ec6 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=FE+fbgsriwsnvVT5CFHM3g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=JsHdwqBLpqT9QgIBurUA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAxMDA2MiBTYWx0ZWRfX2/LYVXRdx0qv
 sA4TiOvNVTR7+v/9hGTHV72oHG4nbzfEI/InyTpmiPpSng9Du7Sz3J/EUqn2qmLnIsOGMWUUFqh
 dZE+eVL1o8txNlEqcHKvrz9DwEUSdxJyTWWV7JkZIF7sqdV3DgWi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAxMDA2MiBTYWx0ZWRfXzIceywAPFAZN
 eGkyD+YEMQXoJ3kAiG9nLlVBLJtSjFLqYU/VzXtnZuqmn8hm9CpqncG9D8cSz8megzs/jKFgHGH
 WeUMvWvIg7omm57mRc9CGAdvZyv9H5aLppAN9YNsu6dJXoD12o+YICDwBc076CzguCyd7Pslsey
 Rsf+PvR7Car2J/JtlBo6uBhi7qQqNljPao05f1kU0N53RCMivsoAB7JtbjfA4J0h7NVth/oSA2K
 Us1d1yRnEuX2rFG2BVXYY0WaMHbzJpk2gjGYoR/vLkeZBXOtTS2PtTt7QLu3poz+m4p0q/rw42S
 Goi3ZyfdC4Iteym6FGYEEszlY1RJ65oUa1AUG00pxDiaD9O8PNrXe/QHy9K0g/8brigDJuaSH9h
 id+8nRDoiggw7B9gQg53OAB7/aPS4T1nUWzI3cLlpynUdFxvbVNy70LA+2JicVep0vqthAQiY6U
 du9lUaLXkAcJB/EFa1g==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11953
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 suspectscore=0 lowpriorityscore=10 impostorscore=10 adultscore=0
 phishscore=0 clxscore=1015 spamscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611010062
X-Rspamd-Queue-Id: 706A12000B
X-Stat-Signature: s5rescqpxxkmsa6honb46jp1nxh8qxax
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793547975-523193
X-HE-Meta: U2FsdGVkX19S9nao2LwXMrZY3hKdrCKvSkl2ziXbP61fourxhqyTem4nY0AEEuvX0g5XiQK7ktBq34qhsxPVP22phNi3ODSaM655CFoTDMSjAFotwVC0tKadAAFN8+3HIf+5AbvMnzDRcpc1dOWck+8DWPBvQhxMDuOgxxnzoIh1CXF2Ff/fKMzj3py/mln537UTrjfw7sp3EDoP+G6sIiBYEfS9bMIza71OvFuWYP412qbSAYxW9+a6+zOlIpprPOY+1hHgasEyQuZvHFoFHfb1NRT/6nCACkC9KeEcMEAZXoII/q2Zs+fh4JXnvUAJhmb+XMmxWb33YX3ST389xQYAsXisvPodVxYTVIPjAoK/QeyaWOlNd8Zuk7ns6AuXYDEC1v0devNd3E3vIYHW6f4TiwVnhjEjfOUqputFQXtA9w6xrbTeSCgI7gtAP3Y7UqU2sL70kg9RUOSRkY9wrpCr304pnOSM4sk+IvNn+SapP59YtzrH+9/onLLzK5IpizeZocPp9mTL36m6D1FQ3wrPjqNYFJ1AlKb/JJkwKeJvfbWS1PHr0aBk8xEGrq7yWbIA/6AmaNFNi/w6tXcLXEJUs+8FNDWNtd6W2o4JOaDOJtqHhLQZPLAGukUR+4skTiyqRKz/HuaibT1Pb23pI2E5dRtC2Mbo+6ekxHL82LLe5vS0+7q6UXejPuHWxrG044hxvQtsPZUtAEGhGRWolGYtfVM9oXA9E/PMFBfia+cYWnjxk/Mtex73ru6wTD4MhXuP3JjCArUbKmqkaQ3NspSYlm1wOFYIvys7AksRgNNmt+rVD+TElO66E/uEhIqHrg/Xva8YaCffMfcY8PefKMDTm02WJVxvWF0BSCcg7Oa4rXITeCZGnU/ghOrq8M0VjXUw3eofmS08E40hYr48N9sEMzP0MzqYuWLGGyF4eceVzYcvrj2fM5g6W6cC1kJqczOXy1rRfo/27BAZi9o
 /ZKozZEt
 l6NAlLYPFC+A1bb+YXjnGyYNmvoRzGj7yOskGeHmmNe9JyEKIuKQNdXvCT75ctJuySkhGlguebvtsM2ZTs17ed5WcvrxjwN4JFIOOa7gCcTBo/Ebnn2Ep7mpCEybBYCy/Qt7r1uoGAbGRJOUY8t8ryhLtxw7iIIulqLMxNLZzdFfXHDXPO2Rrr7WIcTw9llNhB23tpHYubgLe0ME2aoS6wkSqFE5N8ui9rm4AsLs5Bm7pGgjEeadK0LKDRhJszpCD8YLMxFoPadeaah3XrLfGw1y7GmkGCtcEK6I8/95BSv5Hpzs7RACfQEWjL5UMXTkk23qgY8OJc588x5atEYaEcGeMfEXnnZ3BEk3htyik/dxfwUYiqJB21hMufsHDAKgPYKrNVOrHvoLr4a58jIScTxeEt9y72aLujO5CbeefEQ6dLAZBITsLEFWZtASKYX4fBUf6JqdAI4So46Mq6YCazEfNbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 6:15 PM, David Hildenbrand (Arm) wrote:
> Why is this special to large folios? I guess because a single PTE keeps the
> large folio alive, right?

Yup. For a small folio the one PTE maps all of it so
folio_add_new_anon_rmap() is fine there. For a larger one it marks
every page as mapped and exclusive even though only one PTE got mapped.

> Can you pack the existing handling in do_swap_page() into a helper, pass
> nr_pages, and reuse it here?
Sounds good, I'll do that in v2 and send it against mm/core.git
for-next.  One small thing in the helper you suggested though:
the first check should be folio_test_anon() instead of
!folio_test_anon(), otherwise a large non-anon folio would
still get mapped.

Thanks!
Mani

