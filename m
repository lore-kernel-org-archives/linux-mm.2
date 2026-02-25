Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 444D4FD45FD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986136B0092; Wed, 25 Feb 2026 18:44:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 941B66B0093; Wed, 25 Feb 2026 18:44:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768256B0095; Wed, 25 Feb 2026 18:44:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 644986B0092
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:44:55 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3313A1C24C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:44:55 +0000 (UTC)
X-FDA: 84484611750.04.D1999AD
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id CC6111A0006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:44:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="b/yB3FO8";
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772063093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TE8ZhYBQf9fiNswnOLiD0snqyySTRxN7Ufk+GD8fw6E=;
	b=o33+PRLY6/7h4c7ugPQDdrqWFuPVDnKjd26cl0ifEgtBamv3YZO5NFNPQmHSsbz17/evdg
	WEf0Nu+l0CLZLzdzPZtYcmdO0NqNv6zDgyO32K4dJO8hIAp877F8/aEjnaslRq2Cu5UTss
	HtknfVqNpgapXng8eH0NSkAdymxnEKc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772063093; a=rsa-sha256;
	cv=none;
	b=2L40Mrt2NL3Vc3zJalT8ZbwB2K9Be1QhCo8FsqCKS6NvPzZipjUdLIgr3cviTSUrE+o2Af
	1FBpdv56JFUKcQ2xUVavJ7b3mBoKwxC/A7+GqTJDUoFfw/Gv7IMD+Vccy5H6T/u/LH4fIH
	R+v8687aGUdhod0d8uimd3QNoYW+Re0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="b/yB3FO8";
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PNNMkC1400023
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:44:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=TE8Z
	hYBQf9fiNswnOLiD0snqyySTRxN7Ufk+GD8fw6E=; b=b/yB3FO8kwgXmET281Jv
	XP+tAXlRZIOQ6OAFR2YSS+792EIr83nP+nakYz8tKWh86IL9kbOyLkg2yn8b3g/q
	S5VPNh8sAcmAlprkg2Cw/wyQbawj3NLSALIkGLq2K8V4kIRt4aYXHS/DHlGsM8fs
	H8cCC3+JhbwQsrjnzdcgeRxONcJg4TG6TN/qWF72MSX7O8ZGhKSU3I2BfZEDoisK
	t1LvqQr0puhEkmBwjqopiEjNDjB9vH7tXsjnfmo+oQfclWfz01qggxeWH6r8fgsq
	rZ0/3X3DzNuyvGFcD+vq2Q7XNExoHO+FQm1lfYBwrgA16DwNSuwMZae97gH/dVl+
	jg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4chx6v6bcd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:44:51 -0500 (EST)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-506c0231e63so29612581cf.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:44:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772063090; x=1772667890;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TE8ZhYBQf9fiNswnOLiD0snqyySTRxN7Ufk+GD8fw6E=;
        b=W8KKvtOq0RmX+aIsu4HHXyEOFlbncJIKmU8kzc9Hqffi2M5HMgheq83FeztSkMnZWQ
         4Iwbu3gDV5Un+e0hSMGMvw/T6oTEZEgRzDQ70COjyljLHvPcyiUfUROacOaOTb/UolaQ
         z/9YUUIG/sXAKky0aCch0RZFYT/yKFv65qxwNgmqcJJNnBih2K3Ik2V9yReX4CGnOEzS
         GQ0bAQ3u23nL2GEYeu9y/VGFEJWsRzuS9fvC4Jd4zG3cNKAYeXc/m0cj/Aezz9lR6u3z
         QGz+O8uwuao5lQSku32PHGdZrgWRueQbnpn8H3RvJRRiIhjMpySA7NXT7JDdnav+M3j3
         ZaFA==
X-Forwarded-Encrypted: i=1; AJvYcCWV5uOtMsgIyDnZNSYjWkKKJ16qEqRphe3Oig4puKDJ6maRoXA2n0wulnOfZpZzOorEsaoOXd6mwA==@kvack.org
X-Gm-Message-State: AOJu0YykRwWKwJDYJOrrIWHl9YCX3ns2hET/l1nZIyOjzNhaGr9EOpdI
	bDXdTv4L9we1eoIkvpRtcF6GZ7ZeWsY/tMCOw15nLhNHEcQFtf/ujs5LkyXCFtaJ/gylUV/ywhQ
	qxWFUDw709RY/g3987LD6SqXBD2RyW3/O80g52/LdZgszEyAC
