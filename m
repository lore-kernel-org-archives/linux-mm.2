Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4397C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 22:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 925636B009D; Thu,  6 Aug 2026 18:57:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD566B009E; Thu,  6 Aug 2026 18:57:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79E356B009F; Thu,  6 Aug 2026 18:57:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CEF16B009D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:57:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 662A41A04A8
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:57:54 +0000 (UTC)
X-FDA: 85072358868.16.D740B2E
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id EE1541A0003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:57:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="mqnrJCP/";
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786057072;
	b=xbh30Y4SMgjIxeImQ6Vci6Yeo3ocDZFCz2mZrx57p9DQnu0cEd7tQdtChihq2fP40LcT0k
	EBmWcyI8Zh4SIxe5VmNM+LgWj+XN5rFb+YyFASo/SKQBukTxkQYrwFsh47grLeBPGxm3Jo
	MveVhcmNhMuIMR9T4ESDyMyp1TgGfkU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="mqnrJCP/";
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786057072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfgBfz4SBjZG0Zjt1W7ARXOWQHcIrXbdvdbSZq+3q04=;
	b=AXBpvsvoiVqdbPjjSsXK7AnfeECptZJJM/hU91BZdiSWPKvlxM5eRxCI07WIXA/00RRdzL
	ACdkpin30OOYXDEDulV2+aqmzfdCllx6fLHNTBL8TODZDkni6zXWmGnbFxLQcmXi+PUlVh
	5sqOzyNilHRW3qJJ6xfY5hHSbIXOiWo=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676MbTD1476202
	for <linux-mm@kvack.org>; Thu, 6 Aug 2026 18:57:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=GfgB
	fz4SBjZG0Zjt1W7ARXOWQHcIrXbdvdbSZq+3q04=; b=mqnrJCP/PMhCuI+TyvWD
	RUMs1REYDCKt9Upy5SL4LGzL30+OtAUGI26+u+yE5ebVyetCWiHHhgqelk5wNMYc
	ALstKQp5hyDQFXxQXXHHlryvmEBh2MAB/1jyUV/6l5yZyeTCo+k0EXI5+cktE71/
	C8AFm2CADj+aivT+8h+yZ3yOwa8BwZIwVd0Cgar6Bu1iQmdghjnaOPOdQX3Ij1U6
	E7gCah6Cd2c4Qf/ynfx5wdgmfBoBwczQGQmAceSRnqTTwx0/vJiE908hCAJRqq1v
	DsZyOsBn2qXewDFNiv9L/aaqXV69BQ0vX0GCh/aNymtiZtmJhJF++AanAm6ajQ56
	GQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fw1748xd0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 06 Aug 2026 18:57:50 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c19493ac2so30538661cf.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 15:57:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786057069; x=1786661869;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GfgBfz4SBjZG0Zjt1W7ARXOWQHcIrXbdvdbSZq+3q04=;
        b=LLOWNUFOFO9rS3PJDIzO+mkHRW4D3UWVPZ1OpQcGtKXUq8H1qR0Xz9ZKQ/GjMQNkmx
         3Tr3zvII1anZge0SQsEJtHnn3p3mkv2Je9Bx7HTMTtWNN+g4T2HvucxtVEoldrByNAfO
         6zCa65tR1XGXUKiCvnJV93yeU9RublhkzbbfJzeaqL/5bgM+IsB/CEZgHUlFesLzVcOK
         aYWOAlzosbDH9QF3pw0335EfK5T+x1VsHImNVfG5b3LMNMgwrceGIkJJdvilmU85KjKn
         IZdSzq8JtBp7xbezklv1J0383pzWzqMQihjrJuxBNZnR+2nyi1kEgLRt+XnTV6bDj8cM
         JzyA==
X-Gm-Message-State: AOJu0YydTo0lcWvnn4F5rbezz2ide4N7e++xRCiOSYZcYNdXwhYa705s
	qhVZR08WX7xAQrU8rhefNhitKLm2zAkT3NfsuDtInXw+7RlkVFaIreAVmXwpdVn1A/UR4fEC86k
	QkJFMd6KbAuxWd4BNvbFV+CB+dAEF8XzFjBKD+yPWHBR4V5pw
