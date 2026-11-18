Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC20A606A8B0
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 04:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=D+tgjc3n;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=ebBvGIVm
Received: by kanga.kvack.org (Postfix)
	id 1EFAC6B05B5; Tue, 17 Nov 2026 23:29:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179D66B05B7; Tue, 17 Nov 2026 23:29:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0199F6B05B8; Tue, 17 Nov 2026 23:29:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7B036B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:18 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9118140609
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:17 +0000 (UTC)
X-FDA: 85446960354.25.7981512
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3C7E340004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=D+tgjc3n;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ebBvGIVm;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794976155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7289YXaM//7fO3vmjy0krlSMq7JNI/I55b1Tqrw8TVE=;
	b=6fQQfDPqOFZJacZmB+pOV0QivVIU+7QVOdaWaS1xp614SH5yCv8+RRhQSWGSy0lW4lWzrk
	SJjBAu5/egq3jC4FA40w+W+pPZ8yZzU8TbeZcBgibHTKBpxcbf0aoi5HIuPYXMkpTT0Kze
	izCrUBUH591OPhKjRvXNs/3021EKX/Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=D+tgjc3n;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ebBvGIVm;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794976155;
	b=wPOA4a3ARThOw1dDHF7OOIPTOFhiUuuNuzdfSvY3FT7Po1D+MGuI6rpjr0Joz6p3nmdbbE
	bpQnF3zHrHnAd9g6kuGoqM7srTsmrfnN2ubgwNVR9j8ZGW5QES0QOyv5KASLidq+ShxYkj
	SoYEf0HbQcDFuk29dtYTRqSxCXozlSg=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI1XSEH3280061
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=7289
	YXaM//7fO3vmjy0krlSMq7JNI/I55b1Tqrw8TVE=; b=D+tgjc3n5T9eWM1dnAI8
	vg/1W/rALeZZWof3IhNmi7Qs0A9z81k3nfwgwKFoomptRfUvp3966Milx5QG5Fkn
	0RIYkB68ie15ZAXwrzvEk9ZoyNTU1w2rYiIUqscHDmOVemogrQM4IoSUkjfrftTi
	q0+ZUlMpXiUgZ6Y503fUScF4XkAR7inxnzHIragKKjuNUXpuhfk2lW3QO8plWbk/
	UGKIXAFV0UP3PN31BPX0u/Pq6KMoFrCoTxSs6067IUDImCgai0XA5ZMVELxYPzT1
	lMdOYG99AiCwLbzfKziBzXg+bMDS9ej5ILKWoRYMtEzMV9rt5wTF8wjIaiyheI5X
	kg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j0yu6sg8x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:13 -0500 (EST)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-94960131b4eso115015885a.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794976153; x=1795580953; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7289YXaM//7fO3vmjy0krlSMq7JNI/I55b1Tqrw8TVE=;
        b=ebBvGIVmT4tAjpP1rz6ir9pd8blk7V/+VyQy8qPShlLu0HRTrVIEUB3llOxKBTP0Mc
         ZJjz3+9PtY26grrngZl7JLrniJEwb+IlHiJxrOXc2ATWNvV8n0IAMvxvuzMzBjcvpLfn
         bO27Wo9g7SvnMDOpMOdi3mNLrgR1P4w1FtujtSz60wAfcklZ4u7EftRI0fWz2eXZGG/o
         kdzsaohAnKXHn1fy6bkjDMq1IGXlYX2fHi6GBorhFNC8/uRG3pPirKdf3hnPXc6nNmJt
         BxIOOWUVC9yfgW7NpV2ewzw6h2f4BQsuXnigEglopijOKvrv5B5tSQ4oZ/G4X0SbgDCR
         BIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794976153; x=1795580953;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7289YXaM//7fO3vmjy0krlSMq7JNI/I55b1Tqrw8TVE=;
        b=LtWMZGxWNw3++Vkp9bq7f18+KxBBb3vZAlCOQXGMJFlLnzdLuvusaOXxcdtVOiahNz
         1fVQ2HiA9UhswopVx9ztMeajdgwzY0+3+HlamwIaC4NPrUmUa8CwnVdkZVy3TIb8LP4Y
         PloxmDqvnfT80hTQo6K9pzDxq6KvRDpnPTAoVPSmDH/RLK7dpUGanTXBqi6mb7Gge71Q
         /Ha+bikJWWhegwNBFSTZNB2CteMyX6db/zhs8pxdssNx34aIMAWerdbNzQg72pnLvoDc
         YFzgEwsvZj1gS5F4PrxFggFqZI2ATZHyP1qX5h4nDILVlTKjTeq+psglXNp+9/TOJ+om
         xgfw==
