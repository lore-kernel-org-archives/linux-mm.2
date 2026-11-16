Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53315606A33D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=jhx/gmZZ;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=ZJvv7bzs
Received: by kanga.kvack.org (Postfix)
	id DCF766B05BC; Mon, 16 Nov 2026 15:04:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBD5F6B05BD; Mon, 16 Nov 2026 15:04:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5DE66B05BE; Mon, 16 Nov 2026 15:04:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FFC16B05BC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:40 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ED1EE1C1F8E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:39 +0000 (UTC)
X-FDA: 85442059878.13.A6177BB
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 575021C0005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="jhx/gmZZ";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ZJvv7bzs;
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794859477;
	b=XTimH8cQHlQeMKTHKq8HIVBq0qcF7zBHvyerxkpaIc4uXv87Veszgn0rsErxsCpM9T0lMd
	iXyp5PRdPLHoFmF2Hr/fIAkPJeotDhKJSk3IrC3Kt9IzWxaCg1z5JUyQzA+ll1DBS1jAIX
	LC9wgzdVcA9zLsTbgAwKBi9l+25JSAw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="jhx/gmZZ";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ZJvv7bzs;
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0fzsGxlT4q3HpaE4QZIOM3hFczkgekbU9Rdi2JFm50=;
	b=ExnCbGpWWIBXO5iHAym+yvKiraUUS/McoxF8L/n2aj85t3/cFMb9Kv2OVWJuBdRCYqU+hX
	U+tl/2R7jAbTqL0Ongi4q8GmTJKP7HjkAFrhzeVhkvF/Xc+2z5kvLKN8PmxIIKuQr67O/v
	WhYUArv+UOnUiPyK+Qj3ufAlkIZ0ICQ=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGJXV2g1467631
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=T0fz
	sGxlT4q3HpaE4QZIOM3hFczkgekbU9Rdi2JFm50=; b=jhx/gmZZMis2eLHme4pP
	oqNJ4vm94e7n5ru5EAk2U+UL8DsyQzJvWf+ChC8XN6mrCqqY67boqdXPXprBS7Qk
	trstAW/Z252gtEEvOL07aPupShrfGXAiOkseYxYbuuRsEcJV4NimkqrjEgjwGBAZ
	J5glBWtHlaCxVx0nUsxEpWExuqt1xX338Yhh1oydK7F0ujH2NprZdJd2Pr4Ouldp
	ZmYh8Z9jm+TsCrUVOMKcC87xdyCKAw22lwOdh036fxohi54CCT7j/HIxEBqPV1iY
	lQB8j+Le5P3ZyRX8+FaGDHPN9Xulwe2hJRa5sOEljXPywLzBOcwNfZ/Vkts5QESB
	4Q==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j059hj04h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:35 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-55d2f5f1e1dso31573351cf.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794859474; x=1795464274; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T0fzsGxlT4q3HpaE4QZIOM3hFczkgekbU9Rdi2JFm50=;
        b=ZJvv7bzsSyangNL9WkH43VG8zYVNTX+JcJJypPlkw7kanYxYY/IpMc4YPN3RRcsCTs
         bfVS2ygOnqVW2ohMn3wzKo3LuxBT5nG+QFlBTR+x3njuWKhKR/lJJ/wmixU3XRmSGKBE
         5RqEHIYSSHDSal5sMZHpFLfDzbgfThev3SJu/xSAjc1KNswaKR+iG6F7MXg9W9JB46Vz
         035IOYwmhH7qU661uPhsrcAqaFxHnzIzhWb8QWgOycUK4t4Z+4t2pK4PYzzlvbqv3x91
         QUxUB9CRlif2cxgWXf4zncYTpVEoyK5Xqcx1yAEwAWc01g+JIdg+7imsOnA9G5MS/90a
         La9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859474; x=1795464274;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T0fzsGxlT4q3HpaE4QZIOM3hFczkgekbU9Rdi2JFm50=;
        b=mMFvRGTx/DBFDtQrjcpxxJaG8BUj+7ytIt48mKLywD6tpNIWHG1QuU4dgBzrcdZe1E
         HD9poONdFpPwkcCGEgJby7gD7N7WhWXG6f+3BVnT97yexjC1WIThqTZJswbLR3+6lTaf
         A3xHRdLP9gxjI58sZcLuSt5o9CGRlmykf3k1Lp7Z/XJEZuHOX3cDmK9SbdFj37fI1UZL
         ttPOl+n3ZJ2+rDjqXbgH7goeTWtzNW6mJhUxAIdmF+rapK7yhucceB6ctx6lx2r5AIqf
         jSGkc5NO61TxWa/son4BxE3uDRvIWZ1uPddhtWHM03y31meyFxY3/CJHcdw1XSy8iCCI
         SpTg==
