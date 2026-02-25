Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FD0CFD45F9
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6CDF6B008A; Wed, 25 Feb 2026 18:44:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A876B008C; Wed, 25 Feb 2026 18:44:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE2216B0092; Wed, 25 Feb 2026 18:44:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA8126B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:44:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 825D3591CF
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:44:47 +0000 (UTC)
X-FDA: 84484611414.09.358995C
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id EEBA71A0002
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:44:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=k8p8qfY6;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772063085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbU8qIjBMGeq/4CCh33jplvuFV4mV/Z7tLyPGzkrhRQ=;
	b=yog7jFdsEPWnot1ai9DuW+VQzi+PVFt8ejpIu5z/unJabJO/pPURTiWHmYlOt3XpPRfBTf
	FuKX7cUN7TZnJHBjBtZmhN6Zon+PrFGiWrpVDA7+vM8zBcWfC9o4P9xRkoqoNEMdzaxa1F
	j2dlcFIfIZTnYZEtHFqCagPtNv04lpA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772063085; a=rsa-sha256;
	cv=none;
	b=h3+CONGs1IScys7nPHnZMJQpYnN+TusmozZnSngDzN8PeetXI4y0C28vLjWlhEDnklvNGL
	7Cp4kp7J1anHmOloYwTcZdu2vu/J0d8VStxDUdd7YY3u38QSbf4PfguyS0ySwqSmEcs7Hq
	oXxuXRhXYvExE4882m/TbXB95WLBGF0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=k8p8qfY6;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PNN7Xo1318145
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:44:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=QbU8
	qIjBMGeq/4CCh33jplvuFV4mV/Z7tLyPGzkrhRQ=; b=k8p8qfY6LKJTKzyyIu1T
	MBHAySeSL2rGW18v7FXhhfE5FBzkAnsvzwwdn7GkjnE3GX/FS+1Labq+PlugfXXz
	vOec7glehBd8/aUWG3kwI+2K7MIntwvnNxIlbXeb4MC2Iz8OIYCgGdmmdQomMWcR
	jawfPFhJyFIek32736qXfJ1Zsf8PihQodtpVLS4wPMGxrg7MiHzMTOTAz5tsZHSw
	kZ64SjLH0jiAaG/crVhQ9y25MdtNe8NaKVc7DRq0nHaElnWsMUg1K68u6t5fD41K
	7efzQ1T71c41RoTR8AQXiabnd0+DiFVVEkIL0sRUwP2Sy7x2D3aUqGREmAiKw7yl
	/g==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4cj1dtds2p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:44:43 -0500 (EST)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-503915b0a88so44585031cf.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:44:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772063082; x=1772667882;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QbU8qIjBMGeq/4CCh33jplvuFV4mV/Z7tLyPGzkrhRQ=;
        b=NsdSyN+urlosQ+rdqg7f/mhjzFs+vl5KTzy0RV3uuNUhAcRA2XIex+z3GKOI71lNYE
         /nzqS14nyobGNsUDcrkFT63GA5JbIwkfy+4vQmmp3ZX8xXypulM57KIvgMVCs3WoBzS8
         F/0hqoCRUkLXKDguXKXzfrl3IvYXF2aDNrGfd6LmE265tNCL/tkW60vO2zavIym9wiTI
         wHV5z1hUHXCqlrmvXPZuEwjcnFltXQl7a8/lb4m72R+IR9hDrFx5NoWqt/+Tu/STHn4l
         yKmBE7EJHEloFqtSatlFtFmA9rsEcU1sNy6H+8gDobE46AkypAmrjz8c3OJSjP6o7Ql2
         wbUw==
X-Forwarded-Encrypted: i=1; AJvYcCUkojGLVE3i96A6HRbS7GD7hHp9d2hSlh4Y/tBaNBiUmVMZrApW/tPinZRXlavJz0QQ/2prLSdr3Q==@kvack.org
X-Gm-Message-State: AOJu0Yx/JGqYZUbMFVuNWmr7gtkIV+o0IEvcSTbRWZbXXoykYNdCrJcz
	2oKzBRTa10CbMA9/wAzz6N/Spe58gX4HXLLZ+HmN5ASClzfhU7uXUMSmIbronpxUlLyPb5ExPx7
	ET6Oi1sp0mgJmym12RFSlc22QcQWDwze789eCTFUKEZ50TyI3
