Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21268606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=ut6AC4sr;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=L2c0DFps
Received: by kanga.kvack.org (Postfix)
	id 2C3C46B05B2; Thu, 29 Oct 2026 11:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 271EF6B05BD; Thu, 29 Oct 2026 11:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188906B05BE; Thu, 29 Oct 2026 11:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E42CD6B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:05:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A91CFA03FF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:05:09 +0000 (UTC)
X-FDA: 85375986738.12.2B9AA4F
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id CA7D440015
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:05:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ut6AC4sr;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=L2c0DFps;
	spf=pass (imf07.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793286307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vdl3zVyVjBZWDK1aeLeEcxRGnowINUoX/w7iRIrrcs8=;
	b=BfLOtQOaOQQnu88nxRbcxn9+dntGYxjD2an2YWaTOMZNnCj0Roz4KTyu2qjT10MI9+/MqK
	DrChlNWvCEWzY8brO0/UJpjU3+HBI25hXHPk7myE2+/b6oUGlUhYe3RN9NrAadkvLK6/La
	lspC4XuaaJmt8tmthaa7jigQn3Kz9II=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793286307;
	b=Y3VSH/5IVhzKZm5c2O+ePV5+TIC/jl3vfuGQz+nOyv0NMDFcCZ6X6PtiMpbTmXe9DLjlH5
	LMBWjHk3dEcKpBuadQFv2nSq/WWQtmIaJFVcfwevcF04DsNKJn2mMNl4AWyVJIkqvQUBq8
	iy8qfXpRBRxXlrtZgv+U/ea/Pq6pjjE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ut6AC4sr;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=L2c0DFps;
	spf=pass (imf07.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TF0CRF2979274
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:05:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=vdl3
	zVyVjBZWDK1aeLeEcxRGnowINUoX/w7iRIrrcs8=; b=ut6AC4srs2Ls6ntSteUU
	tMeoOU5PB/5JAsOrBCD/1y8thr7bVXPn/20RI2WPzj0O6pD8NyRoAbDtJjuEIvqM
	hztuZCo3eTFcwdNMYw4C68qn5soZMC4gxRNKfOW7HLwpvmGg6OtjCHRxzsyYePY0
	BxuEG4DCxmAZ9XMY+ul3ynMCQzxqn60tBRssboT1sVp9DmHM3LS1ygQPJr4DcqfY
	jjIf4UxOegCQlwFTCP1hIIQ5Tcf9f1le3eNKO45azU0q/fR2orVSKEwl1w86AoJT
	zyKj/JkEGGZsOZZpuxTpSUuZW2+qi07SapJBkBeGy1pGc3kGHEKUrMdgAzttXrkU
	1A==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hkqxv5fcn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:05:05 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91c046843f1so34403446d6.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793286304; x=1793891104; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vdl3zVyVjBZWDK1aeLeEcxRGnowINUoX/w7iRIrrcs8=;
        b=L2c0DFpss+/yj6BVTPP8KdzksnQ+rTkiyclD/cg+cgHE5IAjf8tZa1SCiyVFYJbi7i
         +XsQ1sP8AIixnOJBMBwPgUPZQhYCuQPoANl8x2h1vRrnG4zqXonlzrUktuoMYfBJKnvS
         FTwJ52D38/862IUOqWA884WiNmWUR3ymPIZnXLGJfahazwPy7cmVa3cmEekCN7x/3iGK
         p+GjfmdRQOFY502onBS68HM26shhLOY2WMYdtfUBdBL672ih9kfbGKaPKmpRRJVnP5Cp
         7jaFbG/tiy/KlAWsmoPhI1s+0dHlnvB93kL8v1+5J9maMj+29CeKBZQ0C9AeKqTvOOAZ
         wC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793286304; x=1793891104;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vdl3zVyVjBZWDK1aeLeEcxRGnowINUoX/w7iRIrrcs8=;
        b=gefgtmUg1denUVUM7H5JS9ktmflz7RAEElG7jjRmmX0AIJOlsfEkB3BRaEE9tDHvj6
         MDFrer6z4t6cZh89vE1WpnrobOiFka+YdDa2AGfqP21utAs5X835rjPus+FuqJYndbeE
         QW3fOIt3q1TS8EQuxOVXCvMc+wlHwzAFAglQB9EgnNytoZVY0S+XPxGDfwDoUXlJ9dOx
         DL3ObLjaFqBfIS8vL/et4xwV/sI8IBkMT9i1KIJAOtxMWKWxKCcDJ3lnqxrbuugUdbLb
         z8xU9EeCI/S5dTmpqboXKYp6jynvjUpBn9FkP+o9GbjsFo/1O0dR0kqhR8CpSSGjf+Kc
         C3eA==
X-Forwarded-Encrypted: i=1; AKwUvBwtixz3YHky3Y7Tyalf27X7/iTrZqleL8rXXYsNa2cADfyfR1Ol88Dy2Cu2K2n/G/JCKh63w+8C1A==@kvack.org
X-Gm-Message-State: AFq9FYL2PL4OW/2zZcZYDNGzb17jtAAFh2Fcu5Iy8nvZmGK3IymkqIu0
	LG/jmI7li4d/yMsQ4ryJszUiprBsrdjmyPJufmqaeSt8RzqInNZkNRXsE2EpBpF1xvsQYa6+NxI
	GHcBV7gV9FoCmd7C2JelJOTKlVF0nNaKiIqCXQc3MjO4EkpC0NlzD7pOe
X-Gm-Gg: AYBFou0pd2dcyj1qZ0ZyqOo/lvHwrYMeEt3gv1hNn8Ia5Xy4FHCoTpVCeZV7Jtjn2eQ
	mKRByeUnBqshwvJ9hdGxbsQyxkO8cNU0ehy/BTL13kCQNtLR0FqPaVm7BDFdKZViEHcHz1D7vpU
	k05BAOm6KGcQvIaB3fPx5zqx99xNXRQ1RWdP2VseypYrKNnbX0cPjwLX+hHRv8k7yWSG2X48yx4
	XHgvXdgJQh0lCeGQktfHXddG3WjjicTO3eW6U948tmte2Cmn7gYaQIS4Gm7m7jz6AXZHPWX0feg
	lxKr1kEg5MZJqLD0a5epm4Ed8HxIGHC9lxLD57D0QAvmh28GUKz9m3UkPVn3YU5fMSywpkwWLMs
	P6xDIhmKak9M9QODr+EXfYvXJzHzuHkZKrTrOa/yzqSPspHijaGG8ktS3B/96UfY0GO/KSeJm8R
	Sz8GORiVJgX6Vqm3pljh9gifCKZy26n4QPnlLq7C7XbgVhHJ6VVz/gAkvTpUdPuxjEP+MKKoBTv
	kjUSujzFvTbhibmsTJfvH3Wu+xtzKVaeTQys4bpI7Qyw5nPW2ybu4djOIKZF9YAJ+w=
X-Received: by 2002:a05:6214:ccf:b0:91c:524:465d with SMTP id 6a1803df08f44-91c7cf468acmr86813356d6.9.1793286304111;
        Thu, 29 Oct 2026 08:05:04 -0700 (PDT)
X-Received: by 2002:a05:6214:ccf:b0:91c:524:465d with SMTP id 6a1803df08f44-91c7cf468acmr86812696d6.9.1793286303616;
        Thu, 29 Oct 2026 08:05:03 -0700 (PDT)
Received: from [10.206.158.158] ([129.236.230.185])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca29091e0sm22536d6.7.2026.10.29.08.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 08:05:03 -0700 (PDT)
Message-ID: <5537eacc-0884-4b05-9634-16dff0eef69b@columbia.edu>
Date: Thu, 29 Oct 2026 11:05:02 -0400
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] exit: use READ_ONCE() to read mm->owner
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Christian Brauner <brauner@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu
References: <20261027-kcsan-exit-v1-1-7c0429a29bc0@columbia.edu>
 <20261028235404.2a24aa50c06556eaf77a033b@linux-foundation.org>
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <20261028235404.2a24aa50c06556eaf77a033b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA1OSBTYWx0ZWRfX6bJDO3X7LBMj
 FsnfsF4T9kU4IRFDSORtRPlU/g1wG3G9QjLJCaiTcEra0DtPTV0kyczcmoacWER+lpLpZ/oupOJ
 oUK2rJzZr1fd5SfdRY+pT0MbKR8BQ+oCWYCT7NUJDC89vgsZw94HkiUsD/69nMZLgphtb1mphfs
 RcI0mJkrxGveec8tMgR8lQGJTnmGXwyxosBTpiDG3FZg6+Qg0QPabJEyVfIQHxjdF6UF3vF0prC
 kfKeyMeuFWSZgKj/riUQGH+M2+D3evvr1lyP8AevHmeUkgNk+TzcFea7+stGDY1yaZm7I56iZu1
 E0VNJhxWDj6tTh+vB3yRIaOSkZ172H7cEC0yJLZvqihknXjQ2nkF+mZPsBMspbkqbsCCyI00YM1
 7U4g000M5JGW2i8xDmx2A0N3G52Q0h/k4btz6MUQrk3iZWdviQSDurUpzoxtvL3HvtLPlFI4ebY
 mAMYl2hmyXBCkok0LnQ==
X-Authority-Analysis: v=2.4 cv=M5XYuCws c=1 sm=1 tr=0 ts=6ae360a1 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=s68UaERRFoarOrKl7kvqFw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=VwQbUJbxAAAA:8 a=5dIJZD-rmGDQ5m4RUCsA:9 a=QEXdDO2ut3YA:10
 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA1OSBTYWx0ZWRfXz6Fbf/1pd8bN
 /Y6kNbgRoC1qppWGqozbCQkM2Lw6EzyJh8sgzHYikeMz1u1c6tqURfVEXQZPhksQHNS7U61713Q
 KvEmDDVYuVrJqidfaM+tfCo8GU3up6yK8+IPxm0zbEyJvS6HS6ER
X-Proofpoint-ORIG-GUID: g1T1vKoWtswYbca0AqkxCD73tNMzf_Ns
X-Proofpoint-GUID: g1T1vKoWtswYbca0AqkxCD73tNMzf_Ns
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11949
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 impostorscore=10 phishscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=10 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290059
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CA7D440015
X-Stat-Signature: b9qxz8yu5eft5qnyc1dg6qqjx5x41ntk
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793286306-171865
X-HE-Meta: U2FsdGVkX1/ew+0k06kRa/DPH/jFl3eRSKdTK9/GfPkkhBEmGbsY2yBwWDVJ0w7NhcVtWGClK/G4uWKoj3rdLIPhl1gTr/6C1A72QPZQtpRjZO2WS1HSU0acWsUFP/T9w5kQ9h9WPcSrjoZFHSyq0+miKH0bMrmDwhpRf/afoR4RoRgMqUn3BUsaHOmIJAPNnR2cGw0H1LHJ3h0F6ljsH51FQ23j05gwjghlP60On+MmR4d382Suan6rIS4ykYKk6F+WQhjpVF6+9ppKqEU6uDk+VSH5VTnt9WC1YuzoSwB1KL0W3T3i5T7s/XWmrkf3XyyyNL0saoSElTg6U2TdskTPgMsfoyew+8n/4JRBjF4z3Si1y2tr7y8EqLbGxXCJASZTpWpE6u2TeN6Bs9WcFo6ok0qV7bCtfrzN/J2zVqEXtekgervSgRoJnL5Xf3KiPx8gUzTgKHNOlowRa9YsQ2AiUUOXjfUjL/RhyrZHbRbTEbEjshl1yzRckVDw9p+qYvstI/5UP0M2yuN6//sxBWELqPr7/bTkrAq35lvX04VRPQUw04T3WaV9pCs4ZpT/aQvGX0DkrWJPNPe31RRZmtN9LzF2zrdgmZcJNaCtkrNeM1PfubyXNT6zSxkjyDjxHBudZ53TFJAGHaIUhmY9DkkFp9ljrCeYKDw6iOuJBv8PiRWychaH0l/+Veu3HiNWl0BpM6HOEF453gcc6bDaG2nuuvDqpHI5L8HfBCFQmGbTcuZ065n3mVgvV+9c3Fw965kazkluADVgzLIybvkGHLyF7gPUmoOtzZuCglXwgM0/K086Vl6AyzklA/N170e6NQktTvlnTOCZlK6cofYfyXKEiQyMNg1rWvkO1iRHKU+yww42fKodnLa0dDBrPNkKMsIJBXpW1LT2WlTZyhXUG0+F9Z8im6wswlHOK+nFhMKmijVLi6l7UilxVeTc4DZwuudC/oewcFBjyQdrH9d
 Yc0WA+I/
 dCsWJL39rwP/YPGkQkIylcUssa0W4siR/0J7X4hCac7ImYjCrs8TbtQp/uJuCwC/8FfDcL1hRIjDUD6XAjSmABFGYqKhSdsQsxDTpb8MqJe1bqTLFqZLaXygvQ4z0HdPFd+SSNPqPd5Pu2SRF1l/1tRXl/+HZwEONHhzMe/vnYwuFYjAP0eH+Jh1glmiXoXwPY+M6tn3vwTyxQUVZo0PfH0ld3b5EaXuaj20HKOEQJ2yWeCkvSWq2Xu+NXFTTxmiSZyNBPkHtETyqvTbRhTKEhhfRVNeoa9/twHZxuKEz6VBfE3eQyReTa4yN6BS3ivCugVUhTonzdrEUpKD+FbiAZ9/Q+rldqmtSFIUf3/5xApEDcKC8LOGOq9ggimR9X2lMcEO51adqmZG52Q5klcgGIIs6VchrwDKX1jnokHW3ZBcgIgtBwDaYRZeq9f/rY/5IVnlaaQQSocxBRDErZ3rpxh7iaPeEz+odhcFYVHnyDIvsn7g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/29/26 2:54 AM, Andrew Morton wrote:
> We don't want older kernels doing this either, so I suggest
> 
> Fixes: cf475ad28ac3 ("cgroups: add an owner to the mm_struct")
> Cc: <stable$vger.kernel.org>

Sounds good to me, thanks. Should I send a v2 with these tags or will
you add them when you apply it?

Mani

