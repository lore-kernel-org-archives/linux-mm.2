Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C477FD45F1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C616B0088; Wed, 25 Feb 2026 18:44:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720346B0092; Wed, 25 Feb 2026 18:44:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4486B0093; Wed, 25 Feb 2026 18:44:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 458046B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:44:53 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3412C2307
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:44:52 +0000 (UTC)
X-FDA: 84484611624.02.020A95B
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6DBDC40005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:44:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=KoW+Dwoa;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772063090; a=rsa-sha256;
	cv=none;
	b=abbpqXYlHCWhDNWizPVeypGjTCSm505ZpeEEv9ZNkQTRzGeTpKufJJFbyQUQf9eofVsUXh
	mekG3YREo5IKT9yW50iDwszNt3LkImXskfe/kyEVqfdB02rH/Kl2XHZAh5ObUaqhwr2zqU
	/f3xjXCbjFlsDS1uQzG6NLgbD2PWDdQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=KoW+Dwoa;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772063090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPwSt3hNTFLah6XnifhLIiPsp4G0eC4H6I7+g5VD+/A=;
	b=HPt2Rv4plDiz1p45gR9ca0dPvIB+6sWW1YXygFnwtTzPmk3s8voBwrUNxKx2yrcJwt6QoX
	q6nR8Z62OkpC9ZwuZXtLN+0bEBLhZKEQy7gym9r5fdxB3a+x7NreR6pKew4DQDmbhxha5e
	stABbi8n8w8BSqcvnFuzc4rqsY61wj0=
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PNN9Mx1757003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:44:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=aPwS
	t3hNTFLah6XnifhLIiPsp4G0eC4H6I7+g5VD+/A=; b=KoW+DwoaLBgIKKp07zkU
	w6LYikbpCWQdrh8W1nzdyxYpkzLEcclQRcT7hkkJaTTe33MpHaIr+E7mV91Tq/bL
	SSiXdSa+Gguo6I/AW/mctmElGMAmkjDC+H2jI36BoHDA7GKVhEHL7OJPnGLlvEtT
	4BTdKWrcZuavMXt9r5oc/wjjaziypL86FswUmtKMi7y6Z6HU9iS0yuI9a8I+b0P6
	C+9RwDMULkiKD/iD9k3Sj1JnVFSLbkH0d37CIXOpEzab4zAj7ZLAs5c42CcZAvY/
	y6VP7ocVtll9BIBDwonFGbm0jimM+NTHDOvcuRroLMGuOZKT2Zb5ZQ5D6pO86jQn
	BQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4chxa0pea3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:44:48 -0500 (EST)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8c881d0c617so125048385a.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:44:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772063088; x=1772667888;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aPwSt3hNTFLah6XnifhLIiPsp4G0eC4H6I7+g5VD+/A=;
        b=geH12e3LHnLfO4mJGVMoieuNIhGLy/Jr98lHGXb3US3OqK1mIUjfplzZqMpBzDS+65
         1/7Bvmnwc95AUs2l8Lb6+xh7u5m1Fi9NuB83KFRxTtNLDwYQHsZBfDI65ry9/GSBohLF
         4b7JO4NpsXHzfXu/EO5lsdPayUJNo58MnpJljulQovBafp8PzBUlEyE7nY0c0YpYDNMg
         TQD3VgUkjzIiVyqiSi/guKsJ2PixCQkH8njxtMoC+KPKnXpWAzAt0F0r1YKFAfJpIZq5
         mpUefxk4Pqgx6E5ZjFcKNuEtxf4H/o33GppCJ4iuBONZ41kDtU36NbFC2Exf4T3Y+LeF
         /q0g==
X-Forwarded-Encrypted: i=1; AJvYcCVdvJktTrTHN1wHQpBN2c2B5/82jcLfRCV6A6JU04Ttk6M7SkjjO2mdQkr98sDtvwbXZ8KCNcltqg==@kvack.org
X-Gm-Message-State: AOJu0YyYhWEsTv67BSvqWPutdiDhYBT6Ja/PT8AYH+KhQadaixqjeDwn
	YvyjZ7MurF7Q/B4qbvlzqDr9IP1KSpYAnR+aqO06W+lBDHLyIEWom+cRDl48nrK5sbGry/b5mA8
	7AuJkRVJ7WfiX3A4JMzvyVpHShaoZgcZMB1sPW+jxsnKvZ/HN
