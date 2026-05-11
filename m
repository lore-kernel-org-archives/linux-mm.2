Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06FF3CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:15:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BA056B00BA; Mon, 11 May 2026 14:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B156B00BC; Mon, 11 May 2026 14:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5817D6B00BD; Mon, 11 May 2026 14:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 499446B00BA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:15:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01DC81C0118
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:15:47 +0000 (UTC)
X-FDA: 84755942376.05.8534125
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 64C82C0013
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:15:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ZnvkrCI7;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778523345; a=rsa-sha256;
	cv=none;
	b=MTtEKNCptEasW8pYqxe7jIgb3jImXsjobEhAhbglVYskUGrOQiHC/3qwJyJgPnJvmaeT28
	G4epHbpsOdpIUzG1dy5xKzk2brRiP0kHAER+rrsyBiwSKixUdW5ZHFzjdBg4Pnja8jWg6o
	259g82Z5bCYfwVPDzD39MDt7DSFPpnQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ZnvkrCI7;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778523345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nNMh459Qb0NBOZf/rMrLKlp+eY8nirwVRRGfS/oMrYc=;
	b=wPfRpa6ZdrfwIPBGplIQdlH0pVbKbfnuvDkWUx51oZWZW9kx6mCEo/qRoMtdGZmNMjWErm
	op2QvWsscNlrLO+v3FwOD/eRFiTCjueoJbueA9lhk3TbnUjuaCq005zkQl+L2cUpnJSkyi
	Hu6h0i3CbncwSSimyd8NVXc3uDYcyZk=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64BHvEnS098182
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:15:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=nNMh
	459Qb0NBOZf/rMrLKlp+eY8nirwVRRGfS/oMrYc=; b=ZnvkrCI7Es9dc9+kR4dE
	Nb8psOyeAAu8H1CvJTJ8r5ca0bG4Kd08AL8wqlGxZf79ol0E+6aey1eMXP9AsQMh
	L3NJb4cOM7rqH2DrleUAJ/N7Xu+gWwvW2r13sZBRDhgQRSaBqHLKwmtGc7sGTnBG
	pzc+l9DgH2CVbPUhhUdUokZimUJItAKr7B6VJ+vTcansyhZ9cvOu+tX8frtiIhzP
	8mI++TFt9lvGgOuoo1N5rLWNBRymmFivAZ2U3+rdr0exTevZl3sNg46C7PMii90D
	ZnjVAs8FrAFZH3pOUaNhlnRO2kgdLn/KPgQfMlfYnrzMokYlMavoTkTI8kJcPE2O
	Mw==
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4e3kf8rc1a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:15:43 -0400 (EDT)
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7c485e98f8fso14030427b3.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 11:15:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778523343; x=1779128143;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nNMh459Qb0NBOZf/rMrLKlp+eY8nirwVRRGfS/oMrYc=;
        b=h1U31JBMNwmV2d1bTitjFbqxgnVjeYVE+gqdeMhdx33u4d/I//l0zCVTTbzm8S9RGZ
         yIvzOpPGtS3ewxTrqcD1ZqYj+CMFltmjqpcB4xUr0m3Fx6tKc56CPmIoG6uvYcbm2k2h
         pq2tS3k3rZx2AwHfd5f1qk54JZaz6AejHTkC8bpivTbUR9hexAJ6FfC4IuR1vsnUeAQm
         m+ep0DiuIuRRo7Fky8eO7VQg9aYWBmqmx3U9YuzBKiz/rHBi4pJui0/0LfUIo4miYhfb
         LQIDK86mN9MgHPwEyAMh1WooUW/Ekmxc9iumqlmeeoy1ZY7O1lqsA5WtpUJsRFj3Sy4M
         nOeA==
X-Forwarded-Encrypted: i=1; AFNElJ8tQ5gnrZhrjEupewm4LaZHz/JkNEgP/t3W4qWQs0twQJduek5KpnqhHYq3J8LiqkOGemWGRk4mMg==@kvack.org
X-Gm-Message-State: AOJu0YyBJtwASgR2XTbvN5KKkXCIoGe268O5cNLt+SSzE9WLcdeIBeg5
	RmsSIj5GBhkclpBENnN9JqwQMCm4ljRW3SKy+9GBym9t2IYT8jllOFe/XYEyUsSTbXTrXMNILFz
	NoJGGuD6zrrsc6NLToF/NtuD9rER86R8XMrWsSkQ0pCohSPqd
X-Gm-Gg: Acq92OFsYfiTWKbHwDNxGx1Fx65vWkkFRmhE9He6DxJW//tER0fu7JjdpIbvnbkbA4t
	7NRUasuworlACzYN6dnX7B9zk68FJx4QbYZxqhhPQaS9erjN5taL4Co0e/KY4ScJejw6dak7h8z
	OrrFecpKhZOLmcaLD/DZ2YSy0Y/UF1KWI8g0olzz4CL8Rq20TPT1AM3YNLAA155bWl4l4b0YLpS
	lk29GqcQNiz/iAkhTOX63mJBo2/IF7b2zEt1RX+TiUwtJXoHvVDhPR3hOJEwb2e4rh8Ms32L7UV
	7MvUGTR8EiKooPY03lFiFNj+DlwqZGIZ1bEOndr/BylYeAPzQCdq39G3hwSKTiMhw5FW3015fcm
	kaWWtwVJUq5YoJx140dm0P32i7pJUju6dXbQZ
