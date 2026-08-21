Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E91E9C5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E9B26B00A0; Fri, 21 Aug 2026 10:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C12F6B00A1; Fri, 21 Aug 2026 10:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2F56B00A2; Fri, 21 Aug 2026 10:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF5E86B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:19:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DB7B1C00D3
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:19:04 +0000 (UTC)
X-FDA: 85125483408.03.5289BDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9E5C0C0009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:19:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EjZSYAWO;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787321942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2XbnGzR4oklypPgE+Viv5JNUn/D8iY5cwkY2Kqvw4E=;
	b=bRU5sSjGCVqiVeAbyMCGLFgLV7HQ9Z1UzUqDrYhzyHUhZcXK1RZJCCG4dlVQ8XIPWyzcY1
	z48/gwhTvxxVvuLCNEc2cHhFhEmv5na3zY3DFKFw1B7hNia5bS/QL9CdZvL74SNdLLavVR
	YCJMEEKZxUHmtmZl/44fQBR64xN00Y0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EjZSYAWO;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787321942;
	b=FIePNWuWIzpfN+2byzzRlSRMMDba5BweAQWZuRJMJSXDaIpVPUv4pkK4Iq9Utl+7bvNioI
	4s31iZq26QLSWORg9zcpmbGyg18WXZY9HH0L04b4CbllKYVzqaU/+BqGArcp9Bzu3Z/sW9
	LS7qpZ7ztK8kdPe5mCjTH//OEEPfEpI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ECF1843384;
	Fri, 21 Aug 2026 14:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841651F000E9;
	Fri, 21 Aug 2026 14:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787321941;
	bh=u2XbnGzR4oklypPgE+Viv5JNUn/D8iY5cwkY2Kqvw4E=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=EjZSYAWO28454RqSV7v89nBk8+YcOGyf5apbjjM7L2GvqAzQasrzCMMMPrPqh6tN2
	 kRkIwcYM3KXd4a+eGEgaAWwNlI2c8Y/h0qkgIHqXQpCSlALAxzpd0dvHnfUQMALz9G
	 Ru6tS0xXakGh3n3iyyQu9LPwr0J3OsSMOLtLQMOlDhR1sNYJRUWUQcBDQ8gNrGZAax
	 ILBqWcxTxG9RrLGzzIIAaUFx5QDCqQn8LBEJIBTzQLpdUcdLNhT+sUmmzLFINod50N
	 uHQSN1V8PHPDs2C3P8ltB4+y8NhkRl3G1uNFasRFtBVjD6wXe1GDFLFCotx11glIuO
	 KpEGF8Pbq8DDA==
Message-ID: <dd8c34a9-0e09-453b-88e1-0a5511816627@kernel.org>
Date: Fri, 21 Aug 2026 16:18:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
To: Jann Horn <jannh@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>, Jeff Xu
 <jeffxu@google.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
 Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com>
 <741a833d-6889-4ee6-9322-d6a3a8b95893@kernel.org>
 <CAG48ez2Ngo3=VtyykXY6ynVzGwA8px-p4zV3V6U=YfgV-Hy4BA@mail.gmail.com>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAG48ez2Ngo3=VtyykXY6ynVzGwA8px-p4zV3V6U=YfgV-Hy4BA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rzxm1q9q3ah8s1fojohj8pspmi4t74r9