X-Gm-Gg: ATEYQzzYYRfGXErWXvhJVtwDRe+FtvBh4hxKg7W30P8A14a2vHgYk8xODHX1SXzz/Pn
	dvFaelI7PS0NPCpB2Z1+EAFIr12rALMeZt0TRjhqPIBciGa1cVYHLpZ0maciPl5R5Js0PJw8kqD
	0y+urcLcd1hEADQv+hBlgJ8AIkWFhqdl+kI401Hw12v5gYAtZHt6fPvQERPAJQIv6R2WTvatoen
	v4chZ/ns2FQa3XNJxtABdGZoSNEW0jJO1FVqJJMuqzy8l3EID9UE21ISQAFQvwaZ7AHhyfFjeS+
	bzqcJZHQVl/MKEDNrSCwwd8G5j2mwSimyuZMPQdE/5YAATqwyF8JPqtKkd+442Bzjseir3VslHv
	DWXzuHWBSxXkjpMBV63R0mNB3ViLt4Hk5
X-Received: by 2002:a05:620a:298c:b0:8ca:d5cb:6844 with SMTP id af79cd13be357-8cbbcff7196mr323693885a.49.1772063087680;
        Wed, 25 Feb 2026 15:44:47 -0800 (PST)
X-Received: by 2002:a05:620a:298c:b0:8ca:d5cb:6844 with SMTP id af79cd13be357-8cbbcff7196mr323686785a.49.1772063086986;
        Wed, 25 Feb 2026 15:44:46 -0800 (PST)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c738d80bsm3357606d6.41.2026.02.25.15.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:44:46 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Feb 2026 18:44:27 -0500
Subject: [PATCH v2 3/4] folio_batch: Rename pagevec.h to folio_batch.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260225-pagevec_cleanup-v2-3-716868cc2d11@columbia.edu>
References: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu>
In-Reply-To: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu>
To: David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        Paulo Alcantara <pc@manguebit.org>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
        Bharath SM <bharathsm@microsoft.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tursulin@ursulin.net>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Ilya Dryomov <idryomov@gmail.com>,
        Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
        NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>,
        Dai Ngo <Dai.Ngo@oracle.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>,
        Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
        netfs@lists.linux.dev, linux-nfs@vger.kernel.org,
        ocfs2-devel@lists.linux.dev, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org, gfs2@lists.linux.dev,
        linux-nilfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        cgroups@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772063077; l=17408;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=89ejBUbJAbl9gMJxu0YjzDjYEINzrXDJ4zlC90ZjW70=;
 b=DZR7t8/xTD2RV8IcGDVSrVRbyHqSjvi+mmPKtQKoMAq7YXgwLRBOLtA12ryjIBbsZ8xRvPgOR
 iq+s155nXzBDa4/nkNXPNn2pWi+s7DCbvZYs9/y3NwEhX5dVRbKSlDM
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Csiys34D c=1 sm=1 tr=0 ts=699f8971 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=1-S1nHsFAAAA:8 a=37rDS-QxAAAA:8 a=VwQbUJbxAAAA:8 a=_gStYsYcyfV-qr5JuIkA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
 a=gK44uIRsrOYWoX5St5dO:22 a=k1Nq6YrhK2t884LQW06G:22
X-Proofpoint-GUID: VsdAD_j5P0oqpN4USiTqVte70M67IrMk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDIyNyBTYWx0ZWRfX7jUoZSZM6xXA
 EEKY2V+lQkVj8jxDxfNhDBh6V63MQ4uAxA65yfiQKm5MzGQDY9Ori+HtgXSkPtQz5a70N5FIHAQ
 dwzV0iFcMPkEg65UB/siNoWG/U/gcYh6Iq4Wh5eVW2uDKwV3S/+ibY4PaIIccKYcIutpjIPFjob
 YADnf7UTkGqfra+q/5nARGKpY4SaDG/tcKp3LD2TOEG++9quM4GEKv/5NB0BNWoE8yHzeOlvHFR
 e312r6U3UzqW/PvWma3aul6ZCasbYrlakj8etLRK7kJiIVrTWWjsRbsVvYtZHuLh2aYZEIEKI2E
 ZTW3I7VmD3jHStCZeAU1/NxsLdDtE8ME5fmVnIH0MxQk01cGfJgIDydmG5MFppq0dGeI6+JLAFj
 WkhpInO8pcWrCeOGTtTlsc/91D03vWE2dwMyYodaZ591z/NzIDn2EahcrhX51JLyfKJF2Ez5xzU
 s1Xa9xNGHVgB/b7LppA==