X-Received: by 2002:a05:690c:6983:b0:7ba:a726:57a4 with SMTP id 00721157ae682-7c10567accdmr99156447b3.36.1778523342834;
        Mon, 11 May 2026 11:15:42 -0700 (PDT)
X-Received: by 2002:a05:690c:6983:b0:7ba:a726:57a4 with SMTP id 00721157ae682-7c10567accdmr99156077b3.36.1778523342322;
        Mon, 11 May 2026 11:15:42 -0700 (PDT)
Received: from [10.206.149.208] ([129.236.224.3])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd66019105sm153053607b3.0.2026.05.11.11.15.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2026 11:15:41 -0700 (PDT)
Message-ID: <5280b6f9-e6d7-4854-bbdc-ed5349a478ed@columbia.edu>
Date: Mon, 11 May 2026 14:15:41 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/filemap: fix page_cache_prev_miss() when no hole is
 found
To: Jan Kara <jack@suse.cz>, Vishal Moola <vishal.moola@gmail.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260510-prev_miss_fix-v1-1-755bb123145a@columbia.edu>
 <agHPIcZHHyzBjcGN@fedora>
 <s6hnqm4bbi5j2ergudihydboj3uw7gsu7te4dfmjgv2qeosfbd@yvhp5oy3r3b6>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <s6hnqm4bbi5j2ergudihydboj3uw7gsu7te4dfmjgv2qeosfbd@yvhp5oy3r3b6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: Driy1S4WX7xLfbrM-FR7UPSC-FffYAL4
X-Proofpoint-ORIG-GUID: Driy1S4WX7xLfbrM-FR7UPSC-FffYAL4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTExMDE5NCBTYWx0ZWRfX0orovyW1oT4t
 j28r04PljpxIXzu0B0W3dR8auA2U5N63MzGjacEn+Lh1xFzHWHGDRnip9tCogj+bzU/OVbElLbB
 uS+s626FWxkm8BLpkJ6WFPm1gL8/1ykTzWMowXkUurGsK+K4D4RyM7nkP5ua97PQ6XGwWRSf+P+
 S6J4/x/0uuGP0Z0afEOJzrkevcVqtoj+XHekAE6SOhfpncmylaYfGO1XpDTX0pCHnpH6G8z4z+F
 BMSnRaYFRq0q1AOF7UpKW4erOGDw9Onn7f64jIzlPEDUA82y/vLzKv2J1B+XzfC/0dsrLGVr95l
 n+miZsUvuAoNOzf3bPGwbst1UdQUzHgM80b7jYpovZ/HIPBYkpPKYBr1CITt87BQnUSkQ57Zd+Y
 XvaHKI6hSCiVjA+zKNlBl/lOvhppUzoK42oXmERJLOS3+k3fWmCpe8A3rVNyygzR6NpYhrIU0RW
 90Nj270Mg4343X6Vs/A==
