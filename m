Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F01DDC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 11:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C247B6B007B; Mon, 10 Aug 2026 07:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD4CD6B008A; Mon, 10 Aug 2026 07:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC30D6B008C; Mon, 10 Aug 2026 07:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 725A46B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:19:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F17CEA082D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:19:33 +0000 (UTC)
X-FDA: 85085114226.10.E52A1F6
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 100E414000C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:19:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=NGuzIy+X;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786360771;
	b=gIcNIxzBk5IQcIy9GyiqQg6DAaYyr7uuxEnJJuOADGCNPaRCMFJU6LfwXcKtPFqAVVls0k
	EeOpWPUMb7uOBsDrcH7EKTXvQk/GtgCVW0U864F6HnoAzsw2/Bec7MHP/+aPIVX9R2MOhV
	JPVN3eQcaaq0HeD9i2iO3B+VjKimo44=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=NGuzIy+X;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786360771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjTQG/kj+zvMnDWnzeIhtQ5wAYbdDSZ2K9/KavcTJP8=;
	b=mN3tXeq9YeKeuWbOaJ0bcsPfiYx+T4tnRcWSZhQiNhoNUyVpeqYNomNi3b7tq+ERyCFm+U
	tZlV5W5DMRZFT34lJPl3+QeTLMoxYOLEJOy4cJqx+/LKSJ4rtTlCfaVd3NZIGFTlag8rOB
	DkA99Bg2j7R69dzhAkju0nuGLVck4pQ=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AAYFqC2623379
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:19:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=wjTQ
	G/kj+zvMnDWnzeIhtQ5wAYbdDSZ2K9/KavcTJP8=; b=NGuzIy+Xfvni6HvhWsPm
	u/CD93BSjqeYLmOnchy/SUoT1kUkGi7gZnadvjZ1Nknr2lEaLB4tbO9Xtrp4IBPl
	vH2+C0PXLo7mF9QU/MNbZjV1uF4Tn1MVHJiL8IduSBSjugv/Dth+3fBxVcUNEfmZ
	3SMzDGGW4SV3ZKwGCaPa+Fx9AiU0oe7CQeE5Vf8/VR8+OWgIxFwjqoN8JUJK8hAr
	ZIFSIuPjZ8mFdFN3zKYMfGOC+hyBINTEN+rIpf7silRr7l0sjcUBkTTnNN8HPpVa
	4S/f83i7/peCzdNd9Tvmt2ISBVOU6P7+6RkMFS5Mt8sgfPhfIvxx32P5evV5V4oc
	Zg==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fy2a49ryh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:19:29 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52d28f8737eso34642641cf.2
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:19:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786360769; x=1786965569;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wjTQG/kj+zvMnDWnzeIhtQ5wAYbdDSZ2K9/KavcTJP8=;
        b=buuQHLqFtYRge1lyyaF9sMpLzKXEdLDc0DB59NwJCKUbmRq7PM0NFp2xN8qOq4of9b
         LMVBjpHLanruh4ez2OaLW7v6kLtFtVIdzcU+F9vpe76BRuJmvoELGq7OYURSr/ZBImx4
         4lPiDQOJYa157OAkm4OEDsW5VOnT0KfrstIRlrGRh7bHIrS0Rvdi+vCgeDqyLamqEANj
         5c+KuehSNv3AqtLJtTWuoChYo9BxhGpF8beX8YxltN4OYrTJlwjbi4OdLMFhC8GB56u1
         zYDHu8VetE6fuP7g1SnM+vqnRbZFkpjKOawLlgTC/SL6ca4iqYnsq4qEzCNc5ig41xRW
         /FlQ==
X-Forwarded-Encrypted: i=1; AHgh+RqRIqAqurX6QMqCbHQoUN9c3xWfNZhEvRXQIMR5zwA1Goo5vX8VZQbHOvrOkbIknhYMqG0f6Cdyug==@kvack.org
X-Gm-Message-State: AOJu0Yz4NxOneFnbiFj9ZLSs4gZ9/dZ2qkgnmTUooBw9TMByWhLjcCqQ
	3VaBLMSiw5BkHtTydjh4oTyJ7R+dp+zj8ZifoUeVHJogYW2DjKJbDjV35XFX4SthElh6L1ogW81
	BaiC8g/kG7FG2TiaL9ZCbxKmUJZ8i+/Fp8bEEF5/kdbiDfUDA