X-Gm-Message-State: APuU4Z/j1UO2c6wfWyi/lvIXU+GhBSneVonOqbI8u7j/2Dyyr3Nj9eX1
	28sRJTymQzgPBEQYehDGb9fWXjccATnpUlZsvUbxYn18tWko+tWmMb7p4AvjzJd2+LgD3407sUn
	lNbvoSDF6eMAvAZlaAzQaC3IJFq12Oqt3GSWdQfi4n04w2+WX
X-Gm-Gg: AYBFou37BoyjKIXm0SFgdryEojStTb1RNAg7y4jjC6gvS11M7yIE1bfJAQZn00mxvs/
	cuSiUKJ2Wj2W6obm815KEuO4hhaAEcKzXIsKWNhEYYczUsw5X3vNrVuFQS7CH/7ABbemd7bafx5
	eCErLE6wZ7zUiegN2qWMwj0bv3exInxvVDf+D/d9pkPRjwjt8wrfwMnuXfLvONPX5G4O29ooyjD
	96pozz6BYUZPD8irp9s6c3lDuUYuEboToh8eBVXrACx6xGoCwXsjyVmp4nFGiXw5JCX6qEarkLo
	ZRvEtnX2fhj+fzheKo0wuyh0AIJKxW+WC5mnT8v4B+nNaYzuPAoSRcJ09iAXBRZWSWUDHZLcjq4
	5HU5nqmH5OSpVrAdPBtHadiT66Sw+fqKiEGBjRzBiAQgp8Fv9HeKxOKW9Cc6A4tblul6Fh9LKpL
	YW5vD7xcujwkQe+bgDgA==
X-Received: by 2002:a05:620a:648c:b0:949:7118:47e3 with SMTP id af79cd13be357-949997ae5aamr287928685a.58.1794976153369;
        Tue, 17 Nov 2026 20:29:13 -0800 (PST)
X-Received: by 2002:a05:620a:648c:b0:949:7118:47e3 with SMTP id af79cd13be357-949997ae5aamr287923485a.58.1794976152909;
        Tue, 17 Nov 2026 20:29:12 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b743a8bsm89678085a.17.2026.11.17.20.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:29:12 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 17 Nov 2026 23:28:43 -0500
Subject: [PATCH v3 3/9] fs/proc/task_mmu: downgrade writable migration
 entries in PAGEMAP_SCAN write-protect
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-uffd-state-fixes-v3-3-b617009d1a4a@columbia.edu>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
In-Reply-To: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
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
        linux-fsdevel@vger.kernel.org, Breno Leitao <leitao@debian.org>,
        stable@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794976146; l=6398;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Z0rU5WQNPjJ3mHksKsJWDJfedbCcJMJetTMLG2vLB2w=;
 b=XRNKM1Ps7CsF2NIY2cPR/5N7gPAIoUgLViuopj/ZmKmBllYfk7tlQClC7AC3NNR5wpkG8MLS8
 LI2kMb+hAcEBcaRAuWV9rfWeSrlnYobKmxBRbHlHaNma8CQAC3tZJq7
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfX+4Z10Zcwy75b
 rtuDbIqAQFfWgck3dVLU2qzUMsIOcIgq4C7Nz2edl7O/0wpLN6XT2XTgrWcPzrqcxAZQnCDCkZ5
 2PQQfPvNrE+oR3nDVDXnxaB2cQrs3JaAmO6+SzN0EJEOe2GEk1GpnzM9v2+7REugkxVPCqg9n0u
 Cj4Iwx+8Yur/2He51CvwwOiDxls/rZcThenkKh+q0TaYRRog6yNHcxdLr3ubOzp8lbm3PV4QbNA
 B7SmXnwloxuY89IFnONUt7FaT+vo/lvRsJvNS0obkl6faJqz6BXRAO0v8c89XIIvdIEyf3B8zrF
 /tRM+uJIaGMbh0v0p9lyC+fwLUDAZuL7vkrd3dotxGlJG1eeaTjW21dIYVaym4pPEUDBhEILlhB
 OVSNC0HlKnsBmqIwk+Jd2nfRvwlE61MMCjPr/AQYAQYXWawa84aSj5vYjf4XB603UTkfe6GQfZM
 VE4WtQaf6YSP98xzliQ==
