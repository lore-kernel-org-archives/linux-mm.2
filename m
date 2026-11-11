Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D03E60A382F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=SUlefyVx;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=FYh5/IWa
Received: by kanga.kvack.org (Postfix)
	id DE05F6B05C9; Wed, 11 Nov 2026 12:56:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D90816B05CA; Wed, 11 Nov 2026 12:56:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBBEB6B05CB; Wed, 11 Nov 2026 12:56:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8ACB96B05C9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E7F5140386
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:01 +0000 (UTC)
X-FDA: 85423591722.23.7C98E56
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 577DAC0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:55:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=SUlefyVx;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="FYh5/IWa";
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419758;
	b=oH4SALKGVO/j0Zq16kYYOt6lGFWW1nu26g/2M4wsQ5qZzQw60+/ctYx92KDqfq4mh93flB
	eCjdq+5WGbIcTJwBCduYoy/8tlw+hRQ2bsLwZgclKg5LoR05styMG7ddTJUHMotMquOtO9
	gcNw3/ZrxgGzpkxg41Vj7zw9DtogFnc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=SUlefyVx;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="FYh5/IWa";
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7MOFi51WWNU/BFhcLH1/2inK6bTwCpvqAbFpVpbGI1c=;
	b=HHQV6ulETvtTRn5va1Cu4r1iNrr/FYi/Fz2VFuUbH6J1GX1Z4KrOz89pJxFd3+dePO88ZF
	slUObcb2AtLWj9Gg/hm92Qj9qv8ngPxMuGGY65dXWJ0PjLonOGPBG/S5L0mfVYDlQhvUye
	WbZvTZs38ZFV8hUuInHm6W4FwUoJVmg=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABHYlkc567603
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:55:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=7MOF
	i51WWNU/BFhcLH1/2inK6bTwCpvqAbFpVpbGI1c=; b=SUlefyVxB2IykylV6RQv
	uCFi60l/FjIhTOBff0sXTGw8mJJ67LkIWRby8IoUBoGN71z/AKWoHY4taBUwIcS8
	GInDU+0qmG9aXab4oQAxeNGUYqW1wuDC5N77s9q9G40D0YyCuWd6Y374Un7fptUU
	b5ZH/IKn8BZf5Hol9D5KFMSjD3FMwhrLoCh4MCrseoT06SarW73nAbJfLbk2O9Bo
	JN+LNgOAy8ntOeG9+73YrJeibpoCF2vEIFsj2xd2vpjejlTwTn1p3Otd+/Ni4VK6
	vGNcNORMzv2Vtiwsy2earwPIWL/U8nOwpssXNKYxPtaVTa0PBjwonpv7MAlEc5H3
	IQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hvew5mptf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:55:57 -0500 (EST)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-544019b1831so64127311cf.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794419756; x=1795024556; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7MOFi51WWNU/BFhcLH1/2inK6bTwCpvqAbFpVpbGI1c=;
        b=FYh5/IWamvhtjJ/UxNZMPnvgtTrK30K8Krztu1T+rnDU8Y32G8RPTysVqCcVcwKJ7L
         2iaxUhZAaRm368E7r8O8w29BQDCsne/R18g4NrNthEKu6YlmUnFZTH51iiGUwPFfsqfI
         GnrSLZneDs1pszeHAsBgcskYbobuvmpA/jo+3Jdhckmi+55QcWxqrWglM1effu0f3kEL
         UH0ZGBHcivqrb7xDizCLgr4OwkEQ9RiYNjtWpV9kWHo/X4zJuC4xCX0qIKOwEFF39he8
         YK39fcVrFWhTIGzuFjDCKu4MVjSZ3DewEu+WQpu72I4Uiioak4pN+4xMsjOS64+xsndq
         hDzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419756; x=1795024556;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7MOFi51WWNU/BFhcLH1/2inK6bTwCpvqAbFpVpbGI1c=;
        b=1b3rzET6IZxtGdLcQYifB/6mP8KXG4D5xfPkABC24Gj/tu/uM4i+zAoHslrF2P2oc6
         7PhJizzJviSyriINA5DmyTr7brUSMNbcNZlGU2LKIbL11ItnVKM4UkMNy1q4CbDwcNDp
         gAxinj4jyKKLf1lHiAMhNUA5pC4N+OwchRQwgMYJyDD2wp2PLapcHAvomL343riGGl3T
         Jp3Z0ecCFXpUIFWRp00nmQJ01WdrozZMuurnAlr1WoXW2hlS4n3nJ76qw8IL5obTnfMq
         sxNNccF+Am48DqBZZtxWnpCxIaxEx64cOp/7xerEcRt3zFfvMx3TSiiJg2ktu00i2wvo
         6Phw==
