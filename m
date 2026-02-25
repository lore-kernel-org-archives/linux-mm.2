Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD68FD45F1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815156B0089; Wed, 25 Feb 2026 18:44:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC146B008A; Wed, 25 Feb 2026 18:44:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689CE6B008C; Wed, 25 Feb 2026 18:44:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 553256B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:44:45 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4AAB568CE
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:44:44 +0000 (UTC)
X-FDA: 84484611288.02.38BE59A
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3C0984000F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:44:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="NZaA/URT";
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772063082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=05jgbknsbqZP1uCdgxmv7u4HMptdcfek0XZsU81eJwo=;
	b=JHZv9zxSg56coj6Tge5W9ufzUV5wfzM9PnjW2miGDs4QK/wJjiOnp2VzAzzwbAUv+olrCV
	kIhDLRnrB1gb+zNfxeXkzGOUCIbfnZ77d0mC2pPZ7LlxIe7OXRV8zMxJMpYrIiS3GGQSPD
	PTxGooQTIsCgibqKE2f9OgPGmPHE/fQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="NZaA/URT";
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772063082; a=rsa-sha256;
	cv=none;
	b=SxTKf3ZweVbtPQJ+x953oe+TdFMjwa+zxYkDf4gnSOY3gGC+3jEWr6MqCOogkMZ6uF8P8v
	LW5WG6DRJ/e75YrrWeMsLXzFG25Do/ux7EZ8ha9EObn0cdRg1SR44EZVlXaGXjNYoEUHl0
	sE/XdB/NbA+EAUJwhLrTO6JOfdwUEag=
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PNN6cr2722856
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:44:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=05jgbknsbqZP1uCdgxmv7u4HMp
	tdcfek0XZsU81eJwo=; b=NZaA/URTtN755x3xQdd19/fuZUZtYv1FQpcevc3XwH
	GiJ5HRxGcY9iy/OYljXRxusFlBguMsPnyZDcmgj6ga3FB3ZEB6s8V8MYK1RQkRqs
	73E3y2Il0kMvjM1FeCKvErS6Ge1o+L/OrnSKHrzy/0gMDrz4XGhlptm9EW5EZsiN
	KbNXNDLUxHRAHYoImMhwtPfSo5MKLD5TPNctjPWYbFCDuzg3+QLXfj4h+8nzvl+h
	eF35anfVfxgICHTPN/s3s6nvmvXB97+RSUwbstEdYahxR2kI4oqGBDlsjZPhkjFA
	35Gntn163Y2SMifNAIheBj42FBACqKtXgkrnpRQmM3NQ==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4chv4nxm8b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:44:41 -0500 (EST)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-899b6a1a557so27055326d6.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:44:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772063080; x=1772667880;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=05jgbknsbqZP1uCdgxmv7u4HMptdcfek0XZsU81eJwo=;
        b=BDkiGh3CjQ1XdZdr3X5uAkcws80sHdqx/oLoXiNG66EqGUo29mHcAAFbyIH8M1fHVW
         sCmzkMo6UxCiiaX8u1ZvvDg+Xjo/DvR1CNPmwjWHX1xoVXA/vsB1i2CisYLIlaQV53/T
         21hxGyXbwIGSe8gnsiD+6tCxqFOrF6z7ISzB5mEwNjAwAKihRyBpooUQ20YE/fE2GfeY
         pH+vkKsIk7IjqTYs8oXqPzlOR1htpkizJMEu4FnKnQ5o3QFraNjj/Vhg72IOd5MAn7Ag
         3IWUaxGMaMYOYY5rox87aMphbP1DEfDS+63J9aXGXzaGiGr94PmJ9mDeCP+bPQf7A7SK
         Gukg==
X-Forwarded-Encrypted: i=1; AJvYcCUDxOOjLW6xXttxvpyNGb1nQZswnWk5rta4lvuh0ciBwZ/RfCWnfAq7VMgbga4NBm9aOmSPNT+3Kw==@kvack.org
X-Gm-Message-State: AOJu0Ywk3WmX8wPDvlb24BG3/LuG0Nz3U/bbzlY5L0CaFnNbvtNjZEWF
	cp6u4JHIJG1kCd7VJGPU5ZfVNo9sMvJF228MG4gm9Uht4YX4UGTHeEACDYGtK3a51WvmSrLsxV0
	ULQ3VITgpoUa5sfKMJS7lG90+KFYeicwhq2+NX4ZFyRsQt6hf
