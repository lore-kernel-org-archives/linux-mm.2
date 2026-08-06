Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C29AC561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79CC46B00AB; Thu,  6 Aug 2026 05:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74DB76B00AC; Thu,  6 Aug 2026 05:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663D26B00AD; Thu,  6 Aug 2026 05:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46DD06B00AB
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:20:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 402281C1353
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:20:00 +0000 (UTC)
X-FDA: 85070297760.19.551E96E
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf21.hostedemail.com (Postfix) with ESMTP id C716E1C0003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:19:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=X47FWIPH;
	spf=pass (imf21.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786007998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCc83zHdRLaARt9Jej1f7Kf5mK+LznNYO+G+n5RjFJU=;
	b=B58kafogC/FrhNlgl8iLsaZiVJUUuxesSZtFf87p80vfESr5NxXhogugTtODDdJBkzZsPa
	BOrX7jP05fopcgqev34vNPen/hTVXk3rEMmnZb1ytbR2zasr2BIhw7HHIzL7BmhYSqcsaR
	rLM+S/xxt5B9r4F+8kM3An4x0AMqLu0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=X47FWIPH;
	spf=pass (imf21.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786007998;
	b=sAkzyElF/mCzAL/SzM4EVfqpVpV+JWec+bFm7fo+nVjFps25yphIFHVkJ8u+5JUL8Gjd/6
	EIZ8J/9cH6D+VAs9NkRPuOcRKqsiLW98WYS51pb3qAGiRCjiUpB0mB9HhOL/C2aezNoMbS
	DgW7n9QqJPRwVRLnW3FXW3nfbjA92TI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=rCc83zHdRLaARt9Jej1f7Kf5mK+LznNYO+G+n5RjFJU=;
	b=X47FWIPHIdGTpQfhMgb8ATorhn0o3mGlhTpb+R+dkYvu4gcKDXhx0iXWuQgI8z
	ABJCwBfZpCpLDoMMkK3LVpf3Vo+1C/EYPgLWNm4l0bPTi0M7OSviB2auXKflULRj
	WjogmM1mUvD4OpA3T17ug6PGEYmHONwBGPrOY0/c+IsmU=
Received: from [198.18.0.1] (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgBn6oarUXRqb4s_KA--.45898S2;
	Thu, 06 Aug 2026 17:19:41 +0800 (CST)
Message-ID: <0a8ebdd9-45a8-4417-91ba-71449f727b85@163.com>
Date: Thu, 6 Aug 2026 17:19:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/ksm: validate KSM rmap items before hwpoison kill
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 xialonglong@kylinos.cn
References: <20260803151151.3472893-1-xialonglong2025@163.com>
 <20260805162937.1795310-1-xialonglong2025@163.com> <anNl1SSA3fidOrTy@lucifer>
 <e3700884-ee6c-4671-977e-2694535b8443@163.com> <anRQlo5GQKValPFy@lucifer>
From: Longlong Xia <xialonglong2025@163.com>
In-Reply-To: <anRQlo5GQKValPFy@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgBn6oarUXRqb4s_KA--.45898S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XrW3uF1DZrW5Xw13Gw4xXrb_yoW3XFXEy3
	yqkr1kCr18AF4jkF40krWUArZrWFWagFy7J345X347X3yrAr97XFW7G3savF4fWF4IgFnx
	Wa47uw1Uursa9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjID7DUUUUU==
X-Originating-IP: [240e:46c:1000:421:a8af:b966:4ac5:a4ee]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC2w83MGp0Ua9WfgAA3b
X-Stat-Signature: efkupt1kshfjh4ki5op4sgpbaaz4n3k8
X-Rspamd-Queue-Id: C716E1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786007996-463840
X-HE-Meta: U2FsdGVkX19c/aljMh+2ikLHEkIlMIJ8DdP9kQrt7IbBjcwgFtmUw1GujWR2IHQvUU+/D4bqJqPGJKgLzP+eqIbkW7hlWK8M4NHYSyVTMJBIGiRM3Jx6YfvPVrrMXAatgD3/CAu2r2YLVp2CGNVjKvKW89hhRyi2jtP5PBRBNFoZnDANhYro7/nEA0lEoTzWtOiiMP17OU3KTOAfnTEtYZ53YSnzgYkCEC/4pxJP9+qMFJIB5MfZkyDHhFaYOjB3Qcc/4H6XObjYBxDSnwAghaqn6r6R//Hs3jkUywe0Mvy8XGeK5UhKdRoLhWSy8IqFUCUqSgie0ltX+UuMYSDmVDg+XW4k6SChmBsJtWakxfivz/ldDFfL8auI0sHz0gXQxqoTkxFHvPhwnWIUarnPESgjxpEiEyjy7/3RuxW8TAWJt3U0+2K8ejEI7trCsA+b0OplFaXQWbN5AJ2XEHe1XclFfIzDKc4YUlSe/YS/TJcPIcplBzv7vug/7lJDBIeSwnNKtlmecFSu5t06YjmCG/cTwqbvynBQZsVBkONJLbObM09JIaLu2ghRmNPC8dWjPX4e7lO8GZoK1yF0ZagramCbKeo7hU/hGaMbjce7DRjg/f2LtlE9CY79LS0aY2iNK8pRtEAJZ8ozLOK5E+1UMbtu5RbOFSK4sjowo/PkrG4C0IQ3rlhDH1s25nB9bjp/IEEnJwFdGfALWQfouuma/X0CREJIDhe5Gmaw2pscvOghsP5/hprB2cFY+GpfmjPI1fUJXWKf7z36Euzh0GEcKe9cXd4vIgYTG2IwnO3pOPhOTC8q/6SnUEAOVNTVFC4w2U8V3JCq6EPiOVokhECgkoFwkp4Y2Kq2n7a21xEXokNI2iR3zI00XRXL/LSLG/diqfGg9H46QnoRnEsnNGh4ls1DkAcyHlkGFBdO6pfz7eZI2bmzLt7UUdWl3/D6RDDA0N2vMm54eVYLWsXU3Qd
 CzFO1YEH
 s7orw8uFyQgYdfH9pWJ2oj6BnPU6gspxmFeKrBh4ZaJW1N8bJK5aptKtLlPUyvy6LiTaFRw7LmJhqPbPZya3uwiyWrFV2nUcrGDCd+taVJWWrDqYLbWGZpy1NSCeK7NT3ZM8YO90JV3ya66EyEs/BsaLxVSfLAzG1o46n6Q7fE9VsWO822/8EzbDtT1as76CrGV+H4ISj7FmZfInOMHKJwujI6peORoNHhLgTIX728SP12i1HXktEyvjqhkXnjqnbod+Md/IYwY9LBQb5HF8+DZWEoE4O3hI1Fzxyc70419eGwnhUvzvZcBzxSmKLDrqPYgBwj5m1KbVs95At/vgnVc82x0Soi7JLsBkKtSxfsjvgi+Wuzrbxh0qaD+yltHVH8pkI0+/A/An0VOnWImhWVp/2ctk6p1zgvkigc+SH3BgOp+KRLjdM/L0sSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I will

Thanks,
Longlong

在 2026/8/6 17:16, Lorenzo Stoakes (ARM) 写道:
> On Thu, Aug 06, 2026 at 03:48:35PM +0800, Longlong Xia wrote:
>> Hi Lorenzo,
>>
>> Sorry, you are right. I messed up the process here -- I should not have
>> resent it so quickly, or sent v2 as a reply to v1.
>>
>> I did use AI tooling while working on this, but the patch is my
>> responsibility. I did just follow the anonymous-page handling here, without
>> thinking it carefully enough.
> Please include the Assisted-by tag in future revisions if it formed a
> substantial part of the patch, as per
> https://docs.kernel.org/process/coding-assistants.html thanks!
>
> (Be handy to stick a # < what you used the LLM for > comment after it too :)
>
>> Thanks,
>> Longlong
> --
> Cheers, Lorenzo


