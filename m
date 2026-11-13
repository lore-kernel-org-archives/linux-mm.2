Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92014606A886
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=PCxJGX+C;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=c6pBSA9x
Received: by kanga.kvack.org (Postfix)
	id 880C26B05B4; Fri, 13 Nov 2026 15:55:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B366B05B5; Fri, 13 Nov 2026 15:55:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2976B05B6; Fri, 13 Nov 2026 15:55:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 405FE6B05B4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:55:50 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA5FD40198
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:55:49 +0000 (UTC)
X-FDA: 85431302418.06.E1B68E7
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 93DBD40005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:55:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=PCxJGX+C;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=c6pBSA9x;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794603347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftJY51c2OAWb/isSz9clJ9j210Y5VcK5eGTyPspyp80=;
	b=RhS6Y6Lciftl2fBBs2z5vuSBmooyo6+/V7S81iCya4mYvAExG2pKT5/GDatxoO40QPfXEw
	fb7N/4ETTm0e+PLoCTq686FLScVm9S8H9E9E6B6/1J1cLqdbYz3Ivcx35VpChWPKQx0mH4
	+OWF5Fkfx6eDwfknPv+NVOGjmyUUo+w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=PCxJGX+C;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=c6pBSA9x;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794603347;
	b=mRQD7uiYBhwqLtvAY9IaL+Q3J5Fv+grT/H0RTXMcIrkmQL3gtD1htgoVoZRqEEEhvt5v4W
	oEDhMdrm2lN5FX21Ukv3Xf75EixkNY+NfI4QdXasSPBKeul3F03TXkLAABWQnyxrQwb3d4
	iKiXAUS2gPJYZOowMN/u7gNH6Fcr0PA=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ADJYLk22439700
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:55:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ftJY
	51c2OAWb/isSz9clJ9j210Y5VcK5eGTyPspyp80=; b=PCxJGX+C5raartbiAyfs
	8bSbfri+K1DbGJEX3oYUj3jL1B/84Hw8Gu2AKaMVBOIskR+4kHTpcXXOYVbIWZxQ
	idQEIeOI+i2gq6Zu+bUdgea/qZOteEdOubltcpYZlAE3qKnTpMtMKfvgf7HPFq+G
	1mZYKBOpM+lzI9hPJGWrEkZzZKIDnYEzvd8SMt7NzNFpZaBTRY0Nc6/QH/qnaNqS
	4Sifws52/dbbi3agkCfK+E+KpTsYcxi/maAAAyW9+1yA3wHfysh49x+qbmcrz0c3
	FGrfChqrSK3UgCktrVeFDvLlpb207Nt5u4Z/QnBmEzw7qnKD1KJzYSIbSbOdsimh
	ig==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hx534jva9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:55:45 -0500 (EST)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-91f10c68ccbso35093456d6.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794603344; x=1795208144; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ftJY51c2OAWb/isSz9clJ9j210Y5VcK5eGTyPspyp80=;
        b=c6pBSA9xsf2yE3VE+KZ3zL1EU3M0s9r0qAlOg93PTNbEQg131DGeycpyvASHz2Xsnk
         3B2b5EGl57vJD/iBwpSIetJIxAqtP2ufnNCQvXw87rnkBAta4m8pANxXCn8NGfOX7s1B
         X0mmEOhQk1wNNS+nCWesIHCS6DfsIOHTGpPHmuDvC+gSA6Y0zrTsR+rGV6GMpKamc4lO
         n40c+csjCPmV15sN6P0ZOgW5b/08Q0d+VK3Yg1Wgd+XBW5KxpuiUVL/ZLf4UtdFN+24E
         NPCJLEYcwEDcXSL+5MTeBvOdVNe+RqhJmKqBttfIUabYCmJ4KqOZPylDmw6+0wqB7vYH
         sFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794603344; x=1795208144;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ftJY51c2OAWb/isSz9clJ9j210Y5VcK5eGTyPspyp80=;
        b=KVxGCxub3ChzOu26rCzsWRX/fyAYJtP74sdpNQCJd4ne3WTCwEzMwkR43sM3Z6T1ry
         ErOHn8Lp3UgJOjakDeQLMQcXwm31TYndeiNdjeNiZELXVh6tAt/FfT2mE9xFPRLjb79w
         DbjER6UTQdzGp2TzhqEVdN5BvoGP/jx62+JJXZYeiVJ8L6UMy5r2ddPyxF9M5ompnO5l
         FzUrDROfJDizJNm04sk/zgTOhR8fSeHBgfKRKwqIQBGY7FUlDnV4zSgKPnoPiWHza0TC
         qIfsVE/KuhSOCpWJrhl3OPVvk5b5wQnSYpTBY3hWJI+yFWj/H57brHtHEB1fOcSpRwvh
         3JYQ==
