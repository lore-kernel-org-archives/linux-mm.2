Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3630EF364B2
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789A46B0005; Thu,  9 Apr 2026 14:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A516B0089; Thu,  9 Apr 2026 14:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629176B008A; Thu,  9 Apr 2026 14:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 534CC6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:56:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B03DEB669F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:56:39 +0000 (UTC)
X-FDA: 84639923718.18.F8EDAF4
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 414C3100006
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:56:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=C9NNnw7O;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775760997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TidFUCcjURxrvT0mTb47uTbc8cUi8gBa7hb58XJT0I4=;
	b=KXWyI53TFQxiBaGgd+lsyAMnN11Xzn4Kgsf7j7U+mmR2Dsxy5Wfy8cszIHysOJ9vd9cVs6
	rJdjznVZLucKIZl3o9XcnwKg715TaOs2Wx65J1JhTyv2VjJ+PdrfvJf9FjIF6Vzbt3HN/m
	udCbyO8S5coWqwk6gWEyAd95t6GYzP0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775760997; a=rsa-sha256;
	cv=none;
	b=oNVEjAdd9K1unLXuRskoZ1Z52qLH/vMsRhT26CHot6KrEG8FtgXai0DNA1ItzHhjri9ayg
	cg4PamXg1FIX6exgaJifrf5unXrSVwSRWfar6fQTreXfmOYTwvj7Yz0kRti/3Vm7AKz50P
	Oy9DOQVe3GTYKpHNxHi8GTUfu/2Y9i8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=C9NNnw7O;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639Iu9aj1780552
	for <linux-mm@kvack.org>; Thu, 9 Apr 2026 14:56:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=TidF
	UCcjURxrvT0mTb47uTbc8cUi8gBa7hb58XJT0I4=; b=C9NNnw7OyyNZTpLLiAgn
	1NGy89rwkfGQ8sKW2xsoDs3psZY5O19VidoJhD6BzpRDMyGkFkwTD1iN5wFldI0Z
	7ScowFZ5piO/9JjmpEEBRSlyCxja1P6z9Qy4nAXRuYvh4jS/8CaFyBXH4UDz1vcV
	7Mnk+PrEoPbR8rZZa1xVayXOGGpi39gL3Zntbbd7wmhqBLqzhA7J4itQLNZcZAbZ
	u4loMcbeOLC2TsS69QUqj1tdG4Qa70Zomc4Rnp/kG03BRMGpYgzzi5nZddQOssOj
	zWdOwOHr0li87w5xr9EbzOtHvvqqhmw6SVfAYvLxmRU3ocoFoYt5y+iH6so2OZRL
	eg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dec0qbncx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 09 Apr 2026 14:56:36 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cfcf23c0e1so235969085a.2
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 11:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775760995; x=1776365795;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TidFUCcjURxrvT0mTb47uTbc8cUi8gBa7hb58XJT0I4=;
        b=Ofs8TSERMYMxUgHtxURLRsKExV2WJLqRv46cxfRRp3YpSbCHHzWlMwS7hN/dVUT+AW
         ZC6wM7CYv9OAZRhwNEYbjLHPgOtmlTTONRvpLeejccz6JGuZqsjcxog/xg7NfZ4RzF21
         RxKDrjyy7bMezk9bzrm5TBMJNoUDM64BhMkYqZlmBqXb3FnoQ7zuBU41Zp4Iz9MjYTvh
         gCDYdermB1zDNz2yz40yOoXF/QfzqweaOydvKBoZqIQGnMVz55fShwitljZO0mUbtisV
         onYAvaiHDYaK1jgLlXwXkS6GEDdhqAzJ6k0YTMf/qTMlw5TE5dpm1mFbfKDF2vfep3JR
         cbGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbQb52vjA4u+Z0ZmtFFHY4OQn+q9Jf99jUZsnwRTLhtspSn/9GAkpocn3Nf9CLhhWuen76pRH+Rg==@kvack.org
X-Gm-Message-State: AOJu0YxpCKTASTr53RVCnq8LrFETcRI6DxmlzJWtFYtfhrUDcacPM95Q
	K7JoYwgFidFAlblxmzSn2XGSLvvOqUJCnIaqGeDjShMmd7Ut2qTeSgJTd4PRUDQdtIuilAj9pFE
	SxDkqQR6AyP7uMUg4nEiQN5zOOGWeZ/Y0mvXDB585dRmThTv1