X-Rspamd-Queue-Id: 9E5C0C0009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787321942-394071
X-HE-Meta: U2FsdGVkX18FTxM7fuc8beK6G5eyfcjf32s0G/iqY/FY937VTQT7R2JAVbcdIay0bVOcombGTg8xbpqXWrzRWkpXdCCNM66jMSeoz4J7l6kN735B5IA3ljKc921KxtMNdACUEwIrZls7eLn1LiDraaqL6w6E7+2w8g8k69wOV63wo63X1/gR71tgtRQ58iSopMps/yr3vDg3MZua+iukSfF8ruB6xirA1Qv4pBOkMdl0QNkmtGblRuX+iiSzE0MBwZXDV82QuiLkjgfGZHqCthWPQCO9WiRRVu5BfcnAQlqlhfTxFfS4g10GybnHbwkCj5rZZ9oC4/wTVW+jRu7eDNdc+a5Z7vyjbvAMzxO+2i0KaoNdabHrV2OUZg/bpt/ejCDlEn3+Zi/PWoXxtpe6Wha1dZuB1y6VuPJqbHc1vNJ8Qi0PFOLQI48dPPiD4iOEz7NSPdKeJKpBjQ/KWMIQMjvnVmt95HWcZh5jILwRrepZv2lLuZvGWfLK4Z4it7x6/xfuHgUOoAGqoitJHC2WuUjl61z6Br3hJg1WeGQ7y9BDaGQZzeFqZPqeSybv3K7jOyLJ8rtiHsZzpgWcRE4D0t0/Yj5HWu8VimlJvAtVbuX+FrjVM5imZ9/oprlQv04saIxfrLpJRip4OX0STxQubKxOA9p55IA3o12NCZuuqYhiummkdjGjWFoIFDxCY82IFsDrWXrMJ9f79QO1i+qbR580UlG72gFkVI0Sf4EKx/T6/cvrD8/Y6fHRJzU5PxxUKqxFRgszZgFevle+syWh0JUxduAOO5DRq5BakMt9e5bvlPR2u9uL/WtETjsfEhuGxQtae0ejDQ8NdMdSHOCuKU3bbwW14j6uDzgva/ZPmbRD49DD9tWkvCNGHm8hytGcpzhAELdVZ+zVP9P6U/6X8mrkzytruwjCOg6H4Mf4jpLJmiI1usbqdKzJzrBAFCmvPZcoofmjYbq5K9YBe2l
 caPA5KpJ
 KMTaf7F9v9A/Oanq9kKjXlz+fl11hHG7vXcod8moPdCUUw1iT/NI4bHJTJTPsfIbDZn5AZwdeOHrtl5se5BPza0tqTeeTKVwe0pb5O+M3vpcXw1XkJo6SM/SsnCheDz5LVWpXHukUl3pkY/JMMgoydDny7V3fOtFIG4c0NQIVu6oRJyW7K+fU56TyHiELh9q+9DAS1VDYzP8u7OfFT0SUn5SdqzSxbz5nVqH2yr0QeBTTZEZS+IASDTJ4JgAPtzJbPnhuGhTSiQM5Dd5AENaORds2GYm83XrP9W0QLYj+x/3Al/m3Ir9n6bZ5ghxmGfR8ZriUG/sJKOViIiL9ipSBo8KijPVVaYQmK2zpTesXDJT8NcZQ5CTud214i1N+y+e7/YIf3pxHTJreKjmK4zbTk/mdcgG/Mrljl3Rz77oJvHBFIBydfA7gVVwFGE/0+JDu3h25dInIy28SLA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 20:44, Jann Horn wrote:
> On Thu, Aug 20, 2026 at 7:22 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>> On 8/18/26 21:51, Jann Horn wrote:
>>> If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently have no
>>> good opportunity to block a process from overwriting read-only code in its
>>> own address space through FOLL_FORCE writes via /proc/self/mem.
>>> The security_ptrace_access_check() LSM hook is bypassed when a process
>>> opens /proc/self/mem because this is considered "introspection".
>>>
>>> This causes a hole in SELinux EXECMEM enforcement, which tries to ensure
>>> that a process cannot create executable anonymous pages.
>>>
>>> PROC_MEM_FORCE_PTRACE prevents that and ensures that such FOLL_FORCE
>>> accesses are only possible when the LSM allows ptrace() attachment; but it
>>> is unclear how quickly PROC_MEM_FORCE_PTRACE can be deployed in
>>> environments running lots of third-party code, such as Android.
>>>
>>> So, introduce a new LSM hook that can forbid FOLL_FORCE specifically for
>>> such "introspective" accesses.
>>>
>>> Signed-off-by: Jann Horn <jannh@google.com>
>>> ---
>>>  fs/proc/base.c                |  6 ++++++
>>>  include/linux/lsm_hook_defs.h |  1 +
>>>  include/linux/security.h      |  6 ++++++
>>>  security/security.c           | 15 +++++++++++++++
>>>  4 files changed, 28 insertions(+)
>>>
>>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>>> index bec6197329dc..3dfaef49bb70 100644
>>> --- a/fs/proc/base.c
>>> +++ b/fs/proc/base.c
>>> @@ -851,6 +851,8 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
>>>  /* private_data for proc_mem_operations */
>>>  struct mem_private {
>>>       struct mm_struct *mm;
>>> +     /* Was the ptrace access check bypassed due to introspection? */
>>> +     bool introspection;
>>>  };
>>>
>>>  static int mem_open(struct inode *inode, struct file *file)
>>> @@ -864,12 +866,14 @@ static int mem_open(struct inode *inode, struct file *file)
>>>       priv->mm = proc_mem_open(inode, PTRACE_MODE_ATTACH);
>>>       if (IS_ERR_OR_NULL(priv->mm))
>>>               return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
>>> +     priv->introspection = priv->mm == current->mm;
>>
>> Is the feat that the fd could be passed to someone else that would then not be
>> detected as introspection?
> 
> Yes, exactly, that's the primary reason why I did it this way.

Okay, would "opened_by_owner" or something like that be clearer? At least
"introspection" is less intuitive for me.

-- 
Cheers,

David


