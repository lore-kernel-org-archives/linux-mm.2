Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A5F606A322
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 19:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=aiqJE3oT;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=oujJjss5
Received: by kanga.kvack.org (Postfix)
	id 585D56B00EF; Mon, 16 Nov 2026 14:16:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F816B05BC; Mon, 16 Nov 2026 14:16:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389126B05BD; Mon, 16 Nov 2026 14:16:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7BD6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:16:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D3C0404DB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:16:49 +0000 (UTC)
X-FDA: 85441939338.20.EAF37F8
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id C21C912000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:16:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=aiqJE3oT;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=oujJjss5;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf29.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794856607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5HgnCAHduXh9UgqrRv/0lyqCC3PeAkYFEaq2vgb4eY=;
	b=v1SP9sqLd3v3n9VmMatYOI/u1VivQsno1myIThbKiTjxprun+fqZTP9piqemekY3iawWnG
	DEOf6br3XwbI49Oks5oTBHkyK+AhMwujBlnU2OZLwY0vIs9sBUMULtlBd8ldZr270rCFGd
	LS/lpfr2g34a+5+ldxD6riqD/xw5L8o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=aiqJE3oT;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=oujJjss5;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf29.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794856607;
	b=AfEK7r9BqLJoG9lTK4k9XvofgzQlEpWqn2a3qXSAA7yWsRKhBTAcYhM8Fr2sqcneOll8SN
	zkHFfJ1AwHcd/fJ/9cFiznB9s8S+K7L06TmNLTThRYWxSQDI8+gdyggWr1zPn0e+VQ9069
	kcqbbDoPsPUKh8tyMT94D+ldCo3Y9GI=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGHhQqo3200239
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:16:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=P5Hg
	nCAHduXh9UgqrRv/0lyqCC3PeAkYFEaq2vgb4eY=; b=aiqJE3oT4WLEpnGKlDw5
	6nU9q12AZh4AhxbLBellCSSNW7OIJRcJRo7ky6nYY5brJbA4jXMEEQVDfv6sW158
	QHmvam8UOoFJSKT9yyquvDKWXlJPfUuYRznxG7c6Hv3U6ssracVVa49/PplCb/wk
	Ts3jh+b+rmXwnCeLS0W3cbbI7Zc0w3zq0fbD1oiKhYUtIuWnn/bZSucH9CMKwo8D
	kuMalFon03A7MQKqMmZVyBsqKn4cxhmeZSdPLP0cjI085X8byI+EJDSPVse/epc3
	8kcanZhcTJgRsq2z+NAVxWBWB09uerq6pYchs49IGtt8Agq3/8cScxHGeY3WO6yX
	9g==
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j05989m5q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:16:45 -0500 (EST)
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-8b35b88aa94so56287057b3.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794856605; x=1795461405; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P5HgnCAHduXh9UgqrRv/0lyqCC3PeAkYFEaq2vgb4eY=;
        b=oujJjss5dHYi0lpy6cRZXQ/2IK50ntGlP90JrpqtzJGeXrfSwkxB779NVWSDBwp4d+
         dGevDJpAV1Q84fb3jXcM8IusjWfyTYQkcfukd6gEBEzVoTT5Gbw9kM9GlULI8V6A/Mhv
         5x4gRKtpznqseAqWcGSBolcvq9fG7IAhJXAjla9mcIUFAdOwSUkoz6y4l5p38pwrWtXp
         GXr4YD3pdbB0uDVDesvRpaLdxsC3QyLweymxIdVtNFjtV+tyF6wVIY8PkpgGzokAMxFy
         PYJ9IHoGW1dFnt0ivOmEJzxwfvUzYkCecAezFX7VdNYZJjz95QuHPScoXVHJ22muuLkq
         l++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794856605; x=1795461405;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P5HgnCAHduXh9UgqrRv/0lyqCC3PeAkYFEaq2vgb4eY=;
        b=zOByhBdXFIi9a2m2CL8YvfuiXh2GK5YzOIecxAHLWdk3wHjHYVRw9rK4qu4ReICkxE
         //ZkSqepGnEKvC9MY92J9fAWeU1SbKDrLPVbunPskq04RLy1GVzH3R85VIXTMSit2Go6
         OWlg4zdMM6piNJX8JlHQ2n8E5V+aDgtyRXe1rBXJG0XTzSUeUfxT7WiRA4Lk+fSp4tw9
         c0DPUU5sxQJPkd0+M+C0Ha1a45Nh3gSKTK5tniI0VpwHtptHMtLt86GvbqN3qsVhZxFl
         TNMCtq6vGuCJ3hQ+tiWiwgtEwe+O0z+BoV7stceIgMUeg3B2SVbvjHL62TgKbTtTaYld
         CSvw==
