Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A77D2444B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 17:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC116B00B0; Thu,  4 Dec 2025 12:27:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAC7C6B00B1; Thu,  4 Dec 2025 12:27:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B748E6B00B4; Thu,  4 Dec 2025 12:27:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3CDE6B00B0
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:27:29 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 21C2B890BE
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:27:29 +0000 (UTC)
X-FDA: 84182470218.29.6F792F7
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf14.hostedemail.com (Postfix) with ESMTP id AE80F100002
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:27:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=WJ1OcT9X;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf14.hostedemail.com: domain of "prvs=4269f7937=kalyazin@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=4269f7937=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764869247; a=rsa-sha256;
	cv=none;
	b=DLJ3EET8hSb3Rn4cZwJpMn+gPQhRr2XJNxiU+Re3fVC7zz5+K9OT//Hgm2teOR3TL6oTgh
	nF6iTwp7LwMIjlm+jDqbqs7ZEJMcEgFidnG1FQkzyZel46FqDqg8T+YRhvPNbcvZ2nXzeB
	PCIJGr0c4wGWEbvqhwmKrcLnIesLKTs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=WJ1OcT9X;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf14.hostedemail.com: domain of "prvs=4269f7937=kalyazin@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=4269f7937=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764869247;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+B+opqRca5hXbovGvQR+mVja5lmSAC1UXe+INpSdy+s=;
	b=hHOdoecgvV7u0Iyg+rsyce2VB5a0DLUaYaXtPkamvWMgPzfs6MjZyistDAbKTno8RrlW/D
	a3dN5QDIZ+OKWcp6on6TpmnDvgPW5GIHEuy+FBUwMQEq6k4cVGXbfnBSV6gx3LWVSTC984
	eMyJTszByXjMeEr48McCaS3Nqp6F9VQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764869246; x=1796405246;
  h=message-id:date:mime-version:reply-to:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=+B+opqRca5hXbovGvQR+mVja5lmSAC1UXe+INpSdy+s=;
  b=WJ1OcT9Xu66XpYzxeZ3s7wqV4FlKHbQWkiD2KQf5xMbswAuGBU1mPd9s
   Q/0uY8JV6tvHjBpZacm4y9AlW+ULwOcG+IQFIhpHc0z4Slcmae+apf1mZ
   rhCLzK8RAIfLplQriDM+LH7u/YXmrt6ow9aULxUAaae/QboLvGyCBE/vG
   LDzcwFmwdRVGWUsOJh+2nAw8N9zmU/AJm/CVs/c6F4NVMNHoPq6A98pXj
   iEANWbwUcmOezpUNUalQbN0zkgIcc5RfzpG2bdE0z3TUxWs6MKfgEZ5Jd
   mpj7zIeay0qZCbnF3Xlpqa5ESXNhxCzuAaKahszXKT3lqcmbj+sfNUsSv
   Q==;
X-CSE-ConnectionGUID: tD7J2gDkR+OI14Z+1N4E4A==
X-CSE-MsgGUID: yxbASA5+QGOcaYoyBNhwmA==
X-IronPort-AV: E=Sophos;i="6.20,249,1758585600"; 
   d="scan'208";a="6143936"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 17:27:09 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:2904]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.45.40:2525] with esmtp (Farcaster)
 id 2e22cb74-9984-4686-b8b5-55012d26fc9d; Thu, 4 Dec 2025 17:27:09 +0000 (UTC)
X-Farcaster-Flow-ID: 2e22cb74-9984-4686-b8b5-55012d26fc9d
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Thu, 4 Dec 2025 17:27:07 +0000
Received: from [192.168.12.174] (10.106.82.9) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Thu, 4 Dec 2025
 17:27:06 +0000
Message-ID: <2afda7a3-3c48-44e4-b462-49e0d223208b@amazon.com>
Date: Thu, 4 Dec 2025 17:27:04 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor
 mode