X-Gm-Gg: AR+sD13xnSDGt0pDtH0HOkKgaFtw76WZzSNPq0bexX72dTbMyLsApgmHsQWREryVLvI
	AISgMs5otUbA7iQFO4ghSihFxnaK9HnA/py2H8jMQicXhv9K9yOhq5fGGBdxoqv/LKFJGrkKSBj
	7eUNNB5gI5zmq6jTHAy+Mno9DFn/K0kQcsWzeynrnCxivQjrOBuwe537Hdz1RTtpURJj64x1eYk
	soFyeT8XySuan+UO80zeTgB7RqJScLoYG+jmIys23yESJFbZlSJodL8ULlTU1B6C34OBJNfJmpE
	spryAjNedMWjwNUI0NCi7i6N+grYsUutaRtfPkRwZffhMiR61Akx/my2hgHv8HGBfbY6PWz+fux
	hAf+b8/fr793wCrhokR2Yo6ZJN+pUC8O7H/oD/JiTmslAAuF/Do2RRoEGAG1krvEN
X-Received: by 2002:a05:622a:2b0b:b0:50b:48e3:47a7 with SMTP id d75a77b69052e-52d2096d7e6mr242717261cf.18.1786360769278;
        Mon, 10 Aug 2026 04:19:29 -0700 (PDT)
X-Received: by 2002:a05:622a:2b0b:b0:50b:48e3:47a7 with SMTP id d75a77b69052e-52d2096d7e6mr242716581cf.18.1786360768831;
        Mon, 10 Aug 2026 04:19:28 -0700 (PDT)
Received: from ?IPV6:2a00:a040:199:782e:7d00:b463:d29c:a508? ([2a00:a040:199:782e:7d00:b463:d29c:a508])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145a2bsm34117401f8f.4.2026.08.10.04.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 04:19:27 -0700 (PDT)
Message-ID: <eb86ccda-f4ff-41d8-8231-350469d0dccf@columbia.edu>
Date: Mon, 10 Aug 2026 14:19:24 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] mm/swap: rename __swap_writepage() to
 __swap_writeout()
To: Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Christoph Hellwig <hch@lst.de>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-6-0899bac3b826@columbia.edu>
 <anYPVB3dwJCVoXVv@cmpxchg.org> <anYsXImJ86OY-IZI@casper.infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <anYsXImJ86OY-IZI@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 6DdkZ7Gx1rNeM0BFSonL8LKXXQmyNiMB
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDA5OSBTYWx0ZWRfX0BMk+ag3NEoV
 0ig8mp6Q8QjVnSMxEyGYHxA/ueLZDgca/TaiAhvZBsxQ802OzARoXs6IuzBBZ2y80Haj7Xu2lXE
 qSTtr+41L0Bnyl7T1pObDSCoCsDB0QsH3jElw0j60V6yDwc6UDpw
