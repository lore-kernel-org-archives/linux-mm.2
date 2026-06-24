Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48357CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22D236B00A3; Wed, 24 Jun 2026 10:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DD236B00A5; Wed, 24 Jun 2026 10:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE136B00A6; Wed, 24 Jun 2026 10:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C77F86B00A3
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:38:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 490F412039B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:38:29 +0000 (UTC)
X-FDA: 84915061938.16.D40A263
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 866754000B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:38:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVIuV7Vx;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782311907;
	b=EdxD0NbnI1HUNn88vg8kQHxHc08snnoVXIIMP6+kAoEgjgNWV0YDDbQc2qeaUbDhtUHprL
	V7dzwAD+sPc76vEhgGPJxWZtM/pZaVMhPh23vEdG/xak0Nbw/VEg5DNnTHn2kLqrrU/NP/
	U+3jdMIE5RWVLTLpcVmxG0En57EH0qM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782311907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yhT0/LlB1rg0W3DefCcQyBJOT+qvVyNtU9gdCazTVH4=;
	b=eIxxBVF3jtesjdm41pGNeDZ2VCqyVfsjRziLklZrSCKPFdIEehMDQXsV9Kvy1KqQ5VK/aS
	nx/QmDS1tVRFBs2YmbFAadae3Riy0PMXF5SCkA5FiuGVmBFSuyHsD7MbmWX4hS/xvLTzrg
	pYTaG/qMj6CY+tI1pIyjM1S0IC51sXE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVIuV7Vx;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F32B260018;
	Wed, 24 Jun 2026 14:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A84F1F000E9;
	Wed, 24 Jun 2026 14:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782311906;
	bh=yhT0/LlB1rg0W3DefCcQyBJOT+qvVyNtU9gdCazTVH4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bVIuV7VxLcd9Iyb4ItgZDPIicoaxyovoOREIAv3mS6bxGCWSf1UR6dwmXjtaW3Hb2
	 gzINqdxbMqTQKYLuuwdILpR74+tToCf7tsmpY7gZeWDbtREvlshPCX8RxgqmGtvy7i
	 6ry/ibiDzDBGkq4XRfsfF4+P3n43NVatj9k/zbjyMGY1qnK7icBRoR1qfPz2tRlxaR
	 tOfPOQaOcSXtuQlOdujaM1cCzyEPs//51CKSogBxrMeG6sNyMlS9qhB/B8Pe75tuc2
	 5h3OwImAhV1NuwoWTL3nPgeiuCjQNUrSJAlDcmCX0Osr43tZVCMa8VCLWy4xb8Wi4P
	 woG1M3AZzHMgQ==
Message-ID: <8bff931f-6e32-4506-8b3e-92a494e796e4@kernel.org>
Date: Wed, 24 Jun 2026 16:38:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: fix data-race in folio_batch_count()
To: Lorenzo Stoakes <ljs@kernel.org>, Xuewen Wang <wangxuewen@kylinos.cn>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260624092606.1083449-1-wangxuewen@kylinos.cn>
 <ajvkK-vcVzgll2Tm@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ajvkK-vcVzgll2Tm@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hc1hb3e3ycs3hmgo571y75k4tcx55ybq