From: Nikita Kalyazin <kalyazin@amazon.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Peter Xu
	<peterx@redhat.com>
CC: Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>, Andrea Arcangeli
	<aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, "James
 Houghton" <jthoughton@google.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
 <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
 <2d98c597-0789-4251-843d-bfe36de25bd2@kernel.org>
 <553c64e8-d224-4764-9057-84289257cac9@amazon.com> <aS3f_PlxWLb-6NmR@x1.local>
 <76e3d5bf-df73-4293-84f6-0d6ddabd0fd7@amazon.com> <aS4BVC42JiUT51rS@x1.local>
 <415a5956-1dec-4f10-be36-85f6d4d8f4b4@amazon.com>
 <69bfdffd-8aa3-4375-9caf-b3311ff72448@kernel.org>
 <6b21d20c-447f-4059-8cbd-76a8eeebe834@amazon.com>
Content-Language: en-US
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <6b21d20c-447f-4059-8cbd-76a8eeebe834@amazon.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.82.9]
X-ClientProxiedBy: EX19D015EUB004.ant.amazon.com (10.252.51.13) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE80F100002
X-Stat-Signature: r6c4whrnikj4s4g86d9oax44fpsod1aa
X-Rspam-User: 
X-HE-Tag: 1764869246-245978
X-HE-Meta: U2FsdGVkX1/dDv3HcfdrrgTcSivzsxVMVmIdpNIJQxUYaYDjshps3kptyT2wbjx0URDfsTj/MRtOimlO6Q3WuiE1n7LpjMrEvLdYaPhgd4I0/2Y30mIQ7xfLGpvoIGpPofA1vu4hL3850DwQTxDq8WiJlMDAr3S7Mb+7bDTXal4wvp6Wzb3PPF3DH4bn+SAZjS8Dsb6RIaaOaNeMS8NBD5+xGALRtiA+iNqn2ekL2xnsMG16wDlk85mhVPjH+yT4SAz24gY1e/hcWzrZimUXKiswWTMFJKTm/2vZeqm572+ua/b9aicjQADctoY5/oR7uhinsmHownko93JvGtwyTCE5mCoWl1Etc14gwsljM2VDp6or5wgkqT1ot34QkBrG8U5y66trJc5N2wIzFPGzXvXlQzZ+GWfcdswvLYrfqgoUPN+YjmnXzUWwO38cebLvRnDA+ucPTxYcEh/fruWYSjev9ySrlhAZkkHSWdMV3NIO0Ny9uK8CzIUx7Y0eEJo9nj+F8qE6lsV2PnHtxrDbA2HdX64pWtooz80vOkRlDY7X4SLiXcZN/7+uRpKCkdK3QMG24CU0R8eBLaoHe6m2RVBVViMqcrrYQhfWEh7UrSyIowPkgp7uJrZOi4nO5pyrA4EKUYzkG7/mLLrS/e6yWIV/m7FC7rRqaRTLKckOYzzzhCS6/703GJjryx2v5LI5nFuf34m30Z2vVZRryzw4BxcckWeZEs2Hwe/Q12+h3BXq+NahSCauyeyClOApYTFlOixPN+VtnKsFlVVHDOhaWJJ7/wWH+Y8ehxTVaFMpaQLZtZ/Up66DMl5/+zNkqzkNROsFARtPn+XNZDtk6AU4HHdB/U3VOPfeWnjEkF9htG4eDHKrdidPVTY0KoZG8sCviZ7+U2f3P/W60k5zyRO4KEr2WZjCViBKpzYtcK2L9E3QohxdnfzMPIOHPH94WunK8RrRSwTPbw2ilXIrGQm
 VNLWqeYv
 FucStPaAdwkxROHM48wTvel02Gg4IwM5+aUPuDIX8ScEMSuN1VOxDqeluhXooIBQBS3HLlFJzneqIl2U7vZXiclimPjLb3h1jv5s3kCngO5Q2GheQNfp0SKuYPIXnbCSDRBrgWFUWaZFmn9q9mmUDcF3utsWAynfyDcf4xOFOaCI9/+tgdNZheTfCdrh85sy9HSS4f69ZsZRjhF7ouoTlsk0v3kRq+bjq1Wx3CgbUoSsqBbt69ZXOdasBdnNLGzDoz0DLEM0ZGvixm2JyO89RsMkHmSqDSDXofdmkzutOPp5t6RMqlZv5Wbb9fRsnXyAfPAHgkrhGIjnp/t9GPzwNkSB2dY1AzTKEgS+K9/dygZROaAxvZipVb8DoXK0YwdEmjEBOpmn/ItxJcahGU74GrZk7wNRbDmu7CY4H5n6MOAe+QTJ4A8I6xdsakKXgg96SB5ERmqW96oImTP6O1jVwH2SoWfcDWTVy3vWh0WgMqmsBmENgNLTWsrz9CWOefgIL0i6dopEPCvvvumNo/R1x2wOnK2NDnl+NgxBPs+PoxLkrm0qaAdM/O2R4jVQtGO2DpTwvnFWs6iVG5XQv/FFLumDFRnXR+vHmoVWWKAj0lICEYGnN+v8MjB2MJrVmZETNfVgIuK1AvP96wSlcQENLoprzVUnpxWGH2sb7McC+Dur6/Sq7jz9Vzqs2K8vTtpAM7A4WK8u4UeNaO5fLDwklzMxfKZSTmMylD4KpY6qmpB6bFdGRhEujATStAmsvshsvSpJN3Dqwp3Ipv2TeKk60cnWl+G+5zQAonOQq54yOjoymb/gwVWlgORqawEsJryOqXn4AjzDpIDYlUG6WjwzhpdCMvTeOEcd/+1XZO6Ldo8+owHcOJ6YRvN6e8jpg2e1HTuuDYTcOHvpVY0zF7GpvPOSruHpa+PtubkxIjLTK0a30spcsYOcX425kO87PmwEnDsR5MqTkf02ldfTNFf5Dh8T48IDw
 05whZIYo
 uoq1cszgOFZItnN9G3WUYHoJdmAGkmDHx0tLaHr+IzbxcoM0FzPEkdEz3DUUm/5gnNVZgRfy8MUjsIEXYmEn3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/12/2025 10:03, Nikita Kalyazin wrote:
> On 03/12/2025 09:23, David Hildenbrand (Red Hat) wrote:
>> On 12/2/25 12:50, Nikita Kalyazin wrote:
>>>
>>>
>>> On 01/12/2025 20:57, Peter Xu wrote:
>>>> On Mon, Dec 01, 2025 at 08:12:38PM +0000, Nikita Kalyazin wrote:
>>>>>
>>>>>
>>>>> On 01/12/2025 18:35, Peter Xu wrote:
>>>>>> On Mon, Dec 01, 2025 at 04:48:22PM +0000, Nikita Kalyazin wrote:
>>>>>>> I believe I found the precise point where we convinced ourselves 
>>>>>>> that minor
>>>>>>> support was sufficient: [1].  If at this moment we don't find 
>>>>>>> that reasoning
>>>>>>> valid anymore, then indeed implementing missing is the only option.
>>>>>>>
>>>>>>> [1] https://lore.kernel.org/kvm/Z9GsIDVYWoV8d8-C@x1.local
>>>>>>
>>>>>> Now after I re-read the discussion, I may have made a wrong statement
>>>>>> there, sorry.  I could have got slightly confused on when the write()
>>>>>> syscall can be involved.
>>>>>>
>>>>>> I agree if you want to get an event when cache missed with the 
>>>>>> current uffd
>>>>>> definitions and when pre-population is forbidden, then MISSING 
>>>>>> trap is
>>>>>> required.  That is, with/without the need of UFFDIO_COPY being 
>>>>>> available.
>>>>>>
>>>>>> Do I understand it right that UFFDIO_COPY is not allowed in your 
>>>>>> case, but
>>>>>> only write()?
>>>>>
>>>>> No, UFFDIO_COPY would work perfectly fine.  We will still use write()
>>>>> whenever we resolve stage-2 faults as they aren't visible to UFFD. 
>>>>> When a
>>>>> userfault occurs at an offset that already has a page in the cache, 
>>>>> we will
>>>>> have to keep using UFFDIO_CONTINUE so it looks like both will be 
>>>>> required:
>>>>>
>>>>>    - user mapping major fault -> UFFDIO_COPY (fills the cache and 
>>>>> sets up
>>>>> userspace PT)
>>>>>    - user mapping minor fault -> UFFDIO_CONTINUE (only sets up 
>>>>> userspace PT)
>>>>>    - stage-2 fault -> write() (only fills the cache)
>>>>
>>>> Is stage-2 fault about KVM_MEMORY_EXIT_FLAG_USERFAULT, per James's 
>>>> series?
>>>
>>> Yes, that's the one ([1]).
>>>
>>> [1]
>>> https://lore.kernel.org/kvm/20250618042424.330664-1- 
>>> jthoughton@google.com
>>>
>>>>
>>>> It looks fine indeed, but it looks slightly weird then, as you'll 
>>>> have two
>>>> ways to populate the page cache.  Logically here atomicity is indeed 
>>>> not
>>>> needed when you trap both MISSING + MINOR.
>>>
>>> I reran the test based on the UFFDIO_COPY prototype I had using your
>>> series [2], and UFFDIO_COPY is slower than write() to populate 512 MiB:
>>> 237 vs 202 ms (+17%).  Even though UFFDIO_COPY alone is functionally
>>> sufficient, I would prefer to have an option to use write() where
>>> possible and only falling back to UFFDIO_COPY for userspace faults to
>>> have better performance.
>>
>> Just so I understand correctly: we could even do without UFFDIO_COPY for
>> that scenario by using write() + minor faults?
> 
> We still need major fault notifications as well (which we were 
> accidentally generating until this version).  But we can resolve them 
> with write() + UFFDIO_CONTINUE instead of UFFDIO_COPY.