X-Gm-Gg: ATEYQzx/K/iJW12PGkge9eQUxwfXamUw4M2SQFsDhuEuGhzuJWDD9u+EMGYIzJRQljZ
	C6U4WiQld1c+Qinb95YifPpLJ8wDlusrjmGG1ib+EsgV6wIVY0udnyZ5Z6++mwHHz5hmEjJFX3i
	dQac4kjGUG44v0LLh7V4lDqvI+mu2gMekcTMtByKYG3ghuyeFXvtuJzGqwcoblYfKsxgCRHEAsA
	zFTW0TI/4MKoOAg6CaIDtKO69Gdta2i2JScynNyJ8eKq+YgJUPBmvgf8A51Nv+8jLqtgFAZ9R9n
	HSWy/kYPXK1UpgtPPNhbSr2KbtzWKPzx/OGWooXvnBImKUgku8CnuxDYCJEjA6ELOEOYmWajKfV
	4LoG4sP46TrPAnLW9Utg4y9HIfKGHS2wn
X-Received: by 2002:a05:620a:bc6:b0:8cb:50d6:18be with SMTP id af79cd13be357-8cbbcf5fcf3mr351650385a.18.1772063082529;
        Wed, 25 Feb 2026 15:44:42 -0800 (PST)
X-Received: by 2002:a05:620a:bc6:b0:8cb:50d6:18be with SMTP id af79cd13be357-8cbbcf5fcf3mr351647085a.18.1772063081985;
        Wed, 25 Feb 2026 15:44:41 -0800 (PST)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c738d80bsm3357606d6.41.2026.02.25.15.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:44:41 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Feb 2026 18:44:25 -0500
Subject: [PATCH v2 1/4] mm: Remove stray references to struct pagevec
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-pagevec_cleanup-v2-1-716868cc2d11@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772063077; l=2123;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=86tTrdoOnAn/xo3cekp1XuyRqb4HRFNzoiKbv0I1ps4=;
 b=0ov9kj7XAzT78Flm+u7++Q86OOmjR2OlGmMBdpiKWPN48FTWijPSg85hjs6TZBPJjXCzDYWnL
 klFYhD+F1AcALAkegHF4EiMet5ndziKuMEd8gAJMsRTj0W6VnFL6fSO
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDIyNyBTYWx0ZWRfX11pMDw/LbIPS
 Uii6jRkx3Vmroj8vHwGUB3MbALrcsWgWtCAi089MH72ljiOEzxPYzvMBLKLmP+xi946dDHQQg2V
 I34ryODx4gLLoXSrPHVRwN79o/Tx/QT3YX6MFStiqqebMWEFClrA/5RvcTdd6Lt7ljfXfijC9Lm
 2aMn2vACEZjru96fIlf5hzzjCN5Wk9KHOKoSaaIFh+1WTNrASlboJCtgWUsxqHRbyuYI3i0qnFi
 XoLDbHZACaXlu20GWs6e++ozMfx2Xqk8NiWt/IJMc0vxE+6Svx0Lhbfx9eRhOH05nCeiYKys6fy
 zz0IkWQ5gf+B1JNRf25OHC+ImPKeaBsZXDRPGzFI/YLQE7ueKGW2hRaF4slJ6GYxGzVwxDLsPPW
 cK56lsSdZH66MfVlw/6s2dvEmntGwhtQ0NDwE/eWnmZDSam08Q2rY9WDtdIHdRgdNukkDRDim88
 vVonypBFXostH3JapTw==
X-Proofpoint-GUID: GYfMgICMIBgA_pNTFCJTqCj81KS5CKww
X-Proofpoint-ORIG-GUID: GYfMgICMIBgA_pNTFCJTqCj81KS5CKww
X-Authority-Analysis: v=2.4 cv=ROu+3oi+ c=1 sm=1 tr=0 ts=699f896b cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=KlNbpEHeXbYZISPg4o8A:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11712
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 impostorscore=10 priorityscore=1501 phishscore=0
 malwarescore=0 bulkscore=10 clxscore=1015 suspectscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602250227