X-Proofpoint-GUID: JNSRvOB2K1uTk4d6l1ckZDpAvDY1B_Rs
X-Proofpoint-ORIG-GUID: JNSRvOB2K1uTk4d6l1ckZDpAvDY1B_Rs
X-Authority-Analysis: v=2.4 cv=ZIJCCn7b c=1 sm=1 tr=0 ts=6afd299a cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=xNf9USuDAAAA:8 a=tHa68p0SAAAA:8
 a=lA3VTUfxpHkutY0wpvIA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfXzQ7fZES8c9+M
 nNXtYCVqO8YL3y+GNXFIVmjDRNUhoxgVPx+3aQIcmWfUU6bYfVhccMezbuWE+CSF+Plk7SwKxpP
 lD6ReC31eF3DNaU56RToTJ/bUv6pNmCFQz+NT/OSxcczrK+7LADV
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11969
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 bulkscore=10 clxscore=1015 lowpriorityscore=10
 priorityscore=1501 malwarescore=0 impostorscore=10 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611180017
X-Rspamd-Queue-Id: 3C7E340004
X-Rspam-User: 
X-Stat-Signature: 4sy1go9twr483kh3t85exuadp6cqbcu7
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794976155-223778
X-HE-Meta: U2FsdGVkX1+wqOV29sTBispHC1Dr7E3ZvGUtrPVn10CYKPOW3Ydp6STEBRlH9BGmp/Ibg91abhTQiaqGEEP5MGgqWYjWzCIlRCquDE7CP035SEcW9L3heV3nq+gco4j2WkOYj+55MMYOzXGEWRvW5sZ/unajUx/HwuxHA4mJwSuYLbXwgXZSoKeGpC9g4x32LVypJzvBlJxHcTdR2doL+0nia7Xlsmfy7yyMdRO/ku5lH7kufepaemDRNzJbhntpExhvhMc9VGS/dt2GQUnza5b7zZ/+cW2OaD+qfSwodCL5ndAHOSLqfOQN8G/1AokxT++XCdcdCzEKO+dXgkGCBQDnJLCk6csZyvclJo2XmFWvZwV0ICSYK1ZZXy0kit9LiUOpYN3olYsXs+99WD+ubZK5Zq1q4B9jC5Asxl4RQ6py3a3wi7iIZ4fOwSJV5l5afOeCrvfsscC8sYcOnKEo200LdHBQlMlbzDz4RXZP3e/1Ib5FR1kJ94mdKPThjA3Kye4C0F97pYqChybV8xSylaW3+lgppNqsZBcSjmY/K/UIxZiIGvDBEEC0H3WEs6B21CdsaRqlUyTdIQEyBl3tij+es+fB17qzgqBOl4J8Dg19xeKEntUuq9OfDEeSHSyjpO2ujElTWuPeR3ZLMiH0od99N1YYLxdmRABopYhmiSjVLmfiJU4578KNmiqhWrRNt6/4lxffhDxyuFr+QjquU+odKZCl+DhpL8H7IbqVEqqOWBYJrVnFBfWQ1FS02ymmkJ+t5B1zm1/cPs/66op0JD2d3jCv4djcLAoeVPZobqsZQexJbs+fh8m4iQF7ct6vs6r8jEBHFwtQmRWaZ6lIPnSDfxSgUmCflh+F+IEwsignlp9wTmBphQZvEpzXEvigmuf6DnEh5aFkq+bnPCZlaDn/yQd4QJ4yGwmMHzkXxpd6LbmCR9Qh9WQUfzwAMMoC3ysB1wVAnCCseXfYSCV
 VW+zXNqn
 Qyw8n+3YFIEV77056XH45gQPSEUSou9OkgUro39iz3Jfu0C3ri6Qh+nQjxim/jAJqBo9qgpM5d0jtfPNoTr63jtz+rU7C5ieGo4JyXZohC2DFLqsrtftqaTW/ZbRPaRiNsZGildtkih04/JLp3gdI3novJpC1Ui/drgjwIP8t/dWBwibetP8nXWMRwstLl+zDaH778RvX7TS7O9f70KaOU9fZ/sOFWit9023jwljbWFWgEu5Ppr5FnA1iWgmbFAaVrZnrVvoNXQS+J8md8RsPeT7U7aI9/bPm9/FlDZqNlAy+h+6tR3424C+sianwhY/ZklvdQ3Ck4P85SjiGseY+XEJbd/VlHyIiFVdEFE+bEgHex7dKjefu8eUIZi/QA6AyXeYVWzYgwdQ/REhz+h3Ht/NiKRtMzAH65YhYU0G2qUGsP/KcBy9NhZlJBiAhTAEyJbWRowpv9EjB88Q6MCZBuT2aSHDyTLy0Hpe+tRyDD38pd39DSTYrYjU0CBUtAyIDjIt7AsP5XfFSMzEcq4Lo6iQ8NqNrjqMlY+0xi9q3K/4P7C+wvAP+d2tsFx9UmNQyidX8WnQPw2nl9i3n6C4y1RBP/kH5DxLkCio6tilHCvKQWYoAm9FNg9pH/kgDmZVuqeqP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects pages in a VMA
