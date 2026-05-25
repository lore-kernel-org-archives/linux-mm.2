Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9CAFCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 18:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0021E6B0088; Mon, 25 May 2026 14:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4DB6B008C; Mon, 25 May 2026 14:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE3F76B0093; Mon, 25 May 2026 14:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9D786B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:06:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63B061401A3
	for <linux-mm@kvack.org>; Mon, 25 May 2026 18:06:27 +0000 (UTC)
X-FDA: 84806722014.30.4086694
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id BB72680011
	for <linux-mm@kvack.org>; Mon, 25 May 2026 18:06:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=LDGGlSvn;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779732385; a=rsa-sha256;
	cv=none;
	b=NF1BmRca3WuMSkAfzpXuLjaguJLoh9PKho3mZTlZE4IQQeW1csAl6oqeV/pcGWxtr3FjY9
	dhlzk9TuCV4UqqzHXIIVzx+OfAMfrmJw80BP9bsmA8pakVEuBbNpsH+D43MK8xhDYsFbfb
	udWJM2KzPIujVVOAasTcwU/HngYWxwQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=LDGGlSvn;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779732385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5douZQvAFCZqdwJptJlzHlLbYqFrEBFAQblRV8bjPPI=;
	b=LmOmN7NobrXPhzgsU6BNF4Dq6W64HNbDTntxGABRjNls7400WE1giFPzh7M1E9AOaLK99x
	sIfKLmzxKOLrfcAHtvyhPJrknZQtsYF9q8eL8VUcqxw2XvqiFz17rDu3Uh1gqOKPLnXRL4
	AiKgICo7fsMXz4pelM2V2d28Aq51q/M=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64PHPPM83739995
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:06:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=5dou
	ZQvAFCZqdwJptJlzHlLbYqFrEBFAQblRV8bjPPI=; b=LDGGlSvnVwPgOU4r5HIX
	Vm5NLt1fPlF7jAwQrDVvRFtcUNaPLFY0z4vFHzF8KvXEAANZI70k+v0RcNbZ0hB0
	6g4puXZgHGEPugavputida2cXCM/mE4ZHs2PDRKSB62pgVTfHyArD0xbxdNakbXS
	KE/vTIjo9ruSIpd0EQJg/cY3nDA/83pNowZVYvqOrrSEwU5duvcgQ3009GAqfAfN
	dkEvk9SYCVk8mUvDfbJBStXJyg4S1/qMbbPEZudpe9MYTh+YK5MJleWd2E/NlDwV
	NgB4/9N3hqj83Dv+gYm9ZpQhehAs2aspWH660TK8R8F/Q7S72bwrWAZWjmePpXZ5
	qg==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4ec70hdwbp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:06:23 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8bc5ab12bb5so56466126d6.3
        for <linux-mm@kvack.org>; Mon, 25 May 2026 11:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779732382; x=1780337182;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5douZQvAFCZqdwJptJlzHlLbYqFrEBFAQblRV8bjPPI=;
        b=MubNxlq+j0wuxYvV8uVGju4aOT2J//+69MMm1fopGYq/0z9dw9LUzidmGXHLq843Hn
         MWegAUOdNXDk+V36/Ft9OfRc+XMMW/Ig4wT0+brXryC1oVplwHVZUURBc4lIorE+DS9P
         U87//ZsH4mmc8wAq6oSIUefZaGeTE4qn3z730DXvddAi5YNYGQJwT5YoXKpCla6J7Dp4
         66GM23l/Pxkco6DRppNxBY1oocUUyF/nUqtx732s2773cKxlzYZsWXezKLU+KfNnJ3UG
         C1GPpEd5w5+5aaAAdN540YXI5eryj2LY8JijYMQ0HxLtTffd7jsdDPoGGFVmmFoBEruw
         7EUQ==
X-Forwarded-Encrypted: i=1; AFNElJ/LiNADb0r7ciuDRs2nTKpMT7JPweRtxxcIxBAx+V3PcJrE4CUaH3QjlgCrWJOsK2NcLJcV/a2VEA==@kvack.org
X-Gm-Message-State: AOJu0YxArEhPREADcp3eGSM1eHvy3JGRI9VCwKMqJv0TNEQQUKztgLaA
	UIhfKX6CrJXFTOeMO7Csq1gfl6gN/Mpx88l4nqDds5rsihwejesAHTsYbqjUMeKyHIZ5m/MEdOZ
	4IxRZyjmRDlFZW5wABPzMM3zSLcKDykRu8vvamtz9soaYbpjg