X-Gm-Gg: AeBDies3G1Wb6S+fXsOziOY3/zUFRtRYBPC05soUQ5fWxWzbZcJKpj5IrNSO6NDvUNg
	7F1LsmBzDxt6umya/O0wUNYKjPcDIllN2p+vuS/iVldbG73hfk8yzrJtsUIN+kXmo3hcwrCrosv
	USO4esBh3+4eYNd77kI/pcofzQvUg1ZT84Shicnpv8BNRqYtpz8Jv2W7tc3OlUDOktFF8brUS3S
	8UsdxLpu34i8NAAsXoYsVOahBUzPFzenG/cdofav29gGw7IytKWCeAkbNFq6xdjMd/JAGdlXUFH
	VBlSq2E9Eyy8YE66QGbd6jQ/MNSQr4oTdm05ACoVszzjEv3H4fihux+e9phCgIgwxa1oMltUcsK
	+nJ1/jRofR9jc9ImdK8q06wPAuecWcQ2Hukd9qMI/
X-Received: by 2002:a05:620a:1990:b0:8cd:972d:335 with SMTP id af79cd13be357-8ddcf2be7c4mr2490585a.43.1775760995713;
        Thu, 09 Apr 2026 11:56:35 -0700 (PDT)
X-Received: by 2002:a05:620a:1990:b0:8cd:972d:335 with SMTP id af79cd13be357-8ddcf2be7c4mr2485285a.43.1775760995230;
        Thu, 09 Apr 2026 11:56:35 -0700 (PDT)
Received: from [10.206.71.59] ([129.236.231.31])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac849e35afsm4077376d6.3.2026.04.09.11.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:56:34 -0700 (PDT)
Message-ID: <874d1114-b742-4351-b25a-4521e1f8f6e0@columbia.edu>
Date: Thu, 9 Apr 2026 14:56:32 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v5 0/3] block: enable RWF_DONTCACHE for block devices
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
References: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
 <addM6bkKKtoMvDIG@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <addM6bkKKtoMvDIG@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=CvKPtH4D c=1 sm=1 tr=0 ts=69d7f664 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=RFpAoTwO7tzpE9r8PTiuXw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=cYlWaDRCFYRnH0kQEVgA:9 a=QEXdDO2ut3YA:10 a=QYH75iMubAgA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: KbZvN9Tx0kEVGKwiBdv0CooKmtzM8q6M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE3MyBTYWx0ZWRfX3JJB5JwxOKK+
 gccMEKhOLi8OeILoIAULbc5ZoOJD8lcDGF0R80Gl9XK1Dw6tAnITimI5hobD01qjYOdXzTqG+nH
 gbjcA88zphd2E6d/zV797kRMMsd+/gqxhTWZlcsBOvzIt3R5X1fW+t5dO5OUZPFLwBeSvmuxrHN
 l9YdF+Nb3sjqXU3Pcsu89QU79LqTkuYLYm6DK21T7XCCH/lJndeyi31EJ5ui1kTv6vUwWSxaNho
 BYF3hlVfwwX3Q11fCkzCluvftg4JPIEZIUoh2RMvQvlTCm2FMdKUhVc+rcLsack/igUF20gWm+a
 QR6KI6J2/C4s4hlscuzkiU7ehmULveB4ARfuKtAktHegyGwj9oGUaw14VMoFV94SlLdWArjSczL
 Ej1XNHi3scDg1hcFgiYS01zjaNeuIkCpvfZywbwCQSXK3bnykzQLGCpJoUXvmrJ+pGiOtBw+8JR
 oOSyDGodr2PuSC4mh7w==
X-Proofpoint-GUID: KbZvN9Tx0kEVGKwiBdv0CooKmtzM8q6M
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11754
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 suspectscore=0 bulkscore=10 lowpriorityscore=10
 clxscore=1015 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604090173
