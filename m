Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D948F606A339
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=O53Otncr;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=tgtf2dov
Received: by kanga.kvack.org (Postfix)
	id 9D8736B05BF; Mon, 16 Nov 2026 15:04:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AFCB6B05C0; Mon, 16 Nov 2026 15:04:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84FB96B05C1; Mon, 16 Nov 2026 15:04:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B55E6B05BF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:44 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F006D1A01B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:43 +0000 (UTC)
X-FDA: 85442060046.14.6E45512
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3D9EC80009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=O53Otncr;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=tgtf2dov;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf02.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJcdx4vcENOgHdl2eEbezDZ2+sbt03i8E18pwL1oDcg=;
	b=iFn07HB2FQT2ttelE1I8NhtRKxMin0+lcQ/Zcj3nCpWajp7h59+s6fFiIbfMYxylrK9oUN
	LAt57ZVpcpfQY0GJ9AgayODPAY3NTVgYqF58HRouhJodEEaXQ2Po/DnZvaKk1vI/RiaUwa
	Lcp6rqUYzb27Bcc99J0nuzmek8YBNrI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=O53Otncr;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=tgtf2dov;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf02.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794859481;
	b=sW9hZRtPSmW1OY9NblF5/tmvqrlq7x+NRbRXA1wE0Q/9G+Ci3ePLziDHIsbhbo1S745xZV
	9Cm0J2ZurXsF1C5sn6TBx+XQbttZLBCyRyQjPNG8HDkKfNikDekfzgp4WU4QO/qt4Se/Zs
	1thLDoWtLD4H8IEwmGO7BDWuUv9CyY8=
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGJXTfJ2059014
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=aJcd
	x4vcENOgHdl2eEbezDZ2+sbt03i8E18pwL1oDcg=; b=O53OtncrkYvH3dSx5Qwi
	Fl6G3Ntqld1xFgvYXyPjTgAl+xLeLCmaF6zdCn5hz13GszwJVItrKpw7Lz5eUS8S
	eMRvbV0y5yS22AyYY1SnxqisJI+0yWhw334hIoFAO5YyY2BM04PsJVm8Gm+qfTOj
	T6FmYNtj1uEoV4PU2BgQCsrQ45FIHjyyo2LeE84H6S+AlRJN/SMwQZgm30nW5JvD
	lBsozOtZjWJNBsin0lxTYg1KeRuLsI+V8wxBX38DU8wS2QE1avDgVWx+AoBPQTiA
	fWTfz0erwiJE61WCtAA5phLnOQQuQBPpt9f2Le3MUZSt7UpO+YZUsGX1qEA2zWQE
	aQ==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j0583j3j5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:39 -0500 (EST)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91f12cc95a0so80329226d6.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794859479; x=1795464279; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aJcdx4vcENOgHdl2eEbezDZ2+sbt03i8E18pwL1oDcg=;
        b=tgtf2dovMwYSl90ZdFMg41t9ZQsGnJxii8lJhfSgTT4AqEln9A4iiDWtGmTXUGUjTc
         pUy5psDrIGWQiGHOrKDoaS7LTq8JAT44fWmOn/yQQnoID6EVrPgZbZAGc8jWkrhwSCJj
         hq+uJhJOvOiCmRnPYC1V5Jhfmnl5LsfPASUqPVQMku6Tj6IhuAHp1L8TVFdqIlyRwaSo
         1/5LDZEAya9tTuivzpIOfC/EOsMGU7f6FM3oM73+eyMxM3SpBuxrnf9c5/BQeIuQQ/ji
         mTp1VcNuRWhxJ755SjmSAWnl0GXa7Jbag8j0zJ8+cN+7RbkUuAk/1HHvn9k2chQfZkL7
         XTow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859479; x=1795464279;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aJcdx4vcENOgHdl2eEbezDZ2+sbt03i8E18pwL1oDcg=;
        b=isILmtmqxojtOsYoGMGEyBT4M00d0t1oFxXV5vulqSL9me9CjM7izoK6t6vaDobyNR
         M78NedNWgU2kOzyT3CQtRLXms66oL089FZOrMYJ1TOW2k4kw76G2yer48hzlyoxJZvMC
         y6pxk1ftRnrOI62Uq/4ozhSGka6HSzb054LkJYmkR0CxvOe5LV9SbRTfQhW35RtWZC2G
         h6FJ23761YduHoLtfSDMEW2JDDRggd+sDSRJCQjhI6VEf3O1OQsZV3zfyJ/UyJAS3Fh7
         ha1MrsiMpBnp2jKhCn75bY8M257HD3rtslaEYgQDH/RjSE8G+ytODk2K1iiCM7M8Sx8s
         9wRA==
X-Gm-Message-State: APuU4Z8JClqq6Grh988CAj08enEofx8SJTgMRoV2VlGX1fxjn1IrbNuU
	60KaPQl0f+jL0vnTF5wNvV/BpGcgU+NMoM+YD2CJzKuHauOz0jxcu7vnGFSWpn03j4X5xJR8ATR
	jHCq63unwRy9O0leOFP8ygm//Tqx07yu2zbimcr9BsOfCoCtS
