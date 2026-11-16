Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53905606A8A3
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=IpXx2n9+;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=eRxfMZfo
Received: by kanga.kvack.org (Postfix)
	id 0FF0A6B05B3; Mon, 16 Nov 2026 15:04:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D64E6B05B6; Mon, 16 Nov 2026 15:04:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F075B6B05B7; Mon, 16 Nov 2026 15:04:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B41C56B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B6CE1401C6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:28 +0000 (UTC)
X-FDA: 85442059416.23.1E2E367
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 75325100007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=IpXx2n9+;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=eRxfMZfo;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=x1GSlTdxCDOcwaCkl039quhS7jO/y0dxq7PSFe5uI1Y=;
	b=8BqWDYeL686n2tvXgtrPKWdUvbQrToVWs2FDcszCMvCoQJQ6q9kLVqCbv7zamWV00ZkEPN
	FA0yx3+qPEu32Mpq7yqa5aXGyr2RE/ssne1L70jRM+Z9HC5Ouk+Q2whqfx7ixewrpfjKAl
	u0jeUwq2ga5ilWKkUYlVVvHOIWSXbxc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794859465;
	b=HXjk6INY+f/J172vKFToPAY5CeWpgZWLK14YkZrbao60qklqt0UXurc6vY+NuxNgQ/k/Kh
	Ib1zv6RfDGOR4fvPLXBHkg7C7aUN7zr9v43DcQS+27xlK9YvVnC0HYLWNBORmQcnJiXLfa
	zDPQe8R9IPJp8y1/cpVPK3g309LqlOk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=IpXx2n9+;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=eRxfMZfo;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGJXL1q716052
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=x1GSlTdxCDOcwaCkl039quhS7j
	O/y0dxq7PSFe5uI1Y=; b=IpXx2n9+RamcocPRGOPd8XPboIKjiztrAkZU6DcuMR
	owrO1L9jYZPfd7Bix1u2o6xBqkvtiLeQSkquPaLF4IvEnS52FWTuHflsrx6FB9/p
	/B9pEuUxFFNQmGfo8VUZUjGlIsXMKi7dBRHWAdp+W2JfP1C5b+6ic5mq0PCMhvqr
	4E+5fohvAFveb7oCnY0baP2Zj2hHvARpdMapPW47/6QRXbCKyU17S9hVOf1jPaKE
	Eb+KHBWE58OnqIkTxmTlfbP/A9yuNf0uG0wB1tQUjv5iZi7SlNyV3zJ6lB6lyAJB
	NDxqTJoECbwU0nuSRrbFAXkldL6eVYJIxY8e7Knd+nDg==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j059qt4ft-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:24 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-55bb7f70b06so3709781cf.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794859464; x=1795464264; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=x1GSlTdxCDOcwaCkl039quhS7jO/y0dxq7PSFe5uI1Y=;
        b=eRxfMZfoGpa7YwqSZdcmXbbrD8/W+yu8n8P2zrFdqgyLJa3wlDvV/t89VxJO5iAX12
         u2tfhX2VlwSk3J4Xq5zqtr2uhaWgLkQ/ECyrhYVShlPcJ9+3t/9RMLZfaWOzWP6V5SXD
         DTwuVixttk5j3n4/ZFnqMWCpTTvbf91VdOBRJjugf40ynPWm5kr1ZVvkYPAWl6Qm8TCG
         3UmOjUVXXAfkpbono5SWwBrRwAV6wfIy7ihphCIth+9ysHKhnUxgl+gk50rtueu+1DaP
         xBNT9ainAO9ZCO+cY9YU57y+5Quxv+R9pm+5uAAdyAw1K5efR6nfBNNIqXQKBnXrmR14
         AdnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859464; x=1795464264;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=x1GSlTdxCDOcwaCkl039quhS7jO/y0dxq7PSFe5uI1Y=;
        b=2rJF5RaIQXCQto4sJ6jpa/zlqTI3u2IO3G4Ovs8EDdf2fKkhyfZ6O6c+7bkhJudmF3
         7YhZQxJyB28EyObP0HGjJvR/JzA/xhlyGpjNPcJKC2eqiSD0XaspOF+H6IKt2DCnFZHd
         jUGStpKZnG1vNq1iuoiO0QAKFqEruRZDE2MV/Kdxk0Lk+WEOSeUO3eMz2X1eBw14mrNz
         i8/Ov/O3/753MbSJU9mJnWUkY38+cLD/CFg4mDXnC7a3lCAWY9OwS2pxz2264BGHSU9d
         G5q2zowN54aClnh6iy5iLHnae+L0huxA+oAm3zTvHEajd5CZi7svvIeYf0OkVGRhbSyL
         cHqg==