X-Gm-Gg: ATEYQzy7chZ91za5k9/iq565LDTTiT8soWDTM3adxK9iNkeQO3hdEVx9CxBmjc05EFV
	iAft1miH9obov7k669Dh1rnrTw4lq0J3KlniqXlvtWvj/SAdZftzjR1rG1mkvrcmpHXsACb840E
	eeA8+mBBwj6DQrRhen8xzKOhOLR+FTqbec3pnGwLDy/GcFQrJtCNNSP3wxfhDcshzsy4lSqF/Wh
	D8RvX7igTVAT2m4SUwCbo0+tuYU3I8+ivf1BEkpOMjcbdd8sWwg0dmlHSVtLe8Z6B49TQ3FLF1Y
	xsDokJhL9qCvO1uSilvyXVMRkyXyHgoge9Bdn8g9sODGtMn39yBiGvRdkm/dCpyrxbaoMqOWBge
	fkgiQFFsjC4CXTqsgYWQ5TkvboxtTF/bs
X-Received: by 2002:ac8:5ac5:0:b0:503:2fe5:f380 with SMTP id d75a77b69052e-507441df64fmr13263521cf.0.1772063090057;
        Wed, 25 Feb 2026 15:44:50 -0800 (PST)
X-Received: by 2002:ac8:5ac5:0:b0:503:2fe5:f380 with SMTP id d75a77b69052e-507441df64fmr13262341cf.0.1772063089401;
        Wed, 25 Feb 2026 15:44:49 -0800 (PST)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c738d80bsm3357606d6.41.2026.02.25.15.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:44:49 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Feb 2026 18:44:28 -0500
Subject: [PATCH v2 4/4] folio_batch: Rename PAGEVEC_SIZE to
 FOLIO_BATCH_SIZE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-pagevec_cleanup-v2-4-716868cc2d11@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772063077; l=5814;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=zO7GBjiuOn5Q+h+zA8UgP1+Klsw8MQQTt1O0svxg4WA=;
 b=KCL19WgRUDAqH63IGvAc3KncLR0mQnluCE5DMTx+wx8s1EMvm5gWiID7it4982lNgTaHXaECH
 ClIpdW+IjPxAETpUADJ+80YGkvu3AQ4uNneZg/M0Lj8/3I89nOh73yK
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: uRUSDYTOysqO3QqMHbfPglnH6jqId8VH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDIyNyBTYWx0ZWRfX1inlIkPBqWeR
 YFe6RX1ekX5m4Xw8Rg04+6p8++oMBKvhQyo1T3VdfVjdUA8ICm784mVJ+V8/XUlMWlIDwQBQHWR
 BoGNY/lrLDA4XBpJ9YMrpv+VRM92wb9EjBcSsynfOn3Hbx8Ay2hkPIF4EhCalpgGIDwOj3GyWK/
 /vaF1DVDWovhQppX+2IHGJa3HfL8P21t8eulyc/weurh2AuZclDx5YU/yhGWs01+aqwO4qzEiny
 03/2saFCxTa/3ixCJBaDe8AWaZKNIjuly4Hx/uSdaCUaZ0z1nmNl3zW8vJmZWHUnD9arZ8kBvqX
 gXrY8zldvaMY3E9sSYnvzYcSGepTmoi011RA/M/FC27j4uaPncHC+ig4Jmd/NQ8XHDhBLUM1zaO
 49WryA+XuCLalIe7xBCt24FZV3MYgsA4gCHyJigW/Z7F14hnWPFZFVY4ryAxFFmgf/X+e5Y5gnX
 6jpG36/IdF3efJaJ8Fg==
X-Authority-Analysis: v=2.4 cv=FqMIPmrq c=1 sm=1 tr=0 ts=699f8973 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=960X5KZuJcz03JLduyoA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: uRUSDYTOysqO3QqMHbfPglnH6jqId8VH
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11712
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 malwarescore=0 adultscore=0 impostorscore=10
 spamscore=0 bulkscore=10 lowpriorityscore=10 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602250227