X-Forwarded-Encrypted: i=1; AL+hErG7SmeC3qRiUJppoL/v1STXnJuReXzPk+EJx5tZ5ARNgrJ6Ov2BRTPmFhZGgBlhvhcJ2ld3+JiY2g==@kvack.org
X-Gm-Message-State: APuU4Z9gSSs8ikfnfBaPMcP1au4XASCSR36aPvAIn490tT3aFrozRelS
	VFZNxy4ryU6Ho5WPQLZPep/yldZmt/5+kRl0PmzVnQgYUqxUlfL7L2QgPGu7/gq0sjn8U0fvQ3U
	bMJ0OCRg/7URSSu+T/AAP57RvpNpPgVP5Kw0bGeT5C6rJ/kqK
X-Gm-Gg: AYBFou1/5nH66sodXrlKeEMuwUvXSJV0pbLKgtq+agnr2p6SnQEQgamUAYX+Yw1Uacd
	0lmTc5flXM1w5f5GKBQB/9nu/8ElRNuHV1od0bjbHM19nTWlE23CUBVOxMjJP7Dj0uH/LEXlAWw
	bglrrYWaKX6Fu/23mJ/JFdRbWfDWnsG4X9IPo3iuu7YWhZzSIlIsQcVyJxc0KjRl6uGjaFUKYJF
	UvB6o1NWcD2+62CYHFjoa0hXkiFJpkcOcn3w02KjsEULGvNp6Cp+938iIHzrkYjjdfZsnYdVKlf
	izpTFKYr44fsALGP3TJ7ubW1Kg65KF5Nt3VJWtc+OuDuCS4mQo/h1fqye9Kz4nWRE1cFkXCju1w
	kqKD5TBnJ5tV1+xyu8OUJo1xqsLDf1qo2NbrYlvwADBH5C7BBAgZLMPHYtcTRRIzSMmAT9VvWjs
	1qUOSF4Lp9RBkE+JleTt8RknRIC+Y=
X-Received: by 2002:a05:6214:48b:b0:91f:2e33:771b with SMTP id 6a1803df08f44-91f2e337754mr31662656d6.10.1794603344126;
        Fri, 13 Nov 2026 12:55:44 -0800 (PST)
X-Received: by 2002:a05:6214:48b:b0:91f:2e33:771b with SMTP id 6a1803df08f44-91f2e337754mr31662226d6.10.1794603343465;
        Fri, 13 Nov 2026 12:55:43 -0800 (PST)
Received: from [10.207.116.169] (nat-128-59-178-153.net.columbia.edu. [128.59.178.153])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d70489sm28401346d6.21.2026.11.13.12.55.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 12:55:42 -0800 (PST)
Message-ID: <f53458fd-c268-4dfe-aa99-b050f63af728@columbia.edu>
Date: Fri, 13 Nov 2026 15:55:41 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: disallow guard region installation in
 uffd-armed VMAs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
        "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        stable@vger.kernel.org
References: <20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org>
 <0e3e876e-c3df-4660-ad89-a5f0fd7dedc8@kernel.org> <avcNcL6svEOTg_3r@gremlin>
 <0d6e29f8-54fc-427a-a979-1a8c6f4e3f06@kernel.org> <avdjMNNkOXm2khTW@gremlin>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <avdjMNNkOXm2khTW@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=dqFOmFg4 c=1 sm=1 tr=0 ts=6af77951 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=Y+j3KQtDOE8TDC6EXH/Ajw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=VwQbUJbxAAAA:8 a=H0umD5oqAAAA:8 a=OB121UNARqVzA2KAKi4A:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22 a=du2hvLAJtKcNxoDMbUSS:22
