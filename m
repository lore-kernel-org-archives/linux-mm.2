Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05216C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEF5B6B0088; Wed, 23 Sep 2026 09:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79976B008A; Wed, 23 Sep 2026 09:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C40DC6B0092; Wed, 23 Sep 2026 09:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9ACB06B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:30:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 450B91C31BC
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:30:20 +0000 (UTC)
X-FDA: 85245111000.20.37EDF67
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf31.hostedemail.com (Postfix) with ESMTP id 699B72000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:30:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rfKdHlg7;
	spf=pass (imf31.hostedemail.com: domain of yizhang089@gmail.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=yizhang089@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790170218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zidhQFtMBqWpP4LRT4RaIsC3YDKSMIQiZYuG7TAn+KU=;
	b=1gP9TE1kK/qpELA8IJmJhsVjlikWYXMfNLoqrA60cdavGQMcvRNz0kl0BIBNdnvzC3luhV
	FkwcuZ1DURkMPDtfP7BWaFqpBum/fjow6nAyEIfc/MSBzMXX48rpykvE51uA47QRhvWGM3
	99ihtaKyqI5UcGMbprT0MLl/KgrYRPU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rfKdHlg7;
	spf=pass (imf31.hostedemail.com: domain of yizhang089@gmail.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=yizhang089@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790170218;
	b=0j9ZUZb7jNxZZXZvtvFtztYkqULWo3+DXPWGNlLkW27bzdfNcUhYmq6TJVVcB8HRf59MBV
	wJonYRNaNIvN5pHRaS0jh0yrmIaKTiRe/8ssbGtBG9oLM5d/Yu8zE57wMYp/Za+N6wrPek
	h3pqr1v/QKj2E3eboigbPHc6BQR9Ibo=
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d4ddd179eso12037257b3.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790170217; x=1790775017; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zidhQFtMBqWpP4LRT4RaIsC3YDKSMIQiZYuG7TAn+KU=;
        b=rfKdHlg72d5pEl1KX1XjgnIoL4XOGxB9IOKTzN28fNICW+2qhx76l5eD8T/jMl53vE
         QmXPB9e56UcdUSdztaT2KiaFMmLtHW1/bYJ0EDvCBjAK7zodNyRVfPrbMIFkA+fK/6DW
         ezcrglZ9t7AH8KUnhGvWnQ0wObBgYMYO00gGYe7/7usjmuqX4g9Xkvz/jNGPYwOUUB6e
         oZQHiqBAfbZLHcdhY9V2+XA4STth050pQRTCAGySpjIi4jA/fMtPOI14DhAQ1Hc9Ayzt
         L13B1jhumukv3I53hQ5HJB/E349OzrL66vtNtnnsLUkTN7vtc2bDj1LiM/YVlNE3gIBU
         4+aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790170217; x=1790775017;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zidhQFtMBqWpP4LRT4RaIsC3YDKSMIQiZYuG7TAn+KU=;
        b=zwBa84egFf0CcNddcqwOC8gBbF8pvzttTQvHdmGXj1xqWCUa1rGvyrHo0+dOqS4U9N
         VTgavLFHHErIqFsiGNh/laHQTIaW2g/u4kxAuXS75B7WUBhN/9iG9gRTKQaQDrdBEBgA
         g4SPkSrbrHRZ/cHAsJR7G2kDl61kmZA74GDLbfJ4IO98mJCzqhFfJvACIUXlMMarDuGr
         anqVoRLQAqAzJByVvBpb3NpaRPbxWse6JLWBRwwoFohCuFrD60/VeOs814UZxYqu3MQg
         Vv1elf5oB0/JOIr7OC5bqqP2PXUun6AfOHvyTxm8cM88BALhJUMRtfdkaeisDSzP0yKa
         qCxA==
X-Gm-Message-State: AFuF++kwOKyh9lWDtEb5dpaF79YbOvKPmp/MBTbcjmlzud4GKzba37wI
	bgYAHE+VnkZKhB8jawRTIZP7LLaxqClGQ4fGO8P7mp6Y4rR1B0EpvVBr
X-Gm-Gg: AYBFou29hqAZNQ4POuRC/6feXEwLPPu87hwBrPQ+028znusKcrmPvzM73/6hio4OkhS
	gJAg9V+ERCcV+sjb+XC2qqaHlhFD1jK7i3Q+VgPR4EX4SbRWvqyzue388NDUh5ard3PHD4BNW6l
	drBWooH7G1qS02lUlPWvED1IAlrzpswAZ5liuVF0CGVV4k/ivXImKNmRH+DGOHkFup2sDyyEysQ
	y1h01PBGFylMUtFtLPKDFVnH6/AcIw3MIA8Z1baEUmWa5ZR/6h19b53j/aSMqF57ClMm7GUGMtv
	+RSti1owxY1OIVBHX13nxg3tYD1LzvndojxHkquXKYPiK4mFS4lMyzfDgk4+I/fWOjz0XdHn2ii
	rJt4uJuTtiBxCIS5kkcHATpmfbhL5Us44izM0nOlXccZ5NOUCmPj0rAWoVedvbOzbuCxhUl7Ir1
	kPd9cAk734liOc+h9iPgvAEyU2/wiqUAfwDjFyJzqBIMoYeq8JN9AQronoCDGOkS1QinVQKIvsW
	EqGI2qLop5Zd9OMYL+QAnam3VXIYA==
X-Received: by 2002:a05:690c:4004:b0:89a:63da:cbec with SMTP id 00721157ae682-8a45c270a06mr12544017b3.50.1790170217243;
        Wed, 23 Sep 2026 06:30:17 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a466ab7e7csm9385007b3.44.2026.09.23.06.29.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 06:30:16 -0700 (PDT)
Message-ID: <5419d3e7-bd3e-40a5-a15d-397e9019b3d5@gmail.com>
Date: Wed, 23 Sep 2026 21:29:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] mm/truncate: clarify return value of
 truncate_inode_partial_folio()
To: Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, ziy@nvidia.com, bfoster@redhat.com,
 joannelkoong@gmail.com, djwong@kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-5-yi.zhang@huaweicloud.com>
 <5pthbyxtn7q6xi4fmkofvksmcjzfnujcw2g4fxmxjzfin5pbgf@zui3vcimb4cv>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <5pthbyxtn7q6xi4fmkofvksmcjzfnujcw2g4fxmxjzfin5pbgf@zui3vcimb4cv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rhouq6quj9594zhd94nkuu879edzxgej
X-Rspamd-Queue-Id: 699B72000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790170218-993713
X-HE-Meta: U2FsdGVkX1+4sCPUgpzcJz5fSolAwxqDGHq3Pp/8yUPsW86ZXi28/Zu8xyP3V7HuFbn/SsDhJE8GwkR8WkYKEgvkbobajGwCjiiC5r3dZwdd8XLei8lwM/29h7Iy8RlF8+n66VFvJj/b8Efr+4fXcqUxp9qvGacltxIHqS86rZc5Z/jLSWiAAlvix+C2ivfom0wS1KHGBIKaplCjKmKuEyh7cDW/dMrdxgmFAhM49h+06B5/VeeeMXff+uCrE0zL2h2hNaONRgM8RyiFCB/R3HqQNmDhGvz3PyISu3tTQbEk9wDKQ7vVCsSOgBA490h0aIVzZspJacr+rmU4Dnr1SmapAFcOXXgo/m5wv62GjPo8Bf7PrV/IQ5bATieAqF8qLHW7CdGdKQl7etoRRbEgKO0zboEHK0mg7EOOQouO8XuPW/wZ+ilXzFv6DfKnK+SV07xWj97ikVzLLRdDa8gXiojMDp5mRBMVJmGSRODiBBv4SaSqyqe+30LPOw44/9nU0t7U6GISxeAra3twKwLdtI/BLRY7n95/HU9X8QCHX+5tFOECfb1FHpIHj9w+oYbBRYAZ+/6HQMZhuR2K4PgDwlZUhWqY7dyAks5ukuhVkbFtbnOSA7JPBC4mAiwWY8RCi/bLULbhskbfBNPJ6IkQk/7CLt7Lv6IuVUgvogA0iq6tZtx/IsV7iPQcnGso+fcht5iErLp06zGlc2tszon0rdp87N2gmSKnGdDHvyfx05w/ngYrfreJ8UKkn63+lx6c1Kq8dRnWDazPViE5+J6zfBzdpXTslguXwDOaOKHQ0KHrZJEFc3DQkQViK2bCAarjJcRI5lx6KnPhbKfhqZawOg5hprjg67SHCP0s/Rp8T3U0bSRbeOTs22pjVXO3i2whYuhAgKyGTP4FdpoOFCG1jm8TQuvOAW82oBHtStdk3s6ZcZXY/bbMyB6YiXMtg+Tv2cHB34Y9MzDvalpc6QQ
 jou0LtxX
 fcJAo4bKRZvaYHcfZ1sj7x/Kd9kCmMQm4CbRJD1dU+YYrxUQVG+vrVdEKkZp3MN6RhTxfoRTL5ziZvi7moPo4H/1oyY6OmT5uzvi9rqM0XHPBkK8+cKF9UJnp5BLwqEbu6J9rg7UQ7ztokrg7qz1Ghh4IF0t8pNLiiMzmeH2E3Po8fJBcvFo5CvzpiJnFNlprNs0ruabcxkrUIQCgoerZJp7LtoIzTEss6rmrFryquwY14KwMUOox7iNFS8r2oD/kMCEKRszdWOOKy66nI5iediriBgsUE2g3mcfAdLv6D423ZX8R+f0KPJ++GCCCRINpwKCezn8p97JJAwSoDd2X5mwbZjAihWEXTyMOm0iEoSwEgjLMo27DsWtphdbxYCWuP99pjq6+KzjRuqglxtWfgpKBUug5k6KH7an2/wQvNQXWAXRyl+fqXgguOxZLSrUOEC5ECcqF7oGx8XoEqiN3E7w89NIWALyVZigki+lJHVH7LE3Aal7TVJmigTyViw7X0yDM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/2026 7:58 PM, Jan Kara wrote:
> On Tue 22-09-26 19:07:03, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> With the earlier rework the callers no longer rely on the return value
>> of truncate_inode_partial_folio() to decide whether to adjust the
>> truncation range. The pstart/pend out-parameters carry that information
>> instead. The callers now only use the return value as a flag indicating
>> whether the loop should be reset to pick up newly split sub-folios on
>> the shmem path.
>>
>> Return true if at least one split succeeded, and false otherwise.
>> This clarifies the existing confusing return value semantics.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Looks good to me. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Just as I'm checking the only use of the return value of
> truncate_inode_partial_folio() in shmem_undo_range(), the code there looks
> fishy. It does:
> 
>          } else if (truncate_inode_partial_folio(folio, lstart, lend)) {
>                  /*
>                   * If we split a page, reset the loop so
>                   * that we pick up the new sub pages.
>                   * Otherwise the THP was entirely
>                   * dropped or the target range was
>                   * zeroed, so just continue the loop as
>                   * is.
>                   */
>                  if (!folio_test_large(folio)) {
>                          folio_unlock(folio);
>                          index = start;
>                          break;
>                  }
>          }
> 
> However if folio was say order-2 (4 pages), lstart is inside the 3rd page,
> then the split done by truncate_inode_partial_folio() can result in order-1
> folio, and two order-0 folios. Hence the !folio_test_large(folio) check
> fails and we won't pickup the new smaller folios so that we can free the
> 4th one... So I think we need to unconditionally reset the loop if
> truncate_inode_partial_folio() returned true.
> 
> 								Honza

Indeed, that's a good point. Since this is a pre-existing and
independent issue, I'll send a separate patch to fix it.

Thanks,
Yi.




