Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A66CC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83DD76B008A; Fri, 18 Sep 2026 12:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C7FD6B008C; Fri, 18 Sep 2026 12:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68F1F6B0093; Fri, 18 Sep 2026 12:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46A306B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:04:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 320A31606F1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:04:07 +0000 (UTC)
X-FDA: 85227354534.08.28BF240
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2C537100004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:04:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=IHfsqH0i;
	dmarc=pass (policy=reject) header.from=hpe.com;
	spf=pass (imf14.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=IHfsqH0i;
	dmarc=pass (policy=reject) header.from=hpe.com;
	spf=pass (imf14.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789747445;
	b=zgRwf+nTiya1pZd2PwsRREJ9Q5xy9OX1qrYeWFUBZHbmXI/FTrGXWNKiPCSn3yFLAzFPkO
	3wu3c27rIH5V88PpZvRqv3DxuuG1I1+coTwTs4Xrb+yQJrTs0VLEVVhdwq/yPYD5Gt+VXk
	tqoLvnUVAnC90skDRxMRepD+fd4490U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789747445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uc4FCppFKvSYMEFUJD+GdMcIgxfJPxqNRU0X+NKpVX8=;
	b=wDc9UoH99ITPIBTO+74x+Z50UkVrFUnGlSKYfEXua9Y/Z10qcqPNqv/Q3O8rBtD5RXMi7+
	5hbdROTaA/ZtN5zHdtYYr2VaqTGGvdPRcNOEKX5aCe7KbToEENEdmjBJ0RNX6TUJJNVnaB
	1IjPItz1bqGPAaEcTF6oextvOTAfYpM=
Received: from pps.filterd (m0148663.ppops.net [127.0.0.1])
	by mx0a-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68IDNBXQ515911;
	Fri, 18 Sep 2026 16:03:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=uc4FCppFKvSYMEFUJD+GdMcIgx
	fJPxqNRU0X+NKpVX8=; b=IHfsqH0ij+X+9h6dvxnKG+ln+4UgfkXSOrbSG2AMVN
	3sAGXfDLckP+TodrXje4alDDMWqYZuWX9mY2/kKVIQNp8Lf7gvusxAbtarGjP7e3
	nE46s84zQGcdMeD0F+i9pODg/yXV0R6XK5FaZbeuQDPNTf4F7gI/v4J/i5UIyInj
	+zMM88w2fFRPSSTCkHdKcJCP25XMHdWw3GtwcqY9tQqPsMnsteWLS043RECtiu7+
	9dT3MLQlm6zj3ihi3vAxuPSRHxj+ZTGXkiJZb5qTE6R3CVXbfbH/FM0/0gaYCDKE
	odEEvTaWp4+bJik5jc7FoNK7I5XHRwE/YruFWbpr+img==
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
	by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 4gs4bkbj1q-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 16:03:12 +0000 (GMT)
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id 2BE6DD2E3;
	Fri, 18 Sep 2026 16:03:10 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTPS id E6C9280AA61;
	Fri, 18 Sep 2026 16:03:04 +0000 (UTC)
Date: Fri, 18 Sep 2026 11:03:00 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: Michal Hocko <mhocko@suse.com>,
        "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, corbet@lwn.net, linmiaohe@huawei.com,
        shuah@kernel.org, tony.luck@intel.com, jane.chu@oracle.com,
        jiaqiyan@google.com, Liam.Howlett@oracle.com, bp@alien8.de,
        hannes@cmpxchg.org, jack@suse.cz, joel.granados@kernel.org,
        laoar.shao@gmail.com, lorenzo.stoakes@oracle.com,
        mclapinski@google.com, nao.horiguchi@gmail.com, osalvador@suse.de,
        rafael.j.wysocki@intel.com, rppt@kernel.org, russ.anderson@hpe.com,
        shawn.fan@intel.com, surenb@google.com, vbabka@suse.cz,
        linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aq1gtOOUqU1-RJJu@hpe.com>
References: <aqiIEkrc6aDBOqRg@hpe.com>
 <aqkCbgHmMGxI_GLG@tiehlicka>
 <aqmGd0GGUCkbZpkZ@hpe.com>
 <aqpYxAktjexhaMGc@tiehlicka>
 <ad36cd54-7319-4bb4-bf8f-9fcc7b009158@kernel.org>
 <aqqXbwglwYTyTuUG@tiehlicka>
 <36480c86-fc59-4387-91a4-cad839f502f2@kernel.org>
 <aqqdlndHq9vHeX8s@tiehlicka>
 <67b63b36-82c9-45d4-8dd3-1bec2823a123@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67b63b36-82c9-45d4-8dd3-1bec2823a123@kernel.org>
X-Proofpoint-GUID: L_WdTr3DFK_IidRpPlCXthNiuHl9BS72
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDIyOSBTYWx0ZWRfX6ClIMWsv6mB4
 0IlWT184tZaynkzSZIDoNoAERHmTUSCeSWT2G9DqDmAPWikkEJHU7Z+OCK8WjidX8Tiyh8hpvlw
 lKCwvXrpUS4ES7gMjdNHX3dLER0LLD4=
X-Authority-Analysis: v=2.4 cv=EvhHPicA c=1 sm=1 tr=0 ts=6aad60c0 cx=c_pps
 a=UObrlqRbTUrrdMEdGJ+KZA==:117 a=UObrlqRbTUrrdMEdGJ+KZA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=6_mrDcixewTG61oOsKN3:22 a=RfWlH6W0a2UdQScw0pgA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: L_WdTr3DFK_IidRpPlCXthNiuHl9BS72
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDIyOSBTYWx0ZWRfX3Q0UtYojvFKu
 3/JDEpX/5OkGU3VRG+md1cX5CgLjCC94TPLncGqJLs73047ibKMKLQPBDZ5i/WqWvhAkdWbnn/W
 ZVEppZupoRXP1uUhtBcyQnOhEnhotct8Wgu+2kew7fd+WS627izPZKIkFIvXRhUx+JHE6SM0CPj
 uSdlHm/QaKrlX23yGf2d7hQW6mu/x6TOkwGOOhw3AeYC3NQZPNbEbGdIpR84ISXLxLfqtqGWubo
 XIeEycNeUpkkOsXfYZbkL4KBKH7y/UH+3D0btomS9BAXq7sYko+BxUHc+ieZdkyIJgApL/W6Ssd
 2sug4u2chH3zdAP2QKIZpQLTW7DMqM+Riuo36V3c38q2lhelThRXpensQbEUaM9bUYC6l9pPetd
 N2/N4mA+n5OydnDCvJjB9m0CSrUFBvwPOti+oQ9RtzHfUCjERQeo1Xddenp9+Z0UqUSXay7BFjM
 DRiMhlch8smkwEXvt8A==
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 malwarescore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 suspectscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609180229
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C537100004
X-Stat-Signature: 8yidpsew34g468j8h9puyqtsyh9cryao
X-Rspamd-Server: rspam01
X-HE-Tag: 1789747440-705468
X-HE-Meta: U2FsdGVkX18Lxbp2x3mEWQikrBNMETEmOo5uoYyzY04IUUl4PPpSqTCQTi53JYkWnwO5USaCvyuvPfMhqgCPpeT6yTgXvPHmFL/A1nD1X3ViHKJ4NsXcmq40UKhV/lmxvLdCx+8qZmkyp5p22GtrNo6oqtG4mlewECAVR7hRPtLXee6sl6ZQZFz8cM/4pifZYpswIv/ECGN9DcXcwAZ+7SWaBTeO4LJSlEXNzUhYJCqf57O3kFB0jMLPPvXo1hmQL1I6irExb6VlP3YR040gXCxofCNG26vSQz03AaKhnEhWE46MW5IVM8PrYNEWn1jM4FrFPgZaZ3QEHK9CHhQBY1eipJ+N0RSksnEDdsnOV0q5RTHSfqi7QS5E70+T5ZWTRzLDzATnFRL8K9bM9zecm4mT0Hd0Fetz0SqhnU+OnjvR8cUmBkKwOD49zy76uUphnQWGyZGf+Gw0PfAl6lMDdmOBvulWtJKbqUVER4kltt/OZA+B9QidumGZfvkvcx3f2i6WWjaxFI27qxyDrnkiZsGvOH3oQYeQTiXhCQdwRxTTW0+jbIrhk7gbjDmstSqB7sxkvdLg3jWl7mJb1MhH5Py6qK5fqvblHvOC1wmRsZ/DryvbXq+VevZlsThjagPhjQrsXoToTF42LgvSJs+JLSkqb6oS30yZz7JuQ+a3RjfDJFYv0K5si7/LCnAxmXtviz+iMsxf8dP5aGfXpxy0/SmnC25UrmQo2IOUdENZmnEBB0ZLYyAagkQlXNrUbqSwQLDkH182DGaBO9vrL2owgRcNimFLGmum0eZQdqVrSQUGUIqS5HXkV2U/v4rKFnEJbc+SJDtc68hl1BrJUVH/ReYMdE9UZN2WeuAaXy5dU5r34/Syko3XTVypz646av7nqhYO0VD9xJBZYbqlBDw8jAc861xCYHEBXwmN+LaJ5C1tqNIzvWoD+RC2bsYXJ6p3HyE77g2xhX7HxDdeDQN
 E2BC8Doj
 4OdnXdxhr42CgdxvGyA6AlcVY6k2TCvMI8JQU3iD+7Ke6qoxpvQ7bbbtpHkwTp4Lxb6KRAMkLwhwB7MUWUV9WJRWOUOY/O9LDNpsQ6qZoBnvEYmcydnIrKvPsnRPae5v8tiAm1gOCGDy5SbIPTlLvkMJjzUSg0rPswZVlQLgXW/za7JUyFkregpy7YUB1yu26zIhv2xzX/aweIx2U+y/cVTlwt55khVXWuwSMgHNpHOSUGVv6hxuXQ7nQa84aAFUdyeA/wUmjv1CHnTs6V03W2d+XQ9v0GhQHaNlQyXIXN8Wtb7qP/LKRQMlujQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 04:30:46PM +0200, David Hildenbrand (Arm) wrote:
> On 9/16/26 15:45, Michal Hocko wrote:
> > On Wed 16-09-26 15:28:01, David Hildenbrand wrote:
> >> On 9/16/26 15:19, Michal Hocko wrote:
> >>>
> >>> Yes, no dispute on that. But we have HW poisoning for exactly that
> >>> purpose, no?
> >>
> >> Well, that tells you that the page content is effectively gone and should be
> >> tried to be recovered / migrated away. Unless I am messing up terminology here.
> > 
> > Maybe it is me messing up the terminology...
> > But I guess we have established that whether soft offlining is being
> > abused or not, excluding hugetlb through a configuration is just a wrong
> > thing to do.
> 
> Yes, it's odd that you wouldn't want to evacuate hugetlb but everything else.

Thanks for the feedback, Michal and David.

I'll drop this series.

It sounds like the consensus is to keep soft offline behavior the same across
page types.

Thanks,
Kyle Meyer