X-Authority-Analysis: v=2.4 cv=Eeb4hvmC c=1 sm=1 tr=0 ts=6a021ccf cx=c_pps
 a=g1v0Z557R90hA0UpD/5Yag==:117 a=uvjyHnA+wHnVBzamt/20/A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=5NEz3i_17GglibqS5w4A:9 a=QEXdDO2ut3YA:10 a=MFSWADHSvvjO3QEy5MdX:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11783
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=10 malwarescore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=10 suspectscore=0 bulkscore=10 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605110194
X-Stat-Signature: 9ekhxgtqq5ukpygtkewt3fz15xfs5kew
X-Rspam-User: 
X-Rspamd-Queue-Id: 64C82C0013
X-Rspamd-Server: rspam07
X-HE-Tag: 1778523345-14880
X-HE-Meta: U2FsdGVkX1+Hu/EZ5g+lnjy6bqF8WbWaHb/MUMlXa/r3sEEI9jYW1J7BUrZU8tqsBGeuuWDDA00HxvjuGilb3yAbaPq2oqnvQN7XChf6bFo5RCwue7mjGZ+MCjAEbqqr2F0XuPvUa9jSVnL2UV3ww0wRq3AUV28yhRyoaZZ0nINX2Pm2o42xjnektRkkefv8Nzxqbnic4k0TCixIzKZqBIZF48SayVUc0qZpCR3V9Ushd1mU8wkF4oet6OmCtMPhkXVsvmmQ4gGnhJGP5r7/jUn8efKA5uzM0tIc9KcLoGD5ZlHxg4Sx8CNSNwVtYTm3PTjSLA66RtMpoBboxK1MUk0SCwbwS0PlKTR8z2agGPkGQOqLzf07CbTAr33CTF64IAS1EQrV+8VPff1JJKLysPB8g1Xmxtgv7DxLLD2491+A7oGvkp28zz4zky2856Dwjizwt4cOIsqcKWiKsdnCzCI8dA60zVuAS+4DNlTWHjHImkswR3F8GmdBpzjd1Q1nuQCKwqVmeQLBajuDpruly8sXeYjvEjxVdK1jiC7AT2Uap8i4q+gfFTiY8uHlp5xSD9edb3kl78apVAyOXCeLMJXYpYY/5qIWVoCCCRkqpBmtBAcy8JebcI03cQows2J9QqRfjlpenVLAS/AhpLTmZWatOKxbUmf39j0AbkXzEt7OGWhX+e9pS7/rs4FYHBvX1IVnzQabI7a5c9eqOW4/zWnOhsyUyhmUyGicb9a9wR0ZP9LVwwa/Rdyx1vBPkV3bQRqR+0+1G9qUMgPQHeSDAys9M8AEsI2Vl/fu5eWmFiVoYTnfAeWwrA07X/DZHv6tmMZY1C5PIpyHRSATYcw1lTam8iNK95p7EJA4X1qEHfq/FE61kUmVfxsPVzRmbSQ/BpDUlTXjgZgsabkExpPRCpBYF4wdNWRjnuzUQyYrVVXr7QbYr6rcNxej/15i3NeQFNzuikIB4ubqGs9dYHU
 QiHeqHNM
 +iDkoTJnOIM7Cy76qxFDc4E5ZA6YR0M5uSczlUVHWxnDLGHq/QtlzaDUyM6UYmYLxjl+IZjf3tgXuwMrO42SjrL7A+R7xYzDllviYIi05wHddswXuF1TaQM0oQb6RLR3CopGy9EAWZ9WueDjSsienzR5tF7FfinPdr5Ug/RNqiOv/gpWei1q1xaANGxvSyhYKS3751I6JRmbgbDdgxmLccpNx8dUt/J08gUB+pCacQPzaDVpxJJCCh1b8xcxkCSGlZtd93wk4xG7NCRY46SQz57xkZtJjgm7b4jt4yldShhXyRY5m7psyG+6/8NG4wrlUxc6gwv1ArVMYAA6cGaKSH1OniPMyp6m2fge4XixoRdkFeVkRxlblnsPcC3HQy355vlpjDm11K4p5Kz52q+RiJUaXkkxBYoSBkV/+cjoFTTnJgVFkQtBKcJaembhleroW5pMgfTgswKBaN2UojvvX89JqWWpJGMvXR5nWcHBUKV2YVUsv6XCRc55qxd5GdFvyNhgjRERxVLeIAG/Eoxuga5CLZM2LRBbrFRRli4uOxLO0sdNY3lm7N/GELMW7Fyy07Xh1Q4P8cV4dKLpNssmGhiOG9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 12:26 PM, Jan Kara wrote:
> On Mon 11-05-26 13:44:17, Vishal Moola wrote:
>> On Sun, May 10, 2026 at 05:54:17PM -0400, Tal Zussman wrote:
>> > page_cache_prev_miss() is documented to return a value outside the
>> > searched range when no gap is found. However, the no-gap-found path
>> > returns xas.xa_index, which after a successful loop is the first index
>> > in the range. As such, that index is misreported as a gap.
>> > 
>> > The sole caller, page_cache_sync_ra(), uses the return value to estimate
>> > the cached run preceding a sequential read. In some cases, the buggy
>> > return value can undercount the contiguous range by one, shrinking the
>> > readahead window or pushing borderline requests into the
>> > small-random-read branch.
>> > 
>> > Mirror the fix in commit bbcaee20e03e ("readahead: fix return value of
>> > page_cache_next_miss() when no hole is found"): preserve max_scan in a
>> > separate variable across the loop and return `index - max_scan` from the
>> > no-gap-found path.
>> 
>> IMO, this way of fixing it hurts the readability. I'd prefer something
>> similar to the fix in the original commit. Or...
>> 
>> > -	while (max_scan--) {
>> > +	while (nr--) {
>> >  		void *entry = xas_prev(&xas);
>> >  		if (!entry || xa_is_value(entry))
>> > -			break;
>> > +			return xas.xa_index;
>> >  		if (xas.xa_index == ULONG_MAX)
>> > -			break;
>> > +			return ULONG_MAX;
>> >  	}
>> 
>> If I understand this correctly, couldn't we just do something like:
>> if (!max_scan)
>> 	return xas.xa_index - 1;
> 
> I think the easiest to understand would be to do the above two explicit
> returns instead of 'break' and change below to:
> 
> 	/* Return start of the range - 1 when no hole is found */
> 	return xas.xa_index - 1;

I can do that, but I think it should be consistent with
page_cache_next_miss(), which does index + max_scan. If the xas.xa_index
approach is preferred, I'll change it in both functions, and also get rid of
nr.

The nice part of 'index - max_scan' is that the kdoc describes the range in
terms of that already.

Thoughts?

>> > -	return xas.xa_index;
>> > +	return index - max_scan;
>> >  }