X-Gm-Gg: AZFdTZc6Kc5CbawYkSo44jeuyp5ExLJP1PkHAT5BjiHCqwVtePScDmVsUDcuGCnTPMX
	7lSgp8AgcbjANxVgX20d2Sfmkq7VaozVEDfEKKDIL5+bPp8BU5Sh2UpVIsy08pvFXe9bKPtpO2W
	aI0yuzDUqQnTkeagfoi741bpKHOhWWZYHMPK3vq/bCwWqjHiS3B/QgcnqrKZr0ZoLrN/xeZPm+6
	8/sIVFxjnEYs5S1qJcJym2pMjl5bUeNke5XQifvFTCAoAktKewH9ncHQtFtP4HJjIGKWiI+PDur
	iqG9ZebwP2SF9nnNiWlgDlvSlMnpH4+7Ho+dEsH8WlcUFkNR9ondbvj3N+hAlF6a1+bfFp01kpF
	OT0zBmAySyVM8gY15zsR2NYlDS6jpeXtxnPnSU+qzcjL3UBiXfm94FUrLmwPo+S6n5FCXO9DXCh
	9ADYzjmCm8O91BvV4X4NWj
X-Received: by 2002:a05:6214:623:b0:91e:b874:1290 with SMTP id 6a1803df08f44-91f2420900bmr177490736d6.41.1794859478693;
        Mon, 16 Nov 2026 12:04:38 -0800 (PST)
X-Received: by 2002:a05:6214:623:b0:91e:b874:1290 with SMTP id 6a1803df08f44-91f2420900bmr177490156d6.41.1794859478219;
        Mon, 16 Nov 2026 12:04:38 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23efa2edsm93065426d6.15.2026.11.16.12.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 12:04:37 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 16 Nov 2026 15:02:51 -0500
Subject: [PATCH v2 9/9] mm/userfaultfd: check hugetlb end alignment in
 UFFDIO_UNREGISTER pre-scan
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-uffd-state-fixes-v2-9-4397a0196479@columbia.edu>
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
In-Reply-To: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
        Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@suse.com>,
        =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794859460; l=2072;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Piqnlv4F255M+HE2n3Ql4fdpsjy2Q0rhRNGi9JUEiaQ=;
 b=PR9LR3++3QTBASZudMyOGXHVHu58spzcaDhpG/3Zgg4i0SNzsQRrpoFgELBiH53vOEocXA9+v
 /FkJ/lGjlSZDojjsaQdfAfd+8YWMdP2uWlpedn5houvj/pq2Mgd7aIs
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: IhnEBdUbVbuM2TlhNQftYcqq3SqIbrCr
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfX6suzzhyDUcWG
 zFi6Dghh9P4YU9uRk42Hvg2lhySc/7qvh7n2obCnnlMB/NmmovLSoBk/yHcYx3+IlvfsAG5ohiM
 FjJUuuugDelmslo0CZU4jhkjV7tgj4T5N57fUuGeH37RCx3DDZTq
X-Authority-Analysis: v=2.4 cv=QfjzLcbv c=1 sm=1 tr=0 ts=6afb61d7 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=SFyPIUEspjz1PKPiGGUA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: IhnEBdUbVbuM2TlhNQftYcqq3SqIbrCr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfXwn95rc/pJGyo
 bogJOzU3HWG6w6Yu8UDcSgwIAD+Bgh8j2nDAUfm8l02E/DODyx+KSYGmO78HGOf/MPOGQ/p0dsx
 gfW+9MZ9ay+OYJzGfeAjrYQFIKz+o+JgFoS0MbYD6bEYi7jWQj4abW6xeGsTki+wSgz6j711FOC
 H/mwFxgL1V8QA3EbGI7YLhFkQ73QpA0SZ//FkFVN151HckWqiZHf1lbGyVvIvtMK2wD/SObfmf/
 5GkWjkm4nWJhhdvFvH+A0OzUM7Gqatnt+Fr1bklF1vkjv99X9sZqRe7k8rqJ4KGAYqKKF34YApK
 rKvDNtYiW5X6637kC65xsuBR7kJC9wREwnO86UjkGFOv3M2OToOm0WRrL7bAL5TDDENlvZZ71yH
 FEZtA+MsY1ygXkC2mNOW1GMzg9MjfRrwnHMotBvcw2hP2+tHI91lKpuImznwMbDHkxgqHL7fMs3
 XyPM3P7yPmeCPArlhYA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=10 suspectscore=0
 impostorscore=10 adultscore=0 lowpriorityscore=10 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160080
