Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA1D910F9969
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 19:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF5666B0005; Wed,  8 Apr 2026 15:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6D46B0088; Wed,  8 Apr 2026 15:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94FF6B0089; Wed,  8 Apr 2026 15:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBBCB6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:35:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C42416021F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:35:59 +0000 (UTC)
X-FDA: 84636394038.10.F582E9C
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9B34F2000C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:35:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Bh99876D;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775676956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4LGLk/CDNL83hlgUo8iXk9zFAF5PxXFc3V0NN89y0o=;
	b=XTr+pUG8eMRZoFyGJrn2MG61S4eV3Hk0g5pC0nfpCOJHJaBFsAnNjIKZdWCMcfOGi9dves
	eMGlUOp+dM+U+C+1NTOGQ8VcIw3YyLSI7x3edjCF69oHES8uK55Fa6u4IwlQdNDM3s/StF
	1tPMlP78xDyhFatGCeUU4SCJdQB+bN8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775676957; a=rsa-sha256;
	cv=none;
	b=tVgRsENz6r8EvB3nsfQITy/rR0pu6iPDUA+rilvbbDE58X3TClSZ9TQbYaGXjXzCmdkYHP
	oKH3oVPHZ0ZGgvnbKC+AXidz3eR3n+GN/e01L5rBPCKe81Z7+UFjxk06Cb7ja666BK7oQX
	kItYlY90PugBEYdFOUzcYTY3jd88ai0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Bh99876D;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638JNAkd1556740
	for <linux-mm@kvack.org>; Wed, 8 Apr 2026 15:35:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=E4LG
	Lk/CDNL83hlgUo8iXk9zFAF5PxXFc3V0NN89y0o=; b=Bh99876DlThe4BSrmYhz
	BT49B/aYdNpnd5iXtmahdBmWQKp/nLM7EjQidIcVzMQu0zTcB9WhKQoUhcQ56heK
	5zV2ZTddiaC6RxhQMa/3ecHH0Fzml6zO4IzVbRJpnOjJvzciBUaBCwXgbtXVeneK
	FP8Xt+w6gyqpBzKGjC7/1oEVDvOHhqumfe7LK/Evxpw9i8BV/Ak2Ti10fNw+JAlH
	K10VNlfSBV4KFxb6JDcQUQ+uB/at25i24L1wPVi51/y+nQY78gxCvOr5ponpRO2s
	LXoItPMPFOhAkpFIu+qalKnqsA0rBuc8xR5faWwr1DuNe9DlvITzCPq2Bak+N1Tj
	Zg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3nq4us-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Apr 2026 15:35:55 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50b4b81c632so4501611cf.1
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 12:35:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775676954; x=1776281754;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E4LGLk/CDNL83hlgUo8iXk9zFAF5PxXFc3V0NN89y0o=;
        b=VSHo4gGiibxy5ylt3EeV7pfHBis3jY8SPU0kFH/ES/op1n8rF9LDp+n/RZyaiZ32Cc
         s/7ZCXv7q/7U/1sswRlQ5z2gCRhmLhqt4d6oHqWMGNlmhcNNqYYQqqNJ58/dFBy8mr0v
         aD8/utdYOADWk6/LC7suoFYSKFD80DaoSRVE6famNNUZBUX3VWAcLQ6MEmlFEb9ne0w7
         1uQRNcuznKITKURC+BpqNYNXJZUmomkfpjna6Xq0KImVa5nIAmRKCaqjykpVoQ1ZlVZO
         z6mA9QLrkepJ3zUKF2fnAHY9pEGWHUOO/bWrW0WNorv7Z8q9nQ4lMhWmjEkoydqVFZ7Z
         izkg==
X-Forwarded-Encrypted: i=1; AJvYcCWJaUxtQL0CcjA0XY5vGxwdXf3XWUQIWa4WW2XPfkaL9TwdUlQ9O6bY+tlPUm7QNT5opmVLGa3LJg==@kvack.org
X-Gm-Message-State: AOJu0Yyqf5THtUrmKPrnVYQtoFiLBibjmHmiBuX1XPuLi1ZYpmhbZnH/
	d0ycMurfuLrdqrfw1bjgdAusO51C+4W3QZMC/pfsJdYxi45hLCHkjJ7hoEuEUXt1IZsdNIXSU6o
	VoTcxvGwQIF1FJN0fK3E6N8hIvfZP85nUuGCz77xXiXquoo0P
