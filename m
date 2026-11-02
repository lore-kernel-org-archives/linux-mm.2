Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 239D7606A331
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=egR8AAPu;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=gIttspv6
Received: by kanga.kvack.org (Postfix)
	id 37A786B05C6; Mon,  2 Nov 2026 17:54:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32B5D6B05C7; Mon,  2 Nov 2026 17:54:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21A086B05C8; Mon,  2 Nov 2026 17:54:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D579E6B05C6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:54:47 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B70D402B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:47 +0000 (UTC)
X-FDA: 85391685414.10.991DED2
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id CD21940008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=egR8AAPu;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=gIttspv6;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf07.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793660084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9mApYXyVMf8wWl3gldeOyYhwrTicSkRy7tZqqnYd04o=;
	b=UVuIMfuiYuZ11pTFpKH5iBxK8m8oiSrqfqtEvLo/YwnaFtq8nJkKYoQKwH/AzbKhxrcOZn
	iFId1Yp7N2bTZQk68F63DYNZCbdzI7PpX8yujoYiY+G48MvUEnmZc9SoMhRpQOIMqGrzra
	merTQc8pK3khQEHHR2jiiM4ObiBnOPk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=egR8AAPu;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=gIttspv6;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf07.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793660084;
	b=wvvlWmzD8VALkE+jiWGZh8FYpg0xivc0ArioBqnDggeYRG1llqrItOrpjeZ79LRA+p8Pmi
	EaF68o5aCAsVFnLpF48TJO9OwmG00EIk2CScpO98vcWHZHFwC7XTuu0Yr2lhQPYfVPwrYC
	PS/HYaD72bs3AnSFSPtu0AxsyjTDUb4=
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2LY9hD3299702
	for <linux-mm@kvack.org>; Mon, 2 Nov 2026 17:54:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=9mAp
	YXyVMf8wWl3gldeOyYhwrTicSkRy7tZqqnYd04o=; b=egR8AAPup/lxUzDssFWL
	AyVFd1kfHwPxMkMi2GuVuHfDsRFEIKaLkYEXjyGf4Dmghr8ngZbT10w9Z70F6JYv
	roiTL+gXlO9tZg7hZU57Xv7DtXNxcaQs8mSMTIYrT7jXk1uH3Svie7U7ydnnpKKV
	0Qz2VixSdqSORAzH2hTOclwtFadEPdsuSsVaFA7KC3umQM7yBgY7HsmreyGpnW8W
	pIar7yjBsROX7T6rXOSrZnzorbW2MRsB7mnhO4bMRmjhyWEuScjMuyev7LAWBvzN
	mBYnenRZSXCrOBS22/91raI7v1xaub4yhVMGojZqFPJdwaBuqtFxUpexdkxaTGIQ
	/Q==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hpwa6v7hy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:54:43 -0500 (EST)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f26dd2165so456112185a.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 14:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793660083; x=1794264883; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9mApYXyVMf8wWl3gldeOyYhwrTicSkRy7tZqqnYd04o=;
        b=gIttspv6PbJ7iUS4EL4iGqX6tztL/6Q/Fla6JTIa7CXA/k72+WtFJJB8fyip4urM2l
         Ab57POcFLnrNTV7SvcW9HhHDEdtwc3SzIFCEwwDKOYF5/55lMG1nxQ4+h7hXruadgFpw
         KdrMiutVTMehnOxcuwLpV9KJFT25fWZMkskbhRMb1eYrt4agjDC+l2RBhuc7Y5XfmSEs
         NWm9bAscDWdyEuNPJz0bquWhcduhE53fBOhcT08HOKZuqlTy+o1215dx/2B3YujqwBZ9
         4tXFy1CGKHaqWJyNhIm8DUUYPS2GSoGg9R+aBo1cq4Rcy7AXKwlFy/YvTe9Y2Yz/9IXw
         iXzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793660083; x=1794264883;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9mApYXyVMf8wWl3gldeOyYhwrTicSkRy7tZqqnYd04o=;
        b=2dmGFJvS9g3fx6dK4jtTzxmoWnyqez0PyJ05BmBs+Igg7tbAILy8332Wp58mRIPay+
         Iy5fi/Jn0IW9LZ4FpV+ugtTx7/CwbPymSxlVRrJn5djg8kFzLE63aI2J/CLDghN31bmH
         ucv7Nr4DHt7kKWzJXcMy9xFWBp3Wy4WpM0/ZPDfuSN68tFnHGOjnmPzrYZb5jBltyBOv
         KlAaOr0oP5bU+XzsxdK3N7lIeZYKM0gGOvSmO4PdyRl0cPatbrerHIQgh9FB7URnOBuR
         052dpnmieJXxUFwhUkjB8ZMbi0SHpYrx9NRlQLIwW+iCEF5vuv2W+LOLImLG5I5Vcllh
         6/Ag==