We had a conversation about that at the guest_memfd sync today:

Q: Is it possible from the API point of view to support MISSING 
notifications without supporting UFFDIO_COPY?

A: The manpage [1] says on UFFDIO_REGISTER_MODE_MISSING that "the page 
fault is resolved from user-space by either an UFFDIO_COPY or an 
UFFDIO_ZEROPAGE ioctl", but I don't think it's actually enforced 
anywhere in the code.

Q: UFFDIO_COPY is supposed to provide atomic semantics, while write() + 
UFFDIO_CONTINUE does not. Is it a problem?

A: It isn't a problem for the particular Firecracker use case because 1) 
vCPUs can be prevented from seeing partially populated pages in the 
cache via KVM userfault intercept [2] and 2) we do not use other 
userspace mappings.  However, as James pointed, in the general case, 
other actors may observe partially populated pages via other userspace 
mappings.

[1] https://man7.org/linux/man-pages/man2/userfaultfd.2.html
[2] 
https://lore.kernel.org/kvm/20250618042424.330664-1-jthoughton@google.com

> 
>>
>> But what you are saying is that there might be a performance benefit in
>> using UFFDIO_COPY for userspace faults, to avoid the write()+minor fault
>> overhead?
> 
> UFFDIO_COPY _may_ be faster to resolve userspace faults because it's a 
> single syscall instead of two, but the amount of userspace faults, at 
> least in our scenario, is negligible compared to the amount of stage-2 
> faults, so I wouldn't use it as an argument for supporting UFFDIO_COPY 
> if it can be avoided.
> 
>>
>> -- 
>> Cheers
>>
>> David
> 