X-Rspam-User: 
X-Stat-Signature: nedrx9nf4dmbs1mo9sh7ojr7b4pwrnwc
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CC6111A0006
X-HE-Tag: 1772063092-834119
X-HE-Meta: U2FsdGVkX18wxhsadnTR7gxPBtJokJskrBQnjCgTlT7rFEo8+JLW+l9ViHNamD2nKiWTaeGPuxDaEqtII7twkheU/S94NtNbs1LVf/YhpvadTygMqaqD4649UBg0OXYuAEs50+AYUGCOJs7yGwpbCbJ5Vycfdj7n0MUsF4k3NM3ZpYqDImfotaSxB/SHLtEZ8Q91Y9dJ088CehkkgMf71QyoDhS1eRiI3f5Cmf3BekMJdBzkjRZgH1HgY6X4V+wzyvaz5I6DPfsPIpibCv4smeDQobSvxytP7IrseqYlorg6nQ4Wdlss2CxOaOEaJrP1w3Ad806wyt7JxJyZB95tRQMyEtDPp0Rw8OLLKDMOpG7pBElaLrpMG7YHe+92lSw72HvfmaecqvMs+L/mWQFlU3Crm3LWC/qtuFO5sbQjrBICK8tJui6T6K5yQ1oWrmx7ooj/T0HUZmLBlOdH9n9PRSYWWj5C2nB8ZiMlb6taMpAGnbVxAIeZZV7vrDBdNGDZGHH11OcuA6oJO3iSzJGRLUBzV5lQRE+8LN3kKVIvkCW9S+NPNv1qm029SYHKOF9IaJoGuvLcSnqWeC9NgiAub6biodNkv7FDCCsEJZblO6RvXwgTDdjTuK7+hckfROK9tnLqFsRIe4fqdl/a0lZHtDzSmJ8XJrrCIeme2ykSQpH05ZVax8JfHBAjG1HAdju7snZ2CTaOsvnDudaSXfQ4MAP5lCgLYjoL4v5qHY/cn+ut+PsV/8slYP7zZ/r4HuZjX3NhYAtC1AhLrpQCs8d/USgs+iP/Lwq8un5HlIBtcQ0vB0Ad9t/KwenyBQSSeIWktCT8eiMGw98EIWPOU0njS3s+7kDBLW4tBdER6n5GRMu/XFIi5pM8wteIBYibK89MsxX4J59P/GO/bWu4zwn7OINFI8eBIG2ZXHLZ3ZOGgfqu+VEF5Gh7+qz96f4MxOL+FT/4KtgCG150DrM+wYj
 o5kuGy8V
 pY9A9q3UrGVKVydSF4C1+jAWkNi9+2sS0+JWlB5i+FI3B+vIc2nJgNcnnNPKOrgx3xGLJE+6UAn+7Pk1ZNj1jwjcj4IKZej0ByXReNQczEKNQbOk8aJWJE1Bv+oY56P9ABsAfGbjch0+34nkhKQo9/bSCxiMGhhdW7PcUfCA7rRlKO78CaqwwBpCli6gjKxbbp59QnTF31FLUyiY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct pagevec no longer exists. Rename the macro appropriately.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/extent_io.c        | 4 ++--
 include/linux/folio_batch.h | 6 +++---
 include/linux/folio_queue.h | 6 +++---
 mm/shmem.c                  | 4 ++--
 mm/swap.c                   | 2 +-
 mm/swap_state.c             | 2 +-
 mm/truncate.c               | 6 +++---
 7 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c373d113f1e7..d82ca509503f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2095,13 +2095,13 @@ static void buffer_tree_tag_for_writeback(struct btrfs_fs_info *fs_info,
 struct eb_batch {
 	unsigned int nr;
 	unsigned int cur;
-	struct extent_buffer *ebs[PAGEVEC_SIZE];
+	struct extent_buffer *ebs[FOLIO_BATCH_SIZE];
 };
 
 static inline bool eb_batch_add(struct eb_batch *batch, struct extent_buffer *eb)
 {
 	batch->ebs[batch->nr++] = eb;
-	return (batch->nr < PAGEVEC_SIZE);
+	return (batch->nr < FOLIO_BATCH_SIZE);
 }
 
 static inline void eb_batch_init(struct eb_batch *batch)
diff --git a/include/linux/folio_batch.h b/include/linux/folio_batch.h
index a2f3d3043f7e..b45946adc50b 100644
--- a/include/linux/folio_batch.h
+++ b/include/linux/folio_batch.h
@@ -12,7 +12,7 @@
 #include <linux/types.h>
 
 /* 31 pointers + header align the folio_batch structure to a power of two */
-#define PAGEVEC_SIZE	31
+#define FOLIO_BATCH_SIZE	31
 
 struct folio;
 
@@ -29,7 +29,7 @@ struct folio_batch {
 	unsigned char nr;
 	unsigned char i;
 	bool percpu_pvec_drained;
-	struct folio *folios[PAGEVEC_SIZE];
+	struct folio *folios[FOLIO_BATCH_SIZE];
 };
 
 /**
@@ -58,7 +58,7 @@ static inline unsigned int folio_batch_count(const struct folio_batch *fbatch)
 
 static inline unsigned int folio_batch_space(const struct folio_batch *fbatch)
 {
-	return PAGEVEC_SIZE - fbatch->nr;
+	return FOLIO_BATCH_SIZE - fbatch->nr;
 }
 
 /**
diff --git a/include/linux/folio_queue.h b/include/linux/folio_queue.h
index 0d3765fa9d1d..f6d5f1f127c9 100644
--- a/include/linux/folio_queue.h
+++ b/include/linux/folio_queue.h
@@ -29,12 +29,12 @@
  */
 struct folio_queue {
 	struct folio_batch	vec;		/* Folios in the queue segment */
-	u8			orders[PAGEVEC_SIZE]; /* Order of each folio */
+	u8			orders[FOLIO_BATCH_SIZE]; /* Order of each folio */
 	struct folio_queue	*next;		/* Next queue segment or NULL */
 	struct folio_queue	*prev;		/* Previous queue segment of NULL */
 	unsigned long		marks;		/* 1-bit mark per folio */
 	unsigned long		marks2;		/* Second 1-bit mark per folio */
-#if PAGEVEC_SIZE > BITS_PER_LONG
+#if FOLIO_BATCH_SIZE > BITS_PER_LONG
 #error marks is not big enough
 #endif
 	unsigned int		rreq_id;
@@ -70,7 +70,7 @@ static inline void folioq_init(struct folio_queue *folioq, unsigned int rreq_id)
  */
 static inline unsigned int folioq_nr_slots(const struct folio_queue *folioq)
 {
-	return PAGEVEC_SIZE;
+	return FOLIO_BATCH_SIZE;
 }
 
 /**
diff --git a/mm/shmem.c b/mm/shmem.c
index 149fdb051170..5e7dcf5bc5d3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1113,7 +1113,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 	pgoff_t start = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	pgoff_t end = (lend + 1) >> PAGE_SHIFT;
 	struct folio_batch fbatch;
-	pgoff_t indices[PAGEVEC_SIZE];
+	pgoff_t indices[FOLIO_BATCH_SIZE];
 	struct folio *folio;
 	bool same_folio;
 	long nr_swaps_freed = 0;
@@ -1510,7 +1510,7 @@ static int shmem_unuse_inode(struct inode *inode, unsigned int type)
 	struct address_space *mapping = inode->i_mapping;
 	pgoff_t start = 0;
 	struct folio_batch fbatch;
-	pgoff_t indices[PAGEVEC_SIZE];
+	pgoff_t indices[FOLIO_BATCH_SIZE];
 	int ret = 0;
 
 	do {
diff --git a/mm/swap.c b/mm/swap.c
index 2e517ede6561..78b4aa811fc6 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -1018,7 +1018,7 @@ EXPORT_SYMBOL(folios_put_refs);
 void release_pages(release_pages_arg arg, int nr)
 {
 	struct folio_batch fbatch;
-	int refs[PAGEVEC_SIZE];
+	int refs[FOLIO_BATCH_SIZE];
 	struct encoded_page **encoded = arg.encoded_pages;
 	int i;
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index a0c64db2b275..6313b59d7eab 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -385,7 +385,7 @@ void free_folio_and_swap_cache(struct folio *folio)
 void free_pages_and_swap_cache(struct encoded_page **pages, int nr)
 {
 	struct folio_batch folios;
-	unsigned int refs[PAGEVEC_SIZE];
+	unsigned int refs[FOLIO_BATCH_SIZE];
 
 	folio_batch_init(&folios);
 	for (int i = 0; i < nr; i++) {
diff --git a/mm/truncate.c b/mm/truncate.c
index df0b7a7e6aff..2931d66c16d0 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -369,7 +369,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
 	pgoff_t		start;		/* inclusive */
 	pgoff_t		end;		/* exclusive */
 	struct folio_batch fbatch;
-	pgoff_t		indices[PAGEVEC_SIZE];
+	pgoff_t		indices[FOLIO_BATCH_SIZE];
 	pgoff_t		index;
 	int		i;
 	struct folio	*folio;
@@ -534,7 +534,7 @@ EXPORT_SYMBOL(truncate_inode_pages_final);
 unsigned long mapping_try_invalidate(struct address_space *mapping,
 		pgoff_t start, pgoff_t end, unsigned long *nr_failed)
 {
-	pgoff_t indices[PAGEVEC_SIZE];
+	pgoff_t indices[FOLIO_BATCH_SIZE];
 	struct folio_batch fbatch;
 	pgoff_t index = start;
 	unsigned long ret;
@@ -672,7 +672,7 @@ int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
 int invalidate_inode_pages2_range(struct address_space *mapping,
 				  pgoff_t start, pgoff_t end)
 {
-	pgoff_t indices[PAGEVEC_SIZE];
+	pgoff_t indices[FOLIO_BATCH_SIZE];
 	struct folio_batch fbatch;
 	pgoff_t index;
 	int i;

-- 
2.39.5