X-Gm-Message-State: APuU4Z8ygJDnhV7uQYtgubgHNjtMDXSUM9vGmHJh6/3E/z1iukPkSuO4
	dL2QUn/s1fS9WaN67CAXQ9JP/v+Ur1sTebEB32Sc6704x3yTTr9CZPvEZ9ETFUvJ6wDbu1KyBlf
	61C4gbxtNEjUwjY4s8xZWSLJyfCdselDJNJU6e3xsp9TcCaor
X-Gm-Gg: AYBFou1RlSNXxWDGxvEl5wIDG64FbUjhfCO2AuQSJymZk3MzH7rvEj3LzfaDnWBObn9
	mxIdDNF4YN8n9VcXuYugCJ1nYR0idZIjG8rqNRdvlxLvzied5tW1hpwGm9ZVfAMapFkXtH/8DCP
	/MOLwHsQwG8jJc9dZEJZuXZbHLKUfNNC2q5mzX+dTawslBDrBTdipog0cRCL0wpwN1DMaDBckEQ
	zZIw9vEni7haMx6w5iW5HzN1pzn59v74QKkz5zdDRPs5Bha2ba4CDMpqIzb+8Y6dNRpCnk0i1cM
	U8hVEREANOA71M+wZLd7tJlHmTqsIiQsmybze03PlZAcuBlcmQUsd4Rajt66e7Ir4rGIJ9mbGAa
	nTFcm/1u8O5/dEFP2pY3InBinYuJ0gJ12CWeF3snVhXTh9HdaXmLroRPI7U9hUphN78cf+NuKPO
	HGa8xCJSSX7S3VlMdoxfrF
X-Received: by 2002:a05:622a:4d46:b0:533:3fc2:8b19 with SMTP id d75a77b69052e-55ac7266e55mr188486471cf.20.1794859474276;
        Mon, 16 Nov 2026 12:04:34 -0800 (PST)
X-Received: by 2002:a05:622a:4d46:b0:533:3fc2:8b19 with SMTP id d75a77b69052e-55ac7266e55mr188485541cf.20.1794859473592;
        Mon, 16 Nov 2026 12:04:33 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23efa2edsm93065426d6.15.2026.11.16.12.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 12:04:33 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 16 Nov 2026 15:02:49 -0500
Subject: [PATCH v2 7/9] mm/mremap: resolve uffd state when the context is
 dropped, not during the move
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-uffd-state-fixes-v2-7-4397a0196479@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794859460; l=8555;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Pw3aT4XYGUKtZXK9Y9SabvgsNMzWI/bDdIAFeBvZ9bc=;
 b=1KBkbR/5ZTJejegNiXTYgbIoFhfrtUnq5/BvJ66hqlnGtUxOw+hPSr50QgyONd5bfxVibjP02
 IQTIOjB0hFpBb3AzSDPIl0aMcz/F/Drsn7kdqmyBGNB3Wn3ql25BuCM
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: VoF57AovLf5DRi7ZzJultRfQcV7mYpxO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfX06WCLzq/05g9
 qUCMkO7Y4aJRelT5xfYDvFfEKgWFytXc9WL/fOiXS2/leK2BZfFmndw57YEBvM6j95lancL8MYj
 ox1TWis89lJOg8daXENAb7bhCGYJQ09mHit4XPitpseKZZFHtikN