X-Forwarded-Encrypted: i=1; AL+hErEhhpsvqn12sR9ppNvZjkDNIaa8zd0EL7rql5rB/Tf23X6IyVGtWRMTuOgAiGvRLqvgfGMjgyEw2w==@kvack.org
X-Gm-Message-State: APuU4Z/e/FZh6NtO+0Yr0mZ088anqMbdYI56tIAOb8yU/Bb3ObSd21ut
	0bmvaP/krnSMmEljK7cvDOaZMckFSraOXZkvHRD4k/hKvDUTpCYrIvqSMh9P3Bneh22QW0WGqxi
	aWYEMt4cV98lyQe+Oy4NrPZ+EXPuiKbIj8jgU9YSJOoXXavJ2
X-Gm-Gg: AZFdTZfAM9L40j8Q3lY1sqLBp2GgoBYXdHiRnM1iVGb5n86GPFjTqZLhdgBlnI9DsnO
	MSccYBqhjTGOzfVeQs9OFLdRr6uSbDwOvi7g5RpkDSHQjfSoxVxXImh7kU+B0dK0zErjqA9XUJZ
	9J99mDiMlRYNAnyfGSErW0wNt0GLDz7fcwZQvLIKdH33Um0nYcI4cri+pObr5FBnYin1lNZso9i
	y7lEQGJt76QX9LjTb6mOI7MY6CkbyzZVJTxA5xRyZfRDils0ru+vSHcW/pLLMf2cS84LZxV/TtI
	4zFNNTTj3RVC+0W2i37qXd40WXrX1SWbmVI7HYWMrhfAx49Aek7pc+5jktB2yyNUjeqBPnlokr8
	b5jFkWAMgvlP3LtfinW9ARW+kJYWMafQgAE8D0ccUUAOjeoFaXU69bM/JvbbP1dWQ79OiZqyr2X
	uoBJ6bBuMrPUtoqW449whawBeg
X-Received: by 2002:a05:690c:a089:20b0:8b3:27b8:2bbb with SMTP id 00721157ae682-8b4ee00e3dfmr1847027b3.100.1794856604855;
        Mon, 16 Nov 2026 11:16:44 -0800 (PST)
X-Received: by 2002:a05:690c:a089:20b0:8b3:27b8:2bbb with SMTP id 00721157ae682-8b4ee00e3dfmr1846937b3.100.1794856604435;
        Mon, 16 Nov 2026 11:16:44 -0800 (PST)
Received: from [10.207.2.125] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4ec4d377csm6303207b3.40.2026.11.16.11.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 11:16:43 -0800 (PST)
Message-ID: <032839a7-ae22-43aa-a065-c7e9aeabdb8b@columbia.edu>
Date: Mon, 16 Nov 2026 14:16:42 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/12] mm/migrate_device: do not migrate a uffd-protected
 zero page
To: Alistair Popple <apopple@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?=
 <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>,
        Ying Huang <ying.huang@linux.alibaba.com>,
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
 <20261111-uffd-state-fixes-v1-8-00713d368976@columbia.edu>
 <179454988585.482102.2051616940227067987.b4-reply@b4>
 <c3a51a9c-083d-4c76-9a62-b7a6fe69a121@columbia.edu>
 <avpHe8sGgnzx6UwG@nvdebian.thelocal>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <avpHe8sGgnzx6UwG@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 8eo3cE9LKQpojoBDFEoa6_oPC2zBYPaE
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA3NiBTYWx0ZWRfX8RTjb5QmyTsj
 rL7+oYK/dEteUq6me8n4aOhFRfc6nP1RDrnrGi8+4aKG4HE45g08ZOai7xQQ/6BmXBU/Km/IqgU
 WHWvnntfTDyJWphCCwXgfrZVCyw7AwoPryDqDqm20aUQsDzYrrvO