X-Rspamd-Queue-Id: 3D9EC80009
X-Stat-Signature: adu5zgnidihoon3iww3unqp1gywqbtir
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794859481-15260
X-HE-Meta: U2FsdGVkX1+ANzG9m7IYWCNnDN7WHdMZsG9EHS+WD1JSeruTnO6jgxfG6EqYs8cW2hQgJ6lxmOgXVfiUf+guDHUJ2HZeY/7Jr5XnLGkld4I+VrYBqRfQfv3GQFLukWRdv1IdENiCT7PK1tqhBec2AG2ZSL+4WX/cp2RrIxD6paIZiYKRIfybA0kKU+HXstAPGjneumXkz0I6hZY+P3zHUgSXKlsrjHTxOvLYgTQkR1a64KwlxiB4AgdEoY4nBOTRaJUQN8c+wwgaiHjtm5qvNVtR7PmN6vPNFCzMOP556/SjotwJy2T/HuA82JsVdGdIXrPe5VI719oF2C4GjIJbCnz5VD0awtRvB4oIc73dZ3SNdMllaz9EHOAQy4a+hXzwcAI2JXt3Ih6/1TrfZgbImt72jMrHiNdhKEyqWiaIvJ2UbJBYag3iMrHHSMoV/f6t05RbNO/nudvVc3UwJQtW+Lrd+WBzo2hTbNE7vV0sPsnKWaGu4eE8uo5q17HEXJbMoxmYWP051+zoI0yb7R0xrt12kBII94SObDnRroIm3Cu1RZEqF4E/KXAby16jMTFHlQZvf9nq/rGO8vbVsneNHud8y76yauScvaDn9SwVZd8o4GKjQG2GTepxiTWtPdJXfwvKsozm6MKxCWMMu7JMfhSi2A4qMs2wPc1b0qbxap59nQgTt7IUShaM0Riva86mhMcvFQ+t8SVMIcEENcZz1kZTQkmiEXGs2YdslvOfXJiGxx0sdAXc0pUbXA0uq7BcvtX3n4Eus9rRYnoaLM+Oozg5xvdVcd5FCKI2x4srt+XDCjiy7bIY0tJeNEE7yIvWnz7wQHUMOmebSzj+OkPIo0OnygW7szRzBP2Q3ThArD3rOTFNmCoPvk/TiT3nL99YKCyTxtrphbOZKSN36847yYr5xy1b99t1FOEBY7y7nxGYeWaPMaGG80NuueQm+naPTDI8RBo7/WVJhiGpln8
 9i902QVO
 WK09FhaL1iaH0mQy7cVmtBFUncZeGewt5Ba5cuunx9HvRbWXDxhxfSAzRWfMKgu6PghPPWXzE+92jV913BhUkerS/va5KO9Eqi/RLcpU1RMBn9aeU9vi9O/rdIsuxPpBHts2mXo9JsxxU+8MDvfBgxvnI3PJmCaImT7Cs/wk5qTVCYhH1/JIqnEo3igesSqmfJncAD3Le6dZTMwyZGfE2gXx/7ilsNEVgX2N27+3hs7KFGJcAqTKJFjXh240Ilgt/0fySdhKa9Rt+zNzAAno9/A3RIc+QpleQN+2jJvvB3WocHstjVWLtcDAV/JsGM5/w/ZW/OwLWIf5k0wF3iOwXVncbXxN1u7V+K1ZW9iO7eOo2EqB+jwtc7llg4jBlxd+5AoI9Rs51gvICLKzgr2w3ChwTYKi2MRVzjZbQ4rnodHOsxEmMAIACMQHrZdhOgOm8KYxQi7lQHto9u3szVPK/oW3Dphufz1cRFK400xFScLRYUgz2vA53VIWx6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

UFFDIO_REGISTER and UFFDIO_UNREGISTER both scan the VMAs of the range
before changing anything. For a hugetlb VMA, userfaultfd_register()
rejects a range whose start or end is not huge page aligned there.
However, userfaultfd_unregister() only checks the start.

An unaligned end only fails later, when vma_modify_flags_uffd() cannot
split the VMA there. At that point, userfaultfd_clear_vma() already
cleared the WP or RWP protection. The ioctl returns -EINVAL and the VMA
stays registered, but accesses to its pages are no longer reported. This
requires a caller passing a misaligned range.

To fix it, check the end of a registered VMA in the pre-scan as well.
The ioctl still returns -EINVAL, but no longer unregisters the VMAs
before the misaligned one first.

Fixes: cab350afcbc9 ("userfaultfd: hugetlbfs: allow registration of ranges containing huge pages")
Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/userfaultfd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index bf42fabb5afd..d8abc24353e1 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -3960,6 +3960,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 	found = false;
 	cur = vma;
 	do {
+		const struct userfaultfd_ctx *vma_ctx = cur->vm_userfaultfd_ctx.ctx;
+
 		cond_resched();
 
 		VM_WARN_ON_ONCE(!!cur->vm_userfaultfd_ctx.ctx ^
@@ -3983,6 +3985,15 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
 			goto out_unlock;
 
+		/* See the check in userfaultfd_register(). */
+		if (vma_ctx && vma_is_hugetlb(cur) &&
+		    end <= cur->vm_end && end > cur->vm_start) {
+			const unsigned long vma_hpagesize = vma_kernel_pagesize(cur);
+
+			if (!IS_ALIGNED(end, vma_hpagesize))
+				goto out_unlock;
+		}
+
 		found = true;
 	} for_each_vma_range(vmi, cur, end);
 	VM_WARN_ON_ONCE(!found);

-- 
2.39.5