X-Proofpoint-GUID: VoF57AovLf5DRi7ZzJultRfQcV7mYpxO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfX2Gw7WVuAVU0g
 P6HcW/fe4wZsj8gRiCHIeyZuzdXIm3n2+cZjUB/3mfQQiOwfwJGdMZvb8yd9D/n7bHyLVL2O0vN
 MhuCknZ9uenHxalF+yJp5QUBrpOm0EaUd4En0ioolCebtQ1UKLGKu3VyYhA94cT1yJ4U0MRCanW
 h1lxiKhPiZ4/A7pJaewRaNA3RCAEDMmWTeM28lSniEuu1SUMDR+7LcYzbzJ4rBW06Cs2xvCXb2o
 sJsRdW8Wn9/GMPbmAbNbmS2cPQ9GigB89HX7tfB1B2+Q2LhnUYuwVlN+nh8QTGN+gZNmVvIzP0D
 yrTk8pq+21kte59ilaW4UVF53UU6Ka8pRCW80+Dlp8MdhQ/vuJPuzVpF6HYbRwNnxmhyaKi16Rl
 cxO8HQe4KYF0A626YO3etFSR7OhTbSzEJbA9mNFKNqjM+ye24LJBOpnlipW2bkDbnH2/qhm215t
 Y42A+77ibFJNicl4fJg==
X-Authority-Analysis: v=2.4 cv=NLlAaE6g c=1 sm=1 tr=0 ts=6afb61d3 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=VwQbUJbxAAAA:8 a=tHa68p0SAAAA:8 a=FFitksWucw0zMzmll4cA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 impostorscore=10 clxscore=1015 spamscore=0
 suspectscore=0 bulkscore=10 lowpriorityscore=10 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160080
X-Stat-Signature: whoak4zh1tqs1a4u5z7zkz5cxmde4zi7
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 575021C0005
X-HE-Tag: 1794859477-383144
X-HE-Meta: U2FsdGVkX1/vpzVU2tNxQi6IM2djtMFK1Y9n76iq5a5Fpdqn8U0aVzYgNktc7LMbqUbFbn3gjy+MMzWgG4//GitpU6xn1KAehT0MYunmujkPhVlkzrQiXtf5cIcV90AZQYULuigqYCCTgBS6CHROWUIGG/buW4bJqe30KPlyg26QQuAe09ywkpc5YhvMBbs3oFpEG2PQIfak5j89zepaiLTCccHplYKQhIt9O267sJJzRw6ZJ6RgVwfJQ/60AL9MySm1ItG/AG0FhW3RoWJ8M30rvu6oX53QRB6/mQeldGL+EkksjEHTE/iDVCHv50ft1Teef41S1S368uF1z2cpIznuwxyBkicO2wTPmVM5sSEaTO+iNWx0Nbt3x9pfFYcRpPISbx2+orPCjqv3E9GGcwtYIOHJAgIhralBQkNN/8lm/TkphRVHlvG9GUxDLm7gr1sZn5evhwjggMHhNk+gszrq+FOdMGuRRMcBAVp8jxgADekCp4fC47BYUcm2q1jxRVvE6xmLOFCxjMdrWMEAYmvpr2HDkBQW47nwJLEuwUK8GEhbLhOPyd7NNNXTB6nm45TuFwNRROGz1uc/xoX7w0ayJM11ljVmctf/etWkz7NWRLcWuALfclFY3OEpHUP+AULMvOZHLp6io/4mIqPtwT2XqIe5fQqLMvkpD9MaNE3dEP25p9CUuNQv86IkpvP5oHXyDLuShvF9Cb1FxWoGx0TN1+150IGSnTSea0rlP82Q9SWkwtJTw7DO5JMsLHyEZt5F1nbyyU6wm32PLybYwx1A+0BXUhiCdcOb0bymFF0TZTzqyLq5OciCBhy7ho4cSErfHLV+UJB9M/E1rDKW7PG4VofLtBbM8aXXMSVesxc4+o6PIyLSjpGVOdoNVQ0EN2+CTvxthRt8Vo97gddnmjBwuwPZV6Zdvfaq5s26+PfjJpWN4cUiZ6SnDajWheve0i7mVYP9/1YwmfnD8/I
 T7Yq2T/l
 ZmNuBkLSQhTxqYQwERemJmM3v5nZv4G8AWEtH3QsTrIKA/+8mDKFzD5M6R1fuFiUfI8cIO8WBZgvLY7cLSfbauf4wmN/Y7bvElAkhiGgqTOkjO5iE6dFgLWOtdOLkFUpXO2oq6g0kgfMK/Pw1/ybyi+yoGbxY6AW237ydyGPcK3dgAs1LfV2C9vCuNjq0LLoTG1f0MxPusH9CNHMwl9dG3ahKsro1EVnUXkd9GxsQhOT7noqZtGl2ki6waWT3qt1x/zDpzSVgdxm3kAhikiGw7fh4t1s3WJRICC5Ht0D+FA3m1flu6/4sfu/f4M4HW8s7UwatKv3ymOFPPJO6KBlsOYqapUOLENAxpQNpD2ulJYNXN17oBHS/tG1emE4ESoDPk70n6yahVAXclSuK5QF4LnERHGisT2qY99Jhri+Z7uT0F12jBSei7IO6+q9HbAKxMfFgF4yYoF9uRS6zesFBbPTRmHAr2W0hl1nTbdJrhu/1+E6cYU3zV/daQCE1guskGmed1J7BtvBKhSOaiDg9SJdsA2fxzBITomLH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Without UFFD_FEATURE_EVENT_REMAP, the new VMA of an mremap() is not
