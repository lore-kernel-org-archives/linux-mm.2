Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E936B606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=VU36wWCz;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=m00C9DWU
Received: by kanga.kvack.org (Postfix)
	id BA26D6B05C2; Wed, 11 Nov 2026 18:21:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A0A6B05C5; Wed, 11 Nov 2026 18:21:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68CE6B05C7; Wed, 11 Nov 2026 18:21:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70AE56B05C2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:21:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0D3880409
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:21:42 +0000 (UTC)
X-FDA: 85424412444.02.B2E4B2E
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id DB0A440003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:21:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=VU36wWCz;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=m00C9DWU;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439300;
	b=OXIZ5oPPfkCqjZ/W1ALuKUzo+TNOr4oTl4s6dqm2p+jhXgSBjrRaJUxhRjX2g9WlYEjDEG
	u9leNagdZ8VKB7pxg7mDMkRJxlvjCa8M2pxLBlZFggN56TWrLC5RSw2KoOLbu4i3iAiO+U
	IF20LYSbxoDpIZRvqx+jXXzDGc5+zsA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2Z2d4ubA/vBybLDW0A3M/dONekPuI7b74giCSqVh1w=;
	b=6kGuyFQkfJn5Ra8WFakqspx0YUEEt1qYqxS0A46mLUEgZOG/w7N00teSVG0F1NwVCKD6dJ
	Owv9yMfAo/KWmhloHkkVRMH8pUmmoBYPaJSCrtSXhh/IbUt7JCbPxTDDkwOAw0uevhrv3n
	EKRNx7NB/sJr4LvQrnUEJ5FnN8fj6hc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=VU36wWCz;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=m00C9DWU;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABMBq3k2545898
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:21:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=E2Z2
	d4ubA/vBybLDW0A3M/dONekPuI7b74giCSqVh1w=; b=VU36wWCzQDQPCDJskRC8
	GUumOBIPmH3k55QPlp1YNsxNWGQx4zstGDwIkhP9sggGaAtNDOxVNPM+CIQjV7M0
	d76oIXkhjHWJS6/sJD0V7xwxACCKXbEImyr2R53OJ05AYwSPslCjX6JDP1dkJFLt
	ZGLE+lAezMF3v+tbabY1FXS8t+DLmwNBkOOjfe50Y+e8kR16R4byD26CbkJ1engs
	dELYjDkL4R1vzPRAlEtkmGpBtSZPDEYDeCqZDX8LFf2EW4XF+J1pPYC3lE2ZFibP
	e1E7tig8fu3kP6Kh4QBMujICqMTX3AetkkzRw/0wJjtqfoXr5TsZMDAY2ei2x4fR
	0Q==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hvvaqjy32-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:21:38 -0500 (EST)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-91e98bada22so70407746d6.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794439298; x=1795044098; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E2Z2d4ubA/vBybLDW0A3M/dONekPuI7b74giCSqVh1w=;
        b=m00C9DWUXAtAnUVPT531zeRHoCuvot6UiZajI/tUsDNtHiMM/splq4Xk3naMog8HpT
         +E6JDlztFS/jrInoX8elFIUo/QtgHbaYQ0RlkmWCilQwbkIlZ7szNlRHFv3lvTRc5jz8
         3S8CgvUPuH5hk85tOKQ5JSzBR+3Wj4ELwulbv0EDPw6pBlDjNC6Y1q3Zfid/Z+CVS0W8
         4wkDxxNm4M3V7NunjFsgEAuEVOHwyKqDYZoDu1qB8HMqYcqyHgIy4F6eK61oN/EuMhwO
         Dsu26/1KH9RlBrCZicG6o6dKpsdJ4PmQzpQBe5YFfEjLPtKh9ZNvMgGiYLQm1R0ekU+x
         uMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794439298; x=1795044098;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E2Z2d4ubA/vBybLDW0A3M/dONekPuI7b74giCSqVh1w=;
        b=bSBSk1AkZ9qUkQX0Ee7ro9QLq4RUkRLyfiOvxpwiL6SO/CQ7Xs9ODeKYSQXib0WPLM
         ouHzk+Run/G1DsW/c3mdvR3qQBhmg/mYI7Z1Se3r3u1pv8ALZuoxwlixezdu1M3h3loa
         Wz2BtxVH8wnG3sIuhpypDvphruu2nxTp73a5txeGrhbkSMB8fbyqWGmpj3RTBjJmivrI
         4v7YgP7uepBCIj2h8APLw9td1zVzvzBKvYHUw/uHbZwadP41wYzBXy/J3/ZqJmR8l5JC
         p9CxbEuSheNTTUOStdrNfpJU1NM9OIJGqDFIdeTjN8fEr0gFdyz7Aj3R4hMBNocKkR64
         zKcQ==
