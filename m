Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E34ACFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 07:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40E376B0023; Fri, 28 Nov 2025 02:36:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BEFF6B0024; Fri, 28 Nov 2025 02:36:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D52C6B0027; Fri, 28 Nov 2025 02:36:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D1076B0023
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:36:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DFF289209
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:36:14 +0000 (UTC)
X-FDA: 84159207468.29.974102C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D34434000F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:36:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nrrHHsHU;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764315372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nyOJQbdW3Gq0Bb6MHseviCpECS61Cyxq1QxdXycVmgM=;
	b=cTTvbWFqmEJ4lWE8JE2kyceRNQBGdZnUlTeoxDFVReTGDusy3Gi/tuW75nqoBWW8fBKSoh
	Z0t1YyTDEs5PUIKKz9e3XYJHzncyERViF8zist0MRg0NgseSIxBHMDVhKXM9yh8QUi9NIH
	BQL5HUzm/1xZF7SI+spEfRDe4DOnDUQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764315372; a=rsa-sha256;
	cv=none;
	b=TxvS9/AYd6/sqqZTsf0dE3/aH7EGzJSYXJ0Jy1HG74SGSgV4vKB77e7X0QsQVLmyOhMGdl
	Z0R2OdHE7g+U9vOWk8tJnbIwZgslakMYuE/fJx2cVXbcuX13W27XJxymxJShy27v/kzugg
	A867iMeT7RcZEoPdrK1bvy6/FC0mdqU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nrrHHsHU;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B356842E01;
	Fri, 28 Nov 2025 07:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599B7C4CEF1;
	Fri, 28 Nov 2025 07:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764315371;
	bh=8dndaidv7PWdI9f8/GeBMTDI2VguxBhw3M/fNnSgSBI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nrrHHsHUrLlLfaq4SklPUnzUaCWikqrMZGyRmcI0edgfE39prJtGrl6Q1rPCOhD/H
	 eYJP8uOcHPDXDRpXx1l5haNcDfsXMl3Q1KxqV5Vw0W3wsTHxepowC3OJTL1nDr9YoO
	 gIa/oANTVa8HEG8QKdyr2XiJlAuYnoPjuV74BuKh4gi+0DvA2ShwaJoHiogCsc0mZf
	 /tNQfRuopsB36bwi/HSSSYfCxUZ8BCG7XmbktEkX5RvvMA4Er2jhiNAYSC0p3L1XpY
	 Au2Hphs0H8ru0T50gjxuzWMiEQPy9qeC5UAzvPiaOo2UGfwssaZZYHgDolcl+bELtF
	 My28HZWFK3vTA==
Message-ID: <3cc7d401-c77c-4ac8-abb8-c264fbd9aaf0@kernel.org>
Date: Fri, 28 Nov 2025 08:36:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] powerpc/pseries/cmm: two smaller fixes
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20251021100606.148294-1-david@redhat.com>
 <557b5500-412a-4d26-8c4b-147c9a00d5fd@kernel.org>
 <87zf86n3vq.ritesh.list@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <87zf86n3vq.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D34434000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: b5fqrz6ou6yguke8ntcpxmsyx3bgiph5
