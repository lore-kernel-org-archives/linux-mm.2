Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E706CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 22:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF806B008A; Fri, 29 May 2026 18:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E896B6B0092; Fri, 29 May 2026 18:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51356B0093; Fri, 29 May 2026 18:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C019D6B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:54:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A3241202FF
	for <linux-mm@kvack.org>; Fri, 29 May 2026 22:54:14 +0000 (UTC)
X-FDA: 84821962428.13.D4132CE
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf31.hostedemail.com (Postfix) with ESMTP id 06F6520004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 22:54:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UwuJ6v5W;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf31.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780095252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOZu5NR42SpEsku8Ns1Xem+A9XCgYdtBxKbxW3wb/Q8=;
	b=6TEhs+4lyQfLSdQuX1Yy4ieLWRCx1kdmpKUq/MhmhqU9+CWdLpHZ1ON58yYlVaYUSTjUgQ
	9jDwjFmCb66KTpE86P4VWdRgrRkTiDSZ2TCuyUbOsK8TYSWDspZcqZozjq8SsTNxHft/bo
	+Uzp9KHoE3xTbwA8AIEKP49kV60Slbg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UwuJ6v5W;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf31.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780095252; a=rsa-sha256;
	cv=none;
	b=lylanxTpqRJG8jvpXQhfvVUnx39aZ+unaTErOfFVDLTlKktLz3Qx2xw/IAi7qCmg0Re5eW
	gIEsz4pQ00g+db/qG+3uE4Gb8fIBE43FmA8bro8Wc+nYlwzJ6609E1SJyqPmobkXTO1z+k
	0aZ1VD+69WHq6mF/Pli+0GqTNk2Llv8=
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64TMCQCb1404571
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:54:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=GOZu
	5NR42SpEsku8Ns1Xem+A9XCgYdtBxKbxW3wb/Q8=; b=UwuJ6v5WZJ0OeCqb38nZ
	HxEw2K5Cim53nr0/UyKGLlTxJ8iXCu7a1kzXow6FM8Jm2xVS/jS6fXhXw7NmrG+i
	6Ynjd0MEmmJHxai0llD5mTU106Dx+HBK2yTwvKbRxKZ0Gi3l2kG4Evjxx9XH5tnf
	U6xdc7bZuNMv8AdFXqojAJecp7t44lFRQjuiCn2fRWu3hGsG/u83f6ivFjj67M93
	DssaA27UFx5/Z6enDS2FA5FfbGcpreXwLfICcVDyOb0KSG3OGeelkvVpmMdzfyVV
	qhIQRMNBFt+9suOoW4qapI52ys14Wg13IPwJ73GHax4AgwXM6/Y2JPKDy3tT63tc
	zQ==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4efj9x0m4m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:54:10 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8ccdd96f25fso33316226d6.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 15:54:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780095250; x=1780700050;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GOZu5NR42SpEsku8Ns1Xem+A9XCgYdtBxKbxW3wb/Q8=;
        b=ZwKvFkHU2lpN50uDLbJhanwg4cAeAgIfpWZRagh8e4JJVK+8lKOryA7oQe5YnE2FGG
         01hoZVbNHSAIJV9sJTM2rolKdQoSLyq19SUHkombN4JUS5gjYcY742DDlXS5I122Lfa4
         75g2GghWhhoS62ev0imBsDW1B3ikLmIipz5I5Jyq4nINKcKvqbn3fxhITI8WqNlCRxzw
         WBF9tvYMkYgtT4597CmRPfP6RPvM1DHwNaCmNL5M/Vq48f8mLNZ9O7lmEZ3SFzN2untm
         dkeNgCmpImeYwM3CfvcsUGyC9dcitIcIGBRBgchVW9r+iHiUXDfCk+uGR0152MYWIiPX
         o8iQ==
X-Forwarded-Encrypted: i=1; AFNElJ99Kd4h6/nAmcKGk5/rqw6LwguX47BD/8EHsDIxCNIDTovsycPCxmdclaQh+SeEY88wAPppN5CsFQ==@kvack.org
X-Gm-Message-State: AOJu0YzLBc5CiKd6NYGU2K5ZWqQC2isHusgPj9Fe1xcrz8s+NVVjMr86
	gB4eVejBFLeBa8qvq41z2X4HKbyNYX3Fb18JYLeNk4HHiBVsejn91tI2GQeo55sRPuB4OAIdZcj
	bRbYSZzKbHxIlr3EkUuPsC+FS/PKm8JR+dldzbtcJeceJEKbI
