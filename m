Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415A4606A8BB
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=qyRHIxrd;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=ELE9yUDZ
Received: by kanga.kvack.org (Postfix)
	id 514D06B05CA; Wed, 11 Nov 2026 18:22:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC426B05CC; Wed, 11 Nov 2026 18:22:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3CA6B05CF; Wed, 11 Nov 2026 18:22:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 170356B05CA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:22:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 979AD1C3AAE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:22:05 +0000 (UTC)
X-FDA: 85424413410.30.925F1F1
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 20970120006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:22:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=qyRHIxrd;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ELE9yUDZ;
	spf=pass (imf29.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RDZDLRTYQ+pehNWhTTSvj1YCHvxKOaaZEnb+1PpFOI=;
	b=K8RfBDGHzS3712gbQhxfuyzTDmZsKp7EpruIsxuqlw+wXNro4CvlpC2H1sFKzePw4KCdbF
	ibp9ROANAYJnjmDrU/gQvmVovGbtnixX5Fg47pDZ9T/f/hJp6JH21Jr4B/dG1bVIdyaxjo
	U3gvwCC+xCsqkAOaKfgXS9jElhWgA2Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439323;
	b=aI/K+aZXxahMchSMYlvbNu+mkllKQw9Oh/5bRFckD+6h6bwbdOTPx90EN7tbnzr1ij2s1O
	FLXYV0IXKjd9GHoV9ccHfyT1yy23FJU9KIZWZ/DSN+DAkpc7I1Vi5UP8jnMOgs7bZxwHYX
	kwM8J2dWiLOA+qxufTwp6ipMbe3JR4Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=qyRHIxrd;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ELE9yUDZ;
	spf=pass (imf29.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABMCKnw902228
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:22:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=3RDZ
	DLRTYQ+pehNWhTTSvj1YCHvxKOaaZEnb+1PpFOI=; b=qyRHIxrdjV9xuKPMPbEN
	Q8jUh1svYxpXYQNwH52ReU/BhOJWekTdwXBixTj0mWGaMR2DlDzVgswqXjE9m+7Q
	NAp6z/bl1lbHdMnl6UHxJAjpVxQhbr+wyiIA1WEXfVwbGh7YPl2f4UcDlKxR/vC3
	2/W049z57Qz+vl2Y6qPrOqEgceLy3T2vDXSjZN6VdW9RuK9mVz/6++CZV7JlNdh2
	1oNf4n/NWezx68jbnYmcesANpzJLOjiYZJHyZ8sufMcPGoPWYlm5huXbbZeq3G+O
	PIr47hCB8sieDQeEShcp6BsWiXLCyk79iyeENSijxD8VvgkIaeq+s1u7bku6iNqe
	7A==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hvxjq1mrt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:22:01 -0500 (EST)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5338ff2cf14so71495231cf.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794439321; x=1795044121; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3RDZDLRTYQ+pehNWhTTSvj1YCHvxKOaaZEnb+1PpFOI=;
        b=ELE9yUDZClmlCIK4IS/PWpR5FNanFvyHs7shOjVqdWFi6W7Iu2M2TULU9lzX7oMjsd
         51d948jh88SAuw1fz4OIK0hf3PMuTx1JQVTictduYdYdLHmi1kaZBiMzkDI8WkWbeIJk
         2w1H6OTBHwbTOo8i8/GdmABIc4AdENAgkGfZUcg39TCf41hvo5DjeK+xM4BKMs1IDCRp
         feD/Gam3KjP7Zhp5ILY2Ckr9gJCl/fK9aDxMSyvhTXo6+kNDQ6tDC51hfbohABK8hH0x
         WYqvXR8tyc7vUZaTnm68+xK3Twfi9wkH2+NWqspQJ6Us2NoeLiuNwGyHD2zhaBIeBh3j
         QF5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794439321; x=1795044121;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3RDZDLRTYQ+pehNWhTTSvj1YCHvxKOaaZEnb+1PpFOI=;
        b=b13a8UCUUZagXolFBb6BckQzbKEg7Ukv1HXFr+gax+1L4CzX5U9C1uPBJEH4YDEb2z
         igMH8rkNCoC373ezASieZT5gkxakxkjqS8SwpoLPiLfRvEdO4bKmTq+q259KdYgfCRpD
         DkpwJUhjRtKJ/8ZvnIPZX9ftPV8tGTzeWRMuFVFwfoEFUmOh248xmOOAzpHXyEwRs3VF
         wYv9iuxMQkLN6VMtQ9FrPbXGWn0KhJVvWrWqe2DO6trFb1ndUdAM+wCa3lhWm1twiBFI
         O/VX7NEsOK4407XvkoVJIfK2fuheWUdPoxX8H6CLvQN0eNSzHCVdthys9HsqRzk3ytAG
         P5YQ==
X-Forwarded-Encrypted: i=1; AL+hErFYhIG8hH19z2OT1T66pefyjPYvhEhjrw0vczkk/qx7rFkDCEaaaKfo6o0X1nx4IHUdGWZsZFQ3iQ==@kvack.org
X-Gm-Message-State: APuU4Z95dFmb7eFV2RbEWJE1XfDzG4SdbXWEAf/kzvjw7EbLdP767J0H
	Y1Zlu053fGlP5DoEzBlTdEUNtF8FxqlO68yCooQk6h5eLusu0LQ8hRPmB5iFpZE2n6baQoIb84k
	o6tQf9KnWOWaTKl5NYfjIwMtLIr+g1WOlMhFSFSnuL+0lhaLy
X-Gm-Gg: AYBFou3aEbOgdXGqORhV9OHi0rmMCoxTpBczTN+w6qorMUBKq0iWayrDurI9msX88lO
	gyV+4pxm7wpBZTIdONfdqFCI5IP3MdwlAKgT3/VQSk/DaKBFH1uuYkxgJE1GuDajbpLDSlOSHKj
	LquIZ/0XdFKOQE6B9dTGdnvEk4VB3hBFmrwlUvbzweecPH0W0ZTmuZ5lQ2K4OCN1eH4lSR7oeeq
	6CphfwefiZiAmubCO2v7C3ZYzMpCE456KCv7yQ9mdJN6Yg55bVIKmFRnfSZSEs6iERp+MWad9At
	wKIw2z8neG31InFuoClQsBYyCV8QtcdcDaH+bXlHMg9BOVlZuK2FCBn7SzPCfGdpJUwZeNXRWhr
	mT8euQ5ky9/rn+85jcR39cIIH0Q3IkWCC2SQ1bPjCTpoyVLDynq3k28t+sR0Ja9//nppyCUAu8Z
	5cTsKxLf2j59m3aceIGNGcK3H0Fw6WOawXrHwKKOsS0VfV4PwqXNjdVjZWNOhH52LBabIeqaZDT
	2jrJLL06YdiUCq0NktDMrwMzkiEM6KTykbe7OAonyNh80OvrC+NeejZfJxxrhTLVQ==
X-Received: by 2002:a05:622a:2510:b0:535:a5fb:67f6 with SMTP id d75a77b69052e-556c1b5dfcamr59717031cf.66.1794439321370;
        Wed, 11 Nov 2026 15:22:01 -0800 (PST)
X-Received: by 2002:a05:622a:2510:b0:535:a5fb:67f6 with SMTP id d75a77b69052e-556c1b5dfcamr59716571cf.66.1794439320866;
        Wed, 11 Nov 2026 15:22:00 -0800 (PST)
Received: from [10.206.190.80] ([129.236.225.101])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef04d8d93sm57942026d6.17.2026.11.11.15.21.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 15:22:00 -0800 (PST)
Message-ID: <a87cbd92-0e07-4f84-9a6f-8db0b1778fcf@columbia.edu>
Date: Wed, 11 Nov 2026 18:21:59 -0500
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
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <42a60f57-5323-f981-8ef3-2e5d67623902@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA5MyBTYWx0ZWRfX8Y+W4n4OHKBR
 tyMKk1GqnA19GsQ+bFzFMNL5+IFM/o+zMRFwzWlNx/ZW61Ih31CbmdBrSDyexKvmBfmmQOo2fuG
 VtvIua32kd6ywNKbRnW245VIoTtyMa6v8GSMIZc2AjQGdaM9QxWsoOzxb0uLKDCz0kJf+TD6m4J
 3/5HRSRwuhCXl0tVYTOLjIkMGth3B9lsLK79MAxANtjsKCO2xqWVi7K3YjxVjxe8IQq7spEYMa4
 mZaqzmuyxi1B3ZJoXQ7nCku1zvS8Hs4kL0eCPg6rUEOfs1xUg2yA0V57OCc0ZByp3D4TADp88mz
 kODCAgBh8Rg1rJFnWsnDliGPduMljWo8FQUlZDKrV4BFOpZqVyPvdD0mRdgWhLwaxrUZVnwPWG3
 JXHavYygLgB3TxLihyT2dYeDGl7w+oKm6pF56gBaU56iG+fO2trV5zNSpNcGuU1IRcGfU0hkUyG
 NrUMF+4KlXnUQejkIVA==
X-Proofpoint-ORIG-GUID: pY7w9PBNCQ6p1FgiaNqQnrhTKidfMCfE
X-Proofpoint-GUID: pY7w9PBNCQ6p1FgiaNqQnrhTKidfMCfE
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA5MyBTYWx0ZWRfXyycb8PQWYW/t
 OvD9amRZwl24eY4Qkn9xss4DI3uYau+Zs5P3P67sBAxw6lZ6CKGxQm7qWEIIfZfo9rGH4vaGdiE
 HusMlmYamCHGrGOKiAsXnd5yZNsAHr7FHGFq+1OMwGx9Pghtpg9y
X-Authority-Analysis: v=2.4 cv=J9c/fwnS c=1 sm=1 tr=0 ts=6af4f899 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=F4ifJYvLC05xlQRgS51V4A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=VwQbUJbxAAAA:8 a=968KyxNXAAAA:8 a=oSZCGD4z_m2zKWX6BwUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 phishscore=0 lowpriorityscore=10
 clxscore=1015 suspectscore=0 adultscore=0 impostorscore=10 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110093
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 20970120006
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: zx54en4pwue39x4ca9hekntkj7jw1mew
X-Rspam-User: 
X-HE-Tag: 1794439322-957655
X-HE-Meta: U2FsdGVkX1/XCHDHptUrJNMqDeWoX711zcUvpTvyFty6lLOe7VCM8TOftkxmmXjiyKCkF9Y+wyIB4xYOave/spgT8QibVFFD0J5FJnLcAsLfao5KGQHkmp4TTM69A31Sw7UQpI3EF1p8Qsg6w4HJQUSz+9PMBebksPXj+I/rKOaQpHg10w6+eXKU/q2K4olo4cI6Bs8JWuHcdI4YL/UAbt1hw+CLKOZ0IKbRgFkBhUeUDsmsASJvx8QKyCtlc8rapkSkH+YGcLhqoJrvnkfVCb53YjW484nIvJ6h7uStRG8OB/bE/qxiVZ3ewoCAVkqBdG465k1SDXV3zSWd4Dr7K/XsB1XzZrN9+lRFHaMZ6m6Hsx/sbSu+edvkOA6ttdb+shSFdRBeMnEKJ3E/AVqfHu7MU+1qivn8Y0c7+Ze7FlW0vzZD9yqe3NHa6SSjTMDeXIwGvFHvM1z54zXcdWMVpIl48LyANmCaiJ3XsLIS8rso6iaD+lOH3D4ktQ8GDeS+f4dO5FzJHlbYwfBmjx8V7tcOKzasTVAvtcmeuKNrWQahLzDWmUWojlncU1dYTqTfQUAFlJW3y7SAOOWeOdeEaRlOrnFbbndAmiJZ/8poWCB0Q7ODP9NMF8aOC/T2sdxilaX3XXZbEKtof+Cmnntil0dkkJRqA8RWqNVLE/wMmo35VRSfRV6XM+X4uJmRmZ/Rm/mJh/QhM/Fo623PzAYIKHXZqNecIH0A31aqIIhzJQK6OVnQS31a/jrQSjugZXlY5MwwXwOpNrSODBdhrxWK0n+6dbsvDMCHIeA1rZEg4rWJAJWEC9IK51x/4t4egpPDnlkeaKib/Xgz3jisEuZjyXFPCpyusxqACMSqKg5Vb66CeKCAg0DKzzPikDwpX9BKmoT673Sb4WyzUahlmrPM0PpaQuxvo8NguRiT2VUegFZEQKP884f799AUA/ZJNLauwvnvE7KbbFpFmCuR8+o
 IXkmpEl7
 zqnyPHA4T9l0RMGu8k10o0ZcHkYQxgu/DCZpglUptwTCvxj8W0zVUThk23oYewXpnX5EngZP5I2VKZuZAHKYyL5wnF/Ur42Rwg5OcGTr8ovR+hAc+3zBQNHVggaosMHFvPKzZBRPIJLI3iQssruRN9Am4vou7hfHKBdao0FdQCMYGP6dCkC6FiyJ+DQxvC6jl95sV1w7BTxXTeQyHVl6izm96DdIUNycYjthAudiUWQ7vKgfzYCoawGIzPN4gLJa2hYsFpPAbel50NJB5WNO93bGD54QLPOEYaJWOkrBG3si0LdRXAXgDyGyfloa7vmfHgxHk5z2lxtmFhngNypjBqFOfXEL8DN/Uii5lSEKf+oZHM+CM+2ekd0jTniz2OYLVpP6krvdMEK0LxiNsRpocQJRdrIlkyq1ARz8yp70mxrUrzU5aedXh6e7IPEZVgWrmh7tbyG4MpyAXvLLu+w+st1CSJMivz1sNw/zejVHqg6SKkU/mHK7p+ELaYCvROsb4j08T28oWBEHBDwzpi4Kt8YYIAf/iifZuytgaoU7N1p+MQvQB9fIk2acACDsoGivjyZiLZM+M+bC0mWVz8BmaJcVNtMfBx2Ly5KTvVMXisX5xdI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 2:23 AM, Miaohe Lin wrote:
> I have no idea why the error on P itself is ignored, could you explain that?


My bad, I should have explained that.  By then P is part of a hugetlb
folio that's still free or being set up, so get_hwpoison_page() can't
take it and we just end with "Ignored".  Nothing marks the folio, so
the bad page goes back to the pool and gets handed out later.

If the folio is already in use it's even worse... it gets split as a
THP and hangs.  (That's a different race though, I'll send a separate 
fix for that soon.)
> I think we should clear the PageHWPoison flag we just set since the retry path expects
> we have cleared the PageHWPoison flag in the first round.


Agreed, as long as the page still isn't hugetlb.  Once it is, HVO may
have remapped its struct page, so the clear either hits the shared tail
page (read-only on e.g. 6.6) or gets lost while HVO copies the first
vmemmap page.

So how about clearing it under hugetlb_lock only if the page still isn't
hugetlb, and otherwise skipping the retry like the second round does?

> I suspect this won’t solve the problem. The below race might still exist:
> 
>    Task A (memory_failure)              Task B (nr_hugepages write)
>    get_huge_page_for_hwpoison()         alloc_fresh_hugetlb_folio()
>      /* P not hugetlb */                  /* P becomes a tail page */
>    clear_non_hugetlb_hwpoison
>    goto retry
>    get_huge_page_for_hwpoison()
>      /* P not hugetlb */
> 					 __folio_set_hugetlb
>                                           hugetlb_vmemmap_optimize_folio()
>                                             /* P's struct page now in
>                                                the shared tail page */
>    TestSetPageHWPoison(P)


I think that one's covered.  With the patch, the "not hugetlb" check and
TestSetPageHWPoison() are under the same hugetlb_lock, and
__folio_set_hugetlb() moves under hugetlb_lock too, before HVO.  So A
either sees P as hugetlb, or the flag lands in P's OWN struct page
before HVO gets to it.

Also, with Muchun's vmemmap_remap_rwsem [1] HVO waits for
get_huge_page_for_hwpoison() anyway, so if his series goes in first the
hugetlb.c part can go.

[1] 
https://lore.kernel.org/all/20261111093747.50048-2-songmuchun@bytedance.com/

Mani