X-Gm-Gg: AR+sD11AYAjMNp8hGBT80fcmQriOMpQG7F/pRFq5MJqUgrAkE3/Co2/Ldir/78VWvV5
	XbH76pUGSiLiFVg/oubA/DRKjytPxic870TVIsljxLOwM3aYecEQm7J+jcYPG7Y4ZlQLYk0Yw1h
	n1CAUqoMcAV0tBDolbjbrLMPnWz6uQLLWCux8rLgYMFeFzquPpE2c1Md647SrEDvA+5Xix6/S5k
	KTaw3lgqqU34QBCQxerpjjjRoA3vayQqwQUWXumvK6Vs/+ClRuZAdOF7uLwORysAVPnnQiVdpGV
	BZqbyJBbagGGHBZNnT4uwtvt1ZjgnaVKDB9Gu/F3YF6XnSYi6EZiFQ8SYGz356i3+Psz+VrKX+a
	/YGdam5bKRcYG
X-Received: by 2002:ac8:5fc1:0:b0:517:8711:d46c with SMTP id d75a77b69052e-52ce61b5e59mr187985881cf.31.1786057069499;
        Thu, 06 Aug 2026 15:57:49 -0700 (PDT)
X-Received: by 2002:ac8:5fc1:0:b0:517:8711:d46c with SMTP id d75a77b69052e-52ce61b5e59mr187985471cf.31.1786057068971;
        Thu, 06 Aug 2026 15:57:48 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.78.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff7b31975sm8751344f8f.33.2026.08.06.15.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 15:57:48 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 06 Aug 2026 18:55:37 -0400
Subject: [PATCH 5/6] mm/page_io: refer to folios in swap_writeout()
 comments
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-page_io-folios-v1-5-0899bac3b826@columbia.edu>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
In-Reply-To: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786057045; l=1088;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=UmV9sMHSKSNHxDzc3QqoRx/hDTjI9DTuBW2BUeenTn8=;
 b=gpZYsMmoeYR9uHKPTPWoQ8pj5KB+DanJriXzKT999YnRyMFOq7BXjTKfM5c61ITiwsRWojVnV
 ddRIotN/naJC6JF5Rp9bD1C0xzz5nXlMgaTdu2sPpHcd7NxD2FC7qEL
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE4MCBTYWx0ZWRfX9p3qUoXol/KJ
 CORzanqWYbLWWAdapKic/8/aQphPbcenPFctN/UiIO5V2NTeW0RMArafIYbnePyahUIzKj1e3Ry
 kMyOq2mIR6jMl4eT5nsNMienZhPpZ1AM1TdvTcVDBEbAJhjUqTPG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE4MCBTYWx0ZWRfXz54ZRKrE19ia
 q00JqRQoV7jQuylf742cOoQ25BL67obpHSSuPyePhXRZoP4uHhNvQxidEkVnqRlinYQJiEi3Mpe
 GfEgMn6zsoA5JTSi3v44AngJnGxmEzrInOd3XPlbkbT9Pngtf+oH4RmfIhm95dStE1XldWoZxm9
 orefDwD6m4wN66VmnfORGi5WhiCq2FKFtqmLxma9FlLSv1mobLWIDFiZA0RqTGrCLuYYw4S58nu
 ikB33nD9XcwIt7ArPesLh9A4YyZ9k49Qy5YaXLEBJMDh+alhUssU/cFs7sh6EdFL8Tgce6QqBH+
 kwDNxuYYOIDebvOyM/2wSaapBabUhEnt+xmGbN6xc9O6U5S7GMMkbpulrRpkwP7Mr+tnlJsoyGR
 oC3thF1fifsF+b5pOKQbhqgw8FhFt99d6JbEqUE9aL9zCCMN6FithRx/+nDy5zjZr5RfQIfswRp
 Qo7NO7XX+MskLfB6BHw==