X-Gm-Message-State: APuU4Z/SUnC1KqP3aFw5xA+DytXso8VVhLorip1l+Z9V8vFWHJnszkWe
	MkXScLYuejDnkBPm5hXAE6in6I+PJUWZuslwEoj9UM3gZHOcgX8IF8SO3TwhdL3nR9St9HXneDo
	Sou6C7foMEdT0qFuB3UHacOuy55t/A1brrQEturiFwW1cw/Ue
X-Gm-Gg: AYBFou3GTTWHKvQ3o4muAdk5ZUcenjPjKyJSshFLTFuWtd4DereWdGvnevQciyI9k9x
	CqwczFu4PiYb452BZFNKeXRs0li/tt5E19+Dwjbc5I03xrdmzzuJrRhTVmoCvTdqZRbRYXjdeC1
	qjsNAwEgFNxzevFqxDeS+fOaZ29+rZQpoM3djoOCpqlz/dtzk52XdLe/YKkAHWmhul2wtSPp8m3
	DJ+2dWh1+6XA+aXQHrVzPx875IHP6j2APJwdYs+qXkH3XeVQN44wXqEWLOl83qfPqLHYoKekRwW
	S6LFfx+M0dIlJT/Q2n1PQg5b2qltpLYiToNh6HPD7GBcAUuODllnO4wMPtM3tnAAfqnMbD3hJW2
	mz6PnzwwDiptGzzRpsOeJQq98pLnsJWbQu4vdz+a1wmoscNFMGkxJ/b/TEf602grKRyc+Mbi1TN
	9Jt/cD/fsUkJnAH52jrl/G
X-Received: by 2002:a05:622a:5883:b0:536:723f:5de7 with SMTP id d75a77b69052e-55d49300e66mr9489191cf.4.1794859463667;
        Mon, 16 Nov 2026 12:04:23 -0800 (PST)
X-Received: by 2002:a05:622a:5883:b0:536:723f:5de7 with SMTP id d75a77b69052e-55d49300e66mr9488661cf.4.1794859463022;
        Mon, 16 Nov 2026 12:04:23 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23efa2edsm93065426d6.15.2026.11.16.12.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 12:04:22 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v2 0/9] userfaultfd: assorted fixes (part 1)
Date: Mon, 16 Nov 2026 15:02:42 -0500
Message-Id: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGJh+2oC/2WNzQ6CMBCEX4X07JpuMQU9+R6GQ6GLrFFq+kM0h
 He3oDePX2bmm1kE8kxBnIpZeJo4sBszqF0husGMVwK2mYWSSiNKDanvLYRoIkHPLwpgFSKSMq0
 91CLPnp62IK8uzZdDam/UxdWzNgYO0fn39jnh2vvpEf/1E4IEKSssbanrY6XPnbunR8tmTzaJZ
 lmWD8zFP/bFAAAA