X-Proofpoint-ORIG-GUID: 6DdkZ7Gx1rNeM0BFSonL8LKXXQmyNiMB
X-Authority-Analysis: v=2.4 cv=FfkHAp+6 c=1 sm=1 tr=0 ts=6a79b3c1 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22 a=zFIWcCKHJakqfXWWRy0A:9
 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDA5OSBTYWx0ZWRfX6nbT2RociFQW
 t6kBuXokRyZs3E3+25vSvgvuMHyD/55w1rU2r6ZCsD/4QCH5Z6JZ5QwzTn4yuWXUZkrROWtlWao
 iY6ar1NAllOR3XIQT46xEqV9JSQ9AHgMMB1B9PoAZ/LvJoEJf/kbdvLMXWPIN0FbZzYv03W1NxL
 t1aqRyy6a1xYhPr9qIYjvCtGQz3XaO/Vf4bBhgSC3kjCHwmEphWaYed1mGO4SwyIu/DgD3GjflQ
 8v98KHQN/cZIUqQI3wqhj7bUkhgu+1t+NBpedpFVS+/jFIYbrR39rbdbPCWytkTIL+CoPvPxGKq
 kC/WJp+GmSa7F/jNFNHfHEliD5UN9r0AlJJnq8qBwo2yhCr4O795OmsUrFEjoT0JHE8OhT+Oqy1
 FfHpFeHiigYRsw/KHkXDvla2XuYryRCruFmwcfbEtWnp1aB1cXDqVHMtwhIR5ao47tWGBua6p5q
 NiqOg2pleMalh2h8YKw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11870
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=10 adultscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 bulkscore=10 impostorscore=10 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100099
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 100E414000C
X-Stat-Signature: yt6o46as6gz1n5qucu3h75u97xj41br1
X-Rspam-User: 
X-HE-Tag: 1786360770-980667
X-HE-Meta: U2FsdGVkX198IWINH6ULBMcR/KWJWBhruU95VjGxkmXzaOHJSSw/tkwuxO6wPhxahaWkPOee/B80YqSpOouUG8deKHEBNELxs/0opensh0S7POYeYU8JmN8IOVE79HMqDlPXziZCscxXIhCLfKP2oYm1upwrhC7tG58NPVCIUK/1YCo1BpiQPGTqubcvcHxJLTWWRAVCRhWEfF/maRLxYJ5BoRtSkcmLI5sDmIIAhK+iblS1aKKgwMXurA4J0S37qvpQwwNDWFAPgSdVCwkdQzt1JuTULm8spgHs/okdcaMy6yKWR9qlO1STyBkQV7IqchQWFSFBGNymdUCXVyqVKwxDS3pm415hf+bUHfvS05fuCaZitrHj50631r0n1lOeQH7dEcr35kJ96RM+qrt4FFzuxZo6GJ/TEWPIKlmBYdoTcWugZjkB0wpUaeBdVOP79+wghKvUTAZvHgjVmku5nRFgJzHXnYB3PgsJzBe/b48h5pxBI/A3WrodAECclmvQ21ZXfzlPTWQyvD/Ocn8Wott3oCmPmNDw8vhSQ8NW0oZ+CLbX1IwzXk6qk+G4qd2KZ0iSRI+vhKkO4cIcrOeMPCvq9kc/IibH9CqgVODdD6B7Z8CKbBThY+8wB9ZRh7LbRGvrhc6SxS8kLY5v/MGBeOzRRjzoQv49l9XsD0k/PxCW0RiSVxAMqGRz4YVXoKjcKj6gYgguCk+FmisYJiIOuPTHJsPorx9Ostp/J0LpRR6Z4c6ayAfCUmAuVIiRzdVH2ahep6Ns9pN/wzWMHnEkye4EQmJi4Foip73WVhGQ0teXbV45Im8zn8f4W/kxVGClvFR8nWrc0eJ3wUMiBrd9Yrsf7ChOP3qxukWtspsJT+b2tj7E3K/U3JNTUWsDhlKqpP+iWMkQloovz0DPXXier8D2O0Ih/DhndJ9IRxW6xiZZpZqz68iuU/31xY5lOuUnbsl7F+FOBVFgk/9hsnJ
 rLwnCObE
 0oLwCImKdaGswSSwfj8mcuz6XxCH7oQ1vlwjGv4xoXYLMVOAt8p8CtNzpYBOYroOSzM5G9vuzaeOewmZVs7H4jKDbiDi3Ss/hNNAGaiyKYg8wdy6p0GwvdwHsaT59WJsdjSqtmych7rybATz1onYLecyyBnPzPDDEpm/GG4c/IXJQLDgB7URiDqCyd6/h/+nB22LHRo38KDE0qxej6YtfKYurWEFagEx44dpwGVjhSL/tQGRF83EYxS27ZZP3Gtk2LTqwb6Bz0xyVxNCst6rb0tlgdAR56ZYSMor8/+5MbU4o5UJRUkccOfggRJ1T2p3CpXQp0ddYJ6i31FkKqU3PUSGwiKLv++ug66VwKz+epbmTAZzKCbbMd7krh9nl/rYG53EUSnBd2SOnrj1nSx/zDy6D/lv2rHBIxUWePZ7kikPGGcg284doyxsDheyuFbiGaas54a9SZbopTYhfvL4o09YEP7cPDTzOxbdMjWMNf+DVf9o8xUiKI1wJbM/yJ1MoVsGMRRvrAsyk1kk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 3:05 PM, Matthew Wilcox wrote:
> On Fri, Aug 07, 2026 at 01:01:08PM -0400, Johannes Weiner wrote:
>> On Thu, Aug 06, 2026 at 06:55:38PM -0400, Tal Zussman wrote:
>> > Commit 84798514db50 ("mm: Remove swap_writepage() and
>> > shmem_writepage()") renamed swap_writepage() to swap_writeout().  Rename
>> > __swap_writepage(), which operates on a folio, to match its caller.
>> > Update a stale reference to swap_writepage() in swapfile.c as well.
>> > 
>> > Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> 
>> Looking at that commit, I can only guess that pageout() had an
>> influence on the swap_writeout() name.
>> 
>> However, on the read side of the page_io.c API, we're following
>> swap_read_folio* consistently.
>> 
>> [__]swap_write_folio* would seem more symmetrical?
> 
> I wanted to be sure that filesystem authors see this as something unusual
> rather than something they should implement as a counterpart to their
> read_folio operation.  So it was intentionally asymmetric.  I'm open
> to discussion of better names, but my hope is that we get closer to the
> 'do direct IO' model and shmem doesn't need to swizzle its folios into
> the swapcache to get them into the swap system.
> 

This message only came in on my end after I responded to Johannes. I'll
leave it as [__]swap_writeout() for now.

>> [ At the risk of starting something, should the file itself be
>>   renamed? swap_rw.c or swap_io.c or something. ]
> 
> I'm not opposed to that either!
> 