X-Gm-Gg: Acq92OF8+m8Thrkp8sCTj1X2aVnGvw9cMUnRS+8PZKn5P+exEvJ8mSZ/065gT2gWD5B
	+akAG/Q5Zpsbj9exx9j17MxqAoeSJSt5GZcdtn4xPKSeSCJ7is1V11YcZek/ozr1fSZOQNu57yB
	ySw1o5u3lLNcm2z8/SBZ/4L91r9JdE9uJkBsOLJ3mbUxzJijEzdK3lBhgAIpeFKF6kYDHsYnmFc
	5PHZ4VF8yBFRA85lPPDUrar7/fAm/psqlAGhQDQj/kLpIr/E02vjcU55uhtOKq7Gqg2lZOJsW43
	gbHRGpCZbAQ0yNGFFXW00kbXFhHSM7EM1fdkjAKCXeoGzt2W+YqRd3BFvwiHs/Se/I3R/GupuCf
	FCiViyhm6Da478pf9317takadqzqeMMJ5mqCUrgHEx8nZq5cDZSXICB41tM5eLc8bOjymeC0=
X-Received: by 2002:a05:6214:5a03:b0:8b1:f8fe:507b with SMTP id 6a1803df08f44-8cc7b540e74mr240941626d6.19.1779732382466;
        Mon, 25 May 2026 11:06:22 -0700 (PDT)
X-Received: by 2002:a05:6214:5a03:b0:8b1:f8fe:507b with SMTP id 6a1803df08f44-8cc7b540e74mr240941006d6.19.1779732381967;
        Mon, 25 May 2026 11:06:21 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc812e657csm127335106d6.24.2026.05.25.11.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 11:06:21 -0700 (PDT)
Message-ID: <dcba754e-1c29-402a-980c-f9fe3e57a0a1@columbia.edu>
Date: Mon, 25 May 2026 14:06:19 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/4] block: enable RWF_DONTCACHE for block devices
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
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-4-782e2fa7477b@columbia.edu>
 <f8d509c7-c0c0-4196-9a82-a6f8ae24ffc2@columbia.edu>
 <ahPejprWrEjsh7aC@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <ahPejprWrEjsh7aC@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: E4W7i4YQX4vrcGhkphlMGwqxBY1QQeDA
X-Proofpoint-GUID: E4W7i4YQX4vrcGhkphlMGwqxBY1QQeDA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDE4MSBTYWx0ZWRfX1k1u4QSuWD6m
 pxYZ6Rvw5WVvDkL1oOWFzBeYXs/cJsLTHo9RJAt0BGfNcSKEspQbH0Xczq944Rz6R3LLi2JQ91z
 tAW4DNsgH/Xc5L3KBmR+0LXkqf944JhgnQ3zTvhh08ABLe7Nf96cYsz0X0bXt3cr0HgIKFY3VzC
 6kLj78OKTHa68XrfuNqYLJ+d4O3jeKikxrEeomftQflPoPNNb/Ooyfdf6WxQqPAG458VdXpvUhM
 ecZN3b008Hgu8onhaaUSr5n6C13+sElYDAsTUJKQJ3fIUs2ogD72AeKhhwDixmxy0TKH99C2Cln
 1kUvIpDXm5uNC1HZf9AZptPYRXnDtiiB1PsLXzKq2t1gM7R+svoANf67s35Dmh9AosOqcEjkuro
 d/7mrShvxA6W45LDCMd5rDaCT5v7e023fE9oAqtck3WyQFPsgdyImp1YwzAGM7QRFRkCgFeEZqo
 w9b7MXEVqcP3NIMG9Rg==
X-Authority-Analysis: v=2.4 cv=Ztvd7d7G c=1 sm=1 tr=0 ts=6a148f9f cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=V2gEwdiY8GOwGPefXFgA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11797
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 bulkscore=10 phishscore=0 malwarescore=0 suspectscore=0
 spamscore=0 lowpriorityscore=10 clxscore=1015 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605250181