X-Change-ID: 20261106-uffd-state-fixes-d2111e2abd48
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
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>, Breno Leitao <leitao@debian.org>,
        =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
        Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794859460; l=4488;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Q9vtBat7EPzKier5uhGvIcHrOmBQit4JDniJ4SvUP3U=;
 b=PuIj7+LRsMk4tLVOsesIjArbol6E2+mE6zXf9UwUvZaWh2Se6zEfg4r4N9uXEER+0YOQl25l8
 ZbFg9uq1kztBgkEFbRdYqBvvGW1Tl6vFNKqc30ZQz4B5pydamoG5nJC
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=L/qI0OT8 c=1 sm=1 tr=0 ts=6afb61c8 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=bC-a23v3AAAA:8 a=zAoRp05x23iGVPMylqYA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: SRSBD-ha5D5NsOWq5asOGuTQEzGKmuR5
X-Proofpoint-ORIG-GUID: SRSBD-ha5D5NsOWq5asOGuTQEzGKmuR5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfXxp3wDTqD36XG
 /mgEZXYhi1CmRxP5ZoZzTQt1+MRN/M7THSzktQtHfIhUe3L3y2be5RXnC8Pp75nzMui9tUQIOqt
 Yd34H2a2KWyc0wW3ZgTMv28Sp0kSR072z7O2rhtpJOcrlWVJ5+By+p17FIVf048Ca+XRMGC3Xy+
 a9Jr3vFYt3JJ/YSnVcqpGjfEUarEUW6MO7OdeDBPyUZh9KDc+LUD6RH0z3I9DmQmr/R6Xy8ZWjc
 /dTnMiMJYoUpDFKIdxn+1cUiaFGE7AEsWGOP+afJRCF6VZJWcJaHsTY0Jp9Nem1uWPUC+TMccN2
 gAw5PtYX6I4sAVuqxm+Z5GGq3p0BIGBJTWf29VuV9lVmgfwuS/gARsSnPu8aOGaWAf9RW3vlw2U
 vCHVF8KZGFutBs4J3hGgo20+rpFwIZ9Xs27ckzgHsSQUB/UxiN5Vb6xO0Ci7agw2cr2E4ZI8wz+
 mWQDVZaiVHQPu2bouPQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfX72L2O61a4w6F
 /l7x/oMWnna+Uj3JqIZ5bnnPCirRmNInw0wGfnBDhtmD5OPpLZ40c3BzE8TZrYLmPvg1QHLcdN2
 767c9Q8426o1i8fzncklsV2yOFJHTSZAj/ZBeZ32q58dT50bAony
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 lowpriorityscore=10 adultscore=0 priorityscore=1501
 malwarescore=0 bulkscore=10 suspectscore=0 phishscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160080
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 75325100007
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ujr4gktw8co8tun9dg7u7se163dyayw6
X-HE-Tag: 1794859465-690842
X-HE-Meta: U2FsdGVkX18xdNsDZ4nek0JJE7ZcyYxPlyVCTEgYLpw3l6s6VPSNRW6NGhS+mxhksvosLyMkUTfSEkHyUKchIp2rn/13WZ1PRy/hGMYPK+FJSQmwpws0bUZ+fjf/njKv+IdNAIwVGa3KWuQyt7jhtMVfRrBeIUhwX+9/HdY9XRUbtvaPyR2Ja0C5F5qerUHTioz+VlOPqtb91R6x5aycscDofC/RnYiJE5A+In7nE024xewLugW4wGKXlhI4VJRCCnu0fg0Gn9Ab1gAbMshoyzb0vLJsQAndkduis9yoxeaqGAwo59JMeyn9Ka0CdoLBUFazs9+KlbUAb7oB4wjdWipnPA0tRwAt9VNc8WAZ+Ha4l4n8ZH6KFNqhNcDRNILcXg5F/+Ogagf1zr7ZPI/iwl74tLK8+5sLH5W4gapIQJMWFMs5u3TJMeUCInCUS6Tjofd0prh3B6lPpV7+r9M3n/smMAp21lSAgpASXgy5dHzqtJ/WmF/4LgR1VcES8a31huNLokbG9a4AB/kHqlZo+gAb0cvIUD3CiSEYC+LiWUyCZK6Wp2SXLmFq7lRW9KEId5MXBEkWUqc31YKOS+46cyLWp8DccyfhnOThX5Ay7+7fboQDzbd89afsXiZNiq37vdTYDjt45kfPtTbZWgAFi53Z8Xxn1Xa+kBQBfjPSf7egQUxGb8txFCEbHzVGqHwT5XjXDcpA5X4nH+bkBoDBfkNwC0UYll77ufs6u0twR07nD39to38jQB9RsdWRj/lQx0SK8Sz2zWUag63voN0pvJu8rN0KU5HYzkPDTWYkWU7NlQNky3g1ah3Qs/frHxUBus/ajK+wrI3TxfhBJEGKtHA+3K+QUH8prdZJ3hjNY4iHt1GMaL0VMQlb23fGZueGnLHdpYwXt2ewtelxa1ZEj7QVr542PyVc2JyjnkI+1r4bPfGq6EquVbCtncyE0BJNogeeFj37QWBvwBb/9eb
 OiRa6WAS
 yEqemwW4E8At7BHACjlaUZ0P8bdoF6kcl2AgYFZCBqYoY4mK3qKqHxfliSOIMV9XUWAb87EO1hQPJIN7d1FK/Bg9Payjhr677F+OemEOZxybe9CTpJVns6mZmR32JT88Ob+d9cKs9uwKrgoSlgJGRidaWMWo4QZmgOHqHlVSyfMecJOBqbflh88xBjBCX0cKIid4HVsnDxPd/Yf8aSgzJRMcbW3QygHdt2mE3ivKoOpKYnlSgh1kBlQBHrp38WyknK7YLS26zQbAG+XPopmlie9SxoOpfRa1zWIdPXo3/aHTcAX0kNIwjR7dzk4X76NMI/Cj23cr7n498oUCRHikaiGQdRU6Q5yyIzxObzNQU/lsFRAC4OX/2IeQCuVFVf9f1TKtXCFwVot2SUxcpsLiz5yqcZyfvxKgDUuUlmM+O0mEPhMOdFsc0NdHFZ+rwSmF8LtZyL82VhH4hf6bDdmqlBV1KpArrRyErViTXjUKkNN4KpRptYEy0bIoktR1ZorRlEGYkFfDqXhlo5wlJbxe8IpwDNH4G7mOtZ7y4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is a first batch of userfaultfd fixes, with more to come.