X-Proofpoint-ORIG-GUID: VsdAD_j5P0oqpN4USiTqVte70M67IrMk
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11712
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015 lowpriorityscore=10
 impostorscore=10 phishscore=0 suspectscore=0 bulkscore=10 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602250227
X-Stat-Signature: 7upmekwmm145gypch73xjxng8wrfigde
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6DBDC40005
X-HE-Tag: 1772063090-26936
X-HE-Meta: U2FsdGVkX1/BhjN8nDLaFJgvzH9wa2BFUOpJp1QDeK0Nj8mQ1DTno1yjjioeLaQftjb6KYR9rxOJZ/rB48G7TLJMBxmmALJ6oyXxh0/umJkA8OnOiEvHRXUhcC/1e3pMUX2v/dathxBwDPAQ5i+Ay3Aukl1FIzp6UaLnN4OyM8awcWARNg+dCNa3i7KnsGp+4T70tATizwbSrqDmgbTTY+H6fmT2Xdjinx1irWFAdPyM9LA96XnS/TVVTGFIWUJNzyvV9HMOaRnC8jdu8SmhIMGLVpvaSx75P5JUhYjHSGWQ93PVGtX94+CzkrEAOy8unt/a4SPHeyfkZlnlx6qYc63wQSCDAwKOtvCKKRmQ5+JfVxLWCAeVcsuW9tD0t7o+cF/7NOKhbctJnPuHzKiRF1m+j4q7hFSHCTzsfSVoy5nR4Wqf6E6AZTEJkYuJ+MzhPQ9cOBcXM1T636Vl2zwWNN6hg2N8eSsrzjMY3fsvu+ErKU4vzrL/GR/h4ANflDgK0OF7GAY91BmjKNts//ZHNSqNtfBMWYlUwTDaYxDVDpP670egKP5FkN0/VTcn9A/qFdsn/nGBh+PYcJxv9KPPbwdCgZhm+XgWjuiV3ed+HuYPNxQEUtCsyU7gxbhiUYUTYvGRBpJhwosj9R1VlLlX2Y3+BmEyUMF/x5W0R2Et0hJsGXRAPYqrSua2/4mSPfZoIpwct5LPk3yK35ZwnIZjDUnPzslHB7YvxoCas/7kedPZjmK7ZIJnd3qTgMopltDZrGloNhGyGGS496Znd2/UZh5Kp/TghlYFool743Oa1ghpsDb4yi07a8QvpuJ32SPQQIatP4+ECpan9FTVRb4epFPE3rtPhFMISSYqoD1iM6AZt3MBzVpb43EP06Zy/cdbPaZY5dU37WIldkLLyPSQw8sejaZZlYKFGnf7UoT59U5G3f7mVz7H+5Dgnf0ej0JSmia7HCIWdDC9lqAAvNn
 3vhR18L7
 xS6cwmU6qsqKXv144z1Jr2BlsGGEh80MFYJcYZfnASksyx793JQPvx5BY6DqvVXVXfpCI6LZqEF00k9DjvaESruE4ph9ljnOS4cuoOCwbeJFMrEKqJo+j8Izi6wV+v0nTidXj4lEOqH03X++Xw+MZOOXUADWadmUKHbzBdng/W0BWtrzuAje4ag4TL19l6nHdsDYX2nW2TA9yahaNYUHkexDNc0+kXEoPKYX7in2cwbPtT+DKQkHnlpn82ZtOm8WZGz1Al5nZOZyF7H1gP5wBDqUJFssymUYq6fQyIlubB1Kh8XOciT/nieZUkyI9UgokLusPjUbLRIahfvOmk/S/GQH1ZqIbAKP0bbYkGijT6pcpQV+Vh5DbVx/es6hquaagQU9fDDhEpXV14lBWJke7C/ULNSsOMG2Zf0koNvIKjZd+ieuGCzd3xkUyGQMPCCjdqyqWGYRhfXPvzkp4F+dio/mG0G4VzxmnfiKLLOMVkhqBv5Gt3e3HXummulfxgLr5e1F7v/KjXEh/MthZ9Uhgq/6DESEbKJRz2KL5FeTXDX7iIqGSDPw+j4KXJmR1a/+ZD1dM2yp12zRzSnf8NSlxXXLUP0GdXG+9PBy3UhJWGuI6iM8uXmCiHaRuIV+7N5OfPSdycB2J19Mlz0KtjPWeaof3a9fDIOZ0ihV/7yrOBJRbwlpl6YwFZXAHOEYe46Q+YcIwXQhGowb051P0oSN9Bh0q+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