X-Forwarded-Encrypted: i=1; AL+hErEsmsnLSfoWuaH2/a9WZheHmqDc866CSHIl785SnKliFxcghf1xs7gnaJ+Zw8rM52Rgy7W9jX9N4w==@kvack.org
X-Gm-Message-State: APuU4Z86tyIdycZiAoCypp5+sQ33Gbe1FxB804OZztSQH3vnnJazHttx
	dbLdgYkLiDDyP5LXFEl2ujkbxU+H4y67Xx4/icJsY81shTyp7uy+ES65oy2FZYWWLlY5H1XLa3R
	vRY7dRreOhjlE/R93zBBjHkRKDZ6gHzKyfWzDwm5mh4zT8Wgo
X-Gm-Gg: AYBFou2unxKb5iY9fxZ77sID3qjvWVAHJbKt/Jaeie1zuqB/qrJp6dLixYuRW9/yqQv
	UR9FgQjbnyt4a4NGzsK+Nct3oROsTMufOAowaexVxp7V6eg8vTwzSIvDRoikkN4QSStv2MlBNNv
	cSzG7UdmyAUaLskOYix01cvEeWwq9pTGjRxBKayIqkETzae5YCNeETtJ6VAxFNsTp8OwIDBypYn
	NZpooIn7+U8air3yNoxj+U/oPLRMgR2Jolrhb8kHZ8EeCdVsb656IJl9ZCUHz/KQrvlThMYuj0R
	LXl+FtMMRU16oZ/ikXNnmYwiSt1wFLPV93e3KjFTI3FPrYP2Sw29E/URCr9/MUoVDpJfAHy+Vgc
	Agb4bfyqmd+dGz4bJh/KzRaAieMjr++Z4oz8if2pXbQx9DP03a0WiPOoTRZ6Mh/AzBm0sFfICrj
	mNTwM1DmxzFGVWlzSqSAjKXaaGI9M=
X-Received: by 2002:a05:6214:d86:b0:91e:a629:ff92 with SMTP id 6a1803df08f44-91f04196dd4mr71943066d6.42.1794439298043;
        Wed, 11 Nov 2026 15:21:38 -0800 (PST)
X-Received: by 2002:a05:6214:d86:b0:91e:a629:ff92 with SMTP id 6a1803df08f44-91f04196dd4mr71942586d6.42.1794439297418;
        Wed, 11 Nov 2026 15:21:37 -0800 (PST)