These were found by a mix of regular old LLM review and by having an LLM
write a TLA+ model of uffd interactions with PTE bits and other state
and seeing what issues fell out.

Most of these fix places where mm code loses uffd-wp or RWP protection
while moving or migrating an entry. Userspace then either misses writes
and accesses, or gets pages reported that nobody touched.
There is also a hang in UFFDIO_MOVE, and UFFDIO_ZEROPAGE modifying a
file through a private mapping.

Patches 1-2:   UFFDIO_ZEROPAGE and UFFDIO_MOVE fixes, cc stable
Patches 3-5:   PAGEMAP_SCAN write-protect vs. migration and
               device-private entries, patch 3 cc stable
Patch 6:       UFFDIO_MOVE of the huge zero page from an RWP source
Patch 7:       mremap() losing uffd state when a move fails halfway
Patch 8:       migrate_vma losing uffd state of a zero page
Patch 9:       UFFDIO_UNREGISTER with a misaligned hugetlb end

A few of the fixes change what userspace sees:

 - UFFDIO_ZEROPAGE on a private file mapping no longer fails with
   -EEXIST where the file already has a page, on an mm that cannot use
   the zero page (patch 1)
 - UFFDIO_MOVE returns -EEXIST for any huge destination PMD, not only
   for a present THP (patch 2)
 - UFFDIO_UNREGISTER with a misaligned hugetlb end fails before
   unregistering anything (patch 9)

Patch 6 has little user impact on its own. It is included because,
together with patch 7, it allows removing clear_uffd_wp_pmd().

Patch 7 adds spurious write faults on shmem and hugetlb after mremap():
when dropping uffd protection there, change_protection() makes writable
pages that were never protected read-only. UFFDIO_UNREGISTER and
UFFDIO_WRITEPROTECT already behave this way and lead to the same
spurious faults. This will be fixed in change_protection() in a separate
series.

Based on mm-new.

---
Changes in v2:
- Collect tags (Thanks Kiryl, Lorenzo, Gregory, Alistair!)
- Patch 2: say "softleaf entry" in the commit message, per Lorenzo
- Patch 3: add softleaf_is_writable() and softleaf_mkreadable() to
  leafops.h and rename the helpers to say softleaf, per Lorenzo
- Patch 3: add Reported-by and Closes for Breno's report, and cc stable
- Patch 4: explain in the commit message how PAGEMAP_SCAN set the uffd
  bit on writable migration entries, per Lorenzo
- Patch 5: use pmd_is_valid_softleaf() rather than open-coding it, per
  Lorenzo
- Patch 7: say "write faults" rather than "minor faults" in the commit
  message, per Kiryl
- Patch 7: trim the commit message, per Lorenzo and Gregory
- Patch 8: trim the commit message, per Gregory
- Patch 8: Cc the GPU driver maintainers and lists, per Gregory and
  Alistair
- Patch 9: use IS_ALIGNED() and a local variable for the VMA's ctx, and
  shorten the comment, per Lorenzo
- Drop the three guard region patches, per Lorenzo
- Link to v1: https://patch.msgid.link/20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu

---
Tal Zussman (9):
      userfaultfd: use anonymous memory for UFFDIO_ZEROPAGE on private file mappings
      userfaultfd: refuse UFFDIO_MOVE into a non-present huge destination PMD
      fs/proc/task_mmu: downgrade writable migration entries in PAGEMAP_SCAN write-protect
      mm/migrate: keep the uffd bit when restoring a writable migration entry
      fs/proc/task_mmu: write-protect device-private THPs in PAGEMAP_SCAN
      mm/huge_memory: build the moved huge zero PMD from the destination VMA
      mm/mremap: resolve uffd state when the context is dropped, not during the move
      mm/migrate_device: do not migrate a uffd-protected zero page
      mm/userfaultfd: check hugetlb end alignment in UFFDIO_UNREGISTER pre-scan

 fs/proc/task_mmu.c      | 42 +++++++++++++++++++++++++++---
 include/linux/leafops.h | 51 ++++++++++++++++++++++++++++++++++++
 mm/huge_memory.c        | 31 +++-------------------
 mm/hugetlb.c            | 27 +------------------
 mm/migrate.c            |  2 +-
 mm/migrate_device.c     | 23 +++++++++++++++--
 mm/mremap.c             | 46 +--------------------------------
 mm/userfaultfd.c        | 69 ++++++++++++++++++++++++-------------------------
 8 files changed, 150 insertions(+), 141 deletions(-)
---
base-commit: 67f3b04b277373438f17300e056306adbd9edf7b
change-id: 20261106-uffd-state-fixes-d2111e2abd48

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