X-Forwarded-Encrypted: i=1; AKwUvBzQWal5iN9afDE57/K4Aku1ItET1nF1Dzj7kLl1VnYfHPX8V6g1jV4Yd2yCqWeoDuWQby8duQpqUg==@kvack.org
X-Gm-Message-State: APuU4Z/fU2kBPoYx2GXk3oVX1UHQ35Kq6jZG9cuJCifUfs6Bre29Vrnu
	l5ssPqoJIFvRchyU2KKMA7B0HuxQXzgoT5atpZwJaf+AQt4B4eENe5idN0VteB3suG/gPN2l37S
	Q+g0UY7g3LK5lBxRXBkyv9nVZ32f8Z+U7lC5qULs4qrjdwQzA
X-Gm-Gg: AYBFou2RdfrztFtM7gPHuo/bXNhsyFvf90JJ3o7j+CerfGc1WC3rGO1wsRLJCgrDOKT
	eXVVgVkuf8pJgSetWgx7m18LctSP31fkXlllOe73X8Oq/O+J8PaknH0ETWr/fmWmpDyPrf950Qf
	xyNMdLoewcuR+OXf4GkPzdeXfOPfG6cKCzqGAnFa/QPA2PmMLFXU/Pw3HwiNk9fngCinNDP4LbP
	OENnNZnBAEMYD0SbONnvU34EFkcvFMfCHvvqgAIZFzyQiSOv6oweBcwA1ySMqvyMHs+2KXMaGg9
	Fcb+5GoaAcew8meDWxlBYnmbsOCnDTRYPXi4qxdj8JTn/DI8AHJRvUj9MbBGKd/ROsXWN+qzY0w
	lx5ijtMnByZeCPHWsaWIiYXvtlyx0bGk72sk6Xm7J4gC4+b2dZwEoNHW1/Ww=
X-Received: by 2002:a05:620a:4612:b0:944:14f9:8ef5 with SMTP id af79cd13be357-944216f1f37mr2015908985a.59.1793660083410;
        Mon, 02 Nov 2026 14:54:43 -0800 (PST)
X-Received: by 2002:a05:620a:4612:b0:944:14f9:8ef5 with SMTP id af79cd13be357-944216f1f37mr2015905585a.59.1793660082956;
        Mon, 02 Nov 2026 14:54:42 -0800 (PST)