Received: from [10.207.116.169] (nat-128-59-177-239.net.columbia.edu. [128.59.177.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f02fcc4b7sm33094936d6.44.2026.11.11.15.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 15:21:36 -0800 (PST)
Message-ID: <e19f1fff-f1a7-4c2b-8908-2d3ee6a49069@columbia.edu>
Date: Wed, 11 Nov 2026 18:21:35 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/12] mm/madvise: send UFFD_EVENT_REMOVE when installing
 guard regions
To: Kiryl Shutsemau <kas@kernel.org>,
        "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport
 <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
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
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang
 <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Chris Down <chris@chrisdown.name>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>,
        Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu>
 <avTA58zlxJZ69TB8@thinkstation>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <avTA58zlxJZ69TB8@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=FraQbGrq c=1 sm=1 tr=0 ts=6af4f882 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=BoHXNMl2GZKy+iVh/K8zVQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=eFDYe-PYqAWV_-s2uwYA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA5MyBTYWx0ZWRfX8kEVKsmYqMJW
 8/TTUqeOtcTEaedwDB4FNdyEAnmag9spVP450+38pJyn+jzgO4xAPRFlzxjD/FX0SuRcVD8xj72
 qvFqcuRE4OewygEoXvngVQuJHWk7fDWOw9QP8bdlXPMObYGBukU3tDKyXngkVnNKOHvcGCIlhOl
 hH/aLGNGEzMWjjvoRkJ8smyurmoCW0CEw9VKX8FnM5aLK6tc4/eHv/atTTjQPQ67boYjKnAIjkH
 m85y+UWhyVFgUXE0P3+kjDacQAsrBV4gVZwT9dISbrUuiUePCz2jCggbHb3uj5h8gx6ZM9KMxv5
 bP9kkmsDScSSmbUc49OKV1WUvq8oxLDq5Ke/u00nbsmLK4IiiOjeG+HGOwwqedjlfkEXElKpi4D
 fjSb0Sc7yXBGbrLHV/pUqTIsDBLxk7PtyTE9tu6inCqtgtuoZoBmXW2MbfEiXPoFyt6fN3lkHiG
 FX8VUGHTEV203rFHxHA==
X-Proofpoint-ORIG-GUID: jv1Rre-5HDeeXXbeZyctv7lx6dXqHpY3
X-Proofpoint-GUID: jv1Rre-5HDeeXXbeZyctv7lx6dXqHpY3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA5MyBTYWx0ZWRfXx1sylN2PgXC+
 VInmhoXgubVzhuKeOkEPIRuOCegR6dGzk/0Hwx/uyh04szJ2LBNf8KwIG2GXcjvdA9LSan+9f6o
 FSD188dtN/+kCMgkPaaPQ8p7zFcv3D3pNBtMp2jKvy6pXj0btJ8W
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=10 bulkscore=10
 clxscore=1015 priorityscore=1501 impostorscore=10 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110093
X-Rspamd-Queue-Id: DB0A440003
X-Rspamd-Server: rspam12
X-Stat-Signature: ubjke5c5w3coccb13tguzoia45tdc6s5
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794439299-576018
X-HE-Meta: U2FsdGVkX1+NVouJ/MZk2+0a0aES5CVZmo2SUSJJ2zAg0WRQCnen5U+8DtNOKiDVOYWRZNidlqPL/6UhV3EL3Z1FG6qt2K26pb2qvxRNLGOoYZSH9r0mhQuj9NtM8j6C51Jy3z/E4A+aRMCHRZFhKJY3fVwxLYIfUGq0eg8c5XLwekqT8d3B3ZixhKOo2gz1tPq2iqsXTGw9yLOmmOUmtkf9W00rNuL0fqVkd/hlmqbuc0iffNPUhl0Dq8dqmLD9rBLN/8X/mQFjvnn4Vsygx1J3rNa7Ahh/T8OSX4QqbpF+oCWRRuCZeWdxtgg+kCjskTp5Nm6dY0+4ESpuBdSJswY788xHtKCVEJiOslnvVZ1ioaoaA8T9pXDe9LGDDuFFB0YdGXSu0pqVBRqVqvQ5v3Jjarcnmv1oYcmbclikmFtvmMvwlso3P6Hfn/vmlNaUGcCw6Lm6FUihlDx/8ANR3uBE8AI5+DSdg4+AEHIEOBX16RMgEwHMqpj+uRimK3R0yXIz/gdgSszl8ji23K9apkjTCEJHRXZXQFay72/CpjheP0dzfW/0PFrc4MwXtmqhQ8g0boaCIF6Qd9/Y+pftVs05ZztsRxoJfZvdkZCetnzfjK/wqgnIT2srLFIjBQynLzWjht40Crqrt5DFL12nlST0RvKKcppPRFUga6uH9LA2bna9pTgmb/i7B+1hk2+Xflqpwbt9fiRKbowV3jb8FCMJH15eaM5Uep2Utstn76Cszq9v1Q4XVr8YZM243K2WrjUb63m72PtWFaUpAIPw8+XdjwpfxkhP3La4ZqzHs3KnVoqGcUDX4c6nxgdUv6L57VmgmeQQ4aOX4fhdfzfpwjoXGODYN5j5GtmMrcvXBju0bF5kfsQAybH9lutFX0G28i9G4y+mlrFWMyhBJp2seLTboKSyBYy9fJO+TcyqbJ6ZaTUYVyZz+81IT6ip7pCXQK6PiDsrWmBPLq4wnSr
 ZrEhakOv
 6BSHSNZncV9Sj1gcDCMI1R7MGJNR6YD0tk9qhDdt3JJjV+MyvBpyL2sBQXedr5eRNHd53wlOMRo78DfXjl5Dx1XDktTc4O3d7vsj4sYpnrz00lcMA405FvLlpC+rgv3Itecu9tkOIvDuaKe5+ilSuPvrVLgcHp03/GKZchFuIC8yQPbBozRzhG9qXtwbjcINPKZnp7eyo7mfeRJqi78vNtkWPdeyom5T/yD/3SPuHzz+KB9yUvGgNxTHPfcDTD5HF+/e38YflR8mT/H3Yh2Q9BypATTH2JAWEOMVHfF/WUFNQE95j0RL8MV7/l/QdAfqQAYDQ9m64mF8Rzk1Vh4IvAw0N0xVUXvk49r5nNN8l/VgbKzMEs6MWUGejpO6+whwZY3zKL0JTTSPY6dZaG0mwZokTQoCxPKHCf6sK/7RfDcv3qvqMP9EY6TefFSUDcDdPXR83rinSwyDYcLPvWRx14H0Gs4fKe1kHsoaLqzpdIk9xU4ANWETjxjtHZO1ldpg2N2fWysi0M/dREF/8uC4/eCaolGcXdUzidFJoD4cHqkmXAq0EUzOn2+rIcgi6gu84QAGkT8ggPFoZhFGhrAw9fmFu/LI8O54RoMQxJAHQJZPWkOfTWWWbtFqhN6PGZQam1v8Tn5V4heH0x8OUjN4e6y+b94nQVNpAM3XrEVbLZ7qCStbA9ifOExsh9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

+ Jose

On 11/11/26 2:25 PM, Kiryl Shutsemau wrote:
> On Wed, Nov 11, 2026 at 12:55:19PM -0500, Tal Zussman wrote:
>> On an anonymous VMA, the zap drops uffd-wp and RWP protection along with
>> the pages. Writes and accesses to the range after the guard is removed
>> are then not reported, and the manager cannot know that it has to
>> protect the range again.
> 
> For RWP this only holds if the range is registered without MISSING.
> 
> The zap frees the pages, so with MISSING the first access after the
> guard is removed is reported as a missing fault. And there is nothing to
> protect again: RWP only covers present PTEs, and a page faulted back in
> shows up as accessed in PAGEMAP_SCAN.
> 
So this makes sense, but I think this gets at the documentation point
raised in the other thread. It seems that to use sync RWP "properly" it
needs to be combined with MINOR for shmem and hugetlb (and MISSING for
holes) and with MISSING for anonymous memory. Is that accurate? If so,
this should be stated much more explicitly in the documentation + man
page. I see that co-registering with MISSING is mentioned, but not the
rest of the points (reclaim, collapse, etc.) The example in
userfaultfd.rst also registers a MAP_SHARED mapping only with RWP and
MISSING, no MINOR, so that should be clarified too. Hopefully this will
make it into Jose's documentation patch.

In any case, this change is also needed for MISSING faults. If a guard
discards the contents of a page registered with MISSING, the manager
isn't told. Once the guard is removed and the page is faulted in again,
the manager may fill it with the old contents, when instead it should
have discarded them and filled it with zeroes. This is similar to
MADV_DONTNEED's handling. I'll update the commit message to emphasize
this point rather than the WP/RWP aspect.

Thanks,
Tal

