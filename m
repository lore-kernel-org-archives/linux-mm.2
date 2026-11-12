Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D60C7606A88E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=U+/4y+pU;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=ZdaTLB29
Received: by kanga.kvack.org (Postfix)
	id 01AA06B05B2; Thu, 12 Nov 2026 11:06:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DFB6B05B3; Thu, 12 Nov 2026 11:06:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF2D6B05B4; Thu, 12 Nov 2026 11:06:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B34C66B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:06:31 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57E55A80E8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:06:31 +0000 (UTC)
X-FDA: 85426944582.20.A9E0DA2
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 88C24180003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:06:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="U+/4y+pU";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ZdaTLB29;
	spf=pass (imf24.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794499588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/0yD8XwSZcMtPhKjxGvWxzhalMi4P0RN9zUgkplp3I=;
	b=oAY66XRJVJ5B1tfF4vTk6mTMKawZRR1rxWDKj9yHU3aZviG8srusK955CA9S8CNl6+g92R
	HnvUkn4I1D5+9P7IosvEXxGqQUqv8ywXCOijMNFPJ29ZYV+gFeDbSHmL5aOMKH3eWlZdZo
	a3yVqrpS5M4+u085isEj9XyVk5nori0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794499589;
	b=dGMAMqjG6h5P0rhCxuHm92L290mtAtnRhXedRlFYS5wo93IorcgyAMhWFu8B4s+bqxbbEj
	qYVwOf21JkbqH5p8yUuk1aYl8CrcQuq+GwSmLTeM8GuwKULirKhXzzV70swZg4Z+bM/QZq
	fCz/oF95ILPb2HpwiJXlPAOHkjvPWF8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="U+/4y+pU";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ZdaTLB29;
	spf=pass (imf24.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACFXpgV3622103
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:06:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=s/0y
	D8XwSZcMtPhKjxGvWxzhalMi4P0RN9zUgkplp3I=; b=U+/4y+pUkpfDAQFmeZ09
	BltQvCuaL59sr8VUmfUen3PJ8cTOac6eFO5dnCQiTwzplouLPAndcc8p4GIexEQK
	UJEcEcyMBDEzf5xhAwPSz7lO9RgN8BuMgBrQaQimDgBX0pGy6s0UqUQjhJ9NpZ2k
	ukrOYbxDXqyaGOqG5VVhWnklyNWT7rOrQgV46051NXipQHgGh3B9ngiuDILR2TpQ
	IBU6hkSfwvdYT9RG5nihfk3romNw4nySl2w4ECXSy+lMqpqHDilTS2YPBgC/PnK7
	bwzf5oVzpQCMvwHWtZCXM2DNgHMqdX4sk6ewMRCSTtbAviLTewgSO4PenXDbRkHz
	Qw==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hw0vjmxkf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:06:26 -0500 (EST)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91b937ecbb4so83460586d6.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794499585; x=1795104385; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s/0yD8XwSZcMtPhKjxGvWxzhalMi4P0RN9zUgkplp3I=;
        b=ZdaTLB29WxmD2n1L06Q3xarf+Us7/cLgX9aexhbL152SVHI/BqsL3MDIBzT9F1Wlr1
         2LMgPfvyjvf2igZ8q5hb6hmGKzvPRI/LRgvsw/MkEe4olYSVkd4WCUGrXbgYNmRzjqYZ
         e4A6KSXjlZxHA6p21wJz3nxa2Nv/+D7+EPmMMhHhifd9kMXddaeBh2R0Qd2//sYdCa8B
         BbdQ4xhDmxlRFVG9+eLhJNwgRoxw060xDffqnInsjRthdkk1FkBnll2ltKkyPtuq5Vuf
         B9/5Z4K3yt34sQ/+mhUbMXgeON2BqA03XHRAzGYp5VJkMk9SqmlcTeRnXvx0RTzToea3
         JlLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794499586; x=1795104386;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s/0yD8XwSZcMtPhKjxGvWxzhalMi4P0RN9zUgkplp3I=;
        b=OTumAmYwqH+BH+kYi6Orwm7W23bhT0cWN9crZA+fSt22fp6vym2FsgDv5y8rpPyN3Z
         3v9xM74st6uCqS1arg9BhIqmGMLiKXLCQJufjIwOXnbed6j5Qf4NW8ZPsTnIxVSJbGhN
         5EOv4khByukhTm+TZ1mDv/uyd9aO9f8w7XXrOvPLavj6O4J+FeN97TvV6hZXPEFLFQf4
         fK65eyzUvVyKSBNjCZU+ax7FyEqUfDaZtj0CZozLVOxF8VyFrhzJwNyDRxsjbDJTnTnA
         yFZQfdkcoTh9usV1CYj5Bvp75klyZBliArmimi3+Dbm1IJfAqSnaF2huJ2FoWOt4T/q4
         nKjw==
X-Forwarded-Encrypted: i=1; AL+hErE5fzdy2iMFWAd5y7lC2OiK9S0A20Sqok0pAivkGjf3w4od6P/XvL02eC5RC99yVZrZgggrM4bDYw==@kvack.org
X-Gm-Message-State: APuU4Z++C7VnsM77ckf8XR1tViA2zb8ZWzn8cpn+P8oaT27USX48a5t+
	pdTRPHVje/VNxNC0ZRHjuNFZkwc+S4QPye+6YyGfRBn1xA5uIcIxwrOZwLZIv7C7lSDtNZ8/wGF
	E+qi3tj7995lqtV4R495MsYs52QLDbIbYdL2HAHSsctun4rny
X-Gm-Gg: AYBFou2vYn4X7qjNYwLA9cCMfxsr3v6cprPlYsPO14ZnSiPNBbbvuZSdLfPKOamOS3/
	ugFw5JQlQnCa9Tk6k2USHw1xnysZUKlHv5XsvH+Y3lhs03Hcv7hhrn1SFZcJ9li+kMoXf7D9gnx
	gv+OpGShHcy+DxUSacqFbqvDT2IhSEazn017OR1Y5Jk0L0PktLnWTr+j5ncDn+V/85Hu78FQ4a6
	QSpBGDlI+w7tSDpwd9w9+J0i6E0rnP9iD/QmekBo8ttfRGug9mmFA8J6Z9fIEjjAYJ4LpRcOxe3
	+FC+FjAUEw5aa6QznNNicakE5ROziYZ+3qhaX9+/aJPLwKW7VMAalarWu3Y90Yag9vrE/RTAn2b
	hswRTeL6579jGNnfGh2oLnJKMKrLx6IUMcRy8Q5ZXiv7EBt7VRqY4CCVCRjl4QMSsLRI6/1h+il
	n+2DUoONOQgz55WUgErYY1ig==
X-Received: by 2002:a05:6214:1d21:b0:91e:9db6:c329 with SMTP id 6a1803df08f44-91f0414665bmr103300206d6.35.1794499583663;
        Thu, 12 Nov 2026 08:06:23 -0800 (PST)
X-Received: by 2002:a05:6214:1d21:b0:91e:9db6:c329 with SMTP id 6a1803df08f44-91f0414665bmr103297826d6.35.1794499581900;
        Thu, 12 Nov 2026 08:06:21 -0800 (PST)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef04fb371sm75358026d6.25.2026.11.12.08.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 08:06:21 -0800 (PST)
Message-ID: <e0a9ef1a-c24b-44a8-9d63-9a800b35da24@columbia.edu>
Date: Thu, 12 Nov 2026 11:06:20 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/12] mm/madvise: let a guard marker carry the uffd-wp
 bit
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
 <20261111-uffd-state-fixes-v1-9-00713d368976@columbia.edu>
 <avWeNRMIU2QPGZ4w@gremlin>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <avWeNRMIU2QPGZ4w@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=d9FgWhjE c=1 sm=1 tr=0 ts=6af5e402 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=iDqOqAWsPJ7IfU34PtYA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: XycFdp_BD2TRGPbVevzklpcZ5jlOaN_a
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA2NCBTYWx0ZWRfX+QtaS3098bXP
 5ArKWqk+rdd+zTXKMa/fxhrimbzHc1wxXrfA3XjRazGZBOIAikLdIgWSk3d4hiiK4hmK4wfot31
 EF8wxsRYzXnDgB7+DxYhMI0y14guwbvL/nMvhnoPC3BFT+jui36F
X-Proofpoint-GUID: XycFdp_BD2TRGPbVevzklpcZ5jlOaN_a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA2NCBTYWx0ZWRfX7R3ILsw2NTXR
 DOaK6G9zT6Z3R80f18US+yfg9WnFZSQbnmoLIVPyZCVZv/KHdXW7T+l8l7dSXgJaFAdvxFbMvti
 MafXc+aAAgsKFXae/MHft3Sshh81Mc6YUM27CeYzheACqKZtRjKdvYLHLg10KskFROXAIDVobjB
 Id9KFTdpoZCttlOI0QNyI3vzFrBEd2IkdrpJvnrOmgvWaYNhJBHJEOuZVrFo7CWeZ4NXyFjGz3w
 H2j+/KVGtifBrHMt26+nTyFwBsyGP8J12R9Z1mpgRKzLAelHLpWPOwdT3752boVcHa8zJYcSSb/
 ixlVwFdylOsRJ+jp/OtNCGO5cpA9QOLEKYOPvHUcukxtJhWtjIWQi442HDLhKI/+YERbsDGr2Na
 Nzg7lOnqujFBuyggfx7buXdo1QLDv9ETawn0ZnLDko098QHA+lT9VyHk/HX9oBFzzTUkNtl1wkg
 UZROXeS8HeKTekC8DnA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11964
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 impostorscore=10 malwarescore=0 priorityscore=1501
 suspectscore=0 spamscore=0 phishscore=0 adultscore=0 bulkscore=10
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611120064
X-Rspamd-Server: rspam06
X-Stat-Signature: wwyoaecp64xwns3h6qobgc1wemjuebny
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 88C24180003
X-Rspam-User: 
X-HE-Tag: 1794499588-859270
X-HE-Meta: U2FsdGVkX19SxBVzsbuZ6L8h2mZaJmq+FZm9FbBEUErZVsX4qOIPvvhy9zJ0XeNFKIkRhGeB/7LqHO16HsLmBKooh12vfXjLi9uaqu0qCccGe6GGExkhd91PG5t6vlFdcGg9QOATTqR4puBGHZI71rfdZq9bV9DvjM2bI2tSCKAF9PaOPr44riB+LjAGhLKgOZQhJ55jY+S1X2CavLkjKiUfzAI1GkeQN5hsk2o0r30peNMQ80iwZeVCmrypg99IRwdGGmEzWoo6FSbRpIgF52at180koMgwreFP68o+2H4DWkO7i1xw7LuEaYPV3V5f+B6S6MyeV3mNQy8hmQK/WnYGpyFhYvoFTFtBWby1FNPZ39H7ranC7Nzb/0u3LAeevrKOoV5WoUuUYSuI6bDMxvshwxH7fkoccgBus2/7E09JXUcZ9DkNnTSXVKSG5ccZVzV1TqCv+abdEAu10Qo3CCKcFiSyj+pvOmQO5ESadApmpaQA00ttJsZMyoLyBIYrkTe3OP02l2Gpw5jO3wteFRyG8AsasDfn4Vzz3DnvAk+iec4fpkp64tOovYKeTKE3bu/PpcQgHokI93/ZtFIX4h57YeiZYdy/+ceWwv/WVS/rH96Jbcq67LPtXYpnAKmAWY0//99a16L1BnhS5cSbWctU8PK3CPL1qHiizxiEH4Q5PZykZiEorXAcWMrIXodXjmPON41s+VfZQL0gxTKXaM+iJY7RPyyAqC4pROn7uC5hoHZkcrNcOKca0jvDeVoT6eQuV9sYI05MorcDtNDp0rz2gN28uayPE79jDVTukcXY4Lm3ZxIiF5kbyvCBtloJpdd2zStjWPoaf/830zi94LSHZPT8V5QlDR/gHmo+ThpVXDtIght7WWIvPmVHuwegfqdZK9AuAV1U9m67AJYeUbc8QJK4mle5MmTywbalMjVpvhnJ1jdukUw5yCv3uLa4aYn1rM0eVnaQ04p3MgA
 ciFk3qjr
 rdF4+WVBzqVbAzutWa6Zb6D6uHf5fSz317RQl+S4xaVhYFBUN5g7YLyh6hbTRq60Yufb04JSnqxC/M0LDow+hFTK+BO9rYsDlp6N2oMUEgZdU9AcBs1Up8dl6Ox/vG/oLFb9l3wFOiIYM2jXT91ZnP9hyQ4GmxYFOaLAApmDQvZ6tMBmEnNIGbktmT+mY5HQJMx99qLH+2mGzKgFe8bmhs4EzQNqzqYcKyFQMpIb1I4tdW4kSr6TYfzVUO5OO8TSFQIYAhKu25Rjxtr9QCxXTt3en/vKzzK+yl/xQ4TgZ2IKB8Dv2povDSR/BKdEzLu0zK1AeHJBQJ/otyTkLBfhMBY29OLqmcpalVG+V+uJA/oZau4NR5A5T3JePgg9lgIVpK2FHAaRavsuhRUJdl+SyKGY8aTwNlSgBWe7dHdCafylyah3K5dQNUzTbrtt/mXdoSne+5Mg5dGygVKGOVlWrsmLjDYqC5LxHrOdqEAFdjNweh9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 6:21 AM, Lorenzo Stoakes (ARM) wrote:
> On Wed, Nov 11, 2026 at 12:55:17PM -0500, Tal Zussman wrote:
>> MADV_GUARD_INSTALL can only install guard markers in a range without
>> populated entries. It zaps the range and retries, restarting the syscall
>> if the range still isn't clear. On a file-backed VMA registered for
>> uffd-wp, the zap keeps uffd-wp markers and converts write-protected PTEs
>> into new markers, as the pages are still in the page cache and must stay
>> write-protected. The range never becomes clear, and installing a guard
>> region in write-protected shmem keeps restarting the madvise() call.
>> Signal handlers still run, but the call does not return until the task
>> is killed.
>>
>> An entry that is write-protected must stay write-protected while a guard
>> is installed on it and after the guard is removed. PTE markers are a bit
>> mask, so a marker can be a guard marker and a uffd-wp marker at the same
>> time. To fix it, let a guard marker carry the uffd-wp bit:
>>
>>  - guard install adds the guard bit to an existing uffd-wp marker
>>  - guard removal clears only the guard bit
>>  - unprotecting or unregistering clears the uffd-wp bit of a guard
>>    marker
>>
>> The fault path, zap, fork, and pagemap already handle a marker with both
>> bits set. However, pte_is_uffd_marker() would let UFFDIO_COPY overwrite
>> the guard, so make it ignore guard markers. Anonymous VMAs drop uffd-wp
>> markers on zap and never get the combined marker.
>>
>> MADV_GUARD_INSTALL on a uffd-wp shmem range now succeeds instead of
>> hanging. When the guard region is removed again, its pages are still
>> write-protected. While the guard is in place, pagemap reports both
>> PM_GUARD_REGION and PM_UFFD_WP for them.
>>
>> There are two simpler alternatives, but neither works. Zapping with
>> ZAP_FLAG_DROP_MARKER fixes the hang but drops the write protection: the
>> page is still in the page cache once the guard is removed, and writes to
>> it are not reported. Refusing guard install on uffd-wp file VMAs in
>> is_valid_guard_vma() would break a combination that works on anonymous
>> memory, by adding a new -EINVAL for it.
>>
>> Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> Please drop this patch too.
> 
> With my patch disallowing guard marker install on uffd-armed VMAs this goes
> away (and doesn't make sense anyway.)
> 
> I really feel these guard region ones should have been sent separately, btw.
> 
> You're establishing a bunch of interlocking dependencies of different changes in
> this series that makes life hard for reviewers, especially given backports etc.
> 
> And now I'm having to essentially inverse cherry pick stuff :)
> 

Sorry about that. These started off as one fix and then grew a couple more on
further rounds of AI review...

I'll drop this and the other two guard patches.

>> ---
>>  include/linux/leafops.h |  4 ++++
>>  mm/madvise.c            | 28 ++++++++++++++++++++++++++--
>>  mm/mprotect.c           | 23 +++++++++++++++++++++--
>>  3 files changed, 51 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
>> index 4c1476ae3234..add4968ded44 100644
>> --- a/include/linux/leafops.h
>> +++ b/include/linux/leafops.h
>> @@ -578,6 +578,10 @@ static inline bool pte_is_uffd_marker(pte_t pte)
>>  	if (!softleaf_is_marker(entry))
>>  		return false;
>>
>> +	/* A guard marker stays a guard, even with the uffd-wp bit set. */
>> +	if (softleaf_is_guard_marker(entry))
>> +		return false;
>> +
>>  	/* UFFD WP, poisoned swap entries are UFFD-handled. */
>>  	if (softleaf_is_uffd_wp_marker(entry))
>>  		return true;
>> diff --git a/mm/madvise.c b/mm/madvise.c
>> index 0214efd2a014..e2c6b0f26672 100644
>> --- a/mm/madvise.c
>> +++ b/mm/madvise.c
>> @@ -1123,6 +1123,23 @@ static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
>>  		return 0;
>>  	}
>>
>> +	/*
>> +	 * Zapping keeps uffd-wp markers on file-backed VMAs, so add the guard
>> +	 * to the marker instead. The slot stays write-protected once the guard
>> +	 * is removed.
>> +	 */
>> +	if (!vma_is_anonymous(walk->vma) && pte_is_uffd_wp_marker(pteval)) {
>> +		const softleaf_t entry = softleaf_from_pte(pteval);
>> +
>> +		set_pte_at(walk->mm, addr, pte,
>> +			   make_pte_marker(softleaf_to_marker(entry) |
>> +					   PTE_MARKER_GUARD));
>> +		update_mmu_cache(walk->vma, addr, pte);
>> +		(*nr_pages)++;
>> +
>> +		return 0;
>> +	}
>> +
>>  	/* If populated return >0 so we abort the operation + zap. */
>>  	return 1;
>>  }
>> @@ -1259,8 +1276,15 @@ static int guard_remove_pte_entry(pte_t *pte, unsigned long addr,
>>  	pte_t ptent = ptep_get(pte);
>>
>>  	if (is_guard_pte_marker(ptent)) {
>> -		/* Simply clear the PTE marker. */
>> -		pte_clear(walk->mm, addr, pte);
>> +		const softleaf_t entry = softleaf_from_pte(ptent);
>> +		const pte_marker marker = softleaf_to_marker(entry) &
>> +					  ~PTE_MARKER_GUARD;
>> +
>> +		/* Clear the guard bit and keep the uffd-wp bit, if set. */
>> +		if (marker)
>> +			set_pte_at(walk->mm, addr, pte, make_pte_marker(marker));
>> +		else
>> +			pte_clear(walk->mm, addr, pte);
>>  		update_mmu_cache(walk->vma, addr, pte);
>>  	}
>>
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index ef4e7188e24d..6cc5b99b4185 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -249,9 +249,28 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
>>  		 * because any access should sigbus/sigsegv
>>  		 * anyway.
>>  		 */
>> -		if (softleaf_is_poison_marker(entry) ||
>> -		    softleaf_is_guard_marker(entry))
>> +		if (softleaf_is_poison_marker(entry))
>>  			return 0;
>> +
>> +		/*
>> +		 * A guard marker on a file-backed VMA carries the
>> +		 * uffd-wp state of the slot for when the guard is
>> +		 * removed.
>> +		 */
>> +		if (softleaf_is_guard_marker(entry)) {
>> +			const pte_marker old = softleaf_to_marker(entry);
>> +			pte_marker marker = old;
>> +
>> +			if (uffd_prot_resolve)
>> +				marker &= ~PTE_MARKER_UFFD_WP;
>> +
>> +			if (marker == old)
>> +				return 0;
>> +			set_pte_at(vma->vm_mm, addr, pte,
>> +				   make_pte_marker(marker));
>> +			return 1;
>> +		}
>> +
>>  		/*
>>  		 * If this is uffd-wp pte marker and we'd like
>>  		 * to unprotect it, drop it; the next page
>>
>> --
>> 2.39.5
>>
> 
> --
> Cheers, Lorenzo
> 