X-Proofpoint-GUID: KCixhywsbUbY070FNDav43Kj1heZwV8A
X-Proofpoint-ORIG-GUID: KCixhywsbUbY070FNDav43Kj1heZwV8A
X-Authority-Analysis: v=2.4 cv=ffydDUQF c=1 sm=1 tr=0 ts=6a75116e cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=z9N5oyD7lR4RENIpbqURcg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=o9dMDrf0hGvVio-mgDUA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11867
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=10 impostorscore=10 bulkscore=10 spamscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060180
X-Rspamd-Queue-Id: EE1541A0003
X-Stat-Signature: zaq4zkqxz15uctwgip6u4r1tbcb9kxdi
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786057071-378879
X-HE-Meta: U2FsdGVkX1/lG8nNDz4pr44geUl0HbN3O/mf/LnOTFPSGP2vRqTfDaDHMXHdtbjTGYGtmPCKzEWJw4mqO6TwGL9UfTy60aXZCqeTAq9IB5BBUl3t8lJYPrGdZDntEPv4eKD0RPU+YA2v15bsBlVKi0M+V1gHRYUpDsWI9P8+F9i/9OUH7RfMqBbX/PYDQtwiWw04qFCIINKMyBUu/y1FWHl70qC+gK3uZg59PEYdbykwc4uDQrs6onS3WUnGoTjKwGk2g35CB8AR6oIkfxjsPfwT+p1I3hDLbK0qS4ldZeI7PnLoYPLmvFZG4EdbeiFqIWGOWnwcURAeJeshnMP0EjbSEc5/RGL+vAI5HqfE+j4Ws7pjAfoT7do8az+JOubY7ytsWMO3Jn+L6cJFt6CANbEc/w2PdPZ7QkBdnZTCTmGYsCmM83Ek4CyBLD/MMNq80jGJgf6bNaQlFVQKwblQvaG+YD1J2C1cTle8RS49fGd6kQJqusqOpyOrOz4WshcTcnC+g08OaAic2P1a0mymt7Vv5XddvGpLeK2RKrogIkRt6EmzxgU1S7ZFHTqGKwyfMMak8dW58j2V3tGdK2qzIEFZ8dMLTBT+E/OOc1+kYt4N5i1jKoEJvmAcTM3lKwVEVeuJa0/kW6+MVcOVOlWjuvjbI9sawB36sDB5Jn7E0y5wRJz9Gwkeo2kY6i6CgKW+McnTvum7dCwPkRhdhvjj06NTe6z3QU0u6Bq1ZZM0gyqxuP0wYUnEkrn0AlzLfnDX5yDExLvMJSRoGBHsqwexsA4NitxzY+kfQY/5y52eq+XWC9IbvTp5wtcM6ZlrYrQTsZnGxzRrlyMSeJhyFPVvW96AL9d6q9pUl6t7fJloqPneoTiz4X7xXval7sYwvJT7vnWr0u0aSOkXURGks1oULncIjmDXVlF8Pk497rxykENXKyaEVqRqimwD2WsrFjsEoQ7TEpS7qqELpcb7b2E
 zNk2ANbi
 8t0kBmTNeIk7PqxOEsRgYT40Uci6x4mWhibG6zHdzUTkEA5OBhbDKXdqESBFoUcbT4FG+CoR2Q4MKQl1NZHHf2qJCE6TCYjqcqo9MtF+N43+vjAjMwhVXHU1fW7As4jaz139ZPERITlJzwJsyc32qq24HRKeBIJ/ERs+ybFP43Na2kwGqNQ5d5jroZQDRHaYVjZaAFpKVWbgwaSf3yN0xj84znfzDEngKBGmGQs1ugewFIa4XQ/dFbD6g5HoPcdLUQH9DdWAQQo9IyXsUBjGJxaMJPbqQkc+HO7I3nqcsYrDt66C9cr8BVPCOQ1XJe15mhah5RNI6tCTg6hFDk9xB5+o98Lr1vpjea+/6LcsWvBYPKZJ1ycTLfWZuOyL9VBJfFZejkLYdyERvMHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swap_writeout() operates on folios, not pages. Update its comments
accordingly.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/page_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 8573f7b8967a..b18d3b7d853c 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -208,7 +208,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 		goto out_unlock;
 
 	/*
-	 * Arch code may have to preserve more data than just the page
+	 * Arch code may have to preserve more data than just the folio
 	 * contents, e.g. memory tags.
 	 */
 	ret = arch_prepare_to_swap(folio);
@@ -219,7 +219,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 
 	/*
 	 * Use the swap table zero mark to avoid doing IO for zero-filled
-	 * pages. The zero mark is protected by the cluster lock, which is
+	 * folios. The zero mark is protected by the cluster lock, which is
 	 * acquired internally by swap_zeromap_folio_set/clear.
 	 */
 	if (is_folio_zero_filled(folio)) {

-- 
2.39.5


