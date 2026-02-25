Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 636EBFD45FB
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0B916B008C; Wed, 25 Feb 2026 18:44:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD3F46B0092; Wed, 25 Feb 2026 18:44:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D5B6B0093; Wed, 25 Feb 2026 18:44:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 84C596B008C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:44:50 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2038BBA690
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:44:50 +0000 (UTC)
X-FDA: 84484611540.28.DB16029
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8F57E100003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:44:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=U1PIVhaQ;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772063087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1k2aRLcgmydoMd1dEiHPTc9xxnOTAMtx9b+CM6PXh0=;
	b=urKwIuZCcbY3u3lYpDsZJpCEnQpAeDrMGpSUs3jVr6Q19GIICUpPvgzwDnUln/gIp+DIGg
	iz4xoca+d9uIbV8iMXaPE7zADPkU8NLL5UIVKGVM7wh/taKucl8X1v+cUJnwFcuSnRToiq
	z7SawtLW05RIT9UuiiUr0EcEbkBjJ7A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=U1PIVhaQ;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772063087; a=rsa-sha256;
	cv=none;
	b=StHSeTlv1/qlXPxQz34yTbXIriCHem2ogVo+cT9TROsxrT8uB36/2HKPGc/5kXjwq0NcFN
	Oy6kl83aXYVtEHLitLerxQDQ3bhb5e+Qqmkg+KH5mtXBVOFwHjSSL1S/4wh9qQBbXzn99u
	pd/kZBozlTshdM+gyi0nYFsHPDQmfds=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PNNCpm1318267
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:44:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Q1k2
	aRLcgmydoMd1dEiHPTc9xxnOTAMtx9b+CM6PXh0=; b=U1PIVhaQRwd3nbrNnYtm
	L1no1lMCV2YmzeST//Dp/v7B3/cqL4T65QQrGFeq4b08zK5Y2bNTbh+NZ0dvRq8L
	fWxAXdfzylJQAflLxh8iC6HUOyaR7ki6/xPgiP+/NrizW4D7zaK1w0+W4ErGSFUd
	W0ErFErP2OIoxqkEv58jTOIg5iLwKzU7KKkGTTglXZHlYByD0dZEd4gm2XRonTBf
	IAwk64JaWJh5SI6PlHFHgjkB1xFbM72XAqyzdYvOCmP5fAPuCzBajwGH0E/vZsKp
	WVFnR0ForMBT3YjkIm2sCMYMPztXn+cqf57JO1rCfMS6vvmcio9eEyqAYlqMbGkD
	Vw==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4cj1dtds3p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:44:46 -0500 (EST)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8954ac30d79so24304386d6.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:44:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772063085; x=1772667885;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q1k2aRLcgmydoMd1dEiHPTc9xxnOTAMtx9b+CM6PXh0=;
        b=guW+k3EYEMxKDI7qZfNOYdlMODFwIchcR7zQl18oURQbRQqTGCQN0a7gdNywEBI7Px
         VRgZ8yd0aDY923g3yK8Z6PYmykKSdqSauba49SuTwT7EYy6o8zrm30T2qgYn87Btpt7H
         ZvTXNXCzvwz279CkECEI5o7LiFVRZb47fmS+GM/WGCS5KyIomvHX8YxI6bgmLpd9spex
         o2YX43AkeBz9Aqgy4Y9q6rk3Wq4e4X3TNAui071CsBYweF4qOWjsgznr8lQ6SJZIXgE5
         +4Ij883Nu/RWaZJYIkqDxlnwuI2q2p6Jc2BZ0WBeSh2s6C3/Mz4ELWTJt2Nd2RiAw2Tk
         AErg==
X-Forwarded-Encrypted: i=1; AJvYcCVJAfFyQ2BBIYGk+yUAy9IuFG1AKFHUd2rsE6EA4aeJUKrjORGYglaB3vzULB3l3as9k9ln/gdd3A==@kvack.org
X-Gm-Message-State: AOJu0YxTVynK09SyQdk1feywtCFKe5vqvFkv/SgIhbydRUEqdu1Q7X1p
	Bjaft5NHA2HssK91jWlJwQpXoIuZe7z560H4CWmN8L3bqcmV5ek6PbKS4fEGsJsmAkPfnPfyw88
	ZkbxhIjpN6QakDjTpETIRHBixN6fx6JZd/26ww8p3XcgWscbj