X-Gm-Gg: Acq92OGihNhaIFkKChR/jW2BebqDi3xE5QdzXoY9YTz1uBJdTFMWXlHLKKvrpqnkFEI
	9yc0j7f3XOpfPYADQoAV3XFtkY1p/G3Lna9BWaMAzGR4++RxEpR3sAwU4/07ZtMNLXo1HtUV82O
	CahA2Cc1ZXq5FGWzwaIG6MNlc71H6Ejjxxab06Z7OjRjQSlW7079Z4hXqGqzEQD2KCq01x5Sfra
	jZ9A8LNvMsmbvYW3U1ObAmO0QCeP1t6Ftll8qvsT85ywdusKPph6AMmujKoRxWpisgnuKueSxP5
	Pz10vekdXmW3gTFXab7fKmZuMPe0fdjsL+5wqsInP8hV3HnuwhmOCo0ZCHtMusViMIqpz9hFVUe
	pnWr+Wn0LsPtlDDCS49Z/bMlqOHO79GLvAlgC+lbvR+MrkGUWsBO9qtSEdPoD6fADyab0A3RzXo
	y5kb+LNQcQCKcp6EcdrGXiAqaFqw==
X-Received: by 2002:a05:620a:7005:b0:911:d96d:139 with SMTP id af79cd13be357-9152f91aae8mr628980685a.11.1780095249714;
        Fri, 29 May 2026 15:54:09 -0700 (PDT)
X-Received: by 2002:a05:620a:7005:b0:911:d96d:139 with SMTP id af79cd13be357-9152f91aae8mr628978785a.11.1780095249321;
        Fri, 29 May 2026 15:54:09 -0700 (PDT)
Received: from ?IPV6:2600:4040:974e:fe00:c8bb:325f:9d37:a5f? ([2600:4040:974e:fe00:c8bb:325f:9d37:a5f])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91532628f87sm335923385a.35.2026.05.29.15.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 15:54:08 -0700 (PDT)
Message-ID: <fb59cca8-28b0-4231-a109-a6ae0ea12a03@columbia.edu>
Date: Fri, 29 May 2026 18:54:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/11] mm/filemap: split out folio wait and VFS code
To: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
 <3dxzu3ck5y3wxw4pp2qhzwwb6y3f7mwhvgxfpl56sokw4ymop7@xaaoxsa5yu5q>
 <ahg55Ei8Fc3iRsnA@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <ahg55Ei8Fc3iRsnA@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=RKeD2Yi+ c=1 sm=1 tr=0 ts=6a1a1912 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22 a=lO0XnYq6BgjnjRCXdOAA:9
 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: YlGmW9H-A5cRyWWvM-A7zukD64bBPW7Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDIyNyBTYWx0ZWRfXwy+Ek5ZVZyZZ
 sK4RcYeaFXNLfqH7obXnTIg3tJNjMf30mjriLGnc2C16JaUVRAhxXitMIscxUvFRItOCvWmKexV
 MPrVvH0RjltIIBRn7GvWf5mFIWuUYvCvY9p2oO5ii2EyFN4izEk9WOtFASCX2oVxWilHUXvVM7J
 bEYYADVRY0eTTnNbjoE0hSzgLg0MNm6WFUBxJ5D2zikT/MnAFWH5eZAh6lztjRsPDNFit1+T06o
 9yFCL6Kpc/1vOp/xkjhMDkCWOTOAqxbne7b+iD+fIu8YUZTjYXGp1HyAEGipDTmahyEE2m4LXeQ
 zQY8ruITjXxylK16pF1bVbFLfuSaPRLfAoVswRv2E9p418g7vBwuEQwTMQmGEPVhwodaH4zBa24
 80FyZPlAq0MyBQhjhrOiCEqxCcu9T0NEBhbIhueWBRKIfMBjIPLRbLHAzclPPm750U+or5z/qGV
 8vc12YzQKNA/VqA7EUQ==
