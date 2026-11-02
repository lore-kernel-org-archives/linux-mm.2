Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BA7606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=JQJRUwEP;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=wqgp5nuG
Received: by kanga.kvack.org (Postfix)
	id 464796B05B2; Mon,  2 Nov 2026 17:54:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415676B05BD; Mon,  2 Nov 2026 17:54:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 304166B05BE; Mon,  2 Nov 2026 17:54:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 083736B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:54:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 067B6C01F1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:23 +0000 (UTC)
X-FDA: 85391684406.23.CAFD680
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3B3561C0002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=JQJRUwEP;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=wqgp5nuG;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793660060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5sbOCMDhjH6xs6PfuYcn/1F/Vkftc0vzSyYkPk5CQWc=;
	b=Id2ot66sml+8Mc+bmWsbtXx1SxWqfrAaRLTJb3OMXKczrzs84vW6qXXbhM/RjyO2XN4vqP
	L9skLrym4nbpdUELQ7D8x/RhClHcDCHyD7r+1qV4yBL1r35jy1orufffjo/Bw7G35aBB3w
	g3/rZofPsQpNSzymVGGF58yUvfjrBuA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793660060;
	b=t3QkJjex9sU7GC6oeh3QBehG9R+OjUJE8pX/04SMhTQ7Kj2oKjqFWznUIh/2VJoyn56RIp
	dq4tAVCtFpX/TpE9qdSq0nBkKbWaeG3UD4Sbyjt2UKNHkOKfpns4aEQoz/h9stkUKrAXyY
	jDFl8Oz36T6w2oQU6756yRI76HczZxI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=JQJRUwEP;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=wqgp5nuG;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2LYILR1775110
	for <linux-mm@kvack.org>; Mon, 2 Nov 2026 17:54:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=5sbOCMDhjH6xs6PfuYcn/1F/Vk
	ftc0vzSyYkPk5CQWc=; b=JQJRUwEPyQiLxEVGHM4Ratl59KiwFIpdw1D0lRKm7s
	zbX10Ts48hSZk1T/N4anutoMyZK468rvcgAFo6PfRUz74NCmdAdpr+BHUW+2YEIi
	7C9THXlVGe1Mg+jNAEmg7ndNFP3+MsCHBykeqyG7yu0JPRfF3DuEZ8Cxrt1aYoy2
	TfTRYX+frhAO1tQBpNJr5VNdonZXZ5frZ8uSgFEOh8Fq1WRxOlV4yK9Hs4hguTKE
	W3enCqdryBK4aB4kW1Et4ed5jxVggsW2cwSuK1BhhbHwOuHZyI5NOCuAWHnYGT49
	zqVCVIKKNOiYpt3Q2oNIIn9M1gPYnXqXHbvGTocGWNvA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hpx0juefr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:54:18 -0500 (EST)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5363fa3d3e4so70278311cf.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 14:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793660058; x=1794264858; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5sbOCMDhjH6xs6PfuYcn/1F/Vkftc0vzSyYkPk5CQWc=;
        b=wqgp5nuGCRW/DrMUhNomXnf0h3zIUS5hNxOnr45v8aJDw4CKjd2UxHhZ1nnhlZJ2sm
         xZ73mSnlQUD4u4BaPIxX632r1EgW0WxFipM5IaEbbdyq2s3MN3U+l9zhxL4nWyhb33Qm
         MDiPl/ZZfA4k6ow/FqM9Y6KcbzWTygM8TCtGj5Y1JmXWT051TYpH/vfAMW3PTh/cMq+t
         3fgkKrOO/8i9ejcS07ABnTqo0+B2dXzeOtnLQJfP1OtX9q/+P0ZZ/cuJlaTVkNfou5U/
         +xLFZmEBtCpivW2au/sZBW+S8acfPzeCkuEeqwdlpXjHJ9HCs1D+uBVmgZ7RH6RzN5sj
         ew+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793660058; x=1794264858;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5sbOCMDhjH6xs6PfuYcn/1F/Vkftc0vzSyYkPk5CQWc=;
        b=UaAIk7NkSvSQW/lUbpNF1YrHyLj6qg7IO5LO9NsCRs70aUn9Rpu9eib+QUFX999MVK
         2Ru5DCZZFMekIPZ4hefTF4gufKkgHV60icALF0WmqvLfZeLbDOwKRzu2nowTI/TbbmBO
         dHd7r6iL1wlcodyPT2vR+Nlb4F25nZLEQNLPLAEwyaf8D01DHwdiKp6iGc+QoQINL9fR
         s5acS/DYTLdfZ5RM0Z24oYvDIZWxhGlD63dbPcx/WwpJEJ4z07xYIelIQPtRo9Q3hzBJ
         bX7hgp8Bgtkjr4Iz6ZdtVbOx9r9MfQRAbVa+MjTNiVcORPuvzNQ/TAjyWtUvFhaP/CoU
         yiSw==
