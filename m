Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A6BFCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 11:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F415C6B0005; Wed, 13 May 2026 07:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA886B008A; Wed, 13 May 2026 07:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB95D6B008C; Wed, 13 May 2026 07:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB5866B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:49:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9BE641C19F7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:49:21 +0000 (UTC)
X-FDA: 84762226122.23.7BA2539
Received: from out203-205-221-205.mail.qq.com (out203-205-221-205.mail.qq.com [203.205.221.205])
	by imf18.hostedemail.com (Postfix) with ESMTP id 25ED11C0013
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:49:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=zVUopWNw;
	spf=pass (imf18.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.205 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778672959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIHzgVbli95YXrDt4r2xvjhCuHt4WOuS+wHLnD1yRAk=;
	b=aihH13V5Uf7gfCBwkAeIHgt7VcAgUI2gjBnEj6a8Aa3jaxqw6sf9n+1sN/llPYeMNuyHfo
	ipn1lgbwjGz1WT2pKfyeVAHMmhiBkevQBlHiiiFEdfUJ/jxUiZ/W+XwzTzNvWQPXdMbbiO
	RIbb1h98nbHHGWJIj2sdgpc74K1GTEQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=zVUopWNw;
	spf=pass (imf18.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.205 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778672959; a=rsa-sha256;
	cv=none;
	b=ATmT6Dk9xjF4rKGEvNxM0eXCJbGKG2Wu3S0eyeJHH+pWQtE9ZvbsKYw6bzBXj+Sk9eIf6F
	hWLaNyFN8JvbSeatvHQIoVd2bfXC4105QoM/Mdy8FSb9JgzEy/Ly2YIIG5ZQas7p8m0Ggl
	s3fho048Z79g7BT9PTmpHgLqokZf3W0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778672952; bh=uIHzgVbli95YXrDt4r2xvjhCuHt4WOuS+wHLnD1yRAk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=zVUopWNw9aNcwtzywGGC5TZY7DuATPUgX4dfwLibSvuRYOeNYMFdFqFkFqYs+BoVs
	 kwNDvg0dH87LkDvePMdiFS4LxwyPeq+LTt/GVuSpUbJbQnD8Rw2al70hayEX+5C8g3
	 ukIvPJ60btTWN9G2lqx8bn6AXg4nCWyqqkl13KIg=
Received: from [10.46.141.45] ([36.112.3.68])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id C4A0F68C; Wed, 13 May 2026 19:49:10 +0800
X-QQ-mid: xmsmtpt1778672950tq981p33l
Message-ID: <tencent_802CA0B9BE9F8F159FE6913C7047906E1E09@qq.com>
X-QQ-XMAILINFO: MRMtjO3A6C9XRE5vbLvVJpWGcifG9l5x0ln1XGQ5ij8pr4bXVPr1TdcKBYayMX
	 eUQTsFddOJYgx8GeiaYnvVX5tkQPII68Ti9BxdcnVctSLx8ufX5SAGBUtguBoe4VTKwlN9GqEOfM
	 FFCorW6oTpL5Z8Sgi8TVNTtnrNhGTtfADcbYmmqpvI07QSe8qB8TgQjRIN+PtbRlEC2I7hehN1s+
	 Jho2YNdsh+Iv2uN3X6XPYfbHoRIc4KmOJ7/dlasRgIniTrG5+Icocybb3KH48TOsLPUwFDK2n16A
	 +I1qTvzzMrePlrd4jSf7N6Kz29hM5slotiKC9snrQLNgDx+8eTI+b7+hfh4D8ZWyCNwVcsdt77fP
	 S+5pr4pJvMIs5JpmfiyKUVDArvlLQuSe0XP3QrMDcsZzF1LpoVaIOtmVJwTZXx5r9BLoR8Dp5qdP
	 roRHqmznXP7cU5BGE0nF2Zd5WtzvaEAhA7zjotWe2qNq4uC5SNbH5/qDQ6L74tzMF4BVd9o5p2Kf
	 teG+3HJ6T3tUEGHTdxE6Ms7W3ZlrPF48otKboWcdGa+nv6QhBqyHW457A7wCgiy1t8uHf3NOJMhK
	 xsRv+ivkVoN6QhwYd9zvOj/0BYtJBdft4hLsaqq/bjlfdAkpv5eMKZ+ASFjER7s1sQ0DSWtjfhlz
	 hbDB9eBDSNxpbb1REchXH4Yz/YYs5obINmiQt0FExJtL4BCNuh5sdZrt3SpKwDOOKNsy2tzTCSdV
	 otuMLbkq70coFnBtlQlUXV4oo3GJYIs/280E8yc4/6HStfQTUO8GCMk+XH0cpalFyGhIV03tqpMq
	 dJR+Wae7Iw6trUR9NPPG7bXcjM0jtSaHR+w5mkDS0lEBeyUXCXRX1rufclHoocQnkXUwA3sA3fJW
	 Q5iJV1eHq9I16oE39eqbszEbbjCPK5jWUCk9oWdz+UsY5O0c7e6g1ap+LxjGgmM6SCktO9sdQaX+
	 WNJHiNsmmMLFRblk0E5r6noeRXyoOwBkUeNidzBRsvBg7XLGofVBdcyELtFGrZYgqsDaIC5FErxh
	 rycUkzxkrY6P64q99S1/51hMPz4Vk=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-OQ-MSGID: <3fe8e232-66c0-4b41-83ee-b5b27c9c175c@qq.com>
Date: Wed, 13 May 2026 19:49:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mremap: unmap full fixed target for multi-VMA moves
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <tencent_863C8A01F3C81EBA238F375B16065CBACF08@qq.com>
 <agHmO4i4YUhs3cSG@lucifer>
 <CAG48ez1sLtSKVQLHbLO5usBgMgjyOGhbX29pKEfku4Ht05HffA@mail.gmail.com>
 <agH1ZSdX_7QF8P_I@lucifer>
 <CAG48ez17evhhcoDKF6AoPqzYZwGuFCkVAsc-0bBzevf0LHYNxA@mail.gmail.com>
 <agH7ONBSX7XLzS6q@lucifer>
 <CAG48ez0y3N9uEOzvr4N85Js4XN1fh4JiUFjW=PQB2UZ_5t1R4A@mail.gmail.com>
 <agICeiIEshWf-1xa@lucifer>
 <tencent_B49EC91555E7B93CE646566E0A2DBEB9BE09@qq.com>
 <agMyDHx5MxR0igFY@lucifer>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <agMyDHx5MxR0igFY@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 25ED11C0013
X-Stat-Signature: 6cisspmsu959jy19qhfagymyihis7tif
X-HE-Tag: 1778672958-908689
X-HE-Meta: U2FsdGVkX18pufXVWJpCCW3qZtls9Me8w856RSXgEZBuut6pTG5NIMog1mslav4B+jTY/6dJbe/yBEJ0c3iNqgBqhrYhUdiMs3aeySz2EoPoX6fwt2vYwcfC9vjYn5LMQ88LGosvzypU1AOdke0xixC57ot/8hMenyuIVDaduylHbuD1ZvRWA7YyfbWb7PSx4eefU5UHVQ35B2yV9DNkfA64Eupgwk1gn7v50GuHxM5kNglLsMLokWknpg2w9TOI4Rnp6GSljLmEcxo84hbu3Ajg1/7diQ268spPpyRSHarHsNpyG5fE20Th5hFtFui55i7TX85U8JK4uchKmgQegSKSBZptAb8J5zZKgw81YnPK8GHXXdigzl05jpQlTFZDYHttoF9Bx2TzMm5vAgnQjPS6RbhgCxHr4vD6P1Q/sxpQKQWzlIOF2yd6SetmC/jB9VUzi0K8i3sfD1MbFB7X9KctiUuN85LCQrlVANCpMDey0ecDXMmlCeviFAa1zvfzT7IfqcY0NRAWr/SpBbDkAWt9ZGNPxdBxTBPufpwMkp4EqhM8Nj5tsA8fvNMb86fyrIceFKE3Bs0vFns0wf3w7k5a42Nhc+t9WG8cRtiHTu8ORcrZ4Q/3foj6dDW7AJq6/28IHx4DLtERL98hEb/UM6JhvMjMOMQoMPMFY4MdoTpFm7NoRCi+GG41ZlddXLVx1IYGQxwNPM9JLOCH5YxjSSo5YnQNSGetVf3nC59+EESUVoq80YUU37eCaSbrRgZbS4PUPrbxZQkIamtoCkRQajaMd38BPw5WWNxfGwcbTU0A1LQ92d9SrQBA0b2/DzPN05uiQF6SL+CMx18FUnV66RWsCYFVPHy+NxEBWtSvdELutfM6xEnbOBp9sNCakf3gs0S7kS7Vv2YYVrlVoUbUlcszBlcFDBFm4a2Ehth4gsp69jvCGxeDcZ43Mj1TrJIEjZrgmAwMXWme/qcJXNs
 h7831/z8
 +2wYUMIJtERmzaVG4e53etIOQqdcr1X6dUkPNfRbdSpM+Zs774O+bqn6guijXvvxdZ9bY6aBVMXEZhX7Gs/Am1R1p8ZQNLu+ndPad6ivLFhQHpTzdaEw4twqygQxUmQiZeNjDYtGuMxRwIpeX28k7Uf/U/ng0iea+PSr0HR+R1ppZ9gRQWe/ohL5G57HAP65B6pPdExNdX1LTSlDSw72ArVdTZoGFG3WQpR8eLYAbLQi4R815zfoTd5ZHXTzua3dg2axIgV/bwiIXVYpKnqKnVJRmjbfxjk+W9BrhzZuDENV6lkjE3uCC7NKkEj/EW8VQDwPQne5FW8HDKAzPVETr7dyn0Kysij01PbbD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/12/2026 9:59 PM, Lorenzo Stoakes wrote:
> On Tue, May 12, 2026 at 03:24:24PM +0800, Fujunjie wrote:
>>
>>
>> On 5/12/2026 12:30 AM, Lorenzo Stoakes wrote:
>>> Yeah let's go with that then I think :)
>>
>>
>> Thanks Lorenzo and Jann.
>>
>> I agree that the patch as posted goes in the wrong direction by treating
>> source gaps as ranges that should be propagated to the destination.  Please
>> drop this patch.
>>
>> If disallowing source gaps in this multi-VMA move path still sounds right,
>> I can look into a v2/new patch that rejects sparse source ranges up front
>> instead.
> 
> Sorry I really want to think about this a little more + make sure the
> semantics are sane, so I'd rather take a look at this myself.
> 
> I do really hate to take something away from newer contributors but in this
> case things are quite fiddly so I want to make sure everything's correct :)
> 
>>
>> Thanks,
>> fujunjie
>>
> 
> Thanks, Lorenzo

No problem at all, that makes sense :)