X-Gm-Gg: ATEYQzzRWd6uPiGh/6YfR/6rOSFlBFvUxyIhn4VSivKuPgY8Zm+XDr3AJljjhQCv6vK
	uLVS+BR0It8KLamhJzB5U62GPogPXTu/lkphYwGUW1fcx61vDa89KlaexKVLjjc0sTXiiW4Nzf2
	tXeINIPiVBgjBF6Ljdrp+OeFV8J+gSlsbwUSx+QvnrfDMyc3CMI5OBFlFEuSMlphbiv+J3xSsH0
	KPXlPIP522E9MxegaRC44M9PWA9nZ1HaFh510zSZ//6L8sqrB2hoHF5kCGtRmqSJ62Za/MRnXZi
	WcxHLZYZOG/U/OfS5DCcRsOG+Glj5rhongREs2n2O1vMC3p2BSbfZkpD/b9Mm+kATvOoIR9MsV3
	nh25LJ25so8hVeFOHUM0B4kJDaVQ0Z22R
X-Received: by 2002:a05:6214:21ea:b0:895:7864:f69a with SMTP id 6a1803df08f44-89979eedb2amr279116556d6.46.1772063085031;
        Wed, 25 Feb 2026 15:44:45 -0800 (PST)
X-Received: by 2002:a05:6214:21ea:b0:895:7864:f69a with SMTP id 6a1803df08f44-89979eedb2amr279115656d6.46.1772063084415;
        Wed, 25 Feb 2026 15:44:44 -0800 (PST)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c738d80bsm3357606d6.41.2026.02.25.15.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:44:43 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Feb 2026 18:44:26 -0500
Subject: [PATCH v2 2/4] fs: Remove unncessary pagevec.h includes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-pagevec_cleanup-v2-2-716868cc2d11@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772063077; l=5646;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=gYLxuKpY2d3qKNQKxivfKoBOKiAm81D0oxjvJeYJzNU=;
 b=0+QFbVO+EVyu3LcoNlltI7+0YkfiOzPAREHRqHF+/vRJBoggqFw4V6DeYqoYE35EGaZ0z2yM5
 xg7WRatCQDeAtdc5+Wn8weZAkk+lk9tyDOPYyXE2pnCtDyQNUNup7UV
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDIyNyBTYWx0ZWRfXycDxjOWK4R02
 ZcVNlFHgG2iPQG8Lg10+Ggr2GXnhCtTzYAcMWj4hZAeW0xwMpSjHnrucjtb3JL2xe2+wNoOTwwE
 Zg1+bFk1c6fL6qPc0tTapeOpiTq8bOC/+7qLEbp5qjXwmXeAA73HlUxOd+0/6X1HpNIhrPxn17Y
 Jo9lHbH/DvNNHPr4wkVsi4jRy90bVcwE7Jn/O+JMsBjm2b4mucrmZ10vTFnW8NWBlDUn0NX31Yg
 9KbuxJtzazKaVgI+d7Pn0QDocZFufwT7xGFBPqevCNHPQg7r+PPMdkyvdymoYJWt6l+F39s4kG0
 uyRjfHprll9ygJ4kidz5oMlHsv2h7Wzgxx2Zyyxkux3vdSFrF6/iVHZRQlTm1V5TmbxfjS1w48L
 VBwrhlAWPZFjYl+IBiTvhSeRGT1cpyHoE18hrkOM90N1mkRQPCXUOMQxg2r1dRRnXTvHaIvo79q
 6FWJyPtTnee4ZeNlw4w==