X-Gm-Gg: ATEYQzxTuUtOoDuPvinl3rltnaI+AEFnV0y4Oc5hD9niCZjlQUJMnG1awx0f5kKCNQP
	JBEBrQqi3PI47ea+Qebno3iWDTLUmpBYQVc/bt43k7NG+jjB/ASmuPmjWlUqd7fmpe7p0yVcd0O
	nuAQZxqAuLVTqi8uMIujBZ1BknhjXZcKeYUQmwMDd96NtqUQlIelWAntX/AQdLJogInNw80LqDf
	4c/FXHS9w9y8zEAGb5aKgJ9rRqFdAM7HkL0QlukYo2rgDfDIepWXhxY9xf5k0yS8eWPZ8LtCMMc
	kwS6hY9YvFmm8DaKrmXwOcdjsym8lnxJGvwycBk7JeqGdXGd5YHNsE8esV1WMNziclaKXoTtck5
	QdIrtffGhuIo3KyiZjLfN9JBpGAGtBZo3
X-Received: by 2002:a05:6214:4387:b0:894:663f:cb4b with SMTP id 6a1803df08f44-89979e31f4amr253354536d6.7.1772063080158;
        Wed, 25 Feb 2026 15:44:40 -0800 (PST)
X-Received: by 2002:a05:6214:4387:b0:894:663f:cb4b with SMTP id 6a1803df08f44-89979e31f4amr253353936d6.7.1772063079588;
        Wed, 25 Feb 2026 15:44:39 -0800 (PST)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c738d80bsm3357606d6.41.2026.02.25.15.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:44:39 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v2 0/4] mm: Remove stray references to pagevec
Date: Wed, 25 Feb 2026 18:44:24 -0500
Message-Id: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFiJn2kC/3WNQQ6CMBBFr0JmbQ0dsBpX3sMQU9oBJkFoWttoS
 O9uZe/yveS/v0EgzxTgWm3gKXHgdSmAhwrMpJeRBNvCgDWqGvEknB4pkXmYmfQSnbDt2Uhl+np
 AC2XlPA383ov3rvDE4bX6z36Q5M/+byUppGguhNiqRjUWb2ad47NnfSQbocs5fwEZhc9ksQAAA
 A==
X-Change-ID: 20260225-pagevec_cleanup-d47c16cb0f2d
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772063077; l=3877;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=RPYa8SOtCEMGYvfhLiG7oMZP0LUGjYMFBvMU/E6aYSQ=;
 b=N/1edh2L6XTHkwD9ieSfOXn9kYa5DYTkRpLgb6W+Pjo3fqU/OShuTpJ0EUyLfSHC66PI9wcY+
 BU8+4Nx0zdtBWryBzWRqlHj5gGJzMg+bWxBXZztU9BaHETUf5RWJ+Bm
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: eNC6Vb8clfb7LNm65S3WmTgde7avTjS9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDIyNyBTYWx0ZWRfX2Sbx1pvbo9Le
 6MZbcnHLwmMbOR8ljaMlqJ5220Tj15Udcrr2fZmak8r1gM++DAcin8thR6bP/GkR/uwiKVf0tzW
 oXqJRJAS/u1qKu+8xJ5mhFpbXPYmuBIiCWChglemEleg200MoIwhMBjQl+GRwPsE41jkgTf4jso
 i1Y61bKJR9OJWPtmOx9OB9wRP3nh73RP3Oj97UcV5H0E9PGJWMB4IfEFzgudwVV2XqcVdqt7DB2
 NwPVfdJWZnY0atRXqcuaa/bHKwD9TrgEh+2cN31fQ7+lO8Z+sc69oHydjQr+JAB1XX3hGv8raby
 oJKuvERPzmZuKEo1AZoeUgXcoF0e5fnm6qmblkqXvN3NzUUAMq7xFIRXM5yBgHsTA3hQAGI0Ahc
 IMbpbouXW+/5334mHmw2s3i1ATL0cm5j8z6jQASPugOAv+v/q08KU5CJO8gV9IV/HvPbyjnpooa
 Dyk/4M2uh3l4jPP8USQ==