X-Authority-Analysis: v=2.4 cv=aYD0Dhot c=1 sm=1 tr=0 ts=6afb569d cx=c_pps
 a=g1v0Z557R90hA0UpD/5Yag==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=Ikd4Dj_1AAAA:8 a=UXdWbZvvS6ccjjYRLXkA:9 a=QEXdDO2ut3YA:10
 a=MFSWADHSvvjO3QEy5MdX:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA3NiBTYWx0ZWRfX29/Ut8XWEj21
 xocJy9LM9zyfLmiYuSMUON7hLAACyKQlT9AIIgQQePO8quO32IMeBW78Hi4eBqhRgOLKYurcq0n
 HiFU5vM6G9wRBEIblyd+XIVU9HD5rNHNfKFXGiXMHb1I77y8OSzUuElC6RcDl2c5NhgQKknJCy7
 g25KXa5UURRP6RXq+JQF0Pyblb49PRSeVE/bzwaThrTvtv2KffTDkfQwazh4iHHkuYbmGwk9acS
 cNZhztgJdNFH3emtsLqnCMdtX0fzOn0HszaOdPlGiZVhMByQ3vvWBEXglat7nVSzDyrsVQfLvbm
 RLTeW+0lPiOqS2z3UTx8we2t5X3aOh3S7heYj3LK7rj+kKd1OAFwgESTxCbu4ykm5gYGXvcr0RC
 SJ2JyyMe24MJ5YG2lr4Gl2N4u3owa8f3N+HMoV+BmZecS6Lmly51YbLHk26ltiyEgYppyYPiN/i
 rKCKb3gMd4+VVOkheqg==
X-Proofpoint-GUID: 8eo3cE9LKQpojoBDFEoa6_oPC2zBYPaE
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=10 lowpriorityscore=10 adultscore=0 suspectscore=0
 spamscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160076
X-Stat-Signature: zdcmwarogbmq6bkiecitpzyacw6du5j9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C21C912000B
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794856606-583807
X-HE-Meta: U2FsdGVkX1+w/u8w4EVnDJi40wJbp92Sle1EXhE8PIAir5v06gX9MrwJWQ+v18nbLoEmIN4+Hh7IA2d6lVyfpdjsvtg/CehuH0a5E1GTtWCpwP7gywZnyePKFZZR4uLYi+C5Re6ajzWN+gGoT1SBy/28KjD/t4GLZ6TdQ5g5TKFzX+ei2GKTFIAPygr7dACui45OaCWBOk0m5BmlFClfZTMQ8BD4IlnYFRQX8E7n+r7/NfGhwri4uxLeji7lFsV79soa569UZNmUGPs8KQ0d0ZBlzcMsiesXw9tGmVniISmobTk5qAqCSDUg9V9TQpOijpmZNPJM+awHpBB2L22s1G4cHq5AxIsynO05sl9OQNv7aiRaPCO598mxy5/z2fHL1SOk3UVZ5ZT2L5Dm8dNKtV3NQq4YhdBHxBvkuLWM2UtsfgKR4hy9AcZc0YOPeiDha6A+wcw94UV8eimsQpeyDdZyN8MuowOR542hNLpH0+Aw/u36b0Hg31VmCP1OZ7UL1VnUKVoDcgM24qJXHlg4DF322y2o0g4oHsaQYrXN4ysMOcVq8ZahH1U73yiIeHzIgRvrSzqYXsT1SHKlMdL2Ph1B5xCdf3Nl1Ox1Y8CRCYxjSzTJPokeDNjP79Mag97T74iZZAxFL4gxs/Vd1iyr0NDt0akn1sAh5tYlPdsdIISTDY0fS4uEIPNOteIjj93J7rVPfdt6Av7GuezLi/ZrOfmpI6sXnjdFuN6LyOlKGsWqyCg3c/3Vx3f2cfdfAN9nlNLUfTUge7zE1Dk5S2w/ukRaf1u5TYbgJRax9PDLJlG1k5+eXxQXwrUihyGZAfQhWW9Nb36PkF5/+pz+o9l1xq1iVL/RrPq1viA+g3BLfz7m1T3WV9PrStNdw/pCEgpYzoiIOOhm+E8n4dhs5vLh9ugj61OSEjy0QAEuLy2VQoj6PckBkTaOj/MWDHOSZWZgZFTNI9YuZkoNSYuGkIl
 NR7pZSDT
 bDDqOpwzTC3dNdQZ4kUJWweKhuXbwi/OEJTRGDmXGySHmnRFV/IRNOty1bzh/4+opJX+4qX8JA/DylP6GPDUE4kklkpE609gJ9z15WLDBVknXfY0V0AX3dgcaruzH6I1C+l0grqmfdnhap1lL6B3S3W99qV32lOefjlkGVefGPqCQuE8gZIejws+M+UpwaDkxkCAbqt6jFNHEEN4dk/GpDTvVSlyLeJNpyyq538gnNL/c+qh5l3QJbStGwj6pKAqJJSQVMZH90WQxvrIl0S6pQ/FmZMopoGqh4w02Unv7OmegdemIPDocVN0eIHVzJZe0fioNwU+W6uy2TjvrLuqMEnkvh84G09FSyhUor6YAq/nj6XIS1BjJHRLNtpRL49S5pSfPyONF7aNh2shYYTPC5WN3KQNWAtbAhAx0FVcLaRPdkl34GXEXTjsm8vzwToxuAjvlC/dtX3jG0zCshjGM7dj2/RZF+kIy1SXIN2g4axiEgo3YcihprlOqDkydq73Hv9jGFV6tfrrmAsff+9/SzmX3K369JXglh8JixWm3l2MQ9dFeUAN2IBWrHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/15/26 7:11 PM, Alistair Popple wrote:
> On 2026-11-14 at 09:26 +1100, Tal Zussman <tz2294@columbia.edu> wrote...
>> On 11/13/26 1:04 AM, Gregory Price (Meta) wrote:
>> > On 2026-11-11 12:55 -0500, Tal Zussman wrote:
>> >> migrate_vma_setup() installs a migration entry for each page it
>> >> collects, which carries the uffd bit over to the new PTE. However, a PTE
>> >> that maps the zero page is left in place without a migration entry.
>> >> migrate_vma_insert_page() later overwrites it with a new PTE that is
>> >> built only from the VMA flags, so the uffd-wp bit or the RWP PAGE_NONE
>> >> protection of the old PTE is lost. The same applies to the huge zero
>> >> PMD.
>> >> 
>> >> Once a driver has migrated such a zero page, writes and accesses to it
>> >> no longer fault into userfaultfd, so the manager misses them. With async
>> >> tracking, PAGEMAP_SCAN unconditionally reports the page as written or
>> >> accessed.
>> >> 
>> >> This requires a driver that migrates memory to a device.
>> >> 
>> >> To fix it, do not mark a zero page for migration if its entry has the
>> >> uffd bit set in a VMA registered for WP or RWP. The driver sees an
>> >> address that was not migrated, which drivers already have to deal with.
>> >> 
>> >> The uffd bit can also be set after the zero page was collected, as
>> >> write-protecting only takes the mmap lock for read. So check again under
>> >> the page table lock in migrate_vma_insert_page() and
>> >> migrate_vma_insert_huge_pmd_page().
>> >> 
>> > 
>> > Similar to last patch, this changelog could be improved.  My best
>> > attempt at summarizing:
>> > 
>> > """
>> > Device migration replaces a zero-page mapping with a fresh entry,
>> > losing its userfaultfd WP or RWP protection.
>> > 
>> > Don't migrate the uffd-protected zero pages.
>> > 
>> > Skip protected zero pages during collection. Check again under the
>> > page-table lock before insertion, because another thread can apply
>> > protection after collection finishes.
>> > 
>> > The alternative ...
>> > """
>> > 
>> 
>> Thanks, I'll trim it along these lines.
>> 
>> > I have concerns with this:
>> > 
>> >> The alternative would be to carry the uffd state over in
>> >> migrate_vma_insert_page() and migrate_vma_insert_huge_pmd_page(). Not
>> >> migrating the zero page is simpler, and a zero page that is protected by
>> >> userfaultfd in a range that a driver migrates should be rare.
>> > 
>> > This basically force-fails a migration of a uffd protected zero page.
>> > 
>> > Wouldn't we expect this to cause drivers to fail to make progress if
>> > they require that page to be resident on the device?  Not sure we want
>> > to force drivers to try to handle this special case (if they even can).
>> > 
>> > We'll need some input from the migrate_device/GPU folks.
> 
> Thanks, I was halfway through responding last week but Microslop had other
> ideas.
> 
> Failing the migration is fine - drivers can never *require* a page to be
> resident on the device, as migration can always fail for a host of reasons.
> In these cases drivers should fallback to remote mapping pages (eg. using
> hmm_range_fault()).
> 
> Now if userfaultfd+device memory was a commonly used feature then it would
> be worth fixing this as always failing would have a large performance impact.
> However I've never tested uffd+device memory and have never been confident the
> implementation was correct anyway (both features were merged around the same
> time). So I think the simple fix is fine:
> 
> Reviewed-by: Alistair Popple <apopple@nvidia.com>
> 

Thanks! In that case I'll leave this in with a trimmed commit message and
add some more GPU people to Cc.

>> Yeah, makes sense. I can implement the alternative approach, but testing
>> for this is a little tricky without the right devices... I might drop this
>> patch and send it separately with the GPU folks on Cc.
> 
> It probably is worth copying other GPU folk as well though in case they have
> different use-cases. Matthew Brost (Intel) has done a lot of work in this area
> in DRM, but I notice he is already on CC.
> 
>   - Alistair
> 
>> > -- 
>> > ~Gregory
>> > 
>> 
> 