registered with userfaultfd, so the uffd state of its entries is cleared
while they are moved. If the move fails halfway, the entries are moved
back into the old VMA, which is still registered, without their uffd
state. Writes and accesses to them are then no longer reported.

To fix it, leave the entries alone during the move and clear the uffd
state of the new VMA in mremap_userfaultfd_prep(), right before dropping
the context, like unregistering does. This walks the page tables of the
new VMA a second time.

This is done with userfaultfd_clear_ptes(), which also makes the PTEs
writable again where that is safe. That removes a spurious write fault
per protected page on private anonymous memory, but adds spurious write
faults on shmem and hugetlb, as change_protection() makes writable pages
that were never protected read-only. UFFDIO_UNREGISTER and
UFFDIO_WRITEPROTECT already behave this way. This will be fixed in
change_protection() separately.

The entries no longer need per-entry handling during the move, so drop
uffd_supports_page_table_move() and clear_uffd_wp_pmd(). Whole page
tables of these VMAs can be moved again.

Fixes: 0cef0bb836e3 ("mm: clear uffd-wp PTE/PMD state on mremap()")
Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/huge_memory.c | 25 -------------------------
 mm/hugetlb.c     | 27 +--------------------------
 mm/mremap.c      | 46 +---------------------------------------------
 mm/userfaultfd.c |  1 +
 4 files changed, 3 insertions(+), 96 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a2b1ac11e7dd..e994ca58cc70 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2638,18 +2638,6 @@ static pmd_t move_soft_dirty_pmd(pmd_t pmd)
 	return pmd;
 }
 
-static pmd_t clear_uffd_wp_pmd(pmd_t pmd)
-{
-	if (pmd_none(pmd))
-		return pmd;
-	if (pmd_present(pmd))
-		pmd = pmd_clear_uffd(pmd);
-	else
-		pmd = pmd_swp_clear_uffd(pmd);
-
-	return pmd;
-}
-
 bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		  unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd)
 {
@@ -2685,19 +2673,6 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
 		}
 		pmd = move_soft_dirty_pmd(pmd);
-		if (vma_has_uffd_without_event_remap(vma)) {
-			/*
-			 * See __copy_present_ptes(): normalise the RWP marker
-			 * so the destination starts accessible instead of
-			 * taking a numa-hinting fault on first access. Only the
-			 * marker (protnone + uffd) needs it; leave other present
-			 * PMDs in the VMA untouched.
-			 */
-			if (pmd_present(pmd) && userfaultfd_rwp(vma) &&
-			    pmd_uffd(pmd))
-				pmd = pmd_modify(pmd, vma->vm_page_prot);
-			pmd = clear_uffd_wp_pmd(pmd);
-		}
 		set_pmd_at(mm, new_addr, new_pmd, pmd);
 		if (force_flush)
 			flush_pmd_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 88c9aa700533..b491742702f3 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5195,7 +5195,6 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 			  unsigned long new_addr, pte_t *src_pte, pte_t *dst_pte,
 			  unsigned long sz)
 {
-	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *src_ptl, *dst_ptl;
@@ -5206,31 +5205,7 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 	double_pt_lock(dst_ptl, src_ptl);
 
 	pte = huge_ptep_get_and_clear(mm, old_addr, src_pte, sz);
-
-	if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte)) {
-		huge_pte_clear(mm, new_addr, dst_pte, sz);
-	} else {
-		if (need_clear_uffd_wp) {
-			if (pte_present(pte)) {
-				/*
-				 * See __copy_present_ptes(): normalise the RWP
-				 * marker so the destination starts accessible
-				 * instead of taking a numa-hinting fault on
-				 * first access. Only the marker (protnone + uffd)
-				 * needs it; leave other present PTEs untouched.
-				 */
-				if (userfaultfd_rwp(vma) && huge_pte_uffd(pte)) {
-					pte = huge_pte_modify(pte, vma->vm_page_prot);
-					pte = arch_make_huge_pte(pte, huge_page_shift(h),
-								 vma->vm_flags);
-				}
-				pte = huge_pte_clear_uffd(pte);
-			} else {
-				pte = pte_swp_clear_uffd(pte);
-			}
-		}
-		set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
-	}
+	set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
 
 	double_pt_unlock(dst_ptl, src_ptl);
 }