Received: from [127.0.1.1] ([37.142.157.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8011csm24710529f8f.31.2026.11.02.14.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:54:42 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 02 Nov 2026 17:54:11 -0500
Subject: [PATCH 6/8] mm: remove find_lock_page()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-page-wrappers-v1-6-e7280bdb31f6@columbia.edu>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
In-Reply-To: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793660051; l=1351;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=WnZiaoLf1fsKtQgiDJZzhQv/Ag7bXfwRtEW2BWXMMlQ=;
 b=grLgHIiUTLhVj/AOEt/zWlW7iXhFRri7nXn13M7PaWaw/v/JlVsyYfny63+C2WfvSqYvj7nNe
 A30CPFguwkACa96UKMPYxAYi1hmuInopEbrf8htf8EJMU92e3oURAqY
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfXxleBrpU4THuo
 b0c3dY03o0X38R4wlNUBJVzKVywdVRKhOUlbM2SNME7oW3x4gVb8KFfXUsLtDiXWy2Yhf9QMeEw
 LY4DlthZ2+Hg7XaSQaby4TaHK+lIvHE1JakyNBs6RTXO4yxoN30z0h93JSOUg8Pyu/7piNJJfai
 XpWHDGmFOa1KNdRsU12gNzjPviVZ008raJKEyoeyM56kTVSDItUCgLMicx175HqBzr3z2mTdo4G
 uu83usrKJz6itIa15Kl4sGz3avp/DB2c9HYLAgFVOLaOqJ27nZbudOQ5jFBo6ej+XuirdE5cye7
 FwplD0jH/PrZfGqI86FXE3VgsxStu7g3Sj3D/anWKU+RK/Iz0u4ez9dW5d67LoLWH8tDs9fUU0C
 4/0+cj5+kk4maoOszTPy8rsVkbnXspQ/YNEbVakfMldyE1ScgKC+w0jBylK4Bgl8Qw+CQ6FgCcv
 co9bjH0kWPBww+qwEmQ==
X-Proofpoint-ORIG-GUID: x7YHZs-4pv8faXAp-G8y7n--mWDb4WKq
X-Proofpoint-GUID: x7YHZs-4pv8faXAp-G8y7n--mWDb4WKq
X-Authority-Analysis: v=2.4 cv=JImuIMKb c=1 sm=1 tr=0 ts=6ae914b3 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=Qz3frfIdACK70Hl/8c7MJg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=S2mxmGJpX7xwPQT3_3AA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfX4wmAZEpAK2jS
 GWwosKJ68hGBc+Vudf7L4sDnU3YA1jFAveChKxUQ18mC+Mro42CZ70ElEjnMufsAbHepn6n2NKL
 JFPCWy99PVGawFcB6z7t5CMiAPd/WYGvHXfh5aEV/oOwB8OiPPpt
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11954
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=10 clxscore=1015 phishscore=0 lowpriorityscore=10
 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020090
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CD21940008
X-Stat-Signature: 6pi7zbh716kzf6eb8c1zy931kjxh6819
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793660084-676
X-HE-Meta: U2FsdGVkX1+Jwic1Wky7Tgev8E73CHROHOYkTdKjjQVT11J75cgyDVgCq9vczb1kg2DrjpvPFYg/Tj6YhE1dQnDjO0BdeBgICDRz8GJB6BhnEwKnQXdUEADvGj0JMIHSQtuU5wdv7DeTD364BaVboSNLUqyIhUUON+0PPEbIR8ZY8Wnhmgw3s+XYfT7G04IGppR35ia2qfXfN8UpmfI2AII6iepjl0iZ24Mf4Nv+qWR7MMEk7cNTJmrnqAjanResqbcZa9hQ61MB3Zasi/MiWHGakJqSNg3GN9cKHgPJmcuqypkhRfdP39bYrH9AUSU4ZRe14fx2PA9GHuEG4RANTSBQUrbcoqNlwhtzjmITvUWq/1TduDooFheHjLUCaeYY4/XimzqdP4WN9Vtq7c5KV2FkUBl47vkdS5/zYj1N5OWZYito3duDRc8JihNuZlOfJSgf2vSR3EEU3deaZuAAMTFp8Wvsvuv2/hCTkmKNnhbXVd2+kP8qtQZTsve62/rMn5q+p1n9Jk70s2EfjLq6P1UNQ9SlNL0yf3ZuuGKmDC4S4eytFd/j9D5cti/CY7Ccu34blKPjku2Vlf/F+Zx4vny/Nf6p9T78Ax4H8FUyO6DYOs8VmAHaUW6rp4Q00e1xN5xLugqIr2gkOMwTonhZB7ygcOBptytm0ju9YplUd46oCiGMXU0+sLBAdChKWTUSGdD7sl4zrBjTolp3P5JcW7lVzrH/82AB7OSJVWeDfEYfCEtmeHpIRZV90NnPJbLN121dSdxtAfLzKGgqMJZVlgYgCNnt5jF9ERG2d5YyiQHGJAFRRt/+/634rFQHHf/O9vgatvq+zi2bMHEpzpbeiJqmwgfGt3Eo3t249m6lwEPDPptJKUa0Mo1q0IU186+TBfbZiVMbsLamGLyzKICJMxgdUHujETPJou8xAA5XuEdKCPdGUnBvUnVwmHKBYMvNTW3WyWO9V30vY4gJ7pm
 MKNSceLQ
 Q8oDonaOOCHDwVw6ghfX3KhbcSsAQErl9JulnG9gafbgr1qbAwyKDJ2+3dh0xoMyPNODrmBzAYCcdl1GLAxK/QZfXX+6o4CLnQGbGChdP/Y/unvDFei6dXdUG2aHNyVUzz+PRqUx+7xfnTmZeDHK7qwvZd89PWTFSWGgDlpP73b9lrf4Qhp3ObuTzOLK763rpaO/9V8DcTrClUFfzbywfaY02NsPVybEKzMF91/8tq5ymDwBvv10DHhdEluJ2GZSypa4KO+q2Z98h30NZKP44Bo+S8KEpQ+cfJZz0hLkmHRLA42o0KFOGJl7sxNCCrVjN6EWe9IJ+tEDtMW5VgAKkP3HrFM1H9rTwezQQJNsRxaHakqdtG5aWcFrw5x8QzfN9ci7p6OUnGnfA88f2BMAPIChcBEn3MzGi34rpRct6nAj3t8rYqwjtNy1P17doeeKEB/VPUOLFkPWsaFZJhLpPwzC2UoX7H6oa4WcptyTv63xtuWe0th+3V7UYqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There are no callers left. Remove it. The name still appears in a
sample function graph trace in Documentation/trace/ftrace.rst, which
is recorded output and is left as it is.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/pagemap.h | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 00e32f96b459..a92329805acd 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -846,25 +846,6 @@ static inline struct page *find_get_page(struct address_space *mapping,
 	return pagecache_get_page(mapping, offset, 0, 0);
 }
 
-/**
- * find_lock_page - locate, pin and lock a pagecache page
- * @mapping: the address_space to search
- * @index: the page index
- *
- * Looks up the page cache entry at @mapping & @index.  If there is a
- * page cache page, it is returned locked and with an increased
- * refcount.
- *
- * Context: May sleep.
- * Return: A struct page or %NULL if there is no page in the cache for this
- * index.
- */
-static inline struct page *find_lock_page(struct address_space *mapping,
-					pgoff_t index)
-{
-	return pagecache_get_page(mapping, index, FGP_LOCK, 0);
-}
-
 /**
  * find_or_create_page - locate or add a pagecache page
  * @mapping: the page's address_space

-- 
2.39.5