registered for async uffd-wp, and sets the uffd bit on non-present
entries as they are. An entry with the uffd bit set must not be
writable, so that the page is write-protected once it is mapped again.
change_protection() therefore downgrades writable migration and
device-private entries to readable ones first, but PAGEMAP_SCAN does
not.

For a writable migration entry at the PTE level,
remove_migration_pte() restores a writable PTE without the uffd bit. So
if a page is under migration while PAGEMAP_SCAN write-protects it, the
write protection is lost. A user tracking writes with async uffd-wp
sees the page reported as written on the next scan although nothing
wrote to it.

With CONFIG_PAGE_TABLE_CHECK, setting the uffd bit on a writable
non-present PTE or PMD also triggers a warning.

To fix it, downgrade writable migration and device-private entries
before setting the uffd bit, as change_protection() does, at the PTE,
PMD, and hugetlb levels.

Add softleaf_is_writable() and softleaf_mkreadable() to leafops.h for
the downgrade. The open-coded copies in change_protection() can be
converted to them separately.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Reported-by: Breno Leitao <leitao@debian.org>
Closes: https://lore.kernel.org/all/avNEgmvYdoukt6MS@gmail.com/
Cc: stable@vger.kernel.org
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/proc/task_mmu.c      | 40 +++++++++++++++++++++++++++++++++++---
 include/linux/leafops.h | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 22361607020d..0127bf9c3f77 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2395,6 +2395,25 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 	return categories;
 }
 
+/*
+ * An armed entry must not come back writable, so downgrade a writable
+ * migration or device-private entry before giving it the bit, as
+ * change_softleaf_pte() does.
+ */
+static pte_t set_uffd_wp_softleaf_pte(pte_t pte)
+{
+	softleaf_t entry = softleaf_from_pte(pte);
+	pte_t newpte;
+
+	if (!softleaf_is_writable(entry))
+		return pte_swp_mkuffd(pte);
+
+	newpte = softleaf_to_pte(softleaf_mkreadable(entry));
+	if (pte_swp_soft_dirty(pte))
+		newpte = pte_swp_mksoft_dirty(newpte);
+	return pte_swp_mkuffd(newpte);
+}
+
 static void make_uffd_wp_pte(struct vm_area_struct *vma,
 			     unsigned long addr, pte_t *pte, pte_t ptent)
 {
@@ -2408,7 +2427,7 @@ static void make_uffd_wp_pte(struct vm_area_struct *vma,
 		set_pte_at(vma->vm_mm, addr, pte,
 			   make_pte_marker(PTE_MARKER_UFFD_WP));
 	} else {
-		ptent = pte_swp_mkuffd(ptent);
+		ptent = set_uffd_wp_softleaf_pte(ptent);
 		set_pte_at(vma->vm_mm, addr, pte, ptent);
 	}
 }