X-Proofpoint-ORIG-GUID: NORI7g2wc-voh8abEMk6LpyhUviw6gZJ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEzMDA4MyBTYWx0ZWRfX4leHORGaCpnu
 Gm9GoesfHaEhoBr4NZWVCCn/19n0TwwTA9LbTKcPXC6kYiVk9Iz8aUzBWsbHeiRmrA53GXP3zx0
 M2phKAo6t+reHZu7LpwzqdsN1VijurtiyN8/s4EA6VjV2qKOwnNy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEzMDA4MyBTYWx0ZWRfX00SjvBk+XsfZ
 uubccLdcDU6nNSEU5TMrJwjI+iDCQb+lcg59sukqvLV/Zs9UbIXz/dZuXRbNnvswj4l0DX101KI
 pQP9o1TkMfvvzrJLKl/9n4rJXl64ucj4DrzTsGfziPwzzzfdG1SkGwYn3IuI5OJWP43vh1xgqtf
 Ia82WYJ5bQHS/DJUkXCnmkbZ6ANuy6ozOddJIp7e1NKf3Du8BU6ZqbqOsvoQByxp3ayaK0iht+o
 Em5SDR6MzFPwOSyXX6zjAECxr3AK7y9PqmdASYTOR6mTacGVkTjjecul0ZIhK+x/NREq3GVQHgG
 2dtnyrn3mSAcPjjzv4/E86gYbOt+4l1ZLtxT/zQsi+YzC5gNjOusclA8gxhrv3hgv9QnwuCiEdd
 Q2xd4QkfSDxRKzn0t6HPXEDpsDLl2q+aKnHrMAsN/p6wM01npMcWAMr3hZDXcW8eaZXBCve87uz
 D9chwaB0jCiXm/NhRBQ==
X-Proofpoint-GUID: NORI7g2wc-voh8abEMk6LpyhUviw6gZJ
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11965
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 impostorscore=10 lowpriorityscore=10 clxscore=1015
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611130083
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 93DBD40005
X-Stat-Signature: ofdpytw4bj1kpw6kdxdxhpso3tb7zq5q
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794603346-736460
X-HE-Meta: U2FsdGVkX1+exowtCAbGvVVjMyIqfKmCsIOk486cj9QCVeiapVsyNpp2ZzmMP9S4xn3l5fq6rCIwUNPCKAtj6cQrKnSMuMhk5VOqM+G4N0m+zBlE4Ob58OF1Dyw2yN86tLTWnIn/WA+56da+ntWV4Qs+NMahWpzIpk1uSVQnnYF/3AHBxlDAQHziaxF+mvQEcZPxFyF3Ek45Js/JuJkSapsWQb2hSErVLFSn2dyycWJm9X7JbhM+beYu5rJr3ohP8akhW2eZKd1XgKl2ZynsLcM26k68G6+xOML/e2WGw2bYyH0ctjOz5DNSpPYS+P55J+0Sxgz+6wY5KcrGmN9ofu5LxIf2i2MNCv/wrYMW663jwlx+iJdmpc0ixN3dFlTJxytMiF3ruGN1He6pc0Mp0lTDC37r8MUuZQdQZIefO+2PcpLpMUbS8FwrQ+Sh0gHrUSLZQ1bTzoYnaIIWjei72hjvkKCePAHj2mWAx3GDrBcgcTEPnIzA/b73iW/WJKxMnpfknsAdyyJUu45JbG2lhLuFMgYRTZjHVNZx8ee/M0xsaQSCTqH2fVG2dPTrFBXcFDIgrWtROt7d7M0ucJuBScD/P7T6/ja/8ynInJrSjVPswWFBTgaH2XiNJy1+BD5qXVRKS3VF/iToLI/QEWvcUI3g98bWoyvYtEAMU3TZJvFqaCusio3iHcrsQpmZIPs1HgyfXzUpQBVb0CWI0kFe5KyHPgUAceyX0z50hq7y0foBLyRXCHFplPMz3JWapUDw3+68+ZWepquPgnnTvEb2V/EJ9T+t3aodDNlO4otGO/sHO8Ce3fJ5JwAupY0y8/z61n8u6ge8d+E7ndrF9yuAFzPhaJOKcBPHUq5uCsl5n+YgvAHgJnoJMSzq2OS0shqhaernySyM5297cRTv77/zJfE+FeFeA8eO52MSkRpwF80F+2R8XFZ3NnQAHiEgudxzImVEvFRb3jyne0JJSfd
 T0Y2ZvUP
 RyTGxUlKRSXvFXU905beyXzx2sFRgljPjyVV+X7Ng5IkG/eA3uuDczNzT+mj+qblcGx98xiIzNts+zVDtA62enq9jZebt/Hfj5kFcEiLanzqAdb+FHqoQ05DxgAq7gU62AkgsEUFbUd5MqO4V5k/7Reg6sRVWGXLa8odzOxP1xE83sIpVskgErD4xoYSbOckY37BeCTLSEF0TEtAzOJzVQ+hyEUDhCiSTJuK5xUBt/qcffuHdp3XF9mVvyox8NMp0k560W/y7mmrvPDminYaVfdUjjOUQXUYaIJJTYmlTNcgdxwHVvog/tP6rPHKeM76MQMmBcKDEMlBtAKqJk6yR6G/KRmNr69Swnb89pxWxYtEmsQB92CQcI8cfcCUe07YSvC9cStn3QsILTnJEvtApa+98pUVlWYGGMrVwKT9wKowElGEsmjf67b58PBs+YCe2Lymu134bnCV0j/9eYWspcv6J7lBFQcRs4gk6MfWhjgngfKiuIcWVI19yZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 2:22 PM, Lorenzo Stoakes (ARM) wrote:
> On Fri, Nov 13, 2026 at 08:15:34PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/13/26 14:59, Lorenzo Stoakes (ARM) wrote:
>> > On Fri, Nov 13, 2026 at 12:59:00AM +0100, David Hildenbrand (Arm) wrote:
>> >> On 11/12/26 18:38, Lorenzo Stoakes (ARM) wrote:
>> >>> In order to establish guard regions, guard markers are installed in the
>> >>> page tables of a mapped VMA.
>> >>>
>> >>> However, problems arise when one tries to combine this with registering a
>> >>> VMA for userfaultfd, as such operations may themselves need to install page
>> >>> table markers such as uffd-wp.
>> >>
>> >> How does this interact with UFFDIO_POISON markers that can outlive even
>> >> userfaultfd registration?
>> >
>> > The zap clears poison markers, as is standard. It's really horrible this logic.
>> >
>> > So the code path for zap used by the guard install (via zap_vma_range()) is:
>> >
>> > zap_vma_range()
>> >   -> zap_vma_range_batched() with NULL zap_details
>> >     -> __zap_vma_range()
>> >       -> zap_p4d_range()
>> >         ...
>> >         -> zap_pte_range()
>> >           -> do_zap_pte_range()
>> >             -> zap_nonpresent_ptes()
>> >
>> > And zap_details is NULL.
>> > > In zap_non_present_ptes():
>> >
>> > 	...
>> > 	} else if (softleaf_is_uffd_wp_marker(entry)) {
>> > 		if (... !zap_drop_markers(details))
>> > 			return 1;
>> > 	} else if (softleaf_is_guard_marker(entry)) {
>> > 		...
>> > 		if (!zap_drop_markers(details))
>> > 			return 1;
>> > 	} else if (softleaf_is_hwpoison(entry) ||
>> > 		   softleaf_is_poison_marker(entry)) {
>> > 		if (!should_zap_cows(details))
>> > 			return 1;
>> > 	} ...
>> >
>> > And zap_drop_markers() checks zap_details && zap_details->flags &
>> > ZAP_FLAG_DROP_MARKER.
>>
>> Right, my intuition tells me to just nuke that thing by setting
>> ZAP_FLAG_DROP_MARKER.
>>
>> MADV_GUARD, is just like munmap() another form of "zap it all and protect it".
>> >>> This is especially problematic because guard region installation causes the
>> >>> regions to be zapped first, meaning that the removal of userfaultfd-tracked
>> >>> ranges will not be logged in this case.
>> >>
>> >> Again, similar to trying to uffd-wp-protect'ing a hwpoison marker (which will be
>> >> ignored), and then zapping that.
>> >>
>> >> Isn't guard marker installation/removal just another form of zapping?
>> >
>> > I mean users being weird could decide to use it for that rather than
>> > MADV_DONTNEED, but zapping is a side effect really.
>> >
>> > Really the idea is that you might have users who, for whatever reason,
>> > faulted in some range, and now want to make that a guard range, so for
>> > convenience we zap it for them :)
>>
>> I think not just convenience. There was this problem with faultaround / THP
>> placement IIRC ...
>>
>> I'd just zap everything that's there. That's literally what the user asked for.
>>
>> >
>> >>
>> >> So to me this all sounds like "if user space does something stupid, it's user
>> >> space's fault".
>> >
>> > Unfortunately, as per Tal's series, there's more to it than that (linked in
>> > Closes: tags).
>> >
>> > You can get an infinite syscall restart (ugh) if you do this on a shmem
>> > range (Tal's 9/12) so it's a kernel bug that _has_ to be fixed.
>> >
>> > The other bits are just about a user losing track of uffd stuff if they
>> > guard/unguard, as you say.
>> >
>> > But every other zap code path does the uffd remove event stuff, so this is
>> > still an exception.
>> >
>> > If you support uffd, you have to add a whole bunch of horrifying, awful,
>> > terrible open-coded uffd crap, e.g. the userfaultfd_remove() etc. And you
>> > have to drop the bloody lock and reacquire it too and make sure all that
>> > works correctly (...!)
>> >
>> > Anyway there's basically 3 options here:
>> >
>> > 1. do something like what Tal's series does - add a TON of complexity for a
>> >    use case that nobody uses to get behaviour on something nobody sane
>> >    should care about (i.e. uffd/guard/unguard/expect uffd correctness).
>> >
>> > 2. Zap with ZAP_FLAG_DROP_MARKER, and silently lose uffd-wp state but
>> >   'support' uffd. It does fix the 9/12 bug but then subtly breaks uffd.
>>
>> Right, that's what I would do.
>>
>> MADV_GUARD_INSTALL zaps everything.
>>
>> It already zaps swap entries, migration entries, hwpoison entries ... so just
>> zap everything.
>>
>> [...]
>>
>> >
>> > If you're really concerned though, we could go with option 2, which will
>> > just make UFFD behave differently for guard regions.
>> >
>>
>> Not really concerned, it's just the most consistent one for me. Zap everything.
>> The user asks for it, like he would ask with munmap().
>>
>> > (I regret, obviously, ever allowing this for uffd ranges. And we _all_
>> >  regret that uffd was _ever_ allowed to be merged in this state...)
>> Yeah ...
> 
> Ack will send a v2 doing that then :)
> 
This sounds better to me. My concern in [1] with completely disabling this
was that it could break a uffd manager that doesn't control the task it
manages (e.g. CRIU lazy restore registering the memory of a task whose libc
uses guard regions), but this should avoid that.

This still leaves guard installation as the one zap path that doesn't send
a UFFD_EVENT_REMOVE notification, but for CRIU I think that's fine, since
guards would mostly go on memory that didn't have contents beforehand, so
there's no stale contents to restore.

I could imagine this mattering for something like a userspace far-memory
library [2] that registers a heap with uffd MISSING mode. If the allocator
guards a page that the library has paged out, the library is never told
to drop its copy, and fills the page with the old contents once the guard
is removed.

I don't think anything does this today, so it's not worth adding the event,
but I think this limitation should definitely be documented (i.e., that
MADV_GUARD_INSTALL discards the range and uffd state without notifying uffd)
for the sake of the poor souls that work with uffd and to prevent any
spurious LLM reports in the future...

[1] https://lore.kernel.org/linux-mm/f76cb2b0-0090-4554-9169-5cfff6a6ca53@columbia.edu/
[2] https://www.usenix.org/system/files/nsdi25-yelam.pdf

