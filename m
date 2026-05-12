Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38493CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0E86B0088; Tue, 12 May 2026 05:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8196B0093; Tue, 12 May 2026 05:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CE096B0096; Tue, 12 May 2026 05:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8F76B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:11:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4805DA0419
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:11:47 +0000 (UTC)
X-FDA: 84758200254.06.6D78694
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id D8D1A40002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:11:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PRB+G7+a;
	spf=pass (imf27.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778577105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ewLHYzVyPIcnfA0lWvcYFQpDp7JkXVt+pOOD3Figg4E=;
	b=0R86zfISZG7rcc5rgh1cxU5h9wFDPevAXqsfsG9Nh5SmafRD7NA1UWGn21w1KnoXMSizEL
	YXCUrVMvuA9FuM8fRTmHqL7xV0pvrLgjb5XIQEqg3+ZZxJkmckER5kfzAnC1YXRdhW71uX
	z0s0RAxxmF0DgxOZGgUeVSQQwYbWgxY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PRB+G7+a;
	spf=pass (imf27.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778577105; a=rsa-sha256;
	cv=none;
	b=57sX1D1PqOBqTi2y2fk8ygQZFSMKy8PuqZIeWQr8lAmUXE3rwVDQjtokjC2JN6mm1sunCx
	3WB+fxhST1RIl3MN9cjb95eS/p46dHTN17excD3OBMrpjLAKhA+2hVwHs2soSP4klahuOV
	WEPlk8df32+a5rAKj5pQkAHcnV4EbNU=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64BK7FWo3775794;
	Tue, 12 May 2026 09:11:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ewLHYzVyPIcnfA0lWvcYFQpDp7JkXV
	t+pOOD3Figg4E=; b=PRB+G7+arGYomjB3z3x33qbhpQNSiKXpaIlzhEdy+CL8hX
	uPGJyzns1MSvMNOF0kpe3uKexcsu7ag6GSr6JW9jYoG8EB1DvDIAzjpkThbNPy+1
	8oX5/4eF0ZghhSJOEmOmgKLx8NHEJpWUUXF5sZ/ADscKE/Dpi2zv2aM+Io41BHaE
	SJM/TUsa/UI8sgv/Wj2ZPujkgC2s5nFBfzacRxKhl56SLu1OwBd//Ly/EedVknXw
	kkLUtBSQOTYgVaWzo8RX8Sox0UFpClpdX/a+2pLzXqP1EutEQe/JjXLV3bmobBDB
	ec6Sff9h4NJC+NtyFlXoPPiiq0mH/s0rjJEnVZgQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e3nv6j5rh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 09:11:07 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64C99PJC008832;
	Tue, 12 May 2026 09:11:06 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e3nfgtfd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 09:11:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64C9B29h60752286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 May 2026 09:11:02 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C71732004D;
	Tue, 12 May 2026 09:11:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 61A1120040;
	Tue, 12 May 2026 09:11:01 +0000 (GMT)
Received: from li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com (unknown [9.87.138.92])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 12 May 2026 09:11:01 +0000 (GMT)
Date: Tue, 12 May 2026 11:10:59 +0200
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        driver-core@lists.linux.dev, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R . Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Danilo Krummrich <dakr@kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org,
        linux-cxl@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <chleroy@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Kees Cook <kees@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Donet Tom <donettom@linux.ibm.com>, muchun.song@linux.dev
Subject: Re: [PATCH v2] drivers/base/memory: make memory block get/put
 explicit
Message-ID: <agLuo_m5zQqbxTbD@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
References: <20260512072635.3969576-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512072635.3969576-1-songmuchun@bytedance.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=KbvidwYD c=1 sm=1 tr=0 ts=6a02eeac cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=968KyxNXAAAA:8 a=iox4zFpeAAAA:8 a=VnNF1IyMAAAA:8 a=YAm8QR2gnoILv_Wa2p8A:9
 a=CjuIK1q_8ugA:10 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDA5MiBTYWx0ZWRfX1uUy5DU8yQym
 J4XkJjIEkPTbZdE9YFwMIa2Kt4hhshMO4XebX9z9M6CeML9oIWNXXDqNMmzk0Xautn6MgAKwJfS
 nEj6ZJ/qaViKvn6wlOUVt4hY0oxz73evURw16Dlpvr7vfWPSrnsNgiiwI+sgY7UZe96RJesya5W
 avsU5cTH7loipW1URaKMpdLGbmoLbF9WSnwZOE29jf5535XRFtOPbBBlQosxmcTDFBEtbrB7WNg
 B3kINotmKXT+IkL3Lgsl6upXkAOTtKXzBwobeJm0PoIS6bH9u3e7G+BCXhdLrZ+8ouQ1+8ULlU4
 5syABJUTpbEGkCn+ToG5qh+3KXWfkhhKuXyLq6BwcD2Aihp6JvC5Qo7nAPFv1kZA/DfaPbAMr2w
 f0LWQJzAOFCdbfuwXuU1rwbRhGVlXJ/zuP/qVvCXh1P05wXyua6W9bCstNhjl8kXGlgb4fEFxv0
 GKAJimPwyx/3VIP5HaQ==
X-Proofpoint-GUID: BwsJ5X2pLXcwXHTrX6Rw9tGfynxABbWb
X-Proofpoint-ORIG-GUID: q7xDGR8Cmfhkkj9U_wVZEmghYWVpiYxZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 suspectscore=0 clxscore=1011
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605050000
 definitions=main-2605120092
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8D1A40002
X-Stat-Signature: fdoek1aka5ystakxjigh5ys7gr3ga3oj
X-HE-Tag: 1778577104-767812
X-HE-Meta: U2FsdGVkX18QeMs96fXLfw7NVyv4QmZ8kagLL3F3sobY8fTHp5H2+B1BwALKTfgp6/0J8KTIHZYIgHe20/rcDeqg7z5r63yp1uTSQ4iWaYDaBbD7UUSO5hk4c5GYJISGIv2CiLFR3xJ4ADGwzAGkUjO+qPwUCpEmzLhgAn6HiK8xY4pBFMyJznWDY2jnuir25MdkbrncB/YyJ3cCUfcgo8ARhP68MqaGMB0qo/mLaQBt3USXQslyxyYb5qjlq7g8S8UlSAP1balIgdTbMaKNhIi11g0gCGnpfB9i2tqkDKHsZ/2/6xCHI1tJ01DQcYiMjeQ3ThMIXs2SEqAh8aRHvb9eR+65x2OsoiU9yOuXAPPWGefKhhdGR58XsBgVb7EZ5siYFXygmXW1kONs2X+BJ5mOlHVpueMnAGRQB5fexK9AphoRkqr//W/jZ6BqjwVGwlHLUFMDVfd7toC32JR5WVcARA6gCtMzzC4th0bl3pPyAAGZ+a0gnRzgBrsGjyzjzVme8pMa6L7tNZ1HdCzLlzpIrxMeLhIm8G/relFBCkzgKgpTRPFIk+hXu89DGpEp69dDvJEHAX9ZJALq/i979HfeTzojW/iwjXWtANwWaIhI5a/HFlK/BqUZ2kcAmPTrn/+h+0SOc7XhnExnq732hJKP/rAI3wclt7R4Lqn5tplvt1KzXqlQoQ9UNoAKP63S6KVuX2JbUikMuTTNfAX82q2iI0dkt26FILlLeu5DHnDD8BeAGRxaDmZ0AOGh0T4QSaF1gfJMnEH5MnjWDuOOOqSnAapr81lL9hujdN70tgUFHyn0OJnY+bUyA16Cx21WvRWX2jU+MNxunnl72+/O3k2cB3mhNwzGzdACcOg0j2jK3qu5ERBQzZmrmVAQPIe6NMZyYffUjXkgVVMAFb5knrIwbilLL+YGpq4VEFF6m2Kba0RmlCt0xclva692W+XC6EqHZerDngDuQqcwYRy
 LhSEZ1OX
 0HHNbRfjHF4fydOmIX2eEBI01kuz1nxDOhRfmgj9PY2PXArWo85OlsIgLCaM8vy3LdSU5Rz1zOjkQT/aDCmr04dsrz3gkBxM3tQ0Cns2BS7XEWOfnKL8wTNZvMq5C8IRZfk+HuHH1vvh9IjBruq4ok9nZkz6gzecmem4pT/DxYKmjS5gHnqVoAU4pt0yN46iYC8HHCbFWM2WsHP//wKtdiQJqJZv7AUdFC4DAfeGlaa6+jxd5T2OhP8M5WxPXW5GqKw1YN5WM1hM9Mw/dvwcF6F0gagZLDZ43EPHS/gWPYx34LlYEFmpt3Y9vK9by3iL5qwHY6pwckYNnbN6UrToa3S20qgD0vP/WlHac
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 03:26:35PM +0800, Muchun Song wrote:
> Rename the memory block lookup helper to make the acquired reference
> explicit, add memory_block_put() to wrap put_device(), remove
> find_memory_block(), and use memory_block_get() as the single block-id
> based lookup interface.
> 
> This makes it clearer to callers that a successful lookup holds a
> reference that must be dropped, reducing the chance of forgetting the
> matching put and leaking the memory block device reference.
> 
> Link: https://lore.kernel.org/linux-mm/7887915D-E598-42B3-9AFE-BFFBACE8DE2D@linux.dev/#t
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Tested-by: Donet Tom <donettom@linux.ibm.com>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Tested-by: Sumanth Korikkar <sumanthk@linux.ibm.com> #s390