pagevec"). Rename include/linux/pagevec.h to reflect reality and update
includes tree-wide. Add the new filename to MAINTAINERS explicitly, as
it no longer matches the "include/linux/page[-_]*" pattern in MEMORY
MANAGEMENT - CORE.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 MAINTAINERS                                | 1 +
 drivers/gpu/drm/drm_gem.c                  | 2 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c  | 2 +-
 drivers/gpu/drm/i915/gt/intel_gtt.h        | 2 +-
 drivers/gpu/drm/i915/i915_gpu_error.c      | 2 +-
 fs/btrfs/compression.c                     | 2 +-
 fs/btrfs/extent_io.c                       | 2 +-
 fs/btrfs/tests/extent-io-tests.c           | 2 +-
 fs/buffer.c                                | 2 +-
 fs/ceph/addr.c                             | 2 +-
 fs/ext4/inode.c                            | 2 +-
 fs/f2fs/checkpoint.c                       | 2 +-
 fs/f2fs/compress.c                         | 2 +-
 fs/f2fs/data.c                             | 2 +-
 fs/f2fs/node.c                             | 2 +-
 fs/gfs2/aops.c                             | 2 +-
 fs/hugetlbfs/inode.c                       | 2 +-
 fs/nilfs2/btree.c                          | 2 +-
 fs/nilfs2/page.c                           | 2 +-
 fs/nilfs2/segment.c                        | 2 +-
 fs/ramfs/file-nommu.c                      | 2 +-
 include/linux/{pagevec.h => folio_batch.h} | 8 ++++----
 include/linux/folio_queue.h                | 2 +-
 include/linux/iomap.h                      | 2 +-
 include/linux/sunrpc/svc.h                 | 2 +-
 include/linux/writeback.h                  | 2 +-
 mm/filemap.c                               | 2 +-
 mm/gup.c                                   | 2 +-
 mm/memcontrol.c                            | 2 +-
 mm/mlock.c                                 | 2 +-
 mm/page-writeback.c                        | 2 +-
 mm/page_alloc.c                            | 2 +-
 mm/shmem.c                                 | 2 +-
 mm/swap.c                                  | 2 +-
 mm/swap_state.c                            | 2 +-
 mm/truncate.c                              | 2 +-
 mm/vmscan.c                                | 2 +-
 37 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e4572a36afd2..f50421e65cb1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16664,6 +16664,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/folio_batch.h
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
 F:	include/linux/highmem.h
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 891c3bff5ae0..dc4534fb175c 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -38,7 +38,7 @@
 #include <linux/mman.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/sched/mm.h>
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index c6c64ba29bc4..07025b547c94 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -3,7 +3,7 @@
  * Copyright © 2014-2016 Intel Corporation
  */
 
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/shmem_fs.h>
 #include <linux/swap.h>
 #include <linux/uio.h>
diff --git a/drivers/gpu/drm/i915/gt/intel_gtt.h b/drivers/gpu/drm/i915/gt/intel_gtt.h
index 9d3a3ad567a0..b54ee4f25af1 100644
--- a/drivers/gpu/drm/i915/gt/intel_gtt.h
+++ b/drivers/gpu/drm/i915/gt/intel_gtt.h
@@ -19,7 +19,7 @@
 #include <linux/io-mapping.h>
 #include <linux/kref.h>
 #include <linux/mm.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
 
diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/i915/i915_gpu_error.c
index a99b4e45d26c..ffe5f24594c9 100644
--- a/drivers/gpu/drm/i915/i915_gpu_error.c
+++ b/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -31,7 +31,7 @@
 #include <linux/debugfs.h>
 #include <linux/highmem.h>
 #include <linux/nmi.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/scatterlist.h>
 #include <linux/string_helpers.h>
 #include <linux/utsname.h>
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 790518a8c803..dbc634d10ad3 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -8,7 +8,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
 #include <linux/time.h>
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 744a1fff6eef..c373d113f1e7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -11,7 +11,7 @@
 #include <linux/blkdev.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/prefetch.h>
 #include <linux/fsverity.h>
 #include "extent_io.h"
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index a0187d6163df..b2aacf846c8b 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -4,7 +4,7 @@
  */
 
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/sizes.h>
diff --git a/fs/buffer.c b/fs/buffer.c
index 22b43642ba57..f3122160ee2d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -45,7 +45,7 @@
 #include <linux/bitops.h>
 #include <linux/mpage.h>
 #include <linux/bit_spinlock.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/sched/mm.h>
 #include <trace/events/block.h>
 #include <linux/fscrypt.h>
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e87b3bb94ee8..2803511d86ef 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -7,7 +7,7 @@
 #include <linux/swap.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/signal.h>
 #include <linux/iversion.h>
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 396dc3a5d16b..58f982885187 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -29,7 +29,7 @@
 #include <linux/string.h>
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/mpage.h>
 #include <linux/rmap.h>
 #include <linux/namei.h>
diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 6dd39b7de11a..0143365c07dc 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -11,7 +11,7 @@
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
 #include <linux/f2fs_fs.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/swap.h>
 #include <linux/kthread.h>
 #include <linux/delayacct.h>
diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 8c76400ba631..614e00b8ffdc 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -13,7 +13,7 @@
 #include <linux/lzo.h>
 #include <linux/lz4.h>
 #include <linux/zstd.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 
 #include "f2fs.h"
 #include "node.h"
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 338df7a2aea6..90e8ef625d82 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -10,7 +10,7 @@
 #include <linux/sched/mm.h>
 #include <linux/mpage.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/blkdev.h>
 #include <linux/bio.h>
 #include <linux/blk-crypto.h>
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 74992fd9c9b6..ba0272314528 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -10,7 +10,7 @@
 #include <linux/mpage.h>
 #include <linux/sched/mm.h>
 #include <linux/blkdev.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/swap.h>
 
 #include "f2fs.h"
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index e79ad087512a..dae3dc4ee6f7 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -10,7 +10,7 @@
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/mpage.h>
 #include <linux/fs.h>
 #include <linux/writeback.h>
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 22c799000edb..2ec3e4231252 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -25,7 +25,7 @@
 #include <linux/ctype.h>
 #include <linux/backing-dev.h>
 #include <linux/hugetlb.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/fs_parser.h>
 #include <linux/mman.h>
 #include <linux/slab.h>
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index dd0c8e560ef6..b400cfcdc803 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -10,7 +10,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/errno.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include "nilfs.h"
 #include "page.h"
 #include "btnode.h"
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 56c4da417b6a..a9d8aa65416f 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -14,7 +14,7 @@
 #include <linux/page-flags.h>
 #include <linux/list.h>
 #include <linux/highmem.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/gfp.h>
 #include "nilfs.h"
 #include "page.h"
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 098a3bd103e0..6d62de64a309 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -19,7 +19,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/crc32.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/slab.h>
 #include <linux/sched/signal.h>
 
diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 0f8e838ece07..2f79bcb89d2e 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -14,7 +14,7 @@
 #include <linux/string.h>
 #include <linux/backing-dev.h>
 #include <linux/ramfs.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/mman.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
diff --git a/include/linux/pagevec.h b/include/linux/folio_batch.h
similarity index 95%
rename from include/linux/pagevec.h
rename to include/linux/folio_batch.h
index 007affabf335..a2f3d3043f7e 100644
--- a/include/linux/pagevec.h
+++ b/include/linux/folio_batch.h
@@ -1,13 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * include/linux/pagevec.h
+ * include/linux/folio_batch.h
  *
  * In many places it is efficient to batch an operation up against multiple
  * folios.  A folio_batch is a container which is used for that.
  */
 