X-Gm-Message-State: APuU4Z9ih0g3cztX2Pw+X8+rGi/NIFbYBpxtGJ6doBn/xdWo3qSKObah
	030BZWfc/XuyYZVIbts3SHOb2Ne0yABF8WkMz9AxN4Ra6jaMjO4K7zKzfLzFa7y9AsazLlfweIn
	FEsgf9VBjLovtsdHwmzLyHWRXMav0JVRYKlbg3PHu5DW0lUib
X-Gm-Gg: AYBFou0utPJndIkCX2AZT8rQzwKH6iYRdQ4f2WVP4eqRHPwkBIhwSFBYGtrh/JmC9OX
	HW5w6x1PLRX3IGciepVb3K9o1LSj37ZLqU+uz7PEyHnvpI7Wjaq9k9oMowFy/GXgH2DKxQZhF92
	E5ZesIhZcLBHfkIvaTLEl9LHtpITILMu1YpYdceFZppSfAjD0/Lq3yn0HQXNy8yJb7UrhrUCjus
	pZMZ10rG5zhK5Q+4T70We6WY+UT/9x3TVtFeqexTdxBquewLeYUTXjIUQbBajVig9BFNhmPESoW
	P82Sv4q6xGw5IeqgGGMoOUnWZA+OHuEv6FdNelbEwonhc8HskS2XUB8gmBxA+kRbPOkUXr7l6Tn
	INpQB/SQfGmHfek2BWQ1IULdwzY3e9BmOX7NtxjB8hI8PN5SF3bx9uZd+tH9utnu4wqiO4Lcuje
	zAIG+UjDgO90uyC8vWZw==
X-Received: by 2002:a05:622a:4c85:b0:536:5ec7:7b37 with SMTP id d75a77b69052e-556bded3d02mr45210751cf.8.1794419756309;
        Wed, 11 Nov 2026 09:55:56 -0800 (PST)
X-Received: by 2002:a05:622a:4c85:b0:536:5ec7:7b37 with SMTP id d75a77b69052e-556bded3d02mr45209941cf.8.1794419755682;
        Wed, 11 Nov 2026 09:55:55 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550b93ee00sm54974231cf.16.2026.11.11.09.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:55:55 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 11 Nov 2026 12:55:10 -0500