X-Rspamd-Queue-Id: 866754000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782311907-725693
X-HE-Meta: U2FsdGVkX18+c9UdMqLGhocGzQgr2XoiLojg15XIW1NKFimlHIL40dHeSk6XXRX6QTh/7+XtuWds7d6lGvcWopmKsy2XPphoVuE/2ogDPdi418Z/+ZVRXwM/6H/Son17VTH0GK0/6LovmAKBenmB8d5Ev4P6E9WgAwVZ6OI83hP2iP+iCal6so7svpegFbr0ZK0lhALqnsMUU1Uw1FjGWJxhsJi3jtGzCjBsFEoJaDrfYfjcqqQbbHj+j19KJtRwRdvHypg3P1kil/X0Izz/vMqidve9ruvkgkQPDKlfd7iagIBdtVaJekNjTzUISVRh5Lod8n16lyxt9L/5RgHoOP235BIPC2PDO0/pEaSh6HbLGQ+pEHInojJuNNbOQMKVn8wttfQ+QgVeMe7xAvQZhWSX7ZaRKvqzPVaPP05rmVWC0DvzxBC3URNTt5Ea8KPKvmt7cZmO2gbO2ptGP/2x1lzlKfpGh+LKOiN+0XKjK9SFRWj86Re4IK6Lb1Pt6CGWPTSRyVQGFM/FsHdUsDYZ+o/zly6fiCh6Pu/wCJsDsOZg9BF157Zykrz0LnkPAHaD2GjmyKuWS/PyByMGDs1p8er+SFJLYb+z+uU+QfztfO8BbU8tQ8njf+1hg5pxZuxBWqRwOxoADNmkpHxhCijNDf1Ey47x/CP4jnbOOrRW9j6vWW9AsGxw1FHJLBOy3aYEFWfBH8OfM26wdo1t5qzOtJoH3wiPvKhMJghg6Sg+/g4XjrXOwmLKygnAlpgtJnQHMQ+/Z8eIQsXN7LKZFizxVAAl6D4J/q8mu4MHg+mrY3Bd9t2sXEJE2jkcLCTDOB0V0YEirVu7Mg5+8TyQZA7GIup8Xd+H52f4NHGUq0grqNu8L7mry87uyNPKyX5OBQf5F529pPV6cfW6nQ+qJBn4senkUZldLint7P2ONhVPslY39+YAJIcbObKhzULTIJywqIyIE4pf+rdoD5W6bLk
 JuQA20p0
 s3IVGaJnK4x5ciLymjgm1t8x4o04fwJ7BeOPJXFM+YU0yB2diiQxnV9WuVmVLJnFriGHBVvRnA9zmfC0xCUjt19yxV1qGn+qfwBb8AK1k7jqWYdhzaSLI6awINuEsNNWjW0of54pO/9sD+dcA58DcwPIIJ3YLx2jIujmhvw7mUWpyPk0sOxXEDwk33tk75HdLky9taPWD3SnuNMXnfqegTNvsaFhiVeCRfunADnukG5T3r1OxIz5tLRJpfvM65dgJoAIhm5Z9J/YRCbrjLTrWApG9RlbTYLYiWatk8frG57QFrXKI7+HHaivbZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 16:23, Lorenzo Stoakes wrote:
> On Wed, Jun 24, 2026 at 05:26:06PM +0800, Xuewen Wang wrote:
>> KCSAN reports:
>>
>> BUG: KCSAN: data-race in __lru_add_drain_all / folio_batch_add_and_move
> 
> Where? A syzbot report? A local run? Please specify.
> 
>>
>> write to 0xffff98fe74c015f8 of 1 bytes by task 45153 on cpu 2:
>>   folio_batch_add+0x30/0xe0
>>
>> read to 0xffff98fe74c015f8 of 1 bytes by task 45175 on cpu 0:
>>   folio_batch_count+0x0/0x10
>>   cpu_needs_drain+0x253/0x430
>>
>> The write side is a per-cpu local operation (folio_batch_add on the
>> CPU that owns the per-cpu batch), while cpu_needs_drain() reads
>> another CPU's per-cpu batch without locking. Reading a slightly stale
>> value is harmless -- it only determines whether to schedule a drain,
> 
> Then why are we adding a READ_ONCE() in such a core helper?
> 
>> and a subsequent check will catch it.
> 
> Where? Which check? Be specific.
> 
>>
>> Use READ_ONCE() to annotate the read and prevent load tearing, which
>> also suppresses the KCSAN warning.
> 
> Tearing on a single byte? Which architecture tears a single byte?
> 
> I think you're actually more concerned about the value being optimised out on
> assumption of it not being updated elsewhere right?
> 
> But acutally you're not, because everybody else uses a stack variable or _their
> own_ per-CPU value?
> 
> Only cpu_needs_drain() is the odd one out right?
> 
>>
>> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
>> ---
>>  include/linux/folio_batch.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/folio_batch.h b/include/linux/folio_batch.h
>> index b45946adc50b..1e31e058e19d 100644
>> --- a/include/linux/folio_batch.h
>> +++ b/include/linux/folio_batch.h
>> @@ -53,7 +53,7 @@ static inline void folio_batch_reinit(struct folio_batch *fbatch)
>>
>>  static inline unsigned int folio_batch_count(const struct folio_batch *fbatch)
>>  {
>> -	return fbatch->nr;
>> +	return READ_ONCE(fbatch->nr);
> 
> This isn't free, you're breaking optimisations here by doing that...
> 
> It feels like the wrong level of abstraction, but actually I think every other
> case is either stack or per-CPU _on its own CPU_ (please check), in which case
> we _can_ suppress the check here but I think best done with data_race().

Fully agreed.

-- 
Cheers,

David