X-Forwarded-Encrypted: i=1; AKwUvByKWPXQmDvuyOSUGqym6he/BnkPQhP2gPA/y63WZfqIXuE/NEzrbWuGNzSCKiAuSS5hxfaCLJtq9A==@kvack.org
X-Gm-Message-State: AFq9FYI+RO5JzyxAqCtnwK76qWzfUNadY58Cy78TbXdlnwl7l8mw0sWM
	BuCdKj/lgNNoHsh1I337kSyzM68xojTbzsu3hazKksvqv0ZqymKTvD6niRlh9g1N+YuY6wloWRh
	PG4CxUh25zQEjeSFqq4gpLh6v0FMUKiUdS7iyMayqZA6s+kAq
X-Gm-Gg: AYBFou11y1l8turOCfZ6kfnfex9WOiP7Gr57hJXmjbbPO1sQmP7GogE2EuAJqMULnvm
	IqjrS/YgBkeymOw3SHd7UOwbogue78NNgNTrBoOwU9Qda521TAD94DA3Qucf419zRWIi/Pzv8CO
	dPZUaGwFhKqskh5/2SP7SBKXUdVtesneA6XKd+vEi0wO0ZMOtYmUhbbXKPASe7x2GBrCZtWmsSR
	kXYEpRqlXqf7za+DLXGtmg/NYHQ9yS2qYVb1WruFZkFggfFRxarsWq9JxRn3Gg6la/C8XSzSAvf
	ZxeoOM2SMH4uwodtcOKjklaK1L0VzikWNcVLn8+FIcXRs2Sp6XrOYWBk/KnTmo6/ysDT2Iub+Fb
	/GiJGzQLVDy1j1i4mgf1eAksLEUwIVCcxjWW1cuu4+H4DnZj0opQ4jxJ1dis=
X-Received: by 2002:a05:620a:2984:b0:93f:2e7e:c818 with SMTP id af79cd13be357-94421799c57mr2002812085a.59.1793660057777;
        Mon, 02 Nov 2026 14:54:17 -0800 (PST)
X-Received: by 2002:a05:620a:2984:b0:93f:2e7e:c818 with SMTP id af79cd13be357-94421799c57mr2002808785a.59.1793660057322;
        Mon, 02 Nov 2026 14:54:17 -0800 (PST)