Subject: [PATCH 02/12] userfaultfd: refuse UFFDIO_MOVE into a non-present
 huge destination PMD
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-uffd-state-fixes-v1-2-00713d368976@columbia.edu>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
In-Reply-To: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
        Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>,
        Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419750; l=2480;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=hmSWdcV8+u8Uu55UTF0KE1x/q5080musLnzrsSE8NCI=;
 b=YcmnJF4fHQ0L7W4Y7oTSYqS/5IZFZUFz6kPggxDhxQy+g7C033bdZd6LsCGBcgjt9L5wqvPbF
 LdrIPSEAYk6Barh9Z36Pi1JQlaP2hup+hwI8mBdW8nnsxhKpgORKaTc
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX1/3QpL9BRInD
 mKyNk4rO9oA1+Gnd2SFERzvM0pg2k7RWv/igBm1GQ3CmFs+qKO/gnfbIVV93zWStz14s1x9oQHn
 oDhG3FGED+86oGiLpsEjybB3iuYF6/cY66F6VgC1wbB84TaAmpGHqNJhfXv6PhcLSyXSPagAaET
 y0Ox/INkxrFrlso5wtdodKECQcuoyrokx6rsj9GY1VP/jCvK+v4sti2N9HOhxuH33vFT5ixNDYl
 KkzUk1XrONyUXbmDNFwXdq1bjFG7ww0GNrtUY6WYEifi7bfEsX1xODtY1Eo2CBDqwlzBhk9epU1
 MjDpmGx92e5he3HDlcUaYbg0rfl/QhEiQM+lG3LeqSHSN9crtubxOC/s/Hbl08JiywAfZibg6Pj
 xIY4joawf4A5wcgrtvoz3OZ3ZdSriNUkAC5cW7G257B1pngKPUKinCzyKsIlGgwZZfY/wU+7Ppx
 +OUFQXX+dBQgPa86B4w==
X-Proofpoint-ORIG-GUID: posec8KIYcNyg25CMoZ-WnxeGbNZjuNe
X-Authority-Analysis: v=2.4 cv=etVKXYpX c=1 sm=1 tr=0 ts=6af4ac2d cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=VwQbUJbxAAAA:8 a=n7zxJ9EK30Z5vFJJ7y0A:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX3Y6g6srXutps
 O+fRlKSJ7CzpBZpyT+RyxR2Y3IJDsqZ/8ABQ5R3LbPM9VjcP52toJUax3u1kAYaa7vsYPpq5fFr
 rVo21H0wXajeTciE63Z4PFEXmo3IFJTwHp+oG7ZXQQzXR01Zzry2
X-Proofpoint-GUID: posec8KIYcNyg25CMoZ-WnxeGbNZjuNe
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=10 suspectscore=0 clxscore=1015 lowpriorityscore=10
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110071
X-Stat-Signature: kkp1h94gdb7q1dcigxw48tef75y6e8bh
X-Rspamd-Queue-Id: 577DAC0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794419758-904726
X-HE-Meta: U2FsdGVkX18k5nJJbP/kKwHp2pXsJwqTU2Xu+q66r56JEKf+LTYnCnwbpu3+fh06QvJFFhV2KXaSoiXfi4wA082LyNHxEZd4OIr24YcKcJDyfWANNvQX5D5nJE/g1NfL5XqUtVKA4r8UFYHJ0c8tuIgvT3bIZuzEEuM/uQCVgDUbQWoUMo+I/UdUQzZhkEAmDWOmmFzTAq3TdDHVeGgewXAUnsFzyZiFbku3UD1BRvmtL36IQ1LUwiR1X/o+Ct9jv8zLIjIEYN9JTItbK3Dzfd8iLFKkyYr68O66pfd9VJXvVAqfPCBRmTM5O7cvaJ/tXehibR5yr/XVn0SJc5RwcWjxcl2ia/FvOUsZ987ocKbp0WTVeInPbQ+NNxHUhRTfo338K4iPwhds2ihCqn0QgHTXxyVt6bCO7FdBK456mpX78nqaTwlC1f/Dspgjwwu46YbrjlHs8XDXh+H1tbjInV7QNW5tXoOAFLJkPh78byhj+LT5K1Yt5BtKWDZliYW03a7nmov791dPxi4i0YkQbOaKhrQYxvGasylQCQcadaIV+rKa/dJVTsmgg2J6eMqqIPYri7k4AyqLirj7QM28Q54TM3L6BBsxE7JVgF6iCO4ojb//WgESJ8Tl+V9C25zLRIXkSgI3LFQLSU7yyZYkNZjvgXz+0C2BQaBDrEdEf+xl1RR+IkXWBwcLgeDeHDoLwfqMfpY9J8+szk48nFKQFtGDLRI9F08BF2AlAlYHvWup885OhmYUkFI1OcjYf9pRU8EEhtklQ4zY4CcOBBQdiFIk3PxHiQOv1c8ygGR2lKRnz7NEPQZJSI95VG2jCi0pIbKkm5JDz+zxfwHJwauq3YQxXKbY9pq00e6/omwGAmMG3/Pos7r/w8qZzAE/2RUhQMGL93unggk3tSmC7QaAXyQGL316xgI0RgjeFmRGy/9zht3MJSd865YkSElonb1T9t+BAwbjkZ3m8kXwxdW
 /tPXF5A5
 OUsdc6xN5qJSsZM/YfMu4526IxzM19c52qxW5KPhQI9iBBaDiCyhEZLgtz93biCy3z4tK4NL+vEpqkzGU8E1fy9xuGA/9bXJ97FFbi4ku590zQkJJ70ep0GghyOKAWoNuoQ4z2qDarIGwG3DVYV5kyBVwrKR+mq1EvkMzM4S5zYZ8ZwqnHKP1S4Mj+chdHO3cap1hqFtMvtBqjlP/V67BQI0J4RYIeXy7NnIJ+tk162CQil0PGm1LBEdYbCmt9cbO9tT1m9dsIfgSRNevxkyDZiRZTalbnuUQrnqedJCuRjZwQ4yjcAArD0NoD3oDE/EZYP/AflAUtMfQC9WJ0WFpZviCDLYS/+6gUQfy5/K/GQ6STLf59JZaA6ZSMNQVgWm8EmW9vgQfQA11o9MaLdL5C4dOtBO0NAO8kdIWZF2QgXRUTgfyNk3ipnIGCczL+tzltWy/i0CqEAfnwjan8BcQrZ5OCm/3XZ5D0LrKnEeDYWLTKuH58j1PTWWE2XnWASencanD5CIdhwj6l7Qu1l00oAF3Hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_pages() refuses to move into a destination PMD that already maps a