X-Rspamd-Server: rspam09
X-Stat-Signature: 6dyo46tb5o6iswmp58e7padmcfh8534p
X-Rspamd-Queue-Id: EEBA71A0002
X-Rspam-User: 
X-HE-Tag: 1772063084-213732
X-HE-Meta: U2FsdGVkX1+b0uJo0dvVWF/wxJAM0SmebsdLEWlRcmjTF7FB5sjGsX2FArzwrAH273sFHAZD15sRYE0bh3THxe73yda8wr6yS3jXtTFOqOa++RD/0UZulJYCKkUpbIBzXXjVRc5U3Eq3kWE3qDDSdr4oYzpElAEUgSdruSUNcx7g6/K/bw1bry9zTclZyA9Tlbolm5B9iTHwooeUoNltVBDaFIjbNJ3g4BjyesNRgY43AWfPc0scH2P/NAxNWEZixqIQ3SeAxHR+hKplphQHsCqU0irRre49glrcGMK4XOsGpz3nFis+Oa3uk9h1cOYCGvSWl7jg66bJMFjwlWYSoSuyhv/dt58610fnyj5Aou6siT+L66dpoCiD2+JWJq2Wg2s7FshZs7wjyQ7gGW6ZlKj6wuBNDB+Q1EpCaKG8Q7xcAzcvu1RXQsC+YC63AxEBkahgHJECiufjzH8wderY928jOgrwPcsU4tsDQiqqGXdpsE3eic109JgzoiqWuRnmio8vMR8wG9ejTJo54fTC9zc0Z18lsoN7PPyXkV7d6zLKcTYzvgoWXJQ0kgILw8icdg+pHd42KEijDZIawgVXoRWkMpTzRdXSTLKQQMS30kwzCW6NqP7pMa5RmfO++w+6tgZbJ9Fnm/Jw9Gfx2RGn3YGlgTWCqknuufkeTOFyEfDHgUJHNEdyXXJ7k4omJYlOxXLqk2a9MKl4j3T8KUIVAGCjTWUxzrENiUNXG42ffXG5CNn/dNRqSLEW4gDkXa/JQcdt9ObMbnWacZb3QCi02nJFz/lSKV6ID1vIJhjwOa17Kc1I4i364e+fkk+WmxrqBY3atQxe6kMI61mZTO5s/OV/GTzhjwJC5iJviGyXoefi/YsjFPU1q6SHAH49NmeUL6WZme3fwL+Vl8LRadfVO0fBV1nNxcS0POiWbRWBwk82lcmQTbT7W6XLmJleTaw4V4pK2uop8CNfb88DD2B
 yS9FXpax
 g5R9BWX6bEXxoKGsuj+XzXDnx/2ezhMGAKyHL2E1Y9Xv9q/kKGEVZzy57invRpa/GFOy8sO7AaNFE2WjbwzjUXWkl7vZtnShhIIBWAo4Y1o2Fm6wA31AGtIvrJNhfQka4o1/glv7M5VFq/hDQyoTyw0As4Y7OnGXls103b911qUiUQpzMOcztT7e31onrgAL4Jr/OU0v65n6dxJlby9Qams8D9ehDmsIhsgRkJFI+A7H3TCYFUyDVcY9uLINJReOrWAPiwjx6FBfxIC0EaCon0P96e+CFo946aXxhLEa7YfbV0EH8KdyuocRprF8rL5wYTa948uF0JLjUtkkONw9M6kYKR79W47EXpKKMvfg2IZ41EanGVstt6TLL4rldKLvIXXQ5fSEkB85csnHHm8EGXgy6Uq0qO3Q4LA7iekQQAVTN2goabp2VztpPyPBB22LGp+4jC78kbGqIMBBitUnt9xgVpIsKw3fM+YGdvSF2lBSpvPt/zQnbpA02H54AHrZB0Ht1wU5P5lkP/3vjpK4oEnj1lfWUn2lQmH2Rs/9CMjd3OC9sMY4XLcLYB1HxgDX92bQjW6nS0w4/WE0nvCFqdRm/aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
pagevec"). Remove remaining forward declarations and change
__folio_batch_release()'s declaration to match its definition.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/afs/internal.h       | 1 -
 fs/f2fs/f2fs.h          | 2 --
 include/linux/pagevec.h | 2 +-
 include/linux/swap.h    | 2 --
 4 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 009064b8d661..599353c33337 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -31,7 +31,6 @@
 
 #define AFS_CELL_MAX_ADDRS 15
 
-struct pagevec;
 struct afs_call;
 struct afs_vnode;
 struct afs_server_probe;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index bb34e864d0ef..d9e8531a5301 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -28,8 +28,6 @@
 #include <linux/fscrypt.h>
 #include <linux/fsverity.h>
 
-struct pagevec;
-
 #ifdef CONFIG_F2FS_CHECK_FS
 #define f2fs_bug_on(sbi, condition)	BUG_ON(condition)
 #else
diff --git a/include/linux/pagevec.h b/include/linux/pagevec.h
index 63be5a451627..007affabf335 100644
--- a/include/linux/pagevec.h
+++ b/include/linux/pagevec.h
@@ -93,7 +93,7 @@ static inline struct folio *folio_batch_next(struct folio_batch *fbatch)
 	return fbatch->folios[fbatch->i++];
 }
 
-void __folio_batch_release(struct folio_batch *pvec);
+void __folio_batch_release(struct folio_batch *fbatch);
 
 static inline void folio_batch_release(struct folio_batch *fbatch)
 {
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0effe3cc50f5..4b1f13b5bbad 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -20,8 +20,6 @@ struct notifier_block;
 
 struct bio;
 
-struct pagevec;
-
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */

-- 
2.39.5