X-Proofpoint-GUID: 1FpMPigr1pYwrLSxiPGLU3WYz3e8GeyT
X-Proofpoint-ORIG-GUID: 1FpMPigr1pYwrLSxiPGLU3WYz3e8GeyT
X-Authority-Analysis: v=2.4 cv=ROu+3oi+ c=1 sm=1 tr=0 ts=699f896e cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=_wBAnLaIECucki5onNwA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11712
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 impostorscore=10 priorityscore=1501 phishscore=0
 malwarescore=0 bulkscore=10 clxscore=1015 suspectscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602250227
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F57E100003
X-Rspamd-Server: rspam02
X-Stat-Signature: a4me714b3gbm6tjxx7dqhzfghhswof86
X-HE-Tag: 1772063087-149632
X-HE-Meta: U2FsdGVkX19qVcKtOUK5iacMn5EBHszuyJfeuEMkO/JQMub11JRnW3nSRBsVKma+WlfgAD9S1eH89Jm3Glo+ZTZlmrG/paYxnqWkPKGG5M2V1txZ0ArwhWULcPjC/KVHRVAZBU7EFALFKGK+G7cgnXfcFi1r4mBtWgm6yarx9WFi66X9KlHptjH2kVxMfiD35iWrRw1aSnCayLcrzpZf7Nxr8shFyhMpVN0Qa2A3UMQGlg/MpEcGYueFZnDPOvxrH5NP1VxvjrRE811jKHtGWgNSpsq5UHRDcER6WIlo13eS8msWdc0Jlyu16yfCxa9WPSLLETiuy3r8sSa4nA+Mc+W7zyL2qvy1kcnEwVwJnMgaKqyRDJc3Up6SCaNyWa2r5F4swxuIQ5alg3WWhwMp7wDcqklOSDcKH9s0Buz7orBIvaWtEJLseWw0UBaJ9iLSeSER7Xrzi0tp+saXoY6dFHi37Ls0QPWoSBwONOE4EOHCR584JPodnSxfXRXMPNUe2LVmdllhiHXLuvXLimUZf3PcuetvHxgMVfH6cLEhL02T2VZI3R9vdDatQ144B9OO3domU7ixrgRJglDwm22Lw2DgN+od+PhRhRkwd3Y5Qj1mopzvB2H4lDGv7jYI7XWE1vxM4rRmqa+uHRQJBzfo20wd7P5p8Z7dGAGxu1O3censcZxsw7Ba8nvAzEhnFLdOU3wsd2ab6b1ziQDRosp4I0a4prGupR1DFaYPlJY/SV+KahpWy3M/qWFeVXDW/SkaKyg3PIPoANL36fwq2d9NNry2hdRIj1F4svLxgNWxG2f6JgG8nDfvlP8AVmoh3KjndyOvAPOIW9IAKGy6IaGCWXEF8Mr1R9btWHfYyQWLzeHNeDp622lDGSwL8sPps8/QunAypBV2djePJW93YhuZI+BFZMCBqACCtdZiTCRN/TX9231wGs7XkcLOFdEeqASPt5FXcVTPHFffA7aPJ0w
 MPRdqk/I
 XVS86K+RHK2p3BOjqG1BVdBKkGv30ZeZ6s2uIWXqQlVrqGRYCA1Hsmx6ymzm+yCTURtjKIRv3yyKxlWrVxW72mtK2tJnzE/mn/GrZ5C3eExOgccI61qVl3lHNjU5oFXATj3ilOinaLFuGw9w/8NfiGPOyINGZtJElhknW3jlTY0+s7Y/tV9yPfFTacORsNvIR4ooLmds8k3H9BHOWd54MBMT33jm03jk/XN13Zz6+VOkEipsZJNA+Wzh2UIqeqRBTzcCpoy1T0gYfkAq+Fi+4hS+5f9/0eg9ivUv2OqlMgUaSWsf06EDOKkOQF7jfzdIKts/npUwgoBOplnI1q6kL2lOMAuj6f/lo5oFddjF0l/INPwD8kZXXZxnaJlWQHYqLhDAj8uz4JLroub1U7PeOzKxxW5PpZwjYZdetODDJfL6JRrEeEakTDU22xlm9YOyqvdAQw+AslC/Pzy7//OUuGWLzXAWZUzFisWgqDZgzpr9HVreYR+9Ze7C5tJoUbHpyLvzv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove unused pagevec.h includes from .c files. These were found with
the following command:

  grep -rl '#include.*pagevec\.h' --include='*.c' | while read f; do
  	grep -qE 'PAGEVEC_SIZE|folio_batch' "$f" || echo "$f"
  done