X-Proofpoint-GUID: YlGmW9H-A5cRyWWvM-A7zukD64bBPW7Q
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11801
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 phishscore=0 bulkscore=10 impostorscore=10
 adultscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2605290227
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 06F6520004
X-Stat-Signature: pcqywf1c4aen6trq589t4g91keqm7i4a
X-Rspam-User: 
X-HE-Tag: 1780095251-127144
X-HE-Meta: U2FsdGVkX197hewSm8mjsXtDYwkrp6uN0uoNlVR8WPu6tJaq1QZza+25IcmWjN3iFfI07CNiUKVTvs6FBYjvWtk4Vb2iFPOeAypseUmJeWrhD3nWY2qWZKMCrbMoQo6W24KjSAJqbdPitM0fg1JM/8aeYrYoIvpUlyZ9qs7JiyqSIYqSUxjBxIK45PuuM5mEFRvUTrnShr2eCGQAP8stCysJ+c3IV/y20l6uW0kq8zdSEjOpvEECQBtYDNWX7/u4UNB9Z/5hmkXlzuLEyzKvKFFgJtKY+bVx4+64YKSxQbBxowbKv99reFiJralmjEX//1jqldGX4N6PL1jAiRGC2NtlF5bkf+9b9KuUwPFKgTDf0w3QYBMZa4TK3x6aSxH3Td1v25tKiF0RoP2i1a/ACX5kxyYibHuartfO6hRcqMJ+/uo8YCsS5bYqnhX70KNpKpknginletm2PHuggO9jkuKf9ttYo1/zaDl9/yX41YeqiCqEtGhY2CbuSLcyoW19Wf6CNdtyvMQqHy13SZYhE1LbIGY4eiKpMz9Wv+JQyn4EyHBkY+78vecZzZoltWSvu3VDj97dUrmf1bWz703uzms/+Y8XYnOP/ZSNeBADzs2UWpyP+YsPlgAR9wNsI0ELXXf+OvSQPWHG/jCgCOIDq+HQz12n1bWQILOQ1e1Ircor47OHti6cuIdgV8MqeNZDiPond2Ts28E5gnVEdQ15BCrLvMxU94/Xuk6e6NSF+fDB28NQdPxPdW5BFbA8JFIqmKuw4mFFd4XYlaTl/BMOD9ncsjwS+qCNknnSeh94N5k2CfREK4q8/POt6Zy8NCqlwMHkMQ8eeQwrAOWAGCnE0vdqJ0hm1UBtb1Xzuvfzlt9TI2SCzLkHWGlUmK7o2ygg3qnrrfbVKDrRbJ8x3tbsF/KW3vkHHWTPLQak+fkdkCwgpkh70xrqy2avRJoLx3hf7gD8kGX3pT3rL42+829
 0RZClQ+H
 02wevD81YhEny9W4vptr4R9jhrV4HzE4lfqaEYyJ0OeIi2EJzg68aE0Y+Ix50dnSRbt+5VG3D6q0AtQmC7O3bVbcKSZ8UIQn1bWuqVvgZq25KQpf6tuqh3kiOt5SFWzoa1wohaorR+A8FLgop6avWfAIlAeeuVRjuP0ZzVWGJvMLGXFMVjxnzS3VoBMOIGzbYLnE8LeGdzuY8VRxJap8lOsGSOyjnmT1FhEjQhOtGUV3lZXM4kZDmqug6hhmIhlVD9/Evxq3bWFFH8pcaTWj7j1s+YhCfjSA19qraGum1hGwAuPry876hDRe6FsGoPT5a2mwNeSN2o/RLkJJ60L9zYDfD3tx1j5Up/ByxfmomYr6v86005TTz8tbfUlqEKfeOgXEcqpNE+FI/y+tf4OccsUcCEt4tnMS0dlKubi/6rZXKr90H7cyM5K26G1zRf8GakyRvKQSvlcZq6F9cOn227r40xAbQrNRmIVll5J6/NDGCCYLW+RII0SOT7BnRQ8qMhyp1aPIO+5b7XtH4GBG8ozacwbnzVEkDWynE4rWeuX6wwus3TATuMtcp0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 8:49 AM, Christoph Hellwig wrote:
> On Thu, May 28, 2026 at 11:22:37AM +0200, Jan Kara wrote:
>> Overall this makes sense to me. In particular I agree it makes sense to
>> move the file read/write helpers into fs.
> 
> I disagree very strongly.  Mixing default implementations with the
> higher level APIs is a really bad idea and leads to people taking
> stupid shortcuts and other layering violations.

fs/read_write.c already contains some of these "generic" function
implementations, including generic_write_checks(), which is called by
generic_file_write_iter() in mm/filemap.c. Right now the two files are
unnecessarily interdependent. I do think fs/read_write.c is the natural home
for these functions.

> Splitting up filemap.c makes sense, but I'd rather keep the generic copy
> into and out of the pagecache code with the MM infrastructure for it,
> as it is not VFS code, and making that clear to anyone touching the code
> is important.

About half the code moved is implementing direct I/O or multiplexing between
page cache I/O and direct I/O. It definitely shouldn't be in the page cache,
and I do think it is VFS code. The one exception I see is
generic_perform_write(), which is analogous to filemap_read() and should stay
in filemap.c (and probably be renamed to something like filemap_write()).