X-Rspamd-Server: rspam12
X-Stat-Signature: nawp3x3echwboe1gu4b17sbbir5yeiwq
X-Rspamd-Queue-Id: 414C3100006
X-Rspam-User: 
X-HE-Tag: 1775760997-527755
X-HE-Meta: U2FsdGVkX18WjHrFyzPoULjjDQi+8MUgjNdU61Hh1Dzz7hxJkYNubzyjhxx7EaY8IMDGOeeAIOEl5HZ9+CzmxZ4Kav9RbpzV3doBTY6jfYzrTrKzuB2rTzjkz0zE+sFxgUqmkfdUoCF50XD4Z3ZY2xcD0YLvIh3ir0ZX0EniphRgr0vgPKCL0SbBEChC3cpFGNIw6c+6bmWbU8dlmUJ12FWll3krn9VgUyhz8Ld2gW3qUCk69UFOdOQMO9KUyARStjHWzIASWWCgQOgY4UTFwHp3xIcuT8MYMcM//EPq26tl8hVZtRm88ScG9IQ3J6f51iF2tC0IqZ29FOBXlw0A+NQ9r4esy6QqiwK9OxgaTrdht/ICoNzXDwDg5YKOwgd2kNN8zB+8jumpT+a05JbKC1n0LPEXuYIcZzEPlj60//Z2mb/hhInjR1unfmJ5Ki6v0ziebqiVEkpK8MdmkyAqUdz223xFLvg2vQuWwpqIqaWdxyNCJtvGNVsEQTahUPgY8Ew1A/VOb7XkkPlZYy6hgGYTHsKk/NCnuVLOsCHA1y5GlZ1BxATRgs0yvUIMX+MLdy8MH6o8uV9IIa8vS5WWNP1PLtt9QNVV55n3Bm5yJO0pddWU/ZcNeaRThVL5Fe1JYYQeGYL+kB7byLZjxQ4JMnidoLwRCWNewRmZk/kEZn76OudHK8hy24SyfPYXqsfKzP7xdYJpO6MrUsJXQ1uLXqTN5VuDAv+ZN9fSepYAZpHcU/L5L4HT3qJ1DJbLzDaHZfvES+F7dqhRHetCkzlEGWAcR7xf5F12fSu/wsCjylsK4sGLi7msa2pKcMyiABGqimBt7KSrkhzxJDK+qBoe1qlwPE0Kxvme4T3NNwWruJZUF8xveF8mTjVJg+/8ITwO556+bwpq/4Usb96CCfnCvUidBzfWlSNN91E1jwVU2hHRlv5axPoLkRnXoy0Lk/NWV3FcUTLVxNqMfKbtYMe
 lo1purQ4
 KIIqiE/QWpYnjR3/JZIF2QgiTRTLXlLBxO7LsfrbeUjlvEupjqxOfQqtU16cprFzb+VTqhAmXxSjErUS8Eu6KO20xbR0GcdQhtgFKxPXznY7Xk98XEKm2iGQaguo+ffgN/u4MQVlvPgXtDiMiKhc0EGyEPsyJgSMaDd3W9j9MJd0eVHVXkxTC/ON9Mzqvq15CTw5cdaYCEvB5xjealMLjhTAFhdQ87wXPyvwDbj2sQ8bg3zjMeIf+ui55gZHQClt+pKlz0ziNt0bqnjE6ZS5SAmOYNR+HY4VJDuqarmdaSRqn4gaxRLd6LTQBYevI5tZhwwVDa+abLn0sDyuisSVYol/1G3Vvx+ln5rG9tl4YaBhg9n4BpEbYvaLnkdpgnzeIcMlel1C7jUWk9sCygCtCCaMMb8YcRZ+ZvvxwYfNZuqtkTK9h940/sBMwkVl6eIFrMOZxZEA7zI17Zo2Za5I43Rh2KGAycIy7/WL08Mr3IpiItYpk9A81bP3y2ZCVvatXF0sNkOqXrZtEacFACXcfgQFToUb2t2ksOgZ0xNrMquC6b24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 2:53 AM, Christoph Hellwig wrote:
> What tree is this against?  I tried Jens' for-next and for-7.1/block
> trees, linux-next and current mainline and it does not apply to any
> of them.

Sorry about that -- I had previously based this on an earlier rc and forgot
to rebase. For the next iteration, is there a preferred tree to rebase
onto? I see you rebased this on linux-next.