X-Authority-Analysis: v=2.4 cv=Cr6ys34D c=1 sm=1 tr=0 ts=699f8969 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=VwQbUJbxAAAA:8 a=C2eTfLYCeeefI48a-yAA:9 a=QEXdDO2ut3YA:10
 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: eNC6Vb8clfb7LNm65S3WmTgde7avTjS9
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11712
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 suspectscore=0 adultscore=0 spamscore=0 clxscore=1015
 bulkscore=10 phishscore=0 priorityscore=1501 impostorscore=10 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602250227
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3C0984000F
X-Stat-Signature: bxganunu7tnfzq7m38piqogs5pfa95nx
X-HE-Tag: 1772063082-293045
X-HE-Meta: U2FsdGVkX18w/i4qPnndzkQ08EYtp9jed9sg7wV0txKCATUcbH+EoXqewNI+kCRw3m5t/5UVd0FEgZf7SJNma84vEUdURu9sDA5Q5XbNArQz3zWLfFe4O4b1WLYIVXeIEAa/g2x7Y4RrzTd48htEoz3PwQcLhuNoWc1BOTGJ4RxSnD9V/Y6gs57dQYFAcroxYFvSlHwlJ7g3VBmN9KXJU4xwiwm7WGiJhNsqVFr5l3NNGq+RxlGETl3WpBHIFXC+sVYu3DGYF6V1XCts29cHCeVedLrn5jV2x1Hza8lSpD0SNo+ijA5o5e8nO05eibBhNy862TrmWcegz2dXeLiP2drHqG0Ij4f5NnQXZAzPDSCp0Soy025aWu71KAqymw8Qfpm+YdgSqfPr0S+cVtUfOGBC0E0YbTKhppCJZg8o1Sp2IoIi3LUiNnHBffhLOMyFfsn/38zADEO7KW4USAbMcwqWJaqESiwP36oGz8vuZ8fMPAAkzol3gNeObr+v9wBKgs5X780GQkCvRJMod1VO68ifD38kdT2JaXZZGmYxDEHnBy+K84FQwgwEQJDE7KhJ+mrkzU2LIDWbjxQQZe7+WSNqTqYByG+KXk1nLNxCJMJh9e1RQbr+3g913jEacxaxzyOv2xNKKbbrqXZCJ6GwqV1kcQalQmQk46gEJzNol5oMwlnp/+6W9mjavDzID9RcPrvI+WefUsmk4X31PTGQntmiiS1pmrInga0FVxSVZ5hipEcexhyqdsdLIE7TF/a+u50cZCc61ZW62eUgruKDc2FL5JO91hfp85DM6zbS6nx0PrfOSUvX/OmlAUWLoTM8GsswTmRTNKwxuc/fsV9a+3KpDodDDFzmRvMQ8nWarOdUxIsTDbvu16k8Y1QBogXU+wxXxsnqRQk0m8R5xVxYpGkE+kCZ5GynuqNdlxJAmrLyY3lqwnHh3jelsEXHnIUF1W+s42IM1Q5zQxLP46u
 YutduCSb
 741Ppdv0Q3tv6SoD5xEg0ZeKakJgkCGBJi5X+YCa5YONAM3zhOqVSQYAeAX6ynvYmGPmVZTHqBeVsKsxHOg1EK+CuULnqqEvq8nn0q97JpBvcwApnpUk21p2LPRwEZWjlvjXEz/1PObWS+Xe+xvH2xVIhKDXnU6fdnQo9JCb8+vSioVmvH8klJ+CKxrSLAiqVw1wVXrj1eRWQlHAZ3LRPPmsSEun4WGzBpbsnvkx0ZT5YsAGm8OWHyNh6tT+tj/bzO6MAFJqo/LUJQzP7mZsfTUjhXYD/EpJmzX5LNW9c+bo7bZmSVyjfmaZ4KGJXJeqteHmj6YHTrb+GCwbsU1PHfcsx2FX6FGuWExMBXYjuGqNsAujYkufKmHdeTd+CRfBNJtbs39JfqEg2/vAncr3DfsXU5NV54IBJY5bbb7aFdUdZ2k+w0uIOpiJIboVbqy1FthKkhCXKvW4fJplnmmroJOEJZyTR6ZvMN/e8tb34WrFwlrKRHbybxfc3Ye3ukpeP8zES+QqJ6faDpqQaKi+MUswrrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