-#ifndef _LINUX_PAGEVEC_H
-#define _LINUX_PAGEVEC_H
+#ifndef _LINUX_FOLIO_BATCH_H
+#define _LINUX_FOLIO_BATCH_H
 
 #include <linux/types.h>
 
@@ -102,4 +102,4 @@ static inline void folio_batch_release(struct folio_batch *fbatch)
 }
 
 void folio_batch_remove_exceptionals(struct folio_batch *fbatch);
-#endif /* _LINUX_PAGEVEC_H */
+#endif /* _LINUX_FOLIO_BATCH_H */
diff --git a/include/linux/folio_queue.h b/include/linux/folio_queue.h
index adab609c972e..0d3765fa9d1d 100644
--- a/include/linux/folio_queue.h
+++ b/include/linux/folio_queue.h
@@ -14,7 +14,7 @@
 #ifndef _LINUX_FOLIO_QUEUE_H
 #define _LINUX_FOLIO_QUEUE_H
 
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/mm.h>
 
 /*
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 99b7209dabd7..4551613cea2f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -9,7 +9,7 @@
 #include <linux/types.h>
 #include <linux/mm_types.h>
 #include <linux/blkdev.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 
 struct address_space;
 struct fiemap_extent_info;
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 4dc14c7a711b..a11acf5cd63b 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -20,7 +20,7 @@
 #include <linux/lwq.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/kthread.h>
 
 /*
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index e530112c4b3a..62552a2ce5b9 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -11,7 +11,7 @@
 #include <linux/flex_proportions.h>
 #include <linux/backing-dev-defs.h>
 #include <linux/blk_types.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 
 struct bio;
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 6cd7974d4ada..63f256307fdd 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -31,7 +31,7 @@
 #include <linux/hash.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/security.h>
 #include <linux/cpuset.h>
 #include <linux/hugetlb.h>
diff --git a/mm/gup.c b/mm/gup.c
index 8e7dc2c6ee73..ad9ded39609c 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -18,7 +18,7 @@
 #include <linux/hugetlb.h>
 #include <linux/migrate.h>
 #include <linux/mm_inline.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/sched/mm.h>
 #include <linux/shmem_fs.h>
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index db59fad3503f..51508573963d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -34,7 +34,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/vm_event_item.h>
 #include <linux/smp.h>
 #include <linux/page-flags.h>
diff --git a/mm/mlock.c b/mm/mlock.c
index 2f699c3497a5..1a92d16f3684 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -13,7 +13,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/pagewalk.h>
 #include <linux/mempolicy.h>
 #include <linux/syscalls.h>
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 601a5e048d12..1009bb042ba4 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -33,7 +33,7 @@
 #include <linux/sysctl.h>
 #include <linux/cpu.h>
 #include <linux/syscalls.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/timer.h>
 #include <linux/sched/rt.h>
 #include <linux/sched/signal.h>
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d88c8c67ac0b..74b603872f34 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -31,7 +31,7 @@
 #include <linux/sysctl.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/memory_hotplug.h>
 #include <linux/nodemask.h>
 #include <linux/vmstat.h>
diff --git a/mm/shmem.c b/mm/shmem.c
index cfed6c3ff853..149fdb051170 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -61,7 +61,7 @@ static struct vfsmount *shm_mnt __ro_after_init;
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/percpu_counter.h>
 #include <linux/falloc.h>
 #include <linux/splice.h>
diff --git a/mm/swap.c b/mm/swap.c
index bb19ccbece46..2e517ede6561 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -20,7 +20,7 @@
 #include <linux/swap.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/init.h>
 #include <linux/export.h>
 #include <linux/mm_inline.h>
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 32d9d877bda8..a0c64db2b275 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -15,7 +15,7 @@
 #include <linux/leafops.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
 #include <linux/migrate.h>
diff --git a/mm/truncate.c b/mm/truncate.c
index 12467c1bd711..df0b7a7e6aff 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -17,7 +17,7 @@
 #include <linux/export.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/shmem_fs.h>
 #include <linux/rmap.h>
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7effd01a7828..7e921dbe2373 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -44,7 +44,7 @@
 #include <linux/sysctl.h>
 #include <linux/memory-tiers.h>
 #include <linux/oom.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/prefetch.h>
 #include <linux/printk.h>
 #include <linux/dax.h>

-- 
2.39.5