X-Gm-Gg: AeBDievbKDB0qiAupOEiFdKgx2ATshuYujyA7w3G7wF6gB0D4T7SkP4srkci0gV46uQ
	JY7xfCd7svFo1sEqtz44UDGT/jLUq3cDve0339g0sRgzhmr3rEJq8gxuuSQW6VcshGGJeT5uAQz
	rPlby36h9Z1Hv+oUjHN4RpH8juUXliWLokVGNFdOC3gzpurXp62qSIGi9vnkV9SDl/0/I1OvY9J
	x83PMB5C2E6yQN00RTImbSM6sk5TXUPerozNguL1WYYdgLCKLVXtqHCff4ts6HX7zXnkuMNTGbW
	2gMp5Yi3Th0zmTvuvrSLzkdTFMFyF1IOGgMM+hT3CW0EUvZltpV3lEXG8rK/xrhnSD0WG4FZC0L
	3uQylQtLy7SwzdN0ly8VWGmo++NBvAhj+yyMBjnaO
X-Received: by 2002:ac8:5908:0:b0:50d:a987:89b2 with SMTP id d75a77b69052e-50da98798fdmr100185611cf.31.1775676954058;
        Wed, 08 Apr 2026 12:35:54 -0700 (PDT)
X-Received: by 2002:ac8:5908:0:b0:50d:a987:89b2 with SMTP id d75a77b69052e-50da98798fdmr100185051cf.31.1775676953617;
        Wed, 08 Apr 2026 12:35:53 -0700 (PDT)
Received: from [192.168.129.206] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d82afc7d5sm126128111cf.30.2026.04.08.12.35.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 12:35:52 -0700 (PDT)
Message-ID: <52016a51-58c7-41eb-8824-3c133aab90b2@columbia.edu>
Date: Wed, 8 Apr 2026 15:35:52 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
 <acYdOOpo51xrzNBg@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <acYdOOpo51xrzNBg@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE4MyBTYWx0ZWRfX0tuEQxtesYnW
 zOzgPwQZroQdpIUW8SKEvBUm4HnIOf/R24hmPJ+Bzm3Bz3gCLaLC5U4DxCCxfXVvPFM4iMzZTzn
 W7oh+Aa9kdeYwMfJL9W5+wNs5ZxLNXtI5A8m/0M6qyDSQH3poxbQHquhfTdchpUDigYynRl+THt
 hm93GPwuRAj3bIVBnFyqPGrL9Sw3UwebSqX32zoerqnkkKDZUVpZVg8CJ3ioK7iqcvQxz7GF+yf
 bl1zZymSwzScU6ZKlpgwd6mhl57nwADSAK98klkH2rjNVQAsGDgDiz20FQU4MdnVzZG+kjHnZz5
 lW7kwdwX+W+etWfWDVzkd2TQHUA3ZALowr9S7Rk9pt+8iedBW24ODhoxQvsee/vVZuER5SyX/jn
 1juLEJDLzFbldH8Sh3M2KvnBhcRUxKMuYukExe/SDEVgWYGC04xwo7DcmUUCsViCV4Mc/GY+rnX
 IP7jengN51jHtT0h0kw==