Received: from [127.0.1.1] ([37.142.157.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8011csm24710529f8f.31.2026.11.02.14.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:54:15 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 0/8] mm: remove newly-unused page wrapper APIs
Date: Mon, 02 Nov 2026 17:54:05 -0500
Message-Id: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAI0U6WoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDA2MD3YJEoFh5UWJBQWpRsa6xcbK5hblZoqFBooESUE9BUWpaZgXYvOh
 YCL+4NCkrNbkEZIhSbS0AkhQ/lnEAAAA=
X-Change-ID: 20261030-page-wrappers-33c7876a10a0
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793660051; l=1410;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=xHmePMIFwKfnW6rP/IxD2rFrXi5dM4an870KORSbnuU=;
 b=lG6joMyHvVMs3XovIiL7A9A/jTYzjW8jix0W6c/VcH0NsKuUnCsyuQiQ0VA4GdCMpBG15G0Te
 VA2TieMfdb6Cn5Mgy/khnHItW7rGq42QwrVCPc95P/HiD8C3OfrIONw
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Vpe2kO2n c=1 sm=1 tr=0 ts=6ae9149a cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=Qz3frfIdACK70Hl/8c7MJg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=VwQbUJbxAAAA:8 a=e6GcmG5u4wsWJsvmOGMA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfX8bPnKREXpTkl
 tKreoOux8FCpbXcmg5lhl+ZcbAUs6jKGYHcLUYdVjmGckeOo/fjVYiu7zqxYxx9dCQyE1MyOq3/
 j2Nu7JFk93JpjXiBMyFvRoNdfAnIQrrfancCR5H5AsRdCb+7HOtBa/9dJuK9EIsMiBOJHLozXVM
 FzKx9w58jiGKEfIvJZ7/6nvHGXI04r2wAbq9SIqjqaL39hV646UdK0QpyqqO99CBKcYRFXAnaeE
 B0sFkJkKGC5WkjTyMzarwCdDmBod3ev0mCGmmg5794Z+nd0UsBklSi01S8F+QO+eGqczgg6JwRN
 ENMtWtXShA1PBS0V6WfFgQ14jwTnz+dc5jrRF/wJeLu73H2G2G0VY+zzRbwVjoFdnn9C8EMbK7X
 0AcYkE4fP437VvPgtCFfRZnWcapi67rcx/mJhx4Hvdds+jbpSfqOdUgreMYC5s+VcVoipUH49Ry
 Bj+9d6Hi2uK/ui5RpVg==
X-Proofpoint-ORIG-GUID: vTwNILDZmsjUJgq5BPvPNd_lgrzbVRJf
X-Proofpoint-GUID: vTwNILDZmsjUJgq5BPvPNd_lgrzbVRJf
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfX58eilsG1n6Ok
 YHoqKnchLJKukbM/x3rafQq/PTrlA4/lCRen1Uyt3ULcHgP16fMvPaGN6NeAm5B9eo1V3cMGoJj
 oYKdDt2oT8/Mhc74MXeH7YC7DslLBcRi5Y5hC792qp1i+Iw4+jhJ
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11954
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 bulkscore=10 priorityscore=1501 lowpriorityscore=10
 clxscore=1015 impostorscore=10 adultscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020090
X-Stat-Signature: 1u4to6n35sc57mzondy69jkmqa9szcqa
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3B3561C0002
X-HE-Tag: 1793660060-526542
X-HE-Meta: U2FsdGVkX18DMcPZkZMQjTogJzdCUGwTmWnwaKUXY34nHnch7Ie31Jd7zQdfC//VtAaaz8//v1/mzOfXnutAATsPM3D/u18CLn4xmODRYQcYJDOzyTz+4qn6B/xuk10bF/DBWmCSDn3En1uB67p90Ynsbk3MNXV9Qxq1LTaXNy25u13cFOhq0l3rqV1kViscE7q8G2i7xpkWhtQmttbnzM512Nm6ZWznnK9cV4pW+8mIMS8pZMVkRamQw+IDZdRAZzJ6EztnXMYss1MeF9KJ/06kXIWk7R/EHPmMWiUQkeJOiZ5CT0hi/jQMr5XyPJ7k/zwDen90TE1+TeYIyrrGoulOY0Bstn9Pz25BbiUoCEjHyRCYBcLFP0X5c7Wgt5wrJjhoqx0v2ZShPaNcMM7HpFqQq+RlVa0JqKWuxbMyIVQUwFNWhTZoDKdVQaHq8XUdL63fslKzHBm+rPi21nAC1yCkvjrqjgGzBlW67Th0qsSsx/tkon3If+xjVS48/k1CyTFckl+Tah7+bEwEsCBmEaQ2mPmeYJa3gn3SZZQSNJWsCsbeSxkJQ2yBwDdkfxUceoPG9E/f61RtbOk57H0wTiDQVEurPhSl060DXTDVof/lJsCgMFVB85TyCX+2rlu442ym28Osk2wCXA5rYoly1Q7klIUcEDTrxQZwPYRwAEq8nLTeAokVngh3Af4qVssfnBAeY1X7S2sorfBVfxF/k/Zahe6AslX071tsHKvfVURElBjfue4Zzq10brQZa1D2IAn8dn0RZgpcEL752lpjeFbjGYh+hcmziTWRpES4UsmI5azjkNgZPT5/bLQOZoVAjFkG5/fKbVwLl7jbMMwNTOvTZbmAx4t9j5NeeESacREIDCE8eH/hwpSy/QbM/MMcN1jlkNtVbbs//q5NQX/9dOgyix4CPBvPzLKvo+5I9bgremWNl03WKurihe+1DHOs+hET2mfjetuAE7aPYAt
 zYx+aAz1
 wdCG7d4wa+Rj2redF0pOK4wCU0prlBrY39XbaFOfhgIMhYJUV7+3VGm9H58DlnYJD5tQ/ZLRR8JzthgPu5zC+HB0AuwqrPmMbqdDmWx/HARnekP+ovX6gDQxDGR8URO0Lracgpmb51ddSo9om7pltfq4W+E+HcFCaZPtKCLbqVsr+ol0lGQjWVDOKvczHx+mWT9pXdR0dcJIep3G7etoz5iFxp93Vli779k4Pb8KUYVxKTtRWCQmYYH3Ojzt8mQZJh8ZfE/DT+6aSjq0FkpRMiqRvwwGrXNDb4UEoPqfmgcnR+nBjT+50eysBHgZSMNM53QjoZ6QvFuCmM1HXudLSROLgi+poiB1pT/bSSA6KneSTjcenQ1Lln2v8Mkh1je9bL0CySLLOfqEQEOAxSeKb7lCxtVJAw1zMc8GoiAoCQHOsDv4UMAVGSjKCnpbJzZYa+p4pVv52zEpyZ99hVn46YuhoJqkVKYqC1CBG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

After some folio conversions done last cycle (namely ceph, f2fs, btrfs,
fuse, and page_io.c), there are a number of newly-unused page APIs.
Let's remove them and update comments as necessary.

Patches 1 and 8 are taken from the ceph writeback folio series [1],
along with tags.

[1] https://lore.kernel.org/r/20260810-remove-wait-on-page-writeback-v3-0-dd7531704f26@columbia.edu/

---
Tal Zussman (8):
      mm: remove wait_on_page_writeback()
      mm: remove end_page_writeback()
      mm: remove clear_page_dirty_for_io()
      mm: remove attach_page_private() and detach_page_private()
      mm: remove find_get_page_flags()
      mm: remove find_lock_page()
      mm: remove read_cache_page_gfp()
      mm: remove thp_size() and thp_order()

 include/linux/mm.h        | 21 ---------------------
 include/linux/pagemap.h   | 40 ----------------------------------------
 include/linux/writeback.h |  2 +-
 mm/filemap.c              | 23 -----------------------
 mm/folio-compat.c         | 18 ------------------
 mm/gup.c                  |  6 +++---
 mm/migrate.c              |  2 +-
 mm/page-writeback.c       |  2 +-
 mm/shmem.c                |  4 ++--
 9 files changed, 8 insertions(+), 110 deletions(-)
---
base-commit: 0e02eb17f263e4a3ae6bf1fe45122c23361f0cf7
change-id: 20261030-page-wrappers-33c7876a10a0

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