There are probably more removal candidates in .h files, but those are
more complex to analyze.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/afs/write.c                   | 1 -
 fs/dax.c                         | 1 -
 fs/ext4/file.c                   | 1 -
 fs/ext4/page-io.c                | 1 -
 fs/ext4/readpage.c               | 1 -
 fs/f2fs/file.c                   | 1 -
 fs/mpage.c                       | 1 -
 fs/netfs/buffered_write.c        | 1 -
 fs/nfs/blocklayout/blocklayout.c | 1 -
 fs/nfs/dir.c                     | 1 -
 fs/ocfs2/refcounttree.c          | 1 -
 fs/smb/client/connect.c          | 1 -
 fs/smb/client/file.c             | 1 -
 13 files changed, 13 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 93ad86ff3345..fcfed9d24e0a 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -10,7 +10,6 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
 #include <linux/netfs.h>
 #include <trace/events/netfs.h>
 #include "internal.h"
diff --git a/fs/dax.c b/fs/dax.c
index b78cff9c91b3..a5237169b467 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -15,7 +15,6 @@
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
-#include <linux/pagevec.h>
 #include <linux/sched.h>
 #include <linux/sched/signal.h>
 #include <linux/uio.h>
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index f1dc5ce791a7..5e02f6cf653e 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -27,7 +27,6 @@
 #include <linux/dax.h>
 #include <linux/filelock.h>
 #include <linux/quotaops.h>
-#include <linux/pagevec.h>
 #include <linux/uio.h>
 #include <linux/mman.h>
 #include <linux/backing-dev.h>
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index a8c95eee91b7..98da200d11c8 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -16,7 +16,6 @@
 #include <linux/string.h>
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
 #include <linux/mpage.h>
 #include <linux/namei.h>
 #include <linux/uio.h>
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 830f3b8a321f..3c7aabde719c 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -43,7 +43,6 @@
 #include <linux/mpage.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
-#include <linux/pagevec.h>
 
 #include "ext4.h"
 #include <trace/events/ext4.h>
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index c8a2f17a8f11..c6b6a1465d08 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -17,7 +17,6 @@
 #include <linux/compat.h>
 #include <linux/uaccess.h>
 #include <linux/mount.h>
-#include <linux/pagevec.h>
 #include <linux/uio.h>
 #include <linux/uuid.h>
 #include <linux/file.h>
diff --git a/fs/mpage.c b/fs/mpage.c
index 7dae5afc2b9e..e5285fbfcf09 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -28,7 +28,6 @@
 #include <linux/mm_inline.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
-#include <linux/pagevec.h>
 #include "internal.h"
 
 /*
diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 22a4d61631c9..05ea5b0cc0e8 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -10,7 +10,6 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
-#include <linux/pagevec.h>
 #include "internal.h"
 
 static void __netfs_set_group(struct folio *folio, struct netfs_group *netfs_group)
diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index cb0a645aeb50..11f9f69cde61 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -36,7 +36,6 @@
 #include <linux/namei.h>
 #include <linux/bio.h>		/* struct bio */
 #include <linux/prefetch.h>
-#include <linux/pagevec.h>
 
 #include "../pnfs.h"
 #include "../nfs4session.h"
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 2402f57c8e7d..0d276441206b 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -32,7 +32,6 @@
 #include <linux/nfs_fs.h>
 #include <linux/nfs_mount.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/swap.h>
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index c1cdececdfa4..b4acd081bbc4 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -31,7 +31,6 @@
 #include <linux/blkdev.h>
 #include <linux/slab.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
 #include <linux/swap.h>
 #include <linux/security.h>
 #include <linux/string.h>
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 33dfe116ca52..9e57812b7b95 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -20,7 +20,6 @@
 #include <linux/delay.h>
 #include <linux/completion.h>
 #include <linux/kthread.h>
-#include <linux/pagevec.h>
 #include <linux/freezer.h>
 #include <linux/namei.h>
 #include <linux/uuid.h>
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 18f31d4eb98d..853ce1817810 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -15,7 +15,6 @@
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
 #include <linux/writeback.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/delay.h>

-- 
2.39.5