pagevec"). Remove any stray references to it and rename relevant files
and macros accordingly.

While at it, remove unnecessary #includes of pagevec.h (now
folio_batch.h) in .c files. There are probably more of these that could
be removed in .h files, but those are more complex to verify.

---
Changes in v2:
- Add tags from Matthew, David, and Chris (thanks!).
- Add 3 new patches with more cleanups.
- Link to v1: https://lore.kernel.org/r/20260225-pagevec_cleanup-v1-1-38e2246363d2@columbia.edu

---
Tal Zussman (4):
      mm: Remove stray references to struct pagevec
      fs: Remove unncessary pagevec.h includes
      folio_batch: Rename pagevec.h to folio_batch.h
      folio_batch: Rename PAGEVEC_SIZE to FOLIO_BATCH_SIZE

 MAINTAINERS                                |  1 +
 drivers/gpu/drm/drm_gem.c                  |  2 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c  |  2 +-
 drivers/gpu/drm/i915/gt/intel_gtt.h        |  2 +-
 drivers/gpu/drm/i915/i915_gpu_error.c      |  2 +-
 fs/afs/internal.h                          |  1 -
 fs/afs/write.c                             |  1 -
 fs/btrfs/compression.c                     |  2 +-
 fs/btrfs/extent_io.c                       |  6 +++---
 fs/btrfs/tests/extent-io-tests.c           |  2 +-
 fs/buffer.c                                |  2 +-
 fs/ceph/addr.c                             |  2 +-
 fs/dax.c                                   |  1 -
 fs/ext4/file.c                             |  1 -
 fs/ext4/inode.c                            |  2 +-
 fs/ext4/page-io.c                          |  1 -
 fs/ext4/readpage.c                         |  1 -
 fs/f2fs/checkpoint.c                       |  2 +-
 fs/f2fs/compress.c                         |  2 +-
 fs/f2fs/data.c                             |  2 +-
 fs/f2fs/f2fs.h                             |  2 --
 fs/f2fs/file.c                             |  1 -
 fs/f2fs/node.c                             |  2 +-
 fs/gfs2/aops.c                             |  2 +-
 fs/hugetlbfs/inode.c                       |  2 +-
 fs/mpage.c                                 |  1 -
 fs/netfs/buffered_write.c                  |  1 -
 fs/nfs/blocklayout/blocklayout.c           |  1 -
 fs/nfs/dir.c                               |  1 -
 fs/nilfs2/btree.c                          |  2 +-
 fs/nilfs2/page.c                           |  2 +-
 fs/nilfs2/segment.c                        |  2 +-
 fs/ocfs2/refcounttree.c                    |  1 -
 fs/ramfs/file-nommu.c                      |  2 +-
 fs/smb/client/connect.c                    |  1 -
 fs/smb/client/file.c                       |  1 -
 include/linux/{pagevec.h => folio_batch.h} | 16 ++++++++--------
 include/linux/folio_queue.h                |  8 ++++----
 include/linux/iomap.h                      |  2 +-
 include/linux/sunrpc/svc.h                 |  2 +-
 include/linux/swap.h                       |  2 --
 include/linux/writeback.h                  |  2 +-
 mm/filemap.c                               |  2 +-
 mm/gup.c                                   |  2 +-
 mm/memcontrol.c                            |  2 +-
 mm/mlock.c                                 |  2 +-
 mm/page-writeback.c                        |  2 +-
 mm/page_alloc.c                            |  2 +-
 mm/shmem.c                                 |  6 +++---
 mm/swap.c                                  |  4 ++--
 mm/swap_state.c                            |  4 ++--
 mm/truncate.c                              |  8 ++++----
 mm/vmscan.c                                |  2 +-
 53 files changed, 56 insertions(+), 73 deletions(-)
---
base-commit: 957a3fab8811b455420128ea5f41c51fd23eb6c7
change-id: 20260225-pagevec_cleanup-d47c16cb0f2d

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