X-Rspam-User: 
X-Rspamd-Queue-Id: BB72680011
X-Rspamd-Server: rspam03
X-Stat-Signature: 5td86f3iitt5zojyaxjqc39tdbwyfjgy
X-HE-Tag: 1779732384-841562
X-HE-Meta: U2FsdGVkX1+RbAmLE6s9wxSjv9i6Pwy7u3sFStDDfAUYL0JIfV2ncnmFpsNEv7eaVP/Km9JHarrsYJ1eexNaaYo2P75EVFrHmSSVQV/kkqO0M7VVWxgGt75rBcPRTkxXrvQJ1ZxtUND5YTemrqITlDK5w0Ek8UTx/FOxI+lolnQGquiz526yNX2mh/Kgng1ZJ2HXbawtPuEVpgLhgz3qCY1FPjys3tcKs+o2zwf/ubyOiJ28iCAq5KcQ0fHKmaY1lN5yyPe6ET5CivR2m1eDp9bnQYufRsHQw1BcN1iM7Xrb7qtbACDDD/PzgIXfxYvLCqQPxQazsnJDIXQ+A2GXnrCqOzYwVWii68lLAPob82OT1BQZzPemvSETBYmUyLM5WQYxbRCSH+m5wlvK0b0iALigE9jZzpUhz+uW8dxDKP6/qpCbqDr3lbwmwbxV5Lbt6MN0FYAy5TecfPICf+pvAmStLOAtg51ytv6sdDIU5eD7nQtBaOw+6nSshQNKpXzw0ATQNDBtw/qOdwW67OesPqlkftuLAQiXhxWTRUTqBwUT5oZyxMpwJh79Ya1h26xNWKKps/pTYIkDzq2CsL3p3MjYpx/tGsDAoKfEgxrF6B0SG5FwnUXcYPiNcRkOKvmFEQjsGvsOJ0reo8tv/j19SdKKh1ZZkqcz1Rjw4HOYfUw7bg8tWsABZ5UVUNfNKF7ziFjKpXlkzAc+keqbDEfUQxziYzV+O4aNWtnoNOLNZQsnNdNyUvVOTAU+xsKBqhHW2lYzqO1ZrGYDMReo2f5twohyT7rjv34CgYOUmQJlJOLOe4SjxO/+v90+EYzSEb1iaTPr5+CFRXdfR35dtn1XAvCd2chaNTkG/bEcbvvOXHeFK1BL4DSr+/jVpRYk3R9E4A6BXea+kA1LrQzVQQFSKtG3urZnSG+Ec2wrBGQeFdbxDOVq+So9Oz+dSCINGHn4yetIWz9hujXYHp3/Uux
 W7SvTIpw
 cgaIqoVoC41L3QqccOBGW1LKbUMs2BjAm4TsYG3SIwUTv8/ZUAkkJnuEdgdS6w9RsuJlG+cu126BBJ2DHS+x/AIP70cuga+W6T7OAGncukd200AMSjrNCzUcu7Op5oWTZ1CSHsTlyQtDm1BsFoID4QXx33IDTZKzWBLmBNDRe/PvB5jmh/6atx+K4SbclosuFY2Jz1fWvcpNgGyjuK5kmscdzhkKBpgNfxz+WLaO/VtovE59DYQ4UkhcuM2UUsAVcpAXFcwhLKLDkHd27EwScsE6BnOT+AZZH2BZ6D9+s9jL+nLnGHXbshzRf9KOlQbcovjInFog+AK43YF59IxJtj8kXCs+ZYa6KvZaCfz0b5aPfC9Ez2UPs+8fWpbg1xHXFzAQX4hQpeC8Ymk4yxlYW/4nZdq105WJ4MJ5uy9LLJNykhidv/M5rnQZVjUqVFf+6Y4/2GPJB98QhYdXU9w6usak3FiFWLzamInk0JlJ8CdcYmGcgY+NLC/Z/iFue3C4/c8JKbNZxsZKiU7c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 1:30 AM, Christoph Hellwig wrote:
> On Fri, May 22, 2026 at 07:17:15PM -0400, Tal Zussman wrote:
>> A: So this actually seems legit... doesn't look like anything actually calls 
>> blkdev_write_begin() or blkdev_write_end(), unless I'm missing something.
>> block_write_begin_iocb() usage seems necessary for bh-based filesystems, but
>> block devices seem to use iomap for writes unconditionally.
> 
> Yes.  Maybe send a separate patch to remove these now unused methods?
> Or I could do that since I forgot to remove them when I should have.
> 

I'll send a patch. I'll also drop the block_write_begin_iocb() change from this
series, as it becomes unused.