@@ -2467,6 +2486,21 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
 	return categories;
 }
 
+/* Same as set_uffd_wp_softleaf_pte(), for a PMD. */
+static pmd_t set_uffd_wp_softleaf_pmd(pmd_t pmd)
+{
+	softleaf_t entry = softleaf_from_pmd(pmd);
+	pmd_t newpmd;
+
+	if (!softleaf_is_writable(entry))
+		return pmd_swp_mkuffd(pmd);
+
+	newpmd = softleaf_to_pmd(softleaf_mkreadable(entry));
+	if (pmd_swp_soft_dirty(pmd))
+		newpmd = pmd_swp_mksoft_dirty(newpmd);
+	return pmd_swp_mkuffd(newpmd);
+}
+
 static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 			     unsigned long addr, pmd_t *pmdp)
 {
@@ -2477,7 +2511,7 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 		pmd = pmd_mkuffd(old);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	} else if (pmd_is_migration_entry(pmd)) {
-		pmd = pmd_swp_mkuffd(pmd);
+		pmd = set_uffd_wp_softleaf_pmd(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
 }
@@ -2547,7 +2581,7 @@ static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
 
 	if (softleaf_is_migration(entry)) {
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
-				pte_swp_mkuffd(ptent), psize);
+				set_uffd_wp_softleaf_pte(ptent), psize);
 	} else {
 		pte_t old_pte, new_pte;
 
diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 4c1476ae3234..4c016fc28690 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -434,6 +434,57 @@ static inline struct folio *softleaf_to_folio(softleaf_t entry)
 	return folio;
 }
 
+/**
+ * softleaf_is_writable() - Is this leaf entry writable?
+ * @entry: Leaf entry.
+ *
+ * Returns: true for a writable migration or device private entry.
+ */
+static inline bool softleaf_is_writable(softleaf_t entry)
+{
+	return softleaf_is_migration_write(entry) ||
+	       softleaf_is_device_private_write(entry);
+}
+
+/**
+ * softleaf_migration_mkreadable() - Downgrade a writable migration entry to a
+ * readable one.
+ * @entry: Leaf entry, softleaf_is_migration_write(@entry) must return true.
+ *
+ * Returns: A readable migration entry for the same PFN, which is exclusive if
+ * the folio is anonymous.
+ */
+static inline softleaf_t softleaf_migration_mkreadable(softleaf_t entry)
+{
+	const pgoff_t offset = swp_offset(entry);
+
+	VM_WARN_ON_ONCE(!softleaf_is_migration_write(entry));
+
+	/* A writable anon migration entry implies AnonExclusive. */
+	if (folio_test_anon(softleaf_to_folio(entry)))
+		return make_readable_exclusive_migration_entry(offset);
+	return make_readable_migration_entry(offset);
+}
+
+/**
+ * softleaf_mkreadable() - Downgrade a writable leaf entry to a readable one.
+ * @entry: Leaf entry.
+ *
+ * Returns: A readable entry if @entry is a writable migration or device
+ * private entry, otherwise @entry unchanged.
+ */
+static inline softleaf_t softleaf_mkreadable(softleaf_t entry)
+{
+	switch (softleaf_type(entry)) {
+	case SOFTLEAF_DEVICE_PRIVATE_WRITE:
+		return make_readable_device_private_entry(swp_offset(entry));
+	case SOFTLEAF_MIGRATION_WRITE:
+		return softleaf_migration_mkreadable(entry);
+	default:
+		return entry;
+	}
+}
+
 /**
  * softleaf_is_poison_marker() - Is this leaf entry a poison marker?
  * @entry: Leaf entry.

-- 
2.39.5