diff --git a/mm/mremap.c b/mm/mremap.c
index fff0465f5e06..4564416a6994 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -198,7 +198,6 @@ static int move_ptes(struct pagetable_move_control *pmc,
 		unsigned long extent, pmd_t *old_pmd, pmd_t *new_pmd)
 {
 	struct vm_area_struct *vma = pmc->old;
-	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *old_ptep, *new_ptep;
 	pte_t old_pte, pte;
@@ -290,27 +289,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
 		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
 		pte = move_pte(pte, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
-
-		if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte))
-			pte_clear(mm, new_addr, new_ptep);
-		else {
-			if (need_clear_uffd_wp) {
-				if (pte_present(pte)) {
-					/*
-					 * See __copy_present_ptes(): normalise
-					 * RWP PTEs so the destination starts
-					 * accessible instead of taking a
-					 * numa-hinting fault on first access.
-					 */
-					if (userfaultfd_rwp(vma) && pte_uffd(pte))
-						pte = pte_modify(pte, vma->vm_page_prot);
-					pte = pte_clear_uffd(pte);
-				} else {
-					pte = pte_swp_clear_uffd(pte);
-				}
-			}
-			set_ptes(mm, new_addr, new_ptep, pte, nr_ptes);
-		}
+		set_ptes(mm, new_addr, new_ptep, pte, nr_ptes);
 	}
 
 	lazy_mmu_mode_disable();
@@ -334,25 +313,6 @@ static inline bool arch_supports_page_table_move(void)
 }
 #endif
 
-static inline bool uffd_supports_page_table_move(struct pagetable_move_control *pmc)
-{
-	/*
-	 * If we are moving a VMA that has uffd-wp registered but with
-	 * remap events disabled (new VMA will not be registered with uffd), we
-	 * need to ensure that the uffd-wp state is cleared from all pgtables.
-	 * This means recursing into lower page tables in move_page_tables().
-	 *
-	 * We might get called with VMAs reversed when recovering from a
-	 * failed page table move. In that case, the
-	 * "old"-but-actually-"originally new" VMA during recovery will not have
-	 * a uffd context. Recursing into lower page tables during the original
-	 * move but not during the recovery move will cause trouble, because we
-	 * run into already-existing page tables. So check both VMAs.
-	 */
-	return !vma_has_uffd_without_event_remap(pmc->old) &&
-	       !vma_has_uffd_without_event_remap(pmc->new);
-}
-
 #ifdef CONFIG_HAVE_MOVE_PMD
 static bool move_normal_pmd(struct pagetable_move_control *pmc,
 			pmd_t *old_pmd, pmd_t *new_pmd)
@@ -365,8 +325,6 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
 
 	if (!arch_supports_page_table_move())
 		return false;
-	if (!uffd_supports_page_table_move(pmc))
-		return false;
 	/*
 	 * The destination pmd shouldn't be established, free_pgtables()
 	 * should have released it.
@@ -434,8 +392,6 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
 
 	if (!arch_supports_page_table_move())
 		return false;
-	if (!uffd_supports_page_table_move(pmc))
-		return false;
 	/*
 	 * The destination pud shouldn't be established, free_pgtables()
 	 * should have released it.
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index ad9d243dc64b..bf42fabb5afd 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -3161,6 +3161,7 @@ void mremap_userfaultfd_prep(struct vm_area_struct *vma,
 		up_write(&ctx->map_changing_lock);
 	} else {
 		/* Drop uffd context if remap feature not enabled */
+		userfaultfd_clear_ptes(vma, vma->vm_start, vma->vm_end);
 		userfaultfd_reset_ctx(vma);
 	}
 }

-- 
2.39.5