X-HE-Tag: 1764315372-699552
X-HE-Meta: U2FsdGVkX1+cWsMWLSekjWdRnnfRyrq2obccofpV/xmxDgTMi1Yzj5JEJd4N8QmOVrkLtz7fcHlr4cS7Z2cDMrYZZU3FG2IFb+znMg/co+sW49grFFvc/Pe+7/5gZ09uCTt2pW/+XNDQqfyC4p9OpH50cxKpu7Q2d7Cb9RFHWQanGKx9Xn7t0I7API9I4J0Bgz3q56LEHJmY5B5kBdeXtxCPyjPOOxZ51wNP0CPQ/61HQr/+QHix2jLgyRiMj3CWWd9aBLtdztkDRHo8EZRVN0tiqzDC777+fx77NHMlB3TMYDkE58+QT5qHWQ/6GCpuPWooa0Yok+WLNb06cCROcqXup76OvRHjJhweCv5SL2KtCAIMdi01OYNG86EJU8V8+7+I19ZWqKs99QR/QLO3SDusg5nBDJM2/nrnps76dasDtlqy1ZOEmS/Z3nHdjbZj+DOtkvZ9iiSFVHpZGEO7YApVV62814Na9CKCtLWk0VbR4C5Pw6i6requNRpLcI0Uxmnh1YH4+AuZMqeLGf5NNhV03o8CvUcQcd1Ngvfn+Dyxq5rMQJKCxCdhBESLUg+woKp88ee9qXId3GXcCMfWwtb+cCivxVP6xYVXGawgC50zCM5/IVjhs4ej+pTCic2aEXM50Vbasmpr4xG6tfzSru1XnXBGbDn+yEw8L7uxzpIxXhp0SGqiS1v6kEGvJ9FaDY9HTknum3j4hHUztdS/oP+kIgXC7LhM6XNQ4RFPBumR6DvHgwActRtqVKNS4NC8DAkFvZdtLvsb5O9e7KZuVMChw0LxCulbbO6fEIgL2ptAhOVOtZ7ui1+zU44m0hQJzi0LuyxfgttBJrG2EOdWVSTkkWLmG5XklZtAu2UFgnGzd+dpjzmfCWjtTxp5OcoUtmpaAoMZ+rsAj4ZInQ77Kuv+MMNZQcojU7h4Pds2Qi15u5/LtlE0rvYT5I4lqNn8bhOq8EjtuXOoIqUUHo/
 6A0bU5aP
 xbLpF42Q9SuqLjcNWBpWJAngwJjnoNkSnWLaRU5/4wo2fKeor+/MKp8+7ISr9jbrK3F1Rly9XW7vuOceFWB8nt5j8B/6cICqooAfYHolNp+fjKvPP1RNX24aGqSe/rIE0Apa+3Gh4ueOlidPS9Tu6+P8fqVYki+N1X/9zr16s9cBNmWAuygKnLYijf7H7+BYb/xqe4WaBQCn16akf+iIZUfqvAgoYW6RjG6K97RpvCaAofrtcLAoXozwXYgWHPHavEuJKq74AzkB2lWgdrYL/uSgR5tQVKEE/CmVhDjR8Tvobiigl/XuxorgrM1CIq1diXAzp3Bryc52wbEQWTmVC2/STvWgE2lsJa88H/bFsFKLgYXoPhj3i8aDSNGIao4eUwDv6e2bRAN7AvWFPXN8TV7DNJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/28/25 06:05, Ritesh Harjani (IBM) wrote:
> "David Hildenbrand (Red Hat)" <david@kernel.org> writes:
> 
>> On 10/21/25 12:06, David Hildenbrand wrote:
>>> Two smaller fixes identified while doing a bigger rework.
>>>
>>> Compile-tested only as I don't have an easy way to test right now.
>>>
>>> I would prefer for these patches to go through the MM tree as I will
>>> be sending out a bigger version soon that is based on this series --
>>> I split of the fixes from the other stuff.
>>>
>>
>> Ping,
>>
>> I tried to get CMM running again (using the simulation mode I introduced
>> a while back), but so far my attempts to get a reasonable powernv VM
>> booted in QEMU failed :(
>>
>> (e.g., Fedora qcow2 images use xfs, but the open powernv loader is based
>> on a 5.10 kernel without some mystical XFS feature ...)
>>
> 

Hi Ritesh,

> Sorry, I missed seeing this earlier.
> 
> Do you have the link to simulation mode which you are referring above
> please? So far I didn't find the support of this beyond Linux LPAR
> (pseries), but maybe I missed it.

When I did a rework of the CMM balloon in 2019, I needed a way to test
it. So I added

commit b1713975c31ae20ecc40fd00191ee3fa51445d4a
Author: David Hildenbrand <david@kernel.org>
Date:   Thu Oct 31 15:29:31 2019 +0100

     powerpc/pseries/cmm: Simulation mode
     
     Let's allow to test the implementation without needing HW support.
     When "simulate=1" is specified when loading the module, we bypass all
     HW checks and HW calls. The sysfs file "simulate_loan_target_kb" can
     be used to simulate HW requests.
     
     The simualtion mode can be activated using:
       modprobe cmm debug=1 simulate=1
     
     And the requested loan target can be changed using:
       echo X > /sys/devices/system/cmm/cmm0/simulate_loan_target_kb


I allows for bypassing the absence of FW_FEATURE_CMO.

Back in the days I was able to test it with a pseries (or was it powernv?)
machine we had here at RH. So far my attempts failed to test it in a
similar fashion in QEMU.

-- 
Cheers

David