THP, but checks for that with pmd_trans_huge(), which is only true for a
present THP. A device-private THP or a THP under migration is a
non-present huge PMD leaf and is not refused.

The destination PMD is then treated as if it pointed to a PTE table. It
is not empty, so pte_alloc() leaves it alone, and move_pages_ptes()
fails to map a PTE table from it and returns -EAGAIN. move_pages()
retries on -EAGAIN, with both VMA read locks held. If the source is a
THP, it is split first for nothing.

For a THP under migration, the loop ends once the migration finishes.
A device-private THP can remain in device memory indefinitely, so the
caller of UFFDIO_MOVE hangs until it receives a fatal signal, and
anything in the mm that needs to write-lock one of the VMAs blocks along
with it. This requires a driver that migrates THPs to device memory.

To fix it, check the destination with pmd_is_huge(), which is true for
any huge leaf, present or not. UFFDIO_MOVE now fails with -EEXIST in
these cases, as it already does for a present THP.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: stable@vger.kernel.org
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/userfaultfd.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 61a712e1f9f5..ad9d243dc64b 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2021,12 +2021,13 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 
 		dst_pmdval = pmdp_get_lockless(dst_pmd);
 		/*
-		 * If the dst_pmd is mapped as THP don't override it and just
-		 * be strict. If dst_pmd changes into TPH after this check, the
-		 * move_pages_huge_pmd() will detect the change and retry
-		 * while move_pages_pte() will detect the change and fail.
+		 * If the dst_pmd is a huge leaf, present or not, don't
+		 * override it and just be strict. If dst_pmd changes into a
+		 * leaf after this check, move_pages_huge_pmd() will detect the
+		 * change and retry while move_pages_ptes() will fail to map
+		 * the PTE table and the next iteration will see the leaf.
 		 */
-		if (unlikely(pmd_trans_huge(dst_pmdval))) {
+		if (unlikely(pmd_is_huge(dst_pmdval))) {
 			err = -EEXIST;
 			break;
 		}

-- 
2.39.5


