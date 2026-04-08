Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 941D110F9968
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 20:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEBFA6B0005; Wed,  8 Apr 2026 16:10:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9CDA6B0088; Wed,  8 Apr 2026 16:10:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8B906B0089; Wed,  8 Apr 2026 16:10:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C95516B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:10:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C4BD139FF2
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:10:46 +0000 (UTC)
X-FDA: 84636481692.25.C707A3E
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0A67920013
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:10:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="g//499sA";
	spf=pass (imf13.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="g//499sA";
	spf=pass (imf13.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775679044; a=rsa-sha256;
	cv=none;
	b=SJkA9BS/ftXMVnR8yAoUrZ31ge+424H2WgMBULLBDIAyd6Pk/WQYUpd5XCs78d8okfAFNU
	1jQRjKogK0xjXC5Co3WOF6tPhVyxpAx9d5k3jIQYxfd/3j+D00GkQplpOs51NIb+hoQGrV
	DpfhbmRJ9IOwmivQbAc19QGqtJzvS0M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775679044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSffQ46dxsNqLEMfW9mFNMfZBuciexIdSUQp95L3zYs=;
	b=TWjV5wRmtmwI8Ued9fB6Kiqpiaviy/RiwODyiUi8ZxNyBfkdfC3R8vBpVkk6bUb2Gwer5v
	Uz/uGurSAFiXua1IoNpRcpsDUP2FjU9L5ziQBDdyQWPf8L9kH03U1QqMwDAfJzWvufl8A0
	Rgy/4elWeRPGA2aEXdqTN+VlhgdbM00=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638Ju6Rf3709294
	for <linux-mm@kvack.org>; Wed, 8 Apr 2026 16:10:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=vSff
	Q46dxsNqLEMfW9mFNMfZBuciexIdSUQp95L3zYs=; b=g//499sAUgG6l/aPNEY4
	MrWDgZlHmfuOJ2N7pJMdRvAl/ADxc31gcYWWhPadhtApYsJGBMdVuAZ84Tyf0TLd
	o7X5qy6NkDuP6cuAUkdTFD8YsGuNlKCVqHKCAnE9rBvb0CUUJkvkmpeafOlj6nFb
	KtVZjONIOH0+rMVhdndCyxP4SZmYj9cAcwKbHQBhr3E0D2JfV0q7q15HV/dekLR8
	RPvAfnvNTl8WK7OvOdrYJ5LOORWmu9FgFUIZkXM0Vzzwg+Yg6PWm5vkmCIWOp7A6
	AKzSJZs356dJIl90Rk97kyFsa3pwGkyruHvPJHy6Wv6ixy5KnZy0bZvHdbim9/DG
	Ww==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3r7feg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Apr 2026 16:10:42 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50b802961ecso1865041cf.1
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 13:10:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775679042; x=1776283842;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vSffQ46dxsNqLEMfW9mFNMfZBuciexIdSUQp95L3zYs=;
        b=kxXgZHRcDo/mF4z2wZwUxqsTNhOKoNGiIA8eVSzamr10pC7wBLCd8WRxCwxci1v4hZ
         HLnpZoKlHWQYdFE9zcnxpUkuCTFsVSL4+YRcJeogNw7ybaCX5lKpa/NjNG3P8PvnvZoU
         Mp/LE4mL2n5JTELRF3H5z4C7LhfhFrUp87MF0Dv9rga1uUqwDiQXojUnjx/cjGdvnSpT
         6pFpTXRenc0HXe0Owm0U7q949jJKa0UC0m74NrrZdgIYP5GucJ2X54/frtYR6moC0Pwm
         QinXKifrZVVrtRRmVaHjgKeQUZC1VKr67BxjFX9NJjTiEabjGYn+nKzYNey+gBnIizTz
         2BQA==
X-Forwarded-Encrypted: i=1; AJvYcCVfSzy6lBplVb6E1Rv5ECZmvNVNP3xCBIO80Z9xknDagVTpSvamRqluHdWwZ6isjdwSlxhbVZ6TMg==@kvack.org
X-Gm-Message-State: AOJu0YyAkXnNIuvhO3hVVbxslky68qGtQNeho7QspXJJHkc7jbkwhx9Q
	brc7qGazAhsWcxfHzjVtWlPacyYFiPLpFTo8OiYFOquTRXI4ytjOdQr1AQ7IYHELACvpSYBf17T
	RdQGAGURzJ3SvRk4esAbqz9sw0rOZv38I14MBgX7SWpBmQLh2
X-Gm-Gg: AeBDies9rjpz5gZHQI61UoAUDglIAY0TeqI2Q7w+3mWUqyn3nWLA6H5xrU8JAcRqmFe
	P9uoumIVPLK2wMN9nwpR7q8A911r2xG7zkPNmwuVWzghcihyhvEmDc5S4GY6mP4s6F6deK5ueAw
	nef8FdJKSnKClwtNhaB+pQsTD9lZeUrh9N36wrLdxy9m0Kdr3RsP6OLEvsuF0XjDVk0xsx9ApCh
	eVpCkrB08RrLR2X70M7SRQ7euq+UkNmVTRgfk26SMXueRX+7CLlqpn5zM/UgFS4fL0XvC7UM5QP
	3TkUVvxg7JtzLrkt64K8TRjzb85PvTRFPwXKUjCt+RwQo/OIrcyJldkHsFydtpd6xL6O/coGflm
	hbYPvnDvwqC/A2FkTKkv/XDEtdjJJe8T9UNESWUBi
X-Received: by 2002:ac8:5846:0:b0:50d:83d7:686c with SMTP id d75a77b69052e-50d83d76b21mr252299501cf.31.1775679041647;
        Wed, 08 Apr 2026 13:10:41 -0700 (PDT)
X-Received: by 2002:ac8:5846:0:b0:50d:83d7:686c with SMTP id d75a77b69052e-50d83d76b21mr252298531cf.31.1775679040871;
        Wed, 08 Apr 2026 13:10:40 -0700 (PDT)
Received: from [192.168.129.206] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50db5cfd8a9sm20333591cf.12.2026.04.08.13.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 13:10:40 -0700 (PDT)
Message-ID: <62c1ec17-082d-4215-85ca-3e87048a6226@columbia.edu>
Date: Wed, 8 Apr 2026 16:10:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
To: Matthew Wilcox <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
 <acRDyJrkJhnHHMSe@casper.infradead.org>
 <9631d652-fd3a-45ac-b8a3-b632b26f6fa5@columbia.edu>
 <ada0KnRjpYnY_QYh@casper.infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <ada0KnRjpYnY_QYh@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: gvuUalzwqihCwa3WawS8-N0zAAwyssoR
X-Authority-Analysis: v=2.4 cv=UplT8ewB c=1 sm=1 tr=0 ts=69d6b642 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=rfDhleDhcnsx78YaP-MA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: gvuUalzwqihCwa3WawS8-N0zAAwyssoR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE4OCBTYWx0ZWRfX7pf+bY6owgXJ
 orvK9aql580lWD+v43YvF59nFiX2JkhcnUpXO1uL5f0R3f2D1DDmE+MyCGtypmtQI6PN76PHrGg
 uCL+7/jSn3ide2KvqzRtHZ3ov9hPYRqbsdoxr8Nx/jCwM2rZYcZOAell1TxzU02WWBWL4L1Il6G
 tsCHI3MSZ/61CLpEtFzR38p7pjH+wc5C3lx/L5ftalzVu7bLG3i24nEIV3iAgwoX9BW64+6D95v
 j97Arw9ZX7hiVYBp8g0FigHPG2RLHkhhviN1kFppICYxMqSjHbh6u7WhowiEWb4N/mUJlfylUGF
 QzBiQhuPgUwEL+btixqanEZvJiE5Rj1u3RzzGsLMFHHeKD1wuJBUP8k+GzfbasfnJoIxHBtCO21
 Ck6vRrFqj874JusSYLuuFgEaDEPzxLrusEXMfrxWIyI+geoXPRZ322b4ZVZxGW94GsHW/dGI0qM
 A+D8etZhR533Nxdbk5A==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 spamscore=0 phishscore=0 lowpriorityscore=10
 impostorscore=10 malwarescore=0 clxscore=1015 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080188
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0A67920013
X-Stat-Signature: h4ayyp6opo7ceqmpjunbebrnfbbe7ogn
X-Rspam-User: 
X-HE-Tag: 1775679043-368269
X-HE-Meta: U2FsdGVkX1+pxLhxDCnEZu7/w1etdYqxrYygL+8HO8CoL2pXhvHdBPJ8hWOTb/5x3N3cBNaVoBZEj0jfdIHTvu5kFfl6UBdVhcWyrWmHVu+zS2RyouuqQRMeghIhG/aUhD7F9UbMe810ly5fiskgTuTSAYfo9BDrp4m37msLPD1VQy7N2DGY0zMGVUn30+W8ec1A3nj/3zpxqdLLmfjHzcco2L5Dkerq4DNw7mwJU5hil3Om60jLPRPXGkfDNYx+8StCHF1vBlygjtCAubf4utAt0CiPayW4QLtmyJVvpBBxrTN9giskgAmg3q0mv2zZpVb8hX8eavpXwrMz5DTKWuah+Il7dHtrW4Ct/0l4sp4utwG1kz18vzFD1McFeJCxQP1OJ3s3R5iUj5iBd8BxzwGRdBy2ttwbkkwd6FxoNTv9GRLpys2EpW5mlEtKRm1uH7BxlmmVNVeaE+LCNtKCeQ77alRMZ1FKIvcuJ890KPx4B9/A9C8FZWXN7HIAv4/CokNfRS4XGsp2zTdSA9Z2Ci63gRD5p8925VrP/r3jDGWSeKAvM8r3aVifMr5kRs91ieJ7VS/iPQWfFdUilIbAyCgZSYn4WlMUX524CzV2MXZk1EHj7GHszCB/3pXNrEhwblaLmQB0U2sjAcQVFu0shSY2eoHHSoYp8SKiU8+Kj4XgX772r+GV4wdzUk7Vmq8IVBLk0fouSHt3P7V4EE7n606IKiQlogutFSooXWmqNbpG4gs56rlIoQwmcYIHjXqj/tcM7kTBOw5jGZtQHRgW4mYiaJRmrpcHFqeN90MO1pL/4pY5qN7b4fTNrs7iWN4x6TfgDY9D3rLZEs5IYjpKNKLdiMyXy0kQks+kSRNh2BsH726K1NlAYJNE3hbKYnHUUPU3uYOrovfC9ctvsuqg/nLUOjLmanmmh/iNVFEkxnRGqCb6ikMp36I+WCOBv0dhtCgcM9W89sZady3lkIT
 NLtLLdj5
 D8oFdx8BmytLriCBUbe6B8FSFGvyUl7hICErKSQw+OsMDrj50YFFLAWzQ+/tcldutISEF+VQ15gmzKVt2Wcci4UVJ+18eWkzkKeahABELmIENbMoiK2v2QvIwzAeGm6EcdMi2TORyVBPHz5JwrKbf9L5v0ZRF4fAh79etaSMY76uE4vDUE007W+4IT2YiqqwAy8oBNTq60B8spM2je2Ik5ad7cOO/WRQXMWDSXJXJRwTLeuRJIRW4Lxw2VcePNnyp4MiGXu3Eka7N/XIMb3exMqiPlxjrWSNNB0u2Jgym8+yy/w5VWmQoED9QRcY/n6uD4QAtzkKPnjRAHghcLf4EJ9//ieCeonUl4usKVcpxrNMGH1Zqw5WUQyFHVQZQupatvGQPV5zBnHc3SWpWGfFSAAMF98n/Z0AqDKEVz4GtpuXWcPs3wx3gQBzxC2QI52bK+D33kJRIeQuptf/6h1moyAvVMS9nzM52dCujIXD1rguaUD3Sd7TO6ZVJ+MAqen/AW8ranH8Tm2gd6ZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 4:01 PM, Matthew Wilcox wrote:
> On Wed, Apr 08, 2026 at 03:44:37PM -0400, Tal Zussman wrote:
>> On 3/25/26 4:21 PM, Matthew Wilcox wrote:
>> > On Wed, Mar 25, 2026 at 02:43:01PM -0400, Tal Zussman wrote:
>> >> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when
>> >> IOMAP_IOEND_DONTCACHE is set. This ensures that bi_end_io runs in task
>> >> context, where folio_end_dropbehind() can safely invalidate folios.
>> >> 
>> >> With the bio layer now handling task-context deferral generically, XFS
>> >> no longer needs to route DONTCACHE ioends through its completion
>> >> workqueue for page cache invalidation. Remove the DONTCACHE check from
>> >> xfs_ioend_needs_wq_completion().
>> >> 
>> >> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> >> ---
>> >>  fs/iomap/ioend.c  | 2 ++
>> >>  fs/xfs/xfs_aops.c | 4 ----
>> >>  2 files changed, 2 insertions(+), 4 deletions(-)
>> >> 
>> >> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
>> >> index e4d57cb969f1..6b8375d11cc0 100644
>> >> --- a/fs/iomap/ioend.c
>> >> +++ b/fs/iomap/ioend.c
>> >> @@ -113,6 +113,8 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
>> >>  			       GFP_NOFS, &iomap_ioend_bioset);
>> >>  	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
>> >>  	bio->bi_write_hint = wpc->inode->i_write_hint;
>> >> +	if (ioend_flags & IOMAP_IOEND_DONTCACHE)
>> >> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>> >>  	wbc_init_bio(wpc->wbc, bio);
>> >>  	wpc->nr_folios = 0;
>> >>  	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
>> > 
>> > Can't we delete IOMAP_IOEND_DONTCACHE, and just do:
>> > 
>> > 	if (folio_test_dropbehind(folio))
>> > 		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
>> > 
>> > It'd need to move down a few lines in iomap_add_to_ioend() to after
>> > bio_add_folio() succeeds.
>> > 
>> 
>> Actually, looking into it more, IOMAP_IOEND_DONTCACHE is used as part of
>> IOMAP_IOEND_NOMERGE_FLAGS. I think deleting it while maintaining the
>> no-merge behavior would be uglier than leaving it in.
> 
> But why was it added to NOMERGE in the first place?  I don't think it's
> harmful to merge writeback I/Os which are COMPLETE_IN_TASK and I/Os
> which are not, as long as the final I/O is completed in a task.
> 

Looks like it was added in commit 34ecde3c5606 to ensure XFS DONTCACHE
completions were actually punted to task context... which we now ensure
elsewhere. Will delete and mention the side effect on regular I/Os in the
commit message.