X-Proofpoint-GUID: DJiZzmJ3w2mM0Aw6vcHp11DEigijhHgw
X-Authority-Analysis: v=2.4 cv=BeHoFLt2 c=1 sm=1 tr=0 ts=69d6ae1b cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=h9G_tkD_DQui4U1ChFoA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: DJiZzmJ3w2mM0Aw6vcHp11DEigijhHgw
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=10 adultscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 lowpriorityscore=10 clxscore=1015 impostorscore=10 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080183
X-Rspamd-Queue-Id: 9B34F2000C
X-Stat-Signature: u6aok5c8e6yh4th1rwdjgmagg1sfn5a4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775676956-507261
X-HE-Meta: U2FsdGVkX18QKCKs/g83Wv4DLVF3zVtE04QPfw2Dsd44XIPTeDmnrfMXJe7PaTlannzalbYeyx1pxHf91FPPfgK/b1kMOqIMfAFIb6iZG5AxVeWECpvnhPYuhHa8vahN2uU/i0+nfSjm03hKcfrO7WX4dgKW0VWVEq6PdScTJJ/TXrRVOTWydEwIo9sQUNrkxHjZIkP7JrnfXpc8Nu5i48G0EDSzBNVKDKddMDbxgyXODfqFVWwRpMntDXPuASilhX2Go0MhiOj3Qa4Qc2a6PfBMoYY94RLjdPPvK0Gzc5NL8I1bGmICQKk6CkEgXChEJvzQ0Nu/cjgxiOnVt7f57v0ESqk3pmNHfhdgEYiRBr02Gv45ic6x8oBdMTra2syzxizmOI8rZHJlL4okmm4X5PYxWE4gikq6ixK/rM6P9pmJbncIy4x/Glxdm/BBGFNxpCtkS1uPwwAYyIbs4yqrBJtzNU/0rVJK7yoG4BhEq68vuA0Ppa+WokBJQj4XHVzDbuoZxs+ccxrPZqYhGx0dukg/c2rLEqW3nWNgRXlRncn4lx/QLuvIriw8Es0f7MAhm9VAoCANa96UzuEjo2Sit90V3dzxsU2rL6UQN8Y5ocyb/gxSkbZXbAKtgNItyrhS8GLh9A2r0Fl6SDH+z82JQGjmw9zWEQT6h4nz8Sm696B91jrRRc7En5NT/qxaEyUFsNMZsV6IyUyBHw/DZ6BuoL8yo+wgXWIWmmOArQ9ko9AokiS8GZmi9MDbWi0V4xGYhdFfsBBS8VgP6UGAt1ZF65sJAF0uXZLcMHzG4ZQR18O5vWWYW1KXPBjUGn/PuBhpqdqx9fHxCg8B9LZZSCpoAMGuBfaffsTqZxa678wGUkobTDH/D8fP0RdCywLc8Z7gAY3nVBst0VOnjoTzVx0xis8+XujaccXbzbYvvwrBb4hU7rM8N6I33YB3TTLSiX1E5vS/Y78vteXtPiw//1Q
 OKc2QIY1
 JGYoywcyVRirMOifkhaTDdeBAOrvfuindsuPFQkLJjEOL2o+0cox1b0SLfTwNxKTDjF3TvefGQnpfZGGAt7q1xFC01tjwDt8ncOTkAcHRuKpEfPUL6mTs/FoiAMAyah9mMkz8y64jkpwClagXHLjZ20plXWGhRcVtKvG7rRqRbsjChC4eAB2VoGwD5lI98wSGCqsl0/OvyIvf3rZqagl+RaRHuwQ3mu5H2lz8dRyxL7x3cGXczWBOVNuH/o2cT7h5+eWZvH2CUnOqu4hEaTQYgqIr/rZ4xex7XlarDSAupbBXq/LY32iCVx/fPro1fsPOcLTeMmiiB8OqbxOKnYXRjiBiyh8iexN2W9lx7gX2ABCPUisSHSaPTtyTFFI9CzVW1Je1jpwSrHTaCrrZHyqNA71UMX9wLWn8SNNyzsc9sXHR6+kdYdVjQ5sjuGSOVtymjYKkdwFkm8pMz7bdt6ZyFRpGXXtavDIfCfBGNQuhiMKH1alY3lrp1u1eyRs8vh3kibHqeAJX9PGsjRY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/27/26 2:01 AM, Christoph Hellwig wrote:
> On Wed, Mar 25, 2026 at 02:43:00PM -0400, Tal Zussman wrote:
>> +static void bio_complete_work_fn(struct work_struct *w)
>> +{
>> +	struct bio_complete_batch *batch;
>> +	struct bio_list list;
>> +
>> +again:
>> +	local_lock_irq(&bio_complete_batch.lock);
>> +	batch = this_cpu_ptr(&bio_complete_batch);
>> +	list = batch->list;
>> +	bio_list_init(&batch->list);
>> +	local_unlock_irq(&bio_complete_batch.lock);
>> +
>> +	while (!bio_list_empty(&list)) {
>> +		struct bio *bio = bio_list_pop(&list);
>> +		bio->bi_end_io(bio);
>> +	}
> 
> bio_list_pop already does a NULL check, so this could be:
> 
> 	while ((bio = bio_list_pop(&batch->list)))
> 		bio->bi_end_io(bio);
> 
> In fact that same pattern is repeated later, so maybe just add a helper
> for it?  But I think Dave's idea of just using a llist (and adding a
> new llist member to the bio for this) seems sensible.  Just don't forget
> the llist_reverse_order call to avoid reordering.

Will switch to llist.

>> +
>> +	local_lock_irq(&bio_complete_batch.lock);
>> +	batch = this_cpu_ptr(&bio_complete_batch);
>> +	if (!bio_list_empty(&batch->list)) {
>> +		local_unlock_irq(&bio_complete_batch.lock);
>> +
>> +		if (!need_resched())
>> +			goto again;
>> +
>> +		schedule_work_on(smp_processor_id(), &batch->work);
>> +		return;
>> +	}
>> +	local_unlock_irq(&bio_complete_batch.lock);
> 
> I don't really understand this requeue logic.  Can you explain it?

If new bios were queued while we were processing this batch, we loop back
and process them, if we don't need to reschedule. If we do need to
reschedule, we re-queue the work item and return.

>> +	schedule_work_on(smp_processor_id(), &batch->work);
> 
> We'll probably want a dedicated workqueue here to avoid deadlocks
> vs other system wq uses.
> 
>> +static int bio_complete_batch_cpu_dead(unsigned int cpu)
>> +{
>> +	struct bio_complete_batch *batch = per_cpu_ptr(&bio_complete_batch, cpu);
> 
> Overly long line.
> 

Will fix.

Thanks,
Tal


